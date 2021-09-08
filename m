Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F640406A
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 23:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347797AbhIHVKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 17:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbhIHVKu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Sep 2021 17:10:50 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1451EC061575
        for <netdev@vger.kernel.org>; Wed,  8 Sep 2021 14:09:42 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id g22so4708355edy.12
        for <netdev@vger.kernel.org>; Wed, 08 Sep 2021 14:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Ly6vOtETuWW2Geeu/sHYkS/EJeN2AqpV2F/pWKaoFQ=;
        b=ReCdlqaxUNFIT8stiCpZBWgteOlgeXlf5x3i75D460yL+UmwXVn+sGS1dPDHAFcY1/
         +W/EluUo+6dSkuXktHbwiTfakF2W8yNhiOJ7B3zxMnR7fEPre0Hqmsec9cHQ7Iy3BlLm
         ujtj8UIRuTGYPD3jPy3gU43m2XdsbRbVUsDwIsUFmG+XHeubojQ6mHuI42lrr5R4gbId
         uk9ZeJaklLufU4w0Q9vxBJMqVMvhnQXP+F/JfnwkQYymMqj5Hp8Y8/PgenKP8oYDJEcg
         Bx8EVTxRa9/JA+bw3u3se7zV3xpHC5bAEbHjZCQXKh23JYXbbgJmv/q5cJO2n4i1lhKM
         3tHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Ly6vOtETuWW2Geeu/sHYkS/EJeN2AqpV2F/pWKaoFQ=;
        b=wYMiQZvy3KKFEkCEww1BLd7iVe8IWwafHJt1iLi1l2UIj2eIB1tGmj9sYWRtrNemcu
         9MdnoSJb5aiSzBG/m0R54RPqKM5eGzl/0J0h7RbcUSHXxCzMLqXzFedO+z8aPm1eGX5h
         p8yZVC9zGZXka7gUTHwZCixrUjmBd7hLR37WqrqAM9n6FpnsSxG95CSEDJtivw1bYXMm
         CSpltI/36GdpkTQTuqMCUOGlWsR4BMXM7blv3LQa9DN7txM/rU3kjN+ydzTjzZNh/KYR
         riZUoc9T1waUy0FlnfKLTkkANoaTEVQZEKDYvvGi8+xNe0H68dxKjgta/g2ZtiXcuxtF
         A4ZQ==
X-Gm-Message-State: AOAM531enQjbdWxMXo0dQJHo67HuHS8Fla4Syv+NA5qlrC/SSCqeG9Xx
        rR/uYi1VWyLB5yZba9uAtoY=
X-Google-Smtp-Source: ABdhPJxPJgeDPGP9oT1XJrn1TCt+QYdGqAUFse4Xh6G+k5s/4OcmdCjV+uGIxt1iCS+xphQEZgAZAQ==
X-Received: by 2002:aa7:d805:: with SMTP id v5mr242387edq.3.1631135380512;
        Wed, 08 Sep 2021 14:09:40 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id s3sm65462ejm.49.2021.09.08.14.09.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 14:09:40 -0700 (PDT)
Date:   Thu, 9 Sep 2021 00:09:39 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 3/5 v2] net: dsa: rtl8366rb: Support disabling
 learning
Message-ID: <20210908210939.cwwnwgj3p67qvsrh@skbuf>
References: <20210830214859.403100-1-linus.walleij@linaro.org>
 <20210830214859.403100-4-linus.walleij@linaro.org>
 <20210830224019.d7lzral6zejdfl5t@skbuf>
 <CACRpkdbTCeh6ZX7dbHCQMtniYBxX_yKZPO=PJ-TTGOQP140vLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbTCeh6ZX7dbHCQMtniYBxX_yKZPO=PJ-TTGOQP140vLw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 07, 2021 at 05:52:01PM +0200, Linus Walleij wrote:
> On Tue, Aug 31, 2021 at 12:40 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > >       /* Enable learning for all ports */
> > > -     ret = regmap_write(smi->map, RTL8366RB_SSCR0, 0);
> > > +     ret = regmap_write(smi->map, RTL8366RB_PORT_LEARNDIS_CTRL, 0);
> >
> > So the expected behavior for standalone ports would be to _disable_
> > learning. In rtl8366rb_setup, they are standalone.
> 
> OK I altered the code such that I disable learning on all ports instead,
> the new callback can be used to enable it.
> 
> What about the CPU port here? Sorry if it is a dumb question...
> 
> I just disabled learning on all ports including the CPU port, but
> should I just leave learning on on the CPU port?

Not a dumb question. DSA does not change the learning state of the CPU
port and lets drivers choose among two solutions:

(a) enable hardware address learning manually on it. This was the
    traditional approach, and the exact meaning of what this actually
    does will vary from one switch vendor to another, so you need to
    know what you get and if it complies with the network stack's expectations.
    At one end, you have ASICs where despite this setting, the {MAC SA,
    VLAN ID} will not be learned for packets injected towards a precise
    destination port specified in the DSA tag (so-called "control
    packets"). These ASICs would only learn the {MAC SA, VLAN ID} from
    packets sent from the CPU that are not injected precisely into a
    port, but forwarded freely according to the FDB (in the case of your
    Realtek tagging protocol, think of it as an all-zeroes destination
    port mask).  These are so-called "data plane packets", and DSA has
    traditionally not had any means for building/sending one, hence the
    complete lack of address learning for this type of switches,
    practically.
    On the other end you will have switches which will learn the {MAC
    SA, VLAN ID} from both control and data packets, with no way of
    controlling which one gets learned and which one doesn't.  This will
    further cause problems when you consider that some packets might
    need to be partially forwarded in software between switch ports that
    are members of a hardware bridge. In general, address learning must
    be recognized as a bridge layer function, and only packets
    pertaining to the data plane of a bridge must be subject to
    learning. Ergo: if you inject a packet into a standalone port, its
    MAC SA should not be learned (for reasons that have real life
    implications, but are a bit beside the point to detail here).
    There might also exist in-between hardware implementations, where
    there might be a global learning setting for the CPU port, with an
    override per packet (a bit in the DSA tag).

(b) implement .port_fdb_add and .port_fdb_del and then set
    ds->assisted_learning_on_cpu_port = true. This was created exactly
    for the category of switches that won't learn from CPU-injected
    traffic even when asked to do so, but has since been extended to
    cover use cases even for switches where that is a possibility.
    For example, in a setup with multiple CPU ports (and this includes
    obscure setups where every switch has a single CPU port, but is part
    of a multi-chip topology), hardware address learning on any
    individual CPU port does not make sense, because that learned
    address would keep bouncing back and forth between one CPU port and
    the other, when it really should have stayed fixed on both.
    The way this option works is that it tells DSA to listen for
    switchdev events emitted by the bridge for FDB entries that were
    learned by the software path and point towards the general direction
    of the bridge (towards the bridge itself, or towards a non-DSA
    interface in the same bridge as a DSA port, like a Wi-Fi AP).
    These software FDB entries will then be installed through .port_fdb_add
    as static FDB entries on the CPU port(s), and removed when they are no
    longer needed. Drivers which support multiple CPU ports should then
    program these FDB entries to hardware in a way in which installing
    the entry towards CPU port B will not override a pre-existing FDB
    entry that was pointing towards CPU port A, but instead just append
    to the destination port mask of any pre-existing FDB entry. This is
    also the pattern used when programming multicast (MDB) entries to
    hardware.
    This solution also addresses the observation that packets injected
    towards standalone ports should not result in the {MAC SA, VLAN ID}
    getting learned, due to a combination of two factors:
    - When you set ds->assisted_learning_on_cpu_port = true, you must
      disable hardware learning on the CPU port(s)
    - Since the only FDB entries installed on the CPU port are ones
      originating from switchdev events emitted by a bridge, learning is
      limited to the bridging layer

It is understandable if you do not want to opt into ds->assisted_learning_on_cpu_port,
and if the way in which your DSA tagging protocol injects packets into
the hardware will always remain as "control packets", this might not
even show up any problem. Typically, "control packets" will be sent to
the destination port mask from the DSA tag with no questions asked. That
is to say, if you want to xmit a packet with a given {MAC DA, VLAN ID}
towards port 0, but the same {MAC DA, VLAN ID} was already learned on
the CPU port, the switch will be happy to send it towards port 0
precisely because it's a "control packet" and it will not look up the
FDB for it. With "data packets" it's an entirely different story, the
FDB will be looked up, and the switch will say "hey, I received a packet
with this MAC DA from the CPU port, but my FDB says the destination is
the CPU port. I am told to not reflect packets back from where they came
from, so just drop it". If you are sure that neither you nor anyone else
will ever implement support for data plane packets (bridge tx_fwd_offload)
for this hardware, then statically enabling hardware learning on the CPU
port might be enough if it actually works.

There is a third option where you can still learn the {MAC SA, VLAN ID}
in-band from bridging layer packets (and not from packets sent to standalone ports),
without the overhead of extra SPI/MDIO/I2C transactions that the assisted
learning feature requires.
This third option is available if you can tell the switch to learn on a
per-packet basis, and then to implement the tx_fwd_offload bridge feature.
The idea is to tell the hardware, through the DSA tag on xmit, to only
learn the MAC SA from packets which are sent on behalf of a bridge
(these will have skb->offload_fwd_mark == true).

So in the end, you have quite a bit of choice. First of all I would
start by figuring out what the hardware is capable of doing.

Enable the hardware learning bit on the CPU port, then build this setup:

           192.168.100.3
                br0
               /   \
              /     \
             /       \
         swp0         swp1
          |            |
       Station A    Station B
    192.168.100.1   192.168.100.2


And ping br0 from Station A, attached to the swp0 of your board.

Then tcpdump on Station B, to see all packets.
If you see the ICMP requests sent by Station A towards br0, it means
that the switch has not learned the MAC SA from br0's ICMP replies, and
it basically doesn't know where the MAC address of br0 is. So it will
always flood the packets targeting br0, towards all ports in br0's
forwarding domain. "All ports" includes swp1 in this case, the curious
neighbor.

With address learning functioning properly on the CPU port, you will
only see an initial pair of packets being flooded, that being during a
time when the switch does not know what the intended destination is,
because it has not seen that MAC DA in the MAC SA field of any prior
packets on any ports.
