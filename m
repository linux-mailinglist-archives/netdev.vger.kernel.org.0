Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0D3B33C685
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233224AbhCOTJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233295AbhCOTJh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 15:09:37 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A4DC06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 12:09:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mz6-20020a17090b3786b02900c16cb41d63so94992pjb.2
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 12:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=WVZdrwinpXoPU2HmY1rMPyowgGQlWvGG9U0/DkOOvR0=;
        b=HhiPlTGP1AyepdE0cg85RNjYirCW2fWKNlBygT/IfLkMLvGGAj+qo3d11kupF9ttiM
         49Ev3qxJUkfDSO54pQpoJXI39jfuodoQlxSHvNupfyKYN9WLz9tP1YAXUiBjVdSh17a2
         8Wu67lDfJf3XQRyqtoLuYH6I36LzUKd3LqCwtn+1lhj301pZNHV2/4OT/E4+yVseI/AB
         6riFeWLU3A3QYdOuzMtDiutJKZfQAZ1l/9tD/vSlfPxoCPn/eIpvI2nDLCVVXZVSfyPr
         s4lytpyXjKRI7VqXaIFHfcjl3jMb/ohuSb6ATFl8OKWgLMJk4pGxUuMXSG+tLpPyEIIl
         GVkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=WVZdrwinpXoPU2HmY1rMPyowgGQlWvGG9U0/DkOOvR0=;
        b=PlgLM2HOsmP1/7gRUfqV2uEzdeFNxYDTVPpOhhupfRoMFLiFIaY4nsmn3tnPeMHKKX
         2M7oNnVg8lu45u0+WLzHBODieSE5p4rVJaKCXbJPWPIeFdA9jNnE3IkVnfgBYdoBGbWF
         9h7vOjZ5422yv3xEmFhbJwgnggUeWwe6zFsT1DMg5XL9YyVNIG76ue0nXJchRNuj+fXa
         tWBP/4Bj31v3KRL+uSC7kLB8Sx4vY0G/2QlSI1RuW02By46d5fl8oz1eJjmRwj1eFvC3
         dlr9dK4jlGhn/H1AI4s118n69v+yJ2HbVrimL+80YYGH3oz3SPhIOJRALD/CaI58vgBc
         k/CA==
X-Gm-Message-State: AOAM533BY8XCjBacyFD5FtesMrb6SRNCbe1PIRXDLUcVzu8seS+QFHUq
        MnkDTJt4Q3vCSCh/nSiH0/Q=
X-Google-Smtp-Source: ABdhPJzvqy5NeQDCQvj/i/7bGiz827oSfE/NvL/mFHjDQTCieN/J8to/pytaTkvkDHB64qssDub9VQ==
X-Received: by 2002:a17:90a:5b0b:: with SMTP id o11mr586214pji.150.1615835376326;
        Mon, 15 Mar 2021 12:09:36 -0700 (PDT)
Received: from ?IPv6:2601:681:8800:baf9:1ee4:d363:8fe6:b64f? ([2601:681:8800:baf9:1ee4:d363:8fe6:b64f])
        by smtp.gmail.com with ESMTPSA id d124sm14535925pfa.149.2021.03.15.12.09.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 12:09:35 -0700 (PDT)
Message-ID: <10b8d7e649906b3bd8939e3db0056b39d9194a04.camel@gmail.com>
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Date:   Mon, 15 Mar 2021 14:09:34 -0500
In-Reply-To: <CA+FuTSf6xoJ3UuVU=udtcY9qTZdTyh_OL=G32Bex_a1gEjdzqQ@mail.gmail.com>
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
         <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
         <CA+FuTSf6xoJ3UuVU=udtcY9qTZdTyh_OL=G32Bex_a1gEjdzqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-03-15 at 11:50 -0400, Willem de Bruijn wrote:
> On Sun, Mar 14, 2021 at 12:50 PM Andreas Roeseler
> <andreas.a.roeseler@gmail.com> wrote:
> > 
> > Modify the icmp_rcv function to check PROBE messages and call
> > icmp_echo
> > if a PROBE request is detected.
> > 
> > Modify the existing icmp_echo function to respond ot both ping and
> > PROBE
> > requests.
> > 
> > This was tested using a custom modification to the iputils package
> > and
> > wireshark. It supports IPV4 probing by name, ifindex, and probing
> > by
> > both IPV4 and IPV6 addresses. It currently does not support
> > responding
> > to probes off the proxy node (see RFC 8335 Section 2).
> 
> If you happen to use github or something similar, if you don't mind
> sharing the code, you could clone the iputils repo and publish the
> changes. No pressure.

