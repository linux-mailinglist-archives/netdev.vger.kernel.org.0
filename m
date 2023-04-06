Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CAAF6D90ED
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 09:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235147AbjDFH7Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 03:59:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235362AbjDFH7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 03:59:11 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83EA972A3
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 00:59:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id 4fb4d7f45d1cf-501d3943f8eso1147109a12.1
        for <netdev@vger.kernel.org>; Thu, 06 Apr 2023 00:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680767947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eGOZy8VGjSJ+0BmelGLbUSEWfzbtc8+M0JiKbqs9pJA=;
        b=N9G4spykgdCCFRTeP0t+ub9hYU31XZs52jbiORIrT3M6P+ym5e2uaHZOmZBw1/WDWu
         baZy/UEPhDGMkehJveh1Mu+Khce4DDvvmc8U1i8hX4zLqaerboboiX6irXSsQN1JFYxn
         M5GLLDYqMs+2h2sSBlyRzhv6fUMyFSqtzs24z+sKVsRRHn26eykSjuJgIkNVMzxG+RXZ
         hyDVy5cjnG3vtksjzGRfq8xyNQNDG+Wd2sD0hLdkMq5qIrw4c/0sznC7yO/5AlVL2pcM
         F3SHCfiL2ubj8BWW7ckDNW1GL02kQhlbbc9xrSbAHBs7Hc/9AdgFqcM8uDzJGUSPO+/u
         gVtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680767947;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eGOZy8VGjSJ+0BmelGLbUSEWfzbtc8+M0JiKbqs9pJA=;
        b=h9fRW0LP/UkyjapWFCrqWafxB4WHJyOj33+KbcITOtUoPX/OoLB1dpdOBNmo0yI8uk
         QsfNQd9WD/0qBmWewiM1HvOGVJZrv6BCC63qVPSNz4TOXRFTt4pxIzl/PhYyzbGMDDpa
         xx/rS+kMXp88+jFk5EyKTbJYnUMD0ecgVqbzfKekX0VfNQvLmoiOzvVopEv5rIzA7fPg
         AReUX60bpiooaz+PL3XJ+Xm1QueFbVhnU3kOvQAl0cOkNlII2nzwZa2r5WVXoJV7NXzT
         1k52sscbBtsDj6tK5C+EwBXuMmZ2esMTycw9ewDybazb7pynIXqkscsGUrNhE1LFRm3f
         gGWA==
X-Gm-Message-State: AAQBX9eTtZiXgblRZbIijZVv2VOm7IgiIczeeY+JN92ChFvVTpSG8SjJ
        41mZNDNtP9l6mkQ/g/iO7ZJh0Q==
X-Google-Smtp-Source: AKy350b1OxLYhmKxwlBHwx2zmsP1VmE6Ad6u8dVfEaQOoIeCNILRVP5Ym8zF9rUNNAkIPBP8KInS4A==
X-Received: by 2002:aa7:d3d5:0:b0:4fb:7ad6:907a with SMTP id o21-20020aa7d3d5000000b004fb7ad6907amr3913451edr.13.1680767946915;
        Thu, 06 Apr 2023 00:59:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed? ([2a02:810d:15c0:828:49e6:bb8c:a05b:c4ed])
        by smtp.gmail.com with ESMTPSA id t10-20020a50c24a000000b004aef147add6sm374853edf.47.2023.04.06.00.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Apr 2023 00:59:06 -0700 (PDT)
Message-ID: <7e1b0a58-55f4-8425-5d76-a5a3ace1edc1@linaro.org>
Date:   Thu, 6 Apr 2023 09:59:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 2/2] arm64: dts: qcom: sdm845-polaris: Drop inexistent
 properties
Content-Language: en-US
To:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Cc:     Marijn Suijten <marijn.suijten@somainline.org>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
References: <20230406-topic-ath10k_bindings-v1-0-1ef181c50236@linaro.org>
 <20230406-topic-ath10k_bindings-v1-2-1ef181c50236@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230406-topic-ath10k_bindings-v1-2-1ef181c50236@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/04/2023 02:59, Konrad Dybcio wrote:
> Drop the qcom,snoc-host-cap-skip-quirk that was never introduced to
> solve schema warnings.
> 
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

