Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E9D3CC58C
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 20:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235113AbhGQSok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 14:44:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234625AbhGQSoj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 14:44:39 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94704C061762
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 11:41:42 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id o30-20020a05600c511eb029022e0571d1a0so7818502wms.5
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 11:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O6DepiGJGOS2qtVC84yODHAvnVnJKOo0y5/c60/wyMc=;
        b=gVMvfPv68L12VWkqe1biMCT4Kex3JyPQ8igqNP7+acU02K9/RdvzoYDjcowiMzkL15
         fzNXF1tmydCliZGNn/mV0qLxVpryhmwy6+DwbKv3WMgadzTRppcKTndLUSO02jZZufSh
         hliNH4hTc4VsMa1yqG8xkNbb5MLGGJY7iauIxDeDIlPza+9lQuc5Hfmut0sFTNzmPLtt
         AO1KPtVGJZa+j/GPIF2nf5P7XCmMSO6Tr/kE9PrclrkFbiTrizrduPhVHN84dt13f/n8
         UiBk/nTk7h7Y7wD/ztGgsynULSWgns3X50wLeJqVEgTMyFjpOSyS3U72I6RTDS1FWwjF
         xeJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O6DepiGJGOS2qtVC84yODHAvnVnJKOo0y5/c60/wyMc=;
        b=OJ2kQ4GqXN2SgtiRCGnz1ukGNpGKrn0fOkIvOcHz00hpJOSGNQVpSVdcB0Z1eaWw11
         3RSeQbgaDwDDGvyZuiM17YWsVvA/9m9vuC/fNcXSikK+uAdRYfzKslyRpb7bPH0xYYNF
         jus+8hvSp2X4ZOn6Ocf1x+MRX/luBiVCgn2rxMGNDsqGUs53cLYatvug+gDJyLNrc9i7
         XbANhm+EwQgcaicMmG3ZSCg5+tzYyoU05Hhurut1j0i0uy0C0bS5pN2oEQL0lYF9wBFz
         mMMro4fpStYsmjIAjBoPjRSfzCWWMBDWmQaTHzs/wZqg/ivRf3cAYbJRIS1TyA7j4H6W
         r3qQ==
X-Gm-Message-State: AOAM531kQBEJO0ap9r9RwwaPNlkCxWLJDOO6S1SOp2f3YbWLb4kpFYs9
        5FzREZe5914gpuF+oNUjb87EvP4ZUBpZu7HY9Cg=
X-Google-Smtp-Source: ABdhPJwsS+JBmbpHLWlnlLNuXWU4CJz97RbIETv9vwQxTAGJr0KcyQcXqCHxuX9pJ6SGddUoQPRgPi/Gy3U+qdUJBlA=
X-Received: by 2002:a05:600c:358d:: with SMTP id p13mr24283222wmq.12.1626547301082;
 Sat, 17 Jul 2021 11:41:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210716105417.7938-1-vfedorenko@novek.ru> <20210716105417.7938-2-vfedorenko@novek.ru>
 <CADvbK_eJEY_-4sJM-up_L2G47HqdV2q3XSkexYSm9vDmpmD9pA@mail.gmail.com> <bdb405e2-59e8-b75c-2b8a-864019477989@novek.ru>
