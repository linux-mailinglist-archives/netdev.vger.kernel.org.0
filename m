Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4354782ED
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:01:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232332AbhLQCBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:01:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33086 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231336AbhLQCBj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 21:01:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639706498;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UOoL/tiJrdh8DCnRGXZiLTXgaxptjGqToFCgAElmGFE=;
        b=OWPcyklQrwtFERGcEUnkjlZBgO5z+NdS5wm3oWHgTetgeVUjS9u+GVbt+dmx7HTewwF03E
        qAT3NauOJEkKiX/SBLLrJIcZ4qEZ7SxXcxI702VkROlxosRKm/bsjzfE+myzz8/wh4OPCZ
        jQwLbRVt/ffHY//6P0S8EZhD2IQVIwI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-98-ONxqmhmfPP-tO9PWmFxZOw-1; Thu, 16 Dec 2021 21:01:37 -0500
X-MC-Unique: ONxqmhmfPP-tO9PWmFxZOw-1
Received: by mail-lf1-f69.google.com with SMTP id e23-20020a196917000000b0041bcbb80798so363609lfc.3
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 18:01:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UOoL/tiJrdh8DCnRGXZiLTXgaxptjGqToFCgAElmGFE=;
        b=GV/r7gyPSTad41GXv3NcF05LCpCeVhnH8ji4qgXxehrrdZuLZpHt9KFMyxxS4hT0Uu
         pCX5/Q2hZxhFzd1GV6TweGDO9v1tZZugr7Ze73llHH8jAZ5bY2FHH9WXCFv3OBee74Vr
         ncTid0Kmtu1ECTJ8RKwH+oqltQHa2K7Vxh+EeU0CCwHfgFECqHSsLQ8BmPmEH+wbk8N+
         IhnEPeVk+8Fur8tAUiUrmli7aTx4Ymk11i2boA21i7SKFJZBjaapsF5vRJ4G/RGgXEaV
         X5d+HiB1C1NkqLBCfEKZJdCnsVSRdFyTxo+0MZsmD+fO7Kq20Hd7vdJQioGaAr7QZ/qw
         ORHQ==
X-Gm-Message-State: AOAM532Hk7A4DaYneqijTOsV1qZXOORtOOOLfRKLT+HtIpILd+ciHJP0
        X+Qo8au1DRdUW9o1roG3mRsy4eoTHaq5KfPY0kKeX+jjW5ppSIza6bIYbPLoTwS2iH37nyR/BbF
        SaKnUprBuIwR4QnzOhlVEiXfhMGHLhG10
X-Received: by 2002:a2e:b169:: with SMTP id a9mr787820ljm.369.1639706495301;
        Thu, 16 Dec 2021 18:01:35 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw4M5eaSbIXZZCVSn+3rPRnevckBi33cEjywnsnOmpZWIhZVrPeWQNna+UNYKdxUWxWx+afzvotitx4E/3juHM=
X-Received: by 2002:a2e:b169:: with SMTP id a9mr787796ljm.369.1639706494934;
 Thu, 16 Dec 2021 18:01:34 -0800 (PST)
MIME-Version: 1.0
References: <3ff5fd23-1db0-2f95-4cf9-711ef403fb62@oracle.com>
 <20210224000057-mutt-send-email-mst@kernel.org> <52836a63-4e00-ff58-50fb-9f450ce968d7@oracle.com>
 <20210228163031-mutt-send-email-mst@kernel.org> <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com> <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com> <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com> <CACGkMEskmqv5bLyqEgXEN76Eo=NaPXd8ycMR_rs5_-PWhRkTFQ@mail.gmail.com>
 <b0f7fe98-3d60-f6da-51c6-cfa5e7562c44@oracle.com>
In-Reply-To: <b0f7fe98-3d60-f6da-51c6-cfa5e7562c44@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 17 Dec 2021 10:01:23 +0800
Message-ID: <CACGkMEszKB3Cdk4H-1De5=ZQ=fp47vPntS-ww9_V0tC26d8bKw@mail.gmail.com>
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

