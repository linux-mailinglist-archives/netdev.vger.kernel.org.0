Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 151945BBD03
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbiIRJvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiIRJuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:25 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0E318B08
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:59 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjfD06NqzHndw;
        Sun, 18 Sep 2022 17:47:48 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:54 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 43/55] net: adjust the prototype of xxx_set_features()
Date:   Sun, 18 Sep 2022 09:43:24 +0000
Message-ID: <20220918094336.28958-44-shenjian15@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220918094336.28958-1-shenjian15@huawei.com>
References: <20220918094336.28958-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function net_device_ops.ndo_set_features() using
netdev_features_t as parameters. For the prototype of
netdev_features_t will be extended to be larger than 8
bytes, so change the prototype of the function, change
the prototype of input features to'netdev_features_t *'.

So changes all the implement for this function of all
the netdev drivers, and relative functions.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 20 ++++----
 .../net/ethernet/aquantia/atlantic/aq_main.c  | 16 +++---
 drivers/net/ethernet/asix/ax88796c_main.c     |  6 +--
 .../net/ethernet/atheros/atl1c/atl1c_main.c   | 13 ++---
 .../net/ethernet/atheros/atl1e/atl1e_main.c   | 24 +++++----
 drivers/net/ethernet/atheros/atlx/atl1.c      |  4 +-
 drivers/net/ethernet/atheros/atlx/atl2.c      | 14 ++---
 drivers/net/ethernet/atheros/atlx/atlx.c      | 12 ++---
 drivers/net/ethernet/broadcom/bcmsysport.c    | 16 +++---
 drivers/net/ethernet/broadcom/bnx2.c          |  8 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |  8 +--
 .../net/ethernet/broadcom/bnx2x/bnx2x_cmn.h   |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 11 ++--
 .../net/ethernet/broadcom/genet/bcmgenet.c    |  6 +--
 drivers/net/ethernet/broadcom/tg3.c           | 12 +++--
 drivers/net/ethernet/brocade/bna/bnad.c       |  7 +--
 drivers/net/ethernet/cadence/macb_main.c      | 23 +++++----
 drivers/net/ethernet/calxeda/xgmac.c          |  7 +--
 .../net/ethernet/cavium/liquidio/lio_main.c   | 14 ++---
 .../ethernet/cavium/liquidio/lio_vf_main.c    | 12 ++---
 .../net/ethernet/cavium/thunder/nicvf_main.c  |  8 +--
 .../ethernet/cavium/thunder/nicvf_queues.c    |  7 +--
 .../ethernet/cavium/thunder/nicvf_queues.h    |  2 +-
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c     |  7 +--
 drivers/net/ethernet/chelsio/cxgb/sge.c       |  4 +-
 drivers/net/ethernet/chelsio/cxgb/sge.h       |  2 +-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   | 14 ++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  9 ++--
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  6 +--
 drivers/net/ethernet/cortina/gemini.c         |  4 +-
 drivers/net/ethernet/davicom/dm9000.c         |  6 +--
 drivers/net/ethernet/engleder/tsnep_main.c    |  6 +--
 drivers/net/ethernet/faraday/ftgmac100.c      |  4 +-
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 10 ++--
 drivers/net/ethernet/freescale/enetc/enetc.c  | 12 ++---
 drivers/net/ethernet/freescale/enetc/enetc.h  |  2 +-
 .../net/ethernet/freescale/enetc/enetc_pf.c   |  8 +--
 .../net/ethernet/freescale/enetc/enetc_vf.c   |  2 +-
 drivers/net/ethernet/freescale/fec_main.c     | 12 ++---
 drivers/net/ethernet/freescale/gianfar.h      |  2 +-
 .../net/ethernet/freescale/gianfar_ethtool.c  |  6 +--
 drivers/net/ethernet/google/gve/gve_main.c    |  4 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  8 +--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 16 +++---
 .../net/ethernet/huawei/hinic/hinic_main.c    | 26 +++++-----
 drivers/net/ethernet/ibm/ibmveth.c            | 12 ++---
 drivers/net/ethernet/intel/e100.c             |  6 +--
 drivers/net/ethernet/intel/e1000/e1000_main.c | 18 +++----
 drivers/net/ethernet/intel/e1000e/netdev.c    |  8 +--
 drivers/net/ethernet/intel/i40e/i40e.h        |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 16 +++---
 drivers/net/ethernet/intel/iavf/iavf.h        |  4 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 28 +++++-----
 drivers/net/ethernet/intel/ice/ice_main.c     | 51 ++++++++++---------
 drivers/net/ethernet/intel/igb/igb_main.c     | 17 ++++---
 drivers/net/ethernet/intel/igbvf/netdev.c     |  4 +-
 drivers/net/ethernet/intel/igc/igc_main.c     | 15 +++---
 drivers/net/ethernet/intel/ixgb/ixgb_main.c   |  7 +--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 14 ++---
 drivers/net/ethernet/jme.c                    |  5 +-
 drivers/net/ethernet/marvell/mv643xx_eth.c    |  7 +--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  8 +--
 .../marvell/octeontx2/nic/otx2_common.c       |  9 ++--
 .../marvell/octeontx2/nic/otx2_common.h       |  2 +-
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  |  8 +--
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  |  2 +-
 drivers/net/ethernet/marvell/sky2.c           | 22 ++++----
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  7 +--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 48 ++++++++---------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  7 ++-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 10 ++--
 drivers/net/ethernet/micrel/ksz884x.c         |  4 +-
 drivers/net/ethernet/mscc/ocelot_net.c        | 10 ++--
 drivers/net/ethernet/neterion/s2io.c          |  7 +--
 .../ethernet/netronome/nfp/nfp_net_common.c   | 22 ++++----
 drivers/net/ethernet/netronome/nfp/nfp_port.c |  5 +-
 drivers/net/ethernet/netronome/nfp/nfp_port.h |  3 +-
 drivers/net/ethernet/nvidia/forcedeth.c       | 23 +++++----
 .../ethernet/oki-semi/pch_gbe/pch_gbe_main.c  |  4 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 42 +++++++--------
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  8 +--
 drivers/net/ethernet/qlogic/qede/qede.h       |  2 +-
 .../net/ethernet/qlogic/qede/qede_filter.c    |  6 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic.h   |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  7 +--
 drivers/net/ethernet/qualcomm/emac/emac.c     |  6 +--
 drivers/net/ethernet/realtek/8139cp.c         |  9 ++--
 drivers/net/ethernet/realtek/8139too.c        |  7 +--
 drivers/net/ethernet/realtek/r8169_main.c     | 16 +++---
 drivers/net/ethernet/renesas/ravb.h           |  3 +-
 drivers/net/ethernet/renesas/ravb_main.c      | 12 ++---
 drivers/net/ethernet/renesas/sh_eth.c         |  8 +--
 .../net/ethernet/samsung/sxgbe/sxgbe_main.c   |  6 +--
 drivers/net/ethernet/sfc/efx_common.c         |  6 +--
 drivers/net/ethernet/sfc/efx_common.h         |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 +--
 drivers/net/ethernet/sfc/siena/efx_common.c   |  7 +--
 drivers/net/ethernet/sfc/siena/efx_common.h   |  2 +-
 drivers/net/ethernet/socionext/netsec.c       |  5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 +-
 .../net/ethernet/synopsys/dwc-xlgmac-net.c    | 20 ++++----
 drivers/net/hyperv/netvsc_drv.c               | 14 ++---
 drivers/net/netdevsim/netdev.c                |  4 +-
 drivers/net/usb/aqc111.c                      |  8 +--
 drivers/net/usb/ax88179_178a.c                |  4 +-
 drivers/net/usb/lan78xx.c                     | 10 ++--
 drivers/net/usb/r8152.c                       |  6 +--
 drivers/net/usb/smsc75xx.c                    |  6 +--
 drivers/net/usb/smsc95xx.c                    |  8 +--
 drivers/net/veth.c                            |  6 +--
 drivers/net/virtio_net.c                      |  8 +--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 22 ++++----
 drivers/net/vmxnet3/vmxnet3_int.h             |  3 +-
 drivers/net/wireless/ath/ath6kl/main.c        | 10 ++--
 drivers/net/xen-netfront.c                    |  4 +-
 drivers/s390/net/qeth_core.h                  |  2 +-
 drivers/s390/net/qeth_core_main.c             | 18 +++----
 drivers/staging/qlge/qlge_main.c              | 13 ++---
 include/linux/netdevice.h                     |  2 +-
 net/core/dev.c                                |  2 +-
 123 files changed, 616 insertions(+), 567 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index d41ac42762ed..7b4b9bed8979 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1343,14 +1343,14 @@ static void vector_fix_features(struct net_device *dev,
 }
 
 static int vector_set_features(struct net_device *dev,
-	netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct vector_private *vp = netdev_priv(dev);
 	/* Adjust buffer sizes for GSO/GRO. Unfortunately, there is
 	 * no way to negotiate it on raw sockets, so we can change
 	 * only our side.
 	 */
-	if (netdev_feature_test(NETIF_F_GRO_BIT, features))
+	if (netdev_feature_test(NETIF_F_GRO_BIT, *features))
 		/* All new frame buffers will be GRO-sized */
 		vp->req_size = 65536;
 	else
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index e84a69fb4812..3709f8674724 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2223,7 +2223,7 @@ static void xgbe_fix_features(struct net_device *netdev,
 }
 
 static int xgbe_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_hw_if *hw_if = &pdata->hw_if;
@@ -2237,29 +2237,29 @@ static int xgbe_set_features(struct net_device *netdev,
 	rxvlan_filter = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 					    pdata->netdev_features);
 
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) && !rxhash)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features) && !rxhash)
 		ret = hw_if->enable_rss(pdata);
-	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) && rxhash)
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, *features) && rxhash)
 		ret = hw_if->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) && !rxcsum)
 		hw_if->enable_rx_csum(pdata);
-	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && rxcsum)
+	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) && rxcsum)
 		hw_if->disable_rx_csum(pdata);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && !rxvlan)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) && !rxvlan)
 		hw_if->enable_rx_vlan_stripping(pdata);
-	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && rxvlan)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) && rxvlan)
 		hw_if->disable_rx_vlan_stripping(pdata);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && !rxvlan_filter)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) && !rxvlan_filter)
 		hw_if->enable_rx_vlan_filtering(pdata);
-	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && rxvlan_filter)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) && rxvlan_filter)
 		hw_if->disable_rx_vlan_filtering(pdata);
 
-	pdata->netdev_features = features;
+	netdev_features_copy(pdata->netdev_features, *features);
 
 	DBGPR("<--xgbe_set_features\n");
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index cd714a6cdf27..486f54186806 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -160,10 +160,10 @@ static int aq_ndev_change_mtu(struct net_device *ndev, int new_mtu)
 }
 
 static int aq_ndev_set_features(struct net_device *ndev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
-	bool is_vlan_tx_insert = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-	bool is_vlan_rx_strip = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
+	bool is_vlan_tx_insert = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
+	bool is_vlan_rx_strip = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features);
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	bool need_ndev_restart = false;
 	struct aq_nic_cfg_s *aq_cfg;
@@ -173,14 +173,14 @@ static int aq_ndev_set_features(struct net_device *ndev,
 
 	aq_cfg = aq_nic_get_cfg(aq_nic);
 
-	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, *features)) {
 		if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_NTUPLE_BIT)) {
 			err = aq_clear_rxnfc_all_rules(aq_nic);
 			if (unlikely(err))
 				goto err_exit;
 		}
 	}
-	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features)) {
 		if (netdev_active_feature_test(aq_nic->ndev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT)) {
 			err = aq_filters_vlan_offload_off(aq_nic);
 			if (unlikely(err))
@@ -188,11 +188,11 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	aq_cfg->features = features;
+	netdev_features_copy(aq_cfg->features, *features);
 
 	if (netdev_feature_test(NETIF_F_LRO_BIT,
 				*aq_cfg->aq_hw_caps->hw_features)) {
-		is_lro = netdev_feature_test(NETIF_F_LRO_BIT, features);
+		is_lro = netdev_feature_test(NETIF_F_LRO_BIT, *features);
 
 		if (aq_cfg->is_lro != is_lro) {
 			aq_cfg->is_lro = is_lro;
@@ -200,7 +200,7 @@ static int aq_ndev_set_features(struct net_device *ndev,
 		}
 	}
 
-	netdev_features_xor(changed, aq_nic->ndev->features, features);
+	netdev_features_xor(changed, aq_nic->ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		err = aq_nic->aq_hw_ops->hw_set_offload(aq_nic->aq_hw,
 							aq_cfg);
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index e61aa93c7c74..164437975599 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -921,16 +921,16 @@ ax88796c_close(struct net_device *ndev)
 }
 
 static int
-ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
+ax88796c_set_features(struct net_device *ndev, const netdev_features_t *features)
 {
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (!netdev_features_intersects(changed, ax88796c_features))
 		return 0;
 
-	ndev->features = features;
+	netdev_active_features_copy(ndev, *features);
 
 	if (netdev_features_intersects(changed, ax88796c_features))
 		ax88796c_set_csums(ax_local);
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index b38b508db29c..4ce52ea0833f 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -427,9 +427,10 @@ static void atl1c_set_multi(struct net_device *netdev)
 	}
 }
 
-static void __atl1c_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
+static void __atl1c_vlan_mode(const netdev_features_t *features,
+			      u32 *mac_ctrl_data)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -439,7 +440,7 @@ static void __atl1c_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 }
 
 static void atl1c_vlan_mode(struct net_device *netdev,
-	netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct atl1c_adapter *adapter = netdev_priv(netdev);
 	struct pci_dev *pdev = adapter->pdev;
@@ -461,7 +462,7 @@ static void atl1c_restore_vlan(struct atl1c_adapter *adapter)
 
 	if (netif_msg_pktdata(adapter))
 		dev_dbg(&pdev->dev, "atl1c_restore_vlan\n");
-	atl1c_vlan_mode(adapter->netdev, adapter->netdev->features);
+	atl1c_vlan_mode(adapter->netdev, &adapter->netdev->features);
 }
 
 /**
@@ -527,11 +528,11 @@ static void atl1c_fix_features(struct net_device *netdev,
 }
 
 static int atl1c_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1c_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
index fef2ba816451..29245ecea761 100644
--- a/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
+++ b/drivers/net/ethernet/atheros/atl1e/atl1e_main.c
@@ -296,10 +296,11 @@ static void atl1e_set_multi(struct net_device *netdev)
 	}
 }
 
-static void __atl1e_rx_mode(netdev_features_t features, u32 *mac_ctrl_data)
+static void __atl1e_rx_mode(const netdev_features_t *features,
+			    u32 *mac_ctrl_data)
 {
 
-	if (netdev_feature_test(NETIF_F_RXALL_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, *features)) {
 		/* enable RX of ALL frames */
 		*mac_ctrl_data |= MAC_CTRL_DBG;
 	} else {
@@ -309,7 +310,7 @@ static void __atl1e_rx_mode(netdev_features_t features, u32 *mac_ctrl_data)
 }
 
 static void atl1e_rx_mode(struct net_device *netdev,
-	netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 	u32 mac_ctrl_data = 0;
@@ -324,9 +325,10 @@ static void atl1e_rx_mode(struct net_device *netdev,
 }
 
 
-static void __atl1e_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
+static void __atl1e_vlan_mode(const netdev_features_t *features,
+			      u32 *mac_ctrl_data)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		/* enable VLAN tag insert/strip */
 		*mac_ctrl_data |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -336,7 +338,7 @@ static void __atl1e_vlan_mode(netdev_features_t features, u32 *mac_ctrl_data)
 }
 
 static void atl1e_vlan_mode(struct net_device *netdev,
-	netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct atl1e_adapter *adapter = netdev_priv(netdev);
 	u32 mac_ctrl_data = 0;
@@ -353,7 +355,7 @@ static void atl1e_vlan_mode(struct net_device *netdev,
 static void atl1e_restore_vlan(struct atl1e_adapter *adapter)
 {
 	netdev_dbg(adapter->netdev, "%s\n", __func__);
-	atl1e_vlan_mode(adapter->netdev, adapter->netdev->features);
+	atl1e_vlan_mode(adapter->netdev, &adapter->netdev->features);
 }
 
 /**
@@ -396,11 +398,11 @@ static void atl1e_fix_features(struct net_device *netdev,
 }
 
 static int atl1e_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl1e_vlan_mode(netdev, features);
 
@@ -1059,7 +1061,7 @@ static void atl1e_setup_mac_ctrl(struct atl1e_adapter *adapter)
 	value |= (((u32)adapter->hw.preamble_len &
 		  MAC_CTRL_PRMLEN_MASK) << MAC_CTRL_PRMLEN_SHIFT);
 
-	__atl1e_vlan_mode(netdev->features, &value);
+	__atl1e_vlan_mode(&netdev->features, &value);
 
 	value |= MAC_CTRL_BC_EN;
 	if (netdev->flags & IFF_PROMISC)
@@ -2142,7 +2144,7 @@ static int atl1e_suspend(struct pci_dev *pdev, pm_message_t state)
 				 MAC_CTRL_PRMLEN_MASK) <<
 				 MAC_CTRL_PRMLEN_SHIFT);
 
-		__atl1e_vlan_mode(netdev->features, &mac_ctrl_data);
+		__atl1e_vlan_mode(&netdev->features, &mac_ctrl_data);
 
 		/* magic packet maybe Broadcast&multicast&Unicast frame */
 		if (wufc & AT_WUFC_MAG)
diff --git a/drivers/net/ethernet/atheros/atlx/atl1.c b/drivers/net/ethernet/atheros/atlx/atl1.c
index 745ff416f095..20c8828864ee 100644
--- a/drivers/net/ethernet/atheros/atlx/atl1.c
+++ b/drivers/net/ethernet/atheros/atlx/atl1.c
@@ -1261,7 +1261,7 @@ static void atl1_setup_mac_ctrl(struct atl1_adapter *adapter)
 	value |= (((u32) adapter->hw.preamble_len
 		   & MAC_CTRL_PRMLEN_MASK) << MAC_CTRL_PRMLEN_SHIFT);
 	/* vlan */
-	__atlx_vlan_mode(netdev->features, &value);
+	__atlx_vlan_mode(&netdev->features, &value);
 	/* rx checksum
 	   if (adapter->rx_csum)
 	   value |= MAC_CTRL_RX_CHKSUM_EN;
@@ -2799,7 +2799,7 @@ static int atl1_suspend(struct device *dev)
 			ctrl |= MAC_CTRL_DUPLX;
 		ctrl |= (((u32)adapter->hw.preamble_len &
 			MAC_CTRL_PRMLEN_MASK) << MAC_CTRL_PRMLEN_SHIFT);
-		__atlx_vlan_mode(netdev->features, &ctrl);
+		__atlx_vlan_mode(&netdev->features, &ctrl);
 		if (wufc & ATLX_WUFC_MAG)
 			ctrl |= MAC_CTRL_BC_EN;
 		iowrite32(ctrl, hw->hw_addr + REG_MAC_CTRL);
diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
index 589c9f38e3ae..2bc574a1cc25 100644
--- a/drivers/net/ethernet/atheros/atlx/atl2.c
+++ b/drivers/net/ethernet/atheros/atlx/atl2.c
@@ -341,9 +341,9 @@ static inline void atl2_irq_disable(struct atl2_adapter *adapter)
     synchronize_irq(adapter->pdev->irq);
 }
 
-static void __atl2_vlan_mode(netdev_features_t features, u32 *ctrl)
+static void __atl2_vlan_mode(const netdev_features_t *features, u32 *ctrl)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -353,7 +353,7 @@ static void __atl2_vlan_mode(netdev_features_t features, u32 *ctrl)
 }
 
 static void atl2_vlan_mode(struct net_device *netdev,
-	netdev_features_t features)
+			   const netdev_features_t *features)
 {
 	struct atl2_adapter *adapter = netdev_priv(netdev);
 	u32 ctrl;
@@ -369,7 +369,7 @@ static void atl2_vlan_mode(struct net_device *netdev,
 
 static void atl2_restore_vlan(struct atl2_adapter *adapter)
 {
-	atl2_vlan_mode(adapter->netdev, adapter->netdev->features);
+	atl2_vlan_mode(adapter->netdev, &adapter->netdev->features);
 }
 
 static void atl2_fix_features(struct net_device *netdev,
@@ -386,11 +386,11 @@ static void atl2_fix_features(struct net_device *netdev,
 }
 
 static int atl2_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atl2_vlan_mode(netdev, features);
 
@@ -1125,7 +1125,7 @@ static void atl2_setup_mac_ctrl(struct atl2_adapter *adapter)
 		MAC_CTRL_PRMLEN_SHIFT);
 
 	/* vlan */
-	__atl2_vlan_mode(netdev->features, &value);
+	__atl2_vlan_mode(&netdev->features, &value);
 
 	/* filter mode */
 	value |= MAC_CTRL_BC_EN;
diff --git a/drivers/net/ethernet/atheros/atlx/atlx.c b/drivers/net/ethernet/atheros/atlx/atlx.c
index 1943f97e8283..c0b49b5d20b4 100644
--- a/drivers/net/ethernet/atheros/atlx/atlx.c
+++ b/drivers/net/ethernet/atheros/atlx/atlx.c
@@ -205,9 +205,9 @@ static void atlx_link_chg_task(struct work_struct *work)
 	spin_unlock_irqrestore(&adapter->lock, flags);
 }
 
-static void __atlx_vlan_mode(netdev_features_t features, u32 *ctrl)
+static void __atlx_vlan_mode(const netdev_features_t *features, u32 *ctrl)
 {
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		/* enable VLAN tag insert/strip */
 		*ctrl |= MAC_CTRL_RMV_VLAN;
 	} else {
@@ -217,7 +217,7 @@ static void __atlx_vlan_mode(netdev_features_t features, u32 *ctrl)
 }
 
 static void atlx_vlan_mode(struct net_device *netdev,
-	netdev_features_t features)
+			   const netdev_features_t *features)
 {
 	struct atlx_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
@@ -234,7 +234,7 @@ static void atlx_vlan_mode(struct net_device *netdev,
 
 static void atlx_restore_vlan(struct atlx_adapter *adapter)
 {
-	atlx_vlan_mode(adapter->netdev, adapter->netdev->features);
+	atlx_vlan_mode(adapter->netdev, &adapter->netdev->features);
 }
 
 static void atlx_fix_features(struct net_device *netdev,
@@ -251,11 +251,11 @@ static void atlx_fix_features(struct net_device *netdev,
 }
 
 static int atlx_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		atlx_vlan_mode(netdev, features);
 
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 64dec1d1217b..e6c8c6a9df1f 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -118,12 +118,12 @@ static inline void dma_desc_set_addr(struct bcm_sysport_priv *priv,
 
 /* Ethtool operations */
 static void bcm_sysport_set_rx_csum(struct net_device *dev,
-				    netdev_features_t wanted)
+				    const netdev_features_t *wanted)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	u32 reg;
 
-	priv->rx_chk_en = netdev_feature_test(NETIF_F_RXCSUM_BIT, wanted);
+	priv->rx_chk_en = netdev_feature_test(NETIF_F_RXCSUM_BIT, *wanted);
 	reg = rxchk_readl(priv, RXCHK_CONTROL);
 	/* Clear L2 header checks, which would prevent BPDUs
 	 * from being received.
@@ -155,7 +155,7 @@ static void bcm_sysport_set_rx_csum(struct net_device *dev,
 }
 
 static void bcm_sysport_set_tx_csum(struct net_device *dev,
-				    netdev_features_t wanted)
+				    const netdev_features_t *wanted)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	netdev_features_t tx_csum_features;
@@ -168,7 +168,7 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = netdev_features_intersects(tx_csum_features, wanted);
+	priv->tsb_en = netdev_features_intersects(tx_csum_features, *wanted);
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
@@ -185,12 +185,12 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	tdma_writel(priv, reg, TDMA_CONTROL);
 
 	/* Default TPID is ETH_P_8021AD, change to ETH_P_8021Q */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, wanted))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *wanted))
 		tdma_writel(priv, ETH_P_8021Q, TDMA_TPID);
 }
 
 static int bcm_sysport_set_features(struct net_device *dev,
-				    netdev_features_t features)
+				    const netdev_features_t *features)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	int ret;
@@ -1983,7 +1983,7 @@ static int bcm_sysport_open(struct net_device *dev)
 	/* Apply features again in case we changed them while interface was
 	 * down
 	 */
