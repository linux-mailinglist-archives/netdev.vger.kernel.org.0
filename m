Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05B049A48C
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 03:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2375118AbiAYATX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 19:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455377AbiAXVfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 16:35:19 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07F99C0604F1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:22:11 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id 23so54972160ybf.7
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 12:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xwfv9DWhnbqAeBe0vZuMaEEqHhzX/GAvJYcdU/hIEU0=;
        b=YZEjc5XgddEOMDEFMbA/nfERNSKDAvksKW3MccXgk/muQB+YDP3EGqR5R99SaGgsy+
         tYmN3BspZJWCVNOVtpRcR2yhuqOUS/dTMJ8qhEWo4Q3s+mOiZv/gDoglKXWncm11J4iV
         Hk9DtYMbaYEE1kWvPRVZHw8IKZ8efE2Wiw37iUO0+X/Anbte97vcnN3h8JgZxjeN0ZX2
         rTQ9Uk6paf1BFgq62wq4y5JIew3/PMaHiXBpAWT70gQrG6ZPwfcnCx8lh84GqjA/fFBe
         +SNnIEPlX9wqhIFaYCEziDHQ31p7qhGLgsZidM8UR5q9UUe9PoOilL7zPvj8xz1H6m4E
         k4TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xwfv9DWhnbqAeBe0vZuMaEEqHhzX/GAvJYcdU/hIEU0=;
        b=bPJlew3TObEtyuEwCoXWkCW2k7ypz6XXZbwazjpkV4LCzGY3zxKUv6NP2hgE01TYCu
         4CcHv75sYso2KzQhCnKx2K7GUKSlRHUDKkYoXkoAeHYvIqxW/XfZ9nTYZqRoYQPbiSUd
         LVJjRwjWWg3GP0EvqAQYiEHW0Zk5Z8bOJU9VNuhmTw+Zets6MboriKG37QTUdt+KGf+c
         ciFOJSZ8Uyr5WBhO1oR04zLDc1Y9o4mAnhnozwTw0+JbQtbvOpJfGnDQoJXWTM9A9Wgq
         adohHEesiAk5HeRAlOF4AYdHM5ntG4nOLk46B1zd7PSinMxyl2DOU0+cWXsxXXueqVyC
         AbXw==
X-Gm-Message-State: AOAM531OhhYFcVVQj1VoH78LG2nfG1aM2p4ncNUrmtX6NTL9kqMFfqKu
        f054gFVt1UUJ7CdAQxJ0YGSOhBZBvZcAiYSsniRfoQ==
X-Google-Smtp-Source: ABdhPJwtXciBq3Wt7irMaN1ndtqX+rq+qAoM2WB1evkKx4m1jVtS4txslowHDJwEVGu27cYpbSFGUCQZpRE6GcjSn9w=
X-Received: by 2002:a25:9d82:: with SMTP id v2mr24635936ybp.383.1643055729748;
 Mon, 24 Jan 2022 12:22:09 -0800 (PST)
MIME-Version: 1.0
References: <20220122000301.1872828-1-jeffreyji@google.com>
 <20220121194057.17079951@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAMzD94QW5uK2wAZfYWu5J=2HqCcLrT=y7u6+0PgJvHBb0YTz_Q@mail.gmail.com>
 <20220124092924.0eb17027@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net> <Ye8J7rMiiTwNNA6T@pop-os.localdomain>
In-Reply-To: <Ye8J7rMiiTwNNA6T@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 24 Jan 2022 12:21:58 -0800
Message-ID: <CANn89iJKcKKLEXWELakScxxe8f0z1GQjmtA2UrBhqOEXQkk+9A@mail.gmail.com>
Subject: Re: [PATCH net-next] net-core: add InMacErrors counter
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Brian Vazquez <brianvv@google.com>,
        Jeffrey Ji <jeffreyjilinux@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, jeffreyji <jeffreyji@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 12:20 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Jan 24, 2022 at 09:29:24AM -0800, Jakub Kicinski wrote:
> > On Mon, 24 Jan 2022 09:13:12 -0800 Brian Vazquez wrote:
> > > On Fri, Jan 21, 2022 at 7:41 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > > On Sat, 22 Jan 2022 00:03:01 +0000 Jeffrey Ji wrote:
> > > > > From: jeffreyji <jeffreyji@google.com>
> > > > >
> > > > > Increment InMacErrors counter when packet dropped due to incorrect dest
> > > > > MAC addr.
> > > > >
> > > > > example output from nstat:
> > > > > \~# nstat -z "*InMac*"
> > > > > \#kernel
> > > > > Ip6InMacErrors                  0                  0.0
> > > > > IpExtInMacErrors                1                  0.0
> > > > >
> > > > > Tested: Created 2 netns, sent 1 packet using trafgen from 1 to the other
> > > > > with "{eth(daddr=$INCORRECT_MAC...}", verified that nstat showed the
> > > > > counter was incremented.
> > > > >
> > > > > Signed-off-by: jeffreyji <jeffreyji@google.com>
> > > >
> > > > How about we use the new kfree_skb_reason() instead to avoid allocating
> > > > per-netns memory the stats?
> > >
> > > I'm not too familiar with the new kfree_skb_reason , but my
> > > understanding is that it needs either the drop_monitor  or ebpf to get
> > > the reason from the tracepoint, right? This is not too different from
> > > using perf tool to find where the pkt is being dropped.
> > >
> > > The idea here was to have a high level metric that is easier to find
> > > for users that have less expertise on using more advance tools.
> >
> > That much it's understood, but it's a trade off. This drop point
> > existed for 20 years, why do we need to consume extra memory now?
>
> kfree_skb_reason() is for tracing and tracing has overhead in
> production, which is higher than just a percpu counter.
>
> What memory overhead are you talking about? We have ~37 IP related
> SNMP counters, this patch merely adds 1/37 memory overhead. So, what's the
> point? :-/
>

BTW I just saw that kfree_skb_reason() changes have been proposed
already by Menglong Dong this morning.
