Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A7F3C98A0
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 08:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239812AbhGOGGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 02:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231910AbhGOGGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 02:06:24 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E29C06175F
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:03:30 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d1so3781940qto.4
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 23:03:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cpXNa7TisYFdF2lBPwcRDKMLdNtY4nJ63Q5aTnDpLRc=;
        b=IshGV3eOjmMGkfL+pVTSsP8gpYD0BfGhdOvpapBtLUitg4yNOfVJmHVdhLO2tL4sZG
         sqvY6FyaXwWZCCvdp5JLCCxdoCeY4sSkuKwZPehIRcOSGLnV+/Rhcu6Ey2GNjZwdcQ4v
         KNTDJCKCR5U/ilri03WqbewhM/QH2CNEd9l61UHj8obLYZy+N4eKnPKVG+oZvnnFffkM
         UaRumjALN0zOkkJnXe1KziJKF/GNxngCi0RWnJMOjXYKg1eb3yOt8NGNFgmEGhPGD9A5
         QVwsG8dhMof0wUmrBBnqT+GsTfIQzp5KMTrt3vadCA1m4IzQAoY8RU2YTi5Q3zLKAaVS
         i0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cpXNa7TisYFdF2lBPwcRDKMLdNtY4nJ63Q5aTnDpLRc=;
        b=OcayP8PEK2ZIslm3u0Y1VAacXEAQeN+dMLIHm9PbPqZSpgEMGQLZHHL87jT5c9iBsN
         xiLpRcWK6XZ06LcKtRROFXNyvJLArLmoYyVPwpGBtSKre6pGKPi0HI6O7iy+X5AeQb6i
         o0o0SHLiKc5r7EhRsWVNUB2ExvyyENCGuIVrdKBW+CMljodciA5oNZw9QHFDCfZucJ7t
         9jVcAQ1wQ29Y9Fd/vG7d4g2qPtbA9yADLghCIE5fhrDCsxFRdElHW3T+oq9p1UxRFTC+
         ngzDSMzKZhezfkjyW9BotP5L0PTpLsls0wy2XpEdazfgDZCW/7x/P6GBMDoaAyaYeFmC
         OzxQ==
X-Gm-Message-State: AOAM532xP7zRG8HcUHN0rBqq/6c2HEVCp6rzvwLN8eugFtQltntWpRuJ
        BgeOTlvcUtnxdZ362OK0eL23lT3SKA4=
X-Google-Smtp-Source: ABdhPJzZXR8UZsPX1ffGEGIEn9KDH+VUGznyrnqS+8aXG3EsxMntyrovQIVpWs4NaxV4hBzQw80brg==
X-Received: by 2002:a05:622a:310:: with SMTP id q16mr2370782qtw.168.1626329009658;
        Wed, 14 Jul 2021 23:03:29 -0700 (PDT)
Received: from unknown.attlocal.net (76-217-55-94.lightspeed.sntcca.sbcglobal.net. [76.217.55.94])
        by smtp.gmail.com with ESMTPSA id r5sm1671366qtm.75.2021.07.14.23.03.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 23:03:29 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Qitao Xu <qitao.xu@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>
Subject: [Patch net-next v3] net_sched: introduce tracepoint trace_qdisc_enqueue()
Date:   Wed, 14 Jul 2021 23:03:24 -0700
Message-Id: <20210715060324.43337-1-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qitao Xu <qitao.xu@bytedance.com>

Tracepoint trace_qdisc_enqueue() is introduced to trace skb at
the entrance of TC layer on TX side. This is similar to
trace_qdisc_dequeue():

1. For both we only trace successful cases. The failure cases
   can be traced via trace_kfree_skb().

2. They are called at entrance or exit of TC layer, not for each
   ->enqueue() or ->dequeue(). This is intentional, because
   we want to make trace_qdisc_enqueue() symmetric to
   trace_qdisc_dequeue(), which is easier to use.

