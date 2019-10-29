Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC56EE8F57
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 19:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfJ2Sdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 14:33:41 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:44554 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfJ2Sdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 14:33:41 -0400
Received: by mail-yw1-f65.google.com with SMTP id i123so5418322ywe.11
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 11:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d85NgvjbmkMJe1UdCgj8/nRnPQF4ABbhqPnP7a2epzc=;
        b=jA4mjXrfaHIjcArCUYB2Cd4sSFdHdb0rd8cxCfR1YnxDMTTs7b/fqB7Kqkb1FdIUvR
         wJXoMm0gAUdYaFv+pmXtBLfw7PTVg3qBpadtuZFOhyj2YGZv+Iy3YBQz6aF4N694jrAr
         pFUnJu6YK8J1GoqBCN+ijWt/W0fhgFZm550J26HVW7u7qwSH88UTyFFoRl8qEbPvjINp
         6N894Ki23GxFtxcYI1Nz0CR2fdaTruZunWnPkHWATvvf70Cng06+pJvzbLm9lnkPUSIU
         n6FLtAKF/eVLZDDOhFRzlutDpaYc3KEdU9LBRuMb6Bg+uxjVrdGalIJbEdl3HYXMK8Nq
         zkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d85NgvjbmkMJe1UdCgj8/nRnPQF4ABbhqPnP7a2epzc=;
        b=dVxaU4VmvSF/ZSOVjpJR5UtrKEiIs1yVNoc6DpmLtx8fasrlH2rFTB/ODWpB0O4VIo
         LmwCQOVcgSiMINpNF3UqDiLp1UfT1j+lXNvxt5oDElRiK6In9yfVh+3zxpXVt6SluTlf
         Ygo1wLGhhcuINqrYPtlHzngEONtAsrmVZeWQD8Utf2YYz42h3wofHntu0Qxb8ClAmoWc
         OOvTpM1KaCQCiKolR/yD8zif0qjUBU2y6ozTDSFpbj5KmQbEaewFd5AkaKLHDdv71B6P
         qb6vSn5f8QCgMwCO4n2dnL9nLeOENqeKwo39DVkOvSAJM5LX0Ho5H6KG1IUKWfpFtOVW
         qtTw==
X-Gm-Message-State: APjAAAV7gqA/MBMIAK2+sr3DdocRK3OcpnTDugrfsTRhTTb4kfBEQTGt
        JxbKsjqzHtcBMjHUE9g2sk6mVa+x2/GXRwFFlgwTdA==
X-Google-Smtp-Source: APXvYqyN9S3+r6W8yQsRPP1DV+KXLV7E7sl9KV3UsvmoJn5fEICDvKUSVt9WTO62x9T9dnVvOr0taJIwsHtk53ywb54=
X-Received: by 2002:a81:4986:: with SMTP id w128mr19144145ywa.114.1572374019372;
 Tue, 29 Oct 2019 11:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <CABWYdi1QmrHxNZT_DK4A2WUoj=r1+wxSngzaaTuGCatHisaTRw@mail.gmail.com>
 <CANn89iLE-3zxROxGOusPBRmQL4oN2Nqtg3rqXnpO8bkiFAw8EQ@mail.gmail.com> <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
In-Reply-To: <CABWYdi2Eq30vEKKYxr-diofpeATNXiB3ZYKL6Q15y10w+vsCLg@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 29 Oct 2019 11:33:27 -0700
Message-ID: <CANn89iJYKurw-3-EooE9qyM8-2MzQvCz8qdV91J1hVNxXwsyng@mail.gmail.com>
Subject: Re: fq dropping packets between vlan and ethernet interfaces
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 11:31 AM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> I'm on 5.4-rc5. Let me apply e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5
> on top and report back to you.


Oops, wrong copy/paste. I really meant this one :

9669fffc1415bb0c30e5d2ec98a8e1c3a418cb9c net: ensure correct
skb->tstamp in various fragmenters


