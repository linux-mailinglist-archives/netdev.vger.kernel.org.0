Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C8E4768CD
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 04:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233414AbhLPDnx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 22:43:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:30473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233410AbhLPDnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 22:43:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639626232;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gLwtJu4nRIUgNi4HbPSakOV1hL/CKlCKRYb0XCXtOAg=;
        b=CLECPY1G5mxfx/FKSohdM4gIkN0Em8mhVPkMrUmrQMfSYNLJIAHpgR3dfZpcSwAxzyUXnC
        o3mdX8pINCWSFWxNKK2vq14VbF0+01P8ddVVFQv7PILipuBS6HvsXscWhosf/2V84jhu7v
        sQmMxhzFeqTOd/Qg2mk0OPH5YDPca+o=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-163-xXUGClwFPamLFLvdfy4LEw-1; Wed, 15 Dec 2021 22:43:50 -0500
X-MC-Unique: xXUGClwFPamLFLvdfy4LEw-1
Received: by mail-lj1-f198.google.com with SMTP id h18-20020a05651c159200b0021cf7c089d0so7963953ljq.21
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 19:43:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=gLwtJu4nRIUgNi4HbPSakOV1hL/CKlCKRYb0XCXtOAg=;
        b=4bH1yJNWeBXuhMJZ33cqInR90g1iFRN2QdpaGoQ/xzqb3zbkMglchOjn0g74YH4NdB
         Kg16tyK/Bcoz/zeoBBrh6uuzlhyqvhH4hbE2li5TRhqRvjkmW0dSLSbzHOqx8me0U4/B
         Nba0Y29Yyce+pfLDL1hJYldxUuypO+naU8plJx+kApMkUi7RAOdFcAkEJhjjhIGkgC6O
         lu44tOV/zzGMZbZxAw1tkRAaOpKNhC33kH1Jp9C5AgyMhzn3ye+heGQ/SrKfJLufxrAi
         OihDVrk10mDGjkR+sA/ku7XVaut6Os8GH6pZ/8XQ1R2p2X2O8p/ggxUhjuNICHaDvc/k
         bQCQ==
X-Gm-Message-State: AOAM532MJjDaJt2mN5MT1l1Z50LyVdwRtm/YasN24mKVRUlEwBB/J4FI
        onq7nI0mn5P50//WuWqXEuVafrDGAALhSbyDtki6l/SCx4UZhrrBRoU6BQ0vr9E/Q+4cHl1Uw56
        P1CyZHW2ymeAaEiTCAKCfjKxpWNeeQMsy
X-Received: by 2002:a2e:b88d:: with SMTP id r13mr13561072ljp.362.1639626228850;
        Wed, 15 Dec 2021 19:43:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyPKF0Q8HQ0g5k7Exb/LJ9u7HFKNaAfAkpMoaBMcmqpNSDCu64M1C28Sr37fQm6ThtUVMO6T+5XC7J/JQ3edlo=
X-Received: by 2002:a2e:b88d:: with SMTP id r13mr13561057ljp.362.1639626228534;
 Wed, 15 Dec 2021 19:43:48 -0800 (PST)
MIME-Version: 1.0
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org> <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org> <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com> <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com> <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
In-Reply-To: <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 16 Dec 2021 11:43:37 +0800
Message-ID: <CACGkMEskmqv5bLyqEgXEN76Eo=NaPXd8ycMR_rs5_-PWhRkTFQ@mail.gmail.com>
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

