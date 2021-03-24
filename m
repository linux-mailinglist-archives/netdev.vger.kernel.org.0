Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F38634841D
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 22:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhCXVsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 17:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231777AbhCXVsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 17:48:30 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3636C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:48:29 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b9so263000wrt.8
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 14:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=APpcU8UgTj2/lg7HdSxIqF+ZGPx9m8b+f2ZQOGqq/LY=;
        b=J6PgcluJaK/ebL9jn5BboCJFHBsTsJCsQXbKn+mHsTFP5eGZ4rB49aqLgqlatXYi4B
         MiCZTn3gsG5idQReC519v9hU/G9dAz95DvGMhNqh/lnHX+NiCfxdhzwWfEr9XnhtM8oD
         krcraFfHwJ92kTCR8w2vx1uYurA6WZKP7HpkYJ2dhh8WHQnEFkGgEPHWETp9xOFEYQ4e
         o//aUfSSIML0kB4QMffqNl+WhRjuXHuTU15JE+VfZqIcAfGTu2jqYJ3EuddQ//kei7Hs
         Q2BSvRRlA223/DIerHi2XOfFmpWLINn+6EFCVObl6SujP4OaGHGL38kEdx1AAKxTIPFb
         jgqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=APpcU8UgTj2/lg7HdSxIqF+ZGPx9m8b+f2ZQOGqq/LY=;
        b=RQ9SO/fSZyqxV7ibA659eT2kh3xlwxb1iRhULGA7G/t5wXYPZ+H0zssS64VaGYj/FW
         nA7RtzPYdwXi97pTOzZX6RCv2DAG+wh9qa9EXv9dkjKzhg8zMXoUpCDY5/P5iqKBCMKb
         apE+KPbI4bmqP9m5m3BIMZlCfFGijAOZhLgJljWHHwwpPGTy2/qwurfeIyGESWrxbUCa
         2w/DsiLc+U8bFZEZ2rxiHplcIfrsu4c9gQ60svpaIhJ8J/+BPVeRox09SAax2KClCh1g
         qkA/d6yfYRzef3vtJE11gMOBAjZeOu4Sk5kfDZoS5nt04xnp5uPuB9Le3z1O5qpgjb1r
         Kw3g==
X-Gm-Message-State: AOAM533DFkg5/O/xdh1jxAlseTMXgFglF8yUr9WCTdvdt7TKoHxV5MAf
        hjWFKCsIAvnJ3UiQOKWh7O3Fbg==
X-Google-Smtp-Source: ABdhPJzNi94m5WahMwWQceltVQ3fZ1LDHvX0Cc3Nsq2dv6REXFWpiH/lJ0i/6h0TL0zNw9DMMkatYw==
X-Received: by 2002:a5d:554b:: with SMTP id g11mr5404573wrw.411.1616622508595;
        Wed, 24 Mar 2021 14:48:28 -0700 (PDT)
Received: from enceladus (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id m11sm4911228wri.44.2021.03.24.14.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 14:48:28 -0700 (PDT)
Date:   Wed, 24 Mar 2021 23:48:25 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@linux.microsoft.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next 6/6] mvneta: recycle buffers
Message-ID: <YFuzqWq/CQ6a9SsU@enceladus>
References: <20210322170301.26017-1-mcroce@linux.microsoft.com>
 <20210322170301.26017-7-mcroce@linux.microsoft.com>
 <20210323160611.28ddc712@carbon>
 <YFsGQx6XMbYRtBOR@lore-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YFsGQx6XMbYRtBOR@lore-desk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 10:28:35AM +0100, Lorenzo Bianconi wrote:
> [...]
> > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > index a635cf84608a..8b3250394703 100644
> > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > @@ -2332,7 +2332,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> > >  	if (!skb)
> > >  		return ERR_PTR(-ENOMEM);
> > >  
> > > -	page_pool_release_page(rxq->page_pool, virt_to_page(xdp->data));
> > > +	skb_mark_for_recycle(skb, virt_to_page(xdp->data), &xdp->rxq->mem);
> > >  
> > >  	skb_reserve(skb, xdp->data - xdp->data_hard_start);
> > >  	skb_put(skb, xdp->data_end - xdp->data);
> > > @@ -2344,7 +2344,7 @@ mvneta_swbm_build_skb(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
> > >  		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
> > >  				skb_frag_page(frag), skb_frag_off(frag),
> > >  				skb_frag_size(frag), PAGE_SIZE);
> > > -		page_pool_release_page(rxq->page_pool, skb_frag_page(frag));
> > > +		skb_mark_for_recycle(skb, skb_frag_page(frag), &xdp->rxq->mem);
> > >  	}
> > >  
> > >  	return skb;
> > 
> > This cause skb_mark_for_recycle() to set 'skb->pp_recycle=1' multiple
> > times, for the same SKB.  (copy-pasted function below signature to help
> > reviewers).
> > 
> > This makes me question if we need an API for setting this per page
> > fragment?
> > Or if the API skb_mark_for_recycle() need to walk the page fragments in
> > the SKB and set the info stored in the page for each?
> 
> Considering just performances, I guess it is better open-code here since the
> driver already performs a loop over fragments to build the skb, but I guess
> this approach is quite risky and I would prefer to have a single utility
> routine to take care of linear area + fragments. What do you think?
> 

The mark_for_recycle does two things as you noticed, 
set the pp_recyle bit on the skb head and update the struct page information we
need to trigger the recycling.
We could split those and be more explicit, but isn't the current approach a
bit simpler for the driver writer to get it right?
I don't think setting a single value to 1 will have any noticeable performance
impact, but we can always test it.

> Regards,
> Lorenzo
> 
> > 
> > 
> > -- 
> > Best regards,
> >   Jesper Dangaard Brouer
> >   MSc.CS, Principal Kernel Engineer at Red Hat
> >   LinkedIn: http://www.linkedin.com/in/brouer
> > 


