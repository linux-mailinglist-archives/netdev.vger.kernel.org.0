Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24423312E4
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbhCHQIB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhCHQHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:07:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D39CC06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 08:07:52 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id m9so15519359edd.5
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 08:07:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9fWdVn7nLt3E3L4QID9g8tlOiKwr5cryDbVteVsjhto=;
        b=hby+9gRwE9g9hGAihLCdCtBZ+y4eU1Zfe61MagbI6fqe4FrPk/dLp7WrdubLG93OD4
         xs6lPQ1gHQheNmcoCu6iCEgcfHG9g7FxaBOxs8BB5gxPKEvR1YTBtFilN6gcbe1qPGol
         D1kArFIP6UYLue+0sZkge50+rXKAFp+ylwJ0rVzlyX/UmyDc0tzOPaL6pGW42eG2hSZ5
         dXvgTuHFS/YR8OBxpnDOBvgzZXiuIp//VjqV9BVEjoAlxoX8AodWem+MR0qvm79GGDEu
         DrJvlQdq/Oo/XWQVkj5+PHPoz+34btM4p7tCUKmuKJ7GvdUaDMYsSCQeLQr2jw/AtUJi
         b1Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9fWdVn7nLt3E3L4QID9g8tlOiKwr5cryDbVteVsjhto=;
        b=FJvWh+oL7+vP9+LRV0hJ839jEsfubpgnd1xM1OBFFhijGHe8E/afeDT0g/mx5ij3k1
         nxqoud9HpXYiU1+87hbZA9UMyc+cjWet2fXJyU9Gh2Osb7epfWH5QUGQTAIMFVnP6FcM
         0Pxg5KEKI9PJJnlhR55kNvLKRpKwpudhRlpjRG1TKzOqAiuoPAxbrNpWk/snQT2d/5JY
         7qhc/3jE7EAj8QI6L6YwNBmFGC1vjyxYeQkI62EYX5ZlzsI8H91fx4u5IBqffSluWttz
         0DDqjvC8MH1JGUkSf2XN/7WtvgqICDPIgCyncqlgrssPJUeY6gHZo/vVdJc8JfMfGazY
         JTrg==
X-Gm-Message-State: AOAM532DB4fCV8FD8+b2UupwDKOKSI3PMGBKFaGXZ9Yqjo9yFvz09UyI
        28kNsh0dSSzeULHHGbXqLBCX8OKQ6vo=
X-Google-Smtp-Source: ABdhPJzrDHJBInxj9BnuZ8hCeDRHsfCd0bbAYa9TOlgRAGtgac4UpEMOwAwz1+YiDi+QvR6GjDv82w==
X-Received: by 2002:a05:6402:1157:: with SMTP id g23mr2900560edw.303.1615219670754;
        Mon, 08 Mar 2021 08:07:50 -0800 (PST)
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com. [209.85.128.54])
        by smtp.gmail.com with ESMTPSA id r5sm6942953ejx.96.2021.03.08.08.07.50
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Mar 2021 08:07:50 -0800 (PST)
Received: by mail-wm1-f54.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso4120807wma.4
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 08:07:50 -0800 (PST)
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr21312488wmm.120.1615219669904;
 Mon, 08 Mar 2021 08:07:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1615199056.git.bnemeth@redhat.com> <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
In-Reply-To: <85e04e1e6367f19c8f538d145b32f5bb93788d8a.1615199056.git.bnemeth@redhat.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 8 Mar 2021 11:07:10 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
Message-ID: <CA+FuTSdWSCzkB7sDn+_0Oxy8JqmqL=nsQXP_3bnb4Xdd=0A=KQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] net: avoid infinite loop in mpls_gso_segment when
 mpls_hlen == 0
To:     Balazs Nemeth <bnemeth@redhat.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        David Miller <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 8, 2021 at 5:32 AM Balazs Nemeth <bnemeth@redhat.com> wrote:
>
> A packet with skb_inner_network_header(skb) == skb_network_header(skb)
> and ETH_P_MPLS_UC will prevent mpls_gso_segment from pulling any headers
> from the packet. Subsequently, the call to skb_mac_gso_segment will
> again call mpls_gso_segment with the same packet leading to an infinite
> loop.
>
> Signed-off-by: Balazs Nemeth <bnemeth@redhat.com>
> ---
>  net/mpls/mpls_gso.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/mpls/mpls_gso.c b/net/mpls/mpls_gso.c
> index b1690149b6fa..cc1b6457fc93 100644
> --- a/net/mpls/mpls_gso.c
> +++ b/net/mpls/mpls_gso.c
> @@ -27,7 +27,7 @@ static struct sk_buff *mpls_gso_segment(struct sk_buff *skb,
>
>         skb_reset_network_header(skb);
>         mpls_hlen = skb_inner_network_header(skb) - skb_network_header(skb);
> -       if (unlikely(!pskb_may_pull(skb, mpls_hlen)))
> +       if (unlikely(!mpls_hlen || !pskb_may_pull(skb, mpls_hlen)))
>                 goto out;

Good cathc. Besides length zero, this can be more strict: a label is
4B, so mpls_hlen needs to be >= 4B.

Perhaps even aligned to 4B, too, but not if there may be other encap on top.

Unfortunately there is no struct or type definition that we can use a
sizeof instead of open coding the raw constant.
