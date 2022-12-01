Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B303063ED7C
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 11:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiLAKTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 05:19:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbiLAKTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 05:19:04 -0500
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F1A3983BD
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 02:19:03 -0800 (PST)
Received: by mail-lf1-x12c.google.com with SMTP id bp15so1724419lfb.13
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 02:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:references:cc:to:content-language:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuxOJHGDccJjZFhK+Cj93qZjBJ3bjpMlB1Gplol81Gg=;
        b=YXOlmvvd/tYT37+FhjtNXMi/mmXPmR95cfKWQRopG0ACX0voka4wCVc0OPkepSCbTW
         vFIfKbOC6jZEz96oNoQFHVlcX1S8GRGpT7loa965cMNPtmamduN8UdEs717P0s76WkHL
         0cGKaaoPCoKjr/C3AQcekADZuXKqXcGHV3ZjDTiF4+1DNkzFFeKfAU2uWcjsjm05kftv
         hFKNhUW4NNTlJR/XJmpinhSD3fS4tcdF+HgvBiNxDnc7i8jQSeDzl92ZyFuJ7WA/vhYd
         QW/V4dH4SflKzKOhYDP7ZjZhpyXSYUTBuI9vuJ71kctEEUS/1OfiZwfESqgN6/YPZTdS
         3GpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:disposition-notification-to
         :from:references:cc:to:content-language:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PuxOJHGDccJjZFhK+Cj93qZjBJ3bjpMlB1Gplol81Gg=;
        b=To8VdyK7zP/KhClelZJs7LaOb5YbzC/Y4cNK4DLsM6leGJmvNDpkQrYAysl8oSPvi3
         vFlLluNqCIvam3Zc4KCht8OGc3MbCcScZ50elkL5A4j3H/MzBdIXMRjCwGiTWakNpPv3
         n8klM3PoS6fqukx60aquZRvRF0Mlo+U/x5eElUTKfMP/hmZH2UVlveA8vqizuxmHgj5b
         Lf9QL5xYReG4miS5WwGAnfM92szNSSyIupA70qo6s5Xe1TqxEJd13qtPeytxmvx+te7+
         vY7AQHmii//9yJ3HeVGHwkTLnDNAw7YaUj/nI14j/hXeyM7vTzIIagpnEDlnIapcnQnl
         habA==
X-Gm-Message-State: ANoB5pleJaYbo1VX8dZaYCfOi8VJAq+dJQrA4ZpRQskUSzNARkqK8qG9
        dnq6iNPdhjwGgDhjsXY3DsS9LQ==
X-Google-Smtp-Source: AA0mqf5kw+8XS6ZLadwpWrejVH29wqbJkJyk83BuiQZoq56zId52NTX3XXb6QFrpvw5kDEIXHt5Ipg==
X-Received: by 2002:a05:6512:3762:b0:4ac:5faa:654d with SMTP id z2-20020a056512376200b004ac5faa654dmr20387148lft.684.1669889941691;
        Thu, 01 Dec 2022 02:19:01 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id m6-20020ac24286000000b004b501497b6fsm594625lfh.148.2022.12.01.02.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 02:18:59 -0800 (PST)
Message-ID: <9778695f-f8a9-e361-e28f-f99525c96689@linaro.org>
Date:   Thu, 1 Dec 2022 11:18:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2 2/5] dt-bindings: net: add schema for NXP S32CC dwmac
 glue driver
Content-Language: en-US
To:     =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>,
        Chester Lin <clin@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-3-clin@suse.com>
 <4a7a9bf7-f831-e1c1-0a31-8afcf92ae84c@linaro.org>
 <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <560c38a5-318a-7a72-dc5f-8b79afb664ca@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2022 18:33, Andreas Färber wrote:
> Hi Krysztof,
> 
> Am 30.11.22 um 16:51 schrieb Krzysztof Kozlowski:
>> On 28/11/2022 06:49, Chester Lin wrote:
>>> Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
>>> Chassis.
>>>
>>> Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
>>> Signed-off-by: Chester Lin <clin@suse.com>
>>
>> Thank you for your patch. There is something to discuss/improve.
>>
>>> ---
>>>
>>> Changes in v2:
>>>    - Fix schema issues.
>>>    - Add minItems to clocks & clock-names.
>>>    - Replace all sgmii/SGMII terms with pcs/PCS.
>>>
>>>   .../bindings/net/nxp,s32cc-dwmac.yaml         | 135 ++++++++++++++++++
>>>   1 file changed, 135 insertions(+)
>>>   create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
>>> new file mode 100644
>>> index 000000000000..c6839fd3df40
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
> [...]
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - nxp,s32cc-dwmac
>>> +
>>> +  reg:
>>> +    items:
>>> +      - description: Main GMAC registers
>>> +      - description: S32 MAC control registers
>>> +
>>> +  dma-coherent: true
>>> +
>>> +  clocks:
>>> +    minItems: 5
>>
>> Why only 5 clocks are required? Receive clocks don't have to be there?
>> Is such system - only with clocks for transmit - usable?

Any comments here? If not, drop minItems.

>>
>>> +    items:
>>> +      - description: Main GMAC clock
>>> +      - description: Peripheral registers clock
>>> +      - description: Transmit PCS clock
>>> +      - description: Transmit RGMII clock
>>> +      - description: Transmit RMII clock
>>> +      - description: Transmit MII clock
>>> +      - description: Receive PCS clock
>>> +      - description: Receive RGMII clock
>>> +      - description: Receive RMII clock
>>> +      - description: Receive MII clock
>>> +      - description:
>>> +          PTP reference clock. This clock is used for programming the
>>> +          Timestamp Addend Register. If not passed then the system
>>> +          clock will be used.
>>> +
>>> +  clock-names:
>>> +    minItems: 5
>>> +    items:
>>> +      - const: stmmaceth
>>> +      - const: pclk
>>> +      - const: tx_pcs
>>> +      - const: tx_rgmii
>>> +      - const: tx_rmii
>>> +      - const: tx_mii
>>> +      - const: rx_pcs
>>> +      - const: rx_rgmii
>>> +      - const: rx_rmii
>>> +      - const: rx_mii
>>> +      - const: ptp_ref
>>> +
>>> +  tx-fifo-depth:
>>> +    const: 20480
>>> +
>>> +  rx-fifo-depth:
>>> +    const: 20480
>>> +
>>> +required:
>>> +  - compatible
>>> +  - reg
>>> +  - tx-fifo-depth
>>> +  - rx-fifo-depth
>>> +  - clocks
>>> +  - clock-names
>>> +
>>> +unevaluatedProperties: false
>>> +
>>> +examples:
>>> +  - |
>>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>>> +    #include <dt-bindings/interrupt-controller/irq.h>
>>> +
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_AXI
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_PCS
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_PCS
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
>>> +    #define S32GEN1_SCMI_CLK_GMAC0_TS
>>
>> Why defines? Your clock controller is not ready? If so, just use raw
>> numbers.
> 
> Please compare v1: There is no Linux-driven clock controller here but 
> rather a fluid SCMI firmware interface. Work towards getting clocks into 
> a kernel-hosted .dtsi was halted in favor of (downstream) TF-A, which 
> also explains the ugly examples here and for pinctrl.

This does not explain to me why you added defines in the example. Are
you saying these can change any moment?

> 
> Logically there are only 5 input clocks; however due to SCMI not 
> supporting re-parenting today, some clocks got duplicated at SCMI level. 
> Andrew appeared to approve of that approach. I still dislike it but 
> don't have a better proposal that would work today. So the two values 
> above indeed seem wrong and should be 11 rather than 5.

You should rather fix firmware then create some incorrect bindings as a
workaround...

Best regards,
Krzysztof

