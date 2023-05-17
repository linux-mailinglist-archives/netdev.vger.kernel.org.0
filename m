Return-Path: <netdev+bounces-3303-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BAFA706637
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 21CD32818FF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 913DC2107A;
	Wed, 17 May 2023 11:05:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80601182C3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:05:07 +0000 (UTC)
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A76BA3AA3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:44 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-7576ecfa4e7so65836885a.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321482; x=1686913482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wbEN9wbp/SdMmeLthzDuS+XbT0QYAxc5l9cIkPgO9w4=;
        b=GUY+8X9c1f3269ut4lVR5klsi2WZ0cot0+3jLwv/AZ+baX7mYZtsSRK+wUDFfMH0iF
         +xhxb1YWibUDJJvfdQgPicJAgC3eYmV8nBOJxw8/S4vgxfKXPT1ojXjOmWuwMXmKMMs2
         AX5ZVJaZjASQgtLvjWcD4d9cX4Nub0X7kPimh2YeeH2WLOOtVURPgfMMQDE2uXMWzLVt
         nCs+IZmPVKms2iTKEQgd0XFZ+PG0qctYSZZ3UtTWaPis1W52cbwdYazKKP+Ci0zSIoE0
         MNUw8H9B8s5w2CSzKA1+V6yDPzdoWDhOQzbQOr1GzRq6KeVMzjIKqZP8b85+dsHVCEmo
         qkMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321482; x=1686913482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wbEN9wbp/SdMmeLthzDuS+XbT0QYAxc5l9cIkPgO9w4=;
        b=jskBpjwPGlYGh7nxGmsxgV0DH42P5JftW+ieOmE692vYQrK1hdzo0ngyGB5M3aJuiR
         z4Kr4RKwJv0MknH4lGj4Dnwxifr9fZacqn+BUj8uvPSi3ewbVKiE61x7D4/6EJo+nGMz
         1nl3D8yIdurd9ti1dnCQ/Prf/jENBQHz3LaVPhhcDMHkRymAXApqH5nnwYoY1W54m+wP
         4P3NnLwlMnIMZgt8IAXlcSnegqhWucSbfw1s0e/V7XxDLjGvjyiZ/i4dyH30+53GSqpt
         LAG+50y6e8A1lH6LD/sc0shx23nD1CroPoWvnOy5sH14nuMk5+pUaxidPD+j+bkJXukL
         cZDg==
X-Gm-Message-State: AC+VfDw82nWu2rJydUnBhQIntWiYlhouRbw5GXtW5NqZiQbRdABIzgpq
	gtnKWsj5g3uG70hXbmbQE1vYNDN/WzDwBErGdfA=
X-Google-Smtp-Source: ACHHUZ7e6lCFfFxOdYilI6sXo2aMAAaKX3ZjtYqPdID9pYvqXrYne1s9LyvsILzYZFLHF7cuBRJo3Q==
X-Received: by 2002:a05:6214:493:b0:623:3f92:36f8 with SMTP id pt19-20020a056214049300b006233f9236f8mr34343190qvb.23.1684321482198;
        Wed, 17 May 2023 04:04:42 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id x16-20020a0cda10000000b0061b60afe381sm6225556qvj.85.2023.05.17.04.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:04:41 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 18/28] p4tc: add P4 classifier
Date: Wed, 17 May 2023 07:02:22 -0400
Message-Id: <20230517110232.29349-18-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Introduce P4 tc classifier. A  tc filter instantiated on this classifier
is used to bind a P4 pipeline to one or more netdev ports. To use P4
classifier you must specify a pipeline name that will be associated to
this filter. That pipeline must have already been create via a template.
For example, if we were to add a filter to ingress of network interface
of network interface device eth0 and associate it to P4 pipeline simple_l3
we'd issue the following command:

tc filter add dev lo parent ffff: protocol any prio 6 p4 pname simple_l3

The filter itself has the following steps:

================================1 PARSING================================

