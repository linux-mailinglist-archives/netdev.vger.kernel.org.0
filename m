Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D921931CADE
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 14:07:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229910AbhBPNHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 08:07:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43990 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229864AbhBPNHM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Feb 2021 08:07:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lC03g-006h0z-IM; Tue, 16 Feb 2021 14:06:28 +0100
Date:   Tue, 16 Feb 2021 14:06:28 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nathan Rossi <nathan@nathanrossi.com>
Cc:     netdev@vger.kernel.org, Nathan Rossi <nathan.rossi@digi.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] of: of_mdio: Handle properties for non-phy mdio devices
Message-ID: <YCvDVEvBU5wabIx7@lunn.ch>
References: <20210215070218.1188903-1-nathan@nathanrossi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210215070218.1188903-1-nathan@nathanrossi.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 15, 2021 at 07:02:18AM +0000, Nathan Rossi wrote:
> From: Nathan Rossi <nathan.rossi@digi.com>
> 
> The documentation for MDIO bindings describes the "broken-turn-around",
> "reset-assert-us", and "reset-deassert-us" properties such that any MDIO
> device can define them. Other MDIO devices may require these properties
> in order to correctly function on the MDIO bus.
> 
> Enable the parsing and configuration associated with these properties by
> moving the associated OF parsing to a common function
> of_mdiobus_child_parse and use it to apply these properties for both
> PHYs and other MDIO devices.

Hi Nathan

What device are you using this with?

The Marvell Switch driver does its own GPIO reset handling. It has a
better idea when a hardware reset should be applied than what the
phylib core has. It will also poll the EEPROM busy bit after a
reset. How long a pause you need after the reset depends on how full
the EEPROM is.

And i've never had problems with broken-turn-around with Marvell
switches.

Given the complexity of an Ethernet switch, it is probably better if
it handles its own reset.

     Andrew