Should I include the link to the github repo in the patch?

> 
> >  net/ipv4/icmp.c | 145 +++++++++++++++++++++++++++++++++++++++++++-
> > ----
> >  1 file changed, 130 insertions(+), 15 deletions(-)
> > 
> > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > index 616e2dc1c8fa..f1530011b7bc 100644
> > --- a/net/ipv4/icmp.c
> > +++ b/net/ipv4/icmp.c
> > @@ -93,6 +93,10 @@
> >  #include <net/ip_fib.h>
> >  #include <net/l3mdev.h>
> > 
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +#include <net/addrconf.h>
> > +#endif
> 
> I don't think the conditional is needed (?)
> 
> >  static bool icmp_echo(struct sk_buff *skb)
> >  {
> > +       struct icmp_ext_hdr *ext_hdr, _ext_hdr;
> > +       struct icmp_ext_echo_iio *iio, _iio;
> > +       struct icmp_bxm icmp_param;
> > +       struct net_device *dev;
> >         struct net *net;
> > +       u16 ident_len;
> > +       char *buff;
> > +       u8 status;
> > 
> >         net = dev_net(skb_dst(skb)->dev);
> > -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> > -               struct icmp_bxm icmp_param;
> > -
> > -               icmp_param.data.icmph      = *icmp_hdr(skb);
> > -               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> > -               icmp_param.skb             = skb;
> > -               icmp_param.offset          = 0;
> > -               icmp_param.data_len        = skb->len;
> > -               icmp_param.head_len        = sizeof(struct
> > icmphdr);
> > -               icmp_reply(&icmp_param, skb);
> > -       }
> >         /* should there be an ICMP stat for ignored echos? */
> > -       return true;
> > +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> > +               return true;
> > +
> > +       icmp_param.data.icmph      = *icmp_hdr(skb);
> > +       icmp_param.skb             = skb;
> > +       icmp_param.offset          = 0;
> > +       icmp_param.data_len        = skb->len;
> > +       icmp_param.head_len        = sizeof(struct icmphdr);
> > +
> > +       if (icmp_param.data.icmph.type == ICMP_ECHO)
> > +               goto send_reply;
> 
> Is this path now missing
> 
>                icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> 
> > +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> > +               return true;
> > +       /* We currently only support probing interfaces on the
> > proxy node
> > +        * Check to ensure L-bit is set
> > +        */
> > +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> > +               return true;
> > +       /* Clear status bits in reply message */
> > +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> > +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> > +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr),
> > &_ext_hdr);
> > +       iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> > sizeof(_iio), &_iio);
> > +       if (!ext_hdr || !iio)
> > +               goto send_mal_query;
> > +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio-
> > >extobj_hdr))
> > +               goto send_mal_query;
> > +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio-
> > >extobj_hdr);
> > +       status = 0;
> > +       dev = NULL;
> > +       switch (iio->extobj_hdr.class_type) {
> > +       case EXT_ECHO_CTYPE_NAME:
> > +               if (ident_len >= IFNAMSIZ)
> > +                       goto send_mal_query;
> > +               buff = kcalloc(IFNAMSIZ, sizeof(char), GFP_KERNEL);
> > +               if (!buff)
> > +                       return -ENOMEM;
> > +               memcpy(buff, &iio->ident.name, ident_len);
> > +               /* RFC 8335 2.1 If the Object Payload would not
> > otherwise terminate
> > +                * on a 32-bit boundary, it MUST be padded with
> > ASCII NULL characters
> > +                */
> > +               if (ident_len % sizeof(u32) != 0) {
> > +                       u8 i;
> > +
> > +                       for (i = ident_len; i % sizeof(u32) != 0;
> > i++) {
> > +                               if (buff[i] != '\0')
> > +                                       goto send_mal_query;
> 
> Memory leak. IFNAMSIZ is small enough that you can use on-stack
> allocation
> 
> Also, I think you can ignore if there are non-zero bytes beyond the
> len. We need to safely parse to avoid integrity bugs in the kernel.
> Beyond that, it's fine to be strict about what you send, liberal what
> you accept.

This checks that the incoming request is padded to the nearest 32-bit
boundary by ASCII NULL characters, as specified by RFC 8335

> 
> > +                       }
> > +               }
> > +               dev = dev_get_by_name(net, buff);
> > +               kfree(buff);
> > +               break;
> > +       case EXT_ECHO_CTYPE_INDEX:
> > +               if (ident_len != sizeof(iio->ident.ifindex))
> > +                       goto send_mal_query;
> > +               dev = dev_get_by_index(net, ntohl(iio-
> > >ident.ifindex));
> > +               break;
> > +       case EXT_ECHO_CTYPE_ADDR:
> > +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr)
> > + iio->ident.addr.ctype3_hdr.addrlen)
> > +                       goto send_mal_query;
> > +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> > +               case ICMP_AFI_IP:
> > +                       if (ident_len != sizeof(iio-
> > >ident.addr.ctype3_hdr) + sizeof(struct in_addr))
> > +                               goto send_mal_query;
> > +                       dev = ip_dev_find(net, iio-
> > >ident.addr.ip_addr.ipv4_addr.s_addr);
> > +                       break;
> > +#if IS_ENABLED(CONFIG_IPV6)
> > +               case ICMP_AFI_IP6:
> > +                       if (ident_len != sizeof(iio-
> > >ident.addr.ctype3_hdr) + sizeof(struct in6_addr))
> > +                               goto send_mal_query;
> > +                       rcu_read_lock();
> > +                       dev = ipv6_dev_find(net, &iio-
> > >ident.addr.ip_addr.ipv6_addr, dev);
> > +                       if (dev)
> > +                               dev_hold(dev);
> > +                       rcu_read_unlock();
> > +                       break;
> > +#endif
> > +               default:
> > +                       goto send_mal_query;
> > +               }
> > +               break;
> > +       default:
> > +               goto send_mal_query;
> > +       }
> > +       if (!dev) {
> > +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> > +               goto send_reply;
> > +       }
> > +       /* Fill bits in reply message */
> > +       if (dev->flags & IFF_UP)
> > +               status |= EXT_ECHOREPLY_ACTIVE;
> > +       if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)-
> > >ifa_list)
> > +               status |= EXT_ECHOREPLY_IPV4;
> > +       if (!list_empty(&dev->ip6_ptr->addr_list))
> > +               status |= EXT_ECHOREPLY_IPV6;
> > +       dev_put(dev);
> > +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> > +send_reply:
> > +       icmp_reply(&icmp_param, skb);
> > +               return true;
> > +send_mal_query:
> > +       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> > +       goto send_reply;
> >  }
> > 
> >  /*
> > @@ -1088,6 +1192,11 @@ int icmp_rcv(struct sk_buff *skb)
> >         icmph = icmp_hdr(skb);
> > 
> >         ICMPMSGIN_INC_STATS(net, icmph->type);
> > +
> > +       /* Check for ICMP Extended Echo (PROBE) messages */
> > +       if (icmph->type == ICMP_EXT_ECHO)
> > +               goto probe;
> > +
> >         /*
> >          *      18 is the highest 'known' ICMP type. Anything else
> > is a mystery
> >          *
> > @@ -1097,7 +1206,6 @@ int icmp_rcv(struct sk_buff *skb)
> >         if (icmph->type > NR_ICMP_TYPES)
> >                 goto error;
> > 
> > -
> >         /*
> >          *      Parse the ICMP message
> >          */
> > @@ -1123,7 +1231,7 @@ int icmp_rcv(struct sk_buff *skb)
> >         }
> > 
> >         success = icmp_pointers[icmph->type].handler(skb);
> > -
> > +success_check:
> >         if (success)  {
> >                 consume_skb(skb);
> >                 return NET_RX_SUCCESS;
> > @@ -1137,6 +1245,12 @@ int icmp_rcv(struct sk_buff *skb)
> >  error:
> >         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
> >         goto drop;
> > +probe:
> > +       /* We can't use icmp_pointers[].handler() because it is an
> > array of
> > +        * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code
> > 42.
> > +        */
> > +       success = icmp_echo(skb);
> > +       goto success_check;
> 
> just make this a branch instead of

Could you clarify this comment? Do you mean move this code to the
section where we check for PROBE messages instead of jumping to probe
and then jumping to success_check?