-	bcm_sysport_set_features(dev, dev->features);
+	bcm_sysport_set_features(dev, &dev->features);
 
 	/* Set MAC address */
 	umac_set_hw_addr(priv, dev->dev_addr);
@@ -2845,7 +2845,7 @@ static int __maybe_unused bcm_sysport_resume(struct device *d)
 	}
 
 	/* Restore enabled features */
-	bcm_sysport_set_features(dev, dev->features);
+	bcm_sysport_set_features(dev, &dev->features);
 
 	rbuf_init(priv);
 
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 558d6a2f4e0a..7ea525d1dc11 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7748,12 +7748,12 @@ bnx2_set_phys_id(struct net_device *dev, enum ethtool_phys_id_state state)
 }
 
 static int
-bnx2_set_features(struct net_device *dev, netdev_features_t features)
+bnx2_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
 	/* TSO with VLAN tag won't work with current firmware */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features)) {
 		netdev_features_t tso;
 
 		netdev_features_and(tso, dev->hw_features, NETIF_F_ALL_TSO);
@@ -7762,11 +7762,11 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 		netdev_vlan_features_clear(dev, NETIF_F_ALL_TSO);
 	}
 
-	if ((netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) !=
+	if ((netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) !=
 	     !!(bp->rx_mode & BNX2_EMAC_RX_MODE_KEEP_VLAN_TAG)) &&
 	    netif_running(dev)) {
 		bnx2_netif_stop(bp, false);
-		dev->features = features;
+		netdev_active_features_copy(dev, *features);
 		bnx2_set_rx_mode(dev);
 		bnx2_fw_sync(bp, BNX2_DRV_MSG_CODE_KEEP_VLAN_UPDATE, 0, 1);
 		bnx2_netif_start(bp, false);
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 23a9746c6e55..cb20d2ad72f0 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -4935,18 +4935,18 @@ void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features)
 		netdev_feature_del(NETIF_F_LRO_BIT, *features);
 }
 
-int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
+int bnx2x_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct bnx2x *bp = netdev_priv(dev);
 	netdev_features_t changes;
 	bool bnx2x_reload = false;
 	int rc;
 
-	netdev_features_xor(changes, features, dev->features);
+	netdev_features_xor(changes, *features, dev->features);
 
 	/* VFs or non SRIOV PFs should be able to change loopback feature */
 	if (!pci_num_vf(bp->pdev)) {
-		if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features)) {
 			if (bp->link_params.loopback_mode != LOOPBACK_BMAC) {
 				bp->link_params.loopback_mode = LOOPBACK_BMAC;
 				bnx2x_reload = true;
@@ -4967,7 +4967,7 @@ int bnx2x_set_features(struct net_device *dev, netdev_features_t features)
 
 	if (bnx2x_reload) {
 		if (bp->recovery_state == BNX2X_RECOVERY_DONE) {
-			dev->features = features;
+			netdev_active_features_copy(dev, *features);
 			rc = bnx2x_reload_if_running(dev);
 			return rc ? rc : 1;
 		}
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
index 4c66ef3e04bf..34b140ed0d7b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.h
@@ -607,7 +607,7 @@ int bnx2x_fcoe_get_wwn(struct net_device *dev, u64 *wwn, int type);
 #endif
 
 void bnx2x_fix_features(struct net_device *dev, netdev_features_t *features);
-int bnx2x_set_features(struct net_device *dev, netdev_features_t features);
+int bnx2x_set_features(struct net_device *dev, const netdev_features_t *features);
 
 /**
  * bnx2x_tx_timeout - tx timeout netdev callback
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index b6ca502a3af1..e62d5f9cc211 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11208,7 +11208,8 @@ static void bnxt_fix_features(struct net_device *dev,
 #endif
 }
 
-static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
+static int bnxt_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	u32 flags = bp->flags;
@@ -11218,18 +11219,18 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	bool update_tpa = false;
 
 	flags &= ~BNXT_FLAG_ALL_CONFIG_FEATS;
-	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
+	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features))
 		flags |= BNXT_FLAG_GRO;
-	else if (netdev_feature_test(NETIF_F_LRO_BIT, features))
+	else if (netdev_feature_test(NETIF_F_LRO_BIT, *features))
 		flags |= BNXT_FLAG_LRO;
 
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (netdev_features_intersects(features, BNXT_HW_FEATURE_VLAN_ALL_RX))
+	if (netdev_features_intersects(*features, BNXT_HW_FEATURE_VLAN_ALL_RX))
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
-	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features))
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *features))
 		flags |= BNXT_FLAG_RFS;
 
 	changes = flags ^ bp->flags;
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 711dddfcc1d1..c69fd3b2a542 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -795,7 +795,7 @@ static int bcmgenet_set_link_ksettings(struct net_device *dev,
 }
 
 static int bcmgenet_set_features(struct net_device *dev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 	u32 reg;
@@ -3377,7 +3377,7 @@ static int bcmgenet_open(struct net_device *dev)
 	/* Apply features again in case we changed them while interface was
 	 * down
 	 */
-	bcmgenet_set_features(dev, dev->features);
+	bcmgenet_set_features(dev, &dev->features);
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
@@ -4241,7 +4241,7 @@ static int bcmgenet_resume(struct device *d)
 	bcmgenet_mii_config(priv->dev, false);
 
 	/* Restore enabled features */
-	bcmgenet_set_features(dev, dev->features);
+	bcmgenet_set_features(dev, &dev->features);
 
 	bcmgenet_set_hw_addr(priv, dev->dev_addr);
 
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index be6d69b9c3c1..e4fa6f2fdc72 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -8278,11 +8278,12 @@ static int tg3_phy_lpbk_set(struct tg3 *tp, u32 speed, bool extlpbk)
 	return 0;
 }
 
-static void tg3_set_loopback(struct net_device *dev, netdev_features_t features)
+static void tg3_set_loopback(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
-	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features)) {
 		if (tp->mac_mode & MAC_MODE_PORT_INT_LPBACK)
 			return;
 
@@ -8313,11 +8314,12 @@ static void tg3_fix_features(struct net_device *dev,
 		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 }
 
-static int tg3_set_features(struct net_device *dev, netdev_features_t features)
+static int tg3_set_features(struct net_device *dev,
+			    const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) && netif_running(dev))
 		tg3_set_loopback(dev, features);
 
@@ -11647,7 +11649,7 @@ static int tg3_start(struct tg3 *tp, bool reset_phy, bool test_irq,
 	 * make sure that it's installed properly now.
 	 */
 	if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
-		tg3_set_loopback(dev, dev->features);
+		tg3_set_loopback(dev, &dev->features);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 087aa63598bd..cef5f7704d69 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3344,18 +3344,19 @@ bnad_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	return 0;
 }
 
-static int bnad_set_features(struct net_device *dev, netdev_features_t features)
+static int bnad_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	struct bnad *bnad = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) && netif_running(dev)) {
 		unsigned long flags;
 
 		spin_lock_irqsave(&bnad->bna_lock, flags);
 
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			bna_rx_vlan_strip_enable(bnad->rx_info[0].rx);
 		else
 			bna_rx_vlan_strip_disable(bnad->rx_info[0].rx);
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 7b49abf30def..9b31b70309c7 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3694,7 +3694,7 @@ static int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 }
 
 static inline void macb_set_txcsum_feature(struct macb *bp,
-					   netdev_features_t features)
+					   const netdev_features_t *features)
 {
 	u32 val;
 
@@ -3702,7 +3702,7 @@ static inline void macb_set_txcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, DMACFG);
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features))
 		val |= GEM_BIT(TXCOEN);
 	else
 		val &= ~GEM_BIT(TXCOEN);
@@ -3711,7 +3711,7 @@ static inline void macb_set_txcsum_feature(struct macb *bp,
 }
 
 static inline void macb_set_rxcsum_feature(struct macb *bp,
-					   netdev_features_t features)
+					   const netdev_features_t *features)
 {
 	struct net_device *netdev = bp->dev;
 	u32 val;
@@ -3720,7 +3720,8 @@ static inline void macb_set_rxcsum_feature(struct macb *bp,
 		return;
 
 	val = gem_readl(bp, NCFGR);
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !(netdev->flags & IFF_PROMISC))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) &&
+	    !(netdev->flags & IFF_PROMISC))
 		val |= GEM_BIT(RXCOEN);
 	else
 		val &= ~GEM_BIT(RXCOEN);
@@ -3729,22 +3730,22 @@ static inline void macb_set_rxcsum_feature(struct macb *bp,
 }
 
 static inline void macb_set_rxflow_feature(struct macb *bp,
-					   netdev_features_t features)
+					   const netdev_features_t *features)
 {
 	if (!macb_is_gem(bp))
 		return;
 
 	gem_enable_flow_filters(bp,
-				netdev_feature_test(NETIF_F_NTUPLE_BIT, features));
+				netdev_feature_test(NETIF_F_NTUPLE_BIT, *features));
 }
 
 static int macb_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct macb *bp = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 
 	/* TX checksum offload */
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, changed))
@@ -3768,16 +3769,16 @@ static void macb_restore_features(struct macb *bp)
 	struct ethtool_rx_fs_item *item;
 
 	/* TX checksum offload */
-	macb_set_txcsum_feature(bp, features);
+	macb_set_txcsum_feature(bp, &features);
 
 	/* RX checksum offload */
-	macb_set_rxcsum_feature(bp, features);
+	macb_set_rxcsum_feature(bp, &features);
 
 	/* RX Flow Filters */
 	list_for_each_entry(item, &bp->rx_fs_list.list, list)
 		gem_prog_cmp_regs(bp, &item->fs);
 
-	macb_set_rxflow_feature(bp, features);
+	macb_set_rxflow_feature(bp, &features);
 }
 
 static const struct net_device_ops macb_netdev_ops = {
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index a626fa1d13d4..6891fe90c16b 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1487,19 +1487,20 @@ static int xgmac_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static int xgmac_set_features(struct net_device *dev, netdev_features_t features)
+static int xgmac_set_features(struct net_device *dev,
+			      const netdev_features_t *features)
 {
 	u32 ctrl;
 	struct xgmac_priv *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->base;
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	ctrl = readl(ioaddr + XGMAC_CONTROL);
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		ctrl |= XGMAC_CONTROL_IPC;
 	else
 		ctrl &= ~XGMAC_CONTROL_IPC;
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index cb0cc8a5c268..7e4c749aa8b0 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2758,16 +2758,16 @@ static void liquidio_fix_features(struct net_device *netdev,
  * @features: features to enable/disable
  */
 static int liquidio_set_features(struct net_device *netdev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct lio *lio = netdev_priv(netdev);
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_LRO_BIT, *features) &&
 	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability) &&
 	    !netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	else if (!netdev_feature_test(NETIF_F_LRO_BIT, *features) &&
 		 netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability) &&
 		 netdev_active_feature_test(netdev, NETIF_F_LRO_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
@@ -2778,22 +2778,22 @@ static int liquidio_set_features(struct net_device *netdev,
 	 */
 	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
 	    netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
-	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		liquidio_set_rxcsum_command(netdev,
 					    OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
 	else if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
 		 netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
-		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) &&
 	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, lio->dev_capability) &&
 	    !netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
 				     OCTNET_CMD_VLAN_FILTER_ENABLE);
-	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) &&
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) &&
 		 netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, lio->dev_capability) &&
 		 netdev_active_feature_test(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT))
 		liquidio_set_feature(netdev, OCTNET_CMD_VLAN_FILTER_CTL,
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 8cf64202846b..cd0f6a7de629 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1850,31 +1850,31 @@ static void liquidio_fix_features(struct net_device *netdev,
  * @param features features to enable/disable
  */
 static int liquidio_set_features(struct net_device *netdev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct lio *lio = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_LRO_BIT, *features) &&
 	    netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_ENABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
-	else if (!netdev_feature_test(NETIF_F_LRO_BIT, features) &&
+	else if (!netdev_feature_test(NETIF_F_LRO_BIT, *features) &&
 		 netdev_feature_test(NETIF_F_LRO_BIT, lio->dev_capability))
 		liquidio_set_feature(netdev, OCTNET_CMD_LRO_DISABLE,
 				     OCTNIC_LROIPV4 | OCTNIC_LROIPV6);
 	if (!netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
 	    netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->dev_capability) &&
-	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_ENABLE);
 	else if (netdev_active_feature_test(netdev, NETIF_F_RXCSUM_BIT) &&
 		 netdev_feature_test(NETIF_F_RXCSUM_BIT, lio->enc_dev_capability) &&
-		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		 !netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		liquidio_set_rxcsum_command(netdev, OCTNET_CMD_TNL_RX_CSUM_CTL,
 					    OCTNET_CMD_RXCSUM_DISABLE);
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index 994608dde650..78ec909c5a0b 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1762,13 +1762,13 @@ static void nicvf_reset_task(struct work_struct *work)
 }
 
 static int nicvf_config_loopback(struct nicvf *nic,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	union nic_mbx mbx = {};
 
 	mbx.lbk.msg = NIC_MBOX_MSG_LOOPBACK;
 	mbx.lbk.vf_id = nic->vf_id;
-	mbx.lbk.enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
+	mbx.lbk.enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features);
 
 	return nicvf_send_msg_to_pf(nic, &mbx);
 }
@@ -1784,12 +1784,12 @@ static void nicvf_fix_features(struct net_device *netdev,
 }
 
 static int nicvf_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		nicvf_config_vlan_stripping(nic, features);
 
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
index c9080dbccca1..5d07fb88060d 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.c
@@ -707,7 +707,8 @@ static void nicvf_reclaim_rbdr(struct nicvf *nic,
 		return;
 }
 
-void nicvf_config_vlan_stripping(struct nicvf *nic, netdev_features_t features)
+void nicvf_config_vlan_stripping(struct nicvf *nic,
+				 const netdev_features_t *features)
 {
 	u64 rq_cfg;
 	int sqs;
@@ -715,7 +716,7 @@ void nicvf_config_vlan_stripping(struct nicvf *nic, netdev_features_t features)
 	rq_cfg = nicvf_queue_reg_read(nic, NIC_QSET_RQ_GEN_CFG, 0);
 
 	/* Enable first VLAN stripping */
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		rq_cfg |= (1ULL << 25);
 	else
 		rq_cfg &= ~(1ULL << 25);
@@ -804,7 +805,7 @@ static void nicvf_rcv_queue_config(struct nicvf *nic, struct queue_set *qs,
 		 */
 		nicvf_queue_reg_write(nic, NIC_QSET_RQ_GEN_CFG, 0,
 				      (BIT(24) | BIT(23) | BIT(21) | BIT(20)));
-		nicvf_config_vlan_stripping(nic, nic->netdev->features);
+		nicvf_config_vlan_stripping(nic, &nic->netdev->features);
 	}
 
 	/* Enable Receive queue */
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
index 8453defc296c..fa578d477d24 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_queues.h
@@ -328,7 +328,7 @@ static inline u64 nicvf_iova_to_phys(struct nicvf *nic, dma_addr_t dma_addr)
 void nicvf_unmap_sndq_buffers(struct nicvf *nic, struct snd_queue *sq,
 			      int hdr_sqe, u8 subdesc_cnt);
 void nicvf_config_vlan_stripping(struct nicvf *nic,
-				 netdev_features_t features);
+				 const netdev_features_t *features);
 int nicvf_set_qset_resources(struct nicvf *nic);
 int nicvf_config_data_transfer(struct nicvf *nic, bool enable);
 void nicvf_qset_config(struct nicvf *nic, bool enable);
diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 23dcdc7bde05..c84969e6e343 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -260,7 +260,7 @@ static int cxgb_open(struct net_device *dev)
 		schedule_mac_stats_update(adapter,
 					  adapter->params.stats_update_period);
 
-	t1_vlan_mode(adapter, dev->features);
+	t1_vlan_mode(adapter, &dev->features);
 	return 0;
 }
 
