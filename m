Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42B44750BB
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 03:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239131AbhLOCGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 21:06:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:40453 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239104AbhLOCGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 21:06:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639534007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QODSBQnZr+XWtKCj7HvbR7L/HGQqXDayYtaMW50HzWc=;
        b=L39con9s2aPwtzzgQxXGsqie4y/Ce6v43E2iR2i+Dq/HZfNoEREc9mTeUomTDmw8+PMqRP
        X2L9SnG+X05EceKrWf5Rn5sGw4iKIzReK2C4yVpFRqXHE5i7A21QQZqqGN1CWzSZtZhU8U
        T9n9bMWA1gmt8vlonVBWHBpP/v8tMSg=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-vBGpSdYfMvuOxoKKKtYdeA-1; Tue, 14 Dec 2021 21:06:45 -0500
X-MC-Unique: vBGpSdYfMvuOxoKKKtYdeA-1
Received: by mail-lf1-f71.google.com with SMTP id u20-20020a056512129400b0040373ffc60bso9218689lfs.15
        for <netdev@vger.kernel.org>; Tue, 14 Dec 2021 18:06:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=QODSBQnZr+XWtKCj7HvbR7L/HGQqXDayYtaMW50HzWc=;
        b=6a+9loDC00X4kiJLFP6DWFYyzZTQitAWh/Oa3YpgVuHlur12oQlRSCLa+iMeuVfp0q
         jvZvHHUMBIS2a0rc0dp+FJB0RmbHTHK7eR4HH1ODWC+sMTZTY3BdZnlEfU6yFScDyOkq
         uNuN0KpqdtEyGbtzHozD0r+lbCDKtRjMyw4Cf16Kaw03VzG1YqanKL3vwO7rjdqU62ID
         eAis8cD76JO7HckHInDZzHeTWCwXq9KMU2OXIXjSsM69mJGZdur7K9TgXMYP1CdY69zC
         l3XjJDmIfgnkSYXNEjU5AIpjdXS7mKcWXq3H/aMeeZ7hquZ7hwx2xdsj5Drmtz+k/s4i
         FOng==
X-Gm-Message-State: AOAM533osRF/yFd3gdMtNo1WxtyX8c0FTaDxs+hpCOey61btnyOU8apn
        czWhrySKtWiEmDF5tQIcnn6sIKZbJS9xyTAzEcv31oEny+rZkZTcj3dzUgR8H7a8PizzXVnGCe4
        WbcYrrAq2Y6wirtTuj9Zqzittc/yrzuD5
X-Received: by 2002:a05:6512:2081:: with SMTP id t1mr7811252lfr.348.1639534004171;
        Tue, 14 Dec 2021 18:06:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzff15JaClCTTbqBtYFgf9IWZCMooVmps6g54UP0yHgNBnA/vqyebmqQsVhhxaD7DRl0w/c2Rq+y/uDDYbGKfI=
X-Received: by 2002:a05:6512:2081:: with SMTP id t1mr7811221lfr.348.1639534003798;
 Tue, 14 Dec 2021 18:06:43 -0800 (PST)
MIME-Version: 1.0
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org> <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org> <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com> <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
In-Reply-To: <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 15 Dec 2021 10:06:32 +0800
Message-ID: <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
> > On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
> >>
> >> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> >>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> >>>> Sorry for reviving this ancient thread. I was kinda lost for the con=
clusion
> >>>> it ended up with. I have the following questions,
> >>>>
> >>>> 1. legacy guest support: from the past conversations it doesn't seem=
 the
> >>>> support will be completely dropped from the table, is my understandi=
ng
> >>>> correct? Actually we're interested in supporting virtio v0.95 guest =
for x86,
> >>>> which is backed by the spec at
> >>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/vi=
rtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmi=
dzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
> >>>> if there's request/need to support wilder legacy virtio versions ear=
lier
> >>>> beyond.
> >>> I personally feel it's less work to add in kernel than try to
> >>> work around it in userspace. Jason feels differently.
> >>> Maybe post the patches and this will prove to Jason it's not
> >>> too terrible?
> >> I suppose if the vdpa vendor does support 0.95 in the datapath and rin=
g
> >> layout level and is limited to x86 only, there should be easy way out.
> > Note a subtle difference: what matters is that guest, not host is x86.
> > Matters for emulators which might reorder memory accesses.
> > I guess this enforcement belongs in QEMU then?
> Right, I mean to get started, the initial guest driver support and the
> corresponding QEMU support for transitional vdpa backend can be limited
> to x86 guest/host only. Since the config space is emulated in QEMU, I
> suppose it's not hard to enforce in QEMU.

It's more than just config space, most devices have headers before the buff=
er.

