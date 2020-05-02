Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DC01C26F0
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 18:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgEBQYW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 May 2020 12:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728361AbgEBQYW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 May 2020 12:24:22 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF4AEC061A0C
        for <netdev@vger.kernel.org>; Sat,  2 May 2020 09:24:21 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id a21so1320684pls.4
        for <netdev@vger.kernel.org>; Sat, 02 May 2020 09:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=co/xPmE5MUf3ZKDSKH5h07chdI1gN8lESoboH8HHhS8=;
        b=TiGhmQ9mvovYtc0gskkrRSbDCbAUhry56bo4SsyLnnVKL8NiG6R/WjgexjsAzuLWN7
         SJkh4uTwqnkQMWZ0xt0CkKAyvgHtSmmV6f0cifz+00JpJnIIoeshWpvTejO5zkUPVnmV
         CEtVcFpsVlkNycqjP9TCiNiQM+etUr5qjzr60v58oaAm0PrT2oiCOrWwCo4U9PnHd1fM
         PFaMz7uCoXifT0pyP8aWLQGEcBiHdsazgSqzI/YXc8OyOh05oDuAq5QVA0h68Lio3TOU
         FJfSE6Mip7lo7GRTbu41ME5uvpJx3n4MsyJ7VS9wX7fDs4U425Jc70c+gSyU5J/7yvd1
         7/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=co/xPmE5MUf3ZKDSKH5h07chdI1gN8lESoboH8HHhS8=;
        b=D276pJj97Qk4qy/yKclQtowt4cACG0kOpmDCE1wQq66DQzi0bsWajCg72rlJSjXXhJ
         G4/fmInkmqbrDL/APFyyYpEK1RVDqiLULgA+tSsCuldbdeAqli5TZQrFXSo0n1qnNs1s
         XwTUTc66py1KSuFMauYSUKL2pIcBpJ6NVW7UZr6gHm31GRmKJY18XSQBlV3Q6UXS9woE
         UfBTmOuDvwDL/RWSFwAHO8oOXnEc0FDv4KgzChZ8r8ehhVRkB3FVNMplYLRsZisG1QX7
         ar81hLOUhfbRkyx033AEJ0mqYzrCPSIziTwGVJ48PvYlP7aHDyxC21EzQHqN4obWs3fg
         /+iw==
X-Gm-Message-State: AGi0PuaIn0ifVZ8RYUpqV/VQyrCof3BrOqyoaeoTtWOjZU8lX+AKBWqX
        0DQkDYf6nKcr0c9Zwp4baJQ=
X-Google-Smtp-Source: APiQypIEgCbKmoawTOjGPyGayK1HQSNxzHMulomQl9iN6tzrvpDM0jq81b+W00gEN1hQiIWw2USD6Q==
X-Received: by 2002:a17:902:9f95:: with SMTP id g21mr9743105plq.66.1588436661517;
        Sat, 02 May 2020 09:24:21 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id cm14sm2434033pjb.31.2020.05.02.09.24.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 02 May 2020 09:24:20 -0700 (PDT)
Subject: Re: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
To:     Julian Wiedmann <jwi@linux.ibm.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <20200422161329.56026-1-edumazet@google.com>
 <20200422161329.56026-2-edumazet@google.com>
 <a8f1fbf8-b25f-d3aa-27fe-11b1f0fdae3f@linux.ibm.com>
 <CANn89iKid-JWYs6esRYo25NqVdLkLvn6uwiB7wLz_PXuREQQKA@mail.gmail.com>
 <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <78e8b060-6386-b6c1-d32f-907da2c930a7@gmail.com>
Date:   Sat, 2 May 2020 09:24:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <08fd7715-62c3-23b9-ecac-4d0caff71d3e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/2/20 9:10 AM, Julian Wiedmann wrote:
> On 02.05.20 17:40, Eric Dumazet wrote:
>> On Sat, May 2, 2020 at 7:56 AM Julian Wiedmann <jwi@linux.ibm.com> wrote:
>>>
>>> On 22.04.20 18:13, Eric Dumazet wrote:
>>>> Back in commit 3b47d30396ba ("net: gro: add a per device gro flush timer")
>>>> we added the ability to arm one high resolution timer, that we used
>>>> to keep not-complete packets in GRO engine a bit longer, hoping that further
>>>> frames might be added to them.
>>>>
>>>> Since then, we added the napi_complete_done() interface, and commit
>>>> 364b6055738b ("net: busy-poll: return busypolling status to drivers")
>>>> allowed drivers to avoid re-arming NIC interrupts if we made a promise
>>>> that their NAPI poll() handler would be called in the near future.
>>>>
>>>> This infrastructure can be leveraged, thanks to a new device parameter,
>>>> which allows to arm the napi hrtimer, instead of re-arming the device
>>>> hard IRQ.
>>>>
>>>> We have noticed that on some servers with 32 RX queues or more, the chit-chat
>>>> between the NIC and the host caused by IRQ delivery and re-arming could hurt
>>>> throughput by ~20% on 100Gbit NIC.
>>>>
>>>> In contrast, hrtimers are using local (percpu) resources and might have lower
>>>> cost.
>>>>
>>>> The new tunable, named napi_defer_hard_irqs, is placed in the same hierarchy
>>>> than gro_flush_timeout (/sys/class/net/ethX/)
>>>>
>>>
>>> Hi Eric,
>>> could you please add some Documentation for this new sysfs tunable? Thanks!
>>> Looks like gro_flush_timeout is missing the same :).
>>
>>
>> Yes. I was planning adding this in
>> Documentation/networking/scaling.rst, once our fires are extinguished.
>>
>>>
>>>
>>>> By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.
>>>>
>>>> This patch does not change the prior behavior of gro_flush_timeout
>>>> if used alone : NIC hard irqs should be rearmed as before.
>>>>
>>>> One concrete usage can be :
>>>>
>>>> echo 20000 >/sys/class/net/eth1/gro_flush_timeout
>>>> echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs
>>>>
>>>> If at least one packet is retired, then we will reset napi counter
>>>> to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
>>>> of the queue.
>>>>
>>>> On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
>>>> avoidance was only possible if napi->poll() was exhausting its budget
>>>> and not call napi_complete_done().
>>>>
>>>
>>> I was confused here for a second, so let me just clarify how this is intended
>>> to look like for pure TX completion IRQs:
>>>
>>> napi->poll() calls napi_complete_done() with an accurate work_done value, but
>>> then still returns 0 because TX completion work doesn't consume NAPI budget.
>>
>>
>> If the napi budget was consumed, the driver does _not_ call
>> napi_complete() or napi_complete_done() anyway.
>>
> 
> I was thinking of "TX completions are cheap and don't consume _any_ NAPI budget, ever"
> as the current consensus, but looking at the mlx4 code that evidently isn't true
> for all drivers.

TX completions are not cheap in many cases.

Doing the unmap stuff can be costly in IOMMU world, and freeing skb
can be also expensive.
Add to this that TCP stack might be called back (via skb->destructor()) to add more packets to the qdisc/device.

So using effectively the budget as a limit might help in some stress situations,
by not re-enabling NIC interrupts, even before napi_defer_hard_irqs addition.

> 
>> If the budget is consumed, then napi_complete_done(napi, X>0) allows
>> napi_complete_done()
>> to return 0 if napi_defer_hard_irqs is not 0
>>
>> This means that the NIC hard irq will stay disabled for at least one more round.
>>
