Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9A23195A2
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 23:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBKWNz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 17:13:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbhBKWNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 17:13:52 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B05A6C061574
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 14:13:12 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id p15so6543029ilq.8
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 14:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iBM566jUnLoNer/PlbbYqSn7tzHFIOh+h2FDEN10sK4=;
        b=hNvHE/S0dkEZLgiY6v21eQTWd2ImcQLsCSNdtPi4tZtNvVFfJu8I656veFIyhvjJrU
         FCXXOhIyKFSgzlycGmKwsF+jisKqCQxz7NhcIRmhDqOSpJi1WKWBMEMKyfElgjYNK8Ba
         aADJfK/W67rD6JQG9A9lF+oPRKdgBkGN4UF8REzpO49c5qpXqs5I7LF/58Q9xRu7UqYW
         e7f5Axv3ftOKHx6qyjhuFeS1wHAHcN2IMsfm3lpVe5Qhs5YbV/K5zHSWJZmTP+pjQSsh
         kFzXqL1VI4xvq+JY8x4a+fQFedSHDb+fIvPsYLjZCI3tE/c/e4dVJywjVCaEeSdjYebV
         ja7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iBM566jUnLoNer/PlbbYqSn7tzHFIOh+h2FDEN10sK4=;
        b=Fo7IEK0GQFUjNbd3f02RFt3ghcGnHfmTUHOewGBXZrZbMVu1hBldg8Hdd40aJm93tZ
         77Te2Pnzx/1qnYGQVly9oOJV90CinCQp9wvMF3joE6A28KW4pHdcK5H6WqxgnG2rw4bD
         FjQkGWIUEfOEDmlOncDIDwpvfiyVutHdqjSWD4ieRrxZ4EiGHsjfCNVMAHRtsSLzl5EF
         b2fC2F2OMOoENKu7J++7OV7GSdBmxSEK5Ss6iR/jvDMGTX4t3xk2zmhAQMIHaRrOfY+G
         9YAOOIu42wTWGEeT3qZGGGJ06L7g83INxxnddbICuvPgOEbV6Zw0nQUtnbYUC1aty7QA
         dUzw==
X-Gm-Message-State: AOAM533ju6c20dbWeAnfjBb4Vv3DwxU3djFl2ekN9OkD93k+l0ayXbIR
        HGc5dt4Jw0U7vMbeDtw5Ixs3vQ==
X-Google-Smtp-Source: ABdhPJyFKHsCJ+HuaW7EM369pvPBHo1ZSsL/FA1Ccgrw76WGTSslrGv1PRYh2o0wfowt360MDsOjEg==
X-Received: by 2002:a92:cd8e:: with SMTP id r14mr166799ilb.77.1613081592158;
        Thu, 11 Feb 2021 14:13:12 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d2sm3244085ilr.66.2021.02.11.14.13.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Feb 2021 14:13:11 -0800 (PST)
Subject: Re: [PATCH v2 net-next 2/5] net: ipa: don't report EPROBE_DEFER error
To:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210211211927.28061-1-elder@linaro.org>
 <20210211211927.28061-3-elder@linaro.org>
 <b1824bb1-5e17-7e5c-98e4-9249fbb1188a@gmail.com>
From:   Alex Elder <elder@linaro.org>
Message-ID: <b342bbe2-7031-1cc1-6abf-55431f123f5f@linaro.org>
Date:   Thu, 11 Feb 2021 16:13:10 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <b1824bb1-5e17-7e5c-98e4-9249fbb1188a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/11/21 4:11 PM, Heiner Kallweit wrote:
> On 11.02.2021 22:19, Alex Elder wrote:
>> When initializing the IPA core clock and interconnects, it's
>> possible we'll get an EPROBE_DEFER error.  This isn't really an
>> error, it's just means we need to be re-probed later.
>>
>> Check the return code when initializing these, and if it's
>> EPROBE_DEFER, skip printing the error message.
>>
>> Signed-off-by: Alex Elder <elder@linaro.org>
>> ---
>>   drivers/net/ipa/ipa_clock.c | 12 ++++++++----
>>   1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
>> index 354675a643db5..238a713f6b604 100644
>> --- a/drivers/net/ipa/ipa_clock.c
>> +++ b/drivers/net/ipa/ipa_clock.c
>> @@ -1,7 +1,7 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   
>>   /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
>> - * Copyright (C) 2018-2020 Linaro Ltd.
>> + * Copyright (C) 2018-2021 Linaro Ltd.
>>    */
>>   
>>   #include <linux/refcount.h>
>> @@ -68,8 +68,9 @@ static int ipa_interconnect_init_one(struct device *dev,
>>   	if (IS_ERR(path)) {
>>   		int ret = PTR_ERR(path);
>>   
>> -		dev_err(dev, "error %d getting %s interconnect\n", ret,
>> -			data->name);
>> +		if (ret != -EPROBE_DEFER)
>> +			dev_err(dev, "error %d getting %s interconnect\n", ret,
>> +				data->name);
>>   
> 
> You may want to use dev_err_probe() here.

Great suggestion, I haven't used that before.

I will post v3 with that suggested change,
tomorrow morning.

Thanks!

					-Alex

>>   		return ret;
>>   	}
>> @@ -281,7 +282,10 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
>>   
>>   	clk = clk_get(dev, "core");
>>   	if (IS_ERR(clk)) {
>> -		dev_err(dev, "error %ld getting core clock\n", PTR_ERR(clk));
>> +		ret = PTR_ERR(clk);
>> +		if (ret != -EPROBE_DEFER)
>> +			dev_err(dev, "error %d getting core clock\n", ret);
>> +
>>   		return ERR_CAST(clk);
>>   	}
>>   
>>
> 

