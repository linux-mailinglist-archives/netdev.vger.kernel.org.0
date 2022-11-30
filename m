Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27B663D50A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:54:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235050AbiK3LyO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:54:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234305AbiK3LxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:25 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2070.outbound.protection.outlook.com [40.107.220.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53F461D0EE
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:53:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VkxkE5g2+00BhiDza5Ho+kAYg6FOH62cuLfIiWta2W0RmpPB0vFLDTPDK7AUn+o3cMHV3hzws2pRdrveI6SaNW0WLwnkKycmJhWs5XmJKLtJhC72mJ1Pf85iZtO3p1peetzvCdiZ/qGUX6sxOYRTfpyb5a3VJGZcPW77vRJf17xVthboKfguqUyB9K69TQWEH2oUrKh956bZNlNkW/HRtqGvQyc/hlIlZ6KcN8ZIjWMw9w293Jh+SXh4MzYVQTE2LwFgHDyA+xoES8hFKCmqOLH2GC1Zq/gnTN4Td5zaYTMWc7Tz4IqOS6659+qwNUzXOCYiGclyj9O67Dt5hOfkQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FPwciwfQWYkWUh0pBwocHbSeOOWxbtoNNx5KJ+Cy4as=;
 b=iTImSfcRjKv6wLIEoInearrvkNCmiswzwnK+DO0X48fc0R50g8bYedD7it53GhjJ59Y6kdqtn5IsRk3bNMtzqw0nszFQLIaxCJmoU7f2ReM4+9MQr7EU45pX28nVW1EkPSxQcxqAzaBOSGwkajg/7C3lOtbUL+0rqcCVPmnfMhmtfDABnvifezHkAVsFNY7PurgNl8Vn6TUQzXfM88Os0Ut3Gdguvg6yvl2JwDfC5WAzq5TfjTubs/f0Tb3vxY4KcuqLpZGY5nAe+GAXIN2CVytlQvAWGGKxVut/W/hKkidL67h1ypQT9TD0On4Vnv6GV63XzkVhQcrqfvDOhTyQ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FPwciwfQWYkWUh0pBwocHbSeOOWxbtoNNx5KJ+Cy4as=;
 b=dOw9C1OrNJCSO+GthyMuqzO0TTA05NJikIK5m1nt0jxFxBxiTRBCHyPkxQvbE1ziN0QuUDCudCcD0fXybpbu9Zi78Z8TA6C2GRg70gW4KbgnkJEUgXUyVh8g/hw+kP5bjF5ZWJoAyzP+b0ijWWXhqbDZ0aDSXaY+sbTASir/xAeb9M0bFo0X/Ig24ldBvM/j2GZ9a+Hp73Qjxpns2ClaHRCQeEYRPiNnZ8e6Kx9OKHgO+5QVKKaEctwA4fsA+NypnqjbMabos4ivMtPsDzCqzXMs11wzdR4Caev1f5+NspUL+UeaZzPeTdSDlZ9GEbfUCyM5hn8qS85s5vLrwdOv/w==
Received: from BN8PR07CA0023.namprd07.prod.outlook.com (2603:10b6:408:ac::36)
 by DM4PR12MB7622.namprd12.prod.outlook.com (2603:10b6:8:109::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:53:22 +0000
Received: from BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::a1) by BN8PR07CA0023.outlook.office365.com
 (2603:10b6:408:ac::36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 11:53:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT008.mail.protection.outlook.com (10.13.177.95) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21 via Frontend Transport; Wed, 30 Nov 2022 11:53:22 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:53:07 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:53:02 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 8/8] net/mlx5: E-Switch, Implement devlink port function cmds to control migratable
Date:   Wed, 30 Nov 2022 13:52:17 +0200
Message-ID: <20221130115217.7171-9-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130115217.7171-1-shayd@nvidia.com>
References: <20221130115217.7171-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT008:EE_|DM4PR12MB7622:EE_
X-MS-Office365-Filtering-Correlation-Id: 09e82d43-f8bb-4591-82b3-08dad2c97b46
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iCNgfeW7YQyomTWs9x2JYI17VEkOaTgR3SXc89as/lSVs0Lofu+uHYHU08eWRqKF7CFYLlxLj49j31NJUXKp0D5d2X/aGwy+z8dgdAYB7UXl28BjsoyffMSCBf3Ak0NIVNyH+UAV7cE4KTNykMRlKWKjTBz+CZ3Wa/SssPCJ/DWbbe18a5XxnmDgG9jeiUnKDXmp0BcQ91cbGuLWP5/BV24wnz7ZbKpdeLvwah8SYVxw7Y7wrEBujcQGvVxklMmr98GFZ/9G+D2G9DC/oKHLjX0UvOQ34uCHDLc2BWybgjabDXPn68dJHrcveSG1YmTsHK3yxDyme1rLFqHzPW3Rt03W3sXKVDAs0jnkpQONC3U+2aaHwXkc9V90tgoOc32E/vgyIwDC9RXS21iA5goKuEzf47QQwQZckKj1bXM9kqU1v4FftHDigDERCOPmzMzjpqdr6gMz+vbcd4m9cnEPHHAFnbVJ3V/9+f7AS0j4d0zQ36SjZjnHGBmVrryqhKF2BuTnD2gO25TliKR0P+NyrOZnjsIG5s6vsZjNrwbWBEdsPHvb3GSpsX3jW/SvwHl0kfpU8PFdF3z1QEX4NCic6bZwomPnV+BfZC+XdWoBohHtqNy1BVUpQSpgClnjWgo6nu5/ddeZEMStqY561d+AzK/D2zhb3SyIRN9jq35dLATDec+nDL4l9Z/i+lTmPOuldutdm3HrQRgbJp0izU+X7g==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199015)(46966006)(36840700001)(40470700004)(16526019)(356005)(7636003)(110136005)(316002)(2906002)(54906003)(36860700001)(8936002)(40460700003)(41300700001)(70206006)(5660300002)(83380400001)(70586007)(4326008)(8676002)(86362001)(47076005)(426003)(336012)(26005)(186003)(1076003)(2616005)(82310400005)(107886003)(36756003)(6666004)(478600001)(82740400003)(40480700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:53:22.2637
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 09e82d43-f8bb-4591-82b3-08dad2c97b46
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT008.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7622
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
Ack-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   8 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   8 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 100 ++++++++++++++++++
 5 files changed, 123 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 992e3d2830ad..7825dcb4922e 100644
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
 To use the SF, the user must active the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 6b0685d9260b..9a70a541215b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -320,6 +320,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
 	.port_function_roce_get = mlx5_devlink_port_function_roce_get,
 	.port_function_roce_set = mlx5_devlink_port_function_roce_set,
+	.port_function_mig_get = mlx5_devlink_port_function_mig_get,
+	.port_function_mig_set = mlx5_devlink_port_function_mig_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 66d434dafb0b..fcf5afc5886f 100644
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
index ef0dfe8e55d6..1d8eda0bbd6f 100644
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
index fe1d0f9e723e..622dbf9e41dc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4028,6 +4028,106 @@ mlx5_devlink_port_function_get_vport(struct devlink_port *port, struct mlx5_eswi
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

