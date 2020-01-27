Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5303E14A82E
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 17:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgA0Qhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 11:37:47 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:33404 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgA0Qhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 11:37:47 -0500
Received: by mail-yb1-f193.google.com with SMTP id n66so5215462ybg.0
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 08:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jLx5EV+1JXlnghuhTGiiXfdxDnaaoEFW90f/oUX5P6U=;
        b=neilK4GkNGZcC+8i6sJ5PetyBO5uQnhyW5x4b3WIl44IDatImxVIh/7Q60188W1nP5
         ua+SZgqlYRw1IIrWm5MY9s7KdBVzUsH6+3cVmVr6XlYTkHDd0plE91g2mx/hb9qxprus
         k1xWElu6Q1GDSaKwg61f3dyr7uyheIKE6seMx81LDahZZJlE1ol4Cw8CfDCviV1haky6
         fd4fUkZALpoD2excKnPt5CIYaIx51Gl7PBeTFss08zj2KaZ/C76Fb2oMguT3X9Tfe8jH
         tVGqs0SY8TAt0rMh7DZ9j9+iuRzP40k85cfNaFkvcahRypuTIFE/tdQRzhTumspN/orz
         i2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jLx5EV+1JXlnghuhTGiiXfdxDnaaoEFW90f/oUX5P6U=;
        b=HWv+8lxVJw6SWc0sSHN7tb/1c/KcUnpQmYDJRu+MicOcSCgxtw3URcYvm1r4E3qWaP
         ezYRPfNJCYnj4lJzSNUqZueiUn5K9JqgrsDLgG98v0Yxah3TxY7IVW781O+lah1nvVZ6
         JkEzAxTlMKcdIQVowhR/jQi74UKvGtf9gvKsI5W0OmMRYkV9OT1AX9ql6+wS6c2uccMh
         KENUbET+Ssl2b1/lBZbXKKwJQSRuXqvG0pCqZC6/oHgwGDtiNsBAh2ohKVAxlnbucITE
         /IM2Sheczp9qKWO6m8iymuaOK/2EtY+jnzRDZz9kDM7HMJhQNFP/m3155sojAqWrTmBV
         t+zg==
X-Gm-Message-State: APjAAAX+4YcqIW8fdiJnISz5fVeWmoMsi7v6VYEEfoJrsSA9CMpbUdbG
        P4txNk6OPG0N1+4fl/ckB8a7taaA
X-Google-Smtp-Source: APXvYqyBfugEk2RksBWfdU1iDJvE4ARAYrXvoPIvt65b8jm+zXYyJuUSgllfQshI1LMSj5One7wHzA==
X-Received: by 2002:a25:d903:: with SMTP id q3mr12587643ybg.244.1580143065012;
        Mon, 27 Jan 2020 08:37:45 -0800 (PST)
Received: from mail-yw1-f48.google.com (mail-yw1-f48.google.com. [209.85.161.48])
        by smtp.gmail.com with ESMTPSA id g190sm6852209ywd.85.2020.01.27.08.37.44
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jan 2020 08:37:44 -0800 (PST)
Received: by mail-yw1-f48.google.com with SMTP id i190so5022487ywc.2
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 08:37:44 -0800 (PST)
X-Received: by 2002:a81:6f85:: with SMTP id k127mr13543213ywc.507.1580143063438;
 Mon, 27 Jan 2020 08:37:43 -0800 (PST)
MIME-Version: 1.0
References: <cover.1579798999.git.martin.varghese@nokia.com>
 <f1805f7c981d74d8611dd19329765a1f7308cbaf.1579798999.git.martin.varghese@nokia.com>
 <CA+FuTSccdUY3Z4d9wznbjysacs=OAD4mfRsPP4N84NTEVhOSAQ@mail.gmail.com>
 <20200124144711.GA8532@martin-VirtualBox> <CAF=yD-J7C-g_L8p2N+h4OS2q2nEOOmJqKvnTw5tP4wtm6WuqKA@mail.gmail.com>
 <20200127154855.GA2512@martin-VirtualBox>
In-Reply-To: <20200127154855.GA2512@martin-VirtualBox>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 27 Jan 2020 11:37:07 -0500
X-Gmail-Original-Message-ID: <CA+FuTScr=tsOw0=kCzjMdbM_On-YGR-nYps6rHQYqBucPbm6qQ@mail.gmail.com>
Message-ID: <CA+FuTScr=tsOw0=kCzjMdbM_On-YGR-nYps6rHQYqBucPbm6qQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 1/2] net: UDP tunnel encapsulation module for
 tunnelling different protocols like MPLS,IP,NSH etc.
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        scott.drennan@nokia.com, Jiri Benc <jbenc@redhat.com>,
        martin.varghese@nokia.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 27, 2020 at 10:49 AM Martin Varghese
