Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C33D3306FC
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 05:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhCHEuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 23:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhCHEuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 23:50:19 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9348DC06174A
        for <netdev@vger.kernel.org>; Sun,  7 Mar 2021 20:50:19 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id bd6so12667452edb.10
        for <netdev@vger.kernel.org>; Sun, 07 Mar 2021 20:50:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f8lrR0ZiQSWaL4KkWmwSgVmShpah+Hqkiq/7u9MC3Ec=;
        b=bmd/qNoUyZ3W++JI1eWHTA6hXgZHecFIc0E547jJwbtTn70UxX6QzwAFus163+j3KJ
         Zb0UcgxnaOojruQmNOPQsc6F47QRL9F+1kHeKJciVxhV1UPMoVF93dUkhassGHVxl3N9
         /KruMtkdxz98BVXZCY8VWL0HB2ybk3mC9gO8yaq6Yn6lWJoocOIwUTaugpeUpDLGmvLL
         o5h39mCM6sn6c8GF3cuEMrvR7eE573EuO7HYzPSv2Vjtzgr5zmDYL7y9sWTEHQ33AGQ4
         Kn0xT2AzgvT06obRqhjb3FLEJ/kmHJNBd+le74lwvBZaw0D9zpsHFquJ1TvgGygxZRG0
         j7Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f8lrR0ZiQSWaL4KkWmwSgVmShpah+Hqkiq/7u9MC3Ec=;
        b=lm7tZESYyWTnGmNU1ni3H9TFsXpfqH6M9v7ukgYVuCOo1l6O5j58WCsCR7VJYHDQQN
         tMHoerwBZrfwBrY1Fxhgy4m4IOi8X46GozhimITCnJTTM7xFgw5z6fjm54LU406iMpiW
         uC2H2hq42OQUegA2QgRCI+w8c0zIYkQtOVxp+KQ3XbtczSyJOQazp+y2yDIbkJMKGpBU
         SwqP3tlrqnZgJD1RI1bWsozSGEvcfiotDOb2gy25w2Y0Bqe5BuvxlDFui93FKBybLLE1
         CK4EIZ1m5OwJIzLmCtLdgfOIz8aSVAGTndUaEgU+Ofj9vEnjmVJHh+bXEoMa0u3L2PZg
         1vOw==
X-Gm-Message-State: AOAM533+QLeqrKYRBEt5HaX+Y3tbznp/3Yb2g0tzYKUj3FodJGRfaGdp
        XnSan07+4wpNeH4KtuBd5wVvBr/sce/Vagk6pgro
X-Google-Smtp-Source: ABdhPJyP73PgPrTEn5ZRwI0uF0fAfXgSrG4K8zBx7Ya+smcB67VFKL3uJxgtQS1IadQYI/2VpEQd/iR/G9g05fsqakg=
X-Received: by 2002:a05:6402:4314:: with SMTP id m20mr19843171edc.5.1615179017444;
 Sun, 07 Mar 2021 20:50:17 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com> <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com> <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
 <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com> <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
 <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com> <CACycT3vSRvRUbqbPNjAPQ-TeXnbqtrQO+gD1M0qDRRqX1zovVA@mail.gmail.com>
 <44c21bf4-874d-24c9-334b-053c54e8422e@redhat.com>
In-Reply-To: <44c21bf4-874d-24c9-334b-053c54e8422e@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Mon, 8 Mar 2021 12:50:07 +0800
Message-ID: <CACycT3sZD2DEU=JxM-T+6dHBdsX5gOfAghh=Kg4PVw0PkNzEGw@mail.gmail.com>
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

On Mon, Mar 8, 2021 at 11:04 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 4:12 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 3:37 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 3:27 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>> On 2021/3/5 2:36 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>> On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2021/3/5 11:30 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> >>>>>>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> =
wrote:
> >>>>>>>> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>>>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com>=
 wrote:
> >>>>>>>>>> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>>>>>>>>>> This patch introduces a workqueue to support injecting
> >>>>>>>>>>> virtqueue's interrupt asynchronously. This is mainly
> >>>>>>>>>>> for performance considerations which makes sure the push()
> >>>>>>>>>>> and pop() for used vring can be asynchronous.
> >>>>>>>>>> Do you have pref numbers for this patch?
> >>>>>>>>>>
> >>>>>>>>> No, I can do some tests for it if needed.
> >>>>>>>>>
> >>>>>>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be =
useless
> >>>>>>>>> if we call irq callback in ioctl context. Something like:
> >>>>>>>>>
> >>>>>>>>> virtqueue_push();
> >>>>>>>>> virtio_notify();
> >>>>>>>>>          ioctl()
> >>>>>>>>> -------------------------------------------------
> >>>>>>>>>              irq_cb()
> >>>>>>>>>                  virtqueue_get_buf()
> >>>>>>>>>
> >>>>>>>>> The used vring is always empty each time we call virtqueue_push=
() in
> >>>>>>>>> userspace. Not sure if it is what we expected.
> >>>>>>>> I'm not sure I get the issue.
> >>>>>>>>
> >>>>>>>> THe used ring should be filled by virtqueue_push() which is done=
 by
> >>>>>>>> userspace before?
> >>>>>>>>
> >>>>>>> After userspace call virtqueue_push(), it always call virtio_noti=
fy()
> >>>>>>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notify(=
)
> >>>>>>> will inject an irq to VM and return, then vcpu thread will call
> >>>>>>> interrupt handler. But in container (virtio-vdpa) cases,
> >>>>>>> virtio_notify() will call interrupt handler directly. So it looks=
 like
> >>>>>>> we have to optimize the virtio-vdpa cases. But one problem is we =
don't
> >>>>>>> know whether we are in the VM user case or container user case.
> >>>>>> Yes, but I still don't get why used ring is empty after the ioctl(=
)?
> >>>>>> Used ring does not use bounce page so it should be visible to the =
kernel
> >>>>>> driver. What did I miss :) ?
> >>>>>>
> >>>>> Sorry, I'm not saying the kernel can't see the correct used vring. =
I
> >>>>> mean the kernel will consume the used vring in the ioctl context
> >>>>> directly in the virtio-vdpa case. In userspace's view, that means
> >>>>> virtqueue_push() is used vring's producer and virtio_notify() is us=
ed
> >>>>> vring's consumer. They will be called one by one in one thread rath=
er
> >>>>> than different threads, which looks odd and has a bad effect on
> >>>>> performance.
> >>>> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do you
> >>>> want to squash this patch into patch 8?
> >>>>
> >>>> So I think we can see obvious difference when virtio-vdpa is used.
> >>>>
> >>> But it looks like we don't need this workqueue in vhost-vdpa cases.
> >>> Any suggestions?
> >>
> >> I haven't had a deep thought. But I feel we can solve this by using th=
e
> >> irq bypass manager (or something similar). Then we don't need it to be
> >> relayed via workqueue and vdpa. But I'm not sure how hard it will be.
> >>
> >   Or let vdpa bus drivers give us some information?
>
>
> This kind of 'type' is proposed in the early RFC of vDPA series. One
> issue is that at device level, we should not differ virtio from vhost,
> so if we introduce that, it might encourge people to design a device
> that is dedicated to vhost or virtio which might not be good.
>
> But we can re-visit this when necessary.
>

OK, I see. How about adding some information in ops.set_vq_cb()?

Thanks,
Yongji
