Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A483259FC
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 23:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232938AbhBYW53 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 17:57:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233158AbhBYW5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 17:57:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C380CC06174A
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 14:56:27 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id n4so6821214wrx.1
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 14:56:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y3OvHUuNevj5gtUgvRPGqkkcrjUNYWEErQNUAN5fYME=;
        b=ltjsJ8nd0r4qAEwW0dleDDpDX2QIpZPlCHbriVTyiLkPQ80HF5ShkMSzSNgfGyIj4D
         jPa2x6Mgro36BQx5OReNud4J1QBs2lktVtIQwrj4X7k+kjlvt/9cIzjClwdo04alxIU0
         Ci0H5uREqtg58Fr9WBYjSfcPEXHfEhOmJOID66XX2SuWAHW/2MqRZHJ51KjgxSFJYpir
         D1UYHe7CCtbYSHtaQrZWQhhJoM36rn/ZgGuFYNrqGg+i6H075nlJ0miMnp7/HUQKM95T
         crC8MO7j/T2pdzVY1shuEQsIoW9YxoKBZOW/GtOl6RH74O44+TTaPZMyypXekwS64iaB
         IWiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y3OvHUuNevj5gtUgvRPGqkkcrjUNYWEErQNUAN5fYME=;
        b=GHomHRun6Oq75wzx3aOo7N8dU/LeZQFUdUJBjBZ8wMXUyYQtbvX5LzZA6xgy1+uonc
         QCJLBnJMmArc2cxM/NPcz+76ycU0+G5UnZOaqdpYXrGqoIQ43w5RYXdMSYIJVGgNmTtA
         xcVe/PQBHhdAm8/a/ItoFPH09LvRaBUVJE5/GsezbkJ5Hu+UhVaIjobHcvKtWFMmD2TM
         udU+VKDcsKXytw5oRDJ+q6659S0Qe9KQX9uGN1rJLViJQFycUaPglbFciM4Wz8EMyiXM
         p/ghhJ3sn2/XGpkGJV0HwvPXoEJ80LxtmQBxdHnC+NuU0fdWJYPzuUHX8kTqn+egVddZ
         ex+Q==
X-Gm-Message-State: AOAM532h0jsB209tqtrVsS/kvivHwPJiS5IP3AIbXBJEHaB8WqRfUSbX
        fvfOpDuUJ/yp3at8q8+ZGRMaUVVWKXSWRw==
X-Google-Smtp-Source: ABdhPJz54MzZ4raLTa0r/CQJFKdKzOBT0tMqrqQOU54njnfZSoIE0Vbt7nIxvx6BWiLmKQK/kly/5w==
X-Received: by 2002:a5d:5705:: with SMTP id a5mr189994wrv.333.1614293786407;
        Thu, 25 Feb 2021 14:56:26 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:6075:8df8:f865:fb20? (p200300ea8f395b0060758df8f865fb20.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:6075:8df8:f865:fb20])
        by smtp.googlemail.com with ESMTPSA id c18sm13774454wmk.0.2021.02.25.14.56.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 14:56:25 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4ee0ce3b-39b8-8645-77ce-dd9cb1b1f857@gmail.com>
