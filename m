Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0329A5F2052
	for <lists+netdev@lfdr.de>; Sun,  2 Oct 2022 00:31:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJAWb2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 18:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJAWb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 18:31:27 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9C31EF7
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 15:31:27 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-354c7abf786so76077417b3.0
        for <netdev@vger.kernel.org>; Sat, 01 Oct 2022 15:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=VtRVhYoVVhm4sjpqJgjUmYLvQMMd1LrR+yus67m/gYY=;
        b=XBI+My8RJeM3fuzkVduOF7hkBrLIM7La8u4J20dQI4YwuMkca1PRlppr5dBPukk8Rp
         251ZZKj+nVNhCTtra/O7i3lGv1oNNtbqzFO6gpjlbd0I6ne9isr1q4vjnxUUpCD5DfUt
         zaA0rcOr/3YY7AkB4evLW/yk25twW4iKh/7FdXpcSvVhdYm4WQ5LVSawpz8tIfwzeDq6
         x96poGzap3GRTivMLvvRMg1lCO/dNXliSiQ6MFqAOETcB6AVcL8Ds5X5yEVVD6OrFh4m
         aK2LUgrtTxruhoGx6jdCHd7iCKXoFVvOqO/S2bQgc7bjeG/QfjXOO35l0+Y8QtWDwtY3
         STOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=VtRVhYoVVhm4sjpqJgjUmYLvQMMd1LrR+yus67m/gYY=;
        b=TiHWB9x/eAGIQ/T/oxCcYer6l5w3TjlLqez7f20qb32XKnxnAHBabimihNWBnT66BA
         UxQ/gkYFHij/mxPw7HBmqvmv7eD9zf3ecHo2u547LiIkWNmg6dFFJuKvKnA6IdvVs9Df
         cXrMTF9b9FQW9O3plC7c8dSRhoXs4nnL4SRmiitcEffZD5R1AX+1phGApQ0SD5K+yRLs
         6zva6t0EbPLqz361QKwkM4iuCh6R1TdxZHDqX9Qc4buT7Pb8yBVrU0wi39RgWszAje8e
         uin6i+V/CImqIQCJzLmZghrXkrzUKBdXsLj4P85iGTF8PaRweFumTV1vjlm6hQMSbk0s
         cLrQ==
X-Gm-Message-State: ACrzQf3eBDzwFXnNRqQm+XTCkgs/iOlIR8/Q35/1eFc5pCNkRIZ/FgDz
        vwojPmdP/QajOuGoEbhJzhqFGXpD/cPvSSFdqimiHg==
X-Google-Smtp-Source: AMsMyM6MlsU+skI+/7/rb1Nu+GiS54aVjKRFst8hRVS+BRGnr8LnTGc/4/ceHMiXJu3X0FR87P2o+tC8GmGzyILQEqo=
X-Received: by 2002:a0d:ea90:0:b0:358:b93:d039 with SMTP id
 t138-20020a0dea90000000b003580b93d039mr3090060ywe.47.1664663485960; Sat, 01
 Oct 2022 15:31:25 -0700 (PDT)
MIME-Version: 1.0
References: <03a06114-bc63-bc01-be38-535bcc394612@csgroup.eu>
 <CANn89iKzfzOUPc+g0Brfzyi2efnXE0jLUebBz5fQMWVt9UCtfA@mail.gmail.com>
 <CANn89iLAEYBaoYajy0Y9UmGFff5GPxDUoG-ErVB2jDdRNQ5Tug@mail.gmail.com> <Yzi8Md2tkSYDnF1B@zx2c4.com>
In-Reply-To: <Yzi8Md2tkSYDnF1B@zx2c4.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sat, 1 Oct 2022 15:31:15 -0700
Message-ID: <CANn89iK3maLVo_G7MGswuXV0Og9tEFJxMZt+34ZKTo4zUNoLRw@mail.gmail.com>
Subject: Re: 126 ms irqsoff Latency - Possibly due to commit 190cc82489f4
 ("tcp: change source port randomizarion at connect() time")
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 1, 2022 at 3:16 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> (CC+Sebastian)
>
> Hi Eric, Christophe,
>
> I'm trying to understand the context of this and whether/why there's a
> problem. Some overview on how get_random_bytes() works:
>
> Most of the time, get_random_bytes() is completely lockless and operates
> over per-CPU data structures. get_random_bytes() calls
> _get_random_bytes(), which calls crng_make_state(), and then operates
> over stack data to churn out some random bytes. crng_make_state() is
> where all the meat happens.
>
> In crng_make_state(), there are three unlikely conditionals where locks
> are taken. The first is:
>
>     if (!crng_ready()) {
>         ... do some expensive things involving locks ...
>         ... but only during early boot before the rng is initialized ...
>     }
>
> The second one is:
>
>     if (unlikely(time_is_before_jiffies(READ_ONCE(base_crng.birth) + crng_reseed_interval()))) {
>         ... do something less expensive involving locks ...
>         ... which happens approximately once per minute ...
>     }
>
> The third one is:
>
>     if (unlikely(crng->generation != READ_ONCE(base_crng.generation))) {
>         ... do something even less expensive involving locks ...
>         ... which happens when after a different cpu hit the above ...
>     }
>
> So all three of these conditions are pretty darn unlikely, with the
> exception of the first one that happens all the time during early boot
> before the RNG is initialized, after which it is static-branched out and
> never triggers again. So as far as /locks/ are concerned, things should
> be good here.
>
> However, in order to operate on per-cpu data, and therefore be lockless
> most of the time, it does take a "local lock", which is basically just
> disabling interrupts on non-RT to do a short operation:
>
>     local_lock_irqsave(&crngs.lock, flags);
>     crng = raw_cpu_ptr(&crngs);
>     crng_fast_key_erasure(...);
>     local_unlock_irqrestore(&crngs.lock, flags);
>
> crng_fast_key_erasure(), in turn, computes a single block of chacha20,
> which should be relatively fast. So the critical section is very short
> there.
>
> The reason that's local_lock_irqsave() rather than local_lock() (which
> would only disable preemption, I believe), is because IRQ handlers are
> supposed to be able to have access to random bytes too. It seems like it
> wouldn't be a super nice thing to remove that capability.
>
> It might be possible to double the amount of per-cpu data and have a
> separate state for IRQ than for non-IRQ, but that seems kind of wasteful
> and complex/hairy to implement.
>
> So that leads me to wonder more about the context: why does this matter?
> It looks like you're hitting this from a DO_ONCE() thing, which are
> usually only hit, as the name says, once, and then incur the overhead of
> firing off a worker to change the once-static-branch, which means
> DO_ONCE()es aren't very fast anyway? Or does that not accurately reflect
> what's happening?
>
> I'll also CC Sebastian here, who worked with me on that local lock and
> might have some insights on IRQ latency as well.

Sorry Jason, it seems I forgot to CC you on the tentative patch I sent
earlier today

https://patchwork.kernel.org/project/netdevbpf/patch/20221001205102.2319658-1-eric.dumazet@gmail.com/
