Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09EC532E20E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhCEGQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbhCEGQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:16:06 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310C4C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 22:16:05 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id mj10so1250782ejb.5
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 22:16:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2r5mbSRyoXAewszjMGj565GfUE72iMkjIn8I/oNBuuc=;
        b=dfZ3eW95hpLoy9Q6M25djC9VBeOtTfnnrP91YC4Kzl0n33V3azmi7pNvAaNs1ZvClL
         xOEd63DYB7zz8CcfGjZb61FQjX9at2N+ZcH8GLgo/qOa/WV+ob/NbUSoNgw+6aVA0l4j
         EcObSyHV10kKJ60solXCsWs3ya2y+isWFarPiSgxryVS9awUP/t4I/hO2bBw2GIwclCy
         4qwKYNvpdXXjt32MZm+RApNuv1qJPs+EkHEomNMF6RHeM+FavgryoIJgETqms1tX0Z/X
         AjjmwYXYr3WEkzzG4/fUy0g5zAofpDqXCdrK5FN5OOzYT0BZ9t6NBDF4KFK2Odr7SmtZ
         WCZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2r5mbSRyoXAewszjMGj565GfUE72iMkjIn8I/oNBuuc=;
        b=SHZ9nio5oT/0wOwoZ/CZBEkXY9V3ACGlbazLZ1km49E8sCIw01DCUQu1c8yxBx9x30
         NqnkCdll3Xupbpwy440UUdeJbKKXVwyqQ7MPIVj3R9DOdyUx/fMIvCrP1OLspdHM4Efv
         lp6mIeAaAtPQNvlNChLiDjUawNqiW/B/Vh6nXAoOu4iTboAjavzdI51ExbFg6ObENa2t
         jR8pV7Bkqod3PpvfaAQ2jTKG3D8d1lZ+wMdB4y7VBEgyZ4lymZWFf1v0x1tJtwK0tUlu
         1O+ZQKTCv1tlrUsHDnekyRahK/cgh+a1uLLjAudq6PhKnauBPlHsNSIG8WdgXbYzdx79
         WLZw==
X-Gm-Message-State: AOAM531xt8+CIxrO96rKfXgNFNcO35mZW0ip19eREcqCOjNPOTi/ge2c
        tPqOYSaleIhti2rug+KpP5yJ9RPPcmEhnJxJz5Eh
X-Google-Smtp-Source: ABdhPJynJS3Fn8JWBDfVhJa/VhX3aSWrzR2SbL/BOJnAl2r3NdW7YraYvvxkw124MYDT8lLuwNx04lkHOqy8KqYFTuU=
X-Received: by 2002:a17:906:128e:: with SMTP id k14mr912636ejb.427.1614924963771;
 Thu, 04 Mar 2021 22:16:03 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-7-xieyongji@bytedance.com>
 <573ab913-55ce-045a-478f-1200bd78cf7b@redhat.com> <CACycT3sVhDKKu4zGbt1Lw-uWfKDAWs=O=C7kXXcuSnePohmBdQ@mail.gmail.com>
 <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com>
