Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A570946E65F
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234120AbhLIKOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:14:00 -0500
Received: from mail-bn8nam11on2070.outbound.protection.outlook.com ([40.107.236.70]:2973
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233364AbhLIKNs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:13:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lRVzj/M/LB7wE6uEQ7tftuL1nH2HbwcqmHDYr1eN06DCnGWoRhuh1pmm49diQSDoHkjkg0wB5IR8CzDXjVfiPQwqe83OQPl2ydi0DwvraT+mSii0CbdDNdI2IJa7qb/rpMdJgkiZ+G3AeXMzkR2Itt0L6LlqXBj/pSxAR6wHD/VygghWNTJVKuLal/CfOqJDLiEu+5zbv/WunUHTziOBDLF7c6hToOSIGWJQTBWHImcRM4sRL9CiCTcP1Yj90aj7UwUtrJwpZeKob2Ebzp0KljyIh+BWdd0caaGG7tY4VI7FvtLk987ZAisRl9CyrCAN7u6aqk4DqcGUEhw+dCPVSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c8d0TGroU7tkaElytOMwuSVvj7oxDRdutempO4+6cGY=;
 b=i8j3/RHJjJewzJBOSoLO2Qcct46elO2CCynywX7HSSp5EDVpQbvM5YQc+b4+lq7UUfx7+d9M61KZ2bT8b7aT41Oeb/V/SiB0Cdf9Zxaer4jpFduqySsW/baaBiKGd03az75b5CLraiE8c8qkZ97tO0U8+PfQt4tShHE7wDRCOkSWebo/0kf/5SeQMyCQHlaLYL6O2yEZATseYifftC8ZQ/uDX6I/yxVkPtQUD56XICFAGAnQ3z2xliAB8ZhzZdcFF4B5Bn/qmM8BFzEU82RhxRuZXjdoTGIkZedZuJMpVXoOG1/H2qCddhGi7U/qDpG+2BPLV9dHgDUk16g3vyvIMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c8d0TGroU7tkaElytOMwuSVvj7oxDRdutempO4+6cGY=;
 b=N8/qP0qbq7u3tuCSuf17ih09u3upyUWDMKBR4swwLLpU11FERdcCsKabyZTPR1olq4BLt7buTHu69C3YjPmrWDH7elYdIKY6GHV2Y8SaGxUmSiavgjwEYJMXvbtJCMgICIWMzSvZqmMACGWBk0a2FdsNxPc7ERGRVmhXA8/MFUWUu0DAphNZ0qeWpgy/eC2ApXwVbwWEYI4H/wdGpZ7UlWWdrkekkbikfbO4E/pQ+MWm0JGkhv+7VnXCVoBSMPQ+GGeeOxOXoKgio+qSf6OegLLz+77pqJSqiMpUJ5aQ7jRVTXo31R5gRH0zOL+HIoDYKQfbMAKNJ0fz3Ric303i4Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5373.namprd12.prod.outlook.com (2603:10b6:5:39a::17)
 by DM4PR12MB5311.namprd12.prod.outlook.com (2603:10b6:5:39f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 9 Dec
 2021 10:10:09 +0000
Received: from DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac]) by DM4PR12MB5373.namprd12.prod.outlook.com
 ([fe80::10d0:8c16:3110:f8ac%7]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 10:10:09 +0000
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     jiri@nvidia.com, saeedm@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v4 7/7] net/mlx5: Let user configure max_macs generic param
Date:   Thu,  9 Dec 2021 12:09:29 +0200
Message-Id: <20211209100929.28115-8-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20211209100929.28115-1-shayd@nvidia.com>
References: <20211209100929.28115-1-shayd@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0076.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:88::17) To DM4PR12MB5373.namprd12.prod.outlook.com
 (2603:10b6:5:39a::17)
