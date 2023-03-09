Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572756B19CB
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:10:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjCIDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCIDKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:10:08 -0500
Received: from ex01.ufhost.com (ex01.ufhost.com [61.152.239.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BED72B3E;
        Wed,  8 Mar 2023 19:10:05 -0800 (PST)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by ex01.ufhost.com (Postfix) with ESMTP id A461C24E1A4;
        Thu,  9 Mar 2023 11:10:02 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Mar
 2023 11:10:02 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 9 Mar
 2023 11:10:01 +0800
Message-ID: <aac48eab-5f36-396a-d582-a944cd07c30d@starfivetech.com>
Date:   Thu, 9 Mar 2023 11:10:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v5 03/12] dt-bindings: net: snps,dwmac: Add an optional
 resets single 'ahb'
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
CC:     <linux-riscv@lists.infradead.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230303085928.4535-1-samin.guo@starfivetech.com>
 <20230303085928.4535-4-samin.guo@starfivetech.com>
 <20230308215709.GA3904341-robh@kernel.org>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <20230308215709.GA3904341-robh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [PATCH v5 03/12] dt-bindings: net: snps,dwmac: Add an optional resets single 'ahb'
From: Rob Herring <robh@kernel.org>

> On Fri, Mar 03, 2023 at 04:59:19PM +0800, Samin Guo wrote:
>> According to:
>> stmmac_platform.c: stmmac_probe_config_dt
>> stmmac_main.c: stmmac_dvr_probe
> 
> That's not really a reason on its own. Maybe the driver is wrong. Do we 
> know what hardware needs this?
> 
Hi Rob, Starfive JH7110 SOC must have two resets (stmmaceth+ahb), it uses snps,dwmac-5.20 IP.

Best regards,
Samin
>> dwmac controller may require one (stmmaceth) or two (stmmaceth+ahb)
>> reset signals, and the maxItems of resets/reset-names is going to be 2.
>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  .../devicetree/bindings/net/snps,dwmac.yaml        | 14 ++++++++++----
>>  1 file changed, 10 insertions(+), 4 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> index b4135d5297b4..89099a888f0b 100644
>> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
>> @@ -133,12 +133,18 @@ properties:
>>          - ptp_ref
>>  
>>    resets:
>> -    maxItems: 1
>> -    description:
>> -      MAC Reset signal.
>> +    minItems: 1
>> +    items:
>> +      - description: GMAC stmmaceth reset
>> +      - description: AHB reset
>>  
>>    reset-names:
>> -    const: stmmaceth
>> +    minItems: 1
>> +    maxItems: 2
>> +    contains:
> 
> This means 'reset-names = "foo", "ahb";' is valid. You want 'items' 
> instead. However, that still allows the below string in any order. Do we 
> really need that? If not, then you want:
> 
> items:
>   - const: stmmaceth
>   - const: ahb
> 
Thank you for your guidance. It will be better to modify it in this way, I will fix it in next version.

Best regards,
Samin
>> +      enum:
>> +        - stmmaceth
>> +        - ahb
>>  
>>    power-domains:
>>      maxItems: 1
>> -- 
>> 2.17.1
>>

