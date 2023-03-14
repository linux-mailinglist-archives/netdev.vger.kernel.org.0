Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8D496B95E0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjCNNSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbjCNNSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:18:22 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0052AA730;
        Tue, 14 Mar 2023 06:15:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id k2so8665504pll.8;
        Tue, 14 Mar 2023 06:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678799701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcWoqfvA9IE0sL0PZdVOZ872E1skiGdEi9aMnqvt7k0=;
        b=KALZf0IbRmqSNwlp7+T8n48OrNg0JWoB5O37QP6NCehvUpOCt+K9jgOvDW47eqMnvb
         xlAcpDlVAMmkxGkf3zxQuPUgEpwGREdr1DGG+hq8XQeIaSDIUVxnY4QGOxSG4yWgHmq9
         4238pd7VcjP4juWG0NPZlmQiQ2D4SxL4yiEbu2sQw3Omxi+OxRt7ZKXyPUkxBOsHUA/Y
         1zz1zL03ifFKDS/DqZt84he9pFM5CmcqT0XdV0kE/6MMBCUeIuIZ76rJ7wq9x0ls4ogE
         6c0xG5Ar4hlYkdSMtL4db8opVjktytqfxpcWl6BYThRQ+jgDFuEsY+39bESYh8AqdPdk
         wq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678799701;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcWoqfvA9IE0sL0PZdVOZ872E1skiGdEi9aMnqvt7k0=;
        b=ZVSBcsKKNJSLn745Ko14toIvLNneaGCgJPk4pn25oeK/2ZqCDBpXruX+Q2upA8h911
         hWDD4hDHPTgXdwcMJHJ6nR7cBnFiCJB47+mtetM1z0zCJsh+2o1Gj4+5wRVuNWgFRqrU
         quvE3dS7jTOuhzwPtE03BlbB4Jq10Etd7RXJ8GVxepadUK/0e9zgWW2r9vUXk+pxvi8c
         yjVDprhqDlxODFBDsfXCfKqUAdr8z76rYOPZFizBi6IzOJHSnw77solTpLR60RCPEIzs
         5VBCSrnbRuuYhM90ALh09dkXvQD+tYxDwlC6ByO1KXJShdg5YRk8HqLHl22PxJXiyQg3
         7lHw==
X-Gm-Message-State: AO0yUKVqN8dJD/kgxVhR816kPA2ifywR4a6KuGQht28qAyjywbjKq7LJ
        mdCmJfXq0NfEs1UbKj6mKow=
X-Google-Smtp-Source: AK7set+DEJZR2cUVwxNY3w4ozrdvxd+TZjWmnco0wUDNLN6E+lemTjl35jMINsvOjseHySmPfGGxuQ==
X-Received: by 2002:a17:90a:db46:b0:23d:19c6:84b7 with SMTP id u6-20020a17090adb4600b0023d19c684b7mr4612319pjx.16.1678799701136;
        Tue, 14 Mar 2023 06:15:01 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id g15-20020a17090a7d0f00b0023d36aa85fesm1465843pjl.40.2023.03.14.06.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 06:15:00 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        stephen@networkplumber.org, simon.horman@corigine.com,
        sinquersw@gmail.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kerneljasonxing@gmail.com,
        Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v3 net-next 2/2] net: introduce budget_squeeze to help us tune rx behavior
Date:   Tue, 14 Mar 2023 21:14:27 +0800
Message-Id: <20230314131427.85135-3-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20230314131427.85135-1-kerneljasonxing@gmail.com>
References: <20230314131427.85135-1-kerneljasonxing@gmail.com>
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
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
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
 net/core/net-procfs.c     |  8 +++++---
 3 files changed, 14 insertions(+), 7 deletions(-)

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
index 8056f39da8a1..3b53812a9ac9 100644
--- a/net/core/net-procfs.c
+++ b/net/core/net-procfs.c
@@ -179,13 +179,15 @@ static int softnet_seq_show(struct seq_file *seq, void *v)
 	 */
 	seq_printf(seq,
 		   "%08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x %08x "
-		   "%08x %08x\n",
-		   sd->processed, sd->dropped, sd->time_squeeze, 0,
+		   "%08x %08x %08x %08x\n",
+		   sd->processed, sd->dropped,
+		   sd->time_squeeze + sd->budget_squeeze, 0,
 		   0, 0, 0, 0, /* was fastroute */
 		   0,	/* was cpu_collision */
 		   sd->received_rps, flow_limit_count,
 		   softnet_backlog_len(sd), (int)seq->index,
-		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd));
+		   softnet_input_pkt_queue_len(sd), softnet_process_queue_len(sd),
+		   sd->time_squeeze, sd->budget_squeeze);
 	return 0;
 }
 
-- 
2.37.3

