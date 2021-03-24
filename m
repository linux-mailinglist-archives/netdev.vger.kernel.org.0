Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F90D3472CF
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 08:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhCXHkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 03:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhCXHkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 03:40:14 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37D2C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 00:40:08 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id k10so31258614ejg.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 00:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=OHIaIYExMHEt8rPb+oIFgZan3TrF6ppKBBNq3YXZcCU=;
        b=is8gwfEAk6QN7NWdKIQ4Tpg0jCJ16z9Z5PIVXXhfr0Hk2tJlfgp2WBICAgiyPU7jiB
         YovPVbQ/Ii+NhJABmrRNehfO7ECaMmeYe68aXAXJcN4uNvjd9OMWkgPROKgI6bdt5/eI
         CKvBF1zmwVG2mxYZ9WOC6XKbxdC5OyTTArUr9oOw9R0MldO6zy2RXZjbF4rc+wvUujbn
         Nu4WTUv+6rDF8tVNyq20nGouaKcbHnQayV1OFo8s1drnujSdoKWnV5rTV0lIuiSPBaCz
         alzi57b9e6KRIVyQxdPut5Eb13LBUN+PRXZH7iHgjR9mqyAhlKFfGohzlUD+E3qir81H
         gqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=OHIaIYExMHEt8rPb+oIFgZan3TrF6ppKBBNq3YXZcCU=;
        b=TPKchtdcOyRXzu5vo0mEl2DXQJZoxPWxBPjEsXujmx/azgWllW/uZELtM8VCZWm8Ns
         82xfiZjF920a9WsIJmZgdmj9iOMRbUSpfMztkXReTVySAkionIX69trAljXQSjx2R2+e
         MXTKeZkX9dt1LvDR37TXgZoz+Mj37YFyt4yzHcvc/SBlQ0MG4oPbq4wnRgg7TJsWbE5f
         b0OS0IuIlDO+1bY8SFCSI8ekhtq2CVYC8KSnS2tB1vkvb57YHPs0q6AoZrdc1srNLUSh
         fYSuTGidIpA7DLzhl73icKytvSkmrhgBFO2SRZ6BEvLXf9SUSpboQFPmtqFZSViRT0bi
         v/lw==
X-Gm-Message-State: AOAM530I/xEubXREl9o2hTQcsNR/Zhx1NRehgX2qIFSSDXo5ctkUbljk
        445UqVs6x2igf7J90+qlQw4GmZ6Xr+J38nh1/4oF
X-Google-Smtp-Source: ABdhPJyAIcvxLcMP57Zx3y6IKCbmFIEKal04Sv5kjApQr7WzicydBkW7F9gusrTOpnp9bubP9MzIex15gJHmluNKAeY=
X-Received: by 2002:a17:907:3f96:: with SMTP id hr22mr2151161ejc.427.1616571607072;
 Wed, 24 Mar 2021 00:40:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-9-xieyongji@bytedance.com>
 <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com>
In-Reply-To: <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 24 Mar 2021 15:39:56 +0800
Message-ID: <CACycT3v_-G6ju-poofXEzYt8QPKWNFHwsS7t=KTLgs-=g+iPQQ@mail.gmail.com>
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

On Wed, Mar 24, 2021 at 11:54 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=93=
:
> > This implements an MMU-based IOMMU driver to support mapping
> > kernel dma buffer into userspace. The basic idea behind it is
> > treating MMU (VA->PA) as IOMMU (IOVA->PA). The driver will set
> > up MMU mapping instead of IOMMU mapping for the DMA transfer so
> > that the userspace process is able to use its virtual address to
> > access the dma buffer in kernel.
> >
> > And to avoid security issue, a bounce-buffering mechanism is
> > introduced to prevent userspace accessing the original buffer
> > directly.
> >
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vdpa/vdpa_user/iova_domain.c | 535 ++++++++++++++++++++++++++=
+++++++++
> >   drivers/vdpa/vdpa_user/iova_domain.h |  75 +++++
> >   2 files changed, 610 insertions(+)
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >
> > diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa_u=
ser/iova_domain.c
> > new file mode 100644
> > index 000000000000..83de216b0e51
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> > @@ -0,0 +1,535 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + * MMU-based IOMMU implementation
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
>
>
> 2021 as well.
>

