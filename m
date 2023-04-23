Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 672876EC10E
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 18:22:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjDWQWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 12:22:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjDWQWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 12:22:15 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92234CE;
        Sun, 23 Apr 2023 09:22:13 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-94f910ea993so497315166b.3;
        Sun, 23 Apr 2023 09:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682266932; x=1684858932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yidjVPwBHqcdYdJ/nDtM+sw6Z71xxnPo4Jwo9jCDNjU=;
        b=G6kLdcKGxeCz6DcGFzpTWux076wIQgnE2Z9Vo5K9/gNBEVyI3+WJTexdvRiFHmlzm3
         iDpwsdvId/rxbuiRy5lOKRlEn0lcT1N7YqUocmO+jEt9btjrxNsKfynIiRvjuPMjOxjp
         tCLQZ8k8mIOi5zK7D8ocIuB0i6bj4eg2gSxCSjPAoGF9BZe16pLi6SvEFfF4VGyYTQ62
         PAepNIRHawMbhTpwHooXJdhRzFIQ+fi6yb6keiQFazY5/QIzWN2DRwEbJvRZpF00P5jy
         qtZgXJgtlA6nNFSArM4PxIBPbfn5rKzgoX/F2NZbFSi7SEMwO5+g4MNwpHWbHjcfdcbZ
         dwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682266932; x=1684858932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yidjVPwBHqcdYdJ/nDtM+sw6Z71xxnPo4Jwo9jCDNjU=;
        b=k1gizqIBBcP0t2VDQz2vWmjcX6JO0Xdn8+DWnEYt7npPYDj2n0TUo3DYSXKLOS3zxb
         1Dn0SC97W3xi1GWdeTA6DQ/sck5vgcQXJbHIEMHvqPIieVQiQNTgHtBJJeQdi7kpQbRD
         CBE6m0zbxbRQ0hWfA8VI7IAiTFy3nNTVdNHuThKWGVQ6g5WoW8YoCZW+PfkK+R5r6QT/
         uRbxnpKOfovujZZ+p3iy+JiCoo9DBKAwUDXCEWESo4KxrxeWRDA+3kbATx789vGHDzN9
         5NFD9YGcxXE3KhKLNf6UiDKHhXjObJwfjZusbN1HC3E22cjckoXH3zoB4SaorKYnet8s
         EAVQ==
X-Gm-Message-State: AAQBX9cyM6QCYdNrP9wbNni+HhC/6TpMNR8oa4SqwTuaoYfs+g2jeU0y
        zdbMlFb7U4jw1fNxp4g8T6/oE4mNK81eAERxLWGc0VyG
X-Google-Smtp-Source: AKy350a4rUgBSyIHTYULi35CKzsB9o1sg5MJbqUP+kpNDhOsbDgEjPRUj3iylNQxQ1L65jAX0sjIz3oBnLo6zZgJ/ZI=
X-Received: by 2002:a17:907:b01d:b0:94f:6c6c:e17c with SMTP id
 fu29-20020a170907b01d00b0094f6c6ce17cmr6835618ejc.60.1682266931867; Sun, 23
 Apr 2023 09:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230421090403.15515-1-zhoufeng.zf@bytedance.com>
 <20230421090403.15515-3-zhoufeng.zf@bytedance.com> <20230421182418.5nvj4mp2vfumtmab@dhcp-172-26-102-232.dhcp.thefacebook.com>
 <f860cf89-74b2-9102-d28b-abec7d51f349@bytedance.com>
In-Reply-To: <f860cf89-74b2-9102-d28b-abec7d51f349@bytedance.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 23 Apr 2023 09:22:00 -0700
Message-ID: <CAADnVQKks_tWKRMTr6k3pBzYYXrnzWTAP6h6F_AN4m0uLCJfkw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH bpf-next v2 2/2] selftests/bpf: Add
 testcase for bpf_task_under_cgroup
To:     Feng Zhou <zhoufeng.zf@bytedance.com>
Cc:     Martin KaFai Lau <martin.lau@linux.dev>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Mykola Lysenko <mykolal@fb.com>, Shuah Khan <shuah@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, yangzhenze@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 22, 2023 at 8:51=E2=80=AFPM Feng Zhou <zhoufeng.zf@bytedance.co=
m> wrote:
>
> =E5=9C=A8 2023/4/22 02:24, Alexei Starovoitov =E5=86=99=E9=81=93:
>
> On Fri, Apr 21, 2023 at 05:04:03PM +0800, Feng zhou wrote:
>
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
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/task_under_cgr=
oup.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_task_under_cgr=
oup.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c b=
/tools/testing/selftests/bpf/prog_tests/task_under_cgroup.c
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
> +#define FOO "/foo"
> +
> +void test_task_under_cgroup(void)
> +{
> + struct test_task_under_cgroup *skel;
> + int ret, foo =3D -1;
> +
> + foo =3D test__join_cgroup(FOO);
> + if (!ASSERT_OK(foo < 0, "cgroup_join_foo"))
> + return;
> +
> + skel =3D test_task_under_cgroup__open();
> + if (!ASSERT_OK_PTR(skel, "test_task_under_cgroup__open"))
> + goto cleanup;
> +
> + skel->rodata->local_pid =3D getpid();
> + skel->rodata->cgid =3D get_cgroup_id(FOO);
> +
> + ret =3D test_task_under_cgroup__load(skel);
> + if (!ASSERT_OK(ret, "test_task_under_cgroup__load"))
> + goto cleanup;
> +
> + ret =3D test_task_under_cgroup__attach(skel);
> + if (!ASSERT_OK(ret, "test_task_under_cgroup__attach"))
> + goto cleanup;
> +
> + syscall(__NR_getuid);
> +
> + test_task_under_cgroup__detach(skel);
> +
> + ASSERT_EQ(skel->bss->remote_pid, skel->rodata->local_pid,
> +  "test task_under_cgroup");
> +
> +cleanup:
> + if (foo)
> + close(foo);
>
> Looks wrong. should be if (foo >=3D 0) ?
>
> Yes.
>
> +
> + test_task_under_cgroup__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h b/tool=
s/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> index 22914a70db54..41b3ea231698 100644
> --- a/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> +++ b/tools/testing/selftests/bpf/progs/cgrp_kfunc_common.h
> @@ -26,6 +26,7 @@ struct cgroup *bpf_cgroup_ancestor(struct cgroup *cgrp,=
 int level) __ksym;
>  struct cgroup *bpf_cgroup_from_id(u64 cgid) __ksym;
>  void bpf_rcu_read_lock(void) __ksym;
>  void bpf_rcu_read_unlock(void) __ksym;
> +int bpf_task_under_cgroup(struct cgroup *cgrp, struct task_struct *task)=
 __ksym;
>
>  static inline struct __cgrps_kfunc_map_value *cgrps_kfunc_map_value_look=
up(struct cgroup *cgrp)
>  {
> diff --git a/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c b=
/tools/testing/selftests/bpf/progs/test_task_under_cgroup.c
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
>
> pls narrow down to specific syscall. Like you use in user space part: get=
uid
>
> Also add this test to denylist.s390. See BPF CI failure.
>
> bpf_task_under_cgroup is placed in generic_btf_ids, belongs to BPF_PROG_T=
YPE_TRACING,
>
> if narrow down to specific syscall and uses SEC ("tp/syscalls/sys_enter_g=
etuid"),
>
> bpf prog type is TRACEPOINT, kfunc cannot be used, and reports
>
> "calls kernel function bpf_cgroup_from_id is not allowed".

sure, pls narrow it down. sys_enter is too broad.
In parallel test_progs the bpf prog will be way too many times.
