Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10CE1698F2F
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 09:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbjBPI7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 03:59:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjBPI67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 03:58:59 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2047.outbound.protection.outlook.com [40.107.243.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 836AA410A1
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 00:58:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PcvwdZNdzzzr8Wm3Ca9RQ60GoH/DsP53+a7sFM29Ve4WpeutTRz2c9TJk5wAPIwINmxIbpgTuKeTeaaB0Nd9JDL/PysuJNkf7IIpApRNTe1u5rod5uGO3j/8wUfrcyCGiyAhQRYkKIfAOY3Jaxs0l1kDbe0eRM6UQTLvh0+6jkwVMFU4q7XF6ZjdNj/5JyvtFFltU0pUKL3eQHBniyQfTkTVlfshxpp2dimh2Pf0/BbBrKXjcUCfVPDObq0TrRFkAKz/v2YvzK1pr9EOcAOu7T1mDIyPgIBChxfaNEcvCr0FAaigJT7wqLaCvqi1Dsbc0WUoKZoaoyjNlTasLk3rbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2RCekZY/QU8aMpLz6SWza1XT+uGr++vPYstGSngaNu8=;
 b=iMUoV/NsgVvuj/i4BP+IGrMwr39sGELxB/lK5oJ3ISWF4L6fKbJc7njq8RkbROy+C7LGXRc0zzK0eAhiND1nv/jUINQpbpRcm9ILMBJ3sur9/R3lLRsHHKAD5sjXI7c3NiK80o2Ms20IX4ey2Yp4AfPkwXtQEION2SRo8uHLjqC8B4GHeUgM9GOLyQ58E/xkHfrqRPySMbU2t9v+/rjxfdEtpKliTLmpgsnXFAGiW6AX/mih2GkeQMpQ/mLPt88EnknoqqWf+fcSvhr2Qu9JZbRs7HdSVXhsHywPXIuKrfKW9bRIisx5hRfMdxuuDRkcNai3IUsQXZLe6+sEhSHi6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2RCekZY/QU8aMpLz6SWza1XT+uGr++vPYstGSngaNu8=;
 b=uf41bebD/v3lEgoMulW6LAR1kaB0AsSTg44UfincKHpdHqSlykFdikSBHyNnbV/cBTcs9XkieRy8rCMOw+MWrOCUU3rbjMmQH2bwPFo/sbblH0+IBHP+lVvExe+5fO0SEpDfV2wOpd44+F2l8xc0G4icSiy+Cddqc/STYZ+UNC2tJAdHpPcDhgKck6LnyTjM2kQczZ+rCX+MASVas3o0KoYv46K4fSJgoxha/9M3LmHb5rpxRsCP6QSmZ7BSYXUwXiKcNKPaw7CtrzfJYS5/uNL+ftE9Ef5zmUUpELRlPheuB6tzZlgkWOutWPD5BerRiP5u+AuZ1mkiPXj8ngJJoA==
Received: from BN0PR04CA0079.namprd04.prod.outlook.com (2603:10b6:408:ea::24)
 by PH8PR12MB7351.namprd12.prod.outlook.com (2603:10b6:510:215::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Thu, 16 Feb
 2023 08:58:44 +0000
Received: from BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::78) by BN0PR04CA0079.outlook.office365.com
 (2603:10b6:408:ea::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26 via Frontend
 Transport; Thu, 16 Feb 2023 08:58:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT102.mail.protection.outlook.com (10.13.177.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6111.13 via Frontend Transport; Thu, 16 Feb 2023 08:58:43 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:30 -0800
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 16 Feb
 2023 00:58:30 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.9) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Thu, 16 Feb 2023 00:58:26 -0800
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
        Ido Schimmel <idosch@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v12 7/8] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
Date:   Thu, 16 Feb 2023 10:57:52 +0200
Message-ID: <20230216085753.2177-8-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230216085753.2177-1-paulb@nvidia.com>
References: <20230216085753.2177-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT102:EE_|PH8PR12MB7351:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e29d5d0-1fe9-4ef5-88c5-08db0ffc01ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GGcywJy3Xda97yAK6I/oc2tyRyvFBnbbkCIjgD6GFzKeY4P5lgWRT75NzOXhIngLETKQQxXyRCTuNukrL9PNNErlSc4NcMBll91lnGdo1fNo0wmAWjCzZ683RW5piSYSc7m80gfKrF8cB9BkQjAc5OGciVcceo7Z7AakDfFsT7hc3LeoqrrDUTLg0LjwtNDjIl+Yn26HXbwZvbpsHi9gwtHGQuHLIKKK5KH9EuCjD7sE+J0wcGQ/qRHDEt0AS1mWmm+fxiPfYVc2Q0B0O6gK7ymUWdxn41R4THAI14VSC696tjz5lMWRP8m458LBStwfrAuo7kCbqA7zm+C0opZ1Roaspxit5RjSY5p+YUx5i805Ftv/IJmkqOsN9laeXNlbHSlnKVAbTFm2zKXxuRu/nDQ0OoAJxgzF5h6AE1+DryBw7QCPv9C5R/dMqqs8zInN9B1pnWAohLdAXP3qBbinSOHJWJDZ4IjmgCeZgLHoUcGRDatvkz79Q0IxPD/yvIlwvyKXyCefPYgS5oChLYLH79OIPQpPcSPv48djMgTmdady3ppIRHA2nAKYA2P/iRQnvTfMlR5XM3FFmwoq/G1K4B2ab29n07VI84GsQ6DmG7QDFThjlPfnymvceeqJDfCygx7OiKmXTRCcEhAHmIx48gWJPuwO7u2sJQSQyk3GmHAgI4/F1gBSCos88klfnk7GsP3LC3OkHYwYNoEqRSbYZi/P2Ns82YmnxZIG27B+vos=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(346002)(136003)(376002)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(4326008)(110136005)(8676002)(70206006)(40460700003)(86362001)(54906003)(316002)(70586007)(336012)(41300700001)(5660300002)(8936002)(921005)(36756003)(356005)(426003)(26005)(6666004)(1076003)(47076005)(478600001)(2616005)(107886003)(2906002)(82310400005)(186003)(82740400003)(36860700001)(7636003)(40480700001)(83380400001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 08:58:43.5416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e29d5d0-1fe9-4ef5-88c5-08db0ffc01ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT102.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7351
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reg usage is always a mapped object, not necessarily
containing chain info.

Rename to properly convey what it stores.
This patch doesn't change any functionality.

Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc/sample.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  4 ++--
 .../ethernet/mellanox/mlx5/core/lib/fs_chains.c    | 14 +++++++-------
 5 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
index f2c2c752bd1c..558a776359af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/sample.c
@@ -237,7 +237,7 @@ sample_modify_hdr_get(struct mlx5_core_dev *mdev, u32 obj_id,
 	int err;
 
 	err = mlx5e_tc_match_to_reg_set(mdev, mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, obj_id);
+					MAPPED_OBJ_TO_REG, obj_id);
 	if (err)
 		goto err_set_regc0;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 2251f33c3865..de751d084770 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1875,7 +1875,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	ct_flow->chain_mapping = chain_mapping;
 
 	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err) {
 		ct_dbg("Failed to set chain register mapping");
 		goto err_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index f5cd8df65e23..cd16cdddf2ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -109,7 +109,7 @@ struct mlx5e_tc_table {
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
-	[CHAIN_TO_REG] = {
+	[MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
 		.moffset = 0,
 		.mlen = 16,
@@ -136,7 +136,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	 * into reg_b that is passed to SW since we don't
 	 * jump between steering domains.
 	 */
-	[NIC_CHAIN_TO_REG] = {
+	[NIC_MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,
 		.moffset = 0,
 		.mlen = 16,
@@ -1605,7 +1605,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 		goto err_get_chain;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err)
 		goto err_reg_set;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index c918297831b4..dc6ec18de708 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -233,7 +233,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
-	CHAIN_TO_REG,
+	MAPPED_OBJ_TO_REG,
 	VPORT_TO_REG,
 	TUNNEL_TO_REG,
 	CTSTATE_TO_REG,
@@ -242,7 +242,7 @@ enum mlx5e_tc_attr_to_reg {
 	MARK_TO_REG,
 	LABELS_TO_REG,
 	FTEID_TO_REG,
-	NIC_CHAIN_TO_REG,
+	NIC_MAPPED_OBJ_TO_REG,
 	NIC_ZONE_RESTORE_TO_REG,
 	PACKET_COLOR_TO_REG,
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index df58cba37930..81ed91fee59b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -214,7 +214,7 @@ create_chain_restore(struct fs_chain *chain)
 	struct mlx5_eswitch *esw = chain->chains->dev->priv.eswitch;
 	u8 modact[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5_fs_chains *chains = chain->chains;
-	enum mlx5e_tc_attr_to_reg chain_to_reg;
+	enum mlx5e_tc_attr_to_reg mapped_obj_to_reg;
 	struct mlx5_modify_hdr *mod_hdr;
 	u32 index;
 	int err;
@@ -242,7 +242,7 @@ create_chain_restore(struct fs_chain *chain)
 	chain->id = index;
 
 	if (chains->ns == MLX5_FLOW_NAMESPACE_FDB) {
-		chain_to_reg = CHAIN_TO_REG;
+		mapped_obj_to_reg = MAPPED_OBJ_TO_REG;
 		chain->restore_rule = esw_add_restore_rule(esw, chain->id);
 		if (IS_ERR(chain->restore_rule)) {
 			err = PTR_ERR(chain->restore_rule);
@@ -253,7 +253,7 @@ create_chain_restore(struct fs_chain *chain)
 		 * since we write the metadata to reg_b
 		 * that is passed to SW directly.
 		 */
-		chain_to_reg = NIC_CHAIN_TO_REG;
+		mapped_obj_to_reg = NIC_MAPPED_OBJ_TO_REG;
 	} else {
 		err = -EINVAL;
 		goto err_rule;
@@ -261,12 +261,12 @@ create_chain_restore(struct fs_chain *chain)
 
 	MLX5_SET(set_action_in, modact, action_type, MLX5_ACTION_TYPE_SET);
 	MLX5_SET(set_action_in, modact, field,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mfield);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mfield);
 	MLX5_SET(set_action_in, modact, offset,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].moffset);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].moffset);
 	MLX5_SET(set_action_in, modact, length,
-		 mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen == 32 ?
-		 0 : mlx5e_tc_attr_to_reg_mappings[chain_to_reg].mlen);
+		 mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mlen == 32 ?
+		 0 : mlx5e_tc_attr_to_reg_mappings[mapped_obj_to_reg].mlen);
 	MLX5_SET(set_action_in, modact, data, chain->id);
 	mod_hdr = mlx5_modify_header_alloc(chains->dev, chains->ns,
 					   1, modact);
-- 
2.30.1