>
> On Tue, Oct 29, 2019 at 11:27 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Oct 29, 2019 at 11:20 AM Ivan Babrou <ivan@cloudflare.com> wrote:
> > >
> > > Hello,
> > >
> > > We're trying to test Linux 5.4 early and hit an issue with FQ.
> > >
> > > The relevant part of our network setup involves four interfaces:
> > >
> > > * ext0 (ethernet, internet facing)
> > > * vlan101@ext0 (vlan)
> > > * int0 (ethernet, lan facing)
> > > * vlan11@int0 (vlan)
> > >
> > > Both int0 and ext0 have fq on them:
> > >
> > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > >
> > > The issue itself is that after some time ext0 stops feeding off
> > > vlan101, which is visible as tcpdump not seeing packets on ext0, while
> > > they flow over vlan101.
> > >
> > > I can see that fq_dequeue does not report any packets:
> > >
> > > $ sudo perf record -e qdisc:qdisc_dequeue -aR sleep 1
> > > hping3 40335 [006] 63920.881016: qdisc:qdisc_dequeue: dequeue
> > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > packets=0 skbaddr=(nil)
> > > hping3 40335 [006] 63920.881030: qdisc:qdisc_dequeue: dequeue
> > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > packets=0 skbaddr=(nil)
> > > hping3 40335 [006] 63920.881041: qdisc:qdisc_dequeue: dequeue
> > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > packets=0 skbaddr=(nil)
> > > hping3 40335 [006] 63920.881070: qdisc:qdisc_dequeue: dequeue
> > > ifindex=4 qdisc handle=0x10000 parent=0xFFFFFFFF txq_state=0x0
> > > packets=0 skbaddr=(nil)
> > >
> > > Inside of fq_dequeue I'm able to see that we throw away packets in here:
> > >
> > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L510
> > >
> > > The output of tc -s qdisc shows the following:
> > >
> > > qdisc fq 1: dev ext0 root refcnt 65 limit 10000p flow_limit 100p
> > > buckets 1024 orphan_mask 1023 quantum 3228 initial_quantum 16140
> > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > >  Sent 4872143400 bytes 8448638 pkt (dropped 201276670, overlimits 0
> > > requeues 103)
> > >  backlog 779376b 10000p requeues 103
> > >   2806 flows (2688 inactive, 118 throttled), next packet delay
> > > 1572240566653952889 ns
> > >   354201 gc, 0 highprio, 804560 throttled, 3919 ns latency, 19492 flows_plimit
> > > qdisc fq 8003: dev int0 root refcnt 65 limit 10000p flow_limit 100p
> > > buckets 1024 orphan_mask 1023 quantum 3028 initial_quantum 15140
> > > low_rate_threshold 550Kbit refill_delay 40.0ms
> > >  Sent 15869093876 bytes 17387110 pkt (dropped 0, overlimits 0 requeues 2817)
> > >  backlog 0b 0p requeues 2817
> > >   2047 flows (2035 inactive, 0 throttled)
> > >   225074 gc, 10 highprio, 102308 throttled, 7525 ns latency
> > >
> > > The key part here is probably that next packet delay for ext0 is the
> > > current unix timestamp in nanoseconds. Naturally, we see this code
> > > path being executed:
> > >
> > > * https://elixir.bootlin.com/linux/v5.4-rc2/source/net/sched/sch_fq.c#L462
> > >
> > > Unfortunately, I don't have a reliable reproduction for this issue. It
> > > appears naturally with some traffic and I can do limited tracing with
> > > perf and bcc tools while running hping3 to generate packets.
> > >
> > > The issue goes away if I replace fq with pfifo_fast on ext0.
> >
> > At which commit is your tree  precisely ?
> >
> > This sounds like the recent fix we had for fragmented packets.
> >
> > e7a409c3f46cb0dbc7bfd4f6f9421d53e92614a5 ipv4: fix IPSKB_FRAG_PMTU
> > handling with fragmentation
