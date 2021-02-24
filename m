Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21F05324771
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 00:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236212AbhBXXVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 18:21:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbhBXXVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 18:21:02 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39849C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:20:22 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id h4so2507887pgf.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 15:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8muKIW23K/dddVeaZw1IXM0ikdaJSNj4LJzIYBJWj+w=;
        b=FLJm0k/9JlmdbqwP84pLNzTqgA6388OVrN2ZXeKkNECXTxVzyahRzhfp1lQJJgpHY/
         uI8fGO95KCUhpzrOcagkRad7x9pt6H2FRJ0SHrZcbojZOYM0dQLjNRPRBGWlBIq6gKgz
         /Wc8idXEj+kLpa+Xh84Duw4x29iS4cD8eC2d50ju/Fhi93F3iz3iejHg2gcezdmRhFug
         6aqVVQZh+I9lzipYhX/ZFzDCXQPN05rT7xCTr8/o6dpVDVvk2DoG1fD7OqbT3vtYzNy0
         d0Kk6tg7ZJrfarWBry0rKJ84NJ07sguOdNCWoTEez2vEp+XxfZu3vLLwo3WusXnJ0eWu
         jsiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8muKIW23K/dddVeaZw1IXM0ikdaJSNj4LJzIYBJWj+w=;
        b=mSL5uy01y8DAma/NMWAdcdt77JGLIRPT/dGkgXSWhMFUgFEDIe/u5gZii92NXn3YzN
         ns88zYDd07a0lGWpMPvEzKeRgKWmtJfQn038y2Xvw/ApTE9qiW3Ho1bMebIDtKPCYk/p
         L9z5FvKizo3zbFNz2u50T27OU99yObif3ZCk1hKvJR17/r37lvuq4cWWa3PB0QAVWxJz
         7XCW+mvELi0ug4WXYgx8Z1J9SroKnRTRWMf1VVpkzIUQ4AdUCjUo2eLzjofEVjvW4jqq
         SDqQTGTyDFGM5OkE0BILwyBc87wohOo3ZUB6nBwSC3l8Vbq+mIIptzj3xsu8VlnyHKaR
         fpVA==
X-Gm-Message-State: AOAM531D84zQy9hOkZd/ySgyJ4ldBCYgshqujo+oGECvG+H1kDPKOT6I
        mxmIj9bEj7DcPpCick/m8IE=
X-Google-Smtp-Source: ABdhPJxpSnaKS/ncZ1C3czK1Ms/wTrVOzHb/t8+MTneJM/Q6baMYD9CztWzgf1/y0P2AYhOi+oFK9A==
X-Received: by 2002:a65:5bc5:: with SMTP id o5mr263139pgr.17.1614208821691;
        Wed, 24 Feb 2021 15:20:21 -0800 (PST)
Received: from aroeseler-ly545.local (h134-215-166-75.lapior.broadband.dynamic.tds.net. [134.215.166.75])
        by smtp.gmail.com with ESMTPSA id v26sm3758546pff.195.2021.02.24.15.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 15:20:21 -0800 (PST)
Message-ID: <ba994c253956420744cbbf06f77af09b580a98d3.camel@gmail.com>
Subject: Re: [PATCH V3 net-next 5/5] icmp: add response to RFC 8335 PROBE
 messages
From:   Andreas Roeseler <andreas.a.roeseler@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date:   Wed, 24 Feb 2021 17:20:20 -0600
In-Reply-To: <CA+FuTSeo5uqtU0b0AP5hm9C72qN8PdT4C-fV2YTun33YbX9Ssg@mail.gmail.com>
References: <cover.1613583620.git.andreas.a.roeseler@gmail.com>
         <7bff18c2cffe77b2ea66fd8774a5d0374ff6dd97.1613583620.git.andreas.a.roeseler@gmail.com>
         <CA+FuTSeo5uqtU0b0AP5hm9C72qN8PdT4C-fV2YTun33YbX9Ssg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 2021-02-21 at 23:49 -0500, Willem de Bruijn wrote:
On Wed, Feb 17, 2021 at 1:14 PM Andreas Roeseler
<andreas.a.roeseler@gmail.com> wrote:
> 
> Modify the icmp_rcv function to check for PROBE messages and call
> icmp_echo if a PROBE request is detected.
> 
> Modify the existing icmp_echo function to respond to both ping and
> PROBE
> requests.
> 
> This was tested using a custom modification of the iputils package
> and
> wireshark. It supports IPV4 probing by name, ifindex, and probing by
> both IPV4 and IPV6
> addresses. It currently does not support responding to probes off the
> proxy node
> (See RFC 8335 Section 2).
> 
> Signed-off-by: Andreas Roeseler <andreas.a.roeseler@gmail.com>
> ---
> Changes since v1:
>  - Reorder variable declarations to follow coding style
>  - Switch to functions such as dev_get_by_name and ip_dev_find to
> lookup
>    net devices
> 
> Changes since v2:
> Suggested by Willem de Brujin <willemdebrujin.kernel@gmail.com>
>  - Add verification of incoming messages before looking up netdev
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>  - Include net/addrconf.h library for ipv6_dev_find
> ---
>  net/ipv4/icmp.c | 133 ++++++++++++++++++++++++++++++++++++++++++++--
> --
>  1 file changed, 122 insertions(+), 11 deletions(-)
> 
> diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
> index 396b492c804f..3caca9f2aa07 100644
> --- a/net/ipv4/icmp.c
> +++ b/net/ipv4/icmp.c
> @@ -92,6 +92,7 @@
>  #include <net/inet_common.h>
>  #include <net/ip_fib.h>
>  #include <net/l3mdev.h>
> +#include <net/addrconf.h>
> 
>  /*
>   *     Build xmit assembly blocks
> @@ -970,7 +971,7 @@ static bool icmp_redirect(struct sk_buff *skb)
>  }
> 
>  /*
> - *     Handle ICMP_ECHO ("ping") requests.
> + *     Handle ICMP_ECHO ("ping") and ICMP_EXT_ECHO ("PROBE")
> requests.
>   *
>   *     RFC 1122: 3.2.2.6 MUST have an echo server that answers ICMP
> echo
>   *               requests.
> @@ -978,26 +979,122 @@ static bool icmp_redirect(struct sk_buff *skb)
>   *               included in the reply.
>   *     RFC 1812: 4.3.3.6 SHOULD have a config option for silently
> ignoring
>   *               echo requests, MUST have default=NOT.
> + *     RFC 8335: 8 MUST have a config option to enable/disable ICMP
> + *               Extended Echo functionality, MUST be disabled by
> default
>   *     See also WRT handling of options once they are done and
> working.
>   */
> 
>  static bool icmp_echo(struct sk_buff *skb)
>  {
> +       struct icmp_ext_echo_iio *iio;
> +       struct icmp_ext_hdr *ext_hdr;
> +       struct icmp_bxm icmp_param;
> +       struct net_device *dev;
>         struct net *net;
> +       __u16 ident_len;
> +       __u8 status;

no need for underscore variants.

> +       char *buff;
> 
>         net = dev_net(skb_dst(skb)->dev);
> -       if (!net->ipv4.sysctl_icmp_echo_ignore_all) {
> -               struct icmp_bxm icmp_param;
> +       /* should there be an ICMP stat for ignored echos? */
> +       if (net->ipv4.sysctl_icmp_echo_ignore_all)
> +               return true;
> 
> -               icmp_param.data.icmph      = *icmp_hdr(skb);
> +       icmp_param.data.icmph           = *icmp_hdr(skb);
> +       icmp_param.skb                  = skb;
> +       icmp_param.offset               = 0;
> +       icmp_param.data_len             = skb->len;
> +       icmp_param.head_len             = sizeof(struct icmphdr);
> +       if (icmp_param.data.icmph.type == ICMP_ECHO) {
>                 icmp_param.data.icmph.type = ICMP_ECHOREPLY;
> -               icmp_param.skb             = skb;
> -               icmp_param.offset          = 0;
> -               icmp_param.data_len        = skb->len;
> -               icmp_param.head_len        = sizeof(struct icmphdr);
> -               icmp_reply(&icmp_param, skb);
> +               goto send_reply;
>         }
> -       /* should there be an ICMP stat for ignored echos? */
> +       if (!net->ipv4.sysctl_icmp_echo_enable_probe)
> +               return true;
> +       /* We currently only support probing interfaces on the proxy
> node
> +        * Check to ensure L-bit is set
> +        */
> +       if (!(ntohs(icmp_param.data.icmph.un.echo.sequence) & 1))
> +               return true;
> +
> +       /* Clear status bits in reply message */
> +       icmp_param.data.icmph.un.echo.sequence &= htons(0xFF00);
> +       icmp_param.data.icmph.type = ICMP_EXT_ECHOREPLY;
> +       ext_hdr = (struct icmp_ext_hdr *)(icmp_hdr(skb) + 1);
> +       iio = (struct icmp_ext_echo_iio *)(ext_hdr + 1);

Check that these fields exist (skb is not truncated).
skb_header_pointer is the safest approach.

For this and following point, see also ip_icmp_error_rfc4884_validate.

> +       ident_len = ntohs(iio->extobj_hdr.length) - sizeof(iio-
> >extobj_hdr);

Negative overflow: cannot trust that extobj_hdr.length >=
sizeof(iio->extobj_hdr)

> +       status = 0;
> +       dev = NULL;
> +       switch (iio->extobj_hdr.class_type) {
> +       case EXT_ECHO_CTYPE_NAME:
> +               if (ident_len >= skb->len - sizeof(struct icmphdr) -
> sizeof(iio->extobj_hdr)) {

Also should check "If the Object Payload would not otherwise terminate
on a 32-bit boundary, it MUST be padded with ASCII NULL characters."

> +                       icmp_param.data.icmph.code =
> ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               buff = kcalloc(ident_len + 1, sizeof(char),
> GFP_KERNEL);

Can statically allocate on stack using IFNAMSIZ. Any ident_len > that
is wrong, anyway.

> +               if (!buff)
> +                       return -ENOMEM;
> +               memcpy(buff, &iio->ident.name, ident_len);
> +               dev = dev_get_by_name(net, buff);
> +               kfree(buff);
> +               break;
> +       case EXT_ECHO_CTYPE_INDEX:
> +               if (ident_len != sizeof(iio->ident.ifIndex)) {

this checks that length is 4B, but RFC says "If the Interface
Identification Object identifies the probed interface by index, the
length is equal to 8 and the payload contains the if-index"

ident_len stores the value of the identifier of the interface only,
i.e. it stores the length of the iio minus the length of the iio
header. Therefore, we can check its size against the expected size of
an if_Index (4 octets)

> +                       icmp_param.data.icmph.code =
> ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               dev = dev_get_by_index(net, ntohl(iio-
> >ident.ifIndex));
> +               break;
> +       case EXT_ECHO_CTYPE_ADDR:
> +               switch (ntohs(iio->ident.addr.ctype3_hdr.afi)) {
> +               case EXT_ECHO_AFI_IP:
> +                       if (ident_len != sizeof(iio-
> >ident.addr.ctype3_hdr) + sizeof(__be32) ||
> +                           ident_len != sizeof(iio-
> >ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
> +                               icmp_param.data.icmph.code =
> ICMP_EXT_MAL_QUERY;
> +                               goto send_reply;
> +                       }
> +                       dev = ip_dev_find(net, iio-
> >ident.addr.ip_addr.ipv4_addr);
> +                       break;
> +               case EXT_ECHO_AFI_IP6:
> +                       if (ident_len != sizeof(iio-
> >ident.addr.ctype3_hdr) + sizeof(struct in6_addr) ||
> +                           ident_len != sizeof(iio-
> >ident.addr.ctype3_hdr) + iio->ident.addr.ctype3_hdr.addrlen) {
> +                               icmp_param.data.icmph.code =
> ICMP_EXT_MAL_QUERY;
> +                               goto send_reply;
> +                       }
> +                       dev = ipv6_dev_find(net, &iio-
> >ident.addr.ip_addr.ipv6_addr, dev);

From function comment: "The caller should be protected by RCU, or
RTNL.". Is that the case here?

Also dependent on CONFIG_IPV6

> +                       if (dev)
> +                               dev_hold(dev);
> +                       break;
> +               default:
> +                       icmp_param.data.icmph.code =
> ICMP_EXT_MAL_QUERY;
> +                       goto send_reply;
> +               }
> +               break;
> +       default:
> +               icmp_param.data.icmph.code = ICMP_EXT_MAL_QUERY;
> +               goto send_reply;
> +       }
> +       if (!dev) {
> +               icmp_param.data.icmph.code = ICMP_EXT_NO_IF;
> +               goto send_reply;
> +       }
> +       /* RFC 8335: 3 the last 8 bits of the Extended Echo Reply
> Message
> +        *  are laid out as follows:
> +        *      +-+-+-+-+-+-+-+-+
> +        *      |State|Res|A|4|6|
> +        *      +-+-+-+-+-+-+-+-+
> +        */
> +       if (dev->flags & IFF_UP)
> +               status |= EXT_ECHOREPLY_ACTIVE;
> +       if (dev->ip_ptr->ifa_list)

This is an __rcu pointer, requires rcu_dereference, e.g., via
__in_dev_get_rcu






> +               status |= EXT_ECHOREPLY_IPV4;
> +       if (!list_empty(&dev->ip6_ptr->addr_list))
> +               status |= EXT_ECHOREPLY_IPV6;
> +       dev_put(dev);
> +       icmp_param.data.icmph.un.echo.sequence |= htons(status);
> +
> +send_reply:
> +       icmp_reply(&icmp_param, skb);
>         return true;
>  }
> 
> @@ -1087,6 +1184,13 @@ int icmp_rcv(struct sk_buff *skb)
>         icmph = icmp_hdr(skb);
> 
>         ICMPMSGIN_INC_STATS(net, icmph->type);
> +
> +       /*
> +        *      Check for ICMP Extended Echo (PROBE) messages
> +        */
> +       if (icmph->type == ICMP_EXT_ECHO || icmph->type ==
> ICMPV6_EXT_ECHO_REQUEST)
> +               goto probe;
> +
>         /*
>          *      18 is the highest 'known' ICMP type. Anything else is
> a mystery
>          *
> @@ -1096,7 +1200,6 @@ int icmp_rcv(struct sk_buff *skb)
>         if (icmph->type > NR_ICMP_TYPES)
>                 goto error;
> 
> -
>         /*
>          *      Parse the ICMP message
>          */
> @@ -1123,6 +1226,7 @@ int icmp_rcv(struct sk_buff *skb)
> 
>         success = icmp_pointers[icmph->type].handler(skb);
> 
> +success_check:
>         if (success)  {
>                 consume_skb(skb);
>                 return NET_RX_SUCCESS;
> @@ -1136,6 +1240,13 @@ int icmp_rcv(struct sk_buff *skb)
>  error:
>         __ICMP_INC_STATS(net, ICMP_MIB_INERRORS);
>         goto drop;
> +probe:
> +       /*
> +        * We can't use icmp_pointers[].handler() because the codes
> for PROBE
> +        *   messages are 42 or 160
> +        */

ICMPv6 message 160 (ICMPV6_EXT_ECHO_REQUEST) must be handled in
icmpv6_rcv, not icmp_rcv. Then the ICMPv4 message 42 can be handled in
the usual way.


You are correct that we should handle ICMPV6_EXT_ECHO_REQUEST in the
icmpv6.c file, but shouldn't we still have a special handler for the
ICMPv4 message? The current icmp_pointers[].handler is an array of size
NR_ICMP_TYPES + 1 (or 19 elements), so I don't think it would be a good
idea to extend it to 42.


> +       success = icmp_echo(skb);
> +       goto success_check;
>  }
> 
>  static bool ip_icmp_error_rfc4884_validate(const struct sk_buff
> *skb, int off)
> --
> 2.25.1
> 


