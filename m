Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD3168C1E8
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjBFPmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjBFPmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:10 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2078.outbound.protection.outlook.com [40.107.101.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10D512CFD1
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jKZu5p+1Pd6JPQNO6XoT/xC7ub60s/4E2g+ATTXTahsNFdz4H84QzdZKiJ4Cpa1RSmwGMuHCnDbzuM/hXt2TCUCiCvACbTq9gQMtLBiheyTKaz7H1czIhLvqA0yoi4L6XGAOz0if2NCkk9nokYWjDk4oNZd46TesWqOU3HzEe/wvQeVajXWFi0Y0zfKWjYucALmP2rwtHoT7VvuumIrU1qxpEWyBp+OjPgm+6rjOXkHVCG8DYOV8a7rVfE7J34SES7+jvgRO4W81mECHoopDaeWqq2LFbPA/t/lKb72Z/5Q5KJQVA1hyhV8xUYtLzo9aZlCfxJH+F2UAyC5CuzdNug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S56gj+7rJvydl2d/+Zt3waQDzV/c9hNd7NhR3B/CJkc=;
 b=nWNW2/+Pa2pVDU8TJ4vk2OuN2OXOGMFRVmjmdinLM7KM0hc5nYzpdzaJVMwfCgjrmW9t4WMWUwg2X3Ok6N6OGq75o6KnBgqj430lfW1uYAuo4olnVCepjJzT2UoKGdin3DpzMlwxjTbb/nw6cmcub8zuVw93ngi+vk6NW//+tw1TH8scDu164c9Fux3MVK7AERnIA3zdPwBBa2ZxNrbhTXWiap/rgVx0Ut8phU4NhcjS0XhZmwPqQlz1CIHCK4gla/KyGXREeii65XO4uTTCQSKMpnQwhxiQFnfN2Jcs/YKL2XMhy2BSt3gPcnd0Ua9Q7Xq/6FgGTENK7fM2yb0FkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S56gj+7rJvydl2d/+Zt3waQDzV/c9hNd7NhR3B/CJkc=;
 b=U1Wt4xP/Pdjm1n+8j1cGxMpB6aX39w8RcI6QCxkPiXAn85ldDrz7D/w+feAADhs1la0vFp6qXp2gyKp7ME8IcKexIvkooLlTXnbp//bkX7UFq50fz4K1Upk2M7mIosh5f7fgBW1LcEbrVh8XVRLNmEIrxliITtuleVtIXTER56XuQU+1POOtnL6GkirYLz/pNB17Lmk/BdGJPqSUIAf/AZB3UWpYFjaqKqyVrDPGSGKDMmZZ5Q+LpYaEPYX7Ce4eynDgJOo6AkIRab4LyI3rdlQoL38vToElnY70iHf2cRjTgP4U8dx25U9TaeTTuf2F3EVg/xqwmDUzUWKj1yKleA==
Received: from BN1PR14CA0019.namprd14.prod.outlook.com (2603:10b6:408:e3::24)
 by CH2PR12MB4104.namprd12.prod.outlook.com (2603:10b6:610:a4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Mon, 6 Feb
 2023 15:40:10 +0000
Received: from BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::4c) by BN1PR14CA0019.outlook.office365.com
 (2603:10b6:408:e3::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:40:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT058.mail.protection.outlook.com (10.13.177.58) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 15:40:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:40:02 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:59 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 6/6] mlxsw: core: Register devlink instance before sub-objects
Date:   Mon, 6 Feb 2023 16:39:23 +0100
Message-ID: <cf6d14912dfa17322a311e8d40d13633648c56f9.1675692666.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT058:EE_|CH2PR12MB4104:EE_
X-MS-Office365-Filtering-Correlation-Id: 80f1b119-3fa6-4cc8-2ee8-08db08586e58
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q1odF1xA7PvEwLntjv9GXgsWKO1ywsxANO1M66WF7FSxl5qbHXRsHjC60zMoJwP8MESaNNg6kuL2Wr0AziocHjggXK1Ke3Q8Ikh8uBddx27TODAWSvsM//Zq0w8iKLrK+pVu26ONQoflFSeTpnAOUR0kfTTcHg55l9NPGhG3SAtytPBBuheSAYHiI0QLanf8Wgk40iyT5wKKRJ7yZlZK4Q6/cxrg9LoUVZFcroxrEBhPZZDag3w42i6QuqbTYmV9hBzKQRsrV2tR3jhxNOams0/mUNLRAehroc/uUBtFuuqYlTrDEPjuBZU++WH/j/eOZdEaVTJxwFskYJja5z7N5aYGEcRh2ngRFIog9uVIHbj1qOTPnNdAs/W8DLa0Ge3t4KsnaOI6YoFG/pX72lnSQcFhG768QHdUOjkCe/QhVxjodNjdO5+CrWqIISSc3LEO+vBP+Gms2SnZdOgJYLVrerQKDfetYagmKiC7c4a9c8I2zgFFM30m7uXVzH+bmnliqceKtFzJn1jGzjF+C15ZR13+0eqDQo4HM5QI52xe1WvKoxGYd3diLF1PYEGvwh9tikXJ3fPMUlfpcZ/dNA7Blb1u/TIewWOJCQV7bREweE2Z82VV8OwOzqr9ZuovO0m95HtCqbH/PjB64FWPFn6mrI7rfE5rdX0sG+ULq7QF9/SBw8/bUsEw9/LUo+GthETqW3G+xQkp/pGRTC4GOi00IA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199018)(36840700001)(40470700004)(46966006)(5660300002)(40460700003)(7636003)(186003)(16526019)(82740400003)(8936002)(107886003)(6666004)(426003)(36860700001)(82310400005)(83380400001)(2616005)(47076005)(336012)(70586007)(4326008)(8676002)(40480700001)(86362001)(36756003)(26005)(478600001)(54906003)(316002)(110136005)(70206006)(356005)(2906002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:40:10.2287
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80f1b119-3fa6-4cc8-2ee8-08db08586e58
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT058.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4104
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

Recent changes made it possible to register the devlink instance before
its sub-objects and under the instance lock. Among other things, it
allows us to avoid warnings such as this one [1]. The warning is
generated because a buggy firmware is generating a health event during
driver initialization, before the devlink instance is registered.

Move the registration of the devlink instance to the beginning of the
initialization flow to avoid such problems.

A similar change was implemented in netdevsim in commit 82a3aef2e6af
("netdevsim: move devlink registration under the instance lock").

[1]
WARNING: CPU: 3 PID: 49 at net/devlink/leftover.c:7509 devlink_recover_notify.constprop.0+0xaf/0xc0
[...]
Call Trace:
 <TASK>
 devlink_health_report+0x45/0x1d0
 mlxsw_core_health_event_work+0x24/0x30 [mlxsw_core]
 process_one_work+0x1db/0x390
 worker_thread+0x49/0x3b0
 kthread+0xe5/0x110
 ret_from_fork+0x1f/0x30
 </TASK>

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index a08aec243ad6..22db0bb15c45 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2184,6 +2184,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_devlink_alloc;
 		}
 		devl_lock(devlink);
