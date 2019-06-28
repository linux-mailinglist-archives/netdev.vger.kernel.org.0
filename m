Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7E8259BAC
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 14:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbfF1MiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 08:38:05 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44040 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfF1MiE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 08:38:04 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so10643198edr.11
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 05:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xPcUko9FFAp/UvHdDyFahyCTJmb9UbRYhssd4xSE2/U=;
        b=RrZ3UM+nJNcBDP4HshjSSrMTFoKzLGK90981RAMVEBB7tr+praVOUyIJFC8LwOXogl
         Qcc5I2gPJ+GqrrJo+nwGeUTd77kpSArZYSlGSx5NUTR5OWX5K1bRbOpKjt0y6DtDFa2Y
         3AlTr0yLaOpJjrH4K2AQlkLm9G1kY4+wNLOIFCUPzFjK9dU6LQxoLJ2SaF5mKUqQXxmP
         MhHduRHiOpPL9CD9M2S7ZChnC6Hj3E8AkKPPhbRyfev8DENurTWBYyV9o66ZvSSlBqzU
         cbx5QFEQ8L6qnnpABFZ8A3Kvhf9fQOTSXXjmuoA0l6NJA8D+XpLJ8PeDcC/XI62hNe1a
         tU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xPcUko9FFAp/UvHdDyFahyCTJmb9UbRYhssd4xSE2/U=;
        b=KTbQZOLc+2qIw6cHG8ZxLtMY5EWGGUTWGmKx1kCECQ6bSEVxLnEvcg8i4t1T5YQf4n
         35DBoIm8xTdlwepkapM3UOuWvOb3QBGH//80nH5bg90E0iclBzuycwbUE8nrrVODCrKP
         bvzXRmCaoWiOdviOfxrWwcPkPhB0tKOk6kGA5iDYb9wedqep48V9arkoGT/rmjHMinWu
         qvf8EPta1yzG4iGFkTE7biPzo2KMNztK0r+DB/wxyhSebLFIq2QgMxHejkAg3LZWyoSK
         dmvPxFkJm+XnEKn89QoZd1b8j6EiGFj2DdoBLLdwSdxaL4Jr/Wcr9uPY88znkmTQG8MS
         qDQA==
X-Gm-Message-State: APjAAAVHnXh7Z3+UOgvgxFKOJokmMW8SitS+Ir6Z/SZIzSMknmqD8NvO
        C6pAxm34K77TZvlc5kj7hM6/O93ZrYMDaEE4Z8nsAAcg
X-Google-Smtp-Source: APXvYqzz/hxkHGMZiTwsK/C+HGcPgDhWiwj2KwE+sWryMEQi6RBqMB0HN8w3SwWIhQGN4Y1KAwHOwwCud9uDkc1kxm8=
X-Received: by 2002:a17:906:19d3:: with SMTP id h19mr8442901ejd.300.1561725482959;
 Fri, 28 Jun 2019 05:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <CA+h21hrRMrLH-RjBGhEJSTZd6_QPRSd3RkVRQF-wNKkrgKcRSA@mail.gmail.com>
 <20190628123009.GA10385@splinter>
In-Reply-To: <20190628123009.GA10385@splinter>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 28 Jun 2019 15:37:51 +0300
Message-ID: <CA+h21hpPD6E_qOS-SxWKeXZKLOnN8og1BN_vSgk1+7XXQVTnBw@mail.gmail.com>
Subject: Re: What to do when a bridge port gets its pvid deleted?
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 at 15:30, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Tue, Jun 25, 2019 at 11:49:29PM +0300, Vladimir Oltean wrote:
> > A number of DSA drivers (BCM53XX, Microchip KSZ94XX, Mediatek MT7530
> > at the very least), as well as Mellanox Spectrum (I didn't look at all
> > the pure switchdev drivers) try to restore the pvid to a default value
> > on .port_vlan_del.
>
> I don't know about DSA drivers, but that's not what mlxsw is doing. If
> the VLAN that is configured as PVID is deleted from the bridge port, the
> driver instructs the port to discard untagged and prio-tagged packets.
> This is consistent with the bridge driver's behavior.
>
> We do have a flow the "restores" the PVID, but that's when a port is
> unlinked from its bridge master. The PVID we set is 4095 which cannot be
> configured by the 8021q / bridge driver. This is due to the way the
> underlying hardware works. Even if a port is not bridged and used purely
> for routing, packets still do L2 lookup first which sends them directly
> to the router block. If PVID is not configured, untagged packets could
> not be routed. Obviously, at egress we strip this VLAN.
>
> > Sure, the port stops receiving traffic when its pvid is a VLAN ID that
> > is not installed in its hw filter, but as far as the bridge core is
> > concerned, this is to be expected:
> >
> > # bridge vlan add dev swp2 vid 100 pvid untagged
> > # bridge vlan
> > port    vlan ids
> > swp5     1 PVID Egress Untagged
> >
> > swp2     1 Egress Untagged
> >          100 PVID Egress Untagged
> >
> > swp3     1 PVID Egress Untagged
> >
> > swp4     1 PVID Egress Untagged
> >
> > br0      1 PVID Egress Untagged
> > # ping 10.0.0.1
> > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > 64 bytes from 10.0.0.1: icmp_seq=1 ttl=64 time=0.682 ms
> > 64 bytes from 10.0.0.1: icmp_seq=2 ttl=64 time=0.299 ms
> > 64 bytes from 10.0.0.1: icmp_seq=3 ttl=64 time=0.251 ms
> > 64 bytes from 10.0.0.1: icmp_seq=4 ttl=64 time=0.324 ms
> > 64 bytes from 10.0.0.1: icmp_seq=5 ttl=64 time=0.257 ms
> > ^C
> > --- 10.0.0.1 ping statistics ---
> > 5 packets transmitted, 5 received, 0% packet loss, time 4188ms
> > rtt min/avg/max/mdev = 0.251/0.362/0.682/0.163 ms
> > # bridge vlan del dev swp2 vid 100
> > # bridge vlan
> > port    vlan ids
> > swp5     1 PVID Egress Untagged
> >
> > swp2     1 Egress Untagged
> >
> > swp3     1 PVID Egress Untagged
> >
> > swp4     1 PVID Egress Untagged
> >
> > br0      1 PVID Egress Untagged
> >
> > # ping 10.0.0.1
> > PING 10.0.0.1 (10.0.0.1) 56(84) bytes of data.
> > ^C
> > --- 10.0.0.1 ping statistics ---
> > 8 packets transmitted, 0 received, 100% packet loss, time 7267ms
> >
> > What is the consensus here? Is there a reason why the bridge driver
> > doesn't take care of this?
>
> Take care of what? :) Always maintaining a PVID on the bridge port? It's
> completely OK not to have a PVID.
>

Yes, I didn't think it through during the first email. I came to the
same conclusion in the second one.

> > Do switchdev drivers have to restore the pvid to always be
> > operational, even if their state becomes inconsistent with the upper
> > dev? Is it just 'nice to have'? What if VID 1 isn't in the hw filter
> > either (perfectly legal)?
>
> Are you saying that DSA drivers always maintain a PVID on the bridge
> port and allow untagged traffic to ingress regardless of the bridge
> driver's configuration? If so, I think this needs to be fixed.

Well, not at the DSA core level.
But for Microchip:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/microchip/ksz9477.c#n576
For Broadcom:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/b53/b53_common.c#n1376
For Mediatek:
https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/tree/drivers/net/dsa/mt7530.c#n1196

There might be others as well.

Thanks,
-Vladimir
