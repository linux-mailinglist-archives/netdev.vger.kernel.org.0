Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CADBC5843AB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiG1Pzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbiG1Pyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:54:51 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2061.outbound.protection.outlook.com [40.107.95.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28B836D555
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:54:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q2N5zwFFWYdYMU/Dr13AfUleOqr6psDmrH8OAQG1Xl2/9kuO5C7utYbm8d4/FKAmv4GC3K2rD019LVEV6NfFP9KuwO+jQoKWlVhn3gMJM5bFwA//oRwFIricu1X+T3/wlzO7nIUHaz4vStS8htMhdnQ7/78SQAC06rJr1lygG7ELt6y76JOLyKPoZNDKqp8D6eOnl4FzsXvHWnWCCiN4fXXCY2em4dRu6o880hOiLGGhan24d56m97y7HXPGBAm+kj/IIQv/ITnzewnDw9A9Kx/wr+uHJpezLuUXi386oNet+bXwAFNS0s3EPSCf4t0URwQxtfQj01UsIZuV7O/Jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=quyUkZizyYtOzRciYm91kfZ2cP/PklOd+7XHeOAFvG8=;
 b=nnuTTtQTAr9bHO9Cq/QAV1deSUUn/5f9tdr+cE/ZFl6zevPnApJggKxxC48bX3HukY7Wnttk3uVrlf+0Cvt00wRoWbdEyJF8+0/0vNdMvjs1yAgMOiJUhUYpykj0pNgQZYL5xzBJ8kgM1l43TmMg0ZnDvtZgOijSTzPNA3evZo+vQA2HumkElNFa0XbvrI+iRNePfBH7qSgKW6CZI0ZeIOFo2ynf5K2lEfzX1ufOjMJawRcIJKxkF2Wotu6dtG5MW0O8+syajOYifCntTfZaGWSnB5wi0NpuJRF9gljCymnaWefkcwGDn+q2s6SrhFZie8cywnoA2LWcN8MbUxrf3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=quyUkZizyYtOzRciYm91kfZ2cP/PklOd+7XHeOAFvG8=;
 b=Q2Fg9ApzlPb6NQIcO8UlrUSTRen+FF/rDDY8csfuJle8n1Y7QA7sQDDY5AcC5tExUUEo/i4ji6Ngq6C5OH411QDzwvKS5B5O2+VSaFg0XPCeM8aN00aoRmQMA2LpUrAGOPD7g5qRzzNlRcDQ4/giH1LG2S2ijTckU0DGOgNtq3Mwd4UznBl45Yvd5XlQ/u8KzjEPz8ZIj9abxnpsWAo3vfU2gkLymUWDmdVYsvwN94ADlgi8v8udtpxn3Rq+IY4rzhMtiisX+AdYPv4UzaZ4GGACwFOcDa2N4zXqMZWf1MbILqJGY38SpTpETx3jXjXZAsPOIlZ8JL/bUqBq8fDltA==
Received: from BN9PR03CA0161.namprd03.prod.outlook.com (2603:10b6:408:f4::16)
 by DM6PR12MB4451.namprd12.prod.outlook.com (2603:10b6:5:2ab::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.6; Thu, 28 Jul
 2022 15:54:46 +0000
Received: from BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f4:cafe::aa) by BN9PR03CA0161.outlook.office365.com
 (2603:10b6:408:f4::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.23 via Frontend
 Transport; Thu, 28 Jul 2022 15:54:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT042.mail.protection.outlook.com (10.13.177.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:54:45 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:44 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:44 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:41 -0700
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
Subject: [PATCH net-next v2 8/9] net/mlx5: Lock mlx5 devlink health recovery callback
Date:   Thu, 28 Jul 2022 18:53:49 +0300
Message-ID: <1659023630-32006-9-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f3057ba9-b921-4fb2-48bb-08da70b17e4c
X-MS-TrafficTypeDiagnostic: DM6PR12MB4451:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nkPeB0APtRbwFGrFhrZyH9s1NzOioJ+GxJKPVV86AT1aGX/NhtDWSVE6M9sd65o9JlWEpxY6D+tI7tMhLd3ShdY925FHDBC5NVSVCZSGCAniAlKsUWYyGrSVIgPP5dEWSFlFp7uA+B/f+MFXKnpFioFXUuD+UrmIRd8E//R6c6REh4Kxn4WhADIe3WD/IAfMrjcIXmvJilBIDywiOEuYpjbMeqKT3zLF+kwWPogbNXrdBalqLmlPF3ecyiovPcR4SRGi6DIRkjgGag9sGFqdAsYtohBIra6v0BjHN5dGeuSdU/8isr2/WGYRh8AtYUk9EsQh7kX/SqHT6kg09cfD/DtuQCG1UnUV/6hrUYKLRgW8rFxTl9M3/etnGmUvxQDvwK3xu6IcPWTIEj6T46BDUEJLKk9UZTZRZ43FED9ma9uCt70GsxZ2yy6a8qyYfOUApxFay3TCzGB7zuM0TVPKHxNsTuIuR2Hmuq2OpWOaMzYN97VhqECnXb6NOzpt/2csg0fCl3FMr8R3Epfc/dHyOLBDzSEKorID/oo2x7hAVQ+9fyg1Eqjr8d3lCnEdUoNHdLCa5ESvPy34AUizvYP421aPobSQnNyow7rce4iGppbOI3+JlKK0oA7jfAgC2fZhdywE4Q7cnknwh40+YdN5XRI1HA5FpsQ8SgEmM+xFKRf8XcEeeNrnzvtsLvtODuy2gVrxeFnOOzcBElf57XUQPvnmudszNTSmnx+us0AjBBdCU0LspFEmWLjR6wnC9AKn4EzBg4EHZMexp+Z0efi69WThUwOKf6XDcRgwFfcwszGUuabs6yTAuIK6duwhNMC+TsLX7L0QazEOM9OSqrYLRg==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(346002)(376002)(136003)(46966006)(36840700001)(40470700004)(40480700001)(186003)(26005)(478600001)(107886003)(82310400005)(2616005)(7696005)(336012)(86362001)(40460700003)(81166007)(82740400003)(83380400001)(41300700001)(356005)(426003)(5660300002)(70206006)(70586007)(8676002)(4326008)(8936002)(316002)(36756003)(36860700001)(110136005)(47076005)(2906002)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:54:45.4922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f3057ba9-b921-4fb2-48bb-08da70b17e4c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT042.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4451
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

