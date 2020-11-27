Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6C2C2C6C60
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 21:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731258AbgK0UDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 15:03:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731233AbgK0UCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 15:02:18 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F500C061A47;
        Fri, 27 Nov 2020 11:29:35 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id lt17so9067060ejb.3;
        Fri, 27 Nov 2020 11:29:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CQWS0KFOZGclrXsgAFamD/N59/wMiUy4GaVAQ/IVTQQ=;
        b=bbEqHQ0SHpXzNZZ6lUDkdI7Zrv36B6q9wKcMZ6nWddqQyOMkms+7kMHhRyydqnP5lC
         TzzNgYCGUQNK0mBu89B4aBen+5zU1JpabGW3YPz2iEeKJYR/Gqlix6qZql3Cj4LSajLC
         8AVTQwPCu1ZRNkmiHgkOF0a382Qoi8CqVXcyIKsXnI8KOwlN6Z3kVXTWP45fQRxY7+WA
         tEp5z+rsKx98XLpdjrB5QsXeAMVxKxkXPNuBpQDJni5sOn/Wz9Fnz/1WmUDGbKosbB54
         SgOb/mD1nk3qxTE1epLJBmQgm1rYbMwFT1jxU2UU6TIy588adK86mD7EFd+ufVltJaJK
         xw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CQWS0KFOZGclrXsgAFamD/N59/wMiUy4GaVAQ/IVTQQ=;
        b=kSzdrXQfeCEc0JWMg93KnPQehUKhaBjeiKGV9q96sXeJ2Gkwsw4z+y9f9vQiEdk6AU
         2NxhsdKLUXBrcQr7A9Dx5FXCJordyPx0SwZNjkw8TJa+DC6/4Rx/X/3v7TthdXDugI4H
         s+POaUnZ8U4Y3rg6VIpGfHECkI4iFWCF2occR/5m9249yBr9dOrP3tgHymkeIZwXJh0t
         FN/0yp2yjbnOKeLv+/j8uafhK50IhOkZDZclBwFtl9nAcpUqYdXZrITij6H0ltF5tvae
         SM2DqIO/mq39UGyuX0svblgQex8DiJ/xLO76bzPRzqDrTOWi027ld+dzuKJAhdFhIaWF
         sB6A==
X-Gm-Message-State: AOAM5313/AqFIekEA8DXh0JuL4e40uFv0BDJdkz8NrP1s1dSen9LBv90
        vL6KtS24Iid8ksKmgvyVt7g=
X-Google-Smtp-Source: ABdhPJys+iRhVhnlJ6hsEnSQgG7iAg+ZS41ltM5kbgn+YhatkkQ3k8lCYuWwu2NDfkgXQ/Q2wx81kA==
X-Received: by 2002:a17:906:3bd6:: with SMTP id v22mr9564484ejf.160.1606505373831;
        Fri, 27 Nov 2020 11:29:33 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id gl2sm5313191ejb.29.2020.11.27.11.29.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2020 11:29:33 -0800 (PST)
Date:   Fri, 27 Nov 2020 21:29:31 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Lukasz Majewski <lukma@denx.de>
Cc:     Fugang Duan <fugang.duan@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Fabio Estevam <festevam@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>, stefan.agner@toradex.com,
        krzk@kernel.org, Shawn Guo <shawnguo@kernel.org>
Subject: Re: [RFC 0/4] net: l2switch: Provide support for L2 switch on i.MX28
 SoC
Message-ID: <20201127192931.4arbxkttmpfcqpz5@skbuf>
References: <20201125232459.378-1-lukma@denx.de>
 <20201126123027.ocsykutucnhpmqbt@skbuf>
 <20201127003549.3753d64a@jawa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201127003549.3753d64a@jawa>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 27, 2020 at 12:35:49AM +0100, Lukasz Majewski wrote:
> > > - The question regarding power management - at least for my use
> > > case there is no need for runtime power management. The L2 switch
> > > shall work always at it connects other devices.
> > >
> > > - The FEC clock is also used for L2 switch management and
> > > configuration (as the L2 switch is just in the same, large IP
> > > block). For now I just keep it enabled so DSA code can use it. It
> > > looks a bit problematic to export fec_enet_clk_enable() to be
> > > reused on DSA code.
> > >
> > > Links:
> > > [0] - "i.MX28 Applications Processor Reference Manual, Rev. 2,
> > > 08/2013" [1] -
> > > https://github.com/lmajewski/linux-imx28-l2switch/commit/e3c7a6eab73401e021aef0070e1935a0dba84fb5
> > >
> >
> > Disclaimer: I don't know the details of imx28, it's just now that I
> > downloaded the reference manual to see what it's about.
> >
> > I would push back and say that the switch offers bridge acceleration
> > for the FEC.
>
> Am I correct, that the "bridge acceleration" means in-hardware support
> for L2 packet bridging?
>
> And without the switch IP block enabled one shall be able to have
> software bridging in Linux in those two interfaces?

