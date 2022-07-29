Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1013584DF8
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 11:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234515AbiG2JRW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 05:17:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiG2JRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 05:17:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0CD8D60693
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659086240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Xz418y7DeHdQl2NjMO3kFzuatxvu8DMltqTqlpmM7w=;
        b=I4UHrEamORya5DetcwUPWXmxP4seZZK6+2yRFu10Cif9/cNwl04P1OiG6eGJVbuTDzdR5a
        hC12ugmYiFpeVmgPdwVfGOaitYO5dwrQe8/YUZLRjyhZa0A4NW74Ze8F+sXadlM44oIgwj
        pTDX02BuYW/z6l5+TnZbubx+LTXwyPo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-164-wz9QR1bsMz2b7ZUZEtlPWw-1; Fri, 29 Jul 2022 05:17:18 -0400
X-MC-Unique: wz9QR1bsMz2b7ZUZEtlPWw-1
Received: by mail-ej1-f69.google.com with SMTP id hs16-20020a1709073e9000b0072b73a28465so1588051ejc.17
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 02:17:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1Xz418y7DeHdQl2NjMO3kFzuatxvu8DMltqTqlpmM7w=;
        b=psGEk4mWBwPw3U4Ud3nlp64zjVvXriIC5nKdRqFOcg6tVHCAt+JSZX24XOSH9ive4K
         n7kPitDZANmpak0y/g5PpUYLlQ0mzFcHNRNliLubeScgsDpil3BvfnyOEehlUtX1ytZ6
         BOoRvxDGiOlJjQi2KESl8g003+sMcAVEMbWjguVO0RoMIDkR5S+Z0C8+xQRI2yDE3J+i
         KPp99P2DAoBIcq8620IN/9RW092kVVQHEWhBK7gIOJYV+QNzbvHc3cn+rnJJHr3Fsu6s
         ne72vrPjxRMOJ20/EwLbeZaWoWc9ow232yTilC3Xl5d94A/R+D5jHKi4dxHONuTcd2Yb
         pZYQ==
X-Gm-Message-State: AJIora/G24l3vYeLgtatnJH5SVUBbngfJYbtFs5fEtGUzraWbRhVqF9v
        AEKCclBsTpffPGOMzPmBXP6HsYIADzFkn6aM62rTfU76kII4lM6bn3r+1DxDJKxhqtfmi5E1ExO
        2AeqmlpqhpWYWJzSw
X-Received: by 2002:a17:907:75e7:b0:72b:51c6:47a2 with SMTP id jz7-20020a17090775e700b0072b51c647a2mr2169196ejc.147.1659086236594;
        Fri, 29 Jul 2022 02:17:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uN/gs1nJPkDVqaw/s3+VrdvCIZO2VcGD8T7a3ikP7krGYBxWdgjFeV/oKw8/plr0FhJgUrgw==
X-Received: by 2002:a17:907:75e7:b0:72b:51c6:47a2 with SMTP id jz7-20020a17090775e700b0072b51c647a2mr2169166ejc.147.1659086236072;
        Fri, 29 Jul 2022 02:17:16 -0700 (PDT)
Received: from redhat.com ([2.54.183.236])
        by smtp.gmail.com with ESMTPSA id s11-20020a1709064d8b00b006fee526ed72sm1431449eju.217.2022.07.29.02.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jul 2022 02:17:15 -0700 (PDT)
Date:   Fri, 29 Jul 2022 05:17:12 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Zhu, Lingshan" <lingshan.zhu@intel.com>
Cc:     jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, parav@nvidia.com, xieyongji@bytedance.com,
        gautam.dawar@amd.com
Subject: Re: [PATCH V3 6/6] vDPA: fix 'cast to restricted le16' warnings in
 vdpa.c
Message-ID: <20220729051119-mutt-send-email-mst@kernel.org>
References: <20220701132826.8132-1-lingshan.zhu@intel.com>
 <20220701132826.8132-7-lingshan.zhu@intel.com>
 <20220729045039-mutt-send-email-mst@kernel.org>
 <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ce4da7f-80aa-14d6-8200-c7f928f32b48@intel.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 05:07:11PM +0800, Zhu, Lingshan wrote:
> 
> 
> On 7/29/2022 4:53 PM, Michael S. Tsirkin wrote:
> > On Fri, Jul 01, 2022 at 09:28:26PM +0800, Zhu Lingshan wrote:
> > > This commit fixes spars warnings: cast to restricted __le16
> > > in function vdpa_dev_net_config_fill() and
> > > vdpa_fill_stats_rec()
> > > 
> > > Signed-off-by: Zhu Lingshan <lingshan.zhu@intel.com>
> > > ---
> > >   drivers/vdpa/vdpa.c | 6 +++---
> > >   1 file changed, 3 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
> > > index 846dd37f3549..ed49fe46a79e 100644
> > > --- a/drivers/vdpa/vdpa.c
> > > +++ b/drivers/vdpa/vdpa.c
> > > @@ -825,11 +825,11 @@ static int vdpa_dev_net_config_fill(struct vdpa_device *vdev, struct sk_buff *ms
> > >   		    config.mac))
> > >   		return -EMSGSIZE;
> > > -	val_u16 = le16_to_cpu(config.status);
> > > +	val_u16 = __virtio16_to_cpu(true, config.status);
> > >   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_STATUS, val_u16))
> > >   		return -EMSGSIZE;
> > > -	val_u16 = le16_to_cpu(config.mtu);
> > > +	val_u16 = __virtio16_to_cpu(true, config.mtu);
> > >   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MTU, val_u16))
> > >   		return -EMSGSIZE;
> > Wrong on BE platforms with legacy interface, isn't it?
> > We generally don't handle legacy properly in VDPA so it's
> > not a huge deal, but maybe add a comment at least?
> Sure, I can add a comment here: this is for modern devices only.
> 
> Thanks,
> Zhu Lingshan

Hmm. what "this" is for modern devices only here?

> > 
> > 
> > > @@ -911,7 +911,7 @@ static int vdpa_fill_stats_rec(struct vdpa_device *vdev, struct sk_buff *msg,
> > >   	}
> > >   	vdpa_get_config_unlocked(vdev, 0, &config, sizeof(config));
> > > -	max_vqp = le16_to_cpu(config.max_virtqueue_pairs);
> > > +	max_vqp = __virtio16_to_cpu(true, config.max_virtqueue_pairs);
> > >   	if (nla_put_u16(msg, VDPA_ATTR_DEV_NET_CFG_MAX_VQP, max_vqp))
> > >   		return -EMSGSIZE;
> > > -- 
> > > 2.31.1

