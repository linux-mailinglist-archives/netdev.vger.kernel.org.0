Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7627E10236A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbfKSLjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:39:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:36444 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726000AbfKSLjm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 06:39:42 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 409C3BC7F;
        Tue, 19 Nov 2019 11:39:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 8B7B61E47E5; Tue, 19 Nov 2019 12:39:35 +0100 (CET)
Date:   Tue, 19 Nov 2019 12:39:35 +0100
From:   Jan Kara <jack@suse.cz>
To:     John Hubbard <jhubbard@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Dave Chinner <david@fromorbit.com>,
        David Airlie <airlied@linux.ie>,
        "David S . Miller" <davem@davemloft.net>,
        Ira Weiny <ira.weiny@intel.com>, Jan Kara <jack@suse.cz>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jonathan Corbet <corbet@lwn.net>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Shuah Khan <shuah@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, kvm@vger.kernel.org,
        linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-rdma@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 24/24] mm, tree-wide: rename put_user_page*() to
 unpin_user_page*()
Message-ID: <20191119113935.GE25605@quack2.suse.cz>
References: <20191119081643.1866232-1-jhubbard@nvidia.com>
 <20191119081643.1866232-25-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119081643.1866232-25-jhubbard@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue 19-11-19 00:16:43, John Hubbard wrote:
