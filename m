Return-Path: <netdev+bounces-3297-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 653FA70662D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:08:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2D1C11C20ED8
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:08:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C702171BF;
	Wed, 17 May 2023 11:04:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D15171BC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:44 +0000 (UTC)
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C663910D8
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:16 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-6238417112aso2638106d6.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321445; x=1686913445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uozZ7wnqOWXy8C0w/gU5k36K6Xw5xGL8KRXHjOefN9A=;
        b=qDcWxviezN3N41vKMFtha5rcO+NPc44EIyA839EZuLGbrTQ+EqIMIk5EDzZtvFLRlY
         8nMas7JoYh3tsb9pIPb0Q9hHr6IGmO9XiFwHcdGLDV+nNerUE7wXHgzldGVLpagCMVbd
         eAf4ZjuaGlzG+sFqLkcjOz4+U/p0FuGN5sLpAEED/lLQZ5MZdfnQITHsfvyOxmxqJ2WL
         R9FBL0YoMwjXXV5up051RIrQOvCelJCDzZuoNlLl5uXi/p4QXoSAjQRezdQHv6dVykYy
         LE4aLDFlxCY5zBnUAfLRjvwlvLxgk/zw9W0zdydK/iyxbIiV1b2pQIkeM1YbR1f0Zl5v
         zfkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321445; x=1686913445;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uozZ7wnqOWXy8C0w/gU5k36K6Xw5xGL8KRXHjOefN9A=;
        b=Tz11NL/zMQZeA5UiLOXIuUBhDn1jYibJUhFn4ituZ4ta/8mVEM/2RmB3IUS0EULBEy
         gdY7Q/OXK+6p7sDdrcO9wKxoMdmRpQmDCnpVsvNAggGrskeTCxgmLscbhMgEV/qLw9Z6
         wkYYMNHrQn3i3CtmCm6ecFBeJHnV3ps/mABDz+3I6qIi5BtIEBuoxlkOerjcsz0J5zo4
         pPUQRpmt8bW2Hs07GIW5iilTwvYFz3NM8gLJNrSnAg4GDGleA/agBT/6+Lf2eZGOdTEg
         qPOaEElapwfAeSiqWnirnh1ZeWEIrZeXY/21GJ2eFSnxrS1Gdgw3AdWK6RQqNGFPUo36
         iPFA==
X-Gm-Message-State: AC+VfDwY1bbjbGutdaVg21Z5GxhBm0AlJ1lhU/F1H9P4ipPo5IusKpGL
	kquSoJfujinXRO82CR92NQbbHofPlTMZFcc95QQ=
X-Google-Smtp-Source: ACHHUZ61wUWhSC8ihhVg1lXAh1rb6qZ8Z+Dy6q4xkA/gL8vgW/K0HQ0LlLoTBW6ENpWBILYtlwcWkw==
X-Received: by 2002:a05:6214:20e2:b0:61a:281b:9a5d with SMTP id 2-20020a05621420e200b0061a281b9a5dmr56918964qvk.5.1684321444253;
        Wed, 17 May 2023 04:04:04 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id j7-20020a0ce007000000b0062168714c8fsm4314441qvk.120.2023.05.17.04.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:04:03 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 13/28] p4tc: add action template create, update, delete, get, flush and dump
Date: Wed, 17 May 2023 07:02:17 -0400
Message-Id: <20230517110232.29349-13-jhs@mojatatu.com>
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

This commit allows users to create, update, delete, get, flush and dump
dynamic actions based on P4 action definition.

At the moment dynamic actions are tied to P4 programs only and cannot be
used outside of a P4 program definition.

Visualize the following action in a P4 program:

action ipv4_forward(bit<48> dstAddr, bit<8> port)
{
     standard_metadata.egress_spec = port;
     hdr.ethernet.srcAddr = hdr.ethernet.dstAddr;
     hdr.ethernet.dstAddr = dstAddr;
     hdr.ipv4.ttl = hdr.ipv4.ttl - 1;
}

which is invoked on a P4 table match as such:

table mytable {
        key = {
            hdr.ipv4.dstAddr: lpm;
        }

        actions = {
            ipv4_forward;
            drop;
            NoAction;
        }

        size = 1024;
}

We don't have an equivalent built in "ipv4_forward" action in TC. So we
create this action dynamically.

The mechanics of dynamic actions follow the CRUD semantics.

___DYNAMIC CREATION___

In this stage we issue the creation command for the dynamic action which
specifies the action  name, its ID, parameters and the parameter types.
So for the ipv4_forward action, the creation would look something like this:

tc p4template create action/aP4proggie/ipv4_forward \
  param dstAddr type macaddr id 1 param port type dev id 2

Note1: Although the P4 program defined dstAddr as type bit48 we use our
type called macaddr (likewise for port) - see commit on p4 types for
details.

Note that in the template creation op we usually just specify the action
name, the parameters and their respective types. Also see that we specify
a pipeline name during the template creation command. As an example, the
above command creates an action template that is bounded to
pipeline/program named aP4proggie. Also, below is an example of how one
would specify an ID to the action template created in the above command.
When the create doesn't specify the action template ID, the kernel
assigns a new one for us. Also, if the action template ID specified in
the command is already in use, the kernel will reject the command.

tc p4template create action/aP4proggie/ipv4_forward actid 1 \
  param dstAddr type macaddr id 1 param port type dev id 2

The compiler (for example P4C) will always define the actid.

Per the P4 specification, actions might be contained in a control block.

___OPS_DESCRIPTION___

In the next stage (ops description), we need to specify which operations
this action uses. As example, if we were to specify the operations for
the ipv4_forward action, we'd update the created action and issue the
following command:

tc p4template update action/aP4proggie/ipv4_forward \
     cmd set metadata.aP4proggie.temp hdrfield.aP4proggie.parser1.ethernet.dstAddr   \
     cmd set hdrfield.P4proggie.parser1.ethernet.dstAddr hdrfield.P4proggie.parser1.ethernet.srcAddr \
     cmd set hdrfield.P4proggie.parser1.ethernet.srcAddr  metadata.aP4proggie.temp \
     cmd set metadata.calc.egress_spec param.port \
     cmd decr hdrfield.P4proggie.parser1.ipv4.ttl

As you can see, we refer to the argument values in the ipv4_forward action
using "param" prefix. So, for example, when referring to the argument port
in a ipv4_forward, we use "param.port".

Of course the two steps could be combined as so when creating the action:

tc p4template create action/aP4proggie/ipv4_forward actid 1 \
  param dstAddr type macaddr id 1 param port type dev id 2 \
  cmd set metadata.aP4proggie.temp hdrfield.aP4proggie.parser1.ethernet.dstAddr   \
  cmd set hdrfield.P4proggie.parser1.ethernet.dstAddr hdrfield.P4proggie.parser1.ethernet.srcAddr \
  cmd set hdrfield.P4proggie.parser1.ethernet.srcAddr  metadata.aP4proggie.temp \
  cmd set metadata.calc.egress_spec param.port \
  cmd decr hdrfield.P4proggie.parser1.ipv4.ttl

___ACTION_ACTIVATION___

Once we provided all the necessary information for the new dynamic action,
we can go to the final stage, which is action activation. In this stage,
we activate the dynamic action and make it available for instantiation.
To activate the action template, we issue the following command:

tc p4template update action aP4proggie/ipv4_forward state active

After the above the command, the action is ready to be instantiated.

___RUNTIME___

This next section deals with the runtime part of action templates, which
handle action template instantiation and binding.

To instantiate a new action from a template, we use the following command:

tc actions add action aP4proggie/ipv4_forward \
param dstAddr AA:BB:CC:DD:EE:FF param port eth0 index 1

Observe these are the same semantics as what tc today already provides
with a caveat that we have a keyword "param" to precede the appropriate
parameters - as such specifying the index is optional (kernel provides
one when unspecified).

As previously stated, we refer to the action by it's "full name"
(pipeline_name/action_name). Here we are creating an instance of the
ipv4_forward action specifying as parameter values AA:BB:CC:DD:EE:FF for
dstAddr and eth0 for port. We can create as many instances for action
templates as we wish.

To bind the above instantiated action to a table entry, you can do use the
same approach used to bind ordinary actions to filter, for example:

tc p4runtime create aP4proggie/table/mycontrol/mytable srcAddr 10.10.10.0/24 \
action ipv4_forward index 1

The above command will bind our newly instantiated action to a table
entry which is executed if there's a match.

Of course one could have created the table entry as:

tc p4runtime create aP4proggie/table/mycontrol/mytable srcAddr 10.10.10.0/24 \
action ipv4_forward param dstAddr AA:BB:CC:DD:EE:FF param port eth0

Actions from other control blocks might be referenced as the action
index is per pipeline.

___OTHER_CONTROL_COMMANDS___

The lifetime of the dynamic action is tied to its pipeline.
As with all pipeline components, write operations to action templates, such
as create, update and delete, can only be executed if the pipeline is not
sealed. Read/get can be issued even after the pipeline is sealed.

If, after we are done with our action template we want to delete it, we
should issue the following command:

tc p4template del action/aP4proggie/ipv4_forward

Note that we could also not specify the action name and use the ID instead,
which would transform the above command into the following:

tc p4template del action/aP4proggie actid 1

If we had created more action templates and wanted to flush all of the
action templates from pipeline aP4proggie, one would use the following
command:

tc p4template del action/aP4proggie/

After creating or updating a dynamic actions, if one wishes to verify that
the dynamic action was created correctly, one would use the following
command:

tc p4template get action/aP4proggie/ipv4_forward

As with the del operation, when can also specify the action id instead of
the action name:

tc p4template get action/aP4proggie actid 1

The above command will display the relevant data for the action,
such as parameter names, types, etc.

If one wanted to check which action templates were associated to a specific
pipeline, one could use the following command:

tc p4template get action/aP4proggie/

Note that this command will only display the name of these action
templates. To verify their specific details, one should use the get
command, which was previously described.

Tested-by: "Khan, Mohd Arif" <mohd.arif.khan@intel.com>
Tested-by: "Pottimurthy, Sathya Narayana" <sathya.narayana.pottimurthy@intel.com>
Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/act_api.h          |    1 +
 include/net/p4tc.h             |  177 +++
 include/net/sch_generic.h      |    5 +
 include/net/tc_act/p4tc.h      |   27 +
 include/uapi/linux/p4tc.h      |   46 +
 net/sched/p4tc/Makefile        |    2 +-
 net/sched/p4tc/p4tc_action.c   | 1840 ++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_meta.c     |   61 ++
 net/sched/p4tc/p4tc_pipeline.c |  274 ++++-
 net/sched/p4tc/p4tc_tmpl_api.c |    2 +
 10 files changed, 2409 insertions(+), 26 deletions(-)
 create mode 100644 include/net/tc_act/p4tc.h
 create mode 100644 net/sched/p4tc/p4tc_action.c

