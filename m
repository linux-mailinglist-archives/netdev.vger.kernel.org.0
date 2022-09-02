Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7DBB5AA794
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 08:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235348AbiIBGDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 02:03:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235373AbiIBGDk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 02:03:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5E0ACA04
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 23:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662098617;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAlqNs0IzgVz+dS/NPctX61C/qoNMD0ryJ1OLO2dID0=;
        b=ZV+1EctYhovlFwDp8L7grCha3qDGIBL+oh5nb1uP3z64jltuiwcOPhYcURN2RWvS3GQjVc
        AfW0mpm4/Mlo8PHLCBOxjTwDREzGOitsu2RM9T3Fc3owJaRzorLqEje1xMiG758l3Ij8HP
        dF2HR1i2hZaqp862OW18qYBXEdGaroU=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-573-Tfqw45_iP7ioiHSAj_HvQQ-1; Fri, 02 Sep 2022 02:03:34 -0400
X-MC-Unique: Tfqw45_iP7ioiHSAj_HvQQ-1
Received: by mail-vs1-f69.google.com with SMTP id q16-20020a056102205000b00390e8001d29so324715vsr.9
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 23:03:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jAlqNs0IzgVz+dS/NPctX61C/qoNMD0ryJ1OLO2dID0=;
        b=xAqj1g/SH5iDWHMb+bkZrXAqxnjLlwHVFdH85Ao9h1T55ah1QFeOgLjwlZdtgAW8BS
         cWTFITM4qULfk2dFrlsFJVB0N2JcTD54SeQbDDFsn+DsfQxPl9fRcmUzisoLyg7R4Ppu
         NG4qtvOezjyNTEHeHz9I3eA/deBnlikaMM6D+e34Us9FPzBLY//gaH/5U2UMl8LGzfwx
         LuFJh3HZhniCPK2blN7PLStI1vU68WBjhnMa8Dd2621dIBGcPURfjNhArtKWsogTuqC8
         Jw5Curk+hHzWNWTCLhv/ZI6gugFYKcZkLHL1+OCX7SshtgdNxLeTGgaPS1qb1vGIRqeo
         ko7Q==
X-Gm-Message-State: ACgBeo2a4VFVzS6+wwunkXrG9hEgMBullQYeVhkiMA2ihNXBktKfYz4x
        s+/68TJgfB+yKlrlhEx0sw1OltN82zQZquMargmWVGHqb+guDIP2UAmTNHieZBi4ltqH4lv7MAC
        vrk3/xg6h9Z5L37+Q/PvL0OW0dElsNfKE
X-Received: by 2002:a05:6102:3e1f:b0:388:9dab:9bef with SMTP id j31-20020a0561023e1f00b003889dab9befmr9260974vsv.38.1662098613636;
        Thu, 01 Sep 2022 23:03:33 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6mLow5MQH3dNljOeR9uylALXt3Sva7K2WH7tzLQIVYRdc1tEkBS0basuqbiwYNZ182eJoeIypLiz4wDz/kobY=
X-Received: by 2002:a05:6102:3e1f:b0:388:9dab:9bef with SMTP id
 j31-20020a0561023e1f00b003889dab9befmr9260966vsv.38.1662098613257; Thu, 01
 Sep 2022 23:03:33 -0700 (PDT)
MIME-Version: 1.0
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com> <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com> <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com> <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com> <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com> <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com> <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
 <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
 <4678fc51-a402-d3ea-e875-6eba175933ba@oracle.com> <e06d1f6d-3199-1b75-d369-2e5d69040271@intel.com>
 <CACGkMEv24Rn9+bJ5mma1ciJNwa7wvRCwJ6jF+CBMbz6DtV8MvA@mail.gmail.com> <a6ac322c-636f-1826-5c65-b51cc5464999@oracle.com>
