Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504406B8058
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 19:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230115AbjCMSZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 14:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbjCMSZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 14:25:11 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D607260ABB
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:24:52 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-176d1a112bfso14706744fac.5
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 11:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1678731892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NvskvxnEgt1jVZHQCOShUEBE6+EoupeUdjLizfOxNyU=;
        b=m3m7hbLwBmSjoGNJ+WzW/dK61vU3qrLVbxQEaA8X5YTGu3GDRhymAzFTIn2ObJ0SOu
         m5XUpu8OcJbugKNqJukCqB0tIdPUA62m9S/CykzKiyDwGuM9RLbyDb9R2+ZPKPee2u/J
         4Bw1UJN7/pTRvF1TKG6lmKhOGIhhJ8XRonG34vL0wXOmRlm4vp0eej6zzZu1a2Zi8ES7
         N8C8/wGE7qRzmlxMgb7rxwFuopCLX/lyF4o+/TVuLqhNS3NSuCmPPgE+0wmgfH1gEwQG
         jwyvT9OSrqopDpJUYXGMqCnj7qvNVKn1pqzhaXvQlvipJr9WWWdY+er+YoDq6nqeqNyw
         ETyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678731892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NvskvxnEgt1jVZHQCOShUEBE6+EoupeUdjLizfOxNyU=;
        b=1D8kJkoK4XkTcIGOBsJgnwfE3S/eWHapdEurh5pakvEp0ggFEkgg+Jv1QGcnsCsoBx
         fCTx6PBfSZ3wJCxbnOownOy5R4WeOV0YeVkeZNniGH2ror19fcF8hVTt82eHgFPMWTVT
         VheJN61AIZZM3SKG9YvAPsDuO8e3auSzuUxxVoa6n/l8jL3pgUMYbt+PVGvWct7d8WCM
         muYDzziQraoBRribjP3pDqoD8EMfdYj8HbErXsbRQ4ttF5tuFY41nyjAvMtgmZtPU8jR
         JGTgghCER75874fMF5iID/1TwMhzTO1mRsu7Dy6FJ4L12Q0SU8V3SZ7hnXuVKL/2DX2r
         J5ig==
X-Gm-Message-State: AO0yUKVo8S+K7C1HNRlHiQ/TAz3PHXno3QCHnv5isUcVVY3ZEYA6U3is
        N19FoPVEKLrX7V62JIqmxqPrTA==
X-Google-Smtp-Source: AK7set948xn+TIEumUdjTPjVEQ8hLVLNEDd/bG3rCUtpJyO3mlDug8UYSTbo4SJjrZxlIHEPdlqiNg==
X-Received: by 2002:a05:6870:f20a:b0:177:9467:6e17 with SMTP id t10-20020a056870f20a00b0017794676e17mr5575052oao.44.1678731892226;
        Mon, 13 Mar 2023 11:24:52 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:49ae:9f38:271d:6240? ([2804:14d:5c5e:4698:49ae:9f38:271d:6240])
        by smtp.gmail.com with ESMTPSA id g5-20020a056870a70500b00172721f6cd5sm264467oam.16.2023.03.13.11.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 11:24:51 -0700 (PDT)
Message-ID: <dbdb0bf7-2bc6-4002-d7f2-e561d6120856@mojatatu.com>
Date:   Mon, 13 Mar 2023 15:24:47 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 3/3] net/sched: act_pedit: rate limit datapath
 messages
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230309185158.310994-1-pctammela@mojatatu.com>
 <20230309185158.310994-4-pctammela@mojatatu.com>
 <ZAs83FgjdfizV3Nh@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZAs83FgjdfizV3Nh@corigine.com>
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

On 10/03/2023 11:21, Simon Horman wrote:
> On Thu, Mar 09, 2023 at 03:51:58PM -0300, Pedro Tammela wrote:
>> Unbounded info messages in the pedit datapath can flood the printk ring buffer quite easily
>> depending on the action created. As these messages are informational, usually printing
>> some, not all, is enough to bring attention to the real issue.
> 
> Would this reasoning also apply to other TC actions?

Hi Simon,

So far, the only action that has datapath pr_info() messages is pedit.
This seems like it comes from the old days, according to git.

> 
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> ---
>>   net/sched/act_pedit.c | 17 +++++++----------
>>   1 file changed, 7 insertions(+), 10 deletions(-)
>>
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index e42cbfc369ff..b5a8fc19ee55 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
>> @@ -388,9 +388,8 @@ TC_INDIRECT_SCOPE int tcf_pedit_act(struct sk_buff *skb,
>>   		}
>>   
>>   		rc = pedit_skb_hdr_offset(skb, htype, &hoffset);
>> -		if (rc) {
>> -			pr_info("tc action pedit bad header type specified (0x%x)\n",
>> -				htype);
>> +		if (unlikely(rc)) {
> 
> Do you really need unlikely() here (and no where else?)

This case in particular is already checked in the netlink parsing code 
on create/update.
I was gonna delete the condition initially but then thought of hiding it 
under an unlikely branch.
As for the other branches, I didn't see much of a reason.

> 
>> +			pr_info_ratelimited("tc action pedit bad header type specified (0x%x)\n", htype);
>>   			goto bad;
>>   		}
>>   
> 
> ...

