Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E823644C0B
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:52:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiLFSwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiLFSwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:52:07 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2059.outbound.protection.outlook.com [40.107.237.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433BA3D92B
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 10:52:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bmsma7UA4654NgJBqa8nzCcRtm6lqzNpkMqcx2jD7EUfwViab8EQzcDLb1AOw0avVX5K93DxSO3AKYN/dMo83uLtm5CPsRtFgDPkKI4PaB9Bx6QpS1kwV3AjMzgjc0MQX8K5UZfYd+AuuHZRaDtP0oOkaQgZAT5qMEoVVAgEUgQ/lFf16QZHLxu8fwwGlNrW9/44gQmHPkTDRP9cK0BTrBQX11HzaRvNCsWjxFo0bi16oE2pQriuNZeRE5Gk3LNw+cO8nxed4yv03FyF7dQb+81hhQe3hyzpZcr+pqrc88tRzDCyTDjhYv62Xho4pUCZXcdXAjFxbOuhtw+IMvdeNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=H958ZYs1XWLKJ91+gCrhU8WvFWV/a7vrimFZ7q/JaK/A7y7efg4Gn3Ds5rTBI5Hx78kwiHLsAVX3faRbx/MaZrhMcnR8ezEWhVICV6LqOxWMnTJRO34QoI3xHW4+OkCohvSVF9kDm1XhG1fWOlE6DiotnrTZ1Sg+CIUOPxAvWhTLEiUpP3b+1MCKk1KZG5fk7w6dw6mNYxMCUgVNmbr4nsQZJBRec78j4Qr/32PS1bbS42TnOaPck/dbZPyJ1RfTvJaR0wbUk/YG2DyYpFsnZi677avBKiTfMI3qWYoetWI4BYHaLsqvcRy4X6OBSBAaWQUHiW96oBz44ZWZFg5UKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=qmj27x2SvPxQnTPcgBsoFxd8g2Sn45z7OA7zjsH+1tEKnNXG5AIsPXFuhAA0hrZpjUutAyNTCXYmOw3dVyQ22yNuUeybJgX+e79wUxt57OCgJK2vhTbFcIPhR3+YF6+fcqCVYX+AO7F6jVFyXTuHKS1E7+C5ey4e8Tqiv1e1KF1keLKoak2KkVhJoE932APYQF5CLxxqwg/pyrv0x4bOIkQTRmNj9qQVhlhskXLJXBA/OYeNnz3RgESStaTMe90OSFWb4VDpLXWWIaxxUjLAkJq1MyVNNVIrp5yDNfr+HMNAvQuQ7HZnUDh+bSTQxmAAyXyhut2J0n3vKkP5S9oovw==
Received: from BN7PR02CA0016.namprd02.prod.outlook.com (2603:10b6:408:20::29)
 by DM4PR12MB6136.namprd12.prod.outlook.com (2603:10b6:8:a9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 18:52:02 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:20:cafe::d5) by BN7PR02CA0016.outlook.office365.com
 (2603:10b6:408:20::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Tue, 6 Dec 2022 18:52:02 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 18:52:02 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 10:51:46 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Tue, 6 Dec 2022 10:51:43 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V4 5/8] net/mlx5: Add generic getters for other functions caps
Date:   Tue, 6 Dec 2022 20:51:16 +0200
Message-ID: <20221206185119.380138-6-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT064:EE_|DM4PR12MB6136:EE_
X-MS-Office365-Filtering-Correlation-Id: 2cf46d94-948d-484f-9bec-08dad7baf662
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/Z3nyRYlqxFTVqNsS9t/poRJ0Laz8CZYLcMX9oO2SHPmcJkro9NdtL/D5jYtQY5z3EZN/yXbXHlq65CioGHbY2wJeWI/J8QrX/B98MbDKV3sK5ivCPVcIuF03tRQAXrqQCNOLbw+MQO5WYfx5scvnQPrvJR4IhHOkZMnf0qEHFy8UrIctsYrva9/t1fyDHlW1ksFKUSPE3x0JILidGxVNPxBeS3UHt0CYdPgYb4EOV3GFf34/L9Q2tQiEMnHKSVaYoYWpSPWaUMzxpdYa2K7kaojCDYwA/aFpold00cZ44gmoEJQQXxgglreK/B3PSmAnBPtK25qo7p4hebxeZcW/xfVqVImCrEhk1h86+4frs1T9+DMuOxoKmGX2wBsWOpcrjcyT2ekaLERxmLLOxj+574M9lby0IewotJDUVQ9yASgH0d4RvZbenMdPQDbbrwV8XK2ddXmzDfSVDFlE7DISFssZX46BKTb20vf3/qz/oj/TAlly92V48J6VNcvY/H0RrpjXJs3ZWt4+W+QZuGNhEu5SqYj9PH9dS1DRbBgCNwNBQj+wvya4mDho73DL3tD6B2TuOW+yHFGNRXTYi9E86PlwPdajEBQ2fjXtXBEqmmPCmji9UT6jcovJ2e6ZWIVNk6ZdpOUCxkMsZmt8z0WJQsmOcSIeylwaPRyeLMEwxL6CI8b/RjASG6XCGPalw3nPJ4NwWHuZs3OKDJLV/z3pReAY+pbQIkj4a7Z9j5jBo=
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(396003)(136003)(346002)(451199015)(36840700001)(46966006)(40470700004)(36756003)(2616005)(7636003)(36860700001)(336012)(82740400003)(6666004)(356005)(478600001)(54906003)(110136005)(40480700001)(1076003)(83380400001)(2906002)(26005)(86362001)(107886003)(82310400005)(40460700003)(316002)(5660300002)(8676002)(4326008)(8936002)(47076005)(16526019)(426003)(70206006)(70586007)(186003)(41300700001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:52:02.1861
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2cf46d94-948d-484f-9bec-08dad7baf662
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6136
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

