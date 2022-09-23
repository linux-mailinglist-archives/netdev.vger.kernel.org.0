Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1FB5E8192
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 20:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbiIWSLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 14:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232300AbiIWSLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 14:11:37 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6F2F8C15
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:11:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id l12so917733ljg.9
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=bEsiJd/ABJ6GfZVhG9n8srep4jX5Ng0oqWanjXKMf3M=;
        b=wdf0UoY5ODBa65zXyvuXU6004RbmRtmAQtzkUjBFxlpQtsXPB6f8/sO1rqC0ZGgLp3
         4AMdVPtt9QHPuyI0VxvgIs+5MrEOgv6JoAB8AlLpxgFsMBIOnfWGqJCA6iLMwm3A9N5n
         ZIWhGGwWdLofl2d7Oa0JdtvK+ek0ZFgho+IdjF9Zua3H6P1m8VRuu/tO9eMrcsVF5l11
         CyOBznGHDjwORKYgfJR/Q4p4MPPirUKwQt2U7ZUq1syBcfAYIi47L3cQLBCIvD7tuIti
         xsWsttC3skEp4jaqH1xDk+E1USMXKtinN/Kps+8JXhGImmHsdG5MDsPXMIDqjiMzGcPq
         zmMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=bEsiJd/ABJ6GfZVhG9n8srep4jX5Ng0oqWanjXKMf3M=;
        b=DjBDaGol55I5Ii+mxAGrvIsXtJ0m0KhX9XJG4c1Zju+y6NFiIKokQvBYrZkXOfx0hB
         bkF9Z7Bqqp2IabsOKWPKV9CJSEm6s2LRAVzkMe3dGDloWQ2g81fDph4/lYbxbDHN1uCM
         8K8Im7IeMoDKkA5Hl5MS9pcPuqKdt5ob/gJmuaphDwi5plhSY434+HYeOthJ47IYSuVB
         xszMydyuXETI0MsBIbM07lZbJloUJIMrcR05BtO1Nie0Te6SagKxjI4myiXh9x8PE+Kz
         sD+mOCpfye40ZrZkzK0/9kxhPxAfh6OzD2D1IQnxG1hS6eVNbPUtgdUeuJWsY/YHR7Kf
         BdKA==
X-Gm-Message-State: ACrzQf3J1Y+Q8sdDDYg+BgP8uYcJPzVVOSCIrzvXONDVY4HMkfYeNfF9
        EcAQf0wSitLKNx8MxMLGPgI7XQ==
X-Google-Smtp-Source: AMsMyM5zQjSLuWsd99Ofx6D2TOw4gAeQDb4AO5KB8bpsuR/rhKVETepxlLfDTlGOKwf2sWnZ2pYplA==
X-Received: by 2002:a2e:92c8:0:b0:25d:6ddf:e71d with SMTP id k8-20020a2e92c8000000b0025d6ddfe71dmr3229734ljh.170.1663956694123;
        Fri, 23 Sep 2022 11:11:34 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id z12-20020a2eb52c000000b00261e2aab7c2sm1491057ljm.58.2022.09.23.11.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Sep 2022 11:11:33 -0700 (PDT)
Message-ID: <a215ae81-10de-7880-1a15-b7b08d0d80d7@linaro.org>
Date:   Fri, 23 Sep 2022 20:11:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v5 2/4] dt-bindings: net: snps,dwmac: add clk_csr property
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220923052828.16581-1-jianguo.zhang@mediatek.com>
 <20220923052828.16581-3-jianguo.zhang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220923052828.16581-3-jianguo.zhang@mediatek.com>
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

On 23/09/2022 07:28, Jianguo Zhang wrote:
> The clk_csr property is parsed in driver for generating MDC clock
> with correct frequency. A warning('clk_csr' was unexpeted) is reported
> when runing 'make_dtbs_check' because the clk_csr property
> has been not documented in the binding file.

Your subject is not accurate anymore. Maybe mention that instead of
existing clk_csr, you add a different property.

With commit msg fixes:

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

