Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAF2C10961E
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 00:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbfKYXLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 18:11:20 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:3729 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727491AbfKYXLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 18:11:07 -0500
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqemgate15.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ddc5f830001>; Mon, 25 Nov 2019 15:10:59 -0800
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Mon, 25 Nov 2019 15:11:04 -0800
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Mon, 25 Nov 2019 15:11:04 -0800
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL105.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 25 Nov
 2019 23:11:03 +0000
Received: from rnnvemgw01.nvidia.com (10.128.109.123) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3 via Frontend
 Transport; Mon, 25 Nov 2019 23:11:02 +0000
Received: from blueforge.nvidia.com (Not Verified[10.110.48.28]) by rnnvemgw01.nvidia.com with Trustwave SEG (v7,5,8,10121)
        id <B5ddc5f850001>; Mon, 25 Nov 2019 15:11:02 -0800
From:   John Hubbard <jhubbard@nvidia.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, <bpf@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>, <kvm@vger.kernel.org>,
        <linux-block@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <linux-media@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <netdev@vger.kernel.org>,
        <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        John Hubbard <jhubbard@nvidia.com>
Subject: [PATCH v2 19/19] mm, tree-wide: rename put_user_page*() to unpin_user_page*()
Date:   Mon, 25 Nov 2019 15:10:35 -0800
Message-ID: <20191125231035.1539120-20-jhubbard@nvidia.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191125231035.1539120-1-jhubbard@nvidia.com>
References: <20191125231035.1539120-1-jhubbard@nvidia.com>
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1574723459; bh=OjO2amvRsP/9L4RAk+nljzLtRq+I0eWgQ0p3gdYjuFo=;
        h=X-PGP-Universal:From:To:CC:Subject:Date:Message-ID:X-Mailer:
         In-Reply-To:References:MIME-Version:X-NVConfidentiality:
         Content-Transfer-Encoding:Content-Type;
        b=G6khlBJ7mlyXq27Z35V5HxQ/0SY61MBnHULKYfxAdkB1/S4yZYev42180lOiHuVZM
         mARMUOg20+TTqUBaKPzT/6e35eoBFA7JR1eIiFctes4Gz+UruiYAkkZ5z0Hy7bIBne
         URtmL52iIcNE7/UxzkNFIUc1AOqnjMQ9wc1ByHKlOq5mk1efPIu133KcwXFfY+HBQ+
         oROnXj7ZZxce9uuXAMvJGNNBcscAvr5W9CLTVoOa0xyM4hcau/GO3dtiScAD1LWeD8
         BWqdZJeaDCln08UCFG+cfVVEVp8NbjtfaeEoGTet9P2e3T7QWcEEDKouiWV2ZaK01M
         4ArmOZ2fGK4sw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to provide a clearer, more symmetric API for pinning
and unpinning DMA pages. This way, pin_user_pages*() calls
match up with unpin_user_pages*() calls, and the API is a lot
closer to being self-explanatory.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
---
 Documentation/core-api/pin_user_pages.rst   |  2 +-
 arch/powerpc/mm/book3s64/iommu_api.c        |  4 +--
 drivers/gpu/drm/via/via_dmablit.c           |  4 +--
 drivers/infiniband/core/umem.c              |  2 +-
 drivers/infiniband/hw/hfi1/user_pages.c     |  2 +-
 drivers/infiniband/hw/mthca/mthca_memfree.c |  6 ++--
 drivers/infiniband/hw/qib/qib_user_pages.c  |  2 +-
 drivers/infiniband/hw/qib/qib_user_sdma.c   |  6 ++--
 drivers/infiniband/hw/usnic/usnic_uiom.c    |  2 +-
 drivers/infiniband/sw/siw/siw_mem.c         |  2 +-
 drivers/media/v4l2-core/videobuf-dma-sg.c   |  4 +--
 drivers/platform/goldfish/goldfish_pipe.c   |  4 +--
 drivers/vfio/vfio_iommu_type1.c             |  2 +-
 fs/io_uring.c                               |  4 +--
 include/linux/mm.h                          | 26 ++++++++---------
 mm/gup.c                                    | 32 ++++++++++-----------
 mm/process_vm_access.c                      |  4 +--
 net/xdp/xdp_umem.c                          |  2 +-
 18 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core=
