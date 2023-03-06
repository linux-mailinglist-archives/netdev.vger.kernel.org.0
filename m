Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6EF6ACF59
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 21:43:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjCFUnS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 15:43:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCFUnR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 15:43:17 -0500
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410983645D
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 12:43:16 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-536af109f9aso115090307b3.13
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 12:43:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678135395;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QLe8eYzKaesbgWrlK5zR7xxt0H/CM71W0sgxLzPVnRQ=;
        b=hu4Z7/YQDFJ50uDcfsFoB67KbxrsgT8SRgyrNBRq4A6l6AtD/llYbxAtzK2LZIYSgj
         AUvUyl0J2gnHdAKUb9zeqzAkwkREFJpjdxMzYFgZuhb5300sitzuM4FfWyuFRLVxdIjw
         1H60vyUGzWW2dvRsyIzwIVAsDPIKe0LJ4cYY/x5KxSuONQmGimP8eQ82Bkqq6pXI33DK
         VZf0YW8+vtVEEeupww8A/0v3mCBECSYJfkWAuf4KX/WRVOuXTxjMrnsT/z7ESgz3fPSn
         k1DpNiiWJasfB1RCxx9vXTKa9tCMng9MqlVw+5848KQTzevPwLt7IGJfdKmdX9FzynXz
         2Nsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678135395;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QLe8eYzKaesbgWrlK5zR7xxt0H/CM71W0sgxLzPVnRQ=;
        b=kmx96lImzNpyJThyinN2iotz9XSXp9loEThrBNKblsvPqqaZ12XCE0ao6PYaWDQ31h
         BasRbpCvq3fb7n2Say62u63di+dU0tvAVnjWSLbq0AKqMBWNXkXdOobR+VqiX7WZImeT
         qZI/fnrc8SzNqLKreIR0cmvdA0I7BJ+LTQk6OcI0DPEHr99DrQ6d0ItUVVU7l7rSTgjv
         dF5P1F4p48BJf3uCHLxonbk9TQTO2YbFI92uZaP+zh1ib/Br7FjypWOWQkN/njZ3Cy3G
         pdX0jvv62BlSL9gNK/MgxxQ3/7guXzg08eIY2XaOXeKZJKzSgFBdCLGvnOcvqkyqU7WS
         KFxg==
X-Gm-Message-State: AO0yUKUiySRsps3dyibwF+7oQBb9fK2UFgqHX3+klUk79PpF5z7hiIRs
        r74L3W/q0biqKyQ6LXqcU+4wg6X8vrO0nA==
X-Google-Smtp-Source: AK7set97yPr9cln3yXSDsHty7tlzQvQ35TG8FUNMByBzrsVepQPfCMMducVnnhUA0retIZVusbLIKz++9vpS1A==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9248:0:b0:a09:32fb:be73 with SMTP id
 e8-20020a259248000000b00a0932fbbe73mr7275406ybo.0.1678135395520; Mon, 06 Mar
 2023 12:43:15 -0800 (PST)
Date:   Mon,  6 Mar 2023 20:43:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230306204313.10492-1-edumazet@google.com>
Subject: [PATCH net-next] net: remove enum skb_free_reason
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

enum skb_drop_reason is more generic, we can adopt it instead.

Provide dev_kfree_skb_irq_reason() and dev_kfree_skb_any_reason().

This means drivers can use more precise drop reasons if they want to.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h | 18 +++++++-----------
 net/core/dev.c            | 20 +++++++++-----------
 2 files changed, 16 insertions(+), 22 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 6a14b7b117668ca2c8b1f914ecb49fb4311784ab..ee483071cf599981c12cf00a016a16bb3c46da32 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -52,6 +52,7 @@
 #include <linux/rbtree.h>
 #include <net/net_trackers.h>
 #include <net/net_debug.h>
+#include <net/dropreason.h>
 
 struct netpoll_info;
 struct device;
