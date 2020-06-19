Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09EF20021C
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgFSGqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:46:24 -0400
Received: from gloria.sntech.de ([185.11.138.130]:59148 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgFSGqY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 02:46:24 -0400
Received: from p5b127c2f.dip0.t-ipconnect.de ([91.18.124.47] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <heiko@sntech.de>)
        id 1jmAn1-0007yi-Au; Fri, 19 Jun 2020 08:46:15 +0200
From:   Heiko Stuebner <heiko@sntech.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christoph.muellner@theobroma-systems.com
Subject: Re: [PATCH v5 2/3] dt-bindings: net: mscc-vsc8531: add optional clock properties
Date:   Fri, 19 Jun 2020 08:46:14 +0200
Message-ID: <1876004.CZoxnk3e8W@phil>
In-Reply-To: <a877e41d-4c3c-c4c2-1875-71e1e08cf977@gmail.com>
References: <20200618121139.1703762-1-heiko@sntech.de> <20200618121139.1703762-3-heiko@sntech.de> <a877e41d-4c3c-c4c2-1875-71e1e08cf977@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Freitag, 19. Juni 2020, 07:01:58 CEST schrieb Florian Fainelli:
> 
> On 6/18/2020 5:11 AM, Heiko Stuebner wrote:
> > From: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > 
> > Some mscc ethernet phys have a configurable clock output, so describe the
> > generic properties to access them in devicetrees.
> > 
> > Signed-off-by: Heiko Stuebner <heiko.stuebner@theobroma-systems.com>
> > ---
> >  Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> > index 5ff37c68c941..67625ba27f53 100644
> > --- a/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> > +++ b/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt
> > @@ -1,6 +1,8 @@
> >  * Microsemi - vsc8531 Giga bit ethernet phy
> >  
> >  Optional properties:
> > +- clock-output-names	: Name for the exposed clock output
> > +- #clock-cells		: should be 0
> >  - vsc8531,vddmac	: The vddmac in mV. Allowed values is listed
> >  			  in the first row of Table 1 (below).
> >  			  This property is only used in combination
> > 
> 
> With that approach, you also need to be careful as a driver writer to
> ensure that you have at least probed the MDIO bus to ensure that the PHY
> device has been created (and therefore it is available as a clock
> provider) if that same Ethernet MAC is a consumer of that clock (which
> it appears to be). Otherwise you may just never probe and be trapped in
> a circular dependency.

Yep - although without anything like this, the phy won't emit any clock
at all. Even when enabling the clock output in u-boot already, when the
kernel starts that config is lost,  so no existing board should break.


As you can see in the discussion about patch 3/3 the wanted solution
is not so clear cut as well. With Rob suggesting this clock-provider way
and Russell strongly encouraging taking a second look.

[My first iteration (till v4) was doing it like other phys by specifying
a property to just tell the phy what frequency to output]

I don't really have a preference for one or the other, so
maybe you can also give a vote over there ;-)

Heiko



