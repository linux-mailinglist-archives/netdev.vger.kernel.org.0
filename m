Return-Path: <netdev+bounces-8670-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E3DA1725209
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2078828112D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 02:20:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B2E264F;
	Wed,  7 Jun 2023 02:20:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF937C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:20:37 +0000 (UTC)
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3978A1732;
	Tue,  6 Jun 2023 19:20:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 41be03b00d2f7-53fbb3398c8so554587a12.1;
        Tue, 06 Jun 2023 19:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686104435; x=1688696435;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BKFbnWBQ9QpASxiIB9KMxVKCkkxXRNBDMQ/+Dbfr93o=;
        b=bLdnD8t+AAulFU42EWbzhLFLnbvdsabwOChyzIgJCaKNY781zyWQuuaUXslvOla9py
         fvYLSooxN6izeXYk0Xp1460TFjGc3W8uEd9cdciEYigkAiVhf8B0lq28mxWnvl3/aSuB
         YFECfesJxGfkUKWBvYATOTSilomfJ6Qv7NOL81p2/nY6TXmk1N3ADqu7L+BhJ59CkCsD
         rT3vclse2ncSq5zwdCtmB8xcYxi4N14ht2+9T1WsbALtMjd1OJSwjp0r8CWEV0yDQJbH
         VQl5tnDHg5fI7xIqmIep/wg7+ki2cZXfbQ13wPDmSWr7YSZtuN9cytH69DQkxdTDfVzZ
         idpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686104435; x=1688696435;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BKFbnWBQ9QpASxiIB9KMxVKCkkxXRNBDMQ/+Dbfr93o=;
        b=E22YYT4RL3hriZ/Dn8uOZl+NrR/lY/OyxYqxXJ6FNEqeKQ7+0tfZZjDzXj21+pBw6f
         GyhyR9MzX8Os4GOee2Oc6CNCVkSKKAo9vqUYiHWdYgZkzcGq9FRSEyQyX8x2EpuGEcOe
         McrsWxG2Cc3PzaTGLfvOxnNWowJx9aFYdQQM6CKWPDjZL6tcKXhpB2v4J29SntBYle05
         BwLRl/7VyAdMLxnrd83OPk/DP2QGwtbZ+H41mdw1T4zrDc9k/8H41fTqAX7R1j39k8ld
         WgmWaWLd8qX28CajweOaCxxCclrsTOk5vxx05eh8k8LW2JPORz4Aw4838G4NNy4qe0vz
         Nkkg==
X-Gm-Message-State: AC+VfDwzZEwwNR8Od28CzbkyW8NoVnks+IkmjEkwsuOXgWkS3rqGoGq8
	Xq3JyArLxurCE7w+C4owQQZYa2gdo0ubXytO
X-Google-Smtp-Source: ACHHUZ6PMh11kX98P/Kfl5fQa14Zzk89kRsNBaUn8WW/kQiojy8G+ZUKG7h6Y9JHtG3upBOMDbefRA==
X-Received: by 2002:a17:903:32d1:b0:1ac:6b92:a775 with SMTP id i17-20020a17090332d100b001ac6b92a775mr4259202plr.6.1686104434650;
        Tue, 06 Jun 2023 19:20:34 -0700 (PDT)
Received: from [127.0.0.1] ([2404:c140:1f03::caf2])
        by smtp.gmail.com with ESMTPSA id z11-20020a1709028f8b00b001b1f991a4e2sm5689684plo.20.2023.06.06.19.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 19:20:33 -0700 (PDT)
Message-ID: <7a5e7377-4931-36e3-4102-8fcb1f7a81e8@gmail.com>
Date: Wed, 7 Jun 2023 10:20:28 +0800
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
Content-Language: en-US
To: Larysa Zaremba <larysa.zaremba@intel.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230605070158.48403-1-hbh25y@gmail.com>
 <ZH70I+yV66OpMxbo@lincoln>
From: Hangyu Hua <hbh25y@gmail.com>
In-Reply-To: <ZH70I+yV66OpMxbo@lincoln>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/2023 16:53, Larysa Zaremba wrote:
> On Mon, Jun 05, 2023 at 03:01:58PM +0800, Hangyu Hua wrote:
>> try_module_get can be called in tcf_proto_lookup_ops. So if ops don't
>> implement the corresponding function we should call module_put to drop
>> the refcount.
>>
> 
> Code seems reasonable. But commit message is pretty hard to understand.
> Please, replace "corresponding" with "required".
> Also change the first sentence, do not use "can". From what I see, successful
> execution of tcf_proto_lookup_ops always means we now hold reference to module.
> 
> CC me in v2, I'll give you Reviewed-by.
> 

I apologize for my incorrect English expression. I will send a v2 later.

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

