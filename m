Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F328D1260EF
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 12:38:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbfLSLiH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 06:38:07 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38490 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbfLSLiH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 06:38:07 -0500
Received: by mail-wm1-f68.google.com with SMTP id u2so5264036wmc.3
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 03:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jf62kbN7383jdbacis7wNrHsnIjmJJKbnrW4LQu+pOE=;
        b=HlPFn6uz5WTCvbTJzAWBqeXC+g+uLegghG7BVlmtGZ0mBTTYPmzXeFJ+4CjPv2S0H6
         5/p4ffxhyoP0UatrnDUlpJml2y0oDwANH63a3Se+7dTdCjVWMk5fyB0H22sEBlvrvzaE
         mXYXONpvwqIbbvxLr9xWWnz7pjVfo1MS827D2emBUfpTBwXY3L1/O3UnpmNUwLkinfbe
         bmh4a9kd1CqveAJXvB5f3UE2v5Bfk2YnLfSMZsaS87d0PEONpVM39cs2ZwjZA+iHZszV
         RTTk92sGFg9n2NC4hPgwb1i6mg9DGoVHRPUPMTxoLBoptUSoBdFg3c30YuQjnLuhluM3
         Go+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jf62kbN7383jdbacis7wNrHsnIjmJJKbnrW4LQu+pOE=;
        b=XTSsKEmUVe/AXJIfbSf/FHA2dzJpOsjey6L2ayFlpJLe6TalMmRcySKz4D/QHCHEWl
         9LS4TvM1aBxMOYuNXmRINfVCWAKcNxP6ZdI8/H7+zVWVoJdoDED9UcmHX+RQBAXJ6ESD
         553Y+reY9FPgYLMU3JMHPVFaJv+ZbSVwXpHatUswPtgcSbS3r9oFjFo87DxzVADWoYVL
         DE14w4TJDdaNTqFtxy6DEWQkbvKTF1/T6sIe4eFzr8JEdOyLqWi17+rv8hZ9I/S/4gB6
         Dhmcxd0KK4s7spC6VxQqwLBi8ILf2QmbjdyOwvpqV8foZDdy53mP6Ezgu+Qsz9YZMAfX
         RnAA==
X-Gm-Message-State: APjAAAVEXA9HXrjL/QC/Tq5FDDsFfnBJB3cnVGDF8thUzQeQcmv0nUKv
        SGycAIiqsXp6fQ45Us50x+LaynTk
X-Google-Smtp-Source: APXvYqzcvKEaLpoDZLuwXL+PdrA1ooMqPJF/R/rfenqJ4fdOCxmG1FiCWPI2G2NjOwfEI4Sb4jxZBg==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr9056721wmb.99.1576755483536;
        Thu, 19 Dec 2019 03:38:03 -0800 (PST)
Received: from [192.168.1.186] (248.189.199.178.dynamic.wline.res.cust.swisscom.ch. [178.199.189.248])
        by smtp.gmail.com with ESMTPSA id k11sm5842018wmc.20.2019.12.19.03.38.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2019 03:38:02 -0800 (PST)
Subject: Re: [RFC PATCH v2 0/8] Convert Felix DSA switch to PHYLINK
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20191217221831.10923-1-olteanv@gmail.com>
 <20191218104008.GT25745@shell.armlinux.org.uk>
 <CA+h21hrbqggYxzd6SGhBmy3fUbmG2EFqbOHAnkDu8xPYRP7ewg@mail.gmail.com>
 <20191218132942.GU25745@shell.armlinux.org.uk>
 <e199162b-9b90-0a90-e74e-3b19e542f710@nxp.com>
 <20191218172236.GV25745@shell.armlinux.org.uk>
 <7fd147c9-7531-663a-923f-cdfb0a290fe8@nxp.com>
 <20191218232155.GY25745@shell.armlinux.org.uk>
