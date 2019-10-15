Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2141D6CA4
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 02:52:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbfJOAwr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 20:52:47 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40443 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbfJOAwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 20:52:47 -0400
Received: by mail-pg1-f195.google.com with SMTP id e13so2827383pga.7;
        Mon, 14 Oct 2019 17:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W6Z+FAutC5s64cQmjM/Y9qv/zVoMxmkp3VC30cn4uPM=;
        b=SSShTxsEoFJWwrnSxY8UQ08T7WZxn61LMDV6uiW/tXp2f8wvkckUdR/tNahjr0rw4u
         Z9Ab46iN9GP6IH+CiFZQb8hXKSNfOF9s/PXtrl/MQ8gi+42Rw5EcAIWMdDPrTZZThyEs
         QUvdNBbgO/O55/6aljFh76M31MuuCaa8nxHdzT1lJNSbEgGqtMA0XoNmQ5Z3erqXoi/O
         H/InpkdEu+rR28OQjRYWLlHY60XoWxy+OsYUZjF/h6FR2qVp8/1jLLfDWSz81HF7aciy
         YRy9EqoAP2AJJTylNIFJSbNuOXTff+cvYFCTOGR0HCSbbmZqwzkAsqojw5MDO1OcxGmP
         L+UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=W6Z+FAutC5s64cQmjM/Y9qv/zVoMxmkp3VC30cn4uPM=;
        b=d1fcNb9/KQzAmE6TTbVLT/E7pTqD1fabgX3vBZ5DVECKpw7az4AoDxstgC7+o0TuAR
         HsFGl05hITPHGTs973s1QTeihoojomQp6wmcnasmnKS5GcWi1zTpxepSIi6G55v/4FLt
         NFbWcNPtaB9AKU8IUQ9v+KMsPSPtuTR2UPV2Z8gmQ2ICxCDjJzbRO9DUSn3Q87LX918E
         JdprWzdQNelUP6+sPUs95BQz5in0Rp/otXGMlQ/yQ9r1xbAQGlR/FbN8K08Miqo1gLk3
         adT7+NA2yxBjMlRrWpALi5ja3FGz4wVsGnsuJmBLmbx1ke5R2Ew9iQhC5BGvQfxJ6Yxe
         pDHQ==
X-Gm-Message-State: APjAAAV9MBiLUHHAOKcGO0CeROc0760DMQML2ERaRbneNckiXJ7yH1JA
        uKhvcLinECuj4WT6YGwRdLcIJS+Z
X-Google-Smtp-Source: APXvYqxbaULdFb/xaZEgeY5p/IJ/+4D6iwSCAuH4hq8VmpKlGPbsQxSYQ4A5DQ/QzKTYzljimPkkrQ==
X-Received: by 2002:a62:5c07:: with SMTP id q7mr35046439pfb.159.1571100764598;
        Mon, 14 Oct 2019 17:52:44 -0700 (PDT)
Received: from [10.67.51.137] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a13sm28960237pfg.10.2019.10.14.17.52.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Oct 2019 17:52:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if none
 is valid
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191014212000.27712-1-f.fainelli@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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 YVs=
Message-ID: <b1feb8b5-c52a-e50e-fb4d-8e4c0316b79d@gmail.com>
Date:   Mon, 14 Oct 2019 17:52:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191014212000.27712-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/14/19 2:20 PM, Florian Fainelli wrote:
> Instead of having a hard failure and stopping the driver's probe
> routine, generate a random Ethernet MAC address to keep going.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
> 
> - provide a message that a random MAC is used, the same message that
>   bcmsysport.c uses
> 
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 12cb77ef1081..dd4e4f1dd384 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3461,16 +3461,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  		goto err;
>  	}
>  
> -	if (dn) {
> +	if (dn)
>  		macaddr = of_get_mac_address(dn);
> -		if (IS_ERR(macaddr)) {
> -			dev_err(&pdev->dev, "can't find MAC address\n");
> -			err = -EINVAL;
> -			goto err;
> -		}
> -	} else {
> +	else
>  		macaddr = pd->mac_address;
> -	}
>  
>  	priv->base = devm_platform_ioremap_resource(pdev, 0);
>  	if (IS_ERR(priv->base)) {
> @@ -3482,7 +3476,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  	dev_set_drvdata(&pdev->dev, dev);
> -	ether_addr_copy(dev->dev_addr, macaddr);
> +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
> +		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
> +		eth_hw_addr_random(dev);
> +	} else {
> +		ether_addr_copy(dev->dev_addr, macaddr);
> +	}
>  	dev->watchdog_timeo = 2 * HZ;
>  	dev->ethtool_ops = &bcmgenet_ethtool_ops;
>  	dev->netdev_ops = &bcmgenet_netdev_ops;
> 
Acked-by: Doug Berger <opendmb@gmail.com>
