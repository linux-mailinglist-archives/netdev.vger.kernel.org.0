Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDAD9F6B2D
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 20:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbfKJT4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 14:56:05 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34230 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726882AbfKJT4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Nov 2019 14:56:05 -0500
Received: by mail-pl1-f194.google.com with SMTP id h13so1439917plr.1
        for <netdev@vger.kernel.org>; Sun, 10 Nov 2019 11:56:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=ARC3L8nmzrgmAPqLQq/GA4jwfrPrappSq84lJd5VTQo=;
        b=T9UhRQ0ziOTHscwYmst2Mex/JhjPyFIleJR1fD4TKrXMWVmwfYi3Fd1Dn2ghGYZTLQ
         0fHP9+5ZiPMetgyjRsuSQ8ALMIYhA0cNKfapthe4VPwDVe6oyHBtmckTNuRK6g2+pKl6
         twGUk6E06AhOXwzQEdifyLwj4ezKMpkMqXyMllbdyW61nrXdvlir4meIdgL+YXq0WDMn
         zgqf7BYfqf2pLB5XxBIIWck+MA8aGPq9/homTdUnAeSZ1RfPdSRx2OnqK2TCFCUg7wXh
         MAKiht5p8HI5WxSI9BNWzS+IwCeyoVTvmYSEWDoiuc9TYTMNtqPhWg6QyodGQoVgi+Dj
         9SeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=ARC3L8nmzrgmAPqLQq/GA4jwfrPrappSq84lJd5VTQo=;
        b=cScMApkS0bvMdlr2cyRjzdisaP4BcexNJV3Uqdt+K3SisEzpf9AOA2g4vnX1D+JYcr
         INK/Sg84sJjuA039fMOdhKl5GkGk9P//h5oZB4ECyb7JAQC0SvrqP5cExiDJExVCFnc7
         8Q5ws1ik/Eo95kw6bfjnFYRZcjUkc+5mCE/UKnlmLexzVXUDy3m1jgMrGHPpJ0SToPlK
         /0D/WuhmOGPDMiWbknoi6b80CpBvLkyLXrpyqqicJXasyOouGEDNm+LXHTElM/qdTP05
         QD097AibLlT04x1bi8V7uh3nfIvbxxv3xZ+W7QRXWI5sIbFVwFBRLNpDFEaxdv7VtFv8
         Q5yg==
X-Gm-Message-State: APjAAAWsAu/RHhTVP+MeGzYZexbL0zvmBBtwgFHSTrSsGtyXqupo/9p4
        mdNaJZBy/sFW+tWTPS6eQp1IxReu
X-Google-Smtp-Source: APXvYqwrH1JRoST8b/jBjKtxGRWf0JU1oShn1y8zMLu1KzAc9fdGq24fcci73pyhgKfYzsB1MfNc1w==
X-Received: by 2002:a17:902:900b:: with SMTP id a11mr21526082plp.116.1573415763972;
        Sun, 10 Nov 2019 11:56:03 -0800 (PST)
Received: from [172.26.105.13] ([2620:10d:c090:180::4a5f])
        by smtp.gmail.com with ESMTPSA id l24sm11684286pff.151.2019.11.10.11.56.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 10 Nov 2019 11:56:03 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        netdev@vger.kernel.org,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>
Subject: Re: [net-next v1 PATCH 1/2] xdp: revert forced mem allocator removal
 for page_pool
Date:   Sun, 10 Nov 2019 11:56:01 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <6420F599-A160-449E-8F47-516E9A339C77@gmail.com>
In-Reply-To: <20191110085939.23013f83@carbon>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
 <157323722276.10408.11333995838112864686.stgit@firesoul>
 <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
 <20191109171109.38c90490@carbon>
 <5FDB1D3C-3A80-4F70-A7F0-03D4CD4061EB@gmail.com>
 <20191110085939.23013f83@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9 Nov 2019, at 23:59, Jesper Dangaard Brouer wrote:

> On Sat, 09 Nov 2019 09:34:50 -0800
> "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
>
>> On 9 Nov 2019, at 8:11, Jesper Dangaard Brouer wrote:
>>
>>> On Fri, 08 Nov 2019 11:16:43 -0800
>>> "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
>>>
>>>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>>>> index 5bc65587f1c4..226f2eb30418 100644
>>>>> --- a/net/core/page_pool.c
>>>>> +++ b/net/core/page_pool.c
>>>>> @@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool
>>>>> *pool)
>>>>>
>>>>>  	distance = _distance(hold_cnt, release_cnt);
>>>>>
>>>>> -	/* Drivers should fix this, but only problematic when DMA is used */
>>>>> +	/* BUG but warn as kernel should crash later */
>>>>>  	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>>>>>  	     distance, hold_cnt, release_cnt);
>>>
>>> Because this is kept as a WARN, I set pool->ring.queue = NULL later.
>>
>> ... which is also an API violation, reaching into the ring internals.
>> I strongly dislike this.
>
> I understand your dislike of reaching into ptr_ring "internals".
> But my plan was to add this here, and then in a followup patch move this
> pool->ring.queue=NULL into the ptr_ring.
>
>
>>>>>  }
>>>>> @@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
>>>>>  	WARN(pool->alloc.count, "API usage violation");
>>>>>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>>>>>
>>>>> -	/* Can happen due to forced shutdown */
>>>>>  	if (!__page_pool_safe_to_destroy(pool))
>>>>>  		__warn_in_flight(pool);
>>>>
>>>> If it's not safe to destroy, we shouldn't be getting here.
>>>
>>> Don't make such assumptions. The API is going to be used by driver
>>> developer and they are always a little too creative...
>>
>> If the driver hits this case, the driver has a bug, and it isn't
>> safe to continue in any fashion.  The developer needs to fix their
>> driver in that case.  (see stmmac code)
>
> The stmmac driver is NOT broken, they simply use page_pool as their
> driver level page-cache.  That is exactly what page_pool was designed
> for, creating a generic page-cache for drivers to use.  They use this
> to simplify their driver.  They don't use the advanced features, which
> requires hooking into mem model reg.

