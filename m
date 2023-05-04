Return-Path: <netdev+bounces-283-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E82176F6D42
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:49:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DDCA280D41
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 13:48:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1A52FC1C;
	Thu,  4 May 2023 13:48:56 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2927E
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 13:48:56 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE9F83EA
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 06:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683208096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/Psn8a+p+ivjgRfJh7gyQsRugc6c1mLJFD6NHz5B0co=;
	b=dABzlvvEHm6FgGQ/L6PlB6hZmliyVzYCY9Itmn9H9q7wWkd0s0wNIIf11zj+2zLPwmvX4v
	rQLzi7yUJ+mwO96rkwn6BRCVWyY6dJ79DIYjP3dCxhvhGFlo0y9uxYJ5tznmYU/78eo4vj
	whqBv9E29r3+peGPL9wj3yJiO3uI9kQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-4u1fvioOOgmDzJxorYRdIg-1; Thu, 04 May 2023 09:48:14 -0400
X-MC-Unique: 4u1fvioOOgmDzJxorYRdIg-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a341efd9aso64614766b.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 06:48:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683208093; x=1685800093;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/Psn8a+p+ivjgRfJh7gyQsRugc6c1mLJFD6NHz5B0co=;
        b=liYo1LhfuL01TQT6F+gQz+PTakDKFG2ksr29zmQhIT/TSjG5YllDormx57/1rT+QA6
         7wSEakkJrZuwp4BgZGvE6MNf/bJtgs7u8nH4RIjHD8ooEizQzBl2mTVbVVWJAhJXRsCG
         jroMR5IhjMh4xlQDTBLd0Z9Gm9lAHvT8gX7R/ZfbY39ti0DBrLgrshqp6oC2Oya7Gbmy
         Y0uDU8NLAFZmohxwUSmc0PV3uPK3MF5whpbILCg8ZaRuUvNpT6rY8prBK1P00iqqfs6t
         ZZ8qjNFuNFSVNawmOvhYR1pZPI53tJ7YfatxpykmeluCkGPlTROk16ODjux77FUlqERa
         Zx8g==
X-Gm-Message-State: AC+VfDx8NSppegG4QUZCFglfPyua0cSNdm3CgFI7F76KMlbABXpgqq79
	H9QnBLSXzUAZEhHmFtUgUeTCp5kjP4Y/FdRdssPpquKmMG7qqL3F3B/u4wDGv+Kg25DoXO1a5l3
	btLytD1xXK4PT/0fr
X-Received: by 2002:a17:907:982:b0:94e:3d6f:9c0f with SMTP id bf2-20020a170907098200b0094e3d6f9c0fmr6373065ejc.55.1683208093269;
        Thu, 04 May 2023 06:48:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5yAumZlKjgIkX67ze7eAZsMjh5PrIMF9NPniS81LmF2LlTPtKC5MLQHKTj0FxsOWYmK0Xrug==
X-Received: by 2002:a17:907:982:b0:94e:3d6f:9c0f with SMTP id bf2-20020a170907098200b0094e3d6f9c0fmr6373042ejc.55.1683208092877;
        Thu, 04 May 2023 06:48:12 -0700 (PDT)
