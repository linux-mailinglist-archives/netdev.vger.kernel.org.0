Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF4267EDC2
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 19:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234348AbjA0So7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 13:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbjA0So6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 13:44:58 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 991A575790
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 10:44:56 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-5063029246dso79013657b3.6
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 10:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ljtZ4ypLfej4LcEk6Nj/mIZ/IU9OQUKDueO29CYxzr8=;
        b=ERjS+/UKvT2Uae5aQlJZ2ipzeTGoFeDOQzkFOf5SlGEg1ubHn6Z19kckP11b+zBnIQ
         svPSJLWuqZg0JG6k46PrnQ40nXe99YYQgIcxuRde/HgFQRJN5fpB168Dv57roKqfUhcj
         c3Wl672YDNIQZQzVx6H3a9AzJ6RT1VejPlYYAXL9lvw0ZJlcyQOQnUhHSGL2SzMO1Ls2
         RDhv9WArl+zP1yDzvieI9qpg7zj3gop2WXN0b1h/9G7huOca2wcuwxHzPpXWn1vprgLT
         2iJJg5EuvfF5JxIewWDg+hKR6u/aiKErE7GfIk6bXRUEGs53SFD7eKo/4JC4vNXw0a0X
         zi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ljtZ4ypLfej4LcEk6Nj/mIZ/IU9OQUKDueO29CYxzr8=;
        b=pw7c1fmARy7Ak2Qf+OFI+kPDbfHXO8Nd0DoDVq3TsgaKyV9CP8AweBifHkHnGkOZ/Z
         cpzNkWmqi8bvIc1/AURvO14qLau6/AAU2kjcqapemU/iw27JP8M4Xu4Wn0/U7iHpFm4q
         CLEF7JHn5nmXJB0auP8d56IpFgn2KwyV83xWKyECp11IRDeUck3wSMoPSlPwcD72p17L
         8mX1qlRm55UpMu3TrkEB7KqvGoP1jyE42rTk3fAM8EKPZjOzaXUx0Mguyr2xi2s4e/Ah
         9wMALi2hsMF3rdJ1rX//G983A5C1DPO/38gWJxQqGzdXHxI/22UFS+03jAeg/8t60oKm
         lHFA==
X-Gm-Message-State: AFqh2kqCD0bxSaRdu2k8Wj+DnVjSKD4AuK8Q2roHZa+cDCo9Io6Y/mFd
        /TYI18NK/JOnGGJcrxubIWPKyu/FFNuksmynIFIr5w==
X-Google-Smtp-Source: AMrXdXvETSEU+MmqLTpHVbvFds6LgQpXaPsY9N8oyVVygl8xjrgCoJr+fg0dnYfR+zKcya5/ytTzJ7GeWxYLdgtKZ5E=
X-Received: by 2002:a81:d42:0:b0:501:5ab3:9e6e with SMTP id
 63-20020a810d42000000b005015ab39e6emr3726097ywn.278.1674845095482; Fri, 27
 Jan 2023 10:44:55 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674835106.git.lucien.xin@gmail.com> <798ca80553e73028eeec4be08ba1549d08b2e5fc.1674835106.git.lucien.xin@gmail.com>
 <CANn89iL11WjtqNx0=fL2hOzpH_S6y=J5U9uS3g+iusupJLLsTg@mail.gmail.com> <CADvbK_dfVBNRQunV1mp-Cs+Xh57dnQJqEQ6RQR+feqQNnQ-iTQ@mail.gmail.com>
