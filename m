Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9F2F32604B
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230419AbhBZJkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbhBZJjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:39:24 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A5AC061786
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:38:44 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id w11so7898797wrr.10
        for <netdev@vger.kernel.org>; Fri, 26 Feb 2021 01:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wvH0NwxgEVjzQCtBvx9deQeGY1e94WvetRehSm7lPh8=;
        b=Q5QNMX5+lrvpstEgFo6b7Yg41WFmtbovuoeUND+t2SzwBRnvY5o271AZo3joplnVB0
         j+vTcj8e0PRZM9qp4t5En6vPa2s5YlSvQ3FJD2qtsEXOUwye+cuKsswjBunFe1YlDMiO
         uqRhtgoShLV4CW90ws7hAopvd/I4gZDr3vW3+TxJk/aRqChRPSsN8iR/XiYg+k5ihvO7
         HoB47tbiFX1Dd6SHqxJh1bPT7RdrRUCP1cnVW9bX2Bs/+5IFceUdhoUKIGKtwC0NjVTU
         HaIwTQCc3bBXpu1NqGjX/yxqrKZE7YQwu46udbwbHg34pAqyVZy+FPrUskIkJDGBhwm0
         iRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wvH0NwxgEVjzQCtBvx9deQeGY1e94WvetRehSm7lPh8=;
        b=JgxKgSYgVGVoqIEXTGaoSHrKrflFQTfg8nbSD1MLBME0TKWvYCCQgXnu0fAYFWDnsE
         kItdAzkpPNKJ4ijjvol4ylJtYlKqpQYynATNGGlLosF/BDcrQYn+Z18xF0y2eUlk3nli
         s0MbTUqUysE9OkXPfPexMzYnF+AffwlfzB1pA+ELwFdcE0W3uF+7T5xMU5at8mLWb84a
         AN/tOc5DQshhaz8cUpFmRcg0O7ZT1y01uAbt6F9LsTh5fNsh9I/UjKQb1KdNN5Uh07XB
         Nweg+Q/15SsHIBB/dWEMiTSjyqhFpaxs/f8DMSE0UUamJcVKgchokJowjotn5KJH2TJ1
         wSyQ==
X-Gm-Message-State: AOAM532CQvRT0dhJ7h2Qunkhwv4rA1zFnU9Av857iyFO5c9ywJ59JJD9
        DBrqsmfrOBfixlw4wTqx4zrxj23uIPKKGA==
X-Google-Smtp-Source: ABdhPJwKw5n6428WJVe01b7mGkh2dewh1DNJEOXi/YkUPSPk+Uf6EEUnjGfoTeaRishkbxkF5eFJZA==
X-Received: by 2002:a5d:4705:: with SMTP id y5mr2278382wrq.313.1614332322711;
        Fri, 26 Feb 2021 01:38:42 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3483:8cf6:25ff:155b? (p200300ea8f395b0034838cf625ff155b.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3483:8cf6:25ff:155b])
        by smtp.googlemail.com with ESMTPSA id t15sm10960928wmi.48.2021.02.26.01.38.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Feb 2021 01:38:42 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
From:   Heiner Kallweit <hkallweit1@gmail.com>
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
 <b35ae75c-d0ce-2d29-b31a-72dc999a9bcc@gmail.com>
 <CABwr4_u5azaW8vRix-OtTUyUMRKZ3ncHwsou5MLC9w4F0WUsvg@mail.gmail.com>
 <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com>
