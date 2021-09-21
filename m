Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F27F413A24
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 20:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhIUSmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 14:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhIUSmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Sep 2021 14:42:02 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189C9C061574;
        Tue, 21 Sep 2021 11:40:34 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id g184so21569531pgc.6;
        Tue, 21 Sep 2021 11:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GCp9xMHVQ+O3KUUdN8kb66CJEPEYUuxTq59fEn3D1Xw=;
        b=VtVgExXM18UyUnWVeN7shm+MbOosykIOq8AKWKZer9DFjD3EM4HcDY08YXMvL46qti
         0J8xGCCK4OE1xJio9ponM6+PVnzVbyvXIXacLLJ4fDsa5BbEGdgKz8ruyQt9Na58zGSH
         Oemx4S0r8zUbIE/4qxo5e42Hvsc6aWBQQpTvENeYTXqhJ4QMaW6iklcLhgzzfK9GoF4Z
         Limnu++JlCy1ZeXamXxjhUyWA3Hyj7ADJf1j3YataNMQABrHPE88blvB88hK1TiCkkP3
         DNytgFkwJE90wDdk7CDoWeQX1zzCKHsjBSCaKZYNScv+2GVJ1F5pUw+iDb5GbLP6KTmj
         syjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GCp9xMHVQ+O3KUUdN8kb66CJEPEYUuxTq59fEn3D1Xw=;
        b=Yv1FuB4itVaupdY75jpWqNsTpOT7XYBa/NSUzn1dqfNmCd7rqyubyduKzzalf2TVZz
         yb5naqw/bMg3GzXePcC7QKT7rBqTOWYqiVqEGmzlwA3irYY61ZS1jtAAZyYLRVEeiDc/
         OP2uR9fs7k6n3n4oiXi7CAzkdLvLfbfH4rBkut0CaOQgwLhwwyWBmqgQGG5TlE6XuyfH
         FAKJ7m2aUQ1CxIzjd+og9cFaAM97I/FoE41bpWmef891Z84F2clfmhRy+y6hL2r1/+Yn
         MR3payP96//j2xha35F6fBVDLmXEbJ5mchqXP3QBGmAnzMLrqxF0dxTLdyCCV/+X0TOI
         Ozyg==
X-Gm-Message-State: AOAM532Dk0IdpmyWICdcaRrNepnYEIR6HbBhkq6Y36n6cgLLT8WuVAtz
        MdRlUljge7ckGHDTzREEivw=
X-Google-Smtp-Source: ABdhPJxH4DP+xJCpm5R0nOX3nc3kHOlfM3SnhUYB7ihjVvK4v/gg+I5iAvFjmjADsCJFXZuLKWkT8Q==
X-Received: by 2002:a63:5663:: with SMTP id g35mr29371439pgm.368.1632249633523;
        Tue, 21 Sep 2021 11:40:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y126sm18173990pfy.88.2021.09.21.11.40.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 11:40:32 -0700 (PDT)
Subject: Re: [PATCH RFC] net: bgmac: improve handling PHY
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210921120215.27924-1-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5aeb4d43-14d2-da4c-6004-e9c2f4849d0d@gmail.com>
Date:   Tue, 21 Sep 2021 11:40:30 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210921120215.27924-1-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/21/21 5:02 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> 1. Use info from DT if available
> 
> It allows describing for example a fixed link. It's more accurate than
> just guessing there may be one (depending on a chipset).
> 
> 2. Verify PHY ID before trying to connect PHY
> 
> PHY addr 0x1e (30) is special in Broadcom routers and means a switch
> connected as MDIO devices instead of a real PHY. Don't try connecting to
> it.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Yes this does appear to be a better strategy, you would want to put that
in the same patch set that adds support for the "mdio" node container to
avoid regressions, thanks!

> ---
>  drivers/net/ethernet/broadcom/bgmac-bcma.c | 33 ++++++++++++++--------
>  1 file changed, 21 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
> index 85fa0ab7201c..e39361042aa1 100644
> --- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
> +++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
> @@ -11,6 +11,7 @@
>  #include <linux/bcma/bcma.h>
>  #include <linux/brcmphy.h>
>  #include <linux/etherdevice.h>
> +#include <linux/of_mdio.h>
>  #include <linux/of_net.h>
>  #include "bgmac.h"
>  
> @@ -86,17 +87,28 @@ static int bcma_phy_connect(struct bgmac *bgmac)
>  	struct phy_device *phy_dev;
>  	char bus_id[MII_BUS_ID_SIZE + 3];
>  
> +	/* DT info should be the most accurate */
> +	phy_dev = of_phy_get_and_connect(bgmac->net_dev, bgmac->dev->of_node,
> +					 bgmac_adjust_link);
> +	if (phy_dev)
> +		return 0;
> +
>  	/* Connect to the PHY */
> -	snprintf(bus_id, sizeof(bus_id), PHY_ID_FMT, bgmac->mii_bus->id,
> -		 bgmac->phyaddr);
> -	phy_dev = phy_connect(bgmac->net_dev, bus_id, bgmac_adjust_link,
> -			      PHY_INTERFACE_MODE_MII);
> -	if (IS_ERR(phy_dev)) {
> -		dev_err(bgmac->dev, "PHY connection failed\n");
> -		return PTR_ERR(phy_dev);
> +	if (bgmac->mii_bus && bgmac->phyaddr != BGMAC_PHY_NOREGS) {
> +		snprintf(bus_id, sizeof(bus_id), PHY_ID_FMT, bgmac->mii_bus->id,
> +			 bgmac->phyaddr);
> +		phy_dev = phy_connect(bgmac->net_dev, bus_id, bgmac_adjust_link,
> +				      PHY_INTERFACE_MODE_MII);
> +		if (IS_ERR(phy_dev)) {
> +			dev_err(bgmac->dev, "PHY connection failed\n");
> +			return PTR_ERR(phy_dev);
> +		}
> +
> +		return 0;
>  	}
>  
> -	return 0;
> +	/* Assume a fixed link to the switch port */
> +	return bgmac_phy_connect_direct(bgmac);
>  }
>  
>  static const struct bcma_device_id bgmac_bcma_tbl[] = {
> @@ -295,10 +307,7 @@ static int bgmac_probe(struct bcma_device *core)
>  	bgmac->cco_ctl_maskset = bcma_bgmac_cco_ctl_maskset;
>  	bgmac->get_bus_clock = bcma_bgmac_get_bus_clock;
>  	bgmac->cmn_maskset32 = bcma_bgmac_cmn_maskset32;
> -	if (bgmac->mii_bus)
> -		bgmac->phy_connect = bcma_phy_connect;
> -	else
> -		bgmac->phy_connect = bgmac_phy_connect_direct;
> +	bgmac->phy_connect = bcma_phy_connect;
>  
>  	err = bgmac_enet_probe(bgmac);
>  	if (err)
> 


-- 
Florian
