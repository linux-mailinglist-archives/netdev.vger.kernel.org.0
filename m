Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D504E69871D
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 22:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjBOVLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 16:11:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjBOVK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 16:10:56 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on20623.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::623])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 443DD11E89
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 13:10:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sk9VW4CeXNLx1VlnFh0dGLql+MLAKiWt2Vk/Bt+flyChbpxJ9IzpdStIKq8UaHlKVevhmhl3HwAAwJZq2EPDYRrxxQ9f7DisFc/9X4NYazdom6Sbn54isC74XC+NRqq8kZWmxNPXxle+S9j7nQdpTz7u+iEV0Q4H1GkIYxpVLpu08YRTsqLa/d0yn3wJIOK2K9xyyL7dIDYJ+28bIfUHfRTCbZxPbZfNa+TG9BAVg/31VJQzuJZOiG/96GrQhIPDh/1UBU82CIBYDky/qvFlBkuR1HVjKJdKkSysYseMRIerasMD9UJEob4SmDoOFVUdoVvQtJ/lXtf1vTrN0jFaOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zO0aDw0tax7WqISiNBweCWwrkAHkN4VIBJuG+Nf7o2U=;
 b=neZcJKmTSzrJ1GPhFfrX1fxtHcLYO5Hm3yhRcqBogaVrGi/YsiL7/GWGAOl0+1qzmrI9xCPROM8q82Jkvn853zms0DNr0p0jIPDfGE49y+y4LgrebUfHSvpqjCkPiX2WeZGGZEMHDyJZR5wXRsW/VSmwA/c5R2/fEtpG5a2MIzh1E75LpbGqY8Dq2qR2QWlH1jsTBW8vkOyDLMw7mdRK8gWO3Q6RYhCS7hsRi/+g3/MEj9WXIM3dKKR9qP9VYdXmC0y7z7XQMchC6ehI8WwXHNVxobnS3aeS90/YZ5XJU9tWJivLR3YgPJ0wj1L6EEhm3gbz0ALsuxByIFDCf8W1RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO0aDw0tax7WqISiNBweCWwrkAHkN4VIBJuG+Nf7o2U=;
 b=s+sKTVo74v6WXaPTVRnxNO1MHd5jQDjIP6uJ+2dSbLd+yPaU3OPVYnAGJw0Zqg4zneJbKUrGdAEOgwtKQpwkEsDolwpOXPERlkuMGoy5D2yFYo6V6sL7rq1hcoioDWB6jhxKZU4Q8a14qWzXmbAbAw67s/qpPNcj4u/A045cxb2liL1sF+RnuhWZ/rVkRZHGLt5zNoJ75ZFVjVasNCEo5Z2lajhX6zY4WCXIbONtHhg+QRqUx2rjYL0fcpWaRNqeRA5B0lIcnX1WDqbB2alTNQBEWLtDcG51AghBEoTWF90QP+g2D9+BzqzmRnJsjbFgHQdYwEkeB7VMz4B2ki4qhw==
