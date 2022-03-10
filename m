Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74864D3E27
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239067AbiCJAal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:30:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238375AbiCJAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:30:24 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A7E9125536
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:29:20 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id z4so3317100pgh.12
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:29:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ZTk34LeFcsiXRfkk3uvmXHHBC6cNpPukfbg6fKQ5QM=;
        b=Ok1JmUV9Hc8NKmiUpMINAp4chO7UmTmVt/OYq/+A3+x770kT5DEyUrptgXCgl7UyvY
         Ao90xkiemmK+Vk53pNqmtK9p7b2iyZ1qKmezpHNBN0F2G9LfwTIHWrqWhA5SXFANW8mS
         szNYfZ4v7P3UrlMv9F+HTZYTMx9i46Pv1wSATPW/iytH80KUujI8OQKkSvDF68bMlJWw
         foDLEECNx87kTECMKV0RxnPp/VHPAopdvi4OoNi9erdmz+AVta0El42TqopAeHloIZ7W
         q+AEgJuBLwQARLAVuC3V0okgL1L1amfcxv7Mw/tVnIqcBZoO6q5xUHo/7LxxAJ1q6s5T
         le9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ZTk34LeFcsiXRfkk3uvmXHHBC6cNpPukfbg6fKQ5QM=;
        b=T75fCQBVbXUSlT+R638BXOH0pGpa6jwXCUfXFL1cxeTQZSMOlYcKK5dC+g7VkG/kgF
         ZulT+r/i8ZGsvh3+rVanvx9zzhcGOOagDYuBNfagBOfJccpOkD/jyw15YHGf1ENSWqkG
         zx0xOmtpzRpF/EJwT8PjLD6xDqEqC/9O92vETuMLhRZa3lqL7vCp9ecMJUAHzKbx92sJ
         L3jCDRJQ3SyoILx8b4ZI8rMAYG08dz45UwUwRNmYxon2vq50ovN5TmwwccEQwat1E+Y0
         QGbYgwUAKcwrJNtDB+baVrSHk0nkkMEw0ZoGdTXcF+zaQHz9tmBR52jGtHCS3M/t/aGh
         Yl3w==
X-Gm-Message-State: AOAM530a/3GVspfmyQDIroAVA3w7GPRGJyWpfLPoYKbtwQyadQcHdYcK
        YhEeo9yOjw3Mmzw4xr8tLWvqi5KK9NM=
X-Google-Smtp-Source: ABdhPJwSbriq4+zTILNez8q1SglvA4ls9CsN16cVnVNnkw+obY0Q6XP4e3gE7d4erUeyKkSK22l7PQ==
X-Received: by 2002:a63:af06:0:b0:378:3582:a49f with SMTP id w6-20020a63af06000000b003783582a49fmr1879876pge.125.1646872159992;
        Wed, 09 Mar 2022 16:29:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id nv4-20020a17090b1b4400b001bf64a39579sm7557660pjb.4.2022.03.09.16.29.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:29:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Subject: [PATCH v3 net-next 14/14] mlx5: support BIG TCP packets
Date:   Wed,  9 Mar 2022 16:28:46 -0800
Message-Id: <20220310002846.460907-15-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310002846.460907-1-eric.dumazet@gmail.com>
References: <20220310002846.460907-1-eric.dumazet@gmail.com>
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

From: Coco Li <lixiaoyan@google.com>

mlx5 supports LSOv2.

IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore/skip this HBH header when populating TX descriptor.

Note that ipv6_has_hopopt_jumbo() only recognizes very specific packet
layout, thus mlx5e_sq_xmit_wqe() is taking care of this layout only.

v2: clear hopbyhop in mlx5e_tx_get_gso_ihs()

Signed-off-by: Coco Li <lixiaoyan@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Leon Romanovsky <leon@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 82 +++++++++++++++----
 2 files changed, 67 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index b2ed2f6d4a9208aebfd17fd0c503cd1e37c39ee1..1e51ce1d74486392a26568852c5068fe9047296d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4910,6 +4910,7 @@ static void mlx5e_build_nic_netdev(struct net_device *netdev)
 
 	netdev->priv_flags       |= IFF_UNICAST_FLT;
 
+	netif_set_tso_ipv6_max_size(netdev, 512 * 1024);
 	mlx5e_set_netdev_dev_addr(netdev);
 	mlx5e_ipsec_build_netdev(priv);
 	mlx5e_tls_build_netdev(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 2dc48406cd08d21ff94f665cd61ab9227f351215..c6f6ca2d216692e1d3fd99e540198b11145788cd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -40,6 +40,7 @@
 #include "en_accel/en_accel.h"
 #include "en_accel/ipsec_rxtx.h"
 #include "en/ptp.h"
+#include <net/ipv6.h>
 
 static void mlx5e_dma_unmap_wqe_err(struct mlx5e_txqsq *sq, u8 num_dma)
 {
@@ -130,23 +131,32 @@ mlx5e_txwqe_build_eseg_csum(struct mlx5e_txqsq *sq, struct sk_buff *skb,
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
@@ -208,6 +218,7 @@ struct mlx5e_tx_attr {
 	__be16 mss;
 	u16 insz;
 	u8 opcode;
+	u8 hopbyhop;
 };
 
 struct mlx5e_tx_wqe_attr {
@@ -244,14 +255,16 @@ static void mlx5e_sq_xmit_prepare(struct mlx5e_txqsq *sq, struct sk_buff *skb,
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
@@ -365,7 +378,8 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_eth_seg  *eseg;
 	struct mlx5_wqe_data_seg *dseg;
 	struct mlx5e_tx_wqe_info *wi;
-
+	u16 ihs = attr->ihs;
+	struct ipv6hdr *h6;
 	struct mlx5e_sq_stats *stats = sq->stats;
 	int num_dma;
 
@@ -379,15 +393,36 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
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
+				memcpy(start, skb->data, ETH_HLEN + sizeof(*h6));
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
-			memcpy(eseg->inline_hdr.start, skb->data, attr->ihs);
+			memcpy(start, skb->data, ihs);
 		}
+		eseg->inline_hdr.sz |= cpu_to_be16(ihs);
 		dseg += wqe_attr->ds_cnt_inl;
 	} else if (skb_vlan_tag_present(skb)) {
 		eseg->insert.type = cpu_to_be16(MLX5_ETH_WQE_INSERT_VLAN);
@@ -398,7 +433,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	}
 
 	dseg += wqe_attr->ds_cnt_ids;
-	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs,
+	num_dma = mlx5e_txwqe_build_dsegs(sq, skb, skb->data + attr->ihs + attr->hopbyhop,
 					  attr->headlen, dseg);
 	if (unlikely(num_dma < 0))
 		goto err_drop;
@@ -918,12 +953,27 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	eseg->mss = attr.mss;
 
 	if (attr.ihs) {
-		memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
+		if (unlikely(attr.hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			memcpy(eseg->inline_hdr.start, skb->data, ETH_HLEN + sizeof(*h6));
+			h6 = (struct ipv6hdr *)((char *)eseg->inline_hdr.start + ETH_HLEN);
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else {
+			memcpy(eseg->inline_hdr.start, skb->data, attr.ihs);
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
2.35.1.616.g0bdcbb4464-goog

