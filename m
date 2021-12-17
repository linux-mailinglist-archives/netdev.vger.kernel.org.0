Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CFF4782E9
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 03:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbhLQCBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 21:01:08 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42815 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230322AbhLQCBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 21:01:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639706467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gbhzR/ta5wJM0NZ8+LJz1rln0Vg8UKqxlqmsFHgHsdY=;
        b=BhX/Sk0q7+Rj63zIzOvmlVhbjyZHhhCBdEyM/DI3T/K74dg66hr++9EA2VjOGZhqqkBrGs
        oONozh2Bwv3KbbVvTa1ooXk6f7xGuM/AwjupA4FPkj1abWPmQeGAw0lQjHU3IT8I4tGe4A
        MbD8jswbL634nwEG3wSF4oAD55wZ1/Q=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-GKQKnvWgMg-CXwQ9cpeeJQ-1; Thu, 16 Dec 2021 21:01:06 -0500
X-MC-Unique: GKQKnvWgMg-CXwQ9cpeeJQ-1
Received: by mail-ed1-f71.google.com with SMTP id s12-20020a50ab0c000000b003efdf5a226fso565736edc.10
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 18:01:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gbhzR/ta5wJM0NZ8+LJz1rln0Vg8UKqxlqmsFHgHsdY=;
        b=qVm7JGNu158r+NXzeC30ggNee7Nhvji7PqIRKxF97cKZyiqAOgbBMJWdTHBj4XMuph
         HIpypWiOXWyzSSi7IP2MmshDdWTzUMEkNjZ9uOJ+fM9wI8FblU9WU9cGrX028aos6jFS
         evpIAuSAI8sJPCQMQI/LJFXLS059+wMqty/8XbJzKejApW+FKj2ua8Waes8W+yGICYlA
         fmng7O5+uIVk/uda9VP7nlpnqzSn+7i+oIjOSl9Owje2DFPUeE/tbmFShcA0961Vo1Ct
         M0n1R7oDo2Z2EVBBAank3uwEbMAHnUYA022pofEnzeqYGE1YkeiUTIjeoacXB0QY1UmQ
         D4KQ==
X-Gm-Message-State: AOAM530fLUqpi0DS8N0KzQiaCNZZDoI8HgqIIMDA7r7dyRRa1jceIAOW
        ttlRg41TSHPDJipwtRUrJVkuGwNfgX7040v14IGxsUS1KKznjgH7QiHpcfoPgJvUpp0Gb18HKH0
        q4XXOz002sQZVfIBD
X-Received: by 2002:a17:907:1c89:: with SMTP id nb9mr309665ejc.408.1639706464286;
        Thu, 16 Dec 2021 18:01:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyJOVB8t1MYtjdN8SJk8prhfOCZMdXtMw9SPSd0gMBtUijDWi/l/Iwya9JaM7Wm6Vd6RmlDzw==
X-Received: by 2002:a17:907:1c89:: with SMTP id nb9mr309645ejc.408.1639706463952;
        Thu, 16 Dec 2021 18:01:03 -0800 (PST)
Received: from redhat.com ([2.55.30.56])
        by smtp.gmail.com with ESMTPSA id nc24sm2401836ejc.94.2021.12.16.18.01.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 18:01:03 -0800 (PST)
Date:   Thu, 16 Dec 2021 21:00:59 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     Si-Wei Liu <si-wei.liu@oracle.com>, Eli Cohen <elic@nvidia.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: vdpa legacy guest support (was Re: [PATCH] vdpa/mlx5:
 set_features should allow reset to zero)
