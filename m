Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 316F5D219C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 09:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733050AbfJJHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 03:22:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33529 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732759AbfJJHWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 03:22:04 -0400
Received: by mail-wr1-f65.google.com with SMTP id b9so6458892wrs.0
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 00:22:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5dB9uPHoRFBkypAjQzTL7nZvQlPFX6xcARMET/qNjs0=;
        b=U/UFyF2Xu9q8Ouig4ZC43u+vHWcbhjDxNJD/Bd9T5KLNh6BeM5jfHNgBRQ7P1TlLp2
         phVe/PEXmkI9ref0v/E8yAikkKUf+WGRlaLZnJBqRl6WJxCQ8ARdMOeVEllcbV4JaYZc
         T2eBTBvtdi1XIDEcSmAUcwyf5cascxQve8yjHVi7YKf3PW9uDmilN2t16hvl42APZ7NJ
         QZA2/5m/j9IWMHdu08PPwv8K9BU5EE3D3o+zOmH49NQGdguPMJZzsO5X9oHwxCzUBn1C
         ZGvz/NON6Q7pVDPorZKK8TgGaNYLfrfS8gmQ/LfzBO/rvoHGeRfg0rAYbSPdK2TpzmLE
         cOqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5dB9uPHoRFBkypAjQzTL7nZvQlPFX6xcARMET/qNjs0=;
        b=CBI3QxeEMQyHbNLcdU9L9s2A5VLZ52GJwgvWx33LvoLCybmu9QJ8jJlL4aWA2uhzPA
         jkv+95bLPlYsZyGGgdnz/TI6IvAgpgTVNs4B9Sbi+BzX8ELAlR47js5r3/2IMAfr/AG+
         zMhVxBheXhjNIkOIoK74IqLDTuqR58gHsgY0TEhASTGh04wTug0yUayoWibxATDwydLK
         zjWCMzNjJH9KZFJSs2bFrInHzIMAraCNpdoq50lQ3Aa5vrq/vFpSeV50svxEvw7RNqYk
         6MJkInzXWzpR+LEqvsV4fQUT2VaX/UmXY4yZ4BjuLod+a3hI74dyFSYhuKwcLORQtGGt
         OWDQ==
X-Gm-Message-State: APjAAAVUrIzY9bvWICC7Hd8n7gFG4AF+K3w0dM6rCl56e27xL6cPn1dy
        rU0OuRkMUoCZTIb3JG1fzOU7ew==
X-Google-Smtp-Source: APXvYqyaaawkVLmibGr7yaA6Jyv5o/7IpFGIWqX1jMKtoTCpNIx5VGwgq7n0MGh6tqbep3IpDM8MvQ==
X-Received: by 2002:a5d:6ac1:: with SMTP id u1mr6706289wrw.245.1570692120662;
        Thu, 10 Oct 2019 00:22:00 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id m18sm6396619wrg.97.2019.10.10.00.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 00:22:00 -0700 (PDT)
Date:   Thu, 10 Oct 2019 10:21:57 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, matteo.croce@redhat.com,
        mw@semihalf.com
Subject: Re: [PATCH v2 net-next 4/8] net: mvneta: sync dma buffers before
 refilling hw queues
Message-ID: <20191010072157.GA31883@apalos.home>
References: <cover.1570662004.git.lorenzo@kernel.org>
 <744e01ea2c93200765ba8a77f0e6b0ca6baca513.1570662004.git.lorenzo@kernel.org>
 <20191010090831.5d6c41f2@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191010090831.5d6c41f2@carbon>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, Jesper,

On Thu, Oct 10, 2019 at 09:08:31AM +0200, Jesper Dangaard Brouer wrote:
> On Thu, 10 Oct 2019 01:18:34 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> 
> > mvneta driver can run on not cache coherent devices so it is
> > necessary to sync dma buffers before sending them to the device
> > in order to avoid memory corruption. This patch introduce a performance
> > penalty and it is necessary to introduce a more sophisticated logic
> > in order to avoid dma sync as much as we can
> 
> Report with benchmarks here:
>  https://github.com/xdp-project/xdp-project/blob/master/areas/arm64/board_espressobin08_bench_xdp.org
> 
> We are testing this on an Espressobin board, and do see a huge
> performance cost associated with this DMA-sync.   Regardless we still
> want to get this patch merged, to move forward with XDP support for
> this driver. 
> 
> We promised each-other (on IRC freenode #xdp) that we will follow-up
> with a solution/mitigation, after this patchset is merged.  There are
> several ideas, that likely should get separate upstream review.

I think mentioning that the patch *introduces* a performance penalty is a bit
misleading. 
The dma sync does have a performance penalty but it was always there. 
The initial driver was mapping the DMA with DMA_FROM_DEVICE, which implies
syncing as well. In page_pool we do not explicitly sync buffers on allocation
and leave it up the driver writer (and allow him some tricks to avoid that),
thus this patch is needed.

In any case what Jesper mentions is correct, we do have a plan :)

> 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index 79a6bac0192b..ba4aa9bbc798 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -1821,6 +1821,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
> >  			    struct mvneta_rx_queue *rxq,
> >  			    gfp_t gfp_mask)
> >  {
> > +	enum dma_data_direction dma_dir;
> >  	dma_addr_t phys_addr;
> >  	struct page *page;
> >  
> > @@ -1830,6 +1831,9 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
> >  		return -ENOMEM;
> >  
> >  	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
> > +	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
> > +	dma_sync_single_for_device(pp->dev->dev.parent, phys_addr,
> > +				   MVNETA_MAX_RX_BUF_SIZE, dma_dir);
> >  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> >  
> >  	return 0;
> 
> 
> 
> -- 
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer

Thanks!
/Ilias
