Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6AC5A1980
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242957AbiHYT1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 15:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbiHYT1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 15:27:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1465ABD4E2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661455627;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9X2BznXSiA0UabpKw3Fr8z8GjTtImVcFyhraItrfq9g=;
        b=WEpQBR3LjE9Lgb6+YCttMmkaZN0euOKgiTID8GLQbEZYbkn/WHmHzXsl1VWnXd3iCbvVTC
        on9DYbrzl7xmif4nSrWA29kLDZ3vIiboiihpde/EQBXsjlKpudi5URobCEAvgXCldCZPIV
        MXxRFBcFHB2P2kFHxm640oL7bdNTsHM=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-658-LH5ymcQ6OnG2VXyJN_wHfA-1; Thu, 25 Aug 2022 15:27:05 -0400
X-MC-Unique: LH5ymcQ6OnG2VXyJN_wHfA-1
Received: by mail-il1-f199.google.com with SMTP id i13-20020a056e02152d00b002e97839ff00so11239668ilu.15
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 12:27:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=9X2BznXSiA0UabpKw3Fr8z8GjTtImVcFyhraItrfq9g=;
        b=wVOkhvx7SFsk5qyS+9Acg8uT7BbWpK8lxcRzWhFNV16GHPErVIpy1ZnhLN+iTavuTj
         b0HLkWQoaKEqsZAsjCv0gd97JZIPpYgXATuIUZOL6XJbrH+erQ1i3J34f9N0kJmTIF0q
         5sVvv+Ffokl/hOM3l1L7VlzKXreUCQOBzUgliB/vLJwsk4wwecmXT8f5XjVZpnVQXSPi
         n0KOtYmvjqtzB1q/XgP/OXiJgi86BuHBc+HSA4dljTs64E9Qd9byuCz63KAmqW7f23x1
         hdAMelKrLoS5r1l8G9PfcsdZe9x6ca867SPUfe8R21bh9mb47Dn0O6M0ENMZmQyjsVds
         kGeg==
X-Gm-Message-State: ACgBeo27KNjQG5yDLDXNXPDMfAm4MXe+Prpzhm0SLwG3RN4XZDU1Ph50
        r47HFCVbYv6mHgCafI3h8JmErNpTaO/BnZldsI/eZtuzjuEPwSAaBCGqLfcIgpF+Ynnj6epeGRh
        2LNit7eFliUjtJWsP
X-Received: by 2002:a05:6638:3a16:b0:349:d8cc:2d22 with SMTP id cn22-20020a0566383a1600b00349d8cc2d22mr2564930jab.224.1661455624786;
        Thu, 25 Aug 2022 12:27:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Ln9EnikQJHQyAHhSfnnFHcCYOKWLd7LZeMNOMrow8BsU8sPLtvrmfmlTAqYIOAp9Zk7DnjQ==
X-Received: by 2002:a05:6638:3a16:b0:349:d8cc:2d22 with SMTP id cn22-20020a0566383a1600b00349d8cc2d22mr2564914jab.224.1661455624408;
        Thu, 25 Aug 2022 12:27:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id z12-20020a02938c000000b0033f043929fbsm74367jah.107.2022.08.25.12.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 12:27:04 -0700 (PDT)
Date:   Thu, 25 Aug 2022 13:27:01 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>
Cc:     <jgg@nvidia.com>, <saeedm@nvidia.com>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>,
        <kevin.tian@intel.com>, <joao.m.martins@oracle.com>,
        <leonro@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <20220825132701.07f9a1c3.alex.williamson@redhat.com>
In-Reply-To: <20220815151109.180403-5-yishaih@nvidia.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-5-yishaih@nvidia.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Aug 2022 18:11:03 +0300
Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Joao Martins <joao.m.martins@oracle.com>
> 
> The new facility adds a bunch of wrappers that abstract how an IOVA
> range is represented in a bitmap that is granulated by a given
> page_size. So it translates all the lifting of dealing with user
> pointers into its corresponding kernel addresses backing said user
> memory into doing finally the (non-atomic) bitmap ops to change
> various bits.
> 
> The formula for the bitmap is:
> 
>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> 
> Where 64 is the number of bits in a unsigned long (depending on arch)
> 
> It introduces an IOVA iterator that uses a windowing scheme to minimize
> the pinning overhead, as opposed to be pinning it on demand 4K at a

s/ be / /

> time. So on a 512G and with base page size it would iterate in ranges of
> 64G at a time, while pinning 512 pages at a time leading to fewer

