Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422556C2E72
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 11:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjCUKMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 06:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbjCUKMv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 06:12:51 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27D2C26CE2
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:12:48 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b20so24540520edd.1
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 03:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679393566;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MBblg6ouqKODHyX877fXDi2urk7+HMZmQEWvK4N+5xA=;
        b=cyDchbnmi/K2X12VsJrtHmzOjhrjENPwu2ileUBtV/RR8kgrZ0leVFpzOYCfij+f8s
         +j0bZQSRs/xu91acp5PQGXNgAyIDjwcpuExswfSxzVRjnvoiryoQqjxckO02RX9RZUwE
         Uyz4OfHVdkj2VLarrKqf4fzVEd9lh5y2GPMzm3nnByYCs7FmDLUTw/uzJPuT+m5NUSkF
         FHrzc2YTyAYiXxW4nsBVVBpeddlVENEZ8XQvNE6RXkAZHCtOqvAQBAsyl7kw9ONLHFkT
         3fZwrtBB3WppLix8HvgVD9jWpWM3/6BDfqmkPmssj0pcorizhIN0+KD8P5ok8DVg/GP7
         Z8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679393566;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MBblg6ouqKODHyX877fXDi2urk7+HMZmQEWvK4N+5xA=;
        b=G+mS2VxAYx/LBTHg/7FK+ZiqzIkDW0g48OHY7jrJXflylonMBS1m2i8R77zBRKwwYA
         8bwqT4zjgFDpqFM8OwI97q9gK6WFyDnToYdn2vDW17d0n2HF5C6qVldTzSm5KDfUQVqo
         9LvBB9TLccG39yE50xim3R27XHY/xMKwCtF8A/HWAXt/czmx6j6nYosaoRu2vmN5okvY
         bnrrfT13Wh2wqG/mUyRPpXddYLxQCRGah5itfmeYYIZ6OsblsQAkVQFCUu1N+NyRusbR
         q/ZRLybjemAEH7nMt2RRqOJ+zXgc/DhqUdViM5i5M250rvYJ/4E80IyVSIuiApGAjYE3
         w1mA==
X-Gm-Message-State: AO0yUKX//E3RH6AXf5AT/QG+7+ABQMp3W9T0uz8mlht//oP0TmqPjftZ
        Erq+V02xNJ5Qn8KyVAcJGM6njw==
X-Google-Smtp-Source: AK7set9y91HFCneDKUYOtGWZfa4sI4vIRE5C0iaFvRabDlbD7NgNvD8qB02c9rR0uphL/1AlejObbA==
X-Received: by 2002:aa7:d317:0:b0:4fb:5795:b7e0 with SMTP id p23-20020aa7d317000000b004fb5795b7e0mr2523640edq.31.1679393566673;
        Tue, 21 Mar 2023 03:12:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:2142:d8da:5ae4:d817? ([2a02:810d:15c0:828:2142:d8da:5ae4:d817])
        by smtp.gmail.com with ESMTPSA id g9-20020a056402320900b004fd219242a5sm5983006eda.7.2023.03.21.03.12.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Mar 2023 03:12:46 -0700 (PDT)
Message-ID: <c4d67c22-6953-0f2c-4b80-cc9ab2ab5e8b@linaro.org>
Date:   Tue, 21 Mar 2023 11:12:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 1/2] dt-bindings: wireless: add ath11k pcie bindings
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
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230321094011.9759-1-johan+linaro@kernel.org>
 <20230321094011.9759-2-johan+linaro@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230321094011.9759-2-johan+linaro@kernel.org>
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

On 21/03/2023 10:40, Johan Hovold wrote:
> Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6855
> for which the calibration data variant may need to be described.
> 
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  .../net/wireless/qcom,ath11k-pci.yaml         | 58 +++++++++++++++++++
>  1 file changed, 58 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,ath11k-pci.yaml
> 

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

