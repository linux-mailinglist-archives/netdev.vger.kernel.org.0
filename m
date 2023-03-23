Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDDE6C663B
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 12:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbjCWLMY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 07:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbjCWLMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 07:12:10 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20600.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::600])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F992E0F1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 04:12:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fdi6JTOxI1itR7r7Nb4vyrh0OUiyDcQskHCWCVvWtjhcIbMQuor5JJcpqHZliD/ufeSsDBAme8CD9rhWQkapFOVsdPeFQtbLGoioB8M11qQkB54BbFy+FXN+knmN5bkCvJTthENIUuO1HRNBfKmM0KRxQNhKA/c6pwMrGfx2BwthKaLsKjfIp7rF6IGMZpUwgmSaK3b6cK1HnAbWzhliLOk1eXMi4LfdVsBkp2eVabt0Vp6a0UeazW0dfvm0vv9yOhXKBGUep9qV00DgePRxVe09eG/KGtxCtl38pllyv+CAeHwFJ7VPJIgQN9Cqgg2dsEsEY9VsXtyPVR0LWB5c0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XAr94i1vxEPdl7xyvwcVcFGD1Z8ewH5tyBnU7gnW1L4=;
 b=I8HMG9+lCACajUERkaMU/GV/52OqQQV4wCN6thhLCAgVH7eUMGtusBpkjrEmxqKpDISgvNpREaPI4+gztyCKrxvGFPIO4YxBumPEnxhYILMqkUW6E8o7LipkUAyQG7OI6Pr5lVgT3tx3OIlKIGQOGbHFrmdUHSEJYytIx043ghfB53zDEYR8q9P0FSXX/+/6qsj9Dbx8oA4DLNDntN3/Ii2S8HEnbFR5HHny+ycyvkutm5MNhX1U678odJCneeuAxlATjBjMfBjg8iP5AybhfH2wxA9E+qFEUaDmAuZ0y328zJTBnYEo3ooSMgOkWOBtO5gp+1g/ekVrHBwv6DZjbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XAr94i1vxEPdl7xyvwcVcFGD1Z8ewH5tyBnU7gnW1L4=;
 b=pt5PqkZSP0r/2eMJlsZtg00e5XHcJILfDtkKuAhqpm8Zi1LbNaK4xowH/6b9TFQDx6gRwnkLv+uj3/9cgZR/JPTcJwOP8ps3lV8C62I97HGTwGnKcrJ53YV5juMeC1NZbi1okOkJ5JmUDhWmQG76MXpsJ7p4AhshcVhwOVZIJDuF+ciKZIQM3jZGPwK4//HBJg3EfueKTN0yg70GPv890LpyqRr6elKodOtmsWr5zT7O172Q8fXdy2rdzhOUru0X6K7Uc636qk3HOMINUs9q8onaQOuIYJTrmeR5UCB+qkmtzCxngiU1EjY6qlkJRItGQ6lft5KIqA0zMHyS0bQbcQ==
Received: from DM6PR08CA0029.namprd08.prod.outlook.com (2603:10b6:5:80::42) by
 DM4PR12MB6613.namprd12.prod.outlook.com (2603:10b6:8:b8::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Thu, 23 Mar 2023 11:11:59 +0000
Received: from DS1PEPF0000E650.namprd02.prod.outlook.com
 (2603:10b6:5:80:cafe::71) by DM6PR08CA0029.outlook.office365.com
 (2603:10b6:5:80::42) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Thu, 23 Mar 2023 11:11:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DS1PEPF0000E650.mail.protection.outlook.com (10.167.18.6) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.30 via Frontend Transport; Thu, 23 Mar 2023 11:11:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 23 Mar 2023
 04:11:52 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 23 Mar
 2023 04:11:51 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.5 via Frontend Transport; Thu, 23 Mar
 2023 04:11:49 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Dima Chumak <dchumak@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 4/4] net/mlx5: Implement devlink port function cmds to control ipsec_packet
