Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2E646B6FA4
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjCMGxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:53:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjCMGxI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:53:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB021B330
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:53:06 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id cn21so14212864edb.0
        for <netdev@vger.kernel.org>; Sun, 12 Mar 2023 23:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678690385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=355JmduZ4uMlUlIQ31cjHCMpZLn8xNHuHmgWguAmylE=;
        b=TKjYqz1a7T+SiMwBF2JBJQPhKxdCD0KdLlVhd39vwq2sigDRgokhrf/t9vQpGvto0v
         t4xshEKPSwSIdtWFW1TtLbUN2AVRzF3wSKpfjXgJwTRTmkLz4nv4N0UhAgpoM15/PTZw
         xABnZW6YJKyyo054gMKJBy0WhvqPEQiZiVQnuQzgZ1QVjxRfi1AL/ZhfBQXvZ4KzLrp7
         qKkcreWxgtBdBx5B1i9MnXLNm9yoP+U3FLCZrblg9hHjIYXZVe4W0pQt/9Uxx0QfAUsT
         JQrBs7kQeRKFi9k/iSbmMy2fY/4X5B9Y+yfGAHB8qWyotCgAfQt4z6K+EHRge6M4YkjV
         zkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678690385;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=355JmduZ4uMlUlIQ31cjHCMpZLn8xNHuHmgWguAmylE=;
        b=qdvMwrf27tR3LiAYsayAsC4OmH0TPpve1lDTirp0qWKBfrCePiNSa+pd7gvWZajJSu
         jR63sB28GUh5+vp7U3kXrnPvMgmY9Y3dBbncXJdWAXVYDGvWMHVxfbOWVu7zS2ffNFQz
         VzRZmBo11vkbDiLVTFvFySafQGgjzjtbxyr/FfwWAFfgZQIQtt4JsvGVlfsfuG4C8scA
         4Cs+pgFhd0Z6MdiwWeaB3mcpJC9TQdIYpF459ktE55y2UNWnhsfaPOXaOLoHqmW3xBTS
         P58U4QQJM987VOFXbmTxKfuer9bPl4YEfgiZ2JO/ETSAnonZpwEomdk46DKdAPLT1qoE
         Zg8A==
X-Gm-Message-State: AO0yUKWnFk5Y2AB7z7MwXm0XFsst6ZU87uDKZwO/juLQJWMZa3XC+557
        1OksU3d0RgJ8Iq/L2n02tHp82A==
X-Google-Smtp-Source: AK7set/JMEPJnNNs6jZniy5n06ov3Zsbv7uBujwS7EQrGGb8c4AMOdbWK4NwlzQf72j2A/zb37R0dw==
X-Received: by 2002:a17:907:a686:b0:902:874:9c31 with SMTP id vv6-20020a170907a68600b0090208749c31mr8600156ejc.35.1678690385052;
        Sun, 12 Mar 2023 23:53:05 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:f052:f15:3f90:fcb3? ([2a02:810d:15c0:828:f052:f15:3f90:fcb3])
        by smtp.gmail.com with ESMTPSA id h17-20020a170906261100b00921278f4980sm2603195ejc.34.2023.03.12.23.53.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Mar 2023 23:53:04 -0700 (PDT)
Message-ID: <1f10e6f7-1ef7-f16f-8a88-48cbf47ab448@linaro.org>
Date:   Mon, 13 Mar 2023 07:53:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] nfc: mrvl: Use of_property_read_bool() for boolean
 properties
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230310144718.1544283-1-robh@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230310144718.1544283-1-robh@kernel.org>
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

On 10/03/2023 15:47, Rob Herring wrote:
> It is preferred to use typed property access functions (i.e.
> of_property_read_<type> functions) rather than low-level
> of_get_property/of_find_property functions for reading properties.
> Convert reading boolean properties to to of_property_read_bool().
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

