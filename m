Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4209F4DAA6
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbfFTTuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:50:02 -0400
Received: from mail.us.es ([193.147.175.20]:54680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726965AbfFTTt7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7088BB5ABD
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D84ADA712
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5ABC3DA711; Thu, 20 Jun 2019 21:49:54 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E6D6DA701;
        Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D7F6B4265A2F;
        Thu, 20 Jun 2019 21:49:42 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        cphealy@gmail.com
Subject: [PATCH net-next 10/12] net: flow_offload: add flow_block_cb API
Date:   Thu, 20 Jun 2019 21:49:15 +0200
Message-Id: <20190620194917.2298-11-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch renames:

* struct tcf_block_cb to flow_block_cb.
* struct tc_block_offload to flow_block_offload.

And it exposes the flow_block_cb API through net/flow_offload.h. This
renames the existing codebase to adapt it to this name.

This patch also adds flow_block_cb_splice().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c      |   6 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   6 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   6 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c        |   6 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |   5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  28 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c     |  61 ++++----
 drivers/net/ethernet/mscc/ocelot_ace.h             |   4 +-
 drivers/net/ethernet/mscc/ocelot_flower.c          |  34 ++---
 drivers/net/ethernet/mscc/ocelot_tc.c              |  14 +-
 drivers/net/ethernet/netronome/nfp/abm/cls.c       |   6 +-
 drivers/net/ethernet/netronome/nfp/abm/main.h      |   2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c      |   6 +-
 .../net/ethernet/netronome/nfp/flower/offload.c    |  42 +++---
 drivers/net/ethernet/qlogic/qede/qede_main.c       |   6 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   6 +-
 drivers/net/netdevsim/netdev.c                     |   6 +-
 include/net/flow_offload.h                         |  52 +++++++
 include/net/pkt_cls.h                              |  96 +------------
 net/core/flow_offload.c                            | 115 +++++++++++++++
 net/dsa/slave.c                                    |  12 +-
 net/sched/cls_api.c                                | 158 +++------------------
 25 files changed, 328 insertions(+), 367 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 2ce11fc01a07..f5d492a03317 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9854,9 +9854,9 @@ static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       bnxt_setup_tc_block_cb, bp, bp,
-					       true);
+		return flow_block_setup_offload(type_data,
+						bnxt_setup_tc_block_cb, bp, bp,
+						true);
 	case TC_SETUP_QDISC_MQPRIO: {
 		struct tc_mqprio_qopt *mqprio = type_data;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index c8bb104f28d4..1b78615a1384 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -168,9 +168,9 @@ static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       bnxt_vf_rep_setup_tc_block_cb,
-					       vf_rep, vf_rep, true);
+		return flow_block_setup_offload(type_data,
+						bnxt_vf_rep_setup_tc_block_cb,
+						vf_rep, vf_rep, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 075e4a0d20b0..d516792b10f6 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3191,9 +3191,9 @@ static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       cxgb_setup_tc_block_cb, pi, dev,
-					       true);
+		return flow_block_setup_offload(type_data,
+						cxgb_setup_tc_block_cb, pi, dev,
+						true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 89af0dc55d6d..01a0220e3235 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7651,9 +7651,9 @@ static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       i40e_setup_tc_block_cb, np, np,
-					       true);
+		return flow_block_setup_offload(type_data,
+						i40e_setup_tc_block_cb, np, np,
+						true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 29640e4b15f2..8ef6aca34edd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3133,9 +3133,9 @@ static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       iavf_setup_tc_block_cb, adapter,
-					       adapter, true);
+		return flow_block_setup_offload(type_data,
+						iavf_setup_tc_block_cb, adapter,
+						adapter, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03fd960b58c5..892705a6f81b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2815,8 +2815,9 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data, igb_setup_tc_block_cb,
-					       adapter, adapter, true);
+		return flow_block_setup_offload(type_data,
+						igb_setup_tc_block_cb,
+						adapter, adapter, true);
 
 	case TC_SETUP_QDISC_ETF:
 		return igb_offload_txtime(adapter, type_data);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7d3fe89ce807..144f2cca686a 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9621,9 +9621,9 @@ static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       ixgbe_setup_tc_block_cb,
