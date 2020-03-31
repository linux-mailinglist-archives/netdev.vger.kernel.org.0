Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 695BD198E2E
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 10:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730143AbgCaIT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 04:19:27 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:37666 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729997AbgCaIT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 04:19:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=fYhQraFAMqVrGJISSyWmaqJBEQlzF/bEhXFhgru7//g=; b=muFJAbLQuD2T3Rm9JSGJzbEpz
        6QT405MpkY3OE/Gp3IfEKaafkOiA7IxzCnKgctG0/25tdbpjddwDYq/IfNPPZv+dbWUbTesoXvOc8
        tHX+XQRzoNJlqdMgRwvDQ4uGDucwH7bRzrvxc5LxJo4cnGPxdQZo8qPPiky0qSAs2prlnacrL2ybC
        SJWqcVoDLsAh9Rn7wMIqVsCoHHKkCnnOso5pLQoxTCttzydqLEXzXR7NEXi3z4KeAQ71Kxwl/KROJ
        fIhD4aq7XUVwkTuE9h7XzqML9E5meYlku7JfKHb1dMbz+yonaO1v7pgpypSXBT6+ine8tdMNxRlzL
        qBfrA46LA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43706)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJC7E-00079Q-5k; Tue, 31 Mar 2020 09:19:20 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJC7C-0007yQ-VL; Tue, 31 Mar 2020 09:19:18 +0100
Date:   Tue, 31 Mar 2020 09:19:18 +0100
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
Message-ID: <20200331081918.GK25745@shell.armlinux.org.uk>
References: <20200329110457.4113-1-o.rempel@pengutronix.de>
 <20200329150854.GA31812@lunn.ch>
 <20200330052611.2bgu7x4nmimf7pru@pengutronix.de>
 <40209d08-4acb-75c5-1766-6d39bb826ff9@gmail.com>
 <20200330174114.GG25745@shell.armlinux.org.uk>
 <5ae5c0de-f05c-5e3f-86e1-a9afdd3e1ef1@pengutronix.de>
 <20200331075457.GJ25745@shell.armlinux.org.uk>
 <f1352a82-be3a-cd0a-7cba-6f338f205098@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1352a82-be3a-cd0a-7cba-6f338f205098@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 10:00:12AM +0200, Marc Kleine-Budde wrote:
> On 3/31/20 9:54 AM, Russell King - ARM Linux admin wrote:
> > On Tue, Mar 31, 2020 at 09:47:19AM +0200, Marc Kleine-Budde wrote:
> >> On 3/30/20 7:41 PM, Russell King - ARM Linux admin wrote:
> >>>>> arch/arm/mach-imx/mach-imx6q.c:167:		phy_register_fixup_for_uid(PHY_ID_KSZ9021, MICREL_PHY_ID_MASK,
> >>>>> arch/arm/mach-imx/mach-imx6q.c:169:		phy_register_fixup_for_uid(PHY_ID_KSZ9031, MICREL_PHY_ID_MASK,
> >>>>> arch/arm/mach-imx/mach-imx6q.c:171:		phy_register_fixup_for_uid(PHY_ID_AR8031, 0xffffffef,
> >>>>> arch/arm/mach-imx/mach-imx6q.c:173:		phy_register_fixup_for_uid(PHY_ID_AR8035, 0xffffffef,
> >>>
> >>> As far as I'm concerned, the AR8035 fixup is there with good reason.
> >>> It's not just "random" but is required to make the AR8035 usable with
> >>> the iMX6 SoCs.  Not because of a board level thing, but because it's
> >>> required for the AR8035 to be usable with an iMX6 SoC.
> >>
> >> Is this still ture, if the AR8035 is attached to a switch behind an iMX6?
> > 
> > Do you know of such a setup, or are you talking about theoretical
> > situations?
> 
> Granted, not for the AR8035, but for one of the KSZ Phys. This is why
> Oleksij started looking into this issue in the first place.

Maybe there's an easy solution to this - check whether the PHY being
fixed up is connected to the iMX6 SoC:

static bool phy_connected_to(struct phy_device *phydev,
			     const struct of_device_id *matches)
{
	struct device_node *np, *phy_np;

	for_each_matching_node(np, matches) {
		phy_np = of_parse_phandle(np, "phy-handle", 0);
		if (!phy_np)
			phy_np = of_parse_phandle(np, "phy", 0);
		if (!phy_np)
			phy_np = of_parse_phandle(np, "phy-device", 0);
		if (phy_np && phydev->mdio.dev.of_node == phy_np) {
			of_node_put(phy_np);
			of_node_put(np);
			return true;
		}
		of_node_put(phy_np);
	}
	return false;
}

static struct of_device_id imx_fec_ids[] = {
	{ .compatible = "fsl,imx6q-fec", },
	...
	{ },
};

static bool phy_connected_to_fec(struct phy_device *phydev)
{
	return phy_connected_to(phydev, imx_fec_ids);
}

and then in the fixups:

	if (!phy_connected_to_fec(phydev))
		return 0;

?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
