Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D445BBD18
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiIRJvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiIRJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:50:19 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 812F511C03
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:56 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4MVjbz09jpz14QNv;
        Sun, 18 Sep 2022 17:45:51 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:53 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 41/55] net: adjust the prototype of xxx_features_check()
Date:   Sun, 18 Sep 2022 09:43:22 +0000
Message-ID: <20220918094336.28958-42-shenjian15@huawei.com>
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

The function net_device_ops.ndo_features_check() using
netdev_features_t as parameters, and returns netdev_features_t
directly. For the prototype of netdev_features_t will be extended
to be larger than 8 bytes, so change the prototype of the function,
 change the prototype of input features to'netdev_features_t *',
and return the features pointer as output parameter. So changes
all the implement for this function of all the netdev drivers, and
relative functions.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/3com/typhoon.c           | 12 +++---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c      | 11 ++---
 .../net/ethernet/broadcom/bnx2x/bnx2x_main.c  | 11 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 16 ++++----
 drivers/net/ethernet/cadence/macb_main.c      | 16 ++++----
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 12 +++---
 drivers/net/ethernet/cisco/enic/enic_main.c   | 14 +++----
 drivers/net/ethernet/emulex/benet/be_main.c   | 21 +++++-----
 .../net/ethernet/hisilicon/hns3/hns3_enet.c   | 11 ++---
 drivers/net/ethernet/ibm/ibmvnic.c            |  9 ++---
 .../net/ethernet/intel/fm10k/fm10k_netdev.c   | 10 ++---
 drivers/net/ethernet/intel/i40e/i40e_main.c   | 14 +++----
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 14 +++----
 drivers/net/ethernet/intel/ice/ice_main.c     | 13 +++---
 drivers/net/ethernet/intel/igb/igb_main.c     | 18 ++++-----
 drivers/net/ethernet/intel/igbvf/netdev.c     | 18 ++++-----
 drivers/net/ethernet/intel/igc/igc_main.c     | 18 ++++-----
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 18 ++++-----
 .../net/ethernet/intel/ixgbevf/ixgbevf_main.c | 18 ++++-----
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 13 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  5 +--
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 16 ++++----
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 37 ++++++++---------
 .../ethernet/netronome/nfp/nfp_net_common.c   | 22 +++++-----
 drivers/net/ethernet/qlogic/qede/qede.h       |  5 +--
 drivers/net/ethernet/qlogic/qede/qede_fp.c    | 17 ++++----
 .../net/ethernet/qlogic/qlcnic/qlcnic_main.c  |  9 ++---
 drivers/net/ethernet/realtek/8139cp.c         |  9 ++---
 drivers/net/ethernet/realtek/r8169_main.c     | 28 ++++++-------
 drivers/net/ethernet/sfc/efx_common.c         | 13 +++---
 drivers/net/ethernet/sfc/efx_common.h         |  4 +-
 drivers/net/ethernet/sfc/siena/efx_common.c   | 14 +++----
 drivers/net/ethernet/sfc/siena/efx_common.h   |  5 +--
 drivers/net/usb/lan78xx.c                     | 14 +++----
 drivers/net/usb/r8152.c                       | 10 ++---
 drivers/net/vmxnet3/vmxnet3_ethtool.c         | 18 ++++-----
 drivers/net/vmxnet3/vmxnet3_int.h             |  4 +-
 drivers/s390/net/qeth_core.h                  |  5 +--
 drivers/s390/net/qeth_core_main.c             | 17 ++++----
 drivers/s390/net/qeth_l3_main.c               | 10 ++---
 include/linux/if_vlan.h                       | 13 +++---
 include/linux/netdevice.h                     |  9 ++---
 include/net/vxlan.h                           | 16 ++++----
 net/core/dev.c                                | 40 ++++++++-----------
 44 files changed, 272 insertions(+), 355 deletions(-)

diff --git a/drivers/net/ethernet/3com/typhoon.c b/drivers/net/ethernet/3com/typhoon.c
index 6fb1efbe674f..694400423285 100644
--- a/drivers/net/ethernet/3com/typhoon.c
+++ b/drivers/net/ethernet/3com/typhoon.c
@@ -2261,15 +2261,15 @@ typhoon_test_mmio(struct pci_dev *pdev)
 
 #include <net/vxlan.h>
 
