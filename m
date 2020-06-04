Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65891EDFEB
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 10:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbgFDIlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 04:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgFDIlY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 04:41:24 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CC7C05BD1E;
        Thu,  4 Jun 2020 01:41:24 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id s1so6252904ljo.0;
        Thu, 04 Jun 2020 01:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=niXbj2ikmDqITdGXIco/ydF534thB0b9rEZsBYeN5ew=;
        b=HByN/Qzrccr9TUDTBqlH9sp5SnbAcfC6WAcWM6JKC4n811VDcHYkwm0/u3OmxAelV6
         cZPj/gfkX9vU+Zc/qQEUepo0E2+b93MXuasEqWfIYcNap2BIxcVbpaOlGZaa0sBMZ9wN
         gGhVbz9x+Uz7vjjpB+F5jPdJefWJsEEXEia/Cb6Qumc7TDCesy65BXxZSZnHjjO1PxvA
         oxjRG1VCJ6YprOF5ivxlzOqAnklDDBPpUqcaoSLjwCqXv9SyIt2dWxguBKNdH/sWirDM
         HWbi89SSdxpt7mNbObd/2Z7XbapZOYzNqP1r8KHp4pggJXtOjIcIwDrtVzb0+Srgw8Nn
         AtFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=niXbj2ikmDqITdGXIco/ydF534thB0b9rEZsBYeN5ew=;
        b=IoAdJYzIMHRxi24J9krpNTGJ1RemSgWpqZe/sMKvJiy0lwrCuwkSqwH5qhm+zoL/Y6
         egthvpCORK5JHq+YSLtfbQh6h7DB5tfyGXkYpvToZSZucVNFvEjnwNyULWpCEOEHOJ90
         vNt4TH2KjXpvPlg30Kp3hIhYQcS7q38dQcsTz7Gg0UeyCufl56G+FNfoFpM9Yg1Wm9+5
         Sk8mHnKDIaqxPa264EqObCyRyruXc76QI76EOtr8f7Vy9SI7BqtqdAXnNbSyRdJ0TBPN
         e7mqF0FYdqZmRwfjVnif8UGgLyViXQWqpMxqxaZEnPvGpoJIBM5aVz+bDeeUVvE2XLuy
         y5EQ==
X-Gm-Message-State: AOAM532/0uhB1BVM2EdbpEj7g4RaKuu3VFb6lgH9r6sgckqc+wehaGeE
        VsEdvx9ubeyB5cMJMLBSE9Cowh4PVfeTdCnqkOo=
X-Google-Smtp-Source: ABdhPJxoAn19QOc9KmmF9YH88U39iiAyM0/G3b+LFkZqOC2ojXIqnh6E02c4rcV6jJyrK5EhxS5oJDimhAp2e748kfs=
X-Received: by 2002:a2e:8e64:: with SMTP id t4mr1692370ljk.414.1591260082504;
 Thu, 04 Jun 2020 01:41:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
 <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
 <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com>
 <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
 <CADVnQy=RJfmzHR15DyWdydFAqSqVmFhaW4_cgYYAgnixEa5DNQ@mail.gmail.com>
 <CANn89i+7-wE4xr5D9DpH+N-xkL1SB8oVghCKgz+CT5eG1ODQhA@mail.gmail.com> <CADVnQynXzE6_6h8w8TDyPjtQjy_uXr-+3weikTDtAbY-xPiDEw@mail.gmail.com>
