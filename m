Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB366BF190
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:15:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbjCQTPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCQTPt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:15:49 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B84AE2534
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 12:15:12 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id bj30so4551451oib.6
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 12:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679080509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pxH2gkiMT3Z9lCO6Y4T35qefz8enLtiDaziARNnbtNc=;
        b=NxGuql7swpWSbZZGQj9CE6Y+/O0/MhxrZD/SHySTG0pr0lQfOKMrEl6NFzqWU3LHak
         CduM+BgwFcgpgX2JEoWq+gDaEhz0LGVjRwsrbdnx/BOkzIIopToSLjApILyoIOBI/Uxy
         MXk1Nv0kw+gyktPakP4wrzizw2+7qzI/auWUp/hgamHNmJdeuo/dJXSz2n08HMXwQilI
         QkudsjIIrd7UlGxXK46YNhn5EghdeiuA6GC+yb7p7MZ2GtuJkLkq6NwqEuq8+qDko5f0
         Q/QkjlYL7KhWnRJI5vGpUkGtdl+cPmgflFQ64pmdroPeNfRJbHHkckUT9KnIxnu/aboV
         VXYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679080509;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxH2gkiMT3Z9lCO6Y4T35qefz8enLtiDaziARNnbtNc=;
        b=e6WSEg1Hs8KUEQVq9D0IrJOovnOofLxxwiMOjF6WdEYq+7t/pYFD6FlmfIdYMyPyc/
         TuyhNMlu9mj/yAz+EKEsj6Dtk3MU0wBVR1+8ijiijY/hr/W4ZFzlDla+IAowyaduODT4
         AMt9MAAUKO3qqpJhPjtnqYURb54KH5b3KhVzzmOxAeYSC4/dkQjbuY5wb23NgUfYHnu9
         Dyv2esbc3rLMUTjkRVKfAj7fAo3icRVmmIiXhXN6EhvwNVQyGZLW0JKq7YJ8H4M4UA/7
         88MYIb9U5xokTqweRlJFnm1m6+fVmQ5tKkNfXj8i1Em5eZ8Q0QlIehIYaBLZcRAEUeP5
         AzRw==
X-Gm-Message-State: AO0yUKVR3tPUJTlyydmDTlNJnqW0xPsDwkk9dUhAu/lTQM34gjkdOn8E
        eb4kDajKSSiQAOWSkS9V3g8F6w==
X-Google-Smtp-Source: AK7set8lZ1ghNcyYPR44u7ab3D34dczq5fc/qO4lwMQJJIinUI5FY6cTa08cOOjACsj5ZtmBSLLfRg==
X-Received: by 2002:a54:4518:0:b0:37f:7770:4c01 with SMTP id l24-20020a544518000000b0037f77704c01mr5459992oil.28.1679080509084;
        Fri, 17 Mar 2023 12:15:09 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:10c1:4b9b:b369:bda2? ([2804:14d:5c5e:4698:10c1:4b9b:b369:bda2])
        by smtp.gmail.com with ESMTPSA id r130-20020acaf388000000b00383f58e7e95sm1178894oih.17.2023.03.17.12.15.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 12:15:08 -0700 (PDT)
Message-ID: <750dc9d1-4971-a0f9-4a97-a10a55b5256f@mojatatu.com>
Date:   Fri, 17 Mar 2023 16:15:03 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 1/4] net/sched: act_pedit: use extack in 'ex'
 parsing errors
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230314202448.603841-1-pctammela@mojatatu.com>
 <20230314202448.603841-2-pctammela@mojatatu.com>
 <ZBHpmU+E0gXHRjB2@corigine.com>
Content-Language: en-US
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZBHpmU+E0gXHRjB2@corigine.com>
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

On 15/03/2023 12:51, Simon Horman wrote:
> On Tue, Mar 14, 2023 at 05:24:45PM -0300, Pedro Tammela wrote:
>> We have extack available when parsing 'ex' keys, so pass it to
>> tcf_pedit_keys_ex_parse and add more detailed error messages.
>> While at it, remove redundant code from the 'err_out' label code path.
>>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> ---
>>   net/sched/act_pedit.c | 22 +++++++++++-----------
>>   1 file changed, 11 insertions(+), 11 deletions(-)
>>
>> diff --git a/net/sched/act_pedit.c b/net/sched/act_pedit.c
>> index 4559a1507ea5..be9e7e565551 100644
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
>>   
>> -		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX,
>> -						  ka, pedit_key_ex_policy,
>> -						  NULL);
>> +		err = nla_parse_nested_deprecated(tb, TCA_PEDIT_KEY_EX_MAX, ka,
>> +						  pedit_key_ex_policy, extack);
>>   		if (err)
>>   			goto err_out;
> 
> err_out will return ERR_PTR(-EINVAL).
> I.e. the value of is not propagated.
> Are you sure it is always -EINVAL?

Good catch, I will propagate the error.

> 
>>   
>>   		if (!tb[TCA_PEDIT_KEY_EX_HTYPE] ||
>>   		    !tb[TCA_PEDIT_KEY_EX_CMD]) {
>> -			err = -EINVAL;
>> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit missing required attributes");
>>   			goto err_out;
>>   		}
>>   
>> @@ -83,7 +83,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>>   
>>   		if (k->htype > TCA_PEDIT_HDR_TYPE_MAX ||
>>   		    k->cmd > TCA_PEDIT_CMD_MAX) {
>> -			err = -EINVAL;
>> +			NL_SET_ERR_MSG_MOD(extack, "Extended Pedit key is malformed");
>>   			goto err_out;
>>   		}
>>   
>> @@ -91,7 +91,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>>   	}
>>   
>>   	if (n) {
>> -		err = -EINVAL;
>> +		NL_SET_ERR_MSG_MOD(extack, "Not enough extended keys to parse");
>>   		goto err_out;
>>   	}
>>   
>> @@ -99,7 +99,7 @@ static struct tcf_pedit_key_ex *tcf_pedit_keys_ex_parse(struct nlattr *nla,
>>   
>>   err_out:
>>   	kfree(keys_ex);
>> -	return ERR_PTR(err);
>> +	return ERR_PTR(-EINVAL);
>>   }
>>   
>>   static int tcf_pedit_key_ex_dump(struct sk_buff *skb,
>> @@ -222,7 +222,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   	}
>>   
>>   	nparms->tcfp_keys_ex =
>> -		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
>> +		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys, extack);
>>   	if (IS_ERR(nparms->tcfp_keys_ex)) {
>>   		ret = PTR_ERR(nparms->tcfp_keys_ex);
>>   		goto out_free;
>> -- 
>> 2.34.1
>>

