Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28266599C59
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349086AbiHSMwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349079AbiHSMwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:52:43 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C4AEDAEE4
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:52:42 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id bx38so4424989ljb.10
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=mu4cs57so/hm5H36zlHi+oMf19bmDRm3sZ5zNgNtxQw=;
        b=hNhliri7Zq4aZR+zeEMCZ3lQ5ZYBtWNy2tq1eX2FnOUex3MB2/WSBsLtkv/Z5TzQeY
         zmY4neIXhtWCN5O8TJxlGZeZoO0EVY78CjIM1XKxHSKNcZSuwhcly4clBIh6BuJd1KBw
         /ICBLHjVgOgsoiIinTgW6BtGwpPC8bqf6Z36kq5FGi048T2GQRGNxl8iqK9u7WYUqTwa
         N7Xj2QJCQybpwQdQqpHze8XBJSRAGU6TPCy+3Lq4KZ4k8K9pYyrXWTA34Xx25dP9fmUz
         mtStDwoNwY4y27TMTTQvgYMgcpT8k+gjdvfJegMD1z6IZBkfcm/YftwrsKU7UILwaSC3
         PhHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=mu4cs57so/hm5H36zlHi+oMf19bmDRm3sZ5zNgNtxQw=;
        b=xucABqZC8zPljALBmTtvcv4tC7+oAjFqPCOk+40VlOcB+5VyPil3mn8J/xiRxUwQ/R
         f6N744bTkSuChVglSJlHC2IKGZ9thpf/T3reO2pHhr/h8/lUjoIWnmU63FDRw2dll20P
         aXfXmwrTDhueR/gyy8vvMtGnMfuemRMIO7/TQow/0E7QULvEiswPDbU2rlBcfN/WzOWM
         +iBGjoGV6p536sjnOzOORzL6CyBG8EC/A2DNE/kwi2GzViiimzb8emJeh8aM/n0m4mTL
         L1Lsiffgd0sozCV8uIF1HEUFiTlvs0588nuuZ8SyikJiuWBkutyrDTaJrudUvnRI+ml6
         SHrA==
X-Gm-Message-State: ACgBeo2PSkQ9Yz+y+tDh5nRFR5ksN7ruem/IETaNxYWX6zm7fGxqLsg4
        ElWkOKFHAx29VvH+VuxDdr+Txg==
X-Google-Smtp-Source: AA6agR6E41JWNeYbhnyaHiir5IGmfC6Jpna2d622TenkdJ160D+d3YEw6fp21X0jdpUta0fOc4uQ3g==
X-Received: by 2002:a05:651c:12c4:b0:25d:fe06:8658 with SMTP id 4-20020a05651c12c400b0025dfe068658mr2017908lje.301.1660913560695;
        Fri, 19 Aug 2022 05:52:40 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id e16-20020ac24e10000000b00492ba56995asm630824lfr.101.2022.08.19.05.52.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 05:52:40 -0700 (PDT)
Message-ID: <55c53ba1-8e13-599d-1b16-5dab417a3059@linaro.org>
Date:   Fri, 19 Aug 2022 15:52:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in
 property
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Wei Fang <wei.fang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
 <20220819074729.1496088-2-wei.fang@nxp.com>
 <f0f6e8af-4006-e0e8-544b-f2f892d79a1f@linaro.org>
 <DB9PR04MB81064199835C0E44B997DE06886C9@DB9PR04MB8106.eurprd04.prod.outlook.com>
 <9ec575ba-784d-74f7-8861-da2f62fe0773@linaro.org> <Yv+FuiUoTjpoUZ32@lunn.ch>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Yv+FuiUoTjpoUZ32@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 15:44, Andrew Lunn wrote:
> On Fri, Aug 19, 2022 at 02:37:36PM +0300, Krzysztof Kozlowski wrote:
>> On 19/08/2022 12:37, Wei Fang wrote:
>>>>
>>>>> +          in RMII mode. This clock signal is provided by the PHY and is
>>>>> +          typically derived from an external 25MHz crystal. Alternatively,
>>>>> +          a 50MHz clock signal generated by an external oscillator can be
>>>>> +          connected to pin REF_CLK. A third option is to connect a 25MHz
>>>>> +          clock to pin CLK_IN_OUT. So, the REF_CLK should be configured
>>>>> +          as input or output according to the actual circuit connection.
>>>>> +          If present, indicates that the REF_CLK will be configured as
>>>>> +          interface reference clock input when RMII mode enabled.
>>>>> +          If not present, the REF_CLK will be configured as interface
>>>>> +          reference clock output when RMII mode enabled.
>>>>> +          Only supported on TJA1100 and TJA1101.
>>>>
>>>> Then disallow it on other variants.
>>>>
>>>> Shouldn't this be just "clocks" property?
>>>>
>>>>
>>> This property is to configure the pin REF_CLK of PHY as a input pin through phy register,
>>> indicates that the REF_CLK signal is provided by an external oscillator. so I don't think it's a
>>> "clock" property.
>>
>> clocks, not clock.
>>
>> You just repeated pieces of description as an counter-argument, so this
>> does not explain anything.
>>
>> If it is external oscillator shouldn't it be represented in DTS and then
>> obtained by driver (clk_get + clk_prepare_enable)? Otherwise how are you
>> sure that clock is actually enabled? And the lack of presence of the
>> external clock means it is derived from PHY?
> 
> Using the common clock framework has been discussed in the past. But
> no PHY actually does this. When the SoC provides the clock, a few PHYs
> do make use of the common clock framework as clock consumers to ensure
> the clock is ticking.

IOW, all DTSes would have a fixed clock stub without any logic usable by
Common CF (like enabling)?

> Plus, as the description says, this pin can be either a clock producer
> or a consumer. I don't think the common clock code allows this. It is
> also not something you negotiate between the MAC and PHY. The hardware
> designer typically decides based on the MAC and PHY actually used. So
> this is a fixed hardware property.

Indeed.

Anyway the property name and typo need fixes.
Best regards,
Krzysztof
