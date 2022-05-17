Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A9D529A6B
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 09:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233865AbiEQHGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 03:06:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235637AbiEQHFy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 03:05:54 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A8F76356
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i1so16561128plg.7
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 00:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=wuqROjGK5NGFVKd47141nF0XHj01jigssNIAbAq8B7w=;
        b=TwiatshiqLTe6R9OtUH8skwX03a0UE77zNGTyfDoIfR/3ZEerC9XS/Lx4GoMYbPfU5
         zntS8jK5Kj2ShMWTd7YYBr40HJ5nfaRudQDZAwBUGt0h6gcuHbAP8LRMld+osh8H63E4
         zqbAfe7+MxBOF+IpX6Q9+PGuodYki5I7YJ/h0CVqDXbB8TrWlJ7s734aY35SyxkksWvc
         bGnJdFwau8UVSQuu7GSTCE2ZqzVuh42u/1rcPIh9B4VSTj/k7h9hjEB9xMwpzW41NEIP
         wuwEJs7wsQ/fSh5SYdITgfW+3gu+vWWNSTIE7kssIk8izpsn/fnWCwgUWAmhxdjKC6tv
         k43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wuqROjGK5NGFVKd47141nF0XHj01jigssNIAbAq8B7w=;
        b=Q2675syzGKqOVNjnGa9zudayeOSMaf/Gi27sLi1sSMSqeXpvJD9/V/w4oj3dI91pxp
         ld//ofJ7HZ7fLFz8YFPKVwsjgQdREihNuhmjy8wr/VISGsxe24tL9Guj+ZCd3mxZs7RW
         vTh2adSCfyHIp5qh1fD7VE5XHF9xMJBbbxCgKTiF4n/z68G2nk/MCJ4cw0h8NZ9PMR8a
         ZWmoIfsAw4UvUYeDPH5/+rE5450ayJ5Eb8UwtWbnxoSWT7Ef12JWdZqUUR+z7v0LD8sR
         oxHDNHZpYMMRCGsoGkpbxyiehaDoI6ZdRxWV766dtXFhF/HMdGQ8wit5TSPQtI2lloQe
         KgRg==
X-Gm-Message-State: AOAM533h/U4UH+YGUD5kMgO3V3DSmUSDRa0PN3B7DhJllXsBKaPN8KLJ
        zd7kjGWnI6/jpJUFwYl+UatfdQ==
X-Google-Smtp-Source: ABdhPJxOxQjsL6w9g0OLpHPCjF+bnU3XWXaFNVPHygxmeypO7lQGstrEd7PdWU4Q87yKtJNiFpHfmg==
X-Received: by 2002:a17:90b:48c6:b0:1df:99d9:997f with SMTP id li6-20020a17090b48c600b001df99d9997fmr35838pjb.242.1652771151939;
        Tue, 17 May 2022 00:05:51 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id e17-20020a62ee11000000b0050dc76281b8sm8188698pfi.146.2022.05.17.00.05.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 May 2022 00:05:51 -0700 (PDT)
Message-ID: <44a30595-6a50-6ded-5ecc-18fd1e56abda@bytedance.com>
Date:   Tue, 17 May 2022 15:05:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [External] Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
To:     Yonghong Song <yhs@fb.com>, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, jolsa@kernel.org, davemarchevsky@fb.com,
        joannekoong@fb.com, geliang.tang@suse.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, duanxiongchun@bytedance.com,
        songmuchun@bytedance.com, wangdongdong.6@bytedance.com,
        cong.wang@bytedance.com, zhouchengming@bytedance.com,
        yosryahmed@google.com
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
 <80ab09cf-6072-a75a-082d-2721f6f907ef@fb.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <80ab09cf-6072-a75a-082d-2721f6f907ef@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/17 上午11:09, Yonghong Song 写道:
>
>
> On 5/15/22 7:24 PM, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> comments from Andrii Nakryiko, details in here:
>> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/ 
>>
>>
>> use /* */ instead of //
>> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
>> use 8 bytes for value size
>> fix memory leak
>> use ASSERT_EQ instead of ASSERT_OK
>> add bpf_loop to fetch values on each possible CPU
>>
>> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add 
>> test case for bpf_map_lookup_percpu_elem")
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>
> LGTM with a few nits below.
> Acked-by: Yonghong Song <yhs@fb.com>
>
Ok, will do. Thanks.

