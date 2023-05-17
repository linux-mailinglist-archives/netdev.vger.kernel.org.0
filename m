Return-Path: <netdev+bounces-3295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B15B706629
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC1A6281723
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:07:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 304AA200BA;
	Wed, 17 May 2023 11:04:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEF200AF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:26 +0000 (UTC)
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67202213B
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:58 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-ba82059eec9so838871276.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321437; x=1686913437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3ZBqqa1ZEDZMlqU6RJOcdpv4AzGFV4O0mpFRkpUOxGY=;
        b=x0jRA80z9MFP1g7lopoSHN7tHgqRy9BOWh5Cl1lzP41kfQsYhO4lbV2P7aJdu+VHBC
         lR4yY8tYNuQcV1co81L3nxSqEG5iQtKttBqZ1OHIuG+7az9meZzhVlR5V9/a7gup2Yc2
         lH9CtvnaUIsbMUU2ZdaLBDEaITxXBWNHerfD/rXYPXupU7ggWCCk2dySnXVB3VUyLK4Y
         sMlPjQC9Few9TOjFCl7/zYCXHJt7zyTtsP+nm51jGolwaGNwd37h/9EPjawIbZB83w6Z
         2B9whpL2KiofGG4bYyvZp6hpnvp9+B283vh4JIduwPBOrpL/JDTis25upzxA9Pps3G/O
         AUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321437; x=1686913437;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3ZBqqa1ZEDZMlqU6RJOcdpv4AzGFV4O0mpFRkpUOxGY=;
        b=kbSHt7t/jKKuiuPIYwNg+jAvIp5Rt1w94VvXVwO3jRJlLhLk4BDRKFqkU/pL3HlML0
         GFoqRzmvayy+0nklskpYMdqshnXgtYkg/i8WxKaw+plmbvbVXSqNjOGpoB7Gl73qOAM6
         V3pGGtQCHvubzjNwbTD65primkKTPIKlEI0z0ZY6+B+Yv2JFDN54Gd0mkbR2+Kd/Bato
         teDzrr6qPUuV2TF5yd8WjJ9TFd40zaIJONkoOuDW+eZG1J7VZx0bK0+LYYpuUiF7ldwO
         GiCitI/atwN1Fa8OpKbx4L1PFpI/VTzV/aSIim42+XiL842sYOhhWe+107R57NTvxdGq
         wAgA==
X-Gm-Message-State: AC+VfDwUDP1iu1lwnyXlcXBqU3bhN8jWXPNMfaE1EMODXD+ebqBtYLOt
	Z9k1JingaXQ9MsxiUUFM2FefXb/8cy5yEIbZs18=
X-Google-Smtp-Source: ACHHUZ5w/7DHbH8iLZQi5SeZrUFD1XUz2270s+L+5Czqx4R82/rKJbl1ez/FYtQqbu5R6K1AkyfBqQ==
X-Received: by 2002:a25:31d4:0:b0:ba8:6499:c19a with SMTP id x203-20020a2531d4000000b00ba86499c19amr713722ybx.13.1684321436657;
        Wed, 17 May 2023 04:03:56 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id p7-20020a05620a112700b007579371d70esm532679qkk.46.2023.05.17.04.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:03:56 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 12/28] p4tc: add header field create, get, delete, flush and dump
Date: Wed, 17 May 2023 07:02:16 -0400
Message-Id: <20230517110232.29349-12-jhs@mojatatu.com>
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

This commit allows control to create, get, delete, flush and dump header
field objects. The created header fields are retrieved at runtime by
the parser. From a control plane interaction, a header field can only be
created once the appropriate parser is instantiated. At runtime, existing
header fields can be referenced for computation reasons from metact:
metact will use header fields to either create lookup keys or edit the
header fields.

Header fields are part of a pipeline and a parser instance and header
fields can only be created in an unsealed pipeline.

To create a header field, the user must issue the equivalent of the
following command:

tc p4template create hdrfield/myprog/myparser/ipv4/dstAddr hdrfieldid 4 \
 type ipv4

where myprog is the name of a pipeline, myparser is a name of a parser
instance, ipv4/dstAddr is the name of header field which is of type ipv4.

To delete a header field, the user must issue the equivalent of the
following command:

tc p4template delete hdrfield/myprog/myparser/ipv4/dstAddr

