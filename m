Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AB91886C7
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgCQOEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:04:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40840 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgCQOEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:04:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ULONFoFy52YeIq0i+dbx5LG9OZ6+gxXYBBy7AX4SKfw=; b=tGznDHFIeW8VhzIHSfbLqJ1+wr
        j2UUnERSAtKsQ4z8PekGZm1l89ill9A6WnaQUchaxwOhvzjLQWojgtb7kBcTm0JiZYHGnqBcu9hju
        k00Pg7Am1r5+MhG/nB9MazCvE2TrOadbXhR+F54Bj52E3WDPRBhs3fmS8YxuuSj2rgQU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jECpW-0006lI-Pw; Tue, 17 Mar 2020 15:04:26 +0100
Date:   Tue, 17 Mar 2020 15:04:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, linux.cj@gmail.com,
        Jon Nettleton <jon@solid-run.com>, linux@armlinux.org.uk,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, pankaj.bansal@nxp.com,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/7] mdio_bus: Introduce fwnode MDIO helpers
Message-ID: <20200317140426.GR24270@lunn.ch>
References: <20200131153440.20870-1-calvin.johnson@nxp.com>
 <20200131153440.20870-2-calvin.johnson@nxp.com>
 <20200317113650.GA6016@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317113650.GA6016@lsv03152.swis.in-blr01.nxp.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 17, 2020 at 05:06:50PM +0530, Calvin Johnson wrote:
> Hi,
> 
> On Fri, Jan 31, 2020 at 09:04:34PM +0530, Calvin Johnson wrote:
> 
> <snip>
> 
> > +/**
> > + * fwnode_mdiobus_child_is_phy - Return true if the child is a PHY node.
> > + * It must either:
> > + * o Compatible string of "ethernet-phy-ieee802.3-c45"
> > + * o Compatible string of "ethernet-phy-ieee802.3-c22"
> > + * Checking "compatible" property is done, in order to follow the DT binding.
> > + */
> > +static bool fwnode_mdiobus_child_is_phy(struct fwnode_handle *child)
> > +{
> > +	int ret;
> > +
> > +	ret = fwnode_property_match_string(child, "compatible",
> > +					   "ethernet-phy-ieee802.3-c45");
> > +	if (!ret)
> > +		return true;
> > +
> > +	ret = fwnode_property_match_string(child, "compatible",
> > +					   "ethernet-phy-ieee802.3-c22");
> > +	if (!ret)
> > +		return true;
> > +
> > +	if (!fwnode_property_present(child, "compatible"))
> > +		return true;
> > +
> > +	return false;
> > +}
> 
> Can we use _CID in ACPI to get the compatible string? Is there any other method
> to handle this kind of situation where we would like to pass C45 or C22 info to
> the mdiobus driver?

Hi Calvin

Is there any defacto standardised way to stuff this device tree
property into ACPI? It is one of the key properties, so either there
is one standard way, or lots of variants because nobody can be
bothered to go to the ACPI standardisation body and get it formalised.

     Andrew
