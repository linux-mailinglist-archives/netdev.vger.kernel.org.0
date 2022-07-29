Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15182584E00
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234937AbiG2JXR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:23:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiG2JXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:23:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4B3D664C5
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659086594;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oUdBoqQQwUbtvsfCW4fni3GA77RjAGhoP1Nsc9jk5ic=;
        b=eVsG6AZfQfD49aKMRKHuO7H1/X0a+qzQjkycGaWTz07y7UrzufEvd02hSq3fnyVAYaRSBe
        TeiPShMVsZ/68Mfnxxqwp/s7ZM+DUPxvurCkqoLaPwclX+xG9g4l2HHqHJ7/ArQ1xlVS2p
        4fCLUDHZ5Axmrs9BluXeF4kQZusb1EY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-s8iUTK4JNKyGfOgPoi9iHA-1; Fri, 29 Jul 2022 05:23:12 -0400
X-MC-Unique: s8iUTK4JNKyGfOgPoi9iHA-1
Received: by mail-wr1-f70.google.com with SMTP id w17-20020adfbad1000000b0021f0acd5398so948250wrg.1
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:23:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=oUdBoqQQwUbtvsfCW4fni3GA77RjAGhoP1Nsc9jk5ic=;
        b=nZsMSKiwBrD80+TYvbE74eil9mUoWgpuBa78Zk61BuzsKVmC8wDANkpK+m9Hasf+3b
         F5gGnNMFGxBFjLIdx5mgW9aCC1DPPWe7iy88bdiPHNLuUZwylqbaTjmjBvRbklFD8uZt
         hIAtzO9+ZQB54ku8irGhEgB2tXclbxl3eS5TIYUwdfTmLuY+1tS+4RtXhYKNmK0VIGkh
         MwAEYv2C6m5RbOlzjEjfgxmMl6rJbN03wOwju0ReXa5jbDiD3eMdHy+o4PrbLZc6KkKc
         hvfptaDQGuWsCTsjLSlxue1AXZvvru9ItSu83iFeg+wdAkfLtcsMCVl6mB25Xyc8pKQQ
         JMaQ==
X-Gm-Message-State: ACgBeo2vTJNqjx0d2W9fQN1Xc/c7C968mBCoAatINc+rg4kzfmNE80F2
        F3V3kmpDHRb75Pt3gK4T4V1dNh1iuH1yVa4o70+z6bHm3kifKoL+mMci/LHSLzplw5lIoEs6q4J
        AbpukUNiwzmbMMV3J
X-Received: by 2002:a05:6000:15c3:b0:21d:9f8b:2c3e with SMTP id y3-20020a05600015c300b0021d9f8b2c3emr1849915wry.72.1659086591504;
        Fri, 29 Jul 2022 02:23:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7FTu+5JLpQjx+VA3oidZ9+QsK896x0RakIZgfjw1iE6x88yNMooC2rjY7ywdS8cVawU+4U1g==
X-Received: by 2002:a05:6000:15c3:b0:21d:9f8b:2c3e with SMTP id y3-20020a05600015c300b0021d9f8b2c3emr1849896wry.72.1659086591261;
        Fri, 29 Jul 2022 02:23:11 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id k18-20020a5d6d52000000b0021f0c05859esm2537511wri.71.2022.07.29.02.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 02:23:10 -0700 (PDT)
Date:   Fri, 29 Jul 2022 05:23:07 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Message-ID: <20220729052149-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
 <20220729051119-mutt-send-email-mst@kernel.org>
 <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50b4e7ba-3e49-24b7-5c23-d8a76c61c924@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 05:20:17PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 7/29/2022 5:17 PM, Michael S. Tsirkin wrote:
> > On Fri, Jul 29, 2022 at 05:07:11PM +0800, Zhu, Lingshan wrote:
> > > 
> > > On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
> > > > On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
> > > > > This commit fixes spars warnings: cast to restricted __le16
> > > > > in function vdpa_dev_net_config_fill() and
> > > > > vdpa_fill_stats_rec()
> > > > > 
> > > > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > > > ---
> > > > >    drivers/vdpa/vdpa.c | 6 +++---
> > > > >    1 file changed, 3 insertions(+), 3 deletions(-)
> > > > > 
> > > > > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > > > > index 846dd37f3549..ed49fe46a79e 100644
> > > > > --- a/drivers/vdpa/vdpa.c
> > > > > +++ b/drivers/vdpa/vdpa.c
> > > > > @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> > > > >    		    config.mac))
> > > > >    		return -EMSGSIZE;
> > > > > -	val_u16 = le16_to_cpu(config.status);
> > > > > +	val_u16 = __virtio16_to_cpu(true, config.status);
> > > > >    	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > > > >    		return -EMSGSIZE;
> > > > > -	val_u16 = le16_to_cpu(config.mtu);
> > > > > +	val_u16 = __virtio16_to_cpu(true, config.mtu);
> > > > >    	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > > > >    		return -EMSGSIZE;
> > > > Wrong on BE platforms with legacy interface, isn't it?
> > > > We generally don't handle legacy properly in VDPA so it's
> > > > not a huge deal, but maybe add a comment at least?
> > > Sure, I can add a comment here: this is for modern devices only.
> > > 
> > > Thanks,
> > > Zhu Lingshan
> > Hmm. what "this" is for modern devices only here?
> this cast, for LE modern devices.

I think status existed in legacy for sure, and it's possible that
some legacy devices backported mtu and max_virtqueue_pairs otherwise
we would have these fields as __le not as __virtio, right?

> > 
> > > > 
> > > > > @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
> > > > >    	}
> > > > >    	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > > > > -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
> > > > > +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
> > > > >    	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
> > > > >    		return -EMSGSIZE;
> > > > > -- 
> > > > > 2.31.1

