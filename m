Return-Path: <netdev+bounces-7609-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FB97720DC2
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9A871C2122C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 04:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF61E1FD5;
	Sat,  3 Jun 2023 04:20:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06371FCE
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 04:20:25 +0000 (UTC)
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB1FE55;
	Fri,  2 Jun 2023 21:20:24 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d2e1a72fcca58-64d57cd373fso3026885b3a.1;
        Fri, 02 Jun 2023 21:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685766023; x=1688358023;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FMCJesx+orcQ9tVlanHdUdQLiDUTLtWDjNYa8dP5/z8=;
        b=pDo1iqW2kRynbw5SZpKMZ7uNolpp5uLD3hL+tXf4wkIY4WDIrxvFEK/sOovxNkVALo
         Cr1vgiA0gHzSCiGKJMKY48E1jEXRnEADLKfIWGTpakkCf4rn+Pk6IwwN9efm78stl9fE
         Wsu1ofmtdyGjwvqY5cVNzyELC66IGodsiTFsEPwQYC6OsTsZFaZ//7N7gv8oqrvAFy7P
         UDdblRKw0z82PoEbCfWLD2MlaaiwnMJ44caVCRLPjRq9fgn90bYFTjAYTBzQHGsrmpu4
         cFz8wd3A/glmnKDFq6hKK+lDrkdBehK0L1B/MZU3oyRgDhJjGmzNFThujuZHbM25Xvaw
         Lq1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685766023; x=1688358023;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FMCJesx+orcQ9tVlanHdUdQLiDUTLtWDjNYa8dP5/z8=;
        b=PNyn44RgWcB58wJ9cyQmMbtqPWxpvHMxdtpOeq5yT9k9f8rey/FDjuIKtfGd+s5tNg
         UXFGd6vhm3SRa5S2DSqkOxVpojjqqbdPgdxWF07sfKfGpCaoClnvFck3OTMlMzLKsYvq
         9BmsPGyoHCHVGIr12Q4KTTcZb6CoEK5OshkDmJTjn7gerQpZ4s2aNmcoE7rJRORk6bei
         zyZFuQh2f59BuzUSvodvwRtdNomtXvhzLFRFSP1Htld5cTrtVdyRDtHuf9xhCgfjJAs0
         EWkGS/fb7KdCApaK34FO/8lTToCePT3zND1o36rPCjp1plPLy1L5ouRXXkQjcFAc55di
         8faA==
X-Gm-Message-State: AC+VfDyBbFmNZGb5PBdcNAQFWCihQ2oDxlMJo+yiUaRF6cpxSvQaq11b
	d0geOHdKICskPHZS8NJQpJ4=
X-Google-Smtp-Source: ACHHUZ6xUJdSbZBD+gJNbLHmGaaOr90/y8vM9JWadFL80drP7MpCYM2LgV7cTZXQZqyUQGfqEJ5iew==
X-Received: by 2002:a05:6a20:734a:b0:10e:96a4:e31d with SMTP id v10-20020a056a20734a00b0010e96a4e31dmr702780pzc.22.1685766023400;
        Fri, 02 Jun 2023 21:20:23 -0700 (PDT)
Received: from ?IPv6:2409:8a55:301b:e120:3d47:213a:3f9e:50ab? ([2409:8a55:301b:e120:3d47:213a:3f9e:50ab])
        by smtp.gmail.com with ESMTPSA id s6-20020a656906000000b0051b0e564963sm1822923pgq.49.2023.06.02.21.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 21:20:22 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/3] page_pool: support non-frag page for
 page_pool_alloc_frag()
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-3-linyunsheng@huawei.com>
 <977d55210bfcb4f454b9d740fcbe6c451079a086.camel@gmail.com>
 <2e4f0359-151a-5cff-6d31-0ea0f014ef9a@huawei.com>
 <CAKgT0UcGYXstFP_H8VQtUooYEaYgDpG_crkodYOEyX4q0D58LQ@mail.gmail.com>
 <8c9d5dd8-b654-2d50-039d-9b7732e7746f@huawei.com>
 <CAKgT0UchHBO+kyPZMYJR7JHfqYsk+qSeuvXzA-H9w3VH-9Tfrg@mail.gmail.com>
