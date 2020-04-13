Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3B01A6F9C
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 01:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389840AbgDMXBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 19:01:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728050AbgDMXBE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 19:01:04 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BBFC0A3BDC;
        Mon, 13 Apr 2020 16:01:05 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id b10so8629441qtt.9;
        Mon, 13 Apr 2020 16:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CN+ze2zFPwxmB3EYCvaRIwTK4A4Ycgw65RJkPZl0Mrc=;
        b=iDtUMlYHpc/g9fgLfdN+9m2vxy2uf30OjMPtJ48yDpueBxzgHzuKpU9oImM3leQqz0
         kgo7BeMXi0XDbUmpMIv9nYUBHgKQWuX2SHfsmZye0wjooget7l+D6BGHOWTodRNMxfEc
         9cn/1LVwY8RaNOthNbs4ws6o+lTVqjVVnILkhZfjt7hGjtDHEejbm+txcBCGnpPmP/7y
         DgQ8UX7Qt7DsYfdHATtcPtKV3Ng1MFZurS62KTjEDZlJ/KZXJAVnzdmL71BwXcAI4qqX
         Vkkv3AN2VzvDf7NbBTipIDmcfFPj7xZvhG/ybeu0CNL9G5alW/+pIKJw5DyMhUHZF+St
         A31g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CN+ze2zFPwxmB3EYCvaRIwTK4A4Ycgw65RJkPZl0Mrc=;
        b=iS4XRtcCZjMdirXzdOAAchFUOcvdr6ROS4hqTzRofryor5rwRUSxIJhzhO2Qhh/rpy
         OiXjVS6y8lwEAH2oFFcXgHmvaisv4kU9vbk55NCxsfC5k+yDm9egCKpkvh+b3bNIn7X8
         vuwZ99lt6LvvmL2xub7EiXRrF6ru/UfuUspFHArXNg4TWYMQ8o9y5B4KR79I5LaY6qFQ
         6wu+VlD0ImQ06zwVrlLPH/nAH3cvBwHpIpE6WYIIwl0rUAmmxA3cOcnpO41KhMy9TtQt
         +9PZaNLPFWqWo/VhUvkY1mHo9nAxEbQyBiBCUQldc34lK1ZXRTLGSplo6tMaKpA3NXIv
         Pc0g==
X-Gm-Message-State: AGi0Pub/mP+28UfzimH/gfSAPZcJpFUaeNNBb6HVdjb4fCOVoruzwbr4
        DR/lowYGMoyp7CCrdeSk33JFVhONDLbx7vGtkjE=
X-Google-Smtp-Source: APiQypIZTQ88yT8sUAekL4byrt0Vp9gX70djLyJpOr7p/YSlNr5hHkoEupBMERang9VTaAsKdEiD/8UVjbjXQKXJSTI=
X-Received: by 2002:ac8:3f6d:: with SMTP id w42mr9173506qtk.171.1586818864078;
 Mon, 13 Apr 2020 16:01:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200408232520.2675265-1-yhs@fb.com> <20200408232529.2676060-1-yhs@fb.com>
In-Reply-To: <20200408232529.2676060-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 13 Apr 2020 16:00:52 -0700
Message-ID: <CAEf4BzYYPHAkx4LFuTs3ejqw2-YUzkLLp7+5WqAWBWPrebymtA@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 08/16] bpf: add task and task/file targets
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

