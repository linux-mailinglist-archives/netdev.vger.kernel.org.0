Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A61B1679FF
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 10:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728340AbgBUJ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 04:56:51 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35530 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728062AbgBUJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 04:56:50 -0500
Received: by mail-wm1-f66.google.com with SMTP id b17so1031238wmb.0
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 01:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9iXfmO4WYk9FosSATzyiqqZQj4suiRSh+IDKi494Buc=;
        b=sqAA1S6P47TZDtOsdNeEMR5zNSYVLoqnsbVfSMURbdnj9GQB+IVPNSX/rF+ZlOmorU
         qHJGt+J4AubH83aS3cSOAichRbIyzPKT/sYHrmdxhGGofM/D6Li45rSx4ltrFOLnaUnk
         eFjio5VKZHh9ACQcxWHYXIqxiYNM99hP2H75+oMHouSdUA+mBgbcUggfdFsRHEvIfEo+
         u2a1GgevIH0PAh9F6Zi6/SQDhavEWQqfe7V8UsrJQ7OvMZS1QOka0zrukfm9QnHb+wr4
         Sa/wO9W9V44ALVCMMPebWP7b4RCjKb6VkIuAco3sKq4xiRibcTmoTVlJsMntqnsk1scz
         U3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9iXfmO4WYk9FosSATzyiqqZQj4suiRSh+IDKi494Buc=;
        b=Qff+pjcri7NfOugbET13d6tYWa31S1dK+YgtRiFwdYoqE+mPQKc77nIUOJGy9JbP5j
         yKyZM1sUfPMP4DpeIL9fIDz1EQh+KBMVycGR5UUtOozPxNEc60PP+7hs0RMcYCIlFw2i
         EhU4ED4NaLucVDoY+u0EoUzbsRSqSVcpJqP0XQ6m/zSH9TkwzMkHo0nD2csqxyZd3mAJ
         /xn1QnesCqCBVIObnc1525yUX3lrRSdNl8kh205EebTrALLCyE1o1QjFIXanFHSK4Gpq
         Zj9POF9Am6LVITivqnARrNk6N98UU++AzbWNNkgCRZOKHWFzpvfYae1KjbhKHds7M/VO
         02uw==
X-Gm-Message-State: APjAAAWiUSO35f78+AVDXgQ67KGb0QMAw5zvT4FpkxOMJU6cWdfLcAL/
        p6lhIEGX9q1AHqJmWzimCw3CWyhAnLQ=
X-Google-Smtp-Source: APXvYqyvmH0YQ2fIog1DH/yLbJOpZwI0ipVZ5O4AoMOZhvrjkd/Pu5hzZ0cNIfkLLmgmkbJOhShpzA==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr2844866wmg.92.1582279005789;
        Fri, 21 Feb 2020 01:56:45 -0800 (PST)
Received: from localhost (ip-89-177-130-96.net.upcbroadband.cz. [89.177.130.96])
        by smtp.gmail.com with ESMTPSA id 18sm3151502wmf.1.2020.02.21.01.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 01:56:45 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org, mlxsw@mellanox.com
Subject: [patch net-next 01/10] net: rename tc_cls_can_offload_and_chain0() to tc_cls_can_offload_basic()
Date:   Fri, 21 Feb 2020 10:56:34 +0100
Message-Id: <20200221095643.6642-2-jiri@resnulli.us>
X-Mailer: git-send-email 2.21.1
In-Reply-To: <20200221095643.6642-1-jiri@resnulli.us>
References: <20200221095643.6642-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

