Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A3722B088
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 15:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgGWNbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 09:31:39 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727123AbgGWNbj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 09:31:39 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jybJi-006WDr-88; Thu, 23 Jul 2020 15:31:22 +0200
Date:   Thu, 23 Jul 2020 15:31:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>
Cc:     vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Message-ID: <20200723133122.GB1553578@lunn.ch>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 03:59:41PM +1200, Chris Packham wrote:
> Add implementations for the mv88e6xxx switches to connect with the
> generic dsa operations for configuring the port MTU.

Hi Chris

What tree is this against?

commit 2a550aec36543b20f087e4b3063882e9465f7175
Author: Andrew Lunn <andrew@lunn.ch>
Date:   Sat Jul 11 22:32:05 2020 +0200

    net: dsa: mv88e6xxx: Implement MTU change
    
    The Marvell Switches support jumbo packages. So implement the
    callbacks needed for changing the MTU.
    
    Signed-off-by: Andrew Lunn <andrew@lunn.ch>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index d995f5bf0d40..6f019955ae42 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2693,6 +2693,31 @@ static int mv88e6xxx_setup_port(struct mv88e6xxx_chip *chip, int port)
        return mv88e6xxx_port_write(chip, port, MV88E6XXX_PORT_DEFAULT_VLAN, 0);
 }
 
+static int mv88e6xxx_get_max_mtu(struct dsa_switch *ds, int port)
+{
+       struct mv88e6xxx_chip *chip = ds->priv;
+
+       if (chip->info->ops->port_set_jumbo_size)
+               return 10240;
+       return 1522;
+}
+
+static int mv88e6xxx_change_mtu(struct dsa_switch *ds, int port, int new_mtu)
+{
...
	Andrew
