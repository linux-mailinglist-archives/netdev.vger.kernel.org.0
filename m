Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D143D6EAF3F
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 18:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjDUQgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 12:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbjDUQf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 12:35:59 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFC515446
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:35:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 4fb4d7f45d1cf-506b20efd4cso3120018a12.3
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 09:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682094957; x=1684686957;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B3xXYf8TTlU2/1ojoFhSjIL55VCuhyAcA1eyWc0djEo=;
        b=Sor67hOA1/JULAkvGJjP+cDue/xFOhnaoY7aiqCjAPBgbRT1GNh0cKKYbMhF5M4XyE
         LfSrbGuEhHHdBgzvuMdEMLvFuTyeDjT0YFf6JbkqnsN4a9oFjSnvOwvJwicU9Z0X+OJ1
         vwC4Fq0U1F+0T/okj1wlboZFVddCtNyk4Ch7LsgXx36Ap7ACQYN3jPQUBpE6z6GtFNiw
         u0JyXneZmaMcs5JROQiZw5EPfUMWgdTSJrfsv1k4hbBSSyJoZbqDQSwcy4K2yOC+K7MD
         k/ULY3OkHyXcE8d/64BAXNAA7dG6yTf5tvv5qeQnDE5lTHpPPHRWRwwnIvqzAGQle1gG
         K+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682094957; x=1684686957;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B3xXYf8TTlU2/1ojoFhSjIL55VCuhyAcA1eyWc0djEo=;
        b=dyD6xXyV6IKRikVj0c3+mM0xsT0VKJKFG1xEcoVh3JbhgSwHefz6yEFNGxHOCFT3SX
         4PA7bOZKdH3wqcgrIo0/GmaGyTvhiAj+o6HRyKP5dIIq9hMf8fX6mYDvrA2ZA+EzTiTU
         9iSezMijlXEXUQGe46IVRRMhcXxMUUpUV8Q3kYOmEfFAUENHwr6RVe7sQcTjYZupr4qI
         eV7YgfHnEqRa8vD9dj9ywScLqf0I65/522Zo1YhXmbo2HsDxotSssHDfFGTSl+EWmN41
         Jw6exNg45QOOz2OWlmI6f9kjZqDffSxCIoY+jjJJm14iriCrKPzrRHJghdHqlBg3sGH1
         5IOQ==
X-Gm-Message-State: AAQBX9csk2JJicji0t7zNjUroRYx0n4ULl4vnrFV5x1e9oTezSzvtXyJ
        aEfkKeC0qzRJwxIebo84Er4Dng==
X-Google-Smtp-Source: AKy350boQF7CjGbGArouyeaz2RM7OfQUMW7bsH6kjiwVj9BdnlvnjW2wn3qWocJsMuzqFUF8Kjdsqg==
X-Received: by 2002:aa7:da41:0:b0:506:8660:77a3 with SMTP id w1-20020aa7da41000000b00506866077a3mr5948346eds.37.1682094956706;
        Fri, 21 Apr 2023 09:35:56 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:687d:8c5:41cb:9883? ([2a02:810d:15c0:828:687d:8c5:41cb:9883])
        by smtp.gmail.com with ESMTPSA id w22-20020aa7d296000000b004fa99a22c3bsm1957151edq.61.2023.04.21.09.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 09:35:56 -0700 (PDT)
Message-ID: <bc454390-3658-f16b-aa48-58bdeef52d22@linaro.org>
Date:   Fri, 21 Apr 2023 18:35:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 1/2] dt-bindings: net: mediatek: add WED RX binding for
 MT7981 eth driver
Content-Language: en-US
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
References: <cover.1681994362.git.daniel@makrotopia.org>
 <b355493ed3d56396af91492b86f77f613485272a.1681994362.git.daniel@makrotopia.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <b355493ed3d56396af91492b86f77f613485272a.1681994362.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/04/2023 18:04, Daniel Golle wrote:
> Add compatible string for mediatek,mt7981-wed as MT7981 also supports
> RX WED just like MT7986, but needs a different firmware file.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

