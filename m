Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 875AD4C0004
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234614AbiBVRTH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:19:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiBVRTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:19:06 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0CBD16E7F3
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:18:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aClQRcAJLpRm9FhR8TN63IUZk7FDGv48tZeA9biPC29BuYUFro5KXvC84KGDk2uKmAag94dxhDjgXptfwbUz53estxgea0md53TeyhITtM9GM3DQuZK3nBk5hV5iu2MySiu/D2+uqRezhmuOwdjdF+Vfw5VTIqKxpmiOOFEOIBj9Kd4l46eld2tSc+7gLhaEAa9Ed6cEsWraeWo5wEMtnL3MyF5bsT/bDkOeHOtQv9n3VNiavnFTvA1IKxi683BhvKkCXuk0JxtB59FXPYJyeldTcF4uWypFHyWpsiLIf4Cf3JTVEg/T0N+rOHkRw73nN5XqanI3bU1K/WCok6aemw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhcTCNXDssSJhfiWHprxoMxKE/2ZXUIA/7fe2pbOh+E=;
 b=aSKt+zlc4d2MOlgD/lkeu1bY7CyOHZLAlzp9EmVQKqy/qgwIi65Ekh0cGkEB4mvZBNy54PRHhfBZvP/vnTehp4LV0KhLOrVQ0qMGx15+LqhZrtQYLkEwfK3+l5GD/XRkRP+EHz5rVwYzVkvXZ2fjmJqXuNv755Tzp0zljbhlgaI/5dD34gFLlysXTMArLebrR3iFeFrZoKpZ5QkRKD0f2rNqnCrmNb5CA7jqOK4/80rBkoNozLWXGebxn6gY/5DLlrmY5ciahZzpNh2/x0uHUqK/Jw1QvFoparjbRYMOt3EsAzK0HOYpxtc+MLBgX7tQQFva4LRJjU3h0z3nBN/XxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhcTCNXDssSJhfiWHprxoMxKE/2ZXUIA/7fe2pbOh+E=;
 b=UFOR0bHP80yy31ikuFZmv46D7ROxcqHmgWkTQjiw8l34GNKhJ3Q1cdrColp/mZdTmGaNsaD2O4MUYzYTzZY39WAtUbO8R2j4oKruikN4NB7CF3btJf9megYCb+PIFtjU4qBCFgTjNfsXspvPnQBxflYeaTDmqjSb7T9ccMY0ULbHdwDTbvqPSwIMW8BW2xajxitWHnYPStwYEbKy7x3hRUl+zRqUDJmse+regrJ1jiJuUTdp78k9SLsEYXuK4s8oaSelB0DazRFvviDzO0TiMWJ72H58u76ddbPNVAcCQXl5gX1l5AmOPG04+7js0oYOIy9S6yQ2ebn5Jf8PY+An1g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CH2PR12MB4262.namprd12.prod.outlook.com (2603:10b6:610:af::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.14; Tue, 22 Feb
 2022 17:18:39 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:18:39 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/12] mlxsw: core: Unify method of trap support validation
