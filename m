Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BC4B51FE66
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiEINij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236044AbiEINii (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:38:38 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71165243127
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 06:34:44 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id p4so10950716qtq.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 06:34:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DrCjzxpMZVBEm9XsgHq76yroWzumS8ZX+VaCvmSv+E8=;
        b=qtG49kTE3aZKHJ7ulqLD5mC2JHeyGzCoZS+xqFPOUV958b+uH6OvqUOqhojaq7XZvX
         SUT+Yto2x/FK0Q2jZmU9ZLjdULiHMnA9UQzJZpjCpdnY1cqjO0XBOWzCulbcCeK/YKrv
         ve+f/Vn/tUDBn5soUmttH+WXglIpoEYCkEzmkv05jZZVy2ju09fBmqhx5XmcmGL17bvk
         miYgIBpcLoy1EJTqVNzlrB2qBkXz97x2TAhpTRgL/dVVavhuVG9V3dy5NdUB2CzRjbY0
         OdlKL5sLXi9HovG1r4lTb50vdshkmW3CrpJpymZ+Q/kBkzbgZ4YH0uTrKQZu8ZnqICns
         bg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=DrCjzxpMZVBEm9XsgHq76yroWzumS8ZX+VaCvmSv+E8=;
        b=PhSeYEioaP9JawjqIWokMjKZby7F/Lw7SIJy0Hl6E0Mi9QgeklYMF5+035oCkolkQT
         1WnKWKofkOZCjLobmlNE/r5A9EEDyM3D8s3YUQ4f2t4+JSc7pXM08NZANy8n1K1UZYHj
         KFqeafsRTac0KzDF6SO3KhNdBSRqvRURXAyZYK6CBwsD5BmT+Apfj1ndDVZUEGRvw26u
         J42STS1nzQ+/elTxP2FObVRgdNIdnnzw06ZXZU+JOxpr0wEenqPMMd6k4Kvm8FpJ6+Y3
         aDRiQXaKOnHoab51CFAuphLcY8oCtO7GbkZBUc02yGx40+OHKkc425FAlFSHmCtpRIzL
         WZwQ==
X-Gm-Message-State: AOAM5304cS9hCxMj1m/DgQgfGS+oxU5EnUM40zLGE0ITdwHAicCza8zk
        y49BUjWjhzyDgY+1v533CIvkQBzzRv0w4g==
X-Google-Smtp-Source: ABdhPJymQxiK1jhc36jWp8n1Mx8IJ6TTtsqyJ2pDjFK7/6wN1YHNAtN8fyMwpMIHks6AIh8dYmtCQw==
X-Received: by 2002:a05:622a:1312:b0:2f3:9351:fcf8 with SMTP id v18-20020a05622a131200b002f39351fcf8mr14986115qtk.306.1652103283618;
        Mon, 09 May 2022 06:34:43 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-27-184-148-44-6.dsl.bell.ca. [184.148.44.6])
        by smtp.googlemail.com with ESMTPSA id p184-20020a378dc1000000b0069fc13ce1e1sm6970668qkd.18.2022.05.09.06.34.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 06:34:43 -0700 (PDT)
Message-ID: <c028cd9e-07ff-03db-ab74-499b94075989@mojatatu.com>
Date:   Mon, 9 May 2022 09:34:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 net] net/sched: act_pedit: really ensure the skb is
 writable
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>
References: <004a9eddf22a44b415a6573bdc67040b995c14dc.1652095998.git.pabeni@redhat.com>
 <b898299d-7361-f5e9-2e0e-aa5a0686faab@mojatatu.com>
 <1941abbcd1b9f33061d90533313da0efdb171a93.camel@redhat.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <1941abbcd1b9f33061d90533313da0efdb171a93.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-09 09:14, Paolo Abeni wrote:
> On Mon, 2022-05-09 at 08:16 -0400, Jamal Hadi Salim wrote:
>> On 2022-05-09 07:33, Paolo Abeni wrote:
>>
>> [..]
>>>    	goto_ch = tcf_action_set_ctrlact(*a, parm->action, goto_ch);
>>> @@ -308,13 +320,18 @@ static int tcf_pedit_act(struct sk_buff *skb, const struct tc_action *a,
>>>    			 struct tcf_result *res)
>>>    {
>>>    	struct tcf_pedit *p = to_pedit(a);
>>> +	u32 max_offset;
>>>    	int i;
>>>    
>>> -	if (skb_unclone(skb, GFP_ATOMIC))
>>> -		return p->tcf_action;
>>> -
>>>    	spin_lock(&p->tcf_lock);
>>>    
>>> +	max_offset = (skb_transport_header_was_set(skb) ?
>>> +		      skb_transport_offset(skb) :
>>> +		      skb_network_offset(skb)) +
>>> +		     p->tcfp_off_max_hint;
>>> +	if (skb_ensure_writable(skb, min(skb->len, max_offset)))
>>> +		goto unlock;
>>> +
>>
>> goto bad; would have been better so we can record it in the stats?
> 
> I thought about that, but it looked like an unexpected behavioral
> change: currently skb_unclone() failures do not touch stats.

Fair enough.


>> Other than that LGTM.
>> The commit message is good - but it would be better if you put that
>> example that triggered it.
> 
> Please let me know if you prefer another revision to cope with the
> above.
> 

Only if you have the energy to do it. Otherwise

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal

