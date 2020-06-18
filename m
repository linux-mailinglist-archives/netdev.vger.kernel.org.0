Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1F51FFDE3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgFRWV4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:21:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgFRWV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:21:56 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34CB3C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 15:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=8GTaOBUo9g5tzJkfdj/ybXIPgRvV16QIhnhXAJ21S8Q=; b=PZgrugvMwOPAKeY1+BZKEExh1
        YQPzPWdiFAfvS3TWsq1FTcSKwfdYqxurUjMV9YO20R12/dmOkIH7hECWgMi4uQSuWksB9hLlH14ep
        ILhNLCYhQlsJMZ+ORD4cifnYWdmr7hHHRPYzpmL8LkTVe2+/WYn0p20R6XUgyGM88FhIDniHpYF+0
        1CEXuEvwGKu3tsI3bvLePR4CT5HyKo1sxr0wQLQ4VPm1q2psZY0RViRvOTaBFnIN0BDc1gi85dFEA
        oDKaAN+GMWlgr1lRWJmLUf3SyxrVgQJyk2lN/e4FPNkxrHgwMOGD9x9+IjitjR80Gtq2AkcOUXKHr
        OcsOf+33A==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58808)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jm2uw-0005dU-FV; Thu, 18 Jun 2020 23:21:54 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jm2uv-00053u-Pe; Thu, 18 Jun 2020 23:21:53 +0100
Date:   Thu, 18 Jun 2020 23:21:53 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618222153.GL1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618165510.GG1551@shell.armlinux.org.uk>
 <VI1PR0402MB38712F94BAAC32DB1C8AB7F8E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200618220331.GA279339@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618220331.GA279339@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 12:03:31AM +0200, Andrew Lunn wrote:
> > Are there really instances where the ethernet driver has to manage multiple
> > different types of PCSs? I am not sure this type of snippet of code is really
> > going to occur.
> 
> Hi Ioana
> 
> The Marvell mv88e6390 family has three PCS's, one for SGMII/1000BaseX,
> a 10Gbase-X4/X2 and a 10GBAse-R. So this sort of code could appear.

It in fact already does, but only for the 1G and 10GBase-R cases.
We don't have a PHY interface mode for 10Gbase-X4/X2, so I never
added that, but if it happens, we end up with a third case.

It may be tempting to suggest that moving the mv88e6390 PCS support
to common code would be a good idea, but it's really not - the PCS
don't follow IEEE 802.3 register layout.  The 1G registers are in
the PHYXS MMD, following Clause 22 layout at offset 0x2000.  The
10GBASE-R registers are in the PHYXS MMD at offset 0x1000.

So, I don't think it's sensible to compare the mv88e6390 switch
with this; the mv88e6390 serdes PCS is unlikely to be useful
outside of the DSA switch environment.

However, the Lynx PCS appears to be used in a range of different
situations, which include DSA switches and conventional ethernet
drivers.  That means we need some kind of solution where the code
driving the PCS does not rely on the code structures for the
device it is embedded with.

The solution I've suggested for DSA may help us get towards having
generic PCS drivers, but it doesn't fully solve the problem.  I
would ideally like DSA drivers to have access to "struct phylink"
so that they can attach the PCS themselves without having any of
the DSA layering veneers get in the way between phylink and the
PCS code - thereby allowing the PCS code to be re-used cleanly
with a conventional network driver.

Basically, I'm thinking is:

int phylink_attach_pcs(struct phylink *pl, const struct phylink_pcs_ops *ops,
		       void *pcs_priv);

which the PCS driver itself would call when requested to by the
DSA driver or ethernet driver.

Thoughts?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
