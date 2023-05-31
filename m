Return-Path: <netdev+bounces-6807-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A1F718412
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:01:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 35AD22814D9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 14:01:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED0115481;
	Wed, 31 May 2023 14:01:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29D9914A95
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 14:01:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F5F1E72
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685541571;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kVhCP6HTOR20StVaLzZ07Fh8IZ49b1eeP04qsYM8C9M=;
	b=ZJHyBQjECmKeNYUX1n0/K8bHQ1iNtB0boxEnZpavp74EHxNVNS1W8Smx/Gpt/6pag0Hm0L
	sBLoX6HL09uK7pHU0MhoAHlszaFKT3qidVkURmfkz5FWLtxFYIjrFmn++LCRmEqOLmfHZS
	vBA1IQp+JbD7hde9Nyi26larCWfu8WA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-212-KHJxsEwFPCGwlWxxyrH2hA-1; Wed, 31 May 2023 09:59:30 -0400
X-MC-Unique: KHJxsEwFPCGwlWxxyrH2hA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9715654ab36so509704366b.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:59:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685541569; x=1688133569;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kVhCP6HTOR20StVaLzZ07Fh8IZ49b1eeP04qsYM8C9M=;
        b=C3BOwGmpQWGK+o5vi0XQ/3FcMlRQZv7pU+DHwhR7vl/ywmB30bDeLlL3Oa7nRsWk8u
         ZtcKv5YNcTdd6fi1foRUn3bWdwX58WPy7lYLnlebtqNLno7wREocxP1GyxDhfvJaLKN4
         XbQ4JlwH30ISiz+y1DOhuyMhCfeLAuIW3uG5S8SJSiuT3D76UloDJPHvoialC0XW2cc8
         Y9p5SSkpUYsiA28cRbugQQW7NL8Pl6A3R2CZsqLYrB9dOIO9W+zQzUT565V1NrPkc29w
         Qqv8gUBRpsYI8OJPLVSeEERPV1UrdRrJTYDeyOmQD/uAEHuyaF/YaL/oGz60+vXcOTmV
         yStw==
X-Gm-Message-State: AC+VfDzrWSvhEwt8Xh6cHP6CqrvBxa4heL7dYoymcPjYFh8L1fQ9hHUD
	sZAiQ9ZwSGwWCDq0gFDt636dTyacUS8J2AoN1jgbPmLlt3Qq6FmgbYRrc/QKTxo0l17y9cn730Y
	elrKx2aDD9FYpWk0q
X-Received: by 2002:a17:907:1624:b0:973:dd5b:4072 with SMTP id hb36-20020a170907162400b00973dd5b4072mr5228250ejc.53.1685541568876;
        Wed, 31 May 2023 06:59:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6YA3vUQrzRmUww9U1hLq1c8lsXgIVyFbRK9gNaLerkSDpAH1Z6jr1KK44pKDbMaXNqCzbOzA==
X-Received: by 2002:a17:907:1624:b0:973:dd5b:4072 with SMTP id hb36-20020a170907162400b00973dd5b4072mr5228230ejc.53.1685541568526;
        Wed, 31 May 2023 06:59:28 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id r8-20020a170906c28800b00969e9fef151sm9116452ejz.97.2023.05.31.06.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 31 May 2023 06:59:27 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <fe64a059-f4c8-5983-3b08-f84552d1ce61@redhat.com>
Date: Wed, 31 May 2023 15:59:26 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, Christoph Lameter <cl@linux.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Mel Gorman <mgorman@techsingularity.net>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>, penberg@kernel.org,
 Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 edumazet@google.com, pabeni@redhat.com, Matthew Wilcox
 <willy@infradead.org>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, David Sterba <dsterba@suse.com>
Subject: Re: [PATCH RFC] mm+net: allow to set kmem_cache create flag for
 SLAB_NEVER_MERGE
Content-Language: en-US
To: Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org,
 linux-mm@kvack.org
References: <167396280045.539803.7540459812377220500.stgit@firesoul>
 <81597717-0fed-5fd0-37d0-857d976b9d40@suse.cz>
