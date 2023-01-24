Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D891679FC1
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 18:07:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234830AbjAXRHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 12:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233799AbjAXRGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 12:06:25 -0500
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77B2A5FDB
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-50112511ba7so168312577b3.3
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 09:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7OsKojdOxHjceybZ1cGA/00tnVkuO558t2sFj27xTXQ=;
        b=QCXF5Si3pz/cpgifl7iMwcYE/W12hLyNveJM8RWP+SgilFHYMUd4rhhNjxq8TaHsV3
         9DwOCXaHMwjmPFLOEyfyOmr7ZX4q9S/7OiYeI3WKezIwmUX9XU5It7agWMM+EIzZ3oYV
         LoRGUGuVPvrqmzW9KUf+fEy3vdFLw9F8hqE4V/FuxoltF2DW0CLMjboTSGsQJXpeCpsF
         SN2hf+HaykLvFJYbI7Kf/XsY1VP0OJhcQ1w3JJPQaRCMzyWHcipm+Vj3mx5NfELV5D5G
         O9lwgrA48OhloULT5kgsQ1z7God6Gfb3UumSfnMJUZ9drM6PeJfxOGtHm0vvCzGo+UwD
         L8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7OsKojdOxHjceybZ1cGA/00tnVkuO558t2sFj27xTXQ=;
        b=TKIQtxhTx/xPawvbukjyAxsENCiz6Y4XYksGnbIFGUwi0Okm0GaxK34d/ZRf+UAV6U
         TQBuNyN7rYUQx6+ku238EhQ+bQVEBwpicZDb6onpHpEe0w391OvFF9xVBNd1Jsw6D0f5
         TsVltOUVPMRn9DhJPgGgjbYmE5RD8bvr7ikm9TrP1JkT6DjIK5SumYBBABP4HkCYET6o
         DDdC6CA1iDtYuDk6XVQohfgeRv3cXMymD2l73/Nfm3hLz5DD5sVl70aEQqWrBuVsjn5a
         dCjAvMossklKD4uNYs2UPcapDdathm+3LXCGrR8iqFBYKSxAfWXdD4YQSiX9qqhQ+koo
         9WCA==
X-Gm-Message-State: AFqh2koDv/72yW5wEhvZXTFnKqTQ433nhareduXg0zg6TagoU0odGJrm
        ybtjZzh8D6qMUAf3VC4EByHOBSbaTEeqShAm
X-Google-Smtp-Source: AMrXdXuZXgwVV4RRvBKgvGk3ZWmMTEEAOQ3Tjyd5+K8RGvS2rewgmfYdy93z+f3EclAfhICfJWUr4A==
X-Received: by 2002:a05:7500:d17:b0:ee:4dce:65b7 with SMTP id kp23-20020a0575000d1700b000ee4dce65b7mr2125614gab.76.1674579934918;
        Tue, 24 Jan 2023 09:05:34 -0800 (PST)
Received: from localhost.localdomain (bras-base-kntaon1618w-grc-10-184-145-9-64.dsl.bell.ca. [184.145.9.64])
        by smtp.gmail.com with ESMTPSA id t5-20020a05620a0b0500b007063036cb03sm1700208qkg.126.2023.01.24.09.05.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 09:05:34 -0800 (PST)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     netdev@vger.kernel.org
Cc:     kernel@mojatatu.com, deb.chatterjee@intel.com,
        anjali.singhai@intel.com, namrata.limaye@intel.com,
        khalidm@nvidia.com, tom@sipanda.io, pratyush@sipanda.io,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        vladbu@nvidia.com, simon.horman@corigine.com
Subject: [PATCH net-next RFC 18/20] p4tc: add register create, update, delete, get, flush and dump
Date:   Tue, 24 Jan 2023 12:05:08 -0500
Message-Id: <20230124170510.316970-18-jhs@mojatatu.com>
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

This commit allows users to create, update, delete, get, flush and dump
P4 registers.

It's important to note that write operations, such as create, update
and delete, can only be made if the pipeline is not sealed.

Registers in P4 provide a way to store data in your program that can be
accessed throughout the lifetime of your P4 program. Which means this a
way of storing state between the P4 program's invocations.

Let's take a look at an example register declaration in a P4 program:

Register<bit<32>>(2) register1;

This declaration corresponds to a register named register1, with 2
elements which are of type bit32. You can think of this register as an
array of bit32s with 2 elements.

