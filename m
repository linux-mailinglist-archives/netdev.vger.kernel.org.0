Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E5626277B9
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 09:30:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbiKNIas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 03:30:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiKNIal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 03:30:41 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73EC1B9D8
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:30:39 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id p8so18050816lfu.11
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 00:30:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=j0IQsUMsq/danVFAsXOJQk7VxhiCEHCgZvuXYQZsPNw=;
        b=kZ+gfXhEHvCQ4i5fXaMGbyRs9ISamrJOufucrFkcHxvQoh4vBw/cwIZUfUf4JYNiSv
         26Bpr4SFOlHcgALinLxqix2jc/n+/nI2/+CpEQTf+yttEW/6G8rUIW2HutvLV/W2pkdB
         a1DQd3OfBOFy1pY2P+dhrAMzba32FqUCh3ssyF1mOhkaGInJgGCLRGWh6vyan2lYaqgt
         URIHHUT9URj3BNT3x7xI5ONIm1mzffBeq86x7QfjnugQSPPUgV9hDdOvfIPmh0nGO58r
         mevYIk2qWe+wi2w8cv2hXuEnz9Gy3ym+F1MVW4rQhSbQpeP3gu9Vw0kzjECVUreorCK0
         ZeIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j0IQsUMsq/danVFAsXOJQk7VxhiCEHCgZvuXYQZsPNw=;
        b=oDoaaokG77QNPbdmVPslVYFlEJSnzJ6rUUOgR7vZKMui16vXthoMbcvSiDD9s2l2pv
         5O9IoIddMml9hxaA3HMROuJgAqIjf2uW9Rs1XAgbxLzt8qOWnuIXE4RmKqxAUpJ8q2nj
         ZueHIuTHhV0ben/mneD5ArLGSnHtsb/RhFvYVplqX9pD5n0j4dGbPohQ322UY9UEzf7B
         KdItKctJKRrCP4/bP5qMpZ6tYwqDsVXsTRxa0TPoWgmPErtJRg/5DY36nATkSMCy6V+n
         xQMK1BrePp2/J6V4l7gkQndT6kQewHLR+cGd48CBKxjLjLCmzgJNmcJsJZeuEyS04Cbb
         W58Q==
X-Gm-Message-State: ANoB5pn+yH3h2doE1pGIOVEzrZEOuutjwSgF1qaHg3N6jdv7XzKwIYh2
        2jZV6QZJzPvp6lmzeJHIzscmqQ==
X-Google-Smtp-Source: AA0mqf5PXmLuqjVSEr72QK0K2RYhUlJwXF8LIcf4TRIc4twexmGAV0cltA+P/zb2eai/Dn2DYG/CTQ==
X-Received: by 2002:ac2:5314:0:b0:4b1:8fbb:d3f4 with SMTP id c20-20020ac25314000000b004b18fbbd3f4mr4016325lfh.70.1668414638117;
        Mon, 14 Nov 2022 00:30:38 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id c11-20020a056512324b00b00494942bec60sm1750581lfr.17.2022.11.14.00.30.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 00:30:37 -0800 (PST)
Message-ID: <ca43ac46-9ccf-7723-966b-9d3f8bc3b4fd@linaro.org>
Date:   Mon, 14 Nov 2022 09:30:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5/5] arm64: dts: qcom: ipq8074: add SoC specific
 compatible to MDIO
Content-Language: en-US
To:     Robert Marko <robimarko@gmail.com>, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221113184727.44923-1-robimarko@gmail.com>
 <20221113184727.44923-5-robimarko@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221113184727.44923-5-robimarko@gmail.com>
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

On 13/11/2022 19:47, Robert Marko wrote:
> Add the newly documented SoC compatible to MDIO in order to be able to
> validate clocks for it.
> 
> Signed-off-by: Robert Marko <robimarko@gmail.com>
> ---
>  arch/arm64/boot/dts/qcom/ipq8074.dtsi | 2 +-

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