"on a 512G" what?  The overall size of the IOVA range is somewhat
irrelevant here and it's unclear where 64G comes from without reading
deeper into the series.  Maybe this should be something like:

"Assuming a 4K kernel page and 4K requested page size, we can use a
single kernel page to hold 512 page pointers, mapping 2M of bitmap,
representing 64G of IOVA space."

> atomics (specially if the underlying user memory are hugepages).
> 
> An example usage of these helpers for a given @base_iova, @page_size, @length

Several long lines here that could be wrapped.

> and __user @data:
> 
> 	ret = iova_bitmap_iter_init(&iter, base_iova, page_size, length, data);
> 	if (ret)
> 		return -ENOMEM;
> 
> 	for (; !iova_bitmap_iter_done(&iter) && !ret;
> 	     ret = iova_bitmap_iter_advance(&iter)) {
> 		dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
> 				   iova_bitmap_length(&iter));
> 	}
> 
> 	iova_bitmap_iter_free(&iter);
> 
> An implementation of the lower end -- referred to above as dirty_reporter_ops
> to exemplify -- that is tracking dirty bits would mark an IOVA as dirty
> as following:
> 
> 	iova_bitmap_set(&iter.dirty, iova, page_size);
> 
> or a contiguous range (example two pages):
> 
> 	iova_bitmap_set(&iter.dirty, iova, 2 * page_size);
> 
> The facility is intended to be used for user bitmaps representing
> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
> 
> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/Makefile       |   6 +-
>  drivers/vfio/iova_bitmap.c  | 224 ++++++++++++++++++++++++++++++++++++
>  include/linux/iova_bitmap.h | 189 ++++++++++++++++++++++++++++++
>  3 files changed, 417 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/vfio/iova_bitmap.c
>  create mode 100644 include/linux/iova_bitmap.h
> 
> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> index 1a32357592e3..1d6cad32d366 100644
> --- a/drivers/vfio/Makefile
> +++ b/drivers/vfio/Makefile
> @@ -1,9 +1,11 @@
>  # SPDX-License-Identifier: GPL-2.0
>  vfio_virqfd-y := virqfd.o
>  
> -vfio-y += vfio_main.o
> -
>  obj-$(CONFIG_VFIO) += vfio.o
> +
> +vfio-y := vfio_main.o \
> +          iova_bitmap.o \
> +
>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> new file mode 100644
> index 000000000000..6b6008ef146c
> --- /dev/null
> +++ b/drivers/vfio/iova_bitmap.c
> @@ -0,0 +1,224 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +#include <linux/iova_bitmap.h>
> +#include <linux/highmem.h>
> +
> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
> +
> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
> +
> +/*
> + * Converts a relative IOVA to a bitmap index.
> + * The bitmap is viewed an array of u64, and each u64 represents

"The bitmap is viewed as an u64 array and each u64 represents"

> + * a range of IOVA, and the whole pinned pages to the range window.

I think this phrase after the comma is trying to say something about the
windowed mapping, but I don't know what.

This function provides the index into that u64 array for a given IOVA
offset.

> + * Relative IOVA means relative to the iter::dirty base IOVA (stored
> + * in dirty::iova). All computations in this file are done using
> + * relative IOVAs and thus avoid an extra subtraction against
> + * dirty::iova. The user API iova_bitmap_set() always uses a regular
> + * absolute IOVAs.

So why don't we use variables that make it clear when an IOVA is an
IOVA and when it's an offset?

> + */
> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
> +					       unsigned long iova)

iova_bitmap_offset_to_index(... unsigned long offset)?

> +{
> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
> +
> +	return iova / (BITS_PER_TYPE(*iter->data) * pgsize);

Why do we name the bitmap "data" rather than "bitmap"?

Why do we call the mapped section "dirty" rather than "mapped"?  It's
not necessarily dirty, it's just the window that's current mapped.

> +}
> +
> +/*
> + * Converts a bitmap index to a *relative* IOVA.
> + */
> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
> +					       unsigned long index)

iova_bitmap_index_to_offset()?

