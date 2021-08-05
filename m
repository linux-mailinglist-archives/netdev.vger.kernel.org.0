Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7D33E14C5
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240456AbhHEMe2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:34:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239754AbhHEMe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 08:34:27 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A2BC0613C1
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 05:34:13 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id k9so8117704edr.10
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 05:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GRecJWHpf0gjvXsYNJwzmmW+nOAqDS98ZsWB4Lu3HTk=;
        b=S6f8tdmaaPakzb2Xs58u/YwvnIh9rekjN/u2Vg+M56f15y23TmCewo4lbHT11uACan
         R+0Eu0cRgugPW124XxHQqGp3wx/RovVoqc9g/5nLnXaB61Z52UKlJ4PHE0l2y75vPNYN
         ZN3eBziwB8y1VUGOe2n0Cfa5D1KbaHg1q6wsiTnO5N9jY6j1pR4h2h+zXNzjloGGJxcc
         JozAJrUYNwvab7kealUfpLrbQQgvGROl4OvFrT1C6e1DBRJy0NHbCY5LUedUjTqVYfLJ
         K3XRVYc1Xi2ItkoU/5e6Bxz4uSapyv4cN401EkNa/+XGqNXSxwJLROZJrA4Iwpix9s/8
         pOvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GRecJWHpf0gjvXsYNJwzmmW+nOAqDS98ZsWB4Lu3HTk=;
        b=PlVafBDxefJko7cLmgaLOnj0Zb6fYk3hS9b0iHSmHASmxfqXr9CeY5SAdte/7v/jT0
         eUtwfslIXuOA0rdUZPEDagUqz3/E8PE++IVvYq/NZymVLVW1IzmnEy+s3BkZWNKhcOAt
         9WhIe0GYhhjknwHVn5XIW3LvfIpONeTGWwcv/pUFRTez7BMfKheDnT1NyoWACAT7370T
         kVpZ81tSDFB59hFx0nE7CTBw9JREjrHErbVGz7373kGXCFNWQ89qLzt+aVMDw1qHzeQf
         4gBH6m7TticX0tL1qHj9Ox+RD8VER59m7aM/bl/hAFLljSUriY3Cfg90itipPDU1rjoN
         gc0g==
X-Gm-Message-State: AOAM5339DVzYR8l7u8AhFQ47hgGpPCw5IBCoBJvwpbT7YMdXXqfrRsM7
        cNW7t4wfoJ3lcnyfby4kdmTLQ2D2IMzSDMzY3EuD
X-Google-Smtp-Source: ABdhPJychbjmynLh9/Ea3o5hkpZtU2SNp1dmaj9zAcG470ZYKrb0D+35OhxBNRLSqHVcxZBaICqILCn+TZG+ukzKlGk=
X-Received: by 2002:a05:6402:74f:: with SMTP id p15mr6132819edy.195.1628166852249;
 Thu, 05 Aug 2021 05:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210729073503.187-1-xieyongji@bytedance.com> <20210729073503.187-2-xieyongji@bytedance.com>
 <43d88942-1cd3-c840-6fec-4155fd544d80@redhat.com> <CACycT3vcpwyA3xjD29f1hGnYALyAd=-XcWp8+wJiwSqpqUu00w@mail.gmail.com>
 <6e05e25e-e569-402e-d81b-8ac2cff1c0e8@arm.com> <CACycT3sm2r8NMMUPy1k1PuSZZ3nM9aic-O4AhdmRRCwgmwGj4Q@mail.gmail.com>
 <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com>
In-Reply-To: <417ce5af-4deb-5319-78ce-b74fb4dd0582@arm.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 5 Aug 2021 20:34:01 +0800
Message-ID: <CACycT3vARzvd4-dkZhDHqUkeYoSxTa2ty0z0ivE1znGti+n1-g@mail.gmail.com>
Subject: Re: [PATCH v10 01/17] iova: Export alloc_iova_fast() and free_iova_fast()
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     kvm <kvm@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        songmuchun@bytedance.com, Jens Axboe <axboe@kernel.dk>,
        He Zhe <zhe.he@windriver.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        iommu@lists.linux-foundation.org, bcrl@kvack.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 4, 2021 at 11:43 PM Robin Murphy <robin.murphy@arm.com> wrote:
>
> On 2021-08-04 06:02, Yongji Xie wrote:
> > On Tue, Aug 3, 2021 at 6:54 PM Robin Murphy <robin.murphy@arm.com> wrot=
e:
> >>
> >> On 2021-08-03 09:54, Yongji Xie wrote:
> >>> On Tue, Aug 3, 2021 at 3:41 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>>
> >>>>
> >>>> =E5=9C=A8 2021/7/29 =E4=B8=8B=E5=8D=883:34, Xie Yongji =E5=86=99=E9=
=81=93:
> >>>>> Export alloc_iova_fast() and free_iova_fast() so that
> >>>>> some modules can use it to improve iova allocation efficiency.
> >>>>
> >>>>
> >>>> It's better to explain why alloc_iova() is not sufficient here.
> >>>>
> >>>
> >>> Fine.
> >>
> >> What I fail to understand from the later patches is what the IOVA doma=
in
> >> actually represents. If the "device" is a userspace process then
> >> logically the "IOVA" would be the userspace address, so presumably
> >> somewhere you're having to translate between this arbitrary address
> >> space and actual usable addresses - if you're worried about efficiency
> >> surely it would be even better to not do that?
> >>
> >
> > Yes, userspace daemon needs to translate the "IOVA" in a DMA
> > descriptor to the VA (from mmap(2)). But this actually doesn't affect
> > performance since it's an identical mapping in most cases.
>
> I'm not familiar with the vhost_iotlb stuff, but it looks suspiciously
> like you're walking yet another tree to make those translations. Even if
> the buffer can be mapped all at once with a fixed offset such that each
> DMA mapping call doesn't need a lookup for each individual "IOVA" - that
> might be what's happening already, but it's a bit hard to follow just
> reading the patches in my mail client - vhost_iotlb_add_range() doesn't
> look like it's super-cheap to call, and you're serialising on a lock for
> that.
>

