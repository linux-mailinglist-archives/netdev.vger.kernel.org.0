Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B730D39D6D2
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 10:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbhFGIPv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Jun 2021 04:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbhFGIPu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 04:15:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C22C061766
        for <netdev@vger.kernel.org>; Mon,  7 Jun 2021 01:13:59 -0700 (PDT)
Received: from lupine.hi.pengutronix.de ([2001:67c:670:100:3ad5:47ff:feaf:1a17] helo=lupine)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lqAOO-0002eo-8s; Mon, 07 Jun 2021 10:13:52 +0200
Received: from pza by lupine with local (Exim 4.92)
        (envelope-from <p.zabel@pengutronix.de>)
        id 1lqAOM-0000nj-Qq; Mon, 07 Jun 2021 10:13:50 +0200
Message-ID: <b2d2a1b09704d09105be75aec04e27b9cc8db116.camel@pengutronix.de>
Subject: Re: [PATCH net-next v3 02/10] net: sparx5: add the basic sparx5
 driver
From:   Philipp Zabel <p.zabel@pengutronix.de>
To:     Steen Hegelund <steen.hegelund@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Mon, 07 Jun 2021 10:13:50 +0200
In-Reply-To: <b215ecea90794688906fb0a6d34636e1e8c1fc3e.camel@microchip.com>
References: <20210604085600.3014532-1-steen.hegelund@microchip.com>
         <20210604085600.3014532-3-steen.hegelund@microchip.com>
         <6a1500fb623e6513e39a468ac53d1caf6a2cf7c5.camel@pengutronix.de>
         <b215ecea90794688906fb0a6d34636e1e8c1fc3e.camel@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2001:67c:670:100:3ad5:47ff:feaf:1a17
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-06-07 at 09:34 +0200, Steen Hegelund wrote:
> Hi Philipp,
> 
> Thanks for your comments.
> 
> On Fri, 2021-06-04 at 11:28 +0200, Philipp Zabel wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > Hi Steen,
> > 
> > On Fri, 2021-06-04 at 10:55 +0200, Steen Hegelund wrote:
> > > This adds the Sparx5 basic SwitchDev driver framework with IO range
> > > mapping, switch device detection and core clock configuration.
> > > 
> > > Support for ports, phylink, netdev, mactable etc. are in the following
> > > patches.
> > > 
> > > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> > > ---
> > >  drivers/net/ethernet/microchip/Kconfig        |    2 +
> > >  drivers/net/ethernet/microchip/Makefile       |    2 +
> > >  drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
> > >  .../net/ethernet/microchip/sparx5/Makefile    |    8 +
> > >  .../ethernet/microchip/sparx5/sparx5_main.c   |  746 +++
> > >  .../ethernet/microchip/sparx5/sparx5_main.h   |  273 +
> > >  .../microchip/sparx5/sparx5_main_regs.h       | 4642 +++++++++++++++++
> > >  7 files changed, 5682 insertions(+)
> > >  create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
> > >  create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
> > >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
> > >  create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
> > > 
> > [...]
> > > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > > b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > > new file mode 100644
> > > index 000000000000..73beb85bc52d
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > > @@ -0,0 +1,746 @@
> > [...]
> > > +static int mchp_sparx5_probe(struct platform_device *pdev)
> > > +{
> > [...]
> > > +
> > > +     sparx5->reset = devm_reset_control_get_shared(&pdev->dev, "switch");
> > > +     if (IS_ERR(sparx5->reset)) {
> > 
> > Could you use devm_reset_control_get_optional_shared() instead of
> > ignoring this error? That would just return NULL if there's no "switch"
> > reset specified in the device tree.
> 
> Yes.  That sounds like a good idea.  I assume that the devm_reset_control_get_optional_shared()
> would also return null if another driver has already performed the reset?

It returns the same (shared) reset control. But the following
reset_control_reset() [1] is a no-op if the control has already
triggered once.

If multiple drivers need to coordinate to trigger the reset more than
once (for example once after suspend/resume), both have to use
reset_control_rearm() [2].

[1] https://www.kernel.org/doc/html/latest/driver-api/reset.html#c.reset_control_reset
[2] https://www.kernel.org/doc/html/latest/driver-api/reset.html#c.reset_control_rearm

regards
Philipp