-api/pin_user_pages.rst
index 4f26637a5005..bba96428ade7 100644
--- a/Documentation/core-api/pin_user_pages.rst
+++ b/Documentation/core-api/pin_user_pages.rst
@@ -220,7 +220,7 @@ since the system was booted, via two new /proc/vmstat e=
ntries: ::
     /proc/vmstat/nr_foll_pin_requested
=20
 Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
-because there is a noticeable performance drop in put_user_page(), when th=
ey
+because there is a noticeable performance drop in unpin_user_page(), when =
they
 are activated.
=20
 References
diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s6=
4/iommu_api.c
index fc1670a6fc3c..b965a0dfd4a2 100644
--- a/arch/powerpc/mm/book3s64/iommu_api.c
+++ b/arch/powerpc/mm/book3s64/iommu_api.c
@@ -168,7 +168,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, uns=
igned long ua,
=20
 free_exit:
 	/* free the references taken */
-	put_user_pages(mem->hpages, pinned);
+	unpin_user_pages(mem->hpages, pinned);
=20
 	vfree(mem->hpas);
 	kfree(mem);
@@ -211,7 +211,7 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_=
mem_t *mem)
 		if (!page)
 			continue;
=20
-		put_user_pages_dirty_lock(&page, 1,
+		unpin_user_pages_dirty_lock(&page, 1,
 				mem->hpas[i] & MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);
=20
 		mem->hpas[i] =3D 0;
diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dm=
ablit.c
index 37c5e572993a..719d036c9384 100644
--- a/drivers/gpu/drm/via/via_dmablit.c
+++ b/drivers/gpu/drm/via/via_dmablit.c
@@ -188,8 +188,8 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_=
t *vsg)
 		kfree(vsg->desc_pages);
 		/* fall through */
 	case dr_via_pages_locked:
-		put_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
-					  (vsg->direction =3D=3D DMA_FROM_DEVICE));
+		unpin_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
+					   (vsg->direction =3D=3D DMA_FROM_DEVICE));
 		/* fall through */
 	case dr_via_pages_alloc:
 		vfree(vsg->pages);
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.=
c
index 39a1542e6707..663b5c785716 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -54,7 +54,7 @@ static void __ib_umem_release(struct ib_device *dev, stru=
ct ib_umem *umem, int d
=20
 	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
 		page =3D sg_page_iter_page(&sg_iter);
-		put_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
+		unpin_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
 	}
=20
 	sg_free_table(&umem->sg_head);
diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/h=
w/hfi1/user_pages.c
index 9a94761765c0..3b505006c0a6 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -118,7 +118,7 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsig=
ned long vaddr, size_t np
 void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
 			     size_t npages, bool dirty)
 {
-	put_user_pages_dirty_lock(p, npages, dirty);
+	unpin_user_pages_dirty_lock(p, npages, dirty);
=20
 	if (mm) { /* during close after signal, mm can be NULL */
 		atomic64_sub(npages, &mm->pinned_vm);
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniba=
nd/hw/mthca/mthca_memfree.c
index 8269ab040c21..78a48aea3faf 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -482,7 +482,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mth=
ca_uar *uar,
=20
 	ret =3D pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 	if (ret < 0) {
-		put_user_page(pages[0]);
+		unpin_user_page(pages[0]);
 		goto out;
 	}
=20
@@ -490,7 +490,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mth=
ca_uar *uar,
 				 mthca_uarc_virt(dev, uar, i));
 	if (ret) {
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-		put_user_page(sg_page(&db_tab->page[i].mem));
+		unpin_user_page(sg_page(&db_tab->page[i].mem));
 		goto out;
 	}
=20
@@ -556,7 +556,7 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, s=
truct mthca_uar *uar,
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-			put_user_page(sg_page(&db_tab->page[i].mem));
+			unpin_user_page(sg_page(&db_tab->page[i].mem));
 		}
 	}
=20
diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniban=
d/hw/qib/qib_user_pages.c
index 7fc4b5f81fcd..342e3172ca40 100644
--- a/drivers/infiniband/hw/qib/qib_user_pages.c
+++ b/drivers/infiniband/hw/qib/qib_user_pages.c
@@ -40,7 +40,7 @@
 static void __qib_release_user_pages(struct page **p, size_t num_pages,
 				     int dirty)
 {
-	put_user_pages_dirty_lock(p, num_pages, dirty);
+	unpin_user_pages_dirty_lock(p, num_pages, dirty);
 }