Message-ID: <20211216205958-mutt-send-email-mst@kernel.org>
References: <ba9df703-29af-98a9-c554-f303ff045398@oracle.com>
 <20211214000245-mutt-send-email-mst@kernel.org>
 <4fc43d0f-da9e-ce16-1f26-9f0225239b75@oracle.com>
 <CACGkMEsttnFEKGK-aKdCZeXkUnZJg1uaqYzFqpv-g5TobHGSzQ@mail.gmail.com>
 <6eaf672c-cc86-b5bf-5b74-c837affeb6e1@oracle.com>
 <20211215162917-mutt-send-email-mst@kernel.org>
 <71d2a69c-94a7-76b5-2971-570026760bf0@oracle.com>
 <CACGkMEsoMpSLX=YZmsgRQVs7+9dwon7FCDK+VOL6Nx2FYK=_pA@mail.gmail.com>
 <a6ad8613-2d66-259e-55a3-42799c89dfe3@oracle.com>
 <CACGkMEudFhTU5=zh6Kjeru1_9P+jY41hJTwLDT9vBs6vwDaj5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACGkMEudFhTU5=zh6Kjeru1_9P+jY41hJTwLDT9vBs6vwDaj5g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 09:57:38AM +0800, Jason Wang wrote:
> On Fri, Dec 17, 2021 at 6:32 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> >
> >
> >
> > On 12/15/2021 6:53 PM, Jason Wang wrote:
> > > On Thu, Dec 16, 2021 at 10:02 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> > >>
> > >>
> > >> On 12/15/2021 1:33 PM, Michael S. Tsirkin wrote:
> > >>> On Wed, Dec 15, 2021 at 12:52:20PM -0800, Si-Wei Liu wrote:
> > >>>> On 12/14/2021 6:06 PM, Jason Wang wrote:
> > >>>>> On Wed, Dec 15, 2021 at 9:05 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
> > >>>>>> On 12/13/2021 9:06 PM, Michael S. Tsirkin wrote:
> > >>>>>>> On Mon, Dec 13, 2021 at 05:59:45PM -0800, Si-Wei Liu wrote:
> > >>>>>>>> On 12/12/2021 1:26 AM, Michael S. Tsirkin wrote:
> > >>>>>>>>> On Fri, Dec 10, 2021 at 05:44:15PM -0800, Si-Wei Liu wrote:
> > >>>>>>>>>> Sorry for reviving this ancient thread. I was kinda lost for the conclusion
> > >>>>>>>>>> it ended up with. I have the following questions,
> > >>>>>>>>>>
> > >>>>>>>>>> 1. legacy guest support: from the past conversations it doesn't seem the
> > >>>>>>>>>> support will be completely dropped from the table, is my understanding
> > >>>>>>>>>> correct? Actually we're interested in supporting virtio v0.95 guest for x86,
> > >>>>>>>>>> which is backed by the spec at
> > >>>>>>>>>> https://urldefense.com/v3/__https://ozlabs.org/*rusty/virtio-spec/virtio-0.9.5.pdf__;fg!!ACWV5N9M2RV99hQ!dTKmzJwwRsFM7BtSuTDu1cNly5n4XCotH0WYmidzGqHSXt40i7ZU43UcNg7GYxZg$ . Though I'm not sure
> > >>>>>>>>>> if there's request/need to support wilder legacy virtio versions earlier
> > >>>>>>>>>> beyond.
> > >>>>>>>>> I personally feel it's less work to add in kernel than try to
> > >>>>>>>>> work around it in userspace. Jason feels differently.
> > >>>>>>>>> Maybe post the patches and this will prove to Jason it's not
> > >>>>>>>>> too terrible?
> > >>>>>>>> I suppose if the vdpa vendor does support 0.95 in the datapath and ring
> > >>>>>>>> layout level and is limited to x86 only, there should be easy way out.
> > >>>>>>> Note a subtle difference: what matters is that guest, not host is x86.
> > >>>>>>> Matters for emulators which might reorder memory accesses.
> > >>>>>>> I guess this enforcement belongs in QEMU then?
> > >>>>>> Right, I mean to get started, the initial guest driver support and the
> > >>>>>> corresponding QEMU support for transitional vdpa backend can be limited
> > >>>>>> to x86 guest/host only. Since the config space is emulated in QEMU, I
> > >>>>>> suppose it's not hard to enforce in QEMU.
> > >>>>> It's more than just config space, most devices have headers before the buffer.
> > >>>> The ordering in datapath (data VQs) would have to rely on vendor's support.
> > >>>> Since ORDER_PLATFORM is pretty new (v1.1), I guess vdpa h/w vendor nowadays
> > >>>> can/should well support the case when ORDER_PLATFORM is not acked by the
> > >>>> driver (actually this feature is filtered out by the QEMU vhost-vdpa driver
> > >>>> today), even with v1.0 spec conforming and modern only vDPA device. The
> > >>>> control VQ is implemented in software in the kernel, which can be easily
> > >>>> accommodated/fixed when needed.
> > >>>>
> > >>>>>> QEMU can drive GET_LEGACY,
> > >>>>>> GET_ENDIAN et al ioctls in advance to get the capability from the
> > >>>>>> individual vendor driver. For that, we need another negotiation protocol
> > >>>>>> similar to vhost_user's protocol_features between the vdpa kernel and
> > >>>>>> QEMU, way before the guest driver is ever probed and its feature
> > >>>>>> negotiation kicks in. Not sure we need a GET_MEMORY_ORDER ioctl call
> > >>>>>> from the device, but we can assume weak ordering for legacy at this
> > >>>>>> point (x86 only)?
> > >>>>> I'm lost here, we have get_features() so:
> > >>>> I assume here you refer to get_device_features() that Eli just changed the
> > >>>> name.
> > >>>>> 1) VERSION_1 means the device uses LE if provided, otherwise natvie
> > >>>>> 2) ORDER_PLATFORM means device requires platform ordering
> > >>>>>
> > >>>>> Any reason for having a new API for this?
> > >>>> Are you going to enforce all vDPA hardware vendors to support the
> > >>>> transitional model for legacy guest?
> > > Do we really have other choices?
> > >
> > > I suspect the legacy device is never implemented by any vendor:
> > >
> > > 1) no virtio way to detect host endian
> > This is even true for transitional device that is conforming to the
> > spec, right?
> 
> For hardware, yes.
> 
> > The transport specific way to detect host endian is still
> > being discussed and the spec revision is not finalized yet so far as I
> > see. Why this suddenly becomes a requirement/blocker for h/w vendors to
> > implement the transitional model?
> 
> It's not a sudden blocker, the problem has existed since day 0 if I
> was not wrong. That's why the problem looks a little bit complicated
> and why it would be much simpler if we stick to modern devices.
> 
> > Even if the spec is out, this is
> > pretty new and I suspect not all vendor would follow right away. I hope
> > the software framework can be tolerant with h/w vendors not supporting
> > host endianess (BE specifically) or not detecting it if they would like
> > to support a transitional device for legacy.
> 
> Well, if we know we don't want to support the BE host it would be fine.

