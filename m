Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D422FCC1D
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729178AbhATHyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:54:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729396AbhATHxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:53:22 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D671C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:52:29 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b21so15778757edy.6
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0wlE8FV5lzaneIartyPRtJqAIxLA96GGM1g0vnPU4G0=;
        b=NNJ4K0QYEbLehxOPGKyOmOW4zM0/IB6SaEdgfuP7iShtjqLMi54c3NX8rlDX+E8ch1
         gvclSuM98dOSIIphO9DdJLF+GL5+RoxH6vSq0hHxdnU1iSCfprgVHwGI0MS/ZIpwRJ2A
         T5JFbmbouMSerFVSQRXUgQS2A5t1FHEwAwtnOtcEVKC+2O995SrWkeG3Z/qfh2F29e+h
         /xLbmAi4fucS6QbSwlSXd94Qe//A/3rFGGKaZ5ODnYxpI0m22pHXJ3w/tFotX3WivXuK
         xWAfj7MyjUfbUNP+BIas292ZLo7YcyChhpl2qhfV6+iwFuNzP8VRVMYK1OqKSh3Rzbbz
         Rmug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0wlE8FV5lzaneIartyPRtJqAIxLA96GGM1g0vnPU4G0=;
        b=PNJHvQjxBU9RT0XD2+0BY85YE9Hc8MtLjN7lzzYm6bTX/0zvGWeKKoxf/IsnkxZy5q
         gyirzw374L00FHXJBa/Uh3ZxAVW/wn83qJPRm9y5pjGFJl66y/s3p2DIW4wysJ9nZylh
         MxdDrTZUQfpc2ki+fv8/uwDwAuFYA+Ba8gpZzmCSIYCCaD8JMqRAjGlBA4yQiCjgvUsj
         L1CO7LNUgAN8TmGzaWSKqRqrJAtM32ASN0OTli0PDZq+eXLTFTwvhEbedv4+uyrcaNZd
         qBPrZzhy3deyqGfqTNExPbu7mLl4H89wPBtTG4o0JSegVgtFn3yZbcXPLctWpO14mIO8
         1olw==
X-Gm-Message-State: AOAM5310FtAg5qdDXk3SIYR1/QyR5AjfBwYqSVJb0LidM4izu7iIq1O8
        AI1pzN/9dBLLHo5nBJZejGTDRl517p7cmipJ6jXp
X-Google-Smtp-Source: ABdhPJycbl7lAUAgys1T7sbhXDX9Od1N3CGkYmycWQ/Bs8W1xYIxwqsvQaD1wBLJnV1RkYZMXWGzeNq0ryhOokeQBTs=
X-Received: by 2002:a05:6402:228a:: with SMTP id cw10mr6206641edb.195.1611129147633;
 Tue, 19 Jan 2021 23:52:27 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-7-xieyongji@bytedance.com>
 <455fe36a-23a2-5720-a721-8ae46515186b@redhat.com>
In-Reply-To: <455fe36a-23a2-5720-a721-8ae46515186b@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 15:52:16 +0800
Message-ID: <CACycT3voF9x4o95XtLtkKF-i261JXMMsYR1PgssYFwg15jZXQA@mail.gmail.com>
Subject: Re: Re: [RFC v3 06/11] vhost-vdpa: Add an opaque pointer for vhost IOTLB
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, sgarzare@redhat.com,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, bcrl@kvack.org, Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 2:24 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> > Add an opaque pointer for vhost IOTLB to store the
> > corresponding vma->vm_file and offset on the DMA mapping.
>
>
> Let's split the patch into two.
>
> 1) opaque pointer
> 2) vma stuffs
>

OK.

>
> >
> > It will be used in VDUSE case later.
> >
> > Suggested-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++---
> >   drivers/vhost/iotlb.c            |  5 ++-
> >   drivers/vhost/vdpa.c             | 66 +++++++++++++++++++++++++++++++=
++++-----
> >   drivers/vhost/vhost.c            |  4 +--
> >   include/linux/vdpa.h             |  3 +-
> >   include/linux/vhost_iotlb.h      |  8 ++++-
> >   6 files changed, 79 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index 03c796873a6b..1ffcef67954f 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -279,7 +279,7 @@ static dma_addr_t vdpasim_map_page(struct device *d=
ev, struct page *page,
> >        */
> >       spin_lock(&vdpasim->iommu_lock);
> >       ret =3D vhost_iotlb_add_range(iommu, pa, pa + size - 1,
> > -                                 pa, dir_to_perm(dir));
> > +                                 pa, dir_to_perm(dir), NULL);
>
>
> Maybe its better to introduce
>
> vhost_iotlb_add_range_ctx() which can accepts the opaque (context). And
> let vhost_iotlb_add_range() just call that.
>

