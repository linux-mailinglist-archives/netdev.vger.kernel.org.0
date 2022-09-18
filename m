Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D097D5BBCF5
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 11:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiIRJuK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 05:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229724AbiIRJt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 05:49:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45DDC11C01
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 02:49:49 -0700 (PDT)
Received: from dggpeml500022.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4MVjc516JFzmVM9;
        Sun, 18 Sep 2022 17:45:57 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500022.china.huawei.com (7.185.36.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sun, 18 Sep 2022 17:49:48 +0800
From:   Jian Shen <shenjian15@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ecree.xilinx@gmail.com>,
        <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        <alexandr.lobakin@intel.com>, <saeed@kernel.org>, <leon@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>
Subject: [RFCv8 PATCH net-next 10/55] treewide: replace NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK by netdev_csum_gso_features_mask
Date:   Sun, 18 Sep 2022 09:42:51 +0000
Message-ID: <20220918094336.28958-11-shenjian15@huawei.com>
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
index a737cc9d2752..57559609d116 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -11391,7 +11391,7 @@ static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 			return features;
 		break;
 	}
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 int bnxt_dbg_hwrm_rd_reg(struct bnxt *bp, u32 reg_off, u16 num_words,
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 964a98ae9556..8e36455ab9ed 100644
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
index 24f9c5497b8a..9449b6b5b865 100644
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
index 55c0a66acad2..35b4d335e97c 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -5122,7 +5122,7 @@ static netdev_features_t be_features_check(struct sk_buff *skb,
 		sizeof(struct udphdr) + sizeof(struct vxlanhdr) ||
 	    !adapter->vxlan_port ||
 	    udp_hdr(skb)->dest != adapter->vxlan_port)
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 
 	return features;
 }
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index e91e1d39800d..fa773037a484 100644
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
index d0790e2b8a92..d0da306457d2 100644
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
index fd2cac55cb31..2dbe94cf3db3 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -13235,7 +13235,7 @@ static netdev_features_t i40e_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 34d55e5b461c..3b51eacadec5 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -4431,7 +4431,7 @@ static netdev_features_t iavf_features_check(struct sk_buff *skb,
 
 	return features;
 out_err:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index dab06a6c12d2..c3a007f720d8 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -9042,7 +9042,7 @@ ice_features_check(struct sk_buff *skb,
 
 	return features;
 out_rm_features:
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 static const struct net_device_ops ice_netdev_safe_mode_ops = {
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 2561daf63151..c32b5f170cd6 100644
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
index c72b62f52574..7ea2f59d73ed 100644
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
index 8b1be6bfb475..42dc65abfcd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4472,7 +4472,7 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 
 out:
 	/* Disable CSUM and GSO if the udp dport is not offloaded by HW */
-	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+	return features & ~netdev_csum_gso_features_mask;
 }
 
 netdev_features_t mlx5e_features_check(struct sk_buff *skb,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index e6d11d509145..4b38f3105523 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -1810,7 +1810,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
 		l4_hdr = ipv6_hdr(skb)->nexthdr;
 		break;
 	default:
-		return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		return features & ~netdev_csum_gso_features_mask;
 	}
 
 	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
@@ -1819,7 +1819,7 @@ nfp_net_features_check(struct sk_buff *skb, struct net_device *dev,
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
index c2224e41a694..f7ae65d53c78 100644
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
index 1fd396b00bfb..c8389da6509d 100644
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
index b64ac07157df..0adc6cc0121f 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2771,7 +2771,7 @@ rtl8152_features_check(struct sk_buff *skb, struct net_device *dev,
 
 	if ((mss || skb->ip_summed == CHECKSUM_PARTIAL) &&
 	    skb_transport_offset(skb) > max_offset)
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 	else if ((skb->len + sizeof(struct tx_desc)) > agg_buf_sz)
 		features &= ~NETIF_F_GSO_MASK;
 
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 7f44673ceb2e..3f5006cf8cc1 100644
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
index a7da9862540d..103e1022bb0d 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3486,7 +3486,7 @@ static netdev_features_t harmonize_features(struct sk_buff *skb,
 
 	if (skb->ip_summed != CHECKSUM_NONE &&
 	    !can_checksum_protocol(features, type)) {
-		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+		features &= ~netdev_csum_gso_features_mask;
 	}
 	if (illegal_highdma(skb->dev, skb))
 		features &= ~NETIF_F_SG;
-- 
2.33.0

