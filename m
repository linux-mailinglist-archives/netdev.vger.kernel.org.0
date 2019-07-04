Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B985FD54
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 21:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbfGDTMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 15:12:53 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43817 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726870AbfGDTMw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 15:12:52 -0400
Received: by mail-wr1-f66.google.com with SMTP id p13so7576079wru.10
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 12:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QpoQt5Yo9KQGqUuc55IGt4LPfoFu//zFdvNm3Eps1QA=;
        b=QF/KZ26M+xLOXj047T8sEWcLQDUt9waso7FUrchsFwb4DZYJ4EA2ROmPJVJRcCFdJ+
         QxgBmaWSIW4w4Mpj4yFwTyKGNUB+9+VPd0QTqgzmQ9O0aC4dhfRcHYIS6myK/qFuJwGQ
         6BEmJ+siTkqnL46iMOsMt1u9zexoJsXYtgq3Gm6wIPqW/D6F+wlXNPWxVxHNWlPUUc0y
         7XKm6EDINy7Wpv6skw42Zk6h3igss+QE9FGKPyxRc7rD4lTwuSIx0eRMs2XkyCEhHeRz
         Ia0hjeOhzWiuGK44JqbmZriNkrIJ480cYgdRZBMhn5z0sdj84TShlXDAtpGfIM0vFoKj
         zgpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=QpoQt5Yo9KQGqUuc55IGt4LPfoFu//zFdvNm3Eps1QA=;
        b=s4dyn9Kbo8mjZVD9O+9lUkIVZKi178oiVF2euVfnFwBKERahB2pVri+L0251zLqLT6
         qtFc9E8mYi94N59cbzIaBBIVpAHMT5TlrkTs6HBlb/Nv4nzHylsrRdQevo08Wh0QZGct
         QuXcDuHxdiLpV82gp+uHVJ62HNkQuZEqagyoQgkWeNP9qX7LbaWcKtw9NDxpl4AFMlAp
         BjecQxeCn9YMjyARNJBWWZTdTH5gmr/ZPapcav1IzZmAH0mkm+G2V0Z1iEwRU+V25QAg
         nwyR2F6fScgVEMVOCuhQuxLtpVN69t6VN6LSh4EseUmryc1nWLC+hYwAYZ1czDyZPDoB
         KD8w==
X-Gm-Message-State: APjAAAXa8P1VuutL7aDUXHuKTpJ4gKlc/dh8RxkmjE6HhFTxaQmd6RwN
        J5MIglqrXsr4J2/7wBj0WF+UNA==
X-Google-Smtp-Source: APXvYqyqI/9098xJccix9haKrxu0yf1EVA0cWtiWLwkBHKnJJKcEpyiqr+yA1ObPW93wOXCxlMoquw==
X-Received: by 2002:adf:a55b:: with SMTP id j27mr109421wrb.154.1562267570634;
        Thu, 04 Jul 2019 12:12:50 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id w10sm6492357wru.76.2019.07.04.12.12.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 12:12:50 -0700 (PDT)
Date:   Thu, 4 Jul 2019 22:12:47 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, arnd@arndb.de
Subject: Re: [net-next, PATCH, v2] net: netsec: Sync dma for device on buffer
 allocation
Message-ID: <20190704191247.GA1382@apalos>
References: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
 <20190704193944.5ef80468@carbon>
 <20190704175250.GA15876@apalos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704175250.GA15876@apalos>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 08:52:50PM +0300, Ilias Apalodimas wrote:
> On Thu, Jul 04, 2019 at 07:39:44PM +0200, Jesper Dangaard Brouer wrote:
> > On Thu,  4 Jul 2019 17:46:09 +0300
> > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> > 
> > > Quoting Arnd,
> > > 
> > > We have to do a sync_single_for_device /somewhere/ before the
> > > buffer is given to the device. On a non-cache-coherent machine with
> > > a write-back cache, there may be dirty cache lines that get written back
> > > after the device DMA's data into it (e.g. from a previous memset
> > > from before the buffer got freed), so you absolutely need to flush any
> > > dirty cache lines on it first.
> > > 
> > > Since the coherency is configurable in this device make sure we cover
> > > all configurations by explicitly syncing the allocated buffer for the
> > > device before refilling it's descriptors
> > > 
> > > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > ---
> > > 
> > > Changes since V1: 
> > > - Make the code more readable
> > >  
> > >  drivers/net/ethernet/socionext/netsec.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > > index 5544a722543f..ada7626bf3a2 100644
> > > --- a/drivers/net/ethernet/socionext/netsec.c
> > > +++ b/drivers/net/ethernet/socionext/netsec.c
> > > @@ -727,21 +727,26 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
> > >  {
> > >  
> > >  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > > +	enum dma_data_direction dma_dir;
> > > +	dma_addr_t dma_start;
> > >  	struct page *page;
> > >  
> > >  	page = page_pool_dev_alloc_pages(dring->page_pool);
> > >  	if (!page)
> > >  		return NULL;
> > >  
> > > +	dma_start = page_pool_get_dma_addr(page);
> > >  	/* We allocate the same buffer length for XDP and non-XDP cases.
> > >  	 * page_pool API will map the whole page, skip what's needed for
> > >  	 * network payloads and/or XDP
> > >  	 */
> > > -	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
> > > +	*dma_handle = dma_start + NETSEC_RXBUF_HEADROOM;
> > >  	/* Make sure the incoming payload fits in the page for XDP and non-XDP
> > >  	 * cases and reserve enough space for headroom + skb_shared_info
> > >  	 */
> > >  	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> > > +	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> > > +	dma_sync_single_for_device(priv->dev, dma_start, PAGE_SIZE, dma_dir);
> > 
> > It's it costly to sync_for_device the entire page size?
> > 
> > E.g. we already know that the head-room is not touched by device.  And
> > we actually want this head-room cache-hot for e.g. xdp_frame, thus it
> > would be unfortunate if the head-room is explicitly evicted from the
> > cache here.
> > 
> > Even smarter, the driver could do the sync for_device, when it
> > release/recycle page, as it likely know the exact length that was used
> > by the packet.
> It does sync for device when recycling takes place in XDP_TX with the correct
> size. 
> I guess i can explicitly sync on the xdp_return_buff cases, and 
> netsec_setup_rx_dring() instead of the generic buffer allocation
> 
> I'll send a V3

On a second thought i think this is going to look a bit complicated for no
apparent reason.
If i do this i'll have to track the buffers that got recycled vs buffers 
that are freshly allocated (and sync in this case). I currently have no 
way of cwtelling if the buffer is new or recycled, so i'll just sync the 
payload for now as you suggested.

Maybe this information can be added on page_pool_dev_alloc_pages() ?

Thanks
/Ilias