The parser is implemented in ebpf residing either at the TC or XDP
level.
The parser produces meta-information which prescribes the different
headers defined in the P4 program reside.
Note: the different headers and their IDs are already described in the
templating definition and the generated ebpf code.
The ebpf parser invokes a kfunc(bpf_p4tc_get_parser_buffer) to pass on
the metainfo to P4TC.

To load the eBPF parser program into TC, we issue the following command:

tc filter add dev $P0 ingress protocol any prio 1 p4 pname redirect_srcip \
    prog tc obj $PROGNAME.o section parser/tc-ingress

To load the eBPF parser program into XDP, we first need to load it into
XDP using, for example, the ip command:

ip link set $P0 xdp obj $PROGNAME.o section parser/xdp verbose

Then we pin it:

bpftool prog pin id $ID pin /tmp/

After that we create the P4 filter and refernce the XDP program:

$TC filter add dev $P0 ingress protocol ip prio 1 p4 pname redirect_srcip \
    prog xdp pinned /tmp/xdp_parser prog_cookie 22

Note that we also specify a the "prog_cookie", which is used to verify
whether the eBPF program has executed or not before we reach the P4
classifier. To eBPF program sets this cookie by using the kfunc
bpf_p4tc_set_cookie.

===============================2 PREACTIONS===============================

After parsing, the classifier will execute the pipeline preactions.

Most of the time, the pipeline preactions will consist of a dynamic action
table apply command, which will start the match action chain common to P4
programs.

The preactions will return a standard action code (TC_ACT_OK,
TC_ACT_SHOT and etc). If the preaction returns TC_ACT_PIPE, we'll
continue to the next step of the filter execution, otherwise it will
stop executing the filter and return the op code.

===============================3 POSTACTIONS===============================

After the pipeline preactions have executed and returned TC_ACT_PIPE,
the filter will execute the pipeline postactions.

Like the preactions, the postactions will return a standard action code.
If the postaction returns TC_ACT_PIPE, we'll continue to the next step of
the filter execution, otherwise it will stop executing the filter and
return the op code.

==================4 ADDITIONALLY OPTIONAL FILTER ACTIONS==================

After the pipeline preactions have executed and returned TC_ACT_PIPE,
the filter will execute the filter actions, if any were associated with it.

Filter actions are the ones defined outside the P4 program, example:

tc filter add dev lo parent ffff: protocol ip prio 6 p4 \
    pname simple_l3 action ok

The action "ok" is classical Linux gact action.

