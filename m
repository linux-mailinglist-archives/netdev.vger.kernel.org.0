Return-Path: <netdev+bounces-242-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D1F436F6348
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 05:23:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10237280D00
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 03:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C41C1ED2;
	Thu,  4 May 2023 03:23:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DF97C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 03:23:50 +0000 (UTC)
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36A04E7B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 20:23:47 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 41be03b00d2f7-5191796a483so4114354a12.0
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 20:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1683170626; x=1685762626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yMX7++hY4TQk4m80chfBtqp/BoCVFUEBvGrPejwK03Y=;
        b=C4XBk9y274W2MZ7bH+sTaioczMsRoir4gFPOMVgu9uzCnuwLNOkWPPcGV67y5ExYVD
         Qs/sA4g7XAjLH/C5AWxTTdpD33HaN/OjezLLrf4v8LVw1w+4PBgpJaI+S0hi1VJLXmpm
         1q5IC0Gz54xNAALsvaa38Fi5R2T3ysOEBpEWJJ0kn31LhKXD0MkjI8GKNOmD9UIXESY2
         +5d0Qq4Dlyd6gUkPAJbKzYi8FIZePY9UXqyeQWE4GTVjMhFL6ck5aKqRjkohsexasajL
         18uwX8wnAGe15RA4ojLl0Qp8V9ZN9N06cxJB7rzYx3IkFR4og6WjmM33iXS80EiaeFnb
         MQjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683170626; x=1685762626;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yMX7++hY4TQk4m80chfBtqp/BoCVFUEBvGrPejwK03Y=;
        b=IitTCerchKDzQEF0D/rFu2y6DS05tWPyBlGhzJKrEmb2qzbSb7G3YSRx64ugYNLNIP
         ZC6yCfagiBX6hxxXjGGHtoYVhuIbIMV5aenizux2OIQ76jb4B2y/uHLdr1H2oxnYjEKo
         TS3l60Y8llr+MoJOKJNU9v8WcOI14RMNF/7Rdw2+hl+6zfk5PYzQ8ObgJj4sgxX5bA6w
         DPF7tGmqumeNLYcF01XVhCjhNkPy6Wzsytjy3P/Vw8OClw+RzpaIHzTIU+lV9t6q/v4x
         eUBsUGvKLUBNV/8Y+iM0HAVdDQv78Kp0UJOPQ0zYayUgtT/FWec+HTKJStj1FRjNj1z9
         vqaA==
X-Gm-Message-State: AC+VfDzkwT09M9Vd0Z5gnj/BKqUQy/tjWv0bhELBwQWDuLyBFS77yJ/0
	7joFk2tbi9lbwGM3fJrvFFg7vA==
X-Google-Smtp-Source: ACHHUZ4AuPD0NtWh5gENo1oMd69P666JefqAR3GyFSrWyfJDu0GtoP5UkGSKz57L+v4KKv5QrMqCEw==
X-Received: by 2002:a17:902:8f97:b0:1a9:8ab1:9f3b with SMTP id z23-20020a1709028f9700b001a98ab19f3bmr2058724plo.14.1683170626614;
        Wed, 03 May 2023 20:23:46 -0700 (PDT)
