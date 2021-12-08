Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997BC46CE12
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 08:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244409AbhLHHHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 02:07:43 -0500
Received: from mail-dm6nam12on2069.outbound.protection.outlook.com ([40.107.243.69]:39040
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S244416AbhLHHHk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 02:07:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZnPvjA5yTCoCKNZcfSRUP35L4ueqFycN+ho1qy1wAc2Zwdj0zbtzEmqt0nvai2byEnRh/hjYyWcFU/8dFwFtEO5ldx3PZp1wmzwyA6c0UG3sgl8oUIPNYvWTv0gpJhQgIBkb+nOp1NKGzmTIFRiihItozM6WW7A5eushV51g0np0NeYQ6Pho1VpWKlfWE4LZRl7N2tVd5nHr9DgXMj6Z888x4mZsqg2MbixBC0gNjuUOozOiIa9CA8cWqHbfAyemyopddw7r5YbkwTrRKnBGmAc6N9aPs8mmzrw+W+yDGj8doDekhvCspNzxXS+i/WmJGVEOMhLELzSpaoDepSWrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BsN6KDJirdkosJuidig7EzzIy6c2O3IgtvCXAizKBxE=;
 b=iDQKMOr6Nl3LguEKGH444FN8Xj2uxNg4y6n47aCtBYWZyfoAtyZHblXSQvo+8a3sbHDEArrlAA0LuuDqS8bhWlK1tQiCmTY/S0LB6rh5ftbxpEbybp5D+O4fVFI9ATB6HSyExEhdG/ukcz6B6usvRwfKI2ey+mRYzT2bilL5KFNm+8UEgds6TXa8FoNKTeAm+0GINvezIEKg9dFOddYLv/stOy824CbH7Woup6Hwym7xiPi0WETtkbwH8euo66RWlnX1vnWFL9QMwHaYgfBfUabtwWKfxZ2Vu47nK9LjgJz4FCkXvkKymynpZFxr2mW42DusGEU6vrtg44rO7k75GA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 203.18.50.14) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsN6KDJirdkosJuidig7EzzIy6c2O3IgtvCXAizKBxE=;
 b=AoYz0XRYxJQJL4XNJtu7SpeCNFdGtrGTH0FWWFWGsJ7Ja+UkjBBRjljworExagYj1PMDrQNgyz6tFcC2XZeHawPMIXsEqQOTRI/CxfAXrZL/sC1g98RJS2y7qy1EfyU2gYaOTEYi6swAEB+1GJEWwEq+pzq2rFAzZY4OjY0NyfXmE9dCs4olWoqBPVYWDnNQy0eQzkfA/H3hWI3WSiOoot7j6kec8kP+V5vBIORnqfH7m8CjnPa5BpRIIj4VL50Tj/ubrTI92tGTCvbc0UKtjYCRAhpzYjTJZketdmKXc77O4DYhVj72YueOqTVz6DqrMa1o7r++p7xz/By0AwQI8Q==
Received: from DM6PR12CA0035.namprd12.prod.outlook.com (2603:10b6:5:1c0::48)
 by MWHPR12MB1471.namprd12.prod.outlook.com (2603:10b6:301:e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12; Wed, 8 Dec
 2021 07:04:07 +0000
Received: from DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1c0:cafe::66) by DM6PR12CA0035.outlook.office365.com
 (2603:10b6:5:1c0::48) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.12 via Frontend
 Transport; Wed, 8 Dec 2021 07:04:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 203.18.50.14)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 203.18.50.14 as permitted sender) receiver=protection.outlook.com;
 client-ip=203.18.50.14; helo=mail.nvidia.com;
Received: from mail.nvidia.com (203.18.50.14) by
 DM6NAM11FT044.mail.protection.outlook.com (10.13.173.185) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4755.13 via Frontend Transport; Wed, 8 Dec 2021 07:04:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 8 Dec
 2021 07:04:04 +0000
Received: from nps-server-23.mtl.labs.mlnx (172.20.187.5) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9;
 Tue, 7 Dec 2021 23:04:00 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Shay Drory <shayd@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH net-next v2 6/6] net/mlx5: Let user configure max_macs generic param
Date:   Wed, 8 Dec 2021 09:03:50 +0200
Message-ID: <20211208070350.13305-1-shayd@nvidia.com>
X-Mailer: git-send-email 2.21.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5255b4a4-9b1f-4d12-d0ec-08d9ba18ed6f
X-MS-TrafficTypeDiagnostic: MWHPR12MB1471:EE_
X-Microsoft-Antispam-PRVS: <MWHPR12MB14719ED160EA00A9B27BB01BCF6F9@MWHPR12MB1471.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: So7SIFTnqzOFds8RS3Dk6wOiRNpugFgdr4Iqe8HZUvPktfUM0c1Xd4iTqoZ42Owm/rkU+7Ltmz5ldAZHVUmfSAGqZIoaUOx+ZH9ULDLGBzb467TDzlnnHpnWHAQ3wwTo4ulpzMaaHaYpMEdc2YmZyroZqZsa+LPv3seggwl/ydaNMPnDge+BbBU4wicAs6pDtApb0Zlu+hTnVN/kD5HKZTiL0XakyV2JXQwhmLVy+YVnmQ4aoJkw7oaEGYtUPWwQoDhJGmlUPSu7xOqjnKVUTayoF6NLJM9pJN1DpnWT6Nuz3BnP2IwiFiBA9aL+QH7cQZgKQCF+ckD08DCs4aijSdcctwFKDk02ByvDOR0182ShRRSLvRoxjTo3VvapJ72xl3CysiJ3b2LCnkeGvglfHyoLZYTKFK0BFcBCwzbgVM2iIKpFzuJ/9DhuUnaIiFrsjFfkJAsEBysodvo0Fbyo2U5ooyqPzxMxpq/bn+T0Wi1ylAP+pq0LnAMi1opQcVFb5YvaesXvuvaNV6+PXPD6OBpvlyAabg/CTIGhxsa7tsphmK24QvJUqFVRthqjXh52ImlcPv87Xhyl0TySx+DBzL2UTvic73pvGdpr7BFeWM5EfHA3eiIC14KHT8dCb427jpXUZZbPXjNd09PpRxAUmaKCCL3hni0ZWASHLQu64FupeR2nMl/OZYQs3Dk/iOAUFcBzkigeNmNuKUYP2fXzSshYi9IG+ZkrwWk9w5eylsGgrLP20BI/RbJZvcP7Rn4OTwGH62vFP+iCVrvYCBZooFXGBClncRH7WVtRp5MQX8qA8BBpCCFA9MThpcoU9i519unx7iG1viGblV65+Vw8wQ==
X-Forefront-Antispam-Report: CIP:203.18.50.14;CTRY:HK;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:hkhybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700001)(508600001)(8676002)(2906002)(47076005)(34070700002)(336012)(107886003)(36860700001)(5660300002)(4326008)(8936002)(316002)(70586007)(70206006)(1076003)(2616005)(6666004)(36756003)(426003)(16526019)(86362001)(26005)(7636003)(110136005)(54906003)(83380400001)(186003)(82310400004)(356005)(40460700001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2021 07:04:07.0658
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5255b4a4-9b1f-4d12-d0ec-08d9ba18ed6f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[203.18.50.14];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT044.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1471
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
 include/linux/mlx5/mlx5_ifc.h                 |  2 +-
 4 files changed, 92 insertions(+), 1 deletion(-)

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
index 31bbbb30acae..4c96a1f60ef8 100644
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
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index fbaab440a484..e9db12aae8f9 100644
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

