Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1013F679FC0
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbjAXRHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234576AbjAXRGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:25 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D4710C3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-4c131bede4bso227367097b3.5
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DUfRx7uTYdW2mhGQPCEKufhycHQF/x5jtIB7VgmmCCE=;
        b=wQxJrXIfBCBfN6k88oEcy8Nz9MZMrkA6WZaeM2/rxzdMA3Q2e+mlnX8GMSH+oe6C8g
         HNkhJUPo4d2MURpnX5y4tlJwNI+ramdJ1T2o++XM2S57Kv7qldfWUrY8miMFMl6cGrtO
         jFDAtrPbWBuVGeFTuSyyDDs8bojEGQwVLS5oZo9tO44xbB3oh9uYWuhI3mUFwfR3RdhA
         LVLknsuITrlyCLOuNaNdjKHnWvfIJxNoRO6265dIfkPzXNbOa6325HMCYoin6TiDtDcw
         jaSd0vpbuTKrcOx1XveMoTYiJTNKYDayXZCOTdsTE0UcBFSFzBtOCTLRH29JygkScz2U
         6ptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DUfRx7uTYdW2mhGQPCEKufhycHQF/x5jtIB7VgmmCCE=;
        b=5r+6qWHtaD/b43RQu3jYBtmJyaWsfvyRZCrf9XNvMgWRG67p91yAmVdfLz/h203/f6
         wA9Gl17qpHWC28UGDUQkPpYDjaWyUM9v7CYAAuWrwUljO4mTWRzQk19qUkTD5K2I5zoZ
         qub1dR0r5zZPhwIM0YVdbuzb1s4bq0rtFtJ8h2Sw4qVNvb+Rzea/zItIQS3cT/W8WSy5
         AURdGEDtV+2oElna++Sqmfq5o83ZtxTe93yTMcWh1eSRk43npPcKfvZhN54Ohel8tsRS
         wVDwchWtFtbCKSOt3NEvg9fkb7q1evky2021UD7knz3D8kYayoqrVVdszc0I6muh+6z3
         C/oA==
X-Gm-Message-State: AO0yUKW08tdmw+8c/41KBXVbK+qwZWrfDtuQQ/y2WYtvPLlpCu4zIe5f
        eJiAeiTQx1GcwGgKg+dAvINRpBGx4oTqbHGr
X-Google-Smtp-Source: AK7set/RZtHP3++2I3IF0zMAhFC3HjJDCFgd0vuX54FawVwpzY1kfkpJ53s5vQpy7RR6GzBBbz1P6g==
X-Received: by 2002:a05:7500:2410:b0:f3:8bbf:a5f3 with SMTP id az16-20020a057500241000b000f38bbfa5f3mr208796gab.2.1674579937696;
        Tue, 24 Jan 2023 09:05:37 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:37 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 20/20] p4tc: add P4 classifier
Date:   Tue, 24 Jan 2023 12:05:10 -0500
Message-Id: <20230124170510.316970-20-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230124170510.316970-1-jhs@mojatatu.com>
References: <20230124170510.316970-1-jhs@mojatatu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce P4 classifier, which we'll use execute our P4 pipelines in the
kernel. To use the P4 classifier you must specify a pipeline name that
will be associated to this filter. That pipeline must have already been
create via a template. For example, if we were to add a filter to ingress
of network interface device eth0 and associate it to P4 pipeline simple_l3
we'd issue the following command:

tc filter add dev lo parent ffff: protocol ip prio 6 p4 pname simple_l3

We could also associate an action with this filter, which would look
something like this:

tc filter add dev lo parent ffff: protocol ip prio 6 p4 \
    pname simple_l3 action ok

The classifier itself has the following steps:

================================PARSING================================

If the P4 pipeline has an associated parser, then the first thing that
will happen is we will invoke the parser the pipeline is associated with.

Note, the parser is an optional component. There are P4 programs which
may not need to parse headers.  Assuming presence of a parser in this first
step, the p4 classifier will execute the parser and retrieve all the header
fields that were specified in the templating phase.

Also remember that a P4 program/pipeline can only has a max of one parser.

