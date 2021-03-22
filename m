Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3EE3445C5
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 14:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCVNcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 09:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhCVNbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 09:31:35 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A10C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:31:35 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u9so21279930ejj.7
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tp1vQe+JMUFdR2LOmTLRmk1GATcCncMFlTBZX2LNWEM=;
        b=aphPRE8gaPs5vZJNAAg2gk3gFXZ6UMHA+c6PSt96uGL+M3hEv+3wtinZ97i+heB8dy
         FAINb1BeaPWHGv6jX9XTBcykRKCxRWuk+/p8KpMTaGXo+Gt6ndeo6Rda4b6QBneQuKFB
         /xCt3iMbedZitV7uB8E8c4uKd7LPzFg0HMswFBEO4SykaQs3pCw5mo4tgUpEdqtlBGXK
         LBNWQwD+Mgm/PpenoqI4L6YRFHz2qkrYewWvq0J8+F/VGRqpkupjSXumHashg40R8/mv
         W83Y8vu5QZA1AESuEr7ExBx0Zq01TJ03yuZf/5yjvECAEC+09ZgauyXw2scwo9kwe025
         O0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tp1vQe+JMUFdR2LOmTLRmk1GATcCncMFlTBZX2LNWEM=;
        b=HNsC2iwDnyvxRffzHCdrDTwgmsLdA+6y/XF9BTcg1VKV+xUW6hZWcvLG29v8XqRqkL
         mZqzIr06VIScGB+QxUyjhNhCtpWHdiQRyvs6LPoppxe5bw5fIw7kZZrtneV1M5X/tUpl
         4+YnPV4noGaWCM5/eOlSAa71EvNeG5F5v2DZZShr1JgIdPR2x20X+8yFRjf9kwOHXf17
         /GbjYLb/7PSfMritTMHOCN7ScMSKlDqo1/TqQr6yxHYWZPJUnnwzb9pmChAx1VEGO6eG
         XZPRnZErIBP0mRmd0XRYqaLGh4z5KwwBul258DMaL1RJ4zb/6y6NBe70iXWaPbcQA6uY
         Bb9A==
X-Gm-Message-State: AOAM533lc4xKqDix3dxGKugQe6LSLwIpBlGBxFwAzKkO13lqCCzasTOn
        KkwAPNIfslxGChCMj+gdKb8VGXhdiU4=
X-Google-Smtp-Source: ABdhPJxHAEnkwQ966/sUh6anVBcZWgbzMVzy4fQHSKF3lIrKn4VD/CWZC+Tsjda7PKxp+VlwP+p8HA==
X-Received: by 2002:a17:906:6a06:: with SMTP id o6mr18829022ejr.306.1616419893262;
        Mon, 22 Mar 2021 06:31:33 -0700 (PDT)
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com. [209.85.221.41])
        by smtp.gmail.com with ESMTPSA id oy8sm9678805ejb.58.2021.03.22.06.31.32
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Mar 2021 06:31:32 -0700 (PDT)
Received: by mail-wr1-f41.google.com with SMTP id j7so16809365wrd.1
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 06:31:32 -0700 (PDT)
X-Received: by 2002:a1c:e482:: with SMTP id b124mr15586304wmh.70.1616419892092;
 Mon, 22 Mar 2021 06:31:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1616345643.git.pabeni@redhat.com> <72d8fc8a6d35a74d267cca6c9eddb3ff7852868b.1616345643.git.pabeni@redhat.com>
In-Reply-To: <72d8fc8a6d35a74d267cca6c9eddb3ff7852868b.1616345643.git.pabeni@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 22 Mar 2021 09:30:55 -0400
X-Gmail-Original-Message-ID: <CA+FuTSfpAzEEz0WZ0EqwKu3CzuvZiD1Vv5+kCos0mL=_Rudkrg@mail.gmail.com>
Message-ID: <CA+FuTSfpAzEEz0WZ0EqwKu3CzuvZiD1Vv5+kCos0mL=_Rudkrg@mail.gmail.com>
Subject: Re: [PATCH net-next 3/8] udp: properly complete L4 GRO over UDP
 tunnel packet
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
> After the previous patch the stack can do L4 UDP aggregation
> on top of an UDP tunnel.
>
> The current GRO complete code tries frag based aggregation first;
> in the above scenario will generate corrupted frames.
>
> We need to try first UDP tunnel based aggregation, if the GRO
> packet requires that. We can use time GRO 'encap_mark' field
> to track the need GRO complete action. If encap_mark is set,
> skip the frag_list aggregation.
>
> On tunnel encap GRO complete clear such field, so that an inner
> frag_list GRO complete could take action.
>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  net/ipv4/udp_offload.c | 8 +++++++-
>  net/ipv6/udp_offload.c | 3 ++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
> index 25134a3548e99..54e06b88af69a 100644
> --- a/net/ipv4/udp_offload.c
> +++ b/net/ipv4/udp_offload.c
> @@ -642,6 +642,11 @@ int udp_gro_complete(struct sk_buff *skb, int nhoff,
>                 skb_shinfo(skb)->gso_type = uh->check ? SKB_GSO_UDP_TUNNEL_CSUM
>                                         : SKB_GSO_UDP_TUNNEL;
>
> +               /* clear the encap mark, so that inner frag_list gro_complete
> +                * can take place
> +                */
> +               NAPI_GRO_CB(skb)->encap_mark = 0;
> +
>                 /* Set encapsulation before calling into inner gro_complete()
>                  * functions to make them set up the inner offsets.
>                  */
> @@ -665,7 +670,8 @@ INDIRECT_CALLABLE_SCOPE int udp4_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct iphdr *iph = ip_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> -       if (NAPI_GRO_CB(skb)->is_flist) {
> +       /* do fraglist only if there is no outer UDP encap (or we already processed it) */
> +       if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {

Sorry, I don't follow. I thought the point was to avoid fraglist if an
outer udp tunnel header is present. But the above code clears the mark
and allows entering the fraglist branch exactly when such a header is
encountered?

>                 uh->len = htons(skb->len - nhoff);
>
>                 skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
> index faa823c242923..b3d9ed96e5ea5 100644
> --- a/net/ipv6/udp_offload.c
> +++ b/net/ipv6/udp_offload.c
> @@ -163,7 +163,8 @@ INDIRECT_CALLABLE_SCOPE int udp6_gro_complete(struct sk_buff *skb, int nhoff)
>         const struct ipv6hdr *ipv6h = ipv6_hdr(skb);
>         struct udphdr *uh = (struct udphdr *)(skb->data + nhoff);
>
> -       if (NAPI_GRO_CB(skb)->is_flist) {
> +       /* do fraglist only if there is no outer UDP encap (or we already processed it) */
> +       if (NAPI_GRO_CB(skb)->is_flist && !NAPI_GRO_CB(skb)->encap_mark) {
>                 uh->len = htons(skb->len - nhoff);
>
>                 skb_shinfo(skb)->gso_type |= (SKB_GSO_FRAGLIST|SKB_GSO_UDP_L4);
> --
> 2.26.2
>
