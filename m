Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCA43E5B76
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241447AbhHJNZk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:40 -0400
Received: from mail-mw2nam12on2072.outbound.protection.outlook.com ([40.107.244.72]:39456
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241402AbhHJNZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BjO2JZ4oeJM2kUmRf65ZR3LzKygpotK3lZdh7rCmlk7Szu9u/KlTek4uHUOhpoimmGC8XOly3jamDgbK2E/eLjkIZsiIiqqgtFm8TPfuFTZNYQBpv2zxxIMR0tcOmpmxssHTSVo8xi0Q5J32/I3Ke0M2bQbtqzWQKKsWqmEYVISRUTwZHm9GWRJoyizAtFbWznSBd0l30IveNU433IhLXFSZSjriADCJiEtURPQILTHXNLxUcMt9zbTaJEoigUe/YOcYZDOodnOhlk+nf5gUlxGayXLVh0B0kzyrtbDHenol4rqP8qxTRidKKFkeKMTCCwWGyUH0X9o8kFs/EAwSpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIi8hzPJyZfyI2sfgdbiTFzKy/YbYasDVyImO8S2Rt8=;
 b=YwCBwt+TjRvS4kyAhmhnN3/mz/ELf3BKTCpxXX0OXjRnXjqcL6RQq/HiRT0gUewcbpwpjuZ9Ai07hMsKdotevgDJ6MUWHp8S2VqoQ81/XVLLRBDPuUA7BFrR1oFQoSHpgcjbotzzV7qjQTHq1yuMsYbu7asuNSRNVk14Ws0T26e3loasTRMIBMf3aqkxCGGEi3gUXecO23Gg2SF0j8UTB4C3bYUbhQIvoga7GqoRHCKwHsvssjxr+n+x51o/UOxutypgUdwhm/jIs2oaGNhQ5mEi26/RpbyoO9n80+R/vUby76Y+r3O0p+Ip+M6kcZyEQi8Z8JWK/PirArmslweNjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIi8hzPJyZfyI2sfgdbiTFzKy/YbYasDVyImO8S2Rt8=;
 b=qEMkfrHsak42sZuj0nGvvYnFX7K7TkuGGP7Rcbr5z5kQGk/cMnXbD07KY1qAmceuRmD4Feq+XsCC9mIme6FARWlswcQVcSob9+LJrCI1FKtgmQyW8A+L6JrdJ1g1N9hoNbwZVSMyW7dxHSu6RjmzybXNfHoRXEKQhmyqXQrYNI2utsluyJW5d5LEjDQ2z7CzhmRTlvrIhvVAPda0SfzjqUD/Elqn7zwO2wcGVWe/tLUZkHT65/vY/CxmHyTk/JcSRIW4rDXT7dD/wsOsOV5NiWVdonUh6Gz0cXU1PaGJXD/lX36GOcTjAKdp+8gNm531ch6RyNvZ5OYEwdpolUuleQ==
Received: from MW4PR03CA0002.namprd03.prod.outlook.com (2603:10b6:303:8f::7)
 by DM5PR12MB1721.namprd12.prod.outlook.com (2603:10b6:3:10d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 13:24:48 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::96) by MW4PR03CA0002.outlook.office365.com
 (2603:10b6:303:8f::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:48 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:45 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 10/10] net/mlx5: Support enable_vnet devlink dev param
Date:   Tue, 10 Aug 2021 16:24:24 +0300
Message-ID: <20210810132424.9129-11-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 9334ceaa-3954-4dfb-b9b5-08d95c023a22
X-MS-TrafficTypeDiagnostic: DM5PR12MB1721:
X-Microsoft-Antispam-PRVS: <DM5PR12MB17219C93358E101B57AA8080DCF79@DM5PR12MB1721.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VbWvl9W1mSCM9F2kad5gjuUdntCljrDxgwsGGI0zPCkJijey+YesFq0EH8H/4FqjL5WJzKhGBr3nybtWK+X866Gy2uT5dnlNeMdGyXqUsFjyIagt3/TuV2ZBv56jYOAteqMde7zBGLPt79kPUlsy5XFY/Yv23c79fgXc8RnpQXAfQewdyxfSRlmI53L/ltYeCt8FU8N5zl6nSR0XwLfxbD1soUTmKlxvfhWEWn/WSqBDOLGr0pTDlweXBnOc5yU+sm9j/dxb2Irmjc29qYz1DumrCOHCQxNXXgFZW+zOuBiASM2RPwoylp5Z+IsqJA+G52aYnZaVDgrGwYQA2XNz0vuNZ7ALxFtZ6lQ7gDgSV/snvbB0b48g6R31jYDDO6FVy4DYgnKBddgrBcYxvKNCyV4Md7tr36RbzoAzE+WJuzwABhlmynlRnKoB8INdiYDoWpLuY8e6yEyDYfSVzrWy6Cw4wr90elkqFLyyd4MAA/BXaKqYUrIWgvcr4QFz7g63amDFyaNpsjFde3yBNKD9bqa67AJgFIWdao/VZmKj1MPEi2IVoDoO3ZNVImgzNsTrAlrtiFOo/OuLvHJOTPRsIBDpFGDqxYf64O2F5a2zycRce1/1+N9RsmVJ51RejAXEb64uVIUb7HjBsYFXP8PFoLXfWSP/WznWJwT3WJXNc6tV+FdDvPjjQBNE6anCXEpwJEJOUosDRqXBLlTVwyx6Wg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(186003)(70206006)(107886003)(8676002)(2906002)(336012)(70586007)(82310400003)(82740400003)(7636003)(16526019)(26005)(83380400001)(4326008)(47076005)(356005)(36756003)(8936002)(478600001)(36906005)(1076003)(2616005)(5660300002)(316002)(36860700001)(54906003)(86362001)(110136005)(426003)(6666004);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:48.3170
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9334ceaa-3954-4dfb-b9b5-08d95c023a22
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1721
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to disable VDPA net auxiliary device so that when it is not
required, user can disable it.

For example,

$ devlink dev param set pci/0000:06:00.0 \
              name enable_vnet value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create auxiliary device
mlx5_core.vnet.2 for the VDPA net functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 16 ++++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 42 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index cb86844099c0..ff6b03dc7e32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -116,7 +116,7 @@ static bool is_eth_enabled(struct mlx5_core_dev *dev)
 	return err ? false : val.vbool;
 }
 
