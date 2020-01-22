Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4CE145B87
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgAVSXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:39 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37604 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:39 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so116243plz.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8AW38ZjkFp5VTwWlfd3ipGvhQnLa+MJcQKFz5tlL/iE=;
        b=DrAw/wKG+CVHiNriOxpBG63S3ptkjgDMOIH8aJqCjGwcY0AXoZxhh74Mzkgr/gNvHr
         bOIr8SrjjQ0hPKbe+StCumAvkmxUOs+KzCWh9OMZS6mWccUgCMZDVJNkA6nXLa9OLnoA
         Zne3jTKX5Iy0hWBeCZ97rLvT8JgdmaC1wbBnhFo0mp/bs54sGHC83kSx30zVd9Tvdl9p
         eLfLIk0UT/5odyHF8tI5AbRb0NJj5PasV2oPXvZxKM8PSSpDqAhckPe3i+cO6J3EmTds
         XaW/Z2ZjBhle47H8TYkQFUjbO+8Tx/Me77oyxK58HEXafzMRXxzeSHCWBF7e6uPla/F7
         iQBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8AW38ZjkFp5VTwWlfd3ipGvhQnLa+MJcQKFz5tlL/iE=;
        b=CWbiV/yLbe2PbTJR3b8uTs8zNVbgD97lbVY8o9dGkZczAg/An4uCGkKbvbPLEfiK5G
         lQByRcSV3afY5qsHNdrMlcKRyjolppLkKa31gHyP8g1fxwut2KE+DEPC5DGPH9cmstnY
         WbOSWPyOuYonxorVf/VISyUEuV9jY6DBKEU+MxtM8VgOie3rQaO5DucBNVcRNmTnsO9h
         gB/vbplwaRUrg4UL9gBaH8VahTcftQ94Kb9gOqPFIqjlYLocoP7ECA10y92sh3kwCpaH
         N8IDnWYRtHkKIzKWXmj15hP5ZTZ6fGaKCExP6aM9ECW0sMvNYq8v8/HiD37wr3n4Ab5u
         5Dsg==
X-Gm-Message-State: APjAAAUapCcbTQiGp0KpMiOfxZfIEoFv1OPdh807Utld/e0OXlkpCCVB
        HPHHZtQ9vWmtoaNMhGjOGfGMytdt+XcL9Zny
X-Google-Smtp-Source: APXvYqx1JfE6REp+jJCsyLstcYJhzg9rlSjdBswM7jBzqXkK498t1pmLkKtsx6YlegEdWWcS3L2+Xw==
X-Received: by 2002:a17:902:321:: with SMTP id 30mr12679333pld.130.1579717417493;
        Wed, 22 Jan 2020 10:23:37 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:36 -0800 (PST)
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
        "Sachin D . Patil" <sdp.sachin@gmail.com>,
        "V . Saicharan" <vsaicharan1998@gmail.com>,
        Mohit Bhasi <mohitbhasi1998@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v7 10/10] net: sched: add Flow Queue PIE packet scheduler
Date:   Wed, 22 Jan 2020 23:52:33 +0530
Message-Id: <20200122182233.3940-11-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Principles:
  - Packets are classified on flows.
  - This is a Stochastic model (as we use a hash, several flows might
                                be hashed to the same slot)
  - Each flow has a PIE managed queue.
  - Flows are linked onto two (Round Robin) lists,
    so that new flows have priority on old ones.
  - For a given flow, packets are not reordered.
  - Drops during enqueue only.
  - ECN capability is off by default.
  - ECN threshold (if ECN is enabled) is at 10% by default.
  - Uses timestamps to calculate queue delay by default.

Usage:
tc qdisc ... fq_pie [ limit PACKETS ] [ flows NUMBER ]
                    [ target TIME ] [ tupdate TIME ]
                    [ alpha NUMBER ] [ beta NUMBER ]
                    [ quantum BYTES ] [ memory_limit BYTES ]
                    [ ecnprob PERCENTAGE ] [ [no]ecn ]
                    [ [no]bytemode ] [ [no_]dq_rate_estimator ]

