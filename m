Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512435AF6F8
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiIFVh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiIFVh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:37:28 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC3E9E2FC
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rjo9gZsYoR8R81YIppdby1zxMkF7h4JLrIdaFjRlZKM=; b=bRgazClBOvpCQbw24/X/Z+SxCC
        eX5oMYucUGXe8KmNFwHXTBi5yNUXn//lGPzXR7QZOB0O7Yh9LESJtK88nCI37BsuLu1b5eOUflpfO
        v6zA0AvvKhNKChMvfJEVDVYd6MDTlCL1vfc42ZNzTMRm7pZbBtQPnd+WQNM8rqprFkR0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVgG3-00Fmpg-V2; Tue, 06 Sep 2022 23:37:23 +0200
Date:   Tue, 6 Sep 2022 23:37:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change DSA
 master
Message-ID: <Yxe9k86sWSf687zd@lunn.ch>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
 <20220906082907.5c1f8398@hermes.local>
 <20220906164117.7eiirl4gm6bho2ko@skbuf>
 <20220906095517.4022bde6@hermes.local>
 <20220906191355.bnimmq4z36p5yivo@skbuf>
 <YxeoFfxWwrWmUCkm@lunn.ch>
 <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
 <20220906141719.4482f31d@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906141719.4482f31d@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 02:17:19PM -0700, Stephen Hemminger wrote:
> On Tue, 6 Sep 2022 13:33:09 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
> > On 9/6/2022 1:05 PM, Andrew Lunn wrote:
> > >> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]  
> > > 
> > > Unfortunately, it is not gender neutral, which i assume is a
> > > requirement?
> > > 
> > > Plus the plural is also schnauzer, which would make your current
> > > multiple CPU/schnauzer patches confusing, unless you throw the rule
> > > book out and use English pluralisation.  
> > 
> > What a nice digression, I had no idea you two mastered German that well 
> > :). How about "conduit" or "mgmt_port" or some variant in the same lexicon?
> 
> Is there an IEEE or PCI standard for this? What is used there?

The whole DSA concept is comes from Marvell.

commit 91da11f870f00a3322b81c73042291d7f0be5a17
Author: Lennert Buytenhek <buytenh@wantstofly.org>
Date:   Tue Oct 7 13:44:02 2008 +0000

    net: Distributed Switch Architecture protocol support
    
    Distributed Switch Architecture is a protocol for managing hardware
    switch chips.  It consists of a set of MII management registers and
    commands to configure the switch, and an ethernet header format to
    signal which of the ports of the switch a packet was received from
    or is intended to be sent to.
    
    The switches that this driver supports are typically embedded in
    access points and routers, and a typical setup with a DSA switch
    looks something like this:
    
            +-----------+       +-----------+
            |           | RGMII |           |
            |           +-------+           +------ 1000baseT MDI ("WAN")
            |           |       |  6-port   +------ 1000baseT MDI ("LAN1")
            |    CPU    |       |  ethernet +------ 1000baseT MDI ("LAN2")
            |           |MIImgmt|  switch   +------ 1000baseT MDI ("LAN3")
            |           +-------+  w/5 PHYs +------ 1000baseT MDI ("LAN4")
            |           |       |           |
            +-----------+       +-----------+
    
    The switch driver presents each port on the switch as a separate
    network interface to Linux, polls the switch to maintain software
    link state of those ports, forwards MII management interface
    accesses to those network interfaces (e.g. as done by ethtool) to
    the switch, and exposes the switch's hardware statistics counters
    via the appropriate Linux kernel interfaces.
    
    This initial patch supports the MII management interface register
    layout of the Marvell 88E6123, 88E6161 and 88E6165 switch chips, and
    supports the "Ethertype DSA" packet tagging format.
    
    (There is no officially registered ethertype for the Ethertype DSA
    packet format, so we just grab a random one.  The ethertype to use
    is programmed into the switch, and the switch driver uses the value
    of ETH_P_EDSA for this, so this define can be changed at any time in
    the future if the one we chose is allocated to another protocol or
    if Ethertype DSA gets its own officially registered ethertype, and
    everything will continue to work.)

That first patch from 2008 uses the name master.

The Marvell datasheets tend to just refer to the management CPU, and
sending to / receiving from frames via one of the switches
ports. There is no reference to the network interface the management
CPU must have in order to receive/send such frames.

	Andrew
