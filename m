Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 769CF525983
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 03:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376405AbiEMBtu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 21:49:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376400AbiEMBtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 21:49:49 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5BC227F11C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:49:47 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id e24so6803010pjt.2
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 18:49:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=DXT5U5/unhwYiHaEsAheDw/cqhHfh/fCCJoi5qtw7ns=;
        b=F0xYx6bDiiXb757drwnmvVm4vISBgBumZL6FskV7MtQj1vP0JwDMILNchBUwbt6M8W
         cldW/RGJ0hISLHrMhg+WiQ4FP0zYC8tWYVR1lE4raT8Dvv4M7iC3rZNKCszHHl54Zy8o
         9e7E3PR9Q+AXiA8bqEgamCoQit5nt/aWXj12lD3IR73KpkkTSyppLGCRoSF1NuegfRVq
         hcTLvmRlwQj5uu4CTMseDFfeoy2juBicUaDtU9m6FQRKOBMIHdLtidwWk0hz4/8TZ2Ip
         6kMDM+IOMbfsMGuOYexffaRVdgk39EnO0p8nfYEA98H7zZMfCucCcfVuiOEVCd397duD
         WOkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DXT5U5/unhwYiHaEsAheDw/cqhHfh/fCCJoi5qtw7ns=;
        b=CdmZOGZ93dVmsVqCsZOH7fDhYBNHvbb90QoxYgmqVyjG8To26clI0IYKAErQ7Mlq1L
         x+Ul1odM+GIgFnSt0Wj8od2jsCDBpUFL2GkZz9BRmz+La3k+mql+gOd5/84foHSTOZJB
         53RmCiHM4dUtKz4AJESLg/EKsLxb4XnN3PMAKYJiwYlhrLJ7nwl/abK/pB3rZdfEmCum
         hDpK6TA1Xb7uqKu2Z71trtmhrd1y/UlA7g/kqwNLVw2bNhTItBgD5QLm9ya7KazDAM9S
         Rv/aLbDgHlC2Mf4i4vCEF4RO3smR3Sl10zPHD5wxqtfp9qfeiX9S7/lPHVmBGlGKWuJg
         iyuQ==
X-Gm-Message-State: AOAM532glspsslIAnaAQWRz9lrw7HCL+6sAD79DAcrhiF6kM00CQD+Ep
        0Q6NTlP0OEgpl+UKe4j6yI/0xQ==
X-Google-Smtp-Source: ABdhPJxr6xeF/KoMq1f+Qiv40Ek4BJVeeBVBOz6+/nwI6/JQb0fsp9K+rbBOmAsjP2TKfswr1gsffg==
X-Received: by 2002:a17:90a:c797:b0:1d9:2764:a83b with SMTP id gn23-20020a17090ac79700b001d92764a83bmr13438928pjb.5.1652406587193;
        Thu, 12 May 2022 18:49:47 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id i1-20020a056a00224100b0050dc7628142sm474474pfu.28.2022.05.12.18.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 18:49:46 -0700 (PDT)
Message-ID: <2e331f2e-c481-df3b-f810-5bb867c5c3df@bytedance.com>
Date:   Fri, 13 May 2022 09:49:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [External] Re: [PATCH bpf-next v2 2/2] selftests/bpf: add test
 case for bpf_map_lookup_percpu_elem
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joanne Koong <joannekoong@fb.com>,
        Geliang Tang <geliang.tang@suse.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        duanxiongchun@bytedance.com,
        Muchun Song <songmuchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        zhouchengming@bytedance.com, yosryahmed@google.com
References: <20220511093854.411-1-zhoufeng.zf@bytedance.com>
 <20220511093854.411-3-zhoufeng.zf@bytedance.com>
 <CAEf4BzZL85C7KUwKv9i5cdLSDzM175cLjiW4EDjOqNfcxbLO+A@mail.gmail.com>
 <731c281a-9911-fa86-fec2-a3c1a3954461@bytedance.com>
 <CAEf4BzY5HmNVgUH_bmoXfCubgosmmJ3N1gip_vrLGQEo=XV8gg@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzY5HmNVgUH_bmoXfCubgosmmJ3N1gip_vrLGQEo=XV8gg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/13 上午12:43, Andrii Nakryiko 写道:
> On Wed, May 11, 2022 at 8:58 PM Feng Zhou <zhoufeng.zf@bytedance.com> wrote:
>> 在 2022/5/12 上午11:34, Andrii Nakryiko 写道:
>>> On Wed, May 11, 2022 at 2:39 AM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>>>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>>
>>>> test_progs:
>>>> Tests new ebpf helpers bpf_map_lookup_percpu_elem.
>>>>
>>>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>>>> ---
>>>>    .../bpf/prog_tests/map_lookup_percpu_elem.c   | 46 ++++++++++++++++
>>>>    .../bpf/progs/test_map_lookup_percpu_elem.c   | 54 +++++++++++++++++++
>>>>    2 files changed, 100 insertions(+)
>>>>    create mode 100644 tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>>    create mode 100644 tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
>>>>
>>>> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>> new file mode 100644
>>>> index 000000000000..58b24c2112b0
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>>>> @@ -0,0 +1,46 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +// Copyright (c) 2022 Bytedance
>>> /* */ instead of //
>> Ok, I will do. Thanks.
>>
>>
>>>> +
>>>> +#include <test_progs.h>
>>>> +
>>>> +#include "test_map_lookup_percpu_elem.skel.h"
>>>> +
>>>> +#define TEST_VALUE  1
>>>> +
>>>> +void test_map_lookup_percpu_elem(void)
>>>> +{
>>>> +       struct test_map_lookup_percpu_elem *skel;
>>>> +       int key = 0, ret;
>>>> +       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>>> I think this is actually wrong and will break selftests on systems
>>> with offline CPUs. Please use libbpf_num_possible_cpus() instead.
>>
>> Ok, I will do. Thanks.
>>
>>
>>>> +       int *buf;
>>>> +
>>>> +       buf = (int *)malloc(nr_cpus*sizeof(int));
>>>> +       if (!ASSERT_OK_PTR(buf, "malloc"))
>>>> +               return;
>>>> +       memset(buf, 0, nr_cpus*sizeof(int));
>>> this is wrong, kernel expects to have roundup(sz, 8) per each CPU,
>>> while you have just 4 bytes per each element
>>>
>>> please also have spaces around multiplication operator here and above
>>
>> Ok, I will use 8 bytes for key and val. Thanks.
>>
>>
>>>> +       buf[0] = TEST_VALUE;
>>>> +
>>>> +       skel = test_map_lookup_percpu_elem__open_and_load();
>>>> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
>>>> +               return;
>>> buf leaking here
>>
>> Yes, sorry for my negligence.
>>
>>
>>>> +       ret = test_map_lookup_percpu_elem__attach(skel);
>>>> +       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
>>>> +
>>>> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
>>>> +       ASSERT_OK(ret, "percpu_array_map update");
>>>> +
>>>> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_hash_map), &key, buf, 0);
>>>> +       ASSERT_OK(ret, "percpu_hash_map update");
>>>> +
>>>> +       ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_lru_hash_map), &key, buf, 0);
>>>> +       ASSERT_OK(ret, "percpu_lru_hash_map update");
>>>> +
>>>> +       syscall(__NR_getuid);
>>>> +
>>>> +       ret = skel->bss->percpu_array_elem_val == TEST_VALUE &&
>>>> +             skel->bss->percpu_hash_elem_val == TEST_VALUE &&
>>>> +             skel->bss->percpu_lru_hash_elem_val == TEST_VALUE;
>>>> +       ASSERT_OK(!ret, "bpf_map_lookup_percpu_elem success");
>>> this would be better done as three separate ASSERT_EQ(), combining
>>> into opaque true/false isn't helpful if something breaks
>>
>> Good suggestion.
>>
>>
>>>> +
>>>> +       test_map_lookup_percpu_elem__destroy(skel);
>>>> +}
>>>> diff --git a/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
>>>> new file mode 100644
>>>> index 000000000000..5d4ef86cbf48
>>>> --- /dev/null
>>>> +++ b/tools/testing/selftests/bpf/progs/test_map_lookup_percpu_elem.c
>>>> @@ -0,0 +1,54 @@
>>>> +// SPDX-License-Identifier: GPL-2.0
>>>> +// Copyright (c) 2022 Bytedance
>>> /* */ instead of //
>>
>> Ok, I will do. Thanks.
>>
>>
>>>> +
>>>> +#include "vmlinux.h"
>>>> +#include <bpf/bpf_helpers.h>
>>>> +
>>>> +int percpu_array_elem_val = 0;
>>>> +int percpu_hash_elem_val = 0;
>>>> +int percpu_lru_hash_elem_val = 0;
>>>> +
>>>> +struct {
>>>> +       __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
>>>> +       __uint(max_entries, 1);
>>>> +       __type(key, __u32);
>>>> +       __type(value, __u32);
>>>> +} percpu_array_map SEC(".maps");
>>>> +
>>>> +struct {
>>>> +       __uint(type, BPF_MAP_TYPE_PERCPU_HASH);
>>>> +       __uint(max_entries, 1);
>>>> +       __type(key, __u32);
>>>> +       __type(value, __u32);
>>>> +} percpu_hash_map SEC(".maps");
>>>> +
>>>> +struct {
>>>> +       __uint(type, BPF_MAP_TYPE_LRU_PERCPU_HASH);
>>>> +       __uint(max_entries, 1);
>>>> +       __type(key, __u32);
>>>> +       __type(value, __u32);
>>>> +} percpu_lru_hash_map SEC(".maps");
>>>> +
>>>> +SEC("tp/syscalls/sys_enter_getuid")
>>>> +int sysenter_getuid(const void *ctx)
>>>> +{
>>>> +       __u32 key = 0;
>>>> +       __u32 cpu = 0;
>>>> +       __u32 *value;
>>>> +
>>>> +       value = bpf_map_lookup_percpu_elem(&percpu_array_map, &key, cpu);
>>>> +       if (value)
>>>> +               percpu_array_elem_val = *value;
>>>> +
>>>> +       value = bpf_map_lookup_percpu_elem(&percpu_hash_map, &key, cpu);
>>>> +       if (value)
>>>> +               percpu_hash_elem_val = *value;
>>>> +
>>>> +       value = bpf_map_lookup_percpu_elem(&percpu_lru_hash_map, &key, cpu);
>>>> +       if (value)
>>>> +               percpu_lru_hash_elem_val = *value;
>>>> +
>>> if the test happens to run on CPU 0 then the test doesn't really test
>>> much. It would be more interesting to have a bpf_loop() iteration that
>>> would fetch values on each possible CPU instead and do something with
>>> it.
>>
>> Good suggestion. I check the code and find no bpf helper function to get
>> possible CPU nums.
>>
>> I think for the test function, read cpu0 elem value correctly should be
>> considered to be no problem.
>>
>> Or is it necessary to add a new helper function to get num_possible_cpus ?
>>
>>
> You can pass number of CPUs from user-space to BPF program through
> read-only variable (search for `const volatile` under progs/ for
> examples)
>
Ok, will do. Thanks.


>>>> +       return 0;
>>>> +}
>>>> +
>>>> +char _license[] SEC("license") = "GPL";
>>>> --
>>>> 2.20.1
>>>>