On Thu, Dec 16, 2021 at 4:52 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 12/14/2021 6:06 PM, Jason Wang wrote:
> > On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrot=
e:
> >>
> >>
> >> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
> >>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
> >>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> >>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> >>>>>> Sorry for reviving this ancient thread. I was kinda lost for the c=
onclusion
> >>>>>> it ended up with. I have the following questions,
> >>>>>>
> >>>>>> 1. legacy guest support: from the past conversations it doesn't se=
em the
> >>>>>> support will be completely dropped from the table, is my understan=
ding
> >>>>>> correct? Actually we're interested in supporting virtio v0.95 gues=
t for x86,
> >>>>>> which is backed by the spec at
> >>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/=
virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WY=
midzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
> >>>>>> if there's request/need to support wilder legacy virtio versions e=
arlier
> >>>>>> beyond.
> >>>>> I personally feel it's less work to add in kernel than try to
> >>>>> work around it in userspace. Jason feels differently.
> >>>>> Maybe post the patches and this will prove to Jason it's not
> >>>>> too terrible?
> >>>> I suppose if the vdpa vendor does support 0.95 in the datapath and r=
ing
> >>>> layout level and is limited to x86 only, there should be easy way ou=
t.
> >>> Note a subtle difference: what matters is that guest, not host is x86=
.
> >>> Matters for emulators which might reorder memory accesses.
> >>> I guess this enforcement belongs in QEMU then?
> >> Right, I mean to get started, the initial guest driver support and the
> >> corresponding QEMU support for transitional vdpa backend can be limite=
d
> >> to x86 guest/host only. Since the config space is emulated in QEMU, I
> >> suppose it's not hard to enforce in QEMU.
> > It's more than just config space, most devices have headers before the =
buffer.
> The ordering in datapath (data VQs) would have to rely on vendor's
> support. Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w
> vendor nowadays can/should well support the case when ORDER_PLATFORM is
> not acked by the driver (actually this feature is filtered out by the
> QEMU vhost-vdpa driver today), even with v1.0 spec conforming and modern
> only vDPA device.

That's a bug that needs to be fixed.

> The control VQ is implemented in software in the
> kernel, which can be easily accommodated/fixed when needed.
>
> >
> >> QEMU can drive GET_LEGACY,
> >> GET_ENDIAN et al ioctls in advance to get the capability from the
> >> individual vendor driver. For that, we need another negotiation protoc=
ol
> >> similar to vhost_user's protocol_features between the vdpa kernel and
> >> QEMU, way before the guest driver is ever probed and its feature
> >> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
> >> from the device, but we can assume weak ordering for legacy at this
> >> point (x86 only)?
> > I'm lost here, we have get_features() so:
> I assume here you refer to get_device_features() that Eli just changed
> the name.
> >
> > 1) VERSION_1 means the device uses LE if provided, otherwise natvie
> > 2) ORDER_PLATFORM means device requires platform ordering
> >
> > Any reason for having a new API for this?
> Are you going to enforce all vDPA hardware vendors to support the
> transitional model for legacy guest? meaning guest not acknowledging
> VERSION_1 would use the legacy interfaces captured in the spec section
> 7.4 (regarding ring layout, native endianness, message framing, vq
> alignment of 4096, 32bit feature, no features_ok bit in status, IO port
> interface i.e. all the things) instead? Noted we don't yet have a
> set_device_features() that allows the vdpa device to tell whether it is
> operating in transitional or modern-only mode. For software virtio, all
> support for the legacy part in a transitional model has been built up
> there already, however, it's not easy for vDPA vendors to implement all
> the requirements for an all-or-nothing legacy guest support (big endian
> guest for example). To these vendors, the legacy support within a
> transitional model is more of feature to them and it's best to leave
> some flexibility for them to implement partial support for legacy. That
> in turn calls out the need for a vhost-user protocol feature like
> negotiation API that can prohibit those unsupported guest setups to as
> early as backend_init before launching the VM.
>
>
> >
> >>>> I
> >>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmwar=
e level
> >>>> 0.95 support, it seems all the ingredient had been there already dat=
ed back
> >>>> to the DPDK days. The only major thing limiting is in the vDPA softw=
are that
> >>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLAT=
FORM for
> >>>> a few DMA setup ops, which is virtio 1.0 only.
> >>>>
> >>>>>> 2. suppose some form of legacy guest support needs to be there, ho=
w do we
> >>>>>> deal with the bogus assumption below in vdpa_get_config() in the s=
hort term?
> >>>>>> It looks one of the intuitive fix is to move the vdpa_set_features=
 call out
> >>>>>> of vdpa_get_config() to vdpa_set_config().
> >>>>>>
> >>>>>>            /*
> >>>>>>             * Config accesses aren't supposed to trigger before fe=
atures are
> >>>>>> set.
> >>>>>>             * If it does happen we assume a legacy guest.
> >>>>>>             */
> >>>>>>            if (!vdev->features_valid)
> >>>>>>                    vdpa_set_features(vdev, 0);
> >>>>>>            ops->get_config(vdev, offset, buf, len);
> >>>>>>
> >>>>>> I can post a patch to fix 2) if there's consensus already reached.
> >>>>>>
> >>>>>> Thanks,
> >>>>>> -Siwei
> >>>>> I'm not sure how important it is to change that.
> >>>>> In any case it only affects transitional devices, right?
> >>>>> Legacy only should not care ...
> >>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) again=
st the
> >>>> modern one in a transitional device model rather than being legacy o=
nly.
> >>>> That way a v0.95 and v1.0 supporting vdpa parent can support both ty=
pes of
> >>>> guests without having to reconfigure. Or are you suggesting limit to=
 legacy
