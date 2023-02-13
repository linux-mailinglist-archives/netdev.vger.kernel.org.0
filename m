Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3AD9694F09
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjBMSQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjBMSQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:16:38 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49DCD469B
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:16:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hUIo8F5YexbMUkpDmj6Uf6vexjL9JsmVsXv1NgvwkZTVEsMzsoUwK2OMU87zjrpwb43nEZR94QYT0B/gRsH7qGevPpiuSgVpw8l3PikTpCxx3SIM1dvb/HCk42TUdwlK0f/SSvgfWcl0TYH+cSogcZNo4dPEUXmDFvtjR5aXDEQO9YEKZ/Ax9PUm8exPd/euXhsepWEYRBdtey7+KaaY8b1W0dPK/8DjCmhm7FtFDSkh2Nkg/7YQQ3KgjudwxtzXZPfNlWN31FmQByh4XmdMD/BW0QMOWoaK+sqGdjtDZVgVBm0DlL/9+dPV6ZCmqvvatFuTkDP9HaYSQ7njaLmKWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=am9whSCsnVgF7COm+Kj32LxOnoN3HJiUEIpVbxhjqn4=;
 b=h+roj/PryLMA3SZG1iPb50kISQng6F3f6p9I0KjFiOPT2Yvz5XHnL8J2SZSTbGFQ2XDkW2dQ4hzVghnp2j7gbR5wD4XQe/6yfR2APR2WNgs8Y7D45DLvB5TdJw1H0Zn9sPFeYcNt1zkOaHv6j2PU5ULkDC6ifTtPJ2pfw3nOmjGZpf4yy7lHN48E8AFm9t3w5Mn/OJjuq7swYhU3oPO+stAGNlkQKw1tSIxhYHHHRisfzCav68uKi14YqYSXSxCAyUiRAkBnvKyVrSA6N4HanggSwoswSJdwVF5j2kAevxaBfI5sUFdMZTunWkJ1u51+bHBwYiKap8kNOJa9Hl1Jiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=am9whSCsnVgF7COm+Kj32LxOnoN3HJiUEIpVbxhjqn4=;
 b=M4SWOtxYd1v7fS7IGzYzmWHRUKKeca8xk8+mt2f2SS8Op6xG72DGYhrHr6rghCDbi5itcogvtSkIzdJ0c96IPywHWTgfYCv1Cw6LcEw0/7ka3f0mV92ZWviWhBasopy9lJr1+T6B+BzInYX12Tb5c3aCU2/gt855XooXgibncFUfrgSD54H1Ti4rizFpdpAD357xEcJulvoIg02tJbLPz9fHb5s/XlDcPi9IoXbhTxDQWf4RulNv835IyZjufPm6l/in1Rx5NWtEUFpJJD22DdjB+MZ76Rn08szCHsLJgsvhW+YwgP58pxvnIMBSELZMt2ZmJxbwrnab7agQ9xCuDw==
Received: from DM6PR13CA0057.namprd13.prod.outlook.com (2603:10b6:5:134::34)
 by MN0PR12MB5860.namprd12.prod.outlook.com (2603:10b6:208:37b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:16:28 +0000
Received: from DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:134:cafe::96) by DM6PR13CA0057.outlook.office365.com
 (2603:10b6:5:134::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.10 via Frontend
 Transport; Mon, 13 Feb 2023 18:16:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT103.mail.protection.outlook.com (10.13.172.75) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:16:27 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:17 -0800
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 13 Feb
 2023 10:16:17 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.129.68.8) with Microsoft SMTP Server id 15.2.986.36 via
 Frontend Transport; Mon, 13 Feb 2023 10:16:13 -0800
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
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next v10 6/7] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
Date:   Mon, 13 Feb 2023 20:15:40 +0200
Message-ID: <20230213181541.26114-7-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230213181541.26114-1-paulb@nvidia.com>
References: <20230213181541.26114-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT103:EE_|MN0PR12MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aaaf3d2-021a-47eb-1752-08db0dee6ca8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6AFdKtBUXTXejpKHa538smqT2zBeR2MqMEU8JMNEThzFYpEYN1J1XnHMfXHLxImwX6o2ffZ9ieVW0BtQYVG/ommwYYAJNesesdAy2QvbGkvxs63hwmmCwJTSVDMjxEl/EzyeA8YKs4UY6hB33TQspTkuacV9yPlmUmLYJSTlQbFnw3aYTVv+6ffXPSZ/33FjThI/eHiz0FGvCdn72P7JXhade/uuAcU8vunjSUZnIqO7e8SM8xGvBjG+g+Mv+L/O6G4S8LbPhmQBA6ys8gxR0SNH3ZXJd42WvcpZRJ16onBxMil3rhBdxqV13fr/mhxrIX3ft9f6VIhwYKnczvdDK0RwPTK6qYE3lLjfGgKi3OAoxoJK+YrOxkw1/86AhNbci8BpampZNd0wmpoSrBj4o7gE53FtMxGU+VZe8RRw2hauXC/mczVIIitibPFloRhXanwraZaw5lmpVR2RBd8B/X85v8hMkN6rqZISyuC7jdkJNrAVN6H/tqtXEYmfgW5kTwtv5PCkGZjhp5PKFalpOtNj9OruIGaQ9pGf7GfvjkhIii+lZJ3irIM4fTJiWJ08QSV9GaJfUs2E/ulYWKt8Xg/DarlHuCzxX1V38CX8GgIhoB9oIUj53tfl9h52hK9bBDbft4NDmywzz0JEYhk6o9Xprt8eTT0mP5XLFMNVKYakZJ+9eNgmIJNvgVH0NeyYib/fVjPfmTwATPKQ4L/zr10GYWX7R6nv0zla+j/YDU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(396003)(39860400002)(136003)(451199018)(40470700004)(46966006)(36840700001)(8936002)(36860700001)(1076003)(4326008)(5660300002)(41300700001)(36756003)(70206006)(40460700003)(70586007)(8676002)(86362001)(40480700001)(356005)(921005)(478600001)(47076005)(336012)(426003)(2616005)(107886003)(2906002)(82740400003)(7636003)(316002)(6666004)(26005)(110136005)(82310400005)(54906003)(83380400001)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:16:27.7827
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aaaf3d2-021a-47eb-1752-08db0dee6ca8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5860
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
index 76cda5e9180e..ff0a0220cd46 100644
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
@@ -1583,7 +1583,7 @@ mlx5e_tc_offload_to_slow_path(struct mlx5_eswitch *esw,
 		goto err_get_chain;
 
 	err = mlx5e_tc_match_to_reg_set(esw->dev, &mod_acts, MLX5_FLOW_NAMESPACE_FDB,
-					CHAIN_TO_REG, chain_mapping);
+					MAPPED_OBJ_TO_REG, chain_mapping);
 	if (err)
 		goto err_reg_set;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.h
index 1c52c8915c3a..680333ab63fc 100644
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

