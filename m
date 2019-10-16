Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 381E2D8AAF
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 10:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391502AbfJPISt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 04:18:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35588 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfJPISt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 04:18:49 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so1727041wmi.0
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 01:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=e41oPXp+lDs3YgyFHJcvHHCalJwRg3S0np2bfd3tJ8k=;
        b=POIcaPjbP2phtVWNqzuUAUaZ0oiC900NpgOa+qvbgvk0uxblEZBzX5FXgWnMUgzAGr
         GwmShHhKU3oduO+cntDgFChiq/yFZ//6mQ7L1EjaY9V5ET/lw454Jgi1tSX0+gNuXf1s
         irvQ43FgND8NZ5Tl2gTdMScIA1trnopsE+qvkIEeQEnQsXcMRl/tY7lhLhrfQW12W1so
         pQaH7o1dkSfVhI3tJTB49ZkOSn6vSjo3iW9zJXkFR/TIAqtsB2gHZyYwizRwxxBNqbR5
         HBg3farFEjaaGouj4298Wtyjkzml+j7YTR93hbbsxkKnDZCBKrVVDWJ2dUkCesLsAo/W
         hfug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=e41oPXp+lDs3YgyFHJcvHHCalJwRg3S0np2bfd3tJ8k=;
        b=f8aEVbqSNJby22gz4xbfabqw9QwT7O+dFxTCYk5N5dMnxlCx0P2GF4NU9U/8+ZwWcc
         290BQ8+I431ENQWk3JaDdQSXUC1BpZbqyIhYKzSp42EdriAuwv9zWVEF+zEDLdue4AvI
         hCINM1J+T52RLdnAJpq7scWJ3ZuYjgRLsq/gFuKnu4nUxWNfu/V45X9FVzdAXi9MuSWL
         fqsgF45Y3h9n0lhz7leY1vbhk6QuI54fG96AAtl9nk6UB13wo0KeyUrOdASmuC1B5dI+
         r+XBHETa9sKiRWe/sECC5A6mHdJ8OoSYtYMrRp2jaqxdEg0eZcwRLfos1ZDdZee6Pljj
         Aquw==
X-Gm-Message-State: APjAAAXQJPutGYoEX8BpEPHFow+ZaNT70bzryk9NTbjSJrdGNLJJzPTz
        pbpS+rws0hXLhD3nJtip7WkCow==
X-Google-Smtp-Source: APXvYqwxijDT3SecCH83LftV7ilIdCNsl8cPDoOgAPvamhP7jCCV/aW0ABQV+br0bTOR1jVZdW3PKw==
X-Received: by 2002:a7b:c7d4:: with SMTP id z20mr2132978wmk.135.1571213926611;
        Wed, 16 Oct 2019 01:18:46 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id s10sm2735224wmf.48.2019.10.16.01.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 01:18:46 -0700 (PDT)
Date:   Wed, 16 Oct 2019 11:18:43 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net,
        thomas.petazzoni@bootlin.com, brouer@redhat.com,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v3 net-next 7/8] net: mvneta: make tx buffer array
 agnostic
Message-ID: <20191016081843.GA11653@apalos.home>
References: <cover.1571049326.git.lorenzo@kernel.org>
 <d233782c20a6d64f39c9d28fd321fc07fcc8b65e.1571049326.git.lorenzo@kernel.org>
 <20191015170353.1f4fbbbb@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015170353.1f4fbbbb@cakuba.netronome.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Oct 15, 2019 at 05:03:53PM -0700, Jakub Kicinski wrote:
> On Mon, 14 Oct 2019 12:49:54 +0200, Lorenzo Bianconi wrote:
> > Allow tx buffer array to contain both skb and xdp buffers in order to
> > enable xdp frame recycling adding XDP_TX verdict support
> > 
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  drivers/net/ethernet/marvell/mvneta.c | 66 +++++++++++++++++----------
> >  1 file changed, 43 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > index a79d81c9be7a..477ae6592fa3 100644
> > --- a/drivers/net/ethernet/marvell/mvneta.c
> > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > @@ -561,6 +561,20 @@ struct mvneta_rx_desc {
> >  };
> >  #endif
> >  
> > +enum mvneta_tx_buf_type {
> > +	MVNETA_TYPE_SKB,
> > +	MVNETA_TYPE_XDP_TX,
> > +	MVNETA_TYPE_XDP_NDO,
> > +};
> > +
> > +struct mvneta_tx_buf {
> > +	enum mvneta_tx_buf_type type;
> 
> I'd be tempted to try to encode type on the low bits of the pointer,
> otherwise you're increasing the cache pressure here. I'm not 100% sure
> it's worth the hassle, perhaps could be a future optimization.
> 

Since this is already offering a performance boost (since buffers are not
unmapped, but recycled and synced), we'll consider adding the buffer tracking
capability to the page_pool API. I don't think you'll see any performance
benefits on this device specifically (or any 1gbit interface), but your idea is
nice, if we add it on the page_pool API we'll try implementing it like that.

> > +	union {
> > +		struct xdp_frame *xdpf;
> > +		struct sk_buff *skb;
> > +	};
> > +};
> 


Thanks
/Ilias
