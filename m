Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D09F3652D39
	for <lists+netdev@lfdr.de>; Wed, 21 Dec 2022 08:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiLUHTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Dec 2022 02:19:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234145AbiLUHTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Dec 2022 02:19:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84241209BE
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:18:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671607101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nlacvgblqRgjQqp66kSgstJzrl1cVqPeE2g1ienuDTo=;
        b=Cak2C6KamcIiOxPk3p3PnztbjOAb52goZq8uVVAVd5XaSu0l7wAodhHRgP8lidWZbZlobl
        klO4IWOzf6SRbnuRsTo6+OLbBORSBAc5e7F0hjs7Sr5Om9pxB97V4w7rf6RYD913d7R4ma
        dvwKzkk1ngcIO5d6MgmrW7KaBnAIbUk=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-183-2n5Rh4HXNv2R5bdteB6FaQ-1; Wed, 21 Dec 2022 02:18:19 -0500
X-MC-Unique: 2n5Rh4HXNv2R5bdteB6FaQ-1
Received: by mail-ed1-f71.google.com with SMTP id z3-20020a056402274300b0046b14f99390so10490328edd.9
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 23:18:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nlacvgblqRgjQqp66kSgstJzrl1cVqPeE2g1ienuDTo=;
        b=dZ09z/0d4/1IzYzBl2werlQCuF63HUknPE/rj0fUWlWgjSUJjhpfq+SiRoeQjHT0Ip
         x1/tZGDAq9hJIBAgWk5Ea9gjli5swtaF9/6qV6sO9SCG6k8Uv5G1r/4axVNbBlIigCCR
         PlMOuZLzHN9gUJX43XW/tqvd9EcHIQCt/pEXbU9xGc1o2Jyg40rRXuMQPpdgKGN8fqkE
         oiBC+GdZa6qjE7USo3L+lL1xDjRKBjaXUQJxIoJDy6p3czDVSrt/3qi204TkL6MhSwBA
         EbXGgOHPc01SJaMOFPt5tsEANuodg4vKa25cW4c7P8EGVvIX9Tb9RPri/oWRQCMLffbv
         B7TA==
X-Gm-Message-State: AFqh2kqZydf2n6OikxEpVubu3jK3+W20AzYQiK50ifHFMV/pD9MsxQDe
        alFt3U9KX31moRjpGW/Iq8GA+Z4PJTThY51P6M7M0lvhbeVvI+Bt/xs/RGRnKg3/WltMty6tF5i
        kZCCoUFSFvoMi0yO6OhNBvkUnsqlZ7hrp
X-Received: by 2002:a17:906:6d5a:b0:83c:17d9:67a8 with SMTP id a26-20020a1709066d5a00b0083c17d967a8mr65000ejt.540.1671607098814;
        Tue, 20 Dec 2022 23:18:18 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuzlsICdOi1XsQcOQoxAwJvryf5JuNM6c3TqgmwU1+PwZghUoO7dzApodHgZZy4Kvd4Eu9EUUskw6B/bKoPcYY=
X-Received: by 2002:a17:906:6d5a:b0:83c:17d9:67a8 with SMTP id
 a26-20020a1709066d5a00b0083c17d967a8mr64995ejt.540.1671607098627; Tue, 20 Dec
 2022 23:18:18 -0800 (PST)
MIME-Version: 1.0
References: <20221214163025.103075-1-sgarzare@redhat.com> <20221214163025.103075-7-sgarzare@redhat.com>
In-Reply-To: <20221214163025.103075-7-sgarzare@redhat.com>
From:   Eugenio Perez Martin <eperezma@redhat.com>
Date:   Wed, 21 Dec 2022 08:17:41 +0100
Message-ID: <CAJaqyWdwa5P6hXJ5Ovup+Uz3293Asr10CLvi4JVQZqDL-M1p1A@mail.gmail.com>
Subject: Re: [RFC PATCH 6/6] vdpa_sim: add support for user VA
To:     Stefano Garzarella <sgarzare@redhat.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, stefanha@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 14, 2022 at 5:31 PM Stefano Garzarella <sgarzare@redhat.com> wrote:
>
> The new "use_va" module parameter (default: false) is used in