On Fri, Dec 17, 2021 at 9:08 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 12/15/2021 7:43 PM, Jason Wang wrote:
> > On Thu, Dec 16, 2021 at 4:52 AM Si-Wei Liu <si-wei.liu@oracle.com> wrot=
e:
> >>
> >>
> >> On 12/14/2021 6:06 PM, Jason Wang wrote:
> >>> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wr=
ote:
> >>>>
> >>>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
> >>>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
> >>>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> >>>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> >>>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the=
 conclusion
> >>>>>>>> it ended up with. I have the following questions,
> >>>>>>>>
> >>>>>>>> 1. legacy guest support: from the past conversations it doesn't =
seem the
> >>>>>>>> support will be completely dropped from the table, is my underst=
anding
> >>>>>>>> correct? Actually we're interested in supporting virtio v0.95 gu=
est for x86,
> >>>>>>>> which is backed by the spec at
> >>>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spe=
c/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0=
WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
> >>>>>>>> if there's request/need to support wilder legacy virtio versions=
 earlier
> >>>>>>>> beyond.
> >>>>>>> I personally feel it's less work to add in kernel than try to
> >>>>>>> work around it in userspace. Jason feels differently.
> >>>>>>> Maybe post the patches and this will prove to Jason it's not
> >>>>>>> too terrible?
> >>>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and=
 ring
> >>>>>> layout level and is limited to x86 only, there should be easy way =
out.
> >>>>> Note a subtle difference: what matters is that guest, not host is x=
86.
> >>>>> Matters for emulators which might reorder memory accesses.
> >>>>> I guess this enforcement belongs in QEMU then?
> >>>> Right, I mean to get started, the initial guest driver support and t=
he
> >>>> corresponding QEMU support for transitional vdpa backend can be limi=
ted
> >>>> to x86 guest/host only. Since the config space is emulated in QEMU, =
I
> >>>> suppose it's not hard to enforce in QEMU.
> >>> It's more than just config space, most devices have headers before th=
e buffer.
> >> The ordering in datapath (data VQs) would have to rely on vendor's
> >> support. Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w
> >> vendor nowadays can/should well support the case when ORDER_PLATFORM i=
s
> >> not acked by the driver (actually this feature is filtered out by the
> >> QEMU vhost-vdpa driver today), even with v1.0 spec conforming and mode=
rn
> >> only vDPA device.
> > That's a bug that needs to be fixed.
> >
> >> The control VQ is implemented in software in the
> >> kernel, which can be easily accommodated/fixed when needed.
> >>
> >>>> QEMU can drive GET_LEGACY,
> >>>> GET_ENDIAN et al ioctls in advance to get the capability from the
> >>>> individual vendor driver. For that, we need another negotiation prot=
ocol
> >>>> similar to vhost_user's protocol_features between the vdpa kernel an=
d
> >>>> QEMU, way before the guest driver is ever probed and its feature
> >>>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
> >>>> from the device, but we can assume weak ordering for legacy at this
> >>>> point (x86 only)?
> >>> I'm lost here, we have get_features() so:
> >> I assume here you refer to get_device_features() that Eli just changed
> >> the name.
> >>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
> >>> 2) ORDER_PLATFORM means device requires platform ordering
> >>>
> >>> Any reason for having a new API for this?
> >> Are you going to enforce all vDPA hardware vendors to support the
> >> transitional model for legacy guest? meaning guest not acknowledging
> >> VERSION_1 would use the legacy interfaces captured in the spec section
> >> 7.4 (regarding ring layout, native endianness, message framing, vq
> >> alignment of 4096, 32bit feature, no features_ok bit in status, IO por=
t
> >> interface i.e. all the things) instead? Noted we don't yet have a
> >> set_device_features() that allows the vdpa device to tell whether it i=
s
> >> operating in transitional or modern-only mode. For software virtio, al=
l
> >> support for the legacy part in a transitional model has been built up
> >> there already, however, it's not easy for vDPA vendors to implement al=
l
> >> the requirements for an all-or-nothing legacy guest support (big endia=
n
> >> guest for example). To these vendors, the legacy support within a
> >> transitional model is more of feature to them and it's best to leave
> >> some flexibility for them to implement partial support for legacy. Tha=
t
> >> in turn calls out the need for a vhost-user protocol feature like
> >> negotiation API that can prohibit those unsupported guest setups to as
> >> early as backend_init before launching the VM.
> >>
> >>
> >>>>>> I
> >>>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmw=
are level
> >>>>>> 0.95 support, it seems all the ingredient had been there already d=
ated back
> >>>>>> to the DPDK days. The only major thing limiting is in the vDPA sof=
tware that
> >>>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PL=
ATFORM for
> >>>>>> a few DMA setup ops, which is virtio 1.0 only.
> >>>>>>
> >>>>>>>> 2. suppose some form of legacy guest support needs to be there, =
how do we
> >>>>>>>> deal with the bogus assumption below in vdpa_get_config() in the=
 short term?
