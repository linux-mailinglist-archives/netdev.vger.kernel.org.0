Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B369E1EC98F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725954AbgFCGdH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgFCGdH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:33:07 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140C9C05BD43;
        Tue,  2 Jun 2020 23:33:07 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id h188so572710lfd.7;
        Tue, 02 Jun 2020 23:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FywedV+p++mlSruT+gRfrv7kyw3s60kUhVNNtZpQ1PM=;
        b=YOsSceVigJQZTH+FSlMKWMFfmjanPadDGpXzJKnudPHyifAVfy/7IIt/oa0UBwl6Xm
         iKagIc0SvphMdSvYyGprUS5B8wjvpgnsnjIwt3uY0nwTxveNgq4QAF1KBp98CGKXuLFI
         zFzfJj8rOmamQn9wLOL3P7oMxzIqO/nVIzWzxXJnwgJVnbEMZMduV70QKr3UzBUNrvZe
         KgJkQ/wYt4uujMCxY3jQm3UlgXP8tctjqCpnswqBlXQS89OhEfw7uO2ZPk2CPs7eA42o
         jaW473rDu6gUFXpVeSj+29DFRQvsDAB9nRuXF4lWhCpv2dnmziBbXmOyvlyqrzFjleLY
         Gihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FywedV+p++mlSruT+gRfrv7kyw3s60kUhVNNtZpQ1PM=;
        b=IfKDFg4MI6yuTCfGpTkj7fDv2ZnkfzT6iC40KPPsIGhX5f8RRefVbegL3A2j9pie1l
         /vh6cGoFjUlOWF9lTDL2LfG91XazODbGQpUDTYW8m12GwWL018uuvjDe3T61+pGpSuQ9
         vkkGiVzBjWfTt/9pGe+ElNdHXMfr9jpm2HeU9aX38kneaEJYhnx1cUWGvsFj0kctLD/t
         Pnt+hHTA6Vc1SkMif7a0MFGRRYT9lSki0XH7UF9xpFfLMAEkQvleKjUIqGi1GsEDf09p
         w33L06s4AHUSo0TN1u/uMwiOOFF/6lmwIr1F98pNUDfR7kcTjHBQT3SaDy+pTprDFYO+
         AwYA==
X-Gm-Message-State: AOAM530vXhOv1tBuRc+F3k1V/gEAkpnqnGHEZRcLzejWGSalp/kc8mw5
        2ZWwKuMOuiyq96fysU1YTRvGbCR1xdl9n1u68Yw=
X-Google-Smtp-Source: ABdhPJxsH6Kv6dbizJfZj2zTwTRBoQHfL8Ks/0J/MBPZdvgMWauK0Qws7SNB/OmzxN1GPLZoX6lTHzlIOSPIZYOqEWU=
X-Received: by 2002:ac2:54a8:: with SMTP id w8mr1574614lfk.53.1591165985326;
 Tue, 02 Jun 2020 23:33:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
 <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
 <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com> <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
In-Reply-To: <CANn89iJfLM2Hz69d9qOZoRKwzzCCpgVRZ1zbTTbg4vGvSAEZ-w@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 14:32:29 +0800
Message-ID: <CAL+tcoAQGZRaGJy1a1R=Ut=3+WnvCO7UNLq9J_juTtZJmTnC9g@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
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

On Wed, Jun 3, 2020 at 1:44 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 2, 2020 at 10:05 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > Hi Eric,
> >
> > I'm still trying to understand what you're saying before. Would this
> > be better as following:
> > 1) discard the tcp_internal_pacing() function.
> > 2) remove where the tcp_internal_pacing() is called in the
> > __tcp_transmit_skb() function.
> >
> > If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
> > should we introduce the tcp_wstamp_ns socket field as commit
> > (864e5c090749) does?
> >
>
> Please do not top-post on netdev mailing list.
>
>
> I basically suggested double-checking which point in TCP could end up
> calling tcp_internal_pacing()
> while the timer was already armed.
>
> I guess this is mtu probing.

Thanks for suggestions. I will recheck the point.

>
> Please try the following patch : If we still have another bug, a
> WARNING should give us a stack trace.
>

Agreed. I will apply this part of code and test it, then get back some
information here.
If it runs well as we expect, I decide to send this patch as v2 for
4.19 linux kernel.

Jason