In-Reply-To: <c173b7ec-8c90-d0e3-7272-a56aa8935e64@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 14:15:52 +0800
Message-ID: <CACycT3vb=WyrMpiOOdVDGEh8cEDb-xaj1esQx2UEQpJnOOWhmw@mail.gmail.com>
Subject: Re: Re: [RFC v4 06/11] vduse: Implement an MMU-based IOMMU driver
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
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 11:36 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/4 1:12 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Thu, Mar 4, 2021 at 12:21 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>> This implements a MMU-based IOMMU driver to support mapping
> >>> kernel dma buffer into userspace. The basic idea behind it is
> >>> treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
> >>> up MMU mapping instead of IOMMU mapping for the DMA transfer so
> >>> that the userspace process is able to use its virtual address to
> >>> access the dma buffer in kernel.
> >>>
> >>> And to avoid security issue, a bounce-buffering mechanism is
> >>> introduced to prevent userspace accessing the original buffer
> >>> directly.
> >>>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    drivers/vdpa/vdpa_user/iova_domain.c | 486 +++++++++++++++++++++++=
++++++++++++
> >>>    drivers/vdpa/vdpa_user/iova_domain.h |  61 +++++
> >>>    2 files changed, 547 insertions(+)
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >>>
> >>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa=
_user/iova_domain.c
> >>> new file mode 100644
> >>> index 000000000000..9285d430d486
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> >>> @@ -0,0 +1,486 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * MMU-based IOMMU implementation
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/slab.h>
> >>> +#include <linux/file.h>
> >>> +#include <linux/anon_inodes.h>
> >>> +#include <linux/highmem.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +#define IOVA_START_PFN 1
> >>> +#define IOVA_ALLOC_ORDER 12
> >>> +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> >>> +
> >>> +static inline struct page *
> >>> +vduse_domain_get_bounce_page(struct vduse_iova_domain *domain, u64 i=
ova)
> >>> +{
> >>> +     u64 index =3D iova >> PAGE_SHIFT;
> >>> +
> >>> +     return domain->bounce_pages[index];
> >>> +}
> >>> +
> >>> +static inline void
> >>> +vduse_domain_set_bounce_page(struct vduse_iova_domain *domain,
> >>> +                             u64 iova, struct page *page)
> >>> +{
> >>> +     u64 index =3D iova >> PAGE_SHIFT;
> >>> +
> >>> +     domain->bounce_pages[index] =3D page;
> >>> +}
> >>> +
> >>> +static enum dma_data_direction perm_to_dir(int perm)
> >>> +{
> >>> +     enum dma_data_direction dir;
> >>> +
> >>> +     switch (perm) {
> >>> +     case VHOST_MAP_WO:
> >>> +             dir =3D DMA_FROM_DEVICE;
> >>> +             break;
> >>> +     case VHOST_MAP_RO:
> >>> +             dir =3D DMA_TO_DEVICE;
> >>> +             break;
> >>> +     case VHOST_MAP_RW:
> >>> +             dir =3D DMA_BIDIRECTIONAL;
> >>> +             break;
> >>> +     default:
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return dir;
> >>> +}
> >>> +
> >>> +static int dir_to_perm(enum dma_data_direction dir)
> >>> +{
> >>> +     int perm =3D -EFAULT;
> >>> +
> >>> +     switch (dir) {
> >>> +     case DMA_FROM_DEVICE:
> >>> +             perm =3D VHOST_MAP_WO;
> >>> +             break;
> >>> +     case DMA_TO_DEVICE:
> >>> +             perm =3D VHOST_MAP_RO;
> >>> +             break;
> >>> +     case DMA_BIDIRECTIONAL:
> >>> +             perm =3D VHOST_MAP_RW;
> >>> +             break;
> >>> +     default:
> >>> +             break;
> >>> +     }
> >>> +
> >>> +     return perm;
> >>> +}
> >>
> >> Let's move the above two helpers to vhost_iotlb.h so they could be use=
d
> >> by other driver e.g (vpda_sim)
> >>
> > Sure.
> >
> >>> +
> >>> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> >>> +                     enum dma_data_direction dir)
> >>> +{
> >>> +     unsigned long pfn =3D PFN_DOWN(orig);
> >>> +
> >>> +     if (PageHighMem(pfn_to_page(pfn))) {
> >>> +             unsigned int offset =3D offset_in_page(orig);
> >>> +             char *buffer;
> >>> +             unsigned int sz =3D 0;
> >>> +             unsigned long flags;
> >>> +
> >>> +             while (size) {
> >>> +                     sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> >>> +
> >>> +                     local_irq_save(flags);
> >>> +                     buffer =3D kmap_atomic(pfn_to_page(pfn));
> >>> +                     if (dir =3D=3D DMA_TO_DEVICE)
> >>> +                             memcpy(addr, buffer + offset, sz);
> >>> +                     else
> >>> +                             memcpy(buffer + offset, addr, sz);
> >>> +                     kunmap_atomic(buffer);
> >>> +                     local_irq_restore(flags);
> >>
> >> I wonder why we need to deal with highmem and irq flags explicitly lik=
e
> >> this. Doesn't kmap_atomic() will take care all of those?
> >>
> > Yes, irq flags is useless here. Will remove it.
> >
> >>> +
> >>> +                     size -=3D sz;
> >>> +                     pfn++;
> >>> +                     addr +=3D sz;
> >>> +                     offset =3D 0;
> >>> +             }
> >>> +     } else if (dir =3D=3D DMA_TO_DEVICE) {
> >>> +             memcpy(addr, phys_to_virt(orig), size);
> >>> +     } else {
> >>> +             memcpy(phys_to_virt(orig), addr, size);
> >>> +     }
> >>> +}
> >>> +
> >>> +static struct page *
> >>> +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 =
iova)
> >>> +{
> >>> +     u64 start =3D iova & PAGE_MASK;
> >>> +     u64 last =3D start + PAGE_SIZE - 1;
> >>> +     struct vhost_iotlb_map *map;
> >>> +     struct page *page =3D NULL;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     map =3D vhost_iotlb_itree_first(domain->iotlb, start, last);
> >>> +     if (!map)
> >>> +             goto out;
> >>> +
> >>> +     page =3D pfn_to_page((map->addr + iova - map->start) >> PAGE_SH=
IFT);
> >>> +     get_page(page);
> >>> +out:
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +
> >>> +     return page;
> >>> +}
> >>> +
> >>> +static struct page *
> >>> +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u64=
 iova)