In-Reply-To: <CADvbK_dfVBNRQunV1mp-Cs+Xh57dnQJqEQ6RQR+feqQNnQ-iTQ@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 27 Jan 2023 19:44:43 +0100
Message-ID: <CANn89iL+o-SeOXOajTqcNnyajK2PRAMTMEk1b_A1JC-dFTMrNA@mail.gmail.com>
Subject: Re: [PATCHv3 net-next 10/10] net: add support for ipv4 big tcp
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 7:37 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> On Fri, Jan 27, 2023 at 12:41 PM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Fri, Jan 27, 2023 at 5:00 PM Xin Long <lucien.xin@gmail.com> wrote:
> > >
> > > Similar to Eric's IPv6 BIG TCP, this patch is to enable IPv4 BIG TCP.
> > >
> > > Firstly, allow sk->sk_gso_max_size to be set to a value greater than
> > > GSO_LEGACY_MAX_SIZE by not trimming gso_max_size in sk_trim_gso_size()
> > > for IPv4 TCP sockets.
> > >
> > > Then on TX path, set IP header tot_len to 0 when skb->len > IP_MAX_MTU
> > > in __ip_local_out() to allow to send BIG TCP packets, and this implies
> > > that skb->len is the length of a IPv4 packet; On RX path, use skb->len
> > > as the length of the IPv4 packet when the IP header tot_len is 0 and
> > > skb->len > IP_MAX_MTU in ip_rcv_core(). As the API iph_set_totlen() and
> > > skb_ip_totlen() are used in __ip_local_out() and ip_rcv_core(), we only
> > > need to update these APIs.
> > >
> > > Also in GRO receive, add the check for ETH_P_IP/IPPROTO_TCP, and allows
> > > the merged packet size >= GRO_LEGACY_MAX_SIZE in skb_gro_receive(). In
> > > GRO complete, set IP header tot_len to 0 when the merged packet size
> > > greater than IP_MAX_MTU in iph_set_totlen() so that it can be processed
> > > on RX path.
> > >
> > > Note that by checking skb_is_gso_tcp() in API iph_totlen(), it makes
> > > this implementation safe to use iph->len == 0 indicates IPv4 BIG TCP
> > > packets.
> > >
> > > Signed-off-by: Xin Long <lucien.xin@gmail.com>
> > > ---
> > >  net/core/gro.c       | 12 +++++++-----
> > >  net/core/sock.c      |  8 ++++++--
> > >  net/ipv4/af_inet.c   |  7 ++++---
> > >  net/ipv4/ip_input.c  |  2 +-
> > >  net/ipv4/ip_output.c |  2 +-
> > >  5 files changed, 19 insertions(+), 12 deletions(-)
> > >
> > > diff --git a/net/core/gro.c b/net/core/gro.c
> > > index 506f83d715f8..b15f85546bdd 100644
> > > --- a/net/core/gro.c
> > > +++ b/net/core/gro.c
> > > @@ -162,16 +162,18 @@ int skb_gro_receive(struct sk_buff *p, struct sk_buff *skb)
> > >         struct sk_buff *lp;
> > >         int segs;
> > >
> > > -       /* pairs with WRITE_ONCE() in netif_set_gro_max_size() */
> > > -       gro_max_size = READ_ONCE(p->dev->gro_max_size);
> > > +       /* pairs with WRITE_ONCE() in netif_set_gro(_ipv4)_max_size() */
> > > +       gro_max_size = p->protocol == htons(ETH_P_IPV6) ?
> > > +                       READ_ONCE(p->dev->gro_max_size) :
> > > +                               READ_ONCE(p->dev->gro_ipv4_max_size);
> > >
> > >         if (unlikely(p->len + len >= gro_max_size || NAPI_GRO_CB(skb)->flush))
> > >                 return -E2BIG;
> > >
> > >         if (unlikely(p->len + len >= GRO_LEGACY_MAX_SIZE)) {
> > > -               if (p->protocol != htons(ETH_P_IPV6) ||
> > > -                   skb_headroom(p) < sizeof(struct hop_jumbo_hdr) ||
> > > -                   ipv6_hdr(p)->nexthdr != IPPROTO_TCP ||
> > > +               if (NAPI_GRO_CB(skb)->proto != IPPROTO_TCP ||
> > > +                   (p->protocol == htons(ETH_P_IPV6) &&
> > > +                    skb_headroom(p) < sizeof(struct hop_jumbo_hdr)) ||
> > >                     p->encapsulation)
> > >                         return -E2BIG;
> > >         }
> > > diff --git a/net/core/sock.c b/net/core/sock.c
> > > index 7ba4891460ad..c98f9a4eeff9 100644
> > > --- a/net/core/sock.c
> > > +++ b/net/core/sock.c
> > > @@ -2383,6 +2383,8 @@ static void sk_trim_gso_size(struct sock *sk)
> > >             !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
> > >                 return;
> > >  #endif
> > > +       if (sk->sk_family == AF_INET && sk_is_tcp(sk))
> > > +               return;
> >
> > Or simply
> >
> > diff --git a/net/core/sock.c b/net/core/sock.c
> > index 7ba4891460adbd6c13c0ce1dcdd7f23c8c1f0f5d..dcb8fff91fd9a9472267a2cf2fdc98114a7d2b7d
> > 100644
> > --- a/net/core/sock.c
> > +++ b/net/core/sock.c
> > @@ -2375,14 +2375,9 @@ EXPORT_SYMBOL_GPL(sk_free_unlock_clone);
> >
> >  static void sk_trim_gso_size(struct sock *sk)
> >  {
> > -       if (sk->sk_gso_max_size <= GSO_LEGACY_MAX_SIZE)
> > +       if (sk->sk_gso_max_size <= GSO_LEGACY_MAX_SIZE ||
> > +           sk_is_tcp(sk))
> >                 return;
> > -#if IS_ENABLED(CONFIG_IPV6)
> > -       if (sk->sk_family == AF_INET6 &&
> > -           sk_is_tcp(sk) &&
> > -           !ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr))
> > -               return;
> > -#endif
> >         sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
> >  }
> There's a difference,  AF_INET6 TCP socket may send ipv4 packets with
> ipv6_addr_v4mapped, if we don't check ipv6_addr_v4mapped(), IPV4
> GSO packets might go with the "gso_max_size" for IPV6.
>

