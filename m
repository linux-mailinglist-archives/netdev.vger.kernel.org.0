Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10C563D5A3D
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhGZMme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 08:42:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45352 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231874AbhGZMmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 08:42:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cln8cZt4a45Q+2gD5Ec9oJZudPPOflbKRb07A/zKzrc=; b=fiheO5z1YQ5EjOMY91j82ruTYD
        adDb/VIjT9bKb997nvrbWbuLw6djitCXClAY0aT1Mxuu3Ea2Rmwii2G4MDpiE52wzhyb9SsXD8ecO
        tUJPW4g5Do9sURUqjTBNOIYf0jHqfsDuyWfx+jxDpvzM1/mWTzzNtFrEoXz2zuYWo92c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m80ZQ-00Es3q-7x; Mon, 26 Jul 2021 15:23:00 +0200
Date:   Mon, 26 Jul 2021 15:23:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Dan Murphy <dmurphy@ti.com>, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: phy: dp83td510: Add basic support
 for the DP83TD510 Ethernet PHY
Message-ID: <YP63NBaurhQ2Itse@lunn.ch>
References: <20210723104218.25361-1-o.rempel@pengutronix.de>
 <YPrCiIz7baU26kLU@lunn.ch>
 <20210723170848.lh3l62l7spcyphly@pengutronix.de>
 <YPsGddTXtk/Hinmp@lunn.ch>
 <20210726121851.u3flif2opshwgz5e@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210726121851.u3flif2opshwgz5e@pengutronix.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> With current driver ethtool with show this information:
> Settings for eth1:
> 	Supported ports: [ TP	 MII ]
> 	Supported link modes:   Not reported

Interesting. The default function for getting the PHYs abilities is
doing better than i expected. I was guessing you would see 10BaseT
here.

Given that, what you have is O.K. for the moment. 

> > I suspect you are talking about the PoE aspects. That is outside the
> > scope for phylib. PoE in general is not really supported in the Linux
> > kernel, and probably needs a subsystem of its own.
> 
> No, no. I'm talking about data signals configuration (2.4Vpp/1Vpp), which
> depends on application and cable length. 1Vpp should not be used with
> cable over 200 meter

Should not be used, or is not expected to work very well?

> and 2.4Vpp should not be used on safety critical applications. 

Please work with the other T1L driver writer to propose a suitable way
to configure this. We want all T1L drivers to use the same
configuration method, DT properties etc.

	      Andrew
