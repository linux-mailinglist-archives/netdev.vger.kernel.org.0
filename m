Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85FBD296E5E
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 14:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S463604AbgJWMWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 08:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S463591AbgJWMWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Oct 2020 08:22:30 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5091DC0613D4;
        Fri, 23 Oct 2020 05:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZqZwulKWsNeOfTRPnUtP6s+k2zE4Jglq98sJ21G983w=; b=CN5qPyYW/KGgKCqGUJA+vsxCy
        yR2VXmwysHq99WJCJiNSr//TMWWaZUH7G+vI/fc9GAfvWivfnnIHfjne/DyNoSsCcCEm0lVypw8FQ
        SB4oL7wlaHyj8lKHfGGh+8hTt/q50UnIlZtZO1+fxeYRtAK2LbSmsRqB6nz1M4B7wMk95LszILdDn
        n6f0kO/tuD/yA3G6dGUX/MNGoEmFeW5JoqNBVYyFt/KcZyC3li8rvOtuXnOdW614W73BgpIqOOctb
        QYMjY+2JoWDAvXdMyQueSxhLYRYXo3CMFcIHPlTG6ITfUHkbVESIy0CIwLhE+wBrh/RtcMTKnWHcl
        6YYY3ZNOg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:49966)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kVw5S-0003Pn-7D; Fri, 23 Oct 2020 13:22:26 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kVw5Q-0008Rd-Cj; Fri, 23 Oct 2020 13:22:24 +0100
Date:   Fri, 23 Oct 2020 13:22:24 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [RFC PATCH v1 0/6] add initial CAN PHY support
Message-ID: <20201023122224.GD1551@shell.armlinux.org.uk>
References: <20201023105626.6534-1-o.rempel@pengutronix.de>
 <20201023114502.GC1551@shell.armlinux.org.uk>
 <043b37a0-5aa4-0311-a3f4-09c61ad20671@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <043b37a0-5aa4-0311-a3f4-09c61ad20671@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 02:14:09PM +0200, Marc Kleine-Budde wrote:
> On 10/23/20 1:45 PM, Russell King - ARM Linux admin wrote:
> > On Fri, Oct 23, 2020 at 12:56:20PM +0200, Oleksij Rempel wrote:
> >> - The upcoming CAN SIC and CAN SIC XL PHYs use a different interface to
> >>   the CAN controller. This means the controller needs to know which type
> >>   of PHY is attached to configure the interface in the correct mode. Use
> >>   PHY link for that, too.
> > 
> > Is this dynamic in some form?
> 
> There isn't any CAN SIC transceivers out there yet. I suspect there will be no
> auto detection possible, so we would describe the type of the attached
> transceiver via device tree.
> 
> In the future I can think of some devices that have a MUX and use the a classic
> transceiver (CAN high-speed) for legacy deployments and CAN SIC transceivers if
> connected to a "modern" CAN bus.
> 
> Someone (i.e. the user or the system integrator) has to configure the MUX to
> select the correct transceiver.

Hmm. So it's static, and described in firmware. So, that brings me to
the obvious question: why use phylink for this rather than the phylib
APIs?

phylink isn't obsoleting phylib in any way, and phylib does support
the ability for the PHY to change its MAC side interface (if it didn't
then PHYs such as 88x3310 and similar wouldn't be usable.)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
