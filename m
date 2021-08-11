Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC803E8BE7
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 10:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236156AbhHKIhc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 04:37:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhHKIh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 04:37:29 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766A5C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:37:06 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e19so1702494pla.10
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 01:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=+yiW5kHotNOIsCP88n2IGTFzXnmxVlt5DhvJ4aiUAJ8=;
        b=ADgs2+HHUb6cc2yw9nwe81BuS/VggS/Qhyg7o8RRJt2KwJn1NHpmyc1GFtv5kHKHpV
         61OnNwVjZJi3+B0f+mUO1Fye6Gxwxc84zWK7Jrhk41VNL/s1N7aYF6biriwNbdmqamhA
         +hTv3fDCCQdQRwYNekQK7sRIG8bkUsc9T4mrzpOcUjlQgKTMX9E3BLAG/GkvKAArJsp+
         kA34hwoXo29cg64aDW0/Ad6kx/wlGGIoRfgqV4xVfXwdSsJNfKtryicw3z6J2TE6u0WZ
         wv6DejdcjXjPjkWA36A7J4E+N3nanlLPpOH9ckVDCrVMuZrg7eCI27SUWYti7T2GBgkR
         bEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=+yiW5kHotNOIsCP88n2IGTFzXnmxVlt5DhvJ4aiUAJ8=;
        b=deDkSGvaFCgVE8uQjyifjtOtL/xGSygB12tSascMboF7ZDBlCNiSzPmmwBae3Kd5cV
         wbV89Pf3bEuYtDMUbyQp7UTPSwKrssr7KZbfgJD0sFlpJrJzec8ibmmaFKs6ccpk7H5o
         XPph3jOcSZqP2JZN7mMiwkQxE3Ck7hUcI5N60X4YK0IfACjT+sRuqaR+Z+yaGWXwDeHw
         wTmpIf90xSdtb5DbweWSipwJXfuVkLyzFYcFJpgNXwX8SrH9b2F8l9kKCbRR52GCXh/A
         6ME80crc3IHm4+3ksbBPxCCuXKfeUbh8LjlfaVDd0GHaJY8cARbyN+R59IEq+jbq4Idu
         d4jA==
X-Gm-Message-State: AOAM531e0qhpCgq0Ef5XEmirAnp8FTTCCybId7/1sjQjk8Z6UxOa+gpf
        wKWAIR2Yzeh9bElrPMRBqHQ=
X-Google-Smtp-Source: ABdhPJz57biCNmaV9Sj3JbA6WLm9ACJx0ybtEPGhwEU82uA72fT8EW9Mbqi9OY2mw5Q2pNlVCt8S4Q==
X-Received: by 2002:a17:902:6507:b029:12d:2292:f750 with SMTP id b7-20020a1709026507b029012d2292f750mr13725680plk.54.1628671025978;
        Wed, 11 Aug 2021 01:37:05 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id j1sm2212141pfc.97.2021.08.11.01.37.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 01:37:05 -0700 (PDT)
Subject: Re: [PATCH] net:sched fix array-index-out-of-bounds in taprio_change
To:     Eric Dumazet <eric.dumazet@gmail.com>, vinicius.gomes@intel.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     Haimin Zhang <tcs_kernel@tencent.com>
References: <1628658609-1208-1-git-send-email-tcs_kernel@tencent.com>
 <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
From:   Haimin Zhang <tcs.kernel@gmail.com>
Message-ID: <e965fed3-89c3-ff58-a678-dd715a2b9fcd@gmail.com>
Date:   Wed, 11 Aug 2021 16:36:57 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <303b095e-3342-9461-16ae-86d0923b7dc7@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2021/8/11 15:44, Eric Dumazet 写道:
> 
> 
> On 8/11/21 7:10 AM, tcs.kernel@gmail.com wrote:
>> From: Haimin Zhang <tcs_kernel@tencent.com>
>>
>> syzbot report an array-index-out-of-bounds in taprio_change
>> index 16 is out of range for type '__u16 [16]'
>> that's because mqprio->num_tc is lager than TC_MAX_QUEUE,so we check
>> the return value of netdev_set_num_tc.
>>
>> Reported-by: syzbot+2b3e5fb6c7ef285a94f6@syzkaller.appspotmail.com
>> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>
>> ---
>>   net/sched/sch_taprio.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
>> index 9c79374..1ab2fc9 100644
>> --- a/net/sched/sch_taprio.c
>> +++ b/net/sched/sch_taprio.c
>> @@ -1513,7 +1513,9 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
>>   	taprio_set_picos_per_byte(dev, q);
>>   
>>   	if (mqprio) {
>> -		netdev_set_num_tc(dev, mqprio->num_tc);
>> +		err = netdev_set_num_tc(dev, mqprio->num_tc);
>> +		if (err)
>> +			goto free_sched;
>>   		for (i = 0; i < mqprio->num_tc; i++)
>>   			netdev_set_tc_queue(dev, i,
>>   					    mqprio->count[i],
>>
> 
> When was the bug added ?
> 
> Hint: Please provide a Fixes: tag
> 
> taprio_parse_mqprio_opt() already checks :
> 
> /* Verify num_tc is not out of max range */
> if (qopt->num_tc > TC_MAX_QUEUE) {
>      NL_SET_ERR_MSG(extack, "Number of traffic classes is outside valid range");
>      return -EINVAL;
> }
> 
> So what is happening exactly ?
> 
> 
> 
> 
syzkaller reported this problem,the log shows mqprio->count[16] is accessed.
here is the log
https://syzkaller.appspot.com/bug?id=3a3677d4e7539ec5e671a81e32882ad40b5f7b64

the added check logic is hurtlessness,and netdev_set_num_tc does have a 
return value.
