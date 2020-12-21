Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CBD02E021A
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 22:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725899AbgLUVhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 16:37:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUVhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 16:37:48 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4ABC0613D3;
        Mon, 21 Dec 2020 13:37:07 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id i24so10994298edj.8;
        Mon, 21 Dec 2020 13:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=hQggwWPPkn+WMdoPfwbk6PXTqnMay86HYcER0pUuPDU=;
        b=mme2YD4QrmilHl3rH4PtxXh4y8Phq4UwwyTKfowp7vxflfYKXuGNAwaWvgzd3Wooso
         Ut9BfVdgSAefeuATpsq7l6HYtzEx1jKyNqaI+8dIUS0oT6B/zUHDXPQSNRDYdUW8Mk2L
         D2jgh26Sgy/fLFI9ZFJaLzcy4jEo12N9HmYnoAcmlEpO3MWd6mrsjMQWonMFOBpQq4kS
         kGiuoV8gxQ/toIvEl6axAMzOWQmgD+7wmukKWe75saFipTLNyDv48dP90OspIdeFaB14
         9/lURxLTxYuKHcPnJoFA5qHKl4etjpd4OonH4l0dP4BZFitewHAYN60CIyKX0QiuSEgV
         6S0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=hQggwWPPkn+WMdoPfwbk6PXTqnMay86HYcER0pUuPDU=;
        b=R//L0E587e5MfjWcYmMp6rqLm80QqyHDCPXWWwYSBTqbkNtqzacnJY2N/pEa/UZ7dA
         pWFDWY7Cv44l95zR0NAFNCTCPsBwH56W6a6XAhc+e2TjQKrDIwIrQtYUmGHRPG+DTYoE
         M9vpEyrEN+KiL99ejQI4wilmiGau+L6vnIJzsnwXUlaPOzuBoPWNCVdQ2F1CSORnkYBQ
         dCNoX/MHDKh2jMC7VKKtYYtebJoL3KOHC8tg6IwKqYZJkl2TsjVhjEYE1SaENoEaVz0A
         8evSSVx83IuqbWqbar38yCjj6j7Mmaz0otwS8wvkPZLBYmROvvORXEiMOw4YQwuHBpwE
         6+Cw==
X-Gm-Message-State: AOAM530v9/LZGKPoQkOHorKXAD1C6obXFmbGxXfN2BLtM2KfFZzjnJzp
        pYyxGHigXWhIpvBvnyhJmUgGYG89VLU=
X-Google-Smtp-Source: ABdhPJyxPsg4QZqk0I6q3W047zja/4kF/0lD+UExgg5XcSg+P4YpCkZo5ten+TN3uXrk85CGMihysQ==
X-Received: by 2002:a50:8b61:: with SMTP id l88mr17968781edl.250.1608586626276;
        Mon, 21 Dec 2020 13:37:06 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:cd72:cf28:16d9:79dc? (p200300ea8f065500cd72cf2816d979dc.dip0.t-ipconnect.de. [2003:ea:8f06:5500:cd72:cf28:16d9:79dc])
        by smtp.googlemail.com with ESMTPSA id a6sm29216403edv.74.2020.12.21.13.37.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Dec 2020 13:37:05 -0800 (PST)
Subject: Re: [Aspeed, v1 1/1] net: ftgmac100: Change the order of getting MAC
 address
To:     Hongwei Zhang <hongweiz@ami.com>, linux-aspeed@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
References: <20201221205157.31501-1-hongweiz@ami.com>
 <20201221205157.31501-2-hongweiz@ami.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <55803a8a-7ec9-5d60-04bd-d1e163174250@gmail.com>
Date:   Mon, 21 Dec 2020 22:36:59 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201221205157.31501-2-hongweiz@ami.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 21.12.2020 um 21:51 schrieb Hongwei Zhang:
> Change the order of reading MAC address, try to read it from MAC chip
> first, if it's not availabe, then try to read it from device tree.
> 
This commit message leaves a number of questions. It seems the change
isn't related at all to the change that it's supposed to fix.

- What is the issue that you're trying to fix?
- And what is wrong with the original change?

> Fixes: 35c54922dc97 ("ARM: dts: tacoma: Add reserved memory for ramoops")
> Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
> ---
>  drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/faraday/ftgmac100.c b/drivers/net/ethernet/faraday/ftgmac100.c
> index 65cd25372020..9be69cbdab96 100644
> --- a/drivers/net/ethernet/faraday/ftgmac100.c
> +++ b/drivers/net/ethernet/faraday/ftgmac100.c
> @@ -184,14 +184,7 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
>  	unsigned int l;
>  	void *addr;
>  
> -	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
> -	if (addr) {
> -		ether_addr_copy(priv->netdev->dev_addr, mac);
> -		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
> -			 mac);
> -		return;
> -	}
> -
> +	/* Read from Chip if not from chip */

?!?

>  	m = ioread32(priv->base + FTGMAC100_OFFSET_MAC_MADR);
>  	l = ioread32(priv->base + FTGMAC100_OFFSET_MAC_LADR);
>  
> @@ -205,7 +198,18 @@ static void ftgmac100_initial_mac(struct ftgmac100 *priv)
>  	if (is_valid_ether_addr(mac)) {
>  		ether_addr_copy(priv->netdev->dev_addr, mac);
>  		dev_info(priv->dev, "Read MAC address %pM from chip\n", mac);
> -	} else {
> +		return;
> +	}
> +
> +	/* Read from Chip if not from device tree */

Isn't this how it works now?

> +	addr = device_get_mac_address(priv->dev, mac, ETH_ALEN);
> +	if (addr) {
> +		ether_addr_copy(priv->netdev->dev_addr, mac);
> +		dev_info(priv->dev, "Read MAC address %pM from device tree\n",
> +				mac);
> +		return;
> +	}
> +	else {
>  		eth_hw_addr_random(priv->netdev);
>  		dev_info(priv->dev, "Generated random MAC address %pM\n",
>  			 priv->netdev->dev_addr);
> 

