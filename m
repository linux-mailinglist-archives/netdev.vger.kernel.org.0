Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6B228CDF
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 00:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbfEWWSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 18:18:42 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54048 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbfEWWSm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 18:18:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UJPyyNh44s13ewt1UZjcbEcb6jSyME1F4Mxzw3jpWJ8=; b=eCi8gZmuVT+cbetGvduq0SYQUr
        8d3SYP4STycqzYrK37rT/xO8j3CbHK2AHwKUukk9OZ547HDosYSl8LmTQ1RjVomD4X2FKfFkH2eG7
        DcjvS3i9REXx1ZtGggpdU9E38uSzd7dqz/y64A96xqv5PVfwk5XPrP3kHtToEjrqvWKg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hTw2l-0005wO-3i; Fri, 24 May 2019 00:18:35 +0200
Date:   Fri, 24 May 2019 00:18:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 2/9] net: phy: Guard against the presence of
 a netdev
Message-ID: <20190523221835.GB21208@lunn.ch>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523011958.14944-3-ioana.ciornei@nxp.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 01:20:38AM +0000, Ioana Ciornei wrote:
> A prerequisite for PHYLIB to work in the absence of a struct net_device
> is to not access pointers to it.
> 
> Changes are needed in the following areas:
> 
>  - Printing: In some places netdev_err was replaced with phydev_err.
> 
>  - Incrementing reference count to the parent MDIO bus driver: If there
>    is no net device, then the reference count should definitely be
>    incremented since there is no chance that it was an Ethernet driver
>    who registered the MDIO bus.
> 
>  - Sysfs links are not created in case there is no attached_dev.
> 
>  - No netif_carrier_off is done if there is no attached_dev.

Hi Ioana

Looking at the functions changed here, they seem to be related to
phy_attach(), phy_connect(), and phy_detach() etc. Is the intention
you can call these functions and pass a NULL pointer for the
net_device?

	Andrew
