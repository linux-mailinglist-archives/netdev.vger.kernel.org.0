Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD193C3AA9
	for <lists+netdev@lfdr.de>; Sun, 11 Jul 2021 07:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhGKFDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 01:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbhGKFDE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 01:03:04 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F1DAC0613DD
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 22:00:17 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id y17so14482142pgf.12
        for <netdev@vger.kernel.org>; Sat, 10 Jul 2021 22:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PL2ex365BMFyW6fegRkrYN1g3SJvnpB5LLT+JuMQvCE=;
        b=Kv0rUKwK0xgWgitPZ3znLrZreyRtX2pVQFtuEab+HaRvEEwdFnLRTRIoqCTJk0yfFZ
         X+4x0ObwZbhz6/k6TG2C+l/WTuCaul3nI2wBjJGQfh8n3TEo+RmC4l8hcOUCG+49bjr1
         NPf1pxhy92G0CIQNpXjTsNhCkRgv39Q4Li8hw4vn8SZBpiqb0VM99G2T0SFLK8CaLAod
         pecT3R2/+KtqIqy1pL5O80dNPilUHe95L3VhKRaq+X5EhR3zRMfzjl3hI3u0N2Lw+45d
         XvZsLAkDsHXdBNPBoLZuFI8rJ+W3CQSen2V0HIpaBR5x2gV3sj3v2vv/YH6d8uP3DIc/
         l9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PL2ex365BMFyW6fegRkrYN1g3SJvnpB5LLT+JuMQvCE=;
        b=PfQt0xePjjhrwEWcA6TTSK2u7zat2L4HEpe4xIPtdtNn8DjyHbWobk+2O9nvb6QUGt
         vlfpsWNHNOLhrfRjI7R8iR8tLxg1ycEzMGh3a1m1WObuYRxMFgLYrK2aspYekJxiiw73
         qvViQU8wah13onY4s1AebMeMY6HOHN/Htqtmbvwr6JZDtjIVFXz+alfRRCctvqzhc1oR
         UbrvvK7HMwzbXcACU5wrytHcA8wy1mbznad4vC46WPwI/7Bf2+milzwV/wNzApcMTEcZ
         +k4nEcAXs5iXpWuPSuqTp9S6ukkLABxS60v+kFzy77J81T3iu8BX0mqNOHFy3FBqrd1H
         X9Zw==
X-Gm-Message-State: AOAM532963r20nN584dOMdgNh6BaSsxV6efsNW7iHkHR04ZXj+CGfAgJ
        siWk2YJlSqPDCGHSgdmKnnQ=
X-Google-Smtp-Source: ABdhPJxSsuM+DUqln7Rx2HE8rZf6PGNRmMo5tl0lglCQrLIYV8hsiyuxdyVLt/FPumnzQece4TcKhw==
X-Received: by 2002:a05:6a00:b42:b029:31c:abd1:53ec with SMTP id p2-20020a056a000b42b029031cabd153ecmr39702662pfo.45.1625979616663;
        Sat, 10 Jul 2021 22:00:16 -0700 (PDT)
Received: from localhost.localdomain ([111.204.182.99])
        by smtp.gmail.com with ESMTPSA id u37sm11147448pfg.140.2021.07.10.22.00.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 10 Jul 2021 22:00:16 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     xiyou.wangcong@gmail.com, jhs@mojatatu.com
Cc:     netdev@vger.kernel.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [net-next 2/2] qdisc: add tracepoint qdisc:qdisc_requeue for requeued SKBs
Date:   Sun, 11 Jul 2021 13:00:07 +0800
Message-Id: <20210711050007.1200-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.30.1 (Apple Git-130)
In-Reply-To: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

The main purpose of this tracepoint is to monitor what,
how many and why packets were requeued. The txq_state can
be used for determining the reason for packets requeued.

Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 include/trace/events/qdisc.h | 32 ++++++++++++++++++++++++++++++++
 net/sched/sch_generic.c      |  8 +++++---
 2 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index b0e76237bb74..c6187a8fc103 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -78,6 +78,38 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
+TRACE_EVENT(qdisc_requeue,
+
+	TP_PROTO(struct sk_buff *skb, struct Qdisc *qdisc,
+		 const struct netdev_queue *txq),
+
+	TP_ARGS(skb, qdisc, txq),
+
+	TP_STRUCT__entry(
+		__field(	struct Qdisc *,		qdisc	)
+		__field(const	struct netdev_queue *,	txq	)
+		__field(	void *,			skbaddr	)
+		__field(	int,			ifindex	)
+		__field(	u32,			handle	)
+		__field(	u32,			parent	)
+		__field(	unsigned long,		txq_state)
+	),
+
+	TP_fast_assign(
+		__entry->qdisc		= qdisc;
+		__entry->txq		= txq;
+		__entry->skbaddr	= skb;
+		__entry->ifindex	= txq->dev ? txq->dev->ifindex : 0;
+		__entry->handle		= qdisc->handle;
+		__entry->parent		= qdisc->parent;
+		__entry->txq_state	= txq->state;
+	),
+
+	TP_printk("requeue ifindex=%d qdisc handle=0x%X parent=0x%X txq_state=0x%lX skbaddr=%p",
+		  __entry->ifindex, __entry->handle, __entry->parent,
+		  __entry->txq_state, __entry->skbaddr)
+);
+
 TRACE_EVENT(qdisc_reset,
 
 	TP_PROTO(struct Qdisc *q),
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 75605075178f..0701d1e9d221 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -137,7 +137,8 @@ static inline void qdisc_enqueue_skb_bad_txq(struct Qdisc *q,
 		spin_unlock(lock);
 }
 
-static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
+static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q,
+				   struct netdev_queue *txq)
 {
 	spinlock_t *lock = NULL;
 
@@ -149,6 +150,7 @@ static inline void dev_requeue_skb(struct sk_buff *skb, struct Qdisc *q)
 	while (skb) {
 		struct sk_buff *next = skb->next;
 
+		trace_qdisc_requeue(skb, q, txq);
 		__skb_queue_tail(&q->gso_skb, skb);
 
 		/* it's still part of the queue */
@@ -325,7 +327,7 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 		if (root_lock)
 			spin_lock(root_lock);
 
-		dev_requeue_skb(skb, q);
+		dev_requeue_skb(skb, q, txq);
 		return false;
 	}
 #endif
@@ -353,7 +355,7 @@ bool sch_direct_xmit(struct sk_buff *skb, struct Qdisc *q,
 			net_warn_ratelimited("BUG %s code %d qlen %d\n",
 					     dev->name, ret, q->q.qlen);
 
-		dev_requeue_skb(skb, q);
+		dev_requeue_skb(skb, q, txq);
 		return false;
 	}
 
-- 
2.27.0

