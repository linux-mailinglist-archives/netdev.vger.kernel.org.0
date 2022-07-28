Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59593583BDB
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 12:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbiG1KMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 06:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234681AbiG1KMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 06:12:47 -0400
Received: from smtp-42aa.mail.infomaniak.ch (smtp-42aa.mail.infomaniak.ch [IPv6:2001:1600:4:17::42aa])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1794E65545;
        Thu, 28 Jul 2022 03:12:44 -0700 (PDT)
Received: from smtp-3-0001.mail.infomaniak.ch (unknown [10.4.36.108])
        by smtp-3-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4Ltmfz1TykzMqZgs;
        Thu, 28 Jul 2022 12:12:43 +0200 (CEST)
Received: from ns3096276.ip-94-23-54.eu (unknown [23.97.221.149])
        by smtp-3-0001.mail.infomaniak.ch (Postfix) with ESMTPA id 4Ltmfy4FBqzln8Vn;
        Thu, 28 Jul 2022 12:12:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1659003163;
        bh=86kTHghWAkjF6FizwalX3OjPsXiqgzxG0Gy8ziz1wRs=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=0m+UoQtW0DLZYRerKFN3sLdSgs+R09NgjzMDtkI4rR6lKLWNM45zQ2w8L7wLnAEZz
         pw748JbdtUs8xq7FffwWeR4MV/PKQkiOVdpSYJjCJ10vT+KQkLa3jXGDlrbzusjCqw
         8X1EF7xFKCvo6gV2QoveAQUXEmRPOmEAh3kBCqD4=
Message-ID: <83796b1f-d2c0-06f9-c5fd-eb81d51a1a95@digikod.net>
Date:   Thu, 28 Jul 2022 12:12:41 +0200
MIME-Version: 1.0
User-Agent: 
Content-Language: en-US
To:     "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        anton.sirazetdinov@huawei.com
References: <20220621082313.3330667-1-konstantin.meskhidze@huawei.com>
 <4c57a0c2-e207-10d6-c73d-bcda66bf3963@digikod.net>
 <6691d91f-c03b-30fa-2fa0-d062b3b234b9@digikod.net>
 <38fa02c6-a8d1-892b-3f30-4a2d6b38efe5@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Subject: Re: [PATCH v6 00/17] Network support for Landlock
