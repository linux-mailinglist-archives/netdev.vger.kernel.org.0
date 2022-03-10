Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9C4D4FB9
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244034AbiCJQsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244053AbiCJQsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:48:38 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05976BF94B
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:47:34 -0800 (PST)
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 6621A3F1A8
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 16:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646930853;
        bh=wWVrqZ7JJTH8Su/93i9Vl44N0LYGxLioIabuzPNt6dY=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=uNnhX4M/uSXSVnvqFi7QxUrP1P5Cq/g4n1DgB2y6gAQ4R4anOmU6GWe9RvXiWoYpZ
         JN5X3DpHt/Is6KPzzK/Y8aw6oFLyH4nSZ+v1VOVDr23GQUFHBvTnpKbrRF79KUufIh
         jUDTqsK+45DbhKpiAM6U1ABtywvStSzrLzDGV7a3yxL5bQsKfdDFfGy0F+G2OSHm7s
         5eZ1q+oQRVwutX+OrhO5+7D5c0AWwrXzySPPT/IGxM0Wy+k109+efCprBvLRco69a+
         kyWvMq0rUIWhkMBZVUJyUqciKFsa3U1HTCA8smbh9XI8Qri9m8xcVURGpZg9D40Xvh
         WeGH/09YakycA==
Received: by mail-ed1-f72.google.com with SMTP id i5-20020a056402054500b00415ce7443f4so3439344edx.12
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 08:47:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wWVrqZ7JJTH8Su/93i9Vl44N0LYGxLioIabuzPNt6dY=;
        b=6Im/ZvFsnAaaD9XK2E0vdIDZqhaG0KIHZXbq3aJqkjsGrOGJvmmddUEI9a3xWjD8l9
         rj4SSNL+8NXmhUppGrC+1F9ai0uifSyhD8O6JemPBwKfdeJCuQgmKXDyq/2ZiCErzLaS
         Ki4wr6zjY/SxmNwU+T3nqqVuAzZqUed6P0uvRAL6UG6xbVBXAaMxQbUi2vDJ7tXrFSSv
         TLVEWfME5laFxyiJY+gOc3R2TB8vu1rwZDqIaoW5goL8VEP8Po8l7vSgBa3ID7c9eZeQ
         qzCa4Tz1DypuPDMlNnAoSqoJ1arYaNp+t35mKRR+bVCk3Ie9eEbA25VlX6qV/UyDUA6Q
         wPRQ==
X-Gm-Message-State: AOAM532HrmnaZfjzv2K85C3UbBqavdPE7jCcvF/+580NOGi8q/V0x9N3
        /N0JQIoRg49anjROMvHz91xU3ISWFVqXMMs87+InY6LFqZvVYLGoD/svx1Rqqjh71pA2G+OsxsF
        O6lvlV8+Jj2GRf4fg6+kbofglY8q3HhtfYA==
X-Received: by 2002:a05:6402:10d5:b0:408:f881:f0f3 with SMTP id p21-20020a05640210d500b00408f881f0f3mr5237483edu.112.1646930852927;
        Thu, 10 Mar 2022 08:47:32 -0800 (PST)
X-Google-Smtp-Source: ABdhPJy++BoKBanQlX8IjQPl/omh12eZim/u509rcL+dxdwZ+W/nPbDlkvNHYK/wHstkZtmfEY57IQ==
X-Received: by 2002:a05:6402:10d5:b0:408:f881:f0f3 with SMTP id p21-20020a05640210d500b00408f881f0f3mr5237455edu.112.1646930852690;
        Thu, 10 Mar 2022 08:47:32 -0800 (PST)
Received: from [192.168.0.147] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id y12-20020a50eb8c000000b00410f02e577esm2269227edr.7.2022.03.10.08.47.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 08:47:31 -0800 (PST)
Message-ID: <a32fa8df-bd07-8040-41cd-92484420756d@canonical.com>
Date:   Thu, 10 Mar 2022 17:47:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
 <20220310145200.3645763-3-ioana.ciornei@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220310145200.3645763-3-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 15:51, Ioana Ciornei wrote:
> Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
> driver on Layerscape based SoCs.

The message is a bit misleading, because it suggests you add only
compatible to existing bindings. Instead please look at the git log how
people usually describe it in subject and message.

> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
> 	- none
> Changes in v3:
> 	- 2/8: fix 'make dt_binding_check' errors
> 
>  .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 98 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 99 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> new file mode 100644
> index 000000000000..e98339ec83a7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> @@ -0,0 +1,98 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/phy/fsl,lynx-28g.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Freescale Lynx 28G SerDes PHY binding
> +
> +maintainers:
> +  - Ioana Ciornei <ioana.ciornei@nxp.com>
> +
> +properties:
> +  compatible:
> +    enum:
> +      - fsl,lynx-28g
> +
> +  reg:
> +    maxItems: 1
> +
> +  "#phy-cells":
> +    const: 1
> +
> +  "#address-cells":
> +    const: 1
> +
> +  "#size-cells":
> +    const: 0
> +
> +required:
> +  - compatible
> +  - reg
> +  - "#phy-cells"
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +patternProperties:
> +  '^phy@[0-9a-f]$':
> +    type: object
> +    properties:
> +      reg:
> +        description:
> +          Number of the SerDes lane.
> +        minimum: 0
> +        maximum: 7
> +
> +      "#phy-cells":
> +        const: 0

Why do you need all these children? You just enumerated them, without
statuses, resources or any properties. This should be rather just index
of lynx-28g phy.

> +
> +    additionalProperties: false
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      serdes_1: serdes_phy@1ea0000 {

node name just "phy"

> +        compatible = "fsl,lynx-28g";
> +        reg = <0x0 0x1ea0000 0x0 0x1e30>;
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +        #phy-cells = <1>;
> +
> +        serdes1_lane_a: phy@0 {
> +          reg = <0>;
> +          #phy-cells = <0>;
> +        };



Best regards,
Krzysztof
