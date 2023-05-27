Return-Path: <netdev+bounces-5921-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 260D1713577
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 17:44:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B188B281516
	for <lists+netdev@lfdr.de>; Sat, 27 May 2023 15:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D247A134BA;
	Sat, 27 May 2023 15:44:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7161134A4
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 15:44:17 +0000 (UTC)
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BE7BE
	for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:44:16 -0700 (PDT)
Received: by mail-oo1-xc31.google.com with SMTP id 006d021491bc7-557ca32515eso879752eaf.3
        for <netdev@vger.kernel.org>; Sat, 27 May 2023 08:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1685202255; x=1687794255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Dgko2iplP6bp/b7NPlMDQ44IMQxH2NK5gWXH95pmqI=;
        b=hthB0pCcmFaOsYRVVKv3k2RJ9PRavU+um7qHlaHv3CuO6xm1S/EXJhj6f5HVhuBuMd
         3S+o0CtIo01HE6e4gOm5qxQ2WzG+Rf73xMyER7eNV2+BDzCXSGmSTcf3nvRwwm7i6Tb3
         AxJYXz1TvDPHrr2P6pu1dHqBq7DTIMY4dnacbN65LpEWqE5aKLy4A350ytgMuVP1Auuu
         7eOS1NnDqC4UJOXmZrmUmBFZcO6eAGt3Woe6+SYBzO2fr2p5PzOn3akmOcoO0vz8O2ik
         zesZiEYIcBeQFyhbFavGDmmZLFvybQK3tj723JXr2lh3AkbcxzDgoVyM/WkFZJqiPhYT
         YOfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685202255; x=1687794255;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6Dgko2iplP6bp/b7NPlMDQ44IMQxH2NK5gWXH95pmqI=;
        b=dusDy9Wgx7yVrritKySec23DPL61t5eMe08ebDmrXxo5X5ocSd7FURYOCX/mXZDT9N
         5Syz8YxHuMjX1YIKVhGHXthVW7sag46cS20avLWIIXCEyTw3I/YYl3Vxrv1H2hcUXJpB
         sxeaUJ+7efHsBSnwBBNGBKzZ34BMueWWHbfsu0IIkEbMZ1CHxuK2eXcAexQ80EdRkreM
         WKQQ+AaoeqJ3c0UhCQI9R0K+OBSzyYLC/AEMC3gt0e8w8RAHMFwXPn11Kl9/dyvZF0db
         hkCLWxiGeFvuhnKVzW7S5QdkEXA7vYDFS17uaCLdrVVLQ1e0HeJkb5DYyPtDvxR2SedM
         lmXg==
X-Gm-Message-State: AC+VfDzQJdBUI53NGA3ZwQBWbC61TB2VD6AyLNoBvpxX8lS1Oij7WE0l
	RfLUinl2vw6uVu0RENHrSGdfSg==
X-Google-Smtp-Source: ACHHUZ6nbmm9rWSb/Fv79c80mJfUaX/iyV+lJieXu+ryr/+6ql2kmOKmWDwp5XTZLRt5RHWcRl1A0Q==
X-Received: by 2002:a05:6808:158a:b0:398:4870:d2ed with SMTP id t10-20020a056808158a00b003984870d2edmr3865922oiw.13.1685202255548;
        Sat, 27 May 2023 08:44:15 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:44fb:c676:faf5:b4eb:6b9a? ([2804:14d:5c5e:44fb:c676:faf5:b4eb:6b9a])
        by smtp.gmail.com with ESMTPSA id k67-20020aca3d46000000b00399ed3b7c56sm1530811oia.35.2023.05.27.08.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 27 May 2023 08:44:15 -0700 (PDT)
Message-ID: <886e2fe3-1c24-c0d3-8434-964767fd03ad@mojatatu.com>
Date: Sat, 27 May 2023 12:44:11 -0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH v2] net/sched: act_pedit: Parse L3 Header for L4 offset
Content-Language: en-US
To: Josh Hunt <johunt@akamai.com>, Max Tottenham <mtottenh@akamai.com>,
 netdev@vger.kernel.org
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Cong Wang
 <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
 Amir Vadai <amir@vadai.me>, kernel test robot <lkp@intel.com>
References: <20230526095810.280474-1-mtottenh@akamai.com>
 <5587e78a-acfe-edfa-6b6b-c35bea34f5a3@mojatatu.com>
 <b693fce4-7a05-ce88-ebe0-27b6fa03ed2f@mojatatu.com>
 <2d7ad6a9-2cd4-7936-7dc5-b6c79cd8c02e@akamai.com>
From: Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <2d7ad6a9-2cd4-7936-7dc5-b6c79cd8c02e@akamai.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 26/05/2023 18:54, Josh Hunt wrote:
> On 5/26/23 7:03 AM, Pedro Tammela wrote:
>> On 26/05/2023 10:47, Pedro Tammela wrote:
>>>
>>>> +
>>>> +    switch (skb->protocol) {
>>>> +    case htons(ETH_P_IP):
>>>> +        if (!pskb_may_pull(skb, sizeof(*iph) + noff))
>>>> +            goto out;
>>>
>>> I might have missed something but is this really needed?
>>> https://urldefense.com/v3/__https://elixir.bootlin.com/linux/latest/source/net/ipv4/ip_input.c*L456__;Iw!!GjvTz_vk!TyuEOA10ZxgU7TBKFX6HAZ359qEMEuo3H0jNMIF1EP75tQbrs8uiSNQSpaaW4N34AH1sCdf5vHcUrV0qsw$ 
>>
>> Yes this obviously happens before the mentioned function.
>> Now I'm wondering if it's not better to use skb_header_pointer() 
>> instead...
> 
> Can you elaborate on why you think it would be better?
> 

I don't have a strong argument for one over the other and I believe it's 
fine as is.
It just looks like 'skb_header_pointer()' is a more conservative 
approach as ithas a smaller margin for errorwhen compared to 
'pskb_may_pull()'.
But I shall admit that the errors conditions for 'pskb_may_pull()' are 
extreme.


