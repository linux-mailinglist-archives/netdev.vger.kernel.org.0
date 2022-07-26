Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65B5580C45
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237923AbiGZHTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237619AbiGZHTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:19:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E37FE2AC75;
        Tue, 26 Jul 2022 00:19:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xwg/1o7DwOOFncz2GYtNgpaRVSA7GBaPX4W4R2S7pbx7v7QDrigPvFswUSmIuhctu93uaFCptqEH2mLKMXCk4sS9/c05EJDI99PbZI9MtlVO7VlsJe525p0b5ujQH3pfX2/Gorf0W+X9pvw7KobTeseHVqI1qb1KTw+PxTjeQK+75h39kK8eyMC3LdwK3x0byiNiEgnGUoBVMabpq66QH8mGdaTm3oZBwKuAM7kYEudC+qCfBqRNd6gRtQMBIjO+NbN1ZvLoq9LMlMtAtVYSDjO2M04C6PJTd7BsR/Gt/oxaOEFrd5QWAwczPM1S+02zkBPnPkc7X1kKvI8TqJMGNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k2v/soaFwnXnvLWr3HQtOPjXt9UgP3OMYV8aOZiEbW8=;
 b=NW8ofvxsinFuTBikmaVnAuanavUI2SdQG9cdv1RnJeWseF4K69IeFoLD8sIWe8On8yiNZZ78QLjEf57akY28C81TlxURynFFRZOyKFr8bzoO7c4624wW+lpdV67HHouIMc8Jm01weAhpKos2ny5hQdaENZBD1Kr8WxIa2gAP0mAF6QO++BhvoU//G3j9YiIdg1W+tCK/oawGrEtEpdfwxTWIVVmg5dbj9OGOLhPN5dHA6IKJyZucqu4FZcrheHNM5VrEDTrQqMtxdMpxtfNH5B83tLKnd4b8GoLH3GM47Nnm6U0rAS09QGtF5EIhC6FRn2yZKL/324kv6H/F7kPkiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k2v/soaFwnXnvLWr3HQtOPjXt9UgP3OMYV8aOZiEbW8=;
 b=TufyLt7HXDvmaSyFwgVw58eeyPRPDB2kBGwy5YpZ4U6bj8MUkQM/MhkPsK2x8/v3sa2DwIBlcQA/nFanKkJG5iFillEBXTIvDGBZ4a30DEQczr6CJL+F99s0rqdNai9o7LeSkI9k3EpdbcTvubqTDHzLPywsQoItNW4WgY+gdGUHO1aTWWNwSP2W99hN1DksXG3R6Ow5Bk7vZ6HVlaNyvRhlh2zuFlE4cM4MFrD3nLx1A24QntQX/cEitr0Jk1mW4qqdGYaS+gCdSkUKpxiOfIadzLqFROLg8Tx+NgO5xqmtlyMkXmlDzr5ak2jvs+awWatzh2QBc5bUH+FLj/Q95Q==
