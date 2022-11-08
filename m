Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87D9E620F39
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 12:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233876AbiKHLhp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 06:37:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiKHLhn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 06:37:43 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678331A206
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 03:37:42 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u2so20691957ljl.3
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 03:37:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/lVzoqt83Ak42kIKiN8LqOfDF7RgMmRJivY7ZIPnKXQ=;
        b=KbCk9zzDc2wv90rxSwsopGI0FlGUd0PHG+RyDVhJXRh4SJnAEKlKOHAO9WzEyon8/U
         x8mfPKi9UZIZ9QyvTtebQx0+Gx0ESDxdOVK95xjJ0U2s0YKMlQua3U2+b/ucPREDz8ia
         OYEVwIEafPl7Sencx2iu54Uzz/81mg7fz8Zm+KNetL+aRMNVH03nrfONnWzdc4Z9Q75h
         11a45zws/P3tKRV/zIyFERUv6WRx8DqVi6CTX+cBPFYQv9ROPz47OMh6mXx2IIjhTxuU
         pZ+fSG0PFRhHeZYK5Gx4OQHEQWQ/Nav1ZvRnWCgN7+2C/IddxLnpLb7U11DpCM11lOLJ
         J9+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/lVzoqt83Ak42kIKiN8LqOfDF7RgMmRJivY7ZIPnKXQ=;
        b=55l7qoW982Lj+z32Ir9L6Z2oPV0ZUprUmVVFX0dbGA8jczK1l7jflimXv7ntMNrUtU
         1m3Uc5NdUAP/jO1U1PVnqAkkTMlkGYA3R6PA10YjLMHBw9pAK83jfhhW7RDNyvmQ722K
         A7xeZACVKMBV2xaa1fE2EH1Iai8t3Yc2f9aTex3SIZzjPUIDgH/1+6lPl9dUiKkwms57
         DgfbSW3+rvIg+Szlz84kZouAaMv75ben/y6ZyfqRjg6VBwu2qZUPMR/IJwTpIWsEXZDW
         e1NudoBPAllJdJ4phJrYefHvy8lDfVhrNV+5FEE5olUv8rNifGK/NlGUWhR15Vg6esxV
         4y6Q==
X-Gm-Message-State: ACrzQf2H0/NKIkq1t4oyHsRYsLlum0qHPY+d3UTdK7TE0ty7tU0TFoDO
        9MsKHZgfhPg4mAZFpOgdzUrX5g==
X-Google-Smtp-Source: AMsMyM5KfVSdGMmsYyYqwDpB8dMs4e5lU9f2Z35qXgpVXEtl8NlkUdlhY05UJ83tg5wczhgiCdWTlg==
X-Received: by 2002:a05:651c:307:b0:277:113f:3a1e with SMTP id a7-20020a05651c030700b00277113f3a1emr19582705ljp.518.1667907460751;
        Tue, 08 Nov 2022 03:37:40 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id o4-20020ac25e24000000b0048af4dc964asm1758175lfg.73.2022.11.08.03.37.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 03:37:40 -0800 (PST)
Message-ID: <6a4f7104-8b6f-7dcd-a7ac-f866956e31d6@linaro.org>
Date:   Tue, 8 Nov 2022 12:37:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: h4-bluetooth: add new bindings
 for hci_h4
Content-Language: en-US
To:     Dominique Martinet <dominique.martinet@atmark-techno.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>, mizo@atmark-techno.com
References: <20221108055531.2176793-1-dominique.martinet@atmark-techno.com>
 <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221108055531.2176793-2-dominique.martinet@atmark-techno.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/11/2022 06:55, Dominique Martinet wrote:
> Add devicetree binding to support defining a bluetooth device using the h4
> uart protocol
> 

subject: drop second redundant "bindings"

> This was tested with a NXP wireless+BT AW-XM458 module, but might
> benefit others as the H4 protocol seems often used.
> 
> Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
> ---
>  .../devicetree/bindings/net/h4-bluetooth.yaml | 49 +++++++++++++++++++
>  1 file changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/h4-bluetooth.yaml b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml
> new file mode 100644
> index 000000000000..5d11b89ca386
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/h4-bluetooth.yaml

If the schema is for one specific device, then filename matching the
compatible, so nxp,aw-xm458-bt.yaml... but I understand you want to
describe here class of devices using H4 Bluetooth? Won't they need their
own specific properties?


> @@ -0,0 +1,49 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/h4-bluetooth.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: H4 Bluetooth
> +
> +maintainers:
> +  - Dominique Martinet <dominique.martinet@atmark-techno.com>
> +
> +description:
> +  H4 is a common bluetooth over uart protocol.

Bluetooth
UART

> +  For example, the AW-XM458 is a WiFi + BT module where the WiFi part is
> +  connected over PCI (M.2), while BT is connected over serial speaking
> +  the H4 protocol. Its firmware is sent on the PCI side.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - nxp,aw-xm458-bt
> +
> +  max-speed: true
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +    #include <dt-bindings/clock/imx8mp-clock.h>
> +
> +    uart1 {

uart

> +        pinctrl-names = "default";
> +        pinctrl-0 = <&pinctrl_uart1>;
> +        assigned-clocks = <&clk IMX8MP_CLK_UART1>;
> +        assigned-clock-parents = <&clk IMX8MP_SYS_PLL1_80M>;

Drop unrelated properties.

> +        status = "okay";

Drop status.

> +        fsl,dte-mode = <1>;
> +        fsl,uart-has-rtscts;

Are these two related to this hardware?

> +
> +
> +        bluetooth {
> +            compatible = "nxp,aw-xm458-bt";
> +            max-speed = <3000000>;
> +        };
> +    };

Best regards,
Krzysztof