In-Reply-To: <a6ac322c-636f-1826-5c65-b51cc5464999@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 2 Sep 2022 14:03:22 +0800
Message-ID: <CACGkMEvYGz_L+mYzvycYDLuMUAup9XdU1-cdpy=9sTmSLYXNSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
To:     Si-Wei Liu <si-wei.liu@oracle.com>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>
Cc:     "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 2:24 PM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 8/22/2022 8:26 PM, Jason Wang wrote:
> > On Mon, Aug 22, 2022 at 1:08 PM Zhu, Lingshan <lingshan.zhu@intel.com> =
wrote:
> >>
> >>
> >> On 8/20/2022 4:55 PM, Si-Wei Liu wrote:
> >>>
> >>> On 8/18/2022 5:42 PM, Jason Wang wrote:
> >>>> On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com>
> >>>> wrote:
> >>>>>
> >>>>> On 8/17/2022 9:15 PM, Jason Wang wrote:
> >>>>>> =E5=9C=A8 2022/8/17 18:37, Michael S. Tsirkin =E5=86=99=E9=81=93:
> >>>>>>> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
> >>>>>>>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> >>>>>>>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
> >>>>>>>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> >>>>>>>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote=
:
> >>>>>>>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
> >>>>>>>>>>>> because of
> >>>>>>>>>>>> transitional devices, so maybe this is the best we can do fo=
r
> >>>>>>>>>>>> now
> >>>>>>>>>>> I think vhost generally needs an API to declare config space
> >>>>>>>>>>> endian-ness
> >>>>>>>>>>> to kernel. vdpa can reuse that too then.
> >>>>>>>>>> Yes, I remember you have mentioned some IOCTL to set the
> >>>>>>>>>> endian-ness,
> >>>>>>>>>> for vDPA, I think only the vendor driver knows the endian,
> >>>>>>>>>> so we may need a new function vdpa_ops->get_endian().
> >>>>>>>>>> In the last thread, we say maybe it's better to add a comment =
for
> >>>>>>>>>> now.
> >>>>>>>>>> But if you think we should add a vdpa_ops->get_endian(), I can
> >>>>>>>>>> work
> >>>>>>>>>> on it for sure!
> >>>>>>>>>>
> >>>>>>>>>> Thanks
> >>>>>>>>>> Zhu Lingshan
> >>>>>>>>> I think QEMU has to set endian-ness. No one else knows.
> >>>>>>>> Yes, for SW based vhost it is true. But for HW vDPA, only
> >>>>>>>> the device & driver knows the endian, I think we can not
> >>>>>>>> "set" a hardware's endian.
> >>>>>>> QEMU knows the guest endian-ness and it knows that
> >>>>>>> device is accessed through the legacy interface.
> >>>>>>> It can accordingly send endian-ness to the kernel and
> >>>>>>> kernel can propagate it to the driver.
> >>>>>> I wonder if we can simply force LE and then Qemu can do the endian
> >>>>>> conversion?
> >>>>> convert from LE for config space fields only, or QEMU has to forcef=
ully
> >>>>> mediate and covert endianness for all device memory access includin=
g
> >>>>> even the datapath (fields in descriptor and avail/used rings)?
> >>>> Former. Actually, I want to force modern devices for vDPA when
> >>>> developing the vDPA framework. But then we see requirements for
> >>>> transitional or even legacy (e.g the Ali ENI parent). So it
> >>>> complicates things a lot.
> >>>>
> >>>> I think several ideas has been proposed:
> >>>>
> >>>> 1) Your proposal of having a vDPA specific way for
> >>>> modern/transitional/legacy awareness. This seems very clean since ea=
ch
> >>>> transport should have the ability to do that but it still requires
> >>>> some kind of mediation for the case e.g running BE legacy guest on L=
E
> >>>> host.
> >>> In theory it seems like so, though practically I wonder if we can jus=
t
> >>> forbid BE legacy driver from running on modern LE host. For those who
> >>> care about legacy BE guest, they mostly like could and should talk to
> >>> vendor to get native BE support to achieve hardware acceleration,
> > The problem is the hardware still needs a way to know the endian of the=
 guest?
