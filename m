Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7CB325746
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 21:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233866AbhBYUGK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 15:06:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232403AbhBYUF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 15:05:58 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38EDDC061756
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:05:18 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e10so6239782wro.12
        for <netdev@vger.kernel.org>; Thu, 25 Feb 2021 12:05:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u53AKuuGPQ1MT+gg0CiavQ8xjrangqWYPqK8oHjadPQ=;
        b=f7PV3zR5wYm1EpHIRdUM+/pQkJboq9tgPAdVsvJtnGNXEaVIy6ugWG8nV1y8KdlkN/
         8o2yIHyoBxidsBwuiLDxCi3l++6Te+rQZ/mNDCvI9ylUi+Mj9Yn39jIVdHN2fUunWqxP
         7HeN33XV5K5xNccNtFe9vrOS/P2S9lJtwvLNZI6dolkw7Rj+sCXD1BQ6RQxvJDyPvt54
         /9CLsL6DGUDOMWZGFobp1xXjXDW+qK2M27Rk1ZxlpwVWNqDa+/6SHFwJ08SHZletMoRw
         9lRmzvL5Y8B0R1ipB+3HTm2VqENmJ1jP/Lc1OaPAQrus0TMwtZdlJKVPgBCRaHx+21ye
         5EGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u53AKuuGPQ1MT+gg0CiavQ8xjrangqWYPqK8oHjadPQ=;
        b=AVr433nBmO1MJYnr0o2M1kjnXlGMavohcyd0qKzjApGFvVn724pjl6KtsOQ3IHGdK9
         Z8n/HBuxv2HnHj/1QUKSSklwWvzldSdpRTeXyO9Y8f6zl/aLVSbl3dYl/6mtDfHJsgbs
         jMFQBm+//drR2IpAlQMDMr00cBwBYXqlS+qVxFicyw10QLzQde4AF5DavsmlAF7t10XC
         s14k11092fxhOy6nzwgawUu0BpWD67cqgzk6YSkYQhnYH8iK1tDQPYUEJ6/n33JRZujk
         L1+y/ZcTwHy1yq1qGg1Wf+TGvn2b2fb6pqPSMX35olBPZm46BSx0EG/K9PuuvBWpiZhk
         K/ug==
X-Gm-Message-State: AOAM530aszU5SLgCdCkjDW8orfPYXtDViU8fUjm2XCJWLQYYw1tqSvUA
        Gdp4hjkAqNOPjYFnNy3j354=
