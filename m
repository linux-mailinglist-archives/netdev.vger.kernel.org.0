Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3E93056FF
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 10:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhA0Jai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 04:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhA0J2P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 04:28:15 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6AA4C061573
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:27:34 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id kg20so1671623ejc.4
        for <netdev@vger.kernel.org>; Wed, 27 Jan 2021 01:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=QQ2YJYnqZf1PSQHH//Bvh9ntbh1hJnDMr5nSkJAWkxA=;
        b=iVdlagRI8umriHxb6OzI3FohA/TnX+jobiF4LVQt9CWM1iSpECk+XISQF3ciHixaAs
         OLUIduw4IPaPKo98QfBiPXfibOwW+fL6IRicc118QHHnK9vOGlj7R8F0V09iAHdO7XAB
         Q88NagvaVhbX6ZNpH24b/RZcNt8rfkFK9IjSHvafa4lxq3ULXHhDG42mMIyS8GmmFDFA
         O7ANaoodqNqIq5YRUWFG1DfmYnFlVjycM486QSSdgGwxAlXJq42VqDfEwApN8UIvRK81
         zgiz8EnVvgttjGyo3bpUxlhQqaYgm8sg3ljLrA8GetkhP+VzEewF2nhIoIZ5weKkxwFd
         Bj0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QQ2YJYnqZf1PSQHH//Bvh9ntbh1hJnDMr5nSkJAWkxA=;
        b=p+RlQUpFUmz+clPNdby9cZ9vH5MkD2nBkHk3DkVIgZLaRYoBIenUxvIOj9/rfcxFe5
         rv5+hHSz+QKeHlJpLewYIORyDtYiLaWWeAr/0jY5VUC/z91KEGwd5bA2nMb+dTV5SWFK
         B0F4NdFzkW/785kfP9Kg86t4QaO8HryLqzsM5qkGFfM435aDi67F0prJXt0IM56G/WHt
         Gxa9Mv1ai8bGh8QX49Td8+9jW2kzBQej1ANJbyooVevh00wNrAEZIvklppId2g/kbFRc
         EiDrjbNclyDsPku34uhFPR8PzxKx90em1DZQIl5xJbrjp7+Cq0QGncAMKEgrConzh4rJ
         kkjA==
X-Gm-Message-State: AOAM5303icyPgj5Ts/AfYL89UEEI1M8RWAXSPRs8ZI0WLUkHxay2VQ/9
        z4hX4Nm+sYKHRHEvJCPTsSVoOezwr8FJunpTFrpI
X-Google-Smtp-Source: ABdhPJykffUoMrepE5gCsJFpw9/F05oEBzce3YK1VRsAN6vUpYNqu/l/QdbeA0KC9/avUXftGAM7hutVOz5DimQEPps=
X-Received: by 2002:a17:906:1796:: with SMTP id t22mr5910082eje.372.1611739653464;
 Wed, 27 Jan 2021 01:27:33 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-7-xieyongji@bytedance.com>
 <455fe36a-23a2-5720-a721-8ae46515186b@redhat.com> <CACycT3voF9x4o95XtLtkKF-i261JXMMsYR1PgssYFwg15jZXQA@mail.gmail.com>
 <8b7d0b11-a206-7290-4a79-c1268538fea9@redhat.com>
In-Reply-To: <8b7d0b11-a206-7290-4a79-c1268538fea9@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 27 Jan 2021 17:27:22 +0800
Message-ID: <CACycT3uZ0mhqNunn1ZJxT3FzKCWact=eK8DK0Rg2CogYOrHLOQ@mail.gmail.com>
Subject: Re: Re: [RFC v3 06/11] vhost-vdpa: Add an opaque pointer for vhost IOTLB
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
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

