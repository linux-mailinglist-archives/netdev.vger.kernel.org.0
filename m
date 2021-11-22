Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2805A459073
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 15:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbhKVOq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 09:46:57 -0500
Received: from mail-mw2nam10on2072.outbound.protection.outlook.com ([40.107.94.72]:4544
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239779AbhKVOqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 09:46:54 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ncAsagMWoxT/Zm2en2Fuws4j0RKtAgD7NYlVuCIcciQ2nWOJCWFH5Stgo2uB2QAez1KlgrlGZpchPf/QfZ2g4uBAvQF1ZDrRhhbpvzK0/cYZ/f822awTeZsayxDGuqiT8qhmFoXPLfpW4esF0vKqZ2QnyUf7EyZItvTmAOZo1O4xfHyLZf/NhSSWJ4vMYUcRGNRh91YNCjxrkoGrQ1PMk8M7ngYWmSplx8IF6tuCVgUh4HMgeVMdUqB9amwPumAeH0RIgckdGzmOFvOL20SvCibyjcmeafZBhe+iMMkIdRH9a+gxzPwXzUsHh0YgMn5h9InNZmDD1ovVPwxFV6nLkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B6O7NGuNOE4tsr8sxQ3CsztVnCHhpdbN9c2P2uygUgY=;
 b=R73vDOLd0GICHNnlO0nnNlAIPjt1ndrT1O4bAZm9v9ybbL84Uw+fWZFDYf40RPaT6LX/fE5T5PxtOQDbIwejkrA6KHtM1FBVv+Q4+MC1b+9D03uiFgwDNM7cWxYm6gZVzL/vmh9top61y8HDgcK7sTkSfk+OHY2z0Akb2n4kyM4Oo9v+jEgqKawNgmTgFsT8bgb5eLmwmfcvovrtT4aOtjCgrNeHobW/dzxnTJm4TJ0K7BdTWYVPq1ji8v1aS0xIw3XKUgBgE+B3PXBU1mSxbvQcVfuXLKO0hepvhcamFOik5JTWhkNZO9gt5SR88huqy6dVEcidmqrJKV+h5lqcyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B6O7NGuNOE4tsr8sxQ3CsztVnCHhpdbN9c2P2uygUgY=;
 b=PeMBSipOqi8a6bkgd5dCA9e5+RlQHabMhNFVyQLrpRY/0RyUDae0zV5XTbE9g4sV76794WG6PlU0UtoiuXQY8T6QtgNqEcK5boKTEK9CGU/jUp2y48TvwsjB3VN68dVfw6eVtA5dFw2eO2d/G9HcJ0Bxu1FlhD48sxolb2sLT3YzgmWr11y1Ihec9tb6CYR3Z7tg0mWhL2tN2Ktpurzc+S/UD5OJ7hThhSzoLuqWYm5yPWzACN3eoYoleDW+IQMUz8n2AhOZ0B9yWOhlfMQVq4Yo5icE/MC9v89LtdJ1AFMa39CwHq0HEV9K64L73GZR58cIBBLQQxypK+q0OL+yRQ==
Received: from DM6PR03CA0010.namprd03.prod.outlook.com (2603:10b6:5:40::23) by
 BY5PR12MB4917.namprd12.prod.outlook.com (2603:10b6:a03:1d1::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4713.19; Mon, 22 Nov 2021 14:43:46 +0000
Received: from DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:40:cafe::be) by DM6PR03CA0010.outlook.office365.com
 (2603:10b6:5:40::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19 via Frontend
 Transport; Mon, 22 Nov 2021 14:43:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT018.mail.protection.outlook.com (10.13.172.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4713.20 via Frontend Transport; Mon, 22 Nov 2021 14:43:45 +0000
Received: from mtx-w2012r202.mtx.labs.mlnx (172.20.187.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1497.18; Mon, 22 Nov 2021 14:43:44 +0000
From:   Sunil Rani <sunrani@nvidia.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <parav@nvidia.com>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        Sunil Rani <sunrani@nvidia.com>,
        Bodong Wang <bodong@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [PATCH net-next 2/2] net/mlx5: SF/VF, Port function trust set support
Date:   Mon, 22 Nov 2021 16:43:07 +0200
Message-ID: <20211122144307.218021-3-sunrani@nvidia.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211122144307.218021-1-sunrani@nvidia.com>
References: <20211122144307.218021-1-sunrani@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c285f6e-af02-4883-0f6a-08d9adc67cec
X-MS-TrafficTypeDiagnostic: BY5PR12MB4917:
X-Microsoft-Antispam-PRVS: <BY5PR12MB49170C873550C20D3E58C6EDD49F9@BY5PR12MB4917.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XHRfE6ICz9O+lm8VMevgVXab8nPmHTe7xji/uOPuGG8ZIIpAXibKsuDk5xbvMXfs8QNTdPC9PyNyjVfcs5tvR+B+EgizlIF1/3BXXjowKsviTW7JMWc3cplm4TNp35rVk2rogauLRxApaFpcXwUp/RPupFWkjQvzyxlWjFucJJalyb/xRSi9F1fjVK7BKZt/XkvfSVyTRN5t3mralDEJSHauOjNziWQtWnEphEqV9C1m0q/+L9Ov+WPgolWPHwgzaceD4TsZJYC7vLD9C2NEkcT66vu4LWNy/VqDHYC94ADEL63C9nnDYVMx68XkhwmINtOEuHJ8MJgZUiSEXvOK4cE79w17g+O2QM/YQA3HcEN7xHokwN6wYE5hSYIJ4i6oV2ngZjEYJrYHABD1NeB3I78y4eLY9R0WpTYke/Z0bAv8+roplMdTxEzvQlM3KRn14kU3sK58WOOAJtpfZNNoNE6TkLScdBcOJB2hwVBrhZKzsCPNVMYlJSQLIXaVSCdN04pemscXorV45YlxxGWysoV2mwQu00vSMLbQV2Roza49iCIbSJPxK+sn6ZzInN7pDJU5rjom51Hve7wMh4K4yZro4haqximqBcjgd0jbVnIYGrhwGv4NACLiw9GQEq/1rDsfr67vlAGENPDuZNZz4NM10e8w6V1y843UKxAsFIxvmV3TP0rCeApSS0mccDCFRgAQ1guvmpeJkkDIMV7X8g==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(36756003)(110136005)(1076003)(8936002)(2616005)(54906003)(2906002)(70206006)(8676002)(47076005)(6666004)(86362001)(336012)(426003)(70586007)(36906005)(4326008)(7636003)(316002)(83380400001)(356005)(508600001)(107886003)(16526019)(186003)(5660300002)(26005)(36860700001)(82310400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2021 14:43:45.9101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c285f6e-af02-4883-0f6a-08d9adc67cec
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT018.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4917
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support to mark a given PCI sub-function (SF) or
Virtual function (VF) as a trusted function. The device/firmware
decides how to define privileges and access to resources. Trust
state is queried and cached during function creation. These functions
by default are in untrusted mode.

Function restores to its untrusted state when either user marks it as
untrusted or the function is deleted (SR-IOV disablement or
SF port deletion).

Examples of add, change privilege level and show commands:
$ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 88
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted false

$ devlink port function set pci/0000:08:00.0/32768 trusted true

$ devlink port show pci/0000:08:00.0/32768
pci/0000:08:00.0/32768: type eth netdev eth6 flavour pcisf controller 0 pfnum 0 sfnum 88 splittable false
  function:
    hw_addr 00:00:00:00:00:00 state inactive opstate detached trusted true

Signed-off-by: Sunil Rani <sunrani@nvidia.com>
Signed-off-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Saeed Mahameed < saeedm@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  24 ++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  11 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 116 ++++++++++++++++++
 include/linux/mlx5/driver.h                   |   1 +
 include/linux/mlx5/mlx5_ifc.h                 |  10 +-
 6 files changed, 162 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 1c98652b244a..cbf4288a777a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -298,6 +298,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.eswitch_encap_mode_get = mlx5_devlink_eswitch_encap_mode_get,
 	.port_function_hw_addr_get = mlx5_devlink_port_function_hw_addr_get,
 	.port_function_hw_addr_set = mlx5_devlink_port_function_hw_addr_set,
+	.port_fn_trusted_set = mlx5_devlink_port_function_trusted_set,
+	.port_fn_trusted_get = mlx5_devlink_port_function_trusted_get,
 	.rate_leaf_tx_share_set = mlx5_esw_devlink_rate_leaf_tx_share_set,
 	.rate_leaf_tx_max_set = mlx5_esw_devlink_rate_leaf_tx_max_set,
 	.rate_node_tx_share_set = mlx5_esw_devlink_rate_node_tx_share_set,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 46532dd42b43..aca52a474af1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -820,6 +820,24 @@ static void esw_vport_cleanup(struct mlx5_eswitch *esw, struct mlx5_vport *vport
 	esw_vport_cleanup_acl(esw, vport);
 }
 
+static int mlx5_esw_query_hca_trusted(struct mlx5_eswitch *esw,
+				      struct mlx5_vport *vport)
+{
+	bool trusted;
+	int err;
+
+	err = mlx5_esw_get_hca_trusted(esw, vport->vport, &trusted);
+	if (err == -EOPNOTSUPP)
+		return 0;
+
+	if (err)
+		return err;
+
+	vport->info.offloads_trusted = trusted;
+
+	return 0;
+}
+
 int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 			  enum mlx5_eswitch_vport_event enabled_events)
 {
@@ -857,6 +875,12 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 			goto err_vhca_mapping;
 	}
 
+	if (!mlx5_esw_is_manager_vport(esw, vport_num)) {
+		ret = mlx5_esw_query_hca_trusted(esw, vport);
+		if (ret)
+			goto err_vhca_mapping;
+	}
+
 	/* External controller host PF has factory programmed MAC.
 	 * Read it from the device.
 	 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 513f741d16c7..116cfa1c7ca8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -150,6 +150,7 @@ struct mlx5_vport_info {
 	u8                      qos;
 	u8                      spoofchk: 1;
 	u8                      trusted: 1;
+	u8                      offloads_trusted: 1;
 };
 
 /* Vport context events */
@@ -510,7 +511,15 @@ int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 int mlx5_devlink_port_function_hw_addr_set(struct devlink_port *port,
 					   const u8 *hw_addr, int hw_addr_len,
 					   struct netlink_ext_ack *extack);
-
+int mlx5_devlink_port_function_trusted_get(struct devlink_port *port,
+					   bool *trusted,
+					   struct netlink_ext_ack *extack);
+int mlx5_devlink_port_function_trusted_set(struct devlink_port *port,
+					   bool trusted,
+					   struct netlink_ext_ack *extack);
+int mlx5_esw_get_hca_trusted(struct mlx5_eswitch *esw,
+			     u16 vport_num,
+			     bool *trusted);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int mlx5_eswitch_add_vlan_action(struct mlx5_eswitch *esw,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 4bd502ae82b6..0812cf826787 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3871,6 +3871,122 @@ is_port_function_supported(struct mlx5_eswitch *esw, u16 vport_num)
 	       mlx5_esw_is_sf_vport(esw, vport_num);
 }
 
+static struct mlx5_vport *
+mlx5_dlport_to_vport_get(struct devlink_port *port, struct mlx5_eswitch *esw,
+			 struct netlink_ext_ack *extack)
+{
+	u16 vport_num;
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!is_port_function_supported(esw, vport_num))
+		return ERR_PTR(-EOPNOTSUPP);
+
+	return mlx5_eswitch_get_vport(esw, vport_num);
+}
+
+static int mlx5_esw_set_hca_trusted(struct mlx5_eswitch *esw, u16 vport_num, bool trusted)
+{
+	u32 out[MLX5_ST_SZ_DW(vhca_trust_level)] = {};
+	u32 in[MLX5_ST_SZ_DW(vhca_trust_level)] = {};
+	int sz = MLX5_ST_SZ_BYTES(vhca_trust_level);
+	u16 vhca_id;
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_trust_level_reg))
+		return -EOPNOTSUPP;
+
+	err = mlx5_esw_query_vport_vhca_id(esw, vport_num, &vhca_id);
+	if (err) {
+		esw_warn(esw->dev, "Getting vhca_id for vport=%u failed err=%d\n",
+			 vport_num, err);
+		return err;
+	}
+
+	MLX5_SET(vhca_trust_level, in, vhca_id, vhca_id);
+	MLX5_SET(vhca_trust_level, in, trust_level, trusted);
+
+	return mlx5_core_access_reg(esw->dev, in, sz, out, sz, MLX5_REG_TRUST_LEVEL, 0, 1);
+}
+
+int mlx5_devlink_port_function_trusted_set(struct devlink_port *port,
+					   bool trusted,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	vport = mlx5_dlport_to_vport_get(port, esw, extack);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to get vport");
+		return PTR_ERR(vport);
+	}
+
+	err = mlx5_esw_set_hca_trusted(esw, vport->vport, trusted);
+	if (!err)
+		vport->info.offloads_trusted = trusted;
+
+	return err;
+}
+
+int mlx5_esw_get_hca_trusted(struct mlx5_eswitch *esw, u16 vport_num, bool *trusted)
+{
+	u32 out[MLX5_ST_SZ_DW(vhca_trust_level)] = {};
+	u32 in[MLX5_ST_SZ_DW(vhca_trust_level)] = {};
+	int sz = MLX5_ST_SZ_BYTES(vhca_trust_level);
+	u32 trust_level;
+	u16 vhca_id;
+	int err;
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_trust_level_reg))
+		return -EOPNOTSUPP;
+
+	err = mlx5_esw_query_vport_vhca_id(esw, vport_num, &vhca_id);
+	if (err) {
+		esw_warn(esw->dev, "Query of vhca_id for vport %d failed, err %d\n",
+			 vport_num, err);
+		return err;
+	}
+
+	MLX5_SET(vhca_trust_level, in, vhca_id, vhca_id);
+	mlx5_core_access_reg(esw->dev, in, sz, out, sz, MLX5_REG_TRUST_LEVEL, 0, 0);
+	trust_level = MLX5_GET(vhca_trust_level, out, trust_level);
+	*trusted = trust_level & 0x1;
+
+	return 0;
+}
+
+int mlx5_devlink_port_function_trusted_get(struct devlink_port *port,
+					   bool *trusted,
+					   struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!MLX5_CAP_GEN(esw->dev, vhca_trust_level_reg))
+		return -EOPNOTSUPP;
+
+	vport = mlx5_dlport_to_vport_get(port, esw, extack);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed to get vport");
+		return PTR_ERR(vport);
+	}
+
+	*trusted = vport->info.offloads_trusted;
+
+	return 0;
+}
+
 int mlx5_devlink_port_function_hw_addr_get(struct devlink_port *port,
 					   u8 *hw_addr, int *hw_addr_len,
 					   struct netlink_ext_ack *extack)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index a623ec635947..ce8e35f59851 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -153,6 +153,7 @@ enum {
 	MLX5_REG_MIRC		 = 0x9162,
 	MLX5_REG_SBCAM		 = 0xB01F,
 	MLX5_REG_RESOURCE_DUMP   = 0xC000,
+	MLX5_REG_TRUST_LEVEL     = 0xC007,
 	MLX5_REG_DTOR            = 0xC00E,
 };
 
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 3636df90899a..c9b39a08aae0 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1401,7 +1401,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         vhca_trust_level_reg[0x1];
+	u8         reserved_at_131[0x9];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0x6];
@@ -11485,6 +11486,13 @@ struct mlx5_ifc_tls_progress_params_bits {
 	u8         hw_offset_record_number[0x18];
 };
 
+struct mlx5_ifc_vhca_trust_level_bits {
+	u8        all_vhca[0x1];
+	u8        reserved_0[0xf];
+	u8        vhca_id[0x10];
+	u8        trust_level[0x20];
+};
+
 enum {
 	MLX5_MTT_PERM_READ	= 1 << 0,
 	MLX5_MTT_PERM_WRITE	= 1 << 1,
-- 
2.26.2

