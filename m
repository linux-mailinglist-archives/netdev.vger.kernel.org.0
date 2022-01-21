Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B16FA4962C6
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 17:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbiAUQ2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 11:28:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiAUQ2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 11:28:00 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3828BC06173B
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:28:00 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id o10so8121752ilh.0
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 08:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sABqR0v3jU7EcVT5on60hnrw/dr9UuIrsh0XyrwaR3g=;
        b=gD/5HIdGX//bqhVAw6BEH9XjWChLVKFZl/8ZyuMUKyOLrtY8gewZP1GjUz8FVJQAke
         wVVnsHtsz3gS+JowW+lGba08EovYswTacnekEgCtdx5+sD7diMHngKQBxBnxzlBLqEva
         rSTkuadXumzGU/7WpIxR8fmUMes5FoyLGl5Ss=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sABqR0v3jU7EcVT5on60hnrw/dr9UuIrsh0XyrwaR3g=;
        b=sqZ/sWEcC1UHQb9Sgcjm6Wr55I4kF64EnnmBQkhjRuuiVFSBzUYuv28eCZf4hicNsz
         hwGzoyXsEvysg0SE9z4EeNmhNgfcGxlmS5Zu5rPXKzh716UxRsXAJ0ZJHhlohDI1+atI
         B1J4SLtf8nYdD3SWZsKH3gY9T+GyDY37XQKBBaR/klXH+6wZTO+HVP3mAPeYsy4tYDpO
         8CLD4yfs2BjyFR3uBQYqgmDs5bNxKc+jZC8uH6sSbAqlf7mjJdoYNYuJwaGuYDAmqLc4
         dJbshBgfGYtMOVOTtRr86XOslzhJrVDXhPFYGQWEOq4T3IxSETacUmrMPhZRc7IgN2yF
         bVlw==
X-Gm-Message-State: AOAM5323VsUFTUKbJfuA7O69BwFJrzGI1o4SIp5iwrZLMvf4M5aKUlfs
        v8K3h0nBDtVmeEX+su+2Lz/XlQ==
X-Google-Smtp-Source: ABdhPJz9xUfCdzzV7fkvyVjN1NIa0melD9XX4yw4vlMnnNkd6yz7+39RPqnVdVoDKbmIntExp4Rt3w==
X-Received: by 2002:a05:6e02:1c89:: with SMTP id w9mr2440188ill.205.1642782479524;
        Fri, 21 Jan 2022 08:27:59 -0800 (PST)
Received: from ?IPv6:2601:282:8200:4c:a678:b224:47c8:9f36? ([2601:282:8200:4c:a678:b224:47c8:9f36])
        by smtp.gmail.com with ESMTPSA id x13sm1439302ilu.0.2022.01.21.08.27.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jan 2022 08:27:59 -0800 (PST)
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
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <69c4581e-09bd-4218-4d5f-d39564bce9bc@linuxfoundation.org>
Date:   Fri, 21 Jan 2022 09:27:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <a0051dc2-e626-915a-8925-416ff7effb94@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/21/22 7:11 AM, Jamal Hadi Salim wrote:
> On 2022-01-21 04:36, Davide Caratti wrote:
>> On Thu, Jan 20, 2022 at 8:34 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
> [..]>>
>>> So... How is the robot not reporting this as a regression?
>>> Davide? Basically kernel has the feature but code is missing
>>> in both iproute2 and iproute2-next..
>>
>> my guess (but it's only a guess) is that also the tc-testing code is
>> less recent than the code of the kernel under test, so it does not not
>> contain new items (like 7d64).
> 
> Which kernel(s) + iproute2 version does the bot test?
> In this case, the tdc test is in the kernel already..
> So in my opinion shouldve just ran and failed and a report
> sent indicating failure. Where do the reports go?
> 
> +Cc Shuah.
> 
>> But even if we had the latest net-next test code and the latest
>> net-next kernel under test, we would anyway see unstable test results,
>> because of the gap with iproute2 code.  My suggestion is to push new
>> tdc items (that require iproute2 bits, or some change to the kernel
>> configuration in the build environment) using 'skip: yes' in the JSON
>> (see [1]), and enable them only when we are sure that all the code
>> propagated at least to stable trees.
>>
>> wdyt?
>>
> 
> That's better than current status quo but: still has  human dependency
> IMO. If we can remove human dependency the bot can do a better job.
> Example:
> One thing that is often a cause of failures in tdc is kernel config.
> A lot of tests fail because the kernel doesnt have the config compiled
> in.
> Today, we work around that by providing a kernel config file in tdc.
> Unfortunately we dont use that config file for anything
> meaningful other than to tell the human what kernel options
> to ensure are compiled in before running the tests (manually).
> Infact the user has to inspect the config file first.
> 
> One idea that will help in automation is as follows:
> Could we add a "environment dependency" check that will ensure
> for a given test the right versions of things and configs exist?
> Example check if CONFIG_NET_SCH_ETS is available in the running
> kernel before executing "ets tests" or we have iproute2 version
>  >= blah before running the policer test with skip_sw feature etc
> I think some of this can be done via the pre-test-suite but we may
> need granularity at per-test level.
> 

Several tests check for config support for their dependencies in their
test code - I don't see any of those in tc-testing. Individual tests
are supposed to check for not just the config dependencies, but also
any feature dependency e.g syscall/ioctl.

Couple of way to fix this problem for tc-testing - enhance the test to
check for dependencies and skip with a clear message on why test is
skipped.

A second option is enhancing the tools/testing/selftests/kselftest_deps.sh
script that checks for build depedencies. This tool can be enhanced easily
to check for run-time dependencies and use this in your automation.

Usage: ./kselftest_deps.sh -[p] <compiler> [test_name]

	kselftest_deps.sh [-p] gcc
	kselftest_deps.sh [-p] gcc vm
	kselftest_deps.sh [-p] aarch64-linux-gnu-gcc
	kselftest_deps.sh [-p] aarch64-linux-gnu-gcc vm

- Should be run in selftests directory in the kernel repo.
- Checks if Kselftests can be built/cross-built on a system.
- Parses all test/sub-test Makefile to find library dependencies.
- Runs compile test on a trivial C file with LDLIBS specified
   in the test Makefiles to identify missing library dependencies.
- Prints suggested target list for a system filtering out tests
   failed the build dependency check from the TARGETS in Selftests
   main Makefile when optional -p is specified.
- Prints pass/fail dependency check for each tests/sub-test.
- Prints pass/fail targets and libraries.
- Default: runs dependency checks on all tests.
- Optional test name can be specified to check dependencies for it.

thanks,
-- Shuah


