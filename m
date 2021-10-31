Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92814410CB
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 21:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhJaUeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 16:34:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJaUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 16:34:16 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F4D6C061714
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:31:44 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id q127so18240541iod.12
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1/o5lXy2iBW9x26oc2y9lWYWR6wMFC7vdzjfL+aYDKg=;
        b=RHCygVaT/v1ntZILHt1wH7YPjTrMDK4gBZ0x27hRr3pgMa7d3zHnR0aWeNzDqe8vjJ
         26k01Tg9PEk440qDQfmASS187BTNZylFJxOs1MUrZUETxvpNYEhYb2nrUTvDHJDilG1O
         mb6KMOby/C9MrTq3IfH2tcBKLIe1W482DrxYw2o7iQm2JGS9exTu2wE0HfnYumKwQtoT
         e8i9vcnYNe9o5G2iUKtXrHWpX8rBRNHoUGrUErm3aDYxq34fWwz2O8ef9VwMsjBjiJji
         iJ450gPx4DH4yipYS7Dni3DISY7gj1JwDRKoIVtvR6ZbIYUNoJKpMfWcmblwd6UcRb2X
         oCsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1/o5lXy2iBW9x26oc2y9lWYWR6wMFC7vdzjfL+aYDKg=;
        b=ZUhqMcIvTJthNIsJw2oDhYKvz2G1bD3Uq1z1DxA/ISmJClDJK66tQG5YtHExiM/U+P
         YLdC3Y3v0f1+MrZ5DRH3XkiVXq3rOAf9hBDsJdN5ZGlH+33bCIznKxWRAORe+vXcMYpR
         dAy99WlH4TXBB0jxVqW6nijIcf9jYbsCfr/CkamUiUhZK1GhuCrQipc0qZYpCuqCwmpT
         B9GHuGI4A26yYuZC0uYZCZgDvb1YCpdxZJq/gngv1VOlyfpadMFn31cNGEphjekVdQsL
         Sry75FnymAJBm4ZA04uVccZI1apz0b8ZYfofE8jvGvZnAZu3CBePqYEqLCEzuTxDWVBq
         ueOA==
X-Gm-Message-State: AOAM5313M1fTaCtkXS6yTIQn+C2fLSMJvCRILxmJx9AXDYlpEeMHiWk0
        reTOCBaWH+anVB7ozYJ4HjsT6IXvEDF9fd+VICM=
X-Google-Smtp-Source: ABdhPJzQPYYX89s5r8dLiJfwa13jvKl8AYUpSYKcNSi45jutXQAHI3BZ2QyxAZENx82y+giXDGHzD9ii5viIM+2WEgQ=
X-Received: by 2002:a5d:928c:: with SMTP id s12mr4640013iom.163.1635712303152;
 Sun, 31 Oct 2021 13:31:43 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191500.47377-1-asadsa@ifi.uio.no> <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
 <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
In-Reply-To: <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 31 Oct 2021 13:31:27 -0700
Message-ID: <CAA93jw4w4bDRU+60f=eObmtRzpxFAo6v+j2As=ZUPGwA486OPA@mail.gmail.com>
Subject: Re: [PATCH net-next] fq_codel: avoid under-utilization with
 ce_threshold at low link rates
To:     Eric Dumazet <edumazet@google.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Asad Sajjad Ahmed <asadsa@ifi.uio.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ingemar Johansson S <ingemar.s.johansson@ericsson.com>,
        Tom Henderson <tomh@tomh.org>,
        Bob Briscoe <research@bobbriscoe.net>,
        Olga Albisser <olga@albisser.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 7:53 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Fri, Oct 29, 2021 at 6:54 AM Neal Cardwell <ncardwell@google.com> wrot=
