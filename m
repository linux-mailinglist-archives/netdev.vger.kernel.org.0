Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424DA1EC78A
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgFCCoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:44:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgFCCoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:44:12 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28118C08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 19:44:12 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id k18so245395ybm.13
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 19:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+dgxTQh3Md4txrn7hnHhPbJC7jZ8erDmqs6r1XjY71Y=;
        b=LWEWDdog0PLIePxPYC/qcMr2Z+5wD12p2iU8eCSGIxrWqHCjZs6MlG4TCDgDA2g2dW
         vHb72hAlYE95JxAp0q0Nk3IOH4AU97jEcmDZt6mQMsZtL2Z+iB33/gwuLy+pRbtvr9sY
         zGW1w08gMbNrub35uc64KFo6IBZFLh562CUC/5WQ9POx1XHWpjmusI+qVaoD/rKb79Tv
         Bi96q4ZCBfk1ye28aRgI9/Nlnm02zLOHVLY0Vg6uekHfmXJILoj6xa3bFISdfw84ttyq
         bcQFDICW0e700j7cE6GFou1BKjSq3hJlMvX+U8loxTgGGtphyC3Du83f3AkS9SUCON+0
         iAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+dgxTQh3Md4txrn7hnHhPbJC7jZ8erDmqs6r1XjY71Y=;
        b=sRf0EleYs27gupSK+uy6U/tewR1gSNc9FkBAN/nEfz9VIGO8ApJypniJNtty7s6W2l
         vH9XM3+1cbkvC8MmANr+bC9iPHGU1AWRHILtSKuAEV/1TrCw/Sinx254y8927L3pWAQJ
         ARc8vv6X13fcXiqhuHOcM+omuahOLArohhUBl7bTCKXo/R/VwwPyVONWTySBEo20jP7e
         k7Bi4fl8E5pXsDASCF/9hnMZb2+bfGE8wVxW+m8W7pFGrSKvQFiI6hEYTkQTIK4YR3wL
         iz44KcI3P4jaVfcceQ8xmgrNDtOYxVBEnLQcsNqVS7jH0SHo0Va1QSffpjMLsovdauxp
         knuw==
X-Gm-Message-State: AOAM5314ag++/t5daFDmrnkoe2Ihb9DU/mXwMSWaux2iexcn+90cKgQT
        cd2jsyMBI3QZsl5lPPnsNo8yrp0d3EOrXKy/n95OQA==
X-Google-Smtp-Source: ABdhPJwdbz1eyTSZklSm6NBQdG/S5eHldNBGCLX2VMUQcLkVrfA10ESUpWhpbCmSFBBniAlI779bNyR7JygOAFdawx4=
X-Received: by 2002:a25:ec0d:: with SMTP id j13mr6201342ybh.364.1591152251099;
 Tue, 02 Jun 2020 19:44:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com> <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
In-Reply-To: <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 2 Jun 2020 19:43:59 -0700
Message-ID: <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
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

On Tue, Jun 2, 2020 at 7:42 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
>
> I agree with you. The upstream has already dropped and optimized this
> part (commit 864e5c090749), so it would not happen like that. However
> the old kernels like LTS still have the problem which causes
> large-scale crashes on our thousands of machines after running for a
> long while. I will send the fix to the correct tree soon :)

If you run BBR at scale (thousands of machines), you probably should
use sch_fq instead of internal pacing,
just saying ;)


>
> Thanks again,
> Jason
>
> On Wed, Jun 3, 2020 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Tue, Jun 2, 2020 at 6:53 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > >
> > > Hi Eric,
> > >
> > > I'm sorry that I didn't write enough clearly. We're running the
> > > pristine 4.19.125 linux kernel (the latest LTS version) and have been
> > > haunted by such an issue. This patch is high-important, I think. So
> > > I'm going to resend this email with the [patch 4.19] on the headline
> > > and cc Greg.
> >
> > Yes, please always give for which tree a patch is meant for.
> >
> > Problem is that your patch is not correct.
> > In these old kernels, tcp_internal_pacing() is called _after_ the
> > packet has been sent.
> > It is too late to 'give up pacing'
> >
> > The packet should not have been sent if the pacing timer is queued
> > (otherwise this means we do not respect pacing)
> >
> > So the bug should be caught earlier. check where tcp_pacing_check()
> > calls are missing.
> >
> >
> >
> > >
> > >
> > > Thanks,
> > > Jason
> > >
> > > On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
> > > >
> > > > On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> > > > >
> > > > > From: Jason Xing <kerneljasonxing@gmail.com>
> > > > >
> > > > > TCP socks cannot be released because of the sock_hold() increasing the
> > > > > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > > > > Therefore, this situation could increase the slab memory and then trigger
> > > > > the OOM if the machine has beening running for a long time. This issue,
> > > > > however, can happen on some machine only running a few days.
> > > > >
> > > > > We add one exception case to avoid unneeded use of sock_hold if the
> > > > > pacing_timer is enqueued.
> > > > >
> > > > > Reproduce procedure:
> > > > > 0) cat /proc/slabinfo | grep TCP
> > > > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > > > 2) using wrk tool something like that to send packages
> > > > > 3) using tc to increase the delay in the dev to simulate the busy case.
> > > > > 4) cat /proc/slabinfo | grep TCP
> > > > > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > > > > 6) at last, you could notice that the number would not decrease.
> > > > >
> > > > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > > ---
> > > > >  net/ipv4/tcp_output.c | 3 ++-
> > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > >
> > > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > > index cc4ba42..5cf63d9 100644
> > > > > --- a/net/ipv4/tcp_output.c
> > > > > +++ b/net/ipv4/tcp_output.c
> > > > > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> > > > >         u64 len_ns;
> > > > >         u32 rate;
> > > > >
> > > > > -       if (!tcp_needs_internal_pacing(sk))
> > > > > +       if (!tcp_needs_internal_pacing(sk) ||
> > > > > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> > > > >                 return;
> > > > >         rate = sk->sk_pacing_rate;
> > > > >         if (!rate || rate == ~0U)
> > > > > --
> > > > > 1.8.3.1
> > > > >
> > > >
> > > > Hi Jason.
> > > >
> > > > Please do not send patches that do not apply to current upstream trees.
> > > >
> > > > Instead, backport to your kernels the needed fixes.
> > > >
> > > > I suspect that you are not using a pristine linux kernel, but some
> > > > heavily modified one and something went wrong in your backports.
> > > > Do not ask us to spend time finding what went wrong.
> > > >
> > > > Thank you.