defaults:
  limit: 10240 packets, flows: 1024
  target: 15 ms, tupdate: 15 ms (in jiffies)
  alpha: 1/8, beta : 5/4
  quantum: device MTU, memory_limit: 32 Mb
  ecnprob: 10%, ecn: off
  bytemode: off, dq_rate_estimator: off

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Sachin D. Patil <sdp.sachin@gmail.com>
Signed-off-by: V. Saicharan <vsaicharan1998@gmail.com>
Signed-off-by: Mohit Bhasi <mohitbhasi1998@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h              |   2 +
 include/uapi/linux/pkt_sched.h |  31 ++
 net/sched/Kconfig              |  13 +
 net/sched/Makefile             |   1 +
 net/sched/sch_fq_pie.c         | 562 +++++++++++++++++++++++++++++++++
 5 files changed, 609 insertions(+)
 create mode 100644 net/sched/sch_fq_pie.c

diff --git a/include/net/pie.h b/include/net/pie.h
index 90f5db3d29e7..fd5a37cb7993 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -81,9 +81,11 @@ struct pie_stats {
 /**
  * struct pie_skb_cb - contains private skb vars
  * @enqueue_time:	timestamp when the packet is enqueued
+ * @mem_usage:		size of the skb during enqueue
  */
 struct pie_skb_cb {
 	psched_time_t enqueue_time;
+	u32 mem_usage;
 };
 
 static inline void pie_params_init(struct pie_params *params)
diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
index bf5a5b1dfb0b..bbe791b24168 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -971,6 +971,37 @@ struct tc_pie_xstats {
 	__u32 ecn_mark;			/* packets marked with ecn*/
 };
 
+/* FQ PIE */
+enum {
+	TCA_FQ_PIE_UNSPEC,
+	TCA_FQ_PIE_LIMIT,
+	TCA_FQ_PIE_FLOWS,
+	TCA_FQ_PIE_TARGET,
+	TCA_FQ_PIE_TUPDATE,
+	TCA_FQ_PIE_ALPHA,
+	TCA_FQ_PIE_BETA,
+	TCA_FQ_PIE_QUANTUM,
+	TCA_FQ_PIE_MEMORY_LIMIT,
+	TCA_FQ_PIE_ECN_PROB,
+	TCA_FQ_PIE_ECN,
+	TCA_FQ_PIE_BYTEMODE,
+	TCA_FQ_PIE_DQ_RATE_ESTIMATOR,
+	__TCA_FQ_PIE_MAX
+};
+#define TCA_FQ_PIE_MAX   (__TCA_FQ_PIE_MAX - 1)
+
+struct tc_fq_pie_xstats {
+	__u32 packets_in;	/* total number of packets enqueued */
+	__u32 dropped;		/* packets dropped due to fq_pie_action */
+	__u32 overlimit;	/* dropped due to lack of space in queue */
+	__u32 overmemory;	/* dropped due to lack of memory in queue */
+	__u32 ecn_mark;		/* packets marked with ecn */
+	__u32 new_flow_count;	/* count of new flows created by packets */
+	__u32 new_flows_len;	/* count of flows in new list */
+	__u32 old_flows_len;	/* count of flows in old list */
+	__u32 memory_usage;	/* total memory across all queues */
+};
+
 /* CBS */
 struct tc_cbs_qopt {
 	__u8 offload;
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index b1e7ec726958..edde0e519438 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -366,6 +366,19 @@ config NET_SCH_PIE
 
 	  If unsure, say N.
 
+config NET_SCH_FQ_PIE
+	depends on NET_SCH_PIE
+	tristate "Flow Queue Proportional Integral controller Enhanced (FQ-PIE)"
+	help
+	  Say Y here if you want to use the Flow Queue Proportional Integral
+	  controller Enhanced (FQ-PIE) packet scheduling algorithm.
+	  For more information, please see https://tools.ietf.org/html/rfc8033
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called sch_fq_pie.
+
+	  If unsure, say N.
+
 config NET_SCH_INGRESS
 	tristate "Ingress/classifier-action Qdisc"
 	depends on NET_CLS_ACT
diff --git a/net/sched/Makefile b/net/sched/Makefile
index bc8856b865ff..31c367a6cd09 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -59,6 +59,7 @@ obj-$(CONFIG_NET_SCH_CAKE)	+= sch_cake.o
 obj-$(CONFIG_NET_SCH_FQ)	+= sch_fq.o
 obj-$(CONFIG_NET_SCH_HHF)	+= sch_hhf.o
 obj-$(CONFIG_NET_SCH_PIE)	+= sch_pie.o
+obj-$(CONFIG_NET_SCH_FQ_PIE)	+= sch_fq_pie.o
 obj-$(CONFIG_NET_SCH_CBS)	+= sch_cbs.o
 obj-$(CONFIG_NET_SCH_ETF)	+= sch_etf.o
 obj-$(CONFIG_NET_SCH_TAPRIO)	+= sch_taprio.o
diff --git a/net/sched/sch_fq_pie.c b/net/sched/sch_fq_pie.c
new file mode 100644
index 000000000000..bbd0dea6b6b9
--- /dev/null
+++ b/net/sched/sch_fq_pie.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Flow Queue PIE discipline
+ *
+ * Copyright (C) 2019 Mohit P. Tahiliani <tahiliani@nitk.edu.in>
+ * Copyright (C) 2019 Sachin D. Patil <sdp.sachin@gmail.com>
+ * Copyright (C) 2019 V. Saicharan <vsaicharan1998@gmail.com>
+ * Copyright (C) 2019 Mohit Bhasi <mohitbhasi1998@gmail.com>
+ * Copyright (C) 2019 Leslie Monis <lesliemonis@gmail.com>
+ * Copyright (C) 2019 Gautam Ramakrishnan <gautamramk@gmail.com>
+ */
+
+#include <linux/jhash.h>
+#include <linux/sizes.h>
+#include <linux/vmalloc.h>
+#include <net/pkt_cls.h>
+#include <net/pie.h>
+
+/* Flow Queue PIE
+ *
+ * Principles:
+ *   - Packets are classified on flows.
+ *   - This is a Stochastic model (as we use a hash, several flows might
+ *                                 be hashed to the same slot)
+ *   - Each flow has a PIE managed queue.
+ *   - Flows are linked onto two (Round Robin) lists,
+ *     so that new flows have priority on old ones.
+ *   - For a given flow, packets are not reordered.
+ *   - Drops during enqueue only.
+ *   - ECN capability is off by default.
+ *   - ECN threshold (if ECN is enabled) is at 10% by default.
+ *   - Uses timestamps to calculate queue delay by default.
+ */
+
+/**
+ * struct fq_pie_flow - contains data for each flow
+ * @vars:	pie vars associated with the flow
+ * @deficit:	number of remaining byte credits
+ * @backlog:	size of data in the flow
+ * @qlen:	number of packets in the flow
+ * @flowchain:	flowchain for the flow
+ * @head:	first packet in the flow
+ * @tail:	last packet in the flow
+ */
+struct fq_pie_flow {
+	struct pie_vars vars;
+	s32 deficit;
+	u32 backlog;
+	u32 qlen;
+	struct list_head flowchain;
+	struct sk_buff *head;
+	struct sk_buff *tail;
+};
+
+struct fq_pie_sched_data {
+	struct tcf_proto __rcu *filter_list; /* optional external classifier */
+	struct tcf_block *block;
+	struct fq_pie_flow *flows;
+	struct Qdisc *sch;
+	struct list_head old_flows;
+	struct list_head new_flows;
+	struct pie_params p_params;
+	u32 ecn_prob;
+	u32 flows_cnt;
+	u32 quantum;
+	u32 memory_limit;
+	u32 new_flow_count;
+	u32 memory_usage;
+	u32 overmemory;
+	struct pie_stats stats;
+	struct timer_list adapt_timer;
+};
+
+static unsigned int fq_pie_hash(const struct fq_pie_sched_data *q,
+				struct sk_buff *skb)
+{
+	return reciprocal_scale(skb_get_hash(skb), q->flows_cnt);
+}
+
+static unsigned int fq_pie_classify(struct sk_buff *skb, struct Qdisc *sch,
+				    int *qerr)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct tcf_proto *filter;
+	struct tcf_result res;
+	int result;
+
+	if (TC_H_MAJ(skb->priority) == sch->handle &&
+	    TC_H_MIN(skb->priority) > 0 &&
+	    TC_H_MIN(skb->priority) <= q->flows_cnt)
+		return TC_H_MIN(skb->priority);
+
+	filter = rcu_dereference_bh(q->filter_list);
+	if (!filter)
+		return fq_pie_hash(q, skb) + 1;
+
+	*qerr = NET_XMIT_SUCCESS | __NET_XMIT_BYPASS;
+	result = tcf_classify(skb, filter, &res, false);
+	if (result >= 0) {
+#ifdef CONFIG_NET_CLS_ACT
+		switch (result) {
+		case TC_ACT_STOLEN:
+		case TC_ACT_QUEUED:
+		case TC_ACT_TRAP:
+			*qerr = NET_XMIT_SUCCESS | __NET_XMIT_STOLEN;
+			/* fall through */
+		case TC_ACT_SHOT:
+			return 0;
+		}
+#endif
+		if (TC_H_MIN(res.classid) <= q->flows_cnt)
+			return TC_H_MIN(res.classid);
+	}
+	return 0;
+}
+
+/* add skb to flow queue (tail add) */
+static inline void flow_queue_add(struct fq_pie_flow *flow,
+				  struct sk_buff *skb)
+{
+	if (!flow->head)
+		flow->head = skb;
+	else
+		flow->tail->next = skb;
+	flow->tail = skb;
+	skb->next = NULL;
+}
+
+static int fq_pie_qdisc_enqueue(struct sk_buff *skb, struct Qdisc *sch,
+				struct sk_buff **to_free)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct fq_pie_flow *sel_flow;
+	int uninitialized_var(ret);
+	u8 memory_limited = false;
+	u8 enqueue = false;
+	u32 pkt_len;
+	u32 idx;
+
+	/* Classifies packet into corresponding flow */
+	idx = fq_pie_classify(skb, sch, &ret);
+	sel_flow = &q->flows[idx];
+
+	/* Checks whether adding a new packet would exceed memory limit */
+	get_pie_cb(skb)->mem_usage = skb->truesize;
+	memory_limited = q->memory_usage > q->memory_limit + skb->truesize;
+
+	/* Checks if the qdisc is full */
+	if (unlikely(qdisc_qlen(sch) >= sch->limit)) {
+		q->stats.overlimit++;
+		goto out;
+	} else if (unlikely(memory_limited)) {
+		q->overmemory++;
+	}
+
+	if (!pie_drop_early(sch, &q->p_params, &sel_flow->vars,
+			    sel_flow->backlog, skb->len)) {
+		enqueue = true;
+	} else if (q->p_params.ecn &&
+		   sel_flow->vars.prob <= (MAX_PROB / 100) * q->ecn_prob &&
+		   INET_ECN_set_ce(skb)) {
+		/* If packet is ecn capable, mark it if drop probability
+		 * is lower than the parameter ecn_prob, else drop it.
+		 */
+		q->stats.ecn_mark++;
+		enqueue = true;
+	}
+	if (enqueue) {
+		/* Set enqueue time only when dq_rate_estimator is disabled. */
+		if (!q->p_params.dq_rate_estimator)
+			pie_set_enqueue_time(skb);
+
+		pkt_len = qdisc_pkt_len(skb);
+		q->stats.packets_in++;
+		q->memory_usage += skb->truesize;
+		sch->qstats.backlog += pkt_len;
+		sch->q.qlen++;
+		flow_queue_add(sel_flow, skb);
+		if (list_empty(&sel_flow->flowchain)) {
+			list_add_tail(&sel_flow->flowchain, &q->new_flows);
+			q->new_flow_count++;
+			sel_flow->deficit = q->quantum;
+			sel_flow->qlen = 0;
+			sel_flow->backlog = 0;
+		}
+		sel_flow->qlen++;
+		sel_flow->backlog += pkt_len;
+		return NET_XMIT_SUCCESS;
+	}
+out:
+	q->stats.dropped++;
+	sel_flow->vars.accu_prob = 0;
+	sel_flow->vars.accu_prob_overflows = 0;
+	__qdisc_drop(skb, to_free);
+	qdisc_qstats_drop(sch);
+	return NET_XMIT_CN;
+}
+
+static const struct nla_policy fq_pie_policy[TCA_FQ_PIE_MAX + 1] = {
+	[TCA_FQ_PIE_LIMIT]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_FLOWS]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_TARGET]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_TUPDATE]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_ALPHA]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_BETA]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_QUANTUM]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_MEMORY_LIMIT]	= {.type = NLA_U32},
+	[TCA_FQ_PIE_ECN_PROB]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_ECN]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_BYTEMODE]		= {.type = NLA_U32},
+	[TCA_FQ_PIE_DQ_RATE_ESTIMATOR]	= {.type = NLA_U32},
+};
+
+static inline struct sk_buff *dequeue_head(struct fq_pie_flow *flow)
+{
+	struct sk_buff *skb = flow->head;
+
+	flow->head = skb->next;
+	skb->next = NULL;
+	return skb;
+}
+
+static struct sk_buff *fq_pie_qdisc_dequeue(struct Qdisc *sch)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct sk_buff *skb = NULL;
+	struct fq_pie_flow *flow;
+	struct list_head *head;
+	u32 pkt_len;
+
+begin:
+	head = &q->new_flows;
+	if (list_empty(head)) {
+		head = &q->old_flows;
+		if (list_empty(head))
+			return NULL;
+	}
+
+	flow = list_first_entry(head, struct fq_pie_flow, flowchain);
+	/* Flow has exhausted all its credits */
+	if (flow->deficit <= 0) {
+		flow->deficit += q->quantum;
+		list_move_tail(&flow->flowchain, &q->old_flows);
+		goto begin;
+	}
+
+	if (flow->head) {
+		skb = dequeue_head(flow);
+		pkt_len = qdisc_pkt_len(skb);
+		sch->qstats.backlog -= pkt_len;
+		sch->q.qlen--;
+		qdisc_bstats_update(sch, skb);
+	}
+
+	if (!skb) {
+		/* force a pass through old_flows to prevent starvation */
+		if (head == &q->new_flows && !list_empty(&q->old_flows))
+			list_move_tail(&flow->flowchain, &q->old_flows);
+		else
+			list_del_init(&flow->flowchain);
+		goto begin;
+	}
+
+	flow->qlen--;
+	flow->deficit -= pkt_len;
+	flow->backlog -= pkt_len;
+	q->memory_usage -= get_pie_cb(skb)->mem_usage;
+	pie_process_dequeue(skb, &q->p_params, &flow->vars, flow->backlog);
+	return skb;
+}
+
+static int fq_pie_change(struct Qdisc *sch, struct nlattr *opt,
+			 struct netlink_ext_ack *extack)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct nlattr *tb[TCA_FQ_PIE_MAX + 1];
+	unsigned int len_dropped = 0;
+	unsigned int num_dropped = 0;
+	int err;
+
+	if (!opt)
+		return -EINVAL;
+
+	err = nla_parse_nested(tb, TCA_FQ_PIE_MAX, opt, fq_pie_policy, extack);
+	if (err < 0)
+		return err;
+
+	sch_tree_lock(sch);
+	if (tb[TCA_FQ_PIE_LIMIT]) {
+		u32 limit = nla_get_u32(tb[TCA_FQ_PIE_LIMIT]);
+
+		q->p_params.limit = limit;
+		sch->limit = limit;
+	}
+	if (tb[TCA_FQ_PIE_FLOWS]) {
+		if (q->flows) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Number of flows cannot be changed");
+			goto flow_error;
+		}
+		q->flows_cnt = nla_get_u32(tb[TCA_FQ_PIE_FLOWS]);
+		if (!q->flows_cnt || q->flows_cnt > 65536) {
+			NL_SET_ERR_MSG_MOD(extack,
+					   "Number of flows must be < 65536");
+			goto flow_error;
+		}
+	}
+
+	/* convert from microseconds to pschedtime */
+	if (tb[TCA_FQ_PIE_TARGET]) {
+		/* target is in us */
+		u32 target = nla_get_u32(tb[TCA_FQ_PIE_TARGET]);
+
+		/* convert to pschedtime */
+		q->p_params.target =
+			PSCHED_NS2TICKS((u64)target * NSEC_PER_USEC);
+	}
+
+	/* tupdate is in jiffies */
+	if (tb[TCA_FQ_PIE_TUPDATE])
+		q->p_params.tupdate =
+			usecs_to_jiffies(nla_get_u32(tb[TCA_FQ_PIE_TUPDATE]));
+
+	if (tb[TCA_FQ_PIE_ALPHA])
+		q->p_params.alpha = nla_get_u32(tb[TCA_FQ_PIE_ALPHA]);
+
+	if (tb[TCA_FQ_PIE_BETA])
+		q->p_params.beta = nla_get_u32(tb[TCA_FQ_PIE_BETA]);
+
+	if (tb[TCA_FQ_PIE_QUANTUM])
+		q->quantum = nla_get_u32(tb[TCA_FQ_PIE_QUANTUM]);
+
+	if (tb[TCA_FQ_PIE_MEMORY_LIMIT])
+		q->memory_limit = nla_get_u32(tb[TCA_FQ_PIE_MEMORY_LIMIT]);
+
+	if (tb[TCA_FQ_PIE_ECN_PROB])
+		q->ecn_prob = nla_get_u32(tb[TCA_FQ_PIE_ECN_PROB]);
+
+	if (tb[TCA_FQ_PIE_ECN])
+		q->p_params.ecn = nla_get_u32(tb[TCA_FQ_PIE_ECN]);
+
+	if (tb[TCA_FQ_PIE_BYTEMODE])
+		q->p_params.bytemode = nla_get_u32(tb[TCA_FQ_PIE_BYTEMODE]);
+
+	if (tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR])
+		q->p_params.dq_rate_estimator =
+			nla_get_u32(tb[TCA_FQ_PIE_DQ_RATE_ESTIMATOR]);
+
+	/* Drop excess packets if new limit is lower */
+	while (sch->q.qlen > sch->limit) {
+		struct sk_buff *skb = fq_pie_qdisc_dequeue(sch);
+
+		kfree_skb(skb);
+		len_dropped += qdisc_pkt_len(skb);
+		num_dropped += 1;
+	}
+	qdisc_tree_reduce_backlog(sch, num_dropped, len_dropped);
+
+	sch_tree_unlock(sch);
+	return 0;
+
+flow_error:
+	sch_tree_unlock(sch);
+	return -EINVAL;
+}
+
+static void fq_pie_timer(struct timer_list *t)
+{
+	struct fq_pie_sched_data *q = from_timer(q, t, adapt_timer);
+	struct Qdisc *sch = q->sch;
+	spinlock_t *root_lock; /* to lock qdisc for probability calculations */
+	u16 idx;
+
+	root_lock = qdisc_lock(qdisc_root_sleeping(sch));
+	spin_lock(root_lock);
+
+	for (idx = 0; idx < q->flows_cnt; idx++)
+		pie_calculate_probability(&q->p_params, &q->flows[idx].vars,
+					  q->flows[idx].backlog);
+
+	/* reset the timer to fire after 'tupdate' jiffies. */
+	if (q->p_params.tupdate)
+		mod_timer(&q->adapt_timer, jiffies + q->p_params.tupdate);
+
+	spin_unlock(root_lock);
+}
+
+static int fq_pie_init(struct Qdisc *sch, struct nlattr *opt,
+		       struct netlink_ext_ack *extack)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	int err;
+	u16 idx;
+
+	pie_params_init(&q->p_params);
+	sch->limit = 10 * 1024;
+	q->p_params.limit = sch->limit;
+	q->quantum = psched_mtu(qdisc_dev(sch));
+	q->sch = sch;
+	q->ecn_prob = 10;
+	q->flows_cnt = 1024;
+	q->memory_limit = SZ_32M;
+
+	INIT_LIST_HEAD(&q->new_flows);
+	INIT_LIST_HEAD(&q->old_flows);
+
+	if (opt) {
+		err = fq_pie_change(sch, opt, extack);
+
+		if (err)
+			return err;
+	}
+
+	err = tcf_block_get(&q->block, &q->filter_list, sch, extack);
+	if (err)
+		goto init_failure;
+
+	q->flows = kvcalloc(q->flows_cnt, sizeof(struct fq_pie_flow),
+			    GFP_KERNEL);
+	if (!q->flows) {
+		err = -ENOMEM;
+		goto init_failure;
+	}
+	for (idx = 0; idx < q->flows_cnt; idx++) {
+		struct fq_pie_flow *flow = q->flows + idx;
+
+		INIT_LIST_HEAD(&flow->flowchain);
+		pie_vars_init(&flow->vars);
+	}
+
+	timer_setup(&q->adapt_timer, fq_pie_timer, 0);
+	mod_timer(&q->adapt_timer, jiffies + HZ / 2);
+
+	return 0;
+
+init_failure:
+	q->flows_cnt = 0;
+
+	return err;
+}
+
+static int fq_pie_dump(struct Qdisc *sch, struct sk_buff *skb)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct nlattr *opts;
+
+	opts = nla_nest_start(skb, TCA_OPTIONS);
+	if (!opts)
+		return -EMSGSIZE;
+
+	/* convert target from pschedtime to us */
+	if (nla_put_u32(skb, TCA_FQ_PIE_LIMIT, sch->limit) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_FLOWS, q->flows_cnt) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_TARGET,
+			((u32)PSCHED_TICKS2NS(q->p_params.target)) /
+			NSEC_PER_USEC) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_TUPDATE,
+			jiffies_to_usecs(q->p_params.tupdate)) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_ALPHA, q->p_params.alpha) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_BETA, q->p_params.beta) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_QUANTUM, q->quantum) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_MEMORY_LIMIT, q->memory_limit) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_ECN_PROB, q->ecn_prob) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_ECN, q->p_params.ecn) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_BYTEMODE, q->p_params.bytemode) ||
+	    nla_put_u32(skb, TCA_FQ_PIE_DQ_RATE_ESTIMATOR,
+			q->p_params.dq_rate_estimator))
+		goto nla_put_failure;
+
+	return nla_nest_end(skb, opts);
+
+nla_put_failure:
+	nla_nest_cancel(skb, opts);
+	return -EMSGSIZE;
+}
+
+static int fq_pie_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	struct tc_fq_pie_xstats st = {
+		.packets_in	= q->stats.packets_in,
+		.overlimit	= q->stats.overlimit,
+		.overmemory	= q->overmemory,
+		.dropped	= q->stats.dropped,
+		.ecn_mark	= q->stats.ecn_mark,
+		.new_flow_count = q->new_flow_count,
+		.memory_usage   = q->memory_usage,
+	};
+	struct list_head *pos;
+
+	sch_tree_lock(sch);
+	list_for_each(pos, &q->new_flows)
+		st.new_flows_len++;
+
+	list_for_each(pos, &q->old_flows)
+		st.old_flows_len++;
+	sch_tree_unlock(sch);
+
+	return gnet_stats_copy_app(d, &st, sizeof(st));
+}
+
+static void fq_pie_reset(struct Qdisc *sch)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+	u16 idx;
+
+	INIT_LIST_HEAD(&q->new_flows);
+	INIT_LIST_HEAD(&q->old_flows);
+	for (idx = 0; idx < q->flows_cnt; idx++) {
+		struct fq_pie_flow *flow = q->flows + idx;
+
+		/* Removes all packets from flow */
+		rtnl_kfree_skbs(flow->head, flow->tail);
+		flow->head = NULL;
+
+		INIT_LIST_HEAD(&flow->flowchain);
+		pie_vars_init(&flow->vars);
+	}
+
+	sch->q.qlen = 0;
+	sch->qstats.backlog = 0;
+}
+
+static void fq_pie_destroy(struct Qdisc *sch)
+{
+	struct fq_pie_sched_data *q = qdisc_priv(sch);
+
+	tcf_block_put(q->block);
+	del_timer_sync(&q->adapt_timer);
+	kvfree(q->flows);
+}
+
+static struct Qdisc_ops fq_pie_qdisc_ops __read_mostly = {
+	.id		= "fq_pie",
+	.priv_size	= sizeof(struct fq_pie_sched_data),
+	.enqueue	= fq_pie_qdisc_enqueue,
+	.dequeue	= fq_pie_qdisc_dequeue,
+	.peek		= qdisc_peek_dequeued,
+	.init		= fq_pie_init,
+	.destroy	= fq_pie_destroy,
+	.reset		= fq_pie_reset,
+	.change		= fq_pie_change,
+	.dump		= fq_pie_dump,
+	.dump_stats	= fq_pie_dump_stats,
+	.owner		= THIS_MODULE,
+};
+
+static int __init fq_pie_module_init(void)
+{
+	return register_qdisc(&fq_pie_qdisc_ops);
+}
+
+static void __exit fq_pie_module_exit(void)
+{
+	unregister_qdisc(&fq_pie_qdisc_ops);
+}
+
+module_init(fq_pie_module_init);
+module_exit(fq_pie_module_exit);
+
+MODULE_DESCRIPTION("Flow Queue Proportional Integral controller Enhanced (FQ-PIE)");
+MODULE_AUTHOR("Mohit P. Tahiliani");
+MODULE_LICENSE("GPL");
-- 
2.17.1

