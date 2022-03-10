Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700B14D521A
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 20:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245395AbiCJSWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 13:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238641AbiCJSW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 13:22:27 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26A2E14F28A
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646936484;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ko8Hxv+wOkHEO8P3GHGLzU6jnf5Sj58s0cBYq+RkU70=;
        b=V9JzDv6Kr7j+o05GK6vq918hvZpnmW/rO4YmTDbf63R2q3MEst8AigeF7aOo5/Fmy8bInE
        KeQE/wZlZh9n87utGOsCu15ENxUCvPV4qCKGnEDHfBp4om0AG7CE/6h7Xfe2hzuF0XpXUG
        LEga33sySHmBcpcteBD9xB0DbfR4WIU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-481-aTyGPjpHNCyArlnr-48pjQ-1; Thu, 10 Mar 2022 13:21:22 -0500
X-MC-Unique: aTyGPjpHNCyArlnr-48pjQ-1
Received: by mail-qk1-f197.google.com with SMTP id i2-20020a05620a248200b0067b51fa1269so4411553qkn.19
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 10:21:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ko8Hxv+wOkHEO8P3GHGLzU6jnf5Sj58s0cBYq+RkU70=;
        b=l+uMiPrRD7t/3j+c0NGPgMXm4Cn5uDmIDBVCJvuI0T59jmv0zRI/rT4uFlpcmaZ9i1
         hvpcFUCZDA4aNjjQO3AHRY6p1SaFBWQGn4WHJkllTb1MYDhpHyugVLJpdviKEqLji+8u
         TeTJvsvH5pBOJpJ4xxFS4SVkN+Gaq7HJI2h4qax95eeQV0YtEQob7RS7E1wnoCfosqvY
         nVsmENmTly7c4h/uB/kQil5kkaYaIwz04j6tWg+Krnp0ao+mPG4c4MUkF8fQ1wNERlHA
         PnbR/hbEOWzIvK4bf53cIaZA43p+idTj34aNrY5Le853Wh/WV7O6LoDad0eO+uhLRcvd
         Ybrw==
X-Gm-Message-State: AOAM5303SA0Nr7+CgDlneslx7U2qONO5sEGYXkw98P6gTZq38jZyjj+j
        +Z/ce94i0L9dJdCPDUMtTzIxVg90p0wPaK8AEKtSQbrI/zBKUo0aNMsZTA/OEB7T2YuVy3StNvw
        SAEt2ywGU/74i0CST0FFwMtG7Cgk2oNgc
X-Received: by 2002:a05:6214:dc8:b0:435:c77c:7c56 with SMTP id 8-20020a0562140dc800b00435c77c7c56mr4863422qvt.26.1646936478875;
        Thu, 10 Mar 2022 10:21:18 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw0vk7HXMQ5nT1Z+AiLNfCpgzHu4wNmJJhHv76pNCac8DoKlQXyVwbfy/TrfJHqN0hbBb2Z+1bQba3IEMIoicY=
X-Received: by 2002:a05:6214:dc8:b0:435:c77c:7c56 with SMTP id
 8-20020a0562140dc800b00435c77c7c56mr4863387qvt.26.1646936478522; Thu, 10 Mar
 2022 10:21:18 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-20-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-20-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 10 Mar 2022 19:20:42 +0100
Message-ID: <CAJaqyWedCL0sv0qTvROBj7tJS6n11qEhY0kKMeushyGZLQdj=g@mail.gmail.com>
Subject: Re: [RFC PATCH v2 19/19] vdpasim: control virtqueue support
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>,
        Tanuj Murlidhar Kamde <tanujk@xilinx.com>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Eli Cohen <elic@nvidia.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        Parav Pandit <parav@nvidia.com>,
        Longpeng <longpeng2@huawei.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 10:29 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patch introduces the control virtqueue support for vDPA