-					       adapter, adapter, true);
+		return flow_block_setup_offload(type_data,
+						ixgbe_setup_tc_block_cb,
+						adapter, adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		return ixgbe_setup_tc_mqprio(dev, type_data);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index a0c1a389db53..c1021153facd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3355,9 +3355,9 @@ static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       mlx5e_setup_tc_block_cb,
-					       priv, priv, true);
+		return flow_block_setup_offload(type_data,
+						mlx5e_setup_tc_block_cb,
+						priv, priv, true);
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(dev, type_data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 9507334b9d77..1e36f16cba00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -714,10 +714,10 @@ static void mlx5e_rep_indr_tc_block_unbind(void *cb_priv)
 static int
 mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 			      struct mlx5e_rep_priv *rpriv,
-			      struct tc_block_offload *f)
+			      struct flow_block_offload *f)
 {
 	struct mlx5e_rep_indr_block_priv *indr_priv;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -737,16 +737,16 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		list_add(&indr_priv->list,
 			 &rpriv->uplink_priv.tc_indr_block_priv_list);
 
-		block_cb = tcf_block_cb_alloc(f->net,
-					      mlx5e_rep_indr_setup_block_cb,
-					      indr_priv, indr_priv,
-					      mlx5e_rep_indr_tc_block_unbind);
+		block_cb = flow_block_cb_alloc(f->net,
+					       mlx5e_rep_indr_setup_block_cb,
+					       indr_priv, indr_priv,
+					       mlx5e_rep_indr_tc_block_unbind);
 		if (!block_cb) {
 			list_del(&indr_priv->list);
 			kfree(indr_priv);
 			return -ENOMEM;
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 
 		return 0;
 	case TC_BLOCK_UNBIND:
@@ -754,13 +754,13 @@ mlx5e_rep_indr_setup_tc_block(struct net_device *netdev,
 		if (!indr_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(f->net,
-					       mlx5e_rep_indr_setup_block_cb,
-					       indr_priv);
+		block_cb = flow_block_cb_lookup(f->net,
+						mlx5e_rep_indr_setup_block_cb,
+						indr_priv);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1206,9 +1206,9 @@ static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       mlx5e_rep_setup_tc_cb,
-					       priv, priv, true);
+		return flow_block_setup_offload(type_data,
+						mlx5e_rep_setup_tc_cb,
+						priv, priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index dbd31f4acb70..0340717aab93 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1563,25 +1563,25 @@ static void mlxsw_sp_tc_block_flower_release(void *cb_priv)
 
 static int
 mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
-			            struct tc_block_offload *f, bool ingress)
+			            struct flow_block_offload *f, bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	bool register_block = false;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->net,
-				       mlxsw_sp_setup_tc_block_cb_flower,
-				       mlxsw_sp);
+	block_cb = flow_block_cb_lookup(f->net,
+					mlxsw_sp_setup_tc_block_cb_flower,
+					mlxsw_sp);
 	if (!block_cb) {
 		acl_block = mlxsw_sp_acl_block_create(mlxsw_sp, f->net);
 		if (!acl_block)
 			return -ENOMEM;
-		block_cb = tcf_block_cb_alloc(f->net,
-					      mlxsw_sp_setup_tc_block_cb_flower,
-					      mlxsw_sp, acl_block,
-					      mlxsw_sp_tc_block_flower_release);
+		block_cb = flow_block_cb_alloc(f->net,
+					       mlxsw_sp_setup_tc_block_cb_flower,
+					       mlxsw_sp, acl_block,
+					       mlxsw_sp_tc_block_flower_release);
 		if (!block_cb) {
 			mlxsw_sp_acl_block_destroy(acl_block);
 			err = -ENOMEM;
@@ -1589,9 +1589,9 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 		}
 		register_block = true;
 	} else {
-		acl_block = tcf_block_cb_priv(block_cb);
+		acl_block = flow_block_cb_priv(block_cb);
 	}
-	tcf_block_cb_incref(block_cb);
+	flow_block_cb_incref(block_cb);
 	err = mlxsw_sp_acl_block_bind(mlxsw_sp, acl_block,
 				      mlxsw_sp_port, ingress);
 	if (err)
@@ -1603,29 +1603,30 @@ mlxsw_sp_setup_tc_block_flower_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_port->eg_acl_block = acl_block;
 
 	if (register_block)
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 
 	return 0;
 
 err_block_bind:
-	if (!tcf_block_cb_decref(block_cb))
-		tcf_block_cb_free(block_cb);
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_free(block_cb);
 err_cb_register:
 	return err;
 }
 
 static void
 mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
-				      struct tc_block_offload *f, bool ingress)
+				      struct flow_block_offload *f,
+				      bool ingress)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	struct mlxsw_sp_acl_block *acl_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int err;
 
-	block_cb = tcf_block_cb_lookup(f->net,
-				       mlxsw_sp_setup_tc_block_cb_flower,
-				       mlxsw_sp);
+	block_cb = flow_block_cb_lookup(f->net,
+					mlxsw_sp_setup_tc_block_cb_flower,
+					mlxsw_sp);
 	if (!block_cb)
 		return;
 
@@ -1634,17 +1635,17 @@ mlxsw_sp_setup_tc_block_flower_unbind(struct mlxsw_sp_port *mlxsw_sp_port,
 	else
 		mlxsw_sp_port->eg_acl_block = NULL;
 
-	acl_block = tcf_block_cb_priv(block_cb);
+	acl_block = flow_block_cb_priv(block_cb);
 	err = mlxsw_sp_acl_block_unbind(mlxsw_sp, acl_block,
 					mlxsw_sp_port, ingress);
-	if (!err && !tcf_block_cb_decref(block_cb))
-		tcf_block_cb_remove(block_cb, f);
+	if (!err && !flow_block_cb_decref(block_cb))
+		flow_block_cb_remove(block_cb, f);
 }
 
 static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct tc_block_offload *f)