In-Reply-To: <81597717-0fed-5fd0-37d0-857d976b9d40@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 31/05/2023 14.03, Vlastimil Babka wrote:
> On 1/17/23 14:40, Jesper Dangaard Brouer wrote:
>> Allow API users of kmem_cache_create to specify that they don't want
>> any slab merge or aliasing (with similar sized objects). Use this in
>> network stack and kfence_test.
>>
>> The SKB (sk_buff) kmem_cache slab is critical for network performance.
>> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
>> performance by amortising the alloc/free cost.
>>
>> For the bulk API to perform efficiently the slub fragmentation need to
>> be low. Especially for the SLUB allocator, the efficiency of bulk free
>> API depend on objects belonging to the same slab (page).
>>
>> When running different network performance microbenchmarks, I started
>> to notice that performance was reduced (slightly) when machines had
>> longer uptimes. I believe the cause was 'skbuff_head_cache' got
>> aliased/merged into the general slub for 256 bytes sized objects (with
>> my kernel config, without CONFIG_HARDENED_USERCOPY).
>>
>> For SKB kmem_cache network stack have reasons for not merging, but it
>> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
>> We want to explicitly set SLAB_NEVER_MERGE for this kmem_cache.
>>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> 
> Since this idea was revived by David [1], and neither patch worked as is,
> but yours was more complete and first, I have fixed it up as below. The
> skbuff part itself will be best submitted separately afterwards so we don't
> get conflicts between trees etc. Comments?
> 

Thanks for following up on this! :-)
I like the adjustments, ACKed below.

I'm okay with submitting changes to net/core/skbuff.c separately.

> ----8<----
>  From 485d3f58f3e797306b803102573e7f1367af2ad2 Mon Sep 17 00:00:00 2001
> From: Jesper Dangaard Brouer <brouer@redhat.com>
> Date: Tue, 17 Jan 2023 14:40:00 +0100
> Subject: [PATCH] mm/slab: introduce kmem_cache flag SLAB_NO_MERGE
> 
> Allow API users of kmem_cache_create to specify that they don't want
> any slab merge or aliasing (with similar sized objects). Use this in
> kfence_test.
> 
> The SKB (sk_buff) kmem_cache slab is critical for network performance.
> Network stack uses kmem_cache_{alloc,free}_bulk APIs to gain
> performance by amortising the alloc/free cost.
> 
> For the bulk API to perform efficiently the slub fragmentation need to
> be low. Especially for the SLUB allocator, the efficiency of bulk free
> API depend on objects belonging to the same slab (page).
> 
> When running different network performance microbenchmarks, I started
> to notice that performance was reduced (slightly) when machines had
> longer uptimes. I believe the cause was 'skbuff_head_cache' got
> aliased/merged into the general slub for 256 bytes sized objects (with
> my kernel config, without CONFIG_HARDENED_USERCOPY).
> 
> For SKB kmem_cache network stack have reasons for not merging, but it
> varies depending on kernel config (e.g. CONFIG_HARDENED_USERCOPY).
> We want to explicitly set SLAB_NO_MERGE for this kmem_cache.
> 
> Another use case for the flag has been described by David Sterba [1]:
> 
>> This can be used for more fine grained control over the caches or for
>> debugging builds where separate slabs can verify that no objects leak.
> 
>> The slab_nomerge boot option is too coarse and would need to be
>> enabled on all testing hosts. There are some other ways how to disable
>> merging, e.g. a slab constructor but this disables poisoning besides
>> that it adds additional overhead. Other flags are internal and may
>> have other semantics.
> 
>> A concrete example what motivates the flag. During 'btrfs balance'
>> slab top reported huge increase in caches like
> 
>>   1330095 1330095 100%    0.10K  34105       39    136420K Acpi-ParseExt
>>   1734684 1734684 100%    0.14K  61953       28    247812K pid_namespace
>>   8244036 6873075  83%    0.11K 229001       36    916004K khugepaged_mm_slot
> 
>> which was confusing and that it's because of slab merging was not the
>> first idea.  After rebooting with slab_nomerge all the caches were
>> from btrfs_ namespace as expected.
> 
> [1] https://lore.kernel.org/all/20230524101748.30714-1-dsterba@suse.com/
> 
> [ vbabka@suse.cz: rename to SLAB_NO_MERGE, change the flag value to the
>    one proposed by David so it does not collide with internal SLAB/SLUB
>    flags, write a comment for the flag, expand changelog, drop the skbuff
>    part to be handled spearately ]
> 
> Reported-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com

