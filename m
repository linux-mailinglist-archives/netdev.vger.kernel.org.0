Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5466C2C21
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCUIRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjCUIQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:16:43 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 083F328E44
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:16:29 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id o12so56363455edb.9
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 01:16:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679386588;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tBxCksv4+AUPTCqkuOrtfjmwuvWpCvtIaxZde9QVqzY=;
        b=pXZtkMEqXzy0+xoqJLrZHYn0grjE1FgS1loxdgHeqZeGobhsZRyzNycuDfCxznPX0g
         LmtQbSEXhx7RRNabeE43+TLfPdnj0v/uADhnftBE8R6c9RjygcjtZ6kAr7BAAlIgWHTz
         CpTojZqkED840eapTpL6oncMLUKBtl4cK5ioVvg4Gs9lrjW5fhOg0jc10Rt/9hEu5isa
         t/Hu6nTuaHfPn7qNphkydJOkT6GbuwagDUn7c30s4NIlba0fzZPbWga/+bTi3p+FJwUQ
         FPDhHj24MlwWLEzLGtghug6hs7L2FK2Ih2c3rY7pw/kz6L9J2H2syAmLA4zbRYOnVffg
         xajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679386588;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tBxCksv4+AUPTCqkuOrtfjmwuvWpCvtIaxZde9QVqzY=;
        b=LaNrWKV9Xq/ho4a8QiS/ZOhRDFk4i5aRnZ2ZDwdz4vJaj/styxcKhLCWCRWylsGbha
         v3RB7WRQ/LNjmWSQUUIxQOqlQuI5rtTQIAeD7IA7/mI1qNvOB9ePfGTdjgvydviYH8+1
         wYuG85R/3yJcsFWX+ToRdYg5O2NohFem8Fj5Dp1VQD5Q6qxt5DNFXVXJeyjPIh1v9Ad5
         zD5KKSOGeZcCY4po4A540ru8xR1e7Z/J5iiKEMS6nvzarZ39Fj8F6hj/GufplwyPN477
         YOey1IrmhulJztP+D+6O9jf+kRvo6azDJsn4nWdxa+LW1Noh8FLXQNJ+Ao1DarD+kiN0
         3avg==
X-Gm-Message-State: AO0yUKULZ/vPqhhYCs9fsIFjGCaqyRU9V2uO9ns34qmy6s+x8Wietjg/
        KuqIyy5iR/z5YoVd4Gki89DnBw==
X-Google-Smtp-Source: AK7set9DFIlXBqYvUREvhQe/bGFPfuG9JsCCS2yRE6Ey5jvk6WdvPtAZWoSQxRPdwK+vRjhIsrAZCA==
X-Received: by 2002:a05:6402:114d:b0:4fe:9374:30d0 with SMTP id g13-20020a056402114d00b004fe937430d0mr2038401edw.39.1679386588525;
        Tue, 21 Mar 2023 01:16:28 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:2142:d8da:5ae4:d817? ([2a02:810d:15c0:828:2142:d8da:5ae4:d817])
        by smtp.gmail.com with ESMTPSA id r3-20020a50d683000000b004c0239e41d8sm5847287edi.81.2023.03.21.01.16.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 01:16:28 -0700 (PDT)
Message-ID: <09463d3e-0b80-f8d8-d358-cddae75484bf@linaro.org>
Date:   Tue, 21 Mar 2023 09:16:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
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
 <a8356f76-189d-928b-1a1c-f4171de1e2d0@linaro.org>
In-Reply-To: <a8356f76-189d-928b-1a1c-f4171de1e2d0@linaro.org>
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

On 21/03/2023 09:14, Krzysztof Kozlowski wrote:
> On 20/03/2023 11:46, Johan Hovold wrote:
>> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
>> for which the calibration data variant may need to be described.
>>
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> ---
>>  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
>>  1 file changed, 56 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
>> new file mode 100644
>> index 000000000000..df67013822c6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> 
> PCI devices are kind of exception in the naming, so this should be
> qcom,ath11k-pci.yaml or qcom,wcn6856.yaml (or something similar)
> 
> 
>> @@ -0,0 +1,56 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +# Copyright (c) 2023 Linaro Limited
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/wireless/pci17cb,1103.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Qualcomm Technologies ath11k wireless devices (PCIe)
>> +
>> +maintainers:
>> +  - Kalle Valo <kvalo@kernel.org>
>> +
>> +description: |
>> +  Qualcomm Technologies IEEE 802.11ax PCIe devices.
>> +
>> +properties:
>> +  compatible:
>> +    enum:
>> +      - pci17cb,1103  # WCN6856
>> +
>> +  reg:
>> +    maxItems: 1
>> +
>> +  qcom,ath11k-calibration-variant:
> 
> qcom,calibration-variant

Ah, so there is already property with ath11k, then let's go with
existing name.

Best regards,
Krzysztof

