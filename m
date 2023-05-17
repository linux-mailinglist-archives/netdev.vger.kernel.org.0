Return-Path: <netdev+bounces-3314-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6169D706654
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:14:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1423228201D
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:14:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB9A24E83;
	Wed, 17 May 2023 11:06:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62361DDDF
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:06:26 +0000 (UTC)
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA066E9A
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:53 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id d75a77b69052e-3f4eb166122so4314301cf.3
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321551; x=1686913551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CVlUpHb2wa6E++t32XHblnni3yJWNs5ljUTavffb/N0=;
        b=sY2+rY9/Dn5ADnHG/jIhMZ12bXxadNsThaypCX/DpU6JqoR+SovgaZIaH8+quioiyu
         LxWtXexECJRni5IUuQzqKi8P6MH9cJvI7l3IgvehSesppTE/QKRxY+yXZN41grgKi13d
         NIpWGeTTusFN37VswQyWeK1UWGdoxEiGOX1qIPxn0jWqcj0tkmCwXgbFootPPSd3Y4NU
         KCkhahSbpLOlXMtP5aVrDmrftZ+94Q3xowUKAeabskAWV9c3H3u02T8iwkoM20SY/7s4
         s+OEsEkmVU1lKazrOcGiQtC2muYFDJz/4tzSUt7DbaoRTA7FHBS5HpPpwgYJLBkloj4D
         9j0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321551; x=1686913551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CVlUpHb2wa6E++t32XHblnni3yJWNs5ljUTavffb/N0=;
        b=D+gKIzyWs9gzE2vLj3Wec0AQ+etdetUAK49m87xCEWj9/Gz6jn63K8ge/nDnRdvBBh
         xyNJwOf7M7T0btuYQz9ZGMZVkqjGNu5yHhYV99tDf+32brpKb/qPSrJIzyGDOru0ztjk
         Cc/ZiFZInrBf5kg0iKnwtbB8GOrKiuGFlO+8Xg7qzmdhUT4uM873InDsf/2DRy4sXgxW
         eelRSDtKYWFPzgMV7eaMtYiUf3xOBemniWNOEuBud+LyIxjsehi3O/5HnqszyNpsTWMN
         +yUpz3kBvhqiA3RpAjsjhsBhzJ1WhcUJm+nrZ5G16af3hAu3fp5A8ztnafz2hB7enfHI
         ywKw==
X-Gm-Message-State: AC+VfDwj+cGKf9q3uByeh3xvbVAsZ3A1+xL0nQQ6ex1mjA2Q5m3Brx4x
	aJfszm8puWNNFHMKLDd/WXDG0p67UQ6PcYHU9xw=
X-Google-Smtp-Source: ACHHUZ77322ucpxFoBuXN/adUgNPEjN5D3fhHZZSGdU/XNFHz/aEYQdCU/IR2NaPB74rHw51eAcYcQ==
X-Received: by 2002:a05:622a:613:b0:3f1:e81f:288 with SMTP id z19-20020a05622a061300b003f1e81f0288mr62207016qta.68.1684321550195;
        Wed, 17 May 2023 04:05:50 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id u6-20020a05622a17c600b003ef189ffa82sm6972867qtk.90.2023.05.17.04.05.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:05:49 -0700 (PDT)
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
Subject: [PATCH RFC v2 net-next 27/28] p4tc: add set of P4TC table lookup kfuncs
Date: Wed, 17 May 2023 07:02:31 -0400
Message-Id: <20230517110232.29349-27-jhs@mojatatu.com>
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

We add an initial set of kfuncs to allow table lookups from eBPF programs.

- bpf_skb_p4tc_tbl_lookup: Used to lookup a table entry from a BPF
program installed in TC. To find the table entry we take in an skb, the
pipeline ID, the table ID, a key and a key size.
We use the skb to get the network namespace structure where all the
pipelines are stored. After that we use the pipeline ID and the table
ID, to find the table. We then use the key to search for the entry.
We return an entry on success and NULL on failure.

- bpf_xdp_p4tc_tbl_lookup: Used to lookup a table entry from a BPF
program installed in XDP. To find the table entry we take in an skb, the
pipeline ID, the table ID, a key and a key size.
We use struct xdp_md to get the network namespace structure where all
the pipelines are stored. After that we use the pipeline ID and the table
ID, to find the table. We then use the key to search for the entry.
We return an entry on success and NULL on failure.

To load the eBPF program that uses the bpf_skb_p4tc_tbl_lookup kfunc into
TC, we issue the following command:

tc filter add dev $P0 ingress protocol any prio 1 p4 pname redirect_srcip \
     action bpf obj $PROGNAME.o section p4prog/tc

To load the eBPF program that uses the bpf_xdp_p4tc_tbl_lookup into XDP,
we first need to load it into XDP using, for example, the ip command:

ip link set $P0 xdp obj $PROGNAME.o section p4prog/xdp verbose

Then we pin it:

bpftool prog pin id $ID pin /tmp/

After that we create the P4 filter and reference the XDP program:

$TC filter add dev $P0 ingress protocol ip prio 1 p4 pname redirect_srcip \
     prog xdp pinned /tmp/xdp_p4prog prog_cookie 22

Note that we also specify a "prog_cookie", which is used to verify
whether the eBPF program has executed or not before we reach the P4
classifier. The eBPF program sets this cookie by using the kfunc
bpf_p4tc_set_cookie.

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/linux/bitops.h         |   1 +
 include/linux/filter.h         |   3 +
 include/net/p4tc.h             |  94 +++++++++++++++++++-
 net/core/filter.c              |  10 +++
 net/sched/Kconfig              |   7 ++
 net/sched/cls_p4.c             |   4 +
 net/sched/p4tc/Makefile        |   8 +-
 net/sched/p4tc/p4tc_action.c   |  90 ++++++++++++++++++-
 net/sched/p4tc/p4tc_bpf.c      |  72 +++++++++++++++
 net/sched/p4tc/p4tc_hdrfield.c |   2 +
 net/sched/p4tc/p4tc_pipeline.c | 135 +++++++++++++++++++++++++++-
 net/sched/p4tc/p4tc_table.c    | 156 ++++++++++++++++++++++++++++++++-
 net/sched/p4tc/p4tc_tbl_api.c  | 115 +++++++++++++++++++++---
 net/sched/p4tc/p4tc_tmpl_api.c |   9 ++
 14 files changed, 682 insertions(+), 24 deletions(-)

diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index 2ba557e067fe..290c2399ad18 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -19,6 +19,7 @@
 #define BITS_TO_LONGS(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
 #define BITS_TO_U64(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u64))
 #define BITS_TO_U32(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u32))
+#define BITS_TO_U16(nr)		__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(u16))
 #define BITS_TO_BYTES(nr)	__KERNEL_DIV_ROUND_UP(nr, BITS_PER_TYPE(char))
 
 extern unsigned int __sw_hweight8(unsigned int w);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index bbce89937fde..ebcc0ac50656 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -577,6 +577,9 @@ typedef unsigned int (*bpf_dispatcher_fn)(const void *ctx,
 					  const struct bpf_insn *insnsi,
 					  unsigned int (*bpf_func)(const void *,
 								   const struct bpf_insn *));
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+extern int is_p4tc_kfunc(const struct bpf_reg_state *reg);
+#endif
 
 static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 					  const void *ctx,
diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 53d519149d09..34e78fd3c183 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -37,11 +37,13 @@
 
 struct p4tc_percpu_scratchpad {
 	u32 prog_cookie;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	u32 keysz;
 	u32 maskid;
 	u8 key[BITS_TO_BYTES(P4TC_MAX_KEYSZ)];
 	u8 hdrs[BITS_TO_BYTES(HEADER_MAX_LEN)];
 	u8 metadata[BITS_TO_BYTES(META_MAX_LEN)];
+#endif
 };
 
 DECLARE_PER_CPU(struct p4tc_percpu_scratchpad, p4tc_percpu_scratchpad);
