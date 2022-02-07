Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD2A64ABFED
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 14:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387976AbiBGNqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 08:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378827AbiBGNSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:18:52 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D82DC0401C1;
        Mon,  7 Feb 2022 05:18:51 -0800 (PST)
Received: from fraeml704-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jsmsr6fdHz689YM;
        Mon,  7 Feb 2022 21:18:08 +0800 (CST)
Received: from [10.122.132.241] (10.122.132.241) by
 fraeml704-chm.china.huawei.com (10.206.15.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Mon, 7 Feb 2022 14:18:48 +0100
Message-ID: <51967ba5-519a-8af2-76ce-eafa8c1dea33@huawei.com>
Date:   Mon, 7 Feb 2022 16:18:47 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH 0/2] landlock network implementation cover letter
Content-Language: ru
To:     =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC:     <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
References: <20220124080215.265538-1-konstantin.meskhidze@huawei.com>
 <85450679-51fd-e5ae-b994-74bda3041739@digikod.net>
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
In-Reply-To: <85450679-51fd-e5ae-b994-74bda3041739@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.122.132.241]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 fraeml704-chm.china.huawei.com (10.206.15.53)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



2/1/2022 8:53 PM, Mickaël Salaün пишет:
> 
> On 24/01/2022 09:02, Konstantin Meskhidze wrote:
>> Hi, all!
>>
>> This is a new bunch of RFC patches related to Landlock LSM network 
>> confinement.
>> Here are previous discussions:
>> 1. 
>> https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/ 
>>
>> 2. 
>> https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/ 
>>
>>
>> As in previous RFCs, 2 hooks are supported:
>>    - hook_socket_bind()
>>    - hook_socket_connect()
>>
>> Selftest are provided in tools/testing/selftests/landlock/network_test.c;
>> Implementation was tested in QEMU invironment with 5.13 kernel version:
> 
> Again, you need to base your work on the latest kernel version.
> 
   Is it because there are new Landlock features in a latest kernel
   version?
   I thought 5.13 kernel version and the latest one have the same
   Landlock functionality and there will not be rebasing problems in
   future. But anyway I will base the work on the latest kernel.
   Which kernel version do you work on now?

> 
>>   1. base_test - passed all tests
>>   2. fs_test - passed 44/46 tests. 2 tests related to overlayfs failed.
>>      Probably, I have wrong config options for overlayfs.
> 
> The minimal required configuration is listed in the "config" file. You 
> need to update it for the network tests as well. You missed the 
> ptrace_test. To test everything you can run:
> fakeroot make -C tools/testing/selftests TARGETS=landlock gen_tar
> and then extract 
> tools/testing/selftests/kselftest_install/kselftest-packages/kselftest.tar.gz 
> and execute run_kselftest.sh on your VM.

   Thank you. I missed config file in landlock selftests.
   I will launch all landlock tests.
> 
> 
>>   3. network_test - passed all tests.
>>      Please give your suggestions about test cover in network_test.c
>>
>> Implementation related issues
>> =============================
> 
> It is more a changelog than issues. ;)

   Ok. Thanks. I will add a changelog into the next patches.
> 
> 
>>
>> 1. Access masks array refactored into 1D one and changed
>> to 32 bits. Filesystem masks occupy 16 lower bits and network
>> masks reside in 16 upper bits.
>>
>>        struct landlock_ruleset {
>>              ...
>>              ...
>>              u32 access_masks[];
>>        }
>>
>> 2. Refactor API functions in ruleset.c:
>>      1. Add (void *)object argument.
>>      2. Add u16 rule_type argument.
>>
>>    - In filesystem case the "object" is defined by underlying inode.
>>    In network case the "object" is defined by a port. There is
>>    a union containing either a struct landlock_object pointer or a
>>    raw data (here a u16 port):
>>      union {
>>          struct landlock_object *ptr;
>>          uintptr_t data;
>>      } object;
>>
>>    - Everytime when a rule is inserted it's needed to provide a rule 
>> type:
>>
>>      landlock_insert_rule(ruleset, (void *)object, access, rule_type)
>>        1. A rule_type could be or LANDLOCK_RULE_NET_SERVICE or
>>        LANDLOCK_RULE_PATH_BENEATH;
>>        2. (void *) object - is either landlock_object *ptr or port value;
>>
>> 3. Use two rb_trees in ruleset structure:
>>      1. root_inode - for filesystem objects (inodes).
>>      2. root_net_port - for network port objects.
> 
> Thanks for these explanations!

   Thanks for the review!!!
> 
> 
>>
>> Konstantin Meskhidze (2):
>>    landlock: TCP network hooks implementation
>>    landlock: selftests for bind and connect hooks
>>
>>   include/uapi/linux/landlock.h                 |  52 +++
>>   security/landlock/Makefile                    |   2 +-
>>   security/landlock/fs.c                        |  12 +-
>>   security/landlock/limits.h                    |   6 +
>>   security/landlock/net.c                       | 175 +++++++++
>>   security/landlock/net.h                       |  21 ++
>>   security/landlock/ruleset.c                   | 167 ++++++---
>>   security/landlock/ruleset.h                   |  40 +-
>>   security/landlock/setup.c                     |   3 +
>>   security/landlock/syscalls.c                  | 142 ++++---
>>   .../testing/selftests/landlock/network_test.c | 346 ++++++++++++++++++
>>   11 files changed, 860 insertions(+), 106 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>   create mode 100644 tools/testing/selftests/landlock/network_test.c
>>
>> -- 
>> 2.25.1
>>
> .
