Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6F644C09
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiLFSwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiLFSwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:06 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on20604.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e88::604])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FCA3B9C3
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:52:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf3ig43vUPthUQ5vtyMyEkfCefqGTdQl1ijElu+dFU3RrUp8PNtNMcmCSBu5+ZgOqCowQE2fmytxvSMkXNTtC0Z6SvvyY+9xgfsuGdZTheYlVIUPx5crGI25IqroJ8UN6wNRKvbLLfqXQAAxvNGi+xbXvCWKOTkolYrz9IUs0BLJ9o8OsRKRYf3Y2yu4zCIbq8OtcufcpXrLPvfN5WH2GGet2rfq3D8Ulg+tevbyXIrKvdQcVRsVEk0sK0yg11d0OaiGrVH/0UaJncGuVXmD0Ft6zOel+eNYfAYqOlXf661vqWYAH7s9Y786KNweTZ5r/F+yvxd5gyZJXTaI11qG6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=krBek1wHe+OTgfKcNIuLtmUww7KEIvbXAVjW0Dc1Hd4=;
 b=H12/H7m2uioeNXWTqLw0M3F5SHuxCmSdUqts5ap0XaNXlApXopcTarm+A7xTxdq/yEBTF+CnGEjHDfxtz0yH+wTa4IHPHkQNbH41s2ap2K4X5x1swxaSap45400NfuHTrPVadvGYA9agrHSL2aNkBro5G+ye5aKHMEASj7wbnsEGdnv4zFkkMau24RjYeoyzCesvtBHYF5sq9ItZth4JQviKTcjhmGBrcAhKA+6ysjdSAYpMorX2XFpek49hkDVtQEI1zZDw+14Igy88dJfiIuAbwMmfWHlo0LHgJ/9TJ9boGwxcjh1LJGfi1tDPwh9ZobXbPwblqhFD87XlMS1dUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=krBek1wHe+OTgfKcNIuLtmUww7KEIvbXAVjW0Dc1Hd4=;
 b=fvr2XkQHTQVAgTsiDtTmwdCOkfCLMT+ZsN2R69PoRSuJbtIxXvNFfii9xupDKHqyp3pxc/WiMeNg4XjoD/+8Vy+Hab+JODacETRh6HdVjYf87y/0qJ1thW3BUdlMKJps2kx9VbLKdnuLGdNhDmJtdNCaEn91kgVNURqmeR+n8FaG/0iwf4D9sppWoKQFg08PcL6GItflCFYq+Tq7Y8WPljkEdpK0DvXTAZnfT8CLN699DQTmNAXefYHc7rvyE7ZXO0cx8Nj8SNXBnkIBqJzQh/l+gdlvD4Oh+hWRQNRx+MzCpM8O1Bj+K2dmBY0/mxrEynYTmLcjhQw0qDrUnjEvxw==
Received: from DM6PR17CA0034.namprd17.prod.outlook.com (2603:10b6:5:1b3::47)
 by MN2PR12MB4173.namprd12.prod.outlook.com (2603:10b6:208:1d8::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:51:59 +0000
Received: from DS1PEPF0000E643.namprd02.prod.outlook.com
 (2603:10b6:5:1b3:cafe::27) by DM6PR17CA0034.outlook.office365.com
 (2603:10b6:5:1b3::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Tue, 6 Dec 2022 18:51:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DS1PEPF0000E643.mail.protection.outlook.com (10.167.17.197) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.8 via Frontend Transport; Tue, 6 Dec 2022 18:51:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:49 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:46 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 6/8] net/mlx5: E-Switch, Implement devlink port function cmds to control RoCE
Date:   Tue, 6 Dec 2022 20:51:17 +0200
Message-ID: <20221206185119.380138-7-shayd@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221206185119.380138-1-shayd@nvidia.com>
References: <20221206185119.380138-1-shayd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E643:EE_|MN2PR12MB4173:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c2b49d0-613b-4e33-3e1d-08dad7baf4a6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3zhRb35ZWPconmtJpJ4Dj2hVJGxyoB4/JGVQ5o3L/qL7at2IwKkQL/u7QefsLZ1xinDQfTzLVJphO3FXKtRZRyHIuwf3K8ZpRAK8mqusQYFxOlY8l4DX36Q+kK1EJqQBu+ZQzgFxF4im3F075HsES+PKzBVjBaRuQihyd7DFdSwTA3v9um3cKdk9A2eFcMeXThIhTBZ4I3M3aQs9ov9rxghdgx6+nvCxAXLrDOzSrJVjH8RzxilStGad+VqnW9xI61KmUW+b8K/uEse196lWeAaRwpW0vHLSAiLxRtBvEkIPX9SWEMO3D1ANl5/Qs296AjhYJ8KKXpbwDCKVTyC1eB+q79TK8ofQbO5HJ0On19N+QRvrkKl+zNG8PVMlmW9BLVNoDiPP0CsDM0XCe3EsOIDltvm0v0azPXlgVFKvZ4DQVeucEaitByDKhKTo2CtiYO0nMfHHm9q9q3VPPVoThnFi9VOw47EV7nVG0CkJH5pDyo4sn0VikojE40ASnK8WdmCOD66MuJxjcbg5iAX1X1HuAaDECXR1N3S5zqpIFljyg+Wy7pLjQEUwZOt+yHtuEV496RRUt1afPlp1w8XHqcQWwnR7WB7wda6VnsuOcBQYDOdBAgjB0g9iU+U6Xrrk5Fghi0d1FbFasM91M8TRRzcpCBxJuIq9C2NvvDH8RKQRtBW0amX8b7YoZpFCULXw9sMPqjVELcwASNBcIsYgMQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(39860400002)(396003)(136003)(451199015)(40470700004)(46966006)(36840700001)(36756003)(82740400003)(5660300002)(86362001)(7636003)(356005)(8936002)(40460700003)(4326008)(41300700001)(30864003)(2906002)(36860700001)(83380400001)(54906003)(70586007)(316002)(70206006)(2616005)(110136005)(40480700001)(8676002)(16526019)(82310400005)(478600001)(107886003)(6666004)(426003)(1076003)(47076005)(186003)(26005)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:51:59.3208
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c2b49d0-613b-4e33-3e1d-08dad7baf4a6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E643.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4173
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

Implement devlink port function commands to enable / disable RoCE.
This is used to control the RoCE device capabilities.

This patch implement infrastructure which will be used by downstream
patches that will add additional capabilities.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
v3-v4:
 - change port_function_roce to port_fn_roce.
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |  10 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  35 ++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   6 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 108 ++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/mlx5_core.h   |   2 +
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  24 ++++
 7 files changed, 186 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
index 07cfc1b07db3..8b8f95d1293a 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5.rst
@@ -354,6 +354,16 @@ MAC address setup
 mlx5 driver support devlink port function attr mechanism to setup MAC
 address. (refer to Documentation/networking/devlink/devlink-port.rst)
 
+RoCE capability setup
+---------------------
+Not all mlx5 PCI devices/SFs require RoCE capability.
+
+When RoCE capability is disabled, it saves 1 Mbytes worth of system memory per
+PCI devices/SF.
+
+mlx5 driver support devlink port function attr mechanism to setup RoCE
+capability. (refer to Documentation/networking/devlink/devlink-port.rst)
+
 SF state setup
 --------------
 To use the SF, the user must activate the SF using the SF function state
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 751bc4a9edcf..336c7b7fa494 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -314,6 +314,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_node_new = mlx5_esw_devlink_rate_node_new,
 	.rate_node_del = mlx5_esw_devlink_rate_node_del,
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
+	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
+	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 374e3fbdc2cf..001fb1e62135 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -772,6 +772,33 @@ static void esw_vport_cleanup_acl(struct mlx5_eswitch *esw,
 		esw_vport_destroy_offloads_acl_tables(esw, vport);
 }
 
+static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
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
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport->vport, query_ctx,
+					    MLX5_CAP_GENERAL);
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
@@ -785,6 +812,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 	if (mlx5_esw_is_manager_vport(esw, vport_num))
 		return 0;
 
+	err = mlx5_esw_vport_caps_get(esw, vport);
+	if (err)
+		goto err_caps;
+
 	mlx5_modify_vport_admin_state(esw->dev,
 				      MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
 				      vport_num, 1,
@@ -804,6 +835,10 @@ static int esw_vport_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 			       vport->info.qos, flags);
 
 	return 0;
+
+err_caps:
+	esw_vport_cleanup_acl(esw, vport);
+	return err;
 }
 
 /* Don't cleanup vport->info, it's needed to restore vport configuration */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 42d9df417e20..eea0521729df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -153,6 +153,7 @@ struct mlx5_vport_info {
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
+	u8                      roce_enabled: 1;
 };
 
 /* Vport context events */
@@ -508,7 +509,10 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
-
+int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
+				  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
+				  struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 33dffcb8bdd7..7618c51351ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4022,3 +4022,111 @@ int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 
 	return mlx5_eswitch_set_vport_mac(esw, vport_num, hw_addr);
 }
+
+static struct mlx5_vport *
+mlx5_devlink_port_fn_get_vport(struct devlink_port *port, struct mlx5_eswitch *esw)
+{
+	u16 vport_num;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return mlx5_eswitch_get_vport(esw, vport_num);
+}
+
+int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
+				  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
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
+int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
+				  struct netlink_ext_ack *extack)
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
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+	vport_num = vport->vport;
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
+	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx,
+					    MLX5_CAP_GENERAL);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack, "Failed getting HCA caps");
+		goto out_free;
+	}
+
+	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
+	memcpy(hca_caps, MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability),
+	       MLX5_UN_SZ_BYTES(hca_cap_union));
+	MLX5_SET(cmd_hca_cap, hca_caps, roce, enable);
+
+	err = mlx5_vport_set_other_func_cap(esw->dev, hca_caps, vport_num,
+					    MLX5_SET_HCA_CAP_OP_MOD_GENERAL_DEVICE);
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
index 09473983778f..029305a8b80a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -324,6 +324,8 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap, u16 function_id,
+				  u16 opmod);
 #define mlx5_vport_get_other_func_general_cap(dev, fid, out)		\
 	mlx5_vport_get_other_func_cap(dev, fid, out, MLX5_CAP_GENERAL)
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 7eca7582f243..ba7e3df22413 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1173,3 +1173,27 @@ int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, vo
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
 EXPORT_SYMBOL_GPL(mlx5_vport_get_other_func_cap);
+
+int mlx5_vport_set_other_func_cap(struct mlx5_core_dev *dev, const void *hca_cap,
+				  u16 function_id, u16 opmod)
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
+	MLX5_SET(set_hca_cap_in, set_ctx, op_mod, opmod << 1);
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
2.38.1

