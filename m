Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5153425E8B0
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 17:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbgIEPbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 11:31:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726266AbgIEPbG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 11:31:06 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kEa9d-00DMgG-Ig; Sat, 05 Sep 2020 17:31:01 +0200
Date:   Sat, 5 Sep 2020 17:31:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Paul Barker <pbarker@konsulko.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4] net: dsa: microchip: Add debug print for XMII port
 mode
Message-ID: <20200905153101.GD3164319@lunn.ch>
References: <20200905140325.108846-1-pbarker@konsulko.com>
 <20200905140325.108846-3-pbarker@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200905140325.108846-3-pbarker@konsulko.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 05, 2020 at 03:03:23PM +0100, Paul Barker wrote:
> When debug is enabled for this driver, this allows users to confirm that
> the correct port mode is in use.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>
> ---
>  drivers/net/dsa/microchip/ksz9477.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index a48f5edab561..3e36aa628c9f 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -1211,21 +1211,25 @@ static void ksz9477_port_setup(struct ksz_device *dev, int port, bool cpu_port)
>  		ksz_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
>  		switch (dev->interface) {
>  		case PHY_INTERFACE_MODE_MII:
> +			dev_dbg(dev->dev, "Port%d: MII mode\n", port);
>  			ksz9477_set_xmii(dev, 0, &data8);
>  			ksz9477_set_gbit(dev, false, &data8);
>  			p->phydev.speed = SPEED_100;
>  			break;
>  		case PHY_INTERFACE_MODE_RMII:
> +			dev_dbg(dev->dev, "Port%d: RMII mode\n", port);
>  			ksz9477_set_xmii(dev, 1, &data8);
>  			ksz9477_set_gbit(dev, false, &data8);
>  			p->phydev.speed = SPEED_100;
>  			break;
>  		case PHY_INTERFACE_MODE_GMII:
> +			dev_dbg(dev->dev, "Port%d: GMII mode\n", port);
>  			ksz9477_set_xmii(dev, 2, &data8);
>  			ksz9477_set_gbit(dev, true, &data8);
>  			p->phydev.speed = SPEED_1000;
>  			break;
>  		default:
> +			dev_dbg(dev->dev, "Port%d: RGMII mode\n", port);
>  			ksz9477_set_xmii(dev, 3, &data8);
>  			ksz9477_set_gbit(dev, true, &data8);
>  			data8 &= ~PORT_RGMII_ID_IG_ENABLE;

You could do

dev_dbg(dev->dev, "Port%d: %s\n", port, phy_mode(dev->interface));

just before the switch statement.    

     Andrew
