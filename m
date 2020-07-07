Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3279E217A19
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 23:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729150AbgGGVPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 17:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728184AbgGGVPp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 17:15:45 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ADD6C061755;
        Tue,  7 Jul 2020 14:15:45 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id g75so645401wme.5;
        Tue, 07 Jul 2020 14:15:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NktA5gnzul4WDSIk3Z8xLbXIsmGYp4CLauuUlyvE3jg=;
        b=vTeZDRygjKWIa7rdxNjKDu2EukjjD8gTP18O0VHshYa5njQb2oUQpdGItfHP6Ax4lb
         H46GjaFgqzeM6cYvm6i/eOzVtfvCA1IrRmKtj4ilG+fMd6Va0wHPkGB8ncYTSNXBWFg5
         FvZnQ1rObFZ5qbU9uYwda0JbAiRWazz+0eit0J2LhfXcrddfztkX4d2SlPIKge0STxqz
         PFFsxr87CUsURQUjT5aoz71dNWcjTrjQnQi6oUZ9w/F1GwrrIG7WmgljSAkxMBxGcL6Z
         FpSTs3jQ4qta1FBaY47At1WfeHILWpjsNIML6rngc2u0udTN2mltrvNrCVJSBw1z5U4R
         XsTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NktA5gnzul4WDSIk3Z8xLbXIsmGYp4CLauuUlyvE3jg=;
        b=baqb9iL5gRDLHXxZDjlMoi3aiIEiYwlaFQq5Ge+ef84d9cc2ZkWqGyQbZJ4JoJ+oFz
         wG7LGfzlGa+MobeZNoXnNEMKjeSRXQWy6T4qzAsz8HxgnpaYK2XtaXI3uuz6BWCeAl6v
         /tQUbiAs5wRmN/SCxKCQa9ilrGBeFRoV+EHJ+PLsDBGeLUTpW3qMBovqZ7qvdzzQqkXg
         flBY9R2tNM4nLWOed44nBTG//waIjO80VeUNXWGt4KJ/63JImhJjRfUua6hEIQxLJjMs
         xOzyfcuqRamJ/+mN07gq2b0Hr4KOWovkpUiSccyuPsUhYwJpoTuRRuIj/oPioQIimSpw
         RbQA==
X-Gm-Message-State: AOAM533qFJ//46mihYyZ8Rwo4+ZcwaiW8DxYXxZ6iMIWhMyX3s7qfE8x
        eyiLFcLMj6AqjCAELqIH55k=
X-Google-Smtp-Source: ABdhPJxft2qfu5HTED7RYZE23pZgaoI7p948dsBLtGzuDBlgnEE2+e42JDRJZk++JAtU79L9ryzzDQ==
X-Received: by 2002:a1c:7c16:: with SMTP id x22mr5770691wmc.76.1594156543778;
        Tue, 07 Jul 2020 14:15:43 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u2sm2450343wml.16.2020.07.07.14.15.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jul 2020 14:15:42 -0700 (PDT)
Subject: Re: PHY reset handling during DT parsing
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Maxime Ripard <maxime@cerno.tech>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Antoine_T=c3=a9nart?= <antoine.tenart@bootlin.com>
References: <20200706181331.x2tn5cl5jn5kqmhx@gilmour.lan>
 <20200707141918.GA928075@lunn.ch>
 <20200707145440.teimwt6kmsnyi5dz@gilmour.lan>
 <82482500-d329-71d4-619a-7cb2eddaf9ad@gmail.com>
 <CAL_JsqLxUbf28MqYXsTd-bUPTq9XXaRqVOOy6qnDd9t3LQoP9A@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1834ced3-d785-0180-599d-6e7fb640e9fd@gmail.com>
