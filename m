Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 942A51CDB48
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729548AbgEKNff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726115AbgEKNfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 09:35:34 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A43EC061A0C;
        Mon, 11 May 2020 06:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4r+3UAkxZun2GiEMEOdSxRL5WY7cG+OdzqGyDerOpxs=; b=rxIjZM08c15yrjKydWo5gBieZ
        ySQUQOnMJlYsIf5Kp02hErUicie51HCjpj3Pw0SVcviXsOUWnCNUrIbvJNhl7dUgL09jkzTlUvjbS
        86BmIvqFuruH/3PMBC4Az62cloBykP2F59HdGpnPG13bR+pPFXc9Dupb/yHHa4RSb17z4XI9fZuNW
        bLv1xp6gg9tyySLU34eY8OhYA4tJfeQlTokGFPwxoewoulLOuyjJIZKFgG8E4WK91R9PuotF94K/T
        7EOSuNwnmduOJa9t1Zk5Pl7s0+B3AQL+5B3JXz6wWkzRLTroJlxm+77EEv/IFvgqPU7jMQB+d5gMF
        U8SLAF0OA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:56642)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jY8aO-0006Mz-4y; Mon, 11 May 2020 14:35:12 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jY8aK-0005iI-Ji; Mon, 11 May 2020 14:35:08 +0100
Date:   Mon, 11 May 2020 14:35:08 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>, linux.cj@gmail.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200511133508.GU1551@shell.armlinux.org.uk>
References: <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
 <20200511130457.GC409897@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511130457.GC409897@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 03:04:57PM +0200, Andrew Lunn wrote:
> > NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> > 
> > MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> > MDIO-2 ==> one 25G PHY
> 
> It has been suggested that ACPI only support a one to one
> mapping. Each MAC has one MDIO bus, with one PHY on it. KISS.
> 
> This clearly does not work for your hardware. So not only do we need
> to solve how PHY properties are described, we also need an equivalent
> of phy-handle, so a MAC can indicate which PHY it is connected to.

I'd suggest that doesn't work for a lot of hardware. It won't work for
the Macchiatobin for example, where there are two Clause 45 NBASE-T
PHYs on one MDIO bus.

The same is likely true on the LX2160A - there can be multiple ethernet
interfaces, but IIRC only two external MDIO buses that one can hang
PHYs off of.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
