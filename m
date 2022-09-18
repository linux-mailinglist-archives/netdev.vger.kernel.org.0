Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 985105BBD07
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiIRJuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIRJuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:18 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E67C514003
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc90ndTzmVKb;
        Sun, 18 Sep 2022 17:46:01 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:52 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 32/55] treewide: use netdev_features_and/mask helpers
Date:   Sun, 18 Sep 2022 09:43:13 +0000
Message-ID: <20220918094336.28958-33-shenjian15@huawei.com>
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

Replace the 'f1 = f2 & f3' features expressions by
netdev_features_and helpers, and replace the 'f1 &= f2'
features expressions by netdev_features_clear helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c               |  4 ++--
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  3 ++-
 .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  2 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 ++-
 .../ethernet/chelsio/cxgb4vf/cxgb4vf_main.c   |  3 ++-
 .../ethernet/fungible/funeth/funeth_main.c    |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c            |  7 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c     | 19 ++++++++++++-------
 .../ethernet/netronome/nfp/nfp_net_common.c   |  4 +++-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  2 +-
 drivers/net/hyperv/rndis_filter.c             |  2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  8 ++++----
 drivers/net/macsec.c                          |  7 ++++---
 drivers/net/macvlan.c                         | 11 ++++++-----
 drivers/net/net_failover.c                    |  6 ++++--
 drivers/net/team/team.c                       |  6 ++++--
 drivers/net/tun.c                             |  2 +-
 drivers/net/virtio_net.c                      |  4 +++-
 include/linux/if_vlan.h                       |  4 +++-
 include/linux/netdev_feature_helpers.h        |  5 ++++-
 net/8021q/vlan.h                              |  2 +-
 net/8021q/vlan_dev.c                          |  2 +-
 net/core/dev.c                                | 17 +++++++++--------
 net/ethtool/features.c                        |  3 ++-
 net/ethtool/ioctl.c                           | 10 +++++-----
 net/ipv4/af_inet.c                            |  2 +-
 net/ipv4/gre_offload.c                        |  2 +-
 net/ipv4/udp_offload.c                        |  2 +-
 net/ipv6/ip6_offload.c                        |  2 +-
 net/mac80211/iface.c                          |  3 ++-
 net/mpls/mpls_gso.c                           |  3 ++-
 33 files changed, 92 insertions(+), 64 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 6db8d834c3e4..769ae7a6b800 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1451,8 +1451,8 @@ static void bond_compute_features(struct bonding *bond)
 
 	if (!bond_has_slaves(bond))
 		goto done;
