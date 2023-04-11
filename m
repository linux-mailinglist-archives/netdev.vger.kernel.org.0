Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEE8E6DD66D
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 11:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbjDKJSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 05:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjDKJR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 05:17:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DDB3C6
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 02:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=PvU24wAg7X03avgvYAnDnewfP/2QT07BEy8hEg8derY=; b=sR5O56oWGA/ksl5KB5aysBkLSJ
        xJr6XbYSaovca91kyq2PK1aXkOq2UGcvtp/wjCCBCm0Bs3nA3NolrMb7VO6EoDcZ4vWwGP1QtNh/z
        JitDMaRFJpqJGCFRaOZlIuetN9GVM5YsNK3uDzL05Sx4iKCNVugznrbQvyogyF6a43X0YppeIXTnr
        yDlTwPUr37XBqLBrPXeND6/pjnfNbCu1kNaejHBhgjyXuP2g9j4NeDx+eiHJ5eDh6YSvAwTkjTK91
        +rpCTr2PlaunGLSlanlYiPpd8DNlLmNPHN8IGtNN6lkDkMEQVHxcgqoew+bWqs4jYrOledHA7zMUC
        DFa8mIkA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54102)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pmA8L-0005i4-TM; Tue, 11 Apr 2023 10:17:49 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pmA8J-0003yY-2K; Tue, 11 Apr 2023 10:17:47 +0100
Date:   Tue, 11 Apr 2023 10:17:47 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <olteanv@gmail.com>, kernel@pengutronix.de,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: FWD: Re: [PATCH net-next v1 1/1] net: dsa: microchip: ksz8: Make
 flow control, speed, and duplex on CPU port configurable
Message-ID: <ZDUlu4JEQaNhKJDA@shell.armlinux.org.uk>
References: <7055f8c2-3dba-49cd-b639-b4b507bc1249@lunn.ch>
 <ZDBWdFGN7zmF2A3N@shell.armlinux.org.uk>
 <20230411085626.GA19711@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411085626.GA19711@pengutronix.de>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 11, 2023 at 10:56:26AM +0200, Oleksij Rempel wrote:
> On Fri, Apr 07, 2023 at 06:44:20PM +0100, Russell King (Oracle) wrote:
> > On Fri, Apr 07, 2023 at 04:25:57PM +0200, Andrew Lunn wrote:
> > > > +void ksz8_phylink_mac_link_up(struct ksz_device *dev, int port,
> > > > +			      unsigned int mode, phy_interface_t interface,
> > > > +			      struct phy_device *phydev, int speed, int duplex,
> > > > +			      bool tx_pause, bool rx_pause)
> > > > +{
> > > > +	struct dsa_switch *ds = dev->ds;
> > > > +	struct ksz_port *p;
> > > > +	u8 ctrl = 0;
> > > > +
> > > > +	p = &dev->ports[port];
> > > > +
> > > > +	if (dsa_upstream_port(ds, port)) {
> > > > +		u8 mask = SW_HALF_DUPLEX_FLOW_CTRL | SW_HALF_DUPLEX |
> > > > +			SW_FLOW_CTRL | SW_10_MBIT;
> > > > +
> > > > +		if (duplex) {
> > > > +			if (tx_pause && rx_pause)
> > > > +				ctrl |= SW_FLOW_CTRL;
> > > > +		} else {
> > > > +			ctrl |= SW_HALF_DUPLEX;
> > > > +			if (tx_pause && rx_pause)
> > > > +				ctrl |= SW_HALF_DUPLEX_FLOW_CTRL;
> > > > +		}
> > > > +
> > > > +		if (speed == SPEED_10)
> > > > +			ctrl |= SW_10_MBIT;
> > > > +
> > > > +		ksz_rmw8(dev, REG_SW_CTRL_4, mask, ctrl);
> > > > +
> > > > +		p->phydev.speed = speed;
> > > > +	} else {
> > > > +		const u16 *regs = dev->info->regs;
> > > > +
> > > > +		if (duplex) {
> > > > +			if (tx_pause && rx_pause)
> > > > +				ctrl |= PORT_FORCE_FLOW_CTRL;
> > > > +		} else {
> > > > +			if (tx_pause && rx_pause)
> > > > +				ctrl |= PORT_BACK_PRESSURE;
> > > > +		}
> > > > +
> > > > +		ksz_rmw8(dev, regs[P_STP_CTRL], PORT_FORCE_FLOW_CTRL |
> > > > +			 PORT_BACK_PRESSURE, ctrl);
> > 
> > So, I guess the idea here is to enable some form of flow control when
> > both tx and rx pause are enabled.
> > 
> > Here's a bunch of questions I would like answered before I give a tag:
> > 
> > 1) It looks like the device only supports symmetric pause?
> 
> This part of driver supports two family of switches: ksz88xx and
> ksz87xx.
> 
> According to KSZ8765CLX  datasheet:
> Per port, we control pause rx and tx with one bit:
>   Register 18 (0x12): Port 1 Control 2
>   Bit 4 - Force Flow Control
>     1 = Enables Rx and Tx flow control on the port, regardless of the AN result.
>     0 = Flow control is enabled based on the AN result (Default)

Is this more in the MAC register set than the PCS register set?
It's weird that it seems there's no way to force flow control
off.

If it's the PCS register set, then this is partly what the
permit_pause_to_mac boolean in pcs_config() should be used to
control - but that assumes that when !permit_pause_to_mac it
merely stops forwarding the flow control settings to the MAC.

If it's in the MAC register set, this should be controlled by
the MLO_PAUSE_AN bit in state->pause.

However, when those are false, we expect the tx_pause and
rx_pause in mac_link_up() to be respected by the hardware.

> Globally, pause tx and/or rx can be disabled:
> 
>   Register 3 (0x03): Global Control 1
>   Bit 5 - IEEE 802.3x Transmit Flow Control Disable
>     0 = Enables transmit flow control based on AN result.
>     1 = Will not enable transmit flow control regardless of the AN result.
>   Bit 4 - IEEE 802.3x Receive Flow Control Disable
>     0 = Enables receive flow control based on AN result.
>     1 = Will not enable receive flow control regardless of the AN result.
> 
> So, it is possible to configure the entire switch in SYNC or ASYNC mode
> only.

Well, that's a very strange setup. So basically we have no software
control over manually setting the flow control, and we must use
the hardware to pass the AN result to the MAC to have everything
configured correctly.

> Still not sure what role plays autoneg in this configuration:
> 
>   Register 55 (0x37): Port 3 Control 7 (only for ports 3 and 4)
>   Bits 5 - 4 - Advertised_Flow_Control _Capability
>     00 = No pause
>     01 = Symmetric PAUSE
>     10 = Asymmetric PAUSE
>     11 = Both Symmetric PAUSE and Asymmetric
> 
> According to this bits, it is possible to announce both Symmetric
> and Asymmetric PAUSE, but will the switch enable asymmetric mode
> properly if link partner advertise asymmetric too?

These two bits correspond directly with:
ETHTOOL_LINK_MODE_Pause_BIT (for bit 4)
ETHTOOL_LINK_MODE_Asym_Pause_BIT (for bit 5)

IEEE 802.3 has a table in it of the possible resolutions given the
advertisement from both ends. In the case of advertising both, then
the resolutions can be:
- Pause disabled
- Asymmetric pause towards local device (rx enabled, tx disabled)
- Symmetric pause (rx and tx enabled)

It is the responsibility of both ends of the link to implement the
decoding as per 802.3 table 28B-3.

Since we can't manually control the tx and rx pause enables, I think
the only sensible way forward with this would be to either globally
disable pause on the device, and not report support for any pause
modes, or report support for all pause modes, advertise '11' and
let the hardware control it (which means the ethtool configuration
for pause would not be functional.)

This needs to be commented in the driver so that in the future we
remember why this has been done.

Maybe Andrew and/or Vladimir also have an opinion to share about the
best approach here?

Thanks for the clarification from the register set.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