-static netdev_features_t typhoon_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void typhoon_features_check(struct sk_buff *skb,
+				   struct net_device *dev,
+				   netdev_features_t *features)
 {
 	if (skb_shinfo(skb)->nr_frags > 32 && skb_is_gso(skb))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
-	features = vlan_features_check(skb, features);
-	return vxlan_features_check(skb, features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 #endif
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 92e722c356e0..5ecd0904aacc 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2268,14 +2268,11 @@ static int xgbe_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t xgbe_features_check(struct sk_buff *skb,
-					     struct net_device *netdev,
-					     netdev_features_t features)
+static void xgbe_features_check(struct sk_buff *skb, struct net_device *netdev,
+				netdev_features_t *features)
 {
-	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
-
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops xgbe_netdev_ops = {
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index 2a3b18665054..13055ba8b443 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12854,9 +12854,8 @@ static int bnx2x_get_phys_port_id(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
-					      struct net_device *dev,
-					      netdev_features_t features)
+static void bnx2x_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	/*
 	 * A skb with gso_size + header length > 9700 will cause a
@@ -12874,10 +12873,10 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 	if (unlikely(skb_is_gso(skb) &&
 		     (skb_shinfo(skb)->gso_size > 9000) &&
 		     !skb_gso_validate_mac_len(skb, 9700)))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
-	features = vlan_features_check(skb, features);
-	return vxlan_features_check(skb, features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static int __bnx2x_vlan_configure_vid(struct bnx2x *bp, u16 vid, bool add)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index e8ccccb07045..97a108fdf693 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11370,32 +11370,30 @@ static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
 	return false;
 }
 
-static netdev_features_t bnxt_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void bnxt_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct bnxt *bp = netdev_priv(dev);
 	u8 *l4_proto;
 
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
 		if (!skb->encapsulation)
-			return features;
+			return;
 		l4_proto = &ip_hdr(skb)->protocol;
 		if (bnxt_tunl_check(bp, skb, *l4_proto))
-			return features;
+			return;
 		break;
 	case htons(ETH_P_IPV6):
 		if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
 				       &l4_proto))
 			break;
 		if (!l4_proto || bnxt_tunl_check(bp, skb, *l4_proto))
-			return features;
+			return;
 		break;
 	}
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 31b258a47077..7b49abf30def 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2128,9 +2128,8 @@ static unsigned int macb_tx_map(struct macb *bp,
 	return 0;
 }
 
-static netdev_features_t macb_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void macb_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	unsigned int nr_frags, f;
 	unsigned int hdrlen;
@@ -2139,7 +2138,7 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 
 	/* there is only one buffer or protocol is not UDP */
 	if (!skb_is_nonlinear(skb) || (ip_hdr(skb)->protocol != IPPROTO_UDP))
-		return features;
+		return;
 
 	/* length of header */
 	hdrlen = skb_transport_offset(skb);
@@ -2149,8 +2148,8 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 	 * apart from the last must be a multiple of 8 bytes in size.
 	 */
 	if (!IS_ALIGNED(skb_headlen(skb) - hdrlen, MACB_TX_LEN_ALIGN)) {
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-		return features;
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
+		return;
 	}
 
 	nr_frags = skb_shinfo(skb)->nr_frags;
@@ -2160,11 +2159,10 @@ static netdev_features_t macb_features_check(struct sk_buff *skb,
 		const skb_frag_t *frag = &skb_shinfo(skb)->frags[f];
 
 		if (!IS_ALIGNED(skb_frag_size(frag), MACB_TX_LEN_ALIGN)) {
-			netdev_feature_del(NETIF_F_TSO_BIT, features);
-			return features;
+			netdev_feature_del(NETIF_F_TSO_BIT, *features);
+			return;
 		}
 	}
-	return features;
 }
 
 static inline int macb_clear_csum(struct sk_buff *skb)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index a4b06645861a..08ce0b730ec4 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3841,23 +3841,21 @@ static const struct udp_tunnel_nic_info cxgb_udp_tunnels = {
 	},
 };
 
-static netdev_features_t cxgb_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void cxgb_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	struct port_info *pi = netdev_priv(dev);
 	struct adapter *adapter = pi->adapter;
 
 	if (CHELSIO_CHIP_VERSION(adapter->params.chip) < CHELSIO_T6)
-		return features;
+		return;
 
 	/* Check if hw supports offload for this packet */
 	if (!skb->encapsulation || cxgb_encap_offload_supported(skb))
-		return features;
+		return;
 
 	/* Offload is not supported for this encapsulated packet */
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 static netdev_features_t cxgb_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 9ad7c5b0734a..1b737b940a00 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -241,9 +241,8 @@ static const struct udp_tunnel_nic_info enic_udp_tunnels = {
 	},
 };
 
-static netdev_features_t enic_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void enic_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	const struct ethhdr *eth = (struct ethhdr *)skb_inner_mac_header(skb);
 	struct enic *enic = netdev_priv(dev);
@@ -252,9 +251,9 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	u8 proto;
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
-	features = vxlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IPV6):
@@ -292,11 +291,10 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	if (port  != enic->vxlan.vxlan_udp_port_number)
 		goto out;
 
-	return features;
+	return;
 
 out:
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 int enic_is_dynamic(struct enic *enic)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 6ea623d6ddf4..f254f11d135a 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5065,9 +5065,8 @@ static struct be_cmd_work *be_alloc_work(struct be_adapter *adapter,
 	return work;
 }
 
-static netdev_features_t be_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features)
+static void be_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct be_adapter *adapter = netdev_priv(dev);
 	u8 l4_hdr = 0;
@@ -5077,7 +5076,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		 * to Lancer and BE3 HW. Disable TSO6 feature.
 		 */
 		if (!skyhawk_chip(adapter) && is_ipv6_ext_hdr(skb))
-			netdev_feature_del(NETIF_F_TSO6_BIT, features);
+			netdev_feature_del(NETIF_F_TSO6_BIT, *features);
 
 		/* Lancer cannot handle the packet with MSS less than 256.
 		 * Also it can't handle a TSO packet with a single segment
@@ -5086,17 +5085,17 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		if (lancer_chip(adapter) &&
 		    (skb_shinfo(skb)->gso_size < 256 ||
 		     skb_shinfo(skb)->gso_segs == 1))
-			netdev_features_clear(features, NETIF_F_GSO_MASK);
+			netdev_features_clear(*features, NETIF_F_GSO_MASK);
 	}
 
 	/* The code below restricts offload features for some tunneled and
 	 * Q-in-Q packets.
 	 * Offload features for normal (non tunnel) packets are unchanged.
 	 */
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 	if (!skb->encapsulation ||
 	    !(adapter->flags & BE_FLAGS_VXLAN_OFFLOADS))
