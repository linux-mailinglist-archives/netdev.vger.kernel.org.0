Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3CFD46C984
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhLHAsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbhLHAsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:48:14 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C77C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 16:44:43 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id j14so1791227uan.10
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 16:44:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MnyfDWmiPRytUTG///qgWK+psbnI5BOfM3DkcG3VNiU=;
        b=JTVIiGJuBAZX9tsqMMYpvO//8IrU+mlzelA2Ih+CiK5VZqkiHqpy+OBtUzA3rAU8Gk
         8uyIhOfcMLSjpAnOluzYc+noHncdsVjU8f5OwuecxJu35Wzrk5E8I2VmLSfrN2ZohpzB
         j2jjmDJH6fUIXASVla2uW0x+36ibchRslofb1h82xYxUw5rnUT+Sfx3jAMqcJuir69Om
         gaQ64580d1Gr1koN3Uu0Cfylw0vVm/M11VzK5kirsMRQbMsYXllimjuuV/ZrulfY5iB3
         b17ec+z/qXBrho/lEgzQgbMDEt937DvF9IzEh7Fglv42p/a0QgjK9f8wRooIx5glVoNJ
         Guvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MnyfDWmiPRytUTG///qgWK+psbnI5BOfM3DkcG3VNiU=;
        b=vifNkp2XZjgZS8VMtkGaWdF72S2qWVqz1GfqMikJ/XYB1vKAs+1gdOggsYjUoj8nnO
         Wn/4IjWo7XQJvbVz5UL/YuRx00IijQi+J3VO2FLeZwU1HPqMicVuo8EGidvNJRpq9+yL
         MgOk8hXwkqPz1V0vymWLuf1YMNE8/wME8POW0SbkQaAqO0LHt+4B3EV9lkcvWIdGxOtk
         hvC6001pa68tVWngblAs/XZi7y7rpSr3jJpj/7Q3Cb37TiHKnm+GZoyVpegSAyK5DH4i
         iX2kOFnEYlwH+bVEXodt0G1yjA1/mC7t1eZ8sNU4W9FpI1FB22mzlO/E4YxCgqjSoQ2T
         Grhw==
X-Gm-Message-State: AOAM531HF+wrspSF2VKekNbxLkVH6wNP9I7OR3XFSdx0ZarbFzb/cW1T
        Qop+GkwBl4J/wEUDLcLedOSzdOugNR4=
X-Google-Smtp-Source: ABdhPJxxJL/66FDDEpH2OPvhzhYr95rRGlL5apgKgI7ERTMCKQhzjkA8DyHfMT+Oz8d4NuJJS83bBw==
X-Received: by 2002:ab0:35e8:: with SMTP id w8mr3883921uau.31.1638924282965;
        Tue, 07 Dec 2021 16:44:42 -0800 (PST)
Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com. [209.85.222.41])
        by smtp.gmail.com with ESMTPSA id v7sm798173uaj.13.2021.12.07.16.44.42
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:44:42 -0800 (PST)
Received: by mail-ua1-f41.google.com with SMTP id a14so1957613uak.0
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 16:44:42 -0800 (PST)
X-Received: by 2002:a67:a409:: with SMTP id n9mr49220822vse.74.1638924282242;
 Tue, 07 Dec 2021 16:44:42 -0800 (PST)
