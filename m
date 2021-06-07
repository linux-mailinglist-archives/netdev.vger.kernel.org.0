Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4948339E61A
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhFGSDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:03:20 -0400
Received: from mail-dm6nam12on2054.outbound.protection.outlook.com ([40.107.243.54]:28843
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231409AbhFGSDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 14:03:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqZt+i6nnTes9kV6Lq5K/UNHgpX0QU6y7VPDRLRnSsBwv3y3h+KU2soGw3s80Fk41x88aLxfk9YuON08cKqXnQqbtKXl0lwzZRJ9ZJ+uSM5BrHw708DF/HkWN7FoCWxaQclE7jDvJ1D2ErgCDN8JY0woB1liKeimSog0D8lC6wMhWRjJdxdTdSG9kntV+EhMOuZVRs+OyG9H+AlLQNPF31hDf79xM78L2Mp1kWO+CRZF1C3sDEc9XJbFbFBPBCa1oXOuqi5F/iqLFOsRgx0a5WoDG7wubXYr72X9/lWms1mB+WtbC3ODmt/IbA0YrR67Dwrbhlr+0rjITJLRAdc4Uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B7KUSxRR1dZH2v1RdD6gSVJgM+u2fKMVdDeg9+avqM=;
 b=kIX2fp4eHeek67gfeURnTgRz3snceYpqY/0sGUAG4JtwfZf6iwYBdDePdfwWzHYkMdJ9EoRDFZ7/UHzqRlioA1oBSTj5avc6kLdIsVb/AEr1xf9p86UFMzvCjAVQZhItIZDnpi919CHTNY9Vx/ZkyF56cPYT5u9wdCAHtTq6BYuShzMExwVEfU0nkcQcR/Q1Z1IRdz+ccK8+X98uJ0XlRug55EutR68nRxij07qM3RdDT3sgr7J748E2ASbPDb+RXjmeFBFJAFaxFknXNRq8t/xvtAS4U7tihujgS0A9j2NzTXlIBr1DGeLi24ckZDbQUnBjuadpR6HXrgPvvT2ZJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8B7KUSxRR1dZH2v1RdD6gSVJgM+u2fKMVdDeg9+avqM=;
 b=FAjosCpxpAL0IErocdYjjyGgP4lH9nEyLy3Ctdh3GnZ8N1ZsoHL1/wNuwj7yDsm5cCdLjvCDQUcDaN+ZOcT2TNLxlnbOML0HDC8cCwaNSk3EVVPy/AjilrgLBwUFB5prhU2lmhBI5uBq2RPUEcoY82q+C/sH38UMjET4p6cWRIXdW0m81FGcCGGejnqEoYuufmObnCWjN8fte3BSrIOOzQBeJvILIOzZV8J1xXFPpPG8EJVQ6WTo0oixIefKhoeyyZx2WqhiwD5fk2MvODq1B8o+uMCLKxvyaxUqpfepY0fOufHdsYl4MyxdO4RbQjzgQB+RXBGzfcjhQVG32F2SKA==
Received: from DS7PR03CA0056.namprd03.prod.outlook.com (2603:10b6:5:3b5::31)
 by MN2PR12MB4221.namprd12.prod.outlook.com (2603:10b6:208:1d2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 18:01:24 +0000
Received: from DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::9c) by DS7PR03CA0056.outlook.office365.com
 (2603:10b6:5:3b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend
 Transport; Mon, 7 Jun 2021 18:01:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT058.mail.protection.outlook.com (10.13.172.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Mon, 7 Jun 2021 18:01:24 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 7 Jun
 2021 18:01:00 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v4 1/3] net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
Date:   Mon, 7 Jun 2021 21:00:44 +0300
Message-ID: <20210607180046.13212-2-huyn@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: de86cfe3-7c37-49b5-52d2-08d929de43e1
X-MS-TrafficTypeDiagnostic: MN2PR12MB4221:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4221BD8E2ADE735E799DFE43A2389@MN2PR12MB4221.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ldzVfwFuBmLt0aOvoH3KrLz0WC/AKgdnuH6Y6EIYjsqTzFNAHN6nq0aZvRLWrgXGuNgOOPgfGRY77rw4b9SY9VQbjskjwurZb1ebJwwnrRbqJ9anwtuYMBXTmbL0sBas2buVXKHi+mr6euwhmAw8bPD+qocWRyGdcZKPx3WGv+HlI9ur9FB3RlLe8nalid8e+rM1IVR7Y109u7+wVl8ZEV5E1HfHATJ0ficKFBNiEwzBkA2zIdUH+8kTYYjEnNjizv9D3uTBGSAlqfl2dj0iOjN1de8MeajNnzwYigNqCCEZLiHq/Y8//I6nOGSiIdZGapgG3OhGzOo16ljqmLdIbDSVklSYhFDT/cmS4AUOIurRo7IP+6tDmpHHF0Zqg4nmCiLHPye/xlSbhs00fgne+K5kCAh6VDMkE0BFddhyrRIx23D0VhhVWNvO3CBHxl2x4AHTa+14QGe8yUOMtr1619oEJN4KuLOiaq1cXo+A3FO8mOfSdWaHj5ZqcNUw6TWus44HygISjdU+P83ZyEmyWtseVNno4wScrYQ23AfPCJZagWOB/wNfL8vk2/VVtFnwlIVQDjoK2IpaXIkJWrrAd7tjXTR9OHydin59YctDIkBRayQ601Qu1jD6D8SVM1C6nrIbAXkxqZiaYX5Ka9nM/KoiYCbgVJ7GRqM2bGA2NXQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(396003)(376002)(36840700001)(46966006)(8936002)(36756003)(2906002)(7636003)(36860700001)(1076003)(4326008)(8676002)(356005)(6916009)(47076005)(83380400001)(2616005)(186003)(107886003)(478600001)(316002)(82740400003)(86362001)(6666004)(82310400003)(70206006)(36906005)(70586007)(16526019)(5660300002)(336012)(54906003)(426003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 18:01:24.6791
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: de86cfe3-7c37-49b5-52d2-08d929de43e1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4221
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_ipsec_feature_check belongs to mlx5e_tunnel_features_check.
Also, IPsec is not the default configuration so it should be
checked at the end instead of the beginning of mlx5e_features_check.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
---
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h      | 15 +++++++++------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |  8 +++++---
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
index 3e80742a3caf..cfa98272e4a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_rxtx.h
@@ -93,8 +93,8 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 void mlx5e_ipsec_tx_build_eseg(struct mlx5e_priv *priv, struct sk_buff *skb,
 			       struct mlx5_wqe_eth_seg *eseg);
 
-static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-					     netdev_features_t features)
+static inline netdev_features_t
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
 {
 	struct sec_path *sp = skb_sec_path(skb);
 
@@ -102,9 +102,11 @@ static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_dev
 		struct xfrm_state *x = sp->xvec[0];
 
 		if (x && x->xso.offload_handle)
-			return true;
+			return features;
 	}
-	return false;
+
+	/* Disable CSUM and GSO for software IPsec */
+	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
 #else
@@ -120,8 +122,9 @@ static inline bool mlx5e_ipsec_eseg_meta(struct mlx5_wqe_eth_seg *eseg)
 }
 
 static inline bool mlx5_ipsec_is_rx_flow(struct mlx5_cqe64 *cqe) { return false; }
