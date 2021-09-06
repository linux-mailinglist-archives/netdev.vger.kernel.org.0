Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2B89401A15
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 12:44:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbhIFKoh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 06:44:37 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43314 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230131AbhIFKod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 06:44:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630925006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ul4qFH3gT696MqPqcmDxIOKc6JmUkzaJFABQhow9EWg=;
        b=jS/4G4hsSU7TeVPlCE0Ti6JQdICkGYroM73RM/9qW4a7z76rpZ0wkyDL8KuKuQ3qair+4f
        IlfyXpqlRCz0RxQQZtQGlxk1uVTIR5oun8JNUSsIF59ovWac6PsA9sdrFYvLaBtmVtvxDY
        68nyTjuDh/EPGZY7cWwzhcO6nvqSTZ4=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-77-W7nUpgQ7MmiqWOervF3Nvw-1; Mon, 06 Sep 2021 06:43:25 -0400
X-MC-Unique: W7nUpgQ7MmiqWOervF3Nvw-1
Received: by mail-wm1-f72.google.com with SMTP id v2-20020a7bcb420000b02902e6b108fcf1so3738508wmj.8
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 03:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ul4qFH3gT696MqPqcmDxIOKc6JmUkzaJFABQhow9EWg=;
        b=WrtM11cjnTB91HCTZy12x3EfO9ghB7rJE7XvpRPuUkOzyANDZjnPQZ4qpQs54/zqWS
         cu7pVGqTnejCb2qpXv0rpS4JriddhGZRBhwUgqB/qmE89BjEb424+uDOacMhtaMSSjOF
         VyfPWCZ8KdAg6pqvPLz5V8Ft9LDEVp9bDQ1ZsWRBXKmVTD0jNRXuy3+MeZXzUoGVyRRa
         ogGeD5oHUnJZcXyOQ9EXItd1fwZsb+NoKI4cou12IrnLtD4J94L1IeYt7IkGwcvXIjnw
         hYY7xAVjqbJO4UdGTHRXPVKnh2yE9HKV8mQor2LNsVT2zoN3Cg8JobbpQCD0l171CT7+
         cJPw==
X-Gm-Message-State: AOAM531qdS25AwGv135vm3B8mO8sozKsRxXdFUHEWvUIOHaf0/YxdFno
        2aD3NRK/EqNhJmY2rjF0jS4UOEiWtPs82kKbXJ/l28PpOYZl919uU9WBF7LZIwTLrhLTtkKskrh
        bYbbg3ZR+2EIPRiuW
X-Received: by 2002:a05:600c:3543:: with SMTP id i3mr10798054wmq.2.1630925004177;
        Mon, 06 Sep 2021 03:43:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzq0y7NDDKEVc4QMn/xSXfsLrateDW5EX086OFKHb0Me/zK5A7xaZmIg1gdA2WViHz/LIzfeQ==
X-Received: by 2002:a05:600c:3543:: with SMTP id i3mr10798024wmq.2.1630925003942;
        Mon, 06 Sep 2021 03:43:23 -0700 (PDT)
Received: from redhat.com ([2.55.131.183])
        by smtp.gmail.com with ESMTPSA id g5sm7424960wrq.80.2021.09.06.03.43.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Sep 2021 03:43:22 -0700 (PDT)
Date:   Mon, 6 Sep 2021 06:43:15 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        Christoph Hellwig <hch@infradead.org>,
        Christian Brauner <christian.brauner@canonical.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, joro@8bytes.org,
        Greg KH <gregkh@linuxfoundation.org>,
        He Zhe <zhe.he@windriver.com>,
        Liu Xiaodong <xiaodong.liu@intel.com>,
        Joe Perches <joe@perches.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>,
        John Garry <john.garry@huawei.com>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
Message-ID: <20210906053210-mutt-send-email-mst@kernel.org>
References: <20210831103634.33-1-xieyongji@bytedance.com>
 <20210831103634.33-6-xieyongji@bytedance.com>
 <20210906015524-mutt-send-email-mst@kernel.org>
 <CACycT3v4ZVnh7DGe_RtAOx4Vvau0km=HWyCM=KzKhD+ahYKafQ@mail.gmail.com>
 <20210906023131-mutt-send-email-mst@kernel.org>
 <CACycT3ssC1bhNzY9Pk=LPvKjMrFFavTfCKTJtR2XEiVYqDxT1Q@mail.gmail.com>
 <20210906035338-mutt-send-email-mst@kernel.org>
 <CACycT3vQHRsJ_j5f4T9RoB4MQzBoYO5ts3egVe9K6TcCVfLOFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACycT3vQHRsJ_j5f4T9RoB4MQzBoYO5ts3egVe9K6TcCVfLOFQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 06, 2021 at 04:45:55PM +0800, Yongji Xie wrote:
> On Mon, Sep 6, 2021 at 4:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> >
> > On Mon, Sep 06, 2021 at 03:06:44PM +0800, Yongji Xie wrote:
> > > On Mon, Sep 6, 2021 at 2:37 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > >
> > > > On Mon, Sep 06, 2021 at 02:09:25PM +0800, Yongji Xie wrote:
> > > > > On Mon, Sep 6, 2021 at 1:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > >
> > > > > > On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> > > > > > > This adds a new callback to support device specific reset
> > > > > > > behavior. The vdpa bus driver will call the reset function
> > > > > > > instead of setting status to zero during resetting.
> > > > > > >
> > > > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > >
> > > > > >
> > > > > > This does gloss over a significant change though:
> > > > > >
> > > > > >
> > > > > > > ---
> > > > > > > @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
> > > > > > >       return vdev->dma_dev;
> > > > > > >  }
> > > > > > >
> > > > > > > -static inline void vdpa_reset(struct vdpa_device *vdev)
> > > > > > > +static inline int vdpa_reset(struct vdpa_device *vdev)
> > > > > > >  {
> > > > > > >       const struct vdpa_config_ops *ops = vdev->config;
> > > > > > >
> > > > > > >       vdev->features_valid = false;
> > > > > > > -     ops->set_status(vdev, 0);
> > > > > > > +     return ops->reset(vdev);
> > > > > > >  }
> > > > > > >
> > > > > > >  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > > > > >
> > > > > >
> > > > > > Unfortunately this breaks virtio_vdpa:
> > > > > >
> > > > > >
> > > > > > static void virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > {
> > > > > >         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> > > > > >
> > > > > >         vdpa_reset(vdpa);
> > > > > > }
> > > > > >
> > > > > >
> > > > > > and there's no easy way to fix this, kernel can't recover
> > > > > > from a reset failure e.g. during driver unbind.
> > > > > >
> > > > >
> > > > > Yes, but it should be safe with the protection of software IOTLB even
> > > > > if the reset() fails during driver unbind.
> > > > >
> > > > > Thanks,
> > > > > Yongji
> > > >
> > > > Hmm. I don't see it.
> > > > What exactly will happen? What prevents device from poking at
> > > > memory after reset? Note that dma unmap in e.g. del_vqs happens
> > > > too late.
> > >
> > > But I didn't see any problems with touching the memory for virtqueues.
> >
> > Drivers make the assumption that after reset returns no new
> > buffers will be consumed. For example a bunch of drivers
> > call virtqueue_detach_unused_buf.
> 
> I'm not sure if I get your point. But it looks like
> virtqueue_detach_unused_buf() will check the driver's metadata first
> rather than read the memory from virtqueue.
> 
> > I can't say whether block makes this assumption anywhere.
> > Needs careful auditing.
> >
> > > The memory should not be freed after dma unmap?
> >
> > But unmap does not happen until after the reset.
> >
> 
> I mean the memory is totally allocated and controlled by the VDUSE
> driver. The VDUSE driver will not return them to the buddy system
> unless userspace unmap it.

Right. But what stops VDUSE from poking at memory after
reset failed?



> >
> > > And the memory for the bounce buffer should also be safe to be
> > > accessed by userspace in this case.
> > >
> > > > And what about e.g. interrupts?
> > > > E.g. we have this:
> > > >
> > > >         /* Virtqueues are stopped, nothing can use vblk->vdev anymore. */
> > > >         vblk->vdev = NULL;
> > > >
> > > > and this is no longer true at this point.
> > > >
> > >
> > > You're right. But I didn't see where the interrupt handler will use
> > > the vblk->vdev.
> >
> > static void virtblk_done(struct virtqueue *vq)
> > {
> >         struct virtio_blk *vblk = vq->vdev->priv;
> >
> > vq->vdev is the same as vblk->vdev.
> >
> 
> We will test the vq->ready (will be set to false in del_vqs()) before
> injecting an interrupt in the VDUSE driver. So it should be OK?

Maybe not ...  It's not designed for such asynchronous access, so e.g.
there's no locking or memory ordering around accesses.


> >
> > > So it seems to be not too late to fix it:
> > >
> > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > index 5c25ff6483ad..ea41a7389a26 100644
> > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > @@ -665,13 +665,13 @@ static void vduse_vdpa_set_config(struct
> > > vdpa_device *vdpa, unsigned int offset,
> > >  static int vduse_vdpa_reset(struct vdpa_device *vdpa)
> > >  {
> > >         struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> > > +       int ret;
> > >
> > > -       if (vduse_dev_set_status(dev, 0))
> > > -               return -EIO;
> > > +       ret = vduse_dev_set_status(dev, 0);
> > >
> > >         vduse_dev_reset(dev);
> > >
> > > -       return 0;
> > > +       return ret;
> > >  }
> > >
> > >  static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
> > >
> > > Thanks,
> > > Yongji
> >
> > Needs some comments to explain why it's done like this.
> >
> 
> This is used to make sure the userspace can't not inject the interrupt
> any more after reset. The vduse_dev_reset() will clear the interrupt
> callback and flush the irq kworker.
> 
> > BTW device is generally wedged at this point right?
> > E.g. if reset during initialization fails, userspace
> > will still get the reset at some later point and be
> > confused ...
> >
> 
> Sorry, I don't get why userspace will get the reset at some later point?
> 
> Thanks,
> Yongji

I am generally a bit confused about how does reset work with vduse.
We clearly want device to get back to its original state.
How is that supposed to be achieved?

-- 
MST

