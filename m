Return-Path: <netdev+bounces-6781-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46747717F69
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:02:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E07B81C20CE5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:02:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2935B14280;
	Wed, 31 May 2023 12:02:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B2B1426E;
	Wed, 31 May 2023 12:02:25 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D738E5;
	Wed, 31 May 2023 05:02:23 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f3a99b9177so6767003e87.1;
        Wed, 31 May 2023 05:02:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685534542; x=1688126542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qFZKgasN50SJ2Zttn6fl+wdI2tjJW7B3g+qODK8XLIk=;
        b=N3Fy3ffKa39UUCGLN7TMG4xTIqKv9ctI3itWZUAwQiYjVokiO62l+XRmCw4t7bXHRQ
         aWBEgIS0gAi+T7Ve41g4731jtWcnG2K9OfuDL+WMRwGf/wicQA3PFiayvCj5Gf/2MlQg
         anXE3I8KuV+dVuD5hXH+kG4WTkXAtbS279cEzs6RlnPsLm70AL8jBIQ7e5iahTkrfyeh
         FdqTJtyG+C8mTmMeHhj6TPC8fziup1j2evBx1MrNbl+NiezM00+Pl+2fMhihcioyoY/+
         dYtOcRzOXa/Yxh0f4nPusIf4v/MEO/H34PoapjNbmqRyRPLGx3j/niVP0LxhmKr7Wz31
         Kw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685534542; x=1688126542;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qFZKgasN50SJ2Zttn6fl+wdI2tjJW7B3g+qODK8XLIk=;
        b=Gvns3TVOqCyLOLOlAPU2+CRNZDPsJ3Tvm6f8ZqWw7PW2WdaZFPbm3082FSy1wqVofp
         30XOxC+h6kfNfIv2oDhqcD/j4WGvfMuqu8gCNzFovUylKQpwHL7p+4AzG+jbO19LLDyW
         /33dGyDeiPllOFungIRYuN9cUikPZHUr8+uWKbVfg8WnY6tS5l8yxO2Y0PlExX2nd2ug
         Rns9u4V8uxt2PMKhwyVxUl4E2M/gSkXLkDBrEkSizKXc1XkpaPbWCLCqKIER1LSevKSb
         vB2TkFz/LGRdl+4Jb/KcdMQd8OZ7utR58d7/kTwgK3gb3rXz+TBfrtWqSpq6d5+dwmSq
         GVUg==
X-Gm-Message-State: AC+VfDyASquOTmzpD890D/BYpZQ2mMLOR/u5dCzUXpGVLz5MK9QOV540
	MU34yBcQ7DPH7oMM28dQULlZBQIEsKA=
X-Google-Smtp-Source: ACHHUZ59sm/K5OIpfYtQn50DFg4TdYjySsUTdmGvkr/W+SVEA0OhI5/Mko5/cCNDYXvVlFW2lJ4XdQ==
X-Received: by 2002:ac2:418a:0:b0:4f3:a7d3:28e0 with SMTP id z10-20020ac2418a000000b004f3a7d328e0mr2366037lfh.28.1685534541565;
        Wed, 31 May 2023 05:02:21 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id l18-20020a05600c1d1200b003f61177faffsm3640231wms.0.2023.05.31.05.02.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 05:02:21 -0700 (PDT)
Message-ID: <2b9c7d6b-0fa4-404a-9fbb-80f581c2f294@gmail.com>
Date: Wed, 31 May 2023 15:02:17 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH bpf-next 1/2] samples/bpf: fixup xdp_redirect tool to be
 able to support xdp multibuffer
Content-Language: en-US
To: Martin KaFai Lau <martin.lau@linux.dev>
Cc: brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
 Nimrod Oren <noren@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, drosen@google.com,
 Joanne Koong <joannelkoong@gmail.com>, henning.fehrmann@aei.mpg.de,
 oliver.behnke@aei.mpg.de, Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
References: <20230529110608.597534-1-tariqt@nvidia.com>
 <20230529110608.597534-2-tariqt@nvidia.com>
 <63d91da7-4040-a766-dcd7-bccbb4c02ef4@redhat.com>
 <4ceac69b-d2ae-91b5-1b24-b02c8faa902b@gmail.com>
 <3168b14c-c9c1-b11b-2500-2ff2451eb81c@redhat.com>
 <dc19366d-8516-9f2a-b6ed-d9323e9250c9@gmail.com>
 <cf3903b0-9258-d000-c8b4-1f196ea726c5@linux.dev>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <cf3903b0-9258-d000-c8b4-1f196ea726c5@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 30/05/2023 20:22, Martin KaFai Lau wrote:
> On 5/30/23 6:40 AM, Tariq Toukan wrote:
>>>> I initiated a discussion on this topic a few months ago. dynptr was 
>>>> accepted since then, but I'm not aware of any in-progress followup 
>>>> work that addresses this.
>>>>
>>>
>>> Are you saying some more work is needed on dynptr?
>>>
>>
>> AFAIU yes.
>> But I might be wrong... I need to revisit this.
>> Do you think/know that dynptr can be used immediately?
> 
> Not sure if you are aware of the bpf_dynptr_slice[_rdwr]() which could 
> be useful here. It only does a copy when the requested slice is across 
> different frags:
> https://lore.kernel.org/all/20230301154953.641654-10-joannelkoong@gmail.com/
> 

Thanks for the pointer. I missed it. Looks promising!
I'll take a deeper look soon and do some perf tests.

