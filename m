Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8303A6913
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233060AbhFNOgL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:36:11 -0400
Received: from mail-dm6nam11on2065.outbound.protection.outlook.com ([40.107.223.65]:6977
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232815AbhFNOgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 10:36:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aUuVzY+ZCefYcZwx2l7k4epZL/J2HXiARvB8aFgNBdsVXMemE6SFmSUvo+4HZXelSB4R6f/YQ9963LnJ8HQCs6xQJ5gpOSJmfSLV3ByWUXiD+YzOFDB5g/RHxCwNK/w1V81w2MJxhV4czzfgez1u00jU3QQ7TDC5GqBdr8ZgMsYYAMk6zOS8ru3s3ymBPbqc82rokRX+3tu3n16USROTFnva6tRARopVAFwnlen1WGSlIy5wJ6rsprogEbM6g7vcRGlxzq99CisC59AjF2ZdqcOWfODvzZZnpBlhuX+uDaJ9t78Rw5q9Tssued0zCPgSwQb+ycN/kRKCE6uwmtQXHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59L922PEVGUZI5CBGMuU3BFYi9NceluLMaftbnxxA4=;
 b=nEbsD8JoN2/458nWMMgAIZa3gUG1J1ERBf9yOt9/uS+nOjiEu9rRsW56qvTzKDDW9wKwN4CF9ejNmb9wwGClDNoUIo6aLwX8VyQTLZvFhZ0Ce85croKoxT+JV1nGoZRCtr9z8OAX8WyZrKncI6tk8/LS/xl9CYfwcGWaDy1pEywYKoKPYR7Us+zZ1x+w2m6LtCaoJ613yyCK4I4YFACM+MeXj67M9BzY5DvKcRwn9ggTAW7GVeq1rVrZoBYB3itQ/hEFapiks924iKE/XA9nOnuKl7cwWqbGvq1MkLLgLjF9+9Rb0hQw7IqUblrf0F9dXLTceO0C+yVKaZBmKiBqVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j59L922PEVGUZI5CBGMuU3BFYi9NceluLMaftbnxxA4=;
 b=KxE24u+1d7YBkf9YqGZH0lOxc/vwdrD5CldYeEvl8RimJ576cCCA46l9CW38RJ3J1ITvVwnQRxxQMv2Ki7c+MYFVE0Or7faZ/X7+un1OupQ1npeOt4FYa910oACRRxfgrKFg+tDbZO0gW9rCIuir4Mx9TlvOUwk5LgSfonHutoySn4RIXsmJ3FPB42lAqimZFCkveZiTpsyHJplPl6/GAL+eSOgbyqyfwhFarR7Q0rrgnKc0toLrGvnHoOjJItjmawTRCAJcle+mKr3xBPOXZzeV0XNnPhoMLxtWWxkm1kb7f71odDuSYVpJzzYB5JHM0Wlpwg7xMFbXd1PUlRtZgw==
Received: from CO2PR05CA0008.namprd05.prod.outlook.com (2603:10b6:102:2::18)
 by MN2PR12MB3950.namprd12.prod.outlook.com (2603:10b6:208:16d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 14:34:02 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::db) by CO2PR05CA0008.outlook.office365.com
 (2603:10b6:102:2::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Mon, 14 Jun 2021 14:34:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:34:02 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 14:34:02 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v5 3/3] net/mlx5: Fix checksum issue of VXLAN and IPsec crypto offload
Date:   Mon, 14 Jun 2021 17:33:49 +0300
Message-ID: <20210614143349.74866-4-huyn@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210614143349.74866-1-huyn@nvidia.com>
References: <20210614143349.74866-1-huyn@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7e75165c-0ed0-4141-01e8-08d92f4174b5
X-MS-TrafficTypeDiagnostic: MN2PR12MB3950:
X-Microsoft-Antispam-PRVS: <MN2PR12MB39505141541CB0207DDA9EC5A2319@MN2PR12MB3950.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SHSnuhyraRjor9i+chu1qg+2IqoExZjOk4gADgc33P6vt14fnZ2S765NrGk6GvsUllvtser/pWLTLtQYhWkDDkMWo9Zyj96K9br//WjiM2jcGb/HH4e7YROJdm7buVS2S9vbfuCbs8BmJGMZShEp+p/7qmCNS5a4sMFXAyrNSQRWzs0qr0k/hkF4sCbpaYV/6jG2GIAIZtd4OWBMs2LBWJN7XFpjylRMZ6InqN5kortT7K6SuIXs51BLKK8d5G0QSSOZsHcj4ldoOtST/r3QAWovc3lDq6HFUwyRYdCa97Skv8N4SG49TbKYVOVA+Z1umtQW7esvUcBka3gsJw1a/W+06y/eZ5BALJs9RLwYwNXxUDnmF/rdjRrksDDBYWJrpuUR3A35lbjpQo1O73Yy+sJQ3JGDMpfdsb/ZMhjJ1WxAKcj5f/EGfq6z7aaIfRAFqM9SJPhIl0DPD4gC3nxogvB5G+G5pzZTqyDPciy9B9yQSswki73VfCgbdtCNBD83LhMllPkq9mnf5eyVQazueY+N5f9PZ1J8l5lMLLx5mIMbY5G3XUxrn3D/5Iyh6YdPjd2PBHULVq3zSIwpLIJpZb/T3mv1sExGXsj7nT3PN4hdaujRn4608Dzj1IqUuHVMjM+t1lNSxk+ohXdkbKtLRb/Nf1AtQl/DupBf7P4lAcI=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(1076003)(26005)(36860700001)(7636003)(82310400003)(36906005)(16526019)(186003)(4326008)(6666004)(54906003)(2616005)(356005)(8676002)(426003)(2906002)(8936002)(83380400001)(498600001)(5660300002)(336012)(86362001)(47076005)(107886003)(36756003)(70206006)(70586007)(6916009);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:34:02.5895
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e75165c-0ed0-4141-01e8-08d92f4174b5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3950
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