diff --git a/include/net/act_api.h b/include/net/act_api.h
index a0f443990f27..f631c0e2da1b 100644
--- a/include/net/act_api.h
+++ b/include/net/act_api.h
@@ -68,6 +68,7 @@ struct tc_action {
 #define TCA_ACT_FLAGS_REPLACE	(1U << (TCA_ACT_FLAGS_USER_BITS + 2))
 #define TCA_ACT_FLAGS_NO_RTNL	(1U << (TCA_ACT_FLAGS_USER_BITS + 3))
 #define TCA_ACT_FLAGS_AT_INGRESS	(1U << (TCA_ACT_FLAGS_USER_BITS + 4))
+#define TCA_ACT_FLAGS_FROM_P4TC	(1U << (TCA_ACT_FLAGS_USER_BITS + 5))
 
 /* Update lastuse only if needed, to avoid dirtying a cache line.
  * We use a temp variable to avoid fetching jiffies twice.
diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 096f52c4320e..6111566b05eb 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -9,6 +9,8 @@
 #include <linux/refcount.h>
 #include <linux/rhashtable.h>
 #include <linux/rhashtable-types.h>
+#include <net/tc_act/p4tc.h>
+#include <net/p4tc_types.h>
 
 #define P4TC_DEFAULT_NUM_TABLES P4TC_MINTABLES_COUNT
 #define P4TC_DEFAULT_MAX_RULES 1
@@ -19,6 +21,7 @@
 
 #define P4TC_PID_IDX 0
 #define P4TC_MID_IDX 1
+#define P4TC_AID_IDX 1
 #define P4TC_PARSEID_IDX 1
 #define P4TC_HDRFIELDID_IDX 2
 
@@ -36,6 +39,7 @@ DECLARE_PER_CPU(struct p4tc_percpu_scratchpad, p4tc_percpu_scratchpad);
 
 struct p4tc_dump_ctx {
 	u32 ids[P4TC_PATH_MAX];
+	struct rhashtable_iter *iter;
 };
 
 struct p4tc_template_common;
@@ -92,9 +96,21 @@ struct p4tc_template_common {
 
 extern const struct p4tc_template_ops p4tc_pipeline_ops;
 
+struct p4tc_act_dep_edge_node {
+	struct list_head head;
+	u32 act_id;
+};
+
+struct p4tc_act_dep_node {
+	struct list_head incoming_egde_list;
+	struct list_head head;
+	u32 act_id;
+};
+
 struct p4tc_pipeline {
 	struct p4tc_template_common common;
 	struct idr                  p_meta_idr;
+	struct idr                  p_act_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
 	struct p4tc_parser          *parser;
@@ -102,13 +118,17 @@ struct p4tc_pipeline {
 	int                         num_preacts;
 	struct tc_action            **postacts;
 	int                         num_postacts;
+	struct list_head            act_dep_graph;
+	struct list_head            act_topological_order;
 	u32                         max_rules;
 	u32                         p_meta_offset;
+	u32                         num_created_acts;
 	refcount_t                  p_ref;
 	refcount_t                  p_ctrl_ref;
 	u16                         num_tables;
 	u16                         curr_tables;
 	u8                          p_state;
+	refcount_t                  p_hdrs_used;
 };
 
 struct p4tc_pipeline_net {
@@ -149,6 +169,18 @@ static inline bool pipeline_sealed(struct p4tc_pipeline *pipeline)
 {
 	return pipeline->p_state == P4TC_STATE_READY;
 }
+void tcf_pipeline_add_dep_edge(struct p4tc_pipeline *pipeline,
+			       struct p4tc_act_dep_edge_node *edge_node,
+			       u32 vertex_id);
+bool tcf_pipeline_check_act_backedge(struct p4tc_pipeline *pipeline,
+				     struct p4tc_act_dep_edge_node *edge_node,
+				     u32 vertex_id);
+int determine_act_topological_order(struct p4tc_pipeline *pipeline,
+				    bool copy_dep_graph);
+
+struct p4tc_act;
+void tcf_pipeline_delete_from_dep_graph(struct p4tc_pipeline *pipeline,
+					struct p4tc_act *act);
 
 struct p4tc_metadata {
 	struct p4tc_template_common common;
@@ -165,6 +197,68 @@ struct p4tc_metadata {
 
 extern const struct p4tc_template_ops p4tc_meta_ops;
 
+struct p4tc_ipv4_param_value {
+	u32 value;
+	u32 mask;
+};
+
+#define P4TC_ACT_PARAM_FLAGS_ISDYN BIT(0)
+
+struct p4tc_act_param {
+	char            name[ACTPARAMNAMSIZ];
+	struct list_head head;
+	struct rcu_head	rcu;
+	void            *value;
+	void            *mask;
+	struct p4tc_type *type;
+	u32             id;
+	u32             index;
+	u8              flags;
+};
+
+struct p4tc_act_param_ops {
+	int (*init_value)(struct net *net, struct p4tc_act_param_ops *op,
+			  struct p4tc_act_param *nparam, struct nlattr **tb,
+			  struct netlink_ext_ack *extack);
+	int (*dump_value)(struct sk_buff *skb, struct p4tc_act_param_ops *op,
+			  struct p4tc_act_param *param);
+	void (*free)(struct p4tc_act_param *param);
+	u32 len;
+	u32 alloc_len;
+};
+
+struct p4tc_label_key {
+	char *label;
+	u32 labelsz;
+};
+
+struct p4tc_label_node {
+	struct rhash_head ht_node;
+	struct p4tc_label_key key;
+	int cmd_offset;
+};
+
+struct p4tc_act {
+	struct p4tc_template_common common;
+	struct tc_action_ops        ops;
+	struct rhashtable           *labels;
+	struct list_head            cmd_operations;
+	struct tc_action_net        *tn;
+	struct p4tc_pipeline        *pipeline;
+	struct idr                  params_idr;
+	struct tcf_exts             exts;
+	struct list_head            head;
+	u32                         a_id;
+	u32                         num_params;
+	bool                        active;
+	refcount_t                  a_ref;
+};
+
+extern const struct p4tc_template_ops p4tc_act_ops;
+extern const struct rhashtable_params p4tc_label_ht_params;
+extern const struct rhashtable_params acts_params;
+void p4tc_label_ht_destroy(void *ptr, void *arg);
+
 struct p4tc_parser {
 	char parser_name[PARSERNAMSIZ];
 	struct idr hdr_fields_idr;
@@ -194,6 +288,69 @@ struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
 				   const char *mname, const u32 m_id,
 				   struct netlink_ext_ack *extack);
 void tcf_meta_put_ref(struct p4tc_metadata *meta);
+void *tcf_meta_fetch(struct sk_buff *skb, struct p4tc_metadata *meta);
+
+static inline int p4tc_action_init(struct net *net, struct nlattr *nla,
+				   struct tc_action *acts[], u32 pipeid,
+				   u32 flags, struct netlink_ext_ack *extack)
+{
+	int init_res[TCA_ACT_MAX_PRIO];
+	size_t attrs_size;
+	int ret;
+	int i;
+
+	/* If action was already created, just bind to existing one*/
+	flags |= TCA_ACT_FLAGS_BIND;
+	flags |= TCA_ACT_FLAGS_FROM_P4TC;
+	ret = tcf_action_init(net, NULL, nla, NULL, acts, init_res, &attrs_size,
+			      flags, 0, extack);
+
+	/* Check if we are trying to bind to dynamic action from different pipe */
+	for (i = 0; i < TCA_ACT_MAX_PRIO && acts[i]; i++) {
+		struct tc_action *a = acts[i];
+		struct tcf_p4act *p;
+
+		if (a->ops->id < TCA_ID_DYN)
+			continue;
+
+		p = to_p4act(a);
+		if (p->p_id != pipeid) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to bind to dynact from different pipeline");
+			ret = -EPERM;
+			goto destroy_acts;
+		}
+	}
+
+	return ret;
+
+destroy_acts:
+	tcf_action_destroy(acts, TCA_ACT_FLAGS_BIND);
+	return ret;
+}
+
+struct p4tc_act *tcf_action_find_byid(struct p4tc_pipeline *pipeline,
+				      const u32 a_id);
+struct p4tc_act *tcf_action_find_byname(const char *act_name,
+					struct p4tc_pipeline *pipeline);
+struct p4tc_act *tcf_action_find_byany(struct p4tc_pipeline *pipeline,
+				       const char *act_name, const u32 a_id,
+				       struct netlink_ext_ack *extack);
+struct p4tc_act *tcf_action_get(struct p4tc_pipeline *pipeline,
+				const char *act_name, const u32 a_id,
+				struct netlink_ext_ack *extack);
+void tcf_action_put(struct p4tc_act *act);
+int tcf_p4_dyna_template_init(struct net *net, struct tc_action **a,
+			      struct p4tc_act *act,
+			      struct list_head *params_list,
+			      struct tc_act_dyna *parm, u32 flags,
+			      struct netlink_ext_ack *extack);
+struct p4tc_act_param *tcf_param_find_byid(struct idr *params_idr,
+					   const u32 param_id);
+struct p4tc_act_param *tcf_param_find_byany(struct p4tc_act *act,
+					    const char *param_name,
+					    const u32 param_id,
+					    struct netlink_ext_ack *extack);
 
 struct p4tc_parser *tcf_parser_create(struct p4tc_pipeline *pipeline,
 				      const char *parser_name,
@@ -222,8 +379,28 @@ struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
 				       struct netlink_ext_ack *extack);
 void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield);
 
+int p4tc_init_net_ops(struct net *net, unsigned int id);
+void p4tc_exit_net_ops(struct list_head *net_list, unsigned int id);
+int tcf_p4_act_init_params(struct net *net, struct tcf_p4act_params *params,
+			   struct p4tc_act *act, struct nlattr *nla,
+			   struct netlink_ext_ack *extack);
+void tcf_p4_act_params_destroy(struct tcf_p4act_params *params);
+int p4_act_init(struct p4tc_act *act, struct nlattr *nla,
+		struct p4tc_act_param *params[],
+		struct netlink_ext_ack *extack);
+void p4_put_many_params(struct idr *params_idr, struct p4tc_act_param *params[],
+			int params_count);
+void tcf_p4_act_params_destroy_rcu(struct rcu_head *head);
+int p4_act_init_params(struct p4tc_act *act, struct nlattr *nla,
+		       struct p4tc_act_param *params[], bool update,
+		       struct netlink_ext_ack *extack);
+extern const struct p4tc_act_param_ops param_ops[P4T_MAX + 1];
+int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
+			     struct p4tc_act_param *param);
+
 #define to_pipeline(t) ((struct p4tc_pipeline *)t)
 #define to_meta(t) ((struct p4tc_metadata *)t)
 #define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
+#define to_act(t) ((struct p4tc_act *)t)
 
 #endif
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index fab5ba3e61b7..1b3b12b1ba59 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -326,6 +326,11 @@ struct tcf_result {
 		};
 		const struct tcf_proto *goto_tp;
 
+		struct {
+			bool hit;
+			bool miss;
+			int action_run_id;
+		};
 	};
 };
 
diff --git a/include/net/tc_act/p4tc.h b/include/net/tc_act/p4tc.h
new file mode 100644
index 000000000000..8526559c74dc
--- /dev/null
+++ b/include/net/tc_act/p4tc.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __NET_TC_ACT_P4_H
+#define __NET_TC_ACT_P4_H
+
+#include <net/pkt_cls.h>
+#include <net/act_api.h>
+
+struct tcf_p4act_params {
+	struct tcf_exts exts;
+	struct idr params_idr;
+	struct p4tc_act_param **params_array;
+	struct rcu_head rcu;
+	u32 num_params;
+};
+
+struct tcf_p4act {
+	struct tc_action common;
+	/* list of operations */
+	struct list_head cmd_operations;
+	/* Params IDR reference passed during runtime */
+	struct tcf_p4act_params __rcu *params;
+	u32 p_id;
+	u32 act_id;
+};
+#define to_p4act(a) ((struct tcf_p4act *)a)
+
+#endif /* __NET_TC_ACT_P4_H */
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 72714df9e74f..15876c471266 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -4,6 +4,7 @@
 
 #include <linux/types.h>
 #include <linux/pkt_sched.h>
