Return-Path: <netdev+bounces-11713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B4A7734093
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 13:41:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 629801C20A7D
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 11:41:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1690A848C;
	Sat, 17 Jun 2023 11:41:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09B179F0
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 11:41:21 +0000 (UTC)
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9760E19BE;
	Sat, 17 Jun 2023 04:41:19 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id 46e09a7af769-6b2dbca2daeso1614568a34.3;
        Sat, 17 Jun 2023 04:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687002079; x=1689594079;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dU668eYNm6IwZPJckVNoRTvAYHfPMsCVKmWsf8m/RKE=;
        b=kdh7rALgZ2DRQkp4IkP3tTB16ALKwnfv/fK2cRu3zXfiMSPpJ7pzTVRetekk9LjSb1
         ZgD91ud/HLMKz+iaTyYHY2mQU4aXI512fyM/aYPt6gTPbNlGw0m3T9n3sKQWe1Jb9iL2
         xzQTQmabr1QzivrCMKBC5YFswg8oELqH088B1SHSrG+63KRSqZyD9uY5bZld/n5ryJYk
         MxsG6Q5ztHINpRT9n0ur/ULchASZj5FDFOSGU/ON83Ykyq3ZGCG3w/wbjCbJSirbGgD+
         A8yh6fNMjEQWDUPkhBBw+3v+ZDQyw3WEsL9RKejY79s+YmuT19JJih7hgeaWMH7r/8Si
         WmRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687002079; x=1689594079;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dU668eYNm6IwZPJckVNoRTvAYHfPMsCVKmWsf8m/RKE=;
        b=Y7UyBf7xFHBAi3aORaWrSL5b7ZDeR+sWl30fmiiMH1HGy7Z7gIKlGxJ0E/XGlDcltO
         ah9E3lQgPGu5t4Q97yQ+iinDooeOfQwbDamLpiHlD87W6h7tXzVJkknu3PMBATR0UhwL
         LuwRLdmlAKjrqWnESFjh8KrnsDkeoCeOozOeAreqEBxDV7m5BHrm4vd858Ub8yInvBHo
         aCnLNDlD+hgcJgdG5PxFKgZDvPdrIBttKlspmN5BX75X/2ZMjEbMHqeRJ294tS/zRP+w
         sP1CcQIx3baHCKULkHNXYUun+fDJpLAS619bNAKF2YhZbAhRBgOIBCvp2zsUtFDhbZcV
         yT4A==
X-Gm-Message-State: AC+VfDw7JfwHwJDfEL/lY30RUDZ0fx0s/klUtKMiOmsWv+Vr77Y9OwKk
	AGuoTtnAAPFq+Brj05cGWMU=
X-Google-Smtp-Source: ACHHUZ43LdEie5EsBtpW5R5aaYrDx5fpYsEWKWM6faS1xRDiuduf0R0+dDl624RZYfCFPUNeCp+M1w==
X-Received: by 2002:a9d:6447:0:b0:6b0:cde0:d9b with SMTP id m7-20020a9d6447000000b006b0cde00d9bmr2510070otl.2.1687002078724;
        Sat, 17 Jun 2023 04:41:18 -0700 (PDT)
Received: from ?IPv6:2409:8a55:301b:e120:18ac:7176:4598:6838? ([2409:8a55:301b:e120:18ac:7176:4598:6838])
        by smtp.gmail.com with ESMTPSA id 17-20020aa79211000000b00662610cf7a8sm15247169pfo.172.2023.06.17.04.41.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jun 2023 04:41:18 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
To: Alexander Duyck <alexander.duyck@gmail.com>,
 Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0345b6c4-18da-66d8-71a0-02620f9abe9e@huawei.com>
 <CAKgT0Udmxc6EbUoZ_4P3jfWck3mvUtTY8mqUjT91bDwjZj-uMg@mail.gmail.com>
From: Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <741d1dab-e8d7-2420-e652-d4a671dac7b1@gmail.com>
Date: Sat, 17 Jun 2023 19:41:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAKgT0Udmxc6EbUoZ_4P3jfWck3mvUtTY8mqUjT91bDwjZj-uMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/16 22:46, Alexander Duyck wrote:
...

