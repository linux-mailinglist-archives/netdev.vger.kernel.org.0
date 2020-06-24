Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74936207D02
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 22:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391447AbgFXUcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 16:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391383AbgFXUcv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 16:32:51 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BACBC061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 13:32:49 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id g20so2257534edm.4
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 13:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K+aJSPdA07A442gv0HVm+WYPkv5tbPxX7N30n5ZpQPk=;
        b=N3/fv6EPthg7C5PQXllI1Z/w2ll/axip6Cpf4T0u355hhjBci4lxb123VZ3WotjrXj
         lrdGGXcnrMxdDn5XIA76RzUebiYkB1z+RKCUi47PtFZ2M+g8Hh8+aDL2smqmqJp+I58E
         tx0iEqqzhbc2hP+Zk+WPlNwGavTsSO/hNyQ/10D1YQHe6JHzA6m/tleBRY4GIKGp/v5Q
         MAGQm14XeDRWSjmazi/dksOGhVDyFVRUqsDRbvSo6ZJfkml+64sG2HUbyCg4ROTd9xWU
         MtEK3WchDcyEJz1h2/CqE9Qd3ADaVqNDS5Dqjs8mqV8V0653725qLh8wjwdQUxAI4a1K
         nwsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K+aJSPdA07A442gv0HVm+WYPkv5tbPxX7N30n5ZpQPk=;
        b=SPnjP8En2XE4PDmiwLaPbzkr5GdL9FzptYXbTy8BreWtXU816sJMz+hREtgwHBJ2FS
         D//6jrPIt2IZFeXpSv0I482IKhmMCibAX5+K8Dz2xa5tWzJO27Ux5MLYvio4uxBn2Tjy
         DuEYDaq77ao3dNA7aI+NL2RpwYUrM1thIvjZ31SA6HEn7gW1LhKODCjb56P6QX22s7oj
         +10rgUGeWeP/cfXzWMqAVVJ8oAYI9M6XTfrqGhUixHKsg/JD2Q/jZ4AITcU7+H5Z58hN
         VPKj/v/wm2s5yI/lll/qamw6YuH4Qe6iM7NW86/cklwuxRIqskx5nMjLPmLvKt3yycer
         iDjw==
X-Gm-Message-State: AOAM533Ip3F8wDVun35GiPO8cXSVLTIyrElhN3dscsOhpYJWS3gKBrkY
        K0N6OUzTaU5oXSaZcank3AcmfDQgEy/rKxisFOXMTXWKSnA=
X-Google-Smtp-Source: ABdhPJzo53fCMM/12583zLuAv6JP43a6/qt1z/9u7yISMt5NJdWLvPyiUNEGzn5+pIT9RwFSf8wsQDqggCRnWWc/dkg=
X-Received: by 2002:a50:ee18:: with SMTP id g24mr29316723eds.370.1593030767856;
 Wed, 24 Jun 2020 13:32:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-2-justin.iurman@uliege.be>
In-Reply-To: <20200624192310.16923-2-justin.iurman@uliege.be>
From:   Tom Herbert <tom@herbertland.com>
Date:   Wed, 24 Jun 2020 13:32:36 -0700
Message-ID: <CALx6S34K5+GabNAs9GtutpPNxR+fAdibDTFphT_LUOJ1mAzfOQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/5] ipv6: eh: Introduce removable TLVs
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 12:33 PM Justin Iurman <justin.iurman@uliege.be> wrote:
>
> Add the possibility to remove one or more consecutive TLVs without
> messing up the alignment of others. For now, only IOAM requires this
> behavior.
>
Hi Justin,

Can you explain the motivation for this? Per RFC8200, extension
headers in flight are not to be added, removed, or modified outside of
the standard rules for processing modifiable HBH and DO TLVs., that
would include adding and removing TLVs in EH. One obvious problem this
creates is that it breaks AH if the TLVs are removed in HBH before AH
is processed (AH is processed after HBH).

