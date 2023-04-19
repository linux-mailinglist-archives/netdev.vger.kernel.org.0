Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BF36E824F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 22:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbjDSUFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 16:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbjDSUFJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 16:05:09 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0226249D9
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 13:05:08 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-505035e3368so287916a12.0
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 13:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681934706; x=1684526706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O19qCOe0DTNX6gqRTl+uSUcgN/pbPN+NZIitnjjF7kU=;
        b=WpzhJ5mOLEIpKXG0XRpkqTHjOLPik2bQL9X7PsdCdaHBu/yf3B3+GVSaDYQ1MHriKX
         auq4CO/5oM0teoGCzA/49JRaU/urk1q3QCIluNfhYNMg7ePa1Obi2bc/T+/J/Gj/dtgH
         3Z0jxuVMSNLzQH4OAb9Yu/pqPSWpAXsOpeHy0vqLT82UINEy+ZimfleZQCwzi49cVmja
         wWdYYKVNDHWAOhYirwSkfKCYUFWfewrfWaUblRHf5iChOl6axhj7RV6HtrSB3J+fJPbL
         uapx2QB9WIY9P52+Bi8SmXDcuiTgt0K1snBh6/1bp+4DzpOdu8GdeW55HkE11l0TFUuv
         mczw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681934706; x=1684526706;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O19qCOe0DTNX6gqRTl+uSUcgN/pbPN+NZIitnjjF7kU=;
        b=h3quZBqnFeqqKLPfs/PhtSxhPt7IKxjemZbPjhaUTwb+cu6QH4hB0yOA7GIR7vzRej
         NOKbQcDwPmIrQ80eBrSswdQ8Y0yGtkoNaf9UeElRir9gTQ6+v3icaNoxwME4s8mF7Eem
         T9deHTJLqkuLmm6aDXvoV8Q8KmgAuKMiDcKPnBNOwRA4aFJqfGIVro3xDNFTO1DQbzy+
         z4nMKcpOhydlS79440hVX95eZJohScjU0+obsy01H5HHTYAJdw9pQ/DzFAwQClVcZ2bA
         zxmA6FipbjjjZJTvW1utQUSIG7uZCz1Oa0kAp1cK9WTHxOwVYcStTSJlYkbqadwH9H89
         QPmg==
X-Gm-Message-State: AAQBX9e+uZWGsd88/cbvR57xOlajkX0dRoMeIPEPjJMPGXbWketw5KIz
        h/MZD2XkrMw6fbK0opBS5IARuQ==
X-Google-Smtp-Source: AKy350aaLQ3lajWBdIxdSjFZYfHpAu1ZC15ZkICq3r8HSBuYErL71cxpOOL9pJEKVG9VG3IhfD1Qzg==
X-Received: by 2002:aa7:d882:0:b0:506:747f:3bf0 with SMTP id u2-20020aa7d882000000b00506747f3bf0mr7038464edq.8.1681934706426;
        Wed, 19 Apr 2023 13:05:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:976c:1d6c:6ed0:8935? ([2a02:810d:15c0:828:976c:1d6c:6ed0:8935])
        by smtp.gmail.com with ESMTPSA id k26-20020a056402049a00b0050841de16e9sm440030edv.64.2023.04.19.13.05.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 13:05:05 -0700 (PDT)
Message-ID: <4366b07b-a144-5e7f-ec41-1f58491b36f5@linaro.org>
Date:   Wed, 19 Apr 2023 22:05:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V2 1/3] dt-bindings: net: wireless: qcom,ath11k: allow
 describing radios
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Marko <robimarko@gmail.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20230418093822.24005-1-zajec5@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230418093822.24005-1-zajec5@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/04/2023 11:38, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Qualcomm ath11k chipsets can have up to 3 radios. Each radio may need to
> be additionally described by including its MAC or available frequency
> ranges.

The binding looks fine, but I wonder what is the radio here? It feels
like one antenna, e.g. 2.4 or 5 GHz, but you added $ref to
ieee80211.yaml which is used for entire device. What is the "radio" here?

> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
> ---
> V2: Fix dt_binding_check (add address + size cells & reg)
> ---

Best regards,
Krzysztof

