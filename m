Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DF01FEC3D
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 09:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbgFRHSS convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 18 Jun 2020 03:18:18 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:59775 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbgFRHSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 03:18:18 -0400
Received: from localhost (lfbn-tou-1-1075-236.w90-76.abo.wanadoo.fr [90.76.143.236])
        (Authenticated sender: antoine.tenart@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 0CCC6200012;
        Thu, 18 Jun 2020 07:18:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200617093258.52614fd8@kicinski-fedora-PC1C0HJN>
References: <20200617133127.628454-1-antoine.tenart@bootlin.com> <20200617133127.628454-6-antoine.tenart@bootlin.com> <20200617093258.52614fd8@kicinski-fedora-PC1C0HJN>
To:     Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next v2 5/8] net: phy: mscc: 1588 block initialization
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com,
        foss@0leil.net
From:   Antoine Tenart <antoine.tenart@bootlin.com>
Message-ID: <159246469278.467274.10534310212877661795@kwain>
Date:   Thu, 18 Jun 2020 09:18:12 +0200
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub,

Quoting Jakub Kicinski (2020-06-17 18:32:58)
> On Wed, 17 Jun 2020 15:31:24 +0200 Antoine Tenart wrote:
> > +/* Two PHYs share the same 1588 processor and it's to be entirely configured
> > + * through the base PHY of this processor.
> > + */
> > +/* phydev->bus->mdio_lock should be locked when using this function */
> > +static inline int phy_ts_base_write(struct phy_device *phydev, u32 regnum,
> > +                                 u16 val)
> 
> Please don't use static inline outside of headers in networking code.
> The compiler will know best what to inline and when.

I'll remove them.

Thanks,
Antoine

> > +/* phydev->bus->mdio_lock should be locked when using this function */
> > +static inline int phy_ts_base_read(struct phy_device *phydev, u32 regnum)
> > +{
> > +     struct vsc8531_private *priv = phydev->priv;
> > +
> > +     WARN_ON_ONCE(!mutex_is_locked(&phydev->mdio.bus->mdio_lock));
> > +     return __mdiobus_read(phydev->mdio.bus, priv->ts_base_addr, regnum);
> > +}

-- 
Antoine Ténart, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com
