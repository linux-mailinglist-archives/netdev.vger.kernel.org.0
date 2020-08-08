Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B694723F86F
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:19:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgHHSTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726250AbgHHSTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 14:19:23 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24160C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 11:19:23 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 185so5493004ljj.7
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 11:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LreW+mGC5lh7m37Sqqgbet75hPTvpkK3SNiB5dU08D0=;
        b=Ez7yTEJAjNFRxAOsa9r+rsixwN/kLgmE+isvvcvsFpKc5rvrf7cbYZ19s3Z7U26o+X
         Tu5Rh2uZfbcEQevwBrKI9FIZF1ul4ZyCwe1I5VvJWCAYUM4E79tjUlaTD8e+wEF7j/6Q
         BK0Cz3z25iIELxXRkULpDaInF5JJLwmo1zohY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LreW+mGC5lh7m37Sqqgbet75hPTvpkK3SNiB5dU08D0=;
        b=dthW+GPdmvtvN2eTrNl6ZBByxPo1a6UbjOlhHXCFdXR8dgHGok4WG4OfBGskMbzP2f
         ekf6fJz3n9nBVcJ6afsQt8eoKFP87GeqMiOJ0zE5Dtt5EuwsVlDSGPTvjiiv5i5UgX/S
         LmyCngQW7KkTqVMH2qNteMSj3ODLDymvf+9bs9f7yW9HwC5cQVIJ/cG9ApouFv4UuuRy
         3Bzz4EqX+qbCdTjUdoanwrCsxN1O/uNFka/otck9a9IBrKDMTuCqh7lZZAyLBa+Ni7Kd
         xVMsRXvYUcCcX2gE5n6Vh7b3kl7LQfsDGoE7dmpMj9yRowvUI5xPMkmYo1GTiQPlrQ/5
         Ebuw==
X-Gm-Message-State: AOAM533R4oySqe0F9n6DTjJLoHN6okLCoVLDAykeWH23U81kqg/Kbzv9
        9CtpFQ3zPxi5hYCqQU6MDdyCR20yHOM=
X-Google-Smtp-Source: ABdhPJxriSCM4M3J8Sa1b0q1BXzRenHGv+wv/ulyhudAgQ8Gvkxwe9GzDJK6jxUIantazVYQivJfMw==
X-Received: by 2002:a2e:81d9:: with SMTP id s25mr8668179ljg.104.1596910760246;
        Sat, 08 Aug 2020 11:19:20 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id x2sm5371511ljc.123.2020.08.08.11.19.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 11:19:18 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id v4so5520444ljd.0
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 11:19:17 -0700 (PDT)
X-Received: by 2002:a2e:9a11:: with SMTP id o17mr8609502lji.314.1596910757579;
 Sat, 08 Aug 2020 11:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200808174451.GA7429@1wt.eu>
In-Reply-To: <20200808174451.GA7429@1wt.eu>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Aug 2020 11:19:01 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
Message-ID: <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Marc Plumb <lkml.mplumb@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 8, 2020 at 10:45 AM Willy Tarreau <w@1wt.eu> wrote:
>
>
>     WIP: random32: use siphash with a counter for prandom_u32

siphash is good.

But no:

> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1277,7 +1277,6 @@ void add_interrupt_randomness(int irq, int irq_flags)
>
>         fast_mix(fast_pool);
>         add_interrupt_bench(cycles);
> -       this_cpu_add(net_rand_state.s1, fast_pool->pool[cycles & 3]);
>
>         if (unlikely(crng_init == 0)) {
>                 if ((fast_pool->count >= 64) &&
> --- a/include/linux/random.h
> +++ b/include/linux/random.h
> diff --git a/kernel/time/timer.c b/kernel/time/timer.c
> index 026ac01af9da..c9d839c2b179 100644
> --- a/kernel/time/timer.c
> +++ b/kernel/time/timer.c
> @@ -1743,13 +1743,6 @@ void update_process_times(int user_tick)
>         scheduler_tick();
>         if (IS_ENABLED(CONFIG_POSIX_TIMERS))
>                 run_posix_cpu_timers();
> -
> -       /* The current CPU might make use of net randoms without receiving IRQs
> -        * to renew them often enough. Let's update the net_rand_state from a
> -        * non-constant value that's not affine to the number of calls to make
> -        * sure it's updated when there's some activity (we don't care in idle).
> -        */
> -       this_cpu_add(net_rand_state.s1, rol32(jiffies, 24) + user_tick);
>  }

We're not going back to "don't add noise, just make a stronger
analyzable function".

I simply won't take it. See my previous email. I'm 100% fed up with
security people screwing up real security by trying to make things
overly analyzable.

If siphash is a good enough hash to make the pseudo-random state hard
to guess, then it's also a good enough hash to hide the small part of
the fast-pool we mix in.

And while security researchers may hate it because it's hard to
analyze, that's the POINT, dammit.

This "it's analyzable" makes it repeatable. And since mixing in
serious things is too slow, and people thus delay reseeding for too
long, then we reseed with random crap that doesn't hurt and that isn't
realistically analyzable.

              Linus