On Wed, Jan 27, 2021 at 11:51 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/20 =E4=B8=8B=E5=8D=883:52, Yongji Xie wrote:
> > On Wed, Jan 20, 2021 at 2:24 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> >>> Add an opaque pointer for vhost IOTLB to store the
> >>> corresponding vma->vm_file and offset on the DMA mapping.
> >>
> >> Let's split the patch into two.
> >>
> >> 1) opaque pointer
> >> 2) vma stuffs
> >>
> > OK.
> >
> >>> It will be used in VDUSE case later.
> >>>
> >>> Suggested-by: Jason Wang <jasowang@redhat.com>
> >>> Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> >>> ---
> >>>    drivers/vdpa/vdpa_sim/vdpa_sim.c | 11 ++++---
> >>>    drivers/vhost/iotlb.c            |  5 ++-
> >>>    drivers/vhost/vdpa.c             | 66 ++++++++++++++++++++++++++++=
+++++++-----
> >>>    drivers/vhost/vhost.c            |  4 +--
> >>>    include/linux/vdpa.h             |  3 +-
> >>>    include/linux/vhost_iotlb.h      |  8 ++++-
> >>>    6 files changed, 79 insertions(+), 18 deletions(-)
> >>>
> >>> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim=
/vdpa_sim.c
> >>> index 03c796873a6b..1ffcef67954f 100644
> >>> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >>> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> >>> @@ -279,7 +279,7 @@ static dma_addr_t vdpasim_map_page(struct device =
*dev, struct page *page,
> >>>         */
> >>>        spin_lock(&vdpasim->iommu_lock);
> >>>        ret =3D vhost_iotlb_add_range(iommu, pa, pa + size - 1,
> >>> -                                 pa, dir_to_perm(dir));
> >>> +                                 pa, dir_to_perm(dir), NULL);
> >>
> >> Maybe its better to introduce
> >>
> >> vhost_iotlb_add_range_ctx() which can accepts the opaque (context). An=
d
> >> let vhost_iotlb_add_range() just call that.
> >>
> > If so, we need export both vhost_iotlb_add_range() and
> > vhost_iotlb_add_range_ctx() which will be used in VDUSE driver. Is it
> > a bit redundant?
>
>
> Probably not, we do something similar in virtio core:
>
> void *virtqueue_get_buf_ctx(struct virtqueue *_vq, unsigned int *len,
>                  void **ctx)
> {
>      struct vring_virtqueue *vq =3D to_vvq(_vq);
>
>      return vq->packed_ring ? virtqueue_get_buf_ctx_packed(_vq, len, ctx)=
 :
>                   virtqueue_get_buf_ctx_split(_vq, len, ctx);
> }
> EXPORT_SYMBOL_GPL(virtqueue_get_buf_ctx);
>
> void *virtqueue_get_buf(struct virtqueue *_vq, unsigned int *len)
> {
>      return virtqueue_get_buf_ctx(_vq, len, NULL);
> }
> EXPORT_SYMBOL_GPL(virtqueue_get_buf);
>

I see. Will do it in the next version.

