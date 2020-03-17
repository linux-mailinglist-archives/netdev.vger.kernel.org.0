Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 543E4187AAA
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 08:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgCQHvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 03:51:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45678 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725916AbgCQHvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 03:51:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id t2so14246373wrx.12
        for <netdev@vger.kernel.org>; Tue, 17 Mar 2020 00:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g3WSGBi1FDi2GJpIGSWTYSe6aWAgMu30Myfdzz9HNsM=;
        b=w2zLRsEkcG95RMIE7eYdMjuhM4CO+d5pjRAX4gw1e/QLWvGopYEs6nv159wEXgfq5r
         cLwDmRuDevPQ7s7ePVV/mn4tzDeahUYciLAVojpoNSc/mgH1jVTsoMksi4bX6L5hzA3z
         V43/dzOrGUfkJtmuFNkrBR0MOvV/+j17iA8B1ASp6iIc+2zAhT0bxHDOJvn5uh9S/7lY
         2yH0liTgN0icdFFCwO5Dfyc/fwzw9JTbt3yG3oJb2610jhcbdimbIqLWTO9KGp7/JYMq
         wyGr+f9q7D5rMvUBjxGxb33Ue/FoFu2EpbLZbbRtspweauDz7L4pGcggqMRBk51Wu/i2
         41lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g3WSGBi1FDi2GJpIGSWTYSe6aWAgMu30Myfdzz9HNsM=;
        b=ZoUl/RVvSierT2MOd7cvUO9mM8ArBhVKZrZ7AhuFR4PEbQCzke2zKMiDi12svVsqtL
         6aNAfeU25C7gl6BHU3tky6hWCs6I7VA13QuaCBIxMBy7raToleM5Ec7pib+QCwMQKlo4
         4tv2qeRHjuKPE1Kv0w2Jmn2peeMMQeO1Wgy3NdQ9zca4KVoJJJyb/b2J8qNJP3sNUa5s
         wuo4H1+6+OL+rftzkTTim7sSgJsvbhcjUEX4M/17UUYsZLpcELBoqIrvfii3CKmabUUc
         ljBAEJxBNllmuhAIP1P46CkJYlRjSAkDf6XIAFEewakhQCsFLrhcDZLl8CLXglqRu8/9
         IEmw==
X-Gm-Message-State: ANhLgQ0S0ziBifKLdqLof5Nnf/ENPDEWAxbLaMQz3+GEJPiiqMbeWyB8
        YFDHon6tfMmBo65IwTKvO6S4rw==
X-Google-Smtp-Source: ADFU+vsdV0tTQ+raJ7Ghqgv95OZ9/DNjBEN0UI90L0prhwBx+WeklN21ealtZRaQzbUQoNBSef7MYQ==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr4479813wru.100.1584431493879;
        Tue, 17 Mar 2020 00:51:33 -0700 (PDT)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id p16sm2694517wmi.40.2020.03.17.00.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 00:51:33 -0700 (PDT)
Date:   Tue, 17 Mar 2020 09:51:30 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-net-drivers@solarflare.com, ecree@solarflare.com,
        mhabets@solarflare.com, jaswinder.singh@linaro.org,
        Jose.Abreu@synopsys.com, andy@greyhouse.net,
        grygorii.strashko@ti.com, andrew@lunn.ch, michal.simek@xilinx.com,
        radhey.shyam.pandey@xilinx.com, mkubecek@suse.cz
Subject: Re: [PATCH net-next 2/9] net: socionext: reject unsupported
 coalescing params
Message-ID: <20200317075130.GA96496@apalos.home>
References: <20200316204712.3098382-1-kuba@kernel.org>
 <20200316204712.3098382-3-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200316204712.3098382-3-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub, 

Thanks for the cleanup

On Mon, Mar 16, 2020 at 01:47:05PM -0700, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
> 
> This driver did not previously reject unsupported parameters.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 58b9b7ce7195..a5a0fb60193a 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -589,6 +589,8 @@ static void netsec_et_set_msglevel(struct net_device *dev, u32 datum)
>  }
>  
>  static const struct ethtool_ops netsec_ethtool_ops = {
> +	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
> +				     ETHTOOL_COALESCE_MAX_FRAMES,
>  	.get_drvinfo		= netsec_et_get_drvinfo,
>  	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
>  	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> -- 
> 2.24.1
> 

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
