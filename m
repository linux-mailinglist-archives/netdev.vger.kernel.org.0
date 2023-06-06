Return-Path: <netdev+bounces-8354-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F4A9723CA0
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:11:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B8B228156D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823A1290EE;
	Tue,  6 Jun 2023 09:10:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B90125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:10:58 +0000 (UTC)
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B71048F;
	Tue,  6 Jun 2023 02:10:55 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Qb4QX1kDtz67gyM;
	Tue,  6 Jun 2023 17:08:36 +0800 (CST)
Received: from [10.123.123.126] (10.123.123.126) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 10:10:52 +0100
Message-ID: <ea810d57-93fe-1724-4aab-5cbc1a35062f@huawei.com>
Date: Tue, 6 Jun 2023 12:10:51 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v11 00/12] Network support for Landlock
Content-Language: ru
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
CC: <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
	<linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
	<netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
	<artem.kuzin@huawei.com>
References: <20230515161339.631577-1-konstantin.meskhidze@huawei.com>
 <8f3d242a-c0ee-217e-8094-84093ce4e134@digikod.net>
From: "Konstantin Meskhidze (A)" <konstantin.meskhidze@huawei.com>
In-Reply-To: <8f3d242a-c0ee-217e-8094-84093ce4e134@digikod.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.123.123.126]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



6/5/2023 6:02 PM, Mickaël Salaün пишет:
> Hi Konstantin,
> 
> The kernel code looks good. I found some issues in tests and
> documentation, and I'm still reviewing the whole patches. In the
> meantime, I've pushed it in -next, we'll see how it goes.
> 
> We need to have this new code covered by syzkaller. I'll work on that
> unless you want to.
> 
> Regards,
>    Mickaël
> 
   Hi, Mickaël!
   I have never set up syzkaller. Do you have a syzkaller scenario for 
Landlock code? I need some hints. I will give it a shot.

  Regards,
     Konstantin.
> 
> On 15/05/2023 18:13, Konstantin Meskhidze wrote:
>> Hi,
>> This is a new V11 patch related to Landlock LSM network confinement.
>> It is based on the landlock's -next branch on top of v6.2-rc3+ kernel version:
>> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
>> 
>> It brings refactoring of previous patch version V10.
>> Mostly there are fixes of logic and typos, refactoring some selftests.
>> 
>> All test were run in QEMU evironment and compiled with
>>   -static flag.
>>   1. network_test: 36/36 tests passed.
>>   2. base_test: 7/7 tests passed.
>>   3. fs_test: 78/78 tests passed.
>>   4. ptrace_test: 8/8 tests passed.
>> 
>> Previous versions:
>> v10: https://lore.kernel.org/linux-security-module/20230323085226.1432550-1-konstantin.meskhidze@huawei.com/
>> v9: https://lore.kernel.org/linux-security-module/20230116085818.165539-1-konstantin.meskhidze@huawei.com/
>> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
>> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
>> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
>> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
>> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
>> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
>> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
>> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
>> 
>> Konstantin Meskhidze (11):
>>    landlock: Make ruleset's access masks more generic
>>    landlock: Refactor landlock_find_rule/insert_rule
>>    landlock: Refactor merge/inherit_ruleset functions
>>    landlock: Move and rename layer helpers
>>    landlock: Refactor layer helpers
>>    landlock: Refactor landlock_add_rule() syscall
>>    landlock: Add network rules and TCP hooks support
>>    selftests/landlock: Share enforce_ruleset()
>>    selftests/landlock: Add 11 new test suites dedicated to network
>>    samples/landlock: Add network demo
>>    landlock: Document Landlock's network support
>> 
>> Mickaël Salaün (1):
>>    landlock: Allow filesystem layout changes for domains without such
>>      rule type
>> 
>>   Documentation/userspace-api/landlock.rst     |   89 +-
>>   include/uapi/linux/landlock.h                |   48 +
>>   samples/landlock/sandboxer.c                 |  128 +-
>>   security/landlock/Kconfig                    |    1 +
>>   security/landlock/Makefile                   |    2 +
>>   security/landlock/fs.c                       |  232 +--
>>   security/landlock/limits.h                   |    7 +-
>>   security/landlock/net.c                      |  174 +++
>>   security/landlock/net.h                      |   26 +
>>   security/landlock/ruleset.c                  |  405 +++++-
>>   security/landlock/ruleset.h                  |  185 ++-
>>   security/landlock/setup.c                    |    2 +
>>   security/landlock/syscalls.c                 |  163 ++-
>>   tools/testing/selftests/landlock/base_test.c |    2 +-
>>   tools/testing/selftests/landlock/common.h    |   10 +
>>   tools/testing/selftests/landlock/config      |    4 +
>>   tools/testing/selftests/landlock/fs_test.c   |   74 +-
>>   tools/testing/selftests/landlock/net_test.c  | 1317 ++++++++++++++++++
>>   18 files changed, 2520 insertions(+), 349 deletions(-)
>>   create mode 100644 security/landlock/net.c
>>   create mode 100644 security/landlock/net.h
>>   create mode 100644 tools/testing/selftests/landlock/net_test.c
>> 
>> --
>> 2.25.1
>> 
> .

