Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F158E322D0E
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:03:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhBWPB7 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 23 Feb 2021 10:01:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:14743 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229886AbhBWPB5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Feb 2021 10:01:57 -0500
IronPort-SDR: Y5BPblMfp7qeqVsbJp7nBR2SXs+fx8uAM9lNACv8WwXHb+TL6zvlc2O9wWgEZ/5lGiPJ4IsUa3
 b9dSjfrCLotg==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="184942248"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="184942248"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 07:01:16 -0800
IronPort-SDR: cLSPmfNHa3iCizbtV7UOseFOoudYwdiCxvO85reXnvsywvIYGA+JUrBUTt0rVh1EXVVt1T47b2
 k44ICC7O9TeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="390920095"
Received: from irsmsx602.ger.corp.intel.com ([163.33.146.8])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2021 07:01:15 -0800
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 irsmsx602.ger.corp.intel.com (163.33.146.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 15:01:15 +0000
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.2106.002;
 Tue, 23 Feb 2021 15:01:15 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
Subject: RE: [PATCH bpf-next v2 2/4] selftests/bpf: expose and rename debug
 argument
Thread-Topic: [PATCH bpf-next v2 2/4] selftests/bpf: expose and rename debug
 argument
Thread-Index: AQHXCdQCvMz9NzUmjUC1UzIZ5SACraplz8WAgAAFUHA=
Date:   Tue, 23 Feb 2021 15:01:14 +0000
Message-ID: <8d52ed42f94346889fb0b5534d123a39@intel.com>
References: <20210223103507.10465-1-ciara.loftus@intel.com>
 <20210223103507.10465-3-ciara.loftus@intel.com>
 <20210223143939.GA51139@ranger.igk.intel.com>
In-Reply-To: <20210223143939.GA51139@ranger.igk.intel.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> On Tue, Feb 23, 2021 at 10:35:05AM +0000, Ciara Loftus wrote:
> > Launching xdpxceiver with -D enables what was formerly know as 'debug'
> > mode. Rename this mode to 'dump-pkts' as it better describes the
> > behavior enabled by the option. New usage:
> >
> > ./xdpxceiver .. -D
> > or
> > ./xdpxceiver .. --dump-pkts
> >
> > Also make it possible to pass this flag to the app via the test_xsk.sh
> > shell script like so:
> >
> > ./test_xsk.sh -D
> 
> This doesn't work for me. Not a shell programming expert, but seems like
> my shell doesn't understand that dump-pkts is a variable.
> 
> $ sudo ./test_xsk.sh -D
> ./test_xsk.sh: line 82: dump-pkts=1: command not found
> 
> If I do:
> 
> diff --git a/tools/testing/selftests/bpf/test_xsk.sh
> b/tools/testing/selftests/bpf/test_xsk.sh
> index cb8a9e5c34ff..378720e22877 100755
> --- a/tools/testing/selftests/bpf/test_xsk.sh
> +++ b/tools/testing/selftests/bpf/test_xsk.sh
> @@ -79,7 +79,7 @@ do
>         case "${flag}" in
>                 c) colorconsole=1;;
>                 v) verbose=1;;
> -               D) dump-pkts=1;;
> +               D) dump_pkts=1;;
>         esac
>  done
> 
> @@ -136,7 +136,7 @@ if [[ $verbose -eq 1 ]]; then
>         VERBOSE_ARG="-v"
>  fi
> 
> -if [[ $dump-pkts -eq 1 ]]; then
> +if [[ $dump_pkts -eq 1 ]]; then
>         DUMP_PKTS_ARG="-D"
>  fi
> 
> Then it's fine.

Thanks for catching this Maciej. My shell didn't complain like yours, however with this naming the flag wasn't propagating to the app for me.
Switching to 'dump_pkts' as you suggested solves both problems, so I'll update that in the v3.

