Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37ADA27B11E
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 17:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgI1PpW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 11:45:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24940 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726420AbgI1PpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 11:45:22 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601307919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EmoLZH3c7F182vOGcdO5c+/L/iT9ksAovxdw1FKXD9c=;
        b=ewlg2CnPr+sfIwk0/2uWRX2HaypRD6ibv53AEJSlNG4B78ABwg+UzVUDQQFGMNcM+DCeiP
        DT6V1YoVBMpkLo/2F/EH0dcPL2ZmMUdZpWhUiAps1Mie0x4ojK4Rgo+WFhWF3J4Uck9rmL
        /aEOBulU6Zy6bF6sE3CCUrU1cdaxoW0=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-EfRHimbFM42YY8DjG10vkw-1; Mon, 28 Sep 2020 11:45:18 -0400
X-MC-Unique: EfRHimbFM42YY8DjG10vkw-1
Received: by mail-qt1-f200.google.com with SMTP id p43so882296qtb.23
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 08:45:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EmoLZH3c7F182vOGcdO5c+/L/iT9ksAovxdw1FKXD9c=;
        b=QvUKoBn8vsMUFYvm/52UsB1RGjj29U2bCJj7x7/HypyeGfOHNaliBS2+M+V5EARDo0
         QkYuocuGOtJvtCIX+ycAStPFMYJ5BJ/f0WhkEUo1waOZ70ufptX9qahmiQrfU3/3/tZd
         ujW/94DEqx1dhRQtf/U/vwz1V0Tderiakwu6jp6coHhNbq0Pun35QXHZS4Dx2aElZieG
         +1nHR86kjx45/ZjlQCpAJ1rUjGn4e/N2Q/LY/617UjOFw6y5i8fce3Xcw7C7Id3mR7FY
         6zRAPiBFwFNqy4FcoIdSxE9CmvJrR2DOzfVzD4S5gevUkkMQlOHI2fFunknWtCHCd/kq
         j9Bg==
X-Gm-Message-State: AOAM531T8tN0EF4radVCh3+kjdYkB4EQjyKVQK00muvHcyzg+WTwc737
        r3mhvbQRDx2EUFqIxhwPpuVTeov/NeYVAZTOcWp1IvPzGNUy9VEXvidQtYwwQS8Wu7y1JTZGTaQ
        t+yOCI+0tUR+LzHhNlfl+jzeCWw6NMwGw
X-Received: by 2002:ac8:7208:: with SMTP id a8mr2253992qtp.22.1601307917126;
        Mon, 28 Sep 2020 08:45:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz80d8ZwANAMEdVFkB8z7olGrnUdIuUyaYlxzd50B5cqWKATJ661zvv/uzVeTXVFzBZ/7/34/QGcwHXPNeAh0k=
X-Received: by 2002:ac8:7208:: with SMTP id a8mr2253964qtp.22.1601307916793;
 Mon, 28 Sep 2020 08:45:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200924032125.18619-1-jasowang@redhat.com> <20200924032125.18619-9-jasowang@redhat.com>
In-Reply-To: <20200924032125.18619-9-jasowang@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Mon, 28 Sep 2020 17:44:40 +0200
Message-ID: <CAJaqyWdDX4JoPUHHXxkB=veiK9nETyqCPEJxcrHdjLmpE4PRCg@mail.gmail.com>
Subject: Re: [RFC PATCH 08/24] vdpa: introduce virtqueue groups
To:     Jason Wang <jasowang@redhat.com>
Cc:     Michael Tsirkin <mst@redhat.com>, Cindy Lu <lulu@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Miller <rob.miller@broadcom.com>,
        lingshan.zhu@intel.com, Harpreet Singh Anand <hanand@xilinx.com>,
        mhabets@solarflare.com, eli@mellanox.com,
        Adrian Moreno Zapata <amorenoz@redhat.com>,
        Maxime Coquelin <maxime.coquelin@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 5:23 AM Jason Wang <jasowang@redhat.com> wrote:
>
> This patch introduces virtqueue groups to vDPA device. The virtqueue
> group is the minimal set of virtqueues that must share an address
> space. And the adddress space identifier could only be attached to
> a specific virtqueue group.
>
> A new mandated bus operation is introduced to get the virtqueue group
> ID for a specific virtqueue.
>
> All the vDPA device drivers were converted to simply support a single
> virtqueue group.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  9 ++++++++-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  8 +++++++-
>  drivers/vdpa/vdpa.c               |  4 +++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 11 ++++++++++-
>  include/linux/vdpa.h              | 12 +++++++++---
>  5 files changed, 37 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 076d7ac5e723..e6a0be374e51 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -327,6 +327,11 @@ static u32 ifcvf_vdpa_get_vq_align(struct vdpa_device *vdpa_dev)
>         return IFCVF_QUEUE_ALIGNMENT;
>  }
>
> +static u32 ifcvf_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +       return 0;
> +}
> +
>  static void ifcvf_vdpa_get_config(struct vdpa_device *vdpa_dev,
>                                   unsigned int offset,
>                                   void *buf, unsigned int len)
> @@ -387,6 +392,7 @@ static const struct vdpa_config_ops ifc_vdpa_ops = {
>         .get_device_id  = ifcvf_vdpa_get_device_id,
>         .get_vendor_id  = ifcvf_vdpa_get_vendor_id,
>         .get_vq_align   = ifcvf_vdpa_get_vq_align,
> +       .get_vq_group   = ifcvf_vdpa_get_vq_group,
>         .get_config     = ifcvf_vdpa_get_config,
>         .set_config     = ifcvf_vdpa_set_config,
>         .set_config_cb  = ifcvf_vdpa_set_config_cb,
> @@ -434,7 +440,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>
>         adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
>                                     dev, &ifc_vdpa_ops,
> -                                   IFCVF_MAX_QUEUE_PAIRS * 2);
> +                                   IFCVF_MAX_QUEUE_PAIRS * 2, 1);
> +
>         if (adapter == NULL) {
>                 IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>                 return -ENOMEM;
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index 9df69d5efe8c..4e480f4f754e 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1428,6 +1428,11 @@ static u32 mlx5_vdpa_get_vq_align(struct vdpa_device *vdev)
>         return PAGE_SIZE;
>  }
>
> +static u32 mlx5_vdpa_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +       return 0;
> +}
> +
>  enum { MLX5_VIRTIO_NET_F_GUEST_CSUM = 1 << 9,
>         MLX5_VIRTIO_NET_F_CSUM = 1 << 10,
>         MLX5_VIRTIO_NET_F_HOST_TSO6 = 1 << 11,
> @@ -1838,6 +1843,7 @@ static const struct vdpa_config_ops mlx5_vdpa_ops = {
>         .get_vq_notification = mlx5_get_vq_notification,
>         .get_vq_irq = mlx5_get_vq_irq,
>         .get_vq_align = mlx5_vdpa_get_vq_align,
> +       .get_vq_group = mlx5_vdpa_get_vq_group,
>         .get_features = mlx5_vdpa_get_features,
>         .set_features = mlx5_vdpa_set_features,
>         .set_config_cb = mlx5_vdpa_set_config_cb,
> @@ -1925,7 +1931,7 @@ void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
>         max_vqs = min_t(u32, max_vqs, MLX5_MAX_SUPPORTED_VQS);
>
>         ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -                                2 * mlx5_vdpa_max_qps(max_vqs));
> +                                2 * mlx5_vdpa_max_qps(max_vqs), 1);
>         if (IS_ERR(ndev))
>                 return ndev;
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index a69ffc991e13..46399746ec7c 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -62,6 +62,7 @@ static void vdpa_release_dev(struct device *d)
>   * @parent: the parent device
>   * @config: the bus operations that is supported by this device
>   * @nvqs: number of virtqueues supported by this device
> + * @ngroups: number of groups supported by this device

Hi!

Maybe the description of "ngroups" could be "number of *virtqueue*
groups supported by this device"? I think that it could be needed in
some contexts reading the code.

Thanks!

