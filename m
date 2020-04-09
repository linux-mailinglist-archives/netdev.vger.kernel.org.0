Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7681A3B5E
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 22:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgDIUco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 16:32:44 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41486 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726291AbgDIUcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 16:32:43 -0400
Received: by mail-pg1-f196.google.com with SMTP id m13so8089pgd.8;
        Thu, 09 Apr 2020 13:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=SV4gcePwSyug2j1XofY+vKaPN44dF/BmRIOpTLsKlF4=;
        b=cnIRHMgb4nnkD+d3UfCblS/S4TpfGuQbiAHGWCJV9iwL8C74DjJH1XLvu86bB3FdfA
         7O1NPMbqK3fDv68lvP0g/rwjk0hMXqSqk2Mwn5OkDJmlOxsnUpvK+H//WCYrL2dGs8hK
         rQ4pkiFt+m0G6sE60rUn4RVObdo0TH1bSIQtfL2hnT/DHiCLVHXKlhiuhH+1VDaDQQWO
         ybojNQg4zt7tht0oPbestmQ3dljhGevmwrVdEqeSfX1X1O+KXFijdanSeNd4Nwo0f/cy
         CxCScl24uVI9A1W2JZzH823nTM51Pc9c1Gz1JHoYsMrCvTqDnbKZWNUeFcOdWWsH0yjD
         R8Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=SV4gcePwSyug2j1XofY+vKaPN44dF/BmRIOpTLsKlF4=;
        b=iHgKo28aEdAUtlXz1+2ZIj9JGGqqNjtFAtH+Vge4Xesh0sYVA7k9smzOqjmPQFQpuT
         N/ew+W6qSqrG3QZmNTJ2tXpqm3YlAJZ9Sf7yHIMo1wAT/V8FLFBGktgIo99pobqUHfZp
         XYPS5en9C3GjFVToVLOJX65vx7x+72as1tI7yCd9Hmi3f979HqrAHbQNbXl5Wl1o54Bb
         y7dhMzN4k1cC45m88SfTsGflLF6P/PTIxPnQvWnIouKnhANS+bBtCEewDk0N6p1AR5Rd
         tPmMGwC1D2GGbU9NZs/ZgA2pYOu4oVa7ylHn8SqhG7h+Li0pCvlGwRgTbOY5Kb+s7s4p
         2RUA==
X-Gm-Message-State: AGi0PuZmLRDVQQScrA62yf5TpPdoauBd0zgaWuPC5DcKemyDINKlb8h/
        Bf8U9jVhQAiD/KF0mD3Wb3w=
X-Google-Smtp-Source: APiQypIcvlAfvSv1unLOKM/2cpfBJ+snZN2mRqC+/89OT27A5t9eT3isQrXtTZednNhSY5gDiXjPGg==
X-Received: by 2002:aa7:94a5:: with SMTP id a5mr1477483pfl.67.1586464361864;
        Thu, 09 Apr 2020 13:32:41 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id f200sm20223263pfa.177.2020.04.09.13.32.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 Apr 2020 13:32:41 -0700 (PDT)
Date:   Thu, 9 Apr 2020 13:32:39 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Nuno =?iso-8859-1?Q?S=E1?= <nuno.sa@analog.com>,
        Jean Delvare <jdelvare@suse.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Lee Jones <lee.jones@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Mark Brown <broonie@kernel.org>, linux-hwmon@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix dtc warnings on reg and ranges in
 examples
