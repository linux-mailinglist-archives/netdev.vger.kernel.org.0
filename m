Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABAF4AFEB2
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 21:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232198AbiBIUqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 15:46:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232182AbiBIUqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 15:46:12 -0500
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8D9C001914;
        Wed,  9 Feb 2022 12:46:14 -0800 (PST)
Received: by mail-lj1-x235.google.com with SMTP id c15so5090702ljf.11;
        Wed, 09 Feb 2022 12:46:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=42ix9pxIs7QFalbgN1HNWDOjCK4K43yFy41VvBVv7bU=;
        b=Onp+VDgBymT6Qjqt7xi0TVQXh6aW285HL0JM2QRXaxxjhJncLeQCvVh5xa9XHDqQKW
         SYg3J9gcjuP/bgxMVa4GNa/I22cDjDufZsCqM0xG3k8Oqe+YUOe5H/jGzJn9R61DGP/T
         qaNkj86vgax5sLm4A7ZoczVUk4c1MiWShxe5kCsID2j8q8vbC9nJWDGffipL1HDWi5Ru
         3IBhzF/DFoLfM6VzY6kCyZcvqM8s+ClpvjREukG9BsXWyd+W+FMTt0deSdlXu3LSDQrI
         J7wsc9My83FqT6f0OH9Pan3Kkp5EP9RKUzwYhA2s8Tz7qE6vhPxhkp1IhPcMKm+1cury
         pkmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=42ix9pxIs7QFalbgN1HNWDOjCK4K43yFy41VvBVv7bU=;
        b=dY4X7HyRNBFm2In/6RSP8lHx9b5jASWJRpz1WwHTlj4RObUpgiKUCuBIfzZl1Qr25N
         TWGjn+G64TKdEJZjctZIkjKQTjzfhMgrBZZLxqbO+AQikF3MvhSbBS508XlTSkXA5Suv
         nB7oNQ727Kt5eeXlksVMGKyNqbHXS8GTwyhuQlUTDqDgtQDQIpHR5vSjKsOONjT++lez
         atZ0+jpx/3JuapLJ5IlkaB6Vr4jCYJAip2/AP3BsuSaIdqK/vUL4zbBrr1L2uGxvnoHq
         uTRORvVz8tpiNT+ZKmZZ14/bcJW7KBRBz4FaEz/yXg7BQHcWh+M8T0N23OB7cKFud4Hr
         XmKg==
X-Gm-Message-State: AOAM5308Xp8PWGtWsgHajeSrWpqOyI/G7rL9Lp1GpwocMwt/fxfTCvN8
        6ECdwq4Wp0oH7CXBwRMcKI3V+UMDCAtjSeWKLgwdAR7k
X-Google-Smtp-Source: ABdhPJzdBAwiMyPzlsScq3ntnIkas0zf9+ojPCvEbHlK2WeeLvCZt/RyzEKVwr5zPxum/aUwboUtisFGe+FOBhmtPDQ=
X-Received: by 2002:a2e:b042:: with SMTP id d2mr2662421ljl.486.1644439572392;
 Wed, 09 Feb 2022 12:46:12 -0800 (PST)
MIME-Version: 1.0
References: <20211124193327.2736-1-cpp.code.lv@gmail.com> <CAOrHB_AUCGG0uF4d30Eb4dguPqwvDL8A2c=2EGXqdcqkqLZK-g@mail.gmail.com>
 <CAASuNyWViYk6rt7bpqVApMFJB+k9NKSwasm1H_70uMMRUHxoHw@mail.gmail.com>
 <CAOrHB_D1HKirnub8AQs=tjX60Mc+EP=aWf+xpr9YdOCOAPsi2Q@mail.gmail.com>
 <CAASuNyUKj+dsf++7mhdkjm2mabQggYW4x42_BV=y+VPPSBFqfA@mail.gmail.com> <CAOrHB_CyBoTYO8Qn-qtcfrbqfVc9TjaU6ib_2ZSQx-R9ns-bUQ@mail.gmail.com>