Received: from MW4PR04CA0246.namprd04.prod.outlook.com (2603:10b6:303:88::11)
 by BN9PR12MB5241.namprd12.prod.outlook.com (2603:10b6:408:11e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.12; Wed, 15 Feb
 2023 21:10:52 +0000
Received: from CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::dd) by MW4PR04CA0246.outlook.office365.com
 (2603:10b6:303:88::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Wed, 15 Feb 2023 21:10:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT107.mail.protection.outlook.com (10.13.175.97) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.12 via Frontend Transport; Wed, 15 Feb 2023 21:10:51 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:41 -0800
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 15 Feb
 2023 13:10:40 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.7) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Wed, 15 Feb 2023 13:10:37 -0800
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
Subject: [PATCH net-next v12 5/8] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Wed, 15 Feb 2023 23:10:11 +0200
Message-ID: <20230215211014.6485-6-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230215211014.6485-1-paulb@nvidia.com>
References: <20230215211014.6485-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT107:EE_|BN9PR12MB5241:EE_
X-MS-Office365-Filtering-Correlation-Id: a657a9c2-4e04-4818-bc22-08db0f991e5d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hMtEPOatCs8uemC+DokcCgy5dIvtsC5P1i6NB0S7iVb2n6rQJyph82n8pO8rwinKKeos0SoVGC14kQq61GgkCcuGjK3EjzUbJsvAY40zDm6VzKx/EQf+qpjlpJqdHHdd0r0LJwcs9qnfksIWjw2vUO0LvEtpW3kDYyhDJcz7V10DZWteEppSgrocYq/ggs/Y0pzOU30E/igbp8jZIobtRVGPBl2kPbEjNu2qj3cYUI8dsepRV9l/x19sgNOv0l6hansWpygL6kUW40YzYcjm0PZ2xhH7bLZtA6yJwh+P4bU+bLqKs5fcKVZ6CgIpAZZGSQoKxSHQnOYUKwyCePlNdH1PaJc2cye8nX7rbj+O+TjSc7bwKpOJhCvFqqmTxop3fidhw8wSFSF+RQzASGd8hQEdzZ8RtEdm+pP+646tpx6e/wucMwSuBut1a3w0Bxh3UY28/FzrTr0RwE6W0yRJ2eUK28KACZzIVhAjjfEYVxWeTQvr4NPS/AizqiCmy2uhWC/oZYZc850bjRipy04n5rGmYvs5tBGvU73q5xJGc89a8y6vsdWex3XxjcDO11ie13uZn5gACRo8HAu/u0AfyCVtDjjQXQeLk5l9IaRPGc4Mh7kYeAlk3PmBLKpB6AuZgcAPN3qwtsTP1yKmf89Y0LeVqUrf+QKJO9wZMJmdJ5yklfpSvNzmUq6zzrHMV4uuouYY/UEtfuKQ+dZBt6hz6QjBRtYLF1TrbbPcKFjZesU=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(346002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(36756003)(40460700003)(41300700001)(54906003)(110136005)(316002)(8676002)(4326008)(70586007)(70206006)(356005)(36860700001)(86362001)(921005)(82310400005)(7636003)(40480700001)(82740400003)(1076003)(6666004)(107886003)(26005)(186003)(2906002)(8936002)(5660300002)(336012)(426003)(47076005)(478600001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 21:10:51.5992
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a657a9c2-4e04-4818-bc22-08db0f991e5d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT107.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5241
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
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
index 208809a8eb0e..247649cfd7ac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -5621,7 +5621,6 @@ int mlx5e_setup_tc_block_cb(enum tc_setup_type type, void *type_data,
 bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 			 struct sk_buff *skb)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain = 0, chain_tag, reg_b, zone_restore_id;
 	struct mlx5e_priv *priv = netdev_priv(skb->dev);
 	struct mlx5_mapped_obj mapped_obj;
@@ -5659,7 +5658,6 @@ bool mlx5e_tc_update_skb(struct mlx5_cqe64 *cqe,
 		netdev_dbg(priv->netdev, "Invalid mapped object type: %d\n", mapped_obj.type);
 		return false;
 	}
-#endif /* CONFIG_NET_TC_SKB_EXT */
 
 	return true;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index e8e39fdcda73..9de797fdaea4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -374,7 +374,6 @@ struct mlx5e_tc_table *mlx5e_tc_table_alloc(void);
 void mlx5e_tc_table_free(struct mlx5e_tc_table *tc);
 static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 {
-#if IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
 	u32 chain, reg_b;
 
 	reg_b = be32_to_cpu(cqe->ft_metadata);
@@ -385,7 +384,6 @@ static inline bool mlx5e_cqe_regb_chain(struct mlx5_cqe64 *cqe)
 	chain = reg_b & MLX5E_TC_TABLE_CHAIN_TAG_MASK;
 	if (chain)
 		return true;
-#endif
 
 	return false;
 }
-- 
2.30.1

