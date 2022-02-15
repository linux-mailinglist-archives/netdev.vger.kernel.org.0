Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9CF24B7381
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 17:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237035AbiBOPma (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 10:42:30 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241536AbiBOPlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 10:41:31 -0500
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073F9125585
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:35:24 -0800 (PST)
Received: by mail-yb1-xb31.google.com with SMTP id y6so57153887ybc.5
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 07:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O4eypergZV3m6Zzdl4fNq7xKdAiZHF46BD1z85Nc8jg=;
        b=QXVXjkwWhHxjoLXOmL4F9kN9NOD62pL1mWBMaTYzAESbupVXKNh5VqF9KgeTTv80NX
         8qM68EjdMMonVbDhSSRJ/xxdMD/ZnUyHwl/MAXaBsdLu5vBPwCP3zq2uW6MXcDeKBWMg
         LYAVlC8HVQcez0QQi1WnMtf35FtsRNXzyzL1S2Ty5WGzqw7aPbVl9hB3LSoWvi0p+LPb
         m3hfDp+37V/UnGccbWP2lFtEQk3mAItXOd8GiHBVZWv2LGwEa8oyhACoUx/U+U1wpY8Q
         s6evXE37CnbGzrC3sZPINlGMGyVjjpql9t1fBcWMI8aqIguTkyXmX3UXiePkMlSN6qMm
         6k1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O4eypergZV3m6Zzdl4fNq7xKdAiZHF46BD1z85Nc8jg=;
        b=kD0iAuzmSAUh/33MEB7BscMjl1c6hZOC9ORsALtFazwsl6VsDwOowz7hbiJUXIK5/C
         OhV0d36vewFZPxs6mYWx0rq1cylxGjDG6EZS8hyt+ro9J8SfZZcgNfzvagslGLoNDhgV
         VghVVk8i9nT4bsefyzthc+aBm5MCPMwlmm0hL1Nkge0gYFrz0TwNAkHUTHmZNq7kSlh6
         A+Kgb0x5PQmwVflCkbwzn7zIkR7k4ZS08dN4JkUFlmN0JTbadP4PhWyKdsTYR+lL4AbQ
         VxtfJAEtI8l8HH2ARUBIwL2LEOzppV2yvKy7NrYzfj4z6wB2hK3PYAwuyu+MyERMN6Dp
         +gOQ==
X-Gm-Message-State: AOAM530FJEDhxIfqhNCHkji83QMxkr4M3GcnuTF3YeRQ+Ps/WHS4SgUv
        Cjr/cmkBjtW0XISWXKGr+DT88jjI04/BNyN+Gjgqtw==
X-Google-Smtp-Source: ABdhPJxRvA4gT9FlG4INWIsLr7W6swMmTrbJAhDieVE8mfjvg+BfEtJeIG89DlINozKWNR5djGyY1BHeaHKW0G90v/A=
X-Received: by 2002:a25:8885:: with SMTP id d5mr4091214ybl.383.1644939322315;
 Tue, 15 Feb 2022 07:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20220213150234.31602-1-thomas.liu@ucloud.cn> <CA+FuTSdODATw3hSAMv9aZUmJNM8ZE-YP58pr17bO9rGJUgfegw@mail.gmail.com>
 <CFD9B65A-6762-4D9B-ADEB-B4C0B1902E02@ucloud.cn> <CA+FuTSfQOUEyEDnOU8VVZ=STw_ii-hTwyg-cvpcViPkVK4pLUA@mail.gmail.com>
 <42554FCB-9180-4B32-B5CF-6D3236237D99@ucloud.cn> <CAF=yD-+1RSj_o8n5LDOLVyn_dvVQvmDQo5pacSoDFPOR3M2g5g@mail.gmail.com>
In-Reply-To: <CAF=yD-+1RSj_o8n5LDOLVyn_dvVQvmDQo5pacSoDFPOR3M2g5g@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 15 Feb 2022 07:35:10 -0800
Message-ID: <CANn89i+T=Ny7pfUomSsa1ub77u8LfYtRZPzmp_0-=oWKt0abLg@mail.gmail.com>
Subject: Re: [PATCH] gso: do not skip outer ip header in case of ipip and net_failover
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Tao Liu <thomas.liu@ucloud.cn>, David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 7:01 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Feb 14, 2022 at 8:38 PM Tao Liu <thomas.liu@ucloud.cn> wrote:
> >
> > Sorry to resend it.
> >
> > 2022=E5=B9=B42=E6=9C=8814=E6=97=A5 12:27=EF=BC=8CWillem de Bruijn <will=
emdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sun, Feb 13, 2022 at 11:03 PM Tao Liu <thomas.liu@ucloud.cn> wrote:
> >
> >
> > Sorry for bothering, just repost it.
> >
> > 2022=E5=B9=B42=E6=9C=8814=E6=97=A5 09:28=EF=BC=8CWillem de Bruijn <will=
emdebruijn.kernel@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
> >
> > On Sun, Feb 13, 2022 at 10:10 AM Tao Liu <thomas.liu@ucloud.cn> wrote:
> >
> >
> > We encouter a tcp drop issue in our cloud environment. Packet GROed in =
host
> > forwards to a VM virtio_net nic with net_failover enabled. VM acts as a
> > IPVS LB with ipip encapsulation. The full path like:
> > host gro -> vm virtio_net rx -> net_failover rx -> ipvs fullnat
> > -> ipip encap -> net_failover tx -> virtio_net tx
> >
> > When net_failover transmits a ipip pkt (gso_type =3D 0x0103), there is =
no gso
> > performed because it supports TSO and GSO_IPXIP4. But network_header ha=
s
> > been pointing to inner ip header.
> >
> >
> > If the packet is configured correctly, and net_failover advertises
> > that it can handle TSO packets with IPIP encap, then still virtio_net
> > should not advertise it and software GSO be applied on its
> > dev_queue_xmit call.
> >
> > This is assuming that the packet not only has SKB_GSO_IPXIP4 correctly
> > set, but also tunneling fields like skb->encapsulated and
> > skb_inner_network_header.
> >
> > Thanks very much for your comment!
> >
> > Yes, the packet is correct. Another thing i have not pointed directly i=
s
> > that the pkt has SKB_GSO_DODGY. net_failover do not advertises GSO_ROBU=
ST
> > but virtio_net do.
> >
> >
> > If net_failover does not advertise NETIF_F_GSO_ROBUST, then
> > tcp_gso_segment will pass a packet with SKB_GSO_DODGY to the
> > software gso stack, not taking the branch
> >
> >        if (skb_gso_ok(skb, features | NETIF_F_GSO_ROBUST)) {
> >
> > As i tested, packet with SKB_GSO_DODGY hits this branch. packet's gso_t=
ype=3D0x0103, which
> > means SKB_GSO_TCPV4, SKB_GSO_DODGY and SKB_GSO_IPXIP4. net_failover mat=
ches
> > the condition.
> >
> > Consequently, tcp_gso_segment returns NULL, there is no software gso di=
d here. And
> > network_header points to inner iph.
> >
> > Software gso is did by virtio_net which not advertises NETIF_F_GSO_IPXI=
P4. It skips the outer
> > iph, and keeps it unchanged.
> >
> > ---
> > net/ipv4/af_inet.c | 10 +++++++++-
> > 1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> > index 9c465ba..f8b3f8a 100644
> > --- a/net/ipv4/af_inet.c
> > +++ b/net/ipv4/af_inet.c
> > @@ -1425,10 +1425,18 @@ struct sk_buff *inet_gso_segment(struct sk_buff=
 *skb,
> > static struct sk_buff *ipip_gso_segment(struct sk_buff *skb,
> >                                       netdev_features_t features)
> > {
> > +       struct sk_buff *segs;
> > +       int nhoff;
> > +
> >       if (!(skb_shinfo(skb)->gso_type & SKB_GSO_IPXIP4))
> >               return ERR_PTR(-EINVAL);
> >
> > -       return inet_gso_segment(skb, features);
> > +       nhoff =3D skb_network_header(skb) - skb_mac_header(skb);
> > +       segs =3D inet_gso_segment(skb, features);
> > +       if (!segs)
> > +               skb->network_header =3D skb_mac_header(skb) + nhoff - s=
kb->head;
> > +
> > +       return segs;
> > }
> >
> >
> > If this would be needed for IPIP, then the same would be needed for SIT=
, etc.
> >
> > Is the skb_network_header
> >
> > 1. correctly pointing to the outer header of the TSO packet before the
> > call to inet_gso_segment
> > 2. incorrectly pointing to the inner header of the (still) TSO packet
> > after the call to inet_gso_segment
> >
> > inet_gso_segment already does the same operation: save nhoff, pull
> > network header, call callbacks.gso_segment (which can be
> > ipip_gso_segment->inet_gso_segment), then place the network header
> > back at nhoff.
> >
> > values print in skb_mac_gso_segment() before callbacks.gso_segment:
> > ipip:               vlan_depth=3D0 mac_len=3D0 skb->network_header=3D20=
6
> > net_failover:  vlan_depth=3D14 mac_len=3D14 skb->network_header=3D186
> > virtio_net:      vlan_depth=3D34 mac_len=3D34 skb->network_header=3D206
> >
> > agree to add sit/ip4ip6/ip6ip6, and patch can be simplified as:
> >
> >
> > If IPIP GSO was so broken, I think we would have found it long before.
> >
> > As said, inet_gso_segment should already do the right thing for ipip:
> > it will be called twice.
> >
> >
> > SKB_GSO_DODGY flag and net_failover conduct this issue. local traffic j=
ust works fine.
>
> Got it. That is an uncommon combination. SKB_GSO_DODGY is set from
> external virtio_net, which does not support tunnels. But a path with
> an added tunnel might cause this combination.
>
> And inet_gso_segment resets the network header, both times, before
> calling callbacks.gso_segment()
>
>         skb_reset_network_header(skb);
>         nhoff =3D skb_network_header(skb) - skb_mac_header(skb);
>
>         [...]
>
>         if (likely(ops && ops->callbacks.gso_segment))
>                 segs =3D ops->callbacks.gso_segment(skb, features);
>
> And resets that after for each skb in segs.
>
>         skb =3D segs;
>         do {
>                 [...]
>                 skb->network_header =3D (u8 *)iph - skb->head;
>
> But does not do this if segs =3D=3D NULL.
>
> The packet has to be restored before it is passed to the device. I
> think we have to handle this case correctly in inet_gso_segment,
> instead of patching it up in all the various tunnel devices.
>
> The same holds for ipv6_gso_segment.

Back in the days, GRO was modified so that we passed a context (nhoff)
in called functions,
instead of changing skb offsets. The concept of outer/inner header
only works with 1 encap.

Perhaps it is time to do the same in GSO, to allow arbitrary levels of
encapsulation.
Then we no longer mess with these limited
'network_header/inner_network_header' fields
in the skb.

Stuffing state in the skb has been a mistake I think.
