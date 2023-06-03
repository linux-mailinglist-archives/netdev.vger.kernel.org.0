Return-Path: <netdev+bounces-7655-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E37F572101E
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:59:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4BF981C20D83
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 12:59:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1502C2EA;
	Sat,  3 Jun 2023 12:59:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5DE88F53
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 12:59:25 +0000 (UTC)
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E93133;
	Sat,  3 Jun 2023 05:59:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1b024e29657so15375125ad.3;
        Sat, 03 Jun 2023 05:59:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685797163; x=1688389163;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vqX0LTk5Fo0oh7IvoKNP8D426Vb6iaJ7IPUyhFLI2EE=;
        b=fRJ7NqkO9WiwbkFaGaMq3PLlERhCI3lKTGGuHtCkKVnown5UEjt0seLPT7aloAl59i
         K9t3QApV3REZbJNeh4NbvZybWJ8+qJuB672PXxqRbCsjUqazOIyRFrkpBIZ+sLC6AmXa
         eNIySc6pyCartprWtJnddKWw6JIIAQ7XJ0vDNRFrM5e5PV2a8iJNv7cBpSPemzSMduSM
         SOuS3CNtWlk/WcCVnFZ9R66XAZ8dPvJv9sUJ0zCPmS5rIcXETrJnRHO4hE0u/nZbGOcK
         dqZemULXS7q9eMkT3yAmk8F9QwJvLM/3oQOfEbn9zc95Bbr7WMRaYifCv2QP120oQTw5
         EFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685797163; x=1688389163;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vqX0LTk5Fo0oh7IvoKNP8D426Vb6iaJ7IPUyhFLI2EE=;
        b=MmhbmvVdctZeC8PcKaKruGwyzwkji2xb0ln4VOKwhNiFR9X9vDzWFjTnrWG1eWOcAt
         UG9sFPZt08GQL7JzhX17Rr3vvjWhwauzLv9tXSxZAhzghGh8+ZSl1wpQHWybp9H3X7BN
         dLxYQMt/1gChP37NrKNXSZ/UAXFU58nNshxp+KzLcRLtUg/VhLXfeK356W2BG/thfWCQ
         GQJgxjn1diR6wDorO5nY1Kb08J2QKsMQm/9XYYV0AuPEX/buhCRM8HWVjLUxwbZdlbYo
         FXdAptBhRErZKIQ7r3wPQP67vwaLGb6vyVPmBcOatp+DGLxTBVJJ5ZA9bsz+UhRgOG4A
         tF4Q==
X-Gm-Message-State: AC+VfDxsg483JwmxD6e5cME0HxSwMhM7mT3dOJH0Ojc/OU+tyKIGV620
	z/Vsb/qvAiO5wkuMSpEz6nk=
X-Google-Smtp-Source: ACHHUZ7b8XCpEhuBlBk51H+SwTQgjDIJldJkehRVD1HhUbH0o16KpHlW/I+l/vuMD0Lbo6bQptVCmQ==
X-Received: by 2002:a17:902:ee95:b0:1a9:9ace:3e74 with SMTP id a21-20020a170902ee9500b001a99ace3e74mr1081216pld.65.1685797162609;
        Sat, 03 Jun 2023 05:59:22 -0700 (PDT)
Received: from ?IPv6:2409:8a55:301b:e120:3d47:213a:3f9e:50ab? ([2409:8a55:301b:e120:3d47:213a:3f9e:50ab])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902db8500b001a4fe00a8d4sm3147092pld.90.2023.06.03.05.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Jun 2023 05:59:22 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/3] page_pool: unify frag page and non-frag
 page handling
To: Alexander H Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>
References: <20230529092840.40413-1-linyunsheng@huawei.com>
 <20230529092840.40413-2-linyunsheng@huawei.com>
 <e8db47e3fe99349a998ded1ce4f8da88ea9cc660.camel@gmail.com>
 <5d728f88-2bd0-7e78-90d5-499e85dc6fdf@huawei.com>
 <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
From: Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <21f2fe04-8674-cc73-7a6c-cb0765c84dba@gmail.com>
Date: Sat, 3 Jun 2023 20:59:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <160fea176559526b38a4080cc0f52666634a7a4f.camel@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/3 0:37, Alexander H Duyck wrote:
...

