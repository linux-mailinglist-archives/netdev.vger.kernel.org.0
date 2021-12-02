Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E67466AD5
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348753AbhLBUWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:22:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235095AbhLBUWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:22:53 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5FDC06174A;
        Thu,  2 Dec 2021 12:19:31 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b11so501057pld.12;
        Thu, 02 Dec 2021 12:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EZyJYJGDiU9aKpyBczLv1xRZG/LkexDA2FqwX44VCAM=;
        b=SBmk8vku3Nle/xiZM+Y7yBU8eKxHyoFJVTeABCRA51m1JnxPVovLBWj3uThFliSkll
         2btIwOZuM0nBBKSBByl73odrP3zidi5MTg/xfDuDNOFaaChdA3AQc4b0B2ohMwq1vLwv
         2QUTs1QLxvP2BVjzsztwShPgCvnfcKs1lbsN1fDzR9ovyFtVHyyM2Cc6ywjN4rOvs9qv
         hpCbqNMukcgleu7V4WPfotDSnP07ZSf6oM4y0xHX4aKotj4MXBNdQ/Mt6BjS8t6RCV0v
         kHQAFDtkdYKpG94g8X8Bbikju2h6B/2XMMVjXoWYUP87BXmHkoBez8yOfw6Qmjx2ljqb
         ItaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EZyJYJGDiU9aKpyBczLv1xRZG/LkexDA2FqwX44VCAM=;
        b=ueSYXvCX27Qq0Z8i3kPTtz3G+fiaLgF/u8414gDYq+k99dwcjXGEk/jbHIjea6afdb
         w20QM1sYoZcJef3Jf0LY92BEkqozGUIkqBIPByqEOYh5F0Ndnss1VYdBKZTsHJ+M/x6A
         CoFvfbuNmNrkzgkFF/GWTEU7tZ9J4OSS2HDYqq5GNAV1bzrjmBWSdRYDkDlOF+M71LhG
         FfaQhz2jOe7obVNJJ3Hbs58BS7FLTfNE9rCfbnsNvRkaTwHH57WrNFrVMH3jzXwFZrIn
         L90mWzjoUxzHVdQ8s4g78ep1lnmvy9ycb3Lkq8jkN/qxu6mYvKeKxzSv2+1fXOHlqObt
         4+Hw==
X-Gm-Message-State: AOAM5310Yv2Z/QJ9315sbWoLj5H5dipxm2gh+pCZpu1UuXgFcLSxdLUf
        VadN69kbBqLrqELvkBLMsout9RHxiN7tQ3zTKSc=
X-Google-Smtp-Source: ABdhPJwpJOfg8iRFGqhbc7DMWiH3xS7W842CCQOTVqBCazcIAFXk5W6AmCe0joYoZh7cWSkvJ5m5a9NObL9koqYFfE4=
X-Received: by 2002:a17:90b:1892:: with SMTP id mn18mr8464878pjb.178.1638476370639;
 Thu, 02 Dec 2021 12:19:30 -0800 (PST)
MIME-Version: 1.0
References: <20211125193852.3617-1-goldstein.w.n@gmail.com>
 <CANn89iLnH5B11CtzZ14nMFP7b--7aOfnQqgmsER+NYNzvnVurQ@mail.gmail.com>
 <CAFUsyfK-znRWJN7FTMdJaDTd45DgtBQ9ckKGyh8qYqn0eFMMFA@mail.gmail.com>
 <CAFUsyfLKqonuKAh4k2qdBa24H1wQtR5FkAmmtXQGBpyizi6xvQ@mail.gmail.com>
 <CAFUsyfJ619Jx_BS515Se0V_zRdypOg3_2YzbKUk5zDBNaixhaQ@mail.gmail.com>
 <8e4961ae0cf04a5ca4dffdec7da2e57b@AcuMS.aculab.com> <CAFUsyfLoEckBrnYKUgqWC7AJPTBDfarjBOgBvtK7eGVZj9muYQ@mail.gmail.com>
 <29cf408370b749069f3b395781fe434c@AcuMS.aculab.com> <CANn89iJgNie40sGqAyJ8CM3yKNqRXGGPkMtTPwXQ4S_9jVspgw@mail.gmail.com>
In-Reply-To: <CANn89iJgNie40sGqAyJ8CM3yKNqRXGGPkMtTPwXQ4S_9jVspgw@mail.gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Thu, 2 Dec 2021 14:19:19 -0600
Message-ID: <CAFUsyfJticWKb3fv12r5L5QZ0AVxytWqtPVkYKeFYLW3K1SMNw@mail.gmail.com>
Subject: Re: [PATCH v1] x86/lib: Optimize 8x loop and memory clobbers in csum_partial.c
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Laight <David.Laight@aculab.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        X86 ML <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "alexanderduyck@fb.com" <alexanderduyck@fb.com>,
        open list <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 9:01 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Dec 2, 2021 at 6:24 AM David Laight <David.Laight@aculab.com> wrote:
> >
> > I've dug out my test program and measured the performance of
> > various copied of the inner loop - usually 64 bytes/iteration.
> > Code is below.
> >
> > It uses the hardware performance counter to get the number of
> > clocks the inner loop takes.
> > This is reasonable stable once the branch predictor has settled down.
> > So the different in clocks between a 64 byte buffer and a 128 byte
> > buffer is the number of clocks for 64 bytes.

Intuitively 10 passes is a bit low. Also you might consider aligning
the `csum64` function and possibly the loops.

There a reason you put ` jrcxz` at the beginning of the loops instead
of the end?

> > (Unlike the TSC the pmc count doesn't depend on the cpu frequency.)
> >
> > What is interesting is that even some of the trivial loops appear
> > to be doing 16 bytes per clock for short buffers - which is impossible.
> > Checksum 1k bytes and you get an entirely different answer.
> > The only loop that really exceeds 8 bytes/clock for long buffers
> > is the adxc/adoc one.
> >
> > What is almost certainly happening is that all the memory reads and
> > the dependant add/adc instructions are all queued up in the 'out of
> > order' execution unit.
> > Since 'rdpmc' isn't a serialising instruction they can still be
> > outstanding when the function returns.
> > Uncomment the 'rdtsc' and you get much slower values for short buffers.

Maybe add an `lfence` before / after `csum64`
> >
> > When testing the full checksum function the queued up memory
> > reads and adc are probably running in parallel with the logic
> > that is handling lengths that aren't multiples of 64.
> >
> > I also found nothing consistently different for misaligned reads.
> >
> > These were all tested on my i7-7700 cpu.
> >
>
> I usually do not bother timing each call.
> I instead time a loop of 1,000,000,000 calls.
> Yes, this includes loop cost, but this is the same cost for all variants.
>    for (i = 0; i < 100*1000*1000; i++) {
>         res += csum_partial((void *)frame + 14 + 64*0, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*1, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*2, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*3, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*4, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*5, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*6, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*7, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*8, 40, 0);
>         res += csum_partial((void *)frame + 14 + 64*9, 40, 0);
>     }

+ 1. You can also feed `res` from previous iteration to the next
iteration to measure latency cheaply if that is better
predictor of performance.

>
> Then use " perf stat ./bench"   or similar.
