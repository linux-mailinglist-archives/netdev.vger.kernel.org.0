Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332054C0000
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiBVRSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234604AbiBVRSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:39 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2088.outbound.protection.outlook.com [40.107.220.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F2F162024
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7SSgU/WgFwYvvXxmdiDNnGNlF0Ou4x/bhm/l/skNfRv8vW7HVyUwuGihQNPPiMQl+Ml8sou2Zo2FomkBHTiKWdmPr+O0tOYJ7c5gTp9QFOLPwqPKJqTYNVL9cSjIo3H6nRvj187Z1f3Yu6clRPN74zOFA5UKVatZN63W/F1+Z7tzbbIzDUjGGcWJxjuCz6DhYP0OtCFFs0VHif5J54BQxeLDz5Y4K1ZVNnjlao1zaPEfSWKcA513hbP0tcaCQmwHPDWq/0WEAw/O7eHkKbn0nTqZ3/BSguuoz9evcM+Lj2V5W9MSPwzwSYZnJ51307u6wKewBd4AL6dBWvZesUtVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=upIIBueZOMSFugXauE9kqZUDdevU6dmo+/5mQ6/Tcjs=;
 b=JX2qqShHsIxJCPvUOoo14lLmsaa89ahzSpNGVrXypVC/JwThm8/kAAi86Rzoba9p/lJuFsqzNAqCJd5DQUMQtfoyS3BbQ/xfFhQ0lNozSAW5+RNtLEEQL2l4n3dNPiNKDDfK7GtTA2/xwg0jItSTPuwSlO604eMa+r74zLFSgaHiV52+HKX2VrAp3JNcjx+UtsCStPsmqNk9IW6SEEdpPapdfREIj1Ae+fGXDjYeB+qdcmGr4H4JAO2u/0kyKhcO6cMYyp3F7EpLGZXBwTTxueVgM8q8f35/LKl0XcbK3p9vfrlOjK/Eu/mjOyfcwvahMc/fwO7dQkgloG5CohT48A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=upIIBueZOMSFugXauE9kqZUDdevU6dmo+/5mQ6/Tcjs=;
 b=dE/CL7MEqJrktljeOevbIID0Tjsj4yUYvJfkOQcbspNQgOr26hxoX1k2xBDV1wTQN3sx/d70Dp0BAs0rLimCmomQuZ5LHRUFJOjfbvwtqvJMCmdNfUTSpHwh5b7u3uIjHHZP5iELTzGi/uiUKHPKOofsm49vWFJ5+vUVViZmeA3A4xGttIZV0umMUtPCmPpkbuqWZW00P1O3RbRb3hoxlNxMjt8N3whf5aDU1IIHeEDehlzu4QLGkcQhMGZE0JsIc+mh0VY+uAIIKyiOqrpYTQfyIzbFbAC9uBkpTa2DGGKQEJSNXS75I03XWXhEH02accwVNW5FRRwCBDRTF7FjEQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:12 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:12 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/12] mlxsw: core_thermal: Remove obsolete API for query resource
