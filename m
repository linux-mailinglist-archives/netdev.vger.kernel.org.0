Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0AAE401C36
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 15:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241292AbhIFNZH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 09:25:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232694AbhIFNZG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Sep 2021 09:25:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zM7DYcWrFNeOvzT5B/RGXmNq4S28epUTPOEQr+MGMkI=; b=0ngmq+osCfDKWn5ywa8xtd3S6P
        SxGWtV6oh9Zz6f4gd07/3sGxDRHkoQHGRvwMCt9SXN+Xrg63b8bmJbHQziHgOCIHh+8f+Z19x9EeY
        nO33KMNkZy0ZlFtQsTRU0134JWy7TKq6ibb7FasbV7Fe51WKhd3j1ZwuN7Qr50FjzJTA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mNEbF-005VIx-1T; Mon, 06 Sep 2021 15:23:49 +0200
Date:   Mon, 6 Sep 2021 15:23:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: stmmac: fix MAC not working when system resume back
 with WoL enabled
Message-ID: <YTYWZaVJoETikxeF@lunn.ch>
References: <20210903080147.GS22278@shell.armlinux.org.uk>
 <DB8PR04MB679518228AB7B2C5CD47A1B3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903093246.GT22278@shell.armlinux.org.uk>
 <DB8PR04MB6795EE2FA03451AB5D73EFC3E6CF9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20210903120127.GW22278@shell.armlinux.org.uk>
 <20210903201210.GF1350@shell.armlinux.org.uk>
 <DB8PR04MB6795FC58C1D0E2481E2BC35EE6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTXgqBRMRvYdPyJU@shell.armlinux.org.uk>
 <DB8PR04MB67958E22A85B15FFCA7CDA70E6D29@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YTX515RMVNmT4q+o@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTX515RMVNmT4q+o@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> We do have the ability to place the link into the slowest mutually
> supported speed via phy(link)?_speed_down(). This has the advantage of
> reducing the power used to keep the link active while in suspend (which
> is its primary purpose) but also reduces the possible link modes that
> could be autonegotiated with the partner.
> 
> I think I'd suggest to Andrew that phy_speed_down() should only
> advertise one capability, not "everything we support below the minimum
> mutually supported capability" - that way, if a link change is attempted
> on the partner while the system is suspended, the link will not come up
> and its obvious it isn't going to work.

Yes, that sounds reasonable.

> I think this is an issue for a separate patch set.

Yes, i would say a change like that is net-next material.

     Andrew