If so, we need export both vhost_iotlb_add_range() and
vhost_iotlb_add_range_ctx() which will be used in VDUSE driver. Is it
a bit redundant?

>
> >       spin_unlock(&vdpasim->iommu_lock);
> >       if (ret)
> >               return DMA_MAPPING_ERROR;
> > @@ -317,7 +317,7 @@ static void *vdpasim_alloc_coherent(struct device *=
dev, size_t size,
> >
> >               ret =3D vhost_iotlb_add_range(iommu, (u64)pa,
> >                                           (u64)pa + size - 1,
> > -                                         pa, VHOST_MAP_RW);
> > +                                         pa, VHOST_MAP_RW, NULL);
> >               if (ret) {
> >                       *dma_addr =3D DMA_MAPPING_ERROR;
> >                       kfree(addr);
> > @@ -625,7 +625,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa=
,
> >       for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> >            map =3D vhost_iotlb_itree_next(map, start, last)) {
> >               ret =3D vhost_iotlb_add_range(vdpasim->iommu, map->start,
> > -                                         map->last, map->addr, map->pe=
rm);
> > +                                         map->last, map->addr,
> > +                                         map->perm, NULL);
> >               if (ret)
> >                       goto err;
> >       }
> > @@ -639,14 +640,14 @@ static int vdpasim_set_map(struct vdpa_device *vd=
pa,
> >   }
> >
> >   static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 si=
ze,
> > -                        u64 pa, u32 perm)
> > +                        u64 pa, u32 perm, void *opaque)
> >   {
> >       struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >       int ret;
> >
> >       spin_lock(&vdpasim->iommu_lock);
> >       ret =3D vhost_iotlb_add_range(vdpasim->iommu, iova, iova + size -=
 1, pa,
> > -                                 perm);
> > +                                 perm, NULL);
> >       spin_unlock(&vdpasim->iommu_lock);
> >
> >       return ret;
> > diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> > index 0fd3f87e913c..3bd5bd06cdbc 100644
> > --- a/drivers/vhost/iotlb.c
> > +++ b/drivers/vhost/iotlb.c
> > @@ -42,13 +42,15 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
> >    * @last: last of IOVA range
> >    * @addr: the address that is mapped to @start
> >    * @perm: access permission of this range
> > + * @opaque: the opaque pointer for the IOTLB mapping
> >    *
> >    * Returns an error last is smaller than start or memory allocation
> >    * fails
> >    */
> >   int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
> >                         u64 start, u64 last,
> > -                       u64 addr, unsigned int perm)
> > +                       u64 addr, unsigned int perm,
> > +                       void *opaque)
> >   {
> >       struct vhost_iotlb_map *map;
> >
> > @@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
> >       map->last =3D last;
> >       map->addr =3D addr;
> >       map->perm =3D perm;
> > +     map->opaque =3D opaque;
> >
> >       iotlb->nmaps++;
> >       vhost_iotlb_itree_insert(map, &iotlb->root);
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 36b6950ba37f..e83e5be7cec8 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -488,6 +488,7 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdp=
a *v, u64 start, u64 last)
> >       struct vhost_dev *dev =3D &v->vdev;
> >       struct vdpa_device *vdpa =3D v->vdpa;
> >       struct vhost_iotlb *iotlb =3D dev->iotlb;
> > +     struct vhost_iotlb_file *iotlb_file;
> >       struct vhost_iotlb_map *map;
> >       struct page *page;
> >       unsigned long pfn, pinned;
> > @@ -504,6 +505,10 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vd=
pa *v, u64 start, u64 last)
> >                       }
> >                       atomic64_sub(map->size >> PAGE_SHIFT,
> >                                       &dev->mm->pinned_vm);
> > +             } else if (map->opaque) {
> > +                     iotlb_file =3D (struct vhost_iotlb_file *)map->op=
aque;
> > +                     fput(iotlb_file->file);
> > +                     kfree(iotlb_file);
> >               }
> >               vhost_iotlb_map_free(iotlb, map);
> >       }
> > @@ -540,8 +545,8 @@ static int perm_to_iommu_flags(u32 perm)
> >       return flags | IOMMU_CACHE;
> >   }
> >
> > -static int vhost_vdpa_map(struct vhost_vdpa *v,
> > -                       u64 iova, u64 size, u64 pa, u32 perm)
> > +static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
> > +                       u64 size, u64 pa, u32 perm, void *opaque)
> >   {
> >       struct vhost_dev *dev =3D &v->vdev;
> >       struct vdpa_device *vdpa =3D v->vdpa;
> > @@ -549,12 +554,12 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> >       int r =3D 0;
> >
> >       r =3D vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> > -                               pa, perm);
> > +                               pa, perm, opaque);
> >       if (r)
> >               return r;
> >
> >       if (ops->dma_map) {
> > -             r =3D ops->dma_map(vdpa, iova, size, pa, perm);
> > +             r =3D ops->dma_map(vdpa, iova, size, pa, perm, opaque);
> >       } else if (ops->set_map) {
> >               if (!v->in_batch)
> >                       r =3D ops->set_map(vdpa, dev->iotlb);
> > @@ -591,6 +596,51 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,=
 u64 iova, u64 size)
