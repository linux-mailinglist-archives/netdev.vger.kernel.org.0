Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F868578161
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233990AbiGRL5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:57:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiGRL5g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:57:36 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 952BF23177;
        Mon, 18 Jul 2022 04:57:34 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4LmgRM69kXzFq8d;
        Mon, 18 Jul 2022 19:56:31 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 19:57:32 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 19:57:32 +0800
Subject: Re: [PATCH bpf-next 5/5] selftests/bpf: Remove the casting about
 jited_ksyms and jited_linfo
To:     Yonghong Song <yhs@fb.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20220716125108.1011206-1-pulehui@huawei.com>
 <20220716125108.1011206-6-pulehui@huawei.com>
 <f0f31c00-c4a2-1df2-01f7-4e74685ee019@fb.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <90d2c163-0900-0eb7-6d5c-c6e7ab530fa1@huawei.com>
Date:   Mon, 18 Jul 2022 19:57:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <f0f31c00-c4a2-1df2-01f7-4e74685ee019@fb.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/7/17 9:46, Yonghong Song wrote:
> 
> 
> On 7/16/22 5:51 AM, Pu Lehui wrote:
>> We have unified data extension operation of jited_ksyms and jited_linfo
>> into zero extension, so there's no need to cast u64 memory address to
>> long data type.
> 
> For subject, we are not 'Remove the casting ...'. What the code did is
> to change the casting.
> 
> Also, I don't understand the above commit message. What does this mean
> about 'data extension operation of jited_ksyms and jited_linfo into zero 
> extension'?
> 
> In prog_tests/btf.c, we have a few other places to cast 
> jited_linfo[...]/jited_ksyms[...] to 'long' type. Maybe casting
> to 'unsigned long' is a better choice. Casting to 'unsigned long long'
> of course will work, but is it necessary? Or you are talking about
> 64bit kernel and 32bit user space?
> 

Hi Yonghong,

Thanks for your review. We introduced riscv jited line info in series 
[0], and we found that 32-bit systems can not display bpf line info due 
to the inconsistent data extension between jited_ksyms and jited_linfo. 
And we finally unify them to zero extension. By the way, we cleanup the 
related code. jited_ksyms and jited_linfo both are u64 address, no need 
to casting to long, and we previously remove it. But u64 in some arch is 
%ld, so to avoid compiler warnings we just cast to unsigned long long.

And sorry for not updating the subject and comment. I will corret it.

[0] 
https://lore.kernel.org/bpf/CAEf4Bza4RT=KFhr9ev29967dyT0eF_+6ZRqK35beUvnA_NbcqQ@mail.gmail.com/

>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/prog_tests/btf.c | 16 +++++++++-------
>>   1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c 
>> b/tools/testing/selftests/bpf/prog_tests/btf.c
>> index e852a9df779d..db10fa1745d1 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
>> @@ -6613,8 +6613,9 @@ static int test_get_linfo(const struct 
>> prog_info_raw_test *test,
>>       }
>>       if (CHECK(jited_linfo[0] != jited_ksyms[0],
>> -          "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
>> -          (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
>> +          "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
>> +          (unsigned long long)(jited_linfo[0]),
>> +          (unsigned long long)(jited_ksyms[0]))) {
>>           err = -1;
>>           goto done;
>>       }
>> @@ -6632,16 +6633,17 @@ static int test_get_linfo(const struct 
>> prog_info_raw_test *test,
>>           }
>>           if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
>> -              "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
>> -              i, (long)jited_linfo[i],
>> -              i - 1, (long)(jited_linfo[i - 1]))) {
>> +              "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
>> +              i, (unsigned long long)jited_linfo[i],
>> +              i - 1, (unsigned long long)(jited_linfo[i - 1]))) {
>>               err = -1;
>>               goto done;
>>           }
>>           if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
>> -              "jited_linfo[%u]:%lx - %lx > %u",
>> -              i, (long)jited_linfo[i], (long)cur_func_ksyms,
>> +              "jited_linfo[%u]:%llx - %llx > %u",
>> +              i, (unsigned long long)jited_linfo[i],
>> +              (unsigned long long)cur_func_ksyms,
>>                 cur_func_len)) {
>>               err = -1;
>>               goto done;
> .
