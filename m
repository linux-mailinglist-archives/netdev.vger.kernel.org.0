Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28F146399D
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 16:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232359AbhK3PRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 10:17:51 -0500
Received: from mail-co1nam11on2078.outbound.protection.outlook.com ([40.107.220.78]:9857
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S243987AbhK3PLk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Nov 2021 10:11:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nKunJix2ARRQ0/lpAoDSPc9XxtFRuSvDKHeLKAvBj/hs4ruuW5G+FdjIsXHHG9YpGOYVBkHMM/UQVyQzkXd6CZyVM9c4x7B7/CRLRwCdIHuh189TtKdkrNk/qRXnXpHD1vgCj1Z8bZr8KIQEAAplVDHgYY5i/fEu08btajjheoizpwBUazLLx3IIoJb+6mGcN1Y11nnnaTGWtRpTMJnCopgmoY6W7ZRlE2g3+KT7kqEA9RkszJbl1tT7Ntr/eQNAY+MCzlkeZIVgn32D0KKNl7y03l2tSTa057I6ZrwVYNFkiaTezgxy8g+hEEwxJTHXaQCoUMB/43zRAakNOsB3Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yisAUPwLX4kOwEXgCoZ5eU+ukSxjfZWo82ryTBROEVM=;
 b=jFMF0lARuGG0q3v+Fpd9MlVd2DCZ5pbSpW8OUngqWX78oY6A2GApOmJ7NfdFKVjan4yt3Pppgr7VK1nKQDYiKzcoGCkJuZ8JB2zpP/90fBfHrT8tpvwQSYAb/fYHpO0FTbktpUlF3UVjYXMT1+w7ubZV5DMwk0C6JVJJbLecBRJPIXqSdrO0wzOY12QaipttwjaYTH1Uc++kV/GDG2Ms9NV8ZgjJXWEXwUsfN43K0KNJvCdj2208YE7Rr+PduiYFEfCrBjlsM+kiHyi1soDf1SHX9RVKwRC4VFMk/7RHfWexgWW6L9sECdq32CM7AqLzrMP28twm81y18UisuZtyHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yisAUPwLX4kOwEXgCoZ5eU+ukSxjfZWo82ryTBROEVM=;
 b=sIAhEc5VoruYx6yR3J9a9Drk2pveZdSZUKaAR0wAJnBNgmj/vgQ/RtZvHc4nhpnziYN1QVuCIo29jK2+vYvGNsao2eRHipJnYaGGky8lJ5PjzedAEBRkb3w0cnAkkYEA4kQ4t5Q4IcFBqTK9nSfYt6g0yH/t2F41DHEtl+lPSsTFU7f/O9BPhhhuNGgF3HxDBfztHsbfwXWUlb2C6weafkRxdsEH3oQbTiDJtIoMpr1X6p5s+pYb4kH/TOz+GslEp8L3Ixg3LdIsF33IYDjRZRBPxgWBKh+uMaYaKz8YlBeq6Tz1dF8CnMekXAWTEMrRErMIbguyoL6eL3CfGY/lng==
Received: from BN9PR03CA0352.namprd03.prod.outlook.com (2603:10b6:408:f6::27)
 by BYAPR12MB3285.namprd12.prod.outlook.com (2603:10b6:a03:134::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 15:08:16 +0000
Received: from BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::da) by BN9PR03CA0352.outlook.office365.com
 (2603:10b6:408:f6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23 via Frontend
 Transport; Tue, 30 Nov 2021 15:08:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 BN8NAM11FT004.mail.protection.outlook.com (10.13.176.164) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4734.22 via Frontend Transport; Tue, 30 Nov 2021 15:08:16 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 30 Nov
 2021 15:08:12 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.5;
 Tue, 30 Nov 2021 07:08:08 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next 4/4] net/mlx5: Let user configure max_macs generic param
Date:   Tue, 30 Nov 2021 17:07:06 +0200
Message-ID: <20211130150705.19863-5-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211130150705.19863-1-shayd@nvidia.com>
References: <20211130150705.19863-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88fa3d58-170e-4cdd-93d9-08d9b4133cb0
X-MS-TrafficTypeDiagnostic: BYAPR12MB3285:
X-Microsoft-Antispam-PRVS: <BYAPR12MB32851089EF6C91C71A5EA60ECF679@BYAPR12MB3285.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TroBcrYoSgB24Nc4gC1zVz/YsQO3PL3oUHLZpNLsym/Kty0zjzLQ0lCiRZq0JiAfZxmBQV+ZHg0AoH1GFRxhyGasahHZO3woDr4aGtysgz2o3J1knC54+Nrt7SXn01FsZii17TfQBEDOq4WugpQ4AAErfheTdgN4fzjuIXCYV0VxRznR1f8TPDU30wfiVzaMG2si+Ln0U7WUxm9RSBnwxYe0qGR1XX2COjildGUB8fEN3RjpPF1Z5/WAg7lP9FC/ia0a3WFuwhZv+Ih2LhSj+AhtkkvSAN5VvTvJC/9uw/8DZYNttXh/owBjqIbUlZbUB9ZHvMxGehmEnsjdeJut8DM6JLPb+GD+ev07l6o8s4kU6O1XSw8EeN7zqibNzCOO+yVJ56D5dGXSko7uqqFgMGO5gjusfyHOn71JXeBCSk5qNV1tjBjBS/dolEv4n9jODE9HWEg2zgkrDLr3s8TLpxFTDD1GykzeEuHcGiVnwgWE5fmC53HVd5XaZSchdhCLSz9aUcGWDa/pGsmk38ganazLd8bqhvbgsYrBlKhMnWa5aLJNoc7bPueE54LlecqU4LaLVRd8/BAih7AXzIKh93qcCFO6nhbGp1QcTc1S7w0BEzdyk5q408NLJhWmOCP4nZQqZmk1678nZODr76tT+w1BF/tCVhmk3ajnUFVGXjZFo/3/8IktFgjL0R3mUTqH+NybSlZ5q7tXG1xsawiY6Yju6WVRB+PPXnWiSYgc9SMgXKIWUvvsIy2tSJ+gTA48X87YK4Ok99gSoXbZNfhP5l5YyWnyPh/TV+/cJO3QgRk=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(40470700001)(36756003)(2906002)(70206006)(110136005)(4326008)(36860700001)(47076005)(7636003)(316002)(83380400001)(40460700001)(8936002)(16526019)(186003)(8676002)(107886003)(508600001)(82310400004)(5660300002)(54906003)(426003)(336012)(2616005)(70586007)(26005)(86362001)(356005)(1076003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2021 15:08:16.3580
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 88fa3d58-170e-4cdd-93d9-08d9b4133cb0
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3285
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, max_macs is taking 70Kbytes of memory per function. This
size is not needed in all use cases, and is critical with large scale.
Hence, allow user to configure the number of max_macs.

For example, to reduce the number of max_macs to 1, execute::
$ devlink dev param set pci/0000:00:0b.0 name max_macs value 1 \
              cmode driverinit
$ devlink dev reload pci/0000:00:0b.0

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
---
 Documentation/networking/devlink/mlx5.rst     |  4 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 67 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 18 +++++
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 4 files changed, 90 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 4e4b97f7971a..c44043bcae72 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -14,8 +14,12 @@ Parameters
 
    * - Name
      - Mode
+     - Validation
    * - ``enable_roce``
      - driverinit
+   * - ``max_macs``
+     - driverinit
+     - The range is between 1 and 2^31. Only power of 2 values are supported.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..7383b727f49e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -752,6 +752,66 @@ static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
 	mlx5_devlink_eth_param_unregister(devlink);
 }
 
+static int mlx5_devlink_max_uc_list_validate(struct devlink *devlink, u32 id,
+					     union devlink_param_value val,
+					     struct netlink_ext_ack *extack)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (val.vu32 == 0) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value must be greater than 0");
+		return -EINVAL;
+	}
+
+	if (!is_power_of_2(val.vu32)) {
+		NL_SET_ERR_MSG_MOD(extack, "Only power of 2 values are supported for max_macs");
+		return -EINVAL;
+	}
+
+	if (ilog2(val.vu32) >
+	    MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list)) {
+		NL_SET_ERR_MSG_MOD(extack, "max_macs value is out of the supported range");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static const struct devlink_param max_uc_list_param =
+	DEVLINK_PARAM_GENERIC(MAX_MACS, BIT(DEVLINK_PARAM_CMODE_DRIVERINIT),
+			      NULL, NULL, mlx5_devlink_max_uc_list_validate);
+
+static int mlx5_devlink_max_uc_list_param_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+	union devlink_param_value value;
+	int err;
+
+	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
+		return 0;
+
+	err = devlink_param_register(devlink, &max_uc_list_param);
+	if (err)
+		return err;
+
+	value.vu32 = 1 << MLX5_CAP_GEN(dev, log_max_current_uc_list);
+	devlink_param_driverinit_value_set(devlink,
+					   DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+					   value);
+	return 0;
+}
+
+static void
+mlx5_devlink_max_uc_list_param_unregister(struct devlink *devlink)
+{
+	struct mlx5_core_dev *dev = devlink_priv(devlink);
+
+	if (!MLX5_CAP_GEN(dev, log_max_current_uc_list_wr_supported))
+		return;
+
+	devlink_param_unregister(devlink, &max_uc_list_param);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -815,11 +875,17 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	if (err)
+		goto uc_list_reg_err;
+
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_set_features(devlink, DEVLINK_F_RELOAD);
 
 	return 0;
 
+uc_list_reg_err:
+	mlx5_devlink_traps_unregister(devlink);
 traps_reg_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
@@ -830,6 +896,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index f55a89bd3736..a6819575854f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -484,10 +484,23 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_ODP);
 }
 
+static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_MAX_MACS,
+						 &val);
+	return err ? err : val.vu32;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
+	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -561,6 +574,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
 
+	max_uc_list = max_uc_list_get_devlink_param(dev);
+	if (max_uc_list > 0)
+		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
+			 ilog2(max_uc_list));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3636df90899a..d3899fc33fd7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1621,7 +1621,7 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         ext_stride_num_range[0x1];
 	u8         roce_rw_supported[0x1];
-	u8         reserved_at_3a2[0x1];
+	u8         log_max_current_uc_list_wr_supported[0x1];
 	u8         log_max_stride_sz_rq[0x5];
 	u8         reserved_at_3a8[0x3];
 	u8         log_min_stride_sz_rq[0x5];
-- 
2.21.3

