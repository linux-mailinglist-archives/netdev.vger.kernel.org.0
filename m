Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B371B1042C0
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:00:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727927AbfKTSAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:00:44 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46451 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfKTSAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:00:44 -0500
Received: by mail-wr1-f65.google.com with SMTP id b3so884637wrs.13
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 10:00:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=45ERKgsJ66WHcj3ysRCeTHTAykcbP4bDCeaBEe1z3BE=;
        b=hxHmPvV+uviGWfk84DTeR/WH6CrnZHW8HudF6W6l/EHhWrNU3oFjKuYTf5VbEtICrc
         MLFzmAH24BJUke5jSMFtvxNYolI6HG1SgEYfl3319JnWbhX9Fxbqp1U5IQMZvhJOXNif
         wS8fV5sbBQjIXnwV5Xb66vT71kwSUnBcGBNY+wOlAA+/ZTTBfueNXf287gIQsjEh29ad
         edwjycp9Gpv1QYQRrUXRy3r4U565Jh1SgrF9AEiRX3nB+0BpoKB3Uk0nXG9LX5vBn6jh
         SLKxSI8AnvbkUebN7MyOFlUuhCiiG8+SxojEeuX9lzvXkV/Kf7oiPz8bd6ETeHLwOsy1
         DD9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=45ERKgsJ66WHcj3ysRCeTHTAykcbP4bDCeaBEe1z3BE=;
        b=kbWSDWuKyib+hk3r6szj1UbtWHvv4eI3ql3915J2VVHk+ywRNZaZXM8EnpZlvfoqhe
         zTqxEG87MEs/QF+VZyxObxt8x1vSN7h3wPVU9QB09CPMITnVjaXuGf+6AeT1sx4iFjtp
         4RCQtwRCD3UtleMxcm0Y8Aa+idtTjk0V2ZMrI1iLt3ZhpCK4jSiWoN+cwlckLfJft9rk
         naFmo+jZhf8TZyX36ilWKHxfwnZI8BIXGaTZmH8UolmRxU3FyvYxS65A/A/a1Jg+l36q
         F5uCXia2rWS72+olCWsHWtEhrVU4rBJTud+mi6mGBOf+qnDR6if05Z6QOhNsJgHZfBaL
         QL9g==
X-Gm-Message-State: APjAAAWJic+TNdIjcdnbkhVxicU1xrB7afF2+YL95NmtbP2DSRL6kTEk
        /RoKW/S9W7/zVa9urnR8VeQasw==
X-Google-Smtp-Source: APXvYqw4lec8f3DNCtlWAxGF4ebRZYYuJmMsNnJdRbNuA9bpBVf75DMOUNW08ffLS5CUnS/0oewp4Q==
X-Received: by 2002:a05:6000:1286:: with SMTP id f6mr2338830wrx.44.1574272841592;
        Wed, 20 Nov 2019 10:00:41 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id n1sm60962wrr.24.2019.11.20.10.00.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2019 10:00:40 -0800 (PST)
Date:   Wed, 20 Nov 2019 20:00:38 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v5 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191120180038.GA26040@apalos.home>
References: <cover.1574261017.git.lorenzo@kernel.org>
 <4a22dd0ef91220748c4d3da366082a13190fb794.1574261017.git.lorenzo@kernel.org>
 <20191120184901.59306f16@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120184901.59306f16@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> [...]
> > @@ -281,8 +309,8 @@ static bool __page_pool_recycle_direct(struct page *page,
> >  	return true;
> >  }
> >  
> > -void __page_pool_put_page(struct page_pool *pool,
> > -			  struct page *page, bool allow_direct)
> > +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> > +			  unsigned int dma_sync_size, bool allow_direct)
> >  {
> >  	/* This allocator is optimized for the XDP mode that uses
> >  	 * one-frame-per-page, but have fallbacks that act like the
> > @@ -293,6 +321,10 @@ void __page_pool_put_page(struct page_pool *pool,
> >  	if (likely(page_ref_count(page) == 1)) {
> >  		/* Read barrier done in page_ref_count / READ_ONCE */
> >  
> > +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> > +			page_pool_dma_sync_for_device(pool, page,
> > +						      dma_sync_size);
> > +
> >  		if (allow_direct && in_serving_softirq())
> >  			if (__page_pool_recycle_direct(page, pool))
> >  				return;
> 
> I am slightly concerned this touch the fast-path code. But at-least on
> Intel, I don't think this is measurable.  And for the ARM64 board it
> was a huge win... thus I'll accept this.

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
