Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287DA6EA898
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 12:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231478AbjDUKuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 06:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231562AbjDUKtz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 06:49:55 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2041.outbound.protection.outlook.com [40.107.220.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91B13C166
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 03:49:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VNm7+BHuANsfhVGuyHhu65e68K116zaWTwwFLdmmGx3QlldfRt50ZViATzTTCRj/FPQ82lS/wq4UliE83bhLhZG1tOG4x1ONkmfeE33kqSziEQjZm76PVWWrDYakBHsgs9s5xIBZh+O6U+/zUz85ACXOiP61eNhc4f453sLSc0wXgwaxJYLPhsRz7VMAnQN/KLKPN9ouv997YQZeePm8pJx/wFN0gu6tYt1ccnZeMr3OzzTgzeUysNrdZP3O5/L5TgfyRHAfehEb6yKf7s3/uk2P5vvKg7dfVfcdQCIIrpHdPI0KnJ0lQYp7RlF0UMKBvBJoJVF7kMFXHV4fagczHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M/k7mkvDISXN2/xms8RX0SOk765W/UBxs6XS8Ua9Dcw=;
 b=VaoLGupTRg98ty5WV8IwVwe444ZB9OAsa2+tYD7keusyEOYmP61yuOfXOMV9DIeEQUy9pitsBqDWl/bjueTL+EBWPeTpnk44CvfyOeZfjgLtUaoxrEcaBp+WzIbO/JRflMjYaXDOxmP9Aae+mIxnEDdfrWKsc8pAQ4goE+xbpJuNUXJmIfD3fVeKyBPu5Ma2gvLtcKsEhcJy5Kkhpz91Wkv1xtCp6sFbDCPkQmO9uhcOvkNu2L4SmeIrh+x95DCkMZBuHDkT/RIy97TcJH+RMFHWGy7XAY3YqNdChseZBsDZbv7Abm017OHZFaaO85WoKWTjUGDCtHg8EPxnfiDzTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.233) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M/k7mkvDISXN2/xms8RX0SOk765W/UBxs6XS8Ua9Dcw=;
 b=S800FCx9FBTrxGGd76OyphujkV4ybYJrKRzEyCfQWMXe3cL9lEVNNlQLEiaVXTCAC1ZyXLdoYGAFMfAH51eHwnCXNm7SCCcfIObnAzPToZG4Yu+k15WJ2ZdBrlxHSAvM+betv3w/dgaBiRkbRk4Vvwt2BD1KVdAHX/1NSFDINx2beLwzLRmTFoX5LjwrU9gF6YNuH7gwltDM1WfQjiD+6QLmHK8fb0nYJBOm1BNvKMJCxjhgDVNBHmRVu7S2PCvgjNBJvU5nBSiFVf3cYcwQR7+8N8zJ78COIQVIPLWtnajf4FXBcEktN373Z4NG4AsQwIqhz0kewgzRYc6jqLpzVw==
