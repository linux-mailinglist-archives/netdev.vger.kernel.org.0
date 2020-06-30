Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D534E20FF8C
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgF3Vyx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgF3Vyx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:54:53 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA9D3C03E979
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:54:52 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id k18so10843798ybm.13
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 14:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TH9ubu+kB9wsPTPtDqtZV/d7ZAkRM6RQc2M+/0BpphA=;
        b=TVEfKY2GaQrYrQAhznDmdCfFbFwwH3JVS94HwR4ejRRgUn9JqaLe/78BCO/n2zarw1
         +TIxvdlSHL9+n9XZPzN/g7WfHSH1aCx0txqYZGIFoRV2So10mEyFqosPHpfdk18dkiag
         rClNDqXs3xsBqx1yFcd6+QRT7gDWl6djfWuQrPNURGp8cbh49bXKMROozbrFI+zYTryo
         mx7sNVeeV+zXMCCWwDaG80VYj1AlZTw4MOWo8UIjSqmKEOr5E4D8h1bhapPV2Wgoq0c3
         f/jnYtLTMCRxwscNgPxbfnPthBCHZOy5IW82bL8oQXxHGgLEGs02NqKhmw4mPlyx3nLm
         2mxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TH9ubu+kB9wsPTPtDqtZV/d7ZAkRM6RQc2M+/0BpphA=;
        b=On3Qb+apxXNj4XHIFq8bUJ7uSRzXcb7UpKWLly87Julpuzg/M/lF4tqv6kT35G9uT9
         aGV1bO6cOCOs3ygcLNOnQIRQWKgK9l5CMtr3RyOyW8ydpnQGMHN9s/SNu7NmmApPkC+7
         lzilHhTG1/BP4UaNmR9/THV5Oq6RmuLQchq14oWkOfH4H+xyZE+KQotP66gZfLgP7vL9
         uNzB+fbeuw/FNNLx4IVKkIk9Kc2NUIc4AG60DhHscOrlc55H2oQ+0eAEZVtJ1jwKst99
         y3DbBpjKwlFNQ61XT6MZei9fDI2mCgWpdcp3qmI0OABNfn7jTuM8VucCRhPcyee89uw8
         ttFw==
X-Gm-Message-State: AOAM531luvrixHaKtPj8CztZmnc/Ay95jwPMIjeAGAPgktsNeZWBGFsS
        GpChySNlo24JC8ah2GG+JPCLfCaT/5bYau+3ontMEuWzzyg=
X-Google-Smtp-Source: ABdhPJx0QewOsXXt+xoZ8GRTUhvJ7bamXa0BvWObRv+ayRxJXZnIPyR8ZEUED3+FIhoRVsguFP0cIO7Cu/NBC4x0rhk=
X-Received: by 2002:a25:81c2:: with SMTP id n2mr14682053ybm.520.1593554091451;
 Tue, 30 Jun 2020 14:54:51 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wjEghg5_pX_GhNP+BfcUK6CRZ+4mh3bciitm9JwXvR7aQ@mail.gmail.com>
 <312079189.17903.1593549293094.JavaMail.zimbra@efficios.com>
 <CANn89iJ+rkMrLrHrKXO-57frXNb32epB93LYLRuHX00uWc-0Uw@mail.gmail.com>
 <20200630.134429.1590957032456466647.davem@davemloft.net> <CANn89i+b-LeaPvaaHvj0yc0mJ2qwZ0981fQHVp0+sqXYp=kdkA@mail.gmail.com>
 <474095696.17969.1593551866537.JavaMail.zimbra@efficios.com> <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com>
