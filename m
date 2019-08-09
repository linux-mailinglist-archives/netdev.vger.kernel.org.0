Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8D4B88643
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 00:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbfHIWyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 18:54:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49160 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfHIWyk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Aug 2019 18:54:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=O2V/zfD8lGKgaXIk5ED+s485D/krj/OxHyJFSPZ8Jts=; b=xLf+9BHhjm10P8Ad1iJI2oIWG1
        W7wZX/mnuiS7cWbUsrNB4iT6yUEWxdNBVDTYEkR1DdrRudOQxjv7SfoE+96j9g3E6piWtz/iNg4jn
        Z2t3jjJwjTiSSzxpPNlaVPJTXMKF/WQKcNyhvZ76LqzQz+nMv0qHBu6gIBigWCFTLnLI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwDmN-0004sx-EP; Sat, 10 Aug 2019 00:54:35 +0200
Date:   Sat, 10 Aug 2019 00:54:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/4] net: phy: realtek: add support for the
 2.5Gbps PHY in RTL8125
Message-ID: <20190809225435.GE32706@lunn.ch>
References: <755b2bc9-22cb-f529-4188-0f4b6e48efbd@gmail.com>
 <49454e5b-465d-540e-cc01-07717a773e33@gmail.com>
 <20190809191822.GZ27917@lunn.ch>
 <c8e2b3e7-1d0b-eba3-6a36-8808641f3031@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8e2b3e7-1d0b-eba3-6a36-8808641f3031@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 09, 2019 at 09:31:32PM +0200, Heiner Kallweit wrote:
> On 09.08.2019 21:18, Andrew Lunn wrote:
> >> +	}, {
> >> +		PHY_ID_MATCH_EXACT(0x001cca50),
> > 
> > Hi Heiner
> > 
> Hi Andrew,
> 
> > With the Marvell driver, i looked at the range of IDs the PHYs where
> > using. The switch, being MDIO based, also has ID values. The PHY range
> > and the switch range are well separated, and it seems unlikely Marvell
> > would reuse a switch ID in a PHY which was not compatible with the
> > PHY.
> > 
> > Could you explain why you picked this value for the PHY? What makes
> > you think it is not in use by another Realtek PHY? 
> > 
> 0x001cc800 being the Realtek OUI, I've seen only PHY's with ID
> 0x001cc8XX and 0x001cc9XX so far. Realtek doesn't seem to have such
> a clear separation between PHY and switch PHY ID's.
> 
> Example:
> 0x001cc961 (RTL8366, switch)
> 0x001cc916 (RTL8211F, PHY)
> 
> Last digit of the model is used as model number.
> I did the same and used 5 as model number (from RTL8125).
> Revision number is set to 0 because RTL8125 is brand-new.
> 
> I chose a PHY ID in 0x001ccaXX range because it isn't used by
> Realtek AFAIK.

Hi Heiner

O.K.

This should also be something which is internal. If Realtek do happen
to use the ID, we can change both the MAC and the PHY to an new ID to
avoid the collision.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