> ---
>   include/linux/slab.h    | 12 ++++++++++++
>   mm/kfence/kfence_test.c |  7 +++----
>   mm/slab.h               |  5 +++--
>   mm/slab_common.c        |  2 +-
>   4 files changed, 19 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 6b3e155b70bf..72bc906d8bc7 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -106,6 +106,18 @@
>   /* Avoid kmemleak tracing */
>   #define SLAB_NOLEAKTRACE	((slab_flags_t __force)0x00800000U)
>   
> +/*
> + * Prevent merging with compatible kmem caches. This flag should be used
> + * cautiously. Valid use cases:
> + *
> + * - caches created for self-tests (e.g. kunit)
> + * - general caches created and used by a subsystem, only when a
> + *   (subsystem-specific) debug option is enabled
> + * - performance critical caches, should be very rare and consulted with slab
> + *   maintainers, and not used together with CONFIG_SLUB_TINY
> + */
> +#define SLAB_NO_MERGE		((slab_flags_t __force)0x01000000U)
> +
>   /* Fault injection mark */
>   #ifdef CONFIG_FAILSLAB
>   # define SLAB_FAILSLAB		((slab_flags_t __force)0x02000000U)
> diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
> index 6aee19a79236..9e008a336d9f 100644
> --- a/mm/kfence/kfence_test.c
> +++ b/mm/kfence/kfence_test.c
> @@ -191,11 +191,10 @@ static size_t setup_test_cache(struct kunit *test, size_t size, slab_flags_t fla
>   	kunit_info(test, "%s: size=%zu, ctor=%ps\n", __func__, size, ctor);
>   
>   	/*
> -	 * Use SLAB_NOLEAKTRACE to prevent merging with existing caches. Any
> -	 * other flag in SLAB_NEVER_MERGE also works. Use SLAB_ACCOUNT to
> -	 * allocate via memcg, if enabled.
> +	 * Use SLAB_NO_MERGE to prevent merging with existing caches.
> +	 * Use SLAB_ACCOUNT to allocate via memcg, if enabled.
>   	 */
> -	flags |= SLAB_NOLEAKTRACE | SLAB_ACCOUNT;
> +	flags |= SLAB_NO_MERGE | SLAB_ACCOUNT;
>   	test_cache = kmem_cache_create("test", size, 1, flags, ctor);
>   	KUNIT_ASSERT_TRUE_MSG(test, test_cache, "could not create cache");
>   
> diff --git a/mm/slab.h b/mm/slab.h
> index f01ac256a8f5..9005ddc51cf8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -294,11 +294,11 @@ static inline bool is_kmalloc_cache(struct kmem_cache *s)
>   #if defined(CONFIG_SLAB)
>   #define SLAB_CACHE_FLAGS (SLAB_MEM_SPREAD | SLAB_NOLEAKTRACE | \
>   			  SLAB_RECLAIM_ACCOUNT | SLAB_TEMPORARY | \
> -			  SLAB_ACCOUNT)
> +			  SLAB_ACCOUNT | SLAB_NO_MERGE)
>   #elif defined(CONFIG_SLUB)
>   #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
>   			  SLAB_TEMPORARY | SLAB_ACCOUNT | \
> -			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC)
> +			  SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
>   #else
>   #define SLAB_CACHE_FLAGS (SLAB_NOLEAKTRACE)
>   #endif
> @@ -319,6 +319,7 @@ static inline bool is_kmalloc_cache(struct kmem_cache *s)
>   			      SLAB_TEMPORARY | \
>   			      SLAB_ACCOUNT | \
>   			      SLAB_KMALLOC | \
> +			      SLAB_NO_MERGE | \
>   			      SLAB_NO_USER_FLAGS)
>   
>   bool __kmem_cache_empty(struct kmem_cache *);
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 607249785c07..0e0a617eae7d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -47,7 +47,7 @@ static DECLARE_WORK(slab_caches_to_rcu_destroy_work,
>    */
>   #define SLAB_NEVER_MERGE (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \
>   		SLAB_TRACE | SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | \
> -		SLAB_FAILSLAB | kasan_never_merge())
> +		SLAB_FAILSLAB | SLAB_NO_MERGE | kasan_never_merge())
>   
>   #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
>   			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)