> 
> >
> > Signed-off-by: Ciara Loftus <ciara.loftus@intel.com>
> > ---
> >  tools/testing/selftests/bpf/test_xsk.sh    | 7 ++++++-
> >  tools/testing/selftests/bpf/xdpxceiver.c   | 6 +++---
> >  tools/testing/selftests/bpf/xsk_prereqs.sh | 3 ++-
> >  3 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/tools/testing/selftests/bpf/test_xsk.sh
> b/tools/testing/selftests/bpf/test_xsk.sh
> > index 91127a5be90d..870ae3f38818 100755
> > --- a/tools/testing/selftests/bpf/test_xsk.sh
> > +++ b/tools/testing/selftests/bpf/test_xsk.sh
> > @@ -74,11 +74,12 @@
> >
> >  . xsk_prereqs.sh
> >
> > -while getopts "cv" flag
> > +while getopts "cvD" flag
> >  do
> >  	case "${flag}" in
> >  		c) colorconsole=1;;
> >  		v) verbose=1;;
> > +		D) dump-pkts=1;;
> >  	esac
> >  done
> >
> > @@ -135,6 +136,10 @@ if [[ $verbose -eq 1 ]]; then
> >  	VERBOSE_ARG="-v"
> >  fi
> >
> > +if [[ $dump-pkts -eq 1 ]]; then
> > +	DUMP_PKTS_ARG="-D"
> > +fi
> > +
> >  test_status $retval "${TEST_NAME}"
> >
> >  ## START TESTS
> > diff --git a/tools/testing/selftests/bpf/xdpxceiver.c
> b/tools/testing/selftests/bpf/xdpxceiver.c
> > index 8af746c9a6b6..506423201197 100644
> > --- a/tools/testing/selftests/bpf/xdpxceiver.c
> > +++ b/tools/testing/selftests/bpf/xdpxceiver.c
> > @@ -58,7 +58,7 @@
> >   * - Rx thread verifies if all 10k packets were received and delivered in-
> order,
> >   *   and have the right content
> >   *
> > - * Enable/disable debug mode:
> > + * Enable/disable packet dump mode:
> >   * --------------------------
> >   * To enable L2 - L4 headers and payload dump of each packet on STDOUT,
> add
> >   * parameter -D to params array in test_xsk.sh, i.e. params=("-S" "-D")
> > @@ -340,7 +340,7 @@ static struct option long_options[] = {
> >  	{"copy", no_argument, 0, 'c'},
> >  	{"tear-down", no_argument, 0, 'T'},
> >  	{"bidi", optional_argument, 0, 'B'},
> > -	{"debug", optional_argument, 0, 'D'},
> > +	{"dump-pkts", optional_argument, 0, 'D'},
> >  	{"verbose", no_argument, 0, 'v'},
> >  	{"tx-pkt-count", optional_argument, 0, 'C'},
> >  	{0, 0, 0, 0}
> > @@ -359,7 +359,7 @@ static void usage(const char *prog)
> >  	    "  -c, --copy           Force copy mode\n"
> >  	    "  -T, --tear-down      Tear down sockets by repeatedly recreating
> them\n"
> >  	    "  -B, --bidi           Bi-directional sockets test\n"
> > -	    "  -D, --debug          Debug mode - dump packets L2 - L5\n"
> > +	    "  -D, --dump-pkts      Dump packets L2 - L5\n"
> >  	    "  -v, --verbose        Verbose output\n"
> >  	    "  -C, --tx-pkt-count=n Number of packets to send\n";
> >  	ksft_print_msg(str, prog);
> > diff --git a/tools/testing/selftests/bpf/xsk_prereqs.sh
> b/tools/testing/selftests/bpf/xsk_prereqs.sh
> > index ef8c5b31f4b6..da93575d757a 100755
> > --- a/tools/testing/selftests/bpf/xsk_prereqs.sh
> > +++ b/tools/testing/selftests/bpf/xsk_prereqs.sh
> > @@ -128,5 +128,6 @@ execxdpxceiver()
> >  			copy[$index]=${!current}
> >  		done
> >
> > -	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C
> ${NUMPKTS} ${VERBOSE_ARG}
> > +	./${XSKOBJ} -i ${VETH0} -i ${VETH1},${NS1} ${copy[*]} -C
> ${NUMPKTS} ${VERBOSE_ARG} \
> > +		${DUMP_PKTS_ARG}
> >  }
> > --
> > 2.17.1
> >