-	vlan_features &= NETIF_F_ALL_FOR_ALL;
-	mpls_features &= NETIF_F_ALL_FOR_ALL;
+	netdev_features_mask(vlan_features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_mask(mpls_features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 59658e99bdc3..558d6a2f4e0a 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7756,7 +7756,7 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
 		netdev_features_t tso;
 
-		tso = dev->hw_features & NETIF_F_ALL_TSO;
+		netdev_features_and(tso, dev->hw_features, NETIF_F_ALL_TSO);
 		netdev_vlan_features_set(dev, tso);
 	} else {
 		netdev_vlan_features_clear(dev, NETIF_F_ALL_TSO);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e4b12810148a..ce886feeefdc 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11192,7 +11192,8 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
+	netdev_features_and(vlan_features, features,
+			    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(features,
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index 3b7348ffc71d..a1d6279886a7 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3319,7 +3319,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					NETIF_F_IP_CSUM_BIT, NETIF_F_TSO_BIT,
 					NETIF_F_RXCSUM_BIT,
 					NETIF_F_HW_VLAN_CTAG_RX_BIT);
-		vlan_feat &= netdev->features;
+		netdev_features_mask(vlan_feat, netdev->features);
 		netdev_vlan_features_set(netdev, vlan_feat);
 
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index ec054538e224..a4b06645861a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6856,7 +6856,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
 					NETIF_F_IPV6_CSUM_BIT,
 					NETIF_F_HIGHDMA_BIT);
-		netdev->vlan_features = netdev->features & vlan_features;
+		netdev_vlan_features_and(netdev, netdev->features,
+					 vlan_features);
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index 1dc39903d87c..94f253feda79 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3082,7 +3082,8 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 					NETIF_F_IP_CSUM_BIT, NETIF_F_GRO_BIT,
 					NETIF_F_IPV6_CSUM_BIT,
 					NETIF_F_HIGHDMA_BIT);
-		netdev->vlan_features = netdev->features & vlan_features;
+		netdev_vlan_features_and(netdev, netdev->features,
+					 vlan_features);
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 57734fae1c1e..ea5863db61ed 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1785,7 +1785,7 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 
 	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
-	netdev->vlan_features = netdev->features & vlan_feat;
+	netdev_vlan_features_and(netdev, netdev->features, vlan_feat);
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 126444297e5d..9c6fb5e21cb4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4897,12 +4897,13 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 
 		netdev_features_zero(tmp);
 		/* disable features no longer supported */
-		adapter->netdev->features &= adapter->netdev->hw_features;
+		netdev_active_features_mask(adapter->netdev,
+					    adapter->netdev->hw_features);
 		/* turn on features now supported if previously enabled */
 		netdev_features_xor(tmp, old_hw_features,
 				    adapter->netdev->hw_features);
-		tmp &= adapter->netdev->hw_features;
-		tmp &= adapter->netdev->wanted_features;
+		netdev_features_mask(tmp, adapter->netdev->hw_features);
+		netdev_features_mask(tmp, adapter->netdev->wanted_features);
 		netdev_active_features_set(adapter->netdev, tmp);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7ee3a32d36e1..ec148c43c130 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5820,13 +5820,15 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
 	bool cur_ctag, cur_stag, req_ctag, req_stag;
 
-	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+	netdev_features_and(cur_vlan_fltr, netdev->features,
+			    NETIF_VLAN_FILTERING_FEATURES);
 	cur_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       cur_vlan_fltr);
 	cur_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				       cur_vlan_fltr);
 
-	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
+	netdev_features_and(req_vlan_fltr, features,
+			    NETIF_VLAN_FILTERING_FEATURES);
 	req_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       req_vlan_fltr);
 	req_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
@@ -5966,8 +5968,10 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	struct ice_vsi *vsi = np->vsi;
 	int err;
 
-	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
-	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
+	netdev_features_and(current_vlan_features, netdev->features,
+			    NETIF_VLAN_OFFLOAD_FEATURES);
+	netdev_features_and(requested_vlan_features, features,
+			    NETIF_VLAN_OFFLOAD_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
 	if (diff) {
@@ -5984,9 +5988,10 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 			return err;
 	}
 
-	current_vlan_features = netdev->features &
-		NETIF_VLAN_FILTERING_FEATURES;
-	requested_vlan_features = features & NETIF_VLAN_FILTERING_FEATURES;
+	netdev_features_and(current_vlan_features, netdev->features,
+			    NETIF_VLAN_FILTERING_FEATURES);
+	netdev_features_and(requested_vlan_features, features,
+			    NETIF_VLAN_FILTERING_FEATURES);
 	netdev_features_xor(diff, current_vlan_features,
 			    requested_vlan_features);
 	if (diff) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index eb96078ebff1..e2ae7c147e45 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1785,10 +1785,12 @@ static netdev_features_t
 nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		       netdev_features_t features)
 {
+	netdev_features_t feats;
 	u8 l4_hdr;
 
 	/* We can't do TSO over double tagged packets (802.1AD) */
-	features &= vlan_features_check(skb, features);
+	feats = vlan_features_check(skb, features);
+	netdev_features_mask(features, feats);
 
 	if (!skb->encapsulation)
 		return features;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 2c56ca19f25c..8a15ec010282 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -251,7 +251,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	features = netdev_intersect_features(features, lower_features);
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, tmp);
-	tmp &= old_features;
+	netdev_features_mask(tmp, old_features);
 	netdev_features_set(features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 8228e1d55e38..b97bbb07d06a 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1079,7 +1079,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 						NETIF_F_IPV6_CSUM_BIT,
 						NETIF_F_TSO_BIT,
 						NETIF_F_TSO6_BIT);
