Return-Path: <netdev+bounces-6747-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BFD7D717C21
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:38:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F60D1C209E2
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:38:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97ED512B64;
	Wed, 31 May 2023 09:38:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85031D30F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:38:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADAE0188
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685525931;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D12BVYZkMZ9K5aiiVxmRPYSP+1AHSP+xHRpGJRV/KYk=;
	b=iiK7Ojbb4xp3j6GZdxvoF5wETXv4NXryGbFoYNFIppzQ5DASCH8cIgVnaeBmgh0uNhLT2J
	zT7gISEkHWyrJHRJR8ChfPk1wj9dIJZPet7PqiQZ1gd1QcCofx9UOa88ymHThCbgoEVeBz
	xWpOA+jI9rPBOSmu4fxbkaYM8PhxqPo=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-vRhlJqHzNFCgNOzl-hxoXg-1; Wed, 31 May 2023 05:38:50 -0400
X-MC-Unique: vRhlJqHzNFCgNOzl-hxoXg-1
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-96fb396ee3dso456800666b.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 02:38:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685525929; x=1688117929;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D12BVYZkMZ9K5aiiVxmRPYSP+1AHSP+xHRpGJRV/KYk=;
        b=VudNWJ4/mp1mxK/yUpYqtCbWVGhAWzqgOIILgQdHXLcNgwWBYhddxanRancE1Meol1
         FcIF55K9gxywC9cfWsaEad386sI+jAB1D8IF1ixiA6lee3A1GhpQz/lslekiS7wjLjDh
         1XLm5b4uoTaF1BROJ/Ot1UvQ3lXh4brsLEdzxcXc1wO35Gv/KoSf7iQYbFToazwKjJWN
         L9Qa/RxsbW+pBD7XawNzeRUeCY++zRk31W7sdm10OfiXWXlZRB1mRCwzSK7rmxBlkwW8
         OSCUyzL39TlWqTHTQU4WS32qYMxVUbdTPpLmQcygG9P7cFXo88ytPNPK8cPXNBM5mOI0
         9C4w==
X-Gm-Message-State: AC+VfDxoWUxjQgIf8clKR6qPvM5s9PUanGBJWyBubrEUXCAjFHVL45vc
	QPFuP8ONfdKNjx/0/zdkrDFx6zVguI86EHkRU7xmg796Dh5lYPjS0xhh/rmDO0+SclOVxEvL6sV
	cSZE1JXfiP+R2jBsK
X-Received: by 2002:a17:907:930b:b0:973:cc48:f19d with SMTP id bu11-20020a170907930b00b00973cc48f19dmr4440106ejc.52.1685525929492;
        Wed, 31 May 2023 02:38:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5kSwRVjitOYnK18/zj+Q3nsbVR80CzeIPsdMvTfA0DnDOPFmdte6ADe1m18Dohrybw+SCrFg==
X-Received: by 2002:a17:907:930b:b0:973:cc48:f19d with SMTP id bu11-20020a170907930b00b00973cc48f19dmr4440093ejc.52.1685525929146;
        Wed, 31 May 2023 02:38:49 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id kq10-20020a170906abca00b00960005e09a3sm8618199ejb.61.2023.05.31.02.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 02:38:48 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <0ba065fb-bb19-1319-b77a-065077e11011@redhat.com>
Date: Wed, 31 May 2023 11:38:47 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, gal@nvidia.com, lorenzo@kernel.org,
 netdev@vger.kernel.org, andrew.gospodarek@broadcom.com,
 Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH bpf-next] samples/bpf: xdp1 and xdp2 reduce XDPBUFSIZE to
 60
Content-Language: en-US
To: Tariq Toukan <ttoukan.linux@gmail.com>,
 Daniel Borkmann <borkmann@iogearbox.net>, Alexei Starovoitov
 <ast@kernel.org>, Andrii Nakryiko <andrii.nakryiko@gmail.com>,
 bpf@vger.kernel.org
References: <168545704139.2996228.2516528552939485216.stgit@firesoul>
 <948629b6-8607-9797-8897-7d3e0535fa7b@gmail.com>
In-Reply-To: <948629b6-8607-9797-8897-7d3e0535fa7b@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 31/05/2023 09.23, Tariq Toukan wrote:
> 
> 
> On 30/05/2023 17:30, Jesper Dangaard Brouer wrote:
>> Default samples/pktgen scripts send 60 byte packets as hardware
>> adds 4-bytes FCS checksum, which fulfils minimum Ethernet 64 bytes
>> frame size.
>>
>> XDP layer will not necessary have access to the 4-bytes FCS checksum.
>>
>> This leads to bpf_xdp_load_bytes() failing as it tries to copy
>> 64-bytes from an XDP packet that only have 60-bytes available.
>>
>> Fixes: 772251742262 ("samples/bpf: fixup some tools to be able to 
>> support xdp multibuffer")
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   samples/bpf/xdp1_kern.c |    2 +-
>>   samples/bpf/xdp2_kern.c |    2 +-
>>   2 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/samples/bpf/xdp1_kern.c b/samples/bpf/xdp1_kern.c
>> index 0a5c704badd0..d91f27cbcfa9 100644
>> --- a/samples/bpf/xdp1_kern.c
>> +++ b/samples/bpf/xdp1_kern.c
>> @@ -39,7 +39,7 @@ static int parse_ipv6(void *data, u64 nh_off, void 
>> *data_end)
>>       return ip6h->nexthdr;
>>   }
>> -#define XDPBUFSIZE    64
>> +#define XDPBUFSIZE    60
> 
> Perf with the presence of load/store copies is far from being optimal..
> Still, do we care if memcpy of 60 bytes performs worse than 64 (full 
> cacheline)?

In this case that statement isn't true. I tested it and the
60 bytes define performs (slightly) better than 64 bytes one.

> Maybe not really in this case, looking forward for the replacement of 
> memcpy with the proper dyncptr API.
>

This is a fix to allow sending minimum sized Ethernet frames to these 
samples.

Looking forward, yes once dynptr is ready, we should update these
samples to use that, because the use of bpf_xdp_load_bytes() have a
surprisingly large overhead. But we cannot leave these samples broken in
the mean while.


> Other than that:
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
> 

Thanks

> 
>>   SEC("xdp.frags")
>>   int xdp_prog1(struct xdp_md *ctx)
>>   {
>> diff --git a/samples/bpf/xdp2_kern.c b/samples/bpf/xdp2_kern.c
>> index 67804ecf7ce3..8bca674451ed 100644
>> --- a/samples/bpf/xdp2_kern.c
>> +++ b/samples/bpf/xdp2_kern.c
>> @@ -55,7 +55,7 @@ static int parse_ipv6(void *data, u64 nh_off, void 
>> *data_end)
>>       return ip6h->nexthdr;
>>   }
>> -#define XDPBUFSIZE    64
>> +#define XDPBUFSIZE    60
>>   SEC("xdp.frags")
>>   int xdp_prog1(struct xdp_md *ctx)
>>   {
>>
>>
> 


