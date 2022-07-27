Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14353583161
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242842AbiG0SAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:00:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242835AbiG0R7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 13:59:37 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2052.outbound.protection.outlook.com [40.107.220.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC6E59265
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:04:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgYo34YMqLDKkSBF9vMsai0+MaYQbCTdesRcHI4g5auK//24nOvIQG/9M5gKrTMiVCgAi+uh9ThaL8A/wNlwtSfcgAVP152asqaUR18llJopLQ5N9KymnX5SOkSVQ3LwqdfgjAGevKo+UEAoSw+OjJ+uKXQG7e5yieGrNFPSKpbeGLfqwYVsn8wRu/BxqJ7oVgaMtkPiKeI96hajuJNEu38oo4c1VcU7x3WmMf6uWXK3JbfTMFX+gBCLrHcxySU+n+djuG+OVuw86TZNLQNsnrmmO/JYBETsPeD4LF3pUeOl1AEgK6mkzBPudgP2DQ9qaWpfTZ+XKOa75BoVtQFAxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AeYAgSsKJ845VRknfG3ODHOqZQzS+15OHqeL8jheL+E=;
 b=FdHeA5dOD/KJyFjWs5SmWdTFxMp+Y77FLc54oEgP/F3ZnKMQ5aH0sRq6sM+JLcozsSAxy5wLhxY1+QGREqa1rj7eEnjZKpnbtv8+yCx5UYZnp/oyJ1XDpo/s2Xt4fHgzKj1skt4f4NcbrxbzW8NrdYM8rFekC47b4HFVGt+OKWmH8QZNt2U2Hv8zMAwQnvXDI039FggzAR1jOOCFVRlg5nekPlSY2EPjrd3FYHwomGewCkH59DG+W1mByhrFA0WvI2zPfIkVjpsvs8RDsJQIU6V21dKvhgLLwF8E6BWuwg1AeATr+g0akNT6CKDfcGaxqyza7DXzx3GGnUlyWcXJ6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AeYAgSsKJ845VRknfG3ODHOqZQzS+15OHqeL8jheL+E=;
 b=eQhbClYZaXJa8rB+Ins6NicNzCcUS6mijhrJw5CCuBu8pL1lSfoP/CH3SG67WoNenamxKf5z4yRjAlXdB7bEfhvbzlkkQBSX0SQSv7GFN1wQGSMLX9RBTWqIeNifGjVgpkOrn/hqdXAhlV+obwv/XpL6aidM/eJaSfyrwD2myTEy3Cg555Nm08Zug23wTjgVSgSZi+36b93ureGxgjG3B2xZHm2tdS9xj6kkB0G93P3XTPO5RXMvDoVUMzkvwI+ZToO96LOX5jfOfjSu9d5f8nr3zX9jO96ls/IxBo5b/BsczSh2pv/0hgoygdp20Kti6jDt/drFSl9GHTz71jhhdQ==
Received: from MW4P220CA0024.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::29)
 by MN2PR12MB3120.namprd12.prod.outlook.com (2603:10b6:208:cf::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Wed, 27 Jul
 2022 17:04:32 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::84) by MW4P220CA0024.outlook.office365.com
 (2603:10b6:303:115::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.23 via Frontend
 Transport; Wed, 27 Jul 2022 17:04:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Wed, 27 Jul 2022 17:04:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Wed, 27 Jul 2022 17:04:31 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Wed, 27 Jul 2022 10:04:30 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Wed, 27 Jul 2022 10:04:28 -0700
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
Subject: [PATCH net-next 9/9] devlink: Hold the instance lock in health callbacks
Date:   Wed, 27 Jul 2022 20:03:36 +0300
Message-ID: <1658941416-74393-10-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
References: <1658941416-74393-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad23209f-93c8-4e17-a665-08da6ff21301
X-MS-TrafficTypeDiagnostic: MN2PR12MB3120:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1MwXPz+df1Ly9NHkG47TT7fo0MDs/EKKtxhGFSCe6XBEY4RrRRhbtLc6YiS4Q2VQzEkepm+cZqQ38HFXR9o4MJG1jS5pllUryy/9Pkgb+a4EnzV3FiDa7m9ETHM3jqEOYcuIer0f8OdQ15UUl/616EsKdczxnu/rCA+cXnH2yvF0hwCQm3toou9iDUCnUvyPjO3HE2aRuMQrzoorNmVENpY2EPDcG7aUdNrADE6R8FvYMMwETdU1kgZmBoqiT38z7CpMVsnsaP9U3GGaT2GhSf7gQTaVsXdjLVD0rkx9nh6mHb9oXHmHLcR9O0+ZJTCVTBPpFJrFJoqSIWQ0rQt2FVaqbR4LCxLUUxLCI1z457E1CrjO+ETpdjuMg6gWbaTVuzXE5wiAJHk5zb2Yvn/C+6lsLpDPscN763C+LBfFzkW32c1ldoSfRsMhoPQ879Jk2gVDcAjMZ1DB9cCdYLod83rMpCoH5k7Kd0W/ZZKBpCY+eF6o2PZ7LfiQZTnicM62BLLARyzRrA/yHMU+ZlS6YY1CgYYmkwhQ/TLnbzaAHLYtbpmcCeerHyjNsc5/l/dutgGENbrc1jibnaxhQUyk1rQ/4Hba2r9qdyYB7aRmTNVLf5G7J6w18h0Ex9Dus/hi0EH9yw2dxtXIuueFbI5l5uS5dmUfJMtzy4jlR8rEXWekvJq/wt54dFkG9lTX00goO2aNkaW9DKN8fsgRD005NfcLiX7MdXRjk50oqGKfDKoUgFqpuvxAUQTyGNHZOgKAvHm9Rx5mnA7+J0CPpQMEH1ei7cvfc3fw9u8mh9a+uyO5TjskAefVlmO5divt7FZJ44yOpzx/PKdhYpZvQ6bS/g==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(39860400002)(136003)(40470700004)(46966006)(36840700001)(47076005)(36756003)(478600001)(86362001)(40460700003)(186003)(5660300002)(2616005)(426003)(8936002)(54906003)(110136005)(83380400001)(336012)(36860700001)(40480700001)(107886003)(356005)(82740400003)(70206006)(81166007)(26005)(4326008)(7696005)(41300700001)(70586007)(82310400005)(2906002)(316002)(8676002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2022 17:04:31.6896
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ad23209f-93c8-4e17-a665-08da6ff21301
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3120
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c   |  8 +-------
 net/core/devlink.c                             | 18 ++++++------------
 2 files changed, 7 insertions(+), 19 deletions(-)

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
index 4de1f93053a2..e4bacc6d2cd8 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -9265,8 +9265,7 @@ static const struct genl_small_ops devlink_nl_ops[] = {
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = devlink_nl_cmd_health_reporter_get_doit,
 		.dumpit = devlink_nl_cmd_health_reporter_get_dumpit,
-		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT |
-				  DEVLINK_NL_FLAG_NO_LOCK,
+		.internal_flags = DEVLINK_NL_FLAG_NEED_DEVLINK_OR_PORT,
 		/* can be retrieved by unprivileged users */
 	},
 	{
@@ -9274,24 +9273,21 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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
@@ -9305,16 +9301,14 @@ static const struct genl_small_ops devlink_nl_ops[] = {
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

