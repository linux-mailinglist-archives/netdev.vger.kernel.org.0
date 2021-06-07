Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3487C39D665
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 09:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbhFGH5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 03:57:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGH5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 03:57:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C37C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 00:56:02 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lqA75-0008DB-Uy; Mon, 07 Jun 2021 09:55:59 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lqA74-0006om-IB; Mon, 07 Jun 2021 09:55:58 +0200
Date:   Mon, 7 Jun 2021 09:55:58 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1 5/7] net: usb: asix: add error handling for
 asix_mdio_* functions
Message-ID: <20210607075558.ynlzlgwl7mipre7r@pengutronix.de>
References: <20210604134244.2467-1-o.rempel@pengutronix.de>
 <20210604134244.2467-6-o.rempel@pengutronix.de>
 <YLq3wuAMvljqEJbn@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YLq3wuAMvljqEJbn@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:55:41 up 186 days, 22:02, 44 users,  load average: 0.12, 0.11,
 0.09
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 01:31:14AM +0200, Andrew Lunn wrote:
> > -void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
> > +static int __asix_mdio_write(struct net_device *netdev, int phy_id, int loc,
> > +			     int val)
> >  {
> >  	struct usbnet *dev = netdev_priv(netdev);
> >  	__le16 res = cpu_to_le16(val);
> > @@ -517,13 +522,24 @@ void asix_mdio_write(struct net_device *netdev, int phy_id, int loc, int val)
> >  	} while (!(smsr & AX_HOST_EN) && (i++ < 30) && (ret != -ENODEV));
> >  	if (ret == -ENODEV) {
> >  		mutex_unlock(&dev->phy_mutex);
> > -		return;
> > +		return ret;
> 
> Now that you have added an out: it might be better to use a goto?

ack, done

> Otherwise
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
>     Andrew
> 
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
