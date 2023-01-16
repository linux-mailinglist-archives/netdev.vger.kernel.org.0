Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F0566B5BD
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 03:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjAPCuD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 21:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231806AbjAPCt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 21:49:58 -0500
Received: from out28-218.mail.aliyun.com (out28-218.mail.aliyun.com [115.124.28.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65607EED;
        Sun, 15 Jan 2023 18:49:53 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.09077504|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0574618-0.00379392-0.938744;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.QtcxEZT_1673837386;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.QtcxEZT_1673837386)
          by smtp.aliyun-inc.com;
          Mon, 16 Jan 2023 10:49:47 +0800
Message-ID: <7c38c139-9a5d-f098-3252-cbf5fe51e776@motor-comm.com>
Date:   Mon, 16 Jan 2023 10:49:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
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
        xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com> <Y7bN4vJXMi66FF6v@lunn.ch>
 <e762c7ac-63e7-a86e-3e3f-5c8a450b25b0@motor-comm.com>
 <Y7goXXiRBE6XHuCc@lunn.ch>
 <83fd7a69-7e6a-ab93-b05a-4eba8af4d245@motor-comm.com>
 <Y760k6/pKdjwu1fU@lunn.ch>
Content-Language: en-US
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <Y760k6/pKdjwu1fU@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On 2023/1/11 21:07, Andrew Lunn wrote:
>> RX delay = rx-delay-basic (0ns or 1.9ns) + x-delay-additional-ps
>> (N*150ps, N = 0 ~ 15)
>>  If rx-delay-basic is removed and controlled by phy-mode.
>>  when phy-mode is  rgmii-id or rgmii-rxid, RX delay is 1.9ns + N*150ps.
>>  But sometimes 1.9ns is still too big, we just need  0ns + N*150ps.
>>
>> For this case, can we do like following ?
>> rx-internal-delay-ps:
>>     enum: [ 0, 150, 300, 450, 600, 750, 900, 1050, 1200, 1350, 1500,
>> 1650, 1800, 1900, 1950, 2050, 2100, 2200, 2250, 2350, 2500, 2650, 2800,
>> 2950, 3100, 3250, 3400, 3550, 3700, 3850, 4000, 4150 ]
>>     default: 0
>>  rx-internal-delay-ps is 0ns + N*150ps and  1.9ns + N*150ps.
>>  And check whether need rx-delay-basic (1.9ns) by the val of
>> rx-internal-delay-ps?
> 
> Nothing says delays are only positive. So you could have rgmii-id or
> rgmii-rxid and a rx-internal-delay-ps of -150, if you need less than
> 1.9ns.
> 
> As i said, rx-internal-delay-ps is used to fine tune the delay.

The standard type of rx-internal-delay-ps is uint32-array, so it can't
be -150.

https://github.com/devicetree-org/dt-schema/blob/main/dtschema/schemas/property-units.yaml

 "-ps$":
    $ref: types.yaml#/definitions/uint32-array
    description: picosecond


Can we used rx-internal-delay-ps with int32 type?
like this:
  rx-internal-delay-ps:
    $ref: /schemas/types.yaml#/definitions/int32
    enum: [ -1900, -1750, -1600, -1450, -1300, -1150, -1000, -850, -700,
-550, -400, -250, -100, 0, 50, 150, 200, 300, 350, 450, 600, 750, 900,
1050, 1200, 1350, 1500, 1650, 1800, 1950, 2100, 2250 ]
    default: 0


> 
>> We can't reduce this down to tx-clk-inverted.
>> There are two mac and two yt8531 on their board. Each of yt8531 need
>> different config in DTS. They need adjust tx clk delay in
>> link_change_notify callback function according to current speed.
>>
>>  They configured tx-clk-xxxx-inverted like this :
>>
>>     speed     GMAC0             GMAC1
>>     1000M      1                  0		tx-clk-1000-inverted
>>     100M       1                  1		tx-clk-100-inverted
>>     10M       0/1                0/1     	tx-clk-10-inverted
> 
> What MAC is this? It seems very oddly designed, getting close to
> broken. I've not seen any other MAC/PHY combination need anything like
> this. 
> 
>> Can we put tx-clk-adj-enabled, tx-clk-10-inverted, tx-clk-100-inverted
>> and tx-clk-1000-inverted in tx-clk-10-inverted like bit in byte?
> 
> No, they are individual boolean properties, so should be kept as they
> are. But i really think somebody should be looking deep into the MAC
> design to understand why it is like this, and if the MAC can sort out
> this mess itself.
> 
> 	Andrew

Tanks. We will remove tx-clk-xxxx-inverted and tx-clk-adj-enabled.
