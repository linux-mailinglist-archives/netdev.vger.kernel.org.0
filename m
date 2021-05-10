Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42703792EE
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 17:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbhEJPmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 11:42:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbhEJPmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 May 2021 11:42:32 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D1EC061574
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:41:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id r9so25229081ejj.3
        for <netdev@vger.kernel.org>; Mon, 10 May 2021 08:41:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=p9+0Nb64PBW1BL3+C5z03NpHOeyjqi882dANiQjwxyA=;
        b=ZXzIzmRj7gOotc6e3smjZ17T0DatbzlAe6v/fKo30Vk7VvxXg6edjI8peGXb2aJR4v
         RGefb0hosyF28W1WBEJ9OmR5XlvSOonGa5PflWMi4baXS1zFRjJ/kHY6H/mE0FXfClJi
         Ayyy9GQy253WSax3uAs+xekXin+NncjyiNNm35gCO4uUli0dKEGS4P7zM7mXwv34LjUh
         +MJQfhTjxAi6n+Hn2LXbcF4FOlWwlIecL3g5UYDlDLvozvaatbbYcu1xiPC5kwOgUYH4
         Kya+1s4elzPuUgLKLsn8G165f+pq7ULrUyCtSFNrxM1J4vGTBWAP3swTpR+x93jqzEza
         evAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=p9+0Nb64PBW1BL3+C5z03NpHOeyjqi882dANiQjwxyA=;
        b=FbNuv8DzWdsxLtNvFbrmQr2CYL1mog1btHoL9PFMLBxJ52prXFCnGp7l8zjWWH/z2c
         0BcwIVX5jNfg3JducE0iiKpS3pSBS/24b68XJPlfZ+8cWKwcPEmt2hLbgkMd3XmqhmXi
         OoelPuszhO63vxMbdBvyDfZHxMJKUYxPcWCGjtTR7L75WrgAfJOds0NLk1FhdEza+B25
         ZwiLZ9t0mFUiOxbwKGVodhzs5+kpO5AxdNxsd1lZk9nYqIyyGSnfeGCkzBGCAb+wfe13
         2wUAKlyv+vCPsLHlvgQcc3aU0Rf6RYz5tVhfTvQOVaI7TBHQavxs7vUdj14SVSrsPnxW
         VkAA==
X-Gm-Message-State: AOAM533TzmSEqiF7PG5o8GYhaPZnnK1gC5ZWX6TyLDytGeCvuZkJ7o1f
        J7kdUqfZeQdhNsYvf9DROowYIfKku4waTG4C8wM=
X-Google-Smtp-Source: ABdhPJwvBJ88WwiPMFCJZhMo6dl5lUVJY1eKwuyx0/TBJ07egd4em6bA8DmlDS4r1DvqHqUn37SQnyuFgbFaWPzJ2ks=
X-Received: by 2002:a17:906:2b0c:: with SMTP id a12mr26180017ejg.473.1620661285028;
 Mon, 10 May 2021 08:41:25 -0700 (PDT)
