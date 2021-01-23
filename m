Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A71301213
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 02:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbhAWBki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 20:40:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbhAWBkb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 20:40:31 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50630C06174A;
        Fri, 22 Jan 2021 17:39:51 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id s15so4273536plr.9;
        Fri, 22 Jan 2021 17:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=k76TGReqGZM5gxHEqXtb8YM9oTy9rGbrVJES8tAPUrU=;
        b=G7o4zpfnLt54/EiM7NFzh/QrarRM1ZB6XZwZSQdl3X2R8AdxMQ0HKqEmRyLoT3PCy8
         udn3pSXSZ3JWRdEUE2Qk9Z7FQQrq5vKRgtUjiUBEAX/Ps4ai7rSVNnl8UQpaCRhSsSdh
         kxg9gCVQVt67dfALo/k4uTDCxLCoBbjFIDmG+QJvR7uF5tjz2fp78rOosfGYrtPlC/L7
         irGtRfwEBoRryCSVnxmdDYUkOLutZSjyEbCVj35tsgLqREA6mC8tdEhCAidaATeFaRrw
         1jCgfK2J+fhcUSkH+uBlG6xIu1ODC6JtuLFI1V+GXahh+EaJmb7h6hdSXcx521I7KQ05
         cttQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k76TGReqGZM5gxHEqXtb8YM9oTy9rGbrVJES8tAPUrU=;
        b=q6RMLaOXdXkIb36uYmXCegJg3Rqkp1+vOKuecZRnyFUlpUIcYNUU7/dG4vvs4s/Rih
         etuEmAxvP4Mf/X8sdPxCNHw+CDdqDzeqWY5Q+nHSurcLgzvw3BHZvRIQBDNwdB4tL2OH
         q6Wlouo8d5uuL4Dw1tMQRDSHOES0Sbi5QfAOLILhNk7nsmMfGlTANHE60VV7aU7VpFUG
         av4II1vkK/CSuTV0GK6kGgBG36o0vQmhF5BnUui77FXkPadDsl0XmDREOVgzSGCLbGMr
         7wrVqLhNAq4eh/LpN1xr77xasGN7H2Jhw+tbh3JaxFEe/KVzazYAZZySHMvbA9x4yIUh
         A+Ww==
X-Gm-Message-State: AOAM533qdks/j9FJ7Jg6aubz/z9fJcoD2hc5gnO+LuV/W6/oakQmS6wg
        VJAgq5JV5xwvFyE4sz3hgpwr7G09UU4=
X-Google-Smtp-Source: ABdhPJx/dc+Ld0WuCePhQYJXHRDxh6OxWcaBPEcLs8YwZPDV9AXOQI1wITbSMV1U0d8BDbO1WwU49A==
X-Received: by 2002:a17:902:bcc6:b029:db:e257:9050 with SMTP id o6-20020a170902bcc6b02900dbe2579050mr243905pls.22.1611365990412;
        Fri, 22 Jan 2021 17:39:50 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r30sm10826098pjg.43.2021.01.22.17.39.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 17:39:49 -0800 (PST)
Subject: Re: [PATCH v2] lan743x: add virtual PHY for PHY-less devices
To:     Sergej Bauer <sbauer@blackbox.su>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Simon Horman <simon.horman@netronome.com>,
        Mark Einon <mark.einon@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20210122214247.6536-1-sbauer@blackbox.su>
 <3174210.ndmClRx9B8@metabook>
 <5306ffe6-112c-83c9-826a-9bacd661691b@gmail.com>
 <4496952.bab7Homqhv@metabook>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cce7fdd0-2b75-26f5-ce25-ca8803ffccc5@gmail.com>
Date:   Fri, 22 Jan 2021 17:39:47 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <4496952.bab7Homqhv@metabook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2021 5:01 PM, Sergej Bauer wrote:
> On Saturday, January 23, 2021 3:01:47 AM MSK Florian Fainelli wrote:
>> On 1/22/2021 3:58 PM, Sergej Bauer wrote:
>>> On Saturday, January 23, 2021 2:23:25 AM MSK Andrew Lunn wrote:
>>>>>>> @@ -1000,8 +1005,10 @@ static void lan743x_phy_close(struct
>>>>>>> lan743x_adapter *adapter)>
>>>>>>>
>>>>>>>  	struct net_device *netdev = adapter->netdev;
>>>>>>>  	
>>>>>>>  	phy_stop(netdev->phydev);
>>>>>>>
>>>>>>> -	phy_disconnect(netdev->phydev);
>>>>>>> -	netdev->phydev = NULL;
>>>>>>> +	if (phy_is_pseudo_fixed_link(netdev->phydev))
>>>>>>> +		lan743x_virtual_phy_disconnect(netdev->phydev);
>>>>>>> +	else
>>>>>>> +		phy_disconnect(netdev->phydev);
>>>>>>
>>>>>> phy_disconnect() should work. You might want to call
>>>>
>>>> There are drivers which call phy_disconnect() on a fixed_link. e.g.
>>>>
>>>> https://elixir.bootlin.com/linux/v5.11-rc4/source/drivers/net/usb/lan78xx
>>>> .c# L3555.
>>>>
>>>>
>>>> It could be your missing call to fixed_phy_unregister() is leaving
>>>> behind bad state.
>>>
>>> lan743x_virtual_phy_disconnect removes sysfs-links and calls
>>> fixed_phy_unregister()
>>> and the reason was phydev in sysfs.
>>>
>>>>> It was to make ethtool show full set of supported speeds and MII only in
>>>>> supported ports (without TP and the no any ports in the bare card).
>>>>
>>>> But fixed link does not support the full set of speed. It is fixed. It
>>>> supports only one speed it is configured with.
>>>
>>> That's why I "re-implemented the fixed PHY driver" as Florian said.
>>> The goal of virtual phy was to make an illusion of real device working in
>>> loopback mode. So I could use ethtool and ioctl's to switch speed of
>>> device.> 
>>>> And by setting it
>>>> wrongly, you are going to allow the user to do odd things, like use
>>>> ethtool force the link speed to a speed which is not actually
>>>> supported.
>>>
>>> I have lan743x only and in loopback mode it allows to use speeds
>>> 10/100/1000MBps
>>> in full-duplex mode only. But the highest speed I have achived was
>>> something near
>>> 752Mbps...
>>> And I can switch speed on the fly, without reloading the module.
>>>
>>> May by I should limit the list of acceptable devices?
>>
>> It is not clear what your use case is so maybe start with explaining it
>> and we can help you define something that may be acceptable for upstream
>> inclusion.
> it migth be helpful for developers work on userspace networking tools with
> PHY-less lan743x (the interface even could not be brought up)
> of course, there nothing much to do without TP port but the difference is
> representative.

You are still not explaining why fixed PHY is not a suitable emulation
and what is different, providing the output of ethtool does not tell me
how you are using it.

Literally everyone using Ethernet switches or MAC to MAC Ethernet
connections uses fixed PHY and is reasonably happy with it.
-- 
Florian
