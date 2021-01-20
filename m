Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A152FCB56
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 08:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbhATHLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 02:11:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727122AbhATHLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 02:11:48 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E37AC0613C1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:11:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id n6so9418680edt.10
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 23:11:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=017oWWIlxOT6VivhQTE1Gu4oh0UA53Mgq621dR6TrCw=;
        b=DhcEFXZf9/GwXCjSaJJugCF9/T8eosnex9uUo7fCJhb9U/bEKuac1i2pUWDeCAqFsN
         4rLZcgSTUMmbwM3WeVMoiIhzsbcaytX8TxOarNBww+ITFIH4ErWnA2eu3ZPxJPidiNhw
         jGFRXzYMzYPnFaQSrgSX+zOiZsW3kK04VP9BOkx4cIWq6epgn997K/Ggg7OnNEvR/TaV
         BxTb7OPYFzfMFxNPv7agZtDdjCxpFv/NT5O3vgft8CDomH8n+IBbBkj7aR6qmmOC2MSy
         aBVn2ooIzJHfEeFAKBmW1PDa6CmlYloJkIwXRdojGHDWO3bhzs9gWoVM1AUGDoovAQvI
         rZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=017oWWIlxOT6VivhQTE1Gu4oh0UA53Mgq621dR6TrCw=;
        b=pyAuCOOe7nH7c+l2A3TqJGFdwa/vTRL133AYp019qhxhKbiZJyV08cNOIkCiYWHwK7
         3rDnMcwlKDyZzRHKLkZy9lzVp5JVCIY+mCLr1pW4/ngKeVclY6pbVzYhnlU20/48FDym
         v3io8OxS+av7Xfob8S7FYrG3TXaOXIeUWgX/82Ysky6+EkBK/4iJULcMRhfklrWOoSar
         Ww6vl58LJy/0REG6ZswUnTM9A+/h6PlqR3bR1IeUHg9I3RTfokO0MN1vlY8sLmiWq9xW
         BmqUuoQXa/1ru2FDndtBBYJ+c5FJtfVP+ZMQfab4djqILfzvwLET4q2a/kp3BA6QIXWp
         cq9Q==
X-Gm-Message-State: AOAM531MyYmSwaNd60QluMsxDKMuZJAtJ1IftIRllu+3Fy2FJZrXH++r
        N8zy1xrXCsqfWIW89NnOG3k0W3azIEyo5r1xij5D
X-Google-Smtp-Source: ABdhPJwSiBeJuuQDrdZ4fEW9g9dq5wHp1uj9C97rstkocLBjIyjy5cgwh07ORTk7lR0GXzI9szQBUJmnuhdFA+d1mT8=
X-Received: by 2002:a05:6402:228a:: with SMTP id cw10mr6098248edb.195.1611126666903;
 Tue, 19 Jan 2021 23:11:06 -0800 (PST)
MIME-Version: 1.0
References: <20210119045920.447-1-xieyongji@bytedance.com> <20210119045920.447-6-xieyongji@bytedance.com>
 <3d58d50c-935a-a827-e261-59282f4c8577@redhat.com>
In-Reply-To: <3d58d50c-935a-a827-e261-59282f4c8577@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 20 Jan 2021 15:10:56 +0800
Message-ID: <CACycT3vXCaSc9Er3yzRAzf8-eEFgpQYmEaDy3129xPdb4AFdmA@mail.gmail.com>
Subject: Re: Re: [RFC v3 05/11] vdpa: shared virtual addressing support
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

