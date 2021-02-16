Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8446031D2FB
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 00:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbhBPXOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 18:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbhBPXOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 18:14:52 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCFCDC061574
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 15:14:11 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id gb24so271673pjb.4
        for <netdev@vger.kernel.org>; Tue, 16 Feb 2021 15:14:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IymmMznKSy7Bmsv+H9um3qpKnm8pIQX/vfN8+zKSIVE=;
        b=Z0Jd3P2qcYY30LF3BKZ83VvyofUOXiGAlINP5DT9l6+ZcKp6Ub3SHcYu7PSsmgfPQz
         CrV8HVaVmBwnjTwEeiiEVeOWlPeZVt2BnUrYIgMcuLdP1I7iTVJFZHshbEImzXnXn/lZ
         /6wk+ZW4PVRKzpcYNUv9lUk/aWdarZ616ZcKQWlbXGcgobdhWm/AjZm+8jNiK50a2tnL
         Tim/fHPm/GroYQlixIC8Lijpvl+hoqYq+xNu8yTgNk5UjJmAOoSID4UKC9B2qUCLyefl
         +iidtFe5snbgpyExTV9TJOkYDbGv8jZgF7Or8iR1CYhY0DAIFBzz2NEe/UsGBrXZflDk
         GvIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IymmMznKSy7Bmsv+H9um3qpKnm8pIQX/vfN8+zKSIVE=;
        b=HYG24G/BgCFBVKckZ7rAYEij1RhrJ9O9XBPeFCvDmcLJapR6Glb73DdLFG05vL49Jg
         usCsPUXHBeg5DyEWvJiookuC8PDxggkJtInVTtzQzp8bmiM6foDmfUleeZSSIQJevu8q
         4/4b2+Sxfc6yLuCqn+gy2NV2IDz/UopZdz0uILXCjc9owOuj5lIFBkj8qZmp8LVwl21C
         VuOyuOao8lyQQH0yCzYyaMMq55XVLI3yxsORTJH/w1VYr1OYpvBvVa7dHyGmJTjHLaxW
         KSeYzognElOltCWwEM+CvO49NuJzQ58lhuZU8nbk8gV5CPejseSJsMnNJhbBYNBylBtS
         0hCw==
X-Gm-Message-State: AOAM530mFXMG7jYFbygk2FXMJfdvBVdXJjcMv5REj8A9vB4hmX9I8kOV
        QDyMphXj2LJBKg6LbkF9qed5GCFpGck=
X-Google-Smtp-Source: ABdhPJwoyw70SmLSXrE/50KnLS6u5PfiD2qv1932/KW3ABoNMKNCU9FJ3grx4nWhW2fnO0HElZbz/g==
X-Received: by 2002:a17:90a:ac14:: with SMTP id o20mr6291888pjq.171.1613517251122;
        Tue, 16 Feb 2021 15:14:11 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s184sm35420pfc.106.2021.02.16.15.14.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Feb 2021 15:14:10 -0800 (PST)
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
 <YCvDVEvBU5wabIx7@lunn.ch> <55c94cf4-f660-f0f5-fb04-f51f4d175f53@gmail.com>
 <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <36a4299c-6a1a-016d-c563-fb3be4467e79@gmail.com>
Date:   Tue, 16 Feb 2021 15:14:07 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CA+aJhH3SE1s8P+srhO_-Za3E0KdHVn2_bK=Kf+-Jtbm1vJNm1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/16/2021 2:57 PM, Nathan Rossi wrote:
> On Wed, 17 Feb 2021 at 03:50, Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>>
>>
>> On 2/16/2021 5:06 AM, Andrew Lunn wrote:
>>> On Mon, Feb 15, 2021 at 07:02:18AM +0000, Nathan Rossi wrote:
>>>> From: Nathan Rossi <nathan.rossi@digi.com>
>>>>
>>>> The documentation for MDIO bindings describes the "broken-turn-around",
>>>> "reset-assert-us", and "reset-deassert-us" properties such that any MDIO
>>>> device can define them. Other MDIO devices may require these properties
>>>> in order to correctly function on the MDIO bus.
>>>>
>>>> Enable the parsing and configuration associated with these properties by
>>>> moving the associated OF parsing to a common function
>>>> of_mdiobus_child_parse and use it to apply these properties for both
>>>> PHYs and other MDIO devices.
>>>
>>> Hi Nathan
>>>
>>> What device are you using this with?
>>>
>>> The Marvell Switch driver does its own GPIO reset handling. It has a
>>> better idea when a hardware reset should be applied than what the
>>> phylib core has. It will also poll the EEPROM busy bit after a
>>> reset. How long a pause you need after the reset depends on how full
>>> the EEPROM is.
>>>
>>> And i've never had problems with broken-turn-around with Marvell
>>> switches.
>>
>> The patch does make sense though, Broadcom 53125 switches have a broken
>> turn around and are mdio_device instances, the broken behavior may not
>> show up with all MDIO controllers used to interface though. For the
> 
> Yes the reason we needed this change was to enable broken turn around,
> specifically with a Marvell 88E6390.
> 
>> reset, I would agree with you this is better delegated to the switch
>> driver, given that unlike PHY devices, we have no need to know the
>> mdio_device ID prior to binding the device and the driver together.
>>
>>>
>>> Given the complexity of an Ethernet switch, it is probably better if
>>> it handles its own reset.
> 
> We are not using the reset assert, I included this as part of the
> change to match the existing phy parsing behavior. I can update this
> change to only handle broken turn around, or is it also preferred that
> broken turn around is handled by the e.g. switch driver?

Broken turn around needs to be handled by the core MDIO layer since it
affects what happens to the mdiobus_read() operation, so it is
appropriate to be common to all MDIO and PHY devices. Basically take
your patch but leave the reset handling to the PHY device handling.
-- 
Florian
