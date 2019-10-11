Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23A25D4AE4
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:22:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727541AbfJKXWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:22:35 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45257 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfJKXWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:22:34 -0400
Received: by mail-pf1-f195.google.com with SMTP id y72so6920669pfb.12
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=T5gcsIEKN7fGZ7H7m6feYOoRGQFlbeIl7NkVUQv4he4=;
        b=Ksu7qQFHWBMhWinL77/TQbc+vSKoTq2TIhAH2e2tUs3ppJnmql4AfILW2RwbAubDOl
         chO4usBGOBBH8HDljDNj7ouDLAsMHLaYcN5/ags2Q9i6Is4L5wltQxZNW2yKsGj9HTDB
         EesFgnTZP8oj1M1CPdB/6+vfgQ8jka2FPcm6A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=T5gcsIEKN7fGZ7H7m6feYOoRGQFlbeIl7NkVUQv4he4=;
        b=ZLhh2qw0xI0iPlxJRNIKIGA6PMS07XqpFQ4j5KsAXwwy+qkdo6YO92IEAIWTPXUOAu
         0d+9O/uo6edtlpHHEDxIskDPArWgM2hcZski6sRr2l56M4/gQND3yiGut2TdZCGoHqRz
         p7VpQxLtQ40FRf1Sp9XfIpDNMk25AauS/okmyi3r1SyfYpQjDJGSI4ccRcrNrTNPeTaV
         J/Lx3Z/8ljTflgY6RkMFzVZmUTzskTGuW/9VC5Plhgs92s5VPhwjvC4fvUVJVu1+0u14
         5U2mjY0exjJ0G24jcrCyE6yhKLYKN54D3kPcI5eHzmebyLj7b42jq2xuvR87y1vOHW/m
         LTbg==
X-Gm-Message-State: APjAAAXyuOO7JZCR5rLrOwTU08KKdSQSUf1daHLl3xZ4uuoB+5GUx77E
        fZVRssvaDFVP7z1FRY29Uw4ECg==
X-Google-Smtp-Source: APXvYqxnc8uPXC8zde1FT2hLIcxRHARAplN03/RYBfrBgB8o6kDGDYjUcmJ2HdlhufOjzl4dUByUWw==
X-Received: by 2002:a62:ac02:: with SMTP id v2mr18619372pfe.97.1570836151751;
        Fri, 11 Oct 2019 16:22:31 -0700 (PDT)
Received: from [10.136.13.65] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id z13sm12486111pfq.121.2019.10.11.16.22.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 11 Oct 2019 16:22:31 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bcmgenet: Generate a random MAC if none is
 valid
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191011231915.9347-1-f.fainelli@gmail.com>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <7fe7796f-c98e-3c7c-3683-505a0e643eda@broadcom.com>
Date:   Fri, 11 Oct 2019 16:22:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191011231915.9347-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2019-10-11 4:19 p.m., Florian Fainelli wrote:
> Instead of having a hard failure and stopping the driver's probe
> routine, generate a random Ethernet MAC address to keep going.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c | 15 ++++++---------
>   1 file changed, 6 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 12cb77ef1081..5c20829ffa0f 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -3461,16 +3461,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   		goto err;
>   	}
>   
> -	if (dn) {
> +	if (dn)
>   		macaddr = of_get_mac_address(dn);
> -		if (IS_ERR(macaddr)) {
> -			dev_err(&pdev->dev, "can't find MAC address\n");
We shouldn't hide the error that the MAC address wasn't found.
We should continue to print some kind of error as generating a mac address
is a stop-gap measure and a proper MAC address should be used
for the board.
> -			err = -EINVAL;
> -			goto err;
> -		}
> -	} else {
> +	else
>   		macaddr = pd->mac_address;
> -	}
>   
>   	priv->base = devm_platform_ioremap_resource(pdev, 0);
>   	if (IS_ERR(priv->base)) {
> @@ -3482,7 +3476,10 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   
>   	SET_NETDEV_DEV(dev, &pdev->dev);
>   	dev_set_drvdata(&pdev->dev, dev);
> -	ether_addr_copy(dev->dev_addr, macaddr);
> +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr))
> +		eth_hw_addr_random(dev);
> +	else
> +		ether_addr_copy(dev->dev_addr, macaddr);
>   	dev->watchdog_timeo = 2 * HZ;
>   	dev->ethtool_ops = &bcmgenet_ethtool_ops;
>   	dev->netdev_ops = &bcmgenet_netdev_ops;

