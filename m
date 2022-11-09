Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75EB66229A9
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 12:08:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiKILIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 06:08:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiKILIu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 06:08:50 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FD56444
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 03:08:48 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id k19so25229800lji.2
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 03:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Po/oE6njQiBff55UY7iHnbnmP3bUmGTTPuxVa98ca/E=;
        b=nfvstYiVEqJ4B/Y7gFTtFqb+zwkfqLe2oUHFU7Q7YPebY7s0Y6eV4YDZyHV1gJacNS
         ZPGY+4n7/m/BJmeCmxTqmJZCZ1H7NIlqd1/s4Fn0bmREAl5j6epjgIZ3ZPwEmM5DSUks
         emNd1839fXZhKI5ZA4UDQoEZTtaFr2k3DKpAqO+hEJBsHUAO+JCrZrmvSaC5NTHmy0nY
         OAkNK2SKZ0EvUF1McrXoUIO0vZVObAiCga1Y2o/BX3D8+ouuwWAKdJZDERtnFv+ppMnA
         oyp67D8pTGPkTxbgiuEXznxJydKPCw4mjf2p1RxCTLFIxZvV7Y5K+rIAv9NJu2c79Rbe
         xV9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Po/oE6njQiBff55UY7iHnbnmP3bUmGTTPuxVa98ca/E=;
        b=xHCk+5qfuZVhyGX+9VG2OI3OzJuzizF3YyfuTGvl83FU53kswzFocjqWLgUznbYJxl
         tTzvNiQvESTZBFnTvfjPl5528Ye55QcDXpwuDHDraiOZ/X+qWRLZvhAMKbElaPHeT0OU
         xbmG7tHQPzygxLPUSphHn2R9ehWUn7cR+tnVgoa8Ey0fYiP8MNdtt0SaA4vN8NQOmkaa
         2CRylOn7FZRhLnu0ky9sDWYfEexc7nIhOXRXJdwmx6dxm/EMnT+wzCqwqERaaceMQteD
         zxHx5ajF9ws2EDQoHEpT4cqP8q2G4dNaXqSEzj3e8SiBTdZ8VC3/urorHmfCiT0k1rQ/
         RS+w==
X-Gm-Message-State: ACrzQf1F0HS1MrXS7Vo4KYFddFTpp9gUCllVA8fRjxcc65mCXxmaiwd0
        3fWYOCjPfKzsCd2AFj8QvYP6Fg==
X-Google-Smtp-Source: AMsMyM5p0ZHZaQ/AP0mdulopVpCZmJQWvNB1dMM+Yrnm3uXNeQ33S1MOn6+4hX7dBKV3PZJIN/qZWA==
X-Received: by 2002:a2e:b006:0:b0:277:21c8:aac1 with SMTP id y6-20020a2eb006000000b0027721c8aac1mr8208645ljk.430.1667992127040;
        Wed, 09 Nov 2022 03:08:47 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id p23-20020a2ea4d7000000b002770473d813sm2040839ljm.140.2022.11.09.03.08.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 03:08:46 -0800 (PST)
Message-ID: <709daf8b-a58e-9247-c5d8-f3be3e60fe70@linaro.org>
Date:   Wed, 9 Nov 2022 12:08:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/6] dt-bindings: Document the SYSREG specific
 compatibles found on FSD SoC
Content-Language: en-US
To:     Vivek Yadav <vivek.2311@samsung.com>, rcsekar@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com,
        linux-fsd@tesla.com, robh+dt@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        aswani.reddy@samsung.com, sriranjani.p@samsung.com
References: <20221109100928.109478-1-vivek.2311@samsung.com>
 <CGME20221109100245epcas5p38a01aed025f491d39a09508ebcdcef84@epcas5p3.samsung.com>
 <20221109100928.109478-2-vivek.2311@samsung.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221109100928.109478-2-vivek.2311@samsung.com>
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

On 09/11/2022 11:09, Vivek Yadav wrote:
> From: Sriranjani P <sriranjani.p@samsung.com>
> 

Use subject prefixes matching the subsystem (git log --oneline -- ...).

> Describe the compatible properties for SYSREG controllers found on
> FSD SoC.

This is ARM SoC patch, split it from the patchset.

> 
> Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
> Signed-off-by: Pankaj Kumar Dubey <pankaj.dubey@samsung.com>
> Signed-off-by: Ravi Patel <ravi.patel@samsung.com>
> Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
> Cc: devicetree@vger.kernel.org
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Rob Herring <robh+dt@kernel.org>

Drop the Cc list from commit log. It's not helpful.

> Signed-off-by: Sriranjani P <sriranjani.p@samsung.com>
> ---
>  .../devicetree/bindings/arm/tesla-sysreg.yaml | 50 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> 
> diff --git a/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
> new file mode 100644
> index 000000000000..bbcc6dd75918
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/arm/tesla-sysreg.yaml

arm is only for top level stuff. This goes to soc under tesla or samsung
directory.

> @@ -0,0 +1,50 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/arm/tesla-sysreg.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Tesla Full Self-Driving platform's system registers
> +
> +maintainers:
> +  - Alim Akhtar <alim.akhtar@samsung.com>
> +
> +description: |
> +  This is a system control registers block, providing multiple low level
> +  platform functions like board detection and identification, software
> +  interrupt generation.
> +
> +properties:
> +  compatible:
> +    oneOf:

No need for oneOf.

> +      - items:
> +          - enum:
> +              - tesla,sysreg_fsys0
> +              - tesla,sysreg_peric

From where did you get underscores in compatibles?

> +          - const: syscon
> +
> +  reg:
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
> +      sysreg_fsys0: system-controller@15030000 {
> +            compatible = "tesla,sysreg_fsys0", "syscon";

Use 4 spaces for example indentation.

> +            reg = <0x0 0x15030000 0x0 0x1000>;
> +      };
> +
> +      sysreg_peric: system-controller@14030000 {
> +            compatible = "tesla,sysreg_peric", "syscon";
> +            reg = <0x0 0x14030000 0x0 0x1000>;
> +      };

One example is enough, they are the same.
> +    };
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a198da986146..56995e7d63ad 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2943,6 +2943,7 @@ M:	linux-fsd@tesla.com
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	linux-samsung-soc@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/devicetree/bindings/arm/tesla-sysreg.yaml
>  F:	arch/arm64/boot/dts/tesla*
>  
>  ARM/TETON BGA MACHINE SUPPORT

Best regards,
Krzysztof

