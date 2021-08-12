Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449103EA20A
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 11:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231520AbhHLJah (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 05:30:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234824AbhHLJag (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 05:30:36 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1870AC061765
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 02:30:11 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x27so12301660lfu.5
        for <netdev@vger.kernel.org>; Thu, 12 Aug 2021 02:30:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=m8QHPV2J/65Y2sFquSJNLPWg3P0v7gAx6Klrrr4iNrs=;
        b=g2YOql5hOIh3QTWYd4TTUJZ2Cvg9Giu2Scd8f/wFFriRvZWCuYpZCNG4XvuaqnBaer
         rHkq4B6KgZZXkWaqQODh+wDEA5owl9sgBEUJUtw0TZXsgiR4xOVO412v4AlgMAqaVh4V
         9ojOIg74VBvAHqbIySWtl7VDzLR2Jpz9VIshgOUVcTYq6OThdjd+t3ArlQMuwqHJDG6A
         HcJI3W38K0Duv74fc23Jq1McYBZt+gP1VMq4jH2eiqBveTuR4Kwe8zegj1Wu/znhLdKg
         Z66/nzWYa0rMtT0bjwP1iAXKkL9A1PeliHxILgG1SHRI1R/7zbFbzjNgOOkwDc8dLyp7
         OrjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=m8QHPV2J/65Y2sFquSJNLPWg3P0v7gAx6Klrrr4iNrs=;
        b=FVnhH7Iws5IbOq/Q37hA+VmmMIfHMdE39U9R2oyJaM7AdnejHUF1PtFmewggl8thRk
         KO1e4ul8UYiLXSAaux6PQkHlKR3hv+UN3mN+8tlqJTE+lDhWKO1EMIl055EUQbX3XcMx
         liLm68XLD71mpTE3YlYi/x7Z7eadqAEEUPUb6jVasYy9g3F3fm0pbgo6hhjmrf5iZyvb
         g/yFjsOCUwwVTUEliVKAtSFFtvZiVu4KMcNgVpFHz1W2Hf2NegMKw86QfTIQ49ffj/Ys
         2GDd1jG4mKz+D5EAqCVQa08WmWGPbsWD6kYeTI+P6ka693Q+NIuOpOHVk1RACfhLz5XU
         P1NA==
X-Gm-Message-State: AOAM533dcvf6c6VHar2vpAo2XU/pW17oQTzXFhUcIoKQ5tQhZjlZ2x+c
        tgYHsDYW3sMXgKqgnxPMoXCS4A==
X-Google-Smtp-Source: ABdhPJww+MW1KUdXvxy3UkACWPiy/qFg6d+3Wtd8EQhBb1K3ju32GdL1NKzWzIyYG2a4816CAin4kw==
X-Received: by 2002:a05:6512:3b5:: with SMTP id v21mr1869672lfp.270.1628760607922;
        Thu, 12 Aug 2021 02:30:07 -0700 (PDT)
Received: from localhost (h-46-59-88-219.A463.priv.bahnhof.se. [46.59.88.219])
        by smtp.gmail.com with ESMTPSA id f11sm205927lfh.58.2021.08.12.02.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Aug 2021 02:30:07 -0700 (PDT)
Date:   Thu, 12 Aug 2021 11:30:06 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH net-next] ravb: Remove checks for unsupported internal
 delay modes
Message-ID: <YRTqHgRuyb7RLtyc@oden.dyn.berto.se>
References: <2037542ac56e99413b9807e24049711553cc88a9.1628696778.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2037542ac56e99413b9807e24049711553cc88a9.1628696778.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for your work.

On 2021-08-11 17:49:00 +0200, Geert Uytterhoeven wrote:
> The EtherAVB instances on the R-Car E3/D3 and RZ/G2E SoCs do not support
> TX clock internal delay modes, and the EtherAVB driver prints a warning
> if an unsupported "rgmii-*id" PHY mode is specified, to catch buggy
> DTBs.
> 
> Commit a6f51f2efa742df0 ("ravb: Add support for explicit internal
> clock delay configuration") deprecated deriving the internal delay mode
> from the PHY mode, in favor of explicit configuration using the now
> mandatory "rx-internal-delay-ps" and "tx-internal-delay-ps" properties,
> thus delegating the warning to the legacy fallback code.
> 
> Since explicit configuration of a (valid) internal clock delay
> configuration is enforced by validating device tree source files against
> DT binding files, and all upstream DTS files have been converted as of
> commit a5200e63af57d05e ("arm64: dts: renesas: rzg2: Convert EtherAVB to
> explicit delay handling"), the checks in the legacy fallback code can be
> removed.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

I really like clean-up patches :-)

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  drivers/net/ethernet/renesas/ravb_main.c | 15 ++-------------
>  1 file changed, 2 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index f4dfe9f71d067533..62b0605f02ff786e 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
> @@ -1973,13 +1973,6 @@ static void ravb_set_config_mode(struct net_device *ndev)
>  	}
>  }
>  
> -static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
> -	{ .soc_id = "r8a774c0" },
> -	{ .soc_id = "r8a77990" },
> -	{ .soc_id = "r8a77995" },
> -	{ /* sentinel */ }
> -};
> -
>  /* Set tx and rx clock internal delay modes */
>  static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
>  {
> @@ -2010,12 +2003,8 @@ static void ravb_parse_delay_mode(struct device_node *np, struct net_device *nde
>  
>  	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
>  	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
> -		if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
> -			  "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
> -			  phy_modes(priv->phy_interface))) {
> -			priv->txcidm = 1;
> -			priv->rgmii_override = 1;
> -		}
> +		priv->txcidm = 1;
> +		priv->rgmii_override = 1;
>  	}
>  }
>  
> -- 
> 2.25.1
> 

-- 
Regards,
Niklas Söderlund
