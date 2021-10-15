Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF3E42EE26
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 11:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233073AbhJOJwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 05:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhJOJwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 05:52:41 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B77CC061570
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:50:35 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id i84so21268497ybc.12
        for <netdev@vger.kernel.org>; Fri, 15 Oct 2021 02:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UT8RdVgLBcblfxNbOLP9gxF1gRakrv96JY7rKpveIUw=;
        b=OO6zRmi+q53vzP8G7F7qO1ac9GUR30iW0Z3X3hwcDMB/9mKe4wkRcG2F37XAZ0kYUd
         rI6clpvMhsytIiImClhs+z27cZexLKF9td5HKC9R6N73d7SUWZUart4TPlOxjfPzhJoB
         2uspDNMxv0s88kxRyv+4a+m0RpkseCdAIeL6W1JapELN3Wxy4y3GW9lXTxdnjFLatBYH
         rJCtR4mn1RNDyyVcteuaFnDg1tI/TxGQ1x9Wj0K37ygjJvJEDGvOkeh9ujoFOPr2IvVX
         +lr8Jb3qeDcXq8vnRXa4xY5OVwnUnrZb05yUMgqylaRqF5Pfw3QbM7gjEZXzIw8mAbqP
         Gk+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UT8RdVgLBcblfxNbOLP9gxF1gRakrv96JY7rKpveIUw=;
        b=0YCvJTMVTxTfIoySZUNpOiv5bJ8KGU/Vj/lTKpderyErlWcdduUqsTRLdmMd5cQDWO
         P0J+H6xiwCbG0Qb83Cbhbm7WHyX3FcySyW0TNH6XktUwL0d8KgIa2C3xsnwxNdj/HOP7
         lY0Qq7V6zlg+qA/huILIJ6i7glnSEN3COvPubLAFwvVxgK85Z1mN84OybwqyOv7g8Jk2
         G3TrsqPxX17Qk6pkDMPPOXLX5JOmeaiRUnJCOl7/iEv37TaR1fNYwiMDXzvc4FLMoY4F
         dQGIUiRn2JSxHkuiz8G0TPqDgyA21nGaXWbk064TSzTv2mElyVGwTGWAshMf5rcllNUi
         yU2w==
X-Gm-Message-State: AOAM530f0sUrwHCfazAtUJoKkrElcuHjvMGJ6WZ8UIZcnRKYUO/clSur
        L1/+8CXTVOVbaanmdoK2ZpCoDpgJBo15nGWAYp1HCg==
X-Google-Smtp-Source: ABdhPJzIAnXpnqh+CVBbB+O563DhW5X4Pc9rAsUYBvAcxL5wC8QN0R8AwEhPpvVR7hlYqh4XQ4dguNJFwphkkQOI4n0=
X-Received: by 2002:a05:6902:701:: with SMTP id k1mr12271553ybt.423.1634291434196;
 Fri, 15 Oct 2021 02:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <20211015090934.2870662-1-zenczykowski@gmail.com> <YWlKGFpHa5o5jFgJ@salvia>
In-Reply-To: <YWlKGFpHa5o5jFgJ@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 15 Oct 2021 02:50:22 -0700
Message-ID: <CANP3RGdCBzjWuK8FfHOOKcFAbd_Zru=DkOBBpD3d_PYDR91P5g@mail.gmail.com>
Subject: Re: [PATCH netfilter] netfilter: conntrack: udp: generate event on
 switch to stream timeout
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 15, 2021 at 2:39 AM Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> On Fri, Oct 15, 2021 at 02:09:34AM -0700, Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > Without this it's hard to offload udp due to lack of a conntrack event
> > at the appropriate time (ie. once udp stream is established and stream
> > timeout is in effect).
> >
> > Without this udp conntrack events 'update/assured/timeout=3D30'
> > either need to be ignored, or polling loop needs to be <30 second
> > instead of <120 second.
> >
> > With this change:
> >       [NEW] udp      17 30 src=3D10.246.11.13 dst=3D216.239.35.0 sport=
=3D37282 dport=3D123 [UNREPLIED] src=3D216.239.35.0 dst=3D10.246.11.13 spor=
t=3D123 dport=3D37282
> >    [UPDATE] udp      17 30 src=3D10.246.11.13 dst=3D216.239.35.0 sport=
=3D37282 dport=3D123 src=3D216.239.35.0 dst=3D10.246.11.13 sport=3D123 dpor=
t=3D37282
> >    [UPDATE] udp      17 30 src=3D10.246.11.13 dst=3D216.239.35.0 sport=
=3D37282 dport=3D123 src=3D216.239.35.0 dst=3D10.246.11.13 sport=3D123 dpor=
t=3D37282 [ASSURED]
> >    [UPDATE] udp      17 120 src=3D10.246.11.13 dst=3D216.239.35.0 sport=
=3D37282 dport=3D123 src=3D216.239.35.0 dst=3D10.246.11.13 sport=3D123 dpor=
t=3D37282 [ASSURED]
> >   [DESTROY] udp      17 src=3D10.246.11.13 dst=3D216.239.35.0 sport=3D3=
7282 dport=3D123 src=3D216.239.35.0 dst=3D10.246.11.13 sport=3D123 dport=3D=
37282 [ASSURED]
> > (the 3rd update/assured/120 event is new)
>
> Hm, I still don't understand why do you need this extra 3rd
> update/assured event event. Could you explain your usecase?

