Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FA9244C8B
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 18:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728231AbgHNQSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 12:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726455AbgHNQSJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 12:18:09 -0400
Received: from mail-oo1-xc41.google.com (mail-oo1-xc41.google.com [IPv6:2607:f8b0:4864:20::c41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649A6C061384
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:18:09 -0700 (PDT)
Received: by mail-oo1-xc41.google.com with SMTP id g1so2020060oop.11
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 09:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=oKMvLoZEjavo9ItRvF2YFXgnZ3YMl3lg1q8IBdZcyBw=;
        b=YvaLWtIM1l6sqEBDdBbgUCU5yzrO2sNC0i8wwFuBDHinngc4oXuKNPDo/+07g9mVbZ
         Ryi9qwBfc65/Pc1po6UllPWvPpHC6J7YzsBDqU/DQLgWzoF7BMss9B/1slsOl26GsjcS
         A7XQynOmJeI38PQI1hZBnk+3JvuYCLgJRy1EwNYuaBKu1lty1oyIJV8syoGTevdmWBw7
         3znrjS8Vc1e4Agd/OQ/RmlRoUzW1jpGFFq9DU7djFhXMhWs6mdi9Qrnwpx+4hlMYH59K
         8xDCP7I9fbJTVg1JRdGl7xiU/dQob1YkTBORx5SNvHInwo6X+CQVQYVGL/zXuzVeDu2g
         9uyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=oKMvLoZEjavo9ItRvF2YFXgnZ3YMl3lg1q8IBdZcyBw=;
        b=WZdBqqH3AzhR6HG4RBkN2EHHnxXN4TiaPe3KrM28XgGNC4U/+A04/Wuc7iz1ie9n8x
         4VAtgZL/c05iwYfMryyxvCKh4qIVl3KJLfRTDkzBvrxFDdLgJaxD04yEmK/UMdK4w3Zd
         XP8zCWnSfQ6Q+jJfL6gCr/0RZefxvAJCzea3i5z5cHsu6ZIF6xCZ0LCj0vODslpnWHCH
         7nFy6vz4FyslJEmLEau7FIEOzB5cXYNRNJkq20mu0af5rJqJGFpY0oituUeHuGIrLxoU
         em/bVMk96dK+4QH+NVAi2AoBijwmwbDl2JufTkSNvMfCPkCLYXj1or8HXYyo0cU7D7jL
         KvNQ==
X-Gm-Message-State: AOAM531bzztGQk9JBb54tTbb8jEBxz3URJdJkzXDjFEEqEP6bYbKgn25
        r1bLLA1Ssw3TmSTpAoxYIbSNAe0erih9Str1/bI=
X-Google-Smtp-Source: ABdhPJziy/uurfjfN8EE1DF6KQPUpobqBxkCkrMz5trXLeEVUUDAeEeXWMEJBQW4h9dUnQCGbLoBKI7g6T0O0kOg1c0=
X-Received: by 2002:a4a:4594:: with SMTP id y142mr2226186ooa.24.1597421887663;
 Fri, 14 Aug 2020 09:18:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200810034948.GB8262@1wt.eu> <20200811053455.GH25124@SDF.ORG>
 <20200811054328.GD9456@1wt.eu> <20200811062814.GI25124@SDF.ORG>
 <20200811074538.GA9523@1wt.eu> <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
 <20200812032139.GA10119@1wt.eu> <CA+icZUXS2OPFuEkDC2oHDd344efkbAoq_oP0agqrvWD5FHDXGA@mail.gmail.com>
 <20200813080646.GB10907@1wt.eu> <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu>
In-Reply-To: <20200814160551.GA11657@1wt.eu>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Fri, 14 Aug 2020 18:17:56 +0200
Message-ID: <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 14, 2020 at 6:05 PM Willy Tarreau <w@1wt.eu> wrote:
>
> On Fri, Aug 14, 2020 at 05:32:32PM +0200, Sedat Dilek wrote:
> > commit 94c7eb54c4b8e81618ec79f414fe1ca5767f9720
> > "random32: add a tracepoint for prandom_u32()"
> >
> > ...I gave Willy's patches a try and used the Linux Test Project (LTP)
> > for testing.
>
> Just FWIW today I could run several relevant tests with a 40 Gbps NIC
> at high connection rates and under SYN flood to stress SYN cookies.
> I couldn't post earlier due to a net outage but will post the results
> here. In short, what I'm seeing is very good. The only thing is that
> the noise collection as-is with the 4 longs takes a bit too much CPU
> (0.2% measured) but if keeping only one word we're back to tausworthe
> performance, while using siphash all along.
>
> The noise generation function is so small that we're wasting cycles
> calling it and renaming registers. I'll run one more test by inlining
> it and exporting the noise.
>
> So provided quite some cleanup now, I really think we're about to
> reach a solution which will satisfy everyone. More on this after I
> extract the results.
>

Great news!

Will you publish your new version in [1]?

- Sedat -

[1] https://git.kernel.org/pub/scm/linux/kernel/git/wtarreau/cleanups.git/
