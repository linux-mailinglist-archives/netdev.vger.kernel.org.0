Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C75B6F41A0
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 12:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbjEBK3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 06:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjEBK2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 06:28:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727BAE9
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 03:28:06 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-956eacbe651so724151166b.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 03:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683023285; x=1685615285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wqd93aNECfZIIUkAvlmaD8fXXrRjBdmwtaQb0yapHxI=;
        b=c75B+WHrK3Ojj0utRU31iQI+Ebymm9/nKHez/ap/eyqo2vjpzr48Z2AkIQrheNYGQB
         cBYYar+YRkF9XPsH4naZ3bPgPkya2uL4KZcZdi9t4QDjHAm6re3Gia87Te7beR10Q7F1
         4oILqmpbzfZSQtM9I4QYjxaP3PFg9Jle+1b0UhEziAA3aXEDSuOtAwiIW61nRV1a2EWB
         SiFNBOX3D2rtz9d68B4SHm6lY/MB8YOvX+YxG0HHPQsyWYR2WUEBmqUn0QZfjGw/Zlzy
         xzHRTulGp6iQl2tjFiTSrI1+JEoWyvqY+FjfRRYQ6lyOoV2yaxlD7H4x91Twq56tswyX
         /BiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683023285; x=1685615285;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wqd93aNECfZIIUkAvlmaD8fXXrRjBdmwtaQb0yapHxI=;
        b=Vg1cCnVDyyc1VB+TbxmWEeCnq6bTPIS7BmhQVpA1L3LS5CBU8UrcXe3Dp/3M9X5yJc
         5z1ZSreIhtWP2JhPVKYz0BwnVj8KSORizCFUcxcSYVHCQffR+/uGusK7TiEzsYx8Wos/
         Mz+rSAMOxXVHuOyA92rNVE7j1dDt+HQ9eNiuT8rikdZZQyILBuD/1e1OsL/FGjPYxwCs
         wkDejJ4tWoirlM2n5PzrQoBe0+zYpXx3xcrlaEdNIQgwpaSBYn4Ld50Ah2VJYhXgJl2M
         Nba6YZGJ5OBoH9QhXTougD+Kaq3fqTb/ko2gKXJbD0KRL1jKx6R/miJNIEIPKd7kd4x1
         eGUA==
X-Gm-Message-State: AC+VfDw1vW6k5O5+FFSOoPppnH4I1ZEP5wSoQADsrnVAXUYTl30eJ4dI
        eelpIgKoW2lYue/edPwHRjiIlg==
X-Google-Smtp-Source: ACHHUZ6xKE5OQ1aUkpe0sTeaLjdNFiuH8CIzUPZxWC1Eb+v23BRFtrYMccIop4BXahiHbZJDbGX4qg==
X-Received: by 2002:a17:907:2d8f:b0:946:2fa6:3b85 with SMTP id gt15-20020a1709072d8f00b009462fa63b85mr16985359ejc.36.1683023284914;
        Tue, 02 May 2023 03:28:04 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:bafd:1283:b136:5f6a? ([2a02:810d:15c0:828:bafd:1283:b136:5f6a])
        by smtp.gmail.com with ESMTPSA id kw15-20020a170907770f00b0094f8ff0d899sm15618402ejc.45.2023.05.02.03.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 May 2023 03:28:04 -0700 (PDT)
Message-ID: <04112f5c-231d-559a-39f9-d183e8985a87@linaro.org>
Date:   Tue, 2 May 2023 12:28:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
To:     "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>
Cc:     "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
        "Katakam, Harini" <harini.katakam@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <MW5PR12MB5598678BB9AB6EC2FFC424F487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <MW5PR12MB559857065E298E7A8485305D876F9@MW5PR12MB5598.namprd12.prod.outlook.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB559857065E298E7A8485305D876F9@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/05/2023 12:09, Gaddam, Sarath Babu Naidu wrote:
> 
> 
>> -----Original Message-----
>> From: Gaddam, Sarath Babu Naidu
>> <sarath.babu.naidu.gaddam@amd.com>
>> Sent: Tuesday, March 28, 2023 9:31 PM
>> To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>;
>> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>> pabeni@redhat.com; robh+dt@kernel.org;
>> krzysztof.kozlowski+dt@linaro.org
>> Cc: michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>> Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
>> convert bindings document to yaml
>>
>>
>>
>>> -----Original Message-----
>>> From: Gaddam, Sarath Babu Naidu
>>> <sarath.babu.naidu.gaddam@amd.com>
>>> Sent: Tuesday, March 28, 2023 6:22 PM
>>> To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>;
>>> davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
>>> pabeni@redhat.com; robh+dt@kernel.org;
>>> krzysztof.kozlowski+dt@linaro.org
>>> Cc: michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com;
>>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>>> Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
>>> convert bindings document to yaml
>>>
>>>
>>>
>>>> -----Original Message-----
>>>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>> Sent: Tuesday, March 14, 2023 9:22 PM
>>>> To: Gaddam, Sarath Babu Naidu
>>>> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
>>>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>>>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
>>>> Cc: michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com;
>>>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>>>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>>>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>>>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>>>> Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
>>>> convert bindings document to yaml
>>>>
>>>> On 08/03/2023 07:12, Sarath Babu Naidu Gaddam wrote:
>>>>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>>>>
>>>>> Convert the bindings document for Xilinx AXI Ethernet Subsystem
>>> from
>>>>> txt to yaml. No changes to existing binding description.
>>>>>
>>>>
>>>> (...)
>>>>
>>>>> +properties:
>>>>> +  compatible:
>>>>> +    enum:
>>>>> +      - xlnx,axi-ethernet-1.00.a
>>>>> +      - xlnx,axi-ethernet-1.01.a
>>>>> +      - xlnx,axi-ethernet-2.01.a
>>>>> +
>>>>> +  reg:
>>>>> +    description:
>>>>> +      Address and length of the IO space, as well as the address
>>>>> +      and length of the AXI DMA controller IO space, unless
>>>>> +      axistream-connected is specified, in which case the reg
>>>>> +      attribute of the node referenced by it is used.
>>>>
>>>> Did you test it with axistream-connected? The schema and description
>>>> feel contradictory and tests would point the issue.
>>>
>>> Thanks for review comments. We tested with axistream-connected and
>> did
>>> not observe any errors. Do you anticipate any issues/errors ?
>>
>> Just to add more details, we have tested it using below dt node
>>
>> 	axienet@0 {
>> 	        axistream-connected = <&dma>;
>>                         reg = <0x00 0x80000000 0x00 0x40000>;
>>                         compatible = "xlnx,axi-ethernet-2.01.a";
>>                         clock-names = "s_axi_lite_clk\0axis_clk\0ref_clk";
>>                         clocks = <0x03 0x47 0x03 0x47 0x18>;
>>                         phy-mode = "sgmii";
>>                         xlnx,rxcsum = <0x02>;
>>                         xlnx,rxmem = <0x1000>;
>>                         xlnx,txcsum = <0x02>;
>>                         pcs-handle = <0x19>;
>>                         phy-handle = <0x78>;
>>                         dmas = <0x17 0x00 0x17 0x01>;
>>                         dma-names = "tx_chan0\0rx_chan0";
>>                         mac-address = [ff ff ff ff ff ff];
>>                         managed = "in-band-status";
>>                         phandle = <0x79>;
>> 		mdio {
>>                                 #address-cells = <0x01>;
>>                                 #size-cells = <0x00>;
>>
>>                                 phy@0 {
>>                                         compatible = "ethernet-phy-ieee802.3-c22";
>>                                         reg = <0x00>;
>>                                         phandle = <0x78>;
>>                                 };
>>
>>                                 ethernet-phy@2 {
>>                                         device_type = "ethernet-phy";
>>                                         reg = <0x02>;
>>                                         phandle = <0x19>;
>>                                 };
>>                         };
>> 	};
>> This DT node works with our board. "&dma" is the dma DT node  and to
>> test the second case where dma  address and length  included  in the
>> axienet reg's property as below "reg = <0x00 0x80000000 0x00 0x40000
>> 0x0 0x80040000 0x0 0x1000>;"
>>
>> I did not observe any issue with above two cases. Used below command
>> to validate the yaml using above DT node.
>> make dtbs_check
>> DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/xlnx,axi-
>> ethernet.yaml
>>
> 
> Hi Krzysztof,  Can you please comment If above explanation is acceptable ?
> I will address remaining review comments and send the next version.

The DTS you pointed obviously cannot work with the binding - it has
obvious mistakes. Starting with phy-mode. So whatever you did, was not
correct testing. Since nothing from your code is upstream, I cannot
verify it.

Upstream your DTS first.

Best regards,
Krzysztof

