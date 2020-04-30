Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C0B1C0436
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgD3RzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726285AbgD3Ry7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 13:54:59 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099C8C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:54:59 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g16so5265705eds.1
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 10:54:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VN7f+RKZpo2NmwIV9g9/uqoYpUa4r+jjrL3mwE/PsJ4=;
        b=uiPSNk6xpIWXZQgwWHgnivNfazeLFVKNuFR7RjaoYXrUTLTXL2eTZhXWRxeOVFiXII
         y1zeroSUu084hA9qVFWf3fGezkneSLD/+t4i6GYXKACxwuYnn3cbbTLnT4nlZkRa1Wfj
         A5hNgkbo2hv0+A1/587CQ8GJYFLI/urYjrCrIbD6ZqmWlw9U49SuRTPRC3Yfh8aAvj2X
         hJsRewXV0SdGYbSzzhc/Q7GobkA+qfSVS69qH5m0krDjSaMd9B1BGpPUIy8uXbzlQNwR
         uTLQCRmQa4W7W+PVBVc7Gf9mLJIcewHhhQ/DWlX4Eadvab0JvAJmKUDUbvrgZmNP92wS
         YO1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VN7f+RKZpo2NmwIV9g9/uqoYpUa4r+jjrL3mwE/PsJ4=;
        b=tTa+lTMnsloStmfdzbEH1QqQJkx66q4TJ6PGu28Rkvm0MzLsRj6hpjW29uBva/icFn
         O99U8Uy8ClF/WcFAf9ks3yDwhvl3LEqVVXYFg4mkllIxSFN5mU753J4uSFw2tMx/Ssxm
         zvr87+X2fzZWaYtcU4G9mm2ElY7ykICzTX49VY4UgZ4eZJk1YUt3icy5oU/NeXM8odLm
         FicSIExlXU8HMV19KsGIIImN54IXstgWjhHHMlLcI3BHqSPINEUFOiB4I8HgtEMs414p
         tVD9lMZiYzXDQkjfQYHU8hKqqTfLIGDboR5MPQnqvV2NIIOPXRRnhO0JXJnrIzI6GROe
         MILQ==
X-Gm-Message-State: AGi0PubQhXz2nrva4gnslOjWzNji5JoQ1eD6pnGrEY4DUJ87edVzROqD
        xtsGFQpZlcvW0NmmtmHz+/15S0GtVwhRkcihaBI=
X-Google-Smtp-Source: APiQypJrlwdBkmt8Sa3pKFujJHkJbLyEAZJDbIPYAgehJblgcmWp2oBy1TtQGDZOJ0aJ1Udx9AafYi4Z9/egRjkTndE=
X-Received: by 2002:a50:e002:: with SMTP id e2mr112801edl.179.1588269297748;
 Thu, 30 Apr 2020 10:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200429161952.17769-1-olteanv@gmail.com> <20200429161952.17769-2-olteanv@gmail.com>
 <6b1681a7-13e1-9aaa-f765-2a327fb27555@cumulusnetworks.com>
 <147e0ee1-75f9-4dba-aff5-f7b4a078cbae@cumulusnetworks.com> <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
In-Reply-To: <CA+h21hpAJDomzqTh2UBkefzWOnVbEa+EXmx9k8LXbUwhoURVZg@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 Apr 2020 20:54:46 +0300
Message-ID: <CA+h21hq7N+6YuC1UJyZrz-YL2ZBzCG1zrC6CPd_Vw7KZWh4ZMw@mail.gmail.com>
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

