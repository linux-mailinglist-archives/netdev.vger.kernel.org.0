Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 286B5641D68
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiLDORn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230143AbiLDOR2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2088.outbound.protection.outlook.com [40.107.92.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914AE17A88
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hnQY5lgeEEjmnTWTodS7x+pEUB7Qa5t99TpcMoVmLqpd8ZGS3HG9TMMMsaS6HtT5ITuW3RF2xaGtQbMQ68GAIcvuVjzDb58k3G/M7f1SVQRhMHHL6fOQlMsgoxbij5Mi8xBAII+BHObsmDxJBTPrh8m8d/aAEidavobvisiQvhszYGujheO6CQ2y6e2/ZfDQjPrhu++M7hC7HWGk6CmBOzHad9oLC7RR7SHYALBHwvv+3IQDJfpNqm7dI3ti+oRheM2v/lC0tM6gkjZuQtupYKL5tuTTu/1BeOmiLukZIBFD4NVpgOD3ZfienApZGwK9PDiMYVWQbkPlRuiOfsMWAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mEsBYf0YCHE+52R+L01sHCVv6+tB/Pr7te8VPcd03U=;
 b=IdvUHqMkRPKbCd1kdurmKNu6GpnWQ57bbGifAr2puxKdGPMr9lsTLQdaEyc1NFSIotZnaUexnk8rnpcdwPnd9Y93ne7r3a0jVgWMfZM6OApexTiCXNtyEWDc6E3Gek5aus2F7cbjetJoyRVyIYFM4qO8j7jLpWMiwzidaRYaSgSRhirS9mTMWtXS9sytevFMziY4MBm4dEa3o9+yaI2FvOBGtt0NxM9yeHUYgleRQY1b8AhsyR5yl1wVq2de1VHalqmrxCm5yJxB1YIsErOXZUgZozMoeqoE/mM76RRk/X7VvXLn5AxsAkbtH8moS80vmz4yTZ9RMbSZFre/RcqzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mEsBYf0YCHE+52R+L01sHCVv6+tB/Pr7te8VPcd03U=;
 b=DqIFIT4ZtOAs+55Ds7vz7+npBJlIf5hvRD5SA9GJpl7vYLmGFTeCGuW/27JX+95W15knImaGxZsCck608xY2MC+RwPH9PBdTm3eNIvhY+dBP3jIeRQP+QkVTvKpuoXyq/+VEeDYcfsrt4Tdp5IEyuUiZ0SEhiwmHxMJzS0YCP4nntSUD23Dr1J3JYGM6I+rZfMjxXhwmzrop99T4viFh/PLslSQxfn0oHLxxo0uJiugK0sALf8m7yEeXsSxEGeb26zGKmEt3AikvetC1QMbt0bDbgONSpU+9m0G2339I43zgPEXX+CGB8bSW/u/iOXxq1bs53pIvyf6RdU+PGyeRZQ==
Received: from DM6PR18CA0033.namprd18.prod.outlook.com (2603:10b6:5:15b::46)
 by DM6PR12MB4060.namprd12.prod.outlook.com (2603:10b6:5:216::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:17:14 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:15b:cafe::f9) by DM6PR18CA0033.outlook.office365.com
 (2603:10b6:5:15b::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:13 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:17:06 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:17:04 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 8/8] net/mlx5: E-Switch, Implement devlink port function cmds to control migratable
Date:   Sun, 4 Dec 2022 16:16:32 +0200
Message-ID: <20221204141632.201932-9-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221204141632.201932-1-shayd@nvidia.com>
References: <20221204141632.201932-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT052:EE_|DM6PR12MB4060:EE_
X-MS-Office365-Filtering-Correlation-Id: 8198e737-7b4d-42a0-ac16-08dad6023dbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WcsUYWLDQDmABrrUVlDRFR8kCIenFoI2j9eMc/XsucKOjXW0BPKwQwNYnnP6il1TetG8ukRdHaCB0vkK4pw3zCSe/I45E7JJMKOP+QQGgIvXjnk3R+ZtJ12arMpjXAaeAD/yEfMssXCHY/Mk9czWOQFWVI2RZgvMA5aWYeS0iZ3AKWjGHUtMfyjScN0dVNxKnXncu2wYAc5tAtJsN19BrFLrNcWf7v/9KHzW7aS/N4JpE3ZSxmW/ogYnhqgRZaoIsHGH0XIWH+C1MErFoF3BqEfUj3uKJkPwwhdQdnvYxtlSliSknQWPlInPP6MFR5g+xzpuecNU1KX4hdCeFQI61mD/1QaJ3zTwBoZOnS3uqWL5yg8qQMvFMaSYdb4fkxCrSUTgNuYG+KHqgyc9MZKrCl564JgYSc8s4fE16KdxyQyxNd9fNzgXFLGGBIusi3WDA5WjnNfbWbtlKJoWaRvluloh3aJnfBrg77V0vU06YVAtpREWihIdDjO4mBJ97kDt0HaHPMRgAqnTURE0Ox2t1kP9t3ZT0vk/0NCeCKDSBLlUAnfe5gDoo84DQ6j1lNtgZj4wvjit0LpT3tk+aitianCw7zggzV8SzW9TKbAe7CNFU7LPwMqXuoip+xh8s9Jkes68tuqfPvhfcqOs6bhluBgEWWmFBtgwWO9LdnZFDxcRv9bCwgL/g0nimbQWVBjwfdF07nf6YYx5NtCf5oMZOA==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(40480700001)(36756003)(40460700003)(86362001)(7636003)(478600001)(107886003)(70586007)(8936002)(41300700001)(4326008)(8676002)(5660300002)(6666004)(70206006)(54906003)(2906002)(110136005)(316002)(82310400005)(36860700001)(82740400003)(356005)(2616005)(336012)(26005)(83380400001)(1076003)(186003)(16526019)(47076005)(426003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:13.8928
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8198e737-7b4d-42a0-ac16-08dad6023dbb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4060
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