Date:   Tue, 7 Jul 2020 14:15:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAL_JsqLxUbf28MqYXsTd-bUPTq9XXaRqVOOy6qnDd9t3LQoP9A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/7/2020 10:18 AM, Rob Herring wrote:
> On Tue, Jul 7, 2020 at 10:39 AM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 7/7/2020 7:54 AM, Maxime Ripard wrote:
>>> Hi Andrew,
>>>
>>> On Tue, Jul 07, 2020 at 04:19:18PM +0200, Andrew Lunn wrote:
>>>> On Mon, Jul 06, 2020 at 08:13:31PM +0200, Maxime Ripard wrote:
>>>>> I came across an issue today on an Allwinner board, but I believe it's a
>>>>> core issue.
>>>>>
>>>>> That board is using the stmac driver together with a phy that happens to
>>>>> have a reset GPIO, except that that GPIO will never be claimed, and the
>>>>> PHY will thus never work.
>>>>>
>>>>> You can find an example of such a board here:
>>>>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm/boot/dts/sun6i-a31-hummingbird.dts#n195
>>>>>
>>>>> It looks like when of_mdiobus_register() will parse the DT, it will then
>>>>> call of_mdiobus_register_phy() for each PHY it encounters [1].
>>>>> of_mdiobus_register_phy() will then if the phy doesn't have an
>>>>> ethernet-phy-id* compatible call get_phy_device() [2], and will later on
>>>>> call phy_register_device [3].
>>>>>
>>>>> get_phy_device() will then call get_phy_id() [4], that will try to
>>>>> access the PHY through the MDIO bus [5].
>>>>>
>>>>> The code that deals with the PHY reset line / GPIO is however only done
>>>>> in mdiobus_device_register, called through phy_device_register. Since
>>>>> this is happening way after the call to get_phy_device, our PHY might
>>>>> still very well be in reset if the bootloader hasn't put it out of reset
>>>>> and left it there.
>>>>
>>>> Hi Maxime
>>>>
>>>> If you look at the history of this code,
>>>>
>>>> commit bafbdd527d569c8200521f2f7579f65a044271be
>>>> Author: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>>>> Date:   Mon Dec 4 13:35:05 2017 +0100
>>>>
>>>>     phylib: Add device reset GPIO support
>>>>
>>>> you will see there is an assumption the PHY can be detected while in
>>>> reset. The reset was originally handled inside the at803x PHY driver
>>>> probe function, before it got moved into the core.
>>>>
>>>> What you are asking for it reasonable, but you have some history to
>>>> deal with, changing some assumptions as to what the reset is all
>>>> about.
>>>
>>> Thanks for the pointer.
>>>
>>> It looks to me from the commit log that the assumption was that a
>>> bootloader could leave the PHY into reset though?
>>>
>>> It starts with:
>>>
>>>> The PHY devices sometimes do have their reset signal (maybe even power
>>>> supply?) tied to some GPIO and sometimes it also does happen that a
>>>> boot loader does not leave it deasserted.
>>>
>>> This is exactly the case I was discussing. The bootloader hasn't used
>>> the PHY, and thus the PHY reset signal is still asserted?
>>
>> The current solution to this problem would be to have a reset property
>> specified for the MDIO bus controller node such that the reset would be
>> de-asserted during mdiobus_register() and prior to scanning the MDIO bus.
> 
> Unless the reset controls all the devices on the mdio bus, the
> controller node is not the right place. The core could look into the
> child nodes, but this is just one possible property.

Both are defined and supported (with the caveat mentioned below).

> 
>> This has the nice property that for a 1:1 mapping between MDIO bus
>> controller and device, it works (albeit maybe not being accurately
>> describing hardware), but if you have multiple MDIO/PHY devices sitting
>> on the bus, they might each have their own reset control and while we
>> would attempt to manage that reset line from that call path:
>>
>> mdiobus_scan()
>>  -> phy_device_register()
>>     -> mdiobus_register_device()
>>
>> it would be too late because there is a preceding get_phy_device() which
>> attempts to read the PHY device's OUI and it would fail if the PHY is
>> still held in reset.
>>
>> We have had a similar discussion before with regulators:
>>
>> http://archive.lwn.net:8080/devicetree/20200622093744.13685-1-brgl@bgdev.pl/
>>
>> and so far we do not really have a good solution to this problem either.
>>
>> For your specific use case with resets you could do a couple of things:
>>
>> - if there is only one PHY on the MDIO bus you can describe the reset
>> line to be within the MDIO bus controller node (explained above), this
>> is not great but it is not necessarily too far from reality either
>>
>> - if you know the PHY OUI, you can put it as a compatible string in the
>> form: ethernet-phy-id%4x.%4x and that will avoid the MDIO bus layer to
>> try to read from the PHY but instead match it with a driver and create a
>> phy_device instance right away
> 
> The h/w is simply not discoverable, so it needs a compatible string.

It is discoverable if you have the various resources (regulator(s),
clock(s) and reset(s) managed ahead of issuing the discovery which is
really the crux of the problem here.

> 
>> I think we are open to a "pre probe" model where it is possible to have
>> a phy_device instance created that would allow reset controller or
>> regulator (or clocks, too) to be usable with a struct device reference,
>> yet make no HW access until all of these resources have been enabled.
> 
> I think this is needed for the kernel's driver model in general. It's
> not an MDIO specific problem.

Oh absolutely not, PCI and USB have the same issue, it is not clear to
me how to tackle this yet though.
-- 
Florian