Sure.

>
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#include <linux/slab.h>
> > +#include <linux/file.h>
> > +#include <linux/anon_inodes.h>
> > +#include <linux/highmem.h>
> > +#include <linux/vmalloc.h>
> > +#include <linux/vdpa.h>
> > +
> > +#include "iova_domain.h"
> > +
> > +static int vduse_iotlb_add_range(struct vduse_iova_domain *domain,
> > +                              u64 start, u64 last,
> > +                              u64 addr, unsigned int perm,
> > +                              struct file *file, u64 offset)
> > +{
> > +     struct vdpa_map_file *map_file;
> > +     int ret;
> > +
> > +     map_file =3D kmalloc(sizeof(*map_file), GFP_ATOMIC);
> > +     if (!map_file)
> > +             return -ENOMEM;
> > +
> > +     map_file->file =3D get_file(file);
> > +     map_file->offset =3D offset;
> > +
> > +     ret =3D vhost_iotlb_add_range_ctx(domain->iotlb, start, last,
> > +                                     addr, perm, map_file);
> > +     if (ret) {
> > +             fput(map_file->file);
> > +             kfree(map_file);
> > +             return ret;
> > +     }
> > +     return 0;
> > +}
> > +
> > +static void vduse_iotlb_del_range(struct vduse_iova_domain *domain,
> > +                               u64 start, u64 last)
> > +{
> > +     struct vdpa_map_file *map_file;
> > +     struct vhost_iotlb_map *map;
> > +
> > +     while ((map =3D vhost_iotlb_itree_first(domain->iotlb, start, las=
t))) {
> > +             map_file =3D (struct vdpa_map_file *)map->opaque;
> > +             fput(map_file->file);
> > +             kfree(map_file);
> > +             vhost_iotlb_map_free(domain->iotlb, map);
> > +     }
> > +}
> > +
> > +int vduse_domain_set_map(struct vduse_iova_domain *domain,
> > +                      struct vhost_iotlb *iotlb)
> > +{
> > +     struct vdpa_map_file *map_file;
> > +     struct vhost_iotlb_map *map;
> > +     u64 start =3D 0ULL, last =3D ULLONG_MAX;
> > +     int ret;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     vduse_iotlb_del_range(domain, start, last);
> > +
> > +     for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> > +          map =3D vhost_iotlb_itree_next(map, start, last)) {
> > +             map_file =3D (struct vdpa_map_file *)map->opaque;
> > +             ret =3D vduse_iotlb_add_range(domain, map->start, map->la=
st,
> > +                                         map->addr, map->perm,
> > +                                         map_file->file,
> > +                                         map_file->offset);
> > +             if (ret)
> > +                     goto err;
> > +     }
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     return 0;
> > +err:
> > +     vduse_iotlb_del_range(domain, start, last);
> > +     spin_unlock(&domain->iotlb_lock);
> > +     return ret;
> > +}
> > +
> > +static void vduse_domain_map_bounce_page(struct vduse_iova_domain *dom=
ain,
> > +                                      u64 iova, u64 size, u64 paddr)
> > +{
> > +     struct vduse_bounce_map *map;
> > +     unsigned int index;
> > +     u64 last =3D iova + size - 1;
> > +
> > +     while (iova < last) {
> > +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> > +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> > +             map->orig_phys[index] =3D paddr;
> > +             paddr +=3D IOVA_ALLOC_SIZE;
> > +             iova +=3D IOVA_ALLOC_SIZE;
> > +     }
> > +}
> > +
> > +static void vduse_domain_unmap_bounce_page(struct vduse_iova_domain *d=
omain,
> > +                                        u64 iova, u64 size)
> > +{
> > +     struct vduse_bounce_map *map;
> > +     unsigned int index;
> > +     u64 last =3D iova + size - 1;
> > +
> > +     while (iova < last) {
> > +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> > +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> > +             map->orig_phys[index] =3D INVALID_PHYS_ADDR;
> > +             iova +=3D IOVA_ALLOC_SIZE;
> > +     }
> > +}
> > +
> > +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> > +                   enum dma_data_direction dir)
> > +{
> > +     unsigned long pfn =3D PFN_DOWN(orig);
> > +
> > +     if (PageHighMem(pfn_to_page(pfn))) {
> > +             unsigned int offset =3D offset_in_page(orig);
> > +             char *buffer;
> > +             unsigned int sz =3D 0;
> > +
> > +             while (size) {
> > +                     sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> > +
> > +                     buffer =3D kmap_atomic(pfn_to_page(pfn));
>
>
> So kmap_atomic() can autoamtically go with fast path if the page does
> not belong to highmem.
>
> I think we can removce the condition and just use kmap_atomic() for all
> the cases here.
>

Looks good to me.

>
> > +                     if (dir =3D=3D DMA_TO_DEVICE)
> > +                             memcpy(addr, buffer + offset, sz);
> > +                     else
> > +                             memcpy(buffer + offset, addr, sz);
> > +                     kunmap_atomic(buffer);
> > +
> > +                     size -=3D sz;
> > +                     pfn++;
> > +                     addr +=3D sz;
> > +                     offset =3D 0;
> > +             }
> > +     } else if (dir =3D=3D DMA_TO_DEVICE) {
> > +             memcpy(addr, phys_to_virt(orig), size);
> > +     } else {
> > +             memcpy(phys_to_virt(orig), addr, size);
> > +     }
> > +}
> > +
> > +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> > +                             dma_addr_t iova, size_t size,
> > +                             enum dma_data_direction dir)
> > +{
> > +     struct vduse_bounce_map *map;
> > +     unsigned int index, offset;
> > +     void *addr;
> > +     size_t sz;
> > +
> > +     while (size) {
> > +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> > +             offset =3D offset_in_page(iova);
> > +             sz =3D min_t(size_t, IOVA_ALLOC_SIZE, size);
> > +
> > +             if (map->bounce_page &&
> > +                 map->orig_phys[index] !=3D INVALID_PHYS_ADDR) {
> > +                     addr =3D page_address(map->bounce_page) + offset;
> > +                     index =3D offset >> IOVA_ALLOC_ORDER;
> > +                     do_bounce(map->orig_phys[index], addr, sz, dir);
> > +             }
> > +             size -=3D sz;
> > +             iova +=3D sz;
> > +     }
> > +}
> > +
> > +static struct page *
> > +vduse_domain_get_mapping_page(struct vduse_iova_domain *domain, u64 io=
va)
> > +{
> > +     u64 start =3D iova & PAGE_MASK;
> > +     u64 last =3D start + PAGE_SIZE - 1;
> > +     struct vhost_iotlb_map *map;
> > +     struct page *page =3D NULL;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     map =3D vhost_iotlb_itree_first(domain->iotlb, start, last);
> > +     if (!map)
> > +             goto out;
> > +
> > +     page =3D pfn_to_page((map->addr + iova - map->start) >> PAGE_SHIF=
T);
> > +     get_page(page);
> > +out:
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     return page;
> > +}
> > +
> > +static struct page *
> > +vduse_domain_alloc_bounce_page(struct vduse_iova_domain *domain, u64 i=
ova)
> > +{
> > +     u64 start =3D iova & PAGE_MASK;
> > +     struct page *page =3D alloc_page(GFP_KERNEL);
> > +     struct vduse_bounce_map *map;
> > +
> > +     if (!page)
> > +             return NULL;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> > +     if (map->bounce_page) {
> > +             __free_page(page);
> > +             goto out;
> > +     }
> > +     map->bounce_page =3D page;
> > +
> > +     /* paired with vduse_domain_map_page() */
> > +     smp_mb();
>
>
> So this is suspicious. It's better to explain like, we need make sure A
> must be done after B.

OK. I see. It's used to protect this pattern:

   vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
   write map->bounce_page                           write map->orig_phys
   mb()                                                            mb()
   read map->orig_phys                                 read map->bounce_pag=
e

Make sure there will always be a path to do bouncing.

>
> And it looks to me the iotlb_lock is sufficnet to do the synchronization
> here. E.g any reason that you don't take it in
> vduse_domain_map_bounce_page().
>

Yes, we can. But the performance in multi-queue cases will go down if
we use iotlb_lock on this critical path.

> And what's more, is there anyway to aovid holding the spinlock during
> bouncing?
>

Looks like we can't. In the case that multiple page faults happen on
the same page, we should make sure the bouncing is done before any
page fault handler returns.

>
> > +
> > +     vduse_domain_bounce(domain, start, PAGE_SIZE, DMA_TO_DEVICE);
> > +out:
> > +     get_page(map->bounce_page);
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     return map->bounce_page;
> > +}
> > +
> > +static void
> > +vduse_domain_free_bounce_pages(struct vduse_iova_domain *domain)
> > +{
> > +     struct vduse_bounce_map *map;
> > +     unsigned long i, pfn, bounce_pfns;
> > +
> > +     bounce_pfns =3D domain->bounce_size >> PAGE_SHIFT;
> > +
> > +     for (pfn =3D 0; pfn < bounce_pfns; pfn++) {
> > +             map =3D &domain->bounce_maps[pfn];
> > +             for (i =3D 0; i < IOVA_MAPS_PER_PAGE; i++) {
> > +                     if (WARN_ON(map->orig_phys[i] !=3D INVALID_PHYS_A=
DDR))
> > +                             continue;
> > +             }
> > +             if (!map->bounce_page)
> > +                     continue;
> > +
> > +             __free_page(map->bounce_page);
> > +             map->bounce_page =3D NULL;
> > +     }
> > +}
> > +
> > +void vduse_domain_reset_bounce_map(struct vduse_iova_domain *domain)
> > +{
> > +     if (!domain->bounce_map)
> > +             return;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     if (!domain->bounce_map)
> > +             goto unlock;
> > +
> > +     vduse_iotlb_del_range(domain, 0, domain->bounce_size - 1);
> > +     domain->bounce_map =3D 0;
> > +     vduse_domain_free_bounce_pages(domain);
> > +unlock:
> > +     spin_unlock(&domain->iotlb_lock);
> > +}
> > +
> > +static int vduse_domain_init_bounce_map(struct vduse_iova_domain *doma=
in)
> > +{
> > +     int ret;
> > +
> > +     if (domain->bounce_map)
> > +             return 0;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     if (domain->bounce_map)
> > +             goto unlock;
> > +
> > +     ret =3D vduse_iotlb_add_range(domain, 0, domain->bounce_size - 1,
> > +                                 0, VHOST_MAP_RW, domain->file, 0);
> > +     if (!ret)
> > +             domain->bounce_map =3D 1;
> > +unlock:
> > +     spin_unlock(&domain->iotlb_lock);
> > +     return ret;
> > +}
> > +
> > +static dma_addr_t
> > +vduse_domain_alloc_iova(struct iova_domain *iovad,
> > +                     unsigned long size, unsigned long limit)
> > +{
> > +     unsigned long shift =3D iova_shift(iovad);
> > +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> > +     unsigned long iova_pfn;
> > +
> > +     if (iova_len < (1 << (IOVA_RANGE_CACHE_MAX_SIZE - 1)))
> > +             iova_len =3D roundup_pow_of_two(iova_len);
> > +     iova_pfn =3D alloc_iova_fast(iovad, iova_len, limit >> shift, tru=
e);
> > +
> > +     return iova_pfn << shift;
> > +}
> > +
> > +static void vduse_domain_free_iova(struct iova_domain *iovad,
> > +                                dma_addr_t iova, size_t size)
> > +{
> > +     unsigned long shift =3D iova_shift(iovad);
> > +     unsigned long iova_len =3D iova_align(iovad, size) >> shift;
> > +
> > +     free_iova_fast(iovad, iova >> shift, iova_len);
> > +}
> > +
> > +dma_addr_t vduse_domain_map_page(struct vduse_iova_domain *domain,
> > +                              struct page *page, unsigned long offset,
> > +                              size_t size, enum dma_data_direction dir=
,
> > +                              unsigned long attrs)
> > +{
> > +     struct iova_domain *iovad =3D &domain->stream_iovad;
> > +     unsigned long limit =3D domain->bounce_size - 1;
> > +     phys_addr_t pa =3D page_to_phys(page) + offset;
> > +     dma_addr_t iova =3D vduse_domain_alloc_iova(iovad, size, limit);
> > +
> > +     if (!iova)
> > +             return DMA_MAPPING_ERROR;
> > +
> > +     if (vduse_domain_init_bounce_map(domain)) {
> > +             vduse_domain_free_iova(iovad, iova, size);
> > +             return DMA_MAPPING_ERROR;
> > +     }
> > +
> > +     vduse_domain_map_bounce_page(domain, (u64)iova, (u64)size, pa);
> > +
> > +     /* paired with vduse_domain_alloc_bounce_page() */
> > +     smp_mb();
> > +
> > +     if (dir =3D=3D DMA_TO_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> > +             vduse_domain_bounce(domain, iova, size, DMA_TO_DEVICE);
> > +
> > +     return iova;
> > +}
> > +
> > +void vduse_domain_unmap_page(struct vduse_iova_domain *domain,
> > +                          dma_addr_t dma_addr, size_t size,
> > +                          enum dma_data_direction dir, unsigned long a=
ttrs)
> > +{
> > +     struct iova_domain *iovad =3D &domain->stream_iovad;
> > +
> > +     if (dir =3D=3D DMA_FROM_DEVICE || dir =3D=3D DMA_BIDIRECTIONAL)
> > +             vduse_domain_bounce(domain, dma_addr, size, DMA_FROM_DEVI=
CE);
> > +
> > +     vduse_domain_unmap_bounce_page(domain, (u64)dma_addr, (u64)size);
> > +     vduse_domain_free_iova(iovad, dma_addr, size);
> > +}
> > +
> > +void *vduse_domain_alloc_coherent(struct vduse_iova_domain *domain,
> > +                               size_t size, dma_addr_t *dma_addr,
> > +                               gfp_t flag, unsigned long attrs)
> > +{
> > +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> > +     unsigned long limit =3D domain->iova_limit;
> > +     dma_addr_t iova =3D vduse_domain_alloc_iova(iovad, size, limit);
> > +     void *orig =3D alloc_pages_exact(size, flag);
> > +
> > +     if (!iova || !orig)
> > +             goto err;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     if (vduse_iotlb_add_range(domain, (u64)iova, (u64)iova + size - 1=
,
> > +                               virt_to_phys(orig), VHOST_MAP_RW,
> > +                               domain->file, (u64)iova)) {
> > +             spin_unlock(&domain->iotlb_lock);
> > +             goto err;
> > +     }
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     *dma_addr =3D iova;
> > +
> > +     return orig;
> > +err:
> > +     *dma_addr =3D DMA_MAPPING_ERROR;
> > +     if (orig)
> > +             free_pages_exact(orig, size);
> > +     if (iova)
> > +             vduse_domain_free_iova(iovad, iova, size);
> > +
> > +     return NULL;
> > +}
> > +
> > +void vduse_domain_free_coherent(struct vduse_iova_domain *domain, size=
_t size,
> > +                             void *vaddr, dma_addr_t dma_addr,
> > +                             unsigned long attrs)
> > +{
> > +     struct iova_domain *iovad =3D &domain->consistent_iovad;
> > +     struct vhost_iotlb_map *map;
> > +     struct vdpa_map_file *map_file;
> > +     phys_addr_t pa;
> > +
> > +     spin_lock(&domain->iotlb_lock);
> > +     map =3D vhost_iotlb_itree_first(domain->iotlb, (u64)dma_addr,
> > +                                   (u64)dma_addr + size - 1);
> > +     if (WARN_ON(!map)) {
> > +             spin_unlock(&domain->iotlb_lock);
> > +             return;
> > +     }
> > +     map_file =3D (struct vdpa_map_file *)map->opaque;
> > +     fput(map_file->file);
> > +     kfree(map_file);
> > +     pa =3D map->addr;
> > +     vhost_iotlb_map_free(domain->iotlb, map);
> > +     spin_unlock(&domain->iotlb_lock);
> > +
> > +     vduse_domain_free_iova(iovad, dma_addr, size);
> > +     free_pages_exact(phys_to_virt(pa), size);
>
>
> I wonder whether we should free the coherent page after munmap().

But we don't know whether this coherent page is still needed by
userspace. The userspace can call munmap() in any cases.

> Otherwise usersapce can poke kernel pages in this way, e.g the page
> could be allocated and used by other subsystems?
>

Sorry, I didn't get your point here. What's the relationship between
this problem and munmap()?

>
> > +}
> > +
> > +static vm_fault_t vduse_domain_mmap_fault(struct vm_fault *vmf)
> > +{
> > +     struct vduse_iova_domain *domain =3D vmf->vma->vm_private_data;
> > +     unsigned long iova =3D vmf->pgoff << PAGE_SHIFT;
> > +     struct page *page;
> > +
> > +     if (!domain)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     if (iova < domain->bounce_size)
> > +             page =3D vduse_domain_alloc_bounce_page(domain, iova);
> > +     else
> > +             page =3D vduse_domain_get_mapping_page(domain, iova);
> > +
> > +     if (!page)
> > +             return VM_FAULT_SIGBUS;
> > +
> > +     vmf->page =3D page;
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct vm_operations_struct vduse_domain_mmap_ops =3D {
> > +     .fault =3D vduse_domain_mmap_fault,
> > +};
> > +
> > +static int vduse_domain_mmap(struct file *file, struct vm_area_struct =
*vma)
> > +{
> > +     struct vduse_iova_domain *domain =3D file->private_data;
> > +
> > +     vma->vm_flags |=3D VM_DONTDUMP | VM_DONTEXPAND;
> > +     vma->vm_private_data =3D domain;
> > +     vma->vm_ops =3D &vduse_domain_mmap_ops;
> > +
> > +     return 0;
> > +}
> > +
> > +static int vduse_domain_release(struct inode *inode, struct file *file=
)
> > +{
> > +     struct vduse_iova_domain *domain =3D file->private_data;
> > +
> > +     vduse_domain_reset_bounce_map(domain);
> > +     put_iova_domain(&domain->stream_iovad);
> > +     put_iova_domain(&domain->consistent_iovad);
> > +     vhost_iotlb_free(domain->iotlb);
> > +     vfree(domain->bounce_maps);
> > +     kfree(domain);
> > +
> > +     return 0;
> > +}
> > +
> > +static const struct file_operations vduse_domain_fops =3D {
> > +     .mmap =3D vduse_domain_mmap,
> > +     .release =3D vduse_domain_release,
> > +};
> > +
> > +void vduse_domain_destroy(struct vduse_iova_domain *domain)
> > +{
> > +     fput(domain->file);
> > +}
> > +
> > +struct vduse_iova_domain *
> > +vduse_domain_create(unsigned long iova_limit, size_t bounce_size)
> > +{
> > +     struct vduse_iova_domain *domain;
> > +     struct file *file;
> > +     struct vduse_bounce_map *map;
> > +     unsigned long i, pfn, bounce_pfns;
> > +
> > +     bounce_pfns =3D PAGE_ALIGN(bounce_size) >> PAGE_SHIFT;
> > +     if (iova_limit <=3D bounce_size)
> > +             return NULL;
> > +
> > +     domain =3D kzalloc(sizeof(*domain), GFP_KERNEL);
> > +     if (!domain)
> > +             return NULL;
> > +
> > +     domain->iotlb =3D vhost_iotlb_alloc(0, 0);
> > +     if (!domain->iotlb)
> > +             goto err_iotlb;
> > +
> > +     domain->iova_limit =3D iova_limit;
> > +     domain->bounce_size =3D PAGE_ALIGN(bounce_size);
> > +     domain->bounce_maps =3D vzalloc(bounce_pfns *
> > +                             sizeof(struct vduse_bounce_map));
> > +     if (!domain->bounce_maps)
> > +             goto err_map;
> > +
> > +     for (pfn =3D 0; pfn < bounce_pfns; pfn++) {
> > +             map =3D &domain->bounce_maps[pfn];
> > +             for (i =3D 0; i < IOVA_MAPS_PER_PAGE; i++)
> > +                     map->orig_phys[i] =3D INVALID_PHYS_ADDR;
> > +     }
> > +     file =3D anon_inode_getfile("[vduse-domain]", &vduse_domain_fops,
> > +                             domain, O_RDWR);
> > +     if (IS_ERR(file))
> > +             goto err_file;
> > +
> > +     domain->file =3D file;
> > +     spin_lock_init(&domain->iotlb_lock);
> > +     init_iova_domain(&domain->stream_iovad,
> > +                     IOVA_ALLOC_SIZE, IOVA_START_PFN);
> > +     init_iova_domain(&domain->consistent_iovad,
> > +                     PAGE_SIZE, bounce_pfns);
>
>
> Any reason for treating coherent and stream DMA differently (the
> different granule)?
>

To save space for small I/Os (less than PAGE_SIZE). We can have one
bounce page for multiple small I/Os.

>
> > +
> > +     return domain;
> > +err_file:
> > +     vfree(domain->bounce_maps);
> > +err_map:
> > +     vhost_iotlb_free(domain->iotlb);
> > +err_iotlb:
> > +     kfree(domain);
> > +     return NULL;
> > +}
> > +
> > +int vduse_domain_init(void)
> > +{
> > +     return iova_cache_get();
> > +}
> > +
> > +void vduse_domain_exit(void)
> > +{
> > +     iova_cache_put();
> > +}
> > diff --git a/drivers/vdpa/vdpa_user/iova_domain.h b/drivers/vdpa/vdpa_u=
ser/iova_domain.h
> > new file mode 100644
> > index 000000000000..faeeedfaa786
> > --- /dev/null
> > +++ b/drivers/vdpa/vdpa_user/iova_domain.h
> > @@ -0,0 +1,75 @@
> > +/* SPDX-License-Identifier: GPL-2.0-only */
> > +/*
> > + * MMU-based IOMMU implementation
> > + *
> > + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All rights=
 reserved.
> > + *
> > + * Author: Xie Yongji <xieyongji@bytedance.com>
> > + *
> > + */
> > +
> > +#ifndef _VDUSE_IOVA_DOMAIN_H
> > +#define _VDUSE_IOVA_DOMAIN_H
> > +
> > +#include <linux/iova.h>
> > +#include <linux/dma-mapping.h>
> > +#include <linux/vhost_iotlb.h>
> > +
> > +#define IOVA_START_PFN 1
> > +
> > +#define IOVA_ALLOC_ORDER 12
> > +#define IOVA_ALLOC_SIZE (1 << IOVA_ALLOC_ORDER)
> > +
> > +#define IOVA_MAPS_PER_PAGE (1 << (PAGE_SHIFT - IOVA_ALLOC_ORDER))
> > +
> > +#define INVALID_PHYS_ADDR (~(phys_addr_t)0)
> > +
> > +struct vduse_bounce_map {
> > +     struct page *bounce_page;
> > +     u64 orig_phys[IOVA_MAPS_PER_PAGE];
>
>
> Sorry if I had asked this before. But I'm not sure it's worth to have
> this extra complexitiy. If I read the code correctly, the
> IOVA_MAPS_PER_PAGE is 1 for the archs that have 4K page. Have you tested
> the code on the archs that have more than 4K page?
>

No, I haven't test it. Now I think it's OK to remove this optimization
in this patchset.

Thanks,
Yongji
