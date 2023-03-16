Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F486BC845
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 09:08:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjCPII4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 04:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjCPIIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 04:08:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147DC15163
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:08:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id eg48so4058655edb.13
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 01:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678954130;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jqgjNRTTYxXEBu4RgHLIKOV2OMvEZgDykND/jjBfs/c=;
        b=XTd0nL85CNSMECdA4C0i9h2sZ1dQYnlDTfsrFcWMv+qzAfAn7WxJzdm1xCKhhE7S7J
         Ech53iIFir39KilPHOrlU/+sIwThxbSkxKevwxwJgQrUV8y//OufCdPPpOZDwSGwQtae
         gmvkUUH9eR4WIvKMhs0lRFEHq3gJpzoUb2IlQmQfbvQjhmk6vIXnWesO+7eMbatY8Lt/
         +ZNN4lZnwWFvJ2jEUDajXhf/6Lt/mpOZYn4mdwuJGbe0aUkZqbNAuOqFtcfOo12lrnoz
         B0A36PWIIW2NzOd+lKVvXDoKQYzM37r0ZhJGJEcPuau22/2e/aOb+QqbAmamRkWoV+gp
         VHzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678954130;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jqgjNRTTYxXEBu4RgHLIKOV2OMvEZgDykND/jjBfs/c=;
        b=Oq+PMjFO7Ipodsr3YvDP1nh9mJ49VuylTRv7OCGqIbIbWII4yxG5teY16QxbZAyvVv
         CB8/xJIRYAzkNeEKT1jqO8o5OusTLGLr7YJ5c9d2wOFYBtLKNZr0x/PeshxM6HRDcSlm
         PVY4Z8OCyzubS2iO5GshXXvjqonZE7en2B3UDAPFCnmKo1LltBaZ9FPg1zV8yalTJ/S6
         gvAqnNc0Qb2pAqTWhDPnwi74vpyX1dcX6t8aIkMHcJH8PSi6XtLA1Mezyo17+ZWtD4KO
         x0SBoGxWxMKtoCU3FubyscOsqb2jN1r1tHHI4RlnmhOKVDvy16phhqX0sdFjXUmgpdLk
         1MvA==
X-Gm-Message-State: AO0yUKVJLBWttBrVTBxi2NUUP6E4I4SCAgm1cVEJq6wqimvM5DVUTtr5
        0vwggVEcBlLP2upMqeZPBRnM3w==
X-Google-Smtp-Source: AK7set/VThqElekS4hBXOwTeyPSy1a3TkMzQZlRz5q5wXZ64tA34znN1il3ES/tPjl0A/Zuqi4OL+A==
X-Received: by 2002:a17:906:8248:b0:8b1:2614:fbf2 with SMTP id f8-20020a170906824800b008b12614fbf2mr9306868ejx.70.1678954130576;
        Thu, 16 Mar 2023 01:08:50 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:9827:5f65:8269:a95f? ([2a02:810d:15c0:828:9827:5f65:8269:a95f])
        by smtp.gmail.com with ESMTPSA id c17-20020a170906d19100b008e57b5e0ce9sm3519551ejz.108.2023.03.16.01.08.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 01:08:50 -0700 (PDT)
Message-ID: <cee5e3d7-132c-2c6a-de11-c02ca6499231@linaro.org>
Date:   Thu, 16 Mar 2023 09:08:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next 13/16] dt-bindings: net: dwmac: Fix MTL Tx Queue
 props description
Content-Language: en-US
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>
Cc:     Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20230313225103.30512-1-Sergey.Semin@baikalelectronics.ru>
 <20230313225103.30512-14-Sergey.Semin@baikalelectronics.ru>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230313225103.30512-14-Sergey.Semin@baikalelectronics.ru>
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

On 13/03/2023 23:51, Serge Semin wrote:
> Invalid MTL Tx Queues DT-properties description was added right at the
> initial DCB/AVB features patch. Most likely due to copy-paste mistake the
> text currently matches to what is specified for the AXI-bus config
> properties. Let's fix that by providing correct descriptions for MTL Tx
> Queue DT-properties utilized for the AVB feature (CBS algorithm) tuning.
> 
> Fixes: 19d918731797 ("net: stmmac: configuration of CBS in case of a TX AVB queue")

Fixes must be first in the patchset.

> Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> ---


Best regards,
Krzysztof

