Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06A013048D2
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 20:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbhAZFjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:39:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732101AbhAZCgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:36:19 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60660C0613ED
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 18:35:36 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id a14so6676972edu.7
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 18:35:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SYtcMt85frtqYG9bx7Di5T01WCqFBgQALAx1FqNQsEc=;
        b=Ffwl7O187uajYKS0TJdC7x6W0rg0arRW010RwGaJg9S5h/qdul7Mo2E0vie6uiJLN3
         bC8jn/X4J/uNySjmQNNn38+/ZVnlqr1m6cfdQAt7UmIPHGlzJ4ocr0XfplHHhnLrQqYH
         IIr/qOkLG1ifb50VSrz//HdC3brdDC1CdDh6N3WCoQqawhTjm096mxMvlL61jrrgKJ0R
         i7typ5uYjcL4J/jhidjDv88wXsUZ3k+vju+QUtyprHgrF3h+o+glPzjzsunQZiaStLut
         v/d6xPc0xBO+g2u9OEJbzPTB0FIVmxJWdaVuTKNxLRW4A8+XrpIIr9V6ewasAeWyzzW8
         m/pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SYtcMt85frtqYG9bx7Di5T01WCqFBgQALAx1FqNQsEc=;
        b=oFNGiTFWm9veNUT/4b+BUttSv4LArg375qq5FX1bLG3hfbTN549mel+uv6KEpA/6xR
         6Eb2ZSAD0+zAWqr2WEWWIhnCNYHpUZeYSPVG4pel7qzkEnbWGSk+ctmoH280JH0nTwP6
         VFhxj9H0TnWhnYEewlhrVTaPR1Ka4Gkud51254KRCWM5ixfh8W4tp/CxWW33N4QpvgrL
         KVOvVs9sKoCuu3oIxFN+UyXm6qVkSJLWN7VLXcepLLI1x2bI92DSZfvqxO9gpkMi6LN5
         CrSyHg+px8q4NWv+cErGA8LxDuAoDH47osTbaQsx0OGCypWVJACO4pD115g9qoB3U5fw
         xfXg==
X-Gm-Message-State: AOAM533KFqvHDRP9O4+oDNtP0Rda1jEdJguKBWQDRHLorzgPOFliLWiy
        fuLM1CYsjhYmAg7a/fXhWyuZFVbjH2TrlK8i6XU=
X-Google-Smtp-Source: ABdhPJzVTOoMZWwUTPRd+sRh0U3nvtE0K2G3PV4zh3PQ2FBIKbkcegmoOP4kYCtQRpmlrAwdrphwPk2nKHnmh8VlbyE=
X-Received: by 2002:a05:6402:318e:: with SMTP id di14mr2834368edb.223.1611628535033;
 Mon, 25 Jan 2021 18:35:35 -0800 (PST)
MIME-Version: 1.0
References: <d2a9b26103c84ff535a886e875c6c619057641c8.1611478403.git.lucien.xin@gmail.com>
In-Reply-To: <d2a9b26103c84ff535a886e875c6c619057641c8.1611478403.git.lucien.xin@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 25 Jan 2021 21:34:58 -0500
Message-ID: <CAF=yD-JTBjCfko01qZbmuh+rjOSt-3rtiGgA4OQEZbeiGCT=JA@mail.gmail.com>
Subject: Re: [PATCHv3 net-next] udp: call udp_encap_enable for v6 sockets when
 enabling encap
To:     Xin Long <lucien.xin@gmail.com>
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

