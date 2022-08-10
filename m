Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93DFB58E564
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbiHJDOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C2682F86
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:50 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4M2Zgx5cccz1M8NQ;
        Wed, 10 Aug 2022 11:10:37 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 28/36] treewide: use netdev_features_andnot and netdev_features_clear helpers
Date:   Wed, 10 Aug 2022 11:06:16 +0800
Message-ID: <20220810030624.34711-29-shenjian15@huawei.com>
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

Replace the '& ~' expressions of features by netdev_features_andnot
helpers, and replace the '&= ~' expressions by netdev_features_clear
helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  2 +-
 drivers/net/bonding/bond_main.c               |  5 +++--
 drivers/net/bonding/bond_options.c            |  4 ++--
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  2 +-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  7 ++++---
 drivers/net/ethernet/broadcom/tg3.c           |  6 +++---
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  2 +-
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  5 +++--
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  4 ++--
 drivers/net/ethernet/ibm/ibmveth.c            | 10 ++++++----
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  6 ++++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  4 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  7 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c     | 13 +++++++-----
 drivers/net/ethernet/jme.c                    |  4 ++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  9 +++++----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  5 +++--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++-
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  4 ++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  2 +-
 .../ethernet/netronome/nfp/nfp_net_common.c   |  6 +++---
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    |  5 +++--
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  3 ++-
 drivers/net/ethernet/realtek/r8169_main.c     | 20 +++++++++----------
 drivers/net/ethernet/sfc/efx.c                |  4 ++--
 drivers/net/ethernet/sfc/efx_common.c         | 10 ++++++----
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 ++++---
 drivers/net/ethernet/sfc/siena/efx.c          |  4 ++--
 drivers/net/ethernet/sfc/siena/efx_common.c   |  8 +++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++--
 drivers/net/hyperv/rndis_filter.c             |  4 ++--
 drivers/net/ifb.c                             |  2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  2 +-
 drivers/net/macsec.c                          |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/team/team.c                       |  2 +-
 drivers/net/tun.c                             |  7 ++++---
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  4 ++--
 drivers/net/veth.c                            |  7 ++++---
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         |  8 +++++---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  2 +-
 drivers/s390/net/qeth_core_main.c             |  6 +++---
 drivers/staging/qlge/qlge_main.c              |  2 +-
 include/linux/netdev_features_helper.h        |  2 +-
 include/net/sock.h                            |  3 ++-
 include/net/vxlan.h                           |  2 +-
 net/8021q/vlan.h                              |  2 +-
 net/8021q/vlan_dev.c                          |  3 ++-
 net/bridge/br_if.c                            |  2 +-
 net/core/dev.c                                | 18 ++++++++---------
 net/core/sock.c                               |  4 ++--
 net/ethtool/ioctl.c                           |  6 +++---
 net/hsr/hsr_device.c                          |  2 +-
 net/ipv4/esp4_offload.c                       |  4 ++--
 net/ipv4/ip_gre.c                             |  4 ++--
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/udp_offload.c                        |  2 +-
 net/ipv6/esp6_offload.c                       |  4 ++--
 net/ipv6/ip6_output.c                         |  2 +-
 net/sched/sch_cake.c                          |  2 +-
 net/sched/sch_netem.c                         |  2 +-
 net/sched/sch_taprio.c                        |  2 +-
 net/sched/sch_tbf.c                           |  3 ++-
 net/xfrm/xfrm_device.c                        |  2 +-
 78 files changed, 180 insertions(+), 150 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 9bd68d8dd410..1364f936512d 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1339,7 +1339,7 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static netdev_features_t vector_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	features &= ~netdev_ip_csum_features;
+	netdev_features_clear(&features, netdev_ip_csum_features);
 	return features;
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 06fa1a5fcb36..7041ff2f8896 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1423,12 +1423,13 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	if (bond_sk_check(bond))
 		netdev_features_set(&features, BOND_TLS_FEATURES);
 	else
-		features &= ~BOND_TLS_FEATURES;
+		netdev_features_clear(&features, BOND_TLS_FEATURES);
 #endif
 
 	mask = features;
 
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(&features, NETIF_F_ONE_FOR_ALL);
+
 	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index a90752e8aeef..decb4751abb8 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -838,7 +838,7 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		netdev_wanted_features_set(bond->dev, BOND_XFRM_FEATURES);
 	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
+		netdev_wanted_features_clear(bond->dev, BOND_XFRM_FEATURES);
 
 	return true;
 }
@@ -851,7 +851,7 @@ static bool bond_set_tls_features(struct bonding *bond)
 	if (bond_sk_check(bond))
 		netdev_wanted_features_set(bond->dev, BOND_TLS_FEATURES);
 	else
