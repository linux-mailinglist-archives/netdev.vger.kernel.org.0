Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11AF332E156
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 06:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbhCEFRs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 00:17:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhCEFRe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Mar 2021 00:17:34 -0500
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C78CC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 21:17:34 -0800 (PST)
Received: by mail-yb1-xb2a.google.com with SMTP id p193so675456yba.4
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 21:17:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=T/7R4sid3Y7iG7a2k4Nga3B3LKDvmOJialmJYrWpMjg=;
        b=Y8LxucOsCr/rCFcAMnYeYj0tdcQURNHJLbHdySzkBVD3yKgNqTaUWGZU1UhTH1pL9E
         oedJEcJt5f7G0MvoG9EFv60ElgeZPIJaFiiFNOZO3ki/FjtEP8G6MeuyEHCbJs9tLr7o
         TQsQCPkCWlVCYuW1GJWh/0CseyH6DjHm50WbRsp6jMSyDGz1unaOQxHzNtaJv3G64cw7
         fhatH3g16cemagj3qcrjcaFT6RMqifWbFpipJuJPHrYyepvtnwHXNSRC77r3SGHteesT
         HUQMMrUUPgTqihhVoIjT/5WLYuFu2WDpUe1VN4jLiMlIS6WY7lZcCLJLozQjOJ7KZcrb
         hXoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=T/7R4sid3Y7iG7a2k4Nga3B3LKDvmOJialmJYrWpMjg=;
        b=GtRuTExWC36NnwjIHauIjRD2JDM3qLK65Ycr47XsTBxwI1KEXO6o3/+SkTArf831W+
         IlHldt7OM5mfW75duYdYnT+us0Ll88nKnPC5LNczwe05oxahjEYZ17Dh8NoJAp6AISbb
         LQnC5WP27jE4aUQZY9Yu2qyNv4M+5/BVwYK8l3iyde4xn9gcbKhVRP6rOXQ7sIFzr0JO
         19WNpSMTu7hgMKY3aFavgdRcnArS0uNRIOXW+ffJIL0BptguiP5UloeHWAPHmc/4iEWL
         3lQgHF0avhCH9ksOW3WoLQ8EAYJxguFiUcA7LahYfG+O2IMQnyuI8/xg0Dg5U/v2dxFd
         dHUQ==
X-Gm-Message-State: AOAM530/l0BSHfj2GQWKuj4JxdReVr1TwM4VFieZfiSHN27NIqQwOyA1
        SjCUzbN+nXgotxfYyOeoUw2Fbd2lxhvIPGzXEap4VQ==
X-Google-Smtp-Source: ABdhPJzfXDZnaZieM0i6B/rtoSg5kaxc9y4C7njnJSbDCNC3MR4bIPB4223c4rLuH5l5SHqwH+hQEHBaM9meFHzc3q0=
X-Received: by 2002:a25:b906:: with SMTP id x6mr11226928ybj.504.1614921452924;
 Thu, 04 Mar 2021 21:17:32 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
 <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com>
 <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
 <CANn89iLBi=2VzpiUBZPHaPHCeqqoFE-JmB0KAsf-vxaPvkvcxA@mail.gmail.com> <20210304152709.4e91bd8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304152709.4e91bd8b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 5 Mar 2021 06:17:21 +0100
Message-ID: <CANn89iJKH37CMUuq66nERZQoMHFp+yuTe=yqxm1kf+RQ1RfHzw@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 5, 2021 at 12:27 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 4 Mar 2021 22:26:58 +0100 Eric Dumazet wrote:
> > It would be nice if tun driver would have the ability to delay TX
> > completions by N usecs,
> > so that packetdrill tests could be used.
> >
> > It is probably not too hard to add such a feature.
>
> Add an ioctl to turn off the skb_orphan, queue the skbs in tun_do_read()
> to free them from a timer?

Yes, I  cooked a prototype like that a few hours ago before my night
shift to launch our test suite.

I yet have to add a sane limit to the number of delayed skbs so that
syzbot does not oom its hosts ;)