@@ -105,6 +107,7 @@ struct p4tc_template_common {
 
 extern const struct p4tc_template_ops p4tc_pipeline_ops;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 struct p4tc_act_dep_edge_node {
 	struct list_head head;
 	u32 act_id;
@@ -115,24 +118,31 @@ struct p4tc_act_dep_node {
 	struct list_head head;
 	u32 act_id;
 };
+#endif
 
 struct p4tc_pipeline {
 	struct p4tc_template_common common;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct idr                  p_meta_idr;
+#endif
 	struct idr                  p_act_idr;
 	struct idr                  p_tbl_idr;
 	struct idr                  p_reg_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
 	struct p4tc_parser          *parser;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct tc_action            **preacts;
 	int                         num_preacts;
 	struct tc_action            **postacts;
 	int                         num_postacts;
 	struct list_head            act_dep_graph;
 	struct list_head            act_topological_order;
+#endif
 	u32                         max_rules;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	u32                         p_meta_offset;
+#endif
 	u32                         num_created_acts;
 	refcount_t                  p_ref;
 	refcount_t                  p_ctrl_ref;
@@ -143,8 +153,28 @@ struct p4tc_pipeline {
 	refcount_t                  p_hdrs_used;
 };
 
+#define P4TC_PIPELINE_MAX_ARRAY 32
+
+struct p4tc_table;
+
+struct p4tc_tbl_cache_key {
+	u32 pipeid;
+	u32 tblid;
+};
+
+extern const struct rhashtable_params tbl_cache_ht_params;
+
+int p4tc_tbl_cache_insert(struct net *net, u32 pipeid, struct p4tc_table *table);
+void p4tc_tbl_cache_remove(struct net *net, struct p4tc_table *table);
+struct p4tc_table *p4tc_tbl_cache_lookup(struct net *net, u32 pipeid, u32 tblid);
+
+#define P4TC_TBLS_CACHE_SIZE 32
+
 struct p4tc_pipeline_net {
-	struct idr pipeline_idr;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	struct list_head  tbls_cache[P4TC_TBLS_CACHE_SIZE];
+#endif
+	struct idr        pipeline_idr;
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
@@ -182,6 +212,7 @@ static inline bool pipeline_sealed(struct p4tc_pipeline *pipeline)
 	return pipeline->p_state == P4TC_STATE_READY;
 }
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 void tcf_pipeline_add_dep_edge(struct p4tc_pipeline *pipeline,
 			       struct p4tc_act_dep_edge_node *edge_node,
 			       u32 vertex_id);
@@ -194,7 +225,9 @@ int determine_act_topological_order(struct p4tc_pipeline *pipeline,
 struct p4tc_act;
 void tcf_pipeline_delete_from_dep_graph(struct p4tc_pipeline *pipeline,
 					struct p4tc_act *act);
+#endif
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 struct p4tc_metadata {
 	struct p4tc_template_common common;
 	struct rcu_head             rcu;
@@ -209,6 +242,7 @@ struct p4tc_metadata {
 };
 
 extern const struct p4tc_template_ops p4tc_meta_ops;
+#endif
 
 struct p4tc_table_key {
 	struct tc_action **key_acts;
@@ -224,8 +258,24 @@ struct p4tc_table_key {
 
 #define P4TC_PERMISSIONS_UNINIT (1 << P4TC_PERM_MAX_BIT)
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+#define P4TC_MAX_PARAM_DATA_SIZE 124
+
+struct p4tc_table_entry_act_bpf {
+	u32 act_id;
+	u8 params[P4TC_MAX_PARAM_DATA_SIZE];
+} __packed;
+#endif
+
+struct p4tc_parser_buffer_act_bpf {
+	u16 hdrs[BITS_TO_U16(HEADER_MAX_LEN)];
+};
+
 struct p4tc_table_defact {
 	struct tc_action **default_acts;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	struct p4tc_table_entry_act_bpf *defact_bpf;
+#endif
 	/* Will have 2 5 bits blocks containing CRUDX (Create, read, update,
 	 * delete, execute) permissions for control plane and data plane.
 	 * The first 5 bits are for control and the next five are for data plane.
@@ -242,13 +292,18 @@ struct p4tc_table_perm {
 
 struct p4tc_table {
 	struct p4tc_template_common         common;
+	struct list_head                    tbl_cache_node;
 	struct list_head                    tbl_acts_list;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct p4tc_table_key               *tbl_key;
+#endif
 	struct idr                          tbl_masks_idr;
 	struct ida                          tbl_prio_idr;
 	struct rhltable                     tbl_entries;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct tc_action                    **tbl_preacts;
 	struct tc_action                    **tbl_postacts;
+#endif
 	struct p4tc_table_entry             *tbl_const_entry;
 	struct p4tc_table_defact __rcu      *tbl_default_hitact;
 	struct p4tc_table_defact __rcu      *tbl_default_missact;
@@ -280,7 +335,10 @@ struct p4tc_ipv4_param_value {
 	u32 mask;
 };
 
+
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 #define P4TC_ACT_PARAM_FLAGS_ISDYN BIT(0)
+#endif
 
 struct p4tc_act_param {
 	char            name[ACTPARAMNAMSIZ];
@@ -305,6 +363,7 @@ struct p4tc_act_param_ops {
 	u32 alloc_len;
 };
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 struct p4tc_label_key {
 	char *label;
 	u32 labelsz;
@@ -315,12 +374,15 @@ struct p4tc_label_node {
 	struct p4tc_label_key key;
 	int cmd_offset;
 };
+#endif
 
 struct p4tc_act {
 	struct p4tc_template_common common;
 	struct tc_action_ops        ops;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct rhashtable           *labels;
 	struct list_head            cmd_operations;
+#endif
 	struct tc_action_net        *tn;
 	struct p4tc_pipeline        *pipeline;
 	struct idr                  params_idr;
@@ -345,6 +407,13 @@ void p4tc_label_ht_destroy(void *ptr, void *arg);
 
 extern const struct rhashtable_params entry_hlt_params;
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+struct p4tc_table_entry_act_bpf_params {
+	u32 pipeid;
+	u32 tblid;
+};
+#endif
+
 struct p4tc_table_entry;
 struct p4tc_table_entry_work {
 	struct work_struct   work;
@@ -364,6 +433,9 @@ struct p4tc_table_entry_value {
 	u32                              prio;
 	int                              num_acts;
 	struct tc_action                 **acts;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	struct p4tc_table_entry_act_bpf  *act_bpf;
+#endif
 	refcount_t                       entries_ref;
 	u32                              permissions;
 	struct p4tc_table_entry_tm __rcu *tm;
@@ -395,13 +467,24 @@ static inline void *p4tc_table_entry_value(struct p4tc_table_entry *entry)
 
 extern const struct nla_policy p4tc_root_policy[P4TC_ROOT_MAX + 1];
 extern const struct nla_policy p4tc_policy[P4TC_MAX + 1];
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
 						 struct p4tc_table *table,
 						 u32 keysz);
+#endif
+struct p4tc_table_entry *
+p4tc_table_entry_lookup_direct(struct p4tc_table *table,
+			       struct p4tc_table_entry_key *key);
 int __tcf_table_entry_del(struct p4tc_pipeline *pipeline,
 			  struct p4tc_table *table,
 			  struct p4tc_table_entry_key *key,
 			  struct p4tc_table_entry_mask *mask, u32 prio);
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+struct p4tc_table_entry_act_bpf *
+tcf_table_entry_create_act_bpf(struct tc_action *action,
+			       struct netlink_ext_ack *extack);
+#endif
+int register_p4tc_tbl_bpf(void);
 
 struct p4tc_parser {
 	char parser_name[PARSERNAMSIZ];
@@ -439,6 +522,7 @@ struct p4tc_register {
 
 extern const struct p4tc_template_ops p4tc_register_ops;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
 					 u32 m_id);
 void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
@@ -448,6 +532,7 @@ struct p4tc_metadata *tcf_meta_get(struct p4tc_pipeline *pipeline,
 				   struct netlink_ext_ack *extack);
 void tcf_meta_put_ref(struct p4tc_metadata *meta);
 void *tcf_meta_fetch(struct sk_buff *skb, struct p4tc_metadata *meta);
+#endif
 
 static inline int p4tc_action_init(struct net *net, struct nlattr *nla,
 				   struct tc_action *acts[], u32 pipeid,
@@ -553,12 +638,13 @@ struct p4tc_hdrfield *tcf_hdrfield_find_byany(struct p4tc_parser *parser,
 					      const char *hdrfield_name,
 					      u32 hdrfield_id,
 					      struct netlink_ext_ack *extack);
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield);
+#endif
 struct p4tc_hdrfield *tcf_hdrfield_get(struct p4tc_parser *parser,
 				       const char *hdrfield_name,
 				       u32 hdrfield_id,
 				       struct netlink_ext_ack *extack);
-void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield);
 void tcf_hdrfield_put_ref(struct p4tc_hdrfield *hdrfield);
 
 int p4tc_init_net_ops(struct net *net, unsigned int id);
@@ -595,13 +681,16 @@ struct p4tc_register *tcf_register_find_byany(struct p4tc_pipeline *pipeline,
 void tcf_register_put_rcu(struct rcu_head *head);
 
 #define to_pipeline(t) ((struct p4tc_pipeline *)t)
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 #define to_meta(t) ((struct p4tc_metadata *)t)
+#endif
 #define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
 #define to_act(t) ((struct p4tc_act *)t)
 #define to_table(t) ((struct p4tc_table *)t)
 #define to_register(t) ((struct p4tc_register *)t)
 
 /* P4TC COMMANDS */
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 int p4tc_cmds_parse(struct net *net, struct p4tc_act *act, struct nlattr *nla,
 		    bool ovr, struct netlink_ext_ack *extack);
 int p4tc_cmds_copy(struct p4tc_act *act, struct list_head *new_cmd_operations,
@@ -680,5 +769,6 @@ static inline int __p4tc_cmd_run(struct sk_buff *skb, struct p4tc_cmd_operate *o
 	return op->cmd->run(skb, op, cmd, res);
 }
 #endif
+#endif
 
 #endif
diff --git a/net/core/filter.c b/net/core/filter.c
index d9ce04ca22ce..1bd289c634c9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -8756,6 +8756,11 @@ static int tc_cls_act_btf_struct_access(struct bpf_verifier_log *log,
 {
 	int ret = -EACCES;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+	if (is_p4tc_kfunc(reg))
+		return 0;
+#endif
+
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
 		ret = nfct_btf_struct_access(log, reg, off, size);
@@ -8829,6 +8834,11 @@ static int xdp_btf_struct_access(struct bpf_verifier_log *log,
 {
 	int ret = -EACCES;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+	if (is_p4tc_kfunc(reg))
+		return 0;
+#endif
+
 	mutex_lock(&nf_conn_btf_access_lock);
 	if (nfct_btf_struct_access)
 		ret = nfct_btf_struct_access(log, reg, off, size);
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 43d300ef0f5a..ffd06565c606 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -696,6 +696,13 @@ config NET_P4_TC
 	  The concept of Pipelines, Tables, metadata will be enabled
           with this option.
 
+config NET_P4_TC_KFUNCS
+	bool "P4 TC support for eBPF SW data path"
+	depends on NET_P4_TC
+	select NET_CLS_ACT
+	help
+	  Say Y here if you want to use P4 with eBPF SW data path.
+
 config NET_CLS_ACT
 	bool "Actions"
 	select NET_CLS
diff --git a/net/sched/cls_p4.c b/net/sched/cls_p4.c
index 25e3f0cc7aa8..f068137336f1 100644
--- a/net/sched/cls_p4.c
+++ b/net/sched/cls_p4.c
@@ -46,8 +46,10 @@ static int p4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	bool at_ingress = skb_at_tc_ingress(skb);
 	int rc = TC_ACT_PIPE;
 	struct p4tc_percpu_scratchpad *pad;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct tcf_result p4res = {};
 	struct p4tc_pipeline *pipeline;
+#endif
 
 	if (unlikely(!head)) {
 		pr_err("P4 classifier not found\n");
@@ -85,6 +87,7 @@ static int p4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 	if (rc != TC_ACT_PIPE)
 		goto zero_pad;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	pipeline = head->pipeline;
 	trace_p4_classify(skb, pipeline);
 
@@ -97,6 +100,7 @@ static int p4_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 			     &p4res);
 	if (rc != TC_ACT_PIPE)
 		goto zero_pad;
+#endif
 
 	*res = head->res;
 
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index ac118a79cbf4..9ee62cf3f85b 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -2,6 +2,10 @@
 
 CFLAGS_trace.o := -I$(src)
 
-obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
+obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o \
 	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
-	p4tc_tbl_api.o p4tc_register.o p4tc_cmds.o trace.o
+	p4tc_tbl_api.o p4tc_register.o p4tc_bpf.o trace.o
+
+ifndef CONFIG_NET_P4_TC_KFUNCS
+obj-y += p4tc_meta.o p4tc_cmds.o
+endif
diff --git a/net/sched/p4tc/p4tc_action.c b/net/sched/p4tc/p4tc_action.c
index 8b69842cc3ce..8e08deb30a2f 100644
--- a/net/sched/p4tc/p4tc_action.c
+++ b/net/sched/p4tc/p4tc_action.c
@@ -29,12 +29,14 @@
 #include <net/p4tc.h>
 #include <net/sch_generic.h>
 #include <net/sock.h>
+
 #include <net/tc_act/p4tc.h>
 
 static LIST_HEAD(dynact_list);
 
 #define SEPARATOR "/"
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static u32 label_hash_fn(const void *data, u32 len, u32 seed)
 {
 	const struct p4tc_label_key *key = data;
@@ -73,6 +75,7 @@ const struct rhashtable_params p4tc_label_ht_params = {
 	.key_offset = offsetof(struct p4tc_label_node, key),
 	.automatic_shrinking = true,
 };
+#endif
 
 static void set_param_indices(struct p4tc_act *act)
 {
@@ -131,7 +134,9 @@ static int __tcf_p4_dyna_init(struct net *net, struct nlattr *est,
 		p = to_p4act(*a);
 		p->p_id = pipeline->common.p_id;
 		p->act_id = act->a_id;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 		INIT_LIST_HEAD(&p->cmd_operations);
+#endif
 
 		ret = ACT_P_CREATED;
 	} else {
@@ -160,7 +165,7 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
 {
 	struct tcf_p4act_params *params_old;
 	struct tcf_p4act *p;
-	int err;
+	int err = 0;
 
 	p = to_p4act(*a);
 
@@ -169,6 +174,7 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
 
 	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	err = p4tc_cmds_copy(act, &p->cmd_operations, exists, extack);
 	if (err < 0) {
 		if (exists)
@@ -176,6 +182,7 @@ static int __tcf_p4_dyna_init_set(struct p4tc_act *act, struct tc_action **a,
 
 		return err;
 	}
+#endif
 
 	params_old = rcu_replace_pointer(p->params, params, 1);
 	if (exists)
@@ -375,9 +382,13 @@ static int dev_dump_param_value(struct sk_buff *skb,
 				struct p4tc_act_param *param)
 {
 	struct nlattr *nest;
+	u32 *ifindex;
 	int ret;
 
 	nest = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	ifindex = (u32 *)param->value;
+#else
 	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
 		struct p4tc_cmd_operand *kopnd;
 		struct nlattr *nla_opnd;
@@ -390,13 +401,16 @@ static int dev_dump_param_value(struct sk_buff *skb,
 		}
 		nla_nest_end(skb, nla_opnd);
 	} else {
-		const u32 *ifindex = param->value;
+		ifindex = (u32 *)param->value;
+#endif
 
 		if (nla_put_u32(skb, P4TC_ACT_PARAMS_VALUE_RAW, *ifindex)) {
 			ret = -EINVAL;
 			goto out_nla_cancel;
 		}
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	}
+#endif
 	nla_nest_end(skb, nest);
 
 	return 0;
@@ -408,8 +422,12 @@ static int dev_dump_param_value(struct sk_buff *skb,
 
 static void dev_free_param_value(struct p4tc_act_param *param)
 {
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	kfree(param->value);
+#else
 	if (!(param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN))
 		kfree(param->value);
+#endif
 }
 
 static int generic_init_param_value(struct p4tc_act_param *nparam,
@@ -486,10 +504,15 @@ const struct p4tc_act_param_ops param_ops[P4T_MAX + 1] = {
 
 static void generic_free_param_value(struct p4tc_act_param *param)
 {
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	kfree(param->value);
+	kfree(param->mask);
+#else
 	if (!(param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN)) {
 		kfree(param->value);
 		kfree(param->mask);
 	}
+#endif
 }
 
 int tcf_p4_act_init_params_list(struct tcf_p4act_params *params,
@@ -586,12 +609,15 @@ INDIRECT_CALLABLE_SCOPE int tcf_p4_dyna_act(struct sk_buff *skb,
 {
 	struct tcf_p4act *dynact = to_p4act(a);
 	int ret = 0;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	int jmp_cnt = 0;
 	struct p4tc_cmd_operate *op;
+#endif
 
 	tcf_lastuse_update(&dynact->tcf_tm);
 	tcf_action_update_bstats(&dynact->common, skb);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	list_for_each_entry(op, &dynact->cmd_operations, cmd_operations) {
 		if (jmp_cnt-- > 0)
 			continue;
@@ -609,6 +635,7 @@ INDIRECT_CALLABLE_SCOPE int tcf_p4_dyna_act(struct sk_buff *skb,
 			break;
 		}
 	}
+#endif
 
 	if (ret == TC_ACT_SHOT)
 		tcf_action_inc_drop_qstats(&dynact->common);
@@ -636,7 +663,9 @@ static int tcf_p4_dyna_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	struct tcf_p4act_params *params;
 	struct p4tc_act_param *parm;
 	struct nlattr *nest_parms;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct nlattr *nest;
+#endif
 	struct tcf_t t;
 	int id;
 
@@ -646,10 +675,12 @@ static int tcf_p4_dyna_dump(struct sk_buff *skb, struct tc_action *a, int bind,
 	if (nla_put(skb, P4TC_ACT_OPT, sizeof(opt), &opt))
 		goto nla_put_failure;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
 	if (p4tc_cmds_fillup(skb, &dynact->cmd_operations))
 		goto nla_put_failure;
 	nla_nest_end(skb, nest);
+#endif
 
 	if (nla_put_string(skb, P4TC_ACT_NAME, a->ops->kind))
 		goto nla_put_failure;
@@ -744,7 +775,9 @@ static void tcf_p4_dyna_cleanup(struct tc_action *a)
 	if (refcount_read(&ops->dyn_ref) > 1)
 		refcount_dec(&ops->dyn_ref);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	p4tc_cmds_release_ope_list(NULL, &m->cmd_operations, false);
+#endif
 	if (params)
 		call_rcu(&params->rcu, tcf_p4_act_params_destroy_rcu);
 }
@@ -757,6 +790,7 @@ int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
 	struct nlattr *nla_value;
 
 	nla_value = nla_nest_start(skb, P4TC_ACT_PARAMS_VALUE);
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (param->flags & P4TC_ACT_PARAM_FLAGS_ISDYN) {
 		struct p4tc_cmd_operand *kopnd;
 		struct nlattr *nla_opnd;
@@ -767,10 +801,13 @@ int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
 			goto out_nlmsg_trim;
 		nla_nest_end(skb, nla_opnd);
 	} else {
+#endif
 		if (nla_put(skb, P4TC_ACT_PARAMS_VALUE_RAW, bytesz,
 			    param->value))
 			goto out_nlmsg_trim;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	}
+#endif
 	nla_nest_end(skb, nla_value);
 
 	if (param->mask &&
@@ -1343,7 +1380,9 @@ static int __tcf_act_put(struct net *net, struct p4tc_pipeline *pipeline,
 		kfree(act_param);
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	p4tc_cmds_release_ope_list(net, &act->cmd_operations, true);
+#endif
 
 	ret = tcf_unregister_dyn_action(net, &act->ops);
 	if (ret < 0) {
@@ -1353,16 +1392,20 @@ static int __tcf_act_put(struct net *net, struct p4tc_pipeline *pipeline,
 	}
 	p4tc_action_net_exit(act->tn);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (act->labels) {
 		rhashtable_free_and_destroy(act->labels, p4tc_label_ht_destroy,
 					    NULL);
 		kfree(act->labels);
 	}
+#endif
 
 	idr_remove(&pipeline->p_act_idr, act->a_id);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (!unconditional_purge)
 		tcf_pipeline_delete_from_dep_graph(pipeline, act);
+#endif
 
 	list_del(&act->head);
 
@@ -1378,9 +1421,12 @@ static int _tcf_act_fill_nlmsg(struct net *net, struct sk_buff *skb,
 {
 	unsigned char *b = nlmsg_get_pos(skb);
 	int i = 1;
-	struct nlattr *nest, *parms, *cmds;
+	struct nlattr *nest, *parms;
 	struct p4tc_act_param *param;
 	unsigned long param_id, tmp;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+	struct nlattr *cmds;
+#endif
 
 	if (nla_put_u32(skb, P4TC_PATH, act->a_id))
 		goto out_nlmsg_trim;
@@ -1417,10 +1463,12 @@ static int _tcf_act_fill_nlmsg(struct net *net, struct sk_buff *skb,
 	}
 	nla_nest_end(skb, parms);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	cmds = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
 	if (p4tc_cmds_fillup(skb, &act->cmd_operations))
 		goto out_nlmsg_trim;
 	nla_nest_end(skb, cmds);
+#endif
 
 	nla_nest_end(skb, nest);
 
@@ -1578,7 +1626,9 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 	u32 a_id = ids[P4TC_AID_IDX];
 	int num_params = 0;
 	int ret = 0;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct p4tc_act_dep_node *dep_node;
+#endif
 	struct p4tc_act *act;
 	char *act_name;
 
@@ -1649,6 +1699,7 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 		}
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	dep_node = kzalloc(sizeof(*dep_node), GFP_KERNEL);
 	if (!dep_node) {
 		ret = -ENOMEM;
@@ -1657,13 +1708,18 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 	dep_node->act_id = act->a_id;
 	INIT_LIST_HEAD(&dep_node->incoming_egde_list);
 	list_add_tail(&dep_node->head, &pipeline->act_dep_graph);
+#endif
 
 	refcount_set(&act->ops.dyn_ref, 1);
 	ret = tcf_register_dyn_action(net, &act->ops);
 	if (ret < 0) {
 		NL_SET_ERR_MSG(extack,
 			       "Unable to register new action template");
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		goto idr_rm;
+#else
 		goto free_dep_node;
+#endif
 	}
 
 	num_params = p4_act_init(act, tb[P4TC_ACT_PARMS], params, extack);
@@ -1675,6 +1731,13 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 
 	set_param_indices(act);
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_ACT_CMDS_LIST]) {
+		NL_SET_ERR_MSG(extack, "Commands not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto uninit;
+	}
+#else
 	INIT_LIST_HEAD(&act->cmd_operations);
 	act->pipeline = pipeline;
 	if (tb[P4TC_ACT_CMDS_LIST]) {
@@ -1683,14 +1746,17 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 		if (ret < 0)
 			goto uninit;
 	}
+#endif
 
 	pipeline->num_created_acts++;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	ret = determine_act_topological_order(pipeline, true);
 	if (ret < 0) {
 		pipeline->num_created_acts--;
 		goto release_cmds;
 	}
+#endif
 
 	act->common.p_id = pipeline->common.p_id;
 	snprintf(act->common.name, ACTNAMSIZ, "%s/%s", pipeline->common.name,
@@ -1703,9 +1769,11 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 
 	return act;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 release_cmds:
 	if (tb[P4TC_ACT_CMDS_LIST])
 		p4tc_cmds_release_ope_list(net, &act->cmd_operations, false);
+#endif
 
 uninit:
 	p4_put_many_params(&act->params_idr, params, num_params);
@@ -1716,9 +1784,11 @@ static struct p4tc_act *tcf_act_create(struct net *net, struct nlattr **tb,
 	tcf_unregister_dyn_action(net, &act->ops);
 	rtnl_lock();
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 free_dep_node:
 	list_del(&dep_node->head);
 	kfree(dep_node);
+#endif
 
 idr_rm:
 	idr_remove(&pipeline->p_act_idr, act->a_id);
@@ -1785,6 +1855,13 @@ static struct p4tc_act *tcf_act_update(struct net *net, struct nlattr **tb,
 		goto params_del;
 	}
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_ACT_CMDS_LIST]) {
+		NL_SET_ERR_MSG(extack, "Commands not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto params_del;
+	}
+#else
 	if (tb[P4TC_ACT_CMDS_LIST]) {
 		ret = p4tc_cmds_parse(net, act, tb[P4TC_ACT_CMDS_LIST], true,
 				      extack);
@@ -1795,12 +1872,15 @@ static struct p4tc_act *tcf_act_update(struct net *net, struct nlattr **tb,
 		if (ret < 0)
 			goto release_cmds;
 	}
+#endif
 
 	p4tc_params_replace_many(&act->params_idr, params, num_params);
 	return act;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 release_cmds:
 	p4tc_cmds_release_ope_list(net, &act->cmd_operations, false);
+#endif
 
 params_del:
 	p4_put_many_params(&act->params_idr, params, num_params);
@@ -1880,7 +1960,9 @@ static int tcf_act_dump_1(struct sk_buff *skb,
 	struct nlattr *param = nla_nest_start(skb, P4TC_PARAMS);
 	unsigned char *b = nlmsg_get_pos(skb);
 	struct p4tc_act *act = to_act(common);
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct nlattr *nest;
+#endif
 
 	if (!param)
 		goto out_nlmsg_trim;
@@ -1888,10 +1970,12 @@ static int tcf_act_dump_1(struct sk_buff *skb,
 	if (nla_put_string(skb, P4TC_ACT_NAME, act->common.name))
 		goto out_nlmsg_trim;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	nest = nla_nest_start(skb, P4TC_ACT_CMDS_LIST);
 	if (p4tc_cmds_fillup(skb, &act->cmd_operations))
 		goto out_nlmsg_trim;
 	nla_nest_end(skb, nest);
+#endif
 
 	if (nla_put_u8(skb, P4TC_ACT_ACTIVE, act->active))
 		goto out_nlmsg_trim;
diff --git a/net/sched/p4tc/p4tc_bpf.c b/net/sched/p4tc/p4tc_bpf.c
index 08d26a6499c5..3e4eb1fd9d97 100644
--- a/net/sched/p4tc/p4tc_bpf.c
+++ b/net/sched/p4tc/p4tc_bpf.c
@@ -21,8 +21,74 @@
 #include <linux/filter.h>
 
 BTF_ID_LIST(btf_p4tc_ids)
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+BTF_ID(struct, p4tc_table_entry_act_bpf)
+BTF_ID(struct, p4tc_table_entry_act_bpf_params)
+#else
 BTF_ID(struct, p4tc_parser_buffer_act_bpf)
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+#define ENTRY_KEY_OFFSET (offsetof(struct p4tc_table_entry_key, fa_key))
+
+struct p4tc_table_entry_act_bpf *
+__bpf_p4tc_tbl_lookup(struct net *caller_net,
+		      struct p4tc_table_entry_act_bpf_params *params,
+		      void *key, const u32 key__sz)
+{
+	struct p4tc_table_entry_key *entry_key = (struct p4tc_table_entry_key *)key;
+	const u32 pipeid = params->pipeid;
+	const u32 tblid = params->tblid;
+	struct p4tc_table_entry_value *value;
+	struct p4tc_table_entry *entry;
+	struct p4tc_table *table;
+
+	entry_key->keysz = (key__sz - ENTRY_KEY_OFFSET) << 3;
+
+	table = p4tc_tbl_cache_lookup(caller_net, pipeid, tblid);
+	if (!table)
+		return NULL;
+
+	entry = p4tc_table_entry_lookup_direct(table, entry_key);
+	if (!entry) {
+		struct p4tc_table_defact *defact;
+
+		defact = rcu_dereference(table->tbl_default_missact);
+		return defact ? defact->defact_bpf : NULL;
+	}
+
+	value = p4tc_table_entry_value(entry);
+
+	return value->act_bpf;
+}
+
+struct p4tc_table_entry_act_bpf *
+bpf_skb_p4tc_tbl_lookup(struct __sk_buff *skb_ctx,
+			struct p4tc_table_entry_act_bpf_params *params,
+			void *key, const u32 key__sz)
+{
+	struct sk_buff *skb = (struct sk_buff *)skb_ctx;
+	struct net *caller_net;
+
+	caller_net = skb->dev ? dev_net(skb->dev) : sock_net(skb->sk);
+
+	return __bpf_p4tc_tbl_lookup(caller_net, params, key, key__sz);
+}
+
+struct p4tc_table_entry_act_bpf *
+bpf_xdp_p4tc_tbl_lookup(struct xdp_md *xdp_ctx,
+			struct p4tc_table_entry_act_bpf_params *params,
+			void *key, const u32 key__sz)
+{
+	struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
+	struct net *caller_net;
+
+	caller_net = dev_net(ctx->rxq->dev);
+
+	return __bpf_p4tc_tbl_lookup(caller_net, params, key, key__sz);
+}
+
+#else
 struct p4tc_parser_buffer_act_bpf *bpf_p4tc_get_parser_buffer(void)
 {
 	struct p4tc_percpu_scratchpad *pad;
@@ -45,6 +111,7 @@ int is_p4tc_kfunc(const struct bpf_reg_state *reg)
 
 	return p4tc_parser_type == t;
 }
+#endif
 
 void bpf_p4tc_set_cookie(u32 cookie)
 {
@@ -55,7 +122,12 @@ void bpf_p4tc_set_cookie(u32 cookie)
 }
 
 BTF_SET8_START(p4tc_tbl_kfunc_set)
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+BTF_ID_FLAGS(func, bpf_skb_p4tc_tbl_lookup, KF_RET_NULL);
+BTF_ID_FLAGS(func, bpf_xdp_p4tc_tbl_lookup, KF_RET_NULL);
+#else
 BTF_ID_FLAGS(func, bpf_p4tc_get_parser_buffer, 0);
+#endif
 BTF_ID_FLAGS(func, bpf_p4tc_set_cookie, 0);
 BTF_SET8_END(p4tc_tbl_kfunc_set)
 
diff --git a/net/sched/p4tc/p4tc_hdrfield.c b/net/sched/p4tc/p4tc_hdrfield.c
index d5dd9b5c885d..c7c2fe90ec81 100644
--- a/net/sched/p4tc/p4tc_hdrfield.c
+++ b/net/sched/p4tc/p4tc_hdrfield.c
@@ -165,6 +165,7 @@ tcf_hdrfield_find_byanyattr(struct p4tc_parser *parser,
 				       extack);
 }
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield)
 {
 	size_t hdr_offset_len = sizeof(u16);
@@ -183,6 +184,7 @@ void *tcf_hdrfield_fetch(struct sk_buff *skb, struct p4tc_hdrfield *hdrfield)
 
 	return skb_mac_header(skb) + hdr_offset;
 }
+#endif
 
 static struct p4tc_hdrfield *tcf_hdrfield_create(struct nlmsghdr *n,
 						 struct nlattr *nla,
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index fafb9c849b13..6d5722f6a298 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -37,9 +37,56 @@ static __net_init int pipeline_init_net(struct net *net)
 
 	idr_init(&pipe_net->pipeline_idr);
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	for (int i = 0; i < P4TC_TBLS_CACHE_SIZE; i++)
+		INIT_LIST_HEAD(&pipe_net->tbls_cache[i]);
+#endif
+
 	return 0;
 }
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+static inline size_t p4tc_tbl_cache_hash(u32 pipeid, u32 tblid)
+{
+	return (pipeid + tblid) % P4TC_TBLS_CACHE_SIZE;
+}
+
+struct p4tc_table *p4tc_tbl_cache_lookup(struct net *net, u32 pipeid, u32 tblid)
+{
+	size_t hash = p4tc_tbl_cache_hash(pipeid, tblid);
+	struct p4tc_pipeline_net *pipe_net;
+	struct p4tc_table *pos, *tmp;
+	struct net_generic *ng;
+
+	/* RCU read lock is already being held */
+	ng = rcu_dereference(net->gen);
+	pipe_net = ng->ptr[pipeline_net_id];
+
+	list_for_each_entry_safe(pos, tmp, &pipe_net->tbls_cache[hash],
+				 tbl_cache_node) {
+		if (pos->common.p_id == pipeid && pos->tbl_id == tblid)
+			return pos;
+	}
+
+	return NULL;
+}
+
+int p4tc_tbl_cache_insert(struct net *net, u32 pipeid, struct p4tc_table *table)
+{
+	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
+	size_t hash = p4tc_tbl_cache_hash(pipeid, table->tbl_id);
+
+	list_add_tail(&table->tbl_cache_node, &pipe_net->tbls_cache[hash]);
+
+	return 0;
+}
+
+void p4tc_tbl_cache_remove(struct net *net, struct p4tc_table *table)
+{
+	list_del(&table->tbl_cache_node);
+}
+#endif
+
 static int tcf_pipeline_put(struct net *net,
 			    struct p4tc_template_common *template,
 			    bool unconditional_purgeline,
@@ -73,10 +120,13 @@ static const struct nla_policy tc_pipeline_policy[P4TC_PIPELINE_MAX + 1] = {
 	[P4TC_PIPELINE_NUMTABLES] =
 		NLA_POLICY_RANGE(NLA_U16, P4TC_MINTABLES_COUNT, P4TC_MAXTABLES_COUNT),
 	[P4TC_PIPELINE_STATE] = { .type = NLA_U8 },
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	[P4TC_PIPELINE_PREACTIONS] = { .type = NLA_NESTED },
 	[P4TC_PIPELINE_POSTACTIONS] = { .type = NLA_NESTED },
+#endif
 };
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static void __act_dep_graph_free(struct list_head *incoming_egde_list)
 {
 	struct p4tc_act_dep_edge_node *cursor_edge, *tmp_edge;
@@ -291,11 +341,14 @@ int determine_act_topological_order(struct p4tc_pipeline *pipeline,
 
 	return 0;
 }
+#endif
 
 static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
 				 bool free_pipeline)
 {
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	idr_destroy(&pipeline->p_meta_idr);
+#endif
 	idr_destroy(&pipeline->p_act_idr);
 	idr_destroy(&pipeline->p_tbl_idr);
 	idr_destroy(&pipeline->p_reg_idr);
@@ -324,9 +377,17 @@ static int tcf_pipeline_put(struct net *net,
 	struct p4tc_pipeline_net *pipe_net = net_generic(net, pipeline_net_id);
 	struct p4tc_pipeline *pipeline = to_pipeline(template);
 	struct net *pipeline_net = maybe_get_net(net);
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	struct p4tc_act *act;
+	unsigned long iter_act_id;
+#else
 	struct p4tc_act_dep_node *act_node, *node_tmp;
-	unsigned long reg_id, tbl_id, m_id, tmp;
+#endif
+	unsigned long reg_id, tbl_id, tmp;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct p4tc_metadata *meta;
+	unsigned long m_id;
+#endif
 	struct p4tc_register *reg;
 	struct p4tc_table *table;
 
@@ -349,12 +410,18 @@ static int tcf_pipeline_put(struct net *net,
 	 * will use them. So there is no need to free them in the rcu
 	 * callback. We can just free them here
 	 */
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	p4tc_action_destroy(pipeline->preacts);
 	p4tc_action_destroy(pipeline->postacts);
+#endif
 
 	idr_for_each_entry_ul(&pipeline->p_tbl_idr, table, tmp, tbl_id)
 		table->common.ops->put(net, &table->common, true, extack);
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	idr_for_each_entry_ul(&pipeline->p_act_idr, act, tmp, iter_act_id)
+		act->common.ops->put(net, &act->common, true, extack);
+#else
 	act_dep_graph_free(&pipeline->act_dep_graph);
 
 	list_for_each_entry_safe(act_node, node_tmp,
@@ -366,9 +433,12 @@ static int tcf_pipeline_put(struct net *net,
 		list_del(&act_node->head);
 		kfree(act_node);
 	}
+#endif
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	idr_for_each_entry_ul(&pipeline->p_meta_idr, meta, tmp, m_id)
 		meta->common.ops->put(net, &meta->common, true, extack);
+#endif
 
 	if (pipeline->parser)
 		tcf_parser_del(net, pipeline, pipeline->parser, extack);
@@ -398,6 +468,7 @@ static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 		return -EINVAL;
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (!pipeline->preacts) {
 		NL_SET_ERR_MSG(extack,
 			       "Must specify pipeline preactions before sealing");
@@ -409,12 +480,15 @@ static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 			       "Must specify pipeline postactions before sealing");
 		return -EINVAL;
 	}
+#endif
 	ret = tcf_table_try_set_state_ready(pipeline, extack);
 	if (ret < 0)
 		return ret;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	/* Will never fail in this case */
 	determine_act_topological_order(pipeline, false);
+#endif
 
 	pipeline->p_state = P4TC_STATE_READY;
 	return true;
@@ -520,6 +594,14 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 	else
 		pipeline->num_tables = P4TC_DEFAULT_NUM_TABLES;
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_PIPELINE_PREACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Pipeline preactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto idr_rm;
+	}
+#else
 	if (tb[P4TC_PIPELINE_PREACTIONS]) {
 		pipeline->preacts = kcalloc(TCA_ACT_MAX_PRIO,
 					    sizeof(struct tc_action *),
@@ -540,7 +622,16 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 		pipeline->preacts = NULL;
 		pipeline->num_preacts = 0;
 	}
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Pipeline postactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto idr_rm;
+	}
+#else
 	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
 		pipeline->postacts = kcalloc(TCA_ACT_MAX_PRIO,
 					     sizeof(struct tc_action *),
@@ -561,6 +652,7 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 		pipeline->postacts = NULL;
 		pipeline->num_postacts = 0;
 	}
+#endif
 
 	pipeline->parser = NULL;
 
@@ -569,13 +661,17 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 	idr_init(&pipeline->p_tbl_idr);
 	pipeline->curr_tables = 0;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	idr_init(&pipeline->p_meta_idr);
 	pipeline->p_meta_offset = 0;
+#endif
 
 	idr_init(&pipeline->p_reg_idr);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	INIT_LIST_HEAD(&pipeline->act_dep_graph);
 	INIT_LIST_HEAD(&pipeline->act_topological_order);
+#endif
 	pipeline->num_created_acts = 0;
 
 	pipeline->p_state = P4TC_STATE_NOT_READY;
@@ -591,8 +687,10 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 
 	return pipeline;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 preactions_destroy:
 	p4tc_action_destroy(pipeline->preacts);
+#endif
 
 idr_rm:
 	idr_remove(&pipe_net->pipeline_idr, pipeid);
@@ -715,7 +813,9 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 	int ret = 0;
 	struct nlattr *tb[P4TC_PIPELINE_MAX + 1];
 	struct p4tc_pipeline *pipeline;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	int num_preacts, num_postacts;
+#endif
 
 	ret = nla_parse_nested(tb, P4TC_PIPELINE_MAX, nla, tc_pipeline_policy,
 			       extack);
@@ -734,6 +834,14 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 	if (tb[P4TC_PIPELINE_MAXRULES])
 		max_rules = nla_get_u32(tb[P4TC_PIPELINE_MAXRULES]);
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_PIPELINE_PREACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Pipeline preactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+#else
 	if (tb[P4TC_PIPELINE_PREACTIONS]) {
 		preacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				  GFP_KERNEL);
@@ -751,7 +859,16 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 		}
 		num_preacts = ret;
 	}
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Pipeline preactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto preactions_destroy;
+	}
+#else
 	if (tb[P4TC_PIPELINE_POSTACTIONS]) {
 		postacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				   GFP_KERNEL);
@@ -769,18 +886,22 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 		}
 		num_postacts = ret;
 	}
+#endif
 
 	if (tb[P4TC_PIPELINE_STATE]) {
 		ret = pipeline_try_set_state_ready(pipeline, extack);
 		if (ret < 0)
 			goto postactions_destroy;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 		tcf_meta_fill_user_offsets(pipeline);
+#endif
 	}
 
 	if (max_rules)
 		pipeline->max_rules = max_rules;
 	if (num_tables)
 		pipeline->num_tables = num_tables;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (preacts) {
 		p4tc_action_destroy(pipeline->preacts);
 		pipeline->preacts = preacts;
@@ -791,6 +912,7 @@ tcf_pipeline_update(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
 		pipeline->postacts = postacts;
 		pipeline->num_postacts = num_postacts;
 	}
+#endif
 
 	return pipeline;
 
@@ -835,7 +957,10 @@ static int _tcf_pipeline_fill_nlmsg(struct sk_buff *skb,
 				    const struct p4tc_pipeline *pipeline)
 {
 	unsigned char *b = nlmsg_get_pos(skb);
-	struct nlattr *nest, *preacts, *postacts;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+	 struct nlattr *preacts, *postacts;
+#endif
+	struct nlattr *nest;
 
 	nest = nla_nest_start(skb, P4TC_PARAMS);
 	if (!nest)
@@ -848,6 +973,7 @@ static int _tcf_pipeline_fill_nlmsg(struct sk_buff *skb,
 	if (nla_put_u8(skb, P4TC_PIPELINE_STATE, pipeline->p_state))
 		goto out_nlmsg_trim;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (pipeline->preacts) {
 		preacts = nla_nest_start(skb, P4TC_PIPELINE_PREACTIONS);
 		if (tcf_action_dump(skb, pipeline->preacts, 0, 0, false) < 0)
@@ -861,6 +987,7 @@ static int _tcf_pipeline_fill_nlmsg(struct sk_buff *skb,
 			goto out_nlmsg_trim;
 		nla_nest_end(skb, postacts);
 	}
+#endif
 
 	nla_nest_end(skb, nest);
 
@@ -992,7 +1119,9 @@ static void __tcf_pipeline_init(void)
 
 	strscpy(root_pipeline->common.name, "kernel", PIPELINENAMSIZ);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	idr_init(&root_pipeline->p_meta_idr);
+#endif
 
 	root_pipeline->common.ops =
 		(struct p4tc_template_ops *)&p4tc_pipeline_ops;
@@ -1001,7 +1130,9 @@ static void __tcf_pipeline_init(void)
 
 	root_pipeline->p_state = P4TC_STATE_READY;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	tcf_meta_init(root_pipeline);
+#endif
 }
 
 static void tcf_pipeline_init(void)
diff --git a/net/sched/p4tc/p4tc_table.c b/net/sched/p4tc/p4tc_table.c
index e5b1a56aed7d..64f994c7dffc 100644
--- a/net/sched/p4tc/p4tc_table.c
+++ b/net/sched/p4tc/p4tc_table.c
@@ -31,6 +31,7 @@
 #define P4TC_P_UNSPEC 0
 #define P4TC_P_CREATED 1
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static int tcf_key_try_set_state_ready(struct p4tc_table_key *key,
 				       struct netlink_ext_ack *extack)
 {
@@ -42,11 +43,12 @@ static int tcf_key_try_set_state_ready(struct p4tc_table_key *key,
 
 	return 0;
 }
+#endif
 
 static int __tcf_table_try_set_state_ready(struct p4tc_table *table,
 					   struct netlink_ext_ack *extack)
 {
-	int i;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	int ret;
 
 	if (!table->tbl_postacts) {
@@ -64,6 +66,7 @@ static int __tcf_table_try_set_state_ready(struct p4tc_table *table,
 	ret = tcf_key_try_set_state_ready(table->tbl_key, extack);
 	if (ret < 0)
 		return ret;
+#endif
 
 	table->tbl_masks_array = kcalloc(table->tbl_max_masks,
 					 sizeof(*(table->tbl_masks_array)),
@@ -131,15 +134,18 @@ static const struct nla_policy p4tc_table_policy[P4TC_TABLE_MAX + 1] = {
 	[P4TC_TABLE_NAME] = { .type = NLA_STRING, .len = TABLENAMSIZ },
 	[P4TC_TABLE_INFO] = { .type = NLA_BINARY,
 			      .len = sizeof(struct p4tc_table_parm) },
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	[P4TC_TABLE_PREACTIONS] = { .type = NLA_NESTED },
 	[P4TC_TABLE_KEY] = { .type = NLA_NESTED },
 	[P4TC_TABLE_POSTACTIONS] = { .type = NLA_NESTED },
+#endif
 	[P4TC_TABLE_DEFAULT_HIT] = { .type = NLA_NESTED },
 	[P4TC_TABLE_DEFAULT_MISS] = { .type = NLA_NESTED },
 	[P4TC_TABLE_ACTS_LIST] = { .type = NLA_NESTED },
 	[P4TC_TABLE_OPT_ENTRY] = { .type = NLA_NESTED },
 };
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static const struct nla_policy p4tc_table_key_policy[P4TC_MAXPARSE_KEYS + 1] = {
 	[P4TC_KEY_ACT] = { .type = NLA_NESTED },
 };
@@ -160,6 +166,7 @@ static int tcf_table_key_fill_nlmsg(struct sk_buff *skb,
 
 	return ret;
 }
+#endif
 
 static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
 {
@@ -172,11 +179,15 @@ static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
 	struct nlattr *default_hitact;
 	struct nlattr *nested_count;
 	struct p4tc_table_parm parm;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct nlattr *nest_key;
+#endif
 	struct nlattr *nest;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct nlattr *preacts;
 	struct nlattr *postacts;
 	int err;
+#endif
 
 	if (nla_put_u32(skb, P4TC_PATH, table->tbl_id))
 		goto out_nlmsg_trim;
@@ -196,6 +207,7 @@ static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
 	tbl_perm = rcu_dereference_rtnl(table->tbl_permissions);
 	parm.tbl_permissions = tbl_perm->permissions;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (table->tbl_key) {
 		nest_key = nla_nest_start(skb, P4TC_TABLE_KEY);
 		err = tcf_table_key_fill_nlmsg(skb, table->tbl_key);
@@ -217,6 +229,7 @@ static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
 			goto out_nlmsg_trim;
 		nla_nest_end(skb, postacts);
 	}
+#endif
 
 	if (table->tbl_default_hitact) {
 		struct p4tc_table_defact *hitact;
@@ -322,16 +335,21 @@ static int tcf_table_fill_nlmsg(struct net *net, struct sk_buff *skb,
 	return 0;
 }
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static inline void tcf_table_key_put(struct p4tc_table_key *key)
 {
 	p4tc_action_destroy(key->key_acts);
 	kfree(key);
 }
+#endif
 
 static inline void p4tc_table_defact_destroy(struct p4tc_table_defact *defact)
 {
 	if (defact) {
 		p4tc_action_destroy(defact->default_acts);
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		kfree(defact->defact_bpf);
+#endif
 		kfree(defact);
 	}
 }
@@ -435,16 +453,21 @@ static inline int _tcf_table_put(struct net *net, struct nlattr **tb,
 	if (default_act_del)
 		return 0;
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (table->tbl_key)
 		tcf_table_key_put(table->tbl_key);
 
 	p4tc_action_destroy(table->tbl_preacts);
 	p4tc_action_destroy(table->tbl_postacts);
+#endif
 
 	tcf_table_acts_list_destroy(&table->tbl_acts_list);
 
 	rhltable_free_and_destroy(&table->tbl_entries,
 				  tcf_table_entry_destroy_hash, table);
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	p4tc_tbl_cache_remove(net, table);
+#endif
 
 	idr_destroy(&table->tbl_masks_idr);
 	ida_destroy(&table->tbl_prio_idr);
@@ -475,6 +498,7 @@ static int tcf_table_put(struct net *net, struct p4tc_template_common *tmpl,
 			      extack);
 }
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 static inline struct p4tc_table_key *
 tcf_table_key_add(struct net *net, struct p4tc_table *table, struct nlattr *nla,
 		  struct netlink_ext_ack *extack)
@@ -520,6 +544,7 @@ tcf_table_key_add(struct net *net, struct p4tc_table *table, struct nlattr *nla,
 out:
 	return ERR_PTR(ret);
 }
+#endif
 
 struct p4tc_table *tcf_table_find_byid(struct p4tc_pipeline *pipeline,
 				       const u32 tbl_id)
@@ -623,6 +648,9 @@ static int tcf_table_init_default_act(struct net *net, struct nlattr **tb,
 	}
 
 	if (tb[P4TC_TABLE_DEFAULT_ACTION]) {
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		struct p4tc_table_entry_act_bpf *act_bpf;
+#endif
 		struct tc_action **default_acts;
 
 		if (!p4tc_ctrl_update_ok(curr_permissions)) {
@@ -651,6 +679,17 @@ static int tcf_table_init_default_act(struct net *net, struct nlattr **tb,
 			ret = -EINVAL;
 			goto default_act_free;
 		}
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		act_bpf = tcf_table_entry_create_act_bpf(default_acts[0],
+							 extack);
+		if (IS_ERR(act_bpf)) {
+			tcf_action_destroy(default_acts, TCA_ACT_UNBIND);
+			kfree(default_acts);
+			ret = -EINVAL;
+			goto default_act_free;
+		}
+		(*default_act)->defact_bpf = act_bpf;
+#endif
 		(*default_act)->default_acts = default_acts;
 	}
 
@@ -895,7 +934,9 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 					   struct netlink_ext_ack *extack)
 {
 	struct rhashtable_params table_hlt_params = entry_hlt_params;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct p4tc_table_key *key = NULL;
+#endif
 	struct p4tc_table_parm *parm;
 	struct p4tc_table *table;
 	char *tblname;
@@ -1086,6 +1127,14 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 			goto idr_rm;
 	}
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_TABLE_PREACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Table preactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto table_acts_destroy;
+	}
+#else
 	if (tb[P4TC_TABLE_PREACTIONS]) {
 		table->tbl_preacts = kcalloc(TCA_ACT_MAX_PRIO,
 					     sizeof(struct tc_action *),
@@ -1106,7 +1155,16 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 	} else {
 		table->tbl_preacts = NULL;
 	}
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_TABLE_POSTACTIONS]) {
+		NL_SET_ERR_MSG(extack,
+			       "Table postactions not supported in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto table_acts_destroy;
+	}
+#else
 	if (tb[P4TC_TABLE_POSTACTIONS]) {
 		table->tbl_postacts = kcalloc(TCA_ACT_MAX_PRIO,
 					      sizeof(struct tc_action *),
@@ -1128,7 +1186,16 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 		table->tbl_postacts = NULL;
 		table->tbl_num_postacts = 0;
 	}
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_TABLE_KEY]) {
+		NL_SET_ERR_MSG(extack,
+			       "Mustn't specify key in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto table_acts_destroy;
+	}
+#else
 	if (tb[P4TC_TABLE_KEY]) {
 		key = tcf_table_key_add(net, table, tb[P4TC_TABLE_KEY], extack);
 		if (IS_ERR(key)) {
@@ -1136,13 +1203,18 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 			goto postacts_destroy;
 		}
 	}
+#endif
 
 	ret = tcf_table_init_default_acts(net, tb, table,
 					  &table->tbl_default_hitact,
 					  &table->tbl_default_missact,
 					  &table->tbl_acts_list, extack);
 	if (ret < 0)
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		goto table_acts_destroy;
+#else
 		goto key_put;
+#endif
 
 	table->tbl_curr_used_entries = 0;
 	table->tbl_curr_count = 0;
@@ -1164,7 +1236,15 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 		goto defaultacts_destroy;
 	}
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	ret = p4tc_tbl_cache_insert(net, pipeline->common.p_id, table);
+	if (ret < 0)
+		goto entries_hashtable_destroy;
+#endif
+
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	table->tbl_key = key;
+#endif
 
 	pipeline->curr_tables += 1;
 
@@ -1172,8 +1252,14 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 
 	return table;
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+entries_hashtable_destroy:
+	rhltable_destroy(&table->tbl_entries);
+#endif
+
 defaultacts_destroy:
 	p4tc_table_defact_destroy(table->tbl_default_missact);
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	p4tc_table_defact_destroy(table->tbl_default_hitact);
 
 key_put:
@@ -1185,6 +1271,7 @@ static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
 
 preactions_destroy:
 	p4tc_action_destroy(table->tbl_preacts);
+#endif
 
 idr_rm:
 	idr_remove(&pipeline->p_tbl_idr, table->tbl_id);
@@ -1208,15 +1295,19 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 					   u32 flags,
 					   struct netlink_ext_ack *extack)
 {
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct p4tc_table_key *key = NULL;
 	int num_postacts = 0, num_preacts = 0;
+#endif
 	struct p4tc_table_defact *default_hitact = NULL;
 	struct p4tc_table_defact *default_missact = NULL;
 	struct list_head *tbl_acts_list = NULL;
 	struct p4tc_table_perm *perm = NULL;
 	struct p4tc_table_parm *parm = NULL;
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	struct tc_action **postacts = NULL;
 	struct tc_action **preacts = NULL;
+#endif
 	int ret = 0;
 	struct p4tc_table *table;
 
@@ -1238,6 +1329,7 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 			goto table_acts_destroy;
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (tb[P4TC_TABLE_PREACTIONS]) {
 		preacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
 				  GFP_KERNEL);
@@ -1271,6 +1363,7 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 		}
 		num_postacts = ret;
 	}
+#endif
 
 	if (tbl_acts_list)
 		ret = tcf_table_init_default_acts(net, tb, table,
@@ -1284,8 +1377,20 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 						  &table->tbl_acts_list,
 						  extack);
 	if (ret < 0)
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		goto table_acts_destroy;
+#else
 		goto postactions_destroy;
+#endif
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+	if (tb[P4TC_TABLE_KEY]) {
+		NL_SET_ERR_MSG(extack,
+			       "Mustn't specify key in kfuncs mode");
+		ret = -EOPNOTSUPP;
+		goto defaultacts_destroy;
+	}
+#else
 	if (tb[P4TC_TABLE_KEY]) {
 		key = tcf_table_key_add(net, table, tb[P4TC_TABLE_KEY], extack);
 		if (IS_ERR(key)) {
@@ -1293,6 +1398,7 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 			goto defaultacts_destroy;
 		}
 	}
+#endif
 
 	if (tb[P4TC_TABLE_INFO]) {
 		parm = nla_data(tb[P4TC_TABLE_INFO]);
@@ -1301,13 +1407,21 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 				NL_SET_ERR_MSG(extack,
 					       "Table keysz cannot be zero");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			if (parm->tbl_keysz > P4TC_MAX_KEYSZ) {
 				NL_SET_ERR_MSG(extack,
 					       "Table keysz exceeds maximum keysz");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			table->tbl_keysz = parm->tbl_keysz;
 		}
@@ -1317,13 +1431,21 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 				NL_SET_ERR_MSG(extack,
 					       "Table max_entries cannot be zero");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			if (parm->tbl_max_entries > P4TC_MAX_TENTRIES) {
 				NL_SET_ERR_MSG(extack,
 					       "Table max_entries exceeds maximum value");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			table->tbl_max_entries = parm->tbl_max_entries;
 		}
@@ -1333,13 +1455,21 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 				NL_SET_ERR_MSG(extack,
 					       "Table max_masks cannot be zero");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			if (parm->tbl_max_masks > P4TC_MAX_TMASKS) {
 				NL_SET_ERR_MSG(extack,
 					       "Table max_masks exceeds maximum value");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			table->tbl_max_masks = parm->tbl_max_masks;
 		}
@@ -1348,25 +1478,41 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 				NL_SET_ERR_MSG(extack,
 					       "Permission may only have 10 bits turned on");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			if (!p4tc_data_exec_ok(parm->tbl_permissions)) {
 				NL_SET_ERR_MSG(extack,
 					       "Table must have execute permissions");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			if (!p4tc_data_read_ok(parm->tbl_permissions)) {
 				NL_SET_ERR_MSG(extack,
 					       "Data path read permissions must be set");
 				ret = -EINVAL;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 
 			perm = kzalloc(sizeof(*perm), GFP_KERNEL);
 			if (!perm) {
 				ret = -ENOMEM;
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+				goto defaultacts_destroy;
+#else
 				goto key_destroy;
+#endif
 			}
 			perm->permissions = parm->tbl_permissions;
 		}
@@ -1395,6 +1541,7 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 		table->tbl_const_entry = entry;
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (preacts) {
 		p4tc_action_destroy(table->tbl_preacts);
 		table->tbl_preacts = preacts;
@@ -1406,6 +1553,7 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 		table->tbl_postacts = postacts;
 		table->tbl_num_postacts = num_postacts;
 	}
+#endif
 
 	if (default_hitact) {
 		struct p4tc_table_defact *hitact;
@@ -1429,11 +1577,13 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 		}
 	}
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	if (key) {
 		if (table->tbl_key)
 			tcf_table_key_put(table->tbl_key);
 		table->tbl_key = key;
 	}
+#endif
 
 	if (perm) {
 		perm = rcu_replace_pointer_rtnl(table->tbl_permissions, perm);
@@ -1445,19 +1595,23 @@ static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
 free_perm:
 	kfree(perm);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 key_destroy:
 	if (key)
 		tcf_table_key_put(key);
+#endif
 
 defaultacts_destroy:
 	p4tc_table_defact_destroy(default_missact);
 	p4tc_table_defact_destroy(default_hitact);
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 postactions_destroy:
 	p4tc_action_destroy(postacts);
 
 preactions_destroy:
 	p4tc_action_destroy(preacts);
+#endif
 
 table_acts_destroy:
 	if (tbl_acts_list) {
diff --git a/net/sched/p4tc/p4tc_tbl_api.c b/net/sched/p4tc/p4tc_tbl_api.c
index 21784b84864f..fb0a17cab3a7 100644
--- a/net/sched/p4tc/p4tc_tbl_api.c
+++ b/net/sched/p4tc/p4tc_tbl_api.c
@@ -142,23 +142,15 @@ static void mask_key(const struct p4tc_table_entry_mask *mask, u8 *masked_key,
 		masked_key[i] = skb_key[i] & mask->fa_value[i];
 }
 
-struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
-						 struct p4tc_table *table,
-						 u32 keysz)
+struct p4tc_table_entry *
+p4tc_table_entry_lookup_direct(struct p4tc_table *table,
+			       struct p4tc_table_entry_key *key)
 {
-	const struct p4tc_table_entry_mask **masks_array;
-	u32 smallest_prio = U32_MAX;
 	struct p4tc_table_entry *entry = NULL;
-	struct p4tc_percpu_scratchpad *pad;
-	struct p4tc_table_entry_key *key;
+	u32 smallest_prio = U32_MAX;
+	const struct p4tc_table_entry_mask **masks_array;
 	int i;
 
-	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
-
-	key = (struct p4tc_table_entry_key *)&pad->keysz;
-	key->keysz = keysz;
-	key->maskid = 0;
-
 	if (table->tbl_type == P4TC_TABLE_TYPE_EXACT)
 		return __p4tc_entry_lookup_fast(table, key);
 
@@ -194,6 +186,24 @@ struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
 	return entry;
 }
 
+#ifndef CONFIG_NET_P4_TC_KFUNCS
+struct p4tc_table_entry *p4tc_table_entry_lookup(struct sk_buff *skb,
+						 struct p4tc_table *table,
+						 u32 keysz)
+{
+	struct p4tc_percpu_scratchpad *pad;
+	struct p4tc_table_entry_key *key;
+
+	pad = this_cpu_ptr(&p4tc_percpu_scratchpad);
+
+	key = (void *)&pad->keysz;
+	key->keysz = keysz;
+	key->maskid = 0;
+
+	return p4tc_table_entry_lookup_direct(table, key);
+}
+#endif
+
 #define tcf_table_entry_mask_find_byid(table, id) \
 	(idr_find(&(table)->tbl_masks_idr, id))
 
@@ -596,6 +606,10 @@ static void tcf_table_entry_put(struct p4tc_table_entry *entry)
 		struct p4tc_pipeline *pipeline = entry_work->pipeline;
 		struct net *net;
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		kfree(value->act_bpf);
+#endif
+
 		if (entry_work->defer_deletion) {
 			net = get_net(pipeline->net);
 			refcount_inc(&entry_work->pipeline->p_entry_deferal_ref);
@@ -1454,7 +1468,9 @@ static struct p4tc_table_entry *__tcf_table_entry_cu(struct net *net, u32 flags,
 	}
 
 	if (tb[P4TC_ENTRY_ACT]) {
-
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		struct p4tc_table_entry_act_bpf *act_bpf;
+#endif
 		value->acts = kcalloc(TCA_ACT_MAX_PRIO,
 				      sizeof(struct tc_action *), GFP_KERNEL);
 		if (!value->acts) {
@@ -1480,6 +1496,16 @@ static struct p4tc_table_entry *__tcf_table_entry_cu(struct net *net, u32 flags,
 				       "Action is not allowed as entry action");
 			goto free_acts;
 		}
+
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		act_bpf = tcf_table_entry_create_act_bpf(value->acts[0],
+							 extack);
+		if (IS_ERR(act_bpf)) {
+			ret = PTR_ERR(act_bpf);
+			goto free_acts;
+		}
+		value->act_bpf = act_bpf;
+#endif
 	}
 
 	rcu_read_lock();
@@ -1491,12 +1517,21 @@ static struct p4tc_table_entry *__tcf_table_entry_cu(struct net *net, u32 flags,
 					       whodunnit, true);
 	if (ret < 0) {
 		rcu_read_unlock();
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+		goto free_act_bpf;
+#else
 		goto free_acts;
+#endif
 	}
 	rcu_read_unlock();
 
 	return entry;
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+free_act_bpf:
+	kfree(value->act_bpf);
+#endif
+
 free_acts:
 	p4tc_action_destroy(value->acts);
 
@@ -1510,6 +1545,58 @@ static struct p4tc_table_entry *__tcf_table_entry_cu(struct net *net, u32 flags,
 	return ERR_PTR(ret);
 }
 
+#ifdef CONFIG_NET_P4_TC_KFUNCS
+struct p4tc_table_entry_act_bpf *
+tcf_table_entry_create_act_bpf(struct tc_action *action,
+			       struct netlink_ext_ack *extack)
+{
+	size_t tot_params_sz = 0;
+	int num_params = 0;
+	struct p4tc_act_param *params[P4TC_MSGBATCH_SIZE];
+	struct p4tc_table_entry_act_bpf *act_bpf;
+	struct p4tc_act_param *param;
+	unsigned long param_id, tmp;
+	struct tcf_p4act *p4act;
+	struct tcf_p4act_params *act_params;
+	u8 *params_cursor;
+	int i;
+
+	p4act = to_p4act(action);
+
+	act_params = rcu_dereference(p4act->params);
+
+	idr_for_each_entry_ul(&act_params->params_idr, param, tmp, param_id) {
+		const struct p4tc_type *type = param->type;
+
+		if (tot_params_sz > P4TC_MAX_PARAM_DATA_SIZE) {
+			NL_SET_ERR_MSG(extack, "Maximum parameter byte size reached");
+			return ERR_PTR(-EINVAL);
+		}
+
+		tot_params_sz += BITS_TO_BYTES(type->container_bitsz);
+		params[num_params] = param;
+		num_params++;
+	}
+
+	act_bpf = kzalloc(sizeof(*act_bpf), GFP_KERNEL);
+	if (!act_bpf)
+		return ERR_PTR(-ENOMEM);
+
+	act_bpf->act_id = p4act->act_id;
+	params_cursor = (u8 *)act_bpf + sizeof(act_bpf->act_id);
+	for (i = 0; i < num_params; i++) {
+		const struct p4tc_act_param *param = params[i];
+		const struct p4tc_type *type = param->type;
+		const u32 type_bytesz = BITS_TO_BYTES(type->container_bitsz);
+
+		memcpy(params_cursor, param->value, type_bytesz);
+		params_cursor += type_bytesz;
+	}
+
+	return act_bpf;
+}
+#endif
+
 static int tcf_table_entry_cu(struct sk_buff *skb, struct net *net, u32 flags,
 			      struct nlattr *arg, u32 *ids,
 			      struct p4tc_nl_pname *nl_pname,
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index e8f2ad250256..8e9d3cda44a3 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -42,7 +42,9 @@ static bool obj_is_valid(u32 obj)
 {
 	switch (obj) {
 	case P4TC_OBJ_PIPELINE:
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	case P4TC_OBJ_META:
+#endif
 	case P4TC_OBJ_HDR_FIELD:
 	case P4TC_OBJ_ACT:
 	case P4TC_OBJ_TABLE:
@@ -55,7 +57,9 @@ static bool obj_is_valid(u32 obj)
 
 static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_PIPELINE] = &p4tc_pipeline_ops,
+#ifndef CONFIG_NET_P4_TC_KFUNCS
 	[P4TC_OBJ_META] = &p4tc_meta_ops,
+#endif
 	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
 	[P4TC_OBJ_ACT] = &p4tc_act_ops,
 	[P4TC_OBJ_TABLE] = &p4tc_table_ops,
@@ -576,6 +580,9 @@ static int __init p4tc_template_init(void)
 	for (obj = P4TC_OBJ_PIPELINE; obj < P4TC_OBJ_MAX; obj++) {
 		const struct p4tc_template_ops *op = p4tc_ops[obj];
 
+		if (!op)
+			continue;
+
 		if (!obj_is_valid(obj))
 			continue;
 
@@ -583,6 +590,8 @@ static int __init p4tc_template_init(void)
 			op->init();
 	}
 
+	register_p4tc_tbl_bpf();
+
 	return 0;
 }
 
-- 
2.25.1


