Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981455F0645
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 10:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbiI3IMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 04:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbiI3IMX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 04:12:23 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BE21FF177
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:12:21 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 9so3594529pfz.12
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 01:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=6NyeoJovWo80SRvIahWrHZTL8FRKaUcjv7Xwm9qDiaQ=;
        b=vcBKdm9KUPdo9pN8hASTyPznOaBv2Q56BzQn8lTRbaHyRUKrxKuFtzNdMnFOwR4NNe
         6dH+DPdKQb7VZJkkOIaLfFjAgZP2EtT2e1gcUe54jtjpkUHWlJx79di7bD22MLuawEIU
         FH1PBYO/cyraJPAVqh10PxcPMF0KQBgJlWlDVeNwC1NevKzhK/1fu58hkzc0cLEPzATI
         kvkSysaqnl1vl/UEy8qmRi1OeDXd1DqsGlwSCfNT7rMHZbmmDRp9UweVT+i7T7f4YSbX
         yEhwCuSs5KN8a9jWLsFBBJq5sbKRqF+dJCm7CJbk5mU7DeFPmq8iIHB57E9wyQ8qrOk0
         O5HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=6NyeoJovWo80SRvIahWrHZTL8FRKaUcjv7Xwm9qDiaQ=;
        b=PNZh9iFbKtoomqmKUa/QfDKt6BiykN0AGUlkXazetP4Sg5uI75x5r3ixtMW6ixIuz9
         GRb5ZDBIy4Sd6AIeiM+eyvjCjz3d4EeogalhqkSyNR2Yjq+qwCYcHp411GCTls7Q97/5
         jGZCBJU0q+Gy70caT72InTeBf6wMGcX1DNs4kYifEHZ5OFhVXuphAlkhm4lVjdwtTqYg
         RkVvi5nhIWVbKisadZCMicISTlUNi6Gi5W9/HhhT0N8jGU5DeTwNrCTeUBZls9CUIHx3
         kgTV877co0fZ6YLXZ3vYkMuevwNhfR7w6VhT+Qw1kPCSY+SU+hqQlGn0Y3M550rlnaBf
         DjmA==
X-Gm-Message-State: ACrzQf2UgrOFnum5nuiNjouH0GExT6bpMa5rOjhveihgcRcbD5XsPWXF
        DhHCaHZKzc4NPlytWve3v6ot6A==
X-Google-Smtp-Source: AMsMyM4ozhIXKnEWVfoK7a0PhBcFVtTjLUsOsqboI7LX0DY1IUZCNi4soYe4F0biSh/x/k2zyGlsbA==
X-Received: by 2002:a63:80c8:0:b0:43c:c89d:a944 with SMTP id j191-20020a6380c8000000b0043cc89da944mr6722666pgd.117.1664525541286;
        Fri, 30 Sep 2022 01:12:21 -0700 (PDT)
Received: from ?IPV6:2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7? ([2401:4900:1f3b:3adb:24f8:ac24:2282:1dc7])
        by smtp.gmail.com with ESMTPSA id k17-20020a170902c41100b0016c0b0fe1c6sm1268168plk.73.2022.09.30.01.12.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Sep 2022 01:12:20 -0700 (PDT)
Message-ID: <1163e862-d36a-9b5e-2019-c69be41cc220@linaro.org>
Date:   Fri, 30 Sep 2022 13:42:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 3/4] dt-bindings: net: qcom,ethqos: Convert bindings to
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
References: <20220929060405.2445745-1-bhupesh.sharma@linaro.org>
 <20220929060405.2445745-4-bhupesh.sharma@linaro.org>
 <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
In-Reply-To: <4e896382-c666-55c6-f50b-5c442e428a2b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 9/29/22 12:52 PM, Krzysztof Kozlowski wrote:
> On 29/09/2022 08:04, Bhupesh Sharma wrote:
>> Convert Qualcomm ETHQOS Ethernet devicetree binding to YAML.
>>
>> While at it, also add Qualcomm Ethernet ETHQOS compatible checks
>> in snps,dwmac YAML binding document.
> 
> There are no checks added to snps,dwmac.

Ack.

