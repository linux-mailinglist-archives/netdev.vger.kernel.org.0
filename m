Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C6F1E48BA
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390611AbgE0PzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 11:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390626AbgE0Pyw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 11:54:52 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29AC7C05BD1E;
        Wed, 27 May 2020 08:54:52 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id x10so10268752plr.4;
        Wed, 27 May 2020 08:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nkIhbxtFT/sWyLG+CNPMvzFZfh5YwCelX3IPeKtDVng=;
        b=PAMb3Gighhz0cCKhjZLQ89rDfM+umkVZTkpYgFwBdzZ9PIGR1KNuJfANRSBsICHGU1
         9GFY4+NhktZozymnBZgQaGPkn8QdPxDOXGhFk13RvLQfW7JVN2KYbsdVXfBT1OinJLIp
         zrRy0l+YVDGcMRQy8Ldm4ZecscejFQHzikG3HLWm++8UC3ai8KnWZCyKH6z7T/HA1xRI
         Wp+WUBUbWpR2kBaZ0JpFXShORG+eXejQ1vCRS83kPuIkPDQqhhjsTVcFK0GFU7CbfTMs
         dACufN3iOpLHsbWp1FGFQTUumq0BZHbJAIhG4FZ5GeQo+es6H96EK3UqJhZ/+Te+5OLe
         Y23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nkIhbxtFT/sWyLG+CNPMvzFZfh5YwCelX3IPeKtDVng=;
        b=VTFzvqV8dkwr6K3401itxGBMTwC/kf60dgg1UExx0SDsciPoRL8jZsRcDUNi2ZPYqL
         g4eNnaOBZwpzdA3A6AH42DXVzZ2pSuJR6+p8E4mVdL8h20Gea/3oY74RMAzOLSBVo6Np
         e0MHf6VW07iMxisYI/HfLkuJfGWmqywdTKPF5eV6xD75APqL8IbmWkmOhHCkP/K0zaL3
         JtZi8G2v1UTZfy4XIOKsijtNfO3BG+oEewqSikwPkM9MfhhfSuRwZAX6pH9Z6piKX7FX
         6sYtrXbmEz1Udm6quaUCKI13Rm/wZsaCueVC4q5vKOlDx8Doq/K63eC5ftyILemkbFx3
         jVQQ==
X-Gm-Message-State: AOAM533JrVD2xKcTbGKafB6hE5xCQ+9xrvi2rGh4y2PSaCPzePXbXsTJ
        yXCMvyvkhF67Y5+AKoRhet8=
X-Google-Smtp-Source: ABdhPJxjWquEPV+JeRdzbhyTylh3GgQILPCaziRrufi5RFxgpIErfBy/fC56S/kQiDi7y42BfuoXZQ==
X-Received: by 2002:a17:902:9882:: with SMTP id s2mr6368400plp.184.1590594891507;
        Wed, 27 May 2020 08:54:51 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id q44sm3286859pja.2.2020.05.27.08.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 08:54:50 -0700 (PDT)
Date:   Wed, 27 May 2020 08:54:47 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: Re: [PATCH] net: ethernet: mtk-star-emac: fix error path in RX
 handling
Message-ID: <20200527155447.GA568403@ubuntu-s3-xlarge-x86>
References: <20200527092404.3567-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527092404.3567-1-brgl@bgdev.pl>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 27, 2020 at 11:24:04AM +0200, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> The dma_addr field in desc_data must not be overwritten until after the
> new skb is mapped. Currently we do replace it with uninitialized value
> in error path. This change fixes it by moving the assignment before the
> label to which we jump after mapping or allocation errors.
> 
> Fixes: 8c7bd5a454ff ("net: ethernet: mtk-star-emac: new driver")
> Reported-by: Nathan Chancellor <natechancellor@gmail.com>
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>

Tested-by: Nathan Chancellor <natechancellor@gmail.com> # build

> ---
>  drivers/net/ethernet/mediatek/mtk_star_emac.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> index b74349cede28..72bb624a6a68 100644
> --- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
> +++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
> @@ -1308,6 +1308,8 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
>  		goto push_new_skb;
>  	}
>  
> +	desc_data.dma_addr = new_dma_addr;
> +
>  	/* We can't fail anymore at this point: it's safe to unmap the skb. */
>  	mtk_star_dma_unmap_rx(priv, &desc_data);
>  
> @@ -1318,7 +1320,6 @@ static int mtk_star_receive_packet(struct mtk_star_priv *priv)
>  	netif_receive_skb(desc_data.skb);
>  
>  push_new_skb:
> -	desc_data.dma_addr = new_dma_addr;
>  	desc_data.len = skb_tailroom(new_skb);
>  	desc_data.skb = new_skb;
>  
> -- 
> 2.25.0
> 
