Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8105F3FE88F
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 06:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhIBEdw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 00:33:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbhIBEdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 00:33:51 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFB88C061575;
        Wed,  1 Sep 2021 21:32:53 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id v1so388611plo.10;
        Wed, 01 Sep 2021 21:32:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qICEXTbMnqniKGGEwRU1mHpu4eQoOz55fI0slfOAWC4=;
        b=O68xAklZDL3yTI8T6JpcVH7GitXwNDuIYawgTeB4DsIR2IXFxXQ2N9Ug3C0HoiTnDv
         JNk6S+l1fx0nh+NgHClbh75KupXfsdHMmTPYrBJmFXfpiywS/TBrTlddMy7+HpmYICEt
         UpIqOlMrQNswjplpFPSIdm1XtQGyulRrvZXXf79C6wCscA/Wdgf4zACnv3Xii/mrpby/
         MZ9yJHjHplnwbUoFHaADB/kvVaLWC9Ye201EQnEOR+9jxYO79YNy+Rvp4do41pASrnMJ
         Mkt4GwU+RU2KVV+aIcCkzpbiHWm0z7Xr1roOdVXn4eie4I7taHEe4Bf92nVOzZo+vLYT
         4lwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qICEXTbMnqniKGGEwRU1mHpu4eQoOz55fI0slfOAWC4=;
        b=qS822NtTyuqiR6oCnq71pQNTj7sc3sF/H/Gjr0MXnHw0ZNS6CJIrtaspwH7BNy6z27
         Mb1gIuA3ZJmEEtjchwEZl5VPUHXV+2WwHtHg0EWVsL1+BzKktMgEif906Snqx8h/ySqL
         70NWwFakh1wzqW30IcuF7sh3f/UKGuJqho7WIfoFOtRklt3NwxGKjnHs/+K835A3dGTw
         MmVfyi5VjQDD4ERJ7I1aeaUWuNp2zNjwWo3EZ4kZOu04MlF7zYbLjBCDFXDcIio0/934
         wseEyITP+AMV4Lfq9Z3qtzzpHzIY+ax8CoOcoh+PXwimnVLoiLBenI1poMl7fxFoTZKY
         yKHA==
X-Gm-Message-State: AOAM5302vHdAByeAKGiSpH1LLNWigaLG7Cttls/5ON846I2OAIftx6y9
        AATBMjaWf4brZlI8qSYYouY=
X-Google-Smtp-Source: ABdhPJygZaKbn28P9Pdqg5kqmKlPYy4cOt9VcIYXbNi8vEZnRWPpUZZTPtUfoxho/8llK3zVj/5Xeg==
X-Received: by 2002:a17:90b:4b4d:: with SMTP id mi13mr1634950pjb.160.1630557172095;
        Wed, 01 Sep 2021 21:32:52 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d81sm588747pfd.17.2021.09.01.21.32.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 21:32:51 -0700 (PDT)
Subject: Re: [PATCH net-next v4] skb_expand_head() adjust skb->truesize
 incorrectly
To:     Vasily Averin <vvs@virtuozzo.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Paasch <christoph.paasch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        kernel@openvz.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Julian Wiedmann <jwi@linux.ibm.com>
References: <b653692b-1550-e17a-6c51-894832c56065@virtuozzo.com>
 <ee5b763a-c39d-80fd-3dd4-bca159b5f5ac@virtuozzo.com>
 <ce783b33-c81f-4760-1f9e-90b7d8c51fd7@gmail.com>
 <b7c2cb05-7307-f04e-530e-89fc466aa83f@virtuozzo.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <ef7ccff8-700b-79c2-9a82-199b9ed3d95b@gmail.com>
