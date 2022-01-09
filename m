Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B150C48883D
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 07:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235224AbiAIGh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 01:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235220AbiAIGhZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 01:37:25 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35D57C061401;
        Sat,  8 Jan 2022 22:37:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 59-20020a17090a09c100b001b34a13745eso11359656pjo.5;
        Sat, 08 Jan 2022 22:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Way90yUz+/oARc0V+ElMdCYBNNb7orbnuEP+2suGKw=;
        b=gNqXY4fk14C8cThWFuzOgCWn2id4XYgRUgBYjlNWmxwjMt7SrXBKqWNp4xVf44l8Il
         FkEjsly7mSkilUzyexxtkHw7shNBYTmrffzJ7gxh+MpZeWOZhPnM8v7dWwVXZbABw1LV
         RUgh6lp3e0puwCEvIInVBTa8nNlX7a56TXe/tQeIix2CLTQCXUNZwV3LzDqzNkcr81tD
         VhfRz1r6dG8SEKRzIJWvKxa+w+HQ1B5vsU5iFSuRy626pVz8k/MMZG9up+CkCSJXHjx4
         qsEHueT+pZxHvBZgFuKnPtrN1Ovyr9U3m9pjifGnRL6Kiqofog2YoTT/uSfTCgi3Dj6J
         ngoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Way90yUz+/oARc0V+ElMdCYBNNb7orbnuEP+2suGKw=;
        b=XXspmUZUH2CZLw4gKVMeMyCTQxoF0xXJrU4BRlUsQ9ZPlghlNjC6pVxJXnGT+gejS7
         ecHVBEGV1QZbhEGRvRMbL2s0N0pH0h25aWdw2R47vbHWlsDMdxzgRpkAQfsSvCusOu56
         RTRnkcok7Sl31yEV72cYZXI6qS9cALkKJ6DpaPqyo84X2InX5/DlNULZloX7vZovAyWh
         NHWR7/WtbX4ibpO8oEdaSQO8uflbufPpzvfpzVWJZDcun8h/wIkNYe2r0vlm1c0GlDR+
         L7aOCAmkDTfK95TbBPEGxP4Aq+yXE6ZjOWM9unWBQBPEvQ0gbnaQ4UWJ8fb9vZ9Sss1V
         6E3A==
X-Gm-Message-State: AOAM532R0dznIMSSs8vX/b2ZaJhEH5FavhOo0aqiPSJVIXpb+FUw+SrG
        J2GAKhuiTChg/VpIcxfCWTKbmk2cT2U=
X-Google-Smtp-Source: ABdhPJw80g9m/42eGalDFyQ+9uLUwf4qBPbQwsfRb/h150WFC9fJ3B23cGoq1DmNPZUottDaf3fDSA==
X-Received: by 2002:a17:90b:688:: with SMTP id m8mr18207838pjz.62.1641710244689;
        Sat, 08 Jan 2022 22:37:24 -0800 (PST)
Received: from localhost.localdomain ([43.132.141.4])
        by smtp.gmail.com with ESMTPSA id my5sm5892042pjb.5.2022.01.08.22.37.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Jan 2022 22:37:24 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     rostedt@goodmis.org, dsahern@kernel.org
Cc:     mingo@redhat.com, davem@davemloft.net, kuba@kernel.org,
        nhorman@tuxdriver.com, edumazet@google.com,
        yoshfuji@linux-ipv6.org, alobakin@pm.me, willemb@google.com,
        cong.wang@bytedance.com, keescook@chromium.org, pabeni@redhat.com,
        talalahmad@google.com, haokexin@gmail.com,
        ilias.apalodimas@linaro.org, memxor@gmail.com, atenart@kernel.org,
        bigeasy@linutronix.de, weiwan@google.com, arnd@arndb.de,
        vvs@virtuozzo.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jonathan.lemon@gmail.com,
        imagedong@tencent.com
Subject: [PATCH v4 net-next 1/3] net: skb: introduce kfree_skb_reason()
Date:   Sun,  9 Jan 2022 14:36:26 +0800
Message-Id: <20220109063628.526990-2-imagedong@tencent.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220109063628.526990-1-imagedong@tencent.com>
References: <20220109063628.526990-1-imagedong@tencent.com>
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

All drop reasons are defined in the enum 'skb_drop_reason', and
they will be print as string in 'kfree_skb' tracepoint in format
of 'reason: XXX'.

( Maybe the reasons should be defined in a uapi header file, so that
user space can use them? )

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
v4:
- fix some code style in skb.h

v3:
- rename kfree_skb_with_reason() to kfree_skb_reason()
- turn kfree_skb() into a static inline calling kfree_skb_reason()
---
 include/linux/skbuff.h     | 23 ++++++++++++++++++++++-
 include/trace/events/skb.h | 36 +++++++++++++++++++++++++++++-------
 net/core/dev.c             |  3 ++-
 net/core/drop_monitor.c    | 10 +++++++---
 net/core/skbuff.c          | 12 +++++++-----
 5 files changed, 67 insertions(+), 17 deletions(-)

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
index 9e92f22eb086..294c61bbe44b 100644
--- a/include/trace/events/skb.h
+++ b/include/trace/events/skb.h
@@ -9,29 +9,51 @@
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
+		  __entry->skbaddr, __entry->protocol, __entry->location,
+		  __print_symbolic(__entry->reason,
+				   TRACE_SKB_DROP_REASON))
 );
 
 TRACE_EVENT(consume_skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 83a4089990a0..84a0d9542fe9 100644
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
2.34.1

