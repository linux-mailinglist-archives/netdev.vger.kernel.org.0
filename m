Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B267B68B0C2
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 16:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjBEPvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 10:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjBEPvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 10:51:23 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 121F71ADF7
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 07:50:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gln5uL72SV12WRNUikVC0jvvgcQZBmEJE4tmxmVj9x0kTW9TT4DEbsuc2HNsRGp+B9rh2Ja2PqMDXYDFTXtC6ySShwAPSxbIf9Wp4BUiPavg2slRBkRcJya2ASJsYWAC9TS5l4s5mPyY2G/eXXtV7OZT9CPvHIQa+78C+OIV4Wo2u0MTrnvEWbjf8qIXSx5dOMEZDWqQiJrRIXbDsul9V/rsAGDEPA4cI2ZNUxVHxW4bNttLHCxwELlCLJ0PBRxNdAa+yvxs1Q8fH/829zy7yv4ZMihIEX7jQ+WMLeVBEzrbB4DOgxckLZh8w35Up0zPWriTKQXS7IVfkUXqX5VWXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZA+9FwFscfdBmB7HUVpb7atPINaO+HeGr6tJV4ePV2s=;
 b=EFlYQK5ikvrmknVu0JvJVsdLgsSPRdZedh+3McMSLG1jXl+bZ8CN0dbUSbsEY/MYfvLi1/iLWWDBhuII16wySCqT/em/QAHHrnfhw0niw9L6/R3gEV3pTw0WPm1rC/lU5QLUK5cLejL07KTQ4fVGsrHos2mGCN4/PribVHpSoyLcO5zqN43AdLRgRPFpRf6eg3rMmduaPIyh2R55AiMYYy2j/wz7fpIw6R83+yw9a7HAsnevKLDm80W312/wbpkrQYuzkVD8hYPoR+NMkuuv2CL8/+MMT5XbSJ+KayyZ8KiyTLALnRqUTaxYoWoQ23kzcR74vt9S+YMYKtAfmmSUyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZA+9FwFscfdBmB7HUVpb7atPINaO+HeGr6tJV4ePV2s=;
 b=ctNyRNar/L++qB6+XAV3idJs+xcvc2hwjuBdTygfc4WdDkAirOOqZo4oLzWEGAhc82MrR8iSSGBJWbVaJolH8bJE60x9+Hov0UMEF/OJ0ixSznkfJG7mVw/W42fh6DRhWOqtzWtlo7SuolquE7LAtl1UhB+1cxKUJ4nhrNGcMHucyYy1nyyi+8vd0cKS97FkOKfO3w85jxM7tybCUqNP1YfZAUaXTrFi/uA0nBpqM0BIbNBzST0+DAmA45VoyqOyk9F2y7jFAQr1/+Ed8panfcSc1eeXReGUmfh8x0EQNauiPZtyClH3Pp+5KTaN89ocDgpIhFnQ6WQfhkZt7lhkbQ==
Received: from BN9PR03CA0427.namprd03.prod.outlook.com (2603:10b6:408:113::12)
 by BL1PR12MB5364.namprd12.prod.outlook.com (2603:10b6:208:314::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Sun, 5 Feb
 2023 15:50:12 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::e) by BN9PR03CA0427.outlook.office365.com
 (2603:10b6:408:113::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Sun, 5 Feb 2023 15:50:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Sun, 5 Feb 2023 15:50:11 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 5 Feb 2023
 07:50:03 -0800
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 5 Feb 2023 07:50:02 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.181) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Sun, 5 Feb 2023 07:49:59 -0800
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
        Roi Dayan <roid@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v8 6/7] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
