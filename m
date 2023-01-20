Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF9675145
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:35:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjATJfP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:35:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbjATJfO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:35:14 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9173F9F075
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:34:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674207241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLDCt7HTF1vR5XloMPpvW0nlhP6J69++ZiwCJbCRLlo=;
        b=a+ws0Z479gOh0btZfc0fyG4sAw52bPL9WlEiyJnQHOUblVSA8BukJ06tpz0shady5VQqaK
        meLH+TvQCiaQCkFgSsYiDFs4pQQYbWUz+Bn0EHbqd4yZjjmvCJo5+ExZHKd90m6DgGuXqH
        MhIq8kT9DYLVzpZI9xoUZLYpTjVqMeQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-177-p9-VeKStPTG7ChOkSvJloA-1; Fri, 20 Jan 2023 04:30:31 -0500
X-MC-Unique: p9-VeKStPTG7ChOkSvJloA-1
Received: by mail-ej1-f71.google.com with SMTP id qb2-20020a1709077e8200b00842b790008fso3457792ejc.21
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 01:30:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zLDCt7HTF1vR5XloMPpvW0nlhP6J69++ZiwCJbCRLlo=;
        b=AZ9iemLlQCBGN7czyQ51wNsVjVCOTZjz3xa54m1ouUH3oKOp0aWill3LBawZs1t6M1
         iqVmOA8sMSFXZg2S+3UnPnu4sv5eLtB5n0aau6i2zSUL7DNRwUg1A3HkRdLKpP1ht6/u
         JW6ulztf8217z5SQm66JDjKNvR2+KD6IeerTATSQsbCOGSXHwK2ybmGk2LDrzK1NuQPi
         ifAs7pwYx17efW0rtr5fE4hkhlUBV8Jd17SHAPkaTox2OyhIrMCdPid2ycDAfp/PStLy
         ee3tdQ5RcF7SU3TE/qZ6+eilnNIp6FW+r01nh4yb6Ns7REZL10C08GH255Gabob3xjYD
         FH+Q==
X-Gm-Message-State: AFqh2ko/yPuOjXW1gOYrzU64UPlRrSR4DJkCg1IgA8VTTKEA1QJSt3gR
        NeORNBsLvhNYu00DS+/WLUwdWo/hoYRQUu00DjYrtJQH7irtrbl70LAL5sUNwkiUfpfsj6tyGei
        9RiG8+aasBGV6NNCu
X-Received: by 2002:a17:906:5914:b0:860:ef29:a4e1 with SMTP id h20-20020a170906591400b00860ef29a4e1mr13775918ejq.55.1674207030172;
        Fri, 20 Jan 2023 01:30:30 -0800 (PST)
X-Google-Smtp-Source: AMrXdXujnG7fl70Wr6ymABICQwts9f2loksIsF69Ym7ttj89ALQ/eGhGJ6poLyyq+p1aXmhIjN/TWw==
X-Received: by 2002:a17:906:5914:b0:860:ef29:a4e1 with SMTP id h20-20020a170906591400b00860ef29a4e1mr13775905ejq.55.1674207029925;
        Fri, 20 Jan 2023 01:30:29 -0800 (PST)
Received: from [192.168.41.200] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id m20-20020a056402051400b00467481df198sm1394142edv.48.2023.01.20.01.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Jan 2023 01:30:29 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <cc7f2ca7-8d6e-cfcb-98f8-3e3d7152fced@redhat.com>
Date:   Fri, 20 Jan 2023 10:30:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, pabeni@redhat.com,
        syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
Subject: Re: [PATCH net-next] net: fix kfree_skb_list use of
 skb_mark_not_on_list
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
References: <167415060025.1124471.10712199130760214632.stgit@firesoul>
 <CANn89iJ8Vd2V6jqVdMYLFcs0g_mu+bTJr3mKq__uXBFg1K0yhA@mail.gmail.com>
 <d5c66d86-23e0-b786-5cba-ae9c18a97549@redhat.com>
