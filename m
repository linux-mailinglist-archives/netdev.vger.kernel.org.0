Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09D5F6B5D6F
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 16:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCKPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 10:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjCKPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 10:46:57 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6C3C97C5
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 07:46:55 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id k10so32290885edk.13
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 07:46:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678549614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4dVATx5c6hr9pOV2Vp8/XmqV67vmEqF0l4KPE/5Ob10=;
        b=QGGSkY6z5rMmcEhoqYQjhiYLqmOfGmeHv+u/dyEAay2rvEM6YppXPFcxX1r0ENrjda
         asrvTU37m3LS+XLxQwLX4Jqid0KARnrHGbahPWTd0mepDfbAcaq4D0BU2VeGS3m/E2BS
         1xM5v6lK2Zy+5sJo9lb6e9tvQCxAk1BHCDr6O5lzuzp4hIXtfVg2/kJlozXsCaYoGvnJ
         Jho+wtHt5iTLwlEWZEpLmc5SFY95ZPfQKqVriyUUYjmBtRyULJsuxTokGWxSeCHtBUbA
         aAucXqsTbi5zmTfCOOJaSwrxQm92FMCSKHMUBpOgqteqt3yBClunNvEtFCACvT9fJurT
         wVXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678549614;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dVATx5c6hr9pOV2Vp8/XmqV67vmEqF0l4KPE/5Ob10=;
        b=zpr+d0dUHtOHN+CiEOhqfLsmAoM/+fHEqeabiUAsWULlZL4NKZoEFNvuq5WHjnG2NU
         KftltV1KwVevRHS+Km9uQowMb7NSTuyY/XUSZK8p32rfiv4Et7G3LqKM9uDw26uMfXdF
         +ua/aiQTLk1FaHLHsvqnVh5t0kbQ+JGn+Xp7zXWQcuFWb5hsFjae5PlagOvwRZdgyj+S
         BrogoB6g5bJEh0cYvWK6aQdTenUwk7nNV0xSLrJ0xDL4glTq/UUA93gRglEzQ/0GjjEM
         AYyCYP0U6+MQ+zZooF3hMXeclYp/g3iSPzD2mwdesJrG52XbCV0rYOxEacmFiQvHY4oQ
         8kcg==
X-Gm-Message-State: AO0yUKUzXGj50Rw56e+fG7ouIhPnpW4a7nk630F1041qrv1BKjJBkacp
        wAcTl9OzyUdLWYaUTH+gfBkcHg==
X-Google-Smtp-Source: AK7set8MNJoq43tQWh5HLqQTE5+KCYEEaH0KtBtq3eP0g+QDew0cU9sHyxx5V05LiXYaUdXaN5O6ng==
X-Received: by 2002:a17:907:2ce1:b0:8b1:32dd:3af with SMTP id hz1-20020a1709072ce100b008b132dd03afmr39043153ejc.28.1678549613855;
        Sat, 11 Mar 2023 07:46:53 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:6927:e94d:fc63:9d6e? ([2a02:810d:15c0:828:6927:e94d:fc63:9d6e])
        by smtp.gmail.com with ESMTPSA id q16-20020a50aa90000000b004bd6e3ed196sm1310704edc.86.2023.03.11.07.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 07:46:53 -0800 (PST)
Message-ID: <71c7feff-4189-f12f-7353-bce41a61119d@linaro.org>
Date:   Sat, 11 Mar 2023 16:46:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 2/2] dt-bindings: pinctrl: Move k3.h to arch
Content-Language: en-US
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
 <20230311131325.9750-3-nm@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230311131325.9750-3-nm@ti.com>
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
> Move the k3 pinctrl definition to arch dts folder.
> 
> While at this, fixup MAINTAINERS and header guard macro to better
> reflect the changes.
> 
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Suggested-by: Linus Walleij <linus.walleij@linaro.org>
> Link: https://lore.kernel.org/all/c4d53e9c-dac0-8ccc-dc86-faada324beba@linaro.org/
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> 
> There is no specific case I can think of at the moment to create a
> pinctrl.dtsi for the SoCs.. So, unlike other SoCs, I had not done that
> in the series, if folks have a better opinion about this, please let us
> discuss.
> 
>  MAINTAINERS                                                 | 1 -
>  arch/arm64/boot/dts/ti/k3-am62.dtsi                         | 3 ++-
>  arch/arm64/boot/dts/ti/k3-am62a.dtsi                        | 3 ++-
>  arch/arm64/boot/dts/ti/k3-am64.dtsi                         | 3 ++-
>  arch/arm64/boot/dts/ti/k3-am65.dtsi                         | 3 ++-
>  arch/arm64/boot/dts/ti/k3-j7200.dtsi                        | 3 ++-
>  arch/arm64/boot/dts/ti/k3-j721e.dtsi                        | 3 ++-
>  arch/arm64/boot/dts/ti/k3-j721s2.dtsi                       | 3 ++-
>  arch/arm64/boot/dts/ti/k3-j784s4.dtsi                       | 3 ++-
>  .../pinctrl/k3.h => arch/arm64/boot/dts/ti/k3-pinctrl.h     | 6 +++---

Bindings are separate from other changes (also DTS). Split the patches.

(...)

>  / {
>  	model = "Texas Instruments K3 J784S4 SoC";
>  	compatible = "ti,j784s4";
> diff --git a/include/dt-bindings/pinctrl/k3.h b/arch/arm64/boot/dts/ti/k3-pinctrl.h
> similarity index 94%
> rename from include/dt-bindings/pinctrl/k3.h
> rename to arch/arm64/boot/dts/ti/k3-pinctrl.h
> index 469bd29651db..6004e0967ec5 100644
> --- a/include/dt-bindings/pinctrl/k3.h
> +++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h

Dropping this file is going to break existing code and I would say is
also a break of the ABI. You need to keep the header for at least one
cycle, you can add there a warning for coming deprecation.

See for example:
https://lore.kernel.org/all/20220605160508.134075-5-krzysztof.kozlowski@linaro.org/

Best regards,
Krzysztof