From:   Alexandru Marginean <alexm.osslist@gmail.com>
Message-ID: <406c1cee-f032-f660-af1e-68b60fe87276@gmail.com>
Date:   Thu, 19 Dec 2019 12:38:00 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191218232155.GY25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/19/2019 12:21 AM, Russell King - ARM Linux admin wrote:
> On Wed, Dec 18, 2019 at 08:15:59PM +0000, Alexandru Marginean wrote:
>> On 12/18/2019 6:22 PM, Russell King - ARM Linux admin wrote:
>>> On Wed, Dec 18, 2019 at 03:00:41PM +0000, Alexandru Marginean wrote:
>>>> On 12/18/2019 2:29 PM, Russell King - ARM Linux admin wrote:
>>>>> On Wed, Dec 18, 2019 at 03:21:02PM +0200, Vladimir Oltean wrote:
>>>>>> - The at803x.c driver explicitly checks for the ACK from the MAC PCS,
>>>>>> and prints "SGMII link is not ok" otherwise, and refuses to bring the
>>>>>> link up. This hurts us in 4.19 because I think the check is a bit
>>>>>> misplaced in the .aneg_done callback. To be precise, what we observe
>>>>>> is that this function is not called by the state machine a second,
>>>>>> third time etc to recheck if the AN has completed in the meantime. In
>>>>>> current net-next, as far as I could figure out, at803x_aneg_done is
>>>>>> dead code. What is ironic about the commit f62265b53ef3 ("at803x:
>>>>>> double check SGMII side autoneg") that introduced this function is
>>>>>> that it's for the gianfar driver (Freescale eTSEC), a MAC that has
>>>>>> never supported reprogramming itself based on the in-band config word.
>>>>>> In fact, if you look at gfar_configure_serdes, it even configures its
>>>>>> register 0x4 with an advertisement for 1000Base-X, not SGMII (0x4001).
>>>>>> So I really wonder if there is any real purpose to this check in
>>>>>> at803x_aneg_done, and if not, I would respectfully remove it.
>>>>>
>>>>> Please check whether at803x will pass data if the SGMII config exchange
>>>>> has not completed - I'm aware of some PHYs that, although link comes up
>>>>> on the copper side, if AN does not complete on the SGMII side, they
>>>>> will not pass data, even if the MAC side is forced up.
>>>>>
>>>>> I don't see any configuration bits in the 8031 that suggest the SGMII
>>>>> config exchange can be bypassed.
>>>>>
>>>>>> - The vsc8514 PHY driver configures SerDes AN in U-Boot, but not in
>>>>>> Linux. So we observe that if we disable PHY configuration in U-Boot,
>>>>>> in-band AN breaks in Linux. We are actually wondering how we should
>>>>>> fix this: from what you wrote above, it seems ok to hardcode SGMII AN
>>>>>> in the PHY driver, and just ignore it in the PCS if managed =
>>>>>> "in-band-status" is not set with PHYLINK. But as you said, in the
>>>>>> general case maybe not all PHYs work until they haven't received the
>>>>>> ACK from the MAC PCS, which makes this insufficient as a general
>>>>>> solution.
>>>>>>
>>>>>> But the 2 cases above illustrate the lack of consistency among PHY
>>>>>> drivers w.r.t. in-band aneg.
>>>>>
>>>>> Indeed - it's something of a mine field at the moment, because we aren't
>>>>> quite sure whether "SGMII" means that the PHY requires in-band AN or
>>>>> doesn't provide it. For the Broadcom case I mentioned, when it's used on
>>>>> a SFP, I've had to add a quirk to phylink to work around it.
>>>>>
>>>>> The problem is, it's not a case that the MAC can demand that the PHY
>>>>> provides in-band config - some PHYs are incapable of doing so. Whatever
>>>>> solution we come up with needs to be a "negotiation" between the PHY
>>>>> driver and the MAC driver for it to work well in the known scenarios -
>>>>> like the case with the Broadcom PHY on a SFP that can be plugged into
>>>>> any SFP supporting network interface...
>>>>
>>>> Some sort of capability negotiation does seem to be the proper solution.
>>>> We can have a new capabilities field in phydev for system interface
>>>> capabilities and match that with MAC capabilities, configuration, factor
>>>> in the quirks.  The result would tell if a solution is possible,
>>>> especially with quirky PHYs, and if PHY drivers need to enable AN.
>>>>
>>>> Until we have that in place, any recommended approach for PHY drivers,
>>>> is it acceptable to hardcode system side AN on as a short term fix?
>>>> I've just tested VSC8514 and it doesn't allow traffic through if SI AN
>>>> is enabled but does not complete.  We do use it with AN on on NXP
>>>> systems, and it only works because U-Boot sets things up that way, but
>>>> relying on U-Boot isn't great.
>>>> Aquantia PHYs we use also require AN to complete if enabled.  For them
>>>> Linux depends on U-Boot or on PHY firmware to enable AN.  I don't know
>>>> if anyone out there uses these PHYs with AN off.  Would a patch that
>>>> hardcodes AN on for any of these PHYs be acceptable?
>>>
>>> I'm not sure why you're talking about hard-coding anything. As I've
>>> already mentioned, phylink allows you to specify today whether you
>>> want to use in-band AN or not, provided the MAC implements it as is
>>> done with mvneta and mvpp2.
>>
>> I was asking about PHY drivers, not MAC, in the meantime I noticed
>> phy_device carries a pointer to phylink.  I assume it's OK if PHY
>> drivers check link_an_mode and set up PHY system interface based on it.
> 
> Definitely not on several counts:
> 
> 1. it's an opaque structure to everything but phylink itself (you
>     may notice that it's defined in phylink.c, and that is why - it
>     is unsafe to go poking about in it.)  Lessons should've been
>     learnt from phylib allowing MAC drivers to go poking about in
>     phylib internal state (which I hear phylib maintainers regret
>     allowing.)  This is an intentional design choice on my part to
>     ensure that we do not fall into the same trap.
> 
> 2. phylink really needs to know what the PHY properties are before
>     the driver goes poking about in phylink - the current phylink
>     state at a particular point in time may not be the operating state
>     ultimately chosen for the PHY.
> 
> 3. phylib may not be used with phylink, and we need phylib to
>     continue to work in phylink-less systems.
> 
> (2) is the killer, because it's useless trying to look at the phylink
> state when the PHY is "attached" (and hence config_init is called.)

