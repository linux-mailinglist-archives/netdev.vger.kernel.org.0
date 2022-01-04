Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFB4483AF0
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 04:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiADDV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 22:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiADDV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 22:21:59 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A755C061761;
        Mon,  3 Jan 2022 19:21:59 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id i8so23046822pgt.13;
        Mon, 03 Jan 2022 19:21:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EKEoNk476cBIT7AG/KhWAKjNPo3TYusHnC8cRKGFm7k=;
        b=HGmt9kgysIRCJ3PAnqZSI+ipZa7eD3cvIv9piNiAi5OrirnM8d8xtSP0jFafMGmEpw
         WG/DQQNvhvIEl1tscfk0+nw1ywnp7fM1XgGWZqjFnlxh3Jgq0AjsWeBuTC6KAI+vVnuk
         6JfdbRXqlEAan4EjcPmy4IPqqszxoNNRqSzd0yp+2V18o0TxvV0NHkZjbrESJtwTE36y
         pJr9IEg3LAY8VsBm5SjpeG9+idX3C/fPOlT3d5a3B7LEwyYCi1dlQd6KQdDmDwT+Ulsz
         PB2BOWGNVFNgxGdbuIi/GU7d3rbmMjV+GOiNZB7ypdhYsODUFzX6EvxWoBPA15e9i6CX
         yYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EKEoNk476cBIT7AG/KhWAKjNPo3TYusHnC8cRKGFm7k=;
        b=MYA2PjYCDb4Rx0/QdDe5mECEaIKGDi782kl6P0EC18qGV9m8gH+180GQQ5AoVOHBD7
         078RUoUBTHinYxTU4RCMc+XPNY3Prz1JVk6TGcWu5FAT1aqVAPspL38qbZ1hZe7V9ZkS
         eeow/T7ek3jp2TWX36KlNkuTSp4sxZj99t54LVY8oppPmVxeazrBLU5i7ADOJpSVX6Bs
         FtNHK3SjmDTBw5Q/ZmBPqoNgQOi9ewuAM3i/KGqWiZXLWYtVgMxZM0xVtoE5RFGxuWe7
         bGdL2K6f2wXJ6mCX7uxHKeC0Zz6euzA7rPKcfIL5Ou0ff3FpJc/mbfEEoVgkRTuJ2oCp
         k1rA==
X-Gm-Message-State: AOAM531uIcLEKfwylbt0FIAPtAz5Wlj6wFa0wqLKJcuTlERZKqpEownb
        f3X6Fp/d4guiFmnJsSptQp0=
X-Google-Smtp-Source: ABdhPJwvbwiw1agB8MxRMtHKf3tIHFHmyxzstImUv3zJB5FUo8eGGiU2RG6e9xaUXFTSfrtYE70vog==
X-Received: by 2002:a63:7116:: with SMTP id m22mr42227056pgc.348.1641266518939;
        Mon, 03 Jan 2022 19:21:58 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.8])
        by smtp.gmail.com with ESMTPSA id y3sm36029078pju.37.2022.01.03.19.21.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 19:21:58 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, kuba@kernel.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, nhorman@tuxdriver.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org,
        jonathan.lemon@gmail.com, alobakin@pm.me, keescook@chromium.org,
        cong.wang@bytedance.com, talalahmad@google.com, haokexin@gmail.com,
        imagedong@tencent.com, atenart@kernel.org, bigeasy@linutronix.de,
        weiwan@google.com, arnd@arndb.de, pabeni@redhat.com,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, mengensun@tencent.com,
        mungerjiang@tencent.com
Subject: [PATCH v3 net-next 1/3] net: skb: introduce kfree_skb_reason()
Date:   Tue,  4 Jan 2022 11:21:32 +0800
Message-Id: <20220104032134.1239096-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220104032134.1239096-1-imagedong@tencent.com>
References: <20220104032134.1239096-1-imagedong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

Introduce the interface kfree_skb_reason(), which is able to pass
the reason why the skb is dropped to 'kfree_skb' tracepoint.

