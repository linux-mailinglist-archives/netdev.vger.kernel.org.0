Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AC4E23F3C0
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 22:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHGUYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 16:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbgHGUYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 16:24:40 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A513FC061756
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 13:24:39 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id v9so3506362ljk.6
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 13:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zAEfhaBLFHweOFHJGO1LUi9iEaryA05hJDqBMYtLh6Q=;
        b=FAnH9wp+lzAaIg0WLPx6/RG2l8zTqq+0ckpSbJjHs/J+JanKf5kyn16IV6IOsD99Gh
         7F8vnPHBj4Td3aQ16qLvGe8Jt5UG53byKM0I03OJXyc9T5Pf9Tuj6+XRpkoaH9/63/ot
         LVsacVn6XT+fAqtBms2PHxM25U7jnMxiehVjc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zAEfhaBLFHweOFHJGO1LUi9iEaryA05hJDqBMYtLh6Q=;
        b=Je503yIJQxRUcfW+AqBRQ65oNNb6baeE2g7T3sLY31jmST5gpbqqtQJvRNRlPIRK61
         We1MzeT2mY+rUIuGXVeCE0ICw9sZQM/g7DqC7o8ump3jDMgwL+ctc6MuRwGzzb9a+rGV
         Fn07UDCgDT0LPfVd4mjX8el2D1HCl1lbg7WapDTmEsSFIyHKddNGM19eT4vr6UTnAoEn
         mi3SJyQCLaFSv7c3LKhQCXm6w+4Iz7YrPtU+Xouwu/O0OQkuijs2Q1tjq3DX0WLIfSm7
         chHmBxL1I3KQbD9vkYZAGYZxbh8EqWVixkBqVMfvqFnYLwpHHpYrJvVWwWq3ceE3Sfpz
         iBrQ==
X-Gm-Message-State: AOAM530hKzyd3SMX3JB34jLaafglPeiqqOYnWUyg08Qi7OMn6l51Q+Kc
        r/Y6RzEOEXhA9xSHiXZTwCHZC8mmlpE=
X-Google-Smtp-Source: ABdhPJywF0VsLRhvYB554GCfKhQPJ10NB84SlDHmQn4QqMYJvWyiNZVmNcGoJpEvhkr1niHObObFIQ==
X-Received: by 2002:a2e:9f0a:: with SMTP id u10mr6798139ljk.140.1596831878108;
        Fri, 07 Aug 2020 13:24:38 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id m12sm4199750ljh.127.2020.08.07.13.24.37
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id i80so1626958lfi.13
        for <netdev@vger.kernel.org>; Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
X-Received: by 2002:ac2:58d5:: with SMTP id u21mr7050787lfo.31.1596831877024;
 Fri, 07 Aug 2020 13:24:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=whPgKZRfK_Kfo6Oo+Aek-Z_U_Dxv9Y3HuNuHb5t=jLbcA@mail.gmail.com>
 <57399571-280E-48CF-8F72-516F7178748C@amacapital.net>
In-Reply-To: <57399571-280E-48CF-8F72-516F7178748C@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 7 Aug 2020 13:24:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=whL2Uz7V8OGvZBN0aW0cgn3xTQhPu-jb-Aikn65nkt4Dw@mail.gmail.com>
Message-ID: <CAHk-=whL2Uz7V8OGvZBN0aW0cgn3xTQhPu-jb-Aikn65nkt4Dw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     Willy Tarreau <w@1wt.eu>, Marc Plumb <lkml.mplumb@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 7, 2020 at 1:16 PM Andy Lutomirski <luto@amacapital.net> wrote:
>
> I think this will come down to actual measurements :).

Numbers talk, bullshit walks.

But:

> If the cost of one block of cache-cold ChaCha20 is 100 cycles of actual c=
omputation and 200 cycles of various cache misses, then let=E2=80=99s do mo=
re than one block.

That's *completely* nonsensical thinking and crazy talk.

If the issue is latency (and for a lot of networking, that literally
*is* the issue), your mental model is completely insane.

"Oh, it's so expensive that we should queue *more*" is classic
throughput thinking, and it's wrong.

If you have performance problems, you should look really really hard
at fixing latency.

Because fixing latency helps throughput. But fixing throughput _hurts_ late=
ncy.

It really is that simple. Latency is the much more important thing to optim=
ize.

Nobody cares about "bulk TCP sequence numbers". Sure, you'll find
benchmarks for it, because it's a lot easier to benchmark throughput.
But what people _care_ about is generally latency.

              Linus
