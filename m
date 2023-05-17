Return-Path: <netdev+bounces-3296-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3CE70662C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:08:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1EB6A1C20F9D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:08:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D440920990;
	Wed, 17 May 2023 11:04:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE162098E
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:26 +0000 (UTC)
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493D7E5D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:55 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-6235aac00edso5863596d6.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321423; x=1686913423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RJVQAF19u0xbYocJpbRmHEhOBLEZo5vNQ5qJBiZAcLI=;
        b=b4DsZvt8kYB2h0X1xC8Zd/yzsMdjGQMx3KMo1x7xCnpVbn61SBlN3i1J2khMhb1ojm
         XXYHSQqPQid33J+4w5z6lLX96JNrDjOvSX38WIFwJ+6u0in8idYTVQFxQKrbf0TJZ7/k
         4tEMF5ykmcVB09lqUO5Jf41862cSxQwcLDxRhf0J3EzU0BxxJZC/iWEte2dD3npoVFzd
         /vtF89iAqZq3w64sOp328fmhluH8H37GoRMO7csAOiLyzWe1KPeUmYYm73QjvG+aJYUG
         c6kScH9aj7MSe+DWTImqKmRdoRYiZXgdTQyUNR7HHRjfdQxHswGs4awOyveU9gfd3BKI
         O8+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321423; x=1686913423;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RJVQAF19u0xbYocJpbRmHEhOBLEZo5vNQ5qJBiZAcLI=;
        b=IzgE7pH/lKcizMUmgbZelCKjzyUpmK19C+8pVKomuBJuD/jrwKlCCtpysOG1tcl5s+
         QEx5XSdpdSXrWl9NepSUiowI8LqQ9P3q0z5IiwreWusl9UOdRYWSiowHd8LO65OPsta3
         teY3dFLQzDYNmAbmH/ovtsZT88wjtaBbKo5ZkbA1KQIozE0PDJvjID/1ylv20MtuGWPM
         vY/3nYnpC9xqwXQwPv6BzqocWYfVeTuTWhsR5WIYO6wKkLefkqqljDm9+uPXH2UlJAFt
         jCmgMuwRwcJk5ecXKjaHe7ldoT3lNyDPpfOF3r8GFtp1AEPYsMnLwx/EnCK4VLILw6ut
         7xzw==
X-Gm-Message-State: AC+VfDwGRnA6Zwtl84tQD0kGweSJWUczUFCZHeTuu6cZhaTg6rYjclpw
	3vPbGmjet/kFD16+MBnaKWcZvzBXyO1jC84nkQ0=
X-Google-Smtp-Source: ACHHUZ7OKq9x0qgmT8qrnzvGPO6WB1cw2wtr63DAXtB2szJoyt39sCWGL+1NVoOr+kQ3bWOG+7NpTQ==
X-Received: by 2002:a05:6214:2421:b0:5a2:abf1:7d33 with SMTP id gy1-20020a056214242100b005a2abf17d33mr67738824qvb.50.1684321421549;
        Wed, 17 May 2023 04:03:41 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id pr2-20020a056214140200b006238c00c0eesm23930qvb.50.2023.05.17.04.03.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:40 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 10/28] p4tc: add pipeline create, get, update, delete
Date: Wed, 17 May 2023 07:02:14 -0400
Message-Id: <20230517110232.29349-10-jhs@mojatatu.com>
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
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

__Introducing P4 TC Pipeline__

This commit introduces P4 TC pipelines, which emulate the semantics of a
P4 program/pipeline using the TC infrastructure.

One can refer to P4 programs/pipelines using their names or their
specific pipeline ids (pipeid)

CRUD (Create, Read/get, Update and Delete) commands apply on a pipeline.

As an example, to create a P4 program/pipeline named aP4proggie with a
single table in its pipeline, one would use the following command from user
space tc:

tc p4template create pipeline/aP4proggie numtables 1

Note that, in the above command, the numtables is set as 1; the default
is 0 because it is feasible to have a P4 program with no tables at all.

The kernel issues each pipeline a pipeline ID which could be referenced.
The control plane can specify an ID of choice, for example:

tc p4template create pipeline/aP4proggie pipeid 1 numtables 1

Typically there is no good reason to specify the pipeid, but the choice
is offered to the user.

To Read pipeline aP4proggie attributes, one would retrieve those details as
follows:

tc p4template get pipeline/[aP4proggie] [pipeid 1]

To Update aP4proggie pipeline from 1 to 10 tables, one would use the
following command:

tc p4template update pipeline/[aP4proggie] [pipeid 1] numtables 10

Note that, in the above command, one could use the P4 program/pipeline
name, id or both to specify which P4 program/pipeline to update.

To Delete a P4 program/pipeline named aP4proggie
with a pipeid of 1, one would use the following command:

tc p4template del pipeline/[aP4proggie] [pipeid 1]

Note that, in the above command, one could use the P4 program/pipeline
name, id or both to specify which P4 program/pipeline to delete

If one wished to dump all the created P4 programs/pipelines, one would
use the following command:

tc p4template get pipeline/

__Pipeline Lifetime__

After Create is issued, one can Read/get, Update and Delete; however
the pipeline can only be put to only after it is "sealed".
To seal a pipeline, one would issue the following command:

tc p4template update pipeline/aP4proggie state ready

Once the pipeline is sealed it cannot updated. It can be deleted and read.

After a pipeline is sealed it can be put to use via the TC P4 classifier.
For example:

tc filter add dev $DEV ingress protocol any prio 6 p4 pname aP4proggie

Instantiates aP4proggie in the ingress of $DEV. One could also attach it to
a block of ports (example tc block 22) as such:

tc filter add block 22 ingress protocol any prio 6 p4 pname aP4proggie

Once the pipeline is attached to a device or block it cannot be deleted.
It becomes Read-only from the control plane/user space.
The pipeline can be deleted when there are no longer any users left.

__Packet Flow___

Pipelines have pre and post actions which are defined by the template.

Pipeline Preactions are actions which will be executed when a packet
arrives at the P4TC pipeline.
Post actions are tc actions which will be executed at the very end of the
pipeline and will, usually, execute part of the verdict decided by the
pipeline processing, such as redirecting, mirroring, drop, etc.

A P4 pipeline is instantiated via the tc filter known as "p4", for example:

tc filter add dev $DEV ingress protocol ip prio 6 p4 pname myprog

When a packet arrives at the filter it will first hit the pipeline
preaction. Typically the pipeline preaction will execute the "apply" stanza
of the P4 program.

For example, the following apply logic:

    apply {
	 if (meta.common.direction == ingress && hdrs.ipv4.isValid()) {
                mytable.apply();
        }
    }

Maps to:

tc p4template create action/myprog/PPREA \
 cmd beq metadata.kernel.direction constant.bit1.1 \
             control pipe / jump endif \
 cmd beq hdrfield.myprog.parser1.ipv4.isValid constant.bit1.1 \
             control pipe / jump endif \
 cmd tableapply table.myprog.cb/mytable \
 cmd label endif

Then bind it
tc p4template update pipeline/myprog preactions action myprog/PPREA

A post action is invoked after all the tables (if any) have been
"applied" by Pipeline Preaction.

Example of postaction:

tc p4template create action/myprog/PPOA  \
  cmd beq metadata.myprog.global/drop constant.bit1.1 control drop / pipe \
  cmd send_port_egress metadata.myprog.output_port

