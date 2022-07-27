Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE40582088
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 08:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiG0G4j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 02:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiG0G4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 02:56:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AA918237D9
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658904996;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=APkoBX4cQj/9DCAu9+1UJTMMx3KoQtqmKQn9C5jb7ac=;
        b=EobJJzM2+0OQ3+AooI3NTnrjR70vybcJgj0OindOkmscRI/bmQS0496mRKf6P2y8zmW6XE
        WgUkM8l8xV2KPIWW2VijEoG78Or9Bt8HvHC/QQAcmETyuHDMDKl/X1mehGGSBKjZ612gMD
        whj0L6ORT2UffrDhA8zS4RLmLhUv3wg=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-386-VaTTJk97O_2JI77ISap2RA-1; Wed, 27 Jul 2022 02:56:35 -0400
X-MC-Unique: VaTTJk97O_2JI77ISap2RA-1
Received: by mail-ed1-f69.google.com with SMTP id b15-20020a056402278f00b0043acaf76f8dso10289579ede.21
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 23:56:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=APkoBX4cQj/9DCAu9+1UJTMMx3KoQtqmKQn9C5jb7ac=;
        b=n+9sFls3PRQV4A1ayoi0V9T9c19g+jxpBfDZlOMuG6PfUO5wLi1niKCPXa5mxuB1kQ
         snvMGima05QYc8lMh9d0JU5scBBHIDPqdHM2z8wUX4InTQBfOMuLgRbMPTDpFTePCSUh
         TzYggCv39BIOk4lwROuCOAIPgNNeGSfDA6vBwtl1m2pZuVMvk3QuU6nGPO1Q0tFTMt6Y
         GK3fREonx9Xi0lrisQTmlNnYZgqowhrMnaPZVicRMsavIrEtWdetcw5ge2kiWP/ZKmEm
         jBmeMYM+jEsBNN6SqLlJQzwn15Gfs/k5VvccqqaswfQQPmvIWe7wu/g7WK7QViom10cT
         /E6A==
X-Gm-Message-State: AJIora8q4Scdlo8rNiBqPUZW1Mr5qWsKTGFelGQHGQOBk9e5/NqtMlYI
        gMGK8oe8+Jjl0hvGGeJkZWO/swJ2SW8of8m+elhvuggjbGaKq08ZNbbW70CX49XloTqrksKjDk1
        Eqv3hBX3K2nH7lwN/twBGkZTMwDQYpT/T
X-Received: by 2002:a17:907:a063:b0:72b:52f7:feea with SMTP id ia3-20020a170907a06300b0072b52f7feeamr16931232ejc.740.1658904993342;
        Tue, 26 Jul 2022 23:56:33 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1scCDeYSSG44gop/1/rwLxefBodsTh0sh15M1i+xTC+eNc9SkxzgG/fuzFlLCjkb+b91KSsVBYkPZFhgRi2GH0=
X-Received: by 2002:a17:907:a063:b0:72b:52f7:feea with SMTP id
 ia3-20020a170907a06300b0072b52f7feeamr16931172ejc.740.1658904992006; Tue, 26
 Jul 2022 23:56:32 -0700 (PDT)
MIME-Version: 1.0
References: <00c1f5e8-e58d-5af7-cc6b-b29398e17c8b@intel.com>
 <PH0PR12MB54817863E7BA89D6BB5A5F8CDC869@PH0PR12MB5481.namprd12.prod.outlook.com>
 <c7c8f49c-484f-f5b3-39e6-0d17f396cca7@intel.com> <PH0PR12MB5481E65037E0B4F6F583193BDC899@PH0PR12MB5481.namprd12.prod.outlook.com>
 <1246d2f1-2822-0edb-cd57-efc4015f05a2@intel.com> <PH0PR12MB54815985C202E81122459DFFDC949@PH0PR12MB5481.namprd12.prod.outlook.com>
 <19681358-fc81-be5b-c20b-7394a549f0be@intel.com> <PH0PR12MB54818158D4F7F9F556022857DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <e98fc062-021b-848b-5cf4-15bd63a11c5c@intel.com> <PH0PR12MB54815AD7D0674FEB1D63EB61DC979@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220727015626-mutt-send-email-mst@kernel.org> <4925d1db-51d1-148a-72e0-2347b20e82f4@intel.com>
