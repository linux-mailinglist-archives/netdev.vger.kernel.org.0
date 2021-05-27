Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D7E392F55
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236430AbhE0NTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236373AbhE0NTp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 09:19:45 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF7CC061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 06:18:10 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id gb17so7844ejc.8
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 06:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nQgFn8dxliqZkV+84EDBr5D6XtzraqZ1JcCt4vcxaEg=;
        b=U+4BjfZGBFAb1qVG2dykR4pGeBdKBFy1a0gYiCM/bVIvP4FQgP0Rlv2zd+rc7Cb3qV
         pR+aE2uu9wEZvhgfWfZxsIR/HpvJ2SiNN/uDvKZIKLLr9rQzwjL8rIyIyDU6Qh6tshvo
         fPVAeH9h6ZTQlSdYq8Z3GN9z4duLY02ZtqKLyiXt4CnpYZLHuHaD5CywUaq9UxR1K9JO
         RCRP/QniKCl0pELJZt2SJ4/29wuT+lh8Gu/dnTU2TsNSQ7CgvIKF0SytFPqHlZAnOd0g
         949d1X4Aehx49vMb6axO60paWMz84o4PHz2KAygA9S9MxJyuPxN+bjMMCpX/d/j0cmuN
         lQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nQgFn8dxliqZkV+84EDBr5D6XtzraqZ1JcCt4vcxaEg=;
        b=qYvrs0YNCZi9z+b+NWsbehaVWfXtK+KeUa2CEeA1ExCzd4oN9vLGdBSYt3pKOkJdDx
         jwhP/3UDUvpLZPlFouXfW0NaKBrhwyLZUbSv00pbo7IcccsDMOxJLQoNIZHruYJpJvic
         hErShivPq73wr4H7vLBmkqZTi7HkbruPjKEKbH3Bi14Zi5o3SZLHVilRyZdpoHb458it
         rIoiUK2dm9WmBAak0ByLaDrzu6lXQHInnySnl/GAnlhb6hSFzRNyQBkm3Pn2a3RsXZf9
         VUw8tz8m22ch7+h4UKMqSc5wy4W118ZJpR+WK6iGJH6ZI7sRCs973UWF3AZyQnvvpbjr
         SZVQ==
X-Gm-Message-State: AOAM531LI3/hJlCdKj2bITy6/n28IJEvO5GDvwKCu5zG9kZ8kUeC3uC9
        NM91aWoar+Lgq5VwlxoKMlsaL8qLML3cz4zv41Iz
X-Google-Smtp-Source: ABdhPJzONeuUPApTMkYwvFbbcILylmfJeY2yh2SKaw7NmLK0VfeRDhi2UdjgnlJsCGuc2sUrB8OCqSsNbGKNja1zLzI=
X-Received: by 2002:a17:907:1b11:: with SMTP id mp17mr3810051ejc.1.1622121484390;
 Thu, 27 May 2021 06:18:04 -0700 (PDT)
MIME-Version: 1.0
References: <20210517095513.850-1-xieyongji@bytedance.com> <20210517095513.850-12-xieyongji@bytedance.com>
 <3740c7eb-e457-07f3-5048-917c8606275d@redhat.com> <CACycT3uAqa6azso_8MGreh+quj-JXO1piuGnrV8k2kTfc34N2g@mail.gmail.com>
 <5a68bb7c-fd05-ce02-cd61-8a601055c604@redhat.com> <CACycT3ve7YvKF+F+AnTQoJZMPua+jDvGMs_ox8GQe_=SGdeCMA@mail.gmail.com>
 <ee00efca-b26d-c1be-68d2-f9e34a735515@redhat.com> <CACycT3ufok97cKpk47NjUBTc0QAyfauFUyuFvhWKmuqCGJ7zZw@mail.gmail.com>
 <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
In-Reply-To: <00ded99f-91b6-ba92-5d92-2366b163f129@redhat.com>
From:   Yongji Xie <xieyongji@bytedance.com>
Date:   Thu, 27 May 2021 21:17:54 +0800
Message-ID: <CACycT3uK_Fuade-b8FVYkGCKZnne_UGGbYRFwv7WOH2oKCsXSg@mail.gmail.com>
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

