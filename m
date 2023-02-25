Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91C46A2A0C
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 14:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjBYNip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 08:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjBYNio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 08:38:44 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5E7BD519
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 05:38:36 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id f19-20020a9d5f13000000b00693ce5a2f3eso1151220oti.8
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 05:38:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=135FtJB4zprhs6ljFeegi/oxwa3V2LRXdknECKKljUc=;
        b=ws/UXHplpSYNE8V8CYw5aogyZl7BXKEhxItgEAn6bRqbadkMTFvG37RUyVuapDyO88
         wWNYBemK5cGOC+rxOA7+TE40Gz5cTaSf5J02e8JMIsh2FZd9cwogNOCrnVjT+WtnaDm7
         XMA6ZduiH4PtpQE6F/3ShplN+VrqGY5VSdQMTxcHIX+InE5ZD3jT2kvVNlE/bcYiQA33
         Lty3c4tnzE+XyQEOph9qxDmbFZH36Hq7KY9JgT4TXtDQhZOO1fbDp85v2OWYR7lT69dq
         O/2ra8wA6aDrtVgE7VEwH2ZArSqg593Lyz2gkk5o1wJMliqIxfcCU3Uld87d+S4Pze0G
         hZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=135FtJB4zprhs6ljFeegi/oxwa3V2LRXdknECKKljUc=;
        b=q1qxSZEpqZp/o4mjGSqeolcZl4Q8Z4tlrX4Wu76U7pE0xkPaq7mEWT5AhiDnS9rnfy
         uw1nuxhh6cg1XgTwp4KKyoAOXrPHzoHupioFavZI08HIVimOZi0oNs01jT+lrCa9dYCy
         iQqhLMeSIBgpA5sVkW1gp7WWnVvIRXLttNyhly6C6Cq/QLcMYfWxIa7/8GATPDHozLED
         3RHcKK+3066v4ayiCzC7fZFIFOJYdlWmQwb80qnWdTagqBg2SeZeSsc9jtcPRNGpmhdz
         KppyK0H9+x1glKGKVOmypKvfrasGbWUK1CkFuXTvVzAfOOFx5s1xNdJroARuPGK/8vfJ
         MOzQ==
X-Gm-Message-State: AO0yUKWYHtSD5QWs/OuUaY2mqjtQSMp4znsWVDqA30KHvugIomUDtzKY
        Qz731OYq3aq2sVInHH80Y75H0w==
X-Google-Smtp-Source: AK7set94TrAUVpj1HHUxMgMqeFVScgLfW5TZxBlTzKvuWdikHQ2jZmKNpJkEPiWmSGznvnRyvd8TGw==
X-Received: by 2002:a9d:372:0:b0:68b:c06f:5e67 with SMTP id 105-20020a9d0372000000b0068bc06f5e67mr6468142otv.37.1677332316114;
        Sat, 25 Feb 2023 05:38:36 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:be98:b35:325c:8721? ([2804:14d:5c5e:4698:be98:b35:325c:8721])
        by smtp.gmail.com with ESMTPSA id m8-20020a9d7e88000000b0068bd9a6d644sm622022otp.23.2023.02.25.05.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 05:38:35 -0800 (PST)
Message-ID: <a15d21c6-8a88-6c9a-ca7e-77a31ecfbe28@mojatatu.com>
Date:   Sat, 25 Feb 2023 10:38:31 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 1/3] net/sched: act_pedit: fix action bind logic
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, amir@vadai.me,
        dcaratti@redhat.com, willemb@google.com, ozsh@nvidia.com,
        paulb@nvidia.com
References: <20230224150058.149505-1-pctammela@mojatatu.com>
 <20230224150058.149505-2-pctammela@mojatatu.com>
 <Y/oIWNU5ryYmPPO1@corigine.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <Y/oIWNU5ryYmPPO1@corigine.com>
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

On 25/02/2023 10:08, Simon Horman wrote:
> On Fri, Feb 24, 2023 at 12:00:56PM -0300, Pedro Tammela wrote:
>> The TC architecture allows filters and actions to be created independently.
>> In filters the user can reference action objects using:
>> tc action add action pedit ... index 1
>> tc filter add ... action pedit index 1
>>
>> In the current code for act_pedit this is broken as it checks netlink
>> attributes for create/update before actually checking if we are binding to an
>> existing action.
>>
>> tdc results:
>> 1..69
> 
> ...
> 
> Hi Pedro,
> 
> Thanks for running the tests :)
> 
> I think this patch looks good - though I am still digesting it.
> But I do wonder if you considered adding a test for this condition.

Yes, they are in my backlog to post when net-next reopens.

> 
> Also, what is the failure mode?

When referencing actions via its indexes on filters there would be three 
outcomes:
1 - Action binds to filter (expected)
2 - Action fails netlink parsing in kernel
3 - Action fails parsing in iproute2

I also posted complementary iproute2 patches.

> 
> If it is that user's can't bind actions to filters,  but the kernel behaves
> correctly with configurations it accepts. If so, then perhaps this is more
> of a feature than a fix.

I would argue it's a fix...

> OTOH, perhaps it's a regression wrt the oldest of
> the two patches references below.

...because filters and actions are completely separate TC objects.
There shouldn't be actions that can be created independently but can't 
be really used.

> 
> I've haven't looked at the other patches in this series yet.
> But I expect my comments apply to them too.
> 
>> Fixes: 71d0ed7079df ("net/act_pedit: Support using offset relative to the conventional network headers")
>> Fixes: f67169fef8db ("net/sched: act_pedit: fix WARN() in the traffic path")
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> 
> ...

