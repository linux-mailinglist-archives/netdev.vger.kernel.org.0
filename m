Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4C5B6386C1
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 10:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiKYJv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 04:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiKYJvP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 04:51:15 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D31D46678
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:48:44 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id t17so3262628pjo.3
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 01:48:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fh9lKt/Ex1PEWTAeH6nLeKPXEkO8R8rkyg+dYswqgEE=;
        b=vDysZeeLfQomwf6B75nRI+HaGjwrhHZIUs5fdZIrRPKP/VbWvL7yQ0ALrxn4dZl7j9
         n+kpaP41Wst0rPmTeoFnCi1nUcqjnbvqBwdn69zyBwUV/DX4wxKIvJ/vlrfJ8V/DUNmg
         Je7abb6o1fqWw+0Owl7vUd5QNv/AEvpp0VaHOT+SOBNUcA8KkJzgDrlQyWWRtEjH6YMb
         id+oeuDWgcYSLAEolbcBqs864ZePbxbPDZZmCwSYUqNYf8Dqrw1ah3nxPAIp87+ybaEc
         OMNm7FyX6fB7gDrl5TTgsNRtySjRrC+DRrN1m5r/w9nqR06/zETDgWY+DnOLP/hj/z9L
         dRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fh9lKt/Ex1PEWTAeH6nLeKPXEkO8R8rkyg+dYswqgEE=;
        b=jvEQP+us8SdiHXYUj07REzEY9BRDiPqkiwhmSlpUXYoVrTYL5sLL4e+9J93c93CppU
         mVaMgY4elCEyWggqvlqzVyB33+SywLJX6NtDrEL7BgvMQahS/Ude5RkQUL9kytXR/u8e
         hjQQpwm67pFbgpvOqgxtlRNIBdeBPBQ5BRtHVzoKBSb6Pr0fpmPHs/jdS5x9+OMFWSW3
         1cEQYdYcVYeEbrqL0fC/3yS2zgWSbv1HMDPVMqKY7uLkU0UiNNO/sAMhp9Ic//imD6dq
         mSOy8fGwPnc7Iitetl5brQMBkWHss49iSnCSTtXtbVEFxFfFR7cPoWIQ4dySBXk4VH1N
         yRnQ==
X-Gm-Message-State: ANoB5pknCdpqHoAE9c3DxrnD3v7TuTyVqIeSvdKisdQvjdcn18f0EZ55
        bbf+cLOgb0QAReT1Dp6lI9ktvQ==
X-Google-Smtp-Source: AA0mqf7lZaeE4yg7AW0Zyy+PHMsdV0xTaeowycIugKV0CyHIEnPfVIYVEXLDovr2cbvx7/bzEry1XA==
X-Received: by 2002:a17:903:40c4:b0:188:4f86:e4ea with SMTP id t4-20020a17090340c400b001884f86e4eamr18503460pld.59.1669369723802;
        Fri, 25 Nov 2022 01:48:43 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id r17-20020a63ce51000000b0045751ef6423sm2273887pgi.87.2022.11.25.01.48.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Nov 2022 01:48:43 -0800 (PST)
Message-ID: <4a2d4e3e-5b15-2c58-dc49-92908ab80ad0@daynix.com>
Date:   Fri, 25 Nov 2022 18:48:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v3] igb: Allocate MSI-X vector when testing
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
 <Y34/LDxCnYd6VGJ2@boxer>
Content-Language: en-US
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <Y34/LDxCnYd6VGJ2@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/11/24 0:41, Maciej Fijalkowski wrote:
> On Wed, Nov 23, 2022 at 10:09:26AM +0900, Akihiko Odaki wrote:
>> Without this change, the interrupt test fail with MSI-X environment:
>>
>> $ sudo ethtool -t enp0s2 offline
>> [   43.921783] igb 0000:00:02.0: offline testing starting
>> [   44.855824] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Down
>> [   44.961249] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> [   51.272202] igb 0000:00:02.0: testing shared interrupt
>> [   56.996975] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> The test result is FAIL
>> The test extra info:
>> Register test  (offline)	 0
>> Eeprom test    (offline)	 0
>> Interrupt test (offline)	 4
>> Loopback test  (offline)	 0
>> Link test   (on/offline)	 0
>>
>> Here, "4" means an expected interrupt was not delivered.
>>
>> To fix this, route IRQs correctly to the first MSI-X vector by setting
>> IVAR_MISC. Also, set bit 0 of EIMS so that the vector will not be
>> masked. The interrupt test now runs properly with this change:
> 
> Much better!
> 
>>
>> $ sudo ethtool -t enp0s2 offline
>> [   42.762985] igb 0000:00:02.0: offline testing starting
>> [   50.141967] igb 0000:00:02.0: testing shared interrupt
>> [   56.163957] igb 0000:00:02.0 enp0s2: igb: enp0s2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
>> The test result is PASS
>> The test extra info:
>> Register test  (offline)	 0
>> Eeprom test    (offline)	 0
>> Interrupt test (offline)	 0
>> Loopback test  (offline)	 0
>> Link test   (on/offline)	 0
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> 
> Same comment as on other patch - justify why there is no fixes tag and
> specify the tree in subject.

I couldn't identify what commit introduced the problem. Please see:
https://lore.kernel.org/netdev/f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com/

Regards,
Akihiko Odaki

> 
>> ---
>>   drivers/net/ethernet/intel/igb/igb_ethtool.c | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> index e5f3e7680dc6..ff911af16a4b 100644
>> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
>> @@ -1413,6 +1413,8 @@ static int igb_intr_test(struct igb_adapter *adapter, u64 *data)
>>   			*data = 1;
>>   			return -1;
>>   		}
>> +		wr32(E1000_IVAR_MISC, E1000_IVAR_VALID << 8);
>> +		wr32(E1000_EIMS, BIT(0));
>>   	} else if (adapter->flags & IGB_FLAG_HAS_MSI) {
>>   		shared_int = false;
>>   		if (request_irq(irq,
>> -- 
>> 2.38.1
>>