Received: from [192.168.42.222] (cgn-cgn9-185-107-14-3.static.kviknet.net. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id u13-20020a170906c40d00b0094aa087578csm19031004ejz.171.2023.05.04.06.48.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 06:48:12 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <3785321f-b2f8-d753-7efc-78ee40e6d0b6@redhat.com>
Date: Thu, 4 May 2023 15:48:10 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc: brouer@redhat.com, lorenzo@kernel.org,
 =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
 bpf@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org
Subject: Re: [PATCH RFC net-next/mm V3 1/2] page_pool: Remove workqueue in new
 shutdown scheme
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, netdev@vger.kernel.org,
 Eric Dumazet <eric.dumazet@gmail.com>, linux-mm@kvack.org,
 Mel Gorman <mgorman@techsingularity.net>
References: <168269854650.2191653.8465259808498269815.stgit@firesoul>
 <168269857929.2191653.13267688321246766547.stgit@firesoul>
 <387f4653-1986-3ffe-65e7-448a59002ed0@huawei.com>
In-Reply-To: <387f4653-1986-3ffe-65e7-448a59002ed0@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 04/05/2023 04.42, Yunsheng Lin wrote:
> On 2023/4/29 0:16, Jesper Dangaard Brouer wrote:
>>   void page_pool_release_page(struct page_pool *pool, struct page *page)
>>   {
>> +	unsigned int flags = READ_ONCE(pool->p.flags);
>>   	dma_addr_t dma;
>> -	int count;
>> +	u32 release_cnt;
>> +	u32 hold_cnt;
>>   
>>   	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
>>   		/* Always account for inflight pages, even if we didn't
>> @@ -490,11 +503,15 @@ void page_pool_release_page(struct page_pool *pool, struct page *page)
>>   skip_dma_unmap:
>>   	page_pool_clear_pp_info(page);
>>   
>> -	/* This may be the last page returned, releasing the pool, so
>> -	 * it is not safe to reference pool afterwards.
>> -	 */
>> -	count = atomic_inc_return_relaxed(&pool->pages_state_release_cnt);
>> -	trace_page_pool_state_release(pool, page, count);
> 
> There is a time window between "unsigned int flags = READ_ONCE(pool->p.flags)"
> and flags checking, if page_pool_destroy() is called concurrently during that
> time window, it seems we will have a pp instance leaking problem here?
> 

Nope, that is resolved by the code changes in page_pool_destroy(), see 
below.

> It seems it is very hard to aovid this kind of corner case when using both
> flags & PP_FLAG_SHUTDOWN and release_cnt/hold_cnt checking to decide if pp
> instance can be freed.
> Can we use something like biased reference counting, which used by frag support
> in page pool? So that we only need to check only one variable and avoid cache
> bouncing as much as possible.
> 

See below, I believe we are doing an equivalent refcnt bias trick, that
solves these corner cases in page_pool_destroy().
In short: hold_cnt is increased, prior to setting PP_FLAG_SHUTDOWN.
Thus, if this code READ_ONCE flags without PP_FLAG_SHUTDOWN, we know it
will not be the last to release pool->pages_state_release_cnt.
Below: Perhaps, we should add a RCU grace period to make absolutely
sure, that this code completes before page_pool_destroy() call completes.


>> +	if (flags & PP_FLAG_SHUTDOWN)
>> +		hold_cnt = pp_read_hold_cnt(pool);
>> +

I would like to avoid above code, and I'm considering using call_rcu(),
which I think will resolve the race[0] this code deals with.
As I explained here[0], this code deals with another kind of race.

  [0] 
https://lore.kernel.org/all/f671f5da-d9bc-a559-2120-10c3491e6f6d@redhat.com/

>> +	release_cnt = atomic_inc_return(&pool->pages_state_release_cnt);
>> +	trace_page_pool_state_release(pool, page, release_cnt);
>> +
>> +	/* In shutdown phase, last page will free pool instance */
>> +	if (flags & PP_FLAG_SHUTDOWN)
>> +		page_pool_free_attempt(pool, hold_cnt, release_cnt);
>>   }
>>   EXPORT_SYMBOL(page_pool_release_page);
>>
> 
> ...
> 
>>   
>>   void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
>> @@ -856,6 +884,10 @@ EXPORT_SYMBOL(page_pool_unlink_napi);
>>   
>>   void page_pool_destroy(struct page_pool *pool)
>>   {
>> +	unsigned int flags;
>> +	u32 release_cnt;
>> +	u32 hold_cnt;
>> +
>>   	if (!pool)
>>   		return;
>>   
>> @@ -868,11 +900,39 @@ void page_pool_destroy(struct page_pool *pool)
>>   	if (!page_pool_release(pool))
>>   		return;
>>   
>> -	pool->defer_start = jiffies;
>> -	pool->defer_warn  = jiffies + DEFER_WARN_INTERVAL;
>> +	/* PP have pages inflight, thus cannot immediately release memory.
>> +	 * Enter into shutdown phase, depending on remaining in-flight PP
>> +	 * pages to trigger shutdown process (on concurrent CPUs) and last
>> +	 * page will free pool instance.
>> +	 *
>> +	 * There exist two race conditions here, we need to take into
>> +	 * account in the following code.
>> +	 *
>> +	 * 1. Before setting PP_FLAG_SHUTDOWN another CPU released the last
>> +	 *    pages into the ptr_ring.  Thus, it missed triggering shutdown
>> +	 *    process, which can then be stalled forever.
>> +	 *
>> +	 * 2. After setting PP_FLAG_SHUTDOWN another CPU released the last
>> +	 *    page, which triggered shutdown process and freed pool
>> +	 *    instance. Thus, its not safe to dereference *pool afterwards.
>> +	 *
>> +	 * Handling races by holding a fake in-flight count, via
>> +	 * artificially bumping pages_state_hold_cnt, which assures pool
>> +	 * isn't freed under us.  For race(1) its safe to recheck ptr_ring
>> +	 * (it will not free pool). Race(2) cannot happen, and we can
>> +	 * release fake in-flight count as last step.
>> +	 */
>> +	hold_cnt = READ_ONCE(pool->pages_state_hold_cnt) + 1;
>> +	smp_store_release(&pool->pages_state_hold_cnt, hold_cnt);
> 
> I assume the smp_store_release() is used to ensure the correct order
> between the above store operations?
> There is data dependency between those two store operations, do we
> really need the smp_store_release() here?
> 
>> +	barrier();
>> +	flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN;
> 
> Do we need a stronger barrier like smp_rmb() to prevent cpu from
> executing "flags = READ_ONCE(pool->p.flags) | PP_FLAG_SHUTDOWN"
> before "smp_store_release(&pool->pages_state_hold_cnt, hold_cnt)"
> even if there is a smp_store_release() barrier here?
> 
I do see you point and how it is related to your above comment for
page_pool_release_page().

I think we need to replace barrier() with synchronize_rcu().
Meaning we add a RCU grace period to "wait" for above code (in
page_pool_release_page) that read the old flags value to complete.


>> +	smp_store_release(&pool->p.flags, flags);

When doing a synchronize_rcu(), I assume this smp_store_release() is
overkill, right?
Will a WRITE_ONCE() be sufficient?

Hmm, the synchronize_rcu(), shouldn't that be *after* storing the flags?

>> +
>> +	/* Concurrent CPUs could have returned last pages into ptr_ring */
>> +	page_pool_empty_ring(pool);
>>   
>> -	INIT_DELAYED_WORK(&pool->release_dw, page_pool_release_retry);
>> -	schedule_delayed_work(&pool->release_dw, DEFER_TIME);
>> +	release_cnt = atomic_inc_return(&pool->pages_state_release_cnt);
>> +	page_pool_free_attempt(pool, hold_cnt, release_cnt);
>>   }
>>   EXPORT_SYMBOL(page_pool_destroy);


