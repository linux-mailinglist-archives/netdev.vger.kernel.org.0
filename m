Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEAA93220F8
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 21:52:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhBVUwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 15:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbhBVUwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 15:52:39 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C5AC061786
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 12:51:59 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id c5so2707154ioz.8
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 12:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kuUm+XwaOMq3E6+R97zywmgPDYZMExhRWYsNZ2tzM1k=;
        b=fshLji8N5sLxudDYL0zctHxlngBXio5EBB4HIyt9yiFXqb1lvBv7Hbg+a7SdaXnU92
         t0Z88p6rhVp/LijwWirktql4JIJkb3Keslasl6Nr4g75JqqmbL+wXydCnu7Ugt6pdfTv
         qTcfLe0SVAhU+urDYqQa/2mcMfm2rDU+5gpBM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kuUm+XwaOMq3E6+R97zywmgPDYZMExhRWYsNZ2tzM1k=;
        b=NDiT+AeomQByBSCYMeqOCPy5WmdrmzbWLH+o23VE4dA9ULNxSckeTAQJorAiX9IFg5
         UF+pj06koLY2rb+zPQUYV+7eKQ7kzyahw4xuWoos4LUaZAagUL9t4mEYqq0kvK4IHhm7
         Dfl9q9o3A3U3dJAQ3fqesTmhjth7QHM6zR7ImAJ92LSGo0pDPOSiA5kix28NAZdckA/U
         nSbJRS84qs7XYiCN7ZH0Q4EwX0qRxqAmu1mUrU3C1su+Qf5LhPcnwMXK2tcrOXgZf7d9
         3eIWCXgdMcLr3upK4SiDcvFY+saa6Sq0BfzwyLVkCWbgg+hGpZG9HPw8PthXeieExFnH
         CZSw==
X-Gm-Message-State: AOAM532DoOujg1GPlUJTUQgILZo5vKtjM/R9fDhA/Ho0AxqeNfEC4DEz
        Mdbu0jezVfGt+r2InDOzZYuY5g==
X-Google-Smtp-Source: ABdhPJwzv6hjO87ytJYuheqlXuPEKrgLDRMEEqLMjH49Kte3lJoKPb495/7/SFdW8rMylcM2rbxG/A==
X-Received: by 2002:a5e:dd46:: with SMTP id u6mr14196077iop.73.1614027118926;
        Mon, 22 Feb 2021 12:51:58 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id d12sm12524039ila.71.2021.02.22.12.51.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 12:51:58 -0800 (PST)
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
To:     Johannes Berg <johannes@sipsolutions.net>,
        Peter Zijlstra <peterz@infradead.org>
Cc:     mingo@redhat.com, will@kernel.org, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
 <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
 <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
 <20210215104402.GC4507@worktop.programming.kicks-ass.net>
 <79aeb83a288051bd3a2a3f15e5ac42e06f154d48.camel@sipsolutions.net>
 <YCqbehyyeUoL0pPT@hirez.programming.kicks-ass.net>
 <eb819e72fb2d897e603654d44aeda8c6f337453f.camel@sipsolutions.net>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <c9293180-3eba-a5f3-b34e-b44ebdd60077@linuxfoundation.org>
Date:   Mon, 22 Feb 2021 13:51:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <eb819e72fb2d897e603654d44aeda8c6f337453f.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/21 9:10 AM, Johannes Berg wrote:
> On Mon, 2021-02-15 at 17:04 +0100, Peter Zijlstra wrote:
>> On Mon, Feb 15, 2021 at 02:12:30PM +0100, Johannes Berg wrote:
>>> On Mon, 2021-02-15 at 11:44 +0100, Peter Zijlstra wrote:
>>>> I think something like so will work, but please double check.
>>>
>>> Yeah, that looks better.
>>>
>>>> +++ b/include/linux/lockdep.h
>>>> @@ -294,11 +294,15 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
>>>>   
>>>>   #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
>>>>   
>>>> -#define lockdep_assert_held(l)	do {				\
>>>> -		WARN_ON(debug_locks && !lockdep_is_held(l));	\
>>>> +#define lockdep_assert_held(l)	do {					\
>>>> +		WARN_ON(debug_locks && lockdep_is_held(l) == 0));	\
>>>>   	} while (0)
>>>
>>> That doesn't really need to change? It's the same.
>>
>> Correct, but I found it more symmetric vs the not implementation below.
> 
> Fair enough. One might argue that you should have an
> 
> enum lockdep_lock_state {
> 	LOCK_STATE_NOT_HELD, /* 0 now */
> 	LOCK_STATE_HELD, /* 1 now */
> 	LOCK_STATE_UNKNOWN, /* -1 with your patch but might as well be 2 */
> };
> 
> :)
> 


Thank you both. Picking this back up. Will send v2 incorporating
your comments and suggestions.

thanks,
-- Shuah





