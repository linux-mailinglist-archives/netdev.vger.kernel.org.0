Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4225D1C042C
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:50:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgD3Ruq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:50:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Rup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:50:45 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30715C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:50:44 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id f12so5216210edn.12
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=whtxuoRU8P6bc4BdBUwpA9voDMm0T12yCF61V33vBjU=;
        b=dUOiGRVGQgrmO+U5tVBX+V/CV7NBtCIEbFD7Rj7J9i896UvdIZaTLoEY56TnFUlPwZ
         +kRhPYCUkaNmQrzuUxnBoa3Z48TvZ1iDdYrbOzw4/H5AM/Az/3z2GNBqkQarbNSKYuYZ
         TfhSZuGe1vQbRrUzILQx09Uyrwq0RuOai1po/a+H1Kl3rwT+L0uFqGUm5AqY9lPNAGcW
         u9+o9TaK6OlY9G0TTE6bXD8xsiG7WwXQ8CZi7esFjUnXP4cXSVR2lFv152cRHKjMG5XO
         LEMfxHLwQBqdkyS8p7oUKiTx4yRKlPIq5kNLZzc5HxkqbA6J5AhsdRa6ta4WnpzO8+H6
         wGdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=whtxuoRU8P6bc4BdBUwpA9voDMm0T12yCF61V33vBjU=;
        b=EXRs6FYoShvwETDHxHjH0kYGyhs5EXRohDCiCBaDwlTwCfCIfJySaRUfkSYRE/NLfV
         bDThbp+QDxUG0eIVwL2jkjO7xhSyjXvY/0Qb1N3NGNStq+uh6SwyBBtgD1xbHvzesp7v
         mVxSPL+1iUk+CcCx7m2K//DpURCZ0n/JMWq+hTddi18fUOmnqOWhTlSleZ5WNttTpg45
         hB5X4ni+7RyiOVb0D5QR7mJX0HswpH7vLuNK/oYgormjJAGMKwqN+Zvs7Q4eFUfsf2b0
         jI3UPVMlbgmWxAJWMAxM1hhx4cK6QsBK7D8WdMD5aqK4+egZRAUku62Maka2dja8sHVP
         N9wA==
X-Gm-Message-State: AGi0PuZ5ruXSupS2ykKqrk916nEaqTsXbDdwTLHZv1xG/f1EMJijcnk8
        qDaoCGUeW7GFsDBbtpPMoh53u4lKSxpEQ/ZDSnI=
X-Google-Smtp-Source: APiQypI6yjjYD7C5bPsklGGkv32kS0Q0Ay1E9NBsFH9eRJfDDxevUpdcHz+s37wkuY3dXn4rBD5i3HiOrbNzNra7t2Y=
X-Received: by 2002:aa7:df8d:: with SMTP id b13mr103272edy.145.1588269042820;
 Thu, 30 Apr 2020 10:50:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200429161952.17769-1-olteanv@gmail.com> <20200429161952.17769-2-olteanv@gmail.com>
 <6b1681a7-13e1-9aaa-f765-2a327fb27555@cumulusnetworks.com> <147e0ee1-75f9-4dba-aff5-f7b4a078cbae@cumulusnetworks.com>
In-Reply-To: <147e0ee1-75f9-4dba-aff5-f7b4a078cbae@cumulusnetworks.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 Apr 2020 20:50:31 +0300
Message-ID: <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/4] bridge: Allow enslaving DSA master network devices
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nikolay, Roopa,

On Wed, 29 Apr 2020 at 19:33, Nikolay Aleksandrov
<nikolay@cumulusnetworks.com> wrote:
>
> +CC Roopa
>
> On 29/04/2020 19:27, Nikolay Aleksandrov wrote:
> > On 29/04/2020 19:19, Vladimir Oltean wrote:
> >> From: Florian Fainelli <f.fainelli@gmail.com>
> >>
> >> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
> >> as bridge members") added a special check in br_if.c in order to check
> >> for a DSA master network device with a tagging protocol configured. This
> >> was done because back then, such devices, once enslaved in a bridge
> >> would become inoperative and would not pass DSA tagged traffic anymore
> >> due to br_handle_frame returning RX_HANDLER_CONSUMED.
> >>
> >> But right now we have valid use cases which do require bridging of DSA
> >> masters. One such example is when the DSA master ports are DSA switch
> >> ports themselves (in a disjoint tree setup). This should be completely
> >> equivalent, functionally speaking, from having multiple DSA switches
> >> hanging off of the ports of a switchdev driver. So we should allow the
> >> enslaving of DSA tagged master network devices.
> >>
> >> Make br_handle_frame() return RX_HANDLER_PASS in order to call into the
> >> DSA specific tagging protocol handlers, and lift the restriction from
> >> br_add_if.
> >>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> >> ---
> >>  net/bridge/br_if.c    | 4 +---
> >>  net/bridge/br_input.c | 4 +++-
> >>  2 files changed, 4 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> >> index ca685c0cdf95..e0fbdb855664 100644
> >> --- a/net/bridge/br_if.c
> >> +++ b/net/bridge/br_if.c
> >> @@ -18,7 +18,6 @@
> >>  #include <linux/rtnetlink.h>
> >>  #include <linux/if_ether.h>
> >>  #include <linux/slab.h>
> >> -#include <net/dsa.h>
> >>  #include <net/sock.h>
> >>  #include <linux/if_vlan.h>
> >>  #include <net/switchdev.h>
> >> @@ -571,8 +570,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
> >>       */
> >>      if ((dev->flags & IFF_LOOPBACK) ||
> >>          dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
> >> -        !is_valid_ether_addr(dev->dev_addr) ||
> >> -        netdev_uses_dsa(dev))
> >> +        !is_valid_ether_addr(dev->dev_addr))
> >>              return -EINVAL;
> >>
> >>      /* No bridging of bridges */
> >> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> >> index d5c34f36f0f4..396bc0c18cb5 100644
> >> --- a/net/bridge/br_input.c
> >> +++ b/net/bridge/br_input.c
> >> @@ -17,6 +17,7 @@
> >>  #endif
> >>  #include <linux/neighbour.h>
> >>  #include <net/arp.h>
> >> +#include <net/dsa.h>
> >>  #include <linux/export.h>
> >>  #include <linux/rculist.h>
> >>  #include "br_private.h"
> >> @@ -263,7 +264,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> >>      struct sk_buff *skb = *pskb;
> >>      const unsigned char *dest = eth_hdr(skb)->h_dest;
> >>
> >> -    if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
> >> +    if (unlikely(skb->pkt_type == PACKET_LOOPBACK) ||
> >> +        netdev_uses_dsa(skb->dev))
> >>              return RX_HANDLER_PASS;
> >>
> >>      if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
> >>
> >
> > Yet another test in fast-path for all packets.
> > Since br_handle_frame will not be executed at all for such devices I'd suggest
> > to look into a scheme that avoid installing rx_handler and thus prevents br_handle_frame
> > to be called in the frist place. In case that is not possible then we can discuss adding
> > one more test in fast-path.
> >
> > Actually you can just add a dummy rx_handler that simply returns RX_HANDLER_PASS for
> > these devices and keep rx_handler_data so all br_port_get_* will continue working.
> >
> > Thanks,
> >  Nik
> >

Actually both of those are problematic, since br_port_get_check_rcu
and br_port_get_check_rtnl check for the rx_handler pointer against
br_handle_frame.
Actually a plain old revert of 8db0a2ee2c63 works just fine for what I
need it to, not sure if there's any point in making this any more
complicated than that.
What do you think?

Thanks,
-Vladimir
