Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B366B2F9B4E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 09:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387815AbhARIcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 03:32:01 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:59914 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726488AbhARIcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 03:32:00 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=abaci-bugfix@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UM4i7QI_1610958664;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:abaci-bugfix@linux.alibaba.com fp:SMTPD_---0UM4i7QI_1610958664)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Jan 2021 16:31:13 +0800
From:   Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
To:     jhs@mojatatu.com
Cc:     xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
Subject: [PATCH] taprio: boolean values to a bool variable
Date:   Mon, 18 Jan 2021 16:31:02 +0800
Message-Id: <1610958662-71166-1-git-send-email-abaci-bugfix@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warnings:

./net/sched/sch_taprio.c:393:3-16: WARNING: Assignment of 0/1 to bool
variable.

./net/sched/sch_taprio.c:375:2-15: WARNING: Assignment of 0/1 to bool
variable.

./net/sched/sch_taprio.c:244:4-19: WARNING: Assignment of 0/1 to bool
variable.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>
---
 net/sched/sch_taprio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 6f77527..8287894 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -241,7 +241,7 @@ static struct sched_entry *find_entry_to_transmit(struct sk_buff *skb,
 				/* Here, we are just trying to find out the
 				 * first available interval in the next cycle.
 				 */
-				entry_available = 1;
+				entry_available = true;
 				entry_found = entry;
 				*interval_start = ktime_add_ns(curr_intv_start, cycle);
 				*interval_end = ktime_add_ns(curr_intv_end, cycle);
@@ -372,7 +372,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 	packet_transmit_time = length_to_duration(q, len);
 
 	do {
-		sched_changed = 0;
+		sched_changed = false;
 
 		entry = find_entry_to_transmit(skb, sch, sched, admin,
 					       minimum_time,
@@ -390,7 +390,7 @@ static long get_packet_txtime(struct sk_buff *skb, struct Qdisc *sch)
 		if (admin && admin != sched &&
 		    ktime_after(txtime, admin->base_time)) {
 			sched = admin;
-			sched_changed = 1;
+			sched_changed = true;
 			continue;
 		}
 
-- 
1.8.3.1

