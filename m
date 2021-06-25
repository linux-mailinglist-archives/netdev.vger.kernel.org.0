Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9A63B3CB7
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 08:32:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbhFYGev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 02:34:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:33178 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233184AbhFYGeu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 02:34:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624602749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dADiFgcXa4r/30YVc717dGwDJQ0AW/eVDuxFNmSHG1A=;
        b=NR4Hk80tZZ5Javhg9fBZSAtbjg0Tuo/4ReVxTjnaluLgHRI3+fpdoqWTpQjNmAFlmFu4zC
        yae6PcwMPSPcLa7GoRLcReh5HH++nd0NrNslVQJOvs/pq6oii9SylAIVwKgHbLyh9AB33S
        SCKXtD1hAS5Ktvmy2oaYlc14BNbHgSI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-4-eevmURoqM2akM5_tgybNVA-1; Fri, 25 Jun 2021 02:32:28 -0400
X-MC-Unique: eevmURoqM2akM5_tgybNVA-1
Received: by mail-wr1-f70.google.com with SMTP id a4-20020a0560001884b0290124b6e4a437so1253936wri.16
        for <netdev@vger.kernel.org>; Thu, 24 Jun 2021 23:32:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dADiFgcXa4r/30YVc717dGwDJQ0AW/eVDuxFNmSHG1A=;
        b=UYqX0oODOeNrXWeIeMrpzmI1/SsgmvxGXOtJrVC8esTdoeOzP7e7h3ZuAvNR9QJuFX
         IqJeZsU2e/eAdYNhXHpmLqvg1W5h/I0yoPyDAUqGBiQxlNyAeeaXaDCy7e2KX2MDeOiG
         EmG7AodAglcwhiQFR6dl0DaRQ3iytUe/AsBrSkeS3HmkuIy1nxXgJseEvP52k5O+HsiK
         FT8RkBC3PT1+hdQqHblxq+zCv30ijGTTMJ/JbLbpIEp2z2Us1+oimw6isWc60CmRhg5H
         0gE6BSgYFBxIg7O6UYcF29FyslC7tcDdpGbP5pxAa8Iz4P0WH663w7rOuWRTPOYIwNw/
         xZxw==
X-Gm-Message-State: AOAM533baGwBtqa2iXVxM0tmIZSwkDlaDiojehGnrs5urWGYRSP3Ajm3
        7lQ/LkmsXe2LfJA+W0GhyTrWoYXqAjxF5NNN8gv18Mu9AU6GHlm0bF0o1H8brqa6IouOudMbjU8
        Am8BOZmI1ID78V0Zq
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr8745041wmq.27.1624602746802;
        Thu, 24 Jun 2021 23:32:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzblmcYdLQ+0WpUsYPYtWzDLkJrZbxNg+n/ZbamaCoqfpz8Q7AbqWYWLo4IhalIfmQpSr+JXw==
X-Received: by 2002:a05:600c:198f:: with SMTP id t15mr8745031wmq.27.1624602746619;
        Thu, 24 Jun 2021 23:32:26 -0700 (PDT)
Received: from redhat.com ([77.124.79.210])
        by smtp.gmail.com with ESMTPSA id o203sm5427481wmo.36.2021.06.24.23.32.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 23:32:25 -0700 (PDT)
Date:   Fri, 25 Jun 2021 02:32:22 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty()
 checking more reliable
Message-ID: <20210625022128-mutt-send-email-mst@kernel.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
> Currently r->queue[] is cleared after r->consumer_head is moved
> forward, which makes the __ptr_ring_empty() checking called in
> page_pool_refill_alloc_cache() unreliable if the checking is done
> after the r->queue clearing and before the consumer_head moving
> forward.


Well the documentation for __ptr_ring_empty clearly states is
is not guaranteed to be reliable.

 *
 * NB: This is only safe to call if ring is never resized.
 *
 * However, if some other CPU consumes ring entries at the same time, the value
 * returned is not guaranteed to be correct.
 *
 * In this case - to avoid incorrectly detecting the ring
 * as empty - the CPU consuming the ring entries is responsible
 * for either consuming all ring entries until the ring is empty,
 * or synchronizing with some other CPU and causing it to
 * re-test __ptr_ring_empty and/or consume the ring enteries
 * after the synchronization point.
 *

Is it then the case that page_pool_refill_alloc_cache violates
this requirement? How?

It looks like you are trying to make the guarantee stronger and ensure
no false positives.

If yes please document this as such, update the comment so all
code can be evaluated with the eye towards whether the new stronger
guarantee is maintained. In particular I think I see at least one
issue with this immediately.


> Move the r->queue[] clearing after consumer_head moving forward
> to make __ptr_ring_empty() checking more reliable.
> 
> As a side effect of above change, a consumer_head checking is
> avoided for the likely case, and it has noticeable performance
> improvement when it is tested using the ptr_ring_test selftest
> added in the previous patch.
> 
> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
> to test the case of single thread doing both the enqueuing and
> dequeuing:
> 
>  arch     unpatched           patched       delta
> arm64      4648 ms            4464 ms       +3.9%
>  X86       2562 ms            2401 ms       +6.2%
> 
> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
> to test the case of one thread doing enqueuing and another thread
> doing dequeuing concurrently, also known as single-producer/single-
> consumer:
> 
>  arch      unpatched             patched         delta
> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V2: Add performance data.
> ---
>  include/linux/ptr_ring.h | 25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> index 808f9d3..db9c282 100644
> --- a/include/linux/ptr_ring.h
> +++ b/include/linux/ptr_ring.h
> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>  	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
>  	 * to work correctly.
>  	 */
> -	int consumer_head = r->consumer_head;
> -	int head = consumer_head++;
> +	int consumer_head = r->consumer_head + 1;
>  
>  	/* Once we have processed enough entries invalidate them in
>  	 * the ring all at once so producer can reuse their space in the ring.
> @@ -271,19 +270,27 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
>  	 */
>  	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
>  		     consumer_head >= r->size)) {
> +		int tail = r->consumer_tail;
> +
> +		if (unlikely(consumer_head >= r->size)) {
> +			r->consumer_tail = 0;
> +			WRITE_ONCE(r->consumer_head, 0);
> +		} else {
> +			r->consumer_tail = consumer_head;
> +			WRITE_ONCE(r->consumer_head, consumer_head);
> +		}
> +
>  		/* Zero out entries in the reverse order: this way we touch the
>  		 * cache line that producer might currently be reading the last;
>  		 * producer won't make progress and touch other cache lines
>  		 * besides the first one until we write out all entries.
>  		 */
> -		while (likely(head >= r->consumer_tail))
> -			r->queue[head--] = NULL;
> -		r->consumer_tail = consumer_head;
> -	}
> -	if (unlikely(consumer_head >= r->size)) {
> -		consumer_head = 0;
> -		r->consumer_tail = 0;
> +		while (likely(--consumer_head >= tail))
> +			r->queue[consumer_head] = NULL;
> +
> +		return;


So if now we need this to be reliable then
we also need smp_wmb before writing r->queue[consumer_head],
there could be other gotchas.

>  	}
> +
>  	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
>  	WRITE_ONCE(r->consumer_head, consumer_head);
>  }
> -- 
> 2.7.4

