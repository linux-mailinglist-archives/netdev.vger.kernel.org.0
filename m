Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707713BE1D5
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 06:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230203AbhGGEHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 00:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230159AbhGGEHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 00:07:19 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23257C061574
        for <netdev@vger.kernel.org>; Tue,  6 Jul 2021 21:04:39 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id hr1so1107607ejc.1
        for <netdev@vger.kernel.org>; Tue, 06 Jul 2021 21:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6zjpr5a14XdAl8V/dJOqiSPX85IwvcMo+5qs0QumtoU=;
        b=NcIlXNH6QZfLdl+rOmj0a0sYOVGpIuDw2eaLsZZxns1FcZzHWni5N7x3YZs8xhU0Bg
         p3L+7Qj/WTQbQU692SWnGKpJCRBD772YbcwGtcrRwjRjhQa7GEp8REi/5yYp+PDc0evH
         vd5DJiXSrQuyVixRfBeXo7htXkahDOMz/kjaOv+/rsZfHBYOJbyoV0fF28QNeKEsJsvH
         5VVyJmYRaOtAu+ApBTNbcXtbtwcKwr7TSEoRsUYwmkyyXmZvYBrleo86FA2a+jcohn6u
         MLDQ3xJFhojpYCsRXRxTYhxZ4UVhpycp0w1pN/nAo5AYlI6pJfkKUJ0/1nYQyixpFN/T
         UTRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6zjpr5a14XdAl8V/dJOqiSPX85IwvcMo+5qs0QumtoU=;
        b=YKxsB8oxdSNnt1ldFb8j7DrX84ioKvBMG/8cSZ55x/xB/uASqS7MDo1PqnKo8+Cxrk
         sLmbQH2Iou3o2lh4i68pfyY24pob5w7cC2gs6PSggz9uurOIkh9MQw1VhOI4yfiO5WY6
         pzyN1jdI7934wtDrCS7DHijWvhb+whhdelgMy4G8vklWK41dCvb+mi7nHvMWDMDhyeMy
         WLbYU4O9NylXBgSzL9GNkUhxIBmFmBRDoVynZ6WqciqikSP1RLMiSLtihUbjBaFVF5Ee
         oD2Nw52iKwPzFl7LBWBj5PgN1WfD8KgaB7fh+3AojljYVpEEaiHOWe65hVhG0NILxK89
         2j2Q==
X-Gm-Message-State: AOAM530QGzmI9yxXiBAnzOk5rjuARRjJsgYvOIYJ04eKvd5nzij8bXaW
        gOJ2htkJ+4ZtrsQUk6ZK4sNbA0X9oSq6Tj+HWlSh
X-Google-Smtp-Source: ABdhPJwodR/9AiC+ds303rzjTtBa597jDG5eURB1M4pjwxtZlg+3fLUQdBFK55hIze2MopS9emr3dsl4e5KrA2LexOc=
X-Received: by 2002:a17:906:58c7:: with SMTP id e7mr18831497ejs.197.1625630677638;
 Tue, 06 Jul 2021 21:04:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210705071910.31965-1-jasowang@redhat.com>
