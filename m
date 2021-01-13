Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 454F72F49BA
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 12:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbhAMLKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 06:10:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727716AbhAMLKY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 06:10:24 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8A9C061575;
        Wed, 13 Jan 2021 03:09:43 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id h17so1018794wmq.1;
        Wed, 13 Jan 2021 03:09:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UMQi/tBvEKdEimXx+EFDrWUxg58rI/isxR33AmE9DZQ=;
        b=sHxBp11HxkeBq5dpd3LoxrqfkeetD4G8db6oe7+kucTgDw9cxn/PKaduCtWWtuNz4N
         XDo2nKRN7DfJ1WPRzwYbU6Fg4hl7AIgdQZiAolIQVKIIEevR3zMcWFdqZE8hTQ0pf7y5
         5JJd6BxKhJPJdKZ5Qv6LE5NO7U+sx1p2+Gj9PLGx079xvImEFMSM9auwJ4W3YjGXzj8z
         N2TFYGz5GhiSp8HyUjJYVnJk3GDgd859WoCC6MiAyuWgTNFdst1MXN9Vht1kjkoQvtUb
         xQj2GxfZ21YZIvAJGAr6KbIpCIehF05/BQ/MUwyDmFU+RHBCIlvAt/52V4BCIZKwYgAx
         HpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UMQi/tBvEKdEimXx+EFDrWUxg58rI/isxR33AmE9DZQ=;
        b=EFZLQdBSITGzhr1gK4IDYUX/CQn6zW/JE4GwLJy7kYuxzAEsG+mkXwsEABW1okQdwq
         LXVkuT2iwp6/XUZGtoIsuJRH5qbm9m+9D0vGTMJAc3MTcgyaBJucV5kvnaH84UE0tGaw
         hk93uO5BkYW/nWZSXoDpsscOEC2vhn4gGYteOtTZ8V3RyZ13qQcWRba5ZUqLnS/63SL1
         U68r+lrD6OpH1C+l7Ite4smpmHk2SNtxnyr/HbTQ7uVQHB8nPtV2oHdJXAoXyorMvo1X
         1Bkx1i4tIgPs2ZNV4tTLjgDcsligE/16yWp+O6Ke8XADAocYr62bXXjRpn2LvMHvDX+M
         4Btw==
X-Gm-Message-State: AOAM533QNPf4Gpgd2fMkY0jRqj4emExelvPxPkjGvs1L+pvDa0cXyxsj
        lT5oP6J7XmRruujls3G/UCWtP7zWFS8=
X-Google-Smtp-Source: ABdhPJwh0w6DilTj8o3+r2xlFBs0NrlQBzN77ulhHtuSo+0EZnSuxSYNPPHOxskJzuLMfaUmNNlzqg==
X-Received: by 2002:a1c:5406:: with SMTP id i6mr1647564wmb.137.1610536182334;
        Wed, 13 Jan 2021 03:09:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:88b8:675a:f9a7:fc44? (p200300ea8f06550088b8675af9a7fc44.dip0.t-ipconnect.de. [2003:ea:8f06:5500:88b8:675a:f9a7:fc44])
        by smtp.googlemail.com with ESMTPSA id u3sm3237824wre.54.2021.01.13.03.09.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 03:09:41 -0800 (PST)
To:     Claudiu.Beznea@microchip.com, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
Date:   Wed, 13 Jan 2021 12:09:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.01.2021 10:29, Claudiu.Beznea@microchip.com wrote:
> Hi Heiner,
> 
> On 08.01.2021 18:31, Heiner Kallweit wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 08.01.2021 16:45, Claudiu Beznea wrote:
>>> KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
>>> power saving mode (backup mode) that cuts the power for almost all
>>> parts of the SoC. The rail powering the ethernet PHY is also cut off.
>>> When resuming, in case the PHY has been configured on probe with
>>> slew rate or DLL settings these needs to be restored thus call
>>> driver's config_init() on resume.
>>>
>> When would the SoC enter this backup mode?
> 
> It could enter in this mode based on request for standby or suspend-to-mem:
> echo mem > /sys/power/state
> echo standby > /sys/power/state
> 
> What I didn't mentioned previously is that the RAM remains in self-refresh
> while the rest of the SoC is powered down.
> 

This leaves the question which driver sets backup mode in the SoC.
Whatever/whoever wakes the SoC later would have to take care that basically
everything that was switched off is reconfigured (incl. calling phy_init_hw()). 
So it' more or less the same as waking up from hibernation. Therefore I think
the .restore of all subsystems would have to be executed, incl. .restore of
the MDIO bus. Having said that I don't think that change belongs into the
PHY driver.
Just imagine tomorrow another PHY type is used in a SAMA7G5 setup.
Then you would have to do same change in another PHY driver.


>> And would it suspend the
>> MDIO bus before cutting power to the PHY?
> 
> SAMA7G5 embeds Cadence macb driver which has a integrated MDIO bus. Inside
> macb driver the bus is registered with of_mdiobus_register() or
> mdiobus_register() based on the PHY devices present in DT or not. On macb
> suspend()/resume() functions there are calls to
> phylink_stop()/phylink_start() before cutting/after enabling the power to
> the PHY.
> 
>> I'm asking because in mdio_bus_phy_restore() we call phy_init_hw()
>> already (that calls the driver's config_init).
> 
> As far as I can see from documentation the .restore API of dev_pm_ops is
> hibernation specific (please correct me if I'm wrong). On transitions to
> backup mode the suspend()/resume() PM APIs are called on the drivers.
> 
> Thank you,
> Claudiu Beznea
> 
>>
>>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>>> ---
>>>  drivers/net/phy/micrel.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>>> index 3fe552675dd2..52d3a0480158 100644
>>> --- a/drivers/net/phy/micrel.c
>>> +++ b/drivers/net/phy/micrel.c
>>> @@ -1077,7 +1077,7 @@ static int kszphy_resume(struct phy_device *phydev)
>>>        */
>>>       usleep_range(1000, 2000);
>>>
>>> -     ret = kszphy_config_reset(phydev);
>>> +     ret = phydev->drv->config_init(phydev);
>>>       if (ret)
>>>               return ret;
>>>
>>>

