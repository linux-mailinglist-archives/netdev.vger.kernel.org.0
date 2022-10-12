Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6A35FC774
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 16:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbiJLOes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 10:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiJLOeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 10:34:46 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71FD0FADE
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:34:43 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id d13so4214641qko.5
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 07:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OMsZ+7M+Sgc7E+9hQ4WNx9YG06bm1iwnnpkAazR85FQ=;
        b=v+NlSdt1xz25Z4nh5paIkrUedP3AyaVTV5F6ByBfEKCbp5uDnrvLuQZTADrqMTFH+K
         ouXHzKcWPMhLSawAypW1+Si9D2IHWmm79RcK7w+e2WCcvYrmY2Wank2V9xT5QwYLNuCi
         UJrq5X2oq1EwOmFPEFOQgQpuNvhENP8V7laGYPp26huydnOjvTg1QGKo57j4dzfkZUq7
         5hdsfIUDrPJuzIGg+TwXGqJ76kCLaG0t8tKmt0rlMxoLzOpCorV3GzAnYzlloBHKR5bi
         /anuljnptXX786g8htuf7LyNLu3PnQO92CVhapnNS6rguqUFk5tcihj0Cu7/HwYGvZ52
         cDAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OMsZ+7M+Sgc7E+9hQ4WNx9YG06bm1iwnnpkAazR85FQ=;
        b=WgXjmb/aAxiYIPFp05gS0EdPUYoUPKFGfBMCDNrehZbIoIgO1p9ZoEk+G3GykeAwSx
         LNRvR+OVXaeQy6E5tEm5SREKeGSdYOXQGpJQHyBUWQmQcF6Nbem8DhLJysBktm6Jbtfy
         h4WjbBbd2A6Ky8ze1H/8Tw/1fYAjpE9BUNZ46CjAhRWLptU8mkMXrhisTPqZj19QkWSE
         xjhRLMvy75bKiWau3qx8YozBY25L34eVhyc9SfNvs5p80uru8D8tcXeUkN6sKT0R3krw
         Ig3sAhBflJxRDSjfg42m16QRFMF1K9OH2a2CesgTJijFgyRYkuoX2p6lDV7otX1JJPZu
         NTnw==
X-Gm-Message-State: ACrzQf0Af1yK+/woN9SYRudSlritTaXU8tDyjPjeJwca9kB3NG/QTrwW
        5BPqD5XTDO4iZBFnrcuEgAg/Vw==
X-Google-Smtp-Source: AMsMyM4qzU6utKFRylYq2Fgww+YpmjOTOpohktT/qqMwnS8qvd0pIyK0JpDzT1OKiy9dH2IYptnjgw==
X-Received: by 2002:a37:5a04:0:b0:6e0:a338:5f12 with SMTP id o4-20020a375a04000000b006e0a3385f12mr20382231qkb.420.1665585282401;
        Wed, 12 Oct 2022 07:34:42 -0700 (PDT)
Received: from [192.168.1.57] (cpe-72-225-192-120.nyc.res.rr.com. [72.225.192.120])
        by smtp.gmail.com with ESMTPSA id e124-20020a37b582000000b006ceb933a9fesm15796606qkf.81.2022.10.12.07.34.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 07:34:41 -0700 (PDT)
Message-ID: <881e19a9-2e16-7661-0efd-cae7ef1067e7@linaro.org>
Date:   Wed, 12 Oct 2022 10:34:40 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.2
Subject: Re: [PATCH v3 1/3] dt-bindings: net: marvell,pp2: convert to
 json-schema
Content-Language: en-US
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     =?UTF-8?Q?Micha=c5=82_Grzelak?= <mig@semihalf.com>,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, upstream@semihalf.com
References: <20221011190613.13008-1-mig@semihalf.com>
 <20221011190613.13008-2-mig@semihalf.com>
 <ad015bc9-a6d2-491d-463a-42a6a0afbf75@linaro.org>
 <CAPv3WKcY=erFTBDLP1AhQa0+CP6C8KJinmKFEkR2xh4mHHv_aQ@mail.gmail.com>
 <CAPv3WKdon28ntGQ=xbmL+CEFQ7=xzOQOcV9qN_8MOt-uiLHoXg@mail.gmail.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CAPv3WKdon28ntGQ=xbmL+CEFQ7=xzOQOcV9qN_8MOt-uiLHoXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/10/2022 19:01, Marcin Wojtas wrote:
,
>>
>> ethernet@
>> {
>>     ethernet-port@0
>>     {
>>      }
>>      ethernet-port@1
>>      {
>>      }
>> }
>>
>> What do you recommend?
>>
> 
> I moved the ethernet-controller.yaml reference to under the subnode
> (this allowed me to remove phy and phy-mode description)) and it
> doesn't complain about the node naming. Please let me know if below
> would be acceptable.
> 
> --- a/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> +++ b/Documentation/devicetree/bindings/net/marvell,pp2.yaml
> @@ -61,7 +61,11 @@ patternProperties:
>      type: object
>      description: subnode for each ethernet port.
> 
> +    allOf:

Skip the allOf, just $ref is enough.

> +      - $ref: ethernet-controller.yaml#
> +
>      properties:
>        interrupts:
>          minItems: 1
>          maxItems: 10
> @@ -95,19 +99,11 @@ patternProperties:
> 
>        port-id:
>          $ref: /schemas/types.yaml#/definitions/uint32
> +        deprecated: true
>          description: >
>            ID of the port from the MAC point of view.
>            Legacy binding for backward compatibility.
> 
> -      phy:
> -        $ref: /schemas/types.yaml#/definitions/phandle
> -        description: >
> -          a phandle to a phy node defining the PHY address
> -          (as the reg property, a single integer).
> -
> -      phy-mode:
> -        $ref: ethernet-controller.yaml#/properties/phy-mode
> -
>        marvell,loopback:
>          $ref: /schemas/types.yaml#/definitions/flag
>          description: port is loopback mode.
> @@ -132,7 +128,6 @@ required:
>    - clock-names
> 
>  allOf:
> -  - $ref: ethernet-controller.yaml#
>    - if:
> 

Yes, except:

1. top-level (so with no indentation) unevaluatedProperties: false
should be now additionalProperties: false.
2. You need unevaluatedProperties here:

+    type: object
+    description: subnode for each ethernet port.
+    $ref: ethernet-controller.yaml#
+    unevaluatedProperties: false

Best regards,
Krzysztof

