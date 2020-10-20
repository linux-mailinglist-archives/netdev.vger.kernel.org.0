Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537DF29428F
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 20:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437875AbgJTS4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 14:56:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37116 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437774AbgJTS4K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 14:56:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUwnh-002hR6-MN; Tue, 20 Oct 2020 20:56:01 +0200
Date:   Tue, 20 Oct 2020 20:56:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
Message-ID: <20201020185601.GJ139700@lunn.ch>
References: <20201020171221.730-1-dmurphy@ti.com>
 <20201020171221.730-3-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201020171221.730-3-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +  ti,master-slave-mode:
> +    $ref: /schemas/types.yaml#definitions/uint32
> +    default: 0
> +    description: |
> +      Force the PHY to be configured to a specific mode.
> +      Force Auto Negotiation - 0
> +      Force Master mode at 1v p2p - 1
> +      Force Master mode at 2.4v p2p - 2
> +      Force Slave mode at 1v p2p - 3
> +      Force Slave mode at 2.4v p2p - 4
> +    enum: [ 0, 1, 2, 3, 4 ]

Is this a board hardware property? The fact value 0 means auto-neg
suggests not.

We already have ethtool configuration of master/slave for T1 PHYs:

ommit bdbdac7649fac05f88c9f7ab18121a17fb591687
Author: Oleksij Rempel <linux@rempel-privat.de>
Date:   Tue May 5 08:35:05 2020 +0200

    ethtool: provide UAPI for PHY master/slave configuration.
    
    This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
    auto-negotiation support, we needed to be able to configure the
    MASTER-SLAVE role of the port manually or from an application in user
    space.

Please can you look at using that UAPI.

I assume that 1v p2p is the voltage of the signal put onto the twisted
pair? I know the Marvell 1000BaseT PHYs allow this to be configured as
well, but just downwards to save power. Maybe a PHY tunable would be
better?

Humm. Are 1v and 2.4v advertised so it can be auto negotiated? Maybe a
PHY tunable is not correct? Is this voltage selection actually more
like pause and EEE?

	Andrew