We both know that Ilias is working on extending the lifetime of the
page mapping so it covers the time the page is held by the skb while
it transits the stack.  This work requires a timeout feature of some
sort so the pool is not destroyed until the total inflight packet count
hits zero.  This is introduced in 2050eae626bd7a6591abbf17e26f706a700b201b

Now, while it could be true that the driver is not utilizing this right
now, nor the "advanced" features, as you call it, as soon as it does, then
there is an issue.

I also think you're arguing both sides here - either the driver is not
broken, which means it's safe to destroy the pool without checking anything,
or "The API is going to be used by driver developer and they are always a
little too creative", which means the driver has a bug and there needs to
be a mechanism to handle this.



>>
>>> The page_pool is a separate facility, it is not tied to the
>>> xdp_rxq_info memory model.  Some drivers use page_pool directly e.g.
>>> drivers/net/ethernet/stmicro/stmmac.  It can easily trigger this case,
>>> when some extend that driver.
>>
>> Yes, and I pointed out that the mem_info should likely be completely
>> detached from xdp.c since it really has nothing to do with XDP.
>> The stmmac driver is actually broken at the moment, as it tries to
>> free the pool immediately without a timeout.
>>
>> What should be happening is that drivers just call page_pool_destroy(),
>> which kicks off the shutdown process if this was the last user ref,
>> and delays destruction if packets are in flight.
>
> Sorry, but I'm getting frustrated with you. I've already explained you
> (offlist), that the memory model reg/unreg system have been created to
> support multiple memory models (even per RX-queue).  We already have
> AF_XDP zero copy, but I actually want to keep the flexibility and add
> more in the future.

Again, I'm not sure what your point is here.  I have no problem with the
xdp memory models.  However, the memory models are a consumer of the pool,
and the pool should be independent of the memory model.  In other words,
it should be possible for me to use the pool and a timeout feature without
having to bother with xdp memory models at all.  Later, if I want to have
the xdp features use the pool, then I can also do that:

Use case 1:
  create pool.
  get page from pool.
  attach page to skb.
  send skb up to stack.
  skb is freed, returned to pool.

(no xdp logic is required here)


Use case 2:
  create pool
  create xdp memory model
  attach mem model to pool
  get page from pool
  send page out via xdp
  return page to xdp model.
  xdp memory model returns page to pool


Use case 3:
  create pool
  get page from pool
  copy data from page into skb
  return page to pool

(no timeout/lifetime is required IF things work correctly)

In cases 1 and 2 a timeout mechanism is required.  In all cases, it
is not safe to free the pool if the inflight counter is not 0.  So
where is the problem?  If the inflight counter is not 0 for cases
1 and 2, we cannot destroy the pool.  For case 3, there shouldn't be
outstanding packets (except for a driver bug) so the delayed
destruction never triggers.  In the case of a driver bug, the pool
destruction is permanently delayed, and there is no crash, and no
use-after-free.


>
>>>>>  	ptr_ring_cleanup(&pool->ring, NULL);
>>>>>
>>>>> +	/* Make sure kernel will crash on use-after-free */
>>>>> +	pool->ring.queue = NULL;
>>>>> +	pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] = NULL;
>>>>> +	pool->alloc.count = PP_ALLOC_CACHE_SIZE;
>>>>
>>>> The pool is going to be freed.  This is useless code; if we're
>>>> really concerned about use-after-free, the correct place for catching
>>>> this is with the memory-allocator tools, not scattering things like
>>>> this ad-hoc over the codebase.
>>>
>>> No, I need this code here, because we kept the above WARN() and didn't
>>> change that into a BUG().  It is obviously not a full solution for
>>> use-after-free detection.  The memory subsystem have kmemleak to catch
>>> this kind of stuff, but nobody runs this in production.  I need this
>>> here to catch some obvious runtime cases.
>>
>> The WARN() indicates something went off the rails already.  I really
>> don't like half-assed solutions like the above; it may or may not work
>> properly.  If it doesn't work properly, then what's the point?
>
> So, you are suggesting to use BUG_ON() instead and crash the kernel
> immediately... you do know Linus hates when we do that, right?

No, I'm suggesting that the delayed pool destruction is mandatory for
all cases, even "non-xdp cases", as explained above, so it handles driver
screwups safely, and avoids the use-after-free case completely.

The pool itself knows it can't be freed (because it maintains the packet
in flight counter), so the pool itself should be responsible for it's
delayed destruction, not external code (xdp).  This then sidesteps the
entire "crash or poison things if there was a use after free".
-- 
Jonathan
