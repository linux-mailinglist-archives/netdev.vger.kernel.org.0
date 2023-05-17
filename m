Return-Path: <netdev+bounces-3294-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21FE4706624
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:07:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFA0128165D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:07:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D30B6171B7;
	Wed, 17 May 2023 11:04:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C00211F196
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:25 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46723198D
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:57 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f610c11472so2397791cf.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321430; x=1686913430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DZr/tLbS7sYwjBRnl1fxcTCcUhSxUlDqNLBHEjNidIY=;
        b=OJXDI3BJfcIllohmeUC+Y8ihJzE4XnQvf++INbzXtMXDKt2kTL5jVW++zJ7ZYYH2dJ
         O6fdi1NzCHkZzNiFDybV2XNw5Blg5ImBncrhgczcpGsfkJykgHAq17g6tj/w91QAN/Zs
         lX02kS30JjHJypcYqWlktiF4+Hgx7twNbUkRGF0T62OKiodZ9DwVsda24HvaFjWrrTkS
         fIlScoxQ2tdc2HlUh4f92IfQ7joJMsv6w3yZEzAlOMadUwOcQ2meR/meKTPejoKmSspk
         jQynO00aSbsVG3Q7AHHoRl1j9HPgYkyJEhBdmglkvmR+0DAwiBcf9sZ4HNoEjVGBkipw
         N0Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321430; x=1686913430;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DZr/tLbS7sYwjBRnl1fxcTCcUhSxUlDqNLBHEjNidIY=;
        b=LJUbgwsg3xHnW/NnNUYq93wBVWmscY3NYdKKnW98bdhEuru4Kd3VZHZihvtBtVVLKq
         SXM1iHXPMZk2B9LOecRj2aJa4HJHu+T15s8jkWIlIj7sOGQJvzXlTYu4m0xrrwZYoNHe
         ZOcwOn/cXNvqRCE04oohrp28O8RSZL+tEQfUrHHe8BLVkMIkuOobhdXszBOItbDnKkCn
         f5yu9Miul+K4lxR0NPrKvQiHJk12RggBw1j591TYa2R8wRnCnQWlj4csT8o8V1K7Vb7D
         3zcHeSKD2NWVye4oM5eGDVX/phgSehJKgZUdWOtnIkFIQtaLaqAZcxxvbNZNtOsJsT9V
         dPhQ==
X-Gm-Message-State: AC+VfDzbj2NCJwnp2xlV24CGm77FuZcyd8/oZCjVli8D4esXbqPb/3jQ
	krb0K9/E9D1E7HT5oS2c4GEyMeS4UiOgienTjsM=
X-Google-Smtp-Source: ACHHUZ5G+r256R8A0cQGcHdbmuFh9OC1DjjmKg344e51TdqmD//mLwK+qIiyCyJaUpFw1VVPKFm2Xw==
X-Received: by 2002:a05:622a:8:b0:3f5:c257:9f10 with SMTP id x8-20020a05622a000800b003f5c2579f10mr3081103qtw.22.1684321429313;
        Wed, 17 May 2023 04:03:49 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id e4-20020ac84904000000b003f1f87814a4sm6415909qtq.84.2023.05.17.04.03.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:48 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 11/28] p4tc: add metadata create, update, delete, get, flush and dump
Date: Wed, 17 May 2023 07:02:15 -0400
Message-Id: <20230517110232.29349-11-jhs@mojatatu.com>
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

This commit allows users to create, update, delete and get a P4 pipeline's
metadatum. It also allows users to flush and dump all of the P4 pipeline's
metadata.

As an example, if one were to create a metadatum named mname in a pipeline
named ptables with a type of 8 bits, one would use the following command:

tc p4template create metadata/ptables/mname [mid 1] type bit8

Note that, in the above command, the metadatum id is optional. If one
does not specify a metadatum id, the kernel will assign one.

If one were to update a metadatum named mname in a pipeline named ptables
with an mid of 1, one would use the following command:

tc p4template update metadata/ptables/[mname] [mid 1] type bit4

Note that, in the above command, the metadatum's id and the metadatum's
name are optional. That is, one may specify only the metadatum's name,
only the metadatum's id, or both.

If one were to delete a metadatum named mname from a pipeline named
ptables with an mid of 1, one would use the following command:

tc p4template del metadata/ptables/[mname] [mid 1]

Note that, in the above command, the metadatum's id and the metadatum's
name are optional. That is, one may specify only the metadatum's name,
only the metadatum's id, or both.

If one were to flush all the metadata from a pipeline named ptables, one
would use the following command:

tc p4template del metadata/ptables/

If one were to get a metadatum named mname from a pipeline named ptables
with an mid of 1, one would use the following command:

tc p4template get metadata/ptables/[mname] [mid 1]

Note that, in the above command, the metadatum's id and the metadatum's
name are optional. That is, one may specify only the metadatum's name,
only the metadatum's id, or both.

If one were to dump all the metadata from a pipeline named ptables, one
would use the following command:

tc p4template get metadata/ptables/

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h             |  44 ++
 include/uapi/linux/p4tc.h      |  51 ++
 net/sched/p4tc/Makefile        |   2 +-
 net/sched/p4tc/p4tc_meta.c     | 819 +++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_pipeline.c |  23 +-
 net/sched/p4tc/p4tc_tmpl_api.c |  19 +
 6 files changed, 952 insertions(+), 6 deletions(-)
 create mode 100644 net/sched/p4tc/p4tc_meta.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 178bbdf68719..6e3c4681c1d6 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -12,11 +12,23 @@
 
 #define P4TC_DEFAULT_NUM_TABLES P4TC_MINTABLES_COUNT
 #define P4TC_DEFAULT_MAX_RULES 1
+#define P4TC_MAXMETA_OFFSET 512
 #define P4TC_PATH_MAX 3
 
 #define P4TC_KERNEL_PIPEID 0
 
 #define P4TC_PID_IDX 0
+#define P4TC_MID_IDX 1
+
+struct p4tc_percpu_scratchpad {
+	u32 keysz;
+	u32 maskid;
+	u8 key[BITS_TO_BYTES(P4TC_MAX_KEYSZ)];
+	u8 hdrs[BITS_TO_BYTES(HEADER_MAX_LEN)];
+	u8 metadata[BITS_TO_BYTES(META_MAX_LEN)];
+};
+
+DECLARE_PER_CPU(struct p4tc_percpu_scratchpad, p4tc_percpu_scratchpad);
 
 struct p4tc_dump_ctx {
 	u32 ids[P4TC_PATH_MAX];
@@ -78,6 +90,7 @@ extern const struct p4tc_template_ops p4tc_pipeline_ops;
 
 struct p4tc_pipeline {
 	struct p4tc_template_common common;
+	struct idr                  p_meta_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
 	struct tc_action            **preacts;
@@ -85,6 +98,7 @@ struct p4tc_pipeline {
 	struct tc_action            **postacts;
 	int                         num_postacts;
 	u32                         max_rules;
+	u32                         p_meta_offset;
 	refcount_t                  p_ref;
 	refcount_t                  p_ctrl_ref;
 	u16                         num_tables;
@@ -126,6 +140,36 @@ static inline int p4tc_action_destroy(struct tc_action **acts)
 	return ret;
 }
 
+static inline bool pipeline_sealed(struct p4tc_pipeline *pipeline)
+{
+	return pipeline->p_state == P4TC_STATE_READY;
+}
+
+struct p4tc_metadata {
+	struct p4tc_template_common common;
+	struct rcu_head             rcu;
+	u32                         m_id;
+	u32                         m_skb_off;
+	refcount_t                  m_ref;
+	u16                         m_sz;
+	u16                         m_startbit; /* Relative to its container */
+	u16                         m_endbit; /* Relative to its container */
+	u8                          m_datatype; /* T_XXX */
+	bool                        m_read_only;
+};
+
+extern const struct p4tc_template_ops p4tc_meta_ops;
+
+struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
+					 u32 m_id);
+void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
+void tcf_meta_init(struct p4tc_pipeline *root_pipe);
+struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
+				   const char *mname, const u32 m_id,
+				   struct netlink_ext_ack *extack);
+void tcf_meta_put_ref(struct p4tc_metadata *meta);
+
 #define to_pipeline(t) ((struct p4tc_pipeline *)t)
+#define to_meta(t) ((struct p4tc_metadata *)t)
 
 #endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 739c0fe18e95..8934c032dc87 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -18,11 +18,15 @@ struct p4tcmsg {
 #define P4TC_MAXPARSE_KEYS 16
 #define P4TC_MAXMETA_SZ 128
 #define P4TC_MSGBATCH_SIZE 16
+#define P4TC_MAX_KEYSZ 512
+#define HEADER_MAX_LEN 512
+#define META_MAX_LEN 512
 
 #define P4TC_MAX_KEYSZ 512
 
 #define TEMPLATENAMSZ 256
 #define PIPELINENAMSIZ TEMPLATENAMSZ