On Thu, May 27, 2021 at 4:41 PM Jason Wang <jasowang@redhat.com> wrote:
>
>
> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=883:34, Yongji Xie =E5=86=99=E9=81=93=
:
> > On Thu, May 27, 2021 at 1:40 PM Jason Wang <jasowang@redhat.com> wrote:
> >>
> >> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=881:08, Yongji Xie =E5=86=99=E9=81=
=93:
> >>> On Thu, May 27, 2021 at 1:00 PM Jason Wang <jasowang@redhat.com> wrot=
e:
> >>>> =E5=9C=A8 2021/5/27 =E4=B8=8B=E5=8D=8812:57, Yongji Xie =E5=86=99=E9=
=81=93:
> >>>>> On Thu, May 27, 2021 at 12:13 PM Jason Wang <jasowang@redhat.com> w=
rote:
> >>>>>> =E5=9C=A8 2021/5/17 =E4=B8=8B=E5=8D=885:55, Xie Yongji =E5=86=99=
=E9=81=93:
> >>>>>>> +
> >>>>>>> +static int vduse_dev_msg_sync(struct vduse_dev *dev,
> >>>>>>> +                           struct vduse_dev_msg *msg)
> >>>>>>> +{
> >>>>>>> +     init_waitqueue_head(&msg->waitq);
> >>>>>>> +     spin_lock(&dev->msg_lock);
> >>>>>>> +     vduse_enqueue_msg(&dev->send_list, msg);
> >>>>>>> +     wake_up(&dev->waitq);
> >>>>>>> +     spin_unlock(&dev->msg_lock);
> >>>>>>> +     wait_event_killable(msg->waitq, msg->completed);
> >>>>>> What happens if the userspace(malicous) doesn't give a response fo=
rever?
> >>>>>>
> >>>>>> It looks like a DOS. If yes, we need to consider a way to fix that=
.
> >>>>>>
> >>>>> How about using wait_event_killable_timeout() instead?
> >>>> Probably, and then we need choose a suitable timeout and more import=
ant,
> >>>> need to report the failure to virtio.
> >>>>
> >>> Makes sense to me. But it looks like some
> >>> vdpa_config_ops/virtio_config_ops such as set_status() didn't have a
> >>> return value.  Now I add a WARN_ON() for the failure. Do you mean we
> >>> need to add some change for virtio core to handle the failure?
> >>
> >> Maybe, but I'm not sure how hard we can do that.
> >>
> > We need to change all virtio device drivers in this way.
>
>
> Probably.
>
>
> >
> >> We had NEEDS_RESET but it looks we don't implement it.
> >>
> > Could it handle the failure of get_feature() and get/set_config()?
>
>
> Looks not:
>
> "
>
> The device SHOULD set DEVICE_NEEDS_RESET when it enters an error state
> that a reset is needed. If DRIVER_OK is set, after it sets
> DEVICE_NEEDS_RESET, the device MUST send a device configuration change
> notification to the driver.
>
> "
>
> This looks implies that NEEDS_RESET may only work after device is
> probed. But in the current design, even the reset() is not reliable.
>
>
> >
> >> Or a rough idea is that maybe need some relaxing to be coupled loosely
> >> with userspace. E.g the device (control path) is implemented in the
> >> kernel but the datapath is implemented in the userspace like TUN/TAP.
> >>
> > I think it can work for most cases. One problem is that the set_config
> > might change the behavior of the data path at runtime, e.g.
> > virtnet_set_mac_address() in the virtio-net driver and
> > cache_type_store() in the virtio-blk driver. Not sure if this path is
> > able to return before the datapath is aware of this change.
>
>
> Good point.
>
> But set_config() should be rare:
>
> E.g in the case of virtio-net with VERSION_1, config space is read only,
> and it was set via control vq.
>
> For block, we can
>
> 1) start from without WCE or
> 2) we add a config change notification to userspace or

I prefer this way. And I think we also need to do similar things for
set/get_vq_state().

Thanks,
Yongji
