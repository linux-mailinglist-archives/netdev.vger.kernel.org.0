Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C528D83B8
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389931AbfJOWck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:32:40 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46461 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732040AbfJOWcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:32:39 -0400
Received: by mail-pl1-f193.google.com with SMTP id q24so10246473plr.13
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ZPGOSSx5giEEfL2NPx2gvww++Bfy7bq2OL0BsYfuuHg=;
        b=HJg0uZssgcrUSgxu4Yt6cBbovBjr3Wy8sfTsLZaJ5il4NS8LlLl+YXlQufsmAOhrUe
         EjPI+S9rdd9S0a0yFhE80R21vVioW+hNay9WseUk7tEudntZ+ZVUQW/eEvwAdWlj7R0J
         eL6TvUgJ4Wbp8ruzE7ttH23JwlHVYaonygjyk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ZPGOSSx5giEEfL2NPx2gvww++Bfy7bq2OL0BsYfuuHg=;
        b=CK0NzI+Fr+w7ZOQf9eVWBaJoCemIJ5+PTqpNw7S2zR3IpkCNCpgCXOGtOEWcvACz0x
         ZSn9N1bJeCet1YxFZNbT/JHNYVe0fxDwNQkFHG5U7Zx8/gjIfzB6ZDxaRPeCwl/j6OVm
         z1YM5JYQ9bzkjPmyFCmCGHSUuYlDb0DXEcRaHjqfCreiA42/KX/NzZ9FxcLeEfMvnXw9
         BBLZlYplB1Y6JzxED4blucuw1xY2ajhciLUxd8ifMvlWKfsvD8m2+GknnXmiJDaAvzmd
         qT+b/wS55/FFpkdYnDnh9UeBaD2h/tV+ByAAg4Brha97NGE2PXOX+HYQmq5xg8uapsKt
         uI3Q==
X-Gm-Message-State: APjAAAXgfesvyiDPPQIBeGzcW8i5l/xmdZjRCY40mtEsG9iIO+Sai0id
        lx+Wuppr+atIXrQEkiJgOmZ3dA==
X-Google-Smtp-Source: APXvYqynowQLJijtXfqi2elhpB72G1vEHERM1q9vmxBCIR/fDTcnRQIGAZzcOq4IwAR76Jx3qQgNgQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr26662481plf.239.1571178756804;
        Tue, 15 Oct 2019 15:32:36 -0700 (PDT)
Received: from [10.136.13.65] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l62sm24419257pfl.167.2019.10.15.15.32.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Oct 2019 15:32:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: bcmgenet: Generate a random MAC if none
 is valid
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Cc:     phil@raspberrypi.org, jonathan@raspberrypi.org,
        matthias.bgg@kernel.org, linux-rpi-kernel@lists.infradead.org,
        wahrenst@gmx.net, nsaenzjulienne@suse.de,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:BROADCOM GENET ETHERNET DRIVER" 
        <bcm-kernel-feedback-list@broadcom.com>,
        open list <linux-kernel@vger.kernel.org>
References: <20191014212000.27712-1-f.fainelli@gmail.com>
From:   Scott Branden <scott.branden@broadcom.com>
Message-ID: <dda8587a-0734-d294-5b50-0f5f35c27918@broadcom.com>
Date:   Tue, 15 Oct 2019 15:32:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191014212000.27712-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On 2019-10-14 2:20 p.m., Florian Fainelli wrote:
> Instead of having a hard failure and stopping the driver's probe
> routine, generate a random Ethernet MAC address to keep going.
>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
> Changes in v2:
>
> - provide a message that a random MAC is used, the same message that
>    bcmsysport.c uses
>
>   drivers/net/ethernet/broadcom/genet/bcmgenet.c | 17 ++++++++---------
>   1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 12cb77ef1081..dd4e4f1dd384 100644
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
> @@ -3482,7 +3476,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
>   
>   	SET_NETDEV_DEV(dev, &pdev->dev);
>   	dev_set_drvdata(&pdev->dev, dev);
> -	ether_addr_copy(dev->dev_addr, macaddr);
> +	if (IS_ERR_OR_NULL(macaddr) || !is_valid_ether_addr(macaddr)) {
> +		dev_warn(&pdev->dev, "using random Ethernet MAC\n");
I would still consider this warrants a dev_err as you should not be 
using the device with a random MAC address assigned to it.  But I'll 
leave it to the "experts" to decide on the print level here.
> +		eth_hw_addr_random(dev);
> +	} else {
> +		ether_addr_copy(dev->dev_addr, macaddr);
> +	}
>   	dev->watchdog_timeo = 2 * HZ;
>   	dev->ethtool_ops = &bcmgenet_ethtool_ops;
>   	dev->netdev_ops = &bcmgenet_netdev_ops;

