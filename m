Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E676EA4CE
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 09:31:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbjDUHbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 03:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbjDUHbC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 03:31:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328B29746
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:30:52 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-9505214c47fso207439266b.1
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 00:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682062251; x=1684654251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TXD0SvfVpb5ArVlwxwukJNvZ7FQ4i6U8HJTH0x40wOc=;
        b=jHa4yP8uRXfKtQYslv7gA8gGzGt6bHpcNBBVQkD9GcwARGlxayyqhdRiIBBQY9H1Bb
         SyZU4yixxQM+XsojFJjtucU3i3wen2yRTp6zX48UroM+P9SpyNM7Goe7igAPHzmRXAec
         5oYIBMyA43zod8w/yMsgwjaU3x/F93FJSjXiodloLojrzOAMmINH5JkXL5uSsn1Tkikb
         tBe3WAOiF+rJFvyDRe/d0fYqAQNwa+8nDuoAGBeogng7SGfB6kMOa6BEvIAEsfJAdpmt
         t5pAhDO4F5E3UKc4ZJ+0e/BrjMttO6ouKWwQ0fMnyy5VbXMympEy2ttY8yJgRLOJO18k
         0V0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682062251; x=1684654251;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TXD0SvfVpb5ArVlwxwukJNvZ7FQ4i6U8HJTH0x40wOc=;
        b=Ey6gUy8BTTgUfgpDSBxW5CQe0lyp0u0IFMr/aDUAYJshcsmPcFhrFfDLYVSYPTKqTt
         Tz4NL2Xj1EFe13fuT5lNKHhTwWcKribVuo1uM8Uu2xubCTzcbXS6VHC3NQngPT8k94uS
         vER0Y1sru7sG4F5r4ShpBIMBeYZnPuSYgfHixit2fSSJ2Q7LtqbgJeEYEIIms/BYo5Sm
         jZbw8RNwGBP8LXzFwmTvkmXgI1PBvYcVGb+1sqPvrpzHZShVLjA9+3P3kmORbDVByE1w
         R2l4nHgiIGtK4/XpyK1Nu29fy+Bej3SwQ40dvBgtsdZJAN7q03fZAW3uAlzyAlgo71tO
         QNqw==
X-Gm-Message-State: AAQBX9dQVViMnKaCIkH1eFZgrCMy0XMOxAttjCADv6eFU/V2Pan1NhtM
        ptR7QdzuM2EcHxabtE0F8eqMzw==
X-Google-Smtp-Source: AKy350YiW/RgBcdrDWvcsi4/QmLqcZmY+jKO98eibRooGmPHFN7cNE5Nwwltck2kC0aIMnW0VwZMow==
X-Received: by 2002:a17:907:7851:b0:94f:3b29:e0a5 with SMTP id lb17-20020a170907785100b0094f3b29e0a5mr1216357ejc.20.1682062251073;
        Fri, 21 Apr 2023 00:30:51 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:668b:1e57:3caa:4d06? ([2a02:810d:15c0:828:668b:1e57:3caa:4d06])
        by smtp.gmail.com with ESMTPSA id w27-20020a17090633db00b0094ed0370f8fsm1734575eja.147.2023.04.21.00.30.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 00:30:50 -0700 (PDT)
Message-ID: <3adc1c05-b707-6caf-874e-dfef065c8ab8@linaro.org>
Date:   Fri, 21 Apr 2023 09:30:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 2/6] dt-bindings: net: brcm,unimac-mdio: Add
 asp-v2.0
Content-Language: en-US
To:     Justin Chen <justinpopo6@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
 <1681863018-28006-3-git-send-email-justinpopo6@gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <1681863018-28006-3-git-send-email-justinpopo6@gmail.com>
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

On 19/04/2023 02:10, Justin Chen wrote:
> From: Justin Chen <justin.chen@broadcom.com>
> 
> The ASP 2.0 Ethernet controller uses a brcm unimac.
> 
> Signed-off-by: Justin Chen <justinpopo6@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> index 0be426ee1e44..6684810fcbf0 100644
> --- a/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> +++ b/Documentation/devicetree/bindings/net/brcm,unimac-mdio.yaml
> @@ -22,6 +22,8 @@ properties:
>        - brcm,genet-mdio-v3
>        - brcm,genet-mdio-v4
>        - brcm,genet-mdio-v5
> +      - brcm,asp-v2.0-mdio
> +      - brcm,asp-v2.1-mdio

Same concerns as on previous patch.

Best regards,
Krzysztof

