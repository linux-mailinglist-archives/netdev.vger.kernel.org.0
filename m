Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7AF7580C4B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230481AbiGZHUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237992AbiGZHUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:20:12 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2047.outbound.protection.outlook.com [40.107.102.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF05C2AC67;
        Tue, 26 Jul 2022 00:20:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h1y4q8PhH/oirM1Z8lUZ3jXbGGgBl6I3+/34oTULfmlj+tVH7o/3giUkq8MhweYqDSjSClZzkz9fzRZOQHn3YnS6hVqZLcEk29SCiCdwid9FcGbBcK4RsRTHBJJ3b9gWUykzJ5TioGo9A1rNb3/p8s39HpVc8/6oG/3ELrm+uuxyLR1cnEbKAYh9iDzf5LOXrXdmcAuhxEVqNhjdfnwrjpOJo3NC7tMM2Y3cCZNGsvtHEPzAOM/4jljtXlwQ5V/aY9o+N27mJ5/KvVUkcLYZn+pn0OdTNarTasnb6XlfjINQIVcPS9wujDM6uqwxVDhsjnIxTMKIHISyvh9Lt4V+Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1h/RM+U8dWqlmKglnuFcCperbDOZ3naKWbA2MLGkuF0=;
 b=IFLQYr8HH5iYyplBQMOa2YI6ZcolkiNp7M+TusMIlO5A1/S+oty1JH67SBvSZicuND5GYFkKvV0mEbpVj9sveAE+QMOGV/b99sa5h2EVSvjEsSLyQ9iLvshGFMk4LNZJw8dvsGbmynbtiZWxpmHOmb1UbEoOPPRR8v3gxHTjA3MhvVmtkUabtH7rhvFmk9ixP09ZqL8W/m8ecyL4vjDiExpVyoCIggvkmCwVMkcJUvPFBV81Rc1G76XBjUp8qSYbylI1Ch92teH1JwF7zQ7YcTbVGzyIvc5cjuial7hw2q6nN/NSnDGcPmyd69DyzZmvewljqwkLS3iL/igr1G9OOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1h/RM+U8dWqlmKglnuFcCperbDOZ3naKWbA2MLGkuF0=;
 b=prh1hW3ffTJDDOhLNxotg6XuM8Y3TBqs7SWYfq2gaP2Yne0MUad/Levvf+Xz2BE+ctft68+s2JMzKfk3pZS7gkACAoftikMa4tWNxr+FreT1kYptp3ae0KrEIU8i3QOv48K8fMk871QGMo75qK6J7IyB84SdfSIK1KlOwg6X03YebasOyWxGEFRuWXR3NT9veQlQl8X6TMi9+T5AkwfbI/SgdAXGbi+ZoG1qvfEqEefE1QhL6Rup0AlldDEPRsFbOviJGCipjjfLLOXoZVFW87k+HRpi55JBfB/5ByndAEeLw1cXbOhN0SCIN7IDS+juFKfcZLnxumWRdkhm6SOthw==
Received: from BN9PR03CA0389.namprd03.prod.outlook.com (2603:10b6:408:f7::34)
 by MN2PR12MB3471.namprd12.prod.outlook.com (2603:10b6:208:c8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Tue, 26 Jul
 2022 07:20:00 +0000
Received: from BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f7:cafe::da) by BN9PR03CA0389.outlook.office365.com
 (2603:10b6:408:f7::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Tue, 26 Jul 2022 07:20:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT037.mail.protection.outlook.com (10.13.177.182) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:20:00 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:59 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:59 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:56 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH rdma-next v1 5/5] RDMA/mlx5: Rename the mkey cache variables and functions
Date:   Tue, 26 Jul 2022 10:19:11 +0300
Message-ID: <20220726071911.122765-6-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b37967d8-72a5-4630-8b63-08da6ed74064
X-MS-TrafficTypeDiagnostic: MN2PR12MB3471:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AYjr9LS3y9xrRz+USBjcD7J3UdjVBHf9yJK7XfWdIlkmIhuaOloYVoKCYMQzE8kbzDqsTI7lDXuUggNMoqW0E1DRUagGWQ7gOIkiPS6UY3ubrz58mcRPgqIbkqZyDm71Pnu8vIDBWfgrxd7D8+mKzYgFuG/LQHQZZgbo0ShKJMMWw/PfIs5OKWPFKNBcTrPSMwYysdAw6GXTCkm2EYuzLSjQ+0Ghw6SwiT243SZQsiluuZzf+WMMvxVskkR/aYMeuud4rN1ftM2bBLZZISlDhqIyEmy4Iz4G8VyZM0Ff1dZDeQAGvn3ut8NXh38D0UKJ6Aae573jurOk8rU0regaFCIq00UpLS9pYvj7FiG4IJA/O2UerP3a5VtxIohf5l/0UXrVZEBi2iGGYdnNaF/7yBfqTr+/uKNdejwbE2HyA1zkSKEHUvyzZ6NRC01tP+YirTmHganiTq3f8UvIV4dXCRjtMTB5jDj4nzf06UHE16Kq63DuR7YXYal+zfQHZLGdjiVgBD718A2KREEplhaDOPZ0OJ7SC4ky9XJDOpuxhXcdgFjDjA3jaQGq8tpO0UcMtZqsuBuhF3wqn5+/rI0zEwABN6ujiFD0240rQFR2t64AA5XmPpHgQt+/qoIjVYqVufsCCS8bEh8/4UbenSKBXy5/LHA2X+cEI3mExCrgirq5RnGrCID8Y++3IVczA9c0BC8FFKLketrkqFuqIPrs8dhQHmkVuzZnynSUCdfPcQM8l2VdhWrCMTxndbT5zypp4eCiIox4IxrvXsfUhJhtx3ScAjaAsKyZPIcBoMbeaXVdMi+tWeGaly32MS88htj65vB/IXCLsq3zYQpridjv1g==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(136003)(396003)(46966006)(36840700001)(40470700004)(70586007)(356005)(82740400003)(36860700001)(81166007)(426003)(86362001)(4326008)(8676002)(40460700003)(54906003)(450100002)(70206006)(316002)(37006003)(6636002)(2906002)(8936002)(83380400001)(7696005)(82310400005)(5660300002)(107886003)(2616005)(47076005)(26005)(1076003)(6862004)(30864003)(478600001)(6666004)(36756003)(41300700001)(186003)(40480700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:20:00.2139
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b37967d8-72a5-4630-8b63-08da6ed74064
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT037.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3471
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

After replacing the MR cache with an Mkey cache, rename the variables
and functions to fit the new meaning.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/main.c    |  4 +--
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 14 ++++----
 drivers/infiniband/hw/mlx5/mr.c      | 54 ++++++++++++++--------------
 drivers/infiniband/hw/mlx5/odp.c     |  2 +-
 include/linux/mlx5/driver.h          |  6 ++--
 5 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b68fddeac0f1..a174a0eee8dc 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4002,7 +4002,7 @@ static void mlx5_ib_stage_pre_ib_reg_umr_cleanup(struct mlx5_ib_dev *dev)
 {
 	int err;
 
-	err = mlx5_mr_cache_cleanup(dev);
+	err = mlx5_mkey_cache_cleanup(dev);
 	if (err)
 		mlx5_ib_warn(dev, "mr cache cleanup failed\n");
 
@@ -4022,7 +4022,7 @@ static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		return ret;
 
-	ret = mlx5_mr_cache_init(dev);
+	ret = mlx5_mkey_cache_init(dev);
 	if (ret) {
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
 		mlx5r_umr_resource_cleanup(dev);
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 91f985cd7d90..2e2ad3918385 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -764,9 +764,9 @@ struct mlx5r_async_create_mkey {
 	u32 mkey;
 };
 
-struct mlx5_mr_cache {
+struct mlx5_mkey_cache {
 	struct workqueue_struct *wq;
-	struct mlx5_cache_ent	ent[MAX_MR_CACHE_ENTRIES];
+	struct mlx5_cache_ent	ent[MAX_MKEY_CACHE_ENTRIES];
 	struct dentry		*root;
 	unsigned long		last_add;
 };
@@ -1065,7 +1065,7 @@ struct mlx5_ib_dev {
 	struct mlx5_ib_resources	devr;
 
 	atomic_t			mkey_var;
-	struct mlx5_mr_cache		cache;
+	struct mlx5_mkey_cache		cache;
 	struct timer_list		delay_timer;
 	/* Prevents soft lock on massive reg MRs */
 	struct mutex			slow_path_mutex;
@@ -1310,8 +1310,8 @@ void mlx5_ib_populate_pas(struct ib_umem *umem, size_t page_size, __be64 *pas,
 			  u64 access_flags);
 void mlx5_ib_copy_pas(u64 *old, u64 *new, int step, int num);
 int mlx5_ib_get_cqe_size(struct ib_cq *ibcq);
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev);
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev);
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev);
 
 struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 				       struct mlx5_cache_ent *ent,
@@ -1339,7 +1339,7 @@ int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq);
 void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev);
 int __init mlx5_ib_odp_init(void);
 void mlx5_ib_odp_cleanup(void);
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent);
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent);
 void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 			   struct mlx5_ib_mr *mr, int flags);
 
