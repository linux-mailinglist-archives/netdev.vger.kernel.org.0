Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D02132CC1C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 06:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234172AbhCDFmS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 00:42:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234181AbhCDFl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 00:41:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5766FC061574
        for <netdev@vger.kernel.org>; Wed,  3 Mar 2021 21:41:10 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id b7so19646660edz.8
        for <netdev@vger.kernel.org>; Wed, 03 Mar 2021 21:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=rWsjVB9Em8jxffhCk8PKglKjzOG0xdctw7R4jfAWYpI=;
        b=oMSlvClA0Xjp+3nzrzI82/u22YbIwmbFhpzPoXY6W+FqrMByYHtj0XCrXdbXf7l6f+
         a56w6opganYlF5Pz4JIT7t0RoAd+ZSfBqp0mYEKkKFkIxQif7aisbF/vST2Z9Tedt+BZ
         YDiWuRahr7r5UTmv33b5ml3E3wMJpwcUnDSwMnB0+fz/oPSbbDwqOVq2flqg9+xtA2ei
         LyRyxZj/co14RMyVng8RlkJz30KWpb8t+brQ0XOU/Y8X4omIYsMGVOv5B38mv63GN6Ku
         TOjgtLr0zhCebZe9g92awFMezKg3ksMyywTnukI6noz/QjsPZQVBAdkXCT5kKL68tMjr
         R5NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=rWsjVB9Em8jxffhCk8PKglKjzOG0xdctw7R4jfAWYpI=;
        b=DrQ2FlY8cYQ2xUGc8QBUW6GUULBDxTf8IyS/v8vI1OHY5wFU8drSbqtIP3uRM0UZTi
         pfFmuSDHsuwNLMRFlRcv+qGT82RdfdLn9OfCnLDt6+n3VhR9daSyDVWPZsYjCAzAnyKk
         8A5pnckfWVH4y4GmJl16hxBggHaZVnxyWEfyeUMUpE4sLHrJBym1dxtqm/US05S5WOQO
         vg5bAPUix55zHl1cpF0S6EISiwlICR6Q8OHsv1ve/SowYkdy8gpZhXYZ0hOf73z7Ki8V
         ItDx/SpftNiHRITirZc0jtHeKuh9H0JYajdS8y/Ljzp2YGhwoLDyMPkKg4IH1yK7l61u
         45uw==
X-Gm-Message-State: AOAM5328gD27uNUKp5nTwD08odoX8ePnx2AKfdlvZvJUy5jLxwysAD9G
        n8JMxhJDUcdXTCT0j2cVUMsXtiN8DRcheAo4rUAv
X-Google-Smtp-Source: ABdhPJyauXZFmD5zPpOL119+bKvzohfB/5QeMWrK+gxkxy5IEI0PGVP7ms1tAAHI6iSOChrlYRZBLWVhi3HjqN/+uDE=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr2443472edc.5.1614836469003;
 Wed, 03 Mar 2021 21:41:09 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-6-xieyongji@bytedance.com>
 <9a00b494-bcea-c874-4d3d-5378b62a8913@redhat.com>
In-Reply-To: <9a00b494-bcea-c874-4d3d-5378b62a8913@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 4 Mar 2021 13:40:58 +0800
Message-ID: <CACycT3s7MMWDiwOC2XFSupbG9-f3WqtxzS4yfyYKhbC39JyF9g@mail.gmail.com>
Subject: Re: Re: [RFC v4 05/11] vdpa: Support transferring virtual addressing
 during DMA mapping
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

On Thu, Mar 4, 2021 at 11:07 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> > This patch introduces an attribute for vDPA device to indicate
> > whether virtual address can be used. If vDPA device driver set
> > it, vhost-vdpa bus driver will not pin user page and transfer
> > userspace virtual address instead of physical address during
> > DMA mapping. And corresponding vma->vm_file and offset will be
> > also passed as an opaque pointer.
> >
> > Suggested-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vdpa/ifcvf/ifcvf_main.c   |   2 +-
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c |   2 +-
> >   drivers/vdpa/vdpa.c               |   9 +++-
> >   drivers/vdpa/vdpa_sim/vdpa_sim.c  |   2 +-
> >   drivers/vhost/vdpa.c              | 104 +++++++++++++++++++++++++++++=
++-------
> >   include/linux/vdpa.h              |  20 ++++++--
> >   6 files changed, 113 insertions(+), 26 deletions(-)
> >
> > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf=
_main.c
> > index 7c8bbfcf6c3e..228b9f920fea 100644
> > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > @@ -432,7 +432,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
> >
> >       adapter =3D vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> >                                   dev, &ifc_vdpa_ops,
> > -                                 IFCVF_MAX_QUEUE_PAIRS * 2, NULL);
> > +                                 IFCVF_MAX_QUEUE_PAIRS * 2, NULL, fals=
e);
> >       if (adapter =3D=3D NULL) {
> >               IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
> >               return -ENOMEM;
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 029822060017..54290438da28 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1964,7 +1964,7 @@ static int mlx5v_probe(struct auxiliary_device *a=
dev,
> >       max_vqs =3D min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
> >
> >       ndev =3D vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev=
->device, &mlx5_vdpa_ops,
> > -                              2 * mlx5_vdpa_max_qps(max_vqs), NULL);
> > +                              2 * mlx5_vdpa_max_qps(max_vqs), NULL, fa=
lse);
> >       if (IS_ERR(ndev))
> >               return PTR_ERR(ndev);
> >
> > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > index 9700a0adcca0..fafc0ee5eb05 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
> >    * @nvqs: number of virtqueues supported by this device
> >    * @size: size of the parent structure that contains private data
> >    * @name: name of the vdpa device; optional.
> > + * @use_va: indicate whether virtual address can be used by this devic=
e
>
>
> I think "use_va" means va must be used instead of "can be" here.
>

