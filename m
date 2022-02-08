Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A1A4ADF12
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351931AbiBHROw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243412AbiBHROu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:14:50 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D7AEC061578;
        Tue,  8 Feb 2022 09:14:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e3msj3EasLbsnWw1EMGBYTYthFHzQRXqvhwfcqhFHN+FVrgpfcoCOXv3MUM4UY5N1XAFb5njnRc6gqSudj8Ty4KOMrXx+0jsChcuqF4630LNqsEbqpntsL/wQgy1DXcqI+GoB39aIsfOiWq1fUfSjW3BTjyWdu5ppKkZWHiJGT7SydxHj7iq8yOsA+vV2SqRtXYEfsoa44gsTXdpDB5efczS0A6qReeK30EPt35Gn3bgKMi3DKQNnA2pOv9u0BnmnbQQQarysoUnjj31PZdnoSBm1F+Jdu/eIoJdP378CnnN/YDekZuBL7lOOJx6YL6kEhNqzVLb/o2vOFYP44Weuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUgTWgtUpSUYxncI0pCBf1y6AddDiImbe/TPYjlutNA=;
 b=Q4cnviFFguQabyzKQAS+42+JAK5Nl04lb1fuVdPCH0cKACqS5xa8PRgwRk1bJaCe59kmGYhR7euC+q34JH4QAbS5OCiom/n1TcJr0snFz+AbHMk7ENCIRz/k/aYYFswYZ0/X7hnRo9D9M2w7CrVRdHjal0t5tS12/WUQKnkZwCVJx2DDIivL69tl8ipUIlY/ZMOUoqnFiRqkNoeBaV1Lb/L+tRzyA6WdlNwZOyn7djWSwC4xNTIaYO64mvnXkPl/ZlNhyDDE+P57su3yh0k+8v1IQJA9YlBSMVANkHUfwLpfCHQHCDUuajZyt3NNtNsYWVHSnrZl8xVTSF3KP9GJrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUgTWgtUpSUYxncI0pCBf1y6AddDiImbe/TPYjlutNA=;
 b=rXCBsGX1O54QGSDKR2g3VleEZwSOBR7yCTZ36g4YQlpKfi1EYJV/aXDpiZmIf+UbvSdsKDodtxegTX9GIpIiDm4FYi8BcORpDSM3yfyXaJZXWo7tR/uKUgao//uCj4u61e546Cq7dkuizaNZJf4HW2t4wvyFavVzsIQ1aEyKv07RA9oJP68JrBRbKoNBXfarhFKCNgNIYZeqAuRIXkKc0ZQUrgrmRVHWj7YmAG9nSRevdhwKKuwAQXFOe/cWalFZx5BhDp8SJrelQ5jNmQ0cRpoCGu91Qm+GSOJnHB9ScNU0Tz80hYJEjvn5KROq++8tnvgtw3bPMshS64QGIF7ylQ==
Received: from MW4PR04CA0121.namprd04.prod.outlook.com (2603:10b6:303:84::6)
 by DM6PR12MB3372.namprd12.prod.outlook.com (2603:10b6:5:11b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Tue, 8 Feb
 2022 17:14:48 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:84:cafe::b5) by MW4PR04CA0121.outlook.office365.com
 (2603:10b6:303:84::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 17:14:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 17:14:48 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 17:14:46 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 09:14:46 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 09:14:44 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 1/4] net/mlx5: Split function_setup() to enable and open functions
Date:   Tue, 8 Feb 2022 19:14:03 +0200
Message-ID: <1644340446-125084-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a9dda311-739f-4e33-9659-08d9eb2682bb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3372:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB33721045A3861DDCADD59285D42D9@DM6PR12MB3372.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h2sckm/09nneVk+vX9Z90tXvodmBRCxa5bm1jyb7HSgx0PJGy9ErbmzijPS3WAt4zdmZBvh1wOnwBGepkTQpqGbp9pgOzTarbX5hc0mBDnfee0tfjh3UhCix9gCUvQLbZ80nf+Uyn5EEvSS9mMojJMNUPBZkO55wMlkrs9wYFcmAdXjlHpIQo8QMfjSQHwk+E6UD7/e3rIs8y82pHshXkV4mGs1faCGe/YMdbcGXRK/RhR8Y+cHVKEShkDwH6BiPE5tcuAKYtByfTU+8sTUYb9YnNHviR3HbazjkLo615IZuL0sk3lTaqQxthWh3TSZqz5mFrSXBUM1CaWkFUoziwvGNdJ2pO72OxABpM58xD+q0mNIGlK5ib6LKnzlavjNpT/HQm0Ty3t2d+4vtEoFi/AqRLQ3QF1uB7ZGEo9F0HgYuOsHIYHxjJXROpdlSgK8nZBl+2PoW9yQQpB1aJXQX16Lx9rze8w2W45SNQhI1Q/fxr+6XfWpHac0i6LXDwbVsVIBakahqXLJlYNusJ/FhYu2S0M2oBrPzRnrAlTVj0SbtYquA7j3xRGymlrbyAPevMy//5inyRnb05YUhBxRijbJjbXpnliufoQKDxUnUmMbsmSaET8Z5TnfhTik8tyUl0+cRl13G5QYoP0+Mi9ZyIEMMewqJ6m4nwgJXsL5XxN1XZ4Ex8Vd2iQEA+MXUH6K6y+Uv2SRUkGSICWA1M7Fidw==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(40460700003)(110136005)(107886003)(336012)(426003)(356005)(5660300002)(81166007)(83380400001)(82310400004)(47076005)(2616005)(26005)(36756003)(186003)(7696005)(508600001)(316002)(54906003)(4326008)(8936002)(8676002)(70586007)(36860700001)(70206006)(2906002)(86362001)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:14:48.3158
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a9dda311-739f-4e33-9659-08d9eb2682bb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3372
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