@@ -1358,7 +1358,7 @@ static inline int mlx5r_odp_create_eq(struct mlx5_ib_dev *dev,
 static inline void mlx5_ib_odp_cleanup_one(struct mlx5_ib_dev *ibdev) {}
 static inline int mlx5_ib_odp_init(void) { return 0; }
 static inline void mlx5_ib_odp_cleanup(void)				    {}
-static inline void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent) {}
+static inline void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent) {}
 static inline void mlx5_odp_populate_xlt(void *xlt, size_t idx, size_t nentries,
 					 struct mlx5_ib_mr *mr, int flags) {}
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index edbc2990d151..129d531bd01b 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -119,7 +119,7 @@ static int mlx5_ib_create_mkey_cb(struct mlx5r_async_create_mkey *async_create)
 				&async_create->cb_work);
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev);
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev);
 static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent);
 
 static int destroy_mkey(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
@@ -515,11 +515,11 @@ static const struct file_operations limit_fops = {
 	.read	= limit_read,
 };
 
-static bool someone_adding(struct mlx5_mr_cache *cache)
+static bool someone_adding(struct mlx5_mkey_cache *cache)
 {
 	unsigned int i;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &cache->ent[i];
 		bool ret;
 
@@ -569,7 +569,7 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 static void __cache_work_func(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_dev *dev = ent->dev;
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	int err;
 
 	xa_lock_irq(&ent->mkeys);
@@ -681,7 +681,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 
 static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
 	u32 mkey;
 
@@ -696,7 +696,7 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	xa_unlock_irq(&ent->mkeys);
 }
 
-static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 {
 	if (!mlx5_debugfs_root || dev->is_rep)
 		return;
@@ -705,9 +705,9 @@ static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
 	dev->cache.root = NULL;
 }
 
-static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
+static void mlx5_mkey_cache_debugfs_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	struct dentry *dir;
 	int i;
@@ -717,7 +717,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 
 	cache->root = debugfs_create_dir("mr_cache", mlx5_debugfs_get_dev_root(dev->mdev));
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		sprintf(ent->name, "%d", ent->order);
 		dir = debugfs_create_dir(ent->name, cache->root);
@@ -735,9 +735,9 @@ static void delay_time_func(struct timer_list *t)
 	WRITE_ONCE(dev->fill_delay, 0);
 }
 
-int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_init(struct mlx5_ib_dev *dev)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent;
 	int i;
 
@@ -750,7 +750,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 	mlx5_cmd_init_async_ctx(dev->mdev, &dev->async_ctx);
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 		ent->order = i + 2;
@@ -759,12 +759,12 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 
 		INIT_DELAYED_WORK(&ent->dwork, delayed_cache_work_func);
 
-		if (i > MR_CACHE_LAST_STD_ENTRY) {
-			mlx5_odp_init_mr_cache_entry(ent);
+		if (i > MKEY_CACHE_LAST_STD_ENTRY) {
+			mlx5_odp_init_mkey_cache_entry(ent);
 			continue;
 		}
 
-		if (ent->order > mr_cache_max_order(dev))
+		if (ent->order > mkey_cache_max_order(dev))
 			continue;
 
 		ent->page = PAGE_SHIFT;
@@ -781,19 +781,19 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 		xa_unlock_irq(&ent->mkeys);
 	}
 
-	mlx5_mr_cache_debugfs_init(dev);
+	mlx5_mkey_cache_debugfs_init(dev);
 
 	return 0;
 }
 
