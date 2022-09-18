Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 488445BBCF8
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiIRJvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7254FE016
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4MVjf91PLqzHnhm;
        Sun, 18 Sep 2022 17:47:45 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:51 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 28/55] treewide: use netdev_features_andnot/clear helpers
Date:   Sun, 18 Sep 2022 09:43:09 +0000
Message-ID: <20220918094336.28958-29-shenjian15@huawei.com>
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

Replace the 'f1 = f2 & ~f3' features expressions by
netdev_features_andnot helpers, and replace the
'f1 &= ~f2' expressions by netdev_features_clear helpers.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 arch/um/drivers/vector_kern.c                 |  2 +-
 drivers/net/bonding/bond_main.c               |  4 ++--
 drivers/net/bonding/bond_options.c            |  4 ++--
 drivers/net/ethernet/3com/typhoon.c           |  2 +-
 drivers/net/ethernet/atheros/alx/main.c       |  2 +-
 .../net/ethernet/atheros/atl1c/atl1c_main.c   |  3 ++-
 drivers/net/ethernet/broadcom/bnx2.c          |  2 +-
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  8 ++++---
 drivers/net/ethernet/broadcom/tg3.c           |  5 ++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  3 ++-
 drivers/net/ethernet/cisco/enic/enic_main.c   |  3 ++-
 drivers/net/ethernet/cortina/gemini.c         |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c   |  8 ++++---
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   |  5 ++--
 drivers/net/ethernet/ibm/ibmveth.c            | 11 +++++----
 drivers/net/ethernet/ibm/ibmvnic.c            |  2 +-
 drivers/net/ethernet/intel/e1000e/netdev.c    |  6 +++--
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   |  3 ++-
 drivers/net/ethernet/intel/i40e/i40e_main.c   |  5 ++--
 drivers/net/ethernet/intel/iavf/iavf_main.c   |  8 ++++---
 drivers/net/ethernet/intel/ice/ice_main.c     | 17 ++++++++-----
 drivers/net/ethernet/jme.c                    |  4 ++--
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   |  9 +++----
 drivers/net/ethernet/marvell/sky2.c           |  2 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c   |  4 ++--
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  9 ++++---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  |  8 +++++--
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  3 ++-
 .../ethernet/netronome/nfp/nfp_net_common.c   | 11 +++++----
 .../ethernet/oki-semi/pch_gbe/pch_gbe_param.c |  2 +-
 .../net/ethernet/pensando/ionic/ionic_lif.c   |  3 ++-
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 11 ++++++---
 .../net/ethernet/qlogic/qlcnic/qlcnic_hw.c    |  3 ++-
 drivers/net/ethernet/realtek/r8169_main.c     | 20 ++++++++--------
 drivers/net/ethernet/sfc/efx.c                |  4 ++--
 drivers/net/ethernet/sfc/efx_common.c         | 10 ++++----
 drivers/net/ethernet/sfc/falcon/efx.c         |  7 +++---
 drivers/net/ethernet/sfc/siena/efx.c          |  5 ++--
 drivers/net/ethernet/sfc/siena/efx_common.c   |  8 ++++---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c |  4 ++--
 drivers/net/hyperv/rndis_filter.c             |  4 ++--
 drivers/net/ifb.c                             |  2 +-
 drivers/net/ipvlan/ipvlan_main.c              |  2 +-
 drivers/net/macsec.c                          | 16 +++++++++----
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/team/team.c                       |  2 +-
 drivers/net/tun.c                             |  7 +++---
 drivers/net/usb/lan78xx.c                     |  2 +-
 drivers/net/usb/r8152.c                       |  5 ++--
 drivers/net/veth.c                            |  7 +++---
 drivers/net/vmxnet3/vmxnet3_drv.c             |  4 ++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 12 +++++++---
 .../net/wireless/intel/iwlwifi/mvm/mac80211.c |  3 ++-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c   |  2 +-
 drivers/s390/net/qeth_core_main.c             |  6 ++---
 drivers/staging/qlge/qlge_main.c              |  2 +-
 include/linux/netdev_feature_helpers.h        |  2 +-
 include/net/sock.h                            |  3 ++-
 include/net/vxlan.h                           |  6 +++--
 net/8021q/vlan.h                              |  2 +-
 net/8021q/vlan_dev.c                          |  3 ++-
 net/bridge/br_if.c                            |  2 +-
 net/core/dev.c                                | 24 +++++++++++--------
 net/core/sock.c                               |  5 ++--
 net/ethtool/features.c                        |  2 +-
 net/ethtool/ioctl.c                           | 12 +++++-----
 net/hsr/hsr_device.c                          |  2 +-
 net/ipv4/esp4_offload.c                       |  6 +++--
 net/ipv4/ip_gre.c                             |  4 ++--
 net/ipv4/ip_output.c                          |  2 +-
 net/ipv4/udp_offload.c                        |  2 +-
 net/ipv6/esp6_offload.c                       |  6 +++--
 net/ipv6/ip6_output.c                         |  2 +-
 net/mac80211/main.c                           |  4 +++-
 net/sched/sch_cake.c                          |  2 +-
 net/sched/sch_netem.c                         |  2 +-
 net/sched/sch_taprio.c                        |  2 +-
 net/sched/sch_tbf.c                           |  3 ++-
 net/xfrm/xfrm_device.c                        |  2 +-
 80 files changed, 246 insertions(+), 166 deletions(-)

diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 70b76c41e314..9920c4cb8aa3 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -1339,7 +1339,7 @@ static void vector_net_tx_timeout(struct net_device *dev, unsigned int txqueue)
 static netdev_features_t vector_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
-	features &= ~netdev_ip_csum_features;
+	netdev_features_clear(features, netdev_ip_csum_features);
 	return features;
 }
 
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0756d00f09e5..b8f8ba623c9e 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -1408,12 +1408,12 @@ static netdev_features_t bond_fix_features(struct net_device *dev,
 	if (bond_sk_check(bond))
 		netdev_features_set(features, BOND_TLS_FEATURES);
 	else
-		features &= ~BOND_TLS_FEATURES;
+		netdev_features_clear(features, BOND_TLS_FEATURES);
 #endif
 
 	mask = features;
 
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 
 	bond_for_each_slave(bond, slave, iter) {
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 31fa1a65231d..020e5478c039 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -837,7 +837,7 @@ static bool bond_set_xfrm_features(struct bonding *bond)
 	if (BOND_MODE(bond) == BOND_MODE_ACTIVEBACKUP)
 		netdev_wanted_features_set(bond->dev, BOND_XFRM_FEATURES);
 	else
-		bond->dev->wanted_features &= ~BOND_XFRM_FEATURES;
+		netdev_wanted_features_clear(bond->dev, BOND_XFRM_FEATURES);
 
 	return true;
 }
@@ -850,7 +850,7 @@ static bool bond_set_tls_features(struct bonding *bond)
 	if (bond_sk_check(bond))
 		netdev_wanted_features_set(bond->dev, BOND_TLS_FEATURES);
 	else
-		bond->dev->wanted_features &= ~BOND_TLS_FEATURES;
+		netdev_wanted_features_clear(bond->dev, BOND_TLS_FEATURES);
 
 	return true;
 }
diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index d72f1ef73484..6fb1efbe674f 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2266,7 +2266,7 @@ static netdev_features_t typhoon_features_check(struct sk_buff *skb,
 						netdev_features_t features)
 {
 	if (skb_shinfo(skb)->nr_frags > 32 && skb_is_gso(skb))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	return vxlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 92a0d382795b..db35ffb830de 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1102,7 +1102,7 @@ static netdev_features_t alx_fix_features(struct net_device *netdev,
 					  netdev_features_t features)
 {
 	if (netdev->mtu > ALX_MAX_TSO_PKT_SIZE)
-		features &= ~netdev_general_tso_features;
+		netdev_features_clear(features, netdev_general_tso_features);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
index 946f7edc0b8e..2562f5e443b0 100644
--- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
+++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
@@ -521,7 +521,8 @@ static netdev_features_t atl1c_fix_features(struct net_device *netdev,
 
 	if (hw->nic_type != athr_mt) {
 		if (netdev->mtu > MAX_TSO_FRAME_SIZE)
-			features &= ~netdev_general_tso_features;
+			netdev_features_clear(features,
+					      netdev_general_tso_features);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 39d9ac51ca62..d1e45b7752d0 100644
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
index a46c7bbb7e9b..5466966a2243 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12874,7 +12874,7 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 	if (unlikely(skb_is_gso(skb) &&
 		     (skb_shinfo(skb)->gso_size > 9000) &&
 		     !skb_gso_validate_mac_len(skb, 9700)))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	return vxlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index a6d66ca75886..d1664fdfc980 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11195,14 +11195,15 @@ static netdev_features_t bnxt_fix_features(struct net_device *dev,
 	vlan_features = features & BNXT_HW_FEATURE_VLAN_ALL_RX;
 	if (vlan_features != BNXT_HW_FEATURE_VLAN_ALL_RX) {
 		if (dev->features & BNXT_HW_FEATURE_VLAN_ALL_RX)
-			features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+			netdev_features_clear(features,
+					      BNXT_HW_FEATURE_VLAN_ALL_RX);
 		else if (vlan_features)
 			netdev_features_set(features,
 					    BNXT_HW_FEATURE_VLAN_ALL_RX);
 	}
 #ifdef CONFIG_BNXT_SRIOV
 	if (BNXT_VF(bp) && bp->vf.vlan)
-		features &= ~BNXT_HW_FEATURE_VLAN_ALL_RX;
+		netdev_features_clear(features, BNXT_HW_FEATURE_VLAN_ALL_RX);
 #endif
 	return features;
 }
@@ -11392,7 +11393,8 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 			return features;
 		break;
 	}
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5e1ede8bd049..c5b75539bb7f 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7878,7 +7878,8 @@ static int tg3_tso_bug(struct tg3 *tp, struct tg3_napi *tnapi,
 		netif_tx_wake_queue(txq);
 	}
 
-	features = tp->dev->features & ~netdev_general_tso_features;
+	netdev_features_andnot(features, tp->dev->features,
+			       netdev_general_tso_features);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR(segs) || !segs)
 		goto tg3_tso_bug_end;
@@ -8309,7 +8310,7 @@ static netdev_features_t tg3_fix_features(struct net_device *dev,
 	struct tg3 *tp = netdev_priv(dev);
 
 	if (dev->mtu > ETH_DATA_LEN && tg3_flag(tp, 5780_CLASS))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 4ca7dc2bbf12..da5989ec5bd2 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3852,7 +3852,8 @@ static netdev_features_t cxgb_features_check(struct sk_buff *skb,
 		return features;
 
 	/* Offload is not supported for this encapsulated packet */
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 static netdev_features_t cxgb_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index dc8a4b63d461..7e1cca8b787b 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -295,7 +295,8 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	return features;
 
 out:
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 int enic_is_dynamic(struct enic *enic)
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 2bd0892f5f53..96423bf6ed2d 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1982,7 +1982,7 @@ static netdev_features_t gmac_fix_features(struct net_device *netdev,
 					   netdev_features_t features)
 {
 	if (netdev->mtu + ETH_HLEN + VLAN_HLEN > MTU_SIZE_BIT_MASK)
-		features &= ~GMAC_OFFLOAD_FEATURES;
+		netdev_features_clear(features, GMAC_OFFLOAD_FEATURES);
 
 	return features;
 }
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index bbfa177199c8..fc1345fa42f6 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5086,7 +5086,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		if (lancer_chip(adapter) &&
 		    (skb_shinfo(skb)->gso_size < 256 ||
 		     skb_shinfo(skb)->gso_segs == 1))
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(features, NETIF_F_GSO_MASK);
 	}
 
 	/* The code below restricts offload features for some tunneled and
@@ -5121,8 +5121,10 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 	    skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
-	    udp_hdr(skb)->dest != adapter->vxlan_port)
-		return features & ~netdev_csum_gso_features_mask;
+	    udp_hdr(skb)->dest != adapter->vxlan_port) {
+		netdev_features_clear(features, netdev_csum_gso_features_mask);
+		return features;
+	}
 
 	return features;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 2073d6899106..bf7bafd465b4 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2476,7 +2476,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(features,
+				      netdev_csum_gso_features_mask);
 
 	return features;
 }
@@ -3358,7 +3359,7 @@ static void hns3_set_default_feature(struct net_device *netdev)
 				NETIF_F_GRO_HW_BIT,
 				NETIF_F_NTUPLE_BIT,
 				NETIF_F_HW_TC_BIT);
-	features = netdev->features & ~vlan_off_features;
+	netdev_features_andnot(features, netdev->features, vlan_off_features);
 	netdev_vlan_features_set(netdev, features);
 
 	netdev_hw_enc_features_set(netdev, netdev->vlan_features);
diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 215121bbc375..99f76b0c3031 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -744,7 +744,7 @@ static netdev_features_t ibmveth_fix_features(struct net_device *dev,
 	 */
 
 	if (!(features & NETIF_F_RXCSUM))
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
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
@@ -909,7 +910,8 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (rx_csum != adapter->rx_csum) {
 		rc1 = ibmveth_set_csum_offload(dev, rx_csum);
 		if (rc1 && !adapter->rx_csum) {
-			dev->features = features & ~NETIF_F_CSUM_MASK;
+			netdev_active_features_andnot(dev, features,
+						      NETIF_F_CSUM_MASK);
 			netdev_active_feature_del(dev, NETIF_F_RXCSUM_BIT);
 		}
 	}
@@ -917,7 +919,8 @@ static int ibmveth_set_features(struct net_device *dev,
 	if (large_send != adapter->large_send) {
 		rc2 = ibmveth_set_tso(dev, large_send);
 		if (rc2 && !adapter->large_send)
-			dev->features = features & ~netdev_general_tso_features;
+			netdev_active_features_andnot(dev, features,
+						      netdev_general_tso_features);
 	}
 
 	return rc1 ? rc1 : rc2;
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index e6b46fcf3a57..32e09372fe0d 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3335,7 +3335,7 @@ static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_size < 224 ||
 		    skb_shinfo(skb)->gso_segs == 1)
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(features, NETIF_F_GSO_MASK);
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index 4f8fbe326b71..7bbab2dca5c0 100644
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
index 9346cf8cdf45..da65c5487599 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1512,7 +1512,8 @@ static netdev_features_t fm10k_features_check(struct sk_buff *skb,
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
 		return features;
 
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1ad68869cfe9..30ab7f26b72d 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13203,7 +13203,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -13235,7 +13235,8 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index b1e768a8b757..03f1dd9d296d 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4403,7 +4403,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -4435,7 +4435,8 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 /**
@@ -4678,7 +4679,8 @@ iavf_fix_netdev_vlan_features(struct iavf_adapter *adapter,
 	    adapter->vlan_v2_caps.offloads.ethertype_match ==
 	    VIRTCHNL_ETHERTYPE_STRIPPING_MATCHES_INSERTION) {
 		netdev_warn(adapter->netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		requested_features &= ~netdev_stag_vlan_offload_features;
+		netdev_features_clear(requested_features,
+				      netdev_stag_vlan_offload_features);
 	}
 
 	return requested_features;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 974693a0e067..0a4ffc45cc70 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5834,7 +5834,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_features_set(features,
 						    NETIF_VLAN_FILTERING_FEATURES);
 			} else if (!req_ctag && !req_stag) {
-				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_clear(features,
+						      NETIF_VLAN_FILTERING_FEATURES);
 			} else if ((!cur_ctag && req_ctag && !cur_stag) ||
 				   (!cur_stag && req_stag && !cur_ctag)) {
 				netdev_features_set(features,
@@ -5842,7 +5843,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been enabled for both types.\n");
 			} else if ((cur_ctag && !req_ctag && cur_stag) ||
 				   (cur_stag && !req_stag && cur_ctag)) {
-				features &= ~NETIF_VLAN_FILTERING_FEATURES;
+				netdev_features_clear(features,
+						      NETIF_VLAN_FILTERING_FEATURES);
 				netdev_warn(netdev,  "802.1Q and 802.1ad VLAN filtering must be either both on or both off. VLAN filtering has been disabled for both types.\n");
 			}
 		} else {
@@ -5858,7 +5860,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	if ((features & netdev_ctag_vlan_offload_features) &&
 	    (features & netdev_stag_vlan_offload_features)) {
 		netdev_warn(netdev, "cannot support CTAG and STAG VLAN stripping and/or insertion simultaneously since CTAG and STAG offloads are mutually exclusive, clearing STAG offload settings\n");
-		features &= ~netdev_stag_vlan_offload_features;
+		netdev_features_clear(features,
+				      netdev_stag_vlan_offload_features);
 	}
 
 	if (!(netdev->features & NETIF_F_RXFCS) &&
@@ -5866,7 +5869,8 @@ ice_fix_features(struct net_device *netdev, netdev_features_t features)
 	    (features & NETIF_VLAN_STRIPPING_FEATURES) &&
 	    !ice_vsi_has_non_zero_vlans(np->vsi)) {
 		netdev_warn(netdev, "Disabling VLAN stripping as FCS/CRC stripping is also disabled and there is no VLAN configured\n");
-		features &= ~NETIF_VLAN_STRIPPING_FEATURES;
+		netdev_features_clear(features,
+				      NETIF_VLAN_STRIPPING_FEATURES);
 	}
 
 	return features;
@@ -9011,7 +9015,7 @@ ice_features_check(struct sk_buff *skb,
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
 	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
@@ -9042,7 +9046,8 @@ ice_features_check(struct sk_buff *skb,
 
 	return features;
 out_rm_features:
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/jme.c b/drivers/net/ethernet/jme.c
index cc984ad132f5..13d0de32c6f7 100644
--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -2665,8 +2665,8 @@ static netdev_features_t
 jme_fix_features(struct net_device *netdev, netdev_features_t features)
 {
 	if (netdev->mtu > 1900) {
-		features &= ~NETIF_F_ALL_TSO;
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 5a533a4e726f..369aa0a80212 100644
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
index a8b3999a275d..0e2908c8f8b2 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -4318,7 +4318,7 @@ static netdev_features_t sky2_fix_features(struct net_device *dev,
 		netdev_info(dev, "checksum offload not possible with jumbo frames\n");
 		netdev_feature_del(NETIF_F_TSO_BIT, features);
 		netdev_feature_del(NETIF_F_SG_BIT, features);
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 	}
 
 	/* Some hardware requires receive checksum for RSS to work. */
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 1cb707c987fa..50cebfe2a426 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3900,8 +3900,8 @@ static int mtk_add_mac(struct mtk_eth *eth, struct device_node *np)
 	if (eth->hwlro)
 		netdev_hw_feature_add(eth->netdev[id], NETIF_F_LRO_BIT);
 
-	eth->netdev[id]->vlan_features = *eth->soc->hw_features &
-		~netdev_ctag_vlan_offload_features;
+	netdev_vlan_features_andnot(eth->netdev[id], *eth->soc->hw_features,
+				    netdev_ctag_vlan_offload_features);
 	netdev_active_features_set(eth->netdev[id], *eth->soc->hw_features);
 	eth->netdev[id]->ethtool_ops = &mtk_ethtool_ops;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c81c54f6627e..36a1d28998b3 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2695,7 +2695,8 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			features &= ~netdev_csum_gso_features_mask;
+			netdev_features_clear(features,
+					      netdev_csum_gso_features_mask);
 	}
 
 	return features;
@@ -3384,8 +3385,10 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 		err = mlx4_get_is_vlan_offload_disabled(mdev->dev, port,
 							&vlan_offload_disabled);
 		if (!err && vlan_offload_disabled) {
-			dev->hw_features &= ~netdev_vlan_offload_features;
-			dev->features &= ~netdev_vlan_offload_features;
+			netdev_hw_features_clear(dev,
+						 netdev_vlan_offload_features);
+			netdev_active_features_clear(dev,
+						     netdev_vlan_offload_features);
 		}
 	} else {
 		if (mdev->dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_PHV_EN &&
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 7ea2f59d73ed..6f83eb46d18a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -121,7 +121,8 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 static inline bool
@@ -161,7 +162,10 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
-{ return features & ~netdev_csum_gso_features_mask; }
+{
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
+}
 
 static inline bool
 mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index bd4b6ce608bd..70ac775a53e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4474,7 +4474,8 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	return features & ~netdev_csum_gso_features_mask;
+	netdev_features_clear(features, netdev_csum_gso_features_mask);
+	return features;
 }
 
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index ca0c08673ada..943598704e9a 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1802,7 +1802,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * metadata prepend - 8B
 		 */
 		if (unlikely(hdrlen > NFP_NET_LSO_MAX_HDR_SZ - 8))
-			features &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(features, NETIF_F_GSO_MASK);
 	}
 
 	/* VXLAN/GRE check */
@@ -1814,7 +1814,8 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features & ~netdev_csum_gso_features_mask;
+		netdev_features_clear(features, netdev_csum_gso_features_mask);
+		return features;
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -1822,8 +1823,10 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr != IPPROTO_UDP && l4_hdr != IPPROTO_GRE) ||
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
-	      sizeof(struct udphdr) + sizeof(struct vxlanhdr))))
-		return features & ~netdev_csum_gso_features_mask;
+	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)))) {
+		netdev_features_clear(features, netdev_csum_gso_features_mask);
+		return features;
+	}
 
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
index eaebaac13180..7a68744b7011 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1546,7 +1546,8 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 
 	netdev_hw_features_set(netdev, netdev->hw_enc_features);
 	netdev_active_features_set(netdev, netdev->hw_features);
