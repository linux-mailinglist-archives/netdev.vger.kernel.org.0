Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA9065E8770
	for <lists+netdev@lfdr.de>; Sat, 24 Sep 2022 04:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbiIXCc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 22:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiIXCcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 22:32:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34952EDD32;
        Fri, 23 Sep 2022 19:32:23 -0700 (PDT)
Received: from dggpeml500026.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MZCcB4mPtzlW19;
        Sat, 24 Sep 2022 10:28:10 +0800 (CST)
Received: from [10.174.178.66] (10.174.178.66) by
 dggpeml500026.china.huawei.com (7.185.36.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Sat, 24 Sep 2022 10:32:20 +0800
Message-ID: <427a3b9e-5484-9fa3-04f7-138c93c802b9@huawei.com>
Date:   Sat, 24 Sep 2022 10:32:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net-next,v2 00/15] add tc-testing qdisc test cases
To:     Victor Nogueira <victor@mojatatu.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <jhs@mojatatu.com>,
        <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <shuah@kernel.org>
CC:     <weiyongjun1@huawei.com>, <yuehaibing@huawei.com>
References: <20220921025052.23465-1-shaozhengchao@huawei.com>
 <5a5e70a1-428b-9358-ea47-fdfb48e913ea@mojatatu.com>
From:   shaozhengchao <shaozhengchao@huawei.com>
In-Reply-To: <5a5e70a1-428b-9358-ea47-fdfb48e913ea@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.66]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500026.china.huawei.com (7.185.36.106)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/9/23 21:40, Victor Nogueira wrote:
> On 20/09/2022 23:50, Zhengchao Shao wrote:
> 
>> For this patchset, test cases of the qdisc modules are added to the
>> tc-testing test suite.
>>
>> After a test case is added locally, the test result is as follows:
>>
>> ./tdc.py -c atm
>> ok 1 7628 - Create ATM with default setting
>> ok 2 390a - Delete ATM with valid handle
>> ok 3 32a0 - Show ATM class
>> ok 4 6310 - Dump ATM stats
>>
>> ./tdc.py -c choke
>> ok 1 8937 - Create CHOKE with default setting
>> ok 2 48c0 - Create CHOKE with min packet setting
>> ok 3 38c1 - Create CHOKE with max packet setting
>> ok 4 234a - Create CHOKE with ecn setting
>> ok 5 4380 - Create CHOKE with burst setting
>> ok 6 48c7 - Delete CHOKE with valid handle
>> ok 7 4398 - Replace CHOKE with min setting
>> ok 8 0301 - Change CHOKE with limit setting
>>
>> ./tdc.py -c codel
>> ok 1 983a - Create CODEL with default setting
>> ok 2 38aa - Create CODEL with limit packet setting
>> ok 3 9178 - Create CODEL with target setting
>> ok 4 78d1 - Create CODEL with interval setting
>> ok 5 238a - Create CODEL with ecn setting
>> ok 6 939c - Create CODEL with ce_threshold setting
>> ok 7 8380 - Delete CODEL with valid handle
>> ok 8 289c - Replace CODEL with limit setting
>> ok 9 0648 - Change CODEL with limit setting
>>
>> ./tdc.py -c etf
>> ok 1 34ba - Create ETF with default setting
>> ok 2 438f - Create ETF with delta nanos setting
>> ok 3 9041 - Create ETF with deadline_mode setting
>> ok 4 9a0c - Create ETF with skip_sock_check setting
>> ok 5 2093 - Delete ETF with valid handle
>>
>> ./tdc.py -c fq
>> ok 1 983b - Create FQ with default setting
>> ok 2 38a1 - Create FQ with limit packet setting
>> ok 3 0a18 - Create FQ with flow_limit setting
>> ok 4 2390 - Create FQ with quantum setting
>> ok 5 845b - Create FQ with initial_quantum setting
>> ok 6 9398 - Create FQ with maxrate setting
>> ok 7 342c - Create FQ with nopacing setting
>> ok 8 6391 - Create FQ with refill_delay setting
>> ok 9 238b - Create FQ with low_rate_threshold setting
>> ok 10 7582 - Create FQ with orphan_mask setting
>> ok 11 4894 - Create FQ with timer_slack setting
>> ok 12 324c - Create FQ with ce_threshold setting
>> ok 13 424a - Create FQ with horizon time setting
>> ok 14 89e1 - Create FQ with horizon_cap setting
>> ok 15 32e1 - Delete FQ with valid handle
>> ok 16 49b0 - Replace FQ with limit setting
>> ok 17 9478 - Change FQ with limit setting
>>
>> ./tdc.py -c gred
>> ok 1 8942 - Create GRED with default setting
>> ok 2 5783 - Create GRED with grio setting
>> ok 3 8a09 - Create GRED with limit setting
>> ok 4 48cb - Create GRED with ecn setting
>> ok 5 763a - Change GRED setting
>> ok 6 8309 - Show GRED class
>>
>> ./tdc.py -c hhf
>> ok 1 4812 - Create HHF with default setting
>> ok 2 8a92 - Create HHF with limit setting
>> ok 3 3491 - Create HHF with quantum setting
>> ok 4 ba04 - Create HHF with reset_timeout setting
>> ok 5 4238 - Create HHF with admit_bytes setting
>> ok 6 839f - Create HHF with evict_timeout setting
>> ok 7 a044 - Create HHF with non_hh_weight setting
>> ok 8 32f9 - Change HHF with limit setting
>> ok 9 385e - Show HHF class
>>
>> ./tdc.py -c pfifo_fast
>> ok 1 900c - Create pfifo_fast with default setting
>> ok 2 7470 - Dump pfifo_fast stats
>> ok 3 b974 - Replace pfifo_fast with different handle
>> ok 4 3240 - Delete pfifo_fast with valid handle
>> ok 5 4385 - Delete pfifo_fast with invalid handle
>>
>> ./tdc.py -c plug
>> ok 1 3289 - Create PLUG with default setting
>> ok 2 0917 - Create PLUG with block setting
>> ok 3 483b - Create PLUG with release setting
>> ok 4 4995 - Create PLUG with release_indefinite setting
>> ok 5 389c - Create PLUG with limit setting
>> ok 6 384a - Delete PLUG with valid handle
>> ok 7 439a - Replace PLUG with limit setting
>> ok 8 9831 - Change PLUG with limit setting
>>
>> ./tdc.py -c sfb
>> ok 1 3294 - Create SFB with default setting
>> ok 2 430a - Create SFB with rehash setting
>> ok 3 3410 - Create SFB with db setting
>> ok 4 49a0 - Create SFB with limit setting
>> ok 5 1241 - Create SFB with max setting
>> ok 6 3249 - Create SFB with target setting
>> ok 7 30a9 - Create SFB with increment setting
>> ok 8 239a - Create SFB with decrement setting
>> ok 9 9301 - Create SFB with penalty_rate setting
>> ok 10 2a01 - Create SFB with penalty_burst setting
>> ok 11 3209 - Change SFB with rehash setting
>> ok 12 5447 - Show SFB class
>>
>> ./tdc.py -c sfq
>> ok 1 7482 - Create SFQ with default setting
>> ok 2 c186 - Create SFQ with limit setting
>> ok 3 ae23 - Create SFQ with perturb setting
>> ok 4 a430 - Create SFQ with quantum setting
>> ok 5 4539 - Create SFQ with divisor setting
>> ok 6 b089 - Create SFQ with flows setting
>> ok 7 99a0 - Create SFQ with depth setting
>> ok 8 7389 - Create SFQ with headdrop setting
>> ok 9 6472 - Create SFQ with redflowlimit setting
>> ok 10 8929 - Show SFQ class
>>
>> ./tdc.py -c skbprio
>> ok 1 283e - Create skbprio with default setting
>> ok 2 c086 - Create skbprio with limit setting
>> ok 3 6733 - Change skbprio with limit setting
>> ok 4 2958 - Show skbprio class
>>
>> ./tdc.py -c taprio
>> ok 1 ba39 - Add taprio Qdisc to multi-queue device (8 queues)
>> ok 2 9462 - Add taprio Qdisc with multiple sched-entry
>> ok 3 8d92 - Add taprio Qdisc with txtime-delay
>> ok 4 d092 - Delete taprio Qdisc with valid handle
>> ok 5 8471 - Show taprio class
>> ok 6 0a85 - Add taprio Qdisc to single-queue device
>>
>> ./tdc.py -c tbf
>> ok 1 6430 - Create TBF with default setting
>> ok 2 0518 - Create TBF with mtu setting
>> ok 3 320a - Create TBF with peakrate setting
>> ok 4 239b - Create TBF with latency setting
>> ok 5 c975 - Create TBF with overhead setting
>> ok 6 948c - Create TBF with linklayer setting
>> ok 7 3549 - Replace TBF with mtu
>> ok 8 f948 - Change TBF with latency time
>> ok 9 2348 - Show TBF class
>>
>> ./tdc.py -c teql
>> ok 1 84a0 - Create TEQL with default setting
>> ok 2 7734 - Create TEQL with multiple device
>> ok 3 34a9 - Delete TEQL with valid handle
>> ok 4 6289 - Show TEQL stats
>>
>> ---
>> v2: modify subject prefix
>> ---
>> Zhengchao Shao (15):
>>    selftests/tc-testing: add selftests for atm qdisc
>>    selftests/tc-testing: add selftests for choke qdisc
>>    selftests/tc-testing: add selftests for codel qdisc
>>    selftests/tc-testing: add selftests for etf qdisc
>>    selftests/tc-testing: add selftests for fq qdisc
>>    selftests/tc-testing: add selftests for gred qdisc
>>    selftests/tc-testing: add selftests for hhf qdisc
>>    selftests/tc-testing: add selftests for pfifo_fast qdisc
>>    selftests/tc-testing: add selftests for plug qdisc
>>    selftests/tc-testing: add selftests for sfb qdisc
>>    selftests/tc-testing: add selftests for sfq qdisc
>>    selftests/tc-testing: add selftests for skbprio qdisc
>>    selftests/tc-testing: add selftests for taprio qdisc
>>    selftests/tc-testing: add selftests for tbf qdisc
>>    selftests/tc-testing: add selftests for teql qdisc
>>
>>   .../tc-testing/tc-tests/qdiscs/atm.json       |  94 +++++
>>   .../tc-testing/tc-tests/qdiscs/choke.json     | 188 +++++++++
>>   .../tc-testing/tc-tests/qdiscs/codel.json     | 211 ++++++++++
>>   .../tc-testing/tc-tests/qdiscs/etf.json       | 117 ++++++
>>   .../tc-testing/tc-tests/qdiscs/fq.json        | 395 ++++++++++++++++++
>>   .../tc-testing/tc-tests/qdiscs/gred.json      | 164 ++++++++
>>   .../tc-testing/tc-tests/qdiscs/hhf.json       | 210 ++++++++++
>>   .../tc-tests/qdiscs/pfifo_fast.json           | 119 ++++++
>>   .../tc-testing/tc-tests/qdiscs/plug.json      | 188 +++++++++
>>   .../tc-testing/tc-tests/qdiscs/sfb.json       | 279 +++++++++++++
>>   .../tc-testing/tc-tests/qdiscs/sfq.json       | 232 ++++++++++
>>   .../tc-testing/tc-tests/qdiscs/skbprio.json   |  95 +++++
>>   .../tc-testing/tc-tests/qdiscs/taprio.json    | 135 ++++++
>>   .../tc-testing/tc-tests/qdiscs/tbf.json       | 211 ++++++++++
>>   .../tc-testing/tc-tests/qdiscs/teql.json      |  97 +++++
>>   15 files changed, 2735 insertions(+)
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/atm.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/choke.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/codel.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/etf.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/fq.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/gred.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/hhf.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/pfifo_fast.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/plug.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfb.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/sfq.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/skbprio.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/taprio.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/tbf.json
>>   create mode 100644 
>> tools/testing/selftests/tc-testing/tc-tests/qdiscs/teql.json
> 
> 
> When adding new test case files, you should add any necessary configs 
> needed to
> run them in tools/testing/selftests/tc-testing/config, if they aren't 
> already there.
> 
> For example, your ATM patch should also add the following config options 
> to that file:
> 
> CONFIG_ATM=y
> CONFIG_NET_SCH_ATM=m
> 
> 
Hi Victor：
	Thank you for your testing. I will add config in V3. It might be
better to generate executable test suites based on kernel config.
However, this feature does not seem to be supported currently. Or This 
feature can be added later.

Zhengchao Shao
