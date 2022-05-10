Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE21520D67
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 07:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbiEJGCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 02:02:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236903AbiEJGB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 02:01:59 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2073.outbound.protection.outlook.com [40.107.94.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00395266E12
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 22:58:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mqTOJtlVeHHP0ZgCc4PSO9w3qJfGBipkGCLmevgxKRFCU4aHThidbTnFTPoTGfzpttgBtNPXzS4oa8dZVcpZDsTmG+z7sjdbms+jle9eygcdNmzlBMEcF3FgDeM38JvjUFHW1edqQ/PsvBlYGJhY0g7G3tSJ0Yioai7HaSalKRirWuMmi8HrkdTGcMmmohiVGm5YgMLOMBAb7wdIYu80sK8+n1HmB7ymAxxH3RNSwtHlmQl1MaJceoMpxTUM+e7GzK8lTdNbLk1XRnoQhXXXm31BgYL1UarmFADzqDu5MXldpEaZPyJRshoJsT+/IhheCFfP+2xRHC1W6NlWMOmLDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HR/4J6VUpH5QXp+aXrBy4jb4ZBqVASTmzoAuqJQtJyQ=;
 b=XQcQxlDLk9RNN1W9/AbCA+tcWbMYq+TgOk2h/+1WLiJgGuZsBR3MfUow/suW1/p+2pS+0aE9HnUU/PILQW69fy6ZiLpfwLPdG6HYfjMR80h8vHz42CViWc0ApmWGAqMUqLCH3O3hDKzH9wZoWSIRHUbR3pLSCnzcNI84PZBOf+Qd5dT+gOXPGFvUbjGO0PKa22z0Xtao0gJ0DZ5NYvtrvzKcgejZoNWGw7sdLch9PuxcLEr9Z7qsEhOJwDI3w3GZpf7LaNC4P13CYTIfDWWnJlkgHqJPFSxym0zDySOxN5WmR9dN91SauwyAbTT+I6EbX8WPcb15Q8T/nhPnFll+UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HR/4J6VUpH5QXp+aXrBy4jb4ZBqVASTmzoAuqJQtJyQ=;
 b=r1nyqzGTCxXaW/awGNeap+FOES6SKAMmyLy1bzKr+tjv5b6xNSAGcrwj09vKHQ19bPCmglU++DvoOsnzBumkVE/nTxp4qhTQgY8GfcwSPv72OkBe0LvD9kSdpuD0UhO+5ZXIlqhsrY1UbT5zVDcAax/p0cT5duTiiMUVoX1hIfKj2ZH/tMzQaAWSDz8xUSAKTq6v1pV9mpA9kyVEH+5JDMsaK1VKMRKNQfahfP0TSwmSnbGVHSJNUDlr6hYYiszY03a3eV3kYkHPtb5mT6kUSBopRVKjwYc+apnD7GzEYuglSvlRAIAmIasjvFcx2P+C0OtqOEFEdigt8UM8otS21A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.25; Tue, 10 May
 2022 05:58:01 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::bcda:499a:1cc1:abca%4]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 05:58:01 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Gavin Li <gavinl@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 02/15] net/mlx5: Increase FW pre-init timeout for health recovery
