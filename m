Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F96F62554F
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbiKKIap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231397AbiKKIan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:30:43 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5749654C4
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:30:42 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id g12so7340126lfh.3
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 00:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hrnI1MMknS51ZDdp7gq4JuxX4S3fw0/B9/ygHLoG+Gc=;
        b=mpuPULLEet7biTYrB7NHYa6DedN1VB3nlS8l2m/zyWnAvnFRpMxlO4HkR2WNDFnzR/
         pBCG3HAR4S+qnjkskeZ6EakD+VABTquYZqnfV1SCcQWOGi7VGDSjyXudDlSbzuW4MrIb
         vzha6MT03hIgC/dGq6jTl56uzC+ED9tGPYMo+JtsDFsj6uNiS8sFFCQa2wSsBFnV4mT/
         LzAmJsmJUSQnkOaeoSvkxZV/+2UEIy2nGCWWEBeKBsBwQXXQryygi/gOn6n6l2cSSfMe
         XRp1zaFpDB1EVQoGGgrpBm6VDcutbkqn9s7A72IQTHLZ4DKIeXAeesJIL1nDP/J/Xux3
         ExDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hrnI1MMknS51ZDdp7gq4JuxX4S3fw0/B9/ygHLoG+Gc=;
        b=aCi52N8O1khSEQwr03+EjlPCsCylCXkidEZBc56tTR8yWbolCLWVlxJum6GP1hac8g
         Vg4YBwvP2xKT9M3/JhwXuhIcfbmcIpaSQXyN7jR6FniObGxktPS42po4dKxkMr5YLFNM
         DmsY5zVBDwrcTYn1OkhqIZrBD9zThZjOZqE6qPv7zkcFLJGWLJkNdn5ffLTLTi4TJVHh
         LUYrk2OAuTsjMT8SOlE7RChBp7k/cNzK+9chagRm0TJvZISN8R5IKJH/lo71XU1M1PdT
         IMwr6Evi9Z0cpjqTUL/riJAhzXbbi4MZF8NK4asJ1bIKqSxMnge++PNv79FcBrk1FSdv
         Cxvw==
X-Gm-Message-State: ANoB5pmbP5Bj7BifUkTKUt+sLQXdpixOUv0WPshFTk9nbs12KukbbLnp
        H6PxiBfFgTfnqZj51hiqa2Pw2w==
X-Google-Smtp-Source: AA0mqf7c+RlYfpF8xEXHp48mDlPI+cGjAyFcyWDabKp9R6pOqfNE3GDhhGpOZMMpvoAagMn7dABTww==
X-Received: by 2002:ac2:5461:0:b0:4a2:8cac:96ab with SMTP id e1-20020ac25461000000b004a28cac96abmr378149lfn.415.1668155441159;
        Fri, 11 Nov 2022 00:30:41 -0800 (PST)
Received: from [192.168.0.20] (088156142199.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.199])
        by smtp.gmail.com with ESMTPSA id s11-20020a2eb62b000000b00277050abd55sm277444ljn.130.2022.11.11.00.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 00:30:40 -0800 (PST)
Message-ID: <81890fa5-5793-1ee4-14a4-78c08024f3fb@linaro.org>
Date:   Fri, 11 Nov 2022 09:30:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 2/2] dt-bindings: net: qcom,ipa: restate a
 requirement
Content-Language: en-US
To:     Alex Elder <elder@linaro.org>, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     andersson@kernel.org, konrad.dybcio@linaro.org, agross@kernel.org,
        elder@kernel.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221110195619.1276302-1-elder@linaro.org>
 <20221110195619.1276302-3-elder@linaro.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221110195619.1276302-3-elder@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 20:56, Alex Elder wrote:
> Either the AP or modem loads GSI firmware.  If the modem-init
> property is present, the modem loads it.  Otherwise, the AP loads
> it, and in that case the memory-region property must be defined.
> 
> Currently this requirement is expressed as one or the other of the
> modem-init or the memory-region property being required.  But it's
> harmless for the memory-region to be present if the modem is loading
> firmware (it'll just be ignored).
> 
> Restate the requirement so that the memory-region property is
> required only if modem-init is not present.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 13 ++++++++-----


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

