Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D644758315D
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242668AbiG0R76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 13:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242661AbiG0R7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:34 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2061.outbound.protection.outlook.com [40.107.100.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA2034D155
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nGPGz2Y91bnfdyO8srWVzAOujbjdApFW6NnI41YftvahZqMOnj3e0ufz4J6Sj8wAUwOGBBhKR1WTOjEI5i2xqs6r8VxYQD4yjoTpCPci2Plv3myEajATeHY5G8UupyUhs9di0xeFPeGIk/Haw0Voqnl3DsD/6p8/1VNyFaN6/yUPBhD2Iy02n5oBYx2CDIUzzLtCIltF6klLOsEQdAeD+23dWIYGo05A29g9UYElQ/M1Awk1CPQ2tl9R3xn/gOKq/qzeYS5aSov3fDckSVr1lA1fBO/iZcTvF2ceWM0u5qr3RQPu4fcsZUmRG6s6vndc4S2Hbbn23hs6NU5OuRPH/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rBd3BcZj08RceBhH3bji32iNEFiFZ7UoVVwv8ZHjr6s=;
 b=iePe4KbUm2fNFT8AB61pyloSEgDlPwETZ9lgKdp1sA9pe8FMlU4VsSyX0tt2c/PGXUdfimD8/eEwfkdwrWttnC3qlxaBigcFvTW1Vgz8yUMs3yNnSaoHr4CxJjlcv0JbDwv79mkGyv5+ts1UdHMDzhJ9YtwgaQBkZdBCDwoC/pNDBbK0vFkAyBWy3V4ZvYj0y+H1uwMbXu7PwFU3v0JarwMUAEaSTh0dyG31GAlBQWKoE5IVUH6QqdjfJyH+vww3pkbSiuk3Gi8F6hIBhOm3Xz37cNCLD8f3VHw7L9QYbO0lh3uHSLIi2UAEhn33XRJGSlA71AeEhTacEPK192NyqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rBd3BcZj08RceBhH3bji32iNEFiFZ7UoVVwv8ZHjr6s=;
 b=DkRBLTAVtqEiLVPbk3eUM3p1ZBHaY7lMSuFm0G0SGQGHm97Vg+dgPmdMm6pM1j3IB0RmOJ2+MoftQljr556jjcnLU/Qn2DAdPVx6l9UN+mu612bTmQ9NTlmvps4ENbQdi5c8LNtNAp4xxRA1YEaubSPQgeerG1PIkj8eS0lKya+egilWIBlJyd+zouhqGX3Q0R6F28qfj21YKNRyzJIXadC9JfMF9+cpO1Ant3vlfaBVk/cLRVOcQimCqJLLjy7MU0jXNqNG7yZLrL7xqKqR/hYBbtT8V6g3FjvPIhdUEECmtUKPx0PbznCFxlFgo7qGRQT6GfQL2brhKI7lXnnoYA==
Received: from BN9PR03CA0151.namprd03.prod.outlook.com (2603:10b6:408:f4::6)
 by BL0PR12MB4866.namprd12.prod.outlook.com (2603:10b6:208:1cf::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Wed, 27 Jul
 2022 17:04:20 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::61) by BN9PR03CA0151.outlook.office365.com
 (2603:10b6:408:f4::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:19 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:19 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:18 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:16 -0700
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
Subject: [PATCH net-next 5/9] net/mlx4: Use devl_ API for devlink region create / destroy
Date:   Wed, 27 Jul 2022 20:03:32 +0300
Message-ID: <1658941416-74393-6-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a2a7e9b-962b-409e-19b0-08da6ff20c13
X-MS-TrafficTypeDiagnostic: BL0PR12MB4866:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /VlfNDpnxIKYpU3q4H7IEvwqbBtuyfjfFzNsoVPHuI4edY/uC104g7rYuDOZAGZ88mTrNhVeKZ3G+vP5McLTR7NcG4MN5h3E05YuX5gbxERtbpTImFHORc0y29dnsl2fBMeZspk4RLLQWckPlu6TFnL5e+I7oNvHrCYzD57g39lyv4s7mF+MWmFsE2oRPNLUhw7Nrr3YrmBCw9rzIgD9s52Rs4ZU8ZU34BNPOj8rp8Cj18erZFGVHFpy/J11ZMKDUtxy8I4PhmZl1ja9v5kylinycnTUcQyVJoqWzEUdsvqlC37m1YrCuT/t6/njd4DU0BF8y29DKxsxfUJ5vBm1+q9g+4f4CbE36tCNDaRSJeHkd1I17NFs1wFIrwwpWpZmzd7s/W6OPKQxQwQtOw8ts2oXKNBOt1Hx+mPyAVx9aytqPLqLGLrW2mcuzt47QybRPQ5ybNGWln/94B9iwxZUzjh+Jyb+0dLO7cEuaOkES60DMiiD/eN8Mr0KyN+62tiFmxyVpn22h3w1ULFROBvZRab30zRizC/G6B+ZjDCMvpt4Fa8QxW4LZ7C3M9kpqokssZYbyqr9f6fssZpFYzBRkI2C+DxEl5YHlSLg2eQ5ZgPaY+Uqy0IF28/58qFW4TiY7haGKnoYSEUc1xB1+6kxoemsZUgUXehirqgrIks2+l72ss8ZZHKw8FWjKheyuKOjnMUEMmzjq/qoe31arCida1xFlSGt+FruQl4Gj/Ugdw84bUGbSDYU+BchGF1bxlRzkCyGYh/2BWdeKZCwvU7bX+xpVrbnCA0MkI5A/jis4wqv1+9RklAMernBlF9HDWTzsPdGxwLyt3LpgJjfy/H7uQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(136003)(346002)(39860400002)(40470700004)(46966006)(36840700001)(86362001)(36860700001)(2906002)(82740400003)(26005)(356005)(81166007)(478600001)(40460700003)(82310400005)(8676002)(70586007)(70206006)(40480700001)(316002)(4326008)(54906003)(336012)(426003)(47076005)(8936002)(5660300002)(83380400001)(186003)(6666004)(110136005)(7696005)(41300700001)(2616005)(107886003)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:19.9974
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a2a7e9b-962b-409e-19b0-08da6ff20c13
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4866
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

