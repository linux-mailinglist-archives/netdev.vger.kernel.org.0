Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46693597F83
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 09:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243950AbiHRHvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 03:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243781AbiHRHvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 03:51:08 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A471AF0C6
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:51:07 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id bx38so933503ljb.10
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 00:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=fS1GbInIBT62wufy84Arx4epUlW3RObiFTS+tgetyTk=;
        b=keoomPMpM4w81nF3xeLMz5h7ETgxWI5I+rea3IIfD55BByvaFz8fKdMtR1w2iFWkJX
         lUTuHQFSgWhz50sNlYzKYea6JqOBhUESVmoakyAVcjNjTl43RUrfnUmGfEKxn0u2ukzC
         itf1Zpb3/vEtjuiEjrJClt6FiGtk0mJXqptM8nzyy4wxp8dqLrNhApj6KJsGn5C5Uu3r
         K9OupUSvUFbMhXBR+qGgosGqoZRzuG7HgU2eAG1QNwAto2tJwQKt78a0EUyubOsAii76
         kDC3KEDvScwCatOLqz97elXndGbbVGc0CadOMfq67AGL4XIwSz4NmsgsbxuMs8FuLmsf
         6aJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=fS1GbInIBT62wufy84Arx4epUlW3RObiFTS+tgetyTk=;
        b=Zqvy7kop0GxLY2lnrciUe/8lewYpV+VwQHATHQU2JjD+VwV8W2ikA8pOt+Y6FKJIzX
         r0FP0QPKNEpzvglkxKVhfRAW2AmI2rD9pm663ycBOzWjLbKmS7lcpMNvdciW7F2jy4sr
         lc5ui6F/ONa6Xp8x+U/dNwwSZNBYT5RGucWRti5wmadI4HaXVBURMTpIdACmc/OM73u8
         EenOogcMbcgvnajChpEPI8H1R989oKzb5z7B83paEmhmf3nX9GbH8I+JXTms4F9+GVCX
         FJuo99WrCLpKckSNQQ70KvyJ+fvbdWtc5TPRr+v6AU7W34IkRl+fC7eFtncqpn8GkNbd
         o9uw==
X-Gm-Message-State: ACgBeo3uDoimVcZAXE/xz5vymJ6X21yOwcntC6Xvr857Eap1EfqHEhBt
        pESmLD8cSpX5sf51kPOHq9vF6Q==
X-Google-Smtp-Source: AA6agR6v3Fx6yHipuVXtDQ6ZQZ8fmzkCw46l3zsAq+co+6vRBTz5d/VZLwaRBZo9SEw6jVuSep0pEw==
X-Received: by 2002:a2e:6e13:0:b0:25e:87b1:fda8 with SMTP id j19-20020a2e6e13000000b0025e87b1fda8mr491865ljc.250.1660809065387;
        Thu, 18 Aug 2022 00:51:05 -0700 (PDT)
Received: from ?IPV6:2001:14bb:ae:539c:53ab:2635:d4f2:d6d5? (d15l54z9nf469l8226z-4.rev.dnainternet.fi. [2001:14bb:ae:539c:53ab:2635:d4f2:d6d5])
        by smtp.gmail.com with ESMTPSA id bf12-20020a056512258c00b0048a88c07bcdsm127225lfb.20.2022.08.18.00.51.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 00:51:04 -0700 (PDT)
Message-ID: <fd41a409-d0e0-0026-4644-9058d1177c45@linaro.org>
Date:   Thu, 18 Aug 2022 10:51:02 +0300
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
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220818013344.GE149610@dragon>
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

On 18/08/2022 04:33, Shawn Guo wrote:
> On Mon, Jul 04, 2022 at 11:12:09AM +0200, Krzysztof Kozlowski wrote:
>>> diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>> index daa2f79a294f..6642c246951b 100644
>>> --- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>> +++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
>>> @@ -40,6 +40,10 @@ properties:
>>>            - enum:
>>>                - fsl,imx7d-fec
>>>            - const: fsl,imx6sx-fec
>>> +      - items:
>>> +          - enum:
>>> +              - fsl,imx8ulp-fec
>>> +          - const: fsl,imx6ul-fec
>>
>> This is wrong.  fsl,imx6ul-fec has to be followed by fsl,imx6q-fec. I
>> think someone made similar mistakes earlier so this is a mess.
> 
> Hmm, not sure I follow this.  Supposing we want to have the following
> compatible for i.MX8ULP FEC, why do we have to have "fsl,imx6q-fec"
> here?
> 
> 	fec: ethernet@29950000 {
> 		compatible = "fsl,imx8ulp-fec", "fsl,imx6ul-fec";
> 		...
> 	};

Because a bit earlier this bindings is saying that fsl,imx6ul-fec must
be followed by fsl,imx6q-fec.

Best regards,
Krzysztof
