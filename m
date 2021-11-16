Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323DF453261
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 13:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhKPMu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 07:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234318AbhKPMuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Nov 2021 07:50:23 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B1C5C061570;
        Tue, 16 Nov 2021 04:47:26 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id y13so12332256edd.13;
        Tue, 16 Nov 2021 04:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PC9x1cgBw93P53AgN5U5KNeA285xXCtmQFdlTLxZXtw=;
        b=RZrLyEw5KWKEERg/PuINuxssHIBa8N73E923wFGbauYaYDmhl7p+feedjAhW/wiorN
         a/7/nnu11iYYjxLPlNCucNsqGlD9Cu14l6RDUXd0tuqhbzMmd66FPU5A9xJrg7O9ecGJ
         Edt7buQNRDCJG7PzVyW1yk89b1SEGhbuxw5DJLYYAUWiSWt/sydb68Y2S5ZEhgLbQQnb
         9H7JRc+6GAD3NbDgatl6DjVgp6HUKiVGhxZJlQ6BlzMXDXY+6aiN3i+BCIZ4+Cxsp+Vl
         gQ9KOmz8k8W8a3bHmjPZv5/vttfcDktxmdsX6AJIh4RgaQuR09kpz+WD/hZ4NWlT/XX7
         7GiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PC9x1cgBw93P53AgN5U5KNeA285xXCtmQFdlTLxZXtw=;
        b=vxAFN6qwuu0CxP8410OqJoeUCRSINtx2OFcvJX28A3G9F7HlWXW0AAFlHUdb928cMI
         csC+0I3SMOFclIyhp9nhFAgM+xXoRV+kFM0i8i7dFiAjGVmWc4CZkDl0k3CmZlqL2kY3
         DGFJxm8qWOVvZFJPRCxIHC6RUqQh0/F749HvVDfpVTEQVG0ojvplAtVvtn0aop6+ib9j
         djWZsuERWLbYQSUQOn7Gh465rRaeJIxgbd34Qc7MJ2qqIbyfYVDiQtuCmbPWan3PpgwE
         UXnX1RlIMNmYWAdAhPsdnNFzpII64c+RrWc0RrPs9pER7fw1lifJpFaaXYrjB9rp2nnR
         nItA==
X-Gm-Message-State: AOAM532TDNxUqB5H+hksQazMq+7dMhURfaGlOUlDo3YUVoL8X1mrmf37
        Dy7REIr/yxYalGJxyxHtiIw=
X-Google-Smtp-Source: ABdhPJzmM7Jm0Plk96yqW20zocxqgfgoNwA1vAy7BKhyVjVMaKAX7ggmH8ITu4kza1UOIJHaVbTnKw==
X-Received: by 2002:a17:906:9941:: with SMTP id zm1mr9628075ejb.466.1637066844805;
        Tue, 16 Nov 2021 04:47:24 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id sd28sm8934405ejc.37.2021.11.16.04.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 04:47:24 -0800 (PST)
Date:   Tue, 16 Nov 2021 14:47:23 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     g@pengutronix.de, Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        kernel@pengutronix.de, Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [RFC PATCH net-next] net: dsa: microchip: implement multi-bridge
 support
Message-ID: <20211116124723.kivonrdbgqdxlryd@skbuf>
References: <20211108111034.2735339-1-o.rempel@pengutronix.de>
 <20211110123640.z5hub3nv37dypa6m@skbuf>
 <20211112075823.GJ12195@pengutronix.de>
 <20211115234546.spi7hz2fsxddn4dz@skbuf>
 <20211116083903.GA16121@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211116083903.GA16121@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 09:39:03AM +0100, Oleksij Rempel wrote:
> On Tue, Nov 16, 2021 at 01:45:46AM +0200, Vladimir Oltean wrote:
> 
> .....
> 
> > > > Why != DISABLED? I expect that dev_ops->cfg_port_member() affects only
> > > > data packet forwarding, not control packet forwarding, right?
> > > 
> > > No. According to the KSZ9477S datasheet:
> > > "The processor should program the “Static MAC Table” with the entries that it
> > > needs to receive (for example, BPDU packets). The “overriding” bit should be set
> > > so that the switch will forward those specific packets to the processor. The
> > > processor may send packets to the port(s) in this state. Address learning is
> > > disabled on the port in this state."
> > > 
> > > This part is not implemented.
> > > 
> > > In current driver implementation (before or after this patch), all
> > > packets are forwarded. It looks like, current STP implementation in this driver
> > > is not complete. If I create a loop, the bridge will permanently toggle one of
> > > ports between blocking and listening. 
> > > 
> > > Currently I do not know how to proceed with it. Remove stp callback and
> > > make proper, straightforward bride_join/leave? Implement common soft STP
> > > for all switches without HW STP support?
> > 
> > What does "soft STP" mean?
> 
> Some HW seems to provide configuration bits for ports STP states. For
> example by enabling it, I can just set listening state and it will only pass
> BPDU packets without need to program static MAC table. (At least, this
> would be my expectation)
> 
> For example like this:
> https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/mt7530.c#L1121
> 
> If this HW really exist and works as expected, how should I name it?