In-Reply-To: <CANn89iKK2+pznYZoKZzdCu4qkA7BjJZFqc6ABof4iaS-T-9_aw@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 30 Jun 2020 14:54:39 -0700
Message-ID: <CANn89i+_DUrKROb1Zkk_nmngkD=oy9UjbxwnkgyzGB=z+SKg3g@mail.gmail.com>
Subject: Re: [regression] TCP_MD5SIG on established sockets
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Jonathan Rajotte-Julien <joraj@efficios.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 2:23 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 30, 2020 at 2:17 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > ----- On Jun 30, 2020, at 4:56 PM, Eric Dumazet edumazet@google.com wrote:
> >
> > > On Tue, Jun 30, 2020 at 1:44 PM David Miller <davem@davemloft.net> wrote:
> > >>
> > >> From: Eric Dumazet <edumazet@google.com>
> > >> Date: Tue, 30 Jun 2020 13:39:27 -0700
> > >>
> > >> > The (C) & (B) case are certainly doable.
> > >> >
> > >> > A) case is more complex, I have no idea of breakages of various TCP
> > >> > stacks if a flow got SACK
> > >> > at some point (in 3WHS) but suddenly becomes Reno.
> > >>
> > >> I agree that C and B are the easiest to implement without having to
> > >> add complicated code to handle various negotiated TCP option
> > >> scenerios.
> > >>
> > >> It does seem to be that some entities do A, or did I misread your
> > >> behavioral analysis of various implementations Mathieu?
> > >>
> > >> Thanks.
> > >
> > > Yes, another question about Mathieu cases is do determine the behavior
> > > of all these stacks vs :
> > > SACK option
> > > TCP TS option.
> >
> > I will ask my customer's networking team to investigate these behaviors,
> > which will allow me to prepare a thorough reply to the questions raised
> > by Eric and David. I expect to have an answer within 2-3 weeks at most.
> >
> > Thank you!
>
>
> Great, I am working on adding back support for (B) & (C) by the end of
> this week.

Note that the security issue (of sending uninit bytes to the wire) has
been independently fixed with [1]

This means syzbot was able to have MD5+TS+SACK  ~6 months ago.

It seems we (linux) do not enable this combination for PASSIVE flows,
(according to tcp_synack_options()),
but  for ACTIVE flows we do nothing special.

So maybe code in tcp_synack_options() should be mirrored to
tcp_syn_options() for consistency.
(disabling TS if  both MD5 and SACK are enabled)

[1]

commit 9424e2e7ad93ffffa88f882c9bc5023570904b55
Author: Eric Dumazet <edumazet@google.com>
Date:   Thu Dec 5 10:10:15 2019 -0800

    tcp: md5: fix potential overestimation of TCP option space

    Back in 2008, Adam Langley fixed the corner case of packets for flows
    having all of the following options : MD5 TS SACK

    Since MD5 needs 20 bytes, and TS needs 12 bytes, no sack block
    can be cooked from the remaining 8 bytes.

    tcp_established_options() correctly sets opts->num_sack_blocks
    to zero, but returns 36 instead of 32.

    This means TCP cooks packets with 4 extra bytes at the end
    of options, containing unitialized bytes.

    Fixes: 33ad798c924b ("tcp: options clean up")
    Signed-off-by: Eric Dumazet <edumazet@google.com>
    Reported-by: syzbot <syzkaller@googlegroups.com>
    Acked-by: Neal Cardwell <ncardwell@google.com>
    Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index be6d22b8190fa375074062032105879270af4be5..b184f03d743715ef4b2d166ceae651529be77953
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -755,8 +755,9 @@ static unsigned int tcp_established_options(struct
sock *sk, struct sk_buff *skb
                        min_t(unsigned int, eff_sacks,
                              (remaining - TCPOLEN_SACK_BASE_ALIGNED) /
                              TCPOLEN_SACK_PERBLOCK);
-               size += TCPOLEN_SACK_BASE_ALIGNED +
-                       opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
+               if (likely(opts->num_sack_blocks))
+                       size += TCPOLEN_SACK_BASE_ALIGNED +
+                               opts->num_sack_blocks * TCPOLEN_SACK_PERBLOCK;
        }

        return size;