-		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
+		netdev_wanted_features_clear(bond->dev, BOND_TLS_FEATURES);
 
 	return true;
 }
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index cb7a4bb5cf74..82d1958df83b 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2266,7 +2266,7 @@ static netdev_features_t typhoon_features_check(struct sk_buff *skb,
 						netdev_features_t features)
 {
 	if (skb_shinfo(skb)->nr_frags > 32 && skb_is_gso(skb))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	return vxlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 2de5fb1ab3de..45861e329c4e 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1102,7 +1102,7 @@ static netdev_features_t alx_fix_features(struct net_device *netdev,
 					  netdev_features_t features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		features &= ~netdev_general_tso_features;
+		netdev_features_clear(&features, netdev_general_tso_features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 2113fa44026d..06f6de7dbb85 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -521,7 +521,7 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			features &= ~netdev_general_tso_features;
+			netdev_features_clear(&features, netdev_general_tso_features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index d15ec211150c..2d38958bc5d0 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -7760,7 +7760,7 @@ bnx2_set_features(struct net_device *dev, netdev_features_t features)
 		tso = dev->hw_features & NETIF_F_ALL_TSO;
 		netdev_vlan_features_set(dev, tso);
 	} else {
-		dev->vlan_features &= ~NETIF_F_ALL_TSO;
+		netdev_vlan_features_clear(dev, NETIF_F_ALL_TSO);
 	}
 
 	if ((!!(features & NETIF_F_HW_VLAN_CTAG_RX) !=
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2c460493ccac..64f56c9e2303 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12874,7 +12874,7 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 	if (unlikely(skb_is_gso(skb) &&
 		     (skb_shinfo(skb)->gso_size > 9000) &&
 		     !skb_gso_validate_mac_len(skb, 9700)))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	return vxlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e426aa407ed8..134b775f02f1 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11201,14 +11201,15 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
 		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
-			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+			netdev_features_clear(&features,
+					      BNXT_HW_FEATURE_VLAN_ALL_RX);
 		else if (vlan_features)
 			netdev_features_set(&features,
 					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
-		features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+		netdev_features_clear(&features, BNXT_HW_FEATURE_VLAN_ALL_RX);
 #endif
 	return features;
 }
@@ -11398,7 +11399,7 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 			return features;
 		break;
 	}
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 841c6dc1546f..25171a645e73 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7877,8 +7877,8 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		netif_tx_wake_queue(txq);
 	}
 
-	segs = skb_gso_segment(skb, tp->dev->features &
-				    ~netdev_general_tso_features);
+	segs = skb_gso_segment(skb,
+			       netdev_active_features_andnot(tp->dev, netdev_general_tso_features));
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
 
@@ -8308,7 +8308,7 @@ static netdev_features_t tg3_fix_features(struct net_device *dev,
 	struct tg3 *tp = netdev_priv(dev);
 
 	if (dev->mtu > ETH_DATA_LEN && tg3_flag(tp, 5780_CLASS))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 14a119232481..bddc7f6f0d23 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3852,7 +3852,7 @@ static netdev_features_t cxgb_features_check(struct sk_buff *skb,
 		return features;
 
 	/* Offload is not supported for this encapsulated packet */
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 static netdev_features_t cxgb_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 1b401125aaf0..b2bf06b3054b 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -295,7 +295,7 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	return features;
 
 out:
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 int enic_is_dynamic(struct enic *enic)
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 6acb087baa6b..e5459716a46d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1990,7 +1990,7 @@ static netdev_features_t gmac_fix_features(struct net_device *netdev,
 					   netdev_features_t features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		features &= ~GMAC_OFFLOAD_FEATURES;
+		netdev_features_clear(&features, GMAC_OFFLOAD_FEATURES);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index ba54b89149a9..cd8baf47ceed 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5090,7 +5090,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		if (lancer_chip(adapter) &&
 		    (skb_shinfo(skb)->gso_size < 256 ||
 		     skb_shinfo(skb)->gso_segs == 1))
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(&features, NETIF_F_GSO_MASK);
 	}
 
 	/* The code below restricts offload features for some tunneled and
@@ -5126,7 +5126,8 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
 	    udp_hdr(skb)->dest != adapter->vxlan_port)
-		return features & ~netdev_csum_gso_features_mask;
+		return netdev_features_andnot(features,
+					      netdev_csum_gso_features_mask);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 105ed4d4aab5..7b47f4328ac9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2476,7 +2476,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(&features, netdev_csum_gso_features_mask);
 
 	return features;
 }
@@ -3321,7 +3321,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 	netdev_features_zero(&vlan_off_features);
 	netdev_features_set_array(&hns3_vlan_off_feature_set,
 				  &vlan_off_features);
-	features = netdev->features & ~vlan_off_features;
+	features = netdev_active_features_andnot(netdev, vlan_off_features);
 	netdev_vlan_features_set(netdev, features);
 
 	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 8c1398f8b059..2319507d6731 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -744,7 +744,7 @@ static netdev_features_t ibmveth_fix_features(struct net_device *dev,
 	 */
 
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 
 	return features;
 }
@@ -874,7 +874,8 @@ static int ibmveth_set_tso(struct net_device *dev, u32 data)
 					   set_attr, clr_attr, &ret_attr);
 
 			if (data == 1)
-				dev->features &= ~netdev_general_tso_features;
+				netdev_active_features_clear(dev,
+							     netdev_general_tso_features);
 			rc1 = -EIO;
 
 		} else {
@@ -909,7 +910,7 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
 		if (rc1 && !adapter->rx_csum) {
-			dev->features = features & ~NETIF_F_CSUM_MASK;
+			dev->features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
 			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 		}
 	}
@@ -917,7 +918,8 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
 		if (rc2 && !adapter->large_send)
-			dev->features = features & ~netdev_general_tso_features;
+			dev->features = netdev_features_andnot(features,
+							       netdev_general_tso_features);
 	}
 
 	return rc1 ? rc1 : rc2;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index b5fa773272dd..538bfc2fe829 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3335,7 +3335,7 @@ static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_size < 224 ||
 		    skb_shinfo(skb)->gso_segs == 1)
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(&features, NETIF_F_GSO_MASK);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 1e51c751ff3b..158222876102 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5302,7 +5302,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 				case SPEED_10:
 				case SPEED_100:
 					e_info("10/100 speed: disabling TSO\n");
