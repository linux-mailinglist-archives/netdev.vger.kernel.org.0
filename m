Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EECC524AF78
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 08:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725824AbgHTG6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 02:58:52 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:40524 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgHTG6v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Aug 2020 02:58:51 -0400
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 07K6wc2V021541;
        Thu, 20 Aug 2020 08:58:38 +0200
Date:   Thu, 20 Aug 2020 08:58:38 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>, George Spelvin <lkml@sdf.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Amit Klein <aksecurity@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, netdev@vger.kernel.org
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
Message-ID: <20200820065838.GB21526@1wt.eu>
References: <20200813080646.GB10907@1wt.eu>
 <CA+icZUW8oD6BLnyFUzXHS8fFciLaLQAZnus7GgUdCuSZcMg+MQ@mail.gmail.com>
 <20200814160551.GA11657@1wt.eu>
 <CA+icZUUVv9DYJHr79FnDcd57QCtXKmzEkt1cYvQ1DT8j1G19Ng@mail.gmail.com>
 <20200816150133.GA17475@1wt.eu>
 <CA+icZUW9+iEd8wssWmt9M5bhuLyRDMvTGSmJxvJ4qeQ8o78bPQ@mail.gmail.com>
 <CA+icZUUSQGTbfMCUo9JyAZ_FZzvF98v06pRgH+6iMqgVUYijdQ@mail.gmail.com>
 <20200820043323.GA21461@1wt.eu>
 <CA+icZUXV21ZYzcM_rcKfd3pQ56KYueMQ=YKaVc-QEL7Duf2v-A@mail.gmail.com>
 <20200820060843.GA21526@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820060843.GA21526@1wt.eu>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 08:08:43AM +0200, Willy Tarreau wrote:
> On Thu, Aug 20, 2020 at 06:42:23AM +0200, Sedat Dilek wrote:
> > On Thu, Aug 20, 2020 at 6:33 AM Willy Tarreau <w@1wt.eu> wrote:
> > >
> > > On Thu, Aug 20, 2020 at 05:05:49AM +0200, Sedat Dilek wrote:
> > > > We have the same defines for K0 and K1 in include/linux/prandom.h and
> > > > lib/random32.c?
> > > > More room for simplifications?
> > >
> > > Definitely, I'm not surprized at all. As I said, the purpose was to
> > > discuss around the proposal, not much more. If we think it's the way
> > > to go, some major lifting is required. I just don't want to invest
> > > significant time on this if nobody cares.
> > >
> > 
> > OK.
> > 
> > Right now, I will try with the attached diff.
> 
> No, don't waste your time this way, it's not the right way to address it,
> you're still facing competition between defines. I'll do another one if
> you want to go further in the tests.

I've just pushed a new branch "20200820-siphash-noise" that I also
rebased onto latest master. It's currently running make allmodconfig
here, so that will take a while, but I think it's OK as random32.o is
already OK. I've also addressed a strange build issue caused by having
an array instead of 4 ints in siprand_state.

Please just let me know if that's OK for you now.

Thanks,
Willy
