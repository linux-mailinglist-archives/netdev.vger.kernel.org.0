Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 479A7207A18
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405449AbgFXRTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 13:19:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405414AbgFXRTK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 13:19:10 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6168CC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:10 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id s14so1301563plq.6
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 10:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ao8I7yh9lQNodY4ZHsI/D/j9Zk0SkiV9Y+kygLt5pz0=;
        b=jwJYVbLwAc2j2v6U9ufu3rZMyHPCHikwfg1Ayf2zDmsjeei6zrCzP3SVeGQ7F7l7P4
         /cQ5aEQW7OUk5F4xgEtvnIBj4urjSKiYBcm8kpHn1SsLl5PU/GptXF7p6RhWD8wkmMbh
         32DwSwFAfXWUFExvint9+eiaYqkYPrFGBaAXi1YKz7LAepoMsiBJAoXeUzApQf7sSkVD
         Z1eITOO2J4wjuJ3MT9Vs49oWg7h+dozGmvsuTK4WhES2a7viDwm9b8LlcK/07sMsFyeg
         MeIs8XLaHpJt0EW7Kas/peCrwOQtSSOetEfsHfxfgISGkzpTjoigL38IBVSGsoMrIN37
         5e8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ao8I7yh9lQNodY4ZHsI/D/j9Zk0SkiV9Y+kygLt5pz0=;
        b=lZ5qXYGeuhN+bqqYZP7sVqJ+K6P5sl7UwoN9cQcCg+5jihS7Ki46OIEPkcnrQTVOGk
         QCQcxRMSQSiUf0He5N1/7tqocg904gh9Yl2r7R6Mt8BoevK+EWshvS9eND8Z5jO4GBYa
         ssytfStavXY3U9UWOEz7oNn81YzZhnj7FP5/LFUWyzHcHX/PqmhKrqUB/aHpeabdjpw8
         DWuDTs8wK3yyx0ofbcXkkP1ttsgI78WzzjCZLwkwo+F9JHiXQkzF2C+WXZa7FB2EDYZH
         OAtIkLG3DSHTn7hJdhEdyURonWogsMC6xDCry1K4GVxKuWantYOKTEhpl4m5ZutoTjwG
         2ZYg==
X-Gm-Message-State: AOAM530P6Rm9cV8JRFG0h226LkiGXmmy7QU9lpnA+jiEjhZa7l+VxWoN
        BfPdPDMAbfX4kyWuyCrpRRjoiCUCDZQ=
X-Google-Smtp-Source: ABdhPJz8qrGbV8gFtWHmHCOQ3E04Fi7GMkMCqh+40COTZcq3zm8sbsqm+poBlAVEjY8liQyx5fCpsQ==
X-Received: by 2002:a17:90b:23d2:: with SMTP id md18mr29528038pjb.179.1593019149481;
        Wed, 24 Jun 2020 10:19:09 -0700 (PDT)
Received: from localhost.localdomain (c-73-202-182-113.hsd1.ca.comcast.net. [73.202.182.113])
        by smtp.gmail.com with ESMTPSA id w18sm17490241pgj.31.2020.06.24.10.19.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 10:19:08 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
To:     netdev@vger.kernel.org
Cc:     Tom Herbert <tom@herbertland.com>
Subject: [RFC PATCH 02/11] net: Create netqueue.h and define NO_QUEUE
Date:   Wed, 24 Jun 2020 10:17:41 -0700
Message-Id: <20200624171749.11927-3-tom@herbertland.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200624171749.11927-1-tom@herbertland.com>
References: <20200624171749.11927-1-tom@herbertland.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create linux/netqueue.h to hold generic network queue definitions.

Define NO_QUEUE to replace NO_QUEUE_MAPPING in net/sock.h. NO_QUEUE
can generally be used to indicate that a 16 bit queue index does not
refer to a queue.

Also, define net_queue_pair which will be used as a generic way to store a
transmit/receive pair of network queues.
---
 include/linux/netdevice.h |  1 +
 include/linux/netqueue.h  | 25 +++++++++++++++++++++++++
 include/net/sock.h        | 12 +++++-------
 net/core/filter.c         |  4 ++--
 4 files changed, 33 insertions(+), 9 deletions(-)
 create mode 100644 include/linux/netqueue.h

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6fc613ed8eae..bf5f2a85da97 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -32,6 +32,7 @@
 #include <linux/percpu.h>
 #include <linux/rculist.h>
 #include <linux/workqueue.h>
