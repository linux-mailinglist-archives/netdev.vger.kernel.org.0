Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525AC644C0D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiLFSwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiLFSwQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:16 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 184323D90A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:52:15 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hX/s2XyOhlQJ+LQKF74XAXryXbMjBkaFcer5uA56DHVxpXjtjGVBdQRenzP+xxxvavjmo2VqgXw1r2kQnS6WpFIItpQY+loaWkwq8v/+nRF0n1QFgEloeyNaJurlrPK+rBA27hLpVsUr4bex+BFsiJMW4nOioQTXIdYOkoiYCbCScbgZNhivKRFUiqyjImmSXxBJr0008mga+s21khpG9taW9yYW7wjSvZNtn1ydy5v2A0F92D0xFVvkf9AIyheIyhVX1px4IyiK+P/6t7e3u3S2yKx4UrUBh4SnV8yVO0ogK81LbbSQcqWECDD/oBBYxIinY6h26xcCWT8XjRPwGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ADo/j24LhoFGPxD7bML+Il7TOrn7/hIl3EPEOR0ZPss=;
 b=ec4ktI3hLuIvZs1jUIxobHQ213XtZQ/OGQYWIOlDNlvI3HKeQ58JVwWsoxcKbGKLm9shNZeBobVkqViBpM2aoHbzz8XZ5VRTu13TNeAVhdR5Z40gcOSNpTFD8KzgCPUNB0fv3QZ0xvVm8ERMTPRcxCCqOS6lKAIBKXsVdvXTNnu2qnYKC9yqmY1u4Z8e3346WY/YS8obLk3jmQMzazLzvqndC8NkPf3pXH/J5KVlUyDB13XgkpLrtQ5QXRyZ+wVBqOoAP2YDHmHr6duKAaVcIEpxoKlwPYtwARmY4UVIb8p9Yi6ZrjO+vakuIVH/vjPzelh8kBsFiSzw16UuVgTOag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ADo/j24LhoFGPxD7bML+Il7TOrn7/hIl3EPEOR0ZPss=;
 b=gBDrNUYSqN5H5znVUcd6k6sdUMvFcOflH1aQub8hZ1vtKLeeZazrgrG7dvNe8csjGIvKNkmifG1Mfn1nFBV9qTtxNt7MHtEoNYKlvTFuA0y/qZkwlH6iqA/tBYI+utGi4B4nWfHKG9i2BjG90SBUart5vwhQ6vl8WLLZu8AZDtJY8RnVYKFdEQnUxy5thmKfsO2+WaC4VtFltiMBr67W2YF3B0EaBxPpIEkHQ+sqblhkiARc3bd/U+lQgWnRMVwzhqbvrX0nZoGFtZFyjB26V8wU0aJRcdoi8ixmJzdDSP0xvumvPmb8A93s1uBiIoBeKqeMgcGeOB/DUcrKscTo2Q==
Received: from MW4PR03CA0050.namprd03.prod.outlook.com (2603:10b6:303:8e::25)
 by IA0PR12MB7699.namprd12.prod.outlook.com (2603:10b6:208:431::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:52:13 +0000
Received: from CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::8e) by MW4PR03CA0050.outlook.office365.com
 (2603:10b6:303:8e::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:52:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT086.mail.protection.outlook.com (10.13.175.73) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 18:52:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:55 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:52 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 8/8] net/mlx5: E-Switch, Implement devlink port function cmds to control migratable
Date:   Tue, 6 Dec 2022 20:51:19 +0200
Message-ID: <20221206185119.380138-9-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT086:EE_|IA0PR12MB7699:EE_
X-MS-Office365-Filtering-Correlation-Id: 03e6f355-acce-4003-453e-08dad7bafc48
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wArdm9b/GYsk0n7PBmR6W9DG/ejPRCoVIME1uRkaxMD3qFEo+DNPO92xHMEMmSOmBfeRv9eKHGvmpqV5HOasuISfSzeuTr4LO1MiZlTyFClK72xVvb8ZCP1CajSTRTl44MwTnAGNLczc6uwPhqmmJQFZqoHnZE0zir6rlnYsCFwQ9hhFYiomlCFdumOYrDvgt8WG3tAS8rWWOvtYOxsl/rKPJxVxuztNCFcluO9NfuyZ1S0dxxpRuqIpb6wmuimAZdZYEn1wBdF31ZPLPkLd1yR8yXbDNF2lKpztAWQ3FHc66Pgec1iFYnYkJSdDrLXNsal87U2uS9usvGVcq/ElqPLtkfozfSo5NCkga1yKgcjPpO48dsVjy4rB7b6HTjzxxzXviIGnVx83J0uplsKe8AEgsD2oysq5NpSQTaWE9ttWJqm2i/M2+L9aGSQEtrKLNOX0al+0jyoZPDrCuSAw1Rix9siUpWFIFPPRcDWLaXNvO7ncA6DIHDRUOeEjoFpffpBHzH+NbQmXcR6b9D+AcBDJJF/L1pdo2F+gEC94Pi+1LRDZkcB/3bEszS103rrUId5sca93lg0+D5cR7qtH4sspaTH3+OruP5W5YlrdNW/IxQa2TWLL2S3FKbSjR2hTCQSyYFy4UdKhHbGYb3SfoBZv/8RynTG6FwDPMhHrolMUYyIeoSb/tG+kiNvyHjc3xEDARdQ5ddcwh4YgLEHE+w==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199015)(36840700001)(46966006)(40470700004)(1076003)(336012)(186003)(16526019)(316002)(478600001)(110136005)(54906003)(36756003)(356005)(82740400003)(7636003)(40480700001)(86362001)(40460700003)(47076005)(107886003)(83380400001)(2616005)(26005)(82310400005)(426003)(6666004)(8676002)(5660300002)(2906002)(4326008)(70206006)(36860700001)(70586007)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:52:12.1267
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 03e6f355-acce-4003-453e-08dad7bafc48
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT086.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7699
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
v3->v4:
 - change port_function_mig to port_fn_migratable
---
 .../device_drivers/ethernet/mellanox/mlx5.rst |   8 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   8 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   5 +
 .../mellanox/mlx5/core/eswitch_offloads.c     | 101 ++++++++++++++++++
 5 files changed, 124 insertions(+)

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
index 336c7b7fa494..ddb197970c22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -316,6 +316,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.rate_leaf_parent_set = mlx5_esw_devlink_rate_parent_set,
 	.port_fn_roce_get = mlx5_devlink_port_fn_roce_get,
 	.port_fn_roce_set = mlx5_devlink_port_fn_roce_set,
+	.port_fn_migratable_get = mlx5_devlink_port_fn_migratable_get,
+	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
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
index eea0521729df..5a85a5d32be7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -154,6 +154,7 @@ struct mlx5_vport_info {
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
 	u8                      roce_enabled: 1;
+	u8                      mig_enabled: 1;
 };
 
 /* Vport context events */
@@ -513,6 +514,10 @@ int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
 				  struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_roce_set(struct devlink_port *port, bool enable,
 				  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enabled,
+					struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
+					struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 7618c51351ca..c6a14202c62c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4038,6 +4038,107 @@ mlx5_devlink_port_fn_get_vport(struct devlink_port *port, struct mlx5_eswitch *e
 	return mlx5_eswitch_get_vport(esw, vport_num);
 }
 
+int mlx5_devlink_port_fn_migratable_get(struct devlink_port *port, bool *is_enabled,
+					struct netlink_ext_ack *extack)
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
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
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
+int mlx5_devlink_port_fn_migratable_set(struct devlink_port *port, bool enable,
+					struct netlink_ext_ack *extack)
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
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
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
+
 int mlx5_devlink_port_fn_roce_get(struct devlink_port *port, bool *is_enabled,
 				  struct netlink_ext_ack *extack)
 {
-- 
2.38.1

