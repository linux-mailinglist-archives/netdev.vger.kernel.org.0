Return-Path: <netdev+bounces-8260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AF42A72351A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 04:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 232FA1C20E1F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 02:14:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1845391;
	Tue,  6 Jun 2023 02:14:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E680C7F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:14:02 +0000 (UTC)
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85EBC11D;
	Mon,  5 Jun 2023 19:13:53 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 41be03b00d2f7-5429d91efc2so549757a12.0;
        Mon, 05 Jun 2023 19:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686017633; x=1688609633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GK3SH+ZRgMM3hnQg2lJiFOx+Ehf48Mzwt4h/2p4dLtA=;
        b=od6j8MHiM34MxiAmu/7VpTdynYLAAW+dMGjCcMBFWgPNRZKANQ64sDInmd3TM8FHX+
         +aHwrfDrm9mPt/VGJRnjKe7u2zonavLCUhZbuVWdov5BnAQ7TbpmNLsHx7UIOLtu9edy
         Wj80xJuJFpWQYKsb6uYiZRiCuS3I/vgYSoofBRhbc0rgfxnxO2XEwBaMaXVhhz81jQZv
         ZEXgNe1cu/QI77ritG/hM3R2Ict2mRyzes1QZ4MFg5m8rSPpzv4D7DdRHG79h22eczGN
         FTAHrig4R6hA5Fwu+fRuQHGm5n6E0ie0drKGfFmTIr+4dQ1zuhOX2bSxC5+JF+babEI/
         XL+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686017633; x=1688609633;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GK3SH+ZRgMM3hnQg2lJiFOx+Ehf48Mzwt4h/2p4dLtA=;
        b=Z1Tbr5dbaYKWS0nwpqHtzpLDK6/DnJyFUP0kJtia9gJDh1mAkFfSScQnNXOKpGanyb
         kvt4E1PqyXZo7o7j6A87ywCnYpQW9ZN4X1Z8cb4qJ1KVOg8HsvedbMyYJs18ZSiabT3v
         YAbIeAV1ITSTEQ9K+/ljRwmeoGd4h0wt+T8xovmWnXgPknPjl5TM2CboxVuCrTBIqvux
         pzHuT7Ly2ooD0lVVc/S4PDupGf4xVhpJSXtDEE0DBqDLKxK8gN1O3VHUyYLyF/IEK4kk
         /X8M0fDgx3KWnHzlJYrlDCCspQDxYlUwb3lS9AdqToTKe8LtZuE17v2l90eTvhG+jix0
         NSOw==
X-Gm-Message-State: AC+VfDyVbRF8DmNx5wxOECP4FDaMo0MQ+nY4xpm4ELq5mpFixflqu2j6
	1y1yU6BF3YgGkg91Y53NwJg=
X-Google-Smtp-Source: ACHHUZ4AgqcoZQHQ9vBMlx5Pm4Vzq8IAyRRH9N50lXIEBRai3htmt99Xy8nuKv0x0CXxVsC5A/sbjg==
X-Received: by 2002:a17:902:e751:b0:1ae:1364:6086 with SMTP id p17-20020a170902e75100b001ae13646086mr923553plf.2.1686017632804;
        Mon, 05 Jun 2023 19:13:52 -0700 (PDT)
Received: from [127.0.0.1] ([2404:c140:1f03::caf2])
        by smtp.gmail.com with ESMTPSA id u10-20020a170902e80a00b001aadd0d7364sm7225788plg.83.2023.06.05.19.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Jun 2023 19:13:52 -0700 (PDT)
Message-ID: <1626a8b8-ae7a-a110-44a1-24c8f600822a@gmail.com>
Date: Tue, 6 Jun 2023 10:13:44 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
To: Simon Horman <simon.horman@corigine.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230605070158.48403-1-hbh25y@gmail.com>
 <ZH3Vju3D3KCKAkCO@corigine.com>
Content-Language: en-US
From: Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <ZH3Vju3D3KCKAkCO@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/6/2023 20:31, Simon Horman wrote:
> On Mon, Jun 05, 2023 at 03:01:58PM +0800, Hangyu Hua wrote:
>> try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
>> implement the corresponding function we should call module_put to drop
>> the refcount.
> 
> Hi Hangyu Hua,
> 
> Is this correct even if try_module_get() is
> not called via tcf_proto_lookup_ops() ?
> 

tcf_proto_lookup_ops will return error if try_module_get() is not called 
in tcf_proto_lookup_ops(). I am not sure what you mean?

Thanks,
Hangyu

>> Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
>> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
>> ---
>>   net/sched/cls_api.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
>> index 2621550bfddc..92bfb892e638 100644
>> --- a/net/sched/cls_api.c
>> +++ b/net/sched/cls_api.c
>> @@ -2952,6 +2952,7 @@ static int tc_chain_tmplt_add(struct tcf_chain *chain, struct net *net,
>>   		return PTR_ERR(ops);
>>   	if (!ops->tmplt_create || !ops->tmplt_destroy || !ops->tmplt_dump) {
>>   		NL_SET_ERR_MSG(extack, "Chain templates are not supported with specified classifier");
>> +		module_put(ops->owner);
>>   		return -EOPNOTSUPP;
>>   	}
>>   
>> -- 
>> 2.34.1
>>
>>