Date:   Thu, 23 Mar 2023 13:10:59 +0200
Message-ID: <20230323111059.210634-5-dchumak@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230323111059.210634-1-dchumak@nvidia.com>
References: <20230323111059.210634-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E650:EE_|DM4PR12MB6613:EE_
X-MS-Office365-Filtering-Correlation-Id: 49092fde-1184-4b68-e4fc-08db2b8f6c2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xF+jEhSDqvbqq7Dzm813A/UudM41KM1yKgMOtmC1ZybjhU6ppZW9g1SugG5ce8oK4zEFWuyQWuJoVlcXJqWZLsyP6NaOw2K4cF+oZxO5avUKxaLX2tUjI2DvBlrhCaISfknUlL1BU3WJTcr6pRuCGWnQnzTBd7LqkgkZ4QuhMwKXRVZrSmXDgJbuVrRTuJcEPNAQPA+sAjMtVrgEZDrZ665+vC92J2mMfGfeJl+JMwRkdZpk9L2mrjtH1mnsWwyiLji5b0AfCrfYzTgZ/EhljF5c+kiTnPByt0i4vz/s3pjKuPLExhb2HqpGrkubE6rC2kJeJgn8yaYiRH/C8zlACq1cpRGmWy0B5tuwf9ovpHaSTUm4JDWxODpHR1ufnK93JN7wj+rwsbDGtg2EDPToIrPBPMQrJNHbhUOjhxwnGKXf/KwBg2PyJyphOtUSP9ujcUrlNNJ86D08oRN2P03QKG5pDt1tdw4n8pUnChWeMoQ1QW5aPyZjFUPjG1Yf0MaRNaFcyIzJ2Pw5SZnYS9XAdIgC7j1CtdW6bPohy10OsRIX0Ae4w/gvr5j8Co1KLuDg0pkPlUvuaBStZR+9O0bLC3fPoXy5OcS7gB7uYlX8nwFJJUSwS+sk8i8hNCLsw9qRj1K3uK49ORc29s0NQtms9R7ha/Q8Poim7lsTa1lYxpw4IpolhhUUXxGdwuDyP5L5KC0Ef5ERs93C4iQWR5tD+Qn91rhU/YbHtiln+uUBNQosA87J/7ZC354wb5lIK2hM
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(40470700004)(46966006)(36840700001)(4326008)(70206006)(6916009)(8676002)(41300700001)(70586007)(5660300002)(30864003)(8936002)(40460700003)(2906002)(7636003)(86362001)(356005)(36756003)(82740400003)(7696005)(316002)(6666004)(1076003)(186003)(26005)(54906003)(82310400005)(40480700001)(36860700001)(107886003)(478600001)(83380400001)(2616005)(47076005)(426003)(336012);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2023 11:11:59.6981
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 49092fde-1184-4b68-e4fc-08db2b8f6c2e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E650.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6613
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement devlink port function commands to enable / disable IPsec
packet offloads. This is used to control the IPsec capability of the
device.

When ipsec_offload is enabled for a VF, it prevents adding IPsec packet
offloads on the PF, because the two cannot be active simultaneously due
to HW constraints. Conversely, if there are any active IPsec packet
offloads on the PF, it's not allowed to enable ipsec_packet on a VF,
until PF IPsec offloads are cleared.

Signed-off-by: Dima Chumak <dchumak@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlx5/switchdev.rst      |   8 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   |  40 +++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  11 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |   9 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 100 ++++++++++++++++++
 6 files changed, 160 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
index 9a41da6b33ff..ccfb02e7c2ad 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/switchdev.rst
@@ -176,6 +176,14 @@ to explicitly enable the VF ipsec_crypto capability.
 mlx5 driver support devlink port function attr mechanism to setup ipsec_crypto
 capability. (refer to Documentation/networking/devlink/devlink-port.rst)
 
