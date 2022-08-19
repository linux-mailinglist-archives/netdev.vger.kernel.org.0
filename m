Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7657599873
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 11:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348033AbiHSJOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 05:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348008AbiHSJOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 05:14:08 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37F393D59A
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:14:06 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id q18so2955511ljg.12
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=uuqghSHzNJr5H0vLiTIAXQb7NYP5yoc/bBfCNzDWdy4=;
        b=l7cgJkJddLqTU0nf/69vRzamhM9l1ip2Xstft4D11LGWH1dpvWj14jzRf2oeNn62hH
         XY/OI8AvAiKXRSqwT3Thr9/i8+CUxnG8RAPpumFO31V+Gl7Wkln/eBxJAASBTzaFpU44
         VJimfC7jaaI1UQh13qEwJmgT2KEE8moI/PkeMF86v6/4F+v0DmaZZjuqmFaCCDcvNI5U
         TOa7xVaHe/9r7WwDKWK3CtUsv3Moh7FVzSt6EEUQHlquYvpHAJffNusiHzqbPk0qgO1+
         NRY6NQyVauCtloxOub3uIQ4zlaR6ojgUO54ibHERDO+tTuamJ+6jDh9/xjUCF1GOKoxN
         Bbmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=uuqghSHzNJr5H0vLiTIAXQb7NYP5yoc/bBfCNzDWdy4=;
        b=UU8nYJwb57SxlajCKs1MmkfhydctQ6K8L7hl04tVaXD8F/8e+SkrA9CPU2D1fI/ILI
         PctSSAs6twt4NcaN963P/dChwf4HC0p0G74XNNm7Qo2NKh90DtOqfN1x8re/wnHdxDVG
         Cg+V0RTg4hr14UmcoeEjHXj6weqnw/QLbOfKfYO5vc5YWO2MUr6nS+x/7F8uZAEwQ/yT
         ugvs70Llzzy/T+p0aRSgOWDxGVQiQmShnSt/jsF77By8gmzCbH/m5jh9X/S5iZ4NLCit
         FG4n9WMkA8D1mhwuDwyeQrrPmWsoxRvPDQUOxOyHqvpEE8X0ZC7L4AmF1xxYfdcQeeRf
         1nGA==
X-Gm-Message-State: ACgBeo2HDk7Ak1pbN2mHRf5/CFtewzQkiVn/FZeVeodCCa290Zrfshzu
        XmTbhdm5avriaGtMmk2/Y+ADzA==
X-Google-Smtp-Source: AA6agR4hGCrfJ0FHTxXTCRDG3phtiDLv2uxyWd/UpXV2iEzQ5bMT16E59/9y8ArI9q3JbB7Owyfq+g==
X-Received: by 2002:a2e:7e0a:0:b0:25e:63f2:bbb0 with SMTP id z10-20020a2e7e0a000000b0025e63f2bbb0mr2092765ljc.77.1660900444242;
        Fri, 19 Aug 2022 02:14:04 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5? (d1xw6v77xrs23np8r6z-4.rev.dnainternet.fi. [2001:14bb:ac:e5a8:ef73:73ed:75b3:8ed5])
        by smtp.gmail.com with ESMTPSA id m4-20020a056512114400b0048b969ac5cdsm568712lfg.5.2022.08.19.02.14.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Aug 2022 02:14:03 -0700 (PDT)
Message-ID: <f0f6e8af-4006-e0e8-544b-f2f892d79a1f@linaro.org>
Date:   Fri, 19 Aug 2022 12:14:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: tja11xx: add nxp,refclk_in
 property
Content-Language: en-US
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220819074729.1496088-1-wei.fang@nxp.com>
 <20220819074729.1496088-2-wei.fang@nxp.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220819074729.1496088-2-wei.fang@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/08/2022 10:47, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> TJA110x REF_CLK can be configured as interface reference clock
> intput or output when the RMII mode enabled. This patch add the
> property to make the REF_CLK can be configurable.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---
>  .../devicetree/bindings/net/nxp,tja11xx.yaml    | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> index d51da24f3505..c51ee52033e8 100644
> --- a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> @@ -31,6 +31,22 @@ patternProperties:
>          description:
>            The ID number for the child PHY. Should be +1 of parent PHY.
>  
> +      nxp,rmii_refclk_in:

No underscores in properties.

> +        type: boolean
> +        description: |
> +          The REF_CLK is provided for both transmitted and receivced data

typo: received

> +          in RMII mode. This clock signal is provided by the PHY and is
> +          typically derived from an external 25MHz crystal. Alternatively,
> +          a 50MHz clock signal generated by an external oscillator can be
> +          connected to pin REF_CLK. A third option is to connect a 25MHz
> +          clock to pin CLK_IN_OUT. So, the REF_CLK should be configured
> +          as input or output according to the actual circuit connection.
> +          If present, indicates that the REF_CLK will be configured as
> +          interface reference clock input when RMII mode enabled.
> +          If not present, the REF_CLK will be configured as interface
> +          reference clock output when RMII mode enabled.
> +          Only supported on TJA1100 and TJA1101.

Then disallow it on other variants.

Shouldn't this be just "clocks" property?


Best regards,
Krzysztof