The return value of qdisc_enqueue() is not interesting here,
we have Qdisc's drop packets in ->dequeue(), it is impossible to
trace them even if we have the return value, the only way to trace
them is tracing kfree_skb().

We only add information we need to trace ring buffer. If any other
information is needed, it is easy to extend it without breaking ABI,
see commit 3dd344ea84e1 ("net: tracepoint: exposing sk_family in all
tcp:tracepoints").

Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: Qitao Xu <qitao.xu@bytedance.com>
---
v3: expand changelog
    add helper dev_qdisc_enqueue()

v2: improve changelog

 include/trace/events/qdisc.h | 26 ++++++++++++++++++++++++++
 net/core/dev.c               | 20 ++++++++++++++++----
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 58209557cb3a..c3006c6b4a87 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -46,6 +46,32 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
+TRACE_EVENT(qdisc_enqueue,
+
+	TP_PROTO(struct Qdisc *qdisc, const struct netdev_queue *txq, struct sk_buff *skb),
+
+	TP_ARGS(qdisc, txq, skb),
+
+	TP_STRUCT__entry(
+		__field(struct Qdisc *, qdisc)
+		__field(void *,	skbaddr)
+		__field(int, ifindex)
+		__field(u32, handle)
+		__field(u32, parent)
+	),
+
+	TP_fast_assign(
+		__entry->qdisc = qdisc;
+		__entry->skbaddr = skb;
+		__entry->ifindex = txq->dev ? txq->dev->ifindex : 0;
+		__entry->handle	 = qdisc->handle;
+		__entry->parent	 = qdisc->parent;
+	),
+
+	TP_printk("enqueue ifindex=%d qdisc handle=0x%X parent=0x%X skbaddr=%px",
+		  __entry->ifindex, __entry->handle, __entry->parent, __entry->skbaddr)
+);
+
 TRACE_EVENT(qdisc_reset,
 
 	TP_PROTO(struct Qdisc *q),
diff --git a/net/core/dev.c b/net/core/dev.c
index c253c2aafe97..0dcddd077d60 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -131,6 +131,7 @@
 #include <trace/events/napi.h>
 #include <trace/events/net.h>
 #include <trace/events/skb.h>
+#include <trace/events/qdisc.h>
 #include <linux/inetdevice.h>
 #include <linux/cpu_rmap.h>
 #include <linux/static_key.h>
@@ -3844,6 +3845,18 @@ static void qdisc_pkt_len_init(struct sk_buff *skb)
 	}
 }
 
+static int dev_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *q,
+			     struct sk_buff **to_free,
+			     struct netdev_queue *txq)
+{
+	int rc;
+
+	rc = q->enqueue(skb, q, to_free) & NET_XMIT_MASK;
+	if (rc == NET_XMIT_SUCCESS)
+		trace_qdisc_enqueue(q, txq, skb);
+	return rc;
+}
+
 static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 				 struct net_device *dev,
 				 struct netdev_queue *txq)
@@ -3862,8 +3875,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 			 * of q->seqlock to protect from racing with requeuing.
 			 */
 			if (unlikely(!nolock_qdisc_is_empty(q))) {
-				rc = q->enqueue(skb, q, &to_free) &
-					NET_XMIT_MASK;
+				rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
 				__qdisc_run(q);
 				qdisc_run_end(q);
 
@@ -3879,7 +3891,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 			return NET_XMIT_SUCCESS;
 		}
 
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
 		qdisc_run(q);
 
 no_lock_out:
@@ -3923,7 +3935,7 @@ static inline int __dev_xmit_skb(struct sk_buff *skb, struct Qdisc *q,
 		qdisc_run_end(q);
 		rc = NET_XMIT_SUCCESS;
 	} else {
-		rc = q->enqueue(skb, q, &to_free) & NET_XMIT_MASK;
+		rc = dev_qdisc_enqueue(skb, q, &to_free, txq);
 		if (qdisc_run_begin(q)) {
 			if (unlikely(contended)) {
 				spin_unlock(&q->busylock);
-- 
2.27.0

