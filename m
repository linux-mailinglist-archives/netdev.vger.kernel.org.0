Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E438A4CC663
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 20:44:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235526AbiCCTok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 14:44:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiCCToe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 14:44:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 89363FEB06
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 11:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646336608;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rZukSBtRSbVXgI+lPoT1DA/PpetoH7/G31hBXSlFcS0=;
        b=Gi97LRfRAMAV8+Oozx2G9mx8ZoxrGbHOpL+NjoTprPWCJLZgTzTx9N1mrgujw/J1F9uYB5
        h5fAv8jU+jwvIglVB+tjITEbCdvMoS9OiGbzM5SeI6IvsoR5+9cDE5Dstyv1AmrmVuqY47
        0+h8bKGosAFVxIHH0mKgyaayH82q5ro=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-cVAtbL04Pgegx1W-PPGUuQ-1; Thu, 03 Mar 2022 14:40:17 -0500
X-MC-Unique: cVAtbL04Pgegx1W-PPGUuQ-1
Received: by mail-qv1-f71.google.com with SMTP id w7-20020a0ce107000000b0043512c55ecaso5015846qvk.11
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 11:40:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rZukSBtRSbVXgI+lPoT1DA/PpetoH7/G31hBXSlFcS0=;
        b=mj7E7lNfZI6ELwzcIeIG9fQ6YArBapxbMOf0kbe6EgA4+Sgb3VqkQlh/wnDA2Nd2WM
         dUANVcrE8P5lGiTSWMSd6ntJCPE5KyC6T35el68ecUYioHRHR4L4dC9vf1HDhsuFkuNa
         Rti8n0bT2bUa0QdMOt8RAcoPPyokwX7ggwjFa2HWG99LZrccn+O6wN4AwNwpqvvr1zsE
         lc71K6oHuRNICCy/T5gOov5pRkb1Wf/IPkl/kZNehupR8algmLaUUCGmvfaKlRAhLW1N
         nNFGMRM7Gm3pFNBeWz6gtD1J4HFfiTw16GW5efX3YlxxDQlkWVAWvbVwnR2Du+s1FZPb
         nu5A==
X-Gm-Message-State: AOAM531BgSUOCYMK+AK5/lbpJCHAM22c42JQvnjM2ft3n9L37f//knyQ
        9MsVj9ts0SMxLxjGSyEsyahDxb9Q35agOIWGC9ojrFhtjJHLZVs/wYw8MPw1DNuOmj/n1KwSWqr
        GVMgZVfihH0jf/bNDK1nkHxfnAOi0ZJew
X-Received: by 2002:a05:6214:1d0d:b0:433:1869:1fb7 with SMTP id e13-20020a0562141d0d00b0043318691fb7mr15259229qvd.40.1646336417188;
        Thu, 03 Mar 2022 11:40:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyp3Cbp/Nx9iTTLMWrponYhL1QXQRLgnfcp48KwsXN2YE1W36I5QdI131uucyme4XFXJuQ1X8YitSqQxKWRwtU=
X-Received: by 2002:a05:6214:1d0d:b0:433:1869:1fb7 with SMTP id
 e13-20020a0562141d0d00b0043318691fb7mr15259207qvd.40.1646336416863; Thu, 03
 Mar 2022 11:40:16 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-7-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-7-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Thu, 3 Mar 2022 20:39:40 +0100
