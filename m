Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA3D5BF68F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 08:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbiIUGnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 02:43:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiIUGnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 02:43:42 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E4080F41
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:43:40 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bq9so8220768wrb.4
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 23:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date;
        bh=rUO6t6C3l9V7+NJRQvXy0uGhA6vMbQwppUZNMvDDpV8=;
        b=FXGNEyoJ6TsxJT/6jnwzdEYEYt1X515xt7/Jhk/45XOE+8eGOFiXA/Hpb+Uj5wjO4k
         dpvq2t2OrrobHCE3A1uLZq4sJ85dpbR/4O6LW73t0CVSUWoR3HtPjmHd4yiz/T65PQhb
         1S08uTdvI2ZRtrJHrAYuz+UJS6QnnnaloiOMVuqhPvpAd+i7Q1WlihyBPbQdy2lcYTrs
         d/Bc7XNHJC1bBj7STOS6tkrZ/r/EUXbRRyNe/sBulywi/NzOD6r0ZoY6IHx4Abax1vVa
         wQOh1QX8K3zoEjUnYP3am1l0Fhjuqk2WLTMKUSiS/2bgq5cMXALRiKKzJLAHNdyCcGQM
         KhzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:from:references
         :cc:to:content-language:subject:reply-to:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=rUO6t6C3l9V7+NJRQvXy0uGhA6vMbQwppUZNMvDDpV8=;
        b=UOeY8Zrx3FhQyTRldDpyUpK+U1hPmyWQAx27JpNxsP+q5ol9c32TDpoMeBHDOZwxbW
         nt3F7vjzYuZDvWmD6Ti+glw/uDQzKNYmsIw025W7I7qnTOGj9wxWJVkabSt9TvZxVJjT
         U6VX43iiR3OGRUhNE2towsgz4HM68YnHCl2oh5Ti2hE8TzevaKgpg4s1RFp2jnFjGXmk
         ZgrqNvdVHM9batdgoZUzspsOYDBqZWIwhq15rj3Iju4Rfvy7WOry6y72Um0cFMdW1K8s
         ITcBnn5EDXCMcOAEIfSsn4y5by2XNxhDywgdY78vn+XPNglbPG+JzUZun7Xl5OwqAv/2
         mpHg==
X-Gm-Message-State: ACrzQf2FKVi3StQcKFL1yWERecvYvjEI5nlqh1gJaTLdBR8mXGsA6pJO
        ULKW+t1Co2KUZXJhWV5rxKwzO90fC1UEVg==
X-Google-Smtp-Source: AMsMyM4jYnJHLvtAJQjCSLHXhWg95c/lHNeFctxmznAxybidyvgTk+r20eLliLQ5Hppi6odo8gRrVg==
X-Received: by 2002:a5d:598f:0:b0:22a:f74d:ae24 with SMTP id n15-20020a5d598f000000b0022af74dae24mr10211658wri.544.1663742619299;
        Tue, 20 Sep 2022 23:43:39 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:d6f:4b37:41db:866e? ([2a01:e0a:b41:c160:d6f:4b37:41db:866e])
        by smtp.gmail.com with ESMTPSA id e6-20020a05600c4b8600b003b4de550e34sm1649852wmp.40.2022.09.20.23.43.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 23:43:38 -0700 (PDT)
Message-ID: <99b9a532-5feb-fe00-3d4e-29d560d34dc0@6wind.com>
Date:   Wed, 21 Sep 2022 08:43:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH net-next v4 04/12] net: netlink: add NLM_F_BULK delete
 request modifier
Content-Language: en-US
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     dsahern@kernel.org, roopa@nvidia.com, idosch@idosch.org,
        kuba@kernel.org, davem@davemloft.net,
        bridge@lists.linux-foundation.org
References: <20220413105202.2616106-1-razor@blackwall.org>
 <20220413105202.2616106-5-razor@blackwall.org>
 <0198618f-7b52-3023-5e9f-b38c49af1677@6wind.com>
 <f26fa81a-dc13-6a27-2e63-74b13359756e@blackwall.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <f26fa81a-dc13-6a27-2e63-74b13359756e@blackwall.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 20/09/2022 à 11:05, Nikolay Aleksandrov a écrit :
> On 20/09/2022 10:49, Nicolas Dichtel wrote:
>>
>> Le 13/04/2022 à 12:51, Nikolay Aleksandrov a écrit :
>>> Add a new delete request modifier called NLM_F_BULK which, when
>>> supported, would cause the request to delete multiple objects. The flag
>>> is a convenient way to signal that a multiple delete operation is
>>> requested which can be gradually added to different delete requests. In
>>> order to make sure older kernels will error out if the operation is not
>>> supported instead of doing something unintended we have to break a
>>> required condition when implementing support for this flag, f.e. for
>>> neighbors we will omit the mandatory mac address attribute.
>>> Initially it will be used to add flush with filtering support for bridge
>>> fdbs, but it also opens the door to add similar support to others.
>>>
>>> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
>>> ---
>>>  include/uapi/linux/netlink.h | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/include/uapi/linux/netlink.h b/include/uapi/linux/netlink.h
>>> index 4c0cde075c27..855dffb4c1c3 100644
>>> --- a/include/uapi/linux/netlink.h
>>> +++ b/include/uapi/linux/netlink.h
>>> @@ -72,6 +72,7 @@ struct nlmsghdr {
>>>  
>>>  /* Modifiers to DELETE request */
>>>  #define NLM_F_NONREC	0x100	/* Do not delete recursively	*/
>>> +#define NLM_F_BULK	0x200	/* Delete multiple objects	*/
>> Sorry to reply to an old patch, but FWIW, this patch broke the uAPI.
>> One of our applications was using NLM_F_EXCL with RTM_DELTFILTER. This is
>> conceptually wrong but it was working. After this patch, the kernel returns an
>> error (EOPNOTSUPP).
>>
>> Here is the patch series:
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?h=92716869375b
>>
>> We probably can't do anything now, but to avoid this in the future, I see only
>> two options:
>>  - enforce flags validation depending on the operation (but this may break some
>>    existing apps)
>>  - stop adding new flags that overlap between NEW and DEL operations (by adding
>>    a comment or defining dummy flags).
>>
>> Any thoughts?
>>
> 
> Personally I'd prefer to enforce validation so we don't lose the flags because of buggy user-space
> applications, but we can break someone (who arguably should fix their app though). We already had
> that discussion while the set was under review[1] and just to be a bit more confident I also
Thanks for the link. Finally, someone has (almost) complained :D

> tried searching for open-source buggy users, but didn't find any.
The trend seems to let someone else add another specific flag if needed. Thus,
it seems that checking flags is the way to go.
The pro is that if someone complains, the patch could be reverted, which is not
the case for a new feature like this bulk for example.


Regards,
Nicolas
