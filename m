Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4EB369BF25
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjBSIk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjBSIk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:40:26 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2084.outbound.protection.outlook.com [40.107.212.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6141040F;
        Sun, 19 Feb 2023 00:40:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWgvTLw20tUkhdBNDzI18BBLzLvqNIJ8QX0k7zLC5toKFF9JA10NdTuG2ev9Q7yWoLSaZBlEAR4/NG6e/c/W4M8KFN47O2O+9krtkMf0+hfKtwE8nh560hbITREMMPamIpCkh3ZOKMGB5WqpjJmP28wYAuAb05f/bU7tpJaNT3B1ZcOKy5QAP3p1r2hXoIGi83KOufZm41Zhv7Or+E6X02YJQfLdYmbnDogebGRM9Rk71spkqBzGVV/rOR1v9Zb4D+xEVR0BDRXi/sY7aoF2GPK7rWUkixNalonXKbqhFgz+MiLdRQUCTFJftIJhlCvkDGKA62M9DylbIWtQMVjlyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tcC/oL1pvD96+MYJImLaZ9z2nfMC2DtREarjtefVVdA=;
 b=NJ5o8aDGyX5/HSEMKJxRWLuM5ZKQ6eKcIJguASjLzWK1g8b75I+vB+Edkl0c5NWuPzSQgL8nsaW2h5dVwl8FG3UnBjDTV/Bh8HfiDW2T4Rye/7N+SQABUBuXT4RxuJFo1yxEt/NwPMRZuKcLlGzPzBwN+0N0hvJlfnjo9+SWHmatX5gJI12BhKm+E/SU2zgT4KJlkTK15PV3BpPoCBdHm+/mQdvnmJQMHXDy+qTargzmuV1LWYWlHNj1AzSxVtKkoaA7xx8nRYs17BUawUBPEv8YaQRUAqc1djVg532HR3zbOIFe3vhD/lkPaXgepulpDMyHF2goKS5eRj8DjM+iCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcC/oL1pvD96+MYJImLaZ9z2nfMC2DtREarjtefVVdA=;
 b=yRzPUdWFjF33zv/7mSGpXXVUuw5J2N5tP1hFEvnBQwt5NntOM9q8a8c1nY9dyCn9qF0CiToSa/APD31U1GVBjOcTgP6q5BR8ldfRA//Us40LNqgBfc6Efm3c/BhSnmBkiE1woJ8qFLJBov7zb0dDDcV9Yyq4CiV/KLGIGqT/UGo=
Received: from MW4PR03CA0142.namprd03.prod.outlook.com (2603:10b6:303:8c::27)
 by DM6PR12MB4529.namprd12.prod.outlook.com (2603:10b6:5:2ab::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Sun, 19 Feb
 2023 08:40:05 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::4e) by MW4PR03CA0142.outlook.office365.com
 (2603:10b6:303:8c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18 via Frontend
 Transport; Sun, 19 Feb 2023 08:40:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:40:05 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:39:58 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 4/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Sun, 19 Feb 2023 00:39:05 -0800
Message-ID: <20230219083908.40013-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|DM6PR12MB4529:EE_
X-MS-Office365-Filtering-Correlation-Id: e0778eea-f473-4e32-b1f2-08db1254e635
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a8MkLRzNVdfO42rUCk6uSUEkA490ZaDcg4Qe2yrWY1/+kiCPiaACoYTV7M+8QuImEEEllYK8j+9x2IfH0zaJQ/IZw/PICmbiBqqDgOhtBMoOnG45M3K9c8zVAzIcQz8YxjVV1r78Bo3R6P45c83MH2UYqk35tsdGPDH53M+H2vWwtGTtlA0NiiDuhO4K31vPTgc7mMyg/joX2QG42MC6HGNJb7QMoq5+aUcyP5pzFkKQrDiHIL5J1YCRgQrKp+LUVYi4lorljqSb4zc149cSQiVDDKGny68oA1ikeaI/3W5VYwuoRgHsU8w1fQFp5CwEhnX8bqXcYkZcyPKpx0FbHefyjMiOYlRufayR0tUrD6TqDqMs/fZXGuzasxSW8ZPz8ojJvRFZVZNyEkmreN51u1aAzM/qxuAR8qoqdtexBMFiQDRxFKxSriScaj+oSCGNatOvvgVV+33PvPPQG0z957y/CIsyZzlpmCFc0rgm8C4DeUpnzOg1lAOihrsT+kdtHh1o0MuWx+D3XrRpmZn2LaOlmCbms9OImwiiTYhjVyYd7q0GVj4/JVGJujTU9wUO4NdGrc4CgFPxpf1rgcIhDUfeq4c9GNIncsfNZLbDGDDz85u1DyuLo3bc5bzbdvW1x3Dd64HcldbaSoJQS5V+PTvs0mUqqYQBgI51+sbCv+V2ELJIcWcBRfVBjAA6xjKIYmcoqHPaoQxPJnAyQeRU+dZP7atWd5QCMhFNoO2tWyM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(44832011)(2616005)(316002)(47076005)(82740400003)(110136005)(54906003)(86362001)(36860700001)(8936002)(41300700001)(81166007)(4326008)(70586007)(83380400001)(8676002)(70206006)(40480700001)(426003)(336012)(40460700003)(5660300002)(36756003)(82310400005)(356005)(6666004)(1076003)(66899018)(478600001)(186003)(26005)(16526019)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:40:05.0326
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e0778eea-f473-4e32-b1f2-08db1254e635
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4529
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Cc: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/mlx5/cmd.c | 48 +------------------------------------
 drivers/vfio/vfio_main.c    | 48 +++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h        |  3 +++
 3 files changed, 52 insertions(+), 47 deletions(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 64e68d13cb98..97dcfd800047 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -692,52 +692,6 @@ void mlx5fv_cmd_clean_migf_resources(struct mlx5_vf_migration_file *migf)
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
@@ -760,7 +714,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	int i;
 
 	if (num_ranges > max_num_range) {
-		combine_ranges(ranges, nnodes, max_num_range);
+		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
 		num_ranges = max_num_range;
 	}
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 5177bb061b17..3942551bdfa1 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -809,6 +809,54 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
 	return 0;
 }
 
+void vfio_combine_iova_ranges(struct rb_root_cached *root, u32 cur_nodes,
+			      u32 req_nodes)
+{
+	struct interval_tree_node *prev, *curr, *comb_start, *comb_end;
+	unsigned long min_gap;
+	unsigned long curr_gap;
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
index 35be78e9ae57..08d39d291b5f 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -237,6 +237,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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

