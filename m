Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79436C2C18
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjCUIPF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:15:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbjCUIOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:14:21 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD83E1AC
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:14:18 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id o12so56344862edb.9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679386456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/GlY80fVC6uH/ZqU7yXSUIACPGr/6fR1rzfz7PKIC1U=;
        b=XTHClEkFj9/GzezOJiRBJAo+Tywih9fsnGLCx2EvfPO7EkU3qr0lhvujZ4rV/hC0bA
         AQzYjyLPOMFzqaZRQNA1Hxz63j2WJ92NwAyEG19ijt2gJb1h1nT92mk7a+ADJpaLc2e7
         jFytPhvYu6J1WM7YTxzs57YNFmKYVV2BWBRBjnOwgUHjAuopWFAQUVCrzb1Wb5KZnHrY
         VelFH6I+KLmKhYtvQdVPZca5ss7DQZTbQ2Z6wf1VUAasYPb848o2f3kJqWRkWA/7vJxa
         xXaYt68thkNcW5U3sUxorS9a6d+oVSnF1fyvyTfSyWb5H8c9CClCTZuj2H3xTQNJFAV9
         IonQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386456;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/GlY80fVC6uH/ZqU7yXSUIACPGr/6fR1rzfz7PKIC1U=;
        b=izNSYYyeoE/rs25X3zKeZts2xJ3WUYds5+XVPB1girkwrgLANw6izXO3fHQ2kQwH4g
         ol2hlHApsRX9sGECt8cN6WXu78DiRNFQoL3eXLLtom95Z0wPPOFFAR2P7qoZwoqZ2Uo/
         MupcdwQfsDiJl7jM89rP0rhG1hzQxQJoF8V86Stw2iF26K9F8WVv5Cs74ho5EcuwKpKK
         kmI8H/CHOAuUKvDgWJCu8CQvzHXUbaM6TsFvgGdhe8L4pzYl2YzS2rKaqVPCHquD6r2h
         BbuA79Szl0cFgHOo0vYPuYtCsPapEgXnztUzF6ga3CX0BNulEpHdfaHL0+344+TS7Oxj
         L+Dg==
X-Gm-Message-State: AO0yUKXD/uhnblzPy1I0me5L7Lc350BVgdz7hZyDozV2BS0iLB7F3TzV
        zlcj4UOhyNm1BrCBjgGHQ0kv8Q==
X-Google-Smtp-Source: AK7set+KavFTi/5gL3fFGZNK4zqO5JayQgZGCYyegKnxMgWSDSLPf/Gpn9hgDWKSYK0FTrdYRdNBLA==
X-Received: by 2002:a17:906:2756:b0:931:d350:9aef with SMTP id a22-20020a170906275600b00931d3509aefmr2159037ejd.25.1679386456630;
        Tue, 21 Mar 2023 01:14:16 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:2142:d8da:5ae4:d817? ([2a02:810d:15c0:828:2142:d8da:5ae4:d817])
        by smtp.gmail.com with ESMTPSA id m20-20020a170906259400b0092b8c1f41ebsm5411140ejb.24.2023.03.21.01.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:14:16 -0700 (PDT)
Message-ID: <a8356f76-189d-928b-1a1c-f4171de1e2d0@linaro.org>
Date:   Tue, 21 Mar 2023 09:14:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Content-Language: en-US
To:     Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-2-johan+linaro@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230320104658.22186-2-johan+linaro@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/03/2023 11:46, Johan Hovold wrote:
> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
> for which the calibration data variant may need to be described.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
>  1 file changed, 56 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> new file mode 100644
> index 000000000000..df67013822c6
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml

PCI devices are kind of exception in the naming, so this should be
qcom,ath11k-pci.yaml or qcom,wcn6856.yaml (or something similar)


> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (c) 2023 Linaro Limited
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/wireless/pci17cb,1103.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm Technologies ath11k wireless devices (PCIe)
> +
> +maintainers:
> +  - Kalle Valo <kvalo@kernel.org>
> +
> +description: |
> +  Qualcomm Technologies IEEE 802.11ax PCIe devices.
> +
> +properties:
> +  compatible:
> +    enum:
> +      - pci17cb,1103  # WCN6856
> +
> +  reg:
> +    maxItems: 1
> +
> +  qcom,ath11k-calibration-variant:

qcom,calibration-variant

> +    $ref: /schemas/types.yaml#/definitions/string
> +    description: calibration data variant

Your description copies the name of property. Instead say something more...

> +

Best regards,
Krzysztof

