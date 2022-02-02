Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0607C4A7BB0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 00:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347964AbiBBX3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 18:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239047AbiBBX3t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 18:29:49 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8339C06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 15:29:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id n17so1101255iod.4
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 15:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XSkZgyT9SaCPdPpjpxg7RKDi2ly8T2FHcL7rm88MUFg=;
        b=hvorJX2QM4MFzTy0ftnmWv0klwNhmYimvwKPhT813Rida2VLz9HO67CRuWBrlqJXsL
         XTYu6bS4GUWJQFLRILcZER1QqTyNRIdbE7CMsXQ/QOp/qlj3ESCly2dy06h/Ij5zvMJz
         n363hcEyPSBT3uMEsITwejz8w2ot6wH2buTT0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XSkZgyT9SaCPdPpjpxg7RKDi2ly8T2FHcL7rm88MUFg=;
        b=IWdWSI2zJHt6PZATNbfT6tgLN48I95TWn9yDla3n41pyPslwxdUSZy6G3mX9FvS12f
         ziTW/WXed/7chwqCaZYm55OEUzsKdaWd13bndGGQ/Iq3IMAjC9eEitLXJTGDbIQfoQCe
         CP4KqLBXEpq2JLLXgIS9QGXY3P2lMBISdM6Rkpqv6qjyBGYYsXdClVfIkduZu8j261Ch
         s4BSExmlyXOXr7Ks+zdKgiV0DaNBPs+IhJzdChECD9liuN/wOUiIC8w8eoFi+HjfKbHZ
         9Wg3fDfz6I73LF1nM8S3DfMMuL2BpEWzCqHi3WCl3Nc0WedttVEKTKrjaNirQPjc1lwK
         vIlg==
X-Gm-Message-State: AOAM5330NarUe7qGCpdbbpWtxwtoXoRDKVk5wqOqBNqqM5YF8w/z+mph
        xOrImGBK2dTm8zNxO4pml0LEHbmIUoPPIA==
X-Google-Smtp-Source: ABdhPJyUj4OmV4GrmvIVJVnwTzsyusvoqIfRBVhe4CTCzDYNa7k8KLSMatqyontDWFnJ+WQtgcvzRg==
X-Received: by 2002:a05:6602:340a:: with SMTP id n10mr5126693ioz.76.1643844589140;
        Wed, 02 Feb 2022 15:29:49 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id r64sm19029581iod.25.2022.02.02.15.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 15:29:48 -0800 (PST)
Subject: Re: [PATCH net-next] selftests: fib offload: use sensible tos values
To:     Guillaume Nault <gnault@redhat.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <5e43b343720360a1c0e4f5947d9e917b26f30fbf.1643826556.git.gnault@redhat.com>
 <54a7071e-71ad-0c7d-ccc4-0f85dbe1e077@linuxfoundation.org>
 <20220202201614.GB15826@pc-4.home>
 <c5be299d-35e9-9ae9-185f-2faa6eccb149@linuxfoundation.org>
 <20220202232555.GC15826@pc-4.home>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e860d2f9-2137-8829-c76d-79555a47b3d4@linuxfoundation.org>
Date:   Wed, 2 Feb 2022 16:29:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220202232555.GC15826@pc-4.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/22 4:25 PM, Guillaume Nault wrote:
> On Wed, Feb 02, 2022 at 02:10:15PM -0700, Shuah Khan wrote:
>> On 2/2/22 1:16 PM, Guillaume Nault wrote:
>>> On Wed, Feb 02, 2022 at 12:46:10PM -0700, Shuah Khan wrote:
>>>> On 2/2/22 11:30 AM, Guillaume Nault wrote:
>>>>> Although both iproute2 and the kernel accept 1 and 2 as tos values for
>>>>> new routes, those are invalid. These values only set ECN bits, which
>>>>> are ignored during IPv4 fib lookups. Therefore, no packet can actually
>>>>> match such routes. This selftest therefore only succeeds because it
>>>>> doesn't verify that the new routes do actually work in practice (it
>>>>> just checks if the routes are offloaded or not).
>>>>>
>>>>> It makes more sense to use tos values that don't conflict with ECN.
>>>>> This way, the selftest won't be affected if we later decide to warn or
>>>>> even reject invalid tos configurations for new routes.
>>>>
>>>> Wouldn't it make sense to leave these invalid values in the test though.
>>>> Removing these makes this test out of sync withe kernel.
>>>
>>> Do you mean keeping the test as is and only modify it when (if) we
>>> decide to reject such invalid values?
>>
>> This is for sure. Remove the invalid values in sync with the kernel code.
>>
>>> Or to write two versions of the
>>> test, one with invalid values, the other with correct ones?
>>>
>>
>> This one makes sense if it adds value in testing to make sure we continue
>> to reject invalid values.
>>
>>> I don't get what keeping a test with the invalid values could bring us.
>>> It's confusing for the reader, and might break in the future. This
>>> patch makes the test future proof, without altering its intent and code
>>> coverage. It still works on current (and past) kernels, so I don't see
>>> what this patch could make out of sync.
>>>
>>
>> If kernel still accepts these values, then the test is valid as long as
>> kernel still doesn't flag these values as invalid.
>>
>> I might be missing something. Don't you want to test with invalid values
>> so make sure they are indeed rejected?
> 
> Testing invalid values makes sense, but in another selftest IMHO. This
> file is used to test hardware offload behaviour (although it lives
> under selftests/net/, it's only called from other scripts living under
> selftests/drivers/). Testing for accepted/rejected values should be
> done in a network generic selftest, not in driver specific ones.
> 
> I'm currently working on a patch series that'd include such tests (as
> part of a larger project aimed at fixing conflicting interpretations of
> ECN bits). But for fib_offload_lib.sh, I'd really prefer if we could
> keep it focused on testing driver features.
> 

A separate test for invalid values makes sense. It will be easier to find
and report problems.

thanks,
-- Shuah

