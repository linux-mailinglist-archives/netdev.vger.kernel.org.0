Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69FB26BE59B
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 10:29:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbjCQJ3o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 05:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbjCQJ3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 05:29:43 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3145C6438
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:29:40 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id ek18so17880712edb.6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 02:29:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679045379;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=znTFv1AubvRkYxUKPl9L0HioGGI6g5+jyLubCKmWzMA=;
        b=wtGl9qFCPsJoq10RvK+yfolMr869C5+9i6QYklJ98hucBK9JAF39zfr7vfKXsXkqy3
         7YxSPNflfYhC5UvDBtsNkDAI5mGrqCzMqfx2IA4znQztLQt7FCgQ7xWUr0yiyaryaiwR
         l5V59NeH9LwZrxzKBH5mHCCpquZ+nuknVAX1D0dq4L+hu/d5UjU0lMojzG+C5ZekNesM
         Q9/saAtcCtiPsmKQTZQjfdItptFH40YRFIeoBh3jv4fgnRKSm09x1EKGjBbIWFH0pVzu
         pD7k7oRy1QdMNWjnQzK/lgBkaGexeqPqiN1e8BsLlG7ZFoq1QXEsp6lXou7H+e3UvAys
         YZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679045379;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=znTFv1AubvRkYxUKPl9L0HioGGI6g5+jyLubCKmWzMA=;
        b=RynfyH3uB4w/6qJ9/2wDzdxOnT+dl+sTt0t4IBV6HvDFSzUSyFcFT0mzODsJXaSTAF
         1Sv47yDF8cgubO8+TIPqcj7leRaIVchPE85HaFhsrn3ZgT3AuUrbF/QdwBIJvCet4U1G
         SDpU9TUBIuDHgqieZAs1fIUyDkpa9aXA0SSBLO3qgleAUz7WQ1urUjgGaSIIGgBFovdl
         fT6jpoQjFbz2lz1/9hM0CXxwMAs1lhabdVNFexVmKYb4a/a1r5tKpl8ExxZXF36SiF0T
         khYK5smnVD4eRFtJ96NRVVRSRKH1WRFV7A97jGl5IxcBIZcfqBgtxcP2ZcuQjp/Ecxhf
         cw4Q==
X-Gm-Message-State: AO0yUKWmWAtgZwh5AtI38riGq2YHcHi8VabaAwetQIGGrLXWlFOgdVGG
        YwNd+OXxd9S2oHTgLwyhxX6+gg==
X-Google-Smtp-Source: AK7set9crObJqL5YWlw6KUzI7HalSFOlJyJHyWKk0TSc+f3TtUDK0no1jEdtROyNiVEa2+N7lU2k9w==
X-Received: by 2002:a17:906:99cc:b0:92f:2c64:9d43 with SMTP id s12-20020a17090699cc00b0092f2c649d43mr8903651ejn.68.1679045379236;
        Fri, 17 Mar 2023 02:29:39 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:848a:1971:93e0:b465? ([2a02:810d:15c0:828:848a:1971:93e0:b465])
        by smtp.gmail.com with ESMTPSA id gx24-20020a170906f1d800b0092d16623eeasm746092ejb.138.2023.03.17.02.29.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 02:29:38 -0700 (PDT)
Message-ID: <14492410-f52e-54c4-78a3-2426e17b037a@linaro.org>
Date:   Fri, 17 Mar 2023 10:29:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Fix compatible order
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        nsekhar@ti.com, rogerq@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230315075948.1683120-1-s-vadapalli@ti.com>
 <20230315075948.1683120-2-s-vadapalli@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230315075948.1683120-2-s-vadapalli@ti.com>
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

On 15/03/2023 08:59, Siddharth Vadapalli wrote:
> Reorder compatibles to follow alphanumeric order.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 4 ++


Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