Received: from BN1PR13CA0009.namprd13.prod.outlook.com (2603:10b6:408:e2::14)
 by DM4PR12MB6614.namprd12.prod.outlook.com (2603:10b6:8:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Fri, 21 Apr
 2023 10:49:49 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e2:cafe::9d) by BN1PR13CA0009.outlook.office365.com
 (2603:10b6:408:e2::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.11 via Frontend
 Transport; Fri, 21 Apr 2023 10:49:49 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.233)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.233 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.233; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.233) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.27 via Frontend Transport; Fri, 21 Apr 2023 10:49:49 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by mail.nvidia.com
 (10.127.129.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Fri, 21 Apr 2023
 03:49:43 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.37; Fri, 21 Apr 2023 03:49:43 -0700
Received: from vdi.nvidia.com (10.127.8.13) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.37 via Frontend
 Transport; Fri, 21 Apr 2023 03:49:41 -0700
From:   Dima Chumak <dchumak@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Dima Chumak <dchumak@nvidia.com>
Subject: [PATCH net-next V2 4/4] net/mlx5: Implement devlink port function cmds to control ipsec_packet
Date:   Fri, 21 Apr 2023 13:49:01 +0300
Message-ID: <20230421104901.897946-5-dchumak@nvidia.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421104901.897946-1-dchumak@nvidia.com>
References: <20230421104901.897946-1-dchumak@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|DM4PR12MB6614:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c8ed03b-0138-4133-3bfd-08db42562158
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yLfKZUXeY/G7TiP/IJQc6qGWM3IIyjB769vlADDJKmhDxXnxbW8Twm4yrtTOnX6EmGGD/EuFeUicXrnsq3ZDwHMcnfWbmF7BCkSOq1b8y8t58D3DQFtrcuAmol5o/aMlbrhBN4PGKcTwtCZu70V1faRBRHJckKfFQewpsH95Litxrju/xMdfNrCE25O8UKB5qN/wFTuePJ24lDJZcvrSWwgttkLHkyVbes2qN7RKOCB/TFpXZu5BcUid2kj+676ZuGZ2tu/gst1uZYfZm859g1ru02++9O0Q/LZYT2HtGxdNhs2cTPF10h4BwmaYoB0PO3C6VQqAkIxk8vDfBHE/INm0Op7qNJ/F9T4dSc6AXJV7rrS8mvmv3E9tCmzgfgiXJRWURpGkYf0KnHFk6gicxSTP1APgWysrPoOo+ZQ8Y2zgR4ia2pZDYszBkub9ZQ9ru9sFfCHSdknm3EstSV+P9DU9jglMrT95SagyOWhFxOFcjqwOZx4K7SMjU8/3ry2e4oLojGXu1NRbgeLTk9ZfSDKJCY2ygvTtLdiHt/qiIXI3V9r04Vf+avQvc8zSHQEUQPfSaAUZ0rv5HzFt+EZ3kEnHPoxByHtvS1Xq2fRue4vnLTpEKXKbnFC+EGuiL03Nq2iIrEmfg/z/4oXStjc1AICdo6qz5h8fA0OB7XRVTXTnTxvAKWACSSDNEMDC0Oj/ytfpjkO1rWflILOf9UnHndlUSiSFRVYSZaE3SNyLha4MwlATYxwQz/imzqWRM65BvVkw0EVu5Q1rc66H8cJJEFeFch1OfRGpdDQ60E2k68A=
X-Forefront-Antispam-Report: CIP:216.228.118.233;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(396003)(346002)(376002)(451199021)(46966006)(36840700001)(40470700004)(82310400005)(1076003)(26005)(40460700003)(40480700001)(82740400003)(186003)(110136005)(86362001)(70586007)(41300700001)(6666004)(7696005)(70206006)(36756003)(83380400001)(478600001)(54906003)(316002)(4326008)(7636003)(356005)(107886003)(36860700001)(8676002)(8936002)(2906002)(30864003)(336012)(5660300002)(2616005)(34020700004)(426003)(47076005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2023 10:49:49.5233
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c8ed03b-0138-4133-3bfd-08db42562158
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.233];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6614
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
---
v1 - >v2:
 - Fix build when CONFIG_XFRM is not set.
 - Perform additional capability checks to test if ipsec_packet offload
   is supported by the HW
---
 .../ethernet/mellanox/mlx5/switchdev.rst      |   8 ++
 .../net/ethernet/mellanox/mlx5/core/devlink.c |   2 +
 .../ethernet/mellanox/mlx5/core/esw/ipsec.c   |  71 +++++++++++-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |  11 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  10 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 103 ++++++++++++++++++
 6 files changed, 195 insertions(+), 10 deletions(-)

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
index e1c7cd11444f..2c9ecbcb7687 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -327,6 +327,8 @@ static const struct devlink_ops mlx5_devlink_ops = {
 #ifdef CONFIG_XFRM
 	.port_fn_ipsec_crypto_get = mlx5_devlink_port_fn_ipsec_crypto_get,
 	.port_fn_ipsec_crypto_set = mlx5_devlink_port_fn_ipsec_crypto_set,
+	.port_fn_ipsec_packet_get = mlx5_devlink_port_fn_ipsec_packet_get,
+	.port_fn_ipsec_packet_set = mlx5_devlink_port_fn_ipsec_packet_set,
 #endif /* CONFIG_XFRM */
 #endif /* CONFIG_MLX5_ESWITCH */
 #ifdef CONFIG_MLX5_SF_MANAGER
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
index 5da5fc17cafb..d9fa154a2a3d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/ipsec.c
@@ -38,9 +38,11 @@ static int esw_ipsec_vf_query_generic(struct mlx5_core_dev *dev, u16 vport_num,
 
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
@@ -55,6 +57,7 @@ static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vpor
 		return err;
 	if (!ipsec_enabled) {
 		*crypto = false;
+		*packet = false;
 		return 0;
 	}
 
@@ -68,6 +71,7 @@ static int esw_ipsec_vf_query(struct mlx5_core_dev *dev, struct mlx5_vport *vpor
 
 	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
 	*crypto = MLX5_GET(ipsec_cap, hca_cap, ipsec_crypto_offload);
+	*packet = MLX5_GET(ipsec_cap, hca_cap, ipsec_full_offload);
 out:
 	kvfree(query_cap);
 	return err;
@@ -142,6 +146,9 @@ static int esw_ipsec_vf_set_bytype(struct mlx5_core_dev *dev, struct mlx5_vport
 	case MLX5_ESW_VPORT_IPSEC_CRYPTO_OFFLOAD:
 		MLX5_SET(ipsec_cap, cap, ipsec_crypto_offload, enable);
 		break;
+	case MLX5_ESW_VPORT_IPSEC_PACKET_OFFLOAD:
+		MLX5_SET(ipsec_cap, cap, ipsec_full_offload, enable);
+		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto out;
@@ -199,6 +206,7 @@ static int esw_ipsec_vf_offload_set_bytype(struct mlx5_eswitch *esw, struct mlx5
 					   bool enable, enum esw_vport_ipsec_offload type)
 {
 	struct mlx5_core_dev *dev = esw->dev;
+	bool crypto_enabled, packet_enabled;
 	int err = 0;
 
 	if (vport->index == MLX5_VPORT_PF)
@@ -236,16 +244,28 @@ static int esw_ipsec_vf_offload_set_bytype(struct mlx5_eswitch *esw, struct mlx5
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
@@ -316,9 +336,41 @@ bool mlx5_esw_ipsec_vf_crypto_offload_supported(struct mlx5_core_dev *dev, u16 v
 	return false;
 }
 
-int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport, bool *crypto)
+bool mlx5_esw_ipsec_vf_packet_offload_supported(struct mlx5_core_dev *dev, u16 vport_num)
 {
-	return esw_ipsec_vf_query(dev, vport, crypto);
+	int query_sz = MLX5_ST_SZ_BYTES(query_hca_cap_out);
+	void *hca_cap = NULL, *query_cap = NULL;
+	int err;
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(dev))
+		return false;
+
+	if (!esw_ipsec_offload_supported(dev, vport_num))
+		return false;
+
+	query_cap = kvzalloc(query_sz, GFP_KERNEL);
+	if (!query_cap)
+		return false;
+
+	err = mlx5_vport_get_other_func_cap(dev, vport_num, query_cap, MLX5_CAP_FLOW_TABLE);
+	if (err)
+		goto notsupported;
+	hca_cap = MLX5_ADDR_OF(query_hca_cap_out, query_cap, capability);
+	if (!MLX5_GET(flow_table_nic_cap, hca_cap, flow_table_properties_nic_receive.decap))
+		goto notsupported;
+
+	kvfree(query_cap);
+	return true;
+
+notsupported:
+	kvfree(query_cap);
+	return false;
+}
+
+int mlx5_esw_ipsec_vf_offload_get(struct mlx5_core_dev *dev, struct mlx5_vport *vport,
+				  bool *crypto, bool *packet)
+{
+	return esw_ipsec_vf_query(dev, vport, crypto, packet);
 }
 
 int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
@@ -327,3 +379,10 @@ int mlx5_esw_ipsec_vf_crypto_offload_set(struct mlx5_eswitch *esw, struct mlx5_v
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
index e3b492a84f1b..9d2ccb748d3b 100644
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
index d1f469ec284b..59cd0254498b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -158,6 +158,7 @@ struct mlx5_vport_info {
 	u8                      roce_enabled: 1;
 	u8                      mig_enabled: 1;
 	u8                      ipsec_crypto_enabled: 1;
+	u8                      ipsec_packet_enabled: 1;
 };
 
 /* Vport context events */
@@ -527,6 +528,10 @@ int mlx5_devlink_port_fn_ipsec_crypto_get(struct devlink_port *port, bool *is_en
 					  struct netlink_ext_ack *extack);
 int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable,
 					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_packet_get(struct devlink_port *port, bool *is_enabled,
+					  struct netlink_ext_ack *extack);
+int mlx5_devlink_port_fn_ipsec_packet_set(struct devlink_port *port, bool enable,
+					  struct netlink_ext_ack *extack);
 #endif /* CONFIG_XFRM */
 void *mlx5_eswitch_get_uplink_priv(struct mlx5_eswitch *esw, u8 rep_type);
 
@@ -664,10 +669,13 @@ void mlx5_eswitch_disable_pf_vf_vports(struct mlx5_eswitch *esw);
 
 bool mlx5_esw_ipsec_vf_offload_supported(struct mlx5_core_dev *dev);
 bool mlx5_esw_ipsec_vf_crypto_offload_supported(struct mlx5_core_dev *dev, u16 vport_num);
+bool mlx5_esw_ipsec_vf_packet_offload_supported(struct mlx5_core_dev *dev, u16 vport_num);
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
index d0cb80714f00..4b82cd2dc427 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -4308,4 +4308,107 @@ int mlx5_devlink_port_fn_ipsec_crypto_set(struct devlink_port *port, bool enable
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
+	vport = mlx5_devlink_port_fn_get_vport(port, esw);
+	if (IS_ERR(vport)) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid port");
+		return PTR_ERR(vport);
+	}
+
+	if (!mlx5_esw_ipsec_vf_offload_supported(esw->dev)) {
+		NL_SET_ERR_MSG_MOD(extack, "Device doesn't support ipsec_packet");
+		return err;
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
+
+	vport_num = mlx5_esw_devlink_port_index_to_vport_num(port->index);
+	if (!mlx5_esw_ipsec_vf_packet_offload_supported(esw->dev, vport_num)) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Device doesn't support ipsec_packet or capability is blocked");
+		return err;
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
 #endif /* CONFIG_XFRM */
-- 
2.40.0

