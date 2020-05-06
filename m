Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E554A1C7B8A
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729114AbgEFUv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:51:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726815AbgEFUv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 16:51:59 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3201C061A0F;
        Wed,  6 May 2020 13:51:58 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 23so3724517qkf.0;
        Wed, 06 May 2020 13:51:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j5vLTY8ot16sqeaceuPl0s1a4gnwtu8Y7iX+OYPcAp8=;
        b=e8zPFuoQ0UYjwykN4KRb+b04qrr4s0BobyRinRk077HIQAchFtddSPagk0L3LR/xcW
         HNNzTUbNUIFVVcoR935y6x1UTSeAqcp6hMt28RocNYE+JvxOC3n6ZyAuGAUEuYGHsOZq
         WqNbsSH5egFtZ6J+fiNbpoDUcvXyNafbkWgTOLAPvV1P5qQqxkko+vR6cG2T+6Um8A6L
         vd0DxJ67dz88Ebe/IBHpWlANU2YmQQcko52Y84unky22h0b/DYE5RRlp9iiiRnaVmjof
         dre08ZXLe/5cU4Z2Mpdy+5yamkxh1jL5OKThw6ogtkc3hw1Tjv+yOl3QadxdORL2wF0r
         8mrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j5vLTY8ot16sqeaceuPl0s1a4gnwtu8Y7iX+OYPcAp8=;
        b=DJGhoHdRac2+gGgU5tOsCxFH/uuUEBPxgN+Uu8oUy9wjRh6NpM9MlnC8iMcmDWz6w+
         Qhdj8E29Rjjku4/6ors2xLzFwgHuuGCjXupoj6x8ye1obtkDxrDrO6p3iE7wwgyOlj4Q
         F7RLjKnpa9SRbncWepQy6Ah11cgog+SLOqHoSAKDhiopumLoo8hLdY62HLxa5C4aUC7o
         pIv9s8/puMbuhZurR2nUoRv7w3gw6fr3QM0IftfVxv3ih6gSx5A6ymslMswawO/pju44
         3t9263TOfd1qFBvs64qlCKZnKqXMY3X+x+QPdBdZO51m6MLyCPbtxgP031Krgp8X5Siz
         SVdQ==
X-Gm-Message-State: AGi0PuYRSPswzayrKvp+AvnrYWdshUXh/c0/MSMcX2ifreKHkBaluXQh
        nQxe+ffqQlu6YwkSl9icTvTFfDAWYRv4irHwSac=
X-Google-Smtp-Source: APiQypLGxXPJ7w/xqowtFT+XMC1Ip/UvifAtNeGRUuJwi0/OKNcWn3zFOLeqSrM+H05e7J1X5K7dXrBEhVk/1XSfpfw=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr10821983qkj.92.1588798318006;
 Wed, 06 May 2020 13:51:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062559.2048228-1-yhs@fb.com>
 <CAEf4BzbySjaBQSMTET=HGD_K748GOXZZQ7zMhgtEqE-JgJGbdQ@mail.gmail.com> <8758f1c9-f4ea-af99-9af8-afe9fb210928@fb.com>
In-Reply-To: <8758f1c9-f4ea-af99-9af8-afe9fb210928@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 6 May 2020 13:51:46 -0700
Message-ID: <CAEf4BzaTTdChHsEy=WX8-j-1c66baZnppK6WaSjexewjph0O=g@mail.gmail.com>
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

