Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31AE23F8CB
	for <lists+netdev@lfdr.de>; Sat,  8 Aug 2020 22:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgHHUsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 16:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726069AbgHHUsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Aug 2020 16:48:10 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16229C061756
        for <netdev@vger.kernel.org>; Sat,  8 Aug 2020 13:48:09 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id i19so2765911lfj.8
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 13:48:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CiZLddQIxJOKky65wgscY6f1yEBwf6vf15egbeCHIho=;
        b=IWrVw6JbJfmA3YzWKBYBdvyHAIOh2WLoX3nrDXi++/s27zJg+fkFAvZs7iG+JbKD5j
         UMs1FfbddFvoR1vr4pYS8hHSaGQ1tGZJdJkYAlYyqXaGI199GGeJnEqq4u9mBs1MC2+i
         80+aFCxYp4c2zlCnnIz8JnWj8lSfTQyu55k20=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CiZLddQIxJOKky65wgscY6f1yEBwf6vf15egbeCHIho=;
        b=oYtOjQPmbpXRXwovn5N4quLxqok2cVfvn5ltgxz8j9Tk/sPbIswcthqVJ5G1yTSTnc
         OA5q98GdSzKEkcjNcKMO34BAowro+nZiIUWMfFysQYcZXrkoZjh4Llun//SL83LAZpm9
         1K9ODH5MeGCd7gLSK+xx8PuLtTGevM8KwJSHfMQJvBeB8NTMXA+Fq8gzryrnXDBN5C+a
         kURj7u+NutrcVILPP0kVcPKMYj88QQLzQvCG7TDSQEA30B8pPdLM8KrMbZ6iW4cMO4ND
         qOZqQwfDwcl/67lLsy4AYJ7X8Ni4tM4mWrmjSTQ11ZeUofdwDbV59YF9RHXOrpNWx/V3
         Oxbg==
X-Gm-Message-State: AOAM533PAEJef73+rC/XQ/WqqtRDdDdzX4W5j1Z6rOgvgZKEXXbYLZ11
        1XLzKrgti3lylRAYqdch0HB52oF24DQ=
X-Google-Smtp-Source: ABdhPJwtrlK7IPEvRV2XKipYXAPhrbQnNccy3XcavTW8uuaIV+Dd8wnojD8eiYv4BYttwNv8T/kHBg==
X-Received: by 2002:a19:428c:: with SMTP id p134mr9439936lfa.70.1596919687376;
        Sat, 08 Aug 2020 13:48:07 -0700 (PDT)
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com. [209.85.208.173])
        by smtp.gmail.com with ESMTPSA id s22sm5564307lji.122.2020.08.08.13.48.06
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2020 13:48:06 -0700 (PDT)
Received: by mail-lj1-f173.google.com with SMTP id t6so5684679ljk.9
        for <netdev@vger.kernel.org>; Sat, 08 Aug 2020 13:48:06 -0700 (PDT)
X-Received: by 2002:a2e:b008:: with SMTP id y8mr7911781ljk.421.1596919685994;
 Sat, 08 Aug 2020 13:48:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200808152628.GA27941@SDF.ORG> <20200808174451.GA7429@1wt.eu> <20200808200818.GC27941@SDF.ORG>
In-Reply-To: <20200808200818.GC27941@SDF.ORG>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 8 Aug 2020 13:47:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh2qG7Brjn=54RV-8sDtWuZmWqokYCSvzUt+sF7ESb-TQ@mail.gmail.com>
Message-ID: <CAHk-=wh2qG7Brjn=54RV-8sDtWuZmWqokYCSvzUt+sF7ESb-TQ@mail.gmail.com>
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

On Sat, Aug 8, 2020 at 1:08 PM George Spelvin <lkml@sdf.org> wrote:
>
> So assuming that once per interrupt equals "often" is completely false.

That's not what people are assuming.

They are assuming it's "unpredictable".

Guys, look up the real and true meaning of "random" some day.

Guess what? It at no point says "secure hash".

> Not to mention that the generators are per-CPU, and the CPU gnerating the
> random numbers might not be the one getting what few interrupts there are.
> (It's quite common in networking applications to bind network interrupts
> and application logic to separate CPUs.)

.. which is exactly why the commit that introduced this _also_ does
things from timer interrupts.

And yes. We know.Timer interrupts are turned off when there's nothing going on.

But the sending side - if it's not responding to an interrupt -
explicitly does have something going on, so you actually end up having
timer interrupts.

And yes, both IP and the TSC are "predictable". In theory. Not in
reality, and particularly not remotely.

And again, we knew - and discussed - interrupts coalescing and not
happening under load.

And again - that's a completely specious and pointless argument.

If you can put a machine under such load that it goes into polling
mode _and_ you also control _all_ the network traffic to such an
extent that other actors don't matter, and you get all the data out
and can analyze it to the point of trying to figure out what the prng
internal buffers are, you are basically already on the same network
and are controlling the machine.

It's not an interesting attack, in other words.

I repeat: reality matters. Your theoretical arguments are irrelevant,
because they simply don't even apply.

Btw, don't get me wrong - I think we can improve on the actual hashing
on the prng too. But I'm not backing down on the whole "we need noise
too, and the noise is actually more important".

> This whole bit of logic just seems ridiculously fragile to me.

No, what is fragile is assuming that you can have a random number
generator that is an analyzable secure hash, and then expecting that
to be high-performance and unpredictable.

We can do both. I'm _hoping_ people can come up with a
high-performance hash that is better than what we have. But there was
absolutely nothing going on for months after the last report, and even
with a better high-performance hash, I will absolutely refuse to get
rid of the noise factor.

           Linus
