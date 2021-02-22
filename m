Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4B7321012
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 05:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbhBVEuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Feb 2021 23:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbhBVEuf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Feb 2021 23:50:35 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2685FC061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:49:55 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id r17so717326ejy.13
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yu57BeH6Uobdx2sasfHMHwxNy/NhOWYq2yVTCwLkl7g=;
        b=lxL2Fw1ZRSSs/FlbVi5a51apQ1RJ2nYISADLJHgWIYoHv6YZzTF1BstsHU/s7L9dCI
         3MhdvYfuJj9OLhEjhlznRiz+KPO1KnlMufn/O3eiKeAWuFlznDR/09AUqKgAxZ1AbwcI
         3fiUguXcNS72vshRaOnltD6RDMiXt0wGaxpokMn+F16+iOTnIyCadY0Jp5H25MzonWI0
         rOPAqcBzeFtyFN4pHK2RQuayY3lO2sFBjdrjaz+AhMWzyU7mQ3cW8dYZJ8SF/DsKJ+jv
         yRCyX1GK8VJEO0za8KdUwzKAqGwhzgvEqB59ExdJ1r2/mf2m32MdEu2HT9tZ7t+L0u6K
         8CVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yu57BeH6Uobdx2sasfHMHwxNy/NhOWYq2yVTCwLkl7g=;
        b=GJ1gVkmzk6BkSbwHCnjPhUd5e9YJouE2K07+G9c+TkzatpKZoVbqFcd5tTNcYSOlio
         xfVohKFu65xPMVYqCaT8iBt2wix57CL9F+zQZXsqI9pJTkz8gYIzEolqOadzVzI0kwMq
         e3hj7HdANjsl+UwMvAtv9vhor+nkv+ebpHgdg7MrJZnp3SsSqF2XlC8Ca077tUA1BVYV
         IGGBvV/jPvGxEKSqzeDHw4GBtFZsumxH1iq1BeMUI5BKLmblYY5wDIT9RwYa9D51no4B
         JaCzT2dohs9vrVWiOhn3T9nVUUvPKW3J0xSRraR0ui8YrOy92hDIAI3sdeg5Z6G3WeS8
         VLbA==
X-Gm-Message-State: AOAM531m2kumB77jrqQFrjdWooOQCMgZP9IbdEmGxSRcJlkF2vLl3DTD
        WAO/xjfSoAtqzPXwzgMumcBWL6NIga8=
X-Google-Smtp-Source: ABdhPJyD7AkkxjabdqIaLX6EQPNKlO3BOVJLQFSaXcLHfa2K5rt/OzuVBzOOSCuN50YdJUTA8+B+rw==
X-Received: by 2002:a17:906:18aa:: with SMTP id c10mr18318064ejf.248.1613969393637;
        Sun, 21 Feb 2021 20:49:53 -0800 (PST)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id 35sm11034845edp.85.2021.02.21.20.49.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 20:49:53 -0800 (PST)
Received: by mail-wm1-f52.google.com with SMTP id n10so13154042wmq.0
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 20:49:53 -0800 (PST)
X-Received: by 2002:a1c:dd09:: with SMTP id u9mr16521077wmg.183.1613969392790;
 Sun, 21 Feb 2021 20:49:52 -0800 (PST)
