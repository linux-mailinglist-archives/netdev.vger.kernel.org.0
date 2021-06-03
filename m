Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4BE39A532
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229820AbhFCQCs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:02:48 -0400
Received: from mail-mw2nam10on2069.outbound.protection.outlook.com ([40.107.94.69]:18849
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229597AbhFCQCr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 12:02:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MNhX6LjW4zyhjVplxcEYbgUzCrjL/hFxbaHnPH62CZPFYp3wT9njvXZRT7kZm9d0zK5S+JbyZ3DbWqe6jBLV2+jmCo229hugUOnq+pyYguYd+Xy5S0wuDYu72lmRhmbeQ1lvaFqYslSeEqlVrpK6DLsxkL/fDK5c3m5l4IoR8E5fckPZkcCQay737bx+6TdkoAM03efFRc/AvzmzAkQzm5Me/aiKVoxwCef74+80hnxoIC7rB082UPI4ctPyihgk1Gxb2DLO5ZX4+J+5PnpQDn4Fq6stXssSHkBa86kOApzoDT2fhnkTVUF1crm3WzpJa7mrtO6WsjSteb9coU6DjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elNJ8nhQtM0lNLDEP8V3pa0aVXHmIA7dRR8RS15Y8sg=;
 b=LRE/0lqQZDaOsX29/lv0WeSK2BlU1chlOD+QM8vpRbN+ULpgxRSQqJUOIoFdANsPfBSix7c59kB1V4oMTIoqTyFUP3bmhL8QGT6wtrdQlLdGXvcYNRiTnPSN9X36iLbipp16jBtWq0baJ8rmOAfJr5ldoaBOxlKgTsjisJxvtN49q6CPyhUZwhO/GPY2fGRrfQnml8qWyhecJJBsShwXIUWoTTMQzA5I9WukGuWG0CxHz5OPL31WRk8gUMIELTFXIoLr9M4XPZiri6gD5rgHV//Z0hYijnX5ybaG3DU10m2WxjvCDTlCOQ4TKVPd+V6mJW9QowmADcLfctmYW0Q1qg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=elNJ8nhQtM0lNLDEP8V3pa0aVXHmIA7dRR8RS15Y8sg=;
 b=eIukxRhuqwqUM6NDic46luW3ryjoJFZva8URqiKLPdmJwg2bQwUyQ2qivwQfMa4AvOvOu+Jqzn9+Ms8Q82enBsZMj2ezMYW5gW0nPBqnAGsWMLQu4VsYRklzcfjBp1w0vuHruQ7wwkffYakuNjqFGlA3schbIMCEijeBzV46gcbW4ZML3/4NyRVMepxj8F7rhSES0r+9NCubmgbXv/DCa/x9oLBD3yk24+mbQ6aIk5VDJv8kHg/Dl+KCr0H99Lgu0USWOkxzDdjeajk/gOyHD76cfsDU0XE5coPNk1/2NXHe8kiYaN/PWap1pCaP6wiHKU/eVSgIln9rzhYDFsbwyQ==
Received: from CO2PR04CA0203.namprd04.prod.outlook.com (2603:10b6:104:5::33)
 by DM4PR12MB5328.namprd12.prod.outlook.com (2603:10b6:5:39f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23; Thu, 3 Jun
 2021 16:01:01 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:104:5:cafe::de) by CO2PR04CA0203.outlook.office365.com
 (2603:10b6:104:5::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Thu, 3 Jun 2021 16:01:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Thu, 3 Jun 2021 16:01:01 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Jun
 2021 16:00:57 +0000
From:   Huy Nguyen <huyn@nvidia.com>
To:     <netdev@vger.kernel.org>
CC:     <steffen.klassert@secunet.com>, <saeedm@nvidia.com>,
        <borisp@nvidia.com>, <raeds@nvidia.com>, <danielj@nvidia.com>,
        <yossiku@nvidia.com>, <kuba@kernel.org>, <huyn@nvidia.com>
Subject: [RESEND PATCH net v3 1/3] net/mlx5: Optimize mlx5e_feature_checks for non IPsec packet
Date:   Thu, 3 Jun 2021 19:00:43 +0300
Message-ID: <20210603160045.11805-2-huyn@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 11874b06-d5e8-4d21-e161-08d926a8c8f0
X-MS-TrafficTypeDiagnostic: DM4PR12MB5328:
X-Microsoft-Antispam-PRVS: <DM4PR12MB5328D057CA29A82F9F5CF0BCA23C9@DM4PR12MB5328.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SGK+wFgfMPaYiAtTLqHwW49b+K7VIz3ZQhRUaxB0uCDEoHi+g85qKV+5HvMGZDeK05xhrWIcFg/B40hHQgfKFel5WQX2aRWkWl6auo6ol9cfGXw3sy/w1eKBuJFVNvfKiAx4qVUIb9t87jHg6eVMv645ER87eM3ZhWVjX5937S5+6W6JmND2ZtPWeYY9ZbLpkVk22QGppxCLNkXlbP+zh0Uc2EBLAqOncppcFJ8DpNOrmfIUQmAlSeqxjW1o8KmRxOWuuQ8MAQri5ARYkGQZOr01SD18Ko1srXW8ecnxHGkkBH1eY3NlFuFYu9f/m6qbBiDkT7+Qcx4CBOE6yeJnc2CGCYou3YylC7Y/6zeEs0vDaKdl2hk3kUa0fhRsIVFC/YZ5NRsNmYbTbG9NCdWx2Ste/YrUoUBiwRrscLoAlzDH5h5zEgrVxbE/61RTGIrC+wHwahSyZq3JMIhU6uJqqFSYPcPCZGaPVVxsXo7bjERKMhuLrTtDMmZLFk2nwIA3EzLggBFePh3iufoN2/ptXr1myueVOZLMtw8nKLM1W2QTvuviYj7ADC6P/AtiQRDggr/HERBwI4IHk0kX3W/J/nSgEqKrcS0rH1y0YKOTA+GFrVEx9shmfBDbet9Fi6Ki20P8BsaiMTHWcvrsrmTj7D3F06KkPaJJYzLmoWn6arQ=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(39850400004)(376002)(36840700001)(46966006)(47076005)(82740400003)(86362001)(7636003)(83380400001)(82310400003)(356005)(36860700001)(6666004)(70586007)(70206006)(8936002)(8676002)(5660300002)(4326008)(478600001)(6916009)(107886003)(2906002)(1076003)(26005)(36906005)(316002)(36756003)(2616005)(336012)(426003)(54906003)(16526019)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2021 16:01:01.6167
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 11874b06-d5e8-4d21-e161-08d926a8c8f0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5328
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mlx5e_ipsec_feature_check belongs to mlx5e_tunnel_features_check.
Also, IPsec is not the default configuration so it should be
checked at the end instead of the beginning of mlx5e_features_check.

Fixes: 2ac9cfe78223 ("net/mlx5e: IPSec, Add Innova IPSec offload TX data path")
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