But the change you wrote in sk_setup_caps() only checked sk_family.


> I think we could use the change you wrote above, but we also need to
> use dst->ops->family instead of sk->sk_family in sk_setup_caps():
>
> +                       sk->sk_gso_max_size = dst->ops->family == AF_INET6 ?
> +                                       READ_ONCE(dst->dev->gso_max_size) :
> +
> READ_ONCE(dst->dev->gso_ipv4_max_size);
>
> >
> >
> >
> > >         sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
> > >  }
> > >
> > > @@ -2403,8 +2405,10 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
> > >                         sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
> > >                 } else {
> > >                         sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
> > > -                       /* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
> > > -                       sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
> > > +                       /* pairs with the WRITE_ONCE() in netif_set_gso(_ipv4)_max_size() */
> > > +                       sk->sk_gso_max_size = sk->sk_family == AF_INET6 ?
> > > +                                       READ_ONCE(dst->dev->gso_max_size) :
> > > +                                               READ_ONCE(dst->dev->gso_ipv4_max_size);

Here...

So if you need ipv6_addr_v4mapped() this should be done here anyway.

> > >                         sk_trim_gso_size(sk);
> > >                         sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
> > >                         /* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
> > > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > > index 6c0ec2789943..2f992a323b95 100644
> > > --- a/net/ipv4/af_inet.c
> > > +++ b/net/ipv4/af_inet.c
> > > @@ -1485,6 +1485,7 @@ struct sk_buff *inet_gro_receive(struct list_head *head, struct sk_buff *skb)
> > >         if (unlikely(ip_fast_csum((u8 *)iph, 5)))
> > >                 goto out;
> > >
> > > +       NAPI_GRO_CB(skb)->proto = proto;
> > >         id = ntohl(*(__be32 *)&iph->id);
> > >         flush = (u16)((ntohl(*(__be32 *)iph) ^ skb_gro_len(skb)) | (id & ~IP_DF));
> > >         id >>= 16;
> > > @@ -1618,9 +1619,9 @@ int inet_recv_error(struct sock *sk, struct msghdr *msg, int len, int *addr_len)
> > >
> > >  int inet_gro_complete(struct sk_buff *skb, int nhoff)
> > >  {
> > > -       __be16 newlen = htons(skb->len - nhoff);
> > >         struct iphdr *iph = (struct iphdr *)(skb->data + nhoff);
> > >         const struct net_offload *ops;
> > > +       __be16 totlen = iph->tot_len;
> > >         int proto = iph->protocol;
> > >         int err = -ENOSYS;
> > >
> > > @@ -1629,8 +1630,8 @@ int inet_gro_complete(struct sk_buff *skb, int nhoff)
> > >                 skb_set_inner_network_header(skb, nhoff);
> > >         }
> > >
> > > -       csum_replace2(&iph->check, iph->tot_len, newlen);
> > > -       iph->tot_len = newlen;
> > > +       iph_set_totlen(iph, skb->len - nhoff);
> > > +       csum_replace2(&iph->check, totlen, iph->tot_len);
> > >
> > >         ops = rcu_dereference(inet_offloads[proto]);
> > >         if (WARN_ON(!ops || !ops->callbacks.gro_complete))
> > > diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
> > > index e880ce77322a..0aa8c49b4e1b 100644
> > > --- a/net/ipv4/ip_input.c
> > > +++ b/net/ipv4/ip_input.c
> > > @@ -511,7 +511,7 @@ static struct sk_buff *ip_rcv_core(struct sk_buff *skb, struct net *net)
> > >         if (unlikely(ip_fast_csum((u8 *)iph, iph->ihl)))
> > >                 goto csum_error;
> > >
> > > -       len = ntohs(iph->tot_len);
> > > +       len = skb_ip_totlen(skb);
> >
> > len = iph_totlen(skb, iph);
> OK, thanks.
