Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 130FC3E595E
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 13:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240297AbhHJLrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 07:47:31 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:29665
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240274AbhHJLrK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 07:47:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GG0n6bPkfKb2bUkZ6m8DN8DbzEQHJjPDJ0pYVeej/t49aE+rJQNr8kX0ES3DD4+Jxu238sXY7BmN/s+gY+GylcPmngpFxvWUetB2Oh9Vszky3jcKFTHs2zQK66kUbflWxh3OQdJZc+k4qPyOK2lvfXUXYNoBkWjIk744ausOPUknknCaWy/UKu+88NUiymCP6dJpO1DQwkoEsIjUw2v+JJpV9dxH1H9xcOTPM4zMHOVhm18CK3pUd/wYFi5PLcMDCOEp2S893saAoDHJb5E6LVq2vTP59cIA1KyepYikNKfTiNyKGbZVkGTSVLq93ObGf3rP7hGUEd32mnjRgILcww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIi8hzPJyZfyI2sfgdbiTFzKy/YbYasDVyImO8S2Rt8=;
 b=MP+B6pdKUUkZklP7payBnKwZWrKp0glyiEdIuXmIwfxcQv5W5WqhSCohihG6Zcd8tKDloEsXClCY+mLokjtNeltVJI09MC3IDZ5zvpDhmbCvzYDxcqvrqtw2lMyK9CUdp+Xv9sR5JUbON0cJnLL4Bbwc5JZZ+c2ATTXfZMI3PXK6zHma4zWfTrZSDl+Tv8Azl+XJKU7mmx4cul8Y8n+SvaeHtVnylbLvFg/mlkVJLpiftVjx6mE/ngXo6GN9UW+2o3inviOi2Xnzf8JBXuc1oa2pNKINZ1X/cTNPQYYtUjADNDJ2+UB6zSFlu+fFPLW0pFJuoxgPjePG3+pCI3jjGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oIi8hzPJyZfyI2sfgdbiTFzKy/YbYasDVyImO8S2Rt8=;
 b=Ph1x0Rnnavzh5jcjGjx84BOX1pbiLkfXFckcO8enU93sxzDxNq1MJ391WODq958JZ0YheZBAmx0/ODcc/yJhZJKljMUfKLuB31oNIjJUVlXrM5gvgMr98LhufdmJcbWwpunoxCderJJ+QeNR1QsxuIasMVMljXY0MeKCL0SY2foNv41V3L44fyp/skfH9ggA0EI+iCuClZI3XnZrZbBP5/I6YSZZfjmEWc013+8k7kyFH6W5y6SRpAMaYhC0f+GbJRD84b/Mu5xHPGstwn2GA/BbyxP2muMCAJoHVC1yv7VwJAO/VZii0iib0hjk81mAZ7zWlBqZ5h6QNnQBABRrLA==
Received: from BN9P222CA0018.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::23)
 by BYAPR12MB2648.namprd12.prod.outlook.com (2603:10b6:a03:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 11:46:46 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10c:cafe::35) by BN9P222CA0018.outlook.office365.com
 (2603:10b6:408:10c::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend
 Transport; Tue, 10 Aug 2021 11:46:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4394.16 via Frontend Transport; Tue, 10 Aug 2021 11:46:46 +0000
Received: from sw-mtx-036.mtx.labs.mlnx (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Aug
 2021 11:46:44 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next 10/10] net/mlx5: Support enable_vnet devlink dev param
Date:   Tue, 10 Aug 2021 14:46:20 +0300
Message-ID: <20210810114620.8397-11-parav@nvidia.com>
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
X-MS-Office365-Filtering-Correlation-Id: e8519c82-8d6c-4402-39e5-08d95bf4881c
X-MS-TrafficTypeDiagnostic: BYAPR12MB2648:
X-Microsoft-Antispam-PRVS: <BYAPR12MB2648A41A56876F716AAEC264DCF79@BYAPR12MB2648.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ikY3NHrw4Fbl3g1VkeEU6oGCLo+NbAw5/WArPxtmd89K/X6ARRobRe0S5MOG28r83yV+PUhwpbIDLsq02XhipINYfPNStzrJHAKewChPqwnG3mfZEV68cu/SN5XEMghT/eaURuModacGazhYI+4rSOQ0642jTeZvZRnTxGeynO7ESFcQsJWIjiEzUSXJCV+QLMAKg7Sm2WV+LQE1jVvq6lSSQlILzL8c59V/FBWKz4WWbLYKk5T/yrmkaguOFp+NGFZOFoGe0vIc7IMCWICbQVUxeKQQNJjcdywGe6MUCzcJGbfQte7f8HXr2FGZBXRoO2tD3w2iPyQsn5yew1KFHQGjAgKDbwt5i6MoIvrZjfX11W0f1+efhzXKG2/G+uI/4uLMxAvIXyTCBAXdBCbK82eBHTH3MpRsN2P8OsEGPXogdu90aSx6iZt5Snuz3qF8s6YNgRR768+i2IBnmy0BFGxBJMBBzuJ5xnOg+0r7fvIOeOzWmCkpnmiEZf4qrc7TBqCEFztr5O7AYLvgsiB5OwsfRPzPQ8lmYrqqPpw9W82hfeqlVBb1rL8Q2FqmSMYnUF68mtquTnflSy35SbLb/wSJChP+ibN34EJ7y1kuPB0LbS0zxvR7nXUfIQyEXREO7s9NtdUlwo0HNCB690rNVJJ6KYzyN63MYBCIbCx31Pa8ce9dA0iDgxjHTkWHp7R++AaO4X1aoEHj9w4mn3sRmQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(39860400002)(136003)(396003)(346002)(376002)(46966006)(36840700001)(110136005)(1076003)(82740400003)(36860700001)(54906003)(316002)(83380400001)(2616005)(36756003)(36906005)(356005)(426003)(2906002)(82310400003)(8676002)(86362001)(4326008)(26005)(8936002)(336012)(70206006)(478600001)(16526019)(186003)(7636003)(47076005)(6666004)(5660300002)(107886003)(70586007);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 11:46:46.1655
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e8519c82-8d6c-4402-39e5-08d95bf4881c
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2648
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

