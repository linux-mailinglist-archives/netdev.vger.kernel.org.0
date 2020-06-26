Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED3120B552
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 17:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730057AbgFZPxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 11:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727062AbgFZPxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 11:53:12 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1793FC03E979
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:13 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id d16so658273edz.12
        for <netdev@vger.kernel.org>; Fri, 26 Jun 2020 08:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=t3AHO2YBcg3Ykjlk+al9fXFvzbZnrmnRQHdMhdNl0l0=;
        b=uGVlr0CCnkWWjb3PetYWTUSTtP7ZXvicQpDeQYZpd6BoXt8CP6U98Qr0jWTHZNutLG
         R3V1rMCNKaZDQEz1dq5ou+uwl1le3Q10nVBOvPzF7epH9xA8Nqp5ngnaEGUKWTaM23Ps
         iOhS0EjkB5A5QlYGCJNTonWvZjQ+Ygd4BjuuAHNsDlphEy2YWOZIY9QQyqCGZ12HZtjk
         UQ/4dySvcwkobICzZOrkaxvJaNU7U/RW4EDHWkT9RJc9IBDmGvtK5X5OH1at7+HuI8w5
         L8iAME+Q6818UJv/ZAczMhbpD6YVVuRaTmZ3OEUc8nTlfZmNqnfYf4BbbH0mSZ4Y5j5a
         mSnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=t3AHO2YBcg3Ykjlk+al9fXFvzbZnrmnRQHdMhdNl0l0=;
        b=fM3RbzxRCkKCX0Gy3lhX5b41jkto8/MS+nejUeauxH93PyMMM2exNHyVQWjW/nobn/
         IuCLyGesroERM5LtQ7meVNm6yWCLjqvDz4yCKTsecGWaXm0/OveAz/B7stwsjipdPlYB
         /99nPrf8NOO5KX6p6UqtAs1G0vjgiUd8RM6ZnarQpuPFhun5vii/YyYRzd9r7js/JdPk
         BObCmR+L2ChgDAo4IXexLRrUTiCfpyBbNeC3P5lrwvRKIWIg68fx9rgyMQ9oCPYRX4Jw
         2mjYYsT0J90NiYNQM49e0W19i6jBKKsv/82teOU5pDadveU4md4ZKbAd5foHkdxVgt0P
         zObw==
X-Gm-Message-State: AOAM530oRt9ZXekQpNILtojPNfceRxZ2CXkVDh+kj/IU1GRrYJGRgjdd
        LvbfhnNhwWiuxZ78hIXT2dGeHQrfkLnWdYakFaZwkQ==
X-Google-Smtp-Source: ABdhPJyXHjMnxzi3VIcWhOdoRpig9VCNLbFSQyL6hkOVmjRj/XD5ZTZGiiLSf8mcYJUfOCFOvGF0R8kLdZXPxr18AwM=
X-Received: by 2002:a05:6402:144a:: with SMTP id d10mr3887586edx.35.1593186791672;
 Fri, 26 Jun 2020 08:53:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be>
 <20200624192310.16923-3-justin.iurman@uliege.be> <CALx6S374PQ7GGA_ey6wCwc55hUzOx+2kWT=96TzyF0=g=8T=WA@mail.gmail.com>
 <1597014330.36579162.1593107802322.JavaMail.zimbra@uliege.be>
 <CALx6S37wpA5Mc7jdUk8_sR_fJTc-zRpvY8VkDV=NoWdvDhKfpg@mail.gmail.com> <998893232.37051625.1593160294302.JavaMail.zimbra@uliege.be>
In-Reply-To: <998893232.37051625.1593160294302.JavaMail.zimbra@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Fri, 26 Jun 2020 08:52:59 -0700
Message-ID: <CALx6S346C0Uuvsj0NP_HbEs3zz+tzwcBeGBh-i+PC+30POZE_g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/5] ipv6: IOAM tunnel decapsulation
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:31 AM Justin Iurman <justin.iurman@uliege.be> wro=
te:
>
> Tom,
>
> >> >> Implement the IOAM egress behavior.
> >> >>
> >> >> According to RFC 8200:
> >> >> "Extension headers (except for the Hop-by-Hop Options header) are n=
ot
> >> >>  processed, inserted, or deleted by any node along a packet's deliv=
ery
> >> >>  path, until the packet reaches the node (or each of the set of nod=
es,
> >> >>  in the case of multicast) identified in the Destination Address fi=
eld
> >> >>  of the IPv6 header."
> >> >>
> >> >> Therefore, an ingress node (an IOAM domain border) must encapsulate=
 an
