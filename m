Return-Path: <netdev+bounces-6395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D37BB716248
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:40:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 367E81C20BEE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:40:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3A142099E;
	Tue, 30 May 2023 13:40:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB392134C8;
	Tue, 30 May 2023 13:40:49 +0000 (UTC)
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC29FC7;
	Tue, 30 May 2023 06:40:47 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-4f4f8b94c06so3086788e87.1;
        Tue, 30 May 2023 06:40:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685454046; x=1688046046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SmmXWf5VDDMZcW+QNCbT/c4wqHIFll2ETEUO3d8PsKA=;
        b=q9aRVDAZ+cZ8l92OzxQqOrX4a4jGbQ2d3AIrLy33mkCpDYTogOwgxXXQAkOem8nYuf
         tcMNvNCXkg+NqZ/7CMLow4ui368c9WxjohtxdqLfMgOtGLASQ6+lIfqj2KS2/q8kOcmy
         D/TjIFkmFSzl9y0i/wa7yRfClV0J1lA3DaTmpTgqBJcLeLU3tqkIHMa+qeMz03JpRELo
         KZzzkYvsgzNSuatIMLwGTmzDgRZnHJbsPt3JpFXZYDH5diQ2Eggui8jh+V+1lAaZK1tn
         U3I2eWjDGhWQXVBYQ4yJxWjozJDyKUUKfba6IGV3tp1v0Gradx7pNbxRVK9cb9Zx9gNp
         wUVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685454046; x=1688046046;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SmmXWf5VDDMZcW+QNCbT/c4wqHIFll2ETEUO3d8PsKA=;
        b=KcmGjbQnUD1l5KOUhy3r6L0CYvznAoSuSkrW8lBtdCPvCOvcGkwEIMRIj2a3ESq6R5
         Zji2c0aM7CkrYHlDVg2x8nZCSi+dtYHe+6EYQHVHPm3A19IIFYfezp5195GPiglIysZw
         40V7RwKMyLantE16tLrmoL7sdJg+rgYSwYRl90BF+XLAZYWosUqigBsEKLM8eJubC5Iw
         BsW0tKwQ3wU0rSzr/9OfaDx3kphaC+PqhwdJcVbgbwWRSJ/Zx1uRCFQNBAz78crCZfMw
         kbDLIeK+nptSWbnIygrQbq5iB4cRbhIMFBoD+dbbzWnX6H+1pPtN9giFKOZ+WHaXswEU
         okgA==
X-Gm-Message-State: AC+VfDz8o/5oIKuepn7A5Y0yFe6yUz0WEy70fMgZ6Gank6GqCoCOSEj4
	Q/ovKUMgXKybjuqfiDBjv1M=
X-Google-Smtp-Source: ACHHUZ4w6GAJxwyL6/ORDkh3BmkW9R3onKMmQiZinaXybBNgUVHX54Lyv8nxVmX7ze1ReHJXNfiLEA==
X-Received: by 2002:a2e:3013:0:b0:2af:1120:3f6a with SMTP id w19-20020a2e3013000000b002af11203f6amr803855ljw.11.1685454045843;
        Tue, 30 May 2023 06:40:45 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id i11-20020a170906114b00b00965af4c7f07sm7293224eja.20.2023.05.30.06.40.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 06:40:45 -0700 (PDT)
Message-ID: <dc19366d-8516-9f2a-b6ed-d9323e9250c9@gmail.com>
Date: Tue, 30 May 2023 16:40:41 +0300
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
To: Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Alexei Starovoitov <ast@kernel.org>,
 John Fastabend <john.fastabend@gmail.com>, Jakub Kicinski <kuba@kernel.org>
Cc: brouer@redhat.com, Daniel Borkmann <daniel@iogearbox.net>,
 Jesper Dangaard Brouer <hawk@kernel.org>, bpf@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Gal Pressman <gal@nvidia.com>,
 Nimrod Oren <noren@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
 Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, drosen@google.com,
 Joanne Koong <joannelkoong@gmail.com>, henning.fehrmann@aei.mpg.de,
 oliver.behnke@aei.mpg.de
References: <20230529110608.597534-1-tariqt@nvidia.com>
 <20230529110608.597534-2-tariqt@nvidia.com>
 <63d91da7-4040-a766-dcd7-bccbb4c02ef4@redhat.com>
 <4ceac69b-d2ae-91b5-1b24-b02c8faa902b@gmail.com>
 <3168b14c-c9c1-b11b-2500-2ff2451eb81c@redhat.com>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <3168b14c-c9c1-b11b-2500-2ff2451eb81c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 30/05/2023 15:40, Jesper Dangaard Brouer wrote:
> 
> 
> On 30/05/2023 14.17, Tariq Toukan wrote:
>>
>> On 30/05/2023 14:33, Jesper Dangaard Brouer wrote:
>>>
>>>
>>> On 29/05/2023 13.06, Tariq Toukan wrote:
>>>> Expand the xdp multi-buffer support to xdp_redirect tool.
>>>> Similar to what's done in commit
>>>> 772251742262 ("samples/bpf: fixup some tools to be able to support 
>>>> xdp multibuffer")
>>>> and its fix commit
>>>> 7a698edf954c ("samples/bpf: Fix MAC address swapping in xdp2_kern").
>>>>
>>>
>>> Have you tested if this cause a performance degradation?
>>>
>>> (Also found possible bug below)
>>>
>>
>> Hi Jesper,
>>
>> This introduces the same known perf degradation we already have in 
>> xdp1 and xdp2.
> 
> Did a quick test with xdp1, the performance degradation is around 18%.
> 
>   Before: 22,917,961 pps
>   After:  18,798,336 pps
> 
>   (1-(18798336/22917961))*100 = 17.97%
> 
> 
>> Unfortunately, this is the API we have today to safely support 
>> multi-buffer.
>> Note that both perf and functional (noted below) degradation should be 
>> eliminated once replacing the load/store operations with dynptr logic 
>> that returns a pointer to the scatter entry instead of copying it.
>>
> 
> Well, should we use dynptr logic in this patch then?
> 

AFAIU it's not there ready to be used...
Not sure what parts are missing, I'll need to review it a bit deeper.

> Does it make sense to add sample code that does thing in a way that is 
> sub-optimal and we want to replace?
> ... (I fear people will copy paste the sample code).
> 

I get your point.
As xdp1 and xdp2 are already there, I thought that we'd want to expose 
multi-buffer samples in XDP_REDIRECT as well. We use these samples for 
internal testing.

>> I initiated a discussion on this topic a few months ago. dynptr was 
>> accepted since then, but I'm not aware of any in-progress followup 
>> work that addresses this.
>>
> 
> Are you saying some more work is needed on dynptr?
> 

AFAIU yes.
But I might be wrong... I need to revisit this.
Do you think/know that dynptr can be used immediately?

>>>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>>>> Reviewed-by: Nimrod Oren <noren@nvidia.com>
>>>> ---
>>>>   samples/bpf/xdp_redirect.bpf.c | 16 ++++++++++++----
>>>>   1 file changed, 12 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/samples/bpf/xdp_redirect.bpf.c 
>>>> b/samples/bpf/xdp_redirect.bpf.c
>>>> index 7c02bacfe96b..620163eb7e19 100644
>>>> --- a/samples/bpf/xdp_redirect.bpf.c
>>>> +++ b/samples/bpf/xdp_redirect.bpf.c
>>>> @@ -16,16 +16,21 @@
>>>>   const volatile int ifindex_out;
>>>> -SEC("xdp")
>>>> +#define XDPBUFSIZE    64
>>>
>>> Pktgen sample scripts will default send with 60 pkt length, because the
>>> 4 bytes FCS (end-frame checksum) is added by hardware.
>>>
>>> Will this result in an error when bpf_xdp_load_bytes() tries to copy 64
>>> bytes from a 60 bytes packet?
>>>
>>
>> Yes.
>>
>> This can be resolved by reducing XDPBUFSIZE to 60.
>> Need to check if it's OK to disregard these last 4 bytes without 
>> hurting the XDP program logic.
>>
>> If so, do you suggest changing xdp1 and xdp2 as well?
>>
> 
> I can take care of reducing XDPBUFSIZE to 60 on xpd1 and xdp2, as I
> already had to make these changes for the above quick bench work ;-)
> I'll send out patches shortly.
> 
> 
Thanks.

Are we fine with the above?
Should we just change the array size to 60 and re-spin?

>>>> +SEC("xdp.frags")
>>>>   int xdp_redirect_prog(struct xdp_md *ctx)
>>>>   {
>>>> -    void *data_end = (void *)(long)ctx->data_end;
>>>> -    void *data = (void *)(long)ctx->data;
>>>> +    __u8 pkt[XDPBUFSIZE] = {};
>>>> +    void *data_end = &pkt[XDPBUFSIZE-1];
>>>> +    void *data = pkt;
>>>>       u32 key = bpf_get_smp_processor_id();
>>>>       struct ethhdr *eth = data;
>>>>       struct datarec *rec;
>>>>       u64 nh_off;
>>>> +    if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
>>>> +        return XDP_DROP;
>>>
>>> E.g. sizeof(pkt) = 64 bytes here.
>>>
>>>> +
>>>>       nh_off = sizeof(*eth);
>>>>       if (data + nh_off > data_end)
>>>>           return XDP_DROP;
>>>> @@ -36,11 +41,14 @@ int xdp_redirect_prog(struct xdp_md *ctx)
>>>>       NO_TEAR_INC(rec->processed);
>>>>       swap_src_dst_mac(data);
>>>> +    if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
>>>> +        return XDP_DROP;
>>>> +
>>>>       return bpf_redirect(ifindex_out, 0);
>>>>   }
>>>>   /* Redirect require an XDP bpf_prog loaded on the TX device */
>>>> -SEC("xdp")
>>>> +SEC("xdp.frags")
>>>>   int xdp_redirect_dummy_prog(struct xdp_md *ctx)
>>>>   {
>>>>       return XDP_PASS;
>>>
>>
> 

