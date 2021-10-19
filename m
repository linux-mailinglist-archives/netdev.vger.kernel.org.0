Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91558432D67
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 07:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbhJSFu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 01:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJSFu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 01:50:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB44C061749
        for <netdev@vger.kernel.org>; Mon, 18 Oct 2021 22:48:46 -0700 (PDT)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mchzF-0004x1-86; Tue, 19 Oct 2021 07:48:33 +0200
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1mchzC-0004ue-Fz; Tue, 19 Oct 2021 07:48:30 +0200
Date:   Tue, 19 Oct 2021 07:48:30 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Rob Herring <robh@kernel.org>
Cc:     alexandru.tachici@analog.com, andrew@lunn.ch, davem@davemloft.net,
        devicetree@vger.kernel.org, hkallweit1@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux@armlinux.org.uk,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] dt-bindings: net: phy: Add 10-baseT1L 2.4 Vpp
Message-ID: <20211019054830.GA16320@pengutronix.de>
References: <20211011142215.9013-1-alexandru.tachici@analog.com>
 <20211011142215.9013-8-alexandru.tachici@analog.com>
 <YW3Fq7WMSB+TL2u4@robh.at.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YW3Fq7WMSB+TL2u4@robh.at.kernel.org>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:32:09 up 243 days,  8:56, 111 users,  load average: 0.35, 0.20,
 0.19
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 18, 2021 at 02:06:19PM -0500, Rob Herring wrote:
> On Mon, Oct 11, 2021 at 05:22:14PM +0300, alexandru.tachici@analog.com wrote:
> > From: Alexandru Tachici <alexandru.tachici@analog.com>
> > 
> > Add a tristate property to advertise desired transmit level.
> > 
> > If the device supports the 2.4 Vpp operating mode for 10BASE-T1L,
> > as defined in 802.3gc, and the 2.4 Vpp transmit voltage operation
> > is desired, property should be set to 1. This property is used
> > to select whether Auto-Negotiation advertises a request to
> > operate the 10BASE-T1L PHY in increased transmit level mode.
> > 
> > If property is set to 1, the PHY shall advertise a request
> > to operate the 10BASE-T1L PHY in increased transmit level mode.
> > If property is set to zero, the PHY shall not advertise
> > a request to operate the 10BASE-T1L PHY in increased transmit level mode.
> > 
> > Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> > ---
> >  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > index 2766fe45bb98..2bb3a96612a2 100644
> > --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> > @@ -77,6 +77,15 @@ properties:
> >      description:
> >        Maximum PHY supported speed in Mbits / seconds.
> >  
> > +  an-10base-t1l-2.4vpp:
> 
> What does 'an' mean?

I assume, it is for Auto Negotiate.

> > +    description: |
> > +      tristate, request/disable 2.4 Vpp operating mode. The values are:
> > +      0: Disable 2.4 Vpp operating mode.
> > +      1: Request 2.4 Vpp operating mode from link partner.
> > +      Absence of this property will leave configuration to default values.
> > +    $ref: "/schemas/types.yaml#/definitions/uint32"
> > +    enum: [0, 1]
> 
> What happened to this one doing the same thing?:
> 
> https://lore.kernel.org/lkml/20201117201555.26723-3-dmurphy@ti.com/

This one was not really synced with the IEEE 802.3 standard. According
to the standard, there is optional 10base-t1l specific 2.4 Vpp operating mode.
To be able to operate in this mode, HW should be designed to do so.
And other way around, if HW is designed for explosive environment, it
should never operate in 2.4 Vpp mode.
So, depending on this property, the ability of the link-partner and user
space configuration, we may allow to auto negotiate this mode.

The question is, should it actually be called "an-", since this property
should limit automatic and manual link configuration

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