>>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Vinod Koul <vkoul@kernel.org>
>> Cc: David Miller <davem@davemloft.net>
>> Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> ---
>>   .../devicetree/bindings/net/qcom,ethqos.txt   |  66 --------
>>   .../devicetree/bindings/net/qcom,ethqos.yaml  | 145 ++++++++++++++++++
>>   2 files changed, 145 insertions(+), 66 deletions(-)
>>   delete mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.txt
>>   create mode 100644 Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.txt b/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>> deleted file mode 100644
>> index 1f5746849a71..000000000000
>> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.txt
>> +++ /dev/null
>> @@ -1,66 +0,0 @@
>> -Qualcomm Ethernet ETHQOS device
>> -
>> -This documents dwmmac based ethernet device which supports Gigabit
>> -ethernet for version v2.3.0 onwards.
>> -
>> -This device has following properties:
>> -
>> -Required properties:
>> -
>> -- compatible: Should be one of:
>> -		"qcom,qcs404-ethqos"
>> -		"qcom,sm8150-ethqos"
>> -
>> -- reg: Address and length of the register set for the device
>> -
>> -- reg-names: Should contain register names "stmmaceth", "rgmii"
>> -
>> -- clocks: Should contain phandle to clocks
>> -
>> -- clock-names: Should contain clock names "stmmaceth", "pclk",
>> -		"ptp_ref", "rgmii"
>> -
>> -- interrupts: Should contain phandle to interrupts
>> -
>> -- interrupt-names: Should contain interrupt names "macirq", "eth_lpi"
>> -
>> -Rest of the properties are defined in stmmac.txt file in same directory
>> -
>> -
>> -Example:
>> -
>> -ethernet: ethernet@7a80000 {
>> -	compatible = "qcom,qcs404-ethqos";
>> -	reg = <0x07a80000 0x10000>,
>> -		<0x07a96000 0x100>;
>> -	reg-names = "stmmaceth", "rgmii";
>> -	clock-names = "stmmaceth", "pclk", "ptp_ref", "rgmii";
>> -	clocks = <&gcc GCC_ETH_AXI_CLK>,
>> -		<&gcc GCC_ETH_SLAVE_AHB_CLK>,
>> -		<&gcc GCC_ETH_PTP_CLK>,
>> -		<&gcc GCC_ETH_RGMII_CLK>;
>> -	interrupts = <GIC_SPI 56 IRQ_TYPE_LEVEL_HIGH>,
>> -			<GIC_SPI 55 IRQ_TYPE_LEVEL_HIGH>;
>> -	interrupt-names = "macirq", "eth_lpi";
>> -	snps,reset-gpio = <&tlmm 60 GPIO_ACTIVE_LOW>;
>> -	snps,reset-active-low;
>> -
>> -	snps,txpbl = <8>;
>> -	snps,rxpbl = <2>;
>> -	snps,aal;
>> -	snps,tso;
>> -
>> -	phy-handle = <&phy1>;
>> -	phy-mode = "rgmii";
>> -
>> -	mdio {
>> -		#address-cells = <0x1>;
>> -		#size-cells = <0x0>;
>> -		compatible = "snps,dwmac-mdio";
>> -		phy1: phy@4 {
>> -			device_type = "ethernet-phy";
>> -			reg = <0x4>;
>> -		};
>> -	};
>> -
>> -};
>> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>> new file mode 100644
>> index 000000000000..d3d8f6799d18
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
>> @@ -0,0 +1,145 @@
>> +# SPDX-License-Identifier: GPL-2.0 OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/qcom,ethqos.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Ethernet ETHQOS device
>> +
>> +maintainers:
>> +  - Bhupesh Sharma <bhupesh.sharma@linaro.org>
>> +
>> +description:
>> +  This binding describes the dwmmac based Qualcomm ethernet devices which
>> +  support Gigabit ethernet (version v2.3.0 onwards).
>> +
>> +  So, this file documents platform glue layer for dwmmac stmmac based Qualcomm
>> +  ethernet devices.
>> +
>> +allOf:
>> +  - $ref: snps,dwmac.yaml#
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - qcom,qcs404-ethqos
>> +      - qcom,sm8150-ethqos
>> +
>> +  reg:
>> +    maxItems: 2
>> +
>> +  reg-names:
>> +    items:
>> +      - const: stmmaceth
>> +      - const: rgmii
>> +
>> +  interrupts:
>> +    items:
>> +      - description: Combined signal for various interrupt events
>> +      - description: The interrupt that occurs when Rx exits the LPI state
>> +
>> +  interrupt-names:
>> +    items:
>> +      - const: macirq
>> +      - const: eth_lpi
>> +
>> +  clocks:
>> +    maxItems: 4
>> +
>> +  clock-names:
>> +    items:
>> +      - const: stmmaceth
>> +      - const: pclk
>> +      - const: ptp_ref
>> +      - const: rgmii
>> +
>> +  iommus:
>> +    maxItems: 1
>> +
>> +  mdio:
>> +    $ref: mdio.yaml#
>> +    unevaluatedProperties: false
>> +
>> +    properties:
>> +      compatible:
>> +        const: snps,dwmac-mdio
>> +
>> +  phy-handle:
>> +    maxItems: 1
>> +
>> +  phy-mode:
>> +    maxItems: 1
>> +
>> +  snps,reset-gpio:
>> +    maxItems: 1
> 
> Why is this one here? It's already in snps,dwmac.
> 
> Actually this applies to several other properties. You have
> unevaluatedProperties:false, so you do not have to duplicate snps,dwmac.
> You only need to constrain it, like we said about interrupts in your
> previous patch.

I was actually getting errors like the following without the same:

arm64/boot/dts/qcom/qcs404-evb-1000.dtb: ethernet@7a80000: Unevaluated 
properties are not allowed ('snps,tso' was unexpected)
	From schema: Documentation/devicetree/bindings/net/qcom,ethqos.yaml

So, its not clear to me that even though 'snps,dwmac.yaml' is referenced 
here, the property appears as unevaluated.

>> +
>> +  power-domains:
>> +    maxItems: 1
>> +
>> +  resets:
>> +    maxItems: 1
>> +
>> +  rx-fifo-depth:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +
>> +  tx-fifo-depth:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +
>> +  snps,tso:
>> +    type: boolean
>> +    description: Enables the TSO feature (otherwise managed by MAC HW capability register).
> 
> You add here several new properties. Mention in commit msg changes from
> pure conversion with answer to "why".

Right, most of them are to avoid the make dtbs_check errors / warnings 
like the one mentioned above.

I will add a comment in the commit log regarding the same.

Thanks,
Bhupesh
