Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B9624589C
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 18:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728607AbgHPQsW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 12:48:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgHPQsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 12:48:18 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF314C061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 09:48:17 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id v21so11584951otj.9
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 09:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=VN1tUW4WtJh3F0SB1B45dcXV8wdVc3ZZA7Rmt7Mx+D0=;
        b=A/ESRS7kjs0vt+mKc+E05pUpwEONqnq9uq9NRgvwoQs1cCOZfemTbEoEsP/5m/ohRB
         l7sUKQHc/11+FRGX9aRK0iXKZKwF+COqNnIf/9khDVDebrxEF8rQTM0Jvv77jnEbYGz0
         bxIx6K+KDydhaZ3In8sem2M2oq/oSgT7nqA0ht39pfXc4PlRd/Gp45Wnppkp8DRzg4NY
         ioVHNX5svrtOr4UN3s7g/7MgfdZyalaUO3oWnXWP8/9K8JPv2FXkeLsJVqPhMPY6lq0N
         0dVrwiFG9UYvH7NjXOlYxrW3+ZF9Ww+6GvZjWuWuvltxfopXm8A+rYjMbhS17lBa/iEp
         psAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=VN1tUW4WtJh3F0SB1B45dcXV8wdVc3ZZA7Rmt7Mx+D0=;
        b=IcWMANMmsP+AzwgmT61HEDWTfsrq4bq5Yhy8T8fVKO1ajA1DuX/GEr54DN86kdP2ZQ
         5zeJW/Z8WonOOVm8CukBgUYLyFWXcqGlgxq9P/19qylwhbcaUBZSqLGo4j2hCkN0NgDj
         Ep30z5Z3RpA/d8yqeTpB1X2TYu4ECcMunwxv7FMWLi6eZ7NOkhZtsNcPMluoRBYIdS4j
         IyVIP9hw3gKoZRWTUEnH5TaO2LIhc6+9EfaHYOjOApGYOjeIAFOaD1+VePfcC7eb9tgo
         WrReBRSysDrJB+6+Psx9Seco9BcxmvaoaWU4JfTF7XyV2daNcUEJW0n+0wA1v0cgNWEt
         OHSg==
X-Gm-Message-State: AOAM530a9ycA5TQV9cO7b2vdTMjA36j4PhduqPd13zQMPZY+d8LKFmiu
        a+Fg58lE10eaCKFPez9d4A/I73SfM4fGhpJ2kOQ=
X-Google-Smtp-Source: ABdhPJx1mrrj8YzoMgaviTv4iCpYQPlUnuwbI0w56DV7TEyEHDDHXt6yvtIKvo/R0ZZbMo+UzJ8P4PsEUO54YY/0G38=
X-Received: by 2002:a9d:7656:: with SMTP id o22mr8002394otl.109.1597596496755;
 Sun, 16 Aug 2020 09:48:16 -0700 (PDT)
