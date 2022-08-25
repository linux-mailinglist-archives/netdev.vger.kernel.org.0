Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D34D5A1CFA
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiHYXPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235364AbiHYXPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:15:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D043E6D
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661469338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pnP/qB8WmkipkkDdmE+1Py5IGWD3/b+anGuFhF93kRs=;
        b=OBexyQ5teHzeMI/d/O9vxalL/cSa2Bvy0jgYDgyexTMxm6iI++L/Kp3AreuEupBpfpboor
        Ybb/weIbW3PaMd0tl3BhRbx4VulA9dl46OASbpd8iKfKaCu89LAICXWxNQDjTME9qGuQIS
        HG8jlZMVSIs3Az/8T9T/u/cBr8eKhZM=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-582-xPwdEQvCMhiOZ19u6fOk6g-1; Thu, 25 Aug 2022 19:15:37 -0400
X-MC-Unique: xPwdEQvCMhiOZ19u6fOk6g-1
Received: by mail-io1-f70.google.com with SMTP id t18-20020a5d8852000000b0068832d2b28eso11884928ios.2
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 16:15:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc;
        bh=pnP/qB8WmkipkkDdmE+1Py5IGWD3/b+anGuFhF93kRs=;
        b=Y3/WmNG1wiemtrsS9z9UnhBif1IRoMgAEXNMVKIhWysJeExI0XsGiAKBzK9YmK3RxR
         83zskr4mPYwB369hcIw0ssHmHUw8hYxF7rMbiOHMtQMDpv/K8GwuP2Yi1CryPeMmbmDE
         LO6qCn6fmS/mhz4PItVlgUQ5kWA0UAmTRFFadJR3i2AxvsWVIdv5GAXWe/QWilqT1HH7
         4jzEu0SCcyWYTR2GvDc0e/o54HRBM26f2f+gzeLOhZ3icN/m8LGQ/DDNMdOSxgVPamWH
         6YPXndRG4KNr3Q/1KJrnyAvyhf8mWCqaL5MGQdC144dit2AuLxI9OxIPB6OqToSvYDHI
         P1eQ==
X-Gm-Message-State: ACgBeo0qShF7po3RaJpi8a/OI+Mvbdp/ItC83e0jxZRnNKPyCkXeTJn7
        cNjSFBB/uXMKb92Eb7PaHBPP+0Kj2VvTkUxiUzTI0xd1GEb17wasQrzAdohOfvE5AEFBBym5Hrr
        FBxigt1txawSd8tEK
X-Received: by 2002:a02:9f0d:0:b0:349:ea4f:af3a with SMTP id z13-20020a029f0d000000b00349ea4faf3amr2839117jal.214.1661469334818;
        Thu, 25 Aug 2022 16:15:34 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6mLWHpA1xXpnVkkf5UDlIkiRC7a6ABVYxpA+bNXS6mTAZeUp1UDH0RU0OvzWAODi/97CdzLg==
X-Received: by 2002:a02:9f0d:0:b0:349:ea4f:af3a with SMTP id z13-20020a029f0d000000b00349ea4faf3amr2839100jal.214.1661469334401;
        Thu, 25 Aug 2022 16:15:34 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id e18-20020a056638021200b00349e045f08asm252140jaq.172.2022.08.25.16.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Aug 2022 16:15:33 -0700 (PDT)
Date:   Thu, 25 Aug 2022 17:15:32 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Joao Martins <joao.m.martins@oracle.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, jgg@nvidia.com,
        saeedm@nvidia.com, kvm@vger.kernel.org, netdev@vger.kernel.org,
        kuba@kernel.org, kevin.tian@intel.com, leonro@nvidia.com,
        maorg@nvidia.com, cohuck@redhat.com
Subject: Re: [PATCH V4 vfio 04/10] vfio: Add an IOVA bitmap support
Message-ID: <20220825171532.0123cbac.alex.williamson@redhat.com>
In-Reply-To: <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
References: <20220815151109.180403-1-yishaih@nvidia.com>
        <20220815151109.180403-5-yishaih@nvidia.com>
        <20220825132701.07f9a1c3.alex.williamson@redhat.com>
        <b230f8e1-1519-3164-fe0e-abf1aa55e5d4@oracle.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 23:24:39 +0100