> >> >> incoming IPv6 packet with another similar IPv6 header that will con=
tain
> >> >> IOAM data while it traverses the domain. When leaving, the egress n=
ode,
> >> >> another IOAM domain border which is also the tunnel destination, mu=
st
> >> >> decapsulate the packet.
> >> >
> >> > This is just IP in IP encapsulation that happens to be terminated at
> >> > an egress node of the IOAM domain. The fact that it's IOAM isn't
> >> > germaine, this IP in IP is done in a variety of ways. We should be
> >> > using the normal protocol handler for NEXTHDR_IPV6  instead of speci=
al
> >> > case code.
> >>
> >> Agree. The reason for this special case code is that I was not aware o=
f a more
> >> elegant solution.
> >>
> > The current implementation might not be what you're looking for since
> > ip6ip6 wants a tunnel configured. What we really want is more like
> > anonymous decapsulation, that is just decap the ip6ip6 packet and
> > resubmit the packet into the stack (this is what you patch is doing).
> > The idea has been kicked around before, especially in the use case
> > where we're tunneling across a domain and there could be hundreds of
> > such tunnels to some device. I think it's generally okay to do this,
> > although someone might raise security concerns since it sort of
> > obfuscates the "real packet". Probably makes sense to have a sysctl to
>
> Indeed. However, in this precise case for IOAM, you don't have security i=
ssues since you would only decap if an IOAM HBH is found in the outer heade=
r, which is only valid if the node is part of the IOAM domain (IOAM is enab=
led on its ingress interface). But, for a more generic case, I agree for th=
e sysctl solution.

But again there's no such thing as IOAM packets. There are IPv6
packets that have IOAM TLVs in their Hop-by-Hop or Destination
Options. In this case there are IP6IP6 packets that contain an IOAM
TLV in the other headers, but from a protocol and implementation
perspective there's nothing special about that. The outer headers
could just as easily include an SRH (probably more deployed at this
point) or other options and EH ot maybe no options. So we need a
generic solution and not one tied to a particular use case of IP6IP6
tunneling.

Tom
>
> > enable this and probably could default to on. Of course, if we do this
> > the next question is should we also implement anonymous decapsulation
> > for 44,64,46 tunnels.
>
> Interesting question. I'd say that we should only do it if there is at le=
ast a use case that is (or will be) part of the kernel.
>
> Justin
>
> > Tom
> >
> >> Justin
> >>
> >> >> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> >> >> ---
> >> >>  include/linux/ipv6.h |  1 +
> >> >>  net/ipv6/ip6_input.c | 22 ++++++++++++++++++++++
> >> >>  2 files changed, 23 insertions(+)
> >> >>
> >> >> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> >> >> index 2cb445a8fc9e..5312a718bc7a 100644
> >> >> --- a/include/linux/ipv6.h
> >> >> +++ b/include/linux/ipv6.h
> >> >> @@ -138,6 +138,7 @@ struct inet6_skb_parm {
> >> >>  #define IP6SKB_HOPBYHOP        32
> >> >>  #define IP6SKB_L3SLAVE         64
> >> >>  #define IP6SKB_JUMBOGRAM      128
> >> >> +#define IP6SKB_IOAM           256
> >> >>  };
> >> >>
> >> >>  #if defined(CONFIG_NET_L3_MASTER_DEV)
> >> >> diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
> >> >> index e96304d8a4a7..8cf75cc5e806 100644
> >> >> --- a/net/ipv6/ip6_input.c
> >> >> +++ b/net/ipv6/ip6_input.c
> >> >> @@ -361,9 +361,11 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struc=
t sk_buff
> >> >> *));
> >> >>  void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb=
, int nexthdr,
> >> >>                               bool have_final)
> >> >>  {
> >> >> +       struct inet6_skb_parm *opt =3D IP6CB(skb);
> >> >>         const struct inet6_protocol *ipprot;
> >> >>         struct inet6_dev *idev;
> >> >>         unsigned int nhoff;
> >> >> +       u8 hop_limit;
> >> >>         bool raw;
> >> >>
> >> >>         /*
> >> >> @@ -450,6 +452,25 @@ void ip6_protocol_deliver_rcu(struct net *net,=
 struct
> >> >> sk_buff *skb, int nexthdr,
> >> >>         } else {
> >> >>                 if (!raw) {
> >> >>                         if (xfrm6_policy_check(NULL, XFRM_POLICY_IN=
, skb)) {
> >> >> +                               /* IOAM Tunnel Decapsulation
> >> >> +                                * Packet is going to re-enter the =
stack
> >> >> +                                */
> >> >> +                               if (nexthdr =3D=3D NEXTHDR_IPV6 &&
> >> >> +                                   (opt->flags & IP6SKB_IOAM)) {
> >> >> +                                       hop_limit =3D ipv6_hdr(skb)=
->hop_limit;
> >> >> +
> >> >> +                                       skb_reset_network_header(sk=
b);
> >> >> +                                       skb_reset_transport_header(=
skb);
> >> >> +                                       skb->encapsulation =3D 0;
> >> >> +
> >> >> +                                       ipv6_hdr(skb)->hop_limit =
=3D hop_limit;
> >> >> +                                       __skb_tunnel_rx(skb, skb->d=
ev,
> >> >> +                                                       dev_net(skb=
->dev));
> >> >> +
> >> >> +                                       netif_rx(skb);
> >> >> +                                       goto out;
> >> >> +                               }
> >> >> +
> >> >>                                 __IP6_INC_STATS(net, idev,
> >> >>                                                 IPSTATS_MIB_INUNKNO=
WNPROTOS);
> >> >>                                 icmpv6_send(skb, ICMPV6_PARAMPROB,
> >> >> @@ -461,6 +482,7 @@ void ip6_protocol_deliver_rcu(struct net *net, =
struct
> >> >> sk_buff *skb, int nexthdr,
> >> >>                         consume_skb(skb);
> >> >>                 }
> >> >>         }
> >> >> +out:
> >> >>         return;
> >> >>
> >> >>  discard:
> >> >> --
> > > >> 2.17.1
