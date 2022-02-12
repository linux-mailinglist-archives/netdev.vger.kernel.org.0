Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2155C4B3286
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 02:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiBLByJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 20:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiBLByI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 20:54:08 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3631D99;
        Fri, 11 Feb 2022 17:54:06 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id on2so9564163pjb.4;
        Fri, 11 Feb 2022 17:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YEC57rZ+93vJLMfMqKmuxEbfl1IILSObR1bEO6B/Aqw=;
        b=LmUirQjBBAq3zjlwM4zY3z5EqqE9W4BOVT4M/kyMCr1Xo1K7kURzgFO+95R4oVPPcr
         e7ThXKryZKLkWFYkR+bdkbkP62z/3Dmt2o/UBsvhm1nUNlBN50coe/hs46eMyY5Zk/2k
         1y9V6vlAksWGcKkiN3uJdnVvsO9WeyvFShJdDhFL0t7Vshiu7snYnOlEERIsEsdQIksO
         7g85Hc2wAdivMZTseY8zzKRwBvee9rVpUb2pnk0DAZLGdMvXDGwQpLgKT9nuFogskRZ0
         0PtnDoqAZ8fugDbDLTXoE+3m8XlSgaL2UyQFT+d2tYQY7LxbuuD5OIdu4Jdtjo8YCB87
         cBkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YEC57rZ+93vJLMfMqKmuxEbfl1IILSObR1bEO6B/Aqw=;
        b=aOCh14pDi2OF68suBiN+gfn4K4KrdqrtM13V5UpcPnhPXGY1TPrda1FQHFaJCiAl7k
         1rs5sq34kRnWT+QdzfuTXdJbgSB0MTCC23Ov2M/AAz8JFkLPhB3aipB0ozAC4Jldldy/
         HYAiWdpFdjkgfBSwc52B3Et6RLFT6M7XxeuAGSiabgFwbn3yuSUBWWuYBG6Vo5OHOMkg
         71AYSbgAbwaCF+d7hye2RMJaekXrdmNOW5SrjmWoIpWxfF6QOiJkHFbiGNsePUk4y3lR
         BujEWdq82qzkeFwpGSTVQ5QctfyViW758gOWyHWsVXspjgCco4NyBKhXqFzeCPb9ka/N
         k86w==
X-Gm-Message-State: AOAM533D0ht6v/wwtIUy7oN3qc0nlcGveo6LZyJqwc/+ZwMVkJ+vDTrE
        ohliOprMPaLEGyW5cqTiGdnqdH7csBtvKQ==
X-Google-Smtp-Source: ABdhPJwGwoyIXrBPLcxeSnAvd708/eniWf9HJhERJe43VoAiuhHN9TV2MLLQSfSjWxZyZ+QrSqh/oQ==
X-Received: by 2002:a17:902:d4c2:: with SMTP id o2mr4225305plg.14.1644630846418;
        Fri, 11 Feb 2022 17:54:06 -0800 (PST)
Received: from [192.168.99.7] (i220-99-138-239.s42.a013.ap.plala.or.jp. [220.99.138.239])
        by smtp.googlemail.com with ESMTPSA id j14sm29881329pfj.218.2022.02.11.17.54.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 17:54:05 -0800 (PST)
Message-ID: <8309e037-840d-0a7d-26c1-f07fda9ba744@gmail.com>
Date:   Sat, 12 Feb 2022 10:54:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 1/3] netfilter: flowtable: Support GRE
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Paul Blakey <paulb@nvidia.com>
References: <20220203115941.3107572-1-toshiaki.makita1@gmail.com>
 <20220203115941.3107572-2-toshiaki.makita1@gmail.com>
 <YgFdS0ak3LIR2waA@salvia> <9d4fd782-896d-4a44-b596-517c84d97d5a@gmail.com>
 <YgOQ6a0itcJjQJqx@salvia>
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
In-Reply-To: <YgOQ6a0itcJjQJqx@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/02/09 19:01, Pablo Neira Ayuso wrote:
> On Tue, Feb 08, 2022 at 11:30:03PM +0900, Toshiaki Makita wrote:
>> On 2022/02/08 2:56, Pablo Neira Ayuso wrote:
>>> On Thu, Feb 03, 2022 at 08:59:39PM +0900, Toshiaki Makita wrote:
> [...]
>>>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>>>> index 889cf88..48e2f58 100644
>>>> --- a/net/netfilter/nf_flow_table_ip.c
>>>> +++ b/net/netfilter/nf_flow_table_ip.c
> [...]
>>>> @@ -202,15 +209,25 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
>>>>    	if (!pskb_may_pull(skb, thoff + *hdrsize))
>>>>    		return -1;
>>>> +	if (ipproto == IPPROTO_GRE) {
>>>
>>> No ifdef here? Maybe remove these ifdef everywhere?
>>
>> I wanted to avoid adding many ifdefs and I expect this to be compiled out
>> when CONFIG_NF_CT_PROTO_GRE=n as this block is unreachable anyway. It rather
>> may have been unintuitive though.
>>
>> Removing all of these ifdefs will cause inconsistent behavior between
>> CONFIG_NF_CT_PROTO_GRE=n/y.
>> When CONFIG_NF_CT_PROTO_GRE=n, conntrack cannot determine GRE version, thus
>> it will track GREv1 without key infomation, and the flow will be offloaded.
>> When CONFIG_NF_CT_PROTO_GRE=y, GREv1 will have key information and will not
>> be offloaded.
>> I wanted to just refuse offloading of GRE to avoid this inconsistency.
>> Anyway this kind of inconsistency seems to happen in software conntrack, so
>> if you'd like to remove ifdefs, I will do.
> 
> Good point, thanks for explaining. LGTM.

Let me confirm, did you agree to keep ifdefs, or delete them?

Toshiaki Makita
