Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF73A574678
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 10:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233580AbiGNIPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 04:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGNIOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 04:14:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8DA82B61A;
        Thu, 14 Jul 2022 01:14:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VBTBYXJfz5keZO0tKzsdoARwsXLKx7D714ASWlosLXiIp4cb9wxssDmp/Ji0bSbChlVGszbvWyWRgWRTbnZK1IxPJt0fe59W+dRW/MlsH9IHwx4XbPXHncakhoZz7VtcXaQDA3C90j7vurWb22hjSn14guo9h3gDKXEponfXcZ6i4lBeOrPcIh3V+CZ3QHzTN6EUzhd4WHqzri8DP6M2aBrIzQYoDs2kiXk9MRHWAMwHBRxD4336tZgF+vYRiUXWaI/jBNnS6Hhb9smxxQhvQ89ujt73Andhl1+IzDRTalnSbmNgjpAmBJVSk4ttWy5I5tsbzjGiEaUeKmD2Z5UWZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tAUp/2SphDGPVNCf0zN+fn9F4eP3i//4ewrx0dp+sFE=;
 b=lV7HhWY/F4L6zgNRARWJjJ5iuQ2U5amKxaUbIn8imtoYambCs3GWDEZcbeW/u/ycTKh1CoNOaQvvWEAyfF+G6pn9xGM2hdoAZelEp3SHMfvezU4s2lgeLWI7pDVl/uMznIP73g6l9ZX0gaU/BA5js8zfvJ5XDmHYLIULSIoVj0/OZdP20Oy85+Je3DpvnrfRKLvJk7ntELrUU1G65kZgZLh0X2kNS2UXTO4bgYha8BBJrlk1++WCXn5hdofSnLIDGyfaqZO4JCtPMi04FLRclkiky/8ylPPGRkOg8/yO0e5AIRjof1Ig0TEUWlOo7TMBqyO21xQpvclR4oISGZOSng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.236) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tAUp/2SphDGPVNCf0zN+fn9F4eP3i//4ewrx0dp+sFE=;
 b=Eqg7SlYqIh3XXGG+vNACF1D3skl/dWsi6lXqgtn3aeGnF9JG2+w11/NKTYoJybfkateqe0z/2TRShRib5gDhX3ynS1DeQSzSbWkbqS+yYo9Lv0rKsdrhJLMwcL5SO6jSjfkTIJ4HkkrFVpfTpVIMmcKCBVGR/VjtTiAg25Y7dllQEWxVl7D2GYUzUXKeeu3Fj//iCMOWhfFnABVsEqvEpLPoEb572AHlcLhnhg7HGBYF/gjZKJGinyCJTysXNgNhzUK3IonlxCDdRCXL7yUjfPZuYiZrzaFE7ZQp1Rv028sjmo0hgkR6EppVA8GHo+silrwoWteUMoFYMEpc+HNDMg==
