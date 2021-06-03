Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDB5C39A534
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCQCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:02:53 -0400
Received: from mail-mw2nam12on2068.outbound.protection.outlook.com ([40.107.244.68]:4856
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhFCQCv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:02:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kgawUveFIurZAzefwQ3s6B4p6QWcXJJMdZ3OeZjSzW1lTt7LKKx+vB9F8EDMgmfmym89YcPsEluKSp8jL13f1DReXg11pP037nK5QtyjzMRxHFTSl/abiX/xU8yxJp3w/KpfAVFqlUd+VxpNLBdN8cRel9PtQnS+WSfH2r58ZHC4mUksdpLzCN+KBFWnzDQvIHjpl5r4X5rSnHW+jCqBwhpKt3FwqT+UnFEdhA9nh6UZMomM3wfbYX3vLDL0hHAn6IVGOKEdTpP+MThML99UTTl6q9FWmw7jVavl2ZGgr2ZLimQJIeI+jWCfF8xWe+/xwACbCYfUIpNGMS74XbGBxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOPEvOWR+vBRcDHftT2f4kk0Q+4SjhtYtpUmLF15pd8=;
 b=miigDaivvUDIgmsaPQnHYsGh5fdUDkqO1N5pcEDfR7Igm8QN63b0m2cTJA/SFhCIouTliUxkccpS1FcgbBOtZb6exvEXJze0yrvODEvMdZfGGnvwOBLYd+731BnyGvAjbifqBIPcqA2fGTVX63XLH62QcciyN6jDnrYbM91A32LBDoejNiHzyLYk9M6S/dDM0NeUDemnVjIYjC67PDMT8wo8NAj+MBmc8inWZXjhAVeZOjIDJKYwEE5DhY5C1N8NZpjeujAIDLAQupiCG4IzFk+OY5QdYWoTevYwu0bhuJUZl/mHGLFUK6fpMVVQ+HHdmIfY+ZAnlXijNdDbPzUbRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JOPEvOWR+vBRcDHftT2f4kk0Q+4SjhtYtpUmLF15pd8=;
 b=t8/6/DQ08Yvn0PAm1Z4ezeteZ1G7qUcXeolOJ02qkyDAob3LdsCazr57f3VTOvJUpAVIvzWnzT79JXal8LY636WZuCrrvcZyFMQ+AIrFBZw4YE/dzf+OUvDfV81UIrmHqaaiz7nthKjeCqULJlEApYpt71O2LfXTSt3Ke0l2yUr+t4GPOVnNj2SyHv5hfwBCL+G5YPiwdj3n70dLAxxOAyOSPo5h2MLzfAu7+dNsMHnr0ddqy5Y6zbU8f6DbHeSHwelEa+7z7YLen1wzUC73TIcugfadMYxMyFLZSGFXxJk46LXCuKt6DrD9sRviCOIMQZAru6BKlv8VpX8EAHJz1A==
Received: from CO2PR04CA0186.namprd04.prod.outlook.com (2603:10b6:104:5::16)
 by DM6PR12MB4880.namprd12.prod.outlook.com (2603:10b6:5:1bc::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.21; Thu, 3 Jun
 2021 16:01:05 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::9d) by CO2PR04CA0186.outlook.office365.com
 (2603:10b6:104:5::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend
 Transport; Thu, 3 Jun 2021 16:01:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:01:05 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:01:01 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [RESEND PATCH net v3 3/3] net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload
Date:   Thu, 3 Jun 2021 19:00:45 +0300
Message-ID: <20210603160045.11805-4-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210603160045.11805-1-huyn@nvidia.com>
References: <20210603160045.11805-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30ce3a14-7e79-4a7a-f789-08d926a8cb63
X-MS-TrafficTypeDiagnostic: DM6PR12MB4880:
X-Microsoft-Antispam-PRVS: <DM6PR12MB48802B56B0CF83AEB288EA93A23C9@DM6PR12MB4880.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ibpGNHWkYBF7iiKrvQDlbQz+w07zBPIMMKX15DIqmIGrzCAxnvmxTRQjmYBVNujlqKG3jzfP2yuJsR/6aQ44a/xLsIF6D+P1ajf0fS5F1cVkC1l2tuRibq7OPqB+8Y/7EIP7pqNq4eDNm3ZwdUk8goiS6yN6m53gXJ/Ns2S4nwFsdB8Qv/4oBhZQjEKXA9LI36wVV265LHOG1Qplxgl0VEs1zL3VrUnhQipdT9F7R1qJzNVurGwxKoyTtBUBEE8L7B4isBUOOUOKhiI4tEGKKMRA0MftNp+9MBtRKNkV4SUJ7UlEUKGxcPctjif74W/4UgmrEWMtBsbsD63wVlxKrGu+wpAEsBzuoeSiZFEh4shi0fH1tp6/tqlkqz44rjH2pP38pskS/IvUTWW0AljbqYl6a/jIEDy8mc2eDrxVuPGzogGTEzpLGvPCO80NB9D7d0EOL1DABmDogcQqraJ2J0i4acZdWcciYhjwzXkq7nTR8ZjC6NK11R0U8b8AT6HL9BFSnn5Zc4Ou3JIOW6lIqbS7UlB7HSGHQ5B+CIbOT5rodICIcR6wr6tLm5TA2+5kxr7NRJ1OQiOZy1QNZIrPenv4OhYwFTkI9V0lMBKWvqEEMYfemlBCXrVeJgGojGKiPAxp21InS/aiCWSoD0jc1yAHteulV37LwCboZsN20Ro=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(376002)(396003)(136003)(39850400004)(346002)(36840700001)(46966006)(6916009)(2906002)(186003)(36756003)(86362001)(47076005)(36860700001)(107886003)(356005)(7636003)(6666004)(82740400003)(54906003)(4326008)(82310400003)(36906005)(8676002)(5660300002)(8936002)(426003)(2616005)(70586007)(26005)(70206006)(83380400001)(478600001)(316002)(16526019)(1076003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:01:05.7193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30ce3a14-7e79-4a7a-f789-08d926a8cb63
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4880
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

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
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