Joao Martins <joao.m.martins@oracle.com> wrote:

> On 8/25/22 20:27, Alex Williamson wrote:
> > On Mon, 15 Aug 2022 18:11:03 +0300
> > Yishai Hadas <yishaih@nvidia.com> wrote:
> >   
> >> From: Joao Martins <joao.m.martins@oracle.com>
> >>
> >> The new facility adds a bunch of wrappers that abstract how an IOVA
> >> range is represented in a bitmap that is granulated by a given
> >> page_size. So it translates all the lifting of dealing with user
> >> pointers into its corresponding kernel addresses backing said user
> >> memory into doing finally the (non-atomic) bitmap ops to change
> >> various bits.
> >>
> >> The formula for the bitmap is:
> >>
> >>    data[(iova / page_size) / 64] & (1ULL << (iova % 64))
> >>
> >> Where 64 is the number of bits in a unsigned long (depending on arch)
> >>
> >> It introduces an IOVA iterator that uses a windowing scheme to minimize
> >> the pinning overhead, as opposed to be pinning it on demand 4K at a  
> > 
> > s/ be / /
> >   
> Will fix.
> 
> >> time. So on a 512G and with base page size it would iterate in ranges of
> >> 64G at a time, while pinning 512 pages at a time leading to fewer  
> > 
> > "on a 512G" what?  The overall size of the IOVA range is somewhat
> > irrelevant here and it's unclear where 64G comes from without reading
> > deeper into the series.  Maybe this should be something like:
> > 
> > "Assuming a 4K kernel page and 4K requested page size, we can use a
> > single kernel page to hold 512 page pointers, mapping 2M of bitmap,
> > representing 64G of IOVA space."
> >   
> Much more readable indeed. Will use that.
> 
> >> atomics (specially if the underlying user memory are hugepages).
> >>
> >> An example usage of these helpers for a given @base_iova, @page_size, @length  
> > 
> > Several long lines here that could be wrapped.
> >   
> It's already wrapped (by my editor) and also at 75 columns. I can do a
> bit shorter if that's hurting readability.

78 chars above, but git log indents by another 4 spaces, so they do
wrap.  Something around 70/72 seems better for commit logs.

