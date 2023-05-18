Return-Path: <netdev+bounces-3507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43DA07079B7
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 07:40:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A3241C21013
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 05:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3A11382;
	Thu, 18 May 2023 05:40:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E81D137D
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 05:40:13 +0000 (UTC)
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBCC2D49
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:40:11 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id 3f1490d57ef6-b9a7e639656so2578069276.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 22:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684388410; x=1686980410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u3xXMu8l/4bf/vrew2isCDMT1JwU+wM3xOvA0LRXCwU=;
        b=MV68iLUAjyfk4bFByitJTM0/Lp9XEYqnKGHhbKN4rbOURJSFU+/j+c3gHDnXMbvddt
         I6ZKv0dO1oUZhQNnAr2D4xaPlh730IVvFQZTwHGItz97/SiZPXUUL2dxyUcubkzk33yL
         Nn5lKnb5d6Bmb/jvPsUeeInSp0S3WzLqaA6hgvOpdB7pTgn7CASMtEIBtuzqcHdRiat4
         XDVwoa3uS/dqHFRns0jdqqT3MUreClU92mYxQbxMEF/efyGnnCpjtrEYIjt5UYGdc95g
         9asPWL48oYs6/7pWtQCJqJnlXUa2tlja8rq6/FsVqtwIX6gSZSaQQ/C5uc5UH6HWJ77j
         XglQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684388410; x=1686980410;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3xXMu8l/4bf/vrew2isCDMT1JwU+wM3xOvA0LRXCwU=;
        b=kKyGe0KuxCVSynM3uzFs5zegFVq0fAuXq7nbu4lNqQben/rp0KNlpXjKtrYqK4aHpc
         WHklk56kzyXjqyDhKjiJuoQxSKqlXBkYSMUp/ULuBRFrILWaEpl//bXGg7MdzNpUnJWE
         ZuJ/e+oXm08Gc/6Z751WziF8sIJUpJXzU42VC/yKV0uWIjCfpld3d+FZ3Mku8HQIufrL
         /dutU71/uzvSF7g0n3NPDUxRMLBZlzn9cL23QWRr07Y59FcxKm7KcEDNh0IvQhDupFzO
         ivYXGASWULQrJi6r/xO3ryCMnzKJz0qSHZvmJMVPHfoGF0/r80Y9bM72bwuLLy4Nwo9a
         DIew==
X-Gm-Message-State: AC+VfDzGBpPYtl3lqp9FTbrFLcxjPl3mOekP7a1WvHSQWMTUanIuo/o4
	3YicQUc00YKSZCK3yKgrpoJ4sCVmqXQQ2Q==
X-Google-Smtp-Source: ACHHUZ43G++RG7VTb/2eK7nvWLH75HcWOGlqwU3zuhBG/GOe4EDc4DedTU6m3DnVUnhxbTCdBtX+8Q==
X-Received: by 2002:a25:40d7:0:b0:ba8:66fb:dd86 with SMTP id n206-20020a2540d7000000b00ba866fbdd86mr381552yba.25.1684388410230;
        Wed, 17 May 2023 22:40:10 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:f084:fde8:d62e:32fe? ([2600:1700:6cf8:1240:f084:fde8:d62e:32fe])
        by smtp.gmail.com with ESMTPSA id d203-20020a25e6d4000000b00ba63c25add6sm142261ybh.38.2023.05.17.22.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 22:40:09 -0700 (PDT)
Message-ID: <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
Date: Wed, 17 May 2023 22:40:08 -0700
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
To: David Ahern <dsahern@kernel.org>, Kui-Feng Lee <thinker.li@gmail.com>,
 netdev@vger.kernel.org, ast@kernel.org, martin.lau@linux.dev,
 kernel-team@meta.com, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com
Cc: Kui-Feng Lee <kuifeng@meta.com>, Ido Schimmel <idosch@idosch.org>
References: <20230517183337.190591-1-kuifeng@meta.com>
 <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
From: Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <61248e45-c619-d5f2-95a0-5971593fbe8d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/17/23 20:21, David Ahern wrote:
> On 5/17/23 12:33 PM, Kui-Feng Lee wrote:
>> This RFC is resent to ensure maintainers getting awared.  Also remove
>> some forward declarations that we don't use anymore.
>>
>> The size of a Linux IPv6 routing table can become a big problem if not
>> managed appropriately.  Now, Linux has a garbage collector to remove
>> expired routes periodically.  However, this may lead to a situation in
>> which the routing path is blocked for a long period due to an
>> excessive number of routes.
> 
> I take it this problem was seen internally to your org? Can you give
> representative numbers on how many routes, stats on the blocked time,
> and reason for the large time block (I am guessing the notifier)?

