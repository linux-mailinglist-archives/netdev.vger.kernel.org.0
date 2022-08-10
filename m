Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE158E557
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 05:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiHJDOj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 23:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiHJDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 23:13:54 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB9C982F92
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 20:13:51 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4M2Zfr2JRQzXdT1;
        Wed, 10 Aug 2022 11:09:40 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 10 Aug 2022 11:13:45 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <ecree.xilinx@gmail.com>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@openeuler.org>
Subject: [RFCv7 PATCH net-next 10/36] treewide: replace NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK by netdev_csum_gso_features_mask
Date:   Wed, 10 Aug 2022 11:05:58 +0800
Message-ID: <20220810030624.34711-11-shenjian15@huawei.com>
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

Replace the expression "NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK" by
netdev_csum_gso_features_mask, make it simple to use netdev
features helpers later.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c                   | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c             | 2 +-
 drivers/net/ethernet/cisco/enic/enic_main.c                 | 2 +-
 drivers/net/ethernet/emulex/benet/be_main.c                 | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c             | 2 +-
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c             | 2 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c                 | 2 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c                 | 2 +-
 drivers/net/ethernet/intel/ice/ice_main.c                   | 2 +-
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c              | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h   | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c           | 2 +-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c         | 4 ++--
 drivers/net/ethernet/qlogic/qede/qede_fp.c                  | 5 ++---
 drivers/net/ethernet/sfc/efx_common.c                       | 5 ++---
 drivers/net/ethernet/sfc/siena/efx_common.c                 | 5 ++---
 drivers/net/usb/r8152.c                                     | 2 +-
 drivers/net/vmxnet3/vmxnet3_ethtool.c                       | 6 +++---
 include/net/vxlan.h                                         | 2 +-
 net/core/dev.c                                              | 2 +-
 20 files changed, 27 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 825bf829b36a..37e2018fd875 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11393,7 +11393,7 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 			return features;
 		break;
 	}
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index f40e6964de89..7e61049247b9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -3850,7 +3850,7 @@ static netdev_features_t cxgb_features_check(struct sk_buff *skb,
 		return features;
 
 	/* Offload is not supported for this encapsulated packet */
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 static netdev_features_t cxgb_fix_features(struct net_device *dev,
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index 276fa370ce50..d999b3af2f8a 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -295,7 +295,7 @@ static netdev_features_t enic_features_check(struct sk_buff *skb,
 	return features;
 
 out:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 int enic_is_dynamic(struct enic *enic)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 964e7d6111df..22af4232329e 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5126,7 +5126,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
 	    udp_hdr(skb)->dest != adapter->vxlan_port)
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 
 	return features;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index df3f46d7f217..dccb20072d28 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2476,7 +2476,7 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	 * len of 480 bytes.
 	 */
 	if (len > HNS3_MAX_HDR_LEN)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 
 	return features;
 }
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index a42148582779..513ec9e7f037 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1512,7 +1512,7 @@ static netdev_features_t fm10k_features_check(struct sk_buff *skb,
 	if (!skb->encapsulation || fm10k_tx_encap_offload(skb))
 		return features;
 
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 static const struct net_device_ops fm10k_netdev_ops = {
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 69ac22c7e800..007931b7fcd0 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13237,7 +13237,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 55ab0229179f..afea95a58fbd 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4306,7 +4306,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 34a859ecae0d..81d8e3057808 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -8944,7 +8944,7 @@ ice_features_check(struct sk_buff *skb,
 
 	return features;
 out_rm_features:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 594a650b6bdc..be5197b5efc4 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -2695,7 +2695,7 @@ static netdev_features_t mlx4_en_features_check(struct sk_buff *skb,
 		if (!priv->vxlan_port ||
 		    (ip_hdr(skb)->version != 4) ||
 		    (udp_hdr(skb)->dest != priv->vxlan_port))
-			features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			features &= ~netdev_csum_gso_features_mask;
 	}
 
 	return features;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 0ae4e12ce528..f0f6251a5d87 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -121,7 +121,7 @@ mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 
 	/* Disable CSUM and GSO for software IPsec */
 out_disable:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 static inline bool
@@ -161,7 +161,7 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
-{ return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
+{ return features & ~netdev_csum_gso_features_mask; }
 
 static inline bool
 mlx5e_ipsec_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d858667736a3..c32468f81500 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4465,7 +4465,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index cf4d6f1129fa..b9bade6cd50e 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1806,7 +1806,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -1815,7 +1815,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 	    (l4_hdr == IPPROTO_UDP &&
 	     (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr))))
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 
 	return features;
 }
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 7c2af482192d..a6f28549f4b4 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -1790,13 +1790,12 @@ netdev_features_t qede_features_check(struct sk_buff *skb,
 			     skb_transport_header(skb)) > hdrlen ||
 			     (ntohs(udp_hdr(skb)->dest) != vxln_port &&
 			      ntohs(udp_hdr(skb)->dest) != gnv_port))
-				return features & ~(NETIF_F_CSUM_MASK |
-						    NETIF_F_GSO_MASK);
+				return features & ~netdev_csum_gso_features_mask;
 		} else if (l4_proto == IPPROTO_IPIP) {
 			/* IPIP tunnels are unknown to the device or at least unsupported natively,
 			 * offloads for them can't be done trivially, so disable them for such skb.
 			 */
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return features & ~netdev_csum_gso_features_mask;
 		}
 	}
 
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index a929a1aaba92..b6e0e4855821 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1365,10 +1365,9 @@ netdev_features_t efx_features_check(struct sk_buff *skb, struct net_device *dev
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
 				features &= ~(NETIF_F_GSO_MASK);
-		if (features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~(NETIF_F_GSO_MASK |
-					      NETIF_F_CSUM_MASK);
+				features &= ~netdev_csum_gso_features_mask;
 	}
 	return features;
 }
