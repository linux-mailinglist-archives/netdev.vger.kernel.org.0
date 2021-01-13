Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEBB2F54A1
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 22:38:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbhAMVhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 16:37:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbhAMVgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:36:09 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B78AC061575;
        Wed, 13 Jan 2021 13:35:01 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id g10so2943929wmh.2;
        Wed, 13 Jan 2021 13:35:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HQqEP37L3/Yy+zwbGkb0VS0Y9DkWa6qgrFY6AGrzOps=;
        b=OQ2ZbM8Bq+409g7Ej3ma3SMlADzQRtKTI0nioDlNek56Ye9qDBmM01pFxyRCZBk9Ev
         CwqRMLuaGedGh8Qi2y7XuBbPkqPJJVdT1O+hF379U0ixzjeTea0F6vHTxXHmm0bcRT2X
         sMFcd2AAY1R+noqRdPH58M0jyqd4xCie1f6YOr+ZTgpB784EVzmbN1VpFGbaswblUtGc
         vDuJC8G2ads0yn6vNWeY9yecAiMMyCnPBmb4sN9W78L3nQg5nNbHt/aHG9jytPA53s94
         /9sfNOY2siDQaSMsJ3Fp0zKb2rPsrB7vErdHc8agohpUTtmvYu3ET7/YWQpnKKyw2BOC
         B0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HQqEP37L3/Yy+zwbGkb0VS0Y9DkWa6qgrFY6AGrzOps=;
        b=RPMw4/7O2KHFE+urK7oyTyc5lqPa7DJdgpGgkv/TFyUo8BK0MpEBqPV6IuLhZO6UcL
         0CFpzmDLAYKgak+lXhf0yGt6DXxWMayROn+oPyfooC1hEYnY66ChAoclsH3MI6ZHRq6T
         8mlUOZw4z/t7+i+CxdHqontD6j60EDGNl8dl0fPZsaGOq5WFGTg8cCUBv9Zsl04RG8u2
         rWXveyT4f91RfapGEfXJ1naiQdiAHwWI9nWOCJ8kZjOrFYCrtTOAITVVHpUCBvkP6UcB
         dN2Rh4EH71n/n6nKrsa+DpdTIty+nNSaHrBKSJIkb1ByUM/c2gsjEB/yP+SRsytHuJrM
         9StQ==
X-Gm-Message-State: AOAM533jjv1O+X4YLe4MtTuUjawkUVVGBH2WbF+NE+W0kWL384LFKsGh
        K0xa1jPrcWP0MLW7Rq3czeS6E5/KXOM=
X-Google-Smtp-Source: ABdhPJwQ4sZYxeIUAaFLRDZTmGQ/5loUVIy3uc+7m6lvqK0NutwwFFa16E2wcw2tXK4iD+ILXLLEqQ==
X-Received: by 2002:a7b:cd91:: with SMTP id y17mr1034602wmj.5.1610573699693;
        Wed, 13 Jan 2021 13:34:59 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:391b:9f3f:c40b:cb6d? (p200300ea8f065500391b9f3fc40bcb6d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:391b:9f3f:c40b:cb6d])
        by smtp.googlemail.com with ESMTPSA id n9sm5295460wrq.41.2021.01.13.13.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 13:34:59 -0800 (PST)
To:     Claudiu.Beznea@microchip.com, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1610120754-14331-1-git-send-email-claudiu.beznea@microchip.com>
 <25ec943f-ddfc-9bcd-ef30-d0baf3c6b2a2@gmail.com>
 <ce20d4f3-3e43-154a-0f57-2c2d42752597@microchip.com>
 <ee0fd287-c737-faa5-eee1-99ffa120540a@gmail.com>
 <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: phy: micrel: reconfigure the phy on resume
