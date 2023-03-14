Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13CB56B88D9
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 04:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCNDGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 23:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCNDGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 23:06:23 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A34C7BA06;
        Mon, 13 Mar 2023 20:06:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id k18-20020a17090a591200b0023d36e30cb5so896973pji.1;
        Mon, 13 Mar 2023 20:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678763170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Glcb7gbJW/2Kbapciwm0FRpblb1W2IM9lseG0c3UVk=;
        b=P+3u6NYEU+wMUxXhli0xb9agEpaA6rAdyhhqv7F8djnqrYstY9on7CGvzQP1zdoevf
         NWkMtZEbWX/TxXP3XQF1660nVQPDjimbAZJQgpfrypNnkAjnTGKUTtl3xIfD/cOyxpg7
         xOwJKroR6D35gqb6VUH8uigc7+K6RzQTe8KxLzJVw0rw8xp7wBYfkZsUhc1wPtggRpy+
         YM48WOGRAxeWlSvOvx8pdiLGEWQD3+071OTvPApuEApVHf0cB5FgbsKkOoIEw76WNjbf
         6NhoFg/wEgav9IwJbAxSqb+stO6g5dkh1ABPjrK2YbjATAbpPFYPHQ6CN+P44sYz/PnO
         WaRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678763170;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2Glcb7gbJW/2Kbapciwm0FRpblb1W2IM9lseG0c3UVk=;
        b=oejqAvzFRAm33/1a9a8rQn4WHYHXD6G18B9Clsl7xp8O/903/322J31m0YgUTW3H7D
         6uCtgusPwWisVLTF3I+iI5cMXBdiE3fsUoWE2NTRlVSi/Pefwj8sUkTFku6d27+RbHLv
         rt0vAmK0LH13VE3hX8fACNCwLkZrRktgTbjFOPZDgOB3tkcXcp/mqlQhx2/cfInxs5DR
         rfKflO7BVUaD+ThPHTBgn+V/7OMtJ0LCnzYWgpqxJEHW6pk4+W7b4gN3bLmNkIEkYkEJ
         eWWF/sTPMzs6hRKlA2K2Xbo7eaxloYsza1MIhZppruMgAOoyTU5BnzqHEmEyZPUjs78a
         y4iQ==
X-Gm-Message-State: AO0yUKWecq4MgJFwC5FfsxxmByLKNYzSnQl9GGxCkcH5QczNMbXfOaTK
        DwqVOMsOWtVhKhPlhN5PCXk=
X-Google-Smtp-Source: AK7set/796TeIZnCBEwRRYvVZikm6y42P68Ad5BNCAQW237yqA+PSSF65nn/QkHBVy16xpF9e3geaA==
X-Received: by 2002:a05:6a20:6009:b0:d4:b24b:4459 with SMTP id r9-20020a056a20600900b000d4b24b4459mr3749090pza.13.1678763170003;
        Mon, 13 Mar 2023 20:06:10 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id i17-20020aa787d1000000b005897f5436c0sm395433pfo.118.2023.03.13.20.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Mar 2023 20:06:09 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net-next 2/2] net: introduce budget_squeeze to help us tune rx behavior
Date:   Tue, 14 Mar 2023 11:05:32 +0800
Message-Id: <20230314030532.9238-3-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230314030532.9238-1-kerneljasonxing@gmail.com>
References: <20230314030532.9238-1-kerneljasonxing@gmail.com>
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
index 2809b663e78d..25810ee46a04 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -179,14 +179,17 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 */
 	seq_printf(seq,
 		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
-		   "%08x %08x\n",
-		   sd->processed, sd->dropped, sd->time_squeeze, 0,
+		   "%08x %08x %08x %08x\n",
+		   sd->processed, sd->dropped,
+		   sd->time_squeeze + sd->budget_squeeze, /* keep it untouched */
+		   0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
 		   softnet_backlog_len(sd),	/* keep it untouched */
 		   (int)seq->index,
-		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
+		   sd->time_squeeze, sd->budget_squeeze);
 	return 0;
 }
 
-- 
2.37.3