Message-ID: <b3850776-d5f6-228c-64c2-436479546557@gmail.com>
Date:   Fri, 26 Feb 2021 10:38:33 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <c9e72b62-3b4e-6214-f807-b24ec506cb56@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.02.2021 10:32, Heiner Kallweit wrote:
> On 26.02.2021 10:10, Daniel González Cabanelas wrote:
>> El vie, 26 feb 2021 a las 8:13, Heiner Kallweit
>> (<hkallweit1@gmail.com>) escribió:
>>>
>>> On 25.02.2021 23:28, Daniel González Cabanelas wrote:
>>>> El jue, 25 feb 2021 a las 21:05, Heiner Kallweit
>>>> (<hkallweit1@gmail.com>) escribió:
>>>>>
>>>>> On 25.02.2021 17:36, Daniel González Cabanelas wrote:
>>>>>> El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
>>>>>> (<hkallweit1@gmail.com>) escribió:
>>>>>>>
>>>>>>> On 25.02.2021 00:54, Daniel González Cabanelas wrote:
>>>>>>>> El mié, 24 feb 2021 a las 23:01, Florian Fainelli
>>>>>>>> (<f.fainelli@gmail.com>) escribió:
>>>>>>>>>
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
>>>>>>>>>> On 24.02.2021 16:44, Daniel González Cabanelas wrote:
>>>>>>>>>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
>>>>>>>>>>> result of this it works in polling mode.
>>>>>>>>>>>
>>>>>>>>>>> Fix it using the phy_device structure to assign the platform IRQ.
>>>>>>>>>>>
>>>>>>>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
>>>>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
>>>>>>>>>>>
>>>>>>>>>>> After the patch:
>>>>>>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
>>>>>>>>>>>
>>>>>>>>>>> Pluging and uplugging the ethernet cable now generates interrupts and the
>>>>>>>>>>> PHY goes up and down as expected.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
>>>>>>>>>>> ---
>>>>>>>>>>> changes in V2:
>>>>>>>>>>>   - snippet moved after the mdiobus registration
>>>>>>>>>>>   - added missing brackets
>>>>>>>>>>>
>>>>>>>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>>>>>>>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>>>>> index fd876721316..dd218722560 100644
>>>>>>>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>>>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>>>>>>>>>>>               * if a slave is not present on hw */
>>>>>>>>>>>              bus->phy_mask = ~(1 << priv->phy_id);
>>>>>>>>>>>
>>>>>>>>>>> -            if (priv->has_phy_interrupt)
>>>>>>>>>>> +            ret = mdiobus_register(bus);
>>>>>>>>>>> +
>>>>>>>>>>> +            if (priv->has_phy_interrupt) {
>>>>>>>>>>> +                    phydev = mdiobus_get_phy(bus, priv->phy_id);
>>>>>>>>>>> +                    if (!phydev) {
>>>>>>>>>>> +                            dev_err(&dev->dev, "no PHY found\n");
>>>>>>>>>>> +                            goto out_unregister_mdio;
>>>>>>>>>>> +                    }
>>>>>>>>>>> +
>>>>>>>>>>>                      bus->irq[priv->phy_id] = priv->phy_interrupt;
>>>>>>>>>>> +                    phydev->irq = priv->phy_interrupt;
>>>>>>>>>>> +            }
>>>>>>>>>>>
>>>>>>>>>>> -            ret = mdiobus_register(bus);
>>>>>>>>>>
>>>>>>>>>> You shouldn't have to set phydev->irq, this is done by phy_device_create().
>>>>>>>>>> For this to work bus->irq[] needs to be set before calling mdiobus_register().
>>>>>>>>>
>>>>>>>>> Yes good point, and that is what the unchanged code does actually.
>>>>>>>>> Daniel, any idea why that is not working?
>>>>>>>>
>>>>>>>> Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
>>>>>>>> IRQ through phydev->irq works.
>>>>>>>>
>>>>>>>> I can resend the patch  without the bus->irq[] line since it's
>>>>>>>> pointless in this scenario.
>>>>>>>>
>>>>>>>
>>>>>>> It's still an ugly workaround and a proper root cause analysis should be done
>>>>>>> first. I can only imagine that phydev->irq is overwritten in phy_probe()
>>>>>>> because phy_drv_supports_irq() is false. Can you please check whether
>>>>>>> phydev->irq is properly set in phy_device_create(), and if yes, whether
>>>>>>> it's reset to PHY_POLL in phy_probe()?.
>>>>>>>
>>>>>>
>>>>>> Hi Heiner, I added some kernel prints:
>>>>>>
>>>>>> [    2.712519] libphy: Fixed MDIO Bus: probed
>>>>>> [    2.721969] =======phy_device_create===========
>>>>>> [    2.726841] phy_device_create: dev->irq = 17
>>>>>> [    2.726841]
>>>>>> [    2.832620] =======phy_probe===========
>>>>>> [    2.836846] phy_probe: phydev->irq = 17
>>>>>> [    2.840950] phy_probe: phy_drv_supports_irq = 0, phy_interrupt_is_valid = 1
>>>>>> [    2.848267] phy_probe: phydev->irq = -1
>>>>>> [    2.848267]
>>>>>> [    2.854059] =======phy_probe===========
>>>>>> [    2.858174] phy_probe: phydev->irq = -1
>>>>>> [    2.862253] phy_probe: phydev->irq = -1
>>>>>> [    2.862253]
>>>>>> [    2.868121] libphy: bcm63xx_enet MII bus: probed
>>>>>> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>>>>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>>>>>> irq=POLL)
>>>>>>
>>>>>> Currently using kernel 5.4.99. I still have no idea what's going on.
>>>>>>
>>>>> Thanks for debugging. This confirms my assumption that the interrupt
>>>>> is overwritten in phy_probe(). I'm just scratching my head how
>>>>> phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:
>>>>>
>>>>> static bool phy_drv_supports_irq(struct phy_driver *phydrv)
>>>>> {
>>>>>         return phydrv->config_intr && phydrv->ack_interrupt;
>>>>> }
>>>>>
>>>>> And that's the PHY driver:
>>>>>
>>>>> static struct phy_driver bcm63xx_driver[] = {
>>>>> {
>>>>>         .phy_id         = 0x00406000,
>>>>>         .phy_id_mask    = 0xfffffc00,
>>>>>         .name           = "Broadcom BCM63XX (1)",
>>>>>         /* PHY_BASIC_FEATURES */
>>>>>         .flags          = PHY_IS_INTERNAL,
>>>>>         .config_init    = bcm63xx_config_init,
>>>>>         .ack_interrupt  = bcm_phy_ack_intr,
>>>>>         .config_intr    = bcm63xx_config_intr,
>>>>> }
>>>>>
>>>>> So both callbacks are set. Can you extend your debugging and check
>>>>> in phy_drv_supports_irq() which of the callbacks is missing?
>>>>>
>>>>
>>>> Hi, both callbacks are missing on the first check. However on the next
>>>> calls they're there.
>>>>
>>>> [    2.263909] libphy: Fixed MDIO Bus: probed
>>>> [    2.273026] =======phy_device_create===========
>>>> [    2.277908] phy_device_create: dev->irq = 17
>>>> [    2.277908]
>>>> [    2.373104] =======phy_probe===========
>>>> [    2.377336] phy_probe: phydev->irq = 17
>>>> [    2.381445] phy_drv_supports_irq: phydrv->config_intr = 0,
>>>> phydrv->ack_interrupt = 0
>>>> [    2.389554] phydev->irq = PHY_POLL;
>>>> [    2.393186] phy_probe: phydev->irq = -1
>>>> [    2.393186]
>>>> [    2.398987] =======phy_probe===========
>>>> [    2.403108] phy_probe: phydev->irq = -1
>>>> [    2.407195] phy_drv_supports_irq: phydrv->config_intr = 1,
>>>> phydrv->ack_interrupt = 1
>>>> [    2.415314] phy_probe: phydev->irq = -1
>>>> [    2.415314]
>>>> [    2.421189] libphy: bcm63xx_enet MII bus: probed
>>>> [    2.426129] =======phy_connect===========
>>>> [    2.430410] phy_drv_supports_irq: phydrv->config_intr = 1,
>>>> phydrv->ack_interrupt = 1
>>>> [    2.438537] phy_connect: phy_drv_supports_irq = 1
>>>> [    2.438537]
>>>> [    2.445284] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>>>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>>>> irq=POLL)
>>>>
>>>
>>> I'd like to understand why the phy_device is probed twice,
>>> with which drivers it's probed.
>>> Could you please add printing phydrv->name to phy_probe() ?
>>>
>>
>> Hi Heiner, indeed there are two different probed devices. The B53
>> switch driver is causing this issue.
>>
>> [    2.269595] libphy: Fixed MDIO Bus: probed
>> [    2.278706] =======phy_device_create===========
>> [    2.283594] phy_device_create: dev->irq = 17
>> [    2.283594]
>> [    2.379554] =======phy_probe===========
>> [    2.383780] phy_probe: phydrv->name = Broadcom B53 (3)
> 
> Is this an out-of-tree driver? I can't find this string in any
> DSA or PHY driver.
> 

