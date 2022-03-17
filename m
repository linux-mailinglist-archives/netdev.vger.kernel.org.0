Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807E84DC732
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231199AbiCQNF3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 09:05:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235260AbiCQNDn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 09:03:43 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A524215B98A;
        Thu, 17 Mar 2022 06:01:54 -0700 (PDT)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KK6gJ3HV4z67N4y;
        Thu, 17 Mar 2022 20:59:56 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2375.24; Thu, 17 Mar 2022 14:01:50 +0100
Message-ID: <29244d4d-70cc-9c4f-6d0f-e3ce3beb2623@huawei.com>
Date:   Thu, 17 Mar 2022 16:01:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH v4 00/15] Landlock LSM
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>, <anton.sirazetdinov@huawei.com>
References: <20220309134459.6448-1-konstantin.meskhidze@huawei.com>
 <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <c9333349-5e05-de95-85da-f6a0cd836162@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



3/15/2022 8:02 PM, Mickaël Salaün пишет:
> Hi Konstantin,
> 
> This series looks good! Thanks for the split in multiple patches.
> 
  Thanks. I follow your recommendations.
> 
> On 09/03/2022 14:44, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V4 bunch of RFC patches related to Landlock LSM network 
>> confinement.
>> It brings deep refactirong and commit splitting of previous version V3.
>> Also added additional selftests.
>>
>> This patch series can be applied on top of v5.17-rc3.
>>
>> All test were run in QEMU evironment and compiled with
>>   -static flag.
>>   1. network_test: 9/9 tests passed.
> 
> I get a kernel warning running the network tests.

   What kind of warning? Can you provide it please?
> 
>>   2. base_test: 8/8 tests passed.
>>   3. fs_test: 46/46 tests passed.
>>   4. ptrace_test: 4/8 tests passed.
> 
> Does your test machine use Yama? That would explain the 4/8. You can 
> disable it with the appropriate sysctl.
> 
>>
>> Tests were also launched for Landlock version without
>> v4 patch:
>>   1. base_test: 8/8 tests passed.
>>   2. fs_test: 46/46 tests passed.
>>   3. ptrace_test: 4/8 tests passed.
>>
>> Could not provide test coverage cause had problems with tests
>> on VM (no -static flag the tests compiling, no v4 patch applied):
> 
> You can build statically-linked tests with:
> make -C tools/testing/selftests/landlock CFLAGS=-static

  Ok. I will try. Thanks.
> 
>> 1. base_test: 7/8 tests passed.
>>   Error:
>>   # Starting 8 tests from 1 test cases.
>>   #  RUN           global.inconsistent_attr ...
>>   # base_test.c:51:inconsistent_attr:Expected ENOMSG (42) == errno (22)
> 
> This looks like a bug in the syscall argument checks.

   This bug I just get when don't use -static option. With -static base 
test passes 8/8.
> 
>>   # inconsistent_attr: Test terminated by assertion
>> 2. fs_test: 0 / 46 tests passed
>>   Error for all tests:
>>   # common.h:126:no_restriction:Expected -1 (-1) != 
>> cap_set_proc(cap_p) (-1)
>>   # common.h:127:no_restriction:Failed to cap_set_proc: Operation not 
>> permitted
>>   # fs_test.c:106:no_restriction:Expected 0 (0) == mkdir(path, 0700) (-1)
>>   # fs_test.c:107:no_restriction:Failed to create directory "tmp": 
>> File exists
> 
> You need to run these tests as root.

   OK. I will try.
> 
>> 3. ptrace_test: 4 / 8 tests passed.
>>
>> Previous versions:
>> v3: 
>> https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/ 
>>
>> v2: 
>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
>>
>> v1: 
>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>
> 
> Nice to have this history!
> 
>>
>> Konstantin Meskhidze (15):
>>    landlock: access mask renaming
>>    landlock: filesystem access mask helpers
>>    landlock: landlock_find/insert_rule refactoring
>>    landlock: merge and inherit function refactoring
>>    landlock: unmask_layers() function refactoring
>>    landlock: landlock_add_rule syscall refactoring
>>    landlock: user space API network support
>>    landlock: add support network rules
>>    landlock: TCP network hooks implementation
>>    seltest/landlock: add tests for bind() hooks
>>    seltest/landlock: add tests for connect() hooks
>>    seltest/landlock: connect() with AF_UNSPEC tests
>>    seltest/landlock: rules overlapping test
>>    seltest/landlock: ruleset expanding test
>>    seltest/landlock: invalid user input data test
>>
>>   include/uapi/linux/landlock.h                 |  48 ++
>>   security/landlock/Kconfig                     |   1 +
>>   security/landlock/Makefile                    |   2 +-
>>   security/landlock/fs.c                        |  72 +-
>>   security/landlock/limits.h                    |   6 +
>>   security/landlock/net.c                       | 180 +++++
>>   security/landlock/net.h                       |  22 +
>>   security/landlock/ruleset.c                   | 383 ++++++++--
>>   security/landlock/ruleset.h                   |  72 +-
>>   security/landlock/setup.c                     |   2 +
>>   security/landlock/syscalls.c                  | 176 +++--
>>   .../testing/selftests/landlock/network_test.c | 665 ++++++++++++++++++
>>   12 files changed, 1434 insertions(+), 195 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>   create mode 100644 tools/testing/selftests/landlock/network_test.c
>>
>> -- 
>> 2.25.1
>>
> .