@@ -875,12 +875,13 @@ static void t1_fix_features(struct net_device *dev, netdev_features_t *features)
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
-static int t1_set_features(struct net_device *dev, netdev_features_t features)
+static int t1_set_features(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct adapter *adapter = dev->ml_priv;
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t1_vlan_mode(adapter, features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 0e1afce8d3a5..7b10266d9005 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -724,11 +724,11 @@ static inline void setup_ring_params(struct adapter *adapter, u64 addr,
 /*
  * Enable/disable VLAN acceleration.
  */
-void t1_vlan_mode(struct adapter *adapter, netdev_features_t features)
+void t1_vlan_mode(struct adapter *adapter, const netdev_features_t *features)
 {
 	struct sge *sge = adapter->sge;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		sge->sge_control |= F_VLAN_XTRACT;
 	else
 		sge->sge_control &= ~F_VLAN_XTRACT;
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.h b/drivers/net/ethernet/chelsio/cxgb/sge.h
index f7e6f64040ea..c34b69636aba 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.h
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.h
@@ -70,7 +70,7 @@ irqreturn_t t1_interrupt(int irq, void *cookie);
 int t1_poll(struct napi_struct *, int);
 
 netdev_tx_t t1_start_xmit(struct sk_buff *skb, struct net_device *dev);
-void t1_vlan_mode(struct adapter *adapter, netdev_features_t features);
+void t1_vlan_mode(struct adapter *adapter, const netdev_features_t *features);
 void t1_sge_start(struct sge *);
 void t1_sge_stop(struct sge *);
 bool t1_sge_intr_error_handler(struct sge *sge);
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 56bba53a8dd6..92e8a8855a47 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -1177,18 +1177,19 @@ static void t3_synchronize_rx(struct adapter *adap, const struct port_info *p)
 	}
 }
 
-static void cxgb_vlan_mode(struct net_device *dev, netdev_features_t features)
+static void cxgb_vlan_mode(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 
 	if (adapter->params.rev > 0) {
 		t3_set_vlan_accel(adapter, 1 << pi->port_id,
-				  netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features));
+				  netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features));
 	} else {
 		/* single control for all ports */
 		unsigned int i, have_vlans = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-								 features);
+								 *features);
 
 		for_each_port(adapter, i)
 			have_vlans |= netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
@@ -1249,7 +1250,7 @@ static int cxgb_up(struct adapter *adap)
 			goto out;
 
 		for_each_port(adap, i)
-			cxgb_vlan_mode(adap->port[i], adap->port[i]->features);
+			cxgb_vlan_mode(adap->port[i], &adap->port[i]->features);
 
 		setup_rss(adap);
 		if (!(adap->flags & NAPI_INIT))
@@ -2601,11 +2602,12 @@ static void cxgb_fix_features(struct net_device *dev,
 		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
 }
 
-static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
+static int cxgb_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		cxgb_vlan_mode(dev, features);
 
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index c96b11d6c5d8..8d578c120641 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -1272,22 +1272,23 @@ int cxgb4_set_rspq_intr_params(struct sge_rspq *q,
 	return 0;
 }
 
-static int cxgb_set_features(struct net_device *dev, netdev_features_t features)
+static int cxgb_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	const struct port_info *pi = netdev_priv(dev);
 	netdev_features_t changed;
 	int err;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
 	err = t4_set_rxmode(pi->adapter, pi->adapter->mbox, pi->viid,
 			    pi->viid_mirror, -1, -1, -1, -1,
-			    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features),
+			    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features),
 			    true);
 	if (unlikely(err)) {
-		dev->features = features;
+		netdev_active_features_copy(dev, *features);
 		netdev_active_feature_change(dev, NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 	return err;
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 7941946e512d..a2e8135490d2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -1188,15 +1188,15 @@ static void cxgb4vf_fix_features(struct net_device *dev,
 }
 
 static int cxgb4vf_set_features(struct net_device *dev,
-	netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct port_info *pi = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		t4vf_set_rxmode(pi->adapter, pi->viid, -1, -1, -1, -1,
-				netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features),
+				netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features),
 				0);
 
 	return 0;
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 4da024437808..f66ef5bf8d94 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1986,10 +1986,10 @@ static void gmac_fix_features(struct net_device *netdev,
 }
 
 static int gmac_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
-	int enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+	int enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
 	unsigned long flags;
 	u32 reg;
 
diff --git a/drivers/net/ethernet/davicom/dm9000.c b/drivers/net/ethernet/davicom/dm9000.c
index 650c37096cfe..9cd2c6e10995 100644
--- a/drivers/net/ethernet/davicom/dm9000.c
+++ b/drivers/net/ethernet/davicom/dm9000.c
@@ -584,19 +584,19 @@ static int dm9000_nway_reset(struct net_device *dev)
 }
 
 static int dm9000_set_features(struct net_device *dev,
-	netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct board_info *dm = to_dm9000_board(dev);
 	netdev_features_t changed;
 	unsigned long flags;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&dm->lock, flags);
 	iow(dm, DM9000_RCSR,
-	    netdev_feature_test(NETIF_F_RXCSUM_BIT, features) ? RCSR_CSUM : 0);
+	    netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) ? RCSR_CSUM : 0);
 	spin_unlock_irqrestore(&dm->lock, flags);
 
 	return 0;
diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
index 1792c85ca043..5a86b671ba3d 100644
--- a/drivers/net/ethernet/engleder/tsnep_main.c
+++ b/drivers/net/ethernet/engleder/tsnep_main.c
@@ -1053,16 +1053,16 @@ static int tsnep_netdev_set_mac_address(struct net_device *netdev, void *addr)
 }
 
 static int tsnep_netdev_set_features(struct net_device *netdev,
-				     netdev_features_t features)
+				     const netdev_features_t *features)
 {
 	struct tsnep_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 	bool enable;
 	int retval = 0;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed)) {
-		enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, features);
+		enable = netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features);
 		retval = tsnep_phy_loopback(adapter, enable);
 	}
 
diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
index 1b6fcc214160..b3c2eb85ad64 100644
--- a/drivers/net/ethernet/faraday/ftgmac100.c
+++ b/drivers/net/ethernet/faraday/ftgmac100.c
@@ -1594,7 +1594,7 @@ static void ftgmac100_tx_timeout(struct net_device *netdev, unsigned int txqueue
 }
 
 static int ftgmac100_set_features(struct net_device *netdev,
-				  netdev_features_t features)
+				  const netdev_features_t *features)
 {
 	struct ftgmac100 *priv = netdev_priv(netdev);
 	netdev_features_t changed;
@@ -1602,7 +1602,7 @@ static int ftgmac100_set_features(struct net_device *netdev,
 	if (!netif_running(netdev))
 		return 0;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	/* Update the vlan filtering bit */
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		u32 maccr;
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 45723c5356cb..fdd0bda2c461 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2419,30 +2419,30 @@ static void dpaa2_eth_set_rx_mode(struct net_device *net_dev)
 }
 
 static int dpaa2_eth_set_features(struct net_device *net_dev,
-				  netdev_features_t features)
+				  const netdev_features_t *features)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	netdev_features_t changed;
 	bool enable;
 	int err;
 
-	netdev_features_xor(changed, net_dev->features, features);
+	netdev_features_xor(changed, net_dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
-		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features);
+		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features);
 		err = dpaa2_eth_set_rx_vlan_filtering(priv, enable);
 		if (err)
 			return err;
 	}
 
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
-		enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+		enable = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
 		err = dpaa2_eth_set_rx_csum(priv, enable);
 		if (err)
 			return err;
 	}
 
 	if (netdev_features_intersects(changed, netdev_ip_csum_features)) {
-		enable = netdev_features_intersects(features,
+		enable = netdev_features_intersects(*features,
 						    netdev_ip_csum_features);
 		err = dpaa2_eth_set_tx_csum(priv, enable);
 		if (err)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index f0edb74e509d..836ff64b9b8c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -2642,27 +2642,27 @@ static void enetc_enable_txvlan(struct net_device *ndev, bool en)
 }
 
 int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features)
+		       const netdev_features_t *features)
 {
 	netdev_features_t changed;
 	int err = 0;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
 		enetc_set_rss(ndev,
-			      netdev_feature_test(NETIF_F_RXHASH_BIT, features));
+			      netdev_feature_test(NETIF_F_RXHASH_BIT, *features));
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		enetc_enable_rxvlan(ndev,
-				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features));
+				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features));
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed))
 		enetc_enable_txvlan(ndev,
-				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features));
+				    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features));
 
 	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed))
 		err = enetc_set_psfp(ndev,
-				     netdev_feature_test(NETIF_F_HW_TC_BIT, features));
+				     netdev_feature_test(NETIF_F_HW_TC_BIT, *features));
 
 	return err;
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 29922c20531f..a690eb623be7 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -394,7 +394,7 @@ void enetc_stop(struct net_device *ndev);
 netdev_tx_t enetc_xmit(struct sk_buff *skb, struct net_device *ndev);
 struct net_device_stats *enetc_get_stats(struct net_device *ndev);
 int enetc_set_features(struct net_device *ndev,
-		       netdev_features_t features);
+		       const netdev_features_t *features);
 int enetc_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd);
 int enetc_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 		   void *type_data);
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index c181e3db7962..5f5479253e5b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -706,16 +706,16 @@ static int enetc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 #endif
 
 static int enetc_pf_set_features(struct net_device *ndev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct enetc_ndev_priv *priv = netdev_priv(ndev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
 		struct enetc_pf *pf = enetc_si_priv(priv->si);
 
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features))
 			enetc_disable_si_vlan_promisc(pf, 0);
 		else
 			enetc_enable_si_vlan_promisc(pf, 0);
@@ -723,7 +723,7 @@ static int enetc_pf_set_features(struct net_device *ndev,
 
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed))
 		enetc_set_loopback(ndev,
-				   netdev_feature_test(NETIF_F_LOOPBACK_BIT, features));
+				   netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features));
 
 	return enetc_set_features(ndev, features);
 }
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 461f296b83fb..74b5af9c9eb5 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -87,7 +87,7 @@ static int enetc_vf_set_mac_addr(struct net_device *ndev, void *addr)
 }
 
 static int enetc_vf_set_features(struct net_device *ndev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	return enetc_set_features(ndev, features);
 }
diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index cdffbf75e9ca..90094816a6c8 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3447,17 +3447,17 @@ static void fec_poll_controller(struct net_device *dev)
 #endif
 
 static inline void fec_enet_set_netdev_features(struct net_device *netdev,
-	netdev_features_t features)
+						const netdev_features_t *features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
-	netdev->features = features;
+	netdev_features_xor(changed, netdev->features, *features);
+	netdev_active_features_copy(netdev, *features);
 
 	/* Receive checksum has been changed */
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 			fep->csum_flags |= FLAG_RX_CSUM_ENABLED;
 		else
 			fep->csum_flags &= ~FLAG_RX_CSUM_ENABLED;
@@ -3465,12 +3465,12 @@ static inline void fec_enet_set_netdev_features(struct net_device *netdev,
 }
 
 static int fec_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct fec_enet_private *fep = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netif_running(netdev) && netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		napi_disable(&fep->napi);
 		netif_tx_lock_bh(netdev);
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 68b59d3202e3..24c11f85857c 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -1341,7 +1341,7 @@ static inline u32 gfar_rxbd_dma_lastfree(struct gfar_priv_rx_q *rxq)
 int startup_gfar(struct net_device *dev);
 void stop_gfar(struct net_device *dev);
 void gfar_mac_reset(struct gfar_private *priv);
-int gfar_set_features(struct net_device *dev, netdev_features_t features);
+int gfar_set_features(struct net_device *dev, const netdev_features_t *features);
 
 extern const struct ethtool_ops gfar_ethtool_ops;
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 0c2d97e1154a..dc894803d8cc 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -506,13 +506,13 @@ static int gfar_spauseparam(struct net_device *dev,
 	return 0;
 }
 
-int gfar_set_features(struct net_device *dev, netdev_features_t features)
+int gfar_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct gfar_private *priv = netdev_priv(dev);
 	netdev_features_t changed;
 	int err = 0;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_features_intersects(changed, netdev_ctag_vlan_offload_features) &&
 	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
@@ -520,7 +520,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	while (test_and_set_bit_lock(GFAR_RESETTING, &priv->state))
 		cpu_relax();
 
