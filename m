Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624B168C1F2
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 16:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjBFPmp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 10:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjBFPmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 10:42:15 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8b::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86BC4C04
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 07:41:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V5wIp/ZRDdXx+Df3foMEHv5hiJvAlfae9WmdGgpV4va3xucMPTD1p7yFaaCXPFVTZX5ZIKC2pc8CFghsNcJ0FMui8d0GSSlaUmXYWEDR6Frk2DxbF9T0tRieSpD/+rbaLdqz/HoqkjGZIA6CtCrqWsu2YmzZxPstkKP5DRb8ME0si73lWzcuNNp+0AHo4mIUXm1jleEHHltVh+iHMggCZ7ZKO1pzc9gnar5tjm2KYLihz8LndpYZnoQp9/Xj5snvUYDycfEVRe4B6kQPb0+Sd3ZmtOVICV6L/qWeS1BpTslW2Je46GfPMi1O5bZEDpGLwAUhja+iUZ6i0fAKeJ1n/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GVIA4lYN/ZXzSRvQELMMzK9FZ7qiPIa91d6IEZ4BQso=;
 b=C3pen+zrKj7R9tmZISg9wsxTNUW4IMT2eEdGKFCfwWIh308Udvo97cOVMc9Bik3MXKZzbmO8UnUYpbVaMFJDYoX+KVKpzZzBftYSBzbAdXOMddiUkUU/NUMgWJrNKdfKxLxudAT3ozduGMUzuQOR8EEqg16pXmb6QPP/xFpTSj8TABg178IZmAzSn8AVOCjJWYyfyLyOP5o6D3ii+iwjm3hkIVU1cmN14W8piSwwH8XbeumCmG7vnCOi9hK/uCgT+o/+wNKFiI7cSfPB3+HEc6WOUpEV65vD0/iSJb343qjzx4p8ya+tVmjrVazEdI6bkkHnRtbvTrcuWV+b/rzScA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GVIA4lYN/ZXzSRvQELMMzK9FZ7qiPIa91d6IEZ4BQso=;
 b=jeXBZSKD4Crp9pv8qy0p6wqpwUI/7lu6fn1EidF9d30BvaotrCTLk6uXmj9vfIMPua4WxXI27qAaw+27MvI6IGfyBfqLuJElSHf6XC0bbi+OqZ/EAvf9C+LLdU2rGA/NmDcfJPzJWIOdlmAiuraBO5frRFQT6vZ2Qxt7SvVCquQVhHrQyJa1LnjAr5pFBzSt1VP7lcvIBRFW3569symzG+obdBJM4zEGEbKW0zHzWp3CKvj4Fz0nXupIsKQkXe9RQYz4Pd8F/n6ZHmPfP1mCTMCqLCNQ6j5LL7T+JwpU+93fBMIxdvgtQiifENHVK0eu/gF/WSFb3lkn+XL6I+ObSw==
