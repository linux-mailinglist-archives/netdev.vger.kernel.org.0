Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E194DA3E8
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 21:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351623AbiCOUYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 16:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349997AbiCOUYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 16:24:08 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3205B93
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:22:54 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2d07ae0b1c0so1226367b3.2
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 13:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vCksz8Ih/kUop2/Lw+fYa3CtIdWUgEx6vC+vQyiR/z0=;
        b=Uqd4e4FFzEKzGbM1bDh15NdIFrmeqwo8s8Q0fzpH1dgz6PhT8Zbpe5f+NMmu4sRvy9
         AdQMj4yiN3oqFymAV2QyfXqSKLXogQnVqiSr1a7Tn3Ti4SnbtzmqR8N5ODQRB780h6OQ
         SySpThr8dOIMQZPUJt9N79w5w/351XpQQVuVI5MCoD0X5Cesmg2s8FaOWtp4GbQtWYdI
         QjwFOr+ywYYG3xknOYq2sJSPobmgvV9LapeHIHy1ehzX+F0ZSJfQHn7b83l9rqA+J91U
         p+F95Lx1kJ2MOcs2I6dJCbVKMU6ZhysuRGqcZJnE7o1GY6q1vffpU4UIFEWmj3p5GKqe
         w9sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vCksz8Ih/kUop2/Lw+fYa3CtIdWUgEx6vC+vQyiR/z0=;
        b=nbIBaaKOIQj3qacJ0TRqvgR+NZmIFhc9f04ecOglZw1nzLLuoktm/8BbEKBD15J9Nq
         KxM00P33sukUQsjQLP3CHpSJovY+gTb1unEXv17XdO6yMwKkj/Vxc636Rwd3E29/2Zw6
         9kjAFek6dRbVMLr4g74hp8Kpc8K2MoJiXYImCRyk6ZacuJSLXkQ/V1V+Wjs4g5cXvTSi
         fHQtY2A+ecUJk7ptLHOXXvxdjiVSOiFbng2z+3OQvoO/IyKTqg7jFxQbq9FHkc4V+BFB
         d8SiKyeKKdV5KMJaLJJtwOxlCV9r9CwYAHZPGJBro1inwLwzh7PjcStEor31hGsw04Wj
         Boag==
X-Gm-Message-State: AOAM531SlU8NhedGlJavioOu1CjGHjTXFGx0gTWohpSSsHCidAPPPmwS
        +4huS5YnOwwRxeBMSDNKGoi6j93oICzvz7oTQMFFOKfGI0nlHw==
X-Google-Smtp-Source: ABdhPJw3ULHcpazfGciCZUaz1rJPeiYC0/kV0AzslcN79niI8ONbHZcOhYXz4rEdsfLOc/W2F/VVzemKNb220oU+r34=
X-Received: by 2002:a81:7056:0:b0:2dc:4f0d:47fd with SMTP id
 l83-20020a817056000000b002dc4f0d47fdmr26074809ywc.435.1647375773267; Tue, 15
 Mar 2022 13:22:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220315185603.160778-1-eyal.birger@gmail.com> <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com>
In-Reply-To: <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Tue, 15 Mar 2022 22:22:42 +0200
Message-ID: <CAHsH6Gvj5CVZUVw7-EDrTYzs5vSae3TmFQeRJYuA9wycmVhfOg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shmulik.ladkani@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Roopa,

