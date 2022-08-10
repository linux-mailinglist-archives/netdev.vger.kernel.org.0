Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A285F58E55C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiHJDO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbiHJDN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:57 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3844382F95
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:52 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgy5fzsz1M8lr;
        Wed, 10 Aug 2022 11:10:38 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:49 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 31/36] treewide: use netdev_features_intersects helpers
Date:   Wed, 10 Aug 2022 11:06:19 +0800
Message-ID: <20220810030624.34711-32-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220810030624.34711-1-shenjian15@huawei.com>
References: <20220810030624.34711-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the inersect check expressions of features by
netdev_features_intersects helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      |  2 +-
 drivers/net/ethernet/asix/ax88796c_main.c     |  4 ++--
 drivers/net/ethernet/broadcom/bcmsysport.c    |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 10 +++++-----
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  8 +++++---
 .../net/ethernet/freescale/gianfar_ethtool.c  |  2 +-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c |  6 +++---
 drivers/net/ethernet/ibm/ibmveth.c            |  3 ++-
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 20 +++++++++----------
 drivers/net/ethernet/intel/ice/ice_main.c     | 14 ++++++-------
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  8 ++++----
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 drivers/net/ethernet/nvidia/forcedeth.c       |  8 ++++----
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |  2 +-
 drivers/net/ethernet/qualcomm/emac/emac.c     |  2 +-
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  |  2 +-
 drivers/net/ethernet/sfc/efx_common.c         |  4 ++--
 drivers/net/ethernet/sfc/siena/efx_common.c   |  4 ++--
 drivers/net/tap.c                             |  4 ++--
 drivers/net/veth.c                            |  2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  8 ++++----
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  3 ++-
 drivers/s390/net/qeth_core_main.c             |  6 ++++--
 drivers/s390/net/qeth_l2_main.c               |  2 +-
 drivers/s390/net/qeth_l3_main.c               |  2 +-
 net/8021q/vlan.h                              |  3 ++-
 net/8021q/vlan_dev.c                          |  4 ++--
 net/core/dev.c                                | 11 +++++-----
 net/ethtool/ioctl.c                           |  5 +++--
 net/tls/tls_device.c                          |  2 +-
 34 files changed, 88 insertions(+), 78 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 90e22972fd81..f6015c49363e 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2206,7 +2206,7 @@ static netdev_features_t xgbe_fix_features(struct net_device *netdev,
 		netdev_features_set(&features, vxlan_base);
 	}
 
