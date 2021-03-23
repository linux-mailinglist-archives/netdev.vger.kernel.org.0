Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D51C3458A2
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 08:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCWH01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 03:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhCWH0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 03:26:18 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C401DC061763
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:26:17 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b16so22265892eds.7
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 00:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=U8lpUuZJGaV5U4oC4GW9RvpzpMAWQMtDrKTPzzjAf6w=;
        b=ypwBn/3Rjk7uj3TA7mO19avc3Y511cmNHLraZ2ubCtyzXhyJNYo1u1TLU+LDahvPqJ
         VQILrw/UDQuAlsZWiuI+DeEMAvEh1F9wkP3elzS2RKPih1LawkT9/THlqbO4QdqczdHa
         goKjIRkvtiU/GO2mCuVbboaAeu6YjXz5CKwZgpeIy0G6RtcpH8Ie/fPvtNxMHuR9/3Ll
         gX0XQgt2LjxvONbzbshs4ptOkp08YYyY9nuYTMQl1cBh3MAuaqavPdNesf1NsuyWfdD2
         7jNCXVJrrYQJjk/yrkORJZnhoy61Da7t5WUlo9a0bu0dfTCvyUDMmfCGNkcZ/2s9ePdp
         b7Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=U8lpUuZJGaV5U4oC4GW9RvpzpMAWQMtDrKTPzzjAf6w=;
        b=lu6GAZJRUZU3Zy4s5rqbJGkXSYUqGc5Dus9eUm7K+QpMQscXWPpqzQI8zIl3iT5u/K
         4/nfFgR46outnibAPzt195lY7odT5A3GM0jFxTAgfryaX2H1yBfAE2UXifjWuoStPHak
         ULqVupoqkI56Gobtjh/vwXDms1wnnpTiNj3OjWGvLHFT9u/COi9CEKMGGjeWA4GKVqsa
         HMNOWgFNIIO35c8WCKtiHBezFKYi39uGmLN/D7Z5QXp0T23PSHkTidhTskmRGsGmZZqX
         +it52sKBlarkg0KDdGeO4iWsXu/b0PKrhRH1q5MMt/w1sgTYahzK9PFcUEIPcwwB9aPu
         NurQ==
X-Gm-Message-State: AOAM530rK8uBWHeMRiRMcDthVEq65/jcmoGv26XlpbIXQEG+9RISocbo
        Vbl1AvBkmRDVMl9Rxrxwx9V29nZ8IfTvnNsnPDNl
X-Google-Smtp-Source: ABdhPJwTkBmxBjkwdo1emwyJPsm7yUl37+5xEFgHLcXdCuMiSkEo0ufMWzQf8nKuKTRV+BTEXxv+aSkgHCaPIIkuNdU=
X-Received: by 2002:a05:6402:6ca:: with SMTP id n10mr3248475edy.312.1616484376542;
 Tue, 23 Mar 2021 00:26:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210315053721.189-1-xieyongji@bytedance.com> <20210315053721.189-8-xieyongji@bytedance.com>
 <07312477-6582-1ca9-c5ed-8ff936525d52@redhat.com>
In-Reply-To: <07312477-6582-1ca9-c5ed-8ff936525d52@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Tue, 23 Mar 2021 15:26:05 +0800
Message-ID: <CACycT3vTXvwGjgjJvb1Skst+9NwAQB8BSEHE_h+D2xEprm6LTw@mail.gmail.com>
Subject: Re: Re: [PATCH v5 07/11] vdpa: Support transferring virtual
 addressing during DMA mapping
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

