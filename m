Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAD06F3C38
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 04:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233390AbjEBCzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 May 2023 22:55:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232790AbjEBCzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 May 2023 22:55:08 -0400
Received: from mail.fintek.com.tw (mail.fintek.com.tw [59.120.186.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893853AAB;
        Mon,  1 May 2023 19:55:05 -0700 (PDT)
Received: from vmMailSRV.fintek.com.tw ([192.168.1.1])
        by mail.fintek.com.tw with ESMTP id 3422rcLt091729;
        Tue, 2 May 2023 10:53:38 +0800 (+08)
        (envelope-from peter_hong@fintek.com.tw)
Received: from [192.168.1.132] (192.168.1.132) by vmMailSRV.fintek.com.tw
 (192.168.1.1) with Microsoft SMTP Server id 14.3.498.0; Tue, 2 May 2023
 10:53:42 +0800
Message-ID: <f9c007ae-fcfb-4091-c202-2c27e3ba1151@fintek.com.tw>
Date:   Tue, 2 May 2023 10:53:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH V5] can: usb: f81604: add Fintek F81604 support
Content-Language: en-US
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <wg@grandegger.com>, <Steen.Hegelund@microchip.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <frank.jungclaus@esd.eu>,
        <linux-kernel@vger.kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, <hpeter+linux_kernel@gmail.com>
References: <20230420024403.13830-1-peter_hong@fintek.com.tw>
 <CAMZ6RqKWrtBMFSD=BzGuCbvj=+3X-A-oW9haJ7=4kyL2AbEuHQ@mail.gmail.com>
 <51991fc1-0746-608f-b3bb-78b64e6d1a3e@fintek.com.tw>
 <CAMZ6Rq+zsC4F-mNhjKvqgPQuLhnnX1y79J=qOT8szPvkHY86VQ@mail.gmail.com>
From:   Peter Hong <peter_hong@fintek.com.tw>
In-Reply-To: <CAMZ6Rq+zsC4F-mNhjKvqgPQuLhnnX1y79J=qOT8szPvkHY86VQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.1.132]
X-TM-AS-Product-Ver: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-AS-Result: No-16.712700-8.000000-10
X-TMASE-MatchedRID: HXSqh3WYKfv/9O/B1c/Qy2lHv4vQHqYTlmG/61+LLCeqvcIF1TcLYL2T
        Wg09qIv+AZELdsEgXyh8MG8UC5V2hrvUM1lvDMQ6EVuC0eNRYvLwUenwsKlntMR6XQwVUHowY2i
        R7K8WcswpVwmVg7b70qMcP/k6QRHlPkXUyNZYKfrfqVBdB7I8UUxhUFgrZenKDSG7dmYh9brV9x
        7gL2l/Mgac8ZIsTvB5hnyFUo2UMB/b/MChN5Pw5o61Z+HJnvsOrzl8sNiWClKbKItl61J/ybLn+
        0Vm71Lcq7rFUcuGp/EgBwKKRHe+r3GKVCan0s8kzGJ94pHZV8kboPbGYT1g7p4Svg7QmAiP9u9C
        o9lCee0=
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--16.712700-8.000000
X-TMASE-Version: SMEX-12.5.0.2055-9.0.1002-27556.001
X-TM-SNTS-SMTP: 8536A6B835DB7979EF3EA7DAAC7F86771912D5CAB0CDAC7231E801470F769B7D2000:8
X-DNSRBL: 
X-SPAM-SOURCE-CHECK: pass
X-MAIL: mail.fintek.com.tw 3422rcLt091729
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincent, Michal and Marc,

Vincent MAILHOL 於 2023/4/21 下午 03:30 寫道:
> Hi Peter and Michal,
>
> On Fry. 21 Apr. 2023 at 12:14, Peter Hong <peter_hong@fintek.com.tw> wrote:
>> Hi Vincent,
>>
>> Vincent MAILHOL 於 2023/4/20 下午 08:02 寫道:
>>> Hi Peter,
>>>
>>> Here are my comments. Now, it is mostly nitpicks. I guess that this is
>>> the final round.
>>>
>>> On Thu. 20 avr. 2023 at 11:44, Ji-Ze Hong (Peter Hong)
>>> <peter_hong@fintek.com.tw> wrote:
>>>> +static void f81604_handle_tx(struct f81604_port_priv *priv,
>>>> +                            struct f81604_int_data *data)
>>>> +{
>>>> +       struct net_device *netdev = priv->netdev;
>>>> +       struct net_device_stats *stats;
>>>> +
>>>> +       stats = &netdev->stats;
>>> Merge the declaration with the initialization.
>> If I merge initialization into declaration, it's may violation RCT?
>> How could I change about this ?
> @Michal: You requested RTC in:
>
> https://lore.kernel.org/linux-can/ZBgKSqaFiImtTThv@localhost.localdomain/
>
> I looked at the kernel documentation but I could not find "Reverse
> Chistmas Tree". Can you point me to where this is defined?
>
> In the above case, I do not think RCT should apply.
>
> I think that this:
>
>          struct net_device *netdev = priv->netdev;
>          struct net_device_stats *stats = &netdev->stats;
>
> Is better than that:
>
>          struct net_device *netdev = priv->netdev;
>          struct net_device_stats *stats;
>
>          stats = &netdev->stats;
>
> Arbitrarily splitting the definition and assignment does not make sense to me.
>
> Thank you for your comments.

The RCT coding style seems a bit confuse. How about refactoring of next 
step? @Marc ?


Thanks,