In-Reply-To: <4925d1db-51d1-148a-72e0-2347b20e82f4@intel.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 27 Jul 2022 14:56:20 +0800
Message-ID: <CACGkMEsXLhhLhyfPwc=Sif=iy1wE3zm6sKWQxvO3cyuM547+zw@mail.gmail.com>
Subject: Re: [PATCH V3 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 27, 2022 at 2:26 PM Zhu, Lingshan <lingshan.zhu@intel.com> wrot=
e:
>
>
>
> On 7/27/2022 2:01 PM, Michael S. Tsirkin wrote:
> > On Wed, Jul 27, 2022 at 03:47:35AM +0000, Parav Pandit wrote:
> >>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>> Sent: Tuesday, July 26, 2022 10:53 PM
> >>>
> >>> On 7/27/2022 10:17 AM, Parav Pandit wrote:
> >>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>>>> Sent: Tuesday, July 26, 2022 10:15 PM
> >>>>>
> >>>>> On 7/26/2022 11:56 PM, Parav Pandit wrote:
> >>>>>>> From: Zhu, Lingshan <lingshan.zhu@intel.com>
> >>>>>>> Sent: Tuesday, July 12, 2022 11:46 PM
> >>>>>>>> When the user space which invokes netlink commands, detects that
> >>>>> _MQ
> >>>>>>> is not supported, hence it takes max_queue_pair =3D 1 by itself.
> >>>>>>> I think the kernel module have all necessary information and it i=
s
> >>>>>>> the only one which have precise information of a device, so it
> >>>>>>> should answer precisely than let the user space guess. The kernel
> >>>>>>> module should be reliable than stay silent, leave the question to
> >>>>>>> the user space
> >>>>> tool.
> >>>>>> Kernel is reliable. It doesn=E2=80=99t expose a config space field=
 if the
> >>>>>> field doesn=E2=80=99t
> >>>>> exist regardless of field should have default or no default.
> >>>>> so when you know it is one queue pair, you should answer one, not t=
ry
> >>>>> to guess.
> >>>>>> User space should not guess either. User space gets to see if _MQ
> >>>>> present/not present. If _MQ present than get reliable data from ker=
nel.
> >>>>>> If _MQ not present, it means this device has one VQ pair.
> >>>>> it is still a guess, right? And all user space tools implemented th=
is
> >>>>> feature need to guess
> >>>> No. it is not a guess.
> >>>> It is explicitly checking the _MQ feature and deriving the value.
> >>>> The code you proposed will be present in the user space.
> >>>> It will be uniform for _MQ and 10 other features that are present no=
w and
> >>> in the future.
> >>> MQ and other features like RSS are different. If there is no _RSS_XX,=
 there
> >>> are no attributes like max_rss_key_size, and there is not a default v=
alue.
> >>> But for MQ, we know it has to be 1 wihtout _MQ.
> >> "we" =3D user space.
> >> To keep the consistency among all the config space fields.
> > Actually I looked and the code some more and I'm puzzled:
> I can submit a fix in my next version patch for these issue.
> >
> >
> >       struct virtio_net_config config =3D {};
> >       u64 features;
> >       u16 val_u16;
> >
> >       vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> >
> >       if (nla_put(msg, VDPA_ATTR_DEV_NET_CFG_MACADDR, sizeof(config.mac=
),
> >                   config.mac))
> >               return -EMSGSIZE;
> >
> >
> > Mac returned even without VIRTIO_NET_F_MAC
> if no VIRTIO_NET_F_MAC, we should not nla_put
> VDPA_ATTR_DEV_NET_CFG_MAC_ADDR, the spec says the driver should generate
> a random mac.

It's probably too late to do this. Most of the parents have this
feature support, so probably not a real issue.

> >
> >
> >       val_u16 =3D le16_to_cpu(config.status);
> >       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> >               return -EMSGSIZE;
> >
> >
> > status returned even without VIRTIO_NET_F_STATUS
> if no VIRTIO_NET_F_STATUS, we should not nla_put
> VDPA_ATTR_DEV_NET_STATUS, the spec says the driver should assume the
> link is active.

Somehow similar to F_MAC. But we can report if F_MAC is not negotiated.


> >
> >       val_u16 =3D le16_to_cpu(config.mtu);
> >       if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> >               return -EMSGSIZE;
> >
> >
> > MTU returned even without VIRTIO_NET_F_MTU
> same as above, the spec says config.mtu depends on VIRTIO_NET_F_MTU, so
> without this feature bit, we should not return MTU to the userspace.

Not a big issue, we just need to make sure the parent can report a
correct MTU here.

Thanks

>
> Does these fix look good to you?
>
> And I think we may need your adjudication for the two issues:
> (1) Shall we answer max_vq_paris =3D 1 when _MQ not exist, I know you hav=
e
> agreed on this in a previous thread, its nice to clarify
> (2) I think we should not re-use the netlink attr to report feature bits
> of both the management device and the vDPA device,
> this can lead to a new race condition, there are no locks(especially
> distributed locks for kernel_space and user_space) in the nla_put
> functions. Re-using the attr is some kind of breaking the netlink
> lockless design.
>
> Thanks,
> Zhu Lingshan
> >
> >
> > What's going on here?
> >
> >
>