<martinvarghesenokia@gmail.com> wrote:
>
> On Fri, Jan 24, 2020 at 03:47:37PM -0500, Willem de Bruijn wrote:
> > On Fri, Jan 24, 2020 at 9:47 AM Martin Varghese
> > <martinvarghesenokia@gmail.com> wrote:
> > >
> > > On Thu, Jan 23, 2020 at 05:42:25PM -0500, Willem de Bruijn wrote:
> > > > On Thu, Jan 23, 2020 at 1:04 PM Martin Varghese
> > > > <martinvarghesenokia@gmail.com> wrote:
> > > > >
> > > > > From: Martin Varghese <martin.varghese@nokia.com>
> > > > >
> > > > > The Bareudp tunnel module provides a generic L3 encapsulation
> > > > > tunnelling module for tunnelling different protocols like MPLS,
> > > > > IP,NSH etc inside a UDP tunnel.
> > > > >
> > > > > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> > > >
> > > > > diff --git a/include/net/ip6_tunnel.h b/include/net/ip6_tunnel.h
> > > > > index 028eaea..8215d1b 100644
> > > > > --- a/include/net/ip6_tunnel.h
> > > > > +++ b/include/net/ip6_tunnel.h
> > > > > @@ -165,5 +165,55 @@ static inline void ip6tunnel_xmit(struct sock *sk, struct sk_buff *skb,
> > > > >                 iptunnel_xmit_stats(dev, pkt_len);
> > > > >         }
> > > > >  }
> > > > > +
> > > > > +static inline struct dst_entry *ip6tunnel_get_dst(struct sk_buff *skb,
> > > > > +                                                 struct net_device *dev,
> > > > > +                                                 struct net *net,
> > > > > +                                                 struct socket *sock,
> > > > > +                                                 struct flowi6 *fl6,
> > > > > +                                                 const struct ip_tunnel_info *info,
> > > > > +                                                 bool use_cache)
> > > > > +{
> > > > > +       struct dst_entry *dst = NULL;
> > > > > +#ifdef CONFIG_DST_CACHE
> > > > > +       struct dst_cache *dst_cache;
> > > > > +#endif
> > > >
> > > > I just noticed these ifdefs are absent in Geneve. On closer look,
> > > > CONFIG_NET_UDP_TUNNEL selects CONFIG_NET_IP_TUNNEL selects
> > > > CONFIG_DST_CACHE. So they are indeed not needed.
> > > >
> > > > Sorry, should have noticed that in v4. It could conceivably be fixed
> > > > up later, but seems worth one more round to get it right from the
> > > > start.
> > > >
> > > But unlike geneve i have placed this definition in ip_tunnels.h &
> > > ip6_tunnels.h which doesnt come under NET_IP_TUNNEL.Hence build
> > > will fail in cases where NET_UDP_TUNNEL is disabled
> > > Kbuild robot has shown that in v3.
> > >
> > > Even with  #ifdef CONFIG_DST_CACHE Kbuild robot reported another issue.
> > > when ip6_tunnel.h included in ip4_tunnel_core.c.
> > > dst_cache_get_ipv6 comes under ipv6 flag  and hence the compilation of
> > > ip4_tunnel_core.c fails when IPV6 is disabled.
> > >
> > > Ideally this functions should be defined in ip_tunnel.c & ip6_tunnel.c
> > > as these function has no significance if IP Tunnel is disabled.
> >
> > Sounds great. Yes, these functions are better in a .c file.
>
> Keeping these functions in ipv4/route.c and ipv6/ip6_output.c along with ip_route_output_flow & ip6_dst_lookup_flow
> These functions will be named ip_route_output_tunnel & ip6_dst_lookup_tunnel
>
> Keeping these functions in ip_tunnels.c & ip6_tunnels.c is a bad idea as the bareudp module has no
> Dependency with ipv4 & ipv6 tunnel module as of now and there is no need to create one.
>
> Do you see any issues
> If the above approach is not feasible we should fall back to ip_tunnel.h ip6_tunnel.h with proper #ifdef protection

That sounds fine. I don't have a strong opinion on which .c file they
are in. A dependency of udp tunnels on ip tunnels seems quite logical.
But so does moving it to the routing code. Thanks.
