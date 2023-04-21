Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A06A6EA4B8
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjDUH3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:29:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230521AbjDUH3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:29:51 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E28C83E0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:29:48 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94ed7e49541so172366066b.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682062187; x=1684654187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N+iZ1aFyoi01Oag2G0IVEtycCaHj8d8JsSoYMnnAS8s=;
        b=Ux5ynbWj9qHDQvjPzho8jJ1gQ2rb4QipL0X/UAtCqkvo7IZDtVmz74f5nFVkxoK2oW
         e/Hwaxw55z4H8cQ8dTXOQO9SnOUisy/XUhbW/V15gBm7GX8+N8NXFi8WeSOUU2ztdice
         sS1JHQqVHyrPHzOG8qMKQWd4aaXR9mPKYJt38A7HKrctdthX39VX4bBI0e76rCrTClfO
         JkV4BDMB4G0puP7iVT+bFLwgyv07uv+9ie32NqUZzjgSs+T/iTK94VXRicodc5eYYFZc
         9pXeF0kAJDN7/JWfZ1nWQOjFTHbk3L4gQMRJ93LeMNipt/wqgIbPWCU+NUr1nRr8eR3J
         zIIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682062187; x=1684654187;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N+iZ1aFyoi01Oag2G0IVEtycCaHj8d8JsSoYMnnAS8s=;
        b=eMbW2Mz+M0sQ7P5IhvDvvUIOGUSJV83y6z2OxsBnDTT6gAI79VdpM1gVe/0xPpqBEX
         lwSXKzZUOhW/xUUz6HckdboaS90BZU/RuMJwMs/TQHX2zTjuZ4H0lAyYC3+5PvHzNQXs
         rSc0xyvn9C16JFqPTsMIex9w+OYYQ2sXAxLlVkGD5HOtR8gY7j3FD+cu9LRt4Oe/k0ZQ
         9sqlgMTwDKgZGqSdV/oQgD5L6A5eJnNh0G0tQwsB+pskZQLo/ilIiUESZKLMu4OTSTdo
         gmRbflYyZlkFnnY/5DSIommhSDGMDVCItMD5BVcWNl2YD+4ihlXhk9aNFX1rTpxtrsyJ
         8YIw==
X-Gm-Message-State: AAQBX9ck5hk5n5HJ3niZV9r/uvwNkAP8cxqgZjNJJ8Z2S9kgnSgN4CbT
        uJU32oBcddhXgXgr6QAvvQx4ng==
X-Google-Smtp-Source: AKy350azq/JG2p2vKeECMHZp/w2A8ZvW4QmweQeB9Z6MJLwx4q7Ifbu/S8dQKqzIgf2nQaaeS+sviA==
X-Received: by 2002:a17:906:35c6:b0:94a:9c9e:6885 with SMTP id p6-20020a17090635c600b0094a9c9e6885mr1316489ejb.58.1682062186815;
        Fri, 21 Apr 2023 00:29:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:668b:1e57:3caa:4d06? ([2a02:810d:15c0:828:668b:1e57:3caa:4d06])
        by smtp.gmail.com with ESMTPSA id s22-20020a170906169600b0094f3132cb86sm1712708ejd.40.2023.04.21.00.29.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 00:29:46 -0700 (PDT)
Message-ID: <e2069707-3f09-f1e7-6973-a2e115af7536@linaro.org>
Date:   Fri, 21 Apr 2023 09:29:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/6] dt-bindings: net: Brcm ASP 2.0 Ethernet
 controller
Content-Language: en-US
To:     Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-2-git-send-email-justinpopo6@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1681863018-28006-2-git-send-email-justinpopo6@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 02:10, Justin Chen wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> Add a binding document for the Broadcom ASP 2.0 Ethernet
> controller.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 146 +++++++++++++++++++++
>  1 file changed, 146 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> new file mode 100644
> index 000000000000..3817d722244f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
> @@ -0,0 +1,146 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"

Drop quotes.

> +
> +title: Broadcom ASP 2.0 Ethernet controller
> +
> +maintainers:
> +  - Justin Chen <justinpopo6@gmail.com>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +
> +description: Broadcom Ethernet controller first introduced with 72165
> +
> +properties:
> +  '#address-cells':
> +    const: 1
> +  '#size-cells':
> +    const: 1
> +
> +  compatible:
> +    enum:
> +      - brcm,bcm72165-asp-v2.0
> +      - brcm,asp-v2.0
> +      - brcm,asp-v2.1

Is this part of SoC? If so, then SoC compatibles are preferred, not IP
block versions.

> +
> +  reg:
> +    maxItems: 1
> +    description: ASP registers

Drop description.

> +
> +  ranges: true
> +
> +  interrupts:
> +    minItems: 1
> +    items:
> +      - description: RX/TX interrupt
> +      - description: Port 0 Wake-on-LAN
> +      - description: Port 1 Wake-on-LAN
> +
> +  clocks:
> +    $ref: /schemas/types.yaml#/definitions/phandle-array

Drop.

> +    description: Phandle to clock controller

Drop.

Instead maxItems.

> +
> +  clock-names:
> +    const: sw_asp

Drop entire property.

> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0

Missing additionalProperties:false. Look at existing bindings how it is
done.

> +
> +    patternProperties:
> +      "^port@[0-9]+$":
> +        type: object
> +
> +        $ref: ethernet-controller.yaml#
> +
> +        properties:
> +          reg:
> +            maxItems: 1
> +            description: Port number
> +
> +          channel:
> +            maxItems: 1
> +            description: ASP channel number
> +
> +        required:
> +          - reg
> +          - channel
> +
> +patternProperties:
> +  "^mdio@[0-9a-f]+$":
> +    type: object
> +    $ref: "brcm,unimac-mdio.yaml"
> +
> +    description:
> +      ASP internal UniMAC MDIO bus
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +  - clocks
> +  - clock-names
> +  - ranges
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    asp@9c00000 {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation

> +        compatible = "brcm,asp-v2.0";
> +        reg = <0x9c00000 0x1fff14>;
> +        interrupts = <0x0 0x33 0x4>;

Use proper defines for flags.

> +        ranges;
> +        clocks = <&scmi 14>;
> +        clock-names = "sw_asp";
> +        #address-cells = <1>;
> +        #size-cells = <1>;


Best regards,
Krzysztof

