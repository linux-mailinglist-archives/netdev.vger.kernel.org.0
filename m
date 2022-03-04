Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5085C4CDBC3
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiCDSGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbiCDSGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:06:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7F381C46B2
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 10:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646417112;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1LQCaFXHVFxd9eTB5EpGTf9HGKm8GO1n2hfxb2aYkKc=;
        b=Z1WQcKDsfEU8ojtn92d+UBvLDSD4J8vAGXXGhrSVccO1Gy4She7GYqz0d0JOlSJXpqxT2+
        Eadg0vsfkRNOlo9/es4fl/KaPaV4ZifHnYNbCIWAi00zjvNwPivkLjIT2w622lx6/HthdP
        u0Em+G0hIVN2xw52Gda94aReB5J+Fc0=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-661-G0Mn034_P0GZKqV3j4zzbQ-1; Fri, 04 Mar 2022 13:05:11 -0500
X-MC-Unique: G0Mn034_P0GZKqV3j4zzbQ-1
Received: by mail-qk1-f199.google.com with SMTP id i10-20020a05620a144a00b00648d4fa059dso6167598qkl.0
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 10:05:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1LQCaFXHVFxd9eTB5EpGTf9HGKm8GO1n2hfxb2aYkKc=;
        b=Zkmmvk/y6lSdYUQMcxWqMd/FUQHjmZUs0QwHOhlJb3Ku3QsJP+6rrdkvzlH365ybO1
         6o6CBzKtf/SO4yp1n7eKlf+ctjW6hRidI3RdQwziZEJAPaRL/iYLVLDnbIP6Ry+Kr6JY
         8vfFkcyfGRRHid7RtfXkheIjK1uSUHz5O/1+eqdcx1HUt703Fe5vbbkrd0vVNr0v0Wfe
         d9w9a1qMnFKxgHzPefzx396nbrbebYY43qEajj8fSnr/oSzevUfJKNB5gwb7xaaa7G0W
         OpUCab5CZp6yf0QxSJGDsBYAUt81WnpU7LPbdk89luP+nk0HqY+O+6FSJAB3++zQAemV
         09Hg==
X-Gm-Message-State: AOAM533C74V9jwLY5nilvdp7JaxsxMXz16RfmuY6B3iRXQnTvxwLX2K/
        NneeTLAYKreVDckMkz7TsAfjPiJgy4Bc6sEGJdLxRnebucSv5eY/iMmA2hLUCxe4tqtXS0+A8Ar
        5hqvQfuCkV5LEXHT8COl2K+ZmDrYaorB5
X-Received: by 2002:a05:620a:1a97:b0:663:8d24:8cac with SMTP id bl23-20020a05620a1a9700b006638d248cacmr3336466qkb.632.1646417110544;
        Fri, 04 Mar 2022 10:05:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzxdJDiS+VCQGyEYcH1o6RcK4SfVP0dMzDWB8rgpswFGZgSkAo4tGCe1isg3UE4F8p5mxDoeswbU7YOx47iz0c=
X-Received: by 2002:a05:620a:1a97:b0:663:8d24:8cac with SMTP id
 bl23-20020a05620a1a9700b006638d248cacmr3336441qkb.632.1646417110187; Fri, 04
 Mar 2022 10:05:10 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-16-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-16-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 4 Mar 2022 19:04:34 +0100