Right.

>
> >    *
> >    * Driver should use vdpa_alloc_device() wrapper macro instead of
> >    * using this directly.
> > @@ -81,7 +82,8 @@ static void vdpa_release_dev(struct device *d)
> >    */
> >   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
> >                                       const struct vdpa_config_ops *con=
fig,
> > -                                     int nvqs, size_t size, const char=
 *name)
> > +                                     int nvqs, size_t size, const char=
 *name,
> > +                                     bool use_va)
> >   {
> >       struct vdpa_device *vdev;
> >       int err =3D -EINVAL;
> > @@ -92,6 +94,10 @@ struct vdpa_device *__vdpa_alloc_device(struct devic=
e *parent,
> >       if (!!config->dma_map !=3D !!config->dma_unmap)
> >               goto err;
> >
> > +     /* It should only work for the device that use on-chip IOMMU */
> > +     if (use_va && !(config->dma_map || config->set_map))
> > +             goto err;
> > +
> >       err =3D -ENOMEM;
> >       vdev =3D kzalloc(size, GFP_KERNEL);
> >       if (!vdev)
> > @@ -108,6 +114,7 @@ struct vdpa_device *__vdpa_alloc_device(struct devi=
ce *parent,
> >       vdev->config =3D config;
> >       vdev->features_valid =3D false;
> >       vdev->nvqs =3D nvqs;
> > +     vdev->use_va =3D use_va;
> >
> >       if (name)
> >               err =3D dev_set_name(&vdev->dev, "%s", name);
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index 5cfc262ce055..3a9a2dd4e987 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_a=
ttr *dev_attr)
> >               ops =3D &vdpasim_config_ops;
> >
> >       vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> > -                                 dev_attr->nvqs, dev_attr->name);
> > +                                 dev_attr->nvqs, dev_attr->name, false=
);
> >       if (!vdpasim)
> >               goto err_alloc;
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 70857fe3263c..93769ace34df 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -480,21 +480,31 @@ static long vhost_vdpa_unlocked_ioctl(struct file=
 *filep,
> >   static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u=
64 last)
> >   {
> >       struct vhost_dev *dev =3D &v->vdev;
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> >       struct vhost_iotlb *iotlb =3D dev->iotlb;
> >       struct vhost_iotlb_map *map;
> > +     struct vdpa_map_file *map_file;
> >       struct page *page;
> >       unsigned long pfn, pinned;
> >
> >       while ((map =3D vhost_iotlb_itree_first(iotlb, start, last)) !=3D=
 NULL) {
> > -             pinned =3D map->size >> PAGE_SHIFT;
> > -             for (pfn =3D map->addr >> PAGE_SHIFT;
> > -                  pinned > 0; pfn++, pinned--) {
> > -                     page =3D pfn_to_page(pfn);
> > -                     if (map->perm & VHOST_ACCESS_WO)
> > -                             set_page_dirty_lock(page);
> > -                     unpin_user_page(page);
> > +             if (!vdpa->use_va) {
> > +                     pinned =3D map->size >> PAGE_SHIFT;
> > +                     for (pfn =3D map->addr >> PAGE_SHIFT;
> > +                          pinned > 0; pfn++, pinned--) {
> > +                             page =3D pfn_to_page(pfn);
> > +                             if (map->perm & VHOST_ACCESS_WO)
> > +                                     set_page_dirty_lock(page);
> > +                             unpin_user_page(page);
> > +                     }
> > +                     atomic64_sub(map->size >> PAGE_SHIFT,
> > +                                     &dev->mm->pinned_vm);
> > +             } else {
> > +                     map_file =3D (struct vdpa_map_file *)map->opaque;
> > +                     if (map_file->file)
> > +                             fput(map_file->file);
> > +                     kfree(map_file);
> >               }
> > -             atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm=
);
> >               vhost_iotlb_map_free(iotlb, map);
> >       }
> >   }
> > @@ -530,21 +540,21 @@ static int perm_to_iommu_flags(u32 perm)
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
> >       const struct vdpa_config_ops *ops =3D vdpa->config;
> >       int r =3D 0;
> >
> > -     r =3D vhost_iotlb_add_range(dev->iotlb, iova, iova + size - 1,
> > -                               pa, perm);
> > +     r =3D vhost_iotlb_add_range_ctx(dev->iotlb, iova, iova + size - 1=
,
> > +                                   pa, perm, opaque);
> >       if (r)
> >               return r;
> >
> >       if (ops->dma_map) {
> > -             r =3D ops->dma_map(vdpa, iova, size, pa, perm, NULL);
> > +             r =3D ops->dma_map(vdpa, iova, size, pa, perm, opaque);
> >       } else if (ops->set_map) {
> >               if (!v->in_batch)
> >                       r =3D ops->set_map(vdpa, dev->iotlb);
> > @@ -552,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
> >               r =3D iommu_map(v->domain, iova, pa, size,
> >                             perm_to_iommu_flags(perm));
> >       }
> > -
> > -     if (r)
> > +     if (r) {
> >               vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
> > -     else
> > +             return r;
> > +     }
> > +
> > +     if (!vdpa->use_va)
> >               atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
> >
> > -     return r;
> > +     return 0;
> >   }
> >
> >   static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size=
)
> > @@ -579,10 +591,60 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v=
, u64 iova, u64 size)
> >       }
> >   }
> >
> > +static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> > +                          u64 iova, u64 size, u64 uaddr, u32 perm)
> > +{
> > +     struct vhost_dev *dev =3D &v->vdev;
> > +     u64 offset, map_size, map_iova =3D iova;
> > +     struct vdpa_map_file *map_file;
> > +     struct vm_area_struct *vma;
> > +     int ret;
> > +
> > +     mmap_read_lock(dev->mm);
> > +
> > +     while (size) {
> > +             vma =3D find_vma(dev->mm, uaddr);
> > +             if (!vma) {
> > +                     ret =3D -EINVAL;
> > +                     goto err;
> > +             }
> > +             map_size =3D min(size, vma->vm_end - uaddr);
> > +             offset =3D (vma->vm_pgoff << PAGE_SHIFT) + uaddr - vma->v=
m_start;
> > +             map_file =3D kzalloc(sizeof(*map_file), GFP_KERNEL);
> > +             if (!map_file) {
> > +                     ret =3D -ENOMEM;
> > +                     goto err;
> > +             }
> > +             if (vma->vm_file && (vma->vm_flags & VM_SHARED) &&
> > +                     !(vma->vm_flags & (VM_IO | VM_PFNMAP))) {
> > +                     map_file->file =3D get_file(vma->vm_file);
> > +                     map_file->offset =3D offset;
> > +             }
>
>
> I think it's better to do the flag check right after find_vma(), this
> can avoid things like kfree etc (e.g the code will still call
> vhost_vdpa_map() even if the flag is not expected now).
>

Make sense to me.

>
> > +             ret =3D vhost_vdpa_map(v, map_iova, map_size, uaddr,
> > +                                  perm, map_file);
> > +             if (ret) {
> > +                     if (map_file->file)
> > +                             fput(map_file->file);
> > +                     kfree(map_file);
> > +                     goto err;
> > +             }
> > +             size -=3D map_size;
> > +             uaddr +=3D map_size;
> > +             map_iova +=3D map_size;
> > +     }
> > +     mmap_read_unlock(dev->mm);
> > +
> > +     return 0;
> > +err:
> > +     vhost_vdpa_unmap(v, iova, map_iova - iova);
> > +     return ret;
> > +}
> > +
> >   static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
> >                                          struct vhost_iotlb_msg *msg)
> >   {
> >       struct vhost_dev *dev =3D &v->vdev;
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> >       struct vhost_iotlb *iotlb =3D dev->iotlb;
> >       struct page **page_list;
> >       unsigned long list_size =3D PAGE_SIZE / sizeof(struct page *);
> > @@ -601,6 +663,10 @@ static int vhost_vdpa_process_iotlb_update(struct =
vhost_vdpa *v,
> >                                   msg->iova + msg->size - 1))
> >               return -EEXIST;
> >
> > +     if (vdpa->use_va)
> > +             return vhost_vdpa_va_map(v, msg->iova, msg->size,
> > +                                      msg->uaddr, msg->perm);
>
>
> If possible, I would like to factor out the pa map below into a
> something like vhost_vdpa_pa_map() first with a separated patch. Then
> introduce vhost_vdpa_va_map().
>

Fine, will do it.

Thanks,
Yongji