-					netdev->features &= ~netdev_general_tso_features;
+					netdev_active_features_clear(netdev,
+								     netdev_general_tso_features);
 					break;
 				case SPEED_1000:
 					netdev_active_features_set(netdev,
@@ -5313,7 +5314,8 @@ static void e1000_watchdog_task(struct work_struct *work)
 					break;
 				}
 				if (hw->mac.type == e1000_pch_spt) {
-					netdev->features &= ~netdev_general_tso_features;
+					netdev_active_features_clear(netdev,
+								     netdev_general_tso_features);
 				}
 			}
 
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 3b9df01b313e..1be0f9dade38 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1512,7 +1512,7 @@ static netdev_features_t fm10k_features_check(struct sk_buff *skb,
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
 		return features;
 
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 2377a01904ac..e9008e997a3e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13205,7 +13205,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -13237,7 +13237,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 38b4756e0992..a21cde0c2bbb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4272,7 +4272,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -4304,7 +4304,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 /**
@@ -4541,7 +4541,8 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 	    adapter->vlan_v2_caps.offloads.ethertype_match ==
 	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
 		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		requested_features &= ~netdev_stag_vlan_offload_features;
+		netdev_features_clear(&requested_features,
+				      netdev_stag_vlan_offload_features);
 	}
 
 	return requested_features;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index d71c226ae5af..9078659838a9 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5794,7 +5794,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_features_set(&features,
 						    NETIF_VLAN_FILTERING_FEATURES);
 			} else if (!req_ctag && !req_stag) {
-				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_clear(&features,
+						      NETIF_VLAN_FILTERING_FEATURES);
 			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
 				   (!cur_stag && req_stag && !cur_ctag)) {
 				netdev_features_set(&features,
@@ -5802,7 +5803,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
 			} else if ((cur_ctag && !req_ctag && cur_stag) ||
 				   (cur_stag && !req_stag && cur_ctag)) {
-				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_clear(&features,
+						      NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
 			}
 		} else {
@@ -5818,7 +5820,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	if ((features & netdev_ctag_vlan_offload_features) &&
 	    (features & netdev_stag_vlan_offload_features)) {
 		netdev_warn(netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		features &= ~netdev_stag_vlan_offload_features;
+		netdev_features_clear(&features,
+				      netdev_stag_vlan_offload_features);
 	}
 
 	return features;
@@ -8914,7 +8917,7 @@ ice_features_check(struct sk_buff *skb,
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
 	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
@@ -8945,7 +8948,7 @@ ice_features_check(struct sk_buff *skb,
 
 	return features;
 out_rm_features:
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index fbc3467a36ce..85a008905dcc 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2665,8 +2665,8 @@ static netdev_features_t
 jme_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	if (netdev->mtu > 1900) {
-		features &= ~NETIF_F_ALL_TSO;
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index c6f608388dff..8e7abdc8fd9d 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -1275,8 +1275,8 @@ static void mvpp2_set_hw_csum(struct mvpp2_port *port,
 	 * has 7 bits, so the maximum L3 offset is 128.
 	 */
 	if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-		port->dev->features &= ~csums;
-		port->dev->hw_features &= ~csums;
+		netdev_active_features_clear(port->dev, csums);
+		netdev_hw_features_clear(port->dev, csums);
 	} else {
 		netdev_active_features_set(port->dev, csums);
 		netdev_hw_features_set(port->dev, csums);
@@ -1341,8 +1341,9 @@ static int mvpp2_bm_update_mtu(struct net_device *dev, int mtu)
 
 		/* Update L4 checksum when jumbo enable/disable on port */
 		if (new_long_pool == MVPP2_BM_JUMBO && port->id != 0) {
-			dev->features &= ~netdev_ip_csum_features;
-			dev->hw_features &= ~netdev_ip_csum_features;
+			netdev_active_features_clear(dev,
+						     netdev_ip_csum_features);
+			netdev_hw_features_clear(dev, netdev_ip_csum_features);
 		} else {
 			netdev_active_features_set(dev,
 						   netdev_ip_csum_features);
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index 74b91fddd036..76254d483e9f 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4318,7 +4318,7 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
 		netdev_feature_del(NETIF_F_TSO_BIT, &features);
 		netdev_feature_del(NETIF_F_SG_BIT, &features);
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 5557bae234b1..55216e1eed59 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3899,8 +3899,9 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	if (eth->hwlro)
 		netdev_hw_feature_add(eth->netdev[id], NETIF_F_LRO_BIT);
 
-	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
-		~netdev_ctag_vlan_offload_features;
+	eth->netdev[id]->vlan_features =
+		netdev_features_andnot(*eth->soc->hw_features,
+				       netdev_ctag_vlan_offload_features);
 	netdev_active_features_set(eth->netdev[id], *eth->soc->hw_features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index ba8fdfc3b33a..d9fa50d5ef69 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2695,7 +2695,8 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			features &= ~netdev_csum_gso_features_mask;
+			netdev_features_clear(&features,
+					      netdev_csum_gso_features_mask);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index f0f6251a5d87..c323b27c4883 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -121,7 +121,7 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 static inline bool
@@ -161,7 +161,7 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
-{ return features & ~netdev_csum_gso_features_mask; }
+{ return netdev_features_andnot(features, netdev_csum_gso_features_mask); }
 
 static inline bool
 mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bfbbc3bc152b..50ceeab2540d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4468,7 +4468,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	return features & ~netdev_csum_gso_features_mask;
+	return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 }
 
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 9bda15a858d6..0c605cb98ded 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1799,7 +1799,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * metadata prepend - 8B
 		 */
 		if (unlikely(hdrlen > NFP_NET_LSO_MAX_HDR_SZ - 8))
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(&features, NETIF_F_GSO_MASK);
 	}
 
 	/* VXLAN/GRE check */
@@ -1811,7 +1811,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features & ~netdev_csum_gso_features_mask;
+		return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -1820,7 +1820,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr))))
-		return features & ~netdev_csum_gso_features_mask;
+		return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
index 4652884248be..c55623f3709b 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_param.c
@@ -489,7 +489,7 @@ void pch_gbe_check_options(struct pch_gbe_adapter *adapter)
 		val = XsumTX;
 		pch_gbe_validate_option(&val, &opt, adapter);
 		if (!val)
