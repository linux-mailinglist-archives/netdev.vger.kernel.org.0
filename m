Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8A6234457C
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhCVNVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbhCVNTA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:19:00 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785CC061763
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:18:58 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hq27so21208583ejc.9
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e4EyNBByV2JgZ0Q84EvcGFh8C2pPTeTHOJOEm80UX3Y=;
        b=J5Jm4Pb0iDLk+aW9EfuQzp63xstxTRUMoQu7O2Xy4hn0KN99vVWAxxMxKPaTTKGU/p
         k63/8ipXMlJ4zjqqSdUk4KXd76FKRCF+3nyKYh3XoMWLIEBIhmgdcL/cqgscj9vvbeoZ
         S+cOgetqpv7ddnNyWFQai/Be1ZKJtn9lLC70Dn3IZcxY1sRvjqd13bGMv5bBpYSd6xzu
         RJhGqVY2QIIqkfbHu1DhsZYm6rzJ0KaTFxZnNi82OCQ12d1/mvJa2y4aU3+8j0Om8+7w
         Hib7AvNGvU5qvYdAkw+xD7BdhwSU5UBwF1Ntbvn9EQm+tB40Q2PWqldEolQignm2zgvT
         SPQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e4EyNBByV2JgZ0Q84EvcGFh8C2pPTeTHOJOEm80UX3Y=;
        b=JYqzeRBT/BvwPV3m94ld/robTJHDnzJ54/UpCkD8vDDIx+85gNgGdfABPr2yIArsf6
         ahjHQ5nkq141e/EiQm1PLhGEV3t0rQ740k/QvzxSUTm6FyYeALfb4j6bOMPpJbWVn8mW
         TyZTpcm7KhedhJyMJf9YAjFGa1n6DIg+ggkMmcQJc0L6SDpwAgh+AQrLvt/3j014enWV
         aRpzrXhUn0KEE0fmaJm07Jv2rzBXNxsV1YlxW0WF65T1NBx4P//+cAy+CfZH9avZzNMV
         uRL4VXfRszxBbm54BY7PRlVKuGeKGTnWGmkOf1oVYvTX2sQfnmp9KhlG/3w50LUJDhKY
         hzfQ==
X-Gm-Message-State: AOAM5333fPMToJqvGDpB6CNL4V7563cuTlcIgwYQMcUH1XE1N52aPP1O
        PkR5lUq7ZUfzsAGSBjuxUtevnH1Db4E=
X-Google-Smtp-Source: ABdhPJzNOX2Vp4ksnm/pb8MQaHpf5dNfRe/6+JkPIZpksJeMKjhRk8mp5RoP85oREJmsbOA9spn4sg==
X-Received: by 2002:a17:906:6a94:: with SMTP id p20mr19849826ejr.68.1616419136306;
        Mon, 22 Mar 2021 06:18:56 -0700 (PDT)
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com. [209.85.221.46])
        by smtp.gmail.com with ESMTPSA id la15sm9647826ejb.46.2021.03.22.06.18.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:18:54 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id e9so16704905wrw.10
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:18:53 -0700 (PDT)
X-Received: by 2002:adf:ee92:: with SMTP id b18mr17770286wro.275.1616419133267;
 Mon, 22 Mar 2021 06:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
