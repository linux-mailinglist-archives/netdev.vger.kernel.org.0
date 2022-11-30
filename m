Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E527E63D509
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 12:54:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbiK3LyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 06:54:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235255AbiK3LxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 06:53:21 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2050.outbound.protection.outlook.com [40.107.96.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59674442DF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 03:53:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yy7w12bDQ8Hbgi4L8s2SpbnhHEHWSlY8ERQg8Y/xnbCGmYIexCiiXiobVMIfdSYuaCPqGd8JZEFeNua+WSvESIGC7hRfB8ziPkz23KZLJLRnYitSoDgyO95uxshv175HOboHYx2qdtcd1f9X3w5/2GTsriMue14rIfkXUXQrgX2mB+1ULgI8oswZhbIzZd7nsGGfFcW7woyZ4CYHpHxRnPiYzKaZPQRJaVFchZx+0u9ZtBmC30Icepf4yLI7m10SY6IIexM7XKf/YFRefHuXzNAEQA7XM44bzkwVW+zbCdSJ91946mIZq5I59qbCFk3lW7T6vyZ5pmpgKQsin9+6Tw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCwTM8oskniKNVR3KEcszO+njYiz0yJPt0QZhnV1sWA=;
 b=QivaArRpUV5VpTKkhnOqCXnAgRVgIaVc8QOQeywh13id0tIT0HxVSJ1WfwtO/0QtNVip/UDdZq2IMQN8PZLymY77Ikkg3YssyGYth7dJJZ8SKumhto3feSVk4CZVwQhOW0RusVGU7fwY5rxv0/Z9CGTmarUG0CGVP9ad+QTWdKfpf123py6a3hSZuqnztm2LzUGZJa1VGZMP2FN6VMbhmeLZqlpFkoMJod6u2Onj1EIo1t2imdbACLRNaPGQF9EzP0Bu1qTlniTBJmJswPahop4UfwG/gmdhIjNeLmzYBQJe+pikg6EaSEs+3/4DSjhM558bZ4P2CxoIVDzu9JmlGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCwTM8oskniKNVR3KEcszO+njYiz0yJPt0QZhnV1sWA=;
 b=AofmCNDMvXojHtP5eHXBxodDbYtLAXmAfMwren070lJGd/pmx+J775TiuZPWOqQg4gIzTqYmZOQZ4ERIanwbdmCzdrMuUbvrN/2Cly6SSQXw7KRJn4lT8HGcwDRrKEbgxJlMDQ11V4oZvQmCtJjWEPOtctx6xCzVXlgl7ycxc1X4kSxoAJr90QbkonuoJQ1MrDmUA4kQ9oEbG5A5xF3eI2GjpnxDnwkdnOnSqSF+y1YyywYl8o9gQVEsAeYAypePxS7R9Wm2guOEx9+wtmpmjjVVYaZp1AcG64N/2MDlH0rBPnj2XmguT0Tk1orLsiOz312+P9JeK1QFF+Yc8dE1zQ==
Received: from BN9PR03CA0436.namprd03.prod.outlook.com (2603:10b6:408:113::21)
 by PH7PR12MB7380.namprd12.prod.outlook.com (2603:10b6:510:20f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 11:53:09 +0000
Received: from BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:113:cafe::35) by BN9PR03CA0436.outlook.office365.com
 (2603:10b6:408:113::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23 via Frontend
 Transport; Wed, 30 Nov 2022 11:53:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT085.mail.protection.outlook.com (10.13.176.100) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.17 via Frontend Transport; Wed, 30 Nov 2022 11:53:08 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 30 Nov
 2022 03:52:53 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Wed, 30 Nov 2022 03:52:49 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>
Subject: [PATCH net-next 5/8] net/mlx5: Add generic getters for other functions caps
Date:   Wed, 30 Nov 2022 13:52:14 +0200
Message-ID: <20221130115217.7171-6-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT085:EE_|PH7PR12MB7380:EE_
X-MS-Office365-Filtering-Correlation-Id: ef387fa4-4687-4f95-dd7c-08dad2c97349
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yuAGMRS35CrESRoIJX1MvuSK6oIX9sVRUJlre2joM3ievAqxyYlV69zsTA7v13TyvizpbgLdVrjdqY6AF7eF1FEbEot591lsOckmn8VNPUZRgCoHBaR9fcBNQgus2OVLL8hCfH5OPsli1dn4XlUm7v4UFYNZ4cNsVujCwg5tl0G19mS4mdnAI7HZFiL1qkA0lHn7YzM02gSMcbcVOJBrXCTlxkyrpNFqKdL7OYJgZQD7ir/gI3qp0x1Gzqp+xo/AYN/RMkdM2EelStuu+AkCo8zc2qbpuqSytv6K0F5ucpJ92iIyacWBPCnnwKHtWZUIjfwDWTQqDzj+fG1I2DSKJsPravIARot7VQanOizwnC7CBi+tYumAnVk+QP8Ct3LWWbmM1DB14VaIgi9GU3xO4GCavUv1yZNkfSqaOsafhSBy8XIvOJf71gUVmkT601sThY9eoiS4bQV613kU3KYR7RlZD8R7htoJ/+h1vCDG+Xj6mvF7kQ8omnLnZxZo1f7t5dcDSlTrWyBckNgq86wxelfCtD5lHMpNhW0K+KCOXeUcQFP7L4giQi2DUOprSbvzHT4bbixW9+t5pem7NcaKbyi3HXiAJtsduR87V9z9CqAgOxlvKgteDwn9/wvjYEtoK3ELjAiKtClaQHHq8sGYAQX9mRU1xcWKIcaqbBWp9hbl33VxbuzMy8TcmNvEnaSfmNBbm0PCKgKeQdwB2gYgUbe8+mCIlW1bfw9tNKL356o=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(39860400002)(346002)(451199015)(46966006)(36840700001)(40470700004)(5660300002)(8936002)(40460700003)(83380400001)(26005)(41300700001)(2906002)(4326008)(8676002)(70586007)(478600001)(54906003)(316002)(82310400005)(36756003)(6666004)(107886003)(86362001)(186003)(16526019)(47076005)(40480700001)(7636003)(336012)(82740400003)(356005)(110136005)(1076003)(2616005)(426003)(70206006)(36860700001)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2022 11:53:08.8639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ef387fa4-4687-4f95-dd7c-08dad2c97349
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT085.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7380
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
Ack-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h        | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c          | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c            | 6 ++++--
 include/linux/mlx5/vport.h                                 | 2 ++
 5 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 728ca9f2bb9d..40af64d31f65 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3879,7 +3879,7 @@ static int mlx5_esw_query_vport_vhca_id(struct mlx5_eswitch *esw, u16 vport_num,
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