The filter will return the op code returned by this action.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h           |   1 +
 include/uapi/linux/pkt_cls.h |  18 ++
 net/sched/Kconfig            |  12 +
 net/sched/Makefile           |   1 +
 net/sched/cls_p4.c           | 510 +++++++++++++++++++++++++++++++++++
 net/sched/p4tc/Makefile      |   4 +-
 net/sched/p4tc/p4tc_bpf.c    |  77 ++++++
 net/sched/p4tc/trace.c       |  10 +
 net/sched/p4tc/trace.h       |  44 +++
 9 files changed, 676 insertions(+), 1 deletion(-)
 create mode 100644 net/sched/cls_p4.c
 create mode 100644 net/sched/p4tc/p4tc_bpf.c
 create mode 100644 net/sched/p4tc/trace.c
 create mode 100644 net/sched/p4tc/trace.h

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index a31a6420e7e3..53d519149d09 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -36,6 +36,7 @@
 #define P4TC_HDRFIELD_IS_VALIDITY_BIT 0x1
 
 struct p4tc_percpu_scratchpad {
+	u32 prog_cookie;
 	u32 keysz;
 	u32 maskid;
 	u8 key[BITS_TO_BYTES(P4TC_MAX_KEYSZ)];
diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 337411949ad0..0dcf574799bf 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -724,6 +724,24 @@ enum {
 
 #define TCA_MATCHALL_MAX (__TCA_MATCHALL_MAX - 1)
 
+/* P4 classifier */
+
+enum {
+	TCA_P4_UNSPEC,
+	TCA_P4_CLASSID,
+	TCA_P4_ACT,
+	TCA_P4_PNAME,
+	TCA_P4_PROG_FD,
+	TCA_P4_PROG_NAME,
+	TCA_P4_PROG_TYPE,
+	TCA_P4_PROG_COOKIE,
+	TCA_P4_PROG_ID,
+	TCA_P4_PAD,
+	__TCA_P4_MAX,
+};
+
+#define TCA_P4_MAX (__TCA_P4_MAX - 1)
+
 /* Extended Matches */
 
 struct tcf_ematch_tree_hdr {
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index ea57a4c7b205..43d300ef0f5a 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -566,6 +566,18 @@ config NET_CLS_MATCHALL
 	  To compile this code as a module, choose M here: the module will
 	  be called cls_matchall.
 
+config NET_CLS_P4
+	tristate "P4 classifier"
+	select NET_CLS
+	select NET_P4_TC
+	help
+	  If you say Y here, you will be able to bind a P4 pipeline
+	  program. You will need to install P4 templates scripts successfully to
+          use this feature.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cls_p4.
+
 config NET_EMATCH
 	bool "Extended Matches"
 	select NET_CLS
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 937b8f8a90ce..15bd59ae336c 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -73,6 +73,7 @@ obj-$(CONFIG_NET_CLS_CGROUP)	+= cls_cgroup.o
 obj-$(CONFIG_NET_CLS_BPF)	+= cls_bpf.o
 obj-$(CONFIG_NET_CLS_FLOWER)	+= cls_flower.o
 obj-$(CONFIG_NET_CLS_MATCHALL)	+= cls_matchall.o
+obj-$(CONFIG_NET_CLS_P4)	+= cls_p4.o
 obj-$(CONFIG_NET_EMATCH)	+= ematch.o
 obj-$(CONFIG_NET_EMATCH_CMP)	+= em_cmp.o
 obj-$(CONFIG_NET_EMATCH_NBYTE)	+= em_nbyte.o
diff --git a/net/sched/cls_p4.c b/net/sched/cls_p4.c
new file mode 100644
index 000000000000..25e3f0cc7aa8
--- /dev/null
+++ b/net/sched/cls_p4.c
@@ -0,0 +1,510 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/cls_p4.c - P4 Classifier
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+#include <linux/bpf.h>
+#include <linux/filter.h>
+
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+
+#include <net/p4tc.h>
+
+#include "p4tc/trace.h"
+
+#define CLS_P4_PROG_NAME_LEN	256
+
+struct p4tc_bpf_prog {
+	struct bpf_prog *p4_prog;
+	const char *p4_prog_name;
+};
+
+struct cls_p4_head {
+	struct tcf_exts exts;
+	struct tcf_result res;
+	struct rcu_work rwork;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_bpf_prog *prog;
+	u32 p4_prog_cookie;
+	u32 handle;
+};
+
+static int p4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+		       struct tcf_result *res)
+{
+	struct cls_p4_head *head = rcu_dereference_bh(tp->root);
+	bool at_ingress = skb_at_tc_ingress(skb);
+	int rc = TC_ACT_PIPE;
+	struct p4tc_percpu_scratchpad *pad;
+	struct tcf_result p4res = {};
+	struct p4tc_pipeline *pipeline;
+
+	if (unlikely(!head)) {
+		pr_err("P4 classifier not found\n");
+		return -1;
+	}
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+
+	if (head->prog) {
+		/* If eBPF program is loaded into TC */
+		if (head->prog->p4_prog->type == BPF_PROG_TYPE_SCHED_ACT) {
+			if (at_ingress) {
+				/* It is safe to push/pull even if skb_shared() */
+				__skb_push(skb, skb->mac_len);
+				bpf_compute_data_pointers(skb);
+				rc = bpf_prog_run(head->prog->p4_prog,
+						  skb);
+				__skb_pull(skb, skb->mac_len);
+			} else {
+				bpf_compute_data_pointers(skb);
+				rc = bpf_prog_run(head->prog->p4_prog,
+						  skb);
+			}
+		/* Potentially eBPF program was executed before at XDP and we
+		 * need to check the cookie to see if that was the case.
+		 */
+		} else {
+			if (head->p4_prog_cookie != pad->prog_cookie) {
+				net_notice_ratelimited("prog_cookie doesn't match");
+				return TC_ACT_SHOT;
+			}
+		}
+	}
+
+	if (rc != TC_ACT_PIPE)
+		goto zero_pad;
+
+	pipeline = head->pipeline;
+	trace_p4_classify(skb, pipeline);
+
+	rc = tcf_action_exec(skb, pipeline->preacts, pipeline->num_preacts,
+			     &p4res);
+	if (rc != TC_ACT_PIPE)
+		goto zero_pad;
+
+	rc = tcf_action_exec(skb, pipeline->postacts, pipeline->num_postacts,
+			     &p4res);
+	if (rc != TC_ACT_PIPE)
+		goto zero_pad;
+
+	*res = head->res;
+
+	rc = tcf_exts_exec(skb, &head->exts, res);
+
+zero_pad:
+	/* Pad will always be zero initialised after boot.
+	 * Zero it at the end after all users are done with it.
+	 */
+	memset(pad, 0, sizeof(*pad));
+
+	return rc;
+}
+
+static int p4_init(struct tcf_proto *tp)
+{
+	return 0;
+}
+
+static void p4_bpf_prog_destroy(struct p4tc_bpf_prog *prog)
+{
+	bpf_prog_put(prog->p4_prog);
+	kfree(prog->p4_prog_name);
+	kfree(prog);
+}
+
+static void __p4_destroy(struct cls_p4_head *head)
+{
+	tcf_exts_destroy(&head->exts);
+	tcf_exts_put_net(&head->exts);
+	if (head->prog)
+		p4_bpf_prog_destroy(head->prog);
+	__tcf_pipeline_put(head->pipeline);
+	kfree(head);
+}
+
+static void p4_destroy_work(struct work_struct *work)
+{
+	struct cls_p4_head *head =
+		container_of(to_rcu_work(work), struct cls_p4_head, rwork);
+
+	rtnl_lock();
+	__p4_destroy(head);
+	rtnl_unlock();
+}
+
+static void p4_destroy(struct tcf_proto *tp, bool rtnl_held,
+		       struct netlink_ext_ack *extack)
+{
+	struct cls_p4_head *head = rtnl_dereference(tp->root);
+
+	if (!head)
+		return;
+
+	tcf_unbind_filter(tp, &head->res);
+
+	if (tcf_exts_get_net(&head->exts))
+		tcf_queue_work(&head->rwork, p4_destroy_work);
+	else
+		__p4_destroy(head);
+}
+
+static void *p4_get(struct tcf_proto *tp, u32 handle)
+{
+	struct cls_p4_head *head = rtnl_dereference(tp->root);
+
+	if (head && head->handle == handle)
+		return head;
+
+	return NULL;
+}
+
+static const struct nla_policy p4_policy[TCA_P4_MAX + 1] = {
+	[TCA_P4_UNSPEC] = { .type = NLA_UNSPEC },
+	[TCA_P4_CLASSID] = { .type = NLA_U32 },
+	[TCA_P4_ACT] = { .type = NLA_NESTED },
+	[TCA_P4_PNAME] = { .type = NLA_STRING, .len = PIPELINENAMSIZ },
+	[TCA_P4_PROG_FD] = { .type = NLA_U32},
+	[TCA_P4_PROG_NAME] = { .type = NLA_STRING, .len = CLS_P4_PROG_NAME_LEN },
+	[TCA_P4_PROG_TYPE] = { .type = NLA_U32},
+	[TCA_P4_PROG_COOKIE] = { .type = NLA_U32 }
+};
+
+static int cls_p4_prog_from_efd(struct nlattr **tb,
+				struct p4tc_bpf_prog *prog, u32 flags,
+				struct netlink_ext_ack *extack)
+{
+	struct bpf_prog *fp;
+	u32 prog_type;
+	bool skip_sw;
+	char *name;
+	u32 bpf_fd;
+
+	bpf_fd = nla_get_u32(tb[TCA_P4_PROG_FD]);
+	prog_type = nla_get_u32(tb[TCA_P4_PROG_TYPE]);
+	skip_sw = flags & TCA_CLS_FLAGS_SKIP_SW;
+
+	if (prog_type != BPF_PROG_TYPE_XDP &&
+	    prog_type != BPF_PROG_TYPE_SCHED_ACT) {
+		NL_SET_ERR_MSG(extack,
+			       "BPF prog type must be BPF_PROG_TYPE_SCHED_ACT or BPF_PROG_TYPE_XDP");
+		return -EINVAL;
+	}
+
+	fp = bpf_prog_get_type_dev(bpf_fd, prog_type, skip_sw);
+	if (IS_ERR(fp))
+		return PTR_ERR(fp);
+
+	name = nla_memdup(tb[TCA_P4_PROG_NAME], GFP_KERNEL);
+	if (!name) {
+		bpf_prog_put(fp);
+		return -ENOMEM;
+	}
+
+	prog->p4_prog_name = name;
+	prog->p4_prog = fp;
+
+	return 0;
+}
+
+static int p4_set_parms(struct net *net, struct tcf_proto *tp,
+			struct cls_p4_head *head, unsigned long base,
+			struct nlattr **tb, struct nlattr *est, u32 flags,
+			struct netlink_ext_ack *extack)
+{
+	bool load_bpf_prog = tb[TCA_P4_PROG_NAME] && tb[TCA_P4_PROG_FD] &&
+			     tb[TCA_P4_PROG_TYPE];
+	struct p4tc_bpf_prog *prog = NULL;
+	int err;
+
+	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags, 0,
+				   extack);
+	if (err < 0)
+		return err;
+
+	if (load_bpf_prog) {
+		prog = kzalloc(GFP_KERNEL, sizeof(*prog));
+		if (!prog) {
+			err = -ENOMEM;
+			goto exts_destroy;
+		}
+
+		err = cls_p4_prog_from_efd(tb, prog, flags, extack);
+		if (err < 0) {
+			kfree(prog);
+			goto exts_destroy;
+		}
+	}
+
+	if (tb[TCA_P4_PROG_COOKIE]) {
+		struct p4tc_bpf_prog *prog_aux = prog ?: head->prog;
+		u32 *p4_prog_cookie;
+
+		if (!prog_aux) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack,
+				       "Must have a BPF program to specify xdp prog_cookie");
+			goto prog_put;
+		}
+
+		if (prog_aux->p4_prog->type != BPF_PROG_TYPE_XDP) {
+			err = -EINVAL;
+			NL_SET_ERR_MSG(extack,
+				       "Program must be attached to XDP to specify prog_cookie");
+			goto prog_put;
+		}
+
+		p4_prog_cookie = nla_data(tb[TCA_P4_PROG_COOKIE]);
+		head->p4_prog_cookie = *p4_prog_cookie;
+	} else {
+		struct p4tc_bpf_prog *prog_aux = prog ?: head->prog;
+
+		if (prog_aux && prog_aux->p4_prog->type == BPF_PROG_TYPE_XDP &&
+		    !head->p4_prog_cookie) {
+			NL_SET_ERR_MSG(extack,
+				       "MUST provide prog_cookie when loading into XDP");
+			err = -EINVAL;
+			goto prog_put;
+		}
+	}
+
+	if (tb[TCA_P4_CLASSID]) {
+		head->res.classid = nla_get_u32(tb[TCA_P4_CLASSID]);
+		tcf_bind_filter(tp, &head->res, base);
+	}
+
+	if (head->prog) {
+		pr_notice("cls_p4: Substituting old BPF program with id %u with new one with id %u\n",
+			  head->prog->p4_prog->aux->id, prog->p4_prog->aux->id);
+		p4_bpf_prog_destroy(head->prog);
+	}
+	head->prog = prog;
+
+	return 0;
+
+prog_put:
+	if (prog)
+		p4_bpf_prog_destroy(prog);
+exts_destroy:
+	tcf_exts_destroy(&head->exts);
+	return err;
+}
+
+static int p4_change(struct net *net, struct sk_buff *in_skb,
+		     struct tcf_proto *tp, unsigned long base, u32 handle,
+		     struct nlattr **tca, void **arg, u32 flags,
+		     struct netlink_ext_ack *extack)
+{
+	struct cls_p4_head *head = rtnl_dereference(tp->root);
+	struct p4tc_pipeline *pipeline = NULL;
+	char *pname = NULL;
+	struct nlattr *tb[TCA_P4_MAX + 1];
+	struct cls_p4_head *new;
+	int err;
+
+	if (!tca[TCA_OPTIONS]) {
+		NL_SET_ERR_MSG(extack, "Must provide pipeline options");
+		return -EINVAL;
+	}
+
+	if (head)
+		return -EEXIST;
+
+	err = nla_parse_nested(tb, TCA_P4_MAX, tca[TCA_OPTIONS], p4_policy,
+			       extack);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_P4_PNAME])
+		pname = nla_data(tb[TCA_P4_PNAME]);
+
+	if (pname) {
+		pipeline = tcf_pipeline_get(net, pname, 0, extack);
+		if (IS_ERR(pipeline))
+			return PTR_ERR(pipeline);
+	} else {
+		NL_SET_ERR_MSG(extack, "MUST provide pipeline name");
+		return -EINVAL;
+	}
+
+	if (!pipeline_sealed(pipeline)) {
+		err = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Pipeline must be sealed before use");
+		goto pipeline_put;
+	}
+
+	new = kzalloc(sizeof(*new), GFP_KERNEL);
+	if (!new) {
+		err = -ENOMEM;
+		goto pipeline_put;
+	}
+
+	err = tcf_exts_init(&new->exts, net, TCA_P4_ACT, 0);
+	if (err)
+		goto err_exts_init;
+
+	if (!handle)
+		handle = 1;
+
+	new->handle = handle;
+
+	err = p4_set_parms(net, tp, new, base, tb, tca[TCA_RATE], flags,
+			   extack);
+	if (err)
+		goto err_set_parms;
+
+	new->pipeline = pipeline;
+	*arg = head;
+	rcu_assign_pointer(tp->root, new);
+	return 0;
+
+err_set_parms:
+	tcf_exts_destroy(&new->exts);
+err_exts_init:
+	kfree(new);
+pipeline_put:
+	__tcf_pipeline_put(pipeline);
+	return err;
+}
+
+static int p4_delete(struct tcf_proto *tp, void *arg, bool *last,
+		     bool rtnl_held, struct netlink_ext_ack *extack)
+{
+	*last = true;
+	return 0;
+}
+
+static void p4_walk(struct tcf_proto *tp, struct tcf_walker *arg,
+		    bool rtnl_held)
+{
+	struct cls_p4_head *head = rtnl_dereference(tp->root);
+
+	if (arg->count < arg->skip)
+		goto skip;
+
+	if (!head)
+		return;
+	if (arg->fn(tp, head, arg) < 0)
+		arg->stop = 1;
+skip:
+	arg->count++;
+}
+
+static int p4_prog_dump(struct sk_buff *skb, struct p4tc_bpf_prog *prog,
+			u32 prog_cookie)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+
+	if (nla_put_u32(skb, TCA_P4_PROG_ID, prog->p4_prog->aux->id))
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, TCA_P4_PROG_NAME, prog->p4_prog_name))
+		goto nla_put_failure;
+
+	if (nla_put_u32(skb, TCA_P4_PROG_TYPE, prog->p4_prog->type))
+		goto nla_put_failure;
+
+	if (prog_cookie &&
+	    nla_put_u32(skb, TCA_P4_PROG_COOKIE, prog_cookie))
+		goto nla_put_failure;
+
+	return 0;
+
+nla_put_failure:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int p4_dump(struct net *net, struct tcf_proto *tp, void *fh,
+		   struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
+{
+	struct cls_p4_head *head = fh;
+	struct nlattr *nest;
+
+	if (!head)
+		return skb->len;
+
+	t->tcm_handle = head->handle;
+
+	nest = nla_nest_start(skb, TCA_OPTIONS);
+	if (!nest)
+		goto nla_put_failure;
+
+	if (nla_put_string(skb, TCA_P4_PNAME, head->pipeline->common.name))
+		goto nla_put_failure;
+
+	if (head->res.classid &&
+	    nla_put_u32(skb, TCA_P4_CLASSID, head->res.classid))
+		goto nla_put_failure;
+
+	if (head->prog && p4_prog_dump(skb, head->prog, head->p4_prog_cookie))
+		goto nla_put_failure;
+
+	if (tcf_exts_dump(skb, &head->exts))
+		goto nla_put_failure;
+
+	nla_nest_end(skb, nest);
+
+	if (tcf_exts_dump_stats(skb, &head->exts) < 0)
+		goto nla_put_failure;
+
+	return skb->len;
+
+nla_put_failure:
+	nla_nest_cancel(skb, nest);
+	return -1;
+}
+
+static void p4_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
+			  unsigned long base)
+{
+	struct cls_p4_head *head = fh;
+
+	if (head && head->res.classid == classid) {
+		if (cl)
+			__tcf_bind_filter(q, &head->res, base);
+		else
+			__tcf_unbind_filter(q, &head->res);
+	}
+}
+
+static struct tcf_proto_ops cls_p4_ops __read_mostly = {
+	.kind		= "p4",
+	.classify	= p4_classify,
+	.init		= p4_init,
+	.destroy	= p4_destroy,
+	.get		= p4_get,
+	.change		= p4_change,
+	.delete		= p4_delete,
+	.walk		= p4_walk,
+	.dump		= p4_dump,
+	.bind_class	= p4_bind_class,
+	.owner		= THIS_MODULE,
+};
+
+static int __init cls_p4_init(void)
+{
+	return register_tcf_proto_ops(&cls_p4_ops);
+}
+
+static void __exit cls_p4_exit(void)
+{
+	unregister_tcf_proto_ops(&cls_p4_ops);
+}
+
+module_init(cls_p4_init);
+module_exit(cls_p4_exit);
+
+MODULE_AUTHOR("Mojatatu Networks");
+MODULE_DESCRIPTION("P4 Classifier");
+MODULE_LICENSE("GPL");
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index 396fcd249fb8..ac118a79cbf4 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,5 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
+CFLAGS_trace.o := -I$(src)
+
 obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
 	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