Add the 'reason' field to 'trace_kfree_skb', therefor user can get
more detail information about abnormal skb with 'drop_monitor' or
eBPF.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v3:
- rename kfree_skb_with_reason() to kfree_skb_reason()
- turn kfree_skb() into a static inline calling kfree_skb_reason()
---
 include/linux/skbuff.h     | 23 ++++++++++++++++++++++-
 include/trace/events/skb.h | 35 ++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 12 +++++++-----
 5 files changed, 66 insertions(+), 17 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 642acb0d1646..ef0870abc791 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -305,6 +305,17 @@ struct sk_buff_head {
 
 struct sk_buff;
 
+/* The reason of skb drop, which is used in kfree_skb_reason().
+ * en...maybe they should be splited by group?
+ *
+ * Each item here should also be in 'TRACE_SKB_DROP_REASON', which is
+ * used to translate the reason to string.
+ */
+enum skb_drop_reason {
+	SKB_DROP_REASON_NOT_SPECIFIED,
+	SKB_DROP_REASON_MAX,
+};
+
 /* To allow 64K frame to be packed as single skb without frag_list we
  * require 64K/PAGE_SIZE pages plus 1 additional page to allow for
  * buffers which do not start on a page boundary.
@@ -1085,8 +1096,18 @@ static inline bool skb_unref(struct sk_buff *skb)
 	return true;
 }
 
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason);
+
+/**
+ *	kfree_skb - free an sk_buff with 'NOT_SPECIFIED' reason
+ *	@skb: buffer to free
+ */
+static inline void kfree_skb(struct sk_buff *skb)
+{
+	kfree_skb_reason(skb, SKB_DROP_REASON_NOT_SPECIFIED);
+}
+
 void skb_release_head_state(struct sk_buff *skb);
-void kfree_skb(struct sk_buff *skb);
 void kfree_skb_list(struct sk_buff *segs);
 void skb_dump(const char *level, const struct sk_buff *skb, bool full_pkt);
 void skb_tx_error(struct sk_buff *skb);
diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
index 9e92f22eb086..b5ef652e5a93 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,29 +9,50 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 
+#define TRACE_SKB_DROP_REASON					\
+	EM(SKB_DROP_REASON_NOT_SPECIFIED, NOT_SPECIFIED)	\
+	EMe(SKB_DROP_REASON_MAX, MAX)
+
+#undef EM
+#undef EMe
+
+#define EM(a, b)	TRACE_DEFINE_ENUM(a);
+#define EMe(a, b)	TRACE_DEFINE_ENUM(a);
+
+TRACE_SKB_DROP_REASON
+
+#undef EM
+#undef EMe
+#define EM(a, b)	{ a, #b },
+#define EMe(a, b)	{ a, #b }
+
 /*
  * Tracepoint for free an sk_buff:
  */
 TRACE_EVENT(kfree_skb,
 
-	TP_PROTO(struct sk_buff *skb, void *location),
+	TP_PROTO(struct sk_buff *skb, void *location,
+		 enum skb_drop_reason reason),
 
-	TP_ARGS(skb, location),
+	TP_ARGS(skb, location, reason),
 
 	TP_STRUCT__entry(
-		__field(	void *,		skbaddr		)
-		__field(	void *,		location	)
-		__field(	unsigned short,	protocol	)
+		__field(void *,		skbaddr)
+		__field(void *,		location)
+		__field(unsigned short,	protocol)
+		__field(enum skb_drop_reason,	reason)
 	),
 
 	TP_fast_assign(
 		__entry->skbaddr = skb;
 		__entry->location = location;
 		__entry->protocol = ntohs(skb->protocol);
+		__entry->reason = reason;
 	),
 
-	TP_printk("skbaddr=%p protocol=%u location=%p",
-		__entry->skbaddr, __entry->protocol, __entry->location)
+	TP_printk("skbaddr=%p protocol=%u location=%p reason: %s",
+		__entry->skbaddr, __entry->protocol, __entry->location,
+		__print_symbolic(__entry->reason, TRACE_SKB_DROP_REASON))
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 6c8b226b5f2f..70a6aca1dabf 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4899,7 +4899,8 @@ static __latent_entropy void net_tx_action(struct softirq_action *h)
 			if (likely(get_kfree_skb_cb(skb)->reason == SKB_REASON_CONSUMED))
 				trace_consume_skb(skb);
 			else
-				trace_kfree_skb(skb, net_tx_action);
+				trace_kfree_skb(skb, net_tx_action,
+						SKB_DROP_REASON_NOT_SPECIFIED);
 
 			if (skb->fclone != SKB_FCLONE_UNAVAILABLE)
 				__kfree_skb(skb);
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 3d0ab2eec916..7b288a121a41 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -110,7 +110,8 @@ static u32 net_dm_queue_len = 1000;
 
 struct net_dm_alert_ops {
 	void (*kfree_skb_probe)(void *ignore, struct sk_buff *skb,
-				void *location);
+				void *location,
+				enum skb_drop_reason reason);
 	void (*napi_poll_probe)(void *ignore, struct napi_struct *napi,
 				int work, int budget);
 	void (*work_item_func)(struct work_struct *work);
@@ -262,7 +263,9 @@ static void trace_drop_common(struct sk_buff *skb, void *location)
 	spin_unlock_irqrestore(&data->lock, flags);
 }
 
-static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb, void *location)
+static void trace_kfree_skb_hit(void *ignore, struct sk_buff *skb,
+				void *location,
+				enum skb_drop_reason reason)
 {
 	trace_drop_common(skb, location);
 }
@@ -490,7 +493,8 @@ static const struct net_dm_alert_ops net_dm_alert_summary_ops = {
 
 static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 					      struct sk_buff *skb,
-					      void *location)
+					      void *location,
+					      enum skb_drop_reason reason)
 {
 	ktime_t tstamp = ktime_get_real();
 	struct per_cpu_dm_data *data;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e514a36bcffc..0118f0afaa4f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -759,21 +759,23 @@ void __kfree_skb(struct sk_buff *skb)
 EXPORT_SYMBOL(__kfree_skb);
 
 /**
- *	kfree_skb - free an sk_buff
+ *	kfree_skb_reason - free an sk_buff with special reason
  *	@skb: buffer to free
+ *	@reason: reason why this skb is dropped
  *
  *	Drop a reference to the buffer and free it if the usage count has
- *	hit zero.
+ *	hit zero. Meanwhile, pass the drop reason to 'kfree_skb'
+ *	tracepoint.
  */
-void kfree_skb(struct sk_buff *skb)
+void kfree_skb_reason(struct sk_buff *skb, enum skb_drop_reason reason)
 {
 	if (!skb_unref(skb))
 		return;
 
-	trace_kfree_skb(skb, __builtin_return_address(0));
+	trace_kfree_skb(skb, __builtin_return_address(0), reason);
 	__kfree_skb(skb);
 }
-EXPORT_SYMBOL(kfree_skb);
+EXPORT_SYMBOL(kfree_skb_reason);
 
 void kfree_skb_list(struct sk_buff *segs)
 {
-- 
2.30.2

