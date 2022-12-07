Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFB086450BE
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiLGBHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiLGBHn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:43 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2066.outbound.protection.outlook.com [40.107.220.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA65EFFC;
        Tue,  6 Dec 2022 17:07:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ca35NIth6ohZO1MpvZ3EqM9x30T21mTQH0wk3JQFs6eAYp1I+e/BR9TGLb4GPAz9JWeinSh+OK1kemmI01RRJWAsfU/PfSnyaFChVNc0hQHgbeN9X4c29ABgLBS32JjbOlPqlfVL2V5VSDcrW4EgMWnqQybzMA2Oi0SGLOwSN6yLvaRu0eYk60Leui2dU1hIAtf1IMX1DHdjdOSizeKO8b/ZKxNnwWh1ueHQandqfWGgGSMilt03BbIX7SKIiFPu7FuVHkdgpYhCVoUVJScXGL5xmyAcDow/reKUkOtYdB69fF1CyAAIankQ26OTQGzJB4yUnal0ViEC3dPWEfsrsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jj8mZ7ZQ/4casth4mNYuusoJLb23I2HP5dqxRci1shU=;
 b=jzUfHPpp8XVtm4rzCQBuJKH7c97KHLhrT+KZaOSnzsaAcdlY7jmPwJ2jySIvurqtfOUzWzOcb+Q20BdOvxyMLa04+S17JEwJjrfHUX1ONgXfZh7eqT2rBC5qq8+avtY3SzIZdgEvtNJwV1mrdRNP6LZ1UztriRNE5XNRoFhI/rWT5my38YtI1ZrdBD7+eUV+2pO+sDLlNlzxO69Ca+1TzTC4Adz5BguoUVh7ri0tvJLtpDooTVlSepoo5Xx8l6Uu4/MxO1VQPWQwvD6nR75bJvAai0xNLGQxA/kNt212w9EAMcR10mTfAz8wMT+tyT0WWWR7UQxX3BfWz47qsdn/Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jj8mZ7ZQ/4casth4mNYuusoJLb23I2HP5dqxRci1shU=;
 b=12TLRpAeWy+W1riS3LYhkYRGoKZP+HQsXsA6RuyUGLBzxmc2OQmZRg3RswwUBqkkWCShnT0jjFvHFjy2GCnIcbgMhlnXmOY5nk56L3SHFuYAHEtpvW38r41l5tRquLfQYhSO9TobomayJqin7pYULEZg9W7b6lYZ+4BcrH6WxYk=
Received: from MW4PR03CA0205.namprd03.prod.outlook.com (2603:10b6:303:b8::30)
 by DS7PR12MB6213.namprd12.prod.outlook.com (2603:10b6:8:97::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:31 +0000
Received: from CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b8:cafe::1d) by MW4PR03CA0205.outlook.office365.com
 (2603:10b6:303:b8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT073.mail.protection.outlook.com (10.13.174.196) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:31 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:29 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 4/7] vfio: Commonize combine_ranges for use in other VFIO drivers
Date:   Tue, 6 Dec 2022 17:07:02 -0800
Message-ID: <20221207010705.35128-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT073:EE_|DS7PR12MB6213:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b3d12ac-0ee8-495f-c319-08dad7ef6ad2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6c7MC2w0O1yypPAuxQzcLeM/Wyy0tE30EN9WISPunCqTWJqIhs4eDbxYlVeBg0Bizszw8gk3L5VYKaOxsF3I5yyMQ8g1+ZkaaYYMnYsLP69+ZVNpC5Ixez4NsfE8zvsAgHo7JYpxiQKHB16puJwBuymvomPWMyF2S8oiMemGnRPkwvsYcSGvEBUhpYACLu9VaLZDqEYrAqKnBdHrj3kX4WTbacPgY55ANek96Wt78VA2Zg9CyJsZGylp0qeM7AsfNFwBhpTIH7qX/z54Qc8l/DFDMUXJGjbtLg6H2ZXlGIolrpLzg866TGgbQeZOBNAJ5phHGL05jGg5keprWBZNPnftTXybrxuuJmaPp7XKnkJo1Tu3RB/HBIjIZ0HvR3sjYmT5gYd4TMM9TbUjW0G3wsWOyztP4hssBCT3ayILi1rVCR4Wj76OMHDQ+3GX1Dyy5FJ/YShIH63UpAhLxx5Cs+nxYQZ5FasWLNwUQQu4l9uN0+uHLLfnuH4BK4TWgokdMo2H3sTVCTlyU8vUT5K+jpb11P/knIjJ4Xbq33cW1ZysQs5oVsN+Xluxrt8Pv8NctJSbGafW4DaWCX8gyIGebRFff2XRztwtK7/tshwYZsmW5ZwFV2Kvq7OQbSch9wZiCXa5Lt1PJOvLZa243Mmf693BdZtOQSx5oYh/Chd0p0Sn/G/2kbEkuTCcwoLuDzmQ8NqjXYwGMfH9aoVeP9UDMpSiAwUG9YordJYkYivTJWc=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199015)(40470700004)(46966006)(36840700001)(2906002)(44832011)(478600001)(82740400003)(356005)(82310400005)(41300700001)(4326008)(40460700003)(8676002)(86362001)(40480700001)(5660300002)(8936002)(47076005)(426003)(70206006)(70586007)(36756003)(54906003)(81166007)(110136005)(186003)(26005)(16526019)(336012)(2616005)(1076003)(6666004)(83380400001)(316002)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:31.4293
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b3d12ac-0ee8-495f-c319-08dad7ef6ad2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT073.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6213
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
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
index c604b70437a5..bf620d339d82 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -425,52 +425,6 @@ int mlx5vf_cmd_load_vhca_state(struct mlx5vf_pci_core_device *mvdev,
 	return err;
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
@@ -493,7 +447,7 @@ static int mlx5vf_create_tracker(struct mlx5_core_dev *mdev,
 	int i;
 
 	if (num_ranges > max_num_range) {
-		combine_ranges(ranges, nnodes, max_num_range);
+		vfio_combine_iova_ranges(ranges, nnodes, max_num_range);
 		num_ranges = max_num_range;
 	}
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 6e8804fe0095..67edace75785 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1293,6 +1293,54 @@ static int vfio_ioctl_device_feature_migration(struct vfio_device *device,
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
index fdd393f70b19..90d4fb3f155c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -196,6 +196,9 @@ int vfio_mig_get_next_state(struct vfio_device *device,
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