In-Reply-To: <CADVnQynXzE6_6h8w8TDyPjtQjy_uXr-+3weikTDtAbY-xPiDEw@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 4 Jun 2020 16:40:46 +0800
Message-ID: <CAL+tcoAn_22aJYkgDk_TodBLn-jwA1yHjB0bPXWR3RX3o2uDQw@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 3, 2020 at 10:08 PM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Jun 3, 2020 at 9:55 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Wed, Jun 3, 2020 at 5:02 AM Neal Cardwell <ncardwell@google.com> wrote:
> > >
> > > On Wed, Jun 3, 2020 at 1:44 AM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Jun 2, 2020 at 10:05 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > >
> > > > > Hi Eric,
> > > > >
> > > > > I'm still trying to understand what you're saying before. Would this
> > > > > be better as following:
> > > > > 1) discard the tcp_internal_pacing() function.
> > > > > 2) remove where the tcp_internal_pacing() is called in the
> > > > > __tcp_transmit_skb() function.
> > > > >
> > > > > If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
> > > > > should we introduce the tcp_wstamp_ns socket field as commit
> > > > > (864e5c090749) does?
> > > > >
> > > >
> > > > Please do not top-post on netdev mailing list.
> > > >
> > > >
> > > > I basically suggested double-checking which point in TCP could end up
> > > > calling tcp_internal_pacing()
> > > > while the timer was already armed.
> > > >
> > > > I guess this is mtu probing.
> > >
> > > Perhaps this could also happen from some of the retransmission code
> > > paths that don't use tcp_xmit_retransmit_queue()? Perhaps
> > > tcp_retransmit_timer() (RTO) and  tcp_send_loss_probe() TLP? It seems
> > > they could indirectly cause a call to __tcp_transmit_skb() and thus
> > > tcp_internal_pacing() without first checking if the pacing timer was
> > > already armed?
> >
> > I feared this, (see recent commits about very low pacing rates) :/
> >
> > I am not sure we need to properly fix all these points for old
> > kernels, since EDT model got rid of these problems.
>
> Agreed.
>
> > Maybe we can try to extend the timer.
>
> Sounds good.
>
> > Something like :
> >
> >
> > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > index cc4ba42052c21b206850594db6751810d8fc72b4..626b9f4f500f7e5270d8d59e6eb16dbfa3efbc7c
> > 100644
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -966,6 +966,8 @@ enum hrtimer_restart tcp_pace_kick(struct hrtimer *timer)
> >
> >  static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> >  {
> > +       struct tcp_sock *tp = tcp_sk(sk);
> > +       ktime_t expire, now;
> >         u64 len_ns;
> >         u32 rate;
> >
> > @@ -977,12 +979,29 @@ static void tcp_internal_pacing(struct sock *sk,
> > const struct sk_buff *skb)
> >
> >         len_ns = (u64)skb->len * NSEC_PER_SEC;
> >         do_div(len_ns, rate);
> > -       hrtimer_start(&tcp_sk(sk)->pacing_timer,
> > -                     ktime_add_ns(ktime_get(), len_ns),
> > +
> > +       now = ktime_get();
> > +       /* If hrtimer is already armed, then our caller has not
> > +        * used tcp_pacing_check().
> > +        */
> > +       if (unlikely(hrtimer_is_queued(&tp->pacing_timer))) {
> > +               expire = hrtimer_get_softexpires(&tp->pacing_timer);
> > +               if (ktime_after(expire, now))
> > +                       now = expire;
> > +               if (hrtimer_try_to_cancel(&tp->pacing_timer) == 1)
> > +                       __sock_put(sk);
> > +       }
> > +       hrtimer_start(&tp->pacing_timer, ktime_add_ns(now, len_ns),
> >                       HRTIMER_MODE_ABS_PINNED_SOFT);
> >         sock_hold(sk);
> >  }
> >
> > +static bool tcp_pacing_check(const struct sock *sk)
> > +{
> > +       return tcp_needs_internal_pacing(sk) &&
> > +              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
> > +}
> > +
> >  static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
> >  {
> >         skb->skb_mstamp = tp->tcp_mstamp;
> > @@ -2117,6 +2136,9 @@ static int tcp_mtu_probe(struct sock *sk)
> >         if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
> >                 return -1;
> >
> > +       if (tcp_pacing_check(sk))
> > +               return -1;
> > +
> >         /* We're allowed to probe.  Build it now. */
> >         nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
> >         if (!nskb)
> > @@ -2190,11 +2212,6 @@ static int tcp_mtu_probe(struct sock *sk)
> >         return -1;
> >  }
> >
> > -static bool tcp_pacing_check(const struct sock *sk)
> > -{
> > -       return tcp_needs_internal_pacing(sk) &&
> > -              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
> > -}
> >
> >  /* TCP Small Queues :
> >   * Control number of packets in qdisc/devices to two packets / or ~1 ms.
>
> Thanks for your fix, Eric. This fix looks good to me! I agree that
> this fix is good enough for older kernels.
>

I just tested this patch and it worked well. So it also looks good to me :)
Nice work!

thanks,
Jason

> thanks,
> neal