Date:   Mon,  9 May 2022 22:57:30 -0700
Message-Id: <20220510055743.118828-3-saeedm@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220510055743.118828-1-saeedm@nvidia.com>
References: <20220510055743.118828-1-saeedm@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0017.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::30) To BY5PR12MB4209.namprd12.prod.outlook.com
 (2603:10b6:a03:20d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46231ab5-dd0f-48a7-aa03-08da324a0a7f
X-MS-TrafficTypeDiagnostic: CY5PR12MB6383:EE_
X-Microsoft-Antispam-PRVS: <CY5PR12MB638314553876C39B86B4402AB3C99@CY5PR12MB6383.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ND9mcrjHm5tR8KMy03LiSdf/nHJHXaNztk79HLVMGXKs7DimB0IcJMdbT0RTHtJ3JeNMa/XmJosqaPf2sKtlWFiaxK6IzOEywyHY+c8Qk0bpyKtoyTQ9PIrtak3HAqU8UypsD87E59EgITQRzJe6rEvnNowfjPrMGNyzpDRumFtnF1kIUZiDz0acr9Ys599aOBtVngVBqffLcYGRng7CTkfeqBfWzrI1A5CUHN8ZSK2e6w9QTNfyDHS9sePn9IjR8Ehv4dxk5gj6F4Vr7SARRfO0cHEqMDwJo0+tOm4h61MShNEAlllW2JeHEQxTJtpUhdcVAsUG2AtgNS/Ls/ruP7ZDGYDHWX0mkXh8jrBS36ET/nN9g0eMRFVVk8Lq24KH3fn9hwjmxbAvaQgCUFqqY/nll26T8BP6MJUxMTpHRtZ+Q6EbPebT7fbEgibxIoC6CaBliRa6EU3k25lXqigkcr5BBK7fghjlEPn/k+ldbv15+3/aLflDXvj59pyotqb7t0Kou8mGWSh7n3x6CPQNnKnLdwfgpyBImfW8RDtwEN2CcyKfHcyjBr5nHPdt/Ca+B924EuamW9cd1/qnpCwIw6j8OjMoXuI4piBbu1F4KHfwWFwSmQBiq/1JT7oykUq2JLkt7U9UyLRtXsl4LcjO3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(110136005)(316002)(8676002)(36756003)(2906002)(6506007)(107886003)(2616005)(1076003)(83380400001)(38100700002)(186003)(4326008)(8936002)(6486002)(5660300002)(508600001)(6666004)(66556008)(66946007)(66476007)(86362001)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zzUDbOdx584ou57jPg2MZiyOfeHWtAFEqsXyhBGNy4VBX4Coy2eUEvG7bKQ8?=
 =?us-ascii?Q?F5KdYszOWWD7Wfa73Bs+CPTzmopbgxv1KLCoa+8hIiHZ166MShEubbVh3d/v?=
 =?us-ascii?Q?+qxZ4u+/wDtXl45eL6TUU4epbgSo1UF1QOS+GkZqgfTR4hveanxDrd7krJHp?=
 =?us-ascii?Q?CMS1afAsn0FQxNXU8GPuVMwITSehxGSu9LfLjMago7PNE1j4DjpNi8ymo19b?=
 =?us-ascii?Q?YKCdCK7rO4K9L4Rhv/gHajNbLDxTazi6oafBN1bmsN3gjP/1hYPBRLGGSX79?=
 =?us-ascii?Q?p/DbpA2qGO0X86LAszEGyxOyq0Yx6Okwm8fP9Ubq1GB/HQsNnktMrOObwFjl?=
 =?us-ascii?Q?LgqoRpEvPkfXuACHlI6MiJNDC6rNeXRcxdhCXzpbyW+vRSs0/PfZ23VpwcGQ?=
 =?us-ascii?Q?nbwhbEdCyT6gm/1wofJslx101wNqh5UzIvg6q3wrrebw2HPWhah3fVH/xVcA?=
 =?us-ascii?Q?9Jy+pT9ShECqE/KGf2gWa1AFrSQ/9FMZQgY1lRgFq7K++sJzjutIXtEIidq/?=
 =?us-ascii?Q?9YpmwiTP3rWwWGKLyojzENE9R8YKjermT5EdUFjIB56saLzfwQbcIsn4mUcW?=
 =?us-ascii?Q?0Qow/180KRxPeSqmOlI60/MWlaiW9Wg1mTIjVRjvo6RFMYqOo1wDckasBYcm?=
 =?us-ascii?Q?ghdtsLLWUmg8JOvT9tBHbZq9OjFV0iDEuAjSIU5NDmcts0Inb320qs3DERP8?=
 =?us-ascii?Q?3ijwykLw/toA2NwTIQSzNfcU/D5sOYvZLrf5Whz99XrDxEUMRWY2qKHV7F8K?=
 =?us-ascii?Q?zlFxMmXbhE9DuDLvxL2idCsyu7B3y6o1EbUf0v3ykJ6OzaVL/1u/4tbbVK0N?=
 =?us-ascii?Q?P8Q+6nFRscYBJcHwRU2Lbg2369JVvkZE/MMFe6cuHes9WwWai3Y/HEfgnY5u?=
 =?us-ascii?Q?wjCeMQ+UVQYoSP4rWr0CTTM8/zzhF62Q8+Quc+AhOU0YmRMrk+xCayNq/tNN?=
 =?us-ascii?Q?OEJhjJ0ncA9GxqEApqb0l76V+1W/SkKT5Hud3g/3eqxR0NUzOi8kK/JbIYqd?=
 =?us-ascii?Q?jEITwm7aYFwxJX0S2eSUAa8i2YG9qrj/S1MLn5GqvARrliZA6A2fFPAWEQIh?=
 =?us-ascii?Q?hMyHqOusYhsWwYcdzO2QioaheQSttAhiROiHSGF+Xgy7CA0QAdLwgCdMOMTV?=
 =?us-ascii?Q?dAA2DtTAzvduXbGaZ6qo2NsU61k87EzrSJUSk7djxc4uCfDYJGFcfisgWfH7?=
 =?us-ascii?Q?TKs7UTkxvImCoGLJHLR04AwJQoZvj7gpNFHkbuw8F2HfbaTUXY9Sb2UItQ5y?=
 =?us-ascii?Q?UC16NX49Aehf8Ya2DmgwWrZcf5Y2FLgzKWA9c1L4xnRAFXUrlrAlUsWaaBXV?=
 =?us-ascii?Q?/Oj2ka9Ykl9+EatiSs4X57EMDWaBNSMKO9MSfW0XoIKVymEwCRs41cgUHRg5?=
 =?us-ascii?Q?GOl8cZ/Uq3woSlArx9PE05xLan+GN6yE6krXlgSdT9ctHi9k9OqJopDIIEd7?=
 =?us-ascii?Q?at5khUzJyxdcE3d2okn/yVFZLdoe05mMb071uxAvaKOUNqYCXgBu3Lqq+97d?=
 =?us-ascii?Q?qWc+9fNmsfAD/ZzN8m5QbAEctoVjMS5+8HY232IOSuLTdQY8uhYE5G8W5O4l?=
 =?us-ascii?Q?Tpxoia7/OQ7bIUznBFCQStnJXW9zG4S/LYAvGcCjkWlNmELA0DU2J55LXNL9?=
 =?us-ascii?Q?KkyyWyMPBLw/vSMKbheLNdf3KNGhuAUpQsaZ2yG+AgOANhSX6xQZYAv93u/J?=
 =?us-ascii?Q?hr8/Yu91P6WJoHUzVAgtvFiSO3ksXVeSenGTzgi8WT09DpY6pS5FLpepAfX8?=
 =?us-ascii?Q?fitsjgGJFGmCBrnEfTiWFLPEBAbeMZiwRle6WSAIHuUhADem+ZW8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46231ab5-dd0f-48a7-aa03-08da324a0a7f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2022 05:58:01.2860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kfv+ma0KzTlOgwgIN+rOleqF4kbOZybCUgYWL/koeXcpoZKYNTY/PNT4Ax4tAUJuUtLjYN0MzGGpVmKz67WOiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavin Li <gavinl@nvidia.com>

Currently, health recovery will reload driver to recover it from fatal
errors. During the driver's load process, it would wait for FW to set the
pre-init bit for up to 120 seconds, beyond this threshold it would abort
the load process. In some cases, such as a FW upgrade on the DPU, this
timeout period is insufficient, and the user has no way to recover the
host device.

To solve this issue, introduce a new FW pre-init timeout for health
recovery, which is set to 2 hours.

The timeout for devlink reload and probe will use the original one because
they are user triggered flows, and therefore should not have a
significantly long timeout, during which the user command would hang.

Signed-off-by: Gavin Li <gavinl@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  4 ++--
 .../ethernet/mellanox/mlx5/core/fw_reset.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/lib/tout.c    |  1 +
 .../ethernet/mellanox/mlx5/core/lib/tout.h    |  1 +
 .../net/ethernet/mellanox/mlx5/core/main.c    | 23 +++++++++++--------
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  2 +-
 6 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e8789e6d7e7b..f85166e587f2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -178,13 +178,13 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
-		return mlx5_load_one(dev);
+		return mlx5_load_one(dev, false);
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
 			break;
 		/* On fw_activate action, also driver is reloaded and reinit performed */
 		*actions_performed |= BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-		return mlx5_load_one(dev);
+		return mlx5_load_one(dev, false);
 	default:
 		/* Unsupported action should not get to this function */
 		WARN_ON(1);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index ca1aba845dd6..84df0d56a2b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -148,7 +148,7 @@ static void mlx5_fw_reset_complete_reload(struct mlx5_core_dev *dev)
 	if (test_bit(MLX5_FW_RESET_FLAGS_PENDING_COMP, &fw_reset->reset_flags)) {
 		complete(&fw_reset->done);
 	} else {
-		mlx5_load_one(dev);
+		mlx5_load_one(dev, false);
 		devlink_remote_reload_actions_performed(priv_to_devlink(dev), 0,
 							BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT) |
 							BIT(DEVLINK_RELOAD_ACTION_FW_ACTIVATE));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
index c1df0d3595d8..d758848d34d0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.c
@@ -10,6 +10,7 @@ struct mlx5_timeouts {
 
 static const u32 tout_def_sw_val[MAX_TIMEOUT_TYPES] = {
 	[MLX5_TO_FW_PRE_INIT_TIMEOUT_MS] = 120000,
+	[MLX5_TO_FW_PRE_INIT_ON_RECOVERY_TIMEOUT_MS] = 7200000,
 	[MLX5_TO_FW_PRE_INIT_WARN_MESSAGE_INTERVAL_MS] = 20000,
 	[MLX5_TO_FW_PRE_INIT_WAIT_MS] = 2,
 	[MLX5_TO_FW_INIT_MS] = 2000,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
index 1c42ead782fa..257c03eeab36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/tout.h
@@ -7,6 +7,7 @@
 enum mlx5_timeouts_types {
 	/* pre init timeouts (not read from FW) */
 	MLX5_TO_FW_PRE_INIT_TIMEOUT_MS,
+	MLX5_TO_FW_PRE_INIT_ON_RECOVERY_TIMEOUT_MS,
 	MLX5_TO_FW_PRE_INIT_WARN_MESSAGE_INTERVAL_MS,
 	MLX5_TO_FW_PRE_INIT_WAIT_MS,
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f28a3526aafa..84f75aa25214 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1003,7 +1003,7 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_devcom_unregister_device(dev->priv.devcom);
 }
 
-static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
+static int mlx5_function_setup(struct mlx5_core_dev *dev, u64 timeout)
 {
 	int err;
 
@@ -1018,11 +1018,11 @@ static int mlx5_function_setup(struct mlx5_core_dev *dev, bool boot)
 
 	/* wait for firmware to accept initialization segments configurations
 	 */
-	err = wait_fw_init(dev, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT),
+	err = wait_fw_init(dev, timeout,
 			   mlx5_tout_ms(dev, FW_PRE_INIT_WARN_MESSAGE_INTERVAL));
 	if (err) {
 		mlx5_core_err(dev, "Firmware over %llu MS in pre-initializing state, aborting\n",
-			      mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
+			      timeout);
 		return err;
 	}
 
@@ -1272,7 +1272,7 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	mutex_lock(&dev->intf_state_mutex);
 	dev->state = MLX5_DEVICE_STATE_UP;
 
-	err = mlx5_function_setup(dev, true);
+	err = mlx5_function_setup(dev, mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT));
 	if (err)
 		goto err_function;
 
@@ -1336,9 +1336,10 @@ void mlx5_uninit_one(struct mlx5_core_dev *dev)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
-int mlx5_load_one(struct mlx5_core_dev *dev)
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery)
 {
 	int err = 0;
+	u64 timeout;
 
 	mutex_lock(&dev->intf_state_mutex);
 	if (test_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state)) {
@@ -1348,7 +1349,11 @@ int mlx5_load_one(struct mlx5_core_dev *dev)
 	/* remove any previous indication of internal error */
 	dev->state = MLX5_DEVICE_STATE_UP;
 
-	err = mlx5_function_setup(dev, false);
+	if (recovery)
+		timeout = mlx5_tout_ms(dev, FW_PRE_INIT_ON_RECOVERY_TIMEOUT);
+	else
+		timeout = mlx5_tout_ms(dev, FW_PRE_INIT_TIMEOUT);
+	err = mlx5_function_setup(dev, timeout);
 	if (err)
 		goto err_function;
 
@@ -1719,7 +1724,7 @@ static void mlx5_pci_resume(struct pci_dev *pdev)
 
 	mlx5_pci_trace(dev, "Enter, loading driver..\n");
 
-	err = mlx5_load_one(dev);
+	err = mlx5_load_one(dev, false);
 
 	mlx5_pci_trace(dev, "Done, err = %d, device %s\n", err,
 		       !err ? "recovered" : "Failed");
@@ -1807,7 +1812,7 @@ static int mlx5_resume(struct pci_dev *pdev)
 {
 	struct mlx5_core_dev *dev = pci_get_drvdata(pdev);
 
-	return mlx5_load_one(dev);
+	return mlx5_load_one(dev, false);
 }
 
 static const struct pci_device_id mlx5_core_pci_table[] = {
@@ -1852,7 +1857,7 @@ int mlx5_recover_device(struct mlx5_core_dev *dev)
 			return -EIO;
 	}
 
-	return mlx5_load_one(dev);
+	return mlx5_load_one(dev, true);
 }
 
 static struct pci_driver mlx5_core_driver = {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a9b2d6ead542..9026be1d6223 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -290,7 +290,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev);
 int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev);
-int mlx5_load_one(struct mlx5_core_dev *dev);
+int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
 
-- 
2.35.1