Currently we populate a flow offload array on the assured event, and
thus the flow in both directions starts bypassing the kernel.
Hence conntrack timeout is no longer automatically refreshed - and
there is no opportunity for the timeout to get bumped to the stream
timeout of 120s - it stays at 30s.
We periodically (every just over 60-ish seconds) check whether packets
on a flow have been offloaded, and if so refresh the conntrack
timeout.  This isn't cheap and we don't want to do it even more often.
However this 60s cycle > 30s non-stream udp timeout, so the kernel
conntrack entry expires (and we must thus clear out the flow from the
offload).  This results in a broken udp stream - but only on newer
kernels.  Older kernels don't have this '2s' wait feature (which makes
a lot of sense btw.) but as a result of this the conntrack assured
event happens at the right time - when the timeout hits 120s (or 180s
on even older kernels).

By generating another assured event when the udp stream is 'confirmed'
and the timeout is boosted from 30s to 120s we have an opportunity to
ignore the first one (with timeout 30) and only populate the offload
on the second one (with timeout 120).

I'm not sure if I'm doing a good job of describing this.  Ask again if
it's not clear and I'll try again.

>
> Thanks.
>
> > Cc: Florian Westphal <fw@strlen.de>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > Fixes: d535c8a69c19 'netfilter: conntrack: udp: only extend timeout to =
stream mode after 2s'
> > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> > ---
> >  include/net/netfilter/nf_conntrack.h             |  1 +
> >  .../uapi/linux/netfilter/nf_conntrack_common.h   |  1 +
> >  net/netfilter/nf_conntrack_proto_udp.c           | 16 ++++++++++++++--
> >  3 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilt=
er/nf_conntrack.h
> > index cc663c68ddc4..12029d616cfa 100644
> > --- a/include/net/netfilter/nf_conntrack.h
> > +++ b/include/net/netfilter/nf_conntrack.h
> > @@ -26,6 +26,7 @@
> >
> >  struct nf_ct_udp {
> >       unsigned long   stream_ts;
> > +     bool            notified;
> >  };
> >
> >  /* per conntrack: protocol private data */
> > diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/inclu=
de/uapi/linux/netfilter/nf_conntrack_common.h
> > index 4b3395082d15..a8e91b5821fa 100644
> > --- a/include/uapi/linux/netfilter/nf_conntrack_common.h
> > +++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
> > @@ -144,6 +144,7 @@ enum ip_conntrack_events {
> >       IPCT_SECMARK,           /* new security mark has been set */
> >       IPCT_LABEL,             /* new connlabel has been set */
> >       IPCT_SYNPROXY,          /* synproxy has been set */
> > +     IPCT_UDPSTREAM,         /* udp stream has been set */
> >  #ifdef __KERNEL__
> >       __IPCT_MAX
> >  #endif
> > diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_=
conntrack_proto_udp.c
> > index 68911fcaa0f1..f0d9869aa30f 100644
> > --- a/net/netfilter/nf_conntrack_proto_udp.c
> > +++ b/net/netfilter/nf_conntrack_proto_udp.c
> > @@ -97,18 +97,23 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
> >       if (!timeouts)
> >               timeouts =3D udp_get_timeouts(nf_ct_net(ct));
> >
> > -     if (!nf_ct_is_confirmed(ct))
> > +     if (!nf_ct_is_confirmed(ct)) {
> >               ct->proto.udp.stream_ts =3D 2 * HZ + jiffies;
> > +             ct->proto.udp.notified =3D false;
> > +     }
> >
> >       /* If we've seen traffic both ways, this is some kind of UDP
> >        * stream. Set Assured.
> >        */
> >       if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
> >               unsigned long extra =3D timeouts[UDP_CT_UNREPLIED];
> > +             bool stream =3D false;
> >
> >               /* Still active after two seconds? Extend timeout. */
> > -             if (time_after(jiffies, ct->proto.udp.stream_ts))
> > +             if (time_after(jiffies, ct->proto.udp.stream_ts)) {
> >                       extra =3D timeouts[UDP_CT_REPLIED];
> > +                     stream =3D true;
> > +             }
> >
> >               nf_ct_refresh_acct(ct, ctinfo, skb, extra);
> >
> > @@ -116,9 +121,16 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
> >               if (unlikely((ct->status & IPS_NAT_CLASH)))
> >                       return NF_ACCEPT;
> >
> > +             if (stream) {
> > +                     stream =3D !ct->proto.udp.notified;
> > +                     ct->proto.udp.notified =3D true;
> > +             }
> > +
> >               /* Also, more likely to be important, and not a probe */
> >               if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
> >                       nf_conntrack_event_cache(IPCT_ASSURED, ct);
> > +             else if (stream)
> > +                     nf_conntrack_event_cache(IPCT_UDPSTREAM, ct);
> >       } else {
> >               nf_ct_refresh_acct(ct, ctinfo, skb, timeouts[UDP_CT_UNREP=
LIED]);
> >       }
> > --
> > 2.33.0.1079.g6e70778dc9-goog
> >Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
