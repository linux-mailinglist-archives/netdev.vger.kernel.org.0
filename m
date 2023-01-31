Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CFA6821F8
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 03:22:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbjAaCWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 21:22:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjAaCWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 21:22:00 -0500
Received: from out29-105.mail.aliyun.com (out29-105.mail.aliyun.com [115.124.29.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324142F7B3;
        Mon, 30 Jan 2023 18:21:58 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1227808|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0365434-0.003134-0.960323;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.R5WeoZj_1675131712;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R5WeoZj_1675131712)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 10:21:54 +0800
Message-ID: <18446b51-6428-d8c8-7f59-6a3b9845d2c4@motor-comm.com>
Date:   Tue, 31 Jan 2023 10:21:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
Subject: Re: [PATCH net-next v3 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Peter Geis <pgwipeout@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
 <20230130063539.3700-2-Frank.Sae@motor-comm.com> <Y9fOHxn8rdIHuDbn@lunn.ch>
Content-Language: en-US
In-Reply-To: <Y9fOHxn8rdIHuDbn@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/30 22:03, Andrew Lunn wrote:
> On Mon, Jan 30, 2023 at 02:35:35PM +0800, Frank Sae wrote:
>>  Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
>>  
>> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
>> ---
>>  .../bindings/net/motorcomm,yt8xxx.yaml        | 102 ++++++++++++++++++
>>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>>  MAINTAINERS                                   |   1 +
>>  3 files changed, 105 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> new file mode 100644
>> index 000000000000..8527576c15b3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> @@ -0,0 +1,102 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: MotorComm yt8xxx Ethernet PHY
>> +
>> +maintainers:
>> +  - frank sae <frank.sae@motor-comm.com>
>> +
>> +allOf:
>> +  - $ref: ethernet-phy.yaml#
>> +
>> +properties:
>> +  rx-internal-delay-ps:
>> +    description: |
>> +      RGMII RX Clock Delay used only when PHY operates in RGMII mode with
>> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-rxid') in pico-seconds.
>> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650,
>> +            1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
>> +            2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
>> +    default: 1950
> 
> Ah! There has been a misunderstand. Yes, this changes does make sense, but > 
>> +
>> +  tx-internal-delay-ps:
>> +    description: |
>> +      RGMII TX Clock Delay used only when PHY operates in RGMII mode with
>> +      internal delay (phy-mode is 'rgmii-id' or 'rgmii-txid') in pico-seconds.
>> +    enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800,
>> +            1950, 2100, 2250 ]
>> +    default: 150
> 
> ... i was actually trying to say this 150 is odd. Why is this not
> 1950?

 Tx-delay is usually adjusted by the mac (~ 2ns).
 So here is only fine-turn for the tx-delay.

> 
> 	Andrew
