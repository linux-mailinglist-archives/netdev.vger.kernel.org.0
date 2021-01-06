Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2E2EC582
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbhAFVHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 16:07:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:59382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726394AbhAFVHx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 16:07:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D747323329;
        Wed,  6 Jan 2021 21:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609967231;
        bh=QuaxM4P5Ywde0AlSiub/Rf1nOpXe4H/XN8xG/Tk8/Uw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bMVc/kGKtjfPV7sijd3FamCONGOZc+BH6P99OTq/kbsqz9+w7UED/C1hZ8TiQsuRC
         gidPxwNBmawaX7hF3rlim+qwQOPJyq6kgMijKw4F5w6UUN0Cu/dINSXpfKnkc1gThS
         0LijpmNEq5Vctd8nFdcMdNx7wKlewObRoeh3NYtYrh53x9P9PDDAxBW47M93wwU2C+
         rLxCKY7bXZPeIRULH5va03Gc0Ru2kN7wSmMTJ8DBa1B6kIRpZzgRhUczQhJiKtCSCQ
         vJtDg68eHcmIE7XtO4fTVn8VGTv2pHOdsijIowf57ZeeFlC2UINCCrrBXGsxX25H7t
         5rFNobPaVTHdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, thomas.lendacky@amd.com,
        aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        michael.chan@broadcom.com, rajur@chelsio.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, GR-Linux-NIC-Dev@marvell.com,
        ecree.xilinx@gmail.com, simon.horman@netronome.com,
        alexander.duyck@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 3/4] net: remove ndo_udp_tunnel_* callbacks
Date:   Wed,  6 Jan 2021 13:06:36 -0800
Message-Id: <20210106210637.1839662-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106210637.1839662-1-kuba@kernel.org>
References: <20210106210637.1839662-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All UDP tunnel port management is now routed via udp_tunnel_nic
infra directly. Remove the old callbacks.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c        |  2 --
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c    |  2 --
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |  2 --
 drivers/net/ethernet/cavium/liquidio/lio_main.c |  2 --
 .../net/ethernet/cavium/liquidio/lio_vf_main.c  |  2 --
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  2 --
 drivers/net/ethernet/cisco/enic/enic_main.c     |  4 ----
 drivers/net/ethernet/emulex/benet/be_main.c     |  2 --
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c |  2 --
 drivers/net/ethernet/intel/i40e/i40e_main.c     |  2 --
 drivers/net/ethernet/intel/ice/ice_main.c       |  2 --
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c   |  2 --
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c  |  4 ----
 .../net/ethernet/mellanox/mlx5/core/en_main.c   |  2 --
 .../net/ethernet/mellanox/mlx5/core/en_rep.c    |  2 --
 .../net/ethernet/netronome/nfp/nfp_net_common.c |  2 --
 drivers/net/ethernet/qlogic/qede/qede_main.c    |  6 ------
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c    |  2 --
 drivers/net/ethernet/sfc/efx.c                  |  2 --
 drivers/net/netdevsim/netdev.c                  |  2 --
 include/linux/netdevice.h                       | 17 -----------------
 21 files changed, 65 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2709a2db5657..99b6d5a9f1d9 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2295,8 +2295,6 @@ static const struct net_device_ops xgbe_netdev_ops = {
 	.ndo_setup_tc		= xgbe_setup_tc,
 	.ndo_fix_features	= xgbe_fix_features,
 	.ndo_set_features	= xgbe_set_features,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= xgbe_features_check,
 };
 
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 28069b290862..b652ed72a621 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -13071,8 +13071,6 @@ static const struct net_device_ops bnx2x_netdev_ops = {
 	.ndo_get_phys_port_id	= bnx2x_get_phys_port_id,
 	.ndo_set_vf_link_state	= bnx2x_set_vf_link_state,
 	.ndo_features_check	= bnx2x_features_check,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 };
 
 static int bnx2x_set_coherency_mask(struct bnx2x *bp)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bbd2a07dc329..d31a5ad7522a 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -12091,8 +12091,6 @@ static const struct net_device_ops bnxt_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= bnxt_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_bpf		= bnxt_xdp,
 	.ndo_xdp_xmit		= bnxt_xdp_xmit,
 	.ndo_bridge_getlink	= bnxt_bridge_getlink,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7d00d3a8ded4..7c5af4beedc6 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -3219,8 +3219,6 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_do_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_set_vf_mac		= liquidio_set_vf_mac,
 	.ndo_set_vf_vlan	= liquidio_set_vf_vlan,
 	.ndo_get_vf_config	= liquidio_get_vf_config,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 103440f97bc8..516f166ceff8 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1879,8 +1879,6 @@ static const struct net_device_ops lionetdevops = {
 	.ndo_do_ioctl		= liquidio_ioctl,
 	.ndo_fix_features	= liquidio_fix_features,
 	.ndo_set_features	= liquidio_set_features,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 };
 
 static int lio_nic_info(struct octeon_recv_info *recv_info, void *buf)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..15542661e3d2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3882,8 +3882,6 @@ static const struct net_device_ops cxgb4_netdev_ops = {
 #endif /* CONFIG_CHELSIO_T4_FCOE */
 	.ndo_set_tx_maxrate   = cxgb_set_tx_maxrate,
 	.ndo_setup_tc         = cxgb_setup_tc,
-	.ndo_udp_tunnel_add   = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del   = udp_tunnel_nic_del_port,
 	.ndo_features_check   = cxgb_features_check,
 	.ndo_fix_features     = cxgb_fix_features,
 };
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index fb269d587b74..f04ec53544ae 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -2509,8 +2509,6 @@ static const struct net_device_ops enic_netdev_dynamic_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= enic_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= enic_features_check,
 };
 
