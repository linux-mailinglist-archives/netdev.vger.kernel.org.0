Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8330C4FF1CE
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbiDMI2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231206AbiDMI17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:27:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 20B58344DE
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649838337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v0sg5wD9F3C7lFkpRUCtz+AFJuASun9xz2y5waULHFA=;
        b=RYq/K4buwct0cmBmYAAmBiB/wNIXHOqE359Rn5uNgZJLu34lg/MJK/h9ujHkjajN1ZBUbh
        ghYZm7NC4aNk3PebpDIKUo84uU3ndIc0Y9aVq1E1IMorFzVcFjl02UwwZtXk4eD41WtP5w
        GssJA7Fpvm7unw7E13B6+KaQ7u1G9pY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-313-HeW6C5OVNVWa5nkYiEAZZA-1; Wed, 13 Apr 2022 04:25:36 -0400
X-MC-Unique: HeW6C5OVNVWa5nkYiEAZZA-1
Received: by mail-lf1-f70.google.com with SMTP id w25-20020a05651234d900b0044023ac3f64so636699lfr.0
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 01:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0sg5wD9F3C7lFkpRUCtz+AFJuASun9xz2y5waULHFA=;
        b=wl1enRLzwmg7hoz3noz5n76n/UHlvQDzdSY6uo40YdVHjfjv9Bg7BBuldvr6J54b5d
         HQR2QK3hL6XV5+59k44eDKV+kw4JZJ0xdguZ+4n5bpjPD83BagHbt7sMMQjaRaOMNFTK
         58/vzFdshVqywF+6/5gFzfy62+jdzq+DYChPuYM2kleOS4Jx5HeACRr0/MyLTC764cGL
         lKOOW3S0LvZOithN6vq8I6uIm3byFtZ3NaFiTKbDwFzxB6a6wPsurzelgzxRxyOTgXwB
         hzKmEFS0gMIePCCxc11wCl5/0ELC/zSIIHscW+Cd78tmx/5jO7HOB1/M2/oT98K5HtOr
         9pHQ==
X-Gm-Message-State: AOAM530CUSiDKqYeG+dXowsgu7XzUwGmYnNMtgpH/4b19ZF2wJaBSvAX
        cfwMH+Y7u6Ji2jay+rFjJtmtnlI0ZhZe/vHZR5DSFF/QxgbL7p9zgQv+PZP6QgoWSUBCyka4AVB
        94bw9Yq8ix+ejyUVVWpgj+p11SEjH8nfH
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id p21-20020a056512139500b00446d38279a5mr27259366lfa.210.1649838334270;
        Wed, 13 Apr 2022 01:25:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz3zmOddCT36R9o5k8D7bVrfy1PgoyGeIxjmsSaHPS/8MxdU59aexNFGa5g5E0VRyT+VsYFJyY7hgTdZSHZhsw=
X-Received: by 2002:a05:6512:1395:b0:446:d382:79a5 with SMTP id
 p21-20020a056512139500b00446d38279a5mr27259356lfa.210.1649838333983; Wed, 13
 Apr 2022 01:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220411031057.162485-1-lingshan.zhu@intel.com>