In-Reply-To: <4bff28fbaa8c53ca836eb2b9bdabcc3057118916.1616345643.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 22 Mar 2021 09:18:15 -0400
X-Gmail-Original-Message-ID: <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
Message-ID: <CA+FuTScSPJAh+6XnwnP32W+OmEzCVi8aKundnt2dJNzoKgUthg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/8] udp: fixup csum for GSO receive slow path
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 21, 2021 at 1:01 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> When looping back UDP GSO over UDP tunnel packets to an UDP socket,
> the individual packet csum is currently set to CSUM_NONE. That causes
> unexpected/wrong csum validation errors later in the UDP receive path.
>
> We could possibly addressing the issue with some additional check and
> csum mangling in the UDP tunnel code. Since the issue affects only
> this UDP receive slow path, let's set a suitable csum status there.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/udp.h | 18 ++++++++++++++++++
>  net/ipv4/udp.c    | 10 ++++++++++
>  net/ipv6/udp.c    |  5 +++++
>  3 files changed, 33 insertions(+)
>
> diff --git a/include/net/udp.h b/include/net/udp.h
> index d4d064c592328..007683eb3e113 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -515,6 +515,24 @@ static inline struct sk_buff *udp_rcv_segment(struct sock *sk,
>         return segs;
>  }
>
> +static inline void udp_post_segment_fix_csum(struct sk_buff *skb, int level)
> +{
> +       /* UDP-lite can't land here - no GRO */
> +       WARN_ON_ONCE(UDP_SKB_CB(skb)->partial_cov);
> +
> +       /* GRO already validated the csum up to 'level', and we just
> +        * consumed one header, update the skb accordingly
> +        */
> +       UDP_SKB_CB(skb)->cscov = skb->len;
> +       if (level) {
> +               skb->ip_summed = CHECKSUM_UNNECESSARY;
> +               skb->csum_level = 0;
> +       } else {
> +               skb->ip_summed = CHECKSUM_NONE;
> +               skb->csum_valid = 1;
> +       }

why does this function also update these fields for non-tunneled
packets? the commit only describes an issue with tunneled packets.

> +}
> +
>  #ifdef CONFIG_BPF_SYSCALL
>  struct sk_psock;
>  struct proto *udp_bpf_get_proto(struct sock *sk, struct sk_psock *psock);
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index 4a0478b17243a..ff54135c51ffa 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -2168,6 +2168,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
>  static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  {
>         struct sk_buff *next, *segs;
> +       int csum_level;
>         int ret;
>
>         if (likely(!udp_unexpected_gso(sk, skb)))
> @@ -2175,9 +2176,18 @@ static int udp_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>
>         BUILD_BUG_ON(sizeof(struct udp_skb_cb) > SKB_GSO_CB_OFFSET);
>         __skb_push(skb, -skb_mac_offset(skb));
> +       csum_level = !!(skb_shinfo(skb)->gso_type &
> +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
>         segs = udp_rcv_segment(sk, skb, true);
>         skb_list_walk_safe(segs, skb, next) {
>                 __skb_pull(skb, skb_transport_offset(skb));
> +
> +               /* UDP GSO packets looped back after adding UDP encap land here with CHECKSUM none,
> +                * instead of adding another check in the tunnel fastpath, we can force valid
> +                * csums here (packets are locally generated).
> +                * Additionally fixup the UDP CB
> +                */
> +               udp_post_segment_fix_csum(skb, csum_level);

How does this code differentiates locally generated packets with udp
tunnel headers from packets arriving from the wire, for which the
inner checksum may be incorrect?

>                 ret = udp_queue_rcv_one_skb(sk, skb);
>                 if (ret > 0)
>                         ip_protocol_deliver_rcu(dev_net(skb->dev), skb, ret);
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index d25e5a9252fdb..e7d4bf3a65c72 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -739,16 +739,21 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
>  static int udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
>  {
>         struct sk_buff *next, *segs;
> +       int csum_level;
>         int ret;
>
>         if (likely(!udp_unexpected_gso(sk, skb)))
>                 return udpv6_queue_rcv_one_skb(sk, skb);
>
>         __skb_push(skb, -skb_mac_offset(skb));
> +       csum_level = !!(skb_shinfo(skb)->gso_type &
> +                       (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM));
>         segs = udp_rcv_segment(sk, skb, false);
>         skb_list_walk_safe(segs, skb, next) {
>                 __skb_pull(skb, skb_transport_offset(skb));
>
> +               /* see comments in udp_queue_rcv_skb() */
> +               udp_post_segment_fix_csum(skb, csum_level);
>                 ret = udpv6_queue_rcv_one_skb(sk, skb);
>                 if (ret > 0)
>                         ip6_protocol_deliver_rcu(dev_net(skb->dev), skb, ret,
> --
> 2.26.2
>