> >>>> only at the time of vdpa creation would simplify the implementation =
a lot?
> >>>>
> >>>> Thanks,
> >>>> -Siwei
> >>> I don't know for sure. Take a look at the work Halil was doing
> >>> to try and support transitional devices with BE guests.
> >> Hmmm, we can have those endianness ioctls defined but the initial QEMU
> >> implementation can be started to support x86 guest/host with little
> >> endian and weak memory ordering first. The real trick is to detect
> >> legacy guest - I am not sure if it's feasible to shift all the legacy
> >> detection work to QEMU, or the kernel has to be part of the detection
> >> (e.g. the kick before DRIVER_OK thing we have to duplicate the trackin=
g
> >> effort in QEMU) as well. Let me take a further look and get back.
> > Michael may think differently but I think doing this in Qemu is much ea=
sier.
> I think the key is whether we position emulating legacy interfaces in
> QEMU doing translation on top of a v1.0 modern-only device in the
> kernel, or we allow vdpa core (or you can say vhost-vdpa) and vendor
> driver to support a transitional model in the kernel that is able to
> work for both v0.95 and v1.0 drivers, with some slight aid from QEMU for
> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for
> the former we still rely on vendor for a performant data vqs
> implementation, leaving the question to what it may end up eventually in
> the kernel is effectively the latter).

I think we can do the legacy interface emulation on top of the shadow
VQ. And we know it works for sure. But I agree, it would be much
easier if we depend on the vendor to implement a transitional device.

So assuming we depend on the vendor, I don't see anything that is
strictly needed in the kernel, the kick or config access before
DRIVER_OK can all be handled easily in Qemu unless I miss something.
The only value to do that in the kernel is that it can work for
virtio-vdpa, but modern only virito-vpda is sufficient; we don't need
any legacy stuff for that.

Thanks

>
> Thanks,
> -Siwei
>
> >
> > Thanks
> >
> >
> >
> >> Meanwhile, I'll check internally to see if a legacy only model would
> >> work. Thanks.
> >>
> >> Thanks,
> >> -Siwei
> >>
> >>
> >>>
> >>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
> >>>>>>> On 2021/3/2 5:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> >>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> >>>>>>>>> On 2021/3/1 5:34 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote:
> >>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> >>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl t=
o notify
> >>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
> >>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
> >>>>>>>>>>> know what the use
> >>>>>>>>>>> case there will be for kernel to leverage such info
> >>>>>>>>>>> directly? Is there a
> >>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's inde=
ed
> >>>>>>>>>>> differentiation (legacy v.s. modern) needed?
> >>>>>>>>>> BTW a good API could be
> >>>>>>>>>>
> >>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>>>>
> >>>>>>>>>> we did it per vring but maybe that was a mistake ...
> >>>>>>>>> Actually, I wonder whether it's good time to just not support
> >>>>>>>>> legacy driver
> >>>>>>>>> for vDPA. Consider:
> >>>>>>>>>
> >>>>>>>>> 1) It's definition is no-normative
> >>>>>>>>> 2) A lot of budren of codes
> >>>>>>>>>
> >>>>>>>>> So qemu can still present the legacy device since the config
> >>>>>>>>> space or other
> >>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
> >>>>>>>>> accessed by
> >>>>>>>>> guest directly. Qemu can do the endian conversion when necessar=
y
> >>>>>>>>> in this
> >>>>>>>>> case?
> >>>>>>>>>
> >>>>>>>>> Thanks
> >>>>>>>>>
> >>>>>>>> Overall I would be fine with this approach but we need to avoid =
breaking
> >>>>>>>> working userspace, qemu releases with vdpa support are out there=
 and
> >>>>>>>> seem to work for people. Any changes need to take that into acco=
unt
> >>>>>>>> and document compatibility concerns.
> >>>>>>> Agree, let me check.
> >>>>>>>
> >>>>>>>
> >>>>>>>>      I note that any hardware
> >>>>>>>> implementation is already broken for legacy except on platforms =
with
> >>>>>>>> strong ordering which might be helpful in reducing the scope.
> >>>>>>> Yes.
> >>>>>>>
> >>>>>>> Thanks
> >>>>>>>
> >>>>>>>
>