+				   struct flow_block_offload *f)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	bool ingress;
 	int err;
@@ -1661,26 +1662,26 @@ static int mlxsw_sp_setup_tc_block(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->net, cb, mlxsw_sp_port,
-					      mlxsw_sp_port, NULL);
+		block_cb = flow_block_cb_alloc(f->net, cb, mlxsw_sp_port,
+					       mlxsw_sp_port, NULL);
 		if (!block_cb)
 			return -ENOMEM;
 		err = mlxsw_sp_setup_tc_block_flower_bind(mlxsw_sp_port, f,
 							  ingress);
 		if (err) {
-			tcf_block_cb_free(block_cb);
+			flow_block_cb_free(block_cb);
 			return err;
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		mlxsw_sp_setup_tc_block_flower_unbind(mlxsw_sp_port,
 						      f, ingress);
-		block_cb = tcf_block_cb_lookup(f->net, cb, mlxsw_sp_port);
+		block_cb = flow_block_cb_lookup(f->net, cb, mlxsw_sp_port);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/mscc/ocelot_ace.h b/drivers/net/ethernet/mscc/ocelot_ace.h
index d621683643e1..e98944c87259 100644
--- a/drivers/net/ethernet/mscc/ocelot_ace.h
+++ b/drivers/net/ethernet/mscc/ocelot_ace.h
@@ -225,8 +225,8 @@ int ocelot_ace_init(struct ocelot *ocelot);
 void ocelot_ace_deinit(void);
 
 int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
-				      struct tc_block_offload *f);
+				      struct flow_block_offload *f);
 void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
-					 struct tc_block_offload *f);
+					 struct flow_block_offload *f);
 
 #endif /* _MSCC_OCELOT_ACE_H_ */
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index ca6751d0b797..fa5a3bf22ede 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -307,36 +307,36 @@ static void ocelot_tc_block_unbind(void *cb_priv)
 }
 
 int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
-				      struct tc_block_offload *f)
+				      struct flow_block_offload *f)
 {
 	struct ocelot_port_block *port_block;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int ret;
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
 		return -EOPNOTSUPP;
 
-	block_cb = tcf_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
-				       port);
+	block_cb = flow_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+					port);
 	if (!block_cb) {
 		port_block = ocelot_port_block_create(port);
 		if (!port_block)
 			return -ENOMEM;
 
-		block_cb = tcf_block_cb_alloc(f->net,
-					      ocelot_setup_tc_block_cb_flower,
-					      port, port_block,
-					      ocelot_tc_block_unbind);
+		block_cb = flow_block_cb_alloc(f->net,
+					       ocelot_setup_tc_block_cb_flower,
+					       port, port_block,
+					       ocelot_tc_block_unbind);
 		if (!block_cb) {
 			ret = -ENOMEM;
 			goto err_cb_register;
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 	} else {
-		port_block = tcf_block_cb_priv(block_cb);
+		port_block = flow_block_cb_priv(block_cb);
 	}
 
-	tcf_block_cb_incref(block_cb);
+	flow_block_cb_incref(block_cb);
 	return 0;
 
 err_cb_register:
@@ -346,15 +346,15 @@ int ocelot_setup_tc_block_flower_bind(struct ocelot_port *port,
 }
 
 void ocelot_setup_tc_block_flower_unbind(struct ocelot_port *port,
-					 struct tc_block_offload *f)
+					 struct flow_block_offload *f)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
-	block_cb = tcf_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
-				       port);
+	block_cb = flow_block_cb_lookup(f->net, ocelot_setup_tc_block_cb_flower,
+					port);
 	if (!block_cb)
 		return;
 
-	if (!tcf_block_cb_decref(block_cb))
-		tcf_block_cb_remove(block_cb, f);
+	if (!flow_block_cb_decref(block_cb))
+		flow_block_cb_remove(block_cb, f);
 }
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index 1a2ec5eb65a5..2c6eccab6547 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -129,9 +129,9 @@ static int ocelot_setup_tc_block_cb_eg(enum tc_setup_type type,
 }
 
 static int ocelot_setup_tc_block(struct ocelot_port *port,
-				 struct tc_block_offload *f)
+				 struct flow_block_offload *f)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 	int err;
 