MIME-Version: 1.0
Received: from nps-server-23.mtl.labs.mlnx (94.188.199.18) by AM6P193CA0076.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:88::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 10:10:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0361eafa-60da-4b3e-15f3-08d9bafc148c
X-MS-TrafficTypeDiagnostic: DM4PR12MB5311:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5311A71C18D24BFBD92BD13BCF709@DM4PR12MB5311.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DGB9jfgDykYwkzT4e7mT3+LR+nnEjzFCQCWTIqEzhyV2z1gijksgk/LkKQuhYlkE6X04nwS6EtFvYTDaNtAulBPw4d4h5PYJ7KgJWPj7Qmn5/z5OgKLwvlRlf4fc4RziaXLmNTg4Wxk3z/dCT6CGA91WElG5bSiddu3vLMosXhTbQ6jmi3SdSwpo5foX5kq0J0CzwmwxXwMxo2nYpo9/5KjCzTfXvOLqponBEbsFlZZIM1vxuZv9jKYJNSWXDc1oPuEPeeNcOlRpcMNgjzqJtfsID4gcatKGd4Qw6OAKjVyFQXrgvmuYFtWiVeYj9mZcz6WyjDkvpu0vS5N4eQMou32J2CDd7PlvOUq5yee9mQLbEPQ75ATCzHLOhacMl9x2MzYAVoSbjRI8w4EnACtAJPbTyjq8d13gCwCUasRRE2Z2uwhxSYV5Md3ilvLXnWdifQ7hV6iXxQMvMa5GtUpjSWH8ZCiO8TAIp2ckkACiCX9AKh99f/6+xqyKnyogKTrg6CwWSbBeaJzKgYjAfyWspMvB/dpAeHYWJogJyIRjzMY4QcbJLr6fZqsOFXmvWfyEW+qe56BaZ5l8p//c/fcpG0R5ZntEDAfIPs6nYs+JT1bD5hFnbfXK1452j0RtF9YD08fbSaaPh7o9KUk3laVsvqGe/vApZlOKNVW6HTkvyQ2jeYbSpc5ueWk4BSfOOrt29DddsI12ajMlceFulv+8v/rHQlznyWtsyUFy0bJwnII=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66476007)(66556008)(956004)(38100700002)(38350700002)(2616005)(508600001)(6666004)(26005)(6506007)(1076003)(4326008)(52116002)(5660300002)(316002)(8936002)(54906003)(110136005)(107886003)(2906002)(8676002)(186003)(6512007)(36756003)(6486002)(86362001)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5RHMScSVQGfmvni6YbQsPr5t8UyEgtEV6l5tpvmK7my/g3QtcKI9VyEUVY3?=
 =?us-ascii?Q?SIANWZblJ/LuP4f5UFJIKZlwFwpnEUAKmVv1CXAn1iVVTjc7co1VnEidUew/?=
 =?us-ascii?Q?Tjx1khcn7NobyP+i64Jr5zeqSs04Q3Jl2lyH4pZ2GGaQ7jQPzWXStcdxuuwP?=
 =?us-ascii?Q?GEy3BJqyb6Pvda39pusUyfXMwhxSyD9KkJIN0tNdlBRElbZfr4K/mznxSgDG?=
 =?us-ascii?Q?mO4SeIrtGvdfLfuakktAXzkWIXOn8U/mhw6TLDRUThjkAvuQH1fBU6S3R824?=
 =?us-ascii?Q?8S2iU4xb3w4Rf6jk+rf0hjJfZnJS/3X93nJUWH4QihtNSe2DUsBXBEGQx+ge?=
 =?us-ascii?Q?1WbrI8HrB/aQEGYiLm7ers/mhcSRw92vi9keki95zEao7HG0fqPjwjZpZFwN?=
 =?us-ascii?Q?RaZGOxGVaAioA1s13+nxOGjjEwjHaJgzhMigSLImbj/xuWLeEVRcYWc/TTbM?=
 =?us-ascii?Q?OJHwCxn47k1z6KmguGuvyl3HVQFPlV40hcaaQN9jX5RJRgXJmssG2E0THnpa?=
 =?us-ascii?Q?U29Kq6OhT7pFGPQKiQbOUF+f0FpXqZlUp2qY6zyR+DiMN+iIvsha0KJnKgsL?=
 =?us-ascii?Q?AUN3zFgM91fxBbbAEuisT7U/bdaIGNPPwUY6D3LKMvPlsmPQdfhFN0qaCobJ?=
 =?us-ascii?Q?HRCZ0E2bwP1zlAZ1DKGe/w+170r7lRO3dDPh+A+2DDxW2F7Ilvy1ScfB/ni0?=
 =?us-ascii?Q?ADM7lUu34UuALN220jlXfj6jjXA1CKiwMHnMN2TTZESIUiYJM/PSKNEl3xm2?=
 =?us-ascii?Q?bdmMVvY2FGNMB8bE9ZRebYpvK3zRcAQZMXLNkb3+7lFu/SnNT2RKeZuR0Mol?=
 =?us-ascii?Q?N0Fr2LWmjLdqM1Hdrs/JGVoRZaAnIJBg7Lqslte7SYldsJ60lmaCnbkHHxdJ?=
 =?us-ascii?Q?6u0VltR9arE9xL1e5dBGDAudf+6MZSyF1/0E65UTObzt3EV6TtcaMxXSM32R?=
 =?us-ascii?Q?qP1fsodRjJOZ/5ou7O4tI0DoafWKr3b1DD5nfv8kl3lRDyv/2zyV68K5a3A8?=
 =?us-ascii?Q?Ncl659b3bqfYhm12868wQ6eag2ZnjhzeRUiPsGgAhUl20mQnhpPNxDcHmrpZ?=
 =?us-ascii?Q?f/oUct271uKXXsaNNtZf2o3W65EsCpkWldE9BKRcYALL2SndehxLWEa/muk/?=
 =?us-ascii?Q?G/4hW1DtrrWmbrZ350q5H8VeIXH9gyZX2MAoCllYRzMjA5idPevC2mmQ3i/c?=
 =?us-ascii?Q?U9cNDZ5P1okAaa8p7XElTLqlqGPBMQeRe/jzv979gBnuWTHY2Z3JRy0AIkAH?=
 =?us-ascii?Q?zuCPbk1lw6RDwHz0kJplBOry8CI3193VUyUihbOeKDTChyi1raSD3spHgMDV?=
 =?us-ascii?Q?0zaAHWmUix6kqe+FG1E6xIpkp4XhKPC8hivKt171j58IBf3f0BAL+0qlB4Qo?=
 =?us-ascii?Q?5lilAp0J1UYXzzpafd1+K9Lf9t9Qok9eSlafOwqdyJHDkogyA45O2UeavzpC?=
 =?us-ascii?Q?wmGqUPesK0gK/5BNBWunSGuz3ErQZ0PGF4u23wFo177mqpvzmhQ3aOmpTTuf?=
 =?us-ascii?Q?M1QEfLcB2TTm5P78ccPeLhv8bfCr6dsSG8s9Fq6G83mo185AVYMIHsT/d6ez?=
 =?us-ascii?Q?zjDa8z3dvCFWzV8ISP60+TCc1fytNFgwqsO4iy1r06jrzfH8Ekb3Nc5Qy6Dj?=
 =?us-ascii?Q?eozMrjoPc11x6/n2RNio0kw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0361eafa-60da-4b3e-15f3-08d9bafc148c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 10:10:09.0847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: udWIug0D4gGhJNBGb84zIsJDc1ny/jxdrCSXtNFWzeXBtoUGCCwUWnX0x0oZVGEhBOkPnUVtLwc4eSH3RVwaWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5311
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
 Documentation/networking/devlink/mlx5.rst     |  3 +
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 67 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/main.c    | 21 ++++++
 3 files changed, 91 insertions(+)