In-Reply-To: <d5c66d86-23e0-b786-5cba-ae9c18a97549@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/01/2023 10.09, Jesper Dangaard Brouer wrote:
> 
> On 19/01/2023 19.04, Eric Dumazet wrote:
>> On Thu, Jan 19, 2023 at 6:50 PM Jesper Dangaard Brouer
>> <brouer@redhat.com> wrote:
>>>
>>> A bug was introduced by commit eedade12f4cb ("net: kfree_skb_list use
>>> kmem_cache_free_bulk"). It unconditionally unlinked the SKB list via
>>> invoking skb_mark_not_on_list().
>>>
>>> The skb_mark_not_on_list() should only be called if __kfree_skb_reason()
>>> returns true, meaning the SKB is ready to be free'ed, as it calls/check
>>> skb_unref().
>>>
>>> This is needed as kfree_skb_list() is also invoked on skb_shared_info
>>> frag_list. A frag_list can have SKBs with elevated refcnt due to cloning
>>> via skb_clone_fraglist(), which takes a reference on all SKBs in the
>>> list. This implies the invariant that all SKBs in the list must have the
>>> same refcnt, when using kfree_skb_list().
>>
>> Yeah, or more precisely skb_drop_fraglist() calling kfree_skb_list()
>>
>>>
>>> Reported-by: syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
>>> Reported-and-tested-by: 
>>> syzbot+c8a2e66e37eee553c4fd@syzkaller.appspotmail.com
>>> Fixes: eedade12f4cb ("net: kfree_skb_list use kmem_cache_free_bulk")
>>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>>> ---
>>>   net/core/skbuff.c |    6 +++---
>>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index 4e73ab3482b8..1bffbcbe6087 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -999,10 +999,10 @@ kfree_skb_list_reason(struct sk_buff *segs, 
>>> enum skb_drop_reason reason)
>>>          while (segs) {
>>>                  struct sk_buff *next = segs->next;
>>>
>>> -               skb_mark_not_on_list(segs);
>>> -
>>> -               if (__kfree_skb_reason(segs, reason))
>>> +               if (__kfree_skb_reason(segs, reason)) {
>>> +                       skb_mark_not_on_list(segs);
>>
>> Real question is : Why do we need to set/change/dirt skb->next ?
>>
>> I would remove this completely, and save extra cache lines dirtying.
> 
> First of all, we just read this cacheline via reading segs->next.
> This cacheline must as minimum be in Shared (S) state.
> 
> Secondly SLUB will write into this cacheline. Thus, we actually know 
> that this cacheline need to go into Modified (M) or Exclusive (E).
> Thus, writing into it here should be okay.  We could replace it with a 
> prefetchw() to help SLUB get Exclusive (E) cache coherency state.

I looked it up and SLUB no-longer uses the first cacheline of objects to
store it's freelist_ptr.  Since April 2020 (v5.7) in commit 3202fa62fb43
("slub: relocate freelist pointer to middle of object") (Author: Kees
Cook) the freelist is moved to the middle for security concerns.
Thus, my prefetchw idea is wrong (details: there is an internal
prefetch_freepointer that finds the right location).

Also it could make sense to save the potential (S) to (E) cache
coherency state transition, as SLUB actually writes into another 
cacheline that I first though.


>> Before your patch, we were not calling skb_mark_not_on_list(segs),
>> so why bother ?
> 
> To catch potential bugs.

For this purpose we could discuss creating skb_poison_list() as you
hinted in your debugging proposal, this would likely have caused us to
catch this bug faster (via crash on second caller).

Let me know if you prefer that we simply remove skb_mark_not_on_list() ?

>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 
>> 4e73ab3482b87d81371cff266627dab646d3e84c..180df58e85c72eaa16f5cb56b56d181a379b8921
>> 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -999,8 +999,6 @@ kfree_skb_list_reason(struct sk_buff *segs, enum
>> skb_drop_reason reason)
>>          while (segs) {
>>                  struct sk_buff *next = segs->next;
>>
>> -               skb_mark_not_on_list(segs);
>> -
>>                  if (__kfree_skb_reason(segs, reason))
>>                          kfree_skb_add_bulk(segs, &sa, reason);
>>