If one were to create this register with P4TC, one would issue the
following command:

tc p4template create register/ptables/register1 type bit32 numelems 2

This will create register "register1" and give it an ID that will be
assigned by the kernel. If the user wished to specify also the register
id, the command would be the following

tc p4template create register/ptables/register1 regid 1 type bit32 \
numelems 2

Now, after creating register1, if one wished to, for example, update
index 1 of register1 with value 32, one would issue the following
command:

tc p4template update register/ptables/register1 index 1 \
value constant.bit32.32

One could also change the value of a specific index using hex notation,
examplified by the following command:

tc p4template update register/ptables/ regid 1 index 1 \
value constant.bit32.0x20

Note that we used regid in here instead of the register name (register1).
We can always use name or id.

It's important to note that all elements of a register will be
initialised with zero when the register is created

Now, after updating the new register the user could issue a get command
to check if the register's parameters (type, num elems, id, ...) and the
register element values are correct. To do so, the user would issue the
following command:

tc p4template get register/ptables/register1

Which will output the following:

template obj type register
pipeline name ptables id 22
    register name register1
    register id 1
    container type bit32
    startbit 0
    endbit 31
    number of elements 2
        register1[0] 0
        register1[1] 32

Notice that register[0] was unaltered, so it is a 0 because zero is the
default initial values. register[1] has value 32, because it was
updated in the previous command.

The user could also list all of the created registers associated to a
pipeline. For example, to list all of the registers associated with
pipeline ptables, the user would issue the following command:

tc p4template get register/ptables/

Which will output the following:

template obj type register
pipeline name ptables id 22
    register name register1

Another option is to check the value of a specific index inside
register1, that can be done using the following command:

tc p4template get register/ptables/register1 index 1

Which will output the following:

template obj type register
pipeline name ptables id 22
    register name register1
    register id 1
    container type bit32
        register1[1] 32

To delete register1, the user would issue the following command:

tc p4template del register/ptables/register1

Now, to delete all the registers associated with pipeline ptables, the
user would issue the following command:

tc p4template del register/ptables/

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h             |  32 ++
 include/uapi/linux/p4tc.h      |  28 ++
 net/sched/p4tc/Makefile        |   2 +-
 net/sched/p4tc/p4tc_pipeline.c |   9 +-
 net/sched/p4tc/p4tc_register.c | 749 +++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_tmpl_api.c |   2 +
 6 files changed, 820 insertions(+), 2 deletions(-)
 create mode 100644 net/sched/p4tc/p4tc_register.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 9a7942992..d9267b798 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -31,6 +31,7 @@
 #define P4TC_AID_IDX 1
 #define P4TC_PARSEID_IDX 1
 #define P4TC_HDRFIELDID_IDX 2
+#define P4TC_REGID_IDX 1
 
 #define P4TC_HDRFIELD_IS_VALIDITY_BIT 0x1
 
@@ -109,6 +110,7 @@ struct p4tc_pipeline {
 	struct idr                  p_meta_idr;
 	struct idr                  p_act_idr;
 	struct idr                  p_tbl_idr;
+	struct idr                  p_reg_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
 	struct p4tc_parser          *parser;
@@ -395,6 +397,21 @@ struct p4tc_hdrfield {
 
 extern const struct p4tc_template_ops p4tc_hdrfield_ops;
 
+struct p4tc_register {
+	struct p4tc_template_common common;
+	spinlock_t                  reg_value_lock;
+	struct p4tc_type            *reg_type;
+	struct p4tc_type_mask_shift *reg_mask_shift;
+	void                        *reg_value;
+	u32                         reg_num_elems;
+	u32                         reg_id;
+	refcount_t                  reg_ref;
+	u16                         reg_startbit; /* Relative to its container */
+	u16                         reg_endbit; /* Relative to its container */
+};
+
+extern const struct p4tc_template_ops p4tc_register_ops;
+
 struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
 					 u32 m_id);
 void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
@@ -556,10 +573,25 @@ extern const struct p4tc_act_param_ops param_ops[P4T_MAX + 1];
 int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
 			     struct p4tc_act_param *param);
 