-	if (features & netdev_ip_csum_features) {
+	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
 		if (!netdev_feature_test(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, features)) {
 			netdev_notice(netdev,
 				      "forcing tx udp tunnel checksumming on\n");
diff --git a/drivers/net/ethernet/asix/ax88796c_main.c b/drivers/net/ethernet/asix/ax88796c_main.c
index 66e428e25b7d..27f48743c72f 100644
--- a/drivers/net/ethernet/asix/ax88796c_main.c
+++ b/drivers/net/ethernet/asix/ax88796c_main.c
@@ -926,12 +926,12 @@ ax88796c_set_features(struct net_device *ndev, netdev_features_t features)
 	struct ax88796c_device *ax_local = to_ax88796c_device(ndev);
 	netdev_features_t changed = netdev_active_features_xor(ndev, features);
 
-	if (!(changed & ax88796c_features))
+	if (!netdev_features_intersects(changed, ax88796c_features))
 		return 0;
 
 	ndev->features = features;
 
-	if (changed & ax88796c_features)
+	if (netdev_features_intersects(changed, ax88796c_features))
 		ax88796c_set_csums(ax_local);
 
 	return 0;
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index 36234f731076..4f8db6155c57 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -172,7 +172,7 @@ static void bcm_sysport_set_tx_csum(struct net_device *dev,
 	/* Hardware transmit checksum requires us to enable the Transmit status
 	 * block prepended to the packet contents
 	 */
-	priv->tsb_en = !!(wanted & tx_csum_features);
+	priv->tsb_en = netdev_features_intersects(tx_csum_features, wanted);
 	reg = tdma_readl(priv, TDMA_CONTROL);
 	if (priv->tsb_en)
 		reg |= tdma_control_bit(priv, TSB_EN);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index dd744764cf4b..35fb5b726df1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1740,7 +1740,7 @@ static inline struct sk_buff *bnxt_tpa_end(struct bnxt *bp,
 		skb_set_hash(skb, tpa_info->rss_hash, tpa_info->hash_type);
 
 	if ((tpa_info->flags2 & RX_CMP_FLAGS2_META_FORMAT_VLAN) &&
-	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
+	    netdev_active_features_intersects(skb->dev, BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		__be16 vlan_proto = htons(tpa_info->metadata >>
 					  RX_CMP_FLAGS2_METADATA_TPID_SFT);
 		u16 vtag = tpa_info->metadata & RX_CMP_FLAGS2_METADATA_TCI_MASK;
@@ -2010,7 +2010,7 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 
 	if ((rxcmp1->rx_cmp_flags2 &
 	     cpu_to_le32(RX_CMP_FLAGS2_META_FORMAT_VLAN)) &&
-	    (skb->dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)) {
+	    netdev_active_features_intersects(skb->dev, BNXT_HW_FEATURE_VLAN_ALL_RX)) {
 		u32 meta_data = le32_to_cpu(rxcmp1->rx_cmp_meta_data);
 		u16 vtag = meta_data & RX_CMP_FLAGS2_METADATA_TCI_MASK;
 		__be16 vlan_proto = htons(meta_data >>
@@ -11200,7 +11200,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	 */
 	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
-		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(&features,
 					      BNXT_HW_FEATURE_VLAN_ALL_RX);
 		else if (vlan_features)
@@ -11232,7 +11232,7 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	if (bp->flags & BNXT_FLAG_NO_AGG_RINGS)
 		flags &= ~BNXT_FLAG_TPA;
 
-	if (features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+	if (netdev_features_intersects(features, BNXT_HW_FEATURE_VLAN_ALL_RX))
 		flags |= BNXT_FLAG_STRIP_VLAN;
 
 	if (netdev_feature_test(NETIF_F_NTUPLE_BIT, features))
@@ -13712,7 +13712,7 @@ static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	bnxt_init_dflt_coal(bp);
 
-	if (dev->hw_features & BNXT_HW_FEATURE_VLAN_ALL_RX)
+	if (netdev_hw_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 		bp->flags |= BNXT_FLAG_STRIP_VLAN;
 
 	rc = bnxt_init_int_mode(bp);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 165b6c9c0c41..a552e5a5a353 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -2440,8 +2440,9 @@ static int dpaa2_eth_set_features(struct net_device *net_dev,
 			return err;
 	}
 
-	if (changed & netdev_ip_csum_features) {
-		enable = !!(features & netdev_ip_csum_features);
+	if (netdev_features_intersects(changed, netdev_ip_csum_features)) {
+		enable = netdev_features_intersects(features,
+						    netdev_ip_csum_features);
 		err = dpaa2_eth_set_tx_csum(priv, enable);
 		if (err)
 			return err;
@@ -4702,7 +4703,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 		goto err_csum;
 
 	err = dpaa2_eth_set_tx_csum(priv,
-				    !!(net_dev->features & netdev_ip_csum_features));
+				    netdev_active_features_intersects(net_dev,
+								      netdev_ip_csum_features));
 	if (err)
 		goto err_csum;
 
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 01e9e7aba739..997a1551dce6 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -512,7 +512,7 @@ int gfar_set_features(struct net_device *dev, netdev_features_t features)
 	struct gfar_private *priv = netdev_priv(dev);
 	int err = 0;
 
-	if (!(changed & netdev_ctag_vlan_offload_features) &&
+	if (!netdev_features_intersects(changed, netdev_ctag_vlan_offload_features) &&
 	    !netdev_feature_test(NETIF_F_RXCSUM_BIT, changed))
 		return 0;
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index dbce348ca438..cba1c2cc4495 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1773,11 +1773,11 @@ static int hns_nic_set_features(struct net_device *netdev,
 
 	switch (priv->enet_ver) {
 	case AE_VERSION_1:
-		if (features & netdev_general_tso_features)
+		if (netdev_features_intersects(features, netdev_general_tso_features))
 			netdev_info(netdev, "enet v1 do not support tso!\n");
 		break;
 	default:
-		if (features & netdev_general_tso_features) {
+		if (netdev_features_intersects(features, netdev_general_tso_features)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* The chip only support 7*4096 */
@@ -2166,7 +2166,7 @@ static void hns_nic_set_priv_ops(struct net_device *netdev)
 		priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tx;
 	} else {
 		priv->ops.get_rxd_bnum = get_v2rx_desc_bnum;
-		if (netdev->features & netdev_general_tso_features) {
+		if (netdev_active_features_intersects(netdev, netdev_general_tso_features)) {
 			priv->ops.fill_desc = fill_tso_desc;
 			priv->ops.maybe_stop_tx = hns_nic_maybe_stop_tso;
 			/* This chip only support 7*4096 */
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 1f4e5a7d1f95..bb581f978234 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -904,7 +904,8 @@ static int ibmveth_set_features(struct net_device *dev,
 {
 	struct ibmveth_adapter *adapter = netdev_priv(dev);
 	int rx_csum = netdev_feature_test(NETIF_F_RXCSUM_BIT, features);
-	int large_send = !!(features & netdev_general_tso_features);
+	int large_send = netdev_features_intersects(features,
+						    netdev_general_tso_features);
 	int rc1 = 0, rc2 = 0;
 
 	if (rx_csum != adapter->rx_csum) {
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 09bd2505b39a..79f9363ec939 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4884,7 +4884,7 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 	if (buf->tcp_ipv6_chksum || buf->udp_ipv6_chksum)
 		netdev_hw_feature_add(adapter->netdev, NETIF_F_IPV6_CSUM_BIT);
 
-	if ((adapter->netdev->features & netdev_ip_csum_features))
+	if (netdev_active_features_intersects(adapter->netdev, netdev_ip_csum_features))
 		netdev_hw_feature_add(adapter->netdev, NETIF_F_RXCSUM_BIT);
 
 	if (buf->large_tx_ipv4)
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index c164802ab58d..c6fbadfb8715 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -7327,12 +7327,12 @@ static int e1000_set_features(struct net_device *netdev,
 	netdev_features_t changed = netdev_active_features_xor(netdev, features);
 	netdev_features_t changeable;
 
-	if (changed & netdev_general_tso_features)
+	if (netdev_features_intersects(changed, netdev_general_tso_features))
 		adapter->flags |= FLAG_TSO_FORCE;
 
 	netdev_features_zero(&changeable);
 	netdev_features_set_array(&e1000_changable_feature_set, &changeable);
-	if (!(changed & changeable))
+	if (!netdev_features_intersects(changed, changeable))
 		return 0;
 
 	if (netdev_feature_test(NETIF_F_RXFCS_BIT, changed)) {
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b59cc9891fce..09711e527bd3 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2125,20 +2125,20 @@ iavf_set_vlan_offload_features(struct iavf_adapter *adapter,
 	 * ETH_P_8021Q so an ethertype is specified if disabling insertion and
 	 * stripping.
 	 */
-	if (features & netdev_stag_vlan_offload_features)
+	if (netdev_features_intersects(features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (features & netdev_ctag_vlan_offload_features)
+	else if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
-	else if (prev_features & netdev_stag_vlan_offload_features)
+	else if (netdev_features_intersects(prev_features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (prev_features & netdev_ctag_vlan_offload_features)
+	else if (netdev_features_intersects(prev_features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
 	else
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!(features & netdev_rx_vlan_features))
+	if (!netdev_features_intersects(features, netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!(features & netdev_tx_vlan_features))
+	if (!netdev_features_intersects(features, netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (VLAN_ALLOWED(adapter)) {
@@ -4241,8 +4241,8 @@ static int iavf_set_features(struct net_device *netdev,
 	struct iavf_adapter *adapter = netdev_priv(netdev);
 
 	/* trigger update on any VLAN feature change */
-	if ((netdev->features & NETIF_VLAN_OFFLOAD_FEATURES) ^
-	    (features & NETIF_VLAN_OFFLOAD_FEATURES))
+	if (netdev_active_features_intersects(netdev, NETIF_VLAN_OFFLOAD_FEATURES) ^
+	    netdev_features_intersects(features, NETIF_VLAN_OFFLOAD_FEATURES))
 		iavf_set_vlan_offload_features(adapter, netdev->features,
 					       features);
 
@@ -4536,8 +4536,8 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 		netdev_feature_del(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				   &requested_features);
 
-	if ((requested_features & netdev_ctag_vlan_offload_features) &&
-	    (requested_features & netdev_stag_vlan_offload_features) &&
+	if (netdev_features_intersects(requested_features, netdev_ctag_vlan_offload_features) &&
+	    netdev_features_intersects(requested_features, netdev_stag_vlan_offload_features) &&
 	    adapter->vlan_v2_caps.offloads.ethertype_match ==
 	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
 		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 088719732394..a58669228d64 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5821,8 +5821,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 		}
 	}
 
-	if ((features & netdev_ctag_vlan_offload_features) &&
-	    (features & netdev_stag_vlan_offload_features)) {
+	if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features) &&
+	    netdev_features_intersects(features, netdev_stag_vlan_offload_features)) {
 		netdev_warn(netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
 		netdev_features_clear(&features,
 				      netdev_stag_vlan_offload_features);
@@ -5850,14 +5850,14 @@ ice_set_vlan_offload_features(struct ice_vsi *vsi, netdev_features_t features)
 
 	vlan_ops = ice_get_compat_vsi_vlan_ops(vsi);
 
-	if (features & netdev_stag_vlan_offload_features)
+	if (netdev_features_intersects(features, netdev_stag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021AD;
-	else if (features & netdev_ctag_vlan_offload_features)
+	else if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
 		vlan_ethertype = ETH_P_8021Q;
 
-	if (!(features & netdev_rx_vlan_features))
+	if (!netdev_features_intersects(features, netdev_rx_vlan_features))
 		enable_stripping = false;
-	if (!(features & netdev_tx_vlan_features))
+	if (!netdev_features_intersects(features, netdev_tx_vlan_features))
 		enable_insertion = false;
 
 	if (enable_stripping)
@@ -5893,7 +5893,7 @@ ice_set_vlan_filtering_features(struct ice_vsi *vsi, netdev_features_t features)
 	/* support Single VLAN Mode (SVM) and Double VLAN Mode (DVM) by checking
 	 * if either bit is set
 	 */
-	if (features & netdev_vlan_filter_features)
+	if (netdev_features_intersects(features, netdev_vlan_filter_features))
 		err = vlan_ops->ena_rx_filtering(vsi);
 	else
 		err = vlan_ops->dis_rx_filtering(vsi);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 9da8a0ebb383..b5e3180a05f4 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4348,7 +4348,7 @@ static int sky2_set_features(struct net_device *dev, netdev_features_t features)
 	if (netdev_feature_test(NETIF_F_RXHASH_BIT, changed))
 		rx_set_rss(dev, features);
 
-	if (changed & netdev_ctag_vlan_offload_features)
+	if (netdev_features_intersects(changed, netdev_ctag_vlan_offload_features))
 		sky2_vlan_mode(dev, features);
 
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 1c1637445980..9bad2a77bd54 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4482,7 +4482,8 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
+	    (netdev_features_intersects(features, NETIF_F_CSUM_MASK) ||
+	     netdev_features_intersects(features, NETIF_F_GSO_MASK)))
 		return mlx5e_tunnel_features_check(priv, skb, features);
 
 	return features;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 8bcf75169a93..1ff44d5a2c7c 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1680,15 +1680,15 @@ static int nfp_net_set_features(struct net_device *netdev,
 			new_ctrl &= ~NFP_NET_CFG_CTRL_RXCSUM_ANY;
 	}
 
-	if (changed & netdev_ip_csum_features) {
-		if (features & netdev_ip_csum_features)
+	if (netdev_features_intersects(changed, netdev_ip_csum_features)) {
+		if (netdev_features_intersects(features, netdev_ip_csum_features))
 			new_ctrl |= NFP_NET_CFG_CTRL_TXCSUM;
 		else
 			new_ctrl &= ~NFP_NET_CFG_CTRL_TXCSUM;
 	}
 
-	if (changed & netdev_general_tso_features) {
-		if (features & netdev_general_tso_features)
+	if (netdev_features_intersects(changed, netdev_general_tso_features)) {
+		if (netdev_features_intersects(features, netdev_general_tso_features))
 			new_ctrl |= nn->cap & NFP_NET_CFG_CTRL_LSO2 ?:
 					      NFP_NET_CFG_CTRL_LSO;
 		else
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index acee5eeb4d2e..346bc59ce40d 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -245,7 +245,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	lower_dev = repr->dst->u.port_info.lower_dev;
 
 	lower_features = lower_dev->features;
-	if (lower_features & netdev_ip_csum_features)
+	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 
 	features = netdev_intersect_features(features, lower_features);
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 7fd4f3519414..b4a2fc027475 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -4931,7 +4931,7 @@ static netdev_features_t nv_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
 	/* vlan is dependent on rx checksum offload */
-	if (features & netdev_ctag_vlan_offload_features)
+	if (netdev_features_intersects(features, netdev_ctag_vlan_offload_features))
 		netdev_feature_add(NETIF_F_RXCSUM_BIT, &features);
 
 	return features;
@@ -4985,7 +4985,7 @@ static int nv_set_features(struct net_device *dev, netdev_features_t features)
 		spin_unlock_irq(&np->lock);
 	}
 
-	if (changed & netdev_ctag_vlan_offload_features)
+	if (netdev_features_intersects(changed, netdev_ctag_vlan_offload_features))
 		nv_vlan_mode(dev, features);
 
 	return 0;
@@ -6127,8 +6127,8 @@ static int nv_probe(struct pci_dev *pci_dev, const struct pci_device_id *id)
 		 netdev_active_feature_test(dev, NETIF_F_HIGHDMA_BIT) ? "highdma " : "",
 		 (netdev_active_feature_test(dev, NETIF_F_IP_CSUM_BIT) ||
 		  netdev_active_feature_test(dev, NETIF_F_SG_BIT)) ? "csum " : "",
-		 dev->features & netdev_ctag_vlan_offload_features ?
-			"vlan " : "",
+		 netdev_active_features_intersects(dev, netdev_ctag_vlan_offload_features) ?
+		 "vlan " : "",
 		 netdev_active_feature_test(dev, NETIF_F_LOOPBACK_BIT) ?
 			"loopback " : "",
 		 id->driver_data & DEV_HAS_POWER_CNTRL ? "pwrctl " : "",
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index 30bc427dba46..707fb8a65be1 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -1886,7 +1886,7 @@ netxen_tso_check(struct net_device *netdev,
 		vlan_oob = 1;
 	}
 
-	if ((netdev->features & netdev_general_tso_features) &&
+	if (netdev_active_features_intersects(netdev, netdev_general_tso_features) &&
 	    skb_shinfo(skb)->gso_size > 0) {
 
 		hdr_len = skb_tcp_all_headers(skb);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 3c85eb122448..7b71c2e6f659 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -182,7 +182,7 @@ static int emac_set_features(struct net_device *netdev,
 	/* We only need to reprogram the hardware if the VLAN tag features
 	 * have changed, and if it's already running.
 	 */
-	if (!(changed & netdev_ctag_vlan_offload_features))
+	if (!netdev_features_intersects(changed, netdev_ctag_vlan_offload_features))
 		return 0;
 
 	if (!netif_running(netdev))
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index 2595fe837c78..22777ec41f47 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -437,7 +437,7 @@ static void rmnet_map_v4_checksum_uplink_packet(struct sk_buff *skb,
 	ul_header = (struct rmnet_map_ul_csum_header *)
 		    skb_push(skb, sizeof(struct rmnet_map_ul_csum_header));
 
-	if (unlikely(!(orig_dev->features & netdev_ip_csum_features)))
+	if (unlikely(!netdev_active_features_intersects(orig_dev, netdev_ip_csum_features)))
 		goto sw_csum;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index a4366c23b50f..fdde83bef88e 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1361,7 +1361,7 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 	struct efx_nic *efx = efx_netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (features & NETIF_F_GSO_MASK)
+		if (netdev_features_intersects(features, NETIF_F_GSO_MASK))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
@@ -1369,7 +1369,7 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			    EFX_TSO2_MAX_HDRLEN)
 				netdev_features_clear(&features,
 						      NETIF_F_GSO_MASK);
-		if (features & netdev_csum_gso_features_mask)
+		if (netdev_features_intersects(features, netdev_csum_gso_features_mask))
 			if (!efx_can_encap_offloads(efx, skb))
 				netdev_features_clear(&features,
 						      netdev_csum_gso_features_mask);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 6f547c54e3f1..7eaa2fe9dc13 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1374,7 +1374,7 @@ netdev_features_t efx_siena_features_check(struct sk_buff *skb,
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (features & NETIF_F_GSO_MASK)
+		if (netdev_features_intersects(features, NETIF_F_GSO_MASK))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
@@ -1382,7 +1382,7 @@ netdev_features_t efx_siena_features_check(struct sk_buff *skb,
 			    EFX_TSO2_MAX_HDRLEN)
 				netdev_features_clear(&features,
 						      (NETIF_F_GSO_MASK));
-		if (features & netdev_csum_gso_features_mask)
+		if (netdev_features_intersects(features, netdev_csum_gso_features_mask))
 			if (!efx_can_encap_offloads(efx, skb))
 				netdev_features_clear(&features,
 						      netdev_csum_gso_features_mask);
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 67bfe9cbc573..1ba49051308b 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -382,7 +382,7 @@ rx_handler_result_t tap_handle_frame(struct sk_buff **pskb)
 		 *	  check, we either support them all or none.
 		 */
 		if (skb->ip_summed == CHECKSUM_PARTIAL &&
-		    !(features & NETIF_F_CSUM_MASK) &&
+		    !netdev_features_intersects(features, NETIF_F_CSUM_MASK) &&
 		    skb_checksum_help(skb)) {
 			drop_reason = SKB_DROP_REASON_SKB_CSUM;
 			goto drop;
@@ -977,7 +977,7 @@ static int set_offload(struct tap_queue *q, unsigned long arg)
 	 * When user space turns off TSO, we turn off GSO/LRO so that
 	 * user-space will not receive TSO frames.
 	 */
-	if (feature_mask & netdev_general_tso_features)
+	if (netdev_features_intersects(feature_mask, netdev_general_tso_features))
 		netdev_features_set_array(&tap_rx_offload_feature_set, &features);
 	else
 		netdev_features_clear_array(&tap_rx_offload_feature_set, &features);
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ec210e5586f4..c47a3cebc1bc 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -305,7 +305,7 @@ static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
 					 const struct net_device *rcv,
 					 const struct sk_buff *skb)
 {
-	return !(dev->features & NETIF_F_ALL_TSO) ||
+	return !netdev_active_features_intersects(dev, NETIF_F_ALL_TSO) ||
 		(skb->destructor == sock_wfree &&
 		 (netdev_active_feature_test(rcv, NETIF_F_GRO_FRAGLIST_BIT) ||
 		  netdev_active_feature_test(rcv, NETIF_F_GRO_UDP_FWD_BIT)));
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 8d1ba53fec93..797d0a75929e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -422,12 +422,12 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_zero(&tun_offload_mask);
 	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_BIT, &tun_offload_mask);
 	netdev_feature_add(NETIF_F_GSO_UDP_TUNNEL_CSUM_BIT, &tun_offload_mask);
-	udp_tun_enabled = (netdev->features & tun_offload_mask) != 0;
+	udp_tun_enabled = netdev_active_features_intersects(netdev, tun_offload_mask);
 
 	if (netdev_feature_test(NETIF_F_RXCSUM_BIT, changed) ||
 	    netdev_feature_test(NETIF_F_LRO_BIT, changed) ||
 	    netdev_feature_test(NETIF_F_HW_VLAN_CTAG_RX_BIT, changed) ||
-	    changed & tun_offload_mask) {
+	    netdev_features_intersects(changed, tun_offload_mask)) {
 		if (netdev_feature_test(NETIF_F_RXCSUM_BIT, features))
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXCSUM;
@@ -450,11 +450,11 @@ int vmxnet3_set_features(struct net_device *netdev, netdev_features_t features)
 			adapter->shared->devRead.misc.uptFeatures &=
 			~UPT1_F_RXVLAN;
 
-		if ((features & tun_offload_mask) != 0) {
+		if (netdev_features_intersects(features, tun_offload_mask)) {
 			vmxnet3_enable_encap_offloads(netdev, features);
 			adapter->shared->devRead.misc.uptFeatures |=
 			UPT1_F_RXINNEROFLD;
-		} else if ((features & tun_offload_mask) == 0 &&
+		} else if (!netdev_features_intersects(features, tun_offload_mask) &&
 			   udp_tun_enabled) {
 			vmxnet3_disable_encap_offloads(netdev);
 			adapter->shared->devRead.misc.uptFeatures &=
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 6ac083a84597..4312bcf2d70a 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -54,7 +54,8 @@ static u16 iwl_mvm_tx_csum_pre_bz(struct iwl_mvm *mvm, struct sk_buff *skb,
 		goto out;
 
 	/* We do not expect to be requested to csum stuff we do not support */
-	if (WARN_ONCE(!(mvm->hw->netdev_features & IWL_TX_CSUM_NETIF_FLAGS) ||
+	if (WARN_ONCE(!netdev_features_intersects(mvm->hw->netdev_features,
+						  IWL_TX_CSUM_NETIF_FLAGS) ||
 		      (skb->protocol != htons(ETH_P_IP) &&
 		       skb->protocol != htons(ETH_P_IPV6)),
 		      "No support for requested checksum\n")) {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 1a181b2de48d..99f7ad47dc19 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6852,9 +6852,11 @@ static void qeth_check_restricted_features(struct qeth_card *card,
 	if (!card->info.has_lp2lp_cso_v4)
 		netdev_feature_add(NETIF_F_IP_CSUM_BIT, &ipv4_features);
 
-	if ((changed & ipv6_features) && !(actual & ipv6_features))
+	if (netdev_features_intersects(changed, ipv6_features) &&
+	    !netdev_features_intersects(actual, ipv6_features))
 		qeth_flush_local_addrs6(card);
-	if ((changed & ipv4_features) && !(actual & ipv4_features))
+	if (netdev_features_intersects(changed, ipv4_features) &&
+	    !netdev_features_intersects(actual, ipv4_features))
 		qeth_flush_local_addrs4(card);
 }
 
diff --git a/drivers/s390/net/qeth_l2_main.c b/drivers/s390/net/qeth_l2_main.c
index 32926f3c90ed..f7c2dec0b325 100644
--- a/drivers/s390/net/qeth_l2_main.c
+++ b/drivers/s390/net/qeth_l2_main.c
@@ -1130,7 +1130,7 @@ static int qeth_l2_setup_netdev(struct qeth_card *card)
 		netdev_vlan_feature_add(card->dev, NETIF_F_TSO6_BIT);
 	}
 
-	if (card->dev->hw_features & netdev_general_tso_features) {
+	if (netdev_hw_features_intersects(card->dev, netdev_general_tso_features)) {
 		card->dev->needed_headroom = sizeof(struct qeth_hdr_tso);
 		netif_keep_dst(card->dev);
 		netif_set_tso_max_size(card->dev,
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index 4d0985f20050..bf7901815998 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1913,7 +1913,7 @@ static int qeth_l3_setup_netdev(struct qeth_card *card)
 				   netdev_ctag_vlan_offload_features);
 
 	netif_keep_dst(card->dev);
-	if (card->dev->hw_features & netdev_general_tso_features)
+	if (netdev_hw_features_intersects(card->dev, netdev_general_tso_features))
 		netif_set_tso_max_size(card->dev,
 				       PAGE_SIZE * (QETH_MAX_BUFFER_ELEMENTS(card) - 1));
 
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index e08bbe2ae55b..73c4a6595ace 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -112,7 +112,8 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 	netdev_features_set(&ret, NETIF_F_GSO_ENCAP_ALL);
 	ret &= real_dev->hw_enc_features;
 
-	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
+	if (netdev_features_intersects(ret, NETIF_F_GSO_ENCAP_ALL) &&
+	    netdev_features_intersects(ret, NETIF_F_CSUM_MASK)) {
 		netdev_features_clear(&ret, NETIF_F_CSUM_MASK);
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &ret);
 		return ret;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 56f9b0233d51..d13236621a40 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -582,7 +582,7 @@ static int vlan_dev_init(struct net_device *dev)
 	netdev_active_features_set(dev, dev->hw_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netif_inherit_tso_max(dev, real_dev);
-	if (dev->features & NETIF_F_VLAN_FEATURES)
+	if (netdev_active_features_intersects(dev, NETIF_F_VLAN_FEATURES))
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
 	dev->vlan_features = netdev_vlan_features_andnot(real_dev,
@@ -664,7 +664,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	/* Add HW_CSUM setting to preserve user ability to control
 	 * checksum offload on the vlan device.
 	 */
-	if (lower_features & netdev_ip_csum_features)
+	if (netdev_features_intersects(lower_features, netdev_ip_csum_features))
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 	features = netdev_intersect_features(features, lower_features);
 	tmp = netdev_features_or(NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
diff --git a/net/core/dev.c b/net/core/dev.c
index 7188932a2158..dc4cadf2e4df 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3644,7 +3644,7 @@ int skb_csum_hwoffload_help(struct sk_buff *skb,
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features))
 		return 0;
 
-	if (features & netdev_ip_csum_features) {
+	if (netdev_features_intersects(features, netdev_ip_csum_features)) {
 		switch (skb->csum_offset) {
 		case offsetof(struct tcphdr, check):
 		case offsetof(struct udphdr, check):
@@ -9609,13 +9609,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 
 	/* Fix illegal checksum combinations */
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, features) &&
-	    (features & netdev_ip_csum_features)) {
+	    netdev_features_intersects(features, netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
 		netdev_features_clear(&features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
-	if ((features & NETIF_F_ALL_TSO) &&
+	if (netdev_features_intersects(features, NETIF_F_ALL_TSO) &&
 	    !netdev_feature_test(NETIF_F_SG_BIT, features)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
 		netdev_features_clear(&features, NETIF_F_ALL_TSO);
@@ -9644,7 +9644,8 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	/* TSO ECN requires that TSO is present as well. */
 	tmp = NETIF_F_ALL_TSO;
 	netdev_feature_del(NETIF_F_TSO_ECN_BIT, &tmp);
-	if (!(features & tmp) && netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
+	if (!netdev_features_intersects(features, tmp) &&
+	    netdev_feature_test(NETIF_F_TSO_ECN_BIT, features))
 		netdev_feature_del(NETIF_F_TSO_ECN_BIT, &features);
 
 	/* Software GSO depends on SG. */
@@ -9655,7 +9656,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	}
 
 	/* GSO partial features require GSO partial be set */
-	if ((features & dev->gso_partial_features) &&
+	if (netdev_gso_partial_features_intersects(dev, features) &&
 	    !netdev_feature_test(NETIF_F_GSO_PARTIAL_BIT, features)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index c98b49d5eff1..f1ae7a4ade29 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -271,7 +271,7 @@ static int ethtool_get_one_feature(struct net_device *dev,
 	netdev_features_t mask = ethtool_get_feature_mask(ethcmd);
 	struct ethtool_value edata = {
 		.cmd = ethcmd,
-		.data = !!(dev->features & mask),
+		.data = netdev_active_features_intersects(dev, mask),
 	};
 
 	if (copy_to_user(useraddr, &edata, sizeof(edata)))
@@ -360,7 +360,8 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	changed &= eth_all_features;
 	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
-		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
+		return netdev_hw_features_intersects(dev, changed) ?
+			-EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_clear(dev, changed);
 	tmp = features & changed;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index c88fbe2e1cf5..361c9fe1e689 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -1403,7 +1403,7 @@ static int tls_dev_event(struct notifier_block *this, unsigned long event,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 
 	if (!dev->tlsdev_ops &&
-	    !(dev->features & netdev_tls_features))
+	    !netdev_active_features_intersects(dev, netdev_tls_features))
 		return NOTIFY_DONE;
 
 	switch (event) {
-- 
2.33.0

