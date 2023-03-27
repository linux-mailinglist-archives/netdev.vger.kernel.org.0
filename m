Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB376CA6C7
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjC0OGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjC0OGq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:06:46 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485614EE6
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:05:38 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id y184so6410969oiy.8
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 07:05:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112; t=1679925937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qjKu4sPcCG8HaObf7nLVsO5wGnNB4G8Hn2a89xUM0fI=;
        b=pNwD5h7HyNinFidaMeWERzCWUuAj++pHnNNUUIlmrPrx1/ypEzkpyWuCChmSZyBZZF
         DRV3LZ8cZK+pGAbOgCJpEju37vgQPs6Ibwf6ahj5qJ7y1K/JYr5f3ZgRkaybJ2rpaN8L
         uRXeogJ/er1EvRhqu244xEfWbvFWWhO8tzoDL8lwN7HnWtLTE3TvpI6xHI3e1HdDbXPY
         vxOmTjNPImiYQMre2tvSdatmTCKxLe3j5BkK9TyL4tKcksLEj4Hbiq2JyjhKvb6PG/i1
         n54f5+Vcc4vcyWt78oE8hLYFKrE7NnGKZni6nqMhXewEYPHLAtJWILmMrpEHIa/UMbkx
         doKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679925937;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qjKu4sPcCG8HaObf7nLVsO5wGnNB4G8Hn2a89xUM0fI=;
        b=E4eyHwQjhekmNR5+tlfx7i//oDSOkx9CQ78ptNM2GgRgn14Bt4x75D7qyqrkGYkB9R
         PgrEULqBayZ0RY171OYWGNqm+hf2gN29AzZvj+3PtYUtTQFd8xWZY82jy+vivGV0F3CD
         74Xe4HSRUh/yBRBJkb9DVqaK3OLICB0E+HicOZo/PUAQGTm5P0l7L7rRpYO07eKboCUD
         wHtxhTfGpbC2fkr3fpiwnNP5Cmfe4swDPyqo13yX+jwLEBw72ElskL27Jl7BNX2mOOnx
         vXVfAZBBfjStrv2GrV5jwwYPYvxIUyka/V08AVa55BCGS+0TL7F0b0lp6lv1KfToodUR
         HE4A==
X-Gm-Message-State: AO0yUKWub6B7Xyh0xbvcJtg+0PdsveASMdx2u9xKmfiWdkzgNuX6LIrG
        ihId77YP0vF4CAl1eqFpuZ5qJJd0skxnU5IZcfg=
X-Google-Smtp-Source: AK7set/vR/2H1q0CfWU8fpxbLX9WIn9F9QVleo1stnJQj2Ku9VRkzoiPT7DUpoELlgACmGQXv/Plnw==
X-Received: by 2002:a05:6808:359:b0:386:bbe6:f9a5 with SMTP id j25-20020a056808035900b00386bbe6f9a5mr4993175oie.1.1679925937651;
        Mon, 27 Mar 2023 07:05:37 -0700 (PDT)
Received: from ?IPV6:2804:14d:5c5e:4698:bfcf:d761:95ef:9b9c? ([2804:14d:5c5e:4698:bfcf:d761:95ef:9b9c])
        by smtp.gmail.com with ESMTPSA id c3-20020aca1c03000000b0038901ece6e9sm2201361oic.12.2023.03.27.07.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Mar 2023 07:05:37 -0700 (PDT)
Message-ID: <9923f799-c78e-4a84-8e5d-957bdd1778b3@mojatatu.com>
Date:   Mon, 27 Mar 2023 11:05:33 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v2 2/4] selftests: tc-testing: extend the "skip"
 property
Content-Language: en-US
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ilya Maximets <i.maximets@ovn.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <cover.1679569719.git.dcaratti@redhat.com>
 <29e811befea5e751f938e3bf46ca870ec214d53d.1679569719.git.dcaratti@redhat.com>
 <b6ed0c28-248c-e383-cf05-a8a9bec73b20@mojatatu.com>
 <ZCFpprlY8GiNu6IX@dcaratti.users.ipa.redhat.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <ZCFpprlY8GiNu6IX@dcaratti.users.ipa.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2023 07:02, Davide Caratti wrote:
> hello Pedro, thanks for looking at this!
> 
> On Thu, Mar 23, 2023 at 11:01:53AM -0300, Pedro Tammela wrote:
>> On 23/03/2023 10:34, Davide Caratti wrote:
>>> currently, users can skip individual test cases by means of writing
>>>
>>>     "skip": "yes"
>>>
>>> in the scenario file. Extend this functionality by allowing the execution
>>> of a command, written in the "skip" property for a specific test case. If
>>> such property is present, tdc executes that command and skips the test if
>>> the return value is non-zero.
>>>
>>> Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>>
>>
>> I saw the use case in patch 3 but I didn't understand how it can happen.
>> Shouldn't iproute2 at least match the kernel version? I know it's not a hard
>> requirement for 99% of use cases, but when running tdc I would argue it's
>> the minimum expected.
> 
> sure, but there are distributions where patches are backported: on these
> ones, the kernel/iproute version is not so meaningful.

Oh, of course!

> Instead of posting kselftest after the iproute2 support code is merged, I
> think it's preferrable to just skip those kselftests that can't run because
> they lack userspace bits; and by the way I see we are already taking this
> approach elsewhere [1] [2].
> 

I see, so it makes distribution lives easier.
Wouldn't it be more clear then to have a separate property called 
"depends_on" or something similar?
If someone adds a new feature that depends on iproute2, then it would be 
more natural to just add a "depends_on" property.

Pedro
