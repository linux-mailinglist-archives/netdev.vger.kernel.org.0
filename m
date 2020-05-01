Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D33D1C1D7D
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 21:01:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730416AbgEATBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 15:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729766AbgEATBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 15:01:20 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8CA7C061A0C;
        Fri,  1 May 2020 12:01:20 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b188so10156514qkd.9;
        Fri, 01 May 2020 12:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=POQ5NKa4769BoncsZBdGJ5a0YBr+BMUrQYDGRmZ417U=;
        b=lN9hoQN1AAp9IsoVmGdhomDPRXA+QillGn1eqg2Gyu3FbmOMn6O2rujAmsQ+9GX6Za
         yJQzTsfLtJhOHoLLo7a0cu9h/Qv5uoNZz8FJNqFSLZrYvkFGcChY8yvBevIuYG0CmY5/
         kWqKFn4314B5KoEJOlwnS874Mn5QDJFYNK0p6yO7rblPhpuScWuLastXjt3FNLXwtRlT
         tmb0ltML3CbrWQd9/WKpJvXJ6PYL3aNea5c8S66/ioIR+LuwY+yBqc5mlXgzUt4jqAPk
         REDIoUVps+hLEWcUZu27Jsm1G065RWA2LkLAGRM85dNBDOd8C+lshN3QLjKpIgG/ca9c
         VeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=POQ5NKa4769BoncsZBdGJ5a0YBr+BMUrQYDGRmZ417U=;
        b=Rw1POnUGFCacu8VNCb4ybA7Xm2kCj1vudzZVoosBq+IeDIhgsBOH7Nd6bBSvbJ/InF
         aKH3hVxAQ+xDv52X/VnSmGrpkqVF9DHOzr+04b6zUx+d/V3p2xuwRWvWSlDkC1qrjgM0
         DQjijJrupFZz3n6CvdSlVbJHcLU++O4MkE2F16aTlCnB00fuggaHSfpxZUij/H0i+cVV
         ooE8WPlbjSuDogLyRdSXxoCHwKRGRe1Si5Epv5OnMYp1gOg/hRz20hXHmHGR+QH0v7SY
         d64rKfOepTMXVL7QqU8vLuhYYcH7P3h6dXv5Jk+oFBtfhCq8gRZL+VDNwOD6gyayhhzS
         xTtA==
X-Gm-Message-State: AGi0PuYpXVlkIIovgThxtrddvPIN9GlvD+JNuzUmJ9WfjFS3W+0mj9Dw
        U8FFwGsmW20t9M2OpFizcQRZdxdEe9hARHO8UHE=
X-Google-Smtp-Source: APiQypLzPaCgu8lwSdmV9SfYyeyTDgzE55zdxWpN1RCkpl2uAsQaWOoDZEdMJ2G9pQsIcnT4uuwlQhkr9vBoAuiomwE=
X-Received: by 2002:ae9:e10b:: with SMTP id g11mr5415473qkm.449.1588359679709;
 Fri, 01 May 2020 12:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201247.2995622-1-yhs@fb.com>
 <CAEf4BzaWkKbtDQf=0gOBj7Q6icswh61ky3FFS8bAmhkefDV0tg@mail.gmail.com> <dc46e006-468d-22d6-91bc-2c8e75590205@fb.com>
In-Reply-To: <dc46e006-468d-22d6-91bc-2c8e75590205@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 1 May 2020 12:01:08 -0700
Message-ID: <CAEf4BzZij0uXAvvkNJQNOF=fu44Bg+SsxX7x3WWg2+5wsOATrQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 11/19] bpf: add task and task/file targets
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

