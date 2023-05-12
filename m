Return-Path: <netdev+bounces-2038-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3117070005A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:28:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC28B2819EE
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 289591C2F;
	Fri, 12 May 2023 06:27:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAB2111D
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 06:27:15 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F70C2D47
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:27:12 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bc2feb320so14687411a12.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 23:27:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683872830; x=1686464830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t/ckmPuAa4ujFgIFKMwM+2v/s58OS1qXxZvL0TqJDU4=;
        b=MHlhJFtEiJr+HM6PQUV+d9EhQAarkJRnrOnrct4NKLDL1DGQjpRa36VsvtQpclp6f5
         NOBTtHgMLy6txOr+ng4mQrWTHyYQXgEmKWVBti0F29cDEgbZC6eqyIPcTroTVJJiTEx0
         I6jRTBpklhuW1A7rS6AzYhqfuASSc7W8M1h1mceh4zJ6Zm2ikXo9EsJk7ju0YmSG0BCY
         plWmv6Qdr6QW/RLz0s0tvnZ4CY8oLDxlFUfzbqciaElId1wpw715yyPXTPenH58+gWtc
         HVr1QQ3KHXR/5IUCbdN/NlkfHAakDpWFIJ/RmKZaoN8ZWJDBcgrDIyo36kxD8yw0wdDU
         Ukcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683872830; x=1686464830;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=t/ckmPuAa4ujFgIFKMwM+2v/s58OS1qXxZvL0TqJDU4=;
        b=kq8XvHQRJmWshT3vj6wRW0OcXcBnbmmxtDgcH8Xo8OogUcyQL8Y98i9ZWuEnRRJJ68
         0Yq95C5F0Rh0LSjeNhFo9iMTcS61lMV2FEfb6gUJhINvTtyVXil6P4iSJuDX3/xxfILb
         cpzQUWvoYr+la7D3vGRperXLruO0+izwAamZj1MJPOB5/YvYJirFOK6l3PWlezFbamuv
         3vutsgblQcRoIUZez4MozoyUWfXkeGZ2eMUAn+hG5SOTywv/hGXUWotcceLqN6qUEm3C
         fN4t4RiNtO53WLsJn5XLKrIry0vTONzStu/yLB4c8sVUzevqHvocsv1oxOGbPon0FNoS
         wdsw==
X-Gm-Message-State: AC+VfDx7jdXruNQ94RR9mXeLxaCqRmWY3qZjN3XETAU3IT9QGguF4hYX
	bIEJXEbs7/J20Qrtdl/ynOTaRBfJN/H1tl+Jh6U=
X-Google-Smtp-Source: ACHHUZ5PeyRWIdTJ3kr5Sg6p5WslJiaX0h8HEgKXIeQ+HXUm1hIoVEhYBI1RCHRaWCee1N9oMjr4qg==
X-Received: by 2002:aa7:cb86:0:b0:502:23a2:6739 with SMTP id r6-20020aa7cb86000000b0050223a26739mr16839436edt.28.1683872830598;
        Thu, 11 May 2023 23:27:10 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7ede:fc7b:2328:3883? ([2a02:810d:15c0:828:7ede:fc7b:2328:3883])
        by smtp.gmail.com with ESMTPSA id h8-20020aa7de08000000b005083bc605f9sm3621291edv.72.2023.05.11.23.27.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 23:27:09 -0700 (PDT)
Message-ID: <fe2989c2-2d90-286f-0492-2b07720afcf9@linaro.org>
Date: Fri, 12 May 2023 08:27:08 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Content-Language: en-US
To: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@google.com" <edumazet@google.com>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>,
 "krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>
Cc: "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "Simek, Michal" <michal.simek@amd.com>,
 "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
 "Katakam, Harini" <harini.katakam@amd.com>, "git (AMD-Xilinx)" <git@amd.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
 <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
 <MW5PR12MB55986A4865DB56F7F024EA7687749@MW5PR12MB5598.namprd12.prod.outlook.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB55986A4865DB56F7F024EA7687749@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11/05/2023 13:32, Gaddam, Sarath Babu Naidu wrote:
> 
> 
>> -----Original Message-----
>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>> Sent: Wednesday, May 10, 2023 3:39 PM
>> To: Gaddam, Sarath Babu Naidu
>> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
>> Cc: linux@armlinux.org.uk; Simek, Michal <michal.simek@amd.com>;
>> Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>;
>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>> Subject: Re: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
>> Introduce dmaengine binding support
>>
>> On 10/05/2023 10:50, Sarath Babu Naidu Gaddam wrote:
>>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>>
>>> The axiethernet driver will use dmaengine framework to communicate
>>> with dma controller IP instead of built-in dma programming sequence.
>>
>> Subject: drop second/last, redundant "bindings". The "dt-bindings"
>> prefix is already stating that these are bindings.
>>
>> Actually also drop "dmaenging" as it is Linuxism. Focus on hardware, e.g.
>> "Add DMA support".
>>
>>>
>>> To request dma transmit and receive channels the axiethernet driver
>>> uses generic dmas, dma-names properties.
>>>
>>> Also to support the backward compatibility, use "dmas" property to
>>> identify as it should use dmaengine framework or legacy
>>> driver(built-in dma programming).
>>>
>>> At this point it is recommended to use dmaengine framework but it's
>>> optional. Once the solution is stable will make dmas as required
>>> properties.
>>>
>>> Signed-off-by: Radhey Shyam Pandey
>> <radhey.shyam.pandey@xilinx.com>
>>> Signed-off-by: Sarath Babu Naidu Gaddam
>>> <sarath.babu.naidu.gaddam@amd.com>
>>> ---
>>> These changes are on top of below txt to yaml conversion discussion
>>> https://lore.kernel.org/all/20230308061223.1358637-1-
>> sarath.babu.naidu
>>> .gaddam@amd.com/#Z2e.:20230308061223.1358637-1-
>> sarath.babu.naidu.gadda
>>> m::40amd.com:1bindings:net:xlnx::2caxi-ethernet.yaml
>>>
>>> Changes in V3:
>>> 1) Reverted reg and interrupts property to  support backward
>> compatibility.
>>> 2) Moved dmas and dma-names properties from Required properties.
>>>
>>> Changes in V2:
>>> - None.
>>> ---
>>>  .../devicetree/bindings/net/xlnx,axi-ethernet.yaml   | 12
>> ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git
>>> a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
>>> b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
>>> index 80843c177029..9dfa1976e260 100644
>>> --- a/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
>>> +++ b/Documentation/devicetree/bindings/net/xlnx,axi-ethernet.yaml
>>> @@ -122,6 +122,16 @@ properties:
>>>        modes, where "pcs-handle" should be used to point to the PCS/PMA
>> PHY,
>>>        and "phy-handle" should point to an external PHY if exists.
>>>
>>> +  dmas:
>>> +    items:
>>> +      - description: TX DMA Channel phandle and DMA request line
>> number
>>> +      - description: RX DMA Channel phandle and DMA request line
>>> + number
>>> +
>>> +  dma-names:
>>> +    items:
>>> +      - const: tx_chan0
>>
>> tx
>>
>>> +      - const: rx_chan0
>>
>> rx
> 
> We want to support more channels in the future, currently we support
> AXI DMA which has only one tx and rx channel. In future we want to 
> extend support for multichannel DMA (MCDMA) which has 16 TX and
> 16 RX channels. To uniquely identify each channel, we are using chan
> suffix. Depending on the usecase AXI ethernet driver can request any
> combination of multichannel DMA  channels.
> 
> dma-names = tx_chan0, tx_chan1, rx_chan0, rx_chan1;
> 
> will update the commit message with same.

I expect the binding to be complete, otherwise you get comments like
this. Add missing parts to the binding and resend.

Best regards,
Krzysztof


