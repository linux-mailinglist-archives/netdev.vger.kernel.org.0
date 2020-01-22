Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2E145B82
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAVSXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:11 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:32792 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:11 -0500
Received: by mail-pl1-f195.google.com with SMTP id ay11so125725plb.0
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=75GYGZCutiLRlVt9f9TBFKtlqNdfsesUvmoWR+mvNZE=;
        b=asbJKXx6kpUO5Bur7RqmjUfcEE9MnGnGsuIMxuwFd4VUwBRL9pjPK6ZAP7SLTuI/Cg
         dFshv3P/GMVb/+wM2nBkvZ/07IlYEtb6h5p0786B2XDPM5Ve3Cru5bCkasZZx3Kc4U62
         NE1eilHYBxBi9qo42OSYEdaIp7pzYjN3WBLi4X7TCc3ZWiYMUL+rRzTZqlrBH3OdYpR8
         wXju6RZeRxYTlSXTTixmnlbUTd4A6WRXfFx6Y43sAEOxe0qFnp/B4NSsrekyijhO4Qyi
         8NfB1qgrajAZTnGCTZTAwMmGdppZQSo0FC7sEV3vj94/ogPZkzYzG8P9wwUMN3Mh7KnS
         IldQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=75GYGZCutiLRlVt9f9TBFKtlqNdfsesUvmoWR+mvNZE=;
        b=jS0+7/deJnA7ePqQLmfSDtUA6TyIe2JU9UZ2eiKvg+Yhjw0ZAi9x11q2JyIrB+O2S6
         S5J8122v/5KiRv88AN1ms2hsk1268glNUEu4RfQcwFkH/pqBe0TS8v3OqaEjHkX2EqKB
         JeUomdTU1lqIKE4oaAKX7LM8Zu17YSTetZo750RwxQjwn9X0UDWmqcKbMNCrJR4d1jTe
         8EeY40gZxasjQru6/0rYdrkHVggLYFhTpWT9iFYZb3cJ879hRpej5elNw5a0KnX+H6cJ
         AD8feP4SBIGmwIc6Qyryx6gKZRKurphUzYBdPeiRHbLiUiiYIdlTACXxUyMI7yFyczU+
         TSmw==
X-Gm-Message-State: APjAAAVcK3L1EJYb2+hDGVYe0EupINvha0I9T+ItusAUliyE835GRbKY
        0irr1wAJ3WgEt3TznxtIVlyNIi7ulPnUnEGu
X-Google-Smtp-Source: APXvYqy05SDSg3iYMpd2d6I9TeQqXjLBF1sYUN3LdSCtY/LQk+frVisdYWqCucys1N8mKtbA+0v8yA==
X-Received: by 2002:a17:902:6b8a:: with SMTP id p10mr12141590plk.47.1579717390494;
        Wed, 22 Jan 2020 10:23:10 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:10 -0800 (PST)
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
Subject: [PATCH net-next v7 05/10] pie: rearrange structure members and their initializations
Date:   Wed, 22 Jan 2020 23:52:28 +0530
Message-Id: <20200122182233.3940-6-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
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

