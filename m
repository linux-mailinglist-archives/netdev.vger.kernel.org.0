Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8096246540D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhLARhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233404AbhLARhe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:37:34 -0500
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07EF0C061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 09:34:13 -0800 (PST)
Received: by mail-vk1-xa31.google.com with SMTP id u68so16634475vke.11
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 09:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TDKAafV2gjMFE33oexEFOBQ8rL+NxNWwSDWVYnIRcPs=;
        b=N85Mwym9BrUJNkThD0nAIt9jcvmDZIKpWb8UTDiNSlqKqTq018+zZ2juZRLy4PV9ZR
         M4eQk3dzryA2tHp0wBM5G8tsBt+2S9FeX9pvgmGtjVoN1ynHqOiJLiNSFfJLlNTeeYti
         QvXWt4gJmCgPMOL9pkUmXllJGGzprNsGQIEl8QSey8scMmKNF/VNaQMs6cyXOFYw+QPj
         q+mrK5rEfnbsL9la9/SulZJk06iWDHA4MWo+eNuwMXFR/T4kr4mYz5dgcLj/832FX1X9
         dOSvQRzmsraM8mnCT8DOfDarHeApwEBkgOMNHidO1qwzxfyvBXXU9S3F96vtOfyBiBCk
         +cRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TDKAafV2gjMFE33oexEFOBQ8rL+NxNWwSDWVYnIRcPs=;
        b=dJnFakCtpok0dwFzKqKmVuJ7yEGssVxQBML+opvRNxy7b/dkUypv68FC6IpW1uqvxf
         M9tyIAVEjdTPBr4IXRge8cnDgyuOI9ZheoU65B6Vw9Ybpryl8BY76v18jKzOPxS8GO1J
         GTMqJmVBgVN4QOu7nd5DXUzeHfzw1+fzy8Krn9Bw3IBgzP//SawyKFlaQ26dp0TQhdJR
         +ILM9iXfoDUqLk5oy2f6/iyvBHonDOciYL1ohiP/nCa9iftneT06OkNwXIE6GrjOBm/e
         Bm32ANuGBw1ZmhDqSudU4c6yHyWptxADKp99JjKVBlsZAMUQeT9bjXs9l+AMqACb5TCn
         +X6A==
X-Gm-Message-State: AOAM532wWpsPp0jukmmUK2WD3RIMTq2fAzqwKwXvcirVJmO5K5VD5O/Y
        CXOE0dZr+2+ADNjz2PFhVO5k2rCAwMyd6g==
X-Google-Smtp-Source: ABdhPJwpQrYwKYkNG7P8+tqalPQVPvhcisUA3G8F1xdYACFYU1I3eC7GZP39XdotB+tWtHUqp06EJw==
X-Received: by 2002:a05:6122:d09:: with SMTP id az9mr10076105vkb.23.1638380052127;
        Wed, 01 Dec 2021 09:34:12 -0800 (PST)
Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com. [209.85.221.181])
        by smtp.gmail.com with ESMTPSA id o188sm139240vko.48.2021.12.01.09.34.11
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 09:34:11 -0800 (PST)
Received: by mail-vk1-f181.google.com with SMTP id h1so9475622vkh.0
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 09:34:11 -0800 (PST)
X-Received: by 2002:a05:6122:130f:: with SMTP id e15mr9265117vkp.14.1638380051022;
 Wed, 01 Dec 2021 09:34:11 -0800 (PST)
MIME-Version: 1.0
References: <20211201163245.3629254-1-andrew@lunn.ch> <20211201163245.3629254-3-andrew@lunn.ch>
In-Reply-To: <20211201163245.3629254-3-andrew@lunn.ch>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Dec 2021 09:33:32 -0800
X-Gmail-Original-Message-ID: <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
Message-ID: <CA+FuTSfLxEic2ZtD8ygzUQMrftLkRyfjdf7GH6Pf8ioSRjHrOg@mail.gmail.com>
Subject: Re: [patch RFC net-next 2/3] icmp: ICMPV6: Examine invoking packet
 for Segment Route Headers.
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