Tom
> By default, an 8-octet boundary is automatically assumed. This is the
> price to pay (at most a useless 4-octet padding) to make sure everything
> is still aligned after the removal.
>
> Proof: let's assume for instance the following alignments 2n, 4n and 8n
> respectively for options X, Y and Z, inside a Hop-by-Hop extension
> header.
>
> Example 1:
>
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       X       |       X       |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |                                                               |
> ~                Option to be removed (8 octets)                ~
> |                                                               |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Y       |       Y       |       Y       |       Y       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |    Padding    |    Padding    |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> Result 1: assuming a 4-octet boundary would work, as well as an 8-octet
> boundary (same result in both cases).
>
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       X       |       X       |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Y       |       Y       |       Y       |       Y       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |    Padding    |    Padding    |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> Example 2:
>
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       X       |       X       |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |                Option to be removed (4 octets)                |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Y       |       Y       |       Y       |       Y       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> Result 2: assuming a 4-octet boundary WOULD NOT WORK. Indeed, option Z
> would not be 8n-aligned and the Hop-by-Hop size would not be a multiple
> of 8 anymore.
>
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |  Next header  |  Hdr Ext Len  |       X       |       X       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       X       |       X       |    Padding    |    Padding    |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Y       |       Y       |       Y       |       Y       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> |       Z       |       Z       |       Z       |       Z       |
> +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> Therefore, the largest (8-octet) boundary is assumed by default and for
> all, which means that blocks are only moved in multiples of 8. This
> assertion guarantees good alignment.
>
> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
> ---
>  net/ipv6/exthdrs.c | 134 ++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 108 insertions(+), 26 deletions(-)
>
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index e9b366994475..f27ab3bf2e0c 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -52,17 +52,27 @@
>
>  #include <linux/uaccess.h>
>
> -/*
> - *     Parsing tlv encoded headers.
> +/* States for TLV parsing functions. */
> +
> +enum {
> +       TLV_ACCEPT,
> +       TLV_REJECT,
> +       TLV_REMOVE,
> +       __TLV_MAX
> +};
> +
> +/* Parsing TLV encoded headers.
>   *
> - *     Parsing function "func" returns true, if parsing succeed
> - *     and false, if it failed.
> - *     It MUST NOT touch skb->h.
> + * Parsing function "func" returns either:
> + *  - TLV_ACCEPT if parsing succeeds
> + *  - TLV_REJECT if parsing fails
> + *  - TLV_REMOVE if TLV must be removed
> + * It MUST NOT touch skb->h.
>   */
>
>  struct tlvtype_proc {
>         int     type;
> -       bool    (*func)(struct sk_buff *skb, int offset);
> +       int     (*func)(struct sk_buff *skb, int offset);
>  };
>
>  /*********************
> @@ -109,19 +119,67 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
>         return false;
>  }
>
> +/* Remove one or several consecutive TLVs and recompute offsets, lengths */
> +
> +static int remove_tlv(int start, int end, struct sk_buff *skb)
> +{
> +       int len = end - start;
> +       int padlen = len % 8;
> +       unsigned char *h;
> +       int rlen, off;
> +       u16 pl_len;
> +
> +       rlen = len - padlen;
> +       if (rlen) {
> +               skb_pull(skb, rlen);
> +               memmove(skb_network_header(skb) + rlen, skb_network_header(skb),
> +                       start);
> +               skb_postpull_rcsum(skb, skb_network_header(skb), rlen);
> +
> +               skb_reset_network_header(skb);
> +               skb_set_transport_header(skb, sizeof(struct ipv6hdr));
> +
> +               pl_len = be16_to_cpu(ipv6_hdr(skb)->payload_len) - rlen;
> +               ipv6_hdr(skb)->payload_len = cpu_to_be16(pl_len);
> +
> +               skb_transport_header(skb)[1] -= rlen >> 3;
> +               end -= rlen;
> +       }
> +
> +       if (padlen) {
> +               off = end - padlen;
> +               h = skb_network_header(skb);
> +
> +               if (padlen == 1) {
> +                       h[off] = IPV6_TLV_PAD1;
> +               } else {
> +                       padlen -= 2;
> +
> +                       h[off] = IPV6_TLV_PADN;
> +                       h[off + 1] = padlen;
> +                       memset(&h[off + 2], 0, padlen);
> +               }
> +       }
> +
> +       return end;
> +}
> +
>  /* Parse tlv encoded option header (hop-by-hop or destination) */
>
>  static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>                           struct sk_buff *skb,
> -                         int max_count)
> +                         int max_count,
> +                         bool removable)
>  {
>         int len = (skb_transport_header(skb)[1] + 1) << 3;
> -       const unsigned char *nh = skb_network_header(skb);
> +       unsigned char *nh = skb_network_header(skb);
>         int off = skb_network_header_len(skb);
>         const struct tlvtype_proc *curr;
>         bool disallow_unknowns = false;
> +       int off_remove = 0;
>         int tlv_count = 0;
>         int padlen = 0;
> +       int ret;
>
>         if (unlikely(max_count < 0)) {
>                 disallow_unknowns = true;
> @@ -173,12 +231,14 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>                         if (tlv_count > max_count)
>                                 goto bad;
>
> +                       ret = -1;
>                         for (curr = procs; curr->type >= 0; curr++) {
>                                 if (curr->type == nh[off]) {
>                                         /* type specific length/alignment
>                                            checks will be performed in the
>                                            func(). */
> -                                       if (curr->func(skb, off) == false)
> +                                       ret = curr->func(skb, off);
> +                                       if (ret == TLV_REJECT)
>                                                 return false;
>                                         break;
>                                 }
> @@ -187,6 +247,17 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>                             !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
>                                 return false;
>
> +                       if (removable) {
> +                               if (ret == TLV_REMOVE) {
> +                                       if (!off_remove)
> +                                               off_remove = off - padlen;
> +                               } else if (off_remove) {
> +                                       off = remove_tlv(off_remove, off, skb);
> +                                       nh = skb_network_header(skb);
> +                                       off_remove = 0;
> +                               }
> +                       }
> +
>                         padlen = 0;
>                         break;
>                 }
> @@ -194,8 +265,13 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>                 len -= optlen;
>         }
>
> -       if (len == 0)
> +       if (len == 0) {
> +               /* Don't forget last TLV if it must be removed */
> +               if (off_remove)
> +                       remove_tlv(off_remove, off, skb);
> +
>                 return true;
> +       }
>  bad:
>         kfree_skb(skb);
>         return false;
> @@ -206,7 +282,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
>   *****************************/
>
>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> -static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
> +static int ipv6_dest_hao(struct sk_buff *skb, int optoff)
>  {
>         struct ipv6_destopt_hao *hao;
>         struct inet6_skb_parm *opt = IP6CB(skb);
> @@ -257,11 +333,11 @@ static bool ipv6_dest_hao(struct sk_buff *skb, int optoff)
>         if (skb->tstamp == 0)
>                 __net_timestamp(skb);
>
> -       return true;
> +       return TLV_ACCEPT;
>
>   discard:
>         kfree_skb(skb);
> -       return false;
> +       return TLV_REJECT;
>  }
>  #endif
>
> @@ -306,7 +382,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
>  #endif
>
>         if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
> -                         init_net.ipv6.sysctl.max_dst_opts_cnt)) {
> +                         init_net.ipv6.sysctl.max_dst_opts_cnt,
> +                         false)) {
>                 skb->transport_header += extlen;
>                 opt = IP6CB(skb);
>  #if IS_ENABLED(CONFIG_IPV6_MIP6)
> @@ -918,24 +995,24 @@ static inline struct net *ipv6_skb_net(struct sk_buff *skb)
>
>  /* Router Alert as of RFC 2711 */
>
> -static bool ipv6_hop_ra(struct sk_buff *skb, int optoff)
> +static int ipv6_hop_ra(struct sk_buff *skb, int optoff)
>  {
>         const unsigned char *nh = skb_network_header(skb);
>
>         if (nh[optoff + 1] == 2) {
>                 IP6CB(skb)->flags |= IP6SKB_ROUTERALERT;
>                 memcpy(&IP6CB(skb)->ra, nh + optoff + 2, sizeof(IP6CB(skb)->ra));
> -               return true;
> +               return TLV_ACCEPT;
>         }
>         net_dbg_ratelimited("ipv6_hop_ra: wrong RA length %d\n",
>                             nh[optoff + 1]);
>         kfree_skb(skb);
> -       return false;
> +       return TLV_REJECT;
>  }
>
>  /* Jumbo payload */
>
> -static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
> +static int ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
>  {
>         const unsigned char *nh = skb_network_header(skb);
>         struct inet6_dev *idev = __in6_dev_get_safely(skb->dev);
> @@ -953,12 +1030,12 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
>         if (pkt_len <= IPV6_MAXPLEN) {
>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff+2);
> -               return false;
> +               return TLV_REJECT;
>         }
>         if (ipv6_hdr(skb)->payload_len) {
>                 __IP6_INC_STATS(net, idev, IPSTATS_MIB_INHDRERRORS);
>                 icmpv6_param_prob(skb, ICMPV6_HDR_FIELD, optoff);
> -               return false;
> +               return TLV_REJECT;
>         }
>
>         if (pkt_len > skb->len - sizeof(struct ipv6hdr)) {
> @@ -970,16 +1047,16 @@ static bool ipv6_hop_jumbo(struct sk_buff *skb, int optoff)
>                 goto drop;
>
>         IP6CB(skb)->flags |= IP6SKB_JUMBOGRAM;
> -       return true;
> +       return TLV_ACCEPT;
>
>  drop:
>         kfree_skb(skb);
> -       return false;
> +       return TLV_REJECT;
>  }
>
>  /* CALIPSO RFC 5570 */
>
> -static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
> +static int ipv6_hop_calipso(struct sk_buff *skb, int optoff)
>  {
>         const unsigned char *nh = skb_network_header(skb);
>
> @@ -992,11 +1069,11 @@ static bool ipv6_hop_calipso(struct sk_buff *skb, int optoff)
>         if (!calipso_validate(skb, nh + optoff))
>                 goto drop;
>
> -       return true;
> +       return TLV_ACCEPT;
>
>  drop:
>         kfree_skb(skb);
> -       return false;
> +       return TLV_REJECT;
>  }
>
>  static const struct tlvtype_proc tlvprochopopt_lst[] = {
> @@ -1041,7 +1118,12 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
>
>         opt->flags |= IP6SKB_HOPBYHOP;
>         if (ip6_parse_tlv(tlvprochopopt_lst, skb,
> -                         init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
> +                         init_net.ipv6.sysctl.max_hbh_opts_cnt,
> +                         true)) {
> +               /* we need to refresh the length in case
> +                * at least one TLV was removed
> +                */
> +               extlen = (skb_transport_header(skb)[1] + 1) << 3;
>                 skb->transport_header += extlen;
>                 opt = IP6CB(skb);
>                 opt->nhoff = sizeof(struct ipv6hdr);
> --
> 2.17.1
>