Received: from BN0PR10CA0008.namprd10.prod.outlook.com (2603:10b6:408:143::27)
 by CH2PR12MB4823.namprd12.prod.outlook.com (2603:10b6:610:11::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 07:19:41 +0000
Received: from BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:143:cafe::12) by BN0PR10CA0008.outlook.office365.com
 (2603:10b6:408:143::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.21 via Frontend
 Transport; Tue, 26 Jul 2022 07:19:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT031.mail.protection.outlook.com (10.13.177.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:19:41 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:40 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:39 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:37 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH rdma-next v1 1/5] RDMA/mlx5: Replace ent->lock with xa_lock
Date:   Tue, 26 Jul 2022 10:19:07 +0300
Message-ID: <20220726071911.122765-2-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2759f53b-e5ed-471f-a804-08da6ed73534
X-MS-TrafficTypeDiagnostic: CH2PR12MB4823:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7isSpNeZ3lagpEvtjBkYfjpXiBdLC2pQw2TZ+xBVaH+ehkx8zN/D9dyEX7FSkA9Z/X0Oj+TyW9pH8TFnpNz+qz00zlJGNN+vLh/6D0QyxuXGirDRFEa5y9xvwJberIt1f+nKM1t9HHUN3nj6P/Wq1DQlSuBkC36edvrphWU4Fxr767Vzr3pyh0z+fDBusYBpmszCbK5gyktvaHVUMsxetPxwXew9MObPM61svnGQJGP+hnhgM7bJkiS9xXQOfUKHudjVk//FVrEh3c22gjsWML2OscEZp0O8pQHuUeX24rP2o4BpXOkRSeniXlMppgPUZgw8ixd8ONKYlPx9JU/07VBnujOUJbYblZeZXYfobi7XfltWtZ/CfUPOIkEahMzakUPI/6b++a05/otHtHzLAQ2bC1PWTF53rtfJ5Okj7Gxt2AJMtSPMNjQhb+CmmClwdeIERiLG71QvQ4JWm0ACkxr99R2FGPstfy0i0kTAf+efIhTjJIVZLLEOSdw1ceynvILx7k0IkC4AueqB22vWqPvXEIL3bY6yyUXHwjFy8oDqyd4FPouNJoJ0qePb1kvlPAvy6oiFzbE0Za5zUmwdkTiv7OVXjZQZoaC0E/gp6jFaxsatINv2kmH8KyMInJkKGSDHoNrqEtvhbEml++QQA1NMM3SW8+INxMC2Db9Y8Shn//fCzt2oZ4fIhAzvyHzfr0l9HMMJIYCnsPWTIbqYAogRIL3gSGAImBSJxqIB5hO5SVPjGEG6tRzsuYgp1a8xLuunDpCpKL757SAV0BRFh2HjcqZ3aZis1HVVUO8tav3lv5w/+dSEhbv29IWxP1YOqbQ33NeC9YFVeKAn0RpzZA==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(136003)(376002)(396003)(39860400002)(40470700004)(46966006)(36840700001)(4326008)(36860700001)(54906003)(81166007)(70586007)(8676002)(70206006)(6636002)(37006003)(82740400003)(356005)(316002)(478600001)(82310400005)(26005)(6666004)(86362001)(2906002)(41300700001)(426003)(7696005)(83380400001)(47076005)(40460700003)(40480700001)(8936002)(36756003)(6862004)(1076003)(5660300002)(2616005)(30864003)(107886003)(336012)(450100002)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:19:41.3514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2759f53b-e5ed-471f-a804-08da6ed73534
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT031.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4823
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

In the next patch, ent->list will be replaced with an xarray. The xarray
uses an internal lock to protect the indexes. Use it to protect all the
entry fields, and get rid of ent->lock.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  5 +-
 drivers/infiniband/hw/mlx5/mr.c      | 92 ++++++++++++++--------------
 2 files changed, 47 insertions(+), 50 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 688ee7c05a8f..42bc58967b1f 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -743,11 +743,8 @@ struct umr_common {
 };
 
 struct mlx5_cache_ent {
+	struct xarray		mkeys;
 	struct list_head	head;
-	/* sync access to the cahce entry
-	 */
-	spinlock_t		lock;
-
 
 	char                    name[4];
 	u32                     order;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index aedfd7ff4846..d56e7ff74b98 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -153,10 +153,10 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 	if (status) {
 		create_mkey_warn(dev, status, mr->out);
 		kfree(mr);
-		spin_lock_irqsave(&ent->lock, flags);
+		xa_lock_irqsave(&ent->mkeys, flags);
 		ent->pending--;
 		WRITE_ONCE(dev->fill_delay, 1);
-		spin_unlock_irqrestore(&ent->lock, flags);
+		xa_unlock_irqrestore(&ent->mkeys, flags);
 		mod_timer(&dev->delay_timer, jiffies + HZ);
 		return;
 	}
@@ -168,14 +168,14 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
-	spin_lock_irqsave(&ent->lock, flags);
+	xa_lock_irqsave(&ent->mkeys, flags);
 	list_add_tail(&mr->list, &ent->head);
 	ent->available_mrs++;
 	ent->total_mrs++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	ent->pending--;
-	spin_unlock_irqrestore(&ent->lock, flags);
+	xa_unlock_irqrestore(&ent->mkeys, flags);
 }
 
 static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
@@ -239,23 +239,23 @@ static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 			err = -ENOMEM;
 			break;
 		}
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		if (ent->pending >= MAX_PENDING_REG_MR) {
 			err = -EAGAIN;
-			spin_unlock_irq(&ent->lock);
+			xa_unlock_irq(&ent->mkeys);
 			kfree(mr);
 			break;
 		}
 		ent->pending++;
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
 					     &ent->dev->async_ctx, in, inlen,
 					     mr->out, sizeof(mr->out),
 					     &mr->cb_work);
 		if (err) {
-			spin_lock_irq(&ent->lock);
+			xa_lock_irq(&ent->mkeys);
 			ent->pending--;
-			spin_unlock_irq(&ent->lock);
+			xa_unlock_irq(&ent->mkeys);
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
 			kfree(mr);
 			break;
@@ -293,9 +293,9 @@ static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
 	init_waitqueue_head(&mr->mmkey.wait);
 	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	ent->total_mrs++;
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 	kfree(in);
 	return mr;
 free_mr:
@@ -309,17 +309,17 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 {
 	struct mlx5_ib_mr *mr;
 
-	lockdep_assert_held(&ent->lock);
+	lockdep_assert_held(&ent->mkeys.xa_lock);
 	if (list_empty(&ent->head))
 		return;
 	mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
 	list_del(&mr->list);
 	ent->available_mrs--;
 	ent->total_mrs--;
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
 	kfree(mr);
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 }
 
 static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
@@ -327,7 +327,7 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 {
 	int err;
 
-	lockdep_assert_held(&ent->lock);
+	lockdep_assert_held(&ent->mkeys.xa_lock);
 
 	while (true) {
 		if (limit_fill)
@@ -337,11 +337,11 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 		if (target > ent->available_mrs + ent->pending) {
 			u32 todo = target - (ent->available_mrs + ent->pending);
 
-			spin_unlock_irq(&ent->lock);
+			xa_unlock_irq(&ent->mkeys);
 			err = add_keys(ent, todo);
 			if (err == -EAGAIN)
 				usleep_range(3000, 5000);
-			spin_lock_irq(&ent->lock);
+			xa_lock_irq(&ent->mkeys);
 			if (err) {
 				if (err != -EAGAIN)
 					return err;
@@ -369,7 +369,7 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 	 * cannot free MRs that are in use. Compute the target value for
 	 * available_mrs.
 	 */
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	if (target < ent->total_mrs - ent->available_mrs) {
 		err = -EINVAL;
 		goto err_unlock;
@@ -382,12 +382,12 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 	err = resize_available_mrs(ent, target, false);
 	if (err)
 		goto err_unlock;
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 
 	return count;
 
 err_unlock:
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 	return err;
 }
 
@@ -427,10 +427,10 @@ static ssize_t limit_write(struct file *filp, const char __user *buf,
 	 * Upon set we immediately fill the cache to high water mark implied by
 	 * the limit.
 	 */
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	ent->limit = var;
 	err = resize_available_mrs(ent, 0, true);
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 	if (err)
 		return err;
 	return count;
@@ -465,9 +465,9 @@ static bool someone_adding(struct mlx5_mr_cache *cache)
 		struct mlx5_cache_ent *ent = &cache->ent[i];
 		bool ret;
 
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		ret = ent->available_mrs < ent->limit;
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		if (ret)
 			return true;
 	}
@@ -481,7 +481,7 @@ static bool someone_adding(struct mlx5_mr_cache *cache)
  */
 static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 {
-	lockdep_assert_held(&ent->lock);
+	lockdep_assert_held(&ent->mkeys.xa_lock);
 
 	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
 		return;
@@ -514,16 +514,16 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 	struct mlx5_mr_cache *cache = &dev->cache;
 	int err;
 
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	if (ent->disabled)
 		goto out;
 
 	if (ent->fill_to_high_water &&
 	    ent->available_mrs + ent->pending < 2 * ent->limit &&
 	    !READ_ONCE(dev->fill_delay)) {
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		err = add_keys(ent, 1);
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		if (ent->disabled)
 			goto out;
 		if (err) {
@@ -556,11 +556,11 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		 * the garbage collection work to try to run in next cycle, in
 		 * order to free CPU resources to other tasks.
 		 */
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		need_delay = need_resched() || someone_adding(cache) ||
 			     !time_after(jiffies,
 					 READ_ONCE(cache->last_add) + 300 * HZ);
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		if (ent->disabled)
 			goto out;
 		if (need_delay) {
@@ -571,7 +571,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		queue_adjust_cache_locked(ent);
 	}
 out:
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 }
 
 static void delayed_cache_work_func(struct work_struct *work)
@@ -592,11 +592,11 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	if (!mlx5r_umr_can_reconfig(dev, 0, access_flags))
 		return ERR_PTR(-EOPNOTSUPP);
 
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	if (list_empty(&ent->head)) {
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		mr = create_cache_mr(ent);
 		if (IS_ERR(mr))
 			return mr;
@@ -605,7 +605,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		list_del(&mr->list);
 		ent->available_mrs--;
 		queue_adjust_cache_locked(ent);
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 
 		mlx5_clear_mr(mr);
 	}
@@ -617,11 +617,11 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	struct mlx5_cache_ent *ent = mr->cache_ent;
 
 	WRITE_ONCE(dev->cache.last_add, jiffies);
-	spin_lock_irq(&ent->lock);
+	xa_lock_irq(&ent->mkeys);
 	list_add_tail(&mr->list, &ent->head);
 	ent->available_mrs++;
 	queue_adjust_cache_locked(ent);
-	spin_unlock_irq(&ent->lock);
+	xa_unlock_irq(&ent->mkeys);
 }
 
 static void clean_keys(struct mlx5_ib_dev *dev, int c)
@@ -634,16 +634,16 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 
 	cancel_delayed_work(&ent->dwork);
 	while (1) {
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		if (list_empty(&ent->head)) {
-			spin_unlock_irq(&ent->lock);
+			xa_unlock_irq(&ent->mkeys);
 			break;
 		}
 		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
 		list_move(&mr->list, &del_list);
 		ent->available_mrs--;
 		ent->total_mrs--;
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 	}
 
@@ -710,7 +710,7 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
 		INIT_LIST_HEAD(&ent->head);
-		spin_lock_init(&ent->lock);
+		xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 		ent->order = i + 2;
 		ent->dev = dev;
 		ent->limit = 0;
@@ -734,9 +734,9 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 			ent->limit = dev->mdev->profile.mr_cache[i].limit;
 		else
 			ent->limit = 0;
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		queue_adjust_cache_locked(ent);
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 	}
 
 	mlx5_mr_cache_debugfs_init(dev);
@@ -754,9 +754,9 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		struct mlx5_cache_ent *ent = &dev->cache.ent[i];
 
-		spin_lock_irq(&ent->lock);
+		xa_lock_irq(&ent->mkeys);
 		ent->disabled = true;
-		spin_unlock_irq(&ent->lock);
+		xa_unlock_irq(&ent->mkeys);
 		cancel_delayed_work_sync(&ent->dwork);
 	}
 
@@ -1572,9 +1572,9 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	/* Stop DMA */
 	if (mr->cache_ent) {
 		if (mlx5r_umr_revoke_mr(mr)) {
-			spin_lock_irq(&mr->cache_ent->lock);
+			xa_lock_irq(&mr->cache_ent->mkeys);
 			mr->cache_ent->total_mrs--;
-			spin_unlock_irq(&mr->cache_ent->lock);
+			xa_unlock_irq(&mr->cache_ent->mkeys);
 			mr->cache_ent = NULL;
 		}
 	}
-- 
2.17.2

