Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4BF3217430
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 18:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgGGQjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 12:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726911AbgGGQjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 12:39:08 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B40EC061755;
        Tue,  7 Jul 2020 09:39:08 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id s10so45849954wrw.12;
        Tue, 07 Jul 2020 09:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8WhRhUV0bxW5fKNsJJERRh/gn666x8wPbqXyJwg1M+Y=;
        b=sVZwKe/yxmasMSn4W9LUauyzUsiKPNLiGPnRRvctW3J4at7s1qFoLq5WH7KiVEiO1X
         eouoRbRhe6QRuz536A/mpikK0L7fNdq8QqQECAqiPu46t6KgKf5pxUJmcxN3sgMxaQwc
         PBbG7gpL7O4WqebsWv8NW8f5+Gpcp0pR+Ffyk+Et4tsFS/qq/td4iTX9pCqx0ikxU3TK
         Hfvp5mXJSGOiGU+wCIWx9q0ZUFdcGT55PzX3F7/xZsuucBAvq0fUYMhgEf1YGjRF/K8G
         QtJH1c439l1PZcvOs7bjaHR+8oJhN5niFQWIC9OWZVeccrDKTcc+Kmdng2IUmhBGoZxt
         KGhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8WhRhUV0bxW5fKNsJJERRh/gn666x8wPbqXyJwg1M+Y=;
        b=T7ZQjVSwFeYw0bnkcuazcL4F9YEuCAbrs4O0T28c8RMw6s+BePZ2ZOxcudww40mIVZ
         4LtAWWcmiNhGqq5LWA90cvu0Ayd+UiksomOHd6bpbk3ymWjfcW1NvwNfGUt3fRiO3H1m
         XKC3yohilc7RTiz8FN5VkpWpNgC8oa1Fu3LtinCzQM0efL7/Q07ODmpzux/L7lIzSsOk
         3o/0Ph5Qgv2ka/j2FIUEQ6Hv2NUIknto5j2agTa4thFTmGQ1q1SJxjvvStTFFqWvLNSd
         ymRpi1EMSDFo4nXbcBeMNZC6cSawo/qT2OGMqzBr3xMZzlPdomS8tkw3HayWmJ9t+p53
         C4vg==
X-Gm-Message-State: AOAM532N7dYe3QbjKmIIqt1f5GMwIShQdC0GNfLIN+GqAqcTI7dlorsf
        8en10y6dkKeUxGdsGQdjcpWBO9MF
X-Google-Smtp-Source: ABdhPJxMK9hsl7HRkUBbUzfQV5ktnTNS1wWDpoX3tEAxYfgNSC9TtC5vLKTfcaJTGiL0O+sKDNR1kQ==
X-Received: by 2002:adf:ed02:: with SMTP id a2mr53877459wro.110.1594139946830;
        Tue, 07 Jul 2020 09:39:06 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n16sm1674785wrq.39.2020.07.07.09.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 09:39:06 -0700 (PDT)
Subject: Re: PHY reset handling during DT parsing
To:     Maxime Ripard <maxime@cerno.tech>, Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Antoine_T=c3=a9nart?= <antoine.tenart@bootlin.com>
References: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
 <20200707141918.GA928075@lunn.ch>
 <20200707145440.teimwt6kmsnyi5dz@gilmour.lan>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <82482500-d329-71d4-619a-7cb2eddaf9ad@gmail.com>
Date:   Tue, 7 Jul 2020 09:39:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200707145440.teimwt6kmsnyi5dz@gilmour.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 7:54 AM, Maxime Ripard wrote:
> Hi Andrew,
> 
> On Tue, Jul 07, 2020 at 04:19:18PM +0200, Andrew Lunn wrote:
>> On Mon, Jul 06, 2020 at 08:13:31PM +0200, Maxime Ripard wrote:
>>> I came across an issue today on an Allwinner board, but I believe it's a
>>> core issue.
>>>
>>> That board is using the stmac driver together with a phy that happens to
>>> have a reset GPIO, except that that GPIO will never be claimed, and the
>>> PHY will thus never work.
>>>
>>> You can find an example of such a board here:
>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195
>>>
>>> It looks like when of_mdiobus_register() will parse the DT, it will then
>>> call of_mdiobus_register_phy() for each PHY it encounters [1].
>>> of_mdiobus_register_phy() will then if the phy doesn't have an
>>> ethernet-phy-id* compatible call get_phy_device() [2], and will later on
>>> call phy_register_device [3].
>>>
>>> get_phy_device() will then call get_phy_id() [4], that will try to
>>> access the PHY through the MDIO bus [5].
>>>
>>> The code that deals with the PHY reset line / GPIO is however only done
>>> in mdiobus_device_register, called through phy_device_register. Since
>>> this is happening way after the call to get_phy_device, our PHY might
>>> still very well be in reset if the bootloader hasn't put it out of reset
>>> and left it there.
>>
>> Hi Maxime
>>
>> If you look at the history of this code,
>>
>> commit bafbdd527d569c8200521f2f7579f65a044271be
>> Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>> Date:   Mon Dec 4 13:35:05 2017 +0100
>>
>>     phylib: Add device reset GPIO support
>>
>> you will see there is an assumption the PHY can be detected while in
>> reset. The reset was originally handled inside the at803x PHY driver
>> probe function, before it got moved into the core.
>>
>> What you are asking for it reasonable, but you have some history to
>> deal with, changing some assumptions as to what the reset is all
>> about.
> 
> Thanks for the pointer.
> 
> It looks to me from the commit log that the assumption was that a
> bootloader could leave the PHY into reset though?
> 
> It starts with:
> 
>> The PHY devices sometimes do have their reset signal (maybe even power
>> supply?) tied to some GPIO and sometimes it also does happen that a
>> boot loader does not leave it deasserted.
> 
> This is exactly the case I was discussing. The bootloader hasn't used
> the PHY, and thus the PHY reset signal is still asserted?

The current solution to this problem would be to have a reset property
specified for the MDIO bus controller node such that the reset would be
de-asserted during mdiobus_register() and prior to scanning the MDIO bus.

This has the nice property that for a 1:1 mapping between MDIO bus
controller and device, it works (albeit maybe not being accurately
describing hardware), but if you have multiple MDIO/PHY devices sitting
on the bus, they might each have their own reset control and while we
would attempt to manage that reset line from that call path:

mdiobus_scan()
 -> phy_device_register()
    -> mdiobus_register_device()

it would be too late because there is a preceding get_phy_device() which
attempts to read the PHY device's OUI and it would fail if the PHY is
still held in reset.

We have had a similar discussion before with regulators:

http://archive.lwn.net:8080/devicetree/20200622093744.13685-1-brgl@bgdev.pl/

and so far we do not really have a good solution to this problem either.

For your specific use case with resets you could do a couple of things:

- if there is only one PHY on the MDIO bus you can describe the reset
line to be within the MDIO bus controller node (explained above), this
is not great but it is not necessarily too far from reality either

- if you know the PHY OUI, you can put it as a compatible string in the
form: ethernet-phy-id%4x.%4x and that will avoid the MDIO bus layer to
try to read from the PHY but instead match it with a driver and create a
phy_device instance right away

I think we are open to a "pre probe" model where it is possible to have
a phy_device instance created that would allow reset controller or
regulator (or clocks, too) to be usable with a struct device reference,
yet make no HW access until all of these resources have been enabled.
-- 
Florian
