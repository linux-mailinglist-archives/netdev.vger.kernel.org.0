Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67EA56A170
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 13:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235276AbiGGL6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 07:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235374AbiGGL5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 07:57:19 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94AE3564E3;
        Thu,  7 Jul 2022 04:55:27 -0700 (PDT)
Received: from dggpemm500021.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Ldvtp1QRYzkX3X;
        Thu,  7 Jul 2022 19:53:22 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500021.china.huawei.com (7.185.36.109) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 19:55:25 +0800
Received: from [10.67.109.184] (10.67.109.184) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 7 Jul 2022 19:55:25 +0800
Subject: Re: [PATCH bpf-next v3 6/6] selftests/bpf: Remove the casting about
 jited_ksyms and jited_linfo
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     bpf <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
References: <20220530092815.1112406-1-pulehui@huawei.com>
 <20220530092815.1112406-7-pulehui@huawei.com>
 <CAEf4Bza4RT=KFhr9ev29967dyT0eF_+6ZRqK35beUvnA_NbcqQ@mail.gmail.com>
From:   Pu Lehui <pulehui@huawei.com>
Message-ID: <09b87170-09e1-167f-4afa-ed516fa688ac@huawei.com>
Date:   Thu, 7 Jul 2022 19:55:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAEf4Bza4RT=KFhr9ev29967dyT0eF_+6ZRqK35beUvnA_NbcqQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.109.184]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2022/6/4 5:05, Andrii Nakryiko wrote:
> On Mon, May 30, 2022 at 1:58 AM Pu Lehui <pulehui@huawei.com> wrote:
>>
>> We have unified data extension operation of jited_ksyms and jited_linfo
>> into zero extension, so there's no need to cast u64 memory address to
>> long data type.
>>
>> Signed-off-by: Pu Lehui <pulehui@huawei.com>
>> ---
>>   tools/testing/selftests/bpf/prog_tests/btf.c | 14 +++++++-------
>>   1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
>> index e6612f2bd0cf..65bdc4aa0a63 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
>> @@ -6599,8 +6599,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>>          }
>>
>>          if (CHECK(jited_linfo[0] != jited_ksyms[0],
>> -                 "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
>> -                 (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
>> +                 "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
>> +                 jited_linfo[0], jited_ksyms[0])) {
> 
> __u64 is not always printed with %lld, on some platforms it is
> actually %ld, so to avoid compiler warnings we just cast them to long
> long or unsigned long long (and then %lld or %llu is fine). So please
> update this part here and below.
> 

I found that __u64 in ppc64 actually is defined to be unsigned long. I 
will update it. Thanks.

>>                  err = -1;
>>                  goto done;
>>          }
>> @@ -6618,16 +6618,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>>                  }
>>
>>                  if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
>> -                         "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
>> -                         i, (long)jited_linfo[i],
>> -                         i - 1, (long)(jited_linfo[i - 1]))) {
>> +                         "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
>> +                         i, jited_linfo[i],
>> +                         i - 1, jited_linfo[i - 1])) {
>>                          err = -1;
>>                          goto done;
>>                  }
>>
>>                  if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
>> -                         "jited_linfo[%u]:%lx - %lx > %u",
>> -                         i, (long)jited_linfo[i], (long)cur_func_ksyms,
>> +                         "jited_linfo[%u]:%llx - %llx > %u",
>> +                         i, jited_linfo[i], cur_func_ksyms,
>>                            cur_func_len)) {
>>                          err = -1;
>>                          goto done;
>> --
>> 2.25.1
>>
> .
> 
