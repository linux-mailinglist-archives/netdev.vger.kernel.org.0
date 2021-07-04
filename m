Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F203B3BAC90
	for <lists+netdev@lfdr.de>; Sun,  4 Jul 2021 11:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbhGDJwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Jul 2021 05:52:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbhGDJwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Jul 2021 05:52:03 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC78BC061764
        for <netdev@vger.kernel.org>; Sun,  4 Jul 2021 02:49:27 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i20so23902315ejw.4
        for <netdev@vger.kernel.org>; Sun, 04 Jul 2021 02:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qzAkMSP1FVlaF7igte07rNyxkup5fEZ5Kcb9vm7Jix8=;
        b=SMZguhe0gCeK+K4fpWOBc4ZZOnMdsFi7GKjeWwau3BD+++plq8ypU2RwuzRKIlFwVo
         EGstmcx5t98kTfUG9bhwv7ljPdHJ1Ls/qe95Asrjrtk1uCd4NQCBIIh0EKmHqhRoEYol
         hldjt8N2LAzTyoYWQYZ2JlXUJXARXI1msbzhZKzCTFr69fWdoeJSsY/Sjn4i8pXkFpIo
         YjRAzIAXBf6AhnVeSqz4sTXfeQB3jlvLSRpBgcbieZielxBSuw+ikxw+y8aApqvhW7Pn
         QNM7ylmDgZqeNb+fgsjdZgKC1v3EleI+8SmZhbsCtEMJIhKligBSReCYfqRjdsfmjyH1
         YajQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qzAkMSP1FVlaF7igte07rNyxkup5fEZ5Kcb9vm7Jix8=;
        b=coimDNtOLiCdrwzTv4aXKnqtpaleUqrToRDI3iF9DoBF6owBY/HgjITfs4N8r+sWyj
         cstyCF52I4I1X9/jhEi4QEzO4HwxcZmWMuTCNtqzVj0v8L2Yd9CrUi0wU+fCXN36yxFx
         WyKzeGWKirXdyZrzPoLfkF/yVnVvU8cDS0vT0YuDfk2DP2nkYj0TIrUB2DJtbOEecQQU
         Fw0AX+rUhvFA11g8e02LpKlWecTWyNMQ1OwVie+fidLOGveYXipCaR6ylN86aYy+uyQc
         4BmKRPy0gBDco1OAFOzfjILVq99wjIvvtIXynQPMiE9Opi1996QGXK82Avr2xgMBSAVs
         MZTA==
X-Gm-Message-State: AOAM532XSqiFJxE7VQ9qZVDkzI7YmQ80vf4kYZdyAd58IfYUzDUZXj8o
        WMj81TsycOhv8zCHgE5OCeViFnzwc9HknkHcO+8Q
X-Google-Smtp-Source: ABdhPJxvRtQJIj/yqZPkvbZHD8DNlSHEoDvhzkPyPsAyedq1EVF9bW4cXHVy5LeU0C2sRpYjWJqArcNlZLkm0IT3QiI=
X-Received: by 2002:a17:907:1690:: with SMTP id hc16mr8249257ejc.247.1625392166205;
 Sun, 04 Jul 2021 02:49:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210615141331.407-1-xieyongji@bytedance.com> <20210615141331.407-11-xieyongji@bytedance.com>
 <YNSCH6l31zwPxBjL@stefanha-x1.localdomain> <CACycT3uxnQmXWsgmNVxQtiRhz1UXXTAJFY3OiAJqokbJH6ifMA@mail.gmail.com>
 <YNxCDpM3bO5cPjqi@stefanha-x1.localdomain> <CACycT3taKhf1cWp3Jd0aSVekAZvpbR-_fkyPLQ=B+jZBB5H=8Q@mail.gmail.com>
 <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
