Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F8F5F50A0
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 10:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJEIJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 04:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbiJEIJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 04:09:13 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26EBC70E65
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 01:09:10 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id bn8so4427215ljb.6
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 01:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=fKZVMBLV4cyNa9DTz4xK4r/4KYXQ4qFmdv6P+6q2hAE=;
        b=xDsZijxU2udyYZXfP0YdYnMCiJTLXIDfOLMcGcbDPwCu0RuWMfqe5j2uTWmRPni+xy
         mhDjJ0RTgzZ0Feb2VhJTe0RHt/bA0sGQmvnwzWaJpnSt6zPYm+E9+r8z8qQKp20QQavf
         7kp0rT6OGMGUlYJP5Wf/RLrRh6eHALKr/hiRnyDdjYccmIkYH73GotozJPrd7UrxzUr3
         kYlEZHa1s0Xh9IOMHY8XpFcMEBMONczYn+qCm6BJHEMm0sYr/XhQqUXuyd6xhDR1OWij
         aaiSTgLfH4ByjBBcL2tjMDBLfswZ8QFqd49cqKGlJHRKx8RiT0mSGp/JI06m8hPU7WvH
         AlOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=fKZVMBLV4cyNa9DTz4xK4r/4KYXQ4qFmdv6P+6q2hAE=;
        b=p2+l3XFPCzF19RjvRMYfNj/W4Vor91RoGqHT/O8Dpz74zG/HxO9dFQ3fWLjTaGFNVT
         f9DODdnCW83PKluZZv4DBTzlaqxxvqYnKMiEam7v6mvdiBbM8VcpeSQpCIF6q4ajqubu
         sIfI4NS7InFDYAm1c686VC/lm/Aprgi07xhVMmQjGB1oLXKejrVEnPRrbG7vOMysR1kE
         l5LsC7tTug0uYlRxucYias3ggOa8d0IHRw57Pi+utyAMlLyJwN6xnldh3NlW1RlugKwb
         hApBoaV3syojQIc1ms8q9w/x+5nXHX35acdN2aSubsxcc9t29zSfLZS5uh7wB6OxSk/H
         y+YA==
X-Gm-Message-State: ACrzQf2g3yJJzQ/BISFSC2Wy7ZRkK6UC8xohBPK527FP4JnD9GzVg/da
        5h4qQMQoxeijgx8E3UeYCQkPOQ==
X-Google-Smtp-Source: AMsMyM4eewbzpOumWsknGgIrXWo7yHnFVYt28GJGRa/ZUMTM9+Wwi/Ok1WI3MCBOC0C6gx2HIcSN0A==
X-Received: by 2002:a05:651c:1069:b0:26c:3e08:25eb with SMTP id y9-20020a05651c106900b0026c3e0825ebmr9136701ljm.441.1664957348366;
        Wed, 05 Oct 2022 01:09:08 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z3-20020a056512370300b004a2386b8cf4sm1390141lfr.258.2022.10.05.01.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Oct 2022 01:09:07 -0700 (PDT)
Message-ID: <cae8e149-ef1e-66c6-20f5-067e3fd8c586@linaro.org>
Date:   Wed, 5 Oct 2022 10:09:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
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
 <20221004121517.4j5637hnioepsxgd@skbuf>
 <6444e5d1-0fc9-03e2-9b2a-ec19fa1e7757@linaro.org>
 <20221004160135.lqugs6cf5b7fwkxq@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221004160135.lqugs6cf5b7fwkxq@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/10/2022 18:01, Vladimir Oltean wrote:
> On Tue, Oct 04, 2022 at 04:59:02PM +0200, Krzysztof Kozlowski wrote:
>> On 04/10/2022 14:15, Vladimir Oltean wrote:
>>> On Tue, Oct 04, 2022 at 01:19:33PM +0200, Krzysztof Kozlowski wrote:
>>>>> +  # Ocelot-ext VSC7512
>>>>> +  - |
>>>>> +    spi {
>>>>> +        soc@0 {
>>>>
>>>> soc in spi is a bit confusing.
>>>
>>> Do you have a better suggestion for a node name? This is effectively a
>>> container for peripherals which would otherwise live under a /soc node,
>>
>> /soc node implies it does not live under /spi node. Otherwise it would
>> be /spi/soc, right?
> 
> Did you read what's written right below? I can explain if you want, but
> there's no point if you're not going to read or ask other clarification
> questions.
> 
>>> if they were accessed over MMIO by the internal microprocessor of the
>>> SoC, rather than by an external processor over SPI.
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> The /spi/soc@0 node actually has a compatible of "mscc,vsc7512" which
> Colin did not show in the example (it is not "simple-bus"). It is covered
> by Documentation/devicetree/bindings/mfd/mscc,ocelot.yaml. Still waiting
> for a better suggestion for how to name the mfd container node.

Then still the /spi node does not seem related. If I understand
correctly, your device described in this bindings is a child of soc@0.
Sounds fine. How that soc@0 is connected to the parent - via SPI or
whatever - is not related to this binding, is it? It is related to the
soc binding, but not here.

> 
>>>> How is this example different than previous one (existing soc example)?
>>>> If by compatible and number of ports, then there is no much value here.
>>>
>>> The positioning relative to the other nodes is what's different.
>>
>> Positioning of nodes is not worth another example, if everything else is
>> the same. What is here exactly tested or shown by example? Using a
>> device in SPI controller?
> 
> Everything is not the same, it is not the same hardware as what is currenly
> covered by Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml.
> The "existing soc example" (mscc,vsc9953-switch) has a different port
> count, integration with a different SERDES, interrupt controller, pin
> controller, things like that. The examples already differ in port count
> and phy-mode values, I expect they will start diverging more in the
> future. If you still believe it's not worth having an example of how to
> instantiate a SPI-controlled VSC7512 because there also exists an
> example of an MMIO-controlled VSC9953, then what can I say.
> 
> ------ cut here ------
> 
> Unrelated to your "existing soc example" (the VSC9953), but relevant and
> you may want to share your opinion on this:
> 
> The same hardware present in the VSC7514 SoC can also be driven by an
> integrated MIPS processor, and in that case, it is indeed expected that
> the same dt-bindings cover both the /soc and the /spi/soc@0/ relative
> positioning of their OF node. This is true for simpler peripherals like
> "mscc,ocelot-miim", "mscc,ocelot-pinctrl", "mscc,ocelot-sgpio". However
> it is not true for the main switching IP of the SoC itself.
> 
> When driven by a switchdev driver, by the internal MIPS processor (the
> DMA engine is what is used for packet I/O), the switching IP follows the
> Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml binding
> document.
> 
> When driven by a DSA driver (external processor, host frames are
> redirected through an Ethernet port instead of DMA controller),
> the switching IP follows the Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
> document.
> 
> The switching IP is special in this regard because the hardware is not
> used in the same way. The DSA dt-binding also needs the 'ethernet'
> phandle to be present in a port node. The different placement of the
> bindings according to the use case of the hardware is a bit awkward, but
> is a direct consequence of the separation between DSA and pure switchdev
> drivers that has existed thus far (and the fact that DSA has its own
> folder in the dt-bindings, with common properties in dsa.yaml and
> dsa-port.yaml etc). It is relatively uncommon for a switching IP to have
> provisioning to be used in both modes, and for Linux to support both
> modes (using different drivers), yet this is what we have here.

Is there a question here to me? What shall I do with this paragraph? You
know, I do not have a problem of lack of material to read...

Best regards,
Krzysztof

