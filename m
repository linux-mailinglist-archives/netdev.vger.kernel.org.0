Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A2CE6B5DF5
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 17:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230503AbjCKQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 11:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229874AbjCKQgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 11:36:25 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E128F5CEC9;
        Sat, 11 Mar 2023 08:36:22 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id y10so5409376pfi.8;
        Sat, 11 Mar 2023 08:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678552582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R27q+ruFizVfsZnI4Ph2nW9rPNDoG0WYlTi4uPHonSg=;
        b=KULkSXc2OamSY41P4speudAtRYuqSs1EfdQ1mcnmMMAVtPTtjJnUGfsPFOdwnYKaU0
         4YPTr9wbLFgO8N4nAkhWn0OoB/s8o6ZSt/86vp+yPgefnYxXtNW+fYHl7LGtS/fNfikl
         yY06bXV3uSwwrzTRd2KfECm0hSY8gtvVbCcbjunDWGl6kXR/kKHBR4A5gOn2d2ALQ7tU
         pSgpdW7Ss1f4Sa76Ftb0YgBuYM1+Ygkw+dqcXvMcMQOJJM+APufjIJYXn9P7FdHnbzcp
         IIk5NyryV12bqfRh2/y6wMH7QLLqUlvS8bX6xN5FaxS2ODSuTLGFSZ+N4lkP4nw4MA4y
         jLUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678552582;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R27q+ruFizVfsZnI4Ph2nW9rPNDoG0WYlTi4uPHonSg=;
        b=elAU/9Tf5XWqutregwaey5Hb9kEPDLMehthz+7/sWahcfUQHvYs9obv5VlHsPtCiWR
         1k//7yAUYCzimDC936UkCbr3k0Nab93TTkJFv950kmy8+RFd+hyYKTgXsIFVn1K3Ncdx
         9ID/kNlJ5F2B/0jFjMKP9bB8XmEhidpgDq15U81BxyRq27naMSrxyowUUM5G762kpD01
         YCAh/HRaVKt+opmh+mg0JYj01dINcWv1ZS0Z6V5ujOOlMVeg+Ct4IrDpZmlHbgc0t/Wd
         POXu1RR4fnFD+MNqi1L5hl/Yv2pazalbaesNW4hAtGzMg88EGQo0S+LiAGTmKkG7GYQz
         zsyA==
X-Gm-Message-State: AO0yUKWp4VpjOW1lyQ2VssIuYkDpaamKGVP1dsWVkNcc/nyzpDhSalPK
        zQIy4n+o0B+4h3Cl57OSubU=
X-Google-Smtp-Source: AK7set+UbftSCmso22uaHumhJFqS1Czrkx9Irsx7eNlbSsV19y8Tlpc48FGIS9yAeVyyjiVhJygo5g==
X-Received: by 2002:aa7:96e2:0:b0:5a9:cbc3:ca70 with SMTP id i2-20020aa796e2000000b005a9cbc3ca70mr27132003pfq.24.1678552582273;
        Sat, 11 Mar 2023 08:36:22 -0800 (PST)
Received: from KERNELXING-MB0.tencent.com ([114.253.32.213])
        by smtp.gmail.com with ESMTPSA id g21-20020a62e315000000b0058e08796e98sm1648917pfh.196.2023.03.11.08.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 08:36:21 -0800 (PST)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com
Cc:     kuniyu@amazon.com, liuhangbin@gmail.com, xiangxia.m.yue@gmail.com,
        jiri@nvidia.com, andy.ren@getcruise.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH net-next] net: introduce budget_squeeze to help us tune rx behavior
Date:   Sun, 12 Mar 2023 00:36:14 +0800
Message-Id: <20230311163614.92296-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
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

When we encounter some performance issue and then get lost on how
to tune the budget limit and time limit in net_rx_action() function,
we can separately counting both of them to avoid the confusion.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
note: this commit is based on the link as below:
https://lore.kernel.org/lkml/20230311151756.83302-1-kerneljasonxing@gmail.com/
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
index 253584777101..bed7a68fdb5d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6637,6 +6637,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	unsigned long time_limit = jiffies +
 		usecs_to_jiffies(READ_ONCE(netdev_budget_usecs));
 	int budget = READ_ONCE(netdev_budget);
+	bool is_continue = true;
 	LIST_HEAD(list);
 	LIST_HEAD(repoll);
 
@@ -6644,7 +6645,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	list_splice_init(&sd->poll_list, &list);
 	local_irq_enable();
 
-	for (;;) {
+	for (; is_continue;) {
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
+			is_continue = false;
+		}
+		if (unlikely(time_after_eq(jiffies, time_limit))) {
 			sd->time_squeeze++;
-			break;
+			is_continue = false;
 		}
 	}
 
diff --git a/net/core/net-procfs.c b/net/core/net-procfs.c
index 97a304e1957a..4d1a499d7c43 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -174,14 +174,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 */
 	seq_printf(seq,
 		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
-		   "%08x %08x\n",
-		   sd->processed, sd->dropped, sd->time_squeeze, 0,
+		   "%08x %08x %08x %08x\n",
+		   sd->processed, sd->dropped,
+		   0, /* was old way to count time squeeze */
+		   0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
 		   0,	/* was len of two backlog queues */
 		   (int)seq->index,
-		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
+		   sd->time_squeeze, sd->budget_squeeze);
 	return 0;
 }
 
-- 
2.37.3