Date:   Sun, 5 Feb 2023 17:49:33 +0200
Message-ID: <20230205154934.22040-7-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230205154934.22040-1-paulb@nvidia.com>
References: <20230205154934.22040-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|BL1PR12MB5364:EE_
X-MS-Office365-Filtering-Correlation-Id: 06cf53d4-da38-4e80-9a6c-08db0790aa8d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IP6RS1fj4TalU5Ms2I6pbYbMQnhGX58uKQhlV37J1TKIt6BjwpZwzvzdzak+w2GWLvrVtikC2id03ArpV/FNborFfZslh0yP4tJuWGPLX1Hk0iMp2irgXIwKsw3xaQnTPCJgVkMFp6/2KQRla7HO04vNdwxlrpEzHjh89FlUrE7nAcYOr5uN4/590vA8OHmwpVGmBvyv5F0ctg9QqE5zvTmG7RzcNp32VvkVWs97cg07vHn9UByfxNZCVco9sF1ADOd5jqRei/oS9mdb8KXdfX0+ndx8Edb0vQc4XBiCEiG3o7ElsNaxrH9EeafrkfVPiMyseikTDYcd5k9cJiIAOPfSagu2btRMFlJaA+4owqZzOALckQbAZlsc4twcMLNMHpBbIWyf/v67D1MRuXRYqmzcTp6bOAj2YN8f1xPfIzYWwvq48y8URPfR8BPswS0MJpcZFy463tmtDDjEMv/+IUqoTfHohnCzUk6Basr3EyAVBUFJ7U5k40qZb6eJOQoyg4V7XUFDv2nI2WDbqWQxXQslM0BFWLrYswNlleSNBnSWyM8gdWEkCQ8eiR60n4gpTxoa7i/LTFOPhb5dnE8FTh6/xhHYhrpRpZAAoLbqwQHoaXX+pm/R3rkTJkclDOh+6XxQNiWJ3RnzsiOf6n0zIW/1lskkUblJk10e5OcedlFhLKGI7JGHNgc0rbj56XpaWTyof0WFdgHro0r04k5yyQ==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(346002)(376002)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(40460700003)(47076005)(86362001)(110136005)(8676002)(36756003)(336012)(426003)(83380400001)(82310400005)(1076003)(70586007)(186003)(8936002)(36860700001)(478600001)(316002)(54906003)(6666004)(26005)(2616005)(5660300002)(40480700001)(356005)(70206006)(4326008)(82740400003)(7636003)(2906002)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2023 15:50:11.9274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 06cf53d4-da38-4e80-9a6c-08db0790aa8d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5364
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 313df8232db7..e1a2861cc13b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -1871,7 +1871,7 @@ __mlx5_tc_ct_flow_offload(struct mlx5_tc_ct_priv *ct_priv,
 	ct_flow->chain_mapping = chain_mapping;
 
 	err = mlx5e_tc_match_to_reg_set(priv->mdev, pre_mod_acts, ct_priv->ns_type,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err) {
 		ct_dbg("Failed to set chain register mapping");
 		goto err_mapping;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index a6399dc870c2..f0ce1d1ae8ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -105,7 +105,7 @@ struct mlx5e_tc_table {
 };
 
 struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
-	[CHAIN_TO_REG] = {
+	[MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_C_0,
 		.moffset = 0,
 		.mlen = 16,
@@ -132,7 +132,7 @@ struct mlx5e_tc_attr_to_reg_mapping mlx5e_tc_attr_to_reg_mappings[] = {
 	 * into reg_b that is passed to SW since we don't
 	 * jump between steering domains.
 	 */
-	[NIC_CHAIN_TO_REG] = {
+	[NIC_MAPPED_OBJ_TO_REG] = {
 		.mfield = MLX5_ACTION_IN_FIELD_METADATA_REG_B,
 		.moffset = 0,
 		.mlen = 16,
@@ -1585,7 +1585,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 		goto err_get_chain;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err)
 		goto err_reg_set;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 4fa5d4e024cd..eb985f7bdea7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
@@ -229,7 +229,7 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe);
 void mlx5e_tc_reoffload_flows_work(struct work_struct *work);
 
 enum mlx5e_tc_attr_to_reg {
-	CHAIN_TO_REG,
+	MAPPED_OBJ_TO_REG,
 	VPORT_TO_REG,
 	TUNNEL_TO_REG,
 	CTSTATE_TO_REG,
@@ -238,7 +238,7 @@ enum mlx5e_tc_attr_to_reg {
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

