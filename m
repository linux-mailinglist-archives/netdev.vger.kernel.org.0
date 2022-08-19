Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 549F75991DF
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 02:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241426AbiHSAmt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 20:42:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiHSAms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 20:42:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CDACDEB60
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:42:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660869766;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F+mwOXxAkoNOjKTh4pynirHUBFBiL6gHoAL0lptq2/s=;
        b=iWkaEi+xJrK09jcMTswrRVdKx19ipgjMXlR3FuRBj5/XMsarKrSFiLqcO7cIDDbQIIvNxq
        r1ovwgaGc8AY+P7XR/mP6eT/HKM6iZWe738RzbqD2YU5gBDAZHP3w8LHsxi/aFSS42AAnQ
        ziH8BcNjolW7dtyQhXHoCauLduL1Gts=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-374-_edCZaIFN-SybW7valBQkw-1; Thu, 18 Aug 2022 20:42:45 -0400
X-MC-Unique: _edCZaIFN-SybW7valBQkw-1
Received: by mail-lf1-f70.google.com with SMTP id dw24-20020a0565122c9800b004915129ac64so948047lfb.8
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 17:42:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc;
        bh=F+mwOXxAkoNOjKTh4pynirHUBFBiL6gHoAL0lptq2/s=;
        b=siDH0ta3O4YMO98UA5nB/TL0p0hPNdr+VzlMk82qGPGvDL4scQBAEHEA32H+9JABQ7
         eJn8GKcpOilcTN3zDNVyKSrE1+9HU5fA0AlwNBbkDB8cmo02TFlVy20lt7n71Y0s137g
         9Vgdmm3ujYhFp5L8QPYZmy0e6V6E0DEngQ/OxT46j4Bt1B4ZHlKxF86S+ihTzaldumTN
         /v3VD6/LkyElgX19q7sai1UWVMl3yhTclpA1eq6phIXzh3VfMXhQ5IoM9A934lqolkX/
         Yg+L9iBedxlXlST4pY/JbH+tfaNnDitwbCYinyXazPtdg7KLVPEHcfq0hkI8JJP1Ybfb
         goQQ==
X-Gm-Message-State: ACgBeo0QZtWylHa9syXmtdG4/Ve7Wn2lu+LDkCjmZeNL5JySuZjNV2TT
        Fgd4Px9p8q+MTZVT2zRM5bZLnohpf6QSs+4h0JXqkfca8rarVijUAlkQThsCgd/bU6Pj2UawTRW
        zpCdmr5Sd5NfS1vMtufu7zYYkqhrFuP7n
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id n3-20020a2ea5c3000000b00261ac2d2820mr1566632ljp.243.1660869763868;
        Thu, 18 Aug 2022 17:42:43 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6DovrTZ8skbUJhveovXiAocl2YhXuq8pzuh+lrxGHEPrz2c5hrrGAnX9Fj0f/C41UKEX10jssdqlgV7yfRDzY=
X-Received: by 2002:a2e:a5c3:0:b0:261:ac2d:2820 with SMTP id
 n3-20020a2ea5c3000000b00261ac2d2820mr1566611ljp.243.1660869763375; Thu, 18
 Aug 2022 17:42:43 -0700 (PDT)
MIME-Version: 1.0
References: <c5075d3d-9d2c-2716-1cbf-cede49e2d66f@oracle.com>
 <20e92551-a639-ec13-3d9c-13bb215422e1@intel.com> <9b6292f3-9bd5-ecd8-5e42-cd5d12f036e7@oracle.com>
 <22e0236f-b556-c6a8-0043-b39b02928fd6@intel.com> <892b39d6-85f8-bff5-030d-e21288975572@oracle.com>
 <52a47bc7-bf26-b8f9-257f-7dc5cea66d23@intel.com> <20220817045406-mutt-send-email-mst@kernel.org>
 <a91fa479-d1cc-a2d6-0821-93386069a2c1@intel.com> <20220817053821-mutt-send-email-mst@kernel.org>
 <449c2fb2-3920-7bf9-8c5c-a68456dfea76@intel.com> <20220817063450-mutt-send-email-mst@kernel.org>
 <54aa5a5c-69e2-d372-3e0c-b87f595d213c@redhat.com> <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
