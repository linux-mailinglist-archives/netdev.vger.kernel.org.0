Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DA83BECDE
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 19:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhGGRRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 13:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhGGRRS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 13:17:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D3EC061574;
        Wed,  7 Jul 2021 10:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IKfLCMe4s5rWOvz/YeqfS96bhD2J6/ZLNE/tuqCpjyc=; b=udOdcZ0bZf+3+fMGXiAJn7UNb
        kH76nzJJPqBD6lPUh2XRfZjMXYZuLoi2r1MgswcdE8bmeEfhc807qfV3Tef/+CXsVJ707nERGbZj6
        JAjz15PJAeiIaXm0L3MgkAiEEROAi4txHjWjfT4nIhOLP0KEILipxlHLPKbTnSCZb92ckCa6VKQYB
        yiR8har4UpmnBIiXmGCj+QSHMg5tCXnjotwdYIsIC8hW7dyPUvHWpKttnwu5Vu57IUP/0124Kdphx
        TE/6tMAS7yLNbRWC7PD0SwTjnzZepvBqheAzuY6OxJepgMK5Us27YMUlDdaYNita9k48rE7mAMNY7
        oF8fZ/3Rg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45838)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m1B85-0008J0-9d; Wed, 07 Jul 2021 18:14:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m1B84-00037N-Ez; Wed, 07 Jul 2021 18:14:32 +0100
Date:   Wed, 7 Jul 2021 18:14:32 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Peter Rosin <peda@axentia.se>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH RFC net-next] dt-bindings: ethernet-controller: document
 signal multiplexer
Message-ID: <20210707171432.GT22278@shell.armlinux.org.uk>
References: <20210701005347.8280-1-kabel@kernel.org>
 <YN5kGsMwds+wCACq@lunn.ch>
 <20210707012224.14df9eab@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210707012224.14df9eab@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 07, 2021 at 01:22:24AM +0200, Marek Behún wrote:
> On Fri, 2 Jul 2021 02:55:54 +0200
> Andrew Lunn <andrew@lunn.ch> wrote:
> > On Thu, Jul 01, 2021 at 02:53:47AM +0200, Marek Behún wrote:
> > > There are devices where the MAC signals from the ethernet controller are
> > > not directly connected to an ethernet PHY or a SFP cage, but to a
> > > multiplexer, so that the device can switch between the endpoints.
> > > 
> > > For example on Turris Omnia the WAN controller is connected to a SerDes
> > > switch, which multiplexes the SerDes lanes between SFP cage and ethernet
> > > PHY, depending on whether a SFP module is present (MOD_DEF0 GPIO from
> > > the SFP cage).  
> > 
> > At the moment, i don't think phylink supports this. It does not have a
> > way to dynamically switch PHY. If the SFP disappears, you probably
> > want to configure the PHY, so that it is up, autoneg started,
> > etc. When the SFP reappears, the PHY needs to be configured down, the
> > SFP probably needs its TX GPIO line set active, etc. None of this
> > currently exists.
> 
> Of course this is not supported by phylink: it can't be, since we don't
> even have a binding description :) I am figuring out how to do correct
> binding while working on implementing this into phylink.

I have been thinking that we need phylink to separate the PHY pointer
that was probed by the network adapter and the PHY pointer for the SFP.
The reason being that currently, a network adapter can remove the SFP
PHY when it didn't create it - which is obviously not a good idea as it
doesn't own it.

The other reason is to do with this situation where we have separate
PHY and SFP paths. I'm not intending at this point to add support for
this, only to separate the two PHYs and have something like:

static struct phy_device *phylink_phy(struct phylink *pl)
{
	if (pl->sfp_phy)
		return pl->sfp_phydev;
	return pl->phydev;
}

and use that everywhere we want to get at pl->phydev in the independent
parts of the code. Those which want to get at a specific PHY will
continue using their appropriate pointers directly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