MIME-Version: 1.0
References: <20200811054328.GD9456@1wt.eu> <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu> <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu> <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu>
In-Reply-To: <20200816150133.GA17475@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Sun, 16 Aug 2020 18:48:05 +0200
Message-ID: <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     Eric Dumazet <edumazet@google.com>, George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 16, 2020 at 5:01 PM Willy Tarreau <w@1wt.eu> wrote:
>
> Hi,
>
> so as I mentioned, I could run several test on our lab with variations
> around the various proposals and come to quite positive conclusions.
>
> Synthetic observations: the connection rate and the SYN cookie rate do not
> seem to be affected the same way by the prandom changes. One explanation
> is that the connection rates are less stable across reboots. Another
> possible explanation is that the larger state update is more sensitive
> to cache misses that increase when calling userland. I noticed that the
> compiler didn't inline siprand_u32() for me, resulting in one extra
> function call and noticeable register clobbering that mostly vanish
> once siprand_u32() is inlined, getting back to the original performance.
>
> The noise generation was placed as discussed in the xmit calls, however
> the extra function call and state update had a negative effect on
> performance and the noise function alone appeared for up to 0.23% of the
> CPU usage. Simplifying the mix of data by keeping only one long for
> the noise and using one siphash round on 4 input words to keep only
> the last word allowed to use very few instructions and to inline them,
> making the noise collection imperceptible in microbenchmarks. The noise
> is now collected this way (I verified that all inputs are used), this
> performs 3 xor, 2 add and 2 rol, which is way sufficient and already
> better than my initial attempt with a bare add :
>
>   static inline
>   void prandom_u32_add_noise(unsigned long a, unsigned long b,
>                              unsigned long c, unsigned long d)
>   {
>         /*
>          * This is not used cryptographically; it's just
>          * a convenient 4-word hash function. (3 xor, 2 add, 2 rol)
>          */
>         a ^= __this_cpu_read(net_rand_noise);
>         PRND_SIPROUND(a, b, c, d);
>         __this_cpu_write(net_rand_noise, d);
>   }
>
> My tests were run on a 6-core 12-thread Core i7-8700k equipped with a 40G
> NIC (i40e). I've mainly run two types of tests:
>
>   - connections per second: the machine runs a server which accepts and
>     closes incoming connections. The load generators aim at it and the
>     connection rate is measured once it's stabilized.
>
>   - SYN cookie rate: the load generators flood the machine with enough
>     SYNs to saturate the CPU and the rate of response SYN-ACK is measured.
>
> Both correspond to real world use cases (DDoS protection against SYN flood
> and connection flood).
>
> The base kernel was fc80c51f + Eric's patch to add a tracepoint in
> prandom_u32(). Another test was made by adding George's changes to use
> siphash. Then another test was made with the siprand_u32() function
> inlined and with noise stored as a full siphash state. Then one test
> was run with the noise reduced to a single long. And a final test was
> run with the noise function inlined.
>
>           connections    SYN cookies   Notes
>           per second     emitted/s
>
>   base:     556k          5.38M
>
>   siphash:  535k          5.33M
>
>   siphash inlined
>   +noise:   548k          5.40M    add_noise=0.23%
>
>   siphash + single-word
>    noise    555k          5.45M    add_noise=0.10%
>
>   siphash + single-word&inlined
>    noise    559k          5.38M
>
> Actually the last one is better than the previous one because it also
> swallows more packets. There were 10.9M pps in and 5.38M pps out versus
> 10.77M in and 5.45M out for the previous one. I didn't report the incoming
> traffic for the other ones as it was mostly irrelevant and always within
> these bounds.
>
> Finally I've added Eric's patch to reuse the skb hash when known in
> tcp_conn_request(), and was happy to see the SYN cookies reach 5.45 Mpps
> again and the connection rate remain unaffected. A perf record during
> the SYN flood showed almost no call to prandom_u32() anymore (just a few
> in tcp_rtx_synack()) so this looks like a desirable optimization.
>
> At the moment the code is ugly, in experimental state (I've pushed all of
> it at https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/).
>
> My impression on this is that given that it's possible to maintain the
> same level of performance as we currently have while making the PRNG much
> better, there's no more reason for not doing it.
>
> If there's enough interest at this point, I'm OK with restarting from
> George's patches and doing the adjustments there. There's still this
> prandom_seed() which looks very close to prandom_reseed() and that we
> might possibly better remerge, but I'd vote for not changing everything
> at once, it's ugly enough already. Also I suspect we can have an infinite
> loop in prandom_seed() if entropy is 0 and the state is zero as well.
> We'd be unlucky but I'd just make sure entropy is not all zeroes. And
> running tests on 32-bit would be desirable as well.
>
> Finally one can wonder whether it makes sense to keep Tausworthe for
> other cases (basic statistical sampling) or drop it. We could definitely
> drop it and simplify everything given that we now have the same level of
> performance. But if we do it, what should we do with the test patterns ?
> I personally don't think that testing a PRNG against a known sequence
> brings any value by definition, and that the more random we make it the
> less relevant this is.
>

Hi Willy,

Thanks for the new patchset and offering it via public available Git.

Thanks for the numbers.

As said I tested here against Linux v5.8.1 - with your previous patchset.

I cannot promise I will test the new one.

First, I have to see how things work with Linux v5.9-rc1 - which will
hopefully be released within a few hours.
My primary focus is to make it work with my GNU and LLVM toolchains.

Regards,
- Sedat -
