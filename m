Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169AB2FC857
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389563AbhATC5d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389711AbhATC40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 21:56:26 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F96C061757
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:55:45 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id g10so3256840wrx.1
        for <netdev@vger.kernel.org>; Tue, 19 Jan 2021 18:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uAYJP4auVBg35JykE1t2Rfor4ZjxrxJAHg1d1oLkhKs=;
        b=XakfUtoMHLnUhXE/d+tbmyMdWn1igsskibWQxjQ8cM+vijzd/HzpTCRB9t2vMZ0oS7
         Cw29F69QOhgjo5oLEi5vN/EGWANTnoj/sYufwI5x5VEpaxPrKdXibbuJgsKesi+fMeZt
         L26xY+zQik40trCtYb46GM1+KBlgnzFOIbDwr64alb2UuzJlF82OEGC99F584xxcaRly
         JNINBSe363B4uX1gNgLngjVidk+0WPN4D2xlmIn+CKMWAjQTiWHB0XE9dHGM5e+6krV6
         RhkTpTtUwMtcKcL7qMr/N5qA1+7hNFFU3i/j7NHpcfwIO8ONG0VRWU4WXjzpTqGL2Gtz
         uTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uAYJP4auVBg35JykE1t2Rfor4ZjxrxJAHg1d1oLkhKs=;
        b=S6Pcwi/HLAmAUYX+GWN3oTaf6pg5zCU+w0+RiRklpzUspNadayNLzVmJzQlJFQiGA7
         31i7hf5ARMskjkFGsTh8gPCPRTCosoO/5e36yRrN7IXPLOQaxbYE0g6Ywu2it752i2bX
         PTgKOnsRzPKyxKsCZa0Tsz+hfMuGIUiyDJ2fBZvL+TvNVYqhjjwq3hfjgvr6q7x3nhJM
         muKWrdrErEWr3r/pNWvJ8VpRbmz/e8n+WLb3PWe1KO8K9M3OTNCJ4Z7XroNcAuHCbpkx
         qOh5pr6lPbanKRMsWsgJzR8phd79D1XbdKfN2DScjPnMDUDLevDxQxjrre3+ZRxIvMd+
         kM7A==
X-Gm-Message-State: AOAM533dHikjhtzImkPJjOup/foKuQ61pmDNc9uCqTy9zDca02IMRklc
        xebaoolDk9MfsS6+ZwbJSEcg3qkxx75KQyjHE8k=
X-Google-Smtp-Source: ABdhPJwgqwMPQcHBplqFkf1XqroKCTAWcyYKpGsOCcymJc8VCv7D3yHDW2W8mxMX2qS5Y9cO9rr6NbpEdXuxiOlj21I=
X-Received: by 2002:adf:9d82:: with SMTP id p2mr7035251wre.330.1611111344339;
 Tue, 19 Jan 2021 18:55:44 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610771509.git.lucien.xin@gmail.com> <0ba74e791c186444af53489ebc55664462a1caf6.1610771509.git.lucien.xin@gmail.com>
 <CAKgT0Ud+mjksk1HWpLUSWziGUq9ZQLO33GiVHQtJhoCOpM0zUQ@mail.gmail.com>
In-Reply-To: <CAKgT0Ud+mjksk1HWpLUSWziGUq9ZQLO33GiVHQtJhoCOpM0zUQ@mail.gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 20 Jan 2021 10:55:32 +0800
Message-ID: <CADvbK_dKYB_n72RzY-QQoAocmtyBaxW51kDxFpDHRg24psQNVQ@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 1/2] udp: call udp_encap_enable for v6 sockets
 when enabling encap
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 20, 2021 at 6:17 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Jan 15, 2021 at 8:34 PM Xin Long <lucien.xin@gmail.com> wrote:
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
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > ---
> >  include/net/udp.h        | 1 +
> >  include/net/udp_tunnel.h | 3 +--
> >  net/ipv4/udp.c           | 6 ++++++
> >  net/ipv6/udp.c           | 4 +++-
> >  4 files changed, 11 insertions(+), 3 deletions(-)
> >
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
> > index 7103b0a..28bfe60 100644
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
>
> So this seems unbalanced to me. We are adding/modifying one spot where
> we are calling the enable function, but the other callers don't call
> the disable function? Specifically I am curious about how to deal with
> the rxrpc_open_socket usage.
as long as it's a UDP sock, when it's being destroyed,
udp(v6)_destroy_sock will be called, where the key(s) get decreased.

Sorry, I missed there's a call to udp_encap_enable() in rxrpc, the issue is
the similar to the one in bareudp, it should be:

-       udp_encap_enable();
 #if IS_ENABLED(CONFIG_AF_RXRPC_IPV6)
        if (local->srx.transport.family == AF_INET6)
                udpv6_encap_enable();
+       else
 #endif
+       udp_encap_enable();
+

I will get all these into one patch and repost.

Interesting it doesn't use udp_tunnel APIs here, I will check.

Thanks.

>
> If we don't balance out all the callers I am not sure adding the
> udp_encap_disable makes much sense.
>
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
> > --
> > 2.1.0
> >