On Fri, May 1, 2020 at 10:23 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/29/20 7:08 PM, Andrii Nakryiko wrote:
> > On Mon, Apr 27, 2020 at 1:17 PM Yonghong Song <yhs@fb.com> wrote:
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
> >>   kernel/bpf/Makefile    |   2 +-
> >>   kernel/bpf/task_iter.c | 319 +++++++++++++++++++++++++++++++++++++++++
> >>   2 files changed, 320 insertions(+), 1 deletion(-)
> >>   create mode 100644 kernel/bpf/task_iter.c
> >>
> >
> > [...]
> >
> >> +static void *task_seq_start(struct seq_file *seq, loff_t *pos)
> >> +{
> >> +       struct bpf_iter_seq_task_info *info = seq->private;
> >> +       struct task_struct *task;
> >> +       u32 id = info->id;
> >> +
> >> +       if (*pos == 0)
> >> +               info->ns = task_active_pid_ns(current);
> >
> > I wonder why pid namespace is set in start() callback each time, while
> > net_ns was set once when seq_file is created. I think it should be
> > consistent, no? Either pid_ns is another feature and is set
> > consistently just once using the context of the process that creates
> > seq_file, or net_ns could be set using the same method without
> > bpf_iter infra knowing about this feature? Or there are some
> > non-obvious aspects which make pid_ns easier to work with?
> >
> > Either way, process read()'ing seq_file might be different than
> > process open()'ing seq_file, so they might have different namespaces.
> > We need to decide explicitly which context should be used and do it
> > consistently.
>
> Good point. for networking case, the `net` namespace is locked
> at seq_file open stage and later on it is used for seq_read().
>
> I think I should do the same thing, locking down pid namespace
> at open.

Yeah, I think it's a good idea.

>
> >
> >> +
> >> +       task = task_seq_get_next(info->ns, &id);
> >> +       if (!task)
> >> +               return NULL;
> >> +
> >> +       ++*pos;
> >> +       info->task = task;
> >> +       info->id = id;
> >> +
> >> +       return task;
> >> +}
> >> +
> >> +static void *task_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> >> +{
> >> +       struct bpf_iter_seq_task_info *info = seq->private;
> >> +       struct task_struct *task;
> >> +
> >> +       ++*pos;
> >> +       ++info->id;
> >
> > this would make iterator skip pid 0? Is that by design?
>
> The start will try to find pid 0. That means start will never
> return SEQ_START_TOKEN since the bpf program won't be called any way.

Never mind, I confused task_seq_next() and task_seq_get_next() :)

>
> >
> >> +       task = task_seq_get_next(info->ns, &info->id);
> >> +       if (!task)
> >> +               return NULL;
> >> +
> >> +       put_task_struct(info->task);
> >
> > on very first iteration info->task might be NULL, right?
>
> Even the first iteration info->task is not NULL. The start()
> will forcefully try to find the first real task from idr number 0.
>

Right, goes to same confusion as above, sorry.

> >
> >> +       info->task = task;
> >> +       return task;
> >> +}
> >> +
> >> +struct bpf_iter__task {
> >> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> >> +       __bpf_md_ptr(struct task_struct *, task);
> >> +};
> >> +
> >> +int __init __bpf_iter__task(struct bpf_iter_meta *meta, struct task_struct *task)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +static int task_seq_show(struct seq_file *seq, void *v)
> >> +{
> >> +       struct bpf_iter_meta meta;
> >> +       struct bpf_iter__task ctx;
> >> +       struct bpf_prog *prog;
> >> +       int ret = 0;
> >> +
> >> +       prog = bpf_iter_get_prog(seq, sizeof(struct bpf_iter_seq_task_info),
> >> +                                &meta.session_id, &meta.seq_num,
> >> +                                v == (void *)0);
> >> +       if (prog) {
> >
> > can it happen that prog is NULL?
>
> Yes, this function is shared between show() and stop().
> The stop() function might be called multiple times since
> user can repeatedly try read() although there is nothing
> there, in which case, the seq_ops will be just
> start() and stop().

Ah, right, NULL case after end of iteration, got it.

>
> >
> >
> >> +               meta.seq = seq;
> >> +               ctx.meta = &meta;
> >> +               ctx.task = v;
> >> +               ret = bpf_iter_run_prog(prog, &ctx);
> >> +       }
> >> +
> >> +       return ret == 0 ? 0 : -EINVAL;
> >> +}
> >> +
> >> +static void task_seq_stop(struct seq_file *seq, void *v)
> >> +{
> >> +       struct bpf_iter_seq_task_info *info = seq->private;
> >> +
> >> +       if (!v)
> >> +               task_seq_show(seq, v);
> >
> > hmm... show() called from stop()? what's the case where this is necessary?
>
> I will refactor it better. This is to invoke bpf program
> in stop() with NULL object to signal the end of
> iteration.
>
> >> +
> >> +       if (info->task) {
> >> +               put_task_struct(info->task);
> >> +               info->task = NULL;
> >> +       }
> >> +}
> >> +
> >
> > [...]
> >