=20
 /**
diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband=
/hw/qib/qib_user_sdma.c
index 1a3cc2957e3a..a67599b5a550 100644
--- a/drivers/infiniband/hw/qib/qib_user_sdma.c
+++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
@@ -317,7 +317,7 @@ static int qib_user_sdma_page_to_frags(const struct qib=
_devdata *dd,
 		 * the caller can ignore this page.
 		 */
 		if (put) {
-			put_user_page(page);
+			unpin_user_page(page);
 		} else {
 			/* coalesce case */
 			kunmap(page);
@@ -631,7 +631,7 @@ static void qib_user_sdma_free_pkt_frag(struct device *=
dev,
 			kunmap(pkt->addr[i].page);
=20
 		if (pkt->addr[i].put_page)
-			put_user_page(pkt->addr[i].page);
+			unpin_user_page(pkt->addr[i].page);
 		else
 			__free_page(pkt->addr[i].page);
 	} else if (pkt->addr[i].kvaddr) {
@@ -706,7 +706,7 @@ static int qib_user_sdma_pin_pages(const struct qib_dev=
data *dd,
 	/* if error, return all pages not managed by pkt */
 free_pages:
 	while (i < j)
-		put_user_page(pages[i++]);
+		unpin_user_page(pages[i++]);
=20
 done:
 	return ret;
diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/=
hw/usnic/usnic_uiom.c
index 600896727d34..bd9f944b68fc 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
@@ -75,7 +75,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_=
list, int dirty)
 		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
 			page =3D sg_page(sg);
 			pa =3D sg_phys(sg);
-			put_user_pages_dirty_lock(&page, 1, dirty);
+			unpin_user_pages_dirty_lock(&page, 1, dirty);
 			usnic_dbg("pa: %pa\n", &pa);
 		}
 		kfree(chunk);
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/si=
w/siw_mem.c
index e53b07dcfed5..e2061dc0b043 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -63,7 +63,7 @@ struct siw_mem *siw_mem_id2obj(struct siw_device *sdev, i=
nt stag_index)
 static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
 			   bool dirty)
 {
-	put_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
+	unpin_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
 }
=20
 void siw_umem_release(struct siw_umem *umem, bool dirty)
diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2=
-core/videobuf-dma-sg.c
index 162a2633b1e3..13b65ed9e74c 100644
--- a/drivers/media/v4l2-core/videobuf-dma-sg.c
+++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
@@ -349,8 +349,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
 	BUG_ON(dma->sglen);
=20
 	if (dma->pages) {
-		put_user_pages_dirty_lock(dma->pages, dma->nr_pages,
-					  dma->direction =3D=3D DMA_FROM_DEVICE);
+		unpin_user_pages_dirty_lock(dma->pages, dma->nr_pages,
+					    dma->direction =3D=3D DMA_FROM_DEVICE);
 		kfree(dma->pages);
 		dma->pages =3D NULL;
 	}
diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/g=
oldfish/goldfish_pipe.c
index 2a5901efecde..1ab207ec9c94 100644
--- a/drivers/platform/goldfish/goldfish_pipe.c
+++ b/drivers/platform/goldfish/goldfish_pipe.c
@@ -360,8 +360,8 @@ static int transfer_max_buffers(struct goldfish_pipe *p=
ipe,
=20
 	*consumed_size =3D pipe->command_buffer->rw_params.consumed_size;
=20
-	put_user_pages_dirty_lock(pipe->pages, pages_count,
-				  !is_write && *consumed_size > 0);
+	unpin_user_pages_dirty_lock(pipe->pages, pages_count,
+				    !is_write && *consumed_size > 0);
=20
 	mutex_unlock(&pipe->lock);
 	return 0;
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type=
1.c
index 18bfc2fc8e6d..a177bf2c6683 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -310,7 +310,7 @@ static int put_pfn(unsigned long pfn, int prot)
 	if (!is_invalid_reserved_pfn(pfn)) {
 		struct page *page =3D pfn_to_page(pfn);
=20
-		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
+		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
 		return 1;
 	}
 	return 0;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 869191d8f8d4..acd25b243644 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4118,7 +4118,7 @@ static int io_sqe_buffer_unregister(struct io_ring_ct=
x *ctx)
 		struct io_mapped_ubuf *imu =3D &ctx->user_bufs[i];
=20
 		for (j =3D 0; j < imu->nr_bvecs; j++)
-			put_user_page(imu->bvec[j].bv_page);
+			unpin_user_page(imu->bvec[j].bv_page);
=20
 		if (ctx->account_mem)
 			io_unaccount_mem(ctx->user, imu->nr_bvecs);
@@ -4263,7 +4263,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx =
*ctx, void __user *arg,
 			 * release any pages we did get
 			 */
 			if (pret > 0)
-				put_user_pages(pages, pret);
+				unpin_user_pages(pages, pret);
 			if (ctx->account_mem)
 				io_unaccount_mem(ctx->user, nr_pages);
 			kvfree(imu->bvec);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5fabbc5d10f3..96dd865e3fc9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1036,27 +1036,27 @@ static inline void put_page(struct page *page)
 }
