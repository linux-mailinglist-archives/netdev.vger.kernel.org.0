Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E69258E567
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230260AbiHJDOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE7081B2F
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgy4Wrlz1M8S3;
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
Subject: [RFCv7 PATCH net-next 32/36] net: use netdev_features_and and netdev_features_mask helpers
Date:   Wed, 10 Aug 2022 11:06:20 +0800
Message-ID: <20220810030624.34711-33-shenjian15@huawei.com>
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

Replace the '&' expressions of features by netdev_features_and
helpers, and replace the '& =' expressions by netdev_features_clear
helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/bonding/bond_main.c                 |  4 ++--
 drivers/net/ethernet/broadcom/bnx2.c            |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c       |  2 +-
 drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c |  3 ++-
 .../net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c |  3 ++-
 .../net/ethernet/fungible/funeth/funeth_main.c  |  2 +-
 drivers/net/ethernet/ibm/ibmvnic.c              |  7 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c       | 17 ++++++++++-------
 .../net/ethernet/netronome/nfp/nfp_net_common.c |  2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c   |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c  |  2 +-
 drivers/net/hyperv/rndis_filter.c               |  2 +-
 drivers/net/ipvlan/ipvlan_main.c                |  9 +++++----
 drivers/net/macsec.c                            |  7 ++++---
 drivers/net/macvlan.c                           | 10 +++++-----
 drivers/net/net_failover.c                      |  4 ++--
 drivers/net/team/team.c                         |  4 ++--
 drivers/net/tun.c                               |  2 +-
 drivers/net/virtio_net.c                        |  3 ++-
 include/linux/if_vlan.h                         |  4 +++-
 include/linux/netdev_features_helper.h          |  2 +-
 net/8021q/vlan.h                                |  2 +-
 net/8021q/vlan_dev.c                            |  2 +-
 net/core/dev.c                                  | 17 +++++++++--------
 net/ethtool/ioctl.c                             |  6 +++---
 net/ipv4/af_inet.c                              |  2 +-
 net/ipv4/gre_offload.c                          |  2 +-
 net/ipv4/udp_offload.c                          |  2 +-
 net/ipv6/ip6_offload.c                          |  2 +-
 net/mac80211/iface.c                            |  3 ++-
 net/mpls/mpls_gso.c                             |  3 ++-
 net/nsh/nsh.c                                   |  2 +-
 33 files changed, 76 insertions(+), 62 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 628526c3323a..da6e6c73dc6a 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1467,8 +1467,8 @@ static void bond_compute_features(struct bonding *bond)
 
 	if (!bond_has_slaves(bond))
 		goto done;
