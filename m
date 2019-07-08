Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD2D9620DF
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730234AbfGHOvn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:51:43 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39939 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbfGHOvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:51:43 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so16762134wmj.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 07:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xmmR475W6ZN1ruWGPuR3M5S2TfI2V6Jrohj+e+3IFC0=;
        b=aAEPiZXnwTwTbwQUiY45naIEzBaULzA/gqKZvJ8i10JBfgsrt83Ruyq81iZnEbv99G
         +8w/qA8dnRkhrqyA0gfU0UyBg/23Ov31sJtZGUc0AeXtoJLmziSqez7aivy/+R2Krql9
         2UeJIkj2QkNEduA1KUkXrQdmLMTQJAqj2eVcFWc1UyKlfui76A51q50i5VQHKqcRTcTK
         YmorLA0US/kJGpbP9jyiq0drwTbmtLCPA3z6r90HR0weUFdrhRNufgDYB50mPaleTLRj
         Y3nv2eceoAHiuqL5065FitHeJPYiko9rti/xQAGM+cBqXy5H5vTUEHShIzcFS/hbU7Uk
         t8Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xmmR475W6ZN1ruWGPuR3M5S2TfI2V6Jrohj+e+3IFC0=;
        b=JrBwdZ5w2h1N14s85RNunnXrEqOKjE/LEUBdE2/XDDqGIvV23C1SHO+VnFS/gsp3Wp
         UUpgbEKRnt4wHz0Omn3u1/CyMzDStgQK2k/xQQ93cu/rhOJyL77fopPuRprXYZMZrxCp
         G4Hx3VX9Z85wxOrHfEDhQZac83KUzw6kLxqkfBP2O6cWzYEbbKTh5DP3p9TA9vabN671
         nQhBGHHkhjttu21FzD3/uNbZGBeG9riey+aUD1hsdg4BK6dxr4k+vXkty0xMLim0XqxC
         EK/3xAhnhh18Sd6bXwxVIOsE2iz9Xq7otLmdc5+v5cX3iKjwWIt2L+u1nyTEjA4Amhhi
         BWIg==
X-Gm-Message-State: APjAAAUu3KDG2zrV92TeHMDQ0WvfDP86obAz9reoixCI1mB9SayYR/dO
        yGL73BqOWYKpRTQadhM4VlTU0pYdr0w=
X-Google-Smtp-Source: APXvYqxsHYVM/6XzdfliLdEcO9TNtJACM1YtP1ecIANeF5Za0CTDIqEM/yW4C3HqewRHfIVNNY0bNw==
X-Received: by 2002:a1c:4b0b:: with SMTP id y11mr18336289wma.25.1562597500543;
        Mon, 08 Jul 2019 07:51:40 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id l25sm16147655wme.13.2019.07.08.07.51.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 07:51:39 -0700 (PDT)
Date:   Mon, 8 Jul 2019 17:51:37 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org, hawk@kernel.org, ast@kernel.org,
        ivan.khoronzhuk@linaro.org
Subject: Re: [PATCH net-next 3/4] bnxt_en: optimized XDP_REDIRECT support
Message-ID: <20190708145137.GA21894@apalos>
References: <1562398578-26020-1-git-send-email-michael.chan@broadcom.com>
 <1562398578-26020-4-git-send-email-michael.chan@broadcom.com>
 <20190708082803.GA28592@apalos>
 <20190708142606.GF87269@C02RW35GFVH8.dhcp.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708142606.GF87269@C02RW35GFVH8.dhcp.broadcom.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, 

