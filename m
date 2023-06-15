Return-Path: <netdev+bounces-11060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CCCD731641
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:15:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA2D92812F1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 11:15:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A0B883B;
	Thu, 15 Jun 2023 11:15:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCB5820EE
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 11:15:32 +0000 (UTC)
Received: from BN3PR00CU001.outbound.protection.outlook.com (mail-eastus2azon11020023.outbound.protection.outlook.com [52.101.56.23])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F99A2705;
	Thu, 15 Jun 2023 04:15:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BWvh98eiko/AWIlI3nIuiWTMlYf88enC3N8jxx0sCfi8Su0Me0MPvLeYlulGOosfndp416ntJtx+zP2PSskMgSEq8dZbwU4cUWXhGiDmDfgBGi916HaM2xOGq31eJnQpTgMF1zAfxzthYM3I9osL2p3k7HL7t/0EqAoZCX4Ngox2Bi9u/b9caIQYNjic2rXjLd4ejhvVUOsiLPI/wFRXZYxKPeDsIA60AR+/gCYvYcrSlexLS3JkRTbuxV6I2Ublh5IQLLm1Awu1Dqo14WEm44zywXwtDO/EoCgcEJ+rDJoMyPXRcTB7mCArk91t109VxdFtGOmW/9sOcMvM9fiNIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vdiOMD8Jl5iy20VW89PFFyrHgbVBwG76IEVD8/wCmdM=;
 b=LWxV3zm4Bpex4K3q23lh9icwJTzLaWv+Xunv9sP/78Tn4MuL8M/uzmv7npKoYLFKwTH6EPVFNfUmQ/m3j9g/HBJxL2tNNgUXHJ2Bz22l8xS/42FsxYBWEeMuRNTsCZzSYPz+yjvqjmefhik02meWH+KSsitCfOKOrE7WlR3DFvePbqHHb5JeWE+TsBJCYa6Ebi9kbwemf4HvrpsYXu+oYa4gr/QJWwI+LwtSna9/t4+PpMRkd+9H126BdHKVJu+RBJvmYYZt6Cs9LvyEyyZeUwGqQ3PfXlkp12YO8osmR1oO0VVQGHPguJmlX1fBBUAwdpj0eBQFLQbzmnZGLkWgtw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdiOMD8Jl5iy20VW89PFFyrHgbVBwG76IEVD8/wCmdM=;
 b=Ytu8WozEJrXLQd4sctgVaj9+t5zVtqOTKmIYHip35Tbq5ZDU8/Xs4qMC1Lhmdqgred4aFnxQWSsB8OdiQ+PBk9OJgMU4Kk7ugSOUfwQaWR6lP7xWCFzZ0TzwUUCihqavJhLGT5e1Tv0Vj2+JW6WP5/hc0iBLwaGvx2dzNt0WkUU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from MN2PR21MB1454.namprd21.prod.outlook.com (2603:10b6:208:208::11)
 by DS7PR21MB3526.namprd21.prod.outlook.com (2603:10b6:8:91::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.2; Thu, 15 Jun
 2023 11:15:25 +0000
Received: from MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9]) by MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9%4]) with mapi id 15.20.6521.009; Thu, 15 Jun 2023
 11:15:25 +0000
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
Subject: [PATCH v3 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib driver.
Date: Thu, 15 Jun 2023 11:14:12 +0000
Message-Id: <20230615111412.1687573-1-weh@microsoft.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0002.namprd10.prod.outlook.com
 (2603:10b6:510:23d::28) To MN2PR21MB1454.namprd21.prod.outlook.com
 (2603:10b6:208:208::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR21MB1454:EE_|DS7PR21MB3526:EE_
X-MS-Office365-Filtering-Correlation-Id: ed046288-5055-4157-d1af-08db6d91cfb7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XVcMcppTlyyLO1XXdY+eDRSrA0IOUHJapFf5KN/qs4ol8p07c0FLAn43FKCGkIuLWC6KT23DwVA07sMQfqTO5zrSUO0TTkl8gFTYxTXeZBtuemlcAOXmDdi2Kz4A7676/DT89SnEotA2e76x6fXePPLLociG0OKDtRlEv+/+oPlRj9Le/4EyQiGiPy6tX+6fC/4eRE3h4vMVlkXMsQsojz0yAaUyfi2IDFdEtnl1+uCb57/Se9l102dm0PbklpMovSbqYOM4sWUBVU8rOno6WoC877kh0SspYNW0nEXsum5gIJznqQQuyu5oV2+rOPYruN6Fo7NwAPxTQbGmglPZ30pWT6Ar+sJ80VcnZN/ZT9fknzhfHwpDDqFZ2wm6uLsoknaa7aqcKaojvN1IbmNfhUwP4UyhSSfX/eLe1LgT1gK0F0vXfq1fIz+jRL2g5+81wipNQd6dMVGodrJf96kWMumjNlAlTlIrBW8XKa3FCsnfo4mZx/mruhTjYkVhVvKHpXqgtUaX6FZGlPYm2jE+mfp1Ud/p1x8az6IpGWsHCu1iTd2scQxSrNLkj3n/P/mwNOQCt1yFqlUS5iyIzTetaYwYp8A+TnchosjhkG58yxvkzc+Pqif1hs+ATqt6SudO2OOlXwRtKzMApcXqKmKZR41Pp4E7khz8MGqlZG8XI0kN1dGNJHyx2w03hcB38xPC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1454.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(451199021)(86362001)(7416002)(6486002)(8676002)(316002)(41300700001)(38100700002)(52116002)(5660300002)(26005)(82960400001)(83380400001)(82950400001)(38350700002)(6512007)(1076003)(921005)(6506007)(8936002)(6666004)(66556008)(66476007)(36756003)(66946007)(478600001)(186003)(2906002)(30864003)(66899021)(2616005)(10290500003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?xCKqzvolGCl/9SLl8ylVa9hM3bcT2RNIPiMEJ1BXv34aMzmbU5cMVBlwDYQy?=
 =?us-ascii?Q?2E9cYlsFhQnHk5PcA0+zLISKYa7X3sXQzLzYosddhiKUaT5JvZQTisPJzxm6?=
 =?us-ascii?Q?MRa1z0x/7yDYLq3q3dwo/aU7t1swbKkfmjmUYh/g7+THUIeLovVsmu4NLzmf?=
 =?us-ascii?Q?A5njonmS7ENO0we4Ja00lK31dDUz1UmjaJCQXyRIVrm0DVQVdUnr3vE2Fv9C?=
 =?us-ascii?Q?aQKB3erxO6b87VYDNbpbcoWKTbphf3oGowsY/TGgUOYwbLvxlspUxWiUx0/h?=
 =?us-ascii?Q?ka6x/R3uls5KkItG0q73yhBfkRTe3R+zuHfBIMGLVAC5UQm03PSyvhu4mprW?=
 =?us-ascii?Q?rNrUklQi8IIsBJE7L/DiPPhVdCYsbPurgAFvZdBwYKIS6E1YHdmNdCPEPr2u?=
 =?us-ascii?Q?EwtvgpabomI0B1IBWyPl5N2vZndsENutITUUdVZ6kDI19Wo+UIbZsJTVFwXR?=
 =?us-ascii?Q?aj033PKe+V5hSKJY/YycBPr/4jfrrmzVfWubr+5QrK5d1WYgN2iVcpKLOxhl?=
 =?us-ascii?Q?d5Qi0wstm0UJAx3UY4o6MxpXztiPFd5clmLOOqYfw7dNqIhZTSotfmc97mPh?=
 =?us-ascii?Q?7kZ22HJSmPRKkoLNXuBkw5CxlNH6ylrSv3UjMW1lPkhGpPdi5M8QcdYP0l0c?=
 =?us-ascii?Q?x7/JJnCmtpeny02NP8BPlsQeyIvNIoZBy2PPk3sHCI/k9+NqDeJfZF/ayxBM?=
 =?us-ascii?Q?uXv9LymcAGjosmZgJyRaKyOAxuNBLrTADgyyevQnRmOKyk6veg5euyfEdI81?=
 =?us-ascii?Q?B67uE1sRz7kFk9HjchU3AJQX6nccM/gpcz5yZuWaT3aCmqbO5aB2btJ155zZ?=
 =?us-ascii?Q?NS4fQVZlbBYQnANO1OT+vVqQ/s5pb3xjVjlNNsIkzk2W5ttjR3RfzOwz6Ex1?=
 =?us-ascii?Q?9GlsG1WU5+m0NK1Q/ZGINhiYi03/oaRkBnE3+Xt7m/GYewEnvbPOdbnsdmQA?=
 =?us-ascii?Q?0mBJQcTK8Mcli80eAp9YsY7Ne5GvwM5qbsAQCpcAgO9iTGfv0mRDJeOTdEth?=
 =?us-ascii?Q?jG5Qa0MLqoegrdoAk5i0PMrjx4/srY1+PgAW6Eg+aHLv4v1q2lJSJJH8sPLX?=
 =?us-ascii?Q?+nkij1jj/ghi3E+CHkubaDu0EzrLDldqVuocO1vRZSnl6A/CuL/y26BD4J+O?=
 =?us-ascii?Q?kmNYFSteWhT72b1tB13XOPRGWr7T//so3XXZAtGQMAPR/B5ELyOBY802Rlja?=
 =?us-ascii?Q?whfMqXjGdwPXsH8zSxCLu+7q/g2MJzc8M7Nl1W8+LUzuTasjCCg94nXVmkkm?=
 =?us-ascii?Q?eDlwC6ooL/zpVpxPmWo88iez5urpEAhmbF4DF5uwoaiMbxTvIbDtuIFJa4qX?=
 =?us-ascii?Q?pHSnk2zKQhOSBHQm+v4D7GHMqewhNx2aZPl7pHvBOSdAna455C59p7T1HrWR?=
 =?us-ascii?Q?1x/Qy2rP8KsGwj09X9eynABEw9s5n0LTkqSAFiyC0hD5/5Zks+BK3Hnxm5W5?=
 =?us-ascii?Q?86KMZuXZxIgoPYVn58/DQhAYfV1sIjw37aa27mO6F8MOH5uY9iaeybkZ705Q?=
 =?us-ascii?Q?bqCTHBlkDksUZbFN9KM0xPpyYFL2kAzQV4Ac5Ku/Cz4qUKD7UDu5wo6MPQLm?=
 =?us-ascii?Q?72BdkITQskxDKkKooaV9bcVmEj+leysr/3gGwSVx?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed046288-5055-4157-d1af-08db6d91cfb7
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1454.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 11:15:23.8646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vXNA1UMp3OBm5OkVZHtMeK0874E80K7JYSV8+Qi1Ni8uDNrYHhejNK5zLcxgoe6rMWDDeANhaVuiajKCu8lfIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR21MB3526
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
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

v2: Use ibdev_dbg to print error messages and return -ENOMEN
    when kzalloc fails.

v3: Check return value on mana_ib_gd_destroy_dma_region(). Remove most
    debug prints.

 drivers/infiniband/hw/mana/cq.c               |  35 ++++-
 drivers/infiniband/hw/mana/main.c             |  85 ++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          |   4 +
 drivers/infiniband/hw/mana/qp.c               |  79 ++++++++++-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
 include/net/mana/gdma.h                       |   9 +-
 7 files changed, 280 insertions(+), 64 deletions(-)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index d141cab8a1e6..b6f61cd2d5eb 100644
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
@@ -69,11 +76,35 @@ int mana_ib_destroy_cq(struct ib_cq *ibcq, struct ib_udata *udata)
 	struct mana_ib_cq *cq = container_of(ibcq, struct mana_ib_cq, ibcq);
 	struct ib_device *ibdev = ibcq->device;
 	struct mana_ib_dev *mdev;
+	struct gdma_context *gc;
+	struct gdma_dev *gd;
+	int err;
+
 
 	mdev = container_of(ibdev, struct mana_ib_dev, ib_dev);
+	gd = mdev->gdma_dev;
+	gc = gd->gdma_context;
+
 
-	mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
-	ib_umem_release(cq->umem);
+
+	if (atomic_read(&ibcq->usecnt) == 0) {
+		err = mana_ib_gd_destroy_dma_region(mdev, cq->gdma_region);
+		if (err) {
+			ibdev_dbg(ibdev,
+				  "Faile to destroy dma region, %d\n", err);
+			return err;
+		}
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
+
+	cq->ibcq.comp_handler(&cq->ibcq, cq->ibcq.cq_context);
+}
diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 7be4c3adb4e2..e2affb6ae5ad 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -143,6 +143,79 @@ int mana_ib_dealloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
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
@@ -225,7 +298,17 @@ int mana_ib_alloc_ucontext(struct ib_ucontext *ibcontext,
 
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
@@ -240,6 +323,8 @@ void mana_ib_dealloc_ucontext(struct ib_ucontext *ibcontext)
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
index 54b61930a7fd..b8fcb7a8eae0 100644
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
@@ -215,6 +223,22 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		resp.entries[i].wqid = wq->id;
 
 		mana_ind_table[i] = wq->rx_object;
+
+		if (gd->gdma_context->cq_table[cq->id] == NULL) {
+
+			gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+			if (!gdma_cq) {
+				ret = -ENOMEM;
+				goto free_cq;
+			}
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
 
@@ -224,7 +248,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 					 ucmd.rx_hash_key_len,
 					 ucmd.rx_hash_key);
 	if (ret)
-		goto fail;
+		goto free_cq;
 
 	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
 	if (ret) {
@@ -238,6 +262,23 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 
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
@@ -269,10 +310,12 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
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
@@ -350,7 +393,9 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	cq_spec.gdma_region = send_cq->gdma_region;
 	cq_spec.queue_size = send_cq->cqe * COMP_ENTRY_SIZE;
 	cq_spec.modr_ctx_id = 0;
-	cq_spec.attached_eq = GDMA_CQ_NO_EQ;
+	eq_vec = send_cq->comp_vector % gd->gdma_context->max_num_queues;
+	eq = &mana_ucontext->eqs[eq_vec];
+	cq_spec.attached_eq = eq->eq->id;
 
 	err = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_SQ, &wq_spec,
 				 &cq_spec, &qp->tx_object);
@@ -368,6 +413,23 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	qp->sq_id = wq_spec.queue_index;
 	send_cq->id = cq_spec.queue_index;
 
+	if (gd->gdma_context->cq_table[send_cq->id] == NULL) {
+
+		gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+		if (!gdma_cq) {
+			err = -ENOMEM;
+			goto err_destroy_wqobj_and_cq;
+		}
+
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
@@ -381,12 +443,17 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
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