diff --git a/Documentation/networking/devlink/mlx5.rst b/Documentation/networking/devlink/mlx5.rst
index 38089f0aefcf..38e94ed65936 100644
--- a/Documentation/networking/devlink/mlx5.rst
+++ b/Documentation/networking/devlink/mlx5.rst
@@ -23,6 +23,9 @@ Parameters
    * - ``event_eq_size``
      - driverinit
      - The range is between 64 and 4096.
+   * - ``max_macs``
+     - driverinit
+     - The range is between 1 and 2^31. Only power of 2 values are supported.
 
 The ``mlx5`` driver also implements the following driver-specific
 parameters.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 37b7600c5545..d1093bb2d436 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -773,6 +773,66 @@ static void mlx5_devlink_auxdev_params_unregister(struct devlink *devlink)
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
+	if (!MLX5_CAP_GEN_MAX(dev, log_max_current_uc_list_wr_supported))
+		return;
+
+	devlink_param_unregister(devlink, &max_uc_list_param);
+}
+
 #define MLX5_TRAP_DROP(_id, _group_id)					\
 	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
 			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
@@ -832,6 +892,10 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto auxdev_reg_err;
 
+	err = mlx5_devlink_max_uc_list_param_register(devlink);
+	if (err)
+		goto max_uc_list_err;
+
 	err = mlx5_devlink_traps_register(devlink);
 	if (err)
 		goto traps_reg_err;
@@ -842,6 +906,8 @@ int mlx5_devlink_register(struct devlink *devlink)
 	return 0;
 
 traps_reg_err:
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
+max_uc_list_err:
 	mlx5_devlink_auxdev_params_unregister(devlink);
 auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
@@ -852,6 +918,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
 	mlx5_devlink_traps_unregister(devlink);
+	mlx5_devlink_max_uc_list_param_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index d97c9e86d7b3..b1a82226623c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -484,10 +484,26 @@ static int handle_hca_cap_odp(struct mlx5_core_dev *dev, void *set_ctx)
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
+	if (!err)
+		return val.vu32;
+	mlx5_core_dbg(dev, "Failed to get param. err = %d\n", err);
+	return err;
+}
+
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
+	int max_uc_list;
 	int err;
 
 	err = mlx5_core_get_caps(dev, MLX5_CAP_GENERAL);
@@ -561,6 +577,11 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
 		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
 
+	max_uc_list = max_uc_list_get_devlink_param(dev);
+	if (max_uc_list > 0)
+		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_current_uc_list,
+			 ilog2(max_uc_list));
+
 	return set_caps(dev, set_ctx, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
 }
 
-- 
2.21.3

