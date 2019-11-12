Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC44F8704
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 03:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbfKLCxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 21:53:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726932AbfKLCxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 21:53:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0N54sqRXV1Q/iG6bSVUkEie2+kD6wQ1JLv31TL/96Ok=; b=NAULs/QLdDy7CLMz7+5IwA/et7
        RbOR//q2TRB72vSXbEjqPzrsdAXXn4zwWq2I6LJjASgduMKbqlY+iiFjldQcsIcZwfhyK34aTZbzE
        LDGoKof6kzU4quGxuFSRsTftnCHhmCzezEWwnUwpBSfiw9YhI+1PvLFK0rGA5fwfP/oA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUMIl-0006As-DR; Tue, 12 Nov 2019 03:53:07 +0100
Date:   Tue, 12 Nov 2019 03:53:07 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 15/15] net: mscc: ocelot: don't hardcode the
 number of the CPU port
Message-ID: <20191112025307.GB8153@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-16-olteanv@gmail.com>
 <20191110165031.GF25889@lunn.ch>
 <CA+h21hoDvAX7NgUL0VxkBwyaAst6cr_-xTz9=7T+CANqV=Zv9A@mail.gmail.com>
 <20191110171250.GH25889@lunn.ch>
 <CA+h21hpg2a=V44R_YNBBxTP4jLMgQaHBzHXyqaMDhg9uBvtpAA@mail.gmail.com>
 <d99479d0-b5c2-bee2-73ff-7d9235840225@gmail.com>
 <CA+h21hqvYnj-4mTwQ5zF9HNh8RHH3PMyBgpHHiiyT4+9RPkLbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hqvYnj-4mTwQ5zF9HNh8RHH3PMyBgpHHiiyT4+9RPkLbQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Andrew, is the Z80 embedded CPU able to run Linux?

No. 

If not, then from
> what perspective are you saying you're going to call it "the z80 port"
> instead of "CPU port", and why would you add support for it?

I've wanted to do a Hello World, but never got around to it.  I have
seen uses cases where it is possible to hot {un}plug the host. The
switch keeps on running. While the host is missing, STP packets are no
longer sent, but the switch keeps on switching. At some point the
other switches in the net are going to do something and STP will break
down, either partitioning the net, or causing loops. You could have
the Z80 monitor for the host going away, and either taking over the
STP, or cleanly shutting the switch down.

But Marvells real use case for the Z80 is for it to manage the switch,
no DSA at all. Just a dumb unmanaged, so very simple managed switch.

> But otherwise, I don't know whether there's anything really actionable
> here. What the ocelot driver calls a CPU port is always a "port
> towards the CPU running Linux and managing the switch", so the CPU
> port is always local by definition, no matter whether the CPU is
> connected over DMA or over Ethernet (aka NPI mode or not).

Well, it got me confused, but i think i have it now. It is more about
new people getting up to speed on the driver, especially if they have
experience with other DSA drivers, and suddenly the CPU port can mean
something different.

	  Andrew