In-Reply-To: <38fa02c6-a8d1-892b-3f30-4a2d6b38efe5@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/07/2022 11:25, Konstantin Meskhidze (A) wrote:
> 
> 
> 7/27/2022 10:54 PM, Mickaël Salaün пишет:
>>
>>
>> On 26/07/2022 19:43, Mickaël Salaün wrote:
>>>
>>> On 21/06/2022 10:22, Konstantin Meskhidze wrote:
>>>> Hi,
>>>> This is a new V6 patch related to Landlock LSM network confinement.
>>>> It is based on the latest landlock-wip branch on top of v5.19-rc2:
>>>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=landlock-wip
>>>>
>>>> It brings refactoring of previous patch version V5:
>>>>      - Fixes some logic errors and typos.
>>>>      - Adds additional FIXTURE_VARIANT and FIXTURE_VARIANT_ADD helpers
>>>>      to support both ip4 and ip6 families and shorten seltests' code.
>>>>      - Makes TCP sockets confinement support optional in sandboxer 
>>>> demo.
>>>>      - Formats the code with clang-format-14
>>>>
>>>> All test were run in QEMU evironment and compiled with
>>>>   -static flag.
>>>>   1. network_test: 18/18 tests passed.
>>>>   2. base_test: 7/7 tests passed.
>>>>   3. fs_test: 59/59 tests passed.
>>>>   4. ptrace_test: 8/8 tests passed.
>>>>
>>>> Still have issue with base_test were compiled without -static flag
>>>> (landlock-wip branch without network support)
>>>> 1. base_test: 6/7 tests passed.
>>>>   Error:
>>>>   #  RUN           global.inconsistent_attr ...
>>>>   # base_test.c:54:inconsistent_attr:Expected ENOMSG (42) == errno (22)
>>>>   # inconsistent_attr: Test terminated by assertion
>>>>   #          FAIL  global.inconsistent_attr
>>>> not ok 1 global.inconsistent_attr
>>>>
>>>> LCOV - code coverage report:
>>>>              Hit  Total  Coverage
>>>> Lines:      952  1010    94.3 %
>>>> Functions:  79   82      96.3 %
>>>>
>>>> Previous versions:
>>>> v5: 
>>>> https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>>>> v4: 
>>>> https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>>>> v3: 
>>>> https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>>>> v2: 
>>>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>>>> v1: 
>>>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>>>>
>>>> Konstantin Meskhidze (17):
>>>>    landlock: renames access mask
>>>>    landlock: refactors landlock_find/insert_rule
>>>>    landlock: refactors merge and inherit functions
>>>>    landlock: moves helper functions
>>>>    landlock: refactors helper functions
>>>>    landlock: refactors landlock_add_rule syscall
>>>>    landlock: user space API network support
>>>>    landlock: adds support network rules
>>>>    landlock: implements TCP network hooks
>>>>    seltests/landlock: moves helper function
>>>>    seltests/landlock: adds tests for bind() hooks
>>>>    seltests/landlock: adds tests for connect() hooks
>>>>    seltests/landlock: adds AF_UNSPEC family test
>>>>    seltests/landlock: adds rules overlapping test
>>>>    seltests/landlock: adds ruleset expanding test
>>>>    seltests/landlock: adds invalid input data test
>>>>    samples/landlock: adds network demo
>>>>
>>>>   include/uapi/linux/landlock.h               |  49 ++
>>>>   samples/landlock/sandboxer.c                | 118 ++-
>>>>   security/landlock/Kconfig                   |   1 +
>>>>   security/landlock/Makefile                  |   2 +
>>>>   security/landlock/fs.c                      | 162 +---
>>>>   security/landlock/limits.h                  |   8 +-
>>>>   security/landlock/net.c                     | 155 ++++
>>>>   security/landlock/net.h                     |  26 +
>>>>   security/landlock/ruleset.c                 | 448 +++++++++--
>>>>   security/landlock/ruleset.h                 |  91 ++-
>>>>   security/landlock/setup.c                   |   2 +
>>>>   security/landlock/syscalls.c                | 168 +++--
>>>>   tools/testing/selftests/landlock/common.h   |  10 +
>>>>   tools/testing/selftests/landlock/config     |   4 +
>>>>   tools/testing/selftests/landlock/fs_test.c  |  10 -
>>>>   tools/testing/selftests/landlock/net_test.c | 774 
>>>> ++++++++++++++++++++
>>>>   16 files changed, 1737 insertions(+), 291 deletions(-)
>>>>   create mode 100644 security/landlock/net.c
>>>>   create mode 100644 security/landlock/net.h
>>>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>>>>
>>>> -- 
>>>> 2.25.1
>>>>
>>>
>>> I did a thorough review of all the code. I found that the main issue 
>>> with this version is that we stick to the layers limit whereas it is 
>>> only relevant for filesystem hierarchies. You'll find in the 
>>> following patch miscellaneous fixes and improvement, with some TODOs 
>>> to get rid of this layer limit. We'll need a test to check that too. 
>>> You'll need to integrate this diff into your patches though.
>>
>> You can find the related patch here:
>> https://git.kernel.org/mic/c/8f4104b3dc59e7f110c9b83cdf034d010a2d006f
> 
>   Is this patch based on your updated landlock-wip branch or it's still 
> on Linux 5.19-rc2 version?

It's based on v5.19-rc2 but it doesn't really matter. I removed the 
landlock-wip branch, which is not needed anymore. You can base your 
patches on Linus' master branch.
