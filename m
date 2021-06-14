Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB853A6910
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 16:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhFNOgF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 10:36:05 -0400
Received: from mail-mw2nam08on2061.outbound.protection.outlook.com ([40.107.101.61]:9767
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232975AbhFNOgF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Jun 2021 10:36:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KzGe2GrMubdO08PSKb1td7DxMlB/oCMgmETSlSRLj9NzEXRviBmyxqE/TG+wQDNNvKPViKejBs/D5DilmhDg9127/VF4Smw/afjka5gpJtHT1HrGU2AoB1Nh2wRPDOya9rh17gF9Cvsv6X0AoT7RB2OfiRc9SjmuQq7fSUqvQ5dmmXn9+6s/pfl3gbgqFhqn8N57t3xPNforChV2KlKkpsvRC1e+Ss2ZOU41MuyjRXU1LDU5xSRKfTT5CCM1+BPe+rpWb8I6LvGZytEafOjuMB5zY87JAo0JjcYsNgPcYACt2KeXUKNufsdkpnV/OyZ4sA3LSuFVnm4RiebJPHc4Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8o+zc1eTHlM8jAjrmaZiOaONLJnoPu9bdpRqXTmpjC4=;
 b=cMryvqSmJXv90PhRl5dxWECn6mWWhox+lYV/LrJ0JfG2Sx4YZHeeSSCUD6MQMLnW3oQ7X99AZRBWRcH4XNKqxDff43Wc1OvgHVkYXXExJCWydnOdSWBmaciVHNynp7RoZPXtScH30zkgSa+G32q7nGgp1FUyobHtQHk9/RXuVPvWaVOWFWASVRDAoDOPOrSH00tEvVt4uJTVu33TztwXUr4Q8Q7j0ttpvnxgqAJsWVlfj4v3+bedFvFiXIv30PtJPl+6VRgKbqjWhNSB80WtPiJZAwjyNBLS4rJVMA5DnhY8NdIrgl9JTZYOV+s8ym6fS1JsAJfXJJ0hSAmaUfNvvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8o+zc1eTHlM8jAjrmaZiOaONLJnoPu9bdpRqXTmpjC4=;
 b=RPU1MN8Q9n1oPtzqL2mLbrZPUNaxabQ4kne6UoJtSQ1u0RKyHz5vPTYQ2ihlk2XFJ52KCaU39To+9i4oNjfHiBCiDG7tJXf4A3aGacBq5MMNh6JNG0gm33vviJ2Q7zGwepjCj9f2wwoNdjuSfvoYw4glxBHqz8nWyMVHVTJ3XQjhGyasHyLZkmNz4gVMME3g7o09fx3p+QpGovqgPj76+flN2eemy7emhQNsMt/ez57Rc7/0AO4dV3WootABTk/V7AxalOyoVOB5MlcY4duxFDrhqySr4ohcwS6qzu6uG73vfcwXF+vtjHUpC1PuY6kDMHS5lazs3eIw3oS7/gqo2A==
Received: from CO2PR05CA0065.namprd05.prod.outlook.com (2603:10b6:102:2::33)
 by MWHPR1201MB0094.namprd12.prod.outlook.com (2603:10b6:301:5a::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Mon, 14 Jun
 2021 14:34:01 +0000
Received: from CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:102:2:cafe::f8) by CO2PR05CA0065.outlook.office365.com
 (2603:10b6:102:2::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.9 via Frontend
 Transport; Mon, 14 Jun 2021 14:34:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT040.mail.protection.outlook.com (10.13.174.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4219.21 via Frontend Transport; Mon, 14 Jun 2021 14:34:01 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 14 Jun
 2021 14:34:00 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [PATCH net-next v5 1/3] net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
Date:   Mon, 14 Jun 2021 17:33:47 +0300
Message-ID: <20210614143349.74866-2-huyn@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 09eb3057-29f8-4ea9-6c59-08d92f4173d7
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0094:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB009419B02A96CE63B533DAEEA2319@MWHPR1201MB0094.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H6ysSmpvLyu7sRG9J3zdSyAF9E+7rTAj8Lu2NYKsbg2OV0nkfpFcyp9AaXbiPDO7d+mT18IUN5FNWxjitclkRvIdEpZka9lkegUefEGfMNdiP635fHLIKNUqAeXn6uwJ5ylmZxdcFN5s4uN6hh6McQwkk3eBiF5cXS72v7CGryOIksxmzd7LUdUngvAxVFkmrsakdfa+TNolhclK0PqNOs2W3ZLznV6pDPTNA53gnhQLvTA17hMY2E8INgN6xYdbCH6vyJwLrB5CE7/pXPVVaFxgndnlR9RtsMtiFBtsS6RCH/xen89URAVB9bZxIuPYZwz4fYVSPpdiyc70CT9RBCifo+8RKGE5fxZGFxf+q2MQxLPLsgcaiZDxw4C8q3vnHP+gbI9rw3+FMG+HMQ9c1EofsrKLhm1f6SE802r8fGaCpnXuu9zOh0egw3ZeFQU+5xKTplODrfs/BePvzZHyEEKliiSlAh+tOm18xMcg0UEXAjliTN+Dko9fRd6HQwTH8anKRUHfL2B3Ll+nZoF+Ck0NyiY+2YJk1qz5XsOQwkN1qYUaqdZvDf+D2iS/g2nUwtbPpPEVmiol/YRzOXC3hYELFRgrp3NAsvbbbRFIpTlQv8T646wH/bEvvCrKnpkrCxCBP3Ek+V9VMZ47ondeoGkbEX4UHXRtmCoHChaV2DA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(36840700001)(46966006)(82310400003)(83380400001)(47076005)(36756003)(7636003)(356005)(70206006)(70586007)(82740400003)(478600001)(316002)(2616005)(336012)(426003)(2906002)(4326008)(107886003)(86362001)(5660300002)(8676002)(1076003)(6666004)(6916009)(16526019)(186003)(26005)(54906003)(8936002)(36860700001)(36906005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 14:34:01.1364
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09eb3057-29f8-4ea9-6c59-08d92f4173d7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0094
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
index bca832cdc4cb..43c0a473cc9a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4278,6 +4278,11 @@ static netdev_features_t mlx5e_tunnel_features_check(struct mlx5e_priv *priv,
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
 
@@ -4295,9 +4300,6 @@ netdev_features_t mlx5e_features_check(struct sk_buff *skb,
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

