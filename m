Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADCA492751
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 14:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbiARNgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 08:36:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:43100 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239194AbiARNgQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Jan 2022 08:36:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=VNAr+B29gW2QfI7gqZIOlXuk7JXVSUg3Bfla555i6gw=; b=3rOxCQwHBo7r5A6cee+bzTZbPR
        sVVLf+8F1g8MkgfB1YlQc/fkGtHOjwN5j+9mM73y9zq5miYbceZyi4xUvt/iQUUL9mJ9GF43dNwPd
        Jj/bcDiD0ZhogW+AVeW7sk4AuyU0ajdJZgctYyUT/ue7nOrNnUsuUE2uyVrMBUH5F4q8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n9oeX-001lxM-LA; Tue, 18 Jan 2022 14:36:01 +0100
Date:   Tue, 18 Jan 2022 14:36:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ioana.ciornei@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: phy: micrel: use kszphy_suspend()/kszphy_resume for
 irq aware devices
Message-ID: <YebCQZJ/RQYrh81j@lunn.ch>
References: <20220118110812.1767997-1-claudiu.beznea@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220118110812.1767997-1-claudiu.beznea@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 01:08:12PM +0200, Claudiu Beznea wrote:
> On a setup with KSZ9131 and MACB drivers it happens on suspend path, from
> time to time, that the PHY interrupt arrives after PHY and MACB were
> suspended (PHY via genphy_suspend(), MACB via macb_suspend()). In this
> case the phy_read() at the beginning of kszphy_handle_interrupt() will
> fail (as MACB driver is suspended at this time) leading to phy_error()
> being called and a stack trace being displayed on console. To solve this
> .suspend/.resume functions for all KSZ devices implementing
> .handle_interrupt were replaced with kszphy_suspend()/kszphy_resume()
> which disable/enable interrupt before/after calling
> genphy_suspend()/genphy_resume().
> 
> The fix has been adapted for all KSZ devices which implements
> .handle_interrupt but it has been tested only on KSZ9131.
> 
> Fixes: 59ca4e58b917 ("net: phy: micrel: implement generic .handle_interrupt() callback")
> Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
