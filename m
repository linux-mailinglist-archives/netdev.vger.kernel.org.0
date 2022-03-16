Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BCB4DAC5F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 09:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354508AbiCPIZI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 04:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354510AbiCPIZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 04:25:07 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92883DF49
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:23:52 -0700 (PDT)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 2D2843F4BC
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 08:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647419031;
        bh=e/AyH+eSm9JJq0EMKXs0iqv4SiUNyVLwcorNLctNODk=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=Gz55ggETgRpEC0BQRiOdr6pqXoFHo461V8BYXTbS64RNMVEYY3MDiifx+VPfW7T4u
         rdA77aYdwDAGMnaMWmodwGpcnGqn7AMJ66FEOrGZ28fGbNBGHw/X97R3fEd04GXMrF
         tcm6qWOcYdHxt2xEUqqplRjLml4bYRJbr5E8Mq45wDB4P5fnlUFEP+IOqJ1JUjwPI8
         vzjV5bc/JGOBYXmJZMGMRALRM3DjcPCkQn6ntnaEZ5l1l+CeEYcnOr2PKAJiGVVO1n
         LcNyiEtUBruTGQho5bhUKZ4ZZLesxyUzf2HvevYCPgHiRHR6Cs5JNHWbMVCzsLAfOl
         hsa0xThaiZi5g==
Received: by mail-ed1-f70.google.com with SMTP id n4-20020a5099c4000000b00418ed58d92fso209022edb.0
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 01:23:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e/AyH+eSm9JJq0EMKXs0iqv4SiUNyVLwcorNLctNODk=;
        b=xc0tNVZkQDvPm+BKKQGz88D51MiGKIZpi4t/DXPAyxbF86NeT5ouZ1Lh3ycnTYly07
         F/0osXs9McUsm102qJf/Qm9It2lRfnYh51Ww+vDxr3TuoquMsp/dggnIALXXXnWCESmD
         88ZIZJy3ZAVSIf+Os37iU333oiroa5LJeAxSH8/G2zb0r9KkjgyVwtAEBs122MYoiloh
         tuxqnrNqZtosLni5HdAZIEz+1yc+BC2cTu7Hp5pFKCsw2qjgLtbxNjcmbomse6y6aZKU
         UltlUaEjOIo4+xdKJhOpg9yaKBZnNJdhEKQTRgxkQR8LI8W3clf5KQgqnBu5xgPLIB6Y
         UrIw==
X-Gm-Message-State: AOAM530J+1jWnuesynJTiPCk6rajcRq4OLR18rZOdV8tOVI/BsfKIu/z
        Hp7sYY1F8zkOv7exQrCMehvEBUDfWeuarS/m/UbQaCCGYEfiBYHyenzAN6803PvziAfWPfy4lLs
        xtePNlVvP94jBIWgUR3MkwM8iCfUbZ5R3nQ==
X-Received: by 2002:a05:6402:221b:b0:418:eb30:47ff with SMTP id cq27-20020a056402221b00b00418eb3047ffmr971808edb.68.1647419028008;
        Wed, 16 Mar 2022 01:23:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXRJ2sxr1qa3Bn1UHN+BhsIianpdP+sELsNQc0NOKzWCLlZEItJaFvmiepEfFL2WU9WcOh2g==
X-Received: by 2002:a05:6402:221b:b0:418:eb30:47ff with SMTP id cq27-20020a056402221b00b00418eb3047ffmr971796edb.68.1647419027800;
        Wed, 16 Mar 2022 01:23:47 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id r29-20020a50c01d000000b00415fb0dc793sm613738edb.47.2022.03.16.01.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 01:23:47 -0700 (PDT)
Message-ID: <deed2e82-0d93-38d9-f7a2-4137fa0180e6@canonical.com>
Date:   Wed, 16 Mar 2022 09:23:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] dt-bindings: net: convert sff,sfp to dtschema
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <20220315123315.233963-1-ioana.ciornei@nxp.com>
 <6f4f2e6f-3aee-3424-43bc-c60ef7c0218c@canonical.com>
 <20220315190733.lal7c2xkaez6fz2v@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220315190733.lal7c2xkaez6fz2v@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/03/2022 20:07, Ioana Ciornei wrote:
