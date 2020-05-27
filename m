Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DD11E3764
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbgE0Efz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726940AbgE0Efv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:51 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61342C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:51 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id y11so1383341plt.12
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2LR68rDfef3Rh3b3aPS44MpNQlD/eUSByH7cWCZzVh8=;
        b=Wm8kzVfiIN71TIig2dl/cipqy75HZGb/bXRG9RVybFpRnXgyJGtzxr9ea16hbuWTOL
         688dWr82k5Batf4amblTB4KYD1BtBjbIG1mZEy+WR72Egf1CADnBXvLoNTfiIbRZOctH
         aRF6nn5qCp8/cFX2YpEp4/zZIowrWX/STAayOZffbUV/msTyMYa9IQY6M2I+l1yGpIxI
         x+c41JilMaJ7DASGh4OTggLcDLwmO38hkkqw0TKQxI7ot6KKs8lpMSBCiqLE0wrgaVaL
         Z3GLQNZTDCgtre0OhMASCVCVCyljT3I/qmz2ruoNFy+PK5KJF+cuzXHjeQi3QGTVRtHv
         HcBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2LR68rDfef3Rh3b3aPS44MpNQlD/eUSByH7cWCZzVh8=;
        b=seFxeSqUv605DvWsHh07wcwB1WTdRIQ0v7EKwOsjRHRU09vtj2Vt3UuHdjSzoiZKoT
         K/gJ9bZDfn8tDj4T2RDOJLAzm2I5KKm6jv4rMBAjDnV1PHqRFgXmEvxEQN9pkXCGLAhX
         EWN+yewixWl98jPjjHIotV46nbKiFrb6u/GrzMg5ZdoEZod8nSgdDjn9majPc/gq611q
         XF/qnqDopNi9x1RBTBsFlkpa4ft4YBowDrdnZ456N3bUWAnKaDPiCkXUbUd2cqyY3boh
         d5rrR4K5Mmgc5GrmZXkIr5hC5/h6rTQhG5Sjo1p6ru6SBfLmopCvYiAtsuH4GUtJUVU+
         1q/w==
X-Gm-Message-State: AOAM53278THDp4kd4pyFPuKrFSASEDYBQFCaxnohVTyQYyvO2PVRWz5t
        1g5XWo8mMVpQ9qxWvvIYNRoYDrSE
X-Google-Smtp-Source: ABdhPJw/idpWYzAnWptBn2wwnl0J1HJ+A+vPFUM50rHa1/0eIKCcUkxKheiMRrcB8U1uwFrwvN1ZIA==
X-Received: by 2002:a17:90a:21cf:: with SMTP id q73mr2836120pjc.230.1590554150669;
        Tue, 26 May 2020 21:35:50 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:50 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next 2/5] net_sched: add tracepoints for qdisc_reset() and qdisc_destroy()
Date:   Tue, 26 May 2020 21:35:24 -0700
Message-Id: <20200527043527.12287-3-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add two tracepoints for qdisc_reset() and qdisc_destroy() to track
qdisc resetting and destroying.

Sample output:

  tc-756   [000] ...3   138.355662: qdisc_reset: dev=ens3 kind=pfifo_fast parent=ffff:ffff handle=0:0
  tc-756   [000] ...1   138.355720: qdisc_reset: dev=ens3 kind=pfifo_fast parent=ffff:ffff handle=0:0
  tc-756   [000] ...1   138.355867: qdisc_reset: dev=ens3 kind=pfifo_fast parent=ffff:ffff handle=0:0
  tc-756   [000] ...1   138.355930: qdisc_destroy: dev=ens3 kind=pfifo_fast parent=ffff:ffff handle=0:0
  tc-757   [000] ...2   143.073780: qdisc_reset: dev=ens3 kind=fq_codel parent=ffff:ffff handle=8001:0
  tc-757   [000] ...1   143.073878: qdisc_reset: dev=ens3 kind=fq_codel parent=ffff:ffff handle=8001:0
  tc-757   [000] ...1   143.074114: qdisc_reset: dev=ens3 kind=fq_codel parent=ffff:ffff handle=8001:0
  tc-757   [000] ...1   143.074228: qdisc_destroy: dev=ens3 kind=fq_codel parent=ffff:ffff handle=8001:0

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/trace/events/qdisc.h | 52 ++++++++++++++++++++++++++++++++++++
 net/sched/sch_generic.c      |  4 +++
 2 files changed, 56 insertions(+)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 0d1a9ebf55ba..2b948801afa3 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -8,6 +8,8 @@
 #include <linux/netdevice.h>
 #include <linux/tracepoint.h>
 #include <linux/ftrace.h>
+#include <linux/pkt_sched.h>
+#include <net/sch_generic.h>
 
 TRACE_EVENT(qdisc_dequeue,
 
@@ -44,6 +46,56 @@ TRACE_EVENT(qdisc_dequeue,
 		  __entry->txq_state, __entry->packets, __entry->skbaddr )
 );
 
+TRACE_EVENT(qdisc_reset,
+
+	TP_PROTO(struct Qdisc *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__string(	dev,		qdisc_dev(q)	)
+		__string(	kind,		q->ops->id	)
+		__field(	u32,		parent		)
+		__field(	u32,		handle		)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, qdisc_dev(q));
+		__assign_str(kind, q->ops->id);
+		__entry->parent = q->parent;
+		__entry->handle = q->handle;
+	),
+
+	TP_printk("dev=%s kind=%s parent=%x:%x handle=%x:%x", __get_str(dev),
+		  __get_str(kind), TC_H_MAJ(__entry->parent) >> 16, TC_H_MIN(__entry->parent),
+		  TC_H_MAJ(__entry->handle) >> 16, TC_H_MIN(__entry->handle))
+);
+
+TRACE_EVENT(qdisc_destroy,
+
+	TP_PROTO(struct Qdisc *q),
+
+	TP_ARGS(q),
+
+	TP_STRUCT__entry(
+		__string(	dev,		qdisc_dev(q)	)
+		__string(	kind,		q->ops->id	)
+		__field(	u32,		parent		)
+		__field(	u32,		handle		)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, qdisc_dev(q));
+		__assign_str(kind, q->ops->id);
+		__entry->parent = q->parent;
+		__entry->handle = q->handle;
+	),
+
+	TP_printk("dev=%s kind=%s parent=%x:%x handle=%x:%x", __get_str(dev),
+		  __get_str(kind), TC_H_MAJ(__entry->parent) >> 16, TC_H_MIN(__entry->parent),
+		  TC_H_MAJ(__entry->handle) >> 16, TC_H_MIN(__entry->handle))
+);
+
 #endif /* _TRACE_QDISC_H */
 
 /* This part must be outside protection */
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 7a0b06001e48..abaa446ed01a 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -911,6 +911,8 @@ void qdisc_reset(struct Qdisc *qdisc)
 	const struct Qdisc_ops *ops = qdisc->ops;
 	struct sk_buff *skb, *tmp;
 
+	trace_qdisc_reset(qdisc);
+
 	if (ops->reset)
 		ops->reset(qdisc);
 
@@ -965,6 +967,8 @@ static void qdisc_destroy(struct Qdisc *qdisc)
 	module_put(ops->owner);
 	dev_put(qdisc_dev(qdisc));
 
+	trace_qdisc_destroy(qdisc);
+
 	call_rcu(&qdisc->rcu, qdisc_free_cb);
 }
 
-- 
2.26.2

