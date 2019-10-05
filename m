Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC94ACCB80
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387584AbfJEQwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:52:32 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:42622 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387450AbfJEQwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 12:52:31 -0400
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Oct 2019 12:52:30 EDT
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id 65A131802A365;
        Sat,  5 Oct 2019 16:46:52 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 51AC0181D33FB;
        Sat,  5 Oct 2019 16:46:50 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:960:973:982:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:4605:5007:6119:6261:6742:6743:7903:9036:9389:9592:10004:10848:11026:11657:11658:11914:12043:12291:12296:12297:12438:12555:12679:12683:12895:13069:13161:13229:13311:13357:13972:14096:14181:14384:14394:14721:21080:21433:21451:21627:30054,0,RBL:47.151.152.152:@perches.com:.lbl8.mailshell.net-62.14.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: swim99_ee203254c55
X-Filterd-Recvd-Size: 3433
Received: from joe-laptop.perches.com (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sat,  5 Oct 2019 16:46:46 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-sctp@vger.kernel.org
Cc:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Kan Liang <kan.liang@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Shawn Landden <shawn@git.icu>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        clang-built-linux@googlegroups.com,
        Jonathan Corbet <corbet@lwn.net>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 0/4] treewide: Add 'fallthrough' pseudo-keyword
Date:   Sat,  5 Oct 2019 09:46:40 -0700
Message-Id: <cover.1570292505.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 'fallthrough' pseudo-keyword to enable the removal of comments
like '/* fallthrough */'.

Add a script to convert the fallthrough comments.

The script can be run over any single file or treewide.

For instance, a treewide conversion can be done using:

$ git ls-files -- '*.[ch]' | \
  xargs scripts/cvt_style.pl -o --convert=fallthrough

This currently produces:

$ git diff --shortstat
 1839 files changed, 4377 insertions(+), 4698 deletions(-)

Example fallthrough conversion produced by the script:

$ scripts/cvt_style.pl -o --convert=fallthrough arch/arm/mm/alignment.c

a/arch/arm/mm/alignment.c
b/arch/arm/mm/alignment.c
@@ -695,8 +695,7 @@ thumb2arm(u16 tinstr)
 			return subset[(L<<1) | ((tinstr & (1<<8)) >> 8)] |
 			    (tinstr & 255);		/* register_list */
 		}
-		/* Else, fall through - for illegal instruction case */
-
+		fallthrough;	/* for illegal instruction case */
 	default:
 		return BAD_INSTR;
 	}
@@ -751,8 +750,7 @@ do_alignment_t32_to_handler(unsigned long *pinstr, struct pt_regs *regs,
 	case 0xe8e0:
 	case 0xe9e0:
 		poffset->un = (tinst2 & 0xff) << 2;
-		/* Fall through */
-
+		fallthrough;
 	case 0xe940:
 	case 0xe9c0:
 		return do_alignment_ldrdstrd;

Joe Perches (4):
  net: sctp: Rename fallthrough label to unhandled
  compiler_attributes.h: Add 'fallthrough' pseudo keyword for switch/case use
  Documentation/process: Add fallthrough pseudo-keyword
  scripts/cvt_style.pl: Tool to reformat sources in various ways

 Documentation/process/coding-style.rst |   2 +-
 Documentation/process/deprecated.rst   |  33 +-
 include/linux/compiler_attributes.h    |  17 +
 net/sctp/sm_make_chunk.c               |  12 +-
 scripts/cvt_style.pl                   | 808 +++++++++++++++++++++++++++++++++
 5 files changed, 855 insertions(+), 17 deletions(-)
 create mode 100755 scripts/cvt_style.pl

-- 
2.15.0
