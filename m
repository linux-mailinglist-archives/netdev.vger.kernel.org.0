Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76C676B019A
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 09:36:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230392AbjCHIgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 03:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjCHIfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 03:35:45 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A4541B54
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 00:34:45 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id j11so42986435edq.4
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 00:34:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678264478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VJrJNkTOc+mkotSTD6YyDbRROmB4n6O1HCCuVmryjIQ=;
        b=e8lY5MT3Ocre1fYL5y+xUAp28l2odmzzLy3cMcIyT5mboQmUWsaonS1YsVk3PqB8vi
         mt8ny4ldduvOYW8KkZTkoUvxFaMocal+g/o7IBzF5l9I8DwlNcZxc20E0d84QRkeE5EZ
         m6WBViqERZyaVsizfkbolcMsJRiNh9cHFgreVZrV7WMuo0v1u/6xnPv46SAjrQZKzV5q
         rvtBBFs5D93Q7St7qPikfLZgHzhoLVLytkndeSuaLX83iGNhyYkNb1fGoha/JBjYfFK3
         +QtwhYDPf9WfDP/7oSTXdYAXJeL5abhcO9101tv9llrucbCa80ly4/yf9O2MUBaivkh8
         DQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678264478;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJrJNkTOc+mkotSTD6YyDbRROmB4n6O1HCCuVmryjIQ=;
        b=E5sBYJFt/Z/lYvuiB/gn6llS4jtJ2LEdlUYGrmgFgxUNQQmj7F0a4ciybIByi1ZwN1
         MERrSUOMMARCJvSPA5ulTPze6/VTmHwbhIeriS4GPTLtmA7U7FdizHBcWN9pQ6qrpaiU
         SEUByERFwcK57PUcZhAT63qtRxeRrO/SbA2KLDBn3ElqR5STmGpzpntJ6a5aiuyK6LbV
         HFj4t27HxEwERJH95wl9prSYLMS4oUc80ma4PtQWIY8ZWMHBHRKwYdZiPsW4U0AhrUMj
         x74lH3LM7B39N3NOsPq7fxtjYuRk/p+FhjripwLF2NFy5XloxqbicgAqjRXAH+Os41I4
         srhg==
X-Gm-Message-State: AO0yUKXd6Mz4IcnJqdTSea1XGT1BXiG5GVaANpujKGQAyTfkzXVPSh2G
        FxilooPDElDoxTMFAIhrp4olhw==
X-Google-Smtp-Source: AK7set/eLi+dMlWxA1ga4i1GZ9tTXNLHEDrLYw+hmlbyUTYWR+HGHCzcb4kMHPNnTV1+HTS0kssySw==
X-Received: by 2002:a17:907:6d89:b0:8b1:3f5b:af5f with SMTP id sb9-20020a1709076d8900b008b13f5baf5fmr21837835ejc.73.1678264478232;
        Wed, 08 Mar 2023 00:34:38 -0800 (PST)
Received: from ?IPV6:2a02:810d:15c0:828:bba:fbfa:8aec:a133? ([2a02:810d:15c0:828:bba:fbfa:8aec:a133])
        by smtp.gmail.com with ESMTPSA id h24-20020a1709063b5800b008cda6560404sm7142659ejf.193.2023.03.08.00.34.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 00:34:37 -0800 (PST)
Message-ID: <1ffed720-322c-fa73-1160-5fd73ce3c7c2@linaro.org>
Date:   Wed, 8 Mar 2023 09:34:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2] dt-bindings: net: ti: k3-am654-cpsw-nuss:
 Document Serdes PHY
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, nsekhar@ti.com,
        rogerq@kernel.org
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        srk@ti.com
References: <20230308051835.276552-1-s-vadapalli@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230308051835.276552-1-s-vadapalli@ti.com>
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

On 08/03/2023 06:18, Siddharth Vadapalli wrote:
> Update bindings to include Serdes PHY as an optional PHY, in addition to
> the existing CPSW MAC's PHY. The CPSW MAC's PHY is required while the
> Serdes PHY is optional. The Serdes PHY handle has to be provided only
> when the Serdes is being configured in a Single-Link protocol. Using the
> name "serdes-phy" to represent the Serdes PHY handle, the am65-cpsw-nuss
> driver can obtain the Serdes PHY and request the Serdes to be
> configured.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
> 
> Hello,
> 
> This patch corresponds to the Serdes PHY bindings that were missed out in
> the series at:
> https://lore.kernel.org/r/20230104103432.1126403-1-s-vadapalli@ti.com/
> This was pointed out at:
> https://lore.kernel.org/r/CAMuHMdW5atq-FuLEL3htuE3t2uO86anLL3zeY7n1RqqMP_rH1g@mail.gmail.com/
> 
> Changes from v1:
> 1. Describe phys property with minItems, items and description.
> 2. Use minItems and items in phy-names.
> 3. Remove the description in phy-names.
> 
> v1:
> https://lore.kernel.org/r/20230306094750.159657-1-s-vadapalli@ti.com/
> 
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml        | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> index 900063411a20..0fb48bb6a041 100644
> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -126,8 +126,18 @@ properties:
>              description: CPSW port number
>  
>            phys:
> -            maxItems: 1
> -            description: phandle on phy-gmii-sel PHY
> +            minItems: 1
> +            items:
> +              - description: CPSW MAC's PHY.
> +              - description: Serdes PHY. Serdes PHY is required only if
> +                             the Serdes has to be configured in the
> +                             Single-Link configuration.
> +
> +          phy-names:
> +            minItems: 1
> +            items:
> +              - const: mac-phy
> +              - const: serdes-phy

Drop "phy" suffixes.

Best regards,
Krzysztof

