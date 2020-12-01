Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2145D2CAD04
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 21:09:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404337AbgLAUIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 15:08:11 -0500
Received: from mail-ej1-f67.google.com ([209.85.218.67]:38054 "EHLO
        mail-ej1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgLAUIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 15:08:10 -0500
Received: by mail-ej1-f67.google.com with SMTP id a16so6882133ejj.5;
        Tue, 01 Dec 2020 12:07:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o8OpMIpKsvTP+ao76T3f62qpT21Ac6Cs3TQoq3094Zc=;
        b=P8mANsRRp6HF4fvCFXGvFUPxx9YpzxAqR7WouCMGIY7a94OPI1O2pJujIhfByHnm27
         evu/tRmylhgi1HOghsJWiDfk4eUjpAph2N3SrfkP/nvW4KBq/AdAnugJ+Hsk4C/toxew
         1qT8RTR7N5+7rPbvDtIyyvFe3VCcU64TL71yiCyjdrrhOx0myczCv0VtquBr1J2YWIFC
         GczZLKR5pq/BBV3MESFdGx61J5P4yC1B/knGQUtS32UTSvPfl1ChjBacy+cb4lmnZIbU
         Scy0M+mRpBRxMRFjmR1Y0kBZeW0PZ9bs5zt9Z3mz0dMrb7bOPz1BVhPdfVeRpMlrSyWB
         AgZg==
X-Gm-Message-State: AOAM533ffen631trtoL2j3NhljyQcs3ax9dVr3DB/tAQim15rmoD2jN/
        Swp3qPYr0Lv70KF+oz0Nj2dFhkB0r0c=
X-Google-Smtp-Source: ABdhPJza6eg+oPJXQ5ReF6xIUHNqwcfSXWPMj952gZlGgpNUU+Gspt9SH0D1dl7xx52uuqb0E4/0BQ==
X-Received: by 2002:a17:906:c0d1:: with SMTP id bn17mr5003733ejb.114.1606853248214;
        Tue, 01 Dec 2020 12:07:28 -0800 (PST)
Received: from kozik-lap (adsl-84-226-167-205.adslplus.ch. [84.226.167.205])
        by smtp.googlemail.com with ESMTPSA id s15sm391164edj.75.2020.12.01.12.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 12:07:27 -0800 (PST)
Date:   Tue, 1 Dec 2020 22:07:25 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH v4 net-next 1/4] dt-bindings: net: nfc: s3fwrn5: Support
 a UART interface
Message-ID: <20201201200725.GB2435@kozik-lap>
References: <1606830628-10236-1-git-send-email-bongsu.jeon@samsung.com>
 <1606830628-10236-2-git-send-email-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606830628-10236-2-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 10:50:25PM +0900, Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Since S3FWRN82 NFC Chip, The UART interface can be used.
> S3FWRN82 supports I2C and UART interface.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
> ---
>  .../bindings/net/nfc/samsung,s3fwrn5.yaml          | 32 ++++++++++++++++++++--
>  1 file changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> index cb0b8a5..cc5f9a1 100644
> --- a/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> +++ b/Documentation/devicetree/bindings/net/nfc/samsung,s3fwrn5.yaml
> @@ -12,7 +12,10 @@ maintainers:
>  
>  properties:
>    compatible:
> -    const: samsung,s3fwrn5-i2c
> +    items:

This still has items but it should be a simple enum.

> +      - enum:
> +          - samsung,s3fwrn5-i2c
> +          - samsung,s3fwrn82
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

Use GPIO flags like in example above.

Best regards,
Krzysztof