So if the switch is bypassed through pin strapping of sx_ena, then the
DMA0 would be connected to ENETC-MAC 0, DMA1 to ENET-MAC 1, and both
these ports could be driven by the regular fec driver, am I right? This
is how people use the imx28 with mainline linux right now, no?

When the sx_ena signal enables the switch, a hardware accelerator
appears between the DMA engine and the same MACs. But that DMA engine is
still compatible with the expectations of the fec driver. And the MACs
still belong to the FEC. So, at the end of the day, there are still 2
FEC interfaces.

Where I was going is that from a user's perspective, it would be natural
to have the exact same view of the system in both cases, aka still two
network interfaces for MAC 0 and MAC 1, they still function in the same
way (i.e. you can still ping through them) but with the additional
ability to do hardware-accelerating bridging, if the MAC 0 and MAC 1
network interfaces are put under the same bridge.

Currently, you do not offer that, at all.
You split the MTIP switch configuration between DSA and the FEC driver.
But you are still not exposing networking-capable net devices for MAC 0
and MAC 1. You still do I/O through the DMA engine.

So why use DSA at all? What benefit does it bring you? Why not do the
entire switch configuration from within FEC, or a separate driver very
closely related to it?

> > The fact that the bridge acceleration is provided by a
> > different vendor and requires access to an extra set of register
> > blocks is immaterial.
>
> Am I correct that you mean not important above (i.e. immaterial == not
> important)?

Yes, sorry if that was not clear.

> > To qualify as a DSA switch, you need to have
> > indirect networking I/O through a different network interface. You do
> > not have that.
>
> I do have eth0 (DMA0) -> MoreThanIP switch port 0 input
> 			 |
> 			 |----> switch port1 -> ENET-MAC0
> 			 |
> 			 |----> switch port2 -> ENET-MAC1

The whole point of DSA is to intercept traffic from a different and
completely unaware network interface, parse a tag, and masquerade the
packet as though it came on a different, virtual, network interface
corresponding to the switch. DSA offers this service so that:
- any switch works with any host Ethernet controller
- all vendors use the same mechanism and do not reinvent the same wheel
The last part is especially relevant. Just grep net/core/ for "dsa" and
be amazed at the number of hacks there. DSA can justify that only by scale.
Aka "we have hardware that works this way, and doesn't work any other way.
And lots of it".

That being said, in your case, the network interface is not unaware of
the switch at all. Come on, you need to put the (allegedly) switch's MAC
in promiscuous mode, from the "DSA master" driver! Hardware resource
ownership is very DSA-unlike in the imx28/vybrid model, it seems. This
is a very big deal.

And there is no tag to parse. You have a switch with a DMA engine which
is a priori known to be register-compatible with the DMA engine used for
plain FEC interfaces. It's not like you have a switch that can be
connected via MII to anything and everything. Force forwarding is done
via writing a register, again very much unlike DSA, and retrieving the
source port on RX is up in the air.

> > What I would do is I would expand the fec driver into
> > something that, on capable SoCs, detects bridging of the ENET_MAC0
> > and ENETC_MAC1 ports and configures the switch accordingly to offload
> > that in a seamless manner for the user.
>
> Do you propose to catch some kind of notification when user calls:
>
> ip link add name br0 type bridge; ip link set br0 up;
> ip link set lan1 up; ip link set lan2 up;
> ip link set lan1 master br0; ip link set lan2 master br0;
> bridge link
>
> And then configure the FEC driver to use this L2 switch driver?

Yes, that can be summarized as:
One option to get this upstream would be to transform fec into a
switchdev driver, or to create a mtip switchdev driver that shares a lot
of code with the fec driver. The correct tool for code sharing is
EXPORT_SYMBOL_GPL, not DSA.

