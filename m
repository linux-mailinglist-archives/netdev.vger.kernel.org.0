Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA1F59810C
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 11:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbiHRJqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 05:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243526AbiHRJqi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 05:46:38 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93DA0B08AB
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:46:37 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id a9so1411867lfm.12
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 02:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=MFmEDhXxgZF7KULdzona+7TtwCBEXCBX6WNuKW7to/k=;
        b=o/H8DL4GCtp0fpBXwBnHt5oN/hZyiyzj799GcdO01ig5EyiRWN0swEVeq6HE/3v0nH
         xzXSB9nR2VfYvc6KaZYdR6389lhlOoS/gh6+l68vRvVpDQJWKQM/tk7vFHaxIRG7dsTU
         lEp85ri6wwQeqsB0pZFS2IHrFOyQxHC2C5iNQ82EsU+V2luHYnOBve933fbYDmfZew3r
         96seiWYyn285tf6agIdAA4MUXu5DoL4JXguuYJ89sf7JNCYSfzM4GkW90nJZIplLoU9Q
         u+UmSgJnmbxyYBCgdKWHlJwcWvMsMNzqRMnVwFJAawBrjGV9vS0BJ0VLJLjfjeV4XtiV
         E7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=MFmEDhXxgZF7KULdzona+7TtwCBEXCBX6WNuKW7to/k=;
        b=ZqI/+mHxsDbyCOf1UF/lHQeB9OCILp9l4wWr/vUXS84F5Ct5oavk84Gupy0ZzSh+tW
         FqxaqPYTsjqVamXZz7KbDUGA0ta4woNJRrHL75ZIPJrpwx61B5QQdjg9L5SQZBkQ7APW
         n9ctJ4RK61Pvm2Eaorf6arC24IDw02ZU/ShL4jYNVV8yocETkFcMKTsUC3etUa94MUW+
         EFlg3fItWXdwXpnutb9nxrdpOC/FU7CkmFt7m7TaGxKznE5afHb9qFszPl3JfLaeSY7W
         UrFO9g2qBJb7e+aBkKKP9Rh1E8ask/VhRpVf6XNsU5ZxuxzrRtQli17IVEfMPhXO770F
         dRkg==
X-Gm-Message-State: ACgBeo3WT+GwhKvceqlvJqnXBInGor1AIFgLM4tYM+jN3KmHj5mfme1d
        5mMB8OM2bFlpxbGsksDE3mATGA==
X-Google-Smtp-Source: AA6agR4zbj03HwNiKvNCAMqjbPAZBOEZ5IFS9rP9aP7B53I/HuQKSj52sakcI3/ZRNQcW0rIS0Ap1w==
X-Received: by 2002:a05:6512:39ce:b0:48c:f4d8:d418 with SMTP id k14-20020a05651239ce00b0048cf4d8d418mr724314lfu.635.1660815995938;
        Thu, 18 Aug 2022 02:46:35 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id p4-20020a056512234400b00492adcfefc1sm155757lfu.198.2022.08.18.02.46.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 02:46:35 -0700 (PDT)
Message-ID: <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
Date:   Thu, 18 Aug 2022 12:46:33 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/3] dt-bings: net: fsl,fec: update compatible item
Content-Language: en-US
To:     Shawn Guo <shawnguo@kernel.org>
Cc:     Wei Fang <wei.fang@nxp.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        s.hauer@pengutronix.de, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        peng.fan@nxp.com, ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
References: <20220704101056.24821-1-wei.fang@nxp.com>
 <20220704101056.24821-2-wei.fang@nxp.com>
 <ef7e501a-b351-77f9-c4f7-74ab10283ed6@linaro.org>
 <20220818013344.GE149610@dragon>
 <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
 <20220818092257.GF149610@dragon>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220818092257.GF149610@dragon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2022 12:22, Shawn Guo wrote:
> On Thu, Aug 18, 2022 at 10:51:02AM +0300, Krzysztof Kozlowski wrote:
>> On 18/08/2022 04:33, Shawn Guo wrote:
>>> On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
>>>>> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>> index daa2f79a294f..6642c246951b 100644
>>>>> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>> @@ -40,6 +40,10 @@ properties:
>>>>>            - enum:
>>>>>                - fsl,imx7d-fec
>>>>>            - const: fsl,imx6sx-fec
>>>>> +      - items:
>>>>> +          - enum:
>>>>> +              - fsl,imx8ulp-fec
>>>>> +          - const: fsl,imx6ul-fec
>>>>
>>>> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
>>>> think someone made similar mistakes earlier so this is a mess.
>>>
>>> Hmm, not sure I follow this.  Supposing we want to have the following
>>> compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
>>> here?
>>>
>>> 	fec: ethernet@29950000 {
>>> 		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
>>> 		...
>>> 	};
>>
>> Because a bit earlier this bindings is saying that fsl,imx6ul-fec must
>> be followed by fsl,imx6q-fec.
> 
> The FEC driver OF match table suggests that fsl,imx6ul-fec and fsl,imx6q-fec
> are not really compatible.
> 
> static const struct of_device_id fec_dt_ids[] = {
>         { .compatible = "fsl,imx25-fec", .data = &fec_devtype[IMX25_FEC], },
>         { .compatible = "fsl,imx27-fec", .data = &fec_devtype[IMX27_FEC], },
>         { .compatible = "fsl,imx28-fec", .data = &fec_devtype[IMX28_FEC], },
>         { .compatible = "fsl,imx6q-fec", .data = &fec_devtype[IMX6Q_FEC], },
>         { .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
>         { .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
>         { .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },

I don't see here any incompatibility. Binding driver with different
driver data is not a proof of incompatible devices. Additionally, the
binding describes the hardware, not the driver.

>         { .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
>         { .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
>         { /* sentinel */ }
> };
> MODULE_DEVICE_TABLE(of, fec_dt_ids);
> 
> Should we fix the binding doc?

Maybe, I don't know. The binding describes the hardware, so based on it
the devices are compatible. Changing this, except ABI impact, would be
possible with proper reason, but not based on Linux driver code.


Best regards,
Krzysztof
