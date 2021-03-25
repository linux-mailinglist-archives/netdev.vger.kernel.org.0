Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E88E4348A43
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 08:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbhCYHjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 03:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhCYHij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 03:38:39 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A74C06175F
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:38:38 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id b7so1333943ejv.1
        for <netdev@vger.kernel.org>; Thu, 25 Mar 2021 00:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bUlueBYPh/P+N4UxlAlsJ+Cn56tIXCzQbpulE4eOVhk=;
        b=HBmyYTsumtc5vRJ1bOv2EudZzIIPARoYAyTvgnm+Jnl3SBbqIZQXn809Q5nGQGFUTc
         KO19F5XVGihXVBBepe/7btLAazRZPjSweNzjK1LUEyrGUodn32AG/v9huTlhPlXTlFNx
         Me3F0w8JnmNnp8odLtcma27tai4ssNmDUSRSjOFNFCf/La5eHL7CVzjB79p9fdoJJ54Y
         zErPBYKVmlqpcbRqXuyoboyyAe2XmmtGE34o1kQKm+puxyGH8r8s/dAfg0qODORPFc2n
         gyhm3ZCKoI/FR/Dj9TDGT6+/Ga32LrrbNOJneT6I+5T1rLM9Fh6l+Zok1JxN7zFaloK8
         PvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bUlueBYPh/P+N4UxlAlsJ+Cn56tIXCzQbpulE4eOVhk=;
        b=TZliCVnhmMri0hNrReiOHfw+H6GtjJpv2u1Fi6CuxtfLp9NhQPHFqBEiueFqZnuhWS
         nreMucfWhdTJQuRvKhXaMMJ8PvCyTwYG1dN1DEfq1et2dVdXCWbFJ8gqWI423p2id7bn
         2FhuQyd7PQeSVH1I4g5zqF0RgHzvNng5SKK2qjeMo+dwSuHUNFNl92mIuF4N53wJ7zdE
         /7+2nNYlGdZ9W2CN4RHrHze7QwuJbgkELh/12Xiy3Y/Eu6/Cyp2WM16+EoGY+Ui6hxzm
         YSZqXvTElTUb98Hp+7is0YFOOq4LtxEOcvaN8TXauR3q0ZMSUV5ffmakrX7xwUIJwL9m
         qV2A==
X-Gm-Message-State: AOAM531RqFFRtWS65TOcW5UNpAar6ET997iROHvW+9taNAzzZ7nIrxBK
        gJWM9LUU/6Mgte7EXS0qHFWxbM1ceCsWDXHqJrMM
X-Google-Smtp-Source: ABdhPJwbfjK+VBrQHywVf5rRXSQp0nk52UaeDccXdqV/ahpQI4OqwdbXYERRk3UwwO602+klSuYMi8AO8FGcZ5gTThA=
X-Received: by 2002:a17:906:86c6:: with SMTP id j6mr7573968ejy.197.1616657917510;
 Thu, 25 Mar 2021 00:38:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-9-xieyongji@bytedance.com>
 <ec5b4146-9844-11b0-c9b0-c657d3328dd4@redhat.com> <CACycT3v_-G6ju-poofXEzYt8QPKWNFHwsS7t=KTLgs-=g+iPQQ@mail.gmail.com>
 <7c90754b-681d-f3bf-514c-756abfcf3d23@redhat.com>
In-Reply-To: <7c90754b-681d-f3bf-514c-756abfcf3d23@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 25 Mar 2021 15:38:26 +0800
Message-ID: <CACycT3uS870yy04rw7KBk==sioi+VNunxVz6BQH-Lmxk6m-VSg@mail.gmail.com>
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