The function is going to be extended for checking not only chain 0, but
also HW stats type. So rename it accordingly as this checks for basic
offloading functionality.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c       | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c     | 4 ++--
 drivers/net/ethernet/intel/i40e/i40e_main.c         | 2 +-
 drivers/net/ethernet/intel/igb/igb_main.c           | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c       | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c      | 3 +--
 drivers/net/ethernet/mscc/ocelot_flower.c           | 2 +-
 drivers/net/ethernet/mscc/ocelot_tc.c               | 2 +-
 drivers/net/ethernet/netronome/nfp/abm/cls.c        | 2 +-
 drivers/net/ethernet/netronome/nfp/bpf/main.c       | 2 +-
 drivers/net/ethernet/netronome/nfp/flower/offload.c | 2 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c        | 2 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c   | 2 +-
 drivers/net/netdevsim/bpf.c                         | 2 +-
 include/net/pkt_cls.h                               | 4 ++--
 17 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 597e6fd5bfea..f62a1d9667fa 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11043,7 +11043,7 @@ static int bnxt_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	struct bnxt *bp = cb_priv;
 
 	if (!bnxt_tc_flower_enabled(bp) ||
-	    !tc_cls_can_offload_and_chain0(bp->dev, type_data))
+	    !tc_cls_can_offload_basic(bp->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index b010b34cdaf8..2ab3ecb298de 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -150,7 +150,7 @@ static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
 	int vf_fid = bp->pf.vf[vf_rep->vf_idx].fw_fid;
 
 	if (!bnxt_tc_flower_enabled(vf_rep->bp) ||
-	    !tc_cls_can_offload_and_chain0(bp->dev, type_data))
+	    !tc_cls_can_offload_basic(bp->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 649842a8aa28..7b98c8e2ce69 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3316,7 +3316,7 @@ static int cxgb_setup_tc_block_ingress_cb(enum tc_setup_type type,
 		return -EINVAL;
 	}
 
-	if (!tc_cls_can_offload_and_chain0(dev, type_data))
+	if (!tc_cls_can_offload_basic(dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
@@ -3345,7 +3345,7 @@ static int cxgb_setup_tc_block_egress_cb(enum tc_setup_type type,
 		return -EINVAL;
 	}
 
-	if (!tc_cls_can_offload_and_chain0(dev, type_data))
+	if (!tc_cls_can_offload_basic(dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 8c3e753bfb9d..afa9a96e9212 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -8141,7 +8141,7 @@ static int i40e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 {
 	struct i40e_netdev_priv *np = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(np->vsi->netdev, type_data))
+	if (!tc_cls_can_offload_basic(np->vsi->netdev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index b46bff8fe056..396bda31ab76 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2775,7 +2775,7 @@ static int igb_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 {
 	struct igb_adapter *adapter = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(adapter->netdev, type_data))
+	if (!tc_cls_can_offload_basic(adapter->netdev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 718931d951bc..a91623b7ba19 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9631,7 +9631,7 @@ static int ixgbe_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 {
 	struct ixgbe_adapter *adapter = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(adapter->netdev, type_data))
+	if (!tc_cls_can_offload_basic(adapter->netdev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 74091f72c9a8..bcfe2b6e35e5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3865,7 +3865,7 @@ mlx5e_add_nic_flow(struct mlx5e_priv *priv,
 	int attr_size, err;
 
 	/* multi-chain not supported for NIC rules */
-	if (!tc_cls_can_offload_and_chain0(priv->netdev, &f->common))
+	if (!tc_cls_can_offload_basic(priv->netdev, &f->common))
 		return -EOPNOTSUPP;
 
 	flow_flags |= BIT(MLX5E_TC_FLOW_FLAG_NIC);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index d78e790ba94a..de8c11b5c487 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1589,8 +1589,7 @@ static int mlxsw_sp_setup_tc_block_cb_matchall(enum tc_setup_type type,
 
 	switch (type) {
 	case TC_SETUP_CLSMATCHALL:
-		if (!tc_cls_can_offload_and_chain0(mlxsw_sp_port->dev,
-						   type_data))
+		if (!tc_cls_can_offload_basic(mlxsw_sp_port->dev, type_data))
 			return -EOPNOTSUPP;
 
 		return mlxsw_sp_setup_tc_cls_matchall(mlxsw_sp_port, type_data,
diff --git a/drivers/net/ethernet/mscc/ocelot_flower.c b/drivers/net/ethernet/mscc/ocelot_flower.c
index 3d65b99b9734..64d2758eb223 100644
--- a/drivers/net/ethernet/mscc/ocelot_flower.c
+++ b/drivers/net/ethernet/mscc/ocelot_flower.c
@@ -261,7 +261,7 @@ static int ocelot_setup_tc_block_cb_flower(enum tc_setup_type type,
 {
 	struct ocelot_port_block *port_block = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(port_block->priv->dev, type_data))
+	if (!tc_cls_can_offload_basic(port_block->priv->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/mscc/ocelot_tc.c b/drivers/net/ethernet/mscc/ocelot_tc.c
index a4f7fbd76507..954136db2f62 100644
--- a/drivers/net/ethernet/mscc/ocelot_tc.c
+++ b/drivers/net/ethernet/mscc/ocelot_tc.c
@@ -94,7 +94,7 @@ static int ocelot_setup_tc_block_cb(enum tc_setup_type type,
 {
 	struct ocelot_port_private *priv = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
+	if (!tc_cls_can_offload_basic(priv->dev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/netronome/nfp/abm/cls.c b/drivers/net/ethernet/netronome/nfp/abm/cls.c
index 23ebddfb9532..7c59b248e216 100644
--- a/drivers/net/ethernet/netronome/nfp/abm/cls.c
+++ b/drivers/net/ethernet/netronome/nfp/abm/cls.c
@@ -238,7 +238,7 @@ static int nfp_abm_setup_tc_block_cb(enum tc_setup_type type,
 				   "only offload of u32 classifier supported");
 		return -EOPNOTSUPP;
 	}
-	if (!tc_cls_can_offload_and_chain0(repr->netdev, &cls_u32->common))
+	if (!tc_cls_can_offload_basic(repr->netdev, &cls_u32->common))
 		return -EOPNOTSUPP;
 
 	if (cls_u32->common.protocol != htons(ETH_P_IP) &&
diff --git a/drivers/net/ethernet/netronome/nfp/bpf/main.c b/drivers/net/ethernet/netronome/nfp/bpf/main.c
index 11c83a99b014..4c1b2bd655a0 100644
--- a/drivers/net/ethernet/netronome/nfp/bpf/main.c
+++ b/drivers/net/ethernet/netronome/nfp/bpf/main.c
@@ -116,7 +116,7 @@ static int nfp_bpf_setup_tc_block_cb(enum tc_setup_type type,
 				   "only offload of BPF classifiers supported");
 		return -EOPNOTSUPP;
 	}
-	if (!tc_cls_can_offload_and_chain0(nn->dp.netdev, &cls_bpf->common))
+	if (!tc_cls_can_offload_basic(nn->dp.netdev, &cls_bpf->common))
 		return -EOPNOTSUPP;
 	if (!nfp_net_ebpf_capable(nn)) {
 		NL_SET_ERR_MSG_MOD(cls_bpf->common.extack,
diff --git a/drivers/net/ethernet/netronome/nfp/flower/offload.c b/drivers/net/ethernet/netronome/nfp/flower/offload.c
index 7ca5c1becfcf..7a9bb55deec2 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/offload.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/offload.c
@@ -1523,7 +1523,7 @@ static int nfp_flower_setup_tc_block_cb(enum tc_setup_type type,
 {
 	struct nfp_repr *repr = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(repr->netdev, type_data))
+	if (!tc_cls_can_offload_basic(repr->netdev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 34fa3917eb33..6168bb6e855c 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -567,7 +567,7 @@ static int qede_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	struct flow_cls_offload *f;
 	struct qede_dev *edev = cb_priv;
 
-	if (!tc_cls_can_offload_and_chain0(edev->ndev, type_data))
+	if (!tc_cls_can_offload_basic(edev->ndev, type_data))
 		return -EOPNOTSUPP;
 
 	switch (type) {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 37920b4da091..80b528a58723 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4120,7 +4120,7 @@ static int stmmac_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 	struct stmmac_priv *priv = cb_priv;
 	int ret = -EOPNOTSUPP;
 
-	if (!tc_cls_can_offload_and_chain0(priv->dev, type_data))
+	if (!tc_cls_can_offload_basic(priv->dev, type_data))
 		return ret;
 
 	stmmac_disable_all_queues(priv);
diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
index 0b362b8dac17..537a4233a989 100644
--- a/drivers/net/netdevsim/bpf.c
+++ b/drivers/net/netdevsim/bpf.c
@@ -124,7 +124,7 @@ int nsim_bpf_setup_tc_block_cb(enum tc_setup_type type,
 		return -EOPNOTSUPP;
 	}
 
-	if (!tc_cls_can_offload_and_chain0(ns->netdev, &cls_bpf->common))
+	if (!tc_cls_can_offload_basic(ns->netdev, &cls_bpf->common))
 		return -EOPNOTSUPP;
 
 	if (cls_bpf->common.protocol != htons(ETH_P_ALL)) {
diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 53946b509b51..779364ed080a 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -584,8 +584,8 @@ static inline bool tc_can_offload_extack(const struct net_device *dev,
 }
 
 static inline bool
-tc_cls_can_offload_and_chain0(const struct net_device *dev,
-			      struct flow_cls_common_offload *common)
+tc_cls_can_offload_basic(const struct net_device *dev,
+			 struct flow_cls_common_offload *common)
 {
 	if (!tc_can_offload_extack(dev, common->extack))
 		return false;
-- 
2.21.1