MIME-Version: 1.0
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com> <7bff18c2cffe77b2ea66fd8774a5d0374ff6dd97.1613583620.git.andreas.a.roeseler@gmail.com>
In-Reply-To: <7bff18c2cffe77b2ea66fd8774a5d0374ff6dd97.1613583620.git.andreas.a.roeseler@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 21 Feb 2021 23:49:13 -0500
X-Gmail-Original-Message-ID: <CA+FuTSeo5uqtU0b0AP5hm9C72qN8PdT4C-fV2YTun33YbX9Ssg@mail.gmail.com>
Message-ID: <CA+FuTSeo5uqtU0b0AP5hm9C72qN8PdT4C-fV2YTun33YbX9Ssg@mail.gmail.com>
Subject: Re: [PATCH V3 net-next 5/5] icmp: add response to RFC 8335 PROBE messages
To:     Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 17, 2021 at 1:14 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
>
> Modify the icmp_rcv function to check for PROBE messages and call
> icmp_echo if a PROBE request is detected.
>
> Modify the existing icmp_echo function to respond to both ping and PROBE
> requests.
>
> This was tested using a custom modification of the iputils package and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by both IPV4 and IPV6
> addresses. It currently does not support responding to probes off the proxy node
> (See RFC 8335 Section 2).
>
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Reorder variable declarations to follow coding style
>  - Switch to functions such as dev_get_by_name and ip_dev_find to lookup
>    net devices
>
> Changes since v2:
> Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
>  - Add verification of incoming messages before looking up netdev
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>  - Include net/addrconf.h library for ipv6_dev_find
> ---
>  net/ipv4/icmp.c | 133 ++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 122 insertions(+), 11 deletions(-)
>
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 396b492c804f..3caca9f2aa07 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -92,6 +92,7 @@
>  #include <net/inet_common.h>
>  #include <net/ip_fib.h>
>  #include <net/l3mdev.h>
> +#include <net/addrconf.h>
>
>  /*
>   *     Build xmit assembly blocks
> @@ -970,7 +971,7 @@ static bool icmp_redirect(struct sk_buff *skb)
>  }
>
>  /*
> - *     Handle ICMP_ECHO ("ping") requests.
> + *     Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE") requests.
>   *
>   *     RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP echo
>   *               requests.
> @@ -978,26 +979,122 @@ static bool icmp_redirect(struct sk_buff *skb)
>   *               included in the reply.
>   *     RFC 1812: 4.3.3.6 SHOULD have a config option for silently ignoring
>   *               echo requests, MUST have default=NOT.
> + *     RFC 8335: 8 MUST have a config option to enable/disable ICMP
> + *               Extended Echo functionality, MUST be disabled by default
>   *     See also WRT handling of options once they are done and working.
>   */
>
>  static bool icmp_echo(struct sk_buff *skb)
>  {
> +       struct icmp_ext_echo_iio *iio;
> +       struct icmp_ext_hdr *ext_hdr;
> +       struct icmp_bxm icmp_param;
> +       struct net_device *dev;
>         struct net *net;
> +       __u16 ident_len;
> +       __u8 status;

no need for underscore variants.

> +       char *buff;
>
>         net = dev_net(skb_dst(skb)->dev);
> -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -               struct icmp_bxm icmp_param;
> +       /* should there be an ICMP stat for ignored echos? */
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
>
> -               icmp_param.data.icmph      = *icmp_hdr(skb);
> +       icmp_param.data.icmph           = *icmp_hdr(skb);
> +       icmp_param.skb                  = skb;
> +       icmp_param.offset               = 0;
> +       icmp_param.data_len             = skb->len;
> +       icmp_param.head_len             = sizeof(struct icmphdr);
> +       if (icmp_param.data.icmph.type == ICMP_ECHO) {
>                 icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -               icmp_param.skb             = skb;
> -               icmp_param.offset          = 0;
> -               icmp_param.data_len        = skb->len;
> -               icmp_param.head_len        = sizeof(struct icmphdr);
> -               icmp_reply(&icmp_param, skb);
> +               goto send_reply;
>         }
> -       /* should there be an ICMP stat for ignored echos? */
> +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +               return true;
> +       /* We currently only support probing interfaces on the proxy node
> +        * Check to ensure L-bit is set
> +        */
> +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> +               return true;
> +
> +       /* Clear status bits in reply message */
> +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       ext_hdr = (struct icmp_ext_hdr *)(icmp_hdr(skb) + 1);
> +       iio = (struct icmp_ext_echo_iio *)(ext_hdr + 1);

Check that these fields exist (skb is not truncated).
skb_header_pointer is the safest approach.

For this and following point, see also ip_icmp_error_rfc4884_validate.

> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio->extobj_hdr);

Negative overflow: cannot trust that extobj_hdr.length >=
sizeof(iio->extobj_hdr)

