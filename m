Return-Path: <netdev+bounces-3668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D3470708400
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:38:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6CE9D1C2117A
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 14:38:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9508A13AF1;
	Thu, 18 May 2023 14:38:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8333C23C6A
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 14:38:11 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79634110
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:38:09 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-96598a7c5e0so336292166b.3
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 07:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684420688; x=1687012688;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TJB68kUgGSfkYFcpmVSEE26XJ5wmbNdGl8hf0140WyY=;
        b=QXC24dYERdPj7w5IyHqJSOkP2OV+NyEoktJjOctGrN44M93oC8MV8N8ACJNDiZyw3g
         4Rpt8ut143fHkcGwK6/P9gouJquw1mzjIi4xjmypiBvOc6DtUhhBHp/g3NbNNKoEX5Pv
         vQKn7eyWZTRKxJDBPBjQQI8hW9w+Y61yedZX0BFUjnDs3xkUuUTKcgrXgfdnHbWo8g0t
         vIGW9kSH1LFbX7kzWBfx0laEz88mqfQ80sqzakBCljLzp1Azu87Af8h6UVzxHA6o/6ot
         vf+rams1FbTxZZIJQ3NzIRI4B4eYndEk27BtCTcdf/hpc3JopKjcKscr/G78W4/+yK5a
         mPCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684420688; x=1687012688;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TJB68kUgGSfkYFcpmVSEE26XJ5wmbNdGl8hf0140WyY=;
        b=GI5R6xQdgcQJdogKM6BotOZE8jdgKEa02QnNb/lPREELgH/P+4Ht6ypSJ+oG5if5Y7
         FFOwpP6P143KKqqZUMaSFXTbzQmGjcAk7aVUC3llxA3cc+9jwrxhJce+vb8eqNgCH4Ah
         dLlawdnehnnxjiSJyqIokejsxxJk6cQ3OktjJf0otTGYE9zjYKCLahRVUyW/FQB2hNu0
         CsVqi4LCGEXjx/1JmyxNB9h1OBDVEnToxRL4IW/h1waycsXl/A8oZ4hYVvciwZ9g5j7b
         kuCX1C/SDyznomxRNpwUUCMFfTMw52w4wwvOsdDf7ZudrCOUjWxaxJoMcLF8UxtJjV7e
         9Xow==
X-Gm-Message-State: AC+VfDyTvAy0TdSX5y9fJYXZBQmgMCD1TMRRBfvQ/ALB//jYHPbWCrjI
	VnNO9IxKoEmpfSsVkFuGaruWDQ==
X-Google-Smtp-Source: ACHHUZ5OY62Jnuu4B35AUP+mSoCx9lsYdrzczRWwud1XT5I9W4/XGfvXHS9KlHBKFtC9FLytNd8tNw==
X-Received: by 2002:a17:906:58d4:b0:96f:504b:4672 with SMTP id e20-20020a17090658d400b0096f504b4672mr416887ejs.13.1684420687886;
        Thu, 18 May 2023 07:38:07 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:7e24:6d1b:6bf:4249? ([2a02:810d:15c0:828:7e24:6d1b:6bf:4249])
        by smtp.gmail.com with ESMTPSA id f4-20020a05640214c400b0050e04125a46sm637734edx.10.2023.05.18.07.38.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 07:38:07 -0700 (PDT)
Message-ID: <9e84a332-4b31-6f90-8d06-78f49d4f1275@linaro.org>
Date: Thu, 18 May 2023 16:38:06 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Content-Language: en-US
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "edumazet@google.com" <edumazet@google.com>,
 "kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com"
 <pabeni@redhat.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>,
 "krzysztof.kozlowski+dt@linaro.org" <krzysztof.kozlowski+dt@linaro.org>
Cc: "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
 "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Sarangi, Anirudha" <anirudha.sarangi@amd.com>,
 "Katakam, Harini" <harini.katakam@amd.com>, "git (AMD-Xilinx)" <git@amd.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <a5e18c4f-b906-5c9d-ec93-836401dcd3ea@linaro.org>
 <MW5PR12MB5598ED29E01601585963D5D0876C9@MW5PR12MB5598.namprd12.prod.outlook.com>
 <MW5PR12MB55984CA9A0C4E87E46C6029D877F9@MW5PR12MB5598.namprd12.prod.outlook.com>
 <e3d09e6a-4e34-30b5-7f6c-3ed275e1d8d1@linaro.org>
