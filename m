Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D84E64021B
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbiLBIa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiLBI3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:29:16 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2070.outbound.protection.outlook.com [40.107.101.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C714A7BC30
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:26:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Eb0frO0HhBHOqeghRZb6Y0xgrDy4IfVCDkVp33muHZ1dlPJ1fOLzM4tX8QApH5+on24/q7ok2Pa03mMYoYGl6isNgIxs9W2fbmtpnhHTAZrRkYg2lyP4j0YyAZcWvU5x9tu6zlxoSPzIC/yN+22NtGFmagcexg2NfqwjR1BZgAqgp5buUk3GiuVEl4php/BQKyc40gFVCiH5kt2uvpVpchqLzg1zMZIOg4x+ceqPaEvYL9ttgk+MdLCAew/O+I9pHZZ3l+T/ACgdZMZzOM9Bzbz15FMcTqfAOxYnFsI2my13HJD3dQEqNFQRLg5GYn0pH1rGz/6PHKwsREJIP+2qdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=DU7pwmIkYMUT0RfPtBKOE4x7DhabbTkf8QglJ+SvoGFAxzwZHqdjXEpzEZuLIY/KvPMHhnCWkHY91OHOza+KG/+Oj8UhhC21x1ct/v3Vm8ZCOHJ20UYJDVzJhtDK/6eLMw5ksl6JrvVMdx9QPE69SiFOLaC8WzAw65LJApA3wFkdKxth8PFLOoAtnycTKS39gSAiPj6oGq0WviQv+rnWS57d0BcTtE2zvWurJ3ElKV7z0Bg7ZbPTqW+T44fnOe6vFkGBm/jwn48KrDq5gDojBtqBd07pO6UYIPu9c+4ojOCAQJ0yBHvFwZ35f4f2SWRgxYvoxjQ/jf9+kcs9bETIsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=Cohp42hgKFB2ktw1KV+MTsCcJt+jONQqO+ZkXNAbk11NshOZXFzGYRwJtmy02WffJUZlqGx3MQb7Bq0rkqwk7fvddwp1B11KjIMaL/bOLIUdBnd48WCVnni5fOjXW9EJky29CCQL5LstprSHp4//nRqNzGcvZb/yJJcNH6g1N8lNIcHLbaFcQ/8p0Mx87GyWom6qpOMflXspKXvHolZBU3N6hgngt8Zll6d/DHlOk+FmeVu/uA02gsqujMXHhjuwsQiP7CIHOU+/Xlzq2EtM4SpkzIrPtKfR1wpiFYBeniIkj53rCnm8cQwyCq7SEqAWuAciokbJCnZmFjnuNqlQEg==
Received: from DS7PR03CA0296.namprd03.prod.outlook.com (2603:10b6:5:3ad::31)
 by PH8PR12MB6987.namprd12.prod.outlook.com (2603:10b6:510:1be::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Fri, 2 Dec
 2022 08:26:56 +0000
Received: from DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::3b) by DS7PR03CA0296.outlook.office365.com
 (2603:10b6:5:3ad::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Fri, 2 Dec 2022 08:26:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT096.mail.protection.outlook.com (10.13.173.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10 via Frontend Transport; Fri, 2 Dec 2022 08:26:56 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Fri, 2 Dec 2022
 00:26:48 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Fri, 2 Dec 2022 00:26:45 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next V2 5/8] net/mlx5: Add generic getters for other functions caps
Date:   Fri, 2 Dec 2022 10:26:19 +0200
Message-ID: <20221202082622.57765-6-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT096:EE_|PH8PR12MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 3cc9b776-37d7-47ee-db7c-08dad43ef948
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rq6RTaip088mW5MPot1NRk2oDPZi9G/amBZJScBi/Ec4Me7LsOab1iH9+5SIHvsoW0cc/DsgsmTEnIbj4N11sxijOCnn0peByr0J8BAemIuc04vJK38WBmzt8u0sZFHX6grNsGZKcmRuCRS5wyWXxU3xYOCvfXfQ/1RE+oXjJwSnwbiqadlo2L4OqdJkMusk5dLPBSZgksS4uXC8j1axkTJqBtz7HDt97frRl+8Rn5AxtZLmaGDKCih3dBEiS113eMfF4jq+CgQHQXpwMUj5MRBXvG6g8DM1Am/G+Odj8W/+M20lA+JAQrA1WUx8fvY5hiFVmTfEMXEKtvyPszffh/3xR3dLT11Qrnmq3XT9/WV5Q72j8YCS61dm1Cvs30H+PbL3YZuM2vRItLOq+/eFSj/T5umZBR4x7NMfS51CY2Opl9lH9y+mLJN10UVv/HRQodfAQJuhRfwLrbori9hth4/ZOELecXFuAhwIHgLJmviaOK3hupH7pOOPWjWMFTDVtt3Mgm41A4IRKCyp9HyA++IRfKk9TwQU+3a84IKYorCs2TXpX6YIm1z7m0fr3ygL6XtpheeqG1sf0RCTtOLcABXJRUrNpq/NEba+l7dlWvBIAjLfAPZiOGTjoJIErO8+cb7toTL2LXAknSwubfc0snU5g6O0d/LJbo9SXRpJ7yY/5fShZ0JRfYZ5heDb768US8FepyDdKyHJ5msK4GGDBazPFKFj3x/9OlxPUXWjwFM=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(39860400002)(376002)(451199015)(46966006)(36840700001)(40470700004)(86362001)(36756003)(40480700001)(7636003)(478600001)(6666004)(2906002)(107886003)(26005)(82310400005)(41300700001)(110136005)(4326008)(5660300002)(70206006)(54906003)(356005)(316002)(8936002)(8676002)(70586007)(47076005)(336012)(82740400003)(36860700001)(40460700003)(1076003)(2616005)(186003)(16526019)(83380400001)(426003)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 08:26:56.0146
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cc9b776-37d7-47ee-db7c-08dad43ef948
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6987
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Downstream patch requires to get other function GENERAL2 caps while
mlx5_vport_get_other_func_cap() gets only one type of caps (general).
Rename it to represent this and introduce a generic implementation
of mlx5_vport_get_other_func_cap().

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Acked-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c          | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 ++++--
 include/linux/mlx5/vport.h                                 | 2 ++
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9b6fbb19c22a..33dffcb8bdd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3889,7 +3889,7 @@ static int mlx5_esw_query_vport_vhca_id(struct mlx5_eswitch *esw, u16 vport_num,
 	if (!query_ctx)
 		return -ENOMEM;
 
-	err = mlx5_vport_get_other_func_cap(esw->dev, vport_num, query_ctx);
+	err = mlx5_vport_get_other_func_general_cap(esw->dev, vport_num, query_ctx);
 	if (err)
 		goto out_free;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index a806e3de7b7c..09473983778f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -324,7 +324,8 @@ void mlx5_unload_one_devl_locked(struct mlx5_core_dev *dev);
 int mlx5_load_one(struct mlx5_core_dev *dev, bool recovery);
 int mlx5_load_one_devl_locked(struct mlx5_core_dev *dev, bool recovery);
 
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out);
+#define mlx5_vport_get_other_func_general_cap(dev, fid, out)		\
+	mlx5_vport_get_other_func_cap(dev, fid, out, MLX5_CAP_GENERAL)
 
 void mlx5_events_work_enqueue(struct mlx5_core_dev *dev, struct work_struct *work);
 static inline u32 mlx5_sriov_get_vf_total_msix(struct pci_dev *pdev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index 662f1d55e30e..6bde18bcd42f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -4,6 +4,7 @@
 #include <linux/interrupt.h>
 #include <linux/notifier.h>
 #include <linux/mlx5/driver.h>
+#include <linux/mlx5/vport.h>
 #include "mlx5_core.h"
 #include "mlx5_irq.h"
 #include "pci_irq.h"
@@ -101,7 +102,7 @@ int mlx5_set_msix_vec_count(struct mlx5_core_dev *dev, int function_id,
 		goto out;
 	}
 
-	ret = mlx5_vport_get_other_func_cap(dev, function_id, query_cap);
+	ret = mlx5_vport_get_other_func_general_cap(dev, function_id, query_cap);
 	if (ret)
 		goto out;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index d5c317325030..7eca7582f243 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -1160,14 +1160,16 @@ u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev)
 }
 EXPORT_SYMBOL_GPL(mlx5_query_nic_system_image_guid);
 
-int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out)
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+				  u16 opmod)
 {
-	u16 opmod = (MLX5_CAP_GENERAL << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
 	u8 in[MLX5_ST_SZ_BYTES(query_hca_cap_in)] = {};
 
+	opmod = (opmod << 1) | (HCA_CAP_OPMOD_GET_MAX & 0x01);
 	MLX5_SET(query_hca_cap_in, in, opcode, MLX5_CMD_OP_QUERY_HCA_CAP);
 	MLX5_SET(query_hca_cap_in, in, op_mod, opmod);
 	MLX5_SET(query_hca_cap_in, in, function_id, function_id);
 	MLX5_SET(query_hca_cap_in, in, other_function, true);
 	return mlx5_cmd_exec_inout(dev, query_hca_cap, in, out);
 }
+EXPORT_SYMBOL_GPL(mlx5_vport_get_other_func_cap);
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index aad53cb72f17..7f31432f44c2 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -132,4 +132,6 @@ int mlx5_nic_vport_affiliate_multiport(struct mlx5_core_dev *master_mdev,
 int mlx5_nic_vport_unaffiliate_multiport(struct mlx5_core_dev *port_mdev);
 
 u64 mlx5_query_nic_system_image_guid(struct mlx5_core_dev *mdev);
+int mlx5_vport_get_other_func_cap(struct mlx5_core_dev *dev, u16 function_id, void *out,
+				  u16 opmod);
 #endif /* __MLX5_VPORT_H__ */
-- 
2.38.1