> >       }
> >   }
> >
> > +static int vhost_vdpa_sva_map(struct vhost_vdpa *v,
> > +                           u64 iova, u64 size, u64 uaddr, u32 perm)
> > +{
> > +     u64 offset, map_size, map_iova =3D iova;
> > +     struct vhost_iotlb_file *iotlb_file;
> > +     struct vm_area_struct *vma;
> > +     int ret;
>
>
> Lacking mmap_read_lock().
>

Good catch! Will fix it.

>
> > +
> > +     while (size) {
> > +             vma =3D find_vma(current->mm, uaddr);
> > +             if (!vma) {
> > +                     ret =3D -EINVAL;
> > +                     goto err;
> > +             }
> > +             map_size =3D min(size, vma->vm_end - uaddr);
> > +             offset =3D (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->v=
m_start;
> > +             iotlb_file =3D NULL;
> > +             if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
>
>
> I wonder if we need more strict check here. When developing vhost-vdpa,
> I try hard to make sure the map can only work for user pages.
>
> So the question is: do we need to exclude MMIO area or only allow shmem
> to work here?
>

Do you mean we need to check VM_MIXEDMAP | VM_PFNMAP here?

It makes sense to me.

>
>
> > +                     iotlb_file =3D kmalloc(sizeof(*iotlb_file), GFP_K=
ERNEL);
> > +                     if (!iotlb_file) {
> > +                             ret =3D -ENOMEM;
> > +                             goto err;
> > +                     }
> > +                     iotlb_file->file =3D get_file(vma->vm_file);
> > +                     iotlb_file->offset =3D offset;
> > +             }
>
>
> I wonder if it's better to allocate iotlb_file and make iotlb_file->file
> =3D NULL && iotlb_file->offset =3D 0. This can force a consistent code fo=
r
> the vDPA parents.
>

Looks fine to me.

> Or we can simply fail the map without a file as backend.
>

Actually there will be some vma without vm_file during vm booting.

>
> > +             ret =3D vhost_vdpa_map(v, map_iova, map_size, uaddr,
> > +                                     perm, iotlb_file);
> > +             if (ret) {
> > +                     if (iotlb_file) {
> > +                             fput(iotlb_file->file);
> > +                             kfree(iotlb_file);
> > +                     }
> > +                     goto err;
> > +             }
> > +             size -=3D map_size;
> > +             uaddr +=3D map_size;
> > +             map_iova +=3D map_size;
> > +     }
> > +     return 0;
> > +err:
> > +     vhost_vdpa_unmap(v, iova, map_iova - iova);
> > +     return ret;
> > +}
> > +
> >   static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> >                                          struct vhost_iotlb_msg *msg)
> >   {
> > @@ -615,8 +665,8 @@ static int vhost_vdpa_process_iotlb_update(struct v=
host_vdpa *v,
> >               return -EEXIST;
> >
> >       if (vdpa->sva)
> > -             return vhost_vdpa_map(v, msg->iova, msg->size,
> > -                                   msg->uaddr, msg->perm);
> > +             return vhost_vdpa_sva_map(v, msg->iova, msg->size,
> > +                                       msg->uaddr, msg->perm);
>
>
> So I think it's better squash vhost_vdpa_sva_map() and related changes
> into previous patch.
>

OK, so the order of the patches is:
1) opaque pointer
2) va support + vma stuffs?