> >> and __user @data:
> >>
> >> 	ret = iova_bitmap_iter_init(&iter, base_iova, page_size, length, data);
> >> 	if (ret)
> >> 		return -ENOMEM;
> >>
> >> 	for (; !iova_bitmap_iter_done(&iter) && !ret;
> >> 	     ret = iova_bitmap_iter_advance(&iter)) {
> >> 		dirty_reporter_ops(&iter.dirty, iova_bitmap_iova(&iter),
> >> 				   iova_bitmap_length(&iter));
> >> 	}
> >>
> >> 	iova_bitmap_iter_free(&iter);
> >>
> >> An implementation of the lower end -- referred to above as dirty_reporter_ops
> >> to exemplify -- that is tracking dirty bits would mark an IOVA as dirty
> >> as following:
> >>
> >> 	iova_bitmap_set(&iter.dirty, iova, page_size);
> >>
> >> or a contiguous range (example two pages):
> >>
> >> 	iova_bitmap_set(&iter.dirty, iova, 2 * page_size);
> >>
> >> The facility is intended to be used for user bitmaps representing
> >> dirtied IOVAs by IOMMU (via IOMMUFD) and PCI Devices (via vfio-pci).
> >>
> >> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
> >> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> >> ---
> >>  drivers/vfio/Makefile       |   6 +-
> >>  drivers/vfio/iova_bitmap.c  | 224 ++++++++++++++++++++++++++++++++++++
> >>  include/linux/iova_bitmap.h | 189 ++++++++++++++++++++++++++++++
> >>  3 files changed, 417 insertions(+), 2 deletions(-)
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
> >> index 000000000000..6b6008ef146c
> >> --- /dev/null
> >> +++ b/drivers/vfio/iova_bitmap.c
> >> @@ -0,0 +1,224 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/*
> >> + * Copyright (c) 2022, Oracle and/or its affiliates.
> >> + * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
> >> + */
> >> +#include <linux/iova_bitmap.h>
> >> +#include <linux/highmem.h>
> >> +
> >> +#define BITS_PER_PAGE (PAGE_SIZE * BITS_PER_BYTE)
> >> +
> >> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter);
> >> +
> >> +/*
> >> + * Converts a relative IOVA to a bitmap index.
> >> + * The bitmap is viewed an array of u64, and each u64 represents  
> > 
> > "The bitmap is viewed as an u64 array and each u64 represents"
> >   
> Will use that.
> 
> >> + * a range of IOVA, and the whole pinned pages to the range window.  
> > 
> > I think this phrase after the comma is trying to say something about the
> > windowed mapping, but I don't know what.
> >   
> Yes. doesn't add much in the context of the function.
> 
> > This function provides the index into that u64 array for a given IOVA
> > offset.
> >   
> I'll use this instead.
> 
> >> + * Relative IOVA means relative to the iter::dirty base IOVA (stored
> >> + * in dirty::iova). All computations in this file are done using
> >> + * relative IOVAs and thus avoid an extra subtraction against
> >> + * dirty::iova. The user API iova_bitmap_set() always uses a regular
> >> + * absolute IOVAs.  
> > 
> > So why don't we use variables that make it clear when an IOVA is an
> > IOVA and when it's an offset?
> >   
> I was just sticking the name @offset to how we iterate towards the u64s
> to avoid confusion. Should I switch to offset here I should probably change
> @offset of the struct into something else. But I see you suggested something
> like that too further below.
> 
> >> + */
> >> +static unsigned long iova_bitmap_iova_to_index(struct iova_bitmap_iter *iter,
> >> +					       unsigned long iova)  
> > 
> > iova_bitmap_offset_to_index(... unsigned long offset)?
> >   
> >> +{OK.  
> 
> >> +	unsigned long pgsize = 1 << iter->dirty.pgshift;
> >> +
> >> +	return iova / (BITS_PER_TYPE(*iter->data) * pgsize);  
> > 
> > Why do we name the bitmap "data" rather than "bitmap"?
> >   
> I was avoid overusing the word bitmap given structure is already called @bitmap.
> At the end of the day it's a user data pointer. But I can call it @bitmap.

@data is not very descriptive, and finding a pointer to a bitmap inside
a struct iova_bitmap feels like a fairly natural thing to me ;)

