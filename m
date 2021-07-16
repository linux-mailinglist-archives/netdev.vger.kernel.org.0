Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E2F3CBB68
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 19:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhGPRxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 13:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbhGPRxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 13:53:08 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB221C06175F
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 10:50:11 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v5so13032611wrt.3
        for <netdev@vger.kernel.org>; Fri, 16 Jul 2021 10:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Sg+hBXbxsILa/1XWEvfBiKtKLa8h58eE4UW1jy0Yhg=;
        b=IXDskcnprt//QO9FUOCZ/EU8Lp0FkgZV54upNCMLAxHxGleRiaETFccxpFsYs462u+
         Ev/nzLoyiq/RvPUBYyl9WhYH6f8G4/3c12dMk9GQYTSRsxe5iYRTjzSfCZ2IqvDOgZzz
         tHNopEclm5x+rUWS+3wUzls+oNWq4GIGlMdS4xpg27WLA+ypUKFniPp9kJk/qzX94nvC
         K2OXbX+hQ6cQGeQsxu5P/tJKLebb7Oqg8o8FO254zE7k6491PdG0SA/fDSN60a59u//A
         JEjBeh66zlgcfow2SFIYodO+PJpzGy8v3/9UNMKkIgG2eIq31nB5P2hbejsmLoc7mxy5
         NikA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Sg+hBXbxsILa/1XWEvfBiKtKLa8h58eE4UW1jy0Yhg=;
        b=tJP7yPBCKwJhU56qiFXIjmF81Ki+QGyCXfXVW0fZszk5ecMOlU4KasdU4xosJorCar
         0l8exJGVdNS7rvneKnQw8uHK1KP9cFFL2q5muy6/2r1HroT+XxdwOv6sp6bP4YRp0yB0
         sW0FFyrcRptPc3Ly1ZzJP3paoOZLNTbts540Nv3izniXBhgPDJnsV9tkeadS0/qmQz85
         dV3gcjiT64lZ+c7Iu15/RNuanwKtTmCZ+TwREQLkqLIt1qkGiaY/hqLghVJJWT4q1ude
         Mbs/ivN2BDbuXDPg2PzdMs7+oU44L/SaMMShcZJV8AWKTUdnj1ZdZCQG4ocXWHiK8hZ6
         pxYg==
X-Gm-Message-State: AOAM5333+IRa54cFFoeAweAR/Mx7aZTy0SaJ/zUPH75MuiY03ICYUftm
        F3O0wsRs1GqHfb8qZpeIU6ShIfOeCmuysUmPFJw=
X-Google-Smtp-Source: ABdhPJznC6nXuITXCNtcr8vFH5FCm2mpi8S9Rdz9Z83F/v+Hp+jpsBSv4fF0xGzSAgAYmp4Vh0bAO3kxUmo6s45YFV0=
X-Received: by 2002:adf:b307:: with SMTP id j7mr13925760wrd.243.1626457810313;
 Fri, 16 Jul 2021 10:50:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210712005554.26948-1-vfedorenko@novek.ru> <20210712005554.26948-3-vfedorenko@novek.ru>
 <4cf247328ea397c28c9c404094fb0f952a41f3c6.camel@redhat.com>
 <161cf19b-6ed6-affb-ab67-e8627f6ed6d9@novek.ru> <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
In-Reply-To: <cb9830bd8ef1edc3b5a5f11546618cd50ed82f21.camel@redhat.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 16 Jul 2021 13:50:00 -0400
Message-ID: <CADvbK_fBypr_EXHQg2vvv94WfVa_w8mO9P3fPKGkWvPxhruong@mail.gmail.com>
Subject: Re: [PATCH net 2/3] udp: check encap socket in __udp_lib_err
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Vadim Fedorenko <vfedorenko@novek.ru>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 9:37 AM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Mon, 2021-07-12 at 13:45 +0100, Vadim Fedorenko wrote:
> >
> > > After this patch, the above chunk will not clear 'sk' for packets
> > > targeting ESP in UDP sockets, but AFAICS we will still enter the
> > > following conditional, preserving the current behavior - no ICMP
> > > processing.
> >
> > We will not enter following conditional for ESP in UDP case because
> > there is no more check for encap_type or encap_enabled.
>
> I see. You have a bug in the ipv6 code-path. With your patch applied:
>
> ---
>         sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
>                                inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
>         if (sk && udp_sk(sk)->encap_enabled) {
>                 //...
>         }
>
>         if (!sk || udp_sk(sk)->encap_enabled) {
>         // can still enter here...
> ---
>
> > I maybe missing something but d26796ae5894 doesn't actually explain
> > which particular situation should be avoided by this additional check
> > and no tests were added to simply reproduce the problem. If you can
> > explain it a bit more it would greatly help me to improve the fix.
>
> Xin knows better, but AFAICS it used to cover the situation you
> explicitly tests in patch 3/3 - incoming packet with src-port == dst-
> port == tunnel port - for e.g. vxlan tunnels.
Thanks Paolo and sorry for late.

Right, __udp4/6_lib_err_encap() was introduced to process the ICMP error
packets for UDP tunnels. But it will only work when there's no socket
found with src + dst port, as when the src == dst port a socket might
be found(if the bind addr is ANY) and the code will be called.



>
> > > Why can't you use something alike the following instead?
> > >
> > > ---
> > > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > > index c0f9f3260051..96a3b640e4da 100644
> > > --- a/net/ipv4/udp.c
> > > +++ b/net/ipv4/udp.c
> > > @@ -707,7 +707,7 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
> > >          sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
> > >                                 iph->saddr, uh->source, skb->dev->ifindex,
> > >                                 inet_sdif(skb), udptable, NULL);
> > > -       if (!sk || udp_sk(sk)->encap_type) {
> > > +       if (!sk || READ_ONCE(udp_sk(sk)->encap_err_lookup)) {
> > >                  /* No socket for error: try tunnels before discarding */
> > >                  sk = ERR_PTR(-ENOENT);
> > >                  if (static_branch_unlikely(&udp_encap_needed_key)) {
> > >
> > > ---
>
> Could you please have a look at the above ?
If not all udp tunnels want to do further validation for ICMP error packet,
This looks good to me.

>
> Thanks!
>
> /P
>
