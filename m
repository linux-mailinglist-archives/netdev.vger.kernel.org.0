Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33D40F60B7
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 18:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfKIRey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 12:34:54 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42205 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbfKIRey (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 12:34:54 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so7277077pfh.9
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 09:34:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=qEVl6DQFymxQWqaOwZDhMknEuuQQut3G7AhwPE4cmng=;
        b=Isngil6cuCiZmp2wzx2nhrXFrYSRbMrvTP75IoZFiVFk2+5VoSe41Z4cq9VdYCCvCy
         LyzSlEpxPdBjyybMcCgiZvWj4EolBmle9OSMX6R5Xk2kWE4Da2a05SVv6WGPy/D96tvu
         LELSVo97OIOcUFG2GSxpttGeGNzluN+I5laW/KwCTzd40udLwksXw74A/lIEtU0UzQwW
         abYy+LOSP9BGCOVl5xnxLPnDslGB5FF4rt63qqJi8sKnA5CKh/yXE1P3h0hL32UYVnnh
         PDPHIKWyn4DS6zcPJOsK5LEhQheVssXGi6o34xkhyKA6W2Kp2LWQEBVQaj4+Ks8tqZ3D
         evUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=qEVl6DQFymxQWqaOwZDhMknEuuQQut3G7AhwPE4cmng=;
        b=gqKkvko5xMc27HxGZDluPFnYSlRUx0Tx9rrMcHv0odY/aiF8j4MkCf+Zfs4FTN/FmP
         WvrhgiLVgGxZsffbxM4lyymE7mREUxumOst7J1gjHcqaB+LIWYGCihaENrPm8EQHkdj9
         cpcmtUllWH8vuCD5QswFgWOjOHuF6Jz9wOTyp79dLibnd/XQUwmnZBxPVXCw509UjEl1
         AN1xR4QPeKTrwo16Ri7KtX5IhvSattdk/nRXM9vr/i/VHiJJJcl1hSVSCO7I/dzyp/lk
         2PVptRP3gZWCFxpTXpIwMSuGm27n94Hn2r85r8RAi+VP5Fvz4TdiGPrMcLIXrAm93P+B
         4plw==
X-Gm-Message-State: APjAAAXPpSFHR225EhqmpPmB4yHu0hs0c1B6Ft7D8Ir1hnkfttGD62Un
        M69/4YNx6VVsuGjcFvqX2ToR0yiP
X-Google-Smtp-Source: APXvYqw9bnibCMiVvmApprFFvg1iVw8873TaV2zjAIBZZQ1ef1Lsx/rDt+O1E7Y1DoXzpkXyj1iM0w==
X-Received: by 2002:aa7:982c:: with SMTP id q12mr20267521pfl.83.1573320892048;
        Sat, 09 Nov 2019 09:34:52 -0800 (PST)
Received: from [172.26.104.170] ([2620:10d:c090:180::e678])
        by smtp.gmail.com with ESMTPSA id v3sm9252825pfn.129.2019.11.09.09.34.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 09 Nov 2019 09:34:51 -0800 (PST)
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
Date:   Sat, 09 Nov 2019 09:34:50 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <5FDB1D3C-3A80-4F70-A7F0-03D4CD4061EB@gmail.com>
In-Reply-To: <20191109171109.38c90490@carbon>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
 <157323722276.10408.11333995838112864686.stgit@firesoul>
 <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
 <20191109171109.38c90490@carbon>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9 Nov 2019, at 8:11, Jesper Dangaard Brouer wrote:

> On Fri, 08 Nov 2019 11:16:43 -0800
> "Jonathan Lemon" <jonathan.lemon@gmail.com> wrote:
>
>>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>>> index 5bc65587f1c4..226f2eb30418 100644
>>> --- a/net/core/page_pool.c
>>> +++ b/net/core/page_pool.c
>>> @@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool
>>> *pool)
>>>
>>>  	distance = _distance(hold_cnt, release_cnt);
>>>
>>> -	/* Drivers should fix this, but only problematic when DMA is used */
>>> +	/* BUG but warn as kernel should crash later */
>>>  	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>>>  	     distance, hold_cnt, release_cnt);
>
> Because this is kept as a WARN, I set pool->ring.queue = NULL later.

... which is also an API violation, reaching into the ring internals.
I strongly dislike this.


>>>  }
>>> @@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
>>>  	WARN(pool->alloc.count, "API usage violation");
>>>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>>>
>>> -	/* Can happen due to forced shutdown */
>>>  	if (!__page_pool_safe_to_destroy(pool))
>>>  		__warn_in_flight(pool);
>>
>> If it's not safe to destroy, we shouldn't be getting here.
>
> Don't make such assumptions. The API is going to be used by driver
> developer and they are always a little too creative...

If the driver hits this case, the driver has a bug, and it isn't
safe to continue in any fashion.  The developer needs to fix their
driver in that case.  (see stmmac code)


> The page_pool is a separate facility, it is not tied to the
> xdp_rxq_info memory model.  Some drivers use page_pool directly e.g.
> drivers/net/ethernet/stmicro/stmmac.  It can easily trigger this case,
> when some extend that driver.

Yes, and I pointed out that the mem_info should likely be completely
detached from xdp.c since it really has nothing to do with XDP.
The stmmac driver is actually broken at the moment, as it tries to
free the pool immediately without a timeout.

What should be happening is that drivers just call page_pool_destroy(),
which kicks off the shutdown process if this was the last user ref,
and delays destruction if packets are in flight.



>>>  	ptr_ring_cleanup(&pool->ring, NULL);
>>>
>>> +	/* Make sure kernel will crash on use-after-free */
>>> +	pool->ring.queue = NULL;
>>> +	pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] = NULL;
>>> +	pool->alloc.count = PP_ALLOC_CACHE_SIZE;
>>
>> The pool is going to be freed.  This is useless code; if we're
>> really concerned about use-after-free, the correct place for catching
>> this is with the memory-allocator tools, not scattering things like
>> this ad-hoc over the codebase.
>
> No, I need this code here, because we kept the above WARN() and didn't
> change that into a BUG().  It is obviously not a full solution for
> use-after-free detection.  The memory subsystem have kmemleak to catch
> this kind of stuff, but nobody runs this in production.  I need this
> here to catch some obvious runtime cases.

The WARN() indicates something went off the rails already.  I really
don't like half-assed solutions like the above; it may or may not work
properly.  If it doesn't work properly, then what's the point?
-- 
Jonathan