>
> >
> >>>        spin_unlock(&vdpasim->iommu_lock);
> >>>        if (ret)
> >>>                return DMA_MAPPING_ERROR;
> >>> @@ -317,7 +317,7 @@ static void *vdpasim_alloc_coherent(struct device=
 *dev, size_t size,
> >>>
> >>>                ret =3D vhost_iotlb_add_range(iommu, (u64)pa,
> >>>                                            (u64)pa + size - 1,
> >>> -                                         pa, VHOST_MAP_RW);
> >>> +                                         pa, VHOST_MAP_RW, NULL);
> >>>                if (ret) {
> >>>                        *dma_addr =3D DMA_MAPPING_ERROR;
> >>>                        kfree(addr);
> >>> @@ -625,7 +625,8 @@ static int vdpasim_set_map(struct vdpa_device *vd=
pa,
> >>>        for (map =3D vhost_iotlb_itree_first(iotlb, start, last); map;
> >>>             map =3D vhost_iotlb_itree_next(map, start, last)) {
> >>>                ret =3D vhost_iotlb_add_range(vdpasim->iommu, map->sta=
rt,
> >>> -                                         map->last, map->addr, map->=
perm);
> >>> +                                         map->last, map->addr,
> >>> +                                         map->perm, NULL);
> >>>                if (ret)
> >>>                        goto err;
> >>>        }
> >>> @@ -639,14 +640,14 @@ static int vdpasim_set_map(struct vdpa_device *=
vdpa,
> >>>    }
> >>>
> >>>    static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64=
 size,
> >>> -                        u64 pa, u32 perm)
> >>> +                        u64 pa, u32 perm, void *opaque)
> >>>    {
> >>>        struct vdpasim *vdpasim =3D vdpa_to_sim(vdpa);
> >>>        int ret;
> >>>
> >>>        spin_lock(&vdpasim->iommu_lock);
> >>>        ret =3D vhost_iotlb_add_range(vdpasim->iommu, iova, iova + siz=
e - 1, pa,
> >>> -                                 perm);
> >>> +                                 perm, NULL);
> >>>        spin_unlock(&vdpasim->iommu_lock);
> >>>
> >>>        return ret;
> >>> diff --git a/drivers/vhost/iotlb.c b/drivers/vhost/iotlb.c
> >>> index 0fd3f87e913c..3bd5bd06cdbc 100644
> >>> --- a/drivers/vhost/iotlb.c
> >>> +++ b/drivers/vhost/iotlb.c
> >>> @@ -42,13 +42,15 @@ EXPORT_SYMBOL_GPL(vhost_iotlb_map_free);
> >>>     * @last: last of IOVA range
> >>>     * @addr: the address that is mapped to @start
> >>>     * @perm: access permission of this range
> >>> + * @opaque: the opaque pointer for the IOTLB mapping
> >>>     *
> >>>     * Returns an error last is smaller than start or memory allocatio=
n
> >>>     * fails
> >>>     */
> >>>    int vhost_iotlb_add_range(struct vhost_iotlb *iotlb,
> >>>                          u64 start, u64 last,
> >>> -                       u64 addr, unsigned int perm)
> >>> +                       u64 addr, unsigned int perm,
> >>> +                       void *opaque)
> >>>    {
> >>>        struct vhost_iotlb_map *map;
> >>>
> >>> @@ -71,6 +73,7 @@ int vhost_iotlb_add_range(struct vhost_iotlb *iotlb=
,
> >>>        map->last =3D last;
> >>>        map->addr =3D addr;
> >>>        map->perm =3D perm;
> >>> +     map->opaque =3D opaque;
> >>>
> >>>        iotlb->nmaps++;
> >>>        vhost_iotlb_itree_insert(map, &iotlb->root);
> >>> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> >>> index 36b6950ba37f..e83e5be7cec8 100644
> >>> --- a/drivers/vhost/vdpa.c
> >>> +++ b/drivers/vhost/vdpa.c
> >>> @@ -488,6 +488,7 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_v=
dpa *v, u64 start, u64 last)
> >>>        struct vhost_dev *dev =3D &v->vdev;
> >>>        struct vdpa_device *vdpa =3D v->vdpa;
> >>>        struct vhost_iotlb *iotlb =3D dev->iotlb;
> >>> +     struct vhost_iotlb_file *iotlb_file;
> >>>        struct vhost_iotlb_map *map;
> >>>        struct page *page;
> >>>        unsigned long pfn, pinned;
> >>> @@ -504,6 +505,10 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_=
vdpa *v, u64 start, u64 last)
> >>>                        }
> >>>                        atomic64_sub(map->size >> PAGE_SHIFT,
> >>>                                        &dev->mm->pinned_vm);
> >>> +             } else if (map->opaque) {
> >>> +                     iotlb_file =3D (struct vhost_iotlb_file *)map->=
opaque;
> >>> +                     fput(iotlb_file->file);
> >>> +                     kfree(iotlb_file);
> >>>                }
> >>>                vhost_iotlb_map_free(iotlb, map);
> >>>        }
> >>> @@ -540,8 +545,8 @@ static int perm_to_iommu_flags(u32 perm)
> >>>        return flags | IOMMU_CACHE;
> >>>    }
> >>>
> >>> -static int vhost_vdpa_map(struct vhost_vdpa *v,
> >>> -                       u64 iova, u64 size, u64 pa, u32 perm)
> >>> +static int vhost_vdpa_map(struct vhost_vdpa *v, u64 iova,
> >>> +                       u64 size, u64 pa, u32 perm, void *opaque)
> >>>    {
> >>>        struct vhost_dev *dev =3D &v->vdev;
> >>>        struct vdpa_device *vdpa =3D v->vdpa;
> >>> @@ -549,12 +554,12 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> >>>        int r =3D 0;
> >>>
> >>>        r =3D vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> >>> -                               pa, perm);
> >>> +                               pa, perm, opaque);
> >>>        if (r)
> >>>                return r;
> >>>
> >>>        if (ops->dma_map) {
> >>> -             r =3D ops->dma_map(vdpa, iova, size, pa, perm);
> >>> +             r =3D ops->dma_map(vdpa, iova, size, pa, perm, opaque);
> >>>        } else if (ops->set_map) {
> >>>                if (!v->in_batch)
> >>>                        r =3D ops->set_map(vdpa, dev->iotlb);
> >>> @@ -591,6 +596,51 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *=
v, u64 iova, u64 size)
> >>>        }
> >>>    }
> >>>
> >>> +static int vhost_vdpa_sva_map(struct vhost_vdpa *v,
> >>> +                           u64 iova, u64 size, u64 uaddr, u32 perm)
> >>> +{
> >>> +     u64 offset, map_size, map_iova =3D iova;
> >>> +     struct vhost_iotlb_file *iotlb_file;
> >>> +     struct vm_area_struct *vma;
> >>> +     int ret;
> >>
> >> Lacking mmap_read_lock().
> >>
> > Good catch! Will fix it.
> >
> >>> +
> >>> +     while (size) {
> >>> +             vma =3D find_vma(current->mm, uaddr);
> >>> +             if (!vma) {
> >>> +                     ret =3D -EINVAL;
> >>> +                     goto err;
> >>> +             }
> >>> +             map_size =3D min(size, vma->vm_end - uaddr);
> >>> +             offset =3D (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma-=
>vm_start;
> >>> +             iotlb_file =3D NULL;
> >>> +             if (vma->vm_file && (vma->vm_flags & VM_SHARED)) {
> >>
> >> I wonder if we need more strict check here. When developing vhost-vdpa=
,
> >> I try hard to make sure the map can only work for user pages.
> >>
> >> So the question is: do we need to exclude MMIO area or only allow shme=
m
> >> to work here?
> >>
> > Do you mean we need to check VM_MIXEDMAP | VM_PFNMAP here?
>
>
> I meant do we need to allow VM_IO here? (We don't allow such case in
> vhost-vdpa now).
>

OK, let's exclude the vma with VM_IO | VM_PFNMAP.

>
> >
> > It makes sense to me.
> >
> >>
> >>> +                     iotlb_file =3D kmalloc(sizeof(*iotlb_file), GFP=
_KERNEL);
> >>> +                     if (!iotlb_file) {
> >>> +                             ret =3D -ENOMEM;
> >>> +                             goto err;
> >>> +                     }
> >>> +                     iotlb_file->file =3D get_file(vma->vm_file);
> >>> +                     iotlb_file->offset =3D offset;
> >>> +             }
> >>
> >> I wonder if it's better to allocate iotlb_file and make iotlb_file->fi=
le
> >> =3D NULL && iotlb_file->offset =3D 0. This can force a consistent code=
 for
> >> the vDPA parents.
> >>
> > Looks fine to me.
> >
> >> Or we can simply fail the map without a file as backend.
> >>
> > Actually there will be some vma without vm_file during vm booting.
>
>
> Yes, e.g bios or other rom. Vhost-user has the similar issue and they
> filter the out them in qemu.
>
> For vhost-vDPA, consider it can supports various difference backends, we
> can't do that.
>

OK, I will transfer iotlb_file with NULL file and let the backend do
the filtering.

Thanks,
Yongji