+		devl_register(devlink);
 	}
 
 	mlxsw_core = devlink_priv(devlink);
@@ -2267,10 +2268,8 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 			goto err_driver_init;
 	}
 
-	if (!reload) {
+	if (!reload)
 		devl_unlock(devlink);
-		devlink_register(devlink);
-	}
 	return 0;
 
 err_driver_init:
@@ -2302,6 +2301,7 @@ __mlxsw_core_bus_device_register(const struct mlxsw_bus_info *mlxsw_bus_info,
 err_bus_init:
 	mlxsw_core_irq_event_handler_fini(mlxsw_core);
 	if (!reload) {
+		devl_unregister(devlink);
 		devl_unlock(devlink);
 		devlink_free(devlink);
 	}
@@ -2340,10 +2340,8 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 {
 	struct devlink *devlink = priv_to_devlink(mlxsw_core);
 
-	if (!reload) {
-		devlink_unregister(devlink);
+	if (!reload)
 		devl_lock(devlink);
-	}
 
 	if (devlink_is_reload_failed(devlink)) {
 		if (!reload)
@@ -2372,6 +2370,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 	mlxsw_core->bus->fini(mlxsw_core->bus_priv);
 	mlxsw_core_irq_event_handler_fini(mlxsw_core);
 	if (!reload) {
+		devl_unregister(devlink);
 		devl_unlock(devlink);
 		devlink_free(devlink);
 	}
@@ -2381,6 +2380,7 @@ void mlxsw_core_bus_device_unregister(struct mlxsw_core *mlxsw_core,
 reload_fail_deinit:
 	mlxsw_core_params_unregister(mlxsw_core);
 	devl_resources_unregister(devlink);
+	devl_unregister(devlink);
 	devl_unlock(devlink);
 	devlink_free(devlink);
 }
-- 
2.39.0

