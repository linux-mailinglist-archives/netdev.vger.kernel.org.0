Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A890585F03
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 14:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237066AbiGaM4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 08:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbiGaM42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 08:56:28 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2048.outbound.protection.outlook.com [40.107.96.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3A7B847;
        Sun, 31 Jul 2022 05:56:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OaE1gEF8T81vBolOB73jgh2zVhld2H+mKfrFdV202kCOJaaFSti7RRD88SdjFev4WJNmhQiTbie9MGf6Y8cMM1gVRINedPJqP97O9jFnvmy07vtWxNaXAT3vhvu4zXDA1DaPQjv7MMj38SiqDqHnFFway1z1EkUlsuM5nxVhrhGlyErb5ptsjPyyClkFE3/uassOER2EaFEvKkKDCEOlQK0CTfj1JqJVncrRampwcoWz2LaGxKaisO0oBnw1uzwetk8NUSHrCiTxgxalXVcmx7sZJok+pGAXm20zyhaDVUy0xyX6z+IuJZo7NO3iibpg5WM+GYGUu8MVoE65/OXk0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdMsxcQizw74MGr7+4QxOhhXh8X09L9CMYh7olHhGW8=;
 b=WoqNm+vy/J7vQXSfruePCp3hYZzcJE5qvfo6S5G1iQhxA6tDgl5anoFi7qm1Nk7EFuOUAv+46c8iUzD+/5oB+XJ8wfh4wbn0vIhvISiFYvRws08OhwSPBA0cpuCcCKQQwfPDCGfpa7WEkqFtMR3TDMesAFjF4bTCOD0iL4+XuDVZNMryPnu95hHr5xpea8KHQKARiQIcNJ98GaG7XeWvp+mZypOREyFd4ynnyPkMmk1Uv7/PziBg3xfQTCgEX69l8de41eiLhwJsUjKJSXMc25wGSROB98PaeR3AcHlcpvFyaN2WpRY4KEq4CpbtsWLr9CsfojDtojfGpH1rpsHUhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdMsxcQizw74MGr7+4QxOhhXh8X09L9CMYh7olHhGW8=;
 b=ZRXr+bGB6RiPIgv+Pj7ja+w4iF8JdUqYc2SX4/zWZ0ZfLRE6tiSIm1bQFQ2mgDRtRXSnRcD4B46r2UbPAOp8pJlQUQ9mfB06EImnVgpIIxMDGCHmbO2gg1A1jDY9e+kPLbjEAh0Mltd8Xdq8nFbtWTJmpv1QzxDSi6gmX5/2nW8m8gAmCrSseLjZWPvkQMqt4gC0R5RDyGPWygpDPJuCM34O10JvYCoMqc0RP/YSqDAuFyjqkAU7HBpwOI/nYuaeCDXEZXirtIaj4HUvFSAwiliUGR1sT+Cei8QSphyy4PVZCd+2PrCq7Aqib/q/xxK8TmGG41Wc4bMx7oGjeEpbkg==
Received: from DS7PR03CA0087.namprd03.prod.outlook.com (2603:10b6:5:3bb::32)
 by MW3PR12MB4346.namprd12.prod.outlook.com (2603:10b6:303:58::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Sun, 31 Jul
 2022 12:56:15 +0000
Received: from DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3bb:cafe::d5) by DS7PR03CA0087.outlook.office365.com
 (2603:10b6:5:3bb::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.14 via Frontend
 Transport; Sun, 31 Jul 2022 12:56:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 DM6NAM11FT059.mail.protection.outlook.com (10.13.172.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Sun, 31 Jul 2022 12:56:14 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL109.nvidia.com
 (10.27.9.19) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Sun, 31 Jul
 2022 12:56:14 +0000
Received: from rnnvmail205.nvidia.com (10.129.68.10) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Sun, 31 Jul
 2022 05:56:13 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.10)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Sun, 31 Jul
 2022 05:56:10 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V3 vfio 05/11] vfio: Add an IOVA bitmap support
Date:   Sun, 31 Jul 2022 15:54:57 +0300
Message-ID: <20220731125503.142683-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220731125503.142683-1-yishaih@nvidia.com>
References: <20220731125503.142683-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 44d67555-8bea-4d33-f463-08da72f40d8a
X-MS-TrafficTypeDiagnostic: MW3PR12MB4346:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ow7qdacafHZ6yPCoRJ8GEesdgMPD8KUBTVKy0nY3Zd69zsfE+y4ck+tRddy+H64/7yUSLM4i0oB68NpGqy2yPK3y9BbeChRxAKkKHUmlzbE4MZXZEiMtgWK5fF/hTlsM4Mf3L8nzHUZ74qz7NwTpC54GGezsjEuoN89lAKYd2l0NM77AT/J67d/VyIUFOg68Butmb14O4wUH9pDMcTqrKLgT9p2lgBprULlpKHUP4MwkRKmfI16bZoCi9G7q0XKlsVXgh/ebwtCTs3QyCbZG3G6qaiARUn7g9QGTRjVcsmjLEUJwc9EDRZWW/3irBaHDxSXVsQ7+C4QS9u485B5C19QzqleomP3fSB/nuwVT0YQlMrSpyZyPeklobiwwMiUnAdW5Lgcs5qC5QVYVgM1f4U0KN9ExNDG4Ayms3EaJoeHhcJ7DTfwrokDf0t7cMJO3u5DRd9cJelI3lw3XlD6jRYEm3mzcInVLHljtdiwK40/XGTLsX/Pn93iiCQPusmaeH8YB+SeD48Z+I1MQW/MKJqHO945RzQpP71aKv3F/HJinvYmN+x9gX5ktoch3xxufr/JU8UKgnsCqukok+O+8Abhgw5O/zUyFEITgWcfmhoXbQqvdtlOgNwaZxrwQwKTuvusnOY3iKhNYwrtx0QNRFZp1W3zMKGc+JcvlaZDrDBs0aASR/XNTVnVgk8AlnZjqy6xA9dJ8uBbh5h1YPcMk7AygGNItWQcuddTX/MAsWJ9uAfIwMqY67tD3ymR3zajCm9LCaPQVbu68skMJGGdzjX5feilwMuyzId7/i4z/AC2hnvHoQ5dP6koMm4YIdkVfvqwomR2tMb06FoigBAB2Pg==
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(396003)(376002)(346002)(36840700001)(46966006)(40470700004)(316002)(478600001)(6636002)(86362001)(83380400001)(36860700001)(40480700001)(5660300002)(54906003)(8936002)(8676002)(82310400005)(4326008)(70206006)(110136005)(70586007)(36756003)(30864003)(26005)(426003)(336012)(47076005)(186003)(6666004)(2616005)(1076003)(7696005)(41300700001)(2906002)(82740400003)(40460700003)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jul 2022 12:56:14.9424
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 44d67555-8bea-4d33-f463-08da72f40d8a
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR12MB4346
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

The new facility adds a bunch of wrappers that abstract how an IOVA
range is represented in a bitmap that is granulated by a given
page_size. So it translates all the lifting of dealing with user
pointers into its corresponding kernel addresses backing said user
memory into doing finally the (non-atomic) bitmap ops to change
various bits.

The formula for the bitmap is:

   data[(iova / page_size) / 64] & (1ULL << (iova % 64))

Where 64 is the number of bits in a unsigned long (depending on arch)

It introduces an IOVA iterator that uses a windowing scheme to minimize
the pinning overhead, as opposed to be pinning it on demand 4K at a
time. So on a 512G and with base page size it would iterate in ranges of
64G at a time, while pinning 512 pages at a time leading to fewer
atomics (specially if the underlying user memory are hugepages).

An example usage of these helpers for a given @base_iova, @page_size, @length
and __user @data:

	ret = iova_bitmap_iter_init(&iter, base_iova, page_size, length, data);
	if (ret)
		return -ENOMEM;

	for (; !iova_bitmap_iter_done(&iter) && !ret;
	     ret = iova_bitmap_iter_advance(&iter)) {
		dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
				   iova_bitmap_length(&iter));
	}

	iova_bitmap_iter_free(&iter);

