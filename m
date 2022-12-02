Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14A1664021F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiLBIau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232412AbiLBI3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:19 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2042.outbound.protection.outlook.com [40.107.237.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56D6B0B77
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:27:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZ8Uu/MtxqSE4ZWIQzeIycUc1MFQt7S9T8Rs32V3vgkAW1P63f5uKYU1ZYQg1PL1197RRc6g3sDXOy51EAKUxe9isjkeDYgt3brM/h6/nIExFlLFtmYuXHBuOYAzKkn5UJ/s68hiI/q+30h8KexdZjTsN4JeaJdGa4oy2CFUdEB2exQUYZN8cMvwrWKRNF1vtPsT2o6LpTIYLmkwkLmjbUmNida+vtHVsna1cusmSfjXmHNH8b5Q7j8XvJSjEAel0CJQex4/noUA7NnP/71f9nRWPv2QuKPZas5eHBAx4xtnHdXccHs07lxibdOD2N7mEStJ+ulH+TJshQmsCZmktQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mEsBYf0YCHE+52R+L01sHCVv6+tB/Pr7te8VPcd03U=;
 b=SMQ5jKx3mhN5LMVgy+0iH9UJNFCgSIMko9ZHA5ytxRwGqO7eDqSyMDkL5GmnCpGOF8YRdrsq4n2tP++gPrXWmt9rpnm4J2WetLxnnHzXYhgeTgb2pmAOIBF2CVqSqAGNXv+Qux1SD3UiPUKW887EBkNVKDJqGGh1uSl/pYy5VSwAj1t3dJ38Q/oOfW+fdNAe8p4RgH7yApOfBj81svK4jnI2Dvu3kmiFkufjoTv8NZ4CQ8NN5GmRN27o8tWmGhFYioG5rxd9lUUasqzVYEkO0JXMyNCFgpOiqidLdBmoZ7F7Q9iTpn2+bSs1h6arebDtFR7XS08bRCajEmDJQqXh2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mEsBYf0YCHE+52R+L01sHCVv6+tB/Pr7te8VPcd03U=;
 b=QwwcMMuSEqmt4S/Dda4EefsCQnpKVOwT6F02cbO/iQagG+55GV+HhhmMdV5w7FcPD6Yg2FZz0UanpUsia9q+iUm1LmRiU+S5qFWRBVYOUg4TFLKMnyeGD8ghSdYmuhKT+209w+VKWAAe9HOeMQDGzb2+9UlBPd1C0vZ6eZBRz1h+ueezXfCdlQiaN9gZ8/+ZRb7wm0pesBOQQz6VuWetBgdhjWYwtR+hcoyYcL1IYgVe0ELvh9V5z8Ihq3joy0O7vDtI3aPKGT3md5ypBMEsce2UEVdPc2jxotRZjpW5LtkYgQ4e4f9UZbr8wrjRKAhge+zOUEjdq3en1838TpA7EA==
Received: from DS7PR03CA0180.namprd03.prod.outlook.com (2603:10b6:5:3b2::35)
 by IA1PR12MB6650.namprd12.prod.outlook.com (2603:10b6:208:3a1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 08:27:07 +0000
Received: from DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3b2::4) by DS7PR03CA0180.outlook.office365.com
 (2603:10b6:5:3b2::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10 via Frontend
 Transport; Fri, 2 Dec 2022 08:27:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT112.mail.protection.outlook.com (10.13.173.77) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10 via Frontend Transport; Fri, 2 Dec 2022 08:27:07 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:57 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:54 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 8/8] net/mlx5: E-Switch, Implement devlink port function cmds to control migratable
Date:   Fri, 2 Dec 2022 10:26:22 +0200
Message-ID: <20221202082622.57765-9-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221202082622.57765-1-shayd@nvidia.com>
References: <20221202082622.57765-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT112:EE_|IA1PR12MB6650:EE_
X-MS-Office365-Filtering-Correlation-Id: 9caa8d8b-ac65-4014-a93d-08dad43f0005
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zAZ99De/RL6ZYXERIYKcOZxQCvyByT3HEP6OjUZf8HvZi6dWduO5opDNG8Har4ikfkB+DHf2s8gPOwzfMxMrcbbSCGQcxTrta2GTl3KZQG+rNNdZijkKtUFL34N4tmAM7cI9T73q4wYwmYMfzzvDNhKTchcCJktPJ+t7OnD8VIPjxucg+vXSOGrhDUBsCVt3iTH4p9PxKiKtTu4VJjdCgyjLuhu221hXf/wGNXDbJP66XD1J5t/kcBPJGcADAWxqaAMx/SJZZ8krqKv+EfsfXZyeHsK+8/VDA5EFT8QbQSthtbwVqAjZm6u7lFTKntf7Xs5NXkk/yo6h9QjOYXKIrvm+v8FzoPGXbxQbtFEhlkvhKzRtjSt5u7Qp63YYYrLve/A3gtjcHuSdBAzTfUFGfmbApuJdhaC2d+uzDEQAEq5YpdNjpzanEEcT2pYJsQ+Ucee2b09dbn0PDKAGlJmHq8z+xT/vY/dIspgtZ/SHeJVpIulT0IiZ352wlua1CsDi5XH0ZNWdnU4GfINHHZDyPO7KkIhVNfYCSecsYT89pd8k122F3vcuMsKsvtazC6GzfcfQNeCh5T82Z3Vv6oWs/bONaAS//sTKtlNDGCtRiBW+hcSdJcSbW67M6dbBGr4nP8AHbBTKW8jzTaQ5QlHAQ3Xb/Ktnslu9mE3vYCZDtJUDCerkAnTJwNP0AUbulWS2loSuGdbldQY17LrCdEhWxg==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(451199015)(46966006)(40470700004)(36840700001)(186003)(2616005)(1076003)(36860700001)(426003)(107886003)(47076005)(336012)(16526019)(5660300002)(36756003)(6666004)(82310400005)(70206006)(86362001)(26005)(478600001)(82740400003)(8676002)(8936002)(83380400001)(4326008)(40480700001)(356005)(54906003)(70586007)(41300700001)(7636003)(2906002)(40460700003)(316002)(110136005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:27:07.3339
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9caa8d8b-ac65-4014-a93d-08dad43f0005
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT112.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6650
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement devlink port function commands to enable / disable migratable.
This is used to control the migratable capability of the device.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   8 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   8 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 100 ++++++++++++++++++
 5 files changed, 123 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 8b8f95d1293a..6969652f593c 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -364,6 +364,14 @@ PCI devices/SF.
 mlx5 driver support devlink port function attr mechanism to setup RoCE
 capability. (refer to Documentation/networking/devlink/devlink-port.rst)
 
+migratable capability setup
+---------------------------
+User who wants mlx5 PCI VFs to be able to perform live migration need to
+explicitly enable the VF migratable capability.
+
+mlx5 driver support devlink port function attr mechanism to setup migratable
+capability. (refer to Documentation/networking/devlink/devlink-port.rst)
+
 SF state setup
 --------------
 To use the SF, the user must activate the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 992cdb3b7cc8..a674bf0b6046 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -316,6 +316,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
 	.port_function_roce_get = mlx5_devlink_port_function_roce_get,
 	.port_function_roce_set = mlx5_devlink_port_function_roce_set,
+	.port_function_mig_get = mlx5_devlink_port_function_mig_get,
+	.port_function_mig_set = mlx5_devlink_port_function_mig_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 001fb1e62135..527e4bffda8d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -794,6 +794,14 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
 	vport->info.roce_enabled = MLX5_GET(cmd_hca_cap, hca_caps, roce);
 
+	memset(query_ctx, 0, query_out_sz);
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
+					    MLX5_CAP_GENERAL_2);
+	if (err)
+		goto out_free;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	vport->info.mig_enabled = MLX5_GET(cmd_hca_cap_2, hca_caps, migratable);
 out_free:
 	kfree(query_ctx);
 	return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 71f27fb35c49..8625b97411a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -154,6 +154,7 @@ struct mlx5_vport_info {
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
 	u8                      roce_enabled: 1;
+	u8                      mig_enabled: 1;
 };
 
 /* Vport context events */
@@ -509,6 +510,10 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_mig_get(struct devlink_port *port, bool *is_enabled,
+				       struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_mig_set(struct devlink_port *port, bool enable,
+				       struct netlink_ext_ack *extack);
 int mlx5_devlink_port_function_roce_get(struct devlink_port *port, bool *is_enabled,
 					struct netlink_ext_ack *extack);
 int mlx5_devlink_port_function_roce_set(struct devlink_port *port, bool enable,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index f258fd7e27a8..ce38d9c0ad71 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4038,6 +4038,106 @@ mlx5_devlink_port_function_get_vport(struct devlink_port *port, struct mlx5_eswi
 	return mlx5_eswitch_get_vport(esw, vport_num);
 }
 
+int mlx5_devlink_port_function_mig_get(struct devlink_port *port, bool *is_enabled,
+				       struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, migration)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support migration");
+		return err;
+	}
+
+	vport = mlx5_devlink_port_function_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		*is_enabled = vport->info.mig_enabled;
+		err = 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_function_mig_set(struct devlink_port *port, bool enable,
+				       struct netlink_ext_ack *extack)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	void *query_ctx;
+	void *hca_caps;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, migration)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support migration");
+		return err;
+	}
+
+	vport = mlx5_devlink_port_function_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+		goto out;
+	}
+
+	if (vport->info.mig_enabled == enable) {
+		err = 0;
+		goto out;
+	}
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
+					    MLX5_CAP_GENERAL_2);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed getting HCA caps");
+		goto out_free;
+	}
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	memcpy(hca_caps, MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+	MLX5_SET(cmd_hca_cap_2, hca_caps, migratable, 1);
+
+	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport->vport,
+					    MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE2);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA migratable cap");
+		goto out_free;
+	}
+
+	vport->info.mig_enabled = enable;
+
+out_free:
+	kfree(query_ctx);
+out:
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
 int mlx5_devlink_port_function_roce_get(struct devlink_port *port, bool *is_enabled,
 					struct netlink_ext_ack *extack)
 {
-- 
2.38.1

