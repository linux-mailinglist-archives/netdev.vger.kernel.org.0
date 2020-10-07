Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746E5285FEE
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728360AbgJGNUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:20:01 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47966 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728177AbgJGNUB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:20:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kQ9MF-000XU4-Qj; Wed, 07 Oct 2020 15:19:51 +0200
Date:   Wed, 7 Oct 2020 15:19:51 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: add ksz9563 to ksz9477 I2C
 driver
Message-ID: <20201007131951.GF56634@lunn.ch>
References: <20201007093049.13078-1-ceggers@arri.de>
 <20201007122107.GA112961@lunn.ch>
 <5079657.ehXnlxHBby@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5079657.ehXnlxHBby@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 03:13:15PM +0200, Christian Eggers wrote:
> Hi Andrew,
> 
> > What chip_id values does it use? I don't see it listed in
> > ksz9477_switch_chips.
> 
> here a short dump of the first chip registers:
> 
> >         Chip ID0     00
> >         Chip ID1_2   9893      Chip ID      9893
> >         Chip ID3     60        Revision ID  6              Reset         normal
> >         Chip ID4     1C        SKU ID       1C
> 
> In ksz9477_switch_detect(), the 32 bit value is built from only
> the 2 middle bytes: 0x00989300. The number of port (3) is also
> assigned within this function:
> 
> > 	if ((id_lo & 0xf) == 3) {
> > 		/* Chip is from KSZ9893 design. */
> > 		dev->features |= IS_9893;
> > 		/* Chip does not support gigabit. */
> > 		if (data8 & SW_QW_ABLE)
> > 			dev->features &= ~GBIT_SUPPORT;
> > 		dev->mib_port_cnt = 3;
> > 		dev->phy_port_cnt = 2;
> > 	} ...
> 
> The chip id 0x00989300 does already exist in ksz9477_switch_chips:
> 
> > 	{
> > 		.chip_id = 0x00989300,
> > 		.dev_name = "KSZ9893",

O.K. Thanks. This is not very clear. Maybe add a follow up patch which
adds some comments?

     Andrew
