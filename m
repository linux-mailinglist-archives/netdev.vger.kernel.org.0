Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6651568C507
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBFRok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjBFRoh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:44:37 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2070.outbound.protection.outlook.com [40.107.94.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB742A9B6
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:44:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XgejhYBGCbRaLBK44Pw5rNLoEbDM3SPGfeR1eTaByLojBLQHMM1hIIFsImRLosItJqW2/e5MdF4o2qLnu4/cKE4t0/GUmgQJcMSbn7sjD2kz+RvfC0BAACTgEPQPLZNsqmgAjmwhLs57rRfayLzTleng+WbIKfXFO5zfMEHlZuxZbFENYlcY21oao78qAeraXbhtEr6IgrRR+hUuHU0kD3HxJpww/HOgUXW7uAbUFbJN1g9EG7BOP16vRlffOR1r8cRwqdhC5Q/ots1HL6R/69FhQ5oC2QNzRQaPyR5dPPNGroaM2Ar2wPPhYMfLpIFtcZHkWqSh38B6Ga+spEpzyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=37S5Eg+50hd/aPThnH7MTu40EBHqhIu+ovzEYhwVxms=;
 b=drBnjUrzzn1qhuNs0wegETGz/UT4vwqxgFxTiQF0DcLPSYgUL+Up5tSySsSgtqGVUSp+ViLYwTxcXlJZaq3J/rtv/yJlGAWNoMJ4Nl5b5BVKWnklQMrb35vQ6U7xEsEKwJEwzranYeyJkBI7iZiaR+Jf4TO99ScQBwJCZh5Wgq6RWqtWbSkm6GtRlql8BG+ukMTvM26PzB5pXX51pJQYZnICS5Mg2X8WvjhTg7LflPki0QavbbaJr22XKh+exWRTVRrhHnhRJwlMBIU4OGkm64f+Xdv19ynpkU5aLQx8yOZssHc/QAIJj0MOanyGmidm7+7YWnRDYRMHUdg8oeR3ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=37S5Eg+50hd/aPThnH7MTu40EBHqhIu+ovzEYhwVxms=;
 b=rOcQwq+NTOEjou6nSQl+Vzw6Ke5DRQPFVhkXOb7v0pGn3OQe/cg3dqaXmv50meWVmulmLpJjYQ1Xq7aIWsWJydGFFr1Bm8gTSuzHJEfdE8uF1ImepGv5wY83W4L56pcFFE9ksL20x0DTw5b2ixQh7NDMhsoDUHiPXyWi1fGVHn9YhXNQSa2bod8MURNYTBjfM9V9u4ymW//aB01YDCD/0wFq9MGxahifS3GqS8OiPeEWyNGsc/YWykTS+g/qFNYixj00uSVdVklwWLiwrlzupnQ5BSKC0poUkETRbPDrk6VtmyccGzMz+Xewy/hQZTi7e+Ponvb+cxphpaihz2zzkw==
Received: from DM5PR07CA0076.namprd07.prod.outlook.com (2603:10b6:4:ad::41) by
 DM6PR12MB4925.namprd12.prod.outlook.com (2603:10b6:5:1b7::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34; Mon, 6 Feb 2023 17:44:30 +0000
Received: from DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::d3) by DM5PR07CA0076.outlook.office365.com
 (2603:10b6:4:ad::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35 via Frontend
 Transport; Mon, 6 Feb 2023 17:44:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT091.mail.protection.outlook.com (10.13.173.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 17:44:30 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:44:23 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 09:44:23 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 09:44:20 -0800
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
Subject: [PATCH net-next v9 4/7] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Mon, 6 Feb 2023 19:44:00 +0200
Message-ID: <20230206174403.32733-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206174403.32733-1-paulb@nvidia.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT091:EE_|DM6PR12MB4925:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a665b95-1404-4503-94b8-08db0869cd11
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uwa/Ttwbvq1D04rcSadtVoI0WV8Jp2gpVwjsqAtQtDoJkPiC+x8+1B01QFD/ittmLGbFvavmknWxIzhbBJkshNtwJ1JUSooMecPm0afXwNtU9MQRwf+x4Qc01h12IxOH2u0TMt6XMfqtFY41YkO75hAvls6MpXTmCDBNnZ2KGSJGf1C0cxFy0fFA9dPNayAyPQEw+3Mtf8HXybdPtiOSeYuK1qF98RjuZMc9c0et5AoXAvEAkS2lTDfTjzMDb7QNaGDzNH4XD1tWj1Pj12TkZia9ilmSkwNMmATx109B1sUg5u3LoIkRt3ua1Oa5RskP7v7yW+TzRfTcSNDHma8TXFkQcQemhGovj0xAD/otSehIEMXYKjY/KtO73x+ySuda1WbvxnGu9j9GofX/Q2yBgtbzrw2xDRDqwh1Rw7OpHC/YbUGdIkd85DRgKAdnaJrjr2tMvKAhWngTc0yCgzTWcQf/o0SHfXoUoqzxx+W0BFIO3MePMG1hu9dmbDd1VxcsuAzxKr+GFFniVE4NJfRyYh1nDW5dGQ2AW4IopkVn3aJhRnMbLfoDIF8XdTQeBZGbEwcjivPBy5gHqRtc9yumhUFHa+dpBjf4jLkT6Qv11pv64zZrXwZW0QW+GucZIJY2gPzYpix2BDRNqbBNE7P8QLD7P0lpYNwBSyFJavMuvqxn7mByiOTRl9aKnVV47g0/8motAz8NDna1IoOK+hYsWQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(376002)(136003)(39860400002)(396003)(451199018)(40470700004)(36840700001)(46966006)(336012)(70206006)(47076005)(83380400001)(426003)(82740400003)(40460700003)(7636003)(40480700001)(356005)(8936002)(41300700001)(36860700001)(70586007)(4326008)(8676002)(2906002)(1076003)(2616005)(26005)(82310400005)(186003)(107886003)(316002)(54906003)(110136005)(478600001)(36756003)(86362001)(6666004)(5660300002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:44:30.5939
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a665b95-1404-4503-94b8-08db0869cd11
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4925
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig     | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c  | 7 -------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c     | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h     | 2 --
 5 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 26685fd0fdaa..bb1d7b039a7e 100644
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
@@ -100,7 +100,7 @@ config MLX5_CLS_ACT
 
 config MLX5_TC_CT
 	bool "MLX5 TC connection tracking offload support"
-	depends on MLX5_CLS_ACT && NF_FLOW_TABLE && NET_ACT_CT && NET_TC_SKB_EXT
+	depends on MLX5_CLS_ACT && NF_FLOW_TABLE && NET_ACT_CT
 	default y
 	help
 	  Say Y here if you want to support offloading connection tracking rules
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 193562c14c44..2251f33c3865 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -2078,13 +2078,6 @@ mlx5_tc_ct_init_check_support(struct mlx5e_priv *priv,
 	const char *err_msg = NULL;
 	int err = 0;
 
-#if !IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-	/* cannot restore chain ID on HW miss */
-
-	err_msg = "tc skb extension missing";
-	err = -EOPNOTSUPP;
-	goto out_err;
-#endif
 	if (IS_ERR_OR_NULL(post_act)) {
 		/* Ignore_flow_level support isn't supported by default for VFs and so post_act
 		 * won't be supported. Skip showing error msg.
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
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index ce516dc7f3fd..ee9c8f31491e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -370,7 +370,6 @@ struct mlx5e_tc_table *mlx5e_tc_table_alloc(void);
 void mlx5e_tc_table_free(struct mlx5e_tc_table *tc);
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain, reg_b;
 
 	reg_b = be32_to_cpu(cqe->ft_metadata);
@@ -381,7 +380,6 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 	if (chain)
 		return true;
-#endif
 
 	return false;
 }
-- 
2.30.1