e:
> >
> > On Thu, Oct 28, 2021 at 3:15 PM Asad Sajjad Ahmed <asadsa@ifi.uio.no> w=
rote:
> > >
> > > Commit "fq_codel: generalise ce_threshold marking for subset of traff=
ic"
> > > [1] enables ce_threshold to be used in the Internet, not just in data
> > > centres.
> > >
> > > Because ce_threshold is in time units, it can cause poor utilization =
at
> > > low link rates when it represents <1 packet.
> > > E.g., if link rate <12Mb/s ce_threshold=3D1ms is <1500B packet.
> > >
> > > So, suppress ECN marking unless the backlog is also > 1 MTU.
> > >
> > > A similar patch to [1] was tested on an earlier kernel, and a similar
> > > one-packet check prevented poor utilization at low link rates [2].
> > >
> > > [1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking f=
or subset of traffic")
> > >
> > > [2] See right hand column of plots at the end of:
> > > https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726.p=
df
> > >
> > > Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
> > > Signed-off-by: Olga Albisser <olga@albisser.org>
> > > ---
> > >  include/net/codel_impl.h | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> > > index 137d40d8cbeb..4e3e8473e776 100644
> > > --- a/include/net/codel_impl.h
> > > +++ b/include/net/codel_impl.h
> > > @@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
> > >                                                     vars->rec_inv_sqr=
t);
> > >         }
> > >  end:
> > > -       if (skb && codel_time_after(vars->ldelay, params->ce_threshol=
d)) {
> > > +       if (skb && codel_time_after(vars->ldelay, params->ce_threshol=
d) &&
> > > +           *backlog > params->mtu) {
>
> I think this idea would apply to codel quite well.  (This helper is
> common to codel and fq_codel)
>
> But with fq_codel my thoughts are:
>
> *backlog is the backlog of the qdisc, not the backlog for the flow,
> and it includes the packet currently being removed from the queue.
>
> Setting ce_threshold to 1ms while the link rate is 12Mbs sounds
> misconfiguration to me.
>
> Even if this flow has to transmit one tiny packet every minute, it
> will get CE mark
> just because at least one packet from an elephant flow is currently
> being sent to the wire.
>
> BQL won't prevent that at least one packet is being processed while
> the tiny packet
> is coming into fq_codel qdisc.
>
> vars->ldelay =3D now - skb_time_func(skb);
>
> For tight ce_threshold, vars->ldelay would need to be replaced by
>
> now - (time of first codel_dequeue() after this skb has been queued).
> This seems a bit hard to implement cheaply.
>
>
>
>
> > >                 bool set_ce =3D true;
> > >
> > >                 if (params->ce_threshold_mask) {
> > > --
> >
> > Sounds like a good idea, and looks good to me.
> >
> > Acked-by: Neal Cardwell <ncardwell@google.com>
> >
> > Eric, what do you think?
> >
> > neal

My 2c:

I would prefer this entire patch series be reverted and put back into
the l4s and BBRv2 trees where it can be thoroughly evaluated, and
appropriate parameterizations found for bare metal DCs, virtualized
environments, hosts and routers at a variety of bandwidths.

I'm not huge on arbitrarily cluttering up the fq_codel hot path, or
the uapi, before that happens.

Also, if anyone has any suggestions as to how to apply this correctly
to the wifi users in the kernel, I'm all ears.

I think a safer path forward in linux mainline would be to remove ECT0
from consideration as RFC3168 ECN in the INET_macros (which all the
existing qdiscs will then pick up) and have the unconfigured linux
hosts and vm substrates across the internet revert to drop in that
case. Prague is defined to revert to reno in that case. Throughput, if
not reductions in local queuing, will be good.

A good test of the ECT0 concept across the wire might be to then have
the in-kernel dctcp instance start using that instead of ECT1 and see
what breaks.

I would appreciate a set of before/after benchmarks on a future submission.

It's otherwise not my call, I do wish more folk would read this (
https://github.com/heistp/l4s-tests#key-findings) before committing
seemingly untested code.

--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
