Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7A1C5D6B
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgEEQZM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729455AbgEEQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:25:12 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A09C061A0F;
        Tue,  5 May 2020 09:25:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b6so985546plz.13;
        Tue, 05 May 2020 09:25:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oxHsmVrleduKbLfAdqcEQpbtGTwe8qx1AwhsOsfeLyk=;
        b=Qg/ZENHDNjH6IzMJDZxDsrruyETFW2jgFsFCGCeaJiUV9nGDSl+cZ5OvakprNCSsWG
         Fr1Bwz6GnUxJi3qJnhCckUnEkOlzTwMYGf1o0kgMNtYaaF2Z8+wMHnwY8MbcyIjNTy7J
         QD5EZ4ez25L449ERjGWZLZHoBMCdaVg5/ipgrdaRS+PiurMW0cfTmoZ88ibznaIaj0mw
         h/0rYTlVQOCVZDsUS8OW4K0543o601VBShrPweuJ43dkuVc7iN2oH6ylARE8wDQvO/qi
         oboYXXMzqaKC61dRofsVXe3I3J0dPELQ2czrgC9A+yQcc7JEpfCmluMKGAAq3Mlrejbj
         JsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oxHsmVrleduKbLfAdqcEQpbtGTwe8qx1AwhsOsfeLyk=;
        b=GvYPYJ9OYUHU7I+ncihZPdZn2cJcFnO2Sp4Fwvtl6lOKQeetBYuQae7APe0XHFvdbJ
         suKgQeINWjhPvmcHc05kYXi0rbrELHudy76o7bb4fjESKwq1U17OJ+7xys/9sa0i4UNK
         /J74p6Tb+nm5+yTc2kLY7qbf3yInh5LjYlYP2Ym1etn+Npgg9IXlb+3Vkp7tfgO/qs62
         wv5WCWSqtNU1/6epj1yw2kx4JIQfB1x0fLHPKHdS7IW7hl2ojV8gYT3ylvYI5SsuP9vk
         69SZIPoin9o1QT5t1PDKeaJQ8q+BPQnpWGuVoE9khhtOWLGdGp2WqJtawtvzleHXm7hN
         JFmw==
X-Gm-Message-State: AGi0PuYk6ErWn3K+dxCT3yDh4BphplBnTnAEhNqPm1GH+fCHMZpKax+D
        qpEIqw5aZRGKB6CeDlOu/78=
X-Google-Smtp-Source: APiQypJdbWorU29J+5XCwUEq8a7RsykO7yMqOYnf6AL3ogkg9z1+4w58MWnNxe1exg1o+QoNMAMhhg==
X-Received: by 2002:a17:902:bd02:: with SMTP id p2mr3870012pls.72.1588695911524;
        Tue, 05 May 2020 09:25:11 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id x23sm1798701pgf.32.2020.05.05.09.25.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 09:25:09 -0700 (PDT)
Subject: Re: [PATCH net v2 0/2] Revert the 'socket_alloc' life cycle change
To:     SeongJae Park <sjpark@amazon.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        sj38.park@gmail.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        SeongJae Park <sjpark@amazon.de>, snu@amazon.com,
        amit@kernel.org, stable@vger.kernel.org,
        Paul McKenney <paulmck@kernel.org>
References: <20200505161302.547-1-sjpark@amazon.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <05843a3c-eb9d-3a0d-f992-7e4b97cc1f19@gmail.com>
Date:   Tue, 5 May 2020 09:25:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200505161302.547-1-sjpark@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/5/20 9:13 AM, SeongJae Park wrote:
> On Tue, 5 May 2020 09:00:44 -0700 Eric Dumazet <edumazet@google.com> wrote:
> 
>> On Tue, May 5, 2020 at 8:47 AM SeongJae Park <sjpark@amazon.com> wrote:
>>>
>>> On Tue, 5 May 2020 08:20:50 -0700 Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>
>>>>
>>>>
>>>> On 5/5/20 8:07 AM, SeongJae Park wrote:
>>>>> On Tue, 5 May 2020 07:53:39 -0700 Eric Dumazet <edumazet@google.com> wrote:
>>>>>
>>>>
>>>>>> Why do we have 10,000,000 objects around ? Could this be because of
>>>>>> some RCU problem ?
>>>>>
>>>>> Mainly because of a long RCU grace period, as you guess.  I have no idea how
>>>>> the grace period became so long in this case.
>>>>>
>>>>> As my test machine was a virtual machine instance, I guess RCU readers
>>>>> preemption[1] like problem might affected this.
>>>>>
>>>>> [1] https://www.usenix.org/system/files/conference/atc17/atc17-prasad.pdf
>>>>>
>>>>>>
>>>>>> Once Al patches reverted, do you have 10,000,000 sock_alloc around ?
>>>>>
>>>>> Yes, both the old kernel that prior to Al's patches and the recent kernel
>>>>> reverting the Al's patches didn't reproduce the problem.
>>>>>
>>>>
>>>> I repeat my question : Do you have 10,000,000 (smaller) objects kept in slab caches ?
>>>>
>>>> TCP sockets use the (very complex, error prone) SLAB_TYPESAFE_BY_RCU, but not the struct socket_wq
>>>> object that was allocated in sock_alloc_inode() before Al patches.
>>>>
>>>> These objects should be visible in kmalloc-64 kmem cache.
>>>
>>> Not exactly the 10,000,000, as it is only the possible highest number, but I
>>> was able to observe clear exponential increase of the number of the objects
>>> using slabtop.  Before the start of the problematic workload, the number of
>>> objects of 'kmalloc-64' was 5760, but I was able to observe the number increase
>>> to 1,136,576.
>>>
>>>           OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
>>> before:   5760   5088  88%    0.06K     90       64       360K kmalloc-64
>>> after:  1136576 1136576 100%    0.06K  17759       64     71036K kmalloc-64
>>>
>>
>> Great, thanks.
>>
>> How recent is the kernel you are running for your experiment ?
> 
> It's based on 5.4.35.
> 
>>
>> Let's make sure the bug is not in RCU.
> 
> One thing I can currently say is that the grace period passes at last.  I
> modified the benchmark to repeat not 10,000 times but only 5,000 times to run
> the test without OOM but easily observable memory pressure.  As soon as the
> benchmark finishes, the memory were freed.
> 
> If you need more tests, please let me know.
> 

I would ask Paul opinion on this issue, because we have many objects
being freed after RCU grace periods.

If RCU subsystem can not keep-up, I guess other workloads will also suffer.

Sure, we can revert patches there and there trying to work around the issue,
but for objects allocated from process context, we should not have these problems.



