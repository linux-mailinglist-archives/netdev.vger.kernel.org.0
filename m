Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11E968B0C1
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjBEPvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229760AbjBEPvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:51:14 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9327C1D909
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:50:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WldbZnCy0ECgaYYIzpCXaJlXoUCerets7MlwjL0/F6t7ovUhSAMNURGYA82MgWL1qzSSDbKYwndanKhglNTB6beiS5pgmdj6wVVU3RmHLFsgxopr+P4mzlKoXwt7ZvRxgDISvENSD8RYdw7cnyM7b69d1ORscWMAaOuufJIdQihMznJLZlmsvg3qJ9JyjavGAAequdnfYFPlts8wVdAIBVISyDa0GpBhg3s2MebTv9ZSyG1kS6WbDv5Wvs79b0ocMRNl+De3RetSzsNmGTdwf+OnKiRPM5EUh+FIdIuP9/OlvnW+23A0kB++SCCoU+Nj9liyIa8yA0cvHqaIRkC0ow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HyQhAfw5mseHVeHPs4hpCjX6cAolySXMIsNeG4LFmzQ=;
 b=kpwoFuXWdjESCBvQuktCrJpSSvFukgXnqQ7fznMp5SZFokNWg7QdFL93Wne36ca3FI/LXEWJ7dkln206+UUNPtS9ykUV5vOvs6hlK9DEjM6jP5yFEkfsAEDuThDnQ5rz1LKaHehG+tX+lC5aRkVuzy0mYRKgexDNQGPGInwqzJ60pWzkjcX1pF8qy4RcILdn5J2tECjALEpjrdLA/Yihw0vFW24j1TOKejneW2YdWf6c1QQVHrEHUmJfqxll0+6dQi+YrVL/bLZf/RrFApjJqiWvDC+vBr/UY3zP2iZi8oB1AMqlBRkrZyPXLujuZ3XYBbXZ/avVJRLlWeYTNsRm1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HyQhAfw5mseHVeHPs4hpCjX6cAolySXMIsNeG4LFmzQ=;
 b=RCTfwzV14f24Ok+xrlo/bB3DvqTz5gICQvuInANzUeUv/ENSam/Hs3W4X+qvrVMGVo69FKsIMazV7i2AszVGWHyKkws0am2+q8A2XHyoxbxuAJYgjNvHZRkZHuCuxiDF6vvqShM4mR0KKT6rGGmJYywHl3O0uZ9818H/nenkKj3cQp4XixHWXhv3sxm62IZV6l0+bJwiM6Ua8XjeENuBGSrf3vbUWAgQvKzjxx/ye+UF1UyOyGW52I06ox3MtSxSVRwiZ0Zp+LrmkTrnam+rC6Ub7p3qb4zLfK9HSB7xQ1qKsO9Vpek3ruK4dlUOjIy9H+hKkWQS4DqhBxr1U+AGtQ==
Received: from BN9PR03CA0742.namprd03.prod.outlook.com (2603:10b6:408:110::27)
 by CY5PR12MB6321.namprd12.prod.outlook.com (2603:10b6:930:22::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.32; Sun, 5 Feb
 2023 15:50:04 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:110:cafe::89) by BN9PR03CA0742.outlook.office365.com
 (2603:10b6:408:110::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31 via Frontend
 Transport; Sun, 5 Feb 2023 15:50:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.32 via Frontend Transport; Sun, 5 Feb 2023 15:50:03 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:49:55 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:49:55 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:52 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v8 4/7] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Sun, 5 Feb 2023 17:49:31 +0200
Message-ID: <20230205154934.22040-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205154934.22040-1-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT054:EE_|CY5PR12MB6321:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c347eff-33ad-47f5-cf95-08db0790a58d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PkL7OWDEJ9dtQTM7TWjcRWm1My3KCbIdq8KP/08SA9W9N76QmTb3m1QPP44kW7q2zSJDzF7JgRYyDoL9Wa1Ldt6aJkJFnTuRSUVnTmkTuSg3EhQH7hbeZcPGQ10eriFvh5nAJkBi4KT2QPLeth/PaUlWe42yxun8usG+5YIwIk50WX5QhBmrQerGvBU3BJLfDCCOsrZ9QN2aq/Kgf31D5HznlfbAbg3WM5L7zzHgTYX0AoX990Kkfj97kUjHdC/Z3wvIu+Gtyp+TiFmXxrl6LBFbgV+3I3mdQtu16jVr3V9bDY/aXomsDryP2FMiFqi/OrXVa3DwICNUNk8yJJ6kn05PeqxJhaM9I9bamAl9D54x6CKaMFBfDR94s8hRj6gK67UkXEk6Xj13SP/gx9mAwImX/eGvD/hnuywSoUEc9tHr0pe592i2QwFLmvjK3IWxb/3GtFGM4v2Xmha/Eo5roQOKKr/YTW4P9gGmULtekFsFDxmr58Vp56+iCKKQMn1dXUfEbBUdKphGs/l5AyLEJD4NUIjcptemEKqzqt3hQzX8rvpv6BQMSSfY1+mIuozRyfT66sP0xQYaRFlSVEKyKsHblo8Aty2oAGSZkK6gkp3WBXGwj8tHotCkyCKTvUc6wOcz9HPUABKPNpv1SvPEUQMFRZE7CIHw+/TMemnWeMxnlBGBrk53y5OFRjFNsD9W+QMkqTxjrFk38XhBNpXDvQ==
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(396003)(346002)(451199018)(46966006)(36840700001)(40470700004)(47076005)(186003)(26005)(426003)(8936002)(36756003)(336012)(40480700001)(41300700001)(54906003)(110136005)(316002)(40460700003)(70206006)(70586007)(8676002)(4326008)(2616005)(7636003)(82740400003)(107886003)(6666004)(356005)(83380400001)(5660300002)(36860700001)(478600001)(82310400005)(86362001)(2906002)(1076003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:50:03.5245
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c347eff-33ad-47f5-cf95-08db0790a58d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6321
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tc skb extension is a basic requirement for using tc
offload to support correct restoration on action miss.

Depend on it.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig     | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 --
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 26685fd0fdaa..20447b13c6bc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -85,7 +85,7 @@ config MLX5_BRIDGE
 
 config MLX5_CLS_ACT
 	bool "MLX5 TC classifier action support"
-	depends on MLX5_ESWITCH && NET_CLS_ACT
+	depends on MLX5_ESWITCH && NET_CLS_ACT && NET_TC_SKB_EXT
 	default y
 	help
 	  mlx5 ConnectX offloads support for TC classifier action (NET_CLS_ACT),
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index b08339d986d5..fcb4cf526727 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -762,7 +762,6 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	u32 tunnel_id = (reg_c1 >> ESW_TUN_OFFSET) & TUNNEL_ID_MASK;
 
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	if (chain) {
 		struct mlx5_rep_uplink_priv *uplink_priv;
 		struct mlx5e_rep_priv *uplink_rpriv;
@@ -784,7 +783,6 @@ static bool mlx5e_restore_skb_chain(struct sk_buff *skb, u32 chain, u32 reg_c1,
 					      zone_restore_id))
 			return false;
 	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return mlx5e_restore_tunnel(priv, skb, tc_priv, tunnel_id);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 4e6f5caf8ab6..b173c7e9e553 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5565,7 +5565,6 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			 struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct mlx5_mapped_obj mapped_obj;
@@ -5603,7 +5602,6 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
 }
-- 
2.30.1

