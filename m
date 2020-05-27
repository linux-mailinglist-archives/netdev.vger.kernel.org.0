Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 066C91E3766
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgE0Ef6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgE0Efy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66316C061A0F
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id cx22so996300pjb.1
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F3APV1bDQLXitPHVMpvETixDyrO0aAHo7NHW9tfZ46o=;
        b=Ta1CpHpM9yrM5FimLbCB8GmKTOGqxncrFr7VbJH5S1WpyyYx4D4AhHngmXatCgksWm
         KhoM9z8FKbOOr7ZvYLcL+xJq33fp6mCztZ7rfeYTwkFFRqxfN6z5SsSoB9HZFH6tXfe9
         6v3OZjM6CXpE7QP7Q4rAFViBklPbsB+7hFrPRFiBi6CgbLPpmNITrYRpQ5x64UwzTOb3
         fhmppcU+Zh7rfmuSl8E4DfIX57UjXLoWWrfpminSqcZaiBc34auH/kUwNb2XGkGfl2Fw
         RBBnGQubFaD+FTOhpa4Y1JmloF9TR6+tFGxhd7yq42+u4YxI6uqUC2WyXfOkbEV49rBT
         ldiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F3APV1bDQLXitPHVMpvETixDyrO0aAHo7NHW9tfZ46o=;
        b=rDMEF6GTvkLlf8WqQ+oIkZkehc0dd9fKf1ZjFy/QP1Mbi1keSpVNz5V4zCwjF+31Zg
         EXEURfwgQOjItyAK3NpPZNozCKSR9uZMsEU2JX6ju2SWwZwtnTKJJaXqSCp4iRFYSCFi
         AiFc/23qyA6E14u6Ep1Kleo8+HizJzwM31TbUnVcNm4+gbSzeTTKHDEbJHhehTQFHKpg
         qsZp63zUHXWFxH+xsQjNckELo8UXltX5pmpOaB+gfMIdy5nyxMKWZkna9nsDBEYxm2AE
         UJXxHAHtP/QNhMrF2CPlzhCCW8Uu9uTYBLuXGAV45dLE+BlAmYIRwoo4HPcs2MhpecR7
         CTdg==
X-Gm-Message-State: AOAM531/cVBDPmH6/AEkld9xs+fexUJ2/sccsEYC7frdYdsJysrCNFh0
        Uw9ZDL8+ASOxCMPhm1LvX9nQyp62
X-Google-Smtp-Source: ABdhPJyVgET4dWoWEiqxJyspUJtHVGXMedj4nMI8oP0vxuWSNZCGfoe2a591Ubq4dqa1n60ULXDpbw==
X-Received: by 2002:a17:902:7045:: with SMTP id h5mr4261779plt.108.1590554151743;
        Tue, 26 May 2020 21:35:51 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:51 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next 3/5] net_sched: add a tracepoint for qdisc creation
Date:   Tue, 26 May 2020 21:35:25 -0700
Message-Id: <20200527043527.12287-4-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With this tracepoint, we could know when qdisc's are created,
especially those default qdisc's.

Sample output:

  tc-736   [001] ...1    56.230107: qdisc_create: dev=ens3 kind=pfifo parent=1:0
  tc-736   [001] ...1    56.230113: qdisc_create: dev=ens3 kind=hfsc parent=ffff:ffff
  tc-738   [001] ...1    56.256816: qdisc_create: dev=ens3 kind=pfifo parent=1:100
  tc-739   [001] ...1    56.267584: qdisc_create: dev=ens3 kind=pfifo parent=1:200
  tc-740   [001] ...1    56.279649: qdisc_create: dev=ens3 kind=fq_codel parent=1:100
  tc-741   [001] ...1    56.289996: qdisc_create: dev=ens3 kind=pfifo_fast parent=1:200
  tc-745   [000] .N.1   111.687483: qdisc_create: dev=ens3 kind=ingress parent=ffff:fff1

Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 include/trace/events/qdisc.h | 23 +++++++++++++++++++++++
 net/sched/sch_api.c          |  3 +++
 net/sched/sch_generic.c      |  4 +++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/include/trace/events/qdisc.h b/include/trace/events/qdisc.h
index 2b948801afa3..330d32d84485 100644
--- a/include/trace/events/qdisc.h
+++ b/include/trace/events/qdisc.h
@@ -96,6 +96,29 @@ TRACE_EVENT(qdisc_destroy,
 		  TC_H_MAJ(__entry->handle) >> 16, TC_H_MIN(__entry->handle))
 );
 
+TRACE_EVENT(qdisc_create,
+
+	TP_PROTO(const struct Qdisc_ops *ops, struct net_device *dev, u32 parent),
+
+	TP_ARGS(ops, dev, parent),
+
+	TP_STRUCT__entry(
+		__string(	dev,		dev->name	)
+		__string(	kind,		ops->id		)
+		__field(	u32,		parent		)
+	),
+
+	TP_fast_assign(
+		__assign_str(dev, dev->name);
+		__assign_str(kind, ops->id);
+		__entry->parent = parent;
+	),
+
+	TP_printk("dev=%s kind=%s parent=%x:%x",
+		  __get_str(dev), __get_str(kind),
+		  TC_H_MAJ(__entry->parent) >> 16, TC_H_MIN(__entry->parent))
+);
+
 #endif /* _TRACE_QDISC_H */
 
 /* This part must be outside protection */
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 0d99df1e764d..9a3449b56bd6 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -32,6 +32,8 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 
+#include <trace/events/qdisc.h>
+
 /*
 
    Short review.
@@ -1283,6 +1285,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 	}
 
 	qdisc_hash_add(sch, false);
+	trace_qdisc_create(ops, dev, parent);
 
 	return sch;
 
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index abaa446ed01a..a4271e47f220 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -896,8 +896,10 @@ struct Qdisc *qdisc_create_dflt(struct netdev_queue *dev_queue,
 	}
 	sch->parent = parentid;
 
-	if (!ops->init || ops->init(sch, NULL, extack) == 0)
+	if (!ops->init || ops->init(sch, NULL, extack) == 0) {
+		trace_qdisc_create(ops, dev_queue->dev, parentid);
 		return sch;
+	}
 
 	qdisc_put(sch);
 	return NULL;
-- 
2.26.2

