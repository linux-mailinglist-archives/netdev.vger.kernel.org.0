Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60574DA9C
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 21:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfFTTtt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 15:49:49 -0400
Received: from mail.us.es ([193.147.175.20]:54084 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfFTTtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 15:49:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B2547B60EE
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:42 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81261DA71A
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 21:49:42 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 723BBDA716; Thu, 20 Jun 2019 21:49:42 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 84E32DA704;
        Thu, 20 Jun 2019 21:49:37 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 20 Jun 2019 21:49:37 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 482CB4265A2F;
        Thu, 20 Jun 2019 21:49:36 +0200 (CEST)
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
Subject: [PATCH net-next 06/12] net: sched: add tcf_setup_block_offload()
Date:   Thu, 20 Jun 2019 21:49:11 +0200
Message-Id: <20190620194917.2298-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190620194917.2298-1-pablo@netfilter.org>
References: <20190620194917.2298-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most drivers do the same thing to set up the block, add a helper
function to do this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 26 ++++-------------
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c     | 28 ++++--------------
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 26 ++++-------------
 drivers/net/ethernet/intel/i40e/i40e_main.c       | 26 ++++-------------
 drivers/net/ethernet/intel/iavf/iavf_main.c       | 35 ++++-------------------
 drivers/net/ethernet/intel/igb/igb_main.c         | 23 ++-------------
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 27 ++++-------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c  | 26 ++++-------------
 drivers/net/ethernet/netronome/nfp/abm/cls.c      | 17 ++---------
 drivers/net/ethernet/netronome/nfp/bpf/main.c     | 29 ++++---------------
 drivers/net/ethernet/qlogic/qede/qede_main.c      | 23 ++-------------
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++------------
 drivers/net/netdevsim/netdev.c                    | 26 ++++-------------
 include/net/pkt_cls.h                             | 10 +++++++
 net/sched/cls_api.c                               | 20 +++++++++++++
 16 files changed, 91 insertions(+), 300 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f758b2e0591f..2ce11fc01a07 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9847,32 +9847,16 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int bnxt_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct bnxt *bp = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, bnxt_setup_tc_block_cb,
-					     bp, bp, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, bnxt_setup_tc_block_cb, bp);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct bnxt *bp = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       bnxt_setup_tc_block_cb, bp, bp,
+					       true);
 	case TC_SETUP_QDISC_MQPRIO: {
 		struct tc_mqprio_qopt *mqprio = type_data;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index f760921389a3..c8bb104f28d4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -161,34 +161,16 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	}
 }
 