-		return features;
+		return;
 
 	/* It's an encapsulated packet and VxLAN offloads are enabled. We
 	 * should disable tunnel offload features if it's not a VxLAN packet,
@@ -5112,7 +5111,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features;
+		return;
 	}
 
 	if (l4_hdr != IPPROTO_UDP ||
@@ -5122,11 +5121,9 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
 	    udp_hdr(skb)->dest != adapter->vxlan_port) {
-		netdev_features_clear(features, netdev_csum_gso_features_mask);
-		return features;
+		netdev_features_clear(*features, netdev_csum_gso_features_mask);
+		return;
 	}
-
-	return features;
 }
 
 static int be_get_phys_port_id(struct net_device *dev,
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index b098d070deef..06c79b7cbb23 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2457,9 +2457,8 @@ static int hns3_nic_set_features(struct net_device *netdev,
 	return 0;
 }
 
-static netdev_features_t hns3_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void hns3_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 #define HNS3_MAX_HDR_LEN	480U
 #define HNS3_MAX_L4_HDR_LEN	60U
@@ -2467,7 +2466,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	size_t len;
 
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	if (skb->encapsulation)
 		len = skb_inner_transport_header(skb) - skb->data;
@@ -2483,10 +2482,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		netdev_features_clear(features,
+		netdev_features_clear(*features,
 				      netdev_csum_gso_features_mask);
-
-	return features;
 }
 
 static void hns3_fetch_stats(struct rtnl_link_stats64 *stats,
diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 6f84086ddfe2..afef066f0647 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -3324,9 +3324,8 @@ static int ibmvnic_change_mtu(struct net_device *netdev, int new_mtu)
 	return wait_for_reset(adapter);
 }
 
-static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void ibmvnic_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	/* Some backing hardware adapters can not
 	 * handle packets with a MSS less than 224
@@ -3335,10 +3334,8 @@ static netdev_features_t ibmvnic_features_check(struct sk_buff *skb,
 	if (skb_is_gso(skb)) {
 		if (skb_shinfo(skb)->gso_size < 224 ||
 		    skb_shinfo(skb)->gso_segs == 1)
-			netdev_features_clear(features, NETIF_F_GSO_MASK);
+			netdev_features_clear(*features, NETIF_F_GSO_MASK);
 	}
-
-	return features;
 }
 
 static const struct net_device_ops ibmvnic_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index da65c5487599..2162a2d7f3f5 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1505,15 +1505,13 @@ static void fm10k_dfwd_del_station(struct net_device *dev, void *priv)
 	}
 }
 
-static netdev_features_t fm10k_features_check(struct sk_buff *skb,
-					      struct net_device *dev,
-					      netdev_features_t features)
+static void fm10k_features_check(struct sk_buff *skb, struct net_device *dev,
+				 netdev_features_t *features)
 {
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
-		return features;
+		return;
 
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 0f2cfb6e9ce9..3bf454f234a4 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13189,9 +13189,8 @@ static int i40e_ndo_bridge_getlink(struct sk_buff *skb, u32 pid, u32 seq,
  * @dev: This physical port's netdev
  * @features: Offload features that the stack believes apply
  **/
-static netdev_features_t i40e_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void i40e_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	size_t len;
 
@@ -13200,13 +13199,13 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -13236,10 +13235,9 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 	 * by TCP, which is at most 15 dwords
 	 */
 
-	return features;
+	return;
 out_err:
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 2cc85f1a81df..9b9873d62687 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4386,9 +4386,8 @@ static int iavf_set_features(struct net_device *netdev,
  * @dev: This physical port's netdev
  * @features: Offload features that the stack believes apply
  **/
-static netdev_features_t iavf_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void iavf_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
 	size_t len;
 
@@ -4397,13 +4396,13 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes.  If it is then we need to drop support for GSO.
 	 */
 	if (skb_is_gso(skb) && (skb_shinfo(skb)->gso_size < 64))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
 	/* MACLEN can support at most 63 words */
 	len = skb_network_header(skb) - skb->data;
@@ -4433,10 +4432,9 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 	 * by TCP, which is at most 15 dwords
 	 */
 
-	return features;
+	return;
 out_err:
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index b69357c220d9..105f49eaec4d 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9013,10 +9013,10 @@ int ice_stop(struct net_device *netdev)
  * @netdev: This port's netdev
  * @features: Offload features that the stack believes apply
  */
-static netdev_features_t
+static void
 ice_features_check(struct sk_buff *skb,
 		   struct net_device __always_unused *netdev,
-		   netdev_features_t features)
+		   netdev_features_t *features)
 {
 	bool gso = skb_is_gso(skb);
 	size_t len;
@@ -9026,13 +9026,13 @@ ice_features_check(struct sk_buff *skb,
 	 * checking for CHECKSUM_PARTIAL
 	 */
 	if (skb->ip_summed != CHECKSUM_PARTIAL)
-		return features;
+		return;
 
 	/* We cannot support GSO if the MSS is going to be less than
 	 * 64 bytes. If it is then we need to drop support for GSO.
 	 */
 	if (gso && (skb_shinfo(skb)->gso_size < ICE_TXD_CTX_MIN_MSS))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
 	len = skb_network_offset(skb);
 	if (len > ICE_TXD_MACLEN_MAX || len & 0x1)
@@ -9061,10 +9061,9 @@ ice_features_check(struct sk_buff *skb,
 			goto out_rm_features;
 	}
 
-	return features;
+	return;
 out_rm_features:
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 01af57d888c3..05da0d2cc21f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2506,43 +2506,43 @@ static int igb_ndo_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 #define IGB_MAX_MAC_HDR_LEN	127
 #define IGB_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
+static void
 igb_features_check(struct sk_buff *skb, struct net_device *dev,
-		   netdev_features_t features)
+		   netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGB_MAX_MAC_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_GSO_UDP_L4_BIT,
 					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGB_MAX_NETWORK_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_GSO_UDP_L4_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 
-	return features;
+	return;
 }
 
 static void igb_offload_apply(struct igb_adapter *adapter, s32 queue)
diff --git a/drivers/net/ethernet/intel/igbvf/netdev.c b/drivers/net/ethernet/intel/igbvf/netdev.c
index 00cdc7432d85..11e8496236a6 100644
--- a/drivers/net/ethernet/intel/igbvf/netdev.c
+++ b/drivers/net/ethernet/intel/igbvf/netdev.c
@@ -2619,41 +2619,39 @@ static int igbvf_set_features(struct net_device *netdev,
 #define IGBVF_MAX_MAC_HDR_LEN		127
 #define IGBVF_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
+static void
 igbvf_features_check(struct sk_buff *skb, struct net_device *dev,
-		     netdev_features_t features)
+		     netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGBVF_MAX_MAC_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGBVF_MAX_NETWORK_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-
-	return features;
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 }
 
 static const struct net_device_ops igbvf_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 67849c8d1877..83a5f3ed7cd6 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -5014,41 +5014,39 @@ static int igc_set_features(struct net_device *netdev,
 	return 1;
 }
 
-static netdev_features_t
+static void
 igc_features_check(struct sk_buff *skb, struct net_device *dev,
-		   netdev_features_t features)
+		   netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IGC_MAX_MAC_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IGC_MAX_NETWORK_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	/* We can only support IPv4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-
-	return features;
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 }
 
 static void igc_tsync_interrupt(struct igc_adapter *adapter)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index f3b1d4777c3f..731ac302cf8e 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -10219,34 +10219,34 @@ static void ixgbe_fwd_del(struct net_device *pdev, void *priv)
 #define IXGBE_MAX_MAC_HDR_LEN		127
 #define IXGBE_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
+static void
 ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
-		     netdev_features_t features)
+		     netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IXGBE_MAX_MAC_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_GSO_UDP_L4_BIT,
 					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IXGBE_MAX_NETWORK_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_GSO_UDP_L4_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
@@ -10254,14 +10254,12 @@ ixgbe_features_check(struct sk_buff *skb, struct net_device *dev,
 	 * IPsec offoad sets skb->encapsulation but still can handle
 	 * the TSO, so it's the exception.
 	 */
-	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features)) {
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features)) {
 #ifdef CONFIG_IXGBE_IPSEC
 		if (!secpath_exists(skb))
 #endif
-			netdev_feature_del(NETIF_F_TSO_BIT, features);
+			netdev_feature_del(NETIF_F_TSO_BIT, *features);
 	}