-	features = netdev->features & ~NETIF_F_VLAN_FEATURES;
+	netdev_features_andnot(features, netdev->features,
+			       NETIF_F_VLAN_FEATURES);
 	netdev_vlan_features_set(netdev, features);
 
 	netdev->priv_flags |= IFF_UNICAST_FLT |
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index a6f28549f4b4..2bbbc7591965 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1789,13 +1789,18 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			if ((skb_inner_mac_header(skb) -
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
-			      ntohs(udp_hdr(skb)->dest) != gnv_port))
-				return features & ~netdev_csum_gso_features_mask;
+			      ntohs(udp_hdr(skb)->dest) != gnv_port)) {
+				netdev_features_clear(features,
+						      netdev_csum_gso_features_mask);
+				return features;
+			}
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			return features & ~netdev_csum_gso_features_mask;
+			netdev_features_clear(features,
+					      netdev_csum_gso_features_mask);
+			return features;
 		}
 	}
 
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index 3149f46d603d..e2b74569ae82 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -1050,7 +1050,8 @@ static netdev_features_t qlcnic_process_flags(struct qlcnic_adapter *adapter,
 					  NETIF_F_IPV6_CSUM_BIT);
 
 		if (QLCNIC_IS_TSO_CAPABLE(adapter))
-			features &= ~netdev_general_tso_features;
+			netdev_features_clear(features,
+					      netdev_general_tso_features);
 		adapter->rx_csum = 0;
 	}
 
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index bf6da741ac44..4fe234ef92a0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -1428,12 +1428,12 @@ static netdev_features_t rtl8169_fix_features(struct net_device *dev,
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (dev->mtu > TD_MSS_MAX)
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 
 	if (dev->mtu > ETH_DATA_LEN &&
 	    tp->mac_version > RTL_GIGA_MAC_VER_06) {
-		features &= ~NETIF_F_CSUM_MASK;
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 	}
 
 	return features;
@@ -4270,15 +4270,15 @@ static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
 	    ip_hdrlen(skb) > sizeof(struct iphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 
 	/* IPv4 TCP header has options field */
 	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
 		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 
 	else if (rtl_last_frag_len(skb) <= 6)
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 
 	return features;
 }
@@ -4295,18 +4295,18 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 
 		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_ALL_TSO;
+			netdev_features_clear(features, NETIF_F_ALL_TSO);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* work around hw bug on some chip versions */
 		if (skb->len < ETH_ZLEN)
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
 		if (rtl_quirk_packet_padto(tp, skb))
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
 		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			features &= ~NETIF_F_CSUM_MASK;
+			netdev_features_clear(features, NETIF_F_CSUM_MASK);
 	}
 
 	return vlan_features_check(skb, features);
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index 9ea5f6507deb..9f6c4a971c48 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1010,14 +1010,14 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_clear(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
-	tmp = net_dev->features & ~efx->fixed_features;
+	netdev_features_andnot(tmp, net_dev->features, efx->fixed_features);
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 71f90a2c341c..9fcad774a052 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -217,7 +217,7 @@ int efx_set_features(struct net_device *net_dev, netdev_features_t data)
 	int rc;
 
 	/* If disabling RX n-tuple filtering, clear existing filters */
-	tmp = net_dev->features & ~data;
+	netdev_features_andnot(tmp, net_dev->features, data);
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
+				netdev_features_clear(features,
+						      NETIF_F_GSO_MASK);
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_clear(features,
+						      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index b30b7ccbc701..016c459a3cfd 100644
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
+	netdev_features_andnot(tmp, net_dev->features, data);
 	if (tmp & NETIF_F_NTUPLE) {
 		rc = efx->type->filter_clear_rx(efx, EF4_FILTER_PRI_MANUAL);
 		if (rc)
@@ -2908,7 +2908,8 @@ static int ef4_pci_probe(struct pci_dev *pci_dev,
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
-	net_dev->hw_features = net_dev->features & ~efx->fixed_features;
+	netdev_hw_features_andnot(net_dev, net_dev->features,
+				  efx->fixed_features);
 
 	/* Disable VLAN filtering by default.  It may be enforced if
 	 * the feature is fixed (i.e. VLAN filters are required to
diff --git a/drivers/net/ethernet/sfc/siena/efx.c b/drivers/net/ethernet/sfc/siena/efx.c
index cc988436a108..e5937694bbb1 100644
--- a/drivers/net/ethernet/sfc/siena/efx.c
+++ b/drivers/net/ethernet/sfc/siena/efx.c
@@ -993,14 +993,15 @@ static int efx_pci_probe_post_io(struct efx_nic *efx)
 		netdev_active_feature_add(net_dev, NETIF_F_TSO6_BIT);
 	/* Check whether device supports TSO */
 	if (!efx->type->tso_versions || !efx->type->tso_versions(efx))
-		net_dev->features &= ~NETIF_F_ALL_TSO;
+		netdev_active_features_clear(net_dev, NETIF_F_ALL_TSO);
 	/* Mask for features that also apply to VLAN devices */
 	netdev_vlan_features_set(net_dev, NETIF_F_ALL_TSO);
 	netdev_vlan_features_set_set(net_dev, NETIF_F_HW_CSUM_BIT,
 				     NETIF_F_SG_BIT, NETIF_F_HIGHDMA_BIT,
 				     NETIF_F_RXCSUM_BIT);
 
-	tmp = net_dev->features & ~efx->fixed_features;
+	netdev_features_andnot(tmp, net_dev->features,
+			       efx->fixed_features);
 	netdev_hw_features_set(net_dev, tmp);
 
 	/* Disable receiving frames with bad FCS, by default. */
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 1c2c7500848e..808104cf5220 100644
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
+				netdev_features_clear(features,
+						      (NETIF_F_GSO_MASK));
 		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~netdev_csum_gso_features_mask;
+				netdev_features_clear(features,
+						      netdev_csum_gso_features_mask);
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index d0b7bc8acee3..49a314e709ff 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5594,7 +5594,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 		netdev_feature_del(NETIF_F_RXCSUM_BIT, features);
 
 	if (!priv->plat->tx_coe)
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
 	/* Some GMAC devices have a bugged Jumbo frame support that
 	 * needs to have the Tx COE disabled for oversized frames
@@ -5602,7 +5602,7 @@ static netdev_features_t stmmac_fix_features(struct net_device *dev,
 	 * the TX csum insertion in the TDES and not use SF.
 	 */
 	if (priv->plat->bugged_jumbo && (dev->mtu > ETH_DATA_LEN))
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 
 	/* Disable tso if asked by ethtool */
 	if ((priv->plat->tso_en) && (priv->dma_cap.tsoen)) {
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 2be3039acf20..29b2376f9ef3 100644
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
 	netdev_features_fill(features);
-	features &= ~NETVSC_SUPPORTED_HW_FEATURES;
+	netdev_features_clear(features, NETVSC_SUPPORTED_HW_FEATURES);
 	netdev_features_set(features, net->hw_features);
 	net->features &= features;
 
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 37c660df9a39..3a5cbb491487 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -325,7 +325,7 @@ static void ifb_setup(struct net_device *dev)
 	netdev_active_features_set(dev, ifb_features);
 	netdev_hw_features_set(dev, dev->features);
 	netdev_hw_enc_features_set(dev, dev->features);
-	ifb_features &= ~netdev_tx_vlan_features;
+	netdev_features_clear(ifb_features, netdev_tx_vlan_features);
 	netdev_vlan_features_set(dev, ifb_features);
 
 	dev->flags |= IFF_NOARP;
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index c9993c6d0cec..5bb952c2b30d 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -235,7 +235,7 @@ static netdev_features_t ipvlan_fix_features(struct net_device *dev,
 
 	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
-	tmp &= ~IPVLAN_FEATURES;
+	netdev_features_clear(tmp, IPVLAN_FEATURES);
 	netdev_features_set(tmp, ipvlan->sfeatures);
 	features &= tmp;
 	features = netdev_increment_features(ipvlan->phy_dev->features,
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index dfe6b39f1fc7..f81674c5a3de 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3455,8 +3455,12 @@ static netdev_features_t sw_macsec_features __ro_after_init;
  *   VLAN_FEATURES - they require additional ops
  *   HW_MACSEC - no reason to report it
  */
-#define REAL_DEV_FEATURES(dev) \
-	((dev)->features & ~macsec_no_inherit_features)
+static void macsec_real_dev_features(struct net_device *dev,
+				     netdev_features_t *features)
+{
+	netdev_features_andnot(*features, dev->features,
+			       macsec_no_inherit_features);
+}
 
 static int macsec_dev_init(struct net_device *dev)
 {
@@ -3475,7 +3479,7 @@ static int macsec_dev_init(struct net_device *dev)
 	}
 
 	if (macsec_is_offloaded(macsec)) {
-		dev->features = REAL_DEV_FEATURES(real_dev);
+		macsec_real_dev_features(real_dev, &dev->features);
 	} else {
 		dev->features = real_dev->features & SW_MACSEC_FEATURES;
 		netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
@@ -3513,8 +3517,10 @@ static netdev_features_t macsec_fix_features(struct net_device *dev,
 	struct net_device *real_dev = macsec->real_dev;
 	netdev_features_t tmp;
 
-	if (macsec_is_offloaded(macsec))
-		return REAL_DEV_FEATURES(real_dev);
+	if (macsec_is_offloaded(macsec)) {
+		macsec_real_dev_features(real_dev, &tmp);
+		return tmp;
+	}
 
 	tmp = real_dev->features & SW_MACSEC_FEATURES;
 	netdev_features_set(tmp, NETIF_F_GSO_SOFTWARE);
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index e8b59097b176..498cb6e04a87 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1082,7 +1082,7 @@ static netdev_features_t macvlan_fix_features(struct net_device *dev,
 
 	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 	netdev_features_fill(tmp);
-	tmp &= ~MACVLAN_FEATURES;
+	netdev_features_clear(tmp, MACVLAN_FEATURES);
 	netdev_features_set(tmp, vlan->set_features);
 	features &= tmp;
 	mask = features;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 41e8af2325dd..dc6df0ba0a26 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2007,7 +2007,7 @@ static netdev_features_t team_fix_features(struct net_device *dev,
 	netdev_features_t mask;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 	netdev_features_set(features, NETIF_F_ALL_FOR_ALL);
 
 	rcu_read_lock();
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index c0f0cff917ce..caf449e9e666 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -998,7 +998,8 @@ static int tun_net_init(struct net_device *dev)
 				   NETIF_F_HW_VLAN_STAG_TX_BIT);
 	dev->features = dev->hw_features;
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
-	dev->vlan_features = dev->features & ~netdev_tx_vlan_features;
+	netdev_vlan_features_andnot(dev, dev->features,
+				    netdev_tx_vlan_features);
 
 	tun->flags = (tun->flags & ~TUN_FEATURES) |
 		      (ifr->ifr_flags & TUN_FEATURES);
@@ -1171,7 +1172,7 @@ static netdev_features_t tun_net_fix_features(struct net_device *dev,
 	netdev_features_t tmp1, tmp2;
 
 	tmp1 = features & tun->set_features;
-	tmp2 = features & ~TUN_USER_FEATURES;
+	netdev_features_andnot(tmp2, features, TUN_USER_FEATURES);
 	return tmp1 | tmp2;
 }
 
@@ -2889,7 +2890,7 @@ static int set_offload(struct tun_struct *tun, unsigned long arg)
 		return -EINVAL;
 
 	tun->set_features = features;
-	tun->dev->wanted_features &= ~TUN_USER_FEATURES;
+	netdev_wanted_features_clear(tun->dev, TUN_USER_FEATURES);
 	netdev_wanted_features_set(tun->dev, features);
 	netdev_update_features(tun->dev);
 
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 0eb9fe07c333..027a1c5103f8 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4291,7 +4291,7 @@ static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 	struct lan78xx_net *dev = netdev_priv(netdev);
 
 	if (skb->len > LAN78XX_TSO_SIZE(dev))
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	features = vlan_features_check(skb, features);
 	features = vxlan_features_check(skb, features);
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 43b75c14d4a3..510531a79221 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2771,9 +2771,10 @@ rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
 	    skb_transport_offset(skb) > max_offset)
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(features,
+				      netdev_csum_gso_features_mask);
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 
 	return features;
 }
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 9f9bc0008d9c..cde2f29ce9a6 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1460,7 +1460,7 @@ static netdev_features_t veth_fix_features(struct net_device *dev,
 		struct veth_priv *peer_priv = netdev_priv(peer);
 
 		if (peer_priv->_xdp_prog)
-			features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_features_clear(features, NETIF_F_GSO_SOFTWARE);
 	}
 	if (priv->_xdp_prog)
 		netdev_feature_add(NETIF_F_GRO_BIT, features);
@@ -1560,7 +1560,7 @@ static int veth_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 
 		if (!old_prog) {
-			peer->hw_features &= ~NETIF_F_GSO_SOFTWARE;
+			netdev_hw_features_clear(peer, NETIF_F_GSO_SOFTWARE);
 			peer->max_mtu = max_mtu;
 		}
 	}
@@ -1645,7 +1645,8 @@ static void veth_setup(struct net_device *dev)
 				NETIF_F_HW_VLAN_STAG_RX_BIT);
 	netdev_active_feature_add(dev, NETIF_F_LLTX_BIT);
 	netdev_active_features_set(dev, veth_features);
-	dev->vlan_features = dev->features & ~netdev_vlan_offload_features;
+	netdev_vlan_features_andnot(dev, dev->features,
+				    netdev_vlan_offload_features);
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = veth_dev_free;
 	dev->max_mtu = ETH_MAX_MTU;
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 0be19d8ad6e6..ccead2500579 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3383,8 +3383,8 @@ vmxnet3_declare_features(struct vmxnet3_adapter *adapter)
 		}
 	}
 
-	netdev->vlan_features = netdev->hw_features &
-				~netdev_ctag_vlan_offload_features;
+	netdev_vlan_features_andnot(netdev, netdev->hw_features,
+				    netdev_ctag_vlan_offload_features);
 	netdev->features = netdev->hw_features;
 	netdev_active_feature_add(netdev, NETIF_F_HW_VLAN_CTAG_FILTER_BIT);
 }
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 2e3a795818b9..d9be2fc80de2 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -277,7 +277,9 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features & ~netdev_csum_gso_features_mask;
+			netdev_features_clear(features,
+					      netdev_csum_gso_features_mask);
+			return features;
 		}
 
 		switch (l4_proto) {
@@ -288,11 +290,15 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				return features & ~netdev_csum_gso_features_mask;
+				netdev_features_clear(features,
+						      netdev_csum_gso_features_mask);
+				return features;
 			}
 			break;
 		default:
-			return features & ~netdev_csum_gso_features_mask;
+			netdev_features_clear(features,
+					      netdev_csum_gso_features_mask);
+			return features;
 		}
 	}
 	return features;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 603fa9183816..4a8a0870caa2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -617,7 +617,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 
 	netdev_features_set(hw->netdev_features, *mvm->cfg->features);
 	if (!iwl_mvm_is_csum_supported(mvm))
