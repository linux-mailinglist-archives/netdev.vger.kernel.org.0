Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BAD2C872A
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbgK3OxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:53:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727151AbgK3OxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:53:00 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7317FC0617A6;
        Mon, 30 Nov 2020 06:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=00hy5+VjqFwiD2syVRyuoORrm6whlaAbkwtX1jJA8To=; b=x4dw/ep/4HrrUswFPw0AW1VXX
        yDtM71P5YxG4Ye9p1sUwdGauhdfv2QK+Uz8//pwIJmTpe8sCz1J1AMsGTbPiboiYVwn7ifOfRO72F
        xebP4pllpdUAJfZBvUR+xmnJCU5X3ukPx9Wi61GGTiV24WMx7+5pRsZ8daUvTf0th+MbKEjBWtkJT
        3lUQsfDflyxbRuXagDkNryQpG3R2A1HKEPXJMv5iDE12+3WHLOnfZWIx6KiJ0L6o+4rwGTBcNwXIY
        buWPIokux2rPUbRiS63JORxOFdUdcvQoOjFZ2f09LSSQAfBcP9JmWg6cY5pFvapsGgUJs1vbQkzKH
        byBSbO4ng==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:38024)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kjkXG-0006wU-MI; Mon, 30 Nov 2020 14:52:14 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kjkXG-00055w-Ci; Mon, 30 Nov 2020 14:52:14 +0000
Date:   Mon, 30 Nov 2020 14:52:14 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microsemi List <microsemi@lists.bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] net: sparx5: Add Sparx5 switchdev driver
Message-ID: <20201130145214.GX1551@shell.armlinux.org.uk>
References: <20201127133307.2969817-1-steen.hegelund@microchip.com>
 <20201127133307.2969817-3-steen.hegelund@microchip.com>
 <20201128190616.GF2191767@lunn.ch>
 <20201128222828.GQ1551@shell.armlinux.org.uk>
 <20201129105245.GG1605@shell.armlinux.org.uk>
 <20201130141556.o4vg32lr4uykwxmu@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201130141556.o4vg32lr4uykwxmu@mchp-dev-shegelun>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 03:15:56PM +0100, Steen Hegelund wrote:
> On 29.11.2020 10:52, Russell King - ARM Linux admin wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Sat, Nov 28, 2020 at 10:28:28PM +0000, Russell King - ARM Linux admin wrote:
> > > On Sat, Nov 28, 2020 at 08:06:16PM +0100, Andrew Lunn wrote:
> > > > > +static void sparx5_phylink_mac_config(struct phylink_config *config,
> > > > > +                               unsigned int mode,
> > > > > +                               const struct phylink_link_state *state)
> > > > > +{
> > > > > + struct sparx5_port *port = netdev_priv(to_net_dev(config->dev));
> > > > > + struct sparx5_port_config conf;
> > > > > + int err = 0;
> > > > > +
> > > > > + conf = port->conf;
> > > > > + conf.autoneg = state->an_enabled;
> > > > > + conf.pause = state->pause;
> > > > > + conf.duplex = state->duplex;
> > > > > + conf.power_down = false;
> > > > > + conf.portmode = state->interface;
> > > > > +
> > > > > + if (state->speed == SPEED_UNKNOWN) {
> > > > > +         /* When a SFP is plugged in we use capabilities to
> > > > > +          * default to the highest supported speed
> > > > > +          */
> > > >
> > > > This looks suspicious.
> > > 
> > > Yes, it looks highly suspicious. The fact that
> > > sparx5_phylink_mac_link_up() is empty, and sparx5_phylink_mac_config()
> > > does all the work suggests that this was developed before the phylink
> > > re-organisation, and this code hasn't been updated for it.
> > > 
> > > Any new code for the kernel really ought to be updated for the new
> > > phylink methodology before it is accepted.
> > > 
> > > Looking at sparx5_port_config(), it also seems to use
> > > PHY_INTERFACE_MODE_1000BASEX for both 1000BASE-X and 2500BASE-X. All
> > > very well for the driver to do that internally, but it's confusing
> > > when it comes to reviewing this stuff, especially when people outside
> > > of the driver (such as myself) reviewing it need to understand what's
> > > going on with the configuration.
> > 
> 
> Hi Russell,
> 
> > There are other issues too.
> > 
> > Looking at sparx5_get_1000basex_status(), we have:
> > 
> > +       status->link = DEV2G5_PCS1G_LINK_STATUS_LINK_STATUS_GET(value) |
> > +                      DEV2G5_PCS1G_LINK_STATUS_SYNC_STATUS_GET(value);
> > 
> 
> > Why is the link status the logical OR of these?
> 
> Oops: It should have been AND. Well spotted.

Do you need to check the sync status? Isn't it impossible to have "link
up" on a link that is unsynchronised?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