@@ -2535,8 +2533,6 @@ static const struct net_device_ops enic_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= enic_rx_flow_steer,
 #endif
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= enic_features_check,
 };
 
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index d402d83d9edd..b6eba29d8e99 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5179,8 +5179,6 @@ static const struct net_device_ops be_netdev_ops = {
 #endif
 	.ndo_bridge_setlink	= be_ndo_bridge_setlink,
 	.ndo_bridge_getlink	= be_ndo_bridge_getlink,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= be_features_check,
 	.ndo_get_phys_port_id   = be_get_phys_port_id,
 };
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 5c19ff452558..2fb52bd6fc0e 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1531,8 +1531,6 @@ static const struct net_device_ops fm10k_netdev_ops = {
 	.ndo_set_vf_rate	= fm10k_ndo_set_vf_bw,
 	.ndo_get_vf_config	= fm10k_ndo_get_vf_config,
 	.ndo_get_vf_stats	= fm10k_ndo_get_vf_stats,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_dfwd_add_station	= fm10k_dfwd_add_station,
 	.ndo_dfwd_del_station	= fm10k_dfwd_del_station,
 	.ndo_features_check	= fm10k_features_check,
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2..521ea9df38d5 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12804,8 +12804,6 @@ static const struct net_device_ops i40e_netdev_ops = {
 	.ndo_set_vf_link_state	= i40e_ndo_set_vf_link_state,
 	.ndo_set_vf_spoofchk	= i40e_ndo_set_vf_spoofchk,
 	.ndo_set_vf_trust	= i40e_ndo_set_vf_trust,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_get_phys_port_id	= i40e_get_phys_port_id,
 	.ndo_fdb_add		= i40e_ndo_fdb_add,
 	.ndo_features_check	= i40e_features_check,
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c52b9bb0e3ab..6e251dfffc91 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6790,6 +6790,4 @@ static const struct net_device_ops ice_netdev_ops = {
 	.ndo_bpf = ice_xdp,
 	.ndo_xdp_xmit = ice_xdp_xmit,
 	.ndo_xsk_wakeup = ice_xsk_wakeup,
-	.ndo_udp_tunnel_add = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del = udp_tunnel_nic_del_port,
 };
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 393d1c2cd853..6cbbe09ce8a0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10278,8 +10278,6 @@ static const struct net_device_ops ixgbe_netdev_ops = {
 	.ndo_bridge_getlink	= ixgbe_ndo_bridge_getlink,
 	.ndo_dfwd_add_station	= ixgbe_fwd_add,
 	.ndo_dfwd_del_station	= ixgbe_fwd_del,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= ixgbe_features_check,
 	.ndo_bpf		= ixgbe_xdp,
 	.ndo_xdp_xmit		= ixgbe_xdp_xmit,
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 32aad4d32b88..51b9700fce83 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2839,8 +2839,6 @@ static const struct net_device_ops mlx4_netdev_ops = {
 	.ndo_rx_flow_steer	= mlx4_en_filter_rfs,
 #endif
 	.ndo_get_phys_port_id	= mlx4_en_get_phys_port_id,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
@@ -2873,8 +2871,6 @@ static const struct net_device_ops mlx4_netdev_ops_master = {
 	.ndo_rx_flow_steer	= mlx4_en_filter_rfs,
 #endif
 	.ndo_get_phys_port_id	= mlx4_en_get_phys_port_id,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= mlx4_en_features_check,
 	.ndo_set_tx_maxrate	= mlx4_en_set_tx_maxrate,
 	.ndo_bpf		= mlx4_xdp,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7a79d330c075..f27f509ab028 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4621,8 +4621,6 @@ const struct net_device_ops mlx5e_netdev_ops = {
 	.ndo_change_mtu          = mlx5e_change_nic_mtu,
 	.ndo_do_ioctl            = mlx5e_ioctl,
 	.ndo_set_tx_maxrate      = mlx5e_set_tx_maxrate,
-	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_tx_timeout          = mlx5e_tx_timeout,
 	.ndo_bpf		 = mlx5e_xdp,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 989c70c1eda3..cfa0e8552975 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -653,8 +653,6 @@ static const struct net_device_ops mlx5e_netdev_ops_uplink_rep = {
 	.ndo_has_offload_stats	 = mlx5e_rep_has_offload_stats,
 	.ndo_get_offload_stats	 = mlx5e_rep_get_offload_stats,
 	.ndo_change_mtu          = mlx5e_uplink_rep_change_mtu,
-	.ndo_udp_tunnel_add      = udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del      = udp_tunnel_nic_del_port,
 	.ndo_features_check      = mlx5e_features_check,
 	.ndo_set_vf_mac          = mlx5e_set_vf_mac,
 	.ndo_set_vf_rate         = mlx5e_set_vf_rate,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f21fb573ea3e..7ba8f4c7f26d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3656,8 +3656,6 @@ const struct net_device_ops nfp_net_netdev_ops = {
 	.ndo_set_features	= nfp_net_set_features,
 	.ndo_features_check	= nfp_net_features_check,
 	.ndo_get_phys_port_name	= nfp_net_get_phys_port_name,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_bpf		= nfp_net_xdp,
 	.ndo_get_devlink_port	= nfp_devlink_get_devlink_port,
 };
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9cf960a6d007..4bf94797aac5 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -663,8 +663,6 @@ static const struct net_device_ops qede_netdev_ops = {
 	.ndo_get_vf_config	= qede_get_vf_config,
 	.ndo_set_vf_rate	= qede_set_vf_rate,
 #endif
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qede_features_check,
 	.ndo_bpf		= qede_xdp,
 #ifdef CONFIG_RFS_ACCEL
@@ -688,8 +686,6 @@ static const struct net_device_ops qede_netdev_vf_ops = {
 	.ndo_fix_features	= qede_fix_features,
 	.ndo_set_features	= qede_set_features,
 	.ndo_get_stats64	= qede_get_stats64,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qede_features_check,
 };
 
@@ -707,8 +703,6 @@ static const struct net_device_ops qede_netdev_vf_xdp_ops = {
 	.ndo_fix_features	= qede_fix_features,
 	.ndo_set_features	= qede_set_features,
 	.ndo_get_stats64	= qede_get_stats64,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qede_features_check,
 	.ndo_bpf		= qede_xdp,
 	.ndo_xdp_xmit		= qede_xdp_transmit,
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index c2faf96fcade..96b947fde646 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -520,8 +520,6 @@ static const struct net_device_ops qlcnic_netdev_ops = {
 	.ndo_fdb_del		= qlcnic_fdb_del,
 	.ndo_fdb_dump		= qlcnic_fdb_dump,
 	.ndo_get_phys_port_id	= qlcnic_get_phys_port_id,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_features_check	= qlcnic_features_check,
 #ifdef CONFIG_QLCNIC_SRIOV
 	.ndo_set_vf_mac		= qlcnic_sriov_set_vf_mac,
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 718308076341..36c8625a6fd7 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -612,8 +612,6 @@ static const struct net_device_ops efx_netdev_ops = {
 #ifdef CONFIG_RFS_ACCEL
 	.ndo_rx_flow_steer	= efx_filter_rfs,
 #endif
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_xdp_xmit		= efx_xdp_xmit,
 	.ndo_bpf		= efx_xdp
 };
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 7178468302c8..aec92440eef1 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -258,8 +258,6 @@ static const struct net_device_ops nsim_netdev_ops = {
 	.ndo_setup_tc		= nsim_setup_tc,
 	.ndo_set_features	= nsim_set_features,
 	.ndo_bpf		= nsim_bpf,
-	.ndo_udp_tunnel_add	= udp_tunnel_nic_add_port,
-	.ndo_udp_tunnel_del	= udp_tunnel_nic_del_port,
 	.ndo_get_devlink_port	= nsim_get_devlink_port,
 };
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 259be67644e3..1ec3ac5d5bbf 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1213,19 +1213,6 @@ struct netdev_net_notifier {
  *				 struct netdev_phys_item_id *ppid)
  *	Called to get the parent ID of the physical port of this device.
  *
- * void (*ndo_udp_tunnel_add)(struct net_device *dev,
- *			      struct udp_tunnel_info *ti);
- *	Called by UDP tunnel to notify a driver about the UDP port and socket
- *	address family that a UDP tunnel is listnening to. It is called only
- *	when a new port starts listening. The operation is protected by the
- *	RTNL.
- *
- * void (*ndo_udp_tunnel_del)(struct net_device *dev,
- *			      struct udp_tunnel_info *ti);
- *	Called by UDP tunnel to notify the driver about a UDP port and socket
- *	address family that the UDP tunnel is not listening to anymore. The
- *	operation is protected by the RTNL.
- *
  * void* (*ndo_dfwd_add_station)(struct net_device *pdev,
  *				 struct net_device *dev)
  *	Called by upper layer devices to accelerate switching or other
@@ -1464,10 +1451,6 @@ struct net_device_ops {
 							  struct netdev_phys_item_id *ppid);
 	int			(*ndo_get_phys_port_name)(struct net_device *dev,
 							  char *name, size_t len);
-	void			(*ndo_udp_tunnel_add)(struct net_device *dev,
-						      struct udp_tunnel_info *ti);
-	void			(*ndo_udp_tunnel_del)(struct net_device *dev,
-						      struct udp_tunnel_info *ti);
 	void*			(*ndo_dfwd_add_station)(struct net_device *pdev,
 							struct net_device *dev);
 	void			(*ndo_dfwd_del_station)(struct net_device *pdev,
-- 
2.26.2

