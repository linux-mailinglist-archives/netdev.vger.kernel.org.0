Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 351A26CAF5C
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:06:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232056AbjC0UGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjC0UGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:06:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2085.outbound.protection.outlook.com [40.107.237.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 818CD1733;
        Mon, 27 Mar 2023 13:06:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h9BXMSLOz4TYKDhvFdT1VpGUJNrEPT0wNUCvrnE8E32OylNpdASuqXc+B9LGI8ZUEZAqJQ32T06faYulH3ZTkkmKY1r79hUEI9lQvfNkKfQP2qeCji4WlixgGRpFYU+js3HXonOMnHrFq40LrjWJVoYYDxvB1Bh/xnr1g4BAtaHR9Nlgyw/OTj99Iw4or0t7/3D3JTebe30C+RVySzVuhbdGBqVMVVhiRImKj9r4FnaWrtNohbCp+1xWUxlEr8birYcObvJ1iEVBHeKTitHC8js4iUQEx5qiq4TmyPufl7zTD3Y4jDV66yRVtT5q44B6srMl5yVs5DXp6IOxmBEcAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bkm5yh0mHvU+8zuMTjsQdO/pkdbEabFFsGDUghJFO0Q=;
 b=TNJyd+CSl+B2NCwIcHNLSN4lVvYxPp/2Rx2nTWP9pmTeNOycprxqA4fT1giKQ3pIuS2JiZElD+WqsPxYi5wAOzxSBHY0e/n55Jz2EQnL89yElNoJOQbrs9PG6zeSVexFtgqB6GEMpkFoUJikiaPCUq4su9GFhGO1rc7kohJ/OecDq1c2dtrjAUwMNsCOfdB7mOs1mjCoMbEYumIfax0Z5sAFPe6MH0lpQEYxa8XxvB9FURa1gYpCivZIOhkhYTJNjKnyhzZkqHnO3K+XnyTToqQOKbrUI0N7g0RpUGZqzSea3FKUtu6VLMeW8DRMMTnV74U3/eq/PeIpJZO/i1Wk/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bkm5yh0mHvU+8zuMTjsQdO/pkdbEabFFsGDUghJFO0Q=;
 b=ZntONQhBdDe0wX3zNRoLyEs4VyLX0e+xqI0Dl+BMHX+A2SNgGq2nQBOhcE79kjGkiFPQeADNEsR+zGrvWRP/QSzTuEOb3KYIWaXqY7pFL/cfReiCsofoESgk8dIr/BOI0FS74dN9uD1urlekOW81U8Qk9iqV+IVYuY0dqiKF0lY=
Received: from MW4PR03CA0037.namprd03.prod.outlook.com (2603:10b6:303:8e::12)
 by MN2PR12MB4302.namprd12.prod.outlook.com (2603:10b6:208:1de::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.31; Mon, 27 Mar
 2023 20:06:09 +0000
Received: from CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::c2) by MW4PR03CA0037.outlook.office365.com
 (2603:10b6:303:8e::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.43 via Frontend
 Transport; Mon, 27 Mar 2023 20:06:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT095.mail.protection.outlook.com (10.13.174.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Mon, 27 Mar 2023 20:06:09 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 15:06:07 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v6 vfio 1/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Mon, 27 Mar 2023 13:05:47 -0700
Message-ID: <20230327200553.13951-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327200553.13951-1-brett.creeley@amd.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT095:EE_|MN2PR12MB4302:EE_
X-MS-Office365-Filtering-Correlation-Id: a2c1358b-bfc4-4db1-aa66-08db2efeb4c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0vu1ibzZOwyjtW54SrfP4tSEzJUQsdymEKrZTqceRsiedefKQS0OJhzy6UDsC8Ln8FKutgcr7r+kiCHtMP6KSIKovmdqTB24R3y7avqdVKaLqL5v5oYDeC7Bg6riVFRpmoFAXA415IvzTlwcAilFy57prhb6HFWgasMmJBMlKT3l3/P7rDDunLiWBJjL8nXvUpGdYlcIL7vaonC+HB/exukJmEtUPNyw383uxKfkyfiq1DsFinDGi6fikDlnn148FiR41GzYLA7CwYa1ZXgfsq604s6YsYpalfcTU8PLETypEuk0JqfDUE1MyDVKGou+ePwr7EudoW68KnOr2XneDO5us8tRj3aZiE1Jj+XoXY49Bkc+A3Ft1aJdhUTW9xAJtwTBZb0NoNr4ymaI/uGga4+Z6/KJtUTM4OIfLmZUdVzdC21C/nl7OsJ08iyXKc8g7wyxBh9pXdIky1A70tjSFargN7QJ6hphgrbaNCcLMzedfzjwapmRcdEjme+eloVlthPlgo2VjNuBKflg6xHH9FO17jT+Yh9+9DdlmMyK9KOkDIpSWCQckwMRACcUiZZM2AohUZA1hEHUSIgBaf0d+pivK1vdQ47paCbBOQCQNFiFKs2LXnydAz8p6xQgJ3eD6nWll60MRW2eLR3EWabP63dIkJrw8TkNaoOs/3qCLwYnfHPWxOAPoJdNq20T9snLzD+ueyzkbIN6BIojSQR10hhnilia2YfgsNCrB3hXsqs=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(86362001)(36756003)(82310400005)(66899021)(40480700001)(40460700003)(478600001)(316002)(110136005)(54906003)(8676002)(4326008)(82740400003)(36860700001)(41300700001)(70586007)(70206006)(1076003)(26005)(6666004)(336012)(2616005)(16526019)(426003)(186003)(47076005)(83380400001)(5660300002)(81166007)(2906002)(8936002)(356005)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 20:06:09.0812
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c1358b-bfc4-4db1-aa66-08db2efeb4c1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT095.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4302
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
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
index 43bd6b76e2b6..49f37c1b4932 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -864,6 +864,54 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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

