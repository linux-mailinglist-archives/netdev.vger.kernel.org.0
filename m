Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0E99FCD4C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfKNSVN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:21:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35595 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727140AbfKNSVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:21:12 -0500
Received: by mail-wm1-f67.google.com with SMTP id 8so7035844wmo.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rDJb3mjpY9XI6vA6SU8OZ3bNUZ4QlIC5HxLhMIFBGho=;
        b=UJk23sdqae4BlOJ2tulLVsDYVy1Y6l9xv4c/WYbTx1eBwG2xDSBuzHniGz6qnml8G/
         QXhURWDwfzzZZg/gDm9e4xfi6LWAJ3a3daydLKsYpJ1E5DbpXI3E4b2GiDY6Ngklwazz
         7O9DMkD4ZaCWgyJPO3gOB1SYDdi2+DrUxSntumxlCPT6P3/njL32oArs6GkR1NAyFA9o
         PII9biIdaaUNU+p56iBxEBNMGFKhVFrDPaJrCuZvVLN+53Ne63YWfcz2Vrj/FrCm5bXW
         D4JeIX6xkH6+WQMO8PIZiK0hbrNG4Am3y8PTxHmXT4/G9WjsqBAveiqSM9P09YYuZ+jD
         J9Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rDJb3mjpY9XI6vA6SU8OZ3bNUZ4QlIC5HxLhMIFBGho=;
        b=fjNXP7mObdWWBbQZ6oyBavtOIw9khUz0Jz2GgRTR1mQYr9FBWNco3u/QjtjskhXLm+
         Gk+a3BZqc26FQbMj3Xi4S6NEtBmz9fGF0pdh3D/OdziacZ2KvnpihCRLLbgi03VS4Cow
         eETOR9BKJB6Yz8X4eLKJoXIUk08zIC51E/UERK77/NZf/02a3Trtu2Re4+ke0DLshmsm
         I7n9/eIdOJtEp+vI8vXN2jsHBhWY1UgFB17pPczC34+ORdS7srXd0PSX7aYrMhGXZzUG
         +WYNykjzGFvJSg+XnKjtl9dYuHEqP7krOFOWsm9LkZ7hHMdfqhwrzDmwvCZRJWx98TUS
         Q8+w==
X-Gm-Message-State: APjAAAUWvUSzfce+ZTG4nT/pxhoEYs3MvVZ0LY/oCEPBDaGvTPfTPDHI
        6vDFFvMNzWQ2x0/yQB3gBjslmA==
X-Google-Smtp-Source: APXvYqyOXUueZviT6pzdkrGl4dO1J9dfIRa51X1epbZwBuNDQVAxBH6B76ACXgJWPxYBvj9XD9Smcg==
X-Received: by 2002:a1c:a743:: with SMTP id q64mr9055027wme.44.1573755669600;
        Thu, 14 Nov 2019 10:21:09 -0800 (PST)
Received: from PC192.168.49.172 (athedsl-4484009.home.otenet.gr. [94.71.55.177])
        by smtp.gmail.com with ESMTPSA id t24sm9650012wra.55.2019.11.14.10.21.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 10:21:09 -0800 (PST)
Date:   Thu, 14 Nov 2019 20:18:50 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jlemon@flugsvamp.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 3/3] net: mvneta: get rid of huge DMA sync in
 mvneta_rx_refill
Message-ID: <20191114181850.GA42770@PC192.168.49.172>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <b18159e702ec28bb33c492da216a12eaf3e7490c.1573383212.git.lorenzo@kernel.org>
 <79304C3A-EC21-4D15-8D03-BA035D9E0F4C@flugsvamp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79304C3A-EC21-4D15-8D03-BA035D9E0F4C@flugsvamp.com>
User-Agent: Mutt/1.9.5 (2018-04-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

On Thu, Nov 14, 2019 at 10:14:19AM -0800, Jonathan Lemon wrote:
> On 10 Nov 2019, at 4:09, Lorenzo Bianconi wrote:
> 
> > Get rid of costly dma_sync_single_for_device in mvneta_rx_refill
> > since now the driver can let page_pool API to manage needed DMA
> > sync with a proper size.
> > 
> > - XDP_DROP DMA sync managed by mvneta driver:	~420Kpps
> > - XDP_DROP DMA sync managed by page_pool API:	~595Kpps
> > 
> > Tested-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c
> > b/drivers/net/ethernet/marvell/mvneta.c
> > index ed93eecb7485..591d580c68b4 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1846,7 +1846,6 @@ static int mvneta_rx_refill(struct mvneta_port
> > *pp,
> >  			    struct mvneta_rx_queue *rxq,
> >  			    gfp_t gfp_mask)
> >  {
> > -	enum dma_data_direction dma_dir;
> >  	dma_addr_t phys_addr;
> >  	struct page *page;
> > 
> > @@ -1856,9 +1855,6 @@ static int mvneta_rx_refill(struct mvneta_port
> > *pp,
> >  		return -ENOMEM;
> > 
> >  	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> > -	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> > -	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> > -				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
> >  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> > 
> >  	return 0;
> > @@ -2097,8 +2093,10 @@ mvneta_run_xdp(struct mvneta_port *pp, struct
> > mvneta_rx_queue *rxq,
> >  		err = xdp_do_redirect(pp->dev, xdp, prog);
> >  		if (err) {
> >  			ret = MVNETA_XDP_DROPPED;
> > -			page_pool_recycle_direct(rxq->page_pool,
> > -						 virt_to_head_page(xdp->data));
> > +			__page_pool_put_page(rxq->page_pool,
> > +					virt_to_head_page(xdp->data),
> > +					xdp->data_end - xdp->data_hard_start,
> > +					true);
> 
> I just have a clarifying question.  Here, the RX buffer was received and
> then
> dma_sync'd to the CPU.  Now, it is going to be recycled for RX again; does
> it
> actually need to be sync'd back to the device?
> 
> I'm asking since several of the other network drivers (mellanox, for
> example)
> don't resync the buffer back to the device when recycling it for reuse.

I think that if noone apart from the NIC touches the memory, you don't have any
pending cache writes you have to account for. 
So since the buffer is completely under the drivers control, as long as you can
guarantee noone's going to write it, you can hand it back to the device without
syncing (BPF use case where the bpf program changes the packet for example
breaks this rule)

Thanks
/Ilias
> -- 
> Jonathan
