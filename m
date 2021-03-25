Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5F9349281
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 13:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbhCYM5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 08:57:46 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229617AbhCYM5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Mar 2021 08:57:42 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lPPYN-00CxB2-I4; Thu, 25 Mar 2021 13:57:35 +0100
Date:   Thu, 25 Mar 2021 13:57:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Anand Moon <linux.amoon@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, Rob Herring <robh@kernel.org>
Subject: Re: [PATCHv1 1/6] dt-bindings: net: ethernet-phy: Fix the parsing of
 ethernet-phy compatible string
Message-ID: <YFyIvxOHwIs3R/IT@lunn.ch>
References: <20210325124225.2760-1-linux.amoon@gmail.com>
 <20210325124225.2760-2-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210325124225.2760-2-linux.amoon@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:42:20PM +0000, Anand Moon wrote:
> Fix the parsing of check of pattern ethernet-phy-ieee802.3 used
> by the device tree to initialize the mdio phy.
> 
> As per the of_mdio below 2 are valid compatible string
> 	"ethernet-phy-ieee802.3-c22"
> 	"ethernet-phy-ieee802.3-c45"

Nope, this is not the full story. Yes, you can have these compatible
strings. But you can also use the PHY ID,
e.g. ethernet-phy-idAAAA.BBBB, where AAAA and BBBB are what you find in
registers 2 and 3 of the PHY.

> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Anand Moon <linux.amoon@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 2766fe45bb98..cfc7909d3e56 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -33,7 +33,7 @@ properties:
>          description: PHYs that implement IEEE802.3 clause 22
>        - const: ethernet-phy-ieee802.3-c45
>          description: PHYs that implement IEEE802.3 clause 45
> -      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> +      - pattern: "^ethernet-phy-ieee[0-9]{3}\\.[0-9][-][a-f0-9]{4}$"

So here you need, in addition to, not instead of.

Please test you change on for example imx6ul-14x14-evk.dtsi

   Andrew