From: Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <f5e372ca-e637-4873-0bea-b1b19c623124@gmail.com>
Date: Sat, 3 Jun 2023 12:20:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0UchHBO+kyPZMYJR7JHfqYsk+qSeuvXzA-H9w3VH-9Tfrg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/2 23:57, Alexander Duyck wrote:
> On Fri, Jun 2, 2023 at 5:23 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:

...

>>
>> According to my defination in this patchset:
>> frag page: page alloced from page_pool_alloc_frag() with page->pp_frag_count
>>            being greater than one.
>> non-frag page:page alloced return from both page_pool_alloc_frag() and
>>               page_pool_alloc_pages() with page->pp_frag_count being one.
>>
>> I assume the above 'non-page pool pages' refer to what I call as 'non-frag
>> page' alloced return from both page_pool_alloc_frag(), right? And it is
>> still about doing the (size << 1 > max_size)' checking at the begin instead
>> of at the middle right now to avoid extra steps for 'non-frag page' case?
> 
> Yeah, the non-page I was referring to were you mono-frag pages.

I was using 'frag page' and 'non-frag page' per the defination above,
and you were using 'mono-frag' mostly and 'non-page' sometimes.
I am really confused by them as I felt like I got what they meant and
then I was lost when you used them in the next comment. I really hope
that you could describe what do you mean in more detailed by using
'mono-frag pages' and 'non-page', so that we can choose the right
naming to continue the discussion without further misunderstanding
and confusion.

> 
>>>
>>>>>
>>>>>> -    if (page && *offset + size > max_size) {
>>>>>> +    if (page) {
>>>>>> +            *offset = pool->frag_offset;
>>>>>> +
>>>>>> +            if (*offset + size <= max_size) {
>>>>>> +                    pool->frag_users++;
>>>>>> +                    pool->frag_offset = *offset + size;
>>>>>> +                    alloc_stat_inc(pool, fast);
>>>>>> +                    return page;
>>>>
>>>> Note that we still allow frag page here when '(size << 1 > max_size)'.
>>
>> This is the optimization I was taking about: suppose we start
>> from a clean state with 64K page size, if page_pool_alloc_frag()
>> is called with size being 2K and then 34K, we only need one page
>> to satisfy caller's need as we do the '*offset + size > max_size'
>> checking before the '(size << 1 > max_size)' checking.
> 
> The issue is the unaccounted for waste. We are supposed to know the
> general size of the frags being used so we can compute truesize. If

Note, for case of veth and virtio_net, the driver may only know the
current frag size when calling page_pool_alloc_frag(), it does not
konw what is the size of the frags will be used next time, how exactly
are we going to compute the truesize for cases with different frag
size?  As far as I can tell, we may only do something like virtio_net
is doing with 'page_frag' for the last frag as below, for other frags,
the truesize may need to take accounting to the aligning requirement:
https://elixir.bootlin.com/linux/v6.3.5/source/drivers/net/virtio_net.c#L1638

> for example you are using an order 3 page and you are splitting it
> between a 2K and a 17K fragment the 2K fragments will have a massive
> truesize underestimate that can lead to memory issues if those smaller
> fragments end up holding onto the pages.
> 
> As such we should try to keep the small fragments away from anything
> larger than half of the page.

IMHO, doing the above only alleviate the problem. How is above splitting
different from splitting it evently with 16 2K fragments, and when 15 frag
is released, we still have the last 2K fragment holding onto 32K memory,
doesn't that also cause massive truesize underestimate? Not to mention that
for system with 64K page size.

In RFC patch below, 'page_pool_frag' is used to report the truesize, but
I was thinking both 'page_frag' and 'page_frag_cache' both have a similiar
problem, so I dropped it in V1 and left that as a future improvement.
 
I can pick it up again if 'truesize' is really the concern, but we have to
align on how to compute the truesize here first.

https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.2465-4-linyunsheng@huawei.com/

