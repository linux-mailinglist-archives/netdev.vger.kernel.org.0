Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168CF1C6A15
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 09:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEFHaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 03:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727067AbgEFHaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 03:30:15 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3CC3C061A0F;
        Wed,  6 May 2020 00:30:15 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so943872qkh.11;
        Wed, 06 May 2020 00:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y8H3v1in/yldZzKXzjwYAl5OsrPTXL+w2BtzihawKeg=;
        b=Vi9utcwOydH0OKy07Z1Z3JGyCRJEU7byku6e0Y8xyONuU7rrgK8K/EB9NOGWq8eO4A
         nUsgIX1z6YuroHxtxBle+Htx+z9anXIcyAPEQ39gQaotzhsCIkA034SW+9qT52+O3zWQ
         ZEorzimKEm85q4XZDSlnH860aonXPFD8oBQZzxqfIfPydUbDBdTKNHmHVkvgCQ4U9E59
         pHXm3SHjtwedPe1W+3n2vac5uiGzivHdk7p2Dmx1XnNVN+tN5xriE3ohXcSixV5oIb06
         KEXeEWLdwXrM8XXafP8AYbPu927aWGOeiM6yE6QLZwZ5nfFOicuYj0rvQDOX8/nMSwrC
         tICA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y8H3v1in/yldZzKXzjwYAl5OsrPTXL+w2BtzihawKeg=;
        b=mlPeya5UyHBhPPIPmW4VlsqkE10brLZJsCvuPyDnKHHW2XO7TmP4NW3WWW99NNS42M
         PAYyIiHN8w7H2ncCwkFrIRTtyoaX42BZ/pYDcZkBDXDcObhX5Z4H9WdfvaWKcGEncfiF
         VtYb4SFAeWrbhD7VNE4Z5+xRnbi+aDeL3o43hb7cZW/XUAD9+ttSUBl2fvNvqJPAezmO
         YGcDpdAgwg+3acSdsB6Eyo2DbukQlzGJvQYzb5+xbVwCFHyRRUvmNcCvkwpMgI2iyG8E
         zkWIYZIQOerzcEQv0tRmcdICbeMPASHzmbTR1GPpZEEwheffojWWuLJS5TP6I1ik6x4R
         Nn0A==
X-Gm-Message-State: AGi0PuaqG/tVVYUXcYx0YF0FjDyVLy7sgQqQwc/cmSD+nSv+lDZv+OoL
        adKltWmGbNY7pq0qbdlYvS21LmIUUaySatBNdB4ESsgZ
X-Google-Smtp-Source: APiQypJwB2DWGkRMoHR7cAVgt0s6h62qKpnSUVRRU8+EsMyfqbD3dnty637FmpR+YGBXXb5cinyldmnLu/EC2s3BCrs=
X-Received: by 2002:ae9:e713:: with SMTP id m19mr7422561qka.39.1588750214663;
 Wed, 06 May 2020 00:30:14 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062559.2048228-1-yhs@fb.com>
In-Reply-To: <20200504062559.2048228-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 00:30:03 -0700
Message-ID: <CAEf4BzbySjaBQSMTET=HGD_K748GOXZZQ7zMhgtEqE-JgJGbdQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/20] bpf: add task and task/file iterator targets
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

On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>
> Only the tasks belonging to "current" pid namespace
> are enumerated.
>
> For task/file target, the bpf program will have access to
>   struct task_struct *task
>   u32 fd
>   struct file *file
> where fd/file is an open file for the task.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

I might be missing some subtleties with task refcounting for task_file
iterator, asked few questions below...

>  kernel/bpf/Makefile    |   2 +-
>  kernel/bpf/task_iter.c | 336 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 337 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/task_iter.c
>
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index b2b5eefc5254..37b2d8620153 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -2,7 +2,7 @@
>  obj-y := core.o
>  CFLAGS_core.o += $(call cc-disable-warning, override-init)
>
> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
>  obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
>  obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
>  obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> new file mode 100644
> index 000000000000..1ca258f6e9f4
> --- /dev/null
> +++ b/kernel/bpf/task_iter.c
> @@ -0,0 +1,336 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/* Copyright (c) 2020 Facebook */
> +
> +#include <linux/init.h>
> +#include <linux/namei.h>
> +#include <linux/pid_namespace.h>
> +#include <linux/fs.h>
> +#include <linux/fdtable.h>
> +#include <linux/filter.h>
> +
> +struct bpf_iter_seq_task_common {
> +       struct pid_namespace *ns;
> +};
> +
> +struct bpf_iter_seq_task_info {
> +       struct bpf_iter_seq_task_common common;

you have comment below in init_seq_pidns() that common is supposed to
be the very first field, but I think it's more important and
appropriate here, so that whoever adds anything here knows that order
of field is important.

> +       struct task_struct *task;
> +       u32 id;
> +};
> +

