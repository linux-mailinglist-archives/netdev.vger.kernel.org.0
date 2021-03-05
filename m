Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 446AF32E2E7
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbhCEH10 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 02:27:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbhCEH10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 02:27:26 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEEA8C06175F
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 23:27:25 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id h10so1199474edl.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 23:27:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hM0XVBnBjvo6Mcn0O7eJCM7OuQBmW0OA0z+7Q1PSpD0=;
        b=dNI/7ddrUUBV1gT2sOck2Qs9XORP9rv7TZSeSwpRwn1+PFmreDEPtnkLFrU+Jivwv8
         y6BxcPLp3QycfOG0HL/1ux+3esOM0tZiTu4Ja2dB6gjQBefRQX/VOvmGDcsS1En+RktH
         bKQXxeLBiyMINDjZRY7dKDlghINiR7QrhlSL3DZaEU/M2MCJQnnQ/Rtf/WYqP2Cg+AhQ
         AwTDcV08MI0milFSazXs7mjCrTK80d8vB5F3FqP812oU+kVxVgaMAkE7B3WgHkFCU0mS
         whFfjNTBtBiWqLpZO4leil6ySnNP8sk/yTumXztNWjcCj/83mtMRavXjLZXQ16MzZYFd
         mq6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hM0XVBnBjvo6Mcn0O7eJCM7OuQBmW0OA0z+7Q1PSpD0=;
        b=VAtCdYRbRD6HT6q6Ij6QNKYoS6is++yIGz7IDC3UjH83AHpdHLp/Dm8I0H61abwHXq
         zatK+iqTSrbC48jnpQxj6F5lsnaTRuebVOFv57Gr3IwBbQnTiFwSCmtYwh+XdA10OoM7
         oCtq3npTPk7Enfkq92qLDs2XxTFOkYPhXPBjM7pUr3rezv42VR1T5uqzdPiU/8qWeBDp
         N1+33ycJQPFfeLFFV3SE2vhxqyFTurxJsBCIf8aP1s8WYciU4FRPYEgwHBXb2VbhNy53
         a/RMuMRH4zauX0yAtgVw+JRxvXOe+veiwg33ZaqHxrB38ExHyXp37l6yVY9PEbXYpcyS
         AwRA==
X-Gm-Message-State: AOAM5325DD+5nCQqFqOf7jYe4iCS6Y4w/sqidWrdFFPHNYwhy0Heaa5C
        h/pix9Phr0BwojnMTWeWSaZuUj1Msvvqf6UoKva0R8t3aQ==
X-Google-Smtp-Source: ABdhPJxue5Ac0KWm5LuWB3zHp3MbVN6tHMJsqST8murh5iUTYzZb9u6sReCwvdokxCB2Xhd8hKmcmRqFLWouZ7AI6V4=
X-Received: by 2002:aa7:d687:: with SMTP id d7mr7858393edr.118.1614929244463;
 Thu, 04 Mar 2021 23:27:24 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com> <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com> <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
 <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com>
In-Reply-To: <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 15:27:13 +0800
Message-ID: <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
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

On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 2:36 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 11:30 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>>>> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>>>>>> This patch introduces a workqueue to support injecting
> >>>>>>> virtqueue's interrupt asynchronously. This is mainly
> >>>>>>> for performance considerations which makes sure the push()
> >>>>>>> and pop() for used vring can be asynchronous.
> >>>>>> Do you have pref numbers for this patch?
> >>>>>>
> >>>>> No, I can do some tests for it if needed.
> >>>>>
> >>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be usel=
ess
> >>>>> if we call irq callback in ioctl context. Something like:
> >>>>>
> >>>>> virtqueue_push();
> >>>>> virtio_notify();
> >>>>>        ioctl()
> >>>>> -------------------------------------------------
> >>>>>            irq_cb()
> >>>>>                virtqueue_get_buf()
> >>>>>
> >>>>> The used vring is always empty each time we call virtqueue_push() i=
n
> >>>>> userspace. Not sure if it is what we expected.
> >>>> I'm not sure I get the issue.
> >>>>
> >>>> THe used ring should be filled by virtqueue_push() which is done by
> >>>> userspace before?
> >>>>
> >>> After userspace call virtqueue_push(), it always call virtio_notify()
> >>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
> >>> will inject an irq to VM and return, then vcpu thread will call
> >>> interrupt handler. But in container (virtio-vdpa) cases,
> >>> virtio_notify() will call interrupt handler directly. So it looks lik=
e
> >>> we have to optimize the virtio-vdpa cases. But one problem is we don'=
t
> >>> know whether we are in the VM user case or container user case.
> >>
> >> Yes, but I still don't get why used ring is empty after the ioctl()?
> >> Used ring does not use bounce page so it should be visible to the kern=
el
> >> driver. What did I miss :) ?
> >>
> > Sorry, I'm not saying the kernel can't see the correct used vring. I
> > mean the kernel will consume the used vring in the ioctl context
> > directly in the virtio-vdpa case. In userspace's view, that means
> > virtqueue_push() is used vring's producer and virtio_notify() is used
> > vring's consumer. They will be called one by one in one thread rather
> > than different threads, which looks odd and has a bad effect on
> > performance.
>
>
> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do you
> want to squash this patch into patch 8?
>
> So I think we can see obvious difference when virtio-vdpa is used.
>

But it looks like we don't need this workqueue in vhost-vdpa cases.
Any suggestions?

Thanks,
Yongji
