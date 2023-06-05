Return-Path: <netdev+bounces-7974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CEAD7224D8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:44:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6F381281065
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 11:44:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AD817748;
	Mon,  5 Jun 2023 11:44:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310DCF9E8
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:43:59 +0000 (UTC)
Received: from DM6FTOPR00CU001.outbound.protection.outlook.com (mail-centralusazon11020015.outbound.protection.outlook.com [52.101.61.15])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F099E6;
	Mon,  5 Jun 2023 04:43:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l5URyYc0B9YQ3aKKds0eVmUg9zxEu4H73P9ZajlUY5jHfQYqzDNKMXB3wZ6SZ9RuKiAfWpqxEgwWR6htSpnwvy0oDhNZdNKRXxxo1BS63duWDWqMla6tRgPILNo1/6mOhq5UZCCwj9VDC9vTE8OL+9DtVuHmkS45hGZ4xlHOX7bVgAQ0buT2kHu9IurTmce7DFk1GHeqtoxaG5angbmwoPMZSFo6BejqWI4XRV7nMcyVMSfBEs3X5TnxI2eBiYjCkoCsgkNRIQvTxawsu9hlbi8dSFps2m0j/ecNNOkFBtBenVIGTTxxot5foQnjRFloO6MzkTE6n7J9JQsQQpC2Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uhSyIqQPqPxYg8j1G8Gpstb3oXGGH0mSo5FVlNKZKkU=;
 b=V0WbtQ6Hy9w3TsxJ5UNgbDwtob61zLe5LKOWaLnwA/BeLLyz8Bd+89yqKeC3f7ElPPlK30rSiERXoOBLhOgm/R7H5phbbkUEPTCZVVuREgtJEnVBmhSU5sFaIPeQ/YZeotaSX8HoW1miV6c8IOcdLg0hc559I/Ki4tl/tIrFkiBFH86dxzvHFR3WMea+2v4784cxO4XmvMImXyxtAlWWugYhk0UPNXOU1cK4egHJIa/m3Tul6Ft4l5gpF4Msjm74evXXDSS8ibyRheIVpGUOk6Hr3XWLyFr45efnPDqT2+WbIhJuZl5jWZTOk2lLfbWzFMBf6KBxnG5DQCEi9maIgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uhSyIqQPqPxYg8j1G8Gpstb3oXGGH0mSo5FVlNKZKkU=;
 b=DTfxH/9l0ksvN3OZ/pUq/KzjfucQXHmgewJVbPx98V2wb/FT0yODhBHdlA/I6k3/6gqc5+Ex2PH3QXX37P1kP6V+Yl2SB1QAAkQW+I0VLxdyU1kxQQTQK5+j5dDvGRLZkhyKo/BEjvcqOhrpSTwOwnmqmECS8zYSOyTGjp1oUyw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from MN2PR21MB1454.namprd21.prod.outlook.com (2603:10b6:208:208::11)
 by DS7PR21MB3077.namprd21.prod.outlook.com (2603:10b6:8:71::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.0; Mon, 5 Jun
 2023 11:43:52 +0000
Received: from MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9]) by MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9%4]) with mapi id 15.20.6500.004; Mon, 5 Jun 2023
 11:43:52 +0000
From: Wei Hu <weh@microsoft.com>
To: netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	longli@microsoft.com,
	sharmaajay@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vkuznets@redhat.com,
	ssengar@linux.microsoft.com,
	shradhagupta@linux.microsoft.com,
	weh@microsoft.com