[...]

> +static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)
> +{
> +       struct bpf_iter_meta meta;
> +       struct bpf_iter__task ctx;
> +       struct bpf_prog *prog;
> +       int ret = 0;
> +
> +       meta.seq = seq;
> +       prog = bpf_iter_get_info(&meta, in_stop);
> +       if (prog) {


nit: `if (!prog) return 0;` here would reduce nesting level below

> +               meta.seq = seq;
> +               ctx.meta = &meta;
> +               ctx.task = v;
> +               ret = bpf_iter_run_prog(prog, &ctx);
> +       }
> +
> +       return 0;

return **ret**; ?

> +}
> +

[...]

> +
> +static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32 *id,
> +                                          int *fd, struct task_struct **task,
> +                                          struct files_struct **fstruct)
> +{
> +       struct files_struct *files;
> +       struct task_struct *tk;
> +       u32 sid = *id;
> +       int sfd;
> +
> +       /* If this function returns a non-NULL file object,
> +        * it held a reference to the files_struct and file.
> +        * Otherwise, it does not hold any reference.
> +        */
> +again:
> +       if (*fstruct) {
> +               files = *fstruct;
> +               sfd = *fd;
> +       } else {
> +               tk = task_seq_get_next(ns, &sid);
> +               if (!tk)
> +                       return NULL;
> +
> +               files = get_files_struct(tk);
> +               put_task_struct(tk);

task is put here, but is still used below.. is there some additional
hidden refcounting involved?

> +               if (!files) {
> +                       sid = ++(*id);
> +                       *fd = 0;
> +                       goto again;
> +               }
> +               *fstruct = files;
> +               *task = tk;
> +               if (sid == *id) {
> +                       sfd = *fd;
> +               } else {
> +                       *id = sid;
> +                       sfd = 0;
> +               }
> +       }
> +
> +       rcu_read_lock();
> +       for (; sfd < files_fdtable(files)->max_fds; sfd++) {

files_fdtable does rcu_dereference on each iteration, would it be
better to just cache files_fdtable(files)->max_fds into local
variable? It's unlikely that there will be many iterations, but
still...

> +               struct file *f;
> +
> +               f = fcheck_files(files, sfd);
> +               if (!f)
> +                       continue;
> +               *fd = sfd;
> +               get_file(f);
> +               rcu_read_unlock();
> +               return f;
> +       }
> +
> +       /* the current task is done, go to the next task */
> +       rcu_read_unlock();
> +       put_files_struct(files);
> +       *fstruct = NULL;

*task = NULL; for completeness?

> +       sid = ++(*id);
> +       *fd = 0;
> +       goto again;
> +}
> +
> +static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +       struct bpf_iter_seq_task_file_info *info = seq->private;
> +       struct files_struct *files = NULL;
> +       struct task_struct *task = NULL;
> +       struct file *file;
> +       u32 id = info->id;
> +       int fd = info->fd;
> +
> +       file = task_file_seq_get_next(info->common.ns, &id, &fd, &task, &files);
> +       if (!file) {
> +               info->files = NULL;

what about info->task here?

> +               return NULL;
> +       }
> +
> +       ++*pos;
> +       info->id = id;
> +       info->fd = fd;
> +       info->task = task;
> +       info->files = files;
> +
> +       return file;
> +}
> +

[...]

> +
> +struct bpf_iter__task_file {
> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> +       __bpf_md_ptr(struct task_struct *, task);
> +       u32 fd;

nit: sort of works by accident (due to all other field being 8-byte
aligned pointers), shall we add __attribute__((aligned(8)))?

> +       __bpf_md_ptr(struct file *, file);
> +};
> +

[...]
