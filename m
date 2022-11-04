Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920E7619AFD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 16:08:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiKDPIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 11:08:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231171AbiKDPIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 11:08:10 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BBDB863
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 08:08:09 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id s4so3183754qtx.6
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 08:08:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JwRFU1y3EfXp9NwfKHJKDTZzTorKYkXOQOScKexSK2s=;
        b=N17D5A5+9jSMMCIRJo9nOYaW2EOVWnYsYjcQEdCs2HipPjL04GztoZIFUdoLImjxcx
         YWT0qkQ61KZDBh6kF0Ffp3iSg/X3aQSV/R93MF56XvTuYLHFJQkuO6D1jva6zo3Gyxfb
         s19rlLsB7tsMrvt3B+npYfsnQNWtHiDfTjV26taT59vOhpWgrNg+Obgne8Fq2bMpoLdK
         xqclqtyEkY1hX3OQFaxsfxxAIrXbtGSYXPO7I2UTAuiovBwzOKYP3DvHizak3/qDYfE1
         JBGSFqb77qeBNW02sezuWh0jHVNZmWJ9BuwC/5oymvChnUBbczRiAZ7y15bu6z1d8kHW
         wZFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JwRFU1y3EfXp9NwfKHJKDTZzTorKYkXOQOScKexSK2s=;
        b=2f+0HhKOtAlgCEdxfq2kYla2XBioV0KV4LJ8TgcnjIw0pm1Pt2jbpWVHa5gKqJ/DGd
         qcCPli2cjJqDK6ITr8PHEw6VaitJK0ExFZ4I8scwYk2eNp7IIg2FBEjP0Oli1RSBk/F7
         mikhtfMdCSZGimElPB6T6LpGGFlqFMRGzA6OeKolhwc6fZr6msA1fLpcRdd9NWEhdwNv
         A8MRk83F1nD3DoCy1uoSgfHZ8DuAUUgmM/oTQbjdEysGpARNonrwaJpKGhxIAGw193pM
         YyAiyYqhiHAV9Rpv+qiFtYYqFud7SzTBne2uII+oXXsD/QNeihONqyqmOkwGN+AoHCyd
         YWeg==
X-Gm-Message-State: ACrzQf02DJ0ZNl6bKY71djF3DNNBvplazYflP48JV2bf4oCKQugvcvst
        WnmD0+HnTbef+4RoakdydLheng==
X-Google-Smtp-Source: AMsMyM4LCRABqWLW63iq3OI5t/wjFQZQXiaKmhKKkibnjMz59AyssRT8Oy815QpTVNo+MHXCgSxzpA==
X-Received: by 2002:a05:622a:83:b0:3a4:ee89:1288 with SMTP id o3-20020a05622a008300b003a4ee891288mr298499qtw.512.1667574488795;
        Fri, 04 Nov 2022 08:08:08 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id u5-20020a05620a0c4500b006fa22f0494bsm3043977qki.117.2022.11.04.08.08.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 08:08:08 -0700 (PDT)
Message-ID: <3bdb7b04-27a2-8d50-b96a-76ad914a0988@linaro.org>
Date:   Fri, 4 Nov 2022 11:08:07 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com>
 <50814a5b-03d3-95b4-ab14-bfd19adae52b@linaro.org>
 <20221104143250.6qjkphkhrycp75rv@skbuf>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221104143250.6qjkphkhrycp75rv@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2022 10:32, Vladimir Oltean wrote:
> On Fri, Nov 04, 2022 at 10:31:06AM -0400, Krzysztof Kozlowski wrote:
>>> diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
>>> index b23591110bd2..5fa1af147df9 100644
>>> --- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
>>> +++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
>>> @@ -38,6 +38,7 @@ aliases {
>>>  		spi1 = &blsp1_spi2;
>>>  		i2c0 = &blsp1_i2c3;
>>>  		i2c1 = &blsp1_i2c4;
>>> +		ethernet0 = &gmac;
>>
>> Hm, I have doubts about this one. Why alias is needed and why it is a
>> property of a SoC? Not every board has Ethernet enabled, so this looks
>> like board property.
>>
>> I also wonder why do you need it at all?
> 
> In general, Ethernet aliases are needed so that the bootloader can fix
> up the MAC address of each port's OF node with values it gets from the
> U-Boot environment or an AT24 EEPROM or something like that.

Assuming that's the case here, my other part of question remains - is
this property of SoC or board? The buses (SPI, I2C) are properties of
boards, even though were incorrectly put here. If the board has multiple
ethernets, the final ordering is the property of the board, not SoC. I
would assume that bootloader also configures the MAC address based on
the board config, not per SoC...

Best regards,
Krzysztof

