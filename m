Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA0FD12D836
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 12:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfLaLYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 06:24:15 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:41930 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfLaLYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Dec 2019 06:24:15 -0500
Received: by mail-pl1-f193.google.com with SMTP id bd4so15816255plb.8
        for <netdev@vger.kernel.org>; Tue, 31 Dec 2019 03:24:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M/RJeP9O5uv/7I2Un+TvGnDganXVliStI5l7/wLlTng=;
        b=Y6MBzRazsfVay1n4xlWGk2xrOUbTyN+Hq+o5p2qApeSg+8AMG1qV5Inb0ZanZtDQyL
         1ejxHwcRoPCTtHMAgTdS/3sdX+rVhWSaYZIwKhWt4tEHp4RiyELlxD6fub+pAarYUzMK
         FgT0fKvE84sCFQdrxpP4ZuX2ipnjkYhf1kBIZykWjhj6Ap0YrpAxnLawVXjS7i+qFhpg
         HysPWcHYu/G8PxsWyjMK6AA+YxCm0h1VQgG0KWLIrma8m3SFaCgQIJ8UiWXjR0ZmzR6p
         6fBV4XFCoG8ExSrCo2Z34VGFNQ/RAJarGOY8AkeUBe89//OwHChQr/b13KzFBrBsC5+n
         VHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M/RJeP9O5uv/7I2Un+TvGnDganXVliStI5l7/wLlTng=;
        b=IuepRFlH81MLa4d2kHbKhouhgtW0tGxnutRCTsYvoRiLZWq8R7uR5bih7E4TZO+nIT
         +qb/Q1b876UUKpITBOrd/KdDr/9O9iXxw1mahBm9iotgEB1uXw4v/LMEyjcnNX+OBrk4
         q2DP+kopYgPzcI8+AKrBgpmTOUmOSpDmRfVBAuzI5oe1425Yj9ljphKphjnlgyiInPLJ
         /vSyvSo8iGyuMdr1HncCwL7Swc8E72NRksu7U1tM4/bBCFIwr7dzHhkcbQeuMqETp8R3
         F7ly53s59DsrvVjOTC1GpwFO0Nt16+YZL9lrXInmQOAAdSJUiG/SesoXwUkWU9HBYP3c
         AfJQ==
X-Gm-Message-State: APjAAAVGRCaJW8h3oJxql8cV9xfcrgF+QsExT/HlXhggTjbcMz4yYc8P
        +XKHI47TA04xgYXSMJOx49UzEoLvLr33Ug==
X-Google-Smtp-Source: APXvYqzvrnWxXf1voIHAu8FECHQsJJ4FtMnGnbnTrA1RkFnDkxtQrbcVmyqjhR/RBql9nzhG5NG/rQ==
X-Received: by 2002:a17:90b:3d0:: with SMTP id go16mr5646344pjb.75.1577791453173;
        Tue, 31 Dec 2019 03:24:13 -0800 (PST)
Received: from localhost.localdomain ([223.186.204.218])
        by smtp.gmail.com with ESMTPSA id 68sm51208848pge.14.2019.12.31.03.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Dec 2019 03:24:12 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Leslie Monis <lesliemonis@gmail.com>,
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v2 1/2] net: sched: pie: refactor code
Date:   Tue, 31 Dec 2019 16:53:15 +0530
Message-Id: <20191231112316.2788-2-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191231112316.2788-1-gautamramk@gmail.com>
References: <20191231112316.2788-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

This patch is a precursor for the addition of the Flow Queue Proportional
Integral Controller Enhanced (FQ-PIE) qdisc. The patch removes functions
and structures common to both PIE and FQ-PIE and moves it to the
header file pie.h

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h   | 400 ++++++++++++++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c | 386 ++----------------------------------------
 2 files changed, 415 insertions(+), 371 deletions(-)
 create mode 100644 include/net/pie.h

