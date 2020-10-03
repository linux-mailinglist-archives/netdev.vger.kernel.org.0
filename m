Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C02528231B
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 11:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJCJ0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 05:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725681AbgJCJ0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 05:26:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F37C0613D0
        for <netdev@vger.kernel.org>; Sat,  3 Oct 2020 02:26:34 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so4352569wrm.2
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 02:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=43pUdglIYbB8YzeYMzKsPTWHPuwyJMxM94NcpqU/9VE=;
        b=OOv9F5Zj/MTAZomLpyShRHRtMyM5uw46kKbWGaD4+aNrNcDwCI1nfNHZmh5V6EXWHv
         IlE77vifbDdEvYWRxKoYewwBCtuQt9x6+qyKsYMRFGGr3tVmk6WRu5q9PDtybM9YJ0Fm
         h18l0VeqLxv1uV7HRUcuZauYWllezSkp9cpLUFQTqyXJCxGxCq9269sQs5wAUn31mAJz
         kAAnBdEC04zkHEQvsBQobs90t/eIAgioND5Z5+nucpgvzg/DaTkttRPLE6PilLm6mP4b
         /a3lFlz3nIA2BQbAfzLfbVjAOcyknxouNANUbrEZpAhKw7ITobJvnmD5bHwxakxi+4jL
         je/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=43pUdglIYbB8YzeYMzKsPTWHPuwyJMxM94NcpqU/9VE=;
        b=Cq01qd3QEu8ZnhIVluP8aad17912tPUkpo1vyCLUym6cJSdbnfW0JBIl0x8dfFNdHB
         wdKKg6s7OeC5vHHJ2MvZvoX1rSHfhps8073O592YBhThHLzyL1uPhOn85ytTHSCiLWqk
         8by5Mo7pNARhUAX9IU/wEnQ+qbWm89RRZsFlCe6nPFBJvMpZotefAxC8sxRem7T3sGTp
         y6j+QsOmDMvQTtRWb2an7S2O+yzXzeq0qFmTCL0jpQET/AoUFvMoiuwc1SqCE6aDeKUK
         1wVorPIJ27XqTKg3oZuBiz+EipTv5zUIme3WNteBG8yeQ18nVpG/g4zGtYNbUozsr2KN
         HZWg==
X-Gm-Message-State: AOAM531M9TeaKMjoBvgPF97OTttlAWd8qrFXUBKUX6TSk3Okxi4EEBkT
        vqOZpOMOyPnaO+qsrceed/zBjMK0RgFvb5mWXmk=
X-Google-Smtp-Source: ABdhPJwFzRNh/pWnieaT/DZuERYo7bghN0Yd4QnnhgInnDy4JXvqgZMLAolqPh+IztOzhd2pPORLwmKaYT4pcFXrZv0=
X-Received: by 2002:adf:f586:: with SMTP id f6mr7332949wro.299.1601717192797;
 Sat, 03 Oct 2020 02:26:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com> <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
In-Reply-To: <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 3 Oct 2020 17:41:58 +0800
Message-ID: <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 10:44 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 30/07/2020 =C3=A0 07:41, Steffen Klassert a =C3=A9crit :
> > From: Xin Long <lucien.xin@gmail.com>
> >
> > Similar to ip6_vti, IP6IP6 and IP6IP tunnels processing can easily
> > be done with .cb_handler for xfrm interface.
> >
> > v1->v2:
> >   - no change.
> > v2-v3:
> >   - enable it only when CONFIG_INET6_XFRM_TUNNEL is defined, to fix
> >     the build error, reported by kbuild test robot.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > ---
>
> This patch broke standard IP tunnels. With this setup:
> + ip link set ntfp2 up
> + ip addr add 10.125.0.2/24 dev ntfp2
> + ip tunnel add tun1 mode ipip ttl 64 local 10.125.0.2 remote 10.125.0.1 =
dev ntfp2
> + ip addr add 192.168.0.2/32 peer 192.168.0.1/32 dev tun1
> + ip link set dev tun1 up
>
> incoming packets are dropped:
> $ cat /proc/net/xfrm_stat
> ...
> XfrmInNoStates                  31
> ...
>
> Xin, can you have a look?
Sure.

When xfrmi processes the ipip packets, it does the state lookup and xfrmi
device lookup both in xfrm_input(). When either of them fails, instead of
returning err and continuing the next .handler in tunnel4_rcv(), it would
drop the packet and return 0.

It's kinda the same as xfrm_tunnel_rcv() and xfrm6_tunnel_rcv().

So the safe fix is to lower the priority of xfrmi .handler but it should
still be higher than xfrm_tunnel_rcv() and xfrm6_tunnel_rcv(). Having
xfrmi loaded will only break IPCOMP, and it's expected. I'll post a fix:


diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index dc19aff7c2e0..fb0648e7fb32 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -64,14 +64,14 @@ static int xfrm_tunnel_err(struct sk_buff *skb, u32 inf=
o)
 static struct xfrm_tunnel xfrm_tunnel_handler __read_mostly =3D {
  .handler =3D xfrm_tunnel_rcv,
  .err_handler =3D xfrm_tunnel_err,
- .priority =3D 3,
+ .priority =3D 4,
 };

 #if IS_ENABLED(CONFIG_IPV6)
 static struct xfrm_tunnel xfrm64_tunnel_handler __read_mostly =3D {
  .handler =3D xfrm_tunnel_rcv,
  .err_handler =3D xfrm_tunnel_err,
- .priority =3D 2,
+ .priority =3D 3,
 };
 #endif

diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fab..f696d46e6910 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -303,13 +303,13 @@ static const struct xfrm_type xfrm6_tunnel_type =3D {
 static struct xfrm6_tunnel xfrm6_tunnel_handler __read_mostly =3D {
  .handler =3D xfrm6_tunnel_rcv,
  .err_handler =3D xfrm6_tunnel_err,
- .priority =3D 2,
+ .priority =3D 3,
 };

 static struct xfrm6_tunnel xfrm46_tunnel_handler __read_mostly =3D {
  .handler =3D xfrm6_tunnel_rcv,
  .err_handler =3D xfrm6_tunnel_err,
- .priority =3D 2,
+ .priority =3D 3,
 };

 static int __net_init xfrm6_tunnel_net_init(struct net *net)
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a8f66112c52b..0bb7963b9f6b 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -830,14 +830,14 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler
__read_mostly =3D {
  .handler =3D xfrmi6_rcv_tunnel,
  .cb_handler =3D xfrmi_rcv_cb,
  .err_handler =3D xfrmi6_err,
- .priority =3D -1,
+ .priority =3D 2,
 };

 static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly =3D {
  .handler =3D xfrmi6_rcv_tunnel,
  .cb_handler =3D xfrmi_rcv_cb,
  .err_handler =3D xfrmi6_err,
- .priority =3D -1,
+ .priority =3D 2,
 };
 #endif

@@ -875,14 +875,14 @@ static struct xfrm_tunnel xfrmi_ipip_handler
__read_mostly =3D {
  .handler =3D xfrmi4_rcv_tunnel,
  .cb_handler =3D xfrmi_rcv_cb,
  .err_handler =3D xfrmi4_err,
- .priority =3D -1,
+ .priority =3D 3,
 };

 static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly =3D {
  .handler =3D xfrmi4_rcv_tunnel,
  .cb_handler =3D xfrmi_rcv_cb,
  .err_handler =3D xfrmi4_err,
- .priority =3D -1,
+ .priority =3D 2,
 };
 #endif

> >  net/xfrm/xfrm_interface.c | 38 ++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> >
> > diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
> > index c407ecbc5d46..b9ef496d3d7c 100644
> > --- a/net/xfrm/xfrm_interface.c
> > +++ b/net/xfrm/xfrm_interface.c
> > @@ -798,6 +798,26 @@ static struct xfrm6_protocol xfrmi_ipcomp6_protoco=
l __read_mostly =3D {
> >       .priority       =3D       10,
> >  };
> >
> > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> > +static int xfrmi6_rcv_tunnel(struct sk_buff *skb)
> > +{
> > +     const xfrm_address_t *saddr;
> > +     __be32 spi;
> > +
> > +     saddr =3D (const xfrm_address_t *)&ipv6_hdr(skb)->saddr;
> > +     spi =3D xfrm6_tunnel_spi_lookup(dev_net(skb->dev), saddr);
> > +
> > +     return xfrm6_rcv_spi(skb, IPPROTO_IPV6, spi, NULL);
> > +}
> > +
> > +static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly =3D {
> > +     .handler        =3D       xfrmi6_rcv_tunnel,
> > +     .cb_handler     =3D       xfrmi_rcv_cb,
> > +     .err_handler    =3D       xfrmi6_err,
> > +     .priority       =3D       -1,
> > +};
> > +#endif
> > +
> >  static struct xfrm4_protocol xfrmi_esp4_protocol __read_mostly =3D {
> >       .handler        =3D       xfrm4_rcv,
> >       .input_handler  =3D       xfrm_input,
> > @@ -866,9 +886,23 @@ static int __init xfrmi6_init(void)
> >       err =3D xfrm6_protocol_register(&xfrmi_ipcomp6_protocol, IPPROTO_=
COMP);
> >       if (err < 0)
> >               goto xfrm_proto_comp_failed;
> > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> > +     err =3D xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET6);
> > +     if (err < 0)
> > +             goto xfrm_tunnel_ipv6_failed;
> > +     err =3D xfrm6_tunnel_register(&xfrmi_ipv6_handler, AF_INET);
> > +     if (err < 0)
> > +             goto xfrm_tunnel_ip6ip_failed;
> > +#endif
> >
> >       return 0;
> >
> > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> > +xfrm_tunnel_ip6ip_failed:
> > +     xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
> > +xfrm_tunnel_ipv6_failed:
> > +     xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
> > +#endif
> >  xfrm_proto_comp_failed:
> >       xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
> >  xfrm_proto_ah_failed:
> > @@ -879,6 +913,10 @@ static int __init xfrmi6_init(void)
> >
> >  static void xfrmi6_fini(void)
> >  {
> > +#if IS_ENABLED(CONFIG_INET6_XFRM_TUNNEL)
> > +     xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET);
> > +     xfrm6_tunnel_deregister(&xfrmi_ipv6_handler, AF_INET6);
> > +#endif
> >       xfrm6_protocol_deregister(&xfrmi_ipcomp6_protocol, IPPROTO_COMP);
> >       xfrm6_protocol_deregister(&xfrmi_ah6_protocol, IPPROTO_AH);
> >       xfrm6_protocol_deregister(&xfrmi_esp6_protocol, IPPROTO_ESP);
> >
