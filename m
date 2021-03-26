Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E88A34A0CD
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 06:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhCZFPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 01:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbhCZFO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 01:14:56 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A270DC0613B0
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 22:14:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u21so6477919ejo.13
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 22:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OmwLO9vwtq0vP6FGf68sJX/wnflcZh+14wt3KK+6I8o=;
        b=LkAGEmAA9jHGatA5l2XIeJoq8tJh6NoCRbKa+Z1k4b6/fRgrRYT/YNOAbzAk06Jiyi
         iFm3WXmvz6H8OeaUCLqVCAVDsxhAxY6p1DXIF+2TYj23SeVV8JZddY8V6xXEQ70yhubD
         5nZ0JSc6PCw1HVIJvRUK2QQlrh3nuLK7BwGhfpyN4E9gmImaOFsMe+1GmOw4pn96EKHz
         /ABMgWPRao8Ebk52TaXBCQ8C8vFSCaCFS4aKfOSwvd81FmBUqdO+/onPJhcAkyUcez+T
         WQ/5103uQQFv4Amhez+ZFQawhok5dw1Xgvp+p+1uLXs0RoqYHe6eSnNj9BfQjt3w+IGO
         hF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OmwLO9vwtq0vP6FGf68sJX/wnflcZh+14wt3KK+6I8o=;
        b=CpfNyrgbI5lnrWk/IoB9MZFuvzaNs+TRtJtHmZJ3nAms0NrNroRFZpdTHEMy7uuyrJ
         61T07Yg4TdOuEXJYUstxdoeSCT7WugOu8s9i5eLJTxEqvrbKKt2PUIyNyZKr3lYZ10gO
         vuPMBrSCL1GXpUmiVJKdiqPDCbbOtXeV0mWP7WbCt9nJUzgLZXoO7dJ77bGjTkBiXYpl
         G7m2QK7XPmDPXAZ7GytKwECJF1pfxQTg6SF0v4BUlxUpcnPDPKsRM54qlYeRhBW8FBcK
         1U25cihiLovU5M+NleoZQND5jRiYTDa5CMhVBzeu5uGjLXLGJxys0lQXqJXsOrzDzi1g
         F8kQ==
X-Gm-Message-State: AOAM5310/+SHCxiRPJowrpYJCSq0kXJpyREMOS8ZeYyUdYD4AVmekJPW
        ECACwRnJiSoG5fW6dnRTupP0VnyRSq/QjcGuIJ4e5bxHZA==
X-Google-Smtp-Source: ABdhPJw2/p/ISKUYKtQcsmlAWp1VJRiF5UAiXzMI7WXna6aALU0o5ALqjBhK098VirnkkSYaNAwI97dtz7BQsNsB2uY=
X-Received: by 2002:a17:906:489b:: with SMTP id v27mr13207285ejq.1.1616735679250;
 Thu, 25 Mar 2021 22:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-9-xieyongji@bytedance.com>
 <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com> <CACycT3v_-G6ju-poofXEzYt8QPKWNFHwsS7t=KTLgs-=g+iPQQ@mail.gmail.com>
 <7c90754b-681d-f3bf-514c-756abfcf3d23@redhat.com> <CACycT3uS870yy04rw7KBk==sioi+VNunxVz6BQH-Lmxk6m-VSg@mail.gmail.com>
 <2db71996-037e-494d-6ef0-de3ff164d3c3@redhat.com>