>
> > I was testing this (note how I also removed the tcp_rearm_rto(sk) call)
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 6f450e577975c7be9537338c8a4c0673d7d36c4c..9ef92ca55e530f76ad793d7342442c4ec06165f7
> > 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -6471,11 +6471,10 @@ static bool tcp_rcv_fastopen_synack(struct
> > sock *sk, struct sk_buff *synack,
> >         tcp_fastopen_cache_set(sk, mss, cookie, syn_drop, try_exp);
> >
> >         if (data) { /* Retransmit unacked data in SYN */
> > -               skb_rbtree_walk_from(data) {
> > -                       if (__tcp_retransmit_skb(sk, data, 1))
> > -                               break;
> > -               }
> > -               tcp_rearm_rto(sk);
> > +               skb_rbtree_walk_from(data)
> > +                       tcp_mark_skb_lost(sk, data);
> > +
> > +               tcp_xmit_retransmit_queue(sk);
> >                 NET_INC_STATS(sock_net(sk),
> >                                 LINUX_MIB_TCPFASTOPENACTIVEFAIL);
> >                 return true;
>
> AFAICT this works great now:

Yes but some packetdrill tests fail, I have to check them (sponge link
for Googlers), but at first glance we have more investigations.

Ran 2003 tests: 1990 passed, 13 failed
Sponge: http://sponge2/b0d4c652-3173-4837-86ef-5e8cc59730a1

Failures in
//net/tcp/fastopen/client:ipv4-mapped-ipv6:cookie-disabled-prod-conn
//net/tcp/fastopen/client:ipv4-mapped-ipv6:syn-data-icmp-unreach-frag-needed
//net/tcp/fastopen/client:ipv4-mapped-ipv6:syn-data-icmp-unreach-frag-needed-with-seq
//net/tcp/fastopen/client:ipv4-mapped-ipv6:syn-data-only-syn-acked
//net/tcp/fastopen/client:ipv4-mapped-ipv6:syn-data-partial-or-over-ack
//net/tcp/fastopen/client:ipv4:cookie-disabled-prod-conn
//net/tcp/fastopen/client:ipv4:syn-data-icmp-unreach-frag-needed
//net/tcp/fastopen/client:ipv4:syn-data-icmp-unreach-frag-needed-with-seq
//net/tcp/fastopen/client:ipv4:syn-data-only-syn-acked
//net/tcp/fastopen/client:ipv4:syn-data-partial-or-over-ack
//net/tcp/fastopen/client:ipv6:cookie-disabled-prod-conn
//net/tcp/fastopen/client:ipv6:syn-data-only-syn-acked
//net/tcp/fastopen/client:ipv6:syn-data-partial-or-over-ack

Showing test.log for
//net/tcp/fastopen/client:ipv4:syn-data-icmp-unreach-frag-needed

syn-data-icmp-unreach-frag-needed.pkt:33: error handling packet: live
packet field ipv4_total_length: expected: 800 (0x320) vs actual: 1040
(0x410)
script packet: 0.090624 . 1:761(760) ack 1
actual packet: 0.090619 P. 1:1001(1000) ack 1 win 256


Yes, it looks like Alex patch no longer works

commit c31b70c9968fe9c4194d1b5d06d07596a3b680de
Author: Alexander Duyck <alexanderduyck@fb.com>
Date:   Sat Dec 12 12:31:24 2020 -0800

    tcp: Add logic to check for SYN w/ data in tcp_simple_retransmit



>
> ==> TFO case ret:-16 (0) ca_state:0 skb:ffff8881d3513800!
>   FREED swapper/5 -- skb 0xffff8881d3513800 freed after: 1us
> -----
> First:
>         __tcp_retransmit_skb+1
>         tcp_retransmit_skb+18
>         tcp_xmit_retransmit_queue.part.70+339
>         tcp_rcv_state_process+2491
>         tcp_v6_do_rcv+405
>         tcp_v6_rcv+2984
>
> Second:
>         __tcp_retransmit_skb+1
>         tcp_retransmit_skb+18
>         tcp_xmit_retransmit_queue.part.70+339
>         tcp_tsq_write.part.71+146
>         tcp_tsq_handler+53
>         tcp_tasklet_func+181
>
>  sk:0xffff8885adc16f00 skb:ffff8881d3513800 --- 61us acked:1
>
>
> The other case where we hit RTO after __tcp_retransmit_skb() fails is:
>
> ==> non-TFO case ret:-11 (0) ca_state:3 skb:ffff8883d71dd400!
> -----
> First:
>         __tcp_retransmit_skb+1
>         tcp_retransmit_skb+18
>         tcp_xmit_retransmit_queue.part.70+339
>         tcp_ack+2270
>         tcp_rcv_established+303
>         tcp_v6_do_rcv+190
>
> Second:
>         __tcp_retransmit_skb+1
>         tcp_retransmit_skb+18
>         tcp_retransmit_timer+716
>         tcp_write_timer_handler+136
>         tcp_write_timer+141
>         call_timer_fn+43
>
>  sk:0xffff88801772d340 skb:ffff8883d71dd400 --- 51738us acked:47324
>
> Which I believe is this:
>
>         if (refcount_read(&sk->sk_wmem_alloc) >
>             min_t(u32, sk->sk_wmem_queued + (sk->sk_wmem_queued >> 2),
>                   sk->sk_sndbuf))
>                 return -EAGAIN;
>
> Because __tcp_retransmit_skb() seems to bail before
> inet6_sk_rebuild_header gets called. Should we arm TSQ here as well?

Yes, or make the limit slightly bigger since we now have the fclone
more precise thing for standard drivers [1]

if ((refcount_read(&sk->sk_wmem_alloc) >> 1) >
    min_t(u32, sk->sk_wmem_queued,  sk->sk_sndbuf))
   return -EAGAIN;

[1] It is probably wise to keep this code because some drivers do call
skb_orphan() in their ndo_start_xmit()