In-Reply-To: <f0b6ea5c-1783-96d2-2d9f-e5cf726b0fc0@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Fri, 19 Aug 2022 08:42:32 +0800
Message-ID: <CACGkMEumKfktMUJOTUYL_JYkFbw8qH331gGARPB2bTH=7wKWPg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vDPA: conditionally read fields in virtio-net dev
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        "Zhu, Lingshan" <lingshan.zhu@intel.com>,
        virtualization <virtualization@lists.linux-foundation.org>,
        netdev <netdev@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        Yongji Xie <xieyongji@bytedance.com>,
        "Dawar, Gautam" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 19, 2022 at 7:20 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 8/17/2022 9:15 PM, Jason Wang wrote:
> >
> > =E5=9C=A8 2022/8/17 18:37, Michael S. Tsirkin =E5=86=99=E9=81=93:
> >> On Wed, Aug 17, 2022 at 05:43:22PM +0800, Zhu, Lingshan wrote:
> >>>
> >>> On 8/17/2022 5:39 PM, Michael S. Tsirkin wrote:
> >>>> On Wed, Aug 17, 2022 at 05:13:59PM +0800, Zhu, Lingshan wrote:
> >>>>> On 8/17/2022 4:55 PM, Michael S. Tsirkin wrote:
> >>>>>> On Wed, Aug 17, 2022 at 10:14:26AM +0800, Zhu, Lingshan wrote:
> >>>>>>> Yes it is a little messy, and we can not check _F_VERSION_1
> >>>>>>> because of
> >>>>>>> transitional devices, so maybe this is the best we can do for now
> >>>>>> I think vhost generally needs an API to declare config space
> >>>>>> endian-ness
> >>>>>> to kernel. vdpa can reuse that too then.
> >>>>> Yes, I remember you have mentioned some IOCTL to set the endian-nes=
s,
> >>>>> for vDPA, I think only the vendor driver knows the endian,
> >>>>> so we may need a new function vdpa_ops->get_endian().
> >>>>> In the last thread, we say maybe it's better to add a comment for
> >>>>> now.
> >>>>> But if you think we should add a vdpa_ops->get_endian(), I can work
> >>>>> on it for sure!
> >>>>>
> >>>>> Thanks
> >>>>> Zhu Lingshan
> >>>> I think QEMU has to set endian-ness. No one else knows.
> >>> Yes, for SW based vhost it is true. But for HW vDPA, only
> >>> the device & driver knows the endian, I think we can not
> >>> "set" a hardware's endian.
> >> QEMU knows the guest endian-ness and it knows that
> >> device is accessed through the legacy interface.
> >> It can accordingly send endian-ness to the kernel and
> >> kernel can propagate it to the driver.
> >
> >
> > I wonder if we can simply force LE and then Qemu can do the endian
> > conversion?
> convert from LE for config space fields only, or QEMU has to forcefully
> mediate and covert endianness for all device memory access including
> even the datapath (fields in descriptor and avail/used rings)?

Former. Actually, I want to force modern devices for vDPA when
developing the vDPA framework. But then we see requirements for
transitional or even legacy (e.g the Ali ENI parent). So it
complicates things a lot.

I think several ideas has been proposed:

1) Your proposal of having a vDPA specific way for
modern/transitional/legacy awareness. This seems very clean since each
transport should have the ability to do that but it still requires
some kind of mediation for the case e.g running BE legacy guest on LE
host.

2) Michael suggests using VHOST_SET_VRING_ENDIAN where it means we
need a new config ops for vDPA bus, but it doesn't solve the issue for
config space (at least from its name). We probably need a new ioctl
for both vring and config space.

or

3) revisit the idea of forcing modern only device which may simplify
things a lot

which way should we go?

> I hope
> it's not the latter, otherwise it loses the point to use vDPA for
> datapath acceleration.
>
> Even if its the former, it's a little weird for vendor device to
> implement a LE config space with BE ring layout, although still possible.=
..

Right.

Thanks

>
> -Siwei
> >
> > Thanks
> >
> >
> >>
> >>> So if you think we should add a vdpa_ops->get_endian(),
> >>> I will drop these comments in the next version of
> >>> series, and work on a new patch for get_endian().
> >>>
> >>> Thanks,
> >>> Zhu Lingshan
> >> Guests don't get endian-ness from devices so this seems pointless.
> >>
> >
>

