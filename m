Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812126BABFF
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231838AbjCOJVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231851AbjCOJVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:21:20 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC002884F;
        Wed, 15 Mar 2023 02:21:10 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id p6so19399055plf.0;
        Wed, 15 Mar 2023 02:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678872069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u3vDu5GiFUlxMBd7wPvDcalQ/dhSSRjZ8k+14ffdWRs=;
        b=lgCbGTLuZKGvYG9yF0Azw/uTYJupPKDgDNSMVbCGy9fqiLkjcqwqj3HFBkZjXIu7MZ
         NcdOIJRQpC8YxYqbllRGgdIM6P6pQNupgvs69zL72DUdCrceN+CxWczKdQUbuaPHZfEv
         B9YQgvaxXvlbn4QjDqmUPLN77FOzEvgwZ9+2jNoHW/aFnZS0lyswXFaiEzdLPZiCa4TK
         J0yFYPROvIKord3hpPSX+3hSm4i4FcxhlrhMe8pKt5BfGwB6RICc07E3wBGZRxjqptRL
         wRwTAbweD3ysbxCpv44VVe7NZoKZI7/cTub6A79GsjVfam4l1wb+23xuEH6TvMQ2UCpy
         8GRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678872069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3vDu5GiFUlxMBd7wPvDcalQ/dhSSRjZ8k+14ffdWRs=;
        b=bZzgKPC2rcNST5GDu4fYNA6WNy3vIshoXDTd3OhC5GpVdwBOvv/FBYrdz08EmkzPy8
         IKmKt6KY58K0LVi8vEqaXIxrizc30UzBYOY4oYrUVyqL11/Q3kETs3yayojqVq8uo75B
         m1A47yyrulLJ90FMBYvQW47/ZrXYbhwej5BF/PLDrVGGvJpdu0TjW3Ea2ybjkQThfuT9
         pd4sFQBFAGPMwURAm1MJV3SJcxVdSXR6H+/GO3fWEza61JroHq+TQoQY92ZTcoN1nzCD
         r3oqAypRsDtrOECq3fo/pnhcyUZ0igXFuBzEaq4Xv9a86jUi3Ib2HoPuq5ZgyVCZmvjG
         flJQ==
X-Gm-Message-State: AO0yUKWd7/tF3oRmFdEdneyli0pODods4gGRGJsmp9YS3xcLgmaqQgtS
        wAa7X1IDV3Il+d7HW8D2IWA=
X-Google-Smtp-Source: AK7set9vbWfT61R3ECtfaC/IfTBgmozz3/kZYX+5aRmUOPoj8d0Vdgwr39olfAWmq3iSscslyW8CZA==
X-Received: by 2002:a05:6a20:698b:b0:cd:1808:87bb with SMTP id t11-20020a056a20698b00b000cd180887bbmr37702469pzk.7.1678872069493;
        Wed, 15 Mar 2023 02:21:09 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id n3-20020aa79043000000b005ae02dc5b94sm2971815pfo.219.2023.03.15.02.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 02:21:09 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     jbrouer@redhat.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v4 net-next 2/2] net: introduce budget_squeeze to help us tune rx behavior
Date:   Wed, 15 Mar 2023 17:20:41 +0800
Message-Id: <20230315092041.35482-3-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230315092041.35482-1-kerneljasonxing@gmail.com>
References: <20230315092041.35482-1-kerneljasonxing@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

In our production environment, there're hundreds of machines hitting the
old time_squeeze limit often from which we cannot tell what exactly causes
such issues. Hitting limits aranged from 400 to 2000 times per second,
Especially, when users are running on the guest OS with veth policy
configured, it is relatively easier to hit the limit. After several tries
without this patch, I found it is only real time_squeeze not including
budget_squeeze that hinders the receive process.

So when we encounter some related performance issue and then get lost on
how to tune the budget limit and time limit in net_rx_action() function,
we can separately counting both of them to avoid the confusion.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
v4:
1) also avoid the inconsistency by caching variables suggested by Eric.
2) add more details about the real issue happened on our servers
suggested by Jakub.

v3:
1) drop the comment suggested by Simon
Link: https://lore.kernel.org/lkml/20230314030532.9238-3-kerneljasonxing@gmail.com/

v2:
1) change the coding style suggested by Stephen and Simon
2) Keep the display of the old data (time_squeeze) untouched suggested
by Kui-Feng
Link: https://lore.kernel.org/lkml/20230311163614.92296-1-kerneljasonxing@gmail.com/
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 12 ++++++++----
 net/core/net-procfs.c     |  9 ++++++---
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a14b7b11766..5736311a2133 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3157,6 +3157,7 @@ struct softnet_data {
 	/* stats */
 	unsigned int		processed;
 	unsigned int		time_squeeze;
+	unsigned int		budget_squeeze;
 #ifdef CONFIG_RPS
 	struct softnet_data	*rps_ipi_list;
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index 253584777101..1518a366783b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	unsigned long time_limit = jiffies +
 		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
+	bool done = false;
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
@@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	list_splice_init(&sd->poll_list, &list);
 	local_irq_enable();
 
-	for (;;) {
+	while (!done) {
 		struct napi_struct *n;
 
 		skb_defer_free_flush(sd);
@@ -6662,10 +6663,13 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 		 * Allow this to run for 2 jiffies since which will allow
 		 * an average latency of 1.5/HZ.
 		 */
-		if (unlikely(budget <= 0 ||
-			     time_after_eq(jiffies, time_limit))) {
+		if (unlikely(budget <= 0)) {
+			sd->budget_squeeze++;
+			done = true;
+		}
+		if (unlikely(time_after_eq(jiffies, time_limit))) {
 			sd->time_squeeze++;
-			break;
+			done = true;
 		}
 	}
 
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 09f7ed1a04e8..b748e85952b0 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -158,6 +158,8 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	struct softnet_data *sd = v;
 	u32 input_qlen = softnet_input_pkt_queue_len(sd);
 	u32 process_qlen = softnet_process_queue_len(sd);
+	unsigned int budget_sq = sd->budget_squeeze;
+	unsigned int time_sq = sd->time_squeeze;
 	unsigned int flow_limit_count = 0;
 
 #ifdef CONFIG_NET_FLOW_LIMIT
@@ -176,13 +178,14 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 */
 	seq_printf(seq,
 		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
-		   "%08x %08x\n",
-		   sd->processed, sd->dropped, sd->time_squeeze, 0,
+		   "%08x %08x %08x %08x\n",
+		   sd->processed, sd->dropped, time_sq + budget_sq, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
 		   input_qlen + process_qlen, (int)seq->index,
-		   input_qlen, process_qlen);
+		   input_qlen, process_qlen,
+		   time_sq, budget_sq);
 	return 0;
 }
 
-- 
2.37.3

