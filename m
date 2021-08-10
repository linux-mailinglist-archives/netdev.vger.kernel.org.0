Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6809B3E595C
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240334AbhHJLrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:25 -0400
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:12481
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240267AbhHJLrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxPZ2Y19yNZ0W/kJciLRU8h6jY2SAkUhrqkdNDVgZ9B9tEQHF0S4vo9OR9c2WasUyoqaOEpZ3mt1gwM/ogrV3KDFOCgK/XAfRcpKwemxwtIaUH55/usfh7+5RYi/UE8JJZeABQEED6z7GJ9zCeeFg/qwTsG7J7jqHanQfisk/mRezgxE7yPtca8VpxwHwCglpsYAzcquzD6Cmu8bp2BfHL03P/va/1dFLlWuCGuzhG44SsKWHklA6Ktt23XlKAWoNOyhUlLduBUq5ETsoUz4bH4uLgAKMl8cHyyH2uduKyqnHlPOy+igNknvbBA+hx6XrS+rooTeE3oHU+bH8Zi5rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iXo4z2/Ri5/oZGcxg8c8pCO+V3MDICBW3Ltzca7OPw=;
 b=HEm9PNt/cx/AxVePZsoB/MNspnT28ay4U4BCc+zJGnPtPeeu5LYdqLy60PUPUONXkIMtDU0yPHSVIdD9Cr3tcvL/NBeTbBbQwF+dMayVsklJb6QgTnPgsD98X6rkaQmcivQ6YqXqy8Hnk4oPmHBmr01vz146neCXLSHKnDeGdK85MlJrxxr/0m/ayaNC+GbsZyg9fN8beUvpjzisrAjpIxB4cGmJzQhGHIhQ5N56kgoCeYE9bMYqbnZF3/3OcbcejCgjBomgP+1abZsIOu+k8nHoTZf7HNjDDc3Mh9eosQohSk1MiqPeD6cMJYwXb2FT6jJk0PNpkc8J093BY5mwGA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iXo4z2/Ri5/oZGcxg8c8pCO+V3MDICBW3Ltzca7OPw=;
 b=nzVlBk0tkGBelk4hu5il6K3Tvy2tsZDjHhGmGEEhJYVWo/neyRLQvv+LRFIvNAjz3NOuOy33e50Kle/CskW8oalCVqdq0Q3HqXiBU/vWBgTc2/2iIK9uCwy/LtxQ9lzP0vYbsg2vDhYnEFvgQBOQA6chieauAymPSyIDz0dMsN+gjy+23zt++Z3QQgIuRsaylTC3sKyarQkUxC4vo2YSygCTcVYlZ1bQGmbSjqsa0cDUmVYf0C0UARJtnqyufmZMp/QMJRaN2DZ0j3SjDDRoexVSSxKzu3xnoaaJ/5mzhDFsVXEddVo/ZKIkHFATORQGLnMJyTgMbXoNR40Crpovzw==
Received: from BN9P222CA0026.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::31)
 by BYAPR12MB2998.namprd12.prod.outlook.com (2603:10b6:a03:dd::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 11:46:45 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::1) by BN9P222CA0026.outlook.office365.com
 (2603:10b6:408:10c::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16 via Frontend
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
Subject: [PATCH net-next 09/10] net/mlx5: Support enable_rdma devlink dev param
Date:   Tue, 10 Aug 2021 14:46:19 +0300
Message-ID: <20210810114620.8397-10-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 90dadf90-df67-4a0e-ea74-08d95bf487b3
X-MS-TrafficTypeDiagnostic: BYAPR12MB2998:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2998F646F7469E6164D56AE7DCF79@BYAPR12MB2998.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wXzlcJCqd0s5juT4ay7iHmNZCqLiDrp2isc3bONfFbAgtMBgX81yeQKHMKSdF+YKe8y4c8xnnt/R2TKyPsPdxoTJjjZpEhiyyhAXCfGvJLFfckbms1p2NE7apNhBnpxQY6VkosuswgxuHDwWy6KmfWSrkoBqsJYINr1H0hubdsJKWfrOJUpSsZBa2U3u0T3gu03Gpdx1N3yu3ttA8Rykosm70QGn4DF8OQASbuBZexTczoLq33xBHbfCSHfYAOntpLn+juUcG0qJyZ7r0VM7K13OS8lt6RMeW8wjbENmem8GdAfRQw+/XcPwi2F0IN+wBH1jQZWBplTwhzCvrMAJXGaRQJaT0+PxmdU/vgjjeYJFkFFGKrNjTvVKOyjOdWRlMf0x4LBw2C4tHK2e2xaeq4vlBvTQCwoPpg2ZWk7w94hDn3AQS05QRonxAqHa2JMvwuBXajENhvO+VkQAFynWXvaPTJtbPc77eFdcPack7xO+7qoxPLb+m5155TpGTvbavotwxyja5N3OjGWG9hiDEzwnALFlqebOwZbWAVzHFflzXM4wMQr4EZUuSoqY+2KFNrEIh6C/j+nTLBa5nwcZpmwD1nTo8FzQKIG0vMOXYw/Pntx+fkCRLbr8h/aoCmuLY0SE0s+Astln5uQ35FfxX+dCCXan5KSC71Yi6wKq+6SHC/AkhGr6C9Uzbp4XjjGPNwK54OV8qBkKosk/i2Uiyg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(39860400002)(346002)(376002)(136003)(46966006)(36840700001)(36860700001)(86362001)(26005)(36756003)(8676002)(82740400003)(4326008)(336012)(8936002)(478600001)(7636003)(36906005)(1076003)(6666004)(16526019)(5660300002)(83380400001)(316002)(110136005)(54906003)(47076005)(2616005)(356005)(70206006)(186003)(426003)(70586007)(107886003)(2906002)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:45.4859
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 90dadf90-df67-4a0e-ea74-08d95bf487b3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2998
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enable user to disable RDMA auxiliary device so that when it is not
required, user can disable it.

For example,

$ devlink dev param set pci/0000:06:00.0 \
              name enable_rdma value false cmode driverinit
$ devlink dev reload pci/0000:06:00.0

At this point devlink instance do not create auxiliary device
mlx5_core.rdma.2 for the RDMA functionality.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 16 ++++-
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 65 ++++++++++++++++++-
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |  1 +
 3 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index 10c4309f29be..cb86844099c0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -181,7 +181,7 @@ static bool is_mp_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
-static bool is_ib_supported(struct mlx5_core_dev *dev)
+bool mlx5_rdma_supported(struct mlx5_core_dev *dev)
 {
 	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND))
 		return false;