MIME-Version: 1.0
References: <1620433768-31048-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1620433768-31048-1-git-send-email-michael.chan@broadcom.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 10 May 2021 08:41:14 -0700
Message-ID: <CAKgT0Uep_dwLaG=dsSs9q0UuM3y_4_y7E60nqJMJ7B4WYtO8Rw@mail.gmail.com>
Subject: Re: [PATCH net v2] bnxt_en: Fix and improve .ndo_features_check().
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Gospodarek <gospo@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 7, 2021 at 5:29 PM Michael Chan <michael.chan@broadcom.com> wrote:
>
> Jakub Kicinski pointed out that we need to handle ipv6 extension headers
> and to explicitly check for supported tunnel types in
> .ndo_features_check().
>
> For ipv6 extension headers, the hardware supports up to 2 ext. headers
> and each must be <= 64 bytes.  For tunneled packets, the supported
> packets are UDP with supported VXLAN and Geneve ports, GRE, and IPIP.
>
> v2: Add missing step to check inner ipv6 header for UDP and GRE tunnels.
>     Check TCP/UDP next header after skipping ipv6 ext headers for
>     non-tunneled packets and for inner ipv6.
>     (Both feedback from Alexander Duyck)
>
> Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
> Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
> Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c | 125 +++++++++++++++++++---
>  1 file changed, 108 insertions(+), 17 deletions(-)
>
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index 39ac9e2f5118..8e4670e37140 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -10785,37 +10785,128 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
>         return rc;
>  }
>
> +static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
> +                             u8 *nextproto)
> +{
> +       struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
> +       int hdr_count = 0;
> +       u8 nexthdr;
> +       int start;
> +
> +       /* Check that there are at most 2 IPv6 extension headers, no
> +        * fragment header, and each is <= 64 bytes.
> +        */
> +       start = nw_off + sizeof(*ip6h);
> +       nexthdr = ip6h->nexthdr;
> +       while (ipv6_ext_hdr(nexthdr)) {
> +               struct ipv6_opt_hdr _hdr, *hp;
> +               int hdrlen;
> +
> +               if (hdr_count >= 3 || nexthdr == NEXTHDR_NONE ||
> +                   nexthdr == NEXTHDR_FRAGMENT)
> +                       return false;
> +               hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
> +               if (!hp)
> +                       return false;
> +               if (nexthdr == NEXTHDR_AUTH)
> +                       hdrlen = ipv6_authlen(hp);
> +               else
> +                       hdrlen = ipv6_optlen(hp);
> +
> +               if (hdrlen > 64)
> +                       return false;
> +               nexthdr = hp->nexthdr;
> +               start += hdrlen;
> +               hdr_count++;
> +       }
> +       /* Only support TCP/UDP unless the caller checks the nextproto. */
> +       if (nextproto) {
> +               *nextproto = nexthdr;
> +               return true;
> +       }
> +       if (nexthdr == IPPROTO_TCP || nexthdr == IPPROTO_UDP)
> +               return true;
> +       return false;
> +}
> +
> +/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> +static bool bnxt_udp_tunl_check(struct bnxt *bp, struct sk_buff *skb)
> +{
> +       struct udphdr *uh = udp_hdr(skb);
> +       __be16 udp_port = uh->dest;
> +
> +       if (udp_port != bp->vxlan_port && udp_port != bp->nge_port)
> +               return false;
> +       if (skb->inner_protocol_type == ENCAP_TYPE_ETHER) {
> +               struct ethhdr *eh = inner_eth_hdr(skb);
> +
> +               switch (eh->h_proto) {
> +               case htons(ETH_P_IP):
> +                       return true;
> +               case htons(ETH_P_IPV6):
> +                       return bnxt_exthdr_check(bp, skb,
> +                                                skb_inner_network_offset(skb),
> +                                                NULL);
> +               }
> +       }
> +       return false;
> +}
> +
> +static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
> +{
> +       switch (l4_proto) {
> +       case IPPROTO_UDP:
> +               return bnxt_udp_tunl_check(bp, skb);
> +       case IPPROTO_IPIP:
> +               return true;
> +       case IPPROTO_GRE: {
> +               switch (skb->inner_protocol) {
> +               default:
> +                       return false;
> +               case htons(ETH_P_IP):
> +                       return true;
> +               case htons(ETH_P_IPV6):
> +                       fallthrough;
> +               }
> +       }
> +       case IPPROTO_IPV6:
> +               /* Check ext headers of inner ipv6 */
> +               return bnxt_exthdr_check(bp, skb, skb_inner_network_offset(skb),
> +                                        NULL);
> +       }
> +       return false;
> +}
> +
>  static netdev_features_t bnxt_features_check(struct sk_buff *skb,
>                                              struct net_device *dev,
>                                              netdev_features_t features)
>  {
> -       struct bnxt *bp;
> -       __be16 udp_port;
> +       struct bnxt *bp = netdev_priv(dev);
>         u8 l4_proto = 0;
>
>         features = vlan_features_check(skb, features);
> -       if (!skb->encapsulation)
> -               return features;
> -
>         switch (vlan_get_protocol(skb)) {
>         case htons(ETH_P_IP):
> +               if (!skb->encapsulation)
> +                       return features;
>                 l4_proto = ip_hdr(skb)->protocol;
> -               break;
> +               if (!bnxt_tunl_check(bp, skb, l4_proto))
> +                       goto disable_offload;

What is the point of this label, couldn't you just use a break since
this is in a switch statement? Or you could flip the logic and have it
return features if you successfully determined the offload is doable
and then default to adding a break at the end of the case section.

> +               return features;
>         case htons(ETH_P_IPV6):
> -               l4_proto = ipv6_hdr(skb)->nexthdr;
> +               if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
> +                                      &l4_proto))
> +                       goto disable_offload;

Same here. You could probably just use a break statement.

Also you might save yourself a step here by passing an actual pointer
instead of the address of l4_proto here. Then what you could do is in
the skb->encapsulation case you initialize the pointer to the address
of l4_proto, and in the non encap case you set the pointer to NULL.
Doing that you can avoid having to repeat the same TCP/UDP check below
and could instead just return features if !pointer ||
bnxt_tunl_check().

> +               if (skb->encapsulation) {
> +                       if (bnxt_tunl_check(bp, skb, l4_proto))
> +                               return features;
> +               } else if (l4_proto == IPPROTO_TCP || l4_proto == IPPROTO_UDP) {
> +                       return features;
> +               }
>                 break;
> -       default:
> -               return features;
>         }
>
> -       if (l4_proto != IPPROTO_UDP)
> -               return features;
> -
> -       bp = netdev_priv(dev);
> -       /* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
> -       udp_port = udp_hdr(skb)->dest;
> -       if (udp_port == bp->vxlan_port || udp_port == bp->nge_port)
> -               return features;
> +disable_offload:
>         return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
>  }
>
> --
> 2.18.1
>
