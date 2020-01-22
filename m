Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90D311453E2
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:35:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAVLfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:35:52 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42963 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgAVLfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:35:52 -0500
Received: by mail-pg1-f196.google.com with SMTP id s64so3340493pgb.9
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:35:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IiDX1JRlYJ70f8M8rOGvDndZke5qBtFls/ud8lxDiIs=;
        b=AFtuMlNUNOCboXsI9owvtPmmozOxCuS+z3Zwd9HYNI91rLEmiZu8rvftgMY4U++XIX
         cdjY0U8M4EzHfQ1lFG6m1AGqXV4sMC0Nj9iuxi+OeMeBh81WYRYFfnwZHqERbAH+MANo
         BxciJgmP0hkvw/W2Y08iykOo5/8twX64I9+QnSIo6fftEHrJFhxrSMGvaKo/MhsbO+QN
         dYkmKxZvSo3Ur0xi9QfreTm816TkQ36lYt0jjTYS9tipiSuH6yiNDW1G68kB4avVihq9
         aCPQAzB76J1Qy0tT1iNw8LDPW17pNq5qiX6RxebvicFcXe08MVokDzCxqckiEWA12l/z
         00SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IiDX1JRlYJ70f8M8rOGvDndZke5qBtFls/ud8lxDiIs=;
        b=UqZc3iRAJAXZ3lYMawdHwEpYW8D4nk0ZJfO/sgdQP8sI6q84AK2pZbtJuTD622MZ+W
         b1C9QVBH/oKb6PbIU3AXEMTKBjsKuYnBvf1fqs9nxIzoOhUvFUqbJEJjdyKRl1X0mhlh
         9i2h/v/l5ZJF6wtIjKiWniRJ7XMrtyf8/NyBUmT39rXuvK+HycUhSXif9MDRKRNOY3L4
         TgXQqND05bhHSU7TKQl5V+117Pp/g82CSijIe695GVZajs58UfAyoO/DMtoH/yjtweDe
         AkSh9W0GSTEaygt44opXKU9AfxsvAvL4ffemhZUrSpdCynxf6IBTHwQkwL/WRPpKb+y+
         IKJg==
X-Gm-Message-State: APjAAAU8qH0aj8ygk/2PEwXnsbqgw2NvX1EyArWUWsfsYZDi7pDLtNpk
        XU+mDW8D2AvyZ0Mbo+4e3fCwSm2frI882l+G
X-Google-Smtp-Source: APXvYqxuP4TI2JqtsZltxKISy2Vftj63Do6hhYVelXHApdJrfH3eWy5jjOA95s7wqSLHYVpFFgtMaQ==
X-Received: by 2002:a05:6a00:5b:: with SMTP id i27mr2249172pfk.112.1579692950879;
        Wed, 22 Jan 2020 03:35:50 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:35:50 -0800 (PST)
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
Subject: [PATCH net-next v6 01/10] net: sched: pie: move common code to pie.h
Date:   Wed, 22 Jan 2020 17:05:24 +0530
Message-Id: <20200122113533.28128-2-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
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

