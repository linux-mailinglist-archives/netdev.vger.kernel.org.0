Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC563305C5E
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 14:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238059AbhA0NDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 08:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S313049AbhAZWrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 17:47:46 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506C7C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:47:05 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id bx12so971edb.8
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 14:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HgzEOzoEbZ1l+7iH/R2EQf3nAtw+FzQ+vvJeXAXwUwI=;
        b=q9DkZ0MzDvtYo9tyI7VIiaNDnaMMAwubaG4kRQx8WLND/H2qQzoDX5UQnn9TW9nNNP
         tECMG4Qc81bHshl/YpwBym7z2HLTXHbQ3L1cLobO2CaNtEGuXcqddsqZFqSNzznYelEj
         eUqYy7V2+xWDB4vK/RckjnBPBP8SBtHfeDn5i0AnMXKDuRb8MSoWujT9EAMo6FC+xfCn
         zf0oPzvzvI7TeMJkYX3qMMtGAELnpkS4Y1lHdfJTBvGButVMQsm0xrH2Lke8F4+m27zF
         tYcauOEclSNi/k+CT5jTluzaVN1a3/RvTpj/Q0/COIfE3whBTspLIR/A++1nIHPX6CSK
         6wAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HgzEOzoEbZ1l+7iH/R2EQf3nAtw+FzQ+vvJeXAXwUwI=;
        b=mTineP4lUtkcms1HPDBz6l+FEU+QZSVgl2uFLkKf7O0hinaXjCgwCBXNESBYyvDPqW
         EBWYmLstIPh3AnBLjK+A6G2JnrE6dKR9AA8yQtjzfnv+dZwEPQ2YeXZM3DiKSCjqEKj+
         of3JpLCDg4K387LSmaRgyDHg29TRVMFWHwbn6Qz7Kkg6BbRzEZlSIMOfoQCuM5qZ+6ng
         h+1zpbVuVy9Q334bK/uSUQ76UfHkN81UUx6yMRoe+c0juQl7+iDnOiECcSQgpsBKpnAI
         FOVlKH1qzN7PPD3WNphRrSlVJiTLnFIK+n5ocGNVMeZchUGk1WMd87L+Tee0Nn/B2mOQ
         HktQ==
X-Gm-Message-State: AOAM532mOgQxpfzRWg1Y+9m8A+fsanImpb8bGKS/YKNNzhqwBw+t3qSk
        oDyUkQDJak+T6DmWLmbcVWRLaUHoENIcZqP3uow=
X-Google-Smtp-Source: ABdhPJzM97lpZHC10fQcQWUovquDvnAMai6lz5ZBxIxjFBlwONgFj2Onlt4oEC56x6cNKk24jL4z/NvcDQS1GUj9ZhA=
X-Received: by 2002:a50:eb81:: with SMTP id y1mr6089462edr.176.1611701224122;
 Tue, 26 Jan 2021 14:47:04 -0800 (PST)
MIME-Version: 1.0
References: <20210126115854.2530-1-qiangqing.zhang@nxp.com> <20210126115854.2530-2-qiangqing.zhang@nxp.com>
In-Reply-To: <20210126115854.2530-2-qiangqing.zhang@nxp.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 26 Jan 2021 17:46:26 -0500
Message-ID: <CAF=yD-J-WDY6GPP-4B-9v78wJf3yj6vrqhHnbyhg1kx6Wc1yHg@mail.gmail.com>
Subject: Re: [PATCH V3 1/6] net: stmmac: remove redundant null check for ptp clock
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-imx@nxp.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 7:05 AM Joakim Zhang <qiangqing.zhang@nxp.com> wrote:
>
> Remove redundant null check for ptp clock.
>
> Fixes: 1c35cc9cf6a0 ("net: stmmac: remove redundant null check before clk_disable_unprepare()")

This does not look like a fix to that patch, but another instance of a cleanup.

The patchset also does not explicitly target net (for fixes) or
net-next (for new improvements). I suppose this patch targets
net-next.

> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> index 26b971cd4da5..11e0b30b2e01 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> @@ -5291,8 +5291,7 @@ int stmmac_resume(struct device *dev)
>                 /* enable the clk previously disabled */
>                 clk_prepare_enable(priv->plat->stmmac_clk);
>                 clk_prepare_enable(priv->plat->pclk);
> -               if (priv->plat->clk_ptp_ref)
> -                       clk_prepare_enable(priv->plat->clk_ptp_ref);
> +               clk_prepare_enable(priv->plat->clk_ptp_ref);
>                 /* reset the phy so that it's ready */
>                 if (priv->mii)
>                         stmmac_mdio_reset(priv->mii);
> --
> 2.17.1
>