-int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
+int mlx5_mkey_cache_cleanup(struct mlx5_ib_dev *dev)
 {
 	unsigned int i;
 
 	if (!dev->cache.wq)
 		return 0;
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &dev->cache.ent[i];
 
 		xa_lock_irq(&ent->mkeys);
@@ -802,10 +802,10 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 		cancel_delayed_work_sync(&ent->dwork);
 	}
 
-	mlx5_mr_cache_debugfs_cleanup(dev);
+	mlx5_mkey_cache_debugfs_cleanup(dev);
 	mlx5_cmd_cleanup_async_ctx(&dev->async_ctx);
 
-	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++)
+	for (i = 0; i < MAX_MKEY_CACHE_ENTRIES; i++)
 		clean_keys(dev, i);
 
 	destroy_workqueue(dev->cache.wq);
@@ -872,22 +872,22 @@ static int get_octo_len(u64 addr, u64 len, int page_shift)
 	return (npages + 1) / 2;
 }
 
-static int mr_cache_max_order(struct mlx5_ib_dev *dev)
+static int mkey_cache_max_order(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, umr_extended_translation_offset))
-		return MR_CACHE_LAST_STD_ENTRY + 2;
+		return MKEY_CACHE_LAST_STD_ENTRY + 2;
 	return MLX5_MAX_UMR_SHIFT;
 }
 