We don't have existing incidents so far.  Consider it as
a potential issue.

> 
>>
>> For example, years ago, there is a commit about "ICMPv6 Packet too big
>> messages".  The root cause is that malicious ICMPv6 packets were sent
>> back for every small packet sent to them. These packets have to
>> lookup/insert a new route, putting hosts under high stress due to
>> contention on a spinlock while one is stuck in fib6_run_gc().
>>
>> Why Route Expires
>> =================
>>
>> Users can add IPv6 routes with an expiration time manually. However,
>> the Neighbor Discovery protocol may also generate routes that can
>> expire.  For example, Router Advertisement (RA) messages may create a
>> default route with an expiration time. [RFC 4861] For IPv4, it is not
>> possible to set an expiration time for a route, and there is no RA, so
>> there is no need to worry about such issues.
>>
>> Create Routes with Expires
>> ==========================
>>
>> You can create routes with expires with the  command.
>>
>> For example,
>>
>>      ip -6 route add 2001:b000:591::3 via fe80::5054:ff:fe12:3457 \
>>          dev enp0s3 expires 30
> 
> 
>>
>> The route that has been generated will be deleted automatically in 30
>> seconds.
>>
>> GC of FIB6
>> ==========
>>
>> The function called fib6_run_gc() is responsible for performing
>> garbage collection (GC) for the Linux IPv6 stack. It checks for the
>> expiration of every route by traversing the tries of routing
>> tables. The time taken to traverse a routing table increases with its
>> size. Holding the routing table lock during traversal is particularly
>> undesirable. Therefore, it is preferable to keep the lock for the
>> shortest possible duration.
>>
>> Solution
>> ========
>>
>> The cause of the issue is keeping the routing table locked during the
>> traversal of large tries. To address this, the patchset eliminates
>> garbage collection that does the tries traversal and introduces
>> individual timers for each route that eventually expires.  Walking
>> trials are no longer necessary with the timers. Additionally, the time
>> required to handle a timer is consistent.
> 
> And then for the number of routes mentioned above what does that mean
> for having a timer per route? If this is 10's or 100's of 1000s of
> expired routes what does that mean for the timer subsystem dealing with
> that number of entries on top of other timers and the impact on the
> timer softirq? ie., are you just moving the problem around.

Yes, each expired route has a timer.  But, not all routes have expire
times.  The timer subsystem will handle every single one. Let me
address the timer subsystem later.

> 
> did you consider other solutions? e.g., if it is the notifier, then
> perhaps the entries can be deleted from the fib and then put into a list
> for cleanup in a worker thread.

Yes, I considered to keep a separated list of routes that is expiring,
just like what neighbor tables do.  However, we need to sort them in the
order of expire times.  Other solutions can be a RB-tree or priority
queues. However, later, I went to the timers solution suggested by
Martin Lau.

If I read it correctly, the timer subsystem handles each
timer with a constant time.  It puts timers into buckets and levels.
Every level means different granularity.  For example, it has
granularity of 1ms, 8ms (level 0), 64ms, 512ms, ... up to 4 hours
(level 8) for 1000Hz.  Each level (granularity) has 64 buckets.
Every bucket represent a time slot. That means level 0 holds
timers that is expiring in 0ms~63ms in its 64 buckets, level 1 holds
timers that is expiring in 64ms~511ms, ... so on.  What the timer
subsystem does is to emit every timers in the corresponding current
buckets of every level.  In other word, it checks the current bucket
from level 0 ~ level 8, and emit timers if there is any timer
in the buckets.

In contrast, the current GC has to walk every tree even only one route
expired.  Timers is far better. It emits every timer in the
buckets associated with current time, no search needed.  The current GC
is triggered by a timer as well.  So, it should reduce the computation
of the timer softirq.

However, just like what I mentioned earlier, the drawback of timers are
its granularity can vary.  The longer expiration time means more coarse-
grained.  But, it probably is not a big issue.

> 
>>
>> If the expiration time is long, the timer becomes less precise. The
>> drawback is that the longer the expiration time, the less accurate the
>> timer.
>>
>> Kui-Feng Lee (2):
>>    net: Remove expired routes with separated timers.
>>    net: Remove unused code and variables.
>>
>>   include/net/ip6_fib.h    |  21 ++---
>>   include/net/ip6_route.h  |   2 -
>>   include/net/netns/ipv6.h |   6 --
>>   net/ipv6/addrconf.c      |   8 +-
>>   net/ipv6/ip6_fib.c       | 162 ++++++++++++++++++---------------------
>>   net/ipv6/ndisc.c         |   4 +-
>>   net/ipv6/route.c         | 120 ++---------------------------
>>   7 files changed, 95 insertions(+), 228 deletions(-)
>>
> 
> 

