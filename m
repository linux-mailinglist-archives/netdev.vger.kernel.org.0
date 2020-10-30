Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40D3E2A0EF2
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 20:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbgJ3T5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 15:57:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55360 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgJ3T5E (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 15:57:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYaW7-004PI4-Nn; Fri, 30 Oct 2020 20:56:55 +0100
Date:   Fri, 30 Oct 2020 20:56:55 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        robh@kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v3 2/4] dt-bindings: net: Add Rx/Tx output
 configuration for 10base T1L
Message-ID: <20201030195655.GD1042051@lunn.ch>
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201030172950.12767-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 30, 2020 at 12:29:48PM -0500, Dan Murphy wrote:
> Per the 802.3cg spec the 10base T1L can operate at 2 different
> differential voltages 1v p2p and 2.4v p2p. The abiility of the PHY to
> drive that output is dependent on the PHY's on board power supply.

Hi Dan

So this property is about the board being able to support the needed
voltages? The PHY is not forced into 2.4v p2p, it just says the PHY
can operate at 2.4v and the board will not melt, blow a fuse, etc?

I actually think it is normal to specify the reverse. List the maximum
that device can do because of board restrictions. e.g.

- maximum-power-milliwatt : Maximum module power consumption
  Specifies the maximum power consumption allowable by a module in the
  slot, in milli-Watts.  Presently, modules can be up to 1W, 1.5W or 2W.

- max-link-speed:
   If present this property specifies PCI gen for link capability.  Host
   drivers could add this as a strategy to avoid unnecessary operation for
   unsupported link speed, for instance, trying to do training for
   unsupported link speed, etc.  Must be '4' for gen4, '3' for gen3, '2'
   for gen2, and '1' for gen1. Any other values are invalid.

 - max-microvolt : The maximum voltage value supplied to the haptic motor.
                [The unit of the voltage is a micro]

So i think this property should be

   max-tx-rx-p2p = <1000>;

to limit it to 1000mv p2p because of board PSU limitations, and it is
free to do 22000mv is the property is not present.

   Andrew

