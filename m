Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 822131472FF
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728901AbgAWVNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:13:12 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38519 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbgAWVNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:13:11 -0500
Received: by mail-ed1-f67.google.com with SMTP id i16so4862330edr.5;
        Thu, 23 Jan 2020 13:13:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dh2wt1vORa35MTM3FuGiuCtiW/CFK3Ccqbeyfn7ivTI=;
        b=Br1gHiZhtEos2FE84vsmPLrz7y9aPx1FHdepJbLcQe6rKsLX944lSzvKlnFFHrao+u
         OgZRGimuRrGs8l7319YKrzQj3uuYQ68+VIvE5wJRiJLBHWDim1p5yT+r5fBW0i1MMtc5
         C94h7/VtpLspAGIup4FwX2aiCcyC/mVs3UEfOPu8t438OD5Fr63Bhos8ko4sRDeeZICn
         a434UyLJY19Z1UNf0u6FC+SzjahHcVAZvOm3QPeKU7eCggo4BjB0fY9fQySIIY6swXVu
         N4ZzS7NHs6pwGARnZ+jm2W7fYePXf+5rWs0tT3NRNHghczRoEXLEcY7vnEKOKkHqWl0D
         Kx9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Dh2wt1vORa35MTM3FuGiuCtiW/CFK3Ccqbeyfn7ivTI=;
        b=tg/t4HPkQyyizGZqcWR5JySedgkewowG9w4t5A9kPdEl/1aihbK20xi8ncEpTGH1k0
         ZEDfcg87vjuDdt6+WTdsuUqiynRuzhwRv7dD9WzFdBp0I7bRJvmR2/yxE+DIxOOfVajT
         0sAsnvpWzLXPLsbFVM6+TuoPN+M2RT9WL88skpPMhQvo7ihRmf0gcn1opMo/IebJGxWS
         piVmGfnpIBEpYyUE1GAgdg630vsa+KUDBiRTTHSlEwUJ1bqxCayeAGPRid3Y4DZx+8xx
         8Law1yXJSCk/WnLj/lknbc1Sg72BdCwsg9CDjOA3S+HZZSpmO/cmPY1wQ8d/D14HEAib
         gslg==
X-Gm-Message-State: APjAAAWB7RDYA7+/fmeNddbyLp9H4ypf/hO3/zspVnU7MpKXNKHy/Nrz
        xaOCWCeZ810wQ/EW0gq5rSg=
X-Google-Smtp-Source: APXvYqx6wnIYlrFVF9yeSitfx4KEX6bfY3YcCjjjY1kcHH4cpgS5OW6MMyYedqGO/MG9BQNVLEN4lw==
X-Received: by 2002:a17:906:c40d:: with SMTP id u13mr25787ejz.178.1579813988472;
        Thu, 23 Jan 2020 13:13:08 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o15sm40291edj.3.2020.01.23.13.13.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:13:07 -0800 (PST)
Subject: Re: [RFC 2/2] net: bcmgenet: Fetch MAC address from the adapter
To:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net
References: <20200123060823.1902366-1-jeremy.linton@arm.com>
 <20200123060823.1902366-3-jeremy.linton@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <465844cf-ff19-9bb5-15d3-cc876a2d40f6@gmail.com>
Date:   Thu, 23 Jan 2020 13:13:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200123060823.1902366-3-jeremy.linton@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/20 10:08 PM, Jeremy Linton wrote:
> ARM/ACPI machines should utilize self describing hardware
> when possible. The MAC address on the BCM GENET can be
> read from the adapter if a full featured firmware has already
> programmed it. Lets try using the address already programmed,
> if it appears to be valid.

s/BCM GENET/BCMGENET/ or just GENET.

> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  .../net/ethernet/broadcom/genet/bcmgenet.c    | 47 ++++++++++++++-----
>  1 file changed, 36 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index c736700f829e..6782bb0a24bd 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -2779,6 +2779,27 @@ static void bcmgenet_set_hw_addr(struct bcmgenet_priv *priv,
>  	bcmgenet_umac_writel(priv, (addr[4] << 8) | addr[5], UMAC_MAC1);
>  }
>  
> +static void bcmgenet_get_hw_addr(struct bcmgenet_priv *priv,
> +				 unsigned char *addr)
> +{
> +	u32 addr_tmp;
> +	bool acpi_mode = has_acpi_companion(&priv->pdev->dev);
> +
> +	/* UEFI/ACPI machines and possibly others will preprogram the MAC */
> +	if (acpi_mode) {
> +		addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC0);
> +		addr[0] = addr_tmp >> 24;
> +		addr[1] = (addr_tmp >> 16) & 0xff;
> +		addr[2] = (addr_tmp >>	8) & 0xff;
> +		addr[3] = addr_tmp & 0xff;
> +		addr_tmp = bcmgenet_umac_readl(priv, UMAC_MAC1);
> +		addr[4] = (addr_tmp >> 8) & 0xff;
> +		addr[5] = addr_tmp & 0xff;
> +	} else {
> +		memset(addr, 0, ETH_ALEN);
> +	}
> +}
> +
>  /* Returns a reusable dma control register value */
>  static u32 bcmgenet_dma_disable(struct bcmgenet_priv *priv)
>  {
> @@ -3509,11 +3530,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	}
>  	priv->wol_irq = platform_get_irq_optional(pdev, 2);
>  
> -	if (dn)
> -		macaddr = of_get_mac_address(dn);
> -	else if (pd)
> -		macaddr = pd->mac_address;
> -
>  	priv->base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(priv->base)) {
>  		err = PTR_ERR(priv->base);
> @@ -3524,12 +3540,6 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  	dev_set_drvdata(&pdev->dev, dev);
> -	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
> -		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
> -		eth_hw_addr_random(dev);
> -	} else {
> -		ether_addr_copy(dev->dev_addr, macaddr);
> -	}
>  	dev->watchdog_timeo = 2 * HZ;
>  	dev->ethtool_ops = &bcmgenet_ethtool_ops;
>  	dev->netdev_ops = &bcmgenet_netdev_ops;
> @@ -3601,6 +3611,21 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	    !strcasecmp(phy_mode_str, "internal"))
>  		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
>  
> +	if (dn)
> +		macaddr = of_get_mac_address(dn);
> +	else if (pd)
> +		macaddr = pd->mac_address;

I would be adding an:

	else if (has_acpi_companion())
		bcmgenet_get_hw_addr(priv, macaddr);

such that bcmgenet_get_hw_addr() does not have much ACPI specific
knowledge and get be used outside, with the caller knowing whether it is
appropriate.

You should also indicate in your commit message that you are moving the
fetching of the MAC address at a later point where the clocks are turned
on, to guarantee that the registers can be read.

With that fixed:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

> +
> +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
> +		bcmgenet_get_hw_addr(priv, dev->dev_addr);
> +		if (!is_valid_ether_addr(dev->dev_addr)) {
> +			dev_warn(&pdev->dev, "using random Ethernet MAC\n");
> +			eth_hw_addr_random(dev);
> +		}
> +	} else {
> +		ether_addr_copy(dev->dev_addr, macaddr);
> +	}
> +
>  	reset_umac(priv);
>  
>  	err = bcmgenet_mii_init(dev);
> 


-- 
Florian
