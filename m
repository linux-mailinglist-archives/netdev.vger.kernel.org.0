Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4FA23D06F
	for <lists+netdev@lfdr.de>; Wed,  5 Aug 2020 21:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgHETsa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 15:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728357AbgHEQ5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 12:57:10 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58308C0617A2
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 09:54:16 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q75so38481518iod.1
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 09:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9yc7/eK2x4oGdVpej8T/jT7xrCyASY98xloaab28wkE=;
        b=DPBbz/rZtRwCV00q33wWWFIyDeneJzPALqJ8G31Rp9ADuofCLu1xUlPbKvb2hORSXK
         QR1gUBiKFAJFsJuPxFWyx4OFVjJO18NfHTu7ia1rkmk+i8AQ16xXS9FMg6S99Sfk5e1Y
         D/Vq6H2M0mPTntbf8V1JePPTwMgRBjm9egB3GviKRD/m2NmsE1A+utAFefg8b+6B/SSN
         XjDyEWawohyalFKFMwDs1zBLhNATXvcFYhiZIhdb9O3xX8Eai+8J7BXNCYxja7aWK+74
         xA0PE4EeePgNjN3eIY0ckCMBmvGqg8XEWGjaCh8F1M46cexAPL8tuZ3HOgvbnoo5y2mZ
         yq0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9yc7/eK2x4oGdVpej8T/jT7xrCyASY98xloaab28wkE=;
        b=hiUHVsEuPYeTqUNkgMS07uqYTYgldseZvK9qLL25bTMVJY1VdRlDt4h6IClGEYUKRv
         4tMK8Oa8qGRJHVWy2nxrWaGw7ZxN1I0TE9XCKHkYEviryCBV1ckvBAPU9FUVWPJ8gYus
         vDlTGBTQ63ZUtLxgdtBx/C90FXQC2UCNHZ4RFnhFbwH5ssJlM8L+DF/lI0rjmLhmqzuz
         91+INqvC1dEInRIPscgmC4Sl/y3KVLqosXZ8fofuA6eUwAX18lBvPuQMQtai0OjciKHl
         pPu3VSXAM9MeZb+vJFvRIe62Cu8xX2HcPdGxNjfHjOojZMaYYPIWpCGnPIe6NP3zXlw1
         NKvw==
X-Gm-Message-State: AOAM533XSX2qAoQ8EfOilRlk/iPaOblLoaUqTDXS6jFakzDNwd44Lkwk
        Wm/Yjao83kkhz2cZuvIE0qvltlwca/L3GwxYxo9cIQ==
X-Google-Smtp-Source: ABdhPJxxtcC9PzufXnnKQ32mwEQlOF8l0NQYa6nAZJLdalTAbQvrbs6oSKVFBdvxyl6C+zuuwzUe6B39auMZMkQxX+8=
X-Received: by 2002:a5d:9ac5:: with SMTP id x5mr4452162ion.111.1596646454211;
 Wed, 05 Aug 2020 09:54:14 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1596520062.git.sbrivio@redhat.com> <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
In-Reply-To: <83e5876f589b0071638630dd93fbe0fa6b1b257c.1596520062.git.sbrivio@redhat.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 5 Aug 2020 22:24:03 +0530
Message-ID: <CA+G9fYsJdoQieVr6=e09nYAvpAjnay5XSmJ3WkZHgMdzJRUYEw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/6] tunnels: PMTU discovery support for
 directly bridged IP packets
To:     Stefano Brivio <sbrivio@redhat.com>,
        linux-riscv@lists.infradead.org,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@gmail.com>,
        Aaron Conole <aconole@redhat.com>,
        Numan Siddique <nusiddiq@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Lourdes Pedrajas <lu@pplo.net>,
        Netdev <netdev@vger.kernel.org>, paul.walmsley@sifive.com,
        palmer@dabbelt.com, aou@eecs.berkeley.edu,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 4 Aug 2020 at 11:24, Stefano Brivio <sbrivio@redhat.com> wrote:
>
> It's currently possible to bridge Ethernet tunnels carrying IP
> packets directly to external interfaces without assigning them
> addresses and routes on the bridged network itself: this is the case
> for UDP tunnels bridged with a standard bridge or by Open vSwitch.
>
> PMTU discovery is currently broken with those configurations, because
> the encapsulation effectively decreases the MTU of the link, and
> while we are able to account for this using PMTU discovery on the
> lower layer, we don't have a way to relay ICMP or ICMPv6 messages
> needed by the sender, because we don't have valid routes to it.
>
> On the other hand, as a tunnel endpoint, we can't fragment packets
> as a general approach: this is for instance clearly forbidden for
> VXLAN by RFC 7348, section 4.3:
>
>    VTEPs MUST NOT fragment VXLAN packets.  Intermediate routers may
>    fragment encapsulated VXLAN packets due to the larger frame size.
>    The destination VTEP MAY silently discard such VXLAN fragments.
>
> The same paragraph recommends that the MTU over the physical network
> accomodates for encapsulations, but this isn't a practical option for
> complex topologies, especially for typical Open vSwitch use cases.
>
> Further, it states that:
>
>    Other techniques like Path MTU discovery (see [RFC1191] and
>    [RFC1981]) MAY be used to address this requirement as well.
>
> Now, PMTU discovery already works for routed interfaces, we get
> route exceptions created by the encapsulation device as they receive
> ICMP Fragmentation Needed and ICMPv6 Packet Too Big messages, and
> we already rebuild those messages with the appropriate MTU and route
> them back to the sender.
>
> Add the missing bits for bridged cases:
>
> - checks in skb_tunnel_check_pmtu() to understand if it's appropriate
>   to trigger a reply according to RFC 1122 section 3.2.2 for ICMP and
>   RFC 4443 section 2.4 for ICMPv6. This function is already called by
>   UDP tunnels
>
> - a new function generating those ICMP or ICMPv6 replies. We can't
>   reuse icmp_send() and icmp6_send() as we don't see the sender as a
>   valid destination. This doesn't need to be generic, as we don't
>   cover any other type of ICMP errors given that we only provide an
>   encapsulation function to the sender
>
> While at it, make the MTU check in skb_tunnel_check_pmtu() accurate:
> we might receive GSO buffers here, and the passed headroom already
> includes the inner MAC length, so we don't have to account for it
> a second time (that would imply three MAC headers on the wire, but
> there are just two).
>
> This issue became visible while bridging IPv6 packets with 4500 bytes
> of payload over GENEVE using IPv4 with a PMTU of 4000. Given the 50
> bytes of encapsulation headroom, we would advertise MTU as 3950, and
> we would reject fragmented IPv6 datagrams of 3958 bytes size on the
> wire. We're exclusively dealing with network MTU here, though, so we
> could get Ethernet frames up to 3964 octets in that case.
>
> v2:
> - moved skb_tunnel_check_pmtu() to ip_tunnel_core.c (David Ahern)
> - split IPv4/IPv6 functions (David Ahern)
>
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  drivers/net/bareudp.c     |   5 +-
>  drivers/net/geneve.c      |   5 +-
>  drivers/net/vxlan.c       |   4 +-
>  include/net/dst.h         |  10 --
>  include/net/ip_tunnels.h  |   2 +
>  net/ipv4/ip_tunnel_core.c | 244 ++++++++++++++++++++++++++++++++++++++
>  6 files changed, 254 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
> index 3b6664c7e73c..841910f1db65 100644
> --- a/drivers/net/bareudp.c
> +++ b/drivers/net/bareudp.c
> @@ -308,7 +308,7 @@ static int bareudp_xmit_skb(struct sk_buff *skb, stru=
ct net_device *dev,
>                 return PTR_ERR(rt);
>
>         skb_tunnel_check_pmtu(skb, &rt->dst,
> -                             BAREUDP_IPV4_HLEN + info->options_len);
> +                             BAREUDP_IPV4_HLEN + info->options_len, fals=
e);
>
>         sport =3D udp_flow_src_port(bareudp->net, skb,
>                                   bareudp->sport_min, USHRT_MAX,
> @@ -369,7 +369,8 @@ static int bareudp6_xmit_skb(struct sk_buff *skb, str=
uct net_device *dev,
>         if (IS_ERR(dst))
>                 return PTR_ERR(dst);
>
> -       skb_tunnel_check_pmtu(skb, dst, BAREUDP_IPV6_HLEN + info->options=
_len);
> +       skb_tunnel_check_pmtu(skb, dst, BAREUDP_IPV6_HLEN + info->options=
_len,
> +                             false);
>
>         sport =3D udp_flow_src_port(bareudp->net, skb,
>                                   bareudp->sport_min, USHRT_MAX,
> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
> index 017c13acc911..de86b6d82132 100644
> --- a/drivers/net/geneve.c
> +++ b/drivers/net/geneve.c
> @@ -894,7 +894,7 @@ static int geneve_xmit_skb(struct sk_buff *skb, struc=
t net_device *dev,
>                 return PTR_ERR(rt);
>
>         skb_tunnel_check_pmtu(skb, &rt->dst,
> -                             GENEVE_IPV4_HLEN + info->options_len);
> +                             GENEVE_IPV4_HLEN + info->options_len, false=
);
>
>         sport =3D udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true)=
;
>         if (geneve->cfg.collect_md) {
> @@ -955,7 +955,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, stru=
ct net_device *dev,
>         if (IS_ERR(dst))
>                 return PTR_ERR(dst);
>
> -       skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_=
len);
> +       skb_tunnel_check_pmtu(skb, dst, GENEVE_IPV6_HLEN + info->options_=
len,
> +                             false);
>
>         sport =3D udp_flow_src_port(geneve->net, skb, 1, USHRT_MAX, true)=
;
>         if (geneve->cfg.collect_md) {
> diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
> index 77658425db8a..1432544da507 100644
> --- a/drivers/net/vxlan.c
> +++ b/drivers/net/vxlan.c
> @@ -2720,7 +2720,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, str=
uct net_device *dev,
>                 }
>
>                 ndst =3D &rt->dst;
> -               skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM);
> +               skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM, false);
>
>                 tos =3D ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
>                 ttl =3D ttl ? : ip4_dst_hoplimit(&rt->dst);
> @@ -2760,7 +2760,7 @@ static void vxlan_xmit_one(struct sk_buff *skb, str=
uct net_device *dev,
>                                 goto out_unlock;
>                 }
>
> -               skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM);
> +               skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM, false);
>
>                 tos =3D ip_tunnel_ecn_encap(RT_TOS(tos), old_iph, skb);
>                 ttl =3D ttl ? : ip6_dst_hoplimit(ndst);
> diff --git a/include/net/dst.h b/include/net/dst.h
> index 852d8fb36ab7..6ae2e625050d 100644
> --- a/include/net/dst.h
> +++ b/include/net/dst.h
> @@ -535,14 +535,4 @@ static inline void skb_dst_update_pmtu_no_confirm(st=
ruct sk_buff *skb, u32 mtu)
>                 dst->ops->update_pmtu(dst, NULL, skb, mtu, false);
>  }
>
> -static inline void skb_tunnel_check_pmtu(struct sk_buff *skb,
> -                                        struct dst_entry *encap_dst,
> -                                        int headroom)
> -{
> -       u32 encap_mtu =3D dst_mtu(encap_dst);
> -
> -       if (skb->len > encap_mtu - headroom)
> -               skb_dst_update_pmtu_no_confirm(skb, encap_mtu - headroom)=
;
> -}
> -
>  #endif /* _NET_DST_H */
> diff --git a/include/net/ip_tunnels.h b/include/net/ip_tunnels.h
> index 36025dea7612..02ccd32542d0 100644
> --- a/include/net/ip_tunnels.h
> +++ b/include/net/ip_tunnels.h
> @@ -420,6 +420,8 @@ void iptunnel_xmit(struct sock *sk, struct rtable *rt=
, struct sk_buff *skb,
>                    u8 tos, u8 ttl, __be16 df, bool xnet);
>  struct metadata_dst *iptunnel_metadata_reply(struct metadata_dst *md,
>                                              gfp_t flags);
> +int skb_tunnel_check_pmtu(struct sk_buff *skb, struct dst_entry *encap_d=
st,
> +                         int headroom, bool reply);
>
>  int iptunnel_handle_offloads(struct sk_buff *skb, int gso_type_mask);
>
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index f8b419e2475c..9ddee2a0c66d 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -184,6 +184,250 @@ int iptunnel_handle_offloads(struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
>
> +/**
> + * iptunnel_pmtud_build_icmp() - Build ICMP error message for PMTUD
> + * @skb:       Original packet with L2 header
> + * @mtu:       MTU value for ICMP error
> + *
> + * Return: length on success, negative error code if message couldn't be=
 built.
> + */
> +static int iptunnel_pmtud_build_icmp(struct sk_buff *skb, int mtu)
> +{
> +       const struct iphdr *iph =3D ip_hdr(skb);
> +       struct icmphdr *icmph;
> +       struct iphdr *niph;
> +       struct ethhdr eh;
> +       int len, err;
> +
> +       if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct iphdr)))
> +               return -EINVAL;
> +
> +       skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
> +       pskb_pull(skb, ETH_HLEN);
> +       skb_reset_network_header(skb);
> +
> +       err =3D pskb_trim(skb, 576 - sizeof(*niph) - sizeof(*icmph));
> +       if (err)
> +               return err;
> +
> +       len =3D skb->len + sizeof(*icmph);
> +       err =3D skb_cow(skb, sizeof(*niph) + sizeof(*icmph) + ETH_HLEN);
> +       if (err)
> +               return err;
> +
> +       icmph =3D skb_push(skb, sizeof(*icmph));
> +       *icmph =3D (struct icmphdr) {
> +               .type                   =3D ICMP_DEST_UNREACH,
> +               .code                   =3D ICMP_FRAG_NEEDED,
> +               .checksum               =3D 0,
> +               .un.frag.__unused       =3D 0,
> +               .un.frag.mtu            =3D ntohs(mtu),
> +       };
> +       icmph->checksum =3D ip_compute_csum(icmph, len);
> +       skb_reset_transport_header(skb);
> +
> +       niph =3D skb_push(skb, sizeof(*niph));
> +       *niph =3D (struct iphdr) {
> +               .ihl                    =3D sizeof(*niph) / 4u,
> +               .version                =3D 4,
> +               .tos                    =3D 0,
> +               .tot_len                =3D htons(len + sizeof(*niph)),
> +               .id                     =3D 0,
> +               .frag_off               =3D htons(IP_DF),
> +               .ttl                    =3D iph->ttl,
> +               .protocol               =3D IPPROTO_ICMP,
> +               .saddr                  =3D iph->daddr,
> +               .daddr                  =3D iph->saddr,
> +       };
> +       ip_send_check(niph);
> +       skb_reset_network_header(skb);
> +
> +       skb->ip_summed =3D CHECKSUM_NONE;
> +
> +       eth_header(skb, skb->dev, htons(eh.h_proto), eh.h_source, eh.h_de=
st, 0);
> +       skb_reset_mac_header(skb);
> +
> +       return skb->len;
> +}
> +
> +/**
> + * iptunnel_pmtud_check_icmp() - Trigger ICMP reply if needed and allowe=
d
> + * @skb:       Buffer being sent by encapsulation, L2 headers expected
> + * @mtu:       Network MTU for path
> + *
> + * Return: 0 for no ICMP reply, length if built, negative value on error=
.
> + */
> +static int iptunnel_pmtud_check_icmp(struct sk_buff *skb, int mtu)
> +{
> +       const struct icmphdr *icmph =3D icmp_hdr(skb);
> +       const struct iphdr *iph =3D ip_hdr(skb);
> +
> +       if (mtu <=3D 576 || iph->frag_off !=3D htons(IP_DF))
> +               return 0;
> +
> +       if (ipv4_is_lbcast(iph->daddr)  || ipv4_is_multicast(iph->daddr) =
||
> +           ipv4_is_zeronet(iph->saddr) || ipv4_is_loopback(iph->saddr)  =
||
> +           ipv4_is_lbcast(iph->saddr)  || ipv4_is_multicast(iph->saddr))
> +               return 0;
> +
> +       if (iph->protocol =3D=3D IPPROTO_ICMP && icmp_is_err(icmph->type)=
)
> +               return 0;
> +
> +       return iptunnel_pmtud_build_icmp(skb, mtu);
> +}
> +
> +#if IS_ENABLED(CONFIG_IPV6)
> +/**
> + * iptunnel_pmtud_build_icmpv6() - Build ICMPv6 error message for PMTUD
> + * @skb:       Original packet with L2 header
> + * @mtu:       MTU value for ICMPv6 error
> + *
> + * Return: length on success, negative error code if message couldn't be=
 built.
> + */
> +static int iptunnel_pmtud_build_icmpv6(struct sk_buff *skb, int mtu)
> +{
> +       const struct ipv6hdr *ip6h =3D ipv6_hdr(skb);
> +       struct icmp6hdr *icmp6h;
> +       struct ipv6hdr *nip6h;
> +       struct ethhdr eh;
> +       int len, err;
> +       __wsum csum;
> +
> +       if (!pskb_may_pull(skb, ETH_HLEN + sizeof(struct ipv6hdr)))
> +               return -EINVAL;
> +
> +       skb_copy_bits(skb, skb_mac_offset(skb), &eh, ETH_HLEN);
> +       pskb_pull(skb, ETH_HLEN);
> +       skb_reset_network_header(skb);
> +
> +       err =3D pskb_trim(skb, IPV6_MIN_MTU - sizeof(*nip6h) - sizeof(*ic=
mp6h));
> +       if (err)
> +               return err;
> +
> +       len =3D skb->len + sizeof(*icmp6h);
> +       err =3D skb_cow(skb, sizeof(*nip6h) + sizeof(*icmp6h) + ETH_HLEN)=
;
> +       if (err)
> +               return err;
> +
> +       icmp6h =3D skb_push(skb, sizeof(*icmp6h));
> +       *icmp6h =3D (struct icmp6hdr) {
> +               .icmp6_type             =3D ICMPV6_PKT_TOOBIG,
> +               .icmp6_code             =3D 0,
> +               .icmp6_cksum            =3D 0,
> +               .icmp6_mtu              =3D htonl(mtu),
> +       };
> +       skb_reset_transport_header(skb);
> +
> +       nip6h =3D skb_push(skb, sizeof(*nip6h));
> +       *nip6h =3D (struct ipv6hdr) {
> +               .priority               =3D 0,
> +               .version                =3D 6,
> +               .flow_lbl               =3D { 0 },
> +               .payload_len            =3D htons(len),
> +               .nexthdr                =3D IPPROTO_ICMPV6,
> +               .hop_limit              =3D ip6h->hop_limit,
> +               .saddr                  =3D ip6h->daddr,
> +               .daddr                  =3D ip6h->saddr,
> +       };
> +       skb_reset_network_header(skb);
> +
> +       csum =3D csum_partial(icmp6h, len, 0);
> +       icmp6h->icmp6_cksum =3D csum_ipv6_magic(&nip6h->saddr, &nip6h->da=
ddr, len,
> +                                             IPPROTO_ICMPV6, csum);

Linux next build breaks for riscv architecture defconfig build.

    git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-ne=
xt.git
    target_arch: riscv
    toolchain: gcc-9
    git_short_log: d15fe4ec0435 (\Add linux-next specific files for 2020080=
5\)
    git_describe: next-20200805

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux ARCH=3Driscv
CROSS_COMPILE=3Driscv64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
riscv64-linux-gnu-gcc" O=3Dbuild defconfig
#
#
# make -sk KBUILD_BUILD_USER=3DTuxBuild -C/linux -j16 ARCH=3Driscv
CROSS_COMPILE=3Driscv64-linux-gnu- HOSTCC=3Dgcc CC=3D"sccache
riscv64-linux-gnu-gcc" O=3Dbuild
#
../net/ipv4/ip_tunnel_core.c: In function =E2=80=98iptunnel_pmtud_build_icm=
pv6=E2=80=99:
../net/ipv4/ip_tunnel_core.c:335:24: error: implicit declaration of
function =E2=80=98csum_ipv6_magic=E2=80=99; did you mean =E2=80=98csum_tcpu=
dp_magic=E2=80=99?
[-Werror=3Dimplicit-function-declaration]
  335 |  icmp6h->icmp6_cksum =3D csum_ipv6_magic(&nip6h->saddr,
&nip6h->daddr, len,
      |                        ^~~~~~~~~~~~~~~
      |                        csum_tcpudp_magic
cc1: some warnings being treated as errors
make[3]: *** [../scripts/Makefile.build:283: net/ipv4/ip_tunnel_core.o] Err=
or 1

Full build log link,
https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/671651045


--=20
Linaro LKFT
https://lkft.linaro.org
