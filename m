Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437CB4F0D64
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 03:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376862AbiDDBRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 21:17:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376855AbiDDBRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 21:17:06 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0635F338B0;
        Sun,  3 Apr 2022 18:15:12 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id m17so1809471ilj.13;
        Sun, 03 Apr 2022 18:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3N4Gq7egw3pimbAVK83zfIZ2AhSDtCKyPabJ/Dg7kCA=;
        b=CWOsaexDCNdMOUU4/pwd4WIABm6gMXzjeYLYi3+VhWfSYV7NmnrPpZswECAoWLDVHM
         VG944UvA4wxZtXgmHZRLA3rdHJOP6D0bCg+yslyv6lyk6BNVEHuOxHm4zlEzVCiQVIhX
         4Fcb5/KagkT8uQqIhtn+j8xGLZHbIbYhQ2i85xId5j8yBXisYPz06bhlRbyC36iYnrv4
         aR+vfC66KYM73KPPlbgAWUo3MVCdj9u5rVdjUpkU6uzCcPQZ3suN2KTUnwmrLHx94pTT
         xA/VBaRxFepfJR9A205SDyWo7u0dF+FzvXGZJYxzh55D5mAmGnKzHE89srohTBe3aib/
         KJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3N4Gq7egw3pimbAVK83zfIZ2AhSDtCKyPabJ/Dg7kCA=;
        b=NhxxarnfVx1y2qjaPvPC0Ho7b1qEoTnjPgVJFHKsdr2QNRdlZoRvMZdOETvdb+DlBb
         wIy6CE4r0DhU85jjDKsjJ9/imYzseMnXE0Pn8SrhABK5o6F5eLMSJ6CNqGFwa6LhSZok
         kYAyLEottTS1Eke6xlPNztOFYR2TAZJQqbYmPqlrl8jxPXJpq00ku+Yi4aqsckaak3XB
         UVYa+vQ31+V1WJBOs8xtjrSTBh+A6UydXVNgfa5IY4B9ZHGBUoNPwxC3jd52WHaz9JaF
         N+kBGsubCn0xEM+yrI0oXIIsPRgb/8BLLrgICV05/84XclyvOhpaeKaJlVwuSf/8EhJO
         ma6w==
X-Gm-Message-State: AOAM532d/SI3t74QzkrOG8reV3AIokLoefbXPiAzYvVTWH5fb1zsan2x
        V1PNMcXkkiRfuCrzar1JGsQCBWMnDAbHJqWqpDgF2ZGo
X-Google-Smtp-Source: ABdhPJxnHy7xvmrBeL2VnHQg+0ZF5nLl+yAI9vJ1s3bKsmUWAWHWU4PswYTiKV+N/c0TZtVJX4V2NZM/OVphKYhvAik=
X-Received: by 2002:a05:6e02:1562:b0:2c9:cb97:9a4 with SMTP id
 k2-20020a056e02156200b002c9cb9709a4mr4345839ilu.71.1649034911425; Sun, 03 Apr
 2022 18:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <1648654000-21758-1-git-send-email-alan.maguire@oracle.com> <1648654000-21758-6-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1648654000-21758-6-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sun, 3 Apr 2022 18:15:00 -0700
Message-ID: <CAEf4Bza4fj8GZUqu5RHx3yrQ1mVPkOSAT1=rtD1aAxhUCxYMmQ@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 5/5] selftests/bpf: add tests for uprobe
 auto-attach via skeleton
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Yucong Sun <sunyucong@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 30, 2022 at 8:27 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> tests that verify auto-attach works for function entry/return for
> local functions in program and library functions in a library.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  .../selftests/bpf/prog_tests/uprobe_autoattach.c   | 38 ++++++++++++++++
>  .../selftests/bpf/progs/test_uprobe_autoattach.c   | 52 ++++++++++++++++++++++
>  2 files changed, 90 insertions(+)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> new file mode 100644
> index 0000000..03b15d6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/prog_tests/uprobe_autoattach.c
> @@ -0,0 +1,38 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022, Oracle and/or its affiliates. */
> +
> +#include <test_progs.h>
> +#include "test_uprobe_autoattach.skel.h"
> +
> +/* uprobe attach point */
> +static void autoattach_trigger_func(void)
> +{
> +       asm volatile ("");
> +}
> +
> +void test_uprobe_autoattach(void)
> +{
> +       struct test_uprobe_autoattach *skel;
> +       char *mem;
> +
> +       skel = test_uprobe_autoattach__open_and_load();
> +       if (!ASSERT_OK_PTR(skel, "skel_open"))
> +               return;
> +
> +       if (!ASSERT_OK(test_uprobe_autoattach__attach(skel), "skel_attach"))
> +               goto cleanup;
> +
> +       /* trigger & validate uprobe & uretprobe */
> +       autoattach_trigger_func();
> +
> +       /* trigger & validate shared library u[ret]probes attached by name */
> +       mem = malloc(1);
> +       free(mem);
> +
> +       ASSERT_EQ(skel->bss->uprobe_byname_res, 1, "check_uprobe_byname_res");
> +       ASSERT_EQ(skel->bss->uretprobe_byname_res, 2, "check_uretprobe_byname_res");
> +       ASSERT_EQ(skel->bss->uprobe_byname2_res, 3, "check_uprobe_byname2_res");
> +       ASSERT_EQ(skel->bss->uretprobe_byname2_res, 4, "check_uretprobe_byname2_res");
> +cleanup:
> +       test_uprobe_autoattach__destroy(skel);
> +}
> diff --git a/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
> new file mode 100644
> index 0000000..b442fb5
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_uprobe_autoattach.c
> @@ -0,0 +1,52 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (c) 2022, Oracle and/or its affiliates. */
> +
> +#include <linux/ptrace.h>
> +#include <linux/bpf.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_tracing.h>
> +
> +int uprobe_byname_res = 0;
> +int uretprobe_byname_res = 0;
> +int uprobe_byname2_res = 0;
> +int uretprobe_byname2_res = 0;
> +
> +/* This program cannot auto-attach, but that should not stop other
> + * programs from attaching.
> + */
> +SEC("uprobe")
> +int handle_uprobe_noautoattach(struct pt_regs *ctx)
> +{
> +       return 0;
> +}
> +
> +SEC("uprobe//proc/self/exe:autoattach_trigger_func")
> +int handle_uprobe_byname(struct pt_regs *ctx)
> +{
> +       uprobe_byname_res = 1;
> +       return 0;
> +}
> +
> +SEC("uretprobe//proc/self/exe:autoattach_trigger_func")
> +int handle_uretprobe_byname(struct pt_regs *ctx)
> +{
> +       uretprobe_byname_res = 2;
> +       return 0;
> +}
> +
> +
> +SEC("uprobe/libc.so.6:malloc")
> +int handle_uprobe_byname2(struct pt_regs *ctx)
> +{
> +       uprobe_byname2_res = 3;
> +       return 0;
> +}
> +
> +SEC("uretprobe/libc.so.6:free")
> +int handle_uretprobe_byname2(struct pt_regs *ctx)
> +{
> +       uretprobe_byname2_res = 4;
> +       return 0;
> +}

I just realized that in all our uprobe tests we don't really check
that it was really a return probe. Can you please follow up with
changes to selftests that make relevant trigger functions return some
well-known value and uretprobe programs capturing and recording those
with user-space parts of selftests checking this?


> +
> +char _license[] SEC("license") = "GPL";
> --
> 1.8.3.1
>
