Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF00C583163
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243056AbiG0SAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:00:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243042AbiG0R7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:40 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2058.outbound.protection.outlook.com [40.107.243.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380ED6E2D0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R58Z/qEZeZbvC2hOeOXyYABHIIa1FPBFb4k6vSGVOegxaONcT/pj14Mi9X3K0SFib3LLXUSWvunyExIVKwzF9OlcneDr/1buzPxWve74BZ14f72TP/mz5/yOj1KmN2nsct+wHpWtDBo4ALKJeA3kHtCX1bs0m6ExuVsFg3Da8nVWvyZjgVe/9GTz3tJxV4chlJj/rb4LIXPfvGXqRaXIoBwq5yboInb+kIAlkEF6EoqHRJs1E2m5rH65i2UrEUjPTc7ffPg3nwyrdvf6JoXkma5AhhAHjiERRYmoxAqsoFO3VLn3dTa2GquCG/hTZjdHU4ieppQcZn3mtKQKxfrYjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quyUkZizyYtOzRciYm91kfZ2cP/PklOd+7XHeOAFvG8=;
 b=iFHDgqUaws6rbhmt0DflRRDrhkMu0ZrcrqBWPvybws7wGJalFH5zaCxOI5LMqIH5V4AzWkEPzD2swubSOTHSymkNjvUwX5GJnVQtZN/GuJnbGqWRhvnVMs233uKFsSealHLwwmDKTS7PQIDMygOmuaTVw45bHMczmSNPP/v/WO5ZYwzisfJh6J70Pch9YziwCQYmN9ahJRSs++TjCBqu+sJpypnUiBUnmS05AishTmMcOBbZpLydDqiD899tlJoZAmJBa9KcYYsug+I22Q2qZ1LbmdMpFSI+yNDcwl/DIyfw6PbVpd7LeXDsESInkzKacvuY+Y6YE5r7KP4dxEFlRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quyUkZizyYtOzRciYm91kfZ2cP/PklOd+7XHeOAFvG8=;
 b=Dd9+0hD5+z9xv6dczHdUJ087hxLRNBKcI/5iqx9oew1s8060y+cP7jOC0FQmSbzLh8rEYZBEvZWgInl8hPnVY2k73tpC1UWSYvAf8zdYf+KFOpLdaWYy4gH0caAC2j/7D4VdbkWMDAp62r1BIovwZAKoGYURjW1rYttJLAG1ndK9y6r+xA487PZ+lHJnJAdtsl5un63FRm0wgF82PWoVaRI45AFg4DK44oKkjzhbWsYuiA31y4SDKJPoYl6w3Gxyyx9GAzNtmr95xXxoO52IsmDj53YW50dnyHYenfzg2w0jmzeFvRUJxYL2zhU4bOhcngRSn7wDM/6lR7W9IJajnw==
Received: from BN1PR13CA0022.namprd13.prod.outlook.com (2603:10b6:408:e2::27)
 by IA1PR12MB6532.namprd12.prod.outlook.com (2603:10b6:208:3a3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 27 Jul
 2022 17:04:29 +0000
Received: from BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::a2) by BN1PR13CA0022.outlook.office365.com
 (2603:10b6:408:e2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.7 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT049.mail.protection.outlook.com (10.13.177.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:28 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:28 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:27 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:25 -0700
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
Subject: [PATCH net-next 8/9] net/mlx5: Lock mlx5 devlink health recovery callback
Date:   Wed, 27 Jul 2022 20:03:35 +0300
Message-ID: <1658941416-74393-9-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cfb2ff3e-7a53-4ba0-a398-08da6ff21166
X-MS-TrafficTypeDiagnostic: IA1PR12MB6532:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zFg2uTXJb8uvcon1oneJ+i/jrOLMr18qq1xRuS3ChsuUQyDJwJm6sJW8cHqSPlLDn8TDhaJXnwp0SYy1f5yqSaKkrW/uLWJzPW12SE9bXL3emvJ4HZCrkQxf7qxr5Ls157XDZyoW4lTZ3EIL/8dX9PU3NwfovRv6JUz0UNMtTV4ov1FCtCwhc2OCZLYQKCutwaiFHSrTANqoiFOw69FxsyGj+ENyb1zuppAE5C/8FMboC4YTJ1y7D76ymEjEuF62+1IiX2ja9yZbHn4vAulJk5eq3V8Y7UnXr8b9i0Cu+YQp6I7jFnVj57urI+Tm7YSOeVSzw7JSSBxNYbNiaIeF3euKIADm13xx/wIypP4PGHuJaMXiI3y9PY5uyKwCRUGvBXonCV8yXdojTj+UdBYuWz68cKpNoiwl5p7d5HRM06Qmk6OTRX7ibIbjxKBpdggcI0w53K00yt36G64Ee4wN/1QH+biJGeoWg5Qh4JVefs+xyHUKDYh0/mxwgd2fEJu1UNciumB5DaDyd+x2eiROkApkgpAnBNbRy6jDZKs/eeiQSTLVfxg4trGzs63cxMfey6BNHaq5TeFw8DuYodBuyJAubP5I8kCDukFmt/52Yh0nq7mKkyDb0Gjp+jpZmF6OHvxLz4SO+Jjjz/UVWiCieCGO6MiPTPumXkRSM4yrT/FQNu5y+ReoCjhMRqZNtHsKUAQYkHKNBjlpFA2Nhex/ZH59hQVrWJVRlQ9FACYgbX0555NSWeDbCUfZ859Z9FH9Kk9BoA25nhuuxzUfiFTzblRzrhnyenRYePVBpqqxgHf2tbEiAHwwNr0GiXyu8DR7OQJ5v+x0Jj/0HXdENplXrQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(39860400002)(346002)(46966006)(40470700004)(36840700001)(8676002)(70206006)(70586007)(4326008)(40480700001)(82740400003)(426003)(8936002)(47076005)(36860700001)(336012)(82310400005)(478600001)(26005)(6666004)(40460700003)(41300700001)(316002)(7696005)(54906003)(107886003)(2906002)(81166007)(86362001)(2616005)(186003)(110136005)(36756003)(356005)(5660300002)(83380400001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:28.9179
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cfb2ff3e-7a53-4ba0-a398-08da6ff21166
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6532
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change devlink instance locks in mlx5 driver to have devlink health
recovery callback locked, while keeping all driver paths which lead to
devl_ API functions called by the driver locked.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/health.c | 12 +++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/main.c   |  4 ++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 659021c31cbd..6e154b5c2bc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -622,8 +622,14 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
+	struct devlink *devlink = priv_to_devlink(dev);
+	int ret;
 
-	return mlx5_health_try_recover(dev);
+	devl_lock(devlink);
+	ret = mlx5_health_try_recover(dev);
+	devl_unlock(devlink);
+
+	return ret;
 }
 
 static int
@@ -666,16 +672,20 @@ static void mlx5_fw_fatal_reporter_err_work(struct work_struct *work)
 	struct mlx5_fw_reporter_ctx fw_reporter_ctx;
 	struct mlx5_core_health *health;
 	struct mlx5_core_dev *dev;
+	struct devlink *devlink;
 	struct mlx5_priv *priv;
 
 	health = container_of(work, struct mlx5_core_health, fatal_report_work);
 	priv = container_of(health, struct mlx5_priv, health);
 	dev = container_of(priv, struct mlx5_core_dev, priv);
+	devlink = priv_to_devlink(dev);
 
 	enter_error_state(dev, false);
 	if (IS_ERR_OR_NULL(health->fw_fatal_reporter)) {
+		devl_lock(devlink);
 		if (mlx5_health_try_recover(dev))
 			mlx5_core_err(dev, "health recovery failed\n");
+		devl_unlock(devlink);
 		return;
 	}
 	fw_reporter_ctx.err_synd = health->synd;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 01fcb23eb69a..1de9b39a6359 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1932,7 +1932,7 @@ MODULE_DEVICE_TABLE(pci, mlx5_core_pci_table);
 void mlx5_disable_device(struct mlx5_core_dev *dev)
 {
 	mlx5_error_sw_reset(dev);
-	mlx5_unload_one(dev);
+	mlx5_unload_one_devl_locked(dev);
 }
 
 int mlx5_recover_device(struct mlx5_core_dev *dev)
@@ -1943,7 +1943,7 @@ int mlx5_recover_device(struct mlx5_core_dev *dev)
 			return -EIO;
 	}
 
-	return mlx5_load_one(dev, true);
+	return mlx5_load_one_devl_locked(dev, true);
 }
 
 static struct pci_driver mlx5_core_driver = {
-- 
2.18.2

