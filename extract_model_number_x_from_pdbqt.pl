#!/usr/bin/perl -w 
#
#  get the model number X (default 1) from pdbqt file (such as autodock output). 
#  Written by V Kairys
#  Life Sciences Center, Vilnius University
#
use strict;
use warnings;
use Getopt::Std;

die "Usage: $0 -f pdbqtfile -n ModelNumber\n" if (@ARGV==0);

my %options=();
getopts("f:n:",\%options);
my $pdbf=$options{f};
my $number=$options{n};
unless( defined $number){
    $number=1; #default
}
#
(my $root = $pdbf) =~ s/(.+)\.[^.]+$/$1/; #remove extension
my $outfile="$root" . "_" . "$number" . ".pdbqt";
#die "no such file $flexf" unless (-e $flexf);
die "no such file $pdbf" unless (-e $pdbf);
#

my $currmodel="-100";
print "input file $pdbf , ModelNo $number, output file $outfile\n";
open(INPFILE,"<$pdbf") or die "Error while opening $pdbf: $!\n";
open(OUTFILE,">$outfile") or die "Error while opening $outfile: $!\n";
my $printline=0;
while(<INPFILE>){
	if(/^MODEL/){ 
           chomp; my @tmp=split;
           $currmodel=$tmp[1];
          if($currmodel==$number){
            print "required model #$number found!\n";
            $printline=1;
            next;
            }
    }
    if($printline and /^ENDMDL/){
        last;
    }
    print OUTFILE $_ if $printline;
    #printlines until the next ENDMDL is encountered
}
close(OUTFILE);
close(INPFILE);
print "the resulting file written to $outfile\n";

