Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F55A6C2AB7
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 07:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCUGsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 02:48:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbjCUGsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 02:48:11 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C3D420061
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 23:48:00 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id i5so8801708eda.0
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 23:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679381278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wInF6GafTuPljjFUA+Is8vEjW4Pl6T2we7ZsIWHpBdc=;
        b=t9qzeK5r/pPr7nWar54bwzgkW8DFarwVWfGFpk9NaytbIwZEw12umrs7bj5QwxiuK9
         +kES/0g4F0MOIqGI3y0l3OhtGun11qEdDNfxlGop6VqcPTYPWZiDsGR6MWW4HCkzKWje
         nIezYvISRxREMY9fTomU4/11ue8ESMWS4hggPvBp3S3VmXnorkI5pZ9V1KEZvhlPzbqy
         noAwHJARgZzzi+g7afH2SqNj6avLPLAFW13JEKXKc7AkAMtRUGwm40CRFQj9R3zAEcJQ
         bjV9n63wr2KXFRgENQYbp/6cJ6azeqYMXLsTGiaad8fCbNzd8Me7BOEfbYj8BF+dg5KV
         TqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679381278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wInF6GafTuPljjFUA+Is8vEjW4Pl6T2we7ZsIWHpBdc=;
        b=usRZ9ensBjWNxWgGG5mmxRyjvjSl/DoHHq1SOPJZ28K1t3+VMeWBOA3CkrteooVFWk
         N2hs2376+0u75755AvpmRo6CYg8eRXHiI6eQRmZoXa2nluu4SNyOgusdLaS1SXCptD7m
         +0Z3iVF2AUuUefnX7a7MtM/mRJleoBMpekQHWKHWlsyr1wCZgDmsoQt/+ydqfRIsnCQZ
         6LGL+vRKGmBYS4jOTXRvfnbC+ZWHP+SmjUimM8gtkUU40ONPYRY/uFL/JcmLSP4rxTn/
         Pk9OJM+w2VHqVNwkwppOxheoflwgfGZu2xzA/6gzdo6BEEgOioU6oNS9h+goEZEEo8/O
         M9NA==
X-Gm-Message-State: AO0yUKW5n0/K2CMb8Gefo4HQHo8crzowAYsV/deKjdWQm2q2UMGvsIVf
        lSRMD/1THvIoLTY9V06J2aCAwg==
X-Google-Smtp-Source: AK7set+yUBYPnpsgcGFshQfAIT5gVBUyoTKz/PVli/szhlsgnT8leqFozAyoOp7o+jk4oZaehIJKDw==
X-Received: by 2002:a17:906:397:b0:932:1af9:7386 with SMTP id b23-20020a170906039700b009321af97386mr2043033eja.27.1679381278702;
        Mon, 20 Mar 2023 23:47:58 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:2142:d8da:5ae4:d817? ([2a02:810d:15c0:828:2142:d8da:5ae4:d817])
        by smtp.gmail.com with ESMTPSA id qq24-20020a17090720d800b008df7d2e122dsm5344909ejb.45.2023.03.20.23.47.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 23:47:58 -0700 (PDT)
Message-ID: <48261996-1993-7c9c-b090-eba68157aecf@linaro.org>
Date:   Tue, 21 Mar 2023 07:47:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 04/12] dt-bindings: net: qcom,ethqos: Add
 Qualcomm sc8280xp compatibles
Content-Language: en-US
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        sboyd@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
References: <20230320221617.236323-1-ahalaney@redhat.com>
 <20230320221617.236323-5-ahalaney@redhat.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230320221617.236323-5-ahalaney@redhat.com>
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

On 20/03/2023 23:16, Andrew Halaney wrote:
> The sc8280xp has a new version of the ETHQOS hardware in it, EMAC v3.
> Add a compatible for this.
> 
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---
> 
> Changes since v1:
> 	* Alphabetical sorting (Krzysztof)
> 
>  Documentation/devicetree/bindings/net/qcom,ethqos.yaml | 1 +
>  Documentation/devicetree/bindings/net/snps,dwmac.yaml  | 3 +++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> index 88234a2010b1..c60248e17e5a 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ethqos.yaml
> @@ -21,6 +21,7 @@ properties:
>      enum:
>        - qcom,qcs404-ethqos
>        - qcom,sm8150-ethqos
> +      - qcom,sc8280xp-ethqos

This still needs sort.

Best regards,
Krzysztof

