Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 489A42A4F25
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgKCSm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728351AbgKCSm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:42:58 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05FCFC0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 10:42:58 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id b129so10046778vsb.1
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 10:42:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SA2+2YtT4NJgMHsDfcOa09qPdWt4v/UtcrQOvF0d5yQ=;
        b=BvgIhetmjcrnmI3hCIxI6JFCDRsCeyrjXoiUzHhAYQgmcuGsJkJtl5+sf9/qtPdSmO
         SYA3QySjB6a91ck8naHZiPlbzZcshs1MwdXKSJbXZhZ6Asw+tNuqG4lsFGxByb+oBKiw
         4mzyBOK9cekLnKY3eLfhKD8xIGHkzBSJgyvu1ueuJYVJecjjc794qrIRZiCZ97SW6oDp
         MvPK9LszerGrB7ApAw6uF597SyAHjBxh42VwUzd9VkbMnVNUSuLDJbnzlHn/KG2c9JtD
         QSNTz9qJ0Xw1UDSXmLpZvzFZahRJgMcbBHBnfEWIxkvgkcZ43RLfJhFqVmjnwnfOwPey
         e1jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SA2+2YtT4NJgMHsDfcOa09qPdWt4v/UtcrQOvF0d5yQ=;
        b=A8I24vQqbxIgKI5dqpXHmEcQJDdgVYm4GzW8wAjaXlbLCHI/Jk9q3Q67uHrczh98LV
         u/7vAFnJVt5aEsjC93UhOVcYxbel1YLe8ULM0duhZW/qmbSp2VKQNcs/RSo3wnmVaTie
         sE+a/9TTxKLD/mmdYL0d44xrIo3N1/e8R65Y00f2kkWpg8zULEw9/gHkBP9hUt4HgIvh
         uhaRWQY3/MMmANRhnIu4N3vs6/3FyBLSqw6Tyk82rD4udXVIALQ2doscCFUoCnqpA2xB
         /A2uRk3McbDcEu7ZKLou+PPvKB8TOn/s8nBW+Vn8co9Qt3X6RXQ3tuuVq5tFx7zIWZz9
         zQ6w==
X-Gm-Message-State: AOAM533rHFvtHCeejvTTocBkJq/6nuZcULE+sSpKXIhPVe27WnX3X/ju
        ALTlJtF+zW0WmiSKnSRWr3GZQcuXz/k=
X-Google-Smtp-Source: ABdhPJyr5hLrpKYovYq7IsRKekY+rLk+K6YFaPg6dkc+t5PEKHcAClbEYVYb6yQasY4hc7fr5rhKVg==
X-Received: by 2002:a67:a41:: with SMTP id 62mr17649061vsk.33.1604428976420;
        Tue, 03 Nov 2020 10:42:56 -0800 (PST)
Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com. [209.85.221.172])
        by smtp.gmail.com with ESMTPSA id g7sm1526631vsp.25.2020.11.03.10.42.54
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Nov 2020 10:42:55 -0800 (PST)
Received: by mail-vk1-f172.google.com with SMTP id t67so3923832vkb.8
        for <netdev@vger.kernel.org>; Tue, 03 Nov 2020 10:42:54 -0800 (PST)
X-Received: by 2002:a1f:5341:: with SMTP id h62mr16828240vkb.24.1604428974262;
 Tue, 03 Nov 2020 10:42:54 -0800 (PST)
MIME-Version: 1.0
References: <20201103104133.GA1573211@tws>
In-Reply-To: <20201103104133.GA1573211@tws>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Nov 2020 13:42:17 -0500
X-Gmail-Original-Message-ID: <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
Message-ID: <CA+FuTSdf35EqALizep-65_sF46pk46_RqmEhS9gjw_5rF5cr1Q@mail.gmail.com>
Subject: Re: [PATCH] IPv6: Set SIT tunnel hard_header_len to zero
To:     Oliver Herms <oliver.peter.herms@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 5:41 AM Oliver Herms
<oliver.peter.herms@gmail.com> wrote:
>
> Due to the legacy usage of hard_header_len for SIT tunnels while
> already using infrastructure from net/ipv4/ip_tunnel.c the
> calculation of the path MTU in tnl_update_pmtu is incorrect.
> This leads to unnecessary creation of MTU exceptions for any
> flow going over a SIT tunnel.
>
> As SIT tunnels do not have a header themsevles other than their
> transport (L3, L2) headers we're leaving hard_header_len set to zero
> as tnl_update_pmtu is already taking care of the transport headers
> sizes.
>
> This will also help avoiding unnecessary IPv6 GC runs and spinlock
> contention seen when using SIT tunnels and for more than
> net.ipv6.route.gc_thresh flows.

Thanks. Yes, this is long overdue.

The hard_header_len issue was also recently discussed in the context
of GRE in commit fdafed459998 ("ip_gre: set dev->hard_header_len and
dev->needed_headroom properly").

Question is whether we should reserve room in needed_headroom instead.
AFAIK this existing update logic in ip6_tnl_xmit is sufficient

"
        /* Calculate max headroom for all the headers and adjust
         * needed_headroom if necessary.
         */
        max_headroom = LL_RESERVED_SPACE(dst->dev) + sizeof(struct ipv6hdr)
                        + dst->header_len + t->hlen;
        if (max_headroom > dev->needed_headroom)
                dev->needed_headroom = max_headroom;
"

> Fixes: c54419321455 ("GRE: Refactor GRE tunneling code.")

How did you arrive at this SHA1?

> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv6/sit.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
> index 5e2c34c0ac97..5e7983cb6154 100644
> --- a/net/ipv6/sit.c
> +++ b/net/ipv6/sit.c
> @@ -1128,7 +1128,6 @@ static void ipip6_tunnel_bind_dev(struct net_device *dev)
>         if (tdev && !netif_is_l3_master(tdev)) {
>                 int t_hlen = tunnel->hlen + sizeof(struct iphdr);
>
> -               dev->hard_header_len = tdev->hard_header_len + sizeof(struct iphdr);
>                 dev->mtu = tdev->mtu - t_hlen;
>                 if (dev->mtu < IPV6_MIN_MTU)
>                         dev->mtu = IPV6_MIN_MTU;
> @@ -1426,7 +1425,6 @@ static void ipip6_tunnel_setup(struct net_device *dev)
>         dev->priv_destructor    = ipip6_dev_free;
>
>         dev->type               = ARPHRD_SIT;
> -       dev->hard_header_len    = LL_MAX_HEADER + t_hlen;
>         dev->mtu                = ETH_DATA_LEN - t_hlen;
>         dev->min_mtu            = IPV6_MIN_MTU;
>         dev->max_mtu            = IP6_MAX_MTU - t_hlen;
> --
> 2.25.1
>