-	vlan_features &= NETIF_F_ALL_FOR_ALL;
-	mpls_features &= NETIF_F_ALL_FOR_ALL;
+	netdev_features_mask(&vlan_features, NETIF_F_ALL_FOR_ALL);
+	netdev_features_mask(&mpls_features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
 		vlan_features = netdev_increment_features(vlan_features,
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index ac46a10b6252..d08141a77e1e 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7757,7 +7757,7 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 	if (netdev_feature_test(NETIF_F_HW_VLAN_CTAG_TX_BIT, features)) {
 		netdev_features_t tso;
 
-		tso = dev->hw_features & NETIF_F_ALL_TSO;
+		tso = netdev_hw_features_and(dev, NETIF_F_ALL_TSO);
 		netdev_vlan_features_set(dev, tso);
 	} else {
 		netdev_vlan_features_clear(dev, NETIF_F_ALL_TSO);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 35fb5b726df1..6b2ee76666bf 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11198,7 +11198,7 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	/* Both CTAG and STAG VLAN accelaration on the RX side have to be
 	 * turned on or off together.
 	 */
-	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
+	vlan_features = netdev_features_and(features, BNXT_HW_FEATURE_VLAN_ALL_RX);
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
 		if (netdev_active_features_intersects(dev, BNXT_HW_FEATURE_VLAN_ALL_RX))
 			netdev_features_clear(&features,
diff --git a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
index d7c1637f7d63..d8d9b9a42aa4 100644
--- a/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb3/cxgb3_main.c
@@ -3327,7 +3327,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_TX_BIT);
 		netdev_features_zero(&vlan_feat);
 		netdev_features_set_array(&cxgb_vlan_feature_set, &vlan_feat);
-		vlan_feat &= netdev->features;
+		netdev_features_mask(&vlan_feat, netdev->features);
 		netdev_vlan_features_set(netdev, vlan_feat);
 
 		netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index e903fe97975d..da5e23346871 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6867,7 +6867,8 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		netdev_active_features_set(netdev, netdev->hw_features);
 		vlan_features = tso_features;
 		netdev_features_set_array(&cxgb4_vlan_feature_set, &vlan_features);
-		netdev->vlan_features = netdev->features & vlan_features;
+		netdev->vlan_features = netdev_active_features_and(netdev,
+								   vlan_features);
 #if IS_ENABLED(CONFIG_CHELSIO_TLS_DEVICE)
 		if (pi->adapter->params.crypto & FW_CAPS_CONFIG_TLS_HW) {
 			netdev_hw_feature_add(netdev, NETIF_F_HW_TLS_TX_BIT);
diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index efc86d7e7c42..729e0a272413 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -3098,7 +3098,8 @@ static int cxgb4vf_pci_probe(struct pci_dev *pdev,
 		vlan_features = tso_features;
 		netdev_features_set_array(&cxgb4vf_vlan_feature_set,
 					  &vlan_features);
-		netdev->vlan_features = netdev->features & vlan_features;
+		netdev->vlan_features = netdev_active_features_and(netdev,
+								   vlan_features);
 
 		netdev->priv_flags |= IFF_UNICAST_FLT;
 		netdev->min_mtu = 81;
diff --git a/drivers/net/ethernet/fungible/funeth/funeth_main.c b/drivers/net/ethernet/fungible/funeth/funeth_main.c
index 0fee1effb7ce..c883572e48a1 100644
--- a/drivers/net/ethernet/fungible/funeth/funeth_main.c
+++ b/drivers/net/ethernet/fungible/funeth/funeth_main.c
@@ -1797,7 +1797,7 @@ static int fun_create_netdev(struct fun_ethdev *ed, unsigned int portid)
 
 	netdev_active_features_set(netdev, netdev->hw_features);
 	netdev_active_feature_add(netdev, NETIF_F_HIGHDMA_BIT);
-	netdev->vlan_features = netdev->features & vlan_feat;
+	netdev->vlan_features = netdev_active_features_and(netdev, vlan_feat);
 	netdev->mpls_features = netdev->vlan_features;
 	netdev->hw_enc_features = netdev->hw_features;
 
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 79f9363ec939..95016982f03b 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -4899,11 +4899,12 @@ static void send_control_ip_offload(struct ibmvnic_adapter *adapter)
 		netdev_features_t tmp = netdev_empty_features;
 
 		/* disable features no longer supported */
-		adapter->netdev->features &= adapter->netdev->hw_features;
+		netdev_active_features_mask(adapter->netdev,
+					    adapter->netdev->hw_features);
 		/* turn on features now supported if previously enabled */
 		tmp = netdev_hw_features_xor(adapter->netdev, old_hw_features);
-		tmp &= adapter->netdev->hw_features;
-		tmp &= adapter->netdev->wanted_features;
+		netdev_features_mask(&tmp, adapter->netdev->hw_features);
+		netdev_features_mask(&tmp, adapter->netdev->wanted_features);
 		netdev_active_features_set(adapter->netdev, tmp);
 	}
 
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index a58669228d64..19a0e82d45ae 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5780,13 +5780,13 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	netdev_features_t req_vlan_fltr, cur_vlan_fltr;
 	bool cur_ctag, cur_stag, req_ctag, req_stag;
 
-	cur_vlan_fltr = netdev->features & NETIF_VLAN_FILTERING_FEATURES;
+	cur_vlan_fltr = netdev_active_features_and(netdev, NETIF_VLAN_FILTERING_FEATURES);
 	cur_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       cur_vlan_fltr);
 	cur_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
 				       cur_vlan_fltr);
 
-	req_vlan_fltr = features & NETIF_VLAN_FILTERING_FEATURES;
+	req_vlan_fltr = netdev_features_and(features, NETIF_VLAN_FILTERING_FEATURES);
 	req_ctag = netdev_feature_test(NETIF_F_HW_VLAN_CTAG_FILTER_BIT,
 				       req_vlan_fltr);
 	req_stag = netdev_feature_test(NETIF_F_HW_VLAN_STAG_FILTER_BIT,
@@ -5917,8 +5917,10 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 	struct ice_vsi *vsi = np->vsi;
 	int err;
 
-	current_vlan_features = netdev->features & NETIF_VLAN_OFFLOAD_FEATURES;
-	requested_vlan_features = features & NETIF_VLAN_OFFLOAD_FEATURES;
+	current_vlan_features = netdev_active_features_and(netdev,
+							   NETIF_VLAN_OFFLOAD_FEATURES);
+	requested_vlan_features = netdev_features_and(features,
+						      NETIF_VLAN_OFFLOAD_FEATURES);
 	diff = netdev_features_xor(current_vlan_features, requested_vlan_features);
 	if (diff) {
 		err = ice_set_vlan_offload_features(vsi, features);
@@ -5926,9 +5928,10 @@ ice_set_vlan_features(struct net_device *netdev, netdev_features_t features)
 			return err;
 	}
 
-	current_vlan_features = netdev->features &
-		NETIF_VLAN_FILTERING_FEATURES;
-	requested_vlan_features = features & NETIF_VLAN_FILTERING_FEATURES;
+	current_vlan_features = netdev_active_features_and(netdev,
+							   NETIF_VLAN_FILTERING_FEATURES);
+	requested_vlan_features = netdev_features_and(features,
+						      NETIF_VLAN_FILTERING_FEATURES);
 	diff = netdev_features_xor(current_vlan_features, requested_vlan_features);
 	if (diff) {
 		err = ice_set_vlan_filtering_features(vsi, features);
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 1ff44d5a2c7c..bcd8513b3b43 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1785,7 +1785,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	u8 l4_hdr;
 
 	/* We can't do TSO over double tagged packets (802.1AD) */
-	features &= vlan_features_check(skb, features);
+	netdev_features_mask(&features, vlan_features_check(skb, features));
 
 	if (!skb->encapsulation)
 		return features;
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index 346bc59ce40d..f250067dad7e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -251,7 +251,7 @@ nfp_repr_fix_features(struct net_device *netdev, netdev_features_t features)
 	features = netdev_intersect_features(features, lower_features);
 	tmp = NETIF_F_SOFT_FEATURES;
 	netdev_feature_add(NETIF_F_HW_TC_BIT, &tmp);
-	tmp &= old_features;
+	netdev_features_mask(&tmp, old_features);
 	netdev_features_set(&features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 4fd623d65921..a7ce52edf2df 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1081,7 +1081,7 @@ netdev_features_t qlcnic_fix_features(struct net_device *netdev,
 			netdev_features_zero(&changeable);
 			netdev_features_set_array(&qlcnic_changable_feature_set,
 						  &changeable);
-			changed &= changeable;
+			netdev_features_mask(&changed, changeable);
 			netdev_features_toggle(&features, changed);
 		}
 	}
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 02d2f94c8364..17bf22a0e9b0 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1434,7 +1434,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	netdev_features_fill(&features);
 	netdev_features_clear(&features, NETVSC_SUPPORTED_HW_FEATURES);
 	netdev_features_set(&features, net->hw_features);
-	net->features &= features;
+	netdev_active_features_mask(net, features);
 
 	netif_set_tso_max_size(net, gso_max_size);
 
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index e719b457e4e8..6db91e0de2f2 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -151,9 +151,10 @@ static int ipvlan_init(struct net_device *dev)
 
 	dev->state = (dev->state & ~IPVLAN_STATE_MASK) |
 		     (phy_dev->state & IPVLAN_STATE_MASK);
-	dev->features = phy_dev->features & IPVLAN_FEATURES;
+	dev->features = netdev_active_features_and(phy_dev, IPVLAN_FEATURES);
 	netdev_active_features_set(dev, IPVLAN_ALWAYS_ON);
-	dev->vlan_features = phy_dev->vlan_features & IPVLAN_FEATURES;
+	dev->vlan_features = netdev_vlan_features_and(phy_dev,
+						      IPVLAN_FEATURES);
 	netdev_vlan_features_set(dev, IPVLAN_ALWAYS_ON_OFLOADS);
 	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, phy_dev);
@@ -260,12 +261,12 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 	netdev_features_fill(&tmp);
 	netdev_features_clear(&tmp, IPVLAN_FEATURES);
 	netdev_features_set(&tmp, ipvlan->sfeatures);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 	features = netdev_increment_features(ipvlan->phy_dev->features,
 					     features, features);
 	netdev_features_set(&features, IPVLAN_ALWAYS_ON);
 	tmp = netdev_features_or(IPVLAN_FEATURES, IPVLAN_ALWAYS_ON);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 
 	return features;
 }
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index b415e4aaae1d..999acee318d3 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3456,7 +3456,8 @@ static int macsec_dev_init(struct net_device *dev)
 	if (macsec_is_offloaded(macsec)) {
 		dev->features = REAL_DEV_FEATURES(real_dev);
 	} else {
-		dev->features = real_dev->features & SW_MACSEC_FEATURES;
+		dev->features = netdev_active_features_and(real_dev,
+							   SW_MACSEC_FEATURES);
 		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 	}
@@ -3495,10 +3496,10 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	if (macsec_is_offloaded(macsec))
 		return REAL_DEV_FEATURES(real_dev);
 
-	tmp = real_dev->features & SW_MACSEC_FEATURES;
+	tmp = netdev_active_features_and(real_dev, SW_MACSEC_FEATURES);
 	netdev_features_set(&tmp, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set(&tmp, NETIF_F_SOFT_FEATURES);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
 	return features;
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 78dbe6003618..83107ccc7e14 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -916,10 +916,10 @@ static int macvlan_init(struct net_device *dev)
 
 	dev->state		= (dev->state & ~MACVLAN_STATE_MASK) |
 				  (lowerdev->state & MACVLAN_STATE_MASK);
-	dev->features 		= lowerdev->features & MACVLAN_FEATURES;
+	dev->features = netdev_active_features_and(lowerdev, MACVLAN_FEATURES);
 	netdev_active_features_set(dev, ALWAYS_ON_FEATURES);
 	netdev_hw_feature_add(dev, NETIF_F_LRO_BIT);
-	dev->vlan_features	= lowerdev->vlan_features & MACVLAN_FEATURES;
+	dev->vlan_features = netdev_vlan_features_and(lowerdev, MACVLAN_FEATURES);
 	netdev_vlan_features_set(dev, ALWAYS_ON_OFFLOADS);
 	netdev_hw_enc_features_set(dev, dev->features);
 	netif_inherit_tso_max(dev, lowerdev);
@@ -1105,16 +1105,16 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 	netdev_features_fill(&tmp);
 	netdev_features_clear(&tmp, MACVLAN_FEATURES);
 	netdev_features_set(&tmp, vlan->set_features);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 	mask = features;
 
 	tmp = features;
 	netdev_feature_del(NETIF_F_LRO_BIT, &tmp);
-	lowerdev_features &= tmp;
+	netdev_features_mask(&lowerdev_features, tmp);
 	features = netdev_increment_features(lowerdev_features, features, mask);
 	netdev_features_set(&features, ALWAYS_ON_FEATURES);
 	tmp = netdev_features_or(ALWAYS_ON_FEATURES, MACVLAN_FEATURES);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 
 	return features;
 }
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index a58a1d325dcc..bcf1a93826e1 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -393,8 +393,8 @@ static rx_handler_result_t net_failover_handle_frame(struct sk_buff **pskb)
 
 static void net_failover_compute_features(struct net_device *dev)
 {
-	netdev_features_t vlan_features = FAILOVER_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
+	netdev_features_t vlan_features = netdev_features_and(FAILOVER_VLAN_FEATURES,
+							      NETIF_F_ALL_FOR_ALL);
 	netdev_features_t enc_features  = FAILOVER_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 406f0befe177..9a2103c753de 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -999,8 +999,8 @@ static netdev_features_t team_enc_features __ro_after_init;
 static void __team_compute_features(struct team *team)
 {
 	struct team_port *port;
-	netdev_features_t vlan_features = TEAM_VLAN_FEATURES &
-					  NETIF_F_ALL_FOR_ALL;
+	netdev_features_t vlan_features = netdev_features_and(TEAM_VLAN_FEATURES,
+							      NETIF_F_ALL_FOR_ALL);
 	netdev_features_t enc_features  = TEAM_ENC_FEATURES;
 	unsigned short max_hard_header_len = ETH_HLEN;
 	unsigned int dst_release_flag = IFF_XMIT_DST_RELEASE |
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 7d4ac857555c..363a4ca29cce 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1178,7 +1178,7 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 	struct tun_struct *tun = netdev_priv(dev);
 	netdev_features_t tmp1, tmp2;
 
-	tmp1 = features & tun->set_features;
+	tmp1 = netdev_features_and(features, tun->set_features);
 	tmp2 = netdev_features_andnot(features, TUN_USER_FEATURES);
 	return netdev_features_or(tmp1, tmp2);
 }
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 81d5022c5c42..77038488eaf4 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3538,7 +3538,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		netdev_active_feature_add(dev, NETIF_F_GSO_ROBUST_BIT);
 
 		if (gso) {
-			netdev_features_t tmp = dev->hw_features & NETIF_F_ALL_TSO;
+			netdev_features_t tmp = netdev_hw_features_and(dev,
+								       NETIF_F_ALL_TSO);
 
 			netdev_active_features_set(dev, tmp);
 		}
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 173bf09b4cad..9d2573f0461a 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -8,6 +8,7 @@
 #define _LINUX_IF_VLAN_H_
 
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/etherdevice.h>
 #include <linux/rtnetlink.h>
 #include <linux/bug.h>
@@ -743,7 +744,8 @@ static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		features &= netdev_multi_tags_features_mask;
+		netdev_features_mask(&features,
+				     netdev_multi_tags_features_mask);
 	}
 
 	return features;
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index 9adf376e1798..476d36352160 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -696,7 +696,7 @@ static inline netdev_features_t netdev_intersect_features(netdev_features_t f1,
 			netdev_features_set(&f2, netdev_ip_csum_features);
 	}
 
-	return f1 & f2;
+	return netdev_features_and(f1, f2);
 }
 
 static inline netdev_features_t
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 73c4a6595ace..f919ab183d69 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -110,7 +110,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 
 	ret = netdev_features_or(NETIF_F_CSUM_MASK, NETIF_F_GSO_SOFTWARE);
 	netdev_features_set(&ret, NETIF_F_GSO_ENCAP_ALL);
-	ret &= real_dev->hw_enc_features;
+	netdev_features_mask(&ret, real_dev->hw_enc_features);
 
 	if (netdev_features_intersects(ret, NETIF_F_GSO_ENCAP_ALL) &&
 	    netdev_features_intersects(ret, NETIF_F_CSUM_MASK)) {
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index d13236621a40..be79c298f2ef 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -668,7 +668,7 @@ static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &lower_features);
 	features = netdev_intersect_features(features, lower_features);
 	tmp = netdev_features_or(NETIF_F_SOFT_FEATURES, NETIF_F_GSO_SOFTWARE);
-	tmp &= old_features;
+	netdev_features_mask(&tmp, old_features);
 	netdev_features_set(&features, tmp);
 	netdev_feature_add(NETIF_F_LLTX_BIT, &features);
 
diff --git a/net/core/dev.c b/net/core/dev.c
index dc4cadf2e4df..b97b9316dbde 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3398,7 +3398,7 @@ struct sk_buff *__skb_gso_segment(struct sk_buff *skb,
 		netdev_features_t partial_features;
 		struct net_device *dev = skb->dev;
 
-		partial_features = dev->features & dev->gso_partial_features;
+		partial_features = netdev_active_features_and(dev, dev->gso_partial_features);
 		netdev_feature_add(NETIF_F_GSO_ROBUST_BIT, &partial_features);
 		if (!skb_gso_ok(skb, netdev_features_or(features, partial_features)))
 			netdev_feature_del(NETIF_F_GSO_PARTIAL_BIT, &features);
@@ -3465,7 +3465,7 @@ static netdev_features_t net_mpls_features(struct sk_buff *skb,
 					   __be16 type)
 {
 	if (eth_p_mpls(type))
-		features &= skb->dev->mpls_features;
+		netdev_features_mask(&features, skb->dev->mpls_features);
 
 	return features;
 }
@@ -3563,7 +3563,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 	 * features for the netdev
 	 */
 	if (skb->encapsulation)
-		features &= dev->hw_enc_features;
+		netdev_features_mask(&features, dev->hw_enc_features);
 
 	if (skb_vlan_tagged(skb)) {
 		tmp = netdev_vlan_features_or(dev, netdev_tx_vlan_features);
@@ -3574,7 +3574,7 @@ netdev_features_t netif_skb_features(struct sk_buff *skb)
 		tmp = dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
 		tmp = dflt_features_check(skb, dev, features);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 
 	return harmonize_features(skb, features);
 }
@@ -10046,7 +10046,8 @@ int register_netdevice(struct net_device *dev)
 		netdev_hw_feature_add(dev, NETIF_F_RX_UDP_TUNNEL_PORT_BIT);
 	}
 
-	dev->wanted_features = dev->features & dev->hw_features;
+	dev->wanted_features = netdev_active_features_and(dev,
+							  dev->hw_features);
 
 	if (!(dev->flags & IFF_LOOPBACK))
 		netdev_hw_feature_add(dev, NETIF_F_NOCACHE_COPY_BIT);
@@ -11168,14 +11169,14 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_feature_add(NETIF_F_VLAN_CHALLENGED_BIT, &mask);
 
 	tmp = netdev_features_or(NETIF_F_ONE_FOR_ALL, NETIF_F_CSUM_MASK);
-	tmp &= one;
-	tmp &= mask;
+	netdev_features_mask(&tmp, one);
+	netdev_features_mask(&tmp, mask);
 	netdev_features_set(&all, tmp);
 
 	netdev_features_fill(&tmp);
 	netdev_features_clear(&tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_set(&tmp, one);
-	all &= tmp;
+	netdev_features_mask(&all, tmp);
 
 	/* If one device supports hw checksumming, set for all. */
 	if (netdev_feature_test(NETIF_F_HW_CSUM_BIT, all)) {
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f1ae7a4ade29..9bca8eb4f1c9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -289,7 +289,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 		return -EFAULT;
 
 	mask = ethtool_get_feature_mask(ethcmd);
-	mask &= dev->hw_features;
+	netdev_features_mask(&mask, dev->hw_features);
 	if (!mask)
 		return -EOPNOTSUPP;
 
@@ -357,14 +357,14 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 
 	/* allow changing only bits set in hw_features */
 	changed = netdev_active_features_xor(dev, features);
-	changed &= eth_all_features;
+	netdev_features_mask(&changed, eth_all_features);
 	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
 		return netdev_hw_features_intersects(dev, changed) ?
 			-EINVAL : -EOPNOTSUPP;
 
 	netdev_wanted_features_clear(dev, changed);
-	tmp = features & changed;
+	tmp = netdev_features_and(features, changed);
 	netdev_wanted_features_set(dev, tmp);
 
 	__netdev_update_features(dev);
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ad3bea716358..4c22ea1c1f2d 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1359,7 +1359,7 @@ struct sk_buff *inet_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_features_mask(&features, skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += ihl;
 
 	skb_reset_transport_header(skb);
diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 27b9e531ed62..de8d6849b49d 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -44,7 +44,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
 	skb->encap_hdr_csum = need_csum;
 
-	features &= skb->dev->hw_enc_features;
+	netdev_features_mask(&features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &features);
 
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 07c1237c69f3..9c9b58808137 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -68,7 +68,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 			   (is_ipv6 ? netdev_active_feature_test(skb->dev, NETIF_F_IPV6_CSUM_BIT) :
 				      netdev_active_feature_test(skb->dev, NETIF_F_IP_CSUM_BIT))));
 
-	features &= skb->dev->hw_enc_features;
+	netdev_features_mask(&features, skb->dev->hw_enc_features);
 	if (need_csum)
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &features);
 
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d12dba2dd535..1eb2098e0aea 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -115,7 +115,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 
 	encap = SKB_GSO_CB(skb)->encap_level > 0;
 	if (encap)
-		features &= skb->dev->hw_enc_features;
+		netdev_features_mask(&features, skb->dev->hw_enc_features);
 	SKB_GSO_CB(skb)->encap_level += sizeof(*ipv6h);
 
 	ipv6h = ipv6_hdr(skb);
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index d3dc0628cac3..f78a5e1d2393 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -2398,7 +2398,8 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 			sdata->u.mgd.use_4addr = params->use_4addr;
 
 		netdev_active_features_set(ndev, local->hw.netdev_features);
-		tmp = ndev->features & MAC80211_SUPPORTED_FEATURES_TX;
+		tmp = netdev_active_features_and(ndev,
+						 MAC80211_SUPPORTED_FEATURES_TX);
 		netdev_hw_features_set(ndev, tmp);
 
 		netdev_set_default_ethtool_ops(ndev, &ieee80211_ethtool_ops);
diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
index 1482259de9b5..9e93869ca7f6 100644
--- a/net/mpls/mpls_gso.c
+++ b/net/mpls/mpls_gso.c
@@ -12,6 +12,7 @@
 #include <linux/err.h>
 #include <linux/module.h>
 #include <linux/netdev_features.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/netdevice.h>
 #include <linux/skbuff.h>
 #include <net/mpls.h>
@@ -43,7 +44,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
 	skb_reset_mac_header(skb);
 
 	/* Segment inner packet. */
-	mpls_features = skb->dev->mpls_features & features;
+	mpls_features = netdev_mpls_features_and(skb->dev, features);
 	segs = skb_mac_gso_segment(skb, mpls_features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, mpls_protocol, mpls_hlen, mac_offset,
diff --git a/net/nsh/nsh.c b/net/nsh/nsh.c
index d9b55bf19fd0..c1c465545d93 100644
--- a/net/nsh/nsh.c
+++ b/net/nsh/nsh.c
@@ -107,7 +107,7 @@ static struct sk_buff *nsh_gso_segment(struct sk_buff *skb,
 	skb->protocol = proto;
 
 	netdev_feature_add(NETIF_F_SG_BIT, &tmp);
-	features &= tmp;
+	netdev_features_mask(&features, tmp);
 	segs = skb_mac_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		skb_gso_error_unwind(skb, htons(ETH_P_NSH), nsh_len,
-- 
2.33.0