+IPsec packet capability setup
+~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+User who wants mlx5 PCI VFs to be able to perform IPsec packet offloading need
+to explicitly enable the VF ipsec_packet capability.
+
+mlx5 driver support devlink port function attr mechanism to setup ipsec_packet
+capability. (refer to Documentation/networking/devlink/devlink-port.rst)
+
 SF state setup
 --------------
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index 6beea396401a..36b7bb528d09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -326,6 +326,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 	.port_fn_migratable_set = mlx5_devlink_port_fn_migratable_set,
 	.port_fn_ipsec_crypto_get = mlx5_devlink_port_fn_ipsec_crypto_get,
 	.port_fn_ipsec_crypto_set = mlx5_devlink_port_fn_ipsec_crypto_set,
+	.port_fn_ipsec_packet_get = mlx5_devlink_port_fn_ipsec_packet_get,
+	.port_fn_ipsec_packet_set = mlx5_devlink_port_fn_ipsec_packet_set,
 #endif
 #ifdef CONFIG_MLX5_SF_MANAGER
 	.port_new = mlx5_devlink_sf_port_new,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
index ab67e375c87b..af653bcadbb4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -36,9 +36,11 @@ static int esw_ipsec_vf_query_generic(struct mlx5_core_dev *dev, u16 vport_num,
 
 enum esw_vport_ipsec_offload {
 	MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD,
+	MLX5_ESW_VPORT_IPSEC_PACKET_OFFLOAD,
 };
 
-static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
+static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
+			      bool *crypto, bool *packet)
 {
 	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
 	void *hca_cap = NULL, *query_cap = NULL;
@@ -53,6 +55,7 @@ static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vpor
 		return err;
 	if (!ipsec_enabled) {
 		*crypto = false;
+		*packet = false;
 		return 0;
 	}
 
@@ -66,6 +69,7 @@ static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vpor
 
 	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
 	*crypto = MLX5_GET(ipsec_cap, hca_cap, ipsec_crypto_offload);
+	*packet = MLX5_GET(ipsec_cap, hca_cap, ipsec_full_offload);
 out:
 	kvfree(query_cap);
 	return err;
@@ -140,6 +144,9 @@ static int esw_ipsec_vf_set_bytype(struct mlx5_core_dev *dev, struct mlx5_vport
 	case MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD:
 		MLX5_SET(ipsec_cap, cap, ipsec_crypto_offload, enable);
 		break;
+	case MLX5_ESW_VPORT_IPSEC_PACKET_OFFLOAD:
+		MLX5_SET(ipsec_cap, cap, ipsec_full_offload, enable);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -197,6 +204,7 @@ static int esw_ipsec_vf_offload_set_bytype(struct mlx5_eswitch *esw, struct mlx5
 					   bool enable, enum esw_vport_ipsec_offload type)
 {
 	struct mlx5_core_dev *dev = esw->dev;
+	bool crypto_enabled, packet_enabled;
 	int err = 0;
 
 	if (vport->index == MLX5_VPORT_PF)
@@ -234,16 +242,28 @@ static int esw_ipsec_vf_offload_set_bytype(struct mlx5_eswitch *esw, struct mlx5
 				      err);
 			return err;
 		}
-		err = esw_ipsec_vf_set_generic(dev, vport->index, enable);
+		err = mlx5_esw_ipsec_vf_offload_get(dev, vport, &crypto_enabled, &packet_enabled);
 		if (err) {
-			mlx5_core_dbg(dev, "Failed to disable generic ipsec_offload: %d\n",
-				      err);
+			mlx5_core_dbg(dev, "Failed to get ipsec_offload caps: %d\n", err);
 			return err;
 		}
+		/* The generic ipsec_offload cap can be disabled only if both
+		 * ipsec_crypto_offload and ipsec_full_offload aren't enabled.
+		 */
+		if (!crypto_enabled && !packet_enabled) {
+			err = esw_ipsec_vf_set_generic(dev, vport->index, enable);
+			if (err) {
+				mlx5_core_dbg(dev, "Failed to disable generic ipsec_offload: %d\n",
+					      err);
+				return err;
+			}
+		}
 	}
 
 	if (type == MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD)
 		vport->info.ipsec_crypto_enabled = enable;
+	else if (type == MLX5_ESW_VPORT_IPSEC_PACKET_OFFLOAD)
+		vport->info.ipsec_packet_enabled = enable;
 
 	return err;
 }
