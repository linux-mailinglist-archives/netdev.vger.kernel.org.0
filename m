Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757892DE321
	for <lists+netdev@lfdr.de>; Fri, 18 Dec 2020 14:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgLRNO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 08:14:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbgLRNO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 08:14:27 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BEDC06138C
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 05:13:46 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id e25so2528255wme.0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 05:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PUVQS6CtIWduzl99LlA0iAcZSxRdzwKzX+tvELGUUxo=;
        b=qa6KPiTj08B7VyjNIm5SSCKcAwhv1NukA2OGlBZOQFkZJr3uORyWkDbpJcNpkEgi4s
         nun0mSNR0aR+M1djrx/Q6s6Ejn4bKCuJ+oAKDzXqBYSRJDKRKNQBA1Q1q5Uv/RAu1inu
         TOMDRCO8pZEFYaYgIqKA1ObTXDSNYpnRB3X5F3ItTrYCU0mGkXcsN3lcmhtjS1uy2nTe
         9aO2spbYglhLcJOpxya0xTNNTbB1K/8di+BT1crsku3dr1Iqw4f4os/IlClkk+iBnmMA
         LAqGkNiRXWDhtKeLAcYELGSRKqwHFMeC3EGUdDN8KuillWr87K0MzKEm9YhsaOM9X+Vo
         c4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PUVQS6CtIWduzl99LlA0iAcZSxRdzwKzX+tvELGUUxo=;
        b=kWMWTsgpOzWZfJDz/T1nhl3cQy3WrNlLjC7CYpQllGzyHw/h4ArpXuk346+sApB54F
         LyaYyFwM5iYWyeD5DG8+v6zEIIobDf4jqferrxd/fnJfOPUD+GKFcRJAB4lKnAHunOFU
         QP65i0mNAHDJXV5uN+q5c7nuSHsQGr5vkNmYgkfk8SEIQtHmjttmTYvcPZEBazQ+7QrO
         zmUgJzT+Ns7bwQkK21DPak99N7WTR3mgXEaJRgEoGUW5IY1HK6GuDrWZ+HP1xPNeL3il
         OIv1TrZ9J0FTd+yPLjZZd1174hjEQyCpA5qzQOTHiiooSaibjp+TyuvgRYkhHUeYL7bb
         fXIw==
X-Gm-Message-State: AOAM531s4FXNQoHYSqDq7yB6yLImmPjhooyIAM8fW9XH2pi8a0uPhMG9
        RYyqpNUmnTIn/U25Q6Mpw/mVWA==
X-Google-Smtp-Source: ABdhPJyN50l7VG2cM89yTTsLTEGHtcWLFqr+RQWuBiU2twvWtFsud6ffciBugHbjjOI1UiloucSiJQ==
X-Received: by 2002:a1c:4843:: with SMTP id v64mr4222832wma.186.1608297225168;
        Fri, 18 Dec 2020 05:13:45 -0800 (PST)
Received: from dell ([91.110.221.216])
        by smtp.gmail.com with ESMTPSA id w189sm11866853wmg.31.2020.12.18.05.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:13:44 -0800 (PST)
Date:   Fri, 18 Dec 2020 13:13:42 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Jingoo Han <jingoohan1@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix JSON pointers
Message-ID: <20201218131342.GQ207743@dell>
References: <20201217223429.354283-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201217223429.354283-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020, Rob Herring wrote:

> The correct syntax for JSON pointers begins with a '/' after the '#'.
> Without a '/', the string should be interpretted as a subschema
> identifier. The jsonschema module currently doesn't handle subschema
> identifiers and incorrectly allows JSON pointers to begin without a '/'.
> Let's fix this before it becomes a problem when jsonschema module is
> fixed.
> 
> Converted with:
> perl -p -i -e 's/yaml#definitions/yaml#\/definitions/g' `find Documentation/devicetree/bindings/ -name "*.yaml"`
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Jingoo Han <jingoohan1@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  .../devicetree/bindings/arm/idle-states.yaml  |  2 +-
>  .../bus/allwinner,sun50i-a64-de2.yaml         |  2 +-
>  .../bindings/bus/baikal,bt1-axi.yaml          |  2 +-
>  .../bindings/connector/usb-connector.yaml     | 10 ++---
>  .../devicetree/bindings/dma/dma-common.yaml   |  4 +-
>  .../devicetree/bindings/dma/dma-router.yaml   |  2 +-
>  .../devicetree/bindings/dma/ingenic,dma.yaml  |  2 +-
>  .../bindings/dma/snps,dma-spear1340.yaml      | 10 ++---
>  .../devicetree/bindings/eeprom/at24.yaml      |  4 +-
>  .../devicetree/bindings/eeprom/at25.yaml      |  4 +-
>  .../bindings/hwmon/moortec,mr75203.yaml       |  2 +-
>  .../bindings/hwmon/sensirion,shtc1.yaml       |  4 +-
>  .../devicetree/bindings/hwmon/ti,tmp513.yaml  |  2 +-
>  .../bindings/iio/light/upisemi,us5182.yaml    |  2 +-
>  .../iio/proximity/semtech,sx9310.yaml         |  6 +--
>  .../devicetree/bindings/input/gpio-keys.yaml  | 12 +++---
>  .../interrupt-controller/mti,gic.yaml         |  4 +-
>  .../interrupt-controller/ti,pruss-intc.yaml   |  2 +-
>  .../interrupt-controller/ti,sci-inta.yaml     |  2 +-

>  .../bindings/leds/backlight/common.yaml       |  4 +-

Acked-by: Lee Jones <lee.jones@linaro.org>

>  .../devicetree/bindings/leds/common.yaml      | 16 ++++----
>  .../devicetree/bindings/leds/leds-lp55xx.yaml | 10 ++---
>  .../net/allwinner,sun8i-a83t-emac.yaml        |  6 +--
>  .../bindings/net/amlogic,meson-dwmac.yaml     |  2 +-
>  .../devicetree/bindings/net/dsa/dsa.yaml      |  6 +--
>  .../bindings/net/ethernet-controller.yaml     | 24 ++++++------
>  .../devicetree/bindings/net/ethernet-phy.yaml | 20 +++++-----
>  .../bindings/net/fsl,qoriq-mc-dpmac.yaml      |  2 +-
>  .../devicetree/bindings/net/mdio.yaml         |  2 +-
>  .../bindings/net/mediatek,star-emac.yaml      |  2 +-
>  .../devicetree/bindings/net/qcom,ipa.yaml     |  2 +-
>  .../devicetree/bindings/net/snps,dwmac.yaml   | 38 +++++++++----------
>  .../bindings/net/socionext,uniphier-ave4.yaml |  2 +-
>  .../bindings/net/ti,cpsw-switch.yaml          |  2 +-
>  .../devicetree/bindings/net/ti,dp83867.yaml   | 12 +++---
>  .../devicetree/bindings/net/ti,dp83869.yaml   |  8 ++--
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |  4 +-
>  .../bindings/net/wireless/qcom,ath11k.yaml    |  2 +-
>  .../devicetree/bindings/phy/ti,omap-usb2.yaml |  4 +-
>  .../power/mediatek,power-controller.yaml      | 12 +++---
>  .../bindings/power/supply/cw2015_battery.yaml |  2 +-
>  .../devicetree/bindings/powerpc/sleep.yaml    |  2 +-
>  .../devicetree/bindings/serial/8250.yaml      |  6 +--
>  .../bindings/soc/ti/k3-ringacc.yaml           |  2 +-
>  .../sound/allwinner,sun4i-a10-codec.yaml      |  2 +-
>  .../bindings/sound/st,stm32-sai.yaml          |  4 +-
>  46 files changed, 138 insertions(+), 138 deletions(-)

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
