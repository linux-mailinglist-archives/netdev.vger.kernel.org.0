Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212C658E45C
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 03:10:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbiHJBJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 21:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiHJBJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 21:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7237465834
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 18:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660093783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ealoktxzQvMvoaVETXyzPEIriQf2QjBNBkFv9OiTEac=;
        b=H83D/R4Ps96JqvuwZmmzZ3usu78C7Nh7z3WUXzp4O8k9eCDp5KYVC8hKcKxGyEO+97PQ97
        YRm+HQ61Roje/FKl253ELMDyXjdO3QYbmBVqzEc71ZVkic5guMe7d9FFt5A7B2LOvYiSwu
        U7H1+8UnUTioqX0g/NE3t/vCUzGvLJs=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-22-va8_r6DkNGeohXR9eN0Nog-1; Tue, 09 Aug 2022 21:09:42 -0400
X-MC-Unique: va8_r6DkNGeohXR9eN0Nog-1
Received: by mail-lj1-f198.google.com with SMTP id u14-20020a2e844e000000b0025fbbfc610dso2387158ljh.6
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 18:09:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ealoktxzQvMvoaVETXyzPEIriQf2QjBNBkFv9OiTEac=;
        b=qSY8f8p2UIqWgucvZI9IDpQj33LBUP8ZY215v0K4b2xXdNvbExczk2p8L3Mu7kAfu9
         79viyjxH2hbQi69RG342tX6FYt2ORRziXxBLV/xoUu6NOuIUQJY5mMDgTdm13qrXoxju
         FDfziqBkrtSQwrImnECC8xzXZreh4aU9XzdHo2l49byFcPlJqzPpGzfWTxlNSvIozPie
         dVnnxt6LMgfGLZUO3I00doiuzkGpl/kAPrnM2RbVckvojOVyD5psz+G1IpRSV6Ay4E/l
         dMm1SIiffpPA5EIdfyQX7B4Nwl3kufly354/7MRrz5fFYzG777zDETZWONWRBfO80KnD
         ydFg==
X-Gm-Message-State: ACgBeo2/R+4rNDuagRXy9dpeVWK3zKFgxmqYiQYMmuWCsLOngs3qcoUW
        v0UoofIQH20I4CoOpX79sNEtUD3y2UP3fdQ8fEZulrY//83q/Tsho1ZXN1elkQ6zy6n3yvBgxXD
        J3gWdceaC0Ivs9MVZ8fcBEyj7q8fEvlzs
X-Received: by 2002:a05:6512:1594:b0:48d:25f2:a6d5 with SMTP id bp20-20020a056512159400b0048d25f2a6d5mr149949lfb.238.1660093780779;
        Tue, 09 Aug 2022 18:09:40 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6ZXM7tanNj9gTDHG0dFEK/yhr44bnYG5GLApfvvrxcQrT6B6gKB1dcdR8U6qr4EzRa0V7N7TmAUNPXbfbfZu8=
X-Received: by 2002:a05:6512:1594:b0:48d:25f2:a6d5 with SMTP id
 bp20-20020a056512159400b0048d25f2a6d5mr149942lfb.238.1660093780576; Tue, 09
 Aug 2022 18:09:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com> <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220809152457-mutt-send-email-mst@kernel.org> <42e6d45b-4fba-1c8e-1726-3f082dd7a629@oracle.com>
