Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8640639280B
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 08:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhE0Gys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 02:54:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25087 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229635AbhE0Gyr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 02:54:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622098394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tbeJSxErj2lDV+ffr5QaXbXOERJDDIrzIVBIxT+6PUQ=;
        b=KOF0OJOmc/Y3eSi1E4hGHYXRtqa7xf4n2HLB/Ud01HLzbAGeU4713k5LCQW2dexL2BUQpY
        Vv7/cn+GWb8Qc2Rob3RQzplQLpWUKLDybt0nBwEWetAL+te6A2lSXBiw505ZrroBUd+QKu
        HgMJPKHQqhWhJ6XNR0GsZCtAfiY0JGU=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-599-7WzNsnrSPWaOcvLFvoLB6Q-1; Thu, 27 May 2021 02:53:12 -0400
X-MC-Unique: 7WzNsnrSPWaOcvLFvoLB6Q-1
Received: by mail-pj1-f72.google.com with SMTP id q88-20020a17090a4fe1b029015d5a5f2427so2247368pjh.6
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 23:53:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=tbeJSxErj2lDV+ffr5QaXbXOERJDDIrzIVBIxT+6PUQ=;
        b=OBfGU6uRj20UGpHwQ/J7PCH2ydAivHyxPMdN934s+EgNdp0qXnrV7x2RpRM8INPQxr
         pjClaM6iJT6lTHAGt1O6/Nlwqlw3eeYGDdGTCzR36E5dIhp9x6WTs0EXowsNuAhlIeRe
         4GIwVRwVnZrYowrXHKlgy4fS9+oW9K88SkoYO/Ults/e5Jkhf8kZRlrywKyELyQSF3/2
         Ackyvsb4sanOQTRmz10nZiMEs1SSqk6Fw8Mmt1yNA7EQikDSyV89nIMYaEYoBBqejnrk
         dHwOxGeW6amowPV+pVcncRRwdyqglhJckhB6l6Ik/u2ABXaq15i9FVyaaP1uhFH7s5Yp
         M3Wg==
X-Gm-Message-State: AOAM530TycxEM+n6ZtivlDvucVGf9HdtRMvFw7wyVmVsqWioP7Od1D+H
        lY2Qj3AKet2X9Qvc1InLOLdX6UvDiB8RHziaR4wuXvI9K1739UCWjZIB1JNFbrN2yKwSV5i+slr
        4knnSOkEfMlesJOC7
X-Received: by 2002:a63:935b:: with SMTP id w27mr2403400pgm.264.1622098391339;
        Wed, 26 May 2021 23:53:11 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwbxRpvRjQPr6v5uVQ848wKew2CiohrQQ7CN8mymILSXGnMXBRVDCOnrMW6FbkBE6RAKnPk9A==
X-Received: by 2002:a63:935b:: with SMTP id w27mr2403380pgm.264.1622098391079;
        Wed, 26 May 2021 23:53:11 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b7sm957003pfv.149.2021.05.26.23.53.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 23:53:10 -0700 (PDT)
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
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <51bc1c38-da20-1090-e3ef-1972f28adfee@redhat.com>
Date:   Thu, 27 May 2021 14:53:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <25a6b73d-06ec-fe07-b34c-10fea709e055@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/5/27 下午2:07, Yunsheng Lin 写道:
> On 2021/5/27 12:57, Jason Wang wrote:
>> 在 2021/5/26 下午8:29, Yunsheng Lin 写道:
>>> Currently r->queue[] is cleared after r->consumer_head is moved
>>> forward, which makes the __ptr_ring_empty() checking called in
>>> page_pool_refill_alloc_cache() unreliable if the checking is done
>>> after the r->queue clearing and before the consumer_head moving
>>> forward.
>>>
>>> Move the r->queue[] clearing after consumer_head moving forward
>>> to make __ptr_ring_empty() checking more reliable.
>>
>> If I understand this correctly, this can only happens if you run __ptr_ring_empty() in parallel with ptr_ring_discard_one().
> Yes.
>
>> I think those two needs to be serialized. Or did I miss anything?
> As the below comment in __ptr_ring_discard_one, if the above is true, I
> do not think we need to keep consumer_head valid at all times, right?
>
>
> 	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
> 	 * to work correctly.
> 	 */


I'm not sure I understand. But my point is that you need to synchronize 
the __ptr_ring_discard_one() and __ptr_empty() as explained in the 
comment above __ptr_ring_empty():

/*
  * Test ring empty status without taking any locks.
  *
  * NB: This is only safe to call if ring is never resized.
  *
  * However, if some other CPU consumes ring entries at the same time, 
the value
  * returned is not guaranteed to be correct.
  *
  * In this case - to avoid incorrectly detecting the ring
  * as empty - the CPU consuming the ring entries is responsible
  * for either consuming all ring entries until the ring is empty,
  * or synchronizing with some other CPU and causing it to
  * re-test __ptr_ring_empty and/or consume the ring enteries
  * after the synchronization point.
  *
  * Note: callers invoking this in a loop must use a compiler barrier,
  * for example cpu_relax().
  */

Thanks



>> Thanks
>>
>>
>>> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>>> ---
>>>    include/linux/ptr_ring.h | 26 +++++++++++++++++---------
>>>    1 file changed, 17 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
>>> index 808f9d3..f32f052 100644
>>> --- a/include/linux/ptr_ring.h
>>> +++ b/include/linux/ptr_ring.h
>>> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>>        /* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>>>         * to work correctly.
>>>         */
>>> -    int consumer_head = r->consumer_head;
>>> -    int head = consumer_head++;
>>> +    int consumer_head = r->consumer_head + 1;
>>>          /* Once we have processed enough entries invalidate them in
>>>         * the ring all at once so producer can reuse their space in the ring.
>>> @@ -271,19 +270,28 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>>>         */
>>>        if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>>>                 consumer_head >= r->size)) {
>>> +        int tail = r->consumer_tail;
>>> +        int head = consumer_head;
>>> +
>>> +        if (unlikely(consumer_head >= r->size)) {
>>> +            r->consumer_tail = 0;
>>> +            WRITE_ONCE(r->consumer_head, 0);
>>> +        } else {
>>> +            r->consumer_tail = consumer_head;
>>> +            WRITE_ONCE(r->consumer_head, consumer_head);
>>> +        }
>>> +
>>>            /* Zero out entries in the reverse order: this way we touch the
>>>             * cache line that producer might currently be reading the last;
>>>             * producer won't make progress and touch other cache lines
>>>             * besides the first one until we write out all entries.
>>>             */
>>> -        while (likely(head >= r->consumer_tail))
>>> -            r->queue[head--] = NULL;
>>> -        r->consumer_tail = consumer_head;
>>> -    }
>>> -    if (unlikely(consumer_head >= r->size)) {
>>> -        consumer_head = 0;
>>> -        r->consumer_tail = 0;
>>> +        while (likely(--head >= tail))
>>> +            r->queue[head] = NULL;
>>> +
>>> +        return;
>>>        }
>>> +
>>>        /* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>>>        WRITE_ONCE(r->consumer_head, consumer_head);
>>>    }
>>
>> .
>>

