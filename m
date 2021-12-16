Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CC6A476857
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 03:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhLPCx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 21:53:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36256 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230243AbhLPCx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 21:53:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639623206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CCc5Lvmtn3H7qqXmc5mlvmPAoLf54qIbgbfcsPg1q3E=;
        b=ElT+z7hUy3YTls1YbZv5wuSpUK3Rias5ph/kjxnSNI5Dm/OSVns1J7UZZjPV8awRsl6Z3V
        G3A9a5XoL5+IX6TIumBQp4ktk583q03OjMeA6TO6nofPr6lFUyEjRF04igLhX2R5tA/Mq4
        yGOGmr7TThACDtCR2MVmQtDyycF7YC0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-toiiWMnDOwKswA1d5Iouwg-1; Wed, 15 Dec 2021 21:53:25 -0500
X-MC-Unique: toiiWMnDOwKswA1d5Iouwg-1
Received: by mail-lj1-f199.google.com with SMTP id p21-20020a2e9ad5000000b00219ee503efeso7867471ljj.14
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 18:53:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CCc5Lvmtn3H7qqXmc5mlvmPAoLf54qIbgbfcsPg1q3E=;
        b=i2684cnBoQISYaKnvVBPpBWPLR7deCvG0J/n6tzAc7+eSNS7Z4rGjKAZTcl586yhM/
         RZZ4Y2e/ERsTc0YyRiIsfkpRkZ+mcGoAXOZiS+oft0TIbzil9Jui0iOK8E2XCp5F52ZP
         5Eo2gFqVQm3TkMGxhSIh1r0NTvDaP8F3skdxYALRcJKSwB/seDZll7roRe+jLla6sRDC
         SuFHSIyMsDCNzRxmsd1Hj86T0LcTF0/ohImZiz23imge/je6dsPfuaJHwuQB19aVvB4B
         d86NJVlMdOEVwM3Qe++Pzx0O5NfniG3UZlSQpgRV9fd5RK8BvwImRLeJkYActDr6V2g4
         qwfA==
X-Gm-Message-State: AOAM531FxjxzMDtaPxyq4T7/jyXZu9SpAH6JRRWzuSFKlhN8dqej+DuJ
        WfsYIRHAafJ+WxEPf7bP/qxwCZwV5tphuUVJXj+IGJyg1SQP/MJbquaK9s0y2Vah33yLn6T5BHt
        yTdxI3bY4ToWOpsOCgGXlGfpj2gv4h8s3
X-Received: by 2002:a05:6512:3987:: with SMTP id j7mr12474567lfu.199.1639623204083;
        Wed, 15 Dec 2021 18:53:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLAutD5nzZlBElDVCzFHJ96E3FPyrYoYz9s2kXrLCpo/2Ls7wuhGFhK7b2w/2ew5RDmh89KNXPnJkqC2JTeU8=
X-Received: by 2002:a05:6512:3987:: with SMTP id j7mr12474544lfu.199.1639623203699;
 Wed, 15 Dec 2021 18:53:23 -0800 (PST)
MIME-Version: 1.0
References: <2cb51a6d-afa0-7cd1-d6f2-6b153186eaca@redhat.com>
 <20210302043419-mutt-send-email-mst@kernel.org> <178f8ea7-cebd-0e81-3dc7-10a058d22c07@redhat.com>
 <c9a0932f-a6d7-a9df-38ba-97e50f70c2b2@oracle.com> <20211212042311-mutt-send-email-mst@kernel.org>
 <ba9df703-29af-98a9-c554-f303ff045398@oracle.com> <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com> <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com> <20211215162917-mutt-send-email-mst@kernel.org>
 <71d2a69c-94a7-76b5-2971-570026760bf0@oracle.com>
In-Reply-To: <71d2a69c-94a7-76b5-2971-570026760bf0@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Thu, 16 Dec 2021 10:53:12 +0800
Message-ID: <CACGkMEsoMpSLX=YZmsgRQVs7+9dwon7FCDK+VOL6Nx2FYK=_pA@mail.gmail.com>
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

