Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE02C5EEDD3
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 08:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbiI2GWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 02:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234320AbiI2GWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 02:22:17 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8071BE513B
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:22:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q35-20020a17090a752600b002038d8a68fbso5009481pjk.0
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 23:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ox1GauuStOI4SK9psyOEXzOmaCJACh7EVhwmDraseFg=;
        b=OYSIuBJ+hscx6KBaa9LaMqa68w1O41CuprZllPJ9Evi04V0zn5aq67KJlwSfYVa3e8
         QSueGaKUaG2CubSbimzP0SdwOGmRdQKQQ/NazNHQo/paYkabsw83b4o85SjhbUBOshkM
         gFefgbVxWpaqCR2Q0VjCOE9ODCv5xEmg543RN8Z6LDBLCnWWj/b4PPw39Uaqg/EUlQjm
         X3zJ6nIwY9au08LDhchR8VTVVL+Bgn+P/676kfME+dylaawRysxAZ31BvCHoBCy0abqc
         45/28p0SM30nOT7H1xWlyAqnOixINFIVUCypfO4FbZvO7NjQ6XS/DSULJNF++K04hzRq
         gkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ox1GauuStOI4SK9psyOEXzOmaCJACh7EVhwmDraseFg=;
        b=2VNDYQ7Y1qkqBT/e/gi15MnH/DZea7hSyjxj9SFC/oFj7FAvKQoe9ZfpKPNFyXUbyU
         UK3PJAOBGlQFG56/Un/Y81DEI7JRVk6XWtkEFyulMnR47JB3aHUBCwwnjLKbR0w0778t
         vYGEKeUKcZWMe96W++tePXJqi+LzovTWjMIafkOYng8cZMUgnu4IDL/6alCQ1GGRIbph
         cuGaTb2taCo5XbNta3JdRF53jSzAhxS4j1ITCWF6we0VE+bE6kkbBphiGEKmgwIZoVcj
         VdSZTC6XY86u1dsa7cNE3n74gbOVeKt6QcCWv04jddpBLzqoWcVj1KGQVLDJWatq478A
         ltIQ==
X-Gm-Message-State: ACrzQf0KMaxxqjGnq/B19ahaqVQHL8GtT4ZPurPHtIEdETZEMmaOsNyb
        fug1KsAUJ92MHiBgi1lAktyucg==
X-Google-Smtp-Source: AMsMyM6G5qfjtcJ5DARD473KfsEnnyfDX+1ZzyWjN6ssRcn9kkphWNTL1fKJpy6PH2mMlQC4cr7Xfw==
X-Received: by 2002:a17:902:e5c9:b0:178:5a6f:6eb8 with SMTP id u9-20020a170902e5c900b001785a6f6eb8mr1957938plf.42.1664432534954;
        Wed, 28 Sep 2022 23:22:14 -0700 (PDT)
Received: from ?IPV6:2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7? ([2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7])
        by smtp.gmail.com with ESMTPSA id u18-20020a634552000000b004390b40b4a1sm4715482pgk.23.2022.09.28.23.22.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Sep 2022 23:22:14 -0700 (PDT)
Message-ID: <0b6db6ce-a74c-66d0-dc05-b87b96b386a2@linaro.org>
Date:   Thu, 29 Sep 2022 11:52:08 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/4] dt-bindings: net: qcom,ethqos: Convert bindings to
 yaml
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        devicetree@vger.kernel.org
Cc:     linux-arm-msm@vger.kernel.org, agross@kernel.org,
        bhupesh.linux@gmail.com, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        Bjorn Andersson <andersson@kernel.org>,
        Rob Herring <robh@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        David Miller <davem@davemloft.net>
References: <20220907204924.2040384-1-bhupesh.sharma@linaro.org>
 <20220907204924.2040384-2-bhupesh.sharma@linaro.org>
 <dcf449f5-ad28-d262-98d5-72c6ba2b7aea@linaro.org>
 <ccd6f6c2-458d-832a-7299-d9d9ffb652a8@linaro.org>
 <1a683d12-eee9-e35b-3808-4856fe4dc0f2@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <1a683d12-eee9-e35b-3808-4856fe4dc0f2@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/13/22 2:20 PM, Krzysztof Kozlowski wrote:
> On 12/09/2022 19:28, Bhupesh Sharma wrote:
>> Hi Krzysztof,
>>
>> Thanks for your comments.
>>
>> On 9/8/22 8:08 PM, Krzysztof Kozlowski wrote:
>>> On 07/09/2022 22:49, Bhupesh Sharma wrote:
>>>> Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
>>>>
>>>> Cc: Bjorn Andersson <andersson@kernel.org>
>>>> Cc: Rob Herring <robh@kernel.org>
>>>> Cc: Vinod Koul <vkoul@kernel.org>
>>>> Cc: David Miller <davem@davemloft.net>
>>>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>
>>> Thank you for your patch. There is something to discuss/improve.
>>>
>>>> ---
>>>>    .../devicetree/bindings/net/qcom,ethqos.txt   |  66 ---------
>>>>    .../devicetree/bindings/net/qcom,ethqos.yaml  | 139 ++++++++++++++++++
>>>
>>> You need to update maintainers - old path.
>>
>> Sure, my bad. Will do in v2.
>>
>>>>    2 files changed, 139 insertions(+), 66 deletions(-)
>>>>    delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>>>    create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>>> deleted file mode 100644
>>>> index 1f5746849a71..000000000000
>>>> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>>> +++ /dev/null
>>>> @@ -1,66 +0,0 @@
>>>> -Qualcomm Ethernet ETHQOS device
>>>> -
>>>> -This documents dwmmac based ethernet device which supports Gigabit
>>>> -ethernet for version v2.3.0 onwards.
>>>> -
>>>> -This device has following properties:
>>>> -
>>>> -Required properties:
>>>> -
>>>> -- compatible: Should be one of:
>>>> -		"qcom,qcs404-ethqos"
>>>> -		"qcom,sm8150-ethqos"
>>>> -
>>>> -- reg: Address and length of the register set for the device
>>>> -
>>>> -- reg-names: Should contain register names "stmmaceth", "rgmii"
>>>> -
>>>> -- clocks: Should contain phandle to clocks
>>>> -
>>>> -- clock-names: Should contain clock names "stmmaceth", "pclk",
>>>> -		"ptp_ref", "rgmii"
>>>> -
>>>> -- interrupts: Should contain phandle to interrupts
>>>> -
>>>> -- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
>>>> -
>>>> -Rest of the properties are defined in stmmac.txt file in same directory
>>>> -
>>>> -
>>>> -Example:
>>>> -
>>>> -ethernet: ethernet@7a80000 {
>>>> -	compatible = "qcom,qcs404-ethqos";
>>>> -	reg = <0x07a80000 0x10000>,
>>>> -		<0x07a96000 0x100>;
>>>> -	reg-names = "stmmaceth", "rgmii";
>>>> -	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
>>>> -	clocks = <&gcc GCC_ETH_AXI_CLK>,
>>>> -		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
>>>> -		<&gcc GCC_ETH_PTP_CLK>,
>>>> -		<&gcc GCC_ETH_RGMII_CLK>;
>>>> -	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
>>>> -			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
>>>> -	interrupt-names = "macirq", "eth_lpi";
>>>> -	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
>>>> -	snps,reset-active-low;
>>>> -
>>>> -	snps,txpbl = <8>;
>>>> -	snps,rxpbl = <2>;
>>>> -	snps,aal;
>>>> -	snps,tso;
>>>> -
>>>> -	phy-handle = <&phy1>;
>>>> -	phy-mode = "rgmii";
>>>> -
>>>> -	mdio {
>>>> -		#address-cells = <0x1>;
>>>> -		#size-cells = <0x0>;
>>>> -		compatible = "snps,dwmac-mdio";
>>>> -		phy1: phy@4 {
>>>> -			device_type = "ethernet-phy";
>>>> -			reg = <0x4>;
>>>> -		};
>>>> -	};
>>>> -
>>>> -};
>>>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>>> new file mode 100644
>>>> index 000000000000..f05df9b0d106
>>>> --- /dev/null
>>>> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>>> @@ -0,0 +1,139 @@
>>>> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
>>>> +%YAML 1.2
>>>> +---
>>>> +$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
>>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>>> +
>>>> +title: Qualcomm Ethernet ETHQOS device
>>>> +
>>>> +maintainers:
>>>> +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
>>>> +
>>>> +description:
>>>> +  This binding describes the dwmmac based Qualcomm ethernet devices which
>>>> +  support Gigabit ethernet (version v2.3.0 onwards).
>>>> +
>>>> +  So, this file documents platform glue layer for dwmmac stmmac based Qualcomm
>>>> +  ethernet devices.
>>>> +
>>>> +allOf:
>>>> +  - $ref: "snps,dwmac.yaml#"
>>>
>>> No need for quotes.
>>
>> Ok.
>>
>>>> +
>>>> +properties:
>>>> +  compatible:
>>>> +    enum:
>>>> +      - qcom,qcs404-ethqos
>>>> +      - qcom,sm8150-ethqos
>>>> +
>>>> +  reg: true
>>>
>>> I think both devices use two reg spaces.
>>
>> On this platform the two reg spaces are 64-bit, whereas for other
>> platforms based on dwmmac, for e.g. stm32 have 32-bit address space.
> 
> Then for this platform this should be made specific/constrained, so it
> must be two items.
> 
>>
>>>> +
>>>> +  reg-names:
>>>> +    minItems: 1
>>>
>>> Why allowing only one item?
>>
>> Ok, let me remove this in v2.
> 
> And then as well you allow only one item... This should be specific. If
> not - why?
> 
>>
>>>> +    items:
>>>> +      - const: stmmaceth
>>>> +      - const: rgmii
>>>> +
>>>> +  interrupts: true
>>>
>>> This should be specific/fixed.
>>>
>>>> +
>>>> +  interrupt-names: true
>>>
>>> This should be specific/fixed.
>>
>> These are same as in $ref: "snps,dwmac.yaml#", so
>> do we really need to specify them here? I remember on the sdhci-msm
>> YAML patch review, Rob mentioned that we should just set the property to
>> true, in such cases.
> 
> But it is not specific in dwmac.yaml. You use "xxx: true" when you want
> to accept property from other schema, assuming it is defined there
> properly. However the snps,dwmac does not define it in specific way
> because it expects specific implementation to narrow the details.
> 
>>
>> Am I missing something here?
>>
>>>> +
>>>> +  clocks:
>>>> +    minItems: 1
>>>> +    maxItems: 4
>>>
>>> Why such flexibility?
>>
>> Ok, let me just keep 'maxItems: 4' here for now.
>>
>>>> +
>>>> +  clock-names:
>>>> +    minItems: 1
>>>> +    items:
>>>> +      - const: stmmaceth
>>>> +      - const: pclk
>>>> +      - const: ptp_ref
>>>> +      - const: rgmii
>>>> +
>>>> +  iommus:
>>>> +    minItems: 1
>>>> +    maxItems: 2
>>>
>>> Aren't we using only one MMU?
>>
>> It was just for future compatibility, but I get your point.
>> Let me keep the 'maxItems: 1' here for now.
>>
>>>> +
>>>> +  mdio: true
>>>> +
>>>> +  phy-handle: true
>>>> +
>>>> +  phy-mode: true
>>>> +
>>>> +  snps,reset-gpio: true
>>>> +
>>>> +  snps,tso:
>>>> +    $ref: /schemas/types.yaml#/definitions/flag
>>>> +    description:
>>>> +      Enables the TSO feature otherwise it will be managed by MAC HW capability register.
>>>> +
>>>> +  power-domains: true
>>>> +
>>>> +  resets: true
>>>> +
>>>> +  rx-fifo-depth: true
>>>> +
>>>> +  tx-fifo-depth: true
>>>
>>> You do not list all these properties, because you use
>>> unevaluatedProperties. Drop all of these "xxx :true".
>>
>> Same query as above. May be I am missing something here.
> 
> You do not list any properties:true from other schema, if you use
> unevaluatedProperties:false.

Ok, let me try and fix these in the v2. I will share the same soon.

Thanks,
Bhupesh