I think you guys mean guest not host here. Same for memory ordering etc.
What matters is whether guest has barriers etc.

> >
> > > 2) bypass IOMMU with translated requests
> > > 3) PIO port
> > >
> > > Yes we have enp_vdpa, but it's more like a "transitional device" for
> > > legacy only guests.
> > >
> > >> meaning guest not acknowledging
> > >>>> VERSION_1 would use the legacy interfaces captured in the spec section 7.4
> > >>>> (regarding ring layout, native endianness, message framing, vq alignment of
> > >>>> 4096, 32bit feature, no features_ok bit in status, IO port interface i.e.
> > >>>> all the things) instead?
> > > Note that we only care about the datapath, control path is mediated anyhow.
> > >
> > > So feature_ok and IO port isn't an issue. The rest looks like a must
> > > for the hardware.
> > H/W vendors can opt out not implementing transitional interfaces at all
> > which limits itself a modern only device. Set endianess detection (via
> > transport specific means) aside, for vendors that wishes to support
> > transitional device with legacy interface, is it a hard stop to drop
> > supporting BE host if everything else is there? The spec today doesn't
> > define virtio specific means to detect host memory ordering or device
> > memory coherency,
> 
> Any reason that we need to care about memory coherency at the virtio
> level. I'd expect it's the task of transport.
> 
> > will it yet become a stopper another day for h/w
> > vendor to support more platforms?
> 
> Let's differentiate virtio from vdpa here. For virtio, there's no way
> to add any feature for legacy devices. We can only add memory features
> detecting for modern devices.
> 
> But for vDPA, we can introduce any API that can help vendors to
> present a transitional device. But we can force those APIs since it's
> too late to do that. So transitional devices support is optional for
> sure.
> 
> >
> > >
> > >> Noted we don't yet have a set_device_features()
> > >>>> that allows the vdpa device to tell whether it is operating in transitional
> > >>>> or modern-only mode.
> > > So the device feature should be provisioned via the netlink protocol.
> > Such netlink interface will only be used to limit feature exposure,
> > right? i.e. you can limit a transitional supporting vendor driver to
> > offering modern-only interface,
> 
> There's no way for the management to force a feature, like VERSION_1
> via the current protocol.
> 
> > but you never want to make a modern-only
> > vendor driver to support transitional (I'm not sure if it's a good idea
> > to support all the translation in software, esp. for datapath).
> 
> You may hit this problem for sure, you can't force all vendors to
> support transitional devices especially considering spec said legacy
> is optional. We don't want to end up with a userspace code that can
> only work for some specific vendors.
> 
> > > And what we want is not "set_device_feature()" but
> > > "set_device_mandatory_feautre()", then the parent can choose to fail
> > > the negotiation when VERSION_1 is not negotiated.
> > This assumes the transport specific detection of BE host is in place,
> > right?
> 
> Again, the point is, we can not assume such detection works for all of
> the vendors. And assume BE detection is ready, we still need this for
> modern devices, isn't it?
> 
> > I am not clear who initiates the set_device_mandatory_feautre()
> > call, QEMU during guest feature negotiation, or admin user setting it
> > ahead via netlink?
> 
> Netlink, actually, the spec needs to be extended as well, we saw
> similar requests in the past. E.g there could be a device that works
> in a packed layout only.
> 
> Thanks
> 
> >
> > Thanks,
> > -Siwei
> >
> > >   Qemu then knows for
> > > sure it talks to a transitional device or modern only device.
> > >
> > > Thanks
> > >
> > >> For software virtio, all support for the legacy part in
> > >>>> a transitional model has been built up there already, however, it's not easy
> > >>>> for vDPA vendors to implement all the requirements for an all-or-nothing
> > >>>> legacy guest support (big endian guest for example). To these vendors, the
> > >>>> legacy support within a transitional model is more of feature to them and
> > >>>> it's best to leave some flexibility for them to implement partial support
> > >>>> for legacy. That in turn calls out the need for a vhost-user protocol
> > >>>> feature like negotiation API that can prohibit those unsupported guest
> > >>>> setups to as early as backend_init before launching the VM.
> > >>> Right. Of note is the fact that it's a spec bug which I
> > >>> hope yet to fix, though due to existing guest code the
> > >>> fix won't be complete.
> > >> I thought at one point you pointed out to me that the spec does allow
> > >> config space read before claiming features_ok, and only config write
> > >> before features_ok is prohibited. I haven't read up the full thread of
> > >> Halil's VERSION_1 for transitional big endian device yet, but what is
> > >> the spec bug you hope to fix?
> > >>
> > >>> WRT ioctls, One thing we can do though is abuse set_features
> > >>> where it's called by QEMU early on with just the VERSION_1
> > >>> bit set, to distinguish between legacy and modern
> > >>> interface. This before config space accesses and FEATURES_OK.
> > >>>
> > >>> Halil has been working on this, pls take a look and maybe help him out.
> > >> Interesting thread, am reading now and see how I may leverage or help there.
> > >>
> > >>>>>>>> I
> > >>>>>>>> checked with Eli and other Mellanox/NVDIA folks for hardware/firmware level
> > >>>>>>>> 0.95 support, it seems all the ingredient had been there already dated back
> > >>>>>>>> to the DPDK days. The only major thing limiting is in the vDPA software that
> > >>>>>>>> the current vdpa core has the assumption around VIRTIO_F_ACCESS_PLATFORM for
> > >>>>>>>> a few DMA setup ops, which is virtio 1.0 only.
> > >>>>>>>>
> > >>>>>>>>>> 2. suppose some form of legacy guest support needs to be there, how do we
> > >>>>>>>>>> deal with the bogus assumption below in vdpa_get_config() in the short term?
> > >>>>>>>>>> It looks one of the intuitive fix is to move the vdpa_set_features call out
> > >>>>>>>>>> of vdpa_get_config() to vdpa_set_config().
> > >>>>>>>>>>
> > >>>>>>>>>>              /*
> > >>>>>>>>>>               * Config accesses aren't supposed to trigger before features are
> > >>>>>>>>>> set.
> > >>>>>>>>>>               * If it does happen we assume a legacy guest.
> > >>>>>>>>>>               */
> > >>>>>>>>>>              if (!vdev->features_valid)
> > >>>>>>>>>>                      vdpa_set_features(vdev, 0);
> > >>>>>>>>>>              ops->get_config(vdev, offset, buf, len);
> > >>>>>>>>>>
> > >>>>>>>>>> I can post a patch to fix 2) if there's consensus already reached.
> > >>>>>>>>>>
> > >>>>>>>>>> Thanks,
> > >>>>>>>>>> -Siwei
> > >>>>>>>>> I'm not sure how important it is to change that.
> > >>>>>>>>> In any case it only affects transitional devices, right?
> > >>>>>>>>> Legacy only should not care ...
> > >>>>>>>> Yes I'd like to distinguish legacy driver (suppose it is 0.95) against the
> > >>>>>>>> modern one in a transitional device model rather than being legacy only.
> > >>>>>>>> That way a v0.95 and v1.0 supporting vdpa parent can support both types of
> > >>>>>>>> guests without having to reconfigure. Or are you suggesting limit to legacy
> > >>>>>>>> only at the time of vdpa creation would simplify the implementation a lot?
> > >>>>>>>>
> > >>>>>>>> Thanks,
> > >>>>>>>> -Siwei
> > >>>>>>> I don't know for sure. Take a look at the work Halil was doing
> > >>>>>>> to try and support transitional devices with BE guests.
> > >>>>>> Hmmm, we can have those endianness ioctls defined but the initial QEMU
> > >>>>>> implementation can be started to support x86 guest/host with little
> > >>>>>> endian and weak memory ordering first. The real trick is to detect
> > >>>>>> legacy guest - I am not sure if it's feasible to shift all the legacy
> > >>>>>> detection work to QEMU, or the kernel has to be part of the detection
> > >>>>>> (e.g. the kick before DRIVER_OK thing we have to duplicate the tracking
> > >>>>>> effort in QEMU) as well. Let me take a further look and get back.
> > >>>>> Michael may think differently but I think doing this in Qemu is much easier.
> > >>>> I think the key is whether we position emulating legacy interfaces in QEMU
> > >>>> doing translation on top of a v1.0 modern-only device in the kernel, or we
> > >>>> allow vdpa core (or you can say vhost-vdpa) and vendor driver to support a
> > >>>> transitional model in the kernel that is able to work for both v0.95 and
> > >>>> v1.0 drivers, with some slight aid from QEMU for
> > >>>> detecting/emulation/shadowing (for e.g CVQ, I/O port relay). I guess for the
> > >>>> former we still rely on vendor for a performant data vqs implementation,
> > >>>> leaving the question to what it may end up eventually in the kernel is
> > >>>> effectively the latter).
> > >>>>
> > >>>> Thanks,
> > >>>> -Siwei
> > >>> My suggestion is post the kernel patches, and we can evaluate
> > >>> how much work they are.
> > >> Thanks for the feedback. I will take some read then get back, probably
> > >> after the winter break. Stay tuned.
> > >>
> > >> Thanks,
> > >> -Siwei
> > >>
> > >>>>> Thanks
> > >>>>>
> > >>>>>
> > >>>>>
> > >>>>>> Meanwhile, I'll check internally to see if a legacy only model would
> > >>>>>> work. Thanks.
> > >>>>>>
> > >>>>>> Thanks,
> > >>>>>> -Siwei
> > >>>>>>
> > >>>>>>
> > >>>>>>>>>> On 3/2/2021 2:53 AM, Jason Wang wrote:
> > >>>>>>>>>>> On 2021/3/2 5:47 下午, Michael S. Tsirkin wrote:
> > >>>>>>>>>>>> On Mon, Mar 01, 2021 at 11:56:50AM +0800, Jason Wang wrote:
> > >>>>>>>>>>>>> On 2021/3/1 5:34 上午, Michael S. Tsirkin wrote:
> > >>>>>>>>>>>>>> On Wed, Feb 24, 2021 at 10:24:41AM -0800, Si-Wei Liu wrote:
> > >>>>>>>>>>>>>>>> Detecting it isn't enough though, we will need a new ioctl to notify
> > >>>>>>>>>>>>>>>> the kernel that it's a legacy guest. Ugh :(
> > >>>>>>>>>>>>>>> Well, although I think adding an ioctl is doable, may I
> > >>>>>>>>>>>>>>> know what the use
> > >>>>>>>>>>>>>>> case there will be for kernel to leverage such info
> > >>>>>>>>>>>>>>> directly? Is there a
> > >>>>>>>>>>>>>>> case QEMU can't do with dedicate ioctls later if there's indeed
> > >>>>>>>>>>>>>>> differentiation (legacy v.s. modern) needed?
> > >>>>>>>>>>>>>> BTW a good API could be
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> #define VHOST_SET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > >>>>>>>>>>>>>> #define VHOST_GET_ENDIAN _IOW(VHOST_VIRTIO, ?, int)
> > >>>>>>>>>>>>>>
> > >>>>>>>>>>>>>> we did it per vring but maybe that was a mistake ...
> > >>>>>>>>>>>>> Actually, I wonder whether it's good time to just not support
> > >>>>>>>>>>>>> legacy driver
> > >>>>>>>>>>>>> for vDPA. Consider:
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>> 1) It's definition is no-normative
> > >>>>>>>>>>>>> 2) A lot of budren of codes
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>> So qemu can still present the legacy device since the config
> > >>>>>>>>>>>>> space or other
> > >>>>>>>>>>>>> stuffs that is presented by vhost-vDPA is not expected to be
> > >>>>>>>>>>>>> accessed by
> > >>>>>>>>>>>>> guest directly. Qemu can do the endian conversion when necessary
> > >>>>>>>>>>>>> in this
> > >>>>>>>>>>>>> case?
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>>> Thanks
> > >>>>>>>>>>>>>
> > >>>>>>>>>>>> Overall I would be fine with this approach but we need to avoid breaking
> > >>>>>>>>>>>> working userspace, qemu releases with vdpa support are out there and
> > >>>>>>>>>>>> seem to work for people. Any changes need to take that into account
> > >>>>>>>>>>>> and document compatibility concerns.
> > >>>>>>>>>>> Agree, let me check.
> > >>>>>>>>>>>
> > >>>>>>>>>>>
> > >>>>>>>>>>>>        I note that any hardware
> > >>>>>>>>>>>> implementation is already broken for legacy except on platforms with
> > >>>>>>>>>>>> strong ordering which might be helpful in reducing the scope.
> > >>>>>>>>>>> Yes.
> > >>>>>>>>>>>
> > >>>>>>>>>>> Thanks
> > >>>>>>>>>>>
> > >>>>>>>>>>>
> >

