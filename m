Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15D781EC8EA
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbgFCFoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725275AbgFCFoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:44:17 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE5BCC05BD43
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 22:44:16 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id m16so448552ybf.4
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 22:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=drl8sixri3zXLhlgjm5kMzdzkBeIGW4B0LZy7UPGm64=;
        b=LgBR4wYDM7EbnCEdMCLz/CEAYXc8kPuPCPYULmEQY1HVM3FGzw8s2FcaAZEYiT7bgR
         cJmFg0kNSOTRmTIQ+O6lcy8i1eCq2bbR9ydwSIgEIj5wsXP4Mb+/r7J5+JKrKYUq2r/Q
         J0NgZiiS1XVa9CxF76KP9wGJ/+FH1mMwDIhCKuoG7Pzcycm+haecCiMcNUDckKntMAjv
         0yzwRLIeoxyqujzKd8MTunXunne0KAbO98XnJE8dCxTt8Uivw3SmqJTq4eSAbbQlg70p
         0NuHMv28ewUpNrJhhY/ltCjOaH2fxVxixFFtR2HTDHdEe10vZfdHTuRVj/8XBaI4qbbz
         viwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=drl8sixri3zXLhlgjm5kMzdzkBeIGW4B0LZy7UPGm64=;
        b=O+3FIAJfBAx9/4Dpb3+p3mTB6057AazE4YaBAR3RpadrS2WnOLjomYJwsQ2hxjTWzW
         hk3d8ySovpiWhyf4jbLvS9COGt2u4uu4pYrg/mXKMEXqXROUiIFQdBol559ZLdYAIgDy
         NH4eIl5IkzW25AtsR7VXb5UWHCgm2mIMYK6Q2xiACZpPHAlDMDSO1qKCwVDyeis6+4wa
         d2uRAeh3foDOv9gM9WZ9zWc8Ppql/S5Tr2O3Dyf4piSTJ60poQzxfdKR5TeypbyCYQpr
         zI0uhkBy23b2Oz7pDC771Mz1hatE9+gOYmjAk7EBnlRw93m01Dj0qjvW+Ys2L+nK6C8Y
         Kxmw==
X-Gm-Message-State: AOAM530r/LuODri94o+G1QRiAF6I6+eSv/wTwYeNVbd20rmzCII/zr9J
        9zBEcmpyUO9nrTdDASOuVtZqA4tO6Ue9TLJ2cGSuGw==
X-Google-Smtp-Source: ABdhPJzfNb4M+A75OQNFB0yn0Chinhpyl8JiTiVSPfQpUK6LtL2KmSzSASlR846d42VW556gV29IBHchKq067B/1Lbk=
X-Received: by 2002:a25:9a49:: with SMTP id r9mr21893156ybo.520.1591163055744;
 Tue, 02 Jun 2020 22:44:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
 <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com> <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com>
In-Reply-To: <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Jun 2020 22:44:02 -0700
Message-ID: <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Jason Xing <kerneljasonxing@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, liweishi@kuaishou.com,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 2, 2020 at 10:05 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> Hi Eric,
>
> I'm still trying to understand what you're saying before. Would this
> be better as following:
> 1) discard the tcp_internal_pacing() function.
> 2) remove where the tcp_internal_pacing() is called in the
> __tcp_transmit_skb() function.
>
> If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
> should we introduce the tcp_wstamp_ns socket field as commit
> (864e5c090749) does?
>

Please do not top-post on netdev mailing list.


I basically suggested double-checking which point in TCP could end up
calling tcp_internal_pacing()
while the timer was already armed.

I guess this is mtu probing.

Please try the following patch : If we still have another bug, a
WARNING should give us a stack trace.


diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cc4ba42052c21b206850594db6751810d8fc72b4..8f4081b228486305222767d4d118b9b6ed0ffda3
100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -977,12 +977,26 @@ static void tcp_internal_pacing(struct sock *sk,
const struct sk_buff *skb)

        len_ns = (u64)skb->len * NSEC_PER_SEC;
        do_div(len_ns, rate);
+
+       /* If hrtimer is already armed, then our caller has not properly
+        * used tcp_pacing_check().
+        */
+       if (unlikely(hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))) {
+               WARN_ON_ONCE(1);
+               return;
+       }
        hrtimer_start(&tcp_sk(sk)->pacing_timer,
                      ktime_add_ns(ktime_get(), len_ns),
                      HRTIMER_MODE_ABS_PINNED_SOFT);
        sock_hold(sk);
 }

