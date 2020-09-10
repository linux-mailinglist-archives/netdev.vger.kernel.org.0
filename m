Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E778926501E
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgIJUEj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgIJUCM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:02:12 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B35FC061795
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:01:25 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id j11so10616717ejk.0
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 13:01:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=BJSXCGkDYCgQgpbEcudBETv5w+l8LR6xSvdHLjPUmeY=;
        b=cERsQQ4kSvHQL4a/bvWPHowpatYqzaOK4PaSI3753Mwe2kROZr4/rJHTEIk+qXO1J6
         l3N6CdzhpiyiTutZNOd9/053/LOIQjzOL9ApV2PRUwQqjb70TpLX7NKXqrdkGnsDm9K5
         HsWyGDuGRjN89QPo1JKr61pJpuc2TdkOclEaT8tBh9QTCQSPSLu5PQCQX09+n/gcKVnO
         Y8yjsSBUvp/4tGzu3P4oyGnRwG8E20I/YrxyD//l9FzgseTaG2vBFI8yfy5P6G/i6+PT
         hl+0jzTX1wJ7j4SiA3KnQSXjmhFWwEadc1bmBPMCg1xYehEcgWlvl7zUAYz5HvWLrIws
         EdVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BJSXCGkDYCgQgpbEcudBETv5w+l8LR6xSvdHLjPUmeY=;
        b=bZt23B+TX9YZK/W6Pd86TStf2BOtSTo97EbchU8Uljn97ME+BDL+fQRZaoltybXqVC
         ithmL/FrygnAxgjAJwCtjgYqW060B8PmOuXEU6AFBXvQEYP/cXFqcp6fnMxpLB7+G3JJ
         zzkSrfp2THRglpMc5dPIO5i3b/TKG66wS4Bj3in8kBbslWvNuzzs5nfTFMAJ1clfubyA
         MagtG+dt02DwiAUg+JCC0RJO2Y2kfiaTbhw/SjSSaHCtZd/3O5B5BpPF6IWdjVa9V+ZS
         BOsOABgmDtRhH7KhcZfO7PWwkMSKi8/g2Rm4HJqsj2Nxk+QHjGh86lmjNppe1k3KMX+J
         CMdw==
X-Gm-Message-State: AOAM532+kUbaQ9vaxZqsFuX9dfXnccK4z90BGKwy9Sns4TcUYW4kvH7+
        Rn1whlBZWGX5wow4K8gWBSM=
X-Google-Smtp-Source: ABdhPJzCr+GZkr1iNZLvrsbbmQGM7OAXVEEhrgUeWU9j/v1m/6anaTAcqqOke9L8q2CMPRP0VzCE+A==
X-Received: by 2002:a17:906:bcd5:: with SMTP id lw21mr10700682ejb.430.1599768084133;
        Thu, 10 Sep 2020 13:01:24 -0700 (PDT)
Received: from skbuf ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id 35sm8247830edg.71.2020.09.10.13.01.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 13:01:23 -0700 (PDT)
Date:   Thu, 10 Sep 2020 23:01:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     kuba@kernel.org, andrew@lunn.ch, willemdebruijn.kernel@gmail.com,
        edumazet@google.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] __netif_receive_skb_core: don't untag vlan from skb
 on DSA master
Message-ID: <20200910200121.uaqhi2y7m3k2jssg@skbuf>
References: <20200910162218.1216347-1-olteanv@gmail.com>
 <ea9437b4-e7ba-e31c-0576-36eaeee806a1@gmail.com>
 <3ae92181-b80c-c152-4274-50711c3ed062@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ae92181-b80c-c152-4274-50711c3ed062@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 12:55:46PM -0700, Florian Fainelli wrote:
> On 9/10/2020 12:46 PM, Florian Fainelli wrote:
> > On 9/10/2020 9:22 AM, Vladimir Oltean wrote:
> > > A DSA master interface has upper network devices, each representing an
> > > Ethernet switch port attached to it. Demultiplexing the source ports and
> > > setting skb->dev accordingly is done through the catch-all ETH_P_XDSA
> > > packet_type handler. Catch-all because DSA vendors have various header
> > > implementations, which can be placed anywhere in the frame: before the
> > > DMAC, before the EtherType, before the FCS, etc. So, the ETH_P_XDSA
> > > handler acts like an rx_handler more than anything.
> > >
> > > It is unlikely for the DSA master interface to have any other upper than
> > > the DSA switch interfaces themselves. Only maybe a bridge upper*, but it
> > > is very likely that the DSA master will have no 8021q upper. So
> > > __netif_receive_skb_core() will try to untag the VLAN, despite the fact
> > > that the DSA switch interface might have an 8021q upper. So the skb will
> > > never reach that.
> > >
> > > So far, this hasn't been a problem because most of the possible
> > > placements of the DSA switch header mentioned in the first paragraph
> > > will displace the VLAN header when the DSA master receives the frame, so
> > > __netif_receive_skb_core() will not actually execute any VLAN-specific
> > > code for it. This only becomes a problem when the DSA switch header does
> > > not displace the VLAN header (for example with a tail tag).
> > >
> > > What the patch does is it bypasses the untagging of the skb when there
> > > is a DSA switch attached to this net device. So, DSA is the only
> > > packet_type handler which requires seeing the VLAN header. Once skb->dev
> > > will be changed, __netif_receive_skb_core() will be invoked again and
> > > untagging, or delivery to an 8021q upper, will happen in the RX of the
> > > DSA switch interface itself.
> > >
> > > *see commit 9eb8eff0cf2f ("net: bridge: allow enslaving some DSA master
> > > network devices". This is actually the reason why I prefer keeping DSA
> > > as a packet_type handler of ETH_P_XDSA rather than converting to an
> > > rx_handler. Currently the rx_handler code doesn't support chaining, and
> > > this is a problem because a DSA master might be bridged.
> > >
> > > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > > ---
> > > Resent, sorry, I forgot to copy the list.
> > >
> > >   net/core/dev.c | 3 ++-
> > >   1 file changed, 2 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/core/dev.c b/net/core/dev.c
> > > index 152ad3b578de..952541ce1d9d 100644
> > > --- a/net/core/dev.c
> > > +++ b/net/core/dev.c
> > > @@ -98,6 +98,7 @@
> > >   #include <net/busy_poll.h>
> > >   #include <linux/rtnetlink.h>
> > >   #include <linux/stat.h>
> > > +#include <net/dsa.h>
> > >   #include <net/dst.h>
> > >   #include <net/dst_metadata.h>
> > >   #include <net/pkt_sched.h>
> > > @@ -5192,7 +5193,7 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
> > >           }
> > >       }
> > > -    if (unlikely(skb_vlan_tag_present(skb))) {
> > > +    if (unlikely(skb_vlan_tag_present(skb)) && !netdev_uses_dsa(skb->dev)) {
> >
> > Not that I have performance numbers to claim  this, but we would
> > probably want:
> >
> > && likely(!netdev_uses_dsa(skb->dev))
> >
> > as well?
>
> And #include <net/dsa.h> as it does not look like there is any implicit
> header inclusion that provides that definition:
>
> net/core/dev.c: In function '__netif_receive_skb_core':
> net/core/dev.c:5196:46: error: implicit declaration of function
> 'netdev_uses_dsa'; did you mean 'netdev_reset_tc'?
> [-Werror=implicit-function-declaration]
>

Uhm, it's right there? Not sure how you ended up with that warning.

And I know little about how branch prediction works, I thought it's
enough that the netdev_uses_dsa() check is already following an unlikely
path.

Thanks,
-Vladimir
