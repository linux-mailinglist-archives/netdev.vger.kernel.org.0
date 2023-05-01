Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5672A6F2F09
	for <lists+netdev@lfdr.de>; Mon,  1 May 2023 09:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbjEAHQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 03:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231166AbjEAHQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 03:16:09 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99401E69
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 00:16:07 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5050497df77so3387102a12.1
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 00:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682925366; x=1685517366;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vGjckqNc9oAKUpdapLyExDXzKNBU6vQzE5IdanHWvf8=;
        b=GwphBorOFjC3rUTNp6gNHqjnsnneV2ooi20V1lKYA8VKatsTL/LaeRZViMVSEcphMj
         jEBk6tkzwn+tChW6uSUIXoIdCxlvNKR4/zlyFJ3DHmagiiNs+BDyTEV3uO94AM7qtLpb
         +7TQf0BPzTU89NcKxwwRgiqpoqBTESG1fWhCW+etPC1PlQny+IPRsX6zaxRVczXWZ1TC
         dtzEJgIz06XXmMWtYYTRPQPOJUvdXd+YW88TsMGdjjK43Zj9x2mKRCalUxFuiSpSisdb
         X5fF43GmvlEF20xLMl817FIX50b61X7Py0ahikKz9PMBUF9CFW4ypT51C1igHvDrbiJe
         8I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682925366; x=1685517366;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vGjckqNc9oAKUpdapLyExDXzKNBU6vQzE5IdanHWvf8=;
        b=LXKQEBXTFaN+xRZh2lG++qmDMr6S6wy2Tch13abNoHR7wwXU99GBAkYeR46Wi6JjLT
         B9PcEPLj+okjyzuF250d9iXgMTzZZpHtqPQ9uAJdLEdh17bZfaSVEmifvbaXPmYmCiWc
         89lKDSRvl4qbH75KeC4H5XsICrj3gvJJ5Y/AkchvhuXcOV0hyB3IwmyYiOgZVcqClKpw
         8QFxda2iyOpzOGHHWWm5YVZcQAG1YAhdmCRrKAkM1q90VA12Obfcv5o4sigkhf/kw483
         2GAa1EP0ZU3Uvo/21jE4Q8K9/ieETes3dX4nprLJIy6BNYSb7si7lCmWCBuzOo8z3hSr
         M/+w==
X-Gm-Message-State: AC+VfDzmzTwkNYuzONxz5PxA75l+6Fv9v2qigRV9XDxbk97VmuHaPllt
        eC4kj3OwCNROB7cJNr/QlvvxPA==
X-Google-Smtp-Source: ACHHUZ5A4mlItIKcf+06jLmM8x2PTSTW1S18bGkEXUc2vi2ndXcicN+pXi+z+l3LvY1iN87AvbPykA==
X-Received: by 2002:a05:6402:1214:b0:507:5e52:cdb0 with SMTP id c20-20020a056402121400b005075e52cdb0mr4615980edw.9.1682925366073;
        Mon, 01 May 2023 00:16:06 -0700 (PDT)
Received: from ?IPV6:2a02:810d:15c0:828:637a:fd0c:58fd:9f00? ([2a02:810d:15c0:828:637a:fd0c:58fd:9f00])
        by smtp.gmail.com with ESMTPSA id la5-20020a170906ad8500b0094e877ec197sm14722310ejb.148.2023.05.01.00.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 May 2023 00:16:05 -0700 (PDT)
Message-ID: <62a0c7f6-be34-903a-14ba-21324292c5ec@linaro.org>
Date:   Mon, 1 May 2023 09:16:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH v2 2/4] dt-bindings: net: can: Add poll-interval for MCAN
Content-Language: en-US
To:     "Mendez, Judith" <jm@ti.com>, Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Nishanth Menon <nm@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        devicetree@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Tero Kristo <kristo@kernel.org>,
        Schuyler Patton <spatton@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Vignesh Raghavendra <vigneshr@ti.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230424195402.516-1-jm@ti.com> <20230424195402.516-3-jm@ti.com>
 <168238155801.4123790.14706903991436332296.robh@kernel.org>
 <4ca0c282-35ea-c8c3-06f4-59d0de3b18f5@ti.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <4ca0c282-35ea-c8c3-06f4-59d0de3b18f5@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/04/2023 18:17, Mendez, Judith wrote:
> Hello Rob,
> 
> On 4/24/2023 7:13 PM, Rob Herring wrote:
>>
>> On Mon, 24 Apr 2023 14:54:00 -0500, Judith Mendez wrote:
>>> On AM62x SoC, MCANs on MCU domain do not have hardware interrupt
>>> routed to A53 Linux, instead they will use software interrupt by
>>> hrtimer. To enable timer method, interrupts should be optional so
>>> remove interrupts property from required section and introduce
>>> poll-interval property.
>>>
>>> Signed-off-by: Judith Mendez <jm@ti.com>
>>> ---
>>> Changelog:
>>> v2:
>>>    1. Add poll-interval property to enable timer polling method
>>>    2. Add example using poll-interval property
>>>
>>>   .../bindings/net/can/bosch,m_can.yaml         | 26 ++++++++++++++++---
>>>   1 file changed, 23 insertions(+), 3 deletions(-)
>>>
>>
>> My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
>> on your patch (DT_CHECKER_FLAGS is new in v5.13):
>>
>> yamllint warnings/errors:
>>
>> dtschema/dtc warnings/errors:
>> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with interrupts' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
>> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
>> /builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/net/can/bosch,m_can.yaml: 'example with timer polling' is not one of ['$id', '$schema', 'title', 'description', 'examples', 'required', 'allOf', 'anyOf', 'oneOf', 'definitions', '$defs', 'additionalProperties', 'dependencies', 'dependentRequired', 'dependentSchemas', 'patternProperties', 'properties', 'not', 'if', 'then', 'else', 'unevaluatedProperties', 'deprecated', 'maintainers', 'select', '$ref']
>> 	from schema $id: http://devicetree.org/meta-schemas/base.yaml#
>>
>> doc reference errors (make refcheckdocs):
>>
>> See https://patchwork.ozlabs.org/project/devicetree-bindings/patch/20230424195402.516-3-jm@ti.com
>>
>> The base for the series is generally the latest rc1. A different dependency
>> should be noted in *this* patch.
>>
>> If you already ran 'make dt_binding_check' and didn't see the above
>> error(s), then make sure 'yamllint' is installed and dt-schema is up to
>> date:
>>
>> pip3 install dtschema --upgrade
>>
>> Please check and re-submit after running the above command yourself. Note
>> that DT_SCHEMA_FILES can be set to your schema file to speed up checking
>> your schema. However, it must be unset to test all examples with your schema.
> 
> Thanks Rob, I was not getting the errors, but I have fixed now. Thanks.

There is no way your code have worked, so either you did not test it or
your setup misses something. In both cases you would see errors, so
please check what went wrong.

Best regards,
Krzysztof