Message-ID: <CAJaqyWcesvA68ghx15y0eJgZvXr5MNqYy2X2S+PJ3U_K8Z+DdQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/19] vhost-vdpa: support ASID based IOTLB API
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
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 10:28 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patch extends the vhost-vdpa to support ASID based IOTLB API. The
> vhost-vdpa device will allocated multiple IOTLBs for vDPA device that
> supports multiple address spaces. The IOTLBs and vDPA device memory
> mappings is determined and maintained through ASID.
>
> Note that we still don't support vDPA device with more than one
> address spaces that depends on platform IOMMU. This work will be done
> by moving the IOMMU logic from vhost-vDPA to vDPA device driver.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vhost/vdpa.c  | 129 ++++++++++++++++++++++++++++++++----------
>  drivers/vhost/vhost.c |   2 +-
>  2 files changed, 100 insertions(+), 31 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index 47e6cf9d0881..4bcf824e3b12 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -28,7 +28,8 @@
>  enum {
>         VHOST_VDPA_BACKEND_FEATURES =
>         (1ULL << VHOST_BACKEND_F_IOTLB_MSG_V2) |
> -       (1ULL << VHOST_BACKEND_F_IOTLB_BATCH),
> +       (1ULL << VHOST_BACKEND_F_IOTLB_BATCH) |
> +       (1ULL << VHOST_BACKEND_F_IOTLB_ASID),
>  };
>
>  #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
> @@ -57,13 +58,20 @@ struct vhost_vdpa {
>         struct eventfd_ctx *config_ctx;
>         int in_batch;
>         struct vdpa_iova_range range;
> -       int used_as;
> +       u32 batch_asid;
>  };
>
>  static DEFINE_IDA(vhost_vdpa_ida);
>
>  static dev_t vhost_vdpa_major;
>
> +static inline u32 iotlb_to_asid(struct vhost_iotlb *iotlb)
> +{
> +       struct vhost_vdpa_as *as = container_of(iotlb, struct
> +                                               vhost_vdpa_as, iotlb);
> +       return as->id;
> +}
> +
>  static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
>  {
>         struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> @@ -76,6 +84,16 @@ static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
>         return NULL;
>  }
>
> +static struct vhost_iotlb *asid_to_iotlb(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct vhost_vdpa_as *as = asid_to_as(v, asid);
> +
> +       if (!as)
> +               return NULL;
> +
> +       return &as->iotlb;
> +}
> +
>  static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
>  {
>         struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> @@ -84,6 +102,9 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
>         if (asid_to_as(v, asid))
>                 return NULL;
>
> +       if (asid >= v->vdpa->nas)
> +               return NULL;
> +
>         as = kmalloc(sizeof(*as), GFP_KERNEL);
>         if (!as)
>                 return NULL;
> @@ -91,18 +112,24 @@ static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
>         vhost_iotlb_init(&as->iotlb, 0, 0);
>         as->id = asid;
>         hlist_add_head(&as->hash_link, head);
> -       ++v->used_as;
>
>         return as;
>  }
>
> -static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> +static struct vhost_vdpa_as *vhost_vdpa_find_alloc_as(struct vhost_vdpa *v,
> +                                                     u32 asid)
>  {
>         struct vhost_vdpa_as *as = asid_to_as(v, asid);
>
> -       /* Remove default address space is not allowed */
> -       if (asid == 0)
> -               return -EINVAL;
> +       if (as)
> +               return as;
> +
> +       return vhost_vdpa_alloc_as(v, asid);
> +}
> +
> +static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct vhost_vdpa_as *as = asid_to_as(v, asid);
>
>         if (!as)
>                 return -EINVAL;
> @@ -110,7 +137,6 @@ static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
>         hlist_del(&as->hash_link);
>         vhost_iotlb_reset(&as->iotlb);
>         kfree(as);
> -       --v->used_as;
>
>         return 0;
>  }
> @@ -665,6 +691,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>         struct vhost_dev *dev = &v->vdev;
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
> +       u32 asid = iotlb_to_asid(iotlb);
>         int r = 0;
>
>         r = vhost_iotlb_add_range_ctx(iotlb, iova, iova + size - 1,
> @@ -673,10 +700,10 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>                 return r;
>
>         if (ops->dma_map) {
> -               r = ops->dma_map(vdpa, 0, iova, size, pa, perm, opaque);
> +               r = ops->dma_map(vdpa, asid, iova, size, pa, perm, opaque);
>         } else if (ops->set_map) {
>                 if (!v->in_batch)
> -                       r = ops->set_map(vdpa, 0, iotlb);
> +                       r = ops->set_map(vdpa, asid, iotlb);
>         } else {
>                 r = iommu_map(v->domain, iova, pa, size,
>                               perm_to_iommu_flags(perm));
> @@ -692,23 +719,35 @@ static int vhost_vdpa_map(struct vhost_vdpa *v, struct vhost_iotlb *iotlb,
>         return 0;
>  }
>
> -static void vhost_vdpa_unmap(struct vhost_vdpa *v,
> -                            struct vhost_iotlb *iotlb,
> -                            u64 iova, u64 size)
> +static int vhost_vdpa_unmap(struct vhost_vdpa *v,
> +                           struct vhost_iotlb *iotlb,
> +                           u64 iova, u64 size)
>  {
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
> +       u32 asid = iotlb_to_asid(iotlb);
> +
> +       if (!iotlb)
> +               return -EINVAL;

I think there is no need of checking for this. Similar functions
assume the caller will pass non-null arguments, and
vhost_vdpa_process_iotlb_msg does it.

With that into account, I think there is little point in making this
function return something different than void.

Apart from that, iotlb is already used before checking for NULL.

>
>         vhost_vdpa_iotlb_unmap(v, iotlb, iova, iova + size - 1);
>
>         if (ops->dma_map) {
> -               ops->dma_unmap(vdpa, 0, iova, size);
> +               ops->dma_unmap(vdpa, asid, iova, size);
>         } else if (ops->set_map) {
>                 if (!v->in_batch)
> -                       ops->set_map(vdpa, 0, iotlb);
> +                       ops->set_map(vdpa, asid, iotlb);
>         } else {
>                 iommu_unmap(v->domain, iova, size);
>         }
> +
> +       /* If we are in the middle of batch processing, delay the free
> +        * of AS until BATCH_END.
> +        */
> +       if (!v->in_batch && !iotlb->nmaps)
> +               vhost_vdpa_remove_as(v, asid);
> +
> +       return 0;
>  }
>
>  static int vhost_vdpa_va_map(struct vhost_vdpa *v,
> @@ -916,33 +955,55 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>         struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
> -       struct vhost_vdpa_as *as = asid_to_as(v, 0);
> -       struct vhost_iotlb *iotlb = &as->iotlb;
> +       struct vhost_iotlb *iotlb = NULL;
> +       struct vhost_vdpa_as *as = NULL;
>         int r = 0;
>
>         mutex_lock(&dev->mutex);
>
> -       if (asid != 0)
> -               return -EINVAL;
> -
>         r = vhost_dev_check_owner(dev);
>         if (r)
>                 goto unlock;
>
> +       if (msg->type == VHOST_IOTLB_UPDATE ||
> +           msg->type == VHOST_IOTLB_BATCH_BEGIN) {
> +               as = vhost_vdpa_find_alloc_as(v, asid);
> +               if (!as) {
> +                       dev_err(&v->dev, "can't find and alloc asid %d\n",
> +                               asid);
> +                       return -EINVAL;
> +               }
> +               iotlb = &as->iotlb;
> +       } else
> +               iotlb = asid_to_iotlb(v, asid);
> +
> +       if ((v->in_batch && v->batch_asid != asid) || !iotlb) {
> +               if (v->in_batch && v->batch_asid != asid) {
> +                       dev_info(&v->dev, "batch id %d asid %d\n",
> +                                v->batch_asid, asid);
> +               }
> +               if (!iotlb)
> +                       dev_err(&v->dev, "no iotlb for asid %d\n", asid);
> +               return -EINVAL;
> +       }
> +
>         switch (msg->type) {
>         case VHOST_IOTLB_UPDATE:
>                 r = vhost_vdpa_process_iotlb_update(v, iotlb, msg);
>                 break;
>         case VHOST_IOTLB_INVALIDATE:
> -               vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
> +               r = vhost_vdpa_unmap(v, iotlb, msg->iova, msg->size);
>                 break;
>         case VHOST_IOTLB_BATCH_BEGIN:
> +               v->batch_asid = asid;
>                 v->in_batch = true;
>                 break;
>         case VHOST_IOTLB_BATCH_END:
>                 if (v->in_batch && ops->set_map)
> -                       ops->set_map(vdpa, 0, iotlb);
> +                       ops->set_map(vdpa, asid, iotlb);
>                 v->in_batch = false;
> +               if (!iotlb->nmaps)
> +                       vhost_vdpa_remove_as(v, asid);
>                 break;
>         default:
>                 r = -EINVAL;
> @@ -1030,9 +1091,17 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
>
>  static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
>  {
> +       struct vhost_vdpa_as *as;
> +       u32 asid;
> +
>         vhost_dev_cleanup(&v->vdev);
>         kfree(v->vdev.vqs);
> -       vhost_vdpa_remove_as(v, 0);
> +
> +       for (asid = 0; asid < v->vdpa->nas; asid++) {
> +               as = asid_to_as(v, asid);
> +               if (as)
> +                       vhost_vdpa_remove_as(v, asid);
> +       }
>  }
>
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
> @@ -1067,12 +1136,9 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>         vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>                        vhost_vdpa_process_iotlb_msg);
>
> -       if (!vhost_vdpa_alloc_as(v, 0))
> -               goto err_alloc_as;
> -
>         r = vhost_vdpa_alloc_domain(v);
>         if (r)
> -               goto err_alloc_as;
> +               goto err_alloc_domain;
>
>         vhost_vdpa_set_iova_range(v);
>
> @@ -1080,7 +1146,7 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>
>         return 0;
>
> -err_alloc_as:
> +err_alloc_domain:
>         vhost_vdpa_cleanup(v);
>  err:
>         atomic_dec(&v->opened);
> @@ -1205,8 +1271,11 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         int minor;
>         int i, r;
>
> -       /* Only support 1 address space and 1 groups */
> -       if (vdpa->ngroups != 1 || vdpa->nas != 1)
> +       /* We can't support platform IOMMU device with more than 1
> +        * group or as
> +        */
> +       if (!ops->set_map && !ops->dma_map &&
> +           (vdpa->ngroups > 1 || vdpa->nas > 1))
>                 return -EOPNOTSUPP;
>
>         v = kzalloc(sizeof(*v), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 1f514d98f0de..92eeb684c84d 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -1167,7 +1167,7 @@ ssize_t vhost_chr_write_iter(struct vhost_dev *dev,
>                                 ret = -EINVAL;
>                                 goto done;
>                         }
> -                       offset = sizeof(__u16);
> +                       offset = 0;
>                 } else
>                         offset = sizeof(__u32);
>                 break;
> --
> 2.25.0
>