X-Google-Smtp-Source: ABdhPJz0Isbggjzc/RPV10rh8YrDlxHiNtaXjVVyqBMh221JqelyWgiXvkCNgJTjB5jHDtR1xk2PWQ==
X-Received: by 2002:a5d:4cd1:: with SMTP id c17mr4081978wrt.168.1614283516874;
        Thu, 25 Feb 2021 12:05:16 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:3596:71e6:32b6:12b7? (p200300ea8f395b00359671e632b612b7.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:3596:71e6:32b6:12b7])
        by smtp.googlemail.com with ESMTPSA id h17sm9339931wrt.74.2021.02.25.12.05.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Feb 2021 12:05:16 -0800 (PST)
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <7fc4933f-36d4-99dc-f968-9ca3b8758a9b@gmail.com>
Date:   Thu, 25 Feb 2021 21:05:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CABwr4_s6Y8OoeGNiPK8XpnduMsv3Sv3_mx_UcoGq=9vza6L2Ew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2021 17:36, Daniel González Cabanelas wrote:
> El jue, 25 feb 2021 a las 8:22, Heiner Kallweit
> (<hkallweit1@gmail.com>) escribió:
>>
>> On 25.02.2021 00:54, Daniel González Cabanelas wrote:
>>> El mié, 24 feb 2021 a las 23:01, Florian Fainelli
>>> (<f.fainelli@gmail.com>) escribió:
>>>>
>>>>
>>>>
>>>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
>>>>> On 24.02.2021 16:44, Daniel González Cabanelas wrote:
>>>>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
>>>>>> result of this it works in polling mode.
>>>>>>
>>>>>> Fix it using the phy_device structure to assign the platform IRQ.
>>>>>>
>>>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
>>>>>>
>>>>>> After the patch:
>>>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
>>>>>>
>>>>>> Pluging and uplugging the ethernet cable now generates interrupts and the
>>>>>> PHY goes up and down as expected.
>>>>>>
>>>>>> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
>>>>>> ---
>>>>>> changes in V2:
>>>>>>   - snippet moved after the mdiobus registration
>>>>>>   - added missing brackets
>>>>>>
>>>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>>>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>> index fd876721316..dd218722560 100644
>>>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>>>>>>               * if a slave is not present on hw */
>>>>>>              bus->phy_mask = ~(1 << priv->phy_id);
>>>>>>
>>>>>> -            if (priv->has_phy_interrupt)
>>>>>> +            ret = mdiobus_register(bus);
>>>>>> +
>>>>>> +            if (priv->has_phy_interrupt) {
>>>>>> +                    phydev = mdiobus_get_phy(bus, priv->phy_id);
>>>>>> +                    if (!phydev) {
>>>>>> +                            dev_err(&dev->dev, "no PHY found\n");
>>>>>> +                            goto out_unregister_mdio;
>>>>>> +                    }
>>>>>> +
>>>>>>                      bus->irq[priv->phy_id] = priv->phy_interrupt;
>>>>>> +                    phydev->irq = priv->phy_interrupt;
>>>>>> +            }
>>>>>>
>>>>>> -            ret = mdiobus_register(bus);
>>>>>
>>>>> You shouldn't have to set phydev->irq, this is done by phy_device_create().
>>>>> For this to work bus->irq[] needs to be set before calling mdiobus_register().
>>>>
>>>> Yes good point, and that is what the unchanged code does actually.
>>>> Daniel, any idea why that is not working?
>>>
>>> Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
>>> IRQ through phydev->irq works.
>>>
>>> I can resend the patch  without the bus->irq[] line since it's
>>> pointless in this scenario.
>>>
>>
>> It's still an ugly workaround and a proper root cause analysis should be done
>> first. I can only imagine that phydev->irq is overwritten in phy_probe()
>> because phy_drv_supports_irq() is false. Can you please check whether
>> phydev->irq is properly set in phy_device_create(), and if yes, whether
>> it's reset to PHY_POLL in phy_probe()?.
>>
> 
> Hi Heiner, I added some kernel prints:
> 
> [    2.712519] libphy: Fixed MDIO Bus: probed
> [    2.721969] =======phy_device_create===========
> [    2.726841] phy_device_create: dev->irq = 17
> [    2.726841]
> [    2.832620] =======phy_probe===========
> [    2.836846] phy_probe: phydev->irq = 17
> [    2.840950] phy_probe: phy_drv_supports_irq = 0, phy_interrupt_is_valid = 1
> [    2.848267] phy_probe: phydev->irq = -1
> [    2.848267]
> [    2.854059] =======phy_probe===========
> [    2.858174] phy_probe: phydev->irq = -1
> [    2.862253] phy_probe: phydev->irq = -1
> [    2.862253]
> [    2.868121] libphy: bcm63xx_enet MII bus: probed
> [    2.873320] Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY
> driver [Broadcom BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01,
> irq=POLL)
> 
> Currently using kernel 5.4.99. I still have no idea what's going on.
> 
Thanks for debugging. This confirms my assumption that the interrupt
is overwritten in phy_probe(). I'm just scratching my head how
phy_drv_supports_irq() can return 0. In 5.4.99 it's defined as:

static bool phy_drv_supports_irq(struct phy_driver *phydrv)
{
	return phydrv->config_intr && phydrv->ack_interrupt;
}

And that's the PHY driver:

static struct phy_driver bcm63xx_driver[] = {
{
	.phy_id		= 0x00406000,
	.phy_id_mask	= 0xfffffc00,
	.name		= "Broadcom BCM63XX (1)",
	/* PHY_BASIC_FEATURES */
	.flags		= PHY_IS_INTERNAL,
	.config_init	= bcm63xx_config_init,
	.ack_interrupt	= bcm_phy_ack_intr,
	.config_intr	= bcm63xx_config_intr,
}

So both callbacks are set. Can you extend your debugging and check
in phy_drv_supports_irq() which of the callbacks is missing?

Last but not least: Do you use a mainline kernel, or is it maybe
a modified downstream kernel? In the latter case, please check
in your kernel sources whether both callbacks are set.



>> On which kernel version do you face this problem?
>>
> The kernel version 4.4 works ok. The minimum version where I found the
> problem were the kernel 4.9.111, now using 5.4. And 5.10 also tested.
> 
> Regards
> Daniel
> 
>>> Regards
>>>> --
>>>> Florian
>>