>>
>> Please let me know if the above makes sense, or if misunderstood your
>> concern here.
> 
> So my main concern is that what this is doing is masking things so that
> the veth and virtio_net drivers can essentially lie about the truesize
> of the memory they are using in order to improve their performance by
> misleading the socket layer about how much memory it is actually
> holding onto.
> 
> We have historically had an issue with reporting the truesize of
> fragments, but generally the underestimation was kept to something less
> than 100% because pages were generally split by at least half. Where it
> would get messy is if a misbehaviing socket held onto packets for an
> exceedingly long time.
> 
> What this patch set is doing is enabling explicit lying about the
> truesize, and it compounds that by allowing for mixing small
> allocations w/ large ones.
> 
>>>
>>> The problem is there are some architectures where we just cannot
>>> support having pp_frag_count due to the DMA size. So it makes sense to
>>> leave those with just basic page pool instead of trying to fake that it
>>> is a fragmented page.
>>
>> It kind of depend on how you veiw it, this patch view it as only supporting
>> one frag when we can't support having pp_frag_count, so I would not call it
>> faking.
> 
> So the big thing that make it "faking" is the truesize underestimation
> that will occur with these frames.

Let's discuss truesize issue in patch 2 instead of here.
Personally, I still believe that if the driver can compute the
truesize correctly by manipulating the page->pp_frag_count and
frag offset directly, the page pool can do that too.

> 
>>
>>>
>>>> ---

...

>>>
>>> What is the point of this line? It doesn't make much sense to me. Are
>>> you just trying to force an optiimization? You would be better off just
>>> taking the BUILD_BUG_ON contents and feeding them into an if statement
>>> below since the statement will compile out anyway.
>>
>> if the "if statement" you said refers to the below, then yes.
>>
>>>> +		if (!__builtin_constant_p(nr))
>>>> +			atomic_long_set(&page->pp_frag_count, 1);
>>
>> But it is a *BUILD*_BUG_ON(), isn't it compiled out anywhere we put it?
>>
>> Will move it down anyway to avoid confusion.
> 
> Actually now that I look at this more it is even more confusing. The
> whole point of this function was that we were supposed to be getting
> pp_frag_count to 0. However you are setting it to 1.
> 
> This is seriously flawed. If we are going to treat non-fragmented pages
> as mono-frags then that is what we should do. We should be pulling this
> acounting into all of the page pool freeing paths, not trying to force
> the value up to 1 for the non-fragmented case.

I am not sure I understand what do you mean by 'non-fragmented ',
'mono-frags', 'page pool freeing paths' and 'non-fragmented case'
here. maybe describe it more detailed with something like the
pseudocode?

> 
>>>
>>> It seems like what you would want here is:
>>> 	BUG_ON(!PAGE_POOL_DMA_USE_PP_FRAG_COUNT);
>>>
>>> Otherwise you are potentially writing to a variable that shouldn't
>>> exist.
>>
>> Not if the driver use the page_pool_alloc_frag() API instead of manipulating
>> the page->pp_frag_count directly using the page_pool_defrag_page() like mlx5.
>> The mlx5 call the page_pool_create() with with PP_FLAG_PAGE_FRAG set, and
>> it does not seems to have a failback for PAGE_POOL_DMA_USE_PP_FRAG_COUNT
>> case, and we may need to keep PP_FLAG_PAGE_FRAG for it. That's why we need
>> to keep the driver from implementation detail(pp_frag_count handling specifically)
>> of the frag support unless we have a very good reason.
>>
> 
> Getting the truesize is that "very good reason". The fact is the
> drivers were doing this long before page pool came around. Trying to
> pull that away from them is the wrong way to go in my opinion.

If the truesize is really the concern here, I think it make more
sense to enforce it in the page pool instead of each driver doing
their trick, so I also think we can do better here to handle
pp_frag_count in the page pool instead of driver handling it, so
let's continue the truesize disscussion in patch 2 to see if we
can come up with something better there.

