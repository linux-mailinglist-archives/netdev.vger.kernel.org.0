Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B5764071D
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 13:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232971AbiLBMs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 07:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233105AbiLBMs4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 07:48:56 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0919C1BD2
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 04:48:54 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id c129so5260887oia.0
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 04:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NY2/MAG4BBYgz967LbHxcMTbUEXTrHWcJAf2WHPvavw=;
        b=Z7N5sMYlI/cu3sKW5chVyGcKJXkcvH9IhLRSCR6CT+M01F7mjziitb4jmRiOqAWL0I
         wDZe+kTr+eWW2SWIpSZ5movE5hqACu7lw5vaLL9wDSwhCaLKKlR70YZlWREAhs8QK6ES
         1rBulLj13au0JF8GaA0nVAML425FQQ9yTCTWGybbpm0FDjwC9Gwuw/EXGyLw5SaYcC47
         mPl2dZ71cbefIc9a+SxIaj9jFo8iUeDjU7/a26Vu0A3mVLv89zjetOgecYLkrm4xH7qB
         N5MR0GNpagLAKgCMWXqVGibgeCIDDq9Oc4iSnKgcYTEwi/RoISPtETo7G2hMZU6LUti8
         n+RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NY2/MAG4BBYgz967LbHxcMTbUEXTrHWcJAf2WHPvavw=;
        b=s+eOSVH5GlsZjJq6vunax5bLszK4QluCyV5WshSxLknqgvBBb5Qrf7dbZV2K0FnMd5
         CiE8cf9H1tSEowkjqPD5N6ZFdVipp9X55Ejeh66UsLgpPGSb2tk5/XZQZoDDSj4IdXh3
         IJjBoAsKxTW5boGNYu6BULS1/5FuiVPm2L46e5LOCEQxzbrM+r9Lq69IPr8lyYlgw3Rh
         iYGNT+ga86QdhUJI3CzfkXYDucHRAUxC0CVnuve5ggqtN4KicC/1ZJ94RGeabI8wrcb/
         h3hDCxuMeomSaCxGLVCueoFOQMDOHbymyPvT0QGRu3YiRBt0IEYdbarGpOlAlutqQeN1
         6Veg==
X-Gm-Message-State: ANoB5pnUvqt6wImYMdA++1KtYHMBV9rsRC22kSVDctc0ONayPRQ9INQN
        esQBIO1FzeDwXS3XZkbnfxo/4Q==
X-Google-Smtp-Source: AA0mqf4bEm7hrw2qTqi9EDXi/YUk60hZJLUwiqYQrB5nmq0VsBfGQDcVxmfAkIZY1Lg5tW2/Yvk3ug==
X-Received: by 2002:aca:3455:0:b0:345:20f7:b5df with SMTP id b82-20020aca3455000000b0034520f7b5dfmr24341857oia.46.1669985334177;
        Fri, 02 Dec 2022 04:48:54 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:8c18:43a8:b58f:76fe? ([2804:14d:5c5e:4698:8c18:43a8:b58f:76fe])
        by smtp.gmail.com with ESMTPSA id t26-20020a05683014da00b0066cb9069e0bsm3381219otq.42.2022.12.02.04.48.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Dec 2022 04:48:53 -0800 (PST)
Message-ID: <d2455b9f-78a3-81fe-46d5-c7aa03879294@mojatatu.com>
Date:   Fri, 2 Dec 2022 09:48:49 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 1/3] net/sched: add retpoline wrapper for tc
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com
References: <20221128154456.689326-1-pctammela@mojatatu.com>
 <20221128154456.689326-2-pctammela@mojatatu.com>
 <20221130211643.01d65f46@kernel.org>
 <19b7c2fe-2e56-cc56-86ca-dface0270bad@mojatatu.com>
 <20221201143812.47089fb1@kernel.org>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20221201143812.47089fb1@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/12/2022 19:38, Jakub Kicinski wrote:
> On Thu, 1 Dec 2022 13:40:34 -0300 Pedro Tammela wrote:
>>>> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
>>>> +			   struct tcf_result *res)
>>>> +{
>>>> +	if (0) { /* noop */ }
>>>> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
>>>> +	else if (a->ops->act == tcf_bpf_act)
>>>> +		return tcf_bpf_act(skb, a, res);
>>>> +#endif
>>>
>>> How does the 'else if' ladder compare to a switch statement?
>>
>> It's the semantically the same, we would just need to do some casts to
>> unsigned long.
> 
> Sorry, should've been clearer, I mean in terms of generated code.
> Is the machine code identical / better / worse?
> 
>> WDYT about the following?
>>
>>     #define __TC_ACT_BUILTIN(builtin, fname) \
>>        if (builtin && a->ops->act == fname) return fname(skb, a, res)
>>
>>     #define _TC_ACT_BUILTIN(builtin, fname) __TC_ACT_BUILTIN(builtin, fname)
>>     #define TC_ACT_BUILTIN(cfg, fname)  _TC_ACT_BUILTIN(IS_BUILTIN(cfg),
>> fname)
>>
>>     static inline int __tc_act(struct sk_buff *skb, const struct
>> tc_action *a,
>>                                struct tcf_result *res)
>>     {
>>             TC_ACT_BUILTIN(CONFIG_NET_ACT_BPF, tcf_bpf_act);
>>     ...
>>
>> It might be more pleasant to the reader.
> 
> Most definitely not to this reader :) The less macro magic the better.
> I'm primarily curious about whether the compiler treats this sort of
> construct the same as a switch.

Apparently we can't do a switch case in pointer addresses because the 
case condition must be constant.

> 
>>>> +#ifdef CONFIG_NET_CLS_ACT
>>>> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
>>>> +			   struct tcf_result *res)
>>>> +{
>>>> +	return a->ops->act(skb, a, res);
>>>> +}
>>>> +#endif
>>>> +
>>>> +#ifdef CONFIG_NET_CLS
>>>> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>>>> +				struct tcf_result *res)
>>>> +{
>>>> +	return tp->classify(skb, tp, res);
>>>> +}
>>>> +#endif
>>>
>>> please don't wrap the static inline helpers in #ifdefs unless it's
>>> actually necessary for build to pass.
>>
>> The only one really needed is CONFIG_NET_CLS_ACT because the struct
>> tc_action definition is protected by it. Perhaps we should move it out
>> of the #ifdef?
> 
> Yes, I think that's a nice cleanup.