@@ -258,9 +278,10 @@ bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev)
 	return MLX5_CAP_FLOWTABLE_NIC_TX(dev, reformat_add_esp_trasport);
 }
 
-int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
+int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
+				  bool *crypto, bool *packet)
 {
-	return esw_ipsec_vf_query(dev, vport, crypto);
+	return esw_ipsec_vf_query(dev, vport, crypto, packet);
 }
 
 int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
@@ -269,3 +290,10 @@ int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_v
 	return esw_ipsec_vf_offload_set_bytype(esw, vport, enable,
 					       MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD);
 }
+
+int mlx5_esw_ipsec_vf_packet_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+					 bool enable)
+{
+	return esw_ipsec_vf_offload_set_bytype(esw, vport, enable,
+					       MLX5_ESW_VPORT_IPSEC_PACKET_OFFLOAD);
+}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 7d4f19c21f48..65d52bba1b60 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -784,6 +784,7 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 {
 	int query_out_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
 	bool ipsec_crypto_enabled;
+	bool ipsec_packet_enabled;
 	void *query_ctx;
 	void *hca_caps;
 	int err;
@@ -812,10 +813,12 @@ static int mlx5_esw_vport_caps_get(struct mlx5_eswitch *esw, struct mlx5_vport *
 	hca_caps = MLX5_ADDR_OF(query_hca_cap_out, query_ctx, capability);
 	vport->info.mig_enabled = MLX5_GET(cmd_hca_cap_2, hca_caps, migratable);
 
-	err = mlx5_esw_ipsec_vf_offload_get(esw->dev, vport, &ipsec_crypto_enabled);
+	err = mlx5_esw_ipsec_vf_offload_get(esw->dev, vport, &ipsec_crypto_enabled,
+					    &ipsec_packet_enabled);
 	if (err)
 		goto out_free;
 	vport->info.ipsec_crypto_enabled = ipsec_crypto_enabled;
+	vport->info.ipsec_packet_enabled = ipsec_packet_enabled;
 out_free:
 	kfree(query_ctx);
 	return err;
@@ -919,7 +922,8 @@ int mlx5_esw_vport_enable(struct mlx5_eswitch *esw, u16 vport_num,
 	/* Sync with current vport context */
 	vport->enabled_events = enabled_events;
 	vport->enabled = true;
-	if (vport->vport != MLX5_VPORT_PF && vport->info.ipsec_crypto_enabled)
+	if (vport->vport != MLX5_VPORT_PF &&
+	    (vport->info.ipsec_crypto_enabled || vport->info.ipsec_packet_enabled))
 		mlx5_esw_vport_ipsec_offload_enable(esw);
 
 	/* Esw manager is trusted by default. Host PF (vport 0) is trusted as well
@@ -979,7 +983,8 @@ void mlx5_esw_vport_disable(struct mlx5_eswitch *esw, u16 vport_num)
 	    MLX5_CAP_GEN(esw->dev, vhca_resource_manager))
 		mlx5_esw_vport_vhca_id_clear(esw, vport_num);
 
-	if (vport->vport != MLX5_VPORT_PF && vport->info.ipsec_crypto_enabled)
+	if (vport->vport != MLX5_VPORT_PF &&
+	    (vport->info.ipsec_crypto_enabled || vport->info.ipsec_packet_enabled))
 		mlx5_esw_vport_ipsec_offload_disable(esw);
 
 	/* We don't assume VFs will cleanup after themselves.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index dc7949814b91..43996101d784 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -158,6 +158,7 @@ struct mlx5_vport_info {
 	u8                      roce_enabled: 1;
 	u8                      mig_enabled: 1;
 	u8                      ipsec_crypto_enabled: 1;
+	u8                      ipsec_packet_enabled: 1;
 };
 
 /* Vport context events */
@@ -525,6 +526,10 @@ int mlx5_devlink_port_fn_ipsec_crypto_get(struct devlink_port *port, bool *is_en
 					  struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
 					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_packet_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_packet_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack);
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
 int __mlx5_eswitch_set_vport_vlan(struct mlx5_eswitch *esw,
@@ -661,9 +666,11 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
 
 bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev);
 int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
-				  bool *crypto);
+				  bool *crypto, bool *packet);
 int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 					 bool enable);