mlx5_cmd_init_hca() is taking ~0.2 seconds. In case of a user who
desire to disable some of the SF aux devices, and with large scale-1K
SFs for example, this user will waste more than 3 minutes on
mlx5_cmd_init_hca() which isn't needed at this stage.

Therefore, split function_setup() in order to avoid executing
mlx5_cmd_init_hca() in case user disables SFs aux dev via the devlink
param which will be introduced in downstream patch.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 81 +++++++++++++------
 1 file changed, 56 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 2c774f367199..73d2cec01ead 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1006,7 +1006,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_function_enable(struct mlx5_core_dev *dev)
 {
 	int err;
 
@@ -1070,28 +1070,53 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 		goto reclaim_boot_pages;
 	}
 
+	return 0;
+
+reclaim_boot_pages:
+	mlx5_reclaim_startup_pages(dev);
+err_disable_hca:
+	mlx5_core_disable_hca(dev, 0);
+err_cmd_cleanup:
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
+	mlx5_cmd_cleanup(dev);
+
+	return err;
+}
+
+static void mlx5_function_disable(struct mlx5_core_dev *dev)
+{
+	mlx5_reclaim_startup_pages(dev);
+	mlx5_core_disable_hca(dev, 0);
+	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
+	mlx5_cmd_cleanup(dev);
+}
+
+static int mlx5_function_open(struct mlx5_core_dev *dev, bool boot)
+{
+	int err;
+
 	err = set_hca_ctrl(dev);
 	if (err) {
 		mlx5_core_err(dev, "set_hca_ctrl failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = set_hca_cap(dev);
 	if (err) {
 		mlx5_core_err(dev, "set_hca_cap failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = mlx5_satisfy_startup_pages(dev, 0);
 	if (err) {
 		mlx5_core_err(dev, "failed to allocate init pages\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	err = mlx5_cmd_init_hca(dev, sw_owner_id);
 	if (err) {
 		mlx5_core_err(dev, "init hca failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	mlx5_set_driver_version(dev);
@@ -1099,25 +1124,15 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 	err = mlx5_query_hca_caps(dev);
 	if (err) {
 		mlx5_core_err(dev, "query hca failed\n");
-		goto reclaim_boot_pages;
+		return err;
 	}
 
 	mlx5_start_health_poll(dev);
 
 	return 0;
-
-reclaim_boot_pages:
-	mlx5_reclaim_startup_pages(dev);
-err_disable_hca:
-	mlx5_core_disable_hca(dev, 0);
-err_cmd_cleanup:
-	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
-
-	return err;
 }
 
-static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_function_close(struct mlx5_core_dev *dev, bool boot)
 {
 	int err;
 
@@ -1127,14 +1142,30 @@ static int mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
 		mlx5_core_err(dev, "tear_down_hca failed, skip cleanup\n");
 		return err;
 	}
-	mlx5_reclaim_startup_pages(dev);
-	mlx5_core_disable_hca(dev, 0);
-	mlx5_cmd_set_state(dev, MLX5_CMDIF_STATE_DOWN);
-	mlx5_cmd_cleanup(dev);
 
 	return 0;
 }
 
+static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
+{
+	int err;
+
+	err = mlx5_function_enable(dev);
+	if (err)
+		return err;
+
+	err = mlx5_function_open(dev, boot);
+	if (err)
+		mlx5_function_disable(dev);
+	return err;
+}
+
+static void mlx5_function_teardown(struct mlx5_core_dev *dev, bool boot)
+{
+	if (!mlx5_function_close(dev, boot))
+		mlx5_function_disable(dev);
+}
+
 static int mlx5_load(struct mlx5_core_dev *dev)
 {
 	int err;
@@ -1290,7 +1321,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 
 	err = mlx5_function_setup(dev, true);
 	if (err)
-		goto err_function;
+		goto err_function_setup;
 
 	err = mlx5_init_once(dev);
 	if (err) {
@@ -1324,7 +1355,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	mlx5_cleanup_once(dev);
 function_teardown:
 	mlx5_function_teardown(dev, true);
-err_function:
+err_function_setup:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 	mutex_unlock(&dev->intf_state_mutex);
 	return err;
@@ -1366,7 +1397,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev)
 
 	err = mlx5_function_setup(dev, false);
 	if (err)
-		goto err_function;
+		goto err_function_setup;
 
 	err = mlx5_load(dev);
 	if (err)
@@ -1386,7 +1417,7 @@ int mlx5_load_one(struct mlx5_core_dev *dev)
 	mlx5_unload(dev);
 err_load:
 	mlx5_function_teardown(dev, false);
-err_function:
+err_function_setup:
 	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
 out:
 	mutex_unlock(&dev->intf_state_mutex);
-- 
2.26.3

