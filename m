Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3E413306
	for <lists+netdev@lfdr.de>; Tue, 21 Sep 2021 13:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232503AbhIUMAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Sep 2021 08:00:09 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51992 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231778AbhIUMAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Sep 2021 08:00:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dLUlmsxFMiY2KzC0hGB1G/U8+5+iNP4GLzXqVcqKqZ0=; b=LiqIYBHKDmeo8Q5povwZGOdALH
        7dW6J1YHU7y/NYRS97lVV/A3NrI1Vm5vCqVgEmfQpyI/7tKfXgjzeNwUy1S1yYCRiRISq0694iBSa
        79OiY6alYUtH/Hnopgf0RPqevenl7Gt+coUCPGGWJoexMA8VSDtEwNV50iMTxsl1TnOM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mSePs-007ce4-Bm; Tue, 21 Sep 2021 13:58:28 +0200
Date:   Tue, 21 Sep 2021 13:58:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Wolfram Sang <wsa@kernel.org>, linux-i2c@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-spi@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Subject: Re: [PATCH net 1/2] net: dsa: don't allocate the slave_mii_bus using
 devres
Message-ID: <YUnI5JnKHLW05/Ux@lunn.ch>
References: <20210920214209.1733768-1-vladimir.oltean@nxp.com>
 <20210920214209.1733768-2-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920214209.1733768-2-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I _could_ imagine using devres because the condition used on remove is
> different than the condition used on probe. So strictly speaking, DSA
> cannot determine whether the ds->slave_mii_bus it sees on remove is the
> ds->slave_mii_bus that _it_ has allocated on probe. Using devres would
> have solved that problem. But nonetheless, the existing code already
> proceeds to unregister the MDIO bus, even though it might be
> unregistering an MDIO bus it has never registered. So I can only guess
> that no driver that implements ds->ops->phy_read also allocates and
> registers ds->slave_mii_bus itself.

That should not happen. It should be either/or.

But there is no enforcement of that.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
