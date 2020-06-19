Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2C1200154
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 06:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbgFSEjK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 00:39:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSEjI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 00:39:08 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E112CC06174E;
        Thu, 18 Jun 2020 21:39:07 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id r22so6359982qke.13;
        Thu, 18 Jun 2020 21:39:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VEQDCbFai+4akoJzHfgmFatVzDlF/4lY5gd7vQ/lfaw=;
        b=oIhEj0iTmZ5Rm1v4p0QkNmZR+8qXt+wv07LuTc9y0O9fjg1aH3scMraGPmlYm7Ty0o
         EMWh4Xgki9d68f7lPuASvLJLxS1RBrL5fKDrjyNQ5XTDfEjlRsxQljmv/Mb8a02egeax
         JXqd35V6VwnIoxgB+jcp5bTcyQ4GkJX0dc90Kfb23aeTxZm7OixRhrIDdxHrpCMk4nZd
         CM5aGlZxgnUCREN1NAsBs3VlbYIy8NAj5GoThEaJz+PVf+0h+GGCFsF+Hjkn94c5E4Cy
         LaCaRh74h6qSYZC5g3XuRsRwnkA9je/uu4Luez6LNcGeJWglkVuxPp7fhUkM06/ALWsv
         1tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VEQDCbFai+4akoJzHfgmFatVzDlF/4lY5gd7vQ/lfaw=;
        b=BWZX438J4MbTxlklMDZr4SHVx8FYIsK1oR+ffIxCKIuwLcSlJk4vPGt1NsfF+j4DNK
         eNTTnYE4QP7MOsAfERGZ+990tPrsz2PIvrWHQIwkzs5RaNN4ErY3rhIEEV6DB58DyqoI
         8KGAFPXDz+7c5KQD9UtY+lUGccWMem8cjXQsrYaFM/ET0YeWphgomDCdf/29kV61DXjx
         CfBggYBxkZ//KNQpKS4iHQD6JPUieT0ww3LI9JDeqGNta6fZLXnRqDpd0SFXXEFwvHOL
         0k+rXg3+QeD0tbDpnmOq+K0XnhLx5obthS5PvqUGutE15FuRO3Z9ud7b/pnR7kg3fp6I
         +eBA==
X-Gm-Message-State: AOAM530C5Zj0xQdJuwFraD2RK27rFVEFubF0F+NCzPLFijK7Fa+MBO01
        JO+XJm7WJqB9paPtE0EAHzuCw9MrVyddxXoVqWo=
X-Google-Smtp-Source: ABdhPJxM1e8I9Mxijq8vU5WfnT4Q+JuGKR5qlSTRDotFq/thtLDTjFOosfa2Za314ICRdNSufAXHYmow/2vvaGBqHjU=
X-Received: by 2002:a37:6712:: with SMTP id b18mr1839624qkc.36.1592541547120;
 Thu, 18 Jun 2020 21:39:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200616100512.2168860-1-jolsa@kernel.org> <20200616100512.2168860-11-jolsa@kernel.org>
In-Reply-To: <20200616100512.2168860-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 18 Jun 2020 21:38:56 -0700
Message-ID: <CAEf4BzYr6hwS5-XKAJt-QEyPiofNvj2M1WA_B-F29QCFoZU2jw@mail.gmail.com>
Subject: Re: [PATCH 10/11] selftests/bpf: Add verifier test for d_path helper
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding verifier test for attaching tracing program and
> calling d_path helper from within and testing that it's
> allowed for dentry_open function and denied for 'd_path'
> function with appropriate error.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/testing/selftests/bpf/test_verifier.c   | 13 ++++++-
>  tools/testing/selftests/bpf/verifier/d_path.c | 38 +++++++++++++++++++
>  2 files changed, 50 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
>
> diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> index 78a6bae56ea6..3cce3dc766a2 100644
> --- a/tools/testing/selftests/bpf/test_verifier.c
> +++ b/tools/testing/selftests/bpf/test_verifier.c
> @@ -114,6 +114,7 @@ struct bpf_test {
>                 bpf_testdata_struct_t retvals[MAX_TEST_RUNS];
>         };
>         enum bpf_attach_type expected_attach_type;
> +       const char *kfunc;
>  };
>
>  /* Note we want this to be 64 bit aligned so that the end of our array is
> @@ -984,8 +985,18 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
>                 attr.log_level = 4;
>         attr.prog_flags = pflags;
>
> +       if (prog_type == BPF_PROG_TYPE_TRACING && test->kfunc) {
> +               attr.attach_btf_id = libbpf_find_vmlinux_btf_id(test->kfunc,
> +                                               attr.expected_attach_type);

if (!attr.attach_btf_id)
  emit more meaningful error, than later during load?

> +       }
> +
>         fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> -       if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> +
> +       /* BPF_PROG_TYPE_TRACING requires more setup and
> +        * bpf_probe_prog_type won't give correct answer
> +        */
> +       if (fd_prog < 0 && (prog_type != BPF_PROG_TYPE_TRACING) &&

nit: () are redundant

> +           !bpf_probe_prog_type(prog_type, 0)) {
>                 printf("SKIP (unsupported program type %d)\n", prog_type);
>                 skips++;
>                 goto close_fds;
> diff --git a/tools/testing/selftests/bpf/verifier/d_path.c b/tools/testing/selftests/bpf/verifier/d_path.c
> new file mode 100644
> index 000000000000..e08181abc056
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/verifier/d_path.c
> @@ -0,0 +1,38 @@
> +{
> +       "d_path accept",
> +       .insns = {
> +       BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_MOV64_IMM(BPF_REG_6, 0),
> +       BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6, 0),
> +       BPF_LD_IMM64(BPF_REG_3, 8),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_d_path),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .errstr = "R0 max value is outside of the array range",
> +       .result = ACCEPT,

accept with error string expected?


> +       .prog_type = BPF_PROG_TYPE_TRACING,
> +       .expected_attach_type = BPF_TRACE_FENTRY,
> +       .kfunc = "dentry_open",
> +},
> +{
> +       "d_path reject",
> +       .insns = {
> +       BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> +       BPF_MOV64_IMM(BPF_REG_6, 0),
> +       BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6, 0),
> +       BPF_LD_IMM64(BPF_REG_3, 8),
> +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_d_path),
> +       BPF_MOV64_IMM(BPF_REG_0, 0),
> +       BPF_EXIT_INSN(),
> +       },
> +       .errstr = "helper call is not allowed in probe",
> +       .result = REJECT,
> +       .prog_type = BPF_PROG_TYPE_TRACING,
> +       .expected_attach_type = BPF_TRACE_FENTRY,
> +       .kfunc = "d_path",
> +},
> --
> 2.25.4
>
