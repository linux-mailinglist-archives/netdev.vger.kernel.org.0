Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1165E48C48D
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 14:16:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240976AbiALNO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 08:14:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353425AbiALNO0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 08:14:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=cHTgT2Tsu9i2gMXF7K0U4WJiSWBvuW3RSg4hgZPVSoA=; b=mBOJkwcfvFprApA/v2pXsEbx7n
        MzHtGnG04I0ssWZycG4hGl9gGJVN/VlTrIiD1ExRmxa8OB5N5ZFYF5MWbZv8/N34Mbzd1JboPQPwA
        VtVZsf1WWAG0ny4p0gSpKtjZwcybJRW4+1XJupxjCqPQY42/3OTxILaQVuzLNJV8oo0E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n7dS1-001C6T-Ba; Wed, 12 Jan 2022 14:14:05 +0100
Date:   Wed, 12 Jan 2022 14:14:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     Tim Harvey <tharvey@gateworks.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v6] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <Yd7UHYeAl3wigMmr@lunn.ch>
References: <20210719082756.15733-1-ms@dev.tdt.de>
 <CAJ+vNU3_8Gk8Mj_uCudMz0=MdN3B9T9pUOvYtP7H_B0fnTfZmg@mail.gmail.com>
 <94120968908a8ab073fa2fc0dd56b17d@dev.tdt.de>
 <CAJ+vNU2Bn_eks03g191KKLx5uuuekdqovx000aqcT5=f_6Zq=w@mail.gmail.com>
 <7fe5e3b3ff8fe9375fef409521b93102@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe5e3b3ff8fe9375fef409521b93102@dev.tdt.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If I add a 'genphy_soft_reset(phydev);' at the top of
> > xway_gphy_rgmii_init before the write to XWAY_MDIO_MIICTRL the values
> > do take effect so perhaps that's the proper fix.
> 
> OK, I see that we have to change something here.
> But I would like to avoid a complete reset (BMCR_RESET) if possible.

What does the datasheet say about BMCR_RESET? Some PHYs, like Marvell,
it only resets the internal state machines. Register values are not
changed back to defaults or anything like that. Also for many register
writes in Marvell PHYs the write does not take effect until the next
reset.

So a BMCR_RESET can be the correct thing to do.

   Andrew