Message-ID: <CAJaqyWeeJeFzmov0XPOBMoKS=xH0zA_XXXunMsWOds+53aKxYw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 06/19] vdpa: multiple address spaces support
To:     Gautam Dawar <gautam.dawar@xilinx.com>
Cc:     Gautam Dawar <gdawar@xilinx.com>,
        Martin Petrus Hubertus Habets <martinh@xilinx.com>,
        Harpreet Singh Anand <hanand@xilinx.com>, tanujk@xilinx.com,
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
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 10:25 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patches introduces the multiple address spaces support for vDPA
> device. This idea is to identify a specific address space via an
> dedicated identifier - ASID.
>
> During vDPA device allocation, vDPA device driver needs to report the
> number of address spaces supported by the device then the DMA mapping
> ops of the vDPA device needs to be extended to support ASID.
>
> This helps to isolate the environments for the virtqueue that will not
> be assigned directly. E.g in the case of virtio-net, the control
> virtqueue will not be assigned directly to guest.
>
> As a start, simply claim 1 virtqueue groups and 1 address spaces for
> all vDPA devices. And vhost-vDPA will simply reject the device with
> more than 1 virtqueue groups or address spaces.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  5 +++--
>  drivers/vdpa/vdpa.c               |  4 +++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  | 10 ++++++----
>  drivers/vhost/vdpa.c              | 14 +++++++++-----
>  include/linux/vdpa.h              | 28 +++++++++++++++++++---------
>  6 files changed, 41 insertions(+), 22 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index c815a2e62440..a4815c5612f9 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -513,7 +513,7 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
>         pdev = ifcvf_mgmt_dev->pdev;
>         dev = &pdev->dev;
>         adapter = vdpa_alloc_device(struct ifcvf_adapter, vdpa,
> -                                   dev, &ifc_vdpa_ops, 1, name, false);
> +                                   dev, &ifc_vdpa_ops, 1, 1, name, false);
>         if (IS_ERR(adapter)) {
>                 IFCVF_ERR(pdev, "Failed to allocate vDPA structure");
>                 return PTR_ERR(adapter);
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index fcfc28460b72..a76417892ef3 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -2282,7 +2282,8 @@ static u32 mlx5_vdpa_get_generation(struct vdpa_device *vdev)
>         return mvdev->generation;
>  }
>
> -static int mlx5_vdpa_set_map(struct vdpa_device *vdev, struct vhost_iotlb *iotlb)
> +static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
> +                            struct vhost_iotlb *iotlb)
>  {
>         struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
>         bool change_map;
> @@ -2581,7 +2582,7 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name,
>         }
>
>         ndev = vdpa_alloc_device(struct mlx5_vdpa_net, mvdev.vdev, mdev->device, &mlx5_vdpa_ops,
> -                                1, name, false);
> +                                1, 1, name, false);
>         if (IS_ERR(ndev))
>                 return PTR_ERR(ndev);
>
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index a07bf0130559..1793dc12b208 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -160,6 +160,7 @@ static void vdpa_release_dev(struct device *d)
>   * @parent: the parent device
>   * @config: the bus operations that is supported by this device
>   * @ngroups: number of groups supported by this device
> + * @nas: number of address spaces supported by this device
>   * @size: size of the parent structure that contains private data
>   * @name: name of the vdpa device; optional.
>   * @use_va: indicate whether virtual address must be used by this device
> @@ -172,7 +173,7 @@ static void vdpa_release_dev(struct device *d)
>   */
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>                                         const struct vdpa_config_ops *config,
> -                                       unsigned int ngroups,
> +                                       unsigned int ngroups, unsigned int nas,
>                                         size_t size, const char *name,
>                                         bool use_va)
>  {
> @@ -206,6 +207,7 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>         vdev->features_valid = false;
>         vdev->use_va = use_va;
>         vdev->ngroups = ngroups;
> +       vdev->nas = nas;
>
>         if (name)
>                 err = dev_set_name(&vdev->dev, "%s", name);
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index c98cb1f869fa..659e2e2e4b0c 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -251,7 +251,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr)
>                 ops = &vdpasim_config_ops;
>
>         vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops, 1,
> -                                   dev_attr->name, false);
> +                                   1, dev_attr->name, false);
>         if (IS_ERR(vdpasim)) {
>                 ret = PTR_ERR(vdpasim);
>                 goto err_alloc;
> @@ -539,7 +539,7 @@ static struct vdpa_iova_range vdpasim_get_iova_range(struct vdpa_device *vdpa)
>         return range;
>  }
>
> -static int vdpasim_set_map(struct vdpa_device *vdpa,
> +static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>                            struct vhost_iotlb *iotlb)
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> @@ -566,7 +566,8 @@ static int vdpasim_set_map(struct vdpa_device *vdpa,
>         return ret;
>  }
>
> -static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
> +static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
> +                          u64 iova, u64 size,
>                            u64 pa, u32 perm, void *opaque)
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> @@ -580,7 +581,8 @@ static int vdpasim_dma_map(struct vdpa_device *vdpa, u64 iova, u64 size,
>         return ret;
>  }
>
> -static int vdpasim_dma_unmap(struct vdpa_device *vdpa, u64 iova, u64 size)
> +static int vdpasim_dma_unmap(struct vdpa_device *vdpa, unsigned int asid,
> +                            u64 iova, u64 size)
>  {
>         struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 655ff7029401..6bf755f84d26 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -599,10 +599,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>                 return r;
>
>         if (ops->dma_map) {
> -               r = ops->dma_map(vdpa, iova, size, pa, perm, opaque);
> +               r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
>         } else if (ops->set_map) {
>                 if (!v->in_batch)
> -                       r = ops->set_map(vdpa, iotlb);
> +                       r = ops->set_map(vdpa, 0, iotlb);
>         } else {
>                 r = iommu_map(v->domain, iova, pa, size,
>                               perm_to_iommu_flags(perm));
> @@ -628,10 +628,10 @@ static void vhost_vdpa_unmap(struct vhost_vdpa *v,
>         vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
>
>         if (ops->dma_map) {
> -               ops->dma_unmap(vdpa, iova, size);
> +               ops->dma_unmap(vdpa, 0, iova, size);
>         } else if (ops->set_map) {
>                 if (!v->in_batch)
> -                       ops->set_map(vdpa, iotlb);
> +                       ops->set_map(vdpa, 0, iotlb);
>         } else {
>                 iommu_unmap(v->domain, iova, size);
>         }
> @@ -863,7 +863,7 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev,
>                 break;
>         case VHOST_IOTLB_BATCH_END:
>                 if (v->in_batch && ops->set_map)
> -                       ops->set_map(vdpa, iotlb);
> +                       ops->set_map(vdpa, 0, iotlb);
>                 v->in_batch = false;
>                 break;
>         default:
> @@ -1128,6 +1128,10 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         int minor;
>         int r;
>
> +       /* Only support 1 address space and 1 groups */
> +       if (vdpa->ngroups != 1 || vdpa->nas != 1)
> +               return -EOPNOTSUPP;
> +
>         v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
>         if (!v)
>                 return -ENOMEM;
> diff --git a/include/linux/vdpa.h b/include/linux/vdpa.h
> index 026b7ad72ed7..de22ca1a8ef3 100644
> --- a/include/linux/vdpa.h
> +++ b/include/linux/vdpa.h
> @@ -69,6 +69,8 @@ struct vdpa_mgmt_dev;
>   * @cf_mutex: Protects get and set access to configuration layout.
>   * @index: device index
>   * @features_valid: were features initialized? for legacy guests
> + * @ngroups: the number of virtqueue groups
> + * @nas: the number of address spaces
>   * @use_va: indicate whether virtual address must be used by this device
>   * @nvqs: maximum number of supported virtqueues
>   * @mdev: management device pointer; caller must setup when registering device as part
> @@ -86,6 +88,7 @@ struct vdpa_device {
>         int nvqs;
>         struct vdpa_mgmt_dev *mdev;
>         unsigned int ngroups;
> +       unsigned int nas;
>  };
>
>  /**
> @@ -240,6 +243,7 @@ struct vdpa_map_file {
>   *                             Needed for device that using device
>   *                             specific DMA translation (on-chip IOMMU)
>   *                             @vdev: vdpa device
> + *                             @asid: address space identifier
>   *                             @iotlb: vhost memory mapping to be
>   *                             used by the vDPA
>   *                             Returns integer: success (0) or error (< 0)
> @@ -248,6 +252,7 @@ struct vdpa_map_file {
>   *                             specific DMA translation (on-chip IOMMU)
>   *                             and preferring incremental map.
>   *                             @vdev: vdpa device
> + *                             @asid: address space identifier
>   *                             @iova: iova to be mapped
>   *                             @size: size of the area
>   *                             @pa: physical address for the map
> @@ -259,6 +264,7 @@ struct vdpa_map_file {
>   *                             specific DMA translation (on-chip IOMMU)
>   *                             and preferring incremental unmap.
>   *                             @vdev: vdpa device
> + *                             @asid: address space identifier
>   *                             @iova: iova to be unmapped
>   *                             @size: size of the area
>   *                             Returns integer: success (0) or error (< 0)
> @@ -309,10 +315,12 @@ struct vdpa_config_ops {
>         struct vdpa_iova_range (*get_iova_range)(struct vdpa_device *vdev);
>
>         /* DMA ops */
> -       int (*set_map)(struct vdpa_device *vdev, struct vhost_iotlb *iotlb);
> -       int (*dma_map)(struct vdpa_device *vdev, u64 iova, u64 size,
> -                      u64 pa, u32 perm, void *opaque);
> -       int (*dma_unmap)(struct vdpa_device *vdev, u64 iova, u64 size);
> +       int (*set_map)(struct vdpa_device *vdev, unsigned int asid,
> +                      struct vhost_iotlb *iotlb);
> +       int (*dma_map)(struct vdpa_device *vdev, unsigned int asid,
> +                      u64 iova, u64 size, u64 pa, u32 perm, void *opaque);
> +       int (*dma_unmap)(struct vdpa_device *vdev, unsigned int asid,
> +                        u64 iova, u64 size);
>
>         /* Free device resources */
>         void (*free)(struct vdpa_device *vdev);
> @@ -320,7 +328,7 @@ struct vdpa_config_ops {
>
>  struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>                                         const struct vdpa_config_ops *config,
> -                                       unsigned int ngroups,
> +                                       unsigned int ngroups, unsigned int nas,
>                                         size_t size, const char *name,
>                                         bool use_va);
>
> @@ -332,17 +340,19 @@ struct vdpa_device *__vdpa_alloc_device(struct device *parent,
>   * @parent: the parent device
>   * @config: the bus operations that is supported by this device
>   * @ngroups: the number of virtqueue groups supported by this device
> + * @nas: the number of address spaces
>   * @name: name of the vdpa device
>   * @use_va: indicate whether virtual address must be used by this device
>   *
>   * Return allocated data structure or ERR_PTR upon error
>   */
> -#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, name, use_va)   \
> +#define vdpa_alloc_device(dev_struct, member, parent, config, ngroups, nas, \
> +                         name, use_va) \
>                           container_of((__vdpa_alloc_device( \
> -                                      parent, config, ngroups, \
> -                                      sizeof(dev_struct) + \
> +                                      parent, config, ngroups, nas, \
> +                                      (sizeof(dev_struct) + \

Maybe too nitpick or I'm missing something, but do we need to add the
parentheses around (sizeof(dev_struct) + BUILD_BUG_ON_ZERO(...)) ?

>                                        BUILD_BUG_ON_ZERO(offsetof( \
> -                                      dev_struct, member)), name, use_va)), \
> +                                      dev_struct, member))), name, use_va)), \
>                                        dev_struct, member)
>
>  int vdpa_register_device(struct vdpa_device *vdev, int nvqs);
> --
> 2.25.0
>

