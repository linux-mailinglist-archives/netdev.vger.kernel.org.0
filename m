Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C486D6CD9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbjDDTCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236225AbjDDTCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:02:35 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9065599;
        Tue,  4 Apr 2023 12:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fsF6S5UJ3ctbs6FShFdnYu5u4OzBOIsUjQPezZM0BytYdM/prtPy1+Mav1zHrF+uuEhKwhizkUZm8DIBkxxJbxHh5hkA6eZzBoPl5JubSUe+afiTjuAVGeQAsLK+kaCE07RZaQqJkbdyVrAVW/N2CfCe33hAG1JctlU5G/qPETqeYdDilBg/DRPs5BBLGZuJscptQ/lGbLKZyELnOLRVrHBm3MrNw2JC+2UjP0FpBajzRf6ZaC/onxrtkZVkFNfq1/+0EAbtgJ7wVWVjzF1P8vl++uKHl9HzNFL9HdbMvIxKwUmOqhTBS5MMr+eg3SnUhqzcdjlbGMlLCJ5i1ev1eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=buBK3ONmgk2KMlX1eaqT/kfBXxM7z7Q9cf7Vy2Df4RM=;
 b=OjTKEV2SI7bnVmCVK32BNolu+abPbb051+gGMOZRRwCFhBey6m+SGkw/80BeJ/SZ8D/jVigONJ0dAHTbnc++C1f26k5S0vHihSpHMJ/ZdwHHcH9TzZyd35ERFewPSgAqpy9nm9HhIEYC+UugNbymfwGlu+cyzG9cwdJj4gJLh5BxKc1eQXJK0A3hNwZU2q52cfQLFpMpYG43pb+j6w6RQjuO3wL1RlvxCHLUipm+2N3uaFzDezWFAsBlxoOloy4uKhTM31gl+3PmL7ECHn0S6oeQVEihg19qDSOsH5fQNKTQhlfyAtc7u+R0zAi0MUVbBGMVi2m+qO6DxcVaEmnkJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=buBK3ONmgk2KMlX1eaqT/kfBXxM7z7Q9cf7Vy2Df4RM=;
 b=WqSNGT+wout2cBSRfQU6TbZ7viVTEHoQD5r0Nun7sSrikprPc7us8sPFeWxu1KtfDyW/E00x3eX4XyEqu/ev7tJZsNgnfeVgfrZO+x4mEja39kLl0oSYP2dKK+p1tXm7ZgvRja/+jTv/YOpFI2bldgxw9B8mzNr/ioFrDoYmb9A=
Received: from MW2PR16CA0033.namprd16.prod.outlook.com (2603:10b6:907::46) by
 LV2PR12MB5725.namprd12.prod.outlook.com (2603:10b6:408:14c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:02:01 +0000
Received: from CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:0:cafe::1) by MW2PR16CA0033.outlook.office365.com
 (2603:10b6:907::46) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Tue, 4 Apr 2023 19:02:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT065.mail.protection.outlook.com (10.13.174.62) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Tue, 4 Apr 2023 19:02:01 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 14:01:59 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v8 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Tue, 4 Apr 2023 12:01:35 -0700
Message-ID: <20230404190141.57762-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404190141.57762-1-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT065:EE_|LV2PR12MB5725:EE_
X-MS-Office365-Filtering-Correlation-Id: 4001a6c4-c543-49a6-a5d7-08db353f1296
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sAvzB5OndTqhTrtWNlZMaBTXUFaGp9WlLniuuNhT2/xynO4OloeWEessuBDxCyteb72yvuRoUrRbmQVDqyjxnOsn7zvHCvXAK276sO3N7zRYR4XTHswgXjYARapOHjqX0H99hnqOJIENicezWr139Hpc2tR7Z0fDNi4FUN7KOEeT6s8WM13sX/lG43ZINaPmBByUN8BG1aU2v+19vivo3Nv9rkQ3k2D5J3ENuhSMdu02fQqUa2TBVge3554C5sfWJOtpC0TsOsuz0yeSqg1sErwUZLmzDPIeMOXJKg7hJ2W9gErr7ZpF/0GNhkM62WSGi33kA1MO8aEpQ7Bc9jnRZ//Tz6NwkAZuup49zfC7jR3sLhZUiblqcjeJC4Ma/sgT8dS6s9FFg8SW+NNDkqwkDE9elG59zMoK70zNF1ThkZxjUtbU4vHWwgIcXLYn2Nwygx/4noS4A+iS+vYNCHU7MaWq53Irm9t2R3wsXce4swjpU4Wk3K4ey0hNPsfN7vv0INKP9aOuhJyPgUdr06e2QTxU5u4dahP5vPXR6hYwQTVAE56CkRY18XViBBOqP1eBzhHasmI55Vyhk39xR+i9WuevyQPIOY7iPVcIFd31GScOH3lZJLeCGTMlLoVbDnxwb/9W1YHcL4ruLbuqw1/JEWCw4FsC065qxmRaIHciEni7SKOVZ1u/PM7NBdlDWp4oY3VUSjDge6a16GdkEyy8c/24GP+pPR6mNYyO5x07NEY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(376002)(39860400002)(396003)(451199021)(46966006)(36840700001)(40470700004)(5660300002)(316002)(2906002)(110136005)(54906003)(8936002)(41300700001)(186003)(66899021)(478600001)(4326008)(70206006)(44832011)(8676002)(70586007)(6666004)(81166007)(1076003)(356005)(26005)(40460700003)(16526019)(426003)(2616005)(40480700001)(83380400001)(47076005)(36756003)(336012)(82740400003)(82310400005)(36860700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:02:01.2569
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4001a6c4-c543-49a6-a5d7-08db353f1296
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT065.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5725
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Also, Simon Horman noticed that RCT ordering was not followed
for vfio_combin_iova_ranges(), so fix that.

Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
 drivers/vfio/vfio_main.c    | 47 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h        |  3 +++
 3 files changed, 51 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index deed156e6165..7f6c51992a15 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -732,52 +732,6 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
 	mlx5vf_cmd_dealloc_pd(migf);
 }
 
