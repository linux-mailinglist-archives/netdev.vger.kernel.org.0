Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7285B68D120
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 08:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbjBGH7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 02:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbjBGH7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 02:59:13 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DAF298CB
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 23:59:12 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id bg5-20020a05600c3c8500b003e00c739ce4so2091729wmb.5
        for <netdev@vger.kernel.org>; Mon, 06 Feb 2023 23:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o7VB0jzwnOxKfmTOOzDR17bwgY03oYhE2KBFynIQKYk=;
        b=jAx6zmTdhp+G9FV94pkDTLjS8skfz6TZbOO0uBKFi+LDNSNV8QtcIY+RtU83JITlZT
         vcpbwxilx8Ir4QSMnsWmyKjFTIAgewWI2Ad/rWk4jESbPk6xKQKo6c7OtBNSJmfSsGAZ
         v2JvS/tM1IouLaI0ZaXwAFIbIkK3Ul6zwLJiIiFrbeIJ/SKwbV0E2u//69bmC+O6vflC
         fk4g96py9Fs7kRxnoozdgQCJgg1X1ALSurzAEzHbVgsy/WrxtbrO2YOdSoRhVjVR9Dqi
         1MioNeydHl0K90eHgsYjp1gbMO7PDE2wfGWMiEUFjgjUz3/+Cqy6p9J7/HdaUfyVo0Jc
         e6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o7VB0jzwnOxKfmTOOzDR17bwgY03oYhE2KBFynIQKYk=;
        b=vu7d4Pd/OtvgmWi5UddcKLbSqsUa3mClXnpteYyYN/ybiBWf2bG5jNY0K+rSOgRy5/
         s5HfT36OQ9n3uq53SNoMmb18SEINziUM9GfQTcY0da4nRQ53FRU2PGlqvZJhvwA/a90W
         vCPN3YbsUfo5AuNCJjE34Y59PvqYTm8Tqsp3e1qGc15iOj/kuUZtWInS51b2BO0adZ4V
         3z3Ox4Nad8bHmcPwARatZ29SkIwCmtBpNZbzuNOJ2sJy+JFVSuaSihWf9uXrfzeDuaMs
         ghUnjWsH1nqjreFEeI9vq5XkCuDHRp+3bUv/rZwcizWtyGJ6UTwqt1eoT6D4WD2s9q7Q
         82rQ==
X-Gm-Message-State: AO0yUKXiTPGXtGhBuEDgbAoh189mgndoWBpkzyvcF+un2lJI4ZfxpPLY
        Dq6lJ4QNwwhlMAYh8r9sBRLBuQ==
X-Google-Smtp-Source: AK7set+izeJf1L9+viuy6hL3eXG0OPxOYCFMp/qcAnZZhl4TTkIhcl0lIgta0AjT+ch0CYmfrPlIhA==
X-Received: by 2002:a05:600c:4a9a:b0:3dc:5b48:ee5 with SMTP id b26-20020a05600c4a9a00b003dc5b480ee5mr2266222wmp.2.1675756751053;
        Mon, 06 Feb 2023 23:59:11 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id o37-20020a05600c512500b003c6bbe910fdsm19929143wms.9.2023.02.06.23.59.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 23:59:10 -0800 (PST)
Message-ID: <aa85caa3-6051-46ab-d927-8c552d5a718d@linaro.org>
Date:   Tue, 7 Feb 2023 08:59:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 2/7] dt-bindings: net: snps,dwmac: Update the maxitems
 number of resets and reset-names
To:     yanhong wang <yanhong.wang@starfivetech.com>,
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
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com>
 <20230118061701.30047-3-yanhong.wang@starfivetech.com>
 <15a87640-d8c7-d7aa-bdfb-608fa2e497cb@linaro.org>
 <c9ab22b5-3ffb-d034-b8b8-b056b82a96ce@starfivetech.com>
Content-Language: en-US
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <c9ab22b5-3ffb-d034-b8b8-b056b82a96ce@starfivetech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/02/2023 03:43, yanhong wang wrote:
> 
> 
> On 2023/1/18 23:47, Krzysztof Kozlowski wrote:
>> On 18/01/2023 07:16, Yanhong Wang wrote:
>>> Some boards(such as StarFive VisionFive v2) require more than one value
>>> which defined by resets property, so the original definition can not
>>> meet the requirements. In order to adapt to different requirements,
>>> adjust the maxitems number definition.
>>>
>>> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
>>> ---
>>>  Documentation/devicetree/bindings/net/snps,dwmac.yaml | 9 +++------
>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> index e26c3e76ebb7..baf2c5b9e92d 100644
>>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>>> @@ -133,12 +133,9 @@ properties:
>>>          - ptp_ref
>>>  
>>>    resets:
>>> -    maxItems: 1
>>
>> Also, this does not make sense on its own and messes constraints for all
>> other users. So another no for entire patch.
>>
> 
> Thanks. Change the properties of 'resets' and reset-names like this:
> 
>   resets:
>     minItems: 1
>     maxItems: 2
> 
>   reset-names:
>     minItems: 1
>     maxItems: 2
> 
> Is it right?  Do you have any other better suggestions?

Isn't this allowing two reset items for every variant of snps,dwmac?

Best regards,
Krzysztof