In-Reply-To: <2db71996-037e-494d-6ef0-de3ff164d3c3@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 26 Mar 2021 13:14:28 +0800
Message-ID: <CACycT3v6Lj61fafztOuzBNFLs2TbKeqrNLXkzv5RK6-h-iTnvA@mail.gmail.com>
Subject: Re: Re: [PATCH v5 08/11] vduse: Implement an MMU-based IOMMU driver
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 12:27 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/25 =E4=B8=8B=E5=8D=883:38, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Thu, Mar 25, 2021 at 12:53 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/3/24 =E4=B8=8B=E5=8D=883:39, Yongji Xie =E5=86=99=E9=81=
=93:
> >>> On Wed, Mar 24, 2021 at 11:54 AM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=
=81=93:
> >>>>> This implements an MMU-based IOMMU driver to support mapping
> >>>>> kernel dma buffer into userspace. The basic idea behind it is
> >>>>> treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
> >>>>> up MMU mapping instead of IOMMU mapping for the DMA transfer so
> >>>>> that the userspace process is able to use its virtual address to
> >>>>> access the dma buffer in kernel.
> >>>>>
> >>>>> And to avoid security issue, a bounce-buffering mechanism is
> >>>>> introduced to prevent userspace accessing the original buffer
> >>>>> directly.
> >>>>>
> >>>>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>>>> ---
> >>>>>     drivers/vdpa/vdpa_user/iova_domain.c | 535 ++++++++++++++++++++=
+++++++++++++++
> >>>>>     drivers/vdpa/vdpa_user/iova_domain.h |  75 +++++
> >>>>>     2 files changed, 610 insertions(+)
> >>>>>     create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >>>>>     create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >>>>>
> >>>>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vd=
pa_user/iova_domain.c
> >>>>> new file mode 100644
> >>>>> index 000000000000..83de216b0e51
> >>>>> --- /dev/null
> >>>>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> >>>>> @@ -0,0 +1,535 @@
> >>>>> +// SPDX-License-Identifier: GPL-2.0-only
> >>>>> +/*
> >>>>> + * MMU-based IOMMU implementation
> >>>>> + *
> >>>>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All ri=
ghts reserved.
> >>>> 2021 as well.
> >>>>
> >>> Sure.
> >>>
> >>>>> + *
> >>>>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>>>> + *
> >>>>> + */
> >>>>> +
> >>>>> +#include <linux/slab.h>
> >>>>> +#include <linux/file.h>
> >>>>> +#include <linux/anon_inodes.h>
> >>>>> +#include <linux/highmem.h>
> >>>>> +#include <linux/vmalloc.h>
> >>>>> +#include <linux/vdpa.h>
> >>>>> +
> >>>>> +#include "iova_domain.h"
> >>>>> +
> >>>>> +static int vduse_iotlb_add_range(struct vduse_iova_domain *domain,
> >>>>> +                              u64 start, u64 last,
> >>>>> +                              u64 addr, unsigned int perm,
> >>>>> +                              struct file *file, u64 offset)
> >>>>> +{
> >>>>> +     struct vdpa_map_file *map_file;
> >>>>> +     int ret;
> >>>>> +
> >>>>> +     map_file =3D kmalloc(sizeof(*map_file), GFP_ATOMIC);
> >>>>> +     if (!map_file)
> >>>>> +             return -ENOMEM;
> >>>>> +
> >>>>> +     map_file->file =3D get_file(file);
> >>>>> +     map_file->offset =3D offset;
> >>>>> +
> >>>>> +     ret =3D vhost_iotlb_add_range_ctx(domain->iotlb, start, last,
> >>>>> +                                     addr, perm, map_file);
> >>>>> +     if (ret) {
> >>>>> +             fput(map_file->file);
> >>>>> +             kfree(map_file);
> >>>>> +             return ret;
> >>>>> +     }
> >>>>> +     return 0;
> >>>>> +}
> >>>>> +
> >>>>> +static void vduse_iotlb_del_range(struct vduse_iova_domain *domain=
,
> >>>>> +                               u64 start, u64 last)
> >>>>> +{
> >>>>> +     struct vdpa_map_file *map_file;
> >>>>> +     struct vhost_iotlb_map *map;
> >>>>> +
> >>>>> +     while ((map =3D vhost_iotlb_itree_first(domain->iotlb, start,=
 last))) {
> >>>>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>>>> +             fput(map_file->file);
> >>>>> +             kfree(map_file);
> >>>>> +             vhost_iotlb_map_free(domain->iotlb, map);
> >>>>> +     }
> >>>>> +}
> >>>>> +
> >>>>> +int vduse_domain_set_map(struct vduse_iova_domain *domain,
> >>>>> +                      struct vhost_iotlb *iotlb)
> >>>>> +{
> >>>>> +     struct vdpa_map_file *map_file;
> >>>>> +     struct vhost_iotlb_map *map;
> >>>>> +     u64 start =3D 0ULL, last =3D ULLONG_MAX;
> >>>>> +     int ret;
> >>>>> +
> >>>>> +     spin_lock(&domain->iotlb_lock);
> >>>>> +     vduse_iotlb_del_range(domain, start, last);
> >>>>> +
> >>>>> +     for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map=
;
> >>>>> +          map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>>>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>>>> +             ret =3D vduse_iotlb_add_range(domain, map->start, map=
->last,
> >>>>> +                                         map->addr, map->perm,
> >>>>> +                                         map_file->file,
> >>>>> +                                         map_file->offset);
> >>>>> +             if (ret)
> >>>>> +                     goto err;
> >>>>> +     }
> >>>>> +     spin_unlock(&domain->iotlb_lock);
> >>>>> +
> >>>>> +     return 0;
> >>>>> +err:
> >>>>> +     vduse_iotlb_del_range(domain, start, last);
> >>>>> +     spin_unlock(&domain->iotlb_lock);
> >>>>> +     return ret;
> >>>>> +}
> >>>>> +
> >>>>> +static void vduse_domain_map_bounce_page(struct vduse_iova_domain =
*domain,
> >>>>> +                                      u64 iova, u64 size, u64 padd=
r)
> >>>>> +{
> >>>>> +     struct vduse_bounce_map *map;
> >>>>> +     unsigned int index;
> >>>>> +     u64 last =3D iova + size - 1;
> >>>>> +
> >>>>> +     while (iova < last) {
> >>>>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>>>> +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> >>>>> +             map->orig_phys[index] =3D paddr;
> >>>>> +             paddr +=3D IOVA_ALLOC_SIZE;
> >>>>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>>>> +     }
> >>>>> +}
> >>>>> +
> >>>>> +static void vduse_domain_unmap_bounce_page(struct vduse_iova_domai=
n *domain,
> >>>>> +                                        u64 iova, u64 size)
> >>>>> +{
> >>>>> +     struct vduse_bounce_map *map;
> >>>>> +     unsigned int index;
> >>>>> +     u64 last =3D iova + size - 1;
> >>>>> +
> >>>>> +     while (iova < last) {
> >>>>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>>>> +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> >>>>> +             map->orig_phys[index] =3D INVALID_PHYS_ADDR;
> >>>>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>>>> +     }
> >>>>> +}
> >>>>> +
> >>>>> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> >>>>> +                   enum dma_data_direction dir)
> >>>>> +{
> >>>>> +     unsigned long pfn =3D PFN_DOWN(orig);
> >>>>> +
> >>>>> +     if (PageHighMem(pfn_to_page(pfn))) {
> >>>>> +             unsigned int offset =3D offset_in_page(orig);
> >>>>> +             char *buffer;
> >>>>> +             unsigned int sz =3D 0;
> >>>>> +
> >>>>> +             while (size) {
> >>>>> +                     sz =3D min_t(size_t, PAGE_SIZE - offset, size=
);
> >>>>> +
> >>>>> +                     buffer =3D kmap_atomic(pfn_to_page(pfn));
> >>>> So kmap_atomic() can autoamtically go with fast path if the page doe=
s
> >>>> not belong to highmem.
> >>>>
> >>>> I think we can removce the condition and just use kmap_atomic() for =
all
> >>>> the cases here.
> >>>>
> >>> Looks good to me.
> >>>
> >>>>> +                     if (dir =3D=3D DMA_TO_DEVICE)
> >>>>> +                             memcpy(addr, buffer + offset, sz);
> >>>>> +                     else
> >>>>> +                             memcpy(buffer + offset, addr, sz);
> >>>>> +                     kunmap_atomic(buffer);
> >>>>> +
> >>>>> +                     size -=3D sz;
> >>>>> +                     pfn++;
> >>>>> +                     addr +=3D sz;
> >>>>> +                     offset =3D 0;
> >>>>> +             }
> >>>>> +     } else if (dir =3D=3D DMA_TO_DEVICE) {
> >>>>> +             memcpy(addr, phys_to_virt(orig), size);
> >>>>> +     } else {
> >>>>> +             memcpy(phys_to_virt(orig), addr, size);
> >>>>> +     }
> >>>>> +}
> >>>>> +
> >>>>> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> >>>>> +                             dma_addr_t iova, size_t size,
> >>>>> +                             enum dma_data_direction dir)
> >>>>> +{
> >>>>> +     struct vduse_bounce_map *map;
> >>>>> +     unsigned int index, offset;
> >>>>> +     void *addr;
> >>>>> +     size_t sz;
> >>>>> +
> >>>>> +     while (size) {
> >>>>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>>>> +             offset =3D offset_in_page(iova);
> >>>>> +             sz =3D min_t(size_t, IOVA_ALLOC_SIZE, size);
> >>>>> +
> >>>>> +             if (map->bounce_page &&
> >>>>> +                 map->orig_phys[index] !=3D INVALID_PHYS_ADDR) {
> >>>>> +                     addr =3D page_address(map->bounce_page) + off=
set;
> >>>>> +                     index =3D offset >> IOVA_ALLOC_ORDER;
> >>>>> +                     do_bounce(map->orig_phys[index], addr, sz, di=
r);
> >>>>> +             }
> >>>>> +             size -=3D sz;
> >>>>> +             iova +=3D sz;
> >>>>> +     }
> >>>>> +}
> >>>>> +
> >>>>> +static struct page *
> >>>>> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u6=
4 iova)
> >>>>> +{
> >>>>> +     u64 start =3D iova & PAGE_MASK;
> >>>>> +     u64 last =3D start + PAGE_SIZE - 1;
> >>>>> +     struct vhost_iotlb_map *map;
> >>>>> +     struct page *page =3D NULL;
> >>>>> +
> >>>>> +     spin_lock(&domain->iotlb_lock);
> >>>>> +     map =3D vhost_iotlb_itree_first(domain->iotlb, start, last);
> >>>>> +     if (!map)
> >>>>> +             goto out;
> >>>>> +
> >>>>> +     page =3D pfn_to_page((map->addr + iova - map->start) >> PAGE_=
SHIFT);
> >>>>> +     get_page(page);
> >>>>> +out:
> >>>>> +     spin_unlock(&domain->iotlb_lock);
> >>>>> +
> >>>>> +     return page;
> >>>>> +}
> >>>>> +
> >>>>> +static struct page *
> >>>>> +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u=
64 iova)
> >>>>> +{
> >>>>> +     u64 start =3D iova & PAGE_MASK;
> >>>>> +     struct page *page =3D alloc_page(GFP_KERNEL);
> >>>>> +     struct vduse_bounce_map *map;
> >>>>> +
> >>>>> +     if (!page)
> >>>>> +             return NULL;
> >>>>> +
> >>>>> +     spin_lock(&domain->iotlb_lock);
> >>>>> +     map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>>>> +     if (map->bounce_page) {
> >>>>> +             __free_page(page);
> >>>>> +             goto out;
> >>>>> +     }
> >>>>> +     map->bounce_page =3D page;
> >>>>> +
> >>>>> +     /* paired with vduse_domain_map_page() */
> >>>>> +     smp_mb();
> >>>> So this is suspicious. It's better to explain like, we need make sur=
e A
> >>>> must be done after B.
> >>> OK. I see. It's used to protect this pattern:
> >>>
> >>>      vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
> >>>      write map->bounce_page                           write map->orig=
_phys
> >>>      mb()                                                            =
mb()
> >>>      read map->orig_phys                                 read map->bo=
unce_page
> >>>
> >>> Make sure there will always be a path to do bouncing.
> >>
> >> Ok.
> >>
> >>
> >>>> And it looks to me the iotlb_lock is sufficnet to do the synchroniza=
tion
> >>>> here. E.g any reason that you don't take it in
> >>>> vduse_domain_map_bounce_page().
> >>>>
> >>> Yes, we can. But the performance in multi-queue cases will go down if
> >>> we use iotlb_lock on this critical path.
> >>>
> >>>> And what's more, is there anyway to aovid holding the spinlock durin=
g
> >>>> bouncing?
> >>>>
> >>> Looks like we can't. In the case that multiple page faults happen on
> >>> the same page, we should make sure the bouncing is done before any
> >>> page fault handler returns.
> >>
> >> So it looks to me all those extra complexitiy comes from the fact that
> >> the bounce_page and orig_phys are set by different places so we need t=
o
> >> do the bouncing in two places.
> >>
> >> I wonder how much we can gain from the "lazy" boucning in page fault.
> >> The buffer mapped via dma_ops from virtio driver is expected to be
> >> accessed by the userspace soon.  It looks to me we can do all those
> >> stuffs during dma_map() then things would be greatly simplified.
> >>
> > If so, we need to allocate lots of pages from the pool reserved for
> > atomic memory allocation requests.
>
>
> This should be fine, a lot of drivers tries to allocate pages in atomic
> context. The point is to simplify the codes to make it easy to
> determince the correctness so we can add optimization on top simply by
> benchmarking the difference.
>

OK. I will use this way in the next version.

> E.g we have serveral places that accesses orig_phys:
>
> 1) map_page(), write
> 2) unmap_page(), write
> 3) page fault handler, read
>
> It's not clear to me how they were synchronized. Or if it was
> synchronzied implicitly (via iova allocator?), we'd better document it.

Yes.

> Or simply use spinlock (which is the preferrable way I'd like to go). We
> probably don't need to worry too much about the cost of spinlock since
> iova allocater use it heavily.
>

Actually iova allocator implements a per-CPU cache to optimize it.

Thanks,
Yongji
