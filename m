Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCA47580C4E
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237967AbiGZHT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237944AbiGZHTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:19:52 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2048.outbound.protection.outlook.com [40.107.212.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BB32AE02;
        Tue, 26 Jul 2022 00:19:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ChCpU6tUe6g3YH6HabIJACVcUs91hAXatVex01y1Jkyupyp/LLHnH9+acbAQtG30zL/lkfizUb+T/H9E+/EG2Q308CL8SH6l7wxdTG0W4k0qNTKVM9eEqTi2FoMJqUPTsTWt1/I1Lx54jK4nv5JVMpemR+YA1pMoiHmDNMPVY+K64TSM7skunxgWuT3jqtCd/1mCA9wQDoErpeptgFCi+U7ocbW/B0QmCn2yVSy+yck9JL2pgiqUWBTgVedjWkQfPujujCchVIRHZkSRW0LywoGMYOLSOLvNsOGufhWedkWwcf/igcHjbZdRWUGkRLH6vs1KSq9UX0zlI9e05ORZ/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XBp8/4m2ZQGDRhrNf+DBH0cNtF7zmattYj+SrTpTIl4=;
 b=dQ0AM9OjZTxzcQmDjEkJ/VocJCbqkt9Bg/IfRjJldGvqw6qa6zEYjUWI0YC2tBoDMsYgDgdecIhT37FPa5RARWDz6yFkFtPmTvRz9lVYMs6KwTa4LIyznrTrI4ATbvVeNLuPnp/ih8EibZYf2l21nsri9Qoen3hbCX0WMe9BPTeZx6V3XpR5JBaOlJOolLkbQS2XyFTECUTOwgTsBpuQuGgelcTBSLlmc+nkL+x+5Vk//bOWSHaKRxAKZ2tPd/YvFv4x/1ucGmWDeVYETra5ftmGZP6Y5hvWZp4LZcxhVs/0kFVcAOyb2C7nYazy+NNwXhA6DOReQcbbxm4vr9OunA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XBp8/4m2ZQGDRhrNf+DBH0cNtF7zmattYj+SrTpTIl4=;
 b=jeWlII0uXJ0VhZi0A5hcE6eZ95VST4R8AvH3fSYYwlroPs1L39Do7H4/GSKO6KP6uEnOWhapeAYx/MVoMSTJ0LQuWAC8JvRPgnZH6Ba61DwKVoalHy62scPAtfNkhFGjY0fAqkYOeCIVEX0ootPzMOfht8LrTDQIU1bXawlLNUXXC+jc+gYZPTvloUpU6my8DkaZCS9oq5+sRaOAYEjrLTTEG2OfRfJCa8bxXduo8LMOkuhJAoY3X5iTDhe7MDrX9q/ToEmbsGiVSaVCeqZHa2i6t825pvHU9oQnFNpe60xtRNICemRBprKG1+Uozo9dFiSd+A7wKRWhPptLsEFtOw==
Received: from BN1PR14CA0016.namprd14.prod.outlook.com (2603:10b6:408:e3::21)
 by BN8PR12MB3380.namprd12.prod.outlook.com (2603:10b6:408:43::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 07:19:47 +0000
Received: from BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e3:cafe::65) by BN1PR14CA0016.outlook.office365.com
 (2603:10b6:408:e3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18 via Frontend
 Transport; Tue, 26 Jul 2022 07:19:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT022.mail.protection.outlook.com (10.13.176.112) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:19:47 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:46 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:45 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:43 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH rdma-next v1 2/5] RDMA/mlx5: Replace cache list with Xarray
Date:   Tue, 26 Jul 2022 10:19:08 +0300
Message-ID: <20220726071911.122765-3-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 939c854c-b896-405a-35f7-08da6ed738ac
X-MS-TrafficTypeDiagnostic: BN8PR12MB3380:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2j4T+44RPUkJB1cDre6uS5wBLkONaywAwjxh5EB9KifVh84LyzGslahUw2Hx2v6r9xlpIx7HqTr/JxMVAFN7pnoOLZx6JhVLFVR2+LoFbV9XfG20ajYFVh/G4sirLV8nD0Qpt0/skrmvoFV827ATAGWlEZP1VV9mQQNGADT7iwqGVfC8pMZBqOtB3QfVmQDqDCjQquwwOaUUXN0AEvwCtIlsHczhY9/8HLI8U4W7r9czEileiJTeAG51HitICaHsax8yGV31xBl/xgC6x5mpJEKfV7YcKmE3MHtbuWk6Rm1F71OjSz+HXYk8QpJ9neHSFfZ2DVoNTMD7y7PhQ9Q8qqupav1WcInDKbgo4uLHDFEb2bX1nWfQaYHWiszK5kKTedKqypAdiz/SRhnfOvbwobdrnPLAJAz5FVjc8Hr2xMAVpfAf2thBj1JPXZiDfSgBnxOAkVTKlSKbbite9g5iFNUFZ0vQ6WLDn3mXluKJDK7mPlfJ+fIo8K11ifNT42OPi/nLOPxTo3PDs0Mp5vSIelzh8/zJCAu9TG3t92lF4lfVI9xEB6LpTVThXa13bW+xWIPVtk0cufPZd+BTD3a0UazIuqFiKwkkhLjMNWwcqvU1y9u+Yff3mU9bzCfZ/rdIOncPJHsv73ZRBOOyrsTmKwG6RYqHikovzuPNJ8i+l7ZRdNmUHsp55UJnEYvrfKpK8yt3iamxuuQAEwRQhOdgAay3ZuBjDY6VwhnJwV3ORr7wDImFhHKSELP95jRr/DrY4IHbk/vv/wUtqkUO9vFfMK2zO0NPfC9mnhtjDRu6AFCPnN+BFTLgT6I4D+yW+B+pQH/S5fMgpsYV1RL0bunVlA==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(346002)(396003)(39860400002)(46966006)(40470700004)(36840700001)(82310400005)(36860700001)(86362001)(40460700003)(356005)(81166007)(82740400003)(8936002)(478600001)(30864003)(6862004)(5660300002)(316002)(6636002)(37006003)(54906003)(8676002)(4326008)(70206006)(70586007)(450100002)(47076005)(426003)(336012)(1076003)(107886003)(2616005)(186003)(40480700001)(83380400001)(41300700001)(6666004)(2906002)(26005)(36756003)(7696005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:19:47.1837
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 939c854c-b896-405a-35f7-08da6ed738ac
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT022.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3380
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

The Xarray allows us to store the cached mkeys in memory efficient way.

Entries are reserved in the Xarray using xa_cmpxchg before calling to
the upcoming callbacks to avoid allocations in interrupt context.
The xa_cmpxchg can sleep when using GFP_KERNEL, so we call it in
a loop to ensure one reserved entry for each process trying to reserve.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  14 +-
 drivers/infiniband/hw/mlx5/mr.c      | 226 ++++++++++++++++++---------
 2 files changed, 152 insertions(+), 88 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 42bc58967b1f..e0eb666aefa1 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -651,8 +651,6 @@ struct mlx5_ib_mr {
 		struct {
 			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
 			struct mlx5_async_work cb_work;
-			/* Cache list element */
-			struct list_head list;
 		};
 
 		/* Used only by kernel MRs (umem == NULL) */
@@ -744,7 +742,8 @@ struct umr_common {
 
 struct mlx5_cache_ent {
 	struct xarray		mkeys;
-	struct list_head	head;
+	unsigned long		stored;
+	unsigned long		reserved;
 
 	char                    name[4];
 	u32                     order;
@@ -756,18 +755,13 @@ struct mlx5_cache_ent {
 	u8 fill_to_high_water:1;
 
 	/*
-	 * - available_mrs is the length of list head, ie the number of MRs
-	 *   available for immediate allocation.
-	 * - total_mrs is available_mrs plus all in use MRs that could be
+	 * - total_mrs is stored mkeys plus all in use MRs that could be
 	 *   returned to the cache.
-	 * - limit is the low water mark for available_mrs, 2* limit is the
+	 * - limit is the low water mark for stored mkeys, 2* limit is the
 	 *   upper water mark.
-	 * - pending is the number of MRs currently being created
 	 */
 	u32 total_mrs;
-	u32 available_mrs;
 	u32 limit;
-	u32 pending;
 
 	/* Statistics */
 	u32                     miss;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index d56e7ff74b98..cbb8882c7787 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -142,6 +142,104 @@ static void create_mkey_warn(struct mlx5_ib_dev *dev, int status, void *out)
 	mlx5_cmd_out_err(dev->mdev, MLX5_CMD_OP_CREATE_MKEY, 0, out);
 }
 
+
+static int push_mkey(struct mlx5_cache_ent *ent, bool limit_pendings,
+		     void *to_store)
+{
+	XA_STATE(xas, &ent->mkeys, 0);
+	void *curr;
+
+	xa_lock_irq(&ent->mkeys);
+	if (limit_pendings &&
+	    (ent->reserved - ent->stored) > MAX_PENDING_REG_MR) {
+		xa_unlock_irq(&ent->mkeys);
+		return -EAGAIN;
+	}
+	while (1) {
+		/*
+		 * This is cmpxchg (NULL, XA_ZERO_ENTRY) however this version
+		 * doesn't transparently unlock. Instead we set the xas index to
+		 * the current value of reserved every iteration.
+		 */
+		xas_set(&xas, ent->reserved);
+		curr = xas_load(&xas);
+		if (!curr) {
+			if (to_store && ent->stored == ent->reserved)
+				xas_store(&xas, to_store);
+			else
+				xas_store(&xas, XA_ZERO_ENTRY);
+			if (xas_valid(&xas)) {
+				ent->reserved++;
+				if (to_store) {
+					if (ent->stored != ent->reserved)
+						__xa_store(&ent->mkeys,
+							   ent->stored,
+							   to_store,
+							   GFP_KERNEL);
+					ent->stored++;
+					queue_adjust_cache_locked(ent);
+					WRITE_ONCE(ent->dev->cache.last_add,
+						   jiffies);
+				}
+			}
+		}
+		xa_unlock_irq(&ent->mkeys);
+
+		/*
+		 * Notice xas_nomem() must always be called as it cleans
+		 * up any cached allocation.
+		 */
+		if (!xas_nomem(&xas, GFP_KERNEL))
+			break;
+		xa_lock_irq(&ent->mkeys);
+	}
+	if (xas_error(&xas))
+		return xas_error(&xas);
+	if (WARN_ON(curr))
+		return -EINVAL;
+	return 0;
+}
+
+static void undo_push_reserve_mkey(struct mlx5_cache_ent *ent)
+{
+	void *old;
+
+	ent->reserved--;
+	old = __xa_erase(&ent->mkeys, ent->reserved);
+	WARN_ON(old);
+}
+
+static void push_to_reserved(struct mlx5_cache_ent *ent, struct mlx5_ib_mr *mr)
+{
+	void *old;
+
+	old = __xa_store(&ent->mkeys, ent->stored, mr, 0);
+	WARN_ON(old);
+	ent->stored++;
+}
+
+static struct mlx5_ib_mr *pop_stored_mkey(struct mlx5_cache_ent *ent)
+{
+	struct mlx5_ib_mr *mr;
+	void *old;
+
+	ent->stored--;
+	ent->reserved--;
+
+	if (ent->stored == ent->reserved) {
+		mr = __xa_erase(&ent->mkeys, ent->stored);
+		WARN_ON(!mr);
+		return mr;
+	}
+
+	mr = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
+				GFP_KERNEL);
+	WARN_ON(!mr || xa_is_err(mr));
+	old = __xa_erase(&ent->mkeys, ent->reserved);
+	WARN_ON(old);
+	return mr;
+}
+
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
 	struct mlx5_ib_mr *mr =
@@ -154,7 +252,7 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 		create_mkey_warn(dev, status, mr->out);
 		kfree(mr);
 		xa_lock_irqsave(&ent->mkeys, flags);
-		ent->pending--;
+		undo_push_reserve_mkey(ent);
 		WRITE_ONCE(dev->fill_delay, 1);
 		xa_unlock_irqrestore(&ent->mkeys, flags);
 		mod_timer(&dev->delay_timer, jiffies + HZ);
@@ -169,12 +267,10 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
 	xa_lock_irqsave(&ent->mkeys, flags);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
+	push_to_reserved(ent, mr);
 	ent->total_mrs++;
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
-	ent->pending--;
 	xa_unlock_irqrestore(&ent->mkeys, flags);
 }
 
@@ -237,31 +333,33 @@ static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 		mr = alloc_cache_mr(ent, mkc);
 		if (!mr) {
 			err = -ENOMEM;
-			break;
+			goto free_in;
 		}
-		xa_lock_irq(&ent->mkeys);
-		if (ent->pending >= MAX_PENDING_REG_MR) {
-			err = -EAGAIN;
-			xa_unlock_irq(&ent->mkeys);
-			kfree(mr);
-			break;
-		}
-		ent->pending++;
-		xa_unlock_irq(&ent->mkeys);
+
+		err = push_mkey(ent, true, NULL);
+		if (err)
+			goto free_mr;
+
 		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
 					     &ent->dev->async_ctx, in, inlen,
 					     mr->out, sizeof(mr->out),
 					     &mr->cb_work);
 		if (err) {
-			xa_lock_irq(&ent->mkeys);
-			ent->pending--;
-			xa_unlock_irq(&ent->mkeys);
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
-			kfree(mr);
-			break;
+			goto err_undo_reserve;
 		}
 	}
 
+	kfree(in);
+	return 0;
+
+err_undo_reserve:
+	xa_lock_irq(&ent->mkeys);
+	undo_push_reserve_mkey(ent);
+	xa_unlock_irq(&ent->mkeys);
+free_mr:
+	kfree(mr);
+free_in:
 	kfree(in);
 	return err;
 }