> QEMU can drive GET_LEGACY,
> GET_ENDIAN et al ioctls in advance to get the capability from the
> individual vendor driver. For that, we need another negotiation protocol
> similar to vhost_user's protocol_features between the vdpa kernel and
> QEMU, way before the guest driver is ever probed and its feature
> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
> from the device, but we can assume weak ordering for legacy at this
> point (x86 only)?

I'm lost here, we have get_features() so:

1) VERSION_1 means the device uses LE if provided, otherwise natvie
2) ORDER_PLATFORM means device requires platform ordering

Any reason for having a new API for this?

>
> >
> >> I
> >> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware =
level
> >> 0.95 support, it seems all the ingredient had been there already dated=
 back
> >> to the DPDK days. The only major thing limiting is in the vDPA softwar=
e that
> >> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFO=
RM for
> >> a few DMA setup ops, which is virtio 1.0 only.
> >>
> >>>> 2. suppose some form of legacy guest support needs to be there, how =
do we
> >>>> deal with the bogus assumption below in vdpa_get_config() in the sho=
rt term?
> >>>> It looks one of the intuitive fix is to move the vdpa_set_features c=
all out
> >>>> of vdpa_get_config() to vdpa_set_config().
> >>>>
> >>>>           /*
> >>>>            * Config accesses aren't supposed to trigger before featu=
res are
> >>>> set.
> >>>>            * If it does happen we assume a legacy guest.
> >>>>            */
> >>>>           if (!vdev->features_valid)
> >>>>                   vdpa_set_features(vdev, 0);
> >>>>           ops->get_config(vdev, offset, buf, len);
> >>>>
> >>>> I can post a patch to fix 2) if there's consensus already reached.
> >>>>
> >>>> Thanks,
> >>>> -Siwei
> >>> I'm not sure how important it is to change that.
> >>> In any case it only affects transitional devices, right?
> >>> Legacy only should not care ...
> >> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against=
 the
> >> modern one in a transitional device model rather than being legacy onl=
y.
> >> That way a v0.95 and v1.0 supporting vdpa parent can support both type=
s of
> >> guests without having to reconfigure. Or are you suggesting limit to l=
egacy
> >> only at the time of vdpa creation would simplify the implementation a =
lot?
> >>
> >> Thanks,
> >> -Siwei
> >
> > I don't know for sure. Take a look at the work Halil was doing
> > to try and support transitional devices with BE guests.
> Hmmm, we can have those endianness ioctls defined but the initial QEMU
> implementation can be started to support x86 guest/host with little
> endian and weak memory ordering first. The real trick is to detect
> legacy guest - I am not sure if it's feasible to shift all the legacy
> detection work to QEMU, or the kernel has to be part of the detection
> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
> effort in QEMU) as well. Let me take a further look and get back.

Michael may think differently but I think doing this in Qemu is much easier=
.

Thanks



>
> Meanwhile, I'll check internally to see if a legacy only model would
> work. Thanks.
>
> Thanks,
> -Siwei
>
>
> >
> >
> >>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
> >>>>> On 2021/3/2 5:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> >>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> >>>>>>> On 2021/3/1 5:34 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote:
> >>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> >>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to =
notify
> >>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
> >>>>>>>>> Well, although I think adding an ioctl is doable, may I
> >>>>>>>>> know what the use
> >>>>>>>>> case there will be for kernel to leverage such info
> >>>>>>>>> directly? Is there a
> >>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
> >>>>>>>>> differentiation (legacy v.s. modern) needed?
> >>>>>>>> BTW a good API could be
> >>>>>>>>
> >>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>>
> >>>>>>>> we did it per vring but maybe that was a mistake ...
> >>>>>>> Actually, I wonder whether it's good time to just not support
> >>>>>>> legacy driver
> >>>>>>> for vDPA. Consider:
> >>>>>>>
> >>>>>>> 1) It's definition is no-normative
> >>>>>>> 2) A lot of budren of codes
> >>>>>>>
> >>>>>>> So qemu can still present the legacy device since the config
> >>>>>>> space or other
> >>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
> >>>>>>> accessed by
> >>>>>>> guest directly. Qemu can do the endian conversion when necessary
> >>>>>>> in this
> >>>>>>> case?
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>> Overall I would be fine with this approach but we need to avoid br=
eaking
> >>>>>> working userspace, qemu releases with vdpa support are out there a=
nd
> >>>>>> seem to work for people. Any changes need to take that into accoun=
t
> >>>>>> and document compatibility concerns.
> >>>>> Agree, let me check.
> >>>>>
> >>>>>
> >>>>>>     I note that any hardware
> >>>>>> implementation is already broken for legacy except on platforms wi=
th
> >>>>>> strong ordering which might be helpful in reducing the scope.
> >>>>> Yes.
> >>>>>
> >>>>> Thanks
> >>>>>
> >>>>>
>

