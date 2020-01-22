Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2822D1453E6
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729190AbgAVLgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:15 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:34571 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAVLgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:15 -0500
Received: by mail-pf1-f193.google.com with SMTP id i6so3254803pfc.1
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=75GYGZCutiLRlVt9f9TBFKtlqNdfsesUvmoWR+mvNZE=;
        b=PQa3ctrnuHACqJB53M/OCFa3d87gn52tilb5UfVekREZqeDhiyNDQjwcEaD6CHGwwj
         A7JvBvFAIg29Yn6OQqB+A+eUCoUpJoeFBIFjqxCdzR4s9lOkvY9nOiP0cpYnhq7axFvL
         JrXGunQ+tSX8GQP0SLVhmvBCo+C2DD36UD2oC3RO5VhYUIE7iPZPE0yJP0CjkPnI7CNv
         s0u3OaXmjt2/4Kyw1rtAUYJhAWZ3ZwkJfU2ryNoaVXtWBQdwFaBf2n2m31IIOFqEbmHp
         zgz/FtvknovXvHixueJxlvi+QiHw2NzTIoS9fgHg09bKW73nVx5bumECmA0FNXtceX8T
         qAKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=75GYGZCutiLRlVt9f9TBFKtlqNdfsesUvmoWR+mvNZE=;
        b=NmVXMeLCIE0GBPzEx7BH6mkLI11lb1bDuKFwdNzlO9SFlcze4grX1AyG0zgSscm2/e
         XcQ03xq2ATV62CzrGydGFAfpk0N8EzdVWClES8sWb2a73HuWRPNJX0mJMXYC6zYtXlt1
         G78uPMp5CsahCdP3v45/yQfs5CgvybD6bhwChozii4m9CqIN+7aSHBqG+z1dCsEa3/Fj
         CddbhnwauGbCBgQ48T1Cz4dcJWQ5JlONI9i74lhlxyOhzBo3ZQ20KdtQI6QZZd0353Rw
         QkP8C5Nqn0M+OU4aVA/H7/mOpFcSRZsGdOERX4Mx0Lp4GQ04EaVfkIi5ipNGjHKiJQxK
         Yx6w==
X-Gm-Message-State: APjAAAVmAPRIUXP63tcjfwlPog+gzNfKZFGGBS91zbtGZhOR1yyHucfX
        Rmkkn10OQ3bj0OciujbBUrcbR0sh855HgZFD
X-Google-Smtp-Source: APXvYqx98d8V3lXhbokUEJptiAcrYolBjXZCmsuNMeRWLJWKQ1yRz0boY54YndtRlz5t7RSyznikbg==
X-Received: by 2002:a63:5964:: with SMTP id j36mr10701481pgm.225.1579692974143;
        Wed, 22 Jan 2020 03:36:14 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.36.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:13 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v6 05/10] pie: rearrange structure members and their initializations
Date:   Wed, 22 Jan 2020 17:05:28 +0530
Message-Id: <20200122113533.28128-6-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Rearrange the members of the structure such that closely
referenced members appear together and/or fit in the same
cacheline. Also, change the order of their initializations to
match the order in which they appear in the structure.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h   | 20 ++++++++++----------
 net/sched/sch_pie.c |  2 +-
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index f9c6a44bdb0c..ec0fbe98ec2f 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -28,13 +28,13 @@ struct pie_params {
 
 /* variables used */
 struct pie_vars {
-	u64 prob;		/* probability but scaled by u64 limit. */
-	psched_time_t burst_time;
 	psched_time_t qdelay;
 	psched_time_t qdelay_old;
-	u64 dq_count;		/* measured in bytes */
+	psched_time_t burst_time;
 	psched_time_t dq_tstamp;	/* drain rate */
+	u64 prob;		/* probability but scaled by u64 limit. */
 	u64 accu_prob;		/* accumulated drop probability */
+	u64 dq_count;		/* measured in bytes */
 	u32 avg_dq_rate;	/* bytes per pschedtime tick,scaled */
 	u32 qlen_old;		/* in bytes */
 	u8 accu_prob_overflows;	/* overflows of accu_prob */
@@ -45,8 +45,8 @@ struct pie_stats {
 	u32 packets_in;		/* total number of packets enqueued */
 	u32 dropped;		/* packets dropped due to pie_action */
 	u32 overlimit;		/* dropped due to lack of space in queue */
-	u32 maxq;		/* maximum queue size */
 	u32 ecn_mark;		/* packets marked with ECN */
+	u32 maxq;		/* maximum queue size */
 };
 
 /* private skb vars */
@@ -56,11 +56,11 @@ struct pie_skb_cb {
 
 static inline void pie_params_init(struct pie_params *params)
 {
-	params->alpha = 2;
-	params->beta = 20;
+	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
 	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
 	params->limit = 1000;	/* default of 1000 packets */
-	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
+	params->alpha = 2;
+	params->beta = 20;
 	params->ecn = false;
 	params->bytemode = false;
 	params->dq_rate_estimator = false;
@@ -68,12 +68,12 @@ static inline void pie_params_init(struct pie_params *params)
 
 static inline void pie_vars_init(struct pie_vars *vars)
 {
-	vars->dq_count = DQCOUNT_INVALID;
+	/* default of 150 ms in pschedtime */
+	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
 	vars->dq_tstamp = DTIME_INVALID;
 	vars->accu_prob = 0;
+	vars->dq_count = DQCOUNT_INVALID;
 	vars->avg_dq_rate = 0;
-	/* default of 150 ms in pschedtime */
-	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
 	vars->accu_prob_overflows = 0;
 }
 
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 7197bcaa14ba..0c583cc148f3 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -23,8 +23,8 @@
 
 /* private data for the Qdisc */
 struct pie_sched_data {
-	struct pie_params params;
 	struct pie_vars vars;
+	struct pie_params params;
 	struct pie_stats stats;
 	struct timer_list adapt_timer;
 	struct Qdisc *sch;
-- 
2.17.1

