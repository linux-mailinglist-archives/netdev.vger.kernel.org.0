Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF57D242C16
	for <lists+netdev@lfdr.de>; Wed, 12 Aug 2020 17:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgHLPUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Aug 2020 11:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbgHLPUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Aug 2020 11:20:01 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00897C061383
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:20:00 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h12so1207601pgm.7
        for <netdev@vger.kernel.org>; Wed, 12 Aug 2020 08:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H+HYObw56u4yC2weecsOB/a0gkywmgDNeAc7OsdDbrA=;
        b=KB3UqNYF3LHC0eYaQCa6oedJhMuFJRpNHdN+aFJTcvZSuXy49fIU5QPARJ6DpffQ8K
         /TrAhTyv4LDJ3F/J8m91sjgjlVnbWFAlejPajTnd9BffCyMG/Qm26VX+NVLcw7sWbMMQ
         3vvOg7ygpN2OJmooBqJLPA/pO5c+YmeAhJISnALP6BBlht/npXZvPF7inx2fLW8WJSiH
         bA8DNaZpcFcG8zMwR1Ggp6+PtSwApbTRY3ZBXk8gPv9XXwWAG52wRhNFBKfLT0UZJiJp
         N66Mfvwvrzzv3iJI/D949oPOz8Uh57oEEg2uSFHaTlZNUZmHQGmrK1MewJ8t0Ey3GPro
         DUGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H+HYObw56u4yC2weecsOB/a0gkywmgDNeAc7OsdDbrA=;
        b=M0ZQduSI1IdjO62IyRdGZDzcowyh/viGnKPY6FFFT8fcCXUaZhoeokOjG0BtJbuYns
         OsMnsGcF+k/NGBehvCNiRGSiBswRj8c5BYXk7BvytSo8jPBNSQ3AMCD03a0MeE+VaJhR
         CGOAjyBM4ogJDUzYrahH8g1HFJ5oeeXB7zmFhQ7ZuSyX0aGAu2KEUWEYXXsNDu8axLwH
         IYJWViK85+gWaeSdf95h6g/CW3DrX7SJc3wUVlDUTLQQEjlbKIPjPpqpj/gTx0qF7g9x
         o6I7JKRzLo/9+rYjW6P3cVJMt9CaJaJaEwEGg2ISyrjIiIjq+Uic56ZmSha3MhoIzhxt
         4CTQ==
X-Gm-Message-State: AOAM533AzxZk5npLz/c+9hQJwgKFSICkWLiwkQnMVHo1nAqGIC7bKDIG
        k/yFnz/9bJV7//cn9pQ/cxg=
X-Google-Smtp-Source: ABdhPJyPlgnL3UYrAT9lNCJDIw4WaaFoikt3zvHxHZ7lcL9SLcLudfKYB9hBOaZhliezA/qq+GhsKw==
X-Received: by 2002:a63:2543:: with SMTP id l64mr5632544pgl.164.1597245600611;
        Wed, 12 Aug 2020 08:20:00 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d22sm2789006pfd.42.2020.08.12.08.19.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2020 08:19:59 -0700 (PDT)
Subject: Re: [PATCH net] net: accept an empty mask in
 /sys/class/net/*/queues/rx-*/rps_cpus
To:     peterz@infradead.org,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Alex Belits <abelits@marvell.com>,
        Nitesh Narayan Lal <nitesh@redhat.com>
References: <20200812013440.851707-1-edumazet@google.com>
 <CANP3RGc6Gz73Gt3v9M7KYNeNd57o--=3mF6yqdRjqOViG+TG7A@mail.gmail.com>
 <20200812080049.GH2674@hirez.programming.kicks-ass.net>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b54cee03-77bc-eaa8-c67a-04e4d56e44fe@gmail.com>
Date:   Wed, 12 Aug 2020 08:19:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200812080049.GH2674@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/20 1:00 AM, peterz@infradead.org wrote:
> On Tue, Aug 11, 2020 at 06:45:23PM -0700, Maciej Żenczykowski wrote:
>> On Tue, Aug 11, 2020 at 6:34 PM Eric Dumazet <edumazet@google.com> wrote:
>>
>>> We must accept an empty mask in store_rps_map(), or we are not able
>>> to disable RPS on a queue.
>>>
>>> Fixes: 07bbecb34106 ("net: Restrict receive packets queuing to
>>> housekeeping CPUs")
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Reported-by: Maciej Żenczykowski <maze@google.com>
>>> Cc: Alex Belits <abelits@marvell.com>
>>> Cc: Nitesh Narayan Lal <nitesh@redhat.com>
>>> Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> ---
>>>  net/core/net-sysfs.c | 12 +++++++-----
>>>  1 file changed, 7 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
>>> index
>>> 9de33b594ff2693c054022a42703c90084122444..efec66fa78b70b2fe5b0a5920317eb1d0415d9e3
>>> 100644
>>> --- a/net/core/net-sysfs.c
>>> +++ b/net/core/net-sysfs.c
>>> @@ -757,11 +757,13 @@ static ssize_t store_rps_map(struct netdev_rx_queue
>>> *queue,
>>>                 return err;
>>>         }
>>>
>>> -       hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
>>> -       cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
>>> -       if (cpumask_empty(mask)) {
>>> -               free_cpumask_var(mask);
>>> -               return -EINVAL;
>>> +       if (!cpumask_empty(mask)) {
>>> +               hk_flags = HK_FLAG_DOMAIN | HK_FLAG_WQ;
>>> +               cpumask_and(mask, mask, housekeeping_cpumask(hk_flags));
>>> +               if (cpumask_empty(mask)) {
>>> +                       free_cpumask_var(mask);
>>> +                       return -EINVAL;
>>> +               }
>>>         }
> 
> Ah indeed! Sorry about that.
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> 

No worries, thanks for the review guys.

We probably should add a test doing something like

echo ffffffff >/sys/class/net/lo/queues/rx-0/rps_cpus
echo 0 >/sys/class/net/lo/queues/rx-0/rps_cpus

