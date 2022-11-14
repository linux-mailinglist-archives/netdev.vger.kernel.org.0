Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C316E628451
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 16:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiKNPrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 10:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbiKNPri (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 10:47:38 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91F881ADA5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:47:37 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id j15so19046245wrq.3
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 07:47:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GVA+4J321uM5tz7b8ramzEfb7E2/HDH53nvqav+mhBs=;
        b=OWNUeY148eUrL1o2GIxf5lenkE/ruKDxSrxwltaaaKs4/GzyXKMH6mKmwJ1ZVvrN+9
         Jra7tLU1bZWWuYGdEMpz5bVd9IaVnWGj8FANELRTspE+e1NhLdFOuFijkGmjxC/oqBfu
         WoOqxZMAuf5XR72IWUOrthJru5ur9RxuWkbr91JT96SvLf4xuGrwuxIf0XODjmwxnQbk
         3L4Bfhx3MNpGMNSu+1hRkhT34Pzk6QECHqDN9Jo0G6GG8VkNxypQxgLvoGi+l4kGAIGO
         Iy6FXPsIV4rIGDjbE3vEw1JJ2nEcby/YAUYU1uqr/zGBvojmztcxZO6zy5KtEVWwhOfJ
         8P9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GVA+4J321uM5tz7b8ramzEfb7E2/HDH53nvqav+mhBs=;
        b=s3UKR8o9tq9PE2OYsHCxBP/0N577dyyLrxEmI7ScxBnzGVTNADpVStrfum3nfCmh2u
         kmMBSHrrl+uhVZv752/JVdouT76zXDbNs/JV9lkIYKG1UOdqHysclq6UQXpOZmRFCuta
         FqOflj6tx5Rs1Lx2daVtV8JIQyQyhGrvNVMQjxKf54CMs7dBJ6LtGu0VLmomBXA10EfJ
         4MA7zhwvtkipctNkfdMOcA5lz396PWpxpbaur1YdwYELeepzXEWf3vk1MwDr2OO2YCfz
         raOClpbshpbtHVb9IKVJIVKT4qXOEwwhpn8eNMO5zZ0sMoXgsrBAI0nI6xq9EOIONjRE
         XHhA==
X-Gm-Message-State: ANoB5pkU9ymuX5cYpGlzMzr6MbprFNouFkIFw3cNC6Q14xUt80moTnmT
        acS8ZVc8/yfFLfEtOcR5y7tUkg==
X-Google-Smtp-Source: AA0mqf4HIWEOYavf0ETeTei65t0hMclamVFG1dGwEup1uCd9CCs8SiLthHdecw8YL8I+xQcRbz4lyQ==
X-Received: by 2002:a5d:6742:0:b0:236:74c5:7e2 with SMTP id l2-20020a5d6742000000b0023674c507e2mr7835022wrw.3.1668440856018;
        Mon, 14 Nov 2022 07:47:36 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id r7-20020adfce87000000b00236488f62d6sm10048359wrn.79.2022.11.14.07.47.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 07:47:35 -0800 (PST)
Message-ID: <c27de380-e956-9ac1-1975-a989b8f20550@arista.com>
Date:   Mon, 14 Nov 2022 15:47:29 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH v3 1/3] jump_label: Prevent key->enabled int overflow
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        netdev@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
References: <20221111212320.1386566-1-dima@arista.com>
 <20221111212320.1386566-2-dima@arista.com>
 <Y29vhZ7dWtrlIMAz@hirez.programming.kicks-ass.net>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <Y29vhZ7dWtrlIMAz@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Peter,

Thanks again for reviewing,

On 11/12/22 10:03, Peter Zijlstra wrote:
[..]
>> Prevent the reference counter overflow by checking if (v + 1) > 0.
>> Change functions API to return whether the increment was successful.
>>
>> While at here, provide static_key_fast_inc() helper that does ref
>> counter increment in atomic fashion (without grabbing cpus_read_lock()
>> on CONFIG_JUMP_LABEL=y). This is needed to add a new user for
> 
> -ENOTHERE, did you forget to Cc me on all patches?

I'll Cc you and static_key maintainers on all patches for v4.
Probably, my practice of Cc'ing maintainers only on patches for their
sub-system + cover-letter is a bit outdated and better to Cc on the
whole patch set.

