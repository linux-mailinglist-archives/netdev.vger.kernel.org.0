Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685553E5B74
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241511AbhHJNZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:30 -0400
Received: from mail-bn7nam10on2071.outbound.protection.outlook.com ([40.107.92.71]:35744
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241348AbhHJNZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUONuh1gdwCTnZgHcmU366I4NTt2MeqB8MOA2nXh/T81bWASyA5V69S7x9tAFfX7ikhGniiYsTkIiVJ5FliNsn2+iTiimxq3qNcFyX18NJn8imonSdW3HWg+usi0BUxxiLkpPmvekFXR0azS+uNS12XqZGwT9cC9aAo0o+AuYd+TEJ2oPq0U+JDUMvG3xWEAuEs/rwQzETIE7g8YcteY21wdEm+0ZZJ+4iFF63DUHfJQuaN+msBVDhbRzoX5Z1inYZeeqT3kg0/d2evRg1K4VIOWUZrOCtyUdiNp5M/JIzICCuiw/tdZO2e/2Gep1+eMOvvNiqYpwG+rjw/7h9iMzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1HicVjzcJPAfyQKAKYqTxta5g8FHZk/th/PL0AvTeg=;
 b=AayG31HoXvcWmx/cVCcqs1xsckhpfSEz4osWH1yXaT8dH96vav9Sm0UeoVYEuB4zxrXeUPPfCuKn+NZRjXmh42QDCs3caOKMHDVqXfQWfWErfvKylso2pVuvhhJvu+m2w1TfcvYcsqCYwTSqu6B0CyXMgaLKXPwofz+GlnX01DnNi7DlRSHdTEvxUW4K6I5L5K0OGpycRF1hvFs1YOugctZB3Tt7d/z1DjZG4RGPp8x1gv+NHenAexWX4jGPKysMwJnsXk7b4TILMPZtrb/TYXM7ycZ4HmWA360dpX7d50yog0Sac24SWlKVmNfcRbMFGJz9FJ2eltHg3ocS+m2bqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1HicVjzcJPAfyQKAKYqTxta5g8FHZk/th/PL0AvTeg=;
 b=diD7XvRc35wt1Yu6CBnf+MejNfOQsoC23HPZiwCb67vBCtyhJzQaUSU6j1fQihMNYTHdPLElvH2ckWLe8tmpSiptLwpY3hbz9jXgJYCD1YtqgdN+owlr173YDudmhsbHHkrtbAy21xCj4+f2hrDBuF8YiA1U7IlTV44j9Yp+Th3LmNiW+ZetQP2fHh3KvglTyqC5FTOcuAcox6MRK6H/tZUiHmIU+HjWpSU1+bsiKOCVyM+hn30P+FKFUjPZKAnsKXZDHQoYVp+EZkTV40iZOZIZ62Z5oMPA9ERkdWjJ0mau4dV6mDMBRZ5fSz0IaeKl+Dhf9y7PnVwwToXv4q8Knw==
Received: from MW4PR03CA0026.namprd03.prod.outlook.com (2603:10b6:303:8f::31)
 by BN9PR12MB5356.namprd12.prod.outlook.com (2603:10b6:408:105::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.20; Tue, 10 Aug
 2021 13:24:46 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::f) by MW4PR03CA0026.outlook.office365.com
 (2603:10b6:303:8f::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:46 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 08/10] net/mlx5: Support enable_eth devlink dev param
Date:   Tue, 10 Aug 2021 16:24:22 +0300
Message-ID: <20210810132424.9129-9-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810132424.9129-1-parav@nvidia.com>
References: <20210810132424.9129-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eebd3d0b-7f5d-4533-76e2-08d95c0238d2
X-MS-TrafficTypeDiagnostic: BN9PR12MB5356:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5356BB53A44FD50162F25445DCF79@BN9PR12MB5356.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rKIL3F/eZbnaiPuRbGjmPZVDiPjMCL7gzUJgV1916TplzidKkl26F0rXyqtNUw5r8rEMWr6MZRO0N9xILC1KJSfjoqrbVc6jxYdZ+FnCmuDZbL+V0r5ASh5bFpvlEhJT5uE/HiYtp4YOsL0IjtCU1wzggzpOpk1BGiE5KreqxWzpqR+mOLtnZypFdJrvcOAYaq5xuKVr+D2l6p0h6zTYuADOIZAyDcaT59fvlipC2YjbiRRVaI25ctUr2xosqI7x/mC+oNNUwqh74ohzpY7eTq8ETZeeklZoWHrVK3yE1i6JZRIoWqCCvMApTgRGtdAxgcw4Xciy+4kzWMVk8T1FFP/MljhfxPeL+ABM2QGvXsPOC42HWdmlm264pfBjgNkrqIChb5ATu/irbAxKE2Asj6ydqql79yV7Fk9Ls2eU8sTmwykCvore7qBkTZL7p9l/bPN/g1K1gTpq/WtAo70IsXqvMZwrT5xqwxOT0DHhxBSpg/Fybq+K9rjFlOrM6KnpETEFbJFw5lYdIVvIrtl5ZrEy9j7rPG1kB1O/v7GWUadww04ve9CARh5Fzzcu0O8+ucEcV2in2waEBcW7113uLOpCPZR3PwPRos58EXWGVrDX8HWwm8GYARfZkSTwMIn5JZ/VGCdf92UD3cSJ6pXHsOLY52/Npue/rr0k+gEv+rYSojrINZ3i4SC/zVzG4TfUgaMJ4N2zWg+OZI7dm9W5pA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(396003)(36840700001)(46966006)(26005)(47076005)(5660300002)(4326008)(478600001)(82740400003)(54906003)(356005)(82310400003)(8676002)(186003)(2906002)(70206006)(70586007)(1076003)(16526019)(110136005)(7636003)(6666004)(336012)(8936002)(86362001)(107886003)(36756003)(426003)(83380400001)(36906005)(2616005)(316002)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:46.1483
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eebd3d0b-7f5d-4533-76e2-08d95c0238d2
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5356
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to disable Ethernet auxiliary device so that when it is not
required, user can disable it.

For example,

$ devlink dev param set pci/0000:06:00.0 \
              name enable_eth value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create mlx5_core.eth.2 auxiliary
device for the Ethernet functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 42 ++++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 53 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  3 ++
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index def2156e50ee..10c4309f29be 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -53,7 +53,7 @@ static bool is_eth_rep_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
-static bool is_eth_supported(struct mlx5_core_dev *dev)
+bool mlx5_eth_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_CORE_EN))
 		return false;