Received: from BN0PR02CA0039.namprd02.prod.outlook.com (2603:10b6:408:e5::14)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.24; Mon, 6 Feb
 2023 15:40:11 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e5:cafe::cd) by BN0PR02CA0039.outlook.office365.com
 (2603:10b6:408:e5::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.34 via Frontend
 Transport; Mon, 6 Feb 2023 15:40:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6064.34 via Frontend Transport; Mon, 6 Feb 2023 15:40:10 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:59 -0800
Received: from localhost.localdomain (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Mon, 6 Feb 2023
 07:39:56 -0800
From:   Petr Machata <petrm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     Jacob Keller <jacob.e.keller@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        "Danielle Ratson" <danieller@nvidia.com>, <mlxsw@nvidia.com>
Subject: [PATCH net-next 5/6] mlxsw: spectrum_acl_tcam: Move devlink param to TCAM code
Date:   Mon, 6 Feb 2023 16:39:22 +0100
Message-ID: <ddea48c63c1dfc6af57e10e99f4b33a9219cffc1.1675692666.git.petrm@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT011:EE_|DS0PR12MB6413:EE_
X-MS-Office365-Filtering-Correlation-Id: bad81291-a927-426e-a38f-08db08586e6e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYpW8FMj94DcOa0Bc67t/8ahOF8dsMGAFHAX7vyy3R0SP4pN1SprOCNgZkOUy884NEDzJTCfOusqmjIu3AtXiUo7aCtmF3HXc/mYGD5NvDf4gBKxDHXt8+CPBpdUG7kNhd2Fj6YoJVCNCsS16M9jnwQ07qpdt7QpKaYEyzOmCjNsKUP4/GaWRczfFcg5M6uEsZ6YAoKLWgU+0Xc0y1qvHIFe3gxIz5Yah8IMVL6bLpLSipMLc3JmGTz9f5HiDKP+6j+bZbS++T38Zglufyf6BNgWn7S4WB3XahnsTNb4jPu+5HHT0/f16UtlXE2iBoHij/koxucFV+a2ecyJPTyViWBohTh1QuZ6NKQYtDx5BGy3cTpDrX/7ttrt/oHWTo9KwjM5CkveDSfG2NZDepGwSIZc7PqF5fqpMjRCzcDDRGkDnDq2wRq1To0efA61p9kw2qmUjrydYHlTvaRtGRJy8QhAO4Ts3qjTOvDQLYXT3aXnjO0ldxzWtQSK1gvf581RmgQGW8/d3T1pm/Tgwkc2rl9J7YhEQJo8hMnkyKK4TNo2dSCWm4GQrIl5RcFIYkoenP0z0UNtD1k6L2tE9ZH/+hATQF5cXzszNYVvg1ED1T3zUFfYkWsuGC+0wWPKyCQzmbZrTkivgs1Kj7VYz8j3qnBef+hF9qii5gusxvkzv5uW6hh0/3/GS9OGlQlYNxtJ7I5KcZaDmSeTFbgaZGZeGA==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(396003)(39860400002)(376002)(346002)(136003)(451199018)(36840700001)(40470700004)(46966006)(7636003)(6666004)(82740400003)(110136005)(40460700003)(86362001)(5660300002)(107886003)(16526019)(30864003)(36860700001)(36756003)(2616005)(41300700001)(83380400001)(47076005)(40480700001)(336012)(426003)(26005)(186003)(70206006)(356005)(316002)(2906002)(8936002)(70586007)(82310400005)(4326008)(478600001)(54906003)(8676002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2023 15:40:10.3602
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bad81291-a927-426e-a38f-08db08586e6e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Cited commit added 'DEVLINK_CMD_PARAM_DEL' notifications whenever the
network namespace of the devlink instance is changed. Specifically, the
notifications are generated after calling reload_down(), but before
calling reload_up(). At this stage, the data structures accessed while
reading the value of the "acl_region_rehash_interval" devlink parameter
are uninitialized, resulting in a use-after-free [1].

Fix by moving the registration and unregistration of the devlink
parameter to the TCAM code where it is actually used. This means that
the parameter is unregistered during reload_down() and then
re-registered during reload_up(), avoiding the use-after-free between
these two operations.

Reproducer:

 # ip netns add test123
 # devlink dev reload pci/0000:06:00.0 netns test123

[1]
BUG: KASAN: use-after-free in mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get+0xb2/0xd0
Read of size 4 at addr ffff888162fd37d8 by task devlink/1323
[...]
Call Trace:
 <TASK>
 dump_stack_lvl+0x95/0xbd
 print_report+0x181/0x4a1
 kasan_report+0xdb/0x200
 mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get+0xb2/0xd0
 mlxsw_sp_params_acl_region_rehash_intrvl_get+0x32/0x80
 devlink_nl_param_fill.constprop.0+0x29a/0x11e0
 devlink_param_notify.constprop.0+0xb9/0x250
 devlink_notify_unregister+0xbc/0x470
 devlink_reload+0x1aa/0x440
 devlink_nl_cmd_reload+0x559/0x11b0
 genl_family_rcv_msg_doit.isra.0+0x1f8/0x2e0
 genl_rcv_msg+0x558/0x7f0
 netlink_rcv_skb+0x170/0x440
 genl_rcv+0x2d/0x40
 netlink_unicast+0x53f/0x810
 netlink_sendmsg+0x961/0xe80
 __sys_sendto+0x2a4/0x420
 __x64_sys_sendto+0xe5/0x1c0
 do_syscall_64+0x38/0x80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 7d7e9169a3ec ("devlink: move devlink reload notifications back in between _down() and _up() calls")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c    |  19 +--
 drivers/net/ethernet/mellanox/mlxsw/core.h    |   2 -
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  52 --------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   3 +-
 .../ethernet/mellanox/mlxsw/spectrum_acl.c    |  21 +---
 .../mellanox/mlxsw/spectrum_acl_tcam.c        | 118 ++++++++++++------
 .../mellanox/mlxsw/spectrum_acl_tcam.h        |   5 -
 7 files changed, 90 insertions(+), 130 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 42422a106433..a08aec243ad6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1750,29 +1750,12 @@ static const struct devlink_ops mlxsw_devlink_ops = {
 
 static int mlxsw_core_params_register(struct mlxsw_core *mlxsw_core)
 {
-	int err;
-
-	err = mlxsw_core_fw_params_register(mlxsw_core);
-	if (err)
-		return err;
-
-	if (mlxsw_core->driver->params_register) {
-		err = mlxsw_core->driver->params_register(mlxsw_core);
-		if (err)
-			goto err_params_register;
-	}
-	return 0;
-
-err_params_register:
-	mlxsw_core_fw_params_unregister(mlxsw_core);
-	return err;
+	return mlxsw_core_fw_params_register(mlxsw_core);
 }
 
 static void mlxsw_core_params_unregister(struct mlxsw_core *mlxsw_core)
 {
 	mlxsw_core_fw_params_unregister(mlxsw_core);
-	if (mlxsw_core->driver->params_register)
-		mlxsw_core->driver->params_unregister(mlxsw_core);
 }
 
 struct mlxsw_core_health_event {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index a77cb0be7108..e5474d3e34db 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -421,8 +421,6 @@ struct mlxsw_driver {
 			     const struct mlxsw_config_profile *profile,
 			     u64 *p_single_size, u64 *p_double_size,
 			     u64 *p_linear_size);
-	int (*params_register)(struct mlxsw_core *mlxsw_core);
-	void (*params_unregister)(struct mlxsw_core *mlxsw_core);
 
 	/* Notify a driver that a timestamped packet was transmitted. Driver
 	 * is responsible for freeing the passed-in SKB.
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index b150e97b97b7..a8f94b7544ee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3861,52 +3861,6 @@ static int mlxsw_sp_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 	return 0;
 }
 
-static int
-mlxsw_sp_params_acl_region_rehash_intrvl_get(struct devlink *devlink, u32 id,
-					     struct devlink_param_gset_ctx *ctx)
-{
-	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-
-	ctx->val.vu32 = mlxsw_sp_acl_region_rehash_intrvl_get(mlxsw_sp);
-	return 0;
-}
-
-static int
-mlxsw_sp_params_acl_region_rehash_intrvl_set(struct devlink *devlink, u32 id,
-					     struct devlink_param_gset_ctx *ctx)
-{
-	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
-
-	return mlxsw_sp_acl_region_rehash_intrvl_set(mlxsw_sp, ctx->val.vu32);
-}
-
-static const struct devlink_param mlxsw_sp2_devlink_params[] = {
-	DEVLINK_PARAM_DRIVER(MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
-			     "acl_region_rehash_interval",
-			     DEVLINK_PARAM_TYPE_U32,
-			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
-			     mlxsw_sp_params_acl_region_rehash_intrvl_get,
-			     mlxsw_sp_params_acl_region_rehash_intrvl_set,
-			     NULL),
-};
-
-static int mlxsw_sp2_params_register(struct mlxsw_core *mlxsw_core)
-{
-	struct devlink *devlink = priv_to_devlink(mlxsw_core);
-
-	return devl_params_register(devlink, mlxsw_sp2_devlink_params,
-				    ARRAY_SIZE(mlxsw_sp2_devlink_params));
-}
-
-static void mlxsw_sp2_params_unregister(struct mlxsw_core *mlxsw_core)
-{
-	devl_params_unregister(priv_to_devlink(mlxsw_core),
-			       mlxsw_sp2_devlink_params,
-			       ARRAY_SIZE(mlxsw_sp2_devlink_params));
-}
-
 static void mlxsw_sp_ptp_transmitted(struct mlxsw_core *mlxsw_core,
 				     struct sk_buff *skb, u16 local_port)
 {
@@ -3984,8 +3938,6 @@ static struct mlxsw_driver mlxsw_sp2_driver = {
 	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
-	.params_register		= mlxsw_sp2_params_register,
-	.params_unregister		= mlxsw_sp2_params_unregister,
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
@@ -4023,8 +3975,6 @@ static struct mlxsw_driver mlxsw_sp3_driver = {
 	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
-	.params_register		= mlxsw_sp2_params_register,
-	.params_unregister		= mlxsw_sp2_params_unregister,
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp2_config_profile,
@@ -4060,8 +4010,6 @@ static struct mlxsw_driver mlxsw_sp4_driver = {
 	.trap_policer_counter_get	= mlxsw_sp_trap_policer_counter_get,
 	.txhdr_construct		= mlxsw_sp_txhdr_construct,
 	.resources_register		= mlxsw_sp2_resources_register,
-	.params_register		= mlxsw_sp2_params_register,
-	.params_unregister		= mlxsw_sp2_params_unregister,
 	.ptp_transmitted		= mlxsw_sp_ptp_transmitted,
 	.txhdr_len			= MLXSW_TXHDR_LEN,
 	.profile			= &mlxsw_sp4_config_profile,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index bbc73324451d..4c22f8004514 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -973,6 +973,7 @@ enum mlxsw_sp_acl_profile {
 };
 
 struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl);
+struct mlxsw_sp_acl_tcam *mlxsw_sp_acl_to_tcam(struct mlxsw_sp_acl *acl);
 
 int mlxsw_sp_acl_ruleset_bind(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_flow_block *block,
@@ -1096,8 +1097,6 @@ mlxsw_sp_acl_act_cookie_lookup(struct mlxsw_sp *mlxsw_sp, u32 cookie_index)
 
 int mlxsw_sp_acl_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_acl_fini(struct mlxsw_sp *mlxsw_sp);
-u32 mlxsw_sp_acl_region_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp);
-int mlxsw_sp_acl_region_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp, u32 val);
 
 struct mlxsw_sp_acl_mangle_action;
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 6c5af018546f..0423ac262d89 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -40,6 +40,11 @@ struct mlxsw_afk *mlxsw_sp_acl_afk(struct mlxsw_sp_acl *acl)
 	return acl->afk;
 }
 
+struct mlxsw_sp_acl_tcam *mlxsw_sp_acl_to_tcam(struct mlxsw_sp_acl *acl)
+{
+	return &acl->tcam;
+}
+
 struct mlxsw_sp_acl_ruleset_ht_key {
 	struct mlxsw_sp_flow_block *block;
 	u32 chain_index;
@@ -1099,22 +1104,6 @@ void mlxsw_sp_acl_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(acl);
 }
 
-u32 mlxsw_sp_acl_region_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp)
-{
-	struct mlxsw_sp_acl *acl = mlxsw_sp->acl;
-
-	return mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get(mlxsw_sp,
-							   &acl->tcam);
-}
-
-int mlxsw_sp_acl_region_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp, u32 val)
-{
-	struct mlxsw_sp_acl *acl = mlxsw_sp->acl;
-
-	return mlxsw_sp_acl_tcam_vregion_rehash_intrvl_set(mlxsw_sp,
-							   &acl->tcam, val);
-}
-
 struct mlxsw_sp_acl_rulei_ops mlxsw_sp1_acl_rulei_ops = {
 	.act_mangle_field = mlxsw_sp1_acl_rulei_act_mangle_field,
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
index dbc2f834f859..d50786b0a6ce 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.c
@@ -9,6 +9,7 @@
 #include <linux/rhashtable.h>
 #include <linux/netdevice.h>
 #include <linux/mutex.h>
+#include <net/devlink.h>
 #include <trace/events/mlxsw.h>
 
 #include "reg.h"
@@ -832,41 +833,6 @@ mlxsw_sp_acl_tcam_vregion_destroy(struct mlxsw_sp *mlxsw_sp,
 	kfree(vregion);
 }
 
-u32 mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_acl_tcam *tcam)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-	u32 vregion_rehash_intrvl;
-
-	if (WARN_ON(!ops->region_rehash_hints_get))
-		return 0;
-	vregion_rehash_intrvl = tcam->vregion_rehash_intrvl;
-	return vregion_rehash_intrvl;
-}
-
-int mlxsw_sp_acl_tcam_vregion_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_acl_tcam *tcam,
-						u32 val)
-{
-	const struct mlxsw_sp_acl_tcam_ops *ops = mlxsw_sp->acl_tcam_ops;
-	struct mlxsw_sp_acl_tcam_vregion *vregion;
-
-	if (val < MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_MIN && val)
-		return -EINVAL;
-	if (WARN_ON(!ops->region_rehash_hints_get))
-		return -EOPNOTSUPP;
-	tcam->vregion_rehash_intrvl = val;
-	mutex_lock(&tcam->lock);
-	list_for_each_entry(vregion, &tcam->vregion_list, tlist) {
-		if (val)
-			mlxsw_core_schedule_dw(&vregion->rehash.dw, 0);
-		else
-			cancel_delayed_work_sync(&vregion->rehash.dw);
-	}
-	mutex_unlock(&tcam->lock);
-	return 0;
-}
-
 static struct mlxsw_sp_acl_tcam_vregion *
 mlxsw_sp_acl_tcam_vregion_get(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_acl_tcam_vgroup *vgroup,
@@ -1481,6 +1447,81 @@ mlxsw_sp_acl_tcam_vregion_rehash(struct mlxsw_sp *mlxsw_sp,
 		mlxsw_sp_acl_tcam_vregion_rehash_end(mlxsw_sp, vregion, ctx);
 }
 
+static int
+mlxsw_sp_acl_tcam_region_rehash_intrvl_get(struct devlink *devlink, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_sp_acl_tcam *tcam;
+	struct mlxsw_sp *mlxsw_sp;
+
+	mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	tcam = mlxsw_sp_acl_to_tcam(mlxsw_sp->acl);
+	ctx->val.vu32 = tcam->vregion_rehash_intrvl;
+
+	return 0;
+}
+
+static int
+mlxsw_sp_acl_tcam_region_rehash_intrvl_set(struct devlink *devlink, u32 id,
+					   struct devlink_param_gset_ctx *ctx)
+{
+	struct mlxsw_core *mlxsw_core = devlink_priv(devlink);
+	struct mlxsw_sp_acl_tcam_vregion *vregion;
+	struct mlxsw_sp_acl_tcam *tcam;
+	struct mlxsw_sp *mlxsw_sp;
+	u32 val = ctx->val.vu32;
+
+	if (val < MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_MIN && val)
+		return -EINVAL;
+
+	mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
+	tcam = mlxsw_sp_acl_to_tcam(mlxsw_sp->acl);
+	tcam->vregion_rehash_intrvl = val;
+	mutex_lock(&tcam->lock);
+	list_for_each_entry(vregion, &tcam->vregion_list, tlist) {
+		if (val)
+			mlxsw_core_schedule_dw(&vregion->rehash.dw, 0);
+		else
+			cancel_delayed_work_sync(&vregion->rehash.dw);
+	}
+	mutex_unlock(&tcam->lock);
+	return 0;
+}
+
+static const struct devlink_param mlxsw_sp_acl_tcam_rehash_params[] = {
+	DEVLINK_PARAM_DRIVER(MLXSW_DEVLINK_PARAM_ID_ACL_REGION_REHASH_INTERVAL,
+			     "acl_region_rehash_interval",
+			     DEVLINK_PARAM_TYPE_U32,
+			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			     mlxsw_sp_acl_tcam_region_rehash_intrvl_get,
+			     mlxsw_sp_acl_tcam_region_rehash_intrvl_set,
+			     NULL),
+};
+
+static int mlxsw_sp_acl_tcam_rehash_params_register(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+
+	if (!mlxsw_sp->acl_tcam_ops->region_rehash_hints_get)
+		return 0;
+
+	return devl_params_register(devlink, mlxsw_sp_acl_tcam_rehash_params,
+				    ARRAY_SIZE(mlxsw_sp_acl_tcam_rehash_params));
+}
+
+static void
+mlxsw_sp_acl_tcam_rehash_params_unregister(struct mlxsw_sp *mlxsw_sp)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+
+	if (!mlxsw_sp->acl_tcam_ops->region_rehash_hints_get)
+		return;
+
+	devl_params_unregister(devlink, mlxsw_sp_acl_tcam_rehash_params,
+			       ARRAY_SIZE(mlxsw_sp_acl_tcam_rehash_params));
+}
+
 int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_acl_tcam *tcam)
 {
@@ -1495,6 +1536,10 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 			MLXSW_SP_ACL_TCAM_VREGION_REHASH_INTRVL_DFLT;
 	INIT_LIST_HEAD(&tcam->vregion_list);
 
+	err = mlxsw_sp_acl_tcam_rehash_params_register(mlxsw_sp);
+	if (err)
+		goto err_rehash_params_register;
+
 	max_tcam_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core,
 					      ACL_MAX_TCAM_REGIONS);
 	max_regions = MLXSW_CORE_RES_GET(mlxsw_sp->core, ACL_MAX_REGIONS);
@@ -1531,6 +1576,8 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 err_alloc_used_groups:
 	bitmap_free(tcam->used_regions);
 err_alloc_used_regions:
+	mlxsw_sp_acl_tcam_rehash_params_unregister(mlxsw_sp);
+err_rehash_params_register:
 	mutex_destroy(&tcam->lock);
 	return err;
 }
@@ -1543,6 +1590,7 @@ void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 	ops->fini(mlxsw_sp, tcam->priv);
 	bitmap_free(tcam->used_groups);
 	bitmap_free(tcam->used_regions);
+	mlxsw_sp_acl_tcam_rehash_params_unregister(mlxsw_sp);
 	mutex_destroy(&tcam->lock);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
index edbbc89e7a71..462bf448497d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl_tcam.h
@@ -29,11 +29,6 @@ int mlxsw_sp_acl_tcam_init(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_acl_tcam *tcam);
 void mlxsw_sp_acl_tcam_fini(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_acl_tcam *tcam);
-u32 mlxsw_sp_acl_tcam_vregion_rehash_intrvl_get(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_acl_tcam *tcam);
-int mlxsw_sp_acl_tcam_vregion_rehash_intrvl_set(struct mlxsw_sp *mlxsw_sp,
-						struct mlxsw_sp_acl_tcam *tcam,
-						u32 val);
 int mlxsw_sp_acl_tcam_priority_get(struct mlxsw_sp *mlxsw_sp,
 				   struct mlxsw_sp_acl_rule_info *rulei,
 				   u32 *priority, bool fillup_priority);
-- 
2.39.0

