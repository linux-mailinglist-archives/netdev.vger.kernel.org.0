Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2371CDABC
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:05:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgEKNFF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:05:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53462 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbgEKNFE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:05:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/BkbCLfXmJa4Mhxj45taHyNeShKlZZdwNNPE+B2YLak=; b=ShmrpuzUMEGIiPPOX3SE4xQS08
        NMPGBuBtngosZ4Spk7LCNJD9TOGu6WR/nWUCpW2MTE6f+5U2k6ZZNn9mXi92h9rWSIY2W1miaiANn
        e6uclrhYDObQLK5sdohb+liT1qOMIa2x+TdzrHiM9k18mYBWkrwK59kXnngbZHh0u57g=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jY877-001qyY-9X; Mon, 11 May 2020 15:04:57 +0200
Date:   Mon, 11 May 2020 15:04:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
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
Message-ID: <20200511130457.GC409897@lunn.ch>
References: <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
 <20200508202722.GI298574@lunn.ch>
 <97a9e145-bbaa-efb8-6215-dc3109ee7290@arm.com>
 <20200508234257.GA338317@lunn.ch>
 <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511080040.GC12725@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> NXP's LX2160ARDB platform currently has the following MDIO-PHY connection.
> 
> MDIO-1 ==> one 40G PHY, two 1G PHYs(C45), two 10G PHYs(C22)
> MDIO-2 ==> one 25G PHY

It has been suggested that ACPI only support a one to one
mapping. Each MAC has one MDIO bus, with one PHY on it. KISS.

This clearly does not work for your hardware. So not only do we need
to solve how PHY properties are described, we also need an equivalent
of phy-handle, so a MAC can indicate which PHY it is connected to.

So in effect, you seem to be heading towards a pretty full
reproduction of the DT binding. Before you go too much further and
waste too much of your time, you might want confirmation from the ACPI
people this is not too advanced for what ACPI can do and they tell you
to forget ACPI for this hardware and stick with DT.

   Andrew
