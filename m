Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884EC6BF291
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCQUav (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:30:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbjCQUat (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:30:49 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC36F3B641
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:30:15 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id f17-20020a9d7b51000000b00697349ab7e7so3520268oto.9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 13:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679084999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSnXgkqDQaSk25uqOjvfuycMfRWL/vNC8sOZdDRBA9s=;
        b=0uOXPoTsPILyT9u0V6iIoPEdzgOFLGg0ICXKqPmlUZQxJwNo4kPlJjG5t+v9GEePtT
         zWj14Ko8qpBij7AGJtfSbBnS8dqECMRo2bvskR0ZLbDYpU306kphg7CudHlpesfcbMR6
         cXjdKrrtjQW6pfNEwSkDEzwZpcETX+wRtST63bbxU1Vwlw11KOYJkep/8xqpGYgEBPVk
         KWivdIDkO9YNPfqT2Y3ySYf4m6PjTuXfdOANUGylV9H13I73dgt/4ZiRA/FOPcIZH7ld
         FGqXYV2LDKnHu8n3/Y8Bk2fuW7/cY3kdTcXP6BX7K3+9ME2kfCLLHZMyNwunV/akZPtA
         pgJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679084999;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TSnXgkqDQaSk25uqOjvfuycMfRWL/vNC8sOZdDRBA9s=;
        b=ue+yfmmWCrtW2Cn8dUS3ROQwdVKEvQrxRAlnEhDSBR4gKKvMNeQBPH2svrWG4LdXrI
         SHum7UOwmD6eu+k3OACI+5u/2e0LT8AvuQ/5LK7ZJFm5vsy2n6HwEpjgc4dtmiyYHRJ0
         yKVyITQLacIRiz1rsnxCiKKb99dn2ceU0HPkJx09WkkFz0SRaXI6yRgV0lceG7STSeev
         bTQ4pgUmqbwgV2zS0VEcnwMZCckPlNVgtJjH7E3L0FiIjLe9vzmmyaT1F2tqWTxPo0kb
         MWtGrUgQjQE/RTR9A403YS0iTvRF+YqJhSkmLzhAB6HbHO9UqBqcyIF7+XMVMPOCOe5Q
         /J4g==
X-Gm-Message-State: AO0yUKWAnWZeoXMxPawgLTjgNKEQfb3BqoQxuNHjgPIkbs19BbNDXPYQ
        vhIDgaz7wSFq8HW8L5aIVek5ZHBd7bus4zny7o4=
X-Google-Smtp-Source: AK7set/LAfQ9bVKUeYCGTf4fz++msyupbWVT6HE41uUQHb7lsyl+dJ7229g1uJnHmdwnzyayCxeqcg==
X-Received: by 2002:a05:6830:12cc:b0:693:d927:645e with SMTP id a12-20020a05683012cc00b00693d927645emr477110otq.6.1679084999422;
        Fri, 17 Mar 2023 13:29:59 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:10c1:4b9b:b369:bda2? ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id j25-20020a9d7f19000000b006864c8043e0sm1330848otq.61.2023.03.17.13.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 13:29:59 -0700 (PDT)
Message-ID: <6f09e5c0-9bee-3f98-bdc4-abd9adade9c2@mojatatu.com>
Date:   Fri, 17 Mar 2023 17:29:55 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v3 1/4] net/sched: act_pedit: use extack in 'ex'
 parsing errors
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230317195135.1142050-1-pctammela@mojatatu.com>
 <20230317195135.1142050-2-pctammela@mojatatu.com>
 <ZBTMj7DCCTQaEOCi@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZBTMj7DCCTQaEOCi@corigine.com>
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

On 17/03/2023 17:24, Simon Horman wrote:
> Hi Pedro,
> 
> On Fri, Mar 17, 2023 at 04:51:32PM -0300, Pedro Tammela wrote:
>> We have extack available when parsing 'ex' keys, so pass it to
>> tcf_pedit_keys_ex_parse and add more detailed error messages.
> 
> This part looks good.
> 
>> While at it, remove redundant code from the 'err_out' label code path.
> 
> But I think it would be better to do one thing at a time.
> 
>>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> ---
>>   net/sched/act_pedit.c | 20 ++++++++++----------
>>   1 file changed, 10 insertions(+), 10 deletions(-)
>>
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index 4559a1507ea5..cd3cbe397e87 100644
>> --- a/net/sched/act_pedit.c
>> +++ b/net/sched/act_pedit.c
>> @@ -35,7 +35,7 @@ static const struct nla_policy pedit_key_ex_policy[TCA_PEDIT_KEY_EX_MAX + 1] = {
>>   };
>>   
>>   static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>> -							u8 n)
>> +							u8 n, struct netlink_ext_ack *extack)
>>   {
>>   	struct tcf_pedit_key_ex *keys_ex;
>>   	struct tcf_pedit_key_ex *k;
>> @@ -56,25 +56,25 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>>   		struct nlattr *tb[TCA_PEDIT_KEY_EX_MAX + 1];
>>   
>>   		if (!n) {
>> -			err = -EINVAL;
>> +			NL_SET_ERR_MSG_MOD(extack, "Can't parse more extended keys than requested");
>>   			goto err_out;
>>   		}
>> +
>>   		n--;
>>   
>>   		if (nla_type(ka) != TCA_PEDIT_KEY_EX) {
>> -			err = -EINVAL;
>> +			NL_SET_ERR_MSG_MOD(extack, "Unknown attribute, expected extended key");
>>   			goto err_out;
>>   		}
> 
> perhaps I'm missing something terribly obvious but what I see is that
> this code sits in a loop and the initial value of err is -EINVAL.
> `
>>   
>> -		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
>> -						  ka, pedit_key_ex_policy,
>> -						  NULL);
>> +		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
>> +						  pedit_key_ex_policy, extack);
>>   		if (err)
>>   			goto err_out;
> 
> If nla_parse_nested_deprecated() succeeds then, here, err == 0
> 
>>   
>>   		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
>>   		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
>> -			err = -EINVAL;
>> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
>>   			goto err_out;
> 
> If, f.e.,  this fails the code will now branch to err_out with err == 0.
> Which will return ERR_PTR(err);
> 

Correct, I sent this change too fast and should have been more thorough.
I will try to be more careful in the future.
Thanks again!