+#include <linux/pkt_cls.h>
 
 /* pipeline header */
 struct p4tcmsg {
@@ -29,6 +30,9 @@ struct p4tcmsg {
 #define METANAMSIZ TEMPLATENAMSZ
 #define PARSERNAMSIZ TEMPLATENAMSZ
 #define HDRFIELDNAMSIZ TEMPLATENAMSZ
+#define ACTPARAMNAMSIZ TEMPLATENAMSZ
+
+#define LABELNAMSIZ 32
 
 /* Root attributes */
 enum {
@@ -58,6 +62,7 @@ enum {
 	P4TC_OBJ_PIPELINE,
 	P4TC_OBJ_META,
 	P4TC_OBJ_HDR_FIELD,
+	P4TC_OBJ_ACT,
 	__P4TC_OBJ_MAX,
 };
 #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
@@ -172,6 +177,47 @@ enum {
 };
 #define P4TC_HDRFIELD_MAX (__P4TC_HDRFIELD_MAX - 1)
 
+/* Action attributes */
+enum {
+	P4TC_ACT_UNSPEC,
+	P4TC_ACT_NAME, /* string */
+	P4TC_ACT_PARMS, /* nested params */
+	P4TC_ACT_OPT, /* action opt */
+	P4TC_ACT_TM, /* action tm */
+	P4TC_ACT_CMDS_LIST, /* command list */
+	P4TC_ACT_ACTIVE, /* u8 */
+	P4TC_ACT_PAD,
+	__P4TC_ACT_MAX
+};
+#define P4TC_ACT_MAX __P4TC_ACT_MAX
+
+#define P4TC_CMDS_LIST_MAX 32
+
+/* Action params attributes */
+enum {
+	P4TC_ACT_PARAMS_VALUE_UNSPEC,
+	P4TC_ACT_PARAMS_VALUE_RAW, /* binary */
+	P4TC_ACT_PARAMS_VALUE_OPND, /* struct p4tc_u_operand */
+	__P4TC_ACT_PARAMS_VALUE_MAX
+};
+#define P4TC_ACT_VALUE_PARAMS_MAX __P4TC_ACT_PARAMS_VALUE_MAX
+
+/* Action params attributes */
+enum {
+	P4TC_ACT_PARAMS_UNSPEC,
+	P4TC_ACT_PARAMS_NAME, /* string */
+	P4TC_ACT_PARAMS_ID, /* u32 */
+	P4TC_ACT_PARAMS_VALUE, /* bytes */
+	P4TC_ACT_PARAMS_MASK, /* bytes */
+	P4TC_ACT_PARAMS_TYPE, /* u32 */
+	__P4TC_ACT_PARAMS_MAX
+};
+#define P4TC_ACT_PARAMS_MAX __P4TC_ACT_PARAMS_MAX
+
+struct tc_act_dyna {
+	tc_gen;
+};
+
 #define P4TC_RTA(r) \
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
 
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index add22c909be6..3f7267366827 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
-	p4tc_parser_api.o p4tc_hdrfield.o
+	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o
diff --git a/net/sched/p4tc/p4tc_action.c b/net/sched/p4tc/p4tc_action.c
new file mode 100644
index 000000000000..617aed297a58
--- /dev/null
+++ b/net/sched/p4tc/p4tc_action.c
@@ -0,0 +1,1840 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_action.c	P4 TC ACTION TEMPLATES
+ *
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/err.h>
+#include <linux/errno.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/kmod.h>
+#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <net/flow_offload.h>
+#include <net/net_namespace.h>
+#include <net/netlink.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/sch_generic.h>
+#include <net/sock.h>
+#include <net/tc_act/p4tc.h>
+
+static LIST_HEAD(dynact_list);
+
+#define SEPARATOR "/"
+
+static u32 label_hash_fn(const void *data, u32 len, u32 seed)
+{
+	const struct p4tc_label_key *key = data;
+
+	return jhash(key->label, key->labelsz, seed);
+}
+
+static int label_hash_cmp(struct rhashtable_compare_arg *arg, const void *ptr)
+{
+	const struct p4tc_label_key *label_arg = arg->key;
+	const struct p4tc_label_node *node = ptr;
+
+	return strncmp(label_arg->label, node->key.label, node->key.labelsz);
+}
+
+static u32 label_obj_hash_fn(const void *data, u32 len, u32 seed)
+{
+	const struct p4tc_label_node *node = data;
+
+	return label_hash_fn(&node->key, 0, seed);
+}
+
+void p4tc_label_ht_destroy(void *ptr, void *arg)
+{
+	struct p4tc_label_node *node = ptr;
+
+	kfree(node->key.label);
+	kfree(node);
+}
+
+const struct rhashtable_params p4tc_label_ht_params = {
+	.obj_cmpfn = label_hash_cmp,
+	.obj_hashfn = label_obj_hash_fn,
+	.hashfn = label_hash_fn,
+	.head_offset = offsetof(struct p4tc_label_node, ht_node),
+	.key_offset = offsetof(struct p4tc_label_node, key),
+	.automatic_shrinking = true,
+};
+
+static void set_param_indices(struct p4tc_act *act)
+{
+	struct p4tc_act_param *param;
+	unsigned long tmp, id;
+	int i = 0;
+
+	idr_for_each_entry_ul(&act->params_idr, param, tmp, id) {
+		param->index = i;
+		i++;
+	}
+}
+
+static int __tcf_p4_dyna_init(struct net *net, struct nlattr *est,
+			      struct p4tc_act *act, struct tc_act_dyna *parm,
+			      struct tc_action **a, struct tcf_proto *tp,
+			      struct tc_action_ops *a_o,
+			      struct tcf_chain **goto_ch, u32 flags,
+			      struct netlink_ext_ack *extack)
+{
+	bool bind = flags & TCA_ACT_FLAGS_BIND;
+	bool exists = false;
+	int ret = 0;
+	struct p4tc_pipeline *pipeline;
+	u32 index;
+	int err;
+
+	index = parm->index;
+
+	err = tcf_idr_check_alloc(act->tn, &index, a, bind);
+	if (err < 0)
+		return err;
+
+	exists = err;
+	if (!exists) {
+		struct tcf_p4act *p;
+
+		ret = tcf_idr_create(act->tn, index, est, a, a_o, bind, true,
+				     flags);
+		if (ret) {
+			tcf_idr_cleanup(act->tn, index);
+			return ret;
+		}
+
+		/* dyn_ref here should never be 0, because if we are here, it
+		 * means that a template action of this kind was created. Thus
+		 * dyn_ref should be at least 1. Also since this operation and
+		 * others that add or delete action templates run with
+		 * rtnl_lock held, we cannot do this op and a deletion op in
+		 * parallel.
+		 */
+		WARN_ON(!refcount_inc_not_zero(&a_o->dyn_ref));
+
+		pipeline = act->pipeline;
+
+		p = to_p4act(*a);
+		p->p_id = pipeline->common.p_id;
+		p->act_id = act->a_id;
+		INIT_LIST_HEAD(&p->cmd_operations);
+
+		ret = ACT_P_CREATED;
+	} else {
+		if (bind) /* dont override defaults */
+			return 0;
+		if (!(flags & TCA_ACT_FLAGS_REPLACE)) {
+			tcf_idr_cleanup(act->tn, index);
+			return -EEXIST;
+		}
+	}
+
+	err = tcf_action_check_ctrlact(parm->action, tp, goto_ch, extack);
+	if (err < 0) {
+		tcf_idr_release(*a, bind);
+		return err;
+	}
+
+	return ret;
+}
+
+static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
+				  struct tcf_p4act_params *params,
+				  struct tcf_chain *goto_ch,
+				  struct tc_act_dyna *parm, bool exists,
+				  struct netlink_ext_ack *extack)
+{
+	struct tcf_p4act_params *params_old;
+	struct tcf_p4act *p;
+	int err = 0;
+
+	p = to_p4act(*a);
+
+	if (exists)
+		spin_lock_bh(&p->tcf_lock);
+
+	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
+
+	params_old = rcu_replace_pointer(p->params, params, 1);
+	if (exists)
+		spin_unlock_bh(&p->tcf_lock);
+
+	if (goto_ch)
+		tcf_chain_put_by_act(goto_ch);
+
+	if (params_old)
+		call_rcu(&params_old->rcu, tcf_p4_act_params_destroy_rcu);
+
+	return err;
+}
+
+static struct p4tc_act *tcf_p4_find_act(struct net *net,
+					const struct tc_action_ops *a_o)
+{
+	char *act_name_clone, *act_name, *p_name;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_act *act;
+	int err;
+
+	act_name_clone = act_name = kstrdup(a_o->kind, GFP_KERNEL);
+	if (!act_name)
+		return ERR_PTR(-ENOMEM);
+
+	p_name = strsep(&act_name, SEPARATOR);
+	pipeline = tcf_pipeline_find_byany(net, p_name, 0, NULL);
+	if (IS_ERR(pipeline)) {
+		err = -ENOENT;
+		goto free_act_name;
+	}
+
+	act = tcf_action_find_byname(act_name, pipeline);
+	if (!act) {
+		err = -ENOENT;
+		goto free_act_name;
+	}
+	kfree(act_name_clone);
+
+	return act;
+
+free_act_name:
+	kfree(act_name_clone);
+	return ERR_PTR(err);
+}
+
+static int tcf_p4_dyna_init(struct net *net, struct nlattr *nla,
+			    struct nlattr *est, struct tc_action **a,
+			    struct tcf_proto *tp, struct tc_action_ops *a_o,
+			    u32 flags, struct netlink_ext_ack *extack)
+{
+	bool bind = flags & TCA_ACT_FLAGS_BIND;
+	struct tcf_chain *goto_ch = NULL;
+	bool exists = false;
+	int ret = 0;
+	struct nlattr *tb[P4TC_ACT_MAX + 1];
+	struct tcf_p4act_params *params;
+	struct tc_act_dyna *parm;
+	struct p4tc_act *act;
+	int err;
+
+	if (flags & TCA_ACT_FLAGS_BIND &&
+	    !(flags & TCA_ACT_FLAGS_FROM_P4TC)) {
+		NL_SET_ERR_MSG(extack,
+			       "Can only bind to dynamic action from P4TC objects");
+		return -EPERM;
+	}
+
+	if (!nla) {
+		NL_SET_ERR_MSG(extack,
+			       "Must specify action netlink attributes");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb, P4TC_ACT_MAX, nla, NULL, extack);
+	if (err < 0)
+		return err;
+
+	if (!tb[P4TC_ACT_OPT]) {
+		NL_SET_ERR_MSG(extack,
+			       "Must specify option netlink attributes");
+		return -EINVAL;
+	}
+
+	act = tcf_p4_find_act(net, a_o);
+	if (IS_ERR(act))
+		return PTR_ERR(act);
+
+	if (!act->active) {
+		NL_SET_ERR_MSG(extack,
+			       "Dynamic action must be active to create instance");
+		return -EINVAL;
+	}
+
+	parm = nla_data(tb[P4TC_ACT_OPT]);
+
+	ret = __tcf_p4_dyna_init(net, est, act, parm, a, tp, a_o, &goto_ch,
+				 flags, extack);
+	if (ret < 0)
+		return ret;
+	if (bind && !ret)
+		return 0;
+
+	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		err = -ENOMEM;
+		goto release_idr;
+	}
+
+	idr_init(&params->params_idr);
+	if (tb[P4TC_ACT_PARMS]) {
+		err = tcf_p4_act_init_params(net, params, act,
+					     tb[P4TC_ACT_PARMS], extack);
+		if (err < 0)
+			goto release_params;
+	} else {
+		if (!idr_is_empty(&act->params_idr)) {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify action parameters");
+			err = -EINVAL;
+			goto release_params;
+		}
+	}
+
+	exists = ret != ACT_P_CREATED;
+	err = __tcf_p4_dyna_init_set(act, a, params, goto_ch, parm, exists,
+				     extack);
+	if (err < 0)
+		goto release_params;
+
+	return ret;
+
+release_params:
+	tcf_p4_act_params_destroy(params);
+
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static const struct nla_policy p4tc_act_params_value_policy[P4TC_ACT_VALUE_PARAMS_MAX + 1] = {
+	[P4TC_ACT_PARAMS_VALUE_RAW] = { .type = NLA_BINARY },
+	[P4TC_ACT_PARAMS_VALUE_OPND] = { .type = NLA_NESTED },
+};
+
+static int dev_init_param_value(struct net *net, struct p4tc_act_param_ops *op,
+				struct p4tc_act_param *nparam,
+				struct nlattr **tb,
+				struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb_value[P4TC_ACT_VALUE_PARAMS_MAX + 1];
+	u32 value_len;
+	u32 *ifindex;
+	int err;
+
+	if (!tb[P4TC_ACT_PARAMS_VALUE]) {
+		NL_SET_ERR_MSG(extack, "Must specify param value");
+		return -EINVAL;
+	}
+	err = nla_parse_nested(tb_value, P4TC_ACT_VALUE_PARAMS_MAX,
+			       tb[P4TC_ACT_PARAMS_VALUE],
+			       p4tc_act_params_value_policy, extack);
+	if (err < 0)
+		return err;
+
+	value_len = nla_len(tb_value[P4TC_ACT_PARAMS_VALUE_RAW]);
+	if (value_len != sizeof(u32)) {
+		NL_SET_ERR_MSG(extack, "Value length differs from template's");
+		return -EINVAL;
+	}
+
+	ifindex = nla_data(tb_value[P4TC_ACT_PARAMS_VALUE_RAW]);
+	rcu_read_lock();
+	if (!dev_get_by_index_rcu(net, *ifindex)) {
+		NL_SET_ERR_MSG(extack, "Invalid ifindex");
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
+	nparam->value = kzalloc(sizeof(*ifindex), GFP_KERNEL);
+	if (!nparam->value)
+		return -EINVAL;
+
+	memcpy(nparam->value, ifindex, sizeof(*ifindex));
+
+	return 0;
+}
+
+static int dev_dump_param_value(struct sk_buff *skb,
+				struct p4tc_act_param_ops *op,
+				struct p4tc_act_param *param)
+{
+	struct nlattr *nest;
+	int ret;
+
+	nest = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
+	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
+		struct nlattr *nla_opnd;
+
+		nla_opnd = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE_OPND);
+		nla_nest_end(skb, nla_opnd);
+	} else {
+		const u32 *ifindex = param->value;
+
+		if (nla_put_u32(skb, P4TC_ACT_PARAMS_VALUE_RAW, *ifindex)) {
+			ret = -EINVAL;
+			goto out_nla_cancel;
+		}
+	}
+	nla_nest_end(skb, nest);
+
+	return 0;
+
+out_nla_cancel:
+	nla_nest_cancel(skb, nest);
+	return ret;
+}
+
+static void dev_free_param_value(struct p4tc_act_param *param)
+{
+	if (!(param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN))
+		kfree(param->value);
+}
+
+static int generic_init_param_value(struct p4tc_act_param *nparam,
+				    struct p4tc_type *type, struct nlattr **tb,
+				    struct netlink_ext_ack *extack)
+{
+	const u32 alloc_len = BITS_TO_BYTES(type->container_bitsz);
+	const u32 len = BITS_TO_BYTES(type->bitsz);
+	struct nlattr *tb_value[P4TC_ACT_VALUE_PARAMS_MAX + 1];
+	void *value;
+	int err;
+
+	if (!tb[P4TC_ACT_PARAMS_VALUE]) {
+		NL_SET_ERR_MSG(extack, "Must specify param value");
+		return -EINVAL;
+	}
+
+	err = nla_parse_nested(tb_value, P4TC_ACT_VALUE_PARAMS_MAX,
+			       tb[P4TC_ACT_PARAMS_VALUE],
+			       p4tc_act_params_value_policy, extack);
+	if (err < 0)
+		return err;
+
+	value = nla_data(tb_value[P4TC_ACT_PARAMS_VALUE_RAW]);
+	if (type->ops->validate_p4t) {
+		err = type->ops->validate_p4t(type, value, 0, type->bitsz - 1,
+					      extack);
+		if (err < 0)
+			return err;
+	}
+
+	if (nla_len(tb_value[P4TC_ACT_PARAMS_VALUE_RAW]) != len)
+		return -EINVAL;
+
+	nparam->value = kzalloc(alloc_len, GFP_KERNEL);
+	if (!nparam->value)
+		return -ENOMEM;
+
+	memcpy(nparam->value, value, len);
+
+	if (tb[P4TC_ACT_PARAMS_MASK]) {
+		const void *mask = nla_data(tb[P4TC_ACT_PARAMS_MASK]);
+
+		if (nla_len(tb[P4TC_ACT_PARAMS_MASK]) != len) {
+			NL_SET_ERR_MSG(extack,
+				       "Mask length differs from template's");
+			err = -EINVAL;
+			goto free_value;
+		}
+
+		nparam->mask = kzalloc(alloc_len, GFP_KERNEL);
+		if (!nparam->mask) {
+			err = -ENOMEM;
+			goto free_value;
+		}
+
+		memcpy(nparam->mask, mask, len);
+	}
+
+	return 0;
+
+free_value:
+	kfree(nparam->value);
+	return err;
+}
+
+const struct p4tc_act_param_ops param_ops[P4T_MAX + 1] = {
+	[P4T_DEV] = {
+		.init_value = dev_init_param_value,
+		.dump_value = dev_dump_param_value,
+		.free = dev_free_param_value,
+	},
+};
+
+static void generic_free_param_value(struct p4tc_act_param *param)
+{
+	if (!(param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN)) {
+		kfree(param->value);
+		kfree(param->mask);
+	}
+}
+
+int tcf_p4_act_init_params_list(struct tcf_p4act_params *params,
+				struct list_head *params_list)
+{
+	struct p4tc_act_param *nparam, *tmp;
+	int err;
+
+	list_for_each_entry_safe(nparam, tmp, params_list, head) {
+		err = idr_alloc_u32(&params->params_idr, nparam, &nparam->id,
+				    nparam->id, GFP_KERNEL);
+		if (err < 0)
+			return err;
+		list_del(&nparam->head);
+		params->num_params++;
+	}
+
+	return 0;
+}
+
+/* This is the action instantiation that is invoked from the template code,
+ * specifically when there is a command act with runtime parameters.
+ * It is assumed that the action kind that is being instantiated here was
+ * already created. This functions is analogous to tcf_p4_dyna_init.
+ */
+int tcf_p4_dyna_template_init(struct net *net, struct tc_action **a,
+			      struct p4tc_act *act,
+			      struct list_head *params_list,
+			      struct tc_act_dyna *parm, u32 flags,
+			      struct netlink_ext_ack *extack)
+{
+	bool bind = flags & TCA_ACT_FLAGS_BIND;
+	struct tc_action_ops *a_o = &act->ops;
+	struct tcf_chain *goto_ch = NULL;
+	bool exists = false;
+	struct tcf_p4act_params *params;
+	int ret;
+	int err;
+
+	if (!act->active) {
+		NL_SET_ERR_MSG(extack,
+			       "Dynamic action must be active to create instance");
+		return -EINVAL;
+	}
+
+	ret = __tcf_p4_dyna_init(net, NULL, act, parm, a, NULL, a_o, &goto_ch,
+				 flags, extack);
+	if (ret < 0)
+		return ret;
+
+	err = tcf_action_check_ctrlact(parm->action, NULL, &goto_ch, extack);
+	if (err < 0)
+		goto release_idr;
+
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
+	if (!params) {
+		err = -ENOMEM;
+		goto release_idr;
+	}
+
+	idr_init(&params->params_idr);
+	if (params_list) {
+		err = tcf_p4_act_init_params_list(params, params_list);
+		if (err < 0)
+			goto release_params;
+	} else {
+		if (!idr_is_empty(&act->params_idr)) {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify action parameters");
+			err = -EINVAL;
+			goto release_params;
+		}
+	}
+
+	exists = ret != ACT_P_CREATED;
+	err = __tcf_p4_dyna_init_set(act, a, params, goto_ch, parm, exists,
+				     extack);
+	if (err < 0)
+		goto release_params;
+
+	return err;
+
+release_params:
+	tcf_p4_act_params_destroy(params);
+
+release_idr:
+	tcf_idr_release(*a, bind);
+	return err;
+}
+
+static int tcf_p4_dyna_act(struct sk_buff *skb, const struct tc_action *a,
+			   struct tcf_result *res)
+{
+	struct tcf_p4act *dynact = to_p4act(a);
+	int ret = 0;
+
+	tcf_lastuse_update(&dynact->tcf_tm);
+	tcf_action_update_bstats(&dynact->common, skb);
+
+	return ret;
+}
+
+static int tcf_p4_dyna_dump(struct sk_buff *skb, struct tc_action *a, int bind,
+			    int ref)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct tcf_p4act *dynact = to_p4act(a);
+	struct tc_act_dyna opt = {
+		.index = dynact->tcf_index,
+		.refcnt = refcount_read(&dynact->tcf_refcnt) - ref,
+		.bindcnt = atomic_read(&dynact->tcf_bindcnt) - bind,
+	};
+	int i = 1;
+	struct tcf_p4act_params *params;
+	struct p4tc_act_param *parm;
+	struct nlattr *nest_parms;
+	struct nlattr *nest;
+	struct tcf_t t;
+	int id;
+
+	spin_lock_bh(&dynact->tcf_lock);
+
+	opt.action = dynact->tcf_action;
+	if (nla_put(skb, P4TC_ACT_OPT, sizeof(opt), &opt))
+		goto nla_put_failure;
+
+	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	nla_nest_end(skb, nest);
+
+	if (nla_put_string(skb, P4TC_ACT_NAME, a->ops->kind))
+		goto nla_put_failure;
+
+	tcf_tm_dump(&t, &dynact->tcf_tm);
+	if (nla_put_64bit(skb, P4TC_ACT_TM, sizeof(t), &t, P4TC_ACT_PAD))
+		goto nla_put_failure;
+
+	nest_parms = nla_nest_start(skb, P4TC_ACT_PARMS);
+	if (!nest_parms)
+		goto nla_put_failure;
+
+	params = rcu_dereference_protected(dynact->params, 1);
+	if (params) {
+		idr_for_each_entry(&params->params_idr, parm, id) {
+			struct p4tc_act_param_ops *op;
+			struct nlattr *nest_count;
+
+			nest_count = nla_nest_start(skb, i);
+			if (!nest_count)
+				goto nla_put_failure;
+
+			if (nla_put_string(skb, P4TC_ACT_PARAMS_NAME,
+					   parm->name))
+				goto nla_put_failure;
+
+			if (nla_put_u32(skb, P4TC_ACT_PARAMS_ID, parm->id))
+				goto nla_put_failure;
+
+			op = (struct p4tc_act_param_ops *)&param_ops[parm->type->typeid];
+			if (op->dump_value) {
+				if (op->dump_value(skb, op, parm) < 0)
+					goto nla_put_failure;
+			} else {
+				if (generic_dump_param_value(skb, parm->type, parm))
+					goto nla_put_failure;
+			}
+
+			if (nla_put_u32(skb, P4TC_ACT_PARAMS_TYPE, parm->type->typeid))
+				goto nla_put_failure;
+
+			nla_nest_end(skb, nest_count);
+			i++;
+		}
+	}
+	nla_nest_end(skb, nest_parms);
+
+	spin_unlock_bh(&dynact->tcf_lock);
+
+	return skb->len;
+
+nla_put_failure:
+	spin_unlock_bh(&dynact->tcf_lock);
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_p4_dyna_lookup(struct net *net, const struct tc_action_ops *ops,
+			      struct tc_action **a, u32 index)
+{
+	struct p4tc_act *act;
+
+	act = tcf_p4_find_act(net, ops);
+	if (IS_ERR(act))
+		return PTR_ERR(act);
+
+	return tcf_idr_search(act->tn, a, index);
+}
+
+static int tcf_p4_dyna_walker(struct net *net, struct sk_buff *skb,
+			      struct netlink_callback *cb, int type,
+			      const struct tc_action_ops *ops,
+			      struct netlink_ext_ack *extack)
+{
+	struct p4tc_act *act;
+
+	act = tcf_p4_find_act(net, ops);
+	if (IS_ERR(act))
+		return PTR_ERR(act);
+
+	return tcf_generic_walker(act->tn, skb, cb, type, ops, extack);
+}
+
+static void tcf_p4_dyna_cleanup(struct tc_action *a)
+{
+	struct tc_action_ops *ops = (struct tc_action_ops *)a->ops;
+	struct tcf_p4act *m = to_p4act(a);
+	struct tcf_p4act_params *params;
+
+	params = rcu_dereference_protected(m->params, 1);
+
+	if (refcount_read(&ops->dyn_ref) > 1)
+		refcount_dec(&ops->dyn_ref);
+
+	if (params)
+		call_rcu(&params->rcu, tcf_p4_act_params_destroy_rcu);
+}
+
+int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
+			     struct p4tc_act_param *param)
+{
+	const u32 bytesz = BITS_TO_BYTES(type->container_bitsz);
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct nlattr *nla_value;
+
+	nla_value = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
+	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
+		struct nlattr *nla_opnd;
+
+		nla_opnd = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE_OPND);
+		nla_nest_end(skb, nla_opnd);
+	} else {
+		if (nla_put(skb, P4TC_ACT_PARAMS_VALUE_RAW, bytesz,
+			    param->value))
+			goto out_nlmsg_trim;
+	}
+	nla_nest_end(skb, nla_value);
+
+	if (param->mask &&
+	    nla_put(skb, P4TC_ACT_PARAMS_MASK, bytesz, param->mask))
+		goto out_nlmsg_trim;
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+void tcf_p4_act_params_destroy(struct tcf_p4act_params *params)
+{
+	struct p4tc_act_param *param;
+	unsigned long param_id, tmp;
+
+	idr_for_each_entry_ul(&params->params_idr, param, tmp, param_id) {
+		struct p4tc_act_param_ops *op;
+
+		idr_remove(&params->params_idr, param_id);
+		op = (struct p4tc_act_param_ops *)&param_ops[param->type->typeid];
+		if (op->free)
+			op->free(param);
+		else
+			generic_free_param_value(param);
+		kfree(param);
+	}
+
+	kfree(params->params_array);
+	idr_destroy(&params->params_idr);
+
+	kfree(params);
+}
+
+void tcf_p4_act_params_destroy_rcu(struct rcu_head *head)
+{
+	struct tcf_p4act_params *params;
+
+	params = container_of(head, struct tcf_p4act_params, rcu);
+	tcf_p4_act_params_destroy(params);
+}
+
+static const struct nla_policy p4tc_act_params_policy[P4TC_ACT_PARAMS_MAX + 1] = {
+	[P4TC_ACT_PARAMS_NAME] = { .type = NLA_STRING, .len = ACTPARAMNAMSIZ },
+	[P4TC_ACT_PARAMS_ID] = { .type = NLA_U32 },
+	[P4TC_ACT_PARAMS_VALUE] = { .type = NLA_NESTED },
+	[P4TC_ACT_PARAMS_MASK] = { .type = NLA_BINARY },
+	[P4TC_ACT_PARAMS_TYPE] = { .type = NLA_U32 },
+};
+
+static struct p4tc_act_param *param_find_byname(struct idr *params_idr,
+						const char *param_name)
+{
+	struct p4tc_act_param *param;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(params_idr, param, tmp, id) {
+		if (param == ERR_PTR(-EBUSY))
+			continue;
+		if (strncmp(param->name, param_name, ACTPARAMNAMSIZ) == 0)
+			return param;
+	}
+
+	return NULL;
+}
+
+struct p4tc_act_param *tcf_param_find_byid(struct idr *params_idr,
+					   const u32 param_id)
+{
+	return idr_find(params_idr, param_id);
+}
+
+struct p4tc_act_param *tcf_param_find_byany(struct p4tc_act *act,
+					    const char *param_name,
+					    const u32 param_id,
+					    struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *param;
+	int err;
+
+	if (param_id) {
+		param = tcf_param_find_byid(&act->params_idr, param_id);
+		if (!param) {
+			NL_SET_ERR_MSG(extack, "Unable to find param by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (param_name) {
+			param = param_find_byname(&act->params_idr, param_name);
+			if (!param) {
+				NL_SET_ERR_MSG(extack, "Param name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack, "Must specify param name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return param;
+
+out:
+	return ERR_PTR(err);
+}
+
+static struct p4tc_act_param *
+tcf_param_find_byanyattr(struct p4tc_act *act, struct nlattr *name_attr,
+			 const u32 param_id, struct netlink_ext_ack *extack)
+{
+	char *param_name = NULL;
+
+	if (name_attr)
+		param_name = nla_data(name_attr);
+
+	return tcf_param_find_byany(act, param_name, param_id, extack);
+}
+
+static int tcf_p4_act_init_param(struct net *net,
+				 struct tcf_p4act_params *params,
+				 struct p4tc_act *act, struct nlattr *nla,
+				 struct netlink_ext_ack *extack)
+{
+	u32 param_id = 0;
+	struct nlattr *tb[P4TC_ACT_PARAMS_MAX + 1];
+	struct p4tc_act_param *param, *nparam;
+	struct p4tc_act_param_ops *op;
+	int err;
+
+	err = nla_parse_nested(tb, P4TC_ACT_PARAMS_MAX, nla,
+			       p4tc_act_params_policy, extack);
+	if (err < 0)
+		return err;
+
+	if (tb[P4TC_ACT_PARAMS_ID])
+		param_id = nla_get_u32(tb[P4TC_ACT_PARAMS_ID]);
+
+	param = tcf_param_find_byanyattr(act, tb[P4TC_ACT_PARAMS_NAME],
+					 param_id, extack);
+	if (IS_ERR(param))
+		return PTR_ERR(param);
+
+	if (tb[P4TC_ACT_PARAMS_TYPE]) {
+		u32 typeid = nla_get_u32(tb[P4TC_ACT_PARAMS_TYPE]);
+
+		if (param->type->typeid != typeid) {
+			NL_SET_ERR_MSG(extack,
+				       "Param type differs from template");
+			return -EINVAL;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify param type");
+		return -EINVAL;
+	}
+
+	nparam = kzalloc(sizeof(*nparam), GFP_KERNEL);
+	if (!nparam)
+		return -ENOMEM;
+
+	strscpy(nparam->name, param->name, ACTPARAMNAMSIZ);
+	nparam->type = param->type;
+
+	op = (struct p4tc_act_param_ops *)&param_ops[param->type->typeid];
+	if (op->init_value)
+		err = op->init_value(net, op, nparam, tb, extack);
+	else
+		err = generic_init_param_value(nparam, nparam->type, tb, extack);
+
+	if (err < 0)
+		goto free;
+
+	nparam->id = param->id;
+	nparam->index = param->index;
+
+	err = idr_alloc_u32(&params->params_idr, nparam, &nparam->id,
+			    nparam->id, GFP_KERNEL);
+	if (err < 0)
+		goto free_val;
+
+	params->params_array[param->index] = nparam;
+
+	return 0;
+
+free_val:
+	if (op->free)
+		op->free(nparam);
+	else
+		generic_free_param_value(nparam);
+
+free:
+	kfree(nparam);
+	return err;
+}
+
+int tcf_p4_act_init_params(struct net *net, struct tcf_p4act_params *params,
+			   struct p4tc_act *act, struct nlattr *nla,
+			   struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_MSGBATCH_SIZE + 1];
+	int err;
+	int i;
+
+	err = nla_parse_nested(tb, P4TC_MSGBATCH_SIZE, nla, NULL, NULL);
+	if (err < 0)
+		return err;
+
+	params->params_array = kcalloc(act->num_params,
+				       sizeof(struct p4tc_act_param *),
+				       GFP_KERNEL);
+	if (!params->params_array)
+		return -ENOMEM;
+
+	for (i = 1; i < P4TC_MSGBATCH_SIZE + 1 && tb[i]; i++) {
+		err = tcf_p4_act_init_param(net, params, act, tb[i], extack);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
+struct p4tc_act *tcf_action_find_byname(const char *act_name,
+					struct p4tc_pipeline *pipeline)
+{
+	char full_act_name[ACTPARAMNAMSIZ];
+	struct p4tc_act *act;
+	unsigned long tmp, id;
+
+	snprintf(full_act_name, ACTNAMSIZ, "%s/%s", pipeline->common.name,
+		 act_name);
+	idr_for_each_entry_ul(&pipeline->p_act_idr, act, tmp, id)
+		if (strncmp(act->common.name, full_act_name, ACTNAMSIZ) == 0)
+			return act;
+
+	return NULL;
+}
+
+struct p4tc_act *tcf_action_find_byid(struct p4tc_pipeline *pipeline,
+				      const u32 a_id)
+{
+	return idr_find(&pipeline->p_act_idr, a_id);
+}
+
+struct p4tc_act *tcf_action_find_byany(struct p4tc_pipeline *pipeline,
+				       const char *act_name, const u32 a_id,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_act *act;
+	int err;
+
+	if (a_id) {
+		act = tcf_action_find_byid(pipeline, a_id);
+		if (!act) {
+			NL_SET_ERR_MSG(extack, "Unable to find action by id");
+			err = -ENOENT;
+			goto out;
+		}
+	} else {
+		if (act_name) {
+			act = tcf_action_find_byname(act_name, pipeline);
+			if (!act) {
+				NL_SET_ERR_MSG(extack, "Action name not found");
+				err = -ENOENT;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify action name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return act;
+
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_act *tcf_action_get(struct p4tc_pipeline *pipeline,
+				const char *act_name, const u32 a_id,
+				struct netlink_ext_ack *extack)
+{
+	struct p4tc_act *act;
+
+	act = tcf_action_find_byany(pipeline, act_name, a_id, extack);
+	if (IS_ERR(act))
+		return act;
+
+	WARN_ON(!refcount_inc_not_zero(&act->a_ref));
+	return act;
+}
+
+void tcf_action_put(struct p4tc_act *act)
+{
+	WARN_ON(!refcount_dec_not_one(&act->a_ref));
+}
+
+static struct p4tc_act *
+tcf_action_find_byanyattr(struct nlattr *act_name_attr, const u32 a_id,
+			  struct p4tc_pipeline *pipeline,
+			  struct netlink_ext_ack *extack)
+{
+	char *act_name = NULL;
+
+	if (act_name_attr)
+		act_name = nla_data(act_name_attr);
+
+	return tcf_action_find_byany(pipeline, act_name, a_id, extack);
+}
+
+static void p4_put_param(struct idr *params_idr, struct p4tc_act_param *param)
+{
+	kfree(param);
+}
+
+void p4_put_many_params(struct idr *params_idr, struct p4tc_act_param *params[],
+			int params_count)
+{
+	int i;
+
+	for (i = 0; i < params_count; i++)
+		p4_put_param(params_idr, params[i]);
+}
+
+static struct p4tc_act_param *p4_create_param(struct p4tc_act *act,
+					      struct nlattr **tb, u32 param_id,
+					      struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *param;
+	char *name;
+	int ret;
+
+	if (tb[P4TC_ACT_PARAMS_NAME]) {
+		name = nla_data(tb[P4TC_ACT_PARAMS_NAME]);
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify param name");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	param = kmalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (tcf_param_find_byid(&act->params_idr, param_id) ||
+	    param_find_byname(&act->params_idr, name)) {
+		NL_SET_ERR_MSG(extack, "Param already exists");
+		ret = -EEXIST;
+		goto free;
+	}
+
+	if (tb[P4TC_ACT_PARAMS_TYPE]) {
+		u32 typeid;
+
+		typeid = nla_get_u32(tb[P4TC_ACT_PARAMS_TYPE]);
+		param->type = p4type_find_byid(typeid);
+		if (!param->type) {
+			NL_SET_ERR_MSG(extack, "Param type is invalid");
+			ret = -EINVAL;
+			goto free;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify param type");
+		ret = -EINVAL;
+		goto free;
+	}
+
+	if (param_id) {
+		ret = idr_alloc_u32(&act->params_idr, param, &param_id,
+				    param_id, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to allocate param id");
+			goto free;
+		}
+		param->id = param_id;
+	} else {
+		param->id = 1;
+
+		ret = idr_alloc_u32(&act->params_idr, param, &param->id,
+				    UINT_MAX, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to allocate param id");
+			goto free;
+		}
+	}
+
+	strscpy(param->name, name, ACTPARAMNAMSIZ);
+
+	return param;
+
+free:
+	kfree(param);
+
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_act_param *p4_update_param(struct p4tc_act *act,
+					      struct nlattr **tb,
+					      const u32 param_id,
+					      struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *param_old, *param;
+	int ret;
+
+	param_old = tcf_param_find_byanyattr(act, tb[P4TC_ACT_PARAMS_NAME],
+					     param_id, extack);
+	if (IS_ERR(param_old))
+		return param_old;
+
+	param = kmalloc(sizeof(*param), GFP_KERNEL);
+	if (!param) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	strscpy(param->name, param_old->name, ACTPARAMNAMSIZ);
+	param->id = param_old->id;
+
+	if (tb[P4TC_ACT_PARAMS_TYPE]) {
+		u32 typeid;
+
+		typeid = nla_get_u32(tb[P4TC_ACT_PARAMS_TYPE]);
+		param->type = p4type_find_byid(typeid);
+		if (!param->type) {
+			NL_SET_ERR_MSG(extack, "Param type is invalid");
+			ret = -EINVAL;
+			goto free;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify param type");
+		ret = -EINVAL;
+		goto free;
+	}
+
+	return param;
+
+free:
+	kfree(param);
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_act_param *p4_act_init_param(struct p4tc_act *act,
+						struct nlattr *nla, bool update,
+						struct netlink_ext_ack *extack)
+{
+	u32 param_id = 0;
+	struct nlattr *tb[P4TC_ACT_PARAMS_MAX + 1];
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_ACT_PARAMS_MAX, nla, NULL, extack);
+	if (ret < 0) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (tb[P4TC_ACT_PARAMS_ID])
+		param_id = nla_get_u32(tb[P4TC_ACT_PARAMS_ID]);
+
+	if (update)
+		return p4_update_param(act, tb, param_id, extack);
+	else
+		return p4_create_param(act, tb, param_id, extack);
+
+out:
+	return ERR_PTR(ret);
+}
+
+int p4_act_init_params(struct p4tc_act *act, struct nlattr *nla,
+		       struct p4tc_act_param *params[], bool update,
+		       struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_MSGBATCH_SIZE + 1];
+	int ret;
+	int i;
+
+	ret = nla_parse_nested(tb, P4TC_MSGBATCH_SIZE, nla, NULL, extack);
+	if (ret < 0)
+		return -EINVAL;
+
+	for (i = 1; i < P4TC_MSGBATCH_SIZE + 1 && tb[i]; i++) {
+		struct p4tc_act_param *param;
+
+		param = p4_act_init_param(act, tb[i], update, extack);
+		if (IS_ERR(param)) {
+			ret = PTR_ERR(param);
+			goto params_del;
+		}
+		params[i - 1] = param;
+	}
+
+	return i - 1;
+
+params_del:
+	p4_put_many_params(&act->params_idr, params, i - 1);
+	return ret;
+}
+
+int p4_act_init(struct p4tc_act *act, struct nlattr *nla,
+		struct p4tc_act_param *params[], struct netlink_ext_ack *extack)
+{
+	int num_params = 0;
+	int ret;
+
+	idr_init(&act->params_idr);
+
+	if (nla) {
+		num_params =
+			p4_act_init_params(act, nla, params, false, extack);
+		if (num_params < 0) {
+			ret = num_params;
+			goto idr_destroy;
+		}
+	}
+
+	return num_params;
+
+idr_destroy:
+	p4_put_many_params(&act->params_idr, params, num_params);
+	idr_destroy(&act->params_idr);
+	return ret;
+}
+
+static const struct nla_policy p4tc_act_policy[P4TC_ACT_MAX + 1] = {
+	[P4TC_ACT_NAME] = { .type = NLA_STRING, .len = ACTNAMSIZ },
+	[P4TC_ACT_PARMS] = { .type = NLA_NESTED },
+	[P4TC_ACT_OPT] = { .type = NLA_BINARY,
+			   .len = sizeof(struct tc_act_dyna) },
+	[P4TC_ACT_CMDS_LIST] = { .type = NLA_NESTED },
+	[P4TC_ACT_ACTIVE] = { .type = NLA_U8 },
+};
+
+static inline void p4tc_action_net_exit(struct tc_action_net *tn)
+{
+	tcf_idrinfo_destroy(tn->ops, tn->idrinfo);
+	kfree(tn->idrinfo);
+	kfree(tn);
+}
+
+static int __tcf_act_put(struct net *net, struct p4tc_pipeline *pipeline,
+			 struct p4tc_act *act, bool unconditional_purge,
+			 struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *act_param;
+	unsigned long param_id, tmp;
+	struct tc_action_net *tn;
+	struct idr *idr;
+	int ret;
+
+	if (!unconditional_purge && (refcount_read(&act->ops.dyn_ref) > 1 ||
+				     refcount_read(&act->a_ref) > 1)) {
+		NL_SET_ERR_MSG(extack,
+			       "Unable to delete referenced action template");
+		return -EBUSY;
+	}
+
+	tn = net_generic(net, act->ops.net_id);
+	idr = &tn->idrinfo->action_idr;
+
+	idr_for_each_entry_ul(&act->params_idr, act_param, tmp, param_id) {
+		idr_remove(&act->params_idr, param_id);
+		kfree(act_param);
+	}
+
+	ret = tcf_unregister_dyn_action(net, &act->ops);
+	if (ret < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Unable to unregister new action template");
+		return ret;
+	}
+	p4tc_action_net_exit(act->tn);
+
+	if (act->labels) {
+		rhashtable_free_and_destroy(act->labels, p4tc_label_ht_destroy,
+					    NULL);
+		kfree(act->labels);
+	}
+
+	idr_remove(&pipeline->p_act_idr, act->a_id);
+
+	if (!unconditional_purge)
+		tcf_pipeline_delete_from_dep_graph(pipeline, act);
+
+	list_del(&act->head);
+
+	kfree(act);
+
+	pipeline->num_created_acts--;
+
+	return 0;
+}
+
+static int _tcf_act_fill_nlmsg(struct net *net, struct sk_buff *skb,
+			       struct p4tc_act *act)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	int i = 1;
+	struct nlattr *nest, *parms, *cmds;
+	struct p4tc_act_param *param;
+	unsigned long param_id, tmp;
+
+	if (nla_put_u32(skb, P4TC_PATH, act->a_id))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+
+	if (nla_put_string(skb, P4TC_ACT_NAME, act->common.name))
+		goto out_nlmsg_trim;
+
+	parms = nla_nest_start(skb, P4TC_ACT_PARMS);
+	if (!parms)
+		goto out_nlmsg_trim;
+
+	idr_for_each_entry_ul(&act->params_idr, param, tmp, param_id) {
+		struct nlattr *nest_count;
+
+		nest_count = nla_nest_start(skb, i);
+		if (!nest_count)
+			goto out_nlmsg_trim;
+
+		if (nla_put_string(skb, P4TC_ACT_PARAMS_NAME, param->name))
+			goto out_nlmsg_trim;
+
+		if (nla_put_u32(skb, P4TC_ACT_PARAMS_ID, param->id))
+			goto out_nlmsg_trim;
+
+		if (nla_put_u32(skb, P4TC_ACT_PARAMS_TYPE, param->type->typeid))
+			goto out_nlmsg_trim;
+
+		nla_nest_end(skb, nest_count);
+		i++;
+	}
+	nla_nest_end(skb, parms);
+
+	cmds = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	nla_nest_end(skb, cmds);
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
+static int tcf_act_fill_nlmsg(struct net *net, struct sk_buff *skb,
+			      struct p4tc_template_common *tmpl,
+			      struct netlink_ext_ack *extack)
+{
+	return _tcf_act_fill_nlmsg(net, skb, to_act(tmpl));
+}
+
+static int tcf_act_flush(struct sk_buff *skb, struct net *net,
+			 struct p4tc_pipeline *pipeline,
+			 struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_act *act;
+	unsigned long tmp, act_id;
+	int ret = 0;
+	int i = 0;
+
+	if (nla_put_u32(skb, P4TC_PATH, 0))
+		goto out_nlmsg_trim;
+
+	if (idr_is_empty(&pipeline->p_act_idr)) {
+		NL_SET_ERR_MSG(extack,
+			       "There are not action templates to flush");
+		goto out_nlmsg_trim;
+	}
+
+	idr_for_each_entry_ul(&pipeline->p_act_idr, act, tmp, act_id) {
+		if (__tcf_act_put(net, pipeline, act, false, extack) < 0) {
+			ret = -EBUSY;
+			continue;
+		}
+		i++;
+	}
+
+	nla_put_u32(skb, P4TC_COUNT, i);
+
+	if (ret < 0) {
+		if (i == 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to flush any action template");
+			goto out_nlmsg_trim;
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to flush all action templates");
+		}
+	}
+
+	return i;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_act_gd(struct net *net, struct sk_buff *skb, struct nlmsghdr *n,
+		      struct nlattr *nla, struct p4tc_nl_pname *nl_pname,
+		      u32 *ids, struct netlink_ext_ack *extack)
+{
+	const u32 pipeid = ids[P4TC_PID_IDX], a_id = ids[P4TC_AID_IDX];
+	struct nlattr *tb[P4TC_ACT_MAX + 1] = { NULL };
+	unsigned char *b = nlmsg_get_pos(skb);
+	int ret = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_act *act;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE)
+		pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data,
+							    pipeid, extack);
+	else
+		pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid,
+						   extack);
+	if (IS_ERR(pipeline))
+		return PTR_ERR(pipeline);
+
+	if (nla) {
+		ret = nla_parse_nested(tb, P4TC_ACT_MAX, nla, p4tc_act_policy,
+				       extack);
+		if (ret < 0)
+			return ret;
+	}
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE && (n->nlmsg_flags & NLM_F_ROOT))
+		return tcf_act_flush(skb, net, pipeline, extack);
+
+	act = tcf_action_find_byanyattr(tb[P4TC_ACT_NAME], a_id, pipeline,
+					extack);
+	if (IS_ERR(act))
+		return PTR_ERR(act);
+
+	if (_tcf_act_fill_nlmsg(net, skb, act) < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for template action");
+		return -EINVAL;
+	}
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = __tcf_act_put(net, pipeline, act, false, extack);
+		if (ret < 0)
+			goto out_nlmsg_trim;
+	}
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_act_put(struct net *net, struct p4tc_template_common *tmpl,
+		       bool unconditional_purge, struct netlink_ext_ack *extack)
+{
+	struct p4tc_act *act = to_act(tmpl);
+	struct p4tc_pipeline *pipeline;
+
+	pipeline = tcf_pipeline_find_byid(net, tmpl->p_id);
+
+	return __tcf_act_put(net, pipeline, act, unconditional_purge, extack);
+}
+
+static void p4tc_params_replace_many(struct idr *params_idr,
+				     struct p4tc_act_param *params[],
+				     int params_count)
+{
+	int i;
+
+	for (i = 0; i < params_count; i++) {
+		struct p4tc_act_param *param = params[i];
+
+		param = idr_replace(params_idr, param, param->id);
+		kfree(param);
+	}
+}
+
+static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
+				       struct p4tc_pipeline *pipeline, u32 *ids,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *params[P4TC_MSGBATCH_SIZE] = { NULL };
+	u32 a_id = ids[P4TC_AID_IDX];
+	int num_params = 0;
+	int ret = 0;
+	struct p4tc_act_dep_node *dep_node;
+	struct p4tc_act *act;
+	char *act_name;
+
+	if (tb[P4TC_ACT_NAME]) {
+		act_name = nla_data(tb[P4TC_ACT_NAME]);
+	} else {
+		NL_SET_ERR_MSG(extack, "Must supply action name");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if ((tcf_action_find_byname(act_name, pipeline))) {
+		NL_SET_ERR_MSG(extack, "Action already exists with same name");
+		return ERR_PTR(-EEXIST);
+	}
+
+	if (tcf_action_find_byid(pipeline, a_id)) {
+		NL_SET_ERR_MSG(extack, "Action already exists with same id");
+		return ERR_PTR(-EEXIST);
+	}
+
+	act = kzalloc(sizeof(*act), GFP_KERNEL);
+	if (!act)
+		return ERR_PTR(-ENOMEM);
+
+	act->ops.owner = THIS_MODULE;
+	act->ops.act = tcf_p4_dyna_act;
+	act->ops.dump = tcf_p4_dyna_dump;
+	act->ops.cleanup = tcf_p4_dyna_cleanup;
+	act->ops.init_ops = tcf_p4_dyna_init;
+	act->ops.lookup = tcf_p4_dyna_lookup;
+	act->ops.walk = tcf_p4_dyna_walker;
+	act->ops.size = sizeof(struct tcf_p4act);
+	INIT_LIST_HEAD(&act->head);
+
+	act->tn = kzalloc(sizeof(*act->tn), GFP_KERNEL);
+	if (!act->tn) {
+		ret = -ENOMEM;
+		goto free_act_ops;
+	}
+
+	ret = tc_action_net_init(net, act->tn, &act->ops);
+	if (ret < 0) {
+		kfree(act->tn);
+		goto free_act_ops;
+	}
+	act->tn->ops = &act->ops;
+
+	snprintf(act->ops.kind, ACTNAMSIZ, "%s/%s", pipeline->common.name,
+		 act_name);
+
+	if (a_id) {
+		ret = idr_alloc_u32(&pipeline->p_act_idr, act, &a_id, a_id,
+				    GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to alloc action id");
+			goto free_action_net;
+		}
+
+		act->a_id = a_id;
+	} else {
+		act->a_id = 1;
+
+		ret = idr_alloc_u32(&pipeline->p_act_idr, act, &act->a_id,
+				    UINT_MAX, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to alloc action id");
+			goto free_action_net;
+		}
+	}
+
+	dep_node = kzalloc(sizeof(*dep_node), GFP_KERNEL);
+	if (!dep_node) {
+		ret = -ENOMEM;
+		goto idr_rm;
+	}
+	dep_node->act_id = act->a_id;
+	INIT_LIST_HEAD(&dep_node->incoming_egde_list);
+	list_add_tail(&dep_node->head, &pipeline->act_dep_graph);
+
+	refcount_set(&act->ops.dyn_ref, 1);
+	ret = tcf_register_dyn_action(net, &act->ops);
+	if (ret < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Unable to register new action template");
+		goto free_dep_node;
+	}
+
+	num_params = p4_act_init(act, tb[P4TC_ACT_PARMS], params, extack);
+	if (num_params < 0) {
+		ret = num_params;
+		goto unregister;
+	}
+	act->num_params = num_params;
+
+	set_param_indices(act);
+
+	INIT_LIST_HEAD(&act->cmd_operations);
+	act->pipeline = pipeline;
+
+	pipeline->num_created_acts++;
+
+	ret = determine_act_topological_order(pipeline, true);
+	if (ret < 0) {
+		pipeline->num_created_acts--;
+		goto uninit;
+	}
+
+	act->common.p_id = pipeline->common.p_id;
+	snprintf(act->common.name, ACTNAMSIZ, "%s/%s", pipeline->common.name,
+		 act_name);
+	act->common.ops = (struct p4tc_template_ops *)&p4tc_act_ops;
+
+	refcount_set(&act->a_ref, 1);
+
+	list_add_tail(&act->head, &dynact_list);
+
+	return act;
+
+uninit:
+	p4_put_many_params(&act->params_idr, params, num_params);
+	idr_destroy(&act->params_idr);
+
+unregister:
+	rtnl_unlock();
+	tcf_unregister_dyn_action(net, &act->ops);
+	rtnl_lock();
+
+free_dep_node:
+	list_del(&dep_node->head);
+	kfree(dep_node);
+
+idr_rm:
+	idr_remove(&pipeline->p_act_idr, act->a_id);
+
+free_action_net:
+	p4tc_action_net_exit(act->tn);
+
+free_act_ops:
+	kfree(act);
+
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_act *tcf_act_update(struct net *net, struct nlattr **tb,
+				       struct p4tc_pipeline *pipeline, u32 *ids,
+				       u32 flags,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_act_param *params[P4TC_MSGBATCH_SIZE] = { NULL };
+	const u32 a_id = ids[P4TC_AID_IDX];
+	int num_params = 0;
+	s8 active = -1;
+	int ret = 0;
+	struct p4tc_act *act;
+
+	act = tcf_action_find_byanyattr(tb[P4TC_ACT_NAME], a_id, pipeline,
+					extack);
+	if (IS_ERR(act))
+		return act;
+
+	if (tb[P4TC_ACT_ACTIVE])
+		active = nla_get_u8(tb[P4TC_ACT_ACTIVE]);
+
+	if (act->active) {
+		if (!active) {
+			if (refcount_read(&act->ops.dyn_ref) > 1) {
+				NL_SET_ERR_MSG(extack,
+					       "Unable to inactivate referenced action");
+				return ERR_PTR(-EINVAL);
+			}
+			act->active = false;
+			return act;
+		}
+		NL_SET_ERR_MSG(extack, "Unable to update active action");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (tb[P4TC_ACT_PARMS]) {
+		num_params = p4_act_init_params(act, tb[P4TC_ACT_PARMS], params,
+						true, extack);
+		if (num_params < 0) {
+			ret = num_params;
+			goto out;
+		}
+		set_param_indices(act);
+	}
+
+	act->pipeline = pipeline;
+	if (active == 1) {
+		act->active = true;
+	} else if (!active) {
+		NL_SET_ERR_MSG(extack, "Action is already inactive");
+		ret = -EINVAL;
+		goto params_del;
+	}
+
+	if (tb[P4TC_ACT_CMDS_LIST]) {
+		ret = determine_act_topological_order(pipeline, true);
+		if (ret < 0)
+			goto params_del;
+	}
+
+	p4tc_params_replace_many(&act->params_idr, params, num_params);
+	return act;
+
+params_del:
+	p4_put_many_params(&act->params_idr, params, num_params);
+
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_template_common *
+tcf_act_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+	   struct p4tc_nl_pname *nl_pname, u32 *ids,
+	   struct netlink_ext_ack *extack)
+{
+	const u32 pipeid = ids[P4TC_PID_IDX];
+	struct nlattr *tb[P4TC_ACT_MAX + 1];
+	struct p4tc_act *act;
+	struct p4tc_pipeline *pipeline;
+	int ret;
+
+	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
+						    extack);
+	if (IS_ERR(pipeline))
+		return (void *)pipeline;
+
+	ret = nla_parse_nested(tb, P4TC_ACT_MAX, nla, p4tc_act_policy, extack);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (n->nlmsg_flags & NLM_F_REPLACE)
+		act = tcf_act_update(net, tb, pipeline, ids, n->nlmsg_flags,
+				     extack);
+	else
+		act = tcf_act_create(net, tb, pipeline, ids, extack);
+	if (IS_ERR(act))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+out:
+	return (struct p4tc_template_common *)act;
+}
+
+static int tcf_act_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			struct nlattr *nla, char **p_name, u32 *ids,
+			struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct p4tc_pipeline *pipeline;
+
+	if (!ctx->ids[P4TC_PID_IDX]) {
+		pipeline = tcf_pipeline_find_byany(net, *p_name,
+						   ids[P4TC_PID_IDX], extack);
+		if (IS_ERR(pipeline))
+			return PTR_ERR(pipeline);
+		ctx->ids[P4TC_PID_IDX] = pipeline->common.p_id;
+	} else {
+		pipeline = tcf_pipeline_find_byid(net, ctx->ids[P4TC_PID_IDX]);
+	}
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!(*p_name))
+		*p_name = pipeline->common.name;
+
+	return tcf_p4_tmpl_generic_dump(skb, ctx, &pipeline->p_act_idr,
+					P4TC_AID_IDX, extack);
+}
+
+static int tcf_act_dump_1(struct sk_buff *skb,
+			  struct p4tc_template_common *common)
+{
+	struct nlattr *param = nla_nest_start(skb, P4TC_PARAMS);
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_act *act = to_act(common);
+	struct nlattr *nest;
+
+	if (!param)
+		goto out_nlmsg_trim;
+
+	if (nla_put_string(skb, P4TC_ACT_NAME, act->common.name))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
+	nla_nest_end(skb, nest);
+
+	if (nla_put_u8(skb, P4TC_ACT_ACTIVE, act->active))
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
+const struct p4tc_template_ops p4tc_act_ops = {
+	.init = NULL,
+	.cu = tcf_act_cu,
+	.put = tcf_act_put,
+	.gd = tcf_act_gd,
+	.fill_nlmsg = tcf_act_fill_nlmsg,
+	.dump = tcf_act_dump,
+	.dump_1 = tcf_act_dump_1,
+};
diff --git a/net/sched/p4tc/p4tc_meta.c b/net/sched/p4tc/p4tc_meta.c
index 21a5477ab0c6..140759818da7 100644
--- a/net/sched/p4tc/p4tc_meta.c
+++ b/net/sched/p4tc/p4tc_meta.c
@@ -202,6 +202,67 @@ static int p4tc_check_meta_size(struct p4tc_meta_size_params *sz_params,
 	return new_bitsz;
 }
 
+static inline void *tcf_meta_fetch_kernel(struct sk_buff *skb,
+					  const u32 kernel_meta_id)
+{
+	switch (kernel_meta_id) {
+	case P4TC_KERNEL_META_QMAP:
+		return &skb->queue_mapping;
+	case P4TC_KERNEL_META_PKTLEN:
+		return &skb->len;
+	case P4TC_KERNEL_META_DATALEN:
+		return &skb->data_len;
+	case P4TC_KERNEL_META_SKBMARK:
+		return &skb->mark;
+	case P4TC_KERNEL_META_TCINDEX:
+		return &skb->tc_index;
+	case P4TC_KERNEL_META_SKBHASH:
+		return &skb->hash;
+	case P4TC_KERNEL_META_SKBPRIO:
+		return &skb->priority;
+	case P4TC_KERNEL_META_IFINDEX:
+		return &skb->dev->ifindex;
+	case P4TC_KERNEL_META_SKBIIF:
+		return &skb->skb_iif;
+	case P4TC_KERNEL_META_PROTOCOL:
+		return &skb->protocol;
+	case P4TC_KERNEL_META_PKTYPE:
+	case P4TC_KERNEL_META_IDF:
+	case P4TC_KERNEL_META_IPSUM:
+	case P4TC_KERNEL_META_OOOK:
+	case P4TC_KERNEL_META_PTYPEOFF:
+	case P4TC_KERNEL_META_PTCLNOFF:
+		return &skb->__pkt_type_offset;
+	case P4TC_KERNEL_META_FCLONE:
+	case P4TC_KERNEL_META_PEEKED:
+	case P4TC_KERNEL_META_CLONEOFF:
+		return &skb->__cloned_offset;
+	case P4TC_KERNEL_META_DIRECTION:
+		return &skb->__mono_tc_offset;
+	default:
+		return NULL;
+	}
+
+	return NULL;
+}
+
+static inline void *tcf_meta_fetch_user(struct sk_buff *skb, const u32 skb_off)
+{
+	struct p4tc_percpu_scratchpad *pad;
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+
+	return &pad->metadata[skb_off];
+}
+
+void *tcf_meta_fetch(struct sk_buff *skb, struct p4tc_metadata *meta)
+{
+	if (meta->common.p_id != P4TC_KERNEL_PIPEID)
+		return tcf_meta_fetch_user(skb, meta->m_skb_off);
+
+	return tcf_meta_fetch_kernel(skb, meta->m_id);
+}
+
 void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline)
 {
 	u32 meta_off = START_META_OFFSET;
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index ed924059cb6a..e4cb5ad994e8 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -77,10 +77,226 @@ static const struct nla_policy tc_pipeline_policy[P4TC_PIPELINE_MAX + 1] = {
 	[P4TC_PIPELINE_POSTACTIONS] = { .type = NLA_NESTED },
 };
 
+static void __act_dep_graph_free(struct list_head *incoming_egde_list)
+{
+	struct p4tc_act_dep_edge_node *cursor_edge, *tmp_edge;
+
+	list_for_each_entry_safe(cursor_edge, tmp_edge, incoming_egde_list,
+				 head) {
+		list_del(&cursor_edge->head);
+		kfree(cursor_edge);
+	}
+}
+
+static void act_dep_graph_free(struct list_head *graph)
+{
+	struct p4tc_act_dep_node *cursor, *tmp;
+
+	list_for_each_entry_safe(cursor, tmp, graph, head) {
+		__act_dep_graph_free(&cursor->incoming_egde_list);
+
+		list_del(&cursor->head);
+		kfree(cursor);
+	}
+}
+
+void tcf_pipeline_delete_from_dep_graph(struct p4tc_pipeline *pipeline,
+					struct p4tc_act *act)
+{
+	struct p4tc_act_dep_node *act_node, *node_tmp;
+
+	list_for_each_entry_safe(act_node, node_tmp, &pipeline->act_dep_graph,
+				 head) {
+		if (act_node->act_id == act->a_id) {
+			__act_dep_graph_free(&act_node->incoming_egde_list);
+			list_del(&act_node->head);
+			kfree(act_node);
+		}
+	}
+
+	list_for_each_entry_safe(act_node, node_tmp,
+				 &pipeline->act_topological_order, head) {
+		if (act_node->act_id == act->a_id) {
+			list_del(&act_node->head);
+			kfree(act_node);
+		}
+	}
+}
+
+/* Node id indicates the callee's act id.
+ * edge_node->act_id indicates the caller's act id.
+ */
+void tcf_pipeline_add_dep_edge(struct p4tc_pipeline *pipeline,
+			       struct p4tc_act_dep_edge_node *edge_node,
+			       u32 node_id)
+{
+	struct p4tc_act_dep_node *cursor;
+
+	list_for_each_entry(cursor, &pipeline->act_dep_graph, head) {
+		if (cursor->act_id == node_id)
+			break;
+	}
+
+	list_add_tail(&edge_node->head, &cursor->incoming_egde_list);
+}
+
+/* Find root node, that is, the node in our graph that has no incoming edges.
+ */
+struct p4tc_act_dep_node *find_root_node(struct list_head *act_dep_graph)
+{
+	struct p4tc_act_dep_node *cursor, *root_node;
+
+	list_for_each_entry(cursor, act_dep_graph, head) {
+		if (list_empty(&cursor->incoming_egde_list)) {
+			root_node = cursor;
+			return root_node;
+		}
+	}
+
+	return NULL;
+}
+
+/* node_id indicates where the edge is directed to
+ * edge_node->act_id indicates where the edge comes from.
+ */
+bool tcf_pipeline_check_act_backedge(struct p4tc_pipeline *pipeline,
+				     struct p4tc_act_dep_edge_node *edge_node,
+				     u32 node_id)
+{
+	struct p4tc_act_dep_node *root_node = NULL;
+
+	/* make sure we dont call ourselves */
+	if (edge_node->act_id == node_id)
+		return true;
+
+	/* add to the list temporarily so we can run our algorithm to
+	 * find edgeless node and detect a cycle
+	 */
+	tcf_pipeline_add_dep_edge(pipeline, edge_node, node_id);
+
+	/* Now lets try to find a node which has no incoming edges (root node).
+	 * If we find a root node it means there is no cycle;
+	 * OTOH, if we dont find one, it means we have circular depency.
+	 */
+	root_node = find_root_node(&pipeline->act_dep_graph);
+
+	if (!root_node)
+		return true;
+
+	list_del(&edge_node->head);
+
+	return false;
+}
+
+static struct p4tc_act_dep_node *
+find_and_del_root_node(struct list_head *act_dep_graph)
+{
+	struct p4tc_act_dep_node *cursor, *tmp, *root_node;
+
+	root_node = find_root_node(act_dep_graph);
+	list_del(&root_node->head);
+
+	list_for_each_entry_safe(cursor, tmp, act_dep_graph, head) {
+		struct p4tc_act_dep_edge_node *cursor_edge, *tmp_edge;
+
+		list_for_each_entry_safe(cursor_edge, tmp_edge,
+					 &cursor->incoming_egde_list, head) {
+			if (cursor_edge->act_id == root_node->act_id) {
+				list_del(&cursor_edge->head);
+				kfree(cursor_edge);
+			}
+		}
+	}
+
+	return root_node;
+}
+
+static int act_dep_graph_copy(struct list_head *new_graph,
+			      struct list_head *old_graph)
+{
+	int err = -ENOMEM;
+	struct p4tc_act_dep_node *cursor, *tmp;
+
+	list_for_each_entry_safe(cursor, tmp, old_graph, head) {
+		struct p4tc_act_dep_edge_node *cursor_edge, *tmp_edge;
+		struct p4tc_act_dep_node *new_dep_node;
+
+		new_dep_node = kzalloc(sizeof(*new_dep_node), GFP_KERNEL);
+		if (!new_dep_node)
+			goto free_graph;
+
+		INIT_LIST_HEAD(&new_dep_node->incoming_egde_list);
+		list_add_tail(&new_dep_node->head, new_graph);
+		new_dep_node->act_id = cursor->act_id;
+
+		list_for_each_entry_safe(cursor_edge, tmp_edge,
+					 &cursor->incoming_egde_list, head) {
+			struct p4tc_act_dep_edge_node *new_dep_edge_node;
+
+			new_dep_edge_node =
+				kzalloc(sizeof(*new_dep_edge_node), GFP_KERNEL);
+			if (!new_dep_edge_node)
+				goto free_graph;
+
+			list_add_tail(&new_dep_edge_node->head,
+				      &new_dep_node->incoming_egde_list);
+			new_dep_edge_node->act_id = cursor_edge->act_id;
+		}
+	}
+
+	return 0;
+
+free_graph:
+	act_dep_graph_free(new_graph);
+	return err;
+}
+
+int determine_act_topological_order(struct p4tc_pipeline *pipeline,
+				    bool copy_dep_graph)
+{
+	int i = pipeline->num_created_acts;
+	struct p4tc_act_dep_node *act_node, *node_tmp;
+	struct p4tc_act_dep_node *node;
+	struct list_head *dep_graph;
+
+	if (copy_dep_graph) {
+		int err;
+
+		dep_graph = kzalloc(sizeof(*dep_graph), GFP_KERNEL);
+		if (!dep_graph)
+			return -ENOMEM;
+
+		INIT_LIST_HEAD(dep_graph);
+		err = act_dep_graph_copy(dep_graph, &pipeline->act_dep_graph);
+		if (err < 0)
+			return err;
+	} else {
+		dep_graph = &pipeline->act_dep_graph;
+	}
+
+	/* Clear from previous calls */
+	list_for_each_entry_safe(act_node, node_tmp,
+				 &pipeline->act_topological_order, head) {
+		list_del(&act_node->head);
+		kfree(act_node);
+	}
+
+	while (i--) {
+		node = find_and_del_root_node(dep_graph);
+		list_add_tail(&node->head, &pipeline->act_topological_order);
+	}
+
+	if (copy_dep_graph)
+		kfree(dep_graph);
+
+	return 0;
+}
+
 static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
 				 bool free_pipeline)
 {
 	idr_destroy(&pipeline->p_meta_idr);
+	idr_destroy(&pipeline->p_act_idr);
 
 	if (free_pipeline)
 		kfree(pipeline);
@@ -106,21 +322,15 @@ static int tcf_pipeline_put(struct net *net,
 	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
 	struct p4tc_pipeline *pipeline = to_pipeline(template);
 	struct net *pipeline_net = maybe_get_net(net);
-	struct p4tc_metadata *meta;
+	struct p4tc_act_dep_node *act_node, *node_tmp;
 	unsigned long m_id, tmp;
+	struct p4tc_metadata *meta;
 
 	if (pipeline_net && !refcount_dec_if_one(&pipeline->p_ref)) {
 		NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
 		return -EBUSY;
 	}
 
-	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
-	if (pipeline->parser)
-		tcf_parser_del(net, pipeline, pipeline->parser, extack);
-
-	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
-		meta->common.ops->put(net, &meta->common, true, extack);
-
 	/* XXX: The action fields are only accessed in the control path
 	 * since they will be copied to the filter, where the data path
 	 * will use them. So there is no need to free them in the rcu
@@ -129,6 +339,26 @@ static int tcf_pipeline_put(struct net *net,
 	p4tc_action_destroy(pipeline->preacts);
 	p4tc_action_destroy(pipeline->postacts);
 
+	act_dep_graph_free(&pipeline->act_dep_graph);
+
+	list_for_each_entry_safe(act_node, node_tmp,
+				 &pipeline->act_topological_order, head) {
+		struct p4tc_act *act;
+
+		act = tcf_action_find_byid(pipeline, act_node->act_id);
+		act->common.ops->put(net, &act->common, true, extack);
+		list_del(&act_node->head);
+		kfree(act_node);
+	}
+
+	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
+		meta->common.ops->put(net, &meta->common, true, extack);
+
+	if (pipeline->parser)
+		tcf_parser_del(net, pipeline, pipeline->parser, extack);
+
+	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
+
 	if (pipeline_net)
 		call_rcu(&pipeline->rcu, tcf_pipeline_destroy_rcu);
 	else
@@ -159,26 +389,13 @@ static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 		return -EINVAL;
 	}
 
+	/* Will never fail in this case */
+	determine_act_topological_order(pipeline, false);
+
 	pipeline->p_state = P4TC_STATE_READY;
 	return true;
 }
 
-static int p4tc_action_init(struct net *net, struct nlattr *nla,
-			    struct tc_action *acts[], u32 pipeid, u32 flags,
-			    struct netlink_ext_ack *extack)
-{
-	int init_res[TCA_ACT_MAX_PRIO];
-	size_t attrs_size;
-	int ret;
-
-	/* If action was already created, just bind to existing one*/
-	flags = TCA_ACT_FLAGS_BIND;
-	ret = tcf_action_init(net, NULL, nla, NULL, acts, init_res, &attrs_size,
-			      flags, 0, extack);
-
-	return ret;
-}
-
 struct p4tc_pipeline *tcf_pipeline_find_byid(struct net *net, const u32 pipeid)
 {
 	struct p4tc_pipeline_net *pipe_net;
@@ -323,9 +540,15 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 
 	pipeline->parser = NULL;
 
+	idr_init(&pipeline->p_act_idr);
+
 	idr_init(&pipeline->p_meta_idr);
 	pipeline->p_meta_offset = 0;
 
+	INIT_LIST_HEAD(&pipeline->act_dep_graph);
+	INIT_LIST_HEAD(&pipeline->act_topological_order);
+	pipeline->num_created_acts = 0;
+
 	pipeline->p_state = P4TC_STATE_NOT_READY;
 
 	pipeline->net = net;
@@ -660,7 +883,8 @@ static int tcf_pipeline_gd(struct net *net, struct sk_buff *skb,
 		return PTR_ERR(pipeline);
 
 	tmpl = (struct p4tc_template_common *)pipeline;
-	if (tcf_pipeline_fill_nlmsg(net, skb, tmpl, extack) < 0)
+	ret = tcf_pipeline_fill_nlmsg(net, skb, tmpl, extack);
+	if (ret < 0)
 		return -1;
 
 	if (!ids[P4TC_PID_IDX])
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index 7a3f5c0c3af1..c294dc0789f0 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -44,6 +44,7 @@ static bool obj_is_valid(u32 obj)
 	case P4TC_OBJ_PIPELINE:
 	case P4TC_OBJ_META:
 	case P4TC_OBJ_HDR_FIELD:
+	case P4TC_OBJ_ACT:
 		return true;
 	default:
 		return false;
@@ -54,6 +55,7 @@ static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
 	[P4TC_OBJ_META] = &p4tc_meta_ops,
 	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
+	[P4TC_OBJ_ACT] = &p4tc_act_ops,
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
-- 
2.25.1