-		hw->netdev_features &= ~IWL_CSUM_NETIF_FLAGS_MASK;
+		netdev_features_clear(hw->netdev_features,
+				      IWL_CSUM_NETIF_FLAGS_MASK);
 
 	if (mvm->cfg->vht_mu_mimo_supported)
 		wiphy_ext_feature_set(hw->wiphy,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 81645e3b47c8..ca2814ebe0d4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -908,7 +908,7 @@ static int iwl_mvm_tx_tso(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (skb->protocol == htons(ETH_P_IPV6) &&
 	    ((struct ipv6hdr *)skb_network_header(skb))->nexthdr !=
 	    IPPROTO_TCP) {
-		netdev_flags &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(netdev_flags, NETIF_F_CSUM_MASK);
 		return iwl_mvm_tx_tso_segment(skb, 1, netdev_flags, mpdus_skb);
 	}
 
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 5684903171e2..762968b23edc 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6748,7 +6748,7 @@ void qeth_enable_hw_features(struct net_device *dev)
 	/* force-off any feature that might need an IPA sequence.
 	 * netdev_update_features() will restart them.
 	 */
-	dev->features &= ~dev->hw_features;
+	netdev_active_features_clear(dev, dev->hw_features);
 	/* toggle VLAN filter, so that VIDs are re-programmed: */
 	if (IS_LAYER2(card) && IS_VM_NIC(card)) {
 		netdev_active_feature_del(dev,
@@ -6884,7 +6884,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
-				features &= ~restricted;
+				netdev_features_clear(features, restricted);
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
@@ -6892,7 +6892,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				features &= ~restricted;
+				netdev_features_clear(features, restricted);
 			break;
 		default:
 			break;
diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 6745a3a75041..4b248fe59e67 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -4580,7 +4580,7 @@ static int qlge_probe(struct pci_dev *pdev,
 	ndev->features = ndev->hw_features;
 	ndev->vlan_features = ndev->hw_features;
 	/* vlan gets same features (except vlan filter) */
-	ndev->vlan_features &= ~netdev_ctag_vlan_features;
+	netdev_vlan_features_clear(ndev, netdev_ctag_vlan_features);
 
 	if (test_bit(QL_DMA64, &qdev->flags))
 		netdev_active_feature_add(ndev, NETIF_F_HIGHDMA_BIT);
diff --git a/include/linux/netdev_feature_helpers.h b/include/linux/netdev_feature_helpers.h
index d5ceaf4b52d3..97b0edf5d2f7 100644
--- a/include/linux/netdev_feature_helpers.h
+++ b/include/linux/netdev_feature_helpers.h
@@ -715,7 +715,7 @@ netdev_get_wanted_features(struct net_device *dev)
 {
 	netdev_features_t tmp;
 
-	tmp = dev->features & ~dev->hw_features;
+	netdev_features_andnot(tmp, dev->features, dev->hw_features);
 	netdev_features_set(tmp, dev->wanted_features);
 	return tmp;
 }
diff --git a/include/net/sock.h b/include/net/sock.h
index 96a31026e35d..624ed56a43bf 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -44,6 +44,7 @@
 #include <linux/bitops.h>
 #include <linux/lockdep.h>
 #include <linux/netdevice.h>
+#include <linux/netdev_feature_helpers.h>
 #include <linux/skbuff.h>	/* struct sk_buff */
 #include <linux/mm.h>
 #include <linux/security.h>
@@ -2244,7 +2245,7 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst);
 static inline void sk_gso_disable(struct sock *sk)
 {
 	sk->sk_gso_disabled = 1;
-	sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(sk->sk_route_caps, NETIF_F_GSO_MASK);
 }
 
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 60a8675976c2..d0e4729acebc 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -372,8 +372,10 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
-	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto))))
-		return features & ~netdev_csum_gso_features_mask;
+	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto)))) {
+		netdev_features_clear(features, netdev_csum_gso_features_mask);
+		return features;
+	}
 
 	return features;
 }
diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
index 07b70cf135ef..d8ff9230cc53 100644
--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -113,7 +113,7 @@ static inline netdev_features_t vlan_tnl_features(struct net_device *real_dev)
 	ret &= real_dev->hw_enc_features;
 
 	if ((ret & NETIF_F_GSO_ENCAP_ALL) && (ret & NETIF_F_CSUM_MASK)) {
-		ret &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(ret, NETIF_F_CSUM_MASK);
 		netdev_feature_add(NETIF_F_HW_CSUM_BIT, ret);
 		return ret;
 	}
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index 72e72a799943..21dfdaf1389d 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -581,7 +581,8 @@ static int vlan_dev_init(struct net_device *dev)
 	if (dev->features & NETIF_F_VLAN_FEATURES)
 		netdev_warn(real_dev, "VLAN features are set incorrectly.  Q-in-Q configurations may not work correctly.\n");
 
-	dev->vlan_features = real_dev->vlan_features & ~NETIF_F_ALL_FCOE;
+	netdev_vlan_features_andnot(dev, real_dev->vlan_features,
+				    NETIF_F_ALL_FCOE);
 	dev->hw_enc_features = vlan_tnl_features(real_dev);
 	dev->mpls_features = real_dev->mpls_features;
 
diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index efbd93e92ce2..ef8dd8a91164 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -542,7 +542,7 @@ netdev_features_t br_features_recompute(struct net_bridge *br,
 		return features;
 
 	mask = features;
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 
 	list_for_each_entry(p, &br->port_list, list) {
 		features = netdev_increment_features(features,
diff --git a/net/core/dev.c b/net/core/dev.c
index a6368c620028..fb32cd8e8c3e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3488,7 +3488,8 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~netdev_csum_gso_features_mask;
+		netdev_features_clear(features,
+				      netdev_csum_gso_features_mask);
 	}
 	if (illegal_highdma(skb->dev, skb))
 		netdev_feature_del(NETIF_F_SG_BIT, features);
@@ -3517,12 +3518,15 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
-	if (gso_segs > READ_ONCE(dev->gso_max_segs))
-		return features & ~NETIF_F_GSO_MASK;
+	if (gso_segs > READ_ONCE(dev->gso_max_segs)) {
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		return features;
+	}
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		return features & ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		return features;
 	}
 
 	/* Support for GSO partial features requires software
@@ -3532,7 +3536,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(features, dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -9612,13 +9616,13 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	if ((features & NETIF_F_HW_CSUM) &&
 	    (features & netdev_ip_csum_features)) {
 		netdev_warn(dev, "mixed HW and IP checksum settings.\n");
-		features &= ~netdev_ip_csum_features;
+		netdev_features_clear(features, netdev_ip_csum_features);
 	}
 
 	/* TSO requires that SG is present as well. */
 	if ((features & NETIF_F_ALL_TSO) && !(features & NETIF_F_SG)) {
 		netdev_dbg(dev, "Dropping TSO features since no SG feature.\n");
-		features &= ~NETIF_F_ALL_TSO;
+		netdev_features_clear(features, NETIF_F_ALL_TSO);
 	}
 
 	if ((features & NETIF_F_TSO) && !(features & NETIF_F_HW_CSUM) &&
@@ -9655,7 +9659,7 @@ static netdev_features_t netdev_fix_features(struct net_device *dev,
 	    !(features & NETIF_F_GSO_PARTIAL)) {
 		netdev_dbg(dev,
 			   "Dropping partially supported GSO features since no GSO partial.\n");
-		features &= ~dev->gso_partial_features;
+		netdev_features_clear(features, dev->gso_partial_features);
 	}
 
 	if (!(features & NETIF_F_RXCSUM)) {
@@ -11163,7 +11167,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	netdev_features_set(all, tmp);
 
 	netdev_features_fill(tmp);
-	tmp &= ~NETIF_F_ALL_FOR_ALL;
+	netdev_features_clear(tmp, NETIF_F_ALL_FOR_ALL);
 	netdev_features_set(tmp, one);
 	all &= tmp;
 
@@ -11171,7 +11175,7 @@ netdev_features_t netdev_increment_features(netdev_features_t all,
 	if (all & NETIF_F_HW_CSUM) {
 		tmp = NETIF_F_CSUM_MASK;
 		netdev_feature_del(NETIF_F_HW_CSUM_BIT, tmp);
-		all &= ~tmp;
+		netdev_features_clear(all, tmp);
 	}
 
 	return all;
diff --git a/net/core/sock.c b/net/core/sock.c
index 61e8dc0d65d9..5b89b03660b9 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2376,10 +2376,11 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 	if (sk->sk_route_caps & NETIF_F_GSO)
 		netdev_features_set(sk->sk_route_caps, NETIF_F_GSO_SOFTWARE);
 	if (unlikely(sk->sk_gso_disabled))
-		sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(sk->sk_route_caps, NETIF_F_GSO_MASK);
 	if (sk_can_gso(sk)) {
 		if (dst->header_len && !xfrm_dst_offload_ok(dst)) {
-			sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
+			netdev_features_clear(sk->sk_route_caps,
+					      NETIF_F_GSO_MASK);
 		} else {
 			netdev_features_set_set(sk->sk_route_caps,
 						NETIF_F_SG_BIT,
diff --git a/net/ethtool/features.c b/net/ethtool/features.c
index 51e4702c2b6d..769d77cbeb16 100644
--- a/net/ethtool/features.c
+++ b/net/ethtool/features.c
@@ -253,7 +253,7 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
 	bitmap_andnot(new_wanted, old_wanted, req_mask, NETDEV_FEATURE_COUNT);
 	bitmap_or(req_wanted, new_wanted, req_wanted, NETDEV_FEATURE_COUNT);
 	if (!bitmap_equal(req_wanted, old_wanted, NETDEV_FEATURE_COUNT)) {
-		dev->wanted_features &= ~dev->hw_features;
+		netdev_wanted_features_clear(dev, dev->hw_features);
 		tmp = ethnl_bitmap_to_features(req_wanted) & dev->hw_features;
 		netdev_wanted_features_set(dev, tmp);
 		__netdev_update_features(dev);
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 052edfd2bee1..21045ba78350 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -147,17 +147,17 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 		wanted |= (netdev_features_t)features[i].requested << (32 * i);
 	}
 
-	tmp = valid & ~NETIF_F_ETHTOOL_BITS;
+	netdev_features_andnot(tmp, valid, NETIF_F_ETHTOOL_BITS);
 	if (tmp)
 		return -EINVAL;
 
-	tmp = valid & ~dev->hw_features;
+	netdev_features_andnot(tmp, valid, dev->hw_features);
 	if (tmp) {
 		valid &= dev->hw_features;
 		ret |= ETHTOOL_F_UNSUPPORTED;
 	}
 
-	dev->wanted_features &= ~valid;
+	netdev_wanted_features_clear(dev, valid);
 	tmp = wanted & valid;
 	netdev_wanted_features_set(dev, tmp);
 	__netdev_update_features(dev);
@@ -298,7 +298,7 @@ static int ethtool_set_one_feature(struct net_device *dev,
 	if (edata.data)
 		netdev_wanted_features_set(dev, mask);
 	else
-		dev->wanted_features &= ~mask;
+		netdev_wanted_features_clear(dev, mask);
 
 	__netdev_update_features(dev);
 
@@ -357,11 +357,11 @@ static int __ethtool_set_flags(struct net_device *dev, u32 data)
 	/* allow changing only bits set in hw_features */
 	changed = dev->features ^ features;
 	changed &= eth_all_features;
-	tmp = changed & ~dev->hw_features;
+	netdev_features_andnot(tmp, changed, dev->hw_features);
 	if (tmp)
 		return (changed & dev->hw_features) ? -EINVAL : -EOPNOTSUPP;
 
-	dev->wanted_features &= ~changed;
+	netdev_wanted_features_clear(dev, changed);
 	tmp = features & changed;
 	netdev_wanted_features_set(dev, tmp);
 
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 3747f69d48a2..0e37ba6e1569 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -193,7 +193,7 @@ static netdev_features_t hsr_features_recompute(struct hsr_priv *hsr,
 	 * that were in features originally, and also is in NETIF_F_ONE_FOR_ALL,
 	 * may become enabled.
 	 */
-	features &= ~NETIF_F_ONE_FOR_ALL;
+	netdev_features_clear(features, NETIF_F_ONE_FOR_ALL);
 	hsr_for_each_port(hsr, port)
 		features = netdev_increment_features(features,
 						     port->dev->features,
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 82534cf1fe4f..5aeebbc1d349 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -219,12 +219,14 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		netdev_features_andnot(esp_features, features,
+				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM)) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		netdev_features_andnot(esp_features, features,
+				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	}
 
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 480754eadf4b..381c98fb2ed4 100644
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
index 085fcf1395d2..8353875a9506 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -264,7 +264,7 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	 */
 	features = netif_skb_features(skb);
 	BUILD_BUG_ON(sizeof(*IPCB(skb)) > SKB_GSO_CB_OFFSET);
-	features &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 8a09a951db80..908670adfdfc 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	 * instead set the flag based on our outer checksum offload value.
 	 */
 	if (remcsum) {
-		features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(features, NETIF_F_CSUM_MASK);
 		if (!need_csum || offload_csum)
 			netdev_feature_add(NETIF_F_HW_CSUM_BIT, features);
 	}
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index cc0ca80ac569..19f685f6b378 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -257,11 +257,13 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		netdev_features_andnot(esp_features, features,
+				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	} else if (!(features & NETIF_F_HW_ESP_TX_CSUM)) {
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		netdev_features_andnot(esp_features, features,
+				       NETIF_F_CSUM_MASK);
 		netdev_feature_del(NETIF_F_SCTP_CRC_BIT, esp_features);
 	}
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index f6f54fdce208..28239182d820 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -149,7 +149,7 @@ ip6_finish_output_gso_slowpath_drop(struct net *net, struct sock *sk,
 	 * egress MTU.
 	 */
 	features = netif_skb_features(skb);
-	features &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
 		kfree_skb(skb);
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index d5607d4cf903..f2f55129d639 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -945,6 +945,7 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	int channels, max_bitrates;
 	bool supp_ht, supp_vht, supp_he, supp_eht;
 	struct cfg80211_chan_def dflt_chandef = {};
+	netdev_features_t features;
 
 	if (ieee80211_hw_check(hw, QUEUE_CONTROL) &&
 	    (local->hw.offchannel_tx_hw_queue == IEEE80211_INVAL_HW_QUEUE ||
@@ -1040,7 +1041,8 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 	}
 
 	/* Only HW csum features are currently compatible with mac80211 */
-	if (WARN_ON(hw->netdev_features & ~MAC80211_SUPPORTED_FEATURES))
+	if (WARN_ON(netdev_features_andnot(features, hw->netdev_features,
+					   MAC80211_SUPPORTED_FEATURES)))
 		return -EINVAL;
 
 	if (hw->max_report_rates == 0)
diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 7e7585a16f11..022fd85394e8 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1743,7 +1743,7 @@ static s32 cake_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		netdev_features_t features = netif_skb_features(skb);
 		unsigned int slen = 0, numsegs = 0;
 
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_netem.c b/net/sched/sch_netem.c
index 72f99074ff58..55084f0f2f57 100644
--- a/net/sched/sch_netem.c
+++ b/net/sched/sch_netem.c
@@ -415,7 +415,7 @@ static struct sk_buff *netem_segment(struct sk_buff *skb, struct Qdisc *sch,
 	struct sk_buff *segs;
 	netdev_features_t features = netif_skb_features(skb);
 
-	features &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs)) {
diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index 621ac3c6d505..dc8b114388e2 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -463,7 +463,7 @@ static int taprio_enqueue(struct sk_buff *skb, struct Qdisc *sch,
 		struct sk_buff *segs, *nskb;
 		int ret;
 
-		features &= ~NETIF_F_GSO_MASK;
+		netdev_features_clear(features, NETIF_F_GSO_MASK);
 		segs = skb_gso_segment(skb, features);
 		if (IS_ERR_OR_NULL(segs))
 			return qdisc_drop(skb, sch, to_free);
diff --git a/net/sched/sch_tbf.c b/net/sched/sch_tbf.c
index 9a114fd9de4d..5c883b639ed7 100644
--- a/net/sched/sch_tbf.c
+++ b/net/sched/sch_tbf.c
@@ -13,6 +13,7 @@
 #include <linux/string.h>
 #include <linux/errno.h>
 #include <linux/skbuff.h>
+#include <linux/netdev_feature_helpers.h>
 #include <net/netlink.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
@@ -210,7 +211,7 @@ static int tbf_segment(struct sk_buff *skb, struct Qdisc *sch,
 	unsigned int len = 0, prev_len = qdisc_pkt_len(skb);
 	int ret, nb;
 
-	features &= ~NETIF_F_GSO_MASK;
+	netdev_features_clear(features, NETIF_F_GSO_MASK);
 	segs = skb_gso_segment(skb, features);
 
 	if (IS_ERR_OR_NULL(segs))
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index eb68ef0cfb54..78ebbccbd616 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -115,7 +115,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (!(features & NETIF_F_HW_ESP)) {
 		esp_features = features;
 		netdev_feature_del(NETIF_F_SG_BIT, esp_features);
-		esp_features &= ~NETIF_F_CSUM_MASK;
+		netdev_features_clear(esp_features, NETIF_F_CSUM_MASK);
 	}
 
 	sp = skb_sec_path(skb);
-- 
2.33.0