On Tue, Mar 23, 2021 at 11:13 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/3/15 =E4=B8=8B=E5=8D=881:37, Xie Yongji =E5=86=99=E9=81=93=
:
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
> >   drivers/vdpa/virtio_pci/vp_vdpa.c |   2 +-
> >   drivers/vhost/vdpa.c              | 104 +++++++++++++++++++++++++++++=
++-------
> >   include/linux/vdpa.h              |  19 +++++--
> >   7 files changed, 113 insertions(+), 27 deletions(-)
> >
> > diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf=
_main.c
> > index d555a6a5d1ba..aee013f3eb5f 100644
> > --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> > +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> > @@ -431,7 +431,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const =
struct pci_device_id *id)
> >       }
> >
> >       adapter =3D vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> > -                                 dev, &ifc_vdpa_ops, NULL);
> > +                                 dev, &ifc_vdpa_ops, NULL, false);
> >       if (adapter =3D=3D NULL) {
> >               IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
> >               return -ENOMEM;
> > diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/=
mlx5_vnet.c
> > index 71397fdafa6a..fb62ebcf464a 100644
> > --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> > @@ -1982,7 +1982,7 @@ static int mlx5v_probe(struct auxiliary_device *a=
dev,
> >       max_vqs =3D min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
> >
> >       ndev =3D vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev=
->device, &mlx5_vdpa_ops,
> > -                              NULL);
> > +                              NULL, false);
> >       if (IS_ERR(ndev))
> >               return PTR_ERR(ndev);
> >
> > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > index 5cffce67cab0..97fbac276c72 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -71,6 +71,7 @@ static void vdpa_release_dev(struct device *d)
> >    * @config: the bus operations that is supported by this device
> >    * @size: size of the parent structure that contains private data
> >    * @name: name of the vdpa device; optional.
> > + * @use_va: indicate whether virtual address must be used by this devi=
ce
> >    *
> >    * Driver should use vdpa_alloc_device() wrapper macro instead of
> >    * using this directly.
> > @@ -80,7 +81,8 @@ static void vdpa_release_dev(struct device *d)
> >    */
> >   struct vdpa_device *__vdpa_alloc_device(struct device *parent,
> >                                       const struct vdpa_config_ops *con=
fig,
> > -                                     size_t size, const char *name)
> > +                                     size_t size, const char *name,
> > +                                     bool use_va)
> >   {
> >       struct vdpa_device *vdev;
> >       int err =3D -EINVAL;
> > @@ -91,6 +93,10 @@ struct vdpa_device *__vdpa_alloc_device(struct devic=
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
> > @@ -106,6 +112,7 @@ struct vdpa_device *__vdpa_alloc_device(struct devi=
ce *parent,
> >       vdev->index =3D err;
> >       vdev->config =3D config;
> >       vdev->features_valid =3D false;
> > +     vdev->use_va =3D use_va;
> >
> >       if (name)
> >               err =3D dev_set_name(&vdev->dev, "%s", name);
> > diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/v=
dpa_sim.c
> > index ff331f088baf..d26334e9a412 100644
> > --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> > @@ -235,7 +235,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_a=
ttr *dev_attr)
> >               ops =3D &vdpasim_config_ops;
> >
> >       vdpasim =3D vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> > -                                 dev_attr->name);
> > +                                 dev_attr->name, false);
> >       if (!vdpasim)
> >               goto err_alloc;
> >
> > diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pc=
i/vp_vdpa.c
> > index 1321a2fcd088..03b36aed48d6 100644
> > --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> > +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> > @@ -377,7 +377,7 @@ static int vp_vdpa_probe(struct pci_dev *pdev, cons=
t struct pci_device_id *id)
> >               return ret;
> >
> >       vp_vdpa =3D vdpa_alloc_device(struct vp_vdpa, vdpa,
> > -                                 dev, &vp_vdpa_ops, NULL);
> > +                                 dev, &vp_vdpa_ops, NULL, false);
> >       if (vp_vdpa =3D=3D NULL) {
> >               dev_err(dev, "vp_vdpa: Failed to allocate vDPA structure\=
n");
> >               return -ENOMEM;
> > diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> > index 7c83fbf3edac..b65c21ae98d1 100644
> > --- a/drivers/vhost/vdpa.c
> > +++ b/drivers/vhost/vdpa.c
> > @@ -480,21 +480,30 @@ static long vhost_vdpa_unlocked_ioctl(struct file=
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
> > +                     fput(map_file->file);
> > +                     kfree(map_file);
>
>
> Let's factor out the logic of pa and va separatedly here.
>

Will do it.

Thanks,
Yongji