Message-ID: <7976f7df-c22f-d444-c910-b0462b3d7f61@gmail.com>
Date:   Wed, 13 Jan 2021 22:34:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <ae4e73e9-109f-fdb9-382c-e33513109d1c@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.01.2021 13:36, Claudiu.Beznea@microchip.com wrote:
> 
> 
> On 13.01.2021 13:09, Heiner Kallweit wrote:
>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>
>> On 13.01.2021 10:29, Claudiu.Beznea@microchip.com wrote:
>>> Hi Heiner,
>>>
>>> On 08.01.2021 18:31, Heiner Kallweit wrote:
>>>> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
>>>>
>>>> On 08.01.2021 16:45, Claudiu Beznea wrote:
>>>>> KSZ9131 is used in setups with SAMA7G5. SAMA7G5 supports a special
>>>>> power saving mode (backup mode) that cuts the power for almost all
>>>>> parts of the SoC. The rail powering the ethernet PHY is also cut off.
>>>>> When resuming, in case the PHY has been configured on probe with
>>>>> slew rate or DLL settings these needs to be restored thus call
>>>>> driver's config_init() on resume.
>>>>>
>>>> When would the SoC enter this backup mode?
>>>
>>> It could enter in this mode based on request for standby or suspend-to-mem:
>>> echo mem > /sys/power/state
>>> echo standby > /sys/power/state
>>>
>>> What I didn't mentioned previously is that the RAM remains in self-refresh
>>> while the rest of the SoC is powered down.
>>>
>>
>> This leaves the question which driver sets backup mode in the SoC.
> 
> From Linux point of view the backup mode is a standard suspend-to-mem PM
> mode. The only difference is in SoC specific PM code
> (arch/arm/mach-at91/pm_suspend.S) where the SoC shutdown command is
> executed at the end and the fact that we save the address in RAM of
> cpu_resume() function in a powered memory. Then, the resume is done with
> the help of bootloader (it configures necessary clocks) and jump the
> execution to the previously saved address, resuming Linux.
> 
>> Whatever/whoever wakes the SoC later would have to take care that basically
>> everything that was switched off is reconfigured (incl. calling phy_init_hw()).
> 
> For this the bootloader should know the PHY settings passed via DT (skew
> settings or DLL settings). The bootloader runs from a little SRAM which, at
> the moment doesn't know to parse DT bindings and the DT parsing lib might
> be big enough that the final bootloader size will cross the SRAM size.
> 
>> So it' more or less the same as waking up from hibernation. Therefore I think
>> the .restore of all subsystems would have to be executed, incl. .restore of
>> the MDIO bus.
> 
> I see your point. I think it has been implemented like a standard
> suspend-to-mem PM mode because the RAM remains in self-refresh whereas in
> hibernation it is shut of (as far as I know).
> 
>> Having said that I don't think that change belongs into the
>> PHY driver.
>> Just imagine tomorrow another PHY type is used in a SAMA7G5 setup.
>> Then you would have to do same change in another PHY driver.
> 
> I understand this. At the moment the PM code for drivers in SAMA7G5 are
> saving/restoring in/from RAM the registers content in suspend/resume()
> functions of each drivers and I think it has been chosen like this as the
> RAM remains in self-refresh. Mapping this mode to hibernation will involve
> saving the content of RAM to a non-volatile support which is not wanted as
> this increases the suspend/resume time and it wasn't intended.
> 
>>
>>
>>>> And would it suspend the
>>>> MDIO bus before cutting power to the PHY?
>>>
>>> SAMA7G5 embeds Cadence macb driver which has a integrated MDIO bus. Inside
>>> macb driver the bus is registered with of_mdiobus_register() or
>>> mdiobus_register() based on the PHY devices present in DT or not. On macb
>>> suspend()/resume() functions there are calls to
>>> phylink_stop()/phylink_start() before cutting/after enabling the power to
>>> the PHY.
>>>
>>>> I'm asking because in mdio_bus_phy_restore() we call phy_init_hw()
>>>> already (that calls the driver's config_init).
>>>
>>> As far as I can see from documentation the .restore API of dev_pm_ops is
>>> hibernation specific (please correct me if I'm wrong). On transitions to
>>> backup mode the suspend()/resume() PM APIs are called on the drivers.
>>>

I'm not a Linux PM expert, to me it seems your use case is somewhere in the
middle between s2r and hibernation. I *think* the assumption with s2r is
that one component shouldn't simply cut the power to another component,
and the kernel has no idea about it.

My personal point of view:
If a driver cuts power to another component in s2r, it should take care that
this component is properly re-initialized once power is back.
Otherwise I would miss to see why we need different callbacks resume and restore.

It may be worth to involve the following people/list:

HIBERNATION (aka Software Suspend, aka swsusp)
M:	"Rafael J. Wysocki" <rjw@rjwysocki.net>
M:	Pavel Machek <pavel@ucw.cz>
L:	linux-pm@vger.kernel.org


>>> Thank you,
>>> Claudiu Beznea
>>>
>>>>
>>>>> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
>>>>> ---
>>>>>  drivers/net/phy/micrel.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
>>>>> index 3fe552675dd2..52d3a0480158 100644
>>>>> --- a/drivers/net/phy/micrel.c
>>>>> +++ b/drivers/net/phy/micrel.c
>>>>> @@ -1077,7 +1077,7 @@ static int kszphy_resume(struct phy_device *phydev)
>>>>>        */
>>>>>       usleep_range(1000, 2000);
>>>>>
>>>>> -     ret = kszphy_config_reset(phydev);
>>>>> +     ret = phydev->drv->config_init(phydev);
>>>>>       if (ret)
>>>>>               return ret;
>>>>>
>>>>>

