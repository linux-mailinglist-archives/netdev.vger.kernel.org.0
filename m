Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46C1D7B8F4
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 07:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbfGaFEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 01:04:42 -0400
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:52574 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728822AbfGaFEm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 01:04:42 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id 2C7AB18010BC8;
        Wed, 31 Jul 2019 05:04:40 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1437:1534:1541:1711:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3353:3865:3866:3867:3870:3871:3872:4250:4321:5007:6261:9165:10004:10848:11026:11473:11658:11914:12296:12297:12438:12555:12895:13069:13311:13357:14181:14384:14394:14721:21080:21451:21627:30034:30054:30090,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: straw28_45b1536d17222
X-Filterd-Recvd-Size: 2733
Received: from joe-laptop.perches.com (cpe-23-242-196-136.socal.res.rr.com [23.242.196.136])
        (Authenticated sender: joe@perches.com)
        by omf16.hostedemail.com (Postfix) with ESMTPA;
        Wed, 31 Jul 2019 05:04:38 +0000 (UTC)
From:   Joe Perches <joe@perches.com>
To:     Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sctp: Rename fallthrough label to unhandled
Date:   Tue, 30 Jul 2019 22:04:37 -0700
Message-Id: <e0dd3af448e38e342c1ac6e7c0c802696eb77fd6.1564549413.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
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
index 36bd8a6e82df..3fdcaa2fbf12 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -2152,7 +2152,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 	case SCTP_PARAM_SET_PRIMARY:
 		if (net->sctp.addip_enable)
 			break;
-		goto fallthrough;
+		goto unhandled;
 
 	case SCTP_PARAM_HOST_NAME_ADDRESS:
 		/* Tell the peer, we won't support this param.  */
@@ -2163,11 +2163,11 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
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
@@ -2184,7 +2184,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_CHUNKS:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		/* SCTP-AUTH: Section 3.2
 		 * The CHUNKS parameter MUST be included once in the INIT or
@@ -2200,7 +2200,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
 
 	case SCTP_PARAM_HMAC_ALGO:
 		if (!ep->auth_enable)
-			goto fallthrough;
+			goto unhandled;
 
 		hmacs = (struct sctp_hmac_algo_param *)param.p;
 		n_elt = (ntohs(param.p->length) -
@@ -2223,7 +2223,7 @@ static enum sctp_ierror sctp_verify_param(struct net *net,
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