-static inline bool mlx5e_ipsec_feature_check(struct sk_buff *skb, struct net_device *netdev,
-					     netdev_features_t features) { return false; }
+static inline netdev_features_t
+mlx5e_ipsec_feature_check(struct sk_buff *skb, netdev_features_t features)
+{ return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK); }
 #endif /* CONFIG_MLX5_EN_IPSEC */
 
 #endif /* __MLX5E_IPSEC_RXTX_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index ad0f69480b9c..e200457266ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4281,6 +4281,11 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
 		/* Support Geneve offload for default UDP port */
 		if (port == GENEVE_UDP_PORT && mlx5_geneve_tx_allowed(priv->mdev))
 			return features;
+#endif
+		break;
+#ifdef CONFIG_MLX5_EN_IPSEC
+	case IPPROTO_ESP:
+		return mlx5e_ipsec_feature_check(skb, features);
 #endif
 	}
 
@@ -4298,9 +4303,6 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
 	features = vlan_features_check(skb, features);
 	features = vxlan_features_check(skb, features);
 
-	if (mlx5e_ipsec_feature_check(skb, netdev, features))
-		return features;
-
 	/* Validate if the tunneled packet is being offloaded by HW */
 	if (skb->encapsulation &&
 	    (features & NETIF_F_CSUM_MASK || features & NETIF_F_GSO_MASK))
-- 
2.24.1