In-Reply-To: <YN3ABqCMLQf7ejOm@stefanha-x1.localdomain>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Sun, 4 Jul 2021 17:49:15 +0800
Message-ID: <CACycT3vo-diHgTSLw_FS2E+5ia5VjihE3qw7JmZR7JT55P-wQA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH v8 10/10] Documentation: Add documentation for VDUSE
To:     Stefan Hajnoczi <stefanha@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        Greg KH <gregkh@linuxfoundation.org>, songmuchun@bytedance.com,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 1, 2021 at 9:15 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
>
> On Thu, Jul 01, 2021 at 06:00:48PM +0800, Yongji Xie wrote:
> > On Wed, Jun 30, 2021 at 6:06 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > >
> > > On Tue, Jun 29, 2021 at 01:43:11PM +0800, Yongji Xie wrote:
> > > > On Mon, Jun 28, 2021 at 9:02 PM Stefan Hajnoczi <stefanha@redhat.com> wrote:
> > > > > On Tue, Jun 15, 2021 at 10:13:31PM +0800, Xie Yongji wrote:
> > > > > > +     static void *iova_to_va(int dev_fd, uint64_t iova, uint64_t *len)
> > > > > > +     {
> > > > > > +             int fd;
> > > > > > +             void *addr;
> > > > > > +             size_t size;
> > > > > > +             struct vduse_iotlb_entry entry;
> > > > > > +
> > > > > > +             entry.start = iova;
> > > > > > +             entry.last = iova + 1;
> > > > >
> > > > > Why +1?
> > > > >
> > > > > I expected the request to include *len so that VDUSE can create a bounce
> > > > > buffer for the full iova range, if necessary.
> > > > >
> > > >
> > > > The function is used to translate iova to va. And the *len is not
> > > > specified by the caller. Instead, it's used to tell the caller the
> > > > length of the contiguous iova region from the specified iova. And the
> > > > ioctl VDUSE_IOTLB_GET_FD will get the file descriptor to the first
> > > > overlapped iova region. So using iova + 1 should be enough here.
> > >
> > > Does the entry.last field have any purpose with VDUSE_IOTLB_GET_FD? I
> > > wonder why userspace needs to assign a value at all if it's always +1.
> > >
> >
> > If we need to get some iova regions in the specified range, we need
> > the entry.last field. For example, we can use [0, ULONG_MAX] to get
> > the first overlapped iova region which might be [4096, 8192]. But in
> > this function, we don't use VDUSE_IOTLB_GET_FD like this. We need to
> > get the iova region including the specified iova.
>
> I see, thanks for explaining!
>
> > > > > > +             return addr + iova - entry.start;
> > > > > > +     }
> > > > > > +
> > > > > > +- VDUSE_DEV_GET_FEATURES: Get the negotiated features
> > > > >
> > > > > Are these VIRTIO feature bits? Please explain how feature negotiation
> > > > > works. There must be a way for userspace to report the device's
> > > > > supported feature bits to the kernel.
> > > > >
> > > >
> > > > Yes, these are VIRTIO feature bits. Userspace will specify the
> > > > device's supported feature bits when creating a new VDUSE device with
> > > > ioctl(VDUSE_CREATE_DEV).
> > >
> > > Can the VDUSE device influence feature bit negotiation? For example, if
> > > the VDUSE virtio-blk device does not implement discard/write-zeroes, how
> > > does QEMU or the guest find out about this?
> > >
> >
> > There is a "features" field in struct vduse_dev_config which is used
> > to do feature negotiation.
>
> This approach is more restrictive than required by the VIRTIO
> specification:
>
>   "The device SHOULD accept any valid subset of features the driver
>   accepts, otherwise it MUST fail to set the FEATURES_OK device status
>   bit when the driver writes it."
>
>   https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-130002
>
> The spec allows a device to reject certain subsets of features. For
> example, if feature B depends on feature A and can only be enabled when
> feature A is also enabled.
>
> From your description I think VDUSE would accept feature B without
> feature A since the device implementation has no opportunity to fail
> negotiation with custom logic.
>

Yes, we discussed it [1] before. So I'd like to re-introduce
SET_STATUS messages so that the userspace can fail feature negotiation
during setting FEATURES_OK status bit.

[1]  https://lkml.org/lkml/2021/6/28/1587

