Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0B72F9534
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 21:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730296AbhAQUnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 15:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729279AbhAQUnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 15:43:43 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7FBC061574
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:43:03 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id h13so6654437qvo.1
        for <netdev@vger.kernel.org>; Sun, 17 Jan 2021 12:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WlVzZ+/5W6XdXZOg4Bj9PIOc4QgjCn1Xe/pQhKfGz6Y=;
        b=M/pG/fIstaoItZ1u4odrp5hvb/CXMt4QcC+uTfmxz34vfmx0qg00ERtNtCmT6RnkaF
         zdtBaAKj/pphQ9jWrZ/ez+di/8Wn5ldQ5K8M/fhwWSC82LVX9P7bvsboVtrIJHsDt3OF
         TPWchRtjQDZBVgb+FFeeLAhPWpGW9WR/rvyh7ejS+A0imPBCif2GKXaLw4i91ifP3Qkk
         lyRCObBfsrJtBhGWcXRhINv9ddhgWZY4e8c6VaOLJb8CTMEGoJFIKpaiWVPIcVC5gKlv
         YgR0/48rSsfIl/CT4BNYKp5Y8FFs8s0ZjkBGV3Tt9YJ9zp2/cjvbMUJ+55yq23veMfs0
         CEIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WlVzZ+/5W6XdXZOg4Bj9PIOc4QgjCn1Xe/pQhKfGz6Y=;
        b=Il12e31aKvyVySRq4sDjCt94AYZfquBkSbHalJuBXCl1mgb4/3PJ8LKMfZJarOP6RY
         bWyQDkHsiQR+dvXmViigzkAxmRJ5n3HOwmbNt/iUpxETq6LGt1gy6+Zt23IsyX94/xaE
         6pv4JsnQti3ZoPWvOJpSHlalobjJL6c9UXUkQERnsRVVMwKnEdS2/pyJTPwv0m+MsIUs
         WOQJYwZSmUwfBjNXiUhMJTohM8ueKHyEuq9CU9Rf5c0Fnv/rcMfedryc1n82lmi/dqxq
         IDu34t8DwlnGh/Xyq1Hdr7cmTNQBDAAWPNNqN2Bxj7eJJeWZvZecVMsG9B3IVMeboaIk
         Tp9w==
X-Gm-Message-State: AOAM530uheS5FkazZXNYDG/iyDImdKFS0lNEBcfZFL3sK52DSmjL0QhA
        em7mEcaOfiV493NokEVR1kcycvcmddsrsC+7III=
X-Google-Smtp-Source: ABdhPJwPTYPZ21lb08fAwQuyHL4NSVE2w+P0/aFbGFLA3QjCbKSjVk7LGcfrJgknRszxaHcaGfoNztTRdQHMKp48Jr4=
X-Received: by 2002:a05:6214:1868:: with SMTP id eh8mr21365494qvb.50.1610916182009;
 Sun, 17 Jan 2021 12:43:02 -0800 (PST)
MIME-Version: 1.0
References: <20210110070021.26822-1-pbshelar@fb.com> <27b91883-3b65-4f48-00b1-49b2aa9abdcf@norrbonn.se>
In-Reply-To: <27b91883-3b65-4f48-00b1-49b2aa9abdcf@norrbonn.se>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Sun, 17 Jan 2021 12:42:50 -0800
Message-ID: <CAOrHB_D2oZ5KpTuzTHRekHQ9obFM6xWrAHhbw-PtNqzksHLcQw@mail.gmail.com>
Subject: Re: [PATCH net-next v5] GTP: add support for flow based tunneling API
To:     Jonas Bonn <jonas@norrbonn.se>
Cc:     Pravin B Shelar <pbshelar@fb.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Harald Welte <laforge@gnumonks.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 5:46 AM Jonas Bonn <jonas@norrbonn.se> wrote:
>
> Hi Pravin,
>
> Again, this patch is too big and contains too many disparate changes to
> allow for easy review.  Please break this up into a series of logical
> changes for easier review.
>
> On 10/01/2021 08:00, Pravin B Shelar wrote:
> > Following patch add support for flow based tunneling API
> > to send and recv GTP tunnel packet over tunnel metadata API.
> > This would allow this device integration with OVS or eBPF using
> > flow based tunneling APIs.
> >
> > Signed-off-by: Pravin B Shelar <pbshelar@fb.com>
> > ---
> > v4-v5:
> > - coding style changes
> > v3-v4:
> > - add check for non-zero dst port
> > v2-v3:
> > -  Fixed coding style
> > -  changed IFLA_GTP_FD1 to optional param for LWT dev.
> > v1-v2:
> > -  Fixed according to comments from Jonas Bonn
> >
> >   drivers/net/gtp.c                  | 527 +++++++++++++++++++++--------
> >   include/uapi/linux/gtp.h           |  12 +
> >   include/uapi/linux/if_link.h       |   1 +
> >   include/uapi/linux/if_tunnel.h     |   1 +
> >   tools/include/uapi/linux/if_link.h |   1 +
> >   5 files changed, 398 insertions(+), 144 deletions(-)
> >
> > diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
> > index 4c04e271f184..851364314ecc 100644
> > --- a/drivers/net/gtp.c
> > +++ b/drivers/net/gtp.c
> > @@ -21,6 +21,7 @@
> >   #include <linux/file.h>
> >   #include <linux/gtp.h>
> >
> > +#include <net/dst_metadata.h>
> >   #include <net/net_namespace.h>
> >   #include <net/protocol.h>
> >   #include <net/ip.h>
> > @@ -73,6 +74,9 @@ struct gtp_dev {
> >       unsigned int            hash_size;
> >       struct hlist_head       *tid_hash;
> >       struct hlist_head       *addr_hash;
> > +     /* Used by LWT tunnel. */
> > +     bool                    collect_md;
> > +     struct socket           *collect_md_sock;
> >   };
>
> Can't you use the 'sock' member of sk1u as the reference this socket?
As discussed earlier I use it to destroy the LWT socket in the cleanup
code path. I need to test a solution to avoid this reference. I can
send an incremental patch if that works.

