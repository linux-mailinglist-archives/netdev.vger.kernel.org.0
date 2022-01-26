Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660D049D07C
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 18:14:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbiAZROa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 12:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243620AbiAZRO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 12:14:28 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259CC06161C;
        Wed, 26 Jan 2022 09:14:28 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id f17so266768wrx.1;
        Wed, 26 Jan 2022 09:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gXtdrW27fCZ/wJUPBVbcRIlDfwjyibpVlA/v0Qe0N+A=;
        b=ShEI2vtBBOEzdM8KBa2+C+sra9rF3eUL8rq9LzYJlSnCdzLTrR9bprTUNRFKfPviWE
         9LxSGdHftoFFaEfs5hs4wlUS92fvaNMhsVvPgTvT2ilBpLXxDvPOF61ztFbDBhyABL1T
         NeAJUgNQN40uFADgvWGHHvtXEXm6/Ml8nuddZ7Oji2LkhqqcjoyLsgnsrnl+kd6/i1iI
         yQRqPJInXft4GD+ohxuxSx1AAny0JGtYF1WIsfY27wSah06MVOWb4YXlTQSzlElHgJAI
         dMjR619JNdTUz0aIjR8ixqhJOIRS0C31q6OhH3D1GxGbZ8jz/18gsCQB3V33I37fzdsc
         T8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gXtdrW27fCZ/wJUPBVbcRIlDfwjyibpVlA/v0Qe0N+A=;
        b=e2WKTQgXDEHI6E6SlX6GoQVq6M6AcRB3Ok0wB8gqdSGCT+OgVvz7/GUF9YabliLVFb
         6xnAv8uLpcxn2s1QPriyNg77jzcy21TpXPm53dqRAOpnYN9lfg9qDygZjFHrADRJ+acZ
         O5b8RdD+ldDgNy5tcfnobpFUtZ/pOl9eCnWrRIsx/u/AQMuW/CoPanFYwvbP2kiD6b6B
         hOV0Lg6KL6XJSAXHN9zeYNwCImSuopKEC8UjLrLeZVcv5ASgXvanEiXXCOKPbIu95yU/
         pb66rTEUqIpyWAfe+pgT2/38rYUDLa+XzTi6MiLWbYit5q0K+dcpqTXug6FE3UAm1UQO
         sRug==
X-Gm-Message-State: AOAM533naaXgCqSku43pMez2k9Grw14gu8W5drmOMyujSiXGAmqgdDb8
        IuphwoRghFAOgqlMQgKlW0M=
X-Google-Smtp-Source: ABdhPJwj+3itbOp8dJx8AHey5VYTt5YOotHUNr1kojxGb+QydODRJny0bAdqTKmSHnhQdy6BUYrH6g==
X-Received: by 2002:a05:6000:81:: with SMTP id m1mr18100420wrx.385.1643217266591;
        Wed, 26 Jan 2022 09:14:26 -0800 (PST)
Received: from kista.localnet (cpe-86-58-32-107.static.triera.net. [86.58.32.107])
        by smtp.gmail.com with ESMTPSA id c8sm4800962wmq.34.2022.01.26.09.14.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:14:26 -0800 (PST)
From:   Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jisheng Zhang <jszhang@kernel.org>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()
Date:   Wed, 26 Jan 2022 18:14:25 +0100
Message-ID: <5533854.DvuYhMxLoT@kista>
In-Reply-To: <20220126165215.1921-1-jszhang@kernel.org>
References: <20220126165215.1921-1-jszhang@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Dne sreda, 26. januar 2022 ob 17:52:15 CET je Jisheng Zhang napisal(a):
> When readl_poll_timeout() timeout, we'd better directly use its return
> value.
> 
> Before this patch:
> [    2.145528] dwmac-sun8i: probe of 4500000.ethernet failed with error -14
> 
> After this patch:
> [    2.138520] dwmac-sun8i: probe of 4500000.ethernet failed with error -110
> 
> Signed-off-by: Jisheng Zhang <jszhang@kernel.org>

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej

> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c b/drivers/net/
ethernet/stmicro/stmmac/dwmac-sun8i.c
> index 617d0e4c6495..09644ab0d87a 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c
> @@ -756,7 +756,7 @@ static int sun8i_dwmac_reset(struct stmmac_priv *priv)
>  
>  	if (err) {
>  		dev_err(priv->device, "EMAC reset timeout\n");
> -		return -EFAULT;
> +		return err;
>  	}
>  	return 0;
>  }
> -- 
> 2.34.1
> 
> 