-static int bnxt_vf_rep_setup_tc_block(struct net_device *dev,
-				      struct tc_block_offload *f)
-{
-	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     bnxt_vf_rep_setup_tc_block_cb,
-					     vf_rep, vf_rep, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					bnxt_vf_rep_setup_tc_block_cb, vf_rep);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int bnxt_vf_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 				void *type_data)
 {
+	struct bnxt_vf_rep *vf_rep = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return bnxt_vf_rep_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       bnxt_vf_rep_setup_tc_block_cb,
+					       vf_rep, vf_rep, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 54908002c786..075e4a0d20b0 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3184,32 +3184,16 @@ static int cxgb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int cxgb_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct port_info *pi = netdev2pinfo(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, cxgb_setup_tc_block_cb,
-					     pi, dev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, cxgb_setup_tc_block_cb, pi);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int cxgb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct port_info *pi = netdev2pinfo(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return cxgb_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       cxgb_setup_tc_block_cb, pi, dev,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 7c43ec533385..89af0dc55d6d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -7642,34 +7642,18 @@ static int i40e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int i40e_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct i40e_netdev_priv *np = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, i40e_setup_tc_block_cb,
-					     np, np, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, i40e_setup_tc_block_cb, np);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int __i40e_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			   void *type_data)
 {
+	struct i40e_netdev_priv *np = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return i40e_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return i40e_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       i40e_setup_tc_block_cb, np, np,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 881561b36083..29640e4b15f2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -3114,35 +3114,6 @@ static int iavf_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 }
 
 /**
- * iavf_setup_tc_block - register callbacks for tc
- * @netdev: network interface device structure
- * @f: tc offload data
- *
- * This function registers block callbacks for tc
- * offloads
- **/
-static int iavf_setup_tc_block(struct net_device *dev,
-			       struct tc_block_offload *f)
-{
-	struct iavf_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, iavf_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, iavf_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-/**
  * iavf_setup_tc - configure multiple traffic classes
  * @netdev: network interface device structure
  * @type: type of offload
@@ -3156,11 +3127,15 @@ static int iavf_setup_tc_block(struct net_device *dev,
 static int iavf_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 			 void *type_data)
 {
+	struct iavf_adapter *adapter = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_QDISC_MQPRIO:
 		return __iavf_setup_tc(netdev, type_data);
 	case TC_SETUP_BLOCK:
-		return iavf_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       iavf_setup_tc_block_cb, adapter,
+					       adapter, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index fc925adbd9fa..03fd960b58c5 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2783,25 +2783,6 @@ static int igb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int igb_setup_tc_block(struct igb_adapter *adapter,
-			      struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, igb_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, igb_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int igb_offload_txtime(struct igb_adapter *adapter,
 			      struct tc_etf_qopt_offload *qopt)
 {
@@ -2834,7 +2815,9 @@ static int igb_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	case TC_SETUP_QDISC_CBS:
 		return igb_offload_cbs(adapter, type_data);
 	case TC_SETUP_BLOCK:
-		return igb_setup_tc_block(adapter, type_data);
+		return tcf_setup_block_offload(type_data, igb_setup_tc_block_cb,
+					       adapter, adapter, true);
+
 	case TC_SETUP_QDISC_ETF:
 		return igb_offload_txtime(adapter, type_data);
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index b613e72c8ee4..7d3fe89ce807 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9607,27 +9607,6 @@ static int ixgbe_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int ixgbe_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct ixgbe_adapter *adapter = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, ixgbe_setup_tc_block_cb,
-					     adapter, adapter, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, ixgbe_setup_tc_block_cb,
-					adapter);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 				 struct tc_mqprio_qopt *mqprio)
 {
@@ -9638,9 +9617,13 @@ static int ixgbe_setup_tc_mqprio(struct net_device *dev,
 static int __ixgbe_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			    void *type_data)
 {
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return ixgbe_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       ixgbe_setup_tc_block_cb,
+					       adapter, adapter, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		return ixgbe_setup_tc_mqprio(dev, type_data);
 	default:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5e40db8f92e6..a0c1a389db53 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3345,36 +3345,19 @@ static int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 		return -EOPNOTSUPP;
 	}
 }
-
-static int mlx5e_setup_tc_block(struct net_device *dev,
-				struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_setup_tc_block_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_setup_tc_block_cb,
-					priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
 #endif
 
 static int mlx5e_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			  void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 #ifdef CONFIG_MLX5_ESWITCH
 	case TC_SETUP_BLOCK:
-		return mlx5e_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       mlx5e_setup_tc_block_cb,
+					       priv, priv, true);
 #endif
 	case TC_SETUP_QDISC_MQPRIO:
 		return mlx5e_setup_tc_mqprio(dev, type_data);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 3999da3e6314..17d67a956642 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1187,32 +1187,16 @@ static int mlx5e_rep_setup_tc_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int mlx5e_rep_setup_tc_block(struct net_device *dev,
-				    struct tc_block_offload *f)
-{
-	struct mlx5e_priv *priv = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, mlx5e_rep_setup_tc_cb,
-					     priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, mlx5e_rep_setup_tc_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int mlx5e_rep_setup_tc(struct net_device *dev, enum tc_setup_type type,
 			      void *type_data)
 {
+	struct mlx5e_priv *priv = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return mlx5e_rep_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       mlx5e_rep_setup_tc_cb,
+					       priv, priv, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index ff3913085665..d99981ec04a3 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -265,19 +265,6 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 int nfp_abm_setup_cls_block(struct net_device *netdev, struct nfp_repr *repr,
 			    struct tc_block_offload *f)
 {
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_EGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_abm_setup_tc_block_cb,
-					     repr, repr, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nfp_abm_setup_tc_block_cb,
-					repr);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
+	return tcf_setup_block_offload(f, nfp_abm_setup_tc_block_cb, repr, repr,
+				       true);
 }
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 9c136da25221..fac38899dc23 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -160,35 +160,16 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 	return 0;
 }
 
-static int nfp_bpf_setup_tc_block(struct net_device *netdev,
-				  struct tc_block_offload *f)
-{
-	struct nfp_net *nn = netdev_priv(netdev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     nfp_bpf_setup_tc_block_cb,
-					     nn, nn, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block,
-					nfp_bpf_setup_tc_block_cb,
-					nn);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nfp_bpf_setup_tc(struct nfp_app *app, struct net_device *netdev,
 			    enum tc_setup_type type, void *type_data)
 {
+	struct nfp_net *nn = netdev_priv(netdev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nfp_bpf_setup_tc_block(netdev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       nfp_bpf_setup_tc_block_cb,
+					       nn, nn, true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index d4a29660751d..013046a30732 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -579,25 +579,6 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	}
 }
 
-static int qede_setup_tc_block(struct qede_dev *edev,
-			       struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block,
-					     qede_setup_tc_block_cb,
-					     edev, edev, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, qede_setup_tc_block_cb, edev);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int
 qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 		      void *type_data)
@@ -607,7 +588,9 @@ qede_setup_tc_offload(struct net_device *dev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return qede_setup_tc_block(edev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       qede_setup_tc_block_cb,
+					       edev, edev, true);
 	case TC_SETUP_QDISC_MQPRIO:
 		mqprio = type_data;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a48751989fa6..154bd8aa1cbc 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3774,24 +3774,6 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	return ret;
 }
 
-static int stmmac_setup_tc_block(struct stmmac_priv *priv,
-				 struct tc_block_offload *f)
-{
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, stmmac_setup_tc_block_cb,
-				priv, priv, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, stmmac_setup_tc_block_cb, priv);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 			   void *type_data)
 {
@@ -3799,7 +3781,9 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return stmmac_setup_tc_block(priv, type_data);
+		return tcf_setup_block_offload(type_data,
+					       stmmac_setup_tc_block_cb,
+					       priv, priv, true);
 	case TC_SETUP_QDISC_CBS:
 		return stmmac_tc_setup_cbs(priv, priv, type_data);
 	default:
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index e5c8aa08e1cd..240727623e9b 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -78,26 +78,6 @@ nsim_setup_tc_block_cb(enum tc_setup_type type, void *type_data, void *cb_priv)
 	return nsim_bpf_setup_tc_block_cb(type, type_data, cb_priv);
 }
 
-static int
-nsim_setup_tc_block(struct net_device *dev, struct tc_block_offload *f)
-{
-	struct netdevsim *ns = netdev_priv(dev);
-
-	if (f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
-		return -EOPNOTSUPP;
-
-	switch (f->command) {
-	case TC_BLOCK_BIND:
-		return tcf_block_cb_register(f->block, nsim_setup_tc_block_cb,
-					     ns, ns, f->extack);
-	case TC_BLOCK_UNBIND:
-		tcf_block_cb_unregister(f->block, nsim_setup_tc_block_cb, ns);
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 static int nsim_set_vf_mac(struct net_device *dev, int vf, u8 *mac)
 {
 	struct netdevsim *ns = netdev_priv(dev);
@@ -226,9 +206,13 @@ static int nsim_set_vf_link_state(struct net_device *dev, int vf, int state)
 static int
 nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 {
+	struct netdevsim *ns = netdev_priv(dev);
+
 	switch (type) {
 	case TC_SETUP_BLOCK:
-		return nsim_setup_tc_block(dev, type_data);
+		return tcf_setup_block_offload(type_data,
+					       nsim_setup_tc_block_cb, ns, ns,
+					       true);
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index db4d32266a03..872b75286431 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -111,6 +111,8 @@ void tc_indr_block_cb_unregister(struct net_device *dev,
 int tcf_classify(struct sk_buff *skb, const struct tcf_proto *tp,
 		 struct tcf_result *res, bool compat_mode);
 
+int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+			    void *cb_ident, void *cb_priv, bool ingress_only);
 #else
 static inline bool tcf_block_shared(struct tcf_block *block)
 {
@@ -161,6 +163,14 @@ void tc_setup_cb_block_unregister(struct tcf_block *block, tc_setup_cb_t *cb,
 {
 }
 
+static inline int tcf_setup_block_offload(struct tc_block_offload *f,
+					  tc_setup_cb_t *cb,
+					  void *cb_ident, void *cb_priv,
+					  bool ingress_only)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline struct tcf_block_cb *
 tcf_block_cb_alloc(tc_setup_cb_t *cb, void *cb_ident, void *cb_priv,
 		   void (*release)(void *cb_priv))
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 707c2ae0a15f..6dc6935fe517 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -922,6 +922,26 @@ static int tcf_block_setup(struct tcf_block *block, struct tc_block_offload *bo)
 	return err;
 }
 
+int tcf_setup_block_offload(struct tc_block_offload *f, tc_setup_cb_t *cb,
+			    void *cb_ident, void *cb_priv, bool ingress_only)
+{
+	if (ingress_only &&
+	    f->binder_type != TCF_BLOCK_BINDER_TYPE_CLSACT_INGRESS)
+		return -EOPNOTSUPP;
+
+	switch (f->command) {
+	case TC_BLOCK_BIND:
+		return tcf_block_cb_register(f->block, cb, cb_ident, cb_priv,
+					     f->extack);
+	case TC_BLOCK_UNBIND:
+		tcf_block_cb_unregister(f->block, cb, cb_ident);
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+EXPORT_SYMBOL(tcf_setup_block_offload);
+
 static struct rhashtable indr_setup_block_ht;
 
 struct tc_indr_block_dev {
-- 
2.11.0