>>>> 2. the driver handles it by manipulating the page_pool->frag_offset
>>>>    directly.
>>>
>>> I view 2 as being the only acceptable approach. Otherwise we are
>>> forcing drivers into a solution that may not fit and forcing yet
>>> another fork of allocation setups. There is a reason vendors have
>>
>> I respectly disagree with driver manipulating the page_pool->frag_offset
>> directly.
>>
>> It is a implemenation detail which should be hiden from the driver:
>> For page_pool_alloc_frag() API, page_pool->frag_offset is not even
>> useful for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true,
>> similar cases for page_pool_alloc() returning mono-frag if I understand
>> 'mono-frag ' correctly.
>>
>> IMHO, if the driver try to do the their own page spilting, it should
>> use it's own offset, not messing with the offset the page pool is using.
>> Yes, that may mean driver doing it's own page splitting and page pool
>> doing it's own page splitting for the same page if we really like to
>> make the best out of a page.
> 
> Actually, now that I reread this I agree with you. It shouldn't be
> manipulating the frag_offset. The frag offset isn't really a thing
> that we have to worry about if we are being given the entire page to
> fragment as we want. Basically the driver needs the ability to access
> any offset within the page that it will need to. The frag_offset is an
> implementation of the page_pool and is not an aspect of the fragment
> or page that is given out. That is one of the reasons why the page
> fragments are nothing more than a virtual address that is known to be
> a given size. With that what we can do is subdivide the page further
> in the drivers.

I am really doubtful that the need of 'subdividing the page further
in the drivers' if we have the page splitting in page pool to allow
multi-descs to share the same page for most of the nic driver. IOW,
we should do only one level of page splitting IMHO.

If I understand it correctly, most hw have a per-queue fixed buffer
size, even the mlx5 one with per-desc buffer size support through
mlx5_wqe_data_seg, the driver seems to use the 'per-queue fixed
buffer size' model, I assume that using per-desc buffer size is just
not worth the effort?

Let's say we use the per-queue fixed buffer with 2K buffer size, I
am supposing that is most drivers is using by default, so the question
is how much memory is needed for each desc to allowing subdividing
within desc? I am supposing we mostly need a 4K buffer for each desc,
right? 

For system with 4K page size, that means we are only able to do one
level of page splitting, either in the page pool or in the driver.
What is your perfer option? and Why?

For system with larger page size, that means we are able to do
multi level of page splitting, and I suppose page splitting in
the page pool is always needed, the question is whether we allow
subdividing in the driver, right?

I think we need to consider the truesize underestimate problem
for small packet if we want to do page splitting in the driver
to save memory, even for system with 4K page size, not to
mention the 64K page size.

As you said in the previous thread:
"
> IMHO, doing the above only alleviate the problem. How is above splitting
> different from splitting it evently with 16 2K fragments, and when 15 frag
> is released, we still have the last 2K fragment holding onto 32K memory,
> doesn't that also cause massive truesize underestimate? Not to mention that
> for system with 64K page size.

Yes, that is a known issue. That is why I am not wanting us to further
exacerbate the issue.
"
Also If there is any known solution to this 'known issue'? it
seems unfixable to me, so I did not continue that discussion in
that thread.

And for packet with normal size, it seems the hns3 case seems
like a proof that doing the page splitting in the page pool
seems like a better choice, even for system with 4K page size,
mainly because doing the page splitting in page pool is per-queue,
and doing the page splitting in driver is per-desc, which is a
smaller 'pool' comparing to page pool.

> 
> What I was thinking of was the frag count. That is something the
> driver should have the ability to manipulate, be it adding or removing
> frags as it takes the section of memory it was given and it decides to
> break it up further before handing it out in skb frames.

As my understanding, there is no essential difference between frag
count and frag offet if we want to do 'subdividing', just like we
have frag_count for page pool and _refcount for page allocator, we
may need a third one for this 'subdividing'.

> 
>> That way I see the page splitting in page pool as a way to share a
>> page between different desc, and page splitting in driver as way to
>> reclaim some memory for small packet, something like ena driver is
>> doing:
>> https://lore.kernel.org/netdev/20230612121448.28829-1-darinzon@amazon.com/T/
>>
>> And hns3 driver has already done something similar for old per-desc
>> page flipping with 64K page size:
>>
>> https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c#L3737
> 
> Yeah, I am well aware of the approach. I was the one that originally
> implemented that in igb/ixgbe over a decade ago.
> 
>> As we have done the page splitting to share a page between different desc
>> in the page pool, I really double that the benefit will justify the
>> complexity of the page splitting in the driver.
> 
> The point I am getting at is that there are drivers already using this
> code. There is a tradeoff for adding complexity to update things to
> make it fit another use case. What I question is if it is worth it for
> the other drivers to take on any extra overhead you are adding for a
> use case that doesn't really seem to fix the existing one.

I am not sure I understand your point here.
page_pool_alloc() is more of way to simplify the interface for
driver, so yes, it is impossible to take care of all use cases,
and there is some extra overhead for the simplicity, but it does
not means that we can not try to start generalizing thing, right?

