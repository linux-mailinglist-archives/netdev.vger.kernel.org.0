Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4336A2E1BD2
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 12:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgLWL0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 06:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728376AbgLWL0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 06:26:16 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AEBC0613D3
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 03:25:35 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 143so14572609qke.10
        for <netdev@vger.kernel.org>; Wed, 23 Dec 2020 03:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mih3zdmMFaoRMuxqceFLQMdjm46eO32W/WpvGGFu29A=;
        b=Zju0KZKIMoE5gTdV4iSMFl27LmL9bQ/nJv7OmQVVioq/LiiYkYXxqe3sdhMMZOi4O9
         pP4NJ77XHbLvD3mwmJR9OgrfXV2wGUMdVEfm83FX45Kt+MKvwNQHgwWF8G0UycS9a41c
         nIut6/TlrtbYj3Gqd/78K6oOIGLh05cbkHZDAh0rgDawzcKXxF0/L/ieM7gXPA8NsedM
         Oh8CkljKfvI9M4AACY8hTbalqeNATI2ycuNlcRqsaKGkXdk287uhcasf7FERumCTByfz
         CKPkAMCpWH6qwssegTGS6BF2QYNVtpH1AmfjbMDRIMsxHi5E/MiVM+rMLQuqOdY+vbls
         +bQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mih3zdmMFaoRMuxqceFLQMdjm46eO32W/WpvGGFu29A=;
        b=B8TFyzP4U5rC07jrNU2aSpqJ6fwptyb8inlLiDwySuKtAh50TRMJyrxC7BHHSnt0qu
         1KgFfTRhPllQIxUJAUvPR7WnghOh7DEUhq0BXKVBe12oJ4IUJhAKFxatqyWsgYY8UaKd
         FfkpmPNqV9OCxVKAZSNH0bpDdjRZNvQs3AHW3P4wrEi6F3DGBnlUwJyGMgc9a7x/qEpf
         TPx3SYcMrLMrCUKMPEsqYhPoyKiQI+GJ2jM3T5eSf2frLQ1rsrFgf1/NSOsRkkBOw/jH
         ujrPFnVueXFChNDZ8PSbcgTDWz3CSOEEBrnAJ+6s4WGOuRmTkaC9RJK6zN0DCtdq7wIv
         eolg==
X-Gm-Message-State: AOAM533C58G0DiJtWwd2pXMWJXJUKCVn6+tFQNlzAHsEKBkNDC4dd7VJ
        eA70fpdvxk76C3thfjg8Tnl026+uNtRvqhVNmLMhvQ==
X-Google-Smtp-Source: ABdhPJyC6wxz1ef07cHlZ4ks61+5QGostwMFhtssMRDvHrjmIhcCBqZVeibY17JBLGIn6XWBHO5OiOBdoFjIWwBo2LE=
X-Received: by 2002:a37:4285:: with SMTP id p127mr9869581qka.501.1608722734822;
 Wed, 23 Dec 2020 03:25:34 -0800 (PST)
MIME-Version: 1.0
References: <000000000000fcbe0705b70e9bd9@google.com> <CAHk-=wgfRnXz0W3D37d01q3JFkr_i_uTL=V6A6G1oUZcprmknw@mail.gmail.com>
 <20201222220719.GB9639@breakpoint.cc>
In-Reply-To: <20201222220719.GB9639@breakpoint.cc>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Dec 2020 12:25:23 +0100
Message-ID: <CACT4Y+Z65uJgMETo-rpu0HbvbSOBRqO0+606UsvdGN=AxNQD+Q@mail.gmail.com>
Subject: Re: kernel BUG at lib/string.c:LINE! (6)
To:     Florian Westphal <fw@strlen.de>,
        syzkaller <syzkaller@googlegroups.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        syzbot <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Jakub Jelinek <jakub@redhat.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Peter Zijlstra <peterz@infradead.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 11:07 PM Florian Westphal <fw@strlen.de> wrote:
>
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> > On Tue, Dec 22, 2020 at 6:44 AM syzbot
> > <syzbot+e86f7c428c8c50db65b4@syzkaller.appspotmail.com> wrote:
> > >
> > > The issue was bisected to:
> > >
> > > commit 2f78788b55ba ("ilog2: improve ilog2 for constant arguments")
> >
> > That looks unlikely, although possibly some constant folding
> > improvement might make the fortify code notice something with it.
> >
> > > detected buffer overflow in strlen
> > > ------------[ cut here ]------------
> > > kernel BUG at lib/string.c:1149!
> > > Call Trace:
> > >  strlen include/linux/string.h:325 [inline]
> > >  strlcpy include/linux/string.h:348 [inline]
> > >  xt_rateest_tg_checkentry+0x2a5/0x6b0 net/netfilter/xt_RATEEST.c:143
> >
> > Honestly, this just looks like the traditional bug in "strlcpy()".
>
> Yes, thats exactly what this is, no idea why the bisection points
> at ilog2 changes.

The end result is usually clear from the bisection log:

> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1584f137500000

In this case it looks like the most common cause of diverted bisection
-- interference from other kernel bugs, this __queue_work issue that
happened on ilog2 commit:

[03f4935135b9efeb780b970ba023c201f81cf4e6] checkpatch: fix unescaped left brace
testing commit 03f4935135b9efeb780b970ba023c201f81cf4e6 with gcc (GCC) 8.1.0
all runs: crashed: kernel BUG at lib/string.c:LINE!
# git bisect bad 03f4935135b9efeb780b970ba023c201f81cf4e6

Bisecting: 21 revisions left to test after this (roughly 5 steps)
[2f78788b55baa3410b1ec91a576286abe1ad4d6a] ilog2: improve ilog2 for
constant arguments
testing commit 2f78788b55baa3410b1ec91a576286abe1ad4d6a with gcc (GCC) 8.1.0
run #0: crashed: WARNING in __queue_work
# git bisect bad 2f78788b55baa3410b1ec91a576286abe1ad4d6a




> > That BSD function is complete garbage, exactly because it doesn't
> > limit the source length. People tend to _think_ it does ("what's that
> > size_t argument for?") but strlcpy() only limits the *destination*
> > size, and the source is always read fully.
>
> Right, I'll send a patch shortly.
