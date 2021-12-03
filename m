Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561A84671A4
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 06:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244238AbhLCFcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 00:32:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhLCFcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 00:32:12 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C99CC06174A;
        Thu,  2 Dec 2021 21:28:49 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id z9so2182287qtj.9;
        Thu, 02 Dec 2021 21:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2dyGJ5hKlzyAO1e2h1dMbkBVXRhy9CI5Zw2Og7PkgXU=;
        b=DJl6fWpg+lj1RDqnT/hd5QKmk2HpL58zBCmBwQTwvEKacaTGZQjU6GwsBI2MpB+382
         x9E/FBjqP6zwvpElfLjdfKMA6dQSeMQtqwqcjsJPmJJGo3I5tkD9SypjqwS7qkoTq/hy
         9DVtx2i2OqzCrCKapWXmZ3C+XHrxPvGkDV6lic9EzRP9HrkPYBS2RHBre1xV0RHBv7Da
         HwXtQtnuq65RT81SKaOEc2BJV2NvgiF4sVyoAbx+TTCTGpPww3yV4DuFHyZGP10QEB1Y
         6WAeYSle5ZP2PAO0g7CSpenKepG9RB3tc1ekcd+2oNQJ+h8HBq84D1rXCrzep0q9ACeL
         DaYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2dyGJ5hKlzyAO1e2h1dMbkBVXRhy9CI5Zw2Og7PkgXU=;
        b=woWIg2X5va8BEo3G+50UVKKrU6876iiXum0LqOONKJQL5tzAbzqf50TnmLoVS5STMD
         42Zk6yv/iWY8aKkcJFFOzd29iaiPfIe8WkZ0hXnRa6tk9dXRk6E5AHBF6v7GbdrBj5Ra
         IygrtofmTmgRstDILddqcyR1smcyozNq7SJy/xr+7iAOBsTz3gLuA2aKqa8rgM7eoXa3
         Mp0cCvPssWSL5alXHao1nXU1HNZoaDyewtWUvBfoOcVOG4aQTcIRjOokp6zviKnzCtaN
         7R7UAZ9Kb+86u/d/bkNf5qjgOMn/Aq/zqs1gpiqBd847kAg0GPqM41EKq0U+axNVlSgv
         M7qQ==
X-Gm-Message-State: AOAM531xHT81b/7H+Q1+U+py932IEdA6bRq5mTckoq7P/N28Ia8KG6eh
        uLsjYVXQX38FGV4YvOObgbxVdrUnMZ6E0YLLKEpq3VTVxwQ=
X-Google-Smtp-Source: ABdhPJy4P+RZs2wfiadtTSj/rRjb7/AoxiD5nTXnMSIGjbn7iqh8WlcJRZal2KRKY7cI2WquOtuTgY3boilpSjYz6MM=
X-Received: by 2002:ac8:7d87:: with SMTP id c7mr18409460qtd.501.1638509328237;
 Thu, 02 Dec 2021 21:28:48 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com> <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
 <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
In-Reply-To: <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
From:   Pravin Shelar <pravin.ovn@gmail.com>
Date:   Thu, 2 Dec 2021 21:28:37 -0800
Message-ID: <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Cpp Code <cpp.code.lv@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 2, 2021 at 12:20 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
>
> On Wed, Dec 1, 2021 at 11:34 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> >
> > On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
> > >
> > > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > > packets can be filtered using ipv6_ext flag.
> > >
> > > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > > ---
> > >  include/uapi/linux/openvswitch.h |   6 ++
> > >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> > >  net/openvswitch/flow.h           |  14 ++++
> > >  net/openvswitch/flow_netlink.c   |  26 +++++-
> > >  4 files changed, 184 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > index a87b44cd5590..43790f07e4a2 100644
> > > --- a/include/uapi/linux/openvswitch.h
> > > +++ b/include/uapi/linux/openvswitch.h
> > > @@ -342,6 +342,7 @@ enum ovs_key_attr {
> > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> > >         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> > > +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> > >
> > >  #ifdef __KERNEL__
> > >         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > > @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
> > >         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> > >  };
> > >
> > > +/* separate structure to support backward compatibility with older user space */
> > > +struct ovs_key_ipv6_exthdrs {
> > > +       __u16  hdrs;
> > > +};
> > > +
> > >  struct ovs_key_tcp {
> > >         __be16 tcp_src;
> > >         __be16 tcp_dst;
> > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > index 9d375e74b607..28acb40437ca 100644
> > > --- a/net/openvswitch/flow.c
> > > +++ b/net/openvswitch/flow.c
> > > @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
> > >                                   sizeof(struct icmphdr));
> > >  }
> > >
> > > +/**
> > > + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> > > + *
> > > + * @skb: buffer where extension header data starts in packet
> > > + * @nh: ipv6 header
> > > + * @ext_hdrs: flags are stored here
> > > + *
> > > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > > + * is unexpectedly encountered. (Two destination options headers may be
> > > + * expected and would not cause this bit to be set.)
> > > + *
> > > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > > + * preferred (but not required) by RFC 2460:
> > > + *
> > > + * When more than one extension header is used in the same packet, it is
> > > + * recommended that those headers appear in the following order:
> > > + *      IPv6 header
> > > + *      Hop-by-Hop Options header
> > > + *      Destination Options header
> > > + *      Routing header
> > > + *      Fragment header
> > > + *      Authentication header
> > > + *      Encapsulating Security Payload header
> > > + *      Destination Options header
> > > + *      upper-layer header
> > > + */
> > > +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> > > +                             u16 *ext_hdrs)
> > > +{
> > > +       u8 next_type = nh->nexthdr;
> > > +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> > > +       int dest_options_header_count = 0;
> > > +
> > > +       *ext_hdrs = 0;
> > > +
> > > +       while (ipv6_ext_hdr(next_type)) {
> > > +               struct ipv6_opt_hdr _hdr, *hp;
> > > +
> > > +               switch (next_type) {
> > > +               case IPPROTO_NONE:
> > > +                       *ext_hdrs |= OFPIEH12_NONEXT;
> > > +                       /* stop parsing */
> > > +                       return;
> > > +
> > > +               case IPPROTO_ESP:
> > > +                       if (*ext_hdrs & OFPIEH12_ESP)
> > > +                               *ext_hdrs |= OFPIEH12_UNREP;
> > > +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> > > +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> > > +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> > > +                           dest_options_header_count >= 2) {
> > > +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> > > +                       }
> > > +                       *ext_hdrs |= OFPIEH12_ESP;
> > > +                       break;
> > you need to check_header() before looking into each extension header.
>
> Could you elaborate why I need to add check_header(),
> skb_header_pointer() is doing sanitization.

I mean check_header() would allow you to read the header without
copying the bits, it is used in ovs flow extraction so its usual
check.
