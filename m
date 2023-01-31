Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4577682F0A
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjAaOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230272AbjAaOUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:20:09 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D221516AD6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:20:07 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id bx13so7121412oib.13
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 06:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ozni4YehMCp2nCGPCf1Ml0KJztjqN0LYq6mkHJNnkes=;
        b=VFXkbcU68Xml1BxEvYdq+9PFm10aRbDcHME/EfcpGT+nV1BReSfop5soCor45Oagvc
         2nX6b2OL92CrQnUUa7FHYl09gY2+2rQ70if2o+2wEmoHc0OlIR2nOYR1ChjoqsVZrgnK
         /RZquZ00W/ijMwYNVCjnbp2WNxZQHsbFmgn59v9lmDpmh2owE42NGF6WByeHzFhZKx6L
         DyNom3tkR6+OYi8DHd/0U1LUvbwnMzSv78UnFdFGSu1hKkDv0xCEDUAuakbWnaPNCklZ
         J8KrLI9zbVg4f07fe7v/P2QN7u1Q+n7LohwMmmMOoWtOknzfbeGgTJYdOU0zUgHm+u4g
         Kqrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ozni4YehMCp2nCGPCf1Ml0KJztjqN0LYq6mkHJNnkes=;
        b=MrxlFEMUAaiAHYyN4pNJj+W7JsfPVEPF52yTNdOjoaV9GxFbtHoKZPuSA1KtR8CVIe
         OCt5e8WzSSsZ22ehAY9t9lLDD1VGnKDPGJVWwXFdpTSXpD5OboUVRacgRmDazuI5L6u2
         SreRF/OFAeVF1FBecWaP8bl0GXknfCoW2Vcmaby7M9x6XEnP+tbzgbQU7IwtzFcLifjz
         LP23vyCeOzZ/KYHjw70eAkNWIwnNKMBpsEKFJJEeRkmup98JITDLXNU1n4MkejfsepPD
         8wdhJTnOiS27UKDWa3ZpLOAwxJztAPhOwxetiDm/pa8FFnwXrVhFnKHzXWmk+hWLXghx
         iXTw==
X-Gm-Message-State: AO0yUKV2uITPBCVy3RG4D91xj9oPJZflYe7/DD9eXsueI+uQFtzySiA0
        AabjupFmjxLE4zYQOOH7LxNoTA==
X-Google-Smtp-Source: AK7set8sYEKDWaa6fNLB8uPFGQsjhA0HCC3UM4RzJMIasQ2ocXHMgW8+TkcWZspK+wcU2n5Agqfdpw==
X-Received: by 2002:aca:b7c2:0:b0:378:9cbc:9e56 with SMTP id h185-20020acab7c2000000b003789cbc9e56mr154881oif.38.1675174807088;
        Tue, 31 Jan 2023 06:20:07 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:1d86:b62f:e05b:126b? ([2804:14d:5c5e:4698:1d86:b62f:e05b:126b])
        by smtp.gmail.com with ESMTPSA id x4-20020a05680801c400b0036a97066646sm5823488oic.8.2023.01.31.06.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 06:20:06 -0800 (PST)
Message-ID: <bf8f3ae0-02e7-dae3-2b93-c7088db1a424@mojatatu.com>
Date:   Tue, 31 Jan 2023 11:20:02 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v4 1/2] net/sched: transition act_pedit to rcu
 and percpu stats
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
References: <20230130160233.3702650-1-pctammela@mojatatu.com>
 <20230130160233.3702650-2-pctammela@mojatatu.com>
 <Y9kLbylZSeSst01o@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <Y9kLbylZSeSst01o@corigine.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/01/2023 09:37, Simon Horman wrote:
