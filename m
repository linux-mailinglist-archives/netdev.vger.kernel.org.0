Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 604E55F6A1
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 12:31:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727528AbfGDKbE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 06:31:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33472 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727432AbfGDKbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 06:31:03 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so6081457wru.0
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 03:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vfNfNOecUkgsCK5iRU+RHp5HzJkwACPrVEZHclgWgQw=;
        b=FVKkQerj/tMYlojr2Q5WpayQ+ByGFY3Q0bQtVLvJKEM1f46amoOo4TzfdoVLbfpGFq
         auEpc18Ed67ELqkaR3F4F29TioKOp/61uAHgb0KbVLNJAxbS4ihHPUdgj72YJsYh7VYN
         2YsD/Dr+6AT5Bc9ROI6C7GZeZcrtaOcW8tGXoeLQsvpXeo3w+YXmXKQMuvtcn6UNyvAW
         OtKUgoPW4socc1x5F5+1yvX4S+ZxiEX6RSZ+WoIYjsc/tR9U2HM6g6cpB0b2tBB3yiiy
         vGJ/S/IVFtqZEVsIwglpjE1jcjwuZS9V6cxvvV6qGnTcPUmWaDcRLQjnKyvS0O+avSWa
         Lrew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vfNfNOecUkgsCK5iRU+RHp5HzJkwACPrVEZHclgWgQw=;
        b=B2JamzxVzvQAPO4OFYlZGVjvA87ZjJpfiSYl0AbDlXwVhKf01wOfFQOM2Utl0Csylu
         cZwQdttdhrPTbgfxL8Bj3qFYS3O6k4UrKC5D2Hbkt8XMTrsYjYACJ8yWTFnE4MWJGTUo
         4JQwP65saOq99WfhLwj36HwQK2M6GNefx+GNlxYYXnCIDiSiHB7UQUdj5s+DP+ftcmME
         MjzwjcWoZqhPi/GDlbBy1ZD8DjTf6+dSY23SrZIU8Q333O2wRfPXrg//5ArYUytO77PD
         0Z21YPGzehzVOWYaPuUEWiKWSQyoxW/8fDeu+BgVY37mqNtjhqDg8M8sUebhsEHcso7v
         dH0Q==
X-Gm-Message-State: APjAAAXegL3VP7j8HDiQTfYgKUAUDl08lpIqEsURNZqh2xtLKHy3OLzV
        Tq1fKC6PzrMk9FS2vUdTzJNI5Q==
X-Google-Smtp-Source: APXvYqxUVdc9ozRNmQRBYQi1aV7FgAVJIVtccp1fqnmyAt+NPySxjvsza2v74xpNJCzXO1zhqfzSSA==
X-Received: by 2002:a5d:5186:: with SMTP id k6mr35965127wrv.30.1562236261279;
        Thu, 04 Jul 2019 03:31:01 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id k63sm6177278wmb.2.2019.07.04.03.30.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 03:31:00 -0700 (PDT)
Date:   Thu, 4 Jul 2019 13:30:57 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Jose Abreu <Jose.Abreu@synopsys.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190704103057.GA29734@apalos>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <20190704120018.4523a119@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704120018.4523a119@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

HI Jesper, Ivan,

> On Wed,  3 Jul 2019 12:37:50 +0200
> Jose Abreu <Jose.Abreu@synopsys.com> wrote:
> 
> > @@ -3547,6 +3456,9 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
> >  
> >  			napi_gro_receive(&ch->rx_napi, skb);
> >  
> > +			page_pool_recycle_direct(rx_q->page_pool, buf->page);
> 
> This doesn't look correct.
> 
> The page_pool DMA mapping cannot be "kept" when page traveling into the
> network stack attached to an SKB.  (Ilias and I have a long term plan[1]
> to allow this, but you cannot do it ATM).
> 
> You will have to call:
>   page_pool_release_page(rx_q->page_pool, buf->page);
> 
> This will do a DMA-unmap, and you will likely loose your performance
> gain :-(
> 
> 
> > +			buf->page = NULL;
> > +
> >  			priv->dev->stats.rx_packets++;
> >  			priv->dev->stats.rx_bytes += frame_len;
> >  		}
> 
> Also remember that the page_pool requires you driver to do the DMA-sync
> operation.  I see a dma_sync_single_for_cpu(), but I didn't see a
> dma_sync_single_for_device() (well, I noticed one getting removed).
> (For some HW Ilias tells me that the dma_sync_single_for_device can be
> elided, so maybe this can still be correct for you).
On our case (and in the page_pool API in general) you have to track buffers when
both .ndo_xdp_xmit() and XDP_TX are used.
So the lifetime of a packet might be 

1. page pool allocs packet. The API doesn't sync but i *think* you don't have to
explicitly since the CPU won't touch that buffer until the NAPI handler kicks
in. On the napi handler you need to dma_sync_single_for_cpu() and process the
packet.
2a) no XDP is required so the packet is unmapped and free'd
2b) .ndo_xdp_xmit is called so tyhe buffer need to be mapped/unmapped
2c) XDP_TX is called. In that case we re-use an Rx buffer so we need to
dma_sync_single_for_device()
2a and 2b won't cause any issues
In 2c the buffer will be recycled and fed back to the device with a *correct*
sync (for_device) and all those buffers are allocated as DMA_BIDIRECTIONAL.

So bvottom line i *think* we can skip the dma_sync_single_for_device() on the
initial allocation *only*. If am terribly wrong please let me know :)

Thanks
/Ilias
> 
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool02_SKB_return_callback.org
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
