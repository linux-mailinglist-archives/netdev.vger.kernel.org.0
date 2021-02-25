Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1F9324B2A
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 08:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbhBYHXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 02:23:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232164AbhBYHXO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 02:23:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4863DC06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 23:22:34 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id do6so7088628ejc.3
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 23:22:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WQ9hYkwfqmzmm3d35YtKNEVq1rZky5VpFVIChutRwa0=;
        b=oe6ZTsFiivn+NHFeWkKS1eF0OLyUkh4a8vSjM266A2Sn2Y/6DJkWkYvfbrENTKe1nW
         ehvqRxrMaxhb0SS/arBemmtKClIRJGLuQaZvXFABTyw0D1dfa51Yo2//LuriZPcnEiLr
         47gZ6DXfFNEV5xiHyOWqeMFTC2RlqjPPTMPFICDOfFK0Ny7Zo+ayUik64yH5BVuRdGNb
         go09zAqabR62KekzyRGClIVopIOAPDiOxxlu1BmU6YXygel3jX7I+PjwsMdlJgqjchSC
         sIUil0Ywj0BtWDgH0zBprwl6AnvxMrsbwhwYaU5hljdQZjGWGFuOlWzVX3yOVugZt4BX
         t+MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WQ9hYkwfqmzmm3d35YtKNEVq1rZky5VpFVIChutRwa0=;
        b=XUata32WTYpbQ5w77vrlBlPSefaJL/B1FnypWIuCgIZU1S/LdLEasIL8ed+tgFmKs8
         LCC3ua+H6jmoYOd06PNezSWRF8x/6SFWl4Albjo4IyaWPT0A+W5TUFHAIa4sPuq0zPzd
         tdQXTD07qxH/18ulN+J/Rpv6K8dfNkiXzjy99Zhu/Pbr4ggpqNrqxqlsLjQkImGyfHbq
         hpJiIQnRWFuABaoxiYeXR3FbzwOUd+fnul30fwac/sQKcrzoSZC2aEvO6POuu78XhWrN
         XDWawxxmFrwq8AtgFtpGfVNE/LDiY/DD4/e73Ap4qqj6y4p8qXu6+yYsq+t3FOf2R4Hz
         pOYg==
X-Gm-Message-State: AOAM531GwmtIIJ1o797uVIvrI+1eZdJ4FVdJqdNMMAZtHYeWf5MKoYzu
        Pz/NmwpcXGrKraDOyTHe3Jw=
X-Google-Smtp-Source: ABdhPJz44qJthY9hOrTh6N+AJoDcB1Jl18BT9YImqNs7ZWNRkucbmwlUY5LVVdaXCiHqhX7MazF+lQ==
X-Received: by 2002:a17:906:c007:: with SMTP id e7mr1440820ejz.518.1614237751701;
        Wed, 24 Feb 2021 23:22:31 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:886:d78e:2ad2:a5bf? (p200300ea8f395b000886d78e2ad2a5bf.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:886:d78e:2ad2:a5bf])
        by smtp.googlemail.com with ESMTPSA id m7sm2528244ejk.52.2021.02.24.23.22.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 23:22:31 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org,
        =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>
References: <2323124.5UR7tLNZLG@tool>
 <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
 <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com>
 <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <0e75a5c3-f6bd-6039-3cfd-8708da963d20@gmail.com>
Date:   Thu, 25 Feb 2021 08:22:22 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CABwr4_vwTiFzSdxu-GoON2HHS1pjyiv0PFS-pTbCEMT4Uc4OvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2021 00:54, Daniel González Cabanelas wrote:
> El mié, 24 feb 2021 a las 23:01, Florian Fainelli
> (<f.fainelli@gmail.com>) escribió:
>>
>>
>>
>> On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
>>> On 24.02.2021 16:44, Daniel González Cabanelas wrote:
>>>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
>>>> result of this it works in polling mode.
>>>>
>>>> Fix it using the phy_device structure to assign the platform IRQ.
>>>>
>>>> Tested under a BCM6348 board. Kernel dmesg before the patch:
>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
>>>>
>>>> After the patch:
>>>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
>>>>
>>>> Pluging and uplugging the ethernet cable now generates interrupts and the
>>>> PHY goes up and down as expected.
>>>>
>>>> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
>>>> ---
>>>> changes in V2:
>>>>   - snippet moved after the mdiobus registration
>>>>   - added missing brackets
>>>>
>>>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>>>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>> index fd876721316..dd218722560 100644
>>>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>>>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>>>>               * if a slave is not present on hw */
>>>>              bus->phy_mask = ~(1 << priv->phy_id);
>>>>
>>>> -            if (priv->has_phy_interrupt)
>>>> +            ret = mdiobus_register(bus);
>>>> +
>>>> +            if (priv->has_phy_interrupt) {
>>>> +                    phydev = mdiobus_get_phy(bus, priv->phy_id);
>>>> +                    if (!phydev) {
>>>> +                            dev_err(&dev->dev, "no PHY found\n");
>>>> +                            goto out_unregister_mdio;
>>>> +                    }
>>>> +
>>>>                      bus->irq[priv->phy_id] = priv->phy_interrupt;
>>>> +                    phydev->irq = priv->phy_interrupt;
>>>> +            }
>>>>
>>>> -            ret = mdiobus_register(bus);
>>>
>>> You shouldn't have to set phydev->irq, this is done by phy_device_create().
>>> For this to work bus->irq[] needs to be set before calling mdiobus_register().
>>
>> Yes good point, and that is what the unchanged code does actually.
>> Daniel, any idea why that is not working?
> 
> Hi Florian, I don't know. bus->irq[] has no effect, only assigning the
> IRQ through phydev->irq works.
> 
> I can resend the patch  without the bus->irq[] line since it's
> pointless in this scenario.
> 

It's still an ugly workaround and a proper root cause analysis should be done
first. I can only imagine that phydev->irq is overwritten in phy_probe()
because phy_drv_supports_irq() is false. Can you please check whether
phydev->irq is properly set in phy_device_create(), and if yes, whether
it's reset to PHY_POLL in phy_probe()?.

On which kernel version do you face this problem?

> Regards
>> --
>> Florian

