Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B431CB774
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 20:39:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgEHSjA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 14:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726756AbgEHSi7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 14:38:59 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D79C061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 11:38:58 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e25so2717742ljg.5
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 11:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a6+xBbRgF5KM884gMTB9yzWmorjjz4zA2+XFqsMIIu0=;
        b=clFWuTLGcCDkSy1U4yIYdXzjoZiB5t9xTCfJvaknJtvn2HAGlD2tA6vOQl6ciaiMDx
         D+o+uBjfh3UdyeQaWxbWMM7Jpj9Le6xHBBJTJ8lzSwemEAnF5czqsLlFRtAoWd5kCIf4
         sFGr+K0+m6QkeeFq35cO01LTnVcyGy5tnaD+kQOhlJqv9qfnce3x8xqqBRPJ7VHadAX1
         DVro2+9dWM35INbGy0v0kczcyYt7EPvMM/V5BUUYPRHGA1rKLbGlEFRxzTVbLY6+YFJG
         lFyefey2jmZrEC5HP9rBhf0ByRHphX8Fbc+KSBNWGaZBKuDv75L/P4YnSIgopkJd7XkC
         x8ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a6+xBbRgF5KM884gMTB9yzWmorjjz4zA2+XFqsMIIu0=;
        b=e7ttfap9u6kk5pKL5oOpRfG+3N9jsUIyL4vjKKh6X6zdv00MuZUS22/VaKdEM5mGuF
         Q8AZzLKKksT/NHFeLJHPfuwfUTeBj9MMHg7zuP/SD3Y0MniGmAGtdawWq3ql4fkpe1op
         3LDt9VpajE9wYLi5Nb6oS1VI+3l5wObB4yD1HwVZ979tSRklBPNMUdkw5GSszTAUxiHp
         arJh3ATMc1Vj3/er5oyakYBXvEM+zFVTicq9IYy6GdJPGALUCgAPpFhCX8503TRwfe8V
         phYEdUiKwxDXP0SFjQL8XpBU4bha4LUgwNmBy4UirAYk/aooglli5Y7Eg83btry8ik7h
         jx4A==
X-Gm-Message-State: AOAM532V3CeHmaoYgk9vTFrlsgO6KF3EDjzn1IDl+Jp5m5vhns3fBO9O
        V3Xp8fUiXEhtgWzkPrA4/ORHDVLSTcq06cSJ6LY=
X-Google-Smtp-Source: ABdhPJx/+RBlZRvOJeICbS/zRB9tdN6Rbe7r1IbrZNE32rfeOwDCK3/R3U18hN52IOYLIOxwiU7TIV7yZ0BIu6JO4Y0=
X-Received: by 2002:a2e:9490:: with SMTP id c16mr2634745ljh.110.1588963136591;
 Fri, 08 May 2020 11:38:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200508015810.46023-1-edumazet@google.com> <CABCgpaUqymfoGGyExvKv65UDvLfHnw2cavVCr1Pq8coz21ujKA@mail.gmail.com>
 <CANn89iKk8aZ=wwbet8q_U=inbksvWhJvUewMGP+FfLYiD+yOCQ@mail.gmail.com> <CANn89i+Ltt+oidFvLawa_TKiqvwtr2uPBKCMD7xZ4-UaxgXTgQ@mail.gmail.com>
