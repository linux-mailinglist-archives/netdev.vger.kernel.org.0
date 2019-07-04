Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2B35FCA7
	for <lists+netdev@lfdr.de>; Thu,  4 Jul 2019 19:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGDRwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jul 2019 13:52:55 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34301 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbfGDRwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jul 2019 13:52:55 -0400
Received: by mail-wr1-f65.google.com with SMTP id u18so7462166wru.1
        for <netdev@vger.kernel.org>; Thu, 04 Jul 2019 10:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9S65y8WJK8nZrXIqc0EG751IMw9pa71nGa4l6nrlYa8=;
        b=ab0X/ZQe6BEFP12LZibHbJ3wrvoMqGRbdneGvd95PZ2h4W5D8RkJ1HleaYzzPOx/b/
         Ovr9wiJj/djbvwa+wUoQ7L9Wo9l7GrZDFTunctyLffUaeOYhXe72sCOofyuvAp2MUSoD
         mAhCvnddD5bdVGKrjEMsuM1Gk3p45yeHbSgm6VWh9w2TSmH2r5H9GWSkT+YWiAlBdr/U
         xPLaZKKAqZxgTglQr1Zlj5DjzLuqIMtcyvhSLlNoy4Q/U+P90kXx3diywETelLGYB4zn
         5PegozyW6KYK5UeuS66kuBC0wO7W1sANHzgQM3fr2a6Y2BrpasxNQN1kZCRj6OqS0qGM
         9SNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9S65y8WJK8nZrXIqc0EG751IMw9pa71nGa4l6nrlYa8=;
        b=c/wrEwhAz28RTkwfJXguSxdTgkcqFf1U3pACymtwb1+okfjBS+Lr98c4Z3KAywIO1S
         HQ+bkU4ZGBXET8jXlkA/YB/U6ohK4MWb09bUjhJoCzMA1T0S3Wkh+JknE3PcgHj35uXw
         It9OB7U0BxFe4qqpLU3uWCXPn+6H0IA3AWWYRN+JrCcHF6IQ245CETbaWJUSRnHVpOst
         tdunK/4e+06uLlR4tA7oQIy1G8UAGf5iVepGT5SFaaaXicd4ykVXKcX7v8LPIlqV77U1
         jNi2/pnyLhIe5SiOh8VXa5EBsh0zQ8pjNwFFxbMSCl1jEpnGvkOnn7W29Etl6Y7MPqha
         JB4w==
X-Gm-Message-State: APjAAAUZH9ty2hyjp8JSg//9yguK++SZdDjEPLVkVKng+AKyWZYcoj7B
        HyLIgSolca0/eIpUoMU3lNALXw==
X-Google-Smtp-Source: APXvYqzWPjQ1PlBwIITNklRAX6Qrer08jpodTpyuK8uOyv7s83gPi4m9oMqWa0m1v6UPIRh+/pa4GA==
X-Received: by 2002:adf:ec8e:: with SMTP id z14mr10119209wrn.125.1562262773111;
        Thu, 04 Jul 2019 10:52:53 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id x129sm5917149wmg.44.2019.07.04.10.52.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2019 10:52:52 -0700 (PDT)
Date:   Thu, 4 Jul 2019 20:52:50 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, arnd@arndb.de
Subject: Re: [net-next, PATCH, v2] net: netsec: Sync dma for device on buffer
 allocation
Message-ID: <20190704175250.GA15876@apalos>
References: <1562251569-16506-1-git-send-email-ilias.apalodimas@linaro.org>
 <20190704193944.5ef80468@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190704193944.5ef80468@carbon>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 04, 2019 at 07:39:44PM +0200, Jesper Dangaard Brouer wrote:
> On Thu,  4 Jul 2019 17:46:09 +0300
> Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> 
> > Quoting Arnd,
> > 
> > We have to do a sync_single_for_device /somewhere/ before the
> > buffer is given to the device. On a non-cache-coherent machine with
> > a write-back cache, there may be dirty cache lines that get written back
> > after the device DMA's data into it (e.g. from a previous memset
> > from before the buffer got freed), so you absolutely need to flush any
> > dirty cache lines on it first.
> > 
> > Since the coherency is configurable in this device make sure we cover
> > all configurations by explicitly syncing the allocated buffer for the
> > device before refilling it's descriptors
> > 
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> > 
> > Changes since V1: 
> > - Make the code more readable
> >  
> >  drivers/net/ethernet/socionext/netsec.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> > index 5544a722543f..ada7626bf3a2 100644
> > --- a/drivers/net/ethernet/socionext/netsec.c
> > +++ b/drivers/net/ethernet/socionext/netsec.c
> > @@ -727,21 +727,26 @@ static void *netsec_alloc_rx_data(struct netsec_priv *priv,
> >  {
> >  
> >  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> > +	enum dma_data_direction dma_dir;
> > +	dma_addr_t dma_start;
> >  	struct page *page;
> >  
> >  	page = page_pool_dev_alloc_pages(dring->page_pool);
> >  	if (!page)
> >  		return NULL;
> >  
> > +	dma_start = page_pool_get_dma_addr(page);
> >  	/* We allocate the same buffer length for XDP and non-XDP cases.
> >  	 * page_pool API will map the whole page, skip what's needed for
> >  	 * network payloads and/or XDP
> >  	 */
> > -	*dma_handle = page_pool_get_dma_addr(page) + NETSEC_RXBUF_HEADROOM;
> > +	*dma_handle = dma_start + NETSEC_RXBUF_HEADROOM;
> >  	/* Make sure the incoming payload fits in the page for XDP and non-XDP
> >  	 * cases and reserve enough space for headroom + skb_shared_info
> >  	 */
> >  	*desc_len = PAGE_SIZE - NETSEC_RX_BUF_NON_DATA;
> > +	dma_dir = page_pool_get_dma_dir(dring->page_pool);
> > +	dma_sync_single_for_device(priv->dev, dma_start, PAGE_SIZE, dma_dir);
> 
> It's it costly to sync_for_device the entire page size?
> 
> E.g. we already know that the head-room is not touched by device.  And
> we actually want this head-room cache-hot for e.g. xdp_frame, thus it
> would be unfortunate if the head-room is explicitly evicted from the
> cache here.
> 
> Even smarter, the driver could do the sync for_device, when it
> release/recycle page, as it likely know the exact length that was used
> by the packet.
It does sync for device when recycling takes place in XDP_TX with the correct
size. 
I guess i can explicitly sync on the xdp_return_buff cases, and 
netsec_setup_rx_dring() instead of the generic buffer allocation

I'll send a V3

Thanks!
/Ilias
