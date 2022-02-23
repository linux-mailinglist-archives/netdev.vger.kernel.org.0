Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2E84C1965
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 18:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243168AbiBWRF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 12:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243187AbiBWRF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 12:05:56 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582B453704
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:05:19 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id t14so25598615ljh.8
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 09:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mhF9elGPzo6zI2HzHlbUJKkl8zteOF92vy/DZEZfAVw=;
        b=IaIsYPo1TAIqoP/zFrAyx6bWyTTLVWejHOk3DGwvA2Fq4EJiatjiPT218cZouUjW5q
         tiPYNn/MsE1JwRrSsZJz0JLWWAXZb0H+ej4g2tDsXOLXMXpyh0I3/IyExCTO0EoLLcql
         1RCK/9II38wKyyU+iiCrADBw7YkYzCm7ihuuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mhF9elGPzo6zI2HzHlbUJKkl8zteOF92vy/DZEZfAVw=;
        b=4aaKYisGXlLSUa/CyD/L2Tp2sQVxAwqww6rmaUg89KMmrxtW/URdVFVQhNmr9oh1M7
         u80VQzkeEJ8iitajY+pSPKyZzAk64TgeKr0RL4Scx039yKxWkwf4BXBgcy0eHWs6TAns
         IBZvB9vK31Mvdx280Yi8SNtZZT7fekQYgvWfRYrdK3DIp/OLfeQGNhJCr8ymx70V896x
         6EMnQcc0dEO3gO4kCKemACHx1Rd0GgRtPXA6QueXe0orMhlRMlF4sXg57G7PXVnwJxdK
         OVOGtSnGCIwJ4eEpzH1vr8yt5QAxasGsBDFKC8cBsBXGFW2huRohfl2lsVTPEDTZ44tt
         hAMA==
X-Gm-Message-State: AOAM531LSJ4bzG52I08IH75EXnfAVTB9QqOdiQrD7KldgMFWy+qrsn/W
        6ziElpecLGJ7q2s/X/aAAy49+3z16BpKxRME2RPLXrA0mKyV3A==
X-Google-Smtp-Source: ABdhPJyrnIWhn2C8ps1YfWfV3E+k50JN5XGbZvoFXV3Tgsuah4ei5WNxYXS65rCzpVzuQZpCzgXz3uDSslRxbM0kiMw=
X-Received: by 2002:a2e:944d:0:b0:23b:673f:fbb0 with SMTP id
 o13-20020a2e944d000000b0023b673ffbb0mr244184ljh.93.1645635917632; Wed, 23 Feb
 2022 09:05:17 -0800 (PST)
MIME-Version: 1.0
References: <1645574424-60857-1-git-send-email-jdamato@fastly.com>
 <1645574424-60857-2-git-send-email-jdamato@fastly.com> <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
In-Reply-To: <21c87173-667f-55c1-2eab-a1f684c75352@redhat.com>
From:   Joe Damato <jdamato@fastly.com>
Date:   Wed, 23 Feb 2022 09:05:06 -0800
Message-ID: <CALALjgwqLhTe8zFPugbW7XcMqnhRTKevv-zuVY+CWOjSYTLQRQ@mail.gmail.com>
Subject: Re: [net-next v6 1/2] page_pool: Add page_pool stats
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

On Wed, Feb 23, 2022 at 8:06 AM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
>
> On 23/02/2022 01.00, Joe Damato wrote:
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
> > index 97c3c19..bedc82f 100644
> > --- a/include/net/page_pool.h
> > +++ b/include/net/page_pool.h
> > @@ -135,7 +135,25 @@ struct page_pool {
> >       refcount_t user_cnt;
> >
> >       u64 destroy_cnt;
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +     struct page_pool_stats __percpu *stats ____cacheline_aligned_in_smp;
> > +#endif
> > +};
>
> Adding this to the end of the struct and using attribute
> ____cacheline_aligned_in_smp cause the structure have a lot of wasted
> padding in the end.
>
> I recommend using the tool pahole to see the struct layout.

I mentioned placement near xdp_mem_id in the cover letter for this
code and in my reply on the v5 [1] , but I didn't hear back, so I
really had no idea what you preferred.

I'll move it near xdp_mem_id for the v7, and hope that's what you are
saying here.

> > +
> > +#ifdef CONFIG_PAGE_POOL_STATS
> > +struct page_pool_stats {
> > +     struct {
> > +             u64 fast; /* fast path allocations */
> > +             u64 slow; /* slow-path order 0 allocations */
> > +             u64 slow_high_order; /* slow-path high order allocations */
> > +             u64 empty; /* failed refills due to empty ptr ring, forcing
> > +                         * slow path allocation
> > +                         */
> > +             u64 refill; /* allocations via successful refill */
> > +             u64 waive;  /* failed refills due to numa zone mismatch */
> > +     } alloc;
> >   };
> > +#endif
>
> All of these stats are for page_pool allocation "RX" side, which is
> protected by softirq/NAPI.

Yes.

> Thus, I find it unnecessary to do __percpu stats.

Unnecessary, sure, but doesn't seem harmful and it allows us to expand
this to other stats in a future change.

> As Ilias have pointed out-before, the __percpu stats (first) becomes
> relevant once we want stats for the free/"return" path ... which is not
> part of this patchset.

Does that need to be covered in this patchset?

I believe Ilias' response which mentioned the recycle stats indicates
that they can be added in the future [2]. I took this to mean a
separate patchset, assuming that this first change is accepted.

As I understand your comment, then: this change will not be accepted
unless it is expanded to include recycle stats or if the per-cpu
designation is removed.

Are the cache-line placement and per-cpu designations the only
remaining issues with this change?

[1]: https://lore.kernel.org/all/CALALjgzUQUuEVkNXous0kOcHHqiSrTem+n9MjQh6q-8+Azi-sg@mail.gmail.com/
[2]: https://lore.kernel.org/all/YfJhIpBGW6suBwkY@hades/