> Hardware doesn't need to know. VMM should know by judging from VERSION_1
> feature bit negotiation and legacy interface access (with new code), and
> the target architecture endianness (the latter is existing QEMU code).
> >
> >>> few
> >>> of them would count on QEMU in mediating or emulating the datapath
> >>> (otherwise I don't see the benefit of adopting vDPA?). I still feel
> >>> that not every hardware vendor has to offer backward compatibility
> >>> (transitional device) with legacy interface/behavior (BE being just
> >>> one),
> > Probably, I agree it is a corner case, and dealing with transitional
> > device for the following setups is very challenge for hardware:
> >
> > - driver without IOMMU_PLATFORM support, (requiring device to send
> > translated request which have security implications)
> Don't get better suggestion for this one, but I presume this is
> something legacy guest users should be aware of ahead in term of
> security implications.

Probably but I think this assumption will prevent the device from
being used in a production environment.

>
> > - BE legacy guest on LE host, (requiring device to have a way to know
> > the endian)
> Yes. device can tell apart with the help from VMM (judging by VERSION_1
> acknowledgement and if legacy interface is used during negotiation).
>
> > - device specific requirement (e.g modern virtio-net mandate minimal
> > header length to contain mrg_rxbuf even if the device doesn't offer
> > it)
> This one seems to be spec mandated transitional interface requirement?

Yes.

> Which vDPA hardware vendor should take care of rather (if they do offer
> a transitional device)?

Right but this is not the only one. Section 7.4 summaries the
transitional device conformance which is a very long list for vendor
to follow.

> >
> > It is not obvious for the hardware vendor, so we may end up defecting
> > in the implementation. Dealing with compatibility for the transitional
> > devices is kind of a nightmare which there's no way for the spec to
> > rule the behavior of legacy devices.
> The compatibility detection part is tedious I agree. That's why I
> suggested starting from the very minimal and practically feasible (for
> e.g. on x86), but just don't prohibit the possibility to extend to big
> endian or come up with quirk fixes for various cases in QEMU.

This is somehow we've already been done, e.g ali ENI is limited to x86.

>
> >
> >>>   this is unlike the situation on software virtio device, which
> >>> has legacy support since day one. I think we ever discussed it before=
:
> >>> for those vDPA vendors who don't offer legacy guest support, maybe we
> >>> should mandate some feature for e.g. VERSION_1, as these devices
> >>> really don't offer functionality of the opposite side (!VERSION_1)
> >>> during negotiation.
> > I've tried something similar here (a global mandatory instead of per de=
vice).
> >
> > https://urldefense.com/v3/__https://lkml.org/lkml/2021/6/4/26__;!!ACWV5=
N9M2RV99hQ!NRQPfj5o9o3MKE12ze1zfXMC-9SqwOWqF26g8RrIyUDbUmwDIwl5WQCaNiDe6aZ2=
yR83j-NEqRXQNXcNyOo$
> >
> > But for some reason, it is not applied by Michael. It would be a great
> > relief if we support modern devices only. Maybe it's time to revisit
> > this idea then we can introduce new backend features and then we can
> > mandate VERSION_1
> Probably, mandating per-device should be fine I guess.
>
> >
> >>> Having it said, perhaps we should also allow vendor device to
> >>> implement only partial support for legacy. We can define "reversed"
> >>> backend feature to denote some part of the legacy
> >>> interface/functionality not getting implemented by device. For
> >>> instance, VHOST_BACKEND_F_NO_BE_VRING, VHOST_BACKEND_F_NO_BE_CONFIG,
> >>> VHOST_BACKEND_F_NO_ALIGNED_VRING,
> >>> VHOST_BACKEND_NET_F_NO_WRITEABLE_MAC, and et al. Not all of these
> >>> missing features for legacy would be easy for QEMU to make up for, so
> >>> QEMU can selectively emulate those at its best when necessary and
> >>> applicable. In other word, this design shouldn't prevent QEMU from
> >>> making up for vendor device's partial legacy support.
> > This looks too heavyweight since it tries to provide compatibility for
> > legacy drivers.
> That's just for the sake of extreme backward compatibility, but you can
> say that's not even needed if we mandate transitional device to offer
> all required interfaces for both legacy and modern guest.
>
> >   Considering we've introduced modern devices for 5+
> > years, I'd rather:
> >
> > - Qemu to mediate the config space stuffs
> > - Shadow virtqueue to mediate the datapath (AF_XDP told us shadow ring
> > can perform very well if we do zero-copy).
> This is one way to achieve, though not sure we should stick the only
> hope to zero-copy, which IMHO may take a long way to realize and
> optimize to where a simple datapath passthrough can easily get to (with
> hardware acceleration of coz).