> +{
> +	unsigned long pgshift = iter->dirty.pgshift;
> +
> +	return (index * BITS_PER_TYPE(*iter->data)) << pgshift;
> +}
> +
> +/*
> + * Pins the bitmap user pages for the current range window.
> + * This is internal to IOVA bitmap and called when advancing the
> + * iterator.
> + */
> +static int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +	unsigned long npages;
> +	u64 __user *addr;
> +	long ret;
> +
> +	/*
> +	 * @offset is the cursor of the currently mapped u64 words

So it's an index?  I don't know what a cursor is.  If we start using
"offset" to describe a relative iova, maybe this becomes something more
descriptive, mapped_base_index?

> +	 * that we have access. And it indexes u64 bitmap word that is
> +	 * mapped. Anything before @offset is not mapped. The range
> +	 * @offset .. @count is mapped but capped at a maximum number
> +	 * of pages.

@total_indexes rather than @count maybe?

> +	 */
> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
> +			      sizeof(*iter->data), PAGE_SIZE);
> +
> +	/*
> +	 * We always cap at max number of 'struct page' a base page can fit.
> +	 * This is, for example, on x86 means 2M of bitmap data max.
> +	 */
> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
> +	addr = iter->data + iter->offset;

Subtle pointer arithmetic.

> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
> +				  FOLL_WRITE, dirty->pages);
> +	if (ret <= 0)
> +		return -EFAULT;
> +
> +	dirty->npages = (unsigned long)ret;
> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
> +	dirty->iova = iova_bitmap_iova(iter);

If we're operating on an iterator, wouldn't convention suggest this is
an iova_bitmap_itr_FOO function?  mapped_iova perhaps.

> +
> +	/*
> +	 * offset of the page where pinned pages bit 0 is located.
> +	 * This handles the case where the bitmap is not PAGE_SIZE
> +	 * aligned.
> +	 */
> +	dirty->start_offset = offset_in_page(addr);

Maybe pgoff to avoid confusion with relative iova offsets.

It seems suspect that the length calculations don't take this into
account.

> +	return 0;
> +}
> +
> +/*
> + * Unpins the bitmap user pages and clears @npages
> + * (un)pinning is abstracted from API user and it's done
> + * when advancing or freeing the iterator.
> + */
> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	if (dirty->npages) {
> +		unpin_user_pages(dirty->pages, dirty->npages);
> +		dirty->npages = 0;
> +	}
> +}
> +
> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
> +			  unsigned long iova, unsigned long length,
> +			  unsigned long page_size, u64 __user *data)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	memset(iter, 0, sizeof(*iter));
> +	dirty->pgshift = __ffs(page_size);
> +	iter->data = data;
> +	iter->count = iova_bitmap_iova_to_index(iter, length - 1) + 1;
> +	iter->iova = iova;
> +	iter->length = length;
> +
> +	dirty->iova = iova;
> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
> +	if (!dirty->pages)
> +		return -ENOMEM;
> +
> +	return iova_bitmap_iter_get(iter);
> +}
> +
> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
> +{
> +	struct iova_bitmap *dirty = &iter->dirty;
> +
> +	iova_bitmap_iter_put(iter);
> +
> +	if (dirty->pages) {
> +		free_page((unsigned long)dirty->pages);
> +		dirty->pages = NULL;
> +	}
> +
> +	memset(iter, 0, sizeof(*iter));
> +}
> +
> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long skip = iter->offset;
> +
> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
> +}
> +
> +/*
> + * Returns the remaining bitmap indexes count to process for the currently pinned
> + * bitmap pages.
> + */
> +static unsigned long iova_bitmap_iter_remaining(struct iova_bitmap_iter *iter)

iova_bitmap_iter_mapped_remaining()?

> +{
> +	unsigned long remaining = iter->count - iter->offset;
> +
> +	remaining = min_t(unsigned long, remaining,
> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
> +
> +	return remaining;
> +}
> +
> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)

iova_bitmap_iter_mapped_length()?

Maybe it doesn't really make sense to differentiate the iterator from
the bitmap in the API.  In fact, couldn't we reduce the API to simply:

int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
		     size_t length, size_t page_size, u64 __user *data);

int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
			 int (*fn)(void *data, dma_addr_t iova,
			 	   size_t length,
				   struct iova_bitmap *bitmap));

void iova_bitmap_free(struct iova_bitmap *bitmap);

unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
			      dma_addr_t iova, size_t length);

Removes the need for the API to have done, advance, iova, and length
functions.

