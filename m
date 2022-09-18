Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1715E5BBD0E
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiIRJuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229747AbiIRJt5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:57 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635101260D
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjf62FvwzHnn8;
        Sun, 18 Sep 2022 17:47:42 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 12/55] treewide: replace NETIF_F_TSO | NETIF_F_TSO6 by netdev_general_tso_features
Date:   Sun, 18 Sep 2022 09:42:53 +0000
Message-ID: <20220918094336.28958-13-shenjian15@huawei.com>
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

Replace the expression "NETIF_F_TSO | NETIF_F_TSO6" by
netdev_general_tso_features, make it simple to use netdev
features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/atheros/alx/main.c              |  2 +-
 drivers/net/ethernet/atheros/atl1c/atl1c_main.c      |  2 +-
 drivers/net/ethernet/broadcom/tg3.c                  |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |  9 ++++-----
 drivers/net/ethernet/ibm/ibmveth.c                   |  9 ++++-----
 drivers/net/ethernet/intel/e1000e/netdev.c           | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c       |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  6 +++---
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  2 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |  4 ++--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c       |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |  4 ++--
 drivers/net/ethernet/realtek/r8169_main.c            |  3 ++-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c    |  2 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c    |  3 +--
 drivers/net/tap.c                                    |  2 +-
 drivers/net/virtio_net.c                             |  4 ++--
 drivers/s390/net/qeth_l2_main.c                      |  2 +-
 drivers/s390/net/qeth_l3_main.c                      |  2 +-
 19 files changed, 34 insertions(+), 39 deletions(-)

diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index e07247d87407..92a0d382795b 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1102,7 +1102,7 @@ static netdev_features_t alx_fix_features(struct net_device *netdev,
 					  netdev_features_t features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+		features &= ~netdev_general_tso_features;
 
 	return features;
 }
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index cb2c12cdd0dc..22bb34ca5a9b 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -521,7 +521,7 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			features &= ~netdev_general_tso_features;
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index e27272328a65..b83aeaf904a8 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7878,7 +7878,7 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 	}
 
 	segs = skb_gso_segment(skb, tp->dev->features &
-				    ~(NETIF_F_TSO | NETIF_F_TSO6));
+				    ~netdev_general_tso_features);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 11f208e479ae..f7796d1301e4 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1773,11 +1773,11 @@ static int hns_nic_set_features(struct net_device *netdev,
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
+		if (features & netdev_general_tso_features)
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6)) {
+		if (features & netdev_general_tso_features) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
@@ -2163,8 +2163,7 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
 	} else {
 		priv->ops.get_rxd_bnum = get_v2rx_desc_bnum;
-		if ((netdev->features & NETIF_F_TSO) ||
-		    (netdev->features & NETIF_F_TSO6)) {
+		if (netdev->features & netdev_general_tso_features) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* This chip only support 7*4096 */
@@ -2346,7 +2345,7 @@ static int hns_nic_dev_probe(struct platform_device *pdev)
 					   NETIF_F_RXCSUM_BIT, NETIF_F_SG_BIT,
 					   NETIF_F_GSO_BIT, NETIF_F_GRO_BIT,
 					   NETIF_F_TSO_BIT, NETIF_F_TSO6_BIT);
-		ndev->vlan_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		ndev->vlan_features |= netdev_general_tso_features;
 		ndev->max_mtu = MAC_MAX_MTU_V2 -
 				(ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN);
 		break;
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 424ba4a1870c..bcbf365a7596 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -872,7 +872,7 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 					   set_attr, clr_attr, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+				dev->features &= ~netdev_general_tso_features;
 			rc1 = -EIO;
 
 		} else {
@@ -901,7 +901,7 @@ static int ibmveth_set_features(struct net_device *dev,
 {
 	struct ibmveth_adapter *adapter = netdev_priv(dev);
 	int rx_csum = !!(features & NETIF_F_RXCSUM);
-	int large_send = !!(features & (NETIF_F_TSO | NETIF_F_TSO6));
+	int large_send = !!(features & netdev_general_tso_features);
 	int rc1 = 0, rc2 = 0;
 
 	if (rx_csum != adapter->rx_csum) {
@@ -915,8 +915,7 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
 		if (rc2 && !adapter->large_send)
-			dev->features =
-				features & ~(NETIF_F_TSO | NETIF_F_TSO6);
+			dev->features = features & ~netdev_general_tso_features;
 	}
 
 	return rc1 ? rc1 : rc2;
@@ -1693,7 +1692,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	/* If running older firmware, TSO should not be enabled by default */
 	if (ret == H_SUCCESS && (ret_attr & IBMVETH_ILLAN_LRG_SND_SUPPORT) &&
 	    !old_large_send) {
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev->hw_features |= netdev_general_tso_features;
 		netdev->features |= netdev->hw_features;
 	} else {
 		netdev->hw_features |= NETIF_F_TSO;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index f716cefb46b4..076b04b515f1 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5302,20 +5302,17 @@ static void e1000_watchdog_task(struct work_struct *work)
 				case SPEED_10:
 				case SPEED_100:
 					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
+					netdev->features &= ~netdev_general_tso_features;
 					break;
 				case SPEED_1000:
-					netdev->features |= NETIF_F_TSO;
-					netdev->features |= NETIF_F_TSO6;
+					netdev->features |= netdev_general_tso_features;
 					break;
 				default:
 					/* oops */
 					break;
 				}
 				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~NETIF_F_TSO;
-					netdev->features &= ~NETIF_F_TSO6;
+					netdev->features &= ~netdev_general_tso_features;
 				}
 			}
 
@@ -7319,7 +7316,7 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t changed = features ^ netdev->features;
 	netdev_features_t changeable;
 
-	if (changed & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (changed & netdev_general_tso_features)
 		adapter->flags |= FLAG_TSO_FORCE;
 
 	netdev_features_zero(changeable);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c32b5f170cd6..98501284e3aa 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3327,7 +3327,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	netdev_hw_features_set_set(dev, NETIF_F_SG_BIT, NETIF_F_IP_CSUM_BIT,
 				   NETIF_F_IPV6_CSUM_BIT);
 	if (mdev->LSO_support)
-		dev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		dev->hw_features |= netdev_general_tso_features;
 
 	if (mdev->dev->caps.tunnel_offload_mode ==
 	    MLX4_TUNNEL_OFFLOAD_MODE_VXLAN) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 0106f759b3b3..3faf52d7b1d8 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1689,8 +1689,8 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
 	}
 
-	if (changed & (NETIF_F_TSO | NETIF_F_TSO6)) {
-		if (features & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (changed & netdev_general_tso_features) {
+		if (features & netdev_general_tso_features)
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					      NFP_NET_CFG_CTRL_LSO;
 		else
@@ -2370,7 +2370,7 @@ static void nfp_net_netdev_init(struct nfp_net *nn)
 	}
 	if ((nn->cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    nn->cap & NFP_NET_CFG_CTRL_LSO2) {
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev->hw_features |= netdev_general_tso_features;
 		nn->dp.ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					 NFP_NET_CFG_CTRL_LSO;
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index fd5cb2138520..7c749e41a2d6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -350,7 +350,7 @@ int nfp_repr_init(struct nfp_app *app, struct net_device *netdev,
 		netdev->hw_features |= NETIF_F_SG;
 	if ((repr_cap & NFP_NET_CFG_CTRL_LSO && nn->fw_ver.major > 2) ||
 	    repr_cap & NFP_NET_CFG_CTRL_LSO2)
-		netdev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		netdev->hw_features |= netdev_general_tso_features;
 	if (repr_cap & NFP_NET_CFG_CTRL_RSS_ANY)
 		netdev->hw_features |= NETIF_F_RXHASH;
 	if (repr_cap & NFP_NET_CFG_CTRL_VXLAN) {
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 5f950dfed66c..5c49282a99d7 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1877,8 +1877,8 @@ netxen_tso_check(struct net_device *netdev,
 		vlan_oob = 1;
 	}
 
-	if ((netdev->features & (NETIF_F_TSO | NETIF_F_TSO6)) &&
-			skb_shinfo(skb)->gso_size > 0) {
+	if ((netdev->features & netdev_general_tso_features) &&
+	    skb_shinfo(skb)->gso_size > 0) {
 
 		hdr_len = skb_tcp_all_headers(skb);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index a68d14f6068f..a03d38d4ccfc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1048,7 +1048,7 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 					  NETIF_F_IPV6_CSUM_BIT);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			features &= ~(NETIF_F_TSO | NETIF_F_TSO6);
+			features &= ~netdev_general_tso_features;
 		adapter->rx_csum = 0;
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index c118ab110fd5..4bafef069002 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -2287,8 +2287,8 @@ qlcnic_setup_netdev(struct qlcnic_adapter *adapter, struct net_device *netdev)
 				     NETIF_F_HIGHDMA_BIT);
 
 	if (QLCNIC_IS_TSO_CAPABLE(adapter)) {
-		netdev->features |= (NETIF_F_TSO | NETIF_F_TSO6);
-		netdev->vlan_features |= (NETIF_F_TSO | NETIF_F_TSO6);
+		netdev->features |= netdev_general_tso_features;
+		netdev->vlan_features |= netdev_general_tso_features;
 	}
 
 	if (qlcnic_vlan_tx_check(adapter))
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index e44a553398f2..727792b6cf26 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5268,7 +5268,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * enable them. Use at own risk!
 	 */
 	if (rtl_chip_supports_csum_v2(tp)) {
-		dev->hw_features |= NETIF_F_SG | NETIF_F_TSO | NETIF_F_TSO6;
+		dev->hw_features |= NETIF_F_SG;
+		dev->hw_features |= netdev_general_tso_features;
 		netif_set_tso_max_size(dev, RTL_GSO_MAX_SIZE_V2);
 		netif_set_tso_max_segs(dev, RTL_GSO_MAX_SEGS_V2);
 	} else {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f4e7007e1f0c..c60b47316770 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -7128,7 +7128,7 @@ int stmmac_dvr_probe(struct device *device,
 	}
 
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
-		ndev->hw_features |= NETIF_F_TSO | NETIF_F_TSO6;
+		ndev->hw_features |= netdev_general_tso_features;
 		if (priv->plat->has_gmac4)
 			ndev->hw_features |= NETIF_F_GSO_UDP_L4;
 		priv->tso = true;
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
index cfe715019699..40afd3d89ecb 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-common.c
@@ -179,8 +179,7 @@ static int xlgmac_init(struct xlgmac_pdata *pdata)
 
 	/* Set device features */
 	if (pdata->hw_feat.tso) {
-		netdev->hw_features = NETIF_F_TSO;
-		netdev->hw_features |= NETIF_F_TSO6;
+		netdev->hw_features = netdev_general_tso_features;
 		netdev->hw_features |= NETIF_F_SG;
 		netdev->hw_features |= netdev_ip_csum_features;
 	} else if (pdata->hw_feat.tx_coe) {
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index c82465160e4d..ab78a12218bc 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -968,7 +968,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (feature_mask & netdev_general_tso_features)
 		netdev_features_set_set(features, NETIF_F_GRO_BIT,
 					NETIF_F_LRO_BIT);
 	else
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0ec2e7d1d757..d5be3fe5d140 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3726,8 +3726,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 			netdev_active_features_set_set(dev, NETIF_F_HW_CSUM_BIT,
 						       NETIF_F_SG_BIT);
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_GSO)) {
-			dev->hw_features |= NETIF_F_TSO
-				| NETIF_F_TSO_ECN | NETIF_F_TSO6;
+			dev->hw_features |= netdev_general_tso_features;
+			dev->hw_features |= NETIF_F_TSO_ECN;
 		}
 		/* Individual feature bits: what can host handle? */
 		if (virtio_has_feature(vdev, VIRTIO_NET_F_HOST_TSO4))
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 2d4436cbcb47..83950ce159f9 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1126,7 +1126,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 		card->dev->vlan_features |= NETIF_F_TSO6;
 	}
 
-	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6)) {
+	if (card->dev->hw_features & netdev_general_tso_features) {
 		card->dev->needed_headroom = sizeof(struct qeth_hdr_tso);
 		netif_keep_dst(card->dev);
 		netif_set_tso_max_size(card->dev,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 430856ad17ea..d42303884636 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1910,7 +1910,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 				NETIF_F_HW_VLAN_CTAG_RX;
 
 	netif_keep_dst(card->dev);
-	if (card->dev->hw_features & (NETIF_F_TSO | NETIF_F_TSO6))
+	if (card->dev->hw_features & netdev_general_tso_features)
 		netif_set_tso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
-- 
2.33.0