Date:   Tue, 22 Feb 2022 19:17:01 +0200
Message-Id: <20220222171703.499645-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0022.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::35) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6afed1e9-2dc9-4347-57a6-08d9f6275de4
X-MS-TrafficTypeDiagnostic: CH2PR12MB4262:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB426246C24B8E58EE04BD4AD9B23B9@CH2PR12MB4262.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xHYuO+9LPidPfKua07VSOVOPuhQXypBZNDhJd+L0Ognu+h3hCCBzCA+kZmVawvZ8QDv/MxNXie8jNsyVkXxJ6p3dPxthFsVa1i39bvfGaH/wyxirfrXM/XLURCYQJrfYlMI8xoxj/TcrZpzNqBH8Tt0pmKr82UB1jf52/sY4NzmA5eeF8uz12eIsYQP1ghP72VabmmHo4TNt+TzyfscnNOY9bDn+BMjaadXa2g5m+/ChpjL4VPWmmTUDEZ0HPX17mNVyDqhHpqp4W2dI1lvss0zpUAJUE+ibxtsXKM66V0RQv3okV4SAPJ3YjHDXtAdFP5C36urb65J7Uu1lv41g2mvlXdO4a2a90//zg54LbkmQprDX5PKi4WhEhJACJyBz/PZIj0/4ArX0oKyVisWMz2MgVxtxILzp3uOOC2lp+6rk2SWCHb+D1dkAbyI8vk/5hMIKHcPAuSrvn1PSO7NAaFkI0WiL8+WGYXaFGj/RUL6ouodjb6bF/i2zVUkf9SXhoSoeBAF2qK1zmbBcjxrWXcpP0nltYbRPVv2fBnAAziPAWpSae86hLlI9f8bmm/L2NimYJi8yucfeAckREZm7NefSBHxdx4vvdlmOclrqyL8C3i1KTzKr466MuA2xHGtXa2bzoYjMSwkQtEJ2LchPMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66556008)(6916009)(66476007)(83380400001)(508600001)(4326008)(36756003)(8676002)(6666004)(6506007)(6486002)(5660300002)(186003)(107886003)(26005)(1076003)(86362001)(316002)(2906002)(8936002)(38100700002)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VPycAx5W9xMeIbwdb/GAu0bVoUPXN0dXnh2Cwpu1XXjJ4fkssbhLakz/VfPa?=
 =?us-ascii?Q?rtn5a4HJsAYbRWE7UpteL7JQ2ipEkEcZuDZDiSnZIv6zImq8sUppQEoKSkWn?=
 =?us-ascii?Q?pfl1S2+w50Yb/noa47zAY3Ymw536vCoP1xryQ1AhzleENd+d00hfblybOM45?=
 =?us-ascii?Q?Awbg1ZfPL5m0tkTWUi24Oq1GmO/qd4c2P2OUwfsnDh20fNHsaPuLmrTFQ8Ze?=
 =?us-ascii?Q?ZkSJ97o0koFc3UzlFJanuxwD82IRIAYHvticlELUpCQiLdTVL7sLLlJK0L9h?=
 =?us-ascii?Q?jLpeEHDpDO+wS6wuhKpwZZVu7xOXl1EeNR5cCY4N7agdDIzHg2zxdA4GsMjY?=
 =?us-ascii?Q?aZI05BPHFGvlpFdqr+oKdwL1PjI1Ax64QC4/8dap9OD/MzVjjtGpye7qv7wF?=
 =?us-ascii?Q?0CXh/TzqiM5qVNs2RTkQ9ESqxDwmgRc25oc/PVc9qtJapv1WDw0C0IAcUgDa?=
 =?us-ascii?Q?CRm16bQQv+qehTpcfEyHUgD31uplUEfSm+nTQ3Vj8Zrvl0Yu8mYp2k4okq5B?=
 =?us-ascii?Q?rveqV9m8e2DkPeSgEnOC7LToW08T0DdrAP1OouQa3YC/xem1b9mgpE5yjBQv?=
 =?us-ascii?Q?YvVd4eED+ZGP/rO+rKKwe5MlKgbYK9YTbiv8yud43HjoJdxQeruTsf+poASo?=
 =?us-ascii?Q?Wscg1slTBbGE4SAHK0pU7kea3mzWrk4dY32/BCGygzL4GFeiKo42PIJy/bC6?=
 =?us-ascii?Q?Y07O56+f68iIIYmiLzRaUJtNJTsf7BepBaSUHX1ONQnqrAxILQ0qRQkwWCYO?=
 =?us-ascii?Q?/BcLeoQpA4DMyYClUimQI+84FRAE7F0qSoAQMNnnyu9zggMyoIQwwLGi3ctQ?=
 =?us-ascii?Q?IXBE+iK5uxL7xSaYGQIJZg+RTpr4I0XKvvLspyBWDnxU8FjvKL9S3ZsvKjFP?=
 =?us-ascii?Q?TnWolvhMhWuUa/Ih3q/saRsYacyO/xxl1sKQj+CDXGsCSZyVUXifhGO32eQk?=
 =?us-ascii?Q?L0Zlxe8rJh3K8pvLeSD3xU0JrvvqZ+FYFj671wp8EwR/YnYj47BWi2YODBHh?=
 =?us-ascii?Q?T5Pjir48WoLCj4vDtU4oI6qgZo1SRX5QOUwYqc+1dunIWJ7rglVh0Q7wUQA2?=
 =?us-ascii?Q?N7RI/KumK/PHtTG3qLIQldsIpkFW8gxav3Cr+PVgYe8GF/0BB1mevew15XpW?=
 =?us-ascii?Q?v/ZbHx0QbfifBLSzsaNo6YIGexfv7CB9SP4ZoGk5nDH/uiWzwDs6yggow3ps?=
 =?us-ascii?Q?tAStV0hRHR/+0Ij7F26jCYM3O9an2w2Dsuc/T36cX5VSWc2sRZS9nGHsgrpY?=
 =?us-ascii?Q?ixD+lu6sU+0tOO8DpfIAnGOhGm7Uen4zAke1IF+BuUCCgx0lAvGgfMNv6vi9?=
 =?us-ascii?Q?4zEPWc83UwMLEnYmzYW9m8eSU/w//YXO8eKNnRrBRC43Cz1lqOvzjXOaJ+OB?=
 =?us-ascii?Q?rMbkzK9JyAtqNIy8BEQpIVtiHBdM4JsgaXMA4mlYo2bNIaBzKptChGK/67WG?=
 =?us-ascii?Q?SlbxgZ41kurmktC2j2F43mQ0CDsti8zRje9q7uv4NE7X7caU5LhaOH/RzD47?=
 =?us-ascii?Q?i8wcDcOWCUTApOrAumui+BEyhUoaZajixdVxnmZgODQ8zWdRk3laaemeoJXb?=
 =?us-ascii?Q?3z17bxyXnR1QFQ3O9PBmAZNC9ZxhbkJdzRT8+aB9K865ntylQCXt3ZmRuLSh?=
 =?us-ascii?Q?+RWPxR40j0xaMVZoeSrOD+0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6afed1e9-2dc9-4347-57a6-08d9f6275de4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:18:39.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YeffAN6fWo350bcjL3Qq4kRFXaJXXXHU+Yn5grcwh2peMDgGUVTGzi5iQjWqzEYf7PwjIxcMyKjZGRpR//pCug==
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

