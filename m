Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 835E122145F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 20:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgGOSiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 14:38:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbgGOSiv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 14:38:51 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jvmIl-005HNy-E8; Wed, 15 Jul 2020 20:38:43 +0200
Date:   Wed, 15 Jul 2020 20:38:43 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH RFC net-next] net: phy: add Marvell PHY PTP support
Message-ID: <20200715183843.GA1256692@lunn.ch>
References: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1jvNlE-0001Y0-47@rmk-PC.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Getting the Kconfig for this correct has been a struggle - particularly
> the combination where PTP support is modular.  It's rather odd to have
> the Marvell PTP support asked before the Marvell PHY support.  I
> couldn't work out any other reasonable way to ensure that we always
> have a valid configuration, without leading to stupidities such as
> having the PTP and Marvell PTP support modular, but non-functional
> because Marvell PHY is built-in.

Hi Russell

How much object code is this adding? All the other PHYs which support
PTP just make it part of the PHY driver, not a standalone module. That
i guess simplifies the conditions. 

Looking at DSDT, it lists

        case MAD_88E1340S:
        case MAD_88E1340:
        case MAD_88E1340M:
        case MAD_SWG65G : 
	case MAD_88E151x:

as being MAD_PHY_PTP_TAI_CAPABLE;

and

	case MAD_88E1548
        case MAD_88E1680:
        case MAD_88E1680M:

as MAD_PHY_1STEP_PTP_CAPABLE;

So maybe we can wire this up to a few more PHYs to 'lower' the
overhead a bit?

> It seems that the Marvell PHY PTP is very similar to that found in
> their DSA chips, which suggests maybe we should share the code, but
> different access methods would be required.

That makes the Kconfig even more complex :-(

     Andrew
