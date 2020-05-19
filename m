Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7D01D94CD
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 12:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726880AbgESK7H convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 19 May 2020 06:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726121AbgESK7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 06:59:06 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F27C061A0C
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 03:59:06 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jazxb-0006x7-NN; Tue, 19 May 2020 12:58:59 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jazxX-0007S2-2B; Tue, 19 May 2020 12:58:55 +0200
Date:   Tue, 19 May 2020 12:58:55 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, Marek Vasut <marex@denx.de>,
        Christian Herber <christian.herber@nxp.com>
Subject: Re: [PATCH net-next v1 1/2] ethtool: provide UAPI for PHY Signal
 Quality Index (SQI)
Message-ID: <20200519105855.p7nqklhwotueloko@pengutronix.de>
References: <20200519075200.24631-1-o.rempel@pengutronix.de>
 <20200519085520.GB9046@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200519085520.GB9046@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:20:58 up 186 days,  1:39, 196 users,  load average: 0.08, 0.08,
 0.06
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 10:55:20AM +0200, Michal Kubecek wrote:
> On Tue, May 19, 2020 at 09:51:59AM +0200, Oleksij Rempel wrote:
> > Signal Quality Index is a mandatory value required by "OPEN Alliance
> > SIG" for the 100Base-T1 PHYs [1]. This indicator can be used for cable
> > integrity diagnostic and investigating other noise sources and
> > implement by at least two vendors: NXP[2] and TI[3].
> > 
> > [1] http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
> > [2] https://www.nxp.com/docs/en/data-sheet/TJA1100.pdf
> > [3] https://www.ti.com/product/DP83TC811R-Q1
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  Documentation/networking/ethtool-netlink.rst |  1 +
> >  include/linux/phy.h                          |  1 +
> >  include/uapi/linux/ethtool.h                 | 11 +++++++++
> >  include/uapi/linux/ethtool_netlink.h         |  1 +
> >  net/ethtool/common.c                         | 10 ++++++++
> >  net/ethtool/common.h                         |  1 +
> >  net/ethtool/linkstate.c                      | 25 +++++++++++++++++++-
> >  7 files changed, 49 insertions(+), 1 deletion(-)
> > 
> > diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
> > index eed46b6aa07df..4485e622182fc 100644
> > --- a/Documentation/networking/ethtool-netlink.rst
> > +++ b/Documentation/networking/ethtool-netlink.rst
> > @@ -457,6 +457,7 @@ Kernel response contents:
> >    ====================================  ======  ==========================
> >    ``ETHTOOL_A_LINKSTATE_HEADER``        nested  reply header
> >    ``ETHTOOL_A_LINKSTATE_LINK``          bool    link state (up/down)
> > +  ``ETHTOOL_A_LINKSTATE_SQI``           u8      Current Signal Quality Index
> >    ====================================  ======  ==========================
> >  
> >  For most NIC drivers, the value of ``ETHTOOL_A_LINKSTATE_LINK`` returns
> 
> IIRC you need to update table markers (the "===" lines) so that cell
> text does not overflow. Did you check it with "make htmldocs"?

yes. Seems to look OK.

> > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > index 59344db43fcb1..b2fd230460d77 100644
> > --- a/include/linux/phy.h
> > +++ b/include/linux/phy.h
> > @@ -706,6 +706,7 @@ struct phy_driver {
> >  			    struct ethtool_tunable *tuna,
> >  			    const void *data);
> >  	int (*set_loopback)(struct phy_device *dev, bool enable);
> > +	int (*get_sqi)(struct phy_device *dev);
> >  };
> >  #define to_phy_driver(d) container_of(to_mdio_common_driver(d),		\
> >  				      struct phy_driver, mdiodrv)
> > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > index f4662b3a9e1ef..e55caacd1886c 100644
> > --- a/include/uapi/linux/ethtool.h
> > +++ b/include/uapi/linux/ethtool.h
> > @@ -1678,6 +1678,17 @@ static inline int ethtool_validate_duplex(__u8 duplex)
> >  #define MASTER_SLAVE_STATE_SLAVE		3
> >  #define MASTER_SLAVE_STATE_ERR			4
> >  
> > +#define SQI_STATE_UNSUPPORTED			0
> > +#define SQI_STATE_0				1
> > +#define SQI_STATE_1				2
> > +#define SQI_STATE_2				3
> > +#define SQI_STATE_3				4
> > +#define SQI_STATE_4				5
> > +#define SQI_STATE_5				6
> > +#define SQI_STATE_6				7
> > +#define SQI_STATE_7				8
> > +#define SQI_STATE_8				9
> > +
> >  /* Which connector port. */
> >  #define PORT_TP			0x00
> >  #define PORT_AUI		0x01
> 
> The shift by one between actual SQI values and attribute values is IMHO
> quite confusing for anyone looking at the messages. As the UNSUPPORTED
> value is only internal (the attribute is omitted in reply message in
> such case), perhaps we could use int for linkstate_reply_data::sqi and
> e.g. -1 for "unsupported". Then we could use native 0-7 range

OK

> (SQI_STATE_8=9 is probably a mistake).

yes.

> I'm also a bit worried about hardcoding the 0-7 value range. While I
> understand that it's defined by standard for 100base-T1, we my want to
> provide such information for other devices in the future. I tried to
> search if there is something like that for 1000base-T1 and found this:
> 
>   http://www.sigent.cn/wp-content/uploads/2019/12/TE-1400_User-Manual_1000BASE-T1-EMC-Converter_v3.3.pdf
> 
> The screenshot on page 10 shows "SQI Value: 00015".

Nice, screenshot based reverse engineering :)

> It's probably not
> standardized (yet?) but it seems to indicate we may expect other devices
> providing SQI information with different value range.

what maximal range do we wont to export? u8, u16 or u32?

> Would it make sense to add ETHTOOL_A_LINKSTATE_SQI_MAX attribute telling
> userspace what the range is?

sounds plausible.

> [...]
> > diff --git a/net/ethtool/common.c b/net/ethtool/common.c
> > index 423e640e3876d..f3c905e59124f 100644
> > --- a/net/ethtool/common.c
> > +++ b/net/ethtool/common.c
> > @@ -310,6 +310,16 @@ int __ethtool_get_link(struct net_device *dev)
> >  	return netif_running(dev) && dev->ethtool_ops->get_link(dev);
> >  }
> >  
> > +int __ethtool_get_sqi(struct net_device *dev)
> > +{
> > +	struct phy_device *phydev = dev->phydev;
> > +
> > +	if (!phydev->drv->get_sqi)
> 
> You should check phydev for NULL first.

ok.

> Michal
> 
> > +		return -EOPNOTSUPP;
> > +
> > +	return phydev->drv->get_sqi(phydev);
> > +}
> > +
> >  int ethtool_get_max_rxfh_channel(struct net_device *dev, u32 *max)
> >  {
> >  	u32 dev_size, current_max = 0;
> 

Regards,
Oleksij

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
