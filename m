Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BE7372015
	for <lists+netdev@lfdr.de>; Mon,  3 May 2021 21:01:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhECTCN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 15:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECTCL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 15:02:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D4BC06174A;
        Mon,  3 May 2021 12:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=k22Zy/shsfwRPA4ryfJwN4pDqvGPyLUP/ez8Z8mw1Eg=; b=tKJQhJG25b0ClsHVwy2I2Q6/x
        9OtaID4On9aCvyv9y/9v5CBFfGzSE68WzNwqXYnBgKeFjzfIAU8KWeKfBTP24pmcBMAMy48TZP2Ju
        73+uypiXth+FG5CBK1K0OADl6uAq7Pnzm6gJ10MCc5fSarjaIZnUGtu3VqiKtXfxDa4IJEAlIX4gp
        pibqgbpuaSqeDQvqgSOfjrkVRuw/x20hZMvgXYoC+KmLOqO3oZKVuhXyFHEcPS6sSQfE6mA+cUN7e
        K0TqvalL0lQXkiuNf8hc7KPWd4Og8kuLCbDDN3NUjknx6YyKfVKjYYZhkj0Wx0opiiyE7LF6QrPnl
        h5VWWoXCA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43614)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lddoU-0002Ea-3y; Mon, 03 May 2021 20:01:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lddoT-0001PH-9a; Mon, 03 May 2021 20:01:01 +0100
Date:   Mon, 3 May 2021 20:01:01 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Corentin Labbe <clabbe@baylibre.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: Convert mdio-gpio to yaml
Message-ID: <20210503190101.GB1336@shell.armlinux.org.uk>
References: <20210503184100.1503307-1-clabbe@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210503184100.1503307-1-clabbe@baylibre.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 06:41:00PM +0000, Corentin Labbe wrote:
> Converts net/mdio-gpio.txt to yaml
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> ---
> Changes since v1:
> - fixes yamllint warning about indent
> - added maxItems 3
> 
> Changes since v2:
> - fixed example (gpios need 2 entries)
> 
> Changes since v3:
> - fixed gpios description
> - added additionalProperties/type: object
> 
>  .../devicetree/bindings/net/mdio-gpio.txt     | 27 ---------
>  .../devicetree/bindings/net/mdio-gpio.yaml    | 58 +++++++++++++++++++
>  2 files changed, 58 insertions(+), 27 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.txt
>  create mode 100644 Documentation/devicetree/bindings/net/mdio-gpio.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.txt b/Documentation/devicetree/bindings/net/mdio-gpio.txt
> deleted file mode 100644
> index 4d91a36c5cf5..000000000000
> --- a/Documentation/devicetree/bindings/net/mdio-gpio.txt
> +++ /dev/null
> @@ -1,27 +0,0 @@
> -MDIO on GPIOs
> -
> -Currently defined compatibles:
> -- virtual,gpio-mdio
> -- microchip,mdio-smi0
> -
> -MDC and MDIO lines connected to GPIO controllers are listed in the
> -gpios property as described in section VIII.1 in the following order:
> -
> -MDC, MDIO.
> -
> -Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
> -node.
> -
> -Example:
> -
> -aliases {
> -	mdio-gpio0 = &mdio0;
> -};
> -
> -mdio0: mdio {
> -	compatible = "virtual,mdio-gpio";
> -	#address-cells = <1>;
> -	#size-cells = <0>;
> -	gpios = <&qe_pio_a 11
> -		 &qe_pio_c 6>;
> -};
> diff --git a/Documentation/devicetree/bindings/net/mdio-gpio.yaml b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> new file mode 100644
> index 000000000000..236a8c4768e2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/mdio-gpio.yaml
> @@ -0,0 +1,58 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/mdio-gpio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MDIO on GPIOs
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>

I think your information is outdated here. As the original does not
contain this information, and maintainers no longer lists Florian,
I can only guess that this patch was created some time ago?

Please update this with the latest from MAINTAINERS, thanks.

> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    enum:
> +      - virtual,mdio-gpio
> +      - microchip,mdio-smi0
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +  gpios:
> +    minItems: 2
> +    maxItems: 3
> +    items:
> +      - description: MDC
> +      - description: MDIO
> +      - description: MDO
> +
> +#Note: Each gpio-mdio bus should have an alias correctly numbered in "aliases"
> +#node.
> +additionalProperties:
> +  type: object
> +
> +examples:
> +  - |
> +    aliases {
> +        mdio-gpio0 = &mdio0;
> +    };
> +
> +    mdio0: mdio {
> +      compatible = "virtual,mdio-gpio";
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      gpios = <&qe_pio_a 11>,
> +              <&qe_pio_c 6>;
> +      ethphy0: ethernet-phy@0 {
> +        reg = <0>;
> +      };
> +    };
> +...
> -- 
> 2.26.3
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