> > This would also solve your
> > power management issues, since the entire Ethernet block would be
> > handled by a single driver. DSA is a complication you do not need.
> > Convince me otherwise.
>
> From what I see the MoreThanIP IP block looks like a "typical" L2 switch
> (like lan9xxx), with VLAN tagging support, static and dynamic tables,
> forcing the packet to be passed to port [*], congestion management,
> switch input buffer, priority of packets/queues, broadcast, multicast,
> port snooping, and even IEEE1588 timestamps.
>
> Seems like a lot of useful features.

I did not say that it is not a typical switch, or that it doesn't have
useful features. I said that DSA does not help you. Adding a
DSA_TAG_PROTO_NONE driver in 2020 is a no-go all around.

> The differences from "normal" DSA switches:
>
> 1. It uses mapped memory (for its register space) for
> configuration/statistics gathering (instead of e.g. SPI, I2C)

Nope, that's not a difference.

> 2. The TAG is not appended to the frame outgoing from the "master" FEC
> port - it can be setup when DMA transfers packet to MTIP switch internal
> buffer.

That is a difference indeed. Since DSA switches are isolated from their
host interface, and there has been a traditional separation at the
MAC-to-MAC layer (or MAC-to-PHY-to-PHY-to-MAC in weird cases), the
routing information is passed in-band via a header in the packet. The
host interface has no idea that this header exists, it is just traffic
as usual. The whole DSA infrastructure is built around intercepting and
decoding that.

> Note:
>
> [*] - The same situation is in the VF610 and IMX28:
> The ESW_FFEN register - Bit 0 -> FEN
>
> "When set, the next frame received from port 0 (the local DMA port) is
> forwarded to the ports defined in FD. The bit resets to zero
> automatically when one frame from port 0 has been processed by the
> switch (i.e. has been read from the port 0 input buffer; see Figure
> 32-1). Therefore, the bit must be set again as necessary. See also
> Section 32.5.8.2, "Forced Forwarding" for a description."
>
> (Of course the "Section 32.5.8.2" is not available)
>
>
> According to above the "tag" (engress port) is set when DMA transfers
> the packet to input MTIP buffer. This shall allow force forwarding as
> we can setup this bit when we normally append tag in the network stack.
>
> I will investigate this issue - and check the port separation. If it
> works then DSA (or switchdev) shall be used?

Source port identification and individual egress port addressing are
things that should behave absolutely the same regardless of whether you
have a DSA or a pure switchdev driver. I don't think that this is clear
enough to you. DSA with DSA_TAG_PROTO_NONE is not the shortcut you're
looking for. Please take a look at Documentation/networking/switchdev.rst,
it explains pretty clearly that a switchdev port must still expose the
same interface as any other net device.

> (A side question - DSA uses switchdev, so when one shall use switchdev
> standalone?)

Short answer: if the system-side packet I/O interface is Ethernet and
the hardware ownership is clearly delineated at the boundary of that
Ethernet port, then it should be DSA, otherwise it shouldn't.

But nonetheless, this raises a fundamental question, and I'll indulge in
attempting to answer it more comprehensively.

You seem to be tapping into an idea which has been circulating for a
while, and which can be also found in Documentation/networking/dsa/dsa.rst:

-----------------------------[cut here]-----------------------------

TODO
====

Making SWITCHDEV and DSA converge towards an unified codebase
-------------------------------------------------------------

SWITCHDEV properly takes care of abstracting the networking stack with offload
capable hardware, but does not enforce a strict switch device driver model. On
the other DSA enforces a fairly strict device driver model, and deals with most
of the switch specific. At some point we should envision a merger between these
two subsystems and get the best of both worlds.

-----------------------------[cut here]-----------------------------

IMO this is never going to happen, nor should it.
To unify DSA and switchdev would mean to force plain switchdev drivers
to have a stricter separation between the control path and the data
path, a la DSA. So, just like DSA has separate drivers for the switch,
the tagging protocol and for the DSA master, plain switchdev would need
a separate driver too for the DMA/rings/queues, or whatever, of the
switch (the piece of code that implements the NAPI instance). That
driver would need to:
(a) expose a net device for the DMA interface
(b) fake a DSA tag that gets added by the DMA net device, just to be
    later removed by the switchdev net device.
This is just for compatibility with what DSA _needs_ to do to drive
hardware that was _designed_ to work that way, and where the _hardware_
adds that tag. But non-DSA drivers don't need any of that, nor does it
really help them in any way! So why should we model things this way?
I don't think the lines between plain switchdev and DSA are blurry at all.
And especially not in this case. You should not have a networking
interface registered to the system for DMA-0 at all, just for MAC-0 and
MAC-1.
