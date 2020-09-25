Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0309D2784F0
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgIYKUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:20:55 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728108AbgIYKUx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 06:20:53 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601029252;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=48xx0Uut3LVoJnoZFThGUUKIIpJdqctVHSD98zIttUE=;
        b=f9Z6KwH8tLKCPioErGuyPA/oceXVYdvqpKA32NfhlpZMthnTyYf5F6fy8RIBbrbpzCPhms
        J54tYsGr22pz4oD3d3RHmBUPgDpTVpA59QwBj8iWE7mY4AFtuxneZ8SXx9aPf5vMoFI5hY
        E9wTUgtfWVaMCLHH3SE5qr2AQAuHGU0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-VuM0sAC6PPyYiije_Bj0kw-1; Fri, 25 Sep 2020 06:20:50 -0400
X-MC-Unique: VuM0sAC6PPyYiije_Bj0kw-1
Received: by mail-wr1-f72.google.com with SMTP id s8so885286wrb.15
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 03:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=48xx0Uut3LVoJnoZFThGUUKIIpJdqctVHSD98zIttUE=;
        b=KuFfjUw3DK65h05+9254/UuaaeeZBexMgFj0r9hK7kXAjSByOy4Q4OjIdkKZaapx6P
         CP9qj6etkfu5PbTVGF7NrnKXNe9lo80n5/u9VRDoIOO3et1TbsHA0Bs2q7Br9WjhndWj
         wFPiYKYgAy3IhosI6mOVSYPi+okUfF3SouWgL7ZlYmLyUD3+9BkdMBe0/lL4qAdbpM7b
         xC5GoyoDRxPGxb++WHjFolm3C0j96uLJXMz6ld+l8DkeYmBpaWJ28jjSbWtcTQbIffyK
         pZrXI4jJF2ZOjSD6wLynzENDbKflxeD4Gle4THrlMvRzQ0dK5Jbz2CslfWQoy7cl6S/P
         AvnQ==
X-Gm-Message-State: AOAM532Q/nvDrl2UvGsSml59+8spnoxqXGuQE8OpEX0n4XKJlUBhBTUj
        kYn8dkw2SG1Hc55xMzq7WsoH2QYqqG5CXlQKNVy3cKrl4FnsSpHtX4NA4qXv1poTInUlbnBnrDV
        HcLzTQNuVh2SxYO1N
X-Received: by 2002:adf:f852:: with SMTP id d18mr3656012wrq.245.1601029249079;
        Fri, 25 Sep 2020 03:20:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxfMtavSYQxA31Pq1uMCBQpG6U2aRGi/O/F7xWqzFa0O7KFif6IR4vB7jEML7xD/6dY5K4Wow==
X-Received: by 2002:adf:f852:: with SMTP id d18mr3655999wrq.245.1601029248922;
        Fri, 25 Sep 2020 03:20:48 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id v4sm2244377wml.46.2020.09.25.03.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 03:20:48 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:20:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200925061959-mutt-send-email-mst@kernel.org>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 01:24:13PM +0300, Eli Cohen wrote:
> On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> > > > --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > > > +++ linux-next-20200917/drivers/vdpa/Kconfig
> > > > @@ -31,7 +31,7 @@ config IFCVF
> > > >
> > > >  config MLX5_VDPA
> > > >  	bool "MLX5 VDPA support library for ConnectX devices"
> > > > -	depends on MLX5_CORE
> > > > +	depends on VHOST_IOTLB && MLX5_CORE
> > > >  	default n
> > > 
> > > While we are here, can anyone who apply this patch delete the "default n" line?
> > > It is by default "n".
> 
> I can do that
> 
> > > 
> > > Thanks
> > 
> > Hmm other drivers select VHOST_IOTLB, why not do the same?
> 
> I can't see another driver doing that.

Well grep VHOST_IOTLB and you will see some examples.

> Perhaps I can set dependency on
> VHOST which by itself depends on VHOST_IOTLB?

VHOST is processing virtio in the kernel. You don't really need that
for mlx, do you?

> > 
> > 
> > > >  	help
> > > >  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > >
> > 

