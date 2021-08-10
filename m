Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B0F3E5B75
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 15:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241337AbhHJNZi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 09:25:38 -0400
Received: from mail-dm6nam11on2066.outbound.protection.outlook.com ([40.107.223.66]:20832
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241392AbhHJNZL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 09:25:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMUHdcNhidoGUayoHKAb6z3VYN2Cokfv1yHYLjTdiV+lBJ5K7DZ/6fi0vVPTT0H5EmJ1ckPXZY7+UGuRmktm4oTEzy8V3rQmlNn6GYo+3NTlRUMbLw/s3c5O4owt5+zDxHmpapRqU67KMvBviU8rLGbvJzESBztEoE3M5zdDNH9dRNn7e0sALWnGoAE7aX5+ay0xVx0R77KB7Gw96au+igefO3bG5Bbiz5lQl9W6/zzDE6Oxj4hwCcQ0h8ybCxr9XRqB1f2HoeKzf4dlNEVBPBQGCECDRhF7rnIVz3inQFdl2Rx8NHxZftoXP8SMOD3COLixLCRFbzEC8mr9mSJI9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iXo4z2/Ri5/oZGcxg8c8pCO+V3MDICBW3Ltzca7OPw=;
 b=nwogOKgXs9gRinZ71TJcYAMm+LcS6OIk4RDEo1aRMLIb2P8Sjg80ZplbG3h5WOQCPENYhcR5MagcTsInL8Q0tecPJv9G8Zm6DZZNrurzKYUifQPO3+TJsXfztI5GprEdlIKmeAmETafe+2koidnLgmkWZB8jA5G1yQXd9PxqWLAI0MpvgpfyBymKfTdytQQyE3rjgae10o5S5AbZSpTbpvU7iOhZJOMNoKddHD/OvtHvHbp79dedulG2cmTj5E/X1O5ZBv7jY3KF1k9MM6Ko8YfOAfQL3AaFeYHzsw0O90HMspQWxMiO/yyJpkeWvW8p2vz940Hr/V4dtvV4M1Oy3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2iXo4z2/Ri5/oZGcxg8c8pCO+V3MDICBW3Ltzca7OPw=;
 b=eHsAVLnn51BiMYyta3PJ1PSDO2c2914qZ42BY9zYtlgp6YmBJ8BL5+Y3YStnJykxhu7aHC6si2TnnGHGGmA8Up8+doiwRFKZKEjtGl+FTqUo7VsWcgL0SHM5vYcHQscOPSjsG43TN1eXKvJOBVRhQDTHyyckd8Y+oqzS+is4cvG/A3xvdrLtO2OromLvNTOuz8DaFbWgT98sR3ltqRH08y08/fANgPX0isXPc7xteKXbrZSC1tGslwSwHJtTATnDVwB+Ck6AFeOywO6lESQN76JdaxAK93KUPR6lVXRz2IemYMf4bE9K9ubBNt82kM5I4Dla6t8VOI/OLAzurjMwDw==
Received: from MW4PR03CA0004.namprd03.prod.outlook.com (2603:10b6:303:8f::9)
 by BN7PR12MB2673.namprd12.prod.outlook.com (2603:10b6:408:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Tue, 10 Aug
 2021 13:24:47 +0000
Received: from CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::55) by MW4PR03CA0004.outlook.office365.com
 (2603:10b6:303:8f::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13 via Frontend
 Transport; Tue, 10 Aug 2021 13:24:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT017.mail.protection.outlook.com (10.13.175.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 13:24:47 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 13:24:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <linux-rdma@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH RESEND net-next 09/10] net/mlx5: Support enable_rdma devlink dev param
Date:   Tue, 10 Aug 2021 16:24:23 +0300
Message-ID: <20210810132424.9129-10-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: 26ec7643-71a2-4d2a-07ee-08d95c0239a9
X-MS-TrafficTypeDiagnostic: BN7PR12MB2673:
X-Microsoft-Antispam-PRVS: <BN7PR12MB26737767F22184114FB6D67CDCF79@BN7PR12MB2673.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TNdFg4k55sYDHEhDmnmYBBuLKIDMtvbctJBN/q/9sTbZp/bD19L5RAyjBTqqBtdr0ZlF5rCRKEHqoOLjhjSLcPCwYPfAtUCs1vHcV899aFhMc1enrA8ddTiursWatWoelwdNopjCh9KArNohAK46Ue19mYI9meRSrn9XFiqSAqsV8Za2VAcRM+uWw50CZd9/sVSwn9mmXkVV8uNBuqS9FqLqZhuchGRlGqcjtqzXr9dlSo5TFipmT4ydEzxn2KkwaEnijx1+5Jl2CYZtzXaDXuHS+RE1WaAMuiyvIN2BQCFOF+KOMy4/7n4BOxXzBN2BAS6dDsAxDvaPv8tQTRvSvsdW/LKk2pDGeQwyyz2b8ZKyTbF5tttAuDvPF3CM2kqL5eLqHjEYEaJgFAfERyTN7nOKcD3uk5DUpqVhU/eGpDt7k9emr71RnpztladNpm4UioBcLQ2D697t3pzQWP0rEfhStMQlIBgSuyK7a3Jb3YXO/faba8Kk7B4O2mZU2+vJPKjRWjQ6f/UeBSPnIDpB06Ljl9vhT9YoQdsRpRBVynWb3MWT6uiHh0+oTQobP9++go9uNUbXElbCQi5to69VRjgIPyXGHewUHOv11TSEsbkQhZvE+B2Iv4THZhTVgPdrSxkdWgRI/xrHMmNFLtJZ4gVPqRJiiHpc8Ulx0SiYZXMO9ZeAsWOHX9rgcO5iFyK8ORGm9GH+ul45ngE49mVIMg==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(136003)(39860400002)(36840700001)(46966006)(2616005)(54906003)(107886003)(47076005)(82310400003)(426003)(4326008)(36906005)(110136005)(8936002)(336012)(83380400001)(5660300002)(70586007)(82740400003)(70206006)(26005)(8676002)(478600001)(2906002)(6666004)(16526019)(1076003)(316002)(7636003)(86362001)(356005)(186003)(36756003)(36860700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 13:24:47.5605
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 26ec7643-71a2-4d2a-07ee-08d95c0239a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR12MB2673
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

