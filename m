Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E95B25C50F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 17:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728454AbgICPVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 11:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgICPVq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 11:21:46 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FE93C061244;
        Thu,  3 Sep 2020 08:21:46 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id 2so1694221pjx.5;
        Thu, 03 Sep 2020 08:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gKlCn1zLPHMOHEFTF0w8cCWcR9YJBOeQ0/988P+XVAs=;
        b=pguJZyx1Fe8J33COxXS6yhOla23lvH4Poh6gpcfsWu/NOao4Xm1BIly0Q6hZnK5Y2S
         5Bp2RGeF9fq8cCeIwXkEDrstJGII1WbFZGdft4Hr4JQew30e1Yqs1RcFtMaF/ePelByh
         pJ8cZ3aXwKP3z5GXTRUVBS3ZUT1ViYvcNh+exyQod2fuJDGzyvPxkXeV04q6C7IOa0tC
         27AfE5J/OeAlCVk1jZ8Wf38cSjyi0FLzPTYmSgjeqa0A2KC7V2+GJfmhslL+/Bvjl2+f
         5G0bR+7zWf7ic7N+FyRFbZcpuJbchpkZupiyHu8cAJjFq7I5ZfCOMY1F+Db7H7KhIvFe
         Bacg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gKlCn1zLPHMOHEFTF0w8cCWcR9YJBOeQ0/988P+XVAs=;
        b=g1e15gtaO1h+DKYIm69DOJu2J0s4iO1REx7jkmodt3pTbO5UQq4disviqE+BmeRL2j
         mV8/o8HQSq9TRmgaAhCRbD7OG6ESfrVDBorFSio7l90yUC0rEMP+tX2AeG7lDAp677hr
         jXodWeCrYyjEIFL9DeBPhnaD7xUcIOQConWVqlQlw5id1XfZo7/MA6cYr7usEYtR2yXd
         ye4POHFoQr3OY9XT31P/pmCAkLSIai4R68mIcYKPfkT9awiYw+/CMvSkYshLS687FDvP
         e5ljSbuRUBsn9Eo7hf4K1hjkrFl4907hzOM7ANWYcJPtm3JfBjYFGKPbSix7ehppdqcN
         Grxw==
X-Gm-Message-State: AOAM532/eCbtWKAtM1i6YEDfdL6wZSpotSul2A30RILvCYwo5oYMSKta
        7npUSCkuPnKt83jM6Mvy8HXFDvODmHjYYA==
X-Google-Smtp-Source: ABdhPJzuEOPBzSkG5akflrDNr6nx2Z37h7j/UI07+87qFm/mMyytjpk3C9oyw+w99if0TgwI4ihjsw==
X-Received: by 2002:a17:90a:d597:: with SMTP id v23mr3604367pju.24.1599146505622;
        Thu, 03 Sep 2020 08:21:45 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a19sm3606635pfn.10.2020.09.03.08.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 08:21:44 -0700 (PDT)
Subject: Re: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
 <20200902213347.3177881-3-f.fainelli@gmail.com>
 <20200902222030.GJ3050651@lunn.ch>
 <7696bf30-9d7b-ecc9-041d-7d899dd07915@gmail.com>
 <77088212-ac93-9454-d3a0-c2eb61b5c3e0@arf.net.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <26a8a508-6108-035a-1416-01cff51a930a@gmail.com>
