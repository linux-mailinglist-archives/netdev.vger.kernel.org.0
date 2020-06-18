Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809151FE25A
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:01:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731325AbgFRCBP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:01:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45760 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732982AbgFRCBI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 22:01:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jljrR-0013W0-TW; Thu, 18 Jun 2020 04:01:01 +0200
Date:   Thu, 18 Jun 2020 04:01:01 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     f.fainelli@gmail.com, hkallweit1@gmail.com, davem@davemloft.net,
        robh@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v7 1/6] dt-bindings: net: Add tx and rx internal
 delays
Message-ID: <20200618020101.GJ249144@lunn.ch>
References: <20200617182019.6790-1-dmurphy@ti.com>
 <20200617182019.6790-2-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617182019.6790-2-dmurphy@ti.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 01:20:14PM -0500, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ethernet-phy.yaml         | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 9b1f1147ca36..b2887476fe6a 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -162,6 +162,17 @@ properties:
>      description:
>        Specifies a reference to a node representing a SFP cage.
>  
> +
> +  rx-internal-delay-ps:
> +    description: |
> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable RX internal delays.
> +
> +  tx-internal-delay-ps:
> +    description: |
> +      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable TX internal delays.
> +

So in a later patch you have:

default: 2000

That seems to apply that these values only apply when the phy mode
indicates a delay is needed. It would be good to document that here,
when each of these properties will be used. Also, that they default to
2000 when not present.

     Andrew
