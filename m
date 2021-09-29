Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B8841C8F0
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 17:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345688AbhI2QAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 12:00:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:23240 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343741AbhI2P7m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 11:59:42 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKLbg4tfwz8tCJ;
        Wed, 29 Sep 2021 23:57:03 +0800 (CST)
Received: from dggpeml500022.china.huawei.com (7.185.36.66) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:56 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Wed, 29 Sep 2021 23:57:55 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <hkallweit1@gmail.com>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv2 net-next 006/167] net: convert the prototype of vlan_features_check
Date:   Wed, 29 Sep 2021 23:50:53 +0800
Message-ID: <20210929155334.12454-7-shenjian15@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210929155334.12454-1-shenjian15@huawei.com>
References: <20210929155334.12454-1-shenjian15@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500022.china.huawei.com (7.185.36.66)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the origin type for netdev_features_t would be changed to
be unsigned long * from u64, so changes the prototype of
vlan_features_check for adaption.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c            |  2 +-
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c    |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c           |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c         |  2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c   |  2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c |  2 +-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c    |  2 +-
 drivers/net/ethernet/realtek/8139cp.c               |  3 ++-
 drivers/net/ethernet/realtek/r8169_main.c           |  3 ++-
 drivers/net/usb/lan78xx.c                           |  2 +-
 drivers/s390/net/qeth_core_main.c                   |  3 ++-
 include/linux/if_vlan.h                             | 12 +++++-------
 net/core/dev.c                                      |  3 ++-
 14 files changed, 22 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 17a585adfb49..3fb15f675ddf 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2271,7 +2271,7 @@ static netdev_features_t xgbe_features_check(struct sk_buff *skb,
 					     struct net_device *netdev,
 					     netdev_features_t features)
 {
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	features = vxlan_features_check(skb, features);
 
 	return features;
diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
index ae87296ae1ff..105aae3e21bf 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c
@@ -12856,7 +12856,7 @@ static netdev_features_t bnx2x_features_check(struct sk_buff *skb,
 		     !skb_gso_validate_mac_len(skb, 9700)))
 		features &= ~NETIF_F_GSO_MASK;
 
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	return vxlan_features_check(skb, features);
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 0fba01db336c..775dfcdd35f2 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11097,7 +11097,7 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 	struct bnxt *bp = netdev_priv(dev);
 	u8 *l4_proto;
 
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
 		if (!skb->encapsulation)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 361c1c87c183..556242d32d93 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5092,7 +5092,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 	 * Q-in-Q packets.
 	 * Offload features for normal (non tunnel) packets are unchanged.
 	 */
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	if (!skb->encapsulation ||
 	    !(adapter->flags & BE_FLAGS_VXLAN_OFFLOADS))
 		return features;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 8af7f2827322..a3c2a3e2d392 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2678,7 +2678,7 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 						struct net_device *dev,
 						netdev_features_t features)
 {
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	features = vxlan_features_check(skb, features);
 
 	/* The ConnectX-3 doesn't support outer IPv6 checksums but it does
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 3fd515e7bf30..b6aa5da06776 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3910,7 +3910,7 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	features = vxlan_features_check(skb, features);
 
 	/* Validate if the tunneled packet is being offloaded by HW */
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index 5bfa22accf2c..58e7d98d0dd6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3605,7 +3605,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	u8 l4_hdr;
 
 	/* We can't do TSO over double tagged packets (802.1AD) */
-	features &= vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 
 	if (!skb->encapsulation)
 		return features;
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
index 75960a29f80e..8f3a2a021082 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c
@@ -496,7 +496,7 @@ static netdev_features_t qlcnic_features_check(struct sk_buff *skb,
 					       struct net_device *dev,
 					       netdev_features_t features)
 {
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	return vxlan_features_check(skb, features);
 }
 
diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 2b84b4565e64..d2135fe99cd7 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -1860,7 +1860,8 @@ static netdev_features_t cp_features_check(struct sk_buff *skb,
 	if (skb_shinfo(skb)->gso_size > MSSMask)
 		features &= ~NETIF_F_TSO;
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
+	return features;
 }
 static const struct net_device_ops cp_netdev_ops = {
 	.ndo_open		= cp_open,
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0199914440ab..98e7ffa6aa0a 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4374,7 +4374,8 @@ static netdev_features_t rtl8169_features_check(struct sk_buff *skb,
 			features &= ~NETIF_F_CSUM_MASK;
 	}
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
+	return features;
 }
 
 static void rtl8169_pcierr_interrupt(struct net_device *dev)
diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 793f8fbe0069..bf477ea4ac26 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -3983,7 +3983,7 @@ static netdev_features_t lan78xx_features_check(struct sk_buff *skb,
 	if (skb->len + TX_OVERHEAD > MAX_SINGLE_PACKET_SIZE)
 		features &= ~NETIF_F_GSO_MASK;
 
-	features = vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
 	features = vxlan_features_check(skb, features);
 
 	return features;
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index e9807d2996a9..3b1903f8790a 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -6998,7 +6998,8 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 			features &= ~NETIF_F_SG;
 	}
 
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
+	return features;
 }
 EXPORT_SYMBOL_GPL(qeth_features_check);
 
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 41a518336673..2337538ef015 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -727,8 +727,8 @@ static inline bool skb_vlan_tagged_multi(struct sk_buff *skb)
  *
  * Returns features without unsafe ones if the skb has multiple tags.
  */
-static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
-						    netdev_features_t features)
+static inline void vlan_features_check(struct sk_buff *skb,
+				       netdev_features_t *features)
 {
 	if (skb_vlan_tagged_multi(skb)) {
 		/* In the case of multi-tagged packets, use a direct mask
@@ -736,12 +736,10 @@ static inline netdev_features_t vlan_features_check(struct sk_buff *skb,
 		 * sure that only devices supporting NETIF_F_HW_CSUM will
 		 * have checksum offloading support.
 		 */
-		features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
-			    NETIF_F_FRAGLIST | NETIF_F_HW_VLAN_CTAG_TX |
-			    NETIF_F_HW_VLAN_STAG_TX;
+		*features &= NETIF_F_SG | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM |
+			     NETIF_F_FRAGLIST | NETIF_F_HW_VLAN_CTAG_TX |
+			     NETIF_F_HW_VLAN_STAG_TX;
 	}
-
-	return features;
 }
 
 /**
diff --git a/net/core/dev.c b/net/core/dev.c
index b3426559bac7..85d894e06f4e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3484,7 +3484,8 @@ static netdev_features_t dflt_features_check(struct sk_buff *skb,
 					     struct net_device *dev,
 					     netdev_features_t features)
 {
-	return vlan_features_check(skb, features);
+	vlan_features_check(skb, &features);
+	return features;
 }
 
 static void gso_features_check(const struct sk_buff *skb,
-- 
2.33.0

