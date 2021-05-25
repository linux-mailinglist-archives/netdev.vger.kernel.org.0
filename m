Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 795373901F6
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhEYNSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:18:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56174 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233039AbhEYNS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 May 2021 09:18:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XhIVo0mgfMzn/7oVvcVx8d0Dkd+SkYL6LVHz31eZXIE=; b=tA9zive5G6WKqgqOL1eoaF/94v
        99eqC4lVGavaJSmXJhKHLsT81bjRP0xhfgwwQwaPzey0Cl15O/v26Vl4rbFkaqwot7dVyGV/6RS4T
        jbi0h70xuPXkFOxO03mF8nPpIIpiQPC/GpOLSpAys0oVFTDIK5o3+I846P2oKq2uGhfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1llWvU-006Aot-Av; Tue, 25 May 2021 15:16:52 +0200
Date:   Tue, 25 May 2021 15:16:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next 11/13] net: dsa: sja1105: register the MDIO
 buses for 100base-T1 and 100base-TX
Message-ID: <YKz4xA3QNIoEv5pp@lunn.ch>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-12-olteanv@gmail.com>
 <YKxecB8aDJ4m5x7R@lunn.ch>
 <20210525115429.6bj4pvmudur3ixyy@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210525115429.6bj4pvmudur3ixyy@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It however sounds like you have the two busses one level deeper?
> > 
> > It would be good if you document this as part of the binding.
> 
> Yes, it looks like this:
> 
> 	ethernet-switch@2 {
> 		compatible = "nxp,sja1110a";
> 
> 		ethernet-ports {
> 			...
> 		};
> 
> 		mdio {
> 			#address-cells = <1>;
> 			#size-cells = <0>;
> 
> 			mdio@0 {
> 				reg = <0>;
> 				compatible = "nxp,sja1110-base-t1-mdio";
> 				#address-cells = <1>;
> 				#size-cells = <0>;
> 
> 				sw2_port5_base_t1_phy: ethernet-phy@1 {
> 					compatible = "ethernet-phy-ieee802.3-c45";
> 					reg = <0x1>;
> 				};
> 
> 				...
> 			};
> 

We should run this by Rob.

That is probably not the intention of
Documentation/devicetree/bindings/net/mdio.yaml, it works because of
additionalProperties: true

What meaning does reg have, in mdio@0?

     Andrew