In-Reply-To: <CANn89i+Ltt+oidFvLawa_TKiqvwtr2uPBKCMD7xZ4-UaxgXTgQ@mail.gmail.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Fri, 8 May 2020 11:38:44 -0700
Message-ID: <CABCgpaU_ek2d6cyAXsSAGZ98u+-_izCv2zUGVu+FD-C4OdDVww@mail.gmail.com>
Subject: Re: [PATCH net-next] net/dst: use a smaller percpu_counter batch for
 dst entries accounting
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 11:17 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, May 8, 2020 at 11:06 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, May 8, 2020 at 10:30 AM Brian Vazquez <brianvv.kernel@gmail.com> wrote:
> > >
> > > On Thu, May 7, 2020 at 7:00 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > percpu_counter_add() uses a default batch size which is quite big
> > > > on platforms with 256 cpus. (2*256 -> 512)
> > > >
> > > > This means dst_entries_get_fast() can be off by +/- 2*(nr_cpus^2)
> > > > (131072 on servers with 256 cpus)
> > > >
> > > > Reduce the batch size to something more reasonable, and
> > > > add logic to ip6_dst_gc() to call dst_entries_get_slow()
> > > > before calling the _very_ expensive fib6_run_gc() function.
> > > >
> > > > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > > > ---
> > > >  include/net/dst_ops.h | 4 +++-
> > > >  net/core/dst.c        | 8 ++++----
> > > >  net/ipv6/route.c      | 3 +++
> > > >  3 files changed, 10 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/include/net/dst_ops.h b/include/net/dst_ops.h
> > > > index 443863c7b8da362476c15fd290ac2a32a8aa86e3..88ff7bb2bb9bd950cc54fd5e0ae4573d4c66873d 100644
> > > > --- a/include/net/dst_ops.h
> > > > +++ b/include/net/dst_ops.h
> > > > @@ -53,9 +53,11 @@ static inline int dst_entries_get_slow(struct dst_ops *dst)
> > > >         return percpu_counter_sum_positive(&dst->pcpuc_entries);
> > > >  }
> > > >
> > > > +#define DST_PERCPU_COUNTER_BATCH 32
> > > >  static inline void dst_entries_add(struct dst_ops *dst, int val)
> > > >  {
> > > > -       percpu_counter_add(&dst->pcpuc_entries, val);
> > > > +       percpu_counter_add_batch(&dst->pcpuc_entries, val,
> > > > +                                DST_PERCPU_COUNTER_BATCH);
> > > >  }
> > > >
> > > >  static inline int dst_entries_init(struct dst_ops *dst)
> > > > diff --git a/net/core/dst.c b/net/core/dst.c
> > > > index 193af526e908afa4b868cf128470f0fbc3850698..d6b6ced0d451a39c0ccb88ae39dba225ea9f5705 100644
> > > > --- a/net/core/dst.c
> > > > +++ b/net/core/dst.c
> > > > @@ -81,11 +81,11 @@ void *dst_alloc(struct dst_ops *ops, struct net_device *dev,
> > > >  {
> > > >         struct dst_entry *dst;
> > > >
> > > > -       if (ops->gc && dst_entries_get_fast(ops) > ops->gc_thresh) {
> > > > +       if (ops->gc &&
> > > > +           !(flags & DST_NOCOUNT) &&
> > > > +           dst_entries_get_fast(ops) > ops->gc_thresh) {
> > > >                 if (ops->gc(ops)) {
> > > > -                       printk_ratelimited(KERN_NOTICE "Route cache is full: "
> > > > -                                          "consider increasing sysctl "
> > > > -                                          "net.ipv[4|6].route.max_size.\n");
> > > > +                       pr_notice_ratelimited("Route cache is full: consider increasing sysctl net.ipv6.route.max_size.\n");
> > > >                         return NULL;
> > > >                 }
> > > >         }
> > > > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > > > index 1ff142393c768f85c495474a1d05e1ae1642301c..a9072dba00f4fb0b61bce1fc0f44a3a81ba702fa 100644
> > > > --- a/net/ipv6/route.c
> > > > +++ b/net/ipv6/route.c
> > > > @@ -3195,6 +3195,9 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > > >         int entries;
> > > >
> > > >         entries = dst_entries_get_fast(ops);
> > > > +       if (entries > rt_max_size)
> > > > +               entries = dst_entries_get_slow(ops);
> > > > +
> > > >         if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> > > if this part of the condition is not satisfied, you are going to call
> > > fib6_run_gc anyways and after that you will update the entries. So I
> > > was wondering if code here could be something like:
> > > --- a/net/ipv6/route.c
> > > +++ b/net/ipv6/route.c
> > > @@ -3197,11 +3197,16 @@ static int ip6_dst_gc(struct dst_ops *ops)
> > >         unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> > >         int entries;
> > >
> > > +       if (time_before(rt_last_gc + rt_min_interval, jiffies)
> > > +               goto run_gc;
> > > +
> > >         entries = dst_entries_get_fast(ops);
> > > -       if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> > > -           entries <= rt_max_size)
> > > +       if (entries > rt_max_size)
> > > +               entries = dst_entries_get_slow(ops);
> > > +       if (entries <= rt_max_size)
> > >                 goto out;
> > >
> > > +run_gc:
> > >         net->ipv6.ip6_rt_gc_expire++;
> > >         fib6_run_gc(net->ipv6.ip6_rt_gc_expire, net, true);
> > >         entries = dst_entries_get_slow(ops);
> > >
> > > That way you could potentially avoid an extra call to
> > > dst_entries_get_slow when you know for sure that fib6_run_gc will be
> > > run. WDYT?
> >
> > The problem is that you might still return a wrong status in the final :
> >
> > return entries > rt_max_size;

Oh that's right, thanks for explaining!

> >
> > If we are in ip6_dst_gc(), we know for sure entries might be wrong,
> > if it holds dst_entries_get_fast(ops)
> >
> > If you prefer, the patch is really (since the caller calls us only if
> > dst_entries_get_fast(ops) was suspect)
> >
> > diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> > index ff847a324220bc4cac8b103640f7e1a5db374a87..78e7f3c14e8a9c937866361aaf641cecfe1fed43
> > 100644
> > --- a/net/ipv6/route.c
> > +++ b/net/ipv6/route.c
> > @@ -3196,7 +3196,7 @@ static int ip6_dst_gc(struct dst_ops *ops)
> >         unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
> >         int entries;
> >
> > -       entries = dst_entries_get_fast(ops);
> > +       entries = dst_entries_get_slow(ops);
> >         if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
> >             entries <= rt_max_size)
> >                 goto out;
>
> BTW, we do not _have_ to force a gc if entries (the more accurate
> value) is below gc_thresh
>
> That would be a separate patch :
>
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 4292653af533bb641ae8571fffe45b39327d0380..69a90802a70f830b286795c9c75c13c4ba345a72
> 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -3194,10 +3194,9 @@ static int ip6_dst_gc(struct dst_ops *ops)
>         unsigned long rt_last_gc = net->ipv6.ip6_rt_last_gc;
>         int entries;
>
> -       entries = dst_entries_get_fast(ops);
> -       if (entries > rt_max_size)
> -               entries = dst_entries_get_slow(ops);
> -
> +       entries = dst_entries_get_slow(ops);
> +       if (entries < ops->gc_thresh)
> +               return 0;
>         if (time_after(rt_last_gc + rt_min_interval, jiffies) &&
>             entries <= rt_max_size)
>                 goto out;
This makes sense, thanks!