-	dev->features = features;
+	netdev_active_features_copy(dev, *features);
 
 	if (dev->flags & IFF_UP) {
 		/* Now we take down the rings to rebuild them */
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index d86b6004580a..31d749796b49 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -1179,14 +1179,14 @@ static void gve_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 
 static int gve_set_features(struct net_device *netdev,
-			    netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	const netdev_features_t orig_features = netdev->features;
 	struct gve_priv *priv = netdev_priv(netdev);
 	int err;
 
 	if (netdev_active_feature_test(netdev, NETIF_F_LRO_BIT) !=
-	    netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	    netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		netdev_active_feature_change(netdev, NETIF_F_LRO_BIT);
 		if (netif_carrier_ok(netdev)) {
 			/* To make this process as simple as possible we
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index c29f2eab3d5f..271bc134581a 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1767,17 +1767,17 @@ static int hns_nic_change_mtu(struct net_device *ndev, int new_mtu)
 }
 
 static int hns_nic_set_features(struct net_device *netdev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct hns_nic_priv *priv = netdev_priv(netdev);
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		if (netdev_features_intersects(features, netdev_general_tso_features))
+		if (netdev_features_intersects(*features, netdev_general_tso_features))
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (netdev_features_intersects(features, netdev_general_tso_features)) {
+		if (netdev_features_intersects(*features, netdev_general_tso_features)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
@@ -1788,7 +1788,7 @@ static int hns_nic_set_features(struct net_device *netdev,
 		}
 		break;
 	}
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 06c79b7cbb23..326ee0c13b65 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2404,7 +2404,7 @@ static int hns3_nic_do_ioctl(struct net_device *netdev,
 }
 
 static int hns3_nic_set_features(struct net_device *netdev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	struct hnae3_handle *h = priv->ae_handle;
@@ -2412,10 +2412,10 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	bool enable;
 	int ret;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changed) &&
 	    h->ae_algo->ops->set_gro_en) {
-		enable = netdev_feature_test(NETIF_F_GRO_HW_BIT, features);
+		enable = netdev_feature_test(NETIF_F_GRO_HW_BIT, *features);
 		ret = h->ae_algo->ops->set_gro_en(h, enable);
 		if (ret)
 			return ret;
@@ -2424,7 +2424,7 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    h->ae_algo->ops->enable_hw_strip_rxvtag) {
 		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-					     features);
+					     *features);
 		ret = h->ae_algo->ops->enable_hw_strip_rxvtag(h, enable);
 		if (ret)
 			return ret;
@@ -2432,12 +2432,12 @@ static int hns3_nic_set_features(struct net_device *netdev,
 
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) &&
 	    h->ae_algo->ops->enable_fd) {
-		enable = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
+		enable = netdev_feature_test(NETIF_F_NTUPLE_BIT, *features);
 		h->ae_algo->ops->enable_fd(h, enable);
 	}
 
 	if (netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
-	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, *features) &&
 	    h->ae_algo->ops->cls_flower_active(h)) {
 		netdev_err(netdev,
 			   "there are offloaded TC filters active, cannot disable HW TC offload");
@@ -2447,13 +2447,13 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed) &&
 	    h->ae_algo->ops->enable_vlan_filter) {
 		enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
-					     features);
+					     *features);
 		ret = h->ae_algo->ops->enable_vlan_filter(h, enable);
 		if (ret)
 			return ret;
 	}
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 035b77c95cf0..ecb3d345ff2e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -78,8 +78,8 @@ MODULE_PARM_DESC(rx_weight, "Number Rx packets for NAPI budget (default=64)");
 static int change_mac_addr(struct net_device *netdev, const u8 *addr);
 
 static int set_features(struct hinic_dev *nic_dev,
-			netdev_features_t pre_features,
-			netdev_features_t features, bool force_change);
+			const netdev_features_t *pre_features,
+			const netdev_features_t *features, bool force_change);
 
 static void gather_rx_stats(struct hinic_rxq_stats *nic_rx_stats, struct hinic_rxq *rxq)
 {
@@ -856,11 +856,11 @@ static void hinic_get_stats64(struct net_device *netdev,
 }
 
 static int hinic_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 
-	return set_features(nic_dev, nic_dev->netdev->features,
+	return set_features(nic_dev, &nic_dev->netdev->features,
 			    features, false);
 }
 
@@ -1056,8 +1056,8 @@ static void link_err_event(void *handle,
 }
 
 static int set_features(struct hinic_dev *nic_dev,
-			netdev_features_t pre_features,
-			netdev_features_t features, bool force_change)
+			const netdev_features_t *pre_features,
+			const netdev_features_t *features, bool force_change)
 {
 	u32 csum_en = HINIC_RX_CSUM_OFFLOAD_EN;
 	netdev_features_t failed_features;
@@ -1068,12 +1068,12 @@ static int set_features(struct hinic_dev *nic_dev,
 	if (force_change)
 		netdev_features_fill(changed);
 	else
-		netdev_features_xor(changed, pre_features, features);
+		netdev_features_xor(changed, *pre_features, *features);
 
 	netdev_features_zero(failed_features);
 	if (netdev_feature_test(NETIF_F_TSO_BIT, changed)) {
 		ret = hinic_port_set_tso(nic_dev,
-					 netdev_feature_test(NETIF_F_TSO_BIT, features) ?
+					 netdev_feature_test(NETIF_F_TSO_BIT, *features) ?
 					 HINIC_TSO_ENABLE : HINIC_TSO_DISABLE);
 		if (ret) {
 			err = ret;
@@ -1092,7 +1092,7 @@ static int set_features(struct hinic_dev *nic_dev,
 
 	if (netdev_feature_test(NETIF_F_LRO_BIT, changed)) {
 		ret = hinic_set_rx_lro_state(nic_dev,
-					     netdev_feature_test(NETIF_F_LRO_BIT, features),
+					     netdev_feature_test(NETIF_F_LRO_BIT, *features),
 					     HINIC_LRO_RX_TIMER_DEFAULT,
 					     HINIC_LRO_MAX_WQE_NUM_DEFAULT);
 		if (ret) {
@@ -1104,7 +1104,7 @@ static int set_features(struct hinic_dev *nic_dev,
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		ret = hinic_set_rx_vlan_offload(nic_dev,
 						netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-								    features));
+								    *features));
 		if (ret) {
 			err = ret;
 			netdev_feature_add(NETIF_F_HW_VLAN_CTAG_RX_BIT,
@@ -1113,7 +1113,7 @@ static int set_features(struct hinic_dev *nic_dev,
 	}
 
 	if (err) {
-		netdev_active_features_xor(nic_dev->netdev, features,
+		netdev_active_features_xor(nic_dev->netdev, *features,
 					   failed_features);
 		return -EIO;
 	}
@@ -1294,8 +1294,8 @@ static int nic_dev_init(struct pci_dev *pdev)
 				nic_dev, link_err_event);
 
 	netdev_features_zero(feats);
-	err = set_features(nic_dev, feats,
-			   nic_dev->netdev->features, true);
+	err = set_features(nic_dev, &feats,
+			   &nic_dev->netdev->features, true);
 	if (err)
 		goto err_set_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 3658783641c7..01ff163aa261 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -898,18 +898,18 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 }
 
 static int ibmveth_set_features(struct net_device *dev,
-	netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct ibmveth_adapter *adapter = netdev_priv(dev);
-	int rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
-	int large_send = netdev_features_intersects(features,
+	int rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
+	int large_send = netdev_features_intersects(*features,
 						    netdev_general_tso_features);
 	int rc1 = 0, rc2 = 0;
 
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
 		if (rc1 && !adapter->rx_csum) {
-			netdev_active_features_andnot(dev, features,
+			netdev_active_features_andnot(dev, *features,
 						      NETIF_F_CSUM_MASK);
 			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 		}
@@ -918,7 +918,7 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
 		if (rc2 && !adapter->large_send)
-			netdev_active_features_andnot(dev, features,
+			netdev_active_features_andnot(dev, *features,
 						      netdev_general_tso_features);
 	}
 
@@ -1734,7 +1734,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	netdev_dbg(netdev, "adapter @ 0x%p\n", adapter);
 	netdev_dbg(netdev, "registering netdev...\n");
 
-	ibmveth_set_features(netdev, netdev->features);
+	ibmveth_set_features(netdev, &netdev->features);
 
 	rc = register_netdev(netdev);
 
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 636c386d6761..e1f01fae54f3 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2801,17 +2801,17 @@ static int e100_close(struct net_device *netdev)
 }
 
 static int e100_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct nic *nic = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (!(netdev_feature_test(NETIF_F_RXFCS_BIT, changed) &&
 	      netdev_feature_test(NETIF_F_RXALL_BIT, changed)))
 		return 0;
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 	e100_exec_cb(nic, NULL, e100_configure);
 	return 1;
 }
diff --git a/drivers/net/ethernet/intel/e1000/e1000_main.c b/drivers/net/ethernet/intel/e1000/e1000_main.c
index a689aba72050..0f06f320e579 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_main.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_main.c
@@ -140,7 +140,7 @@ static int e1000_82547_fifo_workaround(struct e1000_adapter *adapter,
 
 static bool e1000_vlan_used(struct e1000_adapter *adapter);
 static void e1000_vlan_mode(struct net_device *netdev,
-			    netdev_features_t features);
+			    const netdev_features_t *features);
 static void e1000_vlan_filter_on_off(struct e1000_adapter *adapter,
 				     bool filter_on);
 static int e1000_vlan_rx_add_vid(struct net_device *netdev,
@@ -800,12 +800,12 @@ static void e1000_fix_features(struct net_device *netdev,
 }
 
 static int e1000_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		e1000_vlan_mode(netdev, features);
 
@@ -813,8 +813,8 @@ static int e1000_set_features(struct net_device *netdev,
 	      netdev_feature_test(NETIF_F_RXALL_BIT, changed)))
 		return 0;
 
-	netdev->features = features;
-	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+	netdev_active_features_copy(netdev, *features);
+	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
 
 	if (netif_running(netdev))
 		e1000_reinit_locked(adapter);
@@ -4893,13 +4893,13 @@ static bool e1000_vlan_used(struct e1000_adapter *adapter)
 }
 
 static void __e1000_vlan_mode(struct e1000_adapter *adapter,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl;
 
 	ctrl = er32(CTRL);
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		/* enable VLAN tag insert/strip */
 		ctrl |= E1000_CTRL_VME;
 	} else {
@@ -4917,7 +4917,7 @@ static void e1000_vlan_filter_on_off(struct e1000_adapter *adapter,
 	if (!test_bit(__E1000_DOWN, &adapter->flags))
 		e1000_irq_disable(adapter);
 
-	__e1000_vlan_mode(adapter, adapter->netdev->features);
+	__e1000_vlan_mode(adapter, &adapter->netdev->features);
 	if (filter_on) {
 		/* enable VLAN receive filtering */
 		rctl = er32(RCTL);
@@ -4938,7 +4938,7 @@ static void e1000_vlan_filter_on_off(struct e1000_adapter *adapter,
 }
 
 static void e1000_vlan_mode(struct net_device *netdev,
-			    netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index d5b022b309aa..95fe8df96d5a 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7311,13 +7311,13 @@ static void e1000_fix_features(struct net_device *netdev,
 }
 
 static int e1000_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changeable;
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_features_intersects(changed, netdev_general_tso_features))
 		adapter->flags |= FLAG_TSO_FORCE;
 
@@ -7330,7 +7330,7 @@ static int e1000_set_features(struct net_device *netdev,
 		return 0;
 
 	if (netdev_feature_test(NETIF_F_RXFCS_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, *features)) {
 			adapter->flags2 &= ~FLAG2_CRC_STRIPPING;
 		} else {
 			/* We need to take it back to defaults, which might mean
@@ -7343,7 +7343,7 @@ static int e1000_set_features(struct net_device *netdev,
 		}
 	}
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 
 	if (netif_running(netdev))
 		e1000e_reinit_locked(adapter);
diff --git a/drivers/net/ethernet/intel/i40e/i40e.h b/drivers/net/ethernet/intel/i40e/i40e.h
index 9a60d6b207f7..f8b25a4d9339 100644
--- a/drivers/net/ethernet/intel/i40e/i40e.h
+++ b/drivers/net/ethernet/intel/i40e/i40e.h
@@ -1167,7 +1167,7 @@ u32 i40e_get_current_fd_count(struct i40e_pf *pf);
 u32 i40e_get_cur_guaranteed_fd_count(struct i40e_pf *pf);
 u32 i40e_get_current_atr_cnt(struct i40e_pf *pf);
 u32 i40e_get_global_fd_count(struct i40e_pf *pf);
-bool i40e_set_ntuple(struct i40e_pf *pf, netdev_features_t features);
+bool i40e_set_ntuple(struct i40e_pf *pf, const netdev_features_t *features);
 void i40e_set_ethtool_ops(struct net_device *netdev);
 struct i40e_mac_filter *i40e_add_filter(struct i40e_vsi *vsi,
 					const u8 *macaddr, s16 vlan);
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 3bf454f234a4..86e63041f2cc 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -12846,14 +12846,14 @@ static int i40e_sw_init(struct i40e_pf *pf)
  *
  * returns a bool to indicate if reset needs to happen
  **/
-bool i40e_set_ntuple(struct i40e_pf *pf, netdev_features_t features)
+bool i40e_set_ntuple(struct i40e_pf *pf, const netdev_features_t *features)
 {
 	bool need_reset = false;
 
 	/* Check if Flow Director n-tuple support was enabled or disabled.  If
 	 * the state changed, we need to reset.
 	 */
-	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *features)) {
 		/* Enable filters and mark for reset */
 		if (!(pf->flags & I40E_FLAG_FD_SB_ENABLED))
 			need_reset = true;
@@ -12915,26 +12915,26 @@ static void i40e_clear_rss_lut(struct i40e_vsi *vsi)
  * Note: expects to be called while under rtnl_lock()
  **/
 static int i40e_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_vsi *vsi = np->vsi;
 	struct i40e_pf *pf = vsi->back;
 	bool need_reset;
 
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features) &&
 	    !netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		i40e_pf_config_rss(pf);
-	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) &&
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, *features) &&
 		 netdev_active_feature_test(netdev, NETIF_F_RXHASH_BIT))
 		i40e_clear_rss_lut(vsi);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		i40e_vlan_stripping_enable(vsi);
 	else
 		i40e_vlan_stripping_disable(vsi);
 
-	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
+	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, *features) &&
 	    netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
 	    pf->num_cloud_filters) {
 		dev_err(&pf->pdev->dev,
@@ -12942,7 +12942,7 @@ static int i40e_set_features(struct net_device *netdev,
 		return -EINVAL;
 	}
 
-	if (!netdev_feature_test(NETIF_F_HW_L2FW_DOFFLOAD_BIT, features) &&
+	if (!netdev_feature_test(NETIF_F_HW_L2FW_DOFFLOAD_BIT, *features) &&
 	    vsi->macvlan_cnt)
 		i40e_del_all_macvlans(vsi);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/intel/iavf/iavf.h
index 5f19135f50d2..c9b9a2141771 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -581,8 +581,8 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
 			     const u8 *new_mac);
 void
 iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
-			       netdev_features_t prev_features,
-			       netdev_features_t features);
+			       const netdev_features_t *prev_features,
+			       const netdev_features_t *features);
 void iavf_add_fdir_filter(struct iavf_adapter *adapter);
 void iavf_del_fdir_filter(struct iavf_adapter *adapter);
 void iavf_add_adv_rss_cfg(struct iavf_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index bc9b963a3bd9..456bb30ce086 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2189,8 +2189,8 @@ static int iavf_process_aq_command(struct iavf_adapter *adapter)
  **/
 void
 iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
-			       netdev_features_t prev_features,
-			       netdev_features_t features)
+			       const netdev_features_t *prev_features,
+			       const netdev_features_t *features)
 {
 	bool enable_stripping = true, enable_insertion = true;
 	u16 vlan_ethertype = 0;
@@ -2202,20 +2202,20 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 	 * ETH_P_8021Q so an ethertype is specified if disabling insertion and
 	 * stripping.
 	 */
-	if (netdev_features_intersects(features, netdev_stag_vlan_offload_features))
+	if (netdev_features_intersects(*features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
+	else if (netdev_features_intersects(*features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
-	else if (netdev_features_intersects(prev_features, netdev_stag_vlan_offload_features))
+	else if (netdev_features_intersects(*prev_features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (netdev_features_intersects(prev_features, netdev_ctag_vlan_offload_features))
+	else if (netdev_features_intersects(*prev_features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
 	else
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!netdev_features_intersects(features, netdev_rx_vlan_features))
+	if (!netdev_features_intersects(*features, netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!netdev_features_intersects(features, netdev_tx_vlan_features))
+	if (!netdev_features_intersects(*features, netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (VLAN_ALLOWED(adapter)) {
@@ -2675,8 +2675,8 @@ static void iavf_init_config_adapter(struct iavf_adapter *adapter)
 
 		netdev_features_zero(feats);
 		/* request initial VLAN offload settings */
-		iavf_set_vlan_offload_features(adapter, feats,
-					       netdev->features);
+		iavf_set_vlan_offload_features(adapter, &feats,
+					       &netdev->features);
 	}
 
 	return;
@@ -3246,7 +3246,7 @@ static void iavf_adminq_task(struct work_struct *work)
 			/* Request VLAN offload settings */
 			if (VLAN_V2_ALLOWED(adapter))
 				iavf_set_vlan_offload_features
-					(adapter, feats, netdev->features);
+					(adapter, &feats, &netdev->features);
 
 			iavf_set_queue_vlan_tag_loc(adapter);
 		}
@@ -4367,14 +4367,14 @@ static int iavf_change_mtu(struct net_device *netdev, int new_mtu)
  * Note: expects to be called while under rtnl_lock()
  **/
 static int iavf_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	/* trigger update on any VLAN feature change */
 	if (netdev_active_features_intersects(netdev, NETIF_VLAN_OFFLOAD_FEATURES) ^
-	    netdev_features_intersects(features, NETIF_VLAN_OFFLOAD_FEATURES))
-		iavf_set_vlan_offload_features(adapter, netdev->features,
+	    netdev_features_intersects(*features, NETIF_VLAN_OFFLOAD_FEATURES))
+		iavf_set_vlan_offload_features(adapter, &netdev->features,
 					       features);
 
 	return 0;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cce947660cfd..d4f77da1ddd7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5890,7 +5890,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t *features)
  * disabled. Finally enable or disable VLAN stripping and insertion.
  */
 static int
-ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
+ice_set_vlan_offload_features(struct ice_vsi *vsi,
+			      const netdev_features_t *features)
 {
 	bool enable_stripping = true, enable_insertion = true;
 	struct ice_vsi_vlan_ops *vlan_ops;
@@ -5899,14 +5900,14 @@ ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
-	if (netdev_features_intersects(features, netdev_stag_vlan_offload_features))
+	if (netdev_features_intersects(*features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
+	else if (netdev_features_intersects(*features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!netdev_features_intersects(features, netdev_rx_vlan_features))
+	if (!netdev_features_intersects(*features, netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!netdev_features_intersects(features, netdev_tx_vlan_features))
+	if (!netdev_features_intersects(*features, netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (enable_stripping)
@@ -5934,7 +5935,8 @@ ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
  * features.
  */
 static int
-ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
+ice_set_vlan_filtering_features(struct ice_vsi *vsi,
+				const netdev_features_t *features)
 {
 	struct ice_vsi_vlan_ops *vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 	int err = 0;
@@ -5942,7 +5944,7 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
 	/* support Single VLAN Mode (SVM) and Double VLAN Mode (DVM) by checking
 	 * if either bit is set
 	 */
-	if (netdev_features_intersects(features, netdev_vlan_filter_features))
+	if (netdev_features_intersects(*features, netdev_vlan_filter_features))
 		err = vlan_ops->ena_rx_filtering(vsi);
 	else
 		err = vlan_ops->dis_rx_filtering(vsi);
@@ -5959,7 +5961,8 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
  * the current_vlan_features.
  */
 static int
-ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
+ice_set_vlan_features(struct net_device *netdev,
+		      const netdev_features_t *features)
 {
 	netdev_features_t current_vlan_features, requested_vlan_features, diff;
 	struct ice_netdev_priv *np = netdev_priv(netdev);
@@ -5968,13 +5971,13 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 
 	netdev_features_and(current_vlan_features, netdev->features,
 			    NETIF_VLAN_OFFLOAD_FEATURES);
-	netdev_features_and(requested_vlan_features, features,
+	netdev_features_and(requested_vlan_features, *features,
 			    NETIF_VLAN_OFFLOAD_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
 	if (!netdev_features_empty(diff)) {
-		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
-		    netdev_features_intersects(features,
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, *features) &&
+		    netdev_features_intersects(*features,
 					       NETIF_VLAN_STRIPPING_FEATURES)) {
 			dev_err(ice_pf_to_dev(vsi->back),
 				"To enable VLAN stripping, you must first enable FCS/CRC stripping\n");
@@ -5988,7 +5991,7 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 
 	netdev_features_and(current_vlan_features, netdev->features,
 			    NETIF_VLAN_FILTERING_FEATURES);
-	netdev_features_and(requested_vlan_features, features,
+	netdev_features_and(requested_vlan_features, *features,
 			    NETIF_VLAN_FILTERING_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
@@ -6033,7 +6036,7 @@ static int ice_set_loopback(struct ice_vsi *vsi, bool ena)
  * @features: the feature set that the stack is suggesting
  */
 static int
-ice_set_features(struct net_device *netdev, netdev_features_t features)
+ice_set_features(struct net_device *netdev, const netdev_features_t *features)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -6055,14 +6058,14 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 		return -EBUSY;
 	}
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 
 	/* Multiple features can be changed in one call so keep features in
 	 * separate if/else statements to guarantee each feature is checked
 	 */
 	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
 		ice_vsi_manage_rss_lut(vsi,
-				       netdev_feature_test(NETIF_F_RXHASH_BIT, features));
+				       netdev_feature_test(NETIF_F_RXHASH_BIT, *features));
 
 	ret = ice_set_vlan_features(netdev, features);
 	if (ret)
@@ -6072,35 +6075,35 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 	 * flag the packet data will have the 4 byte CRC appended
 	 */
 	if (netdev_feature_test(NETIF_F_RXFCS_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features) &&
-		    netdev_features_intersects(features, NETIF_VLAN_STRIPPING_FEATURES)) {
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, *features) &&
+		    netdev_features_intersects(*features, NETIF_VLAN_STRIPPING_FEATURES)) {
 			dev_err(ice_pf_to_dev(vsi->back),
 				"To disable FCS/CRC stripping, you must first disable VLAN stripping\n");
 			return -EIO;
 		}
 
 		ice_vsi_cfg_crc_strip(vsi,
-				      netdev_feature_test(NETIF_F_RXFCS_BIT, features));
+				      netdev_feature_test(NETIF_F_RXFCS_BIT, *features));
 		ret = ice_down_up(vsi);
 		if (ret)
 			return ret;
 	}
 
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed)) {
-		bool ena = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
+		bool ena = netdev_feature_test(NETIF_F_NTUPLE_BIT, *features);
 
 		ice_vsi_manage_fdir(vsi, ena);
 		ena ? ice_init_arfs(vsi) : ice_clear_arfs(vsi);
 	}
 
 	/* don't turn off hw_tc_offload when ADQ is already enabled */
-	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, features) && ice_is_adq_active(pf)) {
+	if (!netdev_feature_test(NETIF_F_HW_TC_BIT, *features) && ice_is_adq_active(pf)) {
 		dev_err(ice_pf_to_dev(pf), "ADQ is active, can't turn hw_tc_offload off\n");
 		return -EACCES;
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_TC_BIT, changed)) {
-		bool ena = netdev_feature_test(NETIF_F_HW_TC_BIT, features);
+		bool ena = netdev_feature_test(NETIF_F_HW_TC_BIT, *features);
 
 		ena ? set_bit(ICE_FLAG_CLS_FLOWER, pf->flags) :
 		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
@@ -6108,7 +6111,7 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
 
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed))
 		ret = ice_set_loopback(vsi,
-				       netdev_feature_test(NETIF_F_LOOPBACK_BIT, features));
+				       netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features));
 
 	return ret;
 }
@@ -6121,11 +6124,11 @@ static int ice_vsi_vlan_setup(struct ice_vsi *vsi)
 {
 	int err;
 
-	err = ice_set_vlan_offload_features(vsi, vsi->netdev->features);
+	err = ice_set_vlan_offload_features(vsi, &vsi->netdev->features);
 	if (err)
 		return err;
 
-	err = ice_set_vlan_filtering_features(vsi, vsi->netdev->features);
+	err = ice_set_vlan_filtering_features(vsi, &vsi->netdev->features);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index a93e52cf01b3..87c55e4c7649 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -145,7 +145,7 @@ static int igb_ioctl(struct net_device *, struct ifreq *, int cmd);
 static void igb_tx_timeout(struct net_device *, unsigned int txqueue);
 static void igb_reset_task(struct work_struct *);
 static void igb_vlan_mode(struct net_device *netdev,
-			  netdev_features_t features);
+			  const netdev_features_t *features);
 static int igb_vlan_rx_add_vid(struct net_device *, __be16, u16);
 static int igb_vlan_rx_kill_vid(struct net_device *, __be16, u16);
 static void igb_restore_vlan(struct igb_adapter *);
@@ -2445,12 +2445,12 @@ static void igb_fix_features(struct net_device *netdev,
 }
 
 static int igb_set_features(struct net_device *netdev,
-	netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igb_vlan_mode(netdev, features);
 
@@ -2458,7 +2458,7 @@ static int igb_set_features(struct net_device *netdev,
 	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, changed))
 		return 0;
 
-	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, *features)) {
 		struct hlist_node *node2;
 		struct igb_nfc_filter *rule;
 
@@ -2473,7 +2473,7 @@ static int igb_set_features(struct net_device *netdev,
 		adapter->nfc_filter_count = 0;
 	}
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 
 	if (netif_running(netdev))
 		igb_reinit_locked(adapter);
@@ -9161,12 +9161,13 @@ s32 igb_write_pcie_cap_reg(struct e1000_hw *hw, u32 reg, u16 *value)
 	return 0;
 }
 
-static void igb_vlan_mode(struct net_device *netdev, netdev_features_t features)
+static void igb_vlan_mode(struct net_device *netdev,
+			  const netdev_features_t *features)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 	struct e1000_hw *hw = &adapter->hw;
 	u32 ctrl, rctl;
-	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
+	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features);
 
 	if (enable) {
 		/* enable VLAN tag insert/strip */
@@ -9224,7 +9225,7 @@ static void igb_restore_vlan(struct igb_adapter *adapter)
 {
 	u16 vid = 1;
 
-	igb_vlan_mode(adapter->netdev, adapter->netdev->features);
+	igb_vlan_mode(adapter->netdev, &adapter->netdev->features);
 	igb_vlan_rx_add_vid(adapter->netdev, htons(ETH_P_8021Q), 0);
 
 	for_each_set_bit_from(vid, adapter->active_vlans, VLAN_N_VID)
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 11e8496236a6..a812b3fae712 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2604,11 +2604,11 @@ static void igbvf_print_device_info(struct igbvf_adapter *adapter)
 }
 
 static int igbvf_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct igbvf_adapter *adapter = netdev_priv(netdev);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		adapter->flags &= ~IGBVF_FLAG_RX_CSUM_DISABLED;
 	else
 		adapter->flags |= IGBVF_FLAG_RX_CSUM_DISABLED;
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 65eb629cda99..c0305237a620 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -1614,9 +1614,10 @@ static void igc_process_skb_fields(struct igc_ring *rx_ring,
 	skb->protocol = eth_type_trans(skb, rx_ring->netdev);
 }
 
-static void igc_vlan_mode(struct net_device *netdev, netdev_features_t features)
+static void igc_vlan_mode(struct net_device *netdev,
+			  const netdev_features_t *features)
 {
-	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features);
+	bool enable = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features);
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	struct igc_hw *hw = &adapter->hw;
 	u32 ctrl;
@@ -1635,7 +1636,7 @@ static void igc_vlan_mode(struct net_device *netdev, netdev_features_t features)
 
 static void igc_restore_vlan(struct igc_adapter *adapter)
 {
-	igc_vlan_mode(adapter->netdev, adapter->netdev->features);
+	igc_vlan_mode(adapter->netdev, &adapter->netdev->features);
 }
 
 static struct igc_rx_buffer *igc_get_rx_buffer(struct igc_ring *rx_ring,
@@ -4985,12 +4986,12 @@ static void igc_fix_features(struct net_device *netdev,
 }
 
 static int igc_set_features(struct net_device *netdev,
-			    netdev_features_t features)
+			    const netdev_features_t *features)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		igc_vlan_mode(netdev, features);
 
@@ -4999,10 +5000,10 @@ static int igc_set_features(struct net_device *netdev,
 	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, changed))
 		return 0;
 
-	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, features))
+	if (!netdev_feature_test(NETIF_F_NTUPLE_BIT, *features))
 		igc_flush_nfc_rules(adapter);
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 
 	if (netif_running(netdev))
 		igc_reinit_locked(adapter);
diff --git a/drivers/net/ethernet/intel/ixgb/ixgb_main.c b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
index bb0ce65cd025..d8d88bb41c38 100644
--- a/drivers/net/ethernet/intel/ixgb/ixgb_main.c
+++ b/drivers/net/ethernet/intel/ixgb/ixgb_main.c
@@ -306,17 +306,18 @@ ixgb_fix_features(struct net_device *netdev, netdev_features_t *features)
 }
 
 static int
-ixgb_set_features(struct net_device *netdev, netdev_features_t features)
+ixgb_set_features(struct net_device *netdev,
+		  const netdev_features_t *features)
 {
 	struct ixgb_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) &&
 	    !netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed))
 		return 0;
 
-	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+	adapter->rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
 
 	if (netif_running(netdev)) {
 		ixgb_down(adapter, true);
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 139eec69f5b9..7faec783bfcc 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -9866,16 +9866,16 @@ static void ixgbe_reset_l2fw_offload(struct ixgbe_adapter *adapter)
 }
 
 static int ixgbe_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 	bool need_reset = false;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 
 	/* Make sure RSC matches LRO, reset if change */
-	if (!netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 		if (adapter->flags2 & IXGBE_FLAG2_RSC_ENABLED)
 			need_reset = true;
 		adapter->flags2 &= ~IXGBE_FLAG2_RSC_ENABLED;
@@ -9886,7 +9886,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 			adapter->flags2 |= IXGBE_FLAG2_RSC_ENABLED;
 			need_reset = true;
 		} else if (netdev_feature_test(NETIF_F_LRO_BIT, changed) !=
-			   netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+			   netdev_feature_test(NETIF_F_LRO_BIT, *features)) {
 			e_info(probe, "rx-usecs set too low, "
 			       "disabling RSC\n");
 		}
@@ -9896,8 +9896,8 @@ static int ixgbe_set_features(struct net_device *netdev,
 	 * Check if Flow Director n-tuple support or hw_tc support was
 	 * enabled or disabled.  If the state changed, we need to reset.
 	 */
-	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features) ||
-	    netdev_feature_test(NETIF_F_HW_TC_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, *features) ||
+	    netdev_feature_test(NETIF_F_HW_TC_BIT, *features)) {
 		/* turn off ATR, enable perfect filters and reset */
 		if (!(adapter->flags & IXGBE_FLAG_FDIR_PERFECT_CAPABLE))
 			need_reset = true;
@@ -9927,7 +9927,7 @@ static int ixgbe_set_features(struct net_device *netdev,
 	if (netdev_feature_test(NETIF_F_RXALL_BIT, changed))
 		need_reset = true;
 
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 
 	if (netdev_feature_test(NETIF_F_HW_L2FW_DOFFLOAD_BIT, changed) && adapter->num_rx_pools > 1)
 		ixgbe_reset_l2fw_offload(adapter);
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index fc967f35f8a7..f051cc448abc 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2671,12 +2671,13 @@ jme_fix_features(struct net_device *netdev, netdev_features_t *features)
 }
 
 static int
-jme_set_features(struct net_device *netdev, netdev_features_t features)
+jme_set_features(struct net_device *netdev,
+		 const netdev_features_t *features)
 {
 	struct jme_adapter *jme = netdev_priv(netdev);
 
 	spin_lock_bh(&jme->rxmcs_lock);
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		jme->reg_rxmcs |= RXMCS_CHECKSUM;
 	else
 		jme->reg_rxmcs &= ~RXMCS_CHECKSUM;
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index b66895090e87..4bf7b2fbf728 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -1683,10 +1683,11 @@ mv643xx_eth_set_ringparam(struct net_device *dev, struct ethtool_ringparam *er,
 
 
 static int
-mv643xx_eth_set_features(struct net_device *dev, netdev_features_t features)
+mv643xx_eth_set_features(struct net_device *dev,
+			 const netdev_features_t *features)
 {
 	struct mv643xx_eth_private *mp = netdev_priv(dev);
-	bool rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+	bool rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, *features);
 
 	wrlp(mp, PORT_CONFIG, rx_csum ? 0x02000000 : 0x00000000);
 
@@ -2364,7 +2365,7 @@ static void port_start(struct mv643xx_eth_private *mp)
 	 * frames to RX queue #0, and include the pseudo-header when
 	 * calculating receive checksums.
 	 */
-	mv643xx_eth_set_features(mp->dev, mp->dev->features);
+	mv643xx_eth_set_features(mp->dev, &mp->dev->features);
 
 	/*
 	 * Treat BPDUs as normal multicasts, and disable partition mode.
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 054946f8fa6e..cc6699715171 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5277,14 +5277,14 @@ static int mvpp2_vlan_rx_kill_vid(struct net_device *dev, __be16 proto, u16 vid)
 }
 
 static int mvpp2_set_features(struct net_device *dev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features)) {
 			mvpp2_prs_vid_enable_filtering(port);
 		} else {
 			/* Invalidate all registered VID filters for this
@@ -5297,7 +5297,7 @@ static int mvpp2_set_features(struct net_device *dev,
 	}
 
 	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features))
 			mvpp22_port_rss_enable(port);
 		else
 			mvpp22_port_rss_disable(port);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a77a0ebb0286..c1c012bf1d43 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -1767,14 +1767,15 @@ u16 otx2_get_max_mtu(struct otx2_nic *pfvf)
 }
 EXPORT_SYMBOL(otx2_get_max_mtu);
 
-int otx2_handle_ntuple_tc_features(struct net_device *netdev, netdev_features_t features)
+int otx2_handle_ntuple_tc_features(struct net_device *netdev,
+				   const netdev_features_t *features)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
-	bool ntuple = netdev_feature_test(NETIF_F_NTUPLE_BIT, features);
-	bool tc = netdev_feature_test(NETIF_F_HW_TC_BIT, features);
+	bool ntuple = netdev_feature_test(NETIF_F_NTUPLE_BIT, *features);
+	bool tc = netdev_feature_test(NETIF_F_HW_TC_BIT, *features);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, changed) && !ntuple)
 		otx2_destroy_ntuple_flows(pfvf);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 23948626b1ef..e721517e6597 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -904,7 +904,7 @@ int otx2_install_rxvlan_offload_flow(struct otx2_nic *pfvf);
 bool otx2_xdp_sq_append_pkt(struct otx2_nic *pfvf, u64 iova, int len, u16 qidx);
 u16 otx2_get_max_mtu(struct otx2_nic *pfvf);
 int otx2_handle_ntuple_tc_features(struct net_device *netdev,
-				   netdev_features_t features);
+				   const netdev_features_t *features);
 int otx2_smq_flush(struct otx2_nic *pfvf, int smq);
 
 /* tc support */
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 839350458bc1..f7cc10dcc9ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1929,23 +1929,23 @@ static void otx2_rx_mode_wrk_handler(struct work_struct *work)
 }
 
 static int otx2_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct otx2_nic *pf = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) &&
 	    netif_running(netdev))
 		return otx2_cgx_config_loopback(pf,
 						netdev_feature_test(NETIF_F_LOOPBACK_BIT,
-								    features));
+								    *features));
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) &&
 	    netif_running(netdev))
 		return otx2_enable_rxvlan(pf,
 					  netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT,
-							      features));
+							      *features));
 
 	return otx2_handle_ntuple_tc_features(netdev, features);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 87870bab4893..0acfc16a08ae 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -471,7 +471,7 @@ static void otx2vf_reset_task(struct work_struct *work)
 }
 
 static int otx2vf_set_features(struct net_device *netdev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	return otx2_handle_ntuple_tc_features(netdev, features);
 }
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index afa6234cdd8f..e0257fff2663 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -1279,7 +1279,7 @@ static void rx_set_checksum(struct sky2_port *sky2)
 }
 
 /* Enable/disable receive hash calculation (RSS) */
