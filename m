Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 713316E8A0
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfGSQUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:20:38 -0400
Received: from mail.us.es ([193.147.175.20]:42874 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729186AbfGSQUg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:20:36 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 26EA0C1A6A
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:20:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1530F115110
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 18:20:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0764D115108; Fri, 19 Jul 2019 18:20:32 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B59FEDA732;
        Fri, 19 Jul 2019 18:20:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 19 Jul 2019 18:20:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [47.60.47.94])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id ED01B4265A31;
        Fri, 19 Jul 2019 18:20:28 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jiri@resnulli.us,
        jakub.kicinski@netronome.com, pshelar@ovn.org
Subject: [PATCH nf,v5 3/4] net: flow_offload: rename tc_setup_cb_t to flow_setup_cb_t
Date:   Fri, 19 Jul 2019 18:20:15 +0200
Message-Id: <20190719162016.10243-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190719162016.10243-1-pablo@netfilter.org>
References: <20190719162016.10243-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rename this type definition and adapt users.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
v5: add #include <linux/list.h> to include/net/netfilter/nf_tables_offload.h
    to fix CONFIG_HEADER_TEST=y - David Miller.

 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c          |  2 +-
 include/net/flow_offload.h                     | 17 +++++++++++------
 include/net/pkt_cls.h                          |  5 ++---
 include/net/sch_generic.h                      |  6 ++----
 net/core/flow_offload.c                        |  9 +++++----
 net/dsa/slave.c                                |  2 +-
 net/sched/cls_api.c                            |  2 +-
 net/sched/cls_bpf.c                            |  2 +-
 net/sched/cls_flower.c                         |  2 +-
 net/sched/cls_matchall.c                       |  2 +-
 net/sched/cls_u32.c                            |  6 +++---
 12 files changed, 30 insertions(+), 27 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a469035400cf..51cd0b6f1f3e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1679,7 +1679,7 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
-	tc_setup_cb_t *cb;
+	flow_setup_cb_t *cb;
 	bool ingress;
 	int err;
 
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index abbcb66bf5ac..fba9512e9ca6 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -134,7 +134,7 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 				 struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
-	tc_setup_cb_t *cb;
+	flow_setup_cb_t *cb;
 	int err;
 
 	netdev_dbg(port->dev, "tc_block command %d, binder_type %d\n",
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index aa9b5287b231..23b299235baf 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -2,8 +2,8 @@
 #define _NET_FLOW_OFFLOAD_H
 
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <net/flow_dissector.h>
-#include <net/sch_generic.h>
 
 struct flow_match {
 	struct flow_dissector	*dissector;
@@ -261,23 +261,27 @@ struct flow_block_offload {
 	struct netlink_ext_ack *extack;
 };
 
+enum tc_setup_type;
+typedef int flow_setup_cb_t(enum tc_setup_type type, void *type_data,
+			    void *cb_priv);
+
 struct flow_block_cb {
 	struct list_head	driver_list;
 	struct list_head	list;
-	tc_setup_cb_t		*cb;
+	flow_setup_cb_t		*cb;
 	void			*cb_ident;
 	void			*cb_priv;
 	void			(*release)(void *cb_priv);
 	unsigned int		refcnt;
 };
 
-struct flow_block_cb *flow_block_cb_alloc(tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv));
 void flow_block_cb_free(struct flow_block_cb *block_cb);
 
 struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *offload,
-					   tc_setup_cb_t *cb, void *cb_ident);
+					   flow_setup_cb_t *cb, void *cb_ident);
 
 void *flow_block_cb_priv(struct flow_block_cb *block_cb);
 void flow_block_cb_incref(struct flow_block_cb *block_cb);
@@ -295,11 +299,12 @@ static inline void flow_block_cb_remove(struct flow_block_cb *block_cb,
 	list_move(&block_cb->list, &offload->cb_list);
 }
 