@@ -149,24 +149,24 @@ static int ocelot_setup_tc_block(struct ocelot_port *port,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->net, cb, port, port, NULL);
+		block_cb = flow_block_cb_alloc(f->net, cb, port, port, NULL);
 		if (!block_cb)
 			return -ENOMEM;
 
 		err = ocelot_setup_tc_block_flower_bind(port, f);
 		if (err < 0) {
-			tcf_block_cb_free(block_cb);
+			flow_block_cb_free(block_cb);
 			return err;
 		}
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->net, cb, port);
+		block_cb = flow_block_cb_lookup(f->net, cb, port);
 		if (!block_cb)
 			return -ENOENT;
 
 		ocelot_setup_tc_block_flower_unbind(port, f);
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index d99981ec04a3..96b89a7c468b 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -263,8 +263,8 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 }
 
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
-			    struct tc_block_offload *f)
+			    struct flow_block_offload *f)
 {
-	return tcf_setup_block_offload(f, nfp_abm_setup_tc_block_cb, repr, repr,
-				       true);
+	return flow_block_setup_offload(f, nfp_abm_setup_tc_block_cb,
+					repr, repr, true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/abm/main.h b/drivers/net/ethernet/netronome/nfp/abm/main.h
index 49749c60885e..48746c9c6224 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/main.h
+++ b/drivers/net/ethernet/netronome/nfp/abm/main.h
@@ -247,7 +247,7 @@ int nfp_abm_setup_tc_mq(struct net_device *netdev, struct nfp_abm_link *alink,
 int nfp_abm_setup_tc_gred(struct net_device *netdev, struct nfp_abm_link *alink,
 			  struct tc_gred_qopt_offload *opt);
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
-			    struct tc_block_offload *opt);
+			    struct flow_block_offload *opt);
 
 int nfp_abm_ctrl_read_params(struct nfp_abm_link *alink);
 int nfp_abm_ctrl_find_addrs(struct nfp_abm *abm);
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index fac38899dc23..3897cc4f7a7e 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -167,9 +167,9 @@ static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       nfp_bpf_setup_tc_block_cb,
-					       nn, nn, true);
+		return flow_block_setup_offload(type_data,
+						nfp_bpf_setup_tc_block_cb,
+						nn, nn, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 297ee0a9c194..89ea95a0d554 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1260,11 +1260,11 @@ static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 }
 
 static int nfp_flower_setup_tc_block(struct net_device *netdev,
-				     struct tc_block_offload *f)
+				     struct flow_block_offload *f)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
 	struct nfp_flower_repr_priv *repr_priv;
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
 		return -EOPNOTSUPP;
@@ -1274,22 +1274,22 @@ static int nfp_flower_setup_tc_block(struct net_device *netdev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->net,
-					      nfp_flower_setup_tc_block_cb,
-					      repr, repr, NULL);
+		block_cb = flow_block_cb_alloc(f->net,
+					       nfp_flower_setup_tc_block_cb,
+					       repr, repr, NULL);
 		if (!block_cb)
 			return -ENOMEM;
 
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->net,
-					       nfp_flower_setup_tc_block_cb,
-					       repr);
+		block_cb = flow_block_cb_lookup(f->net,
+						nfp_flower_setup_tc_block_cb,
+						repr);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
@@ -1358,12 +1358,12 @@ static void nfp_flower_setup_indr_tc_release(void *cb_priv)
 
 static int
 nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