Date:   Thu, 25 Feb 2021 23:56:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CABwr4_siD8PcXnYuAoYCqQp8ioikJQiMgDW=JehX1c+0Zuc3rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2021 23:28, Daniel González Cabanelas wrote:
> El jue, 25 feb 2021 a las 21:05, Heiner Kallweit
> (<hkallweit1@gmail.com>) escribió:
>>
>> On 25.02.2021 17:36, Daniel González Cabanelas wrote:
>>> El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
>>> (<hkallweit1@gmail.com>) escribió:
>>>>
>>>> On 25.02.2021 00:54, Daniel González Cabanelas wrote:
>>>>> El mié, 24 feb 2021 a las 23:01, Florian Fainelli
>>>>> (<f.fainelli@gmail.com>) escribió:
>>>>>>
>>>>>>
>>>>>>
>>>>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
>>>>>>> On 24.02.2021 16:44, Daniel González Cabanelas wrote:
>>>>>>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
>>>>>>>> result of this it works in polling mode.
>>>>>>>>
>>>>>>>> Fix it using the phy_device structure to assign the platform IRQ.
>>>>>>>>
>>>>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
>>>>>>>>
>>>>>>>> After the patch:
>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
>>>>>>>>
>>>>>>>> Pluging and uplugging the ethernet cable now generates interrupts and the
>>>>>>>> PHY goes up and down as expected.
>>>>>>>>
>>>>>>>> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
>>>>>>>> ---
>>>>>>>> changes in V2:
>>>>>>>>   - snippet moved after the mdiobus registration
>>>>>>>>   - added missing brackets
>>>>>>>>
>>>>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>>>>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>> index fd876721316..dd218722560 100644
>>>>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>>>>>>>>               * if a slave is not present on hw */
>>>>>>>>              bus->phy_mask = ~(1 << priv->phy_id);
>>>>>>>>
>>>>>>>> -            if (priv->has_phy_interrupt)
>>>>>>>> +            ret = mdiobus_register(bus);
>>>>>>>> +
>>>>>>>> +            if (priv->has_phy_interrupt) {
>>>>>>>> +                    phydev = mdiobus_get_phy(bus, priv->phy_id);
>>>>>>>> +                    if (!phydev) {
>>>>>>>> +                            dev_err(&dev->dev, "no PHY found\n");
>>>>>>>> +                            goto out_unregister_mdio;
>>>>>>>> +                    }
>>>>>>>> +
>>>>>>>>                      bus->irq[priv->phy_id] = priv->phy_interrupt;
>>>>>>>> +                    phydev->irq = priv->phy_interrupt;
>>>>>>>> +            }
>>>>>>>>
>>>>>>>> -            ret = mdiobus_register(bus);
>>>>>>>
>>>>>>> You shouldn't have to set phydev->irq, this is done by phy_device_create().
>>>>>>> For this to work bus->irq[] needs to be set before calling mdiobus_register().
>>>>>>
>>>>>> Yes good point, and that is what the unchanged code does actually.
>>>>>> Daniel, any idea why that is not working?
>>>>>
>>>>> Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
>>>>> IRQ through phydev->irq works.
>>>>>
>>>>> I can resend the patch  without the bus->irq[] line since it's
>>>>> pointless in this scenario.
>>>>>
>>>>
>>>> It's still an ugly workaround and a proper root cause analysis should be done
>>>> first. I can only imagine that phydev->irq is overwritten in phy_probe()
>>>> because phy_drv_supports_irq() is false. Can you please check whether
>>>> phydev->irq is properly set in phy_device_create(), and if yes, whether
>>>> it's reset to PHY_POLL in phy_probe()?.
>>>>
>>>
>>> Hi Heiner, I added some kernel prints:
>>>
>>> [    2.712519] libphy: Fixed MDIO Bus: probed
>>> [    2.721969] =======phy_device_create===========
>>> [    2.726841] phy_device_create: dev->irq = 17
>>> [    2.726841]
>>> [    2.832620] =======phy_probe===========
>>> [    2.836846] phy_probe: phydev->irq = 17
>>> [    2.840950] phy_probe: phy_drv_supports_irq = 0, phy_interrupt_is_valid = 1
>>> [    2.848267] phy_probe: phydev->irq = -1
>>> [    2.848267]
>>> [    2.854059] =======phy_probe===========
>>> [    2.858174] phy_probe: phydev->irq = -1
>>> [    2.862253] phy_probe: phydev->irq = -1
>>> [    2.862253]
>>> [    2.868121] libphy: bcm63xx_enet MII bus: probed
>>> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>>> irq=POLL)
>>>
>>> Currently using kernel 5.4.99. I still have no idea what's going on.
>>>
>> Thanks for debugging. This confirms my assumption that the interrupt
>> is overwritten in phy_probe(). I'm just scratching my head how
>> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
>>
>> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>> {
>>         return phydrv->config_intr && phydrv->ack_interrupt;
>> }
>>
>> And that's the PHY driver:
>>
>> static struct phy_driver bcm63xx_driver[] = {
>> {
>>         .phy_id         = 0x00406000,
>>         .phy_id_mask    = 0xfffffc00,
>>         .name           = "Broadcom BCM63XX (1)",
>>         /* PHY_BASIC_FEATURES */
>>         .flags          = PHY_IS_INTERNAL,
>>         .config_init    = bcm63xx_config_init,
>>         .ack_interrupt  = bcm_phy_ack_intr,
>>         .config_intr    = bcm63xx_config_intr,
>> }
>>
>> So both callbacks are set. Can you extend your debugging and check
>> in phy_drv_supports_irq() which of the callbacks is missing?
>>
> 
> Hi, both callbacks are missing on the first check. However on the next
> calls they're there.
> 
> [    2.263909] libphy: Fixed MDIO Bus: probed

This is weird. The phy_device seems to show up on both MDIO buses,
the fixed one *and* the bcm63xx_enet bus.
I assume that if you build your kernel w/o CONFIG_FIXED_PHY
the issue should be gone. But that's not really a solution,
we need to check further.



> [    2.273026] =======phy_device_create===========
> [    2.277908] phy_device_create: dev->irq = 17
> [    2.277908]
> [    2.373104] =======phy_probe===========
> [    2.377336] phy_probe: phydev->irq = 17
> [    2.381445] phy_drv_supports_irq: phydrv->config_intr = 0,
> phydrv->ack_interrupt = 0
> [    2.389554] phydev->irq = PHY_POLL;
> [    2.393186] phy_probe: phydev->irq = -1
> [    2.393186]
> [    2.398987] =======phy_probe===========
> [    2.403108] phy_probe: phydev->irq = -1
> [    2.407195] phy_drv_supports_irq: phydrv->config_intr = 1,
> phydrv->ack_interrupt = 1
> [    2.415314] phy_probe: phydev->irq = -1
> [    2.415314]
> [    2.421189] libphy: bcm63xx_enet MII bus: probed
> [    2.426129] =======phy_connect===========
> [    2.430410] phy_drv_supports_irq: phydrv->config_intr = 1,
> phydrv->ack_interrupt = 1
> [    2.438537] phy_connect: phy_drv_supports_irq = 1
> [    2.438537]
> [    2.445284] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
> irq=POLL)
> 
> I also added the prints to phy_connect.
> 
>> Last but not least: Do you use a mainline kernel, or is it maybe
>> a modified downstream kernel? In the latter case, please check
>> in your kernel sources whether both callbacks are set.
>>
> 
> It's a modified kernel, and the the callbacks are set. BTW I also
> tested the kernel with no patches concerning to the ethernet driver.
> 
> Regards,
> Daniel
> 
>>
>>
>>>> On which kernel version do you face this problem?
>>>>
>>> The kernel version 4.4 works ok. The minimum version where I found the
>>> problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.
>>>
>>> Regards
>>> Daniel
>>>
>>>>> Regards
>>>>>> --
>>>>>> Florian
>>>>
>>

