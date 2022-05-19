Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAD752CA53
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233110AbiESD1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiESD1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:27:07 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E86557B3A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:27:06 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so7544868pjb.2
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 20:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=DvCDL7qLHs8BtEUJOCe3YyS8st6NCqz/zZeRA1wCMcs=;
        b=1exOZE9PZibtx7F79PeelNge5roPEynlStGZRREWBc/+lfRew4fgeL9sI/jebZC8n1
         W3aziSpV7BjjuH6EUHV6DK+gInM8hX1PdOF8HDiW3cCkPQPFBIZp0Tymcm/860mG4LJv
         YbcvLKyMrLVeJ0+GMpS6NrPZoUuP4middCswHtVqHjZlY+833Ej584a+5QNmi2Se6dWz
         Ai+mDo2PxyxAg8sxrXYTCIMCpA8WTFGzwBnG96Plz8+xuQhQnbneQa+sdI+5OY5SpbcR
         T1A6lTHpfg4R5hKnbBexOstX7/Q//8VQDIhGKBRhbSZUrarOwd05ZfGPnLxb9QeikK7Z
         TsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :to:cc:references:from:in-reply-to:content-transfer-encoding;
        bh=DvCDL7qLHs8BtEUJOCe3YyS8st6NCqz/zZeRA1wCMcs=;
        b=70Dv4A0DhSYDyGldMWvcNsld6s16bES+1k+FvCE9vZRLFPB6Cwq9SdNGLZTT3Wt7RI
         jsWkf8fEns2/xJv/cPiaV5YqujThvZqQdkyNuMpXq2RHded3GPdzQOIp3Rw2kFkg+ojn
         Zv4l7mrgQ8VdORzfJzM2mhCvMplJD2jqdLSjhCFVxp8T2YOuLFKk7NGo8iZ9ERix2vXj
         Xw/DKg5jQmnqJ3XVIRNMlUsPK4Wo+2zRHxu7qurCoDv9cuF47nfD3fV947ApxpzMnc8S
         RAGZ8hnWi8V8zeP0gdQ4e9wukV1DhKFu3MZhY0p0fpJ/OCRD0vo5hW8tPyvNkrof7kkU
         Wvdg==
X-Gm-Message-State: AOAM532zrE2UdmFgdRSKfXxlgvsFmiHZDZIiUfmlbuf5GU30XNbApeuA
        sOKEdGGPw7C1nVBBD+R4U70Lpg==
X-Google-Smtp-Source: ABdhPJxPK36YqflPnFkLOBUzTk8PKNRY2kI6ZmDVEPjgo4upOyHUWVIR9szL7xBocBGKmy7CsOLC/A==
X-Received: by 2002:a17:902:c714:b0:161:64fa:97b6 with SMTP id p20-20020a170902c71400b0016164fa97b6mr2804299plp.40.1652930825689;
        Wed, 18 May 2022 20:27:05 -0700 (PDT)
Received: from [10.71.57.194] ([139.177.225.241])
        by smtp.gmail.com with ESMTPSA id j8-20020aa78d08000000b0050dc7628182sm2748973pfe.92.2022.05.18.20.26.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 20:27:05 -0700 (PDT)
Message-ID: <196f6ae9-f899-16c8-a5d3-a1c771fa9900@bytedance.com>
Date:   Thu, 19 May 2022 11:26:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [External] Re: [PATCH bpf-next] selftests/bpf: fix some bugs in
 map_lookup_percpu_elem testcase
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
        zhouchengming@bytedance.com, Yosry Ahmed <yosryahmed@google.com>
References: <20220516022453.68420-1-zhoufeng.zf@bytedance.com>
 <CAEf4BzZ0eRh4ufQnc69B=6WQt_Oy3DNPL-TM-rsUW1KX--SBvQ@mail.gmail.com>
From:   Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <CAEf4BzZ0eRh4ufQnc69B=6WQt_Oy3DNPL-TM-rsUW1KX--SBvQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

