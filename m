Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB2E68A9A3
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 12:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbjBDLY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 06:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbjBDLY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 06:24:57 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD08425E2C;
        Sat,  4 Feb 2023 03:24:54 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qw12so22037243ejc.2;
        Sat, 04 Feb 2023 03:24:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s8ZNP49MMz6UAlnK2nUtyzIpJAk5VKQ60tAan71UO1Q=;
        b=cZxzxQp51aFyZTk0TfTdJTIiL0BjvpBLsjyAi1PQaHbx+itHbPGvwX33ixOL9XL6jv
         XjZaGmWLqLyljInIjWGuqnJ8j+FtSpeSOrze4SBT68lVFewn1trPiWgdAlADhFy1Zcg/
         s1ssk84KQo7woNJUf0ixkMX2bs0ACW290N8KiFD951WjPzE7I/U101fyBhtzSYktnnzn
         Goh6MQdjzDcmEGjf+hC9xfpW5rezlmdvpf5z87EYh42GBIqU8/2NlOgL0FJtNUsbgZrY
         PIDeBSqx8LO1WyIirhzYwWqkgcSWh1qRuy8Hb6KAeb5NCxLE0Z3PLWSW2IaJFRAzGFKI
         kZcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8ZNP49MMz6UAlnK2nUtyzIpJAk5VKQ60tAan71UO1Q=;
        b=4gHz6yumWrWWOouFc+GXVrI2gbC22KDLli1trh5xjCxoBVQYH0S5xW78HhIUlwacOD
         SO8p2yq3rQjXMEoFt4yYUFcjBSVjpyZ9DrecSVkilLmqTee9JeFJCwWsdYW8p9lQcb72
         rHed9C6VwrSAEQOyIvzK0FE+0bDOVQZvghfgxYgKxDafhqo1e5EB/QTNW88QI5UkJQxo
         1AILx+SnQeIIxgLXYmFyAa20E6SLQt4U0hUHfamY2i63KApEkfCngVP1z24q+YTyvSNl
         Z0jdCYCEK8RBPo7S16rWAVBWw9KLES+Ka8e+xwh3kwr0TXRLmQWjwONfnJcu4i9SDxCu
         zMPw==
X-Gm-Message-State: AO0yUKUY17IxfkJeJ2XxYrjrUBzLqKbcy524um4bSUS0j8KLqEynDuFN
        O8Dwbs43MF81VKaV/O0JqPk=
X-Google-Smtp-Source: AK7set+fOQikTcotfkU0ysBTia5SDqXYjwAPY9I3A9Bn/oNV95yiaVl6/edL4cOc0HlV+kZzdhtbCA==
X-Received: by 2002:a17:906:cf83:b0:878:5f35:b8d6 with SMTP id um3-20020a170906cf8300b008785f35b8d6mr13313431ejb.51.1675509893187;
        Sat, 04 Feb 2023 03:24:53 -0800 (PST)
Received: from ?IPV6:2a01:c22:7af5:0:151f:7ce:1913:daa6? (dynamic-2a01-0c22-7af5-0000-151f-07ce-1913-daa6.c22.pool.telefonica.de. [2a01:c22:7af5:0:151f:7ce:1913:daa6])
        by smtp.googlemail.com with ESMTPSA id gz22-20020a170906f2d600b0088f88d1d36bsm2679676ejb.166.2023.02.04.03.24.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 04 Feb 2023 03:24:52 -0800 (PST)
Message-ID: <5559d368-c647-5b82-f633-b5cef8a34932@gmail.com>
Date:   Sat, 4 Feb 2023 12:24:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, linux@armlinux.org.uk, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        michael@walle.cc
References: <20230203122542.436305-1-horatiu.vultur@microchip.com>
 <0f81d14d-50cb-b807-b103-8fa066d0769c@gmail.com>
 <20230203151059.k5aa6zihibgsedcw@soft-dev3-1>
 <0280ecbc-06e4-72ce-95f8-17217833c19f@gmail.com>
 <20230204101235.7fk4jqditdjrqegp@soft-dev3-1>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