Date:   Thu, 3 Sep 2020 08:21:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <77088212-ac93-9454-d3a0-c2eb61b5c3e0@arf.net.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 11:00 PM, Adam Rudziński wrote:
> 
> W dniu 2020-09-03 o 04:13, Florian Fainelli pisze:
>>
>>
>> On 9/2/2020 3:20 PM, Andrew Lunn wrote:
>>>> +    priv->clk = devm_clk_get_optional(&phydev->mdio.dev, "sw_gphy");
>>>> +    if (IS_ERR(priv->clk))
>>>> +        return PTR_ERR(priv->clk);
>>>> +
>>>> +    /* To get there, the mdiobus registration logic already enabled 
>>>> our
>>>> +     * clock otherwise we would not have probed this device since 
>>>> we would
>>>> +     * not be able to read its ID. To avoid artificially bumping up 
>>>> the
>>>> +     * clock reference count, only do the clock enable from a 
>>>> phy_remove ->
>>>> +     * phy_probe path (driver unbind, then rebind).
>>>> +     */
>>>> +    if (!__clk_is_enabled(priv->clk))
>>>> +        ret = clk_prepare_enable(priv->clk);
>>>
>>> This i don't get. The clock subsystem does reference counting. So what
>>> i would expect to happen is that during scanning of the bus, phylib
>>> enables the clock and keeps it enabled until after probe. To keep
>>> things balanced, phylib would disable the clock after probe.
>>
>> That would be fine, although it assumes that the individual PHY 
>> drivers have obtained the clocks and called clk_prepare_enable(), 
>> which is a fair assumption I suppose.
>>
>>>
>>> If the driver wants the clock enabled all the time, it can enable it
>>> in the probe method. The common clock framework will then have two
>>> reference counts for the clock, so that when the probe exists, and
>>> phylib disables the clock, the CCF keeps the clock ticking. The PHY
>>> driver can then disable the clock in .remove.
>>
>> But then the lowest count you will have is 1, which will lead to the 
>> clock being left on despite having unbound the PHY driver from the 
>> device (->remove was called). This does not allow saving any power 
>> unfortunately.
>>
>>>
>>> There are some PHYs which will enumerate with the clock disabled. They
>>> only need it ticking for packet transfer. Such PHY drivers can enable
>>> the clock only when needed in order to save some power when the
>>> interface is administratively down.
>>
>> Then the best approach would be for the OF scanning code to enable all 
>> clocks reference by the Ethernet PHY node (like it does in the 
>> proposed patch), since there is no knowledge of which clock is 
>> necessary and all must be assumed to be critical for MDIO bus 
>> scanning. Right before drv->probe() we drop all resources reference 
>> counts, and from there on ->probe() is assumed to manage the necessary 
>> clocks.
>>
>> It looks like another solution may be to use the assigned-clocks 
>> property which will take care of assigning clock references to devices 
>> and having those applied as soon as the clock provider is available.
> 
> Hi Guys,
> 
> I've just realized that a PHY may also have a reset signal connected. 
> The reset signal may be controlled by the dedicated peripheral or by GPIO.

There is already support for such a thing within 
drivers/net/phy/mdio_bus.c though it assumes we could bind the PHY 
device to its driver already.

> 
> In general terms, there might be a set of control signals needed to 
> enable the PHY. It seems that the clock and the reset would be the 
> typical useful options.
> 
> Going further with my imagination of how evil the hardware design could 
> be, in general the signals for the PHY may have some relations to other 
> control signals.
> 
> I think that from the software point of view this comes down to 
> assumption that the PHY is to be controlled "driver only knows how".

That is all well and good as long as we can actually bind the PHY device 
which its driver, and right now this means that we either have:

- a compatible string in Device Tree which is of the form 
ethernet-phy-id%4x.%4x (see of_get_phy_id) which means that we *know* 
already which PHY we have and we avoid doing reads of MII_PHYSID1 and 
MII_PHYSID2. This is a Linux implementation detail that should not have 
to be known to systems designer IMHO

- a successful read of MII_PHYSID1 and MII_PHYSID2 (or an equivalent for 
the clause 45 PHYs) that allows us to know what PHY device we have, 
which is something that needs to happen eventually.

The problem is when there are essential resources such as clocks, 
regulators, reset signals that must be enabled, respectively de-asserted 
in order for a successful MDIO read of MII_PHYSID1 and MII_PHYSID2 to 
succeed.

There is no driver involvement at that stage because we have no 
phy_device to bind it to *yet*. Depending on what we read from 
MII_PHYSID1/PHY_ID2 we will either successfully bind to the Generic PHY 
driver (assuming we did not read all Fs) or not and we will return 
-ENODEV and then it is game over.

This is the chicken and egg problem that this patch series is 
addressing, for clocks, because we can retrieve clock devices with just 
a device_node reference.

It is absolutely reasonable to design systems whereby the boot loader is 
not initializing or using the Ethernet PHY devices, or if it did, put 
them back into reset/low power state after use and before transitioning 
to the OS. This is not only a clean transition, it may also be the only 
way to meet a certain power target as you cannot know or assume that the 
OS will also make use of these resources. This is even more true if 
there is dynamic power negotiation (MHL or USB Type-C for instance).
-- 
Florian