-static void rx_set_rss(struct net_device *dev, netdev_features_t features)
+static void rx_set_rss(struct net_device *dev, const netdev_features_t *features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
@@ -1292,7 +1292,7 @@ static void rx_set_rss(struct net_device *dev, netdev_features_t features)
 	}
 
 	/* Program RSS initial values */
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features)) {
 		u32 rss_key[10];
 
 		netdev_rss_key_fill(rss_key, sizeof(rss_key));
@@ -1404,20 +1404,21 @@ static DECLARE_NETDEV_FEATURE_SET(sky2_vlan_feature_set,
 				  NETIF_F_SG_BIT,
 				  NETIF_F_TSO_BIT);
 
-static void sky2_vlan_mode(struct net_device *dev, netdev_features_t features)
+static void sky2_vlan_mode(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
 	u16 port = sky2->port;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_ON);
 	else
 		sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T),
 			     RX_VLAN_STRIP_OFF);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features)) {
 		sky2_write32(hw, SK_REG(port, TX_GMF_CTRL_T),
 			     TX_VLAN_TAG_ON);
 
@@ -1545,7 +1546,7 @@ static void sky2_rx_start(struct sky2_port *sky2)
 		rx_set_checksum(sky2);
 
 	if (!(hw->flags & SKY2_HW_RSS_BROKEN))
-		rx_set_rss(sky2->netdev, sky2->netdev->features);
+		rx_set_rss(sky2->netdev, &sky2->netdev->features);
 
 	/* submit Rx ring */
 	for (i = 0; i < sky2->rx_pending; i++) {
@@ -1706,7 +1707,7 @@ static void sky2_hw_up(struct sky2_port *sky2)
 	sky2_prefetch_init(hw, txqaddr[port], sky2->tx_le_map,
 			   sky2->tx_ring_size - 1);
 
-	sky2_vlan_mode(sky2->netdev, sky2->netdev->features);
+	sky2_vlan_mode(sky2->netdev, &sky2->netdev->features);
 	netdev_update_features(sky2->netdev);
 
 	sky2_rx_start(sky2);
@@ -4330,17 +4331,18 @@ static void sky2_fix_features(struct net_device *dev,
 	}
 }
 
-static int sky2_set_features(struct net_device *dev, netdev_features_t features)
+static int sky2_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) &&
 	    !(sky2->hw->flags & SKY2_HW_NEW_LE)) {
 		sky2_write32(sky2->hw,
 			     Q_ADDR(rxqaddr[sky2->port], Q_CSR),
-			     netdev_feature_test(NETIF_F_RXCSUM_BIT, features)
+			     netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)
 			     ? BMU_ENA_RX_CHKSUM : BMU_DIS_RX_CHKSUM);
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index c1236dd59f56..ae3a18119fef 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2712,16 +2712,17 @@ static void mtk_fix_features(struct net_device *dev,
 	}
 }
 
-static int mtk_set_features(struct net_device *dev, netdev_features_t features)
+static int mtk_set_features(struct net_device *dev,
+			    const netdev_features_t *features)
 {
 	netdev_features_t changed;
 	int err = 0;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	if (!netdev_feature_test(NETIF_F_LRO_BIT, features))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, *features))
 		mtk_hwlro_netdev_disable(dev);
 
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 3ace17bbbae0..a93cd318d19d 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2467,7 +2467,7 @@ static int mlx4_en_hwtstamp_set(struct net_device *dev, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
-	if (mlx4_en_reset_config(dev, config, dev->features)) {
+	if (mlx4_en_reset_config(dev, config, &dev->features)) {
 		config.tx_type = HWTSTAMP_TX_OFF;
 		config.rx_filter = HWTSTAMP_FILTER_NONE;
 	}
@@ -2514,20 +2514,20 @@ static void mlx4_en_fix_features(struct net_device *netdev,
 }
 
 static int mlx4_en_set_features(struct net_device *netdev,
-		netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct mlx4_en_priv *priv = netdev_priv(netdev);
 	bool reset = false;
 	int ret = 0;
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXFCS_BIT)) {
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_RXFCS_BIT)) {
 		en_info(priv, "Turn %s RX-FCS\n",
-			netdev_feature_test(NETIF_F_RXFCS_BIT, features) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_RXFCS_BIT, *features) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_RXALL_BIT)) {
-		u8 ignore_fcs_value = netdev_feature_test(NETIF_F_RXALL_BIT, features) ? 1 : 0;
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_RXALL_BIT)) {
+		u8 ignore_fcs_value = netdev_feature_test(NETIF_F_RXALL_BIT, *features) ? 1 : 0;
 
 		en_info(priv, "Turn %s RX-ALL\n",
 			ignore_fcs_value ? "ON" : "OFF");
@@ -2537,24 +2537,24 @@ static int mlx4_en_set_features(struct net_device *netdev,
 			return ret;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
 		en_info(priv, "Turn %s RX vlan strip offload\n",
-			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) ? "ON" : "OFF");
 		reset = true;
 	}
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_CTAG_TX_BIT))
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_HW_VLAN_CTAG_TX_BIT))
 		en_info(priv, "Turn %s TX vlan strip offload\n",
-			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_HW_VLAN_STAG_TX_BIT))
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_HW_VLAN_STAG_TX_BIT))
 		en_info(priv, "Turn %s TX S-VLAN strip offload\n",
-			netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, features) ? "ON" : "OFF");
+			netdev_feature_test(NETIF_F_HW_VLAN_STAG_TX_BIT, *features) ? "ON" : "OFF");
 