> +{
> +	unsigned long max_iova = iter->iova + iter->length - 1;
> +	unsigned long iova = iova_bitmap_iova(iter);
> +	unsigned long remaining;
> +
> +	/*
> +	 * iova_bitmap_iter_remaining() returns a number of indexes which
> +	 * when converted to IOVA gives us a max length that the bitmap
> +	 * pinned data can cover. Afterwards, that is capped to
> +	 * only cover the IOVA range in @iter::iova .. iter::length.
> +	 */
> +	remaining = iova_bitmap_index_to_iova(iter,
> +			iova_bitmap_iter_remaining(iter));
> +
> +	if (iova + remaining - 1 > max_iova)
> +		remaining -= ((iova + remaining - 1) - max_iova);
> +
> +	return remaining;
> +}
> +
> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
> +{
> +	return iter->offset >= iter->count;
> +}
> +
> +int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
> +{
> +	unsigned long iova = iova_bitmap_length(iter) - 1;
> +	unsigned long count = iova_bitmap_iova_to_index(iter, iova) + 1;
> +
> +	iter->offset += count;
> +
> +	iova_bitmap_iter_put(iter);
> +	if (iova_bitmap_iter_done(iter))
> +		return 0;
> +
> +	/* When we advance the iterator we pin the next set of bitmap pages */
> +	return iova_bitmap_iter_get(iter);
> +}
> +
> +unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
> +			      unsigned long iova, unsigned long length)
> +{
> +	unsigned long nbits = max(1UL, length >> dirty->pgshift), set = nbits;
> +	unsigned long offset = (iova - dirty->iova) >> dirty->pgshift;
> +	unsigned long page_idx = offset / BITS_PER_PAGE;
> +	unsigned long page_offset = dirty->start_offset;
> +	void *kaddr;
> +
> +	offset = offset % BITS_PER_PAGE;
> +
> +	do {
> +		unsigned long size = min(BITS_PER_PAGE - offset, nbits);
> +
> +		kaddr = kmap_local_page(dirty->pages[page_idx]);
> +		bitmap_set(kaddr + page_offset, offset, size);
> +		kunmap_local(kaddr);
> +		page_offset = offset = 0;
> +		nbits -= size;
> +		page_idx++;
> +	} while (nbits > 0);
> +
> +	return set;
> +}
> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
> new file mode 100644
> index 000000000000..e258d03386d3
> --- /dev/null
> +++ b/include/linux/iova_bitmap.h
> @@ -0,0 +1,189 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2022, Oracle and/or its affiliates.
> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> + */
> +#ifndef _IOVA_BITMAP_H_
> +#define _IOVA_BITMAP_H_
> +
> +#include <linux/mm.h>
> +
> +/**
> + * struct iova_bitmap - A bitmap representing a portion IOVA space
> + *
> + * Main data structure for tracking dirty IOVAs.
> + *
> + * For example something recording dirty IOVAs, will be provided of a
> + * struct iova_bitmap structure. This structure only represents a
> + * subset of the total IOVA space pinned by its parent counterpart
> + * iterator object.
> + *
> + * The user does not need to exact location of the bits in the bitmap.
> + * From user perspective the bitmap the only API available to the dirty
> + * tracker is iova_bitmap_set() which records the dirty IOVA *range*
> + * in the bitmap data.
> + *
> + * The bitmap is an array of u64 whereas each bit represents an IOVA
> + * of range of (1 << pgshift). Thus formula for the bitmap data to be
> + * set is:
> + *
> + *   data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> + */
> +struct iova_bitmap {
> +	/* base IOVA representing bit 0 of the first page */
> +	unsigned long iova;
> +
> +	/* page size order that each bit granules to */
> +	unsigned long pgshift;
> +
> +	/* offset of the first user page pinned */
> +	unsigned long start_offset;
> +
> +	/* number of pages pinned */
> +	unsigned long npages;
> +
> +	/* pinned pages representing the bitmap data */
> +	struct page **pages;
> +};
> +
> +/**
> + * struct iova_bitmap_iter - Iterator object of the IOVA bitmap
> + *
> + * Main data structure for walking the bitmap data.
> + *
> + * Abstracts the pinning work to iterate an IOVA ranges.
> + * It uses a windowing scheme and pins the bitmap in relatively
> + * big ranges e.g.
> + *
> + * The iterator uses one base page to store all the pinned pages
> + * pointers related to the bitmap. For sizeof(struct page) == 64 it
> + * stores 512 struct pages which, if base page size is 4096 it means 2M
> + * of bitmap data is pinned at a time. If the iova_bitmap page size is
> + * also base page size then the range window to iterate is 64G.
> + *
> + * For example iterating on a total IOVA range of 4G..128G, it will
> + * walk through this set of ranges:
> + *
> + *  - 4G  -  68G-1 (64G)
> + *  - 68G - 128G-1 (64G)
> + *
> + * An example of the APIs on how to iterate the IOVA bitmap:
> + *
> + *   ret = iova_bitmap_iter_init(&iter, iova, PAGE_SIZE, length, data);
> + *   if (ret)
> + *       return -ENOMEM;
> + *
> + *   for (; !iova_bitmap_iter_done(&iter) && !ret;
> + *        ret = iova_bitmap_iter_advance(&iter)) {
> + *
> + *        dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
> + *                           iova_bitmap_length(&iter));
> + *   }
> + *
> + * An implementation of the lower end (referred to above as
> + * dirty_reporter_ops) that is tracking dirty bits would:
> + *
> + *        if (iova_dirty)
> + *            iova_bitmap_set(&iter.dirty, iova, PAGE_SIZE);
> + *
> + * The internals of the object use a cursor @offset that indexes
> + * which part u64 word of the bitmap is mapped, up to @count.
> + * Those keep being incremented until @count reaches while mapping
> + * up to PAGE_SIZE / sizeof(struct page*) maximum of pages.
> + *
> + * The iterator is usually located on what tracks DMA mapped ranges
> + * or some form of IOVA range tracking that co-relates to the user
> + * passed bitmap.
> + */
> +struct iova_bitmap_iter {
> +	/* IOVA range representing the currently pinned bitmap data */
> +	struct iova_bitmap dirty;
> +
> +	/* userspace address of the bitmap */
> +	u64 __user *data;
> +
> +	/* u64 index that @dirty points to */
> +	size_t offset;
> +
> +	/* how many u64 can we walk in total */
> +	size_t count;

size_t?  These are both indexes afaict.

> +
> +	/* base IOVA of the whole bitmap */
> +	unsigned long iova;
> +
> +	/* length of the IOVA range for the whole bitmap */
> +	unsigned long length;

OTOH this could arguably be size_t and iova dma_addr_t.  Thanks,

Alex

> +};
> +
> +/**
> + * iova_bitmap_iter_init() - Initializes an IOVA bitmap iterator object.
> + * @iter: IOVA bitmap iterator to initialize
> + * @iova: Start address of the IOVA range
> + * @length: Length of the IOVA range
> + * @page_size: Page size of the IOVA bitmap. It defines what each bit
> + *             granularity represents
> + * @data: Userspace address of the bitmap
> + *
> + * Initializes all the fields in the IOVA iterator including the first
> + * user pages of @data. Returns 0 on success or otherwise errno on error.
> + */
> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
> +			  unsigned long length, unsigned long page_size,
> +			  u64 __user *data);
> +
> +/**
> + * iova_bitmap_iter_free() - Frees an IOVA bitmap iterator object
> + * @iter: IOVA bitmap iterator to free
> + *
> + * It unpins and releases pages array memory and clears any leftover
> + * state.
> + */
> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
> +
> +/**
> + * iova_bitmap_iter_done: Checks if the IOVA bitmap has data to iterate
> + * @iter: IOVA bitmap iterator to free
> + *
> + * Returns true if there's more data to iterate.
> + */
> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
> +
> +/**
> + * iova_bitmap_iter_advance: Advances the IOVA bitmap iterator
> + * @iter: IOVA bitmap iterator to advance
> + *
> + * Advances to the next range, releases the current pinned
> + * pages and pins the next set of bitmap pages.
> + * Returns 0 on success or otherwise errno.
> + */
> +int iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
> +
> +/**
> + * iova_bitmap_iova: Base IOVA of the current range
> + * @iter: IOVA bitmap iterator
> + *
> + * Returns the base IOVA of the current range.
> + */
> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
> +
> +/**
> + * iova_bitmap_length: IOVA length of the current range
> + * @iter: IOVA bitmap iterator
> + *
> + * Returns the length of the current IOVA range.
> + */
> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
> +
> +/**
> + * iova_bitmap_set: Marks an IOVA range as dirty
> + * @dirty: IOVA bitmap
> + * @iova: IOVA to mark as dirty
> + * @length: IOVA range length
> + *
> + * Marks the range [iova .. iova+length-1] as dirty in the bitmap.
> + * Returns the number of bits set.
> + */
> +unsigned long iova_bitmap_set(struct iova_bitmap *dirty,
> +			      unsigned long iova, unsigned long length);
> +
> +#endif