>
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index cc4ba42052c21b206850594db6751810d8fc72b4..8f4081b228486305222767d4d118b9b6ed0ffda3
> 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -977,12 +977,26 @@ static void tcp_internal_pacing(struct sock *sk,
> const struct sk_buff *skb)
>
>         len_ns = (u64)skb->len * NSEC_PER_SEC;
>         do_div(len_ns, rate);
> +
> +       /* If hrtimer is already armed, then our caller has not properly
> +        * used tcp_pacing_check().
> +        */
> +       if (unlikely(hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))) {
> +               WARN_ON_ONCE(1);
> +               return;
> +       }
>         hrtimer_start(&tcp_sk(sk)->pacing_timer,
>                       ktime_add_ns(ktime_get(), len_ns),
>                       HRTIMER_MODE_ABS_PINNED_SOFT);
>         sock_hold(sk);
>  }
>
> +static bool tcp_pacing_check(const struct sock *sk)
> +{
> +       return tcp_needs_internal_pacing(sk) &&
> +              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
> +}
> +
>  static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
>  {
>         skb->skb_mstamp = tp->tcp_mstamp;
> @@ -2117,6 +2131,9 @@ static int tcp_mtu_probe(struct sock *sk)
>         if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
>                 return -1;
>
> +       if (tcp_pacing_check(sk))
> +               return -1;
> +
>         /* We're allowed to probe.  Build it now. */
>         nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
>         if (!nskb)
> @@ -2190,11 +2207,6 @@ static int tcp_mtu_probe(struct sock *sk)
>         return -1;
>  }
>
> -static bool tcp_pacing_check(const struct sock *sk)
> -{
> -       return tcp_needs_internal_pacing(sk) &&
> -              hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
> -}
>
>  /* TCP Small Queues :
>   * Control number of packets in qdisc/devices to two packets / or ~1 ms.
>
>
>
> > Thanks,
> > Jason
> >
> > On Wed, Jun 3, 2020 at 10:44 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 2, 2020 at 7:42 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > >
> > > > I agree with you. The upstream has already dropped and optimized this
> > > > part (commit 864e5c090749), so it would not happen like that. However
> > > > the old kernels like LTS still have the problem which causes
> > > > large-scale crashes on our thousands of machines after running for a
> > > > long while. I will send the fix to the correct tree soon :)
> > >
> > > If you run BBR at scale (thousands of machines), you probably should
> > > use sch_fq instead of internal pacing,
> > > just saying ;)
> > >
> > >
> > > >
> > > > Thanks again,
> > > > Jason
> > > >
> > > > On Wed, Jun 3, 2020 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 2, 2020 at 6:53 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > > > >
> > > > > > Hi Eric,
> > > > > >
> > > > > > I'm sorry that I didn't write enough clearly. We're running the
> > > > > > pristine 4.19.125 linux kernel (the latest LTS version) and have been
> > > > > > haunted by such an issue. This patch is high-important, I think. So
> > > > > > I'm going to resend this email with the [patch 4.19] on the headline
> > > > > > and cc Greg.
> > > > >
> > > > > Yes, please always give for which tree a patch is meant for.
> > > > >
> > > > > Problem is that your patch is not correct.
> > > > > In these old kernels, tcp_internal_pacing() is called _after_ the
> > > > > packet has been sent.
> > > > > It is too late to 'give up pacing'
> > > > >
> > > > > The packet should not have been sent if the pacing timer is queued
> > > > > (otherwise this means we do not respect pacing)
> > > > >
> > > > > So the bug should be caught earlier. check where tcp_pacing_check()
> > > > > calls are missing.
> > > > >
> > > > >
> > > > >
> > > > > >
> > > > > >
> > > > > > Thanks,
> > > > > > Jason
> > > > > >
> > > > > > On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > > > >
> > > > > > > On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> > > > > > > >
> > > > > > > > From: Jason Xing <kerneljasonxing@gmail.com>
> > > > > > > >
> > > > > > > > TCP socks cannot be released because of the sock_hold() increasing the
> > > > > > > > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > > > > > > > Therefore, this situation could increase the slab memory and then trigger
> > > > > > > > the OOM if the machine has beening running for a long time. This issue,
> > > > > > > > however, can happen on some machine only running a few days.
> > > > > > > >
> > > > > > > > We add one exception case to avoid unneeded use of sock_hold if the
> > > > > > > > pacing_timer is enqueued.
> > > > > > > >
> > > > > > > > Reproduce procedure:
> > > > > > > > 0) cat /proc/slabinfo | grep TCP
> > > > > > > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > > > > > > 2) using wrk tool something like that to send packages
> > > > > > > > 3) using tc to increase the delay in the dev to simulate the busy case.
> > > > > > > > 4) cat /proc/slabinfo | grep TCP
> > > > > > > > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > > > > > > > 6) at last, you could notice that the number would not decrease.
> > > > > > > >
> > > > > > > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > > > > > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > > > > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > > > > > ---
> > > > > > > >  net/ipv4/tcp_output.c | 3 ++-
> > > > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > > > >
> > > > > > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > > > > > index cc4ba42..5cf63d9 100644
> > > > > > > > --- a/net/ipv4/tcp_output.c
> > > > > > > > +++ b/net/ipv4/tcp_output.c
> > > > > > > > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> > > > > > > >         u64 len_ns;
> > > > > > > >         u32 rate;
> > > > > > > >
> > > > > > > > -       if (!tcp_needs_internal_pacing(sk))
> > > > > > > > +       if (!tcp_needs_internal_pacing(sk) ||
> > > > > > > > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> > > > > > > >                 return;
> > > > > > > >         rate = sk->sk_pacing_rate;
> > > > > > > >         if (!rate || rate == ~0U)
> > > > > > > > --
> > > > > > > > 1.8.3.1
> > > > > > > >
> > > > > > >
> > > > > > > Hi Jason.
> > > > > > >
> > > > > > > Please do not send patches that do not apply to current upstream trees.
> > > > > > >
> > > > > > > Instead, backport to your kernels the needed fixes.
> > > > > > >
> > > > > > > I suspect that you are not using a pristine linux kernel, but some
> > > > > > > heavily modified one and something went wrong in your backports.
> > > > > > > Do not ask us to spend time finding what went wrong.
> > > > > > >
> > > > > > > Thank you.
