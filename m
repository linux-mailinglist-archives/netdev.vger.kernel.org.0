Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7393A698F2C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBPI6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjBPI6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:58:39 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20616.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::616])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2E84614E
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F08Xu9E5TRfMMx+vwf0q1tb/YbUgXqQDv/3h9nM88EROVo16bdyjr+IApQ5OwGwQIHX2PEZsK3MQ7ztBBWSdETAd72lx1gkrW9wyUcr1W0xOAz7f5pSgUMmMHr6GXdpSvlrBCk3vPB4Ug7gjyBsU6UrQv7b3HMgAmEHjjEhl+ZnQWbmJnZbBU2JY0KNBdMDlYjgF6e9KZg4peCv2Hye/lf/G4+qYla+B1OKTU+lCK3/UfbjgQL6ki/QWsORwyzvVlAsHX559FV2Mkxv/sad/5JEmruF5+4zNvWQDvDBaEqEZjUXI19Z8343b9igV7+Y84Z7+Pdz+t45UW7dbvL715Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zO0aDw0tax7WqISiNBweCWwrkAHkN4VIBJuG+Nf7o2U=;
 b=ftk1xKmj7ov6CotASwXBTNx1zvz3LimDGn2jiXFzrhitk9AdrdDF6pKoXJ3iKpVZ+P3BgWt/T5VQFx0rPUhawvUBxFzHWoqNELcs43gYROL56bxXYyH4zpLUYCx6HovNX/iVo9d/UVI8L5/sxDi+OIpCAr5044sMKhQvhixEm2aQvxmWHOMs0FNi5bkTu71hrmP5dX9+Y6j2vVac7XDP3U/LZRL19bnOTk3sS+HTtp38xSXOZOz60xDMuQzwNZCn59hAudEwnfznPApfnS/E0M7fS3dY/DA6wxAvfZaeZ6tnqEa3HOVJIBKB+GN322kNzTdve/IME83eFGOioxPdPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zO0aDw0tax7WqISiNBweCWwrkAHkN4VIBJuG+Nf7o2U=;
 b=kxH8KIllnNvuvyn7P75UGYWl2m9dT5oL8c0xfvBQpIT2oCFKAIYP82GdIN4UYNFwZ711GBTKB2xuvoSM031TwvLJFGlvzZ0WppblwWnLlyQ80OG7agnGnnJAIjYapQ8VKV5unf6jKaATAw4cXg1wOOP56677HaYtqnLDpjdv+nRIy3a7/ko23Xs1QQO8ESuWaEe5wtLEXwIjxcikIjJ+XNqf09TDPOXico6IBxYjS2bXfGlLfuOan+JLmBg/b1dmxaT6nSLpbIL4pGh192JsNJzMfKCSxzowYlqmUX8s4rO/Y4WlMaxQNhmVsctxKk/LMto90XT5y+AgP7nk0/2Jfg==
Received: from MW4P223CA0011.NAMP223.PROD.OUTLOOK.COM (2603:10b6:303:80::16)
 by BN9PR12MB5366.namprd12.prod.outlook.com (2603:10b6:408:103::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 08:58:30 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:80:cafe::65) by MW4P223CA0011.outlook.office365.com
 (2603:10b6:303:80::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:29 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:22 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail205.nvidia.com
 (10.129.68.10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:21 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:58:18 -0800
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
Subject: [PATCH net-next v12 5/8] net/mlx5: Kconfig: Make tc offload depend on tc skb extension
Date:   Thu, 16 Feb 2023 10:57:50 +0200
Message-ID: <20230216085753.2177-6-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230216085753.2177-1-paulb@nvidia.com>
References: <20230216085753.2177-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT018:EE_|BN9PR12MB5366:EE_
X-MS-Office365-Filtering-Correlation-Id: c0d529b2-25a5-4359-9020-08db0ffbf984
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g1AyprCw42ruigQ/DwWPInY6RpVnrl+5WMQcEwMX3aFwkj92dQF3PrJcXWYOIOo39df/mZcWt7mtLTwN/srzXaL5s0OFngJ+gC0Eq7pT1vc9hdGxWtWXwAenwPt4KeZFHLyBAh6jR/u4mNbJLO/lxGDFQvv0lg58ISO0TJTdgRVP7SicMhlUnJqAc0Z5nA/oLCmpMPOIXZjNnsrzxhxru2Q6rNz8u6BKEqlXuHnlzZKY2PylcF0fP0zPQ8YxnHvuSBqE4J3ffX5ra2G1gv0sK/mBUUfVLAYLfxU3D/oPdBPfS7NpMx2zbiNqqhS8bSGIYr/8w+9qr/FvDmNYd2CkvOfPqHFrfWE6T1qwOPhH7RaP7yn4338EX5ovd7QuiAjipGhN3ER307YYHO/tjVzvr3Y7+5Jas7EwwjhkZSIxpzfwm6Yvov/88z0FUpGt9BeTlgflEo67F05gUYbMHnLVq5EfcM7lnzV9Rml12LOdEhtVri8TTC9QEotGFHUpMWhpo5dHiCQ48/bzFiegLoB+rFWuWBLZq2xQFM75qmfPMUYJQntb1uxprc50pXxJ6BYYILYlm/RoQEHCEV1fGMFGHrweuvFURnptb8+t1WIpOz0BgZePSRh0sKgKDAh8LzYlKyAEaWHF75qw4hdQs3CBzRRfRMPMs1KWqRXwmn+gqSqwUJJkLgcHZwg9S9+SJUYFwvOZibpcmJeZ7i6AduaHnFSrPEYBjPJD0FQ8UVCxfJY=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(39860400002)(396003)(451199018)(46966006)(36840700001)(40470700004)(83380400001)(82310400005)(36756003)(2906002)(8936002)(41300700001)(5660300002)(8676002)(70586007)(4326008)(54906003)(70206006)(316002)(478600001)(110136005)(40460700003)(1076003)(47076005)(107886003)(426003)(2616005)(336012)(186003)(36860700001)(40480700001)(6666004)(26005)(86362001)(921005)(7636003)(82740400003)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:29.9542
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c0d529b2-25a5-4359-9020-08db0ffbf984
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5366
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

