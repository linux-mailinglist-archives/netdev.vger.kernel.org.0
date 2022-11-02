Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A6BB616986
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbiKBQo5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:44:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiKBQog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:44:36 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBBFF58
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 09:40:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eyWgnDwdWyGxzH22aZ4BbfoOxxM+J3p3juZKhSDJdtcybPpVpG7/m/9SXb3byxjsFn9MA/A7baqB6y2p03pOg9EHEyq/u8g5ltMj/2V3+5p7gg/hA4mIuCyzpjfet5SBtGfsHJU13LYh40R9R6mQO4BUgKGa5AMYsfKPNGLVmUmxOwy+P6zJ1bk1a/C0dF3Uoy+ihJSmEL6vlOZ7k7KVkbS+UIA/mg7bY/cbnTDaVcthi2FOPu6tDZwZGJu7CLky66MPDoVJxS4OzDbgPsSMyx3IwOnflk9uJ32SmheHfLctWOhtBhCLiabxTDlBh/kyAcRecIM8o3zrTgnVzV7Wcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1fVTZXnIfxf/MaaAGwI5pGMoE7IH07QT9ZKejTOD6tc=;
 b=Gkslk+9oAVDW5050tKx6oGxjRyCt/V3+tQA6r95A6KdClp0WHi03QcnJFR0eoHPluPyK/taq83HZ/vsCwR4KLTEZ7YipqI0OWByWWeWtaaH5NYTZh5ENsaBaxSUO8t1PCw50sWe/sCiyO0SmxrWNpTfFzYqexZTI+ORLssAKzjvNFgSjdneuIrNgBKPiByIxB3ZId4Wsd/0wHuNL9R8lGDpZxxAsdeqAvqE4XSGDqpBJmqEALPs+E6u62RBMR6FG5/vLOXSw+kscO+nyo01ComagccRqjakoP8Z3TZSqDvxLf6c8TNe6dYK8VNbDwfZ7f6kWjkAupqv+62294YoNxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1fVTZXnIfxf/MaaAGwI5pGMoE7IH07QT9ZKejTOD6tc=;
 b=iLn0s0I9B7VABtp9jWDRc2OBjzdqz5zwkMpEZsEngQBcLqFF2reuSRCdR+BBwiu+TA/VICGgKByHhZlABYjoVsqiyWO3e4LoXx84qpCLPMF9CJxzGjmh7gNMpX2+4htKq0oJ82CHtVjzXfgRZJTN0H+FyT3Kee/ew9Kf/vj2G9YY67/QJS7OYVf5Rl2KO35zoEypLFkchC/JZdL3za1r1lR6lFAqh4PaHkIq7EpYOr4fygxprITu4MnvEi7p5vyQtmpVpHMEVI3AIuKARZ0Cb6yYaLR6jNNa7J25JiTHtugUPQfVyDCZZA53lqjRLoDQW038OGvAgNYCrh/s01vaaw==