In-Reply-To: <CAOrHB_CyBoTYO8Qn-qtcfrbqfVc9TjaU6ib_2ZSQx-R9ns-bUQ@mail.gmail.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Wed, 9 Feb 2022 12:46:01 -0800
Message-ID: <CAASuNyWRh4++uLh4zPuJAuwX4NhYa4HvO1M7iMYdg3Dm0Qbc7Q@mail.gmail.com>
Subject: Re: [PATCH net-next v8] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Pravin Shelar <pravin.ovn@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        ovs dev <dev@openvswitch.org>,
        LKML <linux-kernel@vger.kernel.org>
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

On Thu, Dec 9, 2021 at 11:36 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
>
> ()
>
> On Mon, Dec 6, 2021 at 3:00 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
> >
> > On Thu, Dec 2, 2021 at 9:28 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> > >
> > > On Thu, Dec 2, 2021 at 12:20 PM Cpp Code <cpp.code.lv@gmail.com> wrote:
> > > >
> > > > On Wed, Dec 1, 2021 at 11:34 PM Pravin Shelar <pravin.ovn@gmail.com> wrote:
> > > > >
> > > > > On Wed, Nov 24, 2021 at 11:33 AM Toms Atteka <cpp.code.lv@gmail.com> wrote:
> > > > > >
> > > > > > This change adds a new OpenFlow field OFPXMT_OFB_IPV6_EXTHDR and
> > > > > > packets can be filtered using ipv6_ext flag.
> > > > > >
> > > > > > Signed-off-by: Toms Atteka <cpp.code.lv@gmail.com>
> > > > > > ---
> > > > > >  include/uapi/linux/openvswitch.h |   6 ++
> > > > > >  net/openvswitch/flow.c           | 140 +++++++++++++++++++++++++++++++
> > > > > >  net/openvswitch/flow.h           |  14 ++++
> > > > > >  net/openvswitch/flow_netlink.c   |  26 +++++-
> > > > > >  4 files changed, 184 insertions(+), 2 deletions(-)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > > > > > index a87b44cd5590..43790f07e4a2 100644
> > > > > > --- a/include/uapi/linux/openvswitch.h
> > > > > > +++ b/include/uapi/linux/openvswitch.h
> > > > > > @@ -342,6 +342,7 @@ enum ovs_key_attr {
> > > > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV4,   /* struct ovs_key_ct_tuple_ipv4 */
> > > > > >         OVS_KEY_ATTR_CT_ORIG_TUPLE_IPV6,   /* struct ovs_key_ct_tuple_ipv6 */
> > > > > >         OVS_KEY_ATTR_NSH,       /* Nested set of ovs_nsh_key_* */
> > > > > > +       OVS_KEY_ATTR_IPV6_EXTHDRS,  /* struct ovs_key_ipv6_exthdr */
> > > > > >
> > > > > >  #ifdef __KERNEL__
> > > > > >         OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info */
> > > > > > @@ -421,6 +422,11 @@ struct ovs_key_ipv6 {
> > > > > >         __u8   ipv6_frag;       /* One of OVS_FRAG_TYPE_*. */
> > > > > >  };
> > > > > >
> > > > > > +/* separate structure to support backward compatibility with older user space */
> > > > > > +struct ovs_key_ipv6_exthdrs {
> > > > > > +       __u16  hdrs;
> > > > > > +};
> > > > > > +
> > > > > >  struct ovs_key_tcp {
> > > > > >         __be16 tcp_src;
> > > > > >         __be16 tcp_dst;
> > > > > > diff --git a/net/openvswitch/flow.c b/net/openvswitch/flow.c
> > > > > > index 9d375e74b607..28acb40437ca 100644
> > > > > > --- a/net/openvswitch/flow.c
> > > > > > +++ b/net/openvswitch/flow.c
> > > > > > @@ -239,6 +239,144 @@ static bool icmphdr_ok(struct sk_buff *skb)
> > > > > >                                   sizeof(struct icmphdr));
> > > > > >  }
> > > > > >
> > > > > > +/**
> > > > > > + * get_ipv6_ext_hdrs() - Parses packet and sets IPv6 extension header flags.
> > > > > > + *
> > > > > > + * @skb: buffer where extension header data starts in packet
> > > > > > + * @nh: ipv6 header
> > > > > > + * @ext_hdrs: flags are stored here
> > > > > > + *
> > > > > > + * OFPIEH12_UNREP is set if more than one of a given IPv6 extension header
> > > > > > + * is unexpectedly encountered. (Two destination options headers may be
> > > > > > + * expected and would not cause this bit to be set.)
> > > > > > + *
> > > > > > + * OFPIEH12_UNSEQ is set if IPv6 extension headers were not in the order
> > > > > > + * preferred (but not required) by RFC 2460:
> > > > > > + *
> > > > > > + * When more than one extension header is used in the same packet, it is
> > > > > > + * recommended that those headers appear in the following order:
> > > > > > + *      IPv6 header
> > > > > > + *      Hop-by-Hop Options header
> > > > > > + *      Destination Options header
> > > > > > + *      Routing header
> > > > > > + *      Fragment header
> > > > > > + *      Authentication header
> > > > > > + *      Encapsulating Security Payload header
> > > > > > + *      Destination Options header
> > > > > > + *      upper-layer header
> > > > > > + */
> > > > > > +static void get_ipv6_ext_hdrs(struct sk_buff *skb, struct ipv6hdr *nh,
> > > > > > +                             u16 *ext_hdrs)
> > > > > > +{
> > > > > > +       u8 next_type = nh->nexthdr;
> > > > > > +       unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
> > > > > > +       int dest_options_header_count = 0;
> > > > > > +
> > > > > > +       *ext_hdrs = 0;
> > > > > > +
> > > > > > +       while (ipv6_ext_hdr(next_type)) {
> > > > > > +               struct ipv6_opt_hdr _hdr, *hp;
> > > > > > +
> > > > > > +               switch (next_type) {
> > > > > > +               case IPPROTO_NONE:
> > > > > > +                       *ext_hdrs |= OFPIEH12_NONEXT;
> > > > > > +                       /* stop parsing */
> > > > > > +                       return;
> > > > > > +
> > > > > > +               case IPPROTO_ESP:
> > > > > > +                       if (*ext_hdrs & OFPIEH12_ESP)
> > > > > > +                               *ext_hdrs |= OFPIEH12_UNREP;
> > > > > > +                       if ((*ext_hdrs & ~(OFPIEH12_HOP | OFPIEH12_DEST |
> > > > > > +                                          OFPIEH12_ROUTER | IPPROTO_FRAGMENT |
> > > > > > +                                          OFPIEH12_AUTH | OFPIEH12_UNREP)) ||
> > > > > > +                           dest_options_header_count >= 2) {
> > > > > > +                               *ext_hdrs |= OFPIEH12_UNSEQ;
> > > > > > +                       }
> > > > > > +                       *ext_hdrs |= OFPIEH12_ESP;
> > > > > > +                       break;
> > > > > you need to check_header() before looking into each extension header.
> > > >
> > > > Could you elaborate why I need to add check_header(),
> > > > skb_header_pointer() is doing sanitization.
> > >
> > > I mean check_header() would allow you to read the header without
> > > copying the bits, it is used in ovs flow extraction so its usual
> > > check.
> >
> > But check_header() will call *__pskb_pull_tail which in turn will copy
> > bits if data will be fragmented.
> >
> OVS flow extract uses this function to extract flow upto L4, so
> skb_header_pointer() is not saving any copy operation.
>
> > /* Moves tail of skb head forward, copying data from fragmented part,
> >  * when it is necessary.
> >  * 1. It may fail due to malloc failure.
> >  * 2. It may change skb pointers.
> >  *
> >  * It is pretty complicated. Luckily, it is called only in exceptional cases.
> >  */
> > void *__pskb_pull_tail(struct sk_buff *skb, int delta)
> >
> > as well I noticed that for example commit
> > 4a06fa67c4da20148803525151845276cdb995c1 is moving from
> > pskb_may_pull() to skb_header_pointer()
> ok, I see advantage of using skb_header_pointer() in this case, but
> replacing all check_header() with skb_header_pointer() would add lot
> of copy operation in flow extract. Anyways for this use case
> skb_header_pointer() is fine.
>
> Acked-by: Pravin B Shelar <pshelar@ovn.org>

Hi,

Could this be applied please.

Thanks,
Tom
