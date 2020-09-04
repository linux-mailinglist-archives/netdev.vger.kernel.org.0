Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0A925DDE5
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 17:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgIDPhk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 11:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbgIDPhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 11:37:40 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED35C061244;
        Fri,  4 Sep 2020 08:37:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b124so4781552pfg.13;
        Fri, 04 Sep 2020 08:37:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vd6OOKG0PfWJEUpTEF2TMExH9RlBGmQuVQFRBrWjino=;
        b=cgKvsflvWTCMfOLrHfz71Re/gJ3TZ283cVzrJpsTKeejXn2IF7mPUxJ5BrdeY9sf7l
         XbPrODnD0SWVfUQ4exIlAegHCTq7qyfxXt5EfXjaIB4pXrZmjc/tCJl/ZYMdLl4fDVMQ
         G1fK3FEsMK00DPrwdhvp9fzKUETGt9Qwyunc13u7+IXbnysYu2Eutq4msi7gaWLlReLl
         tzDgsAQcz8xlo8276fWzPZOS2h0pQ7skf8LShYtQTfgnKXGyszx9+8B9XIerI98z0pc9
         dYuNdjJWjG3bKRKCcQaaB1IZQgyczoo81LS8ZyoW80y+0b/ctu/eFqVyYXAcm75bJ+uL
         gB/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vd6OOKG0PfWJEUpTEF2TMExH9RlBGmQuVQFRBrWjino=;
        b=QgWzj3eteIe1YC3McyF9Ps3syCOY8S1IMpddsKJtznWZq5/DZvM3oD/YMmztT1AU56
         gwz9d1bJlv4Y3iMktE8VY/DWV7Sdgdm5zq7kVE5SFudRp5hv71nEmm1V7pDoUYldWFyy
         xoSL2hqFaUW3iVJlXSPIgYRaR9PjCyW9flEV5IImOIsAx6+i+uzDRzESlpSOpWdNggZg
         OkMD3QOiQRGYs+5Jx/VxJgPF8YsgLYC6rvWTzzUlDZiBIbX2QTt0Otkr7dUYOYbcOkgJ
         jNtO1zRuPiZYTZH23AaGX0USbaoHkjKh2bf4Q1pMwfQ55KMgd/ajaMyM+4fGsFaWlSNA
         hGGA==
X-Gm-Message-State: AOAM530btxkKbgxYQ+BPa3tbGUj+Uf6NrsUjyWurM4aRjrA1LPNleEv0
        ybJF4fjfUdioMX8pd+rJ7ic=
X-Google-Smtp-Source: ABdhPJzGU3JS+O5pTGXzLexEvVxWwmTZS0r6jPAg0L0OZdIP1PjCPK2sUmZcGxujbB21TU/l7h9g3A==
X-Received: by 2002:a63:fb4a:: with SMTP id w10mr7518439pgj.114.1599233859325;
        Fri, 04 Sep 2020 08:37:39 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q127sm6939370pfb.61.2020.09.04.08.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2020 08:37:38 -0700 (PDT)
Subject: Re: [PATCH net-next 3/3] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Marco Felsch <m.felsch@pengutronix.de>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, adam.rudzinski@arf.net.pl,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
 <20200903043947.3272453-4-f.fainelli@gmail.com>
 <20200904061558.s2s33nfof6itt24y@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ccfa67f5-d3dd-26a6-1bb8-9772e2434d82@gmail.com>
Date:   Fri, 4 Sep 2020 08:37:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200904061558.s2s33nfof6itt24y@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 11:15 PM, Marco Felsch wrote:
> Hi Florian,
> 
> On 20-09-02 21:39, Florian Fainelli wrote:
>> The internal Gigabit PHY on Broadcom STB chips has a digital clock which
>> drives its MDIO interface among other things, the driver now requests
>> and manage that clock during .probe() and .remove() accordingly.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>   drivers/net/phy/bcm7xxx.c | 18 +++++++++++++++++-
>>   1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
>> index 692048d86ab1..f0ffcdcaef03 100644
>> --- a/drivers/net/phy/bcm7xxx.c
>> +++ b/drivers/net/phy/bcm7xxx.c
>> @@ -11,6 +11,7 @@
>>   #include "bcm-phy-lib.h"
>>   #include <linux/bitops.h>
>>   #include <linux/brcmphy.h>
>> +#include <linux/clk.h>
>>   #include <linux/mdio.h>
>>   
>>   /* Broadcom BCM7xxx internal PHY registers */
>> @@ -39,6 +40,7 @@
>>   
>>   struct bcm7xxx_phy_priv {
>>   	u64	*stats;
>> +	struct clk *clk;
>>   };
>>   
>>   static int bcm7xxx_28nm_d0_afe_config_init(struct phy_device *phydev)
>> @@ -534,7 +536,19 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
>>   	if (!priv->stats)
>>   		return -ENOMEM;
>>   
>> -	return 0;
>> +	priv->clk = devm_clk_get_optional(&phydev->mdio.dev, NULL);
> 
> Since the clock is binded to the mdio-dev here..
> 
>> +	if (IS_ERR(priv->clk))
>> +		return PTR_ERR(priv->clk);
>> +
>> +	return clk_prepare_enable(priv->clk);
> 
> clould we use devm_add_action_or_reset() here so we don't have to
> register the .remove() hook?

Maybe, more on that below.

> 
>> +}
>> +
>> +static void bcm7xxx_28nm_remove(struct phy_device *phydev)
>> +{
>> +	struct bcm7xxx_phy_priv *priv = phydev->priv;
>> +
>> +	clk_disable_unprepare(priv->clk);
>> +	devm_clk_put(&phydev->mdio.dev, priv->clk);
> 
> Is this really necessary? The devm_clk_get_optional() function already
> registers the devm_clk_release() hook.

Yes, because you can unbind the PHY driver from sysfs, and if you want 
to bind that driver again, which will call .probe() again, you must undo 
strictly everything that .probe() did. The embedded mdio_device does not 
go away, so there will be no automatic freeing of resources. Using 
devm_* may be confusing, so using just the plain clk_get() and clk_put() 
may be clearer here.
-- 
Florian
