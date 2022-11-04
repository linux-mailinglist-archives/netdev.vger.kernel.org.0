Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675AF6196AA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 13:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKDM5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 08:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiKDM5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 08:57:20 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B5AB2E6BB
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:57:19 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id c15so2931963qtw.8
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 05:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A0qIuh5pcMXJdmuz1nC0ZXRTGE6QwNg6SLzVqinQUAU=;
        b=rMarUNEI9SNHqM/Raj6LT0ux2rPS6RMPaEAaLrNu4RgLxmpTF8rW1z2UwSW+TPx5PG
         jpY5GnRu6+EWr5o9/q+mrsgXWW7MyCE8gfNy7dZRfhkVE/vFI+tmmkSS+/8PAqA/0kU5
         w6JAejA1t8n+dIcaoOHlAHgWs+ZTKAodIFCwX0ENYJugmZeUG4/gPPiiWTRx348f/2Sw
         2WrU9Ut4T6DOsxmcHp8P4nZ8HzbTdNzLT2Uu4hj80M1qjTfSeiJuRBbsKlPndpNimg5y
         lWvl/zdksWKxWgW4Oz1/o8e9oA1aj3TDLG4rxxdO3OsiSNvsrANDNuBCaFuyyucg7o/8
         2xtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A0qIuh5pcMXJdmuz1nC0ZXRTGE6QwNg6SLzVqinQUAU=;
        b=RJL01WwZJc0iBBIdcNvgWgBVgSwT3TYlzYdFiX0SfPhxYA8+n28ib/gmePwFql9Er4
         3BNp+aJLKFqeDUXdazORMYOEWnNlBmkuGIU7ZFVfpeEgJwGuArOqdozJeat3Legy9m6I
         gKtPTqLzKHSmWFhdcFbZVBe1v5VrFX1Px3ut7pax2E+uoIOVCRkSxYCYkgc7pwdPhxqh
         0Nu5cUwNyXe1dV8g1++zq8dTE+ceXcNeA6hkrEtPgBGUHRYGYh1fBdzTJo6IErjLnsOH
         3q7frUrJtF6XIgc8y2qUhQ4BFeIQEmse4hssIgv+LvYT4U+ZFt4fw0hHwT4YOR2zwt+g
         CVyw==
X-Gm-Message-State: ACrzQf13KTNoxcOJuHw7s16KIqTLrDdNBUPLKrXL7CGMP4TPfyOmkiZE
        9ecIgTWy/Q3gzmyFeJp72jyifA==
X-Google-Smtp-Source: AMsMyM4TJoZbhcfSN3z+lJWHiQ/lHlKWeBmuMkIbyCGvSyAAFBmxolZjQaGby8V8Bi81RMETddaC4g==
X-Received: by 2002:a05:622a:19a2:b0:39c:ba6d:5d6d with SMTP id u34-20020a05622a19a200b0039cba6d5d6dmr28478486qtc.358.1667566638498;
        Fri, 04 Nov 2022 05:57:18 -0700 (PDT)
Received: from ?IPV6:2601:586:5000:570:aad6:acd8:4ed9:299b? ([2601:586:5000:570:aad6:acd8:4ed9:299b])
        by smtp.gmail.com with ESMTPSA id u23-20020ac87517000000b0039a372fbaa5sm2357409qtq.69.2022.11.04.05.57.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Nov 2022 05:57:17 -0700 (PDT)
Message-ID: <bf6bef84-8f67-4bde-e7d1-4f98e3a45455@linaro.org>
Date:   Fri, 4 Nov 2022 08:57:16 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add ICSSG Ethernet Driver
 bindings
Content-Language: en-US
To:     Md Danish Anwar <a0501179@ti.com>, linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski+dt@linaro.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, nm@ti.com, ssantosh@kernel.org,
        s-anna@ti.com, linux-arm-kernel@lists.infradead.org,
        rogerq@kernel.org, vigneshr@ti.com, kishon@ti.com,
        robh+dt@kernel.org, afd@ti.com, andrew@lunn.ch
References: <20220531095108.21757-1-p-mohan@ti.com>
 <20220531095108.21757-2-p-mohan@ti.com>
 <4ccba38a-ccde-83cd-195b-77db7a64477c@linaro.org>
 <41d5952b-51f8-bbc6-2e81-22d6f66320ee@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <41d5952b-51f8-bbc6-2e81-22d6f66320ee@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/11/2022 03:28, Md Danish Anwar wrote:
>>> * It includes indentation, formatting, and other minor changes.
>>> ---
>>>  .../bindings/net/ti,icssg-prueth.yaml         | 181 ++++++++++++++++++
>>>  1 file changed, 181 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>> new file mode 100644
>>> index 000000000000..40af968e9178
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/net/ti,icssg-prueth.yaml
>>> @@ -0,0 +1,181 @@
>>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>>> +%YAML 1.2
>>> +---
>>> +$id: http://devicetree.org/schemas/net/ti,icssg-prueth.yaml#
>>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>>> +
>>> +title: |+
>>
>> Missed Rob's comment.
>>
> 
> I'll remove this in the next version of this series.
> 
>>> +  Texas Instruments ICSSG PRUSS Ethernet
>>> +
>>> +maintainers:
>>> +  - Puranjay Mohan <p-mohan@ti.com>
>>> +
>>> +description:
>>> +  Ethernet based on the Programmable Real-Time
>>> +  Unit and Industrial Communication Subsystem.
>>> +
>>> +allOf:
>>> +  - $ref: /schemas/remoteproc/ti,pru-consumer.yaml#
>>> +
>>> +properties:
>>> +  compatible:
>>> +    enum:
>>> +      - ti,am654-icssg-prueth  # for AM65x SoC family
>>> +
>>> +  pinctrl-0:
>>> +    maxItems: 1
>>> +
>>> +  pinctrl-names:
>>> +    items:
>>> +      - const: default
>>
>> You do not need these usually, they are coming from schema.
>>
> Here from what I understand, I need to delete the below block, right?

Yes, entire pinctrl-0 and pinctr-names are not needed. You specify them
ony if they differ from usual.

Best regards,
Krzysztof

