Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C406C4DA90F
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiCPDwM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353505AbiCPDwJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:52:09 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7385F8EF
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 20:50:55 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2e5757b57caso9763207b3.4
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 20:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VpqRzKtcS5TXJWmQqhzU3QlJUIC8xC901Oo0Sjp2iCc=;
        b=QdvAvJ2IpwBspstgFNLtqofSlIWein8MlkO9llGSvV2fyx2KHTYueZv0SYpfHo8UI2
         ARPSaoLiZTBph5tCoGjIlqqMi/5TO2CkiJRIQ5ZMQVVNclUCjzeSRre10ojaNlbhPkE+
         lO0OE4NGQ0AeuWmDWVM5ugKu/CC+cGULXylSeoY/EUkdmx2QN7uhMG4z23gJb8ooG+II
         +Z8t4Hm+Sl/vOXdnSkrFQSDl5UrOxtg0nwNYa7md/Dv3XC10wID5cs5nb7vDSfhZ8XRo
         zRckYx+6uqdthyv9EnFryZr3jYlgrOsTRD79mnsty0MkvW7jV2P9dgpNd6bq7O3IJ2Fq
         blIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VpqRzKtcS5TXJWmQqhzU3QlJUIC8xC901Oo0Sjp2iCc=;
        b=oCP4sqlNjZXhoxMWy5lK0n3lupgNk9i0sLnIaepQdMWNZi+ToEVienIfE4pIge4U9N
         P8AePqxH1YUaIFBtGToHkBC/vJbglcY5veGzTsdVNpQv7WP3PwrKMESgVd9j95dDjTYX
         3N8tC/ENqIj6CEum+DbqTHSY9zLBj5Sq+jgfNuTdzK18cVn0Oi+yFqM2hQ8HFv/f8DQr
         arxfARPugd0IG+b9IjDs3IKFlAKGTcD3LcPWaGNut+799LE5fYcXQHSZYURqkhHV5ek6
         ZD7quwQGUPm313ZHhzDBIuffjbGS4bWI7aH/ElXTRZ3icR8k8nzzaHIJcXxjYHZF/mqL
         Mn0w==
X-Gm-Message-State: AOAM533/rjKP4s6a8Ukny1LzrCNdpoqF/mczsvV+5tMftzg275YiVGDJ
        iXi55VoonitGJm/C6ZbKdIhnWkfwTEaq9LPHVbI=
X-Google-Smtp-Source: ABdhPJyqNnLcoK7X9/7PbFShLNrv5tTMlk+SicgHBXvZ/sdCmuIggX/91OoGFGpkb0fXHtSxwc9h0NXwaDe5Gqg0gDs=
X-Received: by 2002:a81:14c4:0:b0:2dc:da43:3537 with SMTP id
 187-20020a8114c4000000b002dcda433537mr27977810ywu.204.1647402654703; Tue, 15
 Mar 2022 20:50:54 -0700 (PDT)
MIME-Version: 1.0
References: <20220315185603.160778-1-eyal.birger@gmail.com>
 <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com> <CAHsH6Gvj5CVZUVw7-EDrTYzs5vSae3TmFQeRJYuA9wycmVhfOg@mail.gmail.com>
 <377ae473-a908-6dc3-c658-ca2b81d364e0@nvidia.com>