-			dev->features &= ~NETIF_F_CSUM_MASK;
+			netdev_active_features_clear(dev, NETIF_F_CSUM_MASK);
 	}
 	{ /* Flow Control */
 		static const struct pch_gbe_option opt = {
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index c330ea873300..12301e08c52f 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1548,7 +1548,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 
 	netdev_hw_features_set(netdev, netdev->hw_enc_features);
 	netdev_active_features_set(netdev, netdev->hw_features);
-	features = netdev->features & ~NETIF_F_VLAN_FEATURES;
+	features = netdev_active_features_andnot(netdev,
+						 NETIF_F_VLAN_FEATURES);
 	netdev_vlan_features_set(netdev, features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a6f28549f4b4..53c83e1901d7 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1790,12 +1790,13 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
 			      ntohs(udp_hdr(skb)->dest) != gnv_port))
-				return features & ~netdev_csum_gso_features_mask;
+				return netdev_features_andnot(features,
+							      netdev_csum_gso_features_mask);
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			return features & ~netdev_csum_gso_features_mask;
+			return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 		}
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 503d18280559..5da115f30b69 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1057,7 +1057,8 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 		netdev_features_clear_array(&qlcnic_csum_feature_set, &features);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			features &= ~netdev_general_tso_features;
+			netdev_features_clear(&features,
+					      netdev_general_tso_features);
 		adapter->rx_csum = 0;
 	}
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index d9f92be3e246..80caddaf0c3d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1443,12 +1443,12 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (dev->mtu > TD_MSS_MAX)
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 
 	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06) {
-		features &= ~NETIF_F_CSUM_MASK;
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 	}
 
 	return features;
@@ -4387,15 +4387,15 @@ static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
 	    ip_hdrlen(skb) > sizeof(struct iphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 
 	/* IPv4 TCP header has options field */
 	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
 		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 
 	else if (rtl_last_frag_len(skb) <= 6)
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 
 	return features;
 }
@@ -4412,18 +4412,18 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 
 		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_ALL_TSO;
+			netdev_features_clear(&features, NETIF_F_ALL_TSO);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* work around hw bug on some chip versions */
 		if (skb->len < ETH_ZLEN)
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 
 		if (rtl_quirk_packet_padto(tp, skb))
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 
 		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 	}
 
 	return vlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 77aee7b35585..e1d273770336 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1021,12 +1021,12 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_clear(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
-	tmp = net_dev->features & ~efx->fixed_features;
+	tmp = netdev_active_features_andnot(net_dev, efx->fixed_features);
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index def02fe850af..57fcebde8198 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -217,7 +217,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EFX_FILTER_PRI_MANUAL);
 		if (rc)