+#include <linux/netqueue.h>
 #include <linux/dynamic_queue_limits.h>
 
 #include <linux/ethtool.h>
diff --git a/include/linux/netqueue.h b/include/linux/netqueue.h
new file mode 100644
index 000000000000..5a4d39821ada
--- /dev/null
+++ b/include/linux/netqueue.h
@@ -0,0 +1,25 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Network queue identifier definitions
+ *
+ * Copyright (c) 2020 Tom Herbert <tom@herbertland.com>
+ */
+
+#ifndef _LINUX_NETQUEUE_H
+#define _LINUX_NETQUEUE_H
+
+/* Indicates no network queue is present in 16 bit queue number */
+#define NO_QUEUE	USHRT_MAX
+
+struct net_queue_pair {
+	unsigned short txq_id;
+	unsigned short rxq_id;
+};
+
+static inline void init_net_queue_pair(struct net_queue_pair *qpair)
+{
+	qpair->rxq_id = NO_QUEUE;
+	qpair->txq_id = NO_QUEUE;
+}
+
+#endif /* _LINUX_NETQUEUE_H */
diff --git a/include/net/sock.h b/include/net/sock.h
index c53cc42b5ab9..acb76cfaae1b 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1800,16 +1800,14 @@ static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 	sk->sk_tx_queue_mapping = tx_queue;
 }
 
-#define NO_QUEUE_MAPPING	USHRT_MAX
-
 static inline void sk_tx_queue_clear(struct sock *sk)
 {
-	sk->sk_tx_queue_mapping = NO_QUEUE_MAPPING;
+	sk->sk_tx_queue_mapping = NO_QUEUE;
 }
 
 static inline int sk_tx_queue_get(const struct sock *sk)
 {
-	if (sk && sk->sk_tx_queue_mapping != NO_QUEUE_MAPPING)
+	if (sk && sk->sk_tx_queue_mapping != NO_QUEUE)
 		return sk->sk_tx_queue_mapping;
 
 	return -1;
@@ -1821,7 +1819,7 @@ static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 	if (skb_rx_queue_recorded(skb)) {
 		u16 rx_queue = skb_get_rx_queue(skb);
 
-		if (WARN_ON_ONCE(rx_queue == NO_QUEUE_MAPPING))
+		if (WARN_ON_ONCE(rx_queue == NO_QUEUE))
 			return;
 
 		sk->sk_rx_queue_mapping = rx_queue;
@@ -1832,14 +1830,14 @@ static inline void sk_rx_queue_set(struct sock *sk, const struct sk_buff *skb)
 static inline void sk_rx_queue_clear(struct sock *sk)
 {
 #ifdef CONFIG_XPS
-	sk->sk_rx_queue_mapping = NO_QUEUE_MAPPING;
+	sk->sk_rx_queue_mapping = NO_QUEUE;
 #endif
 }
 
 #ifdef CONFIG_XPS
 static inline int sk_rx_queue_get(const struct sock *sk)
 {
-	if (sk && sk->sk_rx_queue_mapping != NO_QUEUE_MAPPING)
+	if (sk && sk->sk_rx_queue_mapping != NO_QUEUE)
 		return sk->sk_rx_queue_mapping;
 
 	return -1;
diff --git a/net/core/filter.c b/net/core/filter.c
index 73395384afe2..d696aaabe3af 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7544,7 +7544,7 @@ static u32 bpf_convert_ctx_access(enum bpf_access_type type,
 
 	case offsetof(struct __sk_buff, queue_mapping):
 		if (type == BPF_WRITE) {
-			*insn++ = BPF_JMP_IMM(BPF_JGE, si->src_reg, NO_QUEUE_MAPPING, 1);
+			*insn++ = BPF_JMP_IMM(BPF_JGE, si->src_reg, NO_QUEUE, 1);
 			*insn++ = BPF_STX_MEM(BPF_H, si->dst_reg, si->src_reg,
 					      bpf_target_off(struct sk_buff,
 							     queue_mapping,
@@ -7981,7 +7981,7 @@ u32 bpf_sock_convert_ctx_access(enum bpf_access_type type,
 				       sizeof_field(struct sock,
 						    sk_rx_queue_mapping),
 				       target_size));
-		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE_MAPPING,
+		*insn++ = BPF_JMP_IMM(BPF_JNE, si->dst_reg, NO_QUEUE,
 				      1);
 		*insn++ = BPF_MOV64_IMM(si->dst_reg, -1);
 #else
-- 
2.25.1

