Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5435727AFB1
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 16:07:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgI1OHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 10:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgI1OHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 10:07:15 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501A6C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 07:07:15 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b124so1106225pfg.13
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 07:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dyCb5D0V0/zNyW2Ax3egfzB7ATnuo98KnwqMSc7b3/M=;
        b=YAQl4xXicOVp1YpZbEDv2D2QGPrRcuL5EGCU117eWbBAt0O9HAflc42Exak2yXRXwl
         Es8hmXEiBlwX+mpCDeYn45FMbCwuKtnVqtsMOSXuyPRMkK/DNFWpq2Gq7a113+BH1mjP
         KCh2mM8NDON2FpXUG+UGJ4FSv38kHnFHxdtmOPAt0Axqa/zD1BkkOlWnO+jNHKo/yuvG
         ztC414XDmErT6qfnx7jX7lgJw0iy2lxfMZ3880FlY1e7xeMtE+ZxuE5ZUEkccoHrn4oi
         b+g3mGdRTOqC9DyXPg2HlV269Lc2zW3NQfj/rWdul0/3TyHb+e2e7QOXCcqGdv/xhhdm
         DRzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dyCb5D0V0/zNyW2Ax3egfzB7ATnuo98KnwqMSc7b3/M=;
        b=GlKDLZyCI6GjKZhlSkSAOsmkj487gYvYBCkRpt1mWkbCoXhXGErZ4Dae70rFrHPTHF
         oO6yRykndElVnuVlbCskFnVNoIt6I37tM69gf5ZB1W27buP/bTYH4UHKlYLST3u1whk1
         Sdz64nzm9bGZeHAxOfPNRhl37f0Qy5D9UWK6FFvLO9+n6rynRznTpt5ZzEHJgyNc40jt
         6RDMYcY0culBvP4DEueyeMv0wA8yGhYT5JGsFpcY7bZGebWRpxJIcRYkOt0i0RBbTPAu
         K9bul/iNDFIeKAnTWPPHtnSrR8bTcUtA0akOV78P4eH1NiE/V5R+vFl9mmO5mNIojdLU
         4p+w==
X-Gm-Message-State: AOAM532NxDAaSqgrxIMmlt3n99cJjcwIyc/o4KRvUJu/XSsPiG48lAe/
        6Yja5ETeCnfISRzpnil6RNaRmZgIDVq8gzABGwFf56PDUJ4=
X-Google-Smtp-Source: ABdhPJxQbX5Ih+eDPL4udmQ3pIV2Mpr7EAQWQLVKb+K3AESs+Dpoa5Xy/lVFzHEzJnQvK3wkIOAoUBWgrDb8aKs0gbU=
X-Received: by 2002:a65:5bcf:: with SMTP id o15mr1258330pgr.126.1601302034688;
 Mon, 28 Sep 2020 07:07:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com> <CAJ8uoz30afXpbn+RXwN5BNMwrLAcW0Cn8tqP502oCLaKH0+kZg@mail.gmail.com>
 <20200925120652.10b8d7c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200925120652.10b8d7c5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 28 Sep 2020 16:07:03 +0200
Message-ID: <CAJ8uoz0ZMdFkFooipvJphFKH9XP9qEc7vApfjkGu6hC0usHDRQ@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] implement kthread based napi poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 25, 2020 at 9:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 25 Sep 2020 15:48:35 +0200 Magnus Karlsson wrote:
> > I really like this RFC and would encourage you to submit it as a
> > patch. Would love to see it make it into the kernel.
> >
> > I see the same positive effects as you when trying it out with AF_XDP
> > sockets. Made some simple experiments where I sent 64-byte packets to
> > a single AF_XDP socket. Have not managed to figure out how to do
> > percentiles on my load generator, so this is going to be min, avg and
> > max only. The application using the AF_XDP socket just performs a mac
> > swap on the packet and sends it back to the load generator that then
> > measures the round trip latency. The kthread is taskset to the same
> > core as ksoftirqd would run on. So in each experiment, they always run
> > on the same core id (which is not the same as the application).
> >
> > Rate 12 Mpps with 0% loss.
> >               Latencies (us)         Delay Variation between packets
> >           min    avg    max      avg   max
> > sofirq  11.0  17.1   78.4      0.116  63.0
> > kthread 11.2  17.1   35.0     0.116  20.9
> >
> > Rate ~58 Mpps (Line rate at 40 Gbit/s) with substantial loss
> >               Latencies (us)         Delay Variation between packets
> >           min    avg    max      avg   max
> > softirq  87.6  194.9  282.6    0.062  25.9
> > kthread  86.5  185.2  271.8    0.061  22.5
> >
> > For the last experiment, I also get 1.5% to 2% higher throughput with
> > your kthread approach. Moreover, just from the per-second throughput
> > printouts from my application, I can see that the kthread numbers are
> > more stable. The softirq numbers can vary quite a lot between each
> > second, around +-3%. But for the kthread approach, they are nice and
> > stable. Have not examined why.
>
> Sure, it's better than status quo for AF_XDP but it's going to be far
> inferior to well implemented busy polling.

Agree completely. Bj=C3=B6rn is looking into this at the moment, so I will
let him comment on it and post some patches.

> We already discussed the potential scheme with Bjorn, since you prompted
> me again, let me shoot some code from the hip at ya:
>
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 74ce8b253ed6..8dbdfaeb0183 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -6668,6 +6668,7 @@ static struct napi_struct *napi_by_id(unsigned int =
napi_id)
>
>  static void busy_poll_stop(struct napi_struct *napi, void *have_poll_loc=
k)
>  {
> +       unsigned long to;
>         int rc;
>
>         /* Busy polling means there is a high chance device driver hard i=
rq
> @@ -6682,6 +6683,13 @@ static void busy_poll_stop(struct napi_struct *nap=
i, void *have_poll_lock)
>         clear_bit(NAPI_STATE_MISSED, &napi->state);
>         clear_bit(NAPI_STATE_IN_BUSY_POLL, &napi->state);
>
> +       if (READ_ONCE(napi->dev->napi_defer_hard_irqs)) {
> +               netpoll_poll_unlock(have_poll_lock);
> +               to =3D ns_to_ktime(READ_ONCE(napi->dev->gro_flush_timeout=
));
> +               hrtimer_start(&n->timer, to, HRTIMER_MODE_REL_PINNED);
> +               return;
> +       }
> +
>         local_bh_disable();
>
>         /* All we really want here is to re-enable device interrupts.
>
>
> With basic busy polling implemented for AF_XDP this is all** you need
> to make busy polling work very well.
>
> ** once bugs are fixed :D I haven't even compiled this
>
> Eric & co. already implemented hard IRQ deferral. All we need to do is
> push the timer away when application picks up frames. I think.
>
> Please, no loose threads for AF_XDP apps (or other busy polling apps).
> Let the application burn 100% of the core :(