>  include/linux/ipv6.h |  2 ++
>  net/ipv6/icmp.c      | 36 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 37 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index 20c1f968da7c..d8ab5022d397 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -133,6 +133,7 @@ struct inet6_skb_parm {
>         __u16                   dsthao;
>  #endif
>         __u16                   frag_max_size;
> +       __u16                   srhoff;

Out of scope for this patch, but I guess we could use a

BUILD_BUG_ON(sizeof(struct inet6_skb_parm) > sizeof_field(struct sk_buff, cb));

>
>  #define IP6SKB_XFRM_TRANSFORMED        1
>  #define IP6SKB_FORWARDED       2
> @@ -142,6 +143,7 @@ struct inet6_skb_parm {
>  #define IP6SKB_HOPBYHOP        32
>  #define IP6SKB_L3SLAVE         64
>  #define IP6SKB_JUMBOGRAM      128
> +#define IP6SKB_SEG6          512

256?

>  };
>
>  #if defined(CONFIG_NET_L3_MASTER_DEV)
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index a7c31ab67c5d..315787b79f29 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -57,6 +57,7 @@
>  #include <net/protocol.h>
>  #include <net/raw.h>
>  #include <net/rawv6.h>
> +#include <net/seg6.h>
>  #include <net/transp_v6.h>
>  #include <net/ip6_route.h>
>  #include <net/addrconf.h>
> @@ -818,9 +819,40 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>         local_bh_enable();
>  }
>
> +/* Determine if the invoking packet contains a segment routing header.
> + * If it does, extract the true destination address, which is the
> + * first segment address
> + */
> +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> +{
> +       struct sk_buff *skb_orig;
> +       struct ipv6_sr_hdr *srh;
> +
> +       skb_orig = skb_clone(skb, GFP_ATOMIC);
> +       if (!skb_orig)
> +               return;

Is this to be allowed to write to skb->cb? Or because seg6_get_srh
calls pskb_may_pull to parse the headers?

It is unlikely (not impossible) in this path for the packet to be
shared or cloned. Avoid this operation when it isn't? Most packets
will not actually have segment routing, so this imposes significant
cost on the common case (if in the not common ICMP processing path).

nit: I found the name skb_orig confusing, as it is not in the meaning
of preserve the original skb as at function entry.

> +       skb_dst_drop(skb_orig);
> +       skb_reset_network_header(skb_orig);
> +
> +       srh = seg6_get_srh(skb_orig, 0);
> +       if (!srh)
> +               goto out;
> +
> +       if (srh->type != IPV6_SRCRT_TYPE_4)
> +               goto out;
> +
> +       opt->flags |= IP6SKB_SEG6;
> +       opt->srhoff = (unsigned char *)srh - skb->data;

Should this offset be against skb->head, in case other data move
operations could occur?

Also, what happens if the header was in a frags that was pulled by
pskb_may_pull in seg6_get_srh.

If we can expect headers to exist in the linear segment, then perhaps
the whole code can be simplified and the clone can be avoided.

> +
> +out:
> +       kfree_skb(skb_orig);
> +}
> +
>  void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
>  {
>         const struct inet6_protocol *ipprot;
> +       struct inet6_skb_parm *opt = IP6CB(skb);
>         int inner_offset;
>         __be16 frag_off;
>         u8 nexthdr;
> @@ -829,6 +861,8 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
>         if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
>                 goto out;
>
> +       icmpv6_notify_srh(skb, opt);
> +
>         nexthdr = ((struct ipv6hdr *)skb->data)->nexthdr;
>         if (ipv6_ext_hdr(nexthdr)) {
>                 /* now skip over extension headers */
> @@ -853,7 +887,7 @@ void icmpv6_notify(struct sk_buff *skb, u8 type, u8 code, __be32 info)
>
>         ipprot = rcu_dereference(inet6_protos[nexthdr]);
>         if (ipprot && ipprot->err_handler)
> -               ipprot->err_handler(skb, NULL, type, code, inner_offset, info);
> +               ipprot->err_handler(skb, opt, type, code, inner_offset, info);
>
>         raw6_icmp_error(skb, nexthdr, type, code, inner_offset, info);
>         return;
> --
> 2.33.1
>
