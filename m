Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826A057BBC6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 18:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiGTQre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 12:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234444AbiGTQrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 12:47:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 169C343E6B
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658335651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7e2FwVLu9G90MFJDMlm6+BIxdtUncoj10Ov9o5JwI68=;
        b=bLNbC7KiH0V2y2tEwiKFzdzrir6Xf19nGGhVr7zR5koZ0tFj2F5bg32Q6iybwExIxMB+XQ
        xHHISPPRYXjSAIPZqp0MAcZ6ZORDuXx0XEm5yJV9PBSU1nyhVcSxNFlxzH1Tn3a0h9p1Qh
        yH5KsTLc/vHOJSRGQ6UOJed/aTyvJgA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-649-rRLCYSxHN9KRW6nMt51Now-1; Wed, 20 Jul 2022 12:47:29 -0400
X-MC-Unique: rRLCYSxHN9KRW6nMt51Now-1
Received: by mail-il1-f199.google.com with SMTP id o9-20020a056e0214c900b002dc29c288bfso11604945ilk.3
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 09:47:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=7e2FwVLu9G90MFJDMlm6+BIxdtUncoj10Ov9o5JwI68=;
        b=y6ajmr0fAfQvKTxG5IylWSs2UE3nyU4NdSU/Ndw6wvVgvA5ItdHu8huIGDqb3ddGMA
         2398bQW/ycBbNdWIztjGnlsJLuO+9kNa3ukYFACECTAQf493PXJWDgR1CfIGtUqeGkOl
         TOgYxujs40UmvX5/G2xN4ElBpN3HjJQ8mg/uyALrWTLLKrEOut3V38+2HFmxF7GHpaQe
         ayYzWtjRWVviRt3SG1OLKLsVWzWiaCq3X92meHtYZVwIQUqUmgDt62VFbX9vBOcnKWLS
         S1PXNrb7YM1kKUQuiG5wjuQwRXL01LdfE8/HDyDALyuCqR25j617yvfT+R0H4hLDw8CU
         rvUA==
X-Gm-Message-State: AJIora/CVwvh5HmLEetkzDUVvVIFEWINDNM2IHYr+s9zM9ulb9TAQzEk
        hgvm/6kyJV++T5WcCpVnT+1mQHR4MPpDGyfNUMOMgTnPXNq7i4naEd/Ck5WcVpUHVKAev6tc0DT
        PrnP4ACn58eOxJNX6
X-Received: by 2002:a05:6638:3394:b0:33f:7e87:5879 with SMTP id h20-20020a056638339400b0033f7e875879mr20702181jav.260.1658335648180;
        Wed, 20 Jul 2022 09:47:28 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u6E/2LnTxcIDBzDXv0bu72hXc0I3IbxWzjHhMGzVOMi5Uw41PcuYR7boTG2jLPuU4wlEgT4A==
X-Received: by 2002:a05:6638:3394:b0:33f:7e87:5879 with SMTP id h20-20020a056638339400b0033f7e875879mr20702163jav.260.1658335647776;
        Wed, 20 Jul 2022 09:47:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id t131-20020a025489000000b00339de279a5bsm8078863jaa.126.2022.07.20.09.47.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:47:27 -0700 (PDT)
Date:   Wed, 20 Jul 2022 10:47:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V2 vfio 05/11] vfio: Add an IOVA bitmap support
Message-ID: <20220720104725.19aadc5d.alex.williamson@redhat.com>
In-Reply-To: <11865968-4a13-11b0-abfb-267f9adf3a95@oracle.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
        <20220714081251.240584-6-yishaih@nvidia.com>
        <20220719130114.2eecbba1.alex.williamson@redhat.com>
        <11865968-4a13-11b0-abfb-267f9adf3a95@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 20 Jul 2022 02:57:24 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 7/19/22 20:01, Alex Williamson wrote:
> > On Thu, 14 Jul 2022 11:12:45 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> >> From: Joao Martins <joao.m.martins@oracle.com>
> >>
> >> The new facility adds a bunch of wrappers that abstract how an IOVA
> >> range is represented in a bitmap that is granulated by a given
> >> page_size. So it translates all the lifting of dealing with user
> >> pointers into its corresponding kernel addresses backing said user
> >> memory into doing finally the bitmap ops to change various bits.
> >>
> >> The formula for the bitmap is:
> >>
> >>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> >>
> >> Where 64 is the number of bits in a unsigned long (depending on arch)
> >>
> >> An example usage of these helpers for a given @iova, @page_size, @length
> >> and __user @data:
> >>
> >> 	iova_bitmap_init(&iter.dirty, iova, __ffs(page_size));
> >> 	ret = iova_bitmap_iter_init(&iter, iova, length, data);  
> > 
> > Why are these separate functions given this use case?
> >   
> Because one structure (struct iova_bitmap) represents the user-facing
> part i.e. the one setting dirty bits (e.g. the iommu driver or mlx5 vfio)
> and the other represents the iterator of said IOVA bitmap. The iterator
> does all the work while the bitmap user is the one marshalling dirty
> bits from vendor structure into the iterator-prepared iova_bitmap
> (using iova_bitmap_set).
> 
> It made sense to me to separate the two initializations, but in pratice
> both iterator cases (IOMMUFD and VFIO) are initializing in the same way.
> Maybe better merge them for now, considering that it is redundant to retain
> this added complexity.
> 
> >> 	if (ret)
> >> 		return -ENOMEM;
> >>
> >> 	for (; !iova_bitmap_iter_done(&iter);
> >> 	     iova_bitmap_iter_advance(&iter)) {
> >> 		ret = iova_bitmap_iter_get(&iter);
> >> 		if (ret)
> >> 			break;
> >> 		if (dirty)
> >> 			iova_bitmap_set(iova_bitmap_iova(&iter),
> >> 					iova_bitmap_iova_length(&iter),
> >> 					&iter.dirty);
> >>
> >> 		iova_bitmap_iter_put(&iter);
> >>
> >> 		if (ret)
> >> 			break;  
> > 
> > This break is unreachable.
> >   
> I'll remove it.
> 
> >> 	}
> >>
> >> 	iova_bitmap_iter_free(&iter);
> >>
> >> The facility is intended to be used for user bitmaps representing
> >> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
> >>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>  drivers/vfio/Makefile       |   6 +-
> >>  drivers/vfio/iova_bitmap.c  | 164 ++++++++++++++++++++++++++++++++++++
> >>  include/linux/iova_bitmap.h |  46 ++++++++++
> >>  3 files changed, 214 insertions(+), 2 deletions(-)
> >>  create mode 100644 drivers/vfio/iova_bitmap.c
> >>  create mode 100644 include/linux/iova_bitmap.h
> >>
> >> diff --git a/drivers/vfio/Makefile b/drivers/vfio/Makefile
> >> index 1a32357592e3..1d6cad32d366 100644
> >> --- a/drivers/vfio/Makefile
> >> +++ b/drivers/vfio/Makefile
> >> @@ -1,9 +1,11 @@
> >>  # SPDX-License-Identifier: GPL-2.0
> >>  vfio_virqfd-y := virqfd.o
> >>  
> >> -vfio-y += vfio_main.o
> >> -
> >>  obj-$(CONFIG_VFIO) += vfio.o
> >> +
> >> +vfio-y := vfio_main.o \
> >> +          iova_bitmap.o \
> >> +
> >>  obj-$(CONFIG_VFIO_VIRQFD) += vfio_virqfd.o
> >>  obj-$(CONFIG_VFIO_IOMMU_TYPE1) += vfio_iommu_type1.o
> >>  obj-$(CONFIG_VFIO_IOMMU_SPAPR_TCE) += vfio_iommu_spapr_tce.o
> >> diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
> >> new file mode 100644
> >> index 000000000000..9ad1533a6aec
> >> --- /dev/null
> >> +++ b/drivers/vfio/iova_bitmap.c
> >> @@ -0,0 +1,164 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (c) 2022, Oracle and/or its affiliates.
> >> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> >> + */
> >> +
> >> +#include <linux/iova_bitmap.h>
> >> +
> >> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
> >> +					       unsigned long iova_length)  
> > 
> > If we have an iova-to-index function, why do we pass it a length?  That
> > seems to be conflating the use cases where the caller is trying to
> > determine the last index for a range with the actual implementation of
> > this helper.
> >   
> 
> see below
> 
> >> +{
> >> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
> >> +
> >> +	return DIV_ROUND_UP(iova_length, BITS_PER_TYPE(*iter->data) * pgsize);  
> > 
> > ROUND_UP here doesn't make sense to me and is not symmetric with the
> > below index-to-iova function.  For example an iova of 0x1000 give me an
> > index of 1, but index of 1 gives me an iova of 0x40000.  Does this code
> > work??
> >   
> It does work. The functions aren't actually symmetric, and iova_to_index() is returning
> the number of elements based on bits-per-u64/page_size for a IOVA length. And it was me
> being defensive to avoid having to fixup to iovas given that all computations can be done
> with lengths/nr-elements.
> 
> I have been reworking IOMMUFD original version this originated and these are remnants of
> working over chunks of bitmaps/iova rather than treating the bitmap as an array. But the
> latter is where I was aiming at in terms of structure. I should make these symmetric and
> actually return an index and fully adhere to that symmetry as convention.
> 
> Thus will remove the DIV_ROUND_UP here, switch it to work under an IOVA instead of length
> and adjust the necessary off-by-one and +1 in its respective call sites. Sorry for the
> confusion this has caused.
> 
> >> +}
> >> +
> >> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
> >> +					       unsigned long index)
> >> +{
> >> +	unsigned long pgshift = iter->dirty.pgshift;
> >> +
> >> +	return (index * sizeof(*iter->data) * BITS_PER_BYTE) << pgshift;  
> >                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > Isn't that BITS_PER_TYPE(*iter->data), just as in the previous function?
> >   
> Yeap, I'll switch to that.
> 
> >> +}
> >> +
> >> +static unsigned long iova_bitmap_iter_left(struct iova_bitmap_iter *iter)  
> > 
> > I think this is trying to find "remaining" whereas "left" can be
> > confused with a direction.
> >   
> Yes, it was bad english on my end. I'll replace it with @remaining.
> 
> >> +{
> >> +	unsigned long left = iter->count - iter->offset;
> >> +
> >> +	left = min_t(unsigned long, left,
> >> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));  
> > 
> > Ugh, dirty.npages is zero'd on bitmap init, allocated on get and left
> > with stale data on put.  This really needs some documentation/theory of
> > operation.
> >   
> 
> So the get and put are always paired, and their function is to pin a chunk
> of the bitmap (up to 2M which is how many struct pages can fit in one
> base page) and initialize the iova_bitmap with the info on what the bitmap
> pages represent in terms of which IOVA space.
> 
> So while @npages is left stale after put(), its value is only ever useful
> after get() (i.e. pinning). And its purpose is to cap the max pages
> we can access from the bitmap for also e.g. calculating
> iova_bitmap_length()/iova_bitmap_iter_left()
> or advancing the iterator.
> 
> >> +
> >> +	return left;
> >> +}
> >> +
> >> +/*
> >> + * Input argument of number of bits to bitmap_set() is unsigned integer, which
> >> + * further casts to signed integer for unaligned multi-bit operation,
> >> + * __bitmap_set().
> >> + * Then maximum bitmap size supported is 2^31 bits divided by 2^3 bits/byte,
> >> + * that is 2^28 (256 MB) which maps to 2^31 * 2^12 = 2^43 (8TB) on 4K page
> >> + * system.
> >> + */  
> > 
> > This is all true and familiar, but what's it doing here?  The type1
> > code this comes from uses this to justify some #defines that are used
> > to sanitize input.  I see no such enforcement in this code.  The only
> > comment in this whole patch and it seems irrelevant.
> >   
> This was previously related to macros I had here that serve the same purpose
> as the ones in VFIO, but the same said validation was made in some other way
> and by distraction I left this comment stale. I'll remove it.
> 
> >> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
> >> +			  unsigned long iova, unsigned long length,
> >> +			  u64 __user *data)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	iter->data = data;
> >> +	iter->offset = 0;
> >> +	iter->count = iova_bitmap_iova_to_index(iter, length);  
> > 
> > If this works, it's because the DIV_ROUND_UP above accounted for what
> > should have been and index-to-count fixup here, ie. add one.
> >   
> As mentioned earlier, I'll change that to the suggestion above.
> 
> >> +	iter->iova = iova;
> >> +	iter->length = length;
> >> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
> >> +
> >> +	return !dirty->pages ? -ENOMEM : 0;
> >> +}
> >> +
> >> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	if (dirty->pages) {
> >> +		free_page((unsigned long)dirty->pages);
> >> +		dirty->pages = NULL;
> >> +	}
> >> +}
> >> +
> >> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter)
> >> +{
> >> +	return iter->offset >= iter->count;
> >> +}
> >> +
> >> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)
> >> +{
> >> +	unsigned long max_iova = iter->dirty.iova + iter->length;
> >> +	unsigned long left = iova_bitmap_iter_left(iter);
> >> +	unsigned long iova = iova_bitmap_iova(iter);
> >> +
> >> +	left = iova_bitmap_index_to_iova(iter, left);  
> > 
> > @left is first used for number of indexes and then for an iova range :(
> >   
> I was trying to avoid an extra variable and an extra long line.
> 
> >> +	if (iova + left > max_iova)
> >> +		left -= ((iova + left) - max_iova);
> >> +
> >> +	return left;
> >> +}  
> > 
> > IIUC, this is returning the iova free space in the bitmap, not the
> > length of the bitmap??
> >   
> This is essentially representing your bitmap working set IOW the length
> of the *pinned* bitmap. Not the size of the whole bitmap.
> 
> >> +
> >> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
> >> +{
> >> +	unsigned long skip = iter->offset;
> >> +
> >> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
> >> +}  
> > 
> > It would help if this were defined above it's usage above.
> >   
> I'll move it.
> 
> >> +
> >> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter)
> >> +{
> >> +	unsigned long length = iova_bitmap_length(iter);
> >> +
> >> +	iter->offset += iova_bitmap_iova_to_index(iter, length);  
> > 
> > Again, fudging an index count based on bogus index value.
> >   
> As mentioned earlier, I'll change that iova_bitmap_iova_to_index()
> to return an index instead of nr of elements.
> 
> >> +}
> >> +
> >> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	if (dirty->npages)
> >> +		unpin_user_pages(dirty->pages, dirty->npages);  
> > 
> > dirty->npages = 0;?
> >   
> Sadly no, because after iova_bitmap_iter_put() we will call
> iova_bitmap_iter_advance() to go to the next chunk of the bitmap
> (i.e. the next 64G of IOVA, or IOW the next 2M of bitmap memory).
> 
> I could remove explicit calls to iova_bitmap_iter_{get,put}()
> while making them internal only and merge it in iova_bitmap_iter_advance()
> and iova_bimap_iter_init. This should a bit simpler for API user
> and I would be able to clear npages here. Let me see how this looks.
> 
> >> +}
> >> +
> >> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +	unsigned long npages;
> >> +	u64 __user *addr;
> >> +	long ret;
> >> +
> >> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
> >> +			      sizeof(*iter->data), PAGE_SIZE);
> >> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
> >> +	addr = iter->data + iter->offset;
> >> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
> >> +				  FOLL_WRITE, dirty->pages);
> >> +	if (ret <= 0)
> >> +		return ret;
> >> +
> >> +	dirty->npages = (unsigned long)ret;
> >> +	dirty->iova = iova_bitmap_iova(iter);
> >> +	dirty->start_offset = offset_in_page(addr);
> >> +	return 0;
> >> +}
> >> +
> >> +void iova_bitmap_init(struct iova_bitmap *bitmap,
> >> +		      unsigned long base, unsigned long pgshift)
> >> +{
> >> +	memset(bitmap, 0, sizeof(*bitmap));
> >> +	bitmap->iova = base;
> >> +	bitmap->pgshift = pgshift;
> >> +}
> >> +
> >> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
> >> +			     unsigned long iova,
> >> +			     unsigned long length)
> >> +{
> >> +	unsigned long nbits, offset, start_offset, idx, size, *kaddr;
> >> +
> >> +	nbits = max(1UL, length >> dirty->pgshift);
> >> +	offset = (iova - dirty->iova) >> dirty->pgshift;
> >> +	idx = offset / (PAGE_SIZE * BITS_PER_BYTE);
> >> +	offset = offset % (PAGE_SIZE * BITS_PER_BYTE);
> >> +	start_offset = dirty->start_offset;
> >> +
> >> +	while (nbits > 0) {
> >> +		kaddr = kmap_local_page(dirty->pages[idx]) + start_offset;
> >> +		size = min(PAGE_SIZE * BITS_PER_BYTE - offset, nbits);
> >> +		bitmap_set(kaddr, offset, size);
> >> +		kunmap_local(kaddr - start_offset);
> >> +		start_offset = offset = 0;
> >> +		nbits -= size;
> >> +		idx++;
> >> +	}
> >> +
> >> +	return nbits;
> >> +}
> >> +EXPORT_SYMBOL_GPL(iova_bitmap_set);
> >> +
> >> diff --git a/include/linux/iova_bitmap.h b/include/linux/iova_bitmap.h
> >> new file mode 100644
> >> index 000000000000..c474c351634a
> >> --- /dev/null
> >> +++ b/include/linux/iova_bitmap.h
> >> @@ -0,0 +1,46 @@
> >> +/* SPDX-License-Identifier: GPL-2.0 */
> >> +/*
> >> + * Copyright (c) 2022, Oracle and/or its affiliates.
> >> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> >> + */
> >> +
> >> +#ifndef _IOVA_BITMAP_H_
> >> +#define _IOVA_BITMAP_H_
> >> +
> >> +#include <linux/highmem.h>
> >> +#include <linux/mm.h>
> >> +#include <linux/uio.h>
> >> +
> >> +struct iova_bitmap {
> >> +	unsigned long iova;
> >> +	unsigned long pgshift;
> >> +	unsigned long start_offset;
> >> +	unsigned long npages;
> >> +	struct page **pages;
> >> +};
> >> +
> >> +struct iova_bitmap_iter {
> >> +	struct iova_bitmap dirty;
> >> +	u64 __user *data;
> >> +	size_t offset;
> >> +	size_t count;
> >> +	unsigned long iova;
> >> +	unsigned long length;
> >> +};
> >> +
> >> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter, unsigned long iova,
> >> +			  unsigned long length, u64 __user *data);
> >> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter);
> >> +bool iova_bitmap_iter_done(struct iova_bitmap_iter *iter);
> >> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter);
> >> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter);
> >> +void iova_bitmap_iter_advance(struct iova_bitmap_iter *iter);
> >> +int iova_bitmap_iter_get(struct iova_bitmap_iter *iter);
> >> +void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
> >> +void iova_bitmap_init(struct iova_bitmap *bitmap,
> >> +		      unsigned long base, unsigned long pgshift);
> >> +unsigned int iova_bitmap_set(struct iova_bitmap *dirty,
> >> +			     unsigned long iova,
> >> +			     unsigned long length);
> >> +
> >> +#endif  
> > 
> > No relevant comments, no theory of operation.  I found this really
> > difficult to review and the page handling is still not clear to me.
> > I'm not willing to take on maintainership of this code under
> > drivers/vfio/ as is.   
> 
> Sorry for the lack of comments/docs and lack of clearity in some of the
> functions. I'll document all functions/fields and add a comment bloc at
> the top explaining the theory on how it should be used/works, alongside
> the improvements you suggested above.
> 
> Meanwhile what is less clear for you on the page handling? We are essentially
> calculating the number of pages based of @offset and @count and then preping
> the iova_bitmap (@dirty) with the base IOVA and page offset. iova_bitmap_set()
> then computes where is the should start setting bits, and then it kmap() each page
> and sets the said bits. So far I am not caching kmap() kaddr,
> so the majority of iova_bitmap_set() complexity comes from iterating over number
> of bits to kmap and accounting to the offset that user bitmap address had.

It could have saved a lot of struggling through this code if it were
presented as a windowing scheme to iterate over a user bitmap.

As I understand it more though, does the API really fit the expected use
cases?  As presented here and used in the following patch, we map every
section of the user bitmap, present that section to the device driver
and ask them to mark dirty bits and atomically clear their internal
tracker for that sub-range.  This seems really inefficient.

Are we just counting on the fact that each 2MB window of dirty bitmap
is 64GB of guest RAM (assuming 4KB pages) and there's likely something
dirty there?

It seems like a more efficient API might be for us to call the device
driver with an iterator object, which the device driver uses to call
back into this bitmap helper to set specific iova+length ranges as
dirty.  The iterator could still cache the kmap'd page (or pages) to
optimize localized dirties, but we don't necessarily need to kmap and
present every section of the bitmap to the driver.  Thanks,

Alex