In-Reply-To: <20230204101235.7fk4jqditdjrqegp@soft-dev3-1>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.02.2023 11:12, Horatiu Vultur wrote:
> The 02/03/2023 22:57, Heiner Kallweit wrote:
>>
>> On 03.02.2023 16:10, Horatiu Vultur wrote:
>>> The 02/03/2023 14:55, Heiner Kallweit wrote:
>>>
>>> Hi Heiner,
>>>
>>>>
>>>> On 03.02.2023 13:25, Horatiu Vultur wrote:
>>>
>>> ...
>>>
>>>>> +
>>>>> +#define LAN8841_OUTPUT_CTRL                  25
>>>>> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER               BIT(14)
>>>>> +#define LAN8841_CTRL                         31
>>>>> +#define LAN8841_CTRL_INTR_POLARITY           BIT(14)
>>>>> +static int lan8841_config_intr(struct phy_device *phydev)
>>>>> +{
>>>>> +     struct irq_data *irq_data;
>>>>> +     int temp = 0;
>>>>> +
>>>>> +     irq_data = irq_get_irq_data(phydev->irq);
>>>>> +     if (!irq_data)
>>>>> +             return 0;
>>>>> +
>>>>> +     if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
>>>>> +             /* Change polarity of the interrupt */
>>>>
>>>> Why this a little bit esoteric logic? Can't you set the interrupt
>>>> to level-low in the chip (like most other ones), and then define
>>>> the polarity the usual way e.g. in DT?
>>>
>>> To set the interrupt to level-low it needs to be set to open-drain and
>>> in that case I can't use the polarity register, because doesn't have any
>>> effect on the interrupt. So I can't set the interrupt to level low and
>>> then use the polarity to select if it is high or low.
>>> That is the reason why I have these checks.
>>>
>> To me this still doesn't look right. After checking the datasheet I'd say:
>> At first open-drain should be preferred because only in this mode the
>> interrupt line can be shared.
> 
> Agree.
> 
>> And if you use level-low and open-drain, why would you want to fiddle
>> with the polarity?
> 
> In this case, I don't fiddle with the polarity. That case is on the else
> branch of this if condition. I play with the polarity only when using
> push-pull.
> 
>> Level-low and open-drain is the only mode supported by
>> most PHY's and it's totally fine.
>>
>> Or do you have a special use case where
>> you want to connect the interrupt pin to an interrupt controller that
>> only supports level-high and has no programmable inverter in its path?
> 
> I have two cases:
> 1. When lan966x is connected to this lan8841. In this case the interrupt
> controller supports both level-low and level-high. But in this case I
> can test only the level-low.
> 
> 2. When lan7431 is connected to this lan8841 and using x86. If I
> remember correctly (I don't have the setup to test it anymore and will
> take a some time to get it again) this worked only with level-high
> interrupts. To get this working I had some changes in the lan7431 driver
> to enable interrupts from the external PHY.
> 
Looking at the datasheet for LAN7431 (document AN2948, page 76) in register
GPIO_WAKE you can configure the polarity for the PHY interrupt (to be exact,
for all GPIO-triggered interrupts).
Therefore level-low should be fine also with LAN7431.

GPIO Polarity 0-11 (GPIOPOL[11:0])
When clear, the pin functions as a GPIO.
0 = Wakeup/interrupt is triggered when GPIO is driven low.
1 = Wakeup/interrupt is triggered when GPIO is driven high

> Maybe a better approach would be for now, just to set the interrupt to
> open-drain in the lan8841. And only when I add the changes to lan7431
> also add the changes to lan8841 to support level-high interrupts if it
> is still needed.
> 
Agree.

>>
>>>>
>>>>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
>>>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER,
>>>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER);
>>>>> +             phy_modify(phydev, LAN8841_CTRL,
>>>>> +                        LAN8841_CTRL_INTR_POLARITY,
>>>>> +                        LAN8841_CTRL_INTR_POLARITY);
>>>>> +     } else {
>>>>> +             /* It is enough to set INT buffer to open-drain because then
>>>>> +              * the interrupt will be active low.
>>>>> +              */
>>>>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
>>>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
>>>>> +     }
>>>>> +
>>>>> +     /* enable / disable interrupts */
>>>>> +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>>>>> +             temp = LAN8814_INT_LINK;
>>>>> +
>>>>> +     return phy_write(phydev, LAN8814_INTC, temp);
>>>>> +}
>>>>> +
>>>>> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
>>>>> +{
>>>>> +     int irq_status;
>>>>> +
>>>>> +     irq_status = phy_read(phydev, LAN8814_INTS);
>>>>> +     if (irq_status < 0) {
>>>>> +             phy_error(phydev);
>>>>> +             return IRQ_NONE;
>>>>> +     }
>>>>> +
>>>>> +     if (irq_status & LAN8814_INT_LINK) {
>>>>> +             phy_trigger_machine(phydev);
>>>>> +             return IRQ_HANDLED;
>>>>> +     }
>>>>> +
>>>>> +     return IRQ_NONE;
>>>>> +}
>>>>> +
>>>
>>
> 