On Wed, May 6, 2020 at 11:24 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 5/6/20 12:30 AM, Andrii Nakryiko wrote:
> > On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
> >>
> >> Only the tasks belonging to "current" pid namespace
> >> are enumerated.
> >>
> >> For task/file target, the bpf program will have access to
> >>    struct task_struct *task
> >>    u32 fd
> >>    struct file *file
> >> where fd/file is an open file for the task.
> >>
> >> Signed-off-by: Yonghong Song <yhs@fb.com>
> >> ---
> >
> > I might be missing some subtleties with task refcounting for task_file
> > iterator, asked few questions below...
> >
> >>   kernel/bpf/Makefile    |   2 +-
> >>   kernel/bpf/task_iter.c | 336 +++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 337 insertions(+), 1 deletion(-)
> >>   create mode 100644 kernel/bpf/task_iter.c
> >>
> >> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> >> index b2b5eefc5254..37b2d8620153 100644
> >> --- a/kernel/bpf/Makefile
> >> +++ b/kernel/bpf/Makefile
> >> @@ -2,7 +2,7 @@
> >>   obj-y := core.o
> >>   CFLAGS_core.o += $(call cc-disable-warning, override-init)
> >>
> >> -obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o
> >> +obj-$(CONFIG_BPF_SYSCALL) += syscall.o verifier.o inode.o helpers.o tnum.o bpf_iter.o map_iter.o task_iter.o
> >>   obj-$(CONFIG_BPF_SYSCALL) += hashtab.o arraymap.o percpu_freelist.o bpf_lru_list.o lpm_trie.o map_in_map.o
> >>   obj-$(CONFIG_BPF_SYSCALL) += local_storage.o queue_stack_maps.o
> >>   obj-$(CONFIG_BPF_SYSCALL) += disasm.o
> >> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> >> new file mode 100644
> >> index 000000000000..1ca258f6e9f4
> >> --- /dev/null
> >> +++ b/kernel/bpf/task_iter.c
> >> @@ -0,0 +1,336 @@
> >> +// SPDX-License-Identifier: GPL-2.0-only
> >> +/* Copyright (c) 2020 Facebook */
> >> +
> >> +#include <linux/init.h>
> >> +#include <linux/namei.h>
> >> +#include <linux/pid_namespace.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/fdtable.h>
> >> +#include <linux/filter.h>
> >> +
> >> +struct bpf_iter_seq_task_common {
> >> +       struct pid_namespace *ns;
> >> +};
> >> +
> >> +struct bpf_iter_seq_task_info {
> >> +       struct bpf_iter_seq_task_common common;
> >
> > you have comment below in init_seq_pidns() that common is supposed to
> > be the very first field, but I think it's more important and
> > appropriate here, so that whoever adds anything here knows that order
> > of field is important.
>
> I can move the comments here.
>
> >
> >> +       struct task_struct *task;
> >> +       u32 id;
> >> +};
> >> +
> >
> > [...]
> >
> >> +static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)
> >> +{
> >> +       struct bpf_iter_meta meta;
> >> +       struct bpf_iter__task ctx;
> >> +       struct bpf_prog *prog;
> >> +       int ret = 0;
> >> +
> >> +       meta.seq = seq;
> >> +       prog = bpf_iter_get_info(&meta, in_stop);
> >> +       if (prog) {
> >
> >
> > nit: `if (!prog) return 0;` here would reduce nesting level below
> >
> >> +               meta.seq = seq;
> >> +               ctx.meta = &meta;
> >> +               ctx.task = v;
> >> +               ret = bpf_iter_run_prog(prog, &ctx);
> >> +       }
> >> +
> >> +       return 0;
> >
> > return **ret**; ?
>
> It should return "ret". In task_file show() code is similar but correct.
> I can do early return with !prog too although we do not have
> deep nesting level yet.
>
> >
> >> +}
> >> +
> >
> > [...]
> >
> >> +
> >> +static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32 *id,
> >> +                                          int *fd, struct task_struct **task,
> >> +                                          struct files_struct **fstruct)
> >> +{
> >> +       struct files_struct *files;
> >> +       struct task_struct *tk;
> >> +       u32 sid = *id;
> >> +       int sfd;
> >> +
> >> +       /* If this function returns a non-NULL file object,
> >> +        * it held a reference to the files_struct and file.
> >> +        * Otherwise, it does not hold any reference.
> >> +        */
> >> +again:
> >> +       if (*fstruct) {
> >> +               files = *fstruct;
> >> +               sfd = *fd;
> >> +       } else {
> >> +               tk = task_seq_get_next(ns, &sid);
> >> +               if (!tk)
> >> +                       return NULL;
> >> +
> >> +               files = get_files_struct(tk);
> >> +               put_task_struct(tk);
> >
> > task is put here, but is still used below.. is there some additional
> > hidden refcounting involved?
>
> Good question. I had an impression that we take a reference count
> for task->files so task should not go away. But reading linux
> code again, I do not have sufficient evidence to back my claim.
> So I will reference count task as well, e.g., do not put_task_struct()
> until all files are done here.

All threads within the process share files table. So some threads
might exit, but files will stay, which is why task_struct and
files_struct have separate refcounting, and having refcount on files
doesn't guarantee any particular task will stay alive for long enough.
So I think we need to refcount both files and task in this case.
Reading source code of copy_files() in kernel/fork.c (CLONE_FILES
flags just bumps refcnt on old process' files_struct), seems to
confirm this as well.

>
> >
> >> +               if (!files) {
> >> +                       sid = ++(*id);
> >> +                       *fd = 0;
> >> +                       goto again;
> >> +               }
> >> +               *fstruct = files;
> >> +               *task = tk;
> >> +               if (sid == *id) {
> >> +                       sfd = *fd;
> >> +               } else {
> >> +                       *id = sid;
> >> +                       sfd = 0;
> >> +               }
> >> +       }
> >> +
> >> +       rcu_read_lock();
> >> +       for (; sfd < files_fdtable(files)->max_fds; sfd++) {
> >
> > files_fdtable does rcu_dereference on each iteration, would it be
> > better to just cache files_fdtable(files)->max_fds into local
> > variable? It's unlikely that there will be many iterations, but
> > still...
>
> I borrowed code from fs/proc/fd.c. But I can certainly to avoid
> repeated reading max_fds as suggested.
>
> >
> >> +               struct file *f;
> >> +
> >> +               f = fcheck_files(files, sfd);
> >> +               if (!f)
> >> +                       continue;
> >> +               *fd = sfd;
> >> +               get_file(f);
> >> +               rcu_read_unlock();
> >> +               return f;
> >> +       }
> >> +
> >> +       /* the current task is done, go to the next task */
> >> +       rcu_read_unlock();
> >> +       put_files_struct(files);
> >> +       *fstruct = NULL;
> >
> > *task = NULL; for completeness?
>
> if *fstruct == NULL, will try to get next task, so *task = NULL
> is unnecessary, but I can add it, won't hurt and possibly make
> it easy to understand.
>
> >
> >> +       sid = ++(*id);
> >> +       *fd = 0;
> >> +       goto again;
> >> +}
> >> +
> >> +static void *task_file_seq_start(struct seq_file *seq, loff_t *pos)
> >> +{
> >> +       struct bpf_iter_seq_task_file_info *info = seq->private;
> >> +       struct files_struct *files = NULL;
> >> +       struct task_struct *task = NULL;
> >> +       struct file *file;
> >> +       u32 id = info->id;
> >> +       int fd = info->fd;
> >> +
> >> +       file = task_file_seq_get_next(info->common.ns, &id, &fd, &task, &files);
> >> +       if (!file) {
> >> +               info->files = NULL;
> >
> > what about info->task here?
>
> info->files == NULL indicates the end of iteration, info->task will not
> be checked any more. But I guess, I can assign NULL to task as well to
> avoid confusion.
>
> >
> >> +               return NULL;
> >> +       }
> >> +
> >> +       ++*pos;
> >> +       info->id = id;
> >> +       info->fd = fd;
> >> +       info->task = task;
> >> +       info->files = files;
> >> +
> >> +       return file;
> >> +}
> >> +
> >
> > [...]
> >
> >> +
> >> +struct bpf_iter__task_file {
> >> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> >> +       __bpf_md_ptr(struct task_struct *, task);
> >> +       u32 fd;
> >
> > nit: sort of works by accident (due to all other field being 8-byte
> > aligned pointers), shall we add __attribute__((aligned(8)))?
>
> This is what I thought as well. It should work. But I think
> add aligned(8) wont' hurt to expresss the intention.. Will add it.
>
> >
> >> +       __bpf_md_ptr(struct file *, file);
> >> +};
> >> +
> >
> > [...]
> >
