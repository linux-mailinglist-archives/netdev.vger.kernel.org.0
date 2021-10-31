Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3103A4410CE
	for <lists+netdev@lfdr.de>; Sun, 31 Oct 2021 21:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhJaUhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Oct 2021 16:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhJaUhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Oct 2021 16:37:32 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A475C061714
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:35:00 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id 62so11821438iou.2
        for <netdev@vger.kernel.org>; Sun, 31 Oct 2021 13:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Q3rDkfABUnYX2MTUBfnSvszui+x338bWgn86oxg04hk=;
        b=Tt4TrzYoOEFWyiFcvVEaCWigpJPxjbg3hpzmDl9+JjgVFGe3nkvBwgYDxMzmUOmUgv
         AFothoKcrC7Ao512WhWk/vIYQtaP8qEkUdJf9KhyKIr4eXqq9gvYXv8MTfzTXMeQmaSZ
         ZP0TdElsgI1QSkCQNHWh+1fGwWsNGMqiyk6LqnTpPaPv7qjXj/0VpLOhSRw8c7wv0RDP
         Nwno2ckVmE6saPsuH/QZ9+AR7Mid/CVehRDHwAdzm+L2HwqF63+c791N/MITDYqeVFeL
         vkCxYP2NgKqD0RPiKQjXc4UFfO0E+ohMYNfFdW/SkjWIiUOW+5e5PAHYGHF1aXyPnTEU
         KOxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Q3rDkfABUnYX2MTUBfnSvszui+x338bWgn86oxg04hk=;
        b=ymSTwnEX2v4l6+YAo1h4ytoMKg5o7fIWiMkk5BjrwLVziE/orkiFeXObougeM5e6SX
         v+Vevd72ok6PAWw0ux55CLz1SsNsb+21ZAG1ceOLtCOkHVnQBX0gu1K4E+X05k1zzcSB
         IFyC1to+4Qb4etpQPL7nXxq2wSGo36NVLtDagE5aR91ykTUUFmxWkGGgucB2dU50DKr5
         K32ykWPnCmcTr1ZM9DX4pCbclkTlDqc4IUdUe18R0+BKrKDLv193iBZCX0pYtfAXdpIZ
         JOWlRe+i6eNt/zkfVpD6qvfc9lsVvdtT9GIiSUrrxEy0tdNDIuOzduyLT886cpiRzTgQ
         IsdQ==
X-Gm-Message-State: AOAM532eb6wBVKCUrEMsVc1/CwhGIBWAYUV82Bu+sFvmnfoQLv9k5QX/
        OsrPGiO3CQug8ESMmWwVTkHgyQ3SH3QSF9NicHI=
X-Google-Smtp-Source: ABdhPJwyE3BocPbCuHSMKzfN+eZaJm+mcR7YqhqSu/guVDheRUZFeLVr0qX/FcxCnfTtQzFdSkmu3O/+bHuZof+b3fM=
X-Received: by 2002:a05:6602:1649:: with SMTP id y9mr4990052iow.133.1635712499366;
 Sun, 31 Oct 2021 13:34:59 -0700 (PDT)
MIME-Version: 1.0
References: <20211028191500.47377-1-asadsa@ifi.uio.no> <CADVnQykDUB4DgUaV0rd6-OKafO+F6w=BRfxviuZ_MJLY3xMV+Q@mail.gmail.com>
 <CANn89iLcTNHCudo-9=RLR1N3o1T0QgVvbedwXeTaFFo5RdMzkg@mail.gmail.com> <CAA93jw4w4bDRU+60f=eObmtRzpxFAo6v+j2As=ZUPGwA486OPA@mail.gmail.com>
In-Reply-To: <CAA93jw4w4bDRU+60f=eObmtRzpxFAo6v+j2As=ZUPGwA486OPA@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sun, 31 Oct 2021 13:34:42 -0700
Message-ID: <CAA93jw7aFAtMjTH9_TutXc85vKW1wwnddR2ARRaxhaczfzF04A@mail.gmail.com>
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

On Sun, Oct 31, 2021 at 1:31 PM Dave Taht <dave.taht@gmail.com> wrote:
>
> On Fri, Oct 29, 2021 at 7:53 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Oct 29, 2021 at 6:54 AM Neal Cardwell <ncardwell@google.com> wr=
ote:
> > >
> > > On Thu, Oct 28, 2021 at 3:15 PM Asad Sajjad Ahmed <asadsa@ifi.uio.no>=
 wrote:
> > > >
> > > > Commit "fq_codel: generalise ce_threshold marking for subset of tra=
ffic"
> > > > [1] enables ce_threshold to be used in the Internet, not just in da=
ta
> > > > centres.
> > > >
> > > > Because ce_threshold is in time units, it can cause poor utilizatio=
n at
> > > > low link rates when it represents <1 packet.
> > > > E.g., if link rate <12Mb/s ce_threshold=3D1ms is <1500B packet.
> > > >
> > > > So, suppress ECN marking unless the backlog is also > 1 MTU.
> > > >
> > > > A similar patch to [1] was tested on an earlier kernel, and a simil=
ar
> > > > one-packet check prevented poor utilization at low link rates [2].
> > > >
> > > > [1] commit dfcb63ce1de6 ("fq_codel: generalise ce_threshold marking=
 for subset of traffic")
> > > >
> > > > [2] See right hand column of plots at the end of:
> > > > https://bobbriscoe.net/projects/latency/dctth_journal_draft20190726=
.pdf
> > > >
> > > > Signed-off-by: Asad Sajjad Ahmed <asadsa@ifi.uio.no>
> > > > Signed-off-by: Olga Albisser <olga@albisser.org>
> > > > ---
> > > >  include/net/codel_impl.h | 3 ++-
> > > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/net/codel_impl.h b/include/net/codel_impl.h
> > > > index 137d40d8cbeb..4e3e8473e776 100644
> > > > --- a/include/net/codel_impl.h
> > > > +++ b/include/net/codel_impl.h
> > > > @@ -248,7 +248,8 @@ static struct sk_buff *codel_dequeue(void *ctx,
> > > >                                                     vars->rec_inv_s=
qrt);
> > > >         }
> > > >  end:
> > > > -       if (skb && codel_time_after(vars->ldelay, params->ce_thresh=
old)) {
> > > > +       if (skb && codel_time_after(vars->ldelay, params->ce_thresh=
old) &&
> > > > +           *backlog > params->mtu) {
> >
> > I think this idea would apply to codel quite well.  (This helper is
> > common to codel and fq_codel)
> >
> > But with fq_codel my thoughts are:
> >
> > *backlog is the backlog of the qdisc, not the backlog for the flow,
> > and it includes the packet currently being removed from the queue.
> >
> > Setting ce_threshold to 1ms while the link rate is 12Mbs sounds
> > misconfiguration to me.
> >
> > Even if this flow has to transmit one tiny packet every minute, it
> > will get CE mark
> > just because at least one packet from an elephant flow is currently
> > being sent to the wire.
> >
> > BQL won't prevent that at least one packet is being processed while
> > the tiny packet
> > is coming into fq_codel qdisc.
> >
> > vars->ldelay =3D now - skb_time_func(skb);
> >
> > For tight ce_threshold, vars->ldelay would need to be replaced by
> >
> > now - (time of first codel_dequeue() after this skb has been queued).
> > This seems a bit hard to implement cheaply.
> >
> >
> >
> >
> > > >                 bool set_ce =3D true;
> > > >
> > > >                 if (params->ce_threshold_mask) {
> > > > --
> > >
> > > Sounds like a good idea, and looks good to me.
> > >
> > > Acked-by: Neal Cardwell <ncardwell@google.com>
> > >
> > > Eric, what do you think?
> > >
> > > neal
>
> My 2c:


sigh, I got my bits flipped.

>
> I would prefer this entire patch series be reverted and put back into
> the l4s and BBRv2 trees where it can be thoroughly evaluated, and
> appropriate parameterizations found for bare metal DCs, virtualized
> environments, hosts and routers at a variety of bandwidths.
>
> I'm not huge on arbitrarily cluttering up the fq_codel hot path, or
> the uapi, before that happens.
>
> Also, if anyone has any suggestions as to how to apply this correctly
> to the wifi users in the kernel, I'm all ears.
>
> I think a safer path forward in linux mainline would be to remove ECT0
> from consideration as RFC3168 ECN in the INET_macros (which all the
> existing qdiscs will then pick up) and have the unconfigured linux
> hosts and vm substrates across the internet revert to drop in that
> case. Prague is defined to revert to reno in that case. Throughput, if
> not reductions in local queuing, will be good.
>
> A good test of the ECT0 concept across the wire might be to then have
> the in-kernel dctcp instance start using that instead of ECT1 and see
> what breaks.
>
> I would appreciate a set of before/after benchmarks on a future submissio=
n.
>
> It's otherwise not my call, I do wish more folk would read this (
> https://github.com/heistp/l4s-tests#key-findings) before committing
> seemingly untested code.
>
> --
> I tried to build a better future, a few times:
> https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org
>
> Dave T=C3=A4ht CEO, TekLibre, LLC



--=20
I tried to build a better future, a few times:
https://wayforward.archive.org/?site=3Dhttps%3A%2F%2Fwww.icei.org

Dave T=C3=A4ht CEO, TekLibre, LLC