> > Why do we call the mapped section "dirty" rather than "mapped"?  It's
> > not necessarily dirty, it's just the window that's current mapped.
> >   
> Good point. Dirty is just what we tracked, but the structure ::dirty is closer
> to representing what's actually mapped yes. I'll switch to mapped.
> 
> >> +}
> >> +
> >> +/*
> >> + * Converts a bitmap index to a *relative* IOVA.
> >> + */
> >> +static unsigned long iova_bitmap_index_to_iova(struct iova_bitmap_iter *iter,
> >> +					       unsigned long index)  
> > 
> > iova_bitmap_index_to_offset()?
> >   
> ack
> 
> >> +{
> >> +	unsigned long pgshift = iter->dirty.pgshift;
> >> +
> >> +	return (index * BITS_PER_TYPE(*iter->data)) << pgshift;
> >> +}
> >> +
> >> +/*
> >> + * Pins the bitmap user pages for the current range window.
> >> + * This is internal to IOVA bitmap and called when advancing the
> >> + * iterator.
> >> + */
> >> +static int iova_bitmap_iter_get(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +	unsigned long npages;
> >> +	u64 __user *addr;
> >> +	long ret;
> >> +
> >> +	/*
> >> +	 * @offset is the cursor of the currently mapped u64 words  
> > 
> > So it's an index?  I don't know what a cursor is.    
> 
> In my "english" 'cursor' as a synonym for index yes.
> 
> > If we start using
> > "offset" to describe a relative iova, maybe this becomes something more
> > descriptive, mapped_base_index?
> >   
> I am not very fond of long names, @mapped_index maybe hmm
> 
> >> +	 * that we have access. And it indexes u64 bitmap word that is
> >> +	 * mapped. Anything before @offset is not mapped. The range
> >> +	 * @offset .. @count is mapped but capped at a maximum number
> >> +	 * of pages.  
> > 
> > @total_indexes rather than @count maybe?
> >   
> It's still a count of indexes, I thought @count was explicit already without
> being too wordy. I can suffix with indexes if going with mapped_index. Or maybe
> @mapped_count maybe

I was trying to get "index" in there somehow to make it stupid obvious
that it's a count of indexes.

> >> +	 */
> >> +	npages = DIV_ROUND_UP((iter->count - iter->offset) *
> >> +			      sizeof(*iter->data), PAGE_SIZE);
> >> +
> >> +	/*
> >> +	 * We always cap at max number of 'struct page' a base page can fit.
> >> +	 * This is, for example, on x86 means 2M of bitmap data max.
> >> +	 */
> >> +	npages = min(npages,  PAGE_SIZE / sizeof(struct page *));
> >> +	addr = iter->data + iter->offset;  
> > 
> > Subtle pointer arithmetic.
> >   
> >> +	ret = pin_user_pages_fast((unsigned long)addr, npages,
> >> +				  FOLL_WRITE, dirty->pages);
> >> +	if (ret <= 0)
> >> +		return -EFAULT;
> >> +
> >> +	dirty->npages = (unsigned long)ret;
> >> +	/* Base IOVA where @pages point to i.e. bit 0 of the first page */
> >> +	dirty->iova = iova_bitmap_iova(iter);  
> > 
> > If we're operating on an iterator, wouldn't convention suggest this is
> > an iova_bitmap_itr_FOO function?  mapped_iova perhaps.
> >   
> 
> Yes.
> 
> Given your earlier comment, mapped iova is a bit more obvious.
> 
> >> +
> >> +	/*
> >> +	 * offset of the page where pinned pages bit 0 is located.
> >> +	 * This handles the case where the bitmap is not PAGE_SIZE
> >> +	 * aligned.
> >> +	 */
> >> +	dirty->start_offset = offset_in_page(addr);  
> > 
> > Maybe pgoff to avoid confusion with relative iova offsets.
> >   
> Will fix. And it's also convention in mm code, so I should stick with that.
> 
> > It seems suspect that the length calculations don't take this into
> > account.
> >   
> The iova/length/indexes functions only work over bit/iova "quantity" and indexing of it
> without needing to know where the first bit of the mapped range starts. So the pgoff
> is only important when we actually set bits on the bitmap i.e. iova_bitmap_set().

Ok

> >> +	return 0;
> >> +}
> >> +
> >> +/*
> >> + * Unpins the bitmap user pages and clears @npages
> >> + * (un)pinning is abstracted from API user and it's done
> >> + * when advancing or freeing the iterator.
> >> + */
> >> +static void iova_bitmap_iter_put(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	if (dirty->npages) {
> >> +		unpin_user_pages(dirty->pages, dirty->npages);
> >> +		dirty->npages = 0;
> >> +	}
> >> +}
> >> +
> >> +int iova_bitmap_iter_init(struct iova_bitmap_iter *iter,
> >> +			  unsigned long iova, unsigned long length,
> >> +			  unsigned long page_size, u64 __user *data)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	memset(iter, 0, sizeof(*iter));
> >> +	dirty->pgshift = __ffs(page_size);
> >> +	iter->data = data;
> >> +	iter->count = iova_bitmap_iova_to_index(iter, length - 1) + 1;
> >> +	iter->iova = iova;
> >> +	iter->length = length;
> >> +
> >> +	dirty->iova = iova;
> >> +	dirty->pages = (struct page **)__get_free_page(GFP_KERNEL);
> >> +	if (!dirty->pages)
> >> +		return -ENOMEM;
> >> +
> >> +	return iova_bitmap_iter_get(iter);
> >> +}
> >> +
> >> +void iova_bitmap_iter_free(struct iova_bitmap_iter *iter)
> >> +{
> >> +	struct iova_bitmap *dirty = &iter->dirty;
> >> +
> >> +	iova_bitmap_iter_put(iter);
> >> +
> >> +	if (dirty->pages) {
> >> +		free_page((unsigned long)dirty->pages);
> >> +		dirty->pages = NULL;
> >> +	}
> >> +
> >> +	memset(iter, 0, sizeof(*iter));
> >> +}
> >> +
> >> +unsigned long iova_bitmap_iova(struct iova_bitmap_iter *iter)
> >> +{
> >> +	unsigned long skip = iter->offset;
> >> +
> >> +	return iter->iova + iova_bitmap_index_to_iova(iter, skip);
> >> +}
> >> +
> >> +/*
> >> + * Returns the remaining bitmap indexes count to process for the currently pinned
> >> + * bitmap pages.
> >> + */
> >> +static unsigned long iova_bitmap_iter_remaining(struct iova_bitmap_iter *iter)  
> > 
> > iova_bitmap_iter_mapped_remaining()?
> >   
> Yes.
> 
> >> +{
> >> +	unsigned long remaining = iter->count - iter->offset;
> >> +
> >> +	remaining = min_t(unsigned long, remaining,
> >> +		     (iter->dirty.npages << PAGE_SHIFT) / sizeof(*iter->data));
> >> +
> >> +	return remaining;
> >> +}
> >> +
> >> +unsigned long iova_bitmap_length(struct iova_bitmap_iter *iter)  
> > 
> > iova_bitmap_iter_mapped_length()?
> >   
> Yes.
> 
> I don't particularly like long names, but doesn't seem to have better alternatives.
> 
> Part of the reason the names look 'shortened' was because the object we pass
> is already an iterator, so it's implicit that we only fetch the under-iteration/mapped
> iova. Or that was at least the intention.