In-Reply-To: <20210705071910.31965-1-jasowang@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Wed, 7 Jul 2021 12:04:26 +0800
Message-ID: <CACycT3tMd750PQ0mgqCjHnxM4RmMcx2+Eo=2RBs2E2W3qPJang@mail.gmail.com>
Subject: Re: [PATCH 1/2] vdpa: support per virtqueue max queue size
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>, netdev@vger.kernel.org,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 5, 2021 at 3:19 PM Jason Wang <jasowang@redhat.com> wrote:
>
> Virtio spec allows the device to specify the per virtqueue max queue
> size. vDPA needs to adapt to this flexibility. E.g Qemu advertise a
> small control virtqueue for virtio-net.
>
> So this patch adds a index parameter to get_vq_num_max bus operations
> for the device to report its per virtqueue max queue size.
>
> Both VHOST_VDPA_GET_VRING_NUM and VDPA_ATTR_DEV_MAX_VQ_SIZE assume a
> global maximum size. So we iterate all the virtqueues to return the
> minimal size in this case. Actually, the VHOST_VDPA_GET_VRING_NUM is
> not a must for the userspace. Userspace may choose to check the
> VHOST_SET_VRING_NUM for proving or validating the maximum virtqueue
> size. Anyway, we can invent a per vq version of
> VHOST_VDPA_GET_VRING_NUM in the future if it's necessary.
>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_main.c   |  2 +-
>  drivers/vdpa/mlx5/net/mlx5_vnet.c |  2 +-
>  drivers/vdpa/vdpa.c               | 22 +++++++++++++++++++++-
>  drivers/vdpa/vdpa_sim/vdpa_sim.c  |  2 +-
>  drivers/vdpa/virtio_pci/vp_vdpa.c |  2 +-
>  drivers/vhost/vdpa.c              |  9 ++++++---
>  drivers/virtio/virtio_vdpa.c      |  2 +-
>  include/linux/vdpa.h              |  5 ++++-
>  8 files changed, 36 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index ab0ab5cf0f6e..646b340db2af 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -254,7 +254,7 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>         ifcvf_set_status(vf, status);
>  }
>
> -static u16 ifcvf_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev)
> +static u16 ifcvf_vdpa_get_vq_num_max(struct vdpa_device *vdpa_dev, u16 qid)
>  {
>         return IFCVF_QUEUE_MAX;
>  }
> diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> index dda5dc6f7737..afd6114d07b0 100644
> --- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
> +++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
> @@ -1584,7 +1584,7 @@ static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callba
>  }
>
>  #define MLX5_VDPA_MAX_VQ_ENTRIES 256
> -static u16 mlx5_vdpa_get_vq_num_max(struct vdpa_device *vdev)
> +static u16 mlx5_vdpa_get_vq_num_max(struct vdpa_device *vdev, u16 idx)
>  {
>         return MLX5_VDPA_MAX_VQ_ENTRIES;
>  }
> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> index bb3f1d1f0422..d77d59811389 100644
> --- a/drivers/vdpa/vdpa.c
> +++ b/drivers/vdpa/vdpa.c
> @@ -239,6 +239,26 @@ void vdpa_unregister_driver(struct vdpa_driver *drv)
>  }
>  EXPORT_SYMBOL_GPL(vdpa_unregister_driver);
>
> +/**
> + * vdpa_get_vq_num_max - get the maximum virtqueue size
> + * @vdev: vdpa device
> + */
> +u16 vdpa_get_vq_num_max(struct vdpa_device *vdev)
> +{
> +       const struct vdpa_config_ops *ops = vdev->config;
> +       u16 s, size = ops->get_vq_num_max(vdev, 0);
> +       int i;
> +
> +       for (i = 1; i < vdev->nvqs; i++) {
> +               s = ops->get_vq_num_max(vdev, i);
> +               if (s && s < size)
> +                       size = s;
> +       }
> +
> +       return size;
> +}
> +EXPORT_SYMBOL_GPL(vdpa_get_vq_num_max);
> +
>  /**
>   * vdpa_mgmtdev_register - register a vdpa management device
>   *
> @@ -502,7 +522,7 @@ vdpa_dev_fill(struct vdpa_device *vdev, struct sk_buff *msg, u32 portid, u32 seq
>
>         device_id = vdev->config->get_device_id(vdev);
>         vendor_id = vdev->config->get_vendor_id(vdev);
> -       max_vq_size = vdev->config->get_vq_num_max(vdev);
> +       max_vq_size = vdpa_get_vq_num_max(vdev);
>
>         err = -EMSGSIZE;
>         if (nla_put_string(msg, VDPA_ATTR_DEV_NAME, dev_name(&vdev->dev)))
> diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> index 98f793bc9376..49e29056f164 100644
> --- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
> +++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
> @@ -422,7 +422,7 @@ static void vdpasim_set_config_cb(struct vdpa_device *vdpa,
>         /* We don't support config interrupt */
>  }
>
> -static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa)
> +static u16 vdpasim_get_vq_num_max(struct vdpa_device *vdpa, u16 idx)
>  {
>         return VDPASIM_QUEUE_MAX;
>  }
> diff --git a/drivers/vdpa/virtio_pci/vp_vdpa.c b/drivers/vdpa/virtio_pci/vp_vdpa.c
> index c76ebb531212..2926641fb586 100644
> --- a/drivers/vdpa/virtio_pci/vp_vdpa.c
> +++ b/drivers/vdpa/virtio_pci/vp_vdpa.c
> @@ -195,7 +195,7 @@ static void vp_vdpa_set_status(struct vdpa_device *vdpa, u8 status)
>                 vp_vdpa_free_irq(vp_vdpa);
>  }
>
> -static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa)
> +static u16 vp_vdpa_get_vq_num_max(struct vdpa_device *vdpa, u16 qid)
>  {
>         return VP_VDPA_QUEUE_MAX;
>  }
> diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
> index fb41db3da611..c9ec395b8c42 100644
> --- a/drivers/vhost/vdpa.c
> +++ b/drivers/vhost/vdpa.c
> @@ -289,11 +289,14 @@ static long vhost_vdpa_set_features(struct vhost_vdpa *v, u64 __user *featurep)
>
>  static long vhost_vdpa_get_vring_num(struct vhost_vdpa *v, u16 __user *argp)
>  {
> -       struct vdpa_device *vdpa = v->vdpa;
> -       const struct vdpa_config_ops *ops = vdpa->config;
>         u16 num;
>
> -       num = ops->get_vq_num_max(vdpa);
> +       /*
> +        * VHOST_VDPA_GET_VRING_NUM asssumes a global max virtqueue

s/asssumes/assumes. Other looks good to me.

Thanks,
Yongji