Received: from [10.71.57.173] ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id m1-20020a170902db0100b001aad2910194sm8675599plx.14.2023.05.03.20.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 20:23:46 -0700 (PDT)
Message-ID: <f72e8dd0-25cc-e7a3-17bf-5ed2c25ac8d6@bytedance.com>
Date: Thu, 4 May 2023 11:23:36 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: Re: [PATCH bpf-next v4 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
To: Yonghong Song <yhs@meta.com>, martin.lau@linux.dev, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, song@kernel.org, yhs@fb.com,
 john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
 haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
 shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com
References: <20230428071737.43849-1-zhoufeng.zf@bytedance.com>
 <20230428071737.43849-3-zhoufeng.zf@bytedance.com>
 <218660da-f73d-d698-eb5e-f513379945bd@meta.com>
From: Feng Zhou <zhoufeng.zf@bytedance.com>
In-Reply-To: <218660da-f73d-d698-eb5e-f513379945bd@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

在 2023/4/29 00:32, Yonghong Song 写道:
> 
> 
> On 4/28/23 12:17 AM, Feng zhou wrote:
>> From: Feng Zhou <zhoufeng.zf@bytedance.com>
>>
>> test_progs:
>> Tests new kfunc bpf_task_under_cgroup().
>>
>> The bpf program saves the new task's pid within a given cgroup to
>> the remote_pid, which is convenient for the user-mode program to
>> verify the test correctness.
>>
>> The user-mode program creates its own mount namespace, and mounts the
>> cgroupsv2 hierarchy in there, call the fork syscall, then check if
>> remote_pid and local_pid are unequal.
>>
>> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> Ack with a few nits below.
> 
> Acked-by: Yonghong Song <yhs@fb.com>
> 
>> ---
>>   tools/testing/selftests/bpf/DENYLIST.s390x    |  1 +
>>   .../bpf/prog_tests/task_under_cgroup.c        | 55 +++++++++++++++++++
>>   .../bpf/progs/test_task_under_cgroup.c        | 51 +++++++++++++++++
>>   3 files changed, 107 insertions(+)
>>   create mode 100644 
>> tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>>   create mode 100644 
>> tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
>>
>> diff --git a/tools/testing/selftests/bpf/DENYLIST.s390x 
>> b/tools/testing/selftests/bpf/DENYLIST.s390x
>> index c7463f3ec3c0..5061d9e24c16 100644
>> --- a/tools/testing/selftests/bpf/DENYLIST.s390x
>> +++ b/tools/testing/selftests/bpf/DENYLIST.s390x
>> @@ -26,3 +26,4 @@ user_ringbuf                             # failed to 
>> find kernel BTF type ID of
>>   verif_stats                              # 
>> trace_vprintk__open_and_load unexpected error: 
>> -9                           (?)
>>   xdp_bonding                              # failed to auto-attach 
>> program 'trace_on_entry': -524                        (trampoline)
>>   xdp_metadata                             # JIT does not support 
>> calling kernel function                                (kfunc)
>> +test_task_under_cgroup                   # JIT does not support 
>> calling kernel function                                (kfunc)
>> diff --git 
>> a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c 
>> b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>> new file mode 100644
>> index 000000000000..5e79dff86dec
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>> @@ -0,0 +1,55 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2023 Bytedance */
>> +
>> +#include <sys/syscall.h>
>> +#include <test_progs.h>
>> +#include <cgroup_helpers.h>
>> +#include "test_task_under_cgroup.skel.h"
>> +
>> +#define FOO    "/foo"
>> +
>> +void test_task_under_cgroup(void)
>> +{
>> +    struct test_task_under_cgroup *skel;
>> +    int ret, foo = -1;
>> +    pid_t pid;
>> +
>> +    foo = test__join_cgroup(FOO);
>> +    if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
>> +        return;
>> +
>> +    skel = test_task_under_cgroup__open();
>> +    if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
>> +        goto cleanup;
>> +
>> +    skel->rodata->local_pid = getpid();
>> +    skel->bss->remote_pid = getpid();
>> +    skel->rodata->cgid = get_cgroup_id(FOO);
>> +
>> +    ret = test_task_under_cgroup__load(skel);
>> +    if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
>> +        goto cleanup;
>> +
>> +    ret = test_task_under_cgroup__attach(skel);
>> +    if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
>> +        goto cleanup;
>> +
>> +    pid = fork();
>> +    if (pid == 0)
>> +        exit(0);
>> +    else if (pid == -1)
>> +        printf("Couldn't fork process!\n");
> 
> ASSERT_* is preferred compared to 'printf'. Maybe ASSERT_TRUE(0, 
> "Couldn't fork process")?
> 

Will do.

>> +
>> +    wait(NULL);
>> +
>> +    test_task_under_cgroup__detach(skel);
>> +
>> +    ASSERT_NEQ(skel->bss->remote_pid, skel->rodata->local_pid,
>> +           "test task_under_cgroup");
>> +
>> +cleanup:
>> +    if (foo >= 0)
> 
> "if (foo >= 0)" is not needed. 'foo' is guaranteed ">= 0" as this point.
> 

Yes

>> +        close(foo);
>> +
>> +    test_task_under_cgroup__destroy(skel);
>> +}
>> diff --git 
>> a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c 
>> b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
>> new file mode 100644
>> index 000000000000..5bcb726d6d0a
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
>> @@ -0,0 +1,51 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2023 Bytedance */
>> +
>> +#include <vmlinux.h>
>> +#include <bpf/bpf_tracing.h>
>> +#include <bpf/bpf_helpers.h>
>> +
>> +#include "bpf_misc.h"
>> +
>> +struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
>> +long bpf_task_under_cgroup(struct task_struct *task, struct cgroup 
>> *ancestor) __ksym;
>> +void bpf_cgroup_release(struct cgroup *p) __ksym;
>> +struct task_struct *bpf_task_acquire(struct task_struct *p) __ksym;
>> +void bpf_task_release(struct task_struct *p) __ksym;
>> +
>> +const volatile int local_pid;
>> +const volatile long cgid;
> 
> cgid cannot be a negative number. So let us do
> const volatile __u64 cgid;
> 

Ok

>> +int remote_pid;
>> +
>> +SEC("tp_btf/task_newtask")
>> +int BPF_PROG(handle__task_newtask, struct task_struct *task, u64 
>> clone_flags)
>> +{
>> +    struct cgroup *cgrp = NULL;
>> +    struct task_struct *acquired = NULL;
> 
> "acquired = NULL" is not needed. Just do "struct task_struct *acquired;".
> 

Ok

>> +
>> +    if (local_pid != (bpf_get_current_pid_tgid() >> 32))
>> +        return 0;
>> +
>> +    acquired = bpf_task_acquire(task);
>> +    if (!acquired)
>> +        return 0;
>> +
>> +    if (local_pid == acquired->tgid)
>> +        goto out;
>> +
>> +    cgrp = bpf_cgroup_from_id(cgid);
>> +    if (!cgrp)
>> +        goto out;
>> +
>> +    if (bpf_task_under_cgroup(acquired, cgrp))
>> +        remote_pid = acquired->tgid;
>> +
>> +out:
>> +    if (acquired)
>> +        bpf_task_release(acquired);
>> +    if (cgrp)
>> +        bpf_cgroup_release(cgrp);
>> +    return 0;
>> +}
>> +
>> +char _license[] SEC("license") = "GPL";