-			       struct tc_block_offload *f)
+			       struct flow_block_offload *f)
 {
 	struct nfp_flower_indr_block_cb_priv *cb_priv;
 	struct nfp_flower_priv *priv = app->priv;
 	struct net *net = dev_net(netdev);
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 
 	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
 	    !(f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS &&
@@ -1380,30 +1380,30 @@ nfp_flower_setup_indr_tc_block(struct net_device *netdev, struct nfp_app *app,
 		cb_priv->app = app;
 		list_add(&cb_priv->list, &priv->indr_block_cb_priv);
 
-		block_cb = tcf_block_cb_alloc(net,
-					      nfp_flower_setup_indr_block_cb,
-					      cb_priv, cb_priv,
-					      nfp_flower_setup_indr_tc_release);
+		block_cb = flow_block_cb_alloc(net,
+					       nfp_flower_setup_indr_block_cb,
+					       cb_priv, cb_priv,
+					       nfp_flower_setup_indr_tc_release);
 		if (!block_cb) {
 			list_del(&cb_priv->list);
 			kfree(cb_priv);
 			return -ENOMEM;
 		}
 
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
 		cb_priv = nfp_flower_indr_block_cb_priv_lookup(app, netdev);
 		if (!cb_priv)
 			return -ENOENT;
 
-		block_cb = tcf_block_cb_lookup(net,
-					       nfp_flower_setup_indr_block_cb,
-					       cb_priv);
+		block_cb = flow_block_cb_lookup(net,
+						nfp_flower_setup_indr_block_cb,
+						cb_priv);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 013046a30732..00db21d9407f 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -588,9 +588,9 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       qede_setup_tc_block_cb,
-					       edev, edev, true);
+		return flow_block_setup_offload(type_data,
+						qede_setup_tc_block_cb,
+						edev, edev, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		mqprio = type_data;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 154bd8aa1cbc..ca442a7a30ec 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3781,9 +3781,9 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       stmmac_setup_tc_block_cb,
-					       priv, priv, true);
+		return flow_block_setup_offload(type_data,
+						stmmac_setup_tc_block_cb,
+						priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	default:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 240727623e9b..710b03fc8db1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -210,9 +210,9 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return tcf_setup_block_offload(type_data,
-					       nsim_setup_tc_block_cb, ns, ns,
-					       true);
+		return flow_block_setup_offload(type_data,
+						nsim_setup_tc_block_cb, ns, ns,
+						true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 36127c1858a4..728ded7e4361 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -232,4 +232,56 @@ static inline void flow_stats_update(struct flow_stats *flow_stats,
 	flow_stats->lastused	= max_t(u64, flow_stats->lastused, lastused);
 }
 
+#include <net/sch_generic.h> /* for tc_setup_cb_t. */
+
+enum flow_block_command {
+	TC_BLOCK_BIND,
+	TC_BLOCK_UNBIND,
+};
+
+enum flow_block_binder_type {
+	TCF_BLOCK_BINDER_TYPE_UNSPEC,
+	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
+	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
+};
+
+struct flow_block_offload {
+	enum flow_block_command command;
+	enum flow_block_binder_type binder_type;
+	struct list_head cb_list;
+	struct net *net;
+	bool block_shared;
+	struct netlink_ext_ack *extack;
+};
+
+struct flow_block_cb {
+	struct list_head global_list;
+	struct list_head list;
+	struct net *net;
+	tc_setup_cb_t *cb;
+	void (*release)(void *cb_priv);
+	void *cb_ident;
+	void *cb_priv;
+	u32 block_index;
+	unsigned int refcnt;
+};
+
+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv));
+void flow_block_cb_free(struct flow_block_cb *block_cb);
+void *flow_block_cb_priv(struct flow_block_cb *block_cb);
+struct flow_block_cb *flow_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
+					   void *cb_ident);
+void flow_block_cb_incref(struct flow_block_cb *block_cb);
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb);
+void flow_block_cb_add(struct flow_block_cb *block_cb,
+		       struct flow_block_offload *offload);
+void flow_block_cb_remove(struct flow_block_cb *block_cb,
+			  struct flow_block_offload *offload);
+void flow_block_cb_splice(struct flow_block_offload *offload);
+
+int flow_block_setup_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
+			     void *cb_ident, void *cb_priv, bool ingress_only);
+
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 0328556e49bf..471d58380bd5 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -26,14 +26,8 @@ struct tcf_walker {
 int register_tcf_proto_ops(struct tcf_proto_ops *ops);
 int unregister_tcf_proto_ops(struct tcf_proto_ops *ops);
 
-enum tcf_block_binder_type {
-	TCF_BLOCK_BINDER_TYPE_UNSPEC,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
-	TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS,
-};
-
 struct tcf_block_ext_info {
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 	tcf_chain_head_change_t *chain_head_change;
 	void *chain_head_change_priv;
 	u32 block_index;
@@ -72,23 +66,6 @@ static inline struct Qdisc *tcf_block_q(struct tcf_block *block)
 	return block->q;
 }
 
-struct tcf_block_cb *tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv,
-					void (*release)(void *cb_priv));
-void tcf_block_cb_free(struct tcf_block_cb *block_cb);
-
-struct tc_block_offload;
-void tcf_block_cb_add(struct tcf_block_cb *block_cb,
-		      struct tc_block_offload *offload);
-void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
-			 struct tc_block_offload *offload);
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb);
-struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
-					 void *cb_ident);
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb);
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb);
-
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident);
 int tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
@@ -100,9 +77,6 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
 
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
-
-int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
-			    void *cb_ident, void *cb_priv, bool ingress_only);
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
@@ -153,60 +127,6 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
 {
 }
 
-static inline int tcf_setup_block_offload(struct tc_block_offload *f,
-					  tc_setup_cb_t *cb,
-					  void *cb_ident, void *cb_priv,
-					  bool ingress_only)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline struct tcf_block_cb *
-tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb, void *cb_ident,
-		   void *cb_priv, void (*release)(void *cb_priv))
-{
-	return NULL;
-}
-
-static inline void tcf_block_cb_free(struct tcf_block_cb *block_cb)
-{
-}
-
-struct tc_block_offload;
-static inline void tcf_block_cb_add(struct tcf_block_cb *block_cb,
-				    struct tc_block_offload *offload)
-{
-}
-
-static inline void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
-				       struct tc_block_offload *offload)
-{
-}
-
-static inline
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return NULL;
-}
-
-static inline
-struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, struct tcf_block *block,
-					 tc_setup_cb_t *cb, void *cb_ident)
-{
-	return NULL;
-}
-
-static inline
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-}
-
-static inline
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return 0;
-}
-
 static inline
 int __tc_indr_block_cb_register(struct net_device *dev, void *cb_priv,
 				tc_indr_block_bind_cb_t *cb, void *cb_ident)
