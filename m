Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7EB5B0087
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 11:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbiIGJcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 05:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiIGJce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 05:32:34 -0400
Received: from sibelius.xs4all.nl (80-61-163-207.fixed.kpn.net [80.61.163.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2F5070E71;
        Wed,  7 Sep 2022 02:32:32 -0700 (PDT)
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id 009b8c43;
        Wed, 7 Sep 2022 11:25:48 +0200 (CEST)
Date:   Wed, 7 Sep 2022 11:25:48 +0200 (CEST)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, alyssa@rosenzweig.io,
        asahi@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
        davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, marcan@marcan.st, kuba@kernel.org,
        kvalo@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, zajec5@gmail.com, robh+dt@kernel.org,
        SHA-cyfmac-dev-list@infineon.com, sven@svenpeter.dev,
        arend@broadcom.com
In-Reply-To: <E1oVpmk-005LBL-5U@rmk-PC.armlinux.org.uk>
        (rmk+kernel@armlinux.org.uk)
Subject: Re: [PATCH net-next 01/12] dt-bindings: net: bcm4329-fmac: Add Apple
 properties & chips
References: <YxhMaYOfnM+7FG+W@shell.armlinux.org.uk> <E1oVpmk-005LBL-5U@rmk-PC.armlinux.org.uk>
Message-ID: <d3ced5135ffd65d8@bloch.sibelius.xs4all.nl>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> Date: Wed, 07 Sep 2022 08:47:46 +0100
> 
> From: Hector Martin <marcan@marcan.st>
> 
> This binding is currently used for SDIO devices, but these chips are
> also used as PCIe devices on DT platforms and may be represented in the
> DT. Re-use the existing binding and add chip compatibles used by Apple
> T2 and M1 platforms (the T2 ones are not known to be used in DT
> platforms, but we might as well document them).
> 
> Then, add properties required for firmware selection and calibration on
> M1 machines.
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Hector Martin <marcan@marcan.st>
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Mark Kettenis <kettenis@openbsd.org>

> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 37 +++++++++++++++++--
>  1 file changed, 34 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index 53b4153d9bfc..53ded82b273a 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> @@ -4,7 +4,7 @@
>  $id: http://devicetree.org/schemas/net/wireless/brcm,bcm4329-fmac.yaml#
>  $schema: http://devicetree.org/meta-schemas/core.yaml#
>  
> -title: Broadcom BCM4329 family fullmac wireless SDIO devices
> +title: Broadcom BCM4329 family fullmac wireless SDIO/PCIE devices
>  
>  maintainers:
>    - Arend van Spriel <arend@broadcom.com>
> @@ -42,10 +42,16 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
>                - cypress,cyw43012-fmac
>            - const: brcm,bcm4329-fmac
>        - const: brcm,bcm4329-fmac
> +      - enum:
> +          - pci14e4,43dc  # BCM4355
> +          - pci14e4,4464  # BCM4364
> +          - pci14e4,4488  # BCM4377
> +          - pci14e4,4425  # BCM4378
> +          - pci14e4,4433  # BCM4387
>  
>    reg:
> -    description: SDIO function number for the device, for most cases
> -      this will be 1.
> +    description: SDIO function number for the device (for most cases
> +      this will be 1) or PCI device identifier.
>  
>    interrupts:
>      maxItems: 1
> @@ -85,6 +91,31 @@ title: Broadcom BCM4329 family fullmac wireless SDIO devices
>        takes precedence.
>      type: boolean
>  
> +  brcm,cal-blob:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description: A per-device calibration blob for the Wi-Fi radio. This
> +      should be filled in by the bootloader from platform configuration
> +      data, if necessary, and will be uploaded to the device if present.
> +
> +  brcm,board-type:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Overrides the board type, which is normally the compatible of
> +      the root node. This can be used to decouple the overall system board or
> +      device name from the board type for WiFi purposes, which is used to
> +      construct firmware and NVRAM configuration filenames, allowing for
> +      multiple devices that share the same module or characteristics for the
> +      WiFi subsystem to share the same firmware/NVRAM files. On Apple platforms,
> +      this should be the Apple module-instance codename prefixed by "apple,",
> +      e.g. "apple,honshu".
> +
> +  apple,antenna-sku:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Antenna SKU used to identify a specific antenna configuration
> +      on Apple platforms. This is use to build firmware filenames, to allow
> +      platforms with different antenna configs to have different firmware and/or
> +      NVRAM. This would normally be filled in by the bootloader from platform
> +      configuration data.
> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.30.2
> 
> 
> 
