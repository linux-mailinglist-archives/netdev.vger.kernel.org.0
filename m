Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55E6B6EAF39
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjDUQe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233136AbjDUQez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:34:55 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53E2E13F89
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:34:53 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-94f109b1808so316025766b.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682094892; x=1684686892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EsgLhwa1Y3Dit9q7Aba5iOCEKA1BynatRRqIwSMY4k0=;
        b=Am9QkEegkklyVMT9ls9O/2AuspxdFdHs/eOvjT3eAc++BPYy1vEb+tAXUb0C/YboJz
         SUmrtlFj4TA9FvOGr2PY8fzEnrx2qL2bZuKeM6nstgGKnX0sdYIr/JNTjr275d63Pfxg
         rc2pFlLecnCaebBKFu56vFvNECT4pSGUloBarHxzy+74pr0wNN/dQeAVWXpXXxEbJf6n
         W423xBgzLuZ1Qv5uDS8o80sGTrYApPMceCIF8CKrPKp3du6Dqp+1n/xcndEZ2Oz2g0qh
         44KZLpGxfoPCaRn2iS+xqARQMQo6iow15uDPYqalT1rpvBRNLxEnGWEVWj3Ek+tBXG/1
         iSAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094892; x=1684686892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EsgLhwa1Y3Dit9q7Aba5iOCEKA1BynatRRqIwSMY4k0=;
        b=g1oFdtU+NhGBtTTpP8KZbaZNUvtyvFXQpb0xg8XuorEe5BQO45hygZbXEcuZgBKm8+
         17jw/6KK9jpBtN7fc6r8F0iBpvHlyogYrc/KM0ZGIgit9Rz7vAzcFoAQ7rr8CDweFvZw
         ZN36RSxldPO89JiG4aTnuOe5iReBHrqzGwQif83+ZNxVpLyy5s+4U7oeufBO16oYnORJ
         Zov9OG5el+uWDxWR8RcIxU97FLbd9ZxPf4uux6PnLrqd9hSBv55X2qawcf765dDgoovF
         bC1u6MISAX+xeP0VzZ2kDc2d8/47wbSbtV3VzsEEiGs4SnVE+ChvrxUfyEmpAwlFIvyb
         AoWw==
X-Gm-Message-State: AAQBX9e8uursZygows4bC6i0z7ZFpO8mDpabB7d1HthLKPWWgQTAJxvr
        HnPpV+iF7DS0mWj3NRgYmZsrXQ==
X-Google-Smtp-Source: AKy350ZZrT448cL88phrLfnem0Nr+1DJTsIy14wJAqL7qIoVMmVdTpqr2w1NdOQJHZsBgP+kcZqzmw==
X-Received: by 2002:aa7:d88c:0:b0:506:adf0:ead5 with SMTP id u12-20020aa7d88c000000b00506adf0ead5mr5048223edq.30.1682094891767;
        Fri, 21 Apr 2023 09:34:51 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:687d:8c5:41cb:9883? ([2a02:810d:15c0:828:687d:8c5:41cb:9883])
        by smtp.gmail.com with ESMTPSA id i21-20020a05640200d500b00501d73cfc86sm2091328edu.9.2023.04.21.09.34.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:34:51 -0700 (PDT)
Message-ID: <64d12ac8-0fc7-264a-4a73-6cb642dcc319@linaro.org>
Date:   Fri, 21 Apr 2023 18:34:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 1/2] dt-bindings: pinctrl: qcom: Add SDX75 pinctrl
 devicetree compatible
Content-Language: en-US
To:     Rohit Agarwal <quic_rohiagar@quicinc.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        linus.walleij@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, richardcochran@gmail.com,
        manivannan.sadhasivam@linaro.org
Cc:     linux-arm-msm@vger.kernel.org, linux-gpio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1682079770-27656-1-git-send-email-quic_rohiagar@quicinc.com>
 <1682079770-27656-2-git-send-email-quic_rohiagar@quicinc.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1682079770-27656-2-git-send-email-quic_rohiagar@quicinc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/04/2023 14:22, Rohit Agarwal wrote:
> Add device tree binding Documentation details for Qualcomm SDX75
> pinctrl driver.
> 
> Signed-off-by: Rohit Agarwal <quic_rohiagar@quicinc.com>
> ---
>  .../bindings/pinctrl/qcom,sdx75-tlmm.yaml          | 168 +++++++++++++++++++++
>  1 file changed, 168 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
> 
> diff --git a/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
> new file mode 100644
> index 0000000..c141072
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pinctrl/qcom,sdx75-tlmm.yaml
> @@ -0,0 +1,168 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/pinctrl/qcom,sdx75-tlmm.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies, Inc. SDX75 TLMM block
> +
> +maintainers:
> +  - Rohit Agarwal <quic_rohiagar@quicinc.com>
> +
> +description:
> +  Top Level Mode Multiplexer pin controller in Qualcomm SDX75 SoC.
> +
> +allOf:
> +  - $ref: /schemas/pinctrl/qcom,tlmm-common.yaml#
> +
> +properties:
> +  compatible:
> +    const: qcom,sdx75-tlmm
> +
> +  reg:
> +    maxItems: 1
> +
> +  interrupts: true
> +  interrupt-controller: true
> +  "#interrupt-cells": true
> +  gpio-controller: true
> +
> +  gpio-reserved-ranges:
> +    minItems: 1
> +    maxItems: 105

maxItems: 67

Anyway you need to fix errors. Be sure you have yamllint and newest
dtschema.

Best regards,
Krzysztof

