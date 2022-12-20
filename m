Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 886C7652925
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 23:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiLTWlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 17:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiLTWlN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 17:41:13 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C9FDEE7;
        Tue, 20 Dec 2022 14:41:12 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id bj12so32622552ejb.13;
        Tue, 20 Dec 2022 14:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ph+5KOAbIJHfzzO6euiVSZ2Zn0ERVZV2z4gOV1wzvDo=;
        b=N+7vkSYnDXswyTBhQFkUBSBJpYtlEeESEgaB7v9YfFxShQsAdIC5aw+x0F7go1BVjP
         mmDNqiA0I8I27yorhos351bXAlVfyQAPQtWlHsLQT0sUupt7wrwr11xwAgnVSUQpCcoT
         j6DvrA9jeh41bzDJo+MHOb8IQVE1HiDl7zNFWopePXApRlh8ccHGqm/K/u6mVAc1OR5t
         An3Swp/PJeBfThxZX/6xL55rnJCNsu38kiC+cP4Hza8EM+6fboRH4SNI7gmc+kC1OGiD
         kIMMbI/DIX8b+A+JW85oriEq1VRFmjR9XJyRJ8Gh/f4ccoLjGZe5xUsTpgrhb48nyxwC
         UT5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ph+5KOAbIJHfzzO6euiVSZ2Zn0ERVZV2z4gOV1wzvDo=;
        b=YKCEO3kFJW0OlvZZy5F07R20Ucq3ZXqNjzpPYDJiy1YKOkzWMrpHncO6IS8szd/D3R
         gst7vlKU5WDiADDeiSvYWiZaQQse5/nxoPP5+/8z2nL1rOQg8nalOvV1OAcdkWvDck/k
         OXdScb0oRIMwmYYvzZega5dnNUP+a2txeW0agQH1X8gWOOvyOsgVBF4e3dTY8vrENCPg
         U5vxWWwwQ5kxQPQXJs/qg4AVUCChDgRFk9w6j/RMBBz7qtenHvKZaGca0tticzTSeuVQ
         DA1Vrm/3VRoEsKqQVRkY0wvRDeffbLwLuNKyz6wpL/5o9TJEB1yUnaLOxQgKHczjstff
         a/gg==
X-Gm-Message-State: AFqh2krfJcNAuatTGWgRG9zatbXj7JHK4jSPWQ07GJuLnHaRyA5g6z8P
        ijGyfkdyPp/eX6+SeGH5Sduvx/Ft85IcAlZiFwxppHU+QBs=
X-Google-Smtp-Source: AMrXdXvOABP+cSgVSEeMIw97zOqOKqCbUFNXAJEPHKK7q7lq75H3O/ytNF1sRMSl+XKL0FUDt5v0VmOFAMN6POtjMLs=
X-Received: by 2002:a17:906:f153:b0:83d:2544:a11 with SMTP id
 gw19-20020a170906f15300b0083d25440a11mr7552ejb.226.1671576070887; Tue, 20 Dec
 2022 14:41:10 -0800 (PST)
MIME-Version: 1.0
References: <20221220115928.11979-1-danieltimlee@gmail.com>
In-Reply-To: <20221220115928.11979-1-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 20 Dec 2022 14:40:58 -0800
Message-ID: <CAEf4BzYW4NamMJ5LJ66Hq6YJp1vHeGS8xUf+khZpD7EdVfRUSg@mail.gmail.com>
Subject: Re: [bpf-next v2 0/5] samples/bpf: enhance syscall tracing program
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 20, 2022 at 3:59 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Syscall tracing using kprobe is quite unstable. Since it uses the exact
> name of the kernel function, the program might broke due to the rename
> of a function. The problem can also be caused by a changes in the
> arguments of the function to which the kprobe connects. This commit
> enhances syscall tracing program with the following instruments.
>
> In this patchset, ksyscall is used instead of kprobe. By using
> ksyscall, libbpf will detect the appropriate kernel function name.
> (e.g. sys_write -> __s390_sys_write). This eliminates the need to worry
> about which wrapper function to attach in order to parse arguments.
> Also ksyscall provides more fine method with attaching system call, the
> coarse SYSCALL helper at trace_common.h can be removed.
>
> Next, BPF_SYSCALL is used to reduce the inconvenience of parsing
> arguments. Since the nature of SYSCALL_WRAPPER function wraps the
> argument once, additional process of argument extraction is required
> to properly parse the argument. The BPF_SYSCALL macro will reduces the
> hassle of parsing arguments from pt_regs.
>
> Lastly, vmlinux.h is applied to syscall tracing program. This change
> allows the bpf program to refer to the internal structure as a single
> "vmlinux.h" instead of including each header referenced by the bpf
> program.
>
> Additionally, this patchset changes the suffix of _kern to .bpf to make
> use of the new compile rule (CLANG-BPF) which is more simple and neat.
> By just changing the _kern suffix to .bpf will inherit the benefit of
> the new CLANG-BPF compile target.
>
> Also, this commit adds dummy gnu/stub.h to the samples/bpf directory.
> This will fix the compiling problem with 'clang -target bpf'.
>
> ---
> Changes in V2:
> - add gnu/stub.h hack to fix compile error with 'clang -target bpf'
>
> Daniel T. Lee (5):
>   samples/bpf: use kyscall instead of kprobe in syscall tracing program
>   samples/bpf: use vmlinux.h instead of implicit headers in syscall
>     tracing program
>   samples/bpf: change _kern suffix to .bpf with syscall tracing program
>   samples/bpf: fix tracex2 by using BPF_KSYSCALL macro
>   samples/bpf: use BPF_KSYSCALL macro in syscall tracing programs
>

Nice set of changes, thanks for cleaning these up! I don't see
anything obviously wrong, but these changes seem to break s390x build
(see [0]), please check what's going on.

  [0] https://github.com/kernel-patches/bpf/actions/runs/3740339876/jobs/6348606866


>  samples/bpf/Makefile                          | 10 ++--
>  samples/bpf/gnu/stubs.h                       |  1 +
>  ...p_perf_test_kern.c => map_perf_test.bpf.c} | 48 ++++++++-----------
>  samples/bpf/map_perf_test_user.c              |  2 +-
>  ...c => test_current_task_under_cgroup.bpf.c} | 11 ++---
>  .../bpf/test_current_task_under_cgroup_user.c |  2 +-
>  samples/bpf/test_map_in_map_kern.c            |  1 -
>  ...ser_kern.c => test_probe_write_user.bpf.c} | 20 ++++----
>  samples/bpf/test_probe_write_user_user.c      |  2 +-
>  samples/bpf/trace_common.h                    | 13 -----
>  ...trace_output_kern.c => trace_output.bpf.c} |  6 +--
>  samples/bpf/trace_output_user.c               |  2 +-
>  samples/bpf/{tracex2_kern.c => tracex2.bpf.c} | 13 ++---
>  samples/bpf/tracex2_user.c                    |  2 +-
>  14 files changed, 52 insertions(+), 81 deletions(-)
>  create mode 100644 samples/bpf/gnu/stubs.h
>  rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
>  rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
>  rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
>  delete mode 100644 samples/bpf/trace_common.h
>  rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
>  rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)
>
> --
> 2.34.1
>
