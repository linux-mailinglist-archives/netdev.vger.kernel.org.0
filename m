Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFEB6393C1B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 05:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbhE1D4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 23:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbhE1D43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 23:56:29 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058EEC061760
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 20:54:54 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id gb17so3263625ejc.8
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 20:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2ZLRemtbPVIGxGdr14fJ4jpBPRhMcvlWcSDK9Lq8+cA=;
        b=UFv0CeSDqvB7H4mkMIIZWvzf4ZRd39QgluC5dBflrM0VjpNZjb4IxVcqKSaFjQwfoU
         rWgDGpgWI0xme5OQoPqmq8AD4Bg47GUZ3YvvnYsyOqUgiOAVd+/QgHxhOseSV4531t1Y
         q98vrZOP0RiW2TNaGpGtHw15oZuuCxpO73Asd1j4SQ6gy0lkm58WXtdB/hN4BqYh6FU9
         yEPJgHuNA8Ks60yGNmeOlV3X8KsoFvpP05Rqnp8tYwo8GUgycM88TNuz9mDhgbSWS0TP
         NxrAo+V30nyDjMdF8BGfXOf5ZfkePuBez8giFvm6iDMPI8AxgjdRKhgpEh9WCjnfb+4Q
         JHEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2ZLRemtbPVIGxGdr14fJ4jpBPRhMcvlWcSDK9Lq8+cA=;
        b=fqUxeGGe6tjARMBlyOmQ3bltzzJfosfNEeYcyAWCfOtkOn6j6xv8g5sEtkv/M2sU1c
         CCQsjsaAs94I77MZm0CYqJT6/RWJE3VWEb8a6iKQKQyqo+EyJ0jXanubs0q885KNUeyW
         srnj5h94B8QqNklpTR4B8hiqUYmx6iVSX0WW+BJQ6//01s+QVciCDZipZLSk1lRo8Uvu
         kL/a6oxUERNenn80qqhdg0JIjQDC/UVrzUujQ5k21kJsc5rGoRM+FGZKaXIUeV3aIfdX
         Ac3WRSK0/V0krza05HQJsZV5BjHA5C4NNyUmoLNCHpqqzfhGlBxAduRE0THKx4BlGd59
         yQ7g==
X-Gm-Message-State: AOAM530V2LgoS+PkHGQGSB7xA0dFeOe5/IxDrKmdXt2Pc9dvfgy0bdzC
        XDuYz/d8D0RDtPe2oKcQBgl5u8ksAxpC5Yob5LgX
X-Google-Smtp-Source: ABdhPJxDXENlmXrhp9PJ7iDubTy3e2MiMZjJiP/T1ExNiyEHROjd2EqD6OIxlhrl7NlegeNQLvRVHcx+LTeAeQsIVcE=
X-Received: by 2002:a17:906:edaf:: with SMTP id sa15mr7021823ejb.174.1622174093482;
 Thu, 27 May 2021 20:54:53 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com> <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com> <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com> <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
 <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com> <3cc7407d-9637-227e-9afa-402b6894d8ac@redhat.com>
 <CACycT3s6SkER09KL_Ns9d03quYSKOuZwd3=HJ_s1SL7eH7y5gA@mail.gmail.com> <baf0016a-7930-2ae2-399f-c28259f415c1@redhat.com>
In-Reply-To: <baf0016a-7930-2ae2-399f-c28259f415c1@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Fri, 28 May 2021 11:54:42 +0800
Message-ID: <CACycT3vKZ3y0gga8PrSVtssZfNV0Y-A8=iYZSi9sbpHRNkVf-A@mail.gmail.com>
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