On Thu, 30 Apr 2020 at 20:50, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Hi Nikolay, Roopa,
>
> On Wed, 29 Apr 2020 at 19:33, Nikolay Aleksandrov
> <nikolay@cumulusnetworks.com> wrote:
> >
> > +CC Roopa
> >
> > On 29/04/2020 19:27, Nikolay Aleksandrov wrote:
> > > On 29/04/2020 19:19, Vladimir Oltean wrote:
> > >> From: Florian Fainelli <f.fainelli@gmail.com>
> > >>
> > >> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
> > >> as bridge members") added a special check in br_if.c in order to check
> > >> for a DSA master network device with a tagging protocol configured. This
> > >> was done because back then, such devices, once enslaved in a bridge
> > >> would become inoperative and would not pass DSA tagged traffic anymore
> > >> due to br_handle_frame returning RX_HANDLER_CONSUMED.
> > >>
> > >> But right now we have valid use cases which do require bridging of DSA
> > >> masters. One such example is when the DSA master ports are DSA switch
> > >> ports themselves (in a disjoint tree setup). This should be completely
> > >> equivalent, functionally speaking, from having multiple DSA switches
> > >> hanging off of the ports of a switchdev driver. So we should allow the
> > >> enslaving of DSA tagged master network devices.
> > >>
> > >> Make br_handle_frame() return RX_HANDLER_PASS in order to call into the
> > >> DSA specific tagging protocol handlers, and lift the restriction from
> > >> br_add_if.
> > >>
> > >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> > >> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> > >> ---
> > >>  net/bridge/br_if.c    | 4 +---
> > >>  net/bridge/br_input.c | 4 +++-
> > >>  2 files changed, 4 insertions(+), 4 deletions(-)
> > >>
> > >> diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
> > >> index ca685c0cdf95..e0fbdb855664 100644
> > >> --- a/net/bridge/br_if.c
> > >> +++ b/net/bridge/br_if.c
> > >> @@ -18,7 +18,6 @@
> > >>  #include <linux/rtnetlink.h>
> > >>  #include <linux/if_ether.h>
> > >>  #include <linux/slab.h>
> > >> -#include <net/dsa.h>
> > >>  #include <net/sock.h>
> > >>  #include <linux/if_vlan.h>
> > >>  #include <net/switchdev.h>
> > >> @@ -571,8 +570,7 @@ int br_add_if(struct net_bridge *br, struct net_device *dev,
> > >>       */
> > >>      if ((dev->flags & IFF_LOOPBACK) ||
> > >>          dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
> > >> -        !is_valid_ether_addr(dev->dev_addr) ||
> > >> -        netdev_uses_dsa(dev))
> > >> +        !is_valid_ether_addr(dev->dev_addr))
> > >>              return -EINVAL;
> > >>
> > >>      /* No bridging of bridges */
> > >> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> > >> index d5c34f36f0f4..396bc0c18cb5 100644
> > >> --- a/net/bridge/br_input.c
> > >> +++ b/net/bridge/br_input.c
> > >> @@ -17,6 +17,7 @@
> > >>  #endif
> > >>  #include <linux/neighbour.h>
> > >>  #include <net/arp.h>
> > >> +#include <net/dsa.h>
> > >>  #include <linux/export.h>
> > >>  #include <linux/rculist.h>
> > >>  #include "br_private.h"
> > >> @@ -263,7 +264,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff **pskb)
> > >>      struct sk_buff *skb = *pskb;
> > >>      const unsigned char *dest = eth_hdr(skb)->h_dest;
> > >>
> > >> -    if (unlikely(skb->pkt_type == PACKET_LOOPBACK))
> > >> +    if (unlikely(skb->pkt_type == PACKET_LOOPBACK) ||
> > >> +        netdev_uses_dsa(skb->dev))
> > >>              return RX_HANDLER_PASS;
> > >>
> > >>      if (!is_valid_ether_addr(eth_hdr(skb)->h_source))
> > >>
> > >
> > > Yet another test in fast-path for all packets.
> > > Since br_handle_frame will not be executed at all for such devices I'd suggest
> > > to look into a scheme that avoid installing rx_handler and thus prevents br_handle_frame
> > > to be called in the frist place. In case that is not possible then we can discuss adding
> > > one more test in fast-path.
> > >
> > > Actually you can just add a dummy rx_handler that simply returns RX_HANDLER_PASS for
> > > these devices and keep rx_handler_data so all br_port_get_* will continue working.
> > >
> > > Thanks,
> > >  Nik
> > >
>
> Actually both of those are problematic, since br_port_get_check_rcu
> and br_port_get_check_rtnl check for the rx_handler pointer against
> br_handle_frame.
> Actually a plain old revert of 8db0a2ee2c63 works just fine for what I
> need it to, not sure if there's any point in making this any more
> complicated than that.
> What do you think?
>
> Thanks,
> -Vladimir

I spoke way too soon, I should have tested before. Of course the plain
revert is not enough.

-Vladimir