>
> >
> >   static unsigned int gtp_net_id __read_mostly;
> > @@ -179,33 +183,121 @@ static bool gtp_check_ms(struct sk_buff *skb, struct pdp_ctx *pctx,
> >       return false;
> >   }
> >
> > -static int gtp_rx(struct pdp_ctx *pctx, struct sk_buff *skb,
> > -                     unsigned int hdrlen, unsigned int role)
> > +static int gtp_set_tun_dst(struct gtp_dev *gtp, struct sk_buff *skb,
> > +                        unsigned int hdrlen, u8 gtp_version,
> > +                        __be64 tid, u8 flags)
> >   {
> > -     if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
> > -             netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
> > -             return 1;
> > +     struct metadata_dst *tun_dst;
> > +     int opts_len = 0;
> > +
> > +     if (unlikely(flags & GTP1_F_MASK))
> > +             opts_len = sizeof(struct gtpu_metadata);
> > +
> > +     tun_dst = udp_tun_rx_dst(skb, gtp->sk1u->sk_family, TUNNEL_KEY, tid, opts_len);
> > +     if (!tun_dst) {
> > +             netdev_dbg(gtp->dev, "Failed to allocate tun_dst");
> > +             goto err;
> >       }
> >
> > +     netdev_dbg(gtp->dev, "attaching metadata_dst to skb, gtp ver %d hdrlen %d\n",
> > +                gtp_version, hdrlen);
> > +     if (unlikely(opts_len)) {
> > +             struct gtpu_metadata *opts;
> > +             struct gtp1_header *gtp1;
> > +
> > +             opts = ip_tunnel_info_opts(&tun_dst->u.tun_info);
> > +             gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
> > +             opts->ver = GTP_METADATA_V1;
> > +             opts->flags = gtp1->flags;
> > +             opts->type = gtp1->type;
> > +             netdev_dbg(gtp->dev, "recved control pkt: flag %x type: %d\n",
> > +                        opts->flags, opts->type);
> > +             tun_dst->u.tun_info.key.tun_flags |= TUNNEL_GTPU_OPT;
> > +             tun_dst->u.tun_info.options_len = opts_len;
> > +             skb->protocol = htons(0xffff);         /* Unknown */
> > +     }
> >       /* Get rid of the GTP + UDP headers. */
> >       if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> > -                              !net_eq(sock_net(pctx->sk), dev_net(pctx->dev))))
> > -             return -1;
> > +                              !net_eq(sock_net(gtp->sk1u), dev_net(gtp->dev)))) {
> > +             gtp->dev->stats.rx_length_errors++;
> > +             goto err;
> > +     }
> > +
> > +     skb_dst_set(skb, &tun_dst->dst);
> > +     return 0;
> > +err:
> > +     return -1;
> > +}
> > +
> > +static int gtp_rx(struct gtp_dev *gtp, struct sk_buff *skb,
> > +               unsigned int hdrlen, u8 gtp_version, unsigned int role,
> > +               __be64 tid, u8 flags, u8 type)
> > +{
> > +     if (ip_tunnel_collect_metadata() || gtp->collect_md) {
> > +             int err;
> > +
> > +             err = gtp_set_tun_dst(gtp, skb, hdrlen, gtp_version, tid, flags);
> > +             if (err)
> > +                     goto err;
> > +     } else {
> > +             struct pdp_ctx *pctx;
> > +
> > +             if (flags & GTP1_F_MASK)
> > +                     hdrlen += 4;
> >
> > -     netdev_dbg(pctx->dev, "forwarding packet from GGSN to uplink\n");
> > +             if (type != GTP_TPDU)
> > +                     return 1;
> > +
> > +             if (gtp_version == GTP_V0)
> > +                     pctx = gtp0_pdp_find(gtp, be64_to_cpu(tid));
> > +             else
> > +                     pctx = gtp1_pdp_find(gtp, be64_to_cpu(tid));
> > +             if (!pctx) {
> > +                     netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
> > +                     return 1;
> > +             }
> > +
> > +             if (!gtp_check_ms(skb, pctx, hdrlen, role)) {
> > +                     netdev_dbg(pctx->dev, "No PDP ctx for this MS\n");
> > +                     return 1;
> > +             }
> > +             /* Get rid of the GTP + UDP headers. */
> > +             if (iptunnel_pull_header(skb, hdrlen, skb->protocol,
> > +                                      !net_eq(sock_net(pctx->sk), dev_net(gtp->dev)))) {
> > +                     gtp->dev->stats.rx_length_errors++;
> > +                     goto err;
> > +             }
> > +     }
> > +     netdev_dbg(gtp->dev, "forwarding packet from GGSN to uplink\n");
> >
> >       /* Now that the UDP and the GTP header have been removed, set up the
> >        * new network header. This is required by the upper layer to
> >        * calculate the transport header.
> >        */
> >       skb_reset_network_header(skb);
> > +     if (pskb_may_pull(skb, sizeof(struct iphdr))) {
> > +             struct iphdr *iph;
> > +
> > +             iph = ip_hdr(skb);
> > +             if (iph->version == 4) {
> > +                     netdev_dbg(gtp->dev, "inner pkt: ipv4");
> > +                     skb->protocol = htons(ETH_P_IP);
> > +             } else if (iph->version == 6) {
> > +                     netdev_dbg(gtp->dev, "inner pkt: ipv6");
> > +                     skb->protocol = htons(ETH_P_IPV6);
> > +             } else {
> > +                     netdev_dbg(gtp->dev, "inner pkt error: Unknown type");
> > +             }
> > +     }
> >
> > -     skb->dev = pctx->dev;
> > -
> > -     dev_sw_netstats_rx_add(pctx->dev, skb->len);
> > -
> > +     skb->dev = gtp->dev;
> > +     dev_sw_netstats_rx_add(gtp->dev, skb->len);
> >       netif_rx(skb);
> >       return 0;
> > +
> > +err:
> > +     gtp->dev->stats.rx_dropped++;
> > +     return -1;
> >   }
> >
> >   /* 1 means pass up to the stack, -1 means drop and 0 means decapsulated. */
> > @@ -214,7 +306,6 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
> >       unsigned int hdrlen = sizeof(struct udphdr) +
> >                             sizeof(struct gtp0_header);
> >       struct gtp0_header *gtp0;
> > -     struct pdp_ctx *pctx;
> >
> >       if (!pskb_may_pull(skb, hdrlen))
> >               return -1;
> > @@ -224,16 +315,7 @@ static int gtp0_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
> >       if ((gtp0->flags >> 5) != GTP_V0)
> >               return 1;
> >
> > -     if (gtp0->type != GTP_TPDU)
> > -             return 1;
> > -
> > -     pctx = gtp0_pdp_find(gtp, be64_to_cpu(gtp0->tid));
> > -     if (!pctx) {
> > -             netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
> > -             return 1;
> > -     }
> > -
> > -     return gtp_rx(pctx, skb, hdrlen, gtp->role);
> > +     return gtp_rx(gtp, skb, hdrlen, GTP_V0, gtp->role, gtp0->tid, gtp0->flags, gtp0->type);
> >   }
> >
> >   static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
> > @@ -241,41 +323,30 @@ static int gtp1u_udp_encap_recv(struct gtp_dev *gtp, struct sk_buff *skb)
> >       unsigned int hdrlen = sizeof(struct udphdr) +
> >                             sizeof(struct gtp1_header);
> >       struct gtp1_header *gtp1;
> > -     struct pdp_ctx *pctx;
> >
> >       if (!pskb_may_pull(skb, hdrlen))
> >               return -1;
> >
> >       gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
> >
> > +     netdev_dbg(gtp->dev, "GTPv1 recv: flags %x\n", gtp1->flags);
> >       if ((gtp1->flags >> 5) != GTP_V1)
> >               return 1;
> >
> > -     if (gtp1->type != GTP_TPDU)
> > -             return 1;
> > -
> >       /* From 29.060: "This field shall be present if and only if any one or
> >        * more of the S, PN and E flags are set.".
> >        *
> >        * If any of the bit is set, then the remaining ones also have to be
> >        * set.
> >        */
> > -     if (gtp1->flags & GTP1_F_MASK)
> > -             hdrlen += 4;
> > -
> >       /* Make sure the header is larger enough, including extensions. */
> >       if (!pskb_may_pull(skb, hdrlen))
> >               return -1;
> >
> >       gtp1 = (struct gtp1_header *)(skb->data + sizeof(struct udphdr));
> >
> > -     pctx = gtp1_pdp_find(gtp, ntohl(gtp1->tid));
> > -     if (!pctx) {
> > -             netdev_dbg(gtp->dev, "No PDP ctx to decap skb=%p\n", skb);
> > -             return 1;
> > -     }
> > -
> > -     return gtp_rx(pctx, skb, hdrlen, gtp->role);
> > +     return gtp_rx(gtp, skb, hdrlen, GTP_V1, gtp->role,
> > +                   key32_to_tunnel_id(gtp1->tid), gtp1->flags, gtp1->type);
> >   }
> >
> >   static void __gtp_encap_destroy(struct sock *sk)
> > @@ -315,6 +386,11 @@ static void gtp_encap_disable(struct gtp_dev *gtp)
> >   {
> >       gtp_encap_disable_sock(gtp->sk0);
> >       gtp_encap_disable_sock(gtp->sk1u);
> > +     if (gtp->collect_md_sock) {
> > +             udp_tunnel_sock_release(gtp->collect_md_sock);
> > +             gtp->collect_md_sock = NULL;
> > +             netdev_dbg(gtp->dev, "GTP socket released.\n");
> > +     }
> >   }
> >
> >   /* UDP encapsulation receive handler. See net/ipv4/udp.c.
> > @@ -329,7 +405,8 @@ static int gtp_encap_recv(struct sock *sk, struct sk_buff *skb)
> >       if (!gtp)
> >               return 1;
> >
> > -     netdev_dbg(gtp->dev, "encap_recv sk=%p\n", sk);
> > +     netdev_dbg(gtp->dev, "encap_recv sk=%p type %d\n",
> > +                sk, udp_sk(sk)->encap_type);
> >
> >       switch (udp_sk(sk)->encap_type) {
> >       case UDP_ENCAP_GTP0:
> > @@ -383,12 +460,13 @@ static void gtp_dev_uninit(struct net_device *dev)
> >
> >   static struct rtable *ip4_route_output_gtp(struct flowi4 *fl4,
> >                                          const struct sock *sk,
> > -                                        __be32 daddr)
> > +                                        __be32 daddr,
> > +                                        __be32 saddr)
> >   {
> >       memset(fl4, 0, sizeof(*fl4));
> >       fl4->flowi4_oif         = sk->sk_bound_dev_if;
> >       fl4->daddr              = daddr;
> > -     fl4->saddr              = inet_sk(sk)->inet_saddr;
> > +     fl4->saddr              = saddr;
> >       fl4->flowi4_tos         = RT_CONN_FLAGS(sk);
> >       fl4->flowi4_proto       = sk->sk_protocol;
> >
> > @@ -412,7 +490,7 @@ static inline void gtp0_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
> >       gtp0->tid       = cpu_to_be64(pctx->u.v0.tid);
> >   }
> >
> > -static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
> > +static inline void gtp1_push_header(struct sk_buff *skb, __be32 tid)
> >   {
> >       int payload_len = skb->len;
> >       struct gtp1_header *gtp1;
> > @@ -428,46 +506,63 @@ static inline void gtp1_push_header(struct sk_buff *skb, struct pdp_ctx *pctx)
> >       gtp1->flags     = 0x30; /* v1, GTP-non-prime. */
> >       gtp1->type      = GTP_TPDU;
> >       gtp1->length    = htons(payload_len);
> > -     gtp1->tid       = htonl(pctx->u.v1.o_tei);
> > +     gtp1->tid       = tid;
> >
> >       /* TODO: Suppport for extension header, sequence number and N-PDU.
> >        *       Update the length field if any of them is available.
> >        */
> >   }
> >
> > -struct gtp_pktinfo {
> > -     struct sock             *sk;
> > -     struct iphdr            *iph;
> > -     struct flowi4           fl4;
> > -     struct rtable           *rt;
> > -     struct pdp_ctx          *pctx;
> > -     struct net_device       *dev;
> > -     __be16                  gtph_port;
> > -};
> > -
> > -static void gtp_push_header(struct sk_buff *skb, struct gtp_pktinfo *pktinfo)
> > +static inline int gtp1_push_control_header(struct sk_buff *skb,
> > +                                        __be32 tid,
> > +                                        struct gtpu_metadata *opts,
> > +                                        struct net_device *dev)
> >   {
> > -     switch (pktinfo->pctx->gtp_version) {
> > -     case GTP_V0:
> > -             pktinfo->gtph_port = htons(GTP0_PORT);
> > -             gtp0_push_header(skb, pktinfo->pctx);
> > -             break;
> > -     case GTP_V1:
> > -             pktinfo->gtph_port = htons(GTP1U_PORT);
> > -             gtp1_push_header(skb, pktinfo->pctx);
> > -             break;
> > +     struct gtp1_header *gtp1c;
> > +     int payload_len;
> > +
> > +     if (opts->ver != GTP_METADATA_V1)
> > +             return -ENOENT;
> > +
> > +     if (opts->type == 0xFE) {
> > +             /* for end marker ignore skb data. */
> > +             netdev_dbg(dev, "xmit pkt with null data");
> > +             pskb_trim(skb, 0);
> >       }
>
> This is new functionality...???  Separate patch, please.
>
> > +     if (skb_cow_head(skb, sizeof(*gtp1c)) < 0)
> > +             return -ENOMEM;
> > +
> > +     payload_len = skb->len;
> > +
> > +     gtp1c = skb_push(skb, sizeof(*gtp1c));
> > +
> > +     gtp1c->flags    = opts->flags;
> > +     gtp1c->type     = opts->type;
> > +     gtp1c->length   = htons(payload_len);
> > +     gtp1c->tid      = tid;
> > +     netdev_dbg(dev, "xmit control pkt: ver %d flags %x type %x pkt len %d tid %x",
> > +                opts->ver, opts->flags, opts->type, skb->len, tid);
> > +     return 0;
> >   }
> >
> > +struct gtp_pktinfo {
> > +     struct sock             *sk;
> > +     __u8                    tos;
> > +     struct flowi4           fl4;
> > +     struct rtable           *rt;
> > +     struct net_device       *dev;
> > +     __be16                  gtph_port;
> > +};
> > +
>
> There are significant changes to this structure... can't these be made
> seaparately from the main patch adding flow tunneling?
>
This is static scoped structure passed between functions. Without this
change GTP LTW can not reuse existing functions.

> >   static inline void gtp_set_pktinfo_ipv4(struct gtp_pktinfo *pktinfo,
> > -                                     struct sock *sk, struct iphdr *iph,
> > -                                     struct pdp_ctx *pctx, struct rtable *rt,
> > +                                     struct sock *sk,
> > +                                     __u8 tos,
> > +                                     struct rtable *rt,
> >                                       struct flowi4 *fl4,
> >                                       struct net_device *dev)
> >   {
> >       pktinfo->sk     = sk;
> > -     pktinfo->iph    = iph;
> > -     pktinfo->pctx   = pctx;
> > +     pktinfo->tos    = tos;
> >       pktinfo->rt     = rt;
> >       pktinfo->fl4    = *fl4;
> >       pktinfo->dev    = dev;
> > @@ -477,40 +572,99 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
> >                            struct gtp_pktinfo *pktinfo)
> >   {
> >       struct gtp_dev *gtp = netdev_priv(dev);
> > +     struct gtpu_metadata *opts = NULL;
> > +     struct sock *sk = NULL;
> >       struct pdp_ctx *pctx;
> >       struct rtable *rt;
> >       struct flowi4 fl4;
> > -     struct iphdr *iph;
> > -     __be16 df;
> > +     u8 gtp_version;
> > +     __be16 df = 0;
> > +     __be32 tun_id;
> > +     __be32 daddr;
> > +     __be32 saddr;
> > +     __u8 tos;
> >       int mtu;
> >
> > -     /* Read the IP destination address and resolve the PDP context.
> > -      * Prepend PDP header with TEI/TID from PDP ctx.
> > -      */
> > -     iph = ip_hdr(skb);
> > -     if (gtp->role == GTP_ROLE_SGSN)
> > -             pctx = ipv4_pdp_find(gtp, iph->saddr);
> > -     else
> > -             pctx = ipv4_pdp_find(gtp, iph->daddr);
> > +     if (gtp->collect_md) {
> > +             /* LWT GTP1U encap */
> > +             struct ip_tunnel_info *info = NULL;
> >
> > -     if (!pctx) {
> > -             netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> > -                        &iph->daddr);
> > -             return -ENOENT;
> > +             info = skb_tunnel_info(skb);
> > +             if (!info) {
> > +                     netdev_dbg(dev, "missing tunnel info");
> > +                     return -ENOENT;
> > +             }
> > +             if (info->key.tp_dst && ntohs(info->key.tp_dst) != GTP1U_PORT) {
> > +                     netdev_dbg(dev, "unexpected GTP dst port: %d", ntohs(info->key.tp_dst));
> > +                     return -EOPNOTSUPP;
> > +             }
> > +             pctx = NULL;
> > +             gtp_version = GTP_V1;
> > +             tun_id = tunnel_id_to_key32(info->key.tun_id);
> > +             daddr = info->key.u.ipv4.dst;
> > +             saddr = info->key.u.ipv4.src;
> > +             sk = gtp->sk1u;
> > +             if (!sk) {
> > +                     netdev_dbg(dev, "missing tunnel sock");
> > +                     return -EOPNOTSUPP;
> > +             }
> > +             tos = info->key.tos;
> > +             if (info->key.tun_flags & TUNNEL_DONT_FRAGMENT)
> > +                     df = htons(IP_DF);
> > +
> > +             if (info->options_len != 0) {
> > +                     if (info->key.tun_flags & TUNNEL_GTPU_OPT) {
> > +                             opts = ip_tunnel_info_opts(info);
> > +                     } else {
> > +                             netdev_dbg(dev, "missing tunnel metadata for control pkt");
> > +                             return -EOPNOTSUPP;
> > +                     }
> > +             }
> > +             netdev_dbg(dev, "flow-based GTP1U encap: tunnel id %d\n",
> > +                        be32_to_cpu(tun_id));
> > +     } else {
> > +             struct iphdr *iph;
> > +
> > +             if (ntohs(skb->protocol) != ETH_P_IP)
> > +                     return -EOPNOTSUPP;
> > +
> > +             iph = ip_hdr(skb);
> > +
> > +             /* Read the IP destination address and resolve the PDP context.
> > +              * Prepend PDP header with TEI/TID from PDP ctx.
> > +              */
> > +             if (gtp->role == GTP_ROLE_SGSN)
> > +                     pctx = ipv4_pdp_find(gtp, iph->saddr);
> > +             else
> > +                     pctx = ipv4_pdp_find(gtp, iph->daddr);
> > +
> > +             if (!pctx) {
> > +                     netdev_dbg(dev, "no PDP ctx found for %pI4, skip\n",
> > +                                &iph->daddr);
> > +                     return -ENOENT;
> > +             }
> > +             sk = pctx->sk;
> > +             netdev_dbg(dev, "found PDP context %p\n", pctx);
> > +
> > +             gtp_version = pctx->gtp_version;
> > +             tun_id  = htonl(pctx->u.v1.o_tei);
> > +             daddr = pctx->peer_addr_ip4.s_addr;
> > +             saddr = inet_sk(sk)->inet_saddr;
> > +             tos = iph->tos;
> > +             df = iph->frag_off;
> > +             netdev_dbg(dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> > +                        &iph->saddr, &iph->daddr);
> >       }
> > -     netdev_dbg(dev, "found PDP context %p\n", pctx);
>
> Please refactor the above so that the resulting patch set becomes less
> invasive.  There's a lot of unnecessary code movement happening here
> that will result in unnecessary pain when rebasing on top of this.
>
I am trying to reuse existing xmit and recv functionality of GTP
driver. Are you suggesting to introduce duplicate code for LWT
datapath?


> >
> > -     rt = ip4_route_output_gtp(&fl4, pctx->sk, pctx->peer_addr_ip4.s_addr);
> > +     rt = ip4_route_output_gtp(&fl4, sk, daddr, saddr);
> >       if (IS_ERR(rt)) {
> > -             netdev_dbg(dev, "no route to SSGN %pI4\n",
> > -                        &pctx->peer_addr_ip4.s_addr);
> > +             netdev_dbg(dev, "no route to SSGN %pI4\n", &daddr);
> >               dev->stats.tx_carrier_errors++;
> >               goto err;
> >       }
> >
> >       if (rt->dst.dev == dev) {
> > -             netdev_dbg(dev, "circular route to SSGN %pI4\n",
> > -                        &pctx->peer_addr_ip4.s_addr);
> > +             netdev_dbg(dev, "circular route to SSGN %pI4\n", &daddr);
> >               dev->stats.collisions++;
> >               goto err_rt;
> >       }
> > @@ -518,11 +672,10 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
> >       skb_dst_drop(skb);
> >
> >       /* This is similar to tnl_update_pmtu(). */
> > -     df = iph->frag_off;
> >       if (df) {
> >               mtu = dst_mtu(&rt->dst) - dev->hard_header_len -
> >                       sizeof(struct iphdr) - sizeof(struct udphdr);
> > -             switch (pctx->gtp_version) {
> > +             switch (gtp_version) {
> >               case GTP_V0:
> >                       mtu -= sizeof(struct gtp0_header);
> >                       break;
> > @@ -536,17 +689,38 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
> >
> >       rt->dst.ops->update_pmtu(&rt->dst, NULL, skb, mtu, false);
> >
> > -     if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
> > -         mtu < ntohs(iph->tot_len)) {
> > -             netdev_dbg(dev, "packet too big, fragmentation needed\n");
> > +     if (!skb_is_gso(skb) && (df & htons(IP_DF)) && mtu < skb->len) {
> > +             netdev_dbg(dev, "packet too big, fragmentation needed");
> >               memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
> >               icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
> >                             htonl(mtu));
> >               goto err_rt;
> >       }
> >
> > -     gtp_set_pktinfo_ipv4(pktinfo, pctx->sk, iph, pctx, rt, &fl4, dev);
> > -     gtp_push_header(skb, pktinfo);
> > +     gtp_set_pktinfo_ipv4(pktinfo, sk, tos, rt, &fl4, dev);
> > +
> > +     if (unlikely(opts)) {
> > +             int err;
> > +
> > +             pktinfo->gtph_port = htons(GTP1U_PORT);
> > +             err = gtp1_push_control_header(skb, tun_id, opts, dev);
> > +             if (err) {
> > +                     netdev_info(dev, "cntr pkt error %d", err);
> > +                     goto err_rt;
> > +             }
> > +             return 0;
> > +     }
> > +
> > +     switch (gtp_version) {
> > +     case GTP_V0:
> > +             pktinfo->gtph_port = htons(GTP0_PORT);
> > +             gtp0_push_header(skb, pctx);
> > +             break;
> > +     case GTP_V1:
> > +             pktinfo->gtph_port = htons(GTP1U_PORT);
> > +             gtp1_push_header(skb, tun_id);
> > +             break;
> > +     }
> >
> >       return 0;
> >   err_rt:
> > @@ -557,7 +731,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
> >
> >   static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
> >   {
> > -     unsigned int proto = ntohs(skb->protocol);
> >       struct gtp_pktinfo pktinfo;
> >       int err;
> >
> > @@ -569,32 +742,22 @@ static netdev_tx_t gtp_dev_xmit(struct sk_buff *skb, struct net_device *dev)
> >
> >       /* PDP context lookups in gtp_build_skb_*() need rcu read-side lock. */
> >       rcu_read_lock();
> > -     switch (proto) {
> > -     case ETH_P_IP:
> > -             err = gtp_build_skb_ip4(skb, dev, &pktinfo);
> > -             break;
> > -     default:
> > -             err = -EOPNOTSUPP;
> > -             break;
> > -     }
> > +     err = gtp_build_skb_ip4(skb, dev, &pktinfo);
> >       rcu_read_unlock();
> >
> >       if (err < 0)
> >               goto tx_err;
> >
> > -     switch (proto) {
> > -     case ETH_P_IP:
> > -             netdev_dbg(pktinfo.dev, "gtp -> IP src: %pI4 dst: %pI4\n",
> > -                        &pktinfo.iph->saddr, &pktinfo.iph->daddr);
> > -             udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
> > -                                 pktinfo.fl4.saddr, pktinfo.fl4.daddr,
> > -                                 pktinfo.iph->tos,
> > -                                 ip4_dst_hoplimit(&pktinfo.rt->dst),
> > -                                 0,
> > -                                 pktinfo.gtph_port, pktinfo.gtph_port,
> > -                                 true, false);
> > -             break;
> > -     }
> > +     udp_tunnel_xmit_skb(pktinfo.rt, pktinfo.sk, skb,
> > +                         pktinfo.fl4.saddr,
> > +                         pktinfo.fl4.daddr,
> > +                         pktinfo.tos,
> > +                         ip4_dst_hoplimit(&pktinfo.rt->dst),
> > +                         0,
> > +                         pktinfo.gtph_port,
> > +                         pktinfo.gtph_port,
> > +                         true,
> > +                         false);
> >
> >       return NETDEV_TX_OK;
> >   tx_err:
> > @@ -610,6 +773,19 @@ static const struct net_device_ops gtp_netdev_ops = {
> >       .ndo_get_stats64        = dev_get_tstats64,
> >   };
> >
> > +static struct gtp_dev *gtp_find_flow_based_dev(struct net *net)
> > +{
> > +     struct gtp_net *gn = net_generic(net, gtp_net_id);
> > +     struct gtp_dev *gtp;
> > +
> > +     list_for_each_entry(gtp, &gn->gtp_dev_list, list) {
> > +             if (gtp->collect_md)
> > +                     return gtp;
> > +     }
> > +
> > +     return NULL;
> > +}
> > +
> >   static void gtp_link_setup(struct net_device *dev)
> >   {
> >       dev->netdev_ops         = &gtp_netdev_ops;
> > @@ -634,7 +810,7 @@ static void gtp_link_setup(struct net_device *dev)
> >   }
> >
> >   static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize);
> > -static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[]);
> > +static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[]);
> >
> >   static void gtp_destructor(struct net_device *dev)
> >   {
> > @@ -652,11 +828,24 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >       struct gtp_net *gn;
> >       int hashsize, err;
> >
> > -     if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1])
> > +     if (!data[IFLA_GTP_FD0] && !data[IFLA_GTP_FD1] &&
> > +         !data[IFLA_GTP_COLLECT_METADATA])
> >               return -EINVAL;
>
> You're allowing the fd=NULL case for the COLLECT_METADATA variant, but
> you might as well allow it unconditionally since you have the
> create_gtp_socket() function now to handle this for you.
>
I can send an incremental patch for this.

