Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D12145617E9
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:27:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235009AbiF3K1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234823AbiF3K07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:26:59 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7ea9::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7516BBC8B;
        Thu, 30 Jun 2022 03:26:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SUllg0XccrawexyMN1pjw/DxWGRrsGcZXpdCdEhAIBBfRuzg9xsuFOeuXg1o4+ZLyFxyqJ2sP+uQaeVEsSspKCi1hH6xDNNZ1kOs6OY/dJO9ZmNcY11CTOoCDdcdpuh4YuYPVEovFLMshPy/qS6Er7LxH1qmXHUn78po4Xg0VHDgiBCSMZksiWAmPGBmaV870Uxjn1MDLZCvkWa4DIbQ1urXESRk16rk7xO0uCHyJMb+m2WssaHcTs6/Vl/bGeN4BbYwKR3JvIA9Ka02bPtB81/FFdH2zpEc8O8A8BlkAmQVfKRnoy6skYPqkSaX73uEx3qpp1wp6dQEEaUCZoWGrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQb7BEu304mzvh6yz+QuNvPSk0csvwEZnlQ3YPnCSDI=;
 b=Cu/UJl3xg050ic+Whg/UHqFJgi6KGjJPqDUkXTJeofKPteAxz4SeSnLiz0tdfv3HFTqgvQEKKKk/WdX+FizHD+FIxCyqGTuQpAVsDaI9v0ztsBN8K5lKnJIz5WtMOPy5byK1Pgmyaaxk7tO3EdHKWDsLBFGd4Bxfvy554nXONYF2d9VOQj6bDD4z6iZ2GatPJZ0Cw52JBRkeLG12q8C0CdoDRfoFFOvBr6CGi3QEmOFOJmun8jQww8onhJBUE/dyxb7ApSY8/uLpE16ZZgqiaoz5tiIPf70oii0lHnNIGeFQAYjUJVK4PBzTTODFMQytJ0YUCBXdb2cE8NskCetYmA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQb7BEu304mzvh6yz+QuNvPSk0csvwEZnlQ3YPnCSDI=;
 b=PAWxQRZioGY3v1opq4qvlgonlaCINSWGC1VBhMH3d+E0ZsQHMOADAJlECqvXS3wqYoJqo9lDA8tj9hjmbe9q7p+qwAoBbW5omkvC3eP7WxGUUgnHfW+bdP226i25OtKM2P5v/Ok2LlDPVGnXdKxyY9BfiT4gZC/az5US9qFBoSR/GBfyDKhBXxBlip9AUBb9iOsXM0K6Jhz1ecrM5wD9FUYXCK+yawWK0Og1B9WRBFHp8xvJVw6z+JOe3vXpSNH+Hf3W5LF3GKxvsxEM1G6ktNZMLiC6E+LrUy90gz+XOG+el2FVapKviDuOPDwdFIfGB8EHI2VMYdJR+TVzwtJVYg==
Received: from DM6PR07CA0041.namprd07.prod.outlook.com (2603:10b6:5:74::18) by
 MN2PR12MB3085.namprd12.prod.outlook.com (2603:10b6:208:c5::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5373.18; Thu, 30 Jun 2022 10:26:53 +0000
Received: from DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::5d) by DM6PR07CA0041.outlook.office365.com
 (2603:10b6:5:74::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14 via Frontend
 Transport; Thu, 30 Jun 2022 10:26:53 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.238) by
 DM6NAM11FT009.mail.protection.outlook.com (10.13.173.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5395.14 via Frontend Transport; Thu, 30 Jun 2022 10:26:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL105.nvidia.com (10.27.9.14) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 30 Jun 2022 10:26:52 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 30 Jun 2022 03:26:51 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 30 Jun 2022 03:26:47 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH vfio 07/13] vfio: Add an IOVA bitmap support
