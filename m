Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60A5C4ADF1C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:15:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383392AbiBHRPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:15:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352564AbiBHRPP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:15:15 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2077.outbound.protection.outlook.com [40.107.236.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B341BC0613CC;
        Tue,  8 Feb 2022 09:15:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9RIYlVNHB71/KIw07tdPSngmUAE7dywMgRpvedT4/piYIApWMyzZhvGan3reKNWG8tSyySxmerN3jMnqrSch+CsaqCfskENCPHkgV+DJC+zBoraHJC7NR3FEXRS0d6h51HkXP2mKQhE6NbjHSmNzN9giHNMuFFvVrw8UIlmwRUfMpA0yhyGYca0rV3ivnRWHa0xm6tWesyyuz/+O4HZG7u8SSx6fteBIERKReshTT9+GdUq+SDcy0SytDUGPL5igM0UVqwuBSkEgVXrYdgmuuThTZJLtNVo6ry7nIs7wAB946djD5q3SfZiEd72uAcujl+5k7VGG4TusoT7NvQT1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zq9Nr4bC0VlgPmFexyOAJe9CTrvgvKV0U8fbewUwnps=;
 b=gjy7kyv8DCESzYQZM5WZCtOlevqBErsPeQ9JSvPUorxomuL8ULDKv1lyIm9JxEKS663/PiIuyUr6xK0Q8r+4jllpZLgaAGzEdR/ORoiR/d84FqvCz9TqGX08LGJdGECiRD3H8/X8SdELq9/DY1+cwhKYf3GPgnxVvQ3yp1GOplIMjuZeYj4BsDYYA2xkl+MfrPjzzURVJGsxzyFLnSwCiVaHSqbqaYdIS3Ez1sTGPyOL0QXqFLvfKNMq0o6DBmjTZQBSnqZZAecnwITG0E6ieTLA/2rKC2E5Cmx47xpJQTQ7bCL952dw/dTPuEe0GyWqzs6WNK9qsEnCN781hTRmlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zq9Nr4bC0VlgPmFexyOAJe9CTrvgvKV0U8fbewUwnps=;
 b=P66IPRVWRGWnfMWQUM8h/H5zLt2uJUkwtv+dovXjulOOo0z5/pOBdApJPy0tLQ5Yb3BD5+QHVodybpNcwF/DvED8BzQiUJU5Y6AoNNJUzigzDHZWPaO7ASDkWvB7NZ7Zd7ulK0vRsUQHnOKHauPBC0rtT1EGqyVSuJPOeHD35b1PmQOqh0X3E4xjjvp7y26thqDSvX5S82KmgWfGFQZxrFCE9roErKeQQ0ispdmFQ20VL8GfT/QEl8EaJ8Vyu6EwJDFabB8G5PQosJ4n8m6Fa0DXjOG/ewDvXlGCGa4zO/LTvaDUjcqcej8mdG4s488Na5WxFkAdyv8wlVZQU/Ys7w==
Received: from DM3PR11CA0019.namprd11.prod.outlook.com (2603:10b6:0:54::29) by
 SA0PR12MB4446.namprd12.prod.outlook.com (2603:10b6:806:71::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4951.12; Tue, 8 Feb 2022 17:15:08 +0000
Received: from DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:54:cafe::a1) by DM3PR11CA0019.outlook.office365.com
 (2603:10b6:0:54::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Tue, 8 Feb 2022 17:15:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT048.mail.protection.outlook.com (10.13.173.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Tue, 8 Feb 2022 17:15:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 17:14:54 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Tue, 8 Feb 2022
 09:14:53 -0800
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Tue, 8 Feb
 2022 09:14:51 -0800
From:   Moshe Shemesh <moshe@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next 4/4] net/mlx5: Support enable_sfs_aux_devs devlink param
Date:   Tue, 8 Feb 2022 19:14:06 +0200
Message-ID: <1644340446-125084-5-git-send-email-moshe@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 65f917f2-83e1-4494-7b98-08d9eb268ec8
X-MS-TrafficTypeDiagnostic: SA0PR12MB4446:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB44463A4F79DD96DB5F64B7FDD42D9@SA0PR12MB4446.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ChC5Vp3OfZ2ceP5Afctcea9IDe5Ij6i3mZrzGV6vOMyo6RQQ+dznOc0c+MDOMp17cWXkzqGdBRvYECwQe3bdmJ1enSG0X/E6qjiv1ak6zT1ZVTMS5lDmH7QYugMOvadelzsRyTDTlS5cLrwQ4SvaiWosCLhNtJdrbEL//cT+C3XGkI10r46HKV9X5BkaCw2MIv9zASVPAxpEk7XwuN7yEIObBxdoFm21b1iE6y4IIk2HtYxcDvAd1lMj3oDcYulQDYZBNeIN0XYWQawMOeXIvJYWgyR2o+xqdEGU2ufd1O6PRStFC2RfPKWRLDE27Brk/q97md/ZFr47bFNGbr/7G7Lzb7MhocLkjoQe0YspvjTKh0mYmo1NPf5nTY04C+b9+ZFJVRjFu+dqFHvNUMwBsSDvdmRjAz4Gy3lDIGC6nGJvQ20nzSfn/8BNCqB/h42qkYgpquSGqgdN/0lClliYfQDZewo3PT8darjZgfJMDluA029ZnVtnQFCV0QvKb+rEKSOhVYduECqxZOwqmEQcunRXPCpVioSDoDgRM0f+yJj4EOl6FLrO9aS8QJd4jG42QybQozgb3HgGT2mO+RsoE61S5Nnzu8l63lzA0COfnUyRSZyEqcn9zBSS5tug2UfcSW4VAFCxfMf/CZNyPXJ/xZ+kRGUoQOHw9bhSOHasDfuTJWqi6L0uS7ObL67DgEG3Y4a3hju66a+4tlykjErk7UaCgKiyjFfPk/1IbTUJqeI=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(36840700001)(46966006)(40470700004)(54906003)(110136005)(356005)(70206006)(70586007)(81166007)(6666004)(8936002)(4326008)(8676002)(83380400001)(86362001)(7696005)(36860700001)(426003)(336012)(40460700003)(2616005)(5660300002)(2906002)(30864003)(26005)(186003)(316002)(47076005)(107886003)(82310400004)(36756003)(508600001)(21314003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:15:08.5017
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 65f917f2-83e1-4494-7b98-08d9eb268ec8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT048.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4446
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

In case user wants to configure the SFs, for example: to use only vdpa
functionality, he needs to fully probe a SF, configure what he wants,
and afterward reload the SF.
In order to save the time of the reload, exposing a devlink runtime
param on the PF, that when set to off, the SFs won't create any auxiliary
sub-device, so that the SF can be configured prior to its full probe.

Usage example:
$ devlink dev param set pci/0000:00:0b.0 name enable_sfs_aux_devs \
	  value false cmode runtime

Create SF:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
$ devlink port function set pci/0000:08:00.0/32768 \
               hw_addr 00:00:00:00:00:11 state active

Enable ETH auxiliary device:
$ devlink dev param set auxiliary/mlx5_core.sf.1 \
              name enable_eth value true cmode driverinit

Now, in order to fully probe the SF, use devlink reload:
$ devlink dev reload auxiliary/mlx5_core.sf.1

At this point the user have SF devlink instance with auxiliary device
for the Ethernet functionality only.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c |  16 +++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |  31 +++++-
 .../net/ethernet/mellanox/mlx5/core/health.c  |   5 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 102 +++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   6 ++
 .../mellanox/mlx5/core/sf/dev/driver.c        |  13 ++-
 .../ethernet/mellanox/mlx5/core/sf/devlink.c  |  40 +++++++
 .../ethernet/mellanox/mlx5/core/sf/hw_table.c |   7 ++
 .../net/ethernet/mellanox/mlx5/core/sf/priv.h |   2 +
 include/linux/mlx5/driver.h                   |   1 +
 10 files changed, 211 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ba6dad97e308..89ead37b98ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -333,6 +333,18 @@ static void del_adev(struct auxiliary_device *adev)
 	auxiliary_device_uninit(adev);
 }
 
+void mlx5_dev_mark_unregistered(struct mlx5_core_dev *dev)
+{
+	mutex_lock(&mlx5_intf_mutex);
+	dev->priv.flags |= MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+	mutex_unlock(&mlx5_intf_mutex);
+}
+
+bool mlx5_dev_is_unregistered(struct mlx5_core_dev *dev)
+{
+	return dev->priv.flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV;
+}
+
 int mlx5_attach_device(struct mlx5_core_dev *dev)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -473,6 +485,10 @@ static int add_drivers(struct mlx5_core_dev *dev)
 		if (!is_supported)
 			continue;
 
+		if (mlx5_adev_devices[i].is_enabled &&
+		    !(mlx5_adev_devices[i].is_enabled(dev)))
+			continue;
+
 		priv->adev[i] = add_adev(dev, i);
 		if (IS_ERR(priv->adev[i])) {
 			mlx5_core_warn(dev, "Device[%d] (%s) failed to load\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index e832a3f4c18a..1b769b5da577 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -139,6 +139,13 @@ static int mlx5_devlink_reload_down(struct devlink *devlink, bool netns_change,
 	struct pci_dev *pdev = dev->pdev;
 	bool sf_dev_allocated;
 
+	if (mlx5_dev_is_unregistered(dev)) {
+		if (action != DEVLINK_RELOAD_ACTION_DRIVER_REINIT)
+			return -EOPNOTSUPP;
+		mlx5_unload_one_light(dev);
+		return 0;
+	}
+
 	sf_dev_allocated = mlx5_sf_dev_allocated(dev);
 	if (sf_dev_allocated) {
 		/* Reload results in deleting SF device which further results in
@@ -182,6 +189,10 @@ static int mlx5_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
 	*actions_performed = BIT(action);
 	switch (action) {
 	case DEVLINK_RELOAD_ACTION_DRIVER_REINIT:
+		if (mlx5_dev_is_unregistered(dev)) {
+			mlx5_fw_reporters_create(dev);
+			return mlx5_init_one(dev);
+		}
 		return mlx5_load_one(dev);
 	case DEVLINK_RELOAD_ACTION_FW_ACTIVATE:
 		if (limit == DEVLINK_RELOAD_LIMIT_NO_RESET)
@@ -258,6 +269,9 @@ static int mlx5_devlink_trap_action_set(struct devlink *devlink,
 	struct mlx5_devlink_trap *dl_trap;
 	int err = 0;
 
+	if (mlx5_dev_is_unregistered(dev))
+		return -EOPNOTSUPP;
+
 	if (is_mdev_switchdev_mode(dev)) {
 		NL_SET_ERR_MSG_MOD(extack, "Devlink traps can't be set in switchdev mode");
 		return -EOPNOTSUPP;
@@ -440,6 +454,9 @@ static int mlx5_devlink_fs_mode_get(struct devlink *devlink, u32 id,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (mlx5_dev_is_unregistered(dev))
+		return -EOPNOTSUPP;
+
 	if (dev->priv.steering->mode == MLX5_FLOW_STEERING_MODE_SMFS)
 		strcpy(ctx->val.vstr, "smfs");
 	else
@@ -499,6 +516,9 @@ static int mlx5_devlink_esw_port_metadata_get(struct devlink *devlink, u32 id,
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (mlx5_dev_is_unregistered(dev))
+		return -EOPNOTSUPP;
+
 	if (!MLX5_ESWITCH_MANAGER(dev))
 		return -EOPNOTSUPP;
 
@@ -542,6 +562,9 @@ static int mlx5_devlink_enable_remote_dev_reset_get(struct devlink *devlink, u32
 {
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 
+	if (mlx5_dev_is_unregistered(dev))
+		return -EOPNOTSUPP;
+
 	ctx->val.vbool = mlx5_fw_reset_enable_remote_dev_reset_get(dev);
 	return 0;
 }
@@ -588,7 +611,7 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 	struct mlx5_core_dev *dev = devlink_priv(devlink);
 	union devlink_param_value value;
 
-	value.vbool = MLX5_CAP_GEN(dev, roce);
+	value.vbool = MLX5_CAP_GEN(dev, roce) && !mlx5_dev_is_unregistered(dev);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
 					   value);
@@ -628,7 +651,7 @@ static int mlx5_devlink_eth_param_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_unregistered(dev);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
 					   value);
@@ -673,7 +696,7 @@ static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_unregistered(devlink_priv(devlink));
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
 					   value);
@@ -705,7 +728,7 @@ static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
 	if (err)
 		return err;
 
-	value.vbool = true;
+	value.vbool = !mlx5_dev_is_unregistered(dev);
 	devlink_param_driverinit_value_set(devlink,
 					   DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
 					   value);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net/ethernet/mellanox/mlx5/core/health.c
index 737df402c927..1b40ada0e9c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -700,7 +700,7 @@ static const struct devlink_health_reporter_ops mlx5_fw_fatal_reporter_ops = {
 };
 
 #define MLX5_REPORTER_FW_GRACEFUL_PERIOD 1200000
-static void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
+void mlx5_fw_reporters_create(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_health *health = &dev->priv.health;
 	struct devlink *devlink = priv_to_devlink(dev);
@@ -893,7 +893,8 @@ int mlx5_health_init(struct mlx5_core_dev *dev)
 	struct mlx5_core_health *health;
 	char *name;
 
-	mlx5_fw_reporters_create(dev);
+	if (!mlx5_dev_is_unregistered(dev))
+		mlx5_fw_reporters_create(dev);
 
 	health = &dev->priv.health;
 	name = kmalloc(64, GFP_KERNEL);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 73d2cec01ead..b5e40ad0b5fb 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1314,6 +1314,7 @@ static void mlx5_unload(struct mlx5_core_dev *dev)
 
 int mlx5_init_one(struct mlx5_core_dev *dev)
 {
+	bool light_probe = mlx5_dev_is_unregistered(dev);
 	int err = 0;
 
 	mutex_lock(&dev->intf_state_mutex);
@@ -1335,9 +1336,14 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 
 	set_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 
-	err = mlx5_devlink_register(priv_to_devlink(dev));
-	if (err)
-		goto err_devlink_reg;
+	/* In case of light_probe, mlx5_devlink is already registered.
+	 * Hence, don't register devlink again.
+	 */
+	if (!light_probe) {
+		err = mlx5_devlink_register(priv_to_devlink(dev));
+		if (err)
+			goto err_devlink_reg;
+	}
 
 	err = mlx5_register_device(dev);
 	if (err)
@@ -1347,7 +1353,8 @@ int mlx5_init_one(struct mlx5_core_dev *dev)
 	return 0;
 
 err_register:
-	mlx5_devlink_unregister(priv_to_devlink(dev));
+	if (!light_probe)
+		mlx5_devlink_unregister(priv_to_devlink(dev));
 err_devlink_reg:
 	clear_bit(MLX5_INTERFACE_STATE_UP, &dev->intf_state);
 	mlx5_unload(dev);
@@ -1443,6 +1450,93 @@ void mlx5_unload_one(struct mlx5_core_dev *dev)
 	mutex_unlock(&dev->intf_state_mutex);
 }
 
+/* In case of light probe, we don't need a full query of hca_caps, but only the bellow caps.
+ * A full query of hca_caps will be done when the device will reload.
+ */
+static int mlx5_query_hca_caps_light(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
+	if (err)
+		return err;
+
+	if (MLX5_CAP_GEN(dev, eth_net_offloads)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_ETHERNET_OFFLOADS);
+		if (err)
+			return err;
+	}
+
+	if (MLX5_CAP_GEN(dev, nic_flow_table) ||
+	    MLX5_CAP_GEN(dev, ipoib_enhanced_offloads)) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_FLOW_TABLE);
+		if (err)
+			return err;
+	}
+
+	if (MLX5_CAP_GEN_64(dev, general_obj_types) &
+		MLX5_GENERAL_OBJ_TYPES_CAP_VIRTIO_NET_Q) {
+		err = mlx5_core_get_caps(dev, MLX5_CAP_VDPA_EMULATION);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+int mlx5_init_one_light(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	dev->state = MLX5_DEVICE_STATE_UP;
+	err = mlx5_function_enable(dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_function_enable err=%d\n", err);
+		goto out;
+	}
+
+	err = mlx5_query_hca_caps_light(dev);
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_query_hca_caps_light err=%d\n", err);
+		goto query_hca_caps_err;
+	}
+
+	err = mlx5_devlink_register(priv_to_devlink(dev));
+	if (err) {
+		mlx5_core_warn(dev, "mlx5_devlink_reg err = %d\n", err);
+		goto query_hca_caps_err;
+	}
+
+	return 0;
+
+query_hca_caps_err:
+	mlx5_function_disable(dev);
+out:
+	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+	return err;
+}
+
+void mlx5_uninit_one_light(struct mlx5_core_dev *dev)
+{
+	mlx5_devlink_unregister(priv_to_devlink(dev));
+	if (dev->state != MLX5_DEVICE_STATE_UP)
+		return;
+	mlx5_function_disable(dev);
+}
+
+/* xxx_ligth() function are used in order to configure the device without full
+ * init (light init). e.g.: There isn't a point in reload a device to light state.
+ * Hence, mlx5_load_one_light() isn't needed.
+ */
+
+void mlx5_unload_one_light(struct mlx5_core_dev *dev)
+{
+	if (dev->state != MLX5_DEVICE_STATE_UP)
+		return;
+	mlx5_function_disable(dev);
+	dev->state = MLX5_DEVICE_STATE_INTERNAL_ERROR;
+}
+
 static const int types[] = {
 	MLX5_CAP_GENERAL,
 	MLX5_CAP_GENERAL_2,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 6f8baa0f2a73..e2d827474552 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -209,11 +209,14 @@ int mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
+void mlx5_dev_mark_unregistered(struct mlx5_core_dev *dev);
+bool mlx5_dev_is_unregistered(struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
 
+void mlx5_fw_reporters_create(struct mlx5_core_dev *dev);
 int mlx5_query_mtpps(struct mlx5_core_dev *dev, u32 *mtpps, u32 mtpps_size);
 int mlx5_set_mtpps(struct mlx5_core_dev *mdev, u32 *mtpps, u32 mtpps_size);
 int mlx5_query_mtppse(struct mlx5_core_dev *mdev, u8 pin, u8 *arm, u8 *mode);
@@ -291,6 +294,9 @@ int mlx5_init_one(struct mlx5_core_dev *dev);
 void mlx5_uninit_one(struct mlx5_core_dev *dev);
 void mlx5_unload_one(struct mlx5_core_dev *dev);
 int mlx5_load_one(struct mlx5_core_dev *dev);
+int mlx5_init_one_light(struct mlx5_core_dev *dev);
+void mlx5_uninit_one_light(struct mlx5_core_dev *dev);
+void mlx5_unload_one_light(struct mlx5_core_dev *dev);
 
 int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 7b4783ce213e..8d6e0e44e614 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -28,6 +28,9 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 	mdev->priv.adev_idx = adev->id;
 	sf_dev->mdev = mdev;
 
+	if (sf_dev->parent_mdev->priv.sfs_light_probe)
+		mlx5_dev_mark_unregistered(mdev);
+
 	err = mlx5_mdev_init(mdev, MLX5_DEFAULT_PROF);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_mdev_init on err=%d\n", err);
@@ -41,7 +44,10 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		goto remap_err;
 	}
 
-	err = mlx5_init_one(mdev);
+	if (sf_dev->parent_mdev->priv.sfs_light_probe)
+		err = mlx5_init_one_light(mdev);
+	else
+		err = mlx5_init_one(mdev);
 	if (err) {
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
@@ -64,7 +70,10 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 	struct devlink *devlink = priv_to_devlink(sf_dev->mdev);
 
 	devlink_unregister(devlink);
-	mlx5_uninit_one(sf_dev->mdev);
+	if (mlx5_dev_is_unregistered(sf_dev->mdev))
+		mlx5_uninit_one_light(sf_dev->mdev);
+	else
+		mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
 	mlx5_devlink_free(devlink);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index 3be659cd91f1..e3f6066ab7af 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -10,6 +10,7 @@
 #include "ecpf.h"
 #define CREATE_TRACE_POINTS
 #include "diag/sf_tracepoint.h"
+#include "devlink.h"
 
 struct mlx5_sf {
 	struct devlink_port dl_port;
@@ -456,6 +457,44 @@ static int mlx5_sf_vhca_event(struct notifier_block *nb, unsigned long opcode, v
 	return 0;
 }
 
+static int mlx5_devlink_sfs_light_probe_get(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	ctx->val.vbool = !dev->priv.sfs_light_probe;
+	return 0;
+}
+
+static int mlx5_devlink_sfs_light_probe_set(struct devlink *devlink, u32 id,
+					    struct devlink_param_gset_ctx *ctx)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	dev->priv.sfs_light_probe = !ctx->val.vbool;
+	return 0;
+}
+
+static const struct devlink_param sfs_light_probe_param =
+	DEVLINK_PARAM_GENERIC(ENABLE_SFS_AUX_DEVS, BIT(DEVLINK_PARAM_CMODE_RUNTIME),
+			      mlx5_devlink_sfs_light_probe_get,
+			      mlx5_devlink_sfs_light_probe_set, NULL);
+
+int mlx5_devlink_sfs_light_probe_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!mlx5_core_is_pf(dev) || !mlx5_sf_max_functions(dev))
+		return 0;
+
+	return devlink_param_register(devlink, &sfs_light_probe_param);
+}
+
+void mlx5_devlink_sfs_light_probe_param_unregister(struct devlink *devlink)
+{
+	devlink_param_unregister(devlink, &sfs_light_probe_param);
+}
+
 static void mlx5_sf_table_enable(struct mlx5_sf_table *table)
 {
 	init_completion(&table->disable_complete);
@@ -533,6 +572,7 @@ int mlx5_sf_table_init(struct mlx5_core_dev *dev)
 	table->dev = dev;
 	xa_init(&table->port_indices);
 	dev->priv.sf_table = table;
+	dev->priv.sfs_light_probe = false;
 	refcount_set(&table->refcount, 0);
 	table->esw_nb.notifier_call = mlx5_sf_esw_event;
 	err = mlx5_esw_event_notifier_register(dev->priv.eswitch, &table->esw_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
index 17aa348989cb..664704598b76 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/hw_table.c
@@ -283,9 +283,15 @@ int mlx5_sf_hw_table_init(struct mlx5_core_dev *dev)
 	if (err)
 		goto ext_err;
 
+	err = mlx5_devlink_sfs_light_probe_param_register(priv_to_devlink(dev));
+	if (err)
+		goto sfs_reg_err;
+
 	mlx5_core_dbg(dev, "SF HW table: max sfs = %d, ext sfs = %d\n", max_fn, max_ext_fn);
 	return 0;
 
+sfs_reg_err:
+	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_EXTERNAL]);
 ext_err:
 	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_LOCAL]);
 table_err:
@@ -301,6 +307,7 @@ void mlx5_sf_hw_table_cleanup(struct mlx5_core_dev *dev)
 	if (!table)
 		return;
 
+	mlx5_devlink_sfs_light_probe_param_unregister(priv_to_devlink(dev));
 	mutex_destroy(&table->table_lock);
 	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_EXTERNAL]);
 	mlx5_sf_hw_table_hwc_cleanup(&table->hwc[MLX5_SF_HWC_LOCAL]);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
index 7114f3fc335f..c228edc8e43c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/priv.h
@@ -19,4 +19,6 @@ void mlx5_sf_hw_table_sf_free(struct mlx5_core_dev *dev, u32 controller, u16 id)
 void mlx5_sf_hw_table_sf_deferred_free(struct mlx5_core_dev *dev, u32 controller, u16 id);
 bool mlx5_sf_hw_table_supported(const struct mlx5_core_dev *dev);
 
+int mlx5_devlink_sfs_light_probe_param_register(struct devlink *devlink);
+void mlx5_devlink_sfs_light_probe_param_unregister(struct devlink *devlink);
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 78655d8d13a7..fd07175896ff 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -604,6 +604,7 @@ struct mlx5_priv {
 	struct mlx5_vhca_state_notifier *vhca_state_notifier;
 	struct mlx5_sf_dev_table *sf_dev_table;
 	struct mlx5_core_dev *parent_mdev;
+	u8 sfs_light_probe:1;
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	struct mlx5_sf_hw_table *sf_hw_table;
-- 
2.26.3

