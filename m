Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4125C392B8E
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 12:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236129AbhE0KQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 06:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236105AbhE0KQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 06:16:16 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10BCBC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:14:41 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y7so230567eda.2
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 03:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=o38M2BO4ULC4BwKVVDJHYXw+IueHUfFLXYDhWYbT5Ig=;
        b=bk97lq21A/Gg9EU/Cabtt5Dqiuz3zBqg0ZUgn7vHbNo202Sf8zs+esbsZi1472wnDw
         S7tg6T6IbhEKaYeIj4ycsX234NuYYQ0O03FJH5OuiLMpN12/IGb9B/GLV656R4LkrXT7
         zQXhfkYtCReY5f9nCUn7YrhTXkoz5KTPkbYMp2eVWnOvCvOgMk7Ao4RZ5Kt3v2UB38LU
         FgaCGvVGlM5kjH6PanAP74M5XXJO0vEBEDZcBdVLoVPKz7aiDJuuycVw1/jPmGZ/Y2Zw
         NVvS36r16Wba8DeiGMEViGPX9yGp3JsaaE96mEEaPQwksZ0ldz0nzt72uYtVn0AqNCTd
         81Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o38M2BO4ULC4BwKVVDJHYXw+IueHUfFLXYDhWYbT5Ig=;
        b=eAxZOd/XDdy96QzmUiADJWyzw5ITJM5hhKsPXdlXAPrQRQR4II/TP3Mtjcg3fbmXCO
         sQtslEJGIwd5/Eqa8MVAPAkizqeNADs8gza3SNtdVl8gKaPRzKjD8Oyvim4IjcQcgOTF
         //ATOEkSoW7g54l3m1ly3cfBABTNfPbrkOetRX2q5nVigMTgJR7H5+IFNNpJkgYiRq8F
         H7T97NtWXnTSn0OdRlZaLXrJCk+Lxp9LHlOlAs+x1Ch8+DTntT3RO2UWfauYtp2EGh/K
         wZmu06KaZqhYFiCcjK3poOmwb/sxdGwUHL5hSJJetGnR5/n8vjtNZeNmcAzn+D0ESCKf
         Y9rg==
X-Gm-Message-State: AOAM532fG2Q+RxXcFtyZqImfGHWLZ7SvnVLaoIAQa5AZs+IiKcjoVME/
        i8BgObUd3tZLNXEYdpq8AH4DCeQ0g1bIPUib8tsD
X-Google-Smtp-Source: ABdhPJxWXHvU/O2LATe1oBP0kHpNNov+YKoz7byZgiRDTGMJZExbTJNux7H0l7VRJaIaAseiGKHKWtgXJ2fM2OTaKZE=
X-Received: by 2002:a05:6402:4252:: with SMTP id g18mr3221715edb.195.1622110479663;
 Thu, 27 May 2021 03:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com> <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com> <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com> <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
 <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com> <3cc7407d-9637-227e-9afa-402b6894d8ac@redhat.com>
In-Reply-To: <3cc7407d-9637-227e-9afa-402b6894d8ac@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 27 May 2021 18:14:27 +0800
Message-ID: <CACycT3s6SkER09KL_Ns9d03quYSKOuZwd3=HJ_s1SL7eH7y5gA@mail.gmail.com>
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

On Thu, May 27, 2021 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=884:41, Jason Wang =E5=86=99=E9=81=93=
:
> >
> > =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=883:34, Yongji Xie =E5=86=99=E9=81=
=93:
> >> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote=
:
> >>>
> >>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=881:08, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com>
> >>>> wrote:
> >>>>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=8812:57, Yongji Xie =E5=86=99=
=E9=81=93:
> >>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com>
> >>>>>> wrote:
> >>>>>>> =E5=9C=A8 2021/5/17 =E4=B8=8B=E5=8D=885:55, Xie Yongji =E5=86=99=
=E9=81=93:
> >>>>>>>> +
> >>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>>>>>>> +                           struct vduse_dev_msg *msg)
> >>>>>>>> +{
> >>>>>>>> +     init_waitqueue_head(&msg->waitq);
> >>>>>>>> +     spin_lock(&dev->msg_lock);
> >>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>>>>>>> +     wake_up(&dev->waitq);
> >>>>>>>> +     spin_unlock(&dev->msg_lock);
> >>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
> >>>>>>> What happens if the userspace(malicous) doesn't give a response
> >>>>>>> forever?
> >>>>>>>
> >>>>>>> It looks like a DOS. If yes, we need to consider a way to fix tha=
t.
> >>>>>>>
> >>>>>> How about using wait_event_killable_timeout() instead?
> >>>>> Probably, and then we need choose a suitable timeout and more
> >>>>> important,
> >>>>> need to report the failure to virtio.
> >>>>>
> >>>> Makes sense to me. But it looks like some
> >>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
> >>>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
> >>>> need to add some change for virtio core to handle the failure?
> >>>
> >>> Maybe, but I'm not sure how hard we can do that.
> >>>
> >> We need to change all virtio device drivers in this way.
> >
> >
> > Probably.
> >
> >
> >>
> >>> We had NEEDS_RESET but it looks we don't implement it.
> >>>
> >> Could it handle the failure of get_feature() and get/set_config()?
> >
> >
> > Looks not:
> >
> > "
> >
> > The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state
> > that a reset is needed. If DRIVER_OK is set, after it sets
> > DEVICE_NEEDS_RESET, the device MUST send a device configuration change
> > notification to the driver.
> >
> > "
> >
> > This looks implies that NEEDS_RESET may only work after device is
> > probed. But in the current design, even the reset() is not reliable.
> >
> >
> >>
> >>> Or a rough idea is that maybe need some relaxing to be coupled loosel=
y
> >>> with userspace. E.g the device (control path) is implemented in the
> >>> kernel but the datapath is implemented in the userspace like TUN/TAP.
> >>>
> >> I think it can work for most cases. One problem is that the set_config
> >> might change the behavior of the data path at runtime, e.g.
> >> virtnet_set_mac_address() in the virtio-net driver and
> >> cache_type_store() in the virtio-blk driver. Not sure if this path is
> >> able to return before the datapath is aware of this change.
> >
> >
> > Good point.
> >
> > But set_config() should be rare:
> >
> > E.g in the case of virtio-net with VERSION_1, config space is read
> > only, and it was set via control vq.
> >
> > For block, we can
> >
> > 1) start from without WCE or
> > 2) we add a config change notification to userspace or
> > 3) extend the spec to use vq instead of config space
> >
> > Thanks
>
>
> Another thing if we want to go this way:
>
> We need find a way to terminate the data path from the kernel side, to
> implement to reset semantic.
>

Do you mean terminate the data path in vdpa_reset(). Is it ok to just
notify userspace to stop data path asynchronously? Userspace should
not be able to do any I/O at that time because the iotlb mapping is
already removed.

Thanks,
Yongji
