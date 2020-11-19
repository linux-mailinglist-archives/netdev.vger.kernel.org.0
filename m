Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89B72B9E03
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgKSXQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbgKSXQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:16:22 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962A8C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 15:16:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=d04PQ9hXGMwnNf/9OpR576As/8xUL2kZEnoyB/i5tCw=; b=uNdjHuTE/A3AvtmDVttqqmNnG
        9Ct4IRwdP2iBVy5pjZRLUf+MmIbvF6Z6MJQS2BMJ9WctbShL0lqI9KhRVyFDbo/fK84yaQqWb2VeN
        sI1TACgG3qjFks2Wyps5wnDJ0MVhYN9jFg9BZt4KP2LdL66CwqCWdF3r0A1x9xge26XZKpETaajd+
        ZGTeJkNULS2lNzGjAxOOvlDCjm9H0NgqgdzXcv0vthfTglGugM3cAOPIOU7QuZVAx6t0B7KXV0B+I
        y4TIS/ZXLAG2EwLYvNOrlb4YwL/MTYAkLS/vG8FxPdc0gdlZBiKetANw2C7P2i20EF/xQMgj6o9RL
        gINsIsnLA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33582)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kft9z-0002qm-F8; Thu, 19 Nov 2020 23:16:15 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kft9x-0002XJ-Nd; Thu, 19 Nov 2020 23:16:13 +0000
Date:   Thu, 19 Nov 2020 23:16:13 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Antoine Tenart <atenart@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: net: phy: Dealing with 88e1543 dual-port mode
Message-ID: <20201119231613.GN1551@shell.armlinux.org.uk>
References: <20201119152246.085514e1@bootlin.com>
 <20201119145500.GL1551@shell.armlinux.org.uk>
 <20201119162451.4c8d220d@bootlin.com>
 <87k0uh9dd0.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0uh9dd0.fsf@waldekranz.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 11:43:39PM +0100, Tobias Waldekranz wrote:
> On Thu, Nov 19, 2020 at 16:24, Maxime Chevallier <maxime.chevallier@bootlin.com> wrote:
> > I don't think we have a way to distinguish from the DT if we are in
> > SGMII-to-Fibre or in SGMII-to-{Copper + Fibre}, since the description is
> > the same, we don't have any information in DT about wether or not the
> > PHY is wired to a Copper RJ45 port.
> >
> > Maybe we should have a way to indicate if a PHY is wired to a Copper
> > port in DT ?
> 
> Do you mean something like:
> 
> SGMII->SGMII (Fibre):
> ethernet-phy@0 {
>    sfp = <&sfp0>;
> };
> 
> SGMII->MDI (Copper):
> ethernet-phy@0 {
>     mdi;
> };
> 
> SGMII->Auto Media Detect
> ethernet-phy@0 {
>     mdi;
>     sfp = <&sfp0>;
> };

This isn't something we could realistically do - think about how many
DT files are out there today which would not have this for an existing
PHY. The default has to be that today's DT descriptions continue to work
as-is, and that includes ones which already support copper and fibre
either with or without a sfp property.

So, we can't draw any conclusion about whether the fiber interface is
wired from whether there is a sfp property or not.

We also can't draw a conclusion about whether the copper side is wired
using a "mdi" property, or whether there is a "sfp" property or not.

The only thing we could realistically do today is to introduce a
property like:

	mdi = "disabled" | "okay";

to indicate whether the copper port can be used, and maybe something
similar for the fiber interface.  Maybe as you suggest, not "okay"
but specifying the number of connected pairs would be a good idea,
or maybe that should be a separate property?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
