Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDC3308B9
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 08:17:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbhCHHRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 02:17:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235172AbhCHHQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 02:16:55 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89313C061760
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 23:16:55 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id p8so18116120ejb.10
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 23:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xaxuwf4RG8cbOfVCQ4d5rGYvYEfJaL/g+mFlAyqWw/c=;
        b=FBUqUlDZcpT9ib1tHhNTn1hvqJGyS7qQXMaxtR/vVpbWQ7veHPlKcFTga2x6g7eDwH
         NrDaitaSnpZIyMVQRlwQ5KW7AK835j/Caq4tXpQqFmvCTBluv6KGdSP615eJ7+uTh9YT
         HMLYzjuLdckrto2Gjr0OgSodlAoZjv7h5iFbKybSeYo2Tmd59jzGgDtsVWkHdWHsZWon
         JG0wTDUVYlvLzWZwA4jNQjefQFebLe3NNgO9DNja5i8h1bLpHEypYGLWsaRStGikeW0h
         bNmXPqeOB4pNzhAqWQnTTIkKbaxxNCZqec+BHJcqjYhthEE2QzyQJC3NiaV8YiFzf+vY
         ordw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xaxuwf4RG8cbOfVCQ4d5rGYvYEfJaL/g+mFlAyqWw/c=;
        b=I5ar0gwq2OwVijHE4v2RbR5b0NSsD6rBQOeyl0zgzjvwEMtyQecm7ZIP+1P9I2ck93
         L6RP8bttvywsV9h1ck/kgnVwiltx4jcYZDYVNgNGZYtECes3h8T7yye9lmCgMkbNKxdO
         wQokH4ZunF4guttCOKN3ySvjuJdJfLSlT/ImVYYXk86vTZqg01BlFcX9J4BeleJzCo4y
         M7Q8NTvpBfC2mgE0i7cat30IIvCYVo+uqvEM5sh6DRTBCjaV5QZWqLso5bgqxaZtiJuE
         edoAxx3Z6RkArO0bvHOD/wvr01IDW2Wvo6AuqjGtbTjWJkJg7En4oFSZyKCNzdfRIyi1
         5TwQ==
X-Gm-Message-State: AOAM530Bnpv11xMLSRdWLyepkoaaI0P446nXHcyjTWGjHY74JAWlGHXF
        26JCNKMTA5ZlcRStxSpmcFENS5sHY47KX17LEc/yFzU+qA==
X-Google-Smtp-Source: ABdhPJzzf/dh6XnV06uV6XPMW9v1Fx0w+57Wonvc+tyTui0bI++NhX2X373wkpBFkzAFoLg+2PLxm3bWnK//5noZXks=
X-Received: by 2002:a17:906:86c6:: with SMTP id j6mr13155742ejy.197.1615187814236;
 Sun, 07 Mar 2021 23:16:54 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com> <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com> <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
 <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com> <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
 <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com> <CACycT3vSRvRUbqbPNjAPQ-TeXnbqtrQO+gD1M0qDRRqX1zovVA@mail.gmail.com>
 <44c21bf4-874d-24c9-334b-053c54e8422e@redhat.com> <CACycT3sZD2DEU=JxM-T+6dHBdsX5gOfAghh=Kg4PVw0PkNzEGw@mail.gmail.com>
 <a3ee164e-4de8-2305-ec4e-6eeef4aced29@redhat.com>
In-Reply-To: <a3ee164e-4de8-2305-ec4e-6eeef4aced29@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 8 Mar 2021 15:16:43 +0800
Message-ID: <CACycT3stSn_ccZcpFd_NgNHB82FDsD3-9feJjMyf-yMOV0tXKw@mail.gmail.com>
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