-
-	return features;
 }
 
 static int ixgbe_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 50b920ae83e1..5078d723251f 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4400,41 +4400,39 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 #define IXGBEVF_MAX_MAC_HDR_LEN		127
 #define IXGBEVF_MAX_NETWORK_HDR_LEN	511
 
-static netdev_features_t
+static void
 ixgbevf_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+		       netdev_features_t *features)
 {
 	unsigned int network_hdr_len, mac_hdr_len;
 
 	/* Make certain the headers can be described by a context descriptor */
 	mac_hdr_len = skb_network_header(skb) - skb->data;
 	if (unlikely(mac_hdr_len > IXGBEVF_MAX_MAC_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_HW_VLAN_CTAG_TX_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	network_hdr_len = skb_checksum_start(skb) - skb_network_header(skb);
 	if (unlikely(network_hdr_len >  IXGBEVF_MAX_NETWORK_HDR_LEN)) {
-		netdev_features_clear_set(features,
+		netdev_features_clear_set(*features,
 					  NETIF_F_HW_CSUM_BIT,
 					  NETIF_F_SCTP_CRC_BIT,
 					  NETIF_F_TSO_BIT,
 					  NETIF_F_TSO6_BIT);
-		return features;
+		return;
 	}
 
 	/* We can only support IPV4 TSO in tunnels if we can mangle the
 	 * inner IP ID field, so strip TSO if MANGLEID is not supported.
 	 */
-	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, features))
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
-
-	return features;
+	if (skb->encapsulation && !netdev_feature_test(NETIF_F_TSO_MANGLEID_BIT, *features))
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 }
 
 static int ixgbevf_xdp_setup(struct net_device *dev, struct bpf_prog *prog)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index a7e3ec4f034d..7cec4a97a3a1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2677,12 +2677,11 @@ static const struct udp_tunnel_nic_info mlx4_udp_tunnels = {
 	},
 };
 
-static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void mlx4_en_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
-	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 
 	/* The ConnectX-3 doesn't support outer IPv6 checksums but it does
 	 * support inner IPv6 checksums and segmentation so  we need to
@@ -2695,11 +2694,9 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_csum_gso_features_mask);
 	}
-
-	return features;
 }
 
 static int mlx4_en_set_tx_maxrate(struct net_device *dev, int queue_index, u32 maxrate)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 841e4fb520d7..c2dc487ac760 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -1240,9 +1240,8 @@ void mlx5e_build_nic_params(struct mlx5e_priv *priv, struct mlx5e_xsk *xsk, u16
 void mlx5e_rx_dim_work(struct work_struct *work);
 void mlx5e_tx_dim_work(struct work_struct *work);
 
-netdev_features_t mlx5e_features_check(struct sk_buff *skb,
-				       struct net_device *netdev,
-				       netdev_features_t features);
+void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
+			  netdev_features_t *features);
 int mlx5e_set_features(struct net_device *netdev, netdev_features_t features);
 #ifdef CONFIG_MLX5_ESWITCH
 int mlx5e_set_vf_mac(struct net_device *dev, int vf, u8 *mac);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 6f83eb46d18a..c3ad54f56de6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -90,8 +90,8 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 
-static inline netdev_features_t
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
+static inline void
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
 {
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp = skb_sec_path(skb);
@@ -115,14 +115,13 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 				goto out_disable;
 		}
 
-		return features;
+		return;
 
 	}
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 static inline bool
@@ -160,11 +159,10 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 }
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
-static inline netdev_features_t
-mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
+static inline void
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t *features)
 {
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
 static inline bool
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7d9f8863d921..7a7679262252 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4423,9 +4423,9 @@ static bool mlx5e_gre_tunnel_inner_proto_offload_supported(struct mlx5_core_dev
 	return false;
 }
 
-static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
-						     struct sk_buff *skb,
-						     netdev_features_t features)
+static void mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
+					struct sk_buff *skb,
+					netdev_features_t *features)
 {
 	unsigned int offset = 0;
 	struct udphdr *udph;
@@ -4446,12 +4446,12 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 	switch (proto) {
 	case IPPROTO_GRE:
 		if (mlx5e_gre_tunnel_inner_proto_offload_supported(priv->mdev, skb))
-			return features;
+			return;
 		break;
 	case IPPROTO_IPIP:
 	case IPPROTO_IPV6:
 		if (mlx5e_tunnel_proto_supported_tx(priv->mdev, IPPROTO_IPIP))
-			return features;
+			return;
 		break;
 	case IPPROTO_UDP:
 		udph = udp_hdr(skb);
@@ -4459,42 +4459,39 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 		/* Verify if UDP port is being offloaded by HW */
 		if (mlx5_vxlan_lookup_port(priv->mdev->vxlan, port))
-			return features;
+			return;
 
 #if IS_ENABLED(CONFIG_GENEVE)
 		/* Support Geneve offload for default UDP port */
 		if (port == GENEVE_UDP_PORT && mlx5_geneve_tx_allowed(priv->mdev))
-			return features;
+			return;
 #endif
 		break;
 #ifdef CONFIG_MLX5_EN_IPSEC
 	case IPPROTO_ESP:
-		return mlx5e_ipsec_feature_check(skb, features);
+		mlx5e_ipsec_feature_check(skb, features);
+		return;
 #endif
 	}
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	netdev_features_clear(features, netdev_csum_gso_features_mask);
-	return features;
+	netdev_features_clear(*features, netdev_csum_gso_features_mask);
 }
 
-netdev_features_t mlx5e_features_check(struct sk_buff *skb,
-				       struct net_device *netdev,
-				       netdev_features_t features)
+void mlx5e_features_check(struct sk_buff *skb, struct net_device *netdev,
+			  netdev_features_t *features)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
-	    (netdev_features_intersects(features, NETIF_F_CSUM_MASK) ||
-	     netdev_features_intersects(features, NETIF_F_GSO_MASK)))
-		return mlx5e_tunnel_features_check(priv, skb, features);
-
-	return features;
+	    (netdev_features_intersects(*features, NETIF_F_CSUM_MASK) ||
+	     netdev_features_intersects(*features, NETIF_F_GSO_MASK)))
+		mlx5e_tunnel_features_check(priv, skb, features);
 }
 
 static void mlx5e_tx_timeout_work(struct work_struct *work)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e2ae7c147e45..164fbeaa1ca4 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1781,19 +1781,17 @@ nfp_net_fix_features(struct net_device *netdev,
 	return features;
 }
 
-static netdev_features_t
+static void
 nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+		       netdev_features_t *features)
 {
-	netdev_features_t feats;
 	u8 l4_hdr;
 
 	/* We can't do TSO over double tagged packets (802.1AD) */
-	feats = vlan_features_check(skb, features);
-	netdev_features_mask(features, feats);
+	vlan_features_check(skb, features);
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
 	/* Ensure that inner L4 header offset fits into TX descriptor field */
 	if (skb_is_gso(skb)) {
@@ -1805,7 +1803,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		 * metadata prepend - 8B
 		 */
 		if (unlikely(hdrlen > NFP_NET_LSO_MAX_HDR_SZ - 8))
-			netdev_features_clear(features, NETIF_F_GSO_MASK);
+			netdev_features_clear(*features, NETIF_F_GSO_MASK);
 	}
 
 	/* VXLAN/GRE check */
@@ -1817,8 +1815,8 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		netdev_features_clear(features, netdev_csum_gso_features_mask);
-		return features;
+		netdev_features_clear(*features, netdev_csum_gso_features_mask);
+		return;
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -1827,11 +1825,9 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)))) {
-		netdev_features_clear(features, netdev_csum_gso_features_mask);
-		return features;
+		netdev_features_clear(*features, netdev_csum_gso_features_mask);
+		return;
 	}
-
-	return features;
 }
 
 static int
diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..c1f26a2e374d 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -527,9 +527,8 @@ int qede_xdp_transmit(struct net_device *dev, int n_frames,
 		      struct xdp_frame **frames, u32 flags);
 u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 		      struct net_device *sb_dev);
-netdev_features_t qede_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features);
+void qede_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features);
 int qede_alloc_rx_buffer(struct qede_rx_queue *rxq, bool allow_lazy);
 int qede_free_tx_pkt(struct qede_dev *edev,
 		     struct qede_tx_queue *txq, int *len);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 2bbbc7591965..c947b91c42b1 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1756,9 +1756,8 @@ u16 qede_select_queue(struct net_device *dev, struct sk_buff *skb,
 /* 8B udp header + 8B base tunnel header + 32B option length */
 #define QEDE_MAX_TUN_HDR_LEN 48
 
-netdev_features_t qede_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features)
+void qede_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features)
 {
 	if (skb->encapsulation) {
 		u8 l4_proto = 0;
@@ -1771,7 +1770,7 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features;
+			return;
 		}
 
 		/* Disable offloads for geneve tunnels, as HW can't parse
@@ -1790,19 +1789,17 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
 			      ntohs(udp_hdr(skb)->dest) != gnv_port)) {
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      netdev_csum_gso_features_mask);
-				return features;
+				return;
 			}
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_csum_gso_features_mask);
-			return features;
+			return;
 		}
 	}
-
-	return features;
 }
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 3115a942a865..94b5b96ad9fb 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -494,12 +494,11 @@ static const struct udp_tunnel_nic_info qlcnic_udp_tunnels = {
 	},
 };
 
-static netdev_features_t qlcnic_features_check(struct sk_buff *skb,
-					       struct net_device *dev,
-					       netdev_features_t features)
+static void qlcnic_features_check(struct sk_buff *skb, struct net_device *dev,
+				  netdev_features_t *features)
 {
-	features = vlan_features_check(skb, features);
-	return vxlan_features_check(skb, features);
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops qlcnic_netdev_ops = {
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 56c9e0627577..65dd210b0b25 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1858,14 +1858,13 @@ static void cp_set_d3_state (struct cp_private *cp)
 	pci_set_power_state (cp->pdev, PCI_D3hot);
 }
 
-static netdev_features_t cp_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features)
+static void cp_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features)
 {
 	if (skb_shinfo(skb)->gso_size > MSSMask)
-		netdev_feature_del(NETIF_F_TSO_BIT, features);
+		netdev_feature_del(NETIF_F_TSO_BIT, *features);
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 }
 static const struct net_device_ops cp_netdev_ops = {
 	.ndo_open		= cp_open,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 81d7a4eb2a5a..7434f3c06dc6 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4264,52 +4264,48 @@ static unsigned int rtl_last_frag_len(struct sk_buff *skb)
 }
 
 /* Workaround for hw issues with TSO on RTL8168evl */
-static netdev_features_t rtl8168evl_fix_tso(struct sk_buff *skb,
-					    netdev_features_t features)
+static void rtl8168evl_fix_tso(struct sk_buff *skb, netdev_features_t *features)
 {
 	/* IPv4 header has options field */
 	if (vlan_get_protocol(skb) == htons(ETH_P_IP) &&
 	    ip_hdrlen(skb) > sizeof(struct iphdr))
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 
 	/* IPv4 TCP header has options field */
 	else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV4 &&
 		 tcp_hdrlen(skb) > sizeof(struct tcphdr))
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 
 	else if (rtl_last_frag_len(skb) <= 6)
-		netdev_features_clear(features, NETIF_F_ALL_TSO);
-
-	return features;
+		netdev_features_clear(*features, NETIF_F_ALL_TSO);
 }
 