On Tue, Mar 15, 2022 at 9:57 PM Roopa Prabhu <roopa@nvidia.com> wrote:
>
>
> On 3/15/22 11:56, Eyal Birger wrote:
> > This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
> >
> > In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
> > device creation. This property cannot be changed for the time being.
> >
> > In case IP traffic is received on a non-tun device the drop count is
> > increased.
> >
> > Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> > ---
> >   drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++---------
> >   include/uapi/linux/if_link.h |  1 +
> >   2 files changed, 61 insertions(+), 19 deletions(-)
> >
> > diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> > index a895ff756093..37305ec26250 100644
> > --- a/drivers/net/geneve.c
> > +++ b/drivers/net/geneve.c
> > @@ -56,6 +56,7 @@ struct geneve_config {
> >       bool                    use_udp6_rx_checksums;
> >       bool                    ttl_inherit;
> >       enum ifla_geneve_df     df;
> > +     bool                    tun;
> >   };
> >
> >   /* Pseudo network device */
> > @@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
> >               }
> >       }
> >
> > -     skb_reset_mac_header(skb);
> > -     skb->protocol = eth_type_trans(skb, geneve->dev);
> > -     skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > -
> >       if (tun_dst)
> >               skb_dst_set(skb, &tun_dst->dst);
> >
> > -     /* Ignore packet loops (and multicast echo) */
> > -     if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
> > -             geneve->dev->stats.rx_errors++;
> > -             goto drop;
> > +     if (gnvh->proto_type == htons(ETH_P_TEB)) {
> > +             skb_reset_mac_header(skb);
> > +             skb->protocol = eth_type_trans(skb, geneve->dev);
> > +             skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> > +
> > +             /* Ignore packet loops (and multicast echo) */
> > +             if (ether_addr_equal(eth_hdr(skb)->h_source,
> > +                                  geneve->dev->dev_addr)) {
> > +                     geneve->dev->stats.rx_errors++;
> > +                     goto drop;
> > +             }
> > +     } else {
> > +             skb_reset_mac_header(skb);
> > +             skb->dev = geneve->dev;
> > +             skb->pkt_type = PACKET_HOST;
> >       }
> >
> >       oiph = skb_network_header(skb);
> > @@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >       struct genevehdr *geneveh;
> >       struct geneve_dev *geneve;
> >       struct geneve_sock *gs;
> > +     __be16 inner_proto;
> >       int opts_len;
> >
> >       /* Need UDP and Geneve header to be present */
> > @@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >       if (unlikely(geneveh->ver != GENEVE_VER))
> >               goto drop;
> >
> > -     if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
> > +     inner_proto = geneveh->proto_type;
> > +
> > +     if (unlikely((inner_proto != htons(ETH_P_TEB) &&
> > +                   inner_proto != htons(ETH_P_IP) &&
> > +                   inner_proto != htons(ETH_P_IPV6)))) {
> >               goto drop;
> > +     }
> >
>
>
> unnecessary braces

Will fix.

>
> >       gs = rcu_dereference_sk_user_data(sk);
> >       if (!gs)
> > @@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >       if (!geneve)
> >               goto drop;
> >
> > +     if (unlikely((!geneve->cfg.tun && inner_proto != htons(ETH_P_TEB)))) {
> > +             geneve->dev->stats.rx_dropped++;
> > +             goto drop;
> > +     }
>
> Does this change current default behavior ?.
>
> its unclear to be what the current behavior is for a non ETH_P_TEB packet

Currently non ETH_P_TEB packets are silently dropped.
I figured that if the driver supported other ethertypes it would make
sense to increase the count in such case, to assist in debugging wrong
configurations.

