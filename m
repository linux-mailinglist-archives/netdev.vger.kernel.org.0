Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082A0427C3E
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbhJIRJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 13:09:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58378 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230006AbhJIRJX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Oct 2021 13:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zuZsEL5r4HUDY8P7sZmSmVljLz2SRdQ8ORvkwmWDmHU=; b=c5UMF+cFzIEHXaylUd+kdMRbVT
        r/mSApLEWE8nK1GCcOI9d3uBZH/ub8er5ht6AV0NIWHEpg0lFxP6MN47YthLfnAm6doTxw39m5Qb+
        KQxg7WoYDYCGWXhF6eGskf0doPixYGREqJ2lfl7x8FvLDaEY8knW/qjEoWhjkEYl7KaM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mZFob-00AAJr-05; Sat, 09 Oct 2021 19:07:17 +0200
Date:   Sat, 9 Oct 2021 19:07:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH v2 08/15] dt-bindings: net: dsa: qca8k: Add MAC
 swap and clock phase properties
Message-ID: <YWHMRMTSa8xP4SKK@lunn.ch>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
 <20211008002225.2426-9-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008002225.2426-9-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 08, 2021 at 02:22:18AM +0200, Ansuel Smith wrote:
> Add names and decriptions of additional PORT0_PAD_CTRL properties.
> Document new binding qca,mac6_exchange that exchange the mac0 port
> with mac6.
> qca,sgmii-(rx|tx)clk-falling-edge are for setting the respective clock
> phase to failling edge.
> 
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/dsa/qca8k.txt | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/qca8k.txt b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> index 9383d6bf2426..208ee5bc1bbb 100644
> --- a/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/qca8k.txt
> @@ -13,6 +13,11 @@ Required properties:
>  Optional properties:
>  
>  - reset-gpios: GPIO to be used to reset the whole device
> +- qca,mac6-exchange: Internally swap MAC0 with MAC6.
> +- qca,sgmii-rxclk-falling-edge: Set the receive clock phase to falling edge.
> +                                Mostly used in qca8327 with CPU port 0 set to
> +                                sgmii.
> +- qca,sgmii-txclk-falling-edge: Set the transmit clock phase to falling edge.
>  - qca,rgmii0-1-8v: Set the internal regulator to supply 1.8v for MAC0 port.
>                     This is needed for qca8337 and toggles the supply voltage
>                     from 1.5v to 1.8v. For the specific regs it was observed

The edge configuration is a port configuration. So it should be inside
the port DT node it applies to. That also gives a clean way forward
when a new switch appears with more SGMII interfaces, each with its
own edge configuration.

But that then leads into the MAC0/MAC6 swap mess. I need to think
about that some more, how do we cleanly describe that in DT.

      Andrew
