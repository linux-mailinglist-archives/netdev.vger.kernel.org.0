Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018A25EE1D5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 18:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbiI1Q3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Sep 2022 12:29:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233650AbiI1Q3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Sep 2022 12:29:22 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97CC4DB69;
        Wed, 28 Sep 2022 09:29:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id C8FAF21BD0;
        Wed, 28 Sep 2022 16:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1664382557; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EnWbGV237BuzDgTB50BqcLBq1d2zN9a/YOcWsHi9fr4=;
        b=t0+ihg6khVdLY0KsOqEColQEDlRylpDqT1w3q1DzA50zxqc/Vqwf/Zi+169ascbHLgt2bW
        FQkeclL4pKkrvckUy0cyXjOjZQxxzwvYNVbzSbw8k0t1HEJSrsQMny3TCh9HQ5Eog+GWZM
        66qq9zmMiQtEpL5PRSk7pG7/X1wkGwI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1664382557;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EnWbGV237BuzDgTB50BqcLBq1d2zN9a/YOcWsHi9fr4=;
        b=EorZdnweBb5NkWdw4eR45K3RqBYZ40BM744J5xENipJYNYfffn6v9+l3CJz/AghB3JfX3n
        6rVrw5Fity5E62Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 1213713677;
        Wed, 28 Sep 2022 16:29:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id dWVWAF12NGMNKgAAMHmgww
        (envelope-from <vbabka@suse.cz>); Wed, 28 Sep 2022 16:29:17 +0000
Message-ID: <f00866a5-88b2-c705-0a33-8f0b98a0642a@suse.cz>
Date:   Wed, 28 Sep 2022 18:27:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v2 01/16] slab: Remove __malloc attribute from realloc
 functions
Content-Language: en-US
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Kees Cook <keescook@chromium.org>
Cc:     Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Marco Elver <elver@google.com>, linux-mm@kvack.org,
        "Ruhl, Michael J" <michael.j.ruhl@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Alex Elder <elder@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Daniel Micay <danielmicay@gmail.com>,
        Yonghong Song <yhs@fb.com>, Miguel Ojeda <ojeda@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-btrfs@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-fsdevel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        dev@openvswitch.org, x86@kernel.org, llvm@lists.linux.dev,
        linux-hardening@vger.kernel.org
References: <20220923202822.2667581-1-keescook@chromium.org>
 <20220923202822.2667581-2-keescook@chromium.org>
 <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
