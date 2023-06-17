Return-Path: <netdev+bounces-11734-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C3F734104
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 14:47:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E0951C20AC8
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 12:47:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E13079F4;
	Sat, 17 Jun 2023 12:47:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0CD6FDF;
	Sat, 17 Jun 2023 12:47:33 +0000 (UTC)
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD361707;
	Sat, 17 Jun 2023 05:47:32 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id d2e1a72fcca58-668709767b1so25797b3a.2;
        Sat, 17 Jun 2023 05:47:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687006051; x=1689598051;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=s/acIp633u5069UftowfGMeRhhzHgCDz05qkDUeZBLo=;
        b=EAAJPyo0ddKj6069c9ABznlrPKu8phS+LE7gil6pVTKZSc8som44aawVPPrkFZk+q3
         3xUGPkO1dK3lauYT5iqYZr/r3dE9posVFaiWVwQzdAj34ABw7qpFRm7Kr21RDGdM2mAe
         QOTvypRYkAK9g96rmQo4iyHMYYw6Rpq6eY0LVWqclv1g1vmOD+Df88Ie9iO7+sxbRaCe
         rbQSyrgWW/zWw1YKwyW6PRVPuUzY5bALZ6+nwhFbkjWvyFw/JNPX26IAL2sesJYo0iRQ
         dzYDAsf8X6OoKU6D0lZZpMIae0l5gWLwp0a8pu2yxpfcX6Cqi8AcLuFCZkxlxHKIpVy0
         yRXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687006051; x=1689598051;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s/acIp633u5069UftowfGMeRhhzHgCDz05qkDUeZBLo=;
        b=VkPaSZK/I4WTJSrftCpHI6C3qmTreSg+l92QHTbtc6KIcV0WGhgxQhVj5iZVUChMS3
         sJhXTF2an5Go1CT0Wq9FunsBSgpFM5NXnMPNU5JaHcxZ8YtO++NCprWUByEPSGV+TseW
         YzlKdQGdblB8Zk8Ck40cBSpU8vX5aNM4lXIdsdNsfSCv9xtiaYV3iut6vMrxXBYH+YQw
         dppw4sI1N+2FYdofmtBlZNKZ1+ojeXbtoG0x6YOrMzoQbMfZcks4MnQIk8NXBadJv/S7
         ZqH/K1ouuoKwTEd4ytw51zRJPe4rkTYdlcf8i1UlkJJbPAgmmd6Fm2micwRt5ROGglua
         Is7w==
X-Gm-Message-State: AC+VfDxGYtMkFI01aMr4duZDdKyxmwVKnz98+WlxT+qJbjo1WoZyikju
	lxJc0OwTpcLfZJC5wObp/9K3ynXdTFdhhMyVqWc=
X-Google-Smtp-Source: ACHHUZ6E6CA+xWPDuQyMmJkv3N5gSRFr7sh1GIg+lwqT5Fi7NQCGjdTVDWwWc//LGCMXoZfLZSYFvw==
X-Received: by 2002:a05:6a00:24cd:b0:64d:1451:8233 with SMTP id d13-20020a056a0024cd00b0064d14518233mr4322314pfv.21.1687006051155;
        Sat, 17 Jun 2023 05:47:31 -0700 (PDT)
Received: from ?IPv6:2409:8a55:301b:e120:18ac:7176:4598:6838? ([2409:8a55:301b:e120:18ac:7176:4598:6838])
        by smtp.gmail.com with ESMTPSA id v17-20020a63f211000000b00543b4433aa9sm6237943pgh.36.2023.06.17.05.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jun 2023 05:47:30 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc: Yunsheng Lin <linyunsheng@huawei.com>, brouer@redhat.com,
 davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>, Maryam Tahhan <mtahhan@redhat.com>,
 bpf <bpf@vger.kernel.org>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
 <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
 <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com>
 <CAKgT0UfzP30OiBQu+YKefLD+=32t+oA6KGzkvsW6k7CMTXU8KA@mail.gmail.com>
