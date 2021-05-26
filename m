Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9CA3922A8
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 00:24:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234201AbhEZW0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 18:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233535AbhEZW0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 18:26:24 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20235C061574;
        Wed, 26 May 2021 15:24:52 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id c20so4914134ejm.3;
        Wed, 26 May 2021 15:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=upYwLtGa9fOyLSjVETQLNgUNJczN5tq2tRjvlYCAYGo=;
        b=ZxCGQpH6nBkwCGw0G4aCBFMjzk6ac/TrsxDKPTF8gcok0oyFO9QHIItZVUtoJVqrkP
         e58Ei6pd1eeRO0vAB5QB2QU/b9hOD911wnRbLHs0GVJMvB96pY0T40AT2RvrzDHaTIuw
         +aFeo89JSTl8EhFoM4cxvIXCVFCDArjm2J70+rihLntLAxcTPOXITRajVBKCHST9skXe
         6NL5dI/iuhG4gKFUUG9qtUs9XWU1kFwAWUJn5opbu0BPuKgvr+0u7oPIRXTNjMCRQvVr
         sGOsEpIZeoQEfYQw3aQMayz5QV9+BJGEkA5Uu7TgmCy5YFIzCEmrh66/apSllo7MJ4PS
         af/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=upYwLtGa9fOyLSjVETQLNgUNJczN5tq2tRjvlYCAYGo=;
        b=SPzD5XPgcB9N6KH4gncOnZoPAZAwATazFLO4nNaBVX+cj+DHxPlER6JPSrPOR6Ibn8
         fuTxCDzbZv3XSmGNe3PIBoSELtzLpuGbp4lJl5ZAxN7VU4UUiJ9mcqMyrhAX5tXfH1C1
         BmY7rP3ockzJqM3qRDgHYdt1jykambt0c0aex9q5ASeh0Nr30aRHDI8RXJ5orZrnANhZ
         jw281wp/kDjRu7SmGbD+DM3f+rDGLp+PpgGnEWZHq46dHaBc4MP0yzkIqVc6WDMGTxQR
         RXmNOdGcisBX0ozihzQoaz2MOBhisspkTOcCutJsqgTiEyMHQUl+GTEWR7HIGd8uKUPd
         ye8w==
X-Gm-Message-State: AOAM531zMNto4+7LOW0BQghxWmsQUh7w1K6m3mWAI3eg0wdzCSzKKxFq
        DSZh0L1FE/iqomGIX9G34rX9mPzp6kw=
X-Google-Smtp-Source: ABdhPJy7sCVIG2MoRN2VwdG/8PWQxOR7DuRxFzmXimafN2bG+97hAqkIVi2cKKwSsjaCg0nhzx1qfg==
X-Received: by 2002:a17:906:40d1:: with SMTP id a17mr495038ejk.43.1622067890603;
        Wed, 26 May 2021 15:24:50 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id r25sm92203edc.55.2021.05.26.15.24.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 15:24:50 -0700 (PDT)
Date:   Thu, 27 May 2021 01:24:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>
Subject: Re: [PATCH net-next v3 3/9] net: phy: micrel: use consistent
 indention after define
Message-ID: <20210526222448.zjpw3olck75332px@skbuf>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-4-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210526043037.9830-4-o.rempel@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 06:30:31AM +0200, Oleksij Rempel wrote:
> This patch changes the indention to one space between "#define" and the

indention
/ɪnˈdɛnʃ(ə)n/
noun
noun: indention; plural noun: indentions

    archaic term for indentation.

Interesting, I learned something new.

Also, technically it's alignment not indentation.

> macro.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/micrel.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index a14a00328fa3..227d88db7d27 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -38,15 +38,15 @@
>  
>  /* general Interrupt control/status reg in vendor specific block. */
>  #define MII_KSZPHY_INTCS			0x1B
> -#define	KSZPHY_INTCS_JABBER			BIT(15)
> -#define	KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
> -#define	KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
> -#define	KSZPHY_INTCS_PARELLEL			BIT(12)
> -#define	KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
> -#define	KSZPHY_INTCS_LINK_DOWN			BIT(10)
> -#define	KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
> -#define	KSZPHY_INTCS_LINK_UP			BIT(8)
> -#define	KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
> +#define KSZPHY_INTCS_JABBER			BIT(15)
> +#define KSZPHY_INTCS_RECEIVE_ERR		BIT(14)
> +#define KSZPHY_INTCS_PAGE_RECEIVE		BIT(13)
> +#define KSZPHY_INTCS_PARELLEL			BIT(12)
> +#define KSZPHY_INTCS_LINK_PARTNER_ACK		BIT(11)
> +#define KSZPHY_INTCS_LINK_DOWN			BIT(10)
> +#define KSZPHY_INTCS_REMOTE_FAULT		BIT(9)
> +#define KSZPHY_INTCS_LINK_UP			BIT(8)
> +#define KSZPHY_INTCS_ALL			(KSZPHY_INTCS_LINK_UP |\
>  						KSZPHY_INTCS_LINK_DOWN)
>  #define	KSZPHY_INTCS_LINK_DOWN_STATUS		BIT(2)
>  #define	KSZPHY_INTCS_LINK_UP_STATUS		BIT(0)

You left these aligned using tabs.

> @@ -54,11 +54,11 @@
>  						 KSZPHY_INTCS_LINK_UP_STATUS)
>  
>  /* PHY Control 1 */
> -#define	MII_KSZPHY_CTRL_1			0x1e
> +#define MII_KSZPHY_CTRL_1			0x1e
>  
>  /* PHY Control 2 / PHY Control (if no PHY Control 1) */
> -#define	MII_KSZPHY_CTRL_2			0x1f
> -#define	MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
> +#define MII_KSZPHY_CTRL_2			0x1f
> +#define MII_KSZPHY_CTRL				MII_KSZPHY_CTRL_2
>  /* bitmap of PHY register to set interrupt mode */
>  #define KSZPHY_CTRL_INT_ACTIVE_HIGH		BIT(9)
>  #define KSZPHY_RMII_REF_CLK_SEL			BIT(7)
> -- 
> 2.29.2
> 

And the last column of these macros at the end is aligned with spaces
unlike everything else:

/* Write/read to/from extended registers */
#define MII_KSZPHY_EXTREG                       0x0b
#define KSZPHY_EXTREG_WRITE                     0x8000

#define MII_KSZPHY_EXTREG_WRITE                 0x0c
#define MII_KSZPHY_EXTREG_READ                  0x0d

/* Extended registers */
#define MII_KSZPHY_CLK_CONTROL_PAD_SKEW         0x104
#define MII_KSZPHY_RX_DATA_PAD_SKEW             0x105
#define MII_KSZPHY_TX_DATA_PAD_SKEW             0x106

I guess if you're going to send this patch you might as well refactor it all.