-	if (DEV_FEATURE_CHANGED(netdev, features, NETIF_F_LOOPBACK_BIT)) {
+	if (DEV_FEATURE_CHANGED(netdev, *features, NETIF_F_LOOPBACK_BIT)) {
 		en_info(priv, "Turn %s loopback\n",
-			netdev_feature_test(NETIF_F_LOOPBACK_BIT, features) ? "ON" : "OFF");
-		mlx4_en_update_loopback_state(netdev, features);
+			netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features) ? "ON" : "OFF");
+		mlx4_en_update_loopback_state(netdev, *features);
 	}
 
 	if (reset) {
@@ -3498,7 +3498,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 
 int mlx4_en_reset_config(struct net_device *dev,
 			 struct hwtstamp_config ts_config,
-			 netdev_features_t features)
+			 const netdev_features_t *features)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	struct mlx4_en_dev *mdev = priv->mdev;
@@ -3509,12 +3509,12 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	if (priv->hwtstamp_config.tx_type == ts_config.tx_type &&
 	    priv->hwtstamp_config.rx_filter == ts_config.rx_filter &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
-	    !DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT))
+	    !DEV_FEATURE_CHANGED(dev, *features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    !DEV_FEATURE_CHANGED(dev, *features, NETIF_F_RXFCS_BIT))
 		return 0; /* Nothing to change */
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
-	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) &&
+	if (DEV_FEATURE_CHANGED(dev, *features, NETIF_F_HW_VLAN_CTAG_RX_BIT) &&
+	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) &&
 	    (priv->hwtstamp_config.rx_filter != HWTSTAMP_FILTER_NONE)) {
 		en_warn(priv, "Can't turn ON rx vlan offload while time-stamping rx filter is ON\n");
 		return -EINVAL;
@@ -3540,8 +3540,8 @@ int mlx4_en_reset_config(struct net_device *dev,
 
 	mlx4_en_safe_replace_resources(priv, tmp);
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (DEV_FEATURE_CHANGED(dev, *features, NETIF_F_HW_VLAN_CTAG_RX_BIT)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			netdev_active_feature_add(dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 		else
@@ -3559,8 +3559,8 @@ int mlx4_en_reset_config(struct net_device *dev,
 						  NETIF_F_HW_VLAN_CTAG_RX_BIT);
 	}
 
-	if (DEV_FEATURE_CHANGED(dev, features, NETIF_F_RXFCS_BIT)) {
-		if (netdev_feature_test(NETIF_F_RXFCS_BIT, features))
+	if (DEV_FEATURE_CHANGED(dev, *features, NETIF_F_RXFCS_BIT)) {
+		if (netdev_feature_test(NETIF_F_RXFCS_BIT, *features))
 			netdev_active_feature_add(dev, NETIF_F_RXFCS_BIT);
 		else
 			netdev_active_feature_del(dev, NETIF_F_RXFCS_BIT);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index 29b0ac52c6a9..c514fb785e62 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -781,7 +781,7 @@ void mlx4_en_ptp_overflow_check(struct mlx4_en_dev *mdev);
 int mlx4_en_moderation_update(struct mlx4_en_priv *priv);
 int mlx4_en_reset_config(struct net_device *dev,
 			 struct hwtstamp_config ts_config,
-			 netdev_features_t new_features);
+			 const netdev_features_t *new_features);
 void mlx4_en_update_pfc_stats_bitmap(struct mlx4_dev *dev,
 				     struct mlx4_en_stats_bitmap *stats_bitmap,
 				     u8 rx_ppp, u8 rx_pause,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index c2dc487ac760..f70f6b9513aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1242,7 +1242,7 @@ void mlx5e_tx_dim_work(struct work_struct *work);
 
 void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
 			  netdev_features_t *features);
-int mlx5e_set_features(struct net_device *netdev, netdev_features_t features);
+int mlx5e_set_features(struct net_device *netdev, const netdev_features_t *features);
 #ifdef CONFIG_MLX5_ESWITCH
 int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac);
 int mlx5e_set_vf_rate(struct net_device *dev, int vf, int min_tx_rate, int max_tx_rate);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d6cc33d2079b..44a3ef2d8cd1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3861,11 +3861,14 @@ static int mlx5e_handle_feature(struct net_device *netdev,
 	return 0;
 }
 
-int mlx5e_set_features(struct net_device *netdev, netdev_features_t features)
+int mlx5e_set_features(struct net_device *netdev,
+		       const netdev_features_t *features)
 {
-	netdev_features_t oper_features = features;
+	netdev_features_t oper_features;
 	int err = 0;
 
+	netdev_features_copy(oper_features, *features);
+
 #define MLX5E_HANDLE_FEATURE(feature_bit, handler) \
 	mlx5e_handle_feature(netdev, &oper_features, feature_bit, handler)
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9b1934a897e0..ccdc585b6e4c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1216,15 +1216,15 @@ static int mlxsw_sp_feature_loopback(struct net_device *dev, bool enable)
 typedef int (*mlxsw_sp_feature_handler)(struct net_device *dev, bool enable);
 
 static int mlxsw_sp_handle_feature(struct net_device *dev,
-				   netdev_features_t wanted_features,
+				   const netdev_features_t *wanted_features,
 				   int feature_bit,
 				   mlxsw_sp_feature_handler feature_handler)
 {
-	bool enable = netdev_feature_test(feature_bit, wanted_features);
+	bool enable = netdev_feature_test(feature_bit, *wanted_features);
 	netdev_features_t changes;
 	int err;
 
-	netdev_features_xor(changes, dev->features, wanted_features);
+	netdev_features_xor(changes, dev->features, *wanted_features);
 	if (!netdev_feature_test(feature_bit, changes))
 		return 0;
 
@@ -1243,7 +1243,7 @@ static int mlxsw_sp_handle_feature(struct net_device *dev,
 	return 0;
 }
 static int mlxsw_sp_set_features(struct net_device *dev,
-				 netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	netdev_features_t oper_features = dev->features;
 	int err = 0;
@@ -1254,7 +1254,7 @@ static int mlxsw_sp_set_features(struct net_device *dev,
 				       mlxsw_sp_feature_loopback);
 
 	if (err) {
-		dev->features = oper_features;
+		netdev_active_features_copy(dev, oper_features);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/ethernet/micrel/ksz884x.c b/drivers/net/ethernet/micrel/ksz884x.c
index 50789716b1c7..a917aaeed046 100644
--- a/drivers/net/ethernet/micrel/ksz884x.c
+++ b/drivers/net/ethernet/micrel/ksz884x.c
@@ -6498,7 +6498,7 @@ static void netdev_get_ethtool_stats(struct net_device *dev,
  * Return 0 if successful; otherwise an error code.
  */
 static int netdev_set_features(struct net_device *dev,
-	netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct dev_priv *priv = netdev_priv(dev);
 	struct dev_info *hw_priv = priv->adapter;
@@ -6507,7 +6507,7 @@ static int netdev_set_features(struct net_device *dev,
 	mutex_lock(&hw_priv->lock);
 
 	/* see note in hw_setup() */
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		hw->rx_cfg |= DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP;
 	else
 		hw->rx_cfg &= ~(DMA_RX_CSUM_TCP | DMA_RX_CSUM_IP);
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 828fa985f398..cfeb18cbe91b 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -843,13 +843,13 @@ static int ocelot_vlan_rx_kill_vid(struct net_device *dev, __be16 proto,
 }
 
 static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	u32 val;
 
 	/* Filtering */
 	val = ocelot_read(ocelot, ANA_VLANMASK);
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features))
 		val |= BIT(port);
 	else
 		val &= ~BIT(port);
@@ -857,16 +857,16 @@ static void ocelot_vlan_mode(struct ocelot *ocelot, int port,
 }
 
 static int ocelot_set_features(struct net_device *dev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT) &&
-	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, *features) &&
 	    priv->tc.offload_cnt) {
 		netdev_err(dev,
 			   "Cannot disable HW TC offload while offloads active\n");
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 951dd5045ecb..cd0f86d07ac4 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -6568,18 +6568,19 @@ static void s2io_ethtool_get_strings(struct net_device *dev,
 	}
 }
 
-static int s2io_set_features(struct net_device *dev, netdev_features_t features)
+static int s2io_set_features(struct net_device *dev,
+			     const netdev_features_t *features)
 {
 	struct s2io_nic *sp = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_LRO_BIT, changed) && netif_running(dev)) {
 		int rc;
 
 		s2io_stop_all_tx_queue(sp);
 		s2io_card_down(sp);
-		dev->features = features;
+		netdev_active_features_copy(dev, *features);
 		rc = s2io_card_up(sp);
 		if (rc)
 			s2io_reset(sp);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 754179c46769..723ee0225c9f 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1664,7 +1664,7 @@ static void nfp_net_stat64(struct net_device *netdev,
 }
 
 static int nfp_net_set_features(struct net_device *netdev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	netdev_features_t changed;
@@ -1675,23 +1675,23 @@ static int nfp_net_set_features(struct net_device *netdev,
 
 	new_ctrl = nn->dp.ctrl;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXCSUM_ANY;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 
 	if (netdev_features_intersects(changed, netdev_ip_csum_features)) {
-		if (netdev_features_intersects(features, netdev_ip_csum_features))
+		if (netdev_features_intersects(*features, netdev_ip_csum_features))
 			new_ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
 	}
 
 	if (netdev_features_intersects(changed, netdev_general_tso_features)) {
-		if (netdev_features_intersects(features, netdev_general_tso_features))
+		if (netdev_features_intersects(*features, netdev_general_tso_features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					      NFP_NET_CFG_CTRL_LSO;
 		else
@@ -1699,7 +1699,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_RXVLAN_V2 ?:
 				    NFP_NET_CFG_CTRL_RXVLAN;
 		else
@@ -1707,7 +1707,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_TXVLAN_V2 ?:
 				    NFP_NET_CFG_CTRL_TXVLAN;
 		else
@@ -1715,21 +1715,21 @@ static int nfp_net_set_features(struct net_device *netdev,
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features))
 			new_ctrl |= NFP_NET_CFG_CTRL_CTAG_FILTER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_CTAG_FILTER;
 	}
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_STAG_RX_BIT, *features))
 			new_ctrl |= NFP_NET_CFG_CTRL_RXQINQ;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXQINQ;
 	}
 
 	if (netdev_feature_test(NETIF_F_SG_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_SG_BIT, features))
+		if (netdev_feature_test(NETIF_F_SG_BIT, *features))
 			new_ctrl |= NFP_NET_CFG_CTRL_GATHER;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_GATHER;
@@ -1740,7 +1740,7 @@ static int nfp_net_set_features(struct net_device *netdev,
 		return err;
 
 	nn_dbg(nn, "Feature change 0x%llx -> 0x%llx (changed=0x%llx)\n",
-	       netdev->features, features, changed);
+	       netdev->features, *features, changed);
 
 	if (new_ctrl == nn->dp.ctrl)
 		return 0;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.c b/drivers/net/ethernet/netronome/nfp/nfp_port.c
index 01a1fbf9aa0d..8cfda24f5171 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.c
@@ -58,7 +58,8 @@ int nfp_port_setup_tc(struct net_device *netdev, enum tc_setup_type type,
 	return nfp_app_setup_tc(port->app, netdev, type, type_data);
 }
 
-int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
+int nfp_port_set_features(struct net_device *netdev,
+			  const netdev_features_t *features)
 {
 	struct nfp_port *port;
 
@@ -67,7 +68,7 @@ int nfp_port_set_features(struct net_device *netdev, netdev_features_t features)
 		return 0;
 
 	if (netdev_active_feature_test(netdev, NETIF_F_HW_TC_BIT) &&
-	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features) &&
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, *features) &&
 	    port->tc_offload_cnt) {
 		netdev_err(netdev, "Cannot disable HW TC offload while offloads active\n");
 		return -EBUSY;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_port.h b/drivers/net/ethernet/netronome/nfp/nfp_port.h
index 6793cdf9ff11..49acddc4474e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_port.h
+++ b/drivers/net/ethernet/netronome/nfp/nfp_port.h
@@ -103,7 +103,8 @@ static inline bool nfp_port_is_vnic(const struct nfp_port *port)
 }
 
 int
-nfp_port_set_features(struct net_device *netdev, netdev_features_t features);
+nfp_port_set_features(struct net_device *netdev,
+		      const netdev_features_t *features);
 
 struct nfp_port *nfp_port_from_netdev(struct net_device *netdev);
 int nfp_port_get_port_parent_id(struct net_device *netdev,
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 82bccdfcfa50..c1fc2d3f3109 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4872,7 +4872,8 @@ static int nv_set_pauseparam(struct net_device *dev, struct ethtool_pauseparam*
 	return 0;
 }
 
-static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
+static int nv_set_loopback(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	unsigned long flags;
@@ -4881,7 +4882,7 @@ static int nv_set_loopback(struct net_device *dev, netdev_features_t features)
 
 	spin_lock_irqsave(&np->lock, flags);
 	miicontrol = mii_rw(dev, np->phyaddr, MII_BMCR, MII_READ);
-	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, *features)) {
 		if (miicontrol & BMCR_LOOPBACK) {
 			spin_unlock_irqrestore(&np->lock, flags);
 			netdev_info(dev, "Loopback already enabled\n");
@@ -4934,18 +4935,19 @@ static void nv_fix_features(struct net_device *dev, netdev_features_t *features)
 		netdev_feature_add(NETIF_F_RXCSUM_BIT, *features);
 }
 
-static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
+static void nv_vlan_mode(struct net_device *dev,
+			 const netdev_features_t *features)
 {
 	struct fe_priv *np = get_nvpriv(dev);
 
 	spin_lock_irq(&np->lock);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANSTRIP;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANSTRIP;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features))
 		np->txrxctl_bits |= NVREG_TXRXCTL_VLANINS;
 	else
 		np->txrxctl_bits &= ~NVREG_TXRXCTL_VLANINS;
@@ -4955,14 +4957,15 @@ static void nv_vlan_mode(struct net_device *dev, netdev_features_t features)
 	spin_unlock_irq(&np->lock);
 }
 
-static int nv_set_features(struct net_device *dev, netdev_features_t features)
+static int nv_set_features(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct fe_priv *np = netdev_priv(dev);
 	u8 __iomem *base = get_hwbase(dev);
 	netdev_features_t changed;
 	int retval;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_LOOPBACK_BIT, changed) &&
 	    netif_running(dev)) {
 		retval = nv_set_loopback(dev, features);
@@ -4973,7 +4976,7 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		spin_lock_irq(&np->lock);
 
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 			np->txrxctl_bits |= NVREG_TXRXCTL_RXCHECK;
 		else
 			np->txrxctl_bits &= ~NVREG_TXRXCTL_RXCHECK;
@@ -5616,7 +5619,7 @@ static int nv_open(struct net_device *dev)
 	 * that it's set correctly now.
 	 */
 	if (netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT))
-		nv_set_loopback(dev, dev->features);
+		nv_set_loopback(dev, &dev->features);
 
 	return 0;
 out_drain:
@@ -6113,7 +6116,7 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 	nv_stop_tx(dev);
 
 	if (id->driver_data & DEV_HAS_VLAN)
-		nv_vlan_mode(dev, dev->features);
+		nv_vlan_mode(dev, &dev->features);
 
 	dev_info(&pci_dev->dev, "ifname %s, PHY OUI 0x%x @ %d, addr %pM\n",
 		 dev->name, np->phy_oui, np->phyaddr, dev->dev_addr);
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index 452d3fae2f0e..b41db2d70812 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -2203,12 +2203,12 @@ static int pch_gbe_change_mtu(struct net_device *netdev, int new_mtu)
  *	0:		HW state updated successfully
  */
 static int pch_gbe_set_features(struct net_device *netdev,
-	netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct pch_gbe_adapter *adapter = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 081c54db89ef..79f5d936a49f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1364,48 +1364,48 @@ static void ionic_ndo_set_rx_mode(struct net_device *netdev)
 	ionic_lif_deferred_enqueue(&lif->deferred, work);
 }
 
-static __le64 ionic_netdev_features_to_nic(netdev_features_t features)
+static __le64 ionic_netdev_features_to_nic(const netdev_features_t *features)
 {
 	u64 wanted = 0;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features))
 		wanted |= IONIC_ETH_HW_VLAN_TX_TAG;
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_STRIP;
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features))
 		wanted |= IONIC_ETH_HW_VLAN_RX_FILTER;
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features))
 		wanted |= IONIC_ETH_HW_RX_HASH;
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		wanted |= IONIC_ETH_HW_RX_CSUM;
-	if (netdev_feature_test(NETIF_F_SG_BIT, features))
+	if (netdev_feature_test(NETIF_F_SG_BIT, *features))
 		wanted |= IONIC_ETH_HW_TX_SG;
-	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, *features))
 		wanted |= IONIC_ETH_HW_TX_CSUM;
