Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13CE32C8B6D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 18:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgK3Rjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 12:39:51 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:40687 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728451AbgK3Rju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 12:39:50 -0500
Received: by mail-il1-f195.google.com with SMTP id g1so12100063ilk.7;
        Mon, 30 Nov 2020 09:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B4A0okbUHqv5B5dj/XPLmtnTNoOEsXTfn/5l90uEFoM=;
        b=IWCMS3ZMZ90s757ED+4XguK+HL0TsWbt8n/WxBfOLIiV9/lCbDf3sPrIUDJEbb8RWx
         fTkUKuGrwWnHQYZ0iEQVtTdspwFCXYDRMAtXAu+GNra4H3yZUpzAO2Nzh6GJ/axWpuV8
         AUT7XX4r0rUVO+sc7AJkaTVcojE5yeiMMAaQUbt9eMOufwn8kCuSLxRVqgmDBf325we+
         pGb/Cp6tZAa3TDWj4LGdNV4etv+VntS5FgNJPJxZVWdCPbInLnVVSzpS/3ZXIbLsim0W
         Fu+SfCLwEHCACVkuxpD4dgikkyQIv0j7qCtProWFZQ3FAfsUGC3ypQvfB8Jd9Bn6HjCd
         KLhA==
X-Gm-Message-State: AOAM531GI6YivhkYWQNKDY3ZykCJEdOQRBew/47c9MEoX8Hg+DNBk9ps
        WEKCjOnuI0rxN/2n9ZqoJg==
X-Google-Smtp-Source: ABdhPJy1tBVfvlTKy8Ljdlf32Xy2YiZmMU6KG7fY9ZP9pCrPJVaDW4rUpvEHw3svnPb/szKFx5xlXw==
X-Received: by 2002:a92:dd87:: with SMTP id g7mr21491077iln.102.1606757950052;
        Mon, 30 Nov 2020 09:39:10 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id a7sm3382492ioq.38.2020.11.30.09.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 09:39:09 -0800 (PST)
Received: (nullmailer pid 2687938 invoked by uid 1000);
        Mon, 30 Nov 2020 17:39:08 -0000
Date:   Mon, 30 Nov 2020 10:39:08 -0700
From:   Rob Herring <robh@kernel.org>
To:     Bongsu jeon <bongsu.jeon2@gmail.com>
Cc:     krzk@kernel.org, linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v2 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201130173908.GC2684526@robh.at.kernel.org>
References: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606737627-29485-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 30, 2020 at 09:00:27PM +0900, Bongsu jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
> 
> Changes in v2:
>  -change the compatible name.
>  -change the const to enum for compatible.
>  -change the node name to nfc.
> 
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 32 ++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> index cb0b8a5..481bbcc 100644
> --- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> +++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> @@ -12,7 +12,10 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: samsung,s3fwrn5-i2c
> +    oneOf:

Don't need 'oneOf' here.

> +      - enum:
> +        - samsung,s3fwrn5-i2c
> +        - samsung,s3fwrn82
>  
>    en-gpios:
>      maxItems: 1
> @@ -47,10 +50,19 @@ additionalProperties: false
>  required:
>    - compatible
>    - en-gpios
> -  - interrupts
> -  - reg
>    - wake-gpios
>  
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: samsung,s3fwrn5-i2c
> +    then:
> +      required:
> +        - interrupts
> +        - reg
> +
>  examples:
>    - |
>      #include <dt-bindings/gpio/gpio.h>
> @@ -71,3 +83,17 @@ examples:
>              wake-gpios = <&gpj0 2 GPIO_ACTIVE_HIGH>;
>          };
>      };
> +  # UART example on Raspberry Pi
> +  - |
> +    uart0 {
> +        status = "okay";
> +
> +        nfc {
> +            compatible = "samsung,s3fwrn82";
> +
> +            en-gpios = <&gpio 20 0>;
> +            wake-gpios = <&gpio 16 0>;
> +
> +            status = "okay";
> +        };
> +    };
> -- 
> 1.9.1
> 
