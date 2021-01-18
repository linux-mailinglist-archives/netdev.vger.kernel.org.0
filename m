Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBDF2FABDC
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 21:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388234AbhARUwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 15:52:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394484AbhARUux (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 15:50:53 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A104EC061757
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:50:12 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id v67so25984912lfa.0
        for <netdev@vger.kernel.org>; Mon, 18 Jan 2021 12:50:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PBJOvjAiOhmMWsZCYIdfqOTw6TCWRMDqPYu2m3TOPyA=;
        b=ean573HMotYRkhpmfuWcuDU9xxWJXixSAnZTqXu+lzblvz5PPhlHX2pG1XMiWf9gj3
         mBUGsa4kUt2npW6Z4XPzvnHSMZYHpQgb5wcgp4Yg5JjOAGZxHpTEvLJvpDeIOS8NqdeR
         eFpMC0k5M26afcDq8GRIAe8bupmbEu4A6QEPJqqkwiOLCODzkh/kqjujK9wX6RWhiZX2
         01i+p7pl5juQwhpyh6JHgz79hTRQnB3AjfprNPJWjMUKpp/1tU1GwPHpVKlzdFZ7Xvau
         pRCXkkkz8c43spsSvOmaiTJ3IWDb6rZJFbJgDX9JihQviOn/TSY31zD9X+vS2gY53h6x
         dC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PBJOvjAiOhmMWsZCYIdfqOTw6TCWRMDqPYu2m3TOPyA=;
        b=oW4TMWW/1j3G9vxvprXwQN47vV7c/L8uJvNURRY/jJJw5JS30EdjKZgJ/0j0++z+yr
         dGeQUvylvo5Pvnsbf+d0/HGp0CDODl6Mmf2E0qlS5kZAsDng8QdaFSfxEi0HKTLNELx+
         cBtgmrz0QcDdihOCLjh31dmbzgkVPuFLnmO18i0J7O9x5AanOU/t8Vk2EeQ5I+3nK7uI
         Lo9hLZjwkoKo1zbDrHvYDDl/PQLlWVCV13RACNgG+8cH/B/LA4u0TT9YD46vHNQbXLhf
         2oeiW3F/mC/NkAModC6tdpl+OsujQ+8vCCva0mVNv73NIVPMzHs1+pIR7DQ0AYC8QOmB
         v8Zw==
X-Gm-Message-State: AOAM5329rUx77AQE/EmrsPi7xvwuUx1OI2uPCpeMc/m6mj7CIHDTh2b3
        8HgQvsZNKo/sV7OShIRnnDl3CMs3cnrFIw==
X-Google-Smtp-Source: ABdhPJyRdBzbTcJLLjUIbNdqXAdPYYwTNEavwmm4K5yZC4JkSGTHPIGL1GSU4vGZxVQVmLM95ztrBQ==
X-Received: by 2002:a05:6512:3493:: with SMTP id v19mr374356lfr.569.1611003011132;
        Mon, 18 Jan 2021 12:50:11 -0800 (PST)
Received: from localhost (h-209-203.A463.priv.bahnhof.se. [155.4.209.203])
        by smtp.gmail.com with ESMTPSA id k18sm1788227ljb.80.2021.01.18.12.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:50:10 -0800 (PST)
Date:   Mon, 18 Jan 2021 21:50:09 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh_eth: Fix power down vs. is_opened flag ordering
Message-ID: <YAX0gRahdHyZ8GwA@oden.dyn.berto.se>
References: <20210118150812.796791-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210118150812.796791-1-geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for your work.

On 2021-01-18 16:08:12 +0100, Geert Uytterhoeven wrote:
> sh_eth_close() does a synchronous power down of the device before
> marking it closed.  Revert the order, to make sure the device is never
> marked opened while suspended.
> 
> While at it, use pm_runtime_put() instead of pm_runtime_put_sync(), as
> there is no reason to do a synchronous power down.
> 
> Fixes: 7fa2955ff70ce453 ("sh_eth: Fix sleeping function called from invalid context")
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 9b52d350e21a9f2b..590b088bc4c7f3e2 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -2606,10 +2606,10 @@ static int sh_eth_close(struct net_device *ndev)
>  	/* Free all the skbuffs in the Rx queue and the DMA buffer. */
>  	sh_eth_ring_free(ndev);
>  
> -	pm_runtime_put_sync(&mdp->pdev->dev);
> -
>  	mdp->is_opened = 0;
>  
> +	pm_runtime_put(&mdp->pdev->dev);
> +
>  	return 0;
>  }
>  
> -- 
> 2.25.1
> 

-- 
Regards,
Niklas Söderlund
