Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CD97143F01
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729159AbgAUONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:10 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44795 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727508AbgAUONK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:10 -0500
Received: by mail-pg1-f194.google.com with SMTP id x7so1542416pgl.11
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IiDX1JRlYJ70f8M8rOGvDndZke5qBtFls/ud8lxDiIs=;
        b=czm+5/UHG3OYUmOFlHNbuiZW0mvHl+pezywexKo4ifa/baSM6KMFKrljIb0CqYG8ac
         B4Hf0/F/wwckuXWe0SaYYEpkbb0tZlXEuUxUnnHAB/5FkLCxqwLhUtg6aENeCcvYYNQb
         AW0PFfQPPAdo8TGUvghEq8OQjXVnV+MxNI35v796wWE4I6mg/oEFOSuErn1CV+xB8U6e
         ZeCnN4yMgliH1u8MpH5pwfteG2KgsRixh2qUGfyhtK86IW6acstxsTAeRGpQrvLp0hUe
         e8/jmm/waEN+hY+XMPMkwjzaG7QC7F1TTqqgniVYDUgfv5kzvGdBz054zMiRfZAg+dH7
         aRlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IiDX1JRlYJ70f8M8rOGvDndZke5qBtFls/ud8lxDiIs=;
        b=SJBQcfslKg0fpb3wWULcujY9GPWmxuIYwJ6MKWiL4U94Z1YSR0Jr08fyRfN/E/fsKA
         /Qhohh9gYMMMWbFd2srMIyzQDM1O2Kwo2MU4qwfKHKfwoULMUz+UBsmAbKYyeborxG1w
         atLlXaub1w4rucYEmbSBFGNSo4pa2x9FKUK5QoxmoTVf60WzAtnE0Of8dNymHkI67HkT
         b9QO5zvmOh+VhyyzMnlIrg9JA3RZCQTJN2EHWPoehlnB++aZ1MtM4JY/3/Q/G0WN2U2U
         HMgByMoRf6xXI1v8tCu0KgkKyRMw6tpr98tXUrBgPmRd0GdkAn4h0uLmJrdD3hwsZH45
         zzmA==
X-Gm-Message-State: APjAAAXwKZ/9E13a70EJsC78ktQiRwvpccF9WPJVxXaKjxTdbuMqeO17
        Yifx/tU24wnlcbRVqXzNysQXmjg3Ruin9w==
X-Google-Smtp-Source: APXvYqxcQqDHDO/7BaI0m+WlqN7o0TptcOjLHH5IuVkpgTuC+tzKFy2ychNc2Fuf2YOdXki0U7KDnw==
X-Received: by 2002:a62:be09:: with SMTP id l9mr4617075pff.57.1579615988819;
        Tue, 21 Jan 2020 06:13:08 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:08 -0800 (PST)
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
Subject: [PATCH net-next v4 01/10] net: sched: pie: move common code to pie.h
Date:   Tue, 21 Jan 2020 19:42:40 +0530
Message-Id: <20200121141250.26989-2-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

This patch moves macros, structures and small functions common
to PIE and FQ-PIE (to be added in a future commit) from the file
net/sched/sch_pie.c to the header file include/net/pie.h.
All the moved functions are made inline.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h   | 96 +++++++++++++++++++++++++++++++++++++++++++++
 net/sched/sch_pie.c | 86 +---------------------------------------
 2 files changed, 97 insertions(+), 85 deletions(-)
 create mode 100644 include/net/pie.h

diff --git a/include/net/pie.h b/include/net/pie.h
new file mode 100644
index 000000000000..440213ec83eb
--- /dev/null
+++ b/include/net/pie.h
@@ -0,0 +1,96 @@
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
+#define DQCOUNT_INVALID -1
+#define DTIME_INVALID 0xffffffffffffffff
+#define MAX_PROB 0xffffffffffffffff
+#define PIE_SCALE 8
+
+/* parameters used */
+struct pie_params {
+	psched_time_t target;	/* user specified target delay in pschedtime */
+	u32 tupdate;		/* timer frequency (in jiffies) */
+	u32 limit;		/* number of packets that can be enqueued */
+	u32 alpha;		/* alpha and beta are between 0 and 32 */
+	u32 beta;		/* and are used for shift relative to 1 */
+	bool ecn;		/* true if ecn is enabled */
+	bool bytemode;		/* to scale drop early prob based on pkt size */
+	u8 dq_rate_estimator;	/* to calculate delay using Little's law */
+};
+
+/* variables used */
+struct pie_vars {
+	u64 prob;		/* probability but scaled by u64 limit. */
+	psched_time_t burst_time;
+	psched_time_t qdelay;
+	psched_time_t qdelay_old;
+	u64 dq_count;		/* measured in bytes */
+	psched_time_t dq_tstamp;	/* drain rate */
+	u64 accu_prob;		/* accumulated drop probability */
+	u32 avg_dq_rate;	/* bytes per pschedtime tick,scaled */
+	u32 qlen_old;		/* in bytes */
+	u8 accu_prob_overflows;	/* overflows of accu_prob */
+};
+
+/* statistics gathering */
+struct pie_stats {
+	u32 packets_in;		/* total number of packets enqueued */
+	u32 dropped;		/* packets dropped due to pie_action */
+	u32 overlimit;		/* dropped due to lack of space in queue */
+	u32 maxq;		/* maximum queue size */
+	u32 ecn_mark;		/* packets marked with ECN */
+};
+
+/* private skb vars */
+struct pie_skb_cb {
+	psched_time_t enqueue_time;
+};
+
+static inline void pie_params_init(struct pie_params *params)
+{
+	params->alpha = 2;
+	params->beta = 20;
+	params->tupdate = usecs_to_jiffies(15 * USEC_PER_MSEC);	/* 15 ms */
+	params->limit = 1000;	/* default of 1000 packets */
+	params->target = PSCHED_NS2TICKS(15 * NSEC_PER_MSEC);	/* 15 ms */
+	params->ecn = false;
+	params->bytemode = false;
+	params->dq_rate_estimator = false;
+}
+
+static inline void pie_vars_init(struct pie_vars *vars)
+{
+	vars->dq_count = DQCOUNT_INVALID;
+	vars->dq_tstamp = DTIME_INVALID;
+	vars->accu_prob = 0;
+	vars->avg_dq_rate = 0;
+	/* default of 150 ms in pschedtime */
+	vars->burst_time = PSCHED_NS2TICKS(150 * NSEC_PER_MSEC);
+	vars->accu_prob_overflows = 0;
+}
+
+static inline struct pie_skb_cb *get_pie_cb(const struct sk_buff *skb)
+{
+	qdisc_cb_private_validate(skb, sizeof(struct pie_skb_cb));
+	return (struct pie_skb_cb *)qdisc_skb_cb(skb)->data;
+}
+
+static inline psched_time_t pie_get_enqueue_time(const struct sk_buff *skb)
+{
+	return get_pie_cb(skb)->enqueue_time;
+}
+
+static inline void pie_set_enqueue_time(struct sk_buff *skb)
+{
+	get_pie_cb(skb)->enqueue_time = psched_get_time();
+}
+
+#endif
diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index b0b0dc46af61..7197bcaa14ba 100644
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
@@ -70,50 +30,6 @@ struct pie_sched_data {
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
 static bool drop_early(struct Qdisc *sch, u32 packet_size)
 {
 	struct pie_sched_data *q = qdisc_priv(sch);
-- 
2.17.1