On Thu, Dec 16, 2021 at 10:02 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 12/15/2021 1:33 PM, Michael S. Tsirkin wrote:
> > On Wed, Dec 15, 2021 at 12:52:20PM -0800, Si-Wei Liu wrote:
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
> >> The ordering in datapath (data VQs) would have to rely on vendor's sup=
port.
> >> Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w vendor now=
adays
> >> can/should well support the case when ORDER_PLATFORM is not acked by t=
he
> >> driver (actually this feature is filtered out by the QEMU vhost-vdpa d=
river
> >> today), even with v1.0 spec conforming and modern only vDPA device. Th=
e
> >> control VQ is implemented in software in the kernel, which can be easi=
ly
> >> accommodated/fixed when needed.
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
> >> I assume here you refer to get_device_features() that Eli just changed=
 the
> >> name.
> >>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
> >>> 2) ORDER_PLATFORM means device requires platform ordering
> >>>
> >>> Any reason for having a new API for this?
> >> Are you going to enforce all vDPA hardware vendors to support the
> >> transitional model for legacy guest?

Do we really have other choices?

I suspect the legacy device is never implemented by any vendor:

1) no virtio way to detect host endian
2) bypass IOMMU with translated requests
3) PIO port

Yes we have enp_vdpa, but it's more like a "transitional device" for
legacy only guests.

> meaning guest not acknowledging
> >> VERSION_1 would use the legacy interfaces captured in the spec section=
 7.4
> >> (regarding ring layout, native endianness, message framing, vq alignme=
nt of
> >> 4096, 32bit feature, no features_ok bit in status, IO port interface i=
.e.
> >> all the things) instead?

Note that we only care about the datapath, control path is mediated anyhow.

So feature_ok and IO port isn't an issue. The rest looks like a must
for the hardware.

> Noted we don't yet have a set_device_features()
> >> that allows the vdpa device to tell whether it is operating in transit=
ional
> >> or modern-only mode.

So the device feature should be provisioned via the netlink protocol.
And what we want is not "set_device_feature()" but
"set_device_mandatory_feautre()", then the parent can choose to fail
the negotiation when VERSION_1 is not negotiated. Qemu then knows for
sure it talks to a transitional device or modern only device.

Thanks

> For software virtio, all support for the legacy part in
> >> a transitional model has been built up there already, however, it's no=
t easy
> >> for vDPA vendors to implement all the requirements for an all-or-nothi=
ng
> >> legacy guest support (big endian guest for example). To these vendors,=
 the
> >> legacy support within a transitional model is more of feature to them =
and
> >> it's best to leave some flexibility for them to implement partial supp=
ort
> >> for legacy. That in turn calls out the need for a vhost-user protocol
> >> feature like negotiation API that can prohibit those unsupported guest
> >> setups to as early as backend_init before launching the VM.
> > Right. Of note is the fact that it's a spec bug which I
> > hope yet to fix, though due to existing guest code the
> > fix won't be complete.
> I thought at one point you pointed out to me that the spec does allow
> config space read before claiming features_ok, and only config write
> before features_ok is prohibited. I haven't read up the full thread of
> Halil's VERSION_1 for transitional big endian device yet, but what is
> the spec bug you hope to fix?
>
> >
> > WRT ioctls, One thing we can do though is abuse set_features
> > where it's called by QEMU early on with just the VERSION_1
> > bit set, to distinguish between legacy and modern
> > interface. This before config space accesses and FEATURES_OK.
> >
> > Halil has been working on this, pls take a look and maybe help him out.
> Interesting thread, am reading now and see how I may leverage or help the=
re.
>
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
> >> I think the key is whether we position emulating legacy interfaces in =
QEMU
> >> doing translation on top of a v1.0 modern-only device in the kernel, o=
r we
> >> allow vdpa core (or you can say vhost-vdpa) and vendor driver to suppo=
rt a
> >> transitional model in the kernel that is able to work for both v0.95 a=
nd
> >> v1.0 drivers, with some slight aid from QEMU for
> >> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess f=
or the
> >> former we still rely on vendor for a performant data vqs implementatio=
n,
> >> leaving the question to what it may end up eventually in the kernel is
> >> effectively the latter).
> >>
> >> Thanks,
> >> -Siwei
> >
> > My suggestion is post the kernel patches, and we can evaluate
> > how much work they are.
> Thanks for the feedback. I will take some read then get back, probably
> after the winter break. Stay tuned.
>
> Thanks,
> -Siwei
>
> >
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