Received: from MW4PR04CA0230.namprd04.prod.outlook.com (2603:10b6:303:87::25)
 by MN2PR12MB4533.namprd12.prod.outlook.com (2603:10b6:208:266::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.21; Wed, 2 Nov
 2022 16:40:29 +0000
Received: from CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::d3) by MW4PR04CA0230.outlook.office365.com
 (2603:10b6:303:87::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.18 via Frontend
 Transport; Wed, 2 Nov 2022 16:40:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 CO1NAM11FT028.mail.protection.outlook.com (10.13.175.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5791.20 via Frontend Transport; Wed, 2 Nov 2022 16:40:29 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 2 Nov 2022
 09:40:16 -0700
Received: from sw-mtx-036.mtx.labs.mlnx (10.126.230.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Wed, 2 Nov 2022 09:40:15 -0700
From:   Daniel Jurgens <danielj@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <saeedm@nvidia.com>, <yishaih@nvidia.com>,
        "Daniel Jurgens" <danielj@nvidia.com>
Subject: [PATCH 2/2] net/mlx5: E-Switch, Implement devlink port function cmds to control roce
Date:   Wed, 2 Nov 2022 18:39:54 +0200
Message-ID: <20221102163954.279266-3-danielj@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20221102163954.279266-1-danielj@nvidia.com>
References: <20221102163954.279266-1-danielj@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.230.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT028:EE_|MN2PR12MB4533:EE_
X-MS-Office365-Filtering-Correlation-Id: f0212987-3bf4-4c80-2c5e-08dabcf0f3a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2rg9q53zfaxennTLIlK8+G4JCTMBwyFeSDmEdxyKs413p7PsakerFq1kJrkWqlRe7ZGGA2QOtLnuX5CJO7N/dF400nai7HgL6gIdM20KwUsCxvsm62TutGEQzErDWKisGXXUTPgtWmzqU0GFAIHV61AyK6ehPzYTxtZ4P3UO4mQVw4d0ANBnMMMhf8HofF3A8OXgPC7kEDcyXUG0N0NET8p5yyJ2gYZ/MiOFbEZdGKX1yLMz5h24bpwjz4guFyXW/6sSxQd/EOLUHKWW7M0JSBT9u/8NKMkOWTAXwYSZoVj6u7tCa9CCDGYKHuSha5e5pBY0HVKqiBLmADVjYCJqlh2xF4+XVZcAqNVma+IVq1B0L1qOv3YAqyT9ZrURQIM1xCSHWszA5Y+ZnaV6G48RBvkY3dya9KCUHLIuRLPJ9jl6E2Vp/A4CbycbmlluqOmIlD75D7pZf12SVxZL7Xra9U//UEyOwOYh+a7w/InZOjJXkNS0tiZOy/WZGpRovHm+r6gT4auMEc3QkDpd4FrH5w7F75ONkOAM5NMWjb8UZPRSS5OMv4GycZGu60RwEbHaJ6z1NtYef4d6NdIYeHqyUiQNCJlOrIm9zNjiVH4UKFp8wU4yV706y+r4pgH3XKObfdNLaHfP+ZdF66kqxInddt4HEn2GUveU5vvnr9fCxRlmCNh+WOmaxFDKJXvpW3L2rcbIGgUMiNNPfn0gb1pjscEtPV7IkYVlxrY6JJtP0GlXxyu7JFfRavG8gQulzRykhU8hcWDKiCj5gvt3VS9Mmw==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(346002)(136003)(396003)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(83380400001)(40480700001)(82310400005)(7636003)(356005)(86362001)(36756003)(36860700001)(82740400003)(40460700003)(2616005)(6666004)(54906003)(110136005)(107886003)(316002)(16526019)(5660300002)(30864003)(47076005)(186003)(1076003)(426003)(2906002)(70586007)(336012)(26005)(4326008)(8676002)(41300700001)(478600001)(8936002)(70206006);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 16:40:29.1401
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f0212987-3bf4-4c80-2c5e-08dabcf0f3a7
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT028.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4533
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Implement devlink port function commands to enable / disable roce.
This is used to control the roce device capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  32 ++++++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  34 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   8 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 105 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  23 ++++
 7 files changed, 205 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 5edf50d7dbd5..2ffdc103571e 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -388,6 +388,38 @@ device created for the PCI VF/SF.
       function:
         hw_addr 00:00:00:00:88:88
 
+RoCE capability setup
+---------------------
+Not all mlx5 PCI VFs/SFs require RoCE capability.
+
+When RoCE capability is disabled, it saves 1 Mbytes worth of system memory per
+PCI VF/SF.
+
+mlx5 driver provides mechanism to setup RoCE capability.
+
+When user disables RoCE capability for a VF/SF, user application cannot send or
+receive any RoCE packets through this VF/SF and RoCE GID table for this PCI
+will be empty.
+
+When RoCE capability is disabled in the device using port function attribute,
+VF/SF driver cannot override it.
+
+- Get RoCE capability of the VF device::
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce on
+
+- Set RoCE capability of the VF device::
+
+    $ devlink port function set pci/0000:06:00.0/2 roce off
+
+    $ devlink port show pci/0000:06:00.0/2
+    pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
+        function:
+            hw_addr 00:00:00:00:00:00 roce off
+
 SF state setup
 --------------
 To use the SF, the user must active the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 66c6a7017695..69d103694ac2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -318,6 +318,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
+	.port_function_roce_get = mlx5_devlink_port_function_roce_get,
+	.port_function_roce_set = mlx5_devlink_port_function_roce_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index c59107fa9e6d..035240587163 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -772,6 +772,32 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
+static int mlx5_esw_vport_roce_cap_get(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *query_ctx;
+	void *hca_caps;
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return 0;
+
+	query_ctx = kzalloc(query_out_sz, GFP_KERNEL);
+	if (!query_ctx)
+		return -ENOMEM;
+
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx);
+	if (err)
+		goto out_free;
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	vport->info.roce_enabled = MLX5_GET(cmd_hca_cap, hca_caps, roce);
+
+out_free:
+	kfree(query_ctx);
+	return err;
+}
+
 static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	u16 vport_num = vport->vport;
@@ -785,6 +811,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
 
+	err = mlx5_esw_vport_roce_cap_get(esw, vport);
+	if (err)
+		goto err_roce;
+
 	mlx5_modify_vport_admin_state(esw->dev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      vport_num, 1,
@@ -804,6 +834,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 			       vport->info.qos, flags);
 
 	return 0;
+
+err_roce:
+	esw_vport_cleanup_acl(esw, vport);
+	return err;
 }
 
 /* Don't cleanup vport->info, it's needed to restore vport configuration */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index f68dc2d0dbe6..83e125d13b7d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -153,6 +153,7 @@ struct mlx5_vport_info {
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
+	u8                      roce_enabled: 1;
 };
 
 /* Vport context events */
@@ -508,7 +509,12 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
-
+int mlx5_devlink_port_function_roce_get(struct devlink_port *port,
+					bool *is_enabled,
+					struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_roce_set(struct devlink_port *port,
+					bool enable,
+					struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4e50df3139c6..446488687a1c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4024,3 +4024,108 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 
 	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
 }
+
+int mlx5_devlink_port_function_roce_get(struct devlink_port *port,
+					bool *is_enabled,
+					struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	mutex_lock(&esw->state_lock);
+	if (vport->enabled) {
+		*is_enabled = vport->info.roce_enabled;
+		err = 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_function_roce_set(struct devlink_port *port,
+					bool enable,
+					struct netlink_ext_ack *extack)
+{
+	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	void *query_ctx;
+	void *hca_caps;
+	u16 vport_num;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return -EOPNOTSUPP;
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return -EOPNOTSUPP;
+
+	vport = mlx5_eswitch_get_vport(esw, vport_num);
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
+	if (vport->info.roce_enabled == enable) {
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
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed getting HCA caps");
+		goto out_free;
+	}
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	MLX5_SET(cmd_hca_cap, hca_caps, roce, enable);
+
+	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport_num);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA roce cap");
+		goto out_free;
+	}
+
+	vport->info.roce_enabled = enable;
+
+out_free:
+	kfree(query_ctx);
+out:
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a806e3de7b7c..9f717f3fff98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -309,6 +309,8 @@ enum {
 
 u8 mlx5_get_nic_state(struct mlx5_core_dev *dev);
 void mlx5_set_nic_state(struct mlx5_core_dev *dev, u8 state);
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id);
 
 static inline bool mlx5_core_is_sf(const struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index d5c317325030..75c876712992 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1171,3 +1171,26 @@ int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, vo
 	MLX5_SET(query_hca_cap_in, in, other_function, true);
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
+
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id)
+{
+	int set_sz = MLX5_ST_SZ_BYTES(set_hca_cap_in);
+	void *set_hca_cap;
+	void *set_ctx;
+	int ret;
+
+	set_ctx = kzalloc(set_sz, GFP_KERNEL);
+	if (!set_ctx)
+		return -ENOMEM;
+
+	MLX5_SET(set_hca_cap_in, set_ctx, opcode, MLX5_CMD_OP_SET_HCA_CAP);
+	MLX5_SET(set_hca_cap_in, set_ctx, op_mod, MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE << 1);
+	set_hca_cap = MLX5_ADDR_OF(set_hca_cap_in, set_ctx, capability);
+	memcpy(set_hca_cap, hca_cap, MLX5_ST_SZ_BYTES(cmd_hca_cap));
+	MLX5_SET(set_hca_cap_in, set_ctx, function_id, function_id);
+	MLX5_SET(set_hca_cap_in, set_ctx, other_function, true);
+	ret = mlx5_cmd_exec_in(dev, set_hca_cap, set_ctx);
+
+	kfree(set_ctx);
+	return ret;
+}
-- 
2.27.0