> >>>>>>>> It looks one of the intuitive fix is to move the vdpa_set_featur=
es call out
> >>>>>>>> of vdpa_get_config() to vdpa_set_config().
> >>>>>>>>
> >>>>>>>>             /*
> >>>>>>>>              * Config accesses aren't supposed to trigger before=
 features are
> >>>>>>>> set.
> >>>>>>>>              * If it does happen we assume a legacy guest.
> >>>>>>>>              */
> >>>>>>>>             if (!vdev->features_valid)
> >>>>>>>>                     vdpa_set_features(vdev, 0);
> >>>>>>>>             ops->get_config(vdev, offset, buf, len);
> >>>>>>>>
> >>>>>>>> I can post a patch to fix 2) if there's consensus already reache=
d.
> >>>>>>>>
> >>>>>>>> Thanks,
> >>>>>>>> -Siwei
> >>>>>>> I'm not sure how important it is to change that.
> >>>>>>> In any case it only affects transitional devices, right?
> >>>>>>> Legacy only should not care ...
> >>>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) aga=
inst the
> >>>>>> modern one in a transitional device model rather than being legacy=
 only.
> >>>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both =
types of
> >>>>>> guests without having to reconfigure. Or are you suggesting limit =
to legacy
> >>>>>> only at the time of vdpa creation would simplify the implementatio=
n a lot?
> >>>>>>
> >>>>>> Thanks,
> >>>>>> -Siwei
> >>>>> I don't know for sure. Take a look at the work Halil was doing
> >>>>> to try and support transitional devices with BE guests.
> >>>> Hmmm, we can have those endianness ioctls defined but the initial QE=
MU
> >>>> implementation can be started to support x86 guest/host with little
> >>>> endian and weak memory ordering first. The real trick is to detect
> >>>> legacy guest - I am not sure if it's feasible to shift all the legac=
y
> >>>> detection work to QEMU, or the kernel has to be part of the detectio=
n
> >>>> (e.g. the kick before DRIVER_OK thing we have to duplicate the track=
ing
> >>>> effort in QEMU) as well. Let me take a further look and get back.
> >>> Michael may think differently but I think doing this in Qemu is much =
easier.
> >> I think the key is whether we position emulating legacy interfaces in
> >> QEMU doing translation on top of a v1.0 modern-only device in the
> >> kernel, or we allow vdpa core (or you can say vhost-vdpa) and vendor
> >> driver to support a transitional model in the kernel that is able to
> >> work for both v0.95 and v1.0 drivers, with some slight aid from QEMU f=
or
> >> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess f=
or
> >> the former we still rely on vendor for a performant data vqs
> >> implementation, leaving the question to what it may end up eventually =
in
> >> the kernel is effectively the latter).
> > I think we can do the legacy interface emulation on top of the shadow
> > VQ. And we know it works for sure. But I agree, it would be much
> > easier if we depend on the vendor to implement a transitional device.
> First I am not sure if there's a convincing case for users to deploy
> vDPA with shadow (data) VQ against the pure software based backend.
> Please enlighten me if there is.

The problem is shadow VQ is the only solution that can works for all the ca=
ses.

>
> For us, the point to deploy vDPA for legacy guest is the acceleration
> (what "A" stands for in "vDPA") part of it so that we can leverage the
> hardware potential if at all possible. Not sure how the shadow VQ
> implementation can easily deal with datapath acceleration without losing
> too much performance?

