Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECFA13E595D
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbhHJLr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:27 -0400
Received: from mail-bn8nam11on2085.outbound.protection.outlook.com ([40.107.236.85]:24129
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240266AbhHJLrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kiItoetZsKfT0pyifLfwtrc8GL3dquFElZwFF/HVQHpuCxfoxtc+JhpciqpvdPwY/TF/3hnXZ5X98s57HJys4s7MwTCl8Nx+KUFQ2RdtEfe0xtmHHvL0XrpK60gMJPW3proHa0trgdhKsmJYjyPbNatSY3fdj3gcoEGAprfi+IVfcq41VOk9LCoyX/yogvN+YHG+yWWK3ImWet4YlGoFzjvTJZzsWtDtnPbp6x/WaeB3s5m0ajSVB6FMszWoqacpYcKZ6WZTbLhaK2DufKa0g+WiV/9Dhh3zHYSh/IQsMTGrWzA2YMPWzWEg956msNM3p/9+wLPeIVSaDylP3jNX8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1HicVjzcJPAfyQKAKYqTxta5g8FHZk/th/PL0AvTeg=;
 b=ZwvR0yH8/gfbr17cKeuj3fBcQbdmFuE7LPe1+eDL/JPKMtVKOSyyhokv1qCIG21tMrrVL28LB0qd2eA/U+PCjDgBlW27AcgVpFRK/5P1T3EuWG6Zl5cKJHOgUHP+U6c11RV9Wlb6FIMYk0ldCKsK5Rxylq8sXeGsFrwM+gpSZO465bppboeTXofMV8suQy/TqcKShpa+QvvfLV39wZUjTaSe6NW2wjKJhd5PmPVhF8wc9pfai4ZDYLF9HNPe2/nQFkQNmtFBLSfcwIh815PDCvyjXPqrMFbzLwoFj9b37xL81zKa1JBTPcn3nTU8QlDDFWQa8J5VOEeWdwmLcijrtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U1HicVjzcJPAfyQKAKYqTxta5g8FHZk/th/PL0AvTeg=;
 b=PdfFs3IoKW0+Egmag/IWewv7KXHhOUaBlJ4sJFGSwMV37kXdhwF5AHGa09zrXau+1el4twsTXKWAFvEMbnGJsF43Shw+d0un6oxdETWk5W6zoykbBXRXKM522KGmqGBIJWXtACW2VLkC4m3x7AMPfMu2WPaHB2L63ikqWDSwpAdbLBsV/WVavvzzH53B/YYQsfkTpjKTjItppDLVFAEh6LLgFrSMZhrpxs+AsAG9lc6+KyyqcA21smTnSkBjKg+boku/ZSy7Rpm7vfFLWhryU+WhkuLlbxVEygmODpiJ0I0gQt64KesAjHqqJHBv+mAcCFiQAsl2fL6tT4jdX/4ilA==
Received: from BN9P222CA0006.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::11)
 by BN9PR12MB5068.namprd12.prod.outlook.com (2603:10b6:408:135::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.18; Tue, 10 Aug
 2021 11:46:45 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::fc) by BN9P222CA0006.outlook.office365.com
 (2603:10b6:408:10c::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:45 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:45 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:43 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 08/10] net/mlx5: Support enable_eth devlink dev param
Date:   Tue, 10 Aug 2021 14:46:18 +0300
Message-ID: <20210810114620.8397-9-parav@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210810114620.8397-1-parav@nvidia.com>
References: <20210810114620.8397-1-parav@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e970e71-38f7-4014-6409-08d95bf48775
X-MS-TrafficTypeDiagnostic: BN9PR12MB5068:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5068B3C8DB23FE1717EE9902DCF79@BN9PR12MB5068.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwOFOS5WGS3dSHeLr9/LuSs5WY/Grk/8leI42dKLCniikIuZl+P016aOZ62h7WnPUqs/o1zBwxdV9VOXmJBJcJI5W/zaphf+ciB42SuuvJyHNZC98KKxA4sqFEcb+RhfA4/GSaJcFVRHcRZ4LKbhEt7BUbXIj07MIQ944yOggUbDyqbEuBnOJjwcltK7CJzhY56W+Z4pPY1itDoTIR8NI1xxj+BfrPQ1WZoUXsnz2We5iFwjnKas0ld3UXRibnFKsZdAam3K83l2s/NHtkGzNaxSK1XeHo6jS9l18nmvh/4qIqZLyDMED4kftktMCbVoz+THJAjvroKewJTw/DJ/+zAPGcV9jGDXk6CvhMqiaS+iZBbSjobFnhFlx2JUHa2DBqIL/TGegvDQkJ7T47/300NttTX4J7jeHYVmiLSIZTlTtl9Ujpw+AsEzhWcMJA+Q+XJLpUXlYjhHsTm7UWDHIx8tsLQYsBGLUObl+iTs9eGff64cAFtWDrwEl3lpORF8TtVLQg7c8lZC+WO5+JJe4t4ftvBy4ADTnIN5cOnSzq7PZ6UReu9QwHXD/b3DvHmWksQYQPsYahxZErzM9slwqB1HzWJ2FCaU0GR7QlUBJt57n6U/004pwU3LWQNrqyrNe0RRtQlbmXxVjt8+0KorYGZhGVpanmU3JHX2b63fHzlfqPfHomqcxOkm6gpI/3SjPGmG60TC6OSBKSJq3nmAkg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(346002)(396003)(36840700001)(46966006)(7636003)(36906005)(2906002)(316002)(86362001)(82740400003)(26005)(36756003)(336012)(82310400003)(36860700001)(83380400001)(107886003)(1076003)(2616005)(70206006)(47076005)(110136005)(54906003)(16526019)(4326008)(186003)(6666004)(356005)(8936002)(5660300002)(8676002)(478600001)(426003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:45.0792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e970e71-38f7-4014-6409-08d95bf48775
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5068
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

