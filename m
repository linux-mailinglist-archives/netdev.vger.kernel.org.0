Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBD9A46DD99
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbhLHVaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233054AbhLHVaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:30:19 -0500
Received: from mail-ua1-x92c.google.com (mail-ua1-x92c.google.com [IPv6:2607:f8b0:4864:20::92c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E31BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 13:26:47 -0800 (PST)
Received: by mail-ua1-x92c.google.com with SMTP id 30so7118692uag.13
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 13:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uXfGwhRkuDJiwWJax5kqTEWYX/aEQTyPk8a4mbZs718=;
        b=jqSkA+jtMSB9h0rJA3bWs31k6yfdpUoTIizbOWuqEwRfP39z8DPivnxOm0Dq3TpOPp
         0SR0RXlge+6vOrfccJQUwf/iausJ2WoWohsueDDSGRDgfxP0cT5WTSbGv5QoncknRTTo
         EqLcgXPnwj3xplF6TNo4/Kgs6JUTUX8GakUzxBLknN7NkCzs+GxGk9rYB+UGIpSWmwKc
         VrfDDUDn8o83HKdyLyFyQ5rH+SSxl/NnaE1SyhChlR9MWi1qumJhMHN3enr7LgfOu4ge
         jHSDmwWZeHQp264FBleCFqeo6uuWcKiBsVWUwlzSVVfVKcRLhqZd2GHkFhE6RX92AKdg
         Vwsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uXfGwhRkuDJiwWJax5kqTEWYX/aEQTyPk8a4mbZs718=;
        b=JvlcFdQd1DCs5m4mw/G8pwucKVKYcKv5+goIZR47viX9jgNLT/iBsBYxW+iXqChDNi
         EflnX8y3ZOswTAXyp/s+8W9OmEhKaVssC5IaljeZIs8EzAur7ntDP5b06VvUl4Ipwc//
         Gl/XFS+4cZ/TWzDHzi2I68gAJR6hqUckTlhDyFftzaEe3KgTUoNNz76WD0OdlpjgMMFN
         HNBCTz3YY+4XDhpiLZW+kFroiDTSzhPcIr3/M1/zIz69eYijrMCCbo4NuIpbKu0CAd48
         H367xD8UKsAtZ1CizkveKXyJbjJvLjL5zqLDNBGAJ3TuSFBCwA5tD2Oqke+8eM5pr34q
         N7eA==
X-Gm-Message-State: AOAM531De9ViP7XWFqnCK6PkRE18MYXtGUQTZqQHenjIka6jygo8ucX9
        8zqINX9q0Bcnzhli6azyuVffWylWSj8=
X-Google-Smtp-Source: ABdhPJw51Wu9YKQcol2jqNFsZjUmGwy0IvpnrEZTuJspq5jtWn8fkEEbgZd9v/eGL9mCkv5eHlygSw==
X-Received: by 2002:ab0:22d6:: with SMTP id z22mr11703037uam.65.1638998806206;
        Wed, 08 Dec 2021 13:26:46 -0800 (PST)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com. [209.85.222.50])
        by smtp.gmail.com with ESMTPSA id i56sm2580971vkr.25.2021.12.08.13.26.45
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 13:26:45 -0800 (PST)
Received: by mail-ua1-f50.google.com with SMTP id t13so7160096uad.9
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 13:26:45 -0800 (PST)
X-Received: by 2002:a67:3093:: with SMTP id w141mr1617426vsw.24.1638998805265;
 Wed, 08 Dec 2021 13:26:45 -0800 (PST)
MIME-Version: 1.0
References: <20211208173831.3791157-1-andrew@lunn.ch> <20211208173831.3791157-4-andrew@lunn.ch>
In-Reply-To: <20211208173831.3791157-4-andrew@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 8 Dec 2021 16:26:05 -0500
X-Gmail-Original-Message-ID: <CA+FuTScYqNfFmuYXJZHi24gs-Vyx8AJW8tPuehW75wdO4arPgw@mail.gmail.com>
Message-ID: <CA+FuTScYqNfFmuYXJZHi24gs-Vyx8AJW8tPuehW75wdO4arPgw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 3/3] udp6: Use Segment Routing Header for dest
 address if present
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> When finding the socket to report an error on, if the invoking packet
> is using Segment Routing, the IPv6 destination address is that of an
> intermediate router, not the end destination. Extract the ultimate
> destination address from the segment address.
>
> This change allows traceroute to function in the presence of Segment
> Routing.
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/net/seg6.h | 19 +++++++++++++++++++
>  net/ipv6/udp.c     |  3 ++-
>  2 files changed, 21 insertions(+), 1 deletion(-)
>
> diff --git a/include/net/seg6.h b/include/net/seg6.h
> index 02b0cd305787..af668f17b398 100644
> --- a/include/net/seg6.h
> +++ b/include/net/seg6.h
> @@ -65,4 +65,23 @@ extern int seg6_do_srh_encap(struct sk_buff *skb, struct ipv6_sr_hdr *osrh,
>  extern int seg6_do_srh_inline(struct sk_buff *skb, struct ipv6_sr_hdr *osrh);
>  extern int seg6_lookup_nexthop(struct sk_buff *skb, struct in6_addr *nhaddr,
>                                u32 tbl_id);
> +
> +/* If the packet which invoked an ICMP error contains an SRH return
> + * the true destination address from within the SRH, otherwise use the
> + * destination address in the IP header.
> + */

nit: the above describes the behavior of the caller, not the function.
The function returns NULL if no SRH is found.

> +static inline const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
> +                                                   struct inet6_skb_parm *opt)
> +{
> +       struct ipv6_sr_hdr *srh;
> +
> +       if (opt->flags & IP6SKB_SEG6) {
> +               srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
> +               return  &srh->segments[0];
> +       }
> +
> +       return NULL;
> +}
> +
> +
>  #endif
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 6a0e569f0bb8..a14375e3f923 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -40,6 +40,7 @@
>  #include <net/transp_v6.h>
>  #include <net/ip6_route.h>
>  #include <net/raw.h>
> +#include <net/seg6.h>
>  #include <net/tcp_states.h>
>  #include <net/ip6_checksum.h>
>  #include <net/ip6_tunnel.h>
> @@ -561,7 +562,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
>         struct ipv6_pinfo *np;
>         const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
>         const struct in6_addr *saddr = &hdr->saddr;
> -       const struct in6_addr *daddr = &hdr->daddr;
> +       const struct in6_addr *daddr = seg6_get_daddr(skb, opt) ? : &hdr->daddr;
>         struct udphdr *uh = (struct udphdr *)(skb->data+offset);
>         bool tunnel = false;
>         struct sock *sk;
> --
> 2.33.1
>