-			changed &= changeable;
+			netdev_features_mask(changed, changeable);
 			netdev_features_toggle(features, changed);
 		}
 	}
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index d5d94b6a7a0c..3cfe04cf0b3d 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1434,7 +1434,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	netdev_features_fill(features);
 	netdev_features_clear(features, NETVSC_SUPPORTED_HW_FEATURES);
 	netdev_features_set(features, net->hw_features);
-	net->features &= features;
+	netdev_active_features_mask(net, features);
 
 	netif_set_tso_max_size(net, gso_max_size);
 
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 5bb952c2b30d..d2c56abbaf5c 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -128,9 +128,9 @@ static int ipvlan_init(struct net_device *dev)
 
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
-	dev->features = phy_dev->features & IPVLAN_FEATURES;
+	netdev_active_features_and(dev, phy_dev->features, IPVLAN_FEATURES);
 	netdev_active_features_set(dev, IPVLAN_ALWAYS_ON);
-	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
+	netdev_vlan_features_and(dev, phy_dev->vlan_features, IPVLAN_FEATURES);
 	netdev_vlan_features_set(dev, IPVLAN_ALWAYS_ON_OFLOADS);
 	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, phy_dev);
@@ -237,12 +237,12 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, IPVLAN_FEATURES);
 	netdev_features_set(tmp, ipvlan->sfeatures);
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 	features = netdev_increment_features(ipvlan->phy_dev->features,
 					     features, features);
 	netdev_features_set(features, IPVLAN_ALWAYS_ON);
 	netdev_features_or(tmp, IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 
 	return features;
 }
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 0527988c4daf..b5d263c6469f 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3482,7 +3482,8 @@ static int macsec_dev_init(struct net_device *dev)
 	if (macsec_is_offloaded(macsec)) {
 		macsec_real_dev_features(real_dev, &dev->features);
 	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
+		netdev_active_features_and(dev, real_dev->features,
+					   SW_MACSEC_FEATURES);
 		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	}
@@ -3523,11 +3524,11 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 		return tmp;
 	}
 
-	tmp = real_dev->features & SW_MACSEC_FEATURES;
+	netdev_features_and(tmp, real_dev->features, SW_MACSEC_FEATURES);
 	netdev_features_set(tmp, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set(tmp, NETIF_F_SOFT_FEATURES);
 
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
 	return features;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 0207298835a0..858eb9329945 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -895,10 +895,11 @@ static int macvlan_init(struct net_device *dev)
 
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
-	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
+	netdev_active_features_and(dev, lowerdev->features, MACVLAN_FEATURES);
 	netdev_active_features_set(dev, ALWAYS_ON_FEATURES);
 	netdev_hw_feature_add(dev, NETIF_F_LRO_BIT);
-	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
+	netdev_vlan_features_and(dev, lowerdev->vlan_features,
+				 MACVLAN_FEATURES);
 	netdev_vlan_features_set(dev, ALWAYS_ON_OFFLOADS);
 	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, lowerdev);
@@ -1084,16 +1085,16 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, MACVLAN_FEATURES);
 	netdev_features_set(tmp, vlan->set_features);
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 	mask = features;
 
 	tmp = features;
 	netdev_feature_del(NETIF_F_LRO_BIT, tmp);