Yes, but that means you need to look at the function declaration to
know that it takes an iova_bitmap_iter rather than an iova_bitmap,
which already means it's not intuitive enough.

> > Maybe it doesn't really make sense to differentiate the iterator from
> > the bitmap in the API.  In fact, couldn't we reduce the API to simply:
> > 
> > int iova_bitmap_init(struct iova_bitmap *bitmap, dma_addr_t iova,
> > 		     size_t length, size_t page_size, u64 __user *data);
> > 
> > int iova_bitmap_for_each(struct iova_bitmap *bitmap, void *data,
> > 			 int (*fn)(void *data, dma_addr_t iova,
> > 			 	   size_t length,
> > 				   struct iova_bitmap *bitmap));
> > 
> > void iova_bitmap_free(struct iova_bitmap *bitmap);
> > 
> > unsigned long iova_bitmap_set(struct iova_bitmap *bitmap,
> > 			      dma_addr_t iova, size_t length);
> > 
> > Removes the need for the API to have done, advance, iova, and length
> > functions.
> >   
> True, it would be simpler.
> 
> Could also allow us to hide the iterator details enterily and switch to
> container_of() from iova_bitmap pointer. Though, from caller, it would be
> weird to do:
> 
> struct iova_bitmap_iter iter;
> 
> iova_bitmap_init(&iter.dirty, ....);
> 
> Hmm, maybe not that strange.
> 
> Unless you are trying to suggest to merge both struct iova_bitmap and
> iova_bitmap_iter together? I was trying to keep them separate more for
> the dirty tracker (IOMMUFD/VFIO, to just be limited to iova_bitmap_set()
> with the generic infra being the one managing that iterator state in a
> separate structure.

Not suggesting the be merged, but why does the embedded mapping
structure need to be exposed to the API?  That's an implementation
detail that's causing confusion and naming issues for which structure
is passed and how do we represent that in the function name.  Thanks,

Alex