In-Reply-To: <377ae473-a908-6dc3-c658-ca2b81d364e0@nvidia.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Wed, 16 Mar 2022 05:50:43 +0200
Message-ID: <CAHsH6GsW6=OK+=CxaLw_=bcDFspNO4nPmDOTdytpJJYih6khgg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shmulik.ladkani@gmail.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 16, 2022 at 2:33 AM Roopa Prabhu <roopa@nvidia.com> wrote:
>
>
> On 3/15/22 13:22, Eyal Birger wrote:
> > Hi Roopa,
> >
> > On Tue, Mar 15, 2022 at 9:57 PM Roopa Prabhu <roopa@nvidia.com> wrote:
> >>
> >> On 3/15/22 11:56, Eyal Birger wrote:
> >>> This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
> >>>
> >>> In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
> >>> device creation. This property cannot be changed for the time being.
> >>>
> >>> In case IP traffic is received on a non-tun device the drop count is
> >>> increased.
> >>>
> >>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >>> ---
> >>>    drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++-----=
----
> >>>    include/uapi/linux/if_link.h |  1 +
> >>>    2 files changed, 61 insertions(+), 19 deletions(-)
> >>>
> >>> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> >>> index a895ff756093..37305ec26250 100644
> >>> --- a/drivers/net/geneve.c
> >>> +++ b/drivers/net/geneve.c
> >>> @@ -56,6 +56,7 @@ struct geneve_config {
> >>>        bool                    use_udp6_rx_checksums;
> >>>        bool                    ttl_inherit;
> >>>        enum ifla_geneve_df     df;
> >>> +     bool                    tun;
> >>>    };
> >>>
> >>>    /* Pseudo network device */
> >>> @@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve=
, struct geneve_sock *gs,
> >>>                }
> >>>        }
> >>>
> >>> -     skb_reset_mac_header(skb);
> >>> -     skb->protocol =3D eth_type_trans(skb, geneve->dev);
> >>> -     skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> >>> -
> >>>        if (tun_dst)
> >>>                skb_dst_set(skb, &tun_dst->dst);
> >>>
> >>> -     /* Ignore packet loops (and multicast echo) */
> >>> -     if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_a=
ddr)) {
> >>> -             geneve->dev->stats.rx_errors++;
> >>> -             goto drop;
> >>> +     if (gnvh->proto_type =3D=3D htons(ETH_P_TEB)) {
> >>> +             skb_reset_mac_header(skb);
> >>> +             skb->protocol =3D eth_type_trans(skb, geneve->dev);
> >>> +             skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
> >>> +
> >>> +             /* Ignore packet loops (and multicast echo) */
> >>> +             if (ether_addr_equal(eth_hdr(skb)->h_source,
> >>> +                                  geneve->dev->dev_addr)) {
> >>> +                     geneve->dev->stats.rx_errors++;
> >>> +                     goto drop;
> >>> +             }
> >>> +     } else {
> >>> +             skb_reset_mac_header(skb);
> >>> +             skb->dev =3D geneve->dev;
> >>> +             skb->pkt_type =3D PACKET_HOST;
> >>>        }
> >>>
> >>>        oiph =3D skb_network_header(skb);
> >>> @@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk,=
 struct sk_buff *skb)
