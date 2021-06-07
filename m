Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B4339E61B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhFGSDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:03:24 -0400
Received: from mail-sn1anam02on2061.outbound.protection.outlook.com ([40.107.96.61]:45174
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231419AbhFGSDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:03:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EhDhqSP3bXpKxfcFZ4L+mSRFIek6j/0A0LBSBboeGYkS6jF0gL3M7HWKnPGQljRAY9OLVjxw7aPGGq+3bqwxqkCbdRB7wqbcGBFQyY9pb2qVBivh4SaODXHyRNsJ3lT3oDDLr/JRib8ZUoUxhI77ynlKolrnSWGbdU0ewsfz4BwunrMnhqW0+lo7VtKlyadzRNXBuwy76C/eR7FMU4Zf+j5J2XtekLUs1B1lSZeSZagfOpmudu/XTQ0Kkg9OENbC2o+F7bdEf8xZ//Gi35YMOLMFDMNe0TC9Hri3Q7xsyeDyZbV9RbrQyNyUIxRySGlwj9erFCoc4hjg+E3tM5WlpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59L922PEVGUZI5CBGMuU3BFYi9NceluLMaftbnxxA4=;
 b=FvM2QjdAwyBop+uu+nV1KuSrfKCt+s72nIk/plm68u1mTRIlxI61LbFKc4VtiNg9cVS3pJAqxxUSXTLW+MlfdqVfz5LyfG6wOlB3s//von0Q+jPbwMYis5cjdipEBHutq47M61rhz9K/NlQp4/WK0rd8VvLn4nMH3sZlx+A6Q3p/vtKyNcsCFBD+LCeTGTgSLnnzsPEMuGYNdTNx1pfyVZEBu6E8Tol2L6sO8yOnj0TYsain156k8uvfOdobGMfmyMytT07VHlmhKLTLPGlv2PP/i7fXmD0fajMXXV50DcdoI1zZP20/noAwBldiK/AHJTUvbwS+QVg9fPcx79ME7g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59L922PEVGUZI5CBGMuU3BFYi9NceluLMaftbnxxA4=;
 b=GJjwqJuVK35PYQHyKPQFFEPx+nnn1XelbdQwfBWoxuy+WC1143oztB29WKdouI/O9jsRSPvf6W/6SnjJcWntlaRk+6EZMzYjpZhfj4wjTJiVp5dDxd0Yq4xqKzeF/3nQuY4aQG5G3h+pTVZUPkzotGkj5MsT0WgYAOn5kgHgP9ajrf90Wch+S0rpgvvihjnhw/P6MJKa1XE8RJ7RMI35pvznSnXxSBH9P65zp/PT+N8FDXuCLPG3jUqes7SNO6tS/nvXJnkxNN0EsAQJMxcdhZoJ75w+IqnqHQ8jxeEkDrqkR9C0qSp4YkuWZJrQySdf+7s6Z0hWWcgBiM+pFaTP7g==
Received: from DS7PR03CA0214.namprd03.prod.outlook.com (2603:10b6:5:3ba::9) by
 DM6PR12MB3500.namprd12.prod.outlook.com (2603:10b6:5:11d::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.24; Mon, 7 Jun 2021 18:01:25 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ba:cafe::ea) by DS7PR03CA0214.outlook.office365.com
 (2603:10b6:5:3ba::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21 via Frontend
 Transport; Mon, 7 Jun 2021 18:01:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:01:25 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 18:01:02 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v4 3/3] net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload
Date:   Mon, 7 Jun 2021 21:00:46 +0300
Message-ID: <20210607180046.13212-4-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210607180046.13212-1-huyn@nvidia.com>
References: <20210607180046.13212-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 063c5898-afc6-4497-9506-08d929de4451
X-MS-TrafficTypeDiagnostic: DM6PR12MB3500:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3500440EE3D49751F6CC3FECA2389@DM6PR12MB3500.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SQpiGH2fEKmR9ZjJfux8xmDyQywHzEyFPRfNUGEqSmPiNPeOl/avHLmFuDpjFVP+D7zvLfSH55RxN0/zBY1k8wQRFi1ZWMOD1fZ20ky0y4GJTwwgoqa7UN9ImgnhKQi8GflhaeAN86Oicw6tNC13V97oQceNXEePPRe4C86McJyGMf1KnaimChacs0vSFhMxDd3rtzjzDZZMhPaK1dkYNI/gjMAXVVbo0JEmtTnFVJo2mbX+almhRnOrKJUrBvBEePOCiNpIdFaHV5g7Go287DE2uAjScC1mPxSJLKj5wLSFnooJp/wil6yO3eszHg4eK6RL4Xf4WYD1fZspl1elcX3V4wD52krWbQAAxFYPAmhKfmYweYu4wm7nmHCYdt4w25HeyCMH+YYN0apcb9M90o2iJIJhStbiPbnqMbA7B5mFki6v0LHc2oMsMd3ChG5ZigujXcoOK7oZW4Z8TAMFjY5aMhNTUOfEPraMO6MNl07xLZMqljNQJGVvXPb6YgfUWh/jaEMJeJ7gyEATVI9xE5fd+hGPMHj2PPSXS4z4YKUtmO8KN797xQKJD8/MHBCiTbgm0WwG+3XrL2uhMROi4s2PJ0jcU8+k3XcjmiuggNwdipD/3o6jeKmh3CpwJewkz72DSlF1yZOX9v1/ZB6Zme+tAy1jgPWK+v1E6lnRzGo=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(70586007)(426003)(47076005)(336012)(26005)(82310400003)(356005)(36860700001)(498600001)(16526019)(186003)(54906003)(2616005)(70206006)(36906005)(107886003)(6916009)(8936002)(8676002)(7636003)(5660300002)(36756003)(1076003)(83380400001)(2906002)(86362001)(4326008)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:25.3714
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 063c5898-afc6-4497-9506-08d929de4451
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3500
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The packet is VXLAN packet over IPsec transport mode tunnel
which has the following format: [IP1 | ESP | UDP | VXLAN | IP2 | TCP]
NVIDIA ConnectX card cannot do checksum offload for two L4 headers.
The solution is using the checksum partial offload similar to
VXLAN | TCP packet. Hardware calculates IP1, IP2 and TCP checksums and
software calculates UDP checksum. However, unlike VXLAN | TCP case,
IPsec's mlx5 driver cannot access the inner plaintext IP protocol type.
Therefore, inner_ipproto is added in the sec_path structure
to provide this information. Also, utilize the skb's csum_start to
program L4 inner checksum offset.

While at it, remove the call to mlx5e_set_eseg_swp and setup software parser
fields directly in mlx5e_ipsec_set_swp. mlx5e_set_eseg_swp is not
needed as the two features (GENEVE and IPsec) are different and adding
this sharing layer creates unnecessary complexity and affect
performance.

For the case VXLAN packet over IPsec tunnel mode tunnel, checksum offload
is disabled because the hardware does not support checksum offload for
three L3 (IP) headers.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.c  | 65 ++++++++++++++-----
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h  | 24 ++++++-
 2 files changed, 70 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
index a97e8d205094..33de8f0092a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.c
@@ -136,8 +136,6 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 				struct mlx5_wqe_eth_seg *eseg, u8 mode,
 				struct xfrm_offload *xo)
 {
-	struct mlx5e_swp_spec swp_spec = {};
-
 	/* Tunnel Mode:
 	 * SWP:      OutL3       InL3  InL4
 	 * Pkt: MAC  IP     ESP  IP    L4
@@ -146,23 +144,58 @@ static void mlx5e_ipsec_set_swp(struct sk_buff *skb,
 	 * SWP:      OutL3       InL4
 	 *           InL3
 	 * Pkt: MAC  IP     ESP  L4
+	 *
+	 * Tunnel(VXLAN TCP/UDP) over Transport Mode
+	 * SWP:      OutL3                   InL3  InL4
+	 * Pkt: MAC  IP     ESP  UDP  VXLAN  IP    L4
 	 */
-	swp_spec.l3_proto = skb->protocol;
-	swp_spec.is_tun = mode == XFRM_MODE_TUNNEL;
-	if (swp_spec.is_tun) {
-		if (xo->proto == IPPROTO_IPV6) {
-			swp_spec.tun_l3_proto = htons(ETH_P_IPV6);
-			swp_spec.tun_l4_proto = inner_ipv6_hdr(skb)->nexthdr;
-		} else {
-			swp_spec.tun_l3_proto = htons(ETH_P_IP);
-			swp_spec.tun_l4_proto = inner_ip_hdr(skb)->protocol;
-		}
-	} else {
-		swp_spec.tun_l3_proto = skb->protocol;
-		swp_spec.tun_l4_proto = xo->proto;
+
+	/* Shared settings */
+	eseg->swp_outer_l3_offset = skb_network_offset(skb) / 2;
+	if (skb->protocol == htons(ETH_P_IPV6))
+		eseg->swp_flags |= MLX5_ETH_WQE_SWP_OUTER_L3_IPV6;
+
+	/* Tunnel mode */
+	if (mode == XFRM_MODE_TUNNEL) {
+		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+		if (xo->proto == IPPROTO_IPV6)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		if (inner_ip_hdr(skb)->protocol == IPPROTO_UDP)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		return;
+	}
+
+	/* Transport mode */
+	if (mode != XFRM_MODE_TRANSPORT)
+		return;
+
+	if (!xo->inner_ipproto) {
+		eseg->swp_inner_l3_offset = skb_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = skb_inner_transport_offset(skb) / 2;
+		if (skb->protocol == htons(ETH_P_IPV6))
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		if (xo->proto == IPPROTO_UDP)
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		return;
+	}
+
+	/* Tunnel(VXLAN TCP/UDP) over Transport Mode */
+	switch (xo->inner_ipproto) {
+	case IPPROTO_UDP:
+		eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L4_UDP;
+		fallthrough;
+	case IPPROTO_TCP:
+		eseg->swp_inner_l3_offset = skb_inner_network_offset(skb) / 2;
+		eseg->swp_inner_l4_offset = (skb->csum_start + skb->head - skb->data) / 2;
+		if (skb->protocol == htons(ETH_P_IPV6))
+			eseg->swp_flags |= MLX5_ETH_WQE_SWP_INNER_L3_IPV6;
+		break;
+	default:
+		break;
 	}
 
-	mlx5e_set_eseg_swp(skb, eseg, &swp_spec);
+	return;
 }
 
 void mlx5e_ipsec_set_iv_esn(struct sk_buff *skb, struct xfrm_state *x,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index cfa98272e4a9..5120a59361e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -96,16 +96,34 @@ void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 static inline netdev_features_t
 mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 {
+	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp = skb_sec_path(skb);
 
-	if (sp && sp->len) {
+	if (sp && sp->len && xo) {
 		struct xfrm_state *x = sp->xvec[0];
 
-		if (x && x->xso.offload_handle)
-			return features;
+		if (!x || !x->xso.offload_handle)
+			goto out_disable;
+
+		if (xo->inner_ipproto) {
+			/* Cannot support tunnel packet over IPsec tunnel mode
+			 * because we cannot offload three IP header csum
+			 */
+			if (x->props.mode == XFRM_MODE_TUNNEL)
+				goto out_disable;
+
+			/* Only support UDP or TCP L4 checksum */
+			if (xo->inner_ipproto != IPPROTO_UDP &&
+			    xo->inner_ipproto != IPPROTO_TCP)
+				goto out_disable;
+		}
+
+		return features;
+
 	}
 
 	/* Disable CSUM and GSO for software IPsec */
+out_disable:
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-- 
2.24.1

