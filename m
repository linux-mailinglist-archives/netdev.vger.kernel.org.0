Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FF3048B7
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:37:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388279AbhAZFjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732305AbhAZDvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 22:51:19 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8994C06174A
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 19:50:38 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id c12so15035973wrc.7
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 19:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jI8w8pmJ/9DSlsrsr5imG+MtUmQ+czdXtDKoHVOAzvg=;
        b=Bvw5v2JEkMKZN1yx6I+Svoeo/DvsTp9fE2jEo2pKj1aTz86upxeI/T0cOHxG/drvmk
         eHsuYWHPwCZSzXZhKhM4orTgUXHiLhCHjuUJckQnobhOnL1lGyhsoSjrRhAMUrkUUATI
         o8InbBMogzcoqx8FENrU/I7CyDF/j9rt3JwErf24ZnRlPsdHw7lio0bwaVd5h6lGboq5
         XBhCnlD2R0cO+tAIFMyumKOWxEbu8u+i97g1sF7GKZn+ow6ooJg7MCUQtOOySeI2Om4K
         n/+ejIe8W3xqKj2HKvUg82wE0lQP5ohy7x3ZCLSJxIVasogkI6rLaudxngcjjMwmTWli
         VC/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jI8w8pmJ/9DSlsrsr5imG+MtUmQ+czdXtDKoHVOAzvg=;
        b=IpCALnhR0F8EofiYPH8DT0emMCkVsVv0eYOr2+muN2Db/3qrAb+kIezZ4IxZ+0SKgC
         wqfzmfctPrWUBno/laSZrQSNMUH3EVTSZFgbiuEiv53OTTI1vHmTQJ5YEycHth0LnnId
         pBNDGy229JsDjcOZmroR0+OaT6pLeBHJt2jJ51p6qw451VqG0RGGGEA+hiVIiz58K3sD
         2Nl+S+J8lnRZvKo4WxXvEAtDOqhp4hsrKY/Vs37yVDBOJB/omHr4MeA9OKF2Hl/Baj5Y
         KLLzXfOg5Iu4yqlYPYF2jJnoWW5V5hXV9AUHqZehD9zLO7E23YuWFm7pCyi7jLwybwNm
         3C9Q==
X-Gm-Message-State: AOAM530yjBfp+IcqRIcUTidZ9lIZy/qyDLKrABEBbjX7pJ0pJFP/0i4e
        XGEa1LoMo10ACa+4uq9us7F7eMXqdCbuF9Dhac4=
X-Google-Smtp-Source: ABdhPJy64uQmA8ylX497YddA8lrN7YxXerqXgqsFVsz4e+3LNfUYOLCnnbjbv/BPUDBa9igwq+FYy30wyIXyfOxbUuU=
X-Received: by 2002:a5d:4a0d:: with SMTP id m13mr3893309wrq.395.1611633037472;
 Mon, 25 Jan 2021 19:50:37 -0800 (PST)
MIME-Version: 1.0
References: <d2a9b26103c84ff535a886e875c6c619057641c8.1611478403.git.lucien.xin@gmail.com>
 <CAF=yD-JTBjCfko01qZbmuh+rjOSt-3rtiGgA4OQEZbeiGCT=JA@mail.gmail.com>
