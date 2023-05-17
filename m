Return-Path: <netdev+bounces-3374-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 550E4706B89
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:48:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AEC01C20F20
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:48:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 687333D90;
	Wed, 17 May 2023 14:48:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F11C26
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:48:38 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944D03C0C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:48:36 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-510d9218506so162685a12.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:48:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684334915; x=1686926915;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=elvq0HJ66cNTWAPxUlVMN+GA2+ufgNIYZmKlf1bKE8k=;
        b=jmxWX2Hqep6vnItCfquyL4U0/eXi1cZdZsjpxkc1mZ8b0gd9rHAG0PWwAF9MTFi032
         dFnf3vhPW4W7KF3nmL36359po+98NHdO7P72IyggzX2g+z5qBZ2WUFt7DyVEs6OfyJtG
         uXvZL0ZoWSM0wxX5nkvM+spVf6bTID6yhMXs3lLsE7r0HcVoUEIHvMAwIreOvSFPFp7q
         e45BhCbAqJszQd6nFsfu7D0xQrRvgXsuKC+O9Rog7D38WESf/XyxcMhozRi+PTMV2S/c
         tAxMVehKJ19ocmLDMZxZ6kZp/vjvp10QwatUHMen9Yx5XDp09mJom+0OjuDWArXVwptw
         nR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684334915; x=1686926915;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=elvq0HJ66cNTWAPxUlVMN+GA2+ufgNIYZmKlf1bKE8k=;
        b=lZzeW9tZpPqn49kceE3I61Lg9DmxQ9HxZCNQs5RcGq6V/5rvx5smitpelRsU5O5YbU
         Htwd5bRbzwyJyBaudbDI9fwvvYOMhHHw7Zq2FFdMh4NqkTP0kFz+p7MNtZN/CPTFokLA
         8j6XsTeL3m71OmylHJ8nmgdlm0cs6KyrXEZtTgAA665LQ8Cwq+QUFMp2Pp71wOJ5axS5
         Zcdui71LdJq3Omdo0/DKihEy8HlqfuSawa8tCkW+Txq3rAoeJkP1vP2hntwUMN6NRIGR
         9SIOmNjDL6dGPl787SCaR40/5bJLt6VsB785LVjiIk42g592Wy+9SS0CM6A4AQUuEOrt
         3n2g==
X-Gm-Message-State: AC+VfDxoxq+fCSubRcDORrFz/5Gxbp8yrvEgV3ezSWzqDu1yJrgfrIhw
	VwWnEV29hDNxC4PPgi2g5boh7A==
X-Google-Smtp-Source: ACHHUZ7u2N7bCmDcp4Y15qBMsgz6bSdlw0qZZSEJUJZGSKF0JWiEAQtQGmDA7ZrNlC5N0a2zBmn3kw==
X-Received: by 2002:a05:6402:35c2:b0:4fc:97d9:18ec with SMTP id z2-20020a05640235c200b004fc97d918ecmr2062220edc.21.1684334915088;
        Wed, 17 May 2023 07:48:35 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:c9ff:4c84:dd21:568d? ([2a02:810d:15c0:828:c9ff:4c84:dd21:568d])
        by smtp.gmail.com with ESMTPSA id s13-20020aa7c54d000000b00506b2af49fbsm9257750edr.81.2023.05.17.07.48.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 07:48:34 -0700 (PDT)
Message-ID: <d8af7985-49d7-021c-a51e-271d7b731971@linaro.org>
Date: Wed, 17 May 2023 16:48:33 +0200
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
 <fe2989c2-2d90-286f-0492-2b07720afcf9@linaro.org>
 <MW5PR12MB55983A529A1F57A39C7A61B7877E9@MW5PR12MB5598.namprd12.prod.outlook.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <MW5PR12MB55983A529A1F57A39C7A61B7877E9@MW5PR12MB5598.namprd12.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17/05/2023 14:06, Gaddam, Sarath Babu Naidu wrote:
>>>>> +  dma-names:
>>>>> +    items:
>>>>> +      - const: tx_chan0
>>>>
>>>> tx
>>>>
>>>>> +      - const: rx_chan0
>>>>
>>>> rx
>>>
>>> We want to support more channels in the future, currently we support
>>> AXI DMA which has only one tx and rx channel. In future we want to
>>> extend support for multichannel DMA (MCDMA) which has 16 TX and
>>> 16 RX channels. To uniquely identify each channel, we are using chan
>>> suffix. Depending on the usecase AXI ethernet driver can request any
>>> combination of multichannel DMA  channels.
>>>
>>> dma-names = tx_chan0, tx_chan1, rx_chan0, rx_chan1;
>>>
>>> will update the commit message with same.
>>
>> I expect the binding to be complete, otherwise you get comments like this.
>> Add missing parts to the binding and resend.
> 
> Binding is complete for current supported DMA (single channel).  We will
> extend when we add MCDMA.

What doe sit mean "current supported DMA"? By driver? or by hardware? If
the former, then how does it matter for the bindings?

If the latter, then your hardware is going to change? Then you will have
different set of compatibles and then can use different names.

> 
> We will describe the reason for using channel suffix in the description as 
> below. 
> 
>    dma-names:
>       items:
>         - const: tx_chan0
>         - const: rx_chan0
>      description: |
>            Chan suffix is used for identifying each channel uniquely.
>            Current DMA has only one Tx and Rx channel but it will be 
>            extended to support for multichannel DMA (MCDMA) which
>            has 16 TX and 16 RX channels. Depending on the usecase AXI
>            ethernet driver can request any combination of multichannel
>            DMA  channels.

No, because I don't understand what is "will be extended". Bindings
should be complete. If they are going to be extended, it means they are
not complete. If they cannot be complete, which happens, please provide
a reason. There was no reason so far, except your claim it is complete.

Best regards,
Krzysztof