It's not easy, shadow VQ will lose performance for sure.

>
> > So assuming we depend on the vendor, I don't see anything that is
> > strictly needed in the kernel, the kick or config access before
> > DRIVER_OK can all be handled easily in Qemu unless I miss something.
> Right, that's what I think too it's not quite a lot of work in the
> kernel if vendor device offers the aid/support for transitional. The
> kernel only provides the abstraction of device model (transitional or
> modern-only), while vendor driver may implement early platform feature
> discovery and apply legacy specific quirks (unsupported endianness,
> mismatched page size, unsupported host memory ordering model) that the
> device can't adapt to. I don't say we have to depend on the vendor, but
> the point is that we must assume fully spec compliant transitional
> support (the datapath in particular) from the vendor to get started, as
> I guess it's probably the main motivation for users to deploy it -
> acceleration of legacy guest workload without exhausting host computing
> resource. Even if we get started with shadow VQ to mediate and translate
> the datapath, eventually it may evolve towards leveraging datapath
> offload to hardware if acceleration is the only convincing use case for
> legacy support.

Yes, so as discussed, I don't object the idea, kernel patches are more
than welcomed.

Thanks

>
> Thanks,
> -Siwei
> > The only value to do that in the kernel is that it can work for
> > virtio-vdpa, but modern only virito-vpda is sufficient; we don't need
> > any legacy stuff for that.
> >
> > Thanks
> >
> >> Thanks,
> >> -Siwei
> >>
> >>> Thanks
> >>>
> >>>
> >>>
> >>>> Meanwhile, I'll check internally to see if a legacy only model would
> >>>> work. Thanks.
> >>>>
> >>>> Thanks,
> >>>> -Siwei
> >>>>
> >>>>
> >>>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
> >>>>>>>>> On 2021/3/2 5:47 =E4=B8=8B=E5=8D=88, Michael S. Tsirkin wrote:
> >>>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> >>>>>>>>>>> On 2021/3/1 5:34 =E4=B8=8A=E5=8D=88, Michael S. Tsirkin wrote=
:
> >>>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> >>>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl=
 to notify
> >>>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
> >>>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
> >>>>>>>>>>>>> know what the use
> >>>>>>>>>>>>> case there will be for kernel to leverage such info
> >>>>>>>>>>>>> directly? Is there a
> >>>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's in=
deed
> >>>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
> >>>>>>>>>>>> BTW a good API could be
> >>>>>>>>>>>>
> >>>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> >>>>>>>>>>>>
> >>>>>>>>>>>> we did it per vring but maybe that was a mistake ...
> >>>>>>>>>>> Actually, I wonder whether it's good time to just not support
> >>>>>>>>>>> legacy driver
> >>>>>>>>>>> for vDPA. Consider:
> >>>>>>>>>>>
> >>>>>>>>>>> 1) It's definition is no-normative
> >>>>>>>>>>> 2) A lot of budren of codes
> >>>>>>>>>>>
> >>>>>>>>>>> So qemu can still present the legacy device since the config
> >>>>>>>>>>> space or other
> >>>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
> >>>>>>>>>>> accessed by
> >>>>>>>>>>> guest directly. Qemu can do the endian conversion when necess=
ary
> >>>>>>>>>>> in this
> >>>>>>>>>>> case?
> >>>>>>>>>>>
> >>>>>>>>>>> Thanks
> >>>>>>>>>>>
> >>>>>>>>>> Overall I would be fine with this approach but we need to avoi=
d breaking
> >>>>>>>>>> working userspace, qemu releases with vdpa support are out the=
re and
> >>>>>>>>>> seem to work for people. Any changes need to take that into ac=
count
> >>>>>>>>>> and document compatibility concerns.
> >>>>>>>>> Agree, let me check.
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>>       I note that any hardware
> >>>>>>>>>> implementation is already broken for legacy except on platform=
s with
> >>>>>>>>>> strong ordering which might be helpful in reducing the scope.
> >>>>>>>>> Yes.
> >>>>>>>>>
> >>>>>>>>> Thanks
> >>>>>>>>>
> >>>>>>>>>
>

