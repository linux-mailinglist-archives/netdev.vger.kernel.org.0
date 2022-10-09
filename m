Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D085F8C3B
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 18:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiJIQPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 12:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiJIQPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 12:15:14 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C516824F22
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 09:15:11 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id z30so5531688qkz.13
        for <netdev@vger.kernel.org>; Sun, 09 Oct 2022 09:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MPuV4OxPJUlg/BenC0+lIzHK/2HLlqgu9oU374zZOXM=;
        b=n2X21I8kPzZAtcmp9X3n+Y4+1f2hEhVp45W/+u+SfiSdDPIrzPdo8tKmumjC006hiT
         /6bRekPOhFejZksOhvlv7REfPJ4mEQv2vE92tMNeTv7mt9fMONiH0w/oHnfRbTZNBfn9
         mmjUcZESuTCJftjhq8q2Sst1x9QV8E1LSlFLZMJkCjiL+LgguiMUKYBoVEiswWm07+hP
         Q7+j+IZI9XBRpBu/vg4BK022bmgS9LLsyEBKPKavUtXyqDod0KDs9aDgvFBzP6VG3IQd
         n2PKsPSvatShT2BXAtvyLTrSicR5UtQ9U+Wrsjl0Y2/AhqsfldKiu4nZ2yHrRwOeYYWl
         aPow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MPuV4OxPJUlg/BenC0+lIzHK/2HLlqgu9oU374zZOXM=;
        b=da+jivyLkAUQKnTLJP80zwfdTaK8K/DT697EWi2fGzF/+4YLV7jEOVBzcJ5us1nSM5
         3c+XAFm1xDTu8q8yFE60/ylStZJs/3te90mTAYZPxrWAXGbdYPnc80y2wyprAfB30KPr
         gl/8XkhtX92uavhkjRTUVzDN3JuX2SiMrTQoXUhUt2SVXvYn6paMDwwuYAETfkZuAHIt
         pwfljKnaRPB3L4KbPPEVTX2YE10SIafkMFOC828+lZB7RvbrxckalEZYNVXi4j47vdNE
         s9I4fCDXtmAHoFQ96Dk0a6nWqclzgvtrfEKrdS22xpk/fyCjRbL7M40rUt1dKG/iegj2
         axRA==
X-Gm-Message-State: ACrzQf1WfNwChHhxkZVxqPWiuFOJoYkh3ZzXK9/zkXkMmz2/pjFoy1wN
        ggSZdCZHC5yd2E8V/6kPZCdYWQ==
X-Google-Smtp-Source: AMsMyM5294O4SSjjoEqkQLO/lrBvUllt3Wz9tSaV2Bm/EG7Y7Eh6sn98z098vDU0Z8CBSj4JW5gmgQ==
X-Received: by 2002:a05:620a:6082:b0:6cf:f086:a70f with SMTP id dx2-20020a05620a608200b006cff086a70fmr10131303qkb.324.1665332110933;
        Sun, 09 Oct 2022 09:15:10 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id bn35-20020a05620a2ae300b006ce60296f97sm7531742qkb.68.2022.10.09.09.15.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Oct 2022 09:15:10 -0700 (PDT)
Message-ID: <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
Date:   Sun, 9 Oct 2022 12:14:22 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v3 net-next 12/14] dt-bindings: net: dsa: ocelot: add
 ocelot-ext documentation
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Colin Foster <colin.foster@in-advantage.com>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Lee Jones <lee@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <20220926002928.2744638-1-colin.foster@in-advantage.com>
 <20220926002928.2744638-13-colin.foster@in-advantage.com>
 <ec63b5aa-3dec-3c27-e987-25e36b1632ba@linaro.org>
 <YzzLCYHmTcrHbZcH@colin-ia-desktop>
 <455e31be-dc87-39b3-c7fe-22384959c556@linaro.org>
 <Yz2mSOXf68S16Xg/@colin-ia-desktop>
 <28b4d9f9-f41a-deca-aa61-26fb65dcc873@linaro.org>
 <20221008000014.vs2m3vei5la2r2nd@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221008000014.vs2m3vei5la2r2nd@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/10/2022 02:00, Vladimir Oltean wrote:
> On Wed, Oct 05, 2022 at 06:09:59PM +0200, Krzysztof Kozlowski wrote:
>>>> I don't understand how your answer relates to "reg=<0 0>;". How is it
>>>> going to become 0x71010000 if there is no other reg/ranges set in parent
>>>> nodes. The node has only one IO address, but you say the switch has 20
>>>> addresses...
>>>>
>>>> Are we talking about same hardware?
>>>
>>> Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
>>> depending on what capabilities it is to have. In the 7514 they are all
>>> memory-mapped from the device tree. While the 7512 does need these
>>> regmaps, they are managed by the MFD, not the device tree. So there
>>> isn't a _need_ for them to be here, since at the end of the day they're
>>> ignored.
>>>
>>> The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
>>> understand that isn't desired. So moving forward I'll add all the
>>> regmaps back into the device tree.
>>
>> You need to describe the hardware. If hardware has IO address space, how
>> does it matter that some driver needs or needs not something?
> 
> What do you mean by IO address space exactly? It is a SPI device with registers.
> Does that constitute an IO address space to you?

By IO I meant MMIO (or similar) which resides in reg (thus in unit
address). The SPI devices have only chip-select as reg, AFAIR.

> 
> The driver need matters because you don't usually see DT nodes of SPI,
> I2C, MDIO devices describing the address space of their registers, and
> having child nodes with unit addresses in that address space. Only when
> those devices are so complex that the need arises to identify smaller
> building blocks is when you will end up needing that. And this is an
> implementation detail which shapes how the dt-bindings will look like.

So probably I misunderstood here. If this is I2C or SPI device, then of
course reg and unit address do not represent registers.

> 
>> You mentioned that address space is mapped to regmaps. Regmap is Linux
>> specific implementation detail, so this does not answer at all about
>> hardware.
>>
>> On the other hand, if your DTS design requires this is a child of
>> something else and by itself it does not have address space, it would be
>> understandable to skip unit address entirely... but so far it is still
>> confusing, especially that you use arguments related to implementation
>> to justify the DTS.
> 
> If Colin skips the unit address entirely, then how could he distinguish
> between the otherwise identical MDIO controllers mdio@7107009c and
> mdio@710700c0 from Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml?
> The ethernet-switch node added here is on the same hierarchical level
> with the MDIO controller nodes, so it must have a unit address just like
> them.

So what is @710700c0? It's not chip-select, but MMIO or some other bus
(specific to the device), right?

The mscc,ocelot.yaml has a soc@0 SPI device. Children of soc@0 use unit
addresses/reg meaningful for that soc@0.

> 
> But I don't support Colin's choice of "reg=<0 0>;" either. A choice must
> be made between 2 options:
> - mapping all 20 regions of the SPI address space into "reg" values
> - mapping a single region from the smallest until the largest address of
>   those 20, and hope nothing overlaps with some other peripheral, or
>   worse, that this region will never need to be expanded to the left.

Yeah, at least to my limited knowledge of this hardware.


> What information do you need to provide some best practices that can be
> applied here and are more useful than "you need to describe the
> hardware"? 

Describe the hardware properties in terms of it fit in to the whole
system - so some inputs (clocks, GPIOs), outputs (interrupts),
characteristics of a device (e.g. clock provider -> clock cells) and
properties configuring hardware per specific implementation.

But mostly this argument "describe hardware" should be understood like:
do not describe software (Linux drivers) and software policies (driver
choices)...

> Verilog/VHDL is what the hardware description that's
> independent of software implementation is, good luck parsing that.

Best regards,
Krzysztof

