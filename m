Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F079446BE4C
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238287AbhLGO6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 09:58:15 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43156 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238280AbhLGO6O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Dec 2021 09:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=R7Zy+G5BNkhmg8pTkxz2jbI8Dzkz/8n9OJfehLSB/mE=; b=oxUdiMqZSBNR/x7hMaxIa1EX5s
        CIbArZClK1XXLYr0DbtOcdsE+VrS4Ze5Y0FG2aaKlCVDKxOGuh0jQIrbCjZtoYFq9muyqVokCXXLc
        1QdXPcDD3NsTX3KXUn48QKX1HklxcPwIvM1OmVwXniG8CRYryLSq4l7U9qr8XyAeEXL0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mubrZ-00Fmbe-4M; Tue, 07 Dec 2021 15:54:37 +0100
Date:   Tue, 7 Dec 2021 15:54:37 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Martyn Welch <martyn.welch@collabora.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net] net: dsa: mv88e6xxx: allow use of PHYs on CPU
 and DSA ports
Message-ID: <Ya91rX5acIKQk7W0@lunn.ch>
References: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1muYBr-00EwOF-9C@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 07, 2021 at 10:59:19AM +0000, Russell King (Oracle) wrote:
> Martyn Welch reports that his CPU port is unable to link where it has
> been necessary to use one of the switch ports with an internal PHY for
> the CPU port. The reason behind this is the port control register is
> left forcing the link down, preventing traffic flow.
> 
> This occurs because during initialisation, phylink expects the link to
> be down, and DSA forces the link down by synthesising a call to the
> DSA drivers phylink_mac_link_down() method, but we don't touch the
> forced-link state when we later reconfigure the port.
> 
> Resolve this by also unforcing the link state when we are operating in
> PHY mode and the PPU is set to poll the PHY to retrieve link status
> information.
> 
> Reported-by: Martyn Welch <martyn.welch@collabora.com>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Hi Russell

It would be good to have a Fixes: tag here, to help with back porting.

The concept looks good, and i see you now have a Tested-by:, so with
the fixup applied i think you are good to go. Please add my
Reviewed-by: to the next version.

   Andrew