-	lowerdev_features &= tmp;
+	netdev_features_mask(lowerdev_features, tmp);
 	features = netdev_increment_features(lowerdev_features, features, mask);
 	netdev_features_set(features, ALWAYS_ON_FEATURES);
 	netdev_features_or(tmp, ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 
 	return features;
 }
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 962a0a9c0307..eed4e0ac18be 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -383,14 +383,16 @@ static rx_handler_result_t net_failover_handle_frame(struct sk_buff **pskb)
 
 static void net_failover_compute_features(struct net_device *dev)
 {
-	netdev_features_t vlan_features = FAILOVER_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
 	netdev_features_t enc_features  = FAILOVER_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct net_device *primary_dev, *standby_dev;
+	netdev_features_t vlan_features;
+
+	netdev_features_and(vlan_features, FAILOVER_VLAN_FEATURES,
+			    NETIF_F_ALL_FOR_ALL);
 
 	primary_dev = rcu_dereference(nfo_info->primary_dev);
 	if (primary_dev) {
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 7e1c22c955ca..7c9e16d9e16b 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -989,12 +989,14 @@ static netdev_features_t team_enc_features __ro_after_init;
 static void __team_compute_features(struct team *team)
 {
 	struct team_port *port;
-	netdev_features_t vlan_features = TEAM_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
 	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
 					IFF_XMIT_DST_RELEASE_PERM;
+	netdev_features_t vlan_features;
+
+	netdev_features_and(vlan_features, TEAM_VLAN_FEATURES,
+			    NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
 	list_for_each_entry_rcu(port, &team->port_list, list) {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index caf449e9e666..b9bc7ff7c283 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1171,7 +1171,7 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 	struct tun_struct *tun = netdev_priv(dev);
 	netdev_features_t tmp1, tmp2;
 
-	tmp1 = features & tun->set_features;
+	netdev_features_and(tmp1, features, tun->set_features);
 	netdev_features_andnot(tmp2, features, TUN_USER_FEATURES);
 	return tmp1 | tmp2;
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 917df26f3794..f10bfe07d48d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3745,8 +3745,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 		netdev_active_feature_add(dev, NETIF_F_GSO_ROBUST_BIT);
 
 		if (gso) {
-			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
+			netdev_features_t tmp;
 
+			netdev_features_and(tmp, dev->hw_features,
+					    NETIF_F_ALL_TSO);
 			netdev_active_features_set(dev, tmp);
 		}
 		/* (!csum && gso) case will be fixed by register_netdev() */
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 173bf09b4cad..7adac714c78b 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -8,6 +8,7 @@
 #define _LINUX_IF_VLAN_H_
 
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/bug.h>
@@ -743,7 +744,8 @@ static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		features &= netdev_multi_tags_features_mask;
+		netdev_features_mask(features,
+				     netdev_multi_tags_features_mask);
 	}
 
 	return features;
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index 0650d003ccf0..31f52db00fa5 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -700,6 +700,8 @@ static inline bool __netdev_features_subset(const netdev_features_t *feats1,
 static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 							  netdev_features_t f2)
 {
+	netdev_features_t ret;
+
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1) !=
 	    netdev_feature_test(NETIF_F_HW_CSUM_BIT, f2)) {
 		if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, f1))
@@ -708,7 +710,8 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 			netdev_features_set(f2, netdev_ip_csum_features);
 	}
 
-	return f1 & f2;
+	netdev_features_and(ret, f1, f2);
+	return ret;
 }
 
 static inline netdev_features_t
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index bab506759c1b..2acb89660ab5 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -110,7 +110,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 
 	netdev_features_or(ret, NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set(ret, NETIF_F_GSO_ENCAP_ALL);
-	ret &= real_dev->hw_enc_features;
+	netdev_features_mask(ret, real_dev->hw_enc_features);
 
 	if (netdev_features_intersects(ret, NETIF_F_GSO_ENCAP_ALL) &&
 	    netdev_features_intersects(ret, NETIF_F_CSUM_MASK)) {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 3adecc9a803f..04588800df24 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -664,7 +664,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, lower_features);
 	features = netdev_intersect_features(features, lower_features);
 	netdev_features_or(tmp, NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
-	tmp &= old_features;
+	netdev_features_mask(tmp, old_features);
 	netdev_features_set(features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, features);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 428f30bed9b6..10e74f33147e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3397,7 +3397,8 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features = dev->features & dev->gso_partial_features;
+		netdev_features_and(partial_features, dev->features,
+				    dev->gso_partial_features);
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, partial_features);
 		netdev_features_set(partial_features, features);
 		if (!skb_gso_ok(skb, partial_features))
@@ -3465,7 +3466,7 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   __be16 type)
 {
 	if (eth_p_mpls(type))
-		features &= skb->dev->mpls_features;
+		netdev_features_mask(features, skb->dev->mpls_features);
 
 	return features;
 }
