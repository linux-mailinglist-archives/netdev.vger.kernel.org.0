Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8249A1FF39F
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbgFRNrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:47:10 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46798 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728159AbgFRNrJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:47:09 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jlusi-0017YB-PG; Thu, 18 Jun 2020 15:47:04 +0200
Date:   Thu, 18 Jun 2020 15:47:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [RFC PATCH 9/9] dt-bindings: net: dsa: Add documentation for
 Hellcreek switches
Message-ID: <20200618134704.GQ249144@lunn.ch>
References: <20200618064029.32168-1-kurt@linutronix.de>
 <20200618064029.32168-10-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618064029.32168-10-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +Ethernet switch connected memory mapped to the host, CPU port wired to gmac0:
> +
> +soc {
> +        switch0: switch@0xff240000 {
> +                compatible = "hirschmann,hellcreek";
> +                status = "okay";
> +                reg = <0xff240000 0x1000   /* TSN base */
> +                       0xff250000 0x1000>; /* PTP base */
> +                dsa,member = <0 0>;
> +
> +                ports {
> +                        #address-cells = <1>;
> +                        #size-cells = <0>;
> +
> +                        port@0 {
> +                                reg = <0>;
> +                                label = "cpu";
> +                                ethernet = <&gmac0>;
> +                        };
> +
> +                        port@2 {
> +                                reg = <2>;
> +                                label = "lan0";
> +                                phy-handle = <&phy1>;
> +                        };
> +
> +                        port@3 {
> +                                reg = <3>;
> +                                label = "lan1";
> +                                phy-handle = <&phy2>;
> +                        };
> +                };
> +        };
> +};
> +
> +&gmac0 {
> +        status = "okay";
> +        phy-mode = "mii";
> +
> +        fixed-link {
> +                speed = <100>;
> +                full-duplex;

Hi Kurt

The switch is 100/100Mbps right? The MAC is only Fast ethernet. Do you
need some properties in the port@0 node to tell the switch to only use
100Mbps? I would expect it to default to 1G. Not looked at the code
yet...

	Andrew