Note that, current shadow virtqueue is zerocopy, Qemu just need to
forward the descriptors.

>
> >
> >>>> 2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
> >>>> need a new config ops for vDPA bus, but it doesn't solve the issue f=
or
> >>>> config space (at least from its name). We probably need a new ioctl
> >>>> for both vring and config space.
> >>> Yep adding a new ioctl makes things better, but I think the key is no=
t
> >>> the new ioctl. It's whether or not we should enforce every vDPA vendo=
r
> >>> driver to implement all transitional interfaces to be spec compliant.
> > I think the answer is no since the spec allows transitional device.
> > And we know things will be greatly simplified if vDPA support non
> > transitional device only.
> >
> > So we can change the question to:
> >
> > 1) do we need (or is it too late) to enforce non transitional device?
> We already have Alibaba ENI which is sort of a quasi-transitional
> device, right? In the sense it doesn't advertise VERSION_1. I know the
> other parts might not qualify it to be fully transitional, but code now
> doesn't prohibit it from supporting VERSION_1 modern interface depending
> on whatever future need.

We can ask ENI developer for their future plan, it looks to me a
legacy only device wouldn't be interested in the future.

Zongyong, do you have the plan to implement device with VERSION_1 support?

> > 2) if yes, can transitional device be mediate in an efficient way?
> >
> > For 1), it's probably too late but we can invent new vDPA features as
> > you suggest to be non transitional. Then we can:
> >
> > 1.1) extend the netlink API to provision non-transitonal device
> Define non-transitional: device could be either modern-only or legacy-onl=
y?

According to the spec, non-transitional should be modern only.

> > 1.2) work on the non-transtional device in the future
> > 1.3) presenting transitional device via mediation
> presenting transitional on top of a modern device with VERSION_1, right?

Yes, I mean presenting/mediating a transitional device on top of a
non-transitional device.

> What if the hardware device can support legacy-compatible datapath
> natively that doesn't need mediation? Can it be done with direct
> datapath passthrough without svq involvement?

I'd like to avoid supporting legacy-only device like ENI in the
future. The major problem is that it's out of the spec thus the
behaviour is defined by the code not the spec.

>
> >
> > The previous transitional vDPA work as is, it's probably too late to
> > fix all the issue we suffer.
> What do you mean work as-is,

See above, basically I mean the behaviour is defined by the vDPA code
not (or can't) by the spec.

For example, for virtio-pci, we have:

legacy interface: BAR
modern interface: capability

So a transitional device can simple provide both of those interfaces:
E.g for device configuration space, if it is accessed via legacy
interface device know it needs to provide the config with native
endian otherwise little endian when accessing via modern interface.

For virtio-mmio, it looks to me it doesn't provide a way for
transitional device.

For vDPA, we actually don't define whether config_ops is a modern or
legacy interface. This is very tricky for the transitional device
since it tries to reuse the same interface for both legacy and modern
which make it very hard to be correct. E.g:

1) VERSION_1 trick won't work, e.g the spec allows to read device
configuration space before FEATURE_OK. So legacy driver may assume a
native endian.
2) SET_VRING_ENDIAN doesn't fix all the issue, there's still a
question what endian it is before SET_VRING_ENDIAN (or we need to
support userspace without SET_VRING_ENDIAN)
...

Things will be simplified if we mandate the config_ops as the modern
interface and provide the necessary mediation in the hypervisor.

> what's the nomenclature for that,
> quasi-transitional or broken-transitional?

If we invent new API to clarify the modern/legacy and focus on the
modern in the future, we probably don't need a name?

> and what are the outstanding
> issues you anticipate remaining?

Basically we need to check the conformance listed in section 7.4 of the spe=
c.

> If it is device specific or vendor
> driver specific, let it be. But I wonder if there's any generic one that
> has to be fixed in vdpa core to support a truly transitional model.

Two set of config_ops? E.g

legacy_config_ops
modern_config_ops

But I'm not sure whether or not it's worthwhile.

> >
> > For 2), the key part is the datapath mediation, we can use shadow virtq=
ueue.
> Sure. For our use case, we'd care more in providing transitional rather
> than being non-transitional. So, one device fits all.
>
> Thanks for all the ideas. This discussion is really useful.

