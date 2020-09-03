Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7131525C94F
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 21:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728903AbgICTVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 15:21:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgICTVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 15:21:12 -0400
Received: from ipv6.s19.hekko.net.pl (ipv6.s19.hekko.net.pl [IPv6:2a02:1778:113::19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698ABC061244;
        Thu,  3 Sep 2020 12:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=arf.net.pl;
         s=x; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PlvOvfB5+QwvQ/W9QeLL8b6wmLMhGPYKeZWDVn+meOE=; b=HtcNt810exlSybZsaivGUQV6Wp
        DIXOaEbubZeRiPHkjXa0XfUFI6TShQQwsTgA4h0LwA6Xlihgug4V0YXa9fks9pM+AFDBRn8wjp0HX
        YSLy1WdRGxCO/3Gsb50s/VlEhKC2khN7PcepF7NJK7aV4eG7uDIcFNzx9wpfeb89ifnh9e/l3bqVv
        3FUcgQSdzCf0QCKYARqIBeS4OentSe00UUDXPq4ozSuJLOXFLWocUJBKm6Z3iA99rMpL/uS6hh24N
        Zwc3hkeaC9fQBtI8dYEjFKSUG8Nlcnw98Y+8VBLPNYHK2ci5pL6woYCF+FXpKiUZPclacVnP0sDsR
        1C6OKIoA==;
Received: from 188.147.96.44.nat.umts.dynamic.t-mobile.pl ([188.147.96.44] helo=[192.168.8.103])
        by s19.hekko.net.pl with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.92.3)
        (envelope-from <adam.rudzinski@arf.net.pl>)
        id 1kDunG-00FF7X-3o; Thu, 03 Sep 2020 21:21:10 +0200
Subject: Re: [RFC net-next 2/2] net: phy: bcm7xxx: request and manage GPHY
 clock
To:     Florian Fainelli <f.fainelli@gmail.com>,
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
 <26a8a508-6108-035a-1416-01cff51a930a@gmail.com>
 <a61eacc0-caaf-aee9-c0e6-11280c893d65@arf.net.pl>
 <7b38d9fe-7c01-a658-fddd-c32e5a0b6f0d@gmail.com>
From:   =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>
Message-ID: <81674781-d5b5-d826-e41c-0d62b75677d3@arf.net.pl>
Date:   Thu, 3 Sep 2020 21:21:08 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <7b38d9fe-7c01-a658-fddd-c32e5a0b6f0d@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: pl
X-Authenticated-Id: ar@arf.net.pl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


W dniu 2020-09-03 o 19:17, Florian Fainelli pisze:
>
>
> On 9/3/2020 10:13 AM, Adam Rudziński wrote:
>>
>> W dniu 2020-09-03 o 17:21, Florian Fainelli pisze:
>>>
>>>
>>> On 9/2/2020 11:00 PM, Adam Rudziński wrote:
>>>>
>>>> W dniu 2020-09-03 o 04:13, Florian Fainelli pisze:
>>>>>
>>>>>
>>>>> On 9/2/2020 3:20 PM, Andrew Lunn wrote:
>>>>>>> +    priv->clk = devm_clk_get_optional(&phydev->mdio.dev, 
>>>>>>> "sw_gphy");
>>>>>>> +    if (IS_ERR(priv->clk))
>>>>>>> +        return PTR_ERR(priv->clk);
>>>>>>> +
>>>>>>> +    /* To get there, the mdiobus registration logic already 
>>>>>>> enabled our
>>>>>>> +     * clock otherwise we would not have probed this device 
>>>>>>> since we would
>>>>>>> +     * not be able to read its ID. To avoid artificially 
>>>>>>> bumping up the
>>>>>>> +     * clock reference count, only do the clock enable from a 
>>>>>>> phy_remove ->
>>>>>>> +     * phy_probe path (driver unbind, then rebind).
>>>>>>> +     */
>>>>>>> +    if (!__clk_is_enabled(priv->clk))
>>>>>>> +        ret = clk_prepare_enable(priv->clk);
>>>>>>
>>>>>> This i don't get. The clock subsystem does reference counting. So 
>>>>>> what
>>>>>> i would expect to happen is that during scanning of the bus, phylib
>>>>>> enables the clock and keeps it enabled until after probe. To keep
>>>>>> things balanced, phylib would disable the clock after probe.
>>>>>
>>>>> That would be fine, although it assumes that the individual PHY 
>>>>> drivers have obtained the clocks and called clk_prepare_enable(), 
>>>>> which is a fair assumption I suppose.
>>>>>
>>>>>>
>>>>>> If the driver wants the clock enabled all the time, it can enable it
>>>>>> in the probe method. The common clock framework will then have two
>>>>>> reference counts for the clock, so that when the probe exists, and
>>>>>> phylib disables the clock, the CCF keeps the clock ticking. The PHY
>>>>>> driver can then disable the clock in .remove.
>>>>>
>>>>> But then the lowest count you will have is 1, which will lead to 
>>>>> the clock being left on despite having unbound the PHY driver from 
>>>>> the device (->remove was called). This does not allow saving any 
>>>>> power unfortunately.
>>>>>
>>>>>>
>>>>>> There are some PHYs which will enumerate with the clock disabled. 
>>>>>> They
>>>>>> only need it ticking for packet transfer. Such PHY drivers can 
>>>>>> enable
>>>>>> the clock only when needed in order to save some power when the
>>>>>> interface is administratively down.
>>>>>
>>>>> Then the best approach would be for the OF scanning code to enable 
>>>>> all clocks reference by the Ethernet PHY node (like it does in the 
>>>>> proposed patch), since there is no knowledge of which clock is 
>>>>> necessary and all must be assumed to be critical for MDIO bus 
>>>>> scanning. Right before drv->probe() we drop all resources 
>>>>> reference counts, and from there on ->probe() is assumed to manage 
>>>>> the necessary clocks.
>>>>>
>>>>> It looks like another solution may be to use the assigned-clocks 
>>>>> property which will take care of assigning clock references to 
>>>>> devices and having those applied as soon as the clock provider is 
>>>>> available.
>>>>
>>>> Hi Guys,
>>>>
>>>> I've just realized that a PHY may also have a reset signal 
>>>> connected. The reset signal may be controlled by the dedicated 
>>>> peripheral or by GPIO.
>>>
>>> There is already support for such a thing within 
>>> drivers/net/phy/mdio_bus.c though it assumes we could bind the PHY 
>>> device to its driver already.
>>>
>>>>
>>>> In general terms, there might be a set of control signals needed to 
>>>> enable the PHY. It seems that the clock and the reset would be the 
>>>> typical useful options.
>>>>
>>>> Going further with my imagination of how evil the hardware design 
>>>> could be, in general the signals for the PHY may have some 
>>>> relations to other control signals.
>>>>
>>>> I think that from the software point of view this comes down to 
>>>> assumption that the PHY is to be controlled "driver only knows how".
>>>
>>> That is all well and good as long as we can actually bind the PHY 
>>> device which its driver, and right now this means that we either have:
>>>
>>> - a compatible string in Device Tree which is of the form 
>>> ethernet-phy-id%4x.%4x (see of_get_phy_id) which means that we 
>>> *know* already which PHY we have and we avoid doing reads of 
>>> MII_PHYSID1 and MII_PHYSID2. This is a Linux implementation detail 
>>> that should not have to be known to systems designer IMHO
>>>
>>> - a successful read of MII_PHYSID1 and MII_PHYSID2 (or an equivalent 
>>> for the clause 45 PHYs) that allows us to know what PHY device we 
>>> have, which is something that needs to happen eventually.
>>>
>>> The problem is when there are essential resources such as clocks, 
>>> regulators, reset signals that must be enabled, respectively 
>>> de-asserted in order for a successful MDIO read of MII_PHYSID1 and 
>>> MII_PHYSID2 to succeed.
>>>
>>> There is no driver involvement at that stage because we have no 
>>> phy_device to bind it to *yet*. Depending on what we read from 
>>> MII_PHYSID1/PHY_ID2 we will either successfully bind to the Generic 
>>> PHY driver (assuming we did not read all Fs) or not and we will 
>>> return -ENODEV and then it is game over.
>>>
>>> This is the chicken and egg problem that this patch series is 
>>> addressing, for clocks, because we can retrieve clock devices with 
>>> just a device_node reference.
>>
>> I have an impression that here the effort goes in the wrong 
>> direction. If I understand correctly, the goal is to have the kernel 
>> find out what will the driver need to use the phy. But, the kernel 
>> anyway calls a probe function of the driver, doesn't it? To me it 
>> looks as if you were trying to do something that the driver 
>> will/would/might do later, and possibly "undo" it in the meantime. In 
>> this regard, this becomes kind of a workaround, not solution of the 
>> problem. Also, having taken a glance at your previous messages, I can 
>> tell that this is all becoming even more complex.
>
> What is the problem according to you, and what would an acceptable 
> solution look like then?
>
>>
>> I think that the effort should be to allow any node in the device 
>> tree to take care about its child nodes by itself, and just "report" 
>> to the kernel, or "install" in the kernel whatever is necessary, but 
>> without any initiative of the kernel. Let the drivers be as 
>> complicated as necessary, not the kernel.
>
> The Device Tree representation is already correct in that it lists 
> clocks/regulators/reset signals that are needed by the PHY. The 
> problem is its implementation with the Linux device driver model. 
> Please read again what I wrote.

The problem which I had, was that kernel was unable to read ID of second 
PHY, because it needed to have the clock enabled, and during probing it 
still didn't have. I don't know what problems are addressed by the 
discussed patches - only the same one, or if something else too.
In my solution, of my problem, which now works well for me, instead of 
teaching kernel any new tricks, I've taught the kernel to listen to the 
driver, by adding a function allowing the driver to register its PHY on 
the MDIO bus at any time. Then, each driver instance (for a particular 
interface) configures whatever is necessary, finds its PHY when probing 
the shared MDIO bus, and tells the kernel(?) to add it to the shared 
MDIO bus. Since each one does that, when the time comes, all PHYs are 
known and all interfaces are up.
This is just an example. It doesn't need the kernel to mimic the driver. 
But, it requires a bit different structure of the device tree, and I 
guess I'm not aware of tons of reasons for which it's not "the good 
way". Sorry, I can't be more constructive here, I don't have that much 
experience with the kernel. The idea is simple: the driver does the job, 
not the kernel.
You know much better than me how Linux works, so you decide if this 
makes sense, or not, and what does this actually mean in the context of 
the system.

Concerning invalid PHY ID, all Fs are read when the MDIO bus works, but 
the PHY is inactive. Another invalid ID is all 0s. I have seen this 
value when the MDIO bus didn't have the pins assigned, so its signals 
were "trapped" in the processor. Another cause could be a physical fault 
(short?) on the bus. Maybe this case should end up in returning -ENODEV too.

Best regards,
Adam