On Thu, Mar 25, 2021 at 12:53 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/24 =E4=B8=8B=E5=8D=883:39, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Wed, Mar 24, 2021 at 11:54 AM Jason Wang <jasowang@redhat.com> wrote=
:
> >>
> >> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=
=93:
> >>> This implements an MMU-based IOMMU driver to support mapping
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
> >>>    drivers/vdpa/vdpa_user/iova_domain.c | 535 +++++++++++++++++++++++=
++++++++++++
> >>>    drivers/vdpa/vdpa_user/iova_domain.h |  75 +++++
> >>>    2 files changed, 610 insertions(+)
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
> >>>    create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
> >>>
> >>> diff --git a/drivers/vdpa/vdpa_user/iova_domain.c b/drivers/vdpa/vdpa=
_user/iova_domain.c
> >>> new file mode 100644
> >>> index 000000000000..83de216b0e51
> >>> --- /dev/null
> >>> +++ b/drivers/vdpa/vdpa_user/iova_domain.c
> >>> @@ -0,0 +1,535 @@
> >>> +// SPDX-License-Identifier: GPL-2.0-only
> >>> +/*
> >>> + * MMU-based IOMMU implementation
> >>> + *
> >>> + * Copyright (C) 2020 Bytedance Inc. and/or its affiliates. All righ=
ts reserved.
> >>
> >> 2021 as well.
> >>
> > Sure.
> >
> >>> + *
> >>> + * Author: Xie Yongji <xieyongji@bytedance.com>
> >>> + *
> >>> + */
> >>> +
> >>> +#include <linux/slab.h>
> >>> +#include <linux/file.h>
> >>> +#include <linux/anon_inodes.h>
> >>> +#include <linux/highmem.h>
> >>> +#include <linux/vmalloc.h>
> >>> +#include <linux/vdpa.h>
> >>> +
> >>> +#include "iova_domain.h"
> >>> +
> >>> +static int vduse_iotlb_add_range(struct vduse_iova_domain *domain,
> >>> +                              u64 start, u64 last,
> >>> +                              u64 addr, unsigned int perm,
> >>> +                              struct file *file, u64 offset)
> >>> +{
> >>> +     struct vdpa_map_file *map_file;
> >>> +     int ret;
> >>> +
> >>> +     map_file =3D kmalloc(sizeof(*map_file), GFP_ATOMIC);
> >>> +     if (!map_file)
> >>> +             return -ENOMEM;
> >>> +
> >>> +     map_file->file =3D get_file(file);
> >>> +     map_file->offset =3D offset;
> >>> +
> >>> +     ret =3D vhost_iotlb_add_range_ctx(domain->iotlb, start, last,
> >>> +                                     addr, perm, map_file);
> >>> +     if (ret) {
> >>> +             fput(map_file->file);
> >>> +             kfree(map_file);
> >>> +             return ret;
> >>> +     }
> >>> +     return 0;
> >>> +}
> >>> +
> >>> +static void vduse_iotlb_del_range(struct vduse_iova_domain *domain,
> >>> +                               u64 start, u64 last)
> >>> +{
> >>> +     struct vdpa_map_file *map_file;
> >>> +     struct vhost_iotlb_map *map;
> >>> +
> >>> +     while ((map =3D vhost_iotlb_itree_first(domain->iotlb, start, l=
ast))) {
> >>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>> +             fput(map_file->file);
> >>> +             kfree(map_file);
> >>> +             vhost_iotlb_map_free(domain->iotlb, map);
> >>> +     }
> >>> +}
> >>> +
> >>> +int vduse_domain_set_map(struct vduse_iova_domain *domain,
> >>> +                      struct vhost_iotlb *iotlb)
> >>> +{
> >>> +     struct vdpa_map_file *map_file;
> >>> +     struct vhost_iotlb_map *map;
> >>> +     u64 start =3D 0ULL, last =3D ULLONG_MAX;
> >>> +     int ret;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     vduse_iotlb_del_range(domain, start, last);
> >>> +
> >>> +     for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> >>> +          map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>> +             map_file =3D (struct vdpa_map_file *)map->opaque;
> >>> +             ret =3D vduse_iotlb_add_range(domain, map->start, map->=
last,
> >>> +                                         map->addr, map->perm,
> >>> +                                         map_file->file,
> >>> +                                         map_file->offset);
> >>> +             if (ret)
> >>> +                     goto err;
> >>> +     }
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +
> >>> +     return 0;
> >>> +err:
> >>> +     vduse_iotlb_del_range(domain, start, last);
> >>> +     spin_unlock(&domain->iotlb_lock);
> >>> +     return ret;
> >>> +}
> >>> +
> >>> +static void vduse_domain_map_bounce_page(struct vduse_iova_domain *d=
omain,
> >>> +                                      u64 iova, u64 size, u64 paddr)
> >>> +{
> >>> +     struct vduse_bounce_map *map;
> >>> +     unsigned int index;
> >>> +     u64 last =3D iova + size - 1;
> >>> +
> >>> +     while (iova < last) {
> >>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>> +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> >>> +             map->orig_phys[index] =3D paddr;
> >>> +             paddr +=3D IOVA_ALLOC_SIZE;
> >>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>> +     }
> >>> +}
> >>> +
> >>> +static void vduse_domain_unmap_bounce_page(struct vduse_iova_domain =
*domain,
> >>> +                                        u64 iova, u64 size)
> >>> +{
> >>> +     struct vduse_bounce_map *map;
> >>> +     unsigned int index;
> >>> +     u64 last =3D iova + size - 1;
> >>> +
> >>> +     while (iova < last) {
> >>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>> +             index =3D offset_in_page(iova) >> IOVA_ALLOC_ORDER;
> >>> +             map->orig_phys[index] =3D INVALID_PHYS_ADDR;
> >>> +             iova +=3D IOVA_ALLOC_SIZE;
> >>> +     }
> >>> +}
> >>> +
> >>> +static void do_bounce(phys_addr_t orig, void *addr, size_t size,
> >>> +                   enum dma_data_direction dir)
> >>> +{
> >>> +     unsigned long pfn =3D PFN_DOWN(orig);
> >>> +
> >>> +     if (PageHighMem(pfn_to_page(pfn))) {
> >>> +             unsigned int offset =3D offset_in_page(orig);
> >>> +             char *buffer;
> >>> +             unsigned int sz =3D 0;
> >>> +
> >>> +             while (size) {
> >>> +                     sz =3D min_t(size_t, PAGE_SIZE - offset, size);
> >>> +
> >>> +                     buffer =3D kmap_atomic(pfn_to_page(pfn));
> >>
> >> So kmap_atomic() can autoamtically go with fast path if the page does
> >> not belong to highmem.
> >>
> >> I think we can removce the condition and just use kmap_atomic() for al=
l
> >> the cases here.
> >>
> > Looks good to me.
> >
> >>> +                     if (dir =3D=3D DMA_TO_DEVICE)
> >>> +                             memcpy(addr, buffer + offset, sz);
> >>> +                     else
> >>> +                             memcpy(buffer + offset, addr, sz);
> >>> +                     kunmap_atomic(buffer);
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
> >>> +static void vduse_domain_bounce(struct vduse_iova_domain *domain,
> >>> +                             dma_addr_t iova, size_t size,
> >>> +                             enum dma_data_direction dir)
> >>> +{
> >>> +     struct vduse_bounce_map *map;
> >>> +     unsigned int index, offset;
> >>> +     void *addr;
> >>> +     size_t sz;
> >>> +
> >>> +     while (size) {
> >>> +             map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>> +             offset =3D offset_in_page(iova);
> >>> +             sz =3D min_t(size_t, IOVA_ALLOC_SIZE, size);
> >>> +
> >>> +             if (map->bounce_page &&
> >>> +                 map->orig_phys[index] !=3D INVALID_PHYS_ADDR) {
> >>> +                     addr =3D page_address(map->bounce_page) + offse=
t;
> >>> +                     index =3D offset >> IOVA_ALLOC_ORDER;
> >>> +                     do_bounce(map->orig_phys[index], addr, sz, dir)=
;
> >>> +             }
> >>> +             size -=3D sz;
> >>> +             iova +=3D sz;
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
> >>> +     struct page *page =3D alloc_page(GFP_KERNEL);
> >>> +     struct vduse_bounce_map *map;
> >>> +
> >>> +     if (!page)
> >>> +             return NULL;
> >>> +
> >>> +     spin_lock(&domain->iotlb_lock);
> >>> +     map =3D &domain->bounce_maps[iova >> PAGE_SHIFT];
> >>> +     if (map->bounce_page) {
> >>> +             __free_page(page);
> >>> +             goto out;
> >>> +     }
> >>> +     map->bounce_page =3D page;
> >>> +
> >>> +     /* paired with vduse_domain_map_page() */
> >>> +     smp_mb();
> >>
> >> So this is suspicious. It's better to explain like, we need make sure =
A
> >> must be done after B.
> > OK. I see. It's used to protect this pattern:
> >
> >     vduse_domain_alloc_bounce_page:          vduse_domain_map_page:
> >     write map->bounce_page                           write map->orig_ph=
ys
> >     mb()                                                            mb(=
)
> >     read map->orig_phys                                 read map->bounc=
e_page
> >
> > Make sure there will always be a path to do bouncing.
>
>
> Ok.
>
>
> >
> >> And it looks to me the iotlb_lock is sufficnet to do the synchronizati=
on
> >> here. E.g any reason that you don't take it in
> >> vduse_domain_map_bounce_page().
> >>
> > Yes, we can. But the performance in multi-queue cases will go down if
> > we use iotlb_lock on this critical path.
> >
> >> And what's more, is there anyway to aovid holding the spinlock during
> >> bouncing?
> >>
> > Looks like we can't. In the case that multiple page faults happen on
> > the same page, we should make sure the bouncing is done before any
> > page fault handler returns.
>
>
> So it looks to me all those extra complexitiy comes from the fact that
> the bounce_page and orig_phys are set by different places so we need to
> do the bouncing in two places.
>
> I wonder how much we can gain from the "lazy" boucning in page fault.
> The buffer mapped via dma_ops from virtio driver is expected to be
> accessed by the userspace soon.  It looks to me we can do all those
> stuffs during dma_map() then things would be greatly simplified.
>

If so, we need to allocate lots of pages from the pool reserved for
atomic memory allocation requests.

Thanks,
Yongji