-	p4tc_tbl_api.o p4tc_register.o p4tc_cmds.o
+	p4tc_tbl_api.o p4tc_register.o p4tc_cmds.o trace.o
diff --git a/net/sched/p4tc/p4tc_bpf.c b/net/sched/p4tc/p4tc_bpf.c
new file mode 100644
index 000000000000..08d26a6499c5
--- /dev/null
+++ b/net/sched/p4tc/p4tc_bpf.c
@@ -0,0 +1,77 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2022, Mojatatu Networks
+ * Copyright (c) 2022, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/bpf_verifier.h>
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/filter.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/btf_ids.h>
+#include <linux/net_namespace.h>
+#include <net/p4tc.h>
+#include <linux/netdevice.h>
+#include <net/sock.h>
+#include <linux/filter.h>
+
+BTF_ID_LIST(btf_p4tc_ids)
+BTF_ID(struct, p4tc_parser_buffer_act_bpf)
+
+struct p4tc_parser_buffer_act_bpf *bpf_p4tc_get_parser_buffer(void)
+{
+	struct p4tc_percpu_scratchpad *pad;
+	struct p4tc_parser_buffer_act_bpf *parser_buffer;
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+
+	parser_buffer = (struct p4tc_parser_buffer_act_bpf *)&pad->hdrs;
+
+	return parser_buffer;
+}
+
+int is_p4tc_kfunc(const struct bpf_reg_state *reg)
+{
+	const struct btf_type *p4tc_parser_type, *t;
+
+	p4tc_parser_type = btf_type_by_id(reg->btf, btf_p4tc_ids[0]);
+
+	t = btf_type_by_id(reg->btf, reg->btf_id);
+
+	return p4tc_parser_type == t;
+}
+
+void bpf_p4tc_set_cookie(u32 cookie)
+{
+	struct p4tc_percpu_scratchpad *pad;
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+	pad->prog_cookie = cookie;
+}
+
+BTF_SET8_START(p4tc_tbl_kfunc_set)
+BTF_ID_FLAGS(func, bpf_p4tc_get_parser_buffer, 0);
+BTF_ID_FLAGS(func, bpf_p4tc_set_cookie, 0);
+BTF_SET8_END(p4tc_tbl_kfunc_set)
+
+static const struct btf_kfunc_id_set p4tc_table_kfunc_set = {
+	.owner = THIS_MODULE,
+	.set   = &p4tc_tbl_kfunc_set,
+};
+
+int register_p4tc_tbl_bpf(void)
+{
+	int ret;
+
+	ret = register_btf_kfunc_id_set(BPF_PROG_TYPE_SCHED_ACT,
+					&p4tc_table_kfunc_set);
+	ret = ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_XDP,
+					       &p4tc_table_kfunc_set);
+
+	return ret;
+}
diff --git a/net/sched/p4tc/trace.c b/net/sched/p4tc/trace.c
new file mode 100644
index 000000000000..6833134077fa
--- /dev/null
+++ b/net/sched/p4tc/trace.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+#include <net/p4tc.h>
+
+#ifndef __CHECKER__
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"
+EXPORT_TRACEPOINT_SYMBOL_GPL(p4_classify);
+#endif
diff --git a/net/sched/p4tc/trace.h b/net/sched/p4tc/trace.h
new file mode 100644
index 000000000000..80abec13b1bd
--- /dev/null
+++ b/net/sched/p4tc/trace.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM p4tc
+
+#if !defined(__P4TC_TRACE_H_) || defined(TRACE_HEADER_MULTI_READ)
+#define __P4TC_TRACE_H
+
+#include <linux/tracepoint.h>
+
+struct p4tc_pipeline;
+
+TRACE_EVENT(p4_classify,
+	    TP_PROTO(struct sk_buff *skb, struct p4tc_pipeline *pipeline),
+
+	    TP_ARGS(skb, pipeline),
+
+	    TP_STRUCT__entry(__string(pname, pipeline->common.name)
+			     __field(u32,  p_id)
+			     __field(u32,  ifindex)
+			     __field(u32,  ingress)
+			    ),
+
+	    TP_fast_assign(__assign_str(pname, pipeline->common.name);
+			   __entry->p_id = pipeline->common.p_id;
+			   __entry->ifindex = skb->dev->ifindex;
+			   __entry->ingress = skb_at_tc_ingress(skb);
+			  ),
+
+	    TP_printk("dev=%u dir=%s pipeline=%s p_id=%u",
+		      __entry->ifindex,
+		      __entry->ingress ? "ingress" : "egress",
+		      __get_str(pname),
+		      __entry->p_id
+		     )
+);
+
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+
+#include <trace/define_trace.h>
-- 
2.25.1


