Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B11C46386D0
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbiKYJx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:53:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230034AbiKYJxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:53:43 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8122B42194
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:51:10 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id w23so3525759ply.12
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:51:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bbmEM5qM7x75sPofWy7v3pqSVY2Vhtwdbw54ZhPpgbc=;
        b=iCRTTBWxuRvODwOJYcmkFOkuQQgEPD4YOV57I1XT6x/N7GWmst0ZnZCi7YMuuT0J64
         kjIOD2tJUraxz8JF47riqkRk4U8AhE9gFDO1Mfrj2fdNIcftsgpJzbl2uXdR7QC0tQZF
         0x7ZuLz8IiIdAa68cuJUsosh9QLHhEyR+akU32YNINFT9cI+GbD4q4hv8YfmiUt+xkI5
         O6gt7StztbvFRkRafD77gbVXxjqv9KRYNKX1vbcMmpdf7+3XJTbL5o6ac59p+9ujnfHZ
         onQAYUkERIUNZ639SyW2QiCqjrg9kiQSfLu7tqnxfe4pSo/RDvV56F2P4ePMC/uZPfLp
         9XxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bbmEM5qM7x75sPofWy7v3pqSVY2Vhtwdbw54ZhPpgbc=;
        b=GDouEhgxN7LS7pUw9byR4KeSY8i9ZxAbp8ZHopRHpk9tu/f6j39FVHfVPiO4xTfLUm
         bzIFT4VmN2w1ad3rs5Bt6p8Tc8OhOsoQTn+0lonVDJfUZOA+kvUhHbA8aHkBLpCAbvP5
         DXoY57ZD0FjdbKz3afhuquR8ijoRneNdfTSRewbd7afmrUMjDfh9Xd1YynXY9drMlWJZ
         OU/hnKd4Gl5KXhGBSUOGYN8f5vavPpWSTicNMci0P54nPE29W9I/ZQwSn6HXOcRjRtr1
         cyWSpn/Y7qqfSdZatdSp2/7csH9Gp8+pc51q3GxLQFJpYRGqctjq2VAyaqyRaJbnmb7w
         3koA==
X-Gm-Message-State: ANoB5pmim+mhGNIG1PI8uo9SgxRSPgmQaxU3mc9o1nc9YKAfzSzO+7gu
        PcZJlo0OG7SuE99W6dvOxVqDzA==
X-Google-Smtp-Source: AA0mqf4XtwY0PRpNH7k/+GEDUWQA8GTcLYC744EyloOHpW7CdyaARbYWCo+ksrYQLTGwIUm3txp7Gg==
X-Received: by 2002:a17:90a:b703:b0:20d:7716:b05f with SMTP id l3-20020a17090ab70300b0020d7716b05fmr30217pjr.104.1669369849113;
        Fri, 25 Nov 2022 01:50:49 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id f9-20020a170902684900b0017f5c7d3931sm2889995pln.282.2022.11.25.01.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 01:50:48 -0800 (PST)
Message-ID: <1434bd67-1707-7e43-96b6-d2294ff7f04d@daynix.com>
Date:   Fri, 25 Nov 2022 18:50:45 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] igb: Allocate MSI-X vector when testing
Content-Language: en-US
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
References: <20221123010926.7924-1-akihiko.odaki@daynix.com>
 <Y34/LDxCnYd6VGJ2@boxer> <4a2d4e3e-5b15-2c58-dc49-92908ab80ad0@daynix.com>
In-Reply-To: <4a2d4e3e-5b15-2c58-dc49-92908ab80ad0@daynix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/25 18:48, Akihiko Odaki wrote:
> 
> 
> On 2022/11/24 0:41, Maciej Fijalkowski wrote:
>> On Wed, Nov 23, 2022 at 10:09:26AM +0900, Akihiko Odaki wrote:
>>> Without this change, the interrupt test fail with MSI-X environment:
>>>
>>> $ sudo ethtool -t enp0s2 offline
>>> [   43.921783] igb 0000:00:02.0: offline testing starting
>>> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
>>> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 
>>> 1000 Mbps Full Duplex, Flow Control: RX/TX
>>> [   51.272202] igb 0000:00:02.0: testing shared interrupt
>>> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 
>>> 1000 Mbps Full Duplex, Flow Control: RX/TX
>>> The test result is FAIL
>>> The test extra info:
>>> Register test  (offline)     0
>>> Eeprom test    (offline)     0
>>> Interrupt test (offline)     4
>>> Loopback test  (offline)     0
>>> Link test   (on/offline)     0
>>>
>>> Here, "4" means an expected interrupt was not delivered.
>>>
>>> To fix this, route IRQs correctly to the first MSI-X vector by setting
>>> IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
>>> masked. The interrupt test now runs properly with this change:
>>
>> Much better!
>>
>>>
>>> $ sudo ethtool -t enp0s2 offline
>>> [   42.762985] igb 0000:00:02.0: offline testing starting
>>> [   50.141967] igb 0000:00:02.0: testing shared interrupt
>>> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 
>>> 1000 Mbps Full Duplex, Flow Control: RX/TX
>>> The test result is PASS
>>> The test extra info:
>>> Register test  (offline)     0
>>> Eeprom test    (offline)     0
>>> Interrupt test (offline)     0
>>> Loopback test  (offline)     0
>>> Link test   (on/offline)     0
>>>
>>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>>
>> Same comment as on other patch - justify why there is no fixes tag and
>> specify the tree in subject.
> 
> I couldn't identify what commit introduced the problem. Please see:
> https://lore.kernel.org/netdev/f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com/

Sorry, the URL was wrong. The correct URL is:
https://lore.kernel.org/netdev/be5617fe-d332-447a-b836-bec9a6c6d42d@daynix.com/

Regards,
Akihiko Odaki

> 
> Regards,
> Akihiko Odaki
> 
>>
>>> ---
>>>   drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>>>   1 file changed, 2 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c 
>>> b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>> index e5f3e7680dc6..ff911af16a4b 100644
>>> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>>> @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter 
>>> *adapter, u64 *data)
>>>               *data = 1;
>>>               return -1;
>>>           }
>>> +        wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
>>> +        wr32(E1000_EIMS, BIT(0));
>>>       } else if (adapter->flags & IGB_FLAG_HAS_MSI) {
>>>           shared_int = false;
>>>           if (request_irq(irq,
>>> -- 
>>> 2.38.1
>>>
