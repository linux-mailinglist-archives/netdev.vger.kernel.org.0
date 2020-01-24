Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F476148FF3
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgAXVN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:13:56 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38498 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgAXVN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:13:56 -0500
Received: by mail-ed1-f67.google.com with SMTP id i16so4050063edr.5
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 13:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oGW7m7efQWNFvyT1nHFGAp1aEXzlL/nq7vz1zM2nhAg=;
        b=N4pAUZH1P2xyjBo44ngHmOdD6Sp3rhGpWzALcdosC6DRejVG8EH6VUjDDGuuiTdZkC
         LMTFVU7qSZcr3GVQTOH8bAxI+aR9ygZsG7J1SRUdIjw+PskzSadSNo2eXjr9BnVxDYIY
         qTUqPEd0iqOlcI2/fJwqLOk1pVDsb748BuC1rCtD/IYKViLiIaKdHt+mz8d62g11yf/1
         Zxea5PJ06pmW/ZkyZEomh8zR0e91pAyuP03HkMgfqmh7J61jeSVOOWhTp7Pkv6CLSC6f
         QbnSKXT5ldF8m2Dm/uP8+B2H3GSnZ/nLZX+LBnW1jMG3Qrqpx5o5b7/UEqmQnU/yAqDh
         Mz0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oGW7m7efQWNFvyT1nHFGAp1aEXzlL/nq7vz1zM2nhAg=;
        b=h1YJ8gaEAiYkhizPg4DXG2ZAx7Ou4HoF4O2WyThQOOAAj7sStJDBsl7kv3rQHhMRYX
         gK6roxClsgs8xls05ui0J1PfzIRuymuuxIBFMrT/nvo99cFzPG5lwwi5NnYbtFLk9fBc
         rS1g08rXK/8/dvMYrxb9GufsYm1/tredUqzKs305HMFKRHJ6BIqtMy17HYeO1wV7rQPf
         z9rwtIqn2n2hIfnIqF5muyYRLN7flKLcnftyRl87AxR80v84ITe+hX61TG8sCbeTGF2e
         GI2zhryQdncYBN3/97cVnaWcfEMy1X6UKxeIlO5BAk48k68lLCmBptvjsskSQdDrefv9
         dKIw==
X-Gm-Message-State: APjAAAUcApsqlni0GIQwpATLsW5+XqbpexihovMnXV+eJK0AbrpbTisW
        E0q5hXEvJEA+n3CJWfmIvUcvo4PvxEVNIZmuTaxa3g==
X-Google-Smtp-Source: APXvYqxC6bd8qu9jKIX2yj7gY4yljfnIeuanmyBvxRIgYZk41ODmervbrUBqUg8aKcNbme7NN1Du2vEq74qW+rVuIc0=
X-Received: by 2002:a17:906:3798:: with SMTP id n24mr4498637ejc.15.1579900433812;
 Fri, 24 Jan 2020 13:13:53 -0800 (PST)