> In order to provide a clearer, more symmetric API for pinning
> and unpinning DMA pages. This way, pin_user_pages*() calls
> match up with unpin_user_pages*() calls, and the API is a lot
> closer to being self-explanatory.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> ---
>  Documentation/core-api/pin_user_pages.rst   |  2 +-
>  arch/powerpc/mm/book3s64/iommu_api.c        |  6 +--
>  drivers/gpu/drm/via/via_dmablit.c           |  4 +-
>  drivers/infiniband/core/umem.c              |  2 +-
>  drivers/infiniband/hw/hfi1/user_pages.c     |  2 +-
>  drivers/infiniband/hw/mthca/mthca_memfree.c |  6 +--
>  drivers/infiniband/hw/qib/qib_user_pages.c  |  2 +-
>  drivers/infiniband/hw/qib/qib_user_sdma.c   |  6 +--
>  drivers/infiniband/hw/usnic/usnic_uiom.c    |  2 +-
>  drivers/infiniband/sw/siw/siw_mem.c         |  2 +-
>  drivers/media/v4l2-core/videobuf-dma-sg.c   |  4 +-
>  drivers/platform/goldfish/goldfish_pipe.c   |  4 +-
>  drivers/vfio/vfio_iommu_type1.c             |  2 +-
>  fs/io_uring.c                               |  4 +-
>  include/linux/mm.h                          | 30 +++++++-------
>  include/linux/mmzone.h                      |  2 +-
>  mm/gup.c                                    | 46 ++++++++++-----------
>  mm/gup_benchmark.c                          |  2 +-
>  mm/process_vm_access.c                      |  4 +-
>  net/xdp/xdp_umem.c                          |  2 +-
>  20 files changed, 67 insertions(+), 67 deletions(-)
> 
> diff --git a/Documentation/core-api/pin_user_pages.rst b/Documentation/core-api/pin_user_pages.rst
> index baa288a44a77..6d93ef203561 100644
> --- a/Documentation/core-api/pin_user_pages.rst
> +++ b/Documentation/core-api/pin_user_pages.rst
> @@ -220,7 +220,7 @@ since the system was booted, via two new /proc/vmstat entries: ::
>      /proc/vmstat/nr_foll_pin_requested
>  
>  Those are both going to show zero, unless CONFIG_DEBUG_VM is set. This is
> -because there is a noticeable performance drop in put_user_page(), when they
> +because there is a noticeable performance drop in unpin_user_page(), when they
>  are activated.
>  
>  References
> diff --git a/arch/powerpc/mm/book3s64/iommu_api.c b/arch/powerpc/mm/book3s64/iommu_api.c
> index 196383e8e5a9..dd7aa5a4f33c 100644
> --- a/arch/powerpc/mm/book3s64/iommu_api.c
> +++ b/arch/powerpc/mm/book3s64/iommu_api.c
> @@ -168,7 +168,7 @@ static long mm_iommu_do_alloc(struct mm_struct *mm, unsigned long ua,
>  
>  free_exit:
>  	/* free the references taken */
> -	put_user_pages(mem->hpages, pinned);
> +	unpin_user_pages(mem->hpages, pinned);
>  
>  	vfree(mem->hpas);
>  	kfree(mem);
> @@ -211,8 +211,8 @@ static void mm_iommu_unpin(struct mm_iommu_table_group_mem_t *mem)
>  		if (!page)
>  			continue;
>  
> -		put_user_pages_dirty_lock(&mem->hpages[i], 1,
> -					  MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);
> +		unpin_user_pages_dirty_lock(&mem->hpages[i], 1,
> +					    MM_IOMMU_TABLE_GROUP_PAGE_DIRTY);
>  
>  		mem->hpas[i] = 0;
>  	}
> diff --git a/drivers/gpu/drm/via/via_dmablit.c b/drivers/gpu/drm/via/via_dmablit.c
> index 37c5e572993a..719d036c9384 100644
> --- a/drivers/gpu/drm/via/via_dmablit.c
> +++ b/drivers/gpu/drm/via/via_dmablit.c
> @@ -188,8 +188,8 @@ via_free_sg_info(struct pci_dev *pdev, drm_via_sg_info_t *vsg)
>  		kfree(vsg->desc_pages);
>  		/* fall through */
>  	case dr_via_pages_locked:
> -		put_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
> -					  (vsg->direction == DMA_FROM_DEVICE));
> +		unpin_user_pages_dirty_lock(vsg->pages, vsg->num_pages,
> +					   (vsg->direction == DMA_FROM_DEVICE));
>  		/* fall through */
>  	case dr_via_pages_alloc:
>  		vfree(vsg->pages);
> diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
> index 2c287ced3439..119a147da904 100644
> --- a/drivers/infiniband/core/umem.c
> +++ b/drivers/infiniband/core/umem.c
> @@ -54,7 +54,7 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
>  
>  	for_each_sg_page(umem->sg_head.sgl, &sg_iter, umem->sg_nents, 0) {
>  		page = sg_page_iter_page(&sg_iter);
> -		put_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
> +		unpin_user_pages_dirty_lock(&page, 1, umem->writable && dirty);
>  	}
>  
>  	sg_free_table(&umem->sg_head);
> diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
> index 9a94761765c0..3b505006c0a6 100644
> --- a/drivers/infiniband/hw/hfi1/user_pages.c
> +++ b/drivers/infiniband/hw/hfi1/user_pages.c
> @@ -118,7 +118,7 @@ int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t np
>  void hfi1_release_user_pages(struct mm_struct *mm, struct page **p,
>  			     size_t npages, bool dirty)
>  {
> -	put_user_pages_dirty_lock(p, npages, dirty);
> +	unpin_user_pages_dirty_lock(p, npages, dirty);
>  
>  	if (mm) { /* during close after signal, mm can be NULL */
>  		atomic64_sub(npages, &mm->pinned_vm);
> diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
> index 8269ab040c21..78a48aea3faf 100644
> --- a/drivers/infiniband/hw/mthca/mthca_memfree.c
> +++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
> @@ -482,7 +482,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
>  
>  	ret = pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
>  	if (ret < 0) {
> -		put_user_page(pages[0]);
> +		unpin_user_page(pages[0]);
>  		goto out;
>  	}
>  
> @@ -490,7 +490,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
>  				 mthca_uarc_virt(dev, uar, i));
>  	if (ret) {
>  		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
> -		put_user_page(sg_page(&db_tab->page[i].mem));
> +		unpin_user_page(sg_page(&db_tab->page[i].mem));
>  		goto out;
>  	}
>  
> @@ -556,7 +556,7 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, struct mthca_uar *uar,
>  		if (db_tab->page[i].uvirt) {
>  			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1);
>  			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
> -			put_user_page(sg_page(&db_tab->page[i].mem));
> +			unpin_user_page(sg_page(&db_tab->page[i].mem));
>  		}
>  	}
>  
> diff --git a/drivers/infiniband/hw/qib/qib_user_pages.c b/drivers/infiniband/hw/qib/qib_user_pages.c
> index 7fc4b5f81fcd..342e3172ca40 100644
> --- a/drivers/infiniband/hw/qib/qib_user_pages.c
> +++ b/drivers/infiniband/hw/qib/qib_user_pages.c
> @@ -40,7 +40,7 @@
>  static void __qib_release_user_pages(struct page **p, size_t num_pages,
>  				     int dirty)
>  {
> -	put_user_pages_dirty_lock(p, num_pages, dirty);
> +	unpin_user_pages_dirty_lock(p, num_pages, dirty);
>  }
>  
>  /**
> diff --git a/drivers/infiniband/hw/qib/qib_user_sdma.c b/drivers/infiniband/hw/qib/qib_user_sdma.c
> index 1a3cc2957e3a..a67599b5a550 100644
> --- a/drivers/infiniband/hw/qib/qib_user_sdma.c
> +++ b/drivers/infiniband/hw/qib/qib_user_sdma.c
> @@ -317,7 +317,7 @@ static int qib_user_sdma_page_to_frags(const struct qib_devdata *dd,
>  		 * the caller can ignore this page.
>  		 */
>  		if (put) {
> -			put_user_page(page);
> +			unpin_user_page(page);
>  		} else {
>  			/* coalesce case */
>  			kunmap(page);
> @@ -631,7 +631,7 @@ static void qib_user_sdma_free_pkt_frag(struct device *dev,
>  			kunmap(pkt->addr[i].page);
>  
>  		if (pkt->addr[i].put_page)
> -			put_user_page(pkt->addr[i].page);
> +			unpin_user_page(pkt->addr[i].page);
>  		else
>  			__free_page(pkt->addr[i].page);
>  	} else if (pkt->addr[i].kvaddr) {
> @@ -706,7 +706,7 @@ static int qib_user_sdma_pin_pages(const struct qib_devdata *dd,
>  	/* if error, return all pages not managed by pkt */
>  free_pages:
>  	while (i < j)
> -		put_user_page(pages[i++]);
> +		unpin_user_page(pages[i++]);
>  
>  done:
>  	return ret;
> diff --git a/drivers/infiniband/hw/usnic/usnic_uiom.c b/drivers/infiniband/hw/usnic/usnic_uiom.c
> index 600896727d34..bd9f944b68fc 100644
> --- a/drivers/infiniband/hw/usnic/usnic_uiom.c
> +++ b/drivers/infiniband/hw/usnic/usnic_uiom.c
> @@ -75,7 +75,7 @@ static void usnic_uiom_put_pages(struct list_head *chunk_list, int dirty)
>  		for_each_sg(chunk->page_list, sg, chunk->nents, i) {
>  			page = sg_page(sg);
>  			pa = sg_phys(sg);
> -			put_user_pages_dirty_lock(&page, 1, dirty);
> +			unpin_user_pages_dirty_lock(&page, 1, dirty);
>  			usnic_dbg("pa: %pa\n", &pa);
>  		}
>  		kfree(chunk);
> diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
> index e53b07dcfed5..e2061dc0b043 100644
> --- a/drivers/infiniband/sw/siw/siw_mem.c
> +++ b/drivers/infiniband/sw/siw/siw_mem.c
> @@ -63,7 +63,7 @@ struct siw_mem *siw_mem_id2obj(struct siw_device *sdev, int stag_index)
>  static void siw_free_plist(struct siw_page_chunk *chunk, int num_pages,
>  			   bool dirty)
>  {
> -	put_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
> +	unpin_user_pages_dirty_lock(chunk->plist, num_pages, dirty);
>  }
>  
>  void siw_umem_release(struct siw_umem *umem, bool dirty)
> diff --git a/drivers/media/v4l2-core/videobuf-dma-sg.c b/drivers/media/v4l2-core/videobuf-dma-sg.c
> index 162a2633b1e3..13b65ed9e74c 100644
> --- a/drivers/media/v4l2-core/videobuf-dma-sg.c
> +++ b/drivers/media/v4l2-core/videobuf-dma-sg.c
> @@ -349,8 +349,8 @@ int videobuf_dma_free(struct videobuf_dmabuf *dma)
>  	BUG_ON(dma->sglen);
>  
>  	if (dma->pages) {
> -		put_user_pages_dirty_lock(dma->pages, dma->nr_pages,
> -					  dma->direction == DMA_FROM_DEVICE);
> +		unpin_user_pages_dirty_lock(dma->pages, dma->nr_pages,
> +					    dma->direction == DMA_FROM_DEVICE);
>  		kfree(dma->pages);
>  		dma->pages = NULL;
>  	}
> diff --git a/drivers/platform/goldfish/goldfish_pipe.c b/drivers/platform/goldfish/goldfish_pipe.c
> index 635a8bc1b480..bf523df2a90d 100644
> --- a/drivers/platform/goldfish/goldfish_pipe.c
> +++ b/drivers/platform/goldfish/goldfish_pipe.c
> @@ -360,8 +360,8 @@ static int transfer_max_buffers(struct goldfish_pipe *pipe,
>  
>  	*consumed_size = pipe->command_buffer->rw_params.consumed_size;
>  
> -	put_user_pages_dirty_lock(pipe->pages, pages_count,
> -				  !is_write && *consumed_size > 0);
> +	unpin_user_pages_dirty_lock(pipe->pages, pages_count,
> +				    !is_write && *consumed_size > 0);
>  
>  	mutex_unlock(&pipe->lock);
>  	return 0;
> diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
> index 18aa36b56896..c48ac1567f14 100644
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -328,7 +328,7 @@ static int put_pfn(unsigned long pfn, int prot)
>  	if (!is_invalid_reserved_pfn(pfn)) {
>  		struct page *page = pfn_to_page(pfn);
>  
> -		put_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
> +		unpin_user_pages_dirty_lock(&page, 1, prot & IOMMU_WRITE);
>  		return 1;
>  	}
>  	return 0;
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 15715eeebaec..0253a4d8fdc8 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -3328,7 +3328,7 @@ static int io_sqe_buffer_unregister(struct io_ring_ctx *ctx)
>  		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
>  
>  		for (j = 0; j < imu->nr_bvecs; j++)
> -			put_user_page(imu->bvec[j].bv_page);
> +			unpin_user_page(imu->bvec[j].bv_page);
>  
>  		if (ctx->account_mem)
>  			io_unaccount_mem(ctx->user, imu->nr_bvecs);
> @@ -3473,7 +3473,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, void __user *arg,
>  			 * release any pages we did get
>  			 */
>  			if (pret > 0)
> -				put_user_pages(pages, pret);
> +				unpin_user_pages(pages, pret);
>  			if (ctx->account_mem)
>  				io_unaccount_mem(ctx->user, nr_pages);
>  			kvfree(imu->bvec);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ab311b356ab1..775f6a3d615b 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1093,18 +1093,18 @@ static inline void put_page(struct page *page)
>   * made against the page. ("gup-pinned" is another term for the latter).
>   *
>   * With this scheme, pin_user_pages() becomes special: such pages are marked as
> - * distinct from normal pages. As such, the put_user_page() call (and its
> + * distinct from normal pages. As such, the unpin_user_page() call (and its
>   * variants) must be used in order to release gup-pinned pages.
>   *
>   * Choice of value:
>   *
>   * By making GUP_PIN_COUNTING_BIAS a power of two, debugging of page reference
> - * counts with respect to pin_user_pages() and put_user_page() becomes simpler,
> - * due to the fact that adding an even power of two to the page refcount has the
> - * effect of using only the upper N bits, for the code that counts up using the
> - * bias value. This means that the lower bits are left for the exclusive use of
> - * the original code that increments and decrements by one (or at least, by much
> - * smaller values than the bias value).
> + * counts with respect to pin_user_pages() and unpin_user_page() becomes
> + * simpler, due to the fact that adding an even power of two to the page
> + * refcount has the effect of using only the upper N bits, for the code that
> + * counts up using the bias value. This means that the lower bits are left for
> + * the exclusive use of the original code that increments and decrements by one
> + * (or at least, by much smaller values than the bias value).
>   *
>   * Of course, once the lower bits overflow into the upper bits (and this is
>   * OK, because subtraction recovers the original values), then visual inspection
> @@ -1119,10 +1119,10 @@ static inline void put_page(struct page *page)
>   */
>  #define GUP_PIN_COUNTING_BIAS (1UL << 10)
>  
> -void put_user_page(struct page *page);
> -void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> -			       bool make_dirty);
> -void put_user_pages(struct page **pages, unsigned long npages);
> +void unpin_user_page(struct page *page);
> +void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> +				 bool make_dirty);
> +void unpin_user_pages(struct page **pages, unsigned long npages);
>  
>  /**
>   * page_dma_pinned() - report if a page is pinned for DMA.
> @@ -2673,7 +2673,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>  #define FOLL_ANON	0x8000	/* don't do file mappings */
>  #define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
>  #define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
> -#define FOLL_PIN	0x40000	/* pages must be released via put_user_page() */
> +#define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
>  
>  /*
>   * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
> @@ -2708,7 +2708,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   * Direct IO). This lets the filesystem know that some non-file-system entity is
>   * potentially changing the pages' data. In contrast to FOLL_GET (whose pages
>   * are released via put_page()), FOLL_PIN pages must be released, ultimately, by
> - * a call to put_user_page().
> + * a call to unpin_user_page().
>   *
>   * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use different
>   * and separate refcounting mechanisms, however, and that means that each has
> @@ -2716,7 +2716,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   *
>   *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
>   *
> - *     FOLL_PIN: pin_user_pages*() to acquire, and put_user_pages to release.
> + *     FOLL_PIN: pin_user_pages*() to acquire, and unpin_user_pages to release.
>   *
>   * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
>   * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-based
> @@ -2726,7 +2726,7 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
>   * FOLL_PIN should be set internally by the pin_user_pages*() APIs, never
>   * directly by the caller. That's in order to help avoid mismatches when
>   * releasing pages: get_user_pages*() pages must be released via put_page(),
> - * while pin_user_pages*() pages must be released via put_user_page().
> + * while pin_user_pages*() pages must be released via unpin_user_page().
>   *
>   * Please see Documentation/vm/pin_user_pages.rst for more information.
>   */
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 0485cba38d23..d66c1fb9d45e 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -245,7 +245,7 @@ enum node_stat_item {
>  	NR_WRITTEN,		/* page writings since bootup */
>  	NR_KERNEL_MISC_RECLAIMABLE,	/* reclaimable non-slab kernel pages */
>  	NR_FOLL_PIN_REQUESTED,	/* via: pin_user_page(), gup flag: FOLL_PIN */
> -	NR_FOLL_PIN_RETURNED,	/* pages returned via put_user_page() */
> +	NR_FOLL_PIN_RETURNED,	/* pages returned via unpin_user_page() */
>  	NR_VM_NODE_STAT_ITEMS
>  };
>  
> diff --git a/mm/gup.c b/mm/gup.c
> index 002816526670..cebaf2d02f59 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -113,15 +113,15 @@ static bool __put_devmap_managed_user_page(struct page *page)
>  #endif /* CONFIG_DEV_PAGEMAP_OPS */
>  
>  /**
> - * put_user_page() - release a dma-pinned page
> + * unpin_user_page() - release a dma-pinned page
>   * @page:            pointer to page to be released
>   *
>   * Pages that were pinned via pin_user_pages*() must be released via either
> - * put_user_page(), or one of the put_user_pages*() routines. This is so that
> - * such pages can be separately tracked and uniquely handled. In particular,
> - * interactions with RDMA and filesystems need special handling.
> + * unpin_user_page(), or one of the unpin_user_pages*() routines. This is so
> + * that such pages can be separately tracked and uniquely handled. In
> + * particular, interactions with RDMA and filesystems need special handling.
>   */
> -void put_user_page(struct page *page)
> +void unpin_user_page(struct page *page)
>  {
>  	page = compound_head(page);
>  
> @@ -139,10 +139,10 @@ void put_user_page(struct page *page)
>  
>  	__update_proc_vmstat(page, NR_FOLL_PIN_RETURNED, 1);
>  }
> -EXPORT_SYMBOL(put_user_page);
> +EXPORT_SYMBOL(unpin_user_page);
>  
>  /**
> - * put_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
> + * unpin_user_pages_dirty_lock() - release and optionally dirty gup-pinned pages
>   * @pages:  array of pages to be maybe marked dirty, and definitely released.
>   * @npages: number of pages in the @pages array.
>   * @make_dirty: whether to mark the pages dirty
> @@ -152,19 +152,19 @@ EXPORT_SYMBOL(put_user_page);
>   *
>   * For each page in the @pages array, make that page (or its head page, if a
>   * compound page) dirty, if @make_dirty is true, and if the page was previously
> - * listed as clean. In any case, releases all pages using put_user_page(),
> - * possibly via put_user_pages(), for the non-dirty case.
> + * listed as clean. In any case, releases all pages using unpin_user_page(),
> + * possibly via unpin_user_pages(), for the non-dirty case.
>   *
> - * Please see the put_user_page() documentation for details.
> + * Please see the unpin_user_page() documentation for details.
>   *
>   * set_page_dirty_lock() is used internally. If instead, set_page_dirty() is
>   * required, then the caller should a) verify that this is really correct,
>   * because _lock() is usually required, and b) hand code it:
> - * set_page_dirty_lock(), put_user_page().
> + * set_page_dirty_lock(), unpin_user_page().
>   *
>   */
> -void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> -			       bool make_dirty)
> +void unpin_user_pages_dirty_lock(struct page **pages, unsigned long npages,
> +				 bool make_dirty)
>  {
>  	unsigned long index;
>  
> @@ -175,7 +175,7 @@ void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
>  	 */
>  
>  	if (!make_dirty) {
> -		put_user_pages(pages, npages);
> +		unpin_user_pages(pages, npages);
>  		return;
>  	}
>  
> @@ -203,21 +203,21 @@ void put_user_pages_dirty_lock(struct page **pages, unsigned long npages,
>  		 */
>  		if (!PageDirty(page))
>  			set_page_dirty_lock(page);
> -		put_user_page(page);
> +		unpin_user_page(page);
>  	}
>  }
> -EXPORT_SYMBOL(put_user_pages_dirty_lock);
> +EXPORT_SYMBOL(unpin_user_pages_dirty_lock);
>  
>  /**
> - * put_user_pages() - release an array of gup-pinned pages.
> + * unpin_user_pages() - release an array of gup-pinned pages.
>   * @pages:  array of pages to be marked dirty and released.
>   * @npages: number of pages in the @pages array.
>   *
> - * For each page in the @pages array, release the page using put_user_page().
> + * For each page in the @pages array, release the page using unpin_user_page().
>   *
> - * Please see the put_user_page() documentation for details.
> + * Please see the unpin_user_page() documentation for details.
>   */
> -void put_user_pages(struct page **pages, unsigned long npages)
> +void unpin_user_pages(struct page **pages, unsigned long npages)
>  {
>  	unsigned long index;
>  
> @@ -227,9 +227,9 @@ void put_user_pages(struct page **pages, unsigned long npages)
>  	 * single operation to the head page should suffice.
>  	 */
>  	for (index = 0; index < npages; index++)
> -		put_user_page(pages[index]);
> +		unpin_user_page(pages[index]);
>  }
> -EXPORT_SYMBOL(put_user_pages);
> +EXPORT_SYMBOL(unpin_user_pages);
>  
>  #ifdef CONFIG_MMU
>  static struct page *no_page_table(struct vm_area_struct *vma,
> @@ -1956,7 +1956,7 @@ static void __maybe_unused undo_dev_pagemap(int *nr, int nr_start,
>  
>  		ClearPageReferenced(page);
>  		if (flags & FOLL_PIN)
> -			put_user_page(page);
> +			unpin_user_page(page);
>  		else
>  			put_page(page);
>  	}
> diff --git a/mm/gup_benchmark.c b/mm/gup_benchmark.c
> index 1ac089ad815f..76d32db48af8 100644
> --- a/mm/gup_benchmark.c
> +++ b/mm/gup_benchmark.c
> @@ -35,7 +35,7 @@ static void put_back_pages(int cmd, struct page **pages, unsigned long nr_pages)
>  
>  	case PIN_FAST_BENCHMARK:
>  	case PIN_BENCHMARK:
> -		put_user_pages(pages, nr_pages);
> +		unpin_user_pages(pages, nr_pages);
>  		break;
>  	}
>  }
> diff --git a/mm/process_vm_access.c b/mm/process_vm_access.c
> index fd20ab675b85..de41e830cdac 100644
> --- a/mm/process_vm_access.c
> +++ b/mm/process_vm_access.c
> @@ -126,8 +126,8 @@ static int process_vm_rw_single_vec(unsigned long addr,
>  		pa += pinned_pages * PAGE_SIZE;
>  
>  		/* If vm_write is set, the pages need to be made dirty: */
> -		put_user_pages_dirty_lock(process_pages, pinned_pages,
> -					  vm_write);
> +		unpin_user_pages_dirty_lock(process_pages, pinned_pages,
> +					    vm_write);
>  	}
>  
>  	return rc;
> diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
> index d071003b5e76..ac182c38f7b0 100644
> --- a/net/xdp/xdp_umem.c
> +++ b/net/xdp/xdp_umem.c
> @@ -212,7 +212,7 @@ static int xdp_umem_map_pages(struct xdp_umem *umem)
>  
>  static void xdp_umem_unpin_pages(struct xdp_umem *umem)
>  {
> -	put_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
> +	unpin_user_pages_dirty_lock(umem->pgs, umem->npgs, true);
>  
>  	kfree(umem->pgs);
>  	umem->pgs = NULL;
> -- 
> 2.24.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
