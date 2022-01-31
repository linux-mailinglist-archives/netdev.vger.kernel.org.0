Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A454A4AC8
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 16:40:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379771AbiAaPk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 10:40:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379767AbiAaPk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 10:40:26 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B86BC061714
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:40:26 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d188so17366755iof.7
        for <netdev@vger.kernel.org>; Mon, 31 Jan 2022 07:40:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=saE7kpVCpxo95s4+s2LGJEO7SIPJkZjVRqCwzU+SfUE=;
        b=D4KYKk1xRaN4dv4lrZ2G9kxZpb5fTACp43Shio+YjUXs44O2svyZlQsMdkXY7SPfr/
         x44O8XGo1dxkBfdAcpiG/U5jeItbz8gjcth5fPSX8AwiNsVbubXrdRNjpwJ622Eu32dZ
         7Y1Pk2rAsLq6BbdTygGrW8r0zrAcS+3e200N8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=saE7kpVCpxo95s4+s2LGJEO7SIPJkZjVRqCwzU+SfUE=;
        b=hV0KlJEBX+JjMSIXqQUmF5Kxzhkft/YQdMxo908+//aIvdo8yqLz4grvTFaXuCb5Jq
         ylxFoGcggRarJl+Hh6V0V0xUtIWk0jKHAtNCRdDx1qI6qmUNmVoIHPXtHhNzxpt9cJrv
         42lGgR4WXENkCzUE89LfEm8nUJIi5tFCqduszODYZcfZA6nYPncqDhStbKwNmHQYPfU0
         W9ZjPPoG5Rojv5cNoLBDG9AfrVm1mnCNpHQk9n6GRWzR7P1Io7u+IxCm7/+xFRRoqnTG
         ZBX0czwHLgtjk1YeO4nNTfpku2Gt8NEclmzY1nFuJSnwEojK4a8XDDqaAPYhX0pZsbKJ
         9tlA==
X-Gm-Message-State: AOAM531XX6cJr1oEgZGXSnEll/zYErn5tCUPDQh2poJ4+iP1k+fQ7ShS
        HsfMRQsPmoSndv7cjuBmC373YA==
X-Google-Smtp-Source: ABdhPJyKq1rKAJ/Lxq/Vg92Hv5BbtFsUbtCCKiChERafGqzSauSpNIKPktqEMaUuwRzC2Hq7K3xdGQ==
X-Received: by 2002:a05:6638:3781:: with SMTP id w1mr9570775jal.26.1643643625498;
        Mon, 31 Jan 2022 07:40:25 -0800 (PST)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id 193sm12875466iob.17.2022.01.31.07.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 07:40:25 -0800 (PST)
Subject: Re: tdc errors
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>
Cc:     Victor Nogueira <victor@mojatatu.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        David Ahern <dsahern@gmail.com>, shuah@kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <CA+NMeC-xsHvQ5KPybDUV02UW_zyy02k6fQXBy3YOBg8Qnp=LZQ@mail.gmail.com>
 <c4983694-0564-edca-7695-984f1d72367f@mojatatu.com>
 <CAKa-r6teP-fL63MWZzEWfG4XzugN-dY4ZabNfTBubfetwDS-Rg@mail.gmail.com>
 <a0051dc2-e626-915a-8925-416ff7effb94@mojatatu.com>
 <69c4581e-09bd-4218-4d5f-d39564bce9bc@linuxfoundation.org>
 <53506df1-feed-57e4-48f2-7444922e9bc2@mojatatu.com>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <b1a013a9-0f67-3723-d524-0210ca8cbe9a@linuxfoundation.org>
Date:   Mon, 31 Jan 2022 08:40:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <53506df1-feed-57e4-48f2-7444922e9bc2@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/31/22 5:46 AM, Jamal Hadi Salim wrote:
> On 2022-01-21 11:27, Shuah Khan wrote:
>> On 1/21/22 7:11 AM, Jamal Hadi Salim wrote:
>>> On 2022-01-21 04:36, Davide Caratti wrote:
>>>> On Thu, Jan 20, 2022 at 8:34 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
> [..]
> 
> 
>>
>> Several tests check for config support for their dependencies in their
>> test code - I don't see any of those in tc-testing. Individual tests
>> are supposed to check for not just the config dependencies, but also
>> any feature dependency e.g syscall/ioctl.
>>
>> Couple of way to fix this problem for tc-testing - enhance the test to
>> check for dependencies and skip with a clear message on why test is
>> skipped.
>>
>> A second option is enhancing the tools/testing/selftests/kselftest_deps.sh
>> script that checks for build depedencies. This tool can be enhanced easily
>> to check for run-time dependencies and use this in your automation.
>>
>> Usage: ./kselftest_deps.sh -[p] <compiler> [test_name]
>>
>>      kselftest_deps.sh [-p] gcc
>>      kselftest_deps.sh [-p] gcc vm
>>      kselftest_deps.sh [-p] aarch64-linux-gnu-gcc
>>      kselftest_deps.sh [-p] aarch64-linux-gnu-gcc vm
>>
>> - Should be run in selftests directory in the kernel repo.
>> - Checks if Kselftests can be built/cross-built on a system.
>> - Parses all test/sub-test Makefile to find library dependencies.
>> - Runs compile test on a trivial C file with LDLIBS specified
>>    in the test Makefiles to identify missing library dependencies.
>> - Prints suggested target list for a system filtering out tests
>>    failed the build dependency check from the TARGETS in Selftests
>>    main Makefile when optional -p is specified.
>> - Prints pass/fail dependency check for each tests/sub-test.
>> - Prints pass/fail targets and libraries.
>> - Default: runs dependency checks on all tests.
>> - Optional test name can be specified to check dependencies for it.
>>
> 
> Thanks Shuah. We'll look at this approach.
> Question: How do we get reports when the bot finds a regression?
> 
> 

You might be able to subscribe to test ring notification or subscribe
to Linux stable mailing list.

thanks,
-- Shuah