tc p4template update pipeline/myprog postactions action myprog/PPOA

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h             | 131 ++++++
 include/uapi/linux/p4tc.h      |  68 +++
 include/uapi/linux/rtnetlink.h |   7 +
 net/sched/p4tc/Makefile        |   2 +-
 net/sched/p4tc/p4tc_pipeline.c | 756 +++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_tmpl_api.c | 562 ++++++++++++++++++++++++
 security/selinux/nlmsgtab.c    |   5 +-
 7 files changed, 1529 insertions(+), 2 deletions(-)
 create mode 100644 include/net/p4tc.h
 create mode 100644 net/sched/p4tc/p4tc_pipeline.c
 create mode 100644 net/sched/p4tc/p4tc_tmpl_api.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
new file mode 100644
index 000000000000..178bbdf68719
--- /dev/null
+++ b/include/net/p4tc.h
@@ -0,0 +1,131 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_P4TC_H
+#define __NET_P4TC_H
+
+#include <uapi/linux/p4tc.h>
+#include <linux/workqueue.h>
+#include <net/sch_generic.h>
+#include <net/net_namespace.h>
+#include <linux/refcount.h>
+#include <linux/rhashtable.h>
+#include <linux/rhashtable-types.h>
+
+#define P4TC_DEFAULT_NUM_TABLES P4TC_MINTABLES_COUNT
+#define P4TC_DEFAULT_MAX_RULES 1
+#define P4TC_PATH_MAX 3
+
+#define P4TC_KERNEL_PIPEID 0
+
+#define P4TC_PID_IDX 0
+
+struct p4tc_dump_ctx {
+	u32 ids[P4TC_PATH_MAX];
+};
+
+struct p4tc_template_common;
+
+/* Redefine these macros to avoid -Wenum-compare warnings */
+
+#define __P4T_IS_UINT_TYPE(tp) \
+	(tp == P4T_U8 || tp == P4T_U16 || tp == P4T_U32 || tp == P4T_U64)
+
+#define P4T_ENSURE_UINT_OR_BINARY_TYPE(tp)                         \
+	(__NLA_ENSURE(__P4T_IS_UINT_TYPE(tp) || tp == P4T_MSECS || \
+		      tp == P4T_BINARY) +                          \
+	 tp)
+
+#define P4T_POLICY_RANGE(tp, _min, _max)                            \
+	{                                                           \
+		.type = P4T_ENSURE_UINT_OR_BINARY_TYPE(tp),         \
+		.validation_type = NLA_VALIDATE_RANGE, .min = _min, \
+		.max = _max,                                        \
+	}
+
+struct p4tc_nl_pname {
+	char                     *data;
+	bool                     passed;
+};
+
+struct p4tc_template_ops {
+	void (*init)(void);
+	struct p4tc_template_common *(*cu)(struct net *net, struct nlmsghdr *n,
+					   struct nlattr *nla,
+					   struct p4tc_nl_pname *nl_pname,
+					   u32 *ids,
+					   struct netlink_ext_ack *extack);
+	int (*put)(struct net *net, struct p4tc_template_common *tmpl,
+		   bool unconditional_purge, struct netlink_ext_ack *extack);
+	int (*gd)(struct net *net, struct sk_buff *skb, struct nlmsghdr *n,
+		  struct nlattr *nla, struct p4tc_nl_pname *nl_pname, u32 *ids,
+		  struct netlink_ext_ack *extack);
+	int (*fill_nlmsg)(struct net *net, struct sk_buff *skb,
+			  struct p4tc_template_common *tmpl,
+			  struct netlink_ext_ack *extack);
+	int (*dump)(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+		    struct nlattr *nla, char **p_name, u32 *ids,
+		    struct netlink_ext_ack *extack);
+	int (*dump_1)(struct sk_buff *skb, struct p4tc_template_common *common);
+};
+
+struct p4tc_template_common {
+	char                     name[TEMPLATENAMSZ];
+	struct p4tc_template_ops *ops;
+	u32                      p_id;
+	u32                      PAD0;
+};
+
+extern const struct p4tc_template_ops p4tc_pipeline_ops;
+
+struct p4tc_pipeline {
+	struct p4tc_template_common common;
+	struct rcu_head             rcu;
+	struct net                  *net;
+	struct tc_action            **preacts;
+	int                         num_preacts;
+	struct tc_action            **postacts;
+	int                         num_postacts;
+	u32                         max_rules;
+	refcount_t                  p_ref;
+	refcount_t                  p_ctrl_ref;
+	u16                         num_tables;
+	u16                         curr_tables;
+	u8                          p_state;
+};
+
+struct p4tc_pipeline_net {
+	struct idr pipeline_idr;
+};
+
+int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			     struct idr *idr, int idx,
+			     struct netlink_ext_ack *extack);
+
+struct p4tc_pipeline *tcf_pipeline_find_byany(struct net *net,
+					      const char *p_name,
+					      const u32 pipeid,
+					      struct netlink_ext_ack *extack);
+struct p4tc_pipeline *tcf_pipeline_find_byid(struct net *net, const u32 pipeid);
+struct p4tc_pipeline *tcf_pipeline_get(struct net *net, const char *p_name,
+				       const u32 pipeid,
+				       struct netlink_ext_ack *extack);
+void __tcf_pipeline_put(struct p4tc_pipeline *pipeline);
+struct p4tc_pipeline *
+tcf_pipeline_find_byany_unsealed(struct net *net, const char *p_name,
+				 const u32 pipeid,
+				 struct netlink_ext_ack *extack);
+
+static inline int p4tc_action_destroy(struct tc_action **acts)
+{
+	int ret = 0;
+
+	if (acts) {
+		ret = tcf_action_destroy(acts, TCA_ACT_UNBIND);
+		kfree(acts);
+	}
+
+	return ret;
+}
+
+#define to_pipeline(t) ((struct p4tc_pipeline *)t)
+
+#endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 2b6f126dbeb5..739c0fe18e95 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -2,8 +2,73 @@
 #ifndef __LINUX_P4TC_H
 #define __LINUX_P4TC_H
 
+#include <linux/types.h>
+#include <linux/pkt_sched.h>
+
+/* pipeline header */
+struct p4tcmsg {
+	__u32 pipeid;
+	__u32 obj;
+};
+
+#define P4TC_MAXPIPELINE_COUNT 32
+#define P4TC_MAXRULES_LIMIT 512
+#define P4TC_MAXTABLES_COUNT 32
+#define P4TC_MINTABLES_COUNT 0
+#define P4TC_MAXPARSE_KEYS 16
+#define P4TC_MAXMETA_SZ 128
+#define P4TC_MSGBATCH_SIZE 16
+
 #define P4TC_MAX_KEYSZ 512
 