From: Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <a80a095d-1f02-a8bf-f658-66ae114a6e4b@gmail.com>
Date: Sat, 17 Jun 2023 20:47:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UfzP30OiBQu+YKefLD+=32t+oA6KGzkvsW6k7CMTXU8KA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/17 1:34, Alexander Duyck wrote:
...

>>>
>>> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
>>> index 614f3e3efab0..8850394f1d29 100644
>>> --- a/drivers/net/veth.c
>>> +++ b/drivers/net/veth.c
>>> @@ -736,7 +736,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>>          if (skb_shared(skb) || skb_head_is_locked(skb) ||
>>>              skb_shinfo(skb)->nr_frags ||
>>>              skb_headroom(skb) < XDP_PACKET_HEADROOM) {
>>> -               u32 size, len, max_head_size, off;
>>> +               u32 size, len, max_head_size, off, truesize, page_offset;
>>>                  struct sk_buff *nskb;
>>>                  struct page *page;
>>>                  int i, head_off;
>>> @@ -752,12 +752,15 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>>>                  if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
>>>                          goto drop;
>>>
>>> +               size = min_t(u32, skb->len, max_head_size);
>>> +               truesize = size;
>>> +
>>>                  /* Allocate skb head */
>>> -               page = page_pool_dev_alloc_pages(rq->page_pool);
>>> +               page = page_pool_dev_alloc(rq->page_pool, &page_offset, &truesize);
>>
>> Maybe rename API to:
>>
>>   addr = netmem_alloc(rq->page_pool, &truesize);

Unless we create a subsystem called netmem, I am not sure about
the 'netmem', it seems more confusing to use it here.

>>
>>>                  if (!page)
>>>                          goto drop;
>>>
>>> -               nskb = napi_build_skb(page_address(page), PAGE_SIZE);
>>> +               nskb = napi_build_skb(page_address(page) + page_offset, truesize);
>>
>> IMHO this illustrates that API is strange/funky.
>> (I think this is what Alex Duyck is also pointing out).
>>
>> This is the memory (virtual) address "pointer":
>>   addr = page_address(page) + page_offset
>>
>> This is what napi_build_skb() takes as input. (I looked at other users
>> of napi_build_skb() whom all give a mem ptr "va" as arg.)
>> So, why does your new API provide the "page" and not just the address?
>>
>> As proposed above:
>>    addr = netmem_alloc(rq->page_pool, &truesize);
>>
>> Maybe the API should be renamed, to indicate this isn't returning a "page"?
>> We have talked about the name "netmem" before.
> 
> Yeah, this is more-or-less what I was getting at. Keep in mind this is
> likely the most common case since most frames passed and forth aren't
> ever usually much larger than 1500B.

I do feel the pain here, there is why I use a per cpu 'struct
page_pool_frag' to report the result back to user so that we
can report both 'va' and 'page' to the user in the RFC of this
patchset.

IHMO, compared to the above point, it is more importance that
we have a unified implementation for both of them instead
of page frag based on the page allocator.

Currently there are three implementations for page frag:
1. mm/page_alloc.c: net stack seems to be using it in the
   rx part with 'struct page_frag_cache' and the main API
   being page_frag_alloc_align().
2. net/core/sock.c: net stack seems to be using it in the
   tx part with 'struct page_frag' and the main API being
   skb_page_frag_refill().
3. drivers/vhost/net.c: vhost seems to be using it to build
   xdp frame, and it's implementation seems to be a mix of
   the above two.

Acctually I have a patchset to remove the third one waiting
to send out after this one.

And I wonder if the first and second one can be unified as
one, as it seems the only user facing difference is one
returning va, and the other returning page. other difference
seems to be implementation specific, for example, one is
doing offset incrementing, and the other doing offset
decrementing.

