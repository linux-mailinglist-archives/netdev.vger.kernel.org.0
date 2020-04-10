Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 896AF1A4C27
	for <lists+netdev@lfdr.de>; Sat, 11 Apr 2020 00:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbgDJWgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 18:36:22 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:40601 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgDJWgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 18:36:22 -0400
Received: by mail-qk1-f194.google.com with SMTP id z15so3685369qki.7;
        Fri, 10 Apr 2020 15:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zr6HBjvgSbOiJkuAYNPevfrmtAynQ3ITGIc7QE3KC+4=;
        b=jGluSRpucagLx3Jt6KQv5U+Sd+q3KfNjr4WnM3zjlONkBoGPI+pgye95wcZ8lVKYEY
         fWBlNGX7vXUuwbyUkVZFVp9+XyV7Vd4FKCdAizWQyvyucxUF/4piZay/rA8slmI+H7tQ
         55X4Hy5ds+RFSVdjwQ8pFUUJ3g47WAttFCpM+B7t8RPMYr0bE5lO3rL5QpWh6IJ3qSw0
         3NkuL3O+g2bypPzABoAfM3fGk/yD5uQmgWsMoC5X8FcuoA6twMPu+QB3gsNV5xnFhe2f
         LLW8PZApya6SyLl7AIVcxnBqs7L5Up9/dvS+pQKVezSQU9RHb0OQBbNNXdeMdvqsfovU
         Te/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zr6HBjvgSbOiJkuAYNPevfrmtAynQ3ITGIc7QE3KC+4=;
        b=EMhrGjMqAOqKz4r41d3l5VxwwfPOvj5uNTA5/yudRqTyb8Vv1qw6CGSHMu9nbzFN0G
         4hE4tChFXRq+cziDF1gU+/ciYJKip5G7MfLD8KFP3GV9Nz0WySOIplSiNxE1zmfec7wm
         qGyaXDA8i1+hVpj0RLka7mp5nhom+Ilp4zegETZlFG06jVQUfKVeXB+kzJHSXhjIMB9k
         lojJh/EjM42xDWUFGpdPOwjRYxSc6Vo1wsEPvkqSfLc3186y+qL9olIzGI4YGrJaJ67j
         obI77AKGQTEE4GZWMmlqpCeKfin8FyMzsr5jcQbukmWJ3ATi4WS0GYe1TYDMj9xRhgr2
         istw==
X-Gm-Message-State: AGi0PuYXauHyyin2aZds1/4Oa07Qy2Gc3ioRT8WZK7Tqedgx7u/Y9v0/
        QPdSm4ghvhiS9wy1+mqZfFYjqqUWKLY0py3jRR6uGMbC4mFqbQ==
X-Google-Smtp-Source: APiQypLQF9+js2QG7ftCVU7ZqY+pAXVYHnQkbnBk0LjVpzNsBYUIPhbGXfgBFHTRZpz3zC+WxcB+7a0HT1F0vzAVolk=
X-Received: by 2002:a37:b786:: with SMTP id h128mr6204817qkf.92.1586558179955;
 Fri, 10 Apr 2020 15:36:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232524.2675603-1-yhs@fb.com>
In-Reply-To: <20200408232524.2675603-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 10 Apr 2020 15:36:09 -0700
Message-ID: <CAEf4BzaTvAMOLVfhqvFCY_5Aj32J4vVSm343-C4Cg7Xyr65H4w@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 04/16] bpf: allow loading of a dumper program
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 4:25 PM Yonghong Song <yhs@fb.com> wrote:
>
> A dumper bpf program is a tracing program with attach type
> BPF_TRACE_DUMP. During bpf program load, the load attribute
>    attach_prog_fd
> carries the target directory fd. The program will be
> verified against btf_id of the target_proto.
>
> If the program is loaded successfully, the dump target, as
> represented as a relative path to /sys/kernel/bpfdump,
> will be remembered in prog->aux->dump_target, which will
> be used later to create dumpers.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  include/linux/bpf.h            |  2 ++
>  include/uapi/linux/bpf.h       |  1 +
>  kernel/bpf/dump.c              | 40 ++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c           |  8 ++++++-
>  kernel/bpf/verifier.c          | 15 +++++++++++++
>  tools/include/uapi/linux/bpf.h |  1 +
>  6 files changed, 66 insertions(+), 1 deletion(-)
>

[...]

>
> +int bpf_dump_set_target_info(u32 target_fd, struct bpf_prog *prog)
> +{
> +       struct bpfdump_target_info *tinfo;
> +       const char *target_proto;
> +       struct file *target_file;
> +       struct fd tfd;
> +       int err = 0, btf_id;
> +
> +       if (!btf_vmlinux)
> +               return -EINVAL;
> +
> +       tfd = fdget(target_fd);
> +       target_file = tfd.file;
> +       if (!target_file)
> +               return -EBADF;

fdput is missing (or rather err = -BADF; goto done; ?)


> +
> +       if (target_file->f_inode->i_op != &bpf_dir_iops) {
> +               err = -EINVAL;
> +               goto done;
> +       }
> +
> +       tinfo = target_file->f_inode->i_private;
> +       target_proto = tinfo->target_proto;
> +       btf_id = btf_find_by_name_kind(btf_vmlinux, target_proto,
> +                                      BTF_KIND_FUNC);
> +
> +       if (btf_id > 0) {
> +               prog->aux->dump_target = tinfo->target;
> +               prog->aux->attach_btf_id = btf_id;
> +       }
> +
> +       err = min(btf_id, 0);

this min trick looks too clever... why not more straightforward and composable:

if (btf_id < 0) {
    err = btf_id;
    goto done;
}

prog->aux->dump_target = tinfo->target;
prog->aux->attach_btf_id = btf_id;

?

> +done:
> +       fdput(tfd);
> +       return err;
> +}
> +
>  int bpf_dump_reg_target(const char *target,
>                         const char *target_proto,
>                         const struct seq_operations *seq_ops,
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 64783da34202..41005dee8957 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2060,7 +2060,12 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>
>         prog->expected_attach_type = attr->expected_attach_type;
>         prog->aux->attach_btf_id = attr->attach_btf_id;
> -       if (attr->attach_prog_fd) {
> +       if (type == BPF_PROG_TYPE_TRACING &&
> +           attr->expected_attach_type == BPF_TRACE_DUMP) {
> +               err = bpf_dump_set_target_info(attr->attach_prog_fd, prog);

looking at bpf_attr, it's not clear why attach_prog_fd and
prog_ifindex were not combined into a single union field... this
probably got missed? But in this case I'd say let's create a

union {
    __u32 attach_prog_fd;
    __u32 attach_target_fd; (similar to terminology for BPF_PROG_ATTACH)
};

instead of reusing not-exactly-matching field names?

> +               if (err)
> +                       goto free_prog_nouncharge;
> +       } else if (attr->attach_prog_fd) {
>                 struct bpf_prog *tgt_prog;
>
>                 tgt_prog = bpf_prog_get(attr->attach_prog_fd);
> @@ -2145,6 +2150,7 @@ static int bpf_prog_load(union bpf_attr *attr, union bpf_attr __user *uattr)
>         err = bpf_prog_new_fd(prog);
>         if (err < 0)
>                 bpf_prog_put(prog);
> +
>         return err;
>

[...]