On Mon, Mar 8, 2021 at 3:02 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/8 12:50 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Mon, Mar 8, 2021 at 11:04 AM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 4:12 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 3:37 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> On 2021/3/5 3:27 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>> On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>>>> On 2021/3/5 2:36 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>>>> On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> =
wrote:
> >>>>>>>> On 2021/3/5 11:30 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> >>>>>>>>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com=
> wrote:
> >>>>>>>>>> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>>>>>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.co=
m> wrote:
> >>>>>>>>>>>> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>>>>>>>>>>>> This patch introduces a workqueue to support injecting
> >>>>>>>>>>>>> virtqueue's interrupt asynchronously. This is mainly
> >>>>>>>>>>>>> for performance considerations which makes sure the push()
> >>>>>>>>>>>>> and pop() for used vring can be asynchronous.
> >>>>>>>>>>>> Do you have pref numbers for this patch?
> >>>>>>>>>>>>
> >>>>>>>>>>> No, I can do some tests for it if needed.
> >>>>>>>>>>>
> >>>>>>>>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will b=
e useless
> >>>>>>>>>>> if we call irq callback in ioctl context. Something like:
> >>>>>>>>>>>
> >>>>>>>>>>> virtqueue_push();
> >>>>>>>>>>> virtio_notify();
> >>>>>>>>>>>           ioctl()
> >>>>>>>>>>> -------------------------------------------------
> >>>>>>>>>>>               irq_cb()
> >>>>>>>>>>>                   virtqueue_get_buf()
> >>>>>>>>>>>
> >>>>>>>>>>> The used vring is always empty each time we call virtqueue_pu=
sh() in
> >>>>>>>>>>> userspace. Not sure if it is what we expected.
> >>>>>>>>>> I'm not sure I get the issue.
> >>>>>>>>>>
> >>>>>>>>>> THe used ring should be filled by virtqueue_push() which is do=
ne by
> >>>>>>>>>> userspace before?
> >>>>>>>>>>
> >>>>>>>>> After userspace call virtqueue_push(), it always call virtio_no=
tify()
> >>>>>>>>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notif=
y()
> >>>>>>>>> will inject an irq to VM and return, then vcpu thread will call
> >>>>>>>>> interrupt handler. But in container (virtio-vdpa) cases,
> >>>>>>>>> virtio_notify() will call interrupt handler directly. So it loo=
ks like
> >>>>>>>>> we have to optimize the virtio-vdpa cases. But one problem is w=
e don't
> >>>>>>>>> know whether we are in the VM user case or container user case.
> >>>>>>>> Yes, but I still don't get why used ring is empty after the ioct=
l()?
> >>>>>>>> Used ring does not use bounce page so it should be visible to th=
e kernel
> >>>>>>>> driver. What did I miss :) ?
> >>>>>>>>
> >>>>>>> Sorry, I'm not saying the kernel can't see the correct used vring=
. I
> >>>>>>> mean the kernel will consume the used vring in the ioctl context
> >>>>>>> directly in the virtio-vdpa case. In userspace's view, that means
> >>>>>>> virtqueue_push() is used vring's producer and virtio_notify() is =
used
> >>>>>>> vring's consumer. They will be called one by one in one thread ra=
ther
> >>>>>>> than different threads, which looks odd and has a bad effect on
> >>>>>>> performance.
> >>>>>> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do y=
ou
> >>>>>> want to squash this patch into patch 8?
> >>>>>>
> >>>>>> So I think we can see obvious difference when virtio-vdpa is used.
> >>>>>>
> >>>>> But it looks like we don't need this workqueue in vhost-vdpa cases.
> >>>>> Any suggestions?
> >>>> I haven't had a deep thought. But I feel we can solve this by using =
the
> >>>> irq bypass manager (or something similar). Then we don't need it to =
be
> >>>> relayed via workqueue and vdpa. But I'm not sure how hard it will be=
.
> >>>>
> >>>    Or let vdpa bus drivers give us some information?
> >>
> >> This kind of 'type' is proposed in the early RFC of vDPA series. One
> >> issue is that at device level, we should not differ virtio from vhost,
> >> so if we introduce that, it might encourge people to design a device
> >> that is dedicated to vhost or virtio which might not be good.
> >>
> >> But we can re-visit this when necessary.
> >>
> > OK, I see. How about adding some information in ops.set_vq_cb()?
>
>
> I'm not sure I get this, maybe you can explain a little bit more?
>

For example, add an extra parameter for ops.set_vq_cb() to indicate
whether this callback will trigger the interrupt handler directly.

Thanks,
Yongji
