Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73CDF1027FE
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbfKSPXq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:23:46 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34000 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfKSPXp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:23:45 -0500
Received: by mail-wr1-f68.google.com with SMTP id e6so24370846wrw.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 07:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0ZlP3l8MU/qV+mcE5CTpDdgpZthwhwe2rRllBt9+9r8=;
        b=XlSpCEeUbw3Cy9D+a45SNSTSCdl8fKZPl63yAYEUSql3m+oedUCLYmGvyeP1tFzV3q
         S8XLP07p8DiuK//osIdzdICf9jiAVHHWhKtY9RL2ClL54gZJz1bFkckxxJ8zFeay1ehA
         1MCddUEwkLFb41TGhy4bFQZ8qmM+bwGq16Y64OC2Z1Xh5/0zbFdMkFfsRyM6fYT2dDLo
         JChVyRruZqA5KqFGDYoM1ebz7yfMnNFr++UV+DQMrQMN7ztfq9mSCSwQN7JNgk5dYz1M
         K0Es7HeCqz+jjmhTIfXOoin7IgaRsKy3H/5ITqitv0mVn0XAa4fz9CQvIb4glpxKVskF
         womg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=0ZlP3l8MU/qV+mcE5CTpDdgpZthwhwe2rRllBt9+9r8=;
        b=qg4F9MnLm9SdGkDvK+4MpRcJII8ExmIMyEAQxh0/q1UkV/DOwdhHtvH7xM0Gut2/4v
         JKtDfXlMgLXp+0hOCVW4jjHyAuVGLvtkZ7SGSrGydvSoZdFQSJOzR3KCbBfBNogkk9An
         5K9RjW7IIFmcjINPG/URK/99Y6uQMDg8bkjQ4nkWfoC1c1O+HWdTA0EaIFknT+qH2d2w
         QaE+r77iqpAGXWfgqY+n5hj/UwjGyPv2Erkl2Pt/Gpd1n/MuseUyxqUcEJQwh7dB9kEy
         7hLz/+FSzxHxud5vOfWou0fEHJu8Q7loZRRksO4DAcje1rdHRAOB9btYeyNaKCUodHVl
         j+vw==
X-Gm-Message-State: APjAAAVEGjGBEM9v64VQl/BfWnkKa7yt+Y3XRyWY88DMks1T6mq+3lKe
        ZrLXWChYTaqOAZ8/IP+EIwUiCQ==
X-Google-Smtp-Source: APXvYqy4xV+vEHKMRS7ljsN3G0L8IL87R3Jtg9tYlhA77XFoBmrrwNkWWPH/ZHkvms82KXXoKzymxQ==
X-Received: by 2002:a5d:4f09:: with SMTP id c9mr39756946wru.175.1574177023406;
        Tue, 19 Nov 2019 07:23:43 -0800 (PST)
Received: from apalos.home (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id u18sm28119297wrp.14.2019.11.19.07.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 07:23:42 -0800 (PST)
Date:   Tue, 19 Nov 2019 17:23:40 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, lorenzo.bianconi@redhat.com,
        mcroce@redhat.com, jonathan.lemon@gmail.com
Subject: Re: [PATCH v4 net-next 2/3] net: page_pool: add the possibility to
 sync DMA memory for device
Message-ID: <20191119152340.GA31758@apalos.home>
References: <cover.1574083275.git.lorenzo@kernel.org>
 <84b90677751f54c1c8d47f4036bce5999982379c.1574083275.git.lorenzo@kernel.org>
 <20191119122358.12276da4@carbon>
 <20191119113336.GA25152@apalos.home>
 <20191119161109.7cd83965@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119161109.7cd83965@carbon>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 19, 2019 at 04:11:09PM +0100, Jesper Dangaard Brouer wrote:
> On Tue, 19 Nov 2019 13:33:36 +0200
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > index dfc2501c35d9..4f9aed7bce5a 100644
> > > > --- a/net/core/page_pool.c
> > > > +++ b/net/core/page_pool.c
> > > > @@ -47,6 +47,13 @@ static int page_pool_init(struct page_pool *pool,
> > > >  	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
> > > >  		return -EINVAL;
> > > >  
> > > > +	/* In order to request DMA-sync-for-device the page needs to
> > > > +	 * be mapped
> > > > +	 */
> > > > +	if ((pool->p.flags & PP_FLAG_DMA_SYNC_DEV) &&
> > > > +	    !(pool->p.flags & PP_FLAG_DMA_MAP))
> > > > +		return -EINVAL;
> > > > +  
> > > 
> > > I like that you have moved this check to setup time.
> > > 
> > > There are two other parameters the DMA_SYNC_DEV depend on:
> > > 
> > >  	struct page_pool_params pp_params = {
> > >  		.order = 0,
> > > -		.flags = PP_FLAG_DMA_MAP,
> > > +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> > >  		.pool_size = size,
> > >  		.nid = cpu_to_node(0),
> > >  		.dev = pp->dev->dev.parent,
> > >  		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> > > +		.offset = pp->rx_offset_correction,
> > > +		.max_len = MVNETA_MAX_RX_BUF_SIZE,
> > >  	};
> > > 
> > > Can you add a check, that .max_len must not be zero.  The reason is
> > > that I can easily see people misconfiguring this.  And the effect is
> > > that the DMA-sync-for-device is essentially disabled, without user
> > > realizing this. The not-realizing part is really bad, especially
> > > because bugs that can occur from this are very rare and hard to catch.  
> > 
> > +1 we sync based on the min() value of those 
> > 
> > > 
> > > I'm up for discussing if there should be a similar check for .offset.
> > > IMHO we should also check .offset is configured, and then be open to
> > > remove this check once a driver user want to use offset=0.  Does the
> > > mvneta driver already have a use-case for this (in non-XDP mode)?  
> > 
> > Not sure about this, since it does not break anything apart from some
> > performance hit
> 
> I don't follow the 'performance hit' comment.  This is checked at setup
> time (page_pool_init), thus it doesn't affect runtime.

If the offset is 0, you'll end up syncing a couple of uneeded bytes (whatever
headers the buffer has which doesn't need syncing). 

> 
> This is a generic optimization principle that I use a lot. Moving code
> checks out of fast-path, and instead do more at setup/load-time, or
> even at shutdown-time (like we do for page_pool e.g. check refcnt
> invariance).  This principle is also heavily used by BPF, that adjust
> BPF-instructions at load-time.  It is core to getting the performance
> we need for high-speed networking.

The offset will affect the fast path running code.

What i am worried about is that XDP and SKB pool will have different needs for
offsets. In the netsec driver i am dealing with this with reserving the same
header whether the packet is an SKB or XDP buffer. If we check the offset we are
practically forcing people to do something similar

Thanks
/Ilias
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
> 
