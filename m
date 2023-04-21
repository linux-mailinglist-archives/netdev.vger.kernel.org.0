Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF856EA51C
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231320AbjDUHnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbjDUHnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:43:18 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733C54208
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:43:16 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-95316faa3a8so216466966b.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682062995; x=1684654995;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQ6tUNbQr0gBTZA8iuY2w84kK0dZFD9Zeb92jq9bHGQ=;
        b=ul4pLogaDSm78AOEkl8Y4mu/tlwH26o5ejyYE/ug97QoM6QB3I1ofVBePog+mssOKO
         5Bgu2Y/pG1i04Mt3a3g1HFK8K0A4+CIcPIHzzxggbu6reKbeSmfxwDvNG8CNOir8mpYJ
         MePMlIsvW09b5Gdbujr/ViLA6R2JD2/7EnXAQOGDQnLWHRUP9c6h7aWOdjxhRXnjnzQ+
         InYdNxfoC5cEql5U1FW8vBF4Tt6Fj944dSnrZC8LJwn6yZjQugUWwkTKeLGGaHBkqh3k
         hByyxBFLjAl72vQuSo2+bi/zkbZg0Oq2OvqAEcVkJLolDiDhR3QE5EcXIZvoTizgqBHi
         Tvfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682062995; x=1684654995;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQ6tUNbQr0gBTZA8iuY2w84kK0dZFD9Zeb92jq9bHGQ=;
        b=HQJYi4i+YrS/0P0Ab3uA/nxc0gW9w8Lc5CfyHEIWqqiJ2snxgHFb1yO0NJrlPVmAXP
         P0Sv2d1DBr19mMEQK97jrr3cR1jpkt6+16MKoGxipdlNTq2PrOrYusAw/gJngbiZGq89
         zHkwEluwe758vRpuWvbL5oO5dhE5dAn/uVu0tanI/LKLnn1g4q6gw0C+AlkeZWZYmHRw
         /Uj1uc4xFUKVfnoCywKzK80gdN5iaJkPrm9aItfbbfTTBwuJg9xXny1rHyS8jwUiMU2O
         YnQqW5n2+HVBqSXFT0HN5LdBNsDqDgNqCNamGTc6Bk2eBWX7xeXcyV2S0JuQ9UVoTdN5
         Z8rw==
X-Gm-Message-State: AAQBX9c626JFKxjhIQRehkisPcTR6uRZSwMrq3HBj03CnowBo8FeWAN5
        R9DgVi+CRmco7/OUcASE90KgBQ==
X-Google-Smtp-Source: AKy350aB4v+mwockIVyi4LYQnDA/uLM4PrpP01lJrsoDu5tBp6jBJgvZthlEM6bEjpFzS2B+3m6Rlw==
X-Received: by 2002:a17:906:6a16:b0:8aa:c090:a9ef with SMTP id qw22-20020a1709066a1600b008aac090a9efmr1518820ejc.55.1682062994984;
        Fri, 21 Apr 2023 00:43:14 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:668b:1e57:3caa:4d06? ([2a02:810d:15c0:828:668b:1e57:3caa:4d06])
        by smtp.gmail.com with ESMTPSA id pv4-20020a170907208400b0094f49f58019sm1720848ejb.27.2023.04.21.00.43.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 00:43:14 -0700 (PDT)
Message-ID: <fa21a112-5331-7166-32ab-e3d314d80272@linaro.org>
Date:   Fri, 21 Apr 2023 09:43:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 3/3] dt-bindings: net: marvell,pp2: add extts docs
Content-Language: en-US
To:     Shmuel Hazan <shmuel.h@siklu.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     Marcin Wojtas <mw@semihalf.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        horatiu.vultur@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org
References: <20230419151457.22411-1-shmuel.h@siklu.com>
 <20230419151457.22411-4-shmuel.h@siklu.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230419151457.22411-4-shmuel.h@siklu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2023 17:14, Shmuel Hazan wrote:
> Add some documentation and example for enabling extts on the marvell
> mvpp2 TAI.
> 
> Signed-off-by: Shmuel Hazan <shmuel.h@siklu.com>
> ---


Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Best regards,
Krzysztof