> On Tue, Mar 15, 2022 at 07:21:59PM +0100, Krzysztof Kozlowski wrote:
>> On 15/03/2022 13:33, Ioana Ciornei wrote:
>>> Convert the sff,sfp.txt bindings to the DT schema format.
>>>
>>> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
>>> ---
> 
> (..)
> 
>>> +maintainers:
>>> +  - Russell King <linux@armlinux.org.uk>
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - sff,sfp  # for SFP modules
>>> +      - sff,sff  # for soldered down SFF modules
>>> +
>>> +  i2c-bus:
>>
>> Thanks for the conversion.
>>
>> You need here a type because this does not look like standard property.
> 
> Ok.
> 
>>
>>> +    description:
>>> +      phandle of an I2C bus controller for the SFP two wire serial
>>> +
>>> +  maximum-power-milliwatt:
>>> +    maxItems: 1
>>> +    description:
>>> +      Maximum module power consumption Specifies the maximum power consumption
>>> +      allowable by a module in the slot, in milli-Watts. Presently, modules can
>>> +      be up to 1W, 1.5W or 2W.
>>> +
>>> +patternProperties:
>>> +  "mod-def0-gpio(s)?":
>>
>> This should be just "mod-def0-gpios", no need for pattern. The same in
>> all other places.
>>
> 
> The GPIO subsystem accepts both suffixes: "gpio" and "gpios", see
> gpio_suffixes[]. If I just use "mod-def0-gpios" multiple DT files will
> fail the check because they are using the "gpio" suffix.
> 
> Why isn't this pattern acceptable?

Because original bindings required gpios, so DTS are wrong, and the
pattern makes it difficult to grep and read such simple property.

The DTSes which do not follow bindings should be corrected.

> 
>>> +
>>> +  "rate-select1-gpio(s)?":
>>> +    maxItems: 1
>>> +    description:
>>> +      GPIO phandle and a specifier of the Tx Signaling Rate Select (AKA RS1)
>>> +      output gpio signal (SFP+ only), low - low Tx rate, high - high Tx rate. Must
>>> +      not be present for SFF modules
>>
>> This and other cases should have a "allOf: if: ...." with a
>> "rate-select1-gpios: false", to disallow this property on SFF modules.
>>
> 
> Ok, didn't know that's possible.
> 
>>> +
>>> +required:
>>> +  - compatible
>>> +  - i2c-bus
>>> +
>>> +additionalProperties: false
>>> +
>>> +examples:
>>> +  - | # Direct serdes to SFP connection
>>> +    #include <dt-bindings/gpio/gpio.h>
>>> +
>>> +    sfp_eth3: sfp-eth3 {
>>
>> Generic node name please, so maybe "transceiver"? or just "sfp"?
>>
> 
> Ok, I can do just "sfp".
> 
>>> +      compatible = "sff,sfp";
>>> +      i2c-bus = <&sfp_1g_i2c>;
>>> +      los-gpios = <&cpm_gpio2 22 GPIO_ACTIVE_HIGH>;
>>> +      mod-def0-gpios = <&cpm_gpio2 21 GPIO_ACTIVE_LOW>;
>>> +      maximum-power-milliwatt = <1000>;
>>> +      pinctrl-names = "default";
>>> +      pinctrl-0 = <&cpm_sfp_1g_pins &cps_sfp_1g_pins>;
>>> +      tx-disable-gpios = <&cps_gpio1 24 GPIO_ACTIVE_HIGH>;
>>> +      tx-fault-gpios = <&cpm_gpio2 19 GPIO_ACTIVE_HIGH>;
>>> +    };
>>> +
>>> +    cps_emac3 {
>>
>> This is not related, so please remove.
> 
> It's related since it shows a generic usage pattern of the sfp node.
> I wouldn't just remove it since it's just adds context to the example
> not doing any harm.

Usage (consumer) is not related to these bindings. The bindings for this
phy/mac should show the usage of sfp, but not the provider bindings.

The bindings of each clock provider do not contain examples for clock
consumer. Same for regulator, pinctrl, power domains, interconnect and
every other component. It would be a lot of code duplication to include
consumers in each provider. Instead, we out the example of consumer in
the consumer bindings.

The harm is - duplicated code and one more example which can be done
wrong (like here node name not conforming to DT spec).

If you insist to keep it, please share why these bindings are special,
different than all other bindings I mentioned above.

> 
>>
>>> +      phy-names = "comphy";
>>> +      phys = <&cps_comphy5 0>;
>>> +      sfp = <&sfp_eth3>;
>>> +    };
>>> +
>>> +  - | # Serdes to PHY to SFP connection
>>> +    #include <dt-bindings/gpio/gpio.h>
>>
>> Are you sure it works fine? Double define?
> 
> You mean that I added a second example? I don't understand the question.

You have second same include so you will have doubled defines. Usually
it was an error...

Best regards,
Krzysztof
