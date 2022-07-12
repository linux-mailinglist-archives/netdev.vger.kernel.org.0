Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D20CF571EDC
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233773AbiGLPVa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233183AbiGLPVI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 11:21:08 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A318B57231
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 08:18:14 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id p6so7449597ljc.8
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 08:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Tj5Gg27gp6guU9o9CDqxeuyaEnEIyrvYSMIuKpk5DD8=;
        b=tGqKNetCeWXzqGSSNavFzF6GgOnaP8uE2YFx+VXS9WdGV5+5ap7lYe4ilTL/1ca+f+
         ouoKcLg2D+XuplmIZ64Lz27n+Eh3j2Ya6E+NSRFRl3bnp1leC9bzqMmv7HUj60q49LET
         rIvE/HVfZH7a4dyRgaENaiFzB5AsCD1r63XXMdITydVZRxTVBgbNgWAB2rO9AxLLVuaC
         AzOFcDK+tXjAOimM2VbjoHL+V5TK3gLBOqx+O79eaba0f8hHPr9JyQA8CWPolOaN8rpT
         6B9s+95UGjNRSOzF5Y3dhERiewU2/lC5qnFS8oZu/sLrVVw+82sAAOSBpGrbvWYEnvPL
         5OrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Tj5Gg27gp6guU9o9CDqxeuyaEnEIyrvYSMIuKpk5DD8=;
        b=C3j0A8qFVkRjnmR2fYqF4l8y35K2R4h6loi5qgjXFrLYOAFfuC485K69mEXEJ0SFHt
         irk84RdY0yFEhVISl2jyHKSv8uLvuIjxbsZIlYedK9n81mzHZYeRrXv5cm1U3bs4wBBx
         l2GLJZ/e9fvv823Zesd327VLGEbR3RZJJpI3kmXUoL79PEC8Z8DfdnxQx+q843SZtIs9
         ql1y+yryeIihhvajGqFdS9ogBVHwWjTRIYmp2SIdiH+dRRaUry+OLTMk4o204ExAw6LX
         FKLO1XRcPYIpZ8UjE8IPy9ZaL1h/gDP/GdlgZB4JXfZzaXpy6tswvzy9Q7yYFa/ZBLrJ
         Bihg==
X-Gm-Message-State: AJIora+4AUEu027DTTFk9mpoIhzctrcPtV12ay3c5w5I5i3usE65dwtI
        i9ej00MEZDLqZf54M9uaYKzsdw==
X-Google-Smtp-Source: AGRyM1s3SKYPr8wCbAab/dh6Yo/xp76xDbLfy2u6JUJeWpoicCcLEvo3aAi857vpfyk8jA3cDKyCLA==
X-Received: by 2002:a2e:9547:0:b0:24f:2e31:6078 with SMTP id t7-20020a2e9547000000b0024f2e316078mr12469910ljh.102.1657639093026;
        Tue, 12 Jul 2022 08:18:13 -0700 (PDT)
Received: from [10.0.0.8] (fwa5da9-171.bb.online.no. [88.93.169.171])
        by smtp.gmail.com with ESMTPSA id o28-20020a198c1c000000b00482bb812713sm2232708lfd.94.2022.07.12.08.18.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jul 2022 08:18:12 -0700 (PDT)
Message-ID: <d84899e7-06f7-1a20-964f-90b6f0ff96fd@linaro.org>
Date:   Tue, 12 Jul 2022 17:18:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [RFC PATCH net-next 2/9] dt-bindings: net: Expand pcs-handle to
 an array
Content-Language: en-US
To:     Sean Anderson <sean.anderson@seco.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
References: <20220711160519.741990-1-sean.anderson@seco.com>
 <20220711160519.741990-3-sean.anderson@seco.com>
 <ecaf9d0f-6ddb-5842-790e-3d5ee80e2a77@linaro.org>
 <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <fdd34075-4e5e-a617-696d-15c5ac6e9bfe@seco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/07/2022 17:06, Sean Anderson wrote:
> Hi Krzysztof,
> 
> On 7/12/22 4:51 AM, Krzysztof Kozlowski wrote:
>> On 11/07/2022 18:05, Sean Anderson wrote:
>>> This allows multiple phandles to be specified for pcs-handle, such as
>>> when multiple PCSs are present for a single MAC. To differentiate
>>> between them, also add a pcs-names property.
>>>
>>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>>> ---
>>>
>>>  .../devicetree/bindings/net/ethernet-controller.yaml       | 7 ++++++-
>>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>> index 4f15463611f8..c033e536f869 100644
>>> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
>>> @@ -107,11 +107,16 @@ properties:
>>>      $ref: "#/properties/phy-connection-type"
>>>  
>>>    pcs-handle:
>>> -    $ref: /schemas/types.yaml#/definitions/phandle
>>> +    $ref: /schemas/types.yaml#/definitions/phandle-array
>>>      description:
>>>        Specifies a reference to a node representing a PCS PHY device on a MDIO
>>>        bus to link with an external PHY (phy-handle) if exists.
>>
>> You need to update all existing bindings and add maxItems:1.
>>
>>>  
>>> +  pcs-names:
>>
>> To be consistent with other properties this should be "pcs-handle-names"
>> and the other "pcs-handles"... and then actually drop the "handle".
> 
> Sorry, I'm not sure what you're recommending in the second half here.

I would be happy to see consistent naming with other xxxs/xxx-names
properties, therefore I recommend to:
1. deprecate pcs-handle because anyway the naming is encoding DT spec
into the name ("handle"),
2. add new property 'pcs' or 'pcss' (the 's' at the end like clocks but
maybe that's too much) with pcs-names.

However before implementing this, please wait for more feedback. Maybe
Rob or net folks will have different opinions.

Best regards,
Krzysztof
