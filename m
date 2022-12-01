Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7B5B63F57F
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 17:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbiLAQkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 11:40:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231696AbiLAQkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 11:40:40 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4F69ABA3C
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 08:40:39 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id h132so2610534oif.2
        for <netdev@vger.kernel.org>; Thu, 01 Dec 2022 08:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/1ULehJ+bn4AsLIhVxqm80w3b5oHBEpNFVAU1ywKDrA=;
        b=FuDuI7OR7qdynV3eFV++AhE6mgaiA/jHLal7mmAdSm+IDzogSvHBRrIwhbSetEsSOy
         pFlTWqdtMzY9wxg1Zlb0uY8Wzua9D/CLVufq8G/opZz91uIAX0umXz3GB0y+WOk5M4ou
         5vEP2GUEasiZEayQmP/4b8TuduVtRyPrvAz2wqy64FB3ydq16QTT954gq2Rk1N1QVFaD
         ii1lLziyKnB167/N76th/WVB5lzy3l/dsOvl3t4sNOlfYwdakUInRtI0luZE4b+dxCsp
         mbtitzqDbeR215kjqr216PwIY8bt3awCguyLzO1aXzrAkTLrC/7YiJp+AqwvsX+tHoCF
         3A/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/1ULehJ+bn4AsLIhVxqm80w3b5oHBEpNFVAU1ywKDrA=;
        b=QYj0OoMPbc9jgt+SU7prAAM6xLOBfgMqdn+YXyyZvqfGEV/Ipy8c/2/hERyIcxqH8A
         XRUuekHGEVg8mMGg+vosKaphMCzMx7KqwEBTvjAL7VrNfyROmh/60ibmMv5bZXodkGxj
         bQwP1CMgzWruG2k8Wn9F2v+TOA47gLVCSCWZ4lU1r6yNl++9+BxMLwroximzG5l8fGR7
         cJk7TmJ/vEcQiMoKVrQDEwh+O3LZp/AFcRZGOXihw8Qy9LA+SZjr6KzpI7PgUZHAHQMU
         N166ygCKYE+C+EhvKBdNyO37E4OHbtOba2SHTXTLfAUf6dj+dect/l/QxnAgPJ9j8vw6
         2c2g==
X-Gm-Message-State: ANoB5pl+o3Vw+VgbuIIUeSJSi/pYBvUTeW+e7Iu9+kVc1RHlEo2dBsSG
        7h29s9YTAvZakWkVYZkd9cUhdlP1gy2Umw==
X-Google-Smtp-Source: AA0mqf68pAe9KLo+K15gsB1DEWFnrcGTtvBh3jAIRCq61gEEu7nhb65XSkQ9Kbsb0dZYdKveGB5qyA==
X-Received: by 2002:a05:6808:11c1:b0:35a:78c8:4cd7 with SMTP id p1-20020a05680811c100b0035a78c84cd7mr33040961oiv.137.1669912839016;
        Thu, 01 Dec 2022 08:40:39 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:8964:c47c:c89d:8110? ([2804:14d:5c5e:4698:8964:c47c:c89d:8110])
        by smtp.gmail.com with ESMTPSA id o6-20020acad706000000b003549db40f38sm1941334oig.46.2022.12.01.08.40.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Dec 2022 08:40:38 -0800 (PST)
Message-ID: <19b7c2fe-2e56-cc56-86ca-dface0270bad@mojatatu.com>
Date:   Thu, 1 Dec 2022 13:40:34 -0300
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
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <20221130211643.01d65f46@kernel.org>
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

On 01/12/2022 02:16, Jakub Kicinski wrote:
> On Mon, 28 Nov 2022 12:44:54 -0300 Pedro Tammela wrote:
>> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
>> optimize actions and filters that are compiled as built-ins into a direct call.
>> The calls are ordered alphabetically, but new ones should be ideally
>> added last.
>>
>> On subsequent patches we expose the classifiers and actions functions
>> and wire up the wrapper into tc.
> 
>> +#if IS_ENABLED(CONFIG_RETPOLINE) && IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
> 
> The latter 'depends on' former, so just check the latter.
> 
>> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
>> +			   struct tcf_result *res)
>> +{
>> +	if (0) { /* noop */ }
>> +#if IS_BUILTIN(CONFIG_NET_ACT_BPF)
>> +	else if (a->ops->act == tcf_bpf_act)
>> +		return tcf_bpf_act(skb, a, res);
>> +#endif
> 
> How does the 'else if' ladder compare to a switch statement?

It's the semantically the same, we would just need to do some casts to 
unsigned long.
WDYT about the following?

   #define __TC_ACT_BUILTIN(builtin, fname) \
      if (builtin && a->ops->act == fname) return fname(skb, a, res)

   #define _TC_ACT_BUILTIN(builtin, fname) __TC_ACT_BUILTIN(builtin, fname)
   #define TC_ACT_BUILTIN(cfg, fname)  _TC_ACT_BUILTIN(IS_BUILTIN(cfg), 
fname)

   static inline int __tc_act(struct sk_buff *skb, const struct 
tc_action *a,
                              struct tcf_result *res)
   {
           TC_ACT_BUILTIN(CONFIG_NET_ACT_BPF, tcf_bpf_act);
   ...

It might be more pleasant to the reader.

> 
>> +#ifdef CONFIG_NET_CLS_ACT
>> +static inline int __tc_act(struct sk_buff *skb, const struct tc_action *a,
>> +			   struct tcf_result *res)
>> +{
>> +	return a->ops->act(skb, a, res);
>> +}
>> +#endif
>> +
>> +#ifdef CONFIG_NET_CLS
>> +static inline int __tc_classify(struct sk_buff *skb, const struct tcf_proto *tp,
>> +				struct tcf_result *res)
>> +{
>> +	return tp->classify(skb, tp, res);
>> +}
>> +#endif
> 
> please don't wrap the static inline helpers in #ifdefs unless it's
> actually necessary for build to pass.

The only one really needed is CONFIG_NET_CLS_ACT because the struct 
tc_action definition is protected by it. Perhaps we should move it out 
of the #ifdef?
