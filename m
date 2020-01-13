Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B83B139386
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 15:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728885AbgAMOS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 09:18:28 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33560 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgAMOS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 09:18:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1JaluUo2JMQHJEK4hMt/lTHqq99YJUSuwhQgO7c6ABc=; b=TXMWxcn0Z+5mlJfWL/HJnzpNY
        SlcyIvUI8KhnXpC+Ko+zHOsKfyCASQ+iuNkFvBH+naC25/fZT2SIvvHUYbNAw+nHti4KXegdwHlyo
        0Vjc9L/5dcd853Cq/ReCu8wTvPMiBA/YoiJ+NPbEXK8e1qXGqDRkQxve0vJ18n0wGYqzf+BMf9x5n
        jV+AS2ZCJ0PDysFX6buTXeBFJmgqkvYZ3eZlspE4Kae2rVBZSHNrbIvo6QiWKnqOkoN1ofLMr5yne
        AQ74g0kpTKwT7kMe9QXn+Y4y7Dd0+i+m/tcBCwQRRCHGRo6WfI38RKg/GNW/St/WzCDDnItwU5x2o
        A2e8vzduw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:33708)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ir0Xs-0004mt-Ip; Mon, 13 Jan 2020 14:18:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ir0Xp-0004VV-Fx; Mon, 13 Jan 2020 14:18:17 +0000
Date:   Mon, 13 Jan 2020 14:18:17 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Message-ID: <20200113141817.GN25745@shell.armlinux.org.uk>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 13, 2020 at 01:54:28PM +0000, Jose Abreu wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Jan/13/2020, 13:38:45 (UTC+00:00)
> 
> > On Mon, Jan 13, 2020 at 02:11:08PM +0100, Jose Abreu wrote:
> > > Adds the basic support for XPCS including support for USXGMII.
> > 
> > Hi Jose
> > 
> > Please could you describe the 'big picture'. What comes after the
> > XPCS? An SFP? A copper PHY? How in Linux do you combine this PHY and
> > whatever comes next using PHYLINK?
> > 
> > Or do only support backplane with this, and the next thing in the line
> > is the peers XPCS?
> 
> My current setup is this:
> 
> Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> QSFP+
> 
> The only piece that needs configuration besides XGMAC is the XPCS hereby 
> I "called" it a PHY ... Anyway, this is an RFC because I'm not entirely 
> sure about the approach. Hmm ?

I don't seem to have been copied on the original mail, so I'm jumping
in blind here.

In phylink, the mac_pcs_get_state() method is supposed to read from
the PCS - in your case, the XPCS.  This wasn't obvious when phylink
was first submitted, especially as mvneta and mvpp2 don't offer
802.3 MDIO compliant PCS interfaces.  Hence the recent change in
naming of that method.

I've recently suggested a patch to phylink to add a generic helper to
read the state from a generic 802.3 clause 37 PCS, but I guess that
won't be sufficient for an XPCS.  However, it should give some clues
if you're intending to use phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