@@ -3804,13 +3805,8 @@ static inline unsigned int get_netdev_rx_queue_index(
 
 int netif_get_num_default_rss_queues(void);
 
-enum skb_free_reason {
-	SKB_REASON_CONSUMED,
-	SKB_REASON_DROPPED,
-};
-
-void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason);
-void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason);
+void dev_kfree_skb_irq_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+void dev_kfree_skb_any_reason(struct sk_buff *skb, enum skb_drop_reason reason);
 
 /*
  * It is not allowed to call kfree_skb() or consume_skb() from hardware
@@ -3833,22 +3829,22 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason);
  */
 static inline void dev_kfree_skb_irq(struct sk_buff *skb)
 {
-	__dev_kfree_skb_irq(skb, SKB_REASON_DROPPED);
+	dev_kfree_skb_irq_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 static inline void dev_consume_skb_irq(struct sk_buff *skb)
 {
-	__dev_kfree_skb_irq(skb, SKB_REASON_CONSUMED);
+	dev_kfree_skb_irq_reason(skb, SKB_CONSUMED);
 }
 
 static inline void dev_kfree_skb_any(struct sk_buff *skb)
 {
-	__dev_kfree_skb_any(skb, SKB_REASON_DROPPED);
+	dev_kfree_skb_any_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
 }
 
 static inline void dev_consume_skb_any(struct sk_buff *skb)
 {
-	__dev_kfree_skb_any(skb, SKB_REASON_CONSUMED);
+	dev_kfree_skb_any_reason(skb, SKB_CONSUMED);
 }
 
 u32 bpf_prog_run_generic_xdp(struct sk_buff *skb, struct xdp_buff *xdp,
diff --git a/net/core/dev.c b/net/core/dev.c
index 253584777101f2e6af3fc30107516f1e1197f8d3..c7853192563d2ee6cd43293c84b9ae5073346580 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3075,7 +3075,7 @@ void __netif_schedule(struct Qdisc *q)
 EXPORT_SYMBOL(__netif_schedule);
 
 struct dev_kfree_skb_cb {
-	enum skb_free_reason reason;
+	enum skb_drop_reason reason;
 };
 
 static struct dev_kfree_skb_cb *get_kfree_skb_cb(const struct sk_buff *skb)
@@ -3108,7 +3108,7 @@ void netif_tx_wake_queue(struct netdev_queue *dev_queue)
 }
 EXPORT_SYMBOL(netif_tx_wake_queue);
 
-void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason)
+void dev_kfree_skb_irq_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	unsigned long flags;
 
@@ -3128,18 +3128,16 @@ void __dev_kfree_skb_irq(struct sk_buff *skb, enum skb_free_reason reason)
 	raise_softirq_irqoff(NET_TX_SOFTIRQ);
 	local_irq_restore(flags);
 }
-EXPORT_SYMBOL(__dev_kfree_skb_irq);
+EXPORT_SYMBOL(dev_kfree_skb_irq_reason);
 
-void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
+void dev_kfree_skb_any_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (in_hardirq() || irqs_disabled())
-		__dev_kfree_skb_irq(skb, reason);
-	else if (unlikely(reason == SKB_REASON_DROPPED))
-		kfree_skb(skb);
+		dev_kfree_skb_irq_reason(skb, reason);
 	else
-		consume_skb(skb);
+		kfree_skb_reason(skb, reason);
 }
-EXPORT_SYMBOL(__dev_kfree_skb_any);
+EXPORT_SYMBOL(dev_kfree_skb_any_reason);
 
 
 /**
@@ -5020,11 +5018,11 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			clist = clist->next;
 
 			WARN_ON(refcount_read(&skb->users));
-			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
+			if (likely(get_kfree_skb_cb(skb)->reason == SKB_CONSUMED))
 				trace_consume_skb(skb, net_tx_action);
 			else
 				trace_kfree_skb(skb, net_tx_action,
-						SKB_DROP_REASON_NOT_SPECIFIED);
+						get_kfree_skb_cb(skb)->reason);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

