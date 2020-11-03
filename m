Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD3D62A4C9F
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 18:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgKCRWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 12:22:00 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbgKCRWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 12:22:00 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ka00H-00540Y-TL; Tue, 03 Nov 2020 18:21:53 +0100
Date:   Tue, 3 Nov 2020 18:21:53 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        f.fainelli@gmail.com, hkallweit1@gmail.com, robh@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] net: phy: dp83td510: Add support for the
 DP83TD510 Ethernet PHY
Message-ID: <20201103172153.GO1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-5-dmurphy@ti.com>
 <20201030160330.622c55a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b32a56b-f054-5790-c5cf-bf1e86403bad@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b32a56b-f054-5790-c5cf-bf1e86403bad@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 11:09:44AM -0600, Dan Murphy wrote:
> Hello
> 
> On 10/30/20 6:03 PM, Jakub Kicinski wrote:
> > On Fri, 30 Oct 2020 12:29:50 -0500 Dan Murphy wrote:
> > > The DP83TD510E is an ultra-low power Ethernet physical layer transceiver
> > > that supports 10M single pair cable.
> > > 
> > > The device supports both 2.4-V p2p and 1-V p2p output voltage as defined
> > > by IEEE 802.3cg 10Base-T1L specfications. These modes can be forced via
> > > the device tree or the device is defaulted to auto negotiation to
> > > determine the proper p2p voltage.
> > > 
> > > Signed-off-by: Dan Murphy <dmurphy@ti.com>
> > drivers/net/phy/dp83td510.c:70:11: warning: symbol 'dp83td510_feature_array' was not declared. Should it be static?
> I did not see this warning. Did you use W=1?

I _think_ that one is W=1. All the PHY drivers are W=1 clean, and i
want to keep it that way. And i hope to make it the default in a lot
of the network code soon.

> > Also this:
> > 
> > WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
> > #429: FILE: drivers/net/phy/dp83td510.c:371:
> > +		return -ENOTSUPP;
> > 
> > WARNING: ENOTSUPP is not a SUSV4 error code, prefer EOPNOTSUPP
> > #524: FILE: drivers/net/phy/dp83td510.c:466:
> > +		return -ENOTSUPP;
> Same with these warnings how where they reproduced?
> > 
> > ERROR: space required before the open parenthesis '('
> > #580: FILE: drivers/net/phy/dp83td510.c:522:
> > +		if(phydev->autoneg) {
> > 
> > ERROR: space required before the open parenthesis '('
> > #588: FILE: drivers/net/phy/dp83td510.c:530:
> > +		if(phydev->autoneg) {
> > 

These look like checkpatch.

> > 
> > And please try to wrap the code on 80 chars on the non trivial lines:
> 
> What is the LoC limit for networking just for my clarification and I will
> align with that.

80. I would not be too surprised to see checkpatch getting a patch to
set it to 80 for networking code.

    Andrew
