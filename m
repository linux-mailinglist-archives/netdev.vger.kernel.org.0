Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030F333C6E5
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:35:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233137AbhCOTet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbhCOTeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 15:34:46 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DF5C06174A
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 12:34:46 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id x21so18713242eds.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 12:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=w9ehO9eNHPN6X8VMXPtKEWxEFiq+YGTJgu2imH4TlpI=;
        b=KFyQzdWZPfCs9G2i33plBDKQE4lnbtgpLXdn6T0tNuQXoMJH6EXWfddrbEZ3RREtji
         StF9AR9rCBbmf6lFhGO10mXryHCBWnkq8H2Fm9lhMCCNQ83f0fWUwF51nvlJ12uZHFU3
         DCqhuhPQzbmY4TIlclNNA3pK25hKdWlt+MgIBobU9Ki7d0G3Qg83fSz21ztHbCsh+aey
         8m5RDpuLcb1wc1epclZzdFKHpHOoN5Dg7dbqkC+yQZZ1U699NMFqtyqGo7VOMSJPuFF+
         lUkr6ecprB7TG5y/7pFulrv/iKlZyLXS659e9daBizfox5p44I1XOq8pAyme5QMCTArS
         xPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=w9ehO9eNHPN6X8VMXPtKEWxEFiq+YGTJgu2imH4TlpI=;
        b=Iqp8KX8x0bzkogx59WEf7iIIjlE0oU2/TdPi2XFeGawtpNM4Qxe9qzkEu3LQygNMPa
         nedgjb5hDdf+vNSXQ93heap0tPJwMHq+mXDIXJruNdbgvzfh7s3PHKPlWkAB7BWykpkW
         6LkKuYin57EP7J1RVx5EM9TPQkKtB3iUVa/QEJEIYLhwc7eu1cUrOpkK9uL8J5DvAMno
         mQIkXPoXuOXbxgLF6Ot1DSQMxcl65w2KvpjBHLZFAzqoC5ejsWHbM2shJDJF2HhITUPi
         4Y45+R/Qm7eIls+0urDA81vsqm6Zso2IHJbYrLUywBDh5j9tyIVG0DaS64RJAbz+NsuR
         tbOw==
X-Gm-Message-State: AOAM530BQCbZyTprU/fxO8wQ5q7nhi40bcaky1MsQC8zKXk2un4XPXCY
        kOSa6R9kFSKFgsccPiGZ2404CxxlQB4=
X-Google-Smtp-Source: ABdhPJwNZ85K3N3PHyLur/M+0JRDpWcsBYI2nmCu8FpgUc+4wDYy84MrSys98B4ZQDxFMb/0ZRx8Aw==
X-Received: by 2002:a05:6402:35d3:: with SMTP id z19mr31646594edc.143.1615836884589;
        Mon, 15 Mar 2021 12:34:44 -0700 (PDT)
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com. [209.85.128.50])
        by smtp.gmail.com with ESMTPSA id sb4sm7978118ejb.71.2021.03.15.12.34.43
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 12:34:44 -0700 (PDT)
Received: by mail-wm1-f50.google.com with SMTP id g8so8802243wmd.4
        for <netdev@vger.kernel.org>; Mon, 15 Mar 2021 12:34:43 -0700 (PDT)
X-Received: by 2002:a1c:2155:: with SMTP id h82mr1190048wmh.169.1615836883328;
 Mon, 15 Mar 2021 12:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1615738431.git.andreas.a.roeseler@gmail.com>
 <a30d45c43a24f7b65febe51929e6fe990a904805.1615738432.git.andreas.a.roeseler@gmail.com>
 <CA+FuTSf6xoJ3UuVU=udtcY9qTZdTyh_OL=G32Bex_a1gEjdzqQ@mail.gmail.com> <10b8d7e649906b3bd8939e3db0056b39d9194a04.camel@gmail.com>
