Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AFA14C0BE
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 20:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgA1TNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 14:13:13 -0500
Received: from smtprelay0217.hostedemail.com ([216.40.44.217]:41667 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726002AbgA1TNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 14:13:12 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay06.hostedemail.com (Postfix) with ESMTP id 297A01801D7D4;
        Tue, 28 Jan 2020 19:13:10 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3865:3866:3867:5007:10004:10400:10848:11658:11914:12296:12297:12555:12760:13069:13161:13229:13311:13357:13439:14181:14394:14659:14721:21080:21212:21433:21627:21990:30054,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: kiss45_72c9af011f710
X-Filterd-Recvd-Size: 1472
Received: from XPS-9350.home (unknown [47.151.135.224])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Tue, 28 Jan 2020 19:13:08 +0000 (UTC)
Message-ID: <8f13c6144a9bd42a1bc5e281d77fb4bc53043e96.camel@perches.com>
Subject: [PATCH] sch_choke: Use kvcalloc
From:   Joe Perches <joe@perches.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 28 Jan 2020 11:12:03 -0800
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the use of kvmalloc_array with __GFP_ZERO to
the equivalent kvcalloc.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/sched/sch_choke.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_choke.c b/net/sched/sch_choke.c
index dba7037..a36974e 100644
--- a/net/sched/sch_choke.c
+++ b/net/sched/sch_choke.c
@@ -377,7 +377,7 @@ static int choke_change(struct Qdisc *sch, struct nlattr *opt,
 	if (mask != q->tab_mask) {
 		struct sk_buff **ntab;
 
-		ntab = kvmalloc_array((mask + 1), sizeof(struct sk_buff *), GFP_KERNEL | __GFP_ZERO);
+		ntab = kvcalloc(mask + 1, sizeof(struct sk_buff *), GFP_KERNEL);
 		if (!ntab)
 			return -ENOMEM;
 

