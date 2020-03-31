Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03417198D9B
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 09:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730242AbgCaHzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 03:55:14 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37328 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729958AbgCaHzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 03:55:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=IjrKeaoW+Y8qn647fMgg9kytpAUbV0tJ8TWzXxWShm0=; b=JzkIVSeuaSGCRh1kAHtrWXjo/
        RPIYVBti8rwGYH/bGlXrvoW+3OfA3c54BDoDq4yowoZMxhGMpFT7otQZ0Y1zzkey8Cna8+2UQFh/G
        boMcsNq5U3/d/Tod7hgQUdTucq9MD2QIU8ZA/PsRNxU7WB/3YYDyBnLazkjsi8iiNABhKTxYJT9Mt
        vayNA13+Ov7Br7ufgfhX8bvCCO4kNjdGbru9sovxWOL+gCDP6e03U4TewxUeXL1mrcYfOyJuIo+bl
        IzVTkb/BbODzRPBGlYFpAIOIX9I9yA87/tVo2Re6xfiLlEqCwBBMX/UplgHJFDU8lG1qYRC0WXo7S
        ulZ7qM+Jg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:39556)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJBjg-00071D-U6; Tue, 31 Mar 2020 08:55:01 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJBjd-0007xI-Lh; Tue, 31 Mar 2020 08:54:57 +0100
Date:   Tue, 31 Mar 2020 08:54:57 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Oleksij Rempel <o.rempel@pengutronix.de>, linux-imx@nxp.com,
        kernel@pengutronix.de, David Jander <david@protonic.nl>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH v2] ARM: imx: allow to disable board specific PHY fixups
Message-ID: <20200331075457.GJ25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <5ae5c0de-f05c-5e3f-86e1-a9afdd3e1ef1@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ae5c0de-f05c-5e3f-86e1-a9afdd3e1ef1@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 09:47:19AM +0200, Marc Kleine-Budde wrote:
> On 3/30/20 7:41 PM, Russell King - ARM Linux admin wrote:
> >>> arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> >>> arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> >>> arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> >>> arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> > 
> > As far as I'm concerned, the AR8035 fixup is there with good reason.
> > It's not just "random" but is required to make the AR8035 usable with
> > the iMX6 SoCs.  Not because of a board level thing, but because it's
> > required for the AR8035 to be usable with an iMX6 SoC.
> 
> Is this still ture, if the AR8035 is attached to a switch behind an iMX6?

Do you know of such a setup, or are you talking about theoretical
situations?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
