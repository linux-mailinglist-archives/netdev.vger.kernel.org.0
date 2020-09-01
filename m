Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5992590F8
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 16:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgIAOmv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 10:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728242AbgIAOl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 10:41:28 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE52BC061244;
        Tue,  1 Sep 2020 07:41:27 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id j21so1336537oii.10;
        Tue, 01 Sep 2020 07:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=sZhvalbA03rUwegYGv+Cay08wKnFHq0gcapj8Z9U2kk=;
        b=Y/SqwzUN1T5jUMi6cZ2ZuDXFCwQ9pIW40bV/unURxBXPwk7DRwOLaHDwtTXPzup9gL
         cEFKY7SCHTeJimhPAs3bFuPsn0kDmnDHqJqlzU9FZmxXnMBjVPM//99pbmwwqN6oIWte
         cPVMbo+bJSoElNYuopQ8bm3qvB88PXV5tK4HvcEMtbO3qu1BW8WHnx9BmeYzDwOW94IC
         ce00MEsUDYw8friyEmXWOpscVEu6BASNFxHjNF7w/Je9hjg36WLddNLUiz4ApumVkjXB
         JCgKn4rBc2l++lCHpIQKhu6u/KNpjBU6MIMXDIe6asHbk3XQ6DA03spR28BYEr5LsOT7
         Vn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=sZhvalbA03rUwegYGv+Cay08wKnFHq0gcapj8Z9U2kk=;
        b=iWSNWnBFYOKBddw/tSz7QbMmjI3FiAZAfTBljY5JkN2rMNP4lzxmgnEu0fmGm51YxI
         B5723LYRGFerK1n4bszVMYsb906SpdGa6TduhAnM/iHp7douK7d8pyDMEu1uaH6xTliY
         tnTlk1HRTlnitzdEM9XAKHRvbl+73FEP1uZUujzXbxzvVCwJZRlU3zJDopVGGitGwKTO
         C+oO/HDs9N/G5ybi9qyrgz/cH5vXZc/4scLBbtHhMcbPtKiDhsDE2IIcicRzvhThY+QG
         o6o2cOCvBT7rwhxwj6k1oQFtavqgK0ImIIgiHSEmL6zkRpdmH/6bwUfCfR+KS0jnFV1w
         lrpw==
X-Gm-Message-State: AOAM531QHxhHXjvu7r+nYInNKQ9B3m6Z1H3FqOh/4YY/WLI/1J495FME
        9krJuJ9kFmcPc/fvqc/VjcpoyUS/E//KCnjgBKVNg8HMbL0FtQ==
X-Google-Smtp-Source: ABdhPJy3jGYbnV0erw5CDV78wbHykPio/a1ecP5Cmr4JMTFhJXSUqBMYPpa4dn07GhhqNIJgtM5NUmjuAwVvejaykGs=
X-Received: by 2002:aca:d409:: with SMTP id l9mr1255941oig.70.1598971287129;
 Tue, 01 Sep 2020 07:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200901064302.849-1-w@1wt.eu>
In-Reply-To: <20200901064302.849-1-w@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 1 Sep 2020 16:41:13 +0200
Message-ID: <CA+icZUVvOArpuR=PJBg288pJmLmYxtgZxJOHnjk943e9M22WOQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] prandom_u32: make output less predictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        George Spelvin <lkml@sdf.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, tytso@mit.edu,
        Florian Westphal <fw@strlen.de>,
        Marc Plumb <lkml.mplumb@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 1, 2020 at 8:43 AM Willy Tarreau <w@1wt.eu> wrote:
>
> This is the cleanup of the latest series of prandom_u32 experimentations
> consisting in using SipHash instead of Tausworthe to produce the randoms
> used by the network stack. The changes to the files were kept minimal,
> and the controversial commit that used to take noise from the fast_pool
> (f227e3ec3b5c) was reverted. Instead, a dedicated "net_rand_noise" per_cpu
> variable is fed from various sources of activities (networking, scheduling)
> to perturb the SipHash state using fast, non-trivially predictable data,
> instead of keeping it fully deterministic. The goal is essentially to make
> any occasional memory leakage or brute-force attempt useless.
>
> The resulting code was verified to be very slightly faster on x86_64 than
> what is was with the controversial commit above, though this remains barely
> above measurement noise. It was only build-tested on arm & arm64.
>
> George Spelvin (1):
>   random32: make prandom_u32() output unpredictable
>
> Willy Tarreau (1):
>   random32: add noise from network and scheduling activity
>
>  drivers/char/random.c   |   1 -
>  include/linux/prandom.h |  55 ++++-
>  kernel/time/timer.c     |   9 +-
>  lib/random32.c          | 438 ++++++++++++++++++++++++----------------
>  net/core/dev.c          |   4 +
>  5 files changed, 326 insertions(+), 181 deletions(-)
>
> Cc: George Spelvin <lkml@sdf.org>
> Cc: Amit Klein <aksecurity@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: tytso@mit.edu
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Marc Plumb <lkml.mplumb@gmail.com>
> Cc: Sedat Dilek <sedat.dilek@gmail.com>
>

I have tested with the patchset from [1].
( Later I saw, you dropped "WIP: tcp: reuse incoming skb hash in
tcp_conn_request()". )

- Sedat -

https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/prandom.git/log/?h=20200901-siphash-noise


> --
> 2.28.0
