Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4186B5D66
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:43:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbjCKPne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCKPnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:43:32 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24B726CDC
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 07:43:29 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id cn21so2169124edb.0
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 07:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678549408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=joefQDumS5DAEug0aZemuXUZtj8AzGARl18WyLpCzIM=;
        b=DGDcAxUp+bLWAmNzmfOwGpGCJaSQM7d0nEuc7q+J3VArbV/wz0SQnQHNByGf8jJIGc
         FMbNjljsJQiDkiUsk/ErLLxySK5ObggKRsG3pZ0p6kOWY1BM2EdKYWnLcURT2oBJ1x/m
         HyAOzZ9K48nD09XaEpXJihHclNPGpX3X+PGiniJCpLrwXwAOAnWFR+17+efivj89IZtX
         1VjCeP8OMrLyDIpKMBoIOabrqmLdN3X+zhkdgcf+YV22AFllSe6pOibZyIn5IeHjrPHR
         KqaToW3JLXMqoil/0fSztggAayKqiDrOUC7khnSYP56WKP4tQMEU8f6MaNDD0JJtx6uW
         5NHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678549408;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=joefQDumS5DAEug0aZemuXUZtj8AzGARl18WyLpCzIM=;
        b=3ppX4ByZdFb4EMNjkuuq18Gex5UL2BNHGrTzj5+PuaAH+MUhpXovmA4a0y1Aw3pK1R
         B5RMnFonieFro7Cbcp6K3PQf5pFYMd41r70h9RSkx1pzzer4ONcPZYLtEC8MgC+reslb
         AOu5cX5Vj4nB2XsFwEmUtZ2Sh71dhG4djylO06sSwZKhIRTQbgwk07eATNzmIPW37UZc
         3QOQp7VhLGShVP9kjettD12AiWUZZ4zEFT3/AIPg9fkEW5G3VhQ0TVxgF0Mc2FJUeNpp
         ie94Rl7IqbgEuaFCF7lYD5O3Lb8NJm5h3SuT0lxobLAHtZj//wjAez2L+UEElO1R0v0A
         qfCg==
X-Gm-Message-State: AO0yUKWHlLDEiaxyTcJc3xhWhOj1SEBK3EXfewIcsdwErpSoT7+22AfJ
        bf0Iqop+HDtpfLCcyST9FSvepQ==
X-Google-Smtp-Source: AK7set+SYz5w+m7N9cpwUO+BTOJg00mFqXkmIwLNwt6Hbg+I/FT8TbgGXCvZl9e8K3Kg1qnTzDE0BA==
X-Received: by 2002:aa7:cd55:0:b0:4c0:e156:7954 with SMTP id v21-20020aa7cd55000000b004c0e1567954mr22784637edw.34.1678549408198;
        Sat, 11 Mar 2023 07:43:28 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:6927:e94d:fc63:9d6e? ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id g8-20020a1709065d0800b008def483cf79sm1190278ejt.168.2023.03.11.07.43.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 07:43:27 -0800 (PST)
Message-ID: <75f4c8a8-c0ec-a2e9-ec81-23cebef59c19@linaro.org>
Date:   Sat, 11 Mar 2023 16:43:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss: Drop pinmux
 header
To:     Nishanth Menon <nm@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-gpio@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, Tero Kristo <kristo@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
References: <20230311131325.9750-1-nm@ti.com>
 <20230311131325.9750-2-nm@ti.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311131325.9750-2-nm@ti.com>
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

On 11/03/2023 14:13, Nishanth Menon wrote:
> Drop the pinmux header reference. Examples should just show the node
> definition.

You could mention that it is not used.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>



Best regards,
Krzysztof

