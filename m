Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBC846D329
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233232AbhLHMX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:23:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhLHMX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:23:57 -0500
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AA8BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:20:25 -0800 (PST)
Received: by mail-lj1-x234.google.com with SMTP id bn20so3587194ljb.8
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 04:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=cxIhJxLH45f3paJwvO3rHF1VnfiXGcMj12zNmLMco38=;
        b=2vhabGUZOYSFdB90pMpxcPPCsyWSf05R+wNg9Is0AzhRA7xlZWr1sFZT5C9wZkSQO0
         dIUY4HATKEXat9kbLW3ZlaoJ4DL0vbul0zmDgjgHTLzM/nvzhwKEc+RJYR7VILcRZYjo
         g7AvLgH2798JqiCVcQjLAsYSqy8Tl8d7AnGN8SZ6NrqVQJBYRyrjCAPipYW40T7PCpow
         /jBevIE1ZT1NjnuCNqRcWTxU+nLa7Kfi05myozS/A1WyegZwKj0jdzGwB6bNTb3SephP
         jsCQIZ99IwZ+MU5s+jBg3RVQVlutWF6TUXsi29EPl0jREOabafq3ZSpLKHd49JfmKNRl
         4zPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=cxIhJxLH45f3paJwvO3rHF1VnfiXGcMj12zNmLMco38=;
        b=DBnPQV+3e1Q3qR2nYDZSHFNz942EC4V52w7GXzbeXmHWb5+ZBxLqyCzYRiQP80IJlX
         5iwv5JJ1C9b69F1sEf8SYRxz3Il6zuXrreAJZyy7q60lOcNhrRk9KW36WY+9kHV3PrQS
         gx2VpLR1f9X1MOaeHVzOyGX3/fKxS/yP+654Gu5BHnIn+gtrYTjDz8d3kmNf/wUPF/Hn
         a4lWuW/4jetaNduVJCoL0MlXrhPNZtLHQaH+VzSIJhd+4vNjxerVwCd7q7Df5xDEkXIN
         w3cP2FJR4aYSVq3ZuEi12m1LRZXoOcT4b6didAEWe2XKYbw6LzPnrHmcLF1yXrqGcETN
         coyQ==
X-Gm-Message-State: AOAM530iSglYrHT2Mnv8qCxCV3KTW777NRul1OpqN4RVDhyAumAD0y4p
        Wouk9sdUGi5RzVdNv8lAJwqm0Q==
X-Google-Smtp-Source: ABdhPJzVPn2LMqqZTY7tri4yJxfa+HUF9BmoHhAPU9CirLglXWr/b0lKQtT/FKueM7/ZdE3CHiyU2w==
X-Received: by 2002:a2e:a28e:: with SMTP id k14mr4404242lja.488.1638966023694;
        Wed, 08 Dec 2021 04:20:23 -0800 (PST)
Received: from localhost (h-46-59-90-226.A463.priv.bahnhof.se. [46.59.90.226])
        by smtp.gmail.com with ESMTPSA id p10sm299115lja.0.2021.12.08.04.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 04:20:23 -0800 (PST)
Date:   Wed, 8 Dec 2021 13:20:22 +0100
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH] sh_eth: Use dev_err_probe() helper
Message-ID: <YbCjBk0ibN1ga3Qm@oden.dyn.berto.se>
References: <2576cc15bdbb5be636640f491bcc087a334e2c02.1638959463.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2576cc15bdbb5be636640f491bcc087a334e2c02.1638959463.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for your work, I learnt something new.

On 2021-12-08 11:32:07 +0100, Geert Uytterhoeven wrote:

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> Use the dev_err_probe() helper, instead of open-coding the same
> operation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
> index 223626290ce0e278..d947a628e1663009 100644
> --- a/drivers/net/ethernet/renesas/sh_eth.c
> +++ b/drivers/net/ethernet/renesas/sh_eth.c
> @@ -3368,8 +3368,7 @@ static int sh_eth_drv_probe(struct platform_device *pdev)
>  	/* MDIO bus init */
>  	ret = sh_mdio_init(mdp, pd);
>  	if (ret) {
> -		if (ret != -EPROBE_DEFER)
> -			dev_err(&pdev->dev, "MDIO init failed: %d\n", ret);
> +		dev_err_probe(&pdev->dev, ret, "MDIO init failed\n");
>  		goto out_release;
>  	}
>  
> -- 
> 2.25.1
> 

-- 
Kind Regards,
Niklas Söderlund