On Wed, Apr 8, 2020 at 4:26 PM Yonghong Song <yhs@fb.com> wrote:
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
>  kernel/bpf/Makefile    |   2 +-
>  kernel/bpf/dump_task.c | 294 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 295 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/dump_task.c
>
> diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
> index 4a1376ab2bea..7e2c73deabab 100644
> --- a/kernel/bpf/Makefile
> +++ b/kernel/bpf/Makefile
> @@ -26,7 +26,7 @@ obj-$(CONFIG_BPF_SYSCALL) += reuseport_array.o
>  endif
>  ifeq ($(CONFIG_SYSFS),y)
>  obj-$(CONFIG_DEBUG_INFO_BTF) += sysfs_btf.o
> -obj-$(CONFIG_BPF_SYSCALL) += dump.o
> +obj-$(CONFIG_BPF_SYSCALL) += dump.o dump_task.o
>  endif
>  ifeq ($(CONFIG_BPF_JIT),y)
>  obj-$(CONFIG_BPF_SYSCALL) += bpf_struct_ops.o
> diff --git a/kernel/bpf/dump_task.c b/kernel/bpf/dump_task.c
> new file mode 100644
> index 000000000000..69b0bcec68e9
> --- /dev/null
> +++ b/kernel/bpf/dump_task.c
> @@ -0,0 +1,294 @@
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
> +struct bpfdump_seq_task_info {
> +       struct pid_namespace *ns;
> +       struct task_struct *task;
> +       u32 id;
> +};
> +
> +static struct task_struct *task_seq_get_next(struct pid_namespace *ns, u32 *id)
> +{
> +       struct task_struct *task;
> +       struct pid *pid;
> +
> +       rcu_read_lock();
> +       pid = idr_get_next(&ns->idr, id);
> +       task = get_pid_task(pid, PIDTYPE_PID);
> +       if (task)
> +               get_task_struct(task);

I think get_pid_task() already calls get_task_struct() internally on
success. See also bpf_task_fd_query() implementation, it doesn't take
extra refcnt on task.

> +       rcu_read_unlock();
> +
> +       return task;
> +}
> +

[...]

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
> +               files = get_files_struct(tk);
> +               put_task_struct(tk);
> +               if (!files)
> +                       return NULL;

There might still be another task with its own files, so shouldn't we
keep iterating tasks here?

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
> +       spin_lock(&files->file_lock);
> +       for (; sfd < files_fdtable(files)->max_fds; sfd++) {
> +               struct file *f;
> +
> +               f = fcheck_files(files, sfd);
> +               if (!f)
> +                       continue;
> +
> +               *fd = sfd;
> +               get_file(f);
> +               spin_unlock(&files->file_lock);
> +               return f;
> +       }
> +
> +       /* the current task is done, go to the next task */
> +       spin_unlock(&files->file_lock);
> +       put_files_struct(files);
> +       *fstruct = NULL;
> +       sid = ++(*id);
> +       goto again;
> +}
> +

[...]

> +static int task_file_seq_show(struct seq_file *seq, void *v)
> +{
> +       struct bpfdump_seq_task_file_info *info = seq->private;
> +       struct {
> +               struct task_struct *task;
> +               u32 fd;
> +               struct file *file;
> +               struct seq_file *seq;
> +               u64 seq_num;

should all the fields here be 8-byte aligned, including pointers
(because BPF is 64-bit arch)? Well, at least `u32 fd` should?

> +       } ctx = {
> +               .file = v,
> +               .seq = seq,
> +       };
> +       struct bpf_prog *prog;
> +       int ret;
> +
> +       prog = bpf_dump_get_prog(seq, sizeof(struct bpfdump_seq_task_file_info),
> +                                &ctx.seq_num);
> +       ctx.task = info->task;
> +       ctx.fd = info->fd;
> +       ret = bpf_dump_run_prog(prog, &ctx);
> +
> +       return ret == 0 ? 0 : -EINVAL;
> +}
> +
> +static const struct seq_operations task_file_seq_ops = {
> +        .start  = task_file_seq_start,
> +        .next   = task_file_seq_next,
> +        .stop   = task_file_seq_stop,
> +        .show   = task_file_seq_show,
> +};
> +
> +int __init bpfdump__task(struct task_struct *task, struct seq_file *seq,
> +                        u64 seq_num) {
> +       return 0;
> +}
> +
> +int __init bpfdump__task_file(struct task_struct *task, u32 fd,
> +                             struct file *file, struct seq_file *seq,
> +                             u64 seq_num)
> +{
> +       return 0;
> +}
> +
> +static int __init task_dump_init(void)
> +{
> +       int ret;
> +
> +       ret = bpf_dump_reg_target("task", "bpfdump__task",
> +                                 &task_seq_ops,
> +                                 sizeof(struct bpfdump_seq_task_info), 0);
> +       if (ret)
> +               return ret;
> +
> +       return bpf_dump_reg_target("task/file", "bpfdump__task_file",
> +                                  &task_file_seq_ops,
> +                                  sizeof(struct bpfdump_seq_task_file_info),
> +                                  0);
> +}
> +late_initcall(task_dump_init);
> --
> 2.24.1
>