@@ -198,6 +198,17 @@ static bool is_ib_supported(struct mlx5_core_dev *dev)
 	return true;
 }
 
+static bool is_ib_enabled(struct mlx5_core_dev *dev)
+{
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(priv_to_devlink(dev),
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+						 &val);
+	return err ? false : val.vbool;
+}
+
 enum {
 	MLX5_INTERFACE_PROTOCOL_ETH,
 	MLX5_INTERFACE_PROTOCOL_ETH_REP,
@@ -217,7 +228,8 @@ static const struct mlx5_adev_device {
 	[MLX5_INTERFACE_PROTOCOL_VNET] = { .suffix = "vnet",
 					   .is_supported = &is_vnet_supported },
 	[MLX5_INTERFACE_PROTOCOL_IB] = { .suffix = "rdma",
-					 .is_supported = &is_ib_supported },
+					 .is_supported = &mlx5_rdma_supported,
+					 .is_enabled = &is_ib_enabled },
 	[MLX5_INTERFACE_PROTOCOL_ETH] = { .suffix = "eth",
 					  .is_supported = &mlx5_eth_supported,
 					  .is_enabled = &is_eth_enabled },
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 557973c9212f..f247ffb325a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -632,13 +632,76 @@ static void mlx5_devlink_eth_param_unregister(struct devlink *devlink)
 	devlink_param_unregister(devlink, &enable_eth_param);
 }
 
+static int mlx5_devlink_enable_rdma_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	bool new_state = val.vbool;
+
+	if (new_state && !mlx5_rdma_supported(dev))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static const struct devlink_param enable_rdma_param =
+	DEVLINK_PARAM_GENERIC(ENABLE_RDMA, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_enable_rdma_validate);
+
+static int mlx5_devlink_rdma_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	int err;
+
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND) || MLX5_ESWITCH_MANAGER(dev))
+		return 0;
+
+	err = devlink_param_register(devlink, &enable_rdma_param);
+	if (err)
+		return err;
+
+	value.vbool = true;
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_ENABLE_RDMA,
+					   value);
+	devlink_param_publish(devlink, &enable_rdma_param);
+	return 0;
+}
+
+static void mlx5_devlink_rdma_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!IS_ENABLED(CONFIG_MLX5_INFINIBAND) || MLX5_ESWITCH_MANAGER(dev))
+		return;
+
+	devlink_param_unpublish(devlink, &enable_rdma_param);
+	devlink_param_unregister(devlink, &enable_rdma_param);
+}
+
 static int mlx5_devlink_auxdev_params_register(struct devlink *devlink)
 {
-	return mlx5_devlink_eth_param_register(devlink);
+	int err;
+
+	err = mlx5_devlink_eth_param_register(devlink);
+	if (err)
+		return err;
+
+	err = mlx5_devlink_rdma_param_register(devlink);
+	if (err)
+		goto rdma_err;
+
+	return 0;
+
+rdma_err:
+	mlx5_devlink_eth_param_unregister(devlink);
+	return err;
 }
 
 static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_rdma_param_unregister(devlink);
 	mlx5_devlink_eth_param_unregister(devlink);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index b3dfecf4f433..b36fbcdc048e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -272,5 +272,6 @@ static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
 }
 
 bool mlx5_eth_supported(struct mlx5_core_dev *dev);
+bool mlx5_rdma_supported(struct mlx5_core_dev *dev);
 
 #endif /* __MLX5_CORE_H__ */
-- 
2.26.2

