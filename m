Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C22569B59C
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 23:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBQWhM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 17:37:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbjBQWhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 17:37:03 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2064.outbound.protection.outlook.com [40.107.244.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487D855BD
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 14:37:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAYftCFGYHi7gsxUTJkolt0ZNX/2Y+5hO9sVs6ew4pP17AeSEYBmiANHiWdukN4xzSy3Ebn1cD4rWafiPH1v0FL7TGFYCnJz3UujMnFfeWratqYEb3v+aMLqJp+qTvA4HL/fjdoaFbEN2+OYvyBNWz6tyaVkdDSvpW+UJxb48MVpZaturwQu7P3Lwmy0KWRFgpJw0MgsBlGNwZg4fQ7VTOLVetKGLyr1Xuyd5AhQIEeTGyeEuMqbsrDOItnQXiSWtT90dpdmJwbETXSOx0QVsn3maGSurL2qtTozRszk3x/zjNPdLXPd3kD8obZIw102pu3UkFdE2NJ34B0IVr6a+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lhVlal5FnRk7HF7eW75ziSpsnbH99UsCsjdNo3gqW8k=;
 b=Xa14mL+/o+gNQTX9fzr3HV0SUk6UYrt/h80YDFPyfb+rZg8Yd+zTR6tZx2Sx6/Hn7JIopQPzWX1eIPuL+44yVx+xC9pYutOQoFkGZmuf8gG8HtKJbV1DvLat2rvra0rPJVVfM3V3cE4uCNJ23iQ5VP2VNWjTJVKTZ32VtYODL0cQAatz7a7qz/V8A5eYa7Cvp7F2YVYibaTJ0ZCoOoKiPCkZTqEWcRxs3s7jWFyhuQaa+JLVp4JUVvYbOMd6l1tW2AEaJuRoPFH4oS5cIpnOlvLMx7ukvazKlDttqdXfySZcqwMpc2KNW3dCV/sxgm1uhHMshmxQKN6JhL2B2Yg9gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lhVlal5FnRk7HF7eW75ziSpsnbH99UsCsjdNo3gqW8k=;
 b=DVBPOc4GomLSXA8A7Re+EyWyR1g3vkorZq2ksKtfdxqlpZyuG7og92RfRCxTrpzj2muEBIR3MJTc7Twgm7oN6CB6aMrVedBKfDTpnWErKH56hdi39RWKuU6vpYgSp5P8qe7tX73xCF2n5hzesQ6VlLbzwHqQLuwsOGKbBfw0Y0+vrvKYzpTGLcq2ogM64arHE1f1dj5T6Qj29mH+s50bSDPz5o1DHf1NQpHuouTEY4BcSAHyWT7mnWTltyuhPHKH0BaF0/R6RSjvzvAUcQB3QbH7OzDp2dvlNELZUPDBvf3AEj+OOqut84tGygzgBeBeP7fx/Ri2JwEGP4sBvHzjOQ==
Received: from DS7PR07CA0019.namprd07.prod.outlook.com (2603:10b6:5:3af::7) by
 MN0PR12MB6149.namprd12.prod.outlook.com (2603:10b6:208:3c7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Fri, 17 Feb
 2023 22:36:58 +0000
Received: from DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3af:cafe::a8) by DS7PR07CA0019.outlook.office365.com
 (2603:10b6:5:3af::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.17 via Frontend
 Transport; Fri, 17 Feb 2023 22:36:57 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT057.mail.protection.outlook.com (10.13.172.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.17 via Frontend Transport; Fri, 17 Feb 2023 22:36:57 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:50 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 17 Feb
 2023 14:36:49 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Fri, 17 Feb 2023 14:36:46 -0800
From:   Paul Blakey <paulb@nvidia.com>
To:     Paul Blakey <paulb@nvidia.com>, <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     Oz Shlomo <ozsh@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v13 5/8] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Sat, 18 Feb 2023 00:36:17 +0200
Message-ID: <20230217223620.28508-6-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230217223620.28508-1-paulb@nvidia.com>
References: <20230217223620.28508-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT057:EE_|MN0PR12MB6149:EE_
X-MS-Office365-Filtering-Correlation-Id: 20ad7998-e849-4281-1aaf-08db11377a66
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kb0qIm/rY1FvNRDUsH9UbfPWgSthytyL2GMzT4Pf9zmp1/ly47JWI2pCX9bo19teKMBWFskMkvlG1BsMPcrPhKXAv9vJRVzKUvVIoTIpt2RC2VMS1wuL6xk79pnfCiC+m7bqxnUzimDkbkxgUl2coMudMIJtuCfSzMM4K3N/+dwqPCFzKY47nggcY3y8qkCU2ZkLIYSpWljuJHeviJgYPcO9UyzZcgaGxiyqFtIKAqwrF8lIM47t5y2/rEk4Ib/1u10T2O663+xxEu1Np1MDucVNPUtMwKvp/hmCtTnRgXUSdsfT7XIkyZji071IGnz9UJwIpMaBKJARUwtqYQmepITtGhfgj0EPSk0PctI1dqs4hff3BWVifkSVeZJq2kvpl5C6GYstD9w98bCxmrc9q4Ke3Xxt9wBTOqZp/V5jevhfSGI6EKFqqu+jqdJ7lfewYZ0h/y1AXmzewEm2tYs662iKd/lrFMB0BSpiMewd+kfkFks+FJkG58EbTc4NfKKyGjuKXNyyxwfwcnlGZzT0nfcvgLgTdnWzAn5Aj+j+RB7035xb+zl/qMLzbYC8rRpISIXELS8KXMaevzxa8oe9jKg+qNE+aCIsacsFlD8JlCr99RLuWJFxTN3PdasZsclz44Fa8bQ7OE69Om4TrV0LyQWy9+Qg9s8zHMLDxEyS6lACUwUOA2bqMDJQ/bNRopTQDnYkpUfwlnaRKZShGs9QHMyUFTXIZUnUYBbhHndDwRg=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(426003)(83380400001)(47076005)(336012)(2906002)(107886003)(1076003)(2616005)(8936002)(82310400005)(70206006)(5660300002)(70586007)(7636003)(36860700001)(26005)(6666004)(36756003)(82740400003)(186003)(54906003)(41300700001)(478600001)(8676002)(4326008)(40460700003)(316002)(110136005)(40480700001)(356005)(86362001)(921005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2023 22:36:57.5880
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 20ad7998-e849-4281-1aaf-08db11377a66
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6149
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
index 3b590cfe33b8..365627a5536a 100644
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
index b401cf291782..55fc86b837ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5607,7 +5607,6 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			 struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct mlx5_mapped_obj mapped_obj;
@@ -5645,7 +5644,6 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index f6b10bd3368b..2bf037de2c1b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -368,7 +368,6 @@ struct mlx5e_tc_table *mlx5e_tc_table_alloc(void);
 void mlx5e_tc_table_free(struct mlx5e_tc_table *tc);
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain, reg_b;
 
 	reg_b = be32_to_cpu(cqe->ft_metadata);
@@ -379,7 +378,6 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 	if (chain)
 		return true;
-#endif
 
 	return false;
 }
-- 
2.30.1

