Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53FD24CDB7B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241379AbiCDR5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:57:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239769AbiCDR5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:57:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D35801CABD8
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:56:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646416618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hRi/zD2ooAq+A4IzpKs4rURTc4f7TC/VdxgM8GUmy2I=;
        b=Nml4xn8LmQQRm8uwuHm2Jjiz6LXwoPs5JYdt4rkZ6kg7kR3Xaa21wrzVj5GeEvd6UTsCeg
        kPE8U5nlCCCMkeMM7pFhOBzovWkW0km+EQuS+f45ZFiNtXHDxlj6P+6BcBDxg+UcgNJKyI
        70hvl4VHteSYXuP+x5iK+z+vtwEx6bo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-22-uRBHFu2oM1OZJFQ0UnfuNQ-1; Fri, 04 Mar 2022 12:56:56 -0500
X-MC-Unique: uRBHFu2oM1OZJFQ0UnfuNQ-1
Received: by mail-qk1-f199.google.com with SMTP id 2-20020a370a02000000b0060df1ac78baso6070424qkk.20
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 09:56:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hRi/zD2ooAq+A4IzpKs4rURTc4f7TC/VdxgM8GUmy2I=;
        b=AlPdj9zFtjtQIItfmP3veCp1+pmdREXZbPoJwhTO/V/L3n3NSfDM040dcWZxv8SYDP
         vcyg0o+eGrH+j8pw5vX0w7NfCdSqA+2cqZU9PUE49Sj1AYxogOTP1rHufrDNfybEmJ7L
         nEkqu6oi5kZ1yu0pQ2oSJoAs7/oQFAfalG1vQovMSCnmw2yU2sAFPjMAFxRrzFpnrOpK
         eX6sBTwiDl0vfAWOasOHak8xHRnbM8owtIkW3lfJe1zJveSxfaX/qGj5b3tmGT9Q9zkv
         z7ZXEdU+ioZimQ5OwrXxjUOvHMeM6qOPveOQtge+gzLo111c5AWxC+hrAOvFJGMPp576
         Rc6A==
X-Gm-Message-State: AOAM5301hJdid+ASppp9JWy2EDa0Io6HPaLZBY8ajEap6nbxY1rJ6i8p
        lwMVfWdGwhavCb0dv97ZxHQThGKgnOvLkmNkEHCUK60FeR6+rwTQESpRA5Ue+tCFNAMIXnppWHy
        zGoaWeSECK6YXHJ+ET/s/BEDzes6oGzdp
X-Received: by 2002:a05:620a:1a97:b0:663:8d24:8cac with SMTP id bl23-20020a05620a1a9700b006638d248cacmr3307769qkb.632.1646416616282;
        Fri, 04 Mar 2022 09:56:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyBeZl/CkbUYx2vNP9/H8BdiInQZ3wOTRtAtU/ycJucKvgpNEBxq16Qhcnq9wrMphVkKZYJU4zo+AGbEO8vHt4=
X-Received: by 2002:a05:620a:1a97:b0:663:8d24:8cac with SMTP id
 bl23-20020a05620a1a9700b006638d248cacmr3307763qkb.632.1646416616008; Fri, 04
 Mar 2022 09:56:56 -0800 (PST)
MIME-Version: 1.0
References: <20201216064818.48239-1-jasowang@redhat.com> <20220224212314.1326-1-gdawar@xilinx.com>
 <20220224212314.1326-11-gdawar@xilinx.com>
In-Reply-To: <20220224212314.1326-11-gdawar@xilinx.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Fri, 4 Mar 2022 18:56:19 +0100
Message-ID: <CAJaqyWfyEJMAkJhXhi5fF1WxfKqujoeZmemSJJPrvCTDCjCpew@mail.gmail.com>
Subject: Re: [RFC PATCH v2 10/19] vhost-vdpa: introduce asid based IOTLB
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

