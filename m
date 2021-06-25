Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBAD3B3D65
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFYHdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:33:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42642 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229850AbhFYHdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:33:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624606239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xKK7eRDQG8UvZ5Oc1h4Ez07d1ItOKlaqb/2D9MQmVZg=;
        b=B2mav+43OnW6Ls92qdULP44ZIb4eH2lvBgoMy/fJ3Fgpm5s61vdJxZK2cVFLqwS2s3pBDF
        gkbCrNNWOXK6oobO7jDBsQhWfzfxfPhOErITaRCm62TsCQMic+OJU6uI8s9MVTu/SV3PRy
        lqtLfpOrWJBzAEKz3s4Xu8DgfkORGUk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-McnIpgv-PZaMxII6aYi94Q-1; Fri, 25 Jun 2021 03:30:37 -0400
X-MC-Unique: McnIpgv-PZaMxII6aYi94Q-1
Received: by mail-wm1-f70.google.com with SMTP id s80-20020a1ca9530000b02901cff732fde5so2368400wme.6
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 00:30:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKK7eRDQG8UvZ5Oc1h4Ez07d1ItOKlaqb/2D9MQmVZg=;
        b=CrZz5q6fJ7bEShefsrE78TnP5Cl2PVsY5y4VPYeM6bixYoh7RenvQpzJynoJVIbvwF
         ejnlk3wN/Wtawra4R1tdjFpACKsuAETX64BrUEozLOFVe+eNlcH9h5AYFxKV4uNc6D2i
         2RtlbuJ6k/zzodTWbrZD+W+q2vWz+JAHRA0QZYEtaPmo+YI2lXQ1nNRuv/OmZCVih+SZ
         sNGSQKL/yFQ2qUAE8bcKu/g74lWuucCGyjxVIMZBk11my87djEBK0sCqfR80221oW6B2
         QgJHAnSlIZ5QLXV3ozjna5YAsTggLlvd6L5rN7CYTRZELVAZOXwrE9K4KfNyOeYrctJA
         a/vw==
X-Gm-Message-State: AOAM5332kL7l/c2q3imu5ZMDrP0a5JPrZal1XFdy3+us+rzxXeTnAdY2
        FuBEj5D5UVXwczeclgyocrHPoyajMVwcFbxIyCbGP5Kircq00c7h5yks2SH0p/KmBesAXwPTWqi
        COP3MHKNiJoSw3lSJ
X-Received: by 2002:a5d:488a:: with SMTP id g10mr9127105wrq.180.1624606236839;
        Fri, 25 Jun 2021 00:30:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxChax3iiltDo2FH1RlQu7D+c01evM49Qx+uLUiAexGJ9cd0DZ2+IV6/hqze/k243BsL1jmEA==
X-Received: by 2002:a5d:488a:: with SMTP id g10mr9127084wrq.180.1624606236654;
        Fri, 25 Jun 2021 00:30:36 -0700 (PDT)
Received: from redhat.com ([77.124.79.210])
        by smtp.gmail.com with ESMTPSA id d15sm5375468wrb.42.2021.06.25.00.30.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 00:30:35 -0700 (PDT)
Date:   Fri, 25 Jun 2021 03:30:32 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jasowang@redhat.com,
        brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
Subject: Re: [PATCH net-next v2 2/2] ptr_ring: make __ptr_ring_empty()
 checking more reliable
Message-ID: <20210625032508-mutt-send-email-mst@kernel.org>
References: <1624591136-6647-1-git-send-email-linyunsheng@huawei.com>
 <1624591136-6647-3-git-send-email-linyunsheng@huawei.com>
 <20210625022128-mutt-send-email-mst@kernel.org>
 <c6975b2d-2b4a-5b3f-418c-1a59607b9864@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6975b2d-2b4a-5b3f-418c-1a59607b9864@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 25, 2021 at 03:21:33PM +0800, Yunsheng Lin wrote:
> On 2021/6/25 14:32, Michael S. Tsirkin wrote:
> > On Fri, Jun 25, 2021 at 11:18:56AM +0800, Yunsheng Lin wrote:
> >> Currently r->queue[] is cleared after r->consumer_head is moved
> >> forward, which makes the __ptr_ring_empty() checking called in
> >> page_pool_refill_alloc_cache() unreliable if the checking is done
> >> after the r->queue clearing and before the consumer_head moving
> >> forward.
> > 
> > 
> > Well the documentation for __ptr_ring_empty clearly states is
> > is not guaranteed to be reliable.
> 
> Yes, this patch does not make __ptr_ring_empty() strictly reliable
> without taking the r->consumer_lock, as the disscuission in [1].
> 
> 1. https://patchwork.kernel.org/project/netdevbpf/patch/1622032173-11883-1-git-send-email-linyunsheng@huawei.com/#24207011
> 
> > 
> >  *
> >  * NB: This is only safe to call if ring is never resized.
> >  *
> >  * However, if some other CPU consumes ring entries at the same time, the value
> >  * returned is not guaranteed to be correct.
> >  *
> >  * In this case - to avoid incorrectly detecting the ring
> >  * as empty - the CPU consuming the ring entries is responsible
> >  * for either consuming all ring entries until the ring is empty,
> >  * or synchronizing with some other CPU and causing it to
> >  * re-test __ptr_ring_empty and/or consume the ring enteries
> >  * after the synchronization point.
> >  *
> > 
> > Is it then the case that page_pool_refill_alloc_cache violates
> > this requirement? How?
> 
> As my understanding:
> page_pool_refill_alloc_cache() uses __ptr_ring_empty() to avoid
> taking r->consumer_lock, when the above data race happens, it will
> exit out and allocate page from the page allocator instead of reusing
> the page in ptr_ring, which *may* not be happening if __ptr_ring_empty()
> is more reliable.