In-Reply-To: <10b8d7e649906b3bd8939e3db0056b39d9194a04.camel@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 15 Mar 2021 15:34:05 -0400
X-Gmail-Original-Message-ID: <CA+FuTSe3fjVzUqR-T8m7Ug2QypymgP_gkh1VQT2TzjdXDwORHg@mail.gmail.com>
Message-ID: <CA+FuTSe3fjVzUqR-T8m7Ug2QypymgP_gkh1VQT2TzjdXDwORHg@mail.gmail.com>
Subject: Re: [PATCH V4 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 3:10 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> On Mon, 2021-03-15 at 11:50 -0400, Willem de Bruijn wrote:
> > On Sun, Mar 14, 2021 at 12:50 PM Andreas Roeseler
> > <andreas.a.roeseler@gmail.com> wrote:
> > >
> > > Modify the icmp_rcv function to check PROBE messages and call
> > > icmp_echo
> > > if a PROBE request is detected.
> > >
> > > Modify the existing icmp_echo function to respond ot both ping and
> > > PROBE
> > > requests.
> > >
> > > This was tested using a custom modification to the iputils package
> > > and
> > > wireshark. It supports IPV4 probing by name, ifindex, and probing
> > > by
> > > both IPV4 and IPV6 addresses. It currently does not support
> > > responding
> > > to probes off the proxy node (see RFC 8335 Section 2).
> >
> > If you happen to use github or something similar, if you don't mind
> > sharing the code, you could clone the iputils repo and publish the
> > changes. No pressure.
>
> Should I include the link to the github repo in the patch?

If you don't mind, please do. It can serve as example for others to
use the feature, too.

>
> >
> > >  net/ipv4/icmp.c | 145 +++++++++++++++++++++++++++++++++++++++++++-
> > > ----
> > >  1 file changed, 130 insertions(+), 15 deletions(-)
> > >
> > > diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> > > index 616e2dc1c8fa..f1530011b7bc 100644
> > > --- a/net/ipv4/icmp.c
> > > +++ b/net/ipv4/icmp.c
> > > @@ -93,6 +93,10 @@
> > >  #include <net/ip_fib.h>
> > >  #include <net/l3mdev.h>
> > >
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +#include <net/addrconf.h>
> > > +#endif
> >
> > I don't think the conditional is needed (?)
> >
> > >  static bool icmp_echo(struct sk_buff *skb)
> > >  {
> > > +       struct icmp_ext_hdr *ext_hdr, _ext_hdr;
> > > +       struct icmp_ext_echo_iio *iio, _iio;
> > > +       struct icmp_bxm icmp_param;
> > > +       struct net_device *dev;
> > >         struct net *net;
> > > +       u16 ident_len;
> > > +       char *buff;
> > > +       u8 status;
> > >
> > >         net = dev_net(skb_dst(skb)->dev);
> > > -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> > > -               struct icmp_bxm icmp_param;
> > > -
> > > -               icmp_param.data.icmph      = *icmp_hdr(skb);
> > > -               icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> > > -               icmp_param.skb             = skb;
> > > -               icmp_param.offset          = 0;
> > > -               icmp_param.data_len        = skb->len;
> > > -               icmp_param.head_len        = sizeof(struct
> > > icmphdr);
> > > -               icmp_reply(&icmp_param, skb);
> > > -       }
> > >         /* should there be an ICMP stat for ignored echos? */
> > > -       return true;
> > > +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> > > +               return true;
> > > +
> > > +       icmp_param.data.icmph      = *icmp_hdr(skb);
> > > +       icmp_param.skb             = skb;
> > > +       icmp_param.offset          = 0;
> > > +       icmp_param.data_len        = skb->len;
> > > +       icmp_param.head_len        = sizeof(struct icmphdr);
> > > +
> > > +       if (icmp_param.data.icmph.type == ICMP_ECHO)
> > > +               goto send_reply;
> >
> > Is this path now missing
> >
> >                icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> >
> > > +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> > > +               return true;
> > > +       /* We currently only support probing interfaces on the
> > > proxy node
> > > +        * Check to ensure L-bit is set
> > > +        */
> > > +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> > > +               return true;
> > > +       /* Clear status bits in reply message */
> > > +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> > > +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> > > +       ext_hdr = skb_header_pointer(skb, 0, sizeof(_ext_hdr),
> > > &_ext_hdr);
> > > +       iio = skb_header_pointer(skb, sizeof(_ext_hdr),
> > > sizeof(_iio), &_iio);
> > > +       if (!ext_hdr || !iio)
> > > +               goto send_mal_query;
> > > +       if (ntohs(iio->extobj_hdr.length) <= sizeof(iio-
> > > >extobj_hdr))
> > > +               goto send_mal_query;
> > > +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio-
> > > >extobj_hdr);
> > > +       status = 0;
> > > +       dev = NULL;
> > > +       switch (iio->extobj_hdr.class_type) {
> > > +       case EXT_ECHO_CTYPE_NAME:
> > > +               if (ident_len >= IFNAMSIZ)
> > > +                       goto send_mal_query;
> > > +               buff = kcalloc(IFNAMSIZ, sizeof(char), GFP_KERNEL);
> > > +               if (!buff)
> > > +                       return -ENOMEM;
> > > +               memcpy(buff, &iio->ident.name, ident_len);
> > > +               /* RFC 8335 2.1 If the Object Payload would not
> > > otherwise terminate
> > > +                * on a 32-bit boundary, it MUST be padded with
> > > ASCII NULL characters
> > > +                */
> > > +               if (ident_len % sizeof(u32) != 0) {
> > > +                       u8 i;
> > > +
> > > +                       for (i = ident_len; i % sizeof(u32) != 0;
> > > i++) {
> > > +                               if (buff[i] != '\0')
> > > +                                       goto send_mal_query;
> >
> > Memory leak. IFNAMSIZ is small enough that you can use on-stack
> > allocation
> >
> > Also, I think you can ignore if there are non-zero bytes beyond the
> > len. We need to safely parse to avoid integrity bugs in the kernel.
> > Beyond that, it's fine to be strict about what you send, liberal what
> > you accept.
>
> This checks that the incoming request is padded to the nearest 32-bit
> boundary by ASCII NULL characters, as specified by RFC 8335

Right. The question is whether you need to be strict in enforcing
that. Perhaps the RFC states that explicitly. Else, it's up to your
interpretation. I suggested the robustness principle, which is
commonly employed in such instances.

> >
> > > +                       }
> > > +               }
> > > +               dev = dev_get_by_name(net, buff);
> > > +               kfree(buff);
> > > +               break;
> > > +       case EXT_ECHO_CTYPE_INDEX:
> > > +               if (ident_len != sizeof(iio->ident.ifindex))
> > > +                       goto send_mal_query;
> > > +               dev = dev_get_by_index(net, ntohl(iio-
> > > >ident.ifindex));
> > > +               break;
> > > +       case EXT_ECHO_CTYPE_ADDR:
> > > +               if (ident_len != sizeof(iio->ident.addr.ctype3_hdr)
> > > + iio->ident.addr.ctype3_hdr.addrlen)
> > > +                       goto send_mal_query;
> > > +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> > > +               case ICMP_AFI_IP:
> > > +                       if (ident_len != sizeof(iio-
> > > >ident.addr.ctype3_hdr) + sizeof(struct in_addr))
> > > +                               goto send_mal_query;
> > > +                       dev = ip_dev_find(net, iio-
> > > >ident.addr.ip_addr.ipv4_addr.s_addr);
> > > +                       break;
> > > +#if IS_ENABLED(CONFIG_IPV6)
> > > +               case ICMP_AFI_IP6:
> > > +                       if (ident_len != sizeof(iio-
> > > >ident.addr.ctype3_hdr) + sizeof(struct in6_addr))
> > > +                               goto send_mal_query;
> > > +                       rcu_read_lock();
> > > +                       dev = ipv6_dev_find(net, &iio-
> > > >ident.addr.ip_addr.ipv6_addr, dev);
> > > +                       if (dev)
> > > +                               dev_hold(dev);
> > > +                       rcu_read_unlock();
> > > +                       break;
> > > +#endif
> > > +               default:
> > > +                       goto send_mal_query;
> > > +               }
> > > +               break;
> > > +       default:
> > > +               goto send_mal_query;
> > > +       }
> > > +       if (!dev) {
> > > +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> > > +               goto send_reply;
> > > +       }
> > > +       /* Fill bits in reply message */
> > > +       if (dev->flags & IFF_UP)
> > > +               status |= EXT_ECHOREPLY_ACTIVE;
> > > +       if (__in_dev_get_rcu(dev) && __in_dev_get_rcu(dev)-
> > > >ifa_list)
> > > +               status |= EXT_ECHOREPLY_IPV4;
> > > +       if (!list_empty(&dev->ip6_ptr->addr_list))
> > > +               status |= EXT_ECHOREPLY_IPV6;
> > > +       dev_put(dev);
> > > +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> > > +send_reply:
> > > +       icmp_reply(&icmp_param, skb);
> > > +               return true;
> > > +send_mal_query:
> > > +       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> > > +       goto send_reply;
> > >  }
> > >
> > >  /*
> > > @@ -1088,6 +1192,11 @@ int icmp_rcv(struct sk_buff *skb)
> > >         icmph = icmp_hdr(skb);
> > >
> > >         ICMPMSGIN_INC_STATS(net, icmph->type);
> > > +
> > > +       /* Check for ICMP Extended Echo (PROBE) messages */
> > > +       if (icmph->type == ICMP_EXT_ECHO)
> > > +               goto probe;
> > > +
> > >         /*
> > >          *      18 is the highest 'known' ICMP type. Anything else
> > > is a mystery
> > >          *
> > > @@ -1097,7 +1206,6 @@ int icmp_rcv(struct sk_buff *skb)
> > >         if (icmph->type > NR_ICMP_TYPES)
> > >                 goto error;
> > >
> > > -
> > >         /*
> > >          *      Parse the ICMP message
> > >          */
> > > @@ -1123,7 +1231,7 @@ int icmp_rcv(struct sk_buff *skb)
> > >         }
> > >
> > >         success = icmp_pointers[icmph->type].handler(skb);
> > > -
> > > +success_check:
> > >         if (success)  {
> > >                 consume_skb(skb);
> > >                 return NET_RX_SUCCESS;
> > > @@ -1137,6 +1245,12 @@ int icmp_rcv(struct sk_buff *skb)
> > >  error:
> > >         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
> > >         goto drop;
> > > +probe:
> > > +       /* We can't use icmp_pointers[].handler() because it is an
> > > array of
> > > +        * size NR_ICMP_TYPES + 1 (19 elements) and PROBE has code
> > > 42.
> > > +        */
> > > +       success = icmp_echo(skb);
> > > +       goto success_check;
> >
> > just make this a branch instead of
>
> Could you clarify this comment? Do you mean move this code to the
> section where we check for PROBE messages instead of jumping to probe
> and then jumping to success_check?

Exactly
