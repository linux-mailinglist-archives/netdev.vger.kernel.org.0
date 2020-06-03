Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E0E41EC785
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:42:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725967AbgFCCmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725794AbgFCCmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:42:20 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CA37C08C5C0;
        Tue,  2 Jun 2020 19:42:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id a25so786343ljp.3;
        Tue, 02 Jun 2020 19:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CFI1m1bXGZYKZMu3ppASc24ioDiu36YQQGgUMSxsWQI=;
        b=c9WYIlS6PxKJJ2EHnd7jvE8gIGL2qlHjjyJRJqsFW73FDRISPapGPm0n74iGH/I4BU
         BOXAPIcDN6qJr0qSGyzl6+8oMsT/KkwWX5jwqCDzBQJGaCkLX4G3tfe80xrRw5j80mlk
         hzK6BK48EzBqJoAnYOyIFixwCozmdGOhNwMLYeR3DYPJAIhJVniL8FyKoOhXbOBLjZb4
         DmjKSaXgs89smvy8HhmU874l0UAIG+junoxNOS7b9FPQd6+Prwk/Xvam6+MXOHMZu3BP
         lCl0QHMTfFhYGdnZDvd8UTzJprcJON1qgei9L33eU857V4TmXKOiarWKlZV20k9Sj1w4
         B9QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CFI1m1bXGZYKZMu3ppASc24ioDiu36YQQGgUMSxsWQI=;
        b=mb8mUKHT3pQRmod/Gh9sS4pof60qbcdIzDdLCm/7aGXm+PNEG/9rqIjdWfkiETBYB5
         aQ4c5B221QnunFwGG2gIAzAnhLt4LTmJEhvp8iTI7eTJhplTJIyF/1RTIT6E3CuJrzAx
         zBKbDhFXgAAJYubCG/U0wuFEb7AtkV5Nx0J+7NwQvxpDZCyiCidM/hFEUwSzPlwB2lQo
         CqHD20kICKEx3Fj2Hwq3n1M91ainprzbHkxwr/R4T03m7Z5sgZiyy9cFHFh6AsRxBkEN
         8noTUkL4b/jMWtbSw/Qx/oihhkQikqbGu7dCfoprgPUiS4UFMyanBOy5kljB5K+0xwXf
         VaHA==
X-Gm-Message-State: AOAM530R4TmAiHNaG/iEo7zZq0P/qNNHmE5NrO/JiLhkPCBmKvMJHiIr
        8n9mKXm7iLQSgep8WsfTmASCW8GvM211Vvo/PrE=
X-Google-Smtp-Source: ABdhPJxG/g7d0SUPOlZylX53KWmJNDyAVmymN8J4HcFlAbXLbRDKEHmAsJ988BdjbI452PhbZv7i4Lvt8WifPjLg50o=
X-Received: by 2002:a2e:750d:: with SMTP id q13mr892413ljc.448.1591152137654;
 Tue, 02 Jun 2020 19:42:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com> <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
In-Reply-To: <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 10:41:41 +0800
Message-ID: <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
To:     Eric Dumazet <edumazet@google.com>
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

I agree with you. The upstream has already dropped and optimized this
part (commit 864e5c090749), so it would not happen like that. However
the old kernels like LTS still have the problem which causes
large-scale crashes on our thousands of machines after running for a
long while. I will send the fix to the correct tree soon :)

Thanks again,
Jason

On Wed, Jun 3, 2020 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 2, 2020 at 6:53 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > Hi Eric,
> >
> > I'm sorry that I didn't write enough clearly. We're running the
> > pristine 4.19.125 linux kernel (the latest LTS version) and have been
> > haunted by such an issue. This patch is high-important, I think. So
> > I'm going to resend this email with the [patch 4.19] on the headline
> > and cc Greg.
>
> Yes, please always give for which tree a patch is meant for.
>
> Problem is that your patch is not correct.
> In these old kernels, tcp_internal_pacing() is called _after_ the
> packet has been sent.
> It is too late to 'give up pacing'
>
> The packet should not have been sent if the pacing timer is queued
> (otherwise this means we do not respect pacing)
>
> So the bug should be caught earlier. check where tcp_pacing_check()
> calls are missing.
>
>
>
> >
> >
> > Thanks,
> > Jason
> >
> > On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> > > >
> > > > From: Jason Xing <kerneljasonxing@gmail.com>
> > > >
> > > > TCP socks cannot be released because of the sock_hold() increasing the
> > > > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > > > Therefore, this situation could increase the slab memory and then trigger
> > > > the OOM if the machine has beening running for a long time. This issue,
> > > > however, can happen on some machine only running a few days.
> > > >
> > > > We add one exception case to avoid unneeded use of sock_hold if the
> > > > pacing_timer is enqueued.
> > > >
> > > > Reproduce procedure:
> > > > 0) cat /proc/slabinfo | grep TCP
> > > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > > 2) using wrk tool something like that to send packages
> > > > 3) using tc to increase the delay in the dev to simulate the busy case.
> > > > 4) cat /proc/slabinfo | grep TCP
> > > > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > > > 6) at last, you could notice that the number would not decrease.
> > > >
> > > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > ---
> > > >  net/ipv4/tcp_output.c | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > index cc4ba42..5cf63d9 100644
> > > > --- a/net/ipv4/tcp_output.c
> > > > +++ b/net/ipv4/tcp_output.c
> > > > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> > > >         u64 len_ns;
> > > >         u32 rate;
> > > >
> > > > -       if (!tcp_needs_internal_pacing(sk))
> > > > +       if (!tcp_needs_internal_pacing(sk) ||
> > > > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> > > >                 return;
> > > >         rate = sk->sk_pacing_rate;
> > > >         if (!rate || rate == ~0U)
> > > > --
> > > > 1.8.3.1
> > > >
> > >
> > > Hi Jason.
> > >
> > > Please do not send patches that do not apply to current upstream trees.
> > >
> > > Instead, backport to your kernels the needed fixes.
> > >
> > > I suspect that you are not using a pristine linux kernel, but some
> > > heavily modified one and something went wrong in your backports.
> > > Do not ask us to spend time finding what went wrong.
> > >
> > > Thank you.
