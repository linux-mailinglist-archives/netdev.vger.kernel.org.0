Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23BA5FD2AA
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:37:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229843AbiJMBg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiJMBg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:36:57 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728741285C6;
        Wed, 12 Oct 2022 18:36:56 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4MnsSy47YjzlVlT;
        Thu, 13 Oct 2022 09:32:18 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 13 Oct 2022 09:36:53 +0800
Message-ID: <cda0bc3d-9587-6b5e-e676-4e3bd11e95da@huawei.com>
Date:   Thu, 13 Oct 2022 09:36:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v4 6/6] selftest/bpf: Fix error usage of
 ASSERT_OK in xdp_adjust_tail.c
Content-Language: en-US
To:     Martin KaFai Lau <martin.lau@linux.dev>,
        Xu Kuohai <xukuohai@huaweicloud.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Delyan Kratunov <delyank@fb.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>
References: <20221011120108.782373-1-xukuohai@huaweicloud.com>
 <20221011120108.782373-7-xukuohai@huaweicloud.com>
 <33d17f23-03cb-9bff-2e50-06ab0f597640@linux.dev>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <33d17f23-03cb-9bff-2e50-06ab0f597640@linux.dev>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/2022 7:26 AM, Martin KaFai Lau wrote:
> On 10/11/22 5:01 AM, Xu Kuohai wrote:
>> From: Xu Kuohai <xukuohai@huawei.com>
>>
>> xdp_adjust_tail.c calls ASSERT_OK() to check the return value of
>> bpf_prog_test_load(), but the condition is not correct. Fix it.
>>
>> Fixes: 791cad025051 ("bpf: selftests: Get rid of CHECK macro in xdp_adjust_tail.c")
>> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> index 009ee37607df..39973ea1ce43 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_adjust_tail.c
>> @@ -18,7 +18,7 @@ static void test_xdp_adjust_tail_shrink(void)
>>       );
>>       err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>> -    if (ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
>> +    if (!ASSERT_OK(err, "test_xdp_adjust_tail_shrink"))
>>           return;
>>       err = bpf_prog_test_run_opts(prog_fd, &topts);
>> @@ -53,7 +53,7 @@ static void test_xdp_adjust_tail_grow(void)
>>       );
>>       err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>> -    if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
>> +    if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
> 
> Ouch... ic.  It is why this test has been passing.
> 

Well, it's because the value of err is zero, so ASSERT_OK passed.

> 
>>           return;
>>       err = bpf_prog_test_run_opts(prog_fd, &topts);
>> @@ -90,7 +90,7 @@ static void test_xdp_adjust_tail_grow2(void)
>>       );
>>       err = bpf_prog_test_load(file, BPF_PROG_TYPE_XDP, &obj, &prog_fd);
>> -    if (ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
>> +    if (!ASSERT_OK(err, "test_xdp_adjust_tail_grow"))
>>           return;
>>       /* Test case-64 */
> 
> .

