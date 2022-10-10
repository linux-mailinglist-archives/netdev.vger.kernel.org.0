Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 597E95F9F83
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiJJNhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 09:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiJJNhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 09:37:32 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEB65D0D5
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:37:27 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id w28so4489441qtv.9
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 06:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vkuK5BKe2xjQkr/RcXbg8y9N+ayQn7NQBCiNKHV/VJ4=;
        b=Cc9dsYY3Ns5gpbAsjA9eoNHsK/PdkfsTRAQYm4d7Yxa28pltyytcsPDOyAbjEb4Vfy
         fV9CvxhHZ+QohzNZCH40PwvqEKQpZ/DBQHFHR2r+NsS1/GU9rCLfuGykRtsjkBYpittF
         4sUiieWnV2SpWKMy/6umjJ1sx6XQH88UXKtgi4jhNTsr2YrNTdoEEqIvteHJk/AnIvbe
         Se1g7yK7eKDoyaUJ6zXRjsTMJMDKqmAoe8A2dVsbVTpITeHV7bDerqUzdhU0uMzAXucq
         BWT6u7k1zoX21YeXr1VSSo3FEKteHLUx8EL2micF0LUjCBuK6DUIj1UM7AobCdNRbqas
         p4lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vkuK5BKe2xjQkr/RcXbg8y9N+ayQn7NQBCiNKHV/VJ4=;
        b=LRxqED/JWTMlT76Dd/rky8hr2En3g1ZLI4doea26QIVKSak1hJ+1mS1kk9EurHFG3A
         JhsJaeNSnXH8xt9PslTkWHohgehCzyyqCXD3ptM6m1QoXeqbqAqIzjhn5qK+M/5pwsTR
         Xum+wYsNPRjH4p+0IKs9RAzmo+hDPz7XaAuqRcgUUec1Ce2IYwuHehKbLFY57ZdvD1AF
         Jf6ze7wP03/2ucfGZ8zp+qPsxtK7vLfXDfHvyeUQryGk1iEgsEyNA3yxYGYt2ksmBAQj
         Uatj1QAwkzqytJqfnjDi0jkW1YveqZi64Nhb1kwrPzQbR9ksVAzkYc1NSf0SuqUdg41R
         5e5Q==
X-Gm-Message-State: ACrzQf3SndH+YI+8146nxfmcnsKEczBbZ8BkBzSjZEvF60VqPPZ8Z1Fd
        0k8qjXbhvbMwrjzklL7L5NvY3w==
X-Google-Smtp-Source: AMsMyM5B2PMSgTHUQeRVmWgnVQAXgXXfhmXI03btwQHLLUhnuKk8abdqNAj1w+SE3UvwJDKnlBB8eA==
X-Received: by 2002:ac8:580d:0:b0:35c:3fcc:2442 with SMTP id g13-20020ac8580d000000b0035c3fcc2442mr14849984qtg.501.1665409046788;
        Mon, 10 Oct 2022 06:37:26 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id x14-20020a05620a448e00b006b949afa980sm10390657qkp.56.2022.10.10.06.37.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 06:37:26 -0700 (PDT)
Message-ID: <d27d7740-bf35-b8d4-d68c-bb133513fa19@linaro.org>
Date:   Mon, 10 Oct 2022 09:37:23 -0400
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
 <c9ce1d83-d1ca-4640-bba2-724e18e6e56b@linaro.org>
 <20221010130707.6z63hsl43ipd5run@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221010130707.6z63hsl43ipd5run@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/10/2022 09:07, Vladimir Oltean wrote:
> On Sun, Oct 09, 2022 at 12:14:22PM -0400, Krzysztof Kozlowski wrote:
>> On 08/10/2022 02:00, Vladimir Oltean wrote:
>>> On Wed, Oct 05, 2022 at 06:09:59PM +0200, Krzysztof Kozlowski wrote:
>>>>>> I don't understand how your answer relates to "reg=<0 0>;". How is it
>>>>>> going to become 0x71010000 if there is no other reg/ranges set in parent
>>>>>> nodes. The node has only one IO address, but you say the switch has 20
>>>>>> addresses...
>>>>>>
>>>>>> Are we talking about same hardware?
>>>>>
>>>>> Yes. The switch driver for both the VSC7512 and VSC7514 use up to ~20 regmaps
>>>>> depending on what capabilities it is to have. In the 7514 they are all
>>>>> memory-mapped from the device tree. While the 7512 does need these
>>>>> regmaps, they are managed by the MFD, not the device tree. So there
>>>>> isn't a _need_ for them to be here, since at the end of the day they're
>>>>> ignored.
>>>>>
>>>>> The "reg=<0 0>;" was my attempt to indicate that they are ignored, but I
>>>>> understand that isn't desired. So moving forward I'll add all the
>>>>> regmaps back into the device tree.
>>>>
>>>> You need to describe the hardware. If hardware has IO address space, how
>>>> does it matter that some driver needs or needs not something?
>>>
>>> What do you mean by IO address space exactly? It is a SPI device with registers.
>>> Does that constitute an IO address space to you?
>>
>> By IO I meant MMIO (or similar) which resides in reg (thus in unit
>> address). The SPI devices have only chip-select as reg, AFAIR.
> 
> Again, the SPI device (soc@0) has a unit address that describes the chip
> select, yes. The children of the SPI device have a unit address that
> describes the address space of the SPI registers of the mini-peripherals
> within that SPI device.
> 
>>> The driver need matters because you don't usually see DT nodes of SPI,
>>> I2C, MDIO devices describing the address space of their registers, and
>>> having child nodes with unit addresses in that address space. Only when
>>> those devices are so complex that the need arises to identify smaller
>>> building blocks is when you will end up needing that. And this is an
>>> implementation detail which shapes how the dt-bindings will look like.
>>
>> So probably I misunderstood here. If this is I2C or SPI device, then of
>> course reg and unit address do not represent registers.
> 
> Except we're not talking about the SPI device, I'm reminding you that we
> are talking about "reg = <0 0>" which Colin used to describe the
> /spi/soc@0/ethernet-switch node.
> 
> Colin made the incorrect decision to describe "reg = <0 0>" for the
> switch OF node in an attempt to point out that "reg" will *not* be used
> by his implementation, whatever value it has. You may want to revisit
> some of the things that were said.
> 
> What *is* used in the implementation is the array of resources from
> struct mfd_cell vsc7512_devs[] in drivers/mfd/ocelot-core.c, because MFD
> allows you to do this (and I suppose because it is more convenient than
> to rely on the DT). Colin's entire confusion comes from the fact that he
> thought it wouldn't be necessary to describe the unit addresses of MFD
> children if those addresses won't be retrieved from DT.
> 
>>>> You mentioned that address space is mapped to regmaps. Regmap is Linux
>>>> specific implementation detail, so this does not answer at all about
>>>> hardware.
>>>>
>>>> On the other hand, if your DTS design requires this is a child of
>>>> something else and by itself it does not have address space, it would be
>>>> understandable to skip unit address entirely... but so far it is still
>>>> confusing, especially that you use arguments related to implementation
>>>> to justify the DTS.
>>>
>>> If Colin skips the unit address entirely, then how could he distinguish
>>> between the otherwise identical MDIO controllers mdio@7107009c and
>>> mdio@710700c0 from Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml?
>>> The ethernet-switch node added here is on the same hierarchical level
>>> with the MDIO controller nodes, so it must have a unit address just like
>>> them.
>>
>> So what is @710700c0?
> 
> @710700c0 is VSC7512_MIIM1_RES_START, i.e. the base address of the
> second MDIO controller embedded within the SoC (accessed over whatever;
> SPI or MMIO).
> 
>> It's not chip-select, but MMIO or some other bus (specific to the
>> device), right?
> 
> Yes, it is not chip select. Think of the /spi/soc@0 node as an AHB to
> SPI bridge (it is possibly not quite that, but for the sake of imagination
> it's a good enough description), and the children of /spi/soc@0 are
> nodes whose registers are accessed through that AHB to SPI bridge.
> The same addresses can also be accessed via direct MMIO by the processor
> *inside* the switch SoC, which in some cases can also run Linux
> (although not here in VSC7512, but in VSC7514).
> 
>> The mscc,ocelot.yaml has a soc@0 SPI device. Children of soc@0 use unit
>> addresses/reg meaningful for that soc@0.
> 
> Which they do.
> 
>>> But I don't support Colin's choice of "reg=<0 0>;" either. A choice must
>>> be made between 2 options:
>>> - mapping all 20 regions of the SPI address space into "reg" values
>>> - mapping a single region from the smallest until the largest address of
>>>   those 20, and hope nothing overlaps with some other peripheral, or
>>>   worse, that this region will never need to be expanded to the left.
>>
>> Yeah, at least to my limited knowledge of this hardware.
> 
> Yeah what? That a decision must be made?

Yep. That's it. You ask me to learn this hardware, read datasheet and
design it instead of Colin or other people working on it. I can give you
generic guidelines how it should look, but that's it.

> 
>>> What information do you need to provide some best practices that can be
>>> applied here and are more useful than "you need to describe the
>>> hardware"? 
>>
>> Describe the hardware properties in terms of it fit in to the whole
>> system - so some inputs (clocks, GPIOs), outputs (interrupts),
>> characteristics of a device (e.g. clock provider -> clock cells) and
>> properties configuring hardware per specific implementation.
>>
>> But mostly this argument "describe hardware" should be understood like:
>> do not describe software (Linux drivers) and software policies (driver
>> choices)...
> 
> Let's bring this back on track. The discussion started with you saying:
> 
> | soc in spi is a bit confusing.
> 
> which I completely agree with, it really is. But it's also not wrong
> (or at least you didn't point out reasons why it would be, despite being
> asked to), and very descriptive of what actually takes place here:
> SoC registers are being accessed over SPI by an external host.

My comment was not only about this. My comment was about soc@0 not
having reg. And then having ethernet@0 with reg=<0,0> which is unusual,
because - as you explained - it is not a SPI device.

> 
> If you're going to keep giving mechanical review to this, my fear is
> that a very complex set of schemas is going to fall through the cracks
> of bureaucracy, and while it will end up being formally correct,
> absolutely no one will understand what is actually required when
> piecing everything together.
> 
> In your review of the example provided by Colin here, you first have
> this comment about "soc in spi" being confusing, then you seem to forget
> everything about that, and ask "How is this example different than
> previous one (existing soc example)?"

That one was a different topic, but we stopped discussing it. You
explained the differences and its fine.

> 
> There are more things to unpack in order to answer that.
> 
> The main point is that we wanted to reuse the existing MMIO-based
> drivers when accessing the devices over SPI. So the majority of
> peripherals have the same dt-bindings whether they are on /soc or on
> /spi/soc. Linux also provides us with the mfd and regmap abstractions,
> so all is good there. So you are not completely wrong to expect that an
> ethernet-switch with the "mscc,vsc7512-switch" compatible string should
> have the same bindings regardless of whatever its parent is.
> 
> Except this is not actually true, and the risk is that this will appear
> as seamless as just that when it actually isn't.
> 
> First (and here Colin is also wrong), the switch Colin adds support for
> is not directly comparable with "the existing soc example" (vsc9953).
> That is different (NXP) hardware which just happens to be supported by
> the same driver (drivers/net/dsa/ocelot). 

If it is different hardware, then you have different compatible, so why
this is a problem?

> It's worth reiterating that
> dissimilar hardware driven by a common driver should not necessarily
> have the same dt-bindings.

Which is obvious...

> Case in point, the NXP switches have a single
> (larger) "reg", because the SoC integration was tidier and the switch
> doesn't have 20 regions spread out through the SoC's guts, which overlap
> with other peripherals as in the case of VSC7512/VSC7514.
> 
> Anyway, Colin's SPI-controlled VSC7512 switch is most similar to
> mscc,vsc7514-switch.yaml (to the point of the hardware being identical),
> and I believe that this is the schema he should append his information to,
> rather than what he's currently proposing in his patches.
> 
> *But* accessing an Ethernet switch over SPI is not functionally
> identical to accessing it over MMIO, unless you want to have an Ethernet
> throughput in the order of tens of bits per second.
> 
> This is where implementation starts to matter, and while mscc,vsc7514-switch.yaml

Not really, implementation still does not matter to the bindings and
that argument proves nothing. No one forces you to model it as SPI in
bindings...

> describes a switch where packets are sent and received over MMIO (which
> wouldn't be feasible over SPI), Colin's VSC7512 schema describes a
> switch used in DSA mode (packets are sent/received over a host Ethernet
> port, fact which helps overcome the bandwidth limitations of SPI).
> To make matters worse, even VSC7514 can be used in DSA mode. When used
> in DSA mode, a *different* driver, with *different* dt-bindings (because
> of different histories) controls it.

The histories also do not matter here - you can deprecate bindings, e.g.
with a new compatible, and write everything a bit more generic (to cover
different setups).

> 
> So what must be done is that mscc,vsc7514-switch.yaml must incorporate
> *elements* of dsa.yaml, but *only* when it is not accessed using MMIO
> (i.e. the Linux on the MIPS VSC7514 doesn't support an external host
> driving the switch in DSA mode).

Yes and? You write such stuff like there was any objection from my side...

> 
> I was kind of expecting this discussion to converge towards ways in
> which we can modify mscc,vsc7514-switch.yaml to support a switch used
> in DSA mode or in switchdev mode. Most notable in dsa-port.yaml is the
> presence of an 'ethernet' phandle, but there are also other subtle
> differences, like the 'label' property which mscc,vsc7514-switch.yaml
> does not have (and which in the switchdev implementation at
> drivers/net/ethernet/mscc/ does not support, either).

What stops you from doing that? What do you need from me?


Best regards,
Krzysztof