Appreciate for the discussion.

Thanks

>
> Best,
> -Siwei
> >
> >>> If we allow them to reject the VHOST_SET_VRING_ENDIAN  or
> >>> VHOST_SET_CONFIG_ENDIAN call, what could we do? We would still end up
> >>> with same situation of either fail the guest, or trying to
> >>> mediate/emulate, right?
> >>>
> >>> Not to mention VHOST_SET_VRING_ENDIAN is rarely supported by vhost
> >>> today - few distro kernel has CONFIG_VHOST_CROSS_ENDIAN_LEGACY enable=
d
> >>> and QEMU just ignores the result. vhost doesn't necessarily depend on
> >>> it to determine endianness it looks.
> >> I would like to suggest to add two new config ops get/set_vq_endian()
> >> and get/set_config_endian() for vDPA. This is used to:
> >> a) support VHOST_GET/SET_VRING_ENDIAN as MST suggested, and add
> >> VHOST_SET/GET_CONFIG_ENDIAN for vhost_vdpa.
> >> If the device has not implemented interface to set its endianess, then
> >> no matter success or failure of SET_ENDIAN, QEMU knows the endian-ness
> >> anyway.
> > How can Qemu know the endian in this way? And if it can, there's no
> > need for the new API?
> >
> >> In this case, if the device endianess does not match the guest,
> >> there needs a mediation layer or fail.
> >> b) ops->get_config_endian() can always tell the endian-ness of the
> >> device config space after the vendor driver probing the device. So we
> >> can use this ops->get_config_endian() for
> >> MTU, MAC and other fields handling in vdpa_dev_net_config_fill() and w=
e
> >> don't need to set_features in vdpa_get_config_unlocked(), so no race
> >> conditions.
> >> Every time ops->get_config() returned, we can tell the endian by
> >> ops-config_>get_endian(), we don't need set_features(xxx, 0) if featur=
es
> >> negotiation not done.
> >>
> >> The question is: Do we need two pairs of ioctls for both vq and config
> >> space? Can config space endian-ness differ from the vqs?
> >> c) do we need a new netlink attr telling the endian-ness to user space=
?
> > Generally, I'm not sure this is a good design consider it provides neit=
her:
> >
> > Compatibility with the virtio spec
> >
> > nor
> >
> > Compatibility with the existing vhost API (VHOST_SET_VRING_ENDIAN)
> >
> > Thanks
> >
> >> Thanks,
> >> Zhu Lingshan
> >>>> or
> >>>>
> >>>> 3) revisit the idea of forcing modern only device which may simplify
> >>>> things a lot
> >>> I am not actually against forcing modern only config space, given tha=
t
> >>> it's not hard for either QEMU or individual driver to mediate or
> >>> emulate, and for the most part it's not conflict with the goal of
> >>> offload or acceleration with vDPA. But forcing LE ring layout IMO
> >>> would just kill off the potential of a very good use case. Currently
> >>> for our use case the priority for supporting 0.9.5 guest with vDPA is
> >>> slightly lower compared to live migration, but it is still in our TOD=
O
> >>> list.
> >>>
> >>> Thanks,
> >>> -Siwei
> >>>
> >>>> which way should we go?
> >>>>
> >>>>> I hope
> >>>>> it's not the latter, otherwise it loses the point to use vDPA for
> >>>>> datapath acceleration.
> >>>>>
> >>>>> Even if its the former, it's a little weird for vendor device to
> >>>>> implement a LE config space with BE ring layout, although still
> >>>>> possible...
> >>>> Right.
> >>>>
> >>>> Thanks
> >>>>
> >>>>> -Siwei
> >>>>>> Thanks
> >>>>>>
> >>>>>>
> >>>>>>>> So if you think we should add a vdpa_ops->get_endian(),
> >>>>>>>> I will drop these comments in the next version of
> >>>>>>>> series, and work on a new patch for get_endian().
> >>>>>>>>
> >>>>>>>> Thanks,
> >>>>>>>> Zhu Lingshan
> >>>>>>> Guests don't get endian-ness from devices so this seems pointless=
.
> >>>>>>>
>

