Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A812E7A34
	for <lists+netdev@lfdr.de>; Wed, 30 Dec 2020 16:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbgL3PMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Dec 2020 10:12:13 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:44548 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726247AbgL3PMM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Dec 2020 10:12:12 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kud8A-00F2sB-Jo; Wed, 30 Dec 2020 16:11:18 +0100
Date:   Wed, 30 Dec 2020 16:11:18 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marc Zyngier <maz@kernel.org>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?iso-8859-1?Q?Ren=E9?= van Dorst <opensource@vdorst.com>
Subject: Re: Registering IRQ for MT7530 internal PHYs
Message-ID: <X+yYltNeLO+VeNzN@lunn.ch>
References: <20201230042208.8997-1-dqfext@gmail.com>
 <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <441a77e8c30927ce5bc24708e1ceed79@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +static void mt7530_irq_bus_lock(struct irq_data *d)
> > +{
> > +	struct mt7530_priv *priv = irq_data_get_irq_chip_data(d);
> > +
> > +	mutex_lock(&priv->reg_mutex);
> 
> Are you always guaranteed to be in a thread context? I guess that
> is the case, given that you request a threaded interrupt, but
> it would be worth documenting.

Hi Marc

These Ethernet switches are often connected by MDIO, SPI or I2C busses
to the SoC. So in order to access switch registers over these busses,
sleeping is required. So yes, threaded interrupts are required.

	 Andrew
