Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE9B148EF35
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 18:25:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243864AbiANRZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 12:25:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38284 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229758AbiANRZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jan 2022 12:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=JwoliXcJ7ab5c8+F4xKeDTkJ6noi7Vx/K/CQ+XG7ErE=; b=Ez6nvfIec49hV3Dsh4GUYRqhWB
        fGpwDEyw3EXhakHWRoPB9/BpJ9jUnYqugH6S98n+/OQIr1a2ts414G0cdMTQb1mGeBlx5eD1U2mNz
        A3GK7IJTX7datZmfZaoYS9A4Ue3fDF8a08l7vgZVKs5nk1PsjR9haYe5qtzTXDJcQXcY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n8QKb-001Qx9-N6; Fri, 14 Jan 2022 18:25:41 +0100
Date:   Fri, 14 Jan 2022 18:25:41 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Ivan Bornyakov <i.bornyakov@metrotek.ru>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] stmmac: intel: Honor phy LED set by system firmware
 on a Dell hardware
Message-ID: <YeGyFabsBAfzvnU+@lunn.ch>
References: <20220114040755.1314349-1-kai.heng.feng@canonical.com>
 <20220114040755.1314349-2-kai.heng.feng@canonical.com>
 <YeF18mxKuO4/4G0V@lunn.ch>
 <CAAd53p5R2y-2JhWx3wp2=aBypJO=iV7fFS99eAgk6q7KBZMFMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAd53p5R2y-2JhWx3wp2=aBypJO=iV7fFS99eAgk6q7KBZMFMA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > This is a PHY property. Why is the MAC involved?
> 
> This is inspired by commit a93f7fe13454 ("net: phy: marvell: add new
> default led configure for m88e151x") which passes the flag from MAC to
> PHY.

But in this case, the MAC does not care what the LEDs are. The
platform wants them left alone, not the MAC.

> > Please also think about how to make this generic, so any ACPI based
> > system can use it, with any PHY.

...

> So the only approach I can think of is to use DMI match directly in PHY driver.

In the phylib core. And the core then asks the specific PHY driver to
not touch the LED configuration. It is then generic.

      Andrew