@@ -310,11 +408,9 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 	struct mlx5_ib_mr *mr;
 
 	lockdep_assert_held(&ent->mkeys.xa_lock);
-	if (list_empty(&ent->head))
+	if (!ent->stored)
 		return;
-	mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-	list_del(&mr->list);
-	ent->available_mrs--;
+	mr = pop_stored_mkey(ent);
 	ent->total_mrs--;
 	xa_unlock_irq(&ent->mkeys);
 	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
@@ -324,6 +420,7 @@ static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 
 static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 				bool limit_fill)
+	 __acquires(&ent->mkeys) __releases(&ent->mkeys)
 {
 	int err;
 
@@ -332,10 +429,10 @@ static int resize_available_mrs(struct mlx5_cache_ent *ent, unsigned int target,
 	while (true) {
 		if (limit_fill)
 			target = ent->limit * 2;
-		if (target == ent->available_mrs + ent->pending)
+		if (target == ent->reserved)
 			return 0;
-		if (target > ent->available_mrs + ent->pending) {
-			u32 todo = target - (ent->available_mrs + ent->pending);
+		if (target > ent->reserved) {
+			u32 todo = target - ent->reserved;
 
 			xa_unlock_irq(&ent->mkeys);
 			err = add_keys(ent, todo);
@@ -366,15 +463,15 @@ static ssize_t size_write(struct file *filp, const char __user *buf,
 
 	/*
 	 * Target is the new value of total_mrs the user requests, however we
-	 * cannot free MRs that are in use. Compute the target value for
-	 * available_mrs.
+	 * cannot free MRs that are in use. Compute the target value for stored
+	 * mkeys.
 	 */
 	xa_lock_irq(&ent->mkeys);
-	if (target < ent->total_mrs - ent->available_mrs) {
+	if (target < ent->total_mrs - ent->stored) {
 		err = -EINVAL;
 		goto err_unlock;
 	}
-	target = target - (ent->total_mrs - ent->available_mrs);
+	target = target - (ent->total_mrs - ent->stored);
 	if (target < ent->limit || target > ent->limit*2) {
 		err = -EINVAL;
 		goto err_unlock;
@@ -466,7 +563,7 @@ static bool someone_adding(struct mlx5_mr_cache *cache)
 		bool ret;
 
 		xa_lock_irq(&ent->mkeys);
-		ret = ent->available_mrs < ent->limit;
+		ret = ent->stored < ent->limit;
 		xa_unlock_irq(&ent->mkeys);
 		if (ret)
 			return true;
@@ -485,22 +582,22 @@ static void queue_adjust_cache_locked(struct mlx5_cache_ent *ent)
 
 	if (ent->disabled || READ_ONCE(ent->dev->fill_delay))
 		return;
-	if (ent->available_mrs < ent->limit) {
+	if (ent->stored < ent->limit) {
 		ent->fill_to_high_water = true;
 		mod_delayed_work(ent->dev->cache.wq, &ent->dwork, 0);
 	} else if (ent->fill_to_high_water &&
-		   ent->available_mrs + ent->pending < 2 * ent->limit) {
+		   ent->reserved < 2 * ent->limit) {
 		/*
 		 * Once we start populating due to hitting a low water mark
 		 * continue until we pass the high water mark.
 		 */
 		mod_delayed_work(ent->dev->cache.wq, &ent->dwork, 0);
-	} else if (ent->available_mrs == 2 * ent->limit) {
+	} else if (ent->stored == 2 * ent->limit) {
 		ent->fill_to_high_water = false;
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->stored > 2 * ent->limit) {
 		/* Queue deletion of excess entries */
 		ent->fill_to_high_water = false;
-		if (ent->pending)
+		if (ent->stored != ent->reserved)
 			queue_delayed_work(ent->dev->cache.wq, &ent->dwork,
 					   msecs_to_jiffies(1000));
 		else
@@ -518,8 +615,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 	if (ent->disabled)
 		goto out;
 
-	if (ent->fill_to_high_water &&
-	    ent->available_mrs + ent->pending < 2 * ent->limit &&
+	if (ent->fill_to_high_water && ent->reserved < 2 * ent->limit &&
 	    !READ_ONCE(dev->fill_delay)) {
 		xa_unlock_irq(&ent->mkeys);
 		err = add_keys(ent, 1);
@@ -528,8 +624,8 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 			goto out;
 		if (err) {
 			/*
-			 * EAGAIN only happens if pending is positive, so we
-			 * will be rescheduled from reg_mr_callback(). The only
+			 * EAGAIN only happens if there are pending MRs, so we
+			 * will be rescheduled when storing them. The only
 			 * failure path here is ENOMEM.
 			 */
 			if (err != -EAGAIN) {
@@ -541,7 +637,7 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 						   msecs_to_jiffies(1000));
 			}
 		}
-	} else if (ent->available_mrs > 2 * ent->limit) {
+	} else if (ent->stored > 2 * ent->limit) {
 		bool need_delay;
 
 		/*
@@ -593,7 +689,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		return ERR_PTR(-EOPNOTSUPP);
 
 	xa_lock_irq(&ent->mkeys);
-	if (list_empty(&ent->head)) {
+	if (!ent->stored) {
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
@@ -601,9 +697,7 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		if (IS_ERR(mr))
 			return mr;
 	} else {
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_del(&mr->list);
-		ent->available_mrs--;
+		mr = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
 		xa_unlock_irq(&ent->mkeys);
 
@@ -612,45 +706,23 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 	return mr;
 }
 
-static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
-{
-	struct mlx5_cache_ent *ent = mr->cache_ent;
-
-	WRITE_ONCE(dev->cache.last_add, jiffies);
-	xa_lock_irq(&ent->mkeys);
-	list_add_tail(&mr->list, &ent->head);
-	ent->available_mrs++;
-	queue_adjust_cache_locked(ent);
-	xa_unlock_irq(&ent->mkeys);
-}
-
 static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	struct mlx5_ib_mr *tmp_mr;
 	struct mlx5_ib_mr *mr;
-	LIST_HEAD(del_list);
 
 	cancel_delayed_work(&ent->dwork);
-	while (1) {
-		xa_lock_irq(&ent->mkeys);
-		if (list_empty(&ent->head)) {
-			xa_unlock_irq(&ent->mkeys);
-			break;
-		}
-		mr = list_first_entry(&ent->head, struct mlx5_ib_mr, list);
-		list_move(&mr->list, &del_list);
-		ent->available_mrs--;
+	xa_lock_irq(&ent->mkeys);
+	while (ent->stored) {
+		mr = pop_stored_mkey(ent);
 		ent->total_mrs--;
 		xa_unlock_irq(&ent->mkeys);
 		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
-	}
-
-	list_for_each_entry_safe(mr, tmp_mr, &del_list, list) {
-		list_del(&mr->list);
 		kfree(mr);
+		xa_lock_irq(&ent->mkeys);
 	}
+	xa_unlock_irq(&ent->mkeys);
 }
 
 static void mlx5_mr_cache_debugfs_cleanup(struct mlx5_ib_dev *dev)
@@ -680,7 +752,7 @@ static void mlx5_mr_cache_debugfs_init(struct mlx5_ib_dev *dev)
 		dir = debugfs_create_dir(ent->name, cache->root);
 		debugfs_create_file("size", 0600, dir, ent, &size_fops);
 		debugfs_create_file("limit", 0600, dir, ent, &limit_fops);
-		debugfs_create_u32("cur", 0400, dir, &ent->available_mrs);
+		debugfs_create_ulong("cur", 0400, dir, &ent->stored);
 		debugfs_create_u32("miss", 0600, dir, &ent->miss);
 	}
 }
@@ -709,7 +781,6 @@ int mlx5_mr_cache_init(struct mlx5_ib_dev *dev)
 	timer_setup(&dev->delay_timer, delay_time_func, 0);
 	for (i = 0; i < MAX_MR_CACHE_ENTRIES; i++) {
 		ent = &cache->ent[i];
-		INIT_LIST_HEAD(&ent->head);
 		xa_init_flags(&ent->mkeys, XA_FLAGS_LOCK_IRQ);
 		ent->order = i + 2;
 		ent->dev = dev;
@@ -1571,7 +1642,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 
 	/* Stop DMA */
 	if (mr->cache_ent) {
-		if (mlx5r_umr_revoke_mr(mr)) {
+		if (mlx5r_umr_revoke_mr(mr) ||
+		    push_mkey(mr->cache_ent, false, mr)) {
 			xa_lock_irq(&mr->cache_ent->mkeys);
 			mr->cache_ent->total_mrs--;
 			xa_unlock_irq(&mr->cache_ent->mkeys);
@@ -1595,9 +1667,7 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 			mlx5_ib_free_odp_mr(mr);
 	}
 
-	if (mr->cache_ent) {
-		mlx5_mr_cache_free(dev, mr);
-	} else {
+	if (!mr->cache_ent) {
 		mlx5_free_priv_descs(mr);
 		kfree(mr);
 	}
-- 
2.17.2

