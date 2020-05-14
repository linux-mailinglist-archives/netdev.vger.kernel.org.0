Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C5A1D35CC
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 18:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgENQB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 12:01:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60542 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726117AbgENQB6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 12:01:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=msv2kokdkm+/p+wCqKHbElETQKCgYZ1C+ffdv0310YU=; b=GbjxuaBUHyknB++0VHT8Lm+Bng
        Wy7fICEnkQO49+5ENK6KkZ347Y0H7pNbib+2WiCqB4XgL2N954PF6zn/hzeQv136CqPnNLpV/pEhZ
        YmKQzpEnDxVgeNONAqQspYUNtsklsNlN6D2e4pStD/wgJhLF0zf2FT9V2EvCxQRXyDKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZGIy-002Iji-K1; Thu, 14 May 2020 18:01:52 +0200
Date:   Thu, 14 May 2020 18:01:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test
 support
Message-ID: <20200514160152.GU499265@lunn.ch>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
 <20200513180140.GK499265@lunn.ch>
 <20200514120959.b24cszsmkjvfzss6@pengutronix.de>
 <20200514133823.GO527401@lunn.ch>
 <AM0PR04MB704193C938ECC28DE9A1B28E86BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB704193C938ECC28DE9A1B28E86BC0@AM0PR04MB7041.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 03:47:16PM +0000, Christian Herber wrote:
> Hi Andrew,
> 
> > On Wed, May 13, 2020 at 03:39:00PM +0200, Andrew Lunn wrote:
> >> On Thu, May 14, 2020 at 02:09:59PM +0200, Oleksij Rempel wrote:
> >>  ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER - the link partner is active.
> >>
> >>      The TJA1102 is able to detect it if partner link is master.
> >>
> > master is not a cable diagnostics issue. This is a configuration
> > issue.
> 

> Master is very relevant for cable diagnostics, as a cable
> measurement should not be done with an active link partner on the
> other end (i.e. a PHY in master mode trying to train the link).

> So if the measurement detects an active link partner disturbing the
> measurement, it is important to report this to the user.

So with 'normal' PHYs, we use autoneg to make the link go quiet. But
you don't have autoneg.

If there is no way to force the link quiet, then
ETHTOOL_A_CABLE_RESULT_CODE_ACTIVE_PARTNER makes sense. But we need to
keep the meaning generic. I don't want it to mean a T1 PHY with an
active master peer. It should be usable for any reason the link cannot
be made to go quiet.

	Andrew