If page_pool_alloc() does not fit a specific driver/hw' need, there
are still page_pool_alloc_pages() and page_pool_alloc_frag()
available.

> 

...

>>
>> I am not sure if there is any other 'trying to pre-allocate things just
>> isn't going to work' case that I missed, it will be very appreciatived
>> if you can provide the complete cases here, so that we can discuss it
>> throughly.
> 
> The idea is to keep it simple. Basically just like with a classic page
> we can add to or remove from the reference count. That is how most of
> the drivers did all this before the page pool was available.

I understand that is how most of the drivers did all this before the
page pool was available, but I am really not convinced that we need
that when page pool was available yet as the reasons mentioned at the
begining.

> 
>>>
>>>> 3. the page pool handles it as this patch does.
>>>
>>> The problem is the page pool isn't handling it. It is forcing the
>>> allocations larger without reporting them as of this patch. It is
>>> trying to forecast what the next request is going to be which is
>>> problematic since it doesn't have enough info to necessarily be making
>>> such assumptions.
>>
>> We are talking about rx for networking, right? I think the driver
>> does not have that kind of enough info too, Or I am missing something
>> here?
> 
> Yes, we are talking about Rx networking. Most drivers will map a page
> without knowing the size of the frame they are going to receive. As
> such they can end up breaking up the page into multiple fragments with
> the offsets being provided by the device descriptors.

For most hw without support for multi-packet in one desc, the driver
still need to allocate a per-queue size buffer for the next packet,
so I am really not sure the benefit will justify the complexity and
the truesize underestimate exacerbating yet.

> 
>>>
>>>> Is there any other options I missed for the specific case for virtio_net?
>>>> What is your perfer option? And why?
>>>
>>> My advice would be to leave it to the driver.
>>>
>>> What concerns me is that you seem to be taking the page pool API in a
>>> direction other than what it was really intended for. For any physical
>>> device you aren't going to necessarily know what size fragment you are
>>> working with until you have already allocated the page and DMA has
>>> been performed. That is why drivers such as the Mellanox driver are
>>> fragmenting in the driver instead of allocated pre-fragmented pages.
>>
>> Why do you think using the page pool API to do the fragmenting in the
>> driver is the direction that page pool was intended for?
>>
>> I thought page pool API was not intended for any fragmenting in the
>> first place by the discussion in the maillist, I think we should be
>> more open about what direction the page pool API is heading to
>> considering the emerging use case:)
> 
> The problem is virtual devices are very different from physical
> devices. One of the big things we had specifically designed the page
> pool for was to avoid the overhead of DMA mapping and unmapping
> involved in allocating Rx buffers for network devices. Much of it was
> based on the principals we had in drivers such as ixgbe that were
> pinning the Rx pages using reference counting hacks in order to avoid
> having to perform the unmap.

I think I am agreed on this one if I understand it correctly, the basic
idea is to aovid adding another layer of caching as page allocator has
the per-cpu page allocator, right?

If the veth can find a better sultion as discussed on other thread,
then I may need to find another consumer for the new API:) 

> 
>>>
>>>>>
>>>>> If you are going to go down this path then you should have a consumer
>>>>> for the API and fully implement it instead of taking half measures and
>>>>> making truesize underreporting worse by evicting pages earlier.
>>>>
>>>> I am not sure I understand what do you mean by "a consumer for the API",
>>>> Do you mean adding a new API something like page_pool_free() to do
>>>> something ligthweight, such as decrementing the frag user and adjusting
>>>> the frag_offset, which is corresponding to the page_pool_alloc() API
>>>> introduced in this patch?
>>>
>>> What I was getting at is that if you are going to add an API you have
>>> to have a consumer for the API. That is rule #1 for kernel API
>>> development. You don't add API without a consumer for it. The changes
>>> you are making are to support some future implementation, and I see it
>>> breaking most of the existing implementation. That is my concern.
>>
>> The patch is extending a new api, the behavior of current api is preserved
>> as much as possible, so I am not sure which implementation is broken by
>> this patch? How and why?
>>
>> As for the '#1 for kernel API development', I think I had mention the
>> usecase it is intended for in the coverletter, and if I recall correctly,
>> the page_pool_fragment_page() API you added also do not come with a
>> actual consumer, I was overloaded at that time, so just toke a glance
>> and wonder why there was no user with a API added.
> 
> As I recall it was partly due to the fact that I had offered to step
> in and take over that part of the implementation you were working on
> as we had been going back and forth for a while without making much
> progress on the patchset.

Let's improve on that so that there is less of going back and forth
for a while without making much progress this time:)