>   * @size: size of the parent structure that contains private data
>   *
>   * Driver should use vdpa_alloc_device() wrapper macro instead of
> @@ -72,7 +73,7 @@ static void vdpa_release_dev(struct device *d)
>   */
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>                                         const struct vdpa_config_ops *config,
> -                                       int nvqs,
> +                                       int nvqs, unsigned int ngroups,
>                                         size_t size)
>  {
>         struct vdpa_device *vdev;
> @@ -100,6 +101,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>         vdev->config = config;
>         vdev->features_valid = false;
>         vdev->nvqs = nvqs;
> +       vdev->ngroups = ngroups;
>
>         err = dev_set_name(&vdev->dev, "vdpa%u", vdev->index);
>         if (err)
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 62d640327145..6669c561bc6e 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -75,6 +75,7 @@ struct vdpasim {
>         u32 status;
>         u32 generation;
>         u64 features;
> +       u32 groups;
>         /* spinlock to synchronize iommu table */
>         spinlock_t iommu_lock;
>  };
> @@ -352,7 +353,8 @@ static struct vdpasim *vdpasim_create(void)
>         else
>                 ops = &vdpasim_net_config_ops;
>
> -       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, VDPASIM_VQ_NUM);
> +       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> +                                   VDPASIM_VQ_NUM, 1);
>         if (!vdpasim)
>                 goto err_alloc;
>
> @@ -481,6 +483,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
>         return VDPASIM_QUEUE_ALIGN;
>  }
>
> +static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
> +{
> +       return 0;
> +}
> +
>  static u64 vdpasim_get_features(struct vdpa_device *vdpa)
>  {
>         return vdpasim_features;
> @@ -646,6 +653,7 @@ static const struct vdpa_config_ops vdpasim_net_config_ops = {
>         .set_vq_state           = vdpasim_set_vq_state,
>         .get_vq_state           = vdpasim_get_vq_state,
>         .get_vq_align           = vdpasim_get_vq_align,
> +       .get_vq_group           = vdpasim_get_vq_group,
>         .get_features           = vdpasim_get_features,
>         .set_features           = vdpasim_set_features,
>         .set_config_cb          = vdpasim_set_config_cb,
> @@ -672,6 +680,7 @@ static const struct vdpa_config_ops vdpasim_net_batch_config_ops = {
>         .set_vq_state           = vdpasim_set_vq_state,
>         .get_vq_state           = vdpasim_get_vq_state,
>         .get_vq_align           = vdpasim_get_vq_align,
> +       .get_vq_group           = vdpasim_get_vq_group,
>         .get_features           = vdpasim_get_features,
>         .set_features           = vdpasim_set_features,
>         .set_config_cb          = vdpasim_set_config_cb,
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index df169c2f5c0f..d829512efd27 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -51,6 +51,7 @@ struct vdpa_device {
>         unsigned int index;
>         bool features_valid;
>         int nvqs;
> +       unsigned int ngroups;
>  };
>
>  /**
> @@ -109,6 +110,10 @@ struct vdpa_device {
>   *                             for the device
>   *                             @vdev: vdpa device
>   *                             Returns virtqueue algin requirement
> + * @get_vq_group:              Get the group id for a specific virtqueue
> + *                             @vdev: vdpa device
> + *                             @idx: virtqueue index
> + *                             Returns u32: group id for this virtqueue
>   * @get_features:              Get virtio features supported by the device
>   *                             @vdev: vdpa device
>   *                             Returns the virtio features support by the
> @@ -203,6 +208,7 @@ struct vdpa_config_ops {
>
>         /* Device ops */
>         u32 (*get_vq_align)(struct vdpa_device *vdev);
> +       u32 (*get_vq_group)(struct vdpa_device *vdev, u16 idx);
>         u64 (*get_features)(struct vdpa_device *vdev);
>         int (*set_features)(struct vdpa_device *vdev, u64 features);
>         void (*set_config_cb)(struct vdpa_device *vdev,
> @@ -230,12 +236,12 @@ struct vdpa_config_ops {
>
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>                                         const struct vdpa_config_ops *config,
> -                                       int nvqs,
> +                                       int nvqs, unsigned int ngroups,
>                                         size_t size);
>
> -#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs)   \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, nvqs, ngroups) \
>                           container_of(__vdpa_alloc_device( \
> -                                      parent, config, nvqs, \
> +                                      parent, config, nvqs, ngroups, \
>                                        sizeof(dev_struct) + \
>                                        BUILD_BUG_ON_ZERO(offsetof( \
>                                        dev_struct, member))), \
> --
> 2.20.1
>

