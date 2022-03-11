Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9A584D621E
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 14:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240257AbiCKNKO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 08:10:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238154AbiCKNKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 08:10:13 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 597961C2310
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:09:09 -0800 (PST)
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 189A23F62D
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1647004148;
        bh=NV42Tsh6ksYymUGQsb6VXgBFoYR1XLFl1LciE1oosJM=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=rP9pNcjjWbPQtLknj3V27NBGG4+PbYwi9PkEOh4LOKsYQyf2dw6E0nS8wwrdvvw3j
         1Y5vkj/kkts2U75NNxE/tsMw9BlH1Lu+rK5cUtofg5TCF7F2+htdK0Gp/yULRKWYln
         bryaXz5eazzasdUJ2r0nwbAoI+XTMNG82oSgTKJ12Z3+ypk4/pxzGoBD2Eob3VdH+R
         yNJ87IiZVKoov3e0ZAtbRWU2b8b0sAcTGB1ewF3iulJpeF5MSjQ+m4FDwpr1eFgfiP
         NoD8AbQvc1VKhuBS9L5setf6FeLfhCKyFWjiZTQYV04c8lB6ZhhXjkJJuvr1TrpnIX
         c5Ou/Q7mc4jUw==
Received: by mail-wm1-f70.google.com with SMTP id a26-20020a7bc1da000000b003857205ec7cso3461235wmj.2
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 05:09:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NV42Tsh6ksYymUGQsb6VXgBFoYR1XLFl1LciE1oosJM=;
        b=McSygnT7hmCSBU151ahGz/lkxEVFXd2ItRl+QpXvULGqAEREPvXjNxEw37PueUhCWz
         LufUSxsY8PF6A03FCgzE4AhsUT9NLeSfR0HApafe7ewK3SPo0vq2tuQdo14Ql8djdC2M
         Cz1jEmvqYTvpRZF3iCuWTLa4VlZMNc9m2zqPjURwMEeLf6v3TAL+j9ydKqrBd7Bg1J8d
         unJ7F2oLT4oOymID7KTbSR23E8Sc7624UljmAI1DdzYtMkxOJLDSZvBOMRzda6QJgHFm
         qp7Y+Y9TYsmup5HfR3GqC6vArwZoaZDRSJDOvEqU8i+HpP0SsF4KaI3FLAJGVnyPUR2w
         yqQg==
X-Gm-Message-State: AOAM531A5bz1sMEtDLjdFvFG94U65b2K5fwqq5HEsJMbasEB+TXe4siY
        G8Z/XlrBBnwYUAFsx98kD5yarVZBZ0mf07rowkX+lSolJBtmri8JSWwQgUuySgc/+V5bSF5NIVw
        6UjPU1waSbojFQdTxKigistG2VzaFM50GtQ==
X-Received: by 2002:a5d:4310:0:b0:1ef:fb60:e1d8 with SMTP id h16-20020a5d4310000000b001effb60e1d8mr7275973wrq.92.1647004147556;
        Fri, 11 Mar 2022 05:09:07 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyED6dgMrjY9eXx4ZHgAWm3pzIMZBlOht4JOuqN8JwR2d+4/pCQ98QGDhdAY9JgnNNKanzqDA==
X-Received: by 2002:a5d:4310:0:b0:1ef:fb60:e1d8 with SMTP id h16-20020a5d4310000000b001effb60e1d8mr7275953wrq.92.1647004147242;
        Fri, 11 Mar 2022 05:09:07 -0800 (PST)
Received: from [192.168.0.148] (xdsl-188-155-174-239.adslplus.ch. [188.155.174.239])
        by smtp.gmail.com with ESMTPSA id g26-20020a05600c4c9a00b00389a48b68bdsm6715945wmp.10.2022.03.11.05.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 05:09:06 -0800 (PST)
Message-ID: <f782bf45-3a69-18b4-de0b-f53669aec546@canonical.com>
Date:   Fri, 11 Mar 2022 14:09:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 2/8] dt-bindings: phy: add the "fsl,lynx-28g"
 compatible
Content-Language: en-US
To:     Ioana Ciornei <ioana.ciornei@nxp.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com
References: <20220311125437.3854483-1-ioana.ciornei@nxp.com>
 <20220311125437.3854483-3-ioana.ciornei@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220311125437.3854483-3-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/03/2022 13:54, Ioana Ciornei wrote:
> Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
> driver on Layerscape based SoCs.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
> 	- none
> Changes in v3:
> 	- 2/8: fix 'make dt_binding_check' errors
> Changes in v4:
> 	- 2/8: remove the lane DT nodes
> 
>  .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 40 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 41 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> 
> diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> new file mode 100644
> index 000000000000..dd1adf7b3c05
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
> @@ -0,0 +1,40 @@
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
> +required:
> +  - compatible
> +  - reg
> +  - "#phy-cells"
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +      serdes_1: serdes_phy@1ea0000 {

Comment from v3 still unresolved. Rest looks good.

Best regards,
Krzysztof
