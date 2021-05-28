Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5C2D393B08
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 03:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235783AbhE1Bds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 21:33:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36556 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235378AbhE1Bdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 21:33:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622165533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hHryBPaeZZpK0YeHPFtJrIJALGbQEHemmFpdSzi95PI=;
        b=DxeH4LzQLqzrPAn65yhmMcrCPY+X8RbzmfpwpfAcKTFr2ZxCXydb/gL9K71mTSPMNKohfa
        XwoBP3qB2FoggYYK8cfJUoPYZtR2h5msuTXPOGy9pNMGVk+gQihS21/mEORDJQeu7cHe2A
        uoD03LeocTnQVFw1m/Fvcj+rNbKKNiw=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-73-MCCe1v3QNm6v01uwvFlZvQ-1; Thu, 27 May 2021 21:32:12 -0400
X-MC-Unique: MCCe1v3QNm6v01uwvFlZvQ-1
Received: by mail-pj1-f72.google.com with SMTP id h23-20020a17090aa897b029015cc61ef388so1701297pjq.9
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 18:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=hHryBPaeZZpK0YeHPFtJrIJALGbQEHemmFpdSzi95PI=;
        b=sm5AdxWmdwmrrVai8XlPu3Koktqo4WjXoeU+KzYtfbUW4T8UG9UsyRbZrLyy+9z7LZ
         htvdJlxuAy9CNKQwyIlnneSwQZvEgkokmmPXpbiG2jOvGRUHO736n6vAH30ixsXS9BZu
         8T39rdo4HYJen17QoXd1WAWR7szY6PhcosfzgQvxX5G4WCgLxlCsbHGJyWwbvvV58tDh
         Fd44m70lkbYgw8oNt66Tc9oD9Cin52s1SpaI74cHuRrajDe6jdWxr4JiVyvEu1PgVw4k
         KILFoITa1iZ2/KTaScwSSHNyejkday3IjGVn5dk6Q82AeCfAxI0FQIcmARileJ+jm8ft
         HAXA==
X-Gm-Message-State: AOAM531R3BDWDYqVbC4t4aWC5rJhkGMVD5VWLLFkobpp/MXSBBEMdJJU
        P6FDWctVA20/vXnx3Vg9z89I3DcSBsHX32TjYfcSlpwJZDWiLQEGvvwNlxcw91yZN1GSoFtgElC
        q4G73P/Bo4N29xhvU
X-Received: by 2002:a17:90a:5142:: with SMTP id k2mr1514259pjm.5.1622165530969;
        Thu, 27 May 2021 18:32:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyEdgPN8hopVNiLZnOFVHIneq0VV45UvQRO2ibIQalf8OQlbcLG/i/n2jBqCQ4TN2mILXIyeg==
X-Received: by 2002:a17:90a:5142:: with SMTP id k2mr1514224pjm.5.1622165530566;
        Thu, 27 May 2021 18:32:10 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id gg10sm2870037pjb.49.2021.05.27.18.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 May 2021 18:32:09 -0700 (PDT)
Subject: Re: [PATCH net-next] ptr_ring: make __ptr_ring_empty() checking more
 reliable
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     will@kernel.org, peterz@infradead.org, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        mst@redhat.com, brouer@redhat.com
References: <1622032173-11883-1-git-send-email-linyunsheng@huawei.com>
 <d2287691-1ef9-d2c4-13f6-2baf7b80d905@redhat.com>
 <25a6b73d-06ec-fe07-b34c-10fea709e055@huawei.com>
 <51bc1c38-da20-1090-e3ef-1972f28adfee@redhat.com>
 <938bdb23-4335-845d-129e-db8af2484c27@huawei.com>
 <0b64f53d-e120-f90d-bf59-bb89cceea83e@redhat.com>
 <758d89e8-3be1-25ae-9a42-cc8703ac097b@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b2eb7c0b-f3e8-bc89-1644-0d9b533af749@redhat.com>
