Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49287202614
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbgFTTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 15:04:36 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:44483 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728385AbgFTTEg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 15:04:36 -0400
Received: by mail-lj1-f196.google.com with SMTP id c17so15053786lji.11
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 12:04:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gt87KtJU3Py2Xwggx3DihBEvBGQErKAovzogrK/Y7Og=;
        b=sWaxqeRiMDYEKs3Z+H86iGb4nPp0cOYA25+AhFEFnHeRk+/OQWg6x/DvGURYiQ8Zq4
         gUjApymfUikESf21dumpMFLmPOMrHFUQaJxks86JZ+xi85eZFzjgM4dNc0T3+yC220CG
         7j+8iPvgxRo/59SLecApE4+NP7Y3TXm6dhUJTZyVTk8PQ3gfkgS5xFtbVdIARTqtOzLD
         3Q9twdq1R6+u+UdAXAbLhhN5M+raYYOuumQSgtT3SH8d3DpMzpdWw/kJZOeu4CoJbMzN
         c6UDL5yXSkpJWmWeRnISqf4OiPwoiz3jtFxXLcjDUHKzrSGIOp7lpnjBwFg/GepINoum
         GUVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=gt87KtJU3Py2Xwggx3DihBEvBGQErKAovzogrK/Y7Og=;
        b=J2JebaqFCZ4IRP3jTjP7RUFWOylUBnV5QonWSAzkC7hqn/QH1XE0DO1/pNwjHvKXmK
         CUz2vD1rq+dcXzgVcBYO0OlPIf7xRZ6gHpRTY6sybZAoXfYKFVqS0r0MRgtdHyv6n7W/
         NMR4I54y9Go0a4PmZLTFLu4BqERF6GjY325Zy29tD2cIJmq1IVyObh/GdMB/NfC++vcq
         857lV0J5Yl3V35vFpzuSjxSnUaE/QJPSOznGPYj+Q6qgmcmpf27GNUnGVrgX6WlRWF0I
         Eu+9q56g0ogZQG4IntLDo4EDIJlUxyH6K1BUO4UizyCYiw8adk/Ha9i970u8AiuIVzPV
         cJCQ==
X-Gm-Message-State: AOAM532akkKw5USGRKCVfwJHHaW2QKC/wmoBnXO2BqUj6At3GL40lzlE
        P3RaPK7phbxgxcFGOGB237/+jw==
X-Google-Smtp-Source: ABdhPJw93ovWZoxrXKvmkItjVDf94YDZeudxy0paHQYMT1hCqW6/dQs8UC01ensQsGNSHhUcHyNg+A==
X-Received: by 2002:a2e:3603:: with SMTP id d3mr4369653lja.259.1592679812386;
        Sat, 20 Jun 2020 12:03:32 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:462b:c4af:1cf5:65ea:51a9:9da1])
        by smtp.gmail.com with ESMTPSA id x64sm151223lff.14.2020.06.20.12.03.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jun 2020 12:03:31 -0700 (PDT)
Subject: Re: [PATCH/RFC 3/5] ravb: Add support for explicit internal clock
 delay configuration
To:     Geert Uytterhoeven <geert+renesas@glider.be>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Philippe Schenker <philippe.schenker@toradex.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
References: <20200619191554.24942-1-geert+renesas@glider.be>
 <20200619191554.24942-4-geert+renesas@glider.be>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <6935aea3-0acd-f1b9-b36c-553b8c3106d1@cogentembedded.com>
Date:   Sat, 20 Jun 2020 22:03:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20200619191554.24942-4-geert+renesas@glider.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/19/2020 10:15 PM, Geert Uytterhoeven wrote:

> Some EtherAVB variants support internal clock delay configuration, which
> can add larger delays than the delays that are typically supported by
> the PHY (using an "rgmii-*id" PHY mode, and/or "[rt]xc-skew-ps"
> properties).
> 
> Historically, the EtherAVB driver configured these delays based on the
> "rgmii-*id" PHY mode.  This caused issues with PHY drivers that
> implement PHY internal delays properly[1].  Hence a backwards-compatible
> workaround was added by masking the PHY mode[2].
> 
> Add proper support for explicit configuration of the MAC internal clock
> delays using the new "renesas,[rt]xc-delay-ps" properties.
> Fall back to the old handling if none of these properties is present.
> 
> [1] Commit bcf3440c6dd78bfe ("net: phy: micrel: add phy-mode support for
>     the KSZ9031 PHY")
> [2] Commit 9b23203c32ee02cd ("ravb: Mask PHY mode to avoid inserting
>     delays twice").
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
>  drivers/net/ethernet/renesas/ravb.h      |  1 +
>  drivers/net/ethernet/renesas/ravb_main.c | 35 ++++++++++++++++++------
>  2 files changed, 27 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index e5ca12ce93c730a9..7453b17a37a2c8d0 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -1038,6 +1038,7 @@ struct ravb_private {
>  	unsigned wol_enabled:1;
>  	unsigned rxcidm:1;		/* RX Clock Internal Delay Mode */
>  	unsigned txcidm:1;		/* TX Clock Internal Delay Mode */
> +	unsigned rgmii_override:1;	/* Deprecated rgmii-*id behavior */
>  	int num_tx_desc;		/* TX descriptors per packet */
>  };
>  
> diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
> index f326234d1940f43e..0582846bec7726b6 100644
> --- a/drivers/net/ethernet/renesas/ravb_main.c
> +++ b/drivers/net/ethernet/renesas/ravb_main.c
[...]
> @@ -1967,20 +1963,41 @@ static const struct soc_device_attribute ravb_delay_mode_quirk_match[] = {
>  };
>  
>  /* Set tx and rx clock internal delay modes */
> -static void ravb_parse_delay_mode(struct net_device *ndev)
> +static void ravb_parse_delay_mode(struct device_node *np, struct net_device *ndev)
>  {
>  	struct ravb_private *priv = netdev_priv(ndev);
> +	bool explicit_delay = false;
> +	u32 delay;
> +
> +	if (!of_property_read_u32(np, "renesas,rxc-delay-ps", &delay)) {
> +		/* Valid values are 0 and 1800, according to DT bindings */
> +		priv->rxcidm = !!delay;
> +		explicit_delay = true;
> +	}
> +	if (!of_property_read_u32(np, "renesas,txc-delay-ps", &delay)) {
> +		/* Valid values are 0 and 2000, according to DT bindings */
> +		priv->txcidm = !!delay;
> +		explicit_delay = true;
> +	}
>  
> +	if (explicit_delay)
> +		return;
> +
> +	/* Fall back to legacy rgmii-*id behavior */
>  	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
> -	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_RXID) {
>  		priv->rxcidm = true;
> +		priv->rgmii_override = true;

   Mhm, these fields are not bool...

> +	}
>  
>  	if (priv->phy_interface == PHY_INTERFACE_MODE_RGMII_ID ||
>  	    priv->phy_interface == PHY_INTERFACE_MODE_RGMII_TXID) {
>  		if (!WARN(soc_device_match(ravb_delay_mode_quirk_match),
>  			  "phy-mode %s requires TX clock internal delay mode which is not supported by this hardware revision. Please update device tree",
> -			  phy_modes(priv->phy_interface)))
> +			  phy_modes(priv->phy_interface))) {
>  			priv->txcidm = true;
> +			priv->rgmii_override = true;

    Same here...

[...]

MBR, Sergei