+int mlx5_esw_ipsec_vf_packet_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
+					 bool enable);
 void mlx5_esw_vport_ipsec_offload_enable(struct mlx5_eswitch *esw);
 void mlx5_esw_vport_ipsec_offload_disable(struct mlx5_eswitch *esw);
 bool mlx5_esw_vport_ipsec_offload_enabled(struct mlx5_eswitch *esw);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index fd546dd0a481..444ee8712584 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4239,3 +4239,103 @@ int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable
 	mutex_unlock(&net->xfrm.xfrm_cfg_mutex);
 	return err;
 }
+
+int mlx5_devlink_port_fn_ipsec_packet_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_packet");
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
+		*is_enabled = vport->info.ipsec_packet_enabled;
+		err = 0;
+	}
+	mutex_unlock(&esw->state_lock);
+	return err;
+}
+
+int mlx5_devlink_port_fn_ipsec_packet_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack)
+{
+	struct mlx5_eswitch *esw;
+	struct mlx5_vport *vport;
+	int err = -EOPNOTSUPP;
+	struct net *net;
+
+	esw = mlx5_devlink_eswitch_get(port->devlink);
+	if (IS_ERR(esw))
+		return PTR_ERR(esw);
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_packet");
+		return err;
+	}
+
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	/* xfrm_cfg lock is needed to avoid races with XFRM state being added to
+	 * the PF net device. Netlink stack takes this lock for `ip xfrm` user
+	 * commands, so here we need to take it before esw->state_lock to
+	 * preserve the order.
+	 */
+	net = dev_net(esw->dev->mlx5e_res.uplink_netdev);
+	mutex_lock(&net->xfrm.xfrm_cfg_mutex);
+
+	mutex_lock(&esw->state_lock);
+	if (!vport->enabled) {
+		NL_SET_ERR_MSG_MOD(extack, "Eswitch vport is disabled");
+		goto out;
+	}
+	if (vport->info.ipsec_packet_enabled == enable) {
+		err = 0;
+		goto out;
+	}
+
+	err = mlx5_esw_ipsec_vf_packet_offload_set(esw, vport, enable);
+	switch (err) {
+	case 0:
+		break;
+	case -EBUSY:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed setting ipsec_packet. Make sure ip xfrm state/policy is cleared on the PF.");
+		goto out;
+	case -EINVAL:
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Failed setting ipsec_packet. Make sure to unbind the VF first");
+		goto out;
+	default:
+		NL_SET_ERR_MSG_MOD(extack, "Failed setting HCA ipsec_full_offload cap.");
+		goto out;
+	}
+
+	vport->info.ipsec_packet_enabled = enable;
+	if (enable)
+		mlx5_esw_vport_ipsec_offload_enable(esw);
+	else
+		mlx5_esw_vport_ipsec_offload_disable(esw);
+out:
+	mutex_unlock(&esw->state_lock);
+	mutex_unlock(&net->xfrm.xfrm_cfg_mutex);
+	return err;
+}
-- 
2.40.0

