Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691A73245EE
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 22:46:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235541AbhBXVpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 16:45:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhBXVph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 16:45:37 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0A4C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 13:44:57 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id n20so5472271ejb.5
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 13:44:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ldh5qjtrn5wktGqDftqtnEqirgzHDmavEddCK8Ojkq4=;
        b=ZwfHolFTt5GMh/c0cvj72jpWpoA87x70Hl4PrB4MGyZ1v5X4KHW0CiAxwnMd1aScnL
         7XzsUcptzaHTz3CIgE6Sbd9IiAGxn2Fibb3jf7ZMY3g+QKvLuwr/fvhRGiKRZXu0JAVg
         1y6srEnS3u6HYJIJQFmetvaUo7qUKjLHLptyQhp3hp440fXVZdQpBQz4zIXt/XtbAT7K
         DIYh9MYEss5xHkytSrMG6Ptl4/oibgelgWm8JgcaQHWh8NGuSmb/0jOpjO6TkS5IQd9J
         q/ImaZF8hbbyhaMh8ye/wMlTVl9sHJnMSl0p90xSq4Qup0kuqoDqvzspSYQDGQySFh8T
         6bjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ldh5qjtrn5wktGqDftqtnEqirgzHDmavEddCK8Ojkq4=;
        b=CTrPjfKoMbyr/DtHrodtGCSmasUKuEZkHnksm3r23JPLuBjgXGoANgl6pEyuLJ6P95
         Fh4NpZ1zeLzQGKLmUISS2/e7XcHx3WNY+GZmzGeCF1JV4b5nz1zUhH4H0JSi8r5KNayq
         X+CAt0V5+3vL6gKDuwfD7CEx3kFnm63WmwQ4j/fw+Z3hg4WpcpvbQu7ft3yw/dXN4TNK
         GUvK6EsM66dIQD8GuRbBNcgSF18pA41quZlpsC8GN/L3jR/xMy5qEinAGlnCiWcmmozS
         NHcPzMhUMgqQ6jEw+a2NXLZmil+30Xrhj2lvRLzLXuy+ldLfEUh2u1CHz65waZUKm041
         DRNg==
X-Gm-Message-State: AOAM532kzqQHAFV3sQty+JlsS/LK9Lka4X33QjzZkUX/QDlnFeCPHysF
        OkYwamlMTBOlG92kRGNEDVk=
X-Google-Smtp-Source: ABdhPJwIpGGI8Cvuqbj4JK6UAhRJLR2vm+XCzvAyZUYTPqCHYUwW5NUT8cJciT0L4RSWnYL5elvPBQ==
X-Received: by 2002:a17:906:a099:: with SMTP id q25mr32722146ejy.549.1614203096280;
        Wed, 24 Feb 2021 13:44:56 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:9443:f5bc:7a63:9b6c? (p200300ea8f395b009443f5bc7a639b6c.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:9443:f5bc:7a63:9b6c])
        by smtp.googlemail.com with ESMTPSA id x21sm2373464eds.9.2021.02.24.13.44.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 13:44:55 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        davem@davemloft.net
Cc:     kuba@kernel.org, f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
References: <2323124.5UR7tLNZLG@tool>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
Date:   Wed, 24 Feb 2021 22:44:49 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <2323124.5UR7tLNZLG@tool>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.02.2021 16:44, Daniel González Cabanelas wrote:
> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
> result of this it works in polling mode.
> 
> Fix it using the phy_device structure to assign the platform IRQ.
> 
> Tested under a BCM6348 board. Kernel dmesg before the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
> 
> After the patch:
>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
> 
> Pluging and uplugging the ethernet cable now generates interrupts and the
> PHY goes up and down as expected.
> 
> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
> ---
> changes in V2: 
>   - snippet moved after the mdiobus registration
>   - added missing brackets
> 
>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index fd876721316..dd218722560 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>  		 * if a slave is not present on hw */
>  		bus->phy_mask = ~(1 << priv->phy_id);
>  
> -		if (priv->has_phy_interrupt)
> +		ret = mdiobus_register(bus);
> +
> +		if (priv->has_phy_interrupt) {
> +			phydev = mdiobus_get_phy(bus, priv->phy_id);
> +			if (!phydev) {
> +				dev_err(&dev->dev, "no PHY found\n");
> +				goto out_unregister_mdio;
> +			}
> +
>  			bus->irq[priv->phy_id] = priv->phy_interrupt;
> +			phydev->irq = priv->phy_interrupt;
> +		}
>  
> -		ret = mdiobus_register(bus);

You shouldn't have to set phydev->irq, this is done by phy_device_create().
For this to work bus->irq[] needs to be set before calling mdiobus_register().


>  		if (ret) {
>  			dev_err(&pdev->dev, "unable to register mdio bus\n");
>  			goto out_free_mdio;
> 