I found this PHY driver name in an older patch set that obviously
didn't make it into mainline:
https://patchwork.ozlabs.org/project/netdev/patch/1424799727-30946-1-git-send-email-zajec5@gmail.com/

Any yes, if you use this patch set then you have conflicting
PHY drivers. How about using the in-tree B53 DSA driver?

> 
>> [    2.389235] phy_probe: phydev->irq = 17
>> [    2.393332] phy_drv_supports_irq: phydrv->config_intr = 0,
>> phydrv->ack_interrupt = 0
>> [    2.401445] phydev->irq = PHY_POLL
>> [    2.405080] phy_probe: phydev->irq = -1
>> [    2.405080]
>> [    2.410878] =======phy_probe===========
>> [    2.414996] phy_probe: phydrv->name = Broadcom BCM63XX (1)
>> [    2.420791] phy_probe: phydev->irq = -1
>> [    2.424876] phy_drv_supports_irq: phydrv->config_intr = 1,
>> phydrv->ack_interrupt = 1
>> [    2.432994] phy_probe: phydev->irq = -1
>> [    2.432994]
>> [    2.438862] libphy: bcm63xx_enet MII bus: probed
>> [    2.443809] =======phy_connect===========
>> [    2.448092] phy_drv_supports_irq: phydrv->config_intr = 1,
>> phydrv->ack_interrupt = 1
>> [    2.456215] phy_connect: phy_drv_supports_irq = 1
>> [    2.456215]
>> [    2.462961] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>> irq=POLL)
>>
>> The board has no switch, it's a driver for other boards in OpenWrt. I
>> forgot it wasn't upstreamed:
>> https://github.com/openwrt/openwrt/tree/master/target/linux/generic/files/drivers/net/phy/b53
>>
>> I tested a kernel compiled without this driver, now the IRQ is
>> detected as it should be:
>>
>> [    2.270707] libphy: Fixed MDIO Bus: probed
>> [    2.279715] =======phy_device_create===========
>> [    2.284600] phy_device_create: dev->irq = 17
>> [    2.284600]
>> [    2.373763] =======phy_probe===========
>> [    2.377989] phy_probe: phydrv->name = Broadcom BCM63XX (1)
>> [    2.383803] phy_probe: phydev->irq = 17
>> [    2.387888] phy_drv_supports_irq: phydrv->config_intr = 1,
>> phydrv->ack_interrupt = 1
>> [    2.396007] phy_probe: phydev->irq = 17
>> [    2.396007]
>> [    2.401877] libphy: bcm63xx_enet MII bus: probed
>> [    2.406820] =======phy_connect===========
>> [    2.411099] phy_drv_supports_irq: phydrv->config_intr = 1,
>> phydrv->ack_interrupt = 1
>> [    2.419226] phy_connect: phy_drv_supports_irq = 1
>> [    2.419226]
>> [    2.429857] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
>> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
>> irq=17)
>>
>> Then, maybe this is an OpenWrt bug itself?
>>
>> Regards
>> Daniel
>>
>>>
>>>> I also added the prints to phy_connect.
>>>>
>>>>> Last but not least: Do you use a mainline kernel, or is it maybe
>>>>> a modified downstream kernel? In the latter case, please check
>>>>> in your kernel sources whether both callbacks are set.
>>>>>
>>>>
>>>> It's a modified kernel, and the the callbacks are set. BTW I also
>>>> tested the kernel with no patches concerning to the ethernet driver.
>>>>
>>>> Regards,
>>>> Daniel
>>>>
>>>>>
>>>>>
>>>>>>> On which kernel version do you face this problem?
>>>>>>>
>>>>>> The kernel version 4.4 works ok. The minimum version where I found the
>>>>>> problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.
>>>>>>
>>>>>> Regards
>>>>>> Daniel
>>>>>>
>>>>>>>> Regards
>>>>>>>>> --
>>>>>>>>> Florian
>>>>>>>
>>>>>
>>>
> 