-static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
-						struct net_device *dev,
-						netdev_features_t features)
+static void rtl8169_features_check(struct sk_buff *skb, struct net_device *dev,
+				   netdev_features_t *features)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
 	if (skb_is_gso(skb)) {
 		if (tp->mac_version == RTL_GIGA_MAC_VER_34)
-			features = rtl8168evl_fix_tso(skb, features);
+			rtl8168evl_fix_tso(skb, features);
 
 		if (skb_transport_offset(skb) > GTTCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			netdev_features_clear(features, NETIF_F_ALL_TSO);
+			netdev_features_clear(*features, NETIF_F_ALL_TSO);
 	} else if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		/* work around hw bug on some chip versions */
 		if (skb->len < ETH_ZLEN)
-			netdev_features_clear(features, NETIF_F_CSUM_MASK);
+			netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 
 		if (rtl_quirk_packet_padto(tp, skb))
-			netdev_features_clear(features, NETIF_F_CSUM_MASK);
+			netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 
 		if (skb_transport_offset(skb) > TCPHO_MAX &&
 		    rtl_chip_supports_csum_v2(tp))
-			netdev_features_clear(features, NETIF_F_CSUM_MASK);
+			netdev_features_clear(*features, NETIF_F_CSUM_MASK);
 	}
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 }
 
 static void rtl8169_pcierr_interrupt(struct net_device *dev)
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 9a52492f3f06..df921615ba5a 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1355,26 +1355,25 @@ static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
 	}
 }
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features)
+void efx_features_check(struct sk_buff *skb, struct net_device *dev,
+			netdev_features_t *features)
 {
 	struct efx_nic *efx = efx_netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (netdev_features_intersects(features, NETIF_F_GSO_MASK))
+		if (netdev_features_intersects(*features, NETIF_F_GSO_MASK))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      NETIF_F_GSO_MASK);
-		if (netdev_features_intersects(features, netdev_csum_gso_features_mask))
+		if (netdev_features_intersects(*features, netdev_csum_gso_features_mask))
 			if (!efx_can_encap_offloads(efx, skb))
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      netdev_csum_gso_features_mask);
 	}
-	return features;
 }
 
 int efx_get_phys_port_id(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 2c54dac3e662..a191f85b3f5d 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -103,8 +103,8 @@ int efx_change_mtu(struct net_device *net_dev, int new_mtu);
 
 extern const struct pci_error_handlers efx_err_handlers;
 
-netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev,
-				     netdev_features_t features);
+void efx_features_check(struct sk_buff *skb, struct net_device *dev,
+			netdev_features_t *features);
 
 int efx_get_phys_port_id(struct net_device *net_dev,
 			 struct netdev_phys_item_id *ppid);
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 5360c6d6c026..12aa69a679cf 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1367,27 +1367,25 @@ static bool efx_can_encap_offloads(struct efx_nic *efx, struct sk_buff *skb)
 	}
 }
 
-netdev_features_t efx_siena_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features)
+void efx_siena_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features)
 {
 	struct efx_nic *efx = netdev_priv(dev);
 
 	if (skb->encapsulation) {
-		if (netdev_features_intersects(features, NETIF_F_GSO_MASK))
+		if (netdev_features_intersects(*features, NETIF_F_GSO_MASK))
 			/* Hardware can only do TSO with at most 208 bytes
 			 * of headers.
 			 */
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      (NETIF_F_GSO_MASK));
-		if (netdev_features_intersects(features, netdev_csum_gso_features_mask))
+		if (netdev_features_intersects(*features, netdev_csum_gso_features_mask))
 			if (!efx_can_encap_offloads(efx, skb))
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      netdev_csum_gso_features_mask);
 	}
-	return features;
 }
 
 int efx_siena_get_phys_port_id(struct net_device *net_dev,
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.h b/drivers/net/ethernet/sfc/siena/efx_common.h
index aeb92f4e34b7..d0e2cefba6cb 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.h
+++ b/drivers/net/ethernet/sfc/siena/efx_common.h
@@ -106,9 +106,8 @@ int efx_siena_change_mtu(struct net_device *net_dev, int new_mtu);
 
 extern const struct pci_error_handlers efx_siena_err_handlers;
 
-netdev_features_t efx_siena_features_check(struct sk_buff *skb,
-					   struct net_device *dev,
-					   netdev_features_t features);
+void efx_siena_features_check(struct sk_buff *skb, struct net_device *dev,
+			      netdev_features_t *features);
 
 int efx_siena_get_phys_port_id(struct net_device *net_dev,
 			       struct netdev_phys_item_id *ppid);
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index db7eae1b976e..6cf85b19d4ac 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -4284,19 +4284,17 @@ static void lan78xx_tx_timeout(struct net_device *net, unsigned int txqueue)
 	napi_schedule(&dev->napi);
 }
 
-static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
-						struct net_device *netdev,
-						netdev_features_t features)
+static void lan78xx_features_check(struct sk_buff *skb,
+				   struct net_device *netdev,
+				   netdev_features_t *features)
 {
 	struct lan78xx_net *dev = netdev_priv(netdev);
 
 	if (skb->len > LAN78XX_TSO_SIZE(dev))
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 
-	features = vlan_features_check(skb, features);
-	features = vxlan_features_check(skb, features);
-
-	return features;
+	vlan_features_check(skb, features);
+	vxlan_features_check(skb, features);
 }
 
 static const struct net_device_ops lan78xx_netdev_ops = {
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index e835a7be2a67..edce2a0d3dd7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2762,21 +2762,19 @@ static void _rtl8152_set_rx_mode(struct net_device *netdev)
 	netif_wake_queue(netdev);
 }
 
-static netdev_features_t
+static void
 rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
-		       netdev_features_t features)
+		       netdev_features_t *features)
 {
 	u32 mss = skb_shinfo(skb)->gso_size;
 	int max_offset = mss ? GTTCPHO_MAX : TCPHO_MAX;
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
 	    skb_transport_offset(skb) > max_offset)