Why not true by default? I'd say it makes more sense for the simulator
to use va mode and only use pa for testing it.

> vdpa_alloc_device() to inform the vDPA framework that the device
> supports VA.
>
> vringh is initialized to use VA only when "use_va" is true and the
> user's mm has been bound. So, only when the bus supports user VA
> (e.g. vhost-vdpa).
>
> vdpasim_mm_work_fn work is used to attach the kthread to the user
> address space when the .bind_mm callback is invoked, and to detach
> it when the device is reset.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  drivers/vdpa/vdpa_sim/vdpa_sim.h |   1 +
>  drivers/vdpa/vdpa_sim/vdpa_sim.c | 104 ++++++++++++++++++++++++++++++-
>  2 files changed, 103 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.h b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> index 07ef53ea375e..1b010e5c0445 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.h
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.h
> @@ -55,6 +55,7 @@ struct vdpasim {
>         struct vdpasim_virtqueue *vqs;
>         struct kthread_worker *worker;
>         struct kthread_work work;
> +       struct mm_struct *mm_bound;
>         struct vdpasim_dev_attr dev_attr;
>         /* spinlock to synchronize virtqueue state */
>         spinlock_t lock;
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 36a1d2e0a6ba..6e07cedef30c 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -36,10 +36,90 @@ module_param(max_iotlb_entries, int, 0444);
>  MODULE_PARM_DESC(max_iotlb_entries,
>                  "Maximum number of iotlb entries for each address space. 0 means unlimited. (default: 2048)");
>
> +static bool use_va;
> +module_param(use_va, bool, 0444);
> +MODULE_PARM_DESC(use_va, "Enable the device's ability to use VA");
> +
>  #define VDPASIM_QUEUE_ALIGN PAGE_SIZE
>  #define VDPASIM_QUEUE_MAX 256
>  #define VDPASIM_VENDOR_ID 0
>
> +struct vdpasim_mm_work {
> +       struct kthread_work work;
> +       struct task_struct *owner;
> +       struct mm_struct *mm;
> +       bool bind;
> +       int ret;
> +};
> +
> +static void vdpasim_mm_work_fn(struct kthread_work *work)
> +{
> +       struct vdpasim_mm_work *mm_work =
> +               container_of(work, struct vdpasim_mm_work, work);
> +
> +       mm_work->ret = 0;
> +
> +       if (mm_work->bind) {
> +               kthread_use_mm(mm_work->mm);
> +#if 0
> +               if (mm_work->owner)
> +                       mm_work->ret = cgroup_attach_task_all(mm_work->owner,
> +                                                             current);
> +#endif
> +       } else {
> +#if 0
> +               //TODO: check it
> +               cgroup_release(current);
> +#endif
> +               kthread_unuse_mm(mm_work->mm);
> +       }
> +}
> +
> +static void vdpasim_worker_queue_mm(struct vdpasim *vdpasim,
> +                                   struct vdpasim_mm_work *mm_work)
> +{
> +       struct kthread_work *work = &mm_work->work;
> +
> +       kthread_init_work(work, vdpasim_mm_work_fn);
> +       kthread_queue_work(vdpasim->worker, work);
> +
> +       spin_unlock(&vdpasim->lock);
> +       kthread_flush_work(work);
> +       spin_lock(&vdpasim->lock);
> +}
> +
> +static int vdpasim_worker_bind_mm(struct vdpasim *vdpasim,
> +                                 struct mm_struct *new_mm,
> +                                 struct task_struct *owner)
> +{
> +       struct vdpasim_mm_work mm_work;
> +
> +       mm_work.owner = owner;
> +       mm_work.mm = new_mm;
> +       mm_work.bind = true;
> +
> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
> +
> +       if (!mm_work.ret)
> +               vdpasim->mm_bound = new_mm;
> +
> +       return mm_work.ret;
> +}
> +
> +static void vdpasim_worker_unbind_mm(struct vdpasim *vdpasim)
> +{
> +       struct vdpasim_mm_work mm_work;
> +
> +       if (!vdpasim->mm_bound)
> +               return;
> +
> +       mm_work.mm = vdpasim->mm_bound;
> +       mm_work.bind = false;
> +
> +       vdpasim_worker_queue_mm(vdpasim, &mm_work);
> +
> +       vdpasim->mm_bound = NULL;
> +}
>  static struct vdpasim *vdpa_to_sim(struct vdpa_device *vdpa)
>  {
>         return container_of(vdpa, struct vdpasim, vdpa);
> @@ -66,8 +146,10 @@ static void vdpasim_vq_notify(struct vringh *vring)
>  static void vdpasim_queue_ready(struct vdpasim *vdpasim, unsigned int idx)
>  {
>         struct vdpasim_virtqueue *vq = &vdpasim->vqs[idx];
> +       bool va_enabled = use_va && vdpasim->mm_bound;
>
> -       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false, false,
> +       vringh_init_iotlb(&vq->vring, vdpasim->features, vq->num, false,
> +                         va_enabled,
>                           (struct vring_desc *)(uintptr_t)vq->desc_addr,
>                           (struct vring_avail *)
>                           (uintptr_t)vq->driver_addr,
> @@ -96,6 +178,9 @@ static void vdpasim_do_reset(struct vdpasim *vdpasim)
>  {
>         int i;
>
> +       //TODO: should we cancel the works?
> +       vdpasim_worker_unbind_mm(vdpasim);
> +
>         spin_lock(&vdpasim->iommu_lock);
>
>         for (i = 0; i < vdpasim->dev_attr.nvqs; i++) {
> @@ -275,7 +360,7 @@ struct vdpasim *vdpasim_create(struct vdpasim_dev_attr *dev_attr,
>
>         vdpasim = vdpa_alloc_device(struct vdpasim, vdpa, NULL, ops,
>                                     dev_attr->ngroups, dev_attr->nas,
> -                                   dev_attr->name, false);
> +                                   dev_attr->name, use_va);
>         if (IS_ERR(vdpasim)) {
>                 ret = PTR_ERR(vdpasim);
>                 goto err_alloc;
> @@ -657,6 +742,19 @@ static int vdpasim_set_map(struct vdpa_device *vdpa, unsigned int asid,
>         return ret;
>  }
>
> +static int vdpasim_bind_mm(struct vdpa_device *vdpa, struct mm_struct *mm,
> +                          struct task_struct *owner)
> +{
> +       struct vdpasim *vdpasim = vdpa_to_sim(vdpa);
> +       int ret;
> +
> +       spin_lock(&vdpasim->lock);
> +       ret = vdpasim_worker_bind_mm(vdpasim, mm, owner);
> +       spin_unlock(&vdpasim->lock);
> +
> +       return ret;
> +}
> +
>  static int vdpasim_dma_map(struct vdpa_device *vdpa, unsigned int asid,
>                            u64 iova, u64 size,
>                            u64 pa, u32 perm, void *opaque)
> @@ -744,6 +842,7 @@ static const struct vdpa_config_ops vdpasim_config_ops = {
>         .set_group_asid         = vdpasim_set_group_asid,
>         .dma_map                = vdpasim_dma_map,
>         .dma_unmap              = vdpasim_dma_unmap,
> +       .bind_mm                = vdpasim_bind_mm,
>         .free                   = vdpasim_free,
>  };
>
> @@ -776,6 +875,7 @@ static const struct vdpa_config_ops vdpasim_batch_config_ops = {
>         .get_iova_range         = vdpasim_get_iova_range,
>         .set_group_asid         = vdpasim_set_group_asid,
>         .set_map                = vdpasim_set_map,
> +       .bind_mm                = vdpasim_bind_mm,
>         .free                   = vdpasim_free,
>  };
>
> --
> 2.38.1
>

