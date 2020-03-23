Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C8118F858
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 16:14:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727257AbgCWPOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 11:14:31 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbgCWPOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 11:14:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1m+OiC3y42SS9da+Tcx1VksIIwVDt7LFueQm6zuxGVo=; b=XURddeuh+RoTABs816IckUXkfW
        egzgUGPHZht3RdSInSrJYSrt7X9WDAhCHamL4zw3CVNk1yNkmg8mPClDl87yQBxh1ptYvfaoEDUbw
        Axs5liIRIXS3Nl3+tBfKHmEpVjiBJ/o8J0AiUUjo1zF+QiGToIJBQ4ZHZi7to6N0iFXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGOmV-0000ni-Na; Mon, 23 Mar 2020 16:14:23 +0100
Date:   Mon, 23 Mar 2020 16:14:23 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Marek Vasut <marex@denx.de>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP
 TJA11xx
Message-ID: <20200323151423.GA32387@lunn.ch>
References: <AM0PR04MB70413A974A2152D27CAADFAC86F00@AM0PR04MB7041.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB70413A974A2152D27CAADFAC86F00@AM0PR04MB7041.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Yes, it is one device with two address. This is if you call the entire IC a device. If you look at it from a PHY perspective, it is two devices with 1 address.
> If you just look at it as a single device, it gets difficult to add PHY specific properties in the future, e.g. master/slave selection.

> In my opinion its important to have some kind of container for the
> entire IC, but likewise for the individual PHYs.

Yes, we need some sort of representation of two devices.

Logically, the two PHYs are on the same MDIO bus, so you could have
two nodes on the main bus.

Or you consider the secondary PHY as being on an internal MDIO bus
which is transparently bridged to the main bus. This is what was
proposed in the last patchset.

Because this bridge is transparent, the rest of the PHY/MDIO framework
has no idea about it. So i prefer that we keep with two PHY nodes on
the main bus. But i still think we need the master PHY to register the
secondary PHY, due to the missing PHY ID, and the other constrains
like resets which the master PHY has to handle.

     Andrew