=20
 /**
- * put_user_page() - release a gup-pinned page
+ * unpin_user_page() - release a gup-pinned page
  * @page:            pointer to page to be released
  *
  * Pages that were pinned via pin_user_pages*() must be released via eithe=
r
- * put_user_page(), or one of the put_user_pages*() routines. This is so t=
hat
- * eventually such pages can be separately tracked and uniquely handled. I=
n
+ * unpin_user_page(), or one of the unpin_user_pages*() routines. This is =
so
+ * that eventually such pages can be separately tracked and uniquely handl=
ed. In
  * particular, interactions with RDMA and filesystems need special handlin=
g.
  *
- * put_user_page() and put_page() are not interchangeable, despite this ea=
rly
- * implementation that makes them look the same. put_user_page() calls mus=
t
+ * unpin_user_page() and put_page() are not interchangeable, despite this =
early
+ * implementation that makes them look the same. unpin_user_page() calls m=
ust
  * be perfectly matched up with pin*() calls.
  */
-static inline void put_user_page(struct page *page)
+static inline void unpin_user_page(struct page *page)
 {
 	put_page(page);
 }
=20
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
-			       bool make_dirty);
+void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages=
,
+				 bool make_dirty);
=20
-void put_user_pages(struct page **pages, unsigned long npages);
+void unpin_user_pages(struct page **pages, unsigned long npages);
=20
 #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
 #define SECTION_IN_PAGE_FLAGS
@@ -2586,7 +2586,7 @@ struct page *follow_page(struct vm_area_struct *vma, =
unsigned long address,
 #define FOLL_ANON	0x8000	/* don't do file mappings */
 #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below=
 */
 #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
-#define FOLL_PIN	0x40000	/* pages must be released via put_user_page() */
+#define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
=20
 /*
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with eac=
h
@@ -2621,7 +2621,7 @@ struct page *follow_page(struct vm_area_struct *vma, =
unsigned long address,
  * Direct IO). This lets the filesystem know that some non-file-system ent=
ity is
  * potentially changing the pages' data. In contrast to FOLL_GET (whose pa=
ges
  * are released via put_page()), FOLL_PIN pages must be released, ultimate=
ly, by
- * a call to put_user_page().
+ * a call to unpin_user_page().
  *
  * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use diff=
erent
  * and separate refcounting mechanisms, however, and that means that each =
has
@@ -2629,7 +2629,7 @@ struct page *follow_page(struct vm_area_struct *vma, =
unsigned long address,
  *
  *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
  *
- *     FOLL_PIN: pin_user_pages*() to acquire, and put_user_pages to relea=
se.
+ *     FOLL_PIN: pin_user_pages*() to acquire, and unpin_user_pages to rel=
ease.
  *
  * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
  * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-b=
ased
@@ -2639,7 +2639,7 @@ struct page *follow_page(struct vm_area_struct *vma, =
unsigned long address,
  * FOLL_PIN should be set internally by the pin_user_pages*() APIs, never
  * directly by the caller. That's in order to help avoid mismatches when
  * releasing pages: get_user_pages*() pages must be released via put_page(=
),
- * while pin_user_pages*() pages must be released via put_user_page().
+ * while pin_user_pages*() pages must be released via unpin_user_page().
  *
  * Please see Documentation/vm/pin_user_pages.rst for more information.
  */
diff --git a/mm/gup.c b/mm/gup.c
index b9c15c2444ba..5fc2a3ae2e5a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -52,7 +52,7 @@ static inline struct page *try_get_compound_head(struct p=
age *page, int refs)
 }
