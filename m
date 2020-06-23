Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9593205B13
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733219AbgFWSqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733138AbgFWSqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:46:04 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5983C061573;
        Tue, 23 Jun 2020 11:46:03 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id cv17so10134305qvb.13;
        Tue, 23 Jun 2020 11:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=za1LKKD9EFDuXlpTMDU9rDuuS7ZxTYoV0j3nOYrgg8Y=;
        b=MQFLcnnzYv0qm78JGPqIhgJJ43qBk+LC9drirbqEAaokRqGOY36z/Ogrvfzt9jUrlr
         cSVwjWdJX0yFWKSvhRo+bK7LzbGA6gTXRo+/+oiUEyj9n6Mlcr3cwKBVhML+apnpFUb2
         nfzNW2oJdQOqxkdbXXGoCIwr2lNZM2KGmCjJwT1MCazsb3trLG5bgNy4nFvOQvdkfdh2
         Tkr6LefNqzzN4ZRK7l5kMcePxXwqot+va2OYPyWxbanhQ+Fkt6SAAcWWRDSlI2+LzUlK
         KhbsIkofFyCV7nvSttBGN+o+ELXkPjsseTn4iX80rMmFeNGLLxysV+x/aZuCE7voIx6Q
         UrMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=za1LKKD9EFDuXlpTMDU9rDuuS7ZxTYoV0j3nOYrgg8Y=;
        b=MqtssoPVyn+ykcksNjKQeclK15KsAJlCVwWDdINksrgA5X7XbeH9EukfHq22YCIBPj
         l11NONAGnmfnfDQRecKCmCK+35p+qa0Mt8zUMu1Dp01NPozM44/E90rne2rrm+dN5UlR
         bJpNR7USKVFsWD4/dwI77s9QodiILmZ2Gk9Oji6mrsJCbVGhMlMOmFnpaUmJGkO4YI7M
         15/RYvU/rhn0w5opmjbvQTP5gzx2DPJmuNyk9IKgFneQWLUQi24E1HXGC8yXeDMUSGng
         VaBAChbpOYpPbrP4LOP3gtQtUAXMZfnmM7xwBNvHW1pdf9a9ydGrr278LIN2C3HDYGQh
         a8pg==
X-Gm-Message-State: AOAM5319vf8i5PMA1jgD6YhS26KsiQ0qZ6XLK5B3LDFdSU/6BvvPMwMN
        E4t1EsaIV/8sbTARV94LmpYHIcyo/evZhTFIwHY=
X-Google-Smtp-Source: ABdhPJxo1Lac7Ic7jCIc+nCyYrGDSZg3RTPoBUYi6k9fGkHRKu+t2t5e353JfBVrRnbRUiduvtGsBg6YM3tp9m7yEds=
X-Received: by 2002:a0c:9ae2:: with SMTP id k34mr26973278qvf.247.1592937963129;
 Tue, 23 Jun 2020 11:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200623070802.2310018-1-songliubraving@fb.com> <20200623070802.2310018-2-songliubraving@fb.com>
In-Reply-To: <20200623070802.2310018-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:45:52 -0700
Message-ID: <CAEf4Bzb3_oAyOKKEQ8+Ub5H6aaYQPh15NqyAdQQ+BXjur2Yswg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: introduce helper bpf_get_task_stack_trace()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
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

We have get_stackid and get_stack, I think to stay consistent it
should be named get_task_stack

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

See get_stack definition, this one needs to support flags as well. And
we should probably support BPF_F_USER_BUILD_ID as well. And
BPF_F_USER_STACK is also a good idea, I presume?

> +{
> +       return stack_trace_save_tsk(task, (unsigned long *)entries, size, 0);
> +}
> +
> +static int bpf_get_task_stack_trace_btf_ids[5];
> +static const struct bpf_func_proto bpf_get_task_stack_trace_proto = {
> +       .func           = bpf_get_task_stack_trace,
> +       .gpl_only       = true,
> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE_OR_ZERO,
> +       .btf_id         = bpf_get_task_stack_trace_btf_ids,
> +};
> +

[...]