Date:   Fri, 28 May 2021 09:31:48 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <758d89e8-3be1-25ae-9a42-cc8703ac097b@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/27 下午5:03, Yunsheng Lin 写道:
> On 2021/5/27 16:05, Jason Wang wrote:
>> 在 2021/5/27 下午3:21, Yunsheng Lin 写道:
>>> On 2021/5/27 14:53, Jason Wang wrote:
>>>> 在 2021/5/27 下午2:07, Yunsheng Lin 写道:
>>>>> On 2021/5/27 12:57, Jason Wang wrote:
>>>>>> 在 2021/5/26 下午8:29, Yunsheng Lin 写道:
>>>>>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>>>>>> forward, which makes the __ptr_ring_empty() checking called in
>>>>>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>>>>>> after the r->queue clearing and before the consumer_head moving
>>>>>>> forward.
>>>>>>>
>>>>>>> Move the r->queue[] clearing after consumer_head moving forward
>>>>>>> to make __ptr_ring_empty() checking more reliable.
>>>>>> If I understand this correctly, this can only happens if you run __ptr_ring_empty() in parallel with ptr_ring_discard_one().
>>>>> Yes.
>>>>>
>>>>>> I think those two needs to be serialized. Or did I miss anything?
>>>>> As the below comment in __ptr_ring_discard_one, if the above is true, I
>>>>> do not think we need to keep consumer_head valid at all times, right?
>>>>>
>>>>>
>>>>>       /* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>>>>        * to work correctly.
>>>>>        */
>>>> I'm not sure I understand. But my point is that you need to synchronize the __ptr_ring_discard_one() and __ptr_empty() as explained in the comment above __ptr_ring_empty():
>>> I am saying if __ptr_ring_empty() and __ptr_ring_discard_one() is
>>> always serialized, then it seems that the below commit is unnecessary?
>>
>> Just to make sure we are at the same page. What I really meant is "synchronized" not "serialized". So they can be called at the same time but need synchronization.
>>
>>
>>> 406de7555424 ("ptr_ring: keep consumer_head valid at all times")
>>
>> This still needed in this case.
>>
>>
>>>> /*
>>>>    * Test ring empty status without taking any locks.
>>>>    *
>>>>    * NB: This is only safe to call if ring is never resized.
>>>>    *
>>>>    * However, if some other CPU consumes ring entries at the same time, the value
>>>>    * returned is not guaranteed to be correct.
>>>>    *
>>>>    * In this case - to avoid incorrectly detecting the ring
>>>>    * as empty - the CPU consuming the ring entries is responsible
>>>>    * for either consuming all ring entries until the ring is empty,
>>>>    * or synchronizing with some other CPU and causing it to
>>>>    * re-test __ptr_ring_empty and/or consume the ring enteries
>>>>    * after the synchronization point.
>>> I am not sure I understand "incorrectly detecting the ring as empty"
>>> means, is it because of the data race described in the commit log?
>>
>> It means "the ring might be empty but __ptr_ring_empty() returns false".
> But the ring might be non-empty but __ptr_ring_empty() returns true
> for the data race described in the commit log:)


Which commit log?


>
>>
>>> Or other data race? I can not think of other data race if consuming
>>> and __ptr_ring_empty() is serialized:)
>>>
>>> I am agreed that __ptr_ring_empty() checking is not totally reliable
>>> without taking r->consumer_lock, that is why I use "more reliable"
>>> in the title:)
>>
>> Is __ptr_ring_empty() synchronized with the consumer in your case? If yes, have you done some benchmark to see the difference?
>>
>> Have a look at page pool, this only helps when multiple refill request happens in parallel which can make some of the refill return early if the ring has been consumed.
>>
>> This is the slow-path and I'm not sure we see any difference. If one the request runs faster then the following request will go through the fast path.
> Yes, I am agreed there may not be any difference.
> But it is better to make it more reliable, right?


No, any performance optimization must be benchmark to show obvious 
difference to be accepted.

ptr_ring has been used by various subsystems so we should not risk our 
self-eves to accept theoretical optimizations.


>
>> If it really helps, can we do it more simpler by:
>>
>>
>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>> index 808f9d3ee546..c3a72dc77337 100644
>> --- a/include/linux/ptr_ring.h
>> +++ b/include/linux/ptr_ring.h
>> @@ -264,6 +264,10 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>          int consumer_head = r->consumer_head;
>>          int head = consumer_head++;
>>
>> +        /* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>> +       WRITE_ONCE(r->consumer_head,
>> +                   consumer_head < r->size ? consumer_head : 0);
>> +
>>          /* Once we have processed enough entries invalidate them in
>>           * the ring all at once so producer can reuse their space in the ring.
>>           * We also do this when we reach end of the ring - not mandatory
>> @@ -281,11 +285,8 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>                  r->consumer_tail = consumer_head;
>>          }
>>          if (unlikely(consumer_head >= r->size)) {
> What I am thinking is that we can remove the above testing for
> the likely case when the above checking is moved into the body
> of "if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
> consumer_head >= r->size))".
>
> Or is there any specific reason why we keep the testing for likely
> case?


No reason but any optimization must be tested to show differences before 
being accepted.

Thanks


>
>
>> -               consumer_head = 0;
>>                  r->consumer_tail = 0;
>>          }
>> -       /* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>> -       WRITE_ONCE(r->consumer_head, consumer_head);
>>   }
>>
>>   static inline void *__ptr_ring_consume(struct ptr_ring *r)
>>
>>
>> Thanks
>>
>>
>>>
>>>
>>>>    *
>>>>    * Note: callers invoking this in a loop must use a compiler barrier,
>>>>    * for example cpu_relax().
>>>>    */
>>>>
>>>> Thanks
>>>>
>>>>
>>>>
>>
>> .
>>

