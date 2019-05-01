Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF67410E1A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726150AbfEAUfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:35:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51524 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726137AbfEAUfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:35:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=GfxeFIJAZuIhQhJc+pvwy3gmVAVg38vWKBEtmY7jzkw=; b=gFTv2RJxaWSh08iBFavHSuzGKR
        uMh4VNUGdWP0Po6vuoOOsHYgD0KHMV871IDcsbskyGE3zIHFXIY6HZvH/+SrH81zxhprerrNOzJ+5
        ZXhugosdcOd3tO8StDjuo1OB2XSEYeESkbFn8BV6AZfW/dS4cintijfKivgqCUHbY+1A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvxG-00005T-Rn; Wed, 01 May 2019 22:35:50 +0200
Date:   Wed, 1 May 2019 22:35:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: phy: improve pause handling
Message-ID: <20190501203550.GH19809@lunn.ch>
References: <5ac8d9b0-ac63-64d2-d5e1-e0911a35e534@gmail.com>
 <d437c5d8-e683-4d69-7818-c6f69053bc02@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d437c5d8-e683-4d69-7818-c6f69053bc02@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 09:34:43PM +0200, Heiner Kallweit wrote:
> When probing the phy device we set sym and asym pause in the "supported"
> bitmap (unless the PHY tells us otherwise). However we don't know yet
> whether the MAC supports pause. Simply copying phy->supported to
> phy->advertising will trigger advertising pause, and that's not
> what we want. Therefore add phy_advertise_supported() that copies all
> modes but doesn't touch the pause bits.
> 
> In phy_support_(a)sym_pause we shouldn't set any bits in the supported
> bitmap because we may set a bit the PHY intentionally disabled.
> Effective pause support should be the AND-combined PHY and MAC pause
> capabilities. If the MAC supports everything, then it's only relevant
> what the PHY supports. If MAC supports sym pause only, then we have to
> clear the asym bit in phydev->supported.
> Copy the pause flags only and don't touch the modes, because a driver
> may have intentionally removed a mode from phydev->advertising.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