In-Reply-To: <bdb405e2-59e8-b75c-2b8a-864019477989@novek.ru>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 17 Jul 2021 14:41:30 -0400
Message-ID: <CADvbK_fnOyTVOQ0wopnVZSmbB5ZBkCft1mXWLy=SqKkLYv_q3Q@mail.gmail.com>
Subject: Re: [PATCH net v2 1/2] udp: check encap socket in __udp_lib_err_encap
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 6:32 PM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
>
> On 16.07.2021 19:46, Xin Long wrote:
> > On Fri, Jul 16, 2021 at 6:54 AM Vadim Fedorenko <vfedorenko@novek.ru> wrote:
> >>
> >> Commit d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> >> added checks for encapsulated sockets but it broke cases when there is
> >> no implementation of encap_err_lookup for encapsulation, i.e. ESP in
> >> UDP encapsulation. Fix it by calling encap_err_lookup only if socket
> >> implements this method otherwise treat it as legal socket.
> >>
> >> Fixes: d26796ae5894 ("udp: check udp sock encap_type in __udp_lib_err")
> >> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> >> ---
> >>   net/ipv4/udp.c | 23 +++++++++++++++++------
> >>   net/ipv6/udp.c | 23 +++++++++++++++++------
> >>   2 files changed, 34 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> >> index 62cd4cd52e84..963275b94f00 100644
> >> --- a/net/ipv4/udp.c
> >> +++ b/net/ipv4/udp.c
> >> @@ -645,10 +645,12 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
> >>                                           const struct iphdr *iph,
> >>                                           struct udphdr *uh,
> >>                                           struct udp_table *udptable,
> >> +                                        struct sock *sk,
> >>                                           struct sk_buff *skb, u32 info)
> >>   {
> >> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
> >>          int network_offset, transport_offset;
> >> -       struct sock *sk;
> >> +       struct udp_sock *up;
> >>
> >>          network_offset = skb_network_offset(skb);
> >>          transport_offset = skb_transport_offset(skb);
> >> @@ -659,12 +661,19 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
> >>          /* Transport header needs to point to the UDP header */
> >>          skb_set_transport_header(skb, iph->ihl << 2);
> >>
> >> +       if (sk) {
> >> +               up = udp_sk(sk);
> >> +
> >> +               lookup = READ_ONCE(up->encap_err_lookup);
> >> +               if (!lookup || !lookup(sk, skb))
> >> +                       goto out;
> >> +       }
> >> +
> > Currently SCTP reuses lookup() to handle some of ICMP error packets by itself
> > in lookup(), for these packets it will return 1, in which case we should
> > set sk = NULL, and not let udp4_lib_err() handle these packets again.
> >
> > Can you change this part to this below?
> >
> > +       if (sk) {
> > +               up = udp_sk(sk);
> > +
> > +               lookup = READ_ONCE(up->encap_err_lookup);
> > +               if (lookup && lookup(sk, skb))
> > +                       sk = NULL;
> > +
> > +               goto out;
> > +       }
> > +
> >
> > thanks.
> >
>
> But we have vxlan and geneve with encap_err_lookup handler enabled and which do
> not handle ICMP itself, just checks whether socket is correctly selected. Such
> code could break their implementation
Sorry, I don't see how this will break vxlan and geneve implementation.

It checking 'sk' and calling lookup() here means we believe this sk
should be the correct one (for the case of src == dst port only). So
even if lookup() returns !0, we should NOT go to another
__udp4_lib_lookup() in __udp4_lib_err_encap().

If we don't believe this sk should be the correct one, as the sk was
found with reverse ports, then we should NOT call lookup() with this sk
but call __udp4_lib_lookup() directly in __udp4_lib_err_encap(), as it
currently does, and fix this by checking READ_ONCE(up->encap_err_lookup)
in __udp4_lib_lookup(), as Paolo suggested.

Either way is fine to me, but not this one. what do you think?

Thanks.

>
> >>          sk = __udp4_lib_lookup(net, iph->daddr, uh->source,
> >>                                 iph->saddr, uh->dest, skb->dev->ifindex, 0,
> >>                                 udptable, NULL);
> >>          if (sk) {
> >> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
> >> -               struct udp_sock *up = udp_sk(sk);
> >> +               up = udp_sk(sk);
> >>
> >>                  lookup = READ_ONCE(up->encap_err_lookup);
> >>                  if (!lookup || lookup(sk, skb))
> >> @@ -674,6 +683,7 @@ static struct sock *__udp4_lib_err_encap(struct net *net,
> >>          if (!sk)
> >>                  sk = ERR_PTR(__udp4_lib_err_encap_no_sk(skb, info));
> >>
> >> +out:
> >>          skb_set_transport_header(skb, transport_offset);
> >>          skb_set_network_header(skb, network_offset);
> >>
> >> @@ -707,15 +717,16 @@ int __udp4_lib_err(struct sk_buff *skb, u32 info, struct udp_table *udptable)
> >>          sk = __udp4_lib_lookup(net, iph->daddr, uh->dest,
> >>                                 iph->saddr, uh->source, skb->dev->ifindex,
> >>                                 inet_sdif(skb), udptable, NULL);
> >> +
> >>          if (!sk || udp_sk(sk)->encap_type) {
> >>                  /* No socket for error: try tunnels before discarding */
> >> -               sk = ERR_PTR(-ENOENT);
> >>                  if (static_branch_unlikely(&udp_encap_needed_key)) {
> >> -                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, skb,
> >> +                       sk = __udp4_lib_err_encap(net, iph, uh, udptable, sk, skb,
> >>                                                    info);
> >>                          if (!sk)
> >>                                  return 0;
> >> -               }
> >> +               } else
> >> +                       sk = ERR_PTR(-ENOENT);
> >>
> >>                  if (IS_ERR(sk)) {
> >>                          __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
> >> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> >> index 0cc7ba531b34..0210ec93d21d 100644
> >> --- a/net/ipv6/udp.c
> >> +++ b/net/ipv6/udp.c
> >> @@ -502,12 +502,14 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
> >>                                           const struct ipv6hdr *hdr, int offset,
> >>                                           struct udphdr *uh,
> >>                                           struct udp_table *udptable,
> >> +                                        struct sock *sk,
> >>                                           struct sk_buff *skb,
> >>                                           struct inet6_skb_parm *opt,
> >>                                           u8 type, u8 code, __be32 info)
> >>   {
> >> +       int (*lookup)(struct sock *sk, struct sk_buff *skb);
> >>          int network_offset, transport_offset;
> >> -       struct sock *sk;
> >> +       struct udp_sock *up;
> >>
> >>          network_offset = skb_network_offset(skb);
> >>          transport_offset = skb_transport_offset(skb);
> >> @@ -518,12 +520,19 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
> >>          /* Transport header needs to point to the UDP header */
> >>          skb_set_transport_header(skb, offset);
> >>
> >> +       if (sk) {
> >> +               up = udp_sk(sk);
> >> +
> >> +               lookup = READ_ONCE(up->encap_err_lookup);
> >> +               if (!lookup || !lookup(sk, skb))
> >> +                       goto out;
> >> +       }
> >> +
> >>          sk = __udp6_lib_lookup(net, &hdr->daddr, uh->source,
> >>                                 &hdr->saddr, uh->dest,
> >>                                 inet6_iif(skb), 0, udptable, skb);
> >>          if (sk) {
> >> -               int (*lookup)(struct sock *sk, struct sk_buff *skb);
> >> -               struct udp_sock *up = udp_sk(sk);
> >> +               up = udp_sk(sk);
> >>
> >>                  lookup = READ_ONCE(up->encap_err_lookup);
> >>                  if (!lookup || lookup(sk, skb))
> >> @@ -535,6 +544,7 @@ static struct sock *__udp6_lib_err_encap(struct net *net,
> >>                                                          offset, info));
> >>          }
> >>
> >> +out:
> >>          skb_set_transport_header(skb, transport_offset);
> >>          skb_set_network_header(skb, network_offset);
> >>
> >> @@ -558,16 +568,17 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
> >>
> >>          sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
> >>                                 inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
> >> +
> >>          if (!sk || udp_sk(sk)->encap_type) {
> >>                  /* No socket for error: try tunnels before discarding */
> >> -               sk = ERR_PTR(-ENOENT);
> >>                  if (static_branch_unlikely(&udpv6_encap_needed_key)) {
> >>                          sk = __udp6_lib_err_encap(net, hdr, offset, uh,
> >> -                                                 udptable, skb,
> >> +                                                 udptable, sk, skb,
> >>                                                    opt, type, code, info);
> >>                          if (!sk)
> >>                                  return 0;
> >> -               }
> >> +               } else
> >> +                       sk = ERR_PTR(-ENOENT);
> >>
> >>                  if (IS_ERR(sk)) {
> >>                          __ICMP6_INC_STATS(net, __in6_dev_get(skb->dev),
> >> --
> >> 2.18.4
> >>
>
