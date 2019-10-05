Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1E9CCB85
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 18:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387452AbfJEQ4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 12:56:39 -0400
Received: from smtprelay0113.hostedemail.com ([216.40.44.113]:55259 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729348AbfJEQ4j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 12:56:39 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave05.hostedemail.com (Postfix) with ESMTP id 7EE181828AE3A;
        Sat,  5 Oct 2019 16:46:56 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay08.hostedemail.com (Postfix) with ESMTP id 7E52E182CED28;
        Sat,  5 Oct 2019 16:46:54 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:3872:4250:5007:6261:6742:6743:9165:10004:10848:11026:11473:11658:11914:12048:12296:12297:12438:12555:12895:13069:13311:13357:14181:14384:14394:14721:21080:21451:21627:30034:30054:30090,0,RBL:47.151.152.152:@perches.com:.lbl8.mailshell.net-62.8.0.100 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: flesh63_198d491a4e5f
X-Filterd-Recvd-Size: 3579
Received: from joe-laptop.perches.com (unknown [47.151.152.152])
        (Authenticated sender: joe@perches.com)
        by omf15.hostedemail.com (Postfix) with ESMTPA;
        Sat,  5 Oct 2019 16:46:50 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
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
        clang-built-linux@googlegroups.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH 1/4] net: sctp: Rename fallthrough label to unhandled
Date:   Sat,  5 Oct 2019 09:46:41 -0700
Message-Id: <2e0111756153d81d77248bc8356bac78925923dc.1570292505.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1570292505.git.joe@perches.com>
References: <cover.1570292505.git.joe@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fallthrough may become a pseudo reserved keyword so this only use of
fallthrough is better renamed to allow it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sctp/sm_make_chunk.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index e41ed2e0ae7d..48d63956a68c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2155,7 +2155,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_SET_PRIMARY:
 		if (ep->asconf_enable)
 			break;
-		goto fallthrough;
+		goto unhandled;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */
@@ -2166,11 +2166,11 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_FWD_TSN_SUPPORT:
 		if (ep->prsctp_enable)
 			break;
-		goto fallthrough;
+		goto unhandled;
 
 	case SCTP_PARAM_RANDOM:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		/* SCTP-AUTH: Secion 6.1
 		 * If the random number is not 32 byte long the association
@@ -2187,7 +2187,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_CHUNKS:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		/* SCTP-AUTH: Section 3.2
 		 * The CHUNKS parameter MUST be included once in the INIT or
@@ -2203,7 +2203,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_HMAC_ALGO:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		hmacs = (struct sctp_hmac_algo_param *)param.p;
 		n_elt = (ntohs(param.p->length) -
@@ -2226,7 +2226,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 			retval = SCTP_IERROR_ABORT;
 		}
 		break;
-fallthrough:
+unhandled:
 	default:
 		pr_debug("%s: unrecognized param:%d for chunk:%d\n",
 			 __func__, ntohs(param.p->type), cid);
-- 
2.15.0