On Sun, Jan 24, 2021 at 3:57 AM Xin Long <lucien.xin@gmail.com> wrote:
>
> When enabling encap for a ipv6 socket without udp_encap_needed_key
> increased, UDP GRO won't work for v4 mapped v6 address packets as
> sk will be NULL in udp4_gro_receive().
>
> This patch is to enable it by increasing udp_encap_needed_key for
> v6 sockets in udp_tunnel_encap_enable(), and correspondingly
> decrease udp_encap_needed_key in udpv6_destroy_sock().
>
> v1->v2:
>   - add udp_encap_disable() and export it.
> v2->v3:
>   - add the change for rxrpc and bareudp into one patch, as Alex
>     suggested.
>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  drivers/net/bareudp.c    | 6 ------
>  include/net/udp.h        | 1 +
>  include/net/udp_tunnel.h | 3 +--
>  net/ipv4/udp.c           | 6 ++++++
>  net/ipv6/udp.c           | 4 +++-
>  net/rxrpc/local_object.c | 4 +++-
>  6 files changed, 14 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 1b8f597..7511bca 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -240,12 +240,6 @@ static int bareudp_socket_create(struct bareudp_dev *bareudp, __be16 port)
>         tunnel_cfg.encap_destroy = NULL;
>         setup_udp_tunnel_sock(bareudp->net, sock, &tunnel_cfg);
>
> -       /* As the setup_udp_tunnel_sock does not call udp_encap_enable if the
> -        * socket type is v6 an explicit call to udp_encap_enable is needed.
> -        */
> -       if (sock->sk->sk_family == AF_INET6)
> -               udp_encap_enable();
> -
>         rcu_assign_pointer(bareudp->sock, sock);
>         return 0;
>  }
> diff --git a/include/net/udp.h b/include/net/udp.h
> index 877832b..1e7b6cd 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -467,6 +467,7 @@ void udp_init(void);
>
>  DECLARE_STATIC_KEY_FALSE(udp_encap_needed_key);
>  void udp_encap_enable(void);
> +void udp_encap_disable(void);
>  #if IS_ENABLED(CONFIG_IPV6)
>  DECLARE_STATIC_KEY_FALSE(udpv6_encap_needed_key);
>  void udpv6_encap_enable(void);
> diff --git a/include/net/udp_tunnel.h b/include/net/udp_tunnel.h
> index 282d10e..afc7ce7 100644
> --- a/include/net/udp_tunnel.h
> +++ b/include/net/udp_tunnel.h
> @@ -181,9 +181,8 @@ static inline void udp_tunnel_encap_enable(struct socket *sock)
>  #if IS_ENABLED(CONFIG_IPV6)
>         if (sock->sk->sk_family == PF_INET6)
>                 ipv6_stub->udpv6_encap_enable();
> -       else
>  #endif
> -               udp_encap_enable();
> +       udp_encap_enable();
>  }
>
>  #define UDP_TUNNEL_NIC_MAX_TABLES      4
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 69ea765..48208fb 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -596,6 +596,12 @@ void udp_encap_enable(void)
>  }
>  EXPORT_SYMBOL(udp_encap_enable);
>
> +void udp_encap_disable(void)
> +{
> +       static_branch_dec(&udp_encap_needed_key);
> +}
> +EXPORT_SYMBOL(udp_encap_disable);
> +
>  /* Handler for tunnels with arbitrary destination ports: no socket lookup, go
>   * through error handlers in encapsulations looking for a match.
>   */
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index b9f3dfd..d754292 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1608,8 +1608,10 @@ void udpv6_destroy_sock(struct sock *sk)
>                         if (encap_destroy)
>                                 encap_destroy(sk);
>                 }
> -               if (up->encap_enabled)
> +               if (up->encap_enabled) {
>                         static_branch_dec(&udpv6_encap_needed_key);
> +                       udp_encap_disable();
> +               }
>         }
>
>         inet6_destroy_sock(sk);
> diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
> index 8c28810..fc10234 100644
> --- a/net/rxrpc/local_object.c
> +++ b/net/rxrpc/local_object.c
> @@ -135,11 +135,13 @@ static int rxrpc_open_socket(struct rxrpc_local *local, struct net *net)
>         udp_sk(usk)->gro_receive = NULL;
>         udp_sk(usk)->gro_complete = NULL;
>
> -       udp_encap_enable();
>  #if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
>         if (local->srx.transport.family == AF_INET6)
>                 udpv6_encap_enable();
> +       else
>  #endif
> +               udp_encap_enable();
> +

If ipv6 this socket will decrement both static branches in
udpv6_destroy_sock. Shouldn't it increment both, then? Similar to
udp_tunnel_encap_enable, but open coded.