+static bool tcp_pacing_check(const struct sock *sk)
+{
+       return tcp_needs_internal_pacing(sk) &&
+              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
+}
+
 static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
 {
        skb->skb_mstamp = tp->tcp_mstamp;
@@ -2117,6 +2131,9 @@ static int tcp_mtu_probe(struct sock *sk)
        if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
                return -1;

+       if (tcp_pacing_check(sk))
+               return -1;
+
        /* We're allowed to probe.  Build it now. */
        nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
        if (!nskb)
@@ -2190,11 +2207,6 @@ static int tcp_mtu_probe(struct sock *sk)
        return -1;
 }

-static bool tcp_pacing_check(const struct sock *sk)
-{
-       return tcp_needs_internal_pacing(sk) &&
-              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
-}

 /* TCP Small Queues :
  * Control number of packets in qdisc/devices to two packets / or ~1 ms.



> Thanks,
> Jason
>
> On Wed, Jun 3, 2020 at 10:44 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jun 2, 2020 at 7:42 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > I agree with you. The upstream has already dropped and optimized this
> > > part (commit 864e5c090749), so it would not happen like that. However
> > > the old kernels like LTS still have the problem which causes
> > > large-scale crashes on our thousands of machines after running for a
> > > long while. I will send the fix to the correct tree soon :)
> >
> > If you run BBR at scale (thousands of machines), you probably should
> > use sch_fq instead of internal pacing,
> > just saying ;)
> >
> >
> > >
> > > Thanks again,
> > > Jason
> > >
> > > On Wed, Jun 3, 2020 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Jun 2, 2020 at 6:53 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > >
> > > > > Hi Eric,
> > > > >
> > > > > I'm sorry that I didn't write enough clearly. We're running the
> > > > > pristine 4.19.125 linux kernel (the latest LTS version) and have been
> > > > > haunted by such an issue. This patch is high-important, I think. So
> > > > > I'm going to resend this email with the [patch 4.19] on the headline
> > > > > and cc Greg.
> > > >
> > > > Yes, please always give for which tree a patch is meant for.
> > > >
> > > > Problem is that your patch is not correct.
> > > > In these old kernels, tcp_internal_pacing() is called _after_ the
> > > > packet has been sent.
> > > > It is too late to 'give up pacing'
> > > >
> > > > The packet should not have been sent if the pacing timer is queued
> > > > (otherwise this means we do not respect pacing)
> > > >
> > > > So the bug should be caught earlier. check where tcp_pacing_check()
> > > > calls are missing.
> > > >
> > > >
> > > >
> > > > >
> > > > >
> > > > > Thanks,
> > > > > Jason
> > > > >
> > > > > On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > > >
> > > > > > On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> > > > > > >
> > > > > > > From: Jason Xing <kerneljasonxing@gmail.com>
> > > > > > >
> > > > > > > TCP socks cannot be released because of the sock_hold() increasing the
> > > > > > > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > > > > > > Therefore, this situation could increase the slab memory and then trigger
> > > > > > > the OOM if the machine has beening running for a long time. This issue,
> > > > > > > however, can happen on some machine only running a few days.
> > > > > > >
> > > > > > > We add one exception case to avoid unneeded use of sock_hold if the
> > > > > > > pacing_timer is enqueued.
> > > > > > >
> > > > > > > Reproduce procedure:
> > > > > > > 0) cat /proc/slabinfo | grep TCP
> > > > > > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > > > > > 2) using wrk tool something like that to send packages
> > > > > > > 3) using tc to increase the delay in the dev to simulate the busy case.
> > > > > > > 4) cat /proc/slabinfo | grep TCP
> > > > > > > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > > > > > > 6) at last, you could notice that the number would not decrease.
> > > > > > >
> > > > > > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > > > > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > > > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > > > > ---
> > > > > > >  net/ipv4/tcp_output.c | 3 ++-
> > > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > > >
> > > > > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > > > > index cc4ba42..5cf63d9 100644
> > > > > > > --- a/net/ipv4/tcp_output.c
> > > > > > > +++ b/net/ipv4/tcp_output.c
> > > > > > > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> > > > > > >         u64 len_ns;
> > > > > > >         u32 rate;
> > > > > > >
> > > > > > > -       if (!tcp_needs_internal_pacing(sk))
> > > > > > > +       if (!tcp_needs_internal_pacing(sk) ||
> > > > > > > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> > > > > > >                 return;
> > > > > > >         rate = sk->sk_pacing_rate;
> > > > > > >         if (!rate || rate == ~0U)
> > > > > > > --
> > > > > > > 1.8.3.1
> > > > > > >
> > > > > >
> > > > > > Hi Jason.
> > > > > >
> > > > > > Please do not send patches that do not apply to current upstream trees.
> > > > > >
> > > > > > Instead, backport to your kernels the needed fixes.
> > > > > >
> > > > > > I suspect that you are not using a pristine linux kernel, but some
> > > > > > heavily modified one and something went wrong in your backports.
> > > > > > Do not ask us to spend time finding what went wrong.
> > > > > >
> > > > > > Thank you.
