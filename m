Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F12675244
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 11:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjATKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 05:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbjATKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 05:22:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA9CB54B16
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:22:15 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id h12so404773wrv.10
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 02:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TBagG8EDIuu/uJXoc6X7ZZCA35pdkVUcKYnIkIKOggQ=;
        b=pLnd75gP08DHfUkSbA51dfoqrnIo/hGqzDYVkvy+zGYyngqyyUYSz0UvctcHM6VhkR
         Jh585Q7i7ol9+4wW1/P5UBerr7g+6jGWdDoOeLmNeqpNQ5cs43o4N5E0TXaCAdr57tMH
         pqSg8qiQQg35WvrIuiOm5B75R6HfOQ1n8+VXYcF+9vzLBzaaPyIS8VBA7HYor47Ml+3M
         HU6BH5+0BKa9MG+zs9Vx9giNS/L0qCjNNt2RrVF+T20F/ZctaIJess1vzR1F6riSNpyJ
         hEgtgfC5qWcRj3yT8uNpyESn2FtIjvuh3ofyYe5TVI/QP0nFYx465ysOU6G9ljq6E7XI
         NwFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TBagG8EDIuu/uJXoc6X7ZZCA35pdkVUcKYnIkIKOggQ=;
        b=6t8y2PgN3Bkawf96pBKFRkddI4aiyqmt3HSeMeWtzodcxIC8+wYyVcyL+oTl3BR6yD
         JG2KJ9NfEWFbMLuu22+5jvLkQQ9Fh+eR3IKFtoR+T4hhVapJT13U+gLbJBtvEQ6ihQom
         UewqSuYbwQ5ctwUmXyfjrjQFCNqKeI+1gIfRjqNZE15igGMV4J9WUhAdLqrsfJFo0llH
         T24K2vXBEuPgwba1V3mgCdDVS65qR1x9iuRLh+Cs7P8A7bACI95ddJTJqskiBfRFRsR3
         u8yHA1S4mvOkcpEvYQA8tTi59TQ5OX/DU/gHrN6phhfJmez82iKzNwx/KgH5jDWou/SH
         hzKg==
X-Gm-Message-State: AFqh2krYxexvhjJQMy8DgMX8xP4cB2gz2tfQUbU9/xJ2xL8/Kp9rP0Lo
        y8iOUUVPRaajQvmRruV/uT8=
X-Google-Smtp-Source: AMrXdXvISUk8cNPjNkmZunP8YzkcogqSIh6BS8mjoKUYD/dVIALPmjJr0tO/9uEer01FFqoWBWKksA==
X-Received: by 2002:adf:f10b:0:b0:2bd:e215:4372 with SMTP id r11-20020adff10b000000b002bde2154372mr11044719wro.20.1674210134267;
        Fri, 20 Jan 2023 02:22:14 -0800 (PST)
Received: from ?IPV6:2a01:c23:bc41:e300:8963:d1f4:1cd7:2821? (dynamic-2a01-0c23-bc41-e300-8963-d1f4-1cd7-2821.c23.pool.telefonica.de. [2a01:c23:bc41:e300:8963:d1f4:1cd7:2821])
        by smtp.googlemail.com with ESMTPSA id e11-20020a5d6d0b000000b002bdda9856b5sm2190835wrq.50.2023.01.20.02.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 02:22:13 -0800 (PST)
Message-ID: <eef8668d-a1f1-7b5d-1a15-ebf3a00d1e4b@gmail.com>
Date:   Fri, 20 Jan 2023 11:22:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] net: phy: meson-gxl: support more G12A-internal
 PHY versions
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc:     Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hilman <khilman@baylibre.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "open list:ARM/Amlogic Meson..." <linux-amlogic@lists.infradead.org>
References: <d75ef7df-a645-7fdd-491a-f89f70dbea01@gmail.com>
 <Y8Qwk5H8Yd7qiN0j@lunn.ch> <03ea260e-f03c-d9d7-6f5f-ff72836f5739@gmail.com>
 <51abd8ca-8172-edfa-1c18-b1e48231f316@linaro.org>
 <6de25c61-c187-fb88-5bd7-477b1db1510e@gmail.com>
 <e75ed56f-ba25-f337-e879-33cc2a784740@gmail.com>
 <1jo7qtwm1z.fsf@starbuckisacylon.baylibre.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <1jo7qtwm1z.fsf@starbuckisacylon.baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.01.2023 11:01, Jerome Brunet wrote:
> 
> On Thu 19 Jan 2023 at 23:42, Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>> On 15.01.2023 21:38, Heiner Kallweit wrote:
>>> On 15.01.2023 19:43, Neil Armstrong wrote:
>>>> Hi Heiner,
>>>>
>>>> Le 15/01/2023 à 18:09, Heiner Kallweit a écrit :
>>>>> On 15.01.2023 17:57, Andrew Lunn wrote:
>>>>>> On Sun, Jan 15, 2023 at 04:19:37PM +0100, Heiner Kallweit wrote:
>>>>>>> On my SC2-based system the genphy driver was used because the PHY
>>>>>>> identifies as 0x01803300. It works normal with the meson g12a
>>>>>>> driver after this change.
>>>>>>> Switch to PHY_ID_MATCH_MODEL to cover the different sub-versions.
>>>>>>
>>>>>> Hi Heiner
>>>>>>
>>>>>> Are there any datasheets for these devices? Anything which documents
>>>>>> the lower nibble really is a revision?
>>>>>>
>>>>>> I'm just trying to avoid future problems where we find it is actually
>>>>>> a different PHY, needs its own MATCH_EXACT entry, and then we find we
>>>>>> break devices using 0x01803302 which we had no idea exists, but got
>>>>>> covered by this change.
>>>>>>
>>>>> The SC2 platform inherited a lot from G12A, therefore it's plausible
>>>>> that it's the same PHY. Also the vendor driver for SC2 gives a hint
>>>>> as it has the following compatible for the PHY:
>>>>>
>>>>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>>>>
>>>>> But you're right, I can't say for sure as I don't have the datasheets.
>>>>
>>>> On G12A (& GXL), the PHY ID is set in the MDIO MUX registers,
>>>> please see:
>>>> https://elixir.bootlin.com/linux/latest/source/drivers/net/mdio/mdio-mux-meson-g12a.c#L36
>>>>
>>>> So you should either add support for the PHY mux in SC2 or check
>>>> what is in the ETH_PHY_CNTL0 register.
>>>>
>>> Thanks for the hint. I just checked and reading back ETH_PHY_CNTL0 at the
>>> end of g12a_enable_internal_mdio() gives me the expected result of 0x33010180.
>>> But still the PHY reports 3300.
>>> Even if I write some other random value to ETH_PHY_CNTL0, I get 0180/3300
>>> as PHY ID.
>>>
>>> For u-boot I found the following:
>>>
>>> https://github.com/khadas/u-boot/blob/khadas-vim4-r-64bit/drivers/net/phy/amlogic.c
>>>
>>> static struct phy_driver amlogic_internal_driver = {
>>> 	.name = "Meson GXL Internal PHY",
>>> 	.uid = 0x01803300,
>>> 	.mask = 0xfffffff0,
>>> 	.features = PHY_BASIC_FEATURES,
>>> 	.config = &meson_phy_config,
>>> 	.startup = &meson_aml_startup,
>>> 	.shutdown = &genphy_shutdown,
>>> };
>>>
>>> So it's the same PHY ID I'm seeing in Linux.
>>>
>>> My best guess is that the following is the case:
>>>
>>> The PHY compatible string in DT is the following in all cases:
>>> compatible = "ethernet-phy-id0180.3301", "ethernet-phy-ieee802.3-c22";
>>>
>>> Therefore id 0180/3301 is used even if the PHY reports something else.
>>> Means it doesn't matter which value you write to ETH_PHY_CNTL0.
>>>
>>> I reduced the compatible string to compatible = "ethernet-phy-ieee802.3-c22"
>>> and this resulted in the actual PHY ID being used.
>>> You could change the compatible in dts the same way for any g12a system
>>> and I assume you would get 0180/3300 too.
>>>
>>> Remaining question is why the value in ETH_PHY_CNTL0 is ignored.
>>>
>>
>> I think I found what's going on. The PHY ID written to SoC register
>> ETH_PHY_CNTL0 isn't effective immediately. It takes a PHY soft reset before
>> it reports the new PHY ID. Would be good to have a comment in the
>> g12a mdio mux code mentioning this constraint.
>>
>> I see no easy way to trigger a soft reset early enough. Therefore it's indeed
>> the simplest option to specify the new PHY ID in the compatible.
> 
> This is because (I guess) the PHY only picks ups the ID from the glue
> when it powers up. After that the values are ignored.
> 
I tested and a PHY soft reset is also sufficient to pick up the new PHY ID.
Supposedly everything executing the soft reset logic is sufficient:
power-up, soft reset, coming out of suspend/power-down


> Remember the PHY is a "bought" IP, the glue/mux provides the input
> settings required by the PHY provider.
> 
> Best would be to trigger an HW reset of PHY from glue after setting the
> register ETH_PHY_CNTL0.
> 
> Maybe this patch could help : ?
> https://gitlab.com/jbrunet/linux/-/commit/ccbb07b0c9eb2de26818eb4f8aa1fd0e5b31e6db.patch
> 
Thanks for the hint, I'll look at it and test.

> I tried this when we debugged the connectivity issue on the g12 earlier
> this spring. I did not send it because the problem was found to be in
> stmmac.
> 

