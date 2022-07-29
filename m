Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC47584FC7
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235834AbiG2L5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiG2L5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:57:05 -0400
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D487C14
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:57:05 -0700 (PDT)
Received: by mail-vs1-xe33.google.com with SMTP id d187so4267166vsd.10
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 04:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OrIOXodoCB6SlZ9jiBBPmdndGtstR2PZpzKpq8cU0b8=;
        b=o3O8Sg3nO/XdHDe8WbevQnSsJbdEpgGoD5evegQcE2PyAbmMFnTbYqBfln7NeXNaX6
         tVUfE8El/9lJL1vixi9G+GFp5bSI6/nmoQwgFH48tU2GvnOAIzQb/dKeK4v3tdUwTLmA
         zM6Yz3cQajS+/CodavrG6GW6Hs67JSBHR2TrkV5PBAAKRJ2XOPVyI1S9h53HwOsF9JtP
         WfJP9uAkAcakMmWeRwNh3yZJLS9ZuxpjpfW7gUPq9BLb9/GzCNEW98XY/TV15gTd3EDC
         ou/SUkD9IDDxHRDCIQ1ebsY+kNQ27RL4YajZZaWfpfI6EiY2tHS+3rSp1cXd41hBSgiK
         M5Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OrIOXodoCB6SlZ9jiBBPmdndGtstR2PZpzKpq8cU0b8=;
        b=paInrGPeZW/f0euyLMljMts92Dpd19MUdUGof9S248Z9DYtilw/n/N3NGbmm/jguXu
         LuD3S9Z4rU2bTIjxoU3XCKLrbIG1nQsIYsGmGxrymzWhga8y7KusEgfrWQdSqTFFnzk1
         mJ/pHA59Cqvd3ATgl3str3yQ4GTx6VxWWRLksXGxHJUWsYJtX4CO2FcUrH7xwy3QfhI4
         tHtSgF3kY8od4RPBjaNKxfOW+6poCmOnvldSTWgEz1U0Ig9GHamx0e3LMems/OKfbowC
         JY2HxquaZv0T9OM6u4+SqWUlOYf/+xrS2yR7UpgBH089Mmj81WgQqH+fmUtddsLIb5Qu
         qu3w==
X-Gm-Message-State: AJIora+ePyiLi0ciMNIWBEOZYNdPoqYjpzBer2Q+nMq7t0gLBDEfqBCf
        kDLPyRxWhC2hrAm1sxLYOAloF4RiqGEN3Jzg5Bs=
X-Google-Smtp-Source: AGRyM1u/hV1Dw4mOV6IJ+E+XPlrA6tz5r6ZB0O+fN4FmNl4PKhwrifTq7a2QLuPkZ/iZXuq452xj2DekFaJv76yOfVc=
X-Received: by 2002:a67:b042:0:b0:35a:138b:bfe7 with SMTP id
 q2-20020a67b042000000b0035a138bbfe7mr985860vsh.87.1659095824247; Fri, 29 Jul
 2022 04:57:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAJGXZLi_QCZ+4dHv8qtGeyEjdkP3wjoXge_b-zTZ0sgUcEZ8zw@mail.gmail.com>
 <20220622171929.77078c4d@kernel.org> <CAJGXZLiNo=G=5889sPyiCZVjRf65Ygov3=DWFgKmay+Dy3wCYw@mail.gmail.com>
 <20220623202602.650ed2e6@kernel.org> <CAJGXZLg9Z3O8w_bTLhyU1m7Oemfx561X0ji0MdYRZG8XKmxBpg@mail.gmail.com>
 <20220624101743.78d0ece7@kernel.org> <CAJGXZLhJd4xYQhvhb8r0QYhjSjNUCe6nmvi5TA_Ma6LO992KYw@mail.gmail.com>
 <20220701183151.1d623693@kernel.org> <20220701184222.34b75a77@kernel.org>
 <CAJGXZLj2pMki+88OO_fDf-KO1jehEKWg2m5yKTeB0K4yKuMmmg@mail.gmail.com>
 <20220707162319.49c25e90@kernel.org> <CAJGXZLgtLLMGsgn4EXO1VNiO0KvVah_jPHCmYU_zNM-_XnEOOA@mail.gmail.com>
 <20220728081701.191a405b@kernel.org>
