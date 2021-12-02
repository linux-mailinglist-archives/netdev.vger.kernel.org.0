Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA8A9466735
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 16:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359276AbhLBPyq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 10:54:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35954 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1359195AbhLBPyf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 10:54:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Yx+V5f2Y2CmU/PSWvT1gzYgAu+XbVxfp4NZtlNjrmX4=; b=aKT8maR+dhKiok7w2/zQUSgpuz
        VPN6hqvV0l6tiUdtcehrNUi/gNI8cuoE0MHoWGxWn8tScuaJ5RPVGgkjzy2/zcAJzcS4SBYHRfEaU
        7HWi4NPcngXr2y8G9t1MWsZOWbU5O+t1+17dNE24mZt6vXahpHVeqxh7C/+jwKSbwMB0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1msoMW-00FL4e-9J; Thu, 02 Dec 2021 16:51:08 +0100
Date:   Thu, 2 Dec 2021 16:51:08 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Holger Brunck <holger.brunck@hitachienergy.com>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Message-ID: <YajrbIDZVvQNVWiJ@lunn.ch>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
 <20211202102541.06b4e361@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202102541.06b4e361@thinkpad>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > diff --git a/Documentation/devicetree/bindings/net/dsa/marvell.txt b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > index 2363b412410c..9292b6f960df 100644
> > --- a/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > +++ b/Documentation/devicetree/bindings/net/dsa/marvell.txt
> > @@ -46,6 +46,11 @@ Optional properties:
> >  - mdio?		: Container of PHYs and devices on the external MDIO
> >  			  bus. The node must contains a compatible string of
> >  			  "marvell,mv88e6xxx-mdio-external"
> > +- serdes-output-amplitude-mv: Configure the output amplitude of the serdes
> > +			      interface in millivolts. This option can be
> > +                              set in the ports node as it is a property of
> > +                              the port.
> > +    serdes-output-amplitude-mv = <210>;
> 
> The suffix should be millivolt, as can be seen in other bindings.

My bad. I recommended that. It does seem like both are used, but
millivolt is more popular.

> Also I think maybe use "tx" instead of "output"? It is more common to
> refere to serdes pairs as rx/tx instead of input/output:
> 
>   serdes-tx-amplitude-millivolt
> 
> I will probably want to add this property also either to mvneta, or to
> A3720 common PHY binding. Andrew, do you think it should be put
> somewhere more generic?

Not sure what the common location would be. I assume for mvneta and
A3720 it is part of the generic phy comphy driver? Does generic phy
have any properties like this already?

Here we are using it in DSA. And it could also be used in a Marvell
phy driver node.

So maybe something like serdes.yaml?
bindings/phy/microchip,sparx5-serdes.yaml actually mentions

  * Tx output amplitude control

but does not define a property for it, but that looks like another use
case for it.

     Andrew
