Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0C90401B04
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 14:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242195AbhIFMOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 08:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242087AbhIFMOW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 08:14:22 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B46DC0613C1
        for <netdev@vger.kernel.org>; Mon,  6 Sep 2021 05:13:17 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id ia27so13099072ejc.10
        for <netdev@vger.kernel.org>; Mon, 06 Sep 2021 05:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4XK2He6XAxXZ4uQ+tUP1SQxv8SHznWmh71eOTMIjERI=;
        b=xGTcxD7ejbDHeEbg0ZXBUIYzR9oCdXX+beBjuuudikBwUEZeUB9hzQ91YZIEEaRx3T
         oHnlwQCeXwxqq88qh4cfw6ObirXnGIf/StLNaDv+0Z5BnidsFDCipS2EWhRyQ/zW3H2N
         /5rphWoxHQeOpOANwtZtvD8kjZIYS0269VOYUuM9i7hPT/0C+UP0Td8JHmOG0qp7IUDY
         BEjv4LUxVEN3rF9mfccMtptx5kBaiP2w/AWi/WJP7tZ+gWqBwihfay4B9VChiUVhXCkG
         VuTZE7l7g7a53QbanyNAMpB+KgpG4SLgf2VtIUo88uf6zyBz3cnbKrUxeaOHOe74nVS/
         U/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4XK2He6XAxXZ4uQ+tUP1SQxv8SHznWmh71eOTMIjERI=;
        b=TPJMBvjITNfk3qF+5cx0Caw5hKyF9leSvl8/nWvQQiDN6bh/EKPlThWUFTtc3gaKW4
         qIWwFvI1Ovg6uvIk3ea42BqGKF5kVxzPw2/JLtzOll6QoH91GPDhm0FsPCzvPjsRmfpn
         1gDZm8qnV08Z1x8PV3Nt5pYyZOad4rJJDskxQc592Tt40ApkZX2XJkZnYirEsUjyB2VE
         iBLJKobe3xoPz3L4eHX0OCFmT2QryNODa/BJlHH4T+PGBlF85HuowGnHn2t6rbDjdm9k
         z3hQ7I3BklBKB4v3lnAk/ohJGHjdaDrcF44L7BHOalRinbYUhHBREAUL+vBUqJhqVz0G
         sYvA==
X-Gm-Message-State: AOAM532i+2zRVxj2ZA47vyjJkjq3APtMSGt/wZvf9GtGIZ/0ViodiDvD
        qmaCib1Be1uFvAl31TZi92Tba6YZcuXeQJCCOmdC
X-Google-Smtp-Source: ABdhPJzK+qfWM9eD5RSyJJP164cm7bgw35oldCbjaoz6t6fKIkLAriVsnsDFTWGNuSYWqGHiMcBtup9p0O13Crs4IQ4=
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr13305837ejc.72.1630930396029;
 Mon, 06 Sep 2021 05:13:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210831103634.33-1-xieyongji@bytedance.com> <20210831103634.33-6-xieyongji@bytedance.com>
 <20210906015524-mutt-send-email-mst@kernel.org> <CACycT3v4ZVnh7DGe_RtAOx4Vvau0km=HWyCM=KzKhD+ahYKafQ@mail.gmail.com>
 <20210906023131-mutt-send-email-mst@kernel.org> <CACycT3ssC1bhNzY9Pk=LPvKjMrFFavTfCKTJtR2XEiVYqDxT1Q@mail.gmail.com>
 <20210906035338-mutt-send-email-mst@kernel.org> <CACycT3vQHRsJ_j5f4T9RoB4MQzBoYO5ts3egVe9K6TcCVfLOFQ@mail.gmail.com>
 <20210906053210-mutt-send-email-mst@kernel.org>
In-Reply-To: <20210906053210-mutt-send-email-mst@kernel.org>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 6 Sep 2021 20:13:04 +0800
Message-ID: <CACycT3uChWmr50FGutFz0hK+2jSjx0KJsJ5w-NVBq-E_nmJm9w@mail.gmail.com>
Subject: Re: [PATCH v13 05/13] vdpa: Add reset callback in vdpa_config_ops
To:     "Michael S. Tsirkin" <mst@redhat.com>
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
        =?UTF-8?Q?Mika_Penttil=C3=A4?= <mika.penttila@nextfour.com>,
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 6, 2021 at 6:43 PM Michael S. Tsirkin <mst@redhat.com> wrote:
>
> On Mon, Sep 06, 2021 at 04:45:55PM +0800, Yongji Xie wrote:
> > On Mon, Sep 6, 2021 at 4:01 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > >
> > > On Mon, Sep 06, 2021 at 03:06:44PM +0800, Yongji Xie wrote:
> > > > On Mon, Sep 6, 2021 at 2:37 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > >
> > > > > On Mon, Sep 06, 2021 at 02:09:25PM +0800, Yongji Xie wrote:
> > > > > > On Mon, Sep 6, 2021 at 1:56 PM Michael S. Tsirkin <mst@redhat.com> wrote:
> > > > > > >
> > > > > > > On Tue, Aug 31, 2021 at 06:36:26PM +0800, Xie Yongji wrote:
> > > > > > > > This adds a new callback to support device specific reset
> > > > > > > > behavior. The vdpa bus driver will call the reset function
> > > > > > > > instead of setting status to zero during resetting.
> > > > > > > >
> > > > > > > > Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
> > > > > > >
> > > > > > >
> > > > > > > This does gloss over a significant change though:
> > > > > > >
> > > > > > >
> > > > > > > > ---
> > > > > > > > @@ -348,12 +352,12 @@ static inline struct device *vdpa_get_dma_dev(struct vdpa_device *vdev)
> > > > > > > >       return vdev->dma_dev;
> > > > > > > >  }
> > > > > > > >
> > > > > > > > -static inline void vdpa_reset(struct vdpa_device *vdev)
> > > > > > > > +static inline int vdpa_reset(struct vdpa_device *vdev)
> > > > > > > >  {
> > > > > > > >       const struct vdpa_config_ops *ops = vdev->config;
> > > > > > > >
> > > > > > > >       vdev->features_valid = false;
> > > > > > > > -     ops->set_status(vdev, 0);
> > > > > > > > +     return ops->reset(vdev);
> > > > > > > >  }
> > > > > > > >
> > > > > > > >  static inline int vdpa_set_features(struct vdpa_device *vdev, u64 features)
> > > > > > >
> > > > > > >
> > > > > > > Unfortunately this breaks virtio_vdpa:
> > > > > > >
> > > > > > >
> > > > > > > static void virtio_vdpa_reset(struct virtio_device *vdev)
> > > > > > > {
> > > > > > >         struct vdpa_device *vdpa = vd_get_vdpa(vdev);
> > > > > > >
> > > > > > >         vdpa_reset(vdpa);
> > > > > > > }
> > > > > > >
> > > > > > >
> > > > > > > and there's no easy way to fix this, kernel can't recover
> > > > > > > from a reset failure e.g. during driver unbind.
> > > > > > >
> > > > > >
> > > > > > Yes, but it should be safe with the protection of software IOTLB even
> > > > > > if the reset() fails during driver unbind.
> > > > > >
> > > > > > Thanks,
> > > > > > Yongji
> > > > >
> > > > > Hmm. I don't see it.
> > > > > What exactly will happen? What prevents device from poking at
> > > > > memory after reset? Note that dma unmap in e.g. del_vqs happens
> > > > > too late.
> > > >
> > > > But I didn't see any problems with touching the memory for virtqueues.
> > >
> > > Drivers make the assumption that after reset returns no new
> > > buffers will be consumed. For example a bunch of drivers
> > > call virtqueue_detach_unused_buf.
> >
> > I'm not sure if I get your point. But it looks like
> > virtqueue_detach_unused_buf() will check the driver's metadata first
> > rather than read the memory from virtqueue.
> >
> > > I can't say whether block makes this assumption anywhere.
> > > Needs careful auditing.
> > >
> > > > The memory should not be freed after dma unmap?
> > >
> > > But unmap does not happen until after the reset.
> > >
> >
> > I mean the memory is totally allocated and controlled by the VDUSE
> > driver. The VDUSE driver will not return them to the buddy system
> > unless userspace unmap it.
>
> Right. But what stops VDUSE from poking at memory after
> reset failed?
>

