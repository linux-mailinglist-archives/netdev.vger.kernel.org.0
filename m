Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C751E23B7D5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 11:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHDJgf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 05:36:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39078 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726190AbgHDJgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 05:36:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596533791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O3dh+HsPiJkU5F4PPF+MJCTdUmQR6hxGLSPdKsfTb7M=;
        b=Qzjvmq/2FX64d10LMpvdgfAhkXBCi/nnP2WhG5EukbrKI5BdMb+jpc2B6KC4e2ODQvAM+H
        u1PHvSTqFC/eJG0sv1GeDCu0KF3d9J4FplZkj+NBxZ4YOcgTb5ttrG1s1apHRsP92Z49S0
        ArtYPq0JfZJmJfs3eNVirpBogJV+s+o=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-VqgwHO55O0yffp9u9rsjZQ-1; Tue, 04 Aug 2020 05:36:29 -0400
X-MC-Unique: VqgwHO55O0yffp9u9rsjZQ-1
Received: by mail-qv1-f71.google.com with SMTP id x4so17167379qvu.18
        for <netdev@vger.kernel.org>; Tue, 04 Aug 2020 02:36:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=O3dh+HsPiJkU5F4PPF+MJCTdUmQR6hxGLSPdKsfTb7M=;
        b=XJEZ76mNIkBtp6OJcOuHUQ+bozvvqyhOIwjb6WgyiRn6qv4dUrOjxDgY8dzHLbwVXa
         pvEvNEzvG4StQKxX0oZJ+GV8aF0wbX9dzF/v1Oq+7/C+gh2wu1fGJdaUzInGxBqLMxht
         ziwFaqhCJ03FVs/a0x4YRgZVsBwkl4qeMX07qMj7RNEmtCKXkJT/hgSehGcMgF9rTZk3
         zqpotliXbGvvflG4aGC03guzxsdzEKJeCXlOymsNQhGNpALZzQWJ5uWMalRskgCBSiAe
         XJCRXY8fg6p4r/atjhfn7ijbAkn4W17BSoZMHuQanLfsFhws+WRK0oTl0NvpQ2CGnc4W
         wu9g==
X-Gm-Message-State: AOAM530NkXrrpuoABY4R94G/ZzF0r+yYXaDiw2Cj+ApxNGxO5IT8iJVR
        puwb+DYi+LSZNoAC9RVOpif6GoaM6q5teXHopg5UQlC1pKTR9vwq/DDqjlvpUIv8TpfEvwHVKE9
        5sH+ks4eCSxw1XEht
X-Received: by 2002:a05:620a:209b:: with SMTP id e27mr19811338qka.431.1596533789376;
        Tue, 04 Aug 2020 02:36:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwCxhdQUQoBseq1K5S6XpXmEu/bVJf+QqnybD0ZbN2Wl/0CFV/5F+HlZO4X9ZKMYrCiTye/qg==
X-Received: by 2002:a05:620a:209b:: with SMTP id e27mr19811325qka.431.1596533789088;
        Tue, 04 Aug 2020 02:36:29 -0700 (PDT)
Received: from redhat.com (bzq-79-177-102-128.red.bezeqint.net. [79.177.102.128])
        by smtp.gmail.com with ESMTPSA id k2sm22957113qkf.127.2020.08.04.02.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2020 02:36:28 -0700 (PDT)
Date:   Tue, 4 Aug 2020 05:36:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     Jason Wang <jasowang@redhat.com>, alex.williamson@redhat.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com,
        wanpengli@tencent.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, kvm@vger.kernel.org, eli@mellanox.com,
        shahafs@mellanox.com, parav@mellanox.com
Subject: Re: [PATCH V5 4/6] vhost_vdpa: implement IRQ offloading in vhost_vdpa
Message-ID: <20200804053503-mutt-send-email-mst@kernel.org>
References: <20200731065533.4144-1-lingshan.zhu@intel.com>
 <20200731065533.4144-5-lingshan.zhu@intel.com>
 <5212669d-6e7b-21cb-6e25-1837d70624b2@redhat.com>
 <ae5385dc-6637-c5a3-b00a-02f66bb9a85f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ae5385dc-6637-c5a3-b00a-02f66bb9a85f@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 05:31:38PM +0800, Zhu, Lingshan wrote:
> 
> On 8/4/2020 4:51 PM, Jason Wang wrote:
> 
> 
>     On 2020/7/31 下午2:55, Zhu Lingshan wrote:
> 
>         This patch introduce a set of functions for setup/unsetup
>         and update irq offloading respectively by register/unregister
>         and re-register the irq_bypass_producer.
> 
>         With these functions, this commit can setup/unsetup
>         irq offloading through setting DRIVER_OK/!DRIVER_OK, and
>         update irq offloading through SET_VRING_CALL.
> 
>         Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
>         Suggested-by: Jason Wang <jasowang@redhat.com>
>         ---
>           drivers/vhost/Kconfig |  1 +
>           drivers/vhost/vdpa.c  | 79
>         ++++++++++++++++++++++++++++++++++++++++++-
>           2 files changed, 79 insertions(+), 1 deletion(-)
> 
>         diff --git a/drivers/vhost/Kconfig b/drivers/vhost/Kconfig
>         index d3688c6afb87..587fbae06182 100644
>         --- a/drivers/vhost/Kconfig
>         +++ b/drivers/vhost/Kconfig
>         @@ -65,6 +65,7 @@ config VHOST_VDPA
>               tristate "Vhost driver for vDPA-based backend"
>               depends on EVENTFD
>               select VHOST
>         +    select IRQ_BYPASS_MANAGER
>               depends on VDPA
>               help
>                 This kernel module can be loaded in host kernel to accelerate
>         diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
>         index df3cf386b0cd..278ea2f00172 100644
>         --- a/drivers/vhost/vdpa.c
>         +++ b/drivers/vhost/vdpa.c
>         @@ -115,6 +115,55 @@ static irqreturn_t vhost_vdpa_config_cb(void
>         *private)
>               return IRQ_HANDLED;
>           }
>           +static void vhost_vdpa_setup_vq_irq(struct vhost_vdpa *v, u16 qid)
>         +{
>         +    struct vhost_virtqueue *vq = &v->vqs[qid];
>         +    const struct vdpa_config_ops *ops = v->vdpa->config;
>         +    struct vdpa_device *vdpa = v->vdpa;
>         +    int ret, irq;
>         +
>         +    spin_lock(&vq->call_ctx.ctx_lock);
>         +    irq = ops->get_vq_irq(vdpa, qid);
>         +    if (!vq->call_ctx.ctx || irq < 0) {
>         +        spin_unlock(&vq->call_ctx.ctx_lock);
>         +        return;
>         +    }
>         +
>         +    vq->call_ctx.producer.token = vq->call_ctx.ctx;
>         +    vq->call_ctx.producer.irq = irq;
>         +    ret = irq_bypass_register_producer(&vq->call_ctx.producer);
>         +    spin_unlock(&vq->call_ctx.ctx_lock);
>         +}
>         +
>         +static void vhost_vdpa_unsetup_vq_irq(struct vhost_vdpa *v, u16 qid)
>         +{
>         +    struct vhost_virtqueue *vq = &v->vqs[qid];
>         +
>         +    spin_lock(&vq->call_ctx.ctx_lock);
>         +    irq_bypass_unregister_producer(&vq->call_ctx.producer);
> 
> 
> 
>     Any reason for not checking vq->call_ctx.producer.irq as below here?
> 
> we only need ctx as a token to unregister vq from irq bypass manager, if vq->call_ctx.producer.irq is 0, means it is a unused or disabled vq, no harm if we
> perform an unregister on it.
> 
> 
> 
>         +    spin_unlock(&vq->call_ctx.ctx_lock);
>         +}
>         +
>         +static void vhost_vdpa_update_vq_irq(struct vhost_virtqueue *vq)
>         +{
>         +    spin_lock(&vq->call_ctx.ctx_lock);
>         +    /*
>         +     * if it has a non-zero irq, means there is a
>         +     * previsouly registered irq_bypass_producer,
>         +     * we should update it when ctx (its token)
>         +     * changes.
>         +     */
>         +    if (!vq->call_ctx.producer.irq) {
>         +        spin_unlock(&vq->call_ctx.ctx_lock);
>         +        return;
>         +    }
>         +
>         +    irq_bypass_unregister_producer(&vq->call_ctx.producer);
>         +    vq->call_ctx.producer.token = vq->call_ctx.ctx;
>         +    irq_bypass_register_producer(&vq->call_ctx.producer);
>         +    spin_unlock(&vq->call_ctx.ctx_lock);
>         +}
> 
> 
> 
>     I think setup_irq() and update_irq() could be unified with the following
>     logic:
> 
>     irq_bypass_unregister_producer(&vq->call_ctx.producer);
>     irq = ops->get_vq_irq(vdpa, qid);
>         if (!vq->call_ctx.ctx || irq < 0) {
>             spin_unlock(&vq->call_ctx.ctx_lock);
>             return;
>         }
> 
>     vq->call_ctx.producer.token = vq->call_ctx.ctx;
>     vq->call_ctx.producer.irq = irq;
>     ret = irq_bypass_register_producer(&vq->call_ctx.producer);
> 
> Yes, this code piece can do both register and update. Though it's rare to call undate_irq(), however
> setup_irq() is very likely to be called for every vq, so this may cause several rounds of useless irq_bypass_unregister_producer().
> is it worth for simplify the code?
> 
> 
>         +
>           static void vhost_vdpa_reset(struct vhost_vdpa *v)
>           {
>               struct vdpa_device *vdpa = v->vdpa;
>         @@ -155,11 +204,15 @@ static long vhost_vdpa_set_status(struct
>         vhost_vdpa *v, u8 __user *statusp)
>           {
>               struct vdpa_device *vdpa = v->vdpa;
>               const struct vdpa_config_ops *ops = vdpa->config;
>         -    u8 status;
>         +    u8 status, status_old;
>         +    int nvqs = v->nvqs;
>         +    u16 i;
>                 if (copy_from_user(&status, statusp, sizeof(status)))
>                   return -EFAULT;
>           +    status_old = ops->get_status(vdpa);
>         +
>               /*
>                * Userspace shouldn't remove status bits unless reset the
>                * status to 0.
>         @@ -169,6 +222,15 @@ static long vhost_vdpa_set_status(struct
>         vhost_vdpa *v, u8 __user *statusp)
>                 ops->set_status(vdpa, status);
>           +    /* vq irq is not expected to be changed once DRIVER_OK is set */
> 
> 
> 
>     Let's move this comment to the get_vq_irq bus operation.
> 
> OK, can do!
> 
> 


Patch on top pls, these are in my tree now.

> 
>         +    if ((status & VIRTIO_CONFIG_S_DRIVER_OK) && !(status_old &
>         VIRTIO_CONFIG_S_DRIVER_OK))
>         +        for (i = 0; i < nvqs; i++)
>         +            vhost_vdpa_setup_vq_irq(v, i);
>         +
>         +    if ((status_old & VIRTIO_CONFIG_S_DRIVER_OK) && !(status &
>         VIRTIO_CONFIG_S_DRIVER_OK))
>         +        for (i = 0; i < nvqs; i++)
>         +            vhost_vdpa_unsetup_vq_irq(v, i);
>         +
>               return 0;
>           }
>           @@ -332,6 +394,7 @@ static long vhost_vdpa_set_config_call(struct
>         vhost_vdpa *v, u32 __user *argp)
>                 return 0;
>           }
>         +
>           static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int
>         cmd,
>                              void __user *argp)
>           {
>         @@ -390,6 +453,7 @@ static long vhost_vdpa_vring_ioctl(struct
>         vhost_vdpa *v, unsigned int cmd,
>                       cb.private = NULL;
>                   }
>                   ops->set_vq_cb(vdpa, idx, &cb);
>         +        vhost_vdpa_update_vq_irq(vq);
>                   break;
>                 case VHOST_SET_VRING_NUM:
>         @@ -765,6 +829,18 @@ static int vhost_vdpa_open(struct inode *inode,
>         struct file *filep)
>               return r;
>           }
>           +static void vhost_vdpa_clean_irq(struct vhost_vdpa *v)
>         +{
>         +    struct vhost_virtqueue *vq;
>         +    int i;
>         +
>         +    for (i = 0; i < v->nvqs; i++) {
>         +        vq = &v->vqs[i];
>         +        if (vq->call_ctx.producer.irq)
>         +            irq_bypass_unregister_producer(&vq->call_ctx.producer);
>         +    }
>         +}
> 
> 
> 
>     Why not using vhost_vdpa_unsetup_vq_irq()?
> 
> IMHO, in this cleanup phase, the device is almost dead, user space won't change ctx anymore, so I think we don't need to check ctx or irq, can just unregister it.
> 
> Thanks!
> 
> 
>     Thanks
> 
> 
> 
>         +
>           static int vhost_vdpa_release(struct inode *inode, struct file
>         *filep)
>           {
>               struct vhost_vdpa *v = filep->private_data;
>         @@ -777,6 +853,7 @@ static int vhost_vdpa_release(struct inode *inode,
>         struct file *filep)
>               vhost_vdpa_iotlb_free(v);
>               vhost_vdpa_free_domain(v);
>               vhost_vdpa_config_put(v);
>         +    vhost_vdpa_clean_irq(v);
>               vhost_dev_cleanup(&v->vdev);
>               kfree(v->vdev.vqs);
>               mutex_unlock(&d->mutex);
> 
> 
> 