-bool flow_block_cb_is_busy(tc_setup_cb_t *cb, void *cb_ident,
+bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
 			   struct list_head *driver_block_list);
 
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
-			       struct list_head *driver_list, tc_setup_cb_t *cb,
+			       struct list_head *driver_list,
+			       flow_setup_cb_t *cb,
 			       void *cb_ident, void *cb_priv, bool ingress_only);
 
 enum flow_cls_command {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 841faadceb6e..e429809ca90d 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -6,7 +6,6 @@
 #include <linux/workqueue.h>
 #include <net/sch_generic.h>
 #include <net/act_api.h>
-#include <net/flow_offload.h>
 #include <net/net_namespace.h>
 
 /* TC action not accessible from user space */
@@ -126,14 +125,14 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 }
 
 static inline
-int tc_setup_cb_block_register(struct tcf_block *block, tc_setup_cb_t *cb,
+int tc_setup_cb_block_register(struct tcf_block *block, flow_setup_cb_t *cb,
 			       void *cb_priv)
 {
 	return 0;
 }
 
 static inline
-void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
+void tc_setup_cb_block_unregister(struct tcf_block *block, flow_setup_cb_t *cb,
 				  void *cb_priv)
 {
 }
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 855167bbc372..9482e060483b 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -15,6 +15,7 @@
 #include <linux/mutex.h>
 #include <net/gen_stats.h>
 #include <net/rtnetlink.h>
+#include <net/flow_offload.h>
 
 struct Qdisc_ops;
 struct qdisc_walker;
@@ -22,9 +23,6 @@ struct tcf_walker;
 struct module;
 struct bpf_flow_keys;
 
-typedef int tc_setup_cb_t(enum tc_setup_type type,
-			  void *type_data, void *cb_priv);
-
 typedef int tc_indr_block_bind_cb_t(struct net_device *dev, void *cb_priv,
 				    enum tc_setup_type type, void *type_data);
 
@@ -313,7 +311,7 @@ struct tcf_proto_ops {
 	void			(*walk)(struct tcf_proto *tp,
 					struct tcf_walker *arg, bool rtnl_held);
 	int			(*reoffload)(struct tcf_proto *tp, bool add,
-					     tc_setup_cb_t *cb, void *cb_priv,
+					     flow_setup_cb_t *cb, void *cb_priv,
 					     struct netlink_ext_ack *extack);
 	void			(*bind_class)(void *, u32, unsigned long);
 	void *			(*tmplt_create)(struct net *net,
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 507de4b48815..a800fa78d96c 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -165,7 +165,7 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
 
-struct flow_block_cb *flow_block_cb_alloc(tc_setup_cb_t *cb,
+struct flow_block_cb *flow_block_cb_alloc(flow_setup_cb_t *cb,
 					  void *cb_ident, void *cb_priv,
 					  void (*release)(void *cb_priv))
 {
@@ -194,7 +194,7 @@ void flow_block_cb_free(struct flow_block_cb *block_cb)
 EXPORT_SYMBOL(flow_block_cb_free);
 
 struct flow_block_cb *flow_block_cb_lookup(struct flow_block_offload *f,
-					   tc_setup_cb_t *cb, void *cb_ident)
+					   flow_setup_cb_t *cb, void *cb_ident)
 {
 	struct flow_block_cb *block_cb;
 
@@ -226,7 +226,7 @@ unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
 }
 EXPORT_SYMBOL(flow_block_cb_decref);
 
-bool flow_block_cb_is_busy(tc_setup_cb_t *cb, void *cb_ident,
+bool flow_block_cb_is_busy(flow_setup_cb_t *cb, void *cb_ident,
 			   struct list_head *driver_block_list)
 {
 	struct flow_block_cb *block_cb;
@@ -243,7 +243,8 @@ EXPORT_SYMBOL(flow_block_cb_is_busy);
 
 int flow_block_cb_setup_simple(struct flow_block_offload *f,
 			       struct list_head *driver_block_list,
-			       tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
+			       flow_setup_cb_t *cb,
+			       void *cb_ident, void *cb_priv,
 			       bool ingress_only)
 {
 	struct flow_block_cb *block_cb;
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 6ca9ec58f881..d697a64fb564 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -951,7 +951,7 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 				    struct flow_block_offload *f)
 {
 	struct flow_block_cb *block_cb;
-	tc_setup_cb_t *cb;
+	flow_setup_cb_t *cb;
 
 	if (f->binder_type == FLOW_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		cb = dsa_slave_setup_tc_block_cb_ig;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index d144233423c5..78f0f2815b8c 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1514,7 +1514,7 @@ void tcf_block_put(struct tcf_block *block)
 EXPORT_SYMBOL(tcf_block_put);
 
 static int
-tcf_block_playback_offloads(struct tcf_block *block, tc_setup_cb_t *cb,
+tcf_block_playback_offloads(struct tcf_block *block, flow_setup_cb_t *cb,
 			    void *cb_priv, bool add, bool offload_in_use,
 			    struct netlink_ext_ack *extack)
 {
diff --git a/net/sched/cls_bpf.c b/net/sched/cls_bpf.c
index 691f71830134..3f7a9c02b70c 100644
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@ -651,7 +651,7 @@ static void cls_bpf_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	}
 }
 
-static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
+static int cls_bpf_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			     void *cb_priv, struct netlink_ext_ack *extack)
 {
 	struct cls_bpf_head *head = rtnl_dereference(tp->root);
diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 38d6e85693fc..054123742e32 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1800,7 +1800,7 @@ fl_get_next_hw_filter(struct tcf_proto *tp, struct cls_fl_filter *f, bool add)
 	return NULL;
 }
 
-static int fl_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
+static int fl_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			void *cb_priv, struct netlink_ext_ack *extack)
 {
 	struct tcf_block *block = tp->chain->block;
diff --git a/net/sched/cls_matchall.c b/net/sched/cls_matchall.c
index a30d2f8feb32..455ea2793f9b 100644
--- a/net/sched/cls_matchall.c
+++ b/net/sched/cls_matchall.c
@@ -282,7 +282,7 @@ static void mall_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 	arg->count++;
 }
 
-static int mall_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
+static int mall_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			  void *cb_priv, struct netlink_ext_ack *extack)
 {
 	struct cls_mall_head *head = rtnl_dereference(tp->root);
diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index be9e46c77e8b..8614088edd1b 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1152,7 +1152,7 @@ static void u32_walk(struct tcf_proto *tp, struct tcf_walker *arg,
 }
 
 static int u32_reoffload_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
-			       bool add, tc_setup_cb_t *cb, void *cb_priv,
+			       bool add, flow_setup_cb_t *cb, void *cb_priv,
 			       struct netlink_ext_ack *extack)
 {
 	struct tc_cls_u32_offload cls_u32 = {};
@@ -1172,7 +1172,7 @@ static int u32_reoffload_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 }
 
 static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
-			       bool add, tc_setup_cb_t *cb, void *cb_priv,
+			       bool add, flow_setup_cb_t *cb, void *cb_priv,
 			       struct netlink_ext_ack *extack)
 {
 	struct tc_u_hnode *ht = rtnl_dereference(n->ht_down);
@@ -1213,7 +1213,7 @@ static int u32_reoffload_knode(struct tcf_proto *tp, struct tc_u_knode *n,
 	return 0;
 }
 
-static int u32_reoffload(struct tcf_proto *tp, bool add, tc_setup_cb_t *cb,
+static int u32_reoffload(struct tcf_proto *tp, bool add, flow_setup_cb_t *cb,
 			 void *cb_priv, struct netlink_ext_ack *extack)
 {
 	struct tc_u_common *tp_c = tp->data;
-- 
2.11.0