> simulator. This is a requirement for supporting advanced features like
> multiqueue.
>
> A requirement for control virtqueue is to isolate its memory access
> from the rx/tx virtqueues. This is because when using vDPA device
> for VM, the control virqueue is not directly assigned to VM. Userspace
> (Qemu) will present a shadow control virtqueue to control for
> recording the device states.
>
> The isolation is done via the virtqueue groups and ASID support in
> vDPA through vhost-vdpa. The simulator is extended to have:
>
> 1) three virtqueues: RXVQ, TXVQ and CVQ (control virtqueue)
> 2) two virtqueue groups: group 0 contains RXVQ and TXVQ; group 1
>    contains CVQ
> 3) two address spaces and the simulator simply implements the address
>    spaces by mapping it 1:1 to IOTLB.
>
> For the VM use cases, userspace(Qemu) may set AS 0 to group 0 and AS 1
> to group 1. So we have:
>
> 1) The IOTLB for virtqueue group 0 contains the mappings of guest, so
>    RX and TX can be assigned to guest directly.
> 2) The IOTLB for virtqueue group 1 contains the mappings of CVQ which
>    is the buffers that allocated and managed by VMM only. So CVQ of
>    vhost-vdpa is visible to VMM only. And Guest can not access the CVQ
>    of vhost-vdpa.
>
> For the other use cases, since AS 0 is associated to all virtqueue
> groups by default. All virtqueues share the same mapping by default.
>
> To demonstrate the function, VIRITO_NET_F_CTRL_MACADDR is
> implemented in the simulator for the driver to set mac address.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.c     | 91 ++++++++++++++++++++++------
>  drivers/vdpa/vdpa_sim/vdpa_sim.h     |  2 +
>  drivers/vdpa/vdpa_sim/vdpa_sim_net.c | 88 ++++++++++++++++++++++++++-
>  3 files changed, 161 insertions(+), 20 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 659e2e2e4b0c..59611f18a3a8 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -96,11 +96,17 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>  {
>         int i;
>
> -       for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
> +       spin_lock(&vdpasim->iommu_lock);
> +
> +       for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
>                 vdpasim_vq_reset(vdpasim, &vdpasim->vqs[i]);
> +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
> +                                &vdpasim->iommu_lock);
> +       }
> +
> +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
> +               vhost_iotlb_reset(&vdpasim->iommu[i]);
>
> -       spin_lock(&vdpasim->iommu_lock);
> -       vhost_iotlb_reset(vdpasim->iommu);
>         spin_unlock(&vdpasim->iommu_lock);
>
>         vdpasim->features = 0;
> @@ -145,7 +151,7 @@ static dma_addr_t vdpasim_map_range(struct vdpasim *vdpasim, phys_addr_t paddr,
>         dma_addr = iova_dma_addr(&vdpasim->iova, iova);
>
>         spin_lock(&vdpasim->iommu_lock);
> -       ret = vhost_iotlb_add_range(vdpasim->iommu, (u64)dma_addr,
> +       ret = vhost_iotlb_add_range(&vdpasim->iommu[0], (u64)dma_addr,
>                                     (u64)dma_addr + size - 1, (u64)paddr, perm);
>         spin_unlock(&vdpasim->iommu_lock);
>
> @@ -161,7 +167,7 @@ static void vdpasim_unmap_range(struct vdpasim *vdpasim, dma_addr_t dma_addr,
>                                 size_t size)
>  {
>         spin_lock(&vdpasim->iommu_lock);
> -       vhost_iotlb_del_range(vdpasim->iommu, (u64)dma_addr,
> +       vhost_iotlb_del_range(&vdpasim->iommu[0], (u64)dma_addr,
>                               (u64)dma_addr + size - 1);
>         spin_unlock(&vdpasim->iommu_lock);
>
> @@ -250,8 +256,9 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>         else
>                 ops = &vdpasim_config_ops;
>
> -       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
> -                                   1, dev_attr->name, false);
> +       vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
> +                                   dev_attr->ngroups, dev_attr->nas,
> +                                   dev_attr->name, false);
>         if (IS_ERR(vdpasim)) {
>                 ret = PTR_ERR(vdpasim);
>                 goto err_alloc;
> @@ -278,16 +285,20 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>         if (!vdpasim->vqs)
>                 goto err_iommu;
>
> -       vdpasim->iommu = vhost_iotlb_alloc(max_iotlb_entries, 0);
> +       vdpasim->iommu = kmalloc_array(vdpasim->dev_attr.nas,
> +                                      sizeof(*vdpasim->iommu), GFP_KERNEL);
>         if (!vdpasim->iommu)
>                 goto err_iommu;
>
> +       for (i = 0; i < vdpasim->dev_attr.nas; i++)
> +               vhost_iotlb_init(&vdpasim->iommu[i], 0, 0);
> +
>         vdpasim->buffer = kvmalloc(dev_attr->buffer_size, GFP_KERNEL);
>         if (!vdpasim->buffer)
>                 goto err_iommu;
>
>         for (i = 0; i < dev_attr->nvqs; i++)
> -               vringh_set_iotlb(&vdpasim->vqs[i].vring, vdpasim->iommu,
> +               vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
>                                  &vdpasim->iommu_lock);
>
>         ret = iova_cache_get();
> @@ -401,7 +412,11 @@ static u32 vdpasim_get_vq_align(struct vdpa_device *vdpa)
>
>  static u32 vdpasim_get_vq_group(struct vdpa_device *vdpa, u16 idx)
>  {
> -       return 0;
> +       /* RX and TX belongs to group 0, CVQ belongs to group 1 */
> +       if (idx == 2)
> +               return 1;
> +       else
> +               return 0;
>  }
>
>  static u64 vdpasim_get_device_features(struct vdpa_device *vdpa)
> @@ -539,20 +554,53 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
>         return range;
>  }
>
> +static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
> +                                 unsigned int asid)
> +{
> +       struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +       struct vhost_iotlb *iommu;
> +       int i;
> +
> +       if (group > vdpasim->dev_attr.ngroups)
> +               return -EINVAL;
> +
> +       if (asid > vdpasim->dev_attr.nas)
> +               return -EINVAL;
> +
> +       iommu = &vdpasim->iommu[asid];
> +
> +       spin_lock(&vdpasim->lock);
> +
> +       for (i = 0; i < vdpasim->dev_attr.nvqs; i++)
> +               if (vdpasim_get_vq_group(vdpa, i) == group)
> +                       vringh_set_iotlb(&vdpasim->vqs[i].vring, &vdpasim->iommu[0],
> +                                        &vdpasim->iommu_lock);
> +
> +       spin_unlock(&vdpasim->lock);
> +
> +       return 0;
> +}
> +
>  static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>                            struct vhost_iotlb *iotlb)
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>         struct vhost_iotlb_map *map;
> +       struct vhost_iotlb *iommu;
>         u64 start = 0ULL, last = 0ULL - 1;
>         int ret;
>
> +       if (asid >= vdpasim->dev_attr.nas)
> +               return -EINVAL;
> +
>         spin_lock(&vdpasim->iommu_lock);
> -       vhost_iotlb_reset(vdpasim->iommu);
> +
> +       iommu = &vdpasim->iommu[asid];
> +       vhost_iotlb_reset(iommu);
>
>         for (map = vhost_iotlb_itree_first(iotlb, start, last); map;
>              map = vhost_iotlb_itree_next(map, start, last)) {
> -               ret = vhost_iotlb_add_range(vdpasim->iommu, map->start,
> +               ret = vhost_iotlb_add_range(iommu, map->start,
>                                             map->last, map->addr, map->perm);
>                 if (ret)
>                         goto err;
> @@ -561,7 +609,7 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>         return 0;
>
>  err:
> -       vhost_iotlb_reset(vdpasim->iommu);
> +       vhost_iotlb_reset(iommu);
>         spin_unlock(&vdpasim->iommu_lock);
>         return ret;
>  }
> @@ -573,9 +621,12 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>         int ret;
>
> +       if (asid >= vdpasim->dev_attr.nas)
> +               return -EINVAL;
> +
>         spin_lock(&vdpasim->iommu_lock);
> -       ret = vhost_iotlb_add_range_ctx(vdpasim->iommu, iova, iova + size - 1,
> -                                       pa, perm, opaque);
> +       ret = vhost_iotlb_add_range_ctx(&vdpasim->iommu[asid], iova,
> +                                       iova + size - 1, pa, perm, opaque);
>         spin_unlock(&vdpasim->iommu_lock);
>
>         return ret;
> @@ -586,8 +637,11 @@ static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>
> +       if (asid >= vdpasim->dev_attr.nas)
> +               return -EINVAL;
> +
>         spin_lock(&vdpasim->iommu_lock);
> -       vhost_iotlb_del_range(vdpasim->iommu, iova, iova + size - 1);
> +       vhost_iotlb_del_range(&vdpasim->iommu[asid], iova, iova + size - 1);
>         spin_unlock(&vdpasim->iommu_lock);
>
>         return 0;
> @@ -611,8 +665,7 @@ static void vdpasim_free(struct vdpa_device *vdpa)
>         }
>
>         kvfree(vdpasim->buffer);
> -       if (vdpasim->iommu)
> -               vhost_iotlb_free(vdpasim->iommu);
> +       vhost_iotlb_free(vdpasim->iommu);
>         kfree(vdpasim->vqs);
>         kfree(vdpasim->config);
>  }
> @@ -643,6 +696,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
>         .set_config             = vdpasim_set_config,
>         .get_generation         = vdpasim_get_generation,
>         .get_iova_range         = vdpasim_get_iova_range,
> +       .set_group_asid         = vdpasim_set_group_asid,
>         .dma_map                = vdpasim_dma_map,
>         .dma_unmap              = vdpasim_dma_unmap,
>         .free                   = vdpasim_free,
> @@ -674,6 +728,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
>         .set_config             = vdpasim_set_config,
>         .get_generation         = vdpasim_get_generation,
>         .get_iova_range         = vdpasim_get_iova_range,
> +       .set_group_asid         = vdpasim_set_group_asid,
>         .set_map                = vdpasim_set_map,
>         .free                   = vdpasim_free,
>  };
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index 0be7c1e7ef80..622782e92239 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -41,6 +41,8 @@ struct vdpasim_dev_attr {
>         size_t buffer_size;
>         int nvqs;
>         u32 id;
> +       u32 ngroups;
> +       u32 nas;
>
>         work_func_t work_fn;
>         void (*get_config)(struct vdpasim *vdpasim, void *config);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> index ed5ade4ae570..513970c05af2 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim_net.c
> @@ -26,10 +26,15 @@
>  #define DRV_LICENSE  "GPL v2"
>
>  #define VDPASIM_NET_FEATURES   (VDPASIM_FEATURES | \
> +                                (1ULL << VIRTIO_NET_F_MTU) | \

Why the reorder here?

>                                  (1ULL << VIRTIO_NET_F_MAC) | \
> -                                (1ULL << VIRTIO_NET_F_MTU));
> +                                (1ULL << VIRTIO_NET_F_CTRL_VQ) | \
> +                                (1ULL << VIRTIO_NET_F_CTRL_MAC_ADDR));
>
> -#define VDPASIM_NET_VQ_NUM     2
> +/* 3 virtqueues, 2 address spaces, 2 virtqueue groups */
> +#define VDPASIM_NET_VQ_NUM     3
> +#define VDPASIM_NET_AS_NUM     2
> +#define VDPASIM_NET_GROUP_NUM  2
>
>  static void vdpasim_net_complete(struct vdpasim_virtqueue *vq, size_t len)
>  {
> @@ -63,6 +68,81 @@ static bool receive_filter(struct vdpasim *vdpasim, size_t len)
>         return false;
>  }
>
> +static virtio_net_ctrl_ack vdpasim_handle_ctrl_mac(struct vdpasim *vdpasim,
> +                                                  u8 cmd)
> +{
> +       struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +       virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +       size_t read;
> +
> +       switch (cmd) {
> +       case VIRTIO_NET_CTRL_MAC_ADDR_SET:
> +               read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov,
> +                                            (void *)vdpasim->config.mac,

This is not valid anymore as config is of type void *. Need to convert
to virtio_net_config. This also occurs in receive_filter.

You can copy how vdpasim_net_setup_config does it, for example.

Thanks!

> +                                            ETH_ALEN);
> +               if (read == ETH_ALEN)
> +                       status = VIRTIO_NET_OK;
> +               break;
> +       default:
> +               break;
> +       }
> +
> +       return status;
> +}
> +
> +static void vdpasim_handle_cvq(struct vdpasim *vdpasim)
> +{
> +       struct vdpasim_virtqueue *cvq = &vdpasim->vqs[2];
> +       virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
> +       struct virtio_net_ctrl_hdr ctrl;
> +       size_t read, write;
> +       int err;
> +
> +       if (!(vdpasim->features & (1ULL << VIRTIO_NET_F_CTRL_VQ)))
> +               return;
> +
> +       if (!cvq->ready)
> +               return;
> +
> +       while (true) {
> +               err = vringh_getdesc_iotlb(&cvq->vring, &cvq->in_iov,
> +                                          &cvq->out_iov,
> +                                          &cvq->head, GFP_ATOMIC);
> +               if (err <= 0)
> +                       break;
> +
> +               read = vringh_iov_pull_iotlb(&cvq->vring, &cvq->in_iov, &ctrl,
> +                                            sizeof(ctrl));
> +               if (read != sizeof(ctrl))
> +                       break;
> +
> +               switch (ctrl.class) {
> +               case VIRTIO_NET_CTRL_MAC:
> +                       status = vdpasim_handle_ctrl_mac(vdpasim, ctrl.cmd);
> +                       break;
> +               default:
> +                       break;
> +               }
> +
> +               /* Make sure data is wrote before advancing index */
> +               smp_wmb();
> +
> +               write = vringh_iov_push_iotlb(&cvq->vring, &cvq->out_iov,
> +                                             &status, sizeof(status));
> +               vringh_complete_iotlb(&cvq->vring, cvq->head, write);
> +               vringh_kiov_cleanup(&cvq->in_iov);
> +               vringh_kiov_cleanup(&cvq->out_iov);
> +
> +               /* Make sure used is visible before rasing the interrupt. */
> +               smp_wmb();
> +
> +               local_bh_disable();
> +               if (cvq->cb)
> +                       cvq->cb(cvq->private);
> +               local_bh_enable();
> +       }
> +}
> +
>  static void vdpasim_net_work(struct work_struct *work)
>  {
>         struct vdpasim *vdpasim = container_of(work, struct vdpasim, work);
> @@ -77,6 +157,8 @@ static void vdpasim_net_work(struct work_struct *work)
>         if (!(vdpasim->status & VIRTIO_CONFIG_S_DRIVER_OK))
>                 goto out;
>
> +       vdpasim_handle_cvq(vdpasim);
> +
>         if (!txq->ready || !rxq->ready)
>                 goto out;
>
> @@ -162,6 +244,8 @@ static int vdpasim_net_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         dev_attr.id = VIRTIO_ID_NET;
>         dev_attr.supported_features = VDPASIM_NET_FEATURES;
>         dev_attr.nvqs = VDPASIM_NET_VQ_NUM;
> +       dev_attr.ngroups = VDPASIM_NET_GROUP_NUM;
> +       dev_attr.nas = VDPASIM_NET_AS_NUM;
>         dev_attr.config_size = sizeof(struct virtio_net_config);
>         dev_attr.get_config = vdpasim_net_get_config;
>         dev_attr.work_fn = vdpasim_net_work;
> --
> 2.25.0
>