=20
 /**
- * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned p=
ages
+ * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned=
 pages
  * @pages:  array of pages to be maybe marked dirty, and definitely releas=
ed.
  * @npages: number of pages in the @pages array.
  * @make_dirty: whether to mark the pages dirty
@@ -62,19 +62,19 @@ static inline struct page *try_get_compound_head(struct=
 page *page, int refs)
  *
  * For each page in the @pages array, make that page (or its head page, if=
 a
  * compound page) dirty, if @make_dirty is true, and if the page was previ=
ously
- * listed as clean. In any case, releases all pages using put_user_page(),
- * possibly via put_user_pages(), for the non-dirty case.
+ * listed as clean. In any case, releases all pages using unpin_user_page(=
),
+ * possibly via unpin_user_pages(), for the non-dirty case.
  *
- * Please see the put_user_page() documentation for details.
+ * Please see the unpin_user_page() documentation for details.
  *
  * set_page_dirty_lock() is used internally. If instead, set_page_dirty() =
is
  * required, then the caller should a) verify that this is really correct,
  * because _lock() is usually required, and b) hand code it:
- * set_page_dirty_lock(), put_user_page().
+ * set_page_dirty_lock(), unpin_user_page().
  *
  */
-void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
-			       bool make_dirty)
+void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages=
,
+				 bool make_dirty)
 {
 	unsigned long index;
=20
@@ -85,7 +85,7 @@ void put_user_pages_dirty_lock(struct page **pages, unsig=
ned long npages,
 	 */
=20
 	if (!make_dirty) {
-		put_user_pages(pages, npages);
+		unpin_user_pages(pages, npages);
 		return;
 	}
=20
@@ -113,21 +113,21 @@ void put_user_pages_dirty_lock(struct page **pages, u=
nsigned long npages,
 		 */
 		if (!PageDirty(page))
 			set_page_dirty_lock(page);
-		put_user_page(page);
+		unpin_user_page(page);
 	}
 }
-EXPORT_SYMBOL(put_user_pages_dirty_lock);
+EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
=20
 /**
- * put_user_pages() - release an array of gup-pinned pages.
+ * unpin_user_pages() - release an array of gup-pinned pages.
  * @pages:  array of pages to be marked dirty and released.
  * @npages: number of pages in the @pages array.
  *
- * For each page in the @pages array, release the page using put_user_page=
().
+ * For each page in the @pages array, release the page using unpin_user_pa=
ge().
  *
- * Please see the put_user_page() documentation for details.
+ * Please see the unpin_user_page() documentation for details.
  */
-void put_user_pages(struct page **pages, unsigned long npages)
+void unpin_user_pages(struct page **pages, unsigned long npages)
 {
 	unsigned long index;
=20
@@ -137,9 +137,9 @@ void put_user_pages(struct page **pages, unsigned long =
npages)
 	 * single operation to the head page should suffice.
 	 */
 	for (index =3D 0; index < npages; index++)
-		put_user_page(pages[index]);
+		unpin_user_page(pages[index]);
 }
-EXPORT_SYMBOL(put_user_pages);
+EXPORT_SYMBOL(unpin_user_pages);
=20
 #ifdef CONFIG_MMU
 static struct page *no_page_table(struct vm_area_struct *vma,
diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
index fd20ab675b85..de41e830cdac 100644
--- a/mm/process_vm_access.c
+++ b/mm/process_vm_access.c
@@ -126,8 +126,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
 		pa +=3D pinned_pages * PAGE_SIZE;
=20
 		/* If vm_write is set, the pages need to be made dirty: */
-		put_user_pages_dirty_lock(process_pages, pinned_pages,
-					  vm_write);
+		unpin_user_pages_dirty_lock(process_pages, pinned_pages,
+					    vm_write);
 	}
=20
 	return rc;
diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index d071003b5e76..ac182c38f7b0 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -212,7 +212,7 @@ static int xdp_umem_map_pages(struct xdp_umem *umem)
=20
 static void xdp_umem_unpin_pages(struct xdp_umem *umem)
 {
-	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
+	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
=20
 	kfree(umem->pgs);
 	umem->pgs =3D NULL;
--=20
2.24.0

