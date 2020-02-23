Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920D91699E4
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 21:19:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbgBWUTf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 15:19:35 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:56518 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgBWUTf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 15:19:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=VKpyWUJ7gW4E+h1Y5//iHVzFJTXsAhZvji90FqZCHZ0=; b=Bo1BWpsMUXHWoFmIvPDEszdUn
        JEq8dcLY9j8yHx6HijJLxLxZpPJk5BHAkvNiVKvr/FI1rx/ZJbi6VZrMknyTHObwNDOaJkjBhEomn
        TMo/C1bocYASl49lrI5X9yrB+dXHSJCNtxtxepUOlkNDxqadtuByghMavnC/wxprEe1mZKfoNu0m7
        /oJWPyGUvCrwpw3PM+7U5jCrMcqI52rw3oymW4MlBkii1/60Kf1ULuumqjx4zjAjs587EFHHuaRVH
        0pO5uNDqE0DZchOll+pR5DPzkfNhxGgcUvjKR9GF42YvGaWiJ3Cp7A5O1hyIKUZpfWnm4jqnB6h+9
        79ii2fnYQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:44320)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1j5xii-0006sy-HP; Sun, 23 Feb 2020 20:19:20 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1j5xie-0005j2-CE; Sun, 23 Feb 2020 20:19:16 +0000
Date:   Sun, 23 Feb 2020 20:19:16 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/2] net: mdio: add ipq8064 mdio driver
Message-ID: <20200223201916.GO25745@shell.armlinux.org.uk>
References: <20200222161629.1862-1-ansuelsmth@gmail.com>
 <4475595.vek7CkyBFf@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4475595.vek7CkyBFf@debian64>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 12:47:40AM +0100, Christian Lamparter wrote:
> > +static int
> > +ipq8064_mdio_read(struct mii_bus *bus, int phy_addr, int reg_offset)
> > +{
> > +	struct ipq8064_mdio *priv = bus->priv;
> > +	u32 miiaddr = MII_BUSY | MII_CLKRANGE_250_300M;
> > +	u32 ret_val;
> > +	int err;
> > +
> > +	/* Reject clause 45 */
> > +	if (reg_offset & MII_ADDR_C45)
> > +		return -EOPNOTSUPP;
> Heh, C45 on IPQ806X? Ok, anyone know the hardware or is this some fancy
> forward-thinking future-proofing?

Quite simply, the driver as written does not support C45, so it should
reject it, rather than truncating the "reg_offset" and issuing C22
cycles instead.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
