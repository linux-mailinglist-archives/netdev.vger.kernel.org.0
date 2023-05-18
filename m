Return-Path: <netdev+bounces-3709-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03A04708649
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:59:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0B3A1C21150
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 16:59:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA1624E86;
	Thu, 18 May 2023 16:59:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F218A23C90
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 16:59:51 +0000 (UTC)
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6937B121
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:59:50 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-253340db64fso2277886a91.2
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 09:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684429190; x=1687021190;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WqqOwTs/oeF4DjGgjjyIV3XzkitCBD7LbtEQ7FSlFqg=;
        b=iQEC1gqSiLU7cnFE/jj0dFCfldoD1dWXqBWFxk+p1iirpwqEdfI344GdJTCpmizvNs
         +pR2IvIjlFdF9aXfRLQ71Xlwl+maxwpBjulnw9aGJFdbphZ9rIsSBxr/Eug9lx73reBH
         GEM9hVBV3dRKAvOWxb8aNmabbCTLbm82QPoVEtgBugd8NsOrvMyZZ2j5hN08La9bBUOF
         LxJfiuP67wjO9DsoLMcN38ETa7iHu8aNiJI1m4+zg+kR0841kjzhGPU6+uqJcoV4D0Ov
         emMhJlPXQRyivHH6UdpvcWFEmzlI0Dn9lPmquZjC0R2JDJ2MJmvDLPD/2s09KgoLQ+iY
         TYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684429190; x=1687021190;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WqqOwTs/oeF4DjGgjjyIV3XzkitCBD7LbtEQ7FSlFqg=;
        b=i2ievxHtzFjvhXUcvFfKYq5VtXgqjAbnpCyXvWe9i2Go9s80nXeKkSjdwHNEBkv0ie
         IbOrEfXnphM+dBr7JVvfxG6C0aKVtDqkkByClZo8lTSmX+jOD8tdKPj3r943rS6aNOVO
         qXZVrgUvud/pTPcA61J/4CqLMBHVmwwS21nNRmmk+ruHVWHL5GsS2shtthinwLgVUwHZ
         erOUBXVGZlDjuGVPM62ox2kJ9k7GGq0jveQGE7bAy92QeIVnswCTptOCAPaeyFNUFQHg
         ai8tO7BzaLUOwq0Oj5fsoLmVe5rPTY8hL17HHMC9vs4Kffc41EdIi/CXkuaVGVYbqTwi
         aphw==
X-Gm-Message-State: AC+VfDwlMkEs2pSSH7i8oegHNxdU2S9q+hPwnZgJB1pJNLXH5UnAGQCi
	iHaeN0L8HAzR6x8bP5U1VwA=
X-Google-Smtp-Source: ACHHUZ5SGm2gChz5cUIaUmBJuz1VQSgo8Rd1sd4Ftt27tqSRCoEeQLl7foeLEQh15CtVtNnz3muhTg==
X-Received: by 2002:a17:90a:3b47:b0:253:2995:f4a6 with SMTP id t7-20020a17090a3b4700b002532995f4a6mr3460078pjf.38.1684429189805;
        Thu, 18 May 2023 09:59:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:7374:c6c4:9c8a:8ad2? ([2600:1700:6cf8:1240:7374:c6c4:9c8a:8ad2])
        by smtp.gmail.com with ESMTPSA id o4-20020a17090a4e8400b0024de5227d1fsm1595304pjh.40.2023.05.18.09.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 09:59:49 -0700 (PDT)
Message-ID: <8331928c-a525-ff99-d06e-21e769982770@gmail.com>
Date: Thu, 18 May 2023 09:59:45 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC PATCH net-next v2 0/2] Mitigate the Issue of Expired Routes
 in Linux IPv6 Routing Tables
Content-Language: en-US
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: David Ahern <dsahern@kernel.org>, Kui-Feng Lee <thinker.li@gmail.com>,
 netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, Kui-Feng Lee <kuifeng@meta.com>,
 Ido Schimmel <idosch@idosch.org>
References: <20230517183337.190591-1-kuifeng@meta.com>
 <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
 <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
 <20230518084335.5ed41e3f@hermes.local>
From: Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <20230518084335.5ed41e3f@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/18/23 08:43, Stephen Hemminger wrote:
> On Wed, 17 May 2023 22:40:08 -0700
> Kui-Feng Lee <sinquersw@gmail.com> wrote:
> 
>>>> Solution
>>>> ========
>>>>
>>>> The cause of the issue is keeping the routing table locked during the
>>>> traversal of large tries. To address this, the patchset eliminates
>>>> garbage collection that does the tries traversal and introduces
>>>> individual timers for each route that eventually expires.  Walking
>>>> trials are no longer necessary with the timers. Additionally, the time
>>>> required to handle a timer is consistent.
>>>
>>> And then for the number of routes mentioned above what does that mean
>>> for having a timer per route? If this is 10's or 100's of 1000s of
>>> expired routes what does that mean for the timer subsystem dealing with
>>> that number of entries on top of other timers and the impact on the
>>> timer softirq? ie., are you just moving the problem around.
>>
>> Yes, each expired route has a timer.  But, not all routes have expire
>> times.  The timer subsystem will handle every single one. Let me
>> address the timer subsystem later.
>>
>>>
>>> did you consider other solutions? e.g., if it is the notifier, then
>>> perhaps the entries can be deleted from the fib and then put into a list
>>> for cleanup in a worker thread.
>>
>> Yes, I considered to keep a separated list of routes that is expiring,
>> just like what neighbor tables do.  However, we need to sort them in the
>> order of expire times.  Other solutions can be a RB-tree or priority
>> queues. However, later, I went to the timers solution suggested by
>> Martin Lau.
>>
>> If I read it correctly, the timer subsystem handles each
>> timer with a constant time.  It puts timers into buckets and levels.
>> Every level means different granularity.  For example, it has
>> granularity of 1ms, 8ms (level 0), 64ms, 512ms, ... up to 4 hours
>> (level 8) for 1000Hz.  Each level (granularity) has 64 buckets.
>> Every bucket represent a time slot. That means level 0 holds
>> timers that is expiring in 0ms~63ms in its 64 buckets, level 1 holds
>> timers that is expiring in 64ms~511ms, ... so on.  What the timer
>> subsystem does is to emit every timers in the corresponding current
>> buckets of every level.  In other word, it checks the current bucket
>> from level 0 ~ level 8, and emit timers if there is any timer
>> in the buckets.
>>
>> In contrast, the current GC has to walk every tree even only one route
>> expired.  Timers is far better. It emits every timer in the
>> buckets associated with current time, no search needed.  The current GC
>> is triggered by a timer as well.  So, it should reduce the computation
>> of the timer softirq.
>>
>> However, just like what I mentioned earlier, the drawback of timers are
>> its granularity can vary.  The longer expiration time means more coarse-
>> grained.  But, it probably is not a big issue.
> 
> If Linux is used on backbone router it can easily have 3 million routes
> to deal with. That won't make timer subsystem happy.

I will run experiments to get numbers to see how the compact
actually is.



