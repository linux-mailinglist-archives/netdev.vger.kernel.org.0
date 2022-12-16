Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4EB64EA23
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 12:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbiLPLTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 06:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbiLPLTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 06:19:40 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA56D12ACB
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:19:38 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id b3so3026055lfv.2
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 03:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LMQ7FpzOBZak5beUJf6CKIqGy2hYvzKsc2zFOmDZfvI=;
        b=VajkuKQ58L51MwGIWzeMZwYkKycZ9q0wbkB1HOl/hNWLovr27Lwx/zr4ybvlMmx8TJ
         r3AGkzqvSPRKpIAjeq0l8ashsfg49oXwhgiIMyKL5JZnxct2+2R4Lx5iJK7g7oHvbR+g
         8stREbOkWE/EmW7/8p/rLR8h9fXX9lCcWF6w1/altSMURpQvN5fedvRZ9fAiC7D6SZzN
         wxghaIQkrOtU7qVoIHBZi0TBjnPGOFARn+BOMkZUSPrOTTHPZo1ijgpUKTZXwuVPBc0k
         pDbaiCKRDxWMKNRdUjKVdQegrIQGE+Trcij+1COkAukUJxXs0yPUbU2Ovt1Ro53kdDb3
         Bl3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LMQ7FpzOBZak5beUJf6CKIqGy2hYvzKsc2zFOmDZfvI=;
        b=JLzFqUvZfPprIj6k2nadaGkF2UfkxFddRoK6cwELzGqvCLGluQuUDyBmmBi34MxEke
         mHsZflog4i+XPuKrfnS0B2ZEU77LqzPcPheexPIUhpoUdJ4rzu3bHFRBkf/BIFaadnfo
         vMwYJ2BD9k2mmSOq0dv4XDKO282ekSQBOsTZMZ9Nk5PUwT5WTuI/9+mtcmZ/l6I3Y0vQ
         dp5iLA/zIUCVKnW7DyijPIZGt2eRBbZUggA9Fz+ILz9L9HEpHCeWlaU3kQmiY47+Lc5n
         tkBLHJFsKQ72EYB6H4IxhDdNi/TorA5SFBwVIt6YCSoIC3ZTjB0Iely3fHLDVz3LocvZ
         CP2A==
X-Gm-Message-State: ANoB5pnOke3jg9VWjYc5fZyThFlJlDtLkkez24ba+1cZiVa9CV4lukB2
        11iFopNXMHPu6lHyNmG6E96GuA==
X-Google-Smtp-Source: AA0mqf6E6R7NQ3gUyV3W6qibunKn/6TjbRWAoTtVX70oaOyFl1rGOA7DpTMXfyBr3vwnp2Szdebr7A==
X-Received: by 2002:ac2:4f0a:0:b0:4ac:ec52:e063 with SMTP id k10-20020ac24f0a000000b004acec52e063mr8769192lfr.29.1671189577159;
        Fri, 16 Dec 2022 03:19:37 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id k11-20020ac257cb000000b004b55da01d3csm190489lfo.191.2022.12.16.03.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 03:19:36 -0800 (PST)
Message-ID: <332ccb85-fb71-cf4e-0516-50b30420c49a@linaro.org>
Date:   Fri, 16 Dec 2022 12:19:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 7/9] net: stmmac: Add glue layer for StarFive JH71x0
 SoCs
Content-Language: en-US
To:     Yanhong Wang <yanhong.wang@starfivetech.com>,
        linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
 <20221216070632.11444-8-yanhong.wang@starfivetech.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221216070632.11444-8-yanhong.wang@starfivetech.com>
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

On 16/12/2022 08:06, Yanhong Wang wrote:
> This adds StarFive dwmac driver support on the StarFive JH71x0 SoCs.
> 
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Co-developed-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>


> +
> +static const struct of_device_id starfive_eth_plat_match[] = {
> +	{
> +		.compatible = "starfive,jh7110-dwmac"
> +	},
> +	{
> +		.compatible = "starfive,jh7100-dwmac",

NAK.

This wasn't even checked with checkpatch.

Best regards,
Krzysztof

