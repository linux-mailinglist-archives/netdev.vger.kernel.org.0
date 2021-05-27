Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835EB3928A0
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbhE0HgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 03:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233284AbhE0Hfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 03:35:54 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABB94C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 00:34:21 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id s22so6455988ejv.12
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 00:34:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JpPCkjOAGobfSNtpJxvUsntsk9lsRgQ1IR3+Mq27bcI=;
        b=uMfYoJuLhl1KdRjAz6yEq3nbDEYIPQGLPOZo1dzv2U1WiTHQwyTUwYCbEPLT8+euBR
         88x6YAEk2hBave7+d7G+vz7hvjmmWMj7KtUuw++18w7mDwPL4FmzZsGHehLYCV/JxvWB
         0hXKY78gxyqW23n0ICW56b92UcN6Emj4izFb+TMFEGsfxuWSVVmCM7ddoNKpxI/zUDlC
         kYi91qI7d/gPDmflc8jbzkRfQvBe8r0E9Rl9fmnhOl3WM+9wsfv/3a3WUQk+YAipuc0y
         sU4BmfNzMxrrzrFXEaeHWUakPY+IGpQWpVBiWhRBKWSdEIGn1O73/meTmJtMab333NDZ
         4luA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=JpPCkjOAGobfSNtpJxvUsntsk9lsRgQ1IR3+Mq27bcI=;
        b=qZjLZCvLNjtO+BX5LnsEgVnV0iJ22bY348EJTgB/Lv4QyyUJPXkM7lgpGSt5wmCssJ
         9OGXBTZrBfkj+tCIUA6wE/aQYxZBIQFIDyKvVNdwvuTN0ra8Tg14jFWgyXjhHo4khpaJ
         MbfupzFzFyXUM6UH2oQ7DpE9+yDrLpuKo6BZbYS6YpXlaPvcEeFL0gCQW5Ufc0iVfLPZ
         hEkse6btQbUOQeo4Hz9uRSC2sdg3C/NwgDrTm0kB2KvDHB8MwjQS+6ZiODZEkRIQFFs1
         s0S/e3oJNgh93pxliuQ/aOU759iwodrwpIqKUPWwcUfGU1uJiavt8RHL8gvA4TGnGLHz
         TZ/w==
X-Gm-Message-State: AOAM530NPRK01I6bnNJb3/hTyYcukAXVBw2TVhUJl/rTJB9ei4TnuGVa
        bzxsA4sd+66YGG5OskYRDfmT62sUicoB1EUdu3Rb
X-Google-Smtp-Source: ABdhPJx+nv79LV9LGHH2XXyBW6TJ1VbhAhSRhvc0U1UpO3biGSUk5ekbz3VHC3tbBnZ/C+qT8NXNA6kYjMYh4+evHdM=
X-Received: by 2002:a17:907:7684:: with SMTP id jv4mr2315095ejc.427.1622100860243;
 Thu, 27 May 2021 00:34:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com> <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com> <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com>
In-Reply-To: <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 27 May 2021 15:34:09 +0800
Message-ID: <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
Subject: Re: Re: [PATCH v7 11/12] vduse: Introduce VDUSE - vDPA Device in Userspace
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
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
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=881:08, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=8812:57, Yongji Xie =E5=86=99=E9=
=81=93:
> >>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>> =E5=9C=A8 2021/5/17 =E4=B8=8B=E5=8D=885:55, Xie Yongji =E5=86=99=E9=
=81=93:
> >>>>> +
> >>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>>>> +                           struct vduse_dev_msg *msg)
> >>>>> +{
> >>>>> +     init_waitqueue_head(&msg->waitq);
> >>>>> +     spin_lock(&dev->msg_lock);
> >>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>>>> +     wake_up(&dev->waitq);
> >>>>> +     spin_unlock(&dev->msg_lock);
> >>>>> +     wait_event_killable(msg->waitq, msg->completed);
> >>>> What happens if the userspace(malicous) doesn't give a response fore=
ver?
> >>>>
> >>>> It looks like a DOS. If yes, we need to consider a way to fix that.
> >>>>
> >>> How about using wait_event_killable_timeout() instead?
> >>
> >> Probably, and then we need choose a suitable timeout and more importan=
t,
> >> need to report the failure to virtio.
> >>
> > Makes sense to me. But it looks like some
> > vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
> > return value.  Now I add a WARN_ON() for the failure. Do you mean we
> > need to add some change for virtio core to handle the failure?
>
>
> Maybe, but I'm not sure how hard we can do that.
>

We need to change all virtio device drivers in this way.

> We had NEEDS_RESET but it looks we don't implement it.
>

Could it handle the failure of get_feature() and get/set_config()?

> Or a rough idea is that maybe need some relaxing to be coupled loosely
> with userspace. E.g the device (control path) is implemented in the
> kernel but the datapath is implemented in the userspace like TUN/TAP.
>

I think it can work for most cases. One problem is that the set_config
might change the behavior of the data path at runtime, e.g.
virtnet_set_mac_address() in the virtio-net driver and
cache_type_store() in the virtio-blk driver. Not sure if this path is
able to return before the datapath is aware of this change.

Thanks,
Yongji