MIME-Version: 1.0
References: <20211207020102.3690724-1-kafai@fb.com> <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com> <20211208000757.c5oshpdxud6rbzuv@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211208000757.c5oshpdxud6rbzuv@kafai-mbp.dhcp.thefacebook.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 7 Dec 2021 19:44:05 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfBTQ+G3i6j8LPi7PHZWnSx5msdMYoUURdp5Z2d3S6gDA@mail.gmail.com>
Message-ID: <CA+FuTSfBTQ+G3i6j8LPi7PHZWnSx5msdMYoUURdp5Z2d3S6gDA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > -static inline ktime_t skb_get_ktime(const struct sk_buff *skb)
> > > +static inline ktime_t skb_get_ktime(struct sk_buff *skb)
> > >  {
> > > +       if (unlikely(skb->fwd_tstamp))
> > > +               net_timestamp_set(skb);
> > >         return ktime_mono_to_real_cond(skb->tstamp);
> >
> > This changes timestamp behavior for existing applications, probably
> > worth mentioning in the commit message if nothing else. A timestamp
> > taking at the time of the recv syscall is not very useful.
> >
> > If a forwarded timestamp is not a future delivery time (as those are
> > scrubbed), is it not correct to just deliver the original timestamp?
> > It probably was taken at some earlier __netif_receive_skb_core.
> Make sense.  I will compare with the current mono clock first before
> resetting and also mention this behavior change in the commit message.
>
> Do you think it will be too heavy to always compare with
> the current time without testing the skb->fwd_tstamp bit
> first?

There are other examples of code using ktime_get and variants in the
hot path, such as FQ.

Especially if skb_get_ktime is called in recv() timestamp helpers, it
is perhaps acceptable. If not ideal. If we need an skb bit anyway,
then this is moot.

> >
> > >  }
> > >
> > > -static inline void net_timestamp_set(struct sk_buff *skb)
> > > +void net_timestamp_set(struct sk_buff *skb)
> > >  {
> > >         skb->tstamp = 0;
> > > +       skb->fwd_tstamp = 0;
> > >         if (static_branch_unlikely(&netstamp_needed_key))
> > >                 __net_timestamp(skb);
> > >  }
> > > +EXPORT_SYMBOL(net_timestamp_set);
> > >
> > >  #define net_timestamp_check(COND, SKB)                         \
> > >         if (static_branch_unlikely(&netstamp_needed_key)) {     \
> > > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > > index f091c7807a9e..181ddc989ead 100644
> > > --- a/net/core/skbuff.c
> > > +++ b/net/core/skbuff.c
> > > @@ -5295,8 +5295,12 @@ void skb_scrub_tstamp(struct sk_buff *skb)
> > >  {
> > >         struct sock *sk = skb->sk;
> > >
> > > -       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME))
> > > +       if (sk && sk_fullsock(sk) && sock_flag(sk, SOCK_TXTIME)) {
> >
> > There is a slight race here with the socket flipping the feature on/off.
> Right, I think it is an inherited race by relating skb->tstamp with
> a bit in sk, like the existing sch_etf.c.
> Directly setting a bit in skb when setting the skb->tstamp will help.
>
> >
> > >
> > >                 skb->tstamp = 0;
> > > +               skb->fwd_tstamp = 0;
> > > +       } else if (skb->tstamp) {
> > > +               skb->fwd_tstamp = 1;
> > > +       }
> >
> > SO_TXTIME future delivery times are scrubbed, but TCP future delivery
> > times are not?
> It is not too much about scrubbing future SO_TXTIME or future TCP
> delivery time for the local delivery.

The purpose of the above is to reset future delivery time whenever it
can be mistaken for a timestamp, right?

This function is called on forwarding, redirection, looping from
egress to ingress with __dev_forward_skb, etc. But then it breaks the
delivery time forwarding over veth that I thought was the purpose of
this patch series. I guess I'm a bit hazy when this is supposed to be
scrubbed exactly.

> fwd_mono_tstamp may be a better name.  It is about the forwarded tstamp
> is in mono.

After your change skb->tstamp is no longer in CLOCK_REALTIME, right?

Somewhat annoyingly, that does not imply that it is always
CLOCK_MONOTONIC. Because while FQ uses that, ETF is programmed with
CLOCK_TAI.

Perhaps skb->delivery_time is the most specific description. And that
is easy to test for in skb_scrub_tstamp.


> e.g. the packet from a container-netns can be queued
> at the fq@hostns (the case described in patch 1 commit log).
> Also, the bpf@ingress@veth@hostns can now expect the skb->tstamp is in
> mono time.  BPF side does not have helper returning real clock, so it is
> safe to assume that bpf prog is comparing (or setting) skb->tstamp as
> mono also.
>
> > If adding a bit, might it be simpler to add a bit tstamp_is_edt, and
> > scrub based on that. That is also not open to the above race.
> It was one of my earlier attempts by adding tstamp_is_tx_mono and
> set it in tcp_output.c and then test it before scrubbing.
> Other than changing the tcp_output.c (e.g. in __tcp_transmit_skb),
> I ended up making another change on the bpf side to also set
> this bit when the bpf_prog is updating the __sk_buff->tstamp.  Thus,
> in this patch , I ended up setting a bit only in the forward path.
>
> I can go back to retry the tstamp_is_edt/tstamp_is_tx_mono idea and
> that can also avoid the race in testing sock_flag(sk, SOCK_TXTIME)
> as you suggested.

Sounds great, thanks
