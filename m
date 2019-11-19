Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA5E10231E
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:35:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbfKSLdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:33:42 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39604 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbfKSLdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:33:41 -0500
Received: by mail-wm1-f68.google.com with SMTP id t26so3142955wmi.4
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4uuUUTFItp2hkRWm7utdDbiOrPEc2C/0EgZNLd715sU=;
        b=psJwVZr4W1eswyTNoI4nS/fUin/6nKR0d6nlfUbA5kwE7fV9QziqwSIRODWtDoeEsL
         RQYonNOvGGzY9ypv8dU0jY48MCP3epYQT7t4BQoOuAnQR3LYQK6w+0QsWoFqSwYJEEXR
         lMabPi2qaFe9T07s+Thqb80eX4LsXuC279PdzyV1FS4Knb+NArtAmK92VkmAqXEDbskH
         1f5h0KcpiWDspy0yqyu6p4LQy2rQWhgBPV88OZ3alUevRq09gu5sQASRf37C3sCZOcy+
         wzt6LS/DLgNyt/1pJJte0Xs3XjUt08W0Dekng3CtRVPlJtaKczSBJ2RGj21/cOgFYw4R
         f9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4uuUUTFItp2hkRWm7utdDbiOrPEc2C/0EgZNLd715sU=;
        b=l3AtDpCt2YNkoUzf14aFmfLXD2/alU0m09iv4XiVJ9Z2AXCdXFNTSMRhXb8jXfqxwj
         qr4PCDgDpmFKDlQRGzq2VPncewQ/5n/ArHx14XvSBP20t8shcKPvLVpHsrXu9HnbGxHa
         7sW3KY2DOXGNLXBp0Wqkvtntg4oi7y9EUpk4YqhNcDfXG7Oqz2+FVd1jeGXwo291Sxp7
         Z98Gpv2JjtDGBEbJweNpFVvpU/nwfbIZsT1wIPDsoAyTXDZvDM8A7avGf0rtDoTy1sjy
         Gecl9xR6AfYncdsZ8XHmN+H97pZ7mVGKsZmk7IyDMQd/uc0+TOsBCK674mAxOJ9KKOe5
         BwnA==
X-Gm-Message-State: APjAAAXslLpBnp5OAZ7kCYK474OgCR4bUCkVseXn9qhCbzM1BSq7H9PB
        aeGyD5IXGkVSwRyGRDAG1VVYaQ==
X-Google-Smtp-Source: APXvYqy8wzmdkAHBNOOnA9k3O6Bw6ULipgwWO75NMokntNA/XO85N9odi10xMcktCDvzarjE13HF5g==
X-Received: by 2002:a1c:64d4:: with SMTP id y203mr5020995wmb.27.1574163219676;
        Tue, 19 Nov 2019 03:33:39 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id m3sm26355751wrw.20.2019.11.19.03.33.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 03:33:39 -0800 (PST)
Date:   Tue, 19 Nov 2019 13:33:36 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119113336.GA25152@apalos.home>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
 <20191119122358.12276da4@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119122358.12276da4@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index dfc2501c35d9..4f9aed7bce5a 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
> >  	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> >  		return -EINVAL;
> >  
> > +	/* In order to request DMA-sync-for-device the page needs to
> > +	 * be mapped
> > +	 */
> > +	if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > +	    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > +		return -EINVAL;
> > +
> 
> I like that you have moved this check to setup time.
> 
> There are two other parameters the DMA_SYNC_DEV depend on:
> 
>  	struct page_pool_params pp_params = {
>  		.order = 0,
> -		.flags = PP_FLAG_DMA_MAP,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>  		.pool_size = size,
>  		.nid = cpu_to_node(0),
>  		.dev = pp->dev->dev.parent,
>  		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> +		.offset = pp->rx_offset_correction,
> +		.max_len = MVNETA_MAX_RX_BUF_SIZE,
>  	};
> 
> Can you add a check, that .max_len must not be zero.  The reason is
> that I can easily see people misconfiguring this.  And the effect is
> that the DMA-sync-for-device is essentially disabled, without user
> realizing this. The not-realizing part is really bad, especially
> because bugs that can occur from this are very rare and hard to catch.

+1 we sync based on the min() value of those 

> 
> I'm up for discussing if there should be a similar check for .offset.
> IMHO we should also check .offset is configured, and then be open to
> remove this check once a driver user want to use offset=0.  Does the
> mvneta driver already have a use-case for this (in non-XDP mode)?

Not sure about this, since it does not break anything apart from some
performance hit

Cheers
/Ilias
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
