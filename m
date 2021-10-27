Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC0943CCD4
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 16:55:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242637AbhJ0O5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 10:57:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42923 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237296AbhJ0O5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 10:57:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635346527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lp3MKDjnFrSR+4gVc16F4ogHmgYiCOd0YCxbmncoWwI=;
        b=dorPSVyFec5A2TYitO3Xobkwh+V/Gylo6oU2jeJFSWhTs/hL/K2CH7xJvLZycpbcE51kuc
        Aklws4k4iYeTKQykl0vhKfMwtukA0WhiNHWG8ME8DsXHD3Qq0VAJ3cnbL8sP4IedzWlCkg
        UVWWyfnsj8v9g9xw3knchp2RzHVuN3g=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-yLrP7tmXOI6xhcntGqf4jQ-1; Wed, 27 Oct 2021 10:55:26 -0400
X-MC-Unique: yLrP7tmXOI6xhcntGqf4jQ-1
Received: by mail-wm1-f69.google.com with SMTP id y12-20020a1c7d0c000000b0032ccaad73d0so1363891wmc.5
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 07:55:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Lp3MKDjnFrSR+4gVc16F4ogHmgYiCOd0YCxbmncoWwI=;
        b=UHHdxptLXKX13vS6pAhHLwG7BmmdCSboV6nnZcaHi0yrLZfj3Gm+eVJJEi9MOYx5et
         TnNQSL8N8SbvbgH3pptuH7+0JIM1qjCZcMtl5G2Iv2FpzBjh/Yflc7AG3Un6gR2BW1uJ
         FzMTKYIXwYUal//Vhv3pQoxI0130zXEloEAl5i7S4gQDag+DlMxGy+EuAEDc+K69zhVc
         Hu9exC39WqdIFt81JqZ3CnX2ekJcXgTVUavr+ukDbWnfR7tNIXrw9e+R2JufiAASmMvl
         NMu7LzaGErYkbISJTBIt3ba/mFZYpWoAeMwvBxmdlcV8kUzLO6TSIjoWZlVRwnsijGH5
         gX+A==
X-Gm-Message-State: AOAM530dG4HmpHkHHhynA4v9twteB/ufd7B+wlnP7FRRjKn+7tKbZrgz
        VzmNgz8uvfi7+LtQtB7aHCdwhGFrOclsUYf3T22Fxm94LOH79x07YJYMLUew2LeJyAn1qI6VVAu
        UBZMeMv43eAJI0c8f
X-Received: by 2002:a1c:9ad4:: with SMTP id c203mr1620238wme.23.1635346524702;
        Wed, 27 Oct 2021 07:55:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxI361h/ezacALLgptu96Fn+gOJLLfX9nvpCDn8IkWJ2ceM8+0pwmtHwSpwJBQYpLhuQhYzfQ==
X-Received: by 2002:a1c:9ad4:: with SMTP id c203mr1620208wme.23.1635346524471;
        Wed, 27 Oct 2021 07:55:24 -0700 (PDT)
Received: from redhat.com ([2a03:c5c0:207e:a543:72f:c4d1:8911:6346])
        by smtp.gmail.com with ESMTPSA id m3sm103026wrx.52.2021.10.27.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Oct 2021 07:55:23 -0700 (PDT)
Date:   Wed, 27 Oct 2021 10:55:20 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH net-next] net: virtio: use eth_hw_addr_set()
Message-ID: <20211027105137-mutt-send-email-mst@kernel.org>
References: <20211026175634.3198477-1-kuba@kernel.org>
 <20211027032113-mutt-send-email-mst@kernel.org>
 <20211027062640.5d32d7be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027062640.5d32d7be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 06:26:40AM -0700, Jakub Kicinski wrote:
> On Wed, 27 Oct 2021 03:23:17 -0400 Michael S. Tsirkin wrote:
> > > diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> > > index c501b5974aee..b7f35aff8e82 100644
> > > --- a/drivers/net/virtio_net.c
> > > +++ b/drivers/net/virtio_net.c
> > > @@ -3177,12 +3177,16 @@ static int virtnet_probe(struct virtio_device *vdev)
> > >  	dev->max_mtu = MAX_MTU;
> > >  
> > >  	/* Configuration may specify what MAC to use.  Otherwise random. */
> > > -	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC))
> > > +	if (virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
> > > +		u8 addr[MAX_ADDR_LEN];
> > > +
> > >  		virtio_cread_bytes(vdev,
> > >  				   offsetof(struct virtio_net_config, mac),
> > > -				   dev->dev_addr, dev->addr_len);
> > > -	else
> > > +				   addr, dev->addr_len);  
> > 
> > Maybe BUG_ON(dev->addr_len > sizeof addr);
> > 
> > here just to make sure we don't overflow addr silently?
> 
> Since I need to post a v2 and we're talking... can I just use
> eth_hw_addr_set() instead? AFAICT netdev is always allocated with 
> alloc_etherdev_mq() and ->addr_len never changed. Plus there is 
> a number of Ethernet address helpers used so ETH_ALEN is kind of 
> already assumed.


Right. Sure, just document this in the commit log pls.

> > > +		dev_addr_set(dev, addr);
> > > +	} else {
> > >  		eth_hw_addr_random(dev);
> > > +	}
> > >  
> > >  	/* Set up our device-specific information */
> > >  	vi = netdev_priv(dev);

