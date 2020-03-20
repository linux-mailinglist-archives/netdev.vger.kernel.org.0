Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D58E518C89F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 09:07:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726778AbgCTIHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 04:07:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44411 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbgCTIHb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 04:07:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so5723179wrh.11
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 01:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8RIgo40LADD0Eh7SF5vfl2YX/KSzVLo8vE1H+OvzfpU=;
        b=bWcDc+Ex2gHHklYiVs2xg/1q1Oddtf47NnuUHTV3RFXWEP9oDhqu01A4yKeBdOb5r2
         FRiNAnako/UKW1GAz+Y8+VwjP+ooswpCNBQXgbIsRYzA9QeevVwNUFKnb8xLWovE1CHh
         W50i2XfOVVKKl+yzRoKaND0boCXzkZs9ubQxwMxsZymEjqzu74L3M5YKCM96uLq2ekrv
         s0Q9PkjCW2nz5Qie1+H0uvNTqlkTkA+pOLnNX5grXNExF34e0WZHH5YHviyrm83+gNGW
         Su1MRcxPQLD3OQg3kCDUnXGHwsE6SjDYi99jI4CS8rB0lZZoGeL7x7QMT3q1KENcZJxo
         IvLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8RIgo40LADD0Eh7SF5vfl2YX/KSzVLo8vE1H+OvzfpU=;
        b=KSl6GL36YofjST02At7L94HFITjO49sgRYeDxPknAfoYTwraAEbAc3nY50Jxwb+KHa
         B2WWIy6PEnJvtZDpCVwsFi9dJuTPtbHPxpCo/Gb9ghc56dHZGSCenM8oIUDRZllmo3b4
         HZslCw6rvR1U4Y93O9PAV5hl6i3TYxcWhyD022fZeDO3RxvHAaBrh22IVvV9XWDApbka
         2m7XQgeknk5sQ2vZkuDdy+uIV8urVTgEAmEcMw+4epfdwgu9a035jcKvNXrbbHf0TA/+
         oKqx+Izm6wlDCDH94sQSrpXNXKMf+6k+4vOMwziyAPvIz6Wmd4xVKIzQ93fjfw3ttQ9i
         dZEw==
X-Gm-Message-State: ANhLgQ1Jjog+0GyHL4vgSAgYbw601VtqmRQERlfpWePERb98wKhcXbow
        F1iGl/9D9vQDI13v5n6PLb6LEo/l
X-Google-Smtp-Source: ADFU+vseKVyzkV5hsflY0opRCV3uYq7OyPSMNZFAITg1d9qw5DF3+mTEo5iR7mc+KKP979nCyOrAqA==
X-Received: by 2002:a5d:4ac8:: with SMTP id y8mr9220093wrs.272.1584691648314;
        Fri, 20 Mar 2020 01:07:28 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:511d:a818:d0f7:1b4f? (p200300EA8F296000511DA818D0F71B4F.dip0.t-ipconnect.de. [2003:ea:8f29:6000:511d:a818:d0f7:1b4f])
        by smtp.googlemail.com with ESMTPSA id e9sm7192224wrw.30.2020.03.20.01.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Mar 2020 01:07:27 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: phy: add and use phy_check_downshift
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <6e4ea372-3d05-3446-2928-2c1e76a66faf@gmail.com>
 <d2822357-4c1e-a072-632e-a902b04eba7c@gmail.com>
 <20200318232159.GA25745@shell.armlinux.org.uk>
 <b0bc3ca0-0c1b-045e-cd00-37fc85c4eebf@gmail.com>
 <20200319112535.GD25745@shell.armlinux.org.uk>
 <20200319130429.GC24972@lunn.ch>
 <20200319135800.GE25745@shell.armlinux.org.uk>
 <92689def-4bbf-8988-3137-f3cfb940e9fc@gmail.com>
 <20200319170821.GF25745@shell.armlinux.org.uk>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7e0b9a90-edff-a930-db1b-8200c815eaad@gmail.com>