Date:   Thu, 30 Jun 2022 13:25:39 +0300
Message-ID: <20220630102545.18005-8-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220630102545.18005-1-yishaih@nvidia.com>
References: <20220630102545.18005-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c294f138-d325-49bd-435c-08da5a830cf6
X-MS-TrafficTypeDiagnostic: MN2PR12MB3085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eXTkJtFlQdmaH2ki3ZMGHylPvBWDbb4Y3unXvAkEXz17bo/LRXHjqWtBDHlhJj4ZaSSQeKd6BZmtj9K4VQ1CA/6mLSOS4hjuTZr2IlG6VxleriCVIOM1H8A9Xwa2W/NBvJFfsxYyvtjrTBojji0kjRB4ZrZSZ8qmhDGi7QRBI4pBAoxAwkP6TH7i3wCtOt5kHP0hoa5hlfbXe4ZP3u3tYGCZu7CWnfT+P0kjjuLwVQndgKV1M6YSf+7x4dDPnQ17nG5YK6djCefnpz4mEv3p8nLIHsACFR9sy6ZHw3HAPO6LuRgSnsyeVy+rbox8wzP0Kfvj3sIuc174x9g7rxO25HR296UB12zH2fKZrOmIQogR3L/ExQwaRkL5d+3pTdBIFlXGhOe4g64pfVwMATEgMhFYZqnShR6VPjoQLHqlCeLYo0LYEWqPuWgSHkTTHcyoANXga6u7lUg0qwFbY0z3sEynU+9VXUgzEMaQglVzz5LRfB0yTy2Diu7Rz4a3zwUgxIkMp1TEQO/lpdSnwlY8RyRCtbEs/zDKDOKyeskuSO7gBtmU35YczP5Pf2DqPBy29EjtJc8J2qLk52Q9ZDKcvQh6ZlHL+IoSO+eJJtT9cEjkFf9DDNaeQpnBIZ/uoQpsLQCjHl2ROCrjjWyTSaLzPLBpMC1gn3E8g5MmOKuLx8+9Udisid75+NUItmJnBjzom7vgVgxXsp7NtbJseueaUtTlVmFKfqOkqdkboE7YDnwdaU2yQLL+XFmIH4t7pF0cSUyff+mfXqnmkhfNfMXGuA6nwpQyv3rpV3UAXM8Zaht+qSWQ77trCxuxAD2/SBbDPUq9DF4r9FRwcG/mQSVvspmrtOtcnkEgBffbRZGkeuU=
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(136003)(346002)(396003)(39860400002)(376002)(46966006)(36840700001)(40470700004)(70586007)(2616005)(7696005)(356005)(8936002)(5660300002)(36756003)(478600001)(36860700001)(83380400001)(2906002)(40480700001)(81166007)(82310400005)(47076005)(4326008)(86362001)(54906003)(1076003)(426003)(110136005)(41300700001)(336012)(6636002)(186003)(26005)(82740400003)(316002)(40460700003)(8676002)(6666004)(70206006)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 10:26:52.9309
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c294f138-d325-49bd-435c-08da5a830cf6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3085
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
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
memory into doing finally the bitmap ops to change various bits.

The formula for the bitmap is:

   data[(iova / page_size) / 64] & (1ULL << (iova % 64))

Where 64 is the number of bits in a unsigned long (depending on arch)

An example usage of these helpers for a given @iova, @page_size, @length
and __user @data:

	iova_bitmap_init(&iter.dirty, iova, __ffs(page_size));
	ret = iova_bitmap_iter_init(&iter, iova, length, data);
	if (ret)
		return -ENOMEM;

	for (; iova_bitmap_iter_done(&iter);
	     iova_bitmap_iter_advance(&iter)) {
		ret = iova_bitmap_iter_get(&iter);
		if (ret)
			break;
		if (dirty)
			iova_bitmap_set(iova_bitmap_iova(&iter),
					iova_bitmap_iova_length(&iter),
					&iter.dirty);

		iova_bitmap_iter_put(&iter);

		if (ret)
			break;
	}

	iova_bitmap_iter_free(&iter);

