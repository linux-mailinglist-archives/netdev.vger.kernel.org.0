Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4481F324613
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 23:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236233AbhBXWC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 17:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236220AbhBXWCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 17:02:22 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C781C061574
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 14:01:42 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id v200so2252652pfc.0
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 14:01:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fx9q6ciZ7u/M4eg60rJosmaQVprWhitphBVAvHKAkcM=;
        b=JcKSDXw8Ls5NhHtgARFmC74WMDgUft03VNH/xFeRSyBgwtI1yYTM8eM03P8307ai9P
         6+YWu+rWRXIZw3iNyNgYCJJKSX3rucS2EwaFDyU0QYMgxnP7hC1G3UHyhW/qF4jIkqd3
         ftQkMWlYltaNVSg082PmFXKI5uvaWhmTWrI1Wzy6vztIC30wld/0tUAf71wGaFXhCZLk
         ISsyf0MXDvDTVA/55i/k5Fqx/DXYmq63Yg6PM2Ed9JnsIywkjVsAfeF0GdS1AJOVb4ti
         C4zo9g0Iujfj8yNapfdJ0UzwwxmZYxwCXrY0GZ7gN15Vk5V2VrBs6NsX2/n3e7DTRlk5
         FQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fx9q6ciZ7u/M4eg60rJosmaQVprWhitphBVAvHKAkcM=;
        b=PwhLhp/BpRsx66SpgbT1Bj41N6Z0ENZbSSAjKog02IMBWs+uVBdMOZa0Z+wYyoaKJr
         XCD1A3xNThuQemqLjJmrnvT8gxT9BWQbmOEyfcWcVxMOkCIS7P6qFW4ufo3YgNrD05p7
         0Lojv45UjXV9V0dy2BdV1O+B/ISxp/P6KPZiNQ5Z5+yp2+WzuV+U5BZkTsAeXNvyQ5Sj
         q/JeHsez91uNESIIIJ7WPSxvo0ckLk4ye4dp6GLzZx2kqGTfPFh68AUgIXYRh2hQgXxa
         G1bcK7n0W44Iuc0EwMGiuRQSuZX8+zBUq24KXwElqdlx/Q0L9EN/jC4FxqQ/wyPg2BgC
         ZDPQ==
X-Gm-Message-State: AOAM533JtVTM0mkg2DUPGRcpeYf7fXC7buu+mRHg2Y3TDH4Rf8ztW82P
        M5v/oLPA0xI5DnGdxYlqSzQ=
X-Google-Smtp-Source: ABdhPJzAUIfRPig0CbA8CMJr7EpI5R/muKVDXg/G7XC/RUa3hAjJrLv6jQZ6gPIvOdesT5m+YPo73g==
X-Received: by 2002:a62:cf05:0:b029:1ed:62f7:f6c5 with SMTP id b5-20020a62cf050000b02901ed62f7f6c5mr63364pfg.43.1614204100712;
        Wed, 24 Feb 2021 14:01:40 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v123sm2353887pfc.63.2021.02.24.14.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Feb 2021 14:01:40 -0800 (PST)
Subject: Re: [PATCH v2] bcm63xx_enet: fix internal phy IRQ assignment
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?Q?Daniel_Gonz=c3=a1lez_Cabanelas?= <dgcbueu@gmail.com>,
        davem@davemloft.net
Cc:     kuba@kernel.org, gregkh@linuxfoundation.org,
        netdev@vger.kernel.org, noltari@gmail.com
References: <2323124.5UR7tLNZLG@tool>
 <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cf8ea0b6-11ac-3dbd-29a1-337c06d9a991@gmail.com>
Date:   Wed, 24 Feb 2021 14:01:38 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <9d9f3077-9c5c-e7bc-0c77-8e8353be7732@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/24/2021 1:44 PM, Heiner Kallweit wrote:
> On 24.02.2021 16:44, Daniel González Cabanelas wrote:
>> The current bcm63xx_enet driver doesn't asign the internal phy IRQ. As a
>> result of this it works in polling mode.
>>
>> Fix it using the phy_device structure to assign the platform IRQ.
>>
>> Tested under a BCM6348 board. Kernel dmesg before the patch:
>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=POLL)
>>
>> After the patch:
>>    Broadcom BCM63XX (1) bcm63xx_enet-0:01: attached PHY driver [Broadcom
>>               BCM63XX (1)] (mii_bus:phy_addr=bcm63xx_enet-0:01, irq=17)
>>
>> Pluging and uplugging the ethernet cable now generates interrupts and the
>> PHY goes up and down as expected.
>>
>> Signed-off-by: Daniel González Cabanelas <dgcbueu@gmail.com>
>> ---
>> changes in V2: 
>>   - snippet moved after the mdiobus registration
>>   - added missing brackets
>>
>>  drivers/net/ethernet/broadcom/bcm63xx_enet.c | 13 +++++++++++--
>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>> index fd876721316..dd218722560 100644
>> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
>> @@ -1818,10 +1818,19 @@ static int bcm_enet_probe(struct platform_device *pdev)
>>  		 * if a slave is not present on hw */
>>  		bus->phy_mask = ~(1 << priv->phy_id);
>>  
>> -		if (priv->has_phy_interrupt)
>> +		ret = mdiobus_register(bus);
>> +
>> +		if (priv->has_phy_interrupt) {
>> +			phydev = mdiobus_get_phy(bus, priv->phy_id);
>> +			if (!phydev) {
>> +				dev_err(&dev->dev, "no PHY found\n");
>> +				goto out_unregister_mdio;
>> +			}
>> +
>>  			bus->irq[priv->phy_id] = priv->phy_interrupt;
>> +			phydev->irq = priv->phy_interrupt;
>> +		}
>>  
>> -		ret = mdiobus_register(bus);
> 
> You shouldn't have to set phydev->irq, this is done by phy_device_create().
> For this to work bus->irq[] needs to be set before calling mdiobus_register().

Yes good point, and that is what the unchanged code does actually.
Daniel, any idea why that is not working?
-- 
Florian