From:   Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <CAMuHMdXK+UN1YVZm9DenuXAM8hZRUZJwp=SXsueP7sWiVU3a9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_SOFTFAIL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/28/22 09:26, Geert Uytterhoeven wrote:
> Hi Kees,
> 
> On Fri, Sep 23, 2022 at 10:35 PM Kees Cook <keescook@chromium.org> wrote:
>> The __malloc attribute should not be applied to "realloc" functions, as
>> the returned pointer may alias the storage of the prior pointer. Instead
>> of splitting __malloc from __alloc_size, which would be a huge amount of
>> churn, just create __realloc_size for the few cases where it is needed.
>>
>> Additionally removes the conditional test for __alloc_size__, which is
>> always defined now.
>>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Pekka Enberg <penberg@kernel.org>
>> Cc: David Rientjes <rientjes@google.com>
>> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Hyeonggon Yoo <42.hyeyoo@gmail.com>
>> Cc: Marco Elver <elver@google.com>
>> Cc: linux-mm@kvack.org
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Thanks for your patch, which is now commit 63caa04ec60583b1 ("slab:
> Remove __malloc attribute from realloc functions") in next-20220927.
> 
> Noreply@ellerman.id.au reported all gcc8-based builds to fail
> (e.g. [1], more at [2]):
> 
>      In file included from <command-line>:
>      ./include/linux/percpu.h: In function ‘__alloc_reserved_percpu’:
>      ././include/linux/compiler_types.h:279:30: error: expected
> declaration specifiers before ‘__alloc_size__’
>       #define __alloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__) __malloc
>                                    ^~~~~~~~~~~~~~
>      ./include/linux/percpu.h:120:74: note: in expansion of macro ‘__alloc_size’
>      [...]
> 
> It's building fine with e.g. gcc-9 (which is my usual m68k cross-compiler).
> Reverting this commit on next-20220927 fixes the issue.

So IIUC it was wrong to remove the #ifdefs?

> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/14803908/
> [2] http://kisskb.ellerman.id.au/kisskb/head/1bd8b75fe6adeaa89d02968bdd811ffe708cf839/
> 
> 
> 
>> ---
>>   include/linux/compiler_types.h | 13 +++++--------
>>   include/linux/slab.h           | 12 ++++++------
>>   mm/slab_common.c               |  4 ++--
>>   3 files changed, 13 insertions(+), 16 deletions(-)
>>
>> diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
>> index 4f2a819fd60a..f141a6f6b9f6 100644
>> --- a/include/linux/compiler_types.h
>> +++ b/include/linux/compiler_types.h
>> @@ -271,15 +271,12 @@ struct ftrace_likely_data {
>>
>>   /*
>>    * Any place that could be marked with the "alloc_size" attribute is also
>> - * a place to be marked with the "malloc" attribute. Do this as part of the
>> - * __alloc_size macro to avoid redundant attributes and to avoid missing a
>> - * __malloc marking.
>> + * a place to be marked with the "malloc" attribute, except those that may
>> + * be performing a _reallocation_, as that may alias the existing pointer.
>> + * For these, use __realloc_size().
>>    */
>> -#ifdef __alloc_size__
>> -# define __alloc_size(x, ...)  __alloc_size__(x, ## __VA_ARGS__) __malloc
>> -#else
>> -# define __alloc_size(x, ...)  __malloc
>> -#endif
>> +#define __alloc_size(x, ...)   __alloc_size__(x, ## __VA_ARGS__) __malloc
>> +#define __realloc_size(x, ...) __alloc_size__(x, ## __VA_ARGS__)
>>
>>   #ifndef asm_volatile_goto
>>   #define asm_volatile_goto(x...) asm goto(x)
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 0fefdf528e0d..41bd036e7551 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -184,7 +184,7 @@ int kmem_cache_shrink(struct kmem_cache *s);
>>   /*
>>    * Common kmalloc functions provided by all allocators
>>    */
>> -void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __alloc_size(2);
>> +void * __must_check krealloc(const void *objp, size_t new_size, gfp_t flags) __realloc_size(2);
>>   void kfree(const void *objp);
>>   void kfree_sensitive(const void *objp);
>>   size_t __ksize(const void *objp);
>> @@ -647,10 +647,10 @@ static inline __alloc_size(1, 2) void *kmalloc_array(size_t n, size_t size, gfp_
>>    * @new_size: new size of a single member of the array
>>    * @flags: the type of memory to allocate (see kmalloc)
>>    */
>> -static inline __alloc_size(2, 3) void * __must_check krealloc_array(void *p,
>> -                                                                   size_t new_n,
>> -                                                                   size_t new_size,
>> -                                                                   gfp_t flags)
>> +static inline __realloc_size(2, 3) void * __must_check krealloc_array(void *p,
>> +                                                                     size_t new_n,
>> +                                                                     size_t new_size,
>> +                                                                     gfp_t flags)
>>   {
>>          size_t bytes;
>>
>> @@ -774,7 +774,7 @@ static inline __alloc_size(1, 2) void *kvcalloc(size_t n, size_t size, gfp_t fla
>>   }
>>
>>   extern void *kvrealloc(const void *p, size_t oldsize, size_t newsize, gfp_t flags)
>> -                     __alloc_size(3);
>> +                     __realloc_size(3);
>>   extern void kvfree(const void *addr);
>>   extern void kvfree_sensitive(const void *addr, size_t len);
>>
>> diff --git a/mm/slab_common.c b/mm/slab_common.c
>> index 17996649cfe3..457671ace7eb 100644
>> --- a/mm/slab_common.c
>> +++ b/mm/slab_common.c
>> @@ -1134,8 +1134,8 @@ module_init(slab_proc_init);
>>
>>   #endif /* CONFIG_SLAB || CONFIG_SLUB_DEBUG */
>>
>> -static __always_inline void *__do_krealloc(const void *p, size_t new_size,
>> -                                          gfp_t flags)
>> +static __always_inline __realloc_size(2) void *
>> +__do_krealloc(const void *p, size_t new_size, gfp_t flags)
>>   {
>>          void *ret;
>>          size_t ks;
>> --
>> 2.34.1
>>
> 
> 
> --
> Gr{oetje,eeting}s,
> 
>                          Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds

