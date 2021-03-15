Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2331333C088
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 16:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbhCOPvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 11:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbhCOPvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 11:51:05 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35662C061762
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:51:04 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id si25so11365580ejb.1
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Auq5RGOmP5PgUkD9fyagQK7p2Lxp0Vvera/o40KUsSI=;
        b=hvkiH7QbxzDHvFQ01GBmBRiBOQwoZNrh56yjsrfIckKYp9/Y1tepRbTZ+okrdOUUVA
         /eOOS9YTnkVF1nxAIDgFg/fT4pGogfFT3DJ6M14Sfv24tFbDmcucgaGSASsEYgOxOmg7
         nRoWno4GM22l4AjBXKtGJzkV9Q1GWQTKsCKR3rgj0DEU53XtAtRwY99Yd/p5N2eo62pd
         Fmn/+OVhOOvcKzh2DFZmwqJMgyW+QAuAAB7oKJk3cBgx9geULfR3KtjCETvm5v2UyceB
         iiXTgoASsJVynyVUtjyn8u1AajgDhgIsu0gtxFD7yLI3CInnbRDy+zqqnxRIPfv7Nzbn
         KxqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Auq5RGOmP5PgUkD9fyagQK7p2Lxp0Vvera/o40KUsSI=;
        b=DPYg9DrL4VRIuhlm7m8e/Ks8O+B74B46mD8mfF1XrWr1Fj5GB6bcdcQVLuRjLBrvic
         sSu/+M/V61g1aXa8Q+8abgrF/x7BAjZX6VJozrrz7dKIUyNFY52qt1ptpyHuifdZpGcU
         FEzx6hKezgF0tN53ef/zaQV3UZfdGmOHqa1/m9xepsxYOVLX+FMTBQB4b1c0pTUYSIjs
         Mgl5J5GpJfv+ffjeBVa5rCPJmXU2+BJqYs+nqva0GwGnygotpisqT/8a9K8Aoa/xDX+Y
         /JVZeGVu93RP1g2if5STYg320P5FS3f61qkI4CPYugeTnOFJ9qfJMP145zvNbas1Sz1N
         oxkA==
X-Gm-Message-State: AOAM531XVuTrFs6ntOb/XzbeGD010nBYaC68UtjA7Lr2EI3+bsbu4MpO
        TWUjwiQlZKNbcslTwlCCMyajRFs6Rtw=
X-Google-Smtp-Source: ABdhPJzvujmV7p8MjnLlMi2iGN7nEwVpNXbt5lgWm9JAyCh0jBQyzjrqFT4DLZ0J35g+gi+BswamxA==
X-Received: by 2002:a17:906:aada:: with SMTP id kt26mr23768098ejb.137.1615823462458;
        Mon, 15 Mar 2021 08:51:02 -0700 (PDT)
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com. [209.85.128.47])
        by smtp.gmail.com with ESMTPSA id gj26sm7524373ejb.67.2021.03.15.08.51.01
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 08:51:01 -0700 (PDT)
Received: by mail-wm1-f47.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso20562184wma.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 08:51:01 -0700 (PDT)
X-Received: by 2002:a1c:2155:: with SMTP id h82mr304903wmh.169.1615823461239;
 Mon, 15 Mar 2021 08:51:01 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com> <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 15 Mar 2021 11:50:22 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf6xoJ3UuVU=udtcY9qTZdTyh_OL=G32Bex_a1gEjdzqQ@mail.gmail.com>
Message-ID: <CA+FuTSf6xoJ3UuVU=udtcY9qTZdTyh_OL=G32Bex_a1gEjdzqQ@mail.gmail.com>
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 14, 2021 at 12:50 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Modify the icmp_rcv function to check PROBE messages and call icmp_echo
> if a PROBE request is detected.
>
> Modify the existing icmp_echo function to respond ot both ping and PROBE
> requests.
>
> This was tested using a custom modification to the iputils package and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by
> both IPV4 and IPV6 addresses. It currently does not support responding
> to probes off the proxy node (see RFC 8335 Section 2).

If you happen to use github or something similar, if you don't mind
sharing the code, you could clone the iputils repo and publish the
changes. No pressure.

>  net/ipv4/icmp.c | 145 +++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 130 insertions(+), 15 deletions(-)
>
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 616e2dc1c8fa..f1530011b7bc 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -93,6 +93,10 @@
>  #include <net/ip_fib.h>
>  #include <net/l3mdev.h>
>
> +#if IS_ENABLED(CONFIG_IPV6)
> +#include <net/addrconf.h>
> +#endif

I don't think the conditional is needed (?)

>  static bool icmp_echo(struct sk_buff *skb)
>  {
> +       struct icmp_ext_hdr *ext_hdr, _ext_hdr;
> +       struct icmp_ext_echo_iio *iio, _iio;
> +       struct icmp_bxm icmp_param;
> +       struct net_device *dev;
>         struct net *net;
> +       u16 ident_len;
> +       char *buff;
> +       u8 status;
>
>         net = dev_net(skb_dst(skb)->dev);
> -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -               struct icmp_bxm icmp_param;
> -
> -               icmp_param.data.icmph      = *icmp_hdr(skb);
> -               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -               icmp_param.skb             = skb;
> -               icmp_param.offset          = 0;
> -               icmp_param.data_len        = skb->len;
> -               icmp_param.head_len        = sizeof(struct icmphdr);
> -               icmp_reply(&icmp_param, skb);
> -       }
>         /* should there be an ICMP stat for ignored echos? */
> -       return true;
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
> +
> +       icmp_param.data.icmph      = *icmp_hdr(skb);
> +       icmp_param.skb             = skb;
> +       icmp_param.offset          = 0;
> +       icmp_param.data_len        = skb->len;
> +       icmp_param.head_len        = sizeof(struct icmphdr);
> +
> +       if (icmp_param.data.icmph.type == ICMP_ECHO)
> +               goto send_reply;

Is this path now missing

               icmp_param.data.icmph.type = ICMP_ECHOREPLY;

> +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +               return true;
> +       /* We currently only support probing interfaces on the proxy node
> +        * Check to ensure L-bit is set
> +        */
> +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> +               return true;
> +       /* Clear status bits in reply message */
> +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr), &_ext_hdr);
> +       iio = skb_header_pointer(skb, sizeof(_ext_hdr), sizeof(_iio), &_iio);
> +       if (!ext_hdr || !iio)
> +               goto send_mal_query;
> +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio->extobj_hdr))
> +               goto send_mal_query;
> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);
> +       status = 0;
> +       dev = NULL;
> +       switch (iio->extobj_hdr.class_type) {
> +       case EXT_ECHO_CTYPE_NAME:
> +               if (ident_len >= IFNAMSIZ)
> +                       goto send_mal_query;
> +               buff = kcalloc(IFNAMSIZ, sizeof(char), GFP_KERNEL);
> +               if (!buff)
> +                       return -ENOMEM;
> +               memcpy(buff, &iio->ident.name, ident_len);
> +               /* RFC 8335 2.1 If the Object Payload would not otherwise terminate
> +                * on a 32-bit boundary, it MUST be padded with ASCII NULL characters
> +                */
> +               if (ident_len % sizeof(u32) != 0) {
> +                       u8 i;
> +
> +                       for (i = ident_len; i % sizeof(u32) != 0; i++) {
> +                               if (buff[i] != '\0')
> +                                       goto send_mal_query;

Memory leak. IFNAMSIZ is small enough that you can use on-stack allocation

Also, I think you can ignore if there are non-zero bytes beyond the
len. We need to safely parse to avoid integrity bugs in the kernel.
Beyond that, it's fine to be strict about what you send, liberal what
you accept.

> +                       }
> +               }
> +               dev = dev_get_by_name(net, buff);
> +               kfree(buff);
> +               break;
> +       case EXT_ECHO_CTYPE_INDEX:
> +               if (ident_len != sizeof(iio->ident.ifindex))
> +                       goto send_mal_query;
> +               dev = dev_get_by_index(net, ntohl(iio->ident.ifindex));
> +               break;
> +       case EXT_ECHO_CTYPE_ADDR:
> +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen)
> +                       goto send_mal_query;
> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> +               case ICMP_AFI_IP:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in_addr))
> +                               goto send_mal_query;
> +                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr.s_addr);
> +                       break;
> +#if IS_ENABLED(CONFIG_IPV6)
> +               case ICMP_AFI_IP6:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in6_addr))
> +                               goto send_mal_query;
> +                       rcu_read_lock();
> +                       dev = ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);
> +                       if (dev)
> +                               dev_hold(dev);
> +                       rcu_read_unlock();
> +                       break;
> +#endif
> +               default:
> +                       goto send_mal_query;
> +               }
> +               break;
> +       default:
> +               goto send_mal_query;
> +       }
> +       if (!dev) {
> +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> +               goto send_reply;
> +       }
> +       /* Fill bits in reply message */
> +       if (dev->flags & IFF_UP)
> +               status |= EXT_ECHOREPLY_ACTIVE;
> +       if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)->ifa_list)
> +               status |= EXT_ECHOREPLY_IPV4;
> +       if (!list_empty(&dev->ip6_ptr->addr_list))
> +               status |= EXT_ECHOREPLY_IPV6;
> +       dev_put(dev);
> +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> +send_reply:
> +       icmp_reply(&icmp_param, skb);
> +               return true;
> +send_mal_query:
> +       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +       goto send_reply;
>  }
>
>  /*
> @@ -1088,6 +1192,11 @@ int icmp_rcv(struct sk_buff *skb)
>         icmph = icmp_hdr(skb);
>
>         ICMPMSGIN_INC_STATS(net, icmph->type);
> +
> +       /* Check for ICMP Extended Echo (PROBE) messages */
> +       if (icmph->type == ICMP_EXT_ECHO)
> +               goto probe;
> +
>         /*
>          *      18 is the highest 'known' ICMP type. Anything else is a mystery
>          *
> @@ -1097,7 +1206,6 @@ int icmp_rcv(struct sk_buff *skb)
>         if (icmph->type > NR_ICMP_TYPES)
>                 goto error;
>
> -
>         /*
>          *      Parse the ICMP message
>          */
> @@ -1123,7 +1231,7 @@ int icmp_rcv(struct sk_buff *skb)
>         }
>
>         success = icmp_pointers[icmph->type].handler(skb);
> -
> +success_check:
>         if (success)  {
>                 consume_skb(skb);
>                 return NET_RX_SUCCESS;
> @@ -1137,6 +1245,12 @@ int icmp_rcv(struct sk_buff *skb)
>  error:
>         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
>         goto drop;
> +probe:
> +       /* We can't use icmp_pointers[].handler() because it is an array of
> +        * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code 42.
> +        */
> +       success = icmp_echo(skb);
> +       goto success_check;

just make this a branch instead of
