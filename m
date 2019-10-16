Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BF8D8EAE
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 12:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389197AbfJPKzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 06:55:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37129 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfJPKzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 06:55:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so2254078wmc.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 03:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nxTifvovj4bgnSy1+KajPtzFaUPdVrvm5mmk+xKsZcY=;
        b=xkkJn0FOUkypDVTwmVmoT354H/AZVzm++pf85Dfb4XsoZ0LWEZv97VJUAD0itC7JYb
         Pa/pAPD49FkCJy9Wn6XHfidcIhTdPs7cJ7lT3kekXy8T2pLK9iWNGAmFyBU0+pz03VvW
         WDMGuasSZPTibn4XC+QWFdeDrBYeSdmlQRl5+HRE7cQ1Sf8aFtS6+NBa/AgRkm5fZX8D
         39UHrp/CYgbVgkkx4HzeoyL4jBOnh9AVXt9wzteZbEv83bA1kh1DATawx3G0uOdhFP5a
         nOYa3eZ8vdiLVcDs9qTdUubYiaaPagLuJF48YADW+hadDJS1eLN9RNSXFweT0uULcgCu
         eNqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nxTifvovj4bgnSy1+KajPtzFaUPdVrvm5mmk+xKsZcY=;
        b=jKQjsx5bB9fLPIJb1kCHNfXR6b6WDxBMvkcf2dJ/tWffKt1OMOGbdVVpQAgpHd7dUu
         43dc5w5apdEywaQMGs3P51MPJwGYyJdKoD/2Y87chzCo/aQKrT97pXuCLvqpI+gk9EkW
         Oqf8995beCx8RhdoMNn2agv9FPvLlr/HlHF3soDf7DSki6vjobCs/VXbUtqVxIWLSecz
         727iS5J0hHqSAEYB5EtdEVde4p16mDmQHNtZWpeID1jyPWru5yoTSaMjkFhCHk4Z0j4U
         KHrNuJT9cZJs5kZ7Gnd0/hl7hkyn4crWy6PEqdNH3fWIH1mcpyWPaflWTuC4qQJwpACy
         MaCQ==
X-Gm-Message-State: APjAAAWf0xKYPNWcmqyqvMmrtjfLlAOCXsquX4tP47fzhvIMBU7qThPn
        WhMb9ppfAm6Nlb8shi/SezVNuQ==
X-Google-Smtp-Source: APXvYqxLKScwTCgp548n9a7BP36NeI4t7PtZ7T1Kd1Uq7aOCseccbFOKr58OdBOr4weZhXdkw8DQsQ==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr2789459wmc.104.1571223309902;
        Wed, 16 Oct 2019 03:55:09 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id p23sm1934147wmg.42.2019.10.16.03.55.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 03:55:09 -0700 (PDT)
Date:   Wed, 16 Oct 2019 13:55:06 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 8/8] net: mvneta: add XDP_TX support
Message-ID: <20191016105506.GA19689@apalos.home>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <a964f1a704f194169e80f9693cf3150adffc1278.1571049326.git.lorenzo@kernel.org>
 <20191015171152.41d9a747@cakuba.netronome.com>
 <20191016100900.GE2638@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016100900.GE2638@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 12:09:00PM +0200, Lorenzo Bianconi wrote:
> > On Mon, 14 Oct 2019 12:49:55 +0200, Lorenzo Bianconi wrote:
> > > Implement XDP_TX verdict and ndo_xdp_xmit net_device_ops function
> > > pointer
> > > 
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > 
> > > @@ -1972,6 +1975,109 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
> > >  	return i;
> > >  }
> > >  
> > > +static int
> > > +mvneta_xdp_submit_frame(struct mvneta_port *pp, struct mvneta_tx_queue *txq,
> > > +			struct xdp_frame *xdpf, bool dma_map)
> > > +{
> > > +	struct mvneta_tx_desc *tx_desc;
> > > +	struct mvneta_tx_buf *buf;
> > > +	dma_addr_t dma_addr;
> > > +
> > > +	if (txq->count >= txq->tx_stop_threshold)
> > > +		return MVNETA_XDP_CONSUMED;
> > > +
> > > +	tx_desc = mvneta_txq_next_desc_get(txq);
> > > +
> > > +	buf = &txq->buf[txq->txq_put_index];
> > > +	if (dma_map) {
> > > +		/* ndo_xdp_xmit */
> > > +		dma_addr = dma_map_single(pp->dev->dev.parent, xdpf->data,
> > > +					  xdpf->len, DMA_TO_DEVICE);
> > > +		if (dma_mapping_error(pp->dev->dev.parent, dma_addr)) {
> > > +			mvneta_txq_desc_put(txq);
> > > +			return MVNETA_XDP_CONSUMED;
> > > +		}
> > > +		buf->type = MVNETA_TYPE_XDP_NDO;
> > > +	} else {
> > > +		struct page *page = virt_to_page(xdpf->data);
> > > +
> > > +		dma_addr = page_pool_get_dma_addr(page) +
> > > +			   pp->rx_offset_correction + MVNETA_MH_SIZE;
> > > +		dma_sync_single_for_device(pp->dev->dev.parent, dma_addr,
> > > +					   xdpf->len, DMA_BIDIRECTIONAL);
> > 
> > This looks a little suspicious, XDP could have moved the start of frame
> > with adjust_head, right? You should also use xdpf->data to find where
> > the frame starts, no?
> 
> uhm, right..we need to update the dma_addr doing something like:
> 
> dma_addr = page_pool_get_dma_addr(page) + xdpf->data - xdpf;

Can we do  page_pool_get_dma_addr(page) + xdpf->headroom as well right?

> 
> and then use xdpf->len for dma-sync
> 
> > 
> > > +		buf->type = MVNETA_TYPE_XDP_TX;
> > > +	}
> > > +	buf->xdpf = xdpf;
> > > +
> > > +	tx_desc->command = MVNETA_TXD_FLZ_DESC;
> > > +	tx_desc->buf_phys_addr = dma_addr;
> > > +	tx_desc->data_size = xdpf->len;
> > > +
> > > +	mvneta_update_stats(pp, 1, xdpf->len, true);
> > > +	mvneta_txq_inc_put(txq);
> > > +	txq->pending++;
> > > +	txq->count++;
> > > +
> > > +	return MVNETA_XDP_TX;
> > > +}
> > > +
> > > +static int
> > > +mvneta_xdp_xmit_back(struct mvneta_port *pp, struct xdp_buff *xdp)
> > > +{
> > > +	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
> > > +	int cpu = smp_processor_id();
> > > +	struct mvneta_tx_queue *txq;
> > > +	struct netdev_queue *nq;
> > > +	u32 ret;
> > > +
> > > +	if (unlikely(!xdpf))
> > > +		return MVNETA_XDP_CONSUMED;
> > 
> > Personally I'd prefer you haven't called a function which return code
> > has to be error checked in local variable init.
> 
> do you mean moving cpu = smp_processor_id(); after the if condition?
> 
> Regards,
> Lorenzo
> 
> > 
> > > +
> > > +	txq = &pp->txqs[cpu % txq_number];
> > > +	nq = netdev_get_tx_queue(pp->dev, txq->id);
> > > +
> > > +	__netif_tx_lock(nq, cpu);
> > > +	ret = mvneta_xdp_submit_frame(pp, txq, xdpf, false);
> > > +	if (ret == MVNETA_XDP_TX)
> > > +		mvneta_txq_pend_desc_add(pp, txq, 0);
> > > +	__netif_tx_unlock(nq);
> > > +
> > > +	return ret;
> > > +}

Thanks
/Ilias