> >>>        struct genevehdr *geneveh;
> >>>        struct geneve_dev *geneve;
> >>>        struct geneve_sock *gs;
> >>> +     __be16 inner_proto;
> >>>        int opts_len;
> >>>
> >>>        /* Need UDP and Geneve header to be present */
> >>> @@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk=
, struct sk_buff *skb)
> >>>        if (unlikely(geneveh->ver !=3D GENEVE_VER))
> >>>                goto drop;
> >>>
> >>> -     if (unlikely(geneveh->proto_type !=3D htons(ETH_P_TEB)))
> >>> +     inner_proto =3D geneveh->proto_type;
> >>> +
> >>> +     if (unlikely((inner_proto !=3D htons(ETH_P_TEB) &&
> >>> +                   inner_proto !=3D htons(ETH_P_IP) &&
> >>> +                   inner_proto !=3D htons(ETH_P_IPV6)))) {
> >>>                goto drop;
> >>> +     }
> >>>
> >>
> >> unnecessary braces
> > Will fix.
> >
> >>>        gs =3D rcu_dereference_sk_user_data(sk);
> >>>        if (!gs)
> >>> @@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk=
, struct sk_buff *skb)
> >>>        if (!geneve)
> >>>                goto drop;
> >>>
> >>> +     if (unlikely((!geneve->cfg.tun && inner_proto !=3D htons(ETH_P_=
TEB)))) {
> >>> +             geneve->dev->stats.rx_dropped++;
> >>> +             goto drop;
> >>> +     }
> >> Does this change current default behavior ?.
> >>
> >> its unclear to be what the current behavior is for a non ETH_P_TEB pac=
ket
> > Currently non ETH_P_TEB packets are silently dropped.
> > I figured that if the driver supported other ethertypes it would make
> > sense to increase the count in such case, to assist in debugging wrong
> > configurations.
> >
> > I can remove this if it's better to keep the current behavior.
>
> yes, agree. counting is better.
>
>
> >>
> >>> +
> >>>        opts_len =3D geneveh->opt_len * 4;
> >>> -     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
> >>> -                              htons(ETH_P_TEB),
> >>> +     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inne=
r_proto,
> >>>                                 !net_eq(geneve->net, dev_net(geneve->=
dev)))) {
> >>>                geneve->dev->stats.rx_dropped++;
> >>>                goto drop;
> >>> @@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
> >>>    }
> >>>
> >>>    static void geneve_build_header(struct genevehdr *geneveh,
> >>> -                             const struct ip_tunnel_info *info)
> >>> +                             const struct ip_tunnel_info *info,
> >>> +                             __be16 inner_proto)
> >>>    {
> >>>        geneveh->ver =3D GENEVE_VER;
> >>>        geneveh->opt_len =3D info->options_len / 4;
> >>> @@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr =
*geneveh,
> >>>        geneveh->critical =3D !!(info->key.tun_flags & TUNNEL_CRIT_OPT=
);
> >>>        geneveh->rsvd1 =3D 0;
> >>>        tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
> >>> -     geneveh->proto_type =3D htons(ETH_P_TEB);
> >>> +     geneveh->proto_type =3D inner_proto;
> >>>        geneveh->rsvd2 =3D 0;
> >>>
> >>>        if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
> >>> @@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr =
*geneveh,
> >>>
> >>>    static int geneve_build_skb(struct dst_entry *dst, struct sk_buff =
*skb,
> >>>                            const struct ip_tunnel_info *info,
> >>> -                         bool xnet, int ip_hdr_len)
> >>> +                         bool xnet, int ip_hdr_len, bool tun)
> >>>    {
> >>> +     __be16 inner_proto =3D tun ? skb->protocol : htons(ETH_P_TEB);
> >>>        bool udp_sum =3D !!(info->key.tun_flags & TUNNEL_CSUM);
> >>>        struct genevehdr *gnvh;
> >>>        int min_headroom;
> >>> @@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst=
, struct sk_buff *skb,
> >>>                goto free_dst;
> >>>
> >>>        gnvh =3D __skb_push(skb, sizeof(*gnvh) + info->options_len);
> >>> -     geneve_build_header(gnvh, info);
> >>> -     skb_set_inner_protocol(skb, htons(ETH_P_TEB));
> >>> +     geneve_build_header(gnvh, info, inner_proto);
> >>> +     skb_set_inner_protocol(skb, inner_proto);
> >>>        return 0;
> >>>
> >>>    free_dst:
> >>> @@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, s=
truct net_device *dev,
> >>>                }
> >>>        }
> >>>
> >>> -     err =3D geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(stru=
ct iphdr));
> >>> +     err =3D geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(stru=
ct iphdr),
> >>> +                            geneve->cfg.tun);
> >>>        if (unlikely(err))
> >>>                return err;
> >>>
> >>> @@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb=
, struct net_device *dev,
> >>>                        ttl =3D key->ttl;
> >>>                ttl =3D ttl ? : ip6_dst_hoplimit(dst);
> >>>        }
> >>> -     err =3D geneve_build_skb(dst, skb, info, xnet, sizeof(struct ip=
v6hdr));
> >>> +     err =3D geneve_build_skb(dst, skb, info, xnet, sizeof(struct ip=
v6hdr),
> >>> +                            geneve->cfg.tun);
> >>>        if (unlikely(err))
> >>>                return err;
> >>>
> >>> @@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, s=
truct net_device *dev,
> >>>        dst_cache_reset(&geneve->cfg.info.dst_cache);
> >>>        memcpy(&geneve->cfg, cfg, sizeof(*cfg));
> >>>
> >>> +     if (geneve->cfg.tun) {
> >>> +             dev->header_ops =3D NULL;
> >>> +             dev->type =3D ARPHRD_NONE;
> >>> +             dev->hard_header_len =3D 0;
> >>> +             dev->addr_len =3D 0;
> >>> +             dev->flags =3D IFF_NOARP;
> >>> +     }
> >>> +
> >>>        err =3D register_netdevice(dev);
> >>>        if (err)
> >>>                return err;
> >>> @@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[]=
, struct nlattr *data[],
> >>>    #endif
> >>>        }
> >>>
> >>> +     if (data[IFLA_GENEVE_TUN]) {
> >>> +             if (changelink) {
> >>> +                     attrtype =3D IFLA_GENEVE_TUN;
> >>> +                     goto change_notsup;
> >>> +             }
> >>> +             cfg->tun =3D true;
> >>> +     }
> >>> +
> >>>        return 0;
> >>>    change_notsup:
> >>>        NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
> >>> -                         "Changing VNI, Port, endpoint IP address fa=
mily, external, and UDP checksum attributes are not supported");
> >>> +                         "Changing VNI, Port, endpoint IP address fa=
mily, external, tun, and UDP checksum attributes are not supported");
> >>>        return -EOPNOTSUPP;
> >>>    }
> >>>
> >>> @@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb=
, const struct net_device *dev)
> >>>        if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
> >>>                goto nla_put_failure;
> >>>
> >>> +     if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
> >>> +             goto nla_put_failure;
> >>> +
> >>>        return 0;
> >>>
> >>>    nla_put_failure:
> >>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_lin=
k.h
> >>> index bd24c7dc10a2..198aefa2c513 100644
> >>> --- a/include/uapi/linux/if_link.h
> >>> +++ b/include/uapi/linux/if_link.h
> >>> @@ -842,6 +842,7 @@ enum {
> >>>        IFLA_GENEVE_LABEL,
> >>>        IFLA_GENEVE_TTL_INHERIT,
> >>>        IFLA_GENEVE_DF,
> >>> +     IFLA_GENEVE_TUN,
> >> geneve is itself called a tunnel, i wonder if a different name for the
> >> flag would be more appropriate.
> > I tried to find a reference to something similar, so went with somethin=
g like
> > the tun vs. tap distinction. I was also concerned about the possible
> > confusion, but it felt clearer than something like L3_INNER_PROTO_MODE.
> >
> > I'd happily replace it with a better suggestion.
>
> o ok, makes sense. I can't think of anything other than simply
> IFLA_GENEVE_INNER_PROTO
>
> (maybe others have better suggestions)

My concern with calling it IFLA_GENEVE_INNER_PROTO is that inner_proto is
used internally to denote the inner proto value.

Would IFLA_GENEVE_INNER_PROTO_INHERIT make sense?

>
>
> >
> >> what is the use case for this ?. is there a RFC reference ?
> > I stumbled upon this configuration when trying to receive packets from =
an
> > AWS "Gateway Load Balancer" which sends IP packets encapsulated in GENE=
VE [1].
> >
> > But to my understanding the RFC allows this so it doesn't seem somethin=
g
> > specific to AWS.
>
> that makes me wonder if we need a knob atall and if this should be
> allowed by default.

I didn't find a way to make tx work without requiring a flag, so I thought
it'd be better if this mode was enforced in both directions.

>
> wonder how other network vendor standard geneve implementations behave
> by default.
>
>
> >
> > Thanks for the review!
> >
> > Eyal.
> >
> > [1] https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2=
Faws.amazon.com%2Fblogs%2Fnetworking-and-content-delivery%2Fintegrate-your-=
custom-logic-or-appliance-with-aws-gateway-load-balancer%2F&amp;data=3D04%7=
C01%7Croopa%40nvidia.com%7C223c13c616ef430a487f08da06c19610%7C43083d1572734=
0c1b7db39efd9ccc17a%7C0%7C0%7C637829725767772379%7CUnknown%7CTWFpbGZsb3d8ey=
JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp=
;sdata=3DZQTDrFJ8LLn5SdN6h%2B5NECxwlD9PAGV2KzpVUV%2B1chc%3D&amp;reserved=3D=
0
>
> Thanks for the details.
>
>