where myprog is the name of pipeline, myparser is a name of a parser
instance, ipv4/dstAddr is the name of header field to be deleted.

To retrieve meta-information from a header field, such as length,
position and type, the user must issue the equivalent of the following
command:

tc p4template get hdrfield/myprog/myparser/ipv4/dstAddr

where myprog is the name of pipeline, myparser is a name of a parser
instance, ipv4/dstAddr is the name of header field to be deleted.

The user can also dump all the header fields available in a parser
instance using the equivalent of the following command:

tc p4template get hdrfield/myprog/myparser/

With that, the user will get all the header field names available in a
specific parser instance.

The user can also flush all the header fields available in a parser
instance using the equivalent of the following command:

tc p4template del hdrfield/myprog/myparser/

Header fields do not support update operations.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h               |  54 +++
 include/uapi/linux/p4tc.h        |  19 +
 net/sched/p4tc/Makefile          |   3 +-
 net/sched/p4tc/p4tc_hdrfield.c   | 616 +++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_parser_api.c | 146 ++++++++
 net/sched/p4tc/p4tc_pipeline.c   |   4 +
 net/sched/p4tc/p4tc_tmpl_api.c   |   2 +
 7 files changed, 843 insertions(+), 1 deletion(-)
 create mode 100644 net/sched/p4tc/p4tc_hdrfield.c
 create mode 100644 net/sched/p4tc/p4tc_parser_api.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 6e3c4681c1d6..096f52c4320e 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -19,6 +19,10 @@
 
 #define P4TC_PID_IDX 0
 #define P4TC_MID_IDX 1
+#define P4TC_PARSEID_IDX 1
+#define P4TC_HDRFIELDID_IDX 2
+
+#define P4TC_HDRFIELD_IS_VALIDITY_BIT 0x1
 
 struct p4tc_percpu_scratchpad {
 	u32 keysz;
@@ -93,6 +97,7 @@ struct p4tc_pipeline {
 	struct idr                  p_meta_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
+	struct p4tc_parser          *parser;
 	struct tc_action            **preacts;
 	int                         num_preacts;
 	struct tc_action            **postacts;
@@ -160,6 +165,27 @@ struct p4tc_metadata {
 
 extern const struct p4tc_template_ops p4tc_meta_ops;
 
+struct p4tc_parser {
+	char parser_name[PARSERNAMSIZ];
+	struct idr hdr_fields_idr;
+	refcount_t parser_ref;
+	u32 parser_inst_id;
+};
+
+struct p4tc_hdrfield {
+	struct p4tc_template_common common;
+	struct p4tc_parser          *parser;
+	u32                         parser_inst_id;
+	u32                         hdrfield_id;
+	refcount_t                  hdrfield_ref;
+	u16                         startbit;
+	u16                         endbit;
+	u8                          datatype; /* T_XXX */
+	u8                          flags;  /* P4TC_HDRFIELD_FLAGS_* */
+};
+
+extern const struct p4tc_template_ops p4tc_hdrfield_ops;
+
 struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
 					 u32 m_id);
 void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
@@ -169,7 +195,35 @@ struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
 				   struct netlink_ext_ack *extack);
 void tcf_meta_put_ref(struct p4tc_metadata *meta);
 
+struct p4tc_parser *tcf_parser_create(struct p4tc_pipeline *pipeline,
+				      const char *parser_name,
+				      u32 parser_inst_id,
+				      struct netlink_ext_ack *extack);
+
+struct p4tc_parser *tcf_parser_find_byid(struct p4tc_pipeline *pipeline,
+					 const u32 parser_inst_id);
+struct p4tc_parser *tcf_parser_find_byany(struct p4tc_pipeline *pipeline,
+					  const char *parser_name,
+					  u32 parser_inst_id,
+					  struct netlink_ext_ack *extack);
+int tcf_parser_del(struct net *net, struct p4tc_pipeline *pipeline,
+		   struct p4tc_parser *parser, struct netlink_ext_ack *extack);
+
+struct p4tc_hdrfield *tcf_hdrfield_find_byid(struct p4tc_parser *parser,
+					     const u32 hdrfield_id);
+struct p4tc_hdrfield *tcf_hdrfield_find_byany(struct p4tc_parser *parser,
+					      const char *hdrfield_name,
+					      u32 hdrfield_id,
+					      struct netlink_ext_ack *extack);
+void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield);
+struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
+				       const char *hdrfield_name,
+				       u32 hdrfield_id,
+				       struct netlink_ext_ack *extack);
+void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield);
+
 #define to_pipeline(t) ((struct p4tc_pipeline *)t)
 #define to_meta(t) ((struct p4tc_metadata *)t)
