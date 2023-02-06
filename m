Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3A7D68C1FC
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjBFPnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:43:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbjBFPnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:43:02 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8BF13530
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:42:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG0vki5WQSe3lMRUGhZ/UI73Ld4NI1qhkMrymOO/ichr8+J/kNteTt2AtW7qHeHaf2nkkxtebj9eU4hVs608FyINz5Mr4TRHihHVsq/tIb966eQS6BuWQgkuKkyGcRIeBMq6OH18ATapojfgAB1uplNvc/joMyKNz27RjqQAYwdYYgjYep8FIRcb9ut+N0q1bE7by0qCKwbbH8OED7ne8E3sQSEh50tOD5ka0FPN6iFk13wjBxF7xuw+/THSXkFwxmSDMV1pIWy+Ak2p1IRIVjCF2DMWcgQ5mKNBMWycV+hi1VtBFl16EabgdlclmqUvEdH6SOGStQAdkye66IUMKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0UV0UVnJVl5w589HDatB+rz/2Ufkl70mRP7khh2smtM=;
 b=h9pz5wbPbCB5p/6tPlC+tvloMKjEph3G4sPt3fo3ZyexQqtlRLo5IG836npfzjRxqu7T25RpNz1tbvlp+Y8sipiaoT/L8e1jwc3Mt1FzREC4SGY/HPPJBMIaJmHraoEwVh9SkkxDev/fLMxQPJh4eAKyXHIzXTZwjFYMQoQAi1G/ptSaWhxn9nKhLTx9U2GB0OLWVg0o4zgscpdT2LxTn4j7sOpYD18RfESJryu4zkjHlSf5/0L+Mw6YjWmtC4o5FzbYPqQpBJpj15YFzsKc1EGkSZX0tPKbANQuV18eZUaMyS1Y+mjmXNvm/dO/juzoLm7ERBRSuaM4CE+gMTVyDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0UV0UVnJVl5w589HDatB+rz/2Ufkl70mRP7khh2smtM=;
 b=Vvx3izOSV7l2+kY7v8aHTXst09ba7suu0bpyMFgpx3PeyL/udC6HpoNAH1WkNjHgN8bw6aRL1PorzmIlouic6PZnJxF2jZZtjq1k2GZRv/r2PHJdtKZTHmIG0REeSV8BV1CQn9v2BrhCvasqGl6zjoZ0q5/FeaEGSw5ilamt2SxPyW0WE4GUu1DxVLRa69UXGhD2BdEgexdpbxEmy6R0NKZr2Tf4wzJzvM3OHO3H+jZa73OUN3sDdkkrjyWBLDBmHyziksIqU2BTz78JxSqpDYxelINIjD3Z0Kq608CwsIVpTw9g3JTa7f8btdOwrJ/Y14Ug90LSqCxUKq43ZI6tTw==
Received: from BN9PR03CA0129.namprd03.prod.outlook.com (2603:10b6:408:fe::14)
 by CH2PR12MB4277.namprd12.prod.outlook.com (2603:10b6:610:ae::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34; Mon, 6 Feb
 2023 15:40:04 +0000
Received: from BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::4d) by BN9PR03CA0129.outlook.office365.com
 (2603:10b6:408:fe::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:40:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT069.mail.protection.outlook.com (10.13.176.152) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.35 via Frontend Transport; Mon, 6 Feb 2023 15:40:04 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:56 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:53 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 4/6] mlxsw: spectrum_acl_tcam: Reorder functions to avoid forward declarations
Date:   Mon, 6 Feb 2023 16:39:21 +0100
Message-ID: <1ebd853d776fc56742cb79da4a39ddf4c3e67e9f.1675692666.git.petrm@nvidia.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <cover.1675692666.git.petrm@nvidia.com>
References: <cover.1675692666.git.petrm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT069:EE_|CH2PR12MB4277:EE_
X-MS-Office365-Filtering-Correlation-Id: 28dd8a4d-67f1-4b92-1130-08db08586aee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m/XMnktj6hzgrgmIMb1te0hCec4mp41Ndcj/LtX6LU/0l/TDqdIxKowgWhOboxn40UYeTDUwcD0ts96Qa55wG3Fi6d+lIvpzL9zHirJfuW7CBaxxyT69R+eOYqJfyhCnwSYwIIyO6syhZqYvurhPS3pgU9yNT8hcUOlCxOFHJMjK+0KxMuZq1Hf4UF6BYMaa1v4Shkj5rpV+0qDes9/Mjv8iXuQCjthgDDBVXdOPuLaElDuKieCravEQfColzsLqEJtC+/OnwQS4MRa8sUhlfsk9A/WnmRph2FT0WO95sAlG8r9tXLpk888LdYlB4fTC7bbB1sI052Xjct+QV4W8rC8wHyOkm0O7vnGARHM+dYIaoMvxM8kFY/QIdDFf7uVbdjKdvTR7hL1PksB7ag7AHg8rx4W4cJ8zcgqdsYFfkRlqaKq1UJJtusbLbcYPuUBYKTDF+KD4UwhmLbIAszpF242RverK1kuvDAmwZnuAQ0l9TJKKsJvhEh+KNs70XmC88LwgGUNH2HsWgTOP7zbYRxH5Og0fp086hpXqetas4b8SVyV/SE5oQOdOXS0fc+H3+/hvtqnwMA8rwnHLqiMuFEiWweRf0HgShyV6iJW0LVQEZ47AW57xKR8EbU0cxsKSgZN+3mpVfCB/sfdnp9xZYxwQk0HQBp3LFU0rG1y4qq3sfEtiHVLv8oQGBE+DoBzPqGqjLSdi1Ol0QPVqOcBjaQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(82310400005)(47076005)(36756003)(40460700003)(356005)(7636003)(40480700001)(86362001)(26005)(82740400003)(36860700001)(2616005)(478600001)(426003)(186003)(16526019)(83380400001)(336012)(8676002)(107886003)(6666004)(54906003)(316002)(4326008)(70206006)(41300700001)(70586007)(8936002)(110136005)(5660300002)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:40:04.5157
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28dd8a4d-67f1-4b92-1130-08db08586aee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT069.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4277
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Move the initialization and de-initialization code further below in
order to avoid forward declarations in the next patch. No functional
changes.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 130 +++++++++---------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index 2445957355cd..dbc2f834f859 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -29,71 +29,6 @@ size_t mlxsw_sp_acl_tcam_priv_size(struct mlxsw_sp *mlxsw_sp)
 #define MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_MIN 3000 /* ms */
 #define MLXSW_SP_ACL_TCAM_VREGION_REHASH_CREDITS 100 /* number of entries */
 