> >
> >       gtp = netdev_priv(dev);
> >
> > +     if (data[IFLA_GTP_COLLECT_METADATA]) {
> > +             if (data[IFLA_GTP_FD0]) {
> > +                     netdev_dbg(dev, "LWT device does not support setting v0 socket");
> > +                     return -EINVAL;
> > +             }
> > +             if (gtp_find_flow_based_dev(src_net)) {
> > +                     netdev_dbg(dev, "LWT device already exist");
> > +                     return -EBUSY;
> > +             }
> > +             gtp->collect_md = true;
> > +     }
> > +
> >       if (!data[IFLA_GTP_PDP_HASHSIZE]) {
> >               hashsize = 1024;
> >       } else {
> > @@ -669,7 +858,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >       if (err < 0)
> >               return err;
> >
> > -     err = gtp_encap_enable(gtp, data);
> > +     err = gtp_encap_enable(gtp, dev, data);
> >       if (err < 0)
> >               goto out_hashtable;
> >
> > @@ -683,7 +872,7 @@ static int gtp_newlink(struct net *src_net, struct net_device *dev,
> >       list_add_rcu(&gtp->list, &gn->gtp_dev_list);
> >       dev->priv_destructor = gtp_destructor;
> >
> > -     netdev_dbg(dev, "registered new GTP interface\n");
> > +     netdev_dbg(dev, "registered new GTP interface %s\n", dev->name);
> >
> >       return 0;
> >
> > @@ -714,6 +903,7 @@ static const struct nla_policy gtp_policy[IFLA_GTP_MAX + 1] = {
> >       [IFLA_GTP_FD1]                  = { .type = NLA_U32 },
> >       [IFLA_GTP_PDP_HASHSIZE]         = { .type = NLA_U32 },
> >       [IFLA_GTP_ROLE]                 = { .type = NLA_U32 },
> > +     [IFLA_GTP_COLLECT_METADATA]     = { .type = NLA_FLAG },
> >   };
> >
> >   static int gtp_validate(struct nlattr *tb[], struct nlattr *data[],
> > @@ -737,6 +927,9 @@ static int gtp_fill_info(struct sk_buff *skb, const struct net_device *dev)
> >       if (nla_put_u32(skb, IFLA_GTP_PDP_HASHSIZE, gtp->hash_size))
> >               goto nla_put_failure;
> >
> > +     if (gtp->collect_md && nla_put_flag(skb, IFLA_GTP_COLLECT_METADATA))
> > +             goto nla_put_failure;
> > +
> >       return 0;
> >
> >   nla_put_failure:
> > @@ -782,35 +975,24 @@ static int gtp_hashtable_new(struct gtp_dev *gtp, int hsize)
> >       return -ENOMEM;
> >   }
> >
> > -static struct sock *gtp_encap_enable_socket(int fd, int type,
> > -                                         struct gtp_dev *gtp)
> > +static int __gtp_encap_enable_socket(struct socket *sock, int type,
> > +                                  struct gtp_dev *gtp)
> >   {
> >       struct udp_tunnel_sock_cfg tuncfg = {NULL};
> > -     struct socket *sock;
> >       struct sock *sk;
> > -     int err;
> > -
> > -     pr_debug("enable gtp on %d, %d\n", fd, type);
> > -
> > -     sock = sockfd_lookup(fd, &err);
> > -     if (!sock) {
> > -             pr_debug("gtp socket fd=%d not found\n", fd);
> > -             return NULL;
> > -     }
> >
> >       sk = sock->sk;
> >       if (sk->sk_protocol != IPPROTO_UDP ||
> >           sk->sk_type != SOCK_DGRAM ||
> >           (sk->sk_family != AF_INET && sk->sk_family != AF_INET6)) {
> > -             pr_debug("socket fd=%d not UDP\n", fd);
> > -             sk = ERR_PTR(-EINVAL);
> > -             goto out_sock;
> > +             pr_debug("socket not UDP\n");
> > +             return -EINVAL;
> >       }
> >
> >       lock_sock(sk);
> >       if (sk->sk_user_data) {
> > -             sk = ERR_PTR(-EBUSY);
> > -             goto out_rel_sock;
> > +             release_sock(sock->sk);
> > +             return -EBUSY;
> >       }
> >
> >       sock_hold(sk);
> > @@ -821,15 +1003,58 @@ static struct sock *gtp_encap_enable_socket(int fd, int type,
> >       tuncfg.encap_destroy = gtp_encap_destroy;
> >
> >       setup_udp_tunnel_sock(sock_net(sock->sk), sock, &tuncfg);
> > -
> > -out_rel_sock:
> >       release_sock(sock->sk);
> > -out_sock:
> > +     return 0;
> > +}
> > +
> > +static struct sock *gtp_encap_enable_socket(int fd, int type,
> > +                                         struct gtp_dev *gtp)
> > +{
> > +     struct socket *sock;
> > +     int err;
> > +
> > +     pr_debug("enable gtp on %d, %d\n", fd, type);
> > +
> > +     sock = sockfd_lookup(fd, &err);
> > +     if (!sock) {
> > +             pr_debug("gtp socket fd=%d not found\n", fd);
> > +             return NULL;
> > +     }
> > +     err =  __gtp_encap_enable_socket(sock, type, gtp);
> >       sockfd_put(sock);
> > -     return sk;
> > +     if (err)
> > +             return ERR_PTR(err);
> > +
> > +     return sock->sk;
> >   }
> >
> > -static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
> > +static struct socket *gtp_create_gtp_socket(struct gtp_dev *gtp, struct net_device *dev)
> > +{
> > +     struct udp_port_cfg udp_conf;
> > +     struct socket *sock;
> > +     int err;
> > +
> > +     memset(&udp_conf, 0, sizeof(udp_conf));
> > +     udp_conf.family = AF_INET;
> > +     udp_conf.local_ip.s_addr = htonl(INADDR_ANY);
> > +     udp_conf.local_udp_port = htons(GTP1U_PORT);
> > +
> > +     err = udp_sock_create(dev_net(dev), &udp_conf, &sock);
> > +     if (err < 0) {
> > +             pr_debug("create gtp sock failed: %d\n", err);
> > +             return ERR_PTR(err);
> > +     }
> > +     err = __gtp_encap_enable_socket(sock, UDP_ENCAP_GTP1U, gtp);
> > +     if (err) {
> > +             pr_debug("enable gtp sock encap failed: %d\n", err);
> > +             udp_tunnel_sock_release(sock);
> > +             return ERR_PTR(err);
> > +     }
> > +     pr_debug("create gtp sock done\n");
> > +     return sock;
> > +}
> > +
> > +static int gtp_encap_enable(struct gtp_dev *gtp, struct net_device *dev, struct nlattr *data[])
> >   {
> >       struct sock *sk1u = NULL;
> >       struct sock *sk0 = NULL;
> > @@ -853,11 +1078,25 @@ static int gtp_encap_enable(struct gtp_dev *gtp, struct nlattr *data[])
> >               }
> >       }
> >
> > +     if (data[IFLA_GTP_COLLECT_METADATA]) {
> > +             struct socket *sock;
> > +
> > +             if (!sk1u) {
> > +                     sock = gtp_create_gtp_socket(gtp, dev);
> > +                     if (IS_ERR(sock))
> > +                             return PTR_ERR(sock);
> > +
> > +                     gtp->collect_md_sock = sock;
> > +                     sk1u = sock->sk;
> > +             } else {
> > +                     gtp->collect_md_sock = NULL;
> > +             }
> > +     }
> > +
>
> If you're adding a gtp_create_gtp_socket() function, then that s
>
This looks like an incomplete comment. Not sure what you mean here.


> >       if (data[IFLA_GTP_ROLE]) {
> >               role = nla_get_u32(data[IFLA_GTP_ROLE]);
> >               if (role > GTP_ROLE_SGSN) {
> > -                     gtp_encap_disable_sock(sk0);
> > -                     gtp_encap_disable_sock(sk1u);
> > +                     gtp_encap_disable(gtp);
> >                       return -EINVAL;
> >               }
> >       }
> > @@ -1416,7 +1655,7 @@ static int __init gtp_init(void)
> >       if (err < 0)
> >               goto unreg_genl_family;
> >
> > -     pr_info("GTP module loaded (pdp ctx size %zd bytes)\n",
> > +     pr_info("GTP module loaded (pdp ctx size %zd bytes) with tnl-md support\n",
> >               sizeof(struct pdp_ctx));
> >       return 0;
> >
> > diff --git a/include/uapi/linux/gtp.h b/include/uapi/linux/gtp.h
> > index 79f9191bbb24..62aff78b7c56 100644
> > --- a/include/uapi/linux/gtp.h
> > +++ b/include/uapi/linux/gtp.h
> > @@ -2,6 +2,8 @@
> >   #ifndef _UAPI_LINUX_GTP_H_
> >   #define _UAPI_LINUX_GTP_H_
> >
> > +#include <linux/types.h>
> > +
> >   #define GTP_GENL_MCGRP_NAME "gtp"
> >
> >   enum gtp_genl_cmds {
> > @@ -34,4 +36,14 @@ enum gtp_attrs {
> >   };
> >   #define GTPA_MAX (__GTPA_MAX + 1)
> >
> > +enum {
> > +     GTP_METADATA_V1
> > +};
> > +
> > +struct gtpu_metadata {
> > +     __u8    ver;
> > +     __u8    flags;
> > +     __u8    type;
> > +};
> > +
> >   #endif /* _UAPI_LINUX_GTP_H_ */
> > diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
> > index 82708c6db432..2bd0d8bbcdb2 100644
> > --- a/include/uapi/linux/if_link.h
> > +++ b/include/uapi/linux/if_link.h
> > @@ -809,6 +809,7 @@ enum {
> >       IFLA_GTP_FD1,
> >       IFLA_GTP_PDP_HASHSIZE,
> >       IFLA_GTP_ROLE,
> > +     IFLA_GTP_COLLECT_METADATA,
> >       __IFLA_GTP_MAX,
> >   };
> >   #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
> > diff --git a/include/uapi/linux/if_tunnel.h b/include/uapi/linux/if_tunnel.h
> > index 7d9105533c7b..802da679fab1 100644
> > --- a/include/uapi/linux/if_tunnel.h
> > +++ b/include/uapi/linux/if_tunnel.h
> > @@ -176,6 +176,7 @@ enum {
> >   #define TUNNEL_VXLAN_OPT    __cpu_to_be16(0x1000)
> >   #define TUNNEL_NOCACHE              __cpu_to_be16(0x2000)
> >   #define TUNNEL_ERSPAN_OPT   __cpu_to_be16(0x4000)
> > +#define TUNNEL_GTPU_OPT              __cpu_to_be16(0x8000)
> >
> >   #define TUNNEL_OPTIONS_PRESENT \
> >               (TUNNEL_GENEVE_OPT | TUNNEL_VXLAN_OPT | TUNNEL_ERSPAN_OPT)
> > diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
> > index d208b2af697f..28d649bda686 100644
> > --- a/tools/include/uapi/linux/if_link.h
> > +++ b/tools/include/uapi/linux/if_link.h
> > @@ -617,6 +617,7 @@ enum {
> >       IFLA_GTP_FD1,
> >       IFLA_GTP_PDP_HASHSIZE,
> >       IFLA_GTP_ROLE,
> > +     IFLA_GTP_COLLECT_METADATA,
> >       __IFLA_GTP_MAX,
> >   };
> >   #define IFLA_GTP_MAX (__IFLA_GTP_MAX - 1)
> >
>
> /Jonas