================================PREACTIONS================================

After parsing, the classifier will execute the pipeline preactions.

Most of the time, the pipeline preactions will consist of a dynamic action
table apply command, which will start the match action chain common to P4
programs.

The preactions will return a standard action code (TC_ACT_OK,
TC_ACT_SHOT and etc). If the preaction returns TC_ACT_PIPE, we'll
continue to the next step of the filter execution, otherwise it will
stop executing the filter and return the op code.

================================POSTACTIONS================================

After the pipeline preactions have executed and returned TC_ACT_PIPE,
the filter will execute the pipeline postactions.

Like the preactions, the postactions will return a standard action code.
If the postaction returns TC_ACT_PIPE, we'll continue to the next step of
the filter execution, otherwise it will stop executing the filter and
return the op code.

==============================FILTER ACTIONS==============================

After the pipeline preactions have executed and returned TC_ACT_PIPE,
the filter will execute the fitler actions, if any were associate with it.

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
 include/uapi/linux/pkt_cls.h |  13 ++
 net/sched/Kconfig            |  12 ++
 net/sched/Makefile           |   1 +
 net/sched/cls_p4.c           | 339 +++++++++++++++++++++++++++++++++++
 net/sched/p4tc/Makefile      |   4 +-
 net/sched/p4tc/trace.c       |  10 ++
 net/sched/p4tc/trace.h       |  45 +++++
 7 files changed, 423 insertions(+), 1 deletion(-)
 create mode 100644 net/sched/cls_p4.c
 create mode 100644 net/sched/p4tc/trace.c
 create mode 100644 net/sched/p4tc/trace.h