Only itself. But in normal cases, userspace would not poke at the
memory since there is no available data after reset.

And it makes me think whether it's better to disallow returning errors
from userspace for the reset message. Then the only case that leads to
reset failure is the request timeout, which will mark the device
broken now.

>
> > >
> > > > And the memory for the bounce buffer should also be safe to be
> > > > accessed by userspace in this case.
> > > >
> > > > > And what about e.g. interrupts?
> > > > > E.g. we have this:
> > > > >
> > > > >         /* Virtqueues are stopped, nothing can use vblk->vdev anymore. */
> > > > >         vblk->vdev = NULL;
> > > > >
> > > > > and this is no longer true at this point.
> > > > >
> > > >
> > > > You're right. But I didn't see where the interrupt handler will use
> > > > the vblk->vdev.
> > >
> > > static void virtblk_done(struct virtqueue *vq)
> > > {
> > >         struct virtio_blk *vblk = vq->vdev->priv;
> > >
> > > vq->vdev is the same as vblk->vdev.
> > >
> >
> > We will test the vq->ready (will be set to false in del_vqs()) before
> > injecting an interrupt in the VDUSE driver. So it should be OK?
>
> Maybe not ...  It's not designed for such asynchronous access, so e.g.
> there's no locking or memory ordering around accesses.
>

Yes, so we still need the below fix.

>
> > >
> > > > So it seems to be not too late to fix it:
> > > >
> > > > diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > index 5c25ff6483ad..ea41a7389a26 100644
> > > > --- a/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > +++ b/drivers/vdpa/vdpa_user/vduse_dev.c
> > > > @@ -665,13 +665,13 @@ static void vduse_vdpa_set_config(struct
> > > > vdpa_device *vdpa, unsigned int offset,
> > > >  static int vduse_vdpa_reset(struct vdpa_device *vdpa)
> > > >  {
> > > >         struct vduse_dev *dev = vdpa_to_vduse(vdpa);
> > > > +       int ret;
> > > >
> > > > -       if (vduse_dev_set_status(dev, 0))
> > > > -               return -EIO;
> > > > +       ret = vduse_dev_set_status(dev, 0);
> > > >
> > > >         vduse_dev_reset(dev);
> > > >
> > > > -       return 0;
> > > > +       return ret;
> > > >  }
> > > >
> > > >  static u32 vduse_vdpa_get_generation(struct vdpa_device *vdpa)
> > > >
> > > > Thanks,
> > > > Yongji
> > >
> > > Needs some comments to explain why it's done like this.
> > >
> >
> > This is used to make sure the userspace can't not inject the interrupt
> > any more after reset. The vduse_dev_reset() will clear the interrupt
> > callback and flush the irq kworker.
> >
> > > BTW device is generally wedged at this point right?
> > > E.g. if reset during initialization fails, userspace
> > > will still get the reset at some later point and be
> > > confused ...
> > >
> >
> > Sorry, I don't get why userspace will get the reset at some later point?
> >
> > Thanks,
> > Yongji
>
> I am generally a bit confused about how does reset work with vduse.
> We clearly want device to get back to its original state.
> How is that supposed to be achieved?
>

I think both the userspace daemon and kernel should reset their
internal states. Besides, userspace daemon needs to stop processing
virtqueue and clear the memory mapping.

Thanks,
Yongji
