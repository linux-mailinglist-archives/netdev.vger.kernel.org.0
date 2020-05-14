Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 443421D3935
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 20:39:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgENSjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 14:39:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60834 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726188AbgENSjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 May 2020 14:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gupvsLoI2EPTbCeDlomiVkEb9QRYW3zBFnUQWK4fPE4=; b=uyVvJKrrD/p1T/m5Bb74qBnCzQ
        auVHibpRub8C3s343/Oc3+N1Jsnbmy9fV5yfn7yMhB6GnTyOsCJyHzcFYntm0Na8w22GXjC9JI3nJ
        WhvkjmIm92B3rIlwXuBTkoLdR/1d1CbW4cM3BjKP+5GRdNjdLEaJ1kEGadEz2rnXSLtk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jZIlE-002JT7-AS; Thu, 14 May 2020 20:39:12 +0200
Date:   Thu, 14 May 2020 20:39:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dp83822: Add TI dp83822
 phy
Message-ID: <20200514183912.GW499265@lunn.ch>
References: <20200514173055.15013-1-dmurphy@ti.com>
 <20200514173055.15013-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514173055.15013-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 12:30:54PM -0500, Dan Murphy wrote:
> Add a dt binding for the TI dp83822 ethernet phy device.
> 
> CC: Rob Herring <robh+dt@kernel.org>
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83822.yaml   | 49 +++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83822.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83822.yaml b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> new file mode 100644
> index 000000000000..60afd43ad3b6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83822.yaml
> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0+ OR BSD-2-Clause)
> +# Copyright (C) 2020 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83822.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83822 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The DP83822 is a low-power, single-port, 10/100 Mbps Ethernet PHY. It
> +  provides all of the physical layer functions needed to transmit and receive
> +  data over standard, twisted-pair cables or to connect to an external,
> +  fiber-optic transceiver. Additionally, the DP83822 provides flexibility to
> +  connect to a MAC through a standard MII, RMII, or RGMII interface

Hi Dan

You say 10/100 Mbps Ethernet PHY, but then list RGMII?

> +
> +  Specifications about the charger can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83822i.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  ti,signal-polarity-low:
> +    type: boolean
> +    description: |
> +       DP83822 PHY in Fiber mode only.
> +       Sets the DP83822 to detect a link drop condition when the signal goes
> +       high.  If not set then link drop will occur when the signal goes low.

Are we talking about the LOS line from the SFP cage? In the SFF/SFP
binding we have:

- los-gpios : GPIO phandle and a specifier of the Receiver Loss of Signal
  Indication input gpio signal, active (signal lost) high

It would be nice to have a consistent naming.

Is it required the LOS signal is connected to the PHY? Russell King
has some patches which allows the Marvell PHY to be used as a media
converter. In that setting, i think the SFP signals are connected to
GPIOs not the PHY. The SFP core can then control the transmit disable,
module insertion detection etc. So i'm wondering if you need a
property to indicate the LOS is not connected to the PHY?

	 Andrew
