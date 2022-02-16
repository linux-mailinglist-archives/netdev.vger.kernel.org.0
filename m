Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C16B4B8ED0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:05:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236859AbiBPRFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:05:24 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236900AbiBPRFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:05:23 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0912A5994
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:05:09 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id u16so4359602ljk.2
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfnf9bWIhe2XcAFjwjhHiCq1OsTMzFtSwUJH69iJZ7Y=;
        b=WJNEVQSaYzGTJdpgqeYX1xX30jORLCsyKmwsYnpUbS//J2LqIWaoC6sZ9sqLiLHDhQ
         GhyRGm/KNFOZV/L+8hVmF+uf63FjNJNYRFRb18GGS9CX0aKiBQXnKZQCd/pxuSAnkPr0
         GQosSJ8GyL5YgxQSatgQzDNQhOoCKgN6fkXDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfnf9bWIhe2XcAFjwjhHiCq1OsTMzFtSwUJH69iJZ7Y=;
        b=RUB8+bkufHItnqhu5xu+8waDY8Ae7rYEWoOhHQxFYtlLcmc6B0DLP5Chpe1jCAYSJM
         Wt+OK7FeBQwgoeFTTCQy1mRhwvEqaEJIkWITQshuatylENnYPUwgcQwF+Og4yYHBKQJo
         X0aJN3V4h7bcbdBaCt/e3DFFOO4B4SqaLeNVLyTWnlFFz8/ZX78zaRXMlJw3p0kIpXgY
         x72kYJ5YPis4bz8P4XaAtYVMY/fq6M9gdPAArEYPHgT1qeH+syaQ1lyA1Ij3ZFm++sI+
         O4YWloepGWexqTTATFwBdBtnolR+CHYv/41y4fb6gYJNjCesMrxQlRZsB0y8wUI9nPWP
         ckKQ==
X-Gm-Message-State: AOAM5331YIkSbzBYXkrdz/9X4EH0tcM1TW0ayTUrN5hkb/Mcug+wFgld
        fX4/CZa+Sl9do2gwULUT0kE45mcy1O5kfRY0KfrErq2167UtnQ==
X-Google-Smtp-Source: ABdhPJwZ8/8q8zayc3C56yJ8RYbgNy2eOzlrIA6cH5osuvpPyh4iEFW3NYLWWnkHpQdfFQZEnrG1ek0n6fR1mdbR6Ts=
X-Received: by 2002:a2e:a795:0:b0:244:2a13:925 with SMTP id
 c21-20020a2ea795000000b002442a130925mr2782298ljf.255.1645031108124; Wed, 16
 Feb 2022 09:05:08 -0800 (PST)
MIME-Version: 1.0
References: <1644868949-24506-1-git-send-email-jdamato@fastly.com>
 <1644868949-24506-2-git-send-email-jdamato@fastly.com> <ed575c4e-774a-2118-f6bf-c8725d2739e8@redhat.com>
In-Reply-To: <ed575c4e-774a-2118-f6bf-c8725d2739e8@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Wed, 16 Feb 2022 09:04:56 -0800
Message-ID: <CALALjgzUQUuEVkNXous0kOcHHqiSrTem+n9MjQh6q-8+Azi-sg@mail.gmail.com>
Subject: Re: [net-next v5 1/2] page_pool: Add page_pool stat counters
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 7:41 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 14/02/2022 21.02, Joe Damato wrote:
> > Add per-cpu per-pool statistics counters for the allocation path of a page
> > pool.
> >
> > This code is disabled by default and a kernel config option is provided for
> > users who wish to enable them.
> >
> > The statistics added are:
> >       - fast: successful fast path allocations
> >       - slow: slow path order-0 allocations
> >       - slow_high_order: slow path high order allocations
> >       - empty: ptr ring is empty, so a slow path allocation was forced.
> >       - refill: an allocation which triggered a refill of the cache
> >       - waive: pages obtained from the ptr ring that cannot be added to
> >         the cache due to a NUMA mismatch.
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >   include/net/page_pool.h | 18 ++++++++++++++++++
> >   net/Kconfig             | 13 +++++++++++++
> >   net/core/page_pool.c    | 37 +++++++++++++++++++++++++++++++++----
> >   3 files changed, 64 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > index 97c3c19..d827ab1 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -135,7 +135,25 @@ struct page_pool {
> >       refcount_t user_cnt;
> >
> >       u64 destroy_cnt;
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     struct page_pool_stats __percpu *stats;
> > +#endif
> > +};
>
> You still have to consider cache-line locality, as I have pointed out
> before.

You are right, I forgot to include that in this revision. Sorry about
that and thanks for the review and response.

> This placement is wrong!
>
> Output from pahole:
>
>   /* --- cacheline 23 boundary (1472 bytes) --- */
>   atomic_t                   pages_state_release_cnt; /*  1472     4 */
>   refcount_t                 user_cnt;             /*  1476     4 */
>   u64                        destroy_cnt;          /*  1480     8 */
>
> Your *stats pointer end-up on a cache-line that "remote" CPUs will write
> into (pages_state_release_cnt).
> This is why we see a slowdown to the 'bench_page_pool_cross_cpu' test.

If I give *stats its own cache-line by adding
____cacheline_aligned_in_smp (but leaving the placement at the end of
the page_pool struct), pahole reports:

/* --- cacheline 24 boundary (1536 bytes) --- */
atomic_t                   pages_state_release_cnt; /*  1536     4 */
refcount_t                 user_cnt;             /*  1540     4 */
u64                        destroy_cnt;          /*  1544     8 */

/* XXX 48 bytes hole, try to pack */

/* --- cacheline 25 boundary (1600 bytes) --- */
struct page_pool_stats *   stats;                /*  1600     8 */

Re-running bench_page_pool_cross_cpu loops=20000000 returning_cpus=4
still shows a fairly large variation in cycles (measurement period
time of 34.128419339 sec) from run to run; roughly a delta of 287
cycles in the runs I just performed back to back.

The best measurements after making the cache-line change described
above are faster than compiling the kernel with stats disabled. The
worst measurements, however, are very close to the data I submit in
the cover letter for this revision.

As far as I can tell xdp_mem_id is not written to particularly often -
only when RX rings are configured in the driver - so I also tried
moving *stats above xdp_mem_id so that they share a cache-line and
reduce the size of the hole between xdp_mem_id and pp_alloc_cache.

pahole reports:

/* --- cacheline 3 boundary (192 bytes) --- */
struct page_pool_stats *   stats;                /*   192     8 */
u32                        xdp_mem_id;           /*   200     4 */

Results of bench_page_pool_cross_cpu loops=20000000 returning_cpus=4
are the same as above -- the best measurements are faster than stats
disabled, the worst are very close to what I mentioned in the cover
letter for this v5.

I am happy to submit a v6 with *stats placed in either location; on
its own cache-line at the expense of a larger page_pool struct, or
placed near xdp_mem_id to consume some of the hole between xdp_mem_id
and pp_alloc_cache.

Do you have a preference on giving the stats pointer its own
cache-line vs sharing a line with xdp_mem_id?

In either case: the benchmarks don't seem to show a consistent
significant improvement on my test hardware. Is there another
benchmark or a different set of arguments you think I should use when
running this test?

My apologies if I am missing something obvious here.

Thanks,
Joe