Date:   Tue, 22 Feb 2022 19:16:57 +0200
Message-Id: <20220222171703.499645-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0294.eurprd07.prod.outlook.com
 (2603:10a6:800:130::22) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9eb8dad4-0e6e-4f85-6bbf-08d9f6274e18
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB426276FF16245C808FFDD70EB23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /SONjovzXgbWBEKJqQt4UmkznOUWaAzCDFK/A1JEwmICp8pf6HsFWujG+XlyCzAGS6vmp3wWJ+yESN05rxIYkIIGam7x5PrNDshVi3NQ7EI78v27HR8hqxSuuFKbjBfoaBSfHmRLRGC1Y+rVSZjEctaAYDUlCWZ7FM69GTLfIPaUrkVV+fEf+ql3POngdlkOmk5v6kbG49SXxqiXf/9dGOhbh+tLRHFL+iS9nvVbk3ZD+Bz/6H2+tqu/67B1QWeGcoXU0ik0SYFFDGSDWqvBNshDbMCBCyP4H/1KPTH9885rPK/f813JwcXurfchiljHULWF0g/DhupcYONwNamaiR9rrznZ6MB09aLAoRm121N8mUXPpZy7R+YQoFEymA+KzEE+Kl084nXYArCJ+9MKXz4t5S3wbaSJo7qRNcP/doLmkPGqrTQdCyEkqJQq3kl7hJGw9gcHfBnooTOAaJRGyyOxmLp1kRVuv6Dmh36WR6Dm90iTHq9T18ujjV+Fi8tkLOefyIrxQDR3442yc+ud/2MVIzkzjPIBL7BzmwZHjnNyenOU3B0U5l6sLjpO2LKmEVghuz6nGCbFhz6bOp+Q5PEirdiRn8v9e0HgMD57MYgeDEN/0f0/wpDN1B3NDML4dVFdV6+3qcQnurCvCfCMEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/vB70PuW3qLD34qtvlsJVT49/3evNlySuQl6Abtf/yYGtP4rSh4wmfxPhZ4V?=
 =?us-ascii?Q?vMIcsCV/mLSDzfBEbIUTjt1icbHqbUfXhSE+mRdhC9ou+GbO4NDnYYqhuktQ?=
 =?us-ascii?Q?zjipGYWdMrk32ViZOrIqEW7oJenu2X4v1tZ9zylkQUVPWE2rg1lQ5o4eryZh?=
 =?us-ascii?Q?Bc8+++suebGUpW37VO/u4O7iDaGwyYo3rkl3YrhQ9WN5tNcuMD96G5rAVpoM?=
 =?us-ascii?Q?xBfTEFoiDJi6e20gizmNK5zSqzeWcKK+L9CtfVmPQO+4nSPNQTUQAQSpR3JS?=
 =?us-ascii?Q?uUppLL1zBhpow09HWocMfnQVMpYEhd0vbU2Scer3AeLdogFXgAhWoTCsBqra?=
 =?us-ascii?Q?DQwd1fM5wCnFZ/SsG/3Do/5xVq7RmN5ZTc4Jd4zPqcC63R+gDM+/OEtyURck?=
 =?us-ascii?Q?tqSek8s54t3Dr2FKVgLIuap9c/3X2BNZBTkyW795l2x48jAH1MUo1Muq9cGB?=
 =?us-ascii?Q?jTx/clatN33+qHSqIcHoT3SIXI51l1F5Cnc3luo4MqU+cGAWgiO1zUowEA/5?=
 =?us-ascii?Q?8W/bKJ65h9pIhAqTfCKAw40xcmKGgJDBP5SpPWrhiG1M3AxWOXkFolnzSqaC?=
 =?us-ascii?Q?GxLT1DSv7QnkmuGvlXMDqMbH+LlCP3MBYPOftRmppp+hUXQlxozZDwwFijov?=
 =?us-ascii?Q?qlShjPOwP7sJcJBkrjqZkYpx0HsptMc1ULR6rQCBV8txKcVkUz6dd018yHH6?=
 =?us-ascii?Q?TOCSegH7iMDdpeFLl+1CwaONdlVA+ndxwUgPoap/GNup09hPrnRFXgW6tWXR?=
 =?us-ascii?Q?IBjWsJi1YKpW5hxLK6jT1fYWlbwI1k07b8JDF+oLe8i1j40pfeFo4PalpBzi?=
 =?us-ascii?Q?vqsa4R0FXBQId8QKpx7JSf9fErXJtlG6v6eveqBaug09u9LhsOT9PTMKZuR9?=
 =?us-ascii?Q?mB/CBtcPyFsukPdroq1s1X+1iVfD9icfe8IfHmG9ZRjVUb8lLxkiW92plgMf?=
 =?us-ascii?Q?C965ODBc9uxHUmTxG+HpmDSpNFyQ1/n8kyK7C2wxyGCtZMFNwHOcbnY9SGZR?=
 =?us-ascii?Q?VI4UoE4Fd3J03IHExyqqaOSCUwVnfdwwrgVq/w4cvGVXELIAkwFUKVRvGAfr?=
 =?us-ascii?Q?yFzU8QJXOX8lu++0sL2Dx2s/S9ylx2oO4boGXZxd1cWI6DLdHrQ0Y6uo5g6h?=
 =?us-ascii?Q?Xp7NUvso+cXAfUnbJxOhFbZ9IIWSFNgNjhepRJaacypRVJZ53yjV8oXjl8OS?=
 =?us-ascii?Q?npDQqfZEsVP8p+1UqUwNY3KzQnbYBrbmzr5RlWDFEIzmT3S6XZm6sCymjQSk?=
 =?us-ascii?Q?2N2apaPgvQlw4sTL2+1fAmUbGp9DG9/bfG8IM/meDyauy8IWU/k0JgKOQn6J?=
 =?us-ascii?Q?Ol8FDCtL6q1whaDRAOYWN9JkVjjzAyvOx8k/ZxjnR6NhqgEuD9MDt4RWIa10?=
 =?us-ascii?Q?HnCkQz1ulP1g6g70lpupPkEaqO0JLs9Ur4l8sBjLyU3whjh9RVenV4aSU58h?=
 =?us-ascii?Q?cWFcmowimVnh81p/VnMgR5hvuyGkiHtsJGhIVljq/3TTbbH/oleNQsN//GAD?=
 =?us-ascii?Q?p2RTY4fMbBpXJO07S2skNTXmRMVPpXug3dMmBtwXdb0iicRpISdcoYamJxmN?=
 =?us-ascii?Q?axWu83z7UD5oGqD+Al7JAvbhQoSZiyQeH7upzbdzeTW/KWDhwjSp3JWBOmjX?=
 =?us-ascii?Q?IKQ0VO0sjoPWKw7s19gdWxE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9eb8dad4-0e6e-4f85-6bbf-08d9f6274e18
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:12.6672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8uDO6HoQsp3Oe0zTM5C/tY2sO3IAm1Js9y26pQAQRLjrl4Oo79j3vay/g3SzOB1TR+MsMGNFahQiFw5alwgVFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4262
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Remove obsolete API mlxsw_core_res_query_enabled(), which is only
relevant for end-of-life SwitchX-2 ASICs. Support for these ASICs was
removed in commit b0d80c013b04 ("mlxsw: Remove Mellanox SwitchX-2 ASIC
support").

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c         |  6 ------
 drivers/net/ethernet/mellanox/mlxsw/core.h         |  2 --
 drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c   |  3 ---
 drivers/net/ethernet/mellanox/mlxsw/core_thermal.c | 12 ------------
 4 files changed, 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1c6c1ea107a1..aefd3eeb3c9f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -177,12 +177,6 @@ void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_driver_priv);
 
-bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core)
-{
-	return mlxsw_core->driver->res_query_enabled;
-}
-EXPORT_SYMBOL(mlxsw_core_res_query_enabled);
-
 bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_core->driver->temp_warn_enabled;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6d304092f4e7..e973c056f0b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -35,8 +35,6 @@ unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
-bool mlxsw_core_res_query_enabled(const struct mlxsw_core *mlxsw_core);
-
 bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core);
 
 bool
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
index 3788d02b5244..8b170ad92302 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_hwmon.c
@@ -655,9 +655,6 @@ static int mlxsw_hwmon_module_init(struct mlxsw_hwmon *mlxsw_hwmon)
 	u8 module_sensor_max;
 	int i, err;
 
-	if (!mlxsw_core_res_query_enabled(mlxsw_hwmon->core))
-		return 0;
-
 	mlxsw_reg_mgpir_pack(mgpir_pl);
 	err = mlxsw_reg_query(mlxsw_hwmon->core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
index 784f9c7650d1..05f54bd982c0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
@@ -746,9 +746,6 @@ mlxsw_thermal_modules_init(struct device *dev, struct mlxsw_core *core,
 	char mgpir_pl[MLXSW_REG_MGPIR_LEN];
 	int i, err;
 
-	if (!mlxsw_core_res_query_enabled(core))
-		return 0;
-
 	mlxsw_reg_mgpir_pack(mgpir_pl);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
@@ -793,9 +790,6 @@ mlxsw_thermal_modules_fini(struct mlxsw_thermal *thermal)
 {
 	int i;
 
-	if (!mlxsw_core_res_query_enabled(thermal->core))
-		return;
-
 	for (i = thermal->tz_module_num - 1; i >= 0; i--)
 		mlxsw_thermal_module_fini(&thermal->tz_module_arr[i]);
 	kfree(thermal->tz_module_arr);
@@ -843,9 +837,6 @@ mlxsw_thermal_gearboxes_init(struct device *dev, struct mlxsw_core *core,
 	int i;
 	int err;
 
-	if (!mlxsw_core_res_query_enabled(core))
-		return 0;
-
 	mlxsw_reg_mgpir_pack(mgpir_pl);
 	err = mlxsw_reg_query(core, MLXSW_REG(mgpir), mgpir_pl);
 	if (err)
@@ -889,9 +880,6 @@ mlxsw_thermal_gearboxes_fini(struct mlxsw_thermal *thermal)
 {
 	int i;
 
-	if (!mlxsw_core_res_query_enabled(thermal->core))
-		return;
-
 	for (i = thermal->tz_gearbox_num - 1; i >= 0; i--)
 		mlxsw_thermal_gearbox_tz_fini(&thermal->tz_gearbox_arr[i]);
 	kfree(thermal->tz_gearbox_arr);
-- 
2.33.1