@@ -415,7 +415,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 * features which are fixed now
 	 */
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -1367,10 +1367,12 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~NETIF_F_GSO_MASK;
+				netdev_features_clear(&features,
+						      NETIF_F_GSO_MASK);
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_clear(&features,
+						      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index 1ef24fb2315d..5914f1ca989d 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -636,7 +636,7 @@ static void ef4_start_datapath(struct ef4_nic *efx)
 	 * features which are fixed now
 	 */
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -2186,7 +2186,7 @@ static int ef4_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->features & ~data;
+	tmp = netdev_active_features_andnot(net_dev, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
@@ -2912,7 +2912,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	netdev_active_feature_add(net_dev, NETIF_F_RXCSUM_BIT);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
-	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
+	net_dev->hw_features = netdev_active_features_andnot(net_dev,
+							     efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index a18f5fc16b20..d9e7e729e507 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -1003,13 +1003,13 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_clear(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_array(net_dev, &efx_vlan_feature_set);
 
 	netdev_hw_features_set(net_dev,
-			       net_dev->features & ~efx->fixed_features);
+			       netdev_active_features_andnot(net_dev, efx->fixed_features));
 
 	/* Disable receiving frames with bad FCS, by default. */
 	netdev_active_feature_del(net_dev, NETIF_F_RXALL_BIT);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 1c7a4ee1723f..0284eb688121 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -412,7 +412,7 @@ static void efx_start_datapath(struct efx_nic *efx)
 	 * features which are fixed now
 	 */
 	netdev_hw_features_set(efx->net_dev, efx->net_dev->features);
-	efx->net_dev->hw_features &= ~efx->fixed_features;
+	netdev_hw_features_clear(efx->net_dev, efx->fixed_features);
 	netdev_active_features_set(efx->net_dev, efx->fixed_features);
 	if (efx->net_dev->features != old_features)
 		netdev_features_change(efx->net_dev);
@@ -1378,10 +1378,12 @@ netdev_features_t efx_siena_features_check(struct sk_buff *skb,
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				features &= ~(NETIF_F_GSO_MASK);
+				netdev_features_clear(&features,
+						      (NETIF_F_GSO_MASK));
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_clear(&features,
+						      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 8028c1e4d65b..e6a13888d4c8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5609,7 +5609,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 		netdev_feature_del(NETIF_F_RXCSUM_BIT, &features);
 
 	if (!priv->plat->tx_coe)
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 
 	/* Some GMAC devices have a bugged Jumbo frame support that
 	 * needs to have the Tx COE disabled for oversized frames
@@ -5617,7 +5617,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	 * the TX csum insertion in the TDES and not use SF.
 	 */
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 0737794728a2..cd6d771cf191 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1366,7 +1366,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	offloads.ip_v4_csum = NDIS_OFFLOAD_PARAMETERS_TX_RX_DISABLED;
 
 	/* Reset previously set hw_features flags */
-	net->hw_features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	netdev_hw_features_clear(net, NETVSC_SUPPORTED_HW_FEATURES);
 	net_device_ctx->tx_checksum_mask = 0;
 
 	/* Compute tx offload settings based on hw capabilities */
@@ -1432,7 +1432,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	 * net->features list as they're no longer supported.
 	 */
 	netdev_features_fill(&features);
-	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	netdev_features_clear(&features, NETVSC_SUPPORTED_HW_FEATURES);
 	netdev_features_set(&features, net->hw_features);
 	net->features &= features;
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 912570321bfd..e87272042e19 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -329,7 +329,7 @@ static void ifb_setup(struct net_device *dev)
 	netdev_active_features_set(dev, ifb_features);
 	netdev_hw_features_set(dev, dev->features);
 	netdev_hw_enc_features_set(dev, dev->features);
-	ifb_features &= ~netdev_tx_vlan_features;
+	netdev_features_clear(&ifb_features, netdev_tx_vlan_features);
 	netdev_vlan_features_set(dev, ifb_features);
 
 	dev->flags |= IFF_NOARP;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 3d96a990eded..e719b457e4e8 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -258,7 +258,7 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 
 	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(&tmp);
-	tmp &= ~IPVLAN_FEATURES;
+	netdev_features_clear(&tmp, IPVLAN_FEATURES);
 	netdev_features_set(&tmp, ipvlan->sfeatures);
 	features &= tmp;
 	features = netdev_increment_features(ipvlan->phy_dev->features,
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c8ee65e9c170..84312e717720 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3434,7 +3434,7 @@ static DECLARE_NETDEV_FEATURE_SET(sw_macsec_feature_set,
  *   HW_MACSEC - no reason to report it
  */
 #define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~macsec_no_inherit_features)
+	(netdev_active_features_andnot((dev), macsec_no_inherit_features))
 
 static int macsec_dev_init(struct net_device *dev)
 {
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 16d2763fc227..956e93aaa25a 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1103,7 +1103,7 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 
 	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(&tmp);
-	tmp &= ~MACVLAN_FEATURES;
+	netdev_features_clear(&tmp, MACVLAN_FEATURES);
 	netdev_features_set(&tmp, vlan->set_features);
 	features &= tmp;
 	mask = features;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 2aaf3a8789f3..5b501e5069cb 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2017,7 +2017,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(&features, NETIF_F_ONE_FOR_ALL);
 	netdev_features_set(&features, NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 4f067242d634..7d4ac857555c 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1005,7 +1005,8 @@ static int tun_net_init(struct net_device *dev)
 	netdev_hw_features_set_array(dev, &tun_hw_feature_set);
 	dev->features = dev->hw_features;
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
+	dev->vlan_features = netdev_active_features_andnot(dev,
+							   netdev_tx_vlan_features);
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
@@ -1178,7 +1179,7 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 	netdev_features_t tmp1, tmp2;
 
 	tmp1 = features & tun->set_features;
-	tmp2 = features & ~TUN_USER_FEATURES;
+	tmp2 = netdev_features_andnot(features, TUN_USER_FEATURES);
 	return netdev_features_or(tmp1, tmp2);
 }
 
@@ -2894,7 +2895,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 		return -EINVAL;
 
 	tun->set_features = features;
-	tun->dev->wanted_features &= ~TUN_USER_FEATURES;
+	netdev_wanted_features_clear(tun->dev, TUN_USER_FEATURES);
 	netdev_wanted_features_set(tun->dev, features);
 	netdev_update_features(tun->dev);
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index d3dfd9f0fda9..e8db2e8cb755 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4294,7 +4294,7 @@ static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 	struct lan78xx_net *dev = netdev_priv(netdev);
 
 	if (skb->len > LAN78XX_TSO_SIZE(dev))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	features = vxlan_features_check(skb, features);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 52489af158e6..c457b4252c68 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2768,9 +2768,9 @@ rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
 	    skb_transport_offset(skb) > max_offset)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(&features, netdev_csum_gso_features_mask);
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&features, NETIF_F_GSO_MASK);
 
 	return features;
 }
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ef4bb4e63d70..c4805165eb65 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1464,7 +1464,7 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 		struct veth_priv *peer_priv = netdev_priv(peer);
 
 		if (peer_priv->_xdp_prog)
-			features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_features_clear(&features, NETIF_F_GSO_SOFTWARE);
 	}
 	if (priv->_xdp_prog)
 		netdev_feature_add(NETIF_F_GRO_BIT, &features);
@@ -1564,7 +1564,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 
 		if (!old_prog) {
-			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_hw_features_clear(peer, NETIF_F_GSO_SOFTWARE);
 			peer->max_mtu = max_mtu;
 		}
 	}
@@ -1654,7 +1654,8 @@ static void veth_setup(struct net_device *dev)
 	netdev_features_set_array(&veth_feature_set, &veth_features);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netdev_active_features_set(dev, veth_features);
-	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
+	dev->vlan_features = netdev_active_features_andnot(dev,
+							   netdev_vlan_offload_features);
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index b86820386f60..ec24cef62a3a 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3391,8 +3391,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 		}
 	}
 
-	netdev->vlan_features = netdev->hw_features &
-				~netdev_ctag_vlan_offload_features;
+	netdev->vlan_features = netdev_hw_features_andnot(netdev,
+							  netdev_ctag_vlan_offload_features);
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index dc54367e4e92..faeb7bcc0cf2 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -277,7 +277,8 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features & ~netdev_csum_gso_features_mask;
+			return netdev_features_andnot(features,
+						      netdev_csum_gso_features_mask);
 		}
 
 		switch (l4_proto) {
@@ -288,11 +289,12 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				return features & ~netdev_csum_gso_features_mask;
+				return netdev_features_andnot(features,
+							      netdev_csum_gso_features_mask);
 			}
 			break;
 		default:
-			return features & ~netdev_csum_gso_features_mask;
+			return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 		}
 	}
 	return features;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index ee66440cbb22..ad8e312e9ae0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -617,7 +617,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	netdev_features_set(&hw->netdev_features, *mvm->cfg->features);
 	if (!iwl_mvm_is_csum_supported(mvm))
-		hw->netdev_features &= ~IWL_CSUM_NETIF_FLAGS_MASK;
+		netdev_features_clear(&hw->netdev_features,
+				      IWL_CSUM_NETIF_FLAGS_MASK);
 
 	if (mvm->cfg->vht_mu_mimo_supported)
 		wiphy_ext_feature_set(hw->wiphy,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index e110ac000e88..6ac083a84597 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -909,7 +909,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
-		netdev_flags &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&netdev_flags, NETIF_F_CSUM_MASK);
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 8118c2dae6c9..7889ca14213e 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6822,7 +6822,7 @@ void qeth_enable_hw_features(struct net_device *dev)
 	/* force-off any feature that might need an IPA sequence.
 	 * netdev_update_features() will restart them.
 	 */
-	dev->features &= ~dev->hw_features;
+	netdev_active_features_clear(dev, dev->hw_features);
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
 		netdev_active_feature_del(dev,
@@ -6955,7 +6955,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
-				features &= ~restricted;
+				netdev_features_clear(&features, restricted);
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
@@ -6963,7 +6963,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   &restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				features &= ~restricted;
+				netdev_features_clear(&features, restricted);
 			break;
 		default:
 			break;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 2e67d69d6ac7..43c17f542583 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4583,7 +4583,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
-	ndev->vlan_features &= ~netdev_ctag_vlan_features;
+	netdev_vlan_features_clear(ndev, netdev_ctag_vlan_features);
 
 	if (test_bit(QL_DMA64, &qdev->flags))
 		netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
diff --git a/include/linux/netdev_features_helper.h b/include/linux/netdev_features_helper.h
index e529e1cbde51..3732d8a81b9f 100644
--- a/include/linux/netdev_features_helper.h
+++ b/include/linux/netdev_features_helper.h
@@ -703,7 +703,7 @@ netdev_get_wanted_features(struct net_device *dev)
 {
 	netdev_features_t tmp;
 
-	tmp = dev->features & ~dev->hw_features;
+	tmp = netdev_active_features_andnot(dev, dev->hw_features);
 	return netdev_wanted_features_or(dev, tmp);
 }
 
diff --git a/include/net/sock.h b/include/net/sock.h
index a7273b289188..d7196cd8cc1e 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -44,6 +44,7 @@
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>	/* struct sk_buff */
 #include <linux/mm.h>
 #include <linux/security.h>
@@ -2168,7 +2169,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
 static inline void sk_gso_disable(struct sock *sk)
 {
 	sk->sk_gso_disabled = 1;
-	sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(&sk->sk_route_caps, NETIF_F_GSO_MASK);
 }
 
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 60a8675976c2..8c3dc6c3bad9 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -373,7 +373,7 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
 	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto))))
