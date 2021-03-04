Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC2732DBC3
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 22:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239435AbhCDV2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 16:28:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbhCDV1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 16:27:51 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5FE4C061756
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 13:27:10 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id l8so30050214ybe.12
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 13:27:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dDnJfMvrDhsf2ud0NN9/8luKmD47vDzxWGx7IfplQco=;
        b=IOSOFG3mPIeaIdUwuvydiJRAk1SpS22lNswzJZzoPPzAS62F7OIjXpeMb5w0F9iYyf
         16c52u3m1zLWNHacMumWLZ2JG7m80mqADvHs+o05V0lZ+VuMwRnw5IYYyPv1QWUk6rhJ
         SBWqBUfE+KyBeGt++WBhRp7vleEJL62t6bq/6s/8TGVfzYmEbEyla7n5gAfOsmnztag8
         xWTEDRPEPi3C43eoG+hwLPl+3meDllS08BTKRUW+jqXPVf5YbK5Gx27YALGutEvlHO3U
         muzqTTz/beKs0m0GGqgRsWrAbzulEv6hI2/0auL0qxxgJA3MHZMFYU4WhTJNRLPrU/As
         0buQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dDnJfMvrDhsf2ud0NN9/8luKmD47vDzxWGx7IfplQco=;
        b=UudkNsHpTLL1hfxUE+H1Itjt8tSRNoTnwvnsBhXFvFUzlfldKRyh4UV1wFsNYE2J2C
         hpklRSlWvcu+gwgaxjTl1rgbL1TMlqclo7rgRv8RnUMp/5kM+SBq0jzgYxaLdR0LFfVF
         1Sgtdy1Zhpl8vb82DLv2cajEu14G2nkD/hY4XT5/NZmNMo6h88WRqOKJ0j1nVIjASx6Q
         3RW8KhAUyNS/YMs1zfeTCihwM0S4Dw6n7kh2G3+aMafwHSWXpUo85xzLAkBrBuQp6n/1
         8juYt/on8quDfbezUHcU9joL9iFf5wtTNW5yN+0qKlRbR0P1VhO3YGiwXkGjOjBO9rME
         9hTg==
X-Gm-Message-State: AOAM532NYCkQU7p/eHEAY3l8lyGvE2hm6lo4VA5lwjH3QgTtHXA+Wq3z
        L+jVOm2s2RBpdHCnfe5YOQrsHKgMDegqihg/7mAxcw==
X-Google-Smtp-Source: ABdhPJz5alSYGXA7mdtDKoXjbSgUjdryV0lS2qrqjZYlTNhU2p3mtoxgll5HEakJWFc4QyoG8scvHqprpGcHgvKgtMw=
X-Received: by 2002:a25:2307:: with SMTP id j7mr9621423ybj.518.1614893229704;
 Thu, 04 Mar 2021 13:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20210302060753.953931-1-kuba@kernel.org> <CANn89iLaQuCGeWOh7Hp8X9dL09FhPP8Nwj+zV=rhYX7Cq7efpg@mail.gmail.com>
 <CAKgT0UdXiFBW9oDwvsFPe_ZoGveHLGh6RXf55jaL6kOYPEh0Hg@mail.gmail.com>
 <20210303160715.2333d0ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAKgT0Ue9w4WBojY94g3kcLaQrVbVk6S-HgsFgLVXoqsY20hwuw@mail.gmail.com>
 <CANn89iL9fBKDQvAM0mTnh_B5ggmsebDBYxM6WAfYgMuD8-vcBw@mail.gmail.com>
 <20210304110626.1575f7aa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+cXQXP-7ioizFy90Dj-1SfjA0MQfwvDChxVXQ3wbTjFA@mail.gmail.com>
 <20210304210836.bkpqwbvfpkd5fagg@bsd-mbp.dhcp.thefacebook.com> <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
