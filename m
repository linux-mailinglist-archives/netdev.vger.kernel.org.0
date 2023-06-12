Return-Path: <netdev+bounces-10083-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A43972C05A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 12:52:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 31B531C20B20
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:51:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73D5134BF;
	Mon, 12 Jun 2023 10:51:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B616211CAD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 10:51:57 +0000 (UTC)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64F9783C8;
	Mon, 12 Jun 2023 03:51:55 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.53])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4QfpMN3TKDzLqhY;
	Mon, 12 Jun 2023 18:48:48 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 12 Jun 2023 18:51:52 +0800
Message-ID: <ecc10a9b-acc9-14d1-6fc4-f1a1834864b5@huawei.com>
Date: Mon, 12 Jun 2023 18:51:51 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 1/4] selftests/tc-testing: Fix Error: Specified qdisc
 kind is unknown.
To: Vlad Buslov <vladbu@nvidia.com>
CC: <pabeni@redhat.com>, <davem@davemloft.net>, <kuba@kernel.org>,
	<shuah@kernel.org>, <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>,
	<jiri@resnulli.us>, <netdev@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <marcelo.leitner@gmail.com>,
	<victor@mojatatu.com>
References: <20230612075712.2861848-1-vladbu@nvidia.com>
 <20230612075712.2861848-2-vladbu@nvidia.com>
 <6bcd42ad-4818-dff1-96a7-36b117610e85@huawei.com> <87h6rdvtxw.fsf@nvidia.com>
From: shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <87h6rdvtxw.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023/6/12 18:37, Vlad Buslov wrote:
> On Mon 12 Jun 2023 at 18:35, shaozhengchao <shaozhengchao@huawei.com> wrote:
>> On 2023/6/12 15:57, Vlad Buslov wrote:
>>> All TEQL tests assume that sch_teql module is loaded. Load module in tdc.sh
>>> before running qdisc tests.
>>> Fixes following example error when running tests via tdc.sh for all TEQL
>>> tests:
>>>    # $ sudo ./tdc.py -d eth2 -e 84a0
>>>    #  -- ns/SubPlugin.__init__
>>>    # Test 84a0: Create TEQL with default setting
>>>    # exit: 2
>>>    # exit: 0
>>>    # Error: Specified qdisc kind is unknown.
>>>    #
>>>    # -----> teardown stage *** Could not execute: "$TC qdisc del dev $DUMMY handle 1: root"
>>>    #
>>>    # -----> teardown stage *** Error message: "Error: Invalid handle.
>>>    # "
>>>    # returncode 2; expected [0]
>>>    #
>>>    # -----> teardown stage *** Aborting test run.
>>>    #
>>>    # <_io.BufferedReader name=3> *** stdout ***
>>>    #
>>>    # <_io.BufferedReader name=5> *** stderr ***
>>>    # "-----> teardown stage" did not complete successfully
>>>    # Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'Error: Specified qdisc kind is unknown.\n', '"-----> teardown stage" did not complete successfully') (caught in test_runner, running test 2 84a0 Create TEQL with default setting stage teardown)
>>>    # ---------------
>>>    # traceback
>>>    #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 495, in test_runner
>>>    #     res = run_one_test(pm, args, index, tidx)
>>>    #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 434, in run_one_test
>>>    #     prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
>>>    #   File "/images/src/linux/tools/testing/selftests/tc-testing/./tdc.py", line 245, in prepare_env
>>>    #     raise PluginMgrTestFail(
>>>    # ---------------
>>>    # accumulated output for this test:
>>>    # Error: Specified qdisc kind is unknown.
>>>    #
>>>    # ---------------
>>>    #
>>>    # All test results:
>>>    #
>>>    # 1..1
>>>    # ok 1 84a0 - Create TEQL with default setting # skipped - "-----> teardown stage" did not complete successfully
>>> Fixes: cc62fbe114c9 ("selftests/tc-testing: add selftests for teql qdisc")
>>> Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
>>> ---
>>>    tools/testing/selftests/tc-testing/tdc.sh | 1 +
>>>    1 file changed, 1 insertion(+)
>>> diff --git a/tools/testing/selftests/tc-testing/tdc.sh
>>> b/tools/testing/selftests/tc-testing/tdc.sh
>>> index afb0cd86fa3d..eb357bd7923c 100755
>>> --- a/tools/testing/selftests/tc-testing/tdc.sh
>>> +++ b/tools/testing/selftests/tc-testing/tdc.sh
>>> @@ -2,5 +2,6 @@
>>>    # SPDX-License-Identifier: GPL-2.0
>>>      modprobe netdevsim
>>> +modprobe sch_teql
>> I think not only the sch_teql module needs to be imported, but all test
>> modules need to be imported before testing. Modifying the config file
>> looks more appropriate.
> 
> All other modules are automatically loaded when first
> qdisc/action/classifier is instantiated via their respective APIs. The
> problem with two modules that are manually inserted here is that
> netdevsim-related tests expect /sys/bus/netdevsim/new_device to exist
> (which only exists if netdevsim module has been manually loaded) and
> specific command format "$TC qdisc add dev $DUMMY handle 1: root teql0"
> failing since 'telq0', again, only exists when sch_telq is loaded.
> 
> Overall, I added modprobe here not for theoretical correctness sake but
> because running tdc.sh on cold system causes error included in the
> commit message for me. I don't get any other errors related to necessary
> kernel modules not being loaded for any other kinds of tc tests.
> 
Fine, it looks good to me. Thank you.

Zhengchao Shao

>>>    ./tdc.py -c actions --nobuildebpf
>>>    ./tdc.py -c qdisc
> 

