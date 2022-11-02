Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D00616644
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiKBPe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:34:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiKBPeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:34:24 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434CC27B04
        for <netdev@vger.kernel.org>; Wed,  2 Nov 2022 08:34:23 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id v8so5477035qkg.12
        for <netdev@vger.kernel.org>; Wed, 02 Nov 2022 08:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LIpJx6qln47vp15nLOdszBjxMNyG6bb1Jar4R+gVU/M=;
        b=Rw5epargvcJXVs1AANV4fal/WDCpbm5+HPwPMyL/MFJLQqM3K0491J9E1wM4eFsnao
         HjqhqgciZLMJVC2hA6r91L6+cjhRr6ariVcJyNM9bu2/r9ZHY6HlyA3uB38jNkK/WIqn
         QWJ3VSV4NXT5B6qkrqKTsg6uZmNRXXFVpNqWAPeLFy+CgEwZo1mJB9yKCUI749VD4DMg
         WKJomoKpmfyca/wQs4fo2tqV0h2NBQ6Zbuvz9RQt61vwTGPHl8okGmM7F4aypeTgOxiZ
         GHmL7HuSAYWEtu9V6y0wJDgwvWvLUq3tjGDb/Nz8536090XJ1aTQu3vmNnpfy2iLYUbJ
         ps7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LIpJx6qln47vp15nLOdszBjxMNyG6bb1Jar4R+gVU/M=;
        b=4e2UaoTAJeHURqCeYWMTkvrPzNTtwiHTfvtBmkrmutEg2cdmZ88pYA4nLi/c0z1SZt
         UCsnhCqXnWy+I8LuhX1vJuogsaRQhWSvX9lTB9OLZLYaY7cF9w6LJ+Oy1/gl3f95VI3I
         lbPgSFrc0Y1vQNGPLnvCa4MQduSTV6RVg9juWTM3u6qF39JIijAsvXiHBPmCfcelKEVY
         /poznhy8YFia0G4uIwPJ9Fj2X8tD9leeRGu85cVITC0UO2ACnkxyyC/omC6Wkmj1+9JG
         PWbxMFybuWqdndXHtSDKSkP4g6qCoETfpj58Y1fpyrWgKTmIGsf7uErwkAEygwEUSNPV
         8rAw==
X-Gm-Message-State: ACrzQf2EaOGDMaIEIHmQgKb/ray86lrlp4ipShJyEKYthukXUHSm++yZ
        iNdXVN6GjZo+L8hBUBjN/n1Tjvc78x9Hfg==
X-Google-Smtp-Source: AMsMyM5kQoCim9/Y5wx5uUPLincyiCc8P5Ld9QgdtKPP1Hzn8W/K7b3JNeLQ+W/zZDdEEDx8nd0xug==
X-Received: by 2002:a05:620a:1d0c:b0:6fa:4e5d:a212 with SMTP id dl12-20020a05620a1d0c00b006fa4e5da212mr5812582qkb.47.1667403262397;
        Wed, 02 Nov 2022 08:34:22 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:28d9:4790:bc16:cc93? ([2601:586:5000:570:28d9:4790:bc16:cc93])
        by smtp.gmail.com with ESMTPSA id h10-20020a05620a284a00b006fa4a81e895sm2966851qkp.67.2022.11.02.08.34.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 08:34:21 -0700 (PDT)
Message-ID: <ff322db2-c4c4-b365-0ef0-9f223996d661@linaro.org>
Date:   Wed, 2 Nov 2022 11:34:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] dt-bindings: net: constrain number of 'reg' in ethernet
 ports
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20221028140326.43470-1-krzysztof.kozlowski@linaro.org>
 <20221028140326.43470-2-krzysztof.kozlowski@linaro.org>
 <20221031170344.07542bf5@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221031170344.07542bf5@kernel.org>
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

On 31/10/2022 20:03, Jakub Kicinski wrote:
> On Fri, 28 Oct 2022 10:03:25 -0400 Krzysztof Kozlowski wrote:
>> 'reg' without any constraints allows multiple items which is not the
>> intention for Ethernet controller's port number.
>>
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> There was some slightly confusing co-posting going on in the thread 
> (this patch is a reply to patch 1/2?) so given Rob's questions / nits
> I'll drop this from networking pw. Abundance of caution.

Sure, discussion is ongoing. If needed, I will resend.

Best regards,
Krzysztof