@@ -3567,7 +3568,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		netdev_features_mask(features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
 		netdev_features_or(tmp, dev->vlan_features,
@@ -3579,7 +3580,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
 		tmp = dflt_features_check(skb, dev, features);
-	features &= tmp;
+	netdev_features_mask(features, tmp);
 
 	return harmonize_features(skb, features);
 }
@@ -10052,7 +10053,7 @@ int register_netdevice(struct net_device *dev)
 		netdev_hw_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	netdev_wanted_features_and(dev, dev->features, dev->hw_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_feature_add(dev, NETIF_F_NOCACHE_COPY_BIT);
@@ -11172,14 +11173,14 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, mask);
 
 	netdev_features_or(tmp, NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
-	tmp &= one;
-	tmp &= mask;
+	netdev_features_mask(tmp, one);
+	netdev_features_mask(tmp, mask);
 	netdev_features_set(all, tmp);
 
 	netdev_features_fill(tmp);
 	netdev_features_clear(tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_set(tmp, one);
-	all &= tmp;
+	netdev_features_mask(all, tmp);
 
 	/* If one device supports hw checksumming, set for all. */
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, all)) {
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 769d77cbeb16..496dfd45faac 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -254,7 +254,8 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
 		netdev_wanted_features_clear(dev, dev->hw_features);
-		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
+		tmp = ethnl_bitmap_to_features(req_wanted);
+		netdev_features_mask(tmp, dev->hw_features);
 		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
 	}
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 9819bb5b6165..a094c9e14d3d 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -153,12 +153,12 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 	netdev_features_andnot(tmp, valid, dev->hw_features);
 	if (tmp) {
-		valid &= dev->hw_features;
+		netdev_features_mask(valid, dev->hw_features);
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
 	netdev_wanted_features_clear(dev, valid);
-	tmp = wanted & valid;
+	netdev_features_and(tmp, wanted, valid);
 	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
 
@@ -292,7 +292,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EFAULT;
 
 	mask = ethtool_get_feature_mask(ethcmd);
-	mask &= dev->hw_features;
+	netdev_features_mask(mask, dev->hw_features);
 	if (!mask)
 		return -EOPNOTSUPP;
 
@@ -357,14 +357,14 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	/* allow changing only bits set in hw_features */
 	netdev_features_xor(changed, dev->features, features);
-	changed &= eth_all_features;
+	netdev_features_mask(changed, eth_all_features);
 	netdev_features_andnot(tmp, changed, dev->hw_features);
 	if (tmp)
 		return netdev_hw_features_intersects(dev, changed) ?
 			-EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_clear(dev, changed);
-	tmp = features & changed;
+	netdev_features_and(tmp, features, changed);
 	netdev_wanted_features_set(dev, tmp);
 
 	__netdev_update_features(dev);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 1607dd056702..67f71417032a 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1375,7 +1375,7 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_features_mask(features, skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += ihl;
 
 	skb_reset_transport_header(skb);
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index cea677526304..2434e7099190 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -44,7 +44,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
 	skb->encap_hdr_csum = need_csum;
 
-	features &= skb->dev->hw_enc_features;
+	netdev_features_mask(features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, features);
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 0cbe51ad0803..107a80518f61 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -68,7 +68,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 			   (is_ipv6 ? netdev_active_feature_test(skb->dev, NETIF_F_IPV6_CSUM_BIT) :
 				      netdev_active_feature_test(skb->dev, NETIF_F_IP_CSUM_BIT))));
 
-	features &= skb->dev->hw_enc_features;
+	netdev_features_mask(features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, features);
 
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d37a8c97e6de..db7737bac5c3 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -115,7 +115,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_features_mask(features, skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += sizeof(*ipv6h);
 
 	ipv6h = ipv6_hdr(skb);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d2227c0af028..799fbbabe6eb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2230,7 +2230,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		netdev_active_features_set(ndev, local->hw.netdev_features);
 		ndev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
+		netdev_features_and(tmp, ndev->features,
+				    MAC80211_SUPPORTED_FEATURES_TX);
 		netdev_hw_features_set(ndev, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 1482259de9b5..4cf6a6c2eaaa 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/mpls.h>
@@ -43,7 +44,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	/* Segment inner packet. */
-	mpls_features = skb->dev->mpls_features & features;
+	netdev_features_and(mpls_features, skb->dev->mpls_features, features);
 	segs = skb_mac_gso_segment(skb, mpls_features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, mpls_protocol, mpls_hlen, mac_offset,
-- 
2.33.0

