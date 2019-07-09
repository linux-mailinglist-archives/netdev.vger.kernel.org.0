Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA27563B73
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 20:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfGISzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 14:55:13 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34018 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfGISzM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 14:55:12 -0400
Received: by mail-wr1-f67.google.com with SMTP id 31so5376380wrm.1
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 11:55:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AK8RzN+/2hWv9zer5jXNJ3xygPfLGreFMIhVa+OVVVY=;
        b=IXNV3ye3K4avp61PReRwp6ySaheBrtze1f8nv58XAn6YodaxJgX3O4z8iXRHTBDAZQ
         j3Jyd2F2p3M1XtO1Qe7rf/FfFNokPfrJVWA0VDS8ASgN2Wz+eQrJCQK6Fh8NFYGHs/gG
         nFWbW6i5Yd3q+qwX+/Un4KileyefpLgyRR/73s/LOSK/GI3uiLqD0QRyCrCVFY2EswIV
         n8jHB16OOGYYYERA206MSJuH1+I8brQAR75TghKM6a7D+097pU5Wur3nW+1iWSdL7ZJ4
         UjQWueUE1YfikUYs2sw8f65FoOGIjEhFSl9mFWNoKS+rKnupxHCbHdEXToa8EHw1vJFy
         6Xdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AK8RzN+/2hWv9zer5jXNJ3xygPfLGreFMIhVa+OVVVY=;
        b=uLONbvIrXrSK7JTl8FniKQkn0Fw+KO+nseKKPGyRfxozUa/ESKZrwAyHLPRDH3RLur
         dH1eCBfZ4aW2HWwqmwRGJMAwMKIOrMZJO6K2zFO6H73PuS11v6NY5dcmJtG0bl5CBOcg
         i8r8QduMA7jE2RSNUTkdpaMzB9wk+m+gfzKpF3Pt9fGW/tP/glf+kX147WX1qXGbaff3
         j6zw9PtcoNKtXtp8F2Rdap9RAruFG9flAMfPVo/6uSnxP8X0Um3wwUPCHUT6/Oi6JVhg
         ExVJUYTcNMBEMd0AZzdL61HKTKShHkEelGb1EDbDn0JpTcr2uAz3lRlblBnF5o86n3kK
         H5hw==
X-Gm-Message-State: APjAAAVMZhATlfCkLVjX1i5vNxsXAVDO9zqV6xpj520yemjw3KB5lLTh
        OzXn+Z6Nze5tn4rFMzK1Nd/Ibg==
X-Google-Smtp-Source: APXvYqzgnJo2/EpAMyUyDQ53B8feVxFBskw6o5D8ZsPmojJMiVhA4R+6TIiDb7yzwaiyAoHaRrexFA==
X-Received: by 2002:a05:6000:12c8:: with SMTP id l8mr8065473wrx.72.1562698509448;
        Tue, 09 Jul 2019 11:55:09 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id f70sm4380921wme.22.2019.07.09.11.55.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:55:08 -0700 (PDT)
Date:   Tue, 9 Jul 2019 21:55:06 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX ring
 cleanup.
Message-ID: <20190709185506.GA7854@apalos>
References: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
 <20190709131842.GJ87269@C02RW35GFVH8.dhcp.broadcom.net>
 <20190709152057.GA4452@apalos>
 <20190709163154.GO87269@C02RW35GFVH8.dhcp.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709163154.GO87269@C02RW35GFVH8.dhcp.broadcom.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 12:31:54PM -0400, Andy Gospodarek wrote:
> On Tue, Jul 09, 2019 at 06:20:57PM +0300, Ilias Apalodimas wrote:
> > Hi,
> > 
> > > > Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
> > > > cleanup, as Ilias has informed us that the following commit has been
> > > > merged:
> > > > 
> > > > 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
> > > > 
> > > > The special error handling code to call page_pool_free() can now be
> > > > removed.  bnxt_free_rx_rings() will always be called during normal
> > > > shutdown or any error paths.
> > > > 
> > > > Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> > > > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > > > Cc: Andy Gospodarek <gospo@broadcom.com>
> > > > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > > > ---
> > > >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++------
> > > >  1 file changed, 2 insertions(+), 6 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > > index e9d3bd8..2b5b0ab 100644
> > > > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > > > @@ -2500,6 +2500,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
> > > >  		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
> > > >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > > >  
> > > > +		page_pool_destroy(rxr->page_pool);
> > > >  		rxr->page_pool = NULL;
> > > >  
> > > >  		kfree(rxr->rx_tpa);
> > > > @@ -2560,19 +2561,14 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> > > >  			return rc;
> > > >  
> > > >  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
> > > > -		if (rc < 0) {
> > > > -			page_pool_free(rxr->page_pool);
> > > > -			rxr->page_pool = NULL;
> > > > +		if (rc < 0)
> > > >  			return rc;
> > > > -		}
> > > >  
> > > >  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> > > >  						MEM_TYPE_PAGE_POOL,
> > > >  						rxr->page_pool);
> > > >  		if (rc) {
> > > >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > > > -			page_pool_free(rxr->page_pool);
> > > > -			rxr->page_pool = NULL;
> > > 
> > > Rather than deleting these lines it would also be acceptable to do:
> > > 
> > >                 if (rc) {
> > >                         xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > > -                       page_pool_free(rxr->page_pool);
> > > +                       page_pool_destroy(rxr->page_pool);
> > >                         rxr->page_pool = NULL;
> > >                         return rc;
> > >                 }
> > > 
> > > but anytime there is a failure to bnxt_alloc_rx_rings the driver will
> > > immediately follow it up with a call to bnxt_free_rx_rings, so
> > > page_pool_destroy will be called.
> > > 
> > > Thanks for pushing this out so quickly!
> > > 
> > 
> > I also can't find page_pool_release_page() or page_pool_put_page() called when
> > destroying the pool. Can you try to insmod -> do some traffic -> rmmod ?
> > If there's stale buffers that haven't been unmapped properly you'll get a
> > WARN_ON for them.
> 
> I did that test a few times with a few different bpf progs but I do not
> see any WARN messages.  Of course this does not mean that the code we
> have is 100% correct.
> 

I'll try to have a closer look as well

> Presumably you are talking about one of these messages, right?
> 
> 215         /* The distance should not be able to become negative */
> 216         WARN(inflight < 0, "Negative(%d) inflight packet-pages", inflight);
> 
> or
> 
> 356         /* Drivers should fix this, but only problematic when DMA is used */
> 357         WARN(1, "Still in-flight pages:%d hold:%u released:%u",
> 358              distance, hold_cnt, release_cnt);
> 

Yea particularly the second one. There's a counter we increase everytime you
alloc a fresh page which needs to be decresed before freeing the whole pool.
page_pool_release_page will do that for example

> 
> > This part was added later on in the API when Jesper fixed in-flight packet
> > handling

Thanks
/Ilias