diff --git a/include/uapi/linux/pkt_cls.h b/include/uapi/linux/pkt_cls.h
index 5d6e22f2a..614d013bb 100644
--- a/include/uapi/linux/pkt_cls.h
+++ b/include/uapi/linux/pkt_cls.h
@@ -724,6 +724,19 @@ enum {
 
 #define TCA_MATCHALL_MAX (__TCA_MATCHALL_MAX - 1)
 
+/* P4 classifier */
+
+enum {
+	TCA_P4_UNSPEC,
+	TCA_P4_CLASSID,
+	TCA_P4_ACT,
+	TCA_P4_PNAME,
+	TCA_P4_PAD,
+	__TCA_P4_MAX,
+};
+
+#define TCA_P4_MAX (__TCA_P4_MAX - 1)
+
 /* Extended Matches */
 
 struct tcf_ematch_tree_hdr {
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index c2fbd1889..ba84edc1a 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -640,6 +640,18 @@ config NET_CLS_MATCHALL
 	  To compile this code as a module, choose M here: the module will
 	  be called cls_matchall.
 
+config NET_CLS_P4
+	tristate "P4 classifier"
+	select NET_CLS
+	select NET_P4_TC
+	help
+	  If you say Y here, you will be able to classify packets based on
+	  P4 pipeline programs. You will need to install P4 templates scripts
+          successfully to use this feature.
+
+	  To compile this code as a module, choose M here: the module will
+	  be called cls_p4.
+
 config NET_EMATCH
 	bool "Extended Matches"
 	select NET_CLS
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 465ea14cd..174230e92 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -78,6 +78,7 @@ obj-$(CONFIG_NET_CLS_CGROUP)	+= cls_cgroup.o
 obj-$(CONFIG_NET_CLS_BPF)	+= cls_bpf.o
 obj-$(CONFIG_NET_CLS_FLOWER)	+= cls_flower.o
 obj-$(CONFIG_NET_CLS_MATCHALL)	+= cls_matchall.o
+obj-$(CONFIG_NET_CLS_P4)	+= cls_p4.o
 obj-$(CONFIG_NET_EMATCH)	+= ematch.o
 obj-$(CONFIG_NET_EMATCH_CMP)	+= em_cmp.o
 obj-$(CONFIG_NET_EMATCH_NBYTE)	+= em_nbyte.o
diff --git a/net/sched/cls_p4.c b/net/sched/cls_p4.c
new file mode 100644
index 000000000..35b21b3c0
--- /dev/null
+++ b/net/sched/cls_p4.c
@@ -0,0 +1,339 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/cls_p4.c - P4 Classifier
+ * Copyright (c) 2022, Mojatatu Networks
+ * Copyright (c) 2022, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/percpu.h>
+
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+
+#include <net/p4tc.h>
+
+#include "p4tc/trace.h"
+
+struct cls_p4_head {
+	struct tcf_exts exts;
+	struct tcf_result res;
+	struct rcu_work rwork;
+	struct p4tc_pipeline *pipeline;
+	u32 handle;
+};
+
+static int p4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
+		       struct tcf_result *res)
+{
+	struct cls_p4_head *head = rcu_dereference_bh(tp->root);
+	struct tcf_result p4res = {};
+	int rc = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_skb_ext *p4tc_ext;
+
+	if (unlikely(!head)) {
+		pr_err("P4 classifier not found\n");
+		return -1;
+	}
+
+	pipeline = head->pipeline;
+	trace_p4_classify(skb, pipeline);
+
+	p4tc_ext = skb_ext_find(skb, P4TC_SKB_EXT);
+	if (!p4tc_ext) {
+		p4tc_ext = p4tc_skb_ext_alloc(skb);
+		if (WARN_ON_ONCE(!p4tc_ext))
+			return TC_ACT_SHOT;
+	}
+
+	if (refcount_read(&pipeline->p_hdrs_used) > 1)
+		rc = tcf_skb_parse(skb, p4tc_ext, pipeline->parser);
+
+	if (rc > 0) {
+		pr_warn("P4 parser error %d\n", rc);
+		return TC_ACT_SHOT;
+	}
+
+	rc = tcf_action_exec(skb, pipeline->preacts, pipeline->num_preacts,
+			     &p4res);
+	if (rc != TC_ACT_PIPE)
+		return rc;
+
+	rc = tcf_action_exec(skb, pipeline->postacts, pipeline->num_postacts,
+			     &p4res);
+	if (rc != TC_ACT_PIPE)
+		return rc;
+
+	*res = head->res;
+
+	return tcf_exts_exec(skb, &head->exts, res);
+}
+
+static int p4_init(struct tcf_proto *tp)
+{
+	return 0;
+}
+
+static void __p4_destroy(struct cls_p4_head *head)
+{
+	tcf_exts_destroy(&head->exts);
+	tcf_exts_put_net(&head->exts);
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
+	[TCA_P4_PNAME] = { .type = NLA_STRING },
+};
+
+static int p4_set_parms(struct net *net, struct tcf_proto *tp,
+			struct cls_p4_head *head, unsigned long base,
+			struct nlattr **tb, struct nlattr *est, u32 flags,
+			struct netlink_ext_ack *extack)
+{
+	int err;
+
+	err = tcf_exts_validate_ex(net, tp, tb, est, &head->exts, flags, 0,
+				   extack);
+	if (err < 0)
+		return err;
+
+	if (tb[TCA_P4_CLASSID]) {
+		head->res.classid = nla_get_u32(tb[TCA_P4_CLASSID]);
+		tcf_bind_filter(tp, &head->res, base);
+	}
+
+	return 0;
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
+	err = nla_parse_nested_deprecated(tb, TCA_P4_MAX, tca[TCA_OPTIONS],
+					  p4_policy, NULL);
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
+	if (refcount_read(&pipeline->p_hdrs_used) > 1 &&
+	    !tcf_parser_is_callable(pipeline->parser)) {
+		err = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Pipeline doesn't have callable parser");
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
index 396fcd249..ac118a79c 100644
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
diff --git a/net/sched/p4tc/trace.c b/net/sched/p4tc/trace.c
new file mode 100644
index 000000000..9ce2e0c01
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
+
+#endif
diff --git a/net/sched/p4tc/trace.h b/net/sched/p4tc/trace.h
new file mode 100644
index 000000000..8aecd5562
--- /dev/null
+++ b/net/sched/p4tc/trace.h
@@ -0,0 +1,45 @@
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
+
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
2.34.1

