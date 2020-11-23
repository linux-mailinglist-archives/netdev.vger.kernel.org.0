Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB962C183A
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 23:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731969AbgKWWJR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 17:09:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729245AbgKWWJQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Nov 2020 17:09:16 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1khK1K-008YSH-1Z; Mon, 23 Nov 2020 23:09:14 +0100
Date:   Mon, 23 Nov 2020 23:09:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH net-next 2/3] net: dsa: add Arrow SpeedChips XRS700x
 driver
Message-ID: <20201123220914.GC2036992@lunn.ch>
References: <20201120181627.21382-1-george.mccollister@gmail.com>
 <20201120181627.21382-3-george.mccollister@gmail.com>
 <20201120193321.GP1853236@lunn.ch>
 <CAFSKS=P=epx3Sr3OzkCg9ycoftmXm__PaMee7HWbAGXYdqgbDw@mail.gmail.com>
 <20201120232439.GA1949248@lunn.ch>
 <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=M-2rwM2UC58xf8n0ORuwxHq06BjLj7QP=JuU19-tCpGg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > https://www.flexibilis.com/downloads/xrs/SpeedChip_XRS7000_3000_User_Manual.pdf

Section 6.1.4

The forwarding decision is presented in Figure 19. Note that also
frames coming into a disabled port are received to the buffer memory,
but because their forwarding decision is not to forward them to any
port, they are dropped.  This behavior however can be changed, and
frames can be forwarded from disabled ports to other ports by using
Inbound Policy (see Chapter 6.1.5).

Sounds promising. And Section 6.1.5:

Inbound Policy checks the source and the destination MAC addresses of
all the received frames. The user can configure through the register
interface what kind of a treatment should frames with certain source
or destination MAC addresses get. Many protocols use protocol specific
multicast MAC addresses and the destination MAC address can therefore
be used for forwarding those frames to CPU port and not to other
ports.

Looking at table 36, i think you can add a match for the BPDU
destination MAC address, and have i forwarded to the CPU port.

Looks like you can add 15 such filters. So you might want to think
about how you want to use these, what other special packets do you
want to allow through?

	    Andrew
