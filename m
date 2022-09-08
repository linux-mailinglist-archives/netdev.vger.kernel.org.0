Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 727795B25DC
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 20:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiIHSfr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 14:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232052AbiIHSfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 14:35:32 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2072.outbound.protection.outlook.com [40.107.101.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D1E9016;
        Thu,  8 Sep 2022 11:35:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nb1n3m8xeCLZqLTnkogkpfUAwHEEf8xGQUHSJe4nAYtG5SHoN/dTOZzABxCwVbxE2uFfRdTIExxav8OKQgof4zVLBuIx2a1jI+Srsk2m6QDKRtoJvTrPNRtK1tZBtdsg73Cn4eLa5daa5CWFwqq6DCY2aGsjaJCGDzKYjCUScSPGWnIB7hMVMvjI8VU9PChr072yaC53fQffM2XrrbXtHW9qj5jhmkuF9Y//0U6fE0T+eXffNkiDE04HmkkrF5ouLxLupcGgRYDgZAUdS/SQR+ARNw2/gax1FgHKEsjCQgvA5w2PVjAOU0xmxa/tnwrBZtC0o5EPzSh/5TOXPZ1OxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giSxQLI3HQW93vThdHlDQZHdB5UFz7x6VoC3/hSMyQ0=;
 b=IZ3yPcEINrAbjex7DF+olWc6dQZlYGfu4wx/3E90GrOHwpWlrJWHl9IIGoLotL3W/VfgsoTjaskFeE7LLdiHgibBElTjes7FYByMfmUG9QIXFPN+uwkDiEZpwchwhRoF21qfkLpGwNrXpFwPPFni+u/lOYxoNhn11OnXDFD1jkLruQGVc78q3hdYA+naHffWzVuVwjcmOncsRAQxUtpzqqY4XBcY6iq20p/gRmKNnQaLUDHwYky/4Jli+IOnfx006ifT+DSEIMZY2ye8Ly68CftjjS1q0KekEeeKuSMX6S/2KT0unKCF+jWT69gx05Iqu9Hy3oKUZNh9n1W4Exe42A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com;
 dmarc=bestguesspass action=none header.from=nvidia.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giSxQLI3HQW93vThdHlDQZHdB5UFz7x6VoC3/hSMyQ0=;
 b=CEURCwZ29U0yy/mWA5y/HDQBQwQaFUpKEdGmOMYs/gOBEPQuC1hCrP6czraKsl9Sd4j1zY8sUiKWkQj1Zv+tP/AWR/L6OcPHmKy94C/rtwsWLzhP0W0z/vOOl/55UjhNEMsPN+lBH8dhcbz2LBehqcIoOETBgRkLFZWCoE+m+INuZW4bsWRkSHE7Q9DWGqDYuhD/C5KMDbeI+cc4jR/ksaHZpVz1ArAxzHXZKTKogd4FH/GgqfWvb4viLSy967PqzKmdFFtDfgPcVN5l+Ey8NTxkmE0RfvW3w+veYRo/5bNlQKIisuZLHQhjOeFIHcDaeaCVaijmCTNOX5sKyX0ViQ==
Received: from MW2PR16CA0046.namprd16.prod.outlook.com (2603:10b6:907:1::23)
 by CY5PR12MB6108.namprd12.prod.outlook.com (2603:10b6:930:27::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.16; Thu, 8 Sep
 2022 18:35:27 +0000
Received: from CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:907:1:cafe::40) by MW2PR16CA0046.outlook.office365.com
 (2603:10b6:907:1::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.19 via Frontend
 Transport; Thu, 8 Sep 2022 18:35:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=bestguesspass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT051.mail.protection.outlook.com (10.13.174.114) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5612.13 via Frontend Transport; Thu, 8 Sep 2022 18:35:25 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 8 Sep
 2022 18:35:25 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail202.nvidia.com
 (10.129.68.7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Thu, 8 Sep 2022
 11:35:24 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.9)
 with Microsoft SMTP Server id 15.2.986.29 via Frontend Transport; Thu, 8 Sep
 2022 11:35:21 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V7 vfio 04/10] vfio: Add an IOVA bitmap support
Date:   Thu, 8 Sep 2022 21:34:42 +0300
Message-ID: <20220908183448.195262-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220908183448.195262-1-yishaih@nvidia.com>
References: <20220908183448.195262-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT051:EE_|CY5PR12MB6108:EE_
X-MS-Office365-Filtering-Correlation-Id: 459b5bf2-915e-4c9b-9452-08da91c8e5ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HEaTqdp0tyFW+i+6vnYtGko5rbmihA4twn//cqVDAdjvtRiAM2G6niXk2f89s3B/Hg3OlBSRxyLjv90pYCjRFvpxnDgbevW3m7465kIJ97xsaH0jG5fVBaXLKZ+WEvNIaDDbAIcZajAAsVxJWgUQ3kZuNGQqUvqI4zTtsr5lqB1wYP3u0C01TsL3z/rDhwvjZLdBh6Jzf8ZDQSd+rzmJbFJbgajcx/ngQEvvDQMzgbghlKdx4nsMv+9Dp2JDjxaLbOB8K3egOEyIRWYsXYoxYbnAcmbFY3nmNP2OqvNE9hUIzs52PeJhxUt4Hs5hEgCClLztbjd2L98LaeOCGxOg/SIxKzQvSPnL1+KgLNyQVrynSe4EKG4v5wUVhdhzMVgdOoHRvgPVA+0oknYbJk+AIzJ8OOY/e50LYoqNMogHy1EXLJfQGczn/eNmdUNleftohtvtTRDCizcdasiYe/DDAsc7ls9oDtXfzv3VP1nZaQkne8zG1eZOr02k3MpcGBnMCNXrlxGwOP7ysJTZeaZjfKJbDUBvRrlmTUeSE6wklThj37u7i2mpFxlp9cGOkzMyW8NC/6zseUiRyFinFfVi06T2VRe4jFEbcRQJHhKaLJ/hPSga2S8ywK4u4m3CeGVd19NKV4lOgL2ClC3YKjbhWNISaW+q8clHjDclAwuHH7ShXb3G/kzyrHWbtkyF2Iy37J2Af+uNiaPg52YtbMD9fs62PrpF0w56RURMo7Y3rrnos/aqsgt2/Im3k0nfudILG4p1L1YZiWtn5Gy1UyQwldhxPOX1iN/A6z2FfQ69el1pBP8dXOHSWiZG/H3Epok7
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(39860400002)(136003)(36840700001)(46966006)(40470700004)(8676002)(83380400001)(40480700001)(110136005)(7696005)(40460700003)(54906003)(36756003)(5660300002)(30864003)(82310400005)(6636002)(2906002)(8936002)(4326008)(86362001)(316002)(6666004)(478600001)(356005)(82740400003)(81166007)(70586007)(70206006)(426003)(26005)(36860700001)(2616005)(1076003)(47076005)(41300700001)(336012)(186003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2022 18:35:25.9947
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 459b5bf2-915e-4c9b-9452-08da91c8e5ce
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6108
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joao Martins <joao.m.martins@oracle.com>

The new facility adds a bunch of wrappers that abstract how an IOVA range
is represented in a bitmap that is granulated by a given page_size. So it
translates all the lifting of dealing with user pointers into its
corresponding kernel addresses backing said user memory into doing finally
the (non-atomic) bitmap ops to change various bits.

The formula for the bitmap is:

   data[(iova / page_size) / 64] & (1ULL << (iova % 64))

Where 64 is the number of bits in a unsigned long (depending on arch)

It introduces an IOVA iterator that uses a windowing scheme to minimize the
pinning overhead, as opposed to pinning it on demand 4K at a time. Assuming
a 4K kernel page and 4K requested page size, we can use a single kernel
page to hold 512 page pointers, mapping 2M of bitmap, representing 64G of
IOVA space.

An example usage of these helpers for a given @base_iova, @page_size,
@length and __user @data:

   bitmap = iova_bitmap_alloc(base_iova, page_size, length, data);
   if (IS_ERR(bitmap))
       return -ENOMEM;

   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);

   iova_bitmap_free(bitmap);

Each iteration of the @dirty_reporter_fn is called with a unique @iova
and @length argument, indicating the current range available through the
iova_bitmap. The @dirty_reporter_fn uses iova_bitmap_set() to mark dirty
areas (@iova_length) within that provided range, as following:

   iova_bitmap_set(bitmap, iova, iova_length);

The facility is intended to be used for user bitmaps representing dirtied
IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Makefile       |   6 +-
 drivers/vfio/iova_bitmap.c  | 422 ++++++++++++++++++++++++++++++++++++
 include/linux/iova_bitmap.h |  26 +++
 3 files changed, 452 insertions(+), 2 deletions(-)
 create mode 100644 drivers/vfio/iova_bitmap.c
 create mode 100644 include/linux/iova_bitmap.h

diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
index 1a32357592e3..d67c604d0407 100644
--- a/drivers/vfio/Makefile
+++ b/drivers/vfio/Makefile
@@ -1,9 +1,11 @@
 # SPDX-License-Identifier: GPL-2.0
 vfio_virqfd-y := virqfd.o
 
-vfio-y += vfio_main.o
-
 obj-$(CONFIG_VFIO) += vfio.o
+
+vfio-y += vfio_main.o \
+	  iova_bitmap.o \
+
 obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
 obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
 obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
new file mode 100644
index 000000000000..6631e8befe1b
--- /dev/null
+++ b/drivers/vfio/iova_bitmap.c
@@ -0,0 +1,422 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+#include <linux/iova_bitmap.h>
+#include <linux/mm.h>
+#include <linux/highmem.h>
+
+#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
+
+/*
+ * struct iova_bitmap_map - A bitmap representing an IOVA range
+ *
+ * Main data structure for tracking mapped user pages of bitmap data.
+ *
+ * For example, for something recording dirty IOVAs, it will be provided a
+ * struct iova_bitmap structure, as a general structure for iterating the
+ * total IOVA range. The struct iova_bitmap_map, though, represents the
+ * subset of said IOVA space that is pinned by its parent structure (struct
+ * iova_bitmap).
+ *
+ * The user does not need to exact location of the bits in the bitmap.
+ * From user perspective the only API available is iova_bitmap_set() which
+ * records the IOVA *range* in the bitmap by setting the corresponding
+ * bits.
+ *
+ * The bitmap is an array of u64 whereas each bit represents an IOVA of
+ * range of (1 << pgshift). Thus formula for the bitmap data to be set is:
+ *
+ *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
+ */
+struct iova_bitmap_map {
+	/* base IOVA representing bit 0 of the first page */
+	unsigned long iova;
+
+	/* page size order that each bit granules to */
+	unsigned long pgshift;
+
+	/* page offset of the first user page pinned */
+	unsigned long pgoff;
+
+	/* number of pages pinned */
+	unsigned long npages;
+
+	/* pinned pages representing the bitmap data */
+	struct page **pages;
+};
+
+/*
+ * struct iova_bitmap - The IOVA bitmap object
+ *
+ * Main data structure for iterating over the bitmap data.
+ *
+ * Abstracts the pinning work and iterates in IOVA ranges.
+ * It uses a windowing scheme and pins the bitmap in relatively
+ * big ranges e.g.
+ *
+ * The bitmap object uses one base page to store all the pinned pages
+ * pointers related to the bitmap. For sizeof(struct page*) == 8 it stores
+ * 512 struct page pointers which, if the base page size is 4K, it means
+ * 2M of bitmap data is pinned at a time. If the iova_bitmap page size is
+ * also 4K then the range window to iterate is 64G.
+ *
+ * For example iterating on a total IOVA range of 4G..128G, it will walk
+ * through this set of ranges:
+ *
+ *    4G  -  68G-1 (64G)
+ *    68G - 128G-1 (64G)
+ *
+ * An example of the APIs on how to use/iterate over the IOVA bitmap:
+ *
+ *   bitmap = iova_bitmap_alloc(iova, length, page_size, data);
+ *   if (IS_ERR(bitmap))
+ *       return PTR_ERR(bitmap);
+ *
+ *   ret = iova_bitmap_for_each(bitmap, arg, dirty_reporter_fn);
+ *
+ *   iova_bitmap_free(bitmap);
+ *
+ * Each iteration of the @dirty_reporter_fn is called with a unique @iova
+ * and @length argument, indicating the current range available through the
+ * iova_bitmap. The @dirty_reporter_fn uses iova_bitmap_set() to mark dirty
+ * areas (@iova_length) within that provided range, as following:
+ *
+ *   iova_bitmap_set(bitmap, iova, iova_length);
+ *
+ * The internals of the object uses an index @mapped_base_index that indexes
+ * which u64 word of the bitmap is mapped, up to @mapped_total_index.
+ * Those keep being incremented until @mapped_total_index is reached while
+ * mapping up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
+ *
+ * The IOVA bitmap is usually located on what tracks DMA mapped ranges or
+ * some form of IOVA range tracking that co-relates to the user passed
+ * bitmap.
+ */
+struct iova_bitmap {
+	/* IOVA range representing the currently mapped bitmap data */
+	struct iova_bitmap_map mapped;
+
+	/* userspace address of the bitmap */
+	u64 __user *bitmap;
+
+	/* u64 index that @mapped points to */
+	unsigned long mapped_base_index;
+
+	/* how many u64 can we walk in total */
+	unsigned long mapped_total_index;
+
+	/* base IOVA of the whole bitmap */
+	unsigned long iova;
+
+	/* length of the IOVA range for the whole bitmap */
+	size_t length;
+};
+
+/*
+ * Converts a relative IOVA to a bitmap index.
+ * This function provides the index into the u64 array (bitmap::bitmap)
+ * for a given IOVA offset.
+ * Relative IOVA means relative to the bitmap::mapped base IOVA
+ * (stored in mapped::iova). All computations in this file are done using
+ * relative IOVAs and thus avoid an extra subtraction against mapped::iova.
+ * The user API iova_bitmap_set() always uses a regular absolute IOVAs.
+ */
+static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
+						 unsigned long iova)
+{
+	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
+
+	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
+}
+
+/*
+ * Converts a bitmap index to a *relative* IOVA.
+ */
+static unsigned long iova_bitmap_index_to_offset(struct iova_bitmap *bitmap,
+						 unsigned long index)
+{
+	unsigned long pgshift = bitmap->mapped.pgshift;
+
+	return (index * BITS_PER_TYPE(*bitmap->bitmap)) << pgshift;
+}
+
+/*
+ * Returns the base IOVA of the mapped range.
+ */
+static unsigned long iova_bitmap_mapped_iova(struct iova_bitmap *bitmap)
+{
+	unsigned long skip = bitmap->mapped_base_index;
+
+	return bitmap->iova + iova_bitmap_index_to_offset(bitmap, skip);
+}
+
+/*
+ * Pins the bitmap user pages for the current range window.
+ * This is internal to IOVA bitmap and called when advancing the
+ * index (@mapped_base_index) or allocating the bitmap.
+ */
+static int iova_bitmap_get(struct iova_bitmap *bitmap)
+{
+	struct iova_bitmap_map *mapped = &bitmap->mapped;
+	unsigned long npages;
+	u64 __user *addr;
+	long ret;
+
+	/*
+	 * @mapped_base_index is the index of the currently mapped u64 words
+	 * that we have access. Anything before @mapped_base_index is not
+	 * mapped. The range @mapped_base_index .. @mapped_total_index-1 is
+	 * mapped but capped at a maximum number of pages.
+	 */
+	npages = DIV_ROUND_UP((bitmap->mapped_total_index -
+			       bitmap->mapped_base_index) *
+			       sizeof(*bitmap->bitmap), PAGE_SIZE);
+
+	/*
+	 * We always cap at max number of 'struct page' a base page can fit.
+	 * This is, for example, on x86 means 2M of bitmap data max.
+	 */
+	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
+
+	/*
+	 * Bitmap address to be pinned is calculated via pointer arithmetic
+	 * with bitmap u64 word index.
+	 */
+	addr = bitmap->bitmap + bitmap->mapped_base_index;
+
+	ret = pin_user_pages_fast((unsigned long)addr, npages,
+				  FOLL_WRITE, mapped->pages);
+	if (ret <= 0)
+		return -EFAULT;
+
+	mapped->npages = (unsigned long)ret;
+	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
+	mapped->iova = iova_bitmap_mapped_iova(bitmap);
+
+	/*
+	 * offset of the page where pinned pages bit 0 is located.
+	 * This handles the case where the bitmap is not PAGE_SIZE
+	 * aligned.
+	 */
+	mapped->pgoff = offset_in_page(addr);
+	return 0;
+}
+
+/*
+ * Unpins the bitmap user pages and clears @npages
+ * (un)pinning is abstracted from API user and it's done when advancing
+ * the index or freeing the bitmap.
+ */
+static void iova_bitmap_put(struct iova_bitmap *bitmap)
+{
+	struct iova_bitmap_map *mapped = &bitmap->mapped;
+
+	if (mapped->npages) {
+		unpin_user_pages(mapped->pages, mapped->npages);
+		mapped->npages = 0;
+	}
+}
+
+/**
+ * iova_bitmap_alloc() - Allocates an IOVA bitmap object
+ * @iova: Start address of the IOVA range
+ * @length: Length of the IOVA range
+ * @page_size: Page size of the IOVA bitmap. It defines what each bit
+ *             granularity represents
+ * @data: Userspace address of the bitmap
+ *
+ * Allocates an IOVA object and initializes all its fields including the
+ * first user pages of @data.
+ *
+ * Return: A pointer to a newly allocated struct iova_bitmap
+ * or ERR_PTR() on error.
+ */
+struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
+				      unsigned long page_size, u64 __user *data)
+{
+	struct iova_bitmap_map *mapped;
+	struct iova_bitmap *bitmap;
+	int rc;
+
+	bitmap = kzalloc(sizeof(*bitmap), GFP_KERNEL);
+	if (!bitmap)
+		return ERR_PTR(-ENOMEM);
+
+	mapped = &bitmap->mapped;
+	mapped->pgshift = __ffs(page_size);
+	bitmap->bitmap = data;
+	bitmap->mapped_total_index =
+		iova_bitmap_offset_to_index(bitmap, length - 1) + 1;
+	bitmap->iova = iova;
+	bitmap->length = length;
+	mapped->iova = iova;
+	mapped->pages = (struct page **)__get_free_page(GFP_KERNEL);
+	if (!mapped->pages) {
+		rc = -ENOMEM;
+		goto err;
+	}
+
+	rc = iova_bitmap_get(bitmap);
+	if (rc)
+		goto err;
+	return bitmap;
+
+err:
+	iova_bitmap_free(bitmap);
+	return ERR_PTR(rc);
+}
+
+/**
+ * iova_bitmap_free() - Frees an IOVA bitmap object
+ * @bitmap: IOVA bitmap to free
+ *
+ * It unpins and releases pages array memory and clears any leftover
+ * state.
+ */
+void iova_bitmap_free(struct iova_bitmap *bitmap)
+{
+	struct iova_bitmap_map *mapped = &bitmap->mapped;
+
+	iova_bitmap_put(bitmap);
+
+	if (mapped->pages) {
+		free_page((unsigned long)mapped->pages);
+		mapped->pages = NULL;
+	}
+
+	kfree(bitmap);
+}
+
+/*
+ * Returns the remaining bitmap indexes from mapped_total_index to process for
+ * the currently pinned bitmap pages.
+ */
+static unsigned long iova_bitmap_mapped_remaining(struct iova_bitmap *bitmap)
+{
+	unsigned long remaining;
+
+	remaining = bitmap->mapped_total_index - bitmap->mapped_base_index;
+	remaining = min_t(unsigned long, remaining,
+	      (bitmap->mapped.npages << PAGE_SHIFT) / sizeof(*bitmap->bitmap));
+
+	return remaining;
+}
+
+/*
+ * Returns the length of the mapped IOVA range.
+ */
+static unsigned long iova_bitmap_mapped_length(struct iova_bitmap *bitmap)
+{
+	unsigned long max_iova = bitmap->iova + bitmap->length - 1;
+	unsigned long iova = iova_bitmap_mapped_iova(bitmap);
+	unsigned long remaining;
+
+	/*
+	 * iova_bitmap_mapped_remaining() returns a number of indexes which
+	 * when converted to IOVA gives us a max length that the bitmap
+	 * pinned data can cover. Afterwards, that is capped to
+	 * only cover the IOVA range in @bitmap::iova .. @bitmap::length.
+	 */
+	remaining = iova_bitmap_index_to_offset(bitmap,
+			iova_bitmap_mapped_remaining(bitmap));
+
+	if (iova + remaining - 1 > max_iova)
+		remaining -= ((iova + remaining - 1) - max_iova);
+
+	return remaining;
+}
+
+/*
+ * Returns true if there's not more data to iterate.
+ */
+static bool iova_bitmap_done(struct iova_bitmap *bitmap)
+{
+	return bitmap->mapped_base_index >= bitmap->mapped_total_index;
+}
+
+/*
+ * Advances to the next range, releases the current pinned
+ * pages and pins the next set of bitmap pages.
+ * Returns 0 on success or otherwise errno.
+ */
+static int iova_bitmap_advance(struct iova_bitmap *bitmap)
+{
+	unsigned long iova = iova_bitmap_mapped_length(bitmap) - 1;
+	unsigned long count = iova_bitmap_offset_to_index(bitmap, iova) + 1;
+
+	bitmap->mapped_base_index += count;
+
+	iova_bitmap_put(bitmap);
+	if (iova_bitmap_done(bitmap))
+		return 0;
+
+	/* When advancing the index we pin the next set of bitmap pages */
+	return iova_bitmap_get(bitmap);
+}
+
+/**
+ * iova_bitmap_for_each() - Iterates over the bitmap
+ * @bitmap: IOVA bitmap to iterate
+ * @opaque: Additional argument to pass to the callback
+ * @fn: Function that gets called for each IOVA range
+ *
+ * Helper function to iterate over bitmap data representing a portion of IOVA
+ * space. It hides the complexity of iterating bitmaps and translating the
+ * mapped bitmap user pages into IOVA ranges to process.
+ *
+ * Return: 0 on success, and an error on failure either upon
+ * iteration or when the callback returns an error.
+ */
+int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
+			 iova_bitmap_fn_t fn)
+{
+	int ret = 0;
+
+	for (; !iova_bitmap_done(bitmap) && !ret;
+	     ret = iova_bitmap_advance(bitmap)) {
+		ret = fn(bitmap, iova_bitmap_mapped_iova(bitmap),
+			 iova_bitmap_mapped_length(bitmap), opaque);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+/**
+ * iova_bitmap_set() - Records an IOVA range in bitmap
+ * @bitmap: IOVA bitmap
+ * @iova: IOVA to start
+ * @length: IOVA range length
+ *
+ * Set the bits corresponding to the range [iova .. iova+length-1] in
+ * the user bitmap.
+ *
+ * Return: The number of bits set.
+ */
+void iova_bitmap_set(struct iova_bitmap *bitmap,
+		     unsigned long iova, size_t length)
+{
+	struct iova_bitmap_map *mapped = &bitmap->mapped;
+	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
+	unsigned long nbits = max_t(unsigned long, 1, length >> mapped->pgshift);
+	unsigned long page_idx = offset / BITS_PER_PAGE;
+	unsigned long page_offset = mapped->pgoff;
+	void *kaddr;
+
+	offset = offset % BITS_PER_PAGE;
+
+	do {
+		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
+
+		kaddr = kmap_local_page(mapped->pages[page_idx]);
+		bitmap_set(kaddr + page_offset, offset, size);
+		kunmap_local(kaddr);
+		page_offset = offset = 0;
+		nbits -= size;
+		page_idx++;
+	} while (nbits > 0);
+}
+EXPORT_SYMBOL_GPL(iova_bitmap_set);
diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
new file mode 100644
index 000000000000..c006cf0a25f3
--- /dev/null
+++ b/include/linux/iova_bitmap.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2022, Oracle and/or its affiliates.
+ * Copyright (c) 2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+#ifndef _IOVA_BITMAP_H_
+#define _IOVA_BITMAP_H_
+
+#include <linux/types.h>
+
+struct iova_bitmap;
+
+typedef int (*iova_bitmap_fn_t)(struct iova_bitmap *bitmap,
+				unsigned long iova, size_t length,
+				void *opaque);
+
+struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
+				      unsigned long page_size,
+				      u64 __user *data);
+void iova_bitmap_free(struct iova_bitmap *bitmap);
+int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
+			 iova_bitmap_fn_t fn);
+void iova_bitmap_set(struct iova_bitmap *bitmap,
+		     unsigned long iova, size_t length);
+
+#endif
-- 
2.18.1