On Fri, May 28, 2021 at 9:33 AM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=886:14, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Thu, May 27, 2021 at 4:43 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=884:41, Jason Wang =E5=86=99=E9=81=
=93:
> >>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=883:34, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>> On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wro=
te:
> >>>>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=881:08, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>>>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com>
> >>>>>> wrote:
> >>>>>>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=8812:57, Yongji Xie =E5=86=99=
=E9=81=93:
> >>>>>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com=
>
> >>>>>>>> wrote:
> >>>>>>>>> =E5=9C=A8 2021/5/17 =E4=B8=8B=E5=8D=885:55, Xie Yongji =E5=86=
=99=E9=81=93:
> >>>>>>>>>> +
> >>>>>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>>>>>>>>> +                           struct vduse_dev_msg *msg)
> >>>>>>>>>> +{
> >>>>>>>>>> +     init_waitqueue_head(&msg->waitq);
> >>>>>>>>>> +     spin_lock(&dev->msg_lock);
> >>>>>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>>>>>>>>> +     wake_up(&dev->waitq);
> >>>>>>>>>> +     spin_unlock(&dev->msg_lock);
> >>>>>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
> >>>>>>>>> What happens if the userspace(malicous) doesn't give a response
> >>>>>>>>> forever?
> >>>>>>>>>
> >>>>>>>>> It looks like a DOS. If yes, we need to consider a way to fix t=
hat.
> >>>>>>>>>
> >>>>>>>> How about using wait_event_killable_timeout() instead?
> >>>>>>> Probably, and then we need choose a suitable timeout and more
> >>>>>>> important,
> >>>>>>> need to report the failure to virtio.
> >>>>>>>
> >>>>>> Makes sense to me. But it looks like some
> >>>>>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have=
 a
> >>>>>> return value.  Now I add a WARN_ON() for the failure. Do you mean =
we
> >>>>>> need to add some change for virtio core to handle the failure?
> >>>>> Maybe, but I'm not sure how hard we can do that.
> >>>>>
> >>>> We need to change all virtio device drivers in this way.
> >>>
> >>> Probably.
> >>>
> >>>
> >>>>> We had NEEDS_RESET but it looks we don't implement it.
> >>>>>
> >>>> Could it handle the failure of get_feature() and get/set_config()?
> >>>
> >>> Looks not:
> >>>
> >>> "
> >>>
> >>> The device SHOULD set DEVICE_NEEDS_RESET when it enters an error stat=
e
> >>> that a reset is needed. If DRIVER_OK is set, after it sets
> >>> DEVICE_NEEDS_RESET, the device MUST send a device configuration chang=
e
> >>> notification to the driver.
> >>>
> >>> "
> >>>
> >>> This looks implies that NEEDS_RESET may only work after device is
> >>> probed. But in the current design, even the reset() is not reliable.
> >>>
> >>>
> >>>>> Or a rough idea is that maybe need some relaxing to be coupled loos=
ely
> >>>>> with userspace. E.g the device (control path) is implemented in the
> >>>>> kernel but the datapath is implemented in the userspace like TUN/TA=
P.
> >>>>>
> >>>> I think it can work for most cases. One problem is that the set_conf=
ig
> >>>> might change the behavior of the data path at runtime, e.g.
> >>>> virtnet_set_mac_address() in the virtio-net driver and
> >>>> cache_type_store() in the virtio-blk driver. Not sure if this path i=
s
> >>>> able to return before the datapath is aware of this change.
> >>>
> >>> Good point.
> >>>
> >>> But set_config() should be rare:
> >>>
> >>> E.g in the case of virtio-net with VERSION_1, config space is read
> >>> only, and it was set via control vq.
> >>>
> >>> For block, we can
> >>>
> >>> 1) start from without WCE or
> >>> 2) we add a config change notification to userspace or
> >>> 3) extend the spec to use vq instead of config space
> >>>
> >>> Thanks
> >>
> >> Another thing if we want to go this way:
> >>
> >> We need find a way to terminate the data path from the kernel side, to
> >> implement to reset semantic.
> >>
> > Do you mean terminate the data path in vdpa_reset().
>
>
> Yes.
>
>
> >   Is it ok to just
> > notify userspace to stop data path asynchronously?
>
>
> For well-behaved userspace, yes but no for buggy or malicious ones.
>

But the buggy or malicious daemons can't do anything if my
understanding is correct.

> I had an idea, how about terminate IOTLB in this case? Then we're in
> fact turn datapath off.
>

Sorry, I didn't get your point here. What do you mean by terminating
IOTLB? Remove iotlb mapping? But userspace can still access the mapped
region.

Thanks,
Yongji