+#define TEMPLATENAMSZ 256
+#define PIPELINENAMSIZ TEMPLATENAMSZ
+
+/* Root attributes */
+enum {
+	P4TC_ROOT_UNSPEC,
+	P4TC_ROOT, /* nested messages */
+	P4TC_ROOT_PNAME, /* string */
+	__P4TC_ROOT_MAX,
+};
+#define P4TC_ROOT_MAX __P4TC_ROOT_MAX
+
+/* PIPELINE attributes */
+enum {
+	P4TC_PIPELINE_UNSPEC,
+	P4TC_PIPELINE_MAXRULES, /* u32 */
+	P4TC_PIPELINE_NUMTABLES, /* u16 */
+	P4TC_PIPELINE_STATE, /* u8 */
+	P4TC_PIPELINE_PREACTIONS, /* nested preactions */
+	P4TC_PIPELINE_POSTACTIONS, /* nested postactions */
+	P4TC_PIPELINE_NAME, /* string only used for pipeline dump */
+	__P4TC_PIPELINE_MAX
+};
+#define P4TC_PIPELINE_MAX __P4TC_PIPELINE_MAX
+
+/* P4 Object types */
+enum {
+	P4TC_OBJ_UNSPEC,
+	P4TC_OBJ_PIPELINE,
+	__P4TC_OBJ_MAX,
+};
+#define P4TC_OBJ_MAX __P4TC_OBJ_MAX
+
+/* P4 attributes */
+enum {
+	P4TC_UNSPEC,
+	P4TC_PATH,
+	P4TC_PARAMS,
+	__P4TC_MAX,
+};
+#define P4TC_MAX __P4TC_MAX
+
+/* PIPELINE states */
+enum {
+	P4TC_STATE_NOT_READY,
+	P4TC_STATE_READY,
+};
+
 enum {
 	P4T_UNSPEC,
 	P4T_U8 = 1, /* NLA_U8 */
@@ -37,4 +102,7 @@ enum {
 };
 #define P4T_MAX (__P4T_MAX - 1)
 
+#define P4TC_RTA(r) \
+	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
+
 #endif
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 51c13cf9c5ae..41a4046e7958 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -194,6 +194,13 @@ enum {
 	RTM_GETTUNNEL,
 #define RTM_GETTUNNEL	RTM_GETTUNNEL
 
+	RTM_CREATEP4TEMPLATE = 124,
+#define RTM_CREATEP4TEMPLATE	RTM_CREATEP4TEMPLATE
+	RTM_DELP4TEMPLATE,
+#define RTM_DELP4TEMPLATE	RTM_DELP4TEMPLATE
+	RTM_GETP4TEMPLATE,
+#define RTM_GETP4TEMPLATE	RTM_GETP4TEMPLATE
+
 	__RTM_MAX,
 #define RTM_MAX		(((__RTM_MAX + 3) & ~3) - 1)
 };
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index dd1358c9e802..0881a7563646 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := p4tc_types.o
+obj-y := p4tc_types.o p4tc_tmpl_api.o p4tc_pipeline.o
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
new file mode 100644
index 000000000000..776a8d37b615
--- /dev/null
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -0,0 +1,756 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_pipeline.c	P4 TC PIPELINE
+ *
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/netlink.h>
+#include <net/flow_offload.h>
+#include <net/p4tc_types.h>
+
+static unsigned int pipeline_net_id;
+static struct p4tc_pipeline *root_pipeline;
+
+static __net_init int pipeline_init_net(struct net *net)
+{
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+
+	idr_init(&pipe_net->pipeline_idr);
+
+	return 0;
+}
+
+static int tcf_pipeline_put(struct net *net,
+			    struct p4tc_template_common *template,
+			    bool unconditional_purgeline,
+			    struct netlink_ext_ack *extack);
+
+static void __net_exit pipeline_exit_net(struct net *net)
+{
+	struct p4tc_pipeline_net *pipe_net;
+	struct p4tc_pipeline *pipeline;
+	unsigned long pipeid, tmp;
+
+	rtnl_lock();
+	pipe_net = net_generic(net, pipeline_net_id);
+	idr_for_each_entry_ul(&pipe_net->pipeline_idr, pipeline, tmp, pipeid) {
+		tcf_pipeline_put(net, &pipeline->common, true, NULL);
+	}
+	idr_destroy(&pipe_net->pipeline_idr);
+	rtnl_unlock();
+}
+
+static struct pernet_operations pipeline_net_ops = {
+	.init = pipeline_init_net,
+	.pre_exit = pipeline_exit_net,
+	.id = &pipeline_net_id,
+	.size = sizeof(struct p4tc_pipeline_net),
+};
+
+static const struct nla_policy tc_pipeline_policy[P4TC_PIPELINE_MAX + 1] = {
+	[P4TC_PIPELINE_MAXRULES] =
+		NLA_POLICY_RANGE(NLA_U32, 1, P4TC_MAXRULES_LIMIT),
+	[P4TC_PIPELINE_NUMTABLES] =
+		NLA_POLICY_RANGE(NLA_U16, P4TC_MINTABLES_COUNT, P4TC_MAXTABLES_COUNT),
+	[P4TC_PIPELINE_STATE] = { .type = NLA_U8 },
+	[P4TC_PIPELINE_PREACTIONS] = { .type = NLA_NESTED },
+	[P4TC_PIPELINE_POSTACTIONS] = { .type = NLA_NESTED },
+};
+
+static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
+				 bool free_pipeline)
+{
+	if (free_pipeline)
+		kfree(pipeline);
+}
+
+static void tcf_pipeline_destroy_rcu(struct rcu_head *head)
+{
+	struct p4tc_pipeline *pipeline;
+	struct net *net;
+
+	pipeline = container_of(head, struct p4tc_pipeline, rcu);
+
+	net = pipeline->net;
+	tcf_pipeline_destroy(pipeline, true);
+	put_net(net);
+}
+
+static int tcf_pipeline_put(struct net *net,
+			    struct p4tc_template_common *template,
+			    bool unconditional_purgeline,
+			    struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+	struct p4tc_pipeline *pipeline = to_pipeline(template);
+	struct net *pipeline_net = maybe_get_net(net);
+
+	if (pipeline_net && !refcount_dec_if_one(&pipeline->p_ref)) {
+		NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
+		return -EBUSY;
+	}
+
+	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
+
+	/* XXX: The action fields are only accessed in the control path
+	 * since they will be copied to the filter, where the data path
+	 * will use them. So there is no need to free them in the rcu
+	 * callback. We can just free them here
+	 */
+	p4tc_action_destroy(pipeline->preacts);
+	p4tc_action_destroy(pipeline->postacts);
+
+	if (pipeline_net)
+		call_rcu(&pipeline->rcu, tcf_pipeline_destroy_rcu);
+	else
+		tcf_pipeline_destroy(pipeline,
+				     refcount_read(&pipeline->p_ref) == 1);
+
+	return 0;
+}
+
+static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
+					       struct netlink_ext_ack *extack)
+{
+	if (pipeline->curr_tables != pipeline->num_tables) {
+		NL_SET_ERR_MSG(extack,
+			       "Must have all table defined to update state to ready");
+		return -EINVAL;
+	}
+
+	if (!pipeline->preacts) {
+		NL_SET_ERR_MSG(extack,
+			       "Must specify pipeline preactions before sealing");
+		return -EINVAL;
+	}
+
+	if (!pipeline->postacts) {
+		NL_SET_ERR_MSG(extack,
+			       "Must specify pipeline postactions before sealing");
+		return -EINVAL;
+	}
+
+	pipeline->p_state = P4TC_STATE_READY;
+	return true;
+}
+
+static inline bool pipeline_sealed(struct p4tc_pipeline *pipeline)
+{
+	return pipeline->p_state == P4TC_STATE_READY;
+}
+
+static int p4tc_action_init(struct net *net, struct nlattr *nla,
+			    struct tc_action *acts[], u32 pipeid, u32 flags,
+			    struct netlink_ext_ack *extack)
+{
+	int init_res[TCA_ACT_MAX_PRIO];
+	size_t attrs_size;
+	int ret;
+
+	/* If action was already created, just bind to existing one*/
+	flags = TCA_ACT_FLAGS_BIND;
+	ret = tcf_action_init(net, NULL, nla, NULL, acts, init_res, &attrs_size,
+			      flags, 0, extack);
+
+	return ret;
+}
+
+struct p4tc_pipeline *tcf_pipeline_find_byid(struct net *net, const u32 pipeid)
+{
+	struct p4tc_pipeline_net *pipe_net;
+
+	if (pipeid == P4TC_KERNEL_PIPEID)
+		return root_pipeline;
+
+	pipe_net = net_generic(net, pipeline_net_id);
+
+	return idr_find(&pipe_net->pipeline_idr, pipeid);
+}
+
+static struct p4tc_pipeline *tcf_pipeline_find_byname(struct net *net,
+						      const char *name)
+{
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+	struct p4tc_pipeline *pipeline;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&pipe_net->pipeline_idr, pipeline, tmp, id) {
+		/* Don't show kernel pipeline */
+		if (id == P4TC_KERNEL_PIPEID)
+			continue;
+		if (strncmp(pipeline->common.name, name, PIPELINENAMSIZ) == 0)
+			return pipeline;
+	}
+
+	return NULL;
+}
+
+static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
+						 struct nlmsghdr *n,
+						 struct nlattr *nla,
+						 const char *p_name, u32 pipeid,
+						 struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+	int ret = 0;
+	struct nlattr *tb[P4TC_PIPELINE_MAX + 1];
+	struct p4tc_pipeline *pipeline;
+
+	ret = nla_parse_nested(tb, P4TC_PIPELINE_MAX, nla, tc_pipeline_policy,
+			       extack);
+
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	pipeline = kzalloc(sizeof(*pipeline), GFP_KERNEL);
+	if (!pipeline)
+		return ERR_PTR(-ENOMEM);
+
+	if (!p_name || p_name[0] == '\0') {
+		NL_SET_ERR_MSG(extack, "Must specify pipeline name");
+		ret = -EINVAL;
+		goto err;
+	}
+
+	if (pipeid != P4TC_KERNEL_PIPEID &&
+	    tcf_pipeline_find_byid(net, pipeid)) {
+		NL_SET_ERR_MSG(extack, "Pipeline was already created");
+		ret = -EEXIST;
+		goto err;
+	}
+
+	if (tcf_pipeline_find_byname(net, p_name)) {
+		NL_SET_ERR_MSG(extack, "Pipeline was already created");
+		ret = -EEXIST;
+		goto err;
+	}
+
+	strscpy(pipeline->common.name, p_name, PIPELINENAMSIZ);
+
+	if (pipeid) {
+		ret = idr_alloc_u32(&pipe_net->pipeline_idr, pipeline, &pipeid,
+				    pipeid, GFP_KERNEL);
+	} else {
+		pipeid = 1;
+		ret = idr_alloc_u32(&pipe_net->pipeline_idr, pipeline, &pipeid,
+				    UINT_MAX, GFP_KERNEL);
+	}
+
+	if (ret < 0) {
+		NL_SET_ERR_MSG(extack, "Unable to allocate pipeline id");
+		goto err;
+	}
+
+	pipeline->common.p_id = pipeid;
+
+	if (tb[P4TC_PIPELINE_MAXRULES])
+		pipeline->max_rules =
+			nla_get_u32(tb[P4TC_PIPELINE_MAXRULES]);
+	else
+		pipeline->max_rules = P4TC_DEFAULT_MAX_RULES;
+
+	if (tb[P4TC_PIPELINE_NUMTABLES])
+		pipeline->num_tables =
+			nla_get_u16(tb[P4TC_PIPELINE_NUMTABLES]);
+	else
+		pipeline->num_tables = P4TC_DEFAULT_NUM_TABLES;
+
+	if (tb[P4TC_PIPELINE_PREACTIONS]) {
+		pipeline->preacts = kcalloc(TCA_ACT_MAX_PRIO,
+					    sizeof(struct tc_action *),
+					    GFP_KERNEL);
+		if (!pipeline->preacts) {
+			ret = -ENOMEM;
+			goto idr_rm;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_PIPELINE_PREACTIONS],
+				       pipeline->preacts, pipeid, 0, extack);
+		if (ret < 0) {
+			kfree(pipeline->preacts);
+			goto idr_rm;
+		}
+		pipeline->num_preacts = ret;
+	} else {
+		pipeline->preacts = NULL;
+		pipeline->num_preacts = 0;
+	}
+
+	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
+		pipeline->postacts = kcalloc(TCA_ACT_MAX_PRIO,
+					     sizeof(struct tc_action *),
+					     GFP_KERNEL);
+		if (!pipeline->postacts) {
+			ret = -ENOMEM;
+			goto preactions_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_PIPELINE_POSTACTIONS],
+				       pipeline->postacts, pipeid, 0, extack);
+		if (ret < 0) {
+			kfree(pipeline->postacts);
+			goto preactions_destroy;
+		}
+		pipeline->num_postacts = ret;
+	} else {
+		pipeline->postacts = NULL;
+		pipeline->num_postacts = 0;
+	}
+
+	pipeline->p_state = P4TC_STATE_NOT_READY;
+
+	pipeline->net = net;
+
+	refcount_set(&pipeline->p_ref, 1);
+
+	pipeline->common.ops = (struct p4tc_template_ops *)&p4tc_pipeline_ops;
+
+	return pipeline;
+
+preactions_destroy:
+	p4tc_action_destroy(pipeline->preacts);
+
+idr_rm:
+	idr_remove(&pipe_net->pipeline_idr, pipeid);
+
+err:
+	kfree(pipeline);
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_pipeline *
+__tcf_pipeline_find_byany(struct net *net, const char *p_name, const u32 pipeid,
+			  struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline = NULL;
+	int err;
+
+	if (pipeid) {
+		pipeline = tcf_pipeline_find_byid(net, pipeid);
+		if (!pipeline) {
+			NL_SET_ERR_MSG(extack, "Unable to find pipeline by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (p_name) {
+			pipeline = tcf_pipeline_find_byname(net, p_name);
+			if (!pipeline) {
+				NL_SET_ERR_MSG(extack,
+					       "Pipeline name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		}
+	}
+
+	return pipeline;
+
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_pipeline *tcf_pipeline_find_byany(struct net *net,
+					      const char *p_name,
+					      const u32 pipeid,
+					      struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		__tcf_pipeline_find_byany(net, p_name, pipeid, extack);
+	if (!pipeline) {
+		NL_SET_ERR_MSG(extack, "Must specify pipeline name or id");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pipeline;
+}
+
+struct p4tc_pipeline *tcf_pipeline_get(struct net *net, const char *p_name,
+				       const u32 pipeid,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		__tcf_pipeline_find_byany(net, p_name, pipeid, extack);
+	if (!pipeline) {
+		NL_SET_ERR_MSG(extack, "Must specify pipeline name or id");
+		return ERR_PTR(-EINVAL);
+	} else if (IS_ERR(pipeline)) {
+		return pipeline;
+	}
+
+	/* Should never happen */
+	WARN_ON(!refcount_inc_not_zero(&pipeline->p_ref));
+
+	return pipeline;
+}
+EXPORT_SYMBOL_GPL(tcf_pipeline_get);
+
+void __tcf_pipeline_put(struct p4tc_pipeline *pipeline)
+{
+	struct net *net = maybe_get_net(pipeline->net);
+
+	if (net) {
+		refcount_dec(&pipeline->p_ref);
+		put_net(net);
+	/* If netns is going down, we already deleted the pipeline objects in
+	 * the pre_exit net op
+	 */
+	} else {
+		kfree(pipeline);
+	}
+}
+EXPORT_SYMBOL_GPL(__tcf_pipeline_put);
+
+struct p4tc_pipeline *
+tcf_pipeline_find_byany_unsealed(struct net *net, const char *p_name,
+				 const u32 pipeid,
+				 struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		tcf_pipeline_find_byany(net, p_name, pipeid, extack);
+	if (IS_ERR(pipeline))
+		return pipeline;
+
+	if (pipeline_sealed(pipeline)) {
+		NL_SET_ERR_MSG(extack, "Pipeline is sealed");
+		return ERR_PTR(-EINVAL);
+	}
+
+	return pipeline;
+}
+
+static struct p4tc_pipeline *
+tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+		    const char *p_name, const u32 pipeid,
+		    struct netlink_ext_ack *extack)
+{
+	struct tc_action **preacts = NULL;
+	struct tc_action **postacts = NULL;
+	u16 num_tables = 0;
+	u16 max_rules = 0;
+	int ret = 0;
+	struct nlattr *tb[P4TC_PIPELINE_MAX + 1];
+	struct p4tc_pipeline *pipeline;
+	int num_preacts, num_postacts;
+
+	ret = nla_parse_nested(tb, P4TC_PIPELINE_MAX, nla, tc_pipeline_policy,
+			       extack);
+
+	if (ret < 0)
+		goto out;
+
+	pipeline =
+		tcf_pipeline_find_byany_unsealed(net, p_name, pipeid, extack);
+	if (IS_ERR(pipeline))
+		return pipeline;
+
+	if (tb[P4TC_PIPELINE_NUMTABLES])
+		num_tables = nla_get_u16(tb[P4TC_PIPELINE_NUMTABLES]);
+
+	if (tb[P4TC_PIPELINE_MAXRULES])
+		max_rules = nla_get_u32(tb[P4TC_PIPELINE_MAXRULES]);
+
+	if (tb[P4TC_PIPELINE_PREACTIONS]) {
+		preacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
+				  GFP_KERNEL);
+		if (!preacts) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_PIPELINE_PREACTIONS],
+				       preacts, pipeline->common.p_id, 0,
+				       extack);
+		if (ret < 0) {
+			kfree(preacts);
+			goto out;
+		}
+		num_preacts = ret;
+	}
+
+	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
+		postacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
+				   GFP_KERNEL);
+		if (!postacts) {
+			ret = -ENOMEM;
+			goto preactions_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_PIPELINE_POSTACTIONS],
+				       postacts, pipeline->common.p_id, 0,
+				       extack);
+		if (ret < 0) {
+			kfree(postacts);
+			goto preactions_destroy;
+		}
+		num_postacts = ret;
+	}
+
+	if (tb[P4TC_PIPELINE_STATE]) {
+		ret = pipeline_try_set_state_ready(pipeline, extack);
+		if (ret < 0)
+			goto postactions_destroy;
+	}
+
+	if (max_rules)
+		pipeline->max_rules = max_rules;
+	if (num_tables)
+		pipeline->num_tables = num_tables;
+	if (preacts) {
+		p4tc_action_destroy(pipeline->preacts);
+		pipeline->preacts = preacts;
+		pipeline->num_preacts = num_preacts;
+	}
+	if (postacts) {
+		p4tc_action_destroy(pipeline->postacts);
+		pipeline->postacts = postacts;
+		pipeline->num_postacts = num_postacts;
+	}
+
+	return pipeline;
+
+postactions_destroy:
+	p4tc_action_destroy(postacts);
+
+preactions_destroy:
+	p4tc_action_destroy(preacts);
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_template_common *
+tcf_pipeline_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+		struct p4tc_nl_pname *nl_pname, u32 *ids,
+		struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX];
+	struct p4tc_pipeline *pipeline;
+
+	if (n->nlmsg_flags & NLM_F_REPLACE)
+		pipeline = tcf_pipeline_update(net, n, nla, nl_pname->data,
+					       pipeid, extack);
+	else
+		pipeline = tcf_pipeline_create(net, n, nla, nl_pname->data,
+					       pipeid, extack);
+
+	if (IS_ERR(pipeline))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+out:
+	return (struct p4tc_template_common *)pipeline;
+}
+
+static int _tcf_pipeline_fill_nlmsg(struct sk_buff *skb,
+				    const struct p4tc_pipeline *pipeline)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct nlattr *nest, *preacts, *postacts;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+	if (nla_put_u32(skb, P4TC_PIPELINE_MAXRULES, pipeline->max_rules))
+		goto out_nlmsg_trim;
+
+	if (nla_put_u16(skb, P4TC_PIPELINE_NUMTABLES, pipeline->num_tables))
+		goto out_nlmsg_trim;
+	if (nla_put_u8(skb, P4TC_PIPELINE_STATE, pipeline->p_state))
+		goto out_nlmsg_trim;
+
+	if (pipeline->preacts) {
+		preacts = nla_nest_start(skb, P4TC_PIPELINE_PREACTIONS);
+		if (tcf_action_dump(skb, pipeline->preacts, 0, 0, false) < 0)
+			goto out_nlmsg_trim;
+		nla_nest_end(skb, preacts);
+	}
+
+	if (pipeline->postacts) {
+		postacts = nla_nest_start(skb, P4TC_PIPELINE_POSTACTIONS);
+		if (tcf_action_dump(skb, pipeline->postacts, 0, 0, false) < 0)
+			goto out_nlmsg_trim;
+		nla_nest_end(skb, postacts);
+	}
+
+	nla_nest_end(skb, nest);
+
+	return skb->len;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_pipeline_fill_nlmsg(struct net *net, struct sk_buff *skb,
+				   struct p4tc_template_common *template,
+				   struct netlink_ext_ack *extack)
+{
+	const struct p4tc_pipeline *pipeline = to_pipeline(template);
+
+	if (_tcf_pipeline_fill_nlmsg(skb, pipeline) <= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for pipeline");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int tcf_pipeline_del_one(struct net *net,
+				struct p4tc_template_common *tmpl,
+				struct netlink_ext_ack *extack)
+{
+	return tcf_pipeline_put(net, tmpl, false, extack);
+}
+
+static int tcf_pipeline_gd(struct net *net, struct sk_buff *skb,
+			   struct nlmsghdr *n, struct nlattr *nla,
+			   struct p4tc_nl_pname *nl_pname, u32 *ids,
+			   struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	u32 pipeid = ids[P4TC_PID_IDX];
+	struct p4tc_template_common *tmpl;
+	struct p4tc_pipeline *pipeline;
+	int ret = 0;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE &&
+	    (n->nlmsg_flags & NLM_F_ROOT)) {
+		NL_SET_ERR_MSG(extack, "Pipeline flush not supported");
+		return -EOPNOTSUPP;
+	}
+
+	pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid, extack);
+	if (IS_ERR(pipeline))
+		return PTR_ERR(pipeline);
+
+	tmpl = (struct p4tc_template_common *)pipeline;
+	if (tcf_pipeline_fill_nlmsg(net, skb, tmpl, extack) < 0)
+		return -1;
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = tcf_pipeline_del_one(net, tmpl, extack);
+		if (ret < 0)
+			goto out_nlmsg_trim;
+	}
+
+	return ret;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_pipeline_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			     struct nlattr *nla, char **p_name, u32 *ids,
+			     struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+
+	return tcf_p4_tmpl_generic_dump(skb, ctx, &pipe_net->pipeline_idr,
+					P4TC_PID_IDX, extack);
+}
+
+static int tcf_pipeline_dump_1(struct sk_buff *skb,
+			       struct p4tc_template_common *common)
+{
+	struct p4tc_pipeline *pipeline = to_pipeline(common);
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct nlattr *param;
+
+	/* Don't show kernel pipeline in dump */
+	if (pipeline->common.p_id == P4TC_KERNEL_PIPEID)
+		return 1;
+
+	param = nla_nest_start(skb, P4TC_PARAMS);
+	if (!param)
+		goto out_nlmsg_trim;
+	if (nla_put_string(skb, P4TC_PIPELINE_NAME, pipeline->common.name))
+		goto out_nlmsg_trim;
+
+	nla_nest_end(skb, param);
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -ENOMEM;
+}
+
+static int register_pipeline_pernet(void)
+{
+	return register_pernet_subsys(&pipeline_net_ops);
+}
+
+static void __tcf_pipeline_init(void)
+{
+	int pipeid = P4TC_KERNEL_PIPEID;
+
+	root_pipeline = kzalloc(sizeof(*root_pipeline), GFP_ATOMIC);
+	if (!root_pipeline) {
+		pr_err("Unable to register kernel pipeline\n");
+		return;
+	}
+
+	strscpy(root_pipeline->common.name, "kernel", PIPELINENAMSIZ);
+
+	root_pipeline->common.ops =
+		(struct p4tc_template_ops *)&p4tc_pipeline_ops;
+
+	root_pipeline->common.p_id = pipeid;
+
+	root_pipeline->p_state = P4TC_STATE_READY;
+}
+
+static void tcf_pipeline_init(void)
+{
+	if (register_pipeline_pernet() < 0)
+		pr_err("Failed to register per net pipeline IDR");
+
+	if (p4tc_register_types() < 0)
+		pr_err("Failed to register P4 types");
+
+	__tcf_pipeline_init();
+}
+
+const struct p4tc_template_ops p4tc_pipeline_ops = {
+	.init = tcf_pipeline_init,
+	.cu = tcf_pipeline_cu,
+	.fill_nlmsg = tcf_pipeline_fill_nlmsg,
+	.gd = tcf_pipeline_gd,
+	.put = tcf_pipeline_put,
+	.dump = tcf_pipeline_dump,
+	.dump_1 = tcf_pipeline_dump_1,
+};
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
new file mode 100644
index 000000000000..a936ec84841d
--- /dev/null
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_api.c	P4 TC API
+ *
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/netlink.h>
+#include <net/flow_offload.h>
+
+const struct nla_policy p4tc_root_policy[P4TC_ROOT_MAX + 1] = {
+	[P4TC_ROOT] = { .type = NLA_NESTED },
+	[P4TC_ROOT_PNAME] = { .type = NLA_STRING, .len = PIPELINENAMSIZ },
+};
+
+const struct nla_policy p4tc_policy[P4TC_MAX + 1] = {
+	[P4TC_PATH] = { .type = NLA_BINARY,
+			.len = P4TC_PATH_MAX * sizeof(u32) },
+	[P4TC_PARAMS] = { .type = NLA_NESTED },
+};
+
+static bool obj_is_valid(u32 obj)
+{
+	switch (obj) {
+	case P4TC_OBJ_PIPELINE:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
+	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
+};
+
+int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			     struct idr *idr, int idx,
+			     struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	unsigned long id = 0;
+	int i = 0;
+	struct p4tc_template_common *common;
+	unsigned long tmp;
+
+	id = ctx->ids[idx];
+
+	idr_for_each_entry_continue_ul(idr, common, tmp, id) {
+		struct nlattr *count;
+		int ret;
+
+		if (i == P4TC_MSGBATCH_SIZE)
+			break;
+
+		count = nla_nest_start(skb, i + 1);
+		if (!count)
+			goto out_nlmsg_trim;
+		ret = common->ops->dump_1(skb, common);
+		if (ret < 0) {
+			goto out_nlmsg_trim;
+		} else if (ret) {
+			nla_nest_cancel(skb, count);
+			continue;
+		}
+		nla_nest_end(skb, count);
+
+		i++;
+	}
+
+	if (i == 0) {
+		if (!ctx->ids[idx])
+			NL_SET_ERR_MSG(extack,
+				       "There are no pipeline components");
+		return 0;
+	}
+
+	ctx->ids[idx] = id;
+
+	return skb->len;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -ENOMEM;
+}
+
+static int tc_ctl_p4_tmpl_gd_1(struct net *net, struct sk_buff *skb,
+			       struct nlmsghdr *n, struct nlattr *arg,
+			       struct p4tc_nl_pname *nl_pname,
+			       struct netlink_ext_ack *extack)
+{
+	struct p4tcmsg *t = (struct p4tcmsg *)nlmsg_data(n);
+	u32 ids[P4TC_PATH_MAX] = {};
+	struct nlattr *tb[P4TC_MAX + 1];
+	struct p4tc_template_ops *op;
+	int ret;
+
+	if (!obj_is_valid(t->obj)) {
+		NL_SET_ERR_MSG(extack, "Invalid object type");
+		return -EINVAL;
+	}
+
+	ret = nla_parse_nested(tb, P4TC_MAX, arg, p4tc_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	ids[P4TC_PID_IDX] = t->pipeid;
+
+	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
+
+	ret = op->gd(net, skb, n, tb[P4TC_PARAMS], nl_pname, ids, extack);
+	if (ret < 0)
+		return ret;
+
+	if (!t->pipeid)
+		t->pipeid = ids[P4TC_PID_IDX];
+
+	return ret;
+}
+
+static int tc_ctl_p4_tmpl_gd_n(struct sk_buff *skb, struct nlmsghdr *n,
+			       char *p_name, struct nlattr *nla, int event,
+			       struct netlink_ext_ack *extack)
+{
+	struct p4tcmsg *t = (struct p4tcmsg *)nlmsg_data(n);
+	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
+	int ret = 0;
+	struct nlattr *tb[P4TC_MSGBATCH_SIZE + 1];
+	struct p4tc_nl_pname nl_pname;
+	struct sk_buff *new_skb;
+	struct p4tcmsg *t_new;
+	struct nlmsghdr *nlh;
+	struct nlattr *pnatt;
+	struct nlattr *root;
+	int i;
+
+	ret = nla_parse_nested(tb, P4TC_MSGBATCH_SIZE, nla, NULL, extack);
+	if (ret < 0)
+		return ret;
+
+	new_skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!new_skb)
+		return -ENOMEM;
+
+	nlh = nlmsg_put(new_skb, portid, n->nlmsg_seq, event, sizeof(*t),
+			n->nlmsg_flags);
+	if (!nlh) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	t_new = nlmsg_data(nlh);
+	t_new->pipeid = t->pipeid;
+	t_new->obj = t->obj;
+
+	pnatt = nla_reserve(new_skb, P4TC_ROOT_PNAME, PIPELINENAMSIZ);
+	if (!pnatt) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	nl_pname.data = nla_data(pnatt);
+	if (!p_name) {
+		/* Filled up by the operation or forced failure */
+		memset(nl_pname.data, 0, PIPELINENAMSIZ);
+		nl_pname.passed = false;
+	} else {
+		strscpy(nl_pname.data, p_name, PIPELINENAMSIZ);
+		nl_pname.passed = true;
+	}
+
+	root = nla_nest_start(new_skb, P4TC_ROOT);
+	for (i = 1; i < P4TC_MSGBATCH_SIZE + 1 && tb[i]; i++) {
+		struct nlattr *nest = nla_nest_start(new_skb, i);
+
+		ret = tc_ctl_p4_tmpl_gd_1(net, new_skb, nlh, tb[i], &nl_pname,
+					  extack);
+		if (n->nlmsg_flags & NLM_F_ROOT && event == RTM_DELP4TEMPLATE) {
+			if (ret <= 0)
+				goto out;
+		} else {
+			if (ret < 0)
+				goto out;
+		}
+		nla_nest_end(new_skb, nest);
+	}
+	nla_nest_end(new_skb, root);
+
+	nlmsg_end(new_skb, nlh);
+
+	if (event == RTM_GETP4TEMPLATE)
+		return rtnl_unicast(new_skb, net, portid);
+
+	return rtnetlink_send(new_skb, net, portid, RTNLGRP_TC,
+			      n->nlmsg_flags & NLM_F_ECHO);
+out:
+	kfree_skb(new_skb);
+	return ret;
+}
+
+static int tc_ctl_p4_tmpl_get(struct sk_buff *skb, struct nlmsghdr *n,
+			      struct netlink_ext_ack *extack)
+{
+	char *p_name = NULL;
+	struct nlattr *tb[P4TC_ROOT_MAX + 1];
+	int ret;
+
+	ret = nlmsg_parse(n, sizeof(struct p4tcmsg), tb, P4TC_ROOT_MAX,
+			  p4tc_root_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, P4TC_ROOT)) {
+		NL_SET_ERR_MSG(extack,
+			       "Netlink P4TC template attributes missing");
+		return -EINVAL;
+	}
+
+	if (tb[P4TC_ROOT_PNAME])
+		p_name = nla_data(tb[P4TC_ROOT_PNAME]);
+
+	return tc_ctl_p4_tmpl_gd_n(skb, n, p_name, tb[P4TC_ROOT],
+				   RTM_GETP4TEMPLATE, extack);
+}
+
+static int tc_ctl_p4_tmpl_delete(struct sk_buff *skb, struct nlmsghdr *n,
+				 struct netlink_ext_ack *extack)
+{
+	char *p_name = NULL;
+	struct nlattr *tb[P4TC_ROOT_MAX + 1];
+	int ret;
+
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = nlmsg_parse(n, sizeof(struct p4tcmsg), tb, P4TC_ROOT_MAX,
+			  p4tc_root_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, P4TC_ROOT)) {
+		NL_SET_ERR_MSG(extack,
+			       "Netlink P4TC template attributes missing");
+		return -EINVAL;
+	}
+
+	if (tb[P4TC_ROOT_PNAME])
+		p_name = nla_data(tb[P4TC_ROOT_PNAME]);
+
+	return tc_ctl_p4_tmpl_gd_n(skb, n, p_name, tb[P4TC_ROOT],
+				   RTM_DELP4TEMPLATE, extack);
+}
+
+static struct p4tc_template_common *
+tcf_p4_tmpl_cu_1(struct sk_buff *skb, struct net *net, struct nlmsghdr *n,
+		 struct p4tc_nl_pname *nl_pname, struct nlattr *nla,
+		 struct netlink_ext_ack *extack)
+{
+	struct p4tcmsg *t = (struct p4tcmsg *)nlmsg_data(n);
+	u32 ids[P4TC_PATH_MAX] = {};
+	struct nlattr *tb[P4TC_MAX + 1];
+	struct p4tc_template_common *tmpl;
+	struct p4tc_template_ops *op;
+	int ret;
+
+	if (!obj_is_valid(t->obj)) {
+		NL_SET_ERR_MSG(extack, "Invalid object type");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = nla_parse_nested(tb, P4TC_MAX, nla, p4tc_policy, extack);
+	if (ret < 0)
+		goto out;
+
+	if (NL_REQ_ATTR_CHECK(extack, nla, tb, P4TC_PARAMS)) {
+		NL_SET_ERR_MSG(extack, "Must specify object attributes");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ids[P4TC_PID_IDX] = t->pipeid;
+
+	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
+	tmpl = op->cu(net, n, tb[P4TC_PARAMS], nl_pname, ids, extack);
+	if (IS_ERR(tmpl))
+		return tmpl;
+
+	ret = op->fill_nlmsg(net, skb, tmpl, extack);
+	if (ret < 0)
+		goto put;
+
+	if (!t->pipeid)
+		t->pipeid = ids[P4TC_PID_IDX];
+
+	return tmpl;
+
+put:
+	op->put(net, tmpl, false, extack);
+
+out:
+	return ERR_PTR(ret);
+}
+
+static int tcf_p4_tmpl_cu_n(struct sk_buff *skb, struct nlmsghdr *n,
+			    struct nlattr *nla, char *p_name,
+			    struct netlink_ext_ack *extack)
+{
+	struct p4tcmsg *t = (struct p4tcmsg *)nlmsg_data(n);
+	struct net *net = sock_net(skb->sk);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct p4tc_template_common *tmpls[P4TC_MSGBATCH_SIZE];
+	struct nlattr *tb[P4TC_MSGBATCH_SIZE + 1];
+	struct p4tc_nl_pname nl_pname;
+	struct sk_buff *new_skb;
+	struct p4tcmsg *t_new;
+	struct nlmsghdr *nlh;
+	struct nlattr *pnatt;
+	struct nlattr *root;
+	int ret;
+	int i;
+
+	ret = nla_parse_nested(tb, P4TC_MSGBATCH_SIZE, nla, NULL, extack);
+	if (ret < 0)
+		return ret;
+
+	new_skb = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
+	if (!new_skb)
+		return -ENOMEM;
+
+	nlh = nlmsg_put(new_skb, portid, n->nlmsg_seq, RTM_CREATEP4TEMPLATE,
+			sizeof(*t), n->nlmsg_flags);
+	if (!nlh)
+		goto out;
+
+	t_new = nlmsg_data(nlh);
+	if (!t_new) {
+		NL_SET_ERR_MSG(extack, "Message header is missing");
+		ret = -EINVAL;
+		goto out;
+	}
+	t_new->pipeid = t->pipeid;
+	t_new->obj = t->obj;
+
+	pnatt = nla_reserve(new_skb, P4TC_ROOT_PNAME, PIPELINENAMSIZ);
+	if (!pnatt) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	nl_pname.data = nla_data(pnatt);
+	if (!p_name) {
+		/* Filled up by the operation or forced failure */
+		memset(nl_pname.data, 0, PIPELINENAMSIZ);
+		nl_pname.passed = false;
+	} else {
+		strscpy(nl_pname.data, p_name, PIPELINENAMSIZ);
+		nl_pname.passed = true;
+	}
+
+	root = nla_nest_start(new_skb, P4TC_ROOT);
+	if (!root) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* XXX: See if we can use NLA_NESTED_ARRAY here */
+	for (i = 0; i < P4TC_MSGBATCH_SIZE && tb[i + 1]; i++) {
+		struct nlattr *nest = nla_nest_start(new_skb, i + 1);
+
+		tmpls[i] = tcf_p4_tmpl_cu_1(new_skb, net, nlh, &nl_pname,
+					    tb[i + 1], extack);
+		if (IS_ERR(tmpls[i])) {
+			ret = PTR_ERR(tmpls[i]);
+			goto undo_prev;
+		}
+
+		nla_nest_end(new_skb, nest);
+	}
+	nla_nest_end(new_skb, root);
+
+	if (!t_new->pipeid)
+		t_new->pipeid = ret;
+
+	nlmsg_end(new_skb, nlh);
+
+	return rtnetlink_send(new_skb, net, portid, RTNLGRP_TC,
+			      n->nlmsg_flags & NLM_F_ECHO);
+
+undo_prev:
+	if (!(nlh->nlmsg_flags & NLM_F_REPLACE)) {
+		while (--i > 0) {
+			struct p4tc_template_common *tmpl = tmpls[i - 1];
+
+			tmpl->ops->put(net, tmpl, false, extack);
+		}
+	}
+
+out:
+	kfree_skb(new_skb);
+	return ret;
+}
+
+static int tc_ctl_p4_tmpl_cu(struct sk_buff *skb, struct nlmsghdr *n,
+			     struct netlink_ext_ack *extack)
+{
+	char *p_name = NULL;
+	int ret = 0;
+	struct nlattr *tb[P4TC_ROOT_MAX + 1];
+
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = nlmsg_parse(n, sizeof(struct p4tcmsg), tb, P4TC_ROOT_MAX,
+			  p4tc_root_policy, extack);
+	if (ret < 0)
+		return ret;
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, P4TC_ROOT)) {
+		NL_SET_ERR_MSG(extack,
+			       "Netlink P4TC template attributes missing");
+		return -EINVAL;
+	}
+
+	if (tb[P4TC_ROOT_PNAME])
+		p_name = nla_data(tb[P4TC_ROOT_PNAME]);
+
+	return tcf_p4_tmpl_cu_n(skb, n, tb[P4TC_ROOT], p_name, extack);
+}
+
+static int tc_ctl_p4_tmpl_dump_1(struct sk_buff *skb, struct nlattr *arg,
+				 char *p_name, struct netlink_callback *cb)
+{
+	struct p4tc_dump_ctx *ctx = (void *)cb->ctx;
+	struct netlink_ext_ack *extack = cb->extack;
+	u32 portid = NETLINK_CB(cb->skb).portid;
+	const struct nlmsghdr *n = cb->nlh;
+	u32 ids[P4TC_PATH_MAX] = {};
+	struct nlattr *tb[P4TC_MAX + 1];
+	struct p4tc_template_ops *op;
+	struct p4tcmsg *t_new;
+	struct nlmsghdr *nlh;
+	struct nlattr *root;
+	struct p4tcmsg *t;
+	int ret;
+
+	ret = nla_parse_nested_deprecated(tb, P4TC_MAX, arg, p4tc_policy,
+					  extack);
+	if (ret < 0)
+		return ret;
+
+	t = (struct p4tcmsg *)nlmsg_data(n);
+	if (!obj_is_valid(t->obj)) {
+		NL_SET_ERR_MSG(extack, "Invalid object type");
+		return -EINVAL;
+	}
+
+	nlh = nlmsg_put(skb, portid, n->nlmsg_seq, RTM_GETP4TEMPLATE,
+			sizeof(*t), n->nlmsg_flags);
+	if (!nlh)
+		return -ENOSPC;
+
+	t_new = nlmsg_data(nlh);
+	t_new->pipeid = t->pipeid;
+	t_new->obj = t->obj;
+
+	root = nla_nest_start(skb, P4TC_ROOT);
+
+	ids[P4TC_PID_IDX] = t->pipeid;
+
+	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
+	ret = op->dump(skb, ctx, tb[P4TC_PARAMS], &p_name, ids, extack);
+	if (ret <= 0)
+		goto out;
+	nla_nest_end(skb, root);
+
+	if (p_name) {
+		if (nla_put_string(skb, P4TC_ROOT_PNAME, p_name)) {
+			ret = -1;
+			goto out;
+		}
+	}
+
+	if (!t_new->pipeid)
+		t_new->pipeid = ids[P4TC_PID_IDX];
+
+	nlmsg_end(skb, nlh);
+
+	return ret;
+
+out:
+	nlmsg_cancel(skb, nlh);
+	return ret;
+}
+
+static int tc_ctl_p4_tmpl_dump(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	char *p_name = NULL;
+	struct nlattr *tb[P4TC_ROOT_MAX + 1];
+	int ret;
+
+	ret = nlmsg_parse(cb->nlh, sizeof(struct p4tcmsg), tb, P4TC_ROOT_MAX,
+			  p4tc_root_policy, cb->extack);
+	if (ret < 0)
+		return ret;
+
+	if (NL_REQ_ATTR_CHECK(cb->extack, NULL, tb, P4TC_ROOT)) {
+		NL_SET_ERR_MSG(cb->extack,
+			       "Netlink P4TC template attributes missing");
+		return -EINVAL;
+	}
+
+	if (tb[P4TC_ROOT_PNAME])
+		p_name = nla_data(tb[P4TC_ROOT_PNAME]);
+
+	return tc_ctl_p4_tmpl_dump_1(skb, tb[P4TC_ROOT], p_name, cb);
+}
+
+static int __init p4tc_template_init(void)
+{
+	u32 obj;
+
+	rtnl_register(PF_UNSPEC, RTM_CREATEP4TEMPLATE, tc_ctl_p4_tmpl_cu, NULL,
+		      0);
+	rtnl_register(PF_UNSPEC, RTM_DELP4TEMPLATE, tc_ctl_p4_tmpl_delete, NULL,
+		      0);
+	rtnl_register(PF_UNSPEC, RTM_GETP4TEMPLATE, tc_ctl_p4_tmpl_get,
+		      tc_ctl_p4_tmpl_dump, 0);
+
+	for (obj = P4TC_OBJ_PIPELINE; obj < P4TC_OBJ_MAX; obj++) {
+		const struct p4tc_template_ops *op = p4tc_ops[obj];
+
+		if (!obj_is_valid(obj))
+			continue;
+
+		if (op->init)
+			op->init();
+	}
+
+	return 0;
+}
+
+subsys_initcall(p4tc_template_init);
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 2ee7b4ed43ef..0a8daf2f8f2a 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -94,6 +94,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] = {
 	{ RTM_NEWTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETTUNNEL,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_CREATEP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_DELP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
+	{ RTM_GETP4TEMPLATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ },
 };
 
 static const struct nlmsg_perm nlmsg_tcpdiag_perms[] = {
@@ -176,7 +179,7 @@ int selinux_nlmsg_lookup(u16 sclass, u16 nlmsg_type, u32 *perm)
 		 * structures at the top of this file with the new mappings
 		 * before updating the BUILD_BUG_ON() macro!
 		 */
-		BUILD_BUG_ON(RTM_MAX != (RTM_NEWTUNNEL + 3));
+		BUILD_BUG_ON(RTM_MAX != (RTM_CREATEP4TEMPLATE + 3));
 		err = nlmsg_perm(nlmsg_type, perm, nlmsg_route_perms,
 				 sizeof(nlmsg_route_perms));
 		break;
-- 
2.25.1


