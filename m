Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACF2D6A278A
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 07:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbjBYGcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 01:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBYGcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 01:32:12 -0500
Received: from mail-oa1-x29.google.com (mail-oa1-x29.google.com [IPv6:2001:4860:4864:20::29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51F514DE06;
        Fri, 24 Feb 2023 22:32:11 -0800 (PST)
Received: by mail-oa1-x29.google.com with SMTP id 586e51a60fabf-17264e9b575so2009358fac.9;
        Fri, 24 Feb 2023 22:32:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=rj/Z2DJPgHEc3Mgn3wl9ji4nnLLd9teQTaSKkfDKeSU=;
        b=D0yVEN8UCIgMTfUU8jBfozM+bZwnzVRldajUSzYaFEJh+cpWQiBBBEoRTHTHxPxGOJ
         pHUZx6mDR8grCQQqWXZtAsUrm+jX5oJG3h8jkr6SFAymN9dlY/feP7S122RzxQjN/uNe
         9SXWH6mRSy+wim2mCN6HzGWww/we3iYQ6kxfpmNg6T7fYd4eO2irlxmIQdTWqDCLdaUw
         a9fplMmS+yUj17/yk4yx+5AI+lOCS0ofnWaEgpD9/nm0g/Xoa4yLt0CYQoC/rsSImI2H
         IhtuuraFsjW7ksawgizV6yXcu7BAQYM8RaRHQXdylzeync7ya++XuixpkhweZ1N3JSL5
         +uQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rj/Z2DJPgHEc3Mgn3wl9ji4nnLLd9teQTaSKkfDKeSU=;
        b=u452ceydxLWS0cSHWjhE74LN8SKMezxRjZmo1JhyKa/WOaWf2cb7i7nmp8U6V8NraW
         bFHRi6GTpE8WdfOQEp03ADwxd+s7PcIK+OAzaoG5qJ4Tbyn2VfPTcTT67svqwSqboiyM
         Z6mPkbxEZ68dvkvwrPYm+XaETN9I/7C+S2OJwYk88yY8hqrA9hIWneSmQfMY6lh9T4CZ
         pY1nH9Ljn61hooMds7jQq31mGn0iShjtRpiHr+wDzQ3QfPmsDJCndGEn7CDzCStNeRnT
         +iilR47xxghSoX2vvGdd5q1wJGLfLfWJ9FC8DPqUNMpsApZNKw2a6eGxK1X8/Z6LKo8w
         yYJw==
X-Gm-Message-State: AO0yUKWnJwgisP3j47Rjuyx5Ho71IvprdSMri/G++I1oiqd1PUDdL+YH
        dH74w07tgN6IppZ6aAwyGRw=
X-Google-Smtp-Source: AK7set+ylsRIuUfNZSk0GzT4MPe3emyTOu4xzmnXiT4qLjCe15XJ5uoiBAJt/kjd1pUYtPbn9C1NIw==
X-Received: by 2002:a05:6870:1686:b0:16e:8e37:cf08 with SMTP id j6-20020a056870168600b0016e8e37cf08mr17472130oae.35.1677306730619;
        Fri, 24 Feb 2023 22:32:10 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id t2-20020a9d7742000000b0068d59d15a93sm353044otl.40.2023.02.24.22.32.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 22:32:09 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <9173a7a6-5531-6b41-1fb8-a8eb4b8c5d2c@roeck-us.net>
Date:   Fri, 24 Feb 2023 22:32:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v8 6/9] net: phy: c22: migrate to
 genphy_c45_write_eee_adv()
Content-Language: en-US
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Arun.Ramadoss@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Wei Fang <wei.fang@nxp.com>,
        kernel@pengutronix.de, intel-wired-lan@lists.osuosl.org,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20230224035553.GA1089605@roeck-us.net>
 <20230224041604.GA1353778@roeck-us.net>
 <20230224045340.GN19238@pengutronix.de>
 <363517fc-d16e-5bcd-763d-fc0e32c2301a@roeck-us.net>
 <20230224165213.GO19238@pengutronix.de>
 <20230224174132.GA1224969@roeck-us.net>
 <20230224183646.GA26307@pengutronix.de>
 <b0af4518-3c07-726e-79a0-19c53f799204@roeck-us.net>
 <20230224200207.GA8437@pengutronix.de>
 <52f8bb78-0913-6e9a-7816-f32cdad688f2@roeck-us.net>
 <20230225060812.GB8437@pengutronix.de>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230225060812.GB8437@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 22:08, Oleksij Rempel wrote:
> On Fri, Feb 24, 2023 at 04:09:40PM -0800, Guenter Roeck wrote:
>> On 2/24/23 12:02, Oleksij Rempel wrote:
>> [ ... ]
>>>>
>>>> For cubieboard:
>>>>
>>>> MDIO_PCS_EEE_ABLE = 0x0000
>>>>
>>>> qemu reports attempts to access unsupported registers.
>>>>
>>>> I had a look at the Allwinner mdio driver. There is no indication suggesting
>>>> what the real hardware would return when trying to access unsupported registers,
>>>> and the Ethernet controller datasheet is not public.
>>>
>>> These are PHY accesses over MDIO bus. Ethernet controller should not
>>> care about content of this operations. But on qemu side, it is implemented as
>>> part of Ethernet controller emulation...
>>>
>>> Since MDIO_PCS_EEE_ABLE == 0x0000, phydev->supported_eee should prevent
>>> other EEE related operations. But may be actual phy_read_mmd() went
>>> wrong. It is a combination of simple phy_read/write to different
>>> registers.
>>>
>>
>> Adding MDD read/write support in qemu doesn't help. Something else in your patch
>> prevents the PHY from coming up. After reverting your patch, I see
>>
>> sun4i-emac 1c0b000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
>> IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>>
>> in the log. This is missing with your patch in place.
>>
>> Anyway, the key difference is not really the qemu emulation, but the added
>> unconditional call to genphy_c45_write_eee_adv() in your patch. If you look
>> closely into that function, you may notice that the 'changed' variable is
>> never set to 0.
>>
>> diff --git a/drivers/net/phy/phy-c45.c b/drivers/net/phy/phy-c45.c
>> index 3813b86689d0..fee514b96ab1 100644
>> --- a/drivers/net/phy/phy-c45.c
>> +++ b/drivers/net/phy/phy-c45.c
>> @@ -672,7 +672,7 @@ EXPORT_SYMBOL_GPL(genphy_c45_read_mdix);
>>    */
>>   int genphy_c45_write_eee_adv(struct phy_device *phydev, unsigned long *adv)
>>   {
>> -       int val, changed;
>> +       int val, changed = 0;
>>
>>          if (linkmode_intersects(phydev->supported_eee, PHY_EEE_CAP1_FEATURES)) {
>>                  val = linkmode_to_mii_eee_cap1_t(adv);
>>
>> fixes the problem, both for cubieboard and xtensa.
> 
> Good point! Thx for finding it!
> 
> Do you wont to send the fix against net?

No, please go ahead and do it.

Guenter