@@ -614,19 +534,7 @@ int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop);
 unsigned int tcf_exts_num_actions(struct tcf_exts *exts);
 
-enum tc_block_command {
-	TC_BLOCK_BIND,
-	TC_BLOCK_UNBIND,
-};
-
-struct tc_block_offload {
-	enum tc_block_command command;
-	enum tcf_block_binder_type binder_type;
-	struct list_head cb_list;
-	struct net *net;
-	bool block_shared;
-	struct netlink_ext_ack *extack;
-};
+struct flow_block_offload;
 
 struct tc_cls_common_offload {
 	u32 chain_index;
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index f52fe0bc4017..1a585676ca79 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -164,3 +164,118 @@ void flow_rule_match_enc_opts(const struct flow_rule *rule,
 	FLOW_DISSECTOR_MATCH(rule, FLOW_DISSECTOR_KEY_ENC_OPTS, out);
 }
 EXPORT_SYMBOL(flow_rule_match_enc_opts);
+
+void *flow_block_cb_priv(struct flow_block_cb *block_cb)
+{
+	return block_cb->cb_priv;
+}
+EXPORT_SYMBOL(flow_block_cb_priv);
+
+static LIST_HEAD(flow_block_cb_list);
+
+struct flow_block_cb *flow_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
+					   void *cb_ident)
+{
+	struct flow_block_cb *block_cb;
+
+	list_for_each_entry(block_cb, &flow_block_cb_list, global_list) {
+		if (block_cb->net == net &&
+		    block_cb->cb == cb &&
+		    block_cb->cb_ident == cb_ident)
+			return block_cb;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(flow_block_cb_lookup);
+
+void flow_block_cb_incref(struct flow_block_cb *block_cb)
+{
+	block_cb->refcnt++;
+}
+EXPORT_SYMBOL(flow_block_cb_incref);
+
+unsigned int flow_block_cb_decref(struct flow_block_cb *block_cb)
+{
+	return --block_cb->refcnt;
+}
+EXPORT_SYMBOL(flow_block_cb_decref);
+
+struct flow_block_cb *flow_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  void (*release)(void *cb_priv))
+{
+	struct flow_block_cb *block_cb;
+
+	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
+	if (!block_cb)
+		return NULL;
+
+	block_cb->net = net;
+	block_cb->cb = cb;
+	block_cb->cb_ident = cb_ident;
+	block_cb->release = release;
+	block_cb->cb_priv = cb_priv;
+
+	return block_cb;
+}
+EXPORT_SYMBOL(flow_block_cb_alloc);
+
+void flow_block_cb_free(struct flow_block_cb *block_cb)
+{
+	if (block_cb->release)
+		block_cb->release(block_cb->cb_priv);
+
+	kfree(block_cb);
+}
+EXPORT_SYMBOL(flow_block_cb_free);
+
+void flow_block_cb_add(struct flow_block_cb *block_cb,
+		       struct flow_block_offload *offload)
+{
+	list_add_tail(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(flow_block_cb_add);
+
+void flow_block_cb_remove(struct flow_block_cb *block_cb,
+			  struct flow_block_offload *offload)
+{
+	list_move(&block_cb->global_list, &offload->cb_list);
+}
+EXPORT_SYMBOL(flow_block_cb_remove);
+
+void flow_block_cb_splice(struct flow_block_offload *offload)
+{
+	list_splice(&offload->cb_list, &flow_block_cb_list);
+}
+EXPORT_SYMBOL(flow_block_cb_splice);
+
+int flow_block_setup_offload(struct flow_block_offload *f, tc_setup_cb_t *cb,
+			     void *cb_ident, void *cb_priv, bool ingress_only)
+{
+	struct flow_block_cb *block_cb;
+
+	if (ingress_only &&
+	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case TC_BLOCK_BIND:
+		block_cb = flow_block_cb_alloc(f->net, cb, cb_ident, cb_priv,
+					       NULL);
+		if (!block_cb)
+			return -ENOMEM;
+
+		flow_block_cb_add(block_cb, f);
+		return 0;
+	case TC_BLOCK_UNBIND:
+		block_cb = flow_block_cb_lookup(f->net, cb, cb_ident);
+		if (!block_cb)
+			return -ENOENT;
+
+		flow_block_cb_remove(block_cb, f);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(flow_block_setup_offload);
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 8f562f3cf81c..a7e80d4e10ef 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -943,9 +943,9 @@ static int dsa_slave_setup_tc_block_cb_eg(enum tc_setup_type type,
 }
 
 static int dsa_slave_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
+				    struct flow_block_offload *f)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	tc_setup_cb_t *cb;
 
 	if (f->binder_type == TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
@@ -957,18 +957,18 @@ static int dsa_slave_setup_tc_block(struct net_device *dev,
 
 	switch (f->command) {
 	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->net, cb, dev, dev, NULL);
+		block_cb = flow_block_cb_alloc(f->net, cb, dev, dev, NULL);
 		if (!block_cb)
 			return -ENOMEM;
 
-		tcf_block_cb_add(block_cb, f);
+		flow_block_cb_add(block_cb, f);
 		return 0;
 	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->net, cb, dev);
+		block_cb = flow_block_cb_lookup(f->net, cb, dev);
 		if (!block_cb)
 			return -ENOENT;
 
-		tcf_block_cb_remove(block_cb, f);
+		flow_block_cb_remove(block_cb, f);
 		return 0;
 	default:
 		return -EOPNOTSUPP;
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 0255b6166b49..cd1e3f7297c9 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -26,6 +26,7 @@
 #include <net/netlink.h>
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
+#include <net/flow_offload.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_mirred.h>
 #include <net/tc_act/tc_vlan.h>
@@ -709,97 +710,10 @@ static bool tcf_block_offload_in_use(struct tcf_block *block)
 	return block->offloadcnt;
 }
 
-struct tcf_block_cb {
-	struct list_head global_list;
-	struct list_head list;
-	struct net *net;
-	tc_setup_cb_t *cb;
-	void (*release)(void *cb_priv);
-	void *cb_ident;
-	void *cb_priv;
-	unsigned int refcnt;
-};
-
-void *tcf_block_cb_priv(struct tcf_block_cb *block_cb)
-{
-	return block_cb->cb_priv;
-}
-EXPORT_SYMBOL(tcf_block_cb_priv);
-
-static LIST_HEAD(tcf_block_cb_list);
-
-struct tcf_block_cb *tcf_block_cb_lookup(struct net *net, tc_setup_cb_t *cb,
-					 void *cb_ident)
-{
-	struct tcf_block_cb *block_cb;
-
-	list_for_each_entry(block_cb, &tcf_block_cb_list, global_list)
-		if (block_cb->net == net &&
-		    block_cb->cb == cb &&
-		    block_cb->cb_ident == cb_ident)
-			return block_cb;
-	return NULL;
-}
-EXPORT_SYMBOL(tcf_block_cb_lookup);
-
-void tcf_block_cb_incref(struct tcf_block_cb *block_cb)
-{
-	block_cb->refcnt++;
-}
-EXPORT_SYMBOL(tcf_block_cb_incref);
-
-unsigned int tcf_block_cb_decref(struct tcf_block_cb *block_cb)
-{
-	return --block_cb->refcnt;
-}
-EXPORT_SYMBOL(tcf_block_cb_decref);
-
-struct tcf_block_cb *tcf_block_cb_alloc(struct net *net, tc_setup_cb_t *cb,
-					void *cb_ident, void *cb_priv,
-					void (*release)(void *cb_priv))
-{
-	struct tcf_block_cb *block_cb;
-
-	block_cb = kzalloc(sizeof(*block_cb), GFP_KERNEL);
-	if (!block_cb)
-		return NULL;
-
-	block_cb->net = net;
-	block_cb->cb = cb;
-	block_cb->cb_ident = cb_ident;
-	block_cb->release = release;
-	block_cb->cb_priv = cb_priv;
-
-	return block_cb;
-}
-EXPORT_SYMBOL(tcf_block_cb_alloc);
-
-void tcf_block_cb_free(struct tcf_block_cb *block_cb)
-{
-	if (block_cb->release)
-		block_cb->release(block_cb->cb_priv);
-
-	kfree(block_cb);
-}
-EXPORT_SYMBOL(tcf_block_cb_free);
-
-void tcf_block_cb_add(struct tcf_block_cb *block_cb,
-		      struct tc_block_offload *offload)
-{
-	list_add_tail(&block_cb->global_list, &offload->cb_list);
-}
-EXPORT_SYMBOL(tcf_block_cb_add);
-
-void tcf_block_cb_remove(struct tcf_block_cb *block_cb,
-			 struct tc_block_offload *offload)
-{
-	list_move(&block_cb->global_list, &offload->cb_list);
-}
-EXPORT_SYMBOL(tcf_block_cb_remove);
-
-static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
+static int tcf_block_bind(struct tcf_block *block,
+			  struct flow_block_offload *bo)
 {
-	struct tcf_block_cb *block_cb, *next;
+	struct flow_block_cb *block_cb, *next;
 	int err, i = 0;
 
 	list_for_each_entry(block_cb, &bo->cb_list, global_list) {
@@ -813,7 +727,7 @@ static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 		list_add(&block_cb->list, &block->cb_list);
 		i++;
 	}
-	list_splice(&bo->cb_list, &tcf_block_cb_list);
+	flow_block_cb_splice(bo);
 
 	return 0;
 
@@ -833,9 +747,9 @@ static int tcf_block_bind(struct tcf_block *block, struct tc_block_offload *bo)
 }
 
 static void tcf_block_unbind(struct tcf_block *block,
-			     struct tc_block_offload *bo)
+			     struct flow_block_offload *bo)
 {
-	struct tcf_block_cb *block_cb, *next;
+	struct flow_block_cb *block_cb, *next;
 
 	list_for_each_entry_safe(block_cb, next, &bo->cb_list, global_list) {
 		list_del(&block_cb->global_list);
@@ -844,11 +758,12 @@ static void tcf_block_unbind(struct tcf_block *block,
 					    tcf_block_offload_in_use(block),
 					    NULL);
 		list_del(&block_cb->list);
-		tcf_block_cb_free(block_cb);
+		flow_block_cb_free(block_cb);
 	}
 }
 
-static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
+static int tcf_block_setup(struct tcf_block *block,
+			   struct flow_block_offload *bo)
 {
 	int err;
 
@@ -868,37 +783,6 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 	return err;
 }
 
-int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
-			    void *cb_ident, void *cb_priv, bool ingress_only)
-{
-	struct tcf_block_cb *block_cb;
-
-	if (ingress_only &&
-	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		block_cb = tcf_block_cb_alloc(f->net, cb, cb_ident,
-					      cb_priv, NULL);
-		if (!block_cb)
-			return -ENOMEM;
-
-		tcf_block_cb_add(block_cb, f);
-		return 0;
-	case TC_BLOCK_UNBIND:
-		block_cb = tcf_block_cb_lookup(f->net, cb, cb_ident);
-		if (!block_cb)
-			return -ENOENT;
-
-		tcf_block_cb_remove(block_cb, f);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-EXPORT_SYMBOL(tcf_setup_block_offload);
-
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
@@ -1008,9 +892,9 @@ static void tc_indr_block_cb_del(struct tc_indr_block_cb *indr_block_cb)
 
 static void tc_indr_block_ing_cmd(struct tc_indr_block_dev *indr_dev,
 				  struct tc_indr_block_cb *indr_block_cb,
-				  enum tc_block_command command)
+				  enum flow_block_command command)
 {
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS,
 		.net		= dev_net(indr_dev->dev),
@@ -1095,12 +979,12 @@ EXPORT_SYMBOL_GPL(tc_indr_block_cb_unregister);
 
 static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 			       struct tcf_block_ext_info *ei,
-			       enum tc_block_command command,
+			       enum flow_block_command command,
 			       struct netlink_ext_ack *extack)
 {
 	struct tc_indr_block_cb *indr_block_cb;
 	struct tc_indr_block_dev *indr_dev;
-	struct tc_block_offload bo = {
+	struct flow_block_offload bo = {
 		.command	= command,
 		.binder_type	= ei->binder_type,
 		.net		= dev_net(dev),
@@ -1124,10 +1008,10 @@ static void tc_indr_block_call(struct tcf_block *block, struct net_device *dev,
 static int tcf_block_offload_cmd(struct tcf_block *block,
 				 struct net_device *dev,
 				 struct tcf_block_ext_info *ei,
-				 enum tc_block_command command,
+				 enum flow_block_command command,
 				 struct netlink_ext_ack *extack)
 {
-	struct tc_block_offload bo = {};
+	struct flow_block_offload bo = {};
 	int err;
 
 	bo.net = dev_net(dev);
@@ -1585,13 +1469,13 @@ static void tcf_block_release(struct Qdisc *q, struct tcf_block *block,
 struct tcf_block_owner_item {
 	struct list_head list;
 	struct Qdisc *q;
-	enum tcf_block_binder_type binder_type;
+	enum flow_block_binder_type binder_type;
 };
 
 static void
 tcf_block_owner_netif_keep_dst(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	if (block->keep_dst &&
 	    binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS &&
@@ -1612,7 +1496,7 @@ EXPORT_SYMBOL(tcf_block_netif_keep_dst);
 
 static int tcf_block_owner_add(struct tcf_block *block,
 			       struct Qdisc *q,
-			       enum tcf_block_binder_type binder_type)
+			       enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
@@ -1627,7 +1511,7 @@ static int tcf_block_owner_add(struct tcf_block *block,
 
 static void tcf_block_owner_del(struct tcf_block *block,
 				struct Qdisc *q,
-				enum tcf_block_binder_type binder_type)
+				enum flow_block_binder_type binder_type)
 {
 	struct tcf_block_owner_item *item;
 
@@ -3261,7 +3145,7 @@ EXPORT_SYMBOL(tcf_exts_dump_stats);
 int tc_setup_cb_call(struct tcf_block *block, enum tc_setup_type type,
 		     void *type_data, bool err_stop)
 {
-	struct tcf_block_cb *block_cb;
+	struct flow_block_cb *block_cb;
 	int ok_count = 0;
 	int err;
 
-- 
2.11.0