>> ---
>>   .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
>>   .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-------
>>   2 files changed, 70 insertions(+), 40 deletions(-)
>>
>> diff --git 
>> a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c 
>> b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> index 58b24c2112b0..89ca170f1c25 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> @@ -1,30 +1,39 @@
>> -// SPDX-License-Identifier: GPL-2.0
>> -// Copyright (c) 2022 Bytedance
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (c) 2022 Bytedance */
>>     #include <test_progs.h>
>
> The above empty line is unnecessary.
>
>>   #include "test_map_lookup_percpu_elem.skel.h"
>>   -#define TEST_VALUE  1
>> -
>>   void test_map_lookup_percpu_elem(void)
>>   {
>>       struct test_map_lookup_percpu_elem *skel;
>> -    int key = 0, ret;
>> -    int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>> -    int *buf;
>> +    __u64 key = 0, sum;
>> +    int ret, i;
>> +    int nr_cpus = libbpf_num_possible_cpus();
>> +    __u64 *buf;
>>   -    buf = (int *)malloc(nr_cpus*sizeof(int));
>> +    buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));
>>       if (!ASSERT_OK_PTR(buf, "malloc"))
>>           return;
>> -    memset(buf, 0, nr_cpus*sizeof(int));
>> -    buf[0] = TEST_VALUE;
>>   -    skel = test_map_lookup_percpu_elem__open_and_load();
>> -    if (!ASSERT_OK_PTR(skel, 
>> "test_map_lookup_percpu_elem__open_and_load"))
>> -        return;
>> +    for (i=0; i<nr_cpus; i++)
>> +        buf[i] = i;
>> +    sum = (nr_cpus-1)*nr_cpus/2;
>> +
>> +    skel = test_map_lookup_percpu_elem__open();
>> +    if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
>> +        goto exit;
>> +
>> +    skel->rodata->nr_cpus = nr_cpus;
>> +
>> +    ret = test_map_lookup_percpu_elem__load(skel);
>> +    if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
>> +        goto cleanup;
>> +
>>       ret = test_map_lookup_percpu_elem__attach(skel);
>> -    ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
>> +    if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
>> +        goto cleanup;
>>         ret = 
>> bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, 
>> buf, 0);
>>       ASSERT_OK(ret, "percpu_array_map update");
>> @@ -37,10 +46,14 @@ void test_map_lookup_percpu_elem(void)
>>         syscall(__NR_getuid);
>>   -    ret = skel->bss->percpu_array_elem_val == TEST_VALUE &&
>> -          skel->bss->percpu_hash_elem_val == TEST_VALUE &&
>> -          skel->bss->percpu_lru_hash_elem_val == TEST_VALUE;
>> -    ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");
>> +    test_map_lookup_percpu_elem__detach(skel);
>> +
>> +    ASSERT_EQ(skel->bss->percpu_array_elem_sum, sum, "percpu_array 
>> lookup percpu elem");
>> +    ASSERT_EQ(skel->bss->percpu_hash_elem_sum, sum, "percpu_hash 
>> lookup percpu elem");
>> +    ASSERT_EQ(skel->bss->percpu_lru_hash_elem_sum, sum, 
>> "percpu_lru_hash lookup percpu elem");
>>   +cleanup:
>>       test_map_lookup_percpu_elem__destroy(skel);
>> +exit:
>> +    free(buf);
>>   }
> [...]
>> +struct read_percpu_elem_ctx {
>> +    void *map;
>> +    __u64 sum;
>> +};
>> +
>> +static int read_percpu_elem_callback(__u32 index, struct 
>> read_percpu_elem_ctx *ctx)
>> +{
>> +    __u64 key = 0;
>> +    __u64 *value;
>
> Please add an empty line here.
>
>> +    value = bpf_map_lookup_percpu_elem(ctx->map, &key, index);
>> +    if (value)
>> +        ctx->sum += *value;
>> +    return 0;
>> +}
>> +
> [...]


