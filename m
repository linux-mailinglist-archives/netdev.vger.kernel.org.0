Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A249B240038
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbgHIVso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgHIVsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 17:48:43 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FD5C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 14:48:43 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id w14so7530787ljj.4
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 14:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xetCWL4C18TqaePuXkSffzZVk3mkOP/4yiWNQDyJksU=;
        b=IkgyM8ctRhv/sDqGd9sJVc1GcDREg6qVJ+sICx5T3ipq7hDRa4SHPwMKPqfD2uUjWA
         bC8NkSng73MrUOCUuozufeFG72PV3aqfzDWah+1xLUH14msPyJCkUIP0AjJB8JGu+WC3
         K/Y4U9BtIr8O7ViDXGfpYeayC/0c2ASh7f9nU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xetCWL4C18TqaePuXkSffzZVk3mkOP/4yiWNQDyJksU=;
        b=MUDCB3E/aevu+couyjDfA5+rXlF4VZvhY8RqCWa5vw3TLfheXH2cg1OiIw8EQJ1TmK
         MHLt1gtBIzESmLV3eOGR5iQmlbP9ZvZON9nrIQqmLa6KC6Si52j3myt6Wt/+PmFLMEKB
         RgWPZB0DBZmhVREIqmhVgdk3R5GzYUankFCslxoCHuewSiNNo9FVDAXlmNdvdPnxvdb9
         bxON123srQiQ54BoeELPYu2V3ydK9HJz0hCZJetL3lokbE4sSzUfoLQze4FAPSlUee6B
         d9GWeZZrvbt5u7HCUeD/dqxc6J/ENlCZIhNyHHIE/PHG9ZALEOepTl8GRdGz0L8NQSar
         aJmQ==
X-Gm-Message-State: AOAM533/J5FqHezGfDZ/pc6Hfd8yvtSJcZ+NP/kBKpy91Fuadz072Ae8
        KNGhyCmWUi64EkL/3Y2BSNWsf9vpcak=
X-Google-Smtp-Source: ABdhPJy6PS2eKpZLoc4ArTy7oE2svSW/NOUi8Y0zYx6vZjJuz086fP8m7PyCbwzil6jTqB6htfsmeA==
X-Received: by 2002:a2e:b708:: with SMTP id j8mr11253323ljo.375.1597009720777;
        Sun, 09 Aug 2020 14:48:40 -0700 (PDT)
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com. [209.85.208.179])
        by smtp.gmail.com with ESMTPSA id j6sm8304643lja.23.2020.08.09.14.48.39
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Aug 2020 14:48:39 -0700 (PDT)
Received: by mail-lj1-f179.google.com with SMTP id g6so7495684ljn.11
        for <netdev@vger.kernel.org>; Sun, 09 Aug 2020 14:48:39 -0700 (PDT)
X-Received: by 2002:a2e:2e04:: with SMTP id u4mr10322251lju.102.1597009718796;
 Sun, 09 Aug 2020 14:48:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
 <20200809093805.GA7928@1wt.eu> <fdbc7d7d-cba2-ef94-9bde-b3ccae0cfaac@gmail.com>
 <f7070a63-a028-a754-6aeb-2f9328d2e00e@gmail.com>
In-Reply-To: <f7070a63-a028-a754-6aeb-2f9328d2e00e@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun, 9 Aug 2020 14:48:23 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgHd4jNRVuaMQN77Q7f0rddibbBdexznOFhKcjmrr-ZjA@mail.gmail.com>
Message-ID: <CAHk-=wgHd4jNRVuaMQN77Q7f0rddibbBdexznOFhKcjmrr-ZjA@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Marc Plumb <lkml.mplumb@gmail.com>
Cc:     Willy Tarreau <w@1wt.eu>, George Spelvin <lkml@sdf.org>,
        Netdev <netdev@vger.kernel.org>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Florian Westphal <fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 9, 2020 at 2:10 PM Marc Plumb <lkml.mplumb@gmail.com> wrote:
>
> However, I think I'm starting to see your underlying assumptions.
> You're thinking that raw noise data are the only truly unpredictable
> thing so you think that adding it is a defense against attacks like
> foreshadow/spectre/meltdown. You aren't entirely wrong -- if there was
> a fast noise source then it might be a good option. Just if the noise
> source is slow, you're just causing far more damage to a far more
> critical crypto function to get very little benefit.

The only truly good noise source we have is any CPU native randomness.

Sadly, that is usually never really "fast". But we do use that for any
actual real /dev/random reading. We still whiten it through our
hashing, and we mix it in rather than use the raw CPU hw-provided
values (because not everybody trusts the CPU vendors either), but
/dev/random will most certainly take advantage of it as one source of
noise.

(Honesty in advertising: you can also use other interfaces that don't
bother with the remixing, and _will_ just return the raw CPU
randomness).

So if you make the (imho reasonable) assumption that you're running on
a modern enough CPU, and that the CPU hw randomness is of reasonable
quality, then you never need to worry about /dev/random. Every single
time you extract something from one of the pools, I think we mix in
that CPU randomness if it's available.

But the CPU randomness is too slow for the prandom code to use at
extraction time. It's on the order of a couple of hundred to a couple
of thousand cycles. That's peanuts for /dev/random, but quite a lot
for prandom.

In fact, at the slow end it is slow enough that you don't want to do
it at any fast granularity (ie not "every interrupt"), it's the "when
reseeding once a second" kind of slow.

arm64 has randomness too these days too, but that's only of the
"really slow, useful for seeding" variety. And I'm not sure which (if
any) CPU implementations out there actually do it yet.

Anyway, I suspect /dev/random has been over-engineered (I think we
have something like three layers of mixing bits _and_ the CPU
randomness _and_ all the interrupt randomness), and prandom may have
been left alone too much.

             Linus