My bad, I just assumed without checking that phylink is more like phylib 
than it actually is.  (3) is probably less of a problem, phy drivers 
could check if phylink pointers is NULL, but it doesn't matter anyway, 
since the phylink structure is opaque.

> To see why we need PHY property information earlier, look at
> phylink.c in net-next, specifically:
> 
> 1. phylink_bringup_phy(), where we have a special case for Clause 45
>     PHYs that switch their interface modes.
> 
> 2. phylink_phy_no_inband() and phylink_sfp_connect_phy() which
>     special-cases the Broadcom PHY that provides no in-band AN.
>     That is particularly relevant to my point (2) above.
> 
> 3. phylink_sfp_connect_phy() needing to know the capabilities of
>     the PHY before the PHY driver has been attached, so that we can
>     select a particular interface mode that is suitable for the PHY
>     to co-operate with the MAC.
> 

This is all fair and I'm not arguing against a proper solution that 
involves a capability exchange between PHY and MAC.

Until we have that in place, or if phylib is used, PHY drivers should 
probably apply a recommended configuration in config_init based on 
information available to them at that time.  For phy-mode = "sgmii" or 
"qsgmii" I think PHY drivers should enable AN on system side by default 
if that's an option in the PHY hardware.  Currently some seem to do it, 
other don't.  In that context vsc8514 config_init could hardcode 
enabling of AN, phy-mode wouldn't even matter as the PHY only supports 
qsgmii.

This kind of change does not address the overall problem but at least 
makes PHYs more uniform and predictable.

In the proper solution phylink could later determine what the PHY 
configuration should be based on MAC capabilities and configuration and 
re-apply it using a new op, potentially turning off system side AN in 
vsc8514 case.  Does this look reasonable?

Thanks!
Alex