In-Reply-To: <20220411031057.162485-1-lingshan.zhu@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 13 Apr 2022 16:25:22 +0800
Message-ID: <CACGkMEu7dUYKr7Nv-fDFFBM4M1hvWuO8P17xNMEkwofiiP178A@mail.gmail.com>
Subject: Re: [PATCH] vDPA/ifcvf: allow userspace to suspend a queue
To:     Zhu Lingshan <lingshan.zhu@intel.com>
Cc:     mst <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 11:18 AM Zhu Lingshan <lingshan.zhu@intel.com> wrote:
>
> Formerly, ifcvf driver has implemented a lazy-initialization mechanism
> for the virtqueues, it would store all virtqueue config fields that
> passed down from the userspace, then load them to the virtqueues and
> enable the queues upon DRIVER_OK.
>
> To allow the userspace to suspend a virtqueue,
> this commit passes queue_enable to the virtqueue directly through
> set_vq_ready().
>
> This feature requires and this commits implementing all virtqueue
> ops(set_vq_addr, set_vq_num and set_vq_ready) to take immediate
> actions than lazy-initialization, so ifcvf_hw_enable() is retired.
>
> To avoid losing virtqueue configurations caused by multiple
> rounds of reset(), this commit also refactors thed evice reset
> routine, now it simply reset the config handler and the virtqueues,
> and only once device-reset().
>
> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> ---
>  drivers/vdpa/ifcvf/ifcvf_base.c | 94 ++++++++++++++++++++-------------
>  drivers/vdpa/ifcvf/ifcvf_base.h | 11 ++--
>  drivers/vdpa/ifcvf/ifcvf_main.c | 57 +++++---------------
>  3 files changed, 75 insertions(+), 87 deletions(-)
>
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.c b/drivers/vdpa/ifcvf/ifcvf_base.c
> index 48c4dadb0c7c..19eb0dcac123 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.c
> @@ -175,16 +175,12 @@ u8 ifcvf_get_status(struct ifcvf_hw *hw)
>  void ifcvf_set_status(struct ifcvf_hw *hw, u8 status)
>  {
>         vp_iowrite8(status, &hw->common_cfg->device_status);
> +       vp_ioread8(&hw->common_cfg->device_status);

This looks confusing, the name of the function is to set the status
but what actually implemented here is to get the status.

>  }
>
>  void ifcvf_reset(struct ifcvf_hw *hw)
>  {
> -       hw->config_cb.callback = NULL;
> -       hw->config_cb.private = NULL;
> -
>         ifcvf_set_status(hw, 0);
> -       /* flush set_status, make sure VF is stopped, reset */
> -       ifcvf_get_status(hw);
>  }
>
>  static void ifcvf_add_status(struct ifcvf_hw *hw, u8 status)
> @@ -331,68 +327,94 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num)
>         ifcvf_lm = (struct ifcvf_lm_cfg __iomem *)hw->lm_cfg;
>         q_pair_id = qid / hw->nr_vring;
>         avail_idx_addr = &ifcvf_lm->vring_lm_cfg[q_pair_id].idx_addr[qid % 2];
> -       hw->vring[qid].last_avail_idx = num;
>         vp_iowrite16(num, avail_idx_addr);
> +       vp_ioread16(avail_idx_addr);

This looks like a bug fix.

>
>         return 0;
>  }
>
> -static int ifcvf_hw_enable(struct ifcvf_hw *hw)
> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num)
>  {
> -       struct virtio_pci_common_cfg __iomem *cfg;
> -       u32 i;
> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>
> -       cfg = hw->common_cfg;
> -       for (i = 0; i < hw->nr_vring; i++) {
> -               if (!hw->vring[i].ready)
> -                       break;
> +       vp_iowrite16(qid, &cfg->queue_select);
> +       vp_iowrite16(num, &cfg->queue_size);
> +       vp_ioread16(&cfg->queue_size);
> +}
>
> -               vp_iowrite16(i, &cfg->queue_select);
> -               vp_iowrite64_twopart(hw->vring[i].desc, &cfg->queue_desc_lo,
> -                                    &cfg->queue_desc_hi);
> -               vp_iowrite64_twopart(hw->vring[i].avail, &cfg->queue_avail_lo,
> -                                     &cfg->queue_avail_hi);
> -               vp_iowrite64_twopart(hw->vring[i].used, &cfg->queue_used_lo,
> -                                    &cfg->queue_used_hi);
> -               vp_iowrite16(hw->vring[i].size, &cfg->queue_size);
> -               ifcvf_set_vq_state(hw, i, hw->vring[i].last_avail_idx);
> -               vp_iowrite16(1, &cfg->queue_enable);
> -       }
> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
> +                        u64 driver_area, u64 device_area)
> +{
> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +
> +       vp_iowrite16(qid, &cfg->queue_select);
> +       vp_iowrite64_twopart(desc_area, &cfg->queue_desc_lo,
> +                            &cfg->queue_desc_hi);
> +       vp_iowrite64_twopart(driver_area, &cfg->queue_avail_lo,
> +                            &cfg->queue_avail_hi);
> +       vp_iowrite64_twopart(device_area, &cfg->queue_used_lo,
> +                            &cfg->queue_used_hi);
> +       /* to flush IO */
> +       vp_ioread16(&cfg->queue_select);

Why do we need to flush I/O here?

>
>         return 0;
>  }
>
> -static void ifcvf_hw_disable(struct ifcvf_hw *hw)
> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready)
>  {
> -       u32 i;
> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
>
> -       ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);
> -       for (i = 0; i < hw->nr_vring; i++) {
> -               ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
> -       }
> +       vp_iowrite16(qid, &cfg->queue_select);
> +       vp_iowrite16(ready, &cfg->queue_enable);