Currently there are several different features defined in 'mlxsw_driver'
for trap support validation. There is no reason to have dedicated
features for specific traps. Perform validation of all of them by
testing feature 'MLXSW_BUS_F_TXRX'.

Remove trap capability validation from 'core_env.c' which is redundant
after validation has been added to mlxsw_core_trap_register().

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     |  9 ++-------
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  4 ----
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 12 ------------
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  8 --------
 4 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index aefd3eeb3c9f..4edaa84cd785 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -177,11 +177,6 @@ void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core)
 }
 EXPORT_SYMBOL(mlxsw_core_driver_priv);
 
-bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core)
-{
-	return mlxsw_core->driver->temp_warn_enabled;
-}
-
 bool
 mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 					  const struct mlxsw_fw_rev *req_rev)
@@ -2033,7 +2028,7 @@ static int mlxsw_core_health_init(struct mlxsw_core *mlxsw_core)
 	struct devlink_health_reporter *fw_fatal;
 	int err;
 
-	if (!mlxsw_core->driver->fw_fatal_enabled)
+	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
 		return 0;
 
 	fw_fatal = devlink_health_reporter_create(devlink, &mlxsw_core_health_fw_fatal_ops,
@@ -2063,7 +2058,7 @@ static int mlxsw_core_health_init(struct mlxsw_core *mlxsw_core)
 
 static void mlxsw_core_health_fini(struct mlxsw_core *mlxsw_core)
 {
-	if (!mlxsw_core->driver->fw_fatal_enabled)
+	if (!(mlxsw_core->bus->features & MLXSW_BUS_F_TXRX))
 		return;
 
 	mlxsw_core_health_fw_fatal_config(mlxsw_core, false);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index e973c056f0b4..14ae18e8c6f4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -35,8 +35,6 @@ unsigned int mlxsw_core_max_ports(const struct mlxsw_core *mlxsw_core);
 
 void *mlxsw_core_driver_priv(struct mlxsw_core *mlxsw_core);
 
-bool mlxsw_core_temp_warn_enabled(const struct mlxsw_core *mlxsw_core);
-
 bool
 mlxsw_core_fw_rev_minor_subminor_validate(const struct mlxsw_fw_rev *rev,
 					  const struct mlxsw_fw_rev *req_rev);
@@ -405,8 +403,6 @@ struct mlxsw_driver {
 	u8 txhdr_len;
 	const struct mlxsw_config_profile *profile;
 	bool res_query_enabled;
-	bool fw_fatal_enabled;
-	bool temp_warn_enabled;
 };
 
 int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index 5809ebf35535..70e283d22783 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -822,9 +822,6 @@ static int mlxsw_env_temp_warn_event_register(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (!mlxsw_core_temp_warn_enabled(mlxsw_core))
-		return 0;
-
 	return mlxsw_core_trap_register(mlxsw_core,
 					&mlxsw_env_temp_warn_listener,
 					mlxsw_env);
@@ -832,9 +829,6 @@ static int mlxsw_env_temp_warn_event_register(struct mlxsw_core *mlxsw_core)
 
 static void mlxsw_env_temp_warn_event_unregister(struct mlxsw_env *mlxsw_env)
 {
-	if (!mlxsw_core_temp_warn_enabled(mlxsw_env->core))
-		return;
-
 	mlxsw_core_trap_unregister(mlxsw_env->core,
 				   &mlxsw_env_temp_warn_listener, mlxsw_env);
 }
@@ -913,9 +907,6 @@ mlxsw_env_module_plug_event_register(struct mlxsw_core *mlxsw_core)
 {
 	struct mlxsw_env *mlxsw_env = mlxsw_core_env(mlxsw_core);
 
-	if (!mlxsw_core_temp_warn_enabled(mlxsw_core))
-		return 0;
-
 	return mlxsw_core_trap_register(mlxsw_core,
 					&mlxsw_env_module_plug_listener,
 					mlxsw_env);
@@ -924,9 +915,6 @@ mlxsw_env_module_plug_event_register(struct mlxsw_core *mlxsw_core)
 static void
 mlxsw_env_module_plug_event_unregister(struct mlxsw_env *mlxsw_env)
 {
-	if (!mlxsw_core_temp_warn_enabled(mlxsw_env->core))
-		return;
-
 	mlxsw_core_trap_unregister(mlxsw_env->core,
 				   &mlxsw_env_module_plug_listener,
 				   mlxsw_env);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index e39de7e28be9..da6023def6ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3628,8 +3628,6 @@ static struct mlxsw_driver mlxsw_sp1_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp1_config_profile,
 	.res_query_enabled		= true,
-	.fw_fatal_enabled		= true,
-	.temp_warn_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp2_driver = {
@@ -3668,8 +3666,6 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
-	.fw_fatal_enabled		= true,
-	.temp_warn_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp3_driver = {
@@ -3708,8 +3704,6 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
-	.fw_fatal_enabled		= true,
-	.temp_warn_enabled		= true,
 };
 
 static struct mlxsw_driver mlxsw_sp4_driver = {
@@ -3746,8 +3740,6 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
 	.res_query_enabled		= true,
-	.fw_fatal_enabled		= true,
-	.temp_warn_enabled		= true,
 };
 
 bool mlxsw_sp_port_dev_check(const struct net_device *dev)
-- 
2.33.1

