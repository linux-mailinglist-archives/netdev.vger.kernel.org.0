Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D92654D9979
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 11:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347619AbiCOKuW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 06:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348555AbiCOKte (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 06:49:34 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D27DC52B21
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:47:23 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id C728B3F32D
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 10:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647341221;
        bh=Lmjm3yJ63K0GrvAMWP5PfVOb2pmYpXft2AVK3iZtb90=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=qbwgPUj6x31pOvFpugsy0Vk5pH3/RYfG0uWWdUyjhYlfB3ASR1YF63RjkKjXJyh2z
         2fJSTdnZQNe83ucgHKRcb65PJVTnkoLDW0gq6s9bNLC3F2tITM0/drq+a1CKdUBNt7
         JPWxg2I8vsEvbQZ+WsxRL1sVlpUaEagMVGYAbmkQ65Y+Uql014Mx+0gMgOwI4G33hD
         pjbTt+VsyRXaLkUzw2mUgyzmtfX/T13c0TQ2KpCqswxqh2XB9g6EdmFgIL/STcOTjB
         ZAE1GfMHdm92oPTdbZi95OzJB3IR/DAOBdtzyOw/+lddWH7CXL4vIVw8uRLQNk7QNf
         xV6gWADANsMuw==
Received: by mail-ej1-f71.google.com with SMTP id gz16-20020a170907a05000b006db8b2baa10so7032764ejc.1
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 03:47:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Lmjm3yJ63K0GrvAMWP5PfVOb2pmYpXft2AVK3iZtb90=;
        b=HS8Nvk6WIt428W6pI/dzoBLmXCuFwZ2ZFOy+Vf8Gw3P3v5klXWV7JvjEsdbsso4i13
         6s7RsOii0lCt0Ws3uoYGSSx3X/goLJPBvzi23Nid0xW//zUpXacvnS9jw81zGm5r23hg
         JBJ64I25XspuvMLefS3SxWQw7nXUWMcDoQ344xfToJkd9bAFwgE2A1SMwVyhwpc8Xj/6
         S339PZ6cu0AcjdY8SQ+MeE4mAdh/sD2Ss5Cf+e84e8xhOPhRvY2tOYRQk5wWREuHCRpM
         0Tu2o87hJTzd2OxuxacWLCRoIvo67gcLO1HmYgcBaLwxVKHbb1E5NSUqTfCFmDLU15pg
         i92A==
X-Gm-Message-State: AOAM531XDAZoJmrCeptegtIXLYfOvlO0HKK7KhN3oJYKuQQcdfORAu3Y
        FqelUlHyZZVVKWjVR65TC8x5U6QZOG6mBA6aH9Xzh2eWupdoIK3a9bgfmyQE1RqAv9OyWQ4hfv2
        f1oONFG06I+pC2lPiH+EJPWpSwsF5lALJew==
X-Received: by 2002:a05:6402:278a:b0:418:ad9e:8b65 with SMTP id b10-20020a056402278a00b00418ad9e8b65mr2485491ede.9.1647341220840;
        Tue, 15 Mar 2022 03:47:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz6nL12RCswbaC6DHPibcw16xO79D+Y2bi8IcqJHpaussAYU5/NVDJTAcwtyw7Q2DBt1I45Kg==
X-Received: by 2002:a05:6402:278a:b0:418:ad9e:8b65 with SMTP id b10-20020a056402278a00b00418ad9e8b65mr2485476ede.9.1647341220628;
        Tue, 15 Mar 2022 03:47:00 -0700 (PDT)
Received: from [192.168.0.155] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.googlemail.com with ESMTPSA id w15-20020a056402268f00b00416474fbb42sm9477594edd.19.2022.03.15.03.46.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Mar 2022 03:47:00 -0700 (PDT)
Message-ID: <4e6df448-5562-8f50-6f46-91acb279bc1a@canonical.com>
Date:   Tue, 15 Mar 2022 11:46:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 1/8] dt-bindings: pinctrl: mvebu: Document bindings for
 AC5
Content-Language: en-US
To:     Chris Packham <chris.packham@alliedtelesis.co.nz>,
        huziji@marvell.com, ulf.hansson@linaro.org, robh+dt@kernel.org,
        davem@davemloft.net, kuba@kernel.org, linus.walleij@linaro.org,
        catalin.marinas@arm.com, will@kernel.org, andrew@lunn.ch,
        gregory.clement@bootlin.com, sebastian.hesselbarth@gmail.com,
        adrian.hunter@intel.com, thomas.petazzoni@bootlin.com,
        kostap@marvell.com, robert.marko@sartura.hr
Cc:     linux-mmc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20220314213143.2404162-1-chris.packham@alliedtelesis.co.nz>
 <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220314213143.2404162-2-chris.packham@alliedtelesis.co.nz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2022 22:31, Chris Packham wrote:
> Add JSON schema for marvell,ac5-pinctrl present on the Marvell 98DX2530
> SoC.
> 
> Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
> ---
> 
> Notes:
>     Changes in v2:
>     - Remove syscon and simple-mfd compatibles
> 
>  .../bindings/pinctrl/marvell,ac5-pinctrl.yaml | 70 +++++++++++++++++++
>  1 file changed, 70 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/marvell,ac5-pinctrl.yaml
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/marvell,ac5-pinctrl.yaml b/Documentation/devicetree/bindings/pinctrl/marvell,ac5-pinctrl.yaml
> new file mode 100644
> index 000000000000..65af1d5f5fe0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/marvell,ac5-pinctrl.yaml
> @@ -0,0 +1,70 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/pinctrl/marvell,ac5-pinctrl.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell AC5 pin controller
> +
> +maintainers:
> +  - Chris Packham <chris.packham@alliedtelesis.co.nz>
> +
> +description:
> +  Bindings for Marvell's AC5 memory-mapped pin controller.
> +
> +properties:
> +  compatible:
> +    const: marvell,ac5-pinctrl
> +
> +patternProperties:
> +  '-pins$':
> +    type: object
> +    $ref: pinmux-node.yaml#
> +
> +    properties:
> +      marvell,function:
> +        $ref: "/schemas/types.yaml#/definitions/string"
> +        description:
> +          Indicates the function to select.
> +        enum: [ gpio, i2c0, i2c1, nand, sdio, spi0, spi1, uart0, uart1, uart2, uart3 ]
> +
> +      marvell,pins:
> +        $ref: /schemas/types.yaml#/definitions/string-array
> +        description:
> +          Array of MPP pins to be used for the given function.
> +        minItems: 1
> +        items:
> +          enum: [ mpp0, mpp1, mpp2, mpp3, mpp4, mpp5, mpp6, mpp7, mpp8, mpp9,
> +                  mpp10, mpp11, mpp12, mpp13, mpp14, mpp15, mpp16, mpp17, mpp18, mpp19,
> +                  mpp20, mpp21, mpp22, mpp23, mpp24, mpp25, mpp26, mpp27, mpp28, mpp29,
> +                  mpp30, mpp31, mpp32, mpp33, mpp34, mpp35, mpp36, mpp37, mpp38, mpp39,
> +                  mpp40, mpp41, mpp42, mpp43, mpp44, mpp45 ]
> +
> +allOf:
> +  - $ref: "pinctrl.yaml#"
> +
> +required:
> +  - compatible
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    system-controller@80020100 {
> +      compatible = "syscon", "simple-mfd";
> +      reg = <0x80020000 0x20>;

This is unusual. Usually the pinctrl should be a device @80020100, not
child of syscon node. Why do you need it? In v1 you mentioned that
vendor sources do like this, but it's not correct to copy wrong DTS. :)



Best regards,
Krzysztof
