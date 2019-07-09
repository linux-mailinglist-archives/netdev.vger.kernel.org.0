Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7486663880
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 17:21:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGIPVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 11:21:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39002 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbfGIPVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 11:21:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so21468598wrt.6
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 08:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B1h/UIqlGi7MfHP7lsCy2BUQyda+jjY8N+4Z9HgKLFg=;
        b=WGvmYx0VqCpz+uFJoILkyLzf9cpykTFwWJzcDQi8k4P64Vh4tdgJ+KKAF5XCpjA//G
         0rASJeg8xPjy3ChQzEoEphU7Kq+qpYAeKjYj6c8NhIzea3GnErtENF2veklsw739Ani/
         d4R7xjtslU5PFshteK7kQ+ZsVrH4e+Pz8l0fugvquBiUnzOTmxIaTfBQBqNDSh3FGvCt
         CgD2G3/sIBpUDlhlz+IgOdgVp3Jj7aRk9JH9fO87Tqv5i++QPtZKg7IOoERwp2VYYTCi
         /wM1wj4d8bJW5KxVOgYX7mb2Y+PnteJYA8MbtG9e1zrJoNM/8tTyGJZqlFEbEf4oiBea
         0bjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B1h/UIqlGi7MfHP7lsCy2BUQyda+jjY8N+4Z9HgKLFg=;
        b=n7R2ekNaCCBqNhZkqrGi/QxlJLYZdf3Bc6RTyEXPXxStqN3qnLmrkD/M3b0we1/HCi
         uMX5j7278ktGQmMGBxL1xL5u2TqJqkkt2pyCPRXJWFxtn6LPQEfBNGTBlZLfmrebzCQY
         RFYWK59yCUnKOvylhEhbiPlBdd+ElSnzuB8N4N4cHIF6rmTdmRoECTYrJfwyHmP2UOlC
         7F2VOGygRQgMoVHYMe6vd9i4FxyZ8oKAfBV0HRWxj5vP+nTJz/xl69isg+jReFhcrXYl
         lkUZ2z1xPsEyXVNYae/apdDRkTI5QFdqAn66o/fEq8eAZFogVC3qN9szNAKXP9Y/dGWl
         H+Hg==
X-Gm-Message-State: APjAAAVPRdN07Oa/O7ncNSFNzU4btmHo1gLRVWR2mM1DMaUjCWmVPeR3
        rvjl/Db5xGQtUQgTo1Wrq6EGvw==
X-Google-Smtp-Source: APXvYqxsZwdqYcRT50eta2i9zSWPjsk/W03c1ABcf8L2rQEal2wtLEIgvBXYwyYjQ1BAta2a1t5QtQ==
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr18999265wrt.182.1562685660376;
        Tue, 09 Jul 2019 08:21:00 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id s10sm17977517wrt.49.2019.07.09.08.20.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 08:20:59 -0700 (PDT)
Date:   Tue, 9 Jul 2019 18:20:57 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Andy Gospodarek <andrew.gospodarek@broadcom.com>
Cc:     Michael Chan <michael.chan@broadcom.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnxt_en: Add page_pool_destroy() during RX ring
 cleanup.
Message-ID: <20190709152057.GA4452@apalos>
References: <1562658607-30048-1-git-send-email-michael.chan@broadcom.com>
 <20190709131842.GJ87269@C02RW35GFVH8.dhcp.broadcom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709131842.GJ87269@C02RW35GFVH8.dhcp.broadcom.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> > Add page_pool_destroy() in bnxt_free_rx_rings() during normal RX ring
> > cleanup, as Ilias has informed us that the following commit has been
> > merged:
> > 
> > 1da4bbeffe41 ("net: core: page_pool: add user refcnt and reintroduce page_pool_destroy")
> > 
> > The special error handling code to call page_pool_free() can now be
> > removed.  bnxt_free_rx_rings() will always be called during normal
> > shutdown or any error paths.
> > 
> > Fixes: 322b87ca55f2 ("bnxt_en: add page_pool support")
> > Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > Cc: Andy Gospodarek <gospo@broadcom.com>
> > Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++------
> >  1 file changed, 2 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > index e9d3bd8..2b5b0ab 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> > @@ -2500,6 +2500,7 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
> >  		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
> >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> >  
> > +		page_pool_destroy(rxr->page_pool);
> >  		rxr->page_pool = NULL;
> >  
> >  		kfree(rxr->rx_tpa);
> > @@ -2560,19 +2561,14 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
> >  			return rc;
> >  
> >  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
> > -		if (rc < 0) {
> > -			page_pool_free(rxr->page_pool);
> > -			rxr->page_pool = NULL;
> > +		if (rc < 0)
> >  			return rc;
> > -		}
> >  
> >  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> >  						MEM_TYPE_PAGE_POOL,
> >  						rxr->page_pool);
> >  		if (rc) {
> >  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> > -			page_pool_free(rxr->page_pool);
> > -			rxr->page_pool = NULL;
> 
> Rather than deleting these lines it would also be acceptable to do:
> 
>                 if (rc) {
>                         xdp_rxq_info_unreg(&rxr->xdp_rxq);
> -                       page_pool_free(rxr->page_pool);
> +                       page_pool_destroy(rxr->page_pool);
>                         rxr->page_pool = NULL;
>                         return rc;
>                 }
> 
> but anytime there is a failure to bnxt_alloc_rx_rings the driver will
> immediately follow it up with a call to bnxt_free_rx_rings, so
> page_pool_destroy will be called.
> 
> Thanks for pushing this out so quickly!
> 

I also can't find page_pool_release_page() or page_pool_put_page() called when
destroying the pool. Can you try to insmod -> do some traffic -> rmmod ?
If there's stale buffers that haven't been unmapped properly you'll get a
WARN_ON for them.
This part was added later on in the API when Jesper fixed in-flight packet
handling

> Acked-by: Andy Gospodarek <gospo@broadcom.com> 
> 

Thanks
/Ilias
