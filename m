Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43793228379
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 17:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729896AbgGUPUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 11:20:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47476 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728401AbgGUPUM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 11:20:12 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jxu3r-006BfY-CJ; Tue, 21 Jul 2020 17:20:07 +0200
Date:   Tue, 21 Jul 2020 17:20:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Helmut Grohne <helmut.grohne@intenta.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>
Subject: Re: [PATCH v4] net: dsa: microchip: call phy_remove_link_mode during
 probe
Message-ID: <20200721152007.GS1339445@lunn.ch>
References: <20200720204353.GO1339445@lunn.ch>
 <20200721110738.GA9008@laureti-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721110738.GA9008@laureti-dev>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 01:07:39PM +0200, Helmut Grohne wrote:
> When doing "ip link set dev ... up" for a ksz9477 backed link,
> ksz9477_phy_setup is called and it calls phy_remove_link_mode to remove
> 1000baseT HDX. During phy_remove_link_mode, phy_advertise_supported is
> called. Doing so reverts any previous change to advertised link modes
> e.g. using a udevd .link file.
> 
> phy_remove_link_mode is not meant to be used while opening a link and
> should be called during phy probe when the link is not yet available to
> userspace.
> 
> Therefore move the phy_remove_link_mode calls into
> ksz9477_switch_register. It indirectly calls dsa_register_switch, which
> creates the relevant struct phy_devices and we update the link modes
> right after that. At that time dev->features is already initialized by
> ksz9477_switch_detect.
> 
> Remove phy_setup from ksz_dev_ops as no users remain.
> 
> Link: https://lore.kernel.org/netdev/20200715192722.GD1256692@lunn.ch/
> Fixes: 42fc6a4c613019 ("net: dsa: microchip: prepare PHY for proper advertisement")
> Signed-off-by: Helmut Grohne <helmut.grohne@intenta.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
