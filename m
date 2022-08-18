Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C29FA59852F
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245565AbiHROEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245562AbiHROE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:04:27 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F97FB7D3
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:04:25 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id a9so2239576lfm.12
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 07:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=/fleTIpnS9IEBTbF8wo3ueeoCXUGjNkQO4k9xiqRrj4=;
        b=WXgDg4S099HTx4GYgF7438X6p5+shS7CVHR1tjTv5vT25xR45B6IpZ9jhDZz24MFIE
         QYgcE82wPnA6kp/yoF5KRHFg2R1O1rA0Hj3teQ/VwW6ecJCoTpgo1t1hwWTLfUqm7isa
         wPhcprIQQyMzd5VP3nJthYZeUSeel/FnDfuu8sVUdrc9ivIl0o9G/FLaK4i83CbCUR95
         dPmZq615cmnqNWTE8xGMASQ5tJP/6xGoFpVrz611Tyy0YuQz/kvNwF22eEsEO7mWuqll
         UDQIMCwYqn7bOluibttIYU6Mn5Cei8pA13Vu99//76sJQFaN5oyc3DG6XTjq0FOjoFFJ
         /Uvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/fleTIpnS9IEBTbF8wo3ueeoCXUGjNkQO4k9xiqRrj4=;
        b=P6/d47V5W8W6+A9ZrMO9cqcgnFwozOrgoVVNOC2rHpdsNh2Q7ymAPmb6qfVhV1pmnH
         UpR4BIzigcEHIKZYzKXK6GLFRCaWsLQaQcgoelX5+jdTUbvmNWzWODvKuNZ0g+cQuRMj
         VOXpGSuTu552ehQl+cYxKDcM40PO+gMPTnHIXakwgYFAbYMNSdbiMhfOHDNzr+kKWfxC
         uRhp4ZK7GOAhEbYgVMMjO5pPO+agmXaIv5nmLqL3zDGNZzRzh7BgCOECpWeGQBmH2JgH
         pbWthvCvpCb54hljPkKoU6TUhVRvB7AmMmAVNapMwTV421XTI1K6jomYZS9/m7Mehrt3
         dC7w==
X-Gm-Message-State: ACgBeo2Y4+6os0DBOomeb7MW2MN4/PTyLjgO2wrxOweLCXZVmLXRjcDD
        rfm+/UCsDVnpI9IR9KvA4CJPnw==
X-Google-Smtp-Source: AA6agR5VgtXwrxbtl+luU09vE2LQ9Ag6BfzzlNsOlvu+CLmU3emPg2IrZYFkOC0AmgjlyeHuX66LQA==
X-Received: by 2002:a05:6512:159b:b0:492:c1c0:5aab with SMTP id bp27-20020a056512159b00b00492c1c05aabmr477299lfb.523.1660831463816;
        Thu, 18 Aug 2022 07:04:23 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id a2-20020a05651c030200b002619257da21sm241529ljp.118.2022.08.18.07.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 07:04:23 -0700 (PDT)
Message-ID: <00614b8f-0fdd-3d7e-0153-3846be5bb645@linaro.org>
Date:   Thu, 18 Aug 2022 17:04:20 +0300
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
 <a08b230c-d655-75ee-0f0c-8281b13b477b@linaro.org>
 <20220818135727.GG149610@dragon>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220818135727.GG149610@dragon>
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

On 18/08/2022 16:57, Shawn Guo wrote:
> On Thu, Aug 18, 2022 at 12:46:33PM +0300, Krzysztof Kozlowski wrote:
>> On 18/08/2022 12:22, Shawn Guo wrote:
>>> On Thu, Aug 18, 2022 at 10:51:02AM +0300, Krzysztof Kozlowski wrote:
>>>> On 18/08/2022 04:33, Shawn Guo wrote:
>>>>> On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
>>>>>>> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>>>> index daa2f79a294f..6642c246951b 100644
>>>>>>> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>>>> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>>>>>> @@ -40,6 +40,10 @@ properties:
>>>>>>>            - enum:
>>>>>>>                - fsl,imx7d-fec
>>>>>>>            - const: fsl,imx6sx-fec
>>>>>>> +      - items:
>>>>>>> +          - enum:
>>>>>>> +              - fsl,imx8ulp-fec
>>>>>>> +          - const: fsl,imx6ul-fec
>>>>>>
>>>>>> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
>>>>>> think someone made similar mistakes earlier so this is a mess.
>>>>>
>>>>> Hmm, not sure I follow this.  Supposing we want to have the following
>>>>> compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
>>>>> here?
>>>>>
>>>>> 	fec: ethernet@29950000 {
>>>>> 		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
>>>>> 		...
>>>>> 	};
>>>>
>>>> Because a bit earlier this bindings is saying that fsl,imx6ul-fec must
>>>> be followed by fsl,imx6q-fec.
>>>
>>> The FEC driver OF match table suggests that fsl,imx6ul-fec and fsl,imx6q-fec
>>> are not really compatible.
>>>
>>> static const struct of_device_id fec_dt_ids[] = {
>>>         { .compatible = "fsl,imx25-fec", .data = &fec_devtype[IMX25_FEC], },
>>>         { .compatible = "fsl,imx27-fec", .data = &fec_devtype[IMX27_FEC], },
>>>         { .compatible = "fsl,imx28-fec", .data = &fec_devtype[IMX28_FEC], },
>>>         { .compatible = "fsl,imx6q-fec", .data = &fec_devtype[IMX6Q_FEC], },
>>>         { .compatible = "fsl,mvf600-fec", .data = &fec_devtype[MVF600_FEC], },
>>>         { .compatible = "fsl,imx6sx-fec", .data = &fec_devtype[IMX6SX_FEC], },
>>>         { .compatible = "fsl,imx6ul-fec", .data = &fec_devtype[IMX6UL_FEC], },
>>
>> I don't see here any incompatibility. Binding driver with different
>> driver data is not a proof of incompatible devices.
> 
> To me, different driver data is a good sign of incompatibility.  It
> mostly means that software needs to program the hardware block
> differently.

Any device being 100% compatible with old one and having additional
features will have different driver data... so no, it's not a proof.
There are many of such examples and we call them compatible, because the
device could operate when bound by the fallback compatible.

If this is the case here - how do I know? I raised and the answer was
affirmative...

> 
> 
>> Additionally, the
>> binding describes the hardware, not the driver.
>>
>>>         { .compatible = "fsl,imx8mq-fec", .data = &fec_devtype[IMX8MQ_FEC], },
>>>         { .compatible = "fsl,imx8qm-fec", .data = &fec_devtype[IMX8QM_FEC], },
>>>         { /* sentinel */ }
>>> };
>>> MODULE_DEVICE_TABLE(of, fec_dt_ids);
>>>
>>> Should we fix the binding doc?
>>
>> Maybe, I don't know. The binding describes the hardware, so based on it
>> the devices are compatible. Changing this, except ABI impact, would be
>> possible with proper reason, but not based on Linux driver code.
> 
> Well, if Linux driver code is written in the way that hardware requires,
> I guess that's just based on hardware characteristics.
> 
> To me, having a device compatible to two devices that require different
> programming model is unnecessary and confusing.

It's the first time anyone mentions here the programming model is
different... If it is different, the devices are likely not compatible.

However when I raised this issue last time, there were no concerns with
calling them all compatible. Therefore I wonder if the folks working on
this driver actually know what's there... I don't know, I gave
recommendations based on what is described in the binding and expect the
engineer to come with that knowledge.


Best regards,
Krzysztof