-	if (netdev_feature_test(NETIF_F_TSO_BIT, features))
+	if (netdev_feature_test(NETIF_F_TSO_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO;
-	if (netdev_feature_test(NETIF_F_TSO6_BIT, features))
+	if (netdev_feature_test(NETIF_F_TSO6_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_IPV6;
-	if (netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
+	if (netdev_feature_test(NETIF_F_TSO_ECN_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_ECN;
-	if (netdev_feature_test(NETIF_F_GSO_GRE_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_GRE_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_GRE;
-	if (netdev_feature_test(NETIF_F_GSO_GRE_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_GRE_CSUM_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_GRE_CSUM;
-	if (netdev_feature_test(NETIF_F_GSO_IPXIP4_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_IPXIP4_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP4;
-	if (netdev_feature_test(NETIF_F_GSO_IPXIP6_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_IPXIP6_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_IPXIP6;
-	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_UDP;
-	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, *features))
 		wanted |= IONIC_ETH_HW_TSO_UDP_CSUM;
 
 	return cpu_to_le64(wanted);
 }
 
 static int ionic_set_nic_features(struct ionic_lif *lif,
-				  netdev_features_t features)
+				  const netdev_features_t *features)
 {
 	struct device *dev = lif->ionic->dev;
 	struct ionic_admin_ctx ctx = {
@@ -1502,7 +1502,7 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	if (lif->nxqs > 1)
 		netdev_feature_add(NETIF_F_RXHASH_BIT, features);
 
-	err = ionic_set_nic_features(lif, features);
+	err = ionic_set_nic_features(lif, &features);
 	if (err)
 		return err;
 
@@ -1557,13 +1557,13 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 }
 
 static int ionic_set_features(struct net_device *netdev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	int err;
 
 	netdev_dbg(netdev, "%s: lif->features=0x%08llx new_features=0x%08llx\n",
-		   __func__, (u64)lif->netdev->features, (u64)features);
+		   __func__, (u64)lif->netdev->features, (u64)*features);
 
 	err = ionic_set_nic_features(lif, features);
 
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index e2af570cda6e..61b1636e8f86 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -531,23 +531,23 @@ static void netxen_fix_features(struct net_device *dev,
 }
 
 static int netxen_set_features(struct net_device *dev,
-	netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
 	netdev_features_t changed;
 	int hw_lro;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
-	hw_lro = (netdev_feature_test(NETIF_F_LRO_BIT, features)) ? NETXEN_NIC_LRO_ENABLED
+	hw_lro = (netdev_feature_test(NETIF_F_LRO_BIT, *features)) ? NETXEN_NIC_LRO_ENABLED
 	         : NETXEN_NIC_LRO_DISABLED;
 
 	if (netxen_config_hw_lro(adapter, hw_lro))
 		return -EIO;
 
-	if (!netdev_feature_test(NETIF_F_LRO_BIT, features) && netxen_send_lro_cleanup(adapter))
+	if (!netdev_feature_test(NETIF_F_LRO_BIT, *features) && netxen_send_lro_cleanup(adapter))
 		return -EIO;
 
 	return 0;
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index ada71452d454..de6c226fa6ab 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -546,7 +546,7 @@ void qede_vlan_mark_nonconfigured(struct qede_dev *edev);
 int qede_configure_vlan_filters(struct qede_dev *edev);
 
 void qede_fix_features(struct net_device *dev, netdev_features_t *features);
-int qede_set_features(struct net_device *dev, netdev_features_t features);
+int qede_set_features(struct net_device *dev, const netdev_features_t *features);
 void qede_set_rx_mode(struct net_device *ndev);
 void qede_config_rx_mode(struct net_device *ndev);
 void qede_fill_rss_params(struct qede_dev *edev,
diff --git a/drivers/net/ethernet/qlogic/qede/qede_filter.c b/drivers/net/ethernet/qlogic/qede/qede_filter.c
index b6d6ce69929c..0f391d75d9be 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_filter.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_filter.c
@@ -919,20 +919,20 @@ void qede_fix_features(struct net_device *dev, netdev_features_t *features)
 		netdev_feature_del(NETIF_F_GRO_HW_BIT, *features);
 }
 
-int qede_set_features(struct net_device *dev, netdev_features_t features)
+int qede_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	netdev_features_t changes;
 	bool need_reload = false;
 
-	netdev_features_xor(changes, dev->features, features);
+	netdev_features_xor(changes, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changes))
 		need_reload = true;
 
 	if (need_reload) {
 		struct qede_reload_args args;
 
-		args.u.features = features;
+		netdev_features_copy(args.u.features, *features);
 		args.func = &qede_set_features_reload;
 
 		/* Make sure that we definitely need to reload.
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
index 9b41e2f5c82c..4d8f2292c1d7 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic.h
@@ -1624,7 +1624,8 @@ int qlcnic_fw_cmd_set_drv_version(struct qlcnic_adapter *, u32);
 int qlcnic_change_mtu(struct net_device *netdev, int new_mtu);
 void qlcnic_fix_features(struct net_device *netdev,
 			 netdev_features_t *features);
-int qlcnic_set_features(struct net_device *netdev, netdev_features_t features);
+int qlcnic_set_features(struct net_device *netdev,
+			const netdev_features_t *features);
 int qlcnic_config_bridged_mode(struct qlcnic_adapter *adapter, u32 enable);
 void qlcnic_update_cmd_producer(struct qlcnic_host_tx_ring *);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 3efc9f294712..4cb6dce41ad3 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1086,13 +1086,14 @@ void qlcnic_fix_features(struct net_device *netdev, netdev_features_t *features)
 }
 
 
-int qlcnic_set_features(struct net_device *netdev, netdev_features_t features)
+int qlcnic_set_features(struct net_device *netdev,
+			const netdev_features_t *features)
 {
 	struct qlcnic_adapter *adapter = netdev_priv(netdev);
-	int hw_lro = netdev_feature_test(NETIF_F_LRO_BIT, features) ? QLCNIC_LRO_ENABLED : 0;
+	int hw_lro = netdev_feature_test(NETIF_F_LRO_BIT, *features) ? QLCNIC_LRO_ENABLED : 0;
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (!netdev_feature_test(NETIF_F_LRO_BIT, changed))
 		return 0;
 
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index f74079e9c43a..3a5f9c93edb8 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -174,12 +174,12 @@ static irqreturn_t emac_isr(int _irq, void *data)
 
 /* Configure VLAN tag strip/insert feature */
 static int emac_set_features(struct net_device *netdev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
 	 */
@@ -192,7 +192,7 @@ static int emac_set_features(struct net_device *netdev,
 	/* emac_mac_mode_config() uses netdev->features to configure the EMAC,
 	 * so make sure it's set first.
 	 */
-	netdev->features = features;
+	netdev_active_features_copy(netdev, *features);
 
 	return emac_reinit_locked(adpt);
 }
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 65dd210b0b25..098b0ee85f36 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1459,24 +1459,25 @@ static void cp_set_msglevel(struct net_device *dev, u32 value)
 	cp->msg_enable = value;
 }
 
-static int cp_set_features(struct net_device *dev, netdev_features_t features)
+static int cp_set_features(struct net_device *dev,
+			   const netdev_features_t *features)
 {
 	struct cp_private *cp = netdev_priv(dev);
 	netdev_features_t changed;
 	unsigned long flags;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
 	spin_lock_irqsave(&cp->lock, flags);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		cp->cpcmd |= RxChkSum;
 	else
 		cp->cpcmd &= ~RxChkSum;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		cp->cpcmd |= RxVlanOn;
 	else
 		cp->cpcmd &= ~RxVlanOn;
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 24b30873c38d..c8f1622a230f 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -898,14 +898,15 @@ static struct net_device *rtl8139_init_board(struct pci_dev *pdev)
 	return ERR_PTR(rc);
 }
 
-static int rtl8139_set_features(struct net_device *dev, netdev_features_t features)
+static int rtl8139_set_features(struct net_device *dev,
+				const netdev_features_t *features)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
 	unsigned long flags;
 	netdev_features_t changed;
 	void __iomem *ioaddr = tp->mmio_addr;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_RXALL_BIT, changed))
 		return 0;
 
@@ -913,7 +914,7 @@ static int rtl8139_set_features(struct net_device *dev, netdev_features_t featur
 
 	if (netdev_feature_test(NETIF_F_RXALL_BIT, changed)) {
 		int rx_mode = tp->rx_config;
-		if (netdev_feature_test(NETIF_F_RXALL_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXALL_BIT, *features))
 			rx_mode |= (AcceptErr | AcceptRunt);
 		else
 			rx_mode &= ~(AcceptErr | AcceptRunt);
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7f1dd10b6387..3ae8110e1596 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1438,17 +1438,17 @@ static void rtl8169_fix_features(struct net_device *dev,
 }
 
 static void rtl_set_rx_config_features(struct rtl8169_private *tp,
-				       netdev_features_t features)
+				       const netdev_features_t *features)
 {
 	u32 rx_config = RTL_R32(tp, RxConfig);
 
-	if (netdev_feature_test(NETIF_F_RXALL_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXALL_BIT, *features))
 		rx_config |= RX_CONFIG_ACCEPT_ERR_MASK;
 	else
 		rx_config &= ~RX_CONFIG_ACCEPT_ERR_MASK;
 
 	if (rtl_is_8125(tp)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			rx_config |= RX_VLAN_8125;
 		else
 			rx_config &= ~RX_VLAN_8125;
@@ -1458,19 +1458,19 @@ static void rtl_set_rx_config_features(struct rtl8169_private *tp,
 }
 
 static int rtl8169_set_features(struct net_device *dev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	rtl_set_rx_config_features(tp, features);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		tp->cp_cmd |= RxChkSum;
 	else
 		tp->cp_cmd &= ~RxChkSum;
 
 	if (!rtl_is_8125(tp)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			tp->cp_cmd |= RxVlan;
 		else
 			tp->cp_cmd &= ~RxVlan;
@@ -3723,7 +3723,7 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
 	rtl_init_rxcfg(tp);
 	rtl_set_tx_config_registers(tp);
-	rtl_set_rx_config_features(tp, tp->dev->features);
+	rtl_set_rx_config_features(tp, &tp->dev->features);
 	rtl_set_rx_mode(tp->dev);
 	rtl_irq_enable(tp);
 }
@@ -5279,7 +5279,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netdev_hw_feature_add(dev, NETIF_F_RXFCS_BIT);
 
 	/* configure chip for default features */
-	rtl8169_set_features(dev, dev->features);
+	rtl8169_set_features(dev, &dev->features);
 
 	if (tp->dash_type == RTL_DASH_NONE) {
 		rtl_set_d3_pll_down(tp, true);
diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
index efd3c32b9e46..42ade12eda0f 100644
--- a/drivers/net/ethernet/renesas/ravb.h
+++ b/drivers/net/ethernet/renesas/ravb.h
@@ -1009,7 +1009,8 @@ struct ravb_hw_info {
 	void *(*alloc_rx_desc)(struct net_device *ndev, int q);
 	bool (*receive)(struct net_device *ndev, int *quota, int q);
 	void (*set_rate)(struct net_device *ndev);
-	int (*set_feature)(struct net_device *ndev, netdev_features_t features);
+	int (*set_feature)(struct net_device *ndev,
+			   const netdev_features_t *features);
 	int (*dmac_init)(struct net_device *ndev);
 	void (*emac_init)(struct net_device *ndev);
 	const char (*gstrings_stats)[ETH_GSTRING_LEN];
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 49c2d8aa3c25..5f99a06ef122 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2327,29 +2327,29 @@ static void ravb_set_rx_csum(struct net_device *ndev, bool enable)
 }
 
 static int ravb_set_features_gbeth(struct net_device *ndev,
-				   netdev_features_t features)
+				   const netdev_features_t *features)
 {
 	/* Place holder */
 	return 0;
 }
 
 static int ravb_set_features_rcar(struct net_device *ndev,
-				  netdev_features_t features)
+				  const netdev_features_t *features)
 {
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		ravb_set_rx_csum(ndev,
-				 netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
+				 netdev_feature_test(NETIF_F_RXCSUM_BIT, *features));
 
-	ndev->features = features;
+	netdev_active_features_copy(ndev, *features);
 
 	return 0;
 }
 
 static int ravb_set_features(struct net_device *ndev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct ravb_private *priv = netdev_priv(ndev);
 	const struct ravb_hw_info *info = priv->info;
diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index 4a55c969241c..cf027162da71 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2930,17 +2930,17 @@ static void sh_eth_set_rx_csum(struct net_device *ndev, bool enable)
 }
 
 static int sh_eth_set_features(struct net_device *ndev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) && mdp->cd->rx_csum)
 		sh_eth_set_rx_csum(ndev,
-				   netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
+				   netdev_feature_test(NETIF_F_RXCSUM_BIT, *features));
 
-	ndev->features = features;
+	netdev_active_features_copy(ndev, *features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index da2f375ad180..d77175ab4dfa 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1776,14 +1776,14 @@ static void sxgbe_get_stats64(struct net_device *dev,
  *  This function returns 0 after setting or resetting device features.
  */
 static int sxgbe_set_features(struct net_device *dev,
-			      netdev_features_t features)
+			      const netdev_features_t *features)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 			priv->hw->mac->enable_rx_csum(priv->ioaddr);
 			priv->rxcsum_insertion = true;
 		} else {
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index df921615ba5a..670e30425447 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -210,14 +210,14 @@ void efx_set_rx_mode(struct net_device *net_dev)
 	/* Otherwise efx_start_port() will do this */
 }
 
-int efx_set_features(struct net_device *net_dev, netdev_features_t data)
+int efx_set_features(struct net_device *net_dev, const netdev_features_t *data)
 {
 	struct efx_nic *efx = efx_netdev_priv(net_dev);
 	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	netdev_features_andnot(tmp, net_dev->features, data);
+	netdev_features_andnot(tmp, net_dev->features, *data);
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
@@ -227,7 +227,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	netdev_features_xor(tmp, net_dev->features, data);
+	netdev_features_xor(tmp, net_dev->features, *data);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp) ||
 	    netdev_feature_test(NETIF_F_RXFCS_BIT, tmp)) {
 		/* efx_set_rx_mode() will schedule MAC work to update filters
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index a191f85b3f5d..3242ce0bb17f 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -96,7 +96,7 @@ static inline void efx_fini_mcdi_logging(struct efx_nic *efx) {}
 void efx_mac_reconfigure(struct efx_nic *efx, bool mtu_only);
 int efx_set_mac_address(struct net_device *net_dev, void *data);
 void efx_set_rx_mode(struct net_device *net_dev);
-int efx_set_features(struct net_device *net_dev, netdev_features_t data);
+int efx_set_features(struct net_device *net_dev, const netdev_features_t *data);
 void efx_link_status_changed(struct efx_nic *efx);
 unsigned int efx_xdp_max_mtu(struct efx_nic *efx);
 int efx_change_mtu(struct net_device *net_dev, int new_mtu);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 232e8fde0a81..438f8a453f32 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2180,14 +2180,15 @@ static void ef4_set_rx_mode(struct net_device *net_dev)
 	/* Otherwise ef4_start_port() will do this */
 }
 
-static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
+static int ef4_set_features(struct net_device *net_dev,
+			    const netdev_features_t *data)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 	netdev_features_t tmp;
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	netdev_features_andnot(tmp, net_dev->features, data);
+	netdev_features_andnot(tmp, net_dev->features, *data);
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, tmp)) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
@@ -2195,7 +2196,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	}
 
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure */
-	netdev_features_xor(tmp, net_dev->features, data);
+	netdev_features_xor(tmp, net_dev->features, *data);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, tmp)) {
 		/* ef4_set_rx_mode() will schedule MAC work to update filters
 		 * when a new features are finally set in net_dev.
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 12aa69a679cf..fc3bf13d4b67 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -209,7 +209,8 @@ void efx_siena_set_rx_mode(struct net_device *net_dev)
 	/* Otherwise efx_start_port() will do this */
 }
 
-int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
+int efx_siena_set_features(struct net_device *net_dev,
+			   const netdev_features_t *data)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	netdev_features_t features;
@@ -217,7 +218,7 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
 	if (netdev_active_feature_test(net_dev, NETIF_F_NTUPLE_BIT) &&
-	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, data)) {
+	    !netdev_feature_test(NETIF_F_NTUPLE_BIT, *data)) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
 			return rc;
@@ -226,7 +227,7 @@ int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data)
 	/* If Rx VLAN filter is changed, update filters via mac_reconfigure.
 	 * If rx-fcs is changed, mac_reconfigure updates that too.
 	 */
-	netdev_features_xor(features, net_dev->features, data);
+	netdev_features_xor(features, net_dev->features, *data);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) ||
 	    netdev_feature_test(NETIF_F_RXFCS_BIT, features)) {
 		/* efx_siena_set_rx_mode() will schedule MAC work to update filters
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.h b/drivers/net/ethernet/sfc/siena/efx_common.h
index d0e2cefba6cb..23d1163c7358 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.h
+++ b/drivers/net/ethernet/sfc/siena/efx_common.h
@@ -99,7 +99,7 @@ static inline void efx_siena_fini_mcdi_logging(struct efx_nic *efx) {}
 void efx_siena_mac_reconfigure(struct efx_nic *efx, bool mtu_only);
 int efx_siena_set_mac_address(struct net_device *net_dev, void *data);
 void efx_siena_set_rx_mode(struct net_device *net_dev);
-int efx_siena_set_features(struct net_device *net_dev, netdev_features_t data);
+int efx_siena_set_features(struct net_device *net_dev, const netdev_features_t *data);
 void efx_siena_link_status_changed(struct efx_nic *efx);
 unsigned int efx_siena_xdp_max_mtu(struct efx_nic *efx);
 int efx_siena_change_mtu(struct net_device *net_dev, int new_mtu);
diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index d594f6b312f2..05db1d69ae2a 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -1748,11 +1748,12 @@ static void netsec_netdev_uninit(struct net_device *ndev)
 }
 
 static int netsec_netdev_set_features(struct net_device *ndev,
-				      netdev_features_t features)
+				      const netdev_features_t *features)
 {
 	struct netsec_priv *priv = netdev_priv(ndev);
 
-	priv->rx_cksum_offload_flag = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
+	priv->rx_cksum_offload_flag = netdev_feature_test(NETIF_F_RXCSUM_BIT,
+							  *features);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index c70f297c1653..4b01d03185e8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5614,12 +5614,12 @@ static void stmmac_fix_features(struct net_device *dev,
 }
 
 static int stmmac_set_features(struct net_device *netdev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct stmmac_priv *priv = netdev_priv(netdev);
 
 	/* Keep the COE Type in case of csum is supporting */
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		priv->hw->rx_csum = priv->plat->rx_coe;
 	else
 		priv->hw->rx_csum = 0;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 302304ccb41f..9f283d13e4f7 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -877,7 +877,7 @@ static void xlgmac_poll_controller(struct net_device *netdev)
 #endif /* CONFIG_NET_POLL_CONTROLLER */
 
 static int xlgmac_set_features(struct net_device *netdev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	netdev_features_t rxhash, rxcsum, rxvlan, rxvlan_filter;
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
@@ -891,29 +891,29 @@ static int xlgmac_set_features(struct net_device *netdev,
 	rxvlan_filter = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 					    pdata->netdev_features);
 
-	if (netdev_feature_test(NETIF_F_RXHASH_BIT, features) && !rxhash)
+	if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features) && !rxhash)
 		ret = hw_ops->enable_rss(pdata);
-	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, features) && rxhash)
+	else if (!netdev_feature_test(NETIF_F_RXHASH_BIT, *features) && rxhash)
 		ret = hw_ops->disable_rss(pdata);
 	if (ret)
 		return ret;
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && !rxcsum)
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) && !rxcsum)
 		hw_ops->enable_rx_csum(pdata);
-	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) && rxcsum)
+	else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) && rxcsum)
 		hw_ops->disable_rx_csum(pdata);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && !rxvlan)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) && !rxvlan)
 		hw_ops->enable_rx_vlan_stripping(pdata);
-	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features) && rxvlan)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features) && rxvlan)
 		hw_ops->disable_rx_vlan_stripping(pdata);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && !rxvlan_filter)
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) && !rxvlan_filter)
 		hw_ops->enable_rx_vlan_filtering(pdata);
-	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features) && rxvlan_filter)
+	else if (!netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features) && rxvlan_filter)
 		hw_ops->disable_rx_vlan_filtering(pdata);
 