+#define METANAMSIZ TEMPLATENAMSZ
 
 /* Root attributes */
 enum {
@@ -50,6 +54,7 @@ enum {
 enum {
 	P4TC_OBJ_UNSPEC,
 	P4TC_OBJ_PIPELINE,
+	P4TC_OBJ_META,
 	__P4TC_OBJ_MAX,
 };
 #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
@@ -59,6 +64,7 @@ enum {
 	P4TC_UNSPEC,
 	P4TC_PATH,
 	P4TC_PARAMS,
+	P4TC_COUNT,
 	__P4TC_MAX,
 };
 #define P4TC_MAX __P4TC_MAX
@@ -102,6 +108,51 @@ enum {
 };
 #define P4T_MAX (__P4T_MAX - 1)
 
+/* Details all the info needed to find out metadata size and layout inside cb
+ * datastructure
+ */
+struct p4tc_meta_size_params {
+	__u16 startbit;
+	__u16 endbit;
+	__u8 datatype; /* T_XXX */
+};
+
+/* Metadata attributes */
+enum {
+	P4TC_META_UNSPEC,
+	P4TC_META_NAME, /* string */
+	P4TC_META_SIZE, /* struct p4tc_meta_size_params */
+	__P4TC_META_MAX
+};
+#define P4TC_META_MAX __P4TC_META_MAX
+
+/* Linux system metadata */
+enum {
+	P4TC_KERNEL_META_UNSPEC,
+	P4TC_KERNEL_META_PKTLEN,	/* u32 */
+	P4TC_KERNEL_META_DATALEN,	/* u32 */
+	P4TC_KERNEL_META_SKBMARK,	/* u32 */
+	P4TC_KERNEL_META_TCINDEX,	/* u16 */
+	P4TC_KERNEL_META_SKBHASH,	/* u32 */
+	P4TC_KERNEL_META_SKBPRIO,	/* u32 */
+	P4TC_KERNEL_META_IFINDEX,	/* s32 */
+	P4TC_KERNEL_META_SKBIIF,	/* s32 */
+	P4TC_KERNEL_META_PROTOCOL,	/* be16 */
+	P4TC_KERNEL_META_PKTYPE,	/* u8:3 */
+	P4TC_KERNEL_META_IDF,		/* u8:1 */
+	P4TC_KERNEL_META_IPSUM,		/* u8:2 */
+	P4TC_KERNEL_META_OOOK,		/* u8:1 */
+	P4TC_KERNEL_META_FCLONE,	/* u8:2 */
+	P4TC_KERNEL_META_PEEKED,	/* u8:1 */
+	P4TC_KERNEL_META_QMAP,		/* u16 */
+	P4TC_KERNEL_META_PTYPEOFF,	/* u8 */
+	P4TC_KERNEL_META_CLONEOFF,	/* u8 */
+	P4TC_KERNEL_META_PTCLNOFF,	/* u16 */
+	P4TC_KERNEL_META_DIRECTION,	/* u8:1 */
+	__P4TC_KERNEL_META_MAX
+};
+#define P4TC_KERNEL_META_MAX (__P4TC_KERNEL_META_MAX - 1)
+
 #define P4TC_RTA(r) \
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
 
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index 0881a7563646..d523e668cbe5 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,3 +1,3 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := p4tc_types.o p4tc_tmpl_api.o p4tc_pipeline.o
+obj-y := p4tc_types.o p4tc_tmpl_api.o p4tc_pipeline.o p4tc_meta.o
diff --git a/net/sched/p4tc/p4tc_meta.c b/net/sched/p4tc/p4tc_meta.c
new file mode 100644
index 000000000000..21a5477ab0c6
--- /dev/null
+++ b/net/sched/p4tc/p4tc_meta.c
@@ -0,0 +1,819 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_meta.c	P4 TC API METADATA
+ *
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <asm/byteorder.h>
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
+#define START_META_OFFSET 0
+
+static const struct nla_policy p4tc_meta_policy[P4TC_META_MAX + 1] = {
+	[P4TC_META_NAME] = { .type = NLA_STRING, .len = METANAMSIZ },
+	[P4TC_META_SIZE] = { .type = NLA_BINARY,
+			     .len = sizeof(struct p4tc_meta_size_params) },
+};
+
+static int _tcf_meta_put(struct p4tc_pipeline *pipeline,
+			 struct p4tc_metadata *meta, bool unconditional_purge,
+			 struct netlink_ext_ack *extack)
+{
+	if (!unconditional_purge && !refcount_dec_if_one(&meta->m_ref))
+		return -EBUSY;
+
+	pipeline->p_meta_offset -= BITS_TO_U32(meta->m_sz) * sizeof(u32);
+	idr_remove(&pipeline->p_meta_idr, meta->m_id);
+
+	kfree_rcu(meta, rcu);
+
+	return 0;
+}
+
+static int tcf_meta_put(struct net *net, struct p4tc_template_common *template,
+			bool unconditional_purge,
+			struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		tcf_pipeline_find_byid(net, template->p_id);
+	struct p4tc_metadata *meta = to_meta(template);
+	int ret;
+
+	ret = _tcf_meta_put(pipeline, meta, unconditional_purge, extack);
+	if (ret < 0)
+		NL_SET_ERR_MSG(extack, "Unable to delete referenced metadatum");
+
+	return ret;
+}
+
+struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
+					 u32 m_id)
+{
+	return idr_find(&pipeline->p_meta_idr, m_id);
+}
+
+static struct p4tc_metadata *
+tcf_meta_find_byname(const char *m_name, struct p4tc_pipeline *pipeline)
+{
+	struct p4tc_metadata *meta;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, id)
+		if (strncmp(meta->common.name, m_name, METANAMSIZ) == 0)
+			return meta;
+
+	return NULL;
+}
+
+static inline struct p4tc_metadata *
+tcf_meta_find_byname_attr(struct nlattr *name_attr,
+			  struct p4tc_pipeline *pipeline)
+{
+	return tcf_meta_find_byname(nla_data(name_attr), pipeline);
+}
+
+static struct p4tc_metadata *tcf_meta_find_byany(struct p4tc_pipeline *pipeline,
+						 const char *mname,
+						 const u32 m_id,
+						 struct netlink_ext_ack *extack)
+{
+	struct p4tc_metadata *meta;
+	int err;
+
+	if (m_id) {
+		meta = tcf_meta_find_byid(pipeline, m_id);
+		if (!meta) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to find metadatum by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (mname) {
+			meta = tcf_meta_find_byname(mname, pipeline);
+			if (!meta) {
+				NL_SET_ERR_MSG(extack,
+					       "Metadatum name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify metadatum name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return meta;
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
+				   const char *mname, const u32 m_id,
+				   struct netlink_ext_ack *extack)
+{
+	struct p4tc_metadata *meta;
+
+	meta = tcf_meta_find_byany(pipeline, mname, m_id, extack);
+	if (IS_ERR(meta))
+		return meta;
+
+	/* Should never be zero */
+	WARN_ON(!refcount_inc_not_zero(&meta->m_ref));
+	return meta;
+}
+
+void tcf_meta_put_ref(struct p4tc_metadata *meta)
+{
+	WARN_ON(!refcount_dec_not_one(&meta->m_ref));
+}
+
+static struct p4tc_metadata *
+tcf_meta_find_byanyattr(struct p4tc_pipeline *pipeline,
+			struct nlattr *name_attr, const u32 m_id,
+			struct netlink_ext_ack *extack)
+{
+	char *mname = NULL;
+
+	if (name_attr)
+		mname = nla_data(name_attr);
+
+	return tcf_meta_find_byany(pipeline, mname, m_id, extack);
+}
+
+static int p4tc_check_meta_size(struct p4tc_meta_size_params *sz_params,
+				struct p4tc_type *type,
+				struct netlink_ext_ack *extack)
+{
+	int new_bitsz;
+
+	if (sz_params->startbit > P4T_MAX_BITSZ ||
+	    sz_params->startbit > type->bitsz) {
+		NL_SET_ERR_MSG(extack, "Startbit value too big");
+		return -EINVAL;
+	}
+
+	if (sz_params->endbit > P4T_MAX_BITSZ ||
+	    sz_params->endbit > type->bitsz) {
+		NL_SET_ERR_MSG(extack, "Endbit value too big");
+		return -EINVAL;
+	}
+
+	if (sz_params->endbit < sz_params->startbit) {
+		NL_SET_ERR_MSG(extack, "Endbit value smaller than startbit");
+		return -EINVAL;
+	}
+
+	new_bitsz = (sz_params->endbit - sz_params->startbit + 1);
+	if (new_bitsz == 0) {
+		NL_SET_ERR_MSG(extack, "Bit size can't be zero");
+		return -EINVAL;
+	}
+
+	if (new_bitsz > P4T_MAX_BITSZ || new_bitsz > type->bitsz) {
+		NL_SET_ERR_MSG(extack, "Bit size too big");
+		return -EINVAL;
+	}
+
+	return new_bitsz;
+}
+
+void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline)
+{
+	u32 meta_off = START_META_OFFSET;
+	struct p4tc_metadata *meta;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, id) {
+		/* Offsets are multiples of 4 for alignment purposes */
+		meta->m_skb_off = meta_off;
+		meta_off += BITS_TO_U32(meta->m_sz) * sizeof(u32);
+	}
+}
+
+static struct p4tc_metadata *
+__tcf_meta_create(struct p4tc_pipeline *pipeline, u32 m_id, const char *m_name,
+		  struct p4tc_meta_size_params *sz_params, gfp_t alloc_flag,
+		  bool read_only, struct netlink_ext_ack *extack)
+{
+	u32 p_meta_offset = 0;
+	bool kmeta;
+	struct p4tc_metadata *meta;
+	struct p4tc_type *datatype;
+	u32 sz_bytes;
+	int sz_bits;
+	int ret;
+
+	kmeta = pipeline->common.p_id == P4TC_KERNEL_PIPEID;
+
+	meta = kzalloc(sizeof(*meta), alloc_flag);
+	if (!meta) {
+		if (kmeta)
+			pr_err("Unable to allocate kernel metadatum");
+		else
+			NL_SET_ERR_MSG(extack,
+				       "Unable to allocate user metadatum");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	meta->common.p_id = pipeline->common.p_id;
+
+	datatype = p4type_find_byid(sz_params->datatype);
+	if (!datatype) {
+		if (kmeta)
+			pr_err("Invalid data type for kernel metadataum %u\n",
+			       sz_params->datatype);
+		else
+			NL_SET_ERR_MSG(extack,
+				       "Invalid data type for user metdatum");
+		ret = -EINVAL;
+		goto free;
+	}
+
+	sz_bits = p4tc_check_meta_size(sz_params, datatype, extack);
+	if (sz_bits < 0) {
+		ret = sz_bits;
+		goto free;
+	}
+
+	sz_bytes = BITS_TO_U32(datatype->bitsz) * sizeof(u32);
+	if (!kmeta) {
+		p_meta_offset = pipeline->p_meta_offset + sz_bytes;
+		if (p_meta_offset > BITS_TO_BYTES(P4TC_MAXMETA_OFFSET)) {
+			NL_SET_ERR_MSG(extack, "Metadata max offset exceeded");
+			ret = -EINVAL;
+			goto free;
+		}
+	}
+
+	meta->m_datatype = datatype->typeid;
+	meta->m_startbit = sz_params->startbit;
+	meta->m_endbit = sz_params->endbit;
+	meta->m_sz = sz_bits;
+	meta->m_read_only = read_only;
+
+	if (m_id) {
+		ret = idr_alloc_u32(&pipeline->p_meta_idr, meta, &m_id, m_id,
+				    alloc_flag);
+		if (ret < 0) {
+			if (kmeta)
+				pr_err("Unable to alloc kernel metadatum id %u\n",
+				       m_id);
+			else
+				NL_SET_ERR_MSG(extack,
+					       "Unable to alloc user metadatum id");
+			goto free;
+		}
+
+		meta->m_id = m_id;
+	} else {
+		meta->m_id = 1;
+
+		ret = idr_alloc_u32(&pipeline->p_meta_idr, meta, &meta->m_id,
+				    UINT_MAX, alloc_flag);
+		if (ret < 0) {
+			if (kmeta)
+				pr_err("Unable to alloc kernel metadatum id %u\n",
+				       meta->m_id);
+			else
+				NL_SET_ERR_MSG(extack,
+					       "Unable to alloc metadatum id");
+			goto free;
+		}
+	}
+
+	if (!kmeta)
+		pipeline->p_meta_offset = p_meta_offset;
+
+	strscpy(meta->common.name, m_name, METANAMSIZ);
+	meta->common.ops = (struct p4tc_template_ops *)&p4tc_meta_ops;
+
+	refcount_set(&meta->m_ref, 1);
+
+	return meta;
+
+free:
+	kfree(meta);
+out:
+	return ERR_PTR(ret);
+}
+
+struct p4tc_metadata *tcf_meta_create(struct nlmsghdr *n, struct nlattr *nla,
+				      u32 m_id, struct p4tc_pipeline *pipeline,
+				      struct netlink_ext_ack *extack)
+{
+	int ret = 0;
+	struct p4tc_meta_size_params *sz_params;
+	struct nlattr *tb[P4TC_META_MAX + 1];
+	char *m_name;
+
+	ret = nla_parse_nested(tb, P4TC_META_MAX, nla, p4tc_meta_policy,
+			       extack);
+	if (ret < 0)
+		goto out;
+
+	if (tcf_meta_find_byname_attr(tb[P4TC_META_NAME], pipeline) ||
+	    tcf_meta_find_byid(pipeline, m_id)) {
+		NL_SET_ERR_MSG(extack, "Metadatum already exists");
+		ret = -EEXIST;
+		goto out;
+	}
+
+	if (tb[P4TC_META_NAME]) {
+		m_name = nla_data(tb[P4TC_META_NAME]);
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify metadatum name");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	if (tb[P4TC_META_SIZE]) {
+		sz_params = nla_data(tb[P4TC_META_SIZE]);
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify metadatum size params");
+		ret = -ENOENT;
+		goto out;
+	}
+
+	return __tcf_meta_create(pipeline, m_id, m_name, sz_params, GFP_KERNEL,
+				 false, extack);
+
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_metadata *tcf_meta_update(struct nlmsghdr *n,
+					     struct nlattr *nla, u32 m_id,
+					     struct p4tc_pipeline *pipeline,
+					     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_META_MAX + 1];
+	struct p4tc_metadata *meta;
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_META_MAX, nla, p4tc_meta_policy,
+			       extack);
+
+	if (ret < 0)
+		goto out;
+
+	meta = tcf_meta_find_byanyattr(pipeline, tb[P4TC_META_NAME], m_id,
+				       extack);
+	if (IS_ERR(meta))
+		return meta;
+
+	if (tb[P4TC_META_SIZE]) {
+		struct p4tc_type *new_datatype, *curr_datatype;
+		struct p4tc_meta_size_params *sz_params;
+		u32 new_bytesz, curr_bytesz;
+		int new_bitsz;
+		u32 p_meta_offset;
+		int diff;
+
+		sz_params = nla_data(tb[P4TC_META_SIZE]);
+		new_datatype = p4type_find_byid(sz_params->datatype);
+		if (!new_datatype) {
+			NL_SET_ERR_MSG(extack, "Invalid data type");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		new_bitsz =
+			p4tc_check_meta_size(sz_params, new_datatype, extack);
+		if (new_bitsz < 0) {
+			ret = new_bitsz;
+			goto out;
+		}
+
+		new_bytesz = BITS_TO_U32(new_datatype->bitsz) * sizeof(u32);
+
+		curr_datatype = p4type_find_byid(meta->m_datatype);
+		curr_bytesz = BITS_TO_U32(curr_datatype->bitsz) * sizeof(u32);
+
+		diff = new_bytesz - curr_bytesz;
+		p_meta_offset = pipeline->p_meta_offset + diff;
+		if (p_meta_offset > BITS_TO_BYTES(P4TC_MAXMETA_OFFSET)) {
+			NL_SET_ERR_MSG(extack, "Metadata max offset exceeded");
+			ret = -EINVAL;
+			goto out;
+		}
+
+		pipeline->p_meta_offset = p_meta_offset;
+
+		meta->m_datatype = new_datatype->typeid;
+		meta->m_startbit = sz_params->startbit;
+		meta->m_endbit = sz_params->endbit;
+		meta->m_sz = new_bitsz;
+	}
+
+	return meta;
+
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_template_common *
+tcf_meta_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+	    struct p4tc_nl_pname *nl_pname, u32 *ids,
+	    struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], m_id = ids[P4TC_MID_IDX];
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_metadata *meta;
+
+	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
+						    extack);
+	if (IS_ERR(pipeline))
+		return (void *)pipeline;
+
+	if (n->nlmsg_flags & NLM_F_REPLACE)
+		meta = tcf_meta_update(n, nla, m_id, pipeline, extack);
+	else
+		meta = tcf_meta_create(n, nla, m_id, pipeline, extack);
+
+	if (IS_ERR(meta))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+out:
+	return (struct p4tc_template_common *)meta;
+}
+
+static int _tcf_meta_fill_nlmsg(struct sk_buff *skb,
+				const struct p4tc_metadata *meta)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_meta_size_params sz_params;
+	struct nlattr *nest;
+
+	if (nla_put_u32(skb, P4TC_PATH, meta->m_id))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+
+	sz_params.datatype = meta->m_datatype;
+	sz_params.startbit = meta->m_startbit;
+	sz_params.endbit = meta->m_endbit;
+
+	if (nla_put_string(skb, P4TC_META_NAME, meta->common.name))
+		goto out_nlmsg_trim;
+	if (nla_put(skb, P4TC_META_SIZE, sizeof(sz_params), &sz_params))
+		goto out_nlmsg_trim;
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
+static int tcf_meta_fill_nlmsg(struct net *net, struct sk_buff *skb,
+			       struct p4tc_template_common *template,
+			       struct netlink_ext_ack *extack)
+{
+	const struct p4tc_metadata *meta = to_meta(template);
+
+	if (_tcf_meta_fill_nlmsg(skb, meta) <= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for metadatum");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int tcf_meta_flush(struct sk_buff *skb, struct p4tc_pipeline *pipeline,
+			  struct netlink_ext_ack *extack)
+{
+	struct p4tc_metadata *meta;
+	unsigned long tmp, m_id;
+	unsigned char *b = nlmsg_get_pos(skb);
+	int ret = 0;
+	int i = 0;
+
+	if (nla_put_u32(skb, P4TC_PATH, 0))
+		goto out_nlmsg_trim;
+
+	if (idr_is_empty(&pipeline->p_meta_idr)) {
+		NL_SET_ERR_MSG(extack, "There is not metadata to flush");
+		ret = 0;
+		goto out_nlmsg_trim;
+	}
+
+	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id) {
+		if (_tcf_meta_put(pipeline, meta, false, extack) < 0) {
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
+			NL_SET_ERR_MSG(extack, "Unable to flush any metadata");
+			goto out_nlmsg_trim;
+		} else {
+			NL_SET_ERR_MSG(extack, "Unable to flush all metadata");
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
+static int tcf_meta_gd(struct net *net, struct sk_buff *skb, struct nlmsghdr *n,
+		       struct nlattr *nla, struct p4tc_nl_pname *nl_pname,
+		       u32 *ids, struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], m_id = ids[P4TC_MID_IDX];
+	struct nlattr *tb[P4TC_META_MAX + 1] = {};
+	unsigned char *b = nlmsg_get_pos(skb);
+	int ret = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_metadata *meta;
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
+		ret = nla_parse_nested(tb, P4TC_META_MAX, nla, p4tc_meta_policy,
+				       extack);
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
+		return tcf_meta_flush(skb, pipeline, extack);
+
+	meta = tcf_meta_find_byanyattr(pipeline, tb[P4TC_META_NAME], m_id,
+				       extack);
+	if (IS_ERR(meta))
+		return PTR_ERR(meta);
+
+	if (_tcf_meta_fill_nlmsg(skb, meta) < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for metadatum");
+		return -EINVAL;
+	}
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = _tcf_meta_put(pipeline, meta, false, extack);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to delete referenced metadatum");
+			goto out_nlmsg_trim;
+		}
+	}
+
+	return ret;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_meta_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			 struct nlattr *nla, char **p_name, u32 *ids,
+			 struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	const u32 pipeid = ids[P4TC_PID_IDX];
+	struct net *net = sock_net(skb->sk);
+	unsigned long m_id = 0;
+	int i = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_metadata *meta;
+	unsigned long tmp;
+
+	if (!ctx->ids[P4TC_PID_IDX]) {
+		pipeline =
+			tcf_pipeline_find_byany(net, *p_name, pipeid, extack);
+		if (IS_ERR(pipeline))
+			return PTR_ERR(pipeline);
+		ctx->ids[P4TC_PID_IDX] = pipeline->common.p_id;
+	} else {
+		pipeline = tcf_pipeline_find_byid(net, ctx->ids[P4TC_PID_IDX]);
+	}
+
+	m_id = ctx->ids[P4TC_MID_IDX];
+
+	idr_for_each_entry_continue_ul(&pipeline->p_meta_idr, meta, tmp, m_id) {
+		struct nlattr *count, *param;
+
+		if (i == P4TC_MSGBATCH_SIZE)
+			break;
+
+		count = nla_nest_start(skb, i + 1);
+		if (!count)
+			goto out_nlmsg_trim;
+
+		param = nla_nest_start(skb, P4TC_PARAMS);
+		if (!param)
+			goto out_nlmsg_trim;
+		if (nla_put_string(skb, P4TC_META_NAME, meta->common.name))
+			goto out_nlmsg_trim;
+
+		nla_nest_end(skb, param);
+		nla_nest_end(skb, count);
+
+		i++;
+	}
+
+	if (i == 0) {
+		if (!ctx->ids[P4TC_MID_IDX])
+			NL_SET_ERR_MSG(extack, "There is no metadata to dump");
+		return 0;
+	}
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!(*p_name))
+		*p_name = pipeline->common.name;
+
+	ctx->ids[P4TC_MID_IDX] = m_id;
+
+	return skb->len;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -ENOMEM;
+}
+
+static int __p4tc_register_kmeta(struct p4tc_pipeline *pipeline, u32 m_id,
+				 const char *m_name, u8 startbit, u8 endbit,
+				 bool read_only, u32 datatype)
+{
+	struct p4tc_meta_size_params sz_params = {
+		.startbit = startbit,
+		.endbit = endbit,
+		.datatype = datatype,
+	};
+	struct p4tc_metadata *meta;
+
+	meta = __tcf_meta_create(pipeline, m_id, m_name, &sz_params, GFP_ATOMIC,
+				 read_only, NULL);
+	if (IS_ERR(meta)) {
+		pr_err("Failed to register metadata %s %ld\n", m_name,
+		       PTR_ERR(meta));
+		return PTR_ERR(meta);
+	}
+
+	pr_debug("Registered kernel metadata %s with id %u\n", m_name, m_id);
+
+	return 0;
+}
+
+#define p4tc_register_kmeta(...)                            \
+	do {                                                \
+		if (__p4tc_register_kmeta(__VA_ARGS__) < 0) \
+			return;                             \
+	} while (0)
+
+void tcf_meta_init(struct p4tc_pipeline *root_pipe)
+{
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PKTLEN, "pktlen", 0, 31,
+			    false, P4T_U32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_DATALEN, "datalen", 0,
+			    31, false, P4T_U32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_SKBMARK, "skbmark", 0,
+			    31, false, P4T_U32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_TCINDEX, "tcindex", 0,
+			    15, false, P4T_U16);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_SKBHASH, "skbhash", 0,
+			    31, false, P4T_U32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_SKBPRIO, "skbprio", 0,
+			    31, false, P4T_U32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_IFINDEX, "ifindex", 0,
+			    31, false, P4T_S32);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_SKBIIF, "iif", 0, 31,
+			    true, P4T_DEV);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PROTOCOL, "skbproto", 0,
+			    15, false, P4T_BE16);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PTYPEOFF, "ptypeoff", 0,
+			    7, false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_CLONEOFF, "cloneoff", 0,
+			    7, false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PTCLNOFF, "ptclnoff", 0,
+			    15, false, P4T_U16);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_QMAP, "skbqmap", 0, 15,
+			    false, P4T_U16);
+
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PKTYPE, "skbptype", 0,
+			    2, false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_IDF, "skbidf", 3, 3,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_IPSUM, "skbipsum", 5, 6,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_OOOK, "skboook", 7, 7,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_FCLONE, "fclone", 2, 3,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PEEKED, "skbpeek", 4, 4,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_DIRECTION, "direction",
+			    7, 7, false, P4T_U8);
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PKTYPE, "skbptype", 5,
+			    7, false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_IDF, "skbidf", 4, 4,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_IPSUM, "skbipsum", 1, 2,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_OOOK, "skboook", 0, 0,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_FCLONE, "fclone", 4, 5,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_PEEKED, "skbpeek", 3, 3,
+			    false, P4T_U8);
+
+	p4tc_register_kmeta(root_pipe, P4TC_KERNEL_META_DIRECTION, "direction",
+			    0, 0, false, P4T_U8);
+#else
+#error "Please fix <asm/byteorder.h>"
+#endif
+}
+
+const struct p4tc_template_ops p4tc_meta_ops = {
+	.cu = tcf_meta_cu,
+	.fill_nlmsg = tcf_meta_fill_nlmsg,
+	.gd = tcf_meta_gd,
+	.put = tcf_meta_put,
+	.dump = tcf_meta_dump,
+};
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index 776a8d37b615..56b4f7be8d17 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -80,6 +80,8 @@ static const struct nla_policy tc_pipeline_policy[P4TC_PIPELINE_MAX + 1] = {
 static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
 				 bool free_pipeline)
 {
+	idr_destroy(&pipeline->p_meta_idr);
+
 	if (free_pipeline)
 		kfree(pipeline);
 }
