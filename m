Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C036569358
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 22:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233944AbiGFUbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 16:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbiGFUbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 16:31:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2152624947;
        Wed,  6 Jul 2022 13:31:06 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id y4so7322763edc.4;
        Wed, 06 Jul 2022 13:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=1v5gM944L5tDj/Xu6xRU9MCTrntk7X6mN2H+Xf8Tb/c=;
        b=qG4bTw8eCoArv/oT+Be43zAigsJBgPo7mTt2RyL0WrhGXREGSbk4MJ2BYoXorg2lp3
         8kJYJmWxpNpiUfzC1mN9AGcj0wwVed+8FYIlFGeXQ5g8V0WVcg1rwPIl3JNAFOSE74zI
         ntFATBrx9VtCo1ycasWlBMtiLPtDyWAcHnx8JwNXUtC7LSBFOlZWHNhFcyHbgSEppkgZ
         wXy7EzDku1EDmCPclXUQDdlacoiJCqyhtWDVVJcNI5MQiqugGDoNRk1lk095xq36nBmx
         3wjcQwWnm1RHire4BY0miaEX0pqxZkO5X1fYHn5z+31GmAAgd4w3HYIpjU7eShn+kKiS
         La2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=1v5gM944L5tDj/Xu6xRU9MCTrntk7X6mN2H+Xf8Tb/c=;
        b=l68Ghdp8m1O95DhCOmtjbGfUgj3qj2xRZYrpRbxa84PkZTWLVLeUb9IW7P7bHiFML0
         LAM++Q10iuHe7o7nhspVaAnI9deRkf1oDw2f3fRZIZaCdGErVUBJd3lnxXFPOA8iPu8G
         TtgKrrkSaVICRUDiyj4MezFG/xo6GaLBIRIRxXRLtk8Nbk+mRUs18GBPW6DBAygiFE0+
         s1mmmd54zgG0GNp9CaXIpIjz14EUX8rtrNP90UqWC0s43urIMN4IV8+PScxkYFL2jgrw
         JD0HeD+hMnqx85Snj3q8yDtqrKvx1W9i7jd3ePsiMAqIOQSA+QAxFs8K4MUK81E2t9rC
         gWkA==
X-Gm-Message-State: AJIora8NQkM5bRSebTxA4uPxH9lgv9gdCiK6QHxymqev6emW6TVL6wPj
        ALq1Zh5tNPfyfrpmNY677oYr24h5xnrt+UtU
X-Google-Smtp-Source: AGRyM1u7SLtcpQcpbwX6KU+tRmd96YFXMbAyX6uUWtrnbxjA6PRM0XlvfmDxsuxny120zaWR4MEfbA==
X-Received: by 2002:a05:6402:90a:b0:439:c144:24cd with SMTP id g10-20020a056402090a00b00439c14424cdmr33657507edz.209.1657139464674;
        Wed, 06 Jul 2022 13:31:04 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id f3-20020a170906138300b006fe9209a9edsm17628444ejc.128.2022.07.06.13.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 13:31:04 -0700 (PDT)
Date:   Wed, 6 Jul 2022 23:31:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, Doug Berger <opendmb@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        andrew@lunn.ch
Subject: Re: [PATCH stable 4.9 v2] net: dsa: bcm_sf2: force pause link
 settings
Message-ID: <20220706203102.6pd5fac7tkyi4idz@skbuf>
References: <20220706192455.56001-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220706192455.56001-1-f.fainelli@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Wed, Jul 06, 2022 at 12:24:54PM -0700, Florian Fainelli wrote:
> From: Doug Berger <opendmb@gmail.com>
> 
> commit 7c97bc0128b2eecc703106112679a69d446d1a12 upstream
> 
> The pause settings reported by the PHY should also be applied to the
> GMII port status override otherwise the switch will not generate pause
> frames towards the link partner despite the advertisement saying
> otherwise.
> 
> Fixes: 246d7f773c13 ("net: dsa: add Broadcom SF2 switch driver")
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20220623030204.1966851-1-f.fainelli@gmail.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Changes in v2:
> 
> - use both local and remote advertisement to determine when to apply
>   flow control settings
> 
>  drivers/net/dsa/bcm_sf2.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
> index 40b3adf7ad99..562b5eb23d90 100644
> --- a/drivers/net/dsa/bcm_sf2.c
> +++ b/drivers/net/dsa/bcm_sf2.c
> @@ -600,7 +600,9 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>  	struct bcm_sf2_priv *priv = bcm_sf2_to_priv(ds);
>  	struct ethtool_eee *p = &priv->port_sts[port].eee;
>  	u32 id_mode_dis = 0, port_mode;
> +	u16 lcl_adv = 0, rmt_adv = 0;
>  	const char *str = NULL;
> +	u8 flowctrl = 0;
>  	u32 reg;
>  
>  	switch (phydev->interface) {
> @@ -667,10 +669,24 @@ static void bcm_sf2_sw_adjust_link(struct dsa_switch *ds, int port,
>  		break;
>  	}
>  
> +	if (phydev->pause)
> +		rmt_adv = LPA_PAUSE_CAP;
> +	if (phydev->asym_pause)
> +		rmt_adv |= LPA_PAUSE_ASYM;
> +	if (phydev->advertising & ADVERTISED_Pause)
> +		lcl_adv = ADVERTISE_PAUSE_CAP;
> +	if (phydev->advertising & ADVERTISED_Asym_Pause)
> +		lcl_adv |= ADVERTISE_PAUSE_ASYM;
> +	flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);

IEEE 802.3 says "The PAUSE function shall be enabled according to Table
28B–3 only if the highest common denominator is a full duplex technology."

> +
>  	if (phydev->link)
>  		reg |= LINK_STS;
>  	if (phydev->duplex == DUPLEX_FULL)
>  		reg |= DUPLX_MODE;
> +	if (flowctrl & FLOW_CTRL_TX)
> +		reg |= TXFLOW_CNTL;
> +	if (flowctrl & FLOW_CTRL_RX)
> +		reg |= RXFLOW_CNTL;
>  
>  	core_writel(priv, reg, CORE_STS_OVERRIDE_GMIIP_PORT(port));
>  
> -- 
> 2.25.1
> 