-		return features & ~netdev_csum_gso_features_mask;
+		return netdev_features_andnot(features, netdev_csum_gso_features_mask);
 
 	return features;
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 42eab811f8a1..e08bbe2ae55b 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -113,7 +113,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 	ret &= real_dev->hw_enc_features;
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
-		ret &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&ret, NETIF_F_CSUM_MASK);
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, &ret);
 		return ret;
 	}
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 24c812234a79..56f9b0233d51 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -585,7 +585,8 @@ static int vlan_dev_init(struct net_device *dev)
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
-	dev->vlan_features = real_dev->vlan_features & ~NETIF_F_ALL_FCOE;
+	dev->vlan_features = netdev_vlan_features_andnot(real_dev,
+							 NETIF_F_ALL_FCOE);
 	dev->hw_enc_features = vlan_tnl_features(real_dev);
 	dev->mpls_features = real_dev->mpls_features;
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index a84a7cfb9d6d..4b5cec64df79 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -542,7 +542,7 @@ netdev_features_t br_features_recompute(struct net_bridge *br,
 		return features;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(&features, NETIF_F_ONE_FOR_ALL);
 
 	list_for_each_entry(p, &br->port_list, list) {
 		features = netdev_increment_features(features,
diff --git a/net/core/dev.c b/net/core/dev.c
index 7ba5ac96bbeb..ca5dc39cd412 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3488,7 +3488,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(&features, netdev_csum_gso_features_mask);
 	}
 	if (illegal_highdma(skb->dev, skb))
 		netdev_feature_del(NETIF_F_SG_BIT, &features);
@@ -3518,11 +3518,11 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
 	if (gso_segs > READ_ONCE(dev->gso_max_segs))
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		return netdev_features_andnot(features, NETIF_F_GSO_MASK);
 	}
 
 	/* Support for GSO partial features requires software
@@ -3532,7 +3532,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(&features, dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -9611,13 +9611,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~netdev_ip_csum_features;
+		netdev_features_clear(&features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
 	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(&features, NETIF_F_ALL_TSO);
 	}
 
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
@@ -9654,7 +9654,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	    !(features & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(&features, dev->gso_partial_features);
 	}
 
 	if (!(features & NETIF_F_RXCSUM)) {
@@ -11164,7 +11164,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_set(&all, tmp);
 
 	netdev_features_fill(&tmp);
-	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	netdev_features_clear(&tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_set(&tmp, one);
 	all &= tmp;
 
@@ -11172,7 +11172,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, &tmp);
-		all &= ~tmp;
+		netdev_features_clear(&all, tmp);
 	}
 
 	return all;
diff --git a/net/core/sock.c b/net/core/sock.c
index 456ce67fbb08..7dc8b734e807 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2322,10 +2322,10 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		netdev_features_set(&sk->sk_route_caps, NETIF_F_GSO_SOFTWARE);
 	if (unlikely(sk->sk_gso_disabled))
-		sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(&sk->sk_route_caps, NETIF_F_GSO_MASK);
 	if (sk_can_gso(sk)) {
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
-			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(&sk->sk_route_caps, NETIF_F_GSO_MASK);
 		} else {
 			netdev_feature_add(NETIF_F_SG_BIT, &sk->sk_route_caps);
 			netdev_feature_add(NETIF_F_HW_CSUM_BIT, &sk->sk_route_caps);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index f99fcbb224d4..0ecaef5605f9 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -296,7 +296,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (edata.data)
 		netdev_wanted_features_set(dev, mask);
 	else
-		dev->wanted_features &= ~mask;
+		netdev_wanted_features_clear(dev, mask);
 
 	__netdev_update_features(dev);
 
@@ -358,11 +358,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	/* allow changing only bits set in hw_features */
 	changed = netdev_active_features_xor(dev, features);
 	changed &= eth_all_features;
-	tmp = changed & ~dev->hw_features;
+	tmp = netdev_hw_features_andnot_r(dev, changed);
 	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features &= ~changed;
+	netdev_wanted_features_clear(dev, changed);
 	tmp = features & changed;
 	netdev_wanted_features_set(dev, tmp);
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 421ce8c28932..14982fb7bfbb 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -193,7 +193,7 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * that were in features originally, and also is in NETIF_F_ONE_FOR_ALL,
 	 * may become enabled.
 	 */
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(&features, NETIF_F_ONE_FOR_ALL);
 	hsr_for_each_port(hsr, port)
 		features = netdev_increment_features(features,
 						     port->dev->features,
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 619240be4b5e..adfc4c7e36bf 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -219,12 +219,12 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM)) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	}
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 04586ad67183..228beaf40f42 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -773,8 +773,8 @@ static void ipgre_link_update(struct net_device *dev, bool set_mtu)
 
 	if (flags & TUNNEL_SEQ ||
 	    (flags & TUNNEL_CSUM && tunnel->encap.type != TUNNEL_ENCAP_NONE)) {
-		dev->features &= ~NETIF_F_GSO_SOFTWARE;
-		dev->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+		netdev_active_features_clear(dev, NETIF_F_GSO_SOFTWARE);
+		netdev_hw_features_clear(dev, NETIF_F_GSO_SOFTWARE);
 	} else {
 		netdev_active_features_set(dev, NETIF_F_GSO_SOFTWARE);
 		netdev_hw_features_set(dev, NETIF_F_GSO_SOFTWARE);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 9ca2620de9ea..2b9a127e6a20 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -264,7 +264,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 */
 	features = netif_skb_features(skb);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 2ac8360a2922..c4cf8fb52448 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	 * instead set the flag based on our outer checksum offload value.
 	 */
 	if (remcsum) {
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&features, NETIF_F_CSUM_MASK);
 		if (!need_csum || offload_csum)
 			netdev_feature_add(NETIF_F_HW_CSUM_BIT, &features);
 	}
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 8c09c2cec0f5..ee83f7f2947c 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -257,11 +257,11 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM)) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = netdev_features_andnot(features, NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, &esp_features);
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f8fca2a3af3a..80f74d32e2ff 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -149,7 +149,7 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * egress MTU.
 	 */
 	features = netif_skb_features(skb);
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
 		return -ENOMEM;
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index a43a58a73d09..135e943a4613 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1743,7 +1743,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		netdev_features_t features = netif_skb_features(skb);
 		unsigned int slen = 0, numsegs = 0;
 
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 5449ed114e40..b1e4948256ef 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -415,7 +415,7 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 	struct sk_buff *segs;
 	netdev_features_t features = netif_skb_features(skb);
 
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 
 	if (IS_ERR_OR_NULL(segs)) {
 		qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 0b941dd63d26..afde3f7126a1 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -463,7 +463,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		struct sk_buff *segs, *nskb;
 		int ret;
 
-		segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+		segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
 
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 72102277449e..6e4fe9e7dec1 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -12,6 +12,7 @@
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/errno.h>
+#include <linux/netdev_features_helper.h>
 #include <linux/skbuff.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
@@ -210,7 +211,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
-	segs = skb_gso_segment(skb, features & ~NETIF_F_GSO_MASK);
+	segs = skb_gso_segment(skb, netdev_features_andnot(features, NETIF_F_GSO_MASK));
 
 	if (IS_ERR_OR_NULL(segs))
 		return qdisc_drop(skb, sch, to_free);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 63ad940853e0..b14259162313 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -116,7 +116,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (!(features & NETIF_F_HW_ESP)) {
 		esp_features = features;
 		netdev_feature_del(NETIF_F_SG_BIT, &esp_features);
-		esp_features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(&esp_features, NETIF_F_CSUM_MASK);
 	}
 
 	sp = skb_sec_path(skb);
-- 
2.33.0

