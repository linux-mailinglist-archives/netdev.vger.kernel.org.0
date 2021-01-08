Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7F12EED18
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 06:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbhAHFdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 00:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbhAHFdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 00:33:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BCAC0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 21:32:41 -0800 (PST)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kxkNy-0000mT-UF; Fri, 08 Jan 2021 06:32:30 +0100
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1kxkNw-0001i3-BJ; Fri, 08 Jan 2021 06:32:28 +0100
Date:   Fri, 8 Jan 2021 06:32:28 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v7 net-next 2/2] net: dsa: qca: ar9331: export stats64
Message-ID: <20210108053228.2efctejqxbqijm6l@pengutronix.de>
References: <20210107125613.19046-1-o.rempel@pengutronix.de>
 <20210107125613.19046-3-o.rempel@pengutronix.de>
 <X/ccfY+9a8R6wcJX@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <X/ccfY+9a8R6wcJX@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 06:29:50 up 36 days, 19:36, 16 users,  load average: 0.02, 0.05,
 0.00
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 03:36:45PM +0100, Andrew Lunn wrote:
> > +static void ar9331_get_stats64(struct dsa_switch *ds, int port,
> > +			       struct rtnl_link_stats64 *s)
> > +{
> > +	struct ar9331_sw_priv *priv = (struct ar9331_sw_priv *)ds->priv;
> > +	struct ar9331_sw_port *p = &priv->port[port];
> > +
> > +	spin_lock(&p->stats_lock);
> > +	memcpy(s, &p->stats, sizeof(*s));
> > +	spin_unlock(&p->stats_lock);
> > +}
> 
> This should probably wait until Vladimir's changes for stat64 are
> merged, so this call can sleep. You can then return up to date
> statistics.

Ack, no problem. Beside, i forgot to collect all the Reviewed-by tags.
Will resend all needed changes after Vladimirs patches are accepted.
May be the "net: dsa: add optional stats64 support" can already be
taken?

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