+struct p4tc_register *tcf_register_find_byid(struct p4tc_pipeline *pipeline,
+					     const u32 reg_id);
+struct p4tc_register *tcf_register_get(struct p4tc_pipeline *pipeline,
+				       const char *regname, const u32 reg_id,
+				       struct netlink_ext_ack *extack);
+void tcf_register_put_ref(struct p4tc_register *reg);
+
+struct p4tc_register *tcf_register_find_byany(struct p4tc_pipeline *pipeline,
+					      const char *regname,
+					      const u32 reg_id,
+					      struct netlink_ext_ack *extack);
+
+void tcf_register_put_rcu(struct rcu_head *head);
+
 #define to_pipeline(t) ((struct p4tc_pipeline *)t)
 #define to_meta(t) ((struct p4tc_metadata *)t)
 #define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
 #define to_act(t) ((struct p4tc_act *)t)
 #define to_table(t) ((struct p4tc_table *)t)
+#define to_register(t) ((struct p4tc_register *)t)
 
 #endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 727fdcfe5..0c5f2943e 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -22,6 +22,7 @@ struct p4tcmsg {
 #define P4TC_MAX_KEYSZ 512
 #define HEADER_MAX_LEN 512
 #define META_MAX_LEN 512
+#define P4TC_MAX_REGISTER_ELEMS 128
 
 #define P4TC_MAX_KEYSZ 512
 
