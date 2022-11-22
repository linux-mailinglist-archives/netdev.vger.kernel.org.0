Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA15D633D61
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 14:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233607AbiKVNRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 08:17:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiKVNRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 08:17:49 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67B1E95AE
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:17:46 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id b185so14330938pfb.9
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 05:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Px5PFcbBcn5kKKxwkSdASImn/3PTZhLKqsWw3Vdjrd0=;
        b=pkZg3MALBkgNlhuxmzZN3kNu35Fe4iW2g/ojUC2OxXPVlBzOxvsSNsuuIMtoQQbITo
         daP+yIqfhkBvEZro+AZ01RV66RFbYcLlfrgeO0/HRtwJLT4ZwM4V3RUMI5LAEaot+bsI
         uf8NhZSrHdqyX5oC7vGlZYtGFOobRCvW704aAmSk3VLUy6pB2l94GyKe/uXo5KKY+oud
         /bZrK0Qlum3iyJYyWxENMejzQwY5ICDUs3rOuu5m4OAXuLa7oWw9SvuwFBCW5k9Oh3KP
         dwPliZyl02ZQ7rSGkTfrsrhCA2NSDaTBRjnjo7ekwHZ3dva4+lJ1jcsqMGJ4cXMPCjuy
         jhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Px5PFcbBcn5kKKxwkSdASImn/3PTZhLKqsWw3Vdjrd0=;
        b=WgrvRhWMGDrPjRpHi0SOE+UB0lyfzx+BrwyE8n5PnYSgOGAGt0TrpuxQALfm5fQwNJ
         zIvFwd7mXUYJHYuSpTkFE5J83cYgt7tDnmtgKRmf1yJSiFBmWjOmygmfRkgm7tmh0fKl
         vCZ5fO7DMCekExCABUfrkPnrq6Ib3kO1GIsO+kvR79gclOJ9qW3RoZCvq/FwaCHEZ5cK
         Ry2HBYaA+etVBsxCbWsFOP5okrucFwIL4rGJfDzH5oTg5hzF36g0OcciPSSWuHnZfa8e
         H9ugl276QAA8Y0++MWrhYTuRYusTwQdqdMTdIMvRKmgZjPrzYs9DKXyS6ItkqJVPeVJG
         1oSw==
X-Gm-Message-State: ANoB5pmUzpvcI+gtc4rVS7mh3IAWye+MCpSnGg1egQLV/jtoBUj9p9Rp
        sW3FUQlorGEQmbbTPgtY106/Yene9AGuBQ==
X-Google-Smtp-Source: AA0mqf6V/B5zSapMpHlFVtbuZGXiZ1CptoqfnNyOiDaIdhdaBxM1kAuQPg9elHW5MRCOxE9RXq/7vg==
X-Received: by 2002:a05:6a00:2908:b0:56b:d738:9b with SMTP id cg8-20020a056a00290800b0056bd738009bmr4021107pfb.61.1669123065947;
        Tue, 22 Nov 2022 05:17:45 -0800 (PST)
Received: from ?IPV6:2400:4050:c360:8200:8ae8:3c4:c0da:7419? ([2400:4050:c360:8200:8ae8:3c4:c0da:7419])
        by smtp.gmail.com with ESMTPSA id n10-20020a6563ca000000b0043a18cef977sm9123052pgv.13.2022.11.22.05.17.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Nov 2022 05:17:45 -0800 (PST)
Message-ID: <be5617fe-d332-447a-b836-bec9a6c6d42d@daynix.com>
Date:   Tue, 22 Nov 2022 22:17:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH] igb: Allocate MSI-X vector when testing
Content-Language: en-US
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
References: <20221122121312.57741-1-akihiko.odaki@daynix.com>
 <Y3y9dbBUYi5j3Qre@boxer>
From:   Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <Y3y9dbBUYi5j3Qre@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/22 21:15, Maciej Fijalkowski wrote:
> On Tue, Nov 22, 2022 at 09:13:12PM +0900, Akihiko Odaki wrote:
>> Allocate MSI-X vector when testing interrupts, otherwise the tests will
>> not work.
> 
> Hi,
> 
> can you say a bit more about why current code was broken? And also what is
> the current result of that ethtool test?
> 
> Also this is a fix, please provide Fixes: tag and route it to net tree.

Hi, I have just sent v2, please check it out.

Regarding Fixes: tag, I couldn't tell when the bug appeared. The 
modified function, igb_intr_test() lacked the interrupt allocation code 
from the start. My guess is that some code in igb_reset() or after the 
function had code to allocate interrupts in the past and later removed. 
But I couldn't find such code.

Regards,
Akihiko Odaki

> 
>>
>> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
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
