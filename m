Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61A386180AD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 16:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiKCPKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 11:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiKCPJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 11:09:59 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C149A1B793
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 08:08:52 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id 8so1313829qka.1
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 08:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l+EbiXy8hAP8VoNeBUH8kmx6qnfyvhvIHdBBRAmU5R4=;
        b=OG8EyXDCnL1LKRvTvPRHdeCYPRnOIPoCGKIqnexGpgNzpywiOvEGk0BzugzSpulEJ3
         PhCBbjQqAqTSsHPczIDxxMzZ5q7uXrdJDfl/3Fso/mvshPOdJ3dggTannDZGwRYfZ2Fg
         X+uTsfTkM8z/73k/3iENP+1GrX3o2njxob3LGbDwVzx+RytLTL+dlqtXbt466SuSwoFe
         npXXFxveRYWxdU6/dASR18z6MiJQwMUM0AGdu0oRrVd8g6jEnhoPbqgQNV98XuhLTEUf
         CjoTMwq/XHc7c1oaYp8qOJjTLUmJl0iNVqmZ35kwtbdJEibXt2dG64ix6ABBHM38bCcq
         8uoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l+EbiXy8hAP8VoNeBUH8kmx6qnfyvhvIHdBBRAmU5R4=;
        b=jyHnG97NEeqyAjrAOGpuUnr600AFaKAVWwL7zhiD150A0Z7rM9TRnEmNddiim7yX9I
         wvrJ/qu/bzPzXj/54jtz6BTFFNysoSR63W4mJrDJpYcsaPok3y/QAbmOlccVuevQNelA
         ZJsJTWyt/lAri7Ad1ZN+3lzdvLZ6yKsh3XiimR/hQ0rOv7hMCrjJLArJ9U570KPvShFD
         3Yia8KQ8X6EK7jrgqWYbMqFPHtT1K90RO8bYpyG37MUUrujXvHRPLYxa+7mGqP00uwGL
         cSReRYsBtULiPtu7Xg7nm6JgryiXHMJQOAL3Lx4QCHxnHkndDpcmw6N5+aX1a8Pw3Fb3
         LpKQ==
X-Gm-Message-State: ACrzQf2fBkihVbwwGbJxBeQcGydyplZ+XF2O1rieHYrJGlNMHndcJzfw
        78G8nA/c/QSJAjVZ9818eSFyXA==
X-Google-Smtp-Source: AMsMyM6H2OQKbEbvh+qBl09dMiE4Iho9/knHDmPJlnQFflAX3jWAvGOhMYn2dhpItHW/cdlf5kGSYg==
X-Received: by 2002:a37:a09:0:b0:6f9:9f68:5296 with SMTP id 9-20020a370a09000000b006f99f685296mr22239487qkk.83.1667488131730;
        Thu, 03 Nov 2022 08:08:51 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:a35d:9f85:e3f7:d9fb? ([2601:586:5000:570:a35d:9f85:e3f7:d9fb])
        by smtp.gmail.com with ESMTPSA id u4-20020a37ab04000000b006f9e103260dsm881423qke.91.2022.11.03.08.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 08:08:50 -0700 (PDT)
Message-ID: <6d1bd86e-29f0-a3b2-700b-978d64990d56@linaro.org>
Date:   Thu, 3 Nov 2022 11:08:49 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3 net-next 2/8] dt-bindings: net: mediatek: add WED RX
 binding for MT7986 eth driver
Content-Language: en-US
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, lorenzo.bianconi@redhat.com,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org
References: <cover.1667466887.git.lorenzo@kernel.org>
 <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <2d92c3e282c6a788e54370604f966fc7a5b479bf.1667466887.git.lorenzo@kernel.org>
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

On 03/11/2022 05:28, Lorenzo Bianconi wrote:
> Document the binding for the RX Wireless Ethernet Dispatch core on the
> MT7986 ethernet driver used to offload traffic received by WLAN NIC and
> forwarded to LAN/WAN one.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  .../arm/mediatek/mediatek,mt7622-wed.yaml     | 62 ++++++++++++++++++-
>  .../arm/mediatek/mediatek,mt7986-wo-boot.yaml | 47 ++++++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-ccif.yaml | 50 +++++++++++++++
>  .../arm/mediatek/mediatek,mt7986-wo-dlm.yaml  | 50 +++++++++++++++
>  4 files changed, 206 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
>  create mode 100644 Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> index 84fb0a146b6e..9e34c5d15cec 100644
> --- a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7622-wed.yaml
> @@ -1,8 +1,8 @@
>  # SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
>  %YAML 1.2
>  ---
> -$id: "http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.yaml#"
> -$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7622-wed.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#

Split the cleanups from essential/functional changes.

>  
>  title: MediaTek Wireless Ethernet Dispatch Controller for MT7622
>  
> @@ -29,6 +29,50 @@ properties:
>    interrupts:
>      maxItems: 1
>  
> +  memory-region:
> +    items:
> +      - description:
> +          Phandle for the node used to run firmware EMI region