Message-ID: <20200409203239.GA143353@roeck-us.net>
References: <20200409202458.24509-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200409202458.24509-1-robh@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 09, 2020 at 02:24:58PM -0600, Rob Herring wrote:
> A recent update to dtc and changes to the default warnings introduced
> some new warnings in the DT binding examples:
> 
> Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.example.dts:23.13-61:
>  Warning (dma_ranges_format): /example-0/dram-controller@1c01000:dma-ranges: "dma-ranges" property has invalid length (12 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 1)
> Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.example.dts:17.22-28.11:
>  Warning (unit_address_vs_reg): /example-0/fpga-axi@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.example.dts:34.13-54:
>  Warning (dma_ranges_format): /example-0/memory-controller@2c00000:dma-ranges: "dma-ranges" property has invalid length (24 bytes) (parent #address-cells == 1, child #address-cells == 2, #size-cells == 2)
> Documentation/devicetree/bindings/mfd/st,stpmic1.example.dts:19.15-79.11:
>  Warning (unit_address_vs_reg): /example-0/i2c@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.example.dts:28.23-31.15:
>  Warning (unit_address_vs_reg): /example-0/mdio@37000000/switch@10: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/rng/brcm,bcm2835.example.dts:17.5-21.11:
>  Warning (unit_address_vs_reg): /example-0/rng: node has a reg or ranges property, but no unit name
> Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.example.dts:20.20-43.11:
>  Warning (unit_address_vs_reg): /example-0/soc@0: node has a unit name, but no reg or ranges property
> Documentation/devicetree/bindings/usb/ingenic,musb.example.dts:18.28-21.11:
>  Warning (unit_address_vs_reg): /example-0/usb-phy@0: node has a unit name, but no reg or ranges property
> 
> Cc: Maxime Ripard <mripard@kernel.org>
> Cc: Chen-Yu Tsai <wens@csie.org>
> Cc: "Nuno Sá" <nuno.sa@analog.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Jonathan Hunter <jonathanh@nvidia.com>
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Ray Jui <rjui@broadcom.com>
> Cc: Scott Branden <sbranden@broadcom.com>
> Cc: bcm-kernel-feedback-list@broadcom.com
> Cc: Mark Brown <broonie@kernel.org>
> Cc: linux-hwmon@vger.kernel.org
> Cc: linux-tegra@vger.kernel.org
> Cc: linux-arm-msm@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-rpi-kernel@lists.infradead.org
> Cc: linux-spi@vger.kernel.org
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>

For hwmon:

Acked-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Will take this via the DT tree.
> 
> Rob
> 
>  .../arm/sunxi/allwinner,sun4i-a10-mbus.yaml   |  6 +++
>  .../bindings/hwmon/adi,axi-fan-control.yaml   |  2 +-
>  .../nvidia,tegra186-mc.yaml                   | 41 +++++++++++--------
>  .../devicetree/bindings/mfd/st,stpmic1.yaml   |  2 +-
>  .../bindings/net/qcom,ipq8064-mdio.yaml       |  1 +
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml |  2 +-
>  .../bindings/spi/qcom,spi-qcom-qspi.yaml      |  2 +-
>  .../devicetree/bindings/usb/ingenic,musb.yaml |  2 +-
>  8 files changed, 35 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> index aa0738b4d534..e713a6fe4cf7 100644
> --- a/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> +++ b/Documentation/devicetree/bindings/arm/sunxi/allwinner,sun4i-a10-mbus.yaml
> @@ -42,6 +42,10 @@ properties:
>      description:
>        See section 2.3.9 of the DeviceTree Specification.
>  
> +  '#address-cells': true
> +
> +  '#size-cells': true
> +
>  required:
>    - "#interconnect-cells"
>    - compatible
> @@ -59,6 +63,8 @@ examples:
>          compatible = "allwinner,sun5i-a13-mbus";
>          reg = <0x01c01000 0x1000>;
>          clocks = <&ccu CLK_MBUS>;
> +        #address-cells = <1>;
> +        #size-cells = <1>;
>          dma-ranges = <0x00000000 0x40000000 0x20000000>;
>          #interconnect-cells = <1>;
>      };
> diff --git a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> index 57a240d2d026..29bb2c778c59 100644
> --- a/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> +++ b/Documentation/devicetree/bindings/hwmon/adi,axi-fan-control.yaml
> @@ -47,7 +47,7 @@ required:
>  
>  examples:
>    - |
> -    fpga_axi: fpga-axi@0 {
> +    fpga_axi: fpga-axi {
>              #address-cells = <0x2>;
>              #size-cells = <0x1>;
>  
> diff --git a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> index 12516bd89cf9..611bda38d187 100644
> --- a/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> +++ b/Documentation/devicetree/bindings/memory-controllers/nvidia,tegra186-mc.yaml
> @@ -97,30 +97,35 @@ examples:
>      #include <dt-bindings/clock/tegra186-clock.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    memory-controller@2c00000 {
> -        compatible = "nvidia,tegra186-mc";
> -        reg = <0x0 0x02c00000 0x0 0xb0000>;
> -        interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
> -
> +    bus {
>          #address-cells = <2>;
>          #size-cells = <2>;
>  
> -        ranges = <0x0 0x02c00000 0x02c00000 0x0 0xb0000>;
> +        memory-controller@2c00000 {
> +            compatible = "nvidia,tegra186-mc";
> +            reg = <0x0 0x02c00000 0x0 0xb0000>;
> +            interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_HIGH>;
> +
> +            #address-cells = <2>;
> +            #size-cells = <2>;
> +
> +            ranges = <0x0 0x02c00000 0x0 0x02c00000 0x0 0xb0000>;
>  
> -        /*
> -         * Memory clients have access to all 40 bits that the memory
> -         * controller can address.
> -         */
> -        dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
> +            /*
> +             * Memory clients have access to all 40 bits that the memory
> +             * controller can address.
> +             */
> +            dma-ranges = <0x0 0x0 0x0 0x0 0x100 0x0>;
>  
> -        external-memory-controller@2c60000 {
> -            compatible = "nvidia,tegra186-emc";
> -            reg = <0x0 0x02c60000 0x0 0x50000>;
> -            interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
> -            clocks = <&bpmp TEGRA186_CLK_EMC>;
> -            clock-names = "emc";
> +            external-memory-controller@2c60000 {
> +                compatible = "nvidia,tegra186-emc";
> +                reg = <0x0 0x02c60000 0x0 0x50000>;
> +                interrupts = <GIC_SPI 224 IRQ_TYPE_LEVEL_HIGH>;
> +                clocks = <&bpmp TEGRA186_CLK_EMC>;
> +                clock-names = "emc";
>  
> -            nvidia,bpmp = <&bpmp>;
> +                nvidia,bpmp = <&bpmp>;
> +            };
>          };
>      };
>  
> diff --git a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> index d9ad9260e348..f88d13d70441 100644
> --- a/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> +++ b/Documentation/devicetree/bindings/mfd/st,stpmic1.yaml
> @@ -274,7 +274,7 @@ examples:
>    - |
>      #include <dt-bindings/mfd/st,stpmic1.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
> -    i2c@0 {
> +    i2c {
>        #address-cells = <1>;
>        #size-cells = <0>;
>        pmic@33 {
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> index b9f90081046f..67df3fe861ee 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> @@ -48,6 +48,7 @@ examples:
>  
>          switch@10 {
>              compatible = "qca,qca8337";
> +            reg = <0x10>;
>              /* ... */
>          };
>      };
> diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> index 89ab67f20a7f..c147900f9041 100644
> --- a/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> +++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.yaml
> @@ -39,7 +39,7 @@ additionalProperties: false
>  
>  examples:
>    - |
> -    rng {
> +    rng@7e104000 {
>          compatible = "brcm,bcm2835-rng";
>          reg = <0x7e104000 0x10>;
>          interrupts = <2 29>;
> diff --git a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> index 0cf470eaf2a0..5c16cf59ca00 100644
> --- a/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> +++ b/Documentation/devicetree/bindings/spi/qcom,spi-qcom-qspi.yaml
> @@ -61,7 +61,7 @@ examples:
>      #include <dt-bindings/clock/qcom,gcc-sdm845.h>
>      #include <dt-bindings/interrupt-controller/arm-gic.h>
>  
> -    soc: soc@0 {
> +    soc: soc {
>          #address-cells = <2>;
>          #size-cells = <2>;
>  
> diff --git a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> index 1d6877875077..c2d2ee43ba67 100644
> --- a/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> +++ b/Documentation/devicetree/bindings/usb/ingenic,musb.yaml
> @@ -56,7 +56,7 @@ additionalProperties: false
>  examples:
>    - |
>      #include <dt-bindings/clock/jz4740-cgu.h>
> -    usb_phy: usb-phy@0 {
> +    usb_phy: usb-phy {
>        compatible = "usb-nop-xceiv";
>        #phy-cells = <0>;
>      };
> -- 
> 2.20.1
> 
