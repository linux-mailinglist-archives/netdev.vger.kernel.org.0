Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FD45843AC
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 17:56:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbiG1Pzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 11:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232731AbiG1PzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 11:55:06 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2070.outbound.protection.outlook.com [40.107.100.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E5E6C105
        for <netdev@vger.kernel.org>; Thu, 28 Jul 2022 08:55:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S8uG48YaRaxXwWHon8nrPWTpY9I6ILUA53H28C/93GznxZ5VFaBMX3GFwTrDsM195dw5wxAJTELtAZSOxX9YvXLS0zHyQmBKSMzKN1gvNzfTqDetdCN3R2LSJUt3mhgn6KZhCZvayetEZ69Rf2lpeYji6EIamJWs/+gPv/OxYZ+6TSD5n0KUW7J8KSqrh18EBueLNOFUpY8xakxZ8nQhho8KF/+pXBuYXTvTu8M2k0+pRfWrxo5gC5rbW/keVdzF3Xl3EmkV0CzLJf4x1twABqe+rrYnRs+4LyBFVCh/1NQeZRiZlFU1Aa9ewCqde8Q9QAYr44ShDFCv2phoTnvK6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3JhtGYuoGv2zg3iA6zsYuH3rk7l0VxjXZlOr891Z6V0=;
 b=ocFQGvNhXJJYhQQ1xURvIBqZqdrJ2F5PbAQbWWZA7jdEJAfcw3fDnTI0DYzRqhzk9QlQFlfmLcJgM0livGZMiUUaKs1u2ZT8ZqXng7ENB5uNRSJYgG/S3bvFJJ7KG8eMk9MFpx1gJVkarsRavqhWn2106x5SGKCCZLWXAhgYD/8xo4BwJFR4qZUsvKvtayBBETmiSwgHguS2nseCO0zw5bHaD6i2K4+kcOLgUEh3+O3TaiU/NPPsgY6t+LfIgZTNTGk/Eh9bFgp3r0bh0NXWnB4twGLTDTNEbMwoDbFPLX2j77JrclGNfpGhLdYRfSTdesE2GN+ZqJI7YZNEjYStoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3JhtGYuoGv2zg3iA6zsYuH3rk7l0VxjXZlOr891Z6V0=;
 b=PEVjIkci9JQRmbhlqcuky/lEuDzLOUXgF35LeYRrVIFNzSA/PKkNZGiqqkadCngv2VEO3dvxaZAzcLGfNNyYXcQ2VdeCDejnpIhP94NoFxnIcVz8UJtS/mxkdJZiKDLieBYPSLv6R9JA0o2BoJLGUzGrPA2ws11Dunqdo/MBruLGkqbkMjcnH46EBk4Hxa3ndfPj12/soL5P9VvA++22LvsxLDyCx71sl2wq7HdsXdongyvogKdWY5/eXwH6kDbobrDrAO+gF+bRpcoygJ4cqwziLqbvoGblZFzMPpSDtU1PAqQ49v7QjnlnP8apNigSEvseKaXVPyr13iS9yoKprg==
Received: from DS7PR03CA0051.namprd03.prod.outlook.com (2603:10b6:5:3b5::26)
 by DM5PR12MB1324.namprd12.prod.outlook.com (2603:10b6:3:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Thu, 28 Jul
 2022 15:55:03 +0000
Received: from DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b5:cafe::c3) by DS7PR03CA0051.outlook.office365.com
 (2603:10b6:5:3b5::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24 via Frontend
 Transport; Thu, 28 Jul 2022 15:55:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT020.mail.protection.outlook.com (10.13.172.224) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 15:55:02 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 28 Jul 2022 15:54:47 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail202.nvidia.com (10.126.190.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 28 Jul 2022 08:54:47 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 08:54:44 -0700
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
Subject: [PATCH net-next v2 9/9] devlink: Hold the instance lock in health callbacks
Date:   Thu, 28 Jul 2022 18:53:50 +0300
Message-ID: <1659023630-32006-10-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
References: <1659023630-32006-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b46f6d6-703e-472e-100e-08da70b18833
X-MS-TrafficTypeDiagnostic: DM5PR12MB1324:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wMZerd5d+2Sz08pZKto/4XJGk3AaTj4NNWCUSi1ameOVs/5pnGgGZWSPzoS7fZU5ZrzvaNG+qLR6gN/SHOLOYkc0NUytpSxpe9G5Tnes8iZ+DlaVtkLx1P26Q9tf5xsBdIl/dzcH+jly0TEyw/KlJ5rk2MYIiR5+iW1YALDruTkDITNKgnpp2aTFNMuN2hzOdVbRkXn6OF3V57OmQoZpj7fibYa43QvcKb8s29g43oqI92ThKVR7bxV2vy/0ZpS6UKdjkTKulBEjCrMkfMFg4n6GIGrSJJXX5PLR6ae7S/OfNLDZWHfWnYLaXgWBLU89a9s64AdvHukvUAaZ+Ad16oQ4s2trVKPniWny7esO42ceigQ1akauTIfmbGFcXxUw0lLHLNt01KdNUqAFY/Ag7LFAUK4/YIokQy24YJFSXnFECj/SDClVD3IVGRS0pj+/HYb0jDCWCu9F08saWRZjQN3Gkyr+k3LA4JrO1CV9GUWJ2etr6cO2CylOJZGqmTLtzuConesaHX8m4rvun8YR1/ehezlvHOBIOLhrXNX780an2uF2TejO258iO0SRE15hZtZQiRS4Bj8kL6tGrCma2sOoNB5ueH72YtZWejSwfb/VQ0bOqMDm6V+Pqq8GQOldKPi4pevCyVQgSXpmVDsGjORtzSu4w0xDGhy+rhP3XBB+rEi9XZvrMSD9gq3q78TY1FhCpJQRpYi+oBpoQ4iGSVVLkkSg70RIEgROUmmZhuAAL+OD7iafXheM0rqymeNMC9uMy2BzQUHJEOAmE+VdWoFRh+mrmkkFcGCwLtdmboGdexO3ICHuwd6B1RXkVIogdbPgWkaDziHFOox7fQq2zA==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(46966006)(40470700004)(316002)(40480700001)(36860700001)(5660300002)(82740400003)(82310400005)(70206006)(70586007)(4326008)(356005)(36756003)(81166007)(2906002)(336012)(6666004)(8676002)(186003)(54906003)(26005)(426003)(86362001)(40460700003)(110136005)(47076005)(107886003)(8936002)(2616005)(41300700001)(7696005)(83380400001)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 15:55:02.0416
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b46f6d6-703e-472e-100e-08da70b18833
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1324
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let the core take the devlink instance lock around health callbacks and
remove the now redundant locking in the drivers.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
---
v1->v2:
- added lock while calling devlink_health_reporter_recover() from
  devlink core (bug found by test)
---
 .../net/ethernet/mellanox/mlx5/core/health.c  |  8 +----
 net/core/devlink.c                            | 30 +++++++++----------
 2 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 6e154b5c2bc6..2cf2c9948446 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -622,14 +622,8 @@ mlx5_fw_fatal_reporter_recover(struct devlink_health_reporter *reporter,
 			       struct netlink_ext_ack *extack)
 {
 	struct mlx5_core_dev *dev = devlink_health_reporter_priv(reporter);
-	struct devlink *devlink = priv_to_devlink(dev);
-	int ret;
 
-	devl_lock(devlink);
-	ret = mlx5_health_try_recover(dev);
-	devl_unlock(devlink);
-
-	return ret;
+	return mlx5_health_try_recover(dev);
 }
 
 static int
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 274dafd8a594..ee9cbc4f755e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7553,6 +7553,7 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 	enum devlink_health_reporter_state prev_health_state;
 	struct devlink *devlink = reporter->devlink;
 	unsigned long recover_ts_threshold;
+	int ret;
 
 	/* write a log message of the current error */
 	WARN_ON(!msg);
@@ -7586,11 +7587,14 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
 		mutex_unlock(&reporter->dump_lock);
 	}
 
-	if (reporter->auto_recover)
-		return devlink_health_reporter_recover(reporter,
-						       priv_ctx, NULL);
+	if (!reporter->auto_recover)
+		return 0;
 
-	return 0;
+	devl_lock(devlink);
+	ret = devlink_health_reporter_recover(reporter, priv_ctx, NULL);
+	devl_unlock(devlink);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(devlink_health_report);
 
@@ -9264,8 +9268,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9273,24 +9276,21 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_set_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_RECOVER,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_recover_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DIAGNOSE,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_diagnose_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET,
@@ -9304,16 +9304,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_dump_clear_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_HEALTH_REPORTER_TEST,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_test_doit,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 	},
 	{
 		.cmd = DEVLINK_CMD_FLASH_UPDATE,
-- 
2.18.2

