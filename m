Return-Path: <netdev+bounces-3749-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E8DA0708802
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 20:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A612A281916
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 18:51:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB2C711C82;
	Thu, 18 May 2023 18:51:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF04C6FB8
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 18:51:51 +0000 (UTC)
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5D2B0
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:51:50 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5617d793160so30650947b3.2
        for <netdev@vger.kernel.org>; Thu, 18 May 2023 11:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684435909; x=1687027909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kIVdbaEhVk93M3nX12htwcZ63jkFGHV4OL6ORcWI358=;
        b=eMRVsjmyS3MUe2KLpnbxbL8FVetii/LUJ3/LZbLZxeLj/uHhzR02aKY1OhG8K0MHAG
         mb7TpV+8ZjVnQTVpBufR+9nSSaZeGCadDRjC/dIBXRBmfBZzJNSmmakI/13y7kTs1KkD
         B94CF88NEU2mDcp2FHYi/XV8kdikKIgSr1Z2NxLpWRguFZLJCemFNcTbYxGVGh9hk8mn
         pVvqiFS/GmO0xe3krPOYffWoiW3yzMQyUk6bXpmF2G1gIT8aD92i7q1zbIRhUTQDtTmU
         nTCwFZ0+l5FgRqBVSR+2bMDqYH0xhB9Hd3GJId2fnv+PMJYyjvD7T10VlKfiRQmtX9jn
         aXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684435909; x=1687027909;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kIVdbaEhVk93M3nX12htwcZ63jkFGHV4OL6ORcWI358=;
        b=B1EhBtwaW8OhjD+EJ3DkjolZAaPYkhZImKBpA0ojN5PzIM7Zc8p6s1VKnxJ0A5ZiNE
         Q/bgrrtdgOLK1mYunXUCpIWi2wFiA6W1O+LCMmNtvuQsbbsW3sDtL17IiC4dwLj8m2zl
         2JzhKIgu+yFBdN5MTOfP4initTbyaK+HQpL65P4HlPOxxTj0wkcgldW/mQY5ASJw8foM
         +RBmH4mKp5P+FxK6E2zJAzqh04QnXIvu9lSt+jMdyMpuqWEtQwVVhXXmYwW/+7Kqv1XR
         iME6CuAad0vgIeKdd6X/UACCO+N/soVSaqsoH1P8uGzrbO6myZvZYsSNjHbKYxwq5cGP
         dppA==
X-Gm-Message-State: AC+VfDzROoGyoDh/JK9XiXbATZ/NUis9rNbC9bCupXuls07iALFiStNp
	PTY9Sh25SbIQ7c82x7Bi6yc=
X-Google-Smtp-Source: ACHHUZ6RvTRNvLWEP0EwCAJxN26VtVeekcPFVF3mrJzcBtiXFH0rlnbBsDqVGN+qtau+qbmh5XO2Nw==
X-Received: by 2002:a81:c30f:0:b0:55a:a57e:7de6 with SMTP id r15-20020a81c30f000000b0055aa57e7de6mr2236800ywk.15.1684435909242;
        Thu, 18 May 2023 11:51:49 -0700 (PDT)
Received: from ?IPV6:2600:1700:6cf8:1240:f079:1384:f3a6:b50d? ([2600:1700:6cf8:1240:f079:1384:f3a6:b50d])
        by smtp.gmail.com with ESMTPSA id x206-20020a817cd7000000b005620b573934sm365089ywc.128.2023.05.18.11.51.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 May 2023 11:51:48 -0700 (PDT)
Message-ID: <1284f846-f8ed-d95a-4476-40e2de26c092@gmail.com>
Date: Thu, 18 May 2023 11:51:47 -0700
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
 <337e31f2-9619-0db5-2782-dea1b0443d97@gmail.com>
 <15c7358b-ab69-38af-60fc-d6c8778f25e8@kernel.org>
From: Kui-Feng Lee <sinquersw@gmail.com>
In-Reply-To: <15c7358b-ab69-38af-60fc-d6c8778f25e8@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/18/23 08:28, David Ahern wrote:
> On 5/17/23 11:40 PM, Kui-Feng Lee wrote:
>>
>>
>> On 5/17/23 20:21, David Ahern wrote:
>>> On 5/17/23 12:33 PM, Kui-Feng Lee wrote:
>>>> This RFC is resent to ensure maintainers getting awared.  Also remove
>>>> some forward declarations that we don't use anymore.
>>>>
>>>> The size of a Linux IPv6 routing table can become a big problem if not
>>>> managed appropriately.  Now, Linux has a garbage collector to remove
>>>> expired routes periodically.  However, this may lead to a situation in
>>>> which the routing path is blocked for a long period due to an
>>>> excessive number of routes.
>>>
>>> I take it this problem was seen internally to your org? Can you give
>>> representative numbers on how many routes, stats on the blocked time,
>>> and reason for the large time block (I am guessing the notifier)?
>>
>> We don't have existing incidents so far.  Consider it as
>> a potential issue.
> 
> So no data to compare how the system was operating before and after.

I can generate traffic to test it.

> 
> ...
> 
>>
>> In contrast, the current GC has to walk every tree even only one route
>> expired.
> 
> As I recall the largest overhead is systems (e.g., switchdev) handling
> the notifier. The tree walk scaling problem can be addressed with a much
> simpler change -- e.g., add a list_head per fib6_table for fib6_info
> entries that can expire and make the list time sorted. Then the gc only
> needs to walk those lists up to the expired point.

This is one of solutions I considered at beginning.
With this approach, we can have a maximum
number of entries like what neighbor tables do.
Remove entries only if the list reach the maximum without running
a GC timer.  However, it can be very inefficient to insert a new entry
ordered. Stephen mentioned 3 million routes on backbone router
in another message.  We may need something more complicated
like RB-tree or HEAP to reduce the overhead.

