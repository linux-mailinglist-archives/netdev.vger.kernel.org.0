Return-Path: <netdev+bounces-6357-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0164B715ED0
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:17:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7B25A1C20BBD
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:17:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0ACF1990B;
	Tue, 30 May 2023 12:17:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8594217FF5;
	Tue, 30 May 2023 12:17:20 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97A1EE8;
	Tue, 30 May 2023 05:17:16 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-51480d3e161so5850295a12.3;
        Tue, 30 May 2023 05:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685449035; x=1688041035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmrK7zTZ4ZppdV2foagY2KFdCF3Va89SWGmPdH04y9Y=;
        b=Kk8LM6sbWvQLL/yv3oEIk5aYS0qSbVlgbsx9bq7a9hLAFNLl2MjKETUUDtyf4oTjzS
         sRIK1Xfz+TQ1+z9/1rFCo4EiuuMsqi/VhVd6ZZ5a+6f4oxyk8GaPg3cLeY9sEpf0YPnw
         2n0F2Us6jj/4YIWq7RMjxlo6yZuM4//2nKZk4z1Fc+nqsLzBPxZ7qJ4ZMla7l5irj0zV
         4ZznAbUYbNYePO4AIat0/RSCQDikJ5PBJW5V0PIGwl0Smxm+a3DTdvgGeiYRlF4nXyl0
         bMqwRq3bVOt2VfbpdTpaICXxKGj2VfskG0BdzjENyurqQ4JAXamL7PPf0btH6THKdcpZ
         sSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685449035; x=1688041035;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmrK7zTZ4ZppdV2foagY2KFdCF3Va89SWGmPdH04y9Y=;
        b=cdG9fwlASMmUw/qWYGhJ8o/ys3U+4Rs6dPvYzPDsS9ui3B9Kn9T5I0rPVejpsayAGp
         L9Jdevw5Pbt4GYrQb8hTBg7quxZIuc9ZZdUvEkNKTobWGlfCFQJyhTRA2/BW50n0aAtr
         FJwgP12qU4dMnULqtKtG6UM8Hnof4y6gDRxRAgmHwtaoMt5ks5GqWLW9+J7iD6yIsv9D
         x2b9YBeOaIvHhlEOkGtt7r0BIYbu2LHQMo/bD2Yz2GyYwGZxesDbLU1wp6Xu/r5K01PF
         g062Ok4I7XOZuzFsKK13zo1ei+JF9Hzpxc/fg62NiUbfQS11Uo7lV1QM4e6CRRaypco0
         CsiA==
X-Gm-Message-State: AC+VfDyuc4G0tEMeffbHsSlekDfqpBPz8tUwtwRPxXlTMBvzplnECWer
	Ss8tfHLGJim6XDf6FSVkqu8=
X-Google-Smtp-Source: ACHHUZ5TXwbPMq9u2DQyAi4DyAiAoDyPPlY9uFbh+v38WOBaoRDt76eK5uVQjIQGlW9TnHSnCLwWgQ==
X-Received: by 2002:a17:906:fe43:b0:973:e69d:c720 with SMTP id wz3-20020a170906fe4300b00973e69dc720mr2090870ejb.51.1685449034794;
        Tue, 30 May 2023 05:17:14 -0700 (PDT)
Received: from [192.168.0.107] ([77.124.85.177])
        by smtp.gmail.com with ESMTPSA id d14-20020a17090648ce00b0096f887f29d2sm7284020ejt.62.2023.05.30.05.17.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 05:17:14 -0700 (PDT)
Message-ID: <4ceac69b-d2ae-91b5-1b24-b02c8faa902b@gmail.com>
Date: Tue, 30 May 2023 15:17:11 +0300
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
 Nimrod Oren <noren@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>
References: <20230529110608.597534-1-tariqt@nvidia.com>
 <20230529110608.597534-2-tariqt@nvidia.com>
 <63d91da7-4040-a766-dcd7-bccbb4c02ef4@redhat.com>