Date:   Fri, 20 Mar 2020 09:07:21 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200319170821.GF25745@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.03.2020 18:08, Russell King - ARM Linux admin wrote:
> On Thu, Mar 19, 2020 at 05:36:30PM +0100, Heiner Kallweit wrote:
>> On 19.03.2020 14:58, Russell King - ARM Linux admin wrote:
>>> On Thu, Mar 19, 2020 at 02:04:29PM +0100, Andrew Lunn wrote:
>>>>> The only time that this helps is if PHY drivers implement reading a
>>>>> vendor register to report the actual link speed, and the PHY specific
>>>>> driver is used.
>>>>
>>>> So maybe we either need to implement this reading of the vendor
>>>> register as a driver op, or we have a flag indicating the driver is
>>>> returning the real speed, not the negotiated speed?
>>>
>>> I'm not sure it's necessary to have another driver op.  How about
>>> this for an idea:
>>>
>>> - add a flag to struct phy_device which indicates the status of
>>>   downshift.
>>> - on link-up, check the flag and report whether a downshift occurred,
>>>   printing whether a downshift occurred in phy_print_status() and
>>>   similar places.  (Yes, I know that there are some network drivers
>>>   that don't use phy_print_status().)
>>>
>>> The downshift flag could be made tristate - "unknown", "not downshifted"
>>> and "downshifted" - which would enable phy_print_status() to indicate
>>> whether there is downshift supported (and hence whether we need to pay
>>> more attention to what is going on when there is a slow-link report.)
>>>
>>> Something like:
>>>
>>> For no downshift:
>>> 	Link is Up - 1Gbps/Full - flow control off
>>> For downshift:
>>> 	Link is Up - 100Mbps/Full (downshifted) - flow control off
>>> For unknown:
>>> 	Link is Up - 1Gbps/Full (unknown downshift) - flow control off
>>>
>>> which has the effect of being immediately obvious if the driver lacks
>>> support.
>>>
>>> We may wish to consider PHYs which support no downshift ability as
>>> well, which should probably set the status to "not downshifted" or
>>> maybe an "unsupported" state.
>>>
>>> This way, if we fall back to the generic PHY driver, we'd get the
>>> "unknown" state.
>>>
>>
>> I'd like to split the topics. First we have downshift detection,
>> then we have downshift reporting/warning.
>>
>> *Downshift detection*
>> Prerequisite of course is that the PHY supports reading the actual,
>> possibly downshifted link speed (typically from a vendor-specific
>> register). Then the PHY driver has to set phydev->speed to the
>> actual link speed in the read_status() implementation.
>>
>> For the actual downshift detection we have two options:
>> 1. PHY provides info about a downshift event in a vendor-specific
>>    register or as an interrupt source.
>> 2. The generic method, compare actual link speed with the highest
>>    mutually advertised speed.
>> So far I don't see a benefit of option 1. The generic method is
>> easier and reduces complexity in drivers.
>>
>> The genphy driver is a fallback, and in addition may be intentionally
>> used for PHY's that have no specific features. A PHY with additional
>> features in general may or may not work properly with the genphy
>> driver. Some RTL8168-internal PHY's fail miserably with the genphy
>> driver. I just had a longer discussion about it caused by the fact
>> that on some distributions r8169.ko is in initramfs but realtek.ko
>> is not.
>> On a side note: Seems that so far the kernel doesn't provide an
>> option to express a hard module dependency that is not a code
>> dependency.
> 
> So how do we address the "fallback to genphy driver" problem for PHYs
> that do mostly work with genphy?  It is very easy to do, for example
> by omitting the PHY specific driver from the kernel configuration.
> Since the system continues to work in these cases, it may go unnoticed.
> 

A blacklist of PHY ID's known to have hard or soft issues when operated
with the genphy driver could break existing systems. But maybe we could
at least print a warning that genphy on the respective PHY ID is an
emergency fallback only and there may be functional restrictions.

However such a blacklist may be useful for PHY's that are known to not
work properly with genphy. RTL8211B is an example. On this PHY the
MMD registers are used for different proprietary purposes.
Writing to these registers in genphy_config_eee_advert() messes
up the PHY and makes it non-functional.

>> *Downshift reporting/warning*
>> In most cases downshift is caused by some problem with the cabling.
>> Users like the typical Ubuntu user in most cases are not familiar
>> with the concept of PHY downshift and what causes a downshift.
>> Therefore it's not sufficient to just report a downshift, we have
>> to provide the user with a hint what to do.
>> Adding the "downshifted" info to phy_print_status() is a good idea,
>> however I'd see it as an optional addition to the mentioned hint
>> to the user what to do.
>> The info "unknown downshift" IMO would just cause confusion. If we
>> have nothing to say, then why say something. Also users may interpret
>> "unknown" as "there's something wrong".
> 
> So you think reporting not-downshifted and no downshift capability
> implemented by the driver should appear to be identical?
> 
> You claimed as part of the patch description that a downshifted link
> was difficult to diagnose; it seems you aren't actually solving that
> problem - and in that case I would suggest that you should not be
> mentioning it in the commit log.
> 