Question is how do we know it's more reliable?
It would be nice if we did actually made it more reliable,
as it is we are just shifting races around.


> > 
> > It looks like you are trying to make the guarantee stronger and ensure
> > no false positives.
> > 
> > If yes please document this as such, update the comment so all
> > code can be evaluated with the eye towards whether the new stronger
> > guarantee is maintained. In particular I think I see at least one
> > issue with this immediately.
> > 
> > 
> >> Move the r->queue[] clearing after consumer_head moving forward
> >> to make __ptr_ring_empty() checking more reliable.
> >>
> >> As a side effect of above change, a consumer_head checking is
> >> avoided for the likely case, and it has noticeable performance
> >> improvement when it is tested using the ptr_ring_test selftest
> >> added in the previous patch.
> >>
> >> Using "taskset -c 1 ./ptr_ring_test -s 1000 -m 0 -N 100000000"
> >> to test the case of single thread doing both the enqueuing and
> >> dequeuing:
> >>
> >>  arch     unpatched           patched       delta
> >> arm64      4648 ms            4464 ms       +3.9%
> >>  X86       2562 ms            2401 ms       +6.2%
> >>
> >> Using "taskset -c 1-2 ./ptr_ring_test -s 1000 -m 1 -N 100000000"
> >> to test the case of one thread doing enqueuing and another thread
> >> doing dequeuing concurrently, also known as single-producer/single-
> >> consumer:
> >>
> >>  arch      unpatched             patched         delta
> >> arm64   3624 ms + 3624 ms   3462 ms + 3462 ms    +4.4%
> >>  x86    2758 ms + 2758 ms   2547 ms + 2547 ms    +7.6%
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >> V2: Add performance data.
> >> ---
> >>  include/linux/ptr_ring.h | 25 ++++++++++++++++---------
> >>  1 file changed, 16 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/include/linux/ptr_ring.h b/include/linux/ptr_ring.h
> >> index 808f9d3..db9c282 100644
> >> --- a/include/linux/ptr_ring.h
> >> +++ b/include/linux/ptr_ring.h
> >> @@ -261,8 +261,7 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
> >>  	/* Note: we must keep consumer_head valid at all times for __ptr_ring_empty
> >>  	 * to work correctly.
> >>  	 */
> >> -	int consumer_head = r->consumer_head;
> >> -	int head = consumer_head++;
> >> +	int consumer_head = r->consumer_head + 1;
> >>  
> >>  	/* Once we have processed enough entries invalidate them in
> >>  	 * the ring all at once so producer can reuse their space in the ring.
> >> @@ -271,19 +270,27 @@ static inline void __ptr_ring_discard_one(struct ptr_ring *r)
> >>  	 */
> >>  	if (unlikely(consumer_head - r->consumer_tail >= r->batch ||
> >>  		     consumer_head >= r->size)) {
> >> +		int tail = r->consumer_tail;
> >> +
> >> +		if (unlikely(consumer_head >= r->size)) {
> >> +			r->consumer_tail = 0;
> >> +			WRITE_ONCE(r->consumer_head, 0);
> >> +		} else {
> >> +			r->consumer_tail = consumer_head;
> >> +			WRITE_ONCE(r->consumer_head, consumer_head);
> >> +		}
> >> +
> >>  		/* Zero out entries in the reverse order: this way we touch the
> >>  		 * cache line that producer might currently be reading the last;
> >>  		 * producer won't make progress and touch other cache lines
> >>  		 * besides the first one until we write out all entries.
> >>  		 */
> >> -		while (likely(head >= r->consumer_tail))
> >> -			r->queue[head--] = NULL;
> >> -		r->consumer_tail = consumer_head;
> >> -	}
> >> -	if (unlikely(consumer_head >= r->size)) {
> >> -		consumer_head = 0;
> >> -		r->consumer_tail = 0;
> >> +		while (likely(--consumer_head >= tail))
> >> +			r->queue[consumer_head] = NULL;
> >> +
> >> +		return;
> > 
> > 
> > So if now we need this to be reliable then
> > we also need smp_wmb before writing r->queue[consumer_head],
> > there could be other gotchas.
> 
> Yes, This patch does not make it strictly reliable.
> T think I could mention that in the commit log?

OK so it's not that it makes it more reliable - this patch simply makes
a possible false positive less likely while making  a false negative
more likely. Our assumption is that a false negative is cheaper then?

How do we know that it is?

And even if we prove the ptr_ring itself is faster now,
how do we know what affects callers in a better way a
false positive or a false negative?

I would rather we worked on actually making it reliable
e.g. if we can guarantee no false positives, that would be
a net win.

> 
> > 
> >>  	}
> >> +
> >>  	/* matching READ_ONCE in __ptr_ring_empty for lockless tests */
> >>  	WRITE_ONCE(r->consumer_head, consumer_head);
> >>  }
> >> -- 
> >> 2.7.4
> > 
> > 
> > .
> > 