diff --git a/drivers/net/ethernet/sfc/siena/efx_common.c b/drivers/net/ethernet/sfc/siena/efx_common.c
index 954daf464abb..ef00f1d87876 100644
--- a/drivers/net/ethernet/sfc/siena/efx_common.c
+++ b/drivers/net/ethernet/sfc/siena/efx_common.c
@@ -1378,10 +1378,9 @@ netdev_features_t efx_siena_features_check(struct sk_buff *skb,
 			if (skb_inner_transport_offset(skb) >
 			    EFX_TSO2_MAX_HDRLEN)
 				features &= ~(NETIF_F_GSO_MASK);
-		if (features & (NETIF_F_GSO_MASK | NETIF_F_CSUM_MASK))
+		if (features & netdev_csum_gso_features_mask)
 			if (!efx_can_encap_offloads(efx, skb))
-				features &= ~(NETIF_F_GSO_MASK |
-					      NETIF_F_CSUM_MASK);
+				features &= ~netdev_csum_gso_features_mask;
 	}
 	return features;
 }
diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 5e11eaab71f5..218e10ee5442 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2768,7 +2768,7 @@ rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
 	    skb_transport_offset(skb) > max_offset)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
 		features &= ~NETIF_F_GSO_MASK;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 25b3243a9630..abc2aeb0559e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -277,7 +277,7 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			l4_proto = ipv6_hdr(skb)->nexthdr;
 			break;
 		default:
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return features & ~netdev_csum_gso_features_mask;
 		}
 
 		switch (l4_proto) {
@@ -288,11 +288,11 @@ netdev_features_t vmxnet3_features_check(struct sk_buff *skb,
 			if (port != GENEVE_UDP_PORT &&
 			    port != IANA_VXLAN_UDP_PORT &&
 			    port != VXLAN_UDP_PORT) {
-				return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+				return features & ~netdev_csum_gso_features_mask;
 			}
 			break;
 		default:
-			return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+			return features & ~netdev_csum_gso_features_mask;
 		}
 	}
 	return features;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index bca5b01af247..60a8675976c2 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -373,7 +373,7 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	      sizeof(struct udphdr) + sizeof(struct vxlanhdr)) ||
 	     (skb->ip_summed != CHECKSUM_NONE &&
 	      !can_checksum_protocol(features, inner_eth_hdr(skb)->h_proto))))
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 
 	return features;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 9603bac63ffb..7e600c69abe5 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3487,7 +3487,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
 		features &= ~NETIF_F_SG;
-- 
2.33.0