[...]
>>   static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   			  struct nlattr *est, struct tc_action **a,
>>   			  struct tcf_proto *tp, u32 flags,
>> @@ -143,8 +154,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   	bool bind = flags & TCA_ACT_FLAGS_BIND;
>>   	struct nlattr *tb[TCA_PEDIT_MAX + 1];
>>   	struct tcf_chain *goto_ch = NULL;
>> -	struct tc_pedit_key *keys = NULL;
>> -	struct tcf_pedit_key_ex *keys_ex;
>> +	struct tcf_pedit_parms *oparms, *nparms;
>>   	struct tc_pedit *parm;
>>   	struct nlattr *pattr;
>>   	struct tcf_pedit *p;
>> @@ -181,18 +191,25 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   		return -EINVAL;
>>   	}
>>   
>> -	keys_ex = tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
>> -	if (IS_ERR(keys_ex))
>> -		return PTR_ERR(keys_ex);
>> +	nparms = kzalloc(sizeof(*nparms), GFP_KERNEL);
>> +	if (!nparms)
>> +		return -ENOMEM;
>> +
>> +	nparms->tcfp_keys_ex =
>> +		tcf_pedit_keys_ex_parse(tb[TCA_PEDIT_KEYS_EX], parm->nkeys);
>> +	if (IS_ERR(nparms->tcfp_keys_ex)) {
>> +		ret = PTR_ERR(nparms->tcfp_keys_ex);
>> +		goto out_free;
>> +	}
>>   
>>   	index = parm->index;
>>   	err = tcf_idr_check_alloc(tn, &index, a, bind);
>>   	if (!err) {
>> -		ret = tcf_idr_create(tn, index, est, a,
>> -				     &act_pedit_ops, bind, false, flags);
>> +		ret = tcf_idr_create_from_flags(tn, index, est, a,
>> +						&act_pedit_ops, bind, flags);
>>   		if (ret) {
>>   			tcf_idr_cleanup(tn, index);
>> -			goto out_free;
>> +			goto out_free_ex;
>>   		}
>>   		ret = ACT_P_CREATED;
>>   	} else if (err > 0) {
>> @@ -204,7 +221,7 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   		}
>>   	} else {
>>   		ret = err;
>> -		goto out_free;
>> +		goto out_free_ex;
>>   	}
>>   
>>   	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
>> @@ -212,68 +229,79 @@ static int tcf_pedit_init(struct net *net, struct nlattr *nla,
>>   		ret = err;
>>   		goto out_release;
>>   	}
>> +
>> +	nparms->tcfp_off_max_hint = 0;
>> +	nparms->tcfp_flags = parm->flags;
>> +
>>   	p = to_pedit(*a);
>>   	spin_lock_bh(&p->tcf_lock);
>>   
>> +	oparms = rcu_dereference_protected(p->parms, 1);
>> +
>>   	if (ret == ACT_P_CREATED ||
>> -	    (p->tcfp_nkeys && p->tcfp_nkeys != parm->nkeys)) {
>> -		keys = kmalloc(ksize, GFP_ATOMIC);
>> -		if (!keys) {
>> +	    (oparms->tcfp_nkeys && oparms->tcfp_nkeys != parm->nkeys)) {
>> +		nparms->tcfp_keys = kmalloc(ksize, GFP_ATOMIC);
>> +		if (!nparms->tcfp_keys) {
>>   			spin_unlock_bh(&p->tcf_lock);
>>   			ret = -ENOMEM;
>> -			goto put_chain;
>> +			goto out_release;
> 
> I'm a little unclear on why put_chain is no longer needed.
> It seems to me that there can be a reference to goto_ch held here,
> as was the case before this patch.

Correct, initially I thought it was assigned unconditionally after the 
for loop. I will restore it, thanks!

> 
>>   		}
>> -		kfree(p->tcfp_keys);
>> -		p->tcfp_keys = keys;
>> -		p->tcfp_nkeys = parm->nkeys;
>> +		nparms->tcfp_nkeys = parm->nkeys;
>> +	} else {
>> +		nparms->tcfp_keys = oparms->tcfp_keys;
> 
> I feel that I am missing something obvious:
> * Here oparms->tcfp_keys is assigned to nparms->tcfp_keys.
> * Later on there is a call to call_rcu(..., tcf_pedit_cleanup_rcu),
>    which will free oparms->tcfp_keys some time in the future.
> * But the memory bay still be accessed via tcfp_keys.
> 
> Is there a life cycle issue here?

Correct, this is wrong.
I got the wrong impression we could avoid the memory allocation in the 
update case.


> 
>> +		nparms->tcfp_nkeys = oparms->tcfp_nkeys;
>>   	}
>> -	memcpy(p->tcfp_keys, parm->keys, ksize);
>> -	p->tcfp_off_max_hint = 0;
>> -	for (i = 0; i < p->tcfp_nkeys; ++i) {
>> -		u32 cur = p->tcfp_keys[i].off;
>> +
>> +	memcpy(nparms->tcfp_keys, parm->keys, ksize);
>> +
>> +	for (i = 0; i < nparms->tcfp_nkeys; ++i) {
>> +		u32 cur = nparms->tcfp_keys[i].off;
>>   
>>   		/* sanitize the shift value for any later use */
>> -		p->tcfp_keys[i].shift = min_t(size_t, BITS_PER_TYPE(int) - 1,
>> -					      p->tcfp_keys[i].shift);
>> +		nparms->tcfp_keys[i].shift = min_t(size_t,
>> +						   BITS_PER_TYPE(int) - 1,
>> +						   nparms->tcfp_keys[i].shift);
>>   
>>   		/* The AT option can read a single byte, we can bound the actual
>>   		 * value with uchar max.
>>   		 */
>> -		cur += (0xff & p->tcfp_keys[i].offmask) >> p->tcfp_keys[i].shift;
>> +		cur += (0xff & nparms->tcfp_keys[i].offmask) >> nparms->tcfp_keys[i].shift;
>>   
>>   		/* Each key touches 4 bytes starting from the computed offset */
>> -		p->tcfp_off_max_hint = max(p->tcfp_off_max_hint, cur + 4);
>> +		nparms->tcfp_off_max_hint =
>> +			max(nparms->tcfp_off_max_hint, cur + 4);
>>   	}
>>   
>> -	p->tcfp_flags = parm->flags;
>>   	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>>   
>> -	kfree(p->tcfp_keys_ex);
>> -	p->tcfp_keys_ex = keys_ex;
>> +	rcu_assign_pointer(p->parms, nparms);
>>   
>>   	spin_unlock_bh(&p->tcf_lock);
>> +
>> +	if (oparms)
>> +		call_rcu(&oparms->rcu, tcf_pedit_cleanup_rcu);
> 
> 	Here there is a condition on oparms being non-NULL.
> 	But further above oparms is dereference unconditionally.
> 	Is there an inconsistency here?

oparms is NULL when we create the action instance.
I believe this will be way clearer in the next version.

> 
>> +
>>   	if (goto_ch)
>>   		tcf_chain_put_by_act(goto_ch);
>> +
>>   	return ret;
>>   
>> -put_chain:
>> -	if (goto_ch)
>> -		tcf_chain_put_by_act(goto_ch);
>>   out_release:
>>   	tcf_idr_release(*a, bind);
>> +out_free_ex:
>> +	kfree(nparms->tcfp_keys_ex);
>>   out_free:
>> -	kfree(keys_ex);
>> +	kfree(nparms);
>>   	return ret;
>> -
>>   }
> 
> ...