-static struct mlx5_cache_ent *mr_cache_ent_from_order(struct mlx5_ib_dev *dev,
-						      unsigned int order)
+static struct mlx5_cache_ent *mkey_cache_ent_from_order(struct mlx5_ib_dev *dev,
+							unsigned int order)
 {
-	struct mlx5_mr_cache *cache = &dev->cache;
+	struct mlx5_mkey_cache *cache = &dev->cache;
 
 	if (order < cache->ent[0].order)
 		return &cache->ent[0];
 	order = order - cache->ent[0].order;
-	if (order > MR_CACHE_LAST_STD_ENTRY)
+	if (order > MKEY_CACHE_LAST_STD_ENTRY)
 		return NULL;
 	return &cache->ent[order];
 }
@@ -930,7 +930,7 @@ static struct mlx5_ib_mr *alloc_cacheable_mr(struct ib_pd *pd,
 						     0, iova);
 	if (WARN_ON(!page_size))
 		return ERR_PTR(-EINVAL);
-	ent = mr_cache_ent_from_order(
+	ent = mkey_cache_ent_from_order(
 		dev, order_base_2(ib_umem_num_dma_blocks(umem, page_size)));
 	/*
 	 * Matches access in alloc_cache_mr(). If the MR can't come from the
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 84da5674e1ab..e305bf1dc6c2 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -1588,7 +1588,7 @@ mlx5_ib_odp_destroy_eq(struct mlx5_ib_dev *dev, struct mlx5_ib_pf_eq *eq)
 	return err;
 }
 
-void mlx5_odp_init_mr_cache_entry(struct mlx5_cache_ent *ent)
+void mlx5_odp_init_mkey_cache_entry(struct mlx5_cache_ent *ent)
 {
 	if (!(ent->dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 		return;
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 76d7661e3e63..220597c2f436 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -728,10 +728,10 @@ enum {
 };
 
 enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
+	MKEY_CACHE_LAST_STD_ENTRY = 20,
 	MLX5_IMR_MTT_CACHE_ENTRY,
 	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
+	MAX_MKEY_CACHE_ENTRIES
 };
 
 struct mlx5_profile {
@@ -740,7 +740,7 @@ struct mlx5_profile {
 	struct {
 		int	size;
 		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
+	} mr_cache[MAX_MKEY_CACHE_ENTRIES];
 };
 
 struct mlx5_hca_cap {
-- 
2.17.2

