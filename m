Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECEFA4CFFA5
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 14:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242791AbiCGNJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 08:09:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242773AbiCGNJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 08:09:49 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7D08A6DD;
        Mon,  7 Mar 2022 05:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Y1pAQAT+a0HARiqstgx7zeKOv3dhoPYqsfR15bdIcSk=; b=EOb3iEff71UakXpSibnedHS2r+
        BBoxGl/z1wtbVZrpT1EiRiLHrj525TcG5QXS6cwyna497wK3Dxhzu3x1E11SwlY3z2kdocmjAmFzW
        bJA0yFUCpyVSs9Yq5vlaz2X8i5k4c4h916s7+eKMT+fIfRP1ftDp2qmPqYAxupLPWvdI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nRD6Q-009cFX-HD; Mon, 07 Mar 2022 14:08:42 +0100
Date:   Mon, 7 Mar 2022 14:08:42 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Divya.Koppera@microchip.com
Cc:     netdev@vger.kernel.org, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        richardcochran@gmail.com, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, Madhuri.Sripada@microchip.com,
        Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <YiYD2kAFq5EZhU+q@lunn.ch>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-3-Divya.Koppera@microchip.com>
 <YiILJ3tXs9Sba42B@lunn.ch>
 <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO1PR11MB4771237FE3F53EBE43B614F6E2089@CO1PR11MB4771.namprd11.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +
> > > + - lan8814,ignore-ts: If present the PHY will not support timestamping.
> > > +
> > > +     This option acts as check whether Timestamping is supported by
> > > +     hardware or not. LAN8814 phy support hardware tmestamping.
> > 
> > Does this mean the hardware itself cannot tell you it is missing the needed
> > hardware? What happens when you forget to add this flag? Does the driver
> > timeout waiting for hardware which does not exists?
> > 
> 
> If forgot to add this flag, driver will try to register ptp_clock that needs
> access to clock related registers, which in turn fails if those registers doesn't exists.

Thanks for the reply, but you did not answer my question:

  Does this mean the hardware itself cannot tell you it is missing the
  needed hardware?

Don't you have different IDs in register 2 and 3 for those devices
with clock register and those without?

> > > + - lan8814,latency_rx_10: Configures Latency value of phy in ingress at 10
> > Mbps.
> > > +
> > > + - lan8814,latency_tx_10: Configures Latency value of phy in egress at 10
> > Mbps.
> > > +
> > > + - lan8814,latency_rx_100: Configures Latency value of phy in ingress at 100
> > Mbps.
> > > +
> > > + - lan8814,latency_tx_100: Configures Latency value of phy in egress at 100
> > Mbps.
> > > +
> > > + - lan8814,latency_rx_1000: Configures Latency value of phy in ingress at
> > 1000 Mbps.
> > > +
> > > + - lan8814,latency_tx_1000: Configures Latency value of phy in egress at
> > 1000 Mbps.
> > 
> > Why does this need to be configured, rather than hard coded? Why would the
> > latency for a given speed change? I would of thought though you would take
> > the average length of a PTP packet and divide is by the link speed.
> > 
> 
> This latency values could be different for different phy's. So hardcoding will not work here.

But you do actually have hard coded defaults. Those odd hex values i
pointed out.

By different PHYs do you mean different PHY versions? So you can look
at register 2 and 3, determine what PHY it is, and so from that what
defaults should be used? Or do you mean different boards with the same
PHY?

In general, the less tunables you have, the better. If the driver can
figure it out, it is better to not have DT properties. The PHY will
then also work with ACPI and USB etc, where there is no
DT. Implementing the user space API Richard pointed out will also
allow your PHY to work with none DP systems.

> Yes in our case latency values depends on port speed. It is delay between network medium and 
> PTP timestamp point.

What are the units. You generally have the units in the property
name. So e.g. lan8814,latency_tx_1000_ns. If need be, the driver then
converts to whatever value you place into the register.

If you do keep them, please make it clear that these values are
optional, and state what value will be used when the property is not
present.

	Andrew