-		netdev_features_clear(features,
+		netdev_features_clear(*features,
 				      netdev_csum_gso_features_mask);
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
-
-	return features;
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
 }
 
 static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index ff1d4218135f..9b7adc83c210 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -256,9 +256,8 @@ netdev_features_t vmxnet3_fix_features(struct net_device *netdev,
 	return features;
 }
 
-netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
-					 struct net_device *netdev,
-					 netdev_features_t features)
+void vmxnet3_features_check(struct sk_buff *skb, struct net_device *netdev,
+			    netdev_features_t *features)
 {
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
@@ -277,9 +276,9 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_csum_gso_features_mask);
-			return features;
+			return;
 		}
 
 		switch (l4_proto) {
@@ -290,18 +289,17 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				netdev_features_clear(features,
+				netdev_features_clear(*features,
 						      netdev_csum_gso_features_mask);
-				return features;
+				return;
 			}
 			break;
 		default:
-			netdev_features_clear(features,
+			netdev_features_clear(*features,
 					      netdev_csum_gso_features_mask);
-			return features;
+			return;
 		}
 	}
-	return features;
 }
 
 static void vmxnet3_enable_encap_offloads(struct net_device *netdev, netdev_features_t features)
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 82d661d919f6..4fe7be614c05 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -494,9 +494,9 @@ vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
-netdev_features_t
+void
 vmxnet3_features_check(struct sk_buff *skb,
-		       struct net_device *netdev, netdev_features_t features);
+		       struct net_device *netdev, netdev_features_t *features);
 
 int
 vmxnet3_set_features(struct net_device *netdev, netdev_features_t features);
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 1d195429753d..3015edb0ac66 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1088,9 +1088,8 @@ int qeth_setassparms_cb(struct qeth_card *, struct qeth_reply *, unsigned long);
 int qeth_set_features(struct net_device *, netdev_features_t);
 void qeth_enable_hw_features(struct net_device *dev);
 netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
-netdev_features_t qeth_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features);
+void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features);
 void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
 int qeth_set_real_num_tx_queues(struct qeth_card *card, unsigned int count);
 u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 72c487009c33..9bed9ba8f6c4 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6873,9 +6873,8 @@ netdev_features_t qeth_fix_features(struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(qeth_fix_features);
 
-netdev_features_t qeth_features_check(struct sk_buff *skb,
-				      struct net_device *dev,
-				      netdev_features_t features)
+void qeth_features_check(struct sk_buff *skb, struct net_device *dev,
+			 netdev_features_t *features)
 {
 	struct qeth_card *card = dev->ml_priv;
 
@@ -6885,7 +6884,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 		netdev_features_t restricted;
 
 		netdev_features_zero(restricted);
-		if (skb_is_gso(skb) && !netif_needs_gso(skb, features))
+		if (skb_is_gso(skb) && !netif_needs_gso(skb, *features))
 			netdev_features_set(restricted, NETIF_F_ALL_TSO);
 
 		switch (vlan_get_protocol(skb)) {
@@ -6895,7 +6894,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   restricted);
 
 			if (restricted && qeth_next_hop_is_local_v4(card, skb))
-				netdev_features_clear(features, restricted);
+				netdev_features_clear(*features, restricted);
 			break;
 		case htons(ETH_P_IPV6):
 			if (!card->info.has_lp2lp_cso_v6)
@@ -6903,7 +6902,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 						   restricted);
 
 			if (restricted && qeth_next_hop_is_local_v6(card, skb))
-				netdev_features_clear(features, restricted);
+				netdev_features_clear(*features, restricted);
 			break;
 		default:
 			break;
@@ -6917,7 +6916,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 	 * additional buffer element. This reduces buffer utilization, and
 	 * hurts throughput. So compress small segments into one element.
 	 */
-	if (netif_needs_gso(skb, features)) {
+	if (netif_needs_gso(skb, *features)) {
 		/* match skb_segment(): */
 		unsigned int doffset = skb->data - skb_mac_header(skb);
 		unsigned int hsize = skb_shinfo(skb)->gso_size;
@@ -6925,10 +6924,10 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 
 		/* linearize only if resulting skb allocations are order-0: */
 		if (SKB_DATA_ALIGN(hroom + doffset + hsize) <= SKB_MAX_HEAD(0))
-			netdev_feature_del(NETIF_F_SG_BIT, features);
+			netdev_feature_del(NETIF_F_SG_BIT, *features);
 	}
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 }
 EXPORT_SYMBOL_GPL(qeth_features_check);
 
diff --git a/drivers/s390/net/qeth_l3_main.c b/drivers/s390/net/qeth_l3_main.c
index ecc32a217e31..a3a9fcf459ee 100644
--- a/drivers/s390/net/qeth_l3_main.c
+++ b/drivers/s390/net/qeth_l3_main.c
@@ -1804,13 +1804,13 @@ qeth_l3_neigh_setup(struct net_device *dev, struct neigh_parms *np)
 	return 0;
 }
 
-static netdev_features_t qeth_l3_osa_features_check(struct sk_buff *skb,
-						    struct net_device *dev,
-						    netdev_features_t features)
+static void qeth_l3_osa_features_check(struct sk_buff *skb,
+				       struct net_device *dev,
+				       netdev_features_t *features)
 {
 	if (vlan_get_protocol(skb) != htons(ETH_P_IP))
-		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, features);
-	return qeth_features_check(skb, dev, features);
+		netdev_feature_del(NETIF_F_HW_VLAN_CTAG_TX_BIT, *features);
+	qeth_features_check(skb, dev, features);
 }
 
 static u16 qeth_l3_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 7adac714c78b..4fef74864267 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -731,12 +731,11 @@ static inline bool skb_vlan_tagged_multi(struct sk_buff *skb)
 /**
  * vlan_features_check - drop unsafe features for skb with multiple tags.
  * @skb: skbuff to query
- * @features: features to be checked
- *
- * Returns features without unsafe ones if the skb has multiple tags.
+ * @features: features to be checked, returns features without unsafe ones
+ *	if the skb has multiple tags.
  */
