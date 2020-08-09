Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E1323FC20
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 04:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgHICHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 22:07:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbgHICHy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 22:07:54 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6750C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 19:07:53 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id s9so2947371lfs.4
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 19:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z3uwOhvPU8tDKpFgKcC2R919tAITsyZX/AV/GPcJMVY=;
        b=Z4MfgvYCMKxfgx5HBImokQsKNId1FQRzEK3F2CFlGpa6iF9XZk2LhkX0w5VLp0SygF
         Sov0LSLKSSY6bwM/FV6CtB1KLHwWZeDuUxy8v6FjHd/65lHvuBCwpug2EvEpv/49YaTB
         JcyX5QU89hz5g8N4/Z/vt8m3kcreAbq/pp4dQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z3uwOhvPU8tDKpFgKcC2R919tAITsyZX/AV/GPcJMVY=;
        b=j0J6TpOZTyqZJ70rNjFpcT1l3x/zCcAQjkaJJkn49LQqOPIjMmCnJ5T1+zqIU2cCdF
         zufDhDXR/ozjhdYSsFvAIrjRp93vEp0xWsRij0srPjFuvqlQ2Kk5sKfAqioYBRFolTBA
         OZMYhNk+9E+Nq9jGuH6X3dZZO2eGseO0l+Yrgzpkp2uDQJOWhdostcFasF2YxrHPru/j
         jcL7JZp68sHlf6LgqjyzdOWz8MOa4aMTK/q8kLLyZsMiAqTv1y1tvAeJAMxcPibx0uWs
         GP4fNxCgYT9ixrGhYAIXPYxxe+84KtwCdwZAdH+6T9j7zuDhct3X6AIzojbJI4gsRkeJ
         +GnQ==
X-Gm-Message-State: AOAM532bxhndSdABjFiqgcSbjH9G9xfu2F8ADe41ZD1zYg0lccutzD8H
        MAlrmBOXrieBlMq1e2sv690uACyiy+o=
X-Google-Smtp-Source: ABdhPJyLcJEP3+1jneURY8OXakFiJNh/bEnV+ssbi7qA+xnUC8gHLNEOzQr8IB+rGUGtLXkujnH0BQ==
X-Received: by 2002:a19:8314:: with SMTP id f20mr10244726lfd.199.1596938868834;
        Sat, 08 Aug 2020 19:07:48 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id b1sm6198207ljp.78.2020.08.08.19.07.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 19:07:47 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id m22so5979310ljj.5
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 19:07:46 -0700 (PDT)
X-Received: by 2002:a05:651c:503:: with SMTP id o3mr7378120ljp.312.1596938866088;
 Sat, 08 Aug 2020 19:07:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200808174451.GA7429@1wt.eu>
 <CAHk-=wjeRgAoKXo-oPOjLTppYOo5ZpXFG7h6meQz6-tP0gQuNg@mail.gmail.com>
 <20200808204729.GD27941@SDF.ORG> <CAHk-=whU-3rEAY551DeDsuVsZgLXyq37JX1kCvDzQFnuKzUXew@mail.gmail.com>
 <20200808222752.GG27941@SDF.ORG>
In-Reply-To: <20200808222752.GG27941@SDF.ORG>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Aug 2020 19:07:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh00nvUwT-yck2gt3eKgix-mBZ4RcGe1WJ6C5VDW4e6zw@mail.gmail.com>
Message-ID: <CAHk-=wh00nvUwT-yck2gt3eKgix-mBZ4RcGe1WJ6C5VDW4e6zw@mail.gmail.com>
Subject: Re: Flaw in "random32: update the net random state on interrupt and activity"
To:     George Spelvin <lkml@sdf.org>
Cc:     Willy Tarreau <w@1wt.eu>, Netdev <netdev@vger.kernel.org>,
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

On Sat, Aug 8, 2020 at 3:28 PM George Spelvin <lkml@sdf.org> wrote:
>
> It's not a theoretical hole, it's a very real one.  Other than the cycles
> to do the brute-force part, it's not even all that complicated.  The
> theory part is that it's impossible to patch.

We'll just disagree.

I'm really fed up with security holes that are brought on by crypto
people not being willing to just do reasonable things.

> *If* you do the stupid thing.  WHICH YOU COULD JUST STOP DOING.

We're not feeding all the same bits to the /dev/random that we're
using to also update the pseudo-random state, so I think you're
overreacting. Think of it as "/dev/random gets a few bits, and prandom
gets a few other bits".

The fact that there is overlap between the bits is immaterial, when
other parts are disjoint. Fractonal bits of entropy and all that.

> The explain it to me.  What is that actual *problem*?  Nobody's described
> one, so I've been guessing.  What is this *monumentally stupid* abuse of
> /dev/random allegedly fixing?

The problem is that the networking people really want unguessable
random state. There was a remote DNS spoofing poisoning attack because
the UDP ports ended up being guessable.

And that was actually reported to us back in early March.

Almost five months later, nothing had been done, all the discussion
bogged down about "theoretical randomness" rather than to actual
real-life security.

> If you're not an idiot, explain.
>
> Because right now you sound like one.  There's a simple and easy fix which
> I've described and will get back to implementing as soon as I've finished
> yelling at you.  What, FFS, is your objection to considering it?

By now, I'm not in the least interested in theoretical arguments.

I claim that the simple "mix in (different parts of) the TSC bits and
IP bits into _both_ the pseudo random state and the /dev/random state"
is going to make it hell on earth for anybody to ever find weaknesses
in either. Or if they do, they need to find and then exploit them
really quickly, because practically speaking, a few hundred times a
second you end up with noise that you cannot attack algorithmically
perturbing the state of both.

And I realize that drives you crazy. You _want_ to be able to analyze
the state to prove something about it. And that's absolutely the
opposite of what I want. I want the internal state (both prandom and
/dev/random) to simply not be amenable to analysis - simple because we
intentionally screw it up on interrupts. You can analyze it all you
want, knowing that in a few milliseconds you'll have to start over (at
least partially).

So even if you're the NSA, and it turns out that you have a magical
quantum computer that can break the best hash function crypto people
know about by just seeing a fairly small part stream of random
numbers, you'd better figure that state out quickly, because next
interrupt comes along, and we'll perturb it.

Or, say that you find something like meltdown, and can actually use
some side channel to read out the full state of our internal
/dev/random mixing buffers. ALL of it. No magic NSA quantum computer
required, just a side channel. Your "theoretical" are all complete and
utter shit in that case, if all we do is have the best possible secure
algorithm. Because the state is right there, and our
super-duper-secure algorithm is all open source, and your claims of
"this is unbreakable in theory" is just complet and utter nonsense.

This is why I claim the noise that you can't analyze is so important.
You see it as a weakness, because you see it as a "now I can't prove
certain things". I see it as exactly the opposite.

So to me, your whole "theoretical safety" argument is actually a huge
honking weakness.

Btw, you'll really hate what I did to /dev/random for initializing the
pool last year. Another case of "Christ, crypto people have screwed us
for decades, now I'm going to just fix it" situation.

Go do

    git log --author=Torvalds --no-merges drivers/char/random.c

and you'll probably have a heart attack.

              Linus
