Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8952D4B2199
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 10:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348497AbiBKJVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 04:21:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234834AbiBKJVE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 04:21:04 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD7A337;
        Fri, 11 Feb 2022 01:21:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TEbxkgZcT0A3HzBYwlJyrBEhy+T9fqjUXYhDwUfM4UF4KVvxp1Y5Vuc7JFy+0olIKeP8lB9pgPQeupS7ufwnNkgexUjcjRNK2txn8p8sGdhHWhxsiF/55HHA9U0gQBDB/Xgcrpwp32WipaTjXOTVayO4hlSiheRdMOll0+FdN9TpYlG0Lv60+xgPJrrKBVJnBdqA2jEuH+3ILf3ShQtF2ojQ8SHMd1UxL4VxZ1Qm90IKUoetA2IaYU5Hh0YP0nFBtuQIoqazG0b43bvDVCt0dLJvGPG1Mtv+GAn5rQGBrNrWxLgeLpb5G2e4p2Zs0hIeZ5j32bh0CZJSoKRn4C/tFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZUgTWgtUpSUYxncI0pCBf1y6AddDiImbe/TPYjlutNA=;
 b=HfQDkJA1fuumMK8JOgJtt/OWock0meOke3AwOnxsXmIW/h2WLftQXxI2xeolZciVS7uaIKDvw4y28OBEkoSbEaFct+tsNh1lGIA8eMufsVHiFcu++IM0LXk46uZ04t+wydPB98YZLyM5Ml49/22AfLvY1gvUGP+xdz8ICXHz3M/WhSu/na6lJapFSzacYBuvMfrMOmApUzWfrdjtE/PhG1URjMlWiN3agNJqa7TOgA2TjxMPDPKfT2+2BDlx7ULUIbQj7I9qqHxHoWQ7NQlu22THdZ7dNtgjwjswMjTIlHoM3HkZSuYWDCQ9LFMO5qnTKljWRktc6VGUJobUTCsexw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUgTWgtUpSUYxncI0pCBf1y6AddDiImbe/TPYjlutNA=;
 b=bfdTL+MqheSwdYB5phTeczdm+9zjFRVsf1jBddPuPWRj3VxNlXIfrk8Yom+/yYwkQJgRU0Ls4tE+sxAVcb0CifxzpC0bT/Ye/gwWdo1LSRYm/xmeVoVDG3A/gJiqGXjTaHVpU9Gp6p+scsUDeonlTzwjd2ZScaJXau2CnunAE1aEgQKkANmLINC4K1f2x+whvMLUJOxY0D5sbKaSx1yQ4NV4vcPLklyBONKKGofMxB7QyaWeJFdc9IL9fZXY2pXFXxKAI2EAaLXZ73Tgs0D/Xur+5ph/74WaFvvZ0mq05ZLJSaAcHalseu3iW5myF2CwuN1Hc4+FeVtgOt/lIjY+vQ==
Received: from MW4PR03CA0013.namprd03.prod.outlook.com (2603:10b6:303:8f::18)
 by SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.12; Fri, 11 Feb
 2022 09:21:02 +0000
Received: from CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::ca) by MW4PR03CA0013.outlook.office365.com
 (2603:10b6:303:8f::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.14 via Frontend
 Transport; Fri, 11 Feb 2022 09:21:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT018.mail.protection.outlook.com (10.13.175.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4975.11 via Frontend Transport; Fri, 11 Feb 2022 09:21:01 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 11 Feb
 2022 09:20:56 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Fri, 11 Feb 2022
 01:20:55 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Fri, 11 Feb
 2022 01:20:53 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@nvidia.com>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next v2 1/4] net/mlx5: Split function_setup() to enable and open functions
Date:   Fri, 11 Feb 2022 11:20:18 +0200
Message-ID: <1644571221-237302-2-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
References: <1644571221-237302-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f6d8bff-185a-41c1-d036-08d9ed3fd28c
X-MS-TrafficTypeDiagnostic: SN1PR12MB2560:EE_
X-Microsoft-Antispam-PRVS: <SN1PR12MB25608380CACC888C3172AD90D4309@SN1PR12MB2560.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qwed99iTzLJcTghGPc+eeAuKyUCtalZkgbynuKwBntXpbnT0RDLxcSS+x5TW0h3eN6yj5/tyJrCBL92fMVVh+MdBjbpg9Ofyw+jKkYv/Jpga/evokLgrkW1HQLBwo/VyRa24TOFuFD85uUvkPNuu/axatEpGKFMSUcoQA/pKqAkMrTz22FuLOQjkhf3sOe2gEoq1rJWiVj802Qfjga98WJbW7xvRO4Ee2O/tQN1jzsFZiwTgOGU4gdSkiaLtei2XWGVvQntvMQb5vuvSZ7CLSOpbO9l1DrjtwSCTtUWe3UIBQG2LJzu47qdQxwfwT2Cr3oBq2gmq/K48K90wmFaaPgoNrW+wdX4fynnBRVwVGBebWr3G/VHEvhiGfOiZEZpWA6+yUKmHNFLuHlxhrss3S5S6qJ26xbZTc4J7XpVHsnUz3bryaETyfmWRA8RJjcaF/F23kyEqBlJ6KN2mZGuAoRFMncySc3fGo7He9i9SJkH+bQmXy3fa2ZO5/RNdZTiegmYG7xx/zuWPQXPUPh7UOi4loDkAJMLzXen7AEGdxnsXDk4+49s1l9Oh+H0d3deCZG9t1T9gcp1ngGWmbeYZhyC1SxinIm55quuIL4G7Ll75w2ME1awxvV45ct6BQGvee5/VZlIIa0H4q/mleLoVtuYa8ekvWWgF9WObqBOihLpCsM5XjtbDi1DyexSZqJEMNZo/S9r37lERfkjeq30+WQ==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(6666004)(83380400001)(47076005)(508600001)(5660300002)(2906002)(40460700003)(36756003)(36860700001)(110136005)(8936002)(70586007)(86362001)(70206006)(8676002)(4326008)(316002)(82310400004)(6636002)(54906003)(107886003)(336012)(426003)(81166007)(2616005)(186003)(26005)(356005)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2022 09:21:01.9708
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f6d8bff-185a-41c1-d036-08d9ed3fd28c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2560
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

