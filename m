Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7094D3DE8A2
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 10:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234559AbhHCIow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 04:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbhHCIow (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 04:44:52 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D4D4C061764
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 01:44:41 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mAq2M-0006F9-UP; Tue, 03 Aug 2021 10:44:34 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1mAq2L-0001sc-0A; Tue, 03 Aug 2021 10:44:33 +0200
Date:   Tue, 3 Aug 2021 10:44:32 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net 1/1] net: dsa: qca: ar9331: make proper initial port
 defaults
Message-ID: <20210803084432.gvl7dexmhqii6a5s@pengutronix.de>
References: <20210803065424.9692-1-o.rempel@pengutronix.de>
 <20210803081435.2910620-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210803081435.2910620-1-dqfext@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:44:03 up 243 days, 22:50, 25 users,  load average: 0.02, 0.08,
 0.04
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 04:14:35PM +0800, DENG Qingfang wrote:
> On Tue, Aug 03, 2021 at 08:54:24AM +0200, Oleksij Rempel wrote:
> > +	if (dsa_is_cpu_port(ds, port)) {
> > +		/* CPU port should be allowed to communicate with all user
> > +		 * ports.
> > +		 */
> > +		port_mask = dsa_user_ports(ds);
> > +		/* Enable Atheros header on CPU port. This will allow us
> > +		 * communicate with each port separately
> > +		 */
> > +		port_ctrl |= AR9331_SW_PORT_CTRL_HEAD_EN;
> > +	} else if (dsa_is_user_port(ds, port)) {
> > +		/* User ports should communicate only with the CPU port.
> > +		 */
> > +		port_mask = BIT(dsa_to_port(ds, port)->cpu_dp->index);
> > +		port_ctrl |= AR9331_SW_PORT_CTRL_LEARN_EN;
> 
> All user ports should start with address learning disabled.
> To toggle it, implement .port_pre_bridge_flags and .port_bridge_flags.

Ok, thx! Will move it to the separate patch

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
