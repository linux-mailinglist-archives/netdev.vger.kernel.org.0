Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1B252696D
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383369AbiEMSfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383363AbiEMSe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:59 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6371719CC
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso11563966pjb.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=i5p5k7rpU7op1tiw99AQW82x3B0PR3DOMQKdry4Mlzs=;
        b=aX/56dq8E5YH1ZOelCQlA/me9+3k7X/zDHRRdYBd/uORooIZjo9BXZqDVSFYIcAJmW
         g4nSrbmqFbpj3KybVSdpWVf4GVim3rruvE6qwAWkjlCoIHVKcZXsSW6fhoFCDTLgaZcp
         A7W8qq78cf/2gAYtfiitt7dCriwPIU83tb4Jg0kjT2dCn+YoXpecd2o4m8LsHZaHj26q
         OxXSotTgo4h47cF2WfrY1E8gIMyr92NzEklotpKuh1z12hb6mBNnlFuhrZs2Vo67wchC
         pxYuO7qBZI1zZExCladvw6lNrODAJBqJ+FOk3ZsG9xILVsCzGJfGyIiQBUeLmGvX3sL+
         1SkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=i5p5k7rpU7op1tiw99AQW82x3B0PR3DOMQKdry4Mlzs=;
        b=SGJJHX5vHD0GUXcNbuw0dYeausAya5dS4MGAyH7m8cjuEf8InXTt7YRT11RyQ+HbZU
         eE0JS9nD3r8XxZMpbIWga8Fanzt/s+gprYocJUKZ8z9pwxShk0UOrROqYgE/M4LTT108
         p30AlhOsnLet+BlhrbSRz5BRNtkoh5p2xT/b2gKGhcDyjnw1LjC71yo/QGD12gq2KSKC
         ceiSQNWyuAqqF4otyZ9b0DzmKMwQHpg1xtEnOVZRk8F67twNndAvp1/JDRZ6f1Weyq8R
         uJ2rs4X4ndjAYYvschbEXPADOKPlLTYnKJhgfM+OJU4jEnJqVsk3aUr7zmLLVVeNGVwn
         ycLQ==
X-Gm-Message-State: AOAM5304itS10RqLkYnWEqxAd3LGLUKdhcQ9u4iTeXyEPSIvTWps0AL2
        DKgIvVZgJwuRXZEspM1whE63/IIbKYY=
X-Google-Smtp-Source: ABdhPJzU1+5qxhD16Hr3NzqRwWkt3Tdl9VEHx0/cXMwunHF4rRC6ywJJsAPBNtFDEFQfwZL5FEnt/g==
X-Received: by 2002:a17:90b:4c85:b0:1dc:5778:5344 with SMTP id my5-20020a17090b4c8500b001dc57785344mr17406603pjb.8.1652466874198;
        Fri, 13 May 2022 11:34:34 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:33 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v7 net-next 13/13] mlx5: support BIG TCP packets
Date:   Fri, 13 May 2022 11:34:08 -0700
Message-Id: <20220513183408.686447-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

mlx5 supports LSOv2.

IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore/skip this HBH header when populating TX descriptor.

Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.

v7: adopt unsafe_memcpy() and MLX5_UNSAFE_MEMCPY_DISCLAIMER
v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()
v4: fix compile error for CONFIG_MLX5_CORE_IPOIB=y

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 111 ++++++++++++++----
 2 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d27986869b8ba070d1a4f8bcdc7e14ab54ae984e..bf3bca79e160124abd128ac1e9910cb2f39a39ff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4920,6 +4920,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
+	netif_set_tso_max_size(netdev, GSO_MAX_SIZE);
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_ktls_build_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 5855d8f9c509a5fcf1109e38a4395d46242fe745..50d14cec4894beda28f87a9a4079601131ec89ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,6 +40,7 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
+#include <net/ipv6.h>
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -91,6 +92,13 @@ static inline u16 mlx5e_calc_min_inline(enum mlx5_inline_modes mode,
 	return min_t(u16, hlen, skb_headlen(skb));
 }
 
+#define MLX5_UNSAFE_MEMCPY_DISCLAIMER				\
+	"This copy has been bounds-checked earlier in "		\
+	"mlx5i_sq_calc_wqe_attr() and intentionally "		\
+	"crosses a flex array boundary. Since it is "		\
+	"performance sensitive, splitting the copy is "		\
+	"undesirable."
+
 static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 {
 	struct vlan_ethhdr *vhdr = (struct vlan_ethhdr *)start;
@@ -100,7 +108,10 @@ static inline void mlx5e_insert_vlan(void *start, struct sk_buff *skb, u16 ihs)
 	memcpy(&vhdr->addrs, skb->data, cpy1_sz);
 	vhdr->h_vlan_proto = skb->vlan_proto;
 	vhdr->h_vlan_TCI = cpu_to_be16(skb_vlan_tag_get(skb));
-	memcpy(&vhdr->h_vlan_encapsulated_proto, skb->data + cpy1_sz, cpy2_sz);
+	unsafe_memcpy(&vhdr->h_vlan_encapsulated_proto,
+		      skb->data + cpy1_sz,
+		      cpy2_sz,
+		      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
 }
 
 static inline void
@@ -130,23 +141,32 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		sq->stats->csum_none++;
 }
 
+/* Returns the number of header bytes that we plan
+ * to inline later in the transmit descriptor
+ */
 static inline u16
-mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb)
+mlx5e_tx_get_gso_ihs(struct mlx5e_txqsq *sq, struct sk_buff *skb, int *hopbyhop)
 {
 	struct mlx5e_sq_stats *stats = sq->stats;
 	u16 ihs;
 
+	*hopbyhop = 0;
 	if (skb->encapsulation) {
 		ihs = skb_inner_transport_offset(skb) + inner_tcp_hdrlen(skb);
 		stats->tso_inner_packets++;
 		stats->tso_inner_bytes += skb->len - ihs;
 	} else {
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			ihs = skb_transport_offset(skb) + sizeof(struct udphdr);
-		else
+		} else {
 			ihs = skb_transport_offset(skb) + tcp_hdrlen(skb);
+			if (ipv6_has_hopopt_jumbo(skb)) {
+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
+				ihs -= sizeof(struct hop_jumbo_hdr);
+			}
+		}
 		stats->tso_packets++;
-		stats->tso_bytes += skb->len - ihs;
+		stats->tso_bytes += skb->len - ihs - *hopbyhop;
 	}
 
 	return ihs;
@@ -208,6 +228,7 @@ struct mlx5e_tx_attr {
 	__be16 mss;
 	u16 insz;
 	u8 opcode;
+	u8 hopbyhop;
 };
 
 struct mlx5e_tx_wqe_attr {
@@ -244,14 +265,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5e_sq_stats *stats = sq->stats;
 
 	if (skb_is_gso(skb)) {
-		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb);
+		int hopbyhop;
+		u16 ihs = mlx5e_tx_get_gso_ihs(sq, skb, &hopbyhop);
 
 		*attr = (struct mlx5e_tx_attr) {
 			.opcode    = MLX5_OPCODE_LSO,
 			.mss       = cpu_to_be16(skb_shinfo(skb)->gso_size),
 			.ihs       = ihs,
 			.num_bytes = skb->len + (skb_shinfo(skb)->gso_segs - 1) * ihs,
-			.headlen   = skb_headlen(skb) - ihs,
+			.headlen   = skb_headlen(skb) - ihs - hopbyhop,
+			.hopbyhop  = hopbyhop,
 		};
 
 		stats->packets += skb_shinfo(skb)->gso_segs;
@@ -365,7 +388,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
-
+	u16 ihs = attr->ihs;
+	struct ipv6hdr *h6;
 	struct mlx5e_sq_stats *stats = sq->stats;
 	int num_dma;
 
@@ -379,21 +403,40 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	eseg->mss = attr->mss;
 
-	if (attr->ihs) {
-		if (skb_vlan_tag_present(skb)) {
-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs + VLAN_HLEN);
-			mlx5e_insert_vlan(eseg->inline_hdr.start, skb, attr->ihs);
+	if (ihs) {
+		u8 *start = eseg->inline_hdr.start;
+
+		if (unlikely(attr->hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			if (skb_vlan_tag_present(skb)) {
+				mlx5e_insert_vlan(start, skb, ETH_HLEN + sizeof(*h6));
+				ihs += VLAN_HLEN;
+				h6 = (struct ipv6hdr *)(start + sizeof(struct vlan_ethhdr));
+			} else {
+				unsafe_memcpy(start, skb->data,
+					      ETH_HLEN + sizeof(*h6),
+					      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
+				h6 = (struct ipv6hdr *)(start + ETH_HLEN);
+			}
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else if (skb_vlan_tag_present(skb)) {
+			mlx5e_insert_vlan(start, skb, ihs);
+			ihs += VLAN_HLEN;
 			stats->added_vlan_packets++;
 		} else {
-			eseg->inline_hdr.sz |= cpu_to_be16(attr->ihs);
-			unsafe_memcpy(eseg->inline_hdr.start, skb->data, attr->ihs,
-				/* This copy has been bounds-checked earlier in
-				 * mlx5i_sq_calc_wqe_attr() and intentionally
-				 * crosses a flex array boundary. Since it is
-				 * performance sensitive, splitting the copy is
-				 * undesirable.
-				 */);
+			unsafe_memcpy(eseg->inline_hdr.start, skb->data,
+				      attr->ihs,
+				      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
 		}
+		eseg->inline_hdr.sz |= cpu_to_be16(ihs);
 		dseg += wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
 		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
@@ -404,7 +447,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	dseg += wqe_attr->ds_cnt_ids;
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
 					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
@@ -924,12 +967,34 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	eseg->mss = attr.mss;
 
 	if (attr.ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		if (unlikely(attr.hopbyhop)) {
+			struct ipv6hdr *h6;
+
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			unsafe_memcpy(eseg->inline_hdr.start, skb->data,
+				      ETH_HLEN + sizeof(*h6),
+				      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
+			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			unsafe_memcpy(h6 + 1,
+				      skb->data + ETH_HLEN + sizeof(*h6) +
+						  sizeof(struct hop_jumbo_hdr),
+				      tcp_hdrlen(skb),
+				      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else {
+			unsafe_memcpy(eseg->inline_hdr.start, skb->data,
+				      attr.ihs,
+				      MLX5_UNSAFE_MEMCPY_DISCLAIMER);
+		}
 		eseg->inline_hdr.sz = cpu_to_be16(attr.ihs);
 		dseg += wqe_attr.ds_cnt_inl;
 	}
 
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr.ihs + attr.hopbyhop,
 					  attr.headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
-- 
2.36.0.550.gb090851708-goog

