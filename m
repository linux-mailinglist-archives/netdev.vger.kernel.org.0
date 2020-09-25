Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4CC2784EA
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 12:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728093AbgIYKTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 06:19:40 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35163 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727290AbgIYKTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 06:19:39 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601029178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=P26OWL3+8b1prUkCt7qDotBrREGjXGjJKCeLvVKhHiw=;
        b=Zpvffw5eBL12N5/U4yskXrqzyniknqzcQKFBfxD1AVjfDvQl/mcRvw37V6FzkXbr0NF9u9
        kbZbxkmBdDx0Qo57eYKLm/eDdvLjQ9qWy08MP/J1KBr6x16soBWgSR88DAd4AI9aOsMvAd
        luigpYUPInLzaNGaihXE+ylhs2N8+f8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-RWhHmXANNOu7Ne3GItNatw-1; Fri, 25 Sep 2020 06:19:36 -0400
X-MC-Unique: RWhHmXANNOu7Ne3GItNatw-1
Received: by mail-wr1-f69.google.com with SMTP id y3so880854wrl.21
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 03:19:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=P26OWL3+8b1prUkCt7qDotBrREGjXGjJKCeLvVKhHiw=;
        b=LHHauwTQD5VuIxskkDyImm4Y+iJM7x9VW3d5V3q98K5sqNbhpKB04GtwpWCHc675y0
         Gic91zWFf+niOH1Qr0lmYig8MF7nbnc2fBEfbzbi1bFSWBJmR4wTpjunRzdgVzqPQeoe
         MlUz3zoWM0xXfM0SI6WjHBpzeBKliFemA/ko2RUX/gCiZBjM9wMzSaLtMul4YXQD35Ja
         azVQVdRrFoUNdpZL2S1446X274Kfq7QDirKNyqrf/PSUhjDd9a9aKQCwvYqh8wD7KTjW
         fZ+gTIuBXTWjPzIrsDOdvHvTJAF6Z2CNzU3COtKkVWQIyS4j7VxeRsbjUoWT9waiINhr
         cQzA==
X-Gm-Message-State: AOAM533Y7Op2ZnhTT7dWwXGrsWTMfK7XJWSKbuTLNGIFEb7vJo3k9fbc
        pLhxYxdPhZPhyqLRqljFlNn7JmM7DoCKz46G9r4afZWkOGq5y9wR/dDx7OMnKua+uAo0Mrk4Iux
        bKbGWEyFR9R8MGkKA
X-Received: by 2002:a5d:470f:: with SMTP id y15mr3625815wrq.420.1601029175427;
        Fri, 25 Sep 2020 03:19:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwLSbI9jm2XMOk+32xte7rC7OY1SRWmEug56SJmm4FkGi+zaNWLZhe1WA4eNqffhuABgGE01g==
X-Received: by 2002:a5d:470f:: with SMTP id y15mr3625796wrq.420.1601029175219;
        Fri, 25 Sep 2020 03:19:35 -0700 (PDT)
Received: from redhat.com (bzq-79-179-71-128.red.bezeqint.net. [79.179.71.128])
        by smtp.gmail.com with ESMTPSA id u126sm2972203wmu.9.2020.09.25.03.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 03:19:34 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:19:30 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, Eli Cohen <elic@nvidia.com>,
        virtualization@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH v3 -next] vdpa: mlx5: change Kconfig depends to fix build
 errors
Message-ID: <20200925061847-mutt-send-email-mst@kernel.org>
References: <73f7e48b-8d16-6b20-07d3-41dee0e3d3bd@infradead.org>
 <20200918082245.GP869610@unreal>
 <20200924052932-mutt-send-email-mst@kernel.org>
 <20200924102413.GD170403@mtl-vdi-166.wap.labs.mlnx>
 <079c831e-214d-22c1-028e-05d84e3b7f04@infradead.org>
 <20200924120217-mutt-send-email-mst@kernel.org>
 <20200925072005.GB2280698@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925072005.GB2280698@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 10:20:05AM +0300, Leon Romanovsky wrote:
> On Thu, Sep 24, 2020 at 12:02:43PM -0400, Michael S. Tsirkin wrote:
> > On Thu, Sep 24, 2020 at 08:47:05AM -0700, Randy Dunlap wrote:
> > > On 9/24/20 3:24 AM, Eli Cohen wrote:
> > > > On Thu, Sep 24, 2020 at 05:30:55AM -0400, Michael S. Tsirkin wrote:
> > > >>>> --- linux-next-20200917.orig/drivers/vdpa/Kconfig
> > > >>>> +++ linux-next-20200917/drivers/vdpa/Kconfig
> > > >>>> @@ -31,7 +31,7 @@ config IFCVF
> > > >>>>
> > > >>>>  config MLX5_VDPA
> > > >>>>  	bool "MLX5 VDPA support library for ConnectX devices"
> > > >>>> -	depends on MLX5_CORE
> > > >>>> +	depends on VHOST_IOTLB && MLX5_CORE
> > > >>>>  	default n
> > > >>>
> > > >>> While we are here, can anyone who apply this patch delete the "default n" line?
> > > >>> It is by default "n".
> > > >
> > > > I can do that
> > > >
> > > >>>
> > > >>> Thanks
> > > >>
> > > >> Hmm other drivers select VHOST_IOTLB, why not do the same?
> > >
> > > v1 used select, but Saeed requested use of depends instead because
> > > select can cause problems.
> > >
> > > > I can't see another driver doing that. Perhaps I can set dependency on
> > > > VHOST which by itself depends on VHOST_IOTLB?
> > > >>
> > > >>
> > > >>>>  	help
> > > >>>>  	  Support library for Mellanox VDPA drivers. Provides code that is
> > > >>>>
> > > >>
> > >
> >
> > Saeed what kind of problems? It's used with select in other places,
> > isn't it?
> 
> IMHO, "depends" is much more explicit than "select".
> 
> Thanks

This is now how VHOST_IOTLB has been designed though.
If you want to change VHOST_IOTLB to depends I think
we should do it consistently all over.


config VHOST_IOTLB
        tristate
        help
          Generic IOTLB implementation for vhost and vringh.
          This option is selected by any driver which needs to support
          an IOMMU in software.


> >
> > > --
> > > ~Randy
> >

