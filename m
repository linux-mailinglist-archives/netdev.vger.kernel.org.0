Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4265A935E
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 11:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbiIAJlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 05:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233657AbiIAJlT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 05:41:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3856D1275C3;
        Thu,  1 Sep 2022 02:41:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWMLV+lP2zwFKMBuWzh5Vvje1X3ssjOaWPcyFVx6QWLbMWtv5RcQxTlbD/Pl0iNXPP0BLh0O2pEZSS6Q8CY5aANEBNJgt87hGQI3ggBuDE2vHzB2iHifTykWDR+OmYBFc4vk6VGQWVkfGSePL1Jj804sdmoaJ+Sit0l4n/OEnFkt91w/uv5wxQvLVZkWzTfMy8llj3p5qNABNpqnshhXat8kHm3RRwmYClxHq4eK0JR2gJVzYnPd7Pq5n1p5oWQg1W0Ac6KOd6jjBCFxm1R9nxJSe+nK8x8zmKddksH2hcwFXrD1tjWIheIE+8J518oE4fTGH2D8IEkym1v/mScH9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HtBspUcaLnb7pelswA6vSBhAcUtN1JTVPK7JJ7LZzIc=;
 b=L7NGfqMeh67Q5mlsl02EZ9HCO/EKxZBQJ9S3rSLjWKnYqJhh3iir/m6focbErvKi78jcRh2sWaHbyEIopbzwhwVkAevccDz9B8FtXkL5hNaY/FWRQvDEjAJykNwk+63lNZwM2/dhdwYCTHb5Rms+zxEeif1WZ7SKBkwDxq19LgobiydZIUw/03Oxho6Ew/38DocPq8h3/cHdxkFtdeg3ukbTAF41ESG5gjQamNi0nlifFTAhYaFvLLg32hDDVsBT+bvuDH1upsyR1RbwmTJ93Gdy21L+sbcfenncqQDeXHpZHyNAULU4dGR+aBGO5og9ftWbiHHmrn4AlYD1OaeuJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.234) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HtBspUcaLnb7pelswA6vSBhAcUtN1JTVPK7JJ7LZzIc=;
 b=Fp5ZvHi1xKCvN4FL8WPCkUFnk69X9ErwV5xjFM9UI6fTmq0plmg4nd3Mxn6SDbZDNaKpIz0fSRFP/OF0qkr2C9MFN8t923QBul+b6IhmtuKuctrc8p1EBUWcL94IXtitgXio7UdNd3hOO31liHp0BtPAWi32izZtPdOCXrAXwAxIYbrnWcRIjgvtfo+ci23SEWER/D06ps2VQeKM+wc9iKa5chkIL8usJe1+BLa4hTz+70C/9Fz8RG5nMKs4oN59kIr6JF3oQ17Pg2bs4wztr/lHkodPkoQsEmHjUjRFVX+5USwapR0q630N3nXdP6E+CwQJrsWeQb4dVw63dJcCug==
Received: from MW4PR04CA0215.namprd04.prod.outlook.com (2603:10b6:303:87::10)
 by PH0PR12MB5647.namprd12.prod.outlook.com (2603:10b6:510:144::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Thu, 1 Sep
 2022 09:41:14 +0000
Received: from CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:87:cafe::c4) by MW4PR04CA0215.outlook.office365.com
 (2603:10b6:303:87::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.20 via Frontend
 Transport; Thu, 1 Sep 2022 09:41:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.234 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.234; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.234) by
 CO1NAM11FT045.mail.protection.outlook.com (10.13.175.181) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5588.10 via Frontend Transport; Thu, 1 Sep 2022 09:41:14 +0000
