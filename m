Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8697558E045
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 21:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbiHITgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 15:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344773AbiHITgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 15:36:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 276EF248DB
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 12:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660073767;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=86z9/W88KKlZHXVb1k6E/YXG9z9XRpPQOI7vpeaGWug=;
        b=NlMTdFgByOQKGj0lZI7M9Kkt+YgO4j8YniULQjWSXDbRV6EjRBoDkCPFuIq6G48vwhzc0A
        ML9DVhEInWFcvxvT/5MQKgf0DaiIwzIUrw5IZyalFnq7SWe/8sAt2hudKTIFUTfGKAASc7
        MxpuaiXjarZk9EnyPaxfPGAY/r+jhRI=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-586-sGqX7qwDPHaM-uGhjJ6Jwg-1; Tue, 09 Aug 2022 15:36:06 -0400
X-MC-Unique: sGqX7qwDPHaM-uGhjJ6Jwg-1
Received: by mail-ej1-f71.google.com with SMTP id qk37-20020a1709077fa500b00730c2d975a0so3671934ejc.13
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 12:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=86z9/W88KKlZHXVb1k6E/YXG9z9XRpPQOI7vpeaGWug=;
        b=vqLOkYkBJxROQoKstUY04Bdj6DqVuux0G4vKniyV/T8jemJt//kL90s5x6HH8ed0SZ
         PP7pJzx6jCubE5o3maqKa7ddYqfZxAsdB2LSbBKfMYjsonYbgV5D6VbAerwt0gv/YCbl
         DJLWTJh42VSjTHmv3vqSD80S8JW3RCTUODBeT4E7apb9w3Jxq2P134rEGkd1pgbwhOgm
         S73iIecjgGilHtmL6ueQJik0o5ffwIMn7FLoyoM3As/F1mIapud9og8Fw2484EoM1NgT
         HkgMbSSKsOg1OPf+xnvA+vuMFiuaYUm+rWFynsQGfd8KW+AaC076PRjzEk5wSD960JVv
         kJyw==
X-Gm-Message-State: ACgBeo0jxIcWN43ri9gI2w52E+RevVPvMWhhCNpvKDgw8994sinF0tgz
        mWrec0STiP/ObRIps66rgAX/5krHJU0X3iIAK0mGhHy1pOGiwNx0Q2oWo9/eH84CWWVGnKpyiIa
        KonZ2yXAA/ZwZmG8q
X-Received: by 2002:aa7:d0d8:0:b0:441:4671:49d6 with SMTP id u24-20020aa7d0d8000000b00441467149d6mr3941258edo.252.1660073764940;
        Tue, 09 Aug 2022 12:36:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6SVgSalV0wsmO7HBLIT8305FcJrKLeyl6xNti4dZOesLImI7NiKREUy8wFLzman/e7qzyfUg==
X-Received: by 2002:aa7:d0d8:0:b0:441:4671:49d6 with SMTP id u24-20020aa7d0d8000000b00441467149d6mr3941240edo.252.1660073764751;
        Tue, 09 Aug 2022 12:36:04 -0700 (PDT)
Received: from redhat.com ([2.52.152.113])
        by smtp.gmail.com with ESMTPSA id o15-20020aa7dd4f000000b0043bba5ed21csm6408172edw.15.2022.08.09.12.36.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 12:36:04 -0700 (PDT)
Date:   Tue, 9 Aug 2022 15:36:01 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     Zhu Lingshan <lingshan.zhu@intel.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "xieyongji@bytedance.com" <xieyongji@bytedance.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>
Subject: Re: [PATCH V4 5/6] vDPA: answer num of queue pairs = 1 to userspace
 when VIRTIO_NET_F_MQ == 0
Message-ID: <20220809152457-mutt-send-email-mst@kernel.org>
References: <20220722115309.82746-1-lingshan.zhu@intel.com>
 <20220722115309.82746-6-lingshan.zhu@intel.com>
 <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR12MB5481AC83A7C7B0320D6FB44CDC909@PH0PR12MB5481.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 01:14:42PM +0000, Parav Pandit wrote:
> 
> 
> > From: Zhu Lingshan <lingshan.zhu@intel.com>
> > Sent: Friday, July 22, 2022 7:53 AM
> > 
> > If VIRTIO_NET_F_MQ == 0, the virtio device should have one queue pair, so
> > when userspace querying queue pair numbers, it should return mq=1 than
> > zero.
> > 
> > Function vdpa_dev_net_config_fill() fills the attributions of the vDPA
> > devices, so that it should call vdpa_dev_net_mq_config_fill() so the
> > parameter in vdpa_dev_net_mq_config_fill() should be feature_device than
> > feature_driver for the vDPA devices themselves
> > 
> > Before this change, when MQ = 0, iproute2 output:
> > $vdpa dev config show vdpa0
> > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 0
> > mtu 1500
> > 
> > After applying this commit, when MQ = 0, iproute2 output:
> > $vdpa dev config show vdpa0
> > vdpa0: mac 00:e8:ca:11:be:05 link up link_announce false max_vq_pairs 1
> > mtu 1500
> > 
> No. We do not want to diverge returning values of config space for fields which are not present as discussed in previous versions.
> Please drop this patch.
> Nack on this patch.

Wrt this patch as far as I'm concerned you guys are bikeshedding.

Parav generally don't send nacks please they are not helpful.

Zhu Lingshan please always address comments in some way.  E.g. refer to
them in the commit log explaining the motivation and the alternatives.
I know you don't agree with Parav but ghosting isn't nice.

I still feel what we should have done is
not return a value, as long as we do return it we might
as well return something reasonable, not 0.

And I like it that this fixes sparse warning actually:
max_virtqueue_pairs it tagged as __virtio, not __le.

However, I am worried there is another bug here:
this is checking driver features. But really max vqs
should not depend on that, it depends on device
features, no?



> > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > ---
> >  drivers/vdpa/vdpa.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c index
> > d76b22b2f7ae..846dd37f3549 100644
> > --- a/drivers/vdpa/vdpa.c
> > +++ b/drivers/vdpa/vdpa.c
> > @@ -806,9 +806,10 @@ static int vdpa_dev_net_mq_config_fill(struct
> > vdpa_device *vdev,
> >  	u16 val_u16;
> > 
> >  	if ((features & BIT_ULL(VIRTIO_NET_F_MQ)) == 0)
> > -		return 0;
> > +		val_u16 = 1;
> > +	else
> > +		val_u16 = __virtio16_to_cpu(true, config-
> > >max_virtqueue_pairs);
> > 
> > -	val_u16 = le16_to_cpu(config->max_virtqueue_pairs);
> >  	return nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> > val_u16);  }
> > 
> > @@ -842,7 +843,7 @@ static int vdpa_dev_net_config_fill(struct
> > vdpa_device *vdev, struct sk_buff *ms
> >  			      VDPA_ATTR_PAD))
> >  		return -EMSGSIZE;
> > 
> > -	return vdpa_dev_net_mq_config_fill(vdev, msg, features_driver,
> > &config);
> > +	return vdpa_dev_net_mq_config_fill(vdev, msg, features_device,
> > +&config);
> >  }
> > 
> >  static int
> > --
> > 2.31.1