@@ -104,6 +106,8 @@ static int tcf_pipeline_put(struct net *net,
 	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
 	struct p4tc_pipeline *pipeline = to_pipeline(template);
 	struct net *pipeline_net = maybe_get_net(net);
+	struct p4tc_metadata *meta;
+	unsigned long m_id, tmp;
 
 	if (pipeline_net && !refcount_dec_if_one(&pipeline->p_ref)) {
 		NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
@@ -112,6 +116,9 @@ static int tcf_pipeline_put(struct net *net,
 
 	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
 
+	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
+		meta->common.ops->put(net, &meta->common, true, extack);
+
 	/* XXX: The action fields are only accessed in the control path
 	 * since they will be copied to the filter, where the data path
 	 * will use them. So there is no need to free them in the rcu
@@ -154,11 +161,6 @@ static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 	return true;
 }
 
-static inline bool pipeline_sealed(struct p4tc_pipeline *pipeline)
-{
-	return pipeline->p_state == P4TC_STATE_READY;
-}
-
 static int p4tc_action_init(struct net *net, struct nlattr *nla,
 			    struct tc_action *acts[], u32 pipeid, u32 flags,
 			    struct netlink_ext_ack *extack)
@@ -317,6 +319,9 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 		pipeline->num_postacts = 0;
 	}
 
+	idr_init(&pipeline->p_meta_idr);
+	pipeline->p_meta_offset = 0;
+
 	pipeline->p_state = P4TC_STATE_NOT_READY;
 
 	pipeline->net = net;
@@ -510,6 +515,7 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 		ret = pipeline_try_set_state_ready(pipeline, extack);
 		if (ret < 0)
 			goto postactions_destroy;
+		tcf_meta_fill_user_offsets(pipeline);
 	}
 
 	if (max_rules)
@@ -726,12 +732,16 @@ static void __tcf_pipeline_init(void)
 
 	strscpy(root_pipeline->common.name, "kernel", PIPELINENAMSIZ);
 
+	idr_init(&root_pipeline->p_meta_idr);
+
 	root_pipeline->common.ops =
 		(struct p4tc_template_ops *)&p4tc_pipeline_ops;
 
 	root_pipeline->common.p_id = pipeid;
 
 	root_pipeline->p_state = P4TC_STATE_READY;
+
+	tcf_meta_init(root_pipeline);
 }
 
 static void tcf_pipeline_init(void)
@@ -745,6 +755,9 @@ static void tcf_pipeline_init(void)
 	__tcf_pipeline_init();
 }
 
+DEFINE_PER_CPU(struct p4tc_percpu_scratchpad, p4tc_percpu_scratchpad);
+EXPORT_PER_CPU_SYMBOL_GPL(p4tc_percpu_scratchpad);
+
 const struct p4tc_template_ops p4tc_pipeline_ops = {
 	.init = tcf_pipeline_init,
 	.cu = tcf_pipeline_cu,
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index a936ec84841d..19dd6f41a3a4 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -42,6 +42,7 @@ static bool obj_is_valid(u32 obj)
 {
 	switch (obj) {
 	case P4TC_OBJ_PIPELINE:
+	case P4TC_OBJ_META:
 		return true;
 	default:
 		return false;
@@ -50,6 +51,7 @@ static bool obj_is_valid(u32 obj)
 
 static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
+	[P4TC_OBJ_META] = &p4tc_meta_ops,
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
@@ -124,6 +126,12 @@ static int tc_ctl_p4_tmpl_gd_1(struct net *net, struct sk_buff *skb,
 
 	ids[P4TC_PID_IDX] = t->pipeid;
 
+	if (tb[P4TC_PATH]) {
+		const u32 *arg_ids = nla_data(tb[P4TC_PATH]);
+
+		memcpy(&ids[P4TC_MID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
+	}
+
 	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
 
 	ret = op->gd(net, skb, n, tb[P4TC_PARAMS], nl_pname, ids, extack);
@@ -300,6 +308,12 @@ tcf_p4_tmpl_cu_1(struct sk_buff *skb, struct net *net, struct nlmsghdr *n,
 
 	ids[P4TC_PID_IDX] = t->pipeid;
 
+	if (tb[P4TC_PATH]) {
+		const u32 *arg_ids = nla_data(tb[P4TC_PATH]);
+
+		memcpy(&ids[P4TC_MID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
+	}
+
 	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
 	tmpl = op->cu(net, n, tb[P4TC_PARAMS], nl_pname, ids, extack);
 	if (IS_ERR(tmpl))
@@ -486,6 +500,11 @@ static int tc_ctl_p4_tmpl_dump_1(struct sk_buff *skb, struct nlattr *arg,
 	root = nla_nest_start(skb, P4TC_ROOT);
 
 	ids[P4TC_PID_IDX] = t->pipeid;
+	if (tb[P4TC_PATH]) {
+		const u32 *arg_ids = nla_data(tb[P4TC_PATH]);
+
+		memcpy(&ids[P4TC_MID_IDX], arg_ids, nla_len(tb[P4TC_PATH]));
+	}
 
 	op = (struct p4tc_template_ops *)p4tc_ops[t->obj];
 	ret = op->dump(skb, ctx, tb[P4TC_PARAMS], &p_name, ids, extack);
-- 
2.25.1