> >>> +{
> >>> +     u64 start =3D iova & PAGE_MASK;
> >>> +     u64 last =3D start + PAGE_SIZE - 1;
> >>> +     struct vhost_iotlb_map *map;
> >>> +     struct page *page =3D NULL, *new_page =3D alloc_page(GFP_KERNEL=
);
> >>> +
> >>> +     if (!new_page)
> >>> +             return NULL;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     if (!vhost_iotlb_itree_first(domain->iotlb, start, last)) {
> >>> +             __free_page(new_page);
> >>> +             goto out;
> >>> +     }
> >>> +     page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +     if (page) {
> >>> +             get_page(page);
> >>> +             __free_page(new_page);
> >>> +             goto out;
> >>> +     }
> >>> +     vduse_domain_set_bounce_page(domain, iova, new_page);
> >>> +     get_page(new_page);
> >>> +     page =3D new_page;
> >>> +
> >>> +     for (map =3D vhost_iotlb_itree_first(domain->iotlb, start, last=
); map;
> >>> +          map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>> +             unsigned int src_offset =3D 0, dst_offset =3D 0;
> >>> +             phys_addr_t src;
> >>> +             void *dst;
> >>> +             size_t sz;
> >>> +
> >>> +             if (perm_to_dir(map->perm) =3D=3D DMA_FROM_DEVICE)
> >>> +                     continue;
> >>> +
> >>> +             if (start > map->start)
> >>> +                     src_offset =3D start - map->start;
> >>> +             else
> >>> +                     dst_offset =3D map->start - start;
> >>> +
> >>> +             src =3D map->addr + src_offset;
> >>> +             dst =3D page_address(page) + dst_offset;
> >>> +             sz =3D min_t(size_t, map->size - src_offset,
> >>> +                             PAGE_SIZE - dst_offset);
> >>> +             do_bounce(src, dst, sz, DMA_TO_DEVICE);
> >>> +     }
> >>> +out:
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +
> >>> +     return page;
> >>> +}
> >>> +
> >>> +static void
> >>> +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain,
> >>> +                             u64 iova, size_t size)
> >>> +{
> >>> +     struct page *page;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     if (WARN_ON(vhost_iotlb_itree_first(domain->iotlb, iova,
> >>> +                                             iova + size - 1)))
> >>> +             goto out;
> >>> +
> >>> +     while (size > 0) {
> >>> +             page =3D vduse_domain_get_bounce_page(domain, iova);
> >>> +             if (page) {
> >>> +                     vduse_domain_set_bounce_page(domain, iova, NULL=
);
> >>> +                     __free_page(page);
> >>> +             }
> >>> +             size -=3D PAGE_SIZE;
> >>> +             iova +=3D PAGE_SIZE;
> >>> +     }
> >>> +out:
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +}
> >>> +
> >>> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> >>> +                             dma_addr_t iova, phys_addr_t orig,
> >>> +                             size_t size, enum dma_data_direction di=
r)
> >>> +{
> >>> +     unsigned int offset =3D offset_in_page(iova);
> >>> +
> >>> +     while (size) {
> >>> +             struct page *p =3D vduse_domain_get_bounce_page(domain,=
 iova);
> >>> +             size_t sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> >>> +
> >>> +             WARN_ON(!p && dir =3D=3D DMA_FROM_DEVICE);
> >>> +
> >>> +             if (p)
> >>> +                     do_bounce(orig, page_address(p) + offset, sz, d=
ir);
> >>> +
> >>> +             size -=3D sz;
> >>> +             orig +=3D sz;
> >>> +             iova +=3D sz;
> >>> +             offset =3D 0;
> >>> +     }
> >>> +}
> >>> +
> >>> +static dma_addr_t vduse_domain_alloc_iova(struct iova_domain *iovad,
> >>> +                             unsigned long size, unsigned long limit=
)
> >>> +{
> >>> +     unsigned long shift =3D iova_shift(iovad);
> >>> +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> >>> +     unsigned long iova_pfn;
> >>> +
> >>> +     if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> >>> +             iova_len =3D roundup_pow_of_two(iova_len);
> >>> +     iova_pfn =3D alloc_iova_fast(iovad, iova_len, limit >> shift, t=
rue);
> >>> +
> >>> +     return iova_pfn << shift;
> >>> +}
> >>> +
> >>> +static void vduse_domain_free_iova(struct iova_domain *iovad,
> >>> +                             dma_addr_t iova, size_t size)
> >>> +{
> >>> +     unsigned long shift =3D iova_shift(iovad);
> >>> +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> >>> +
> >>> +     free_iova_fast(iovad, iova >> shift, iova_len);
> >>> +}
> >>> +
> >>> +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> >>> +                             struct page *page, unsigned long offset=
,
> >>> +                             size_t size, enum dma_data_direction di=
r,
> >>> +                             unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->stream_iovad;
> >>> +     unsigned long limit =3D domain->bounce_size - 1;
> >>> +     phys_addr_t pa =3D page_to_phys(page) + offset;
> >>> +     dma_addr_t iova =3D vduse_domain_alloc_iova(iovad, size, limit)=
;
> >>> +     int ret;
> >>> +
> >>> +     if (!iova)
> >>> +             return DMA_MAPPING_ERROR;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     ret =3D vhost_iotlb_add_range(domain->iotlb, (u64)iova,
> >>> +                                 (u64)iova + size - 1,
> >>> +                                 pa, dir_to_perm(dir));
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +     if (ret) {
> >>> +             vduse_domain_free_iova(iovad, iova, size);
> >>> +             return DMA_MAPPING_ERROR;
> >>> +     }
> >>> +     if (dir =3D=3D DMA_TO_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> >>> +             vduse_domain_bounce(domain, iova, pa, size, DMA_TO_DEVI=
CE);
> >>> +
> >>> +     return iova;
> >>> +}
> >>> +
> >>> +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> >>> +                     dma_addr_t dma_addr, size_t size,
> >>> +                     enum dma_data_direction dir, unsigned long attr=
s)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->stream_iovad;
> >>> +     struct vhost_iotlb_map *map;
> >>> +     phys_addr_t pa;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     map =3D vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> >>> +                                   (u64)dma_addr + size - 1);
> >>> +     if (WARN_ON(!map)) {
> >>> +             spin_unlock(&domain->iotlb_lock);
> >>> +             return;
> >>> +     }
> >>> +     pa =3D map->addr;
> >>> +     vhost_iotlb_map_free(domain->iotlb, map);
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +
> >>> +     if (dir =3D=3D DMA_FROM_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> >>> +             vduse_domain_bounce(domain, dma_addr, pa,
> >>> +                                     size, DMA_FROM_DEVICE);
> >>> +
> >>> +     vduse_domain_free_iova(iovad, dma_addr, size);
> >>> +}
> >>> +
> >>> +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> >>> +                             size_t size, dma_addr_t *dma_addr,
> >>> +                             gfp_t flag, unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> >>> +     unsigned long limit =3D domain->iova_limit;
> >>> +     dma_addr_t iova =3D vduse_domain_alloc_iova(iovad, size, limit)=
;
> >>> +     void *orig =3D alloc_pages_exact(size, flag);
> >>> +     int ret;
> >>> +
> >>> +     if (!iova || !orig)
> >>> +             goto err;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     ret =3D vhost_iotlb_add_range(domain->iotlb, (u64)iova,
> >>> +                                 (u64)iova + size - 1,
> >>> +                                 virt_to_phys(orig), VHOST_MAP_RW);
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +     if (ret)
> >>> +             goto err;
> >>> +
> >>> +     *dma_addr =3D iova;
> >>> +
> >>> +     return orig;
> >>> +err:
> >>> +     *dma_addr =3D DMA_MAPPING_ERROR;
> >>> +     if (orig)
> >>> +             free_pages_exact(orig, size);
> >>> +     if (iova)
> >>> +             vduse_domain_free_iova(iovad, iova, size);
> >>> +
> >>> +     return NULL;
> >>> +}
> >>> +
> >>> +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, si=
ze_t size,
> >>> +                             void *vaddr, dma_addr_t dma_addr,
> >>> +                             unsigned long attrs)
> >>> +{
> >>> +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> >>> +     struct vhost_iotlb_map *map;
> >>> +     phys_addr_t pa;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     map =3D vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> >>> +                                   (u64)dma_addr + size - 1);
> >>> +     if (WARN_ON(!map)) {
> >>> +             spin_unlock(&domain->iotlb_lock);
> >>> +             return;
> >>> +     }
> >>> +     pa =3D map->addr;
> >>> +     vhost_iotlb_map_free(domain->iotlb, map);
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +
> >>> +     vduse_domain_free_iova(iovad, dma_addr, size);
> >>> +     free_pages_exact(phys_to_virt(pa), size);
> >>> +}
> >>> +
> >>> +static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D vmf->vma->vm_private_data;
> >>> +     unsigned long iova =3D vmf->pgoff << PAGE_SHIFT;
> >>> +     struct page *page;
> >>> +
> >>> +     if (!domain)
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     if (iova < domain->bounce_size)
> >>> +             page =3D vduse_domain_alloc_bounce_page(domain, iova);
> >>> +     else
> >>> +             page =3D vduse_domain_get_mapping_page(domain, iova);
> >>> +
> >>> +     if (!page)
> >>> +             return VM_FAULT_SIGBUS;
> >>> +
> >>> +     vmf->page =3D page;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static const struct vm_operations_struct vduse_domain_mmap_ops =3D {
> >>> +     .fault =3D vduse_domain_mmap_fault,
> >>> +};
> >>> +
> >>> +static int vduse_domain_mmap(struct file *file, struct vm_area_struc=
t *vma)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D file->private_data;
> >>> +
> >>> +     vma->vm_flags |=3D VM_DONTDUMP | VM_DONTEXPAND;
> >>> +     vma->vm_private_data =3D domain;
> >>> +     vma->vm_ops =3D &vduse_domain_mmap_ops;
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static int vduse_domain_release(struct inode *inode, struct file *fi=
le)
> >>> +{
> >>> +     struct vduse_iova_domain *domain =3D file->private_data;
> >>> +
> >>> +     vduse_domain_free_bounce_pages(domain, 0, domain->bounce_size);
> >>> +     put_iova_domain(&domain->stream_iovad);
> >>> +     put_iova_domain(&domain->consistent_iovad);
> >>> +     vhost_iotlb_free(domain->iotlb);
> >>> +     vfree(domain->bounce_pages);
> >>> +     kfree(domain);
> >>> +
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static const struct file_operations vduse_domain_fops =3D {
> >>> +     .mmap =3D vduse_domain_mmap,
> >>> +     .release =3D vduse_domain_release,
> >>> +};
> >>> +
> >>> +void vduse_domain_destroy(struct vduse_iova_domain *domain)
> >>> +{
> >>> +     fput(domain->file);
> >>> +}
> >>> +
> >>> +struct vduse_iova_domain *
> >>> +vduse_domain_create(unsigned long iova_limit, size_t bounce_size)
> >>> +{
> >>> +     struct vduse_iova_domain *domain;
> >>> +     struct file *file;
> >>> +     unsigned long bounce_pfns =3D PAGE_ALIGN(bounce_size) >> PAGE_S=
HIFT;
> >>> +
> >>> +     if (iova_limit <=3D bounce_size)
> >>> +             return NULL;
> >>> +
> >>> +     domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> >>> +     if (!domain)
> >>> +             return NULL;
> >>> +
> >>> +     domain->iotlb =3D vhost_iotlb_alloc(0, 0);
> >>> +     if (!domain->iotlb)
> >>> +             goto err_iotlb;
> >>> +
> >>> +     domain->iova_limit =3D iova_limit;
> >>> +     domain->bounce_size =3D PAGE_ALIGN(bounce_size);
> >>> +     domain->bounce_pages =3D vzalloc(bounce_pfns * sizeof(struct pa=
ge *));
> >>> +     if (!domain->bounce_pages)
> >>> +             goto err_page;
> >>> +
> >>> +     file =3D anon_inode_getfile("[vduse-domain]", &vduse_domain_fop=
s,
> >>> +                             domain, O_RDWR);
> >>> +     if (IS_ERR(file))
> >>> +             goto err_file;
> >>> +
> >>> +     domain->file =3D file;
> >>> +     spin_lock_init(&domain->iotlb_lock);
> >>> +     init_iova_domain(&domain->stream_iovad,
> >>> +                     IOVA_ALLOC_SIZE, IOVA_START_PFN);
> >>> +     init_iova_domain(&domain->consistent_iovad,
> >>> +                     PAGE_SIZE, bounce_pfns);
> >>> +
> >>> +     return domain;
> >>> +err_file:
> >>> +     vfree(domain->bounce_pages);
> >>> +err_page:
> >>> +     vhost_iotlb_free(domain->iotlb);
> >>> +err_iotlb:
> >>> +     kfree(domain);
> >>> +     return NULL;
> >>> +}
> >>> +
> >>> +int vduse_domain_init(void)
> >>> +{
> >>> +     return iova_cache_get();
> >>> +}
> >>> +
> >>> +void vduse_domain_exit(void)
> >>> +{
> >>> +     iova_cache_put();
> >>> +}
> >>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa=
_user/iova_domain.h
> >>> new file mode 100644
> >>> index 000000000000..9c85d8346626
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> >>> @@ -0,0 +1,61 @@
> >>> +/* SPDX-License-Identifier: GPL-2.0-only */
> >>> +/*
> >>> + * MMU-based IOMMU implementation
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#ifndef _VDUSE_IOVA_DOMAIN_H
> >>> +#define _VDUSE_IOVA_DOMAIN_H
> >>> +
> >>> +#include <linux/iova.h>
> >>> +#include <linux/dma-mapping.h>
> >>> +#include <linux/vhost_iotlb.h>
> >>> +
> >>> +struct vduse_iova_domain {
> >>> +     struct iova_domain stream_iovad;
> >>> +     struct iova_domain consistent_iovad;
> >>> +     struct page **bounce_pages;
> >>> +     size_t bounce_size;
> >>> +     unsigned long iova_limit;
> >>> +     struct vhost_iotlb *iotlb;
> >>
> >> Sorry if I've asked this before.
> >>
> >> But what's the reason for maintaing a dedicated IOTLB here? I think we
> >> could reuse vduse_dev->iommu since the device can not be used by both
> >> virtio and vhost in the same time or use vduse_iova_domain->iotlb for
> >> set_map().
> >>
> > The main difference between domain->iotlb and dev->iotlb is the way to
> > deal with bounce buffer. In the domain->iotlb case, bounce buffer
> > needs to be mapped each DMA transfer because we need to get the bounce
> > pages by an IOVA during DMA unmapping. In the dev->iotlb case, bounce
> > buffer only needs to be mapped once during initialization, which will
> > be used to tell userspace how to do mmap().
> >
> >> Also, since vhost IOTLB support per mapping token (opauqe), can we use
> >> that instead of the bounce_pages *?
> >>
> > Sorry, I didn't get you here. Which value do you mean to store in the
> > opaque pointer=EF=BC=9F
>
>
> So I would like to have a way to use a single IOTLB for manage all kinds
> of mappings. Two possible ideas:
>
> 1) map bounce page one by one in vduse_dev_map_page(), in
> VDUSE_IOTLB_GET_FD, try to merge the result if we had the same fd. Then
> for bounce pages, userspace still only need to map it once and we can
> maintain the actual mapping by storing the page or pa in the opaque
> field of IOTLB entry.

Looks like userspace still needs to unmap the old region and map a new
region (size is changed) with the fd in each VDUSE_IOTLB_GET_FD ioctl.

> 2) map bounce page once in vduse_dev_map_page() and store struct page
> **bounce_pages in the opaque field of this single IOTLB entry.
>

We can get the struct page **bounce_pages from vduse_iova_domain. Why
do we need to store it in the opaque field?  Should the opaque field
be used to store vdpa_map_file?

And I think it works. One problem is we need to find a place to store
the original DMA buffer's address and size. I think we can modify the
array of bounce_pages for this purpose.

Thanks,
Yongji
