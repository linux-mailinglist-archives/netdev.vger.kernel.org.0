Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337DF1EC88F
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725905AbgFCFFo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:05:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgFCFFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:05:44 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31CEC05BD43;
        Tue,  2 Jun 2020 22:05:43 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z206so469525lfc.6;
        Tue, 02 Jun 2020 22:05:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cJyqSf+S/kkiuR8jlqaM5ACA5juCm28yi6KSRgY87Jo=;
        b=LB6Su5bCu23bD/EWMNFe32yZlC81ypLGMWUTTkkVGGkiaM/Ld0gD3yyLGghMihDcAQ
         1gnigEsR09fOJTCebUgWv+WTUXuCaVKA6LGVLnHNnKXe1Yvs+kPZQ2Ga+nKoryViZYHY
         FnyOABaOTOQqn0rqXUKOeJWBcr7bYEShG2LgRczDOggb+0JElBUWpdW2p7ktCPrI4LPB
         ZnQcmtFEKzh8ep8IUUnemJKwfwW/MJnGqCv3Ve4Gm+eT7gjjITtSpTg9RSzIm5CtcbrO
         +PZV1Y/HJVSCN5EStlN2hozeusdlSd1iRsydaJgZhhIiRo5Bj9kMFUZdqS5jQAQSIjIa
         pPuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cJyqSf+S/kkiuR8jlqaM5ACA5juCm28yi6KSRgY87Jo=;
        b=hTxm898wSLxNKKWp4GhLmK2T9Vvd4cRgueXWgE01iUvDL5U+yR8z0X6xZpQOwmupeA
         70uYuDrjTb5CrRXR5SlnmshyUMjCXH1IOKwmEk7Chf7WIVsfYhSDEOMoIwMUmLOssZ2U
         hXmGnhPTdY9f8ZGonfRim7WEYNGm9XvKFvq19WClxoA8hxIIPvQUSUVBeh1jOV50SQjD
         OxW/TGORxCj2P+1VU8oh1cbd3evqL4BE1AgdL67FFS+ETOjbBxDNPHcR2f/JgXezOG40
         T2gUHHMiL6r3ls+HsGEtOt3qeUDcVqxTeDbCbjhY3cYR3qF1WKIk3SmpBD7mWw2nW5KH
         3UUQ==
X-Gm-Message-State: AOAM533Z0+8U26/wpd6BxkKjov+drEuxKd0mMLm8opvVvFA+afb947Ra
        q3rE1lv9DBtdVkN8ISb6sH7QK/L2e00jBjiXMxc=
X-Google-Smtp-Source: ABdhPJwpRj/U5VDzgT5X2VnWNjOsWcW4/+UvkO60CxKaOuqe0sVov63gSencvYqwOKYNwtgMjRUkDx21pN0pXBj8J9A=
X-Received: by 2002:ac2:55b2:: with SMTP id y18mr1423165lfg.55.1591160742095;
 Tue, 02 Jun 2020 22:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
 <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
 <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
 <CANn89iKDKnnW1na_F0ngGh3EEc0quuBB2XWo21oAKaHckdPK4w@mail.gmail.com>
 <CAL+tcoDn_=T--uB0CRymfTGvD022PPDk5Yw2yCxvqOOpZ4G_dQ@mail.gmail.com> <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
In-Reply-To: <CANn89i+dPu9=qJowhRVm9d3CesY4p+zzJ0HGiCMc_yJxux6pow@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Wed, 3 Jun 2020 13:05:05 +0800
Message-ID: <CAL+tcoC2+vYoFbujkLCF7P3evfirNSBQtJ9bPFHiU2FGOnBo+A@mail.gmail.com>
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

Hi Eric,

I'm still trying to understand what you're saying before. Would this
be better as following:
1) discard the tcp_internal_pacing() function.
2) remove where the tcp_internal_pacing() is called in the
__tcp_transmit_skb() function.

If we do so, we could avoid 'too late to give up pacing'. Meanwhile,
should we introduce the tcp_wstamp_ns socket field as commit
(864e5c090749) does?

Thanks,
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
