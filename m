Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9AA68A511
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjBCV5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233871AbjBCV51 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:57:27 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD33A7EF8;
        Fri,  3 Feb 2023 13:57:25 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id mf7so19083057ejc.6;
        Fri, 03 Feb 2023 13:57:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZbiQWezooZRSt6r8DDWWFl9mmk/VlSQDjHwWr+T1yMk=;
        b=Br8Oo+F5E8Kh4RXz0OhQ1lyEI6jRG5ULhDYfncSliLviO7PE4ADbRh0xRaxgjWKHSP
         sUxBHpM4mGo9ahVYpm6t4iJ1WA7ui2I2OzuDxdpw7dJpeIlGqxT8dWC1jqzjnp4CQpsI
         Qo1re6zkWHaVfBtrqxaCmDiLp0gnvaEoFtCXWFiuS6q65Z10V9oIOtCDscoNeZCKXUr7
         nBihcy2fu59GS+VOLPY2eGkTao8DxUKo8trX37MO3xLhG9v/cmaj9fWzBtUfJf/INmp0
         nFvgKYPdyGtmlrhOpc1czT9K+blNovzh2ZP6lEXwTL+H8kWI6lPd4KRI6lQoLAJwjJs3
         pmHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZbiQWezooZRSt6r8DDWWFl9mmk/VlSQDjHwWr+T1yMk=;
        b=np4dKVh6ddIO606Pi5wegGFOhtviwHkDDwiPf/tSoLtsRM/LVorBaZcP4U+78s1yeR
         pHo3MY3IQZXEw1vU0cewcEmpGt/8GNJBi/kAORw5MBFzjMQKFtD5vVR+KkuYAbXYgkQ1
         a/N6nF8u6stbCXLzRlHCmK5W9hNEOzdTLX7BicGJ2AgeAp36vog6E8rEgUkWLmRvmN0I
         fLZD7uVSgKBlnCRtcVElmx6WYszW6vfIz2bhwp731Qp/8QBDoK/B3PR7tk2NqKTsKBq+
         tWCBtge8oS/AoWixHmzNN8Xnb9SZTol3Rymw9q7q0b6z8gHyuHFqbdPzV0t7JzjldFXv
         n8WA==
X-Gm-Message-State: AO0yUKW/E7JjBUEwFGaGqZLo9yuRrn3+3hpFXRoM7ehiL6lz06mfQakw
        cHwsfZxL5JTgg4nkUxHH0Ps=
X-Google-Smtp-Source: AK7set88yVtzXOcecILDBp6qpw3yW+T1P9ZG2ttsMArCyTrXTSR15PcPZj45rLwgQOhWlOF2fsu5ug==
X-Received: by 2002:a17:906:184a:b0:871:d59d:4f54 with SMTP id w10-20020a170906184a00b00871d59d4f54mr11872154eje.27.1675461443735;
        Fri, 03 Feb 2023 13:57:23 -0800 (PST)
Received: from ?IPV6:2a01:c23:b81c:5800:95fd:ccbf:6c44:23f7? (dynamic-2a01-0c23-b81c-5800-95fd-ccbf-6c44-23f7.c23.pool.telefonica.de. [2a01:c23:b81c:5800:95fd:ccbf:6c44:23f7])
        by smtp.googlemail.com with ESMTPSA id ot17-20020a170906ccd100b0088272bac7c5sm1918236ejb.121.2023.02.03.13.57.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 13:57:23 -0800 (PST)
Message-ID: <0280ecbc-06e4-72ce-95f8-17217833c19f@gmail.com>
Date:   Fri, 3 Feb 2023 22:57:22 +0100
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
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v2] net: micrel: Add support for lan8841 PHY
In-Reply-To: <20230203151059.k5aa6zihibgsedcw@soft-dev3-1>
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

On 03.02.2023 16:10, Horatiu Vultur wrote:
> The 02/03/2023 14:55, Heiner Kallweit wrote:
> 
> Hi Heiner,
> 
>>
>> On 03.02.2023 13:25, Horatiu Vultur wrote:
> 
> ...
> 
>>> +
>>> +#define LAN8841_OUTPUT_CTRL                  25
>>> +#define LAN8841_OUTPUT_CTRL_INT_BUFFER               BIT(14)
>>> +#define LAN8841_CTRL                         31
>>> +#define LAN8841_CTRL_INTR_POLARITY           BIT(14)
>>> +static int lan8841_config_intr(struct phy_device *phydev)
>>> +{
>>> +     struct irq_data *irq_data;
>>> +     int temp = 0;
>>> +
>>> +     irq_data = irq_get_irq_data(phydev->irq);
>>> +     if (!irq_data)
>>> +             return 0;
>>> +
>>> +     if (irqd_get_trigger_type(irq_data) & IRQ_TYPE_LEVEL_HIGH) {
>>> +             /* Change polarity of the interrupt */
>>
>> Why this a little bit esoteric logic? Can't you set the interrupt
>> to level-low in the chip (like most other ones), and then define
>> the polarity the usual way e.g. in DT?
> 
> To set the interrupt to level-low it needs to be set to open-drain and
> in that case I can't use the polarity register, because doesn't have any
> effect on the interrupt. So I can't set the interrupt to level low and
> then use the polarity to select if it is high or low.
> That is the reason why I have these checks.
> 
To me this still doesn't look right. After checking the datasheet I'd say:
At first open-drain should be preferred because only in this mode the
interrupt line can be shared.
And if you use level-low and open-drain, why would you want to fiddle
with the polarity? Level-low and open-drain is the only mode supported by
most PHY's and it's totally fine. Or do you have a special use case where
you want to connect the interrupt pin to an interrupt controller that
only supports level-high and has no programmable inverter in its path?

>>
>>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER,
>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER);
>>> +             phy_modify(phydev, LAN8841_CTRL,
>>> +                        LAN8841_CTRL_INTR_POLARITY,
>>> +                        LAN8841_CTRL_INTR_POLARITY);
>>> +     } else {
>>> +             /* It is enough to set INT buffer to open-drain because then
>>> +              * the interrupt will be active low.
>>> +              */
>>> +             phy_modify(phydev, LAN8841_OUTPUT_CTRL,
>>> +                        LAN8841_OUTPUT_CTRL_INT_BUFFER, 0);
>>> +     }
>>> +
>>> +     /* enable / disable interrupts */
>>> +     if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
>>> +             temp = LAN8814_INT_LINK;
>>> +
>>> +     return phy_write(phydev, LAN8814_INTC, temp);
>>> +}
>>> +
>>> +static irqreturn_t lan8841_handle_interrupt(struct phy_device *phydev)
>>> +{
>>> +     int irq_status;
>>> +
>>> +     irq_status = phy_read(phydev, LAN8814_INTS);
>>> +     if (irq_status < 0) {
>>> +             phy_error(phydev);
>>> +             return IRQ_NONE;
>>> +     }
>>> +
>>> +     if (irq_status & LAN8814_INT_LINK) {
>>> +             phy_trigger_machine(phydev);
>>> +             return IRQ_HANDLED;
>>> +     }
>>> +
>>> +     return IRQ_NONE;
>>> +}
>>> +
> 