In-Reply-To: <42e6d45b-4fba-1c8e-1726-3f082dd7a629@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Wed, 10 Aug 2022 09:09:29 +0800
Message-ID: <CACGkMEuSY=se+CnsiwH2BdaAv3Eu7L=-xJED-wSNiDwCP9RRXQ@mail.gmail.com>
Subject: Re: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
To:     Si-Wei Liu <si-wei.liu@oracle.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 10, 2022 at 8:54 AM Si-Wei Liu <si-wei.liu@oracle.com> wrote:
>
>
>
> On 8/9/2022 12:36 PM, Michael S. Tsirkin wrote:
> > On Fri, Jul 22, 2022 at 01:14:42PM +0000, Parav Pandit wrote:
> >>
> >>> From: Zhu Lingshan <lingshan.zhu@intel.com>
> >>> Sent: Friday, July 22, 2022 7:53 AM
> >>>
> >>> If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
> >>> when userspace querying queue pair numbers, it should return mq=1 than
> >>> zero.
> >>>
> >>> Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
> >>> devices, so that it should call vdpa_dev_net_mq_config_fill() so the
> >>> parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
> >>> feature_driver for the vDPA devices themselves
> >>>
> >>> Before this change, when MQ = 0, iproute2 output:
> >>> $vdpa dev config show vdpa0
> >>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
> >>> mtu 1500
> >>>
> >>> After applying this commit, when MQ = 0, iproute2 output:
> >>> $vdpa dev config show vdpa0
> >>> vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
> >>> mtu 1500
> >>>
> >> No. We do not want to diverge returning values of config space for fields which are not present as discussed in previous versions.
> >> Please drop this patch.
> >> Nack on this patch.
> > Wrt this patch as far as I'm concerned you guys are bikeshedding.
> >
> > Parav generally don't send nacks please they are not helpful.
> >
> > Zhu Lingshan please always address comments in some way.  E.g. refer to
> > them in the commit log explaining the motivation and the alternatives.
> > I know you don't agree with Parav but ghosting isn't nice.
> >
> > I still feel what we should have done is
> > not return a value, as long as we do return it we might
> > as well return something reasonable, not 0.
> Maybe I missed something but I don't get this, when VIRTIO_NET_F_MQ is
> not negotiated, the VDPA_ATTR_DEV_NET_CFG_MAX_VQP attribute is simply
> not there, but userspace (iproute) mistakenly puts a zero value there.
> This is a pattern every tool in iproute follows consistently by large. I
> don't get why kernel has to return something without seeing a very
> convincing use case?
>
> Not to mention spec doesn't give us explicit definition for when the
> field in config space becomes valid and/or the default value at first
> sights as part of feature negotiation. If we want to stick to the model
> Lingshan proposed, maybe fix the spec first then get back on the details?

So spec said

"
The following driver-read-only field, max_virtqueue_pairs only exists
if VIRTIO_NET_F_MQ or VIRTIO_NET_F_RSS is set.
"

My understanding is that the field is always valid if the device
offers the feature.

Btw, even if the spec is unclear, it would be very hard to "fix" it
without introducing a new feature bit, it means we still need to deal
with device without the new feature.

Thanks

>
> -Siwei
>
> >
> > And I like it that this fixes sparse warning actually:
> > max_virtqueue_pairs it tagged as __virtio, not __le.
> >
> > However, I am worried there is another bug here:
> > this is checking driver features. But really max vqs
> > should not depend on that, it depends on device
> > features, no?
> >
> >
> >
> >>> Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> >>> ---
> >>>   drivers/vdpa/vdpa.c | 7 ++++---
> >>>   1 file changed, 4 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> >>> d76b22b2f7ae..846dd37f3549 100644
> >>> --- a/drivers/vdpa/vdpa.c
> >>> +++ b/drivers/vdpa/vdpa.c
> >>> @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
> >>> vdpa_device *vdev,
> >>>     u16 val_u16;
> >>>
> >>>     if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> >>> -           return 0;
> >>> +           val_u16 = 1;
> >>> +   else
> >>> +           val_u16 = __virtio16_to_cpu(true, config-
> >>>> max_virtqueue_pairs);
> >>> -   val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> >>>     return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> >>> val_u16);  }
> >>>
> >>> @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
> >>> vdpa_device *vdev, struct sk_buff *ms
> >>>                           VDPA_ATTR_PAD))
> >>>             return -EMSGSIZE;
> >>>
> >>> -   return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
> >>> &config);
> >>> +   return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
> >>> +&config);
> >>>   }
> >>>
> >>>   static int
> >>> --
> >>> 2.31.1
> > _______________________________________________
> > Virtualization mailing list
> > Virtualization@lists.linux-foundation.org
> > https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>
> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
>

