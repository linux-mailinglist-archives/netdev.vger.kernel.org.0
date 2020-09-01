Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878B3258A0A
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726298AbgIAIEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgIAIEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 04:04:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5208CC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 01:04:45 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1HS-0001KG-5e; Tue, 01 Sep 2020 10:04:38 +0200
Received: from mfe by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <mfe@pengutronix.de>)
        id 1kD1HR-0005Qc-On; Tue, 01 Sep 2020 10:04:37 +0200
Date:   Tue, 1 Sep 2020 10:04:37 +0200
From:   Marco Felsch <m.felsch@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk,
        zhengdejin5@gmail.com, richard.leitner@skidata.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 4/5] net: phy: smsc: add phy refclk in support
Message-ID: <20200901080437.w5og2l5toa57wkdk@pengutronix.de>
References: <20200831134836.20189-1-m.felsch@pengutronix.de>
 <20200831134836.20189-5-m.felsch@pengutronix.de>
 <20200831140847.GE2403519@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200831140847.GE2403519@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:01:48 up 290 days, 23:20, 278 users,  load average: 0.17, 0.16,
 0.10
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: mfe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20-08-31 16:08, Andrew Lunn wrote:
> > +	priv->refclk = devm_clk_get_optional(dev, NULL);
> > +	if (IS_ERR(priv->refclk)) {
> > +		if (PTR_ERR(priv->refclk) == -EPROBE_DEFER)
> > +			return -EPROBE_DEFER;
> > +
> > +		/* Clocks are optional all errors should be ignored here */
> > +		return 0;
> 
> Since you are calling devm_clk_get_optional() isn't an error a real
> error, not that the clock is missing? It probably should be returned
> as an error code.

Yes you're right. Actually I can't remember why went this way... I will
change this to dev_err_probe() and this gets a oneliner.

Regards,
  Marco

> 
>    Andrew
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