Received: from MW4P220CA0029.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::34)
 by BN6PR12MB1490.namprd12.prod.outlook.com (2603:10b6:405:f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12; Thu, 14 Jul
 2022 08:14:38 +0000
Received: from CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::67) by MW4P220CA0029.outlook.office365.com
 (2603:10b6:303:115::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.12 via Frontend
 Transport; Thu, 14 Jul 2022 08:14:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.236)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.236 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.236; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.236) by
 CO1NAM11FT059.mail.protection.outlook.com (10.13.174.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5438.12 via Frontend Transport; Thu, 14 Jul 2022 08:14:37 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 DRHQMAIL109.nvidia.com (10.27.9.19) with Microsoft SMTP Server (TLS) id
 15.0.1497.32; Thu, 14 Jul 2022 08:14:36 +0000
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.26; Thu, 14 Jul 2022 01:14:35 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server id 15.2.986.26 via Frontend
 Transport; Thu, 14 Jul 2022 01:14:29 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Date:   Thu, 14 Jul 2022 11:12:45 +0300
Message-ID: <20220714081251.240584-6-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220714081251.240584-1-yishaih@nvidia.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58a9ed82-ad94-450d-4f63-08da6570e4ae
X-MS-TrafficTypeDiagnostic: BN6PR12MB1490:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7fDXojtsstdzP1EjE3L36oopz1VkSWibM2P4mgxY2Oq95FyY7F6srLef8JCcsqoxnu2utE1b+rhkTZmgpyOLWeVqj6LfVurolbsPt3LYhQDOuozX6QaozEW0q6vJyGuKP6HYI/d6dGLXS/GcBEGtQn0k5AeLG+e5KDddlj6eJhpc8NpSiHZcf7KsGULOhODoP/wdCSIg2EFKVcN5TU5ksBockZDb1pSXJkpkj091TJNkCD8yedhY9pQgeRwngByv62BwPtAZ2sXcE6d9CKnqlrkj3j6IRLxvlmMHHLbRABMQqpPn2Db2tCVHun2rjrVvZJC18QHgv955lxj0Hzs5U7WaB4tkg2y9TMIRNy8RIETNfCYgWXoHbm09T6kuk2ZAvqmF6ij8WesWNY+5m36xTpmEAp6EaG+ww2MFA+C467iQHOCJ78L+AOcMhtpWAu5GFBK0cHYniKpxTIICknbJWgg9RnJ/8JDANRc4ZU5PRaBAthcFF87o9tkdFmIEW1tijvcT3KDsz9PSDGXqRjTCLrHNPpqyJDcX9QY5zZm318VtFXgGH/uBC4yhvJD5b/GHoaU9zHX0nmrvw5zHfWVCu7gnLaKzDKaqQuUAB/QOITmkB6a46V7E8zcH51Za3gDIVAYgqSg6lqkzEYbk0oWlCnoM9l1RV7fVO7ADrqnvHm8w37/M2QeQbqlHtIL/N5Vnw7w4riDrJnAloVS6Y5ZFqH24ZZ1BBPazd8BmXGvoSrMXew1X/Dm+BiwGc/KXSgZZa8jVHQFs2kEO0mDx2plWcalet8naZl2K/V9jcck3QXmFDvPgzwC7MX9VSQ+UvYwEdxV6SB/vyPOHlGTV+Wh8v7LDgVQ0AAvZiM/i8M/JYOc=
X-Forefront-Antispam-Report: CIP:12.22.5.236;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:ErrorRetry;CAT:NONE;SFS:(13230016)(4636009)(136003)(396003)(346002)(376002)(39860400002)(36840700001)(46966006)(40470700004)(82740400003)(336012)(47076005)(356005)(426003)(186003)(2616005)(36860700001)(40480700001)(2906002)(5660300002)(8936002)(36756003)(40460700003)(8676002)(70206006)(70586007)(478600001)(1076003)(26005)(6666004)(7696005)(41300700001)(81166007)(110136005)(4326008)(83380400001)(86362001)(6636002)(54906003)(82310400005)(316002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2022 08:14:37.2311
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 58a9ed82-ad94-450d-4f63-08da6570e4ae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.236];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT059.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1490
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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

	for (; !iova_bitmap_iter_done(&iter);
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
index 000000000000..9ad1533a6aec
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
+static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
+					       unsigned long iova_length)
+{
+	unsigned long pgsize = 1 << iter->dirty.pgshift;
+
+	return DIV_ROUND_UP(iova_length, BITS_PER_TYPE(*iter->data) * pgsize);
+}
+
+static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
+					       unsigned long index)
+{
+	unsigned long pgshift = iter->dirty.pgshift;
+
+	return (index * sizeof(*iter->data) * BITS_PER_BYTE) << pgshift;
+}
+
+static unsigned long iova_bitmap_iter_left(struct iova_bitmap_iter *iter)
+{
+	unsigned long left = iter->count - iter->offset;
+
+	left = min_t(unsigned long, left,
+		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
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
+			  u64 __user *data)
+{
+	struct iova_bitmap *dirty = &iter->dirty;
+
+	iter->data = data;
+	iter->offset = 0;
+	iter->count = iova_bitmap_iova_to_index(iter, length);
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
+	return iter->offset >= iter->count;
+}
+
+unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
+{
+	unsigned long max_iova = iter->dirty.iova + iter->length;
+	unsigned long left = iova_bitmap_iter_left(iter);
+	unsigned long iova = iova_bitmap_iova(iter);
+
+	left = iova_bitmap_index_to_iova(iter, left);
+	if (iova + left > max_iova)
+		left -= ((iova + left) - max_iova);
+
+	return left;
+}
+
+unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
+{
+	unsigned long skip = iter->offset;
+
+	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
+}
+
+void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
+{
+	unsigned long length = iova_bitmap_length(iter);
+
+	iter->offset += iova_bitmap_iova_to_index(iter, length);
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
+	u64 __user *addr;
+	long ret;
+
+	npages = DIV_ROUND_UP((iter->count - iter->offset) *
+			      sizeof(*iter->data), PAGE_SIZE);
+	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
+	addr = iter->data + iter->offset;
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
index 000000000000..c474c351634a
--- /dev/null
+++ b/include/linux/iova_bitmap.h
@@ -0,0 +1,46 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+	u64 __user *data;
+	size_t offset;
+	size_t count;
+	unsigned long iova;
+	unsigned long length;
+};
+
+int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
+			  unsigned long length, u64 __user *data);
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