-static void combine_ranges(struct rb_root_cached *root, u32 cur_nodes,
-			   u32 req_nodes)
-{
-	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
-	unsigned long min_gap;
-	unsigned long curr_gap;
-
-	/* Special shortcut when a single range is required */
-	if (req_nodes == 1) {
-		unsigned long last;
-
-		curr = comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			last = curr->last;
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-			if (prev != comb_start)
-				interval_tree_remove(prev, root);
-		}
-		comb_start->last = last;
-		return;
-	}
-
-	/* Combine ranges which have the smallest gap */
-	while (cur_nodes > req_nodes) {
-		prev = NULL;
-		min_gap = ULONG_MAX;
-		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
-		while (curr) {
-			if (prev) {
-				curr_gap = curr->start - prev->last;
-				if (curr_gap < min_gap) {
-					min_gap = curr_gap;
-					comb_start = prev;
-					comb_end = curr;
-				}
-			}
-			prev = curr;
-			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
-		}
-		comb_start->last = comb_end->last;
-		interval_tree_remove(comb_end, root);
-		cur_nodes--;
-	}
-}
-
 static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 				 struct mlx5vf_pci_core_device *mvdev,
 				 struct rb_root_cached *ranges, u32 nnodes)
@@ -800,7 +754,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	int i;
 
 	if (num_ranges > max_num_range) {
-		combine_ranges(ranges, nnodes, max_num_range);
+		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
 		num_ranges = max_num_range;
 	}
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 43bd6b76e2b6..ad8a3f948f05 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -864,6 +864,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes)
+{
+	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	unsigned long min_gap, curr_gap;
+
+	/* Special shortcut when a single range is required */
+	if (req_nodes == 1) {
+		unsigned long last;
+
+		comb_start = interval_tree_iter_first(root, 0, ULONG_MAX);
+		curr = comb_start;
+		while (curr) {
+			last = curr->last;
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+			if (prev != comb_start)
+				interval_tree_remove(prev, root);
+		}
+		comb_start->last = last;
+		return;
+	}
+
+	/* Combine ranges which have the smallest gap */
+	while (cur_nodes > req_nodes) {
+		prev = NULL;
+		min_gap = ULONG_MAX;
+		curr = interval_tree_iter_first(root, 0, ULONG_MAX);
+		while (curr) {
+			if (prev) {
+				curr_gap = curr->start - prev->last;
+				if (curr_gap < min_gap) {
+					min_gap = curr_gap;
+					comb_start = prev;
+					comb_end = curr;
+				}
+			}
+			prev = curr;
+			curr = interval_tree_iter_next(curr, 0, ULONG_MAX);
+		}
+		comb_start->last = comb_end->last;
+		interval_tree_remove(comb_end, root);
+		cur_nodes--;
+	}
+}
+EXPORT_SYMBOL_GPL(vfio_combine_iova_ranges);
+
 /* Ranges should fit into a single kernel page */
 #define LOG_MAX_RANGES \
 	(PAGE_SIZE / sizeof(struct vfio_device_feature_dma_logging_range))
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 93134b023968..10db5aa3e985 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -241,6 +241,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
 			    enum vfio_device_mig_state new_fsm,
 			    enum vfio_device_mig_state *next_fsm);
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes);
+
 /*
  * External user API
  */
-- 
2.17.1

