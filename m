Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47172580C49
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:20:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238018AbiGZHUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232099AbiGZHUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:20:02 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2070.outbound.protection.outlook.com [40.107.95.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68392AC7D;
        Tue, 26 Jul 2022 00:19:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X5wwVPNuoiXKHWbNc5isEbYJS4uR0UCFcgg9xfrtSnGQKxsBHz2kobNGgcy5/JZsIQRcLBwvyTPFs4MYIQyp9Rc1p021gfwyUT0FGpkKYJReOWcZJ0dBYx7jGmfCgV8rqOTZSo0sVp5KkNEDDMrmfzZbiWZDiS5aDr1lTMiLnnwVE50vplXgZ17QLsFjLnmzN4HQ8QvwkxvWMIIrnV3yNWbNpNmgDUCqb1bru0O0B1gUJTA1r5c08DNCKLbQlZDX3jb/P36HGydvCYCzvQQdieq+dh+LyOh0EvrTDmfqjjC0AfzxEnxTE5RusfLbG/bU+0yWFil8IQztC1bO6cFaWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bFe/3ybdedcZJKYDQCc33Bbp11JqfAKe/5fUCb6v/I0=;
 b=h6YJNT9GMKxeA41cUIAyjcm9o7VBchGkJ+8fsPIkQhJtNMRcCyYrlIlQDvRfndhLc4H+0J8kIeuxS2Ff4uk+qX2+11TibUq2x6ForIXAFZl3glzrnDjWxTHFEFnZcOZpT5jWeuduotjuw8m9xnG7OL/+XeTa/nJCDthtBT8NVvMagC9awdOx9XmgMx/8sm9gHopl4rO0j/ZLaBHYi4qeVSJD9fApXU2oSh2Eo7cERxUvuF5FIc2YT/9QLwQmH0UJ1fYEuXobLREvIZko0gWXMvgGOXvBkcagNRVeeAUVkA0s1EJ4EqlI4HtQjMKDgLBWuihtGzAk1rADQzfdv/VMJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bFe/3ybdedcZJKYDQCc33Bbp11JqfAKe/5fUCb6v/I0=;
 b=DKRz+8F3uAWiUPrhZdmrL1EdxIGj/y3XgWoZCETm3MvCg3dNYI40kMYVcq8HRnzdJNV3462olKDgk3XziqSM3Afs6Ur5lDfxQjrT2VHNIYil71/pX58Y/HgfvRRBSPZAkLwdNv7K9rygIfUIKefPVB7dwGZiubtSn+5xas/kiNhrxQXr6AHXVWfFen47PCgZdDVV2mJFnl9Bd1qalj+bcqBjQNIfpfPKSSVWd9wMw0DFzCdYnf/Cv8LLxSSNpCRF7LtToaogUWQWBX/BryMeJqJeMASU+T67kxZRlHFCazPsl7vOMGTZqG9Ehc6D8hU8GymlMu0Z7Zo8ae3sp/1rLA==
Received: from BN7PR06CA0045.namprd06.prod.outlook.com (2603:10b6:408:34::22)
 by BL3PR12MB6548.namprd12.prod.outlook.com (2603:10b6:208:38f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.25; Tue, 26 Jul
 2022 07:19:51 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:34:cafe::23) by BN7PR06CA0045.outlook.office365.com
 (2603:10b6:408:34::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Tue, 26 Jul 2022 07:19:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:19:51 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:50 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:49 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:47 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH rdma-next v1 3/5] RDMA/mlx5: Store the number of in_use cache mkeys instead of total_mrs
Date:   Tue, 26 Jul 2022 10:19:09 +0300
Message-ID: <20220726071911.122765-4-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10ba0d28-7a0b-4ac5-38fc-08da6ed73b10
X-MS-TrafficTypeDiagnostic: BL3PR12MB6548:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sr8DCISHJF63HCSTQF5ZYGkf/swUX6MCm9IHvjrImVrFkci7mKBc4+XGEZ+yXQfRUMtJhkOyo8PnRwk01TLWBEA3E+9DUZ+X5d7kCehei52sYeqyeRp4bnIaS3lCfqoSw0JGGysJ4hgH6qMBH6S1GgLTnQKdt2LlUEUdosLeFsSVArDjles4SZVfs3X0mv/gZXewxX/cK0M6H1MN7hc+PDkwUQPIqRMeSqZnwGicC/VwPMQAnFojOVAdn6V73RGRJKB3M3sbqXN/vjf9lzJgZE7O7Fh3WqsZCHhzEAotTd2trvIja3u/EvU5V8UklP8GY9ZIs8S1bB22lzC6d0mZv5zzAJB9KQmXBBUxS5MLI3nAd7//oN+OSSrTdAjUYKSGN9NV1FOp//2SWYsjbaE0SV4FhQeFbGo+27CzgL406hOP38+HT+y0tDJfjDrnLzgdav8vJ8DRbWjBZQlrkWaCSux8d3U011oDEFARbNAhOca7cpJExGNta/6KleeJHdRA/QLP8KAshAOXQFplLYSpuV9rAtAQiZQERzZArQoSa3TRhTkGmwHbeMS6RAvieQ3OJUcQKQSS7UOO6pV1KQ2mm0IIXjiWfK2Y08bba2l52sZndNz6+BrAfH3GC/5XHTOUnbkUJXcubGHflUxfyGEbodP0UunflcWdTazCP9fJc7wQTyfz2zrrHGVnpL81QRxwnJ5oMcXJVy32ak7RkdFpV+sCsX+Gb1wFzGBrT00KwqPnmNwGqPPsLMGoA2vZfJVIcnDmR8ePHn2VKvCkuEPtHRXCIXXta3ROXZ0fkAWgfzsNmqVaSJQfJzv+f3EmWfGBPwLfMsRKhDN6tVy37SN3NQ==
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(376002)(39860400002)(40470700004)(46966006)(36840700001)(186003)(1076003)(107886003)(2616005)(40480700001)(8676002)(4326008)(70586007)(70206006)(54906003)(6636002)(83380400001)(37006003)(336012)(426003)(47076005)(450100002)(36756003)(7696005)(41300700001)(6666004)(2906002)(26005)(40460700003)(86362001)(36860700001)(82310400005)(6862004)(5660300002)(316002)(81166007)(82740400003)(356005)(478600001)(8936002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:19:51.2570
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10ba0d28-7a0b-4ac5-38fc-08da6ed73b10
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR12MB6548
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

total_mrs is used only to calculate the number of mkeys currently in
use. To simplify things, replace it with a new member called "in_use"
and directly store the number of mkeys currently in use.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  4 +---
 drivers/infiniband/hw/mlx5/mr.c      | 30 ++++++++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e0eb666aefa1..da9202f4b5f3 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -755,12 +755,10 @@ struct mlx5_cache_ent {
 	u8 fill_to_high_water:1;
 
 	/*
-	 * - total_mrs is stored mkeys plus all in use MRs that could be
-	 *   returned to the cache.
 	 * - limit is the low water mark for stored mkeys, 2* limit is the
 	 *   upper water mark.
 	 */
-	u32 total_mrs;
+	u32 in_use;
 	u32 limit;
 
 	/* Statistics */
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index cbb8882c7787..26bfdbba24b4 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -268,7 +268,6 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 
 	xa_lock_irqsave(&ent->mkeys, flags);
 	push_to_reserved(ent, mr);
-	ent->total_mrs++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irqrestore(&ent->mkeys, flags);
@@ -391,9 +390,6 @@ static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
 	init_waitqueue_head(&mr->mmkey.wait);
 	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
-	xa_lock_irq(&ent->mkeys);
-	ent->total_mrs++;
-	xa_unlock_irq(&ent->mkeys);
 	kfree(in);
 	return mr;
 free_mr:
@@ -411,7 +407,6 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 	if (!ent->stored)
 		return;
 	mr = pop_stored_mkey(ent);
-	ent->total_mrs--;
 	xa_unlock_irq(&ent->mkeys);
 	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
 	kfree(mr);
@@ -467,11 +462,11 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 	 * mkeys.
 	 */
 	xa_lock_irq(&ent->mkeys);
-	if (target < ent->total_mrs - ent->stored) {
+	if (target < ent->in_use) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	target = target - (ent->total_mrs - ent->stored);
+	target = target - ent->in_use;
 	if (target < ent->limit || target > ent->limit*2) {
 		err = -EINVAL;
 		goto err_unlock;
@@ -495,7 +490,7 @@ static ssize_t size_read(struct file *filp, char __user *buf, size_t count,
 	char lbuf[20];
 	int err;
 
-	err = snprintf(lbuf, sizeof(lbuf), "%d\n", ent->total_mrs);
+	err = snprintf(lbuf, sizeof(lbuf), "%ld\n", ent->stored + ent->in_use);
 	if (err < 0)
 		return err;
 
@@ -689,13 +684,19 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	xa_lock_irq(&ent->mkeys);
+	ent->in_use++;
+
 	if (!ent->stored) {
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
 		mr = create_cache_mr(ent);
-		if (IS_ERR(mr))
+		if (IS_ERR(mr)) {
+			xa_lock_irq(&ent->mkeys);
+			ent->in_use--;
+			xa_unlock_irq(&ent->mkeys);
 			return mr;
+		}
 	} else {
 		mr = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
@@ -716,7 +717,6 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 	xa_lock_irq(&ent->mkeys);
 	while (ent->stored) {
 		mr = pop_stored_mkey(ent);
-		ent->total_mrs--;
 		xa_unlock_irq(&ent->mkeys);
 		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
 		kfree(mr);
@@ -1642,13 +1642,13 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	/* Stop DMA */
 	if (mr->cache_ent) {
+		xa_lock_irq(&mr->cache_ent->mkeys);
+		mr->cache_ent->in_use--;
+		xa_unlock_irq(&mr->cache_ent->mkeys);
+
 		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_mkey(mr->cache_ent, false, mr)) {
-			xa_lock_irq(&mr->cache_ent->mkeys);
-			mr->cache_ent->total_mrs--;
-			xa_unlock_irq(&mr->cache_ent->mkeys);
+		    push_mkey(mr->cache_ent, false, mr))
 			mr->cache_ent = NULL;
-		}
 	}
 	if (!mr->cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
-- 
2.17.2

