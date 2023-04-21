Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D77CB6EB18E
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 20:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbjDUSYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 14:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjDUSYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 14:24:24 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EA6519A;
        Fri, 21 Apr 2023 11:24:23 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5c4c76aaso1901274b3a.2;
        Fri, 21 Apr 2023 11:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682101462; x=1684693462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OypLJRTEB5SbxLBh9tKcIDiFO23AVAYc9LxzvH6yqzM=;
        b=WHuV4wkb9Ov9Uf5JAU4CitMPxP7KBxUhJPjwwGriFuvOl6r9AZaphtmjXhvPh0y/yf
         07OzEem47p4XybvBedFkd8MuzzDwI8WPr8cM7GX2HVSQzNZKKNSEsJmeRrXw8vpwL4ee
         ZGQQmsRNaix8T88vJcnlEvbL/5B3iXFg2yILvL/ljkao/Liy8fEu2BuGxK90gDY3jLBa
         VwF6NB7+4YKLrR3K7dvS03tpoSdWTdirOWA5W3hFPwJdKlS3D3HsDHdmHsXl5nE7YnpZ
         VrNgUkdf7HN19kfNTwcxn3o4EFzRdP2SNT0Ob+RIp9i9atj8bVc1zNlc81/2UYPSJWK0
         HTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682101462; x=1684693462;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OypLJRTEB5SbxLBh9tKcIDiFO23AVAYc9LxzvH6yqzM=;
        b=MIwOjMG42z8C2PXmZ09VrcFZA4HJikwBrx+GLrdNeDgZoEhHBFNXbXMbofivkYn/RE
         Vdn0hS1BV2ZPHgdw+vMCacEz2UzmxpBOdQg+ovM3Q+g0gMLGfY7Rj7XXdf235drHdy1a
         Ur9ViQjU/pwnnHjRtEDQhlGjoq+2lIsyBrfAZ1ogr0Q5F8Qx+LO5kt0C6lh1Q20va8Es
         l35V3D4AvgP03B4ObyBX4ULi0KVTInWop56E6D3jYMA0gw7S/p/TXWtXK0MDOzCrPmCt
         IhdcxasF7T+UTif+flOw9AUhv9yS9KC6GR16BXYJQ4eQd2lFWze44mKrmQLUNtLcA4cT
         +/9g==
X-Gm-Message-State: AAQBX9erfo9geSVB2lh7DTwlFStdH5C+1ScbKrtnAieJpZdZwxGG+YEr
        c2J1/RMnEVpFJc+Ytyb7p7CjBRX0nTE=
X-Google-Smtp-Source: AKy350bdqKhKObaXCm3kR3cZk3swBANng8Vxrne2H7FBqk2E7adQc211wBjk6FVGRCZsd+fI+AvV3g==
X-Received: by 2002:a05:6a00:814:b0:63c:1be4:5086 with SMTP id m20-20020a056a00081400b0063c1be45086mr8028880pfk.6.1682101462459;
        Fri, 21 Apr 2023 11:24:22 -0700 (PDT)
Received: from dhcp-172-26-102-232.dhcp.thefacebook.com ([2620:10d:c090:400::5:ef5e])
        by smtp.gmail.com with ESMTPSA id c192-20020a621cc9000000b0063d44634d8csm3275518pfc.71.2023.04.21.11.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Apr 2023 11:24:21 -0700 (PDT)
Date:   Fri, 21 Apr 2023 11:24:18 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Feng zhou <zhoufeng.zf@bytedance.com>
Cc:     martin.lau@linux.dev, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        mykolal@fb.com, shuah@kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, yangzhenze@bytedance.com,
        wangdongdong.6@bytedance.com
Subject: Re: [PATCH bpf-next v2 2/2] selftests/bpf: Add testcase for
 bpf_task_under_cgroup
Message-ID: <20230421182418.5nvj4mp2vfumtmab@dhcp-172-26-102-232.dhcp.thefacebook.com>
References: <20230421090403.15515-1-zhoufeng.zf@bytedance.com>
 <20230421090403.15515-3-zhoufeng.zf@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230421090403.15515-3-zhoufeng.zf@bytedance.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 21, 2023 at 05:04:03PM +0800, Feng zhou wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> test_progs:
> Tests new kfunc bpf_task_under_cgroup().
> 
> The bpf program saves the pid which call the getuid syscall within a
> given cgroup to the remote_pid, which is convenient for the user-mode
> program to verify the test correctness.
> 
> The user-mode program creates its own mount namespace, and mounts the
> cgroupsv2 hierarchy in there, call the getuid syscall, then check if
> remote_pid and local_pid are equal.
> 
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> ---
>  .../bpf/prog_tests/task_under_cgroup.c        | 46 +++++++++++++++++++
>  .../selftests/bpf/progs/cgrp_kfunc_common.h   |  1 +
>  .../bpf/progs/test_task_under_cgroup.c        | 40 ++++++++++++++++
>  3 files changed, 87 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> 
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> new file mode 100644
> index 000000000000..bd3deb469938
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
> @@ -0,0 +1,46 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <test_progs.h>
> +#include <cgroup_helpers.h>
> +#include "test_task_under_cgroup.skel.h"
> +
> +#define FOO	"/foo"
> +
> +void test_task_under_cgroup(void)
> +{
> +	struct test_task_under_cgroup *skel;
> +	int ret, foo = -1;
> +
> +	foo = test__join_cgroup(FOO);
> +	if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
> +		return;
> +
> +	skel = test_task_under_cgroup__open();
> +	if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
> +		goto cleanup;
> +
> +	skel->rodata->local_pid = getpid();
> +	skel->rodata->cgid = get_cgroup_id(FOO);
> +
> +	ret = test_task_under_cgroup__load(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
> +		goto cleanup;
> +
> +	ret = test_task_under_cgroup__attach(skel);
> +	if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
> +		goto cleanup;
> +
> +	syscall(__NR_getuid);
> +
> +	test_task_under_cgroup__detach(skel);
> +
> +	ASSERT_EQ(skel->bss->remote_pid, skel->rodata->local_pid,
> +		  "test task_under_cgroup");
> +
> +cleanup:
> +	if (foo)
> +		close(foo);

Looks wrong. should be if (foo >= 0) ?

> +
> +	test_task_under_cgroup__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> index 22914a70db54..41b3ea231698 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> @@ -26,6 +26,7 @@ struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp, int level) __ksym;
>  struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
>  void bpf_rcu_read_lock(void) __ksym;
>  void bpf_rcu_read_unlock(void) __ksym;
> +int bpf_task_under_cgroup(struct cgroup *cgrp, struct task_struct *task) __ksym;
>  
>  static inline struct __cgrps_kfunc_map_value *cgrps_kfunc_map_value_lookup(struct cgroup *cgrp)
>  {
> diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> new file mode 100644
> index 000000000000..e2740f9b029d
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
> @@ -0,0 +1,40 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2023 Bytedance */
> +
> +#include <vmlinux.h>
> +#include <asm/unistd.h>
> +#include <bpf/bpf_tracing.h>
> +#include <bpf/bpf_helpers.h>
> +
> +#include "cgrp_kfunc_common.h"
> +
> +const volatile int local_pid;
> +const volatile long cgid;
> +int remote_pid;
> +
> +SEC("tp_btf/sys_enter")

pls narrow down to specific syscall. Like you use in user space part: getuid

Also add this test to denylist.s390. See BPF CI failure.

> +int BPF_PROG(sysenter, struct pt_regs *regs, long id)
> +{
> +	struct cgroup *cgrp;
> +
> +	if (id != __NR_getuid)
> +		return 0;
> +
> +	if (local_pid != (bpf_get_current_pid_tgid() >> 32))
> +		return 0;
> +
> +	cgrp = bpf_cgroup_from_id(cgid);
> +	if (!cgrp)
> +		return 0;
> +
> +	if (!bpf_task_under_cgroup(cgrp, bpf_get_current_task_btf()))
> +		goto out;
> +
> +	remote_pid = local_pid;
> +
> +out:
> +	bpf_cgroup_release(cgrp);
> +	return 0;
> +}
> +
> +char _license[] SEC("license") = "GPL";
> -- 
> 2.20.1
> 
