Return-Path: <netdev+bounces-8530-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D6F724775
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:18:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CEC68280FD3
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05BA22DBC1;
	Tue,  6 Jun 2023 15:18:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E847137B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:18:51 +0000 (UTC)
Received: from BN6PR00CU002.outbound.protection.outlook.com (mail-eastus2azon11021026.outbound.protection.outlook.com [52.101.57.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0C21B5;
	Tue,  6 Jun 2023 08:18:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UNTKCVMZsiYRkdw/7elVErcFLLC9DpUurOdrF0Y39rORr/y6FASeC+NAXpNdZk3kI7R4kSTTt0qXnqUj3oeG8KdfXvVuhLSjxiXmJDeYDnNHVI/Ci4INsWiwOjC2dzCfDQtHVnHKQ+8THVpb9nWaDmw++TRTbytmGvK6zewFBAGbvKql5IHLNNZFW62gth+tf38cFHFrywvLRt6zBP1AYfVi2/f5tD9WS+mdxrqPwHVMJ14yuQSvfxMQ8a5uH95cdMcgOdb+tyicQ7ASsuI453koyXfL/G+4dBo6Un1IHlekcLYH76ap3Ar6j1IsMpbKuY9tb6r6w87Weveq2OMWAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=40jfHFcfip9qBLpqXbUGN/gVINPZ9Rv0gQB4Fd7merA=;
 b=PIHCV5+XeSPKORsTSpfacQtlzFXDlK0aH5Z/p+t22iv96L6cT6JvUx7z+fhdek+sBLkm4oyNYJf9X3vYbPA6Al5JN3+0mJ8ktrZvqoQVFA+zLie0xZkDAOVmQo1L9ScJwevZ+mcQofhSyDjfOGke+jGTjP8LRVQWp2ETtlMn7z8HLMnFcl0i2LMIBgALUcqy/BWOqfyKdGGUyu23IxJgsYcLSvMJxvibxyCUAb9qVeNmpTbVsKGxyjX71ExF9OAdDvZWMaaZ0gTp6WcyYN1TT23Bujf+n4PJgtEOKgrlSWl76+/Ibr5pns1cd4UO7JfvJlFtEa9eZm9F+JDXm01bEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40jfHFcfip9qBLpqXbUGN/gVINPZ9Rv0gQB4Fd7merA=;
 b=jOj63+EXXVqXJ+GYlCBo7d9EvRjV6wAcEuPFQanNqEratIIMVlXG8OV41Q8psCyUrH7z+A6AK4C4/d4PMMEqsL8JcxkzpAiXmzNaeHD/qoliB2c2fJnO0+2SP6NThwwIxbRWYyMkpdyqmpzcJwLShmzB1aTq5Gw6Y5zudBcQhUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
Received: from MN2PR21MB1454.namprd21.prod.outlook.com (2603:10b6:208:208::11)
 by DM6PR21MB1483.namprd21.prod.outlook.com (2603:10b6:5:25c::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.7; Tue, 6 Jun
 2023 15:18:45 +0000
Received: from MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9]) by MN2PR21MB1454.namprd21.prod.outlook.com
 ([fe80::5108:edcf:df0:4cf9%4]) with mapi id 15.20.6500.004; Tue, 6 Jun 2023
 15:18:45 +0000
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
Subject: [PATCH v2 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib driver.
Date: Tue,  6 Jun 2023 15:17:47 +0000
Message-Id: <20230606151747.1649305-1-weh@microsoft.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0210.namprd05.prod.outlook.com
 (2603:10b6:a03:330::35) To MN2PR21MB1454.namprd21.prod.outlook.com
 (2603:10b6:208:208::11)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR21MB1454:EE_|DM6PR21MB1483:EE_
X-MS-Office365-Filtering-Correlation-Id: 61508912-2117-451c-499b-08db66a15157
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IWihzrnRjrsBnhMtQYZ4HO1Lg547bkx0nl63BZvZuFS/mpLVpFVcKaIprkI7Iuf3cdwO5nFrI9UmoPv9YGVA6K5QZ1oBqpLkWYgXBG7+AMRsrjELJA17lmbAf9Vn1jU4X+loiZNId4ys34Nhu8q5LOP/MkplZ55zbxsK1pYQ+rxIab0OV6bK/iuKPTcMDgjyr6ji/Ng4rHfcUp2yT2zZTzhRtsQTT1qB0adOePmJdCfkc1y9MU8/URNI8qw52LtZZwCRl8V10CKhr0QcMwRM5y1yBuyKARs6zavFxWu5hJhwEOiD9FSBaqHefYCLU10QyDSvg53RDTtgO9HLqMcZEmGWETEtd+boVSr+ZwilO1zIASoaiKXUd0nL2UKOrZYxwSV/xor1gwyzBZCm5TtvszXElkC3tCDwMGNOPj+UuFxfR/r7Pbyfd1jrP6bldaPQ4a1dbLTRaZWoKttKSgXNVrxeSBI/IIPb1qMjpxnPQPArwyUl3JKIH5eJQcq/gBwcsmMWVfNA/JXVyWIfFtUUqhM75YzbnmKyUwn98245857lCjcKQKY+rYjeeFXZTzmO6+ZDKYV1lSNICXC7QcSpQR5G4XYu0q4FgmE0zUM0BjWMVS+/ofr8bD+rHB5rVEzz66J2OcH/DU5ymfhzuQhUEhnQ18ZAHtrn1ULCURawvhcta3Alg2WyeuWIGoZppkNC
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR21MB1454.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199021)(478600001)(186003)(82950400001)(66899021)(82960400001)(36756003)(10290500003)(6486002)(52116002)(26005)(6506007)(6512007)(1076003)(41300700001)(38350700002)(83380400001)(316002)(38100700002)(30864003)(2906002)(5660300002)(8936002)(8676002)(7416002)(921005)(86362001)(66476007)(66556008)(66946007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RuIjdS7FOlmvNpI98F+Gk05RPp/iueuZY+Krh5KhOEADlkxv6+P7ZU8n9trn?=
 =?us-ascii?Q?33lDHZ3QLjYVDNafwZjC9sdWjHi9zXuQJmKuK5g54B60T02AJTOoIGbgrH1O?=
 =?us-ascii?Q?uvJ89thwvdPIvwyvC0EyyLirVBo8EPJD0zXSUvw9CJ+bWN+UMsZaBXjHGKBS?=
 =?us-ascii?Q?+VKrbh8HWAkH9DMrpQn/JsMm/Vgz4NCFwc45iy67JObBJiTdr7LPE4KuDXJU?=
 =?us-ascii?Q?KJ8yPJv5w2JRWg2ASxfzMn6sNENcqGeg8/TYDgRkh2YU0trL2t2yPdeT+CyO?=
 =?us-ascii?Q?bqBJ5cS58iezY4NHbJeY6K9HTXY92ocXs9G9O57lN+giIIXhIXS0LN2Cx6Br?=
 =?us-ascii?Q?ORK7mQPNYgPIR3Z8rdk2f52sDKufwKISrNAlMAlQc9TfeBR/RmZlFwJ1ll/4?=
 =?us-ascii?Q?f9zHtL59L9I+6okZ9PnmcHDmUFMxX6NLWS5Of5Gu6rDgMQghN/bPqmGR3Vt+?=
 =?us-ascii?Q?ZpCs3PBc4ewbve6h4jso6mhTIO5cYF4HRaknoN7AlcLDcMYixXbBkObXYhgd?=
 =?us-ascii?Q?dWhZhOxNXvp2vON09tmFjbSgnscA49mZRcSmlpe8doo/YKAUlUNsqpOvSbAI?=
 =?us-ascii?Q?M/ERurBsDtzPQxvS1DfphvaIQrCHa4fDfhl4pwudz8ZD4YwlKpt1d/lVWWKE?=
 =?us-ascii?Q?aNlNQ5TGO8wWKTUeKT2FQrlrPILq2f07/8Zfs1bImGH7dbruxPmtF+VfYlNm?=
 =?us-ascii?Q?Patwxc9fNMft1MhrUBDBgVZRXH0lXlL7QlBATJpzCoNL7n81ceyxVeS/gwJJ?=
 =?us-ascii?Q?4hgiGxLaqrpbdhmCNMXzjXX0gZNlj0fgqdE8RL/QKEOvYL/FYOvK+f84Iqoh?=
 =?us-ascii?Q?6WIwew41ELRoGyyvksH7lHDwKTZ71cE3PcGgJSsgwJw6FgAeutiNLjc0Fr5I?=
 =?us-ascii?Q?wGUOzx0DRehDrfqPE6bKyIWL/IlyBoeTmrwxvviGVbd1SoyrtRbDFdi6h6gV?=
 =?us-ascii?Q?FcvZqmyOnwtCo1Y1Dx5KsDjb4YaZ57ArRXrkJMKTFT+P+hOwuvx8W5EyQl6k?=
 =?us-ascii?Q?wC1MFPJpr5leMF7+cr/g0XSZW07VLlV10z2llJ+1BGqRmhLP6SCFw4MXqXLk?=
 =?us-ascii?Q?eb4E+FjlM3VSkHDUVn5pZyHVI1ttQoG3L5/r9yv/i/Dxii1AGlTRfzbzsyPS?=
 =?us-ascii?Q?GbSs0v+/eA/bmILNOnxKMoR6sXssTbBkEqRkIXzW5si8w4HTsu7SwWn9XcD4?=
 =?us-ascii?Q?M7+Hx8P/f5b3P6RC8+evyyj9v671d/BW9HcWMu2EKrHjlf2LZKnMfJjPPH5+?=
 =?us-ascii?Q?IvoLYVh7TMy+Pjcb/7kZfO0M+2jnaTKa5U12/3MlxEU2ETBMwBSadLcJQdem?=
 =?us-ascii?Q?IlFSHIRkEdT1IzHdri6N3DTbjuz365DSDHEhWVhqKhS60P1bCufJgoWAyNbZ?=
 =?us-ascii?Q?bvgREW0UkPMF4o3h6BzNrhdAa/8iT7fwDwhFocERagb95lEVo3Ux6GIS2K/f?=
 =?us-ascii?Q?4ycoAgX8eIJf7vKlZSg/IDWrK7HNKh4XAjaauthn2XTmDC9ltZi0xMLXQ0yh?=
 =?us-ascii?Q?A5D6uepOstLHTJjgKk7PbLadAiYY2NZ5qRncYg9YDnpd/z4Xg1XknJJJC2ko?=
 =?us-ascii?Q?VTeonyTBbOHjlzsIOwTy/rvGLxwcqHKnOD9mY2l8?=
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61508912-2117-451c-499b-08db66a15157
X-MS-Exchange-CrossTenant-AuthSource: MN2PR21MB1454.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:18:45.0015
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VWwQUjypGwFY/fCSTqMi056Ep0JAma4SQ1dHhMszcJBoqGkx7+a5afetHmUgm9cDXa00RIPTuNr5fBQqLkluw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR21MB1483
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

v2: Use ibdev_dbg to print error messages and return -ENOMEN
    when kzalloc fails.

 drivers/infiniband/hw/mana/cq.c               |  32 ++++-
 drivers/infiniband/hw/mana/main.c             |  87 ++++++++++++
 drivers/infiniband/hw/mana/mana_ib.h          |   4 +
 drivers/infiniband/hw/mana/qp.c               |  90 +++++++++++-
 .../net/ethernet/microsoft/mana/gdma_main.c   | 131 ++++++++++--------
 drivers/net/ethernet/microsoft/mana/mana_en.c |   1 +
 include/net/mana/gdma.h                       |   9 +-
 7 files changed, 290 insertions(+), 64 deletions(-)

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
index 54b61930a7fd..e133d86c0875 100644
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
@@ -215,6 +226,27 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 		resp.entries[i].wqid = wq->id;
 
 		mana_ind_table[i] = wq->rx_object;
+
+		if (gd->gdma_context->cq_table[cq->id] == NULL) {
+
+			gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+			if (!gdma_cq) {
+				ibdev_dbg(&mdev->ib_dev,
+					 "failed to allocate gdma_cq\n");
+				ret = -ENOMEM;
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
 
@@ -224,7 +256,7 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 					 ucmd.rx_hash_key_len,
 					 ucmd.rx_hash_key);
 	if (ret)
-		goto fail;
+		goto free_cq;
 
 	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
 	if (ret) {
@@ -238,6 +270,23 @@ static int mana_ib_create_qp_rss(struct ib_qp *ibqp, struct ib_pd *pd,
 
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
@@ -269,10 +318,12 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
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
@@ -350,7 +401,9 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	cq_spec.gdma_region = send_cq->gdma_region;
 	cq_spec.queue_size = send_cq->cqe * COMP_ENTRY_SIZE;
 	cq_spec.modr_ctx_id = 0;
-	cq_spec.attached_eq = GDMA_CQ_NO_EQ;
+	eq_vec = send_cq->comp_vector % gd->gdma_context->max_num_queues;
+	eq = &mana_ucontext->eqs[eq_vec];
+	cq_spec.attached_eq = eq->eq->id;
 
 	err = mana_create_wq_obj(mpc, mpc->port_handle, GDMA_SQ, &wq_spec,
 				 &cq_spec, &qp->tx_object);
@@ -368,6 +421,26 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
 	qp->sq_id = wq_spec.queue_index;
 	send_cq->id = cq_spec.queue_index;
 
+	if (gd->gdma_context->cq_table[send_cq->id] == NULL) {
+
+		gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
+		if (!gdma_cq) {
+			ibdev_dbg(&mdev->ib_dev,
+				  "failed to allocate gdma_cq\n");
+			err = -ENOMEM;
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
@@ -381,12 +454,17 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
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


