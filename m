Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFC0D659C50
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 21:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235444AbiL3UuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 15:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235164AbiL3UuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 15:50:06 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3B6DE83
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 12:50:04 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id z10so20700128wrh.10
        for <netdev@vger.kernel.org>; Fri, 30 Dec 2022 12:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y6b9aelL9iSEbjyOBwL53WmG//4FVZXwYLwFNbDpMUw=;
        b=UCCgE4fCvwFxwjRK0yqscFsK3vDERv1qxNA9peDx8gyIK+a8/FgD2X9kHWgF9H4VJM
         qlpFIqNXW2wUUtAahQVXwtFvSgO8LAHd2luBNq3m6fh2Dy16Zk0K8csGaoqkt+1uPBLz
         KJXtoRaKO7H/I+r0bWwP+FEL4HcdT6ouoUk72Biak4xLsaykZ1eMdKEA7s4jbY4uB5Os
         Beld5Cs/ZNFIuaFEndlE5Ul4WiYRu8HEsvc/eIkqQejNmjwv3QHmLxQBtiWs5owKA8+f
         fRILj6CqkdMB7xwVTX4+6vSxXRqzq2t/0OgycASrqwatUyeQBIuhdETa1eJb1Oot+xtG
         UZJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6b9aelL9iSEbjyOBwL53WmG//4FVZXwYLwFNbDpMUw=;
        b=RJgoTnV+Vs5LrExf598IEaiVisbAscIqzOEYazM6IqQR5DgZIgA3y/X8MYY7EZ+Soh
         kV7YSs+HZpvLwFVJ/YJUeKf8oxAAUnS1wtcW87PyjhffAMhb3p/JFPV7q9OrICOa06PS
         Ofnvbv1rS7HarUPND0f9L8Zt4E4JlgmHVVDfD+E5hUnhiD+rRLSCI8Db0cih6oCNV5Vn
         dHjaDKiEoiKiJnZJykFXqK8JNe0sLlS0wmEN+2zKUMQo3vC5ZCU3jkeMdqPXXG2a/cfI
         vkd0L0dlOZ6pkk369qhTsLdlqjqkX/up1UPrlq9a822IJRK6CHPUfFez/NX7co0BN8D3
         Z9lA==
X-Gm-Message-State: AFqh2kowZzAFjhCYfNFcFfeQlcdmLgX8QpbflYhfLl98vhEZO47V5L71
        A8W8z7JuEB9TWCWQNfSeexRFcQ==
X-Google-Smtp-Source: AMrXdXs9zsAkclgd1Vq9SvyW38PaxbPK3XY99VdcD1efED48RBNOm7YL3SK6EhMGoQ2pzLyYvqQuXg==
X-Received: by 2002:a5d:6808:0:b0:272:3a86:29c1 with SMTP id w8-20020a5d6808000000b002723a8629c1mr17458587wru.16.1672433403417;
        Fri, 30 Dec 2022 12:50:03 -0800 (PST)
Received: from [192.168.1.12] (host-92-24-101-87.as13285.net. [92.24.101.87])
        by smtp.gmail.com with ESMTPSA id o15-20020adfe80f000000b0028965dc7c6bsm7006911wrm.73.2022.12.30.12.50.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 12:50:02 -0800 (PST)
Message-ID: <1dee1e8e-60dd-0a9d-ad4f-1370bba66bde@linaro.org>
Date:   Fri, 30 Dec 2022 20:50:01 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: qcom,ipa: Add SM6350
 compatible
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     Luca Weiss <luca.weiss@fairphone.com>, andersson@kernel.org,
        konrad.dybcio@linaro.org, agross@kernel.org, elder@kernel.org,
        linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221208211529.757669-1-elder@linaro.org>
 <mlVN9KS9KdswblsJtK7F6Yyu3c3vWIsdzIwAo8iVaZDt_Ti53FvYwfzzVF60yEeCXuw17joStgI1cti0HipwCA==@protonmail.internalid>
 <20221208211529.757669-2-elder@linaro.org>
From:   Caleb Connolly <caleb.connolly@linaro.org>
In-Reply-To: <20221208211529.757669-2-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 08/12/2022 21:15, Alex Elder wrote:
> From: Luca Weiss <luca.weiss@fairphone.com>
> 
> Add support for SM6350, which uses IPA v4.7.
> 
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Caleb Connolly <caleb.connolly@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipa.yaml b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> index 9e81b9ec7cfdd..4aeda379726fa 100644
> --- a/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> +++ b/Documentation/devicetree/bindings/net/qcom,ipa.yaml
> @@ -49,6 +49,7 @@ properties:
>        - qcom,sc7280-ipa
>        - qcom,sdm845-ipa
>        - qcom,sdx55-ipa
> +      - qcom,sm6350-ipa
>        - qcom,sm8350-ipa
> 
>    reg:
> --
> 2.34.1
> 

-- 
Kind Regards,
Caleb (they/them)
