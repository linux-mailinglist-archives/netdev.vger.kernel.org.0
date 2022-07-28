Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4F705843A5
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbiG1Pys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiG1Pyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:39 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2067.outbound.protection.outlook.com [40.107.95.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5604F6D2DC
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bkb9wBXor+Ag5P9D8lQTdxpPS9wTeXo5eOhTF7eHei7C28zwJe2M10jTIQC53ETV3FutCE8S3nkxC1y//XJmY05x0PUniR8fXdPqPyTkOX/j1g6LiAkRXSKfR+nlDWaz/IMNL9kx8xhn78g5D39h53eBzCy5XBrrKrjrgB/jkLOoMRg0dj8/0ZniMSySJ/0+mE3apAfKDWjdMR68yOz+8+66wgokrvTuqRZwme0jQ0J8PutCa+ZhKAKxOJC0cg1Qv/A7BDBSmFIMbB1nKKJa0Oby2afHc0aanIltaLMP+ZzpHBpx2fYxvbT7QNj7y0snWFFKJmE49heb5KSAPDidqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBd3BcZj08RceBhH3bji32iNEFiFZ7UoVVwv8ZHjr6s=;
 b=MXoZ0bdVtEijqw0TiWxwxmRq0JpJda99gXSQbW/lCpu1JsNCeBQe8B3039v72pwaWFRREsN+IwDltCcjkv/UR4x+rMpDVXyugcJgtCFUIUGF7ZEg+EqmOZbMOhW9W/cg5iRIuwdpnmvshDz2Pn/rMx9x2FYmmE+WBXhRgLk4riP51jGCZAkpqYV8FNOUCdX9cGsnrpOQwQsT6RxD6Eye8PbJe6OiuQXx+mJ6CqMB5bsGQSAq9TjkY8noIN1ZDmHXAYtE6FqzvIyCdAZdO/r2MBtlYwjseI6fbmOpJlvETHvLp2FXl5KMUKPaVOGz+1AjE6FhG4E3k+zo2a17jhXyog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBd3BcZj08RceBhH3bji32iNEFiFZ7UoVVwv8ZHjr6s=;
 b=HcniUUFpnTeuM4Jr/TPyj/mpmAQ1Ad5o99noZ5PQz1ZzbcfNoaWTp1dSgf55rWjh/BQ2BybMAAOrj/Ti/HlpGKd3A2X7gzXGYBYr3/2Gka1YMLBIFCZtxgEU1VJRJWoQo7qiXbJpxswYJYhFOUckqGF+COCZOQrrohbec6tbpigsAutysUs2bBcHkE6cfDs/iKsdBkku+eB5rN8CqFd/cGK6YqgCyGRzwFP8lKu1vxCdrhVXU8ptw0kKqaBOc9D83w74qNs/wyFI3L2wNiHM7LLY6NVwS8IorVuN1pcVrm6lFCyFPrQ57XnjQ85LuT4QyNyQaMFKuaMN7ybHKyV0sA==
Received: from DS7PR05CA0060.namprd05.prod.outlook.com (2603:10b6:8:2f::13) by
 LV2PR12MB5967.namprd12.prod.outlook.com (2603:10b6:408:170::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 15:54:36 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2f:cafe::d) by DS7PR05CA0060.outlook.office365.com
 (2603:10b6:8:2f::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.1 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL107.nvidia.com (10.27.9.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:35 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:35 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:32 -0700
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Tariq Toukan" <tariqt@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>
Subject: [PATCH net-next v2 5/9] net/mlx4: Use devl_ API for devlink region create / destroy
Date:   Thu, 28 Jul 2022 18:53:46 +0300
Message-ID: <1659023630-32006-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f031e1ad-31a2-478d-fe61-08da70b178bc
X-MS-TrafficTypeDiagnostic: LV2PR12MB5967:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NzAB0iBNz2w+8l4JbL78UQPzN5I7C8vBk9S5uUIagDh+O6taGnEguYCBeKVmByCwN58eKfD12MsvM1EUJMW5Yx4QIAzvFlP7qqyW+sp0y2VuG9RKhKkyfMyL98PS5tF2WJY3U1IML5qdnhI7tY8qCKSoEQ5FPtopjfMzwQzsdadb3gTDjkIJJAHasxOby5aixD/GzR9j2B5lthrUCc6s7QbrWNAzl24iJ0mQYIZz/DeWZgRnC1U9XSrYvkl5uHvkhHbOU7GyglTutDWm8dF4TQ8r60dJoYU0g7/D8xIlA/mL7x+yPo/l97o0OWhVF9FH4ksTsKYm6yQMsV0g3o1dN912bKJvs4OyMa7n1XY/Jcz7Bt6hnXWXE0/iF0AYTiSddwIxSRMzke3lk1pSGVhBbhBXCNizAGJG71/E2ASspwbhzeO768Ifk+/mEX9U1uHWGGTF7xiPNPe6WO0blFsEVceAGERxqQHXqsOM/QOFgRiB3uW3dgasCmMiElIeTycd08HdIySreCv2WvjSQppmMPL7fShf3pEa3wkz+871UeQWNGKqfTr8Bjtpx0IIeu9OyV6GUtXXvtGObUQHYQs1TC2NyBtXRgWMMl1PFmBNCUFwWVuH8mzEJOLU9cv7lIuDe6LjCkmoA6zLS2NwDMnR8uoZ70mYF1m9sqiSviZGwRd2Ibn2aTX6ZFMiWmVWwWA02sipNbuVt+I5miKVDO2cnO3o2XCLWpmfzFq+RWyLnwzIBIrUgbFRcugGq60wgG2eDrASXzrbk/UZ/ax3jEcN4f+W7TWCfXbp6S4pMvmyTe48sAkVZZslxOm5Ryj10Snnjj4vwVVfW9beZz5h1ZdN8w==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(36840700001)(40470700004)(46966006)(7696005)(107886003)(5660300002)(26005)(186003)(6666004)(2616005)(41300700001)(336012)(40460700003)(2906002)(82310400005)(82740400003)(356005)(83380400001)(81166007)(47076005)(54906003)(36860700001)(40480700001)(426003)(110136005)(86362001)(478600001)(70586007)(36756003)(70206006)(4326008)(8676002)(8936002)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:36.2426
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f031e1ad-31a2-478d-fe61-08da70b178bc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5967
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use devl_ API to call devl_region_create() and devl_region_destroy()
instead of devlink_region_create() and devlink_region_destroy().
Add devlink instance lock in mlx4 driver paths to these functions.

This will be used by the downstream patch to invoke mlx4 devlink reload
callbacks with devlink lock held.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx4/crdump.c | 20 ++++++++++----------
 drivers/net/ethernet/mellanox/mlx4/main.c   |  7 +++++++
 2 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/crdump.c b/drivers/net/ethernet/mellanox/mlx4/crdump.c
index ac5468b77488..82a07a31cde7 100644
--- a/drivers/net/ethernet/mellanox/mlx4/crdump.c
+++ b/drivers/net/ethernet/mellanox/mlx4/crdump.c
@@ -226,10 +226,10 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 
 	/* Create cr-space region */
 	crdump->region_crspace =
-		devlink_region_create(devlink,
-				      &region_cr_space_ops,
-				      MAX_NUM_OF_DUMPS_TO_STORE,
-				      pci_resource_len(pdev, 0));
+		devl_region_create(devlink,
+				   &region_cr_space_ops,
+				   MAX_NUM_OF_DUMPS_TO_STORE,
+				   pci_resource_len(pdev, 0));
 	if (IS_ERR(crdump->region_crspace))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_cr_space_str,
@@ -237,10 +237,10 @@ int mlx4_crdump_init(struct mlx4_dev *dev)
 
 	/* Create fw-health region */
 	crdump->region_fw_health =
-		devlink_region_create(devlink,
-				      &region_fw_health_ops,
-				      MAX_NUM_OF_DUMPS_TO_STORE,
-				      HEALTH_BUFFER_SIZE);
+		devl_region_create(devlink,
+				   &region_fw_health_ops,
+				   MAX_NUM_OF_DUMPS_TO_STORE,
+				   HEALTH_BUFFER_SIZE);
 	if (IS_ERR(crdump->region_fw_health))
 		mlx4_warn(dev, "crdump: create devlink region %s err %ld\n",
 			  region_fw_health_str,
@@ -253,6 +253,6 @@ void mlx4_crdump_end(struct mlx4_dev *dev)
 {
 	struct mlx4_fw_crdump *crdump = &dev->persist->crdump;
 
-	devlink_region_destroy(crdump->region_fw_health);
-	devlink_region_destroy(crdump->region_crspace);
+	devl_region_destroy(crdump->region_fw_health);
+	devl_region_destroy(crdump->region_crspace);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index b187c210d4d6..f3d13190b959 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -3732,6 +3732,7 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	int prb_vf[MLX4_MAX_PORTS + 1] = {0, 0, 0};
 	const int param_map[MLX4_MAX_PORTS + 1][MLX4_MAX_PORTS + 1] = {
 		{2, 0, 0}, {0, 1, 2}, {0, 1, 2} };
+	struct devlink *devlink = priv_to_devlink(priv);
 	unsigned total_vfs = 0;
 	unsigned int i;
 
@@ -3844,7 +3845,9 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 		}
 	}
 
+	devl_lock(devlink);
 	err = mlx4_crdump_init(&priv->dev);
+	devl_unlock(devlink);
 	if (err)
 		goto err_release_regions;
 
@@ -3862,7 +3865,9 @@ static int __mlx4_init_one(struct pci_dev *pdev, int pci_dev_data,
 	mlx4_catas_end(&priv->dev);
 
 err_crdump:
+	devl_lock(devlink);
 	mlx4_crdump_end(&priv->dev);
+	devl_unlock(devlink);
 
 err_release_regions:
 	pci_release_regions(pdev);
@@ -4161,7 +4166,9 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 	else
 		mlx4_info(dev, "%s: interface is down\n", __func__);
 	mlx4_catas_end(dev);
+	devl_lock(devlink);
 	mlx4_crdump_end(dev);
+	devl_unlock(devlink);
 	if (dev->flags & MLX4_FLAG_SRIOV && !active_vfs) {
 		mlx4_warn(dev, "Disabling SR-IOV\n");
 		pci_disable_sriov(pdev);
-- 
2.18.2

