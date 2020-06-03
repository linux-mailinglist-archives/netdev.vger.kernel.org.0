Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6D01EC79B
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725888AbgFCCst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:48:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgFCCss (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:48:48 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A266C08C5C0;
        Tue,  2 Jun 2020 19:48:46 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id x27so321612lfg.9;
        Tue, 02 Jun 2020 19:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qOKDoSBli51DIYrV+/BavzMGsCzLxEyswY3rhX9J9ow=;
        b=Gx0lYwEtK90Rb0yiyibESharhnlq10cu1Vm+7kmCldA8wec3RaQhwNC4tEZ50QtqXZ
         Gho4AG3lV1xP1aywWnQ9hOnEcgEicQmuybc1gw5JYs1dBK9w6S9P1AOrb1muq3pP0+2J
         REmBJfOZsdQkhCsJZDfI9XeMiEYNfaZF9inHo4zcZvi8yL+OU0KtIFPMgQS1rfUgJwuK
         tKGfzpYOUxtC7SUiCPkp3U5XUtqkMA9dOM6aPxDzsDmgGfKflqVS+GEWTw1KZ2lAg4u2
         9xZbY4IuRftBnRNDuvvvjZKRz0tHXW0NcIrmujQQGbX4hy9JpQDF2JHEHcR0e0fHHIJK
         rbFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qOKDoSBli51DIYrV+/BavzMGsCzLxEyswY3rhX9J9ow=;
        b=e+zlA6nKkSkvPbKOxLE+j9GaoWgbON/iZO766H0FAjujilFtw98M204Ej6EfYx8n8c
         5U2/oTuLolYLBvNGf0Xo6lkTD1JRnwSoUFNU53AwVimnAn0FyRzG2zR6BEaBDBBeL/69
         94zZj+76TOL++W1YHJUxjIdW4rcKIvljnT4z8Wiy798ILdIQrqKSl8mNI/BJOCzhZHy4
         Dve1pH0bO0dU7XS20uBgLHA2JK4c7ARcSWqxm2VmzhR3ZAhF53yH7nQ207lC9bZ4h66n
         rV+p89e1A6e8b2RQSh1ggkpbA+uHAOdi4N8VloZkHCNVNeokzI3pCUcFpOzLgFLH+imP
         Pn+g==
X-Gm-Message-State: AOAM5338M+W/hzlIMq1UpIPCtG20i6KRVVkaZuZTH4XjSSPqE/CHdapp
        AVyMdiRStrxA28E+YZd4XM5ksiMXiK7349y2rb9ukV74dzI=
X-Google-Smtp-Source: ABdhPJzHkx4QSbOwKRlmc2dsSKv8eGkWRny1QukE6QfFG2NvoJTI9BvnFWYYyY7PVy9LxWaRIbOVSbE3jekyVVuIvC8=
X-Received: by 2002:a19:f017:: with SMTP id p23mr1172772lfc.79.1591152525110;
 Tue, 02 Jun 2020 19:48:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com> <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
In-Reply-To: <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 10:48:08 +0800
Message-ID: <CAL+tcoB2_4H4gOgn-M_693qZmKF+Fk=Wxc+e02Q=K3JkkvQGMQ@mail.gmail.com>
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

Thanks for reminding me.
I will test the cases through using sch_fq.

Jason

On Wed, Jun 3, 2020 at 10:44 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Jun 2, 2020 at 7:42 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > I agree with you. The upstream has already dropped and optimized this
> > part (commit 864e5c090749), so it would not happen like that. However
> > the old kernels like LTS still have the problem which causes
> > large-scale crashes on our thousands of machines after running for a
> > long while. I will send the fix to the correct tree soon :)
>
> If you run BBR at scale (thousands of machines), you probably should
> use sch_fq instead of internal pacing,
> just saying ;)
>
>
> >
> > Thanks again,
> > Jason
> >
> > On Wed, Jun 3, 2020 at 10:29 AM Eric Dumazet <edumazet@google.com> wrote:
> > >
> > > On Tue, Jun 2, 2020 at 6:53 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> > > >
> > > > Hi Eric,
> > > >
> > > > I'm sorry that I didn't write enough clearly. We're running the
> > > > pristine 4.19.125 linux kernel (the latest LTS version) and have been
> > > > haunted by such an issue. This patch is high-important, I think. So
> > > > I'm going to resend this email with the [patch 4.19] on the headline
> > > > and cc Greg.
> > >
> > > Yes, please always give for which tree a patch is meant for.
> > >
> > > Problem is that your patch is not correct.
> > > In these old kernels, tcp_internal_pacing() is called _after_ the
> > > packet has been sent.
> > > It is too late to 'give up pacing'
> > >
> > > The packet should not have been sent if the pacing timer is queued
> > > (otherwise this means we do not respect pacing)
> > >
> > > So the bug should be caught earlier. check where tcp_pacing_check()
> > > calls are missing.
> > >
> > >
> > >
> > > >
> > > >
> > > > Thanks,
> > > > Jason
> > > >
> > > > On Tue, Jun 2, 2020 at 9:05 PM Eric Dumazet <edumazet@google.com> wrote:
> > > > >
> > > > > On Tue, Jun 2, 2020 at 1:05 AM <kerneljasonxing@gmail.com> wrote:
> > > > > >
> > > > > > From: Jason Xing <kerneljasonxing@gmail.com>
> > > > > >
> > > > > > TCP socks cannot be released because of the sock_hold() increasing the
> > > > > > sk_refcnt in the manner of tcp_internal_pacing() when RTO happens.
> > > > > > Therefore, this situation could increase the slab memory and then trigger
> > > > > > the OOM if the machine has beening running for a long time. This issue,
> > > > > > however, can happen on some machine only running a few days.
> > > > > >
> > > > > > We add one exception case to avoid unneeded use of sock_hold if the
> > > > > > pacing_timer is enqueued.
> > > > > >
> > > > > > Reproduce procedure:
> > > > > > 0) cat /proc/slabinfo | grep TCP
> > > > > > 1) switch net.ipv4.tcp_congestion_control to bbr
> > > > > > 2) using wrk tool something like that to send packages
> > > > > > 3) using tc to increase the delay in the dev to simulate the busy case.
> > > > > > 4) cat /proc/slabinfo | grep TCP
> > > > > > 5) kill the wrk command and observe the number of objects and slabs in TCP.
> > > > > > 6) at last, you could notice that the number would not decrease.
> > > > > >
> > > > > > Signed-off-by: Jason Xing <kerneljasonxing@gmail.com>
> > > > > > Signed-off-by: liweishi <liweishi@kuaishou.com>
> > > > > > Signed-off-by: Shujin Li <lishujin@kuaishou.com>
> > > > > > ---
> > > > > >  net/ipv4/tcp_output.c | 3 ++-
> > > > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > > > >
> > > > > > diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> > > > > > index cc4ba42..5cf63d9 100644
> > > > > > --- a/net/ipv4/tcp_output.c
> > > > > > +++ b/net/ipv4/tcp_output.c
> > > > > > @@ -969,7 +969,8 @@ static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
> > > > > >         u64 len_ns;
> > > > > >         u32 rate;
> > > > > >
> > > > > > -       if (!tcp_needs_internal_pacing(sk))
> > > > > > +       if (!tcp_needs_internal_pacing(sk) ||
> > > > > > +           hrtimer_is_queued(&tcp_sk(sk)->pacing_timer))
> > > > > >                 return;
> > > > > >         rate = sk->sk_pacing_rate;
> > > > > >         if (!rate || rate == ~0U)
> > > > > > --
> > > > > > 1.8.3.1
> > > > > >
> > > > >
> > > > > Hi Jason.
> > > > >
> > > > > Please do not send patches that do not apply to current upstream trees.
> > > > >
> > > > > Instead, backport to your kernels the needed fixes.
> > > > >
> > > > > I suspect that you are not using a pristine linux kernel, but some
> > > > > heavily modified one and something went wrong in your backports.
> > > > > Do not ask us to spend time finding what went wrong.
> > > > >
> > > > > Thank you.