I think we need a comment to explain that IFCVF can support write to
queue_enable since it's not allowed by the virtio spec.

> +       vp_ioread16(&cfg->queue_enable);
> +}
> +
> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid)
> +{
> +       struct virtio_pci_common_cfg __iomem *cfg = hw->common_cfg;
> +       bool queue_enable;
> +
> +       vp_iowrite16(qid, &cfg->queue_select);
> +       queue_enable = vp_ioread16(&cfg->queue_enable);
> +
> +       return (bool)queue_enable;
>  }
>
>  int ifcvf_start_hw(struct ifcvf_hw *hw)
>  {
> -       ifcvf_reset(hw);
>         ifcvf_add_status(hw, VIRTIO_CONFIG_S_ACKNOWLEDGE);
>         ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER);
>
>         if (ifcvf_config_features(hw) < 0)
>                 return -EINVAL;
>
> -       if (ifcvf_hw_enable(hw) < 0)
> -               return -EINVAL;
> -
>         ifcvf_add_status(hw, VIRTIO_CONFIG_S_DRIVER_OK);
>
>         return 0;
>  }
>
> +static void ifcvf_reset_vring(struct ifcvf_hw *hw)
> +{
> +       int i;
> +
> +       for (i = 0; i < hw->nr_vring; i++) {
> +               hw->vring[i].cb.callback = NULL;
> +               hw->vring[i].cb.private = NULL;
> +               ifcvf_set_vq_vector(hw, i, VIRTIO_MSI_NO_VECTOR);
> +       }
> +}
> +
> +static void ifcvf_reset_config_handler(struct ifcvf_hw *hw)
> +{
> +       hw->config_cb.callback = NULL;
> +       hw->config_cb.private = NULL;
> +       ifcvf_set_config_vector(hw, VIRTIO_MSI_NO_VECTOR);

Do we need to synchronize with the IRQ here?

> +}
> +
>  void ifcvf_stop_hw(struct ifcvf_hw *hw)
>  {
> -       ifcvf_hw_disable(hw);
> -       ifcvf_reset(hw);
> +       ifcvf_reset_vring(hw);
> +       ifcvf_reset_config_handler(hw);
>  }
>
>  void ifcvf_notify_queue(struct ifcvf_hw *hw, u16 qid)
> diff --git a/drivers/vdpa/ifcvf/ifcvf_base.h b/drivers/vdpa/ifcvf/ifcvf_base.h
> index 115b61f4924b..41d86985361f 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_base.h
> +++ b/drivers/vdpa/ifcvf/ifcvf_base.h
> @@ -49,12 +49,6 @@
>  #define MSIX_VECTOR_DEV_SHARED                 3
>
>  struct vring_info {
> -       u64 desc;
> -       u64 avail;
> -       u64 used;
> -       u16 size;
> -       u16 last_avail_idx;
> -       bool ready;
>         void __iomem *notify_addr;
>         phys_addr_t notify_pa;
>         u32 irq;
> @@ -131,6 +125,11 @@ int ifcvf_set_vq_state(struct ifcvf_hw *hw, u16 qid, u16 num);
>  struct ifcvf_adapter *vf_to_adapter(struct ifcvf_hw *hw);
>  int ifcvf_probed_virtio_net(struct ifcvf_hw *hw);
>  u32 ifcvf_get_config_size(struct ifcvf_hw *hw);
> +int ifcvf_set_vq_address(struct ifcvf_hw *hw, u16 qid, u64 desc_area,
> +                        u64 driver_area, u64 device_area);
>  u16 ifcvf_set_vq_vector(struct ifcvf_hw *hw, u16 qid, int vector);
>  u16 ifcvf_set_config_vector(struct ifcvf_hw *hw, int vector);
> +void ifcvf_set_vq_num(struct ifcvf_hw *hw, u16 qid, u32 num);
> +void ifcvf_set_vq_ready(struct ifcvf_hw *hw, u16 qid, bool ready);
> +bool ifcvf_get_vq_ready(struct ifcvf_hw *hw, u16 qid);
>  #endif /* _IFCVF_H_ */
> diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
> index 4366320fb68d..e442aa11333e 100644
> --- a/drivers/vdpa/ifcvf/ifcvf_main.c
> +++ b/drivers/vdpa/ifcvf/ifcvf_main.c
> @@ -374,37 +374,6 @@ static int ifcvf_start_datapath(void *private)
>         return ret;
>  }
>
> -static int ifcvf_stop_datapath(void *private)
> -{
> -       struct ifcvf_hw *vf = ifcvf_private_to_vf(private);
> -       int i;
> -
> -       for (i = 0; i < vf->nr_vring; i++)
> -               vf->vring[i].cb.callback = NULL;
> -
> -       ifcvf_stop_hw(vf);
> -
> -       return 0;
> -}
> -
> -static void ifcvf_reset_vring(struct ifcvf_adapter *adapter)
> -{
> -       struct ifcvf_hw *vf = ifcvf_private_to_vf(adapter);
> -       int i;
> -
> -       for (i = 0; i < vf->nr_vring; i++) {
> -               vf->vring[i].last_avail_idx = 0;
> -               vf->vring[i].desc = 0;
> -               vf->vring[i].avail = 0;
> -               vf->vring[i].used = 0;
> -               vf->vring[i].ready = 0;
> -               vf->vring[i].cb.callback = NULL;
> -               vf->vring[i].cb.private = NULL;
> -       }
> -
> -       ifcvf_reset(vf);
> -}
> -
>  static struct ifcvf_adapter *vdpa_to_adapter(struct vdpa_device *vdpa_dev)
>  {
>         return container_of(vdpa_dev, struct ifcvf_adapter, vdpa);
> @@ -477,6 +446,8 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>         if (status_old == status)
>                 return;
>
> +       ifcvf_set_status(vf, status);
> +
>         if ((status & VIRTIO_CONFIG_S_DRIVER_OK) &&
>             !(status_old & VIRTIO_CONFIG_S_DRIVER_OK)) {
>                 ret = ifcvf_request_irq(adapter);

Does this mean e.g for DRIVER_OK the device may work before the
interrupt handler is requested?

Looks racy.

Thanks

> @@ -493,7 +464,6 @@ static void ifcvf_vdpa_set_status(struct vdpa_device *vdpa_dev, u8 status)
>                                   status);
>         }
>
> -       ifcvf_set_status(vf, status);
>  }
>
>  static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
> @@ -509,12 +479,10 @@ static int ifcvf_vdpa_reset(struct vdpa_device *vdpa_dev)
>         if (status_old == 0)
>                 return 0;
>
> -       if (status_old & VIRTIO_CONFIG_S_DRIVER_OK) {
> -               ifcvf_stop_datapath(adapter);
> -               ifcvf_free_irq(adapter);
> -       }
> +       ifcvf_stop_hw(vf);
> +       ifcvf_free_irq(adapter);
>
> -       ifcvf_reset_vring(adapter);
> +       ifcvf_reset(vf);
>
>         return 0;
>  }
> @@ -554,14 +522,17 @@ static void ifcvf_vdpa_set_vq_ready(struct vdpa_device *vdpa_dev,
>  {
>         struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>
> -       vf->vring[qid].ready = ready;
> +       ifcvf_set_vq_ready(vf, qid, ready);
>  }
>
>  static bool ifcvf_vdpa_get_vq_ready(struct vdpa_device *vdpa_dev, u16 qid)
>  {
>         struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
> +       bool ready;
>
> -       return vf->vring[qid].ready;
> +       ready = ifcvf_get_vq_ready(vf, qid);
> +
> +       return ready;
>  }
>
>  static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
> @@ -569,7 +540,7 @@ static void ifcvf_vdpa_set_vq_num(struct vdpa_device *vdpa_dev, u16 qid,
>  {
>         struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>
> -       vf->vring[qid].size = num;
> +       ifcvf_set_vq_num(vf, qid, num);
>  }
>
>  static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
> @@ -578,11 +549,7 @@ static int ifcvf_vdpa_set_vq_address(struct vdpa_device *vdpa_dev, u16 qid,
>  {
>         struct ifcvf_hw *vf = vdpa_to_vf(vdpa_dev);
>
> -       vf->vring[qid].desc = desc_area;
> -       vf->vring[qid].avail = driver_area;
> -       vf->vring[qid].used = device_area;
> -
> -       return 0;
> +       return ifcvf_set_vq_address(vf, qid, desc_area, driver_area, device_area);
>  }
>
>  static void ifcvf_vdpa_kick_vq(struct vdpa_device *vdpa_dev, u16 qid)
> --
> 2.31.1
>

