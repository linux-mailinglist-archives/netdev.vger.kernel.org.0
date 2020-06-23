Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C922055AE
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 17:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732986AbgFWPTU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 11:19:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732951AbgFWPTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 11:19:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F65DC061573;
        Tue, 23 Jun 2020 08:19:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id 9so23911738ljc.8;
        Tue, 23 Jun 2020 08:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zg5KrHOcQrVCDVOVV1dxi5MJGq6i4wHlqMrQXmXPUSo=;
        b=P2uaReEK5NwiTTG5uk8gT05JIjoCpzK+Y6gQCqAo02RmYaqV8iLo8DJ+Mn8KeIiwt4
         mshaieTmNk+Hu+LdwbqqHbFQeTOZkva/WMCfi2YLs3YnD9mOd+3TnwtMcogD5YTPDhE2
         pfIRgZjMTI8qAvq58aTxg8cKbYgrwzbZnGUADP+AuZ68TiOuGkbobefhe14AW2JrO2So
         SX8dF9tG0JUXhi9JTFUqklXmd6FMpVUbndJqLE6nF3xvg2K7omKhXzT3I3xrk/JWOfNw
         o/ioyMpcJwAlEE+qjFb1QAVtsaCmxFfl7YCZhjm7MmT6+n9yEAV6g/dtNnFfiUfhsodP
         0qhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zg5KrHOcQrVCDVOVV1dxi5MJGq6i4wHlqMrQXmXPUSo=;
        b=maSsbEsSLUoj569jI/dAZqcYt74USNP9eBdqc1Muzru6SOuQMLeSXT4gOa7hfmECOT
         ls7ktNYHc/tzcA1YoSuk1FPQlIYrwdGZIvNPaETsghrhWUKCRS7/q/DGH/c2PQV2A7kH
         fShWFNgXsfasM6byB9SrvsQe8B5jb5Ftp1nqwV+iQHNDv6JJFOR7ezPrSvjbUdkptjzp
         ZFV0HUskQAboJwwDv+Zt65ja2uRdxdGUNFmJzpmke3oxLma+8htDaeC80RYigZO64OBe
         8xLe8Tvq2DMQDtqEU9nJhuJttXRuBYNSAVkEi01PG1V0QS3O44RRdZdZXw7Cp/KpnI6X
         xyWg==
X-Gm-Message-State: AOAM533RXMgEutGnkKoSbE7q2PielzCMPtpI1BJ6yYrdOL2/BxP5tSyw
        +Bi5iT6J/rmBJ1AQm7rjGZVWQ4x+qOy+t/PQWYw=
X-Google-Smtp-Source: ABdhPJzLAZtdQh5aznejLbauphcFF8+SS5/1cEVf1PaB+zfU5KEleGAsRuo5NLJx+k3GkTZco8Sg8YU+JkPD0/pStnc=
X-Received: by 2002:a2e:2f07:: with SMTP id v7mr10860497ljv.51.1592925557988;
 Tue, 23 Jun 2020 08:19:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200623070802.2310018-1-songliubraving@fb.com> <20200623070802.2310018-2-songliubraving@fb.com>
In-Reply-To: <20200623070802.2310018-2-songliubraving@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jun 2020 08:19:06 -0700
Message-ID: <CAADnVQJxinR1fY69hf_rLShdbi947DjGXAH+55eZQDTtm4VBRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 12:08 AM Song Liu <songliubraving@fb.com> wrote:
>
> This helper can be used with bpf_iter__task to dump all /proc/*/stack to
> a seq_file.
>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  include/uapi/linux/bpf.h       | 10 +++++++++-
>  kernel/trace/bpf_trace.c       | 21 +++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 10 +++++++++-
>  4 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 19684813faaed..a30416b822fe3 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3252,6 +3252,13 @@ union bpf_attr {
>   *             case of **BPF_CSUM_LEVEL_QUERY**, the current skb->csum_level
>   *             is returned or the error code -EACCES in case the skb is not
>   *             subject to CHECKSUM_UNNECESSARY.
> + *
> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries, u32 size)
> + *     Description
> + *             Save a task stack trace into array *entries*. This is a wrapper
> + *             over stack_trace_save_tsk().
> + *     Return
> + *             Number of trace entries stored.
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3389,7 +3396,8 @@ union bpf_attr {
>         FN(ringbuf_submit),             \
>         FN(ringbuf_discard),            \
>         FN(ringbuf_query),              \
> -       FN(csum_level),
> +       FN(csum_level),                 \
> +       FN(get_task_stack_trace),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index e729c9e587a07..2c13bcb5c2bce 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1488,6 +1488,23 @@ static const struct bpf_func_proto bpf_get_stack_proto_raw_tp = {
>         .arg4_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_get_task_stack_trace, struct task_struct *, task,
> +          void *, entries, u32, size)
> +{
> +       return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
> +}
> +
> +static int bpf_get_task_stack_trace_btf_ids[5];
> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto = {
> +       .func           = bpf_get_task_stack_trace,
> +       .gpl_only       = true,

why?

> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE_OR_ZERO,

OR_ZERO ? why?

> +       .btf_id         = bpf_get_task_stack_trace_btf_ids,
> +};
> +
>  static const struct bpf_func_proto *
>  raw_tp_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>  {
> @@ -1521,6 +1538,10 @@ tracing_prog_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>                 return prog->expected_attach_type == BPF_TRACE_ITER ?
>                        &bpf_seq_write_proto :
>                        NULL;
> +       case BPF_FUNC_get_task_stack_trace:
> +               return prog->expected_attach_type == BPF_TRACE_ITER ?
> +                       &bpf_get_task_stack_trace_proto :

why limit to iter only?

> + *
> + * int bpf_get_task_stack_trace(struct task_struct *task, void *entries, u32 size)
> + *     Description
> + *             Save a task stack trace into array *entries*. This is a wrapper
> + *             over stack_trace_save_tsk().

size is not documented and looks wrong.
the verifier checks it in bytes, but it's consumed as number of u32s.