In-Reply-To: <20220728081701.191a405b@kernel.org>
From:   Aleksey Shumnik <ashumnik9@gmail.com>
Date:   Fri, 29 Jul 2022 14:56:53 +0300
Message-ID: <CAJGXZLh3aCuG9GVcOKxRo17H8=NY=yyN34fBRHr2w3YZbb1LFA@mail.gmail.com>
Subject: Re: [PATCH] net/ipv4/ip_gre.c net/ipv6/ip6_gre.c: ip and gre header
 are recorded twice
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        David Ahern <dsahern@gmail.com>, kuznet@ms2.inr.ac.ru,
        xeb@mail.ru
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 28, 2022 at 6:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 28 Jul 2022 16:54:01 +0300 Aleksey Shumnik wrote:
> > On Fri, Jul 8, 2022 at 2:23 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Thu, 7 Jul 2022 19:41:23 +0300 Aleksey Shumnik wrote:
> > >
> > > Yeah, I've added the neigh entries (although the v6 addresses had to
> > > be massaged a little for ip neigh to take them, the commands from the
> > > email don't work cause iproute2 doesn't support :: in lladdr, AFAICT).
> > >
> > > What I've seen in tracing was that I hit:
> > >
> > > ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap()
> > >
> > > that returns IP6_TNL_F_CAP_PER_PACKET
> > >
> > > so back to ip6gre_tunnel_xmit() -> goto tx_err -> error, drop
> > >
> > > packet never leaves the interface.
> >
> > I skipped this check so that the packets wouldn't drop.
> > I compared the implementations of ip_gre.c and ip6_gre.c and I
> > concluded that in ip6_tnl_xmit_ctl() instead of tunnel params
> > (&ip6_tnl->parms.laddr and &ip6_tnl->parms.raddr) it is better to use
> > skb network header (ipv6_hdr(skb)->saddr and ipv6_hdr(skb)->daddr).
> > It is illogical to use the tunnel parameters, because if we have an
> > NBMA connection, the addresses will not be set in the tunnel
> > parameters and packets will always drop on ip6_tnl_xmit_ctl().
> >
> > > Hm, so you did get v6 to repro? Not sure what I'm doing wrong, I'm
> > > trying to repro with a net namespace over veth but that can't be it...
> >
> > Yes, just skip ip6_tnl_xmit_ctl().
>
> Mm. Having to remove checks for packets to pass thru makes it seem like
> a lot less of a bug.

I don't agree. It is a bug.
When sending a packet over the NBMA network, the following sequence of
functions occurs:

ip6gre_tunnel_xmit() -> ip6_tnl_xmit_ctl() -> ip6_tnl_get_cap() ->
  ...
  if (ltype == IPV6_ADDR_ANY || rtype == IPV6_ADDR_ANY) {
      flags = IP6_TNL_F_CAP_PER_PACKET;
  ...

After that, the packages are dropped, but if you skip ip6_tnl_xmit_ctl()

ip6gre_tunnel_xmit() -> ip6gre_xmit_ipv4() / ip6gre_xmit_ipv6() /
ip6gre_xmit_other() -> __gre6_xmit() -> ip6_tnl_xmit() ->
  ...
  /* NBMA tunnel */
  if (ipv6_addr_any(&t->parms.raddr)) {
  ...

It is strange that at first when checking addr_type == IPV6_ADDR_ANY
packages are dropped,
but after that there is ipv6_addr_any(addr) which leads to
neigh_lookup() end etc.
It turns out that the same check leads to different actions. In
addition, due to the fact that the package is dropped, there is no
neighbor_lookup and the package will not be sent.
It looks like ip6_gre supports NBMA, but does not allow it to work,
because of this bug.
