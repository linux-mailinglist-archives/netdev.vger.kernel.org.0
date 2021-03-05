Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE9A32E371
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 09:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEINE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 03:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhCEIMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 03:12:49 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5A24C061574
        for <netdev@vger.kernel.org>; Fri,  5 Mar 2021 00:12:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bm21so1725973ejb.4
        for <netdev@vger.kernel.org>; Fri, 05 Mar 2021 00:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=MBq2dGqsKbpMQki8GbETIioPY9a6dWwdNAOqi//tVmc=;
        b=porWskft+5t/TBuUshloZFxNjeupZlZ23+ErLyvvzGuXRkkEYh0vvQbJbucntZdqAg
         0ES+45LLefK3HEONaNlvegQ1vO5iTeel907vOXTK3EePZ8izS8gwXWV5fyWAY4GWOZ0Z
         5tk/5HS7ka14qwrbaJgTdKn790HLoPQHjao2dSkPjEvBMV4vj5LRycnQyCZoxw043iYM
         jX88gNjUJRTSNabDKBY1BHfqKcuzf8tJL18lOYbJUWwBIb2czXRDBoUeZKrlNpqB+vo4
         EedABKKbBL3IqVnaB4xIsYUGuZbmMZwsEbqSBko3xGQ6k4GCN0iLRX/ROIY/R//Lo0Zc
         MnaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=MBq2dGqsKbpMQki8GbETIioPY9a6dWwdNAOqi//tVmc=;
        b=RwetiQ3VzEMVHF3EzikluZjc8wYGbsoEt1ZwhseUWQhAU24asUSRvQQ3EzSA7WaHBu
         Kw+rhcO1Gn3zU8jD5sp7DPzde82XQi5BeNPEZMWX8VOTuzq8D90QG3Ef3VUdnS7qvGox
         WFID/TjEy4Jxysa5gmipCDlpGWI1n+a7qYC/bxwDCZzWQnNX0qAyocfd8c90kCCouDcC
         zFoxyGBeEi9gCyJ6epJRM8ra3w0vV13x5HW7m6PE/J3cwcLNU0zhOsOasR2kTksbKH+M
         1Rr7RxvEc1JZ9CUr/OvYiXf7WCCSVUb/G+L9Zzs5U18i7k68Y36uwwtxcTu1eSoswULf
         lVtg==
X-Gm-Message-State: AOAM531AjhjS6pwQtDpUEKnMSS/1OsNCQshsojbRLeHJb4FkWjfQzviY
        582Y4pO7Krc4ReJ79Fzh4N49mL8zpsmG5uaps/Wh
X-Google-Smtp-Source: ABdhPJwBVpzIGvikUm/YZyRyq/dpIgXIV3a8HsfaiFFYOPN+MrInYoK8nhTRYFkzCPSxGa96na2IDVTi9Bc9HIxIN8s=
X-Received: by 2002:a17:906:7b8d:: with SMTP id s13mr1273371ejo.247.1614931967461;
 Fri, 05 Mar 2021 00:12:47 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com> <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
 <b3faa4a6-a65b-faf7-985a-b2771533c8bb@redhat.com> <CACycT3uZ2ZPjUwVZqzQPZ4ke=VrHCkfNvYagA-oxggPUEUi0Vg@mail.gmail.com>
 <e933ec33-9d47-0ef5-9152-25cedd330ce2@redhat.com> <CACycT3ug30sQptdoSP8XzRJVN7Yb2DPLBtfG-RNbus3BOhdONA@mail.gmail.com>
 <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com>
In-Reply-To: <b01d9ee7-b038-cef2-8996-cd6401003267@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 16:12:36 +0800
Message-ID: <CACycT3vSRvRUbqbPNjAPQ-TeXnbqtrQO+gD1M0qDRRqX1zovVA@mail.gmail.com>
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

On Fri, Mar 5, 2021 at 3:37 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/5 3:27 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Fri, Mar 5, 2021 at 3:01 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/3/5 2:36 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>> On Fri, Mar 5, 2021 at 11:42 AM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> On 2021/3/5 11:30 =E4=B8=8A=E5=8D=88, Yongji Xie wrote:
> >>>>> On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wr=
ote:
> >>>>>> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> >>>>>>> On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> w=
rote:
> >>>>>>>> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>>>>>>>> This patch introduces a workqueue to support injecting
> >>>>>>>>> virtqueue's interrupt asynchronously. This is mainly
> >>>>>>>>> for performance considerations which makes sure the push()
> >>>>>>>>> and pop() for used vring can be asynchronous.
> >>>>>>>> Do you have pref numbers for this patch?
> >>>>>>>>
> >>>>>>> No, I can do some tests for it if needed.
> >>>>>>>
> >>>>>>> Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be us=
eless
> >>>>>>> if we call irq callback in ioctl context. Something like:
> >>>>>>>
> >>>>>>> virtqueue_push();
> >>>>>>> virtio_notify();
> >>>>>>>         ioctl()
> >>>>>>> -------------------------------------------------
> >>>>>>>             irq_cb()
> >>>>>>>                 virtqueue_get_buf()
> >>>>>>>
> >>>>>>> The used vring is always empty each time we call virtqueue_push()=
 in
> >>>>>>> userspace. Not sure if it is what we expected.
> >>>>>> I'm not sure I get the issue.
> >>>>>>
> >>>>>> THe used ring should be filled by virtqueue_push() which is done b=
y
> >>>>>> userspace before?
> >>>>>>
> >>>>> After userspace call virtqueue_push(), it always call virtio_notify=
()
> >>>>> immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
> >>>>> will inject an irq to VM and return, then vcpu thread will call
> >>>>> interrupt handler. But in container (virtio-vdpa) cases,
> >>>>> virtio_notify() will call interrupt handler directly. So it looks l=
ike
> >>>>> we have to optimize the virtio-vdpa cases. But one problem is we do=
n't
> >>>>> know whether we are in the VM user case or container user case.
> >>>> Yes, but I still don't get why used ring is empty after the ioctl()?
> >>>> Used ring does not use bounce page so it should be visible to the ke=
rnel
> >>>> driver. What did I miss :) ?
> >>>>
> >>> Sorry, I'm not saying the kernel can't see the correct used vring. I
> >>> mean the kernel will consume the used vring in the ioctl context
> >>> directly in the virtio-vdpa case. In userspace's view, that means
> >>> virtqueue_push() is used vring's producer and virtio_notify() is used
> >>> vring's consumer. They will be called one by one in one thread rather
> >>> than different threads, which looks odd and has a bad effect on
> >>> performance.
> >>
> >> Yes, that's why we need a workqueue (WQ_UNBOUND you used). Or do you
> >> want to squash this patch into patch 8?
> >>
> >> So I think we can see obvious difference when virtio-vdpa is used.
> >>
> > But it looks like we don't need this workqueue in vhost-vdpa cases.
> > Any suggestions?
>
>
> I haven't had a deep thought. But I feel we can solve this by using the
> irq bypass manager (or something similar). Then we don't need it to be
> relayed via workqueue and vdpa. But I'm not sure how hard it will be.
>

 Or let vdpa bus drivers give us some information?

> Do you see any obvious performance regression by using the workqueue? Or
> we can optimize it in the future.
>

Agree.

Thanks,
Yongji
