Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041AF276D80
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 11:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgIXJbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 05:31:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22975 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgIXJbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 05:31:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600939864;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Cn5Bd+L14KVOkBy3I0zvESfB5G1klOhcdE8jhSzxAk=;
        b=Z3Hm+fNbt4nCbrBGmnf/QWd45S1mq5KPFKKGxULOWOJrmYNGwuavxc81Q0mVg8HkbJ04rL
        pOolHvJxrl0tQUBu+um4C+gTet+pSDh6WNr9JG7GVCWjfgs8cQgcPLqnSOhEkpKeGySEKR
        Mall7cN6tkmAb0RNu0CKYjYDhagj/EA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-107-xztVxcydNmmreiEBmMFxsQ-1; Thu, 24 Sep 2020 05:31:01 -0400
X-MC-Unique: xztVxcydNmmreiEBmMFxsQ-1
Received: by mail-wm1-f70.google.com with SMTP id b14so662619wmj.3
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 02:31:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Cn5Bd+L14KVOkBy3I0zvESfB5G1klOhcdE8jhSzxAk=;
        b=WbOsoFD25bV3UisG7a2h3CEoyZiRiCvuf634h/pc8Zr2DrgFqfsvwQDuw0GFebdAjs
         2VsEPL3sJyw77bS3KkudjCWoQcIXFg/E14UgwtWUIBoDYklpLsYok6VkpNXmQbAgq0v8
         869J45rT3Wc5mFo0bzQyGpCzU/eCJcO3zELGgbEH7YdfO/VfI/fdDUq8NpX3ABirnygr
         91uGbJIF7o/81uH9xGApcX7CMe7uga6YD7U0hcXxuPUExWatOitUtB9vBYVzi56FrpYB
         /D5GAZ8K8pe3pX2IMKXfZG7Bnp0R9RBVFNCLmx5b8Rq5MaGlxSQpopbDIpJDsQAxWpTH
         9Erg==
X-Gm-Message-State: AOAM531cI0wSqIUOnjcclD1m3EVl/KPAlk2m3M+CKE73d7dCyLdqYo4t
        12QymBo16ct5oawbYDmlnshWyJhiajS9oIOBQOe3Gf1xkwBIYG87yEayiiJMYwYRlKDIETArE5g
        blKtUG3NlrWyeHtV+
X-Received: by 2002:adf:dfc9:: with SMTP id q9mr4019268wrn.400.1600939859787;
        Thu, 24 Sep 2020 02:30:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzNr9iTqIQuESzVSCPAV8Mwoq5mFq1pIRj7KbtcjUI1Z0WuhkhVRABCz6hVxbGoGui7GYmBg==
X-Received: by 2002:adf:dfc9:: with SMTP id q9mr4019248wrn.400.1600939859611;
        Thu, 24 Sep 2020 02:30:59 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id p11sm2641023wma.11.2020.09.24.02.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 02:30:58 -0700 (PDT)
Date:   Thu, 24 Sep 2020 05:30:55 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>, Eli Cohen <elic@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200924052932-mutt-send-email-mst@kernel.org>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918082245.GP869610@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 18, 2020 at 11:22:45AM +0300, Leon Romanovsky wrote:
> On Thu, Sep 17, 2020 at 07:35:03PM -0700, Randy Dunlap wrote:
> > From: Randy Dunlap <rdunlap@infradead.org>
> >
> > drivers/vdpa/mlx5/ uses vhost_iotlb*() interfaces, so add a dependency
> > on VHOST to eliminate build errors.
> >
> > ld: drivers/vdpa/mlx5/core/mr.o: in function `add_direct_chain':
> > mr.c:(.text+0x106): undefined reference to `vhost_iotlb_itree_first'
> > ld: mr.c:(.text+0x1cf): undefined reference to `vhost_iotlb_itree_next'
> > ld: mr.c:(.text+0x30d): undefined reference to `vhost_iotlb_itree_first'
> > ld: mr.c:(.text+0x3e8): undefined reference to `vhost_iotlb_itree_next'
> > ld: drivers/vdpa/mlx5/core/mr.o: in function `_mlx5_vdpa_create_mr':
> > mr.c:(.text+0x908): undefined reference to `vhost_iotlb_itree_first'
> > ld: mr.c:(.text+0x9e6): undefined reference to `vhost_iotlb_itree_next'
> > ld: drivers/vdpa/mlx5/core/mr.o: in function `mlx5_vdpa_handle_set_map':
> > mr.c:(.text+0xf1d): undefined reference to `vhost_iotlb_itree_first'
> >
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Cc: Saeed Mahameed <saeedm@nvidia.com>
> > Cc: Leon Romanovsky <leonro@nvidia.com>
> > Cc: netdev@vger.kernel.org
> > ---
> > v2: change from select to depends on VHOST (Saeed)
> > v3: change to depends on VHOST_IOTLB (Jason)
> >
> >  drivers/vdpa/Kconfig |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > +++ linux-next-20200917/drivers/vdpa/Kconfig
> > @@ -31,7 +31,7 @@ config IFCVF
> >
> >  config MLX5_VDPA
> >  	bool "MLX5 VDPA support library for ConnectX devices"
> > -	depends on MLX5_CORE
> > +	depends on VHOST_IOTLB && MLX5_CORE
> >  	default n
> 
> While we are here, can anyone who apply this patch delete the "default n" line?
> It is by default "n".
> 
> Thanks

Hmm other drivers select VHOST_IOTLB, why not do the same?


> >  	help
> >  	  Support library for Mellanox VDPA drivers. Provides code that is
> >

