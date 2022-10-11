Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1D3E5FACCE
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiJKGaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJKGaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:30:07 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431963DF1A;
        Mon, 10 Oct 2022 23:30:05 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Mmm3h2RndzHtf8;
        Tue, 11 Oct 2022 14:25:04 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 11 Oct 2022 14:30:02 +0800
Message-ID: <5311e154-c2d4-91a5-ccb8-f5adede579ed@huawei.com>
Date:   Tue, 11 Oct 2022 14:30:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf v3 0/6] Fix bugs found by ASAN when running selftests
Content-Language: en-US
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
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
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <20221010142553.776550-1-xukuohai@huawei.com>
 <CAEf4Bzbt1_J=bzsSmO-xX=Ubi9UeGj8swQT7c1pZt_ay1npZhw@mail.gmail.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <CAEf4Bzbt1_J=bzsSmO-xX=Ubi9UeGj8swQT7c1pZt_ay1npZhw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/11/2022 9:37 AM, Andrii Nakryiko wrote:
> On Mon, Oct 10, 2022 at 7:08 AM Xu Kuohai <xukuohai@huawei.com> wrote:
>>
> 
> Thanks for the fixes! I left a few comments in a few patches, please
> address those. But also
> please provide a commit message, even if a single line one. Kernel
> style dictates that the commit message shouldn't be empty.
> 

Will do, thanks

> And I think none of these fixes are critical enough to go to bpf tree,
> please target bpf-next for next revision. Thanks.
> 

Ok, will target to bpf-next branch, targeting bpf tree just because
Documentation/bpf/bpf_devel_QA.rst says bpf-next is for features

> 
>> v3:
>> - Fix error failure of case test_xdp_adjust_tail_grow exposed by this series
>>
>> v2: https://lore.kernel.org/bpf/20221010070454.577433-1-xukuohai@huaweicloud.com
>> - Rebase and fix conflict
>>
>> v1: https://lore.kernel.org/bpf/20221009131830.395569-1-xukuohai@huaweicloud.com
>>
>> Xu Kuohai (6):
>>    libbpf: Fix use-after-free in btf_dump_name_dups
>>    libbpf: Fix memory leak in parse_usdt_arg()
>>    selftests/bpf: Fix memory leak caused by not destroying skeleton
>>    selftest/bpf: Fix memory leak in kprobe_multi_test
>>    selftests/bpf: Fix error failure of case test_xdp_adjust_tail_grow
>>    selftest/bpf: Fix error usage of ASSERT_OK in xdp_adjust_tail.c
>>
>>   tools/lib/bpf/btf_dump.c                      | 47 +++++++++++----
>>   tools/lib/bpf/usdt.c                          | 59 +++++++++++--------
>>   .../bpf/prog_tests/kprobe_multi_test.c        | 17 +++---
>>   .../selftests/bpf/prog_tests/map_kptr.c       |  3 +-
>>   .../selftests/bpf/prog_tests/tracing_struct.c |  3 +-
>>   .../bpf/prog_tests/xdp_adjust_tail.c          |  7 ++-
>>   6 files changed, 86 insertions(+), 50 deletions(-)
>>
>> --
>> 2.30.2
>>
> .

