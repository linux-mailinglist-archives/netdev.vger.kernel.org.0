Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5841A2E1EEB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 16:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728209AbgLWPua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 10:50:30 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:38818 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgLWPu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 10:50:29 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1ks6OM-00Dc5c-Q3; Wed, 23 Dec 2020 16:49:34 +0100
Date:   Wed, 23 Dec 2020 16:49:34 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Device Tree List <devicetree@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v2 8/8] arm64: dts: sparx5: Add the Sparx5 switch node
Message-ID: <20201223154934.GE3198262@lunn.ch>
References: <20201217075134.919699-1-steen.hegelund@microchip.com>
 <20201217075134.919699-9-steen.hegelund@microchip.com>
 <20201219202448.GE3026679@lunn.ch>
 <20201223143124.tr2vejqgpf2qsot2@mchp-dev-shegelun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201223143124.tr2vejqgpf2qsot2@mchp-dev-shegelun>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 03:31:24PM +0100, Steen Hegelund wrote:
> On 19.12.2020 21:24, Andrew Lunn wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > > +             port13: port@13 {
> > > +                     reg = <13>;
> > > +                     /* Example: CU SFP, 1G speed */
> > > +                     max-speed = <10000>;
> > 
> > One too many 0's for 1G.
> 
> Ah, but this is allocation for the port, not the speed.

phylib will look for this property and change what the PHY advertises
based on this. There are some devices with Fast Ethernet but with a 1G
PHY, because they are cheaper. By setting max-speed=<100>; phylib will
stop the PHY advertising 1000Base-T/Full and 1000Base-T/Half. I can
imaging the same is used when the MAC can do 2.5G, but the PHY is 5G
capable, etc.

> This just used by the calendar module to allocate slots on the taxis
> as requested.  So I would say it is OK to overallocate in this case
> (but you could argue it does not make much sense).

Rather than misusing the max-speed property, it would be better to add
a property with your specific meaning.

  Andrew