-static bool is_vnet_supported(struct mlx5_core_dev *dev)
+bool mlx5_vnet_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_VDPA_NET))
 		return false;
@@ -138,6 +138,17 @@ static bool is_vnet_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static bool is_vnet_enabled(struct mlx5_core_dev *dev)
+{
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+						 &val);
+	return err ? false : val.vbool;
+}
+
 static bool is_ib_rep_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
@@ -226,7 +237,8 @@ static const struct mlx5_adev_device {
 	bool (*is_enabled)(struct mlx5_core_dev *dev);
 } mlx5_adev_devices[] = {
 	[MLX5_INTERFACE_PROTOCOL_VNET] = { .suffix = "vnet",
-					   .is_supported = &is_vnet_supported },
+					   .is_supported = &mlx5_vnet_supported,
+					   .is_enabled = &is_vnet_enabled },
 	[MLX5_INTERFACE_PROTOCOL_IB] = { .suffix = "rdma",
 					 .is_supported = &mlx5_rdma_supported,
 					 .is_enabled = &is_ib_enabled },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index f247ffb325a9..6f4d7c7f06e0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -680,6 +680,42 @@ static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
 	devlink_param_unregister(devlink, &enable_rdma_param);
 }
 
+static const struct devlink_param enable_vnet_param =
+	DEVLINK_PARAM_GENERIC(ENABLE_VNET, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, NULL);
+
+static int mlx5_devlink_vnet_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	int err;
+
+	if (!mlx5_vnet_supported(dev))
+		return 0;
+
+	err = devlink_param_register(devlink, &enable_vnet_param);
+	if (err)
+		return err;
+
+	value.vbool = true;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_VNET,
+					   value);
+	devlink_param_publish(devlink, &enable_rdma_param);
+	return 0;
+}
+
+static void mlx5_devlink_vnet_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!mlx5_vnet_supported(dev))
+		return;
+
+	devlink_param_unpublish(devlink, &enable_vnet_param);
+	devlink_param_unregister(devlink, &enable_vnet_param);
+}
+
 static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 {
 	int err;
@@ -692,8 +728,13 @@ static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 	if (err)
 		goto rdma_err;
 
+	err = mlx5_devlink_vnet_param_register(devlink);
+	if (err)
+		goto vnet_err;
 	return 0;
 
+vnet_err:
+	mlx5_devlink_rdma_param_unregister(devlink);
 rdma_err:
 	mlx5_devlink_eth_param_unregister(devlink);
 	return err;
@@ -701,6 +742,7 @@ static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 
 static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_vnet_param_unregister(devlink);
 	mlx5_devlink_rdma_param_unregister(devlink);
 	mlx5_devlink_eth_param_unregister(devlink);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b36fbcdc048e..2059b7319867 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -273,5 +273,6 @@ static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
 
 bool mlx5_eth_supported(struct mlx5_core_dev *dev);
 bool mlx5_rdma_supported(struct mlx5_core_dev *dev);
+bool mlx5_vnet_supported(struct mlx5_core_dev *dev);
 
 #endif /* __MLX5_CORE_H__ */
-- 
2.26.2