+#define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
 
 #endif
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 8934c032dc87..72714df9e74f 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -27,6 +27,8 @@ struct p4tcmsg {
 #define TEMPLATENAMSZ 256
 #define PIPELINENAMSIZ TEMPLATENAMSZ
 #define METANAMSIZ TEMPLATENAMSZ
+#define PARSERNAMSIZ TEMPLATENAMSZ
+#define HDRFIELDNAMSIZ TEMPLATENAMSZ
 
 /* Root attributes */
 enum {
@@ -55,6 +57,7 @@ enum {
 	P4TC_OBJ_UNSPEC,
 	P4TC_OBJ_PIPELINE,
 	P4TC_OBJ_META,
+	P4TC_OBJ_HDR_FIELD,
 	__P4TC_OBJ_MAX,
 };
 #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
@@ -153,6 +156,22 @@ enum {
 };
 #define P4TC_KERNEL_META_MAX (__P4TC_KERNEL_META_MAX - 1)
 
+struct p4tc_hdrfield_ty {
+	__u16 startbit;
+	__u16 endbit;
+	__u8  datatype; /* P4T_* */
+};
+
+/* Header field attributes */
+enum {
+	P4TC_HDRFIELD_UNSPEC,
+	P4TC_HDRFIELD_DATA,
+	P4TC_HDRFIELD_NAME,
+	P4TC_HDRFIELD_PARSER_NAME,
+	__P4TC_HDRFIELD_MAX
+};
+#define P4TC_HDRFIELD_MAX (__P4TC_HDRFIELD_MAX - 1)
+
 #define P4TC_RTA(r) \
 	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
 
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index d523e668cbe5..add22c909be6 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-y := p4tc_types.o p4tc_tmpl_api.o p4tc_pipeline.o p4tc_meta.o
+obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
+	p4tc_parser_api.o p4tc_hdrfield.o
diff --git a/net/sched/p4tc/p4tc_hdrfield.c b/net/sched/p4tc/p4tc_hdrfield.c
new file mode 100644
index 000000000000..d5dd9b5c885d
--- /dev/null
+++ b/net/sched/p4tc/p4tc_hdrfield.c
@@ -0,0 +1,616 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_hdrfield.c	P4 TC HEADER FIELD
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
+#include <linux/err.h>
+#include <linux/module.h>
+#include <net/net_namespace.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/netlink.h>
+#include <net/p4tc_types.h>
+#include <net/sock.h>
+
+static const struct nla_policy tc_hdrfield_policy[P4TC_HDRFIELD_MAX + 1] = {
+	[P4TC_HDRFIELD_DATA] = { .type = NLA_BINARY,
+				 .len = sizeof(struct p4tc_hdrfield_ty) },
+	[P4TC_HDRFIELD_NAME] = { .type = NLA_STRING, .len = HDRFIELDNAMSIZ },
+	[P4TC_HDRFIELD_PARSER_NAME] = { .type = NLA_STRING,
+					.len = PARSERNAMSIZ },
+};
+
+static int _tcf_hdrfield_put(struct p4tc_pipeline *pipeline,
+			     struct p4tc_parser *parser,
+			     struct p4tc_hdrfield *hdrfield,
+			     bool unconditional_purge,
+			     struct netlink_ext_ack *extack)
+{
+	if (!refcount_dec_if_one(&hdrfield->hdrfield_ref) &&
+	    !unconditional_purge) {
+		NL_SET_ERR_MSG(extack,
+			       "Unable to delete referenced header field");
+		return -EBUSY;
+	}
+	idr_remove(&parser->hdr_fields_idr, hdrfield->hdrfield_id);
+
+	WARN_ON(!refcount_dec_not_one(&parser->parser_ref));
+	kfree(hdrfield);
+
+	return 0;
+}
+
+static int tcf_hdrfield_put(struct net *net, struct p4tc_template_common *tmpl,
+			    bool unconditional_purge,
+			    struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_parser *parser;
+
+	pipeline = tcf_pipeline_find_byid(net, tmpl->p_id);
+
+	hdrfield = to_hdrfield(tmpl);
+	parser = pipeline->parser;
+
+	return _tcf_hdrfield_put(pipeline, parser, hdrfield,
+				 unconditional_purge, extack);
+}
+
+static struct p4tc_hdrfield *hdrfield_find_name(struct p4tc_parser *parser,
+						const char *hdrfield_name)
+{
+	struct p4tc_hdrfield *hdrfield;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, id)
+		if (hdrfield->common.name[0] &&
+		    strncmp(hdrfield->common.name, hdrfield_name,
+			    HDRFIELDNAMSIZ) == 0)
+			return hdrfield;
+
+	return NULL;
+}
+
+struct p4tc_hdrfield *tcf_hdrfield_find_byid(struct p4tc_parser *parser,
+					     const u32 hdrfield_id)
+{
+	return idr_find(&parser->hdr_fields_idr, hdrfield_id);
+}
+
+struct p4tc_hdrfield *tcf_hdrfield_find_byany(struct p4tc_parser *parser,
+					      const char *hdrfield_name,
+					      u32 hdrfield_id,
+					      struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield;
+	int err;
+
+	if (hdrfield_id) {
+		hdrfield = tcf_hdrfield_find_byid(parser, hdrfield_id);
+		if (!hdrfield) {
+			NL_SET_ERR_MSG(extack, "Unable to find hdrfield by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (hdrfield_name) {
+			hdrfield = hdrfield_find_name(parser, hdrfield_name);
+			if (!hdrfield) {
+				NL_SET_ERR_MSG(extack,
+					       "Header field name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Must specify hdrfield name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return hdrfield;
+
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
+				       const char *hdrfield_name,
+				       u32 hdrfield_id,
+				       struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield;
+
+	hdrfield = tcf_hdrfield_find_byany(parser, hdrfield_name, hdrfield_id,
+					   extack);
+	if (IS_ERR(hdrfield))
+		return hdrfield;
+
+	/* Should never happen */
+	WARN_ON(!refcount_inc_not_zero(&hdrfield->hdrfield_ref));
+
+	return hdrfield;
+}
+
+void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield)
+{
+	WARN_ON(!refcount_dec_not_one(&hdrfield->hdrfield_ref));
+}
+
+static struct p4tc_hdrfield *
+tcf_hdrfield_find_byanyattr(struct p4tc_parser *parser,
+			    struct nlattr *name_attr, u32 hdrfield_id,
+			    struct netlink_ext_ack *extack)
+{
+	char *hdrfield_name = NULL;
+
+	if (name_attr)
+		hdrfield_name = nla_data(name_attr);
+
+	return tcf_hdrfield_find_byany(parser, hdrfield_name, hdrfield_id,
+				       extack);
+}
+
+void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield)
+{
+	size_t hdr_offset_len = sizeof(u16);
+	struct p4tc_percpu_scratchpad *pad;
+	u16 *hdr_offset_bits, hdr_offset;
+	u16 hdr_offset_index;
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+
+	hdr_offset_index = (hdrfield->hdrfield_id - 1) * hdr_offset_len;
+	if (hdrfield->flags & P4TC_HDRFIELD_IS_VALIDITY_BIT)
+		return &pad->hdrs[hdr_offset_index];
+
+	hdr_offset_bits = (u16 *)&pad->hdrs[hdr_offset_index];
+	hdr_offset = BITS_TO_BYTES(*hdr_offset_bits);
+
+	return skb_mac_header(skb) + hdr_offset;
+}
+
+static struct p4tc_hdrfield *tcf_hdrfield_create(struct nlmsghdr *n,
+						 struct nlattr *nla,
+						 struct p4tc_pipeline *pipeline,
+						 u32 *ids,
+						 struct netlink_ext_ack *extack)
+{
+	u32 parser_id = ids[P4TC_PARSEID_IDX];
+	char *hdrfield_name = NULL;
+	const char *parser_name = NULL;
+	u32 hdrfield_id = 0;
+	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1];
+	struct p4tc_hdrfield_ty *hdr_arg;
+	struct p4tc_hdrfield *hdrfield;
+	struct p4tc_parser *parser;
+	char *s;
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla, tc_hdrfield_policy,
+			       extack);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	hdrfield_id = ids[P4TC_HDRFIELDID_IDX];
+	if (!hdrfield_id) {
+		NL_SET_ERR_MSG(extack, "Must specify header field id");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, nla, tb, P4TC_HDRFIELD_DATA)) {
+		NL_SET_ERR_MSG(extack, "Must supply header field data");
+		return ERR_PTR(-EINVAL);
+	}
+	hdr_arg = nla_data(tb[P4TC_HDRFIELD_DATA]);
+
+	if (tb[P4TC_HDRFIELD_PARSER_NAME])
+		parser_name = nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]);
+
+	rcu_read_lock();
+	parser = tcf_parser_find_byany(pipeline, parser_name, parser_id, NULL);
+	if (IS_ERR(parser)) {
+		rcu_read_unlock();
+		if (!parser_name) {
+			NL_SET_ERR_MSG(extack, "Must supply parser name");
+			return ERR_PTR(-EINVAL);
+		}
+
+		/* If the parser instance wasn't created, let's create it here */
+		parser = tcf_parser_create(pipeline, parser_name, parser_id,
+					   extack);
+
+		if (IS_ERR(parser))
+			return (void *)parser;
+		rcu_read_lock();
+	}
+
+	if (!refcount_inc_not_zero(&parser->parser_ref)) {
+		NL_SET_ERR_MSG(extack, "Parser is stale");
+		rcu_read_unlock();
+		return ERR_PTR(-EBUSY);
+	}
+	rcu_read_unlock();
+
+	if (tb[P4TC_HDRFIELD_NAME])
+		hdrfield_name = nla_data(tb[P4TC_HDRFIELD_NAME]);
+
+	if ((hdrfield_name && hdrfield_find_name(parser, hdrfield_name)) ||
+	    tcf_hdrfield_find_byid(parser, hdrfield_id)) {
+		NL_SET_ERR_MSG(extack,
+			       "Header field with same id or name was already inserted");
+		ret = -EEXIST;
+		goto refcount_dec_parser;
+	}
+
+	if (hdr_arg->startbit > hdr_arg->endbit) {
+		NL_SET_ERR_MSG(extack, "Header field startbit > endbit");
+		ret = -EINVAL;
+		goto refcount_dec_parser;
+	}
+
+	hdrfield = kzalloc(sizeof(*hdrfield), GFP_KERNEL);
+	if (!hdrfield) {
+		NL_SET_ERR_MSG(extack, "Failed to allocate hdrfield");
+		ret = -ENOMEM;
+		goto refcount_dec_parser;
+	}
+
+	hdrfield->hdrfield_id = hdrfield_id;
+
+	s = strnchr(hdrfield_name, HDRFIELDNAMSIZ, '/');
+	if (s++ && strncmp(s, "isValid", HDRFIELDNAMSIZ) == 0) {
+		if (hdr_arg->datatype != P4T_U8 || hdr_arg->startbit != 0 ||
+		    hdr_arg->endbit != 0) {
+			NL_SET_ERR_MSG(extack,
+				       "isValid data type must be bit1");
+			ret = -EINVAL;
+			goto free_hdr;
+		}
+		hdrfield->datatype = hdr_arg->datatype;
+		hdrfield->flags = P4TC_HDRFIELD_IS_VALIDITY_BIT;
+	} else {
+		if (!p4type_find_byid(hdr_arg->datatype)) {
+			NL_SET_ERR_MSG(extack, "Invalid hdrfield data type");
+			ret = -EINVAL;
+			goto free_hdr;
+		}
+		hdrfield->datatype = hdr_arg->datatype;
+	}
+
+	hdrfield->startbit = hdr_arg->startbit;
+	hdrfield->endbit = hdr_arg->endbit;
+	hdrfield->parser_inst_id = parser->parser_inst_id;
+
+	ret = idr_alloc_u32(&parser->hdr_fields_idr, hdrfield, &hdrfield_id,
+			    hdrfield_id, GFP_KERNEL);
+	if (ret < 0) {
+		NL_SET_ERR_MSG(extack, "Unable to allocate ID for hdrfield");
+		goto free_hdr;
+	}
+
+	hdrfield->common.p_id = pipeline->common.p_id;
+	hdrfield->common.ops = (struct p4tc_template_ops *)&p4tc_hdrfield_ops;
+	hdrfield->parser = parser;
+	refcount_set(&hdrfield->hdrfield_ref, 1);
+
+	if (hdrfield_name)
+		strscpy(hdrfield->common.name, hdrfield_name, HDRFIELDNAMSIZ);
+
+	return hdrfield;
+
+free_hdr:
+	kfree(hdrfield);
+
+refcount_dec_parser:
+	WARN_ON(!refcount_dec_not_one(&parser->parser_ref));
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_template_common *
+tcf_hdrfield_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+		struct p4tc_nl_pname *nl_pname, u32 *ids,
+		struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX];
+	struct p4tc_hdrfield *hdrfield;
+	struct p4tc_pipeline *pipeline;
+
+	if (n->nlmsg_flags & NLM_F_REPLACE) {
+		NL_SET_ERR_MSG(extack, "Header field update not supported");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
+	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
+						    extack);
+	if (IS_ERR(pipeline))
+		return (void *)pipeline;
+
+	hdrfield = tcf_hdrfield_create(n, nla, pipeline, ids, extack);
+	if (IS_ERR(hdrfield))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+out:
+	return (struct p4tc_template_common *)hdrfield;
+}
+
+static int _tcf_hdrfield_fill_nlmsg(struct sk_buff *skb,
+				    struct p4tc_hdrfield *hdrfield)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_hdrfield_ty hdr_arg;
+	struct nlattr *nest;
+	/* Parser instance id + header field id */
+	u32 ids[2];
+
+	ids[0] = hdrfield->parser_inst_id;
+	ids[1] = hdrfield->hdrfield_id;
+
+	if (nla_put(skb, P4TC_PATH, sizeof(ids), ids))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+
+	hdr_arg.datatype = hdrfield->datatype;
+	hdr_arg.startbit = hdrfield->startbit;
+	hdr_arg.endbit = hdrfield->endbit;
+
+	if (hdrfield->common.name[0]) {
+		if (nla_put_string(skb, P4TC_HDRFIELD_NAME,
+				   hdrfield->common.name))
+			goto out_nlmsg_trim;
+	}
+
+	if (nla_put(skb, P4TC_HDRFIELD_DATA, sizeof(hdr_arg), &hdr_arg))
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
+static int tcf_hdrfield_fill_nlmsg(struct net *net, struct sk_buff *skb,
+				   struct p4tc_template_common *template,
+				   struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield = to_hdrfield(template);
+
+	if (_tcf_hdrfield_fill_nlmsg(skb, hdrfield) <= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for pipeline");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int tcf_hdrfield_flush(struct sk_buff *skb,
+			      struct p4tc_pipeline *pipeline,
+			      struct p4tc_parser *parser,
+			      struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	int ret = 0;
+	int i = 0;
+	struct p4tc_hdrfield *hdrfield;
+	u32 path[2];
+	unsigned long tmp, hdrfield_id;
+
+	path[0] = parser->parser_inst_id;
+	path[1] = 0;
+
+	if (nla_put(skb, P4TC_PATH, sizeof(path), path))
+		goto out_nlmsg_trim;
+
+	if (idr_is_empty(&parser->hdr_fields_idr)) {
+		NL_SET_ERR_MSG(extack, "There are no header fields to flush");
+		goto out_nlmsg_trim;
+	}
+
+	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, hdrfield_id) {
+		if (_tcf_hdrfield_put(pipeline, parser, hdrfield, false, extack) < 0) {
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
+				       "Unable to flush any table instance");
+			goto out_nlmsg_trim;
+		} else {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to flush all table instances");
+		}
+	}
+
+	return i;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return 0;
+}
+
+static int tcf_hdrfield_gd(struct net *net, struct sk_buff *skb,
+			   struct nlmsghdr *n, struct nlattr *nla,
+			   struct p4tc_nl_pname *nl_pname, u32 *ids,
+			   struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	u32 pipeid = ids[P4TC_PID_IDX];
+	u32 parser_inst_id = ids[P4TC_PARSEID_IDX];
+	u32 hdrfield_id = ids[P4TC_HDRFIELDID_IDX];
+	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1];
+	struct p4tc_hdrfield *hdrfield;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_parser *parser;
+	char *parser_name;
+	int ret;
+
+	pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid, extack);
+	if (IS_ERR(pipeline))
+		return PTR_ERR(pipeline);
+
+	ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla, tc_hdrfield_policy,
+			       extack);
+	if (ret < 0)
+		return ret;
+
+	parser_name = tb[P4TC_HDRFIELD_PARSER_NAME] ?
+		nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]) : NULL;
+
+	parser = tcf_parser_find_byany(pipeline, parser_name, parser_inst_id,
+				       extack);
+	if (IS_ERR(parser))
+		return PTR_ERR(parser);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE && n->nlmsg_flags & NLM_F_ROOT)
+		return tcf_hdrfield_flush(skb, pipeline, parser, extack);
+
+	hdrfield = tcf_hdrfield_find_byanyattr(parser, tb[P4TC_HDRFIELD_NAME],
+					       hdrfield_id, extack);
+	if (IS_ERR(hdrfield))
+		return PTR_ERR(hdrfield);
+
+	ret = _tcf_hdrfield_fill_nlmsg(skb, hdrfield);
+	if (ret < 0)
+		return -ENOMEM;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = _tcf_hdrfield_put(pipeline, parser, hdrfield, false,
+					extack);
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
+static int tcf_hdrfield_dump_1(struct sk_buff *skb,
+			       struct p4tc_template_common *common)
+{
+	struct p4tc_hdrfield *hdrfield = to_hdrfield(common);
+	struct nlattr *param = nla_nest_start(skb, P4TC_PARAMS);
+	unsigned char *b = nlmsg_get_pos(skb);
+	u32 path[2];
+
+	if (!param)
+		goto out_nlmsg_trim;
+
+	if (hdrfield->common.name[0] &&
+	    nla_put_string(skb, P4TC_HDRFIELD_NAME, hdrfield->common.name))
+		goto out_nlmsg_trim;
+
+	nla_nest_end(skb, param);
+
+	path[0] = hdrfield->parser_inst_id;
+	path[1] = hdrfield->hdrfield_id;
+	if (nla_put(skb, P4TC_PATH, sizeof(path), path))
+		goto out_nlmsg_trim;
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -ENOMEM;
+}
+
+static int tcf_hdrfield_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			     struct nlattr *nla, char **p_name, u32 *ids,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_HDRFIELD_MAX + 1] = { NULL };
+	const u32 pipeid = ids[P4TC_PID_IDX];
+	struct net *net = sock_net(skb->sk);
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_parser *parser;
+	int ret;
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
+	if (!ctx->ids[P4TC_PARSEID_IDX]) {
+		if (nla) {
+			ret = nla_parse_nested(tb, P4TC_HDRFIELD_MAX, nla,
+					       tc_hdrfield_policy, extack);
+			if (ret < 0)
+				return ret;
+		}
+
+		parser = tcf_parser_find_byany(pipeline,
+					       nla_data(tb[P4TC_HDRFIELD_PARSER_NAME]),
+					       ids[P4TC_PARSEID_IDX], extack);
+		if (IS_ERR(parser))
+			return PTR_ERR(parser);
+
+		ctx->ids[P4TC_PARSEID_IDX] = parser->parser_inst_id;
+	} else {
+		parser = pipeline->parser;
+	}
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!(*p_name))
+		*p_name = pipeline->common.name;
+
+	return tcf_p4_tmpl_generic_dump(skb, ctx, &parser->hdr_fields_idr,
+					P4TC_HDRFIELDID_IDX, extack);
+}
+
+const struct p4tc_template_ops p4tc_hdrfield_ops = {
+	.init = NULL,
+	.cu = tcf_hdrfield_cu,
+	.fill_nlmsg = tcf_hdrfield_fill_nlmsg,
+	.gd = tcf_hdrfield_gd,
+	.put = tcf_hdrfield_put,
+	.dump = tcf_hdrfield_dump,
+	.dump_1 = tcf_hdrfield_dump_1,
+};
diff --git a/net/sched/p4tc/p4tc_parser_api.c b/net/sched/p4tc/p4tc_parser_api.c
new file mode 100644
index 000000000000..4af715f86aad
--- /dev/null
+++ b/net/sched/p4tc/p4tc_parser_api.c
@@ -0,0 +1,146 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_parser_api.c	P4 TC PARSER API
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
+#include <linux/err.h>
+#include <linux/module.h>
+#include <net/net_namespace.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/netlink.h>
+
+static struct p4tc_parser *parser_find_name(struct p4tc_pipeline *pipeline,
+					    const char *parser_name)
+{
+	if (unlikely(!pipeline->parser))
+		return NULL;
+
+	if (!strncmp(pipeline->parser->parser_name, parser_name, PARSERNAMSIZ))
+		return pipeline->parser;
+
+	return NULL;
+}
+
+struct p4tc_parser *tcf_parser_find_byid(struct p4tc_pipeline *pipeline,
+					 const u32 parser_inst_id)
+{
+	if (unlikely(!pipeline->parser))
+		return NULL;
+
+	if (parser_inst_id == pipeline->parser->parser_inst_id)
+		return pipeline->parser;
+
+	return NULL;
+}
+
+static struct p4tc_parser *__parser_find(struct p4tc_pipeline *pipeline,
+					 const char *parser_name,
+					 u32 parser_inst_id,
+					 struct netlink_ext_ack *extack)
+{
+	struct p4tc_parser *parser;
+	int err;
+
+	if (parser_inst_id) {
+		parser = tcf_parser_find_byid(pipeline, parser_inst_id);
+		if (!parser) {
+			if (extack)
+				NL_SET_ERR_MSG(extack,
+					       "Unable to find parser by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (parser_name) {
+			parser = parser_find_name(pipeline, parser_name);
+			if (!parser) {
+				if (extack)
+					NL_SET_ERR_MSG(extack,
+						       "Parser name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			if (extack)
+				NL_SET_ERR_MSG(extack,
+					       "Must specify parser name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return parser;
+
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_parser *tcf_parser_find_byany(struct p4tc_pipeline *pipeline,
+					  const char *parser_name,
+					  u32 parser_inst_id,
+					  struct netlink_ext_ack *extack)
+{
+	return __parser_find(pipeline, parser_name, parser_inst_id, extack);
+}
+
+struct p4tc_parser *
+tcf_parser_create(struct p4tc_pipeline *pipeline, const char *parser_name,
+		  u32 parser_inst_id, struct netlink_ext_ack *extack)
+{
+	struct p4tc_parser *parser;
+
+	if (pipeline->parser) {
+		NL_SET_ERR_MSG(extack,
+			       "Can only have one parser instance per pipeline");
+		return ERR_PTR(-EEXIST);
+	}
+
+	parser = kzalloc(sizeof(*parser), GFP_KERNEL);
+	if (!parser)
+		return ERR_PTR(-ENOMEM);
+
+	if (parser_inst_id)
+		parser->parser_inst_id = parser_inst_id;
+	else
+		parser->parser_inst_id = 1;
+
+	strscpy(parser->parser_name, parser_name, PARSERNAMSIZ);
+
+	refcount_set(&parser->parser_ref, 1);
+
+	idr_init(&parser->hdr_fields_idr);
+
+	pipeline->parser = parser;
+
+	return parser;
+}
+
+int tcf_parser_del(struct net *net, struct p4tc_pipeline *pipeline,
+		   struct p4tc_parser *parser, struct netlink_ext_ack *extack)
+{
+	struct p4tc_hdrfield *hdrfield;
+	unsigned long hdr_field_id, tmp;
+
+	idr_for_each_entry_ul(&parser->hdr_fields_idr, hdrfield, tmp, hdr_field_id)
+		hdrfield->common.ops->put(net, &hdrfield->common, true, extack);
+
+	idr_destroy(&parser->hdr_fields_idr);
+
+	pipeline->parser = NULL;
+
+	kfree(parser);
+
+	return 0;
+}
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index 56b4f7be8d17..ed924059cb6a 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -115,6 +115,8 @@ static int tcf_pipeline_put(struct net *net,
 	}
 
 	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
+	if (pipeline->parser)
+		tcf_parser_del(net, pipeline, pipeline->parser, extack);
 
 	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
 		meta->common.ops->put(net, &meta->common, true, extack);
@@ -319,6 +321,8 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 		pipeline->num_postacts = 0;
 	}
 
+	pipeline->parser = NULL;
+
 	idr_init(&pipeline->p_meta_idr);
 	pipeline->p_meta_offset = 0;
 
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index 19dd6f41a3a4..7a3f5c0c3af1 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -43,6 +43,7 @@ static bool obj_is_valid(u32 obj)
 	switch (obj) {
 	case P4TC_OBJ_PIPELINE:
 	case P4TC_OBJ_META:
+	case P4TC_OBJ_HDR_FIELD:
 		return true;
 	default:
 		return false;
@@ -52,6 +53,7 @@ static bool obj_is_valid(u32 obj)
 static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
 	[P4TC_OBJ_META] = &p4tc_meta_ops,
+	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
-- 
2.25.1


