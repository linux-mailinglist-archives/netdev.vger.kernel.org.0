Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB39836FDF3
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbhD3Pmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Apr 2021 11:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhD3Pmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 11:42:51 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19D1C06174A
        for <netdev@vger.kernel.org>; Fri, 30 Apr 2021 08:42:03 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1lcVHA-0005oA-Q4; Fri, 30 Apr 2021 17:41:56 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1lcVH7-0007ic-IQ; Fri, 30 Apr 2021 17:41:53 +0200
Date:   Fri, 30 Apr 2021 17:41:53 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-imx@nxp.com, Fabio Estevam <festevam@gmail.com>,
        David Jander <david@protonic.nl>,
        Russell King <linux@armlinux.org.uk>,
        Philippe Schenker <philippe.schenker@toradex.com>
Subject: Re: [PATCH net-next v1 1/1] net: selftest: provide option to disable
 generic selftests
Message-ID: <20210430154153.zhdnxzkm2fhcuogo@pengutronix.de>
References: <20210430095308.14465-1-o.rempel@pengutronix.de>
 <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f0905c84-6bb2-702f-9ae7-614dcd85c458@infradead.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:34:20 up 149 days,  5:40, 45 users,  load average: 0.06, 0.06,
 0.02
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 30, 2021 at 08:13:12AM -0700, Randy Dunlap wrote:
> On 4/30/21 2:53 AM, Oleksij Rempel wrote:
> > Some systems may need to disable selftests to reduce kernel size or for
> > some policy reasons. This patch provide option to disable generic selftests.
> > 
> > Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Fixes: 3e1e58d64c3d ("net: add generic selftest support")
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > ---
> >  net/Kconfig | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/net/Kconfig b/net/Kconfig
> > index f5ee7c65e6b4..dac98c73fcd8 100644
> > --- a/net/Kconfig
> > +++ b/net/Kconfig
> > @@ -431,7 +431,12 @@ config SOCK_VALIDATE_XMIT
> >  
> >  config NET_SELFTESTS
> >  	def_tristate PHYLIB
> > +	prompt "Support for generic selftests"
> >  	depends on PHYLIB && INET
> > +	help
> > +	  These selftests are build automatically if any driver with generic
> 
> 	                      built
> 
> > +	  selftests support is enabled. This option can be used to disable
> > +	  selftests to reduce kernel size.
> >  
> >  config NET_SOCK_MSG
> >  	bool
> > 
> 
> Thanks for the patch/option. But I think it should just default to n,
> not PHYLIB.

It should be enabled by default for every device supporting this kind of
selftests. This tests extend functionality of cable tests, which are not
optional. Disabling it by default makes even less sense, at least for
me.

It depends on PHYLIB, if PHYLIB is build as module, this
this part should be build as module too. And since Geert asking to make
it optional, I provided this patch.

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
