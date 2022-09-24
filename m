Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3E5E8F74
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 21:06:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbiIXTGq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 15:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233463AbiIXTGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 15:06:44 -0400
Received: from mx15lb.world4you.com (mx15lb.world4you.com [81.19.149.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C49C303F5;
        Sat, 24 Sep 2022 12:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=6LHWS+ODuzedUsjl08yIAOMNxYKvdZQqOuzZ/KojxC8=; b=NTHgtfkNQg59u1/4X3FtMy7s4Z
        3Fwnp3uT7DDwTIfE6rn+c9PVN3w/tdfAmMcJdF5o58BPvgrLhtw0IA1MewcUMnQ9MplwppUGY1bEj
        iJQ62JRSr/iKmHNJLQwbRpfFIKPKysQhedA0Rh/D4hsBQj/GJ/mP7wbFCzyYS0aYJKmc=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx15lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ocAU5-0008Jt-24; Sat, 24 Sep 2022 21:06:41 +0200
Message-ID: <dfa31cab-1952-e48d-d05c-50d2d44b2f5c@engleder-embedded.com>
Date:   Sat, 24 Sep 2022 21:06:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 2/6] dt-bindings: net: tsnep: Allow additional
 interrupts
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
References: <20220923202911.119729-1-gerhard@engleder-embedded.com>
 <20220923202911.119729-3-gerhard@engleder-embedded.com>
 <b7e44e61-4beb-7b94-01e5-d217c546114d@linaro.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <b7e44e61-4beb-7b94-01e5-d217c546114d@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.09.22 11:17, Krzysztof Kozlowski wrote:
> On 23/09/2022 22:29, Gerhard Engleder wrote:
>> Additional TX/RX queue pairs require dedicated interrupts. Extend
>> binding with additional interrupts.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   .../bindings/net/engleder,tsnep.yaml          | 37 ++++++++++++++++++-
>>   1 file changed, 36 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>> index 37e08ee744a8..ce1f1bd413c2 100644
>> --- a/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>> +++ b/Documentation/devicetree/bindings/net/engleder,tsnep.yaml
>> @@ -20,7 +20,23 @@ properties:
>>       maxItems: 1
>>   
>>     interrupts:
>> -    maxItems: 1
>> +    minItems: 1
>> +    maxItems: 8
>> +
>> +  interrupt-names:
>> +    minItems: 1
>> +    maxItems: 8
>> +    items:
>> +      pattern: '^mac|txrx-[1-7]$'
> 
> No. The order of items must be fixed. Now you allow any combination,
> which is exactly what we do not want.

Ok. I will do it like in 
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml#L58

>> +    description:
>> +      If more than one interrupt is available, then interrupts are
>> +      identified by their names.
> 
> Not really. Interrupts are fixed, unless explicitly mentioned otherwise.
> 
>> +      "mac" is the main interrupt for basic MAC features and the first
>> +      TX/RX queue pair. If only a single interrupt is available, then
>> +      it is assumed that this interrupt is the "mac" interrupt.
>> +      "txrx-[1-7]" are the interrupts for additional TX/RX queue pairs.
>> +      These interrupt names shall start with index 1 and increment the
>> +      index by 1 with every further TX/RX queue pair.
> 
> Skip last three sentences - they will become redundant after
> implementing proper items.

I will rework description for fixed order.

>>   
>>     dma-coherent: true
>>   
>> @@ -78,4 +94,23 @@ examples:
>>                   };
>>               };
>>           };
> 
> Missing line break.

I will add it.
> Best regards,
> Krzysztof

Thanks!

Gerhard