From: Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <63d91da7-4040-a766-dcd7-bccbb4c02ef4@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 30/05/2023 14:33, Jesper Dangaard Brouer wrote:
> 
> 
> On 29/05/2023 13.06, Tariq Toukan wrote:
>> Expand the xdp multi-buffer support to xdp_redirect tool.
>> Similar to what's done in commit
>> 772251742262 ("samples/bpf: fixup some tools to be able to support xdp 
>> multibuffer")
>> and its fix commit
>> 7a698edf954c ("samples/bpf: Fix MAC address swapping in xdp2_kern").
>>
> 
> Have you tested if this cause a performance degradation?
> 
> (Also found possible bug below)
> 

Hi Jesper,

This introduces the same known perf degradation we already have in xdp1 
and xdp2.
Unfortunately, this is the API we have today to safely support multi-buffer.
Note that both perf and functional (noted below) degradation should be 
eliminated once replacing the load/store operations with dynptr logic 
that returns a pointer to the scatter entry instead of copying it.

I initiated a discussion on this topic a few months ago. dynptr was 
accepted since then, but I'm not aware of any in-progress followup work 
that addresses this.

>> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
>> Reviewed-by: Nimrod Oren <noren@nvidia.com>
>> ---
>>   samples/bpf/xdp_redirect.bpf.c | 16 ++++++++++++----
>>   1 file changed, 12 insertions(+), 4 deletions(-)
>>
>> diff --git a/samples/bpf/xdp_redirect.bpf.c 
>> b/samples/bpf/xdp_redirect.bpf.c
>> index 7c02bacfe96b..620163eb7e19 100644
>> --- a/samples/bpf/xdp_redirect.bpf.c
>> +++ b/samples/bpf/xdp_redirect.bpf.c
>> @@ -16,16 +16,21 @@
>>   const volatile int ifindex_out;
>> -SEC("xdp")
>> +#define XDPBUFSIZE    64
> 
> Pktgen sample scripts will default send with 60 pkt length, because the
> 4 bytes FCS (end-frame checksum) is added by hardware.
> 
> Will this result in an error when bpf_xdp_load_bytes() tries to copy 64
> bytes from a 60 bytes packet?
> 

Yes.

This can be resolved by reducing XDPBUFSIZE to 60.
Need to check if it's OK to disregard these last 4 bytes without hurting 
the XDP program logic.

If so, do you suggest changing xdp1 and xdp2 as well?

>> +SEC("xdp.frags")
>>   int xdp_redirect_prog(struct xdp_md *ctx)
>>   {
>> -    void *data_end = (void *)(long)ctx->data_end;
>> -    void *data = (void *)(long)ctx->data;
>> +    __u8 pkt[XDPBUFSIZE] = {};
>> +    void *data_end = &pkt[XDPBUFSIZE-1];
>> +    void *data = pkt;
>>       u32 key = bpf_get_smp_processor_id();
>>       struct ethhdr *eth = data;
>>       struct datarec *rec;
>>       u64 nh_off;
>> +    if (bpf_xdp_load_bytes(ctx, 0, pkt, sizeof(pkt)))
>> +        return XDP_DROP;
> 
> E.g. sizeof(pkt) = 64 bytes here.
> 
>> +
>>       nh_off = sizeof(*eth);
>>       if (data + nh_off > data_end)
>>           return XDP_DROP;
>> @@ -36,11 +41,14 @@ int xdp_redirect_prog(struct xdp_md *ctx)
>>       NO_TEAR_INC(rec->processed);
>>       swap_src_dst_mac(data);
>> +    if (bpf_xdp_store_bytes(ctx, 0, pkt, sizeof(pkt)))
>> +        return XDP_DROP;
>> +
>>       return bpf_redirect(ifindex_out, 0);
>>   }
>>   /* Redirect require an XDP bpf_prog loaded on the TX device */
>> -SEC("xdp")
>> +SEC("xdp.frags")
>>   int xdp_redirect_dummy_prog(struct xdp_md *ctx)
>>   {
>>       return XDP_PASS;
> 