On Wed, Jan 20, 2021 at 1:55 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/1/19 =E4=B8=8B=E5=8D=8812:59, Xie Yongji wrote:
> > This patches introduces SVA (Shared Virtual Addressing)
> > support for vDPA device. During vDPA device allocation,
> > vDPA device driver needs to indicate whether SVA is
> > supported by the device. Then vhost-vdpa bus driver
> > will not pin user page and transfer userspace virtual
> > address instead of physical address during DMA mapping.
> >
> > Suggested-by: Jason Wang <jasowang@redhat.com>
> > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > ---
> >   drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
> >   drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
> >   drivers/vdpa/vdpa.c               |  5 ++++-
> >   drivers/vdpa/vdpa_sim/vdpa_sim.c  |  3 ++-
> >   drivers/vhost/vdpa.c              | 35 +++++++++++++++++++++++-------=
-----
> >   include/linux/vdpa.h              | 10 +++++++---
> >   6 files changed, 38 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf=
_main.c
> > index 23474af7da40..95c4601f82f5 100644
> > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > @@ -439,7 +439,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const =
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
> > index 77595c81488d..05988d6907f2 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1959,7 +1959,7 @@ static int mlx5v_probe(struct auxiliary_device *a=
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
> > index 32bd48baffab..50cab930b2e5 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -72,6 +72,7 @@ static void vdpa_release_dev(struct device *d)
> >    * @nvqs: number of virtqueues supported by this device
> >    * @size: size of the parent structure that contains private data
> >    * @name: name of the vdpa device; optional.
> > + * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
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
> > +                                     bool sva)
> >   {
> >       struct vdpa_device *vdev;
> >       int err =3D -EINVAL;
> > @@ -108,6 +110,7 @@ struct vdpa_device *__vdpa_alloc_device(struct devi=
ce *parent,
> >       vdev->config =3D config;
> >       vdev->features_valid =3D false;
> >       vdev->nvqs =3D nvqs;
> > +     vdev->sva =3D sva;
> >
> >       if (name)
> >               err =3D dev_set_name(&vdev->dev, "%s", name);
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index 85776e4e6749..03c796873a6b 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -367,7 +367,8 @@ static struct vdpasim *vdpasim_create(const char *n=
ame)
> >       else
> >               ops =3D &vdpasim_net_config_ops;
> >
> > -     vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VD=
PASIM_VQ_NUM, name);
> > +     vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> > +                             VDPASIM_VQ_NUM, name, false);
> >       if (!vdpasim)
> >               goto err_alloc;
> >
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 4a241d380c40..36b6950ba37f 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -486,21 +486,25 @@ static long vhost_vdpa_unlocked_ioctl(struct file=
 *filep,
> >   static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u=
64 last)
> >   {
> >       struct vhost_dev *dev =3D &v->vdev;
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> >       struct vhost_iotlb *iotlb =3D dev->iotlb;
> >       struct vhost_iotlb_map *map;
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
> > +             if (!vdpa->sva) {
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
> >               }
> > -             atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm=
);
> >               vhost_iotlb_map_free(iotlb, map);
> >       }
> >   }
> > @@ -558,13 +562,15 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
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
> > +     if (!vdpa->sva)
> >               atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
> >
> > -     return r;
> > +     return 0;
> >   }
> >
> >   static void vhost_vdpa_unmap(struct vhost_vdpa *v, u64 iova, u64 size=
)
> > @@ -589,6 +595,7 @@ static int vhost_vdpa_process_iotlb_update(struct v=
host_vdpa *v,
> >                                          struct vhost_iotlb_msg *msg)
> >   {
> >       struct vhost_dev *dev =3D &v->vdev;
> > +     struct vdpa_device *vdpa =3D v->vdpa;
> >       struct vhost_iotlb *iotlb =3D dev->iotlb;
> >       struct page **page_list;
> >       unsigned long list_size =3D PAGE_SIZE / sizeof(struct page *);
> > @@ -607,6 +614,10 @@ static int vhost_vdpa_process_iotlb_update(struct =
vhost_vdpa *v,
> >                                   msg->iova + msg->size - 1))
> >               return -EEXIST;
> >
> > +     if (vdpa->sva)
> > +             return vhost_vdpa_map(v, msg->iova, msg->size,
> > +                                   msg->uaddr, msg->perm);
> > +
> >       /* Limit the use of memory for bookkeeping */
> >       page_list =3D (struct page **) __get_free_page(GFP_KERNEL);
> >       if (!page_list)
> > diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> > index cb5a3d847af3..f86869651614 100644
> > --- a/include/linux/vdpa.h
> > +++ b/include/linux/vdpa.h
> > @@ -44,6 +44,7 @@ struct vdpa_parent_dev;
> >    * @config: the configuration ops for this device.
> >    * @index: device index
> >    * @features_valid: were features initialized? for legacy guests
> > + * @sva: indicate whether SVA (Shared Virtual Addressing) is supported
>
>
> Rethink about this. I think we probably need a better name other than
> "sva" since kernel already use that for shared virtual address space.
> But actually we don't the whole virtual address space.
>

This flag is used to tell vhost-vdpa bus driver to transfer virtual
addresses instead of physical addresses. So how about "use_va=E2=80=9C,
=E2=80=9Dneed_va" or "va=E2=80=9C?

> And I guess this can not work for the device that use platform IOMMU, so
> we should check and fail if sva && !(dma_map || set_map).
>

Agree.

Thanks,
Yongji
