Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5123F86C
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 20:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgHHSNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 14:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbgHHSNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 14:13:42 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142D3C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 11:13:42 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id g6so5459759ljn.11
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 11:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EIRQ7pWguqeGpLMXstW0ASsVnJMVBGKxJvRykZiwucg=;
        b=AAf6nZhRh9uy1Oo6RIk4PbubkPXt3X0DuzntMkV6AtlaPnEWI50KPmSTHZ/a/kWSwK
         yoJps29MRRUyka4gphUrnR0/1aYyj9Jce1/zlgAqR730U4870NQDjznokOtRsQdeeGxf
         /ioGLlFzPKN4Q32gmZ2IIsk8ZlljLRIvffR9A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EIRQ7pWguqeGpLMXstW0ASsVnJMVBGKxJvRykZiwucg=;
        b=KeB7kaeqO4By9gp3TxX2L0z8nlyz7D6NCZKq31WPGLJ+t919qdHovhHMGJErQJ8h9u
         MKpNlQAwo1MUD53DGA7qNWG70XD3elwWNxSxxdIkUVUhV3qReq9LBulT52/BHMCUTt1a
         u0IU6eL2WysaU5d2lIhfiO65/qm/WP5i1BjzTsBlF1S3vG0PJrA9H9G52O7kJ3VnFDUa
         9j45o11TS/ecBsXRZO8ddNMFcKRObTwrJ7Oplr+y7UyBq3RYy0fT1xER/kEO3/nEeK+W
         vAEt34DUKYdtJqtprhKb8C/l21Pp9KnE0PMvSIyEf4PY3FbBddyGeTPni6BhVvF80pyG
         bbRQ==
X-Gm-Message-State: AOAM53109ILjY22P+8zIt1+BhvlAPMz3I0cltiT67JRQLTu7gh4cFjB3
        I6zYJXirw6VLjcKj2B++qYph9UdhylA=
X-Google-Smtp-Source: ABdhPJx1DTIt3kmXToYs4f9rNzTq0QaVW1YOCc2vf+dTz8WN6z5hq7S33hRIEQ5OtOhWjCEC1xnOQg==
X-Received: by 2002:a05:651c:106a:: with SMTP id y10mr8805111ljm.296.1596910418933;
        Sat, 08 Aug 2020 11:13:38 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id u28sm717660ljd.39.2020.08.08.11.13.36
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 11:13:37 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id w25so5468479ljo.12
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 11:13:36 -0700 (PDT)
X-Received: by 2002:a2e:7615:: with SMTP id r21mr8362623ljc.371.1596910416430;
 Sat, 08 Aug 2020 11:13:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
In-Reply-To: <7E03D29C-2982-43C9-81E6-DB46FF4D369E@amacapital.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Aug 2020 11:13:20 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiSw7zYVUxiGT=_TPx1fqtNNYgu0L6rC=GaSGpCDnDbVw@mail.gmail.com>
Message-ID: <CAHk-=wiSw7zYVUxiGT=_TPx1fqtNNYgu0L6rC=GaSGpCDnDbVw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     George Spelvin <lkml@sdf.org>, Netdev <netdev@vger.kernel.org>,
        Willy Tarreau <w@1wt.eu>, Amit Klein <aksecurity@gmail.com>,
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

On Sat, Aug 8, 2020 at 10:07 AM Andy Lutomirski <luto@amacapital.net> wrote:
>
>
> > On Aug 8, 2020, at 8:29 AM, George Spelvin <lkml@sdf.org> wrote:
> >
>
> > And apparently switching to the fastest secure PRNG currently
> > in the kernel (get_random_u32() using ChaCha + per-CPU buffers)
> > would cause too much performance penalty.
>
> Can someone explain *why* the slow path latency is particularly relevant here?

You guys know what's relevant?  Reality.

The thing is, I see Spelvin's rant, and I've generally enjoyed our
encounters in the past, but I look back at the kinds of security
problems we've had, and they are the exact _reverse_ of what
cryptographers and Spelvin is worried about.

The fact is, nobody ever EVER had any practical issues with our
"secure hash function" even back when it was MD5, which is today
considered trivially breakable.

Thinking back on it, I don't think it was even md5. I think it was
half-md5, wasn't it?

So what have people have had _real_ security problems with in our
random generators - pseudo or not?

EVERY SINGLE problem I can remember was because some theoretical
crypto person said "I can't guarantee that" and removed real security
- or kept it from being merged.

Seriously.

We've had absolutely horrendous performance issues due to the
so-called "secure" random number thing blocking. End result: people
didn't use it.

We've had absolutely garbage fast random numbers because the crypto
people don't think performance matters, so the people who _do_ think
it matters just roill their own.

We've had "random" numbers that weren't, because random.c wanted to
use only use inputs it can analyze and as a result didn't use any
input at all, and every single embedded device ended up having the
exact same state (this ends up being intertwined with the latency
thing).

We've had years of the drivers/char/random.c not getting fixed because
Ted listens too much to the "serious crypto" guys, with the end result
that I then have to step in and say "f*ck that, we're doing this
RIGHT".

And RIGHT means caring about reality, not theory.

So instead of asking "why is the slow path relevant", the question
should be "why is some theoretical BS relevant", when history says it
has never ever mattered.

Our random number generation needs to be _practical_.

When Spelvin and Marc complain about us now taking the fastpool data
and adding it to the prandom pool and "exposing" it, they are full of
shit. That fastpool data gets whitened so much by two layers of
further mixing, that there is no way you'll ever see any sign of us
taking one word of it for other things.

I want to hear _practical_ attacks against this whole "let's mix in
the instruction pointer and the cycle counter into both the 'serious'
random number generator and the prandom one".

Because I don't think they exist. And I think it's actively dangerous
to continue on the path of thinking that stable and "serious"
algorithms that can be analyzed are better than the one that end up
depending on random hardware details.

I really think kernel random people need to stop this whole "in
theory" garbage, and embrace the "let's try to mix in small
non-predictable things in various places to actively make it hard to
analyze this".

Because at some point, "security by obscurity" is actually better than
"analyze this".

And we have decades of history to back this up. Stop with the crazy
"let's only use very expensive stuff has been analyzed".

It's actively detrimental.

It's detrimental to performance, but it's also detrimental to real security.

And stop dismissing performance as "who cares". Because it's just
feeding into this bad loop.

               Linus