Subject: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib driver.
Date: Mon,  5 Jun 2023 11:43:13 +0000
Message-Id: <20230605114313.1640883-1-weh@microsoft.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ2PR07CA0004.namprd07.prod.outlook.com
 (2603:10b6:a03:505::10) To MN2PR21MB1454.namprd21.prod.outlook.com
 (2603:10b6:208:208::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR21MB1454:EE_|DS7PR21MB3077:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f91a496-6bcb-4c30-f0cf-08db65ba2114
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	MT6ySgUKRR6rCDQxBuQiFIMdkV6O6LTnVevoXYjsRvFNkRTnH4M6CbwvwG8gG9IXfTGgdD1cy0m2kqBgROYbFjow6V8BTN91mOgLfYA01qw+Z14o+pJlSTtiJO7FvDWCwvzCud5I9s4fk/dVaofusaMVWjzJy3eBOjHtgmGxJ16Bprxm7YG2AUj8ZdCEWbwWUYxNfh+PVEfdjnQ9sAz6GA5ugd6ERDDwLgaSZL8Jip9jeI4d22+UCdMyo1LWgASj1wbCBFdeqXtAxBTfKPPIfIgjz4xwVEzeYzUuf1qVyU+MnF5UDFkchPn7juOkaaZfTwd18ivs97IjSZ1Pqj5OS9qWQVXsfIUaUqoo0AGM4iVSNs2oZP10xDIY1Mgf1YgcAJNYbvwTclOL3RzfvOsSbq1aeWXcVEzWlm7QzTOpn2k8WCi66j9TqPJTcBEHiYb+t9Yio7J7PBs0p1WWf/5T3sSeQ5aUs2rSj+8WlxpU0yq84VOPd8GGpeVDkKzypB1fPPlrUBS6qP8kUWJ/oxt4LH+bvqAmyjIfDr2V5bSZGvZZC1u6dqqzZR1gZWjVd9IDUVrgdK7YJ9ARcIR/7NSaZb/Wixaa70qTeDNIeD8bDgY6vXcS/Ei84ABCBi43c4XhImocqtpLDOMOvRqwgBags26krKfx4aIZBpaGO6NWV6wN3f87UKUudmEvdXzzUMk7
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1454.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(451199021)(41300700001)(316002)(7416002)(82950400001)(82960400001)(921005)(5660300002)(10290500003)(30864003)(2906002)(478600001)(66899021)(66946007)(66476007)(66556008)(8676002)(8936002)(6666004)(6486002)(52116002)(86362001)(38350700002)(186003)(36756003)(2616005)(38100700002)(26005)(83380400001)(6506007)(6512007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nJWjIOlg60bqkmcuBvND+hTW/wyFUGVLhrJLPtuXvTogN6lA0wEPHpoLpWUy?=
 =?us-ascii?Q?b1mAkmAGRKVB/N6w8jBxQhxNeN5cYZ+X0eGosKB/g/L4ihGVBWk72A8F2fUA?=
 =?us-ascii?Q?pYfZV3NwzxDs/Yva4poqIvCUQY+7o4W0RopXXqmpu/G7R9sfeDOWtGU4y7+d?=
 =?us-ascii?Q?zlZ4KUA/3ObrXIzdTnycDvfIToYlxrqS8mAspmrqLfn1Y3Qdxc0djXO05Iwx?=
 =?us-ascii?Q?se72w9JT/qqk56tQ8KgQ05fMAycISJzjPg8T9ePnvByDAQFFIkyefke5OkYj?=
 =?us-ascii?Q?aH97yH/iUEAEtGPH3rVcOz0tnTSVuL/vTl1Zf9fyXrcst3wLz6BuiuQw/n1I?=
 =?us-ascii?Q?PuH4zRF2hGDhRKfR9nnHUcakVPmoQckoTo81K8XRR5Np7ve4WPaQ85m0Oiqy?=
 =?us-ascii?Q?TJm3JVbI9qNFxfxJUr2AFJMxB3lb1n2UbgvngnMEmqPuCwGEKLdAywMJIC9X?=
 =?us-ascii?Q?3wbx6PWcDqNcPoVsZ0QMOZwvY33eS/K40FqCP1czuxvcDz3o0TKO6BjfolRD?=
 =?us-ascii?Q?n3FylneBA3uScr90SwXvccPyyI0P7jKCsQLOqVqTPaGabAuy6Isp+xfTMDYg?=
 =?us-ascii?Q?z8D3C3TbT7rbXLVSCRTx0uSqIJkscMXV+25s2xWrb44PxcUdqTLs6U0Jsd9l?=
 =?us-ascii?Q?x+WLrU/v/HvCNsij74ZrR8iteR3Sv/QlAeScw+GRh/wMXiZiTbNzqG0MzHKh?=
 =?us-ascii?Q?kjjFZ+cNNkaWalVV1Jf7851VqBDsUhE0hUwVs4bHg+/Eet6JiBaWa/EgC08x?=
 =?us-ascii?Q?movlWuHDkbO+53FFctTJarcKn4kFrycYYumlyAhx9SurJUl/cIxZYOmZCapz?=
 =?us-ascii?Q?kIHWh9wdUdnTsG9aNkeGil4U7SJTfefE2G5Cod/EhfofC3jnqTEXsKORNpfM?=
 =?us-ascii?Q?3haFG1cvqWNFutpSSo7HzBVLXTjyZJPqSIU/9ZlbrPdf8MudPFxxhVoUkYx4?=
 =?us-ascii?Q?Tf+IuyW2GkhJPHycRaZBwxTki7SsTX4RSLWDj/1kb57Q1GdZzD6BxGEYyzia?=
 =?us-ascii?Q?RJ2ENWGDvlScQ3e7WZ4qcDUEHEfRb9aJZWtBvugzZRkRA0dzy0649LD/pm9r?=
 =?us-ascii?Q?Fmal5JUMgd0FsTCa3oS08k9RJQfJ02bvegb3JyR0XJJXxSOyFe7fiQBRJkbT?=
 =?us-ascii?Q?hBRvbheT60KIy1SaAXfQXqJ3LI7N4IiFNkAhVd1Tyh0yv+QvyrU5b6KF/nvz?=
 =?us-ascii?Q?uhUPXfboLPQlUc/ZbvRxueMGN3WHYvcOaKma1AEm0P/vgbIOBfofgov7SkBr?=
 =?us-ascii?Q?zn13XPp6lz3HcKC2dCHqDrfX4pimTY1S8amxTEruywr78ZBOogU/VdBSyTLE?=
 =?us-ascii?Q?v1zamKVuRuqK3ZpQ8A3uwyJIOGxeDee1ZF9nStBXqDVdxSezNiJ8yzOM+ob7?=
 =?us-ascii?Q?l4OlInNgV1mzsOrhGEiTot9SMAhh8QmQjnRbqBYe4W9NTRIvNuAl+sA8j01m?=
 =?us-ascii?Q?VfmeAZ1TlDdAj2v9S3FVTWtG4SGHcOL31B2+OSxgRfQFcy8WdaO072siL4ua?=
 =?us-ascii?Q?5HxkjUT0ZpVV3jn/8PgTEAh3uTG7tQtQge3JxPiF86otdp/M57mKiC7MkQFr?=
 =?us-ascii?Q?N4D9YDv/azfckdh7x5Qg4jrqcxIt3GkpAewwRK2T?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f91a496-6bcb-4c30-f0cf-08db65ba2114
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1454.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jun 2023 11:43:50.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0o60ROEZ5HnpgqkblAk5N8bVnayfV53EQmaB+OwPTawDEkEcezeTMqkOl/STKaDxz4KXTI5xBSGh9jtf9KGogg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3077
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add EQ interrupt support for mana ib driver. Allocate EQs per ucontext
to receive interrupt. Attach EQ when CQ is created. Call CQ interrupt
handler when completion interrupt happens. EQs are destroyed when
ucontext is deallocated.

The change calls some public APIs in mana ethernet driver to
allocate EQs and other resources. Ehe EQ process routine is also shared
by mana ethernet and mana ib drivers.

Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
Signed-off-by: Wei Hu <weh@microsoft.com>
---
 drivers/infiniband/hw/mana/cq.c               |  32 ++++-
 drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          |   4 +
 drivers/infiniband/hw/mana/qp.c               |  87 +++++++++++-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
 include/net/mana/gdma.h                       |   9 +-
 7 files changed, 287 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d141cab8a1e6..3cd680e0e753 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -12,13 +12,20 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	struct ib_device *ibdev = ibcq->device;
 	struct mana_ib_create_cq ucmd = {};
 	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	struct gdma_dev *gd;
 	int err;
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gd = mdev->gdma_dev;
+	gc = gd->gdma_context;
 
 	if (udata->inlen < sizeof(ucmd))
 		return -EINVAL;
 
+	cq->comp_vector = attr->comp_vector > gc->max_num_queues ?
+				0 : attr->comp_vector;
+
 	err = ib_copy_from_udata(&ucmd, udata, min(sizeof(ucmd), udata->inlen));
 	if (err) {
 		ibdev_dbg(ibdev,
@@ -69,11 +76,32 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 	struct ib_device *ibdev = ibcq->device;
 	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	struct gdma_dev *gd;
+
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gd = mdev->gdma_dev;
+	gc = gd->gdma_context;
 
-	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
-	ib_umem_release(cq->umem);
+
+
+	if (atomic_read(&ibcq->usecnt) == 0) {
+		mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
+		ibdev_dbg(ibdev, "freeing gdma cq %p\n", gc->cq_table[cq->id]);
+		kfree(gc->cq_table[cq->id]);
+		gc->cq_table[cq->id] = NULL;
+		ib_umem_release(cq->umem);
+	}
 
 	return 0;
 }
+
+void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq)
+{
+	struct mana_ib_cq *cq = ctx;
+	struct ib_device *ibdev = cq->ibcq.device;
+
+	ibdev_dbg(ibdev, "Enter %s %d\n", __func__, __LINE__);
+	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 7be4c3adb4e2..e4efbcaed10e 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -143,6 +143,81 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	return err;
 }
 
+static void mana_ib_destroy_eq(struct mana_ib_ucontext *ucontext,
+			       struct mana_ib_dev *mdev)
+{
+	struct gdma_context *gc = mdev->gdma_dev->gdma_context;
+	struct ib_device *ibdev = ucontext->ibucontext.device;
+	struct gdma_queue *eq;
+	int i;
+
+	if (!ucontext->eqs)
+		return;
+
+	for (i = 0; i < gc->max_num_queues; i++) {
+		eq = ucontext->eqs[i].eq;
+		if (!eq)
+			continue;
+
+		mana_gd_destroy_queue(gc, eq);
+	}
+
+	kfree(ucontext->eqs);
+	ucontext->eqs = NULL;
+
+	ibdev_dbg(ibdev, "destroyed eq's count %d\n", gc->max_num_queues);
+}
+
+static int mana_ib_create_eq(struct mana_ib_ucontext *ucontext,
+			     struct mana_ib_dev *mdev)
+{
+	struct gdma_queue_spec spec = {};
+	struct gdma_queue *queue;
+	struct gdma_context *gc;
+	struct ib_device *ibdev;
+	struct gdma_dev *gd;
+	int err;
+	int i;
+
+	if (!ucontext || !mdev)
+		return -EINVAL;
+
+	ibdev = ucontext->ibucontext.device;
+	gd = mdev->gdma_dev;
+
+	gc = gd->gdma_context;
+
+	ucontext->eqs = kcalloc(gc->max_num_queues, sizeof(struct mana_eq),
+				GFP_KERNEL);
+	if (!ucontext->eqs)
+		return -ENOMEM;
+
+	spec.type = GDMA_EQ;
+	spec.monitor_avl_buf = false;
+	spec.queue_size = EQ_SIZE;
+	spec.eq.callback = NULL;
+	spec.eq.context = ucontext->eqs;
+	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
+	spec.eq.msix_allocated = true;
+
+	for (i = 0; i < gc->max_num_queues; i++) {
+		spec.eq.msix_index = i;
+		err = mana_gd_create_mana_eq(gd, &spec, &queue);
+		if (err)
+			goto out;
+
+		queue->eq.disable_needed = true;
+		ucontext->eqs[i].eq = queue;
+	}
+
+	return 0;
+
+out:
+	ibdev_dbg(ibdev, "Failed to allocated eq err %d\n", err);
+	mana_ib_destroy_eq(ucontext, mdev);
+	return err;
+}
+
 static int mana_gd_destroy_doorbell_page(struct gdma_context *gc,
 					 int doorbell_page)
 {
@@ -225,7 +300,17 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 
 	ucontext->doorbell = doorbell_page;
 
+	ret = mana_ib_create_eq(ucontext, mdev);
+	if (ret) {
+		ibdev_dbg(ibdev, "Failed to create eq's , ret %d\n", ret);
+		goto err;
+	}
+
 	return 0;
+
+err:
+	mana_gd_destroy_doorbell_page(gc, doorbell_page);
+	return ret;
 }
 
 void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
@@ -240,6 +325,8 @@ void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
 	gc = mdev->gdma_dev->gdma_context;
 
+	mana_ib_destroy_eq(mana_ucontext, mdev);
+
 	ret = mana_gd_destroy_doorbell_page(gc, mana_ucontext->doorbell);
 	if (ret)
 		ibdev_dbg(ibdev, "Failed to destroy doorbell page %d\n", ret);
diff --git a/drivers/infiniband/hw/mana/mana_ib.h b/drivers/infiniband/hw/mana/mana_ib.h
index 502cc8672eef..9672fa1670a5 100644
--- a/drivers/infiniband/hw/mana/mana_ib.h
+++ b/drivers/infiniband/hw/mana/mana_ib.h
@@ -67,6 +67,7 @@ struct mana_ib_cq {
 	int cqe;
 	u64 gdma_region;
 	u64 id;
+	u32 comp_vector;
 };
 
 struct mana_ib_qp {
@@ -86,6 +87,7 @@ struct mana_ib_qp {
 struct mana_ib_ucontext {
 	struct ib_ucontext ibucontext;
 	u32 doorbell;
+	struct mana_eq *eqs;
 };
 
 struct mana_ib_rwq_ind_table {
@@ -159,4 +161,6 @@ int mana_ib_query_gid(struct ib_device *ibdev, u32 port, int index,
 
 void mana_ib_disassociate_ucontext(struct ib_ucontext *ibcontext);
 
+void mana_ib_cq_handler(void *ctx, struct gdma_queue *gdma_cq);
+
 #endif
diff --git a/drivers/infiniband/hw/mana/qp.c b/drivers/infiniband/hw/mana/qp.c
index 54b61930a7fd..0938085bded3 100644
--- a/drivers/infiniband/hw/mana/qp.c
+++ b/drivers/infiniband/hw/mana/qp.c
@@ -96,16 +96,20 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 	struct mana_ib_dev *mdev =
 		container_of(pd->device, struct mana_ib_dev, ib_dev);
+	struct ib_ucontext *ib_ucontext = pd->uobject->context;
 	struct ib_rwq_ind_table *ind_tbl = attr->rwq_ind_tbl;
 	struct mana_ib_create_qp_rss_resp resp = {};
 	struct mana_ib_create_qp_rss ucmd = {};
+	struct mana_ib_ucontext *mana_ucontext;
 	struct gdma_dev *gd = mdev->gdma_dev;
 	mana_handle_t *mana_ind_table;
 	struct mana_port_context *mpc;
+	struct gdma_queue *gdma_cq;
 	struct mana_context *mc;
 	struct net_device *ndev;
 	struct mana_ib_cq *cq;
 	struct mana_ib_wq *wq;
+	struct mana_eq *eq;
 	unsigned int ind_tbl_size;
 	struct ib_cq *ibcq;
 	struct ib_wq *ibwq;
@@ -114,6 +118,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 	int ret;
 
 	mc = gd->driver_data;
+	mana_ucontext =
+		container_of(ib_ucontext, struct mana_ib_ucontext, ibucontext);
 
 	if (!udata || udata->inlen < sizeof(ucmd))
 		return -EINVAL;
@@ -180,6 +186,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 	for (i = 0; i < ind_tbl_size; i++) {
 		struct mana_obj_spec wq_spec = {};
 		struct mana_obj_spec cq_spec = {};
+		unsigned int max_num_queues = gd->gdma_context->max_num_queues;
 
 		ibwq = ind_tbl->ind_tbl[i];
 		wq = container_of(ibwq, struct mana_ib_wq, ibwq);
@@ -193,7 +200,8 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		cq_spec.gdma_region = cq->gdma_region;
 		cq_spec.queue_size = cq->cqe * COMP_ENTRY_SIZE;
 		cq_spec.modr_ctx_id = 0;
-		cq_spec.attached_eq = GDMA_CQ_NO_EQ;
+		eq = &mana_ucontext->eqs[cq->comp_vector % max_num_queues];
+		cq_spec.attached_eq = eq->eq->id;
 
 		ret = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_RQ,
 					 &wq_spec, &cq_spec, &wq->rx_object);
@@ -207,6 +215,9 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		wq->id = wq_spec.queue_index;
 		cq->id = cq_spec.queue_index;
 
+		ibdev_dbg(&mdev->ib_dev, "attached eq id %u  cq with id %llu\n",
+			eq->eq->id, cq->id);
+
 		ibdev_dbg(&mdev->ib_dev,
 			  "ret %d rx_object 0x%llx wq id %llu cq id %llu\n",
 			  ret, wq->rx_object, wq->id, cq->id);
@@ -215,6 +226,26 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		resp.entries[i].wqid = wq->id;
 
 		mana_ind_table[i] = wq->rx_object;
+
+		if (gd->gdma_context->cq_table[cq->id] == NULL) {
+
+			gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+			if (!gdma_cq) {
+				ibdev_dbg(&mdev->ib_dev,
+					 "failed to allocate gdma_cq\n");
+				goto free_cq;
+			}
+
+			ibdev_dbg(&mdev->ib_dev, "gdma cq allocated %p\n",
+				  gdma_cq);
+
+			gdma_cq->cq.context = cq;
+			gdma_cq->type = GDMA_CQ;
+			gdma_cq->cq.callback = mana_ib_cq_handler;
+			gdma_cq->id = cq->id;
+			gd->gdma_context->cq_table[cq->id] = gdma_cq;
+		}
+
 	}
 	resp.num_entries = i;
 
@@ -224,7 +255,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 					 ucmd.rx_hash_key_len,
 					 ucmd.rx_hash_key);
 	if (ret)
-		goto fail;
+		goto free_cq;
 
 	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
 	if (ret) {
@@ -238,6 +269,23 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 
 	return 0;
 
+free_cq:
+	{
+		int j = i;
+		u64 cqid;
+
+		while (j-- > 0) {
+			cqid = resp.entries[j].cqid;
+			gdma_cq = gd->gdma_context->cq_table[cqid];
+			cq = gdma_cq->cq.context;
+			if (atomic_read(&cq->ibcq.usecnt) == 0) {
+				kfree(gd->gdma_context->cq_table[cqid]);
+				gd->gdma_context->cq_table[cqid] = NULL;
+			}
+		}
+
+	}
+
 fail:
 	while (i-- > 0) {
 		ibwq = ind_tbl->ind_tbl[i];
@@ -269,10 +317,12 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	struct mana_obj_spec wq_spec = {};
 	struct mana_obj_spec cq_spec = {};
 	struct mana_port_context *mpc;
+	struct gdma_queue *gdma_cq;
 	struct mana_context *mc;
 	struct net_device *ndev;
 	struct ib_umem *umem;
-	int err;
+	struct mana_eq *eq;
+	int err, eq_vec;
 	u32 port;
 
 	mc = gd->driver_data;
@@ -350,7 +400,9 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	cq_spec.gdma_region = send_cq->gdma_region;
 	cq_spec.queue_size = send_cq->cqe * COMP_ENTRY_SIZE;
 	cq_spec.modr_ctx_id = 0;
-	cq_spec.attached_eq = GDMA_CQ_NO_EQ;
+	eq_vec = send_cq->comp_vector % gd->gdma_context->max_num_queues;
+	eq = &mana_ucontext->eqs[eq_vec];
+	cq_spec.attached_eq = eq->eq->id;
 
 	err = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_SQ, &wq_spec,
 				 &cq_spec, &qp->tx_object);
@@ -368,6 +420,24 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	qp->sq_id = wq_spec.queue_index;
 	send_cq->id = cq_spec.queue_index;
 
+	if (gd->gdma_context->cq_table[send_cq->id] == NULL) {
+
+		gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+		if (!gdma_cq) {
+			pr_err("failed to allocate gdma_cq\n");
+			goto err_destroy_wqobj_and_cq;
+		}
+
+		pr_debug("gdma cq allocated %p\n", gdma_cq);
+		gdma_cq->cq.context = send_cq;
+		gdma_cq->type = GDMA_CQ;
+		gdma_cq->cq.callback = mana_ib_cq_handler;
+		gdma_cq->id = send_cq->id;
+		gd->gdma_context->cq_table[send_cq->id] = gdma_cq;
+	} else {
+		gdma_cq = gd->gdma_context->cq_table[send_cq->id];
+	}
+
 	ibdev_dbg(&mdev->ib_dev,
 		  "ret %d qp->tx_object 0x%llx sq id %llu cq id %llu\n", err,
 		  qp->tx_object, qp->sq_id, send_cq->id);
@@ -381,12 +451,17 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 		ibdev_dbg(&mdev->ib_dev,
 			  "Failed copy udata for create qp-raw, %d\n",
 			  err);
-		goto err_destroy_wq_obj;
+		goto err_destroy_wqobj_and_cq;
 	}
 
 	return 0;
 
-err_destroy_wq_obj:
+err_destroy_wqobj_and_cq:
+	if (atomic_read(&send_cq->ibcq.usecnt) == 0) {
+		kfree(gdma_cq);
+		gd->gdma_context->cq_table[send_cq->id] = NULL;
+	}
+
 	mana_destroy_wq_obj(mpc, GDMA_SQ, qp->tx_object);
 
 err_destroy_dma_region:
diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 8f3f78b68592..8231d77628d9 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -368,53 +368,57 @@ static void mana_gd_process_eqe(struct gdma_queue *eq)
 	}
 }
 
-static void mana_gd_process_eq_events(void *arg)
+static void mana_gd_process_eq_events(struct list_head *eq_list)
 {
 	u32 owner_bits, new_bits, old_bits;
 	union gdma_eqe_info eqe_info;
 	struct gdma_eqe *eq_eqe_ptr;
-	struct gdma_queue *eq = arg;
 	struct gdma_context *gc;
+	struct gdma_queue *eq;
 	struct gdma_eqe *eqe;
 	u32 head, num_eqe;
 	int i;
 
-	gc = eq->gdma_dev->gdma_context;
+	list_for_each_entry_rcu(eq, eq_list, entry) {
+		gc = eq->gdma_dev->gdma_context;
 
-	num_eqe = eq->queue_size / GDMA_EQE_SIZE;
-	eq_eqe_ptr = eq->queue_mem_ptr;
+		num_eqe = eq->queue_size / GDMA_EQE_SIZE;
+		eq_eqe_ptr = eq->queue_mem_ptr;
 
-	/* Process up to 5 EQEs at a time, and update the HW head. */
-	for (i = 0; i < 5; i++) {
-		eqe = &eq_eqe_ptr[eq->head % num_eqe];
-		eqe_info.as_uint32 = eqe->eqe_info;
-		owner_bits = eqe_info.owner_bits;
+		/* Process up to 5 EQEs at a time, and update the HW head. */
+		for (i = 0; i < 5; i++) {
+			eqe = &eq_eqe_ptr[eq->head % num_eqe];
+			eqe_info.as_uint32 = eqe->eqe_info;
+			owner_bits = eqe_info.owner_bits;
 
-		old_bits = (eq->head / num_eqe - 1) & GDMA_EQE_OWNER_MASK;
-		/* No more entries */
-		if (owner_bits == old_bits)
-			break;
+			old_bits =
+				(eq->head / num_eqe - 1) & GDMA_EQE_OWNER_MASK;
+			/* No more entries */
+			if (owner_bits == old_bits)
+				break;
 
-		new_bits = (eq->head / num_eqe) & GDMA_EQE_OWNER_MASK;
-		if (owner_bits != new_bits) {
-			dev_err(gc->dev, "EQ %d: overflow detected\n", eq->id);
-			break;
-		}
+			new_bits = (eq->head / num_eqe) & GDMA_EQE_OWNER_MASK;
+			if (owner_bits != new_bits) {
+				dev_err(gc->dev, "EQ %d: overflow detected\n",
+					eq->id);
+				break;
+			}
 
-		/* Per GDMA spec, rmb is necessary after checking owner_bits, before
-		 * reading eqe.
-		 */
-		rmb();
+			/* Per GDMA spec, rmb is necessary after checking
+			 * owner_bits, before reading eqe.
+			 */
+			rmb();
 
-		mana_gd_process_eqe(eq);
+			mana_gd_process_eqe(eq);
 
-		eq->head++;
-	}
+			eq->head++;
+		}
 
-	head = eq->head % (num_eqe << GDMA_EQE_OWNER_BITS);
+		head = eq->head % (num_eqe << GDMA_EQE_OWNER_BITS);
 
-	mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type, eq->id,
-			      head, SET_ARM_BIT);
+		mana_gd_ring_doorbell(gc, eq->gdma_dev->doorbell, eq->type,
+				      eq->id, head, SET_ARM_BIT);
+	}
 }
 
 static int mana_gd_register_irq(struct gdma_queue *queue,
@@ -432,44 +436,49 @@ static int mana_gd_register_irq(struct gdma_queue *queue,
 	gc = gd->gdma_context;
 	r = &gc->msix_resource;
 	dev = gc->dev;
+	msi_index = spec->eq.msix_index;
 
 	spin_lock_irqsave(&r->lock, flags);
 
-	msi_index = find_first_zero_bit(r->map, r->size);
-	if (msi_index >= r->size || msi_index >= gc->num_msix_usable) {
-		err = -ENOSPC;
-	} else {
-		bitmap_set(r->map, msi_index, 1);
-		queue->eq.msix_index = msi_index;
-	}
-
-	spin_unlock_irqrestore(&r->lock, flags);
+	if (!spec->eq.msix_allocated) {
+		msi_index = find_first_zero_bit(r->map, r->size);
+		if (msi_index >= r->size || msi_index >= gc->num_msix_usable)
+			err = -ENOSPC;
+		else
+			bitmap_set(r->map, msi_index, 1);
 
-	if (err) {
-		dev_err(dev, "Register IRQ err:%d, msi:%u rsize:%u, nMSI:%u",
-			err, msi_index, r->size, gc->num_msix_usable);
+		if (err) {
+			dev_err(dev, "Register IRQ err:%d, msi:%u rsize:%u, nMSI:%u",
+				err, msi_index, r->size, gc->num_msix_usable);
 
-		return err;
+			goto out;
+		}
 	}
 
+	queue->eq.msix_index = msi_index;
 	gic = &gc->irq_contexts[msi_index];
 
-	WARN_ON(gic->handler || gic->arg);
+	list_add_rcu(&queue->entry, &gic->eq_list);
 
-	gic->arg = queue;
+	WARN_ON(gic->handler);
 
 	gic->handler = mana_gd_process_eq_events;
 
-	return 0;
+out:
+	spin_unlock_irqrestore(&r->lock, flags);
+
+	return err;
 }
 
-static void mana_gd_deregiser_irq(struct gdma_queue *queue)
+static void mana_gd_deregister_irq(struct gdma_queue *queue)
 {
 	struct gdma_dev *gd = queue->gdma_dev;
 	struct gdma_irq_context *gic;
 	struct gdma_context *gc;
 	struct gdma_resource *r;
 	unsigned int msix_index;
+	struct list_head *p, *n;
+	struct gdma_queue *eq;
 	unsigned long flags;
 
 	gc = gd->gdma_context;
@@ -480,13 +489,25 @@ static void mana_gd_deregiser_irq(struct gdma_queue *queue)
 	if (WARN_ON(msix_index >= gc->num_msix_usable))
 		return;
 
+	spin_lock_irqsave(&r->lock, flags);
+
 	gic = &gc->irq_contexts[msix_index];
-	gic->handler = NULL;
-	gic->arg = NULL;
 
-	spin_lock_irqsave(&r->lock, flags);
-	bitmap_clear(r->map, msix_index, 1);
+	list_for_each_safe(p, n, &gic->eq_list) {
+		eq = list_entry(p, struct gdma_queue, entry);
+		if (queue == eq) {
+			list_del_rcu(&eq->entry);
+			break;
+		}
+	}
+
+	if (list_empty(&gic->eq_list)) {
+		gic->handler = NULL;
+		bitmap_clear(r->map, msix_index, 1);
+	}
+
 	spin_unlock_irqrestore(&r->lock, flags);
+	synchronize_rcu();
 
 	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
 }
@@ -550,7 +571,7 @@ static void mana_gd_destroy_eq(struct gdma_context *gc, bool flush_evenets,
 			dev_warn(gc->dev, "Failed to flush EQ: %d\n", err);
 	}
 
-	mana_gd_deregiser_irq(queue);
+	mana_gd_deregister_irq(queue);
 
 	if (queue->eq.disable_needed)
 		mana_gd_disable_queue(queue);
@@ -565,7 +586,7 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
 	u32 log2_num_entries;
 	int err;
 
-	queue->eq.msix_index = INVALID_PCI_MSIX_INDEX;
+	queue->eq.msix_index = spec->eq.msix_index;
 
 	log2_num_entries = ilog2(queue->queue_size / GDMA_EQE_SIZE);
 
@@ -602,6 +623,7 @@ static int mana_gd_create_eq(struct gdma_dev *gd,
 	mana_gd_destroy_eq(gc, false, queue);
 	return err;
 }
+EXPORT_SYMBOL(mana_gd_create_mana_eq);
 
 static void mana_gd_create_cq(const struct gdma_queue_spec *spec,
 			      struct gdma_queue *queue)
@@ -873,6 +895,7 @@ void mana_gd_destroy_queue(struct gdma_context *gc, struct gdma_queue *queue)
 	mana_gd_free_memory(gmi);
 	kfree(queue);
 }
+EXPORT_SYMBOL(mana_gd_destroy_queue);
 
 int mana_gd_verify_vf_version(struct pci_dev *pdev)
 {
@@ -1188,7 +1211,7 @@ static irqreturn_t mana_gd_intr(int irq, void *arg)
 	struct gdma_irq_context *gic = arg;
 
 	if (gic->handler)
-		gic->handler(gic->arg);
+		gic->handler(&gic->eq_list);
 
 	return IRQ_HANDLED;
 }
@@ -1241,7 +1264,7 @@ static int mana_gd_setup_irqs(struct pci_dev *pdev)
 	for (i = 0; i < nvec; i++) {
 		gic = &gc->irq_contexts[i];
 		gic->handler = NULL;
-		gic->arg = NULL;
+		INIT_LIST_HEAD(&gic->eq_list);
 
 		if (!i)
 			snprintf(gic->name, MANA_IRQ_NAME_SZ, "mana_hwc@pci:%s",
diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 06d6292e09b3..85345225813f 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1156,6 +1156,7 @@ static int mana_create_eq(struct mana_context *ac)
 	spec.eq.callback = NULL;
 	spec.eq.context = ac->eqs;
 	spec.eq.log2_throttle_limit = LOG2_EQ_THROTTLE;
+	spec.eq.msix_allocated = false;
 
 	for (i = 0; i < gc->max_num_queues; i++) {
 		err = mana_gd_create_mana_eq(gd, &spec, &ac->eqs[i].eq);
diff --git a/include/net/mana/gdma.h b/include/net/mana/gdma.h
index 96c120160f15..cc728fc42043 100644
--- a/include/net/mana/gdma.h
+++ b/include/net/mana/gdma.h
@@ -6,6 +6,7 @@
 
 #include <linux/dma-mapping.h>
 #include <linux/netdevice.h>
+#include <linux/list.h>
 
 #include "shm_channel.h"
 
@@ -291,6 +292,8 @@ struct gdma_queue {
 	u32 head;
 	u32 tail;
 
+	struct list_head entry;
+
 	/* Extra fields specific to EQ/CQ. */
 	union {
 		struct {
@@ -325,6 +328,8 @@ struct gdma_queue_spec {
 			void *context;
 
 			unsigned long log2_throttle_limit;
+			bool msix_allocated;
+			unsigned int msix_index;
 		} eq;
 
 		struct {
@@ -340,8 +345,8 @@ struct gdma_queue_spec {
 #define MANA_IRQ_NAME_SZ 32
 
 struct gdma_irq_context {
-	void (*handler)(void *arg);
-	void *arg;
+	void (*handler)(struct list_head *arg);
+	struct list_head eq_list;
 	char name[MANA_IRQ_NAME_SZ];
 };
 
-- 
2.25.1


