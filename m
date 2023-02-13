Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C98694F07
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjBMSQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbjBMSQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:16:27 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2043.outbound.protection.outlook.com [40.107.237.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100C71720
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:16:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WFm7k0OOZFJ3OAOItGw3S3YNCtjMlGGLu1l4retZ3EcvCEBvzU32w8q0fpx2TRxTDo0M684Tl5MlvDjNZB2RRO6BrsPzpaeZzYqlB/wqQiTqr/jjW9yQhObqIuxNjk3NnghRIajeilk9+k9ygM0gEumo8qZ4jmckgDZcwaOvwqK2JFZa5P9K4+/ifW7Gs2OPpW1jb3VOFnTWP1wDm2Waarfzq+oqkFY4ns6ukgfw++t5l01O+0JC5BR2hsJwkUO/UIRFFf0tPJvALPgocfd4Vv1V75+Z7/Umx/8XnAjpSkkBQjjhNlCDjofUODgOKwYM+iVev9lMzdduOVk+ZoJ2LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VDrf06IkDFNwNqRNHVfvCY2K0fBHV1BOS/wTiXopN60=;
 b=IM4qlYYYM4ze/EVaL4QCfwM2H0EjbtU63FIksXLTm2KG+cgoqJgA6jb5HmYw0p//fG/pNri+sO/rRA2FrNb0B7naVt6yWkiYT/64jKaCup4vRkzRPcybqlpYuF9bvS4sfnpISkr76t62HZz/3LLWSN6FVqtnQQSgTavQOpGHootsPPL6iz77oODxctibL1XbzqDaAShSTRw7Sk3xUxFYZ+8LGzI2G3dO4zx4+1DKhNMY5biKsSF1vBGb4aFIkOjYNpS6aSIgAFLZuVBqbGXM+LBL2jb0fOEdJLXm8DJ9q4n3lmlz7+BCu8WsCbpJXtynfEbsZXc+rsFrsL5XiL7nCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VDrf06IkDFNwNqRNHVfvCY2K0fBHV1BOS/wTiXopN60=;
 b=cSM7PCX2M8K1iGO1O67aXFPY+hN6elf0wqKDC4brGSqyOvMzT9Neh1ingfC8SiWLtyE0pZPabh66Lhsb3TAswkjTs/pusx9YbpQt0MvlA2fro3a+k/CPEoqt8BE/rLrToPO/UP1q3o2ry9Bxp4wuKNcjyhIPSM/YG/Li8j/5eoI5ZYFrvlXbYObTLPu7ZMpaDroQM6vDItG/eVKGJpR76Q1mp/BRTga2EQ5F5ULiGlhOR49gItv2tHtFlTwi2zV1iOI2lnuNKQ06lkPatVgs6DFlS2lQjvqJbxFCpgiI0rtXWepvJnmCENLsBDnCsJuDT0VuYPv8WaMMH5wj9nJgCA==
Received: from DM6PR03CA0086.namprd03.prod.outlook.com (2603:10b6:5:333::19)
 by CYYPR12MB8752.namprd12.prod.outlook.com (2603:10b6:930:b9::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:16:21 +0000
Received: from DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:333:cafe::3) by DM6PR03CA0086.outlook.office365.com
 (2603:10b6:5:333::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:16:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT077.mail.protection.outlook.com (10.13.173.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:16:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:09 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:08 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Mon, 13 Feb 2023 10:16:05 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>
Subject: [PATCH net-next v10 4/7] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Mon, 13 Feb 2023 20:15:38 +0200
Message-ID: <20230213181541.26114-5-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230213181541.26114-1-paulb@nvidia.com>
References: <20230213181541.26114-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT077:EE_|CYYPR12MB8752:EE_
X-MS-Office365-Filtering-Correlation-Id: d5432bcc-c031-4d14-f289-08db0dee6894
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jiM5N3DjtxIbDu27caZGHQ8IPaBmxtUzfLiZYc9uf+Jj34tyxc4VWzWmu3QkvSZkZGv5hUHVYeXraekz6HPF5z55OCJlIV5Ey3KhFPwa+fhc3NufMZXgjMVOUpJb39W8WJKgsYUmb3yKDSb/RcEpnhl6sNbbjyw/GP5HwtduoTbKS8H4cnVKjwmbWzniLSTV64+vesPHsg7Vq4QvMQcv9ph6IlZrzdNdvoftYXJn0vsEO4bWw6kduk7km7HiLypohNWPYzzDBNoxCpXQq/nbqTmzA47L9zWuvWSrUiVsQOAhicEyp/Q5dN7FmpDLOq8v6cqy85Uq5EvR5hCne1QRbCrfoW8cVgy/BBAB9CWxhaSe/S+7R094bmtTDfZEj5sS7WlMd8HFeIrk7NoMjI+7y5X3fJFp1lIHWaDKbSHyAR2wFuv/D/T4lngPXRUBqbddGghV83JHDTVJ+J0tX6BsU0cYulMcLPGJgJOA7fhvJ+eifBTc6JEYVsZRnWcXcEXehDiG93B7tDjX41WeFnlT/kTfY6OVLdSPjH2S+XU4I/uIyqXc2PutjDFUjDPSeDJAz67cbgiAGpExYIQ2MIpI7T+8Zt1QVbSheLzMXULLUptkkhK3/IQa/EjwcmKVZwgFRibmDUlmuyPibq4ew5WMSMuMqXxNLMo5SaBe3u9xyKuaErO8SGPny9kw/fXRjpxybn1nnJJh47Zt2rRsH2lOfh20k+0RmSZ63YkFE9Zjkpw=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(2906002)(5660300002)(83380400001)(426003)(47076005)(26005)(186003)(2616005)(40480700001)(336012)(921005)(356005)(36860700001)(82740400003)(4326008)(7636003)(70586007)(8676002)(70206006)(54906003)(316002)(8936002)(41300700001)(107886003)(478600001)(6666004)(40460700003)(1076003)(86362001)(110136005)(82310400005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:16:20.9620
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5432bcc-c031-4d14-f289-08db0dee6894
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT077.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8752
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
index e2ec80ebde58..f4897929f362 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5554,7 +5554,6 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			 struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct mlx5_mapped_obj mapped_obj;
@@ -5592,7 +5591,6 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
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