@@ -105,6 +105,17 @@ static bool is_eth_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static bool is_eth_enabled(struct mlx5_core_dev *dev)
+{
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+						 &val);
+	return err ? false : val.vbool;
+}
+
 static bool is_vnet_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_VDPA_NET))
@@ -201,13 +212,15 @@ enum {
 static const struct mlx5_adev_device {
 	const char *suffix;
 	bool (*is_supported)(struct mlx5_core_dev *dev);
+	bool (*is_enabled)(struct mlx5_core_dev *dev);
 } mlx5_adev_devices[] = {
 	[MLX5_INTERFACE_PROTOCOL_VNET] = { .suffix = "vnet",
 					   .is_supported = &is_vnet_supported },
 	[MLX5_INTERFACE_PROTOCOL_IB] = { .suffix = "rdma",
 					 .is_supported = &is_ib_supported },
 	[MLX5_INTERFACE_PROTOCOL_ETH] = { .suffix = "eth",
-					  .is_supported = &is_eth_supported },
+					  .is_supported = &mlx5_eth_supported,
+					  .is_enabled = &is_eth_enabled },
 	[MLX5_INTERFACE_PROTOCOL_ETH_REP] = { .suffix = "eth-rep",
 					   .is_supported = &is_eth_rep_supported },
 	[MLX5_INTERFACE_PROTOCOL_IB_REP] = { .suffix = "rdma-rep",
@@ -308,6 +321,14 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 		if (!priv->adev[i]) {
 			bool is_supported = false;
 
+			if (mlx5_adev_devices[i].is_enabled) {
+				bool enabled;
+
+				enabled = mlx5_adev_devices[i].is_enabled(dev);
+				if (!enabled)
+					continue;
+			}
+
 			if (mlx5_adev_devices[i].is_supported)
 				is_supported = mlx5_adev_devices[i].is_supported(dev);
 
@@ -360,6 +381,14 @@ void mlx5_detach_device(struct mlx5_core_dev *dev)
 		if (!priv->adev[i])
 			continue;
 
+		if (mlx5_adev_devices[i].is_enabled) {
+			bool enabled;
+
+			enabled = mlx5_adev_devices[i].is_enabled(dev);
+			if (!enabled)
+				goto skip_suspend;
+		}
+
 		adev = &priv->adev[i]->adev;
 		/* Auxiliary driver was unbind manually through sysfs */
 		if (!adev->dev.driver)
@@ -447,12 +476,21 @@ static void delete_drivers(struct mlx5_core_dev *dev)
 		if (!priv->adev[i])
 			continue;
 
+		if (mlx5_adev_devices[i].is_enabled) {
+			bool enabled;
+
+			enabled = mlx5_adev_devices[i].is_enabled(dev);
+			if (!enabled)
+				goto del_adev;
+		}
+
 		if (mlx5_adev_devices[i].is_supported && !delete_all)
 			is_supported = mlx5_adev_devices[i].is_supported(dev);
 
 		if (is_supported)
 			continue;
 
+del_adev:
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 0ec446d0fd6a..557973c9212f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -596,6 +596,52 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 #endif
 }
 
+static const struct devlink_param enable_eth_param =
+	DEVLINK_PARAM_GENERIC(ENABLE_ETH, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, NULL);
+
+static int mlx5_devlink_eth_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	int err;
+
+	if (!mlx5_eth_supported(dev))
+		return 0;
+
+	err = devlink_param_register(devlink, &enable_eth_param);
+	if (err)
+		return err;
+
+	value.vbool = true;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_ETH,
+					   value);
+	devlink_param_publish(devlink, &enable_eth_param);
+	return 0;
+}
+
+static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!mlx5_eth_supported(dev))
+		return;
+
+	devlink_param_unpublish(devlink, &enable_eth_param);
+	devlink_param_unregister(devlink, &enable_eth_param);
+}
+
+static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
+{
+	return mlx5_devlink_eth_param_register(devlink);
+}
+
+static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
+{
+	mlx5_devlink_eth_param_unregister(devlink);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -654,6 +700,10 @@ int mlx5_devlink_register(struct devlink *devlink)
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
 
+	err = mlx5_devlink_auxdev_params_register(devlink);
+	if (err)
+		goto auxdev_reg_err;
+
 	err = mlx5_devlink_traps_register(devlink);
 	if (err)
 		goto traps_reg_err;
@@ -661,6 +711,8 @@ int mlx5_devlink_register(struct devlink *devlink)
 	return 0;
 
 traps_reg_err:
+	mlx5_devlink_auxdev_params_unregister(devlink);
+auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 params_reg_err:
@@ -671,6 +723,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 343807ac2036..b3dfecf4f433 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -270,4 +270,7 @@ static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
 
 	return MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix);
 }
+
+bool mlx5_eth_supported(struct mlx5_core_dev *dev);
+
 #endif /* __MLX5_CORE_H__ */
-- 
2.26.2