-int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
-			   struct mlxsw_sp_acl_tcam *tcam)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-	u64 max_tcam_regions;
-	u64 max_regions;
-	u64 max_groups;
-	int err;
-
-	mutex_init(&tcam->lock);
-	tcam->vregion_rehash_intrvl =
-			MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_DFLT;
-	INIT_LIST_HEAD(&tcam->vregion_list);
-
-	max_tcam_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-					      ACL_MAX_TCAM_REGIONS);
-	max_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_REGIONS);
-
-	/* Use 1:1 mapping between ACL region and TCAM region */
-	if (max_tcam_regions < max_regions)
-		max_regions = max_tcam_regions;
-
-	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
-	if (!tcam->used_regions) {
-		err = -ENOMEM;
-		goto err_alloc_used_regions;
-	}
-	tcam->max_regions = max_regions;
-
-	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
-	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
-	if (!tcam->used_groups) {
-		err = -ENOMEM;
-		goto err_alloc_used_groups;
-	}
-	tcam->max_groups = max_groups;
-	tcam->max_group_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
-						 ACL_MAX_GROUP_SIZE);
-
-	err = ops->init(mlxsw_sp, tcam->priv, tcam);
-	if (err)
-		goto err_tcam_init;
-
-	return 0;
-
-err_tcam_init:
-	bitmap_free(tcam->used_groups);
-err_alloc_used_groups:
-	bitmap_free(tcam->used_regions);
-err_alloc_used_regions:
-	mutex_destroy(&tcam->lock);
-	return err;
-}
-
-void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
-			    struct mlxsw_sp_acl_tcam *tcam)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-
-	ops->fini(mlxsw_sp, tcam->priv);
-	bitmap_free(tcam->used_groups);
-	bitmap_free(tcam->used_regions);
-	mutex_destroy(&tcam->lock);
-}
-
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_rule_info *rulei,
 				   u32 *priority, bool fillup_priority)
@@ -1546,6 +1481,71 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_acl_tcam_vregion_rehash_end(mlxsw_sp, vregion, ctx);
 }
 
+int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
+			   struct mlxsw_sp_acl_tcam *tcam)
+{
+	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
+	u64 max_tcam_regions;
+	u64 max_regions;
+	u64 max_groups;
+	int err;
+
+	mutex_init(&tcam->lock);
+	tcam->vregion_rehash_intrvl =
+			MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_DFLT;
+	INIT_LIST_HEAD(&tcam->vregion_list);
+
+	max_tcam_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+					      ACL_MAX_TCAM_REGIONS);
+	max_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_REGIONS);
+
+	/* Use 1:1 mapping between ACL region and TCAM region */
+	if (max_tcam_regions < max_regions)
+		max_regions = max_tcam_regions;
+
+	tcam->used_regions = bitmap_zalloc(max_regions, GFP_KERNEL);
+	if (!tcam->used_regions) {
+		err = -ENOMEM;
+		goto err_alloc_used_regions;
+	}
+	tcam->max_regions = max_regions;
+
+	max_groups = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_GROUPS);
+	tcam->used_groups = bitmap_zalloc(max_groups, GFP_KERNEL);
+	if (!tcam->used_groups) {
+		err = -ENOMEM;
+		goto err_alloc_used_groups;
+	}
+	tcam->max_groups = max_groups;
+	tcam->max_group_size = MLXSW_CORE_RES_GET(mlxsw_sp->core,
+						  ACL_MAX_GROUP_SIZE);
+
+	err = ops->init(mlxsw_sp, tcam->priv, tcam);
+	if (err)
+		goto err_tcam_init;
+
+	return 0;
+
+err_tcam_init:
+	bitmap_free(tcam->used_groups);
+err_alloc_used_groups:
+	bitmap_free(tcam->used_regions);
+err_alloc_used_regions:
+	mutex_destroy(&tcam->lock);
+	return err;
+}
+
+void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
+			    struct mlxsw_sp_acl_tcam *tcam)
+{
+	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
+
+	ops->fini(mlxsw_sp, tcam->priv);
+	bitmap_free(tcam->used_groups);
+	bitmap_free(tcam->used_regions);
+	mutex_destroy(&tcam->lock);
+}
+
 static const enum mlxsw_afk_element mlxsw_sp_acl_tcam_pattern_ipv4[] = {
 	MLXSW_AFK_ELEMENT_SRC_SYS_PORT,
 	MLXSW_AFK_ELEMENT_DMAC_32_47,
-- 
2.39.0

