Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5428C20BA66
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbgFZUij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725823AbgFZUij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:38:39 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 349CBC03E979;
        Fri, 26 Jun 2020 13:38:39 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g11so5100490qvs.2;
        Fri, 26 Jun 2020 13:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5A9KYnY7QhqaDBDdTCfkkhegKzoduuLb+R/8pScFTXs=;
        b=SrmREoXa7FATyxyS7+R5Bj6v2piiHMWwzm/HmjsH/3bhpZVVMFjsyrJ2U4RQtQD/0m
         VEN0dwAFOog5suhp2g8rTFvwW8YBc9mtXp3X4lE+XPuUvj0KESwixP2Oc8LmCWcUtM1u
         TNEYtadTLXMycBpnAL3IBCG54f1QCMIct+bDwIO3onF3a8P6F/z20Qu3ElKzpW2i+8zd
         0b5oHMfHHc0k4PdvlifEPWgJTSLEKbpoq5a+GLpi6HCnxD6cdjjebEC0oyYeiTQSOYe2
         EfySQLCF2twa9pOqYO9MC7ZNQtTtDU7tGPFegDzDN3E+zLiqjfWjgB4r6zvyQLu8DyX8
         SHMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5A9KYnY7QhqaDBDdTCfkkhegKzoduuLb+R/8pScFTXs=;
        b=gOR0/dXQ+rDtFNV40UVb/IA7wT9thYJKRB4UTtKKKXGLjbY/gwXPaTDshZavt5PiWE
         aXxGcgpnWn6qDo4XpSE7CWP0dxeG3W0CTH3zjjy8hn6SkC26WbABKerm4xJbzZ3cQycv
         LygMo0dCWQe2Cc5dCOCUadW+6lEFzi/3mmnbc9eFW0Nit6Oe31M9oeTUePnCcHfNplHv
         ttA18FzL84LYo87o0hN3/UhdrHT5YOEUXP6aPbKM4lhRrymOpbFtrWD0e4UZu4EObWXT
         6E/2EK5/WO5QEn+69Uv3fMfwVhJ9CWgDiqEyla+SoNO9xRdrFrQB4Za9n/tVv6J4O2WW
         ToBQ==
X-Gm-Message-State: AOAM532AoldFmkcboL+JTxN22yyNH7++VB3KxEvbUIynsMMsA1I6Ptot
        jFGhzPreh2GUEqTWyeZhwDOGYc/Atinrgu+U7qg=
X-Google-Smtp-Source: ABdhPJwet2e9VD3QkUSQfL35dFttS91K8oCX8GtWYXii57P1aViL3HKt2bSlE2cXZO9aIDqUSmDdhdrSLQMpOsTkBbw=
X-Received: by 2002:a05:6214:8f4:: with SMTP id dr20mr4701485qvb.228.1593203918349;
 Fri, 26 Jun 2020 13:38:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-11-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-11-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:38:27 -0700
Message-ID: <CAEf4BzY4EqkbB7Ob9EZAJrWdBRtH_k3sL=4JZzAiqkMXjYjNKA@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 10/14] bpf: Add d_path helper
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

On Thu, Jun 25, 2020 at 4:49 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding d_path helper function that returns full path
> for give 'struct path' object, which needs to be the
> kernel BTF 'path' object.
>
> The helper calls directly d_path function.
>
> Updating also bpf.h tools uapi header and adding
> 'path' to bpf_helpers_doc.py script.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/uapi/linux/bpf.h       | 14 +++++++++-
>  kernel/trace/bpf_trace.c       | 47 ++++++++++++++++++++++++++++++++++
>  scripts/bpf_helpers_doc.py     |  2 ++
>  tools/include/uapi/linux/bpf.h | 14 +++++++++-
>  4 files changed, 75 insertions(+), 2 deletions(-)
>
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 0cb8ec948816..23274c81f244 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -3285,6 +3285,17 @@ union bpf_attr {
>   *             Dynamically cast a *sk* pointer to a *udp6_sock* pointer.
>   *     Return
>   *             *sk* if casting is valid, or NULL otherwise.
> + *
> + * int bpf_d_path(struct path *path, char *buf, u32 sz)
> + *     Description
> + *             Return full path for given 'struct path' object, which
> + *             needs to be the kernel BTF 'path' object. The path is
> + *             returned in buffer provided 'buf' of size 'sz'.
> + *
> + *     Return
> + *             length of returned string on success, or a negative
> + *             error in case of failure

It's important to note whether string is always zero-terminated (I'm
guessing it is, right?).

> + *
>   */
>  #define __BPF_FUNC_MAPPER(FN)          \
>         FN(unspec),                     \
> @@ -3427,7 +3438,8 @@ union bpf_attr {
>         FN(skc_to_tcp_sock),            \
>         FN(skc_to_tcp_timewait_sock),   \
>         FN(skc_to_tcp_request_sock),    \
> -       FN(skc_to_udp6_sock),
> +       FN(skc_to_udp6_sock),           \
> +       FN(d_path),
>
>  /* integer value in 'imm' field of BPF_CALL instruction selects which helper
>   * function eBPF program intends to call
> diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
> index b124d468688c..6f31e21565b6 100644
> --- a/kernel/trace/bpf_trace.c
> +++ b/kernel/trace/bpf_trace.c
> @@ -1060,6 +1060,51 @@ static const struct bpf_func_proto bpf_send_signal_thread_proto = {
>         .arg1_type      = ARG_ANYTHING,
>  };
>
> +BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
> +{
> +       char *p = d_path(path, buf, sz - 1);
> +       int len;
> +
> +       if (IS_ERR(p)) {
> +               len = PTR_ERR(p);
> +       } else {
> +               len = strlen(p);
> +               if (len && p != buf) {
> +                       memmove(buf, p, len);
> +                       buf[len] = 0;

if len above is zero, you won't zero-terminate it, so probably better
to move buf[len] = 0 out of if to do unconditionally

> +               }
> +       }
> +
> +       return len;
> +}
> +
> +BTF_SET_START(btf_whitelist_d_path)
> +BTF_ID(func, vfs_truncate)
> +BTF_ID(func, vfs_fallocate)
> +BTF_ID(func, dentry_open)
> +BTF_ID(func, vfs_getattr)
> +BTF_ID(func, filp_close)
> +BTF_SET_END(btf_whitelist_d_path)
> +
> +static bool bpf_d_path_allowed(const struct bpf_prog *prog)
> +{
> +       return btf_id_set_contains(&btf_whitelist_d_path, prog->aux->attach_btf_id);
> +}
> +

This looks pretty great and clean, considering what's happening under
the covers. Nice work, thanks a lot!

> +BTF_ID_LIST(bpf_d_path_btf_ids)
> +BTF_ID(struct, path)

this is a bit more confusing to read and error-prone, but I couldn't
come up with any better way to do this... Still better than
alternatives.

> +
> +static const struct bpf_func_proto bpf_d_path_proto = {
> +       .func           = bpf_d_path,
> +       .gpl_only       = true,

Does it have to be GPL-only? What's the criteria? Sorry if this was
brought up previously.

> +       .ret_type       = RET_INTEGER,
> +       .arg1_type      = ARG_PTR_TO_BTF_ID,
> +       .arg2_type      = ARG_PTR_TO_MEM,
> +       .arg3_type      = ARG_CONST_SIZE,
> +       .btf_id         = bpf_d_path_btf_ids,
> +       .allowed        = bpf_d_path_allowed,
> +};
> +

[...]