In-Reply-To: <e3d09e6a-4e34-30b5-7f6c-3ed275e1d8d1@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 18/05/2023 16:34, Krzysztof Kozlowski wrote:
> On 18/05/2023 08:17, Gaddam, Sarath Babu Naidu wrote:
>>
>>
>>> -----Original Message-----
>>> From: Gaddam, Sarath Babu Naidu
>>> Sent: Wednesday, May 3, 2023 3:01 PM
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
>>>> Sent: Tuesday, May 2, 2023 3:56 PM
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
>>>> On 28/03/2023 14:52, Gaddam, Sarath Babu Naidu wrote:
>>>>>
>>>>>
>>>>>> -----Original Message-----
>>>>>> From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>>>>>> Sent: Tuesday, March 14, 2023 9:22 PM
>>>>>> To: Gaddam, Sarath Babu Naidu
>>>>>> <sarath.babu.naidu.gaddam@amd.com>; davem@davemloft.net;
>>>>>> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com;
>>>>>> robh+dt@kernel.org; krzysztof.kozlowski+dt@linaro.org
>>>>>> Cc: michal.simek@xilinx.com; radhey.shyam.pandey@xilinx.com;
>>>>>> netdev@vger.kernel.org; devicetree@vger.kernel.org; linux-arm-
>>>>>> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Sarangi,
>>>>>> Anirudha <anirudha.sarangi@amd.com>; Katakam, Harini
>>>>>> <harini.katakam@amd.com>; git (AMD-Xilinx) <git@amd.com>
>>>>>> Subject: Re: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet:
>>>>>> convert bindings document to yaml
>>>>>>
>>>>>> On 08/03/2023 07:12, Sarath Babu Naidu Gaddam wrote:
>>>>>>> From: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
>>>>>>>
>>>>>>> Convert the bindings document for Xilinx AXI Ethernet Subsystem
>>>> from
>>>>>>> txt to yaml. No changes to existing binding description.
>>>>>>>
>>>>>>
>>>>>> (...)
>>>>>>
>>>>>>> +properties:
>>>>>>> +  compatible:
>>>>>>> +    enum:
>>>>>>> +      - xlnx,axi-ethernet-1.00.a
>>>>>>> +      - xlnx,axi-ethernet-1.01.a
>>>>>>> +      - xlnx,axi-ethernet-2.01.a
>>>>>>> +
>>>>>>> +  reg:
>>>>>>> +    description:
>>>>>>> +      Address and length of the IO space, as well as the address
>>>>>>> +      and length of the AXI DMA controller IO space, unless
>>>>>>> +      axistream-connected is specified, in which case the reg
>>>>>>> +      attribute of the node referenced by it is used.
>>>>>>
>>>>>> Did you test it with axistream-connected? The schema and
>>>>>> description feel contradictory and tests would point the issue.
>>>>>
>>>>> Thanks for review comments. We tested with axistream-connected
>>> and
>>>> did
>>>>> not observe any errors. Do you anticipate any issues/errors ?
>>>>
>>>> Yes, I anticipate errors. What you wrote here looks incorrect based on
>>>> the schema.
>>>>
>>>> Also, See also my further comments (or you ignored them?).
>>>>
>>>> You can come many months after my review to ask about details, to be
>>>> sure I will forget the topic.
>>>
>>>
>>> Hi Krzysztof, Apologies for miscommunication. I replied to this thread on
>>> March 28 and said that I would address remaining review comments in
>>> the next version.
>>>
>>> Lore link:
>>> https://lore.kernel.org/all/MW5PR12MB559880B0E220BDBD64E06D24
>>> 87889@MW5PR12MB5598.namprd12.prod.outlook.com/
>>> https://lore.kernel.org/all/MW5PR12MB5598678BB9AB6EC2FFC424F48
>>> 7889@MW5PR12MB5598.namprd12.prod.outlook.com/
>>>
>>> I planned to send next version with phy-mode and pcs-handle maxItems
>>> fixed.but I wanted to close on the axistream-connected discussion before
>>> doing so.
>>>
>>> Related to axistream-connected discussion:
>>> I already ran dt binding check for schema and dts node validation. I
>>> assume this should point any errors on it.
> 
> And how do we know that you tested correct DTS with it?
> 
>>>
>>
>> Hi Krzysztof, Could you please comment on this ? Please let me if I missed
>> any changes or comments.
> 
> I don't think anything improved in this patchset. The binding has
> incomplete and I believe incorrect constraints for axistream-connected.
> You did not provide DTS to prove me otherwise. If you are not going to
> fix the issue nor provide DTS, what I can say more? Looks wrong.

I think my concerns would be solved if you extend the example with a
correct second possibility - device with axistream-connected. An
example, which will match all your constraints and all your descriptions
(we expect then not having any reg, right?).

Best regards,
Krzysztof


