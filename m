Return-Path: <netdev+bounces-7581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CB94720BAF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:04:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26F6A281AE7
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:04:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4054EC13B;
	Fri,  2 Jun 2023 22:03:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E69C126
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:40 +0000 (UTC)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2061c.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::61c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E631B5;
	Fri,  2 Jun 2023 15:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hca75JY/JaNz1p9cJAs2oJXZ46dvHxYfAAy/7b7bmp8sHbAZs4LjojZygjqEjtF1AHW8hJWlH7ieTRA4+fGBbw7LjL6DqwAqcx51HYB5xU1P4OorS3OWIFJWkq0XrydkeHGrVtLjzyDcIer6/0/hyXo9K32lv8PKBo/OFZLJop0oeXyx2SN/fk/mra/CvjPy4Vcc1w90ou7mT0FtKCeaHvi6RCRdYEqEnPSYF5coPIZslKLwRUaUrUkQOsFrJpJsza4ba5+MFjIIwUifYf470a8W5HyrTSwwP13S2HqZhZO67mmktJ8QMYmdaTiZwIcFzx/hko0SzKnqk85AFFLmuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=ZVKbIWSzwM/RCHY4ZgVbZFeKd66PKVrzowgAr1yavl6e4nMMVPQYcKzImQ7Rs0tfjqM2SPneuFw5OWm8malkBQVKDki4pVDXuP/6bY8OyI6lYtZQ272nzgua8LUxp4dGCDsF2QYXXav0mS+S+khTRgbowp7swzl+ALeVtsSB6ySbZkEZLQyhlwWr2AeuQJ/rlJosncfku8WCOgqqAGZJxciVaQv+c93SSWnqbjdoLmPYKeEypOtLW8wW/eJr8I/I8jmkt1EiGR40NUH8wbeO4Cunyima9jG+Ub2kXWe6a/rLFZzrAT4S39bA3KGR7Wyln3UnJNx4R9zXvpshSyp5vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ySOn0UHJNptpXXPBGLj3BDqJ81Vo9WUO8xq2SoXTbbk=;
 b=byjkWcbTLHGSap8uMdX2TftJoSBOaGk1gyjoA1XZYv12Q7XKcCJs1Dbxm48oiaFI/O/UvkdHjJOjn9eWCS9VsXXXCeeQJIpXCU6Iw4eKCEr0oBNAA0b4fgp0pBYk7SdQtPlUzHC9euYU6oRak7XRjzJ7p/djr9+WZmObzhtXM8c=
Received: from DS7PR03CA0306.namprd03.prod.outlook.com (2603:10b6:8:2b::14) by
 DM4PR12MB5721.namprd12.prod.outlook.com (2603:10b6:8:5c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.27; Fri, 2 Jun 2023 22:03:36 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2b:cafe::9d) by DS7PR03CA0306.outlook.office365.com
 (2603:10b6:8:2b::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.26 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:36 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.24 via Frontend Transport; Fri, 2 Jun 2023 22:03:36 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:34 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date: Fri, 2 Jun 2023 15:03:12 -0700
Message-ID: <20230602220318.15323-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|DM4PR12MB5721:EE_
X-MS-Office365-Filtering-Correlation-Id: 261a3b7f-24c8-400b-e68f-08db63b536b1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/aEG/xSz8vG2yDAx+FMaSzWbko7Yu6I/+6cRliFaHBIbWNJYtvYVzWHQGyZrgJgqmFSYIDq615T32msNa/MdjpNfOsQ+PzvZSABulEBeQ/bEN9UqfbarYuZ42X5LNv3Y6NOqIF+541vjqo+cUsvHj+qqeHw4FF6KaU1qLj+Y+xkSy5ThP3evEqgjb2iLve/MIpmwvjtkb+AgasHMTZda9ZMscu424k8fU2Rf0XhBZMe8WB4ow6Je9/GYCgIj0J0UTyC8tTwuDFKfYSpBgFgjh48CaZ1lWOpdpnOGdJSeKuKxHJM2hVEp/Cqm6c43CGEV4b8eokt9cvUvzILz/nuFv0pLdl1mnAw/OG4ahulkaGt94q6jeDnK+ZlxpEQLA2mbZHckVZmxqnaXtOmd+Yb+IH+R+irA79Ixw28AR82u2vGGw3EB6s/d0neWIAEyjrB+/FfSfGpyAHJkxLPeW1Y+M6r3N0dfVhG6jBsmoNUmmY2lm6YHc51LjFF8hJOroTSitGwwwjxFIiynBSgL0DOyy6tasLINrn2qDTz5D1ZyHbS0p3khmPRKEPDgyHnxALXeggixPjW3/zKuef3O/1zt3l8TCblnR1NskLfD2kWkcy5WV/u4W7+ovKXfa6UoOByfGfULdQV6PHv6nuhFDc4+OQdu04PgxsmtZy0FqcoWiup5M2qJRfq5xue7xxlxwlHMEq+3qdQnpsvCZI+29JhovWPyrEbRjr6/e2DTAtIdawQBbUkUVle3+IcMhr668gO3nZv5sgqh34ZJBu0MibNk2w==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199021)(40470700004)(36840700001)(46966006)(5660300002)(70586007)(70206006)(4326008)(8936002)(478600001)(40480700001)(41300700001)(316002)(36756003)(8676002)(2906002)(44832011)(66899021)(40460700003)(47076005)(36860700001)(110136005)(54906003)(86362001)(82310400005)(6666004)(1076003)(186003)(426003)(26005)(336012)(16526019)(81166007)(82740400003)(356005)(83380400001)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:36.0134
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 261a3b7f-24c8-400b-e68f-08db63b536b1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5721
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
	SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Currently only Mellanox uses the combine_ranges function. The
new pds_vfio driver also needs this function. So, move it to
a common location for other vendor drivers to use.

Also, Simon Harmon noticed that RCT ordering was not followed
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
index f0ca33b2e1df..3bde62f7e08b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -865,6 +865,53 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
index 2c137ea94a3e..f49933b63ac3 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -245,6 +245,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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


