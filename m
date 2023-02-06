Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECCF868C509
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230090AbjBFRox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 12:44:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBFRow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 12:44:52 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2063.outbound.protection.outlook.com [40.107.94.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B412DE4D
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 09:44:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqsd8X+QTdGNT8u49L+qh0C8Lnw62cfRdWwnuxabeWj4L4WG5E6C3gXNNbmmVyKGdHfcB8s+Uue6fWL7zVuUWtZ9YJVPYZ3F3NSr/tCPMhak+yhlG0BNFwZLFIjH2ZMc3PiB0LbglOtM2szyLz23//Q1GuSOd3jS1VKOteymrwKbOuCozVBq3wWQiE7cKMORCCF/6q/Hz8ZYVm1z8grOdXfqy7gfhMUH9mKyu22Wto9Sr9eToKpzsfgo9/rDYodWDk6Cvt+gyZyzhb7tYwDGu1zIaOZFTVpr2jiRcCQ7nxo8oGYQEoG2COrqcmugO95MjIcw/QONSiaku7WpBI9MrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c7O8kFJOb6sksELcbx4p78T0fgKxi9uFaNBzTe2yOrY=;
 b=NzioNgyUxsQ2c8iCFppRUqktEWCK288/6c4q+3OemoM4/LECbDCjz2DgRwcykY0ARPDbUng+JWiilntCkHkqv8RWBKlz1L7r3PQsnJW8QjgVELBYz17OtdNPr10Y+DH1dz1NWnXH5YF1JID4Oei5MB+ku2MR582DFM4RQ6A3Qbf0Yyg/jFD/BPRxodWq5CDRkLOnh1C4cFfyvlSeQkNelgnxBKl0kjvfNO6vXyAG2svZT1jdXLgRxvDrzSQqrKzk+y8a/yll5QiKjEdIAp6qjRlvF4oN4HfAaoc88ul0iO5Z1l+Rw41dY0WPm63f8bNgQ1d6JxjRtUg7IPkQn4LmbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c7O8kFJOb6sksELcbx4p78T0fgKxi9uFaNBzTe2yOrY=;
 b=G1Yk7/BgYJ8lbTy+pFLOLRiWha202q/sA48eal2AmyFCQbZBVfid9sdQTMNc+6Uf4la+MdHyFshjT27X/KIHgrXt7kfsb/9MZI0Xb3TScZDYdDehvGWlVFHoyqbrgAgti6hFRg1hb5urNLOu1fZnzMB/F8XBC5qXlPAL1g3M85g+OjeKPCzoLyV+HGopTjt7aw5lQABwJplm1jG+aXM7/lTQrsIUT0ifM2l0sguxP9JNsojLII2WDCX3BwFJuPyx4+LMpXl7QZj5O6aUPwancsJVNSOwo/ZzmKAxOCwOrycgQOayfzeQo2cwijcSbTuVqPs0duCqBaMAuWdq41QM+A==
Received: from DM5PR07CA0065.namprd07.prod.outlook.com (2603:10b6:4:ad::30) by
 MN2PR12MB4344.namprd12.prod.outlook.com (2603:10b6:208:26e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 17:44:39 +0000
Received: from DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
 (2603:10b6:4:ad:cafe::e1) by DM5PR07CA0065.outlook.office365.com
 (2603:10b6:4:ad::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 17:44:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 DM6NAM11FT091.mail.protection.outlook.com (10.13.173.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 17:44:39 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 09:44:31 -0800
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Mon, 6 Feb 2023 09:44:30 -0800
Received: from reg-r-vrt-019-180.mtr.labs.mlnx (10.127.8.11) by
 mail.nvidia.com (10.126.190.180) with Microsoft SMTP Server id 15.2.986.36
 via Frontend Transport; Mon, 6 Feb 2023 09:44:27 -0800
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
Subject: [PATCH net-next v9 6/7] net/mlx5e: Rename CHAIN_TO_REG to MAPPED_OBJ_TO_REG
Date:   Mon, 6 Feb 2023 19:44:02 +0200
Message-ID: <20230206174403.32733-7-paulb@nvidia.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230206174403.32733-1-paulb@nvidia.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT091:EE_|MN2PR12MB4344:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c2dc592-7eef-488c-1abc-08db0869d27d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MHKPxXM65pfFl0WeakaqJli4LSoBq+HiXy/cIhqC7Cyy3dqiaAz94DTjilxXodiO8K31svizSCGmbOMsrUjCicmt6/PMiyzpawPWW/mXp8/6P2khbqdxPgai6uAhBM5qsQ21buM1J9Ss6HubGSPOE7EkVNFzf5iUG13h225W600pwfJK6ImVN9P83UXFaC/MyDWbNKRXrCbxDvuCG+OMQQtYh48vCLMmLjNHFwzTrB8Fm4ykVpsvTjZ/ZdMWQ8OqprI28m63EiNRVxFJZwM/balnHiowgJ/TRF94vhXT7WD8FSxp06HlqJS3Kn0TVBQhO6R7pb8dTBTBUZQQa/ksISBFC88yxbPA5RsOuZj4DMjVH0Bln3JtR2StT3mEPWbiaL2iJH+YbCK6PDcOoOXe82Uy1nIRJONly5da8yy4N0IlIrdZGhiPC1tqe7jghlFA3Rk9+q/3KALDhubpoYOtqCyARAmtcjO2ug/cGT/Zf2sO9nmjwbyYFuO15RRGfe1CQVGGrdXYYMWgmKWLx3PLTV/rbbBDWqfwH3uQYlWJA8cT/HaT/sASVtToat7EZa2eRZLFzXzmUmfmpjH5+VFDp9aKuxU3Vwucu5CUDF90bJCuIfctmL+3zezxC1N2rptthNDbRH14lNd6+nlfD8uHEYsxvIrfM7DGgh8VqPnxxs8QOlefF1c7PGrc4TMTDCQuhPffIJ+qhOyUM17Uc/+8QA==
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(136003)(376002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(316002)(54906003)(8676002)(5660300002)(70206006)(4326008)(70586007)(7636003)(110136005)(41300700001)(36756003)(82740400003)(356005)(86362001)(36860700001)(82310400005)(1076003)(6666004)(26005)(186003)(107886003)(83380400001)(40460700003)(426003)(336012)(2906002)(8936002)(40480700001)(2616005)(478600001)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 17:44:39.7341
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c2dc592-7eef-488c-1abc-08db0869d27d
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT091.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4344
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