diff --git a/include/net/pie.h b/include/net/pie.h
new file mode 100644
index 000000000000..09f074d273e9
--- /dev/null
+++ b/include/net/pie.h
@@ -0,0 +1,400 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __NET_SCHED_PIE_H
+#define __NET_SCHED_PIE_H
+
+#include <linux/ktime.h>
+#include <linux/skbuff.h>
+#include <linux/types.h>
+#include <net/inet_ecn.h>
+#include <net/pkt_sched.h>
+
+#define QUEUE_THRESHOLD 16384
+#define PIE_SCALE 8
+#define DQCOUNT_INVALID -1
+#define DTIME_INVALID 0xffffffffffffffff
+#define MAX_PROB 0xffffffffffffffff
+
+/**
+ * struct pie_params - contains pie parameters
+ * @target: target delay in pschedtime
+ * @tudpate: interval at which drop probability is calculated
+ * @limit: total number of packets that can be in the queue
+ * @alpha: parameter to control drop probability
+ * @beta: parameter to control drop probability
+ * @ecn: whether to enable ECN marking of packets
+ * @bytemode: whether to scale drop prob based on pkt size
+ * @dq_rate_estimator: whether to use little's law for qdelay calculation
+ */
+struct pie_params {
+	psched_time_t target;
+	u32 tupdate;
+	u32 limit;
+	u32 alpha;
+	u32 beta;
+	u8 ecn;
+	u8 bytemode;
+	u8 dq_rate_estimator;
+};
+
+/**
+ * struct pie_vars - contains pie variables
+ * @burst_time: burst time allowance
+ * @qdelay: current queue delay
+ * @qdelay_old: queue delay in previous qdelay calculation
+ * @dq_tstamp: last instance at which dq rate was calculated
+ * @prob: drop probability
+ * @dq_count: number of bytes dequeued in a measurement cycle
+ * @accu_prob: accumulated drop probability
+ * @avg_dq_rate: calculated average dq rate
+ * @qlen_old: queue length during previous qdelay calculation
+ * @accu_prob_overflow: whether accu_prob overflowed
+ */
+struct pie_vars {
+	psched_time_t burst_time;
+	psched_time_t qdelay;
+	psched_time_t qdelay_old;
+	psched_time_t dq_tstamp;
+	u64 prob;
+	u64 dq_count;
+	u64 accu_prob;
+	u32 avg_dq_rate;
+	u32 qlen_old;
+	u8 accu_prob_overflows;
+};
+
+/**
+ * struct pie_stats - contains pie stats
+ * @packets_in: total number of packets enqueued
+ * @dropped: packets dropped due to pie action
+ * @overlimit: packets dropped due to lack of space in queue
+ * @maxq: maximum queue size
+ * @ecn_mark: packets marked with ECN
+ */
+struct pie_stats {
+	u32 packets_in;
+	u32 dropped;
+	u32 overlimit;
+	u32 maxq;
+	u32 ecn_mark;
+};
+
+static void pie_params_init(struct pie_params *params)
+{
+	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
+	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
+	params->limit = 1000; /* in packets */
+	params->alpha = 2;
+	params->beta = 20;
+	params->ecn = false;
+	params->bytemode = false;
+	params->dq_rate_estimator = false;
+}
+
+static void pie_vars_init(struct pie_vars *vars)
+{
+	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC); /* 150 ms */
+	vars->dq_count = DQCOUNT_INVALID;
+	vars->dq_tstamp = DTIME_INVALID;
+	vars->accu_prob = 0;
+	vars->avg_dq_rate = 0;
+	vars->accu_prob_overflows = 0;
+}
+
+/* private skb vars */
+struct pie_skb_cb {
+	psched_time_t enqueue_time;
+};
+
+static struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
+	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static psched_time_t pie_get_enqueue_time(const struct sk_buff *skb)
+{
+	return get_pie_cb(skb)->enqueue_time;
+}
+
+static void pie_set_enqueue_time(struct sk_buff *skb)
+{
+	get_pie_cb(skb)->enqueue_time = psched_get_time();
+}
+
+static bool drop_early(struct Qdisc *sch, struct pie_params *params,
+		       struct pie_vars *vars, u32 backlog, u32 packet_size)
+{
+	u64 rnd;
+	u64 local_prob = vars->prob;
+	u32 mtu = psched_mtu(qdisc_dev(sch)); /* device MTU */
+
+	/* If there is still burst allowance left skip random early drop */
+	if (vars->burst_time > 0)
+		return false;
+
+	/* If current delay is less than half of target, and
+	 * if drop prob is low already, disable early_drop
+	 */
+	if ((vars->qdelay < params->target / 2) &&
+	    (vars->prob < MAX_PROB / 5))
+		return false;
+
+	/* If we have fewer than 2 mtu-sized packets, disable drop_early,
+	 * similar to min_th in RED
+	 */
+	if (backlog < 2 * mtu)
+		return false;
+
+	/* If bytemode is turned on, use packet size to compute new
+	 * probablity. Smaller packets will have lower drop prob in this case
+	 */
+	if (params->bytemode && packet_size <= mtu)
+		local_prob = (u64)packet_size * div_u64(local_prob, mtu);
+	else
+		local_prob = vars->prob;
+
+	if (local_prob == 0) {
+		vars->accu_prob = 0;
+		vars->accu_prob_overflows = 0;
+	}
+
+	if (local_prob > MAX_PROB - vars->accu_prob)
+		vars->accu_prob_overflows++;
+
+	vars->accu_prob += local_prob;
+
+	if (vars->accu_prob_overflows == 0 &&
+	    vars->accu_prob < (MAX_PROB / 100) * 85)
+		return false;
+	if (vars->accu_prob_overflows == 8 &&
+	    vars->accu_prob >= MAX_PROB / 2)
+		return true;
+
+	prandom_bytes(&rnd, 8);
+	if (rnd < local_prob) {
+		vars->accu_prob = 0;
+		vars->accu_prob_overflows = 0;
+		return true;
+	}
+
+	return false;
+}
+
+static void pie_process_dequeue(struct sk_buff *skb,
+				struct pie_params *params,
+				struct pie_vars *vars, u32 backlog)
+{
+	psched_time_t now = psched_get_time();
+	u32 qlen = backlog;	/* current queue size in bytes */
+	u32 dtime = 0;
+
+	/* If dq_rate_estimator is disabled, calculate qdelay using the
+	 * packet timestamp.
+	 */
+	if (!params->dq_rate_estimator) {
+		vars->qdelay = now - pie_get_enqueue_time(skb);
+
+		if (vars->dq_tstamp != DTIME_INVALID)
+			dtime = now - vars->dq_tstamp;
+
+		vars->dq_tstamp = now;
+
+		if (qlen == 0)
+			vars->qdelay = 0;
+
+		if (dtime == 0)
+			return;
+
+		goto burst_allowance_reduction;
+	}
+
+	/* If current queue is about 10 packets or more and dq_count is unset
+	 * we have enough packets to calculate the drain rate. Save
+	 * current time as dq_tstamp and start measurement cycle.
+	 */
+	if (qlen >= QUEUE_THRESHOLD && vars->dq_count == DQCOUNT_INVALID) {
+		vars->dq_tstamp = psched_get_time();
+		vars->dq_count = 0;
+	}
+
+	/* Calculate the average drain rate from this value. If queue length
+	 * has receded to a small value viz., <= QUEUE_THRESHOLD bytes, reset
+	 * the dq_count to -1 as we don't have enough packets to calculate the
+	 * drain rate anymore. The following if block is entered only when we
+	 * have a substantial queue built up (QUEUE_THRESHOLD bytes or more)
+	 * and we calculate the drain rate for the threshold here.  dq_count is
+	 * in bytes, time difference in psched_time, hence rate is in
+	 * bytes/psched_time.
+	 */
+	if (vars->dq_count != DQCOUNT_INVALID) {
+		vars->dq_count += skb->len;
+
+		if (vars->dq_count >= QUEUE_THRESHOLD) {
+			u32 count = vars->dq_count << PIE_SCALE;
+
+			dtime = now - vars->dq_tstamp;
+
+			if (dtime == 0)
+				return;
+
+			count = count / dtime;
+
+			if (vars->avg_dq_rate == 0)
+				vars->avg_dq_rate = count;
+			else
+				vars->avg_dq_rate =
+				    (vars->avg_dq_rate -
+				     (vars->avg_dq_rate >> 3)) + (count >> 3);
+
+			/* If the queue has receded below the threshold, we hold
+			 * on to the last drain rate calculated, else we reset
+			 * dq_count to 0 to re-enter the if block when the next
+			 * packet is dequeued
+			 */
+			if (qlen < QUEUE_THRESHOLD) {
+				vars->dq_count = DQCOUNT_INVALID;
+			} else {
+				vars->dq_count = 0;
+				vars->dq_tstamp = psched_get_time();
+			}
+
+			goto burst_allowance_reduction;
+		}
+	}
+
+	return;
+
+burst_allowance_reduction:
+	if (vars->burst_time > 0) {
+		if (vars->burst_time > dtime)
+			vars->burst_time -= dtime;
+		else
+			vars->burst_time = 0;
+	}
+}
+
+static void calculate_probability(struct pie_params *params,
+				  struct pie_vars *vars, u32 backlog)
+{
+	psched_time_t qdelay = 0;
+	psched_time_t qdelay_old = 0;
+	s64 delta = 0; /* determines the change in probability */
+	u64 oldprob;
+	u64 alpha;
+	u64 beta;
+	u32 power;
+	u32 qlen = backlog; /* queue size in bytes */
+	u8  update_prob = true;
+
+	if (params->dq_rate_estimator) {
+		qdelay_old = vars->qdelay;
+		vars->qdelay_old = vars->qdelay;
+
+		if (vars->avg_dq_rate > 0)
+			qdelay = (qlen << PIE_SCALE) / vars->avg_dq_rate;
+		else
+			qdelay = 0;
+	} else {
+		qdelay = vars->qdelay;
+		qdelay_old = vars->qdelay_old;
+	}
+
+	/* If qdelay is zero and qlen is not, it means qlen is very small,
+	 * so we do not update probabilty in this round.
+	 */
+	if (qdelay == 0 && qlen != 0)
+		update_prob = false;
+
+	/* In the algorithm, alpha and beta are between 0 and 2 with typical
+	 * value for alpha as 0.125. In this implementation, we use values 0-32
+	 * passed from user space to represent this. Also, alpha and beta have
+	 * unit of HZ and need to be scaled before they can used to update
+	 * probability. alpha/beta are updated locally below by scaling down
+	 * by 16 to come to 0-2 range.
+	 */
+	alpha = ((u64)params->alpha * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
+	beta = ((u64)params->beta * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
+
+	/* We scale alpha and beta differently depending on how heavy the
+	 * congestion is. Please see RFC 8033 for details.
+	 */
+	if (vars->prob < MAX_PROB / 10) {
+		alpha >>= 1;
+		beta >>= 1;
+
+		power = 100;
+		while (vars->prob < div_u64(MAX_PROB, power) &&
+		       power <= 1000000) {
+			alpha >>= 2;
+			beta >>= 2;
+			power *= 10;
+		}
+	}
+
+	/* alpha and beta should be between 0 and 32, in multiples of 1/16 */
+	delta += alpha * (u64)(qdelay - params->target);
+	delta += beta * (u64)(qdelay - qdelay_old);
+
+	oldprob = vars->prob;
+
+	/* to ensure we increase probability in steps of no more than 2% */
+	if (delta > (s64)(MAX_PROB / (100 / 2)) &&
+	    vars->prob >= MAX_PROB / 10)
+		delta = (MAX_PROB / 100) * 2;
+
+	/* Non-linear drop:
+	 * Tune drop probability to increase quickly for high delays(>= 250ms)
+	 * 250ms is derived through experiments and provides error protection
+	 */
+
+	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
+		delta += MAX_PROB / (100 / 2);
+
+	vars->prob += delta;
+
+	if (delta > 0) {
+		/* prevent overflow */
+		if (vars->prob < oldprob) {
+			vars->prob = MAX_PROB;
+			/* Prevent normalization error. If probability is at
+			 * maximum value already, we normalize it here, and
+			 * skip the check to do a non-linear drop in the next
+			 * section.
+			 */
+			update_prob = false;
+		}
+	} else {
+		/* prevent underflow */
+		if (vars->prob > oldprob)
+			vars->prob = 0;
+	}
+
+	/* Non-linear drop in probability: Reduce drop probability quickly if
+	 * delay is 0 for 2 consecutive Tupdate periods.
+	 */
+
+	if (qdelay == 0 && qdelay_old == 0 && update_prob)
+		/* Reduce drop probability to 98.4% */
+		vars->prob -= vars->prob / 64;
+
+	vars->qdelay = qdelay;
+	vars->qlen_old = qlen;
+
+	/* We restart the measurement cycle if the following conditions are met
+	 * 1. If the delay has been low for 2 consecutive Tupdate periods
+	 * 2. Calculated drop probability is zero
+	 * 3. If average dq_rate_estimator is enabled, we have atleast one
+	 *    estimate for the avg_dq_rate ie., is a non-zero value
+	 */
+	if ((vars->qdelay < params->target / 2) &&
+	    (vars->qdelay_old < params->target / 2) &&
+	    vars->prob == 0 &&
+	    (!params->dq_rate_estimator || vars->avg_dq_rate > 0)) {
+		pie_vars_init(vars);
+	}
+
+	if (!params->dq_rate_estimator)
+		vars->qdelay_old = qdelay;
+}
+
+#endif
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index b0b0dc46af61..9727614fd37a 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -19,47 +19,7 @@
 #include <linux/skbuff.h>
 #include <net/pkt_sched.h>
 #include <net/inet_ecn.h>
-
-#define QUEUE_THRESHOLD 16384
-#define DQCOUNT_INVALID -1
-#define DTIME_INVALID 0xffffffffffffffff
-#define MAX_PROB 0xffffffffffffffff
-#define PIE_SCALE 8
-
-/* parameters used */
-struct pie_params {
-	psched_time_t target;	/* user specified target delay in pschedtime */
-	u32 tupdate;		/* timer frequency (in jiffies) */
-	u32 limit;		/* number of packets that can be enqueued */
-	u32 alpha;		/* alpha and beta are between 0 and 32 */
-	u32 beta;		/* and are used for shift relative to 1 */
-	bool ecn;		/* true if ecn is enabled */
-	bool bytemode;		/* to scale drop early prob based on pkt size */
-	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
-};
-
-/* variables used */
-struct pie_vars {
-	u64 prob;		/* probability but scaled by u64 limit. */
-	psched_time_t burst_time;
-	psched_time_t qdelay;
-	psched_time_t qdelay_old;
-	u64 dq_count;		/* measured in bytes */
-	psched_time_t dq_tstamp;	/* drain rate */
-	u64 accu_prob;		/* accumulated drop probability */
-	u32 avg_dq_rate;	/* bytes per pschedtime tick,scaled */
-	u32 qlen_old;		/* in bytes */
-	u8 accu_prob_overflows;	/* overflows of accu_prob */
-};
-
-/* statistics gathering */
-struct pie_stats {
-	u32 packets_in;		/* total number of packets enqueued */
-	u32 dropped;		/* packets dropped due to pie_action */
-	u32 overlimit;		/* dropped due to lack of space in queue */
-	u32 maxq;		/* maximum queue size */
-	u32 ecn_mark;		/* packets marked with ECN */
-};
+#include <net/pie.h>
 
 /* private data for the Qdisc */
 struct pie_sched_data {
@@ -70,109 +30,6 @@ struct pie_sched_data {
 	struct Qdisc *sch;
 };
 
-static void pie_params_init(struct pie_params *params)
-{
-	params->alpha = 2;
-	params->beta = 20;
-	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
-	params->limit = 1000;	/* default of 1000 packets */
-	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
-	params->ecn = false;
-	params->bytemode = false;
-	params->dq_rate_estimator = false;
-}
-
-/* private skb vars */
-struct pie_skb_cb {
-	psched_time_t enqueue_time;
-};
-
-static struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
-{
-	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
-	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
-}
-
-static psched_time_t pie_get_enqueue_time(const struct sk_buff *skb)
-{
-	return get_pie_cb(skb)->enqueue_time;
-}
-
-static void pie_set_enqueue_time(struct sk_buff *skb)
-{
-	get_pie_cb(skb)->enqueue_time = psched_get_time();
-}
-
-static void pie_vars_init(struct pie_vars *vars)
-{
-	vars->dq_count = DQCOUNT_INVALID;
-	vars->dq_tstamp = DTIME_INVALID;
-	vars->accu_prob = 0;
-	vars->avg_dq_rate = 0;
-	/* default of 150 ms in pschedtime */
-	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
-	vars->accu_prob_overflows = 0;
-}
-
-static bool drop_early(struct Qdisc *sch, u32 packet_size)
-{
-	struct pie_sched_data *q = qdisc_priv(sch);
-	u64 rnd;
-	u64 local_prob = q->vars.prob;
-	u32 mtu = psched_mtu(qdisc_dev(sch));
-
-	/* If there is still burst allowance left skip random early drop */
-	if (q->vars.burst_time > 0)
-		return false;
-
-	/* If current delay is less than half of target, and
-	 * if drop prob is low already, disable early_drop
-	 */
-	if ((q->vars.qdelay < q->params.target / 2) &&
-	    (q->vars.prob < MAX_PROB / 5))
-		return false;
-
-	/* If we have fewer than 2 mtu-sized packets, disable drop_early,
-	 * similar to min_th in RED
-	 */
-	if (sch->qstats.backlog < 2 * mtu)
-		return false;
-
-	/* If bytemode is turned on, use packet size to compute new
-	 * probablity. Smaller packets will have lower drop prob in this case
-	 */
-	if (q->params.bytemode && packet_size <= mtu)
-		local_prob = (u64)packet_size * div_u64(local_prob, mtu);
-	else
-		local_prob = q->vars.prob;
-
-	if (local_prob == 0) {
-		q->vars.accu_prob = 0;
-		q->vars.accu_prob_overflows = 0;
-	}
-
-	if (local_prob > MAX_PROB - q->vars.accu_prob)
-		q->vars.accu_prob_overflows++;
-
-	q->vars.accu_prob += local_prob;
-
-	if (q->vars.accu_prob_overflows == 0 &&
-	    q->vars.accu_prob < (MAX_PROB / 100) * 85)
-		return false;
-	if (q->vars.accu_prob_overflows == 8 &&
-	    q->vars.accu_prob >= MAX_PROB / 2)
-		return true;
-
-	prandom_bytes(&rnd, 8);
-	if (rnd < local_prob) {
-		q->vars.accu_prob = 0;
-		q->vars.accu_prob_overflows = 0;
-		return true;
-	}
-
-	return false;
-}
-
 static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 			     struct sk_buff **to_free)
 {
@@ -184,7 +41,8 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		goto out;
 	}
 
-	if (!drop_early(sch, skb->len)) {
+	if (!drop_early(sch, &q->params, &q->vars, sch->qstats.backlog,
+			skb->len)) {
 		enqueue = true;
 	} else if (q->params.ecn && (q->vars.prob <= MAX_PROB / 10) &&
 		   INET_ECN_set_ce(skb)) {
@@ -216,14 +74,14 @@ static int pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 }
 
 static const struct nla_policy pie_policy[TCA_PIE_MAX + 1] = {
-	[TCA_PIE_TARGET] = {.type = NLA_U32},
-	[TCA_PIE_LIMIT] = {.type = NLA_U32},
-	[TCA_PIE_TUPDATE] = {.type = NLA_U32},
-	[TCA_PIE_ALPHA] = {.type = NLA_U32},
-	[TCA_PIE_BETA] = {.type = NLA_U32},
-	[TCA_PIE_ECN] = {.type = NLA_U32},
-	[TCA_PIE_BYTEMODE] = {.type = NLA_U32},
-	[TCA_PIE_DQ_RATE_ESTIMATOR] = {.type = NLA_U32},
+	[TCA_PIE_TARGET]		= {.type = NLA_U32},
+	[TCA_PIE_LIMIT]			= {.type = NLA_U32},
+	[TCA_PIE_TUPDATE]		= {.type = NLA_U32},
+	[TCA_PIE_ALPHA]			= {.type = NLA_U32},
+	[TCA_PIE_BETA]			= {.type = NLA_U32},
+	[TCA_PIE_ECN]			= {.type = NLA_U32},
+	[TCA_PIE_BYTEMODE]		= {.type = NLA_U32},
+	[TCA_PIE_DQ_RATE_ESTIMATOR]	= {.type = NLA_U32},
 };
 
 static int pie_change(struct Qdisc *sch, struct nlattr *opt,
@@ -296,221 +154,6 @@ static int pie_change(struct Qdisc *sch, struct nlattr *opt,
 	return 0;
 }
 
-static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
-{
-	struct pie_sched_data *q = qdisc_priv(sch);
-	int qlen = sch->qstats.backlog;	/* current queue size in bytes */
-	psched_time_t now = psched_get_time();
-	u32 dtime = 0;
-
-	/* If dq_rate_estimator is disabled, calculate qdelay using the
-	 * packet timestamp.
-	 */
-	if (!q->params.dq_rate_estimator) {
-		q->vars.qdelay = now - pie_get_enqueue_time(skb);
-
-		if (q->vars.dq_tstamp != DTIME_INVALID)
-			dtime = now - q->vars.dq_tstamp;
-
-		q->vars.dq_tstamp = now;
-
-		if (qlen == 0)
-			q->vars.qdelay = 0;
-
-		if (dtime == 0)
-			return;
-
-		goto burst_allowance_reduction;
-	}
-
-	/* If current queue is about 10 packets or more and dq_count is unset
-	 * we have enough packets to calculate the drain rate. Save
-	 * current time as dq_tstamp and start measurement cycle.
-	 */
-	if (qlen >= QUEUE_THRESHOLD && q->vars.dq_count == DQCOUNT_INVALID) {
-		q->vars.dq_tstamp = psched_get_time();
-		q->vars.dq_count = 0;
-	}
-
-	/* Calculate the average drain rate from this value.  If queue length
-	 * has receded to a small value viz., <= QUEUE_THRESHOLD bytes,reset
-	 * the dq_count to -1 as we don't have enough packets to calculate the
-	 * drain rate anymore The following if block is entered only when we
-	 * have a substantial queue built up (QUEUE_THRESHOLD bytes or more)
-	 * and we calculate the drain rate for the threshold here.  dq_count is
-	 * in bytes, time difference in psched_time, hence rate is in
-	 * bytes/psched_time.
-	 */
-	if (q->vars.dq_count != DQCOUNT_INVALID) {
-		q->vars.dq_count += skb->len;
-
-		if (q->vars.dq_count >= QUEUE_THRESHOLD) {
-			u32 count = q->vars.dq_count << PIE_SCALE;
-
-			dtime = now - q->vars.dq_tstamp;
-
-			if (dtime == 0)
-				return;
-
-			count = count / dtime;
-
-			if (q->vars.avg_dq_rate == 0)
-				q->vars.avg_dq_rate = count;
-			else
-				q->vars.avg_dq_rate =
-				    (q->vars.avg_dq_rate -
-				     (q->vars.avg_dq_rate >> 3)) + (count >> 3);
-
-			/* If the queue has receded below the threshold, we hold
-			 * on to the last drain rate calculated, else we reset
-			 * dq_count to 0 to re-enter the if block when the next
-			 * packet is dequeued
-			 */
-			if (qlen < QUEUE_THRESHOLD) {
-				q->vars.dq_count = DQCOUNT_INVALID;
-			} else {
-				q->vars.dq_count = 0;
-				q->vars.dq_tstamp = psched_get_time();
-			}
-
-			goto burst_allowance_reduction;
-		}
-	}
-
-	return;
-
-burst_allowance_reduction:
-	if (q->vars.burst_time > 0) {
-		if (q->vars.burst_time > dtime)
-			q->vars.burst_time -= dtime;
-		else
-			q->vars.burst_time = 0;
-	}
-}
-
-static void calculate_probability(struct Qdisc *sch)
-{
-	struct pie_sched_data *q = qdisc_priv(sch);
-	u32 qlen = sch->qstats.backlog;	/* queue size in bytes */
-	psched_time_t qdelay = 0;	/* in pschedtime */
-	psched_time_t qdelay_old = 0;	/* in pschedtime */
-	s64 delta = 0;		/* determines the change in probability */
-	u64 oldprob;
-	u64 alpha, beta;
-	u32 power;
-	bool update_prob = true;
-
-	if (q->params.dq_rate_estimator) {
-		qdelay_old = q->vars.qdelay;
-		q->vars.qdelay_old = q->vars.qdelay;
-
-		if (q->vars.avg_dq_rate > 0)
-			qdelay = (qlen << PIE_SCALE) / q->vars.avg_dq_rate;
-		else
-			qdelay = 0;
-	} else {
-		qdelay = q->vars.qdelay;
-		qdelay_old = q->vars.qdelay_old;
-	}
-
-	/* If qdelay is zero and qlen is not, it means qlen is very small, less
-	 * than dequeue_rate, so we do not update probabilty in this round
-	 */
-	if (qdelay == 0 && qlen != 0)
-		update_prob = false;
-
-	/* In the algorithm, alpha and beta are between 0 and 2 with typical
-	 * value for alpha as 0.125. In this implementation, we use values 0-32
-	 * passed from user space to represent this. Also, alpha and beta have
-	 * unit of HZ and need to be scaled before they can used to update
-	 * probability. alpha/beta are updated locally below by scaling down
-	 * by 16 to come to 0-2 range.
-	 */
-	alpha = ((u64)q->params.alpha * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
-	beta = ((u64)q->params.beta * (MAX_PROB / PSCHED_TICKS_PER_SEC)) >> 4;
-
-	/* We scale alpha and beta differently depending on how heavy the
-	 * congestion is. Please see RFC 8033 for details.
-	 */
-	if (q->vars.prob < MAX_PROB / 10) {
-		alpha >>= 1;
-		beta >>= 1;
-
-		power = 100;
-		while (q->vars.prob < div_u64(MAX_PROB, power) &&
-		       power <= 1000000) {
-			alpha >>= 2;
-			beta >>= 2;
-			power *= 10;
-		}
-	}
-
-	/* alpha and beta should be between 0 and 32, in multiples of 1/16 */
-	delta += alpha * (u64)(qdelay - q->params.target);
-	delta += beta * (u64)(qdelay - qdelay_old);
-
-	oldprob = q->vars.prob;
-
-	/* to ensure we increase probability in steps of no more than 2% */
-	if (delta > (s64)(MAX_PROB / (100 / 2)) &&
-	    q->vars.prob >= MAX_PROB / 10)
-		delta = (MAX_PROB / 100) * 2;
-
-	/* Non-linear drop:
-	 * Tune drop probability to increase quickly for high delays(>= 250ms)
-	 * 250ms is derived through experiments and provides error protection
-	 */
-
-	if (qdelay > (PSCHED_NS2TICKS(250 * NSEC_PER_MSEC)))
-		delta += MAX_PROB / (100 / 2);
-
-	q->vars.prob += delta;
-
-	if (delta > 0) {
-		/* prevent overflow */
-		if (q->vars.prob < oldprob) {
-			q->vars.prob = MAX_PROB;
-			/* Prevent normalization error. If probability is at
-			 * maximum value already, we normalize it here, and
-			 * skip the check to do a non-linear drop in the next
-			 * section.
-			 */
-			update_prob = false;
-		}
-	} else {
-		/* prevent underflow */
-		if (q->vars.prob > oldprob)
-			q->vars.prob = 0;
-	}
-
-	/* Non-linear drop in probability: Reduce drop probability quickly if
-	 * delay is 0 for 2 consecutive Tupdate periods.
-	 */
-
-	if (qdelay == 0 && qdelay_old == 0 && update_prob)
-		/* Reduce drop probability to 98.4% */
-		q->vars.prob -= q->vars.prob / 64u;
-
-	q->vars.qdelay = qdelay;
-	q->vars.qlen_old = qlen;
-
-	/* We restart the measurement cycle if the following conditions are met
-	 * 1. If the delay has been low for 2 consecutive Tupdate periods
-	 * 2. Calculated drop probability is zero
-	 * 3. If average dq_rate_estimator is enabled, we have atleast one
-	 *    estimate for the avg_dq_rate ie., is a non-zero value
-	 */
-	if ((q->vars.qdelay < q->params.target / 2) &&
-	    (q->vars.qdelay_old < q->params.target / 2) &&
-	    q->vars.prob == 0 &&
-	    (!q->params.dq_rate_estimator || q->vars.avg_dq_rate > 0)) {
-		pie_vars_init(&q->vars);
-	}
-
-	if (!q->params.dq_rate_estimator)
-		q->vars.qdelay_old = qdelay;
-}
-
 static void pie_timer(struct timer_list *t)
 {
 	struct pie_sched_data *q = from_timer(q, t, adapt_timer);
@@ -518,7 +161,7 @@ static void pie_timer(struct timer_list *t)
 	spinlock_t *root_lock = qdisc_lock(qdisc_root_sleeping(sch));
 
 	spin_lock(root_lock);
-	calculate_probability(sch);
+	calculate_probability(&q->params, &q->vars, sch->qstats.backlog);
 
 	/* reset the timer to fire after 'tupdate'. tupdate is in jiffies. */
 	if (q->params.tupdate)
@@ -607,12 +250,13 @@ static int pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 
 static struct sk_buff *pie_qdisc_dequeue(struct Qdisc *sch)
 {
+	struct pie_sched_data *q = qdisc_priv(sch);
 	struct sk_buff *skb = qdisc_dequeue_head(sch);
 
 	if (!skb)
 		return NULL;
 
-	pie_process_dequeue(sch, skb);
+	pie_process_dequeue(skb, &q->params, &q->vars, sch->qstats.backlog);
 	return skb;
 }
 
@@ -633,7 +277,7 @@ static void pie_destroy(struct Qdisc *sch)
 }
 
 static struct Qdisc_ops pie_qdisc_ops __read_mostly = {
-	.id = "pie",
+	.id		= "pie",
 	.priv_size	= sizeof(struct pie_sched_data),
 	.enqueue	= pie_qdisc_enqueue,
 	.dequeue	= pie_qdisc_dequeue,
-- 
2.17.1