In-Reply-To: <CANn89i+Sf66QknMO7+1gxowhV6g+Bs-DMhnvsvFx8vaqPfBVug@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 4 Mar 2021 22:26:58 +0100
Message-ID: <CANn89iLBi=2VzpiUBZPHaPHCeqqoFE-JmB0KAsf-vxaPvkvcxA@mail.gmail.com>
Subject: Re: [PATCH net] net: tcp: don't allocate fast clones for fastopen SYN
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        kernel-team <kernel-team@fb.com>, Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 4, 2021 at 10:20 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Thu, Mar 4, 2021 at 10:08 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
> >
> > On Thu, Mar 04, 2021 at 08:41:45PM +0100, Eric Dumazet wrote:
> > > On Thu, Mar 4, 2021 at 8:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > >
> > > > On Thu, 4 Mar 2021 13:51:15 +0100 Eric Dumazet wrote:
> > > > > I think we are over thinking this really (especially if the fix needs
> > > > > a change in core networking or drivers)
> > > > >
> > > > > We can reuse TSQ logic to have a chance to recover when the clone is
> > > > > eventually freed.
> > > > > This will be more generic, not only for the SYN+data of FastOpen.
> > > > >
> > > > > Can you please test the following patch ?
> > > >
> > > > #7 - Eric comes up with something much better :)
> > > >
> > > >
> > > > But so far doesn't seem to quite do it, I'm looking but maybe you'll
> > > > know right away (FWIW testing a v5.6 backport but I don't think TSQ
> > > > changed?):
> > > >
> > > > On __tcp_retransmit_skb kretprobe:
> > > >
> > > > ==> Hit TFO case ret:-16 ca_state:0 skb:ffff888fdb4bac00!
> > > >
> > > > First hit:
> > > >         __tcp_retransmit_skb+1
> > > >         tcp_rcv_state_process+2488
> > > >         tcp_v6_do_rcv+405
> > > >         tcp_v6_rcv+2984
> > > >         ip6_protocol_deliver_rcu+180
> > > >         ip6_input_finish+17
> > > >
> > > > Successful hit:
> > > >         __tcp_retransmit_skb+1
> > > >         tcp_retransmit_skb+18
> > > >         tcp_retransmit_timer+716
> > > >         tcp_write_timer_handler+136
> > > >         tcp_write_timer+141
> > > >         call_timer_fn+43
> > > >
> > > >  skb:ffff888fdb4bac00 --- delay:51642us bytes_acked:1
> > >
> > >
> > > Humm maybe one of the conditions used in tcp_tsq_write() does not hold...
> > >
> > > if (tp->lost_out > tp->retrans_out &&
> > >     tp->snd_cwnd > tcp_packets_in_flight(tp)) {
> > >     tcp_mstamp_refresh(tp);
> > >     tcp_xmit_retransmit_queue(sk);
> > > }
> > >
> > > Maybe FastOpen case is 'special' and tp->lost_out is wrong.
> >
> >
> > Something like this?  (completely untested)
> > --
> > Jonathan
> >
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 69a545db80d2..92bc9b0f4955 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5995,8 +5995,10 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
> >                 else
> >                         tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
> >                 skb_rbtree_walk_from(data) {
> > +                       tcp_mark_skb_lost(sk, data);
> >                         if (__tcp_retransmit_skb(sk, data, 1))
> >                                 break;
> > +                       tp->retrans_out += tcp_skb_pcount(data);
> >                 }
> >                 tcp_rearm_rto(sk);
> >                 NET_INC_STATS(sock_net(sk),
> >
>
> Yes, but the hard part is testing this ;)
>
> Once we properly mark the skb lost, we can call regular
> tcp_xmit_retransmit_queue() to not have to care of tp->retrans_out
>
> Not that we really need to make sure tcp_xmit_retransmit_queue() can
> be called anyway from TSQ handler if TX completion is delayed.

I was testing this (note how I also removed the tcp_rearm_rto(sk) call)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 6f450e577975c7be9537338c8a4c0673d7d36c4c..9ef92ca55e530f76ad793d7342442c4ec06165f7
100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -6471,11 +6471,10 @@ static bool tcp_rcv_fastopen_synack(struct
sock *sk, struct sk_buff *synack,
        tcp_fastopen_cache_set(sk, mss, cookie, syn_drop, try_exp);

        if (data) { /* Retransmit unacked data in SYN */
-               skb_rbtree_walk_from(data) {
-                       if (__tcp_retransmit_skb(sk, data, 1))
-                               break;
-               }
-               tcp_rearm_rto(sk);
+               skb_rbtree_walk_from(data)
+                       tcp_mark_skb_lost(sk, data);
+
+               tcp_xmit_retransmit_queue(sk);
                NET_INC_STATS(sock_net(sk),
                                LINUX_MIB_TCPFASTOPENACTIVEFAIL);
                return true;