> On Mon, Jul 08, 2019 at 11:28:03AM +0300, Ilias Apalodimas wrote:
> > Thanks Andy, Michael
> > 
> > > +	if (event & BNXT_REDIRECT_EVENT)
> > > +		xdp_do_flush_map();
> > > +
> > >  	if (event & BNXT_TX_EVENT) {
> > >  		struct bnxt_tx_ring_info *txr = bnapi->tx_ring;
> > >  		u16 prod = txr->tx_prod;
> > > @@ -2254,9 +2257,23 @@ static void bnxt_free_tx_skbs(struct bnxt *bp)
> > >  
> > >  		for (j = 0; j < max_idx;) {
> > >  			struct bnxt_sw_tx_bd *tx_buf = &txr->tx_buf_ring[j];
> > > -			struct sk_buff *skb = tx_buf->skb;
> > > +			struct sk_buff *skb;
> > >  			int k, last;
> > >  
> > > +			if (i < bp->tx_nr_rings_xdp &&
> > > +			    tx_buf->action == XDP_REDIRECT) {
> > > +				dma_unmap_single(&pdev->dev,
> > > +					dma_unmap_addr(tx_buf, mapping),
> > > +					dma_unmap_len(tx_buf, len),
> > > +					PCI_DMA_TODEVICE);
> > > +				xdp_return_frame(tx_buf->xdpf);
> > > +				tx_buf->action = 0;
> > > +				tx_buf->xdpf = NULL;
> > > +				j++;
> > > +				continue;
> > > +			}
> > > +
> > 
> > Can't see the whole file here and maybe i am missing something, but since you
> > optimize for that and start using page_pool, XDP_TX will be a re-synced (and
> > not remapped)  buffer that can be returned to the pool and resynced for 
> > device usage. 
> > Is that happening later on the tx clean function?
> 
> Take a look at the way we treat the buffers in bnxt_rx_xdp() when we
> receive them and then in bnxt_tx_int_xdp() when the transmits have
> completed (for XDP_TX and XDP_REDIRECT).  I think we are doing what is
> proper with respect to mapping vs sync for both cases, but I would be
> fine to be corrected.
> 

Yea seems to be doing the right thing, 
XDP_TX syncs correctly and reuses with bnxt_reuse_rx_data() right?

This might be a bit confusing for someone reading the driver on the first time,
probably because you'll end up with 2 ways of recycling buffers. 

Once a buffers get freed on the XDP path it's either fed back to the pool, so
the next requested buffer get served from the pools cache (ndo_xdp_xmit case in
the patch). If the buffer is used for XDP_TX is's synced correctly but recycled
via bnxt_reuse_rx_data() right? Since you are moving to page pool please
consider having a common approach towards the recycling path. I understand that
means tracking buffers types and make sure you do the right thing on 'tx clean'.
I've done something similar on the netsec driver and i do think this might be a
good thing to add on page_pool API

Again this isn't a blocker at least for me but you already have the buffer type
(via tx_buf->action)

> > 
> > > +			skb = tx_buf->skb;
> > >  			if (!skb) {
> > >  				j++;
> > >  				continue;
> > > @@ -2517,6 +2534,13 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> > >  		if (rc < 0)
> > >  			return rc;
> > >  
> > > +		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> > > +						MEM_TYPE_PAGE_SHARED, NULL);
> > > +		if (rc) {
> > > +			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > 
> > I think you can use page_pool_free directly here (and pge_pool_destroy once
> > Ivan's patchset gets nerged), that's what mlx5 does iirc. Can we keep that
> > common please?
> 
> That's an easy change, I can do that.
> 
> > 
> > If Ivan's patch get merged please note you'll have to explicitly
> > page_pool_destroy, after calling xdp_rxq_info_unreg() in the general unregister
> > case (not the error habdling here). Sorry for the confusion this might bring!
> 
> Funny enough the driver was basically doing that until page_pool_destroy
> was removed (these patches are not new).  I saw last week there was
> discussion to add it back, but I did not want to wait to get this on the
> list before that was resolved.

Fair enough

> 
> This path works as expected with the code in the tree today so it seemed
> like the correct approach to post something that is working, right?  :-)

Yes.

It will continue to work even if you dont change the call in the future. 
This is more a 'let's not spread the code' attempt, but removing and re-adding
page_pool_destroy() was/is our mess. We might as well live with the
consequences!

> 
> > 
> > > +			return rc;
> > > +		}
> > > +
> > >  		rc = bnxt_alloc_ring(bp, &ring->ring_mem);
> > >  		if (rc)
> > >  			return rc;
> > > @@ -10233,6 +10257,7 @@ static const struct net_device_ops bnxt_netdev_ops = {
> > [...]
> > 

Thanks!
/Ilias