> 
>>>>  	/* If nr == pp_frag_count then we have cleared all remaining
>>>>  	 * references to the page. No need to actually overwrite it, instead
>>>>  	 * we can leave this to be overwritten by the calling function.
>>>> @@ -311,19 +321,36 @@ static inline long page_pool_defrag_page(struct page *page, long nr)
>>>>  	 * especially when dealing with a page that may be partitioned
>>>>  	 * into only 2 or 3 pieces.
>>>>  	 */
>>>> -	if (atomic_long_read(&page->pp_frag_count) == nr)
>>>> +	if (atomic_long_read(&page->pp_frag_count) == nr) {
>>>> +		/* As we have ensured nr is always one for constant case
>>>> +		 * using the BUILD_BUG_ON() as above, only need to handle
>>>> +		 * the non-constant case here for frag count draining.
>>>> +		 */
>>>> +		if (!__builtin_constant_p(nr))
>>>> +			atomic_long_set(&page->pp_frag_count, 1);
>>>> +
>>>>  		return 0;
>>>> +	}
>>>>  
> 
> The optimization here was already the comparison since we didn't have
> to do anything if pp_frag_count == nr. The whole point of pp_frag_count
> going to 0 is that is considered non-fragmented in that case and ready
> to be freed. By resetting it to 1 you are implying that there is still
> one *other* user that is holding a fragment so the page cannot be
> freed.
> 
> We weren't bothering with writing the value since the page is in the
> free path and this value is going to be unused until the page is
> reallocated anyway.

I am not sure what you meant above.
But I will describe what is this patch trying to do again:
When PP_FLAG_PAGE_FRAG is set and that flag is per page pool, not per
page, so page_pool_alloc_pages() is not allowed to be called as the
page->pp_frag_count is not setup correctly for the case.

So in order to allow calling page_pool_alloc_pages(), as best as I
can think of, either we need a per page flag/bit to decide whether
to do something like dec_and_test for page->pp_frag_count in
page_pool_is_last_frag(), or we unify the page->pp_frag_count handling
in page_pool_is_last_frag() so that we don't need a per page flag/bit.

This patch utilizes the optimization you mentioned above to unify the
page->pp_frag_count handling.

> 
>>>>  	ret = atomic_long_sub_return(nr, &page->pp_frag_count);
>>>>  	WARN_ON(ret < 0);
>>>> +
>>>> +	/* Reset frag count back to 1, this should be the rare case when
>>>> +	 * two users call page_pool_defrag_page() currently.
>>>> +	 */
>>>> +	if (!ret)
>>>> +		atomic_long_set(&page->pp_frag_count, 1);
>>>> +
>>>>  	return ret;
>>>>  }
>>>>

...

>> As above, it is about unifying handling for frag and non-frag page in
>> page_pool_is_last_frag(). please let me know if there is any better way
>> to do it without adding statements here.
> 
> I get what you are trying to get at but I feel like the implementation
> is going to cause more problems than it helps. The problem is it is
> going to hurt base page pool performance and it just makes the
> fragmented pages that much more confusing to deal with.

For base page pool performance, as I mentioned before:
It remove PP_FLAG_PAGE_FRAG checking and only add the cost of
page_pool_fragment_page() in page_pool_set_pp_info(), which I
think it is negligible as we are already dirtying the same cache
line in page_pool_set_pp_info().

For the confusing, sometimes it is about personal taste, so I am
not going to argue with it:) But it would be good to provide a
non-confusing way to do that with minimal overhead. I feel like
you have provided it in the begin, but I am not able to understand
it yet.

> 
> My advice as a first step would be to look at first solving how to
> enable the PP_FLAG_PAGE_FRAG mode when you have
> PAGE_POOL_DMA_USE_PP_FRAG_COUNT as true. That should be creating mono-
> frags as we are calling them, and we should have a way to get the
> truesize for those so we know when we are consuming significant amount
> of memory.

Does the way to get the truesize in the below RFC make sense to you?
https://patchwork.kernel.org/project/netdevbpf/patch/20230516124801.2465-4-linyunsheng@huawei.com/

> 
> Once that is solved then we can look at what it would take to apply
> mono-frags to the standard page pool case. Ideally we would need to
> find a way to do it with minimal overhead.
> 
> 