In-Reply-To: <CAF=yD-JTBjCfko01qZbmuh+rjOSt-3rtiGgA4OQEZbeiGCT=JA@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 26 Jan 2021 11:50:26 +0800
Message-ID: <CADvbK_f2XH+ZTzzKjUGot5GhpJ1X-FPif7vLTM=nty7wWGw+qA@mail.gmail.com>
Subject: Re: [PATCHv3 net-next] udp: call udp_encap_enable for v6 sockets when
 enabling encap
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 26, 2021 at 10:35 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Sun, Jan 24, 2021 at 3:57 AM Xin Long <lucien.xin@gmail.com> wrote:
> >
> > When enabling encap for a ipv6 socket without udp_encap_needed_key
> > increased, UDP GRO won't work for v4 mapped v6 address packets as
> > sk will be NULL in udp4_gro_receive().
> >
> > This patch is to enable it by increasing udp_encap_needed_key for
> > v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> > decrease udp_encap_needed_key in udpv6_destroy_sock().
> >
> > v1->v2:
> >   - add udp_encap_disable() and export it.
> > v2->v3:
> >   - add the change for rxrpc and bareudp into one patch, as Alex
> >     suggested.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  drivers/net/bareudp.c    | 6 ------
> >  include/net/udp.h        | 1 +
> >  include/net/udp_tunnel.h | 3 +--
> >  net/ipv4/udp.c           | 6 ++++++
> >  net/ipv6/udp.c           | 4 +++-
> >  net/rxrpc/local_object.c | 4 +++-
> >  6 files changed, 14 insertions(+), 10 deletions(-)
> >
> > diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> > index 1b8f597..7511bca 100644
> > --- a/drivers/net/bareudp.c
> > +++ b/drivers/net/bareudp.c
> > @@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
> >         tunnel_cfg.encap_destroy = NULL;
> >         setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
> >
> > -       /* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
> > -        * socket type is v6 an explicit call to udp_encap_enable is needed.
> > -        */
> > -       if (sock->sk->sk_family == AF_INET6)
> > -               udp_encap_enable();
> > -
> >         rcu_assign_pointer(bareudp->sock, sock);
> >         return 0;
> >  }
> > diff --git a/include/net/udp.h b/include/net/udp.h
> > index 877832b..1e7b6cd 100644
> > --- a/include/net/udp.h
> > +++ b/include/net/udp.h
> > @@ -467,6 +467,7 @@ void udp_init(void);
> >
> >  DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
> >  void udp_encap_enable(void);
> > +void udp_encap_disable(void);
> >  #if IS_ENABLED(CONFIG_IPV6)
> >  DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
> >  void udpv6_encap_enable(void);
> > diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
> > index 282d10e..afc7ce7 100644
> > --- a/include/net/udp_tunnel.h
> > +++ b/include/net/udp_tunnel.h
> > @@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
> >  #if IS_ENABLED(CONFIG_IPV6)
> >         if (sock->sk->sk_family == PF_INET6)
> >                 ipv6_stub->udpv6_encap_enable();
> > -       else
> >  #endif
> > -               udp_encap_enable();
> > +       udp_encap_enable();
> >  }
> >
> >  #define UDP_TUNNEL_NIC_MAX_TABLES      4
> > diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> > index 69ea765..48208fb 100644
> > --- a/net/ipv4/udp.c
> > +++ b/net/ipv4/udp.c
> > @@ -596,6 +596,12 @@ void udp_encap_enable(void)
> >  }
> >  EXPORT_SYMBOL(udp_encap_enable);
> >
> > +void udp_encap_disable(void)
> > +{
> > +       static_branch_dec(&udp_encap_needed_key);
> > +}
> > +EXPORT_SYMBOL(udp_encap_disable);
> > +
> >  /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
> >   * through error handlers in encapsulations looking for a match.
> >   */
> > diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> > index b9f3dfd..d754292 100644
> > --- a/net/ipv6/udp.c
> > +++ b/net/ipv6/udp.c
> > @@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
> >                         if (encap_destroy)
> >                                 encap_destroy(sk);
> >                 }
> > -               if (up->encap_enabled)
> > +               if (up->encap_enabled) {
> >                         static_branch_dec(&udpv6_encap_needed_key);
> > +                       udp_encap_disable();
> > +               }
> >         }
> >
> >         inet6_destroy_sock(sk);
> > diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
> > index 8c28810..fc10234 100644
> > --- a/net/rxrpc/local_object.c
> > +++ b/net/rxrpc/local_object.c
> > @@ -135,11 +135,13 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
> >         udp_sk(usk)->gro_receive = NULL;
> >         udp_sk(usk)->gro_complete = NULL;
> >
> > -       udp_encap_enable();
> >  #if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
> >         if (local->srx.transport.family == AF_INET6)
> >                 udpv6_encap_enable();
> > +       else
> >  #endif
> > +               udp_encap_enable();
> > +
>
> If ipv6 this socket will decrement both static branches in
> udpv6_destroy_sock. Shouldn't it increment both, then? Similar to
> udp_tunnel_encap_enable, but open coded.
My mistake, all above should just call udp_tunnel_encap_enable(),
otherwise, it won't be decreased in udpv6_destroy_sock(). will respost.

Thanks.
