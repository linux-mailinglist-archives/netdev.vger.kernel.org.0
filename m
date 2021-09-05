Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 999DE4010A2
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237285AbhIEPsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 11:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbhIEPsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 11:48:31 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF15C061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 08:47:28 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n27so8154233eja.5
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 08:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+fcTuIfPSL6WdPSoyPQDexJMeE1W679eEN0NffGbf1o=;
        b=LwVhVyB94H7sQ8GEkTIEC5jzNJ1zyBoxDFdeSzza860IApJkxT0yIAptysOZ+8oKr4
         PSxiU5E+qtQtIXjo3x7hMxayNZgZCNJL+/gwWc1uO5tYn9sQGH5WKg4tqiZv3qp1rG+U
         DE2Ph+0h5KQmpiVrF8KQ0kE1hjB+pduSyENR0KfIcA5HfZ5xOY2dJRm3kN4BfxiJBvN0
         R28D3bNpFrMPFDCs/Rq0gqxCoi4g/Y7rPzNfgcvAH/0NU6gU0HdduGxKM6WqXRlCQWY4
         WW9VoUu+dIfFAHB2/bej1PqZ15ez94EV7zgieE/LsSPzDmbn2GcdUq92YbABewJ8+c73
         SVNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+fcTuIfPSL6WdPSoyPQDexJMeE1W679eEN0NffGbf1o=;
        b=bsj2v87/51r99LBVfZPnietceiTydJFPDYKJPPq7D6yx9THmDVHhOwAQTF1vAMCxnq
         iWbx9+ByvxzpY+ASbLtFIiQMNLTPzl8TmXMDTYFzUWYjGYGjkg7em/eY8w2ZCZfUELSa
         8NY40JZNlyPIPEBKk/u/kux0l76tPOafVMHNTqJxokJwFcL5Yf/LPzWtQ0VW7tkSa4i7
         aIuGIZ+EYb1/lm7S6VbeTDMGw0vJGgPJamATyhYigszgKrcf1r0hIzKkhEFvCDkjjulo
         +Zz27wQdE6sGO7K0H/92P1aJJ/bSB36pOc7rSf9+6ZemVtQjcggMl8xmKbqyl0rYIq27
         Oa5w==
X-Gm-Message-State: AOAM532hVLkQeIXhe5PdYfXJ79ytf9WntCY59xuaZV/BR7cmacKr/vnS
        UJUHtTr8a+fn7V2AhSiDv7gl4dcB7uzc7m7uq/M=
X-Google-Smtp-Source: ABdhPJwEygtxm8ufOijtlsR+ftZvRQNfzQ7piDdm9oNOC4uKQlRhCEBpK7Q/VZ84M7BMuK7ORJzO0vSlrUQqd0tnLtc=
X-Received: by 2002:a17:906:e51:: with SMTP id q17mr9497268eji.76.1630856847085;
 Sun, 05 Sep 2021 08:47:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
In-Reply-To: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sun, 5 Sep 2021 08:47:16 -0700
Message-ID: <CAKgT0UfX__k29P+SuhSrsantA9=KVi8=9+pspmcDXh+dWuHyfQ@mail.gmail.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only on pull
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@idosch.org>,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 5, 2021 at 8:21 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> From: Willem de Bruijn <willemb@google.com>
>
> The GRE tunnel device can pull existing outer headers in ipge_xmit.
> This is a rare path, apparently unique to this device. The below
> commit ensured that pulling does not move skb->data beyond csum_start.
>
> But it has a false positive if ip_summed is not CHECKSUM_PARTIAL and
> thus csum_start is irrelevant.
>
> Refine to exclude this. At the same time simplify and strengthen the
> test.
>
> Simplify, by moving the check next to the offending pull, making it
> more self documenting and removing an unnecessary branch from other
> code paths.
>
> Strengthen, by also ensuring that the transport header is correct and
> therefore the inner headers will be after skb_reset_inner_headers.
> The transport header is set to csum_start in skb_partial_csum_set.
>
> Link: https://lore.kernel.org/netdev/YS+h%2FtqCJJiQei+W@shredder/
> Fixes: 1d011c4803c7 ("ip_gre: add validation for csum_start")
> Reported-by: Ido Schimmel <idosch@idosch.org>
> Suggested-by: Alexander Duyck <alexander.duyck@gmail.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> ---
>  net/ipv4/ip_gre.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
> index 177d26d8fb9c..0fe6c936dc54 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -473,8 +473,6 @@ static void __gre_xmit(struct sk_buff *skb, struct net_device *dev,
>
>  static int gre_handle_offloads(struct sk_buff *skb, bool csum)
>  {
> -       if (csum && skb_checksum_start(skb) < skb->data)
> -               return -EINVAL;
>         return iptunnel_handle_offloads(skb, csum ? SKB_GSO_GRE_CSUM : SKB_GSO_GRE);
>  }
>
> @@ -632,15 +630,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
>         }
>
>         if (dev->header_ops) {
> +               const int pull_len = tunnel->hlen + sizeof(struct iphdr);
> +
>                 if (skb_cow_head(skb, 0))
>                         goto free_skb;
>
>                 tnl_params = (const struct iphdr *)skb->data;
>
> +               if (pull_len > skb_transport_offset(skb))
> +                       goto free_skb;
> +
>                 /* Pull skb since ip_tunnel_xmit() needs skb->data pointing
>                  * to gre header.
>                  */
> -               skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
> +               skb_pull(skb, pull_len);
>                 skb_reset_mac_header(skb);
>         } else {
>                 if (skb_cow_head(skb, dev->needed_headroom))
> --
> 2.33.0.153.gba50c8fa24-goog
>

Looks good to me.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
