Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 952B8481530
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbhL2QmU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 11:42:20 -0500
Received: from sibelius.xs4all.nl ([83.163.83.176]:50403 "EHLO
        sibelius.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234322AbhL2QmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 11:42:20 -0500
Received: from localhost (bloch.sibelius.xs4all.nl [local])
        by bloch.sibelius.xs4all.nl (OpenSMTPD) with ESMTPA id 079f839a;
        Wed, 29 Dec 2021 17:42:17 +0100 (CET)
Date:   Wed, 29 Dec 2021 17:42:17 +0100 (CET)
From:   Mark Kettenis <mark.kettenis@xs4all.nl>
To:     Hector Martin <marcan@marcan.st>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, rafael@kernel.org, lenb@kernel.org,
        aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@infineon.com,
        wright.feng@infineon.com, chung-hsien.hsu@infineon.com,
        marcan@marcan.st, sven@svenpeter.dev, alyssa@rosenzweig.io,
        kettenis@openbsd.org, zajec5@gmail.com,
        pieter-paul.giesberts@broadcom.com, linus.walleij@linaro.org,
        hdegoede@redhat.com, linville@tuxdriver.com, dekim@broadcom.com,
        sandals@crustytoothpaste.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
In-Reply-To: <20211226153624.162281-2-marcan@marcan.st> (message from Hector
        Martin on Mon, 27 Dec 2021 00:35:51 +0900)
Subject: Re: [PATCH 01/34] dt-bindings: net: bcm4329-fmac: Add Apple properties & chips
References: <20211226153624.162281-1-marcan@marcan.st> <20211226153624.162281-2-marcan@marcan.st>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-ID: <d3cb7b3782b16029@bloch.sibelius.xs4all.nl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Hector Martin <marcan@marcan.st>
> Cc: Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
>         Alyssa Rosenzweig <alyssa@rosenzweig.io>,
>         Mark Kettenis <kettenis@openbsd.org>,
>         Rafał Miłecki <zajec5@gmail.com>,
>         Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
>         Linus Walleij <linus.walleij@linaro.org>,
>         Hans de Goede <hdegoede@redhat.com>,
>         "John W. Linville" <linville@tuxdriver.com>,
>         "Daniel (Deognyoun) Kim" <dekim@broadcom.com>,
>         "brian m. carlson" <sandals@crustytoothpaste.net>,
>         linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
>         devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
>         linux-acpi@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com,
>         SHA-cyfmac-dev-list@infineon.com
> Date: Mon, 27 Dec 2021 00:35:51 +0900
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
> Signed-off-by: Hector Martin <marcan@marcan.st>
> ---
>  .../net/wireless/brcm,bcm4329-fmac.yaml       | 32 +++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml b/Documentation/devicetree/bindings/net/wireless/brcm,bcm4329-fmac.yaml
> index c11f23b20c4c..2530ff3e7b90 100644
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
> @@ -36,16 +36,22 @@ properties:
>                - brcm,bcm43455-fmac
>                - brcm,bcm43456-fmac
>                - brcm,bcm4354-fmac
> +              - brcm,bcm4355c1-fmac
>                - brcm,bcm4356-fmac
>                - brcm,bcm4359-fmac
> +              - brcm,bcm4364b2-fmac
> +              - brcm,bcm4364b3-fmac
> +              - brcm,bcm4377b3-fmac
> +              - brcm,bcm4378b1-fmac
> +              - brcm,bcm4387c2-fmac
>                - cypress,cyw4373-fmac
>                - cypress,cyw43012-fmac
>            - const: brcm,bcm4329-fmac
>        - const: brcm,bcm4329-fmac

I suppose this helps with validation of device trees.  However, nodes
for PCI devices are not supposed to have a "compatible" property as
the PCI vendor and device IDs are supposed to be used to identify a
device.

That does raise the question how a schema for additional properties
for PCI device nodes is supposed to be defined...

>    reg:
> -    description: SDIO function number for the device, for most cases
> -      this will be 1.
> +    description: SDIO function number for the device (for most cases
> +      this will be 1) or PCI device identifier.
>  
>    interrupts:
>      maxItems: 1
> @@ -75,6 +81,26 @@ properties:
>      items:
>        pattern: '^[A-Z][A-Z]-[A-Z][0-9A-Z]-[0-9]+$'
>  
> +  brcm,cal-blob:
> +    $ref: /schemas/types.yaml#/definitions/uint8-array
> +    description: A per-device calibration blob for the Wi-Fi radio. This
> +      should be filled in by the bootloader from platform configuration
> +      data, if necessary, and will be uploaded to the device if present.
> +
> +  apple,module-instance:
> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: Module codename used to identify a specific board on
> +      Apple platforms. This is used to build the firmware filenames, to allow
> +      different platforms to have different firmware and/or NVRAM config.
> +
> +  apple,antenna-sku:
> +    $def: /schemas/types.yaml#/definitions/string
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
> 2.33.0
> 
> 
