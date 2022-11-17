Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0052462D0E5
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 03:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiKQCAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 21:00:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbiKQCAD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 21:00:03 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13E5F60EB1;
        Wed, 16 Nov 2022 18:00:02 -0800 (PST)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NCNQ85gmzzHvxb;
        Thu, 17 Nov 2022 09:59:28 +0800 (CST)
Received: from [10.174.179.191] (10.174.179.191) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 17 Nov 2022 09:59:52 +0800
Message-ID: <2d5eb774-f327-9c92-8be7-a1a1f3c6fa98@huawei.com>
Date:   Thu, 17 Nov 2022 09:59:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH v2 2/2] selftests/net: fix opening object file failed
To:     Saeed Mahameed <saeed@kernel.org>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <shuah@kernel.org>, <andrii@kernel.org>,
        <mykolal@fb.com>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <martin.lau@linux.dev>
References: <1668507800-45450-1-git-send-email-wangyufen@huawei.com>
 <1668507800-45450-3-git-send-email-wangyufen@huawei.com>
 <Y3VfeXK092oeV+yh@x130.lan>
From:   wangyufen <wangyufen@huawei.com>
In-Reply-To: <Y3VfeXK092oeV+yh@x130.lan>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.191]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/11/17 6:08, Saeed Mahameed 写道:
> On 15 Nov 18:23, Wang Yufen wrote:
>> The program file used in the udpgro_frglist testcase is 
>> "../bpf/nat6to4.o",
>> but the actual nat6to4.o file is in "bpf/" not "../bpf".
>> The following error occurs:
>>  Error opening object ../bpf/nat6to4.o: No such file or directory
>>  Cannot initialize ELF context!
>>  Unable to load program
>>
>> In addition, all the kernel bpf source files are centred under the
>> subdir "progs" after commit bd4aed0ee73c ("selftests: bpf: centre
>> kernel bpf objects under new subdir "progs""). So mv nat6to4.c to
>                                                    ^^ move :)
got it :)

>> "../bpf/progs" and use "../bpf/nat6to4.bpf.o". And also move the
>> test program to selftests/bpf.
>>
> 
> Can you separate the fix from the mv ?
got it, will change in v3

> 
>> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf 
>> self-tests")
>> Signed-off-by: Wang Yufen <wangyufen@huawei.com>
>> ---
>> tools/testing/selftests/bpf/Makefile               |   7 +-
>> tools/testing/selftests/bpf/in_netns.sh            |  23 +
>> .../testing/selftests/bpf/progs/nat6to4_egress4.c  | 184 ++++++
>> .../testing/selftests/bpf/progs/nat6to4_ingress6.c | 149 +++++
>> tools/testing/selftests/bpf/test_udpgro_frglist.sh | 110 ++++
>> tools/testing/selftests/bpf/udpgso_bench_rx.c      | 409 ++++++++++++
>> tools/testing/selftests/bpf/udpgso_bench_tx.c      | 712 
>> +++++++++++++++++++++
>> tools/testing/selftests/net/Makefile               |   2 -
>> tools/testing/selftests/net/bpf/Makefile           |  14 -
>> tools/testing/selftests/net/bpf/nat6to4.c          | 285 ---------
>> tools/testing/selftests/net/udpgro_frglist.sh      | 103 ---
>> 11 files changed, 1592 insertions(+), 406 deletions(-)
>> create mode 100755 tools/testing/selftests/bpf/in_netns.sh
>> create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_egress4.c
>> create mode 100644 tools/testing/selftests/bpf/progs/nat6to4_ingress6.c
>> create mode 100755 tools/testing/selftests/bpf/test_udpgro_frglist.sh
>> create mode 100644 tools/testing/selftests/bpf/udpgso_bench_rx.c
>> create mode 100644 tools/testing/selftests/bpf/udpgso_bench_tx.c
>> delete mode 100644 tools/testing/selftests/net/bpf/Makefile
>> delete mode 100644 tools/testing/selftests/net/bpf/nat6to4.c
>> delete mode 100755 tools/testing/selftests/net/udpgro_frglist.sh
>>
> 
> created more files than deleted? also moving files should appear as
> rename. Did you do the mv with git mv ? I am surprised how git didn't 
> pick this up
> as "rename".
in_netns.sh,udpgso_bench_rx.c and udpgso_bench_tx.c also used by other 
tests of selftests/net, so create new copy here.
The two progs of nat6to4.c are separately defined in nat6to4_ingress6.c 
and nat6to4_egress4.c files. SEC("schedcls/ingress6/nat_6") and 
SEC("schedcls/egress4/snat4") are defined as SEC ("tc").
I will separate the fix from the mv in v3
> 
> For next version please use tag [PATCH bpf-next]
got it.
Thanks.