-	pdata->netdev_features = features;
+	netdev_features_copy(pdata->netdev_features, *features);
 
 	return 0;
 }
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index e89fcfc52247..c96811972969 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1920,25 +1920,27 @@ static void netvsc_fix_features(struct net_device *ndev,
 }
 
 static int netvsc_set_features(struct net_device *ndev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct net_device_context *ndevctx = netdev_priv(ndev);
 	struct netvsc_device *nvdev = rtnl_dereference(ndevctx->nvdev);
 	struct net_device *vf_netdev = rtnl_dereference(ndevctx->vf_netdev);
 	struct ndis_offload_params offloads;
 	netdev_features_t change;
+	netdev_features_t feats;
 	int ret = 0;
 
 	if (!nvdev || nvdev->destroy)
 		return -ENODEV;
 
-	netdev_features_xor(change, ndev->features, features);
+	netdev_features_copy(feats, feats);
+	netdev_features_xor(change, ndev->features, feats);
 	if (!netdev_feature_test(NETIF_F_LRO_BIT, change))
 		goto syncvf;
 
 	memset(&offloads, 0, sizeof(struct ndis_offload_params));
 
-	if (netdev_feature_test(NETIF_F_LRO_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_LRO_BIT, feats)) {
 		offloads.rsc_ip_v4 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 		offloads.rsc_ip_v6 = NDIS_OFFLOAD_PARAMETERS_RSC_ENABLED;
 	} else {
@@ -1949,15 +1951,15 @@ static int netvsc_set_features(struct net_device *ndev,
 	ret = rndis_filter_set_offload_params(ndev, nvdev, &offloads);
 
 	if (ret) {
-		netdev_feature_change(NETIF_F_LRO_BIT, features);
-		ndev->features = features;
+		netdev_feature_change(NETIF_F_LRO_BIT, feats);
+		netdev_active_features_copy(ndev, feats);
 	}
 
 syncvf:
 	if (!vf_netdev)
 		return ret;
 
-	vf_netdev->wanted_features = features;
+	netdev_wanted_features_copy(vf_netdev, feats);
 	netdev_update_features(vf_netdev);
 
 	return ret;
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 00f660d89c82..4b5ed4452710 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -229,12 +229,12 @@ nsim_setup_tc(struct net_device *dev, enum tc_setup_type type, void *type_data)
 }
 
 static int
-nsim_set_features(struct net_device *dev, netdev_features_t features)
+nsim_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct netdevsim *ns = netdev_priv(dev);
 
 	if (netdev_active_feature_test(dev, NETIF_F_HW_TC_BIT) &&
-	    !netdev_feature_test(NETIF_F_HW_TC_BIT, features))
+	    !netdev_feature_test(NETIF_F_HW_TC_BIT, *features))
 		return nsim_bpf_disable_tc(ns);
 
 	return 0;
diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
index 6687081c5e37..5672382dc361 100644
--- a/drivers/net/usb/aqc111.c
+++ b/drivers/net/usb/aqc111.c
@@ -589,7 +589,7 @@ static void aqc111_set_rx_mode(struct net_device *net)
 }
 
 static int aqc111_set_features(struct net_device *net,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct aqc111_data *aqc111_data = dev->driver_priv;
@@ -597,7 +597,7 @@ static int aqc111_set_features(struct net_device *net,
 	u16 reg16 = 0;
 	u8 reg8 = 0;
 
-	netdev_features_xor(changed, net->features, features);
+	netdev_features_xor(changed, net->features, *features);
 	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_TXCOE_CTL, 1, 1, &reg8);
 		reg8 ^= SFR_TXCOE_TCP | SFR_TXCOE_UDP;
@@ -614,7 +614,7 @@ static int aqc111_set_features(struct net_device *net,
 
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		aqc111_read_cmd(dev, AQ_ACCESS_MAC, SFR_RXCOE_CTL, 1, 1, &reg8);
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 			aqc111_data->rx_checksum = 1;
 			reg8 &= ~(SFR_RXCOE_IP | SFR_RXCOE_TCP | SFR_RXCOE_UDP |
 				  SFR_RXCOE_TCPV6 | SFR_RXCOE_UDPV6);
@@ -628,7 +628,7 @@ static int aqc111_set_features(struct net_device *net,
 				 1, 1, &reg8);
 	}
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features)) {
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features)) {
 			u16 i = 0;
 
 			for (i = 0; i < 256; i++) {
diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 3f3c7da6f758..1ff3bd37792f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -894,13 +894,13 @@ static void ax88179_set_multicast(struct net_device *net)
 }
 
 static int
-ax88179_set_features(struct net_device *net, netdev_features_t features)
+ax88179_set_features(struct net_device *net, const netdev_features_t *features)
 {
 	u8 tmp;
 	struct usbnet *dev = netdev_priv(net);
 	netdev_features_t changed;
 
-	netdev_features_xor(changed, net->features, features);
+	netdev_features_xor(changed, net->features, *features);
 	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
 		ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_TXCOE_CTL, 1, 1, &tmp);
 		tmp ^= AX_TXCOE_TCP | AX_TXCOE_UDP;
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 6cf85b19d4ac..227ca5943007 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2592,7 +2592,7 @@ static int lan78xx_set_mac_addr(struct net_device *netdev, void *p)
 
 /* Enable or disable Rx checksum offload engine */
 static int lan78xx_set_features(struct net_device *netdev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct lan78xx_net *dev = netdev_priv(netdev);
 	struct lan78xx_priv *pdata = (struct lan78xx_priv *)(dev->data[0]);
@@ -2600,7 +2600,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features)) {
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_COE_ | RFE_CTL_IP_COE_;
 		pdata->rfe_ctl |= RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_;
 	} else {
@@ -2608,12 +2608,12 @@ static int lan78xx_set_features(struct net_device *netdev,
 		pdata->rfe_ctl &= ~(RFE_CTL_ICMP_COE_ | RFE_CTL_IGMP_COE_);
 	}
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_STRIP_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_STRIP_;
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, features))
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT, *features))
 		pdata->rfe_ctl |= RFE_CTL_VLAN_FILTER_;
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_FILTER_;
@@ -3022,7 +3022,7 @@ static int lan78xx_reset(struct lan78xx_net *dev)
 		return ret;
 
 	/* Enable or disable checksum offload engines */
-	ret = lan78xx_set_features(dev->net, dev->net->features);
+	ret = lan78xx_set_features(dev->net, &dev->net->features);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index edce2a0d3dd7..5b4f73b7c023 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3251,7 +3251,7 @@ static void rtl_rx_vlan_en(struct r8152 *tp, bool enable)
 }
 
 static int rtl8152_set_features(struct net_device *dev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct r8152 *tp = netdev_priv(dev);
 	netdev_features_t changed;
@@ -3261,12 +3261,12 @@ static int rtl8152_set_features(struct net_device *dev,
 	if (ret < 0)
 		goto out;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 
 	mutex_lock(&tp->control);
 
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			rtl_rx_vlan_en(tp, true);
 		else
 			rtl_rx_vlan_en(tp, false);
diff --git a/drivers/net/usb/smsc75xx.c b/drivers/net/usb/smsc75xx.c
index d3f64cdadfd4..a3cd5f974f6c 100644
--- a/drivers/net/usb/smsc75xx.c
+++ b/drivers/net/usb/smsc75xx.c
@@ -935,7 +935,7 @@ static int smsc75xx_change_mtu(struct net_device *netdev, int new_mtu)
 
 /* Enable or disable Rx checksum offload engine */
 static int smsc75xx_set_features(struct net_device *netdev,
-	netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	struct smsc75xx_priv *pdata = (struct smsc75xx_priv *)(dev->data[0]);
@@ -944,7 +944,7 @@ static int smsc75xx_set_features(struct net_device *netdev,
 
 	spin_lock_irqsave(&pdata->rfe_ctl_lock, flags);
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		pdata->rfe_ctl |= RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM;
 	else
 		pdata->rfe_ctl &= ~(RFE_CTL_TCPUDP_CKM | RFE_CTL_IP_CKM);
@@ -1319,7 +1319,7 @@ static int smsc75xx_reset(struct usbnet *dev)
 		  pdata->rfe_ctl);
 
 	/* Enable or disable checksum offload engines */
-	smsc75xx_set_features(dev->net, dev->net->features);
+	smsc75xx_set_features(dev->net, &dev->net->features);
 
 	smsc75xx_set_multicast(dev->net);
 
diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index 43ba97ab1a82..c3926ae1c11d 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -591,7 +591,7 @@ static void smsc95xx_status(struct usbnet *dev, struct urb *urb)
 
 /* Enable or disable Tx & Rx checksum offload engines */
 static int smsc95xx_set_features(struct net_device *netdev,
-	netdev_features_t features)
+				 const netdev_features_t *features)
 {
 	struct usbnet *dev = netdev_priv(netdev);
 	u32 read_buf;
@@ -601,12 +601,12 @@ static int smsc95xx_set_features(struct net_device *netdev,
 	if (ret < 0)
 		return ret;
 
-	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, *features))
 		read_buf |= Tx_COE_EN_;
 	else
 		read_buf &= ~Tx_COE_EN_;
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 		read_buf |= Rx_COE_EN_;
 	else
 		read_buf &= ~Rx_COE_EN_;
@@ -992,7 +992,7 @@ static int smsc95xx_reset(struct usbnet *dev)
 		return ret;
 
 	/* Enable or disable checksum offload engines */
-	ret = smsc95xx_set_features(dev->net, dev->net->features);
+	ret = smsc95xx_set_features(dev->net, &dev->net->features);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Failed to set checksum offload features\n");
 		return ret;
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ac7a6ebadf00..8c516efa818d 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1467,18 +1467,18 @@ static void veth_fix_features(struct net_device *dev,
 }
 
 static int veth_set_features(struct net_device *dev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	netdev_features_t changed;
 	int err;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (!netdev_feature_test(NETIF_F_GRO_BIT, changed) ||
 	    !(dev->flags & IFF_UP) || priv->_xdp_prog)
 		return 0;
 
-	if (netdev_feature_test(NETIF_F_GRO_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_GRO_BIT, *features)) {
 		err = veth_napi_enable(dev);
 		if (err)
 			return err;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f10bfe07d48d..d4e9ffa9695e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3209,19 +3209,19 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
 }
 
 static int virtnet_set_features(struct net_device *dev,
-				netdev_features_t features)
+				const netdev_features_t *features)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	netdev_features_t changed;
 	u64 offloads;
 	int err;
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_GRO_HW_BIT, changed)) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, features))
+		if (netdev_feature_test(NETIF_F_GRO_HW_BIT, *features))
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
@@ -3234,7 +3234,7 @@ static int virtnet_set_features(struct net_device *dev,
 	}
 
 	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed)) {
-		if (netdev_feature_test(NETIF_F_RXHASH_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXHASH_BIT, *features))
 			vi->ctrl->rss.hash_types = vi->rss_hash_types_saved;
 		else
 			vi->ctrl->rss.hash_types = VIRTIO_NET_HASH_REPORT_NONE;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 6f6338a22c31..f16d5fa08e7e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -300,7 +300,8 @@ void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
 	}
 }
 
-static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_features_t features)
+static void vmxnet3_enable_encap_offloads(struct net_device *netdev,
+					  const netdev_features_t *features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -313,10 +314,10 @@ static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_feat
 					       NETIF_F_TSO_BIT,
 					       NETIF_F_TSO6_BIT,
 					       NETIF_F_LRO_BIT);
-		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, features))
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_BIT, *features))
 			netdev_hw_enc_feature_add(netdev,
 						  NETIF_F_GSO_UDP_TUNNEL_BIT);
-		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features))
+		if (netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, *features))
 			netdev_hw_enc_feature_add(netdev,
 						  NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT);
 	}
@@ -403,7 +404,8 @@ static void vmxnet3_disable_encap_offloads(struct net_device *netdev)
 	}
 }
 
-int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
+int vmxnet3_set_features(struct net_device *netdev,
+			 const netdev_features_t *features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 	unsigned long flags;
@@ -416,12 +418,12 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, tun_offload_mask);
 	udp_tun_enabled = netdev_active_features_intersects(netdev, tun_offload_mask);
 
-	netdev_features_xor(changed, netdev->features, features);
+	netdev_features_xor(changed, netdev->features, *features);
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) ||
 	    netdev_feature_test(NETIF_F_LRO_BIT, changed) ||
 	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) ||
 	    netdev_features_intersects(changed, tun_offload_mask)) {
-		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
+		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
 		else
@@ -429,25 +431,25 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			~UPT1_F_RXCSUM;
 
 		/* update hardware LRO capability accordingly */
-		if (netdev_feature_test(NETIF_F_LRO_BIT, features))
+		if (netdev_feature_test(NETIF_F_LRO_BIT, *features))
 			adapter->shared->devRead.misc.uptFeatures |=
 							UPT1_F_LRO;
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
 							~UPT1_F_LRO;
 
-		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features))
+		if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXVLAN;
 		else
 			adapter->shared->devRead.misc.uptFeatures &=
 			~UPT1_F_RXVLAN;
 
-		if (netdev_features_intersects(features, tun_offload_mask)) {
+		if (netdev_features_intersects(*features, tun_offload_mask)) {
 			vmxnet3_enable_encap_offloads(netdev, features);
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXINNEROFLD;
-		} else if (!netdev_features_intersects(features, tun_offload_mask) &&
+		} else if (!netdev_features_intersects(*features, tun_offload_mask) &&
 			   udp_tun_enabled) {
 			vmxnet3_disable_encap_offloads(netdev);
 			adapter->shared->devRead.misc.uptFeatures &=
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index c9aac6a8e65c..987ffda65ee0 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -499,7 +499,8 @@ vmxnet3_features_check(struct sk_buff *skb,
 		       struct net_device *netdev, netdev_features_t *features);
 
 int
-vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
+vmxnet3_set_features(struct net_device *netdev,
+		     const netdev_features_t *features);
 
 int
 vmxnet3_create_queues(struct vmxnet3_adapter *adapter,
diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index 9ae4af581545..84949d124ef8 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -1120,31 +1120,31 @@ static int ath6kl_close(struct net_device *dev)
 }
 
 static int ath6kl_set_features(struct net_device *dev,
-			       netdev_features_t features)
+			       const netdev_features_t *features)
 {
 	struct ath6kl_vif *vif = netdev_priv(dev);
 	struct ath6kl *ar = vif->ar;
 	int err = 0;
 
-	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
+	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) &&
 	    (ar->rx_meta_ver != WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = WMI_META_VERSION_2;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features;
+			netdev_active_features_copy(dev, *features);
 			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 			return err;
 		}
-	} else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, features) &&
+	} else if (!netdev_feature_test(NETIF_F_RXCSUM_BIT, *features) &&
 		   (ar->rx_meta_ver == WMI_META_VERSION_2)) {
 		ar->rx_meta_ver = 0;
 		err = ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
 							 vif->fw_vif_idx,
 							 ar->rx_meta_ver, 0, 0);
 		if (err) {
-			dev->features = features;
+			netdev_active_features_copy(dev, *features);
 			netdev_active_feature_add(dev, NETIF_F_RXCSUM_BIT);
 			return err;
 		}
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index f83a5e3c6de9..654f805f4522 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1495,9 +1495,9 @@ static void xennet_fix_features(struct net_device *dev,
 }
 
 static int xennet_set_features(struct net_device *dev,
-	netdev_features_t features)
+			       const netdev_features_t *features)
 {
-	if (!netdev_feature_test(NETIF_F_SG_BIT, features) && dev->mtu > ETH_DATA_LEN) {
+	if (!netdev_feature_test(NETIF_F_SG_BIT, *features) && dev->mtu > ETH_DATA_LEN) {
 		netdev_info(dev, "Reducing MTU because no SG offload");
 		dev->mtu = ETH_DATA_LEN;
 	}
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6214f7f0d5ae..b0ac056aa8d0 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1085,7 +1085,7 @@ void qeth_dbf_longtext(debug_info_t *id, int level, char *text, ...);
 int qeth_configure_cq(struct qeth_card *, enum qeth_cq);
 int qeth_hw_trap(struct qeth_card *, enum qeth_diags_trap_action);
 int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
-int qeth_set_features(struct net_device *, netdev_features_t);
+int qeth_set_features(struct net_device *, const netdev_features_t *);
 void qeth_enable_hw_features(struct net_device *dev);
 void qeth_fix_features(struct net_device *, netdev_features_t *);
 void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 31326e81344f..b3ca79930c42 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6788,7 +6788,7 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 		qeth_flush_local_addrs4(card);
 }
 
-int qeth_set_features(struct net_device *dev, netdev_features_t features)
+int qeth_set_features(struct net_device *dev, const netdev_features_t *features)
 {
 	struct qeth_card *card = dev->ml_priv;
 	netdev_features_t changed;
@@ -6797,12 +6797,12 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	int rc = 0;
 
 	QETH_CARD_TEXT(card, 2, "setfeat");
-	QETH_CARD_HEX(card, 2, &features, sizeof(features));
+	QETH_CARD_HEX(card, 2, features, sizeof(*features));
 
-	netdev_features_xor(changed, dev->features, features);
+	netdev_features_xor(changed, dev->features, *features);
 	if (netdev_feature_test(NETIF_F_IP_CSUM_BIT, changed)) {
 		rc = qeth_set_ipa_csum(card,
-				       netdev_feature_test(NETIF_F_IP_CSUM_BIT, features),
+				       netdev_feature_test(NETIF_F_IP_CSUM_BIT, *features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV4,
 				       &card->info.has_lp2lp_cso_v4);
 		if (rc)
@@ -6810,7 +6810,7 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	}
 	if (netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, changed)) {
 		rc = qeth_set_ipa_csum(card,
-				       netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, features),
+				       netdev_feature_test(NETIF_F_IPV6_CSUM_BIT, *features),
 				       IPA_OUTBOUND_CHECKSUM, QETH_PROT_IPV6,
 				       &card->info.has_lp2lp_cso_v6);
 		if (rc)
@@ -6818,26 +6818,26 @@ int qeth_set_features(struct net_device *dev, netdev_features_t features)
 	}
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed)) {
 		rc = qeth_set_ipa_rx_csum(card,
-					  netdev_feature_test(NETIF_F_RXCSUM_BIT, features));
+					  netdev_feature_test(NETIF_F_RXCSUM_BIT, *features));
 		if (rc)
 			netdev_feature_change(NETIF_F_RXCSUM_BIT, changed);
 	}
 	if (netdev_feature_test(NETIF_F_TSO_BIT, changed)) {
 		rc = qeth_set_ipa_tso(card,
-				      netdev_feature_test(NETIF_F_TSO_BIT, features),
+				      netdev_feature_test(NETIF_F_TSO_BIT, *features),
 				      QETH_PROT_IPV4);
 		if (rc)
 			netdev_feature_change(NETIF_F_TSO_BIT, changed);
 	}
 	if (netdev_feature_test(NETIF_F_TSO6_BIT, changed)) {
 		rc = qeth_set_ipa_tso(card,
-				      netdev_feature_test(NETIF_F_TSO6_BIT, features),
+				      netdev_feature_test(NETIF_F_TSO6_BIT, *features),
 				      QETH_PROT_IPV6);
 		if (rc)
 			netdev_feature_change(NETIF_F_TSO6_BIT, changed);
 	}
 
-	netdev_features_xor(diff1, dev->features, features);
+	netdev_features_xor(diff1, dev->features, *features);
 	netdev_features_xor(diff2, dev->features, changed);
 	qeth_check_restricted_features(card, diff1, diff2);
 
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 5e158dbf987f..c1140efa3413 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -2220,11 +2220,12 @@ static int qlge_napi_poll_msix(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
+static void qlge_vlan_mode(struct net_device *ndev,
+			   const netdev_features_t *features)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 
-	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, features)) {
+	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, *features)) {
 		qlge_write32(qdev, NIC_RCV_CFG, NIC_RCV_CFG_VLAN_MASK |
 			     NIC_RCV_CFG_VLAN_MATCH_AND_NON);
 	} else {
@@ -2237,7 +2238,7 @@ static void qlge_vlan_mode(struct net_device *ndev, netdev_features_t features)
  * based on the features to enable/disable hardware vlan accel
  */
 static int qlge_update_hw_vlan_features(struct net_device *ndev,
-					netdev_features_t features)
+					const netdev_features_t *features)
 {
 	struct qlge_adapter *qdev = netdev_to_qdev(ndev);
 	bool need_restart = netif_running(ndev);
@@ -2253,7 +2254,7 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 	}
 
 	/* update the features with resent change */
-	ndev->features = features;
+	netdev_active_features_copy(ndev, *features);
 
 	if (need_restart) {
 		status = qlge_adapter_up(qdev);
@@ -2268,12 +2269,12 @@ static int qlge_update_hw_vlan_features(struct net_device *ndev,
 }
 
 static int qlge_set_features(struct net_device *ndev,
-			     netdev_features_t features)
+			     const netdev_features_t *features)
 {
 	netdev_features_t changed;
 	int err;
 
-	netdev_features_xor(changed, ndev->features, features);
+	netdev_features_xor(changed, ndev->features, *features);
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed)) {
 		/* Update the behavior of vlan accel in the adapter */
 		err = qlge_update_hw_vlan_features(ndev, features);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 63e97effa858..d9e64b45298c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1517,7 +1517,7 @@ struct net_device_ops {
 	void			(*ndo_fix_features)(struct net_device *dev,
 						    netdev_features_t *features);
 	int			(*ndo_set_features)(struct net_device *dev,
-						    netdev_features_t features);
+						    const netdev_features_t *features);
 	int			(*ndo_neigh_construct)(struct net_device *dev,
 						       struct neighbour *n);
 	void			(*ndo_neigh_destroy)(struct net_device *dev,
diff --git a/net/core/dev.c b/net/core/dev.c
index 0d5df1d4f712..e27a8322289b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9732,7 +9732,7 @@ int __netdev_update_features(struct net_device *dev)
 		&dev->features, &features);
 
 	if (dev->netdev_ops->ndo_set_features)
-		err = dev->netdev_ops->ndo_set_features(dev, features);
+		err = dev->netdev_ops->ndo_set_features(dev, &features);
 	else
 		err = 0;
 
-- 
2.33.0