> +       status = 0;
> +       dev = NULL;
> +       switch (iio->extobj_hdr.class_type) {
> +       case EXT_ECHO_CTYPE_NAME:
> +               if (ident_len >= skb->len - sizeof(struct icmphdr) - sizeof(iio->extobj_hdr)) {

Also should check "If the Object Payload would not otherwise terminate
on a 32-bit boundary, it MUST be padded with ASCII NULL characters."

> +                       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               buff = kcalloc(ident_len + 1, sizeof(char), GFP_KERNEL);

Can statically allocate on stack using IFNAMSIZ. Any ident_len > that
is wrong, anyway.

> +               if (!buff)
> +                       return -ENOMEM;
> +               memcpy(buff, &iio->ident.name, ident_len);
> +               dev = dev_get_by_name(net, buff);
> +               kfree(buff);
> +               break;
> +       case EXT_ECHO_CTYPE_INDEX:
> +               if (ident_len != sizeof(iio->ident.ifIndex)) {

this checks that length is 4B, but RFC says "If the Interface
Identification Object identifies the probed interface by index, the
length is equal to 8 and the payload contains the if-index"
> +                       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               dev = dev_get_by_index(net, ntohl(iio->ident.ifIndex));
> +               break;
> +       case EXT_ECHO_CTYPE_ADDR:
> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> +               case EXT_ECHO_AFI_IP:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(__be32) ||
> +                           ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
> +                               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                               goto send_reply;
> +                       }
> +                       dev = ip_dev_find(net, iio->ident.addr.ip_addr.ipv4_addr);
> +                       break;
> +               case EXT_ECHO_AFI_IP6:
> +                       if (ident_len != sizeof(iio->ident.addr.ctype3_hdr) + sizeof(struct in6_addr) ||
> +                           ident_len != sizeof(iio->ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
> +                               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                               goto send_reply;
> +                       }
> +                       dev = ipv6_dev_find(net, &iio->ident.addr.ip_addr.ipv6_addr, dev);

From function comment: "The caller should be protected by RCU, or
RTNL.". Is that the case here?

Also dependent on CONFIG_IPV6

> +                       if (dev)
> +                               dev_hold(dev);
> +                       break;
> +               default:
> +                       icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               break;
> +       default:
> +               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +               goto send_reply;
> +       }
> +       if (!dev) {
> +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> +               goto send_reply;
> +       }
> +       /* RFC 8335: 3 the last 8 bits of the Extended Echo Reply Message
> +        *  are laid out as follows:
> +        *      +-+-+-+-+-+-+-+-+
> +        *      |State|Res|A|4|6|
> +        *      +-+-+-+-+-+-+-+-+
> +        */
> +       if (dev->flags & IFF_UP)
> +               status |= EXT_ECHOREPLY_ACTIVE;
> +       if (dev->ip_ptr->ifa_list)

This is an __rcu pointer, requires rcu_dereference, e.g., via __in_dev_get_rcu






> +               status |= EXT_ECHOREPLY_IPV4;
> +       if (!list_empty(&dev->ip6_ptr->addr_list))
> +               status |= EXT_ECHOREPLY_IPV6;
> +       dev_put(dev);
> +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> +
> +send_reply:
> +       icmp_reply(&icmp_param, skb);
>         return true;
>  }
>
> @@ -1087,6 +1184,13 @@ int icmp_rcv(struct sk_buff *skb)
>         icmph = icmp_hdr(skb);
>
>         ICMPMSGIN_INC_STATS(net, icmph->type);
> +
> +       /*
> +        *      Check for ICMP Extended Echo (PROBE) messages
> +        */
> +       if (icmph->type == ICMP_EXT_ECHO || icmph->type == ICMPV6_EXT_ECHO_REQUEST)
> +               goto probe;
> +
>         /*
>          *      18 is the highest 'known' ICMP type. Anything else is a mystery
>          *
> @@ -1096,7 +1200,6 @@ int icmp_rcv(struct sk_buff *skb)
>         if (icmph->type > NR_ICMP_TYPES)
>                 goto error;
>
> -
>         /*
>          *      Parse the ICMP message
>          */
> @@ -1123,6 +1226,7 @@ int icmp_rcv(struct sk_buff *skb)
>
>         success = icmp_pointers[icmph->type].handler(skb);
>
> +success_check:
>         if (success)  {
>                 consume_skb(skb);
>                 return NET_RX_SUCCESS;
> @@ -1136,6 +1240,13 @@ int icmp_rcv(struct sk_buff *skb)
>  error:
>         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
>         goto drop;
> +probe:
> +       /*
> +        * We can't use icmp_pointers[].handler() because the codes for PROBE
> +        *   messages are 42 or 160
> +        */

ICMPv6 message 160 (ICMPV6_EXT_ECHO_REQUEST) must be handled in
icmpv6_rcv, not icmp_rcv. Then the ICMPv4 message 42 can be handled in
the usual way.


> +       success = icmp_echo(skb);
> +       goto success_check;
>  }
>
>  static bool ip_icmp_error_rfc4884_validate(const struct sk_buff *skb, int off)
> --
> 2.25.1
>