Merge above two lines. Drop "phandle for the node used to run"

> +      - description:
> +          Phandle for the node used to run firmware ILM region
> +      - description:
> +          Phandle for the node used to run firmware CPU DATA region
> +
> +  memory-region-names:
> +    items:
> +      - const: wo-emi
> +      - const: wo-ilm
> +      - const: wo-data
> +
> +  mediatek,wo-ccif:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo controller.

Drop "Phandle to". Same in other cases.

> +
> +  mediatek,wo-boot:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo boot interface.
> +
> +  mediatek,wo-dlm:
> +    $ref: /schemas/types.yaml#/definitions/phandle
> +    description:
> +      Phandle to the mediatek wed-wo rx hw ring.

rx->RX?
hw->HW?

> +
> +allOf:
> +  - if:
> +      properties:
> +        compatible:
> +          contains:
> +            const: mediatek,mt7622-wed
> +    then:
> +      properties:
> +        memory-region-names: false
> +        memory-region: false
> +        mediatek,wo-boot: false
> +        mediatek,wo-ccif: false
> +        mediatek,wo-dlm: false
> +
>  required:
>    - compatible
>    - reg
> @@ -44,8 +88,20 @@ examples:
>        #address-cells = <2>;
>        #size-cells = <2>;
>        wed0: wed@1020a000 {
> -        compatible = "mediatek,mt7622-wed","syscon";
> +        compatible = "mediatek,mt7622-wed", "syscon";
>          reg = <0 0x1020a000 0 0x1000>;
>          interrupts = <GIC_SPI 214 IRQ_TYPE_LEVEL_LOW>;
>        };
> +
> +      wed1: wed@15010000 {

That's a separate example. - |
Drop wed1 label.

> +        compatible = "mediatek,mt7986-wed", "syscon";

And where is the compatible added?

> +        reg = <0 0x15010000 0 0x1000>;
> +        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> +
> +        memory-region = <&wo_emi>, <&wo_data>, <&wo_ilm>;
> +        memory-region-names = "wo-emi", "wo-ilm", "wo-data";
> +        mediatek,wo-ccif = <&wo_ccif0>;
> +        mediatek,wo-boot = <&wo_boot>;
> +        mediatek,wo-dlm = <&wo_dlm0>;
> +      };
>      };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml
> new file mode 100644
> index 000000000000..6c3c514c48ef
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-boot.yaml

arm is only for top-level stuff. Choose appropriate subsystem, soc as
last resort.

> @@ -0,0 +1,47 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-boot.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title:
> +  MediaTek Wireless Ethernet Dispatch WO boot controller interface for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-boot provides a configuration interface for WED WO
> +  boot controller on MT7986 soc.

And what is "WED WO boot controller?

> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-boot
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      wo_boot: syscon@15194000 {
> +        compatible = "mediatek,mt7986-wo-boot", "syscon";
> +        reg = <0 0x15194000 0 0x1000>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
> new file mode 100644
> index 000000000000..6357a206587a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-ccif.yaml
> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-ccif.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Wireless Ethernet Dispatch WO controller interface for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-ccif provides a configuration interface for WED WO
> +  controller on MT7986 soc.

All previous comments apply.

> +
> +properties:
> +  compatible:
> +    items:
> +      - enum:
> +          - mediatek,mt7986-wo-ccif
> +      - const: syscon
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - interrupts
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    #include <dt-bindings/interrupt-controller/irq.h>
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      wo_ccif0: syscon@151a5000 {
> +        compatible = "mediatek,mt7986-wo-ccif", "syscon";
> +        reg = <0 0x151a5000 0 0x1000>;
> +        interrupts = <GIC_SPI 205 IRQ_TYPE_LEVEL_HIGH>;
> +      };
> +    };
> diff --git a/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> new file mode 100644
> index 000000000000..a499956d9e07
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/mediatek/mediatek,mt7986-wo-dlm.yaml
> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/mediatek/mediatek,mt7986-wo-dlm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MediaTek Wireless Ethernet Dispatch WO hw rx ring interface for MT7986
> +
> +maintainers:
> +  - Lorenzo Bianconi <lorenzo@kernel.org>
> +  - Felix Fietkau <nbd@nbd.name>
> +
> +description:
> +  The mediatek wo-dlm provides a configuration interface for WED WO
> +  rx ring on MT7986 soc.
> +
> +properties:
> +  compatible:
> +    const: mediatek,mt7986-wo-dlm
> +
> +  reg:
> +    maxItems: 1
> +
> +  resets:
> +    maxItems: 1
> +
> +  reset-names:
> +    maxItems: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - resets
> +  - reset-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      wo_dlm0: wo-dlm@151e8000 {

Node names should be generic.
https://devicetree-specification.readthedocs.io/en/latest/chapter2-devicetree-basics.html#generic-names-recommendation


Best regards,
Krzysztof