Date:   Wed, 1 Sep 2021 21:32:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <b7c2cb05-7307-f04e-530e-89fc466aa83f@virtuozzo.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/21 8:59 PM, Vasily Averin wrote:
> On 9/1/21 10:17 PM, Eric Dumazet wrote:
>>
>>
>> On 9/1/21 1:11 AM, Vasily Averin wrote:
>>> Christoph Paasch reports [1] about incorrect skb->truesize
>>> after skb_expand_head() call in ip6_xmit.
>>> This may happen because of two reasons:
>>> - skb_set_owner_w() for newly cloned skb is called too early,
>>> before pskb_expand_head() where truesize is adjusted for (!skb-sk) case.
>>> - pskb_expand_head() does not adjust truesize in (skb->sk) case.
>>> In this case sk->sk_wmem_alloc should be adjusted too.
>>>
>>> [1] https://lkml.org/lkml/2021/8/20/1082
>>>
>>> Fixes: f1260ff15a71 ("skbuff: introduce skb_expand_head()")
>>> Reported-by: Christoph Paasch <christoph.paasch@gmail.com>
>>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>>> ---
>>> v4: decided to use is_skb_wmem() after pskb_expand_head() call
>>>     fixed 'return (EXPRESSION);' in os_skb_wmem according to Eric Dumazet
>>> v3: removed __pskb_expand_head(),
>>>     added is_skb_wmem() helper for skb with wmem-compatible destructors
>>>     there are 2 ways to use it:
>>>      - before pskb_expand_head(), to create skb clones
>>>      - after successfull pskb_expand_head() to change owner on extended skb.
>>> v2: based on patch version from Eric Dumazet,
>>>     added __pskb_expand_head() function, which can be forced
>>>     to adjust skb->truesize and sk->sk_wmem_alloc.
>>> ---
>>>  include/net/sock.h |  1 +
>>>  net/core/skbuff.c  | 35 ++++++++++++++++++++++++++---------
>>>  net/core/sock.c    |  8 ++++++++
>>>  3 files changed, 35 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/net/sock.h b/include/net/sock.h
>>> index 95b2577..173d58c 100644
>>> --- a/include/net/sock.h
>>> +++ b/include/net/sock.h
>>> @@ -1695,6 +1695,7 @@ struct sk_buff *sock_wmalloc(struct sock *sk, unsigned long size, int force,
>>>  			     gfp_t priority);
>>>  void __sock_wfree(struct sk_buff *skb);
>>>  void sock_wfree(struct sk_buff *skb);
>>> +bool is_skb_wmem(const struct sk_buff *skb);
>>>  struct sk_buff *sock_omalloc(struct sock *sk, unsigned long size,
>>>  			     gfp_t priority);
>>>  void skb_orphan_partial(struct sk_buff *skb);
>>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>>> index f931176..09991cb 100644
>>> --- a/net/core/skbuff.c
>>> +++ b/net/core/skbuff.c
>>> @@ -1804,28 +1804,45 @@ struct sk_buff *skb_realloc_headroom(struct sk_buff *skb, unsigned int headroom)
>>>  struct sk_buff *skb_expand_head(struct sk_buff *skb, unsigned int headroom)
>>>  {
>>>  	int delta = headroom - skb_headroom(skb);
>>> +	int osize = skb_end_offset(skb);
>>> +	struct sk_buff *oskb = NULL;
>>> +	struct sock *sk = skb->sk;
>>>  
>>>  	if (WARN_ONCE(delta <= 0,
>>>  		      "%s is expecting an increase in the headroom", __func__))
>>>  		return skb;
>>>  
>>> -	/* pskb_expand_head() might crash, if skb is shared */
>>> +	delta = SKB_DATA_ALIGN(delta);
>>> +	/* pskb_expand_head() might crash, if skb is shared.
>>> +	 * Also we should clone skb if its destructor does
>>> +	 * not adjust skb->truesize and sk->sk_wmem_alloc
>>> + 	 */
>>>  	if (skb_shared(skb)) {
>>>  		struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
>>>  
>>> -		if (likely(nskb)) {
>>> -			if (skb->sk)
>>> -				skb_set_owner_w(nskb, skb->sk);
>>> -			consume_skb(skb);
>>> -		} else {
>>> +		if (unlikely(!nskb)) {
>>>  			kfree_skb(skb);
>>> +			return NULL;
>>>  		}
>>> +		oskb = skb;
>>>  		skb = nskb;
>>>  	}
>>> -	if (skb &&
>>> -	    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
>>> +	if (pskb_expand_head(skb, delta, 0, GFP_ATOMIC)) {
>>>  		kfree_skb(skb);
>>> -		skb = NULL;
>>> +		kfree_skb(oskb);
>>> +		return NULL;
>>> +	}
>>> +	if (oskb) {
>>> +		if (sk)
>>
>> if (is_skb_wmem(oskb))
>> Again, it is not valid to call skb_set_owner_w(skb, sk) on all kind of sockets.
> 
> I'm disagree.

:/ :/ :/

> 
> In this particular case we have new skb with skb->sk = NULL,
> In this case skb_orphan() called inside skb_set_owner_w(() will do nothing,
> we just properly set destructor to sock_wfree and adjust sk->sk_wmem_alloc,
> 

We can not adjust sk_wmem_alloc if this is already 0

The only way you can guarantee this is :

to look at is_skb_wmem(oskb)

Because then you are certain that _at_ least this skb owns a reference on sk->sk_wmem_alloc

If another kind of destructor is held by oskb, then you can not assume this.

Otherwise we need a new refcount_add_if_not_zero() function, and make skb_set_owner_w()
more expensive for a very corner case.

> It is 100% equivalent of code used with skb_realloc_headroom(),
> and there was no claims on this.
> Cristoph's reproducer do not use shared skb and to not check this path,
> so it cannot be the reason of troubles in his experiments.
> 
> Old destructor (sock_edemux?) can be calleda bit later, for old skb, inside consume_skb().
> It can decrement last refcount and can trigger sk_free(). However in this case
> adjusted sk_wmem_alloc did not allow to free sk.
> 
> So I'm sure it is safe.

It is not safe.

> 
>>> +			skb_set_owner_w(skb, sk);
>>> +		consume_skb(oskb);
>>> +	} else if (sk) {
>>
>> && (skb->destructor != sock_edemux)
>> (Because in this case , pskb_expand_head() already adjusted skb->truesize)
> 
> Agree, thank you, my fault, I've missed it.
> I think it was the reason of the troubles in last Cristoph's experiment.
> 
>>> +		delta = osize - skb_end_offset(skb);
>>
>>> +		if (!is_skb_wmem(skb))
>>> +			skb_set_owner_w(skb, sk);
>>
>> This is dangerous, even if a socket is there, its sk->sk_wmem_alloc could be zero.
>> We can not add skb->truesize to a refcount_t that already reached 0 (sk_free())
>>
>> If is_skb_wmem() is false, you probably should do nothing, and leave
>> current destructor as it is.
> 
> I;m still not sure and think it is tricky too.



> I've found few destructors called sock_wfree inside, they require sk_wmem_alloc adjustement.
> sctp_wfree, unix_destruct_scm and tpacket_destruct_skb
> 
> In the same time another ones do not use sk_wmem_alloc and I do not know how to detect proper ones.
> Potentially there are some 3rd party protocols out-of-tree, and I cannot list all of them here.

I think you missed netem case, in particular
skb_orphan_partial() which I already pointed out.

You can setup a stack of virtual devices (tunnels),
with a qdisc on them, before ip6_xmit() is finally called...

Socket might have been closed already.

To test your patch, you could force a skb_orphan_partial() at the beginning
of skb_expand_head() (extending code coverage)

> 
> However I think I can use the same trick as one described above:
> I can increase sk_wmem_alloc before skb_orphan(), so sk_free() called by old destuctor 
> cannot call __sk_free() and release sk.


You can not change sk_wmem_alloc if this is already 0.

refcount_add() will trigger a warning (panic under KASAN)

> 
> I hope this should work, 
> otherwise we'll need to clone skb for !is_skb_wmem(skb) before pskb_expand_head() call.
> 
> Thank you,
> 	Vasily Averin
> 

