Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797674E6352
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350154AbiCXM2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350156AbiCXM2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:28:38 -0400
Received: from smtp-bc0c.mail.infomaniak.ch (smtp-bc0c.mail.infomaniak.ch [IPv6:2001:1600:4:17::bc0c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47FFA94F3
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 05:27:05 -0700 (PDT)
Received: from smtp-2-0001.mail.infomaniak.ch (unknown [10.5.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4KPPc53yx2zMprrp;
        Thu, 24 Mar 2022 13:27:01 +0100 (CET)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-2-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4KPPc45TPLzljsV8;
        Thu, 24 Mar 2022 13:27:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1648124821;
        bh=GambdRT0rOro/c6TI0baCIcy5+p9FbWf/97/D77xtcA=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=0UbF5hpdebGMkuMHESTmaUE4rLQEBSbrVj6h2+reQhBvtsOpCLJ+L8i46pXasy+Wm
         c5tINrKXq/J5drLBhf2bqbi11D5lF3tYqMxn/sTYa+02kDu189qcT97zZoF5q6S8CS
         W+oG4xBhh0/4i9ZnveFUfkxVTZZ5l8Ufc4OixqLc=
Message-ID: <59923702-3a1f-e018-c9b4-7a53f97b1791@digikod.net>
Date:   Thu, 24 Mar 2022 13:27:04 +0100
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com, anton.sirazetdinov@huawei.com
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
 <29244d4d-70cc-9c4f-6d0f-e3ce3beb2623@huawei.com>
 <ef128eed-65a3-1617-d630-275f3cfa8220@digikod.net>
 <b367c8c6-adfc-9ec1-a898-f9aa13815ca5@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [RFC PATCH v4 00/15] Landlock LSM
In-Reply-To: <b367c8c6-adfc-9ec1-a898-f9aa13815ca5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2022 17:30, Konstantin Meskhidze wrote:
> 
> 
> 3/17/2022 8:26 PM, Mickaël Salaün пишет:
>>
>> On 17/03/2022 14:01, Konstantin Meskhidze wrote:
>>>
>>>
>>> 3/15/2022 8:02 PM, Mickaël Salaün пишет:
>>>> Hi Konstantin,
>>>>
>>>> This series looks good! Thanks for the split in multiple patches.
>>>>
>>>   Thanks. I follow your recommendations.
>>>>
>>>> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>>>>> Hi,
>>>>> This is a new V4 bunch of RFC patches related to Landlock LSM 
>>>>> network confinement.
>>>>> It brings deep refactirong and commit splitting of previous version 
>>>>> V3.
>>>>> Also added additional selftests.
>>>>>
>>>>> This patch series can be applied on top of v5.17-rc3.
>>>>>
>>>>> All test were run in QEMU evironment and compiled with
>>>>>   -static flag.
>>>>>   1. network_test: 9/9 tests passed.
>>>>
>>>> I get a kernel warning running the network tests.
>>>
>>>    What kind of warning? Can you provide it please?
>>
>> You really need to get a setup that gives you such kernel warning. 
>> When running network_test you should get:
>> WARNING: CPU: 3 PID: 742 at security/landlock/ruleset.c:218 
>> insert_rule+0x220/0x270
>>
>> Before sending new patches, please make sure you're able to catch such 
>> issues.
>>
>>
>>>>
>>>>>   2. base_test: 8/8 tests passed.
>>>>>   3. fs_test: 46/46 tests passed.
>>>>>   4. ptrace_test: 4/8 tests passed.
>>>>
>>>> Does your test machine use Yama? That would explain the 4/8. You can 
>>>> disable it with the appropriate sysctl.
>>
>> Can you answer this question?
>>
>>
>>>>
>>>>>
>>>>> Tests were also launched for Landlock version without
>>>>> v4 patch:
>>>>>   1. base_test: 8/8 tests passed.
>>>>>   2. fs_test: 46/46 tests passed.
>>>>>   3. ptrace_test: 4/8 tests passed.
>>>>>
>>>>> Could not provide test coverage cause had problems with tests
>>>>> on VM (no -static flag the tests compiling, no v4 patch applied):
>>>>
>     Hi, Mickaёl!
>     I tried to get base test coverage without v4 patch applied.
> 
>     1. Kernel configuration :
>      - CONFIG_DEBUG_FS=y
>      - CONFIG_GCOV_KERNEL=y
>      - CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y
>     2. Added GCOV_PROFILE := y in security/landlock/Makefile

I think this is useless because of CONFIG_ARCH_HAS_GCOV_PROFILE_ALL=y. I 
don't add GCOV_PROFILE anyway.


>     3. Compiled kernel  and rebooted VM with the new one.
>     4. Run landlock selftests as root user:
>      $ cd tools/testing/selftests/landlock
>      $ ./base_test
>      $ ./fs_test
>      $ ./ptrace_test
>     5. Copied GCOV data to some folder :
>        $ cp -r 
> /sys/kernel/debug/gcov/<source-dir>/linux/security/landlock/ /gcov-before
>        $ cd /gcov-before
>        $ lcov -c -d ./landlock -o lcov.info && genhtml -o html lcov.info

I do this step on my host but that should work as long as you have the 
kernel sources in the same directory. I guess this is not the case. I 
think you also need GCC >= 4.8 .

> 
> I got the next result:
> " Capturing coverage data from ./landlock
> Found gcov version: 9.4.0
> Using intermediate gcov format
> Scanning ./landlock for .gcda files ...
> Found 7 data files in ./landlock
> Processing landlock/setup.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/setup.gcda:cannot open 
> data file, assuming not executed
> Processing landlock/object.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/object.gcda:cannot open 
> data file, assuming not executed
> Processing landlock/cred.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/cred.gcda:cannot open 
> data file, assuming not executed
> Processing landlock/ruleset.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/ruleset.gcda:cannot open 
> data file, assuming not executed
> Processing landlock/syscalls.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/syscalls.gcda:cannot open 
> data file, assuming not executed
> Processing landlock/fs.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/fs.gcda:cannot open data 
> file, assuming not executed
> Processing landlock/ptrace.gcda
> /home/kmeskhidze/work/src/gcov_before/landlock/ptrace.gcda:cannot open 
> data file, assuming not executed
> Finished .info-file creation
> Reading data file lcov.info
> Found 38 entries.
> Found common filename prefix 
> "/home/kmeskhidze/work/src/linux_5.13_landlock"
> Writing .css and .png files.
> Generating output.
> Processing file arch/x86/include/asm/atomic64_64.h
> Processing file arch/x86/include/asm/bitops.h
> Processing file arch/x86/include/asm/atomic.h
> Processing file arch/x86/include/asm/current.h
> Processing file include/asm-generic/getorder.h
> Processing file include/asm-generic/bitops/instrumented-non-atomic.h
> Processing file include/linux/fs.h
> Processing file include/linux/refcount.h
> Processing file include/linux/kernel.h
> Processing file include/linux/list.h
> Processing file include/linux/sched.h
> Processing file include/linux/overflow.h
> Processing file include/linux/dcache.h
> Processing file include/linux/spinlock.h
> Processing file include/linux/file.h
> Processing file include/linux/rcupdate.h
> Processing file include/linux/err.h
> Processing file include/linux/workqueue.h
> Processing file include/linux/fortify-string.h
> Processing file include/linux/slab.h
> Processing file include/linux/instrumented.h
> Processing file include/linux/uaccess.h
> Processing file include/linux/thread_info.h
> Processing file include/linux/rbtree.h
> Processing file include/linux/log2.h
> Processing file include/linux/atomic/atomic-instrumented.h
> Processing file include/linux/atomic/atomic-long.h
> Processing file security/landlock/fs.c
> Processing file security/landlock/ruleset.h
> Processing file security/landlock/ruleset.c
> Processing file security/landlock/ptrace.c
> Processing file security/landlock/object.h
> Processing file security/landlock/syscalls.c
> Processing file security/landlock/setup.c
> Processing file security/landlock/cred.c
> Processing file security/landlock/object.c
> Processing file security/landlock/fs.h
> Processing file security/landlock/cred.h
> Writing directory view page.
> Overall coverage rate:
>    lines......: 0.0% (0 of 937 lines)
>    functions..: 0.0% (0 of 67 functions) "
> 
> Looks like .gcda files were not executed.
> Maybe I did miss something. Any thoughts?
