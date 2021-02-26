Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7510325C67
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 05:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhBZENK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 23:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbhBZENH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 23:13:07 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0F8C061574
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 20:12:27 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id d20so8469726oiw.10
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 20:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B5VNpdJMoE9IgsJwDJNvQwE+UmmFKJO4tBe4Sx5SXxQ=;
        b=ISHgbgLyE+yi13U3dbTV2DhZKbnkmEceYDk115WXITubVaoNyS+pQSzB4a5plaiFCn
         JKnTZofjq1CJe47x5HXo1czCYdL9Rhiw9w34Lv2ZzM/09PsLNzhz14fafX8pVhxO0BsL
         xZIzOHCAhjLUG07yjgW4iIZJrqNnFeF3FBjkVrjIcaeRzUbVgQahdZ+Jp4j31wykuESZ
         SfuCnONKfMD57dI+KpCODtnrAH13pUqKlWNbV1344NiAOMRei0/JbXMLdYmi1R6a0ccv
         aEA7RiN9p3jSSyT8XKyEEYDaz5odu/D3tstDEie1ngmUmsehqnmsymRvImHTRszsqB5r
         CTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B5VNpdJMoE9IgsJwDJNvQwE+UmmFKJO4tBe4Sx5SXxQ=;
        b=XwrIqyABts/hcSORc4PBP8T5zZ+Slf3/A2ik92gy9bbQbT6/PigFQSEEmXQtMpboOk
         Tp/RK1P2B6lIp/xMUNKlukVdN6rYgyB023dhLkvBszGYcmyTZHqpHSAm2viALifFkNby
         fR8MwryCEPthjYhP6tS5F5s9uhGxtm/+pRmrrHvk8amlOK0dM28HTQqTwNtmngiWD8kI
         EzyhuqFAIvIL0LPaNrANFovY08+KQsMXzObQRSDzqK3lLmCxlhi6zO3gsRKirjHm4eIg
         rzGRFR2JjTmRolUu2ZP6+dmI45PwpuYVqO8UNoo7ofu1dvTf+JB3fdqfjEihwdvNdicQ
         yRYA==
X-Gm-Message-State: AOAM533XzSC3kJRyTlQ7A4GwEWfVjThcODJsCQYhERI63BGlkOmSzxTP
        SzEE6gH0DZi9zHKOwfBrJVPI9g3w+PE=
X-Google-Smtp-Source: ABdhPJy6iCTwU9JVVO7AJebm6m53IO+rT3GhKr6i0UthjnBSF1+Q915CIxcrBiXkXbhLnhFPTlpDjg==
X-Received: by 2002:aca:c08b:: with SMTP id q133mr795652oif.160.1614312746556;
        Thu, 25 Feb 2021 20:12:26 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:252a:68f7:aed6:4dde? ([2600:1700:dfe0:49f0:252a:68f7:aed6:4dde])
        by smtp.gmail.com with ESMTPSA id c2sm1485621ooo.17.2021.02.25.20.12.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 20:12:25 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
References: <2323124.5UR7tLNZLG@tool>
 <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com>
 <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
 <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
 <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
 <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
 <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
 <4ee0ce3b-39b8-8645-77ce-dd9cb1b1f857@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35f5f66b-fe19-8e45-7e8a-8af85d73149f@gmail.com>
Date:   Thu, 25 Feb 2021 20:12:23 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <4ee0ce3b-39b8-8645-77ce-dd9cb1b1f857@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/25/2021 2:56 PM, Heiner Kallweit wrote:
>>>>> It's still an ugly workaround and a proper root cause analysis should be done
>>>>> first. I can only imagine that phydev->irq is overwritten in phy_probe()
>>>>> because phy_drv_supports_irq() is false. Can you please check whether
>>>>> phydev->irq is properly set in phy_device_create(), and if yes, whether
>>>>> it's reset to PHY_POLL in phy_probe()?.
>>>>>
>>>>
>>>> Hi Heiner, I added some kernel prints:
>>>>
>>>> [    2.712519] libphy: Fixed MDIO Bus: probed
>>>> [    2.721969] =======phy_device_create===========
>>>> [    2.726841] phy_device_create: dev->irq = 17
>>>> [    2.726841]
>>>> [    2.832620] =======phy_probe===========
>>>> [    2.836846] phy_probe: phydev->irq = 17
>>>> [    2.840950] phy_probe: phy_drv_supports_irq = 0, phy_interrupt_is_valid = 1
>>>> [    2.848267] phy_probe: phydev->irq = -1
>>>> [    2.848267]
>>>> [    2.854059] =======phy_probe===========
>>>> [    2.858174] phy_probe: phydev->irq = -1
>>>> [    2.862253] phy_probe: phydev->irq = -1
>>>> [    2.862253]
>>>> [    2.868121] libphy: bcm63xx_enet MII bus: probed
>>>> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>>>> irq=POLL)
>>>>
>>>> Currently using kernel 5.4.99. I still have no idea what's going on.
>>>>
>>> Thanks for debugging. This confirms my assumption that the interrupt
>>> is overwritten in phy_probe(). I'm just scratching my head how
>>> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
>>>
>>> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>>> {
>>>         return phydrv->config_intr && phydrv->ack_interrupt;
>>> }
>>>
>>> And that's the PHY driver:
>>>
>>> static struct phy_driver bcm63xx_driver[] = {
>>> {
>>>         .phy_id         = 0x00406000,
>>>         .phy_id_mask    = 0xfffffc00,
>>>         .name           = "Broadcom BCM63XX (1)",
>>>         /* PHY_BASIC_FEATURES */
>>>         .flags          = PHY_IS_INTERNAL,
>>>         .config_init    = bcm63xx_config_init,
>>>         .ack_interrupt  = bcm_phy_ack_intr,
>>>         .config_intr    = bcm63xx_config_intr,
>>> }
>>>
>>> So both callbacks are set. Can you extend your debugging and check
>>> in phy_drv_supports_irq() which of the callbacks is missing?
>>>
>>
>> Hi, both callbacks are missing on the first check. However on the next
>> calls they're there.
>>
>> [    2.263909] libphy: Fixed MDIO Bus: probed
> 
> This is weird. The phy_device seems to show up on both MDIO buses,
> the fixed one *and* the bcm63xx_enet bus.

Yes that does not make sense to me at all, but maybe something broke at
some point for non-Device Tree systems and we are just catching it now.
The largest rework that occurred during v4.4 and v4.9 was the
introduction of mdio_device.
-- 
Florian