Yes, that's true. Since the software IOTLB is not used in the VM case,
we need a unified way (vhost_iotlb) to manage the IOVA mapping for
both VM and Container cases.

> My main point, though, is that if you've already got something else
> keeping track of the actual addresses, then the way you're using an
> iova_domain appears to be something you could do with a trivial bitmap
> allocator. That's why I don't buy the efficiency argument. The main
> design points of the IOVA allocator are to manage large address spaces
> while trying to maximise spatial locality to minimise the underlying
> pagetable usage, and allocating with a flexible limit to support
> multiple devices with different addressing capabilities in the same
> address space. If none of those aspects are relevant to the use-case -
> which AFAICS appears to be true here - then as a general-purpose
> resource allocator it's rubbish and has an unreasonably massive memory
> overhead and there are many, many better choices.
>

OK, I get your point. Actually we used the genpool allocator in the
early version. Maybe we can fall back to using it.

> FWIW I've recently started thinking about moving all the caching stuff
> out of iova_domain and into the iommu-dma layer since it's now a giant
> waste of space for all the other current IOVA users.
>
> >> Presumably userspace doesn't have any concern about alignment and the
> >> things we have to worry about for the DMA API in general, so it's pret=
ty
> >> much just allocating slots in a buffer, and there are far more effecti=
ve
> >> ways to do that than a full-blown address space manager.
> >
> > Considering iova allocation efficiency, I think the iova allocator is
> > better here. In most cases, we don't even need to hold a spin lock
> > during iova allocation.
> >
> >> If you're going
> >> to reuse any infrastructure I'd have expected it to be SWIOTLB rather
> >> than the IOVA allocator. Because, y'know, you're *literally implementi=
ng
> >> a software I/O TLB* ;)
> >>
> >
> > But actually what we can reuse in SWIOTLB is the IOVA allocator.
>
> Huh? Those are completely unrelated and orthogonal things - SWIOTLB does
> not use an external allocator (see find_slots()). By SWIOTLB I mean
> specifically the library itself, not dma-direct or any of the other
> users built around it. The functionality for managing slots in a buffer
> and bouncing data in and out can absolutely be reused - that's why users
> like the Xen and iommu-dma code *are* reusing it instead of open-coding
> their own versions.
>

I see. Actually the slots management in SWIOTLB is what I mean by IOVA
allocator.

> > And
> > the IOVA management in SWIOTLB is not what we want. For example,
> > SWIOTLB allocates and uses contiguous memory for bouncing, which is
> > not necessary in VDUSE case.
>
> alloc_iova() allocates a contiguous (in IOVA address) region of space.
> In vduse_domain_map_page() you use it to allocate a contiguous region of
> space from your bounce buffer. Can you clarify how that is fundamentally
> different from allocating a contiguous region of space from a bounce
> buffer? Nobody's saying the underlying implementation details of where
> the buffer itself comes from can't be tweaked.
>

I mean physically contiguous memory here. We can currently allocate
the bounce pages one by one rather than allocating a bunch of
physically contiguous memory at once which is not friendly to a
userspace device.

> > And VDUSE needs coherent mapping which is
> > not supported by the SWIOTLB. Besides, the SWIOTLB works in singleton
> > mode (designed for platform IOMMU) , but VDUSE is based on on-chip
> > IOMMU (supports multiple instances).
> That's not entirely true - the IOMMU bounce buffering scheme introduced
> in intel-iommu and now moved into the iommu-dma layer was already a step
> towards something conceptually similar. It does still rely on stealing
> the underlying pages from the global SWIOTLB pool at the moment, but the
> bouncing is effectively done in a per-IOMMU-domain context.
>
> The next step is currently queued in linux-next, wherein we can now have
> individual per-device SWIOTLB pools. In fact at that point I think you
> might actually be able to do your thing without implementing any special
> DMA ops at all - you'd need to set up a pool for your "device" with
> force_bounce set, then when you mmap() that to userspace, set up
> dev->dma_range_map to describe an offset from the physical address of
> the buffer to the userspace address, and I think dma-direct would be
> tricked into doing the right thing. It's a bit wacky, but it could stand
> to save a hell of a lot of bother.
>

Cool! I missed this work, sorry. But it looks like its current version
can't meet our needs (e.g. avoid using physically contiguous memory).
So I'd like to consider it as a follow-up optimization and use a
general IOVA allocator in this initial version. The IOVA allocator
would be still needed for coherent mapping
(vduse_domain_alloc_coherent() and vduse_domain_free_coherent()) after
we reuse the SWIOTLB.

> Finally, enhancing SWIOTLB to cope with virtually-mapped buffers that
> don't have to be physically contiguous is a future improvement which I
> think could benefit various use-cases - indeed it's possibly already on
> the table for IOMMU bounce pages - so would probably be welcome in genera=
l.
>

Yes, it's indeed needed by VDUSE. But I'm not sure if it would be
needed by other drivers. Looks like we need swiotlb_tbl_map_single()
to return a virtual address and introduce some way to let the caller
do some translation between VA to PA.

Thanks,
Yongji
