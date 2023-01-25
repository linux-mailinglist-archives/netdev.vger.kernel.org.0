Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D185B67BAFF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 20:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234990AbjAYTua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 14:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjAYTu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 14:50:29 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6EEEF88
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:50:27 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id o5so16951704qtr.11
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 11:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZoHg4ev9fSktbcMxE1AoB5FvBrcNF8OI64tDCG3F9+M=;
        b=nAZ0NEeyW4QmhBDtGTv3IY0zq9AO6EuUCKXwjZTerYwmayJp9IDQeJA/hkkDLX4eOU
         QVYuvHgcfChsx63d9582ML7P+Atfl3tBdRlFv2RlZj8+YNJwfnfghc4bVTgLlC4xrtDg
         yuimmAgvt6zDEvvvch2lIV299x8u+OIiCo3Nn6J/UD/P4PTQlnO/vX+mSD9Hv6kOqewU
         pHnxxG5Jfk/MlX4bWsQym67EgfQRE8QQs3y4zw1ozdzXTK9rwZXFF9CjaaDSaxW412Bo
         tggdrTPeM/FBapEjRzsfudUoRxdCrM7Li3peSCkYswhFGpSaUEHiRlouA0PNUHYwges4
         jvDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZoHg4ev9fSktbcMxE1AoB5FvBrcNF8OI64tDCG3F9+M=;
        b=puJBglG8DNi6F8hdAWx4ppTLZQYPMgHyFL1AXVqxls2qOOUoXD+gyceOzykSVENd9b
         rpqnVySBQgwd9PEsZtpoGJOp0nqbuuSIw1BYXm4rS16KH3U4KvgGyTHHxBssA8Cfpzfn
         tXc3qLOFXvF+b+crKj4hH89xTBKY2xuKCfEAZ3y8EczbmhMn9dB9LDT0Qv0BnORvIohB
         1eSS1FNLeXXpvKsY25BLbt+xx8fgAUdjAUik0aw0Lcon1fDK3u1GYstcsxM+qrAb5BAm
         CG3zfEMXAy9eOhb8dpXQFY7UsZMWNG9b33tXzn6zEnNjKpi6lPgR5FcYOLdLfZoJ+PUo
         65qw==
X-Gm-Message-State: AFqh2kp4MlGOb9EFCkx7gsIuCbxQuJ6x8ICCiX5HqKxP9+K29t6FfqJE
        sfwBsj+UXhRuSPrko0xeXvNBUZ0tIAU9zw==
X-Google-Smtp-Source: AMrXdXtu79/DW3qiHvStPwXfnF9mXH1TTcaEn3OUYR/cVZH8dQ87QdkPZFHKmCcjhQ4tgxAii5nzug==
X-Received: by 2002:ac8:6f09:0:b0:3b6:3468:8417 with SMTP id bs9-20020ac86f09000000b003b634688417mr52164804qtb.17.1674676226878;
        Wed, 25 Jan 2023 11:50:26 -0800 (PST)
Received: from ?IPV6:2601:18f:700:287c::1006? ([2601:18f:700:287c::1006])
        by smtp.gmail.com with ESMTPSA id x17-20020a05620a14b100b007069fde14a6sm4089167qkj.25.2023.01.25.11.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jan 2023 11:50:26 -0800 (PST)
Message-ID: <10278d1e-0aee-ee8e-3d54-0a82b2bcdbb9@gmail.com>
Date:   Wed, 25 Jan 2023 14:50:25 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] neighbor: fix proxy_delay usage when it is zero
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org
References: <20230123185829.238909-1-haleyb.dev@gmail.com>
 <20230124203059.59cdb789@kernel.org>
From:   Brian Haley <haleyb.dev@gmail.com>
In-Reply-To: <20230124203059.59cdb789@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub - thanks for the review.

On 1/24/23 11:30 PM, Jakub Kicinski wrote:
> On Mon, 23 Jan 2023 13:58:29 -0500 Brian Haley wrote:
>> When set to zero, the neighbor sysctl proxy_delay value
>> does not cause an immediate reply for ARP/ND requests
>> as expected, it instead causes a random delay between
>> [0, U32_MAX]. Looking at this comment from
>> __get_random_u32_below() explains the reason:
>>
>> /*
>>   * This function is technically undefined for ceil == 0, and in fact
>>   * for the non-underscored constant version in the header, we build bug
>>   * on that. But for the non-constant case, it's convenient to have that
>>   * evaluate to being a straight call to get_random_u32(), so that
>>   * get_random_u32_inclusive() can work over its whole range without
>>   * undefined behavior.
>>   */
>>
>> Added helper function that does not call get_random_u32_below()
>> if proxy_delay is zero and just uses the current value of
>> jiffies instead, causing pneigh_enqueue() to respond
>> immediately.
>>
>> Also added definition of proxy_delay to ip-sysctl.txt since
>> it was missing.
> 
> Sounds like this never worked, until commit a533b70a657c ("net:
> neighbor: fix a crash caused by mod zero") it crashed, now it
> does something silly. Can we instead reject 0 as invalid input
> during configuration?

To me, proxy_delay==0 implies respond immediately, so I think zero is 
valid input.

>> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
>> index 7fbd060d6047..34183fb38b20 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -1589,6 +1589,12 @@ proxy_arp_pvlan - BOOLEAN
>>   	  Hewlett-Packard call it Source-Port filtering or port-isolation.
>>   	  Ericsson call it MAC-Forced Forwarding (RFC Draft).
>>   
>> +proxy_delay - INTEGER
>> +	Delay proxy response.
>> +
>> +	The maximum number of jiffies to delay a response to a neighbor
>> +	solicitation when proxy_arp or proxy_ndp is enabled. Defaults to 80.
> 
> Is there a better way of expressing the fact that we always
> choose a value lower than proxy_delay ? Maximum sounds a bit
> like we'd do:
> 
> 	when = jiffies + random() % (proxy_delay + 1);

I think technically it's in the range of [0, proxy_delay] but I'll 
change the text to make that more obvious.

>>   shared_media - BOOLEAN
>>   	Send(router) or accept(host) RFC1620 shared media redirects.
>>   	Overrides secure_redirects.
>> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> index f00a79fc301b..8bd8aaae6d5e 100644
>> --- a/net/core/neighbour.c
>> +++ b/net/core/neighbour.c
>> @@ -1662,11 +1662,22 @@ static void neigh_proxy_process(struct timer_list *t)
>>   	spin_unlock(&tbl->proxy_queue.lock);
>>   }
>>   
>> +static __inline__ unsigned long neigh_proxy_delay(struct neigh_parms *p)
> 
> Drop the inline please, it's pointless for a tiny static function

JayV mentioned the same in private, guess I owe him a beer.

>> +{
>> +	/*
> 
> did you run checkpatch?

No, my kernel-fu is a little rusty, will do on v2.

> 
>> +	 * If proxy_delay is zero, do not call get_random_u32_below()
>> +	 * as it is undefined behavior.
>> +	 */
>> +	unsigned long proxy_delay = NEIGH_VAR(p, PROXY_DELAY);
> 
> empty line here
> 
>> +	return proxy_delay ?
>> +	       jiffies + get_random_u32_below(NEIGH_VAR(p, PROXY_DELAY)) :
> 
> also - since you have proxy_delay in a local variable why not use it

Ack.

Thanks,

-Brian