The facility is intended to be used for user bitmaps representing
dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Makefile       |   6 +-
 drivers/vfio/iova_bitmap.c  | 164 ++++++++++++++++++++++++++++++++++++
 include/linux/iova_bitmap.h |  46 ++++++++++
 3 files changed, 214 insertions(+), 2 deletions(-)
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
index 000000000000..58abf485eba8
--- /dev/null
+++ b/drivers/vfio/iova_bitmap.c
@@ -0,0 +1,164 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/iova_bitmap.h>
+
+static unsigned long iova_bitmap_array_length(unsigned long iova_length,
+					      unsigned long page_shift)
+{
+	return DIV_ROUND_UP(iova_length, BITS_PER_TYPE(u64) * (1 << page_shift));
+}
+
+static unsigned long iova_bitmap_index_to_length(struct iova_bitmap_iter *iter,
+						 unsigned long index)
+{
+	return ((index * sizeof(u64) * BITS_PER_BYTE) << iter->dirty.pgshift);
+}
+
+static unsigned long iova_bitmap_iter_left(struct iova_bitmap_iter *iter)
+{
+	unsigned long left = iter->count - iter->offset;
+
+	left = min_t(unsigned long, left,
+		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(u64));
+
+	return left;
+}
+
+/*
+ * Input argument of number of bits to bitmap_set() is unsigned integer, which
+ * further casts to signed integer for unaligned multi-bit operation,
+ * __bitmap_set().
+ * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
+ * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
+ * system.
+ */
+int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
+			  unsigned long iova, unsigned long length,
+			  unsigned long __user *data)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	iter->data = data;
+	iter->offset = 0;
+	iter->count = iova_bitmap_array_length(length, dirty->pgshift);
+	iter->iova = iova;
+	iter->length = length;
+	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
+
+	return !dirty->pages ? -ENOMEM : 0;
+}
+
+void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	if (dirty->pages) {
+		free_page((unsigned long)dirty->pages);
+		dirty->pages = NULL;
+	}
+}
+
+bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
+{
+	return (iter->count - iter->offset) > 0;
+}
+
+static unsigned long iova_bitmap_iter_length(struct iova_bitmap_iter *iter)
+{
+	return iova_bitmap_index_to_length(iter, iter->count);
+}
+
+unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
+{
+	unsigned long left = iova_bitmap_iter_left(iter);
+	unsigned long iova = iova_bitmap_iova(iter);
+
+	left = iova_bitmap_index_to_length(iter, left);
+	if (iova_bitmap_iter_length(iter) > iter->length &&
+	    iova + left > iter->iova + iter->length - 1)
+		left -= ((iova + left) - (iova + iter->length));
+	return left;
+}
+
+unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
+{
+	unsigned long skip = iter->offset;
+
+	return iter->iova + iova_bitmap_index_to_length(iter, skip);
+}
+
+void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
+{
+	unsigned long length = iova_bitmap_length(iter);
+
+	iter->offset += iova_bitmap_array_length(length, iter->dirty.pgshift);
+}
+
+void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	if (dirty->npages)
+		unpin_user_pages(dirty->pages, dirty->npages);
+}
+
+int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+	unsigned long npages;
+	void __user *addr;
+	long ret;
+
+	npages = DIV_ROUND_UP((iter->count - iter->offset) * sizeof(u64),
+			      PAGE_SIZE);
+	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
+	addr = iter->data + (iter->offset * sizeof(u64));
+	ret = pin_user_pages_fast((unsigned long)addr, npages,
+				  FOLL_WRITE, dirty->pages);
+	if (ret <= 0)
+		return ret;
+
+	dirty->npages = (unsigned long)ret;
+	dirty->iova = iova_bitmap_iova(iter);
+	dirty->start_offset = offset_in_page(addr);
+	return 0;
+}
+
+void iova_bitmap_init(struct iova_bitmap *bitmap,
+		      unsigned long base, unsigned long pgshift)
+{
+	memset(bitmap, 0, sizeof(*bitmap));
+	bitmap->iova = base;
+	bitmap->pgshift = pgshift;
+}
+
+unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
+			     unsigned long iova,
+			     unsigned long length)
+{
+	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
+
+	nbits = max(1UL, length >> dirty->pgshift);
+	offset = (iova - dirty->iova) >> dirty->pgshift;
+	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
+	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
+	start_offset = dirty->start_offset;
+
+	while (nbits > 0) {
+		kaddr = kmap_local_page(dirty->pages[idx]) + start_offset;
+		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
+		bitmap_set(kaddr, offset, size);
+		kunmap_local(kaddr - start_offset);
+		start_offset = offset = 0;
+		nbits -= size;
+		idx++;
+	}
+
+	return nbits;
+}
+EXPORT_SYMBOL_GPL(iova_bitmap_set);
+
diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
new file mode 100644
index 000000000000..ff19ad47a126
--- /dev/null
+++ b/include/linux/iova_bitmap.h
@@ -0,0 +1,46 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#ifndef _IOVA_BITMAP_H_
+#define _IOVA_BITMAP_H_
+
+#include <linux/highmem.h>
+#include <linux/mm.h>
+#include <linux/uio.h>
+
+struct iova_bitmap {
+	unsigned long iova;
+	unsigned long pgshift;
+	unsigned long start_offset;
+	unsigned long npages;
+	struct page **pages;
+};
+
+struct iova_bitmap_iter {
+	struct iova_bitmap dirty;
+	void __user *data;
+	size_t offset;
+	size_t count;
+	unsigned long iova;
+	unsigned long length;
+};
+
+int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
+			  unsigned long length, unsigned long __user *data);
+void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
+bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
+unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
+unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
+void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
+int iova_bitmap_iter_get(struct iova_bitmap_iter *iter);
+void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
+void iova_bitmap_init(struct iova_bitmap *bitmap,
+		      unsigned long base, unsigned long pgshift);
+unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
+			     unsigned long iova,
+			     unsigned long length);
+
+#endif
-- 
2.18.1

