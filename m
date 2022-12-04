Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186FB641D65
	for <lists+netdev@lfdr.de>; Sun,  4 Dec 2022 15:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiLDORc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Dec 2022 09:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiLDORN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Dec 2022 09:17:13 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8872615A3F
        for <netdev@vger.kernel.org>; Sun,  4 Dec 2022 06:17:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzU6efulUaVESeKoEQXDQmggarhep1ec444CKtMBbR1Hf0bcJ9gnM2kFrOK91EaIzHGlQ3qDrdsy+W09tDx4by33mbI0AIKA+W1C11tuPdpa71fKsAP+OkpgVQwCks0HLGbpSySycnj17rWqAqCCK9LLbsECW9IzZvmS5XQMMdHZSNWAEIfMWohhPFGLm8Jf1WUe2s4okSw31AJatMHeJk4u/axC+fcxJ6gYcANu2So40Y4UyP0SdtAfO85KAB3vXxIsl6y3Y85y4fUlb9QTRBXvhD5vqRYTuXqORpLZ5b9/FgbanM/HfOe56YYLxLD2j3DMjTgVk4uOUG7hfbKO+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=Cl0tfMgCjk4SII78T0mhK23fEaqkXEhEDkXu/RabIFCLp+HF/O9yq70WhD01ox+sxAKx7Pc1SaFjDks9lajiOLkf0UBdbANvo5aFf1+PyKVsTLCTJjn8zj/4YHa1FfkWdkz0cYjQCPze2uCXDQDX5S6I6k97+LHzDjYBZqQurgm1Yt1T/2KuxtgSkyxxcPXdyKj68DJMwMx8Z5ib2Tcm6z5M5Ig9lLhpf7fijt6Spkp/cJEo/a9TObbW9RcCBFgCguvrAtiHm2nz1Thuzt2XO1wOHthb9/P10id8TSavEXOXKjUuC8tXlbft2o/idc5Mu1knzKcge8LZj9nvihGOgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qXr1jEd66S007qgvs1TkJOlAZxpix6qcG4dezthwF4E=;
 b=NpedefzA+vLlVkLeuxQtuxiPbW7HiZ75TVEUQcnk9KSLTsK6uoQRIQZPdnPHWpJR2CAgDCQEVsOsgdBKfPwOMhxnLQx67p4an3dn7nxqUaUY3mKG+gemNUOSsCWBPQXNxHMVA3yLs7I7nFXBnFmGw0jmHY4YrGuI2s+cxvFfAsjHPeJ2emTrqkYauwMoVTmTCWJo3xcWKSzcBGi+85shZ4TS2GVY9d4/ug0T7ht5LCg/w0pQMKRklIluNPHG1R1dPxTeRS2eckmxssJ0BD/twE3rYvlVXb3IBKXXg1brM5ua/V+snw6bMJqVjLXh823irxVlf9ZgEKUCF+1zdiSW2Q==
Received: from MW4PR04CA0381.namprd04.prod.outlook.com (2603:10b6:303:81::26)
 by CY8PR12MB7266.namprd12.prod.outlook.com (2603:10b6:930:56::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Sun, 4 Dec
 2022 14:17:11 +0000
Received: from CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::e7) by MW4PR04CA0381.outlook.office365.com
 (2603:10b6:303:81::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13 via Frontend
 Transport; Sun, 4 Dec 2022 14:17:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT013.mail.protection.outlook.com (10.13.174.227) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.13 via Frontend Transport; Sun, 4 Dec 2022 14:17:11 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Sun, 4 Dec 2022
 06:16:57 -0800
Received: from nps-server-23.mtl.labs.mlnx (10.126.231.35) by
 rnnvmail201.nvidia.com (10.129.68.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.36; Sun, 4 Dec 2022 06:16:55 -0800
From:   Shay Drory <shayd@nvidia.com>
To:     <netdev@vger.kernel.org>, <kuba@kernel.org>, <davem@davemloft.net>
CC:     <danielj@nvidia.com>, <yishaih@nvidia.com>, <jiri@nvidia.com>,
        <saeedm@nvidia.com>, <parav@nvidia.com>,
        Shay Drory <shayd@nvidia.com>
Subject: [PATCH net-next V3 5/8] net/mlx5: Add generic getters for other functions caps
Date:   Sun, 4 Dec 2022 16:16:29 +0200
Message-ID: <20221204141632.201932-6-shayd@nvidia.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT013:EE_|CY8PR12MB7266:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b0fc596-7f0a-497d-2b50-08dad6023c0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EhSO5SHcQTVaFujlgGvV8l5IypuQ2rbgW22qnxD6iO47udYO9Cw9HxJ7N+zsdy5yVY0Fi6e9F+/7ffRXnC9j9+RF6OHQCWG922/nKMvGeXTF7BUGiUvxKEWrCyBGyOX/tfjqRDFzk1+g8ii3t82jnhc7ZGmySNlygqY9qJE7tfzrQ8SfPGx/IWhcApGUiBqkteaakuCYwFwYQciv7s/bYQxoKWOlbn1vNmAGFcGadKpGFn7JKKCG0AoxsaVqxPNWT3+cf5N7LIctnHJ3ix+86M4cjravK6IQo4Ko/JZKBmZjXpjOe92At+6ELvNmpNe/L1xz3wgeWo+HKEpNTXuwlU8e+ammPUp8xd4tg6WgqeUA5DIdvmGc3kYM888tpUVBdpLevt4Jfum66ADPcgiET5ZDq6P3iXFblOveMPHd0t3QuLcfkWBKqZOthWDGpo9cwag0cZld3CEmqCK83aD9QXTBLmnL/B8rdGh7oLLPXxrODWETzh8pXuLTnRrKCmH/RbquvZIIn9ETFmnCyNN0qwUb9vm03CqtCOXjzB/SOma0wz+rd3qvNIoRGqDG5UWwkK0QjLNlsQi2L2WwBJkBlj3nT0zlcmPBvpwaPctUhRFWECXM3YQciMZ4wb4EFgBS5pQSnTNEMknT6rY+/mXN68IsREYXZSB+oTlyBQVjrWarffp19IJPkaht4QFvuEKeG153i3CLz4frc273NLNdep0Ke7F9nsDfC+AH/7FrAxE=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(40470700004)(36840700001)(46966006)(426003)(47076005)(40460700003)(86362001)(478600001)(7636003)(36756003)(40480700001)(356005)(82740400003)(82310400005)(36860700001)(336012)(2616005)(16526019)(1076003)(83380400001)(186003)(8936002)(41300700001)(5660300002)(4326008)(8676002)(26005)(70586007)(6666004)(107886003)(70206006)(110136005)(316002)(54906003)(2906002)(41533002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2022 14:17:11.0427
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b0fc596-7f0a-497d-2b50-08dad6023c0b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7266
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

