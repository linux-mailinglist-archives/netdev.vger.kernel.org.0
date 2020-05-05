Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5791C5DB3
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbgEEQhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729989AbgEEQhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:37:45 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96410C061A0F;
        Tue,  5 May 2020 09:37:45 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id s20so1034757plp.6;
        Tue, 05 May 2020 09:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=un2HqrYJeLi559EHQvGLp0mAi/PQdWiaf/DuAFbu8d4=;
        b=o3lVQd9b0m+nhlAeQR7UtaMZ9mgLlAqgSwwkvq2DlNH9wvUqV9GoYqKPSVhnjcnO3Z
         H7NCKxgckgYptCdu576Uc8hTI+iAvyowdiuk8PzJfxHwDjT02HUNDHBKo6sLVQP50NfB
         X7NYFc1fh+N+4PWMxUUxVEfYq0tXEM9rsb2a5CF/0GgE5NcLbDy3+oJ3afAGgvyv03Nl
         t8HGudY3f7Nm/MjnNW2wwQw+RECIm6YxivfqDoiAzzhcD6OovY3ZJ0W0t7/uFtv3yD1v
         TpeUE4xbdZhW5nCXc1Gu6hDzXtrs1wpbMohaThWHnGwGjOHUFzySluc6QfolBSIzDKh9
         U+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=un2HqrYJeLi559EHQvGLp0mAi/PQdWiaf/DuAFbu8d4=;
        b=j1ypOirTRTOnpzUk+7nV9SjGjCZJNcMwNmxSNmaDb7TX8JluxPwW8AvjG9O0OTUiJ7
         bm0XWkbH1g4q02VQUO0HROFFoQgiszTNWQhcz9R5jfJobTqMCAjzWswf5JSUaJWtxgx2
         z48lJ8A0kgpLjLDElCTBLtDkJ0h+0UXEBgJu7vglalfDgYgtxHObfwE2EpbzGpdPqEGn
         YbrjwOR2/EEvgh58kO/6lGi2MV313oe0g6fwbpIA/yNP2nXs4P7AkqbgpsKEaDe/59XM
         CNCuGL8SQG1EY4+dSaeU6VzvCU2b8L94LHidKPIjkopwkxj0NqGQJzzp3d97ftuoOgF2
         eaIQ==
X-Gm-Message-State: AGi0Puar8F43A8ThRQSETgsxH2yN5Tpqy+eq2ZI60iIbGwQvUegpi9fZ
        v8d/O0MNhB3jky4fiYleX+o=
X-Google-Smtp-Source: APiQypJmWfVc8acKWgsK+7Vqq+NzhGASqeuNjrDjhX+K56+evq1iWmMfx9oOweAvaLn6e6CaJKFEJg==
X-Received: by 2002:a17:902:8a81:: with SMTP id p1mr3990217plo.104.1588696665108;
        Tue, 05 May 2020 09:37:45 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id a129sm2459072pfb.102.2020.05.05.09.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:37:43 -0700 (PDT)
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org,
        Paul McKenney <paulmck@kernel.org>
References: <20200505161302.547-1-sjpark@amazon.com>
 <05843a3c-eb9d-3a0d-f992-7e4b97cc1f19@gmail.com>
 <77124fc2-86b2-27f6-fd7c-4f1e86eb3fff@gmail.com>
Message-ID: <67bdfac9-0d7d-0bbe-dc7a-d73979fd8ed9@gmail.com>
Date:   Tue, 5 May 2020 09:37:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <77124fc2-86b2-27f6-fd7c-4f1e86eb3fff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 9:31 AM, Eric Dumazet wrote:
> 
> 
> On 5/5/20 9:25 AM, Eric Dumazet wrote:
>>
>>
>> On 5/5/20 9:13 AM, SeongJae Park wrote:
>>> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
>>>
>>>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
>>>>>
>>>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>>
>>>>>>
>>>>>>
>>>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
>>>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
>>>>>>>
>>>>>>
>>>>>>>> Why do we have 10,000,000 objects around ? Could this be because of
>>>>>>>> some RCU problem ?
>>>>>>>
>>>>>>> Mainly because of a long RCU grace period, as you guess.  I have no idea how
>>>>>>> the grace period became so long in this case.
>>>>>>>
>>>>>>> As my test machine was a virtual machine instance, I guess RCU readers
>>>>>>> preemption[1] like problem might affected this.
>>>>>>>
>>>>>>> [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
>>>>>>>
>>>>>>>>
>>>>>>>> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
>>>>>>>
>>>>>>> Yes, both the old kernel that prior to Al's patches and the recent kernel
>>>>>>> reverting the Al's patches didn't reproduce the problem.
>>>>>>>
>>>>>>
>>>>>> I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
>>>>>>
>>>>>> TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
>>>>>> object that was allocated in sock_alloc_inode() before Al patches.
>>>>>>
>>>>>> These objects should be visible in kmalloc-64 kmem cache.
>>>>>
>>>>> Not exactly the 10,000,000, as it is only the possible highest number, but I
>>>>> was able to observe clear exponential increase of the number of the objects
>>>>> using slabtop.  Before the start of the problematic workload, the number of
>>>>> objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
>>>>> to 1,136,576.
>>>>>
>>>>>           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>>>> before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
>>>>> after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
>>>>>
>>>>
>>>> Great, thanks.
>>>>
>>>> How recent is the kernel you are running for your experiment ?
>>>
>>> It's based on 5.4.35.
>>>
>>>>
>>>> Let's make sure the bug is not in RCU.
>>>
>>> One thing I can currently say is that the grace period passes at last.  I
>>> modified the benchmark to repeat not 10,000 times but only 5,000 times to run
>>> the test without OOM but easily observable memory pressure.  As soon as the
>>> benchmark finishes, the memory were freed.
>>>
>>> If you need more tests, please let me know.
>>>
>>
>> I would ask Paul opinion on this issue, because we have many objects
>> being freed after RCU grace periods.
>>
>> If RCU subsystem can not keep-up, I guess other workloads will also suffer.
>>
>> Sure, we can revert patches there and there trying to work around the issue,
>> but for objects allocated from process context, we should not have these problems.
>>
> 
> I wonder if simply adjusting rcu_divisor to 6 or 5 would help 
> 
> diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
> index d9a49cd6065a20936edbda1b334136ab597cde52..fde833bac0f9f81e8536211b4dad6e7575c1219a 100644
> --- a/kernel/rcu/tree.c
> +++ b/kernel/rcu/tree.c
> @@ -427,7 +427,7 @@ module_param(qovld, long, 0444);
>  static ulong jiffies_till_first_fqs = ULONG_MAX;
>  static ulong jiffies_till_next_fqs = ULONG_MAX;
>  static bool rcu_kick_kthreads;
> -static int rcu_divisor = 7;
> +static int rcu_divisor = 6;
>  module_param(rcu_divisor, int, 0644);
>  
>  /* Force an exit from rcu_do_batch() after 3 milliseconds. */
> 

To be clear, you can adjust the value without building a new kernel.

echo 6 >/sys/module/rcutree/parameters/rcu_divisor


