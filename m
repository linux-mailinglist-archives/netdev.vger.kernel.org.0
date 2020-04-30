Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE21A1BF7EE
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 14:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgD3MJz convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 30 Apr 2020 08:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726515AbgD3MJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 08:09:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5FEC035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 05:09:54 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jU80j-0004eL-2T; Thu, 30 Apr 2020 14:09:49 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jU80f-0000EE-BC; Thu, 30 Apr 2020 14:09:45 +0200
Date:   Thu, 30 Apr 2020 14:09:45 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Marek Vasut <marex@denx.de>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        mkl@pengutronix.de, kernel@pengutronix.de,
        David Jander <david@protonic.nl>,
        Jakub Kicinski <kuba@kernel.org>,
        Christian Herber <christian.herber@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 1/2] ethtool: provide UAPI for PHY
 master/slave configuration.
Message-ID: <20200430120945.GA7370@pengutronix.de>
References: <20200428075308.2938-1-o.rempel@pengutronix.de>
 <20200428075308.2938-2-o.rempel@pengutronix.de>
 <20200429195222.GA17581@lion.mk-sys.cz>
 <20200430050058.cetxv76pyboanbkz@pengutronix.de>
 <20200430082020.GC17581@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20200430082020.GC17581@lion.mk-sys.cz>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:03:23 up 232 days, 51 min, 517 users,  load average: 22.23,
 19.35, 22.10
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

On Thu, Apr 30, 2020 at 10:20:20AM +0200, Michal Kubecek wrote:
> On Thu, Apr 30, 2020 at 07:00:58AM +0200, Oleksij Rempel wrote:
> > > > diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
> > > > index 92f737f101178..eb680e3d6bda5 100644
> > > > --- a/include/uapi/linux/ethtool.h
> > > > +++ b/include/uapi/linux/ethtool.h
> > > > @@ -1666,6 +1666,31 @@ static inline int ethtool_validate_duplex(__u8 duplex)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +/* Port mode */
> > > > +#define PORT_MODE_CFG_UNKNOWN		0
> > > > +#define PORT_MODE_CFG_MASTER_PREFERRED	1
> > > > +#define PORT_MODE_CFG_SLAVE_PREFERRED	2
> > > > +#define PORT_MODE_CFG_MASTER_FORCE	3
> > > > +#define PORT_MODE_CFG_SLAVE_FORCE	4
> > > > +#define PORT_MODE_STATE_UNKNOWN		0
> > > > +#define PORT_MODE_STATE_MASTER		1
> > > > +#define PORT_MODE_STATE_SLAVE		2
> > > > +#define PORT_MODE_STATE_ERR		3
> > > 
> > > You have "MASTER_SLAVE" or "master_slave" everywhere but "PORT_MODE" in
> > > these constants which is inconsistent.
> > 
> > What will be preferred name?
> 
> Not sure, that would be rather question for people more familiar with
> the hardware. What I wanted to say is that whether we use "master_slave"
> or "port_mode", we should use the same everywhere.

Ok, I rename it all to MASTER_SLAVE prefix. It is the only common name
across the all documentations.

> > > > +
> > > > +static inline int ethtool_validate_master_slave_cfg(__u8 cfg)
> > > > +{
> > > > +	switch (cfg) {
> > > > +	case PORT_MODE_CFG_MASTER_PREFERRED:
> > > > +	case PORT_MODE_CFG_SLAVE_PREFERRED:
> > > > +	case PORT_MODE_CFG_MASTER_FORCE:
> > > > +	case PORT_MODE_CFG_SLAVE_FORCE:
> > > > +	case PORT_MODE_CFG_UNKNOWN:
> > > > +		return 1;
> > > > +	}
> > > > +
> > > > +	return 0;
> > > > +}
> > > 
> > > Should we really allow CFG_UNKNOWN in client requests? As far as I can
> > > see, this value is handled as no-op which should be rather expressed by
> > > absence of the attribute. Allowing the client to request a value,
> > > keeping current one and returning 0 (success) is IMHO wrong.
> > 
> > ok
> > 
> > > Also, should this function be in UAPI header?
> > 
> > It is placed together with other validate functions:
> > ethtool_validate_duplex
> > ethtool_validate_speed
> > 
> > Doing it in a different place, would be inconsistent.
> 
> Those two have been there since "ever". The important question is if we
> want this function to be provided to userspace as part of UAPI (which
> would also limit our options for future modifications.

good argument. Moved it to other location.

> > 
> > > [...]
> > > > @@ -119,7 +123,12 @@ static int linkmodes_fill_reply(struct sk_buff *skb,
> > > >  	}
> > > >  
> > > >  	if (nla_put_u32(skb, ETHTOOL_A_LINKMODES_SPEED, lsettings->speed) ||
> > > > -	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex))
> > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_DUPLEX, lsettings->duplex) ||
> > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_CFG,
> > > > +		       lsettings->master_slave_cfg) ||
> > > > +	    nla_put_u8(skb, ETHTOOL_A_LINKMODES_MASTER_SLAVE_STATE,
> > > > +		       lsettings->master_slave_state))
> > > > +
> > > >  		return -EMSGSIZE;
> > > 
> > > From the two handlers you introduced, it seems we only get CFG_UNKNOWN
> > > or STATE_UNKNOWN if driver or device does not support the feature at all
> > > so it would be IMHO more appropriate to omit the attribute in such case.
> > 
> > STATE_UNKNOWN is returned if link is not active.
> 
> How about distinguishing the two cases then? Omitting both if CFG is
> CFG_UNKNOWN (i.e. driver does not support the feature) and sending
> STATE=STATE_UNKNOWN to userspace only if we know it's a meaningful value
> actually reported by the driver?

Hm... after thinking about it, we should keep state and config
separately. The TJA1102 PHY do not provide actual state. Even no error
related to Master/Master conflict. I reworked the code to have
unsupported and unknown values.  In case we know, that state or config
is not supported, it will not be exported to the user space.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