On Thu, Feb 24, 2022 at 10:26 PM Gautam Dawar <gautam.dawar@xilinx.com> wrote:
>
> This patch converts the vhost-vDPA device to support multiple IOTLBs
> tagged via ASID via hlist. This will be used for supporting multiple
> address spaces in the following patches.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> Signed-off-by: Gautam Dawar <gdawar@xilinx.com>
> ---
>  drivers/vhost/vdpa.c | 104 ++++++++++++++++++++++++++++++++-----------
>  1 file changed, 79 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index d0aacc0cc79a..4e8b7c4809cd 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -33,13 +33,21 @@ enum {
>
>  #define VHOST_VDPA_DEV_MAX (1U << MINORBITS)
>
> +#define VHOST_VDPA_IOTLB_BUCKETS 16
> +
> +struct vhost_vdpa_as {
> +       struct hlist_node hash_link;
> +       struct vhost_iotlb iotlb;
> +       u32 id;
> +};
> +
>  struct vhost_vdpa {
>         struct vhost_dev vdev;
>         struct iommu_domain *domain;
>         struct vhost_virtqueue *vqs;
>         struct completion completion;
>         struct vdpa_device *vdpa;
> -       struct vhost_iotlb *iotlb;
> +       struct hlist_head as[VHOST_VDPA_IOTLB_BUCKETS];
>         struct device dev;
>         struct cdev cdev;
>         atomic_t opened;
> @@ -49,12 +57,64 @@ struct vhost_vdpa {
>         struct eventfd_ctx *config_ctx;
>         int in_batch;
>         struct vdpa_iova_range range;
> +       int used_as;

This member is only modified to count the number of AS, but is never
read again. In patch 15/19 is deleted. Could we avoid introducing it
in all the series?

This is also in the previous series, but it was declared useless if I
recall correctly.

>  };
>
>  static DEFINE_IDA(vhost_vdpa_ida);
>
>  static dev_t vhost_vdpa_major;
>
> +static struct vhost_vdpa_as *asid_to_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> +       struct vhost_vdpa_as *as;
> +
> +       hlist_for_each_entry(as, head, hash_link)
> +               if (as->id == asid)
> +                       return as;
> +
> +       return NULL;
> +}
> +
> +static struct vhost_vdpa_as *vhost_vdpa_alloc_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct hlist_head *head = &v->as[asid % VHOST_VDPA_IOTLB_BUCKETS];
> +       struct vhost_vdpa_as *as;
> +
> +       if (asid_to_as(v, asid))
> +               return NULL;
> +
> +       as = kmalloc(sizeof(*as), GFP_KERNEL);
> +       if (!as)
> +               return NULL;
> +
> +       vhost_iotlb_init(&as->iotlb, 0, 0);
> +       as->id = asid;
> +       hlist_add_head(&as->hash_link, head);
> +       ++v->used_as;
> +
> +       return as;
> +}
> +
> +static int vhost_vdpa_remove_as(struct vhost_vdpa *v, u32 asid)
> +{
> +       struct vhost_vdpa_as *as = asid_to_as(v, asid);
> +
> +       /* Remove default address space is not allowed */
> +       if (asid == 0)
> +               return -EINVAL;

We must remove address space id 0 so we don't leak it at
vhost_vdpa_cleanup. I think the check could go away with no need of
moving it.

> +
> +       if (!as)
> +               return -EINVAL;
> +
> +       hlist_del(&as->hash_link);
> +       vhost_iotlb_reset(&as->iotlb);
> +       kfree(as);
> +       --v->used_as;
> +
> +       return 0;
> +}
> +
>  static void handle_vq_kick(struct vhost_work *work)
>  {
>         struct vhost_virtqueue *vq = container_of(work, struct vhost_virtqueue,
> @@ -554,15 +614,6 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v,
>         return vhost_vdpa_pa_unmap(v, iotlb, start, last);
>  }
>
> -static void vhost_vdpa_iotlb_free(struct vhost_vdpa *v)
> -{
> -       struct vhost_iotlb *iotlb = v->iotlb;
> -
> -       vhost_vdpa_iotlb_unmap(v, iotlb, 0ULL, 0ULL - 1);
> -       kfree(v->iotlb);
> -       v->iotlb = NULL;
> -}
> -
>  static int perm_to_iommu_flags(u32 perm)
>  {
>         int flags = 0;
> @@ -842,7 +893,8 @@ static int vhost_vdpa_process_iotlb_msg(struct vhost_dev *dev, u32 asid,
>         struct vhost_vdpa *v = container_of(dev, struct vhost_vdpa, vdev);
>         struct vdpa_device *vdpa = v->vdpa;
>         const struct vdpa_config_ops *ops = vdpa->config;
> -       struct vhost_iotlb *iotlb = v->iotlb;
> +       struct vhost_vdpa_as *as = asid_to_as(v, 0);
> +       struct vhost_iotlb *iotlb = &as->iotlb;
>         int r = 0;
>
>         mutex_lock(&dev->mutex);
> @@ -953,6 +1005,13 @@ static void vhost_vdpa_set_iova_range(struct vhost_vdpa *v)
>         }
>  }
>
> +static void vhost_vdpa_cleanup(struct vhost_vdpa *v)
> +{
> +       vhost_dev_cleanup(&v->vdev);
> +       kfree(v->vdev.vqs);
> +       vhost_vdpa_remove_as(v, 0);
> +}
> +
>  static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>  {
>         struct vhost_vdpa *v;
> @@ -985,15 +1044,12 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>         vhost_dev_init(dev, vqs, nvqs, 0, 0, 0, false,
>                        vhost_vdpa_process_iotlb_msg);
>
> -       v->iotlb = vhost_iotlb_alloc(0, 0);
> -       if (!v->iotlb) {
> -               r = -ENOMEM;
> -               goto err_init_iotlb;
> -       }
> +       if (!vhost_vdpa_alloc_as(v, 0))
> +               goto err_alloc_as;
>
>         r = vhost_vdpa_alloc_domain(v);
>         if (r)
> -               goto err_alloc_domain;
> +               goto err_alloc_as;
>
>         vhost_vdpa_set_iova_range(v);
>
> @@ -1001,11 +1057,8 @@ static int vhost_vdpa_open(struct inode *inode, struct file *filep)
>
>         return 0;
>
> -err_alloc_domain:
> -       vhost_vdpa_iotlb_free(v);
> -err_init_iotlb:
> -       vhost_dev_cleanup(&v->vdev);
> -       kfree(vqs);
> +err_alloc_as:
> +       vhost_vdpa_cleanup(v);
>  err:
>         atomic_dec(&v->opened);
>         return r;
> @@ -1029,11 +1082,9 @@ static int vhost_vdpa_release(struct inode *inode, struct file *filep)
>         vhost_vdpa_clean_irq(v);
>         vhost_vdpa_reset(v);
>         vhost_dev_stop(&v->vdev);
> -       vhost_vdpa_iotlb_free(v);
>         vhost_vdpa_free_domain(v);
>         vhost_vdpa_config_put(v);
>         vhost_dev_cleanup(&v->vdev);
> -       kfree(v->vdev.vqs);
>         mutex_unlock(&d->mutex);
>
>         atomic_dec(&v->opened);
> @@ -1129,7 +1180,7 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         const struct vdpa_config_ops *ops = vdpa->config;
>         struct vhost_vdpa *v;
>         int minor;
> -       int r;
> +       int i, r;
>
>         /* Only support 1 address space and 1 groups */
>         if (vdpa->ngroups != 1 || vdpa->nas != 1)
> @@ -1177,6 +1228,9 @@ static int vhost_vdpa_probe(struct vdpa_device *vdpa)
>         init_completion(&v->completion);
>         vdpa_set_drvdata(vdpa, v);
>
> +       for (i = 0; i < VHOST_VDPA_IOTLB_BUCKETS; i++)
> +               INIT_HLIST_HEAD(&v->as[i]);
> +
>         return 0;
>
>  err:
> --
> 2.25.0
>