Is it OK?

>
> >
> >       /* Limit the use of memory for bookkeeping */
> >       page_list =3D (struct page **) __get_free_page(GFP_KERNEL);
> > @@ -671,7 +721,7 @@ static int vhost_vdpa_process_iotlb_update(struct v=
host_vdpa *v,
> >                               csize =3D (last_pfn - map_pfn + 1) << PAG=
E_SHIFT;
> >                               ret =3D vhost_vdpa_map(v, iova, csize,
> >                                                    map_pfn << PAGE_SHIF=
T,
> > -                                                  msg->perm);
> > +                                                  msg->perm, NULL);
> >                               if (ret) {
> >                                       /*
> >                                        * Unpin the pages that are left =
unmapped
> > @@ -700,7 +750,7 @@ static int vhost_vdpa_process_iotlb_update(struct v=
host_vdpa *v,
> >
> >       /* Pin the rest chunk */
> >       ret =3D vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_=
SHIFT,
> > -                          map_pfn << PAGE_SHIFT, msg->perm);
> > +                          map_pfn << PAGE_SHIFT, msg->perm, NULL);
> >   out:
> >       if (ret) {
> >               if (nchunks) {
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index a262e12c6dc2..120dd5b3c119 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -1104,7 +1104,7 @@ static int vhost_process_iotlb_msg(struct vhost_d=
ev *dev,
> >               vhost_vq_meta_reset(dev);
> >               if (vhost_iotlb_add_range(dev->iotlb, msg->iova,
> >                                         msg->iova + msg->size - 1,
> > -                                       msg->uaddr, msg->perm)) {
> > +                                       msg->uaddr, msg->perm, NULL)) {
> >                       ret =3D -ENOMEM;
> >                       break;
> >               }
> > @@ -1450,7 +1450,7 @@ static long vhost_set_memory(struct vhost_dev *d,=
 struct vhost_memory __user *m)
> >                                         region->guest_phys_addr +
> >                                         region->memory_size - 1,
> >                                         region->userspace_addr,
> > -                                       VHOST_MAP_RW))
> > +                                       VHOST_MAP_RW, NULL))
> >                       goto err;
> >       }
> >
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index f86869651614..b264c627e94b 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -189,6 +189,7 @@ struct vdpa_iova_range {
> >    *                          @size: size of the area
> >    *                          @pa: physical address for the map
> >    *                          @perm: device access permission (VHOST_MA=
P_XX)
> > + *                           @opaque: the opaque pointer for the mappi=
ng
> >    *                          Returns integer: success (0) or error (< =
0)
> >    * @dma_unmap:                      Unmap an area of IOVA (optional b=
ut
> >    *                          must be implemented with dma_map)
> > @@ -243,7 +244,7 @@ struct vdpa_config_ops {
> >       /* DMA ops */
> >       int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotl=
b);
> >       int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> > -                    u64 pa, u32 perm);
> > +                    u64 pa, u32 perm, void *opaque);
> >       int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
> >
> >       /* Free device resources */
> > diff --git a/include/linux/vhost_iotlb.h b/include/linux/vhost_iotlb.h
> > index 6b09b786a762..66a50c11c8ca 100644
> > --- a/include/linux/vhost_iotlb.h
> > +++ b/include/linux/vhost_iotlb.h
> > @@ -4,6 +4,11 @@
> >
> >   #include <linux/interval_tree_generic.h>
> >
> > +struct vhost_iotlb_file {
> > +     struct file *file;
> > +     u64 offset;
> > +};
>
>
> I think we'd better either:
>
> 1) simply use struct vhost_iotlb_file * instead of void *opaque for
> vhost_iotlb_map
>
> or
>
> 2)rename and move the vhost_iotlb_file to vdpa
>
> 2) looks better since we want to let vhost iotlb to carry any type of
> context (opaque pointer)
>

I agree. So we need to introduce struct vdpa_iotlb_file in
include/linux/vdpa.h, right?

> And if we do this, the modification of vdpa_config_ops deserves a
> separate patch.
>

Sorry, I didn't get you here. What do you mean by the modification of
vdpa_config_ops? Do you mean adding an opaque pointer to ops.dma_map?

Thanks,
Yongji