在 2022/5/19 上午8:17, Andrii Nakryiko 写道:
> On Sun, May 15, 2022 at 7:25 PM Feng zhou <zhoufeng.zf@bytedance.com> wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> comments from Andrii Nakryiko, details in here:
>> https://lore.kernel.org/lkml/20220511093854.411-1-zhoufeng.zf@bytedance.com/T/
>>
>> use /* */ instead of //
>> use libbpf_num_possible_cpus() instead of sysconf(_SC_NPROCESSORS_ONLN)
>> use 8 bytes for value size
>> fix memory leak
>> use ASSERT_EQ instead of ASSERT_OK
>> add bpf_loop to fetch values on each possible CPU
>>
>> Fixes: ed7c13776e20c74486b0939a3c1de984c5efb6aa ("selftests/bpf: add test case for bpf_map_lookup_percpu_elem")
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
>> ---
>>   .../bpf/prog_tests/map_lookup_percpu_elem.c   | 49 +++++++++------
>>   .../bpf/progs/test_map_lookup_percpu_elem.c   | 61 ++++++++++++-------
>>   2 files changed, 70 insertions(+), 40 deletions(-)
>>
>> diff --git a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> index 58b24c2112b0..89ca170f1c25 100644
>> --- a/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> +++ b/tools/testing/selftests/bpf/prog_tests/map_lookup_percpu_elem.c
>> @@ -1,30 +1,39 @@
>> -// SPDX-License-Identifier: GPL-2.0
>> -// Copyright (c) 2022 Bytedance
>> +/* SPDX-License-Identifier: GPL-2.0 */
> heh, so for SPDX license comment the rule is to use // in .c files :)
> so keep SPDX as // and all others as /* */

will do. Thanks.

>
>> +/* Copyright (c) 2022 Bytedance */
>>
>>   #include <test_progs.h>
>>
>>   #include "test_map_lookup_percpu_elem.skel.h"
>>
>> -#define TEST_VALUE  1
>> -
>>   void test_map_lookup_percpu_elem(void)
>>   {
>>          struct test_map_lookup_percpu_elem *skel;
>> -       int key = 0, ret;
>> -       int nr_cpus = sysconf(_SC_NPROCESSORS_ONLN);
>> -       int *buf;
>> +       __u64 key = 0, sum;
>> +       int ret, i;
>> +       int nr_cpus = libbpf_num_possible_cpus();
>> +       __u64 *buf;
>>
>> -       buf = (int *)malloc(nr_cpus*sizeof(int));
>> +       buf = (__u64 *)malloc(nr_cpus*sizeof(__u64));
> no need for casting

casting means no '(__u64 *)'?
just like this:
'buf = malloc(nr_cpus * sizeof(__u64));'

>
>>          if (!ASSERT_OK_PTR(buf, "malloc"))
>>                  return;
>> -       memset(buf, 0, nr_cpus*sizeof(int));
>> -       buf[0] = TEST_VALUE;
>>
>> -       skel = test_map_lookup_percpu_elem__open_and_load();
>> -       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open_and_load"))
>> -               return;
>> +       for (i=0; i<nr_cpus; i++)
> spaces between operators

will do. Thanks.

>
>> +               buf[i] = i;
>> +       sum = (nr_cpus-1)*nr_cpus/2;
> same, please follow kernel code style

will do. Thanks.

>
>> +
>> +       skel = test_map_lookup_percpu_elem__open();
>> +       if (!ASSERT_OK_PTR(skel, "test_map_lookup_percpu_elem__open"))
>> +               goto exit;
>> +
> nit: keep it simple, init skel to NULL and use single cleanup goto
> label that will destroy skel unconditionally (it deals with NULL just
> fine)

will do. Thanks.

>> +       skel->rodata->nr_cpus = nr_cpus;
>> +
>> +       ret = test_map_lookup_percpu_elem__load(skel);
>> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__load"))
>> +               goto cleanup;
>> +
>>          ret = test_map_lookup_percpu_elem__attach(skel);
>> -       ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach");
>> +       if (!ASSERT_OK(ret, "test_map_lookup_percpu_elem__attach"))
>> +               goto cleanup;
>>
>>          ret = bpf_map_update_elem(bpf_map__fd(skel->maps.percpu_array_map), &key, buf, 0);
>>          ASSERT_OK(ret, "percpu_array_map update");
> [...]


