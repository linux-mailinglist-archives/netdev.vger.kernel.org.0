Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA325427AE0
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 16:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbhJIOkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 10:40:19 -0400
Received: from smtp-relay-internal-0.canonical.com ([185.125.188.122]:33186
        "EHLO smtp-relay-internal-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229929AbhJIOkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 10:40:17 -0400
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 24FE53FFFE
        for <netdev@vger.kernel.org>; Sat,  9 Oct 2021 14:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1633790300;
        bh=piKl389zZcyeHqnlCZHkGS20SA85lTrv1Cw48kxXcc4=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=IfzgzRinl/pdjD8kscCSljHRVmwn6ru/+yLOnyB+KsiRUKB9rK1+ylIRiDq2typAx
         vLWV1e/yC5ifLfEldo95bMBpVIwhZpq187383uMNGCcHp9SEa9z6MvlTiGcSvcOG2+
         067VVXBNuHQC90+gJL/IHFeljk/5rptxoh/gzwseu3S7iv3m24WIenmegtRkOfFmJh
         p4nQtbaMmFnAzHPgK0O1cY9eDvpVq4R4rI651ovVlofdrO4Wh0m8YP0zlcBAR4DUrT
         6IWXYwkBEkLSZrQuomeO39X3XlOIG5c8NB4m4tNQZVkluh2ZGN5+FVqSohoKe/q+ag
         0wY/6Eefxwl/w==
Received: by mail-ed1-f69.google.com with SMTP id e14-20020a056402088e00b003db6ebb9526so2160729edy.22
        for <netdev@vger.kernel.org>; Sat, 09 Oct 2021 07:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=piKl389zZcyeHqnlCZHkGS20SA85lTrv1Cw48kxXcc4=;
        b=co3Uu5Shfm4jAUF7xH35qe/V/Q9E4TNdrXT+5qjSPwAJd6SpfwFKEF7qmajfB7ynVV
         DGXtvyu8VXQGo1GoqH1oMDlPx6+C0cD3uQee1lYAlreBvImDRqnAUv5YuBGZPcRu/cxl
         DLNzvy1BzZeWXZYgZrzEIheGczk1Ie0dATmLpBW54FHcjxPi4tQntAmtHceEkM9zkTqM
         FEkj1evG6nmklDUtRUVn56118EXxGf5eLbjWeTPvRxkGcgdiFpgy1u9O805m8GukPrCU
         Ke+IXk/gyf1mrKHkV9421BQffA4KMfInqHfwdNHIDDatCUEYBp5d/q/lc2niNeTyQoar
         8yww==
X-Gm-Message-State: AOAM533Z+/Makrqoh2mxxraCvENgbCoyVESUXBFqe0vjJsHOBYQ2f9n9
        kHwlMNnzSbRgLgWAASlEUXzf2VLxd7dF8G67JBcxARQ8t1aezJy+mH9FP1n3CPFQMEInZvPxAxx
        TDyrsS2Nm7pCKxtDj7pwvFkKQ//HRoWoaHQ==
X-Received: by 2002:a17:906:454a:: with SMTP id s10mr12005407ejq.11.1633790299743;
        Sat, 09 Oct 2021 07:38:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJySnG0AidBa0+FS688Hs3cRj+PsAMJtoScCF1sdlpdUlvL/P3XWYtMxfLUNnXJZN29ivuMmPg==
X-Received: by 2002:a17:906:454a:: with SMTP id s10mr12005382ejq.11.1633790299467;
        Sat, 09 Oct 2021 07:38:19 -0700 (PDT)
Received: from [192.168.0.20] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id r19sm1285131edt.54.2021.10.09.07.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 07:38:18 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: net: nfc: nxp,pn544: Convert txt bindings to
 yaml
To:     David Heidelberg <david@ixit.cz>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, ~okias/devicetree@lists.sr.ht
References: <20211009111215.51775-1-david@ixit.cz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <b52a93da-e805-b04e-3b50-454956764d04@canonical.com>
Date:   Sat, 9 Oct 2021 16:38:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211009111215.51775-1-david@ixit.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/10/2021 13:12, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  .../bindings/net/nfc/nxp,pn544.yaml           | 67 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 ---------
>  2 files changed, 67 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 

Hi,

Thanks for the patch. Please use get_maintainers.pl to get the list of
folks to Cc. You missed Rob. This is even weirder because you put him as
a maintainer...

> diff --git a/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> new file mode 100644
> index 000000000000..c44f5ee8e2c2
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
> @@ -0,0 +1,67 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nfc/nxp,pn544.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP Semiconductors PN544 NFC Controller
> +
> +maintainers:
> +  - Rob Herring <robh+dt@kernel.org>

This should not be Rob but someone responsible for the driver. I see
there is no maintainers entry, so put there me:

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>

> +
> +properties:
> +  compatible:
> +    const: nxp,pn544-i2c
> +
> +  clock-frequency: true
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +  enable-gpios:
> +    description: Output GPIO pin used for enabling/disabling the PN544
> +
> +  firmware-gpios:
> +    description: Output GPIO pin used to enter firmware download mode
> +
> +  pinctrl-names:
> +    items:
> +      - const: default
> +
> +  pintctrl-0: true

Drop pinctrl, there is a typo here and this is already provided by the
schema.

> +
> +required:
> +  - compatible
> +  - clock-frequency
> +  - reg
> +  - interrupts
> +  - enable-gpios
> +  - firmware-gpios
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +
> +    i2c {
> +      #address-cells = <1>;
> +      #size-cells = <0>;

Use 4-space indentation for the example. Easier to read.

> +
> +      pn544@28 {

Nodes should have generic name, so "nfc".

> +        compatible = "nxp,pn544-i2c";



Best regards,
Krzysztof