>> a static_key when the caller controls the lifetime of another user.
>> The exact detail where it will be used: if a listen socket with TCP-MD5
>> key receives SYN packet that passes the verification and in result
>> creates a request socket - it's all done from RX softirq. At that moment
>> userspace can't lock the listen socket and remove that TCP-MD5 key, so
>> the tcp_md5_needed static branch can't get disabled. But the refcounter
>> of the static key needs to be adjusted to account for a new user
>> (the request socket).
> 
> Arguably all this should be a separate patch. Also I'm hoping the caller
> does something like WARN on failure?

I thought about it, but did add an error-fallback.
I'll add net_warn_ratelimited() for v4 for such cases.

>> -static inline void static_key_slow_inc(struct static_key *key)
>> +static inline bool static_key_fast_inc(struct static_key *key)
>>  {
>> +	int v, v1;
>> +
>>  	STATIC_KEY_CHECK_USE(key);
>> -	atomic_inc(&key->enabled);
>> +	/*
>> +	 * Prevent key->enabled getting negative to follow the same semantics
>> +	 * as for CONFIG_JUMP_LABEL=y, see kernel/jump_label.c comment.
>> +	 */
>> +	for (v = atomic_read(&key->enabled); v >= 0 && (v + 1) > 0; v = v1) {
>> +		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
>> +		if (likely(v1 == v))
>> +			return true;
>> +	}
> 
> 
> Please, use atomic_try_cmpxchg(), it then turns into something like:
> 
> 	int v = atomic_read(&key->enabled);
> 
> 	do {
> 		if (v < 0 || (v + 1) < 0)
> 			return false;
> 	} while (!atomic_try_cmpxchg(&key->enabled, &v, v + 1))
> 
> 	return true;

Thanks, will do.

> 
>> +	return false;
>>  }
>> +#define static_key_slow_inc(key)	static_key_fast_inc(key)
>>  
>>  static inline void static_key_slow_dec(struct static_key *key)
>>  {
>> diff --git a/kernel/jump_label.c b/kernel/jump_label.c
>> index 714ac4c3b556..f2c1aa351d41 100644
>> --- a/kernel/jump_label.c
>> +++ b/kernel/jump_label.c
>> @@ -113,11 +113,38 @@ int static_key_count(struct static_key *key)
>>  }
>>  EXPORT_SYMBOL_GPL(static_key_count);
>>  
>> -void static_key_slow_inc_cpuslocked(struct static_key *key)
>> +/***
>> + * static_key_fast_inc - adds a user for a static key
>> + * @key: static key that must be already enabled
>> + *
>> + * The caller must make sure that the static key can't get disabled while
>> + * in this function. It doesn't patch jump labels, only adds a user to
>> + * an already enabled static key.
>> + *
>> + * Returns true if the increment was done.
>> + */
>> +bool static_key_fast_inc(struct static_key *key)
> 
> Typically this primitive is called something_inc_not_zero().

Hmm, maybe static_key_fast_inc_not_negative()?

> 
>>  {
>>  	int v, v1;
>>  
>>  	STATIC_KEY_CHECK_USE(key);
>> +	/*
>> +	 * Negative key->enabled has a special meaning: it sends
>> +	 * static_key_slow_inc() down the slow path, and it is non-zero
>> +	 * so it counts as "enabled" in jump_label_update().  Note that
>> +	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
>> +	 */
>> +	for (v = atomic_read(&key->enabled); v > 0 && (v + 1) > 0; v = v1) {
>> +		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
>> +		if (likely(v1 == v))
>> +			return true;
>> +	}
> 
> Idem on atomic_try_cmpxchg().
> 
>> +	return false;
>> +}
>> +EXPORT_SYMBOL_GPL(static_key_fast_inc);
>> +
>> +bool static_key_slow_inc_cpuslocked(struct static_key *key)
>> +{
>>  	lockdep_assert_cpus_held();
>>  
>>  	/*
>> @@ -126,17 +153,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
>>  	 * jump_label_update() process.  At the same time, however,
>>  	 * the jump_label_update() call below wants to see
>>  	 * static_key_enabled(&key) for jumps to be updated properly.
>> -	 *
>> -	 * So give a special meaning to negative key->enabled: it sends
>> -	 * static_key_slow_inc() down the slow path, and it is non-zero
>> -	 * so it counts as "enabled" in jump_label_update().  Note that
>> -	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
>>  	 */
>> -	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
>> -		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
>> -		if (likely(v1 == v))
>> -			return;
>> -	}
> 
> This does not in fact apply, since someone already converted to try_cmpxchg.

Yeah, I based it on the current master, will take a look in linux-next.

Thanks,
          Dmitry
