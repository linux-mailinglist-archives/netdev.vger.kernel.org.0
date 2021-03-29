Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83A334C0A7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 02:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhC2ApU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 20:45:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:43576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhC2ApF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Mar 2021 20:45:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 84F5D61922;
        Mon, 29 Mar 2021 00:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616978705;
        bh=zeGCyoboA+q76qGFIXKo8D8OHY96X9ABMRK3z7+6ctU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qaAC7deAHyIDC7WFT6WqscOLdTyu2sBDI0dwWTZr7yvYOWa1kQYhh1uPXkAPJ+VlS
         5qlyPPGn0DsyObbtwbtrhuCXiE8VuufSfndwjUQWidb5RYm43DyCRMRaPiJ2Kyz19m
         VHiekJgu7N3ARXZbNd3OJDI1A/cWkgfyNSLzgsZX3qtZBf67NDLAEvzKhdz7DXytGd
         hxVUSM2mzNWg9qkui4KvN9iY+Ij7+j/K1Ms+vDM5DKI/Rh4l/njk6y/V4cy/O4GFri
         NGhDjR0ffXSw4Jtl8kvVJqcE8+Xtjq+niXZsKy88MdIujvt3TiXsgF07j+XweYcxi+
         ueFB5DzQTmrPA==
Date:   Mon, 29 Mar 2021 08:44:59 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, kernel@pengutronix.de,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com,
        Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH v2 0/7] remove different PHY fixups
Message-ID: <20210329004458.GD22955@dragon>
References: <20210309112615.625-1-o.rempel@pengutronix.de>
 <20210324055424.u4mbdewg4stndzgh@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324055424.u4mbdewg4stndzgh@pengutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 06:54:24AM +0100, Oleksij Rempel wrote:
> Hi Shawn,
> 
> ping, do this patches need some ACK from some one?

As this will break existing DTBs, I need more ACKs from people to see
the consensus that this is the right thing to do.

Shawn

> 
> Regards,
> Oleksij
> 
> On Tue, Mar 09, 2021 at 12:26:08PM +0100, Oleksij Rempel wrote:
> > changes v2:
> > - rebase against latest kernel
> > - fix networking on RIoTBoard
> > 
> > This patch series tries to remove most of the imx6 and imx7 board
> > specific PHY configuration via fixup, as this breaks the PHYs when
> > connected to switch chips or USB Ethernet MACs.
> > 
> > Each patch has the possibility to break boards, but contains a
> > recommendation to fix the problem in a more portable and future-proof
> > way.
> > 
> > regards,
> > Oleksij
> > 
> > Oleksij Rempel (7):
> >   ARM: imx6q: remove PHY fixup for KSZ9031
> >   ARM: imx6q: remove TX clock delay of ar8031_phy_fixup()
> >   ARM: imx6q: remove hand crafted PHY power up in ar8035_phy_fixup()
> >   ARM: imx6q: remove clk-out fixup for the Atheros AR8031 and AR8035
> >     PHYs
> >   ARM: imx6q: remove Atheros AR8035 SmartEEE fixup
> >   ARM: imx6sx: remove Atheros AR8031 PHY fixup
> >   ARM: imx7d: remove Atheros AR8031 PHY fixup
> > 
> >  arch/arm/boot/dts/imx6dl-riotboard.dts  |  2 +
> >  arch/arm/boot/dts/imx6q-dmo-edmqmx6.dts |  2 +-
> >  arch/arm/mach-imx/mach-imx6q.c          | 85 -------------------------
> >  arch/arm/mach-imx/mach-imx6sx.c         | 26 --------
> >  arch/arm/mach-imx/mach-imx7d.c          | 22 -------
> >  5 files changed, 3 insertions(+), 134 deletions(-)
> > 
> > -- 
> > 2.29.2
> > 
> > 
> 
> -- 
> Pengutronix e.K.                           |                             |
> Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
> 31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
