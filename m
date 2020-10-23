Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7813829773C
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1755066AbgJWSsY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:48:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755062AbgJWSsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 14:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rzTfua3GRk/XGy07dLFNryvhTBOBJk20cb003sHqSlA=;
        b=brDuHLvtEw81PK348zJ4olqFmGEuOIr0zU9GdveA9moU7uMAMogsz2sXBian0GIlP2gb/n
        i7Eh83nTBB5/GbjY0FJOnWtJN2SQCrjKHndldYFz9JYK9lS/hWUXfNOifOWNnagjriUFqR
        VpWLzmZWzZTxv1ddJESx1usHl2eWgSE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-535-WvwD6yT6PDeeo2H_xV5nIQ-1; Fri, 23 Oct 2020 14:48:20 -0400
X-MC-Unique: WvwD6yT6PDeeo2H_xV5nIQ-1
Received: by mail-wr1-f72.google.com with SMTP id x16so919269wrg.7
        for <netdev@vger.kernel.org>; Fri, 23 Oct 2020 11:48:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rzTfua3GRk/XGy07dLFNryvhTBOBJk20cb003sHqSlA=;
        b=oytGXhiMWv8UyE0d7DiFE9P2K6JIzpWGcRylOERKUVlu9rlA26v6GRLOwIxiJdV7Pk
         zXCTZJ2yYhooCstCj4frZo6P8zXZyNb+k/691pCQvKZaE11KN/CDb9K8plpW2MzG8ysH
         v5lfUE/YPsSS1pKguCMx54txMkzw7I2CyoZsRY9yKnPM0sH0WbhXrrXGUkiF8mJF/qQG
         Qx5yfoYztDMTN12lDImS4HkSlRGswUt8LKWXatbK+StuUxdnldjWT+CrOv4A8wUzjLnu
         xMggYTd2ssXlMGT4r7lyDWdBJb5aB9EkjbbJTjUQm8gX3XSDmK/gOnCF50NRXn6YIYdG
         pFNg==
X-Gm-Message-State: AOAM5310Z0+7HrtcZ7FkBXvYeJebF8s02RfB/2kGyBYDHGrSOEwEg8fy
        UNz7mRCsUaU/Wrbglq0KclFJKNQuG+26yvKaoEMhl8StJoL1ci6MmKu3EvVRcXeI2BHJar43Iu4
        nscoJBpR2b3aXFigd
X-Received: by 2002:a1c:f612:: with SMTP id w18mr3698882wmc.11.1603478899173;
        Fri, 23 Oct 2020 11:48:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8igSYu6eaFldIBVM6vU1Sda9KsojJCZD2Uw1ALF+g+luBvoixdL6fXdwUkmejN44Ok7XmYQ==
X-Received: by 2002:a1c:f612:: with SMTP id w18mr3698865wmc.11.1603478898965;
        Fri, 23 Oct 2020 11:48:18 -0700 (PDT)
Received: from pc-2.home (2a01cb058d4f8400c9f0d639f7c74c26.ipv6.abo.wanadoo.fr. [2a01:cb05:8d4f:8400:c9f0:d639:f7c7:4c26])
        by smtp.gmail.com with ESMTPSA id j5sm4981701wrx.88.2020.10.23.11.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:48:18 -0700 (PDT)
Date:   Fri, 23 Oct 2020 20:48:16 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
Message-ID: <20201023184816.GB21673@pc-2.home>
References: <cover.1603469145.git.gnault@redhat.com>
 <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
 <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 11:23:04AM -0700, Jakub Kicinski wrote:
> On Fri, 23 Oct 2020 18:19:43 +0200 Guillaume Nault wrote:
> > Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
> > mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
> > need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.
> 
> Does it generate an error or a warning? I don't know much about soft
> dependencies, but I'd think it's optional.

Yes, it's optional from a softdep point of view. My point was that
having a softdep isn't a complete solution, as a bad .config can still
result in inability to properly transmit GSO packets.

> > diff --git a/net/mpls/Kconfig b/net/mpls/Kconfig
> > index d672ab72ab12..b83093bcb48f 100644
> > --- a/net/mpls/Kconfig
> > +++ b/net/mpls/Kconfig
> > @@ -33,6 +33,7 @@ config MPLS_ROUTING
> >  config MPLS_IPTUNNEL
> >  	tristate "MPLS: IP over MPLS tunnel support"
> >  	depends on LWTUNNEL && MPLS_ROUTING
> > +	select NET_MPLS_GSO
> >  	help
> >  	 mpls ip tunnel support.
> >  
> 

