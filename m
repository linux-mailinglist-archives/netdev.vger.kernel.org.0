Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30063634BFA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 02:04:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235392AbiKWBEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 20:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235059AbiKWBE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 20:04:29 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D7DA4F2
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:04:27 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id b62so15535837pgc.0
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 17:04:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ChWuCRj2lztiuijm5XOjLHSRF/5QHbLZueG3gnKY4L8=;
        b=YwVkPoatcqi4jXSpmqwULOaickgxdfWjzYRsRGsfVhr2gxfiYnamK0eNVwHMQ+R1gR
         +r74F/yWjXL9Dwrm5ZeY9fWRnuoK0fghHmEDfEcsSmSDGw7L8jOd7SWE1uge/vkGcr+2
         hiCW2e96JXLas1N+CmvNFdVCsg/mBHpooxEpDAgG5QV0bqhRObQK7WmSF4VMlfPWAoip
         DyN3g1MpJGVdoiXz9hNv1bpm3MHQPqh7Wxb4PoyQm/DYbS/RJQAO+9vtfuRQBPJk2RJo
         AdGTeCW4/TKO/gL+9GJulh+3Ktb5JVA65swTrWQKzlUscwYRkPM8jSjjxS3FVCokQ9mW
         LqoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ChWuCRj2lztiuijm5XOjLHSRF/5QHbLZueG3gnKY4L8=;
        b=h1WL7xZII73RiqDjppegSNbb92g8/f4zBjjC8zRWjEybY4ea5UsL6jpwehE32NkuX/
         lOTOryIEw/KTH6JtibA2lU9mGmM7yUZa3T3D4khNHXd5HAk1+6AEwUpuA4PMN9C2FAQY
         h6DAwbNcB4c1bzRyttdSqDYA6NEF2N478sd7zfoK6RbHPzVOfouCgSCw2fIVfKm9uUNj
         RBZtQ66AGu6hK6mTjDuDOfh4PUZPRP7dPWgTu7PUUMsZJTq/F1YfPIJFEVBigbdYxPfb
         C6NldyX8YcHJs8IYskeXzCqoIR7FYsAYTWgGzpwwX3QL0MnXuKB3RjKZdTDEj1/qnFxj
         8ihQ==
X-Gm-Message-State: ANoB5pnNzTp/Ajj39jrPPnOAb6S6HHqQh8jj8qdBMngyhDDqPkEXvWm6
        Ojt6HHFXwK0tJbm9uUTdl6IWxg==
X-Google-Smtp-Source: AA0mqf5e8w5bXA3SZQyPvtiv2JIpKsGGSQQ2IKYTpQVwLCWBveP11ej/boYKJtOJrVPO81Fo8fWZ0Q==
X-Received: by 2002:aa7:854d:0:b0:56d:6e51:60ee with SMTP id y13-20020aa7854d000000b0056d6e5160eemr6422159pfn.25.1669165467251;
        Tue, 22 Nov 2022 17:04:27 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id s187-20020a625ec4000000b0056b8181861esm11673965pfb.19.2022.11.22.17.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 17:04:26 -0800 (PST)
Message-ID: <f2457229-865a-57a0-94a1-c5c63b2f30a5@daynix.com>
Date:   Wed, 23 Nov 2022 10:04:22 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v2] igbvf: Regard vf reset nack as success
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Yan Vugenfirer <yan@daynix.com>,
        Yuri Benditovich <yuri.benditovich@daynix.com>
References: <20221122152630.76190-1-akihiko.odaki@daynix.com>
 <Y3z3Y5kpz2EgN3uq@boxer>
Content-Language: en-US
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <Y3z3Y5kpz2EgN3uq@boxer>
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

Hi,

On 2022/11/23 1:22, Maciej Fijalkowski wrote:
> On Wed, Nov 23, 2022 at 12:26:30AM +0900, Akihiko Odaki wrote:
>> vf reset nack actually represents the reset operation itself is
>> performed but no address is assigned. Therefore, e1000_reset_hw_vf
>> should fill the "perm_addr" with the zero address and return success on
>> such an occasion. This prevents its callers in netdev.c from saying PF
>> still resetting, and instead allows them to correctly report that no
>> address is assigned.
> 
> What's the v1->v2 diff?

Sorry, I mistakenly added you to CC (and didn't tell you the context). 
The diff is only in the message. For details, please look at:
https://patchew.org/linux/20221122092707.30981-1-akihiko.odaki@daynix.com/#647a4053-bae0-6c06-3049-274d389c2bdd@daynix.com

> Probably route to net and add fixes tag?
It is hard to determine the cause of the bug because it is about 
undocumented ABI. Linux introduced E1000_VF_RESET | 
E1000_VT_MSGTYPE_NACK response with commit 6ddbc4cf1f4d ("igb: Indicate 
failure on vf reset for empty mac address") so one can say it is the 
cause of the bug.

However, the PF may be driven by someone else Linux (Windows in 
particular), and if such system have already had E1000_VF_RESET | 
E1000_VT_MSGTYPE_NACK response defined, it can be said the bug existed 
even before Linux changes how the PF responds to E1000_VF_RESET request.

Regards,
Akihiko Odaki

> 
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
>> ---
>>   drivers/net/ethernet/intel/igbvf/vf.c | 15 ++++++++++++---
>>   1 file changed, 12 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/intel/igbvf/vf.c b/drivers/net/ethernet/intel/igbvf/vf.c
>> index b8ba3f94c363..2691ae2a8002 100644
>> --- a/drivers/net/ethernet/intel/igbvf/vf.c
>> +++ b/drivers/net/ethernet/intel/igbvf/vf.c
>> @@ -1,6 +1,8 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   /* Copyright(c) 2009 - 2018 Intel Corporation. */
>>   
>> +#include <linux/etherdevice.h>
>> +
>>   #include "vf.h"
>>   
>>   static s32 e1000_check_for_link_vf(struct e1000_hw *hw);
>> @@ -131,11 +133,18 @@ static s32 e1000_reset_hw_vf(struct e1000_hw *hw)
>>   		/* set our "perm_addr" based on info provided by PF */
>>   		ret_val = mbx->ops.read_posted(hw, msgbuf, 3);
>>   		if (!ret_val) {
>> -			if (msgbuf[0] == (E1000_VF_RESET |
>> -					  E1000_VT_MSGTYPE_ACK))
>> +			switch (msgbuf[0]) {
>> +			case E1000_VF_RESET | E1000_VT_MSGTYPE_ACK:
>>   				memcpy(hw->mac.perm_addr, addr, ETH_ALEN);
>> -			else
>> +				break;
>> +
>> +			case E1000_VF_RESET | E1000_VT_MSGTYPE_NACK:
>> +				eth_zero_addr(hw->mac.perm_addr);
>> +				break;
>> +
>> +			default:
>>   				ret_val = -E1000_ERR_MAC_INIT;
>> +			}
>>   		}
>>   	}
>>   
>> -- 
>> 2.38.1
>>