> Ideally VDUSE would send a SET_FEATURES message to userspace, allowing
> the device implementation full flexibility in which subsets of features
> to accept.
>
> This is a corner case. Many or maybe even all existing VIRTIO devices
> don't need this flexibility, but I want to point out this limitation in
> the VDUSE interface because it may cause issues in the future.
>
> > > > > > +- VDUSE_DEV_UPDATE_CONFIG: Update the configuration space and inject a config interrupt
> > > > >
> > > > > Does this mean the contents of the configuration space are cached by
> > > > > VDUSE?
> > > >
> > > > Yes, but the kernel will also store the same contents.
> > > >
> > > > > The downside is that the userspace code cannot generate the
> > > > > contents on demand. Most devices doin't need to generate the contents
> > > > > on demand, so I think this is okay but I had expected a different
> > > > > interface:
> > > > >
> > > > > kernel->userspace VDUSE_DEV_GET_CONFIG
> > > > > userspace->kernel VDUSE_DEV_INJECT_CONFIG_IRQ
> > > > >
> > > >
> > > > The problem is how to handle the failure of VDUSE_DEV_GET_CONFIG. We
> > > > will need lots of modification of virtio codes to support that. So to
> > > > make it simple, we choose this way:
> > > >
> > > > userspace -> kernel VDUSE_DEV_SET_CONFIG
> > > > userspace -> kernel VDUSE_DEV_INJECT_CONFIG_IRQ
> > > >
> > > > > I think you can leave it the way it is, but I wanted to mention this in
> > > > > case someone thinks it's important to support generating the contents of
> > > > > the configuration space on demand.
> > > > >
> > > >
> > > > Sorry, I didn't get you here. Can't VDUSE_DEV_SET_CONFIG and
> > > > VDUSE_DEV_INJECT_CONFIG_IRQ achieve that?
> > >
> > > If the contents of the configuration space change continuously, then the
> > > VDUSE_DEV_SET_CONFIG approach is inefficient and might have race
> > > conditions. For example, imagine a device where the driver can read a
> > > timer from the configuration space. I think the VIRTIO device model
> > > allows that although I'm not aware of any devices that do something like
> > > it today. The problem is that VDUSE_DEV_SET_CONFIG would have to be
> > > called frequently to keep the timer value updated even though the guest
> > > driver probably isn't accessing it.
> > >
> >
> > OK, I get you now. Since the VIRTIO specification says "Device
> > configuration space is generally used for rarely-changing or
> > initialization-time parameters". I assume the VDUSE_DEV_SET_CONFIG
> > ioctl should not be called frequently.
>
> The spec uses MUST and other terms to define the precise requirements.
> Here the language (especially the word "generally") is weaker and means
> there may be exceptions.
>
> Another type of access that doesn't work with the VDUSE_DEV_SET_CONFIG
> approach is reads that have side-effects. For example, imagine a field
> containing an error code if the device encounters a problem unrelated to
> a specific virtqueue request. Reading from this field resets the error
> code to 0, saving the driver an extra configuration space write access
> and possibly race conditions. It isn't possible to implement those
> semantics suing VDUSE_DEV_SET_CONFIG. It's another corner case, but it
> makes me think that the interface does not allow full VIRTIO semantics.
>

Agreed. I will use VDUSE_DEV_GET_CONFIG in the next version. And to
handle the message failure, I'm going to add a return value to
virtio_config_ops.get() and virtio_cread_* API so that the error can
be propagated to the virtio device driver. Then the virtio-blk device
driver can be modified to handle that.

Jason and Stefan, what do you think of this way?

> > > What's worse is that there might be race conditions where other
> > > driver->device operations are supposed to update the configuration space
> > > but VDUSE_DEV_SET_CONFIG means that the VDUSE kernel code is caching an
> > > outdated copy.
> > >
> >
> > I'm not sure. Should the device and driver be able to access the same
> > fields concurrently?
>
> Yes. The VIRTIO spec has a generation count to handle multi-field
> accesses so that consistency can be ensured:
> https://docs.oasis-open.org/virtio/virtio/v1.1/cs01/virtio-v1.1-cs01.html#x1-180004
>

I see.

Thanks,
Yongji