-static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
-						    netdev_features_t features)
+static inline void vlan_features_check(struct sk_buff *skb,
+				       netdev_features_t *features)
 {
 	if (skb_vlan_tagged_multi(skb)) {
 		/* In the case of multi-tagged packets, use a direct mask
@@ -744,11 +743,9 @@ static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		netdev_features_mask(features,
+		netdev_features_mask(*features,
 				     netdev_multi_tags_features_mask);
 	}
-
-	return features;
 }
 
 /**
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 75a839cf5cd2..78b0c501a24a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1385,9 +1385,9 @@ struct net_device_ops {
 	int			(*ndo_stop)(struct net_device *dev);
 	netdev_tx_t		(*ndo_start_xmit)(struct sk_buff *skb,
 						  struct net_device *dev);
-	netdev_features_t	(*ndo_features_check)(struct sk_buff *skb,
+	void			(*ndo_features_check)(struct sk_buff *skb,
 						      struct net_device *dev,
-						      netdev_features_t features);
+						      netdev_features_t *features);
 	u16			(*ndo_select_queue)(struct net_device *dev,
 						    struct sk_buff *skb,
 						    struct net_device *sb_dev);
@@ -4912,9 +4912,8 @@ void netdev_change_features(struct net_device *dev);
 void netif_stacked_transfer_operstate(const struct net_device *rootdev,
 					struct net_device *dev);
 
-netdev_features_t passthru_features_check(struct sk_buff *skb,
-					  struct net_device *dev,
-					  netdev_features_t features);
+void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
+			     netdev_features_t *features);
 void netif_skb_features(struct sk_buff *skb, netdev_features_t *features);
 
 static inline bool net_gso_ok(netdev_features_t features, int gso_type)
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index d0e4729acebc..25d2bc8015c7 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -347,13 +347,13 @@ struct vxlan_dev {
 struct net_device *vxlan_dev_create(struct net *net, const char *name,
 				    u8 name_assign_type, struct vxlan_config *conf);
 
-static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
-						     netdev_features_t features)
+static inline void vxlan_features_check(struct sk_buff *skb,
+					netdev_features_t *features)
 {
 	u8 l4_hdr = 0;
 
 	if (!skb->encapsulation)
-		return features;
+		return;
 
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
@@ -363,7 +363,7 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features;
+		return;
 	}
 
 	if ((l4_hdr == IPPROTO_UDP) &&
@@ -372,12 +372,10 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
-	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto)))) {
-		netdev_features_clear(features, netdev_csum_gso_features_mask);
-		return features;
+	      !can_checksum_protocol(*features, inner_eth_hdr(skb)->h_proto)))) {
+		netdev_features_clear(*features, netdev_csum_gso_features_mask);
+		return;
 	}
-
-	return features;
 }
 
 /* IP header + UDP + VXLAN + Ethernet header */
diff --git a/net/core/dev.c b/net/core/dev.c
index 695b724a4054..5e84fdc8c7f5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3490,36 +3490,33 @@ static void harmonize_features(struct sk_buff *skb, netdev_features_t *features)
 		netdev_feature_del(NETIF_F_SG_BIT, *features);
 }
 
-netdev_features_t passthru_features_check(struct sk_buff *skb,
-					  struct net_device *dev,
-					  netdev_features_t features)
+void passthru_features_check(struct sk_buff *skb, struct net_device *dev,
+			     netdev_features_t *features)
 {
-	return features;
 }
 EXPORT_SYMBOL(passthru_features_check);
 
-static netdev_features_t dflt_features_check(struct sk_buff *skb,
-					     struct net_device *dev,
-					     netdev_features_t features)
+static void dflt_features_check(struct sk_buff *skb, struct net_device *dev,
+				netdev_features_t *features)
 {
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, features);
 }
 
-static netdev_features_t gso_features_check(const struct sk_buff *skb,
-					    struct net_device *dev,
-					    netdev_features_t features)
+static void gso_features_check(const struct sk_buff *skb,
+			       struct net_device *dev,
+			       netdev_features_t *features)
 {
 	u16 gso_segs = skb_shinfo(skb)->gso_segs;
 
 	if (gso_segs > READ_ONCE(dev->gso_max_segs)) {
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
-		return features;
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
+		return;
 	}
 
 	if (!skb_shinfo(skb)->gso_type) {
 		skb_warn_bad_offload(skb);
-		netdev_features_clear(features, NETIF_F_GSO_MASK);
-		return features;
+		netdev_features_clear(*features, NETIF_F_GSO_MASK);
+		return;
 	}
 
 	/* Support for GSO partial features requires software
@@ -3529,7 +3526,7 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 	 * segmented the frame.
 	 */
 	if (!(skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL))
-		netdev_features_clear(features, dev->gso_partial_features);
+		netdev_features_clear(*features, dev->gso_partial_features);
 
 	/* Make sure to clear the IPv4 ID mangling feature if the
 	 * IPv4 header has the potential to be fragmented.
@@ -3540,10 +3537,8 @@ static netdev_features_t gso_features_check(const struct sk_buff *skb,
 
 		if (!(iph->frag_off & htons(IP_DF)))
 			netdev_feature_del(NETIF_F_TSO_MANGLEID_BIT,
-					   features);
+					   *features);
 	}
-
-	return features;
 }
 
 void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
@@ -3554,7 +3549,7 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 	netdev_features_copy(*features, dev->features);
 
 	if (skb_is_gso(skb))
-		*features = gso_features_check(skb, dev, *features);
+		gso_features_check(skb, dev, features);
 
 	/* If encapsulation offload request, verify we are testing
 	 * hardware encapsulation features instead of standard
@@ -3570,10 +3565,9 @@ void netif_skb_features(struct sk_buff *skb, netdev_features_t *features)
 	}
 
 	if (dev->netdev_ops->ndo_features_check)
-		tmp = dev->netdev_ops->ndo_features_check(skb, dev, *features);
+		dev->netdev_ops->ndo_features_check(skb, dev, features);
 	else
-		tmp = dflt_features_check(skb, dev, *features);
-	netdev_features_mask(*features, tmp);
+		dflt_features_check(skb, dev, features);
 
 	harmonize_features(skb, features);
 }
-- 
2.33.0