I can remove this if it's better to keep the current behavior.
>
>
> > +
> >       opts_len = geneveh->opt_len * 4;
> > -     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
> > -                              htons(ETH_P_TEB),
> > +     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
> >                                !net_eq(geneve->net, dev_net(geneve->dev)))) {
> >               geneve->dev->stats.rx_dropped++;
> >               goto drop;
> > @@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
> >   }
> >
> >   static void geneve_build_header(struct genevehdr *geneveh,
> > -                             const struct ip_tunnel_info *info)
> > +                             const struct ip_tunnel_info *info,
> > +                             __be16 inner_proto)
> >   {
> >       geneveh->ver = GENEVE_VER;
> >       geneveh->opt_len = info->options_len / 4;
> > @@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
> >       geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
> >       geneveh->rsvd1 = 0;
> >       tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
> > -     geneveh->proto_type = htons(ETH_P_TEB);
> > +     geneveh->proto_type = inner_proto;
> >       geneveh->rsvd2 = 0;
> >
> >       if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
> > @@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr *geneveh,
> >
> >   static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
> >                           const struct ip_tunnel_info *info,
> > -                         bool xnet, int ip_hdr_len)
> > +                         bool xnet, int ip_hdr_len, bool tun)
> >   {
> > +     __be16 inner_proto = tun ? skb->protocol : htons(ETH_P_TEB);
> >       bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
> >       struct genevehdr *gnvh;
> >       int min_headroom;
> > @@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
> >               goto free_dst;
> >
> >       gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
> > -     geneve_build_header(gnvh, info);
> > -     skb_set_inner_protocol(skb, htons(ETH_P_TEB));
> > +     geneve_build_header(gnvh, info, inner_proto);
> > +     skb_set_inner_protocol(skb, inner_proto);
> >       return 0;
> >
> >   free_dst:
> > @@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> >               }
> >       }
> >
> > -     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
> > +     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
> > +                            geneve->cfg.tun);
> >       if (unlikely(err))
> >               return err;
> >
> > @@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
> >                       ttl = key->ttl;
> >               ttl = ttl ? : ip6_dst_hoplimit(dst);
> >       }
> > -     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
> > +     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
> > +                            geneve->cfg.tun);
> >       if (unlikely(err))
> >               return err;
> >
> > @@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
> >       dst_cache_reset(&geneve->cfg.info.dst_cache);
> >       memcpy(&geneve->cfg, cfg, sizeof(*cfg));
> >
> > +     if (geneve->cfg.tun) {
> > +             dev->header_ops = NULL;
> > +             dev->type = ARPHRD_NONE;
> > +             dev->hard_header_len = 0;
> > +             dev->addr_len = 0;
> > +             dev->flags = IFF_NOARP;
> > +     }
> > +
> >       err = register_netdevice(dev);
> >       if (err)
> >               return err;
> > @@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
> >   #endif
> >       }
> >
> > +     if (data[IFLA_GENEVE_TUN]) {
> > +             if (changelink) {
> > +                     attrtype = IFLA_GENEVE_TUN;
> > +                     goto change_notsup;
> > +             }
> > +             cfg->tun = true;
> > +     }
> > +
> >       return 0;
> >   change_notsup:
> >       NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
> > -                         "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
> > +                         "Changing VNI, Port, endpoint IP address family, external, tun, and UDP checksum attributes are not supported");
> >       return -EOPNOTSUPP;
> >   }
> >
> > @@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
> >       if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
> >               goto nla_put_failure;
> >
> > +     if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
> > +             goto nla_put_failure;
> > +
> >       return 0;
> >
> >   nla_put_failure:
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index bd24c7dc10a2..198aefa2c513 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -842,6 +842,7 @@ enum {
> >       IFLA_GENEVE_LABEL,
> >       IFLA_GENEVE_TTL_INHERIT,
> >       IFLA_GENEVE_DF,
> > +     IFLA_GENEVE_TUN,
>
> geneve is itself called a tunnel, i wonder if a different name for the
> flag would be more appropriate.

I tried to find a reference to something similar, so went with something like
the tun vs. tap distinction. I was also concerned about the possible
confusion, but it felt clearer than something like L3_INNER_PROTO_MODE.

I'd happily replace it with a better suggestion.

>
> what is the use case for this ?. is there a RFC reference ?

I stumbled upon this configuration when trying to receive packets from an
AWS "Gateway Load Balancer" which sends IP packets encapsulated in GENEVE [1].

But to my understanding the RFC allows this so it doesn't seem something
specific to AWS.

Thanks for the review!

Eyal.

[1] https://aws.amazon.com/blogs/networking-and-content-delivery/integrate-your-custom-logic-or-appliance-with-aws-gateway-load-balancer/

>
>
>
> >       __IFLA_GENEVE_MAX
> >   };
> >   #define IFLA_GENEVE_MAX     (__IFLA_GENEVE_MAX - 1)