An implementation of the lower end -- referred to above as dirty_reporter_ops
to exemplify -- that is tracking dirty bits would mark an IOVA as dirty
as following:

	iova_bitmap_set(&iter.dirty, iova, page_size);

or a contiguous range (example two pages):

	iova_bitmap_set(&iter.dirty, iova, 2 * page_size);

The facility is intended to be used for user bitmaps representing
dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Makefile       |   6 +-
 drivers/vfio/iova_bitmap.c  | 224 ++++++++++++++++++++++++++++++++++++
 include/linux/iova_bitmap.h | 189 ++++++++++++++++++++++++++++++
 3 files changed, 417 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 1a32357592e3..1d6cad32d366 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,9 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio_virqfd-y := virqfd.o
 
-vfio-y += vfio_main.o
-
 obj-$(CONFIG_VFIO) += vfio.o
+
+vfio-y := vfio_main.o \
+          iova_bitmap.o \
+
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
new file mode 100644
index 000000000000..6b6008ef146c
--- /dev/null
+++ b/drivers/vfio/iova_bitmap.c
@@ -0,0 +1,224 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+#include <linux/iova_bitmap.h>
+#include <linux/highmem.h>
+
+#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
+
+static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
+
+/*
+ * Converts a relative IOVA to a bitmap index.
+ * The bitmap is viewed an array of u64, and each u64 represents
+ * a range of IOVA, and the whole pinned pages to the range window.
+ * Relative IOVA means relative to the iter::dirty base IOVA (stored
+ * in dirty::iova). All computations in this file are done using
+ * relative IOVAs and thus avoid an extra subtraction against
+ * dirty::iova. The user API iova_bitmap_set() always uses a regular
+ * absolute IOVAs.
+ */
+static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
+					       unsigned long iova)
+{
+	unsigned long pgsize = 1 << iter->dirty.pgshift;
+
+	return iova / (BITS_PER_TYPE(*iter->data) * pgsize);
+}
+
+/*
+ * Converts a bitmap index to a *relative* IOVA.
+ */
+static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
+					       unsigned long index)
+{
+	unsigned long pgshift = iter->dirty.pgshift;
+
+	return (index * BITS_PER_TYPE(*iter->data)) << pgshift;
+}
+
+/*
+ * Pins the bitmap user pages for the current range window.
+ * This is internal to IOVA bitmap and called when advancing the
+ * iterator.
+ */
+static int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+	unsigned long npages;
+	u64 __user *addr;
+	long ret;
+
+	/*
+	 * @offset is the cursor of the currently mapped u64 words
+	 * that we have access. And it indexes u64 bitmap word that is
+	 * mapped. Anything before @offset is not mapped. The range
+	 * @offset .. @count is mapped but capped at a maximum number
+	 * of pages.
+	 */
+	npages = DIV_ROUND_UP((iter->count - iter->offset) *
+			      sizeof(*iter->data), PAGE_SIZE);
+
+	/*
+	 * We always cap at max number of 'struct page' a base page can fit.
+	 * This is, for example, on x86 means 2M of bitmap data max.
+	 */
+	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
+	addr = iter->data + iter->offset;
+	ret = pin_user_pages_fast((unsigned long)addr, npages,
+				  FOLL_WRITE, dirty->pages);
+	if (ret <= 0)
+		return -EFAULT;
+
+	dirty->npages = (unsigned long)ret;
+	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
+	dirty->iova = iova_bitmap_iova(iter);
+
+	/*
+	 * offset of the page where pinned pages bit 0 is located.
+	 * This handles the case where the bitmap is not PAGE_SIZE
+	 * aligned.
+	 */
+	dirty->start_offset = offset_in_page(addr);
+	return 0;
+}
+
+/*
+ * Unpins the bitmap user pages and clears @npages
+ * (un)pinning is abstracted from API user and it's done
+ * when advancing or freeing the iterator.
+ */
+static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	if (dirty->npages) {
+		unpin_user_pages(dirty->pages, dirty->npages);
+		dirty->npages = 0;
+	}
+}
+
+int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
+			  unsigned long iova, unsigned long length,
+			  unsigned long page_size, u64 __user *data)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	memset(iter, 0, sizeof(*iter));
+	dirty->pgshift = __ffs(page_size);
+	iter->data = data;
+	iter->count = iova_bitmap_iova_to_index(iter, length - 1) + 1;
+	iter->iova = iova;
+	iter->length = length;
+
+	dirty->iova = iova;
+	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
+	if (!dirty->pages)
+		return -ENOMEM;
+
+	return iova_bitmap_iter_get(iter);
+}
+
+void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	iova_bitmap_iter_put(iter);
+
+	if (dirty->pages) {
+		free_page((unsigned long)dirty->pages);
+		dirty->pages = NULL;
+	}
+
+	memset(iter, 0, sizeof(*iter));
+}
+
+unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
+{
+	unsigned long skip = iter->offset;
+
+	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
+}
+
+/*
+ * Returns the remaining bitmap indexes count to process for the currently pinned
+ * bitmap pages.
+ */
+static unsigned long iova_bitmap_iter_remaining(struct iova_bitmap_iter *iter)
+{
+	unsigned long remaining = iter->count - iter->offset;
+
+	remaining = min_t(unsigned long, remaining,
+		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
+
+	return remaining;
+}
+
+unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
+{
+	unsigned long max_iova = iter->iova + iter->length - 1;
+	unsigned long iova = iova_bitmap_iova(iter);
+	unsigned long remaining;
+
+	/*
+	 * iova_bitmap_iter_remaining() returns a number of indexes which
+	 * when converted to IOVA gives us a max length that the bitmap
+	 * pinned data can cover. Afterwards, that is capped to
+	 * only cover the IOVA range in @iter::iova .. iter::length.
+	 */
+	remaining = iova_bitmap_index_to_iova(iter,
+			iova_bitmap_iter_remaining(iter));
+
+	if (iova + remaining - 1 > max_iova)
+		remaining -= ((iova + remaining - 1) - max_iova);
+
+	return remaining;
+}
+
+bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
+{
+	return iter->offset >= iter->count;
+}
+
+int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
+{
+	unsigned long iova = iova_bitmap_length(iter) - 1;
+	unsigned long count = iova_bitmap_iova_to_index(iter, iova) + 1;
+
+	iter->offset += count;
+
+	iova_bitmap_iter_put(iter);
+	if (iova_bitmap_iter_done(iter))
+		return 0;
+
+	/* When we advance the iterator we pin the next set of bitmap pages */
+	return iova_bitmap_iter_get(iter);
+}
+
+unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
+			      unsigned long iova, unsigned long length)
+{
+	unsigned long nbits = max(1UL, length >> dirty->pgshift), set = nbits;
+	unsigned long offset = (iova - dirty->iova) >> dirty->pgshift;
+	unsigned long page_idx = offset / BITS_PER_PAGE;
+	unsigned long page_offset = dirty->start_offset;
+	void *kaddr;
+
+	offset = offset % BITS_PER_PAGE;
+
+	do {
+		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
+
+		kaddr = kmap_local_page(dirty->pages[page_idx]);
+		bitmap_set(kaddr + page_offset, offset, size);
+		kunmap_local(kaddr);
+		page_offset = offset = 0;
+		nbits -= size;
+		page_idx++;
+	} while (nbits > 0);
+
+	return set;
+}
+EXPORT_SYMBOL_GPL(iova_bitmap_set);
diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
new file mode 100644
index 000000000000..e258d03386d3
--- /dev/null
+++ b/include/linux/iova_bitmap.h
@@ -0,0 +1,189 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+#ifndef _IOVA_BITMAP_H_
+#define _IOVA_BITMAP_H_
+
+#include <linux/mm.h>
+
+/**
+ * struct iova_bitmap - A bitmap representing a portion IOVA space
+ *
+ * Main data structure for tracking dirty IOVAs.
+ *
+ * For example something recording dirty IOVAs, will be provided of a
+ * struct iova_bitmap structure. This structure only represents a
+ * subset of the total IOVA space pinned by its parent counterpart
+ * iterator object.
+ *
+ * The user does not need to exact location of the bits in the bitmap.
+ * From user perspective the bitmap the only API available to the dirty
+ * tracker is iova_bitmap_set() which records the dirty IOVA *range*
+ * in the bitmap data.
+ *
+ * The bitmap is an array of u64 whereas each bit represents an IOVA
+ * of range of (1 << pgshift). Thus formula for the bitmap data to be
+ * set is:
+ *
+ *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iova_bitmap {
+	/* base IOVA representing bit 0 of the first page */
+	unsigned long iova;
+
+	/* page size order that each bit granules to */
+	unsigned long pgshift;
+
+	/* offset of the first user page pinned */
+	unsigned long start_offset;
+
+	/* number of pages pinned */
+	unsigned long npages;
+
+	/* pinned pages representing the bitmap data */
+	struct page **pages;
+};
+
+/**
+ * struct iova_bitmap_iter - Iterator object of the IOVA bitmap
+ *
+ * Main data structure for walking the bitmap data.
+ *
+ * Abstracts the pinning work to iterate an IOVA ranges.
+ * It uses a windowing scheme and pins the bitmap in relatively
+ * big ranges e.g.
+ *
+ * The iterator uses one base page to store all the pinned pages
+ * pointers related to the bitmap. For sizeof(struct page) == 64 it
+ * stores 512 struct pages which, if base page size is 4096 it means 2M
+ * of bitmap data is pinned at a time. If the iova_bitmap page size is
+ * also base page size then the range window to iterate is 64G.
+ *
+ * For example iterating on a total IOVA range of 4G..128G, it will
+ * walk through this set of ranges:
+ *
+ *  - 4G  -  68G-1 (64G)
+ *  - 68G - 128G-1 (64G)
+ *
+ * An example of the APIs on how to iterate the IOVA bitmap:
+ *
+ *   ret = iova_bitmap_iter_init(&iter, iova, PAGE_SIZE, length, data);
+ *   if (ret)
+ *       return -ENOMEM;
+ *
+ *   for (; !iova_bitmap_iter_done(&iter) && !ret;
+ *        ret = iova_bitmap_iter_advance(&iter)) {
+ *
+ *        dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
+ *                           iova_bitmap_length(&iter));
+ *   }
+ *
+ * An implementation of the lower end (referred to above as
+ * dirty_reporter_ops) that is tracking dirty bits would:
+ *
+ *        if (iova_dirty)
+ *            iova_bitmap_set(&iter.dirty, iova, PAGE_SIZE);
+ *
+ * The internals of the object use a cursor @offset that indexes
+ * which part u64 word of the bitmap is mapped, up to @count.
+ * Those keep being incremented until @count reaches while mapping
+ * up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
+ *
+ * The iterator is usually located on what tracks DMA mapped ranges
+ * or some form of IOVA range tracking that co-relates to the user
+ * passed bitmap.
+ */
+struct iova_bitmap_iter {
+	/* IOVA range representing the currently pinned bitmap data */
+	struct iova_bitmap dirty;
+
+	/* userspace address of the bitmap */
+	u64 __user *data;
+
+	/* u64 index that @dirty points to */
+	size_t offset;
+
+	/* how many u64 can we walk in total */
+	size_t count;
+
+	/* base IOVA of the whole bitmap */
+	unsigned long iova;
+
+	/* length of the IOVA range for the whole bitmap */
+	unsigned long length;
+};
+
+/**
+ * iova_bitmap_iter_init() - Initializes an IOVA bitmap iterator object.
+ * @iter: IOVA bitmap iterator to initialize
+ * @iova: Start address of the IOVA range
+ * @length: Length of the IOVA range
+ * @page_size: Page size of the IOVA bitmap. It defines what each bit
+ *             granularity represents
+ * @data: Userspace address of the bitmap
+ *
+ * Initializes all the fields in the IOVA iterator including the first
+ * user pages of @data. Returns 0 on success or otherwise errno on error.
+ */
+int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
+			  unsigned long length, unsigned long page_size,
+			  u64 __user *data);
+
+/**
+ * iova_bitmap_iter_free() - Frees an IOVA bitmap iterator object
+ * @iter: IOVA bitmap iterator to free
+ *
+ * It unpins and releases pages array memory and clears any leftover
+ * state.
+ */
+void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
+
+/**
+ * iova_bitmap_iter_done: Checks if the IOVA bitmap has data to iterate
+ * @iter: IOVA bitmap iterator to free
+ *
+ * Returns true if there's more data to iterate.
+ */
+bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
+
+/**
+ * iova_bitmap_iter_advance: Advances the IOVA bitmap iterator
+ * @iter: IOVA bitmap iterator to advance
+ *
+ * Advances to the next range, releases the current pinned
+ * pages and pins the next set of bitmap pages.
+ * Returns 0 on success or otherwise errno.
+ */
+int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
+
+/**
+ * iova_bitmap_iova: Base IOVA of the current range
+ * @iter: IOVA bitmap iterator
+ *
+ * Returns the base IOVA of the current range.
+ */
+unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
+
+/**
+ * iova_bitmap_length: IOVA length of the current range
+ * @iter: IOVA bitmap iterator
+ *
+ * Returns the length of the current IOVA range.
+ */
+unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
+
+/**
+ * iova_bitmap_set: Marks an IOVA range as dirty
+ * @dirty: IOVA bitmap
+ * @iova: IOVA to mark as dirty
+ * @length: IOVA range length
+ *
+ * Marks the range [iova .. iova+length-1] as dirty in the bitmap.
+ * Returns the number of bits set.
+ */
+unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
+			      unsigned long iova, unsigned long length);
+
+#endif
-- 
2.18.1

