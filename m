Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2581432E019
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:30:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCEDai (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:30:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhCEDai (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:30:38 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB692C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 19:30:36 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id w17so770664ejc.6
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 19:30:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C+ogyoK38Cfjz7G3M+eNy9cM9qZXYZcebDJjq71Ozuw=;
        b=E8CbUqZf//ZG2QYu9FjpoxyYNbMaGC9Pp0vBTdX4rtXrkcj7wSsGa0RM6Bs5zqxHau
         y/5iXXA4/tMsiruZNCtCvvk3yikHmAlpz951XsxJ+o1NSwupTcpAqvdhrsDUXB5qDwdR
         6XLjWLrip7jQ0ITAPPGNm0X8JlvTyKdgSoFqOo+SPpN3S1tg3+fto7qZFR/EOJ+GztDt
         jUxS5rng6CUDofq5poHG4fDcOLIQD4+0OJBlzz9FnYOdlJrGNV/saY03oAF3pRANkF+a
         pzSas7ceuy2CaHRqOJnhRMsTIuZTVe4sdsdEoLs3kiLopj9Ud2J+bnZyhRGPUaRwWhHh
         mIkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C+ogyoK38Cfjz7G3M+eNy9cM9qZXYZcebDJjq71Ozuw=;
        b=XHTzRm2grlC2fnnOy0Jgjr2hDgOYwt1wm1uQ+oDhTbQMyRfe8nwiygnzsSPQkXJo5U
         Nbjd1Mya6MGWsC0OehScUq6WuZ13vPwOE5KDwz2iGEgjlg06QAlgq4m2sMjFW/soSAG/
         GnDKeLhLJuOwZOGvy01VVsLrtoDqDDscB0h+P7xWqrKPm3iUX2gQjLQnwmeeVhDn7wPu
         /JL2rG/VxqZsm5IWFUIK8q/CwU5Qnw5wmGTGQvgFEA/KWfueen3g1AV5lTfq0o00lUzz
         Upw2fj6FnBcmJjtQrM6xjj9C28kyjBLzZmcnJIM3Umiqmo5Y5juqZUdx7tVWxFJbdLcD
         Ypag==
X-Gm-Message-State: AOAM530MKY2LgnOysU7eH5gNr4cjUk0Lxz5JxuQDhFMVaFunfgQU67u2
        U05qKBp0MVfqp7mEh4d8XC8Hqwl9UOsDrxb4TbpF
X-Google-Smtp-Source: ABdhPJwRp2OwjEEAfQc6V+wGt2nQ5v2L9KaeVb8YODxriL3dl3YvNTj2dO/X0edCrvphEMKoVtpIbiUujoYjSRR4VBI=
X-Received: by 2002:a17:906:128e:: with SMTP id k14mr513662ejb.427.1614915035112;
 Thu, 04 Mar 2021 19:30:35 -0800 (PST)
MIME-Version: 1.0
References: <20210223115048.435-1-xieyongji@bytedance.com> <20210223115048.435-11-xieyongji@bytedance.com>
 <d63e4cfd-4992-8493-32b0-18e0478f6e1a@redhat.com> <CACycT3tqM=ALOG1r0Ve6UTGmwJ7Wg7fQpLZypjZsJF1mJ+adMA@mail.gmail.com>
 <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com>
In-Reply-To: <2d3418d9-856c-37ee-7614-af5b721becd7@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 5 Mar 2021 11:30:24 +0800
Message-ID: <CACycT3u0+LTbtFMS75grKGZ2mnXzHnKug+HGWbf+nqVybqwkZQ@mail.gmail.com>
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

On Fri, Mar 5, 2021 at 11:05 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> On 2021/3/4 4:58 =E4=B8=8B=E5=8D=88, Yongji Xie wrote:
> > On Thu, Mar 4, 2021 at 2:59 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> On 2021/2/23 7:50 =E4=B8=8B=E5=8D=88, Xie Yongji wrote:
> >>> This patch introduces a workqueue to support injecting
> >>> virtqueue's interrupt asynchronously. This is mainly
> >>> for performance considerations which makes sure the push()
> >>> and pop() for used vring can be asynchronous.
> >>
> >> Do you have pref numbers for this patch?
> >>
> > No, I can do some tests for it if needed.
> >
> > Another problem is the VIRTIO_RING_F_EVENT_IDX feature will be useless
> > if we call irq callback in ioctl context. Something like:
> >
> > virtqueue_push();
> > virtio_notify();
> >      ioctl()
> > -------------------------------------------------
> >          irq_cb()
> >              virtqueue_get_buf()
> >
> > The used vring is always empty each time we call virtqueue_push() in
> > userspace. Not sure if it is what we expected.
>
>
> I'm not sure I get the issue.
>
> THe used ring should be filled by virtqueue_push() which is done by
> userspace before?
>

After userspace call virtqueue_push(), it always call virtio_notify()
immediately. In traditional VM (vhost-vdpa) cases, virtio_notify()
will inject an irq to VM and return, then vcpu thread will call
interrupt handler. But in container (virtio-vdpa) cases,
virtio_notify() will call interrupt handler directly. So it looks like
we have to optimize the virtio-vdpa cases. But one problem is we don't
know whether we are in the VM user case or container user case.

Thanks,
Yongji