@@ -32,6 +33,7 @@ struct p4tcmsg {
 #define HDRFIELDNAMSIZ TEMPLATENAMSZ
 #define ACTPARAMNAMSIZ TEMPLATENAMSZ
 #define TABLENAMSIZ TEMPLATENAMSZ
+#define REGISTERNAMSIZ TEMPLATENAMSZ
 
 #define P4TC_TABLE_FLAGS_KEYSZ 0x01
 #define P4TC_TABLE_FLAGS_MAX_ENTRIES 0x02
@@ -120,6 +122,7 @@ enum {
 	P4TC_OBJ_ACT,
 	P4TC_OBJ_TABLE,
 	P4TC_OBJ_TABLE_ENTRY,
+	P4TC_OBJ_REGISTER,
 	__P4TC_OBJ_MAX,
 };
 #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
@@ -353,6 +356,31 @@ enum {
 	P4TC_ENTITY_MAX
 };
 
+#define P4TC_REGISTER_FLAGS_DATATYPE 0x1
+#define P4TC_REGISTER_FLAGS_STARTBIT 0x2
+#define P4TC_REGISTER_FLAGS_ENDBIT 0x4
+#define P4TC_REGISTER_FLAGS_NUMELEMS 0x8
+#define P4TC_REGISTER_FLAGS_INDEX 0x10
+
+struct p4tc_u_register {
+	__u32 num_elems;
+	__u32 datatype;
+	__u32 index;
+	__u16 startbit;
+	__u16 endbit;
+	__u16 flags;
+};
+
+/* P4 Register attributes */
+enum {
+	P4TC_REGISTER_UNSPEC,
+	P4TC_REGISTER_NAME, /* string */
+	P4TC_REGISTER_INFO, /* struct p4tc_u_register */
+	P4TC_REGISTER_VALUE, /* value blob */
+	__P4TC_REGISTER_MAX
+};
+#define P4TC_REGISTER_MAX (__P4TC_REGISTER_MAX - 1)
+
 #define P4TC_RTA(r) \
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
 
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index 0d2c20223..b35ced1e3 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -2,4 +2,4 @@
 
 obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
 	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
-	p4tc_tbl_api.o
+	p4tc_tbl_api.o p4tc_register.o
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index f8fcde20b..9f8433545 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -298,6 +298,7 @@ static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
 	idr_destroy(&pipeline->p_meta_idr);
 	idr_destroy(&pipeline->p_act_idr);
 	idr_destroy(&pipeline->p_tbl_idr);
+	idr_destroy(&pipeline->p_reg_idr);
 
 	if (free_pipeline)
 		kfree(pipeline);
@@ -324,8 +325,9 @@ static int tcf_pipeline_put(struct net *net,
 	struct p4tc_pipeline *pipeline = to_pipeline(template);
 	struct net *pipeline_net = maybe_get_net(net);
 	struct p4tc_act_dep_node *act_node, *node_tmp;
-	unsigned long tbl_id, m_id, tmp;
+	unsigned long reg_id, tbl_id, m_id, tmp;
 	struct p4tc_metadata *meta;
+	struct p4tc_register *reg;
 	struct p4tc_table *table;
 
 	if (!refcount_dec_if_one(&pipeline->p_ctrl_ref)) {
@@ -371,6 +373,9 @@ static int tcf_pipeline_put(struct net *net,
 	if (pipeline->parser)
 		tcf_parser_del(net, pipeline, pipeline->parser, extack);
 
+	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, reg_id)
+		reg->common.ops->put(net, &reg->common, true, extack);
+
 	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
 
 	if (pipeline_net)
@@ -567,6 +572,8 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 	idr_init(&pipeline->p_meta_idr);
 	pipeline->p_meta_offset = 0;
 
+	idr_init(&pipeline->p_reg_idr);
+
 	INIT_LIST_HEAD(&pipeline->act_dep_graph);
 	INIT_LIST_HEAD(&pipeline->act_topological_order);
 	pipeline->num_created_acts = 0;
diff --git a/net/sched/p4tc/p4tc_register.c b/net/sched/p4tc/p4tc_register.c
new file mode 100644
index 000000000..deac38fd2
--- /dev/null
+++ b/net/sched/p4tc/p4tc_register.c
@@ -0,0 +1,749 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_register.c	P4 TC REGISTER
+ *
+ * Copyright (c) 2022, Mojatatu Networks
+ * Copyright (c) 2022, Intel Corporation.
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
+static const struct nla_policy p4tc_register_policy[P4TC_REGISTER_MAX + 1] = {
+	[P4TC_REGISTER_NAME] = { .type = NLA_STRING, .len  = REGISTERNAMSIZ },
+	[P4TC_REGISTER_INFO] = {
+		.type = NLA_BINARY,
+		.len = sizeof(struct p4tc_u_register),
+	},
+	[P4TC_REGISTER_VALUE] = { .type = NLA_BINARY },
+};
+
+struct p4tc_register *tcf_register_find_byid(struct p4tc_pipeline *pipeline,
+					     const u32 reg_id)
+{
+	return idr_find(&pipeline->p_reg_idr, reg_id);
+}
+
+static struct p4tc_register *
+tcf_register_find_byname(const char *regname, struct p4tc_pipeline *pipeline)
+{
+	struct p4tc_register *reg;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, id)
+		if (strncmp(reg->common.name, regname, REGISTERNAMSIZ) == 0)
+			return reg;
+
+	return NULL;
+}
+
+struct p4tc_register *tcf_register_find_byany(struct p4tc_pipeline *pipeline,
+					      const char *regname,
+					      const u32 reg_id,
+					      struct netlink_ext_ack *extack)
+{
+	struct p4tc_register *reg;
+	int err;
+
+	if (reg_id) {
+		reg = tcf_register_find_byid(pipeline, reg_id);
+		if (!reg) {
+			NL_SET_ERR_MSG(extack, "Unable to find register by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (regname) {
+			reg = tcf_register_find_byname(regname, pipeline);
+			if (!reg) {
+				NL_SET_ERR_MSG(extack,
+					       "Register name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify register name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return reg;
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_register *tcf_register_get(struct p4tc_pipeline *pipeline,
+				       const char *regname, const u32 reg_id,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_register *reg;
+
+	reg = tcf_register_find_byany(pipeline, regname, reg_id, extack);
+	if (IS_ERR(reg))
+		return reg;
+
+	WARN_ON(!refcount_inc_not_zero(&reg->reg_ref));
+
+	return reg;
+}
+
+void tcf_register_put_ref(struct p4tc_register *reg)
+{
+	WARN_ON(!refcount_dec_not_one(&reg->reg_ref));
+}
+
+static struct p4tc_register *
+tcf_register_find_byanyattr(struct p4tc_pipeline *pipeline,
+			    struct nlattr *name_attr, const u32 reg_id,
+			    struct netlink_ext_ack *extack)
+{
+	char *regname = NULL;
+
+	if (name_attr)
+		regname = nla_data(name_attr);
+
+	return tcf_register_find_byany(pipeline, regname, reg_id, extack);
+}
+
+static int _tcf_register_fill_nlmsg(struct sk_buff *skb,
+				    struct p4tc_register *reg,
+				    struct p4tc_u_register *parm_arg)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_u_register parm = { 0 };
+	size_t value_bytesz;
+	struct nlattr *nest;
+	void *value;
+
+	if (nla_put_u32(skb, P4TC_PATH, reg->reg_id))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+
+	if (nla_put_string(skb, P4TC_REGISTER_NAME, reg->common.name))
+		goto out_nlmsg_trim;
+
+	parm.datatype = reg->reg_type->typeid;
+	parm.flags |= P4TC_REGISTER_FLAGS_DATATYPE;
+	if (parm_arg) {
+		parm.index = parm_arg->index;
+		parm.flags |= P4TC_REGISTER_FLAGS_INDEX;
+	} else {
+		parm.startbit = reg->reg_startbit;
+		parm.flags |= P4TC_REGISTER_FLAGS_STARTBIT;
+		parm.endbit = reg->reg_endbit;
+		parm.flags |= P4TC_REGISTER_FLAGS_ENDBIT;
+		parm.num_elems = reg->reg_num_elems;
+		parm.flags |= P4TC_REGISTER_FLAGS_NUMELEMS;
+	}
+
+	if (nla_put(skb, P4TC_REGISTER_INFO, sizeof(parm), &parm))
+		goto out_nlmsg_trim;
+
+	value_bytesz = BITS_TO_BYTES(reg->reg_type->container_bitsz);
+	spin_lock_bh(&reg->reg_value_lock);
+	if (parm.flags & P4TC_REGISTER_FLAGS_INDEX) {
+		value = reg->reg_value + parm.index * value_bytesz;
+	} else {
+		value = reg->reg_value;
+		value_bytesz *= reg->reg_num_elems;
+	}
+
+	if (nla_put(skb, P4TC_REGISTER_VALUE, value_bytesz, value)) {
+		spin_unlock_bh(&reg->reg_value_lock);
+		goto out_nlmsg_trim;
+	}
+	spin_unlock_bh(&reg->reg_value_lock);
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
+static int tcf_register_fill_nlmsg(struct net *net, struct sk_buff *skb,
+				   struct p4tc_template_common *template,
+				   struct netlink_ext_ack *extack)
+{
+	struct p4tc_register *reg = to_register(template);
+
+	if (_tcf_register_fill_nlmsg(skb, reg, NULL) <= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for register");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int _tcf_register_put(struct p4tc_pipeline *pipeline,
+			     struct p4tc_register *reg,
+			     bool unconditional_purge,
+			     struct netlink_ext_ack *extack)
+{
+	void *value;
+
+	if (!refcount_dec_if_one(&reg->reg_ref) && !unconditional_purge)
+		return -EBUSY;
+
+	idr_remove(&pipeline->p_reg_idr, reg->reg_id);
+
+	spin_lock_bh(&reg->reg_value_lock);
+	value = reg->reg_value;
+	reg->reg_value = NULL;
+	spin_unlock_bh(&reg->reg_value_lock);
+	kfree(value);
+
+	if (reg->reg_mask_shift) {
+		kfree(reg->reg_mask_shift->mask);
+		kfree(reg->reg_mask_shift);
+	}
+	kfree(reg);
+
+	return 0;
+}
+
+static int tcf_register_put(struct net *net, struct p4tc_template_common *tmpl,
+			    bool unconditional_purge,
+			    struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		tcf_pipeline_find_byid(net, tmpl->p_id);
+	struct p4tc_register *reg = to_register(tmpl);
+	int ret;
+
+	ret = _tcf_register_put(pipeline, reg, unconditional_purge, extack);
+	if (ret < 0)
+		NL_SET_ERR_MSG(extack, "Unable to delete referenced register");
+
+	return ret;
+}
+
+static struct p4tc_register *tcf_register_create(struct net *net,
+						 struct nlmsghdr *n,
+						 struct nlattr *nla, u32 reg_id,
+						 struct p4tc_pipeline *pipeline,
+						 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_REGISTER_MAX + 1];
+	struct p4tc_u_register *parm;
+	struct p4tc_type *datatype;
+	struct p4tc_register *reg;
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla, p4tc_register_policy,
+			       extack);
+
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
+	if (!reg)
+		return ERR_PTR(-ENOMEM);
+
+	if (!tb[P4TC_REGISTER_NAME]) {
+		NL_SET_ERR_MSG(extack, "Must specify register name");
+		ret = -EINVAL;
+		goto free_reg;
+	}
+
+	if (tcf_register_find_byname(nla_data(tb[P4TC_REGISTER_NAME]), pipeline) ||
+	    tcf_register_find_byid(pipeline, reg_id)) {
+		NL_SET_ERR_MSG(extack, "Register already exists");
+		ret = -EEXIST;
+		goto free_reg;
+	}
+
+	reg->common.p_id = pipeline->common.p_id;
+	strscpy(reg->common.name, nla_data(tb[P4TC_REGISTER_NAME]),
+		REGISTERNAMSIZ);
+
+	if (tb[P4TC_REGISTER_INFO]) {
+		parm = nla_data(tb[P4TC_REGISTER_INFO]);
+	} else {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Missing register info");
+		goto free_reg;
+	}
+
+	if (tb[P4TC_REGISTER_VALUE]) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Value can't be passed in create");
+		goto free_reg;
+	}
+
+	if (parm->flags & P4TC_REGISTER_FLAGS_INDEX) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Index can't be passed in create");
+		goto free_reg;
+	}
+
+	if (parm->flags & P4TC_REGISTER_FLAGS_NUMELEMS) {
+		if (!parm->num_elems) {
+			ret = -EINVAL;
+			NL_SET_ERR_MSG(extack, "Num elems can't be zero");
+			goto free_reg;
+		}
+
+		if (parm->num_elems > P4TC_MAX_REGISTER_ELEMS) {
+			NL_SET_ERR_MSG(extack,
+				       "Number of elements exceededs P4 register maximum");
+			ret = -EINVAL;
+			goto free_reg;
+		}
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify num elems");
+		ret = -EINVAL;
+		goto free_reg;
+	}
+
+	if (!(parm->flags & P4TC_REGISTER_FLAGS_STARTBIT) ||
+	    !(parm->flags & P4TC_REGISTER_FLAGS_ENDBIT)) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Must specify start and endbit");
+		goto free_reg;
+	}
+
+	if (parm->startbit > parm->endbit) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "startbit > endbit");
+		goto free_reg;
+	}
+
+	if (parm->flags & P4TC_REGISTER_FLAGS_DATATYPE) {
+		datatype = p4type_find_byid(parm->datatype);
+		if (!datatype) {
+			NL_SET_ERR_MSG(extack,
+				       "Invalid data type for P4 register");
+			ret = -EINVAL;
+			goto free_reg;
+		}
+		reg->reg_type = datatype;
+	} else {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Must specify datatype");
+		goto free_reg;
+	}
+
+	if (parm->endbit > datatype->bitsz) {
+		NL_SET_ERR_MSG(extack,
+			       "Endbit doesn't fix in container datatype");
+		ret = -EINVAL;
+		goto free_reg;
+	}
+	reg->reg_startbit = parm->startbit;
+	reg->reg_endbit = parm->endbit;
+
+	reg->reg_num_elems = parm->num_elems;
+
+	spin_lock_init(&reg->reg_value_lock);
+
+	reg->reg_value = kcalloc(reg->reg_num_elems,
+				 BITS_TO_BYTES(datatype->container_bitsz),
+				 GFP_KERNEL);
+	if (!reg->reg_value) {
+		ret = -ENOMEM;
+		goto free_reg;
+	}
+
+	if (reg_id) {
+		reg->reg_id = reg_id;
+		ret = idr_alloc_u32(&pipeline->p_reg_idr, reg, &reg->reg_id,
+				    reg->reg_id, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to allocate register id");
+			goto free_reg_value;
+		}
+	} else {
+		reg->reg_id = 1;
+		ret = idr_alloc_u32(&pipeline->p_reg_idr, reg, &reg->reg_id,
+				    UINT_MAX, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to allocate register id");
+			goto free_reg_value;
+		}
+	}
+
+	if (datatype->ops->create_bitops) {
+		size_t bitsz = reg->reg_endbit - reg->reg_startbit + 1;
+		struct p4tc_type_mask_shift *mask_shift;
+
+		mask_shift = datatype->ops->create_bitops(bitsz,
+							  reg->reg_startbit,
+							  reg->reg_endbit,
+							  extack);
+		if (IS_ERR(mask_shift)) {
+			ret = PTR_ERR(mask_shift);
+			goto idr_rm;
+		}
+		reg->reg_mask_shift = mask_shift;
+	}
+
+	refcount_set(&reg->reg_ref, 1);
+
+	reg->common.ops = (struct p4tc_template_ops *)&p4tc_register_ops;
+
+	return reg;
+
+idr_rm:
+	idr_remove(&pipeline->p_reg_idr, reg->reg_id);
+
+free_reg_value:
+	kfree(reg->reg_value);
+
+free_reg:
+	kfree(reg);
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_register *tcf_register_update(struct net *net,
+						 struct nlmsghdr *n,
+						 struct nlattr *nla, u32 reg_id,
+						 struct p4tc_pipeline *pipeline,
+						 struct netlink_ext_ack *extack)
+{
+	void *user_value = NULL;
+	struct nlattr *tb[P4TC_REGISTER_MAX + 1];
+	struct p4tc_u_register *parm;
+	struct p4tc_type *datatype;
+	struct p4tc_register *reg;
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla, p4tc_register_policy,
+			       extack);
+
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	reg = tcf_register_find_byanyattr(pipeline, tb[P4TC_REGISTER_NAME],
+					  reg_id, extack);
+	if (IS_ERR(reg))
+		return reg;
+
+	if (tb[P4TC_REGISTER_INFO]) {
+		parm = nla_data(tb[P4TC_REGISTER_INFO]);
+	} else {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Missing register info");
+		goto err;
+	}
+
+	datatype = reg->reg_type;
+
+	if (parm->flags & P4TC_REGISTER_FLAGS_NUMELEMS) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Can't update register num elems");
+		goto err;
+	}
+
+	if (!(parm->flags & P4TC_REGISTER_FLAGS_STARTBIT) ||
+	    !(parm->flags & P4TC_REGISTER_FLAGS_ENDBIT)) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Must specify start and endbit");
+		goto err;
+	}
+
+	if (parm->startbit != reg->reg_startbit ||
+	    parm->endbit != reg->reg_endbit) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack,
+			       "Start and endbit don't match with register values");
+		goto err;
+	}
+
+	if (!(parm->flags & P4TC_REGISTER_FLAGS_INDEX)) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Must specify index");
+		goto err;
+	}
+
+	if (tb[P4TC_REGISTER_VALUE]) {
+		if (nla_len(tb[P4TC_REGISTER_VALUE]) !=
+		    BITS_TO_BYTES(datatype->container_bitsz)) {
+			ret = -EINVAL;
+			NL_SET_ERR_MSG(extack,
+				       "Value size differs from register type's container size");
+			goto err;
+		}
+		user_value = nla_data(tb[P4TC_REGISTER_VALUE]);
+	} else {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Missing register value");
+		goto err;
+	}
+
+	if (parm->index >= reg->reg_num_elems) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Register index out of bounds");
+		goto err;
+	}
+
+	if (user_value) {
+		u64 read_user_value[2] = { 0 };
+		size_t type_bytesz;
+		void *value;
+
+		type_bytesz = BITS_TO_BYTES(datatype->container_bitsz);
+
+		datatype->ops->host_read(datatype, reg->reg_mask_shift,
+					 user_value, read_user_value);
+
+		spin_lock_bh(&reg->reg_value_lock);
+		value = reg->reg_value + parm->index * type_bytesz;
+		datatype->ops->host_write(datatype, reg->reg_mask_shift,
+					  read_user_value, value);
+		spin_unlock_bh(&reg->reg_value_lock);
+	}
+
+	return reg;
+
+err:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_template_common *
+tcf_register_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+		struct p4tc_nl_pname *nl_pname, u32 *ids,
+		struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], reg_id = ids[P4TC_REGID_IDX];
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_register *reg;
+
+	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
+						    extack);
+	if (IS_ERR(pipeline))
+		return (void *)pipeline;
+
+	if (n->nlmsg_flags & NLM_F_REPLACE)
+		reg = tcf_register_update(net, n, nla, reg_id, pipeline,
+					  extack);
+	else
+		reg = tcf_register_create(net, n, nla, reg_id, pipeline,
+					  extack);
+
+	if (IS_ERR(reg))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = reg->common.p_id;
+
+out:
+	return (struct p4tc_template_common *)reg;
+}
+
+static int tcf_register_flush(struct sk_buff *skb,
+			      struct p4tc_pipeline *pipeline,
+			      struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_register *reg;
+	unsigned long tmp, reg_id;
+	int ret = 0;
+	int i = 0;
+
+	if (nla_put_u32(skb, P4TC_PATH, 0))
+		goto out_nlmsg_trim;
+
+	if (idr_is_empty(&pipeline->p_reg_idr)) {
+		NL_SET_ERR_MSG(extack, "There are no registers to flush");
+		goto out_nlmsg_trim;
+	}
+
+	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, reg_id) {
+		if (_tcf_register_put(pipeline, reg, false, extack) < 0) {
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
+			NL_SET_ERR_MSG(extack, "Unable to flush any register");
+			goto out_nlmsg_trim;
+		} else {
+			NL_SET_ERR_MSG(extack, "Unable to flush all registers");
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
+static int tcf_register_gd(struct net *net, struct sk_buff *skb,
+			   struct nlmsghdr *n, struct nlattr *nla,
+			   struct p4tc_nl_pname *nl_pname, u32 *ids,
+			   struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], reg_id = ids[P4TC_REGID_IDX];
+	struct nlattr *tb[P4TC_REGISTER_MAX + 1] = {};
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_u_register *parm_arg = NULL;
+	int ret = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_register *reg;
+	struct nlattr *attr_info;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE)
+		pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data,
+							    pipeid, extack);
+	else
+		pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid,
+						   extack);
+
+	if (IS_ERR(pipeline))
+		return PTR_ERR(pipeline);
+
+	if (nla) {
+		ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla,
+				       p4tc_register_policy, extack);
+
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
+		return tcf_register_flush(skb, pipeline, extack);
+
+	reg = tcf_register_find_byanyattr(pipeline, tb[P4TC_REGISTER_NAME],
+					  reg_id, extack);
+	if (IS_ERR(reg))
+		return PTR_ERR(reg);
+
+	attr_info = tb[P4TC_REGISTER_INFO];
+	if (attr_info) {
+		if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+			NL_SET_ERR_MSG(extack,
+				       "Can't pass info attribute in delete");
+			return -EINVAL;
+		}
+		parm_arg = nla_data(attr_info);
+		if (!(parm_arg->flags & P4TC_REGISTER_FLAGS_INDEX) ||
+		    (parm_arg->flags & ~P4TC_REGISTER_FLAGS_INDEX)) {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify param index and only param index");
+			return -EINVAL;
+		}
+		if (parm_arg->index >= reg->reg_num_elems) {
+			NL_SET_ERR_MSG(extack, "Register index out of bounds");
+			return -EINVAL;
+		}
+	}
+	if (_tcf_register_fill_nlmsg(skb, reg, parm_arg) < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for register");
+		return -EINVAL;
+	}
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = _tcf_register_put(pipeline, reg, false, extack);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to delete referenced register");
+			goto out_nlmsg_trim;
+		}
+	}
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_register_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			     struct nlattr *nla, char **p_name, u32 *ids,
+			     struct netlink_ext_ack *extack)
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
+	return tcf_p4_tmpl_generic_dump(skb, ctx, &pipeline->p_reg_idr,
+					P4TC_REGID_IDX, extack);
+}
+
+static int tcf_register_dump_1(struct sk_buff *skb,
+			       struct p4tc_template_common *common)
+{
+	struct nlattr *nest = nla_nest_start(skb, P4TC_PARAMS);
+	struct p4tc_register *reg = to_register(common);
+
+	if (!nest)
+		return -ENOMEM;
+
+	if (nla_put_string(skb, P4TC_REGISTER_NAME, reg->common.name)) {
+		nla_nest_cancel(skb, nest);
+		return -ENOMEM;
+	}
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+}
+
+const struct p4tc_template_ops p4tc_register_ops = {
+	.cu = tcf_register_cu,
+	.fill_nlmsg = tcf_register_fill_nlmsg,
+	.gd = tcf_register_gd,
+	.put = tcf_register_put,
+	.dump = tcf_register_dump,
+	.dump_1 = tcf_register_dump_1,
+};
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index 2963f6497..5712cfaf8 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -46,6 +46,7 @@ static bool obj_is_valid(u32 obj)
 	case P4TC_OBJ_HDR_FIELD:
 	case P4TC_OBJ_ACT:
 	case P4TC_OBJ_TABLE:
+	case P4TC_OBJ_REGISTER:
 		return true;
 	default:
 		return false;
@@ -58,6 +59,7 @@ static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
 	[P4TC_OBJ_ACT] = &p4tc_act_ops,
 	[P4TC_OBJ_TABLE] = &p4tc_table_ops,
+	[P4TC_OBJ_REGISTER] = &p4tc_register_ops,
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
-- 
2.34.1