MIME-Version: 1.0
References: <20200124082218.2572-1-steffen.klassert@secunet.com> <20200124082218.2572-5-steffen.klassert@secunet.com>
In-Reply-To: <20200124082218.2572-5-steffen.klassert@secunet.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 Jan 2020 16:13:17 -0500
Message-ID: <CAF=yD-JmKdDmKs5W8YeLOc2L81av8SrS1nR=chAAre2z=ALepw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 4/4] udp: Support UDP fraglist GRO/GSO.
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     David Miller <davem@davemloft.net>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 24, 2020 at 3:24 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> This patch extends UDP GRO to support fraglist GRO/GSO
> by using the previously introduced infrastructure.
> If the feature is enabled, all UDP packets are going to
> fraglist GRO (local input and forward).
>
> After validating the csum,  we mark ip_summed as
> CHECKSUM_UNNECESSARY for fraglist GRO packets to
> make sure that the csum is not touched.
>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> ---
>  include/net/udp.h      |   2 +-
>  net/ipv4/udp_offload.c | 104 ++++++++++++++++++++++++++++++++---------
>  net/ipv6/udp_offload.c |  22 ++++++++-
>  3 files changed, 102 insertions(+), 26 deletions(-)
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index bad74f780831..44e0e52b585c 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -167,7 +167,7 @@ typedef struct sock *(*udp_lookup_t)(struct sk_buff *skb, __be16 sport,
>                                      __be16 dport);
>
>  struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> -                               struct udphdr *uh, udp_lookup_t lookup);
> +                               struct udphdr *uh, struct sock *sk);
>  int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
>
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index b25e42100ceb..1a98583a79f4 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -184,6 +184,20 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
>  }
>  EXPORT_SYMBOL(skb_udp_tunnel_segment);
>
> +static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
> +                                             netdev_features_t features)
> +{
> +       unsigned int mss = skb_shinfo(skb)->gso_size;
> +
> +       skb = skb_segment_list(skb, features, skb_mac_header_len(skb));
> +       if (IS_ERR(skb))
> +               return skb;
> +
> +       udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
> +
> +       return skb;
> +}
> +
>  struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>                                   netdev_features_t features)
>  {
> @@ -196,6 +210,9 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
>         __sum16 check;
>         __be16 newlen;
>
> +       if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
> +               return __udp_gso_segment_list(gso_skb, features);
> +
>         mss = skb_shinfo(gso_skb)->gso_size;
>         if (gso_skb->len <= sizeof(*uh) + mss)
>                 return ERR_PTR(-EINVAL);
> @@ -354,6 +371,7 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>         struct udphdr *uh2;
>         struct sk_buff *p;
>         unsigned int ulen;
> +       int ret = 0;
>
>         /* requires non zero csum, for symmetry with GSO */
>         if (!uh->check) {
> @@ -369,7 +387,6 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>         }
>         /* pull encapsulating udp header */
>         skb_gro_pull(skb, sizeof(struct udphdr));
> -       skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
>
>         list_for_each_entry(p, head, list) {
>                 if (!NAPI_GRO_CB(p)->same_flow)
> @@ -383,14 +400,40 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>                         continue;
>                 }
>
> +               if (NAPI_GRO_CB(skb)->is_flist != NAPI_GRO_CB(p)->is_flist) {
> +                       NAPI_GRO_CB(skb)->flush = 1;
> +                       return p;
> +               }
> +
>                 /* Terminate the flow on len mismatch or if it grow "too much".
>                  * Under small packet flood GRO count could elsewhere grow a lot
>                  * leading to excessive truesize values.
>                  * On len mismatch merge the first packet shorter than gso_size,
>                  * otherwise complete the GRO packet.
>                  */
> -               if (ulen > ntohs(uh2->len) || skb_gro_receive(p, skb) ||
> -                   ulen != ntohs(uh2->len) ||
> +               if (ulen > ntohs(uh2->len)) {
> +                       pp = p;
> +               } else {
> +                       if (NAPI_GRO_CB(skb)->is_flist) {
> +                               if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
> +                                       NAPI_GRO_CB(skb)->flush = 1;
> +                                       return NULL;
> +                               }
> +                               if ((skb->ip_summed != p->ip_summed) ||
> +                                   (skb->csum_level != p->csum_level)) {
> +                                       NAPI_GRO_CB(skb)->flush = 1;
> +                                       return NULL;
> +                               }
> +                               ret = skb_gro_receive_list(p, skb);
> +                       } else {
> +                               skb_gro_postpull_rcsum(skb, uh,
> +                                                      sizeof(struct udphdr));
> +
> +                               ret = skb_gro_receive(p, skb);
> +                       }
> +               }
> +
> +               if (ret || ulen != ntohs(uh2->len) ||
>                     NAPI_GRO_CB(p)->count >= UDP_GRO_CNT_MAX)
>                         pp = p;
>
> @@ -401,36 +444,29 @@ static struct sk_buff *udp_gro_receive_segment(struct list_head *head,
>         return NULL;
>  }
>
> -INDIRECT_CALLABLE_DECLARE(struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
> -                                                  __be16 sport, __be16 dport));
>  struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
> -                               struct udphdr *uh, udp_lookup_t lookup)
> +                               struct udphdr *uh, struct sock *sk)
>  {
>         struct sk_buff *pp = NULL;
>         struct sk_buff *p;
>         struct udphdr *uh2;
>         unsigned int off = skb_gro_offset(skb);
>         int flush = 1;
> -       struct sock *sk;
>
> -       rcu_read_lock();
> -       sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
> -                               udp4_lib_lookup_skb, skb, uh->source, uh->dest);
> -       if (!sk)
> -               goto out_unlock;
> +       if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
> +               NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
>
> -       if (udp_sk(sk)->gro_enabled) {
> +       if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
>                 pp = call_gro_receive(udp_gro_receive_segment, head, skb);
> -               rcu_read_unlock();
>                 return pp;
>         }
>
> -       if (NAPI_GRO_CB(skb)->encap_mark ||
> +       if (!sk || NAPI_GRO_CB(skb)->encap_mark ||
>             (skb->ip_summed != CHECKSUM_PARTIAL &&
>              NAPI_GRO_CB(skb)->csum_cnt == 0 &&
>              !NAPI_GRO_CB(skb)->csum_valid) ||
>             !udp_sk(sk)->gro_receive)
> -               goto out_unlock;
> +               goto out;
>
>         /* mark that this skb passed once through the tunnel gro layer */
>         NAPI_GRO_CB(skb)->encap_mark = 1;
> @@ -457,8 +493,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
>         skb_gro_postpull_rcsum(skb, uh, sizeof(struct udphdr));
>         pp = call_gro_receive_sk(udp_sk(sk)->gro_receive, sk, head, skb);
>
> -out_unlock:
> -       rcu_read_unlock();
> +out:
>         skb_gro_flush_final(skb, pp, flush);
>         return pp;
>  }
> @@ -468,8 +503,10 @@ INDIRECT_CALLABLE_SCOPE
>  struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
>  {
>         struct udphdr *uh = udp_gro_udphdr(skb);
> +       struct sk_buff *pp;
> +       struct sock *sk;
>
> -       if (unlikely(!uh) || !static_branch_unlikely(&udp_encap_needed_key))
> +       if (unlikely(!uh))
>                 goto flush;
>
>         /* Don't bother verifying checksum if we're going to flush anyway. */
> @@ -484,7 +521,11 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
>                                              inet_gro_compute_pseudo);
>  skip:
>         NAPI_GRO_CB(skb)->is_ipv6 = 0;
> -       return udp_gro_receive(head, skb, uh, udp4_lib_lookup_skb);
> +       rcu_read_lock();
> +       sk = static_branch_unlikely(&udp_encap_needed_key) ? udp4_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
> +       pp = udp_gro_receive(head, skb, uh, sk);
> +       rcu_read_unlock();
> +       return pp;
>
>  flush:
>         NAPI_GRO_CB(skb)->flush = 1;
> @@ -517,9 +558,7 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
>         rcu_read_lock();
>         sk = INDIRECT_CALL_INET(lookup, udp6_lib_lookup_skb,
>                                 udp4_lib_lookup_skb, skb, uh->source, uh->dest);
> -       if (sk && udp_sk(sk)->gro_enabled) {
> -               err = udp_gro_complete_segment(skb);
> -       } else if (sk && udp_sk(sk)->gro_complete) {
> +       if (sk && udp_sk(sk)->gro_complete) {
>                 skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
>                                         : SKB_GSO_UDP_TUNNEL;
>
> @@ -529,6 +568,8 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
>                 skb->encapsulation = 1;
>                 err = udp_sk(sk)->gro_complete(sk, skb,
>                                 nhoff + sizeof(struct udphdr));
> +       } else {
> +               err = udp_gro_complete_segment(skb);
>         }
>         rcu_read_unlock();
>
> @@ -544,6 +585,23 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct iphdr *iph = ip_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               if (skb->ip_summed == CHECKSUM_UNNECESSARY) {
> +                       if (skb->csum_level < SKB_MAX_CSUM_LEVEL)
> +                               skb->csum_level++;
> +               } else {
> +                       skb->ip_summed = CHECKSUM_UNNECESSARY;
> +                       skb->csum_level = 0;
> +               }
> +
> +               return 0;
> +       }
> +
>         if (uh->check)
>                 uh->check = ~udp_v4_check(skb->len - nhoff, iph->saddr,
>                                           iph->daddr, 0);
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index f0d5fc27d0b5..4c55b0efe0cb 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -115,8 +115,10 @@ INDIRECT_CALLABLE_SCOPE
>  struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
>  {
>         struct udphdr *uh = udp_gro_udphdr(skb);
> +       struct sk_buff *pp;
> +       struct sock *sk;
>
> -       if (unlikely(!uh) || !static_branch_unlikely(&udpv6_encap_needed_key))
> +       if (unlikely(!uh))
>                 goto flush;
>
>         /* Don't bother verifying checksum if we're going to flush anyway. */
> @@ -132,7 +134,11 @@ struct sk_buff *udp6_gro_receive(struct list_head *head, struct sk_buff *skb)
>
>  skip:
>         NAPI_GRO_CB(skb)->is_ipv6 = 1;
> -       return udp_gro_receive(head, skb, uh, udp6_lib_lookup_skb);
> +       rcu_read_lock();
> +       sk = static_branch_unlikely(&udpv6_encap_needed_key) ? udp6_lib_lookup_skb(skb, uh->source, uh->dest) : NULL;
> +       pp = udp_gro_receive(head, skb, uh, sk);
> +       rcu_read_unlock();
> +       return pp;
>
>  flush:
>         NAPI_GRO_CB(skb)->flush = 1;
> @@ -144,6 +150,18 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> +       if (NAPI_GRO_CB(skb)->is_flist) {
> +               uh->len = htons(skb->len - nhoff);
> +
> +               skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> +               skb_shinfo(skb)->gso_segs = NAPI_GRO_CB(skb)->count;
> +
> +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> +               skb->csum_level = ~0;

This probably needs to be the same change as in udp4_gro_complete.

Otherwise patch set looks great to me based on a git range-diff to v1.