You are simply talking about the kind of registers that a switch exposes.
That doesn't really matter, the end result should be the same.
For example, sja1105 doesn't have named STP states, but it allows the
driver to specify whether data plane packets can be received and sent on
a given port.
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/sja1105/sja1105_main.c#L2030
On other switches it's even more interesting, you need to calibrate STP
states from the port forwarding mask.
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/ethernet/mscc/ocelot.c#L1476
In any case, the switch should be able (somehow) to distinguish
link-local multicast packets and send them to the CPU port regardless of
the source port's STP state, and also be able to inject a link-local
multicast packet into a port regardless of its STP state.
For Micrel/Microchip switches, at least BPDU injection should be
supported, I believe that's what this piece of code does:
https://elixir.bootlin.com/linux/v5.16-rc1/source/net/dsa/tag_ksz.c#L127

> > You need to have a port state in which data  plane packets are blocked,
> > but BPDUs can pass.
> 
> ack.
> 
> > Unless you trap all packets to the CPU and make the selection in software
> > (therefore, including the forwarding, I don't know if that is so desirable),
> 
> Yes, this is my point, on plain linux bridge with two simple USB ethernet
> adapters, I'm able to use STP without any HW offloading.
> 
> If my HW do not provide straightforward way to trap BPDU packets to CPU,
> i should be able to reuse functionality already provided by the linux
> bridge.

At least on net-next you can return -EOPNOTSUPP in ->port_bridge_join
and DSA will leave your port to operate in standalone mode and what will
happen is exactly what you describe. But if lack of STP support is what
you're trying to fix, there might be better ways of fixing it than doing
software bridging.

> Probably I need to signal it some how from dsa driver, to let linux
> bridge make proper decision and reduce logging noise.

What logging noise?

> For example:
> - Have flag like: ds->sta_without_bpdu_trap = true;

:-/ what would this flag do?

> - If no .port_mdb_add/.port_fdb_add callbacks are implemented, handle
>   all incoming packet by the linux bridge without making lots of noise,
>   and use .port_bridge_join/.port_bridge_leave to separate ports.

You can already let forwarding be partially done in software. For
example qca8k sets up the CPU port as the only destination for multicast
and for flooding:
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/qca8k.c#L1157
Notice how its tagging protocol driver does not call
dsa_default_offload_fwd_mark(), in order to let the bridge forward the
packets in software:
https://elixir.bootlin.com/linux/v5.16-rc1/source/net/dsa/tag_qca.c#L51

> - If .port_mdb_add/.port_fdb_add are implemented, program the static MAC table.

You want DSA to program the static MAC table for link-local traffic?
Why? DSA doesn't care how you trap your link-local traffic to the CPU,
it might vary wildly between one switch and another. Also,
->port_mdb_add() is for data plane multicast packets (aka not BPDUs),
and ->port_fdb_add() is for unicast data plane packets (again not
BPDUs). Your driver wouldn't even be the first one that traps link-local
traffic privately.
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/hirschmann/hellcreek.c#L1050
https://elixir.bootlin.com/linux/v5.16-rc1/source/drivers/net/dsa/sja1105/sja1105_main.c#L868
There isn't any good way for user space to have visibility into which
packets a switch will trap. There is devlink-trap which AFAIK allows you
to see but not modify the traps that are built-in to the hardware/driver:
https://www.kernel.org/doc/html/latest/networking/devlink/devlink-trap.html
There are also traps which you can add using the tc-trap action
(amazingly I could not find documentation for this). But I don't think
it would surprise anyone if you would trap BPDUs by default in the
driver - as mentioned, some switches already do this with no way to disable it.

> > you don't have much of a choice except to do what you've said above, program
> > the static MAC table with entries for 01-80-c2-00-00-0x which trap those
> > link-local multicast addresses to the CPU and set the STP state override
> > bit for them and for them only.
> 
> Hm... Microchip documentation do not describes it as STP state override. Only
> as "port state override".

Potato, patato, it should be the same thing.

> And since STP state is not directly configurable on this switch, it
> probably means receive/transmit enable state of the port.  So, packets
> with matching MAC should be forwarded even if port is in the receive
> disabled state. Correct?

In the context we've been discussing so far, "forwarding" has a pretty
specific meaning, which is autonomously redirecting from one front port
to another. For link-local packets, what you want is "trapping", i.e.
send to the CPU and to the CPU only.

> 
> > BTW, see the "bridge link set" section in "man bridge" for a list of
> > what you should do in each STP state.
> 
> ack. Thank you.
> 
> Regards,
> Oleksij
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