Received: from drhqmail201.nvidia.com (10.126.190.180) by
 DRHQMAIL101.nvidia.com (10.27.9.10) with Microsoft SMTP Server (TLS) id
 15.0.1497.38; Thu, 1 Sep 2022 09:40:42 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by
 drhqmail201.nvidia.com (10.126.190.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Thu, 1 Sep 2022 02:40:42 -0700
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com
 (10.126.190.182) with Microsoft SMTP Server id 15.2.986.29 via Frontend
 Transport; Thu, 1 Sep 2022 02:40:39 -0700
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <jgg@nvidia.com>
CC:     <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <yishaih@nvidia.com>, <maorg@nvidia.com>,
        <cohuck@redhat.com>
Subject: [PATCH V5 vfio 04/10] vfio: Add an IOVA bitmap support
Date:   Thu, 1 Sep 2022 12:38:47 +0300
Message-ID: <20220901093853.60194-5-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220901093853.60194-1-yishaih@nvidia.com>
References: <20220901093853.60194-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40d30024-00bb-425c-975a-08da8bfe1c87
X-MS-TrafficTypeDiagnostic: PH0PR12MB5647:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VOWOSMfvtKZVHpiBM8+V7l3KIfummMbMK3tH6RZ8N/PoWFc11SFaaI4a4m0RbWA6v70RUBrIPOkf3LAGLOb5d+O3lKq252sv05K5ZKG9Q9hC3xnQFKro6/IEEkSVSC8FptLJaUl5F0exwtOoKyVHzdK9lpyt/fnzohTrBAzBqjrnQEUxP+Styj7vefwSP2mmAPaDsahd7GQFeJYMOOJo+TqxohQxhNw4Q9McK6byHKqN8g8zckWl9l7WM2hfikPHCAzCtOxrjrQ8XFeLhabCAM/onPbzZN7R+FlEvRp5+4dvf7b/Ms/azwEGoWZfZHA9veP0oS5wx2XGhjcgidma+4AYbn9QOSzWv9UofGDPEIOaoyKiamUHiU2EqUMLpVMIRyrOKi5+/2c8NQvM7Cc0Vi9N3jHBGB/PebjLiBxHK29Jv0bt3FUTwdcaI6V5IO/svr7417i80KwAYXHHF97vnmCzFHTJd5SUBjunAcwBl+1XL7xBceP/B5saqSQmDFVX63tWlMFNTYgPsdyBE2itt2sAaRySySx7/dxxbj1zODHkMfaSXoKWAvZOTUdzE1wJJcNkPYOrSu+rj6Ocd8KPU/AF2OTz5qZxT+telrpCxHs0uK4TxiHlGYunV0R0f1+YH6OnvhZw/TOykkWA4/cDiMZmzfCohrdwvM2d0+/KHE54RbroKpKuBMERb646RsCOpOlt/Dy4t83xy+/rMCV0ZQ65Vlf2Zxrsm0+wQW6ypROkJPTy/cnyGh+zy86RaHilRWif0SI/qzqHtk1udKXRaaVnI3DjlKYZagBIQNxekWeOrlg/tYh2YhrH/hlCzY3C
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(136003)(376002)(40470700004)(46966006)(36840700001)(40480700001)(86362001)(7696005)(426003)(47076005)(2906002)(40460700003)(186003)(2616005)(26005)(1076003)(478600001)(4326008)(70206006)(336012)(8676002)(70586007)(8936002)(82740400003)(41300700001)(82310400005)(36860700001)(5660300002)(54906003)(110136005)(6636002)(36756003)(83380400001)(30864003)(316002)(81166007)(6666004)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Sep 2022 09:41:14.1855
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40d30024-00bb-425c-975a-08da8bfe1c87
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT045.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5647
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

An implementation of the lower end -- referred to above as
dirty_reporter_fn to exemplify -- that is tracking dirty bits would mark
an IOVA as dirty as following:

	iova_bitmap_set(bitmap, iova, page_size);

Or a contiguous range (example two pages):

	iova_bitmap_set(bitmap, iova, 2 * page_size);

The facility is intended to be used for user bitmaps representing dirtied
IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).

Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
---
 drivers/vfio/Makefile       |   6 +-
 drivers/vfio/iova_bitmap.c  | 426 ++++++++++++++++++++++++++++++++++++
 include/linux/iova_bitmap.h |  24 ++
 3 files changed, 454 insertions(+), 2 deletions(-)
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
index 000000000000..4211a16eb542
--- /dev/null
+++ b/drivers/vfio/iova_bitmap.c
@@ -0,0 +1,426 @@
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
+ * pointers related to the bitmap. For sizeof(struct page) == 64 it stores
+ * 512 struct pages which, if the base page size is 4K, it means 2M of bitmap
+ * data is pinned at a time. If the iova_bitmap page size is also 4K
+ * then the range window to iterate is 64G.
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
+ * An implementation of the lower end (referred to above as
+ * dirty_reporter_fn to exemplify), that is tracking dirty bits would mark
+ * an IOVA as dirty as following:
+ *     iova_bitmap_set(bitmap, iova, page_size);
+ * Or a contiguous range (example two pages):
+ *     iova_bitmap_set(bitmap, iova, 2 * page_size);
+ *
+ * The internals of the object uses an index @mapped_base_index that indexes
+ * which u64 word of the bitmap is mapped, up to @mapped_total_index.
+ * Those keep being incremented until @mapped_total_index reaches while
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
+			 int (*fn)(struct iova_bitmap *bitmap,
+				   unsigned long iova, size_t length,
+				   void *opaque))
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
+unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
+			      unsigned long iova, size_t length)
+{
+	struct iova_bitmap_map *mapped = &bitmap->mapped;
+	unsigned long nbits = max(1UL, length >> mapped->pgshift), set = nbits;
+	unsigned long offset = (iova - mapped->iova) >> mapped->pgshift;
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
+
+	return set;
+}
+EXPORT_SYMBOL_GPL(iova_bitmap_set);
diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
new file mode 100644
index 000000000000..ab3b4fa6ac48
--- /dev/null
+++ b/include/linux/iova_bitmap.h
@@ -0,0 +1,24 @@
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
+struct iova_bitmap *iova_bitmap_alloc(unsigned long iova, size_t length,
+				      unsigned long page_size,
+				      u64 __user *data);
+void iova_bitmap_free(struct iova_bitmap *bitmap);
+int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *opaque,
+			 int (*fn)(struct iova_bitmap *bitmap,
+				   unsigned long iova, size_t length,
+				   void *opaque));
+unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
+			      unsigned long iova, size_t length);
+
+#endif
-- 
2.18.1

