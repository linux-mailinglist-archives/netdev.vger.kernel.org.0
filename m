Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A4068D46C
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 11:37:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231557AbjBGKhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 05:37:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231597AbjBGKg7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 05:36:59 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB6E38EAD
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 02:36:35 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id l21-20020a05600c1d1500b003dfe462b7e4so836840wms.0
        for <netdev@vger.kernel.org>; Tue, 07 Feb 2023 02:36:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6akUIoItLi3FPLFbzJ7SrzjHSbuoH+2n41Ug/RmLJwc=;
        b=dRcfv9CHkDxW/ZUOibWuY6fjH5+3zcpZ2Sx+P63o+6bUh6UFzD2QexUPBR2Nak9U8C
         YDq7V41MvojNOMA3BpXiMb9cV0gqX9oTi9uElt/85ajXg+xShHs4aaSlGbPw4+mnFYeS
         43v9xxZ868hbEK0E8vxdK1GgltJPpBthIgBg032n9N6P5zj4gH0Kxz6xL8JfXLZ4BsaX
         OSITbJR82H18wIS5pEc7QG1JQR26r3HLURTxe0KKShSre1H7BnEn1TK5A3sl5FzMRYnL
         HvUtSHb25hixtvU/gIAcxTEpQJ8KlqKK2UVvRXR8Yc4pIQB/nJmLPjXQ+vJq1Yai9i0e
         7tfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6akUIoItLi3FPLFbzJ7SrzjHSbuoH+2n41Ug/RmLJwc=;
        b=oMUMc3sMpP48FXe8IuMuoUzt4dOoTgmCfNPclBGDyrFxhHctK0NNX/aW8DpHyq1jP2
         Sj88b4Yqwx4XpticsPBeTMcPHMF3bnK96gdgJL29WVDdSpSJOIdG1D4PUMGpFfNiBo2F
         5ps+aOEZUJhtVE0MIPa9EuDw22GjT8HRjmTyHFK9ycKUlLNbrDY7O8UF8zUTTAfeY6Et
         MDJmrIDwrPh1vR2E530o90b/EG8c4LYznvsTdeelTF6FPBdKr0wGD3+kuJh4H90pX4n7
         00n5D+1xGUft1+zDmw/d2dUM1MoL1WTxW5ULOhCA9c6KBcBu4u7eq+70d1z4DdQiqwpZ
         mVeA==
X-Gm-Message-State: AO0yUKVk9EbIBuxIfNNVaz94miaJwbHh9YIJKuU0uV+HYTnRqV8YXC3H
        QoJueqA+2RLnSfncqKBYmTJZhQ==
X-Google-Smtp-Source: AK7set9dhWTRjD2sCEQ1PXiRWCf6P/rNr3G4SvS5+IcLaf3dVJAC7IrrK5MTz5yTEI2K3JWwmtIJ2A==
X-Received: by 2002:a05:600c:44c4:b0:3e0:14a:697a with SMTP id f4-20020a05600c44c400b003e0014a697amr2728064wmo.6.1675766193599;
        Tue, 07 Feb 2023 02:36:33 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id w14-20020a05600c474e00b003dfe57f6f61sm13680712wmo.33.2023.02.07.02.36.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Feb 2023 02:36:33 -0800 (PST)
Message-ID: <e56a9985-001e-fb42-f916-94f2bb5d6d13@linaro.org>
Date:   Tue, 7 Feb 2023 11:36:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 1/2] dt: bindings: net: ath11k: add dt entry for XO
 calibration support
To:     Youghandhar Chintala <quic_youghand@quicinc.com>, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230207103207.759-1-quic_youghand@quicinc.com>
 <20230207103207.759-3-quic_youghand@quicinc.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230207103207.759-3-quic_youghand@quicinc.com>
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

On 07/02/2023 11:32, Youghandhar Chintala wrote:
> Add dt binding to get XO calibration data support for Wi-Fi RF clock.

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Several comments were ignored.

Use subject prefixes matching the subsystem (which you can get for
example with `git log --oneline -- DIRECTORY_OR_FILE` on the directory
your patch is touching).

Subject: drop second/last, redundant "dt entry for". The "dt-bindings"
prefix is already stating that these are bindings.

dt-bindings: net: qcom,ath11k: add XO frequency offset

> 
> Retrieve the XO trim offset via system firmware (e.g., device tree),
> especially in the case where the device doesn't have a useful EEPROM
> on which to store the calibrated XO offset.
> Calibrated XO offset is sent to firmware, which compensate the RF clock
> drift by programing the XO trim register.
> 
> Signed-off-by: Youghandhar Chintala <quic_youghand@quicinc.com>
> ---
>  .../devicetree/bindings/net/wireless/qcom,ath11k.yaml         | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> index f7cf135aa37f..4745251e70d4 100644
> --- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
> @@ -41,6 +41,10 @@ properties:
>          * reg
>          * reg-names
>  
> +  xo-cal-data:
> +    description:
> +      XO frequency offset to program the XO trim register

This is a friendly reminder during the review process.

It seems my previous comments were not fully addressed. Maybe my
feedback got lost between the quotes, maybe you just forgot to apply it.
Please go back to the previous discussion and either implement all
requested changes or keep discussing them.

Thank you.

(missing type/ref, vendor prefix).


Best regards,
Krzysztof

