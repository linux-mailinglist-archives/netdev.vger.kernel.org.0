Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB89532E249
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 07:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCEGhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 01:37:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbhCEGhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 01:37:05 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF8FC061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 22:37:04 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id w9so1022120edt.13
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 22:37:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ye59LOuGJNa6hn8POa8Q5ZSuRRH1Gakg9Xz+Jk2Jink=;
        b=vu5x9yYj2w7fljnGMRc6sBWOUbFHyR11j69ZlJAT7KX2UQczG6/XSMQaQI1RX2tFPv
         2kkU3lHS+iIDkfOCg4mQyMdvK7y6fMgg2xx0/SkmzfQUN6tSpIQ1xXSgyWQ/ND+xwiD4
         MVXuAU9FlzuArjViWE/Hv4l9ChOYOX7qVlD2Hc0SE9jhRGCPALFaDdB1YYRooTHECR0x
         Pfg9lskpz9RqMJooT6/AurbUMhQX23872AJPDRDmvHE1Z53wEw9H9+eJNCXfM6dJ6Bz4
         yt6hFmIrDfgXZYB8bf7qzXBmDXZLdu9AHXjgEs9xOTmWkhJH9HMIva/mOMFj0BOhvzo4
         VXkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ye59LOuGJNa6hn8POa8Q5ZSuRRH1Gakg9Xz+Jk2Jink=;
        b=SjqSoN739xM8Cc8eFAD5mxHxKZL8Fn4y2sVJ7eTy6lRBqDLNphllMU3483f8zy1uTY
         9d2IXdxwTtZDRc5Y8O/mk9cph2PvksiitUV8RbwKJ2f7d6KPYaFz4z3u/tv/rFFPdTjt
         4DHKbCAk+CCUlnhdwoPcxN70Ex9f+sYDRMKQQq0JvE4oCyzaFGo1xT7hocbtdmBiy620
         rtln8/oDOj+zw8AP2qSQtXzvJI7RQaqKloI4UkvRedJM+Gdv0a4DoqXW//FSNTR4L6d6
         y2JFvaI9hOt4p5zfwCNoXzvXJWfZAqcZ9pCwYrscY9YvFQPpySYjRK/MpU3/aiY8fTUk
         xKcA==
X-Gm-Message-State: AOAM532hXke2rP6YLLbszitceMDCC1qREQa61MLZWNCYg+ko6Ira1Nkk
        0Lqwj6BrZ9+3D64yTMQ4INOUT0RwdESOtDp2s0r2
X-Google-Smtp-Source: ABdhPJyzGm5l6y0XncFMOdG/BrxDoWZXw1mC+/B9mBP/5bP1IX8avxfXqpHQX94dMqW8zB6Sk/QjqAEUmZOZe1o8d2g=
X-Received: by 2002:a05:6402:3122:: with SMTP id dd2mr7725434edb.253.1614926223212;
 Thu, 04 Mar 2021 22:37:03 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com> <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com>
In-Reply-To: <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 14:36:51 +0800
Message-ID: <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
Subject: Re: Re: [RFC v4 10/11] vduse: Introduce a workqueue for irq injection
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 11:30 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>>>> This patch introduces a workqueue to support injecting
> >>>>> virtqueue's interrupt asynchronously. This is mainly
> >>>>> for performance considerations which makes sure the push()
> >>>>> and pop() for used vring can be asynchronous.
> >>>> Do you have pref numbers for this patch?
> >>>>
> >>> No, I can do some tests for it if needed.
> >>>
> >>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useles=
s
> >>> if we call irq callback in ioctl context. Something like:
> >>>
> >>> virtqueue_push();
> >>> virtio_notify();
> >>>       ioctl()
> >>> -------------------------------------------------
> >>>           irq_cb()
> >>>               virtqueue_get_buf()
> >>>
> >>> The used vring is always empty each time we call virtqueue_push() in
> >>> userspace. Not sure if it is what we expected.
> >>
> >> I'm not sure I get the issue.
> >>
> >> THe used ring should be filled by virtqueue_push() which is done by
> >> userspace before?
> >>
> > After userspace call virtqueue_push(), it always call virtio_notify()
> > immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
> > will inject an irq to VM and return, then vcpu thread will call
> > interrupt handler. But in container (virtio-vdpa) cases,
> > virtio_notify() will call interrupt handler directly. So it looks like
> > we have to optimize the virtio-vdpa cases. But one problem is we don't
> > know whether we are in the VM user case or container user case.
>
>
> Yes, but I still don't get why used ring is empty after the ioctl()?
> Used ring does not use bounce page so it should be visible to the kernel
> driver. What did I miss :) ?
>

Sorry, I'm not saying the kernel can't see the correct used vring. I
mean the kernel will consume the used vring in the ioctl context
directly in the virtio-vdpa case. In userspace's view, that means
virtqueue_push() is used vring's producer and virtio_notify() is used
vring's consumer. They will be called one by one in one thread rather
than different threads, which looks odd and has a bad effect on
performance.

Thanks,
Yongji
