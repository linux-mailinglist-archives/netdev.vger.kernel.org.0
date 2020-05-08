Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59CC41CB861
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 21:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726891AbgEHTgS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 15:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHTgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 15:36:17 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E2BC061A0C;
        Fri,  8 May 2020 12:36:16 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id s186so1061147qkd.4;
        Fri, 08 May 2020 12:36:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ljLmDQJs3tJDtTeKPcwgxb/GDu+OQ91OWH4WN/dCD+o=;
        b=KR0rf8v7k9JEX3E7oXqpOFDR/9ruvvcP9xg9KqKXGvm9be1RlSB85Z4weoCSvSbtuu
         YYDUPttxpZKe6qpL1y9hcsIY41PmSmL2nLp3nBHYBnMb1M3PI3tGEGmAr0N0Gjm1+Ggi
         k5vp8p7Fam6lYQTgPcCbR1+XjtRROHi/rNbhNKcCoJowNiycgclySD828c+qd0dYOhEV
         b3wa7R6TrS+hO3Aw7VJYHiTauS3TyFBD++HCJS5O92tpGtuPX2fn6lLSZT8e9zcldsNM
         bKD+AFSSLTjjZTt9+SLorkZLoSQiwaAO1q5Fave9UoOMGAvNrjqplHmfAEDaNSxJ5Ylm
         IEtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ljLmDQJs3tJDtTeKPcwgxb/GDu+OQ91OWH4WN/dCD+o=;
        b=RwA7W1L4PTnETVw/pesh+LJOBrrgGnq3oXZtabpS2Gyb/lAfnTWkXXi2JWTSlkX84N
         OijUpKHZZ7VaRs393iy4e52MyI1TQatY5f+VZG3H6wCUudj63LTd9WPTBo2ytqV9WlBb
         A1eUaZSEURFBSlHULatc4aaHroML9Fk5YQBXPv6HNQC1uRXRVtYfiSnOV5g3dQYem2ZN
         dUM07oSV6PE7w0uRj7+elYJxPoKIRetVD2hi6C0jrw5VfpfHvZxMZZNoO/QS+FQcmSGF
         5inn8AhLQStC9keqlBfaVefIF9UsSZ5fGG2gH3RtDdmXsf/Wn/ngDPaQOjb+E6qmhJru
         9l9w==
X-Gm-Message-State: AGi0PuaPtyuLAwlilFVqK3L6NNGME/PtOO9rHC0TUFt7MGzungxXf63f
        v4uREBAhsGmH0APLzcM0CoAHr15WkeUUpqzOFFw4VIRcN98=
X-Google-Smtp-Source: APiQypLwChiC1ohmTSjpTx+jHdlfw107k3ooUru0D9mHKfucKqY/b1e4EplK6wrSIk2iM6myvhV8DhbqnpdN9EagbUo=
X-Received: by 2002:a05:620a:2049:: with SMTP id d9mr4784582qka.449.1588966575981;
 Fri, 08 May 2020 12:36:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200507053915.1542140-1-yhs@fb.com> <20200507053927.1543615-1-yhs@fb.com>
In-Reply-To: <20200507053927.1543615-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 12:36:04 -0700
Message-ID: <CAEf4BzZd_DiCThN_6boqtkJ15d2ms+88B+Uxm45zbc1=_7Mjqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 11/21] bpf: add task and task/file iterator targets
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

On Wed, May 6, 2020 at 10:40 PM Yonghong Song <yhs@fb.com> wrote:
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
>  kernel/bpf/task_iter.c | 332 +++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 333 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/task_iter.c
>

Looks good, though I'd just use bpf_iter_seq_task_file_info directly,
given it is a state of iterator by design. Probably would simplify
code a bit as well. But either way I can't find any bug in the code,
so:

Acked-by: Andrii Nakryiko <andriin@fb.com>


[...]

> +
> +struct bpf_iter_seq_task_common {
> +       struct pid_namespace *ns;
> +};
> +
> +struct bpf_iter_seq_task_info {
> +       /* The first field must be struct bpf_iter_seq_task_common.
> +        * this is assumed by {init, fini}_seq_pidns() callback functions.
> +        */

Awesome, thanks!

> +       struct bpf_iter_seq_task_common common;
> +       u32 tid;
> +};
> +

[...]

> +
> +static void *task_seq_next(struct seq_file *seq, void *v, loff_t *pos)

nit: v is very non-descriptive name, prev_task?

> +{
> +       struct bpf_iter_seq_task_info *info = seq->private;
> +       struct task_struct *task;
> +
> +       ++*pos;
> +       ++info->tid;
> +       put_task_struct((struct task_struct *)v);
> +       task = task_seq_get_next(info->common.ns, &info->tid);
> +       if (!task)
> +               return NULL;
> +
> +       return task;
> +}
> +
> +struct bpf_iter__task {
> +       __bpf_md_ptr(struct bpf_iter_meta *, meta);
> +       __bpf_md_ptr(struct task_struct *, task);
> +};
> +
> +DEFINE_BPF_ITER_FUNC(task, struct bpf_iter_meta *meta, struct task_struct *task)
> +
> +static int __task_seq_show(struct seq_file *seq, void *v, bool in_stop)

same nit: v -> task? Can also specify `struct task_struct *` type,
same for above.

[...]

> +
> +struct bpf_iter_seq_task_file_info {
> +       /* The first field must be struct bpf_iter_seq_task_common.
> +        * this is assumed by {init, fini}_seq_pidns() callback functions.
> +        */
> +       struct bpf_iter_seq_task_common common;
> +       struct task_struct *task;
> +       struct files_struct *files;
> +       u32 tid;
> +       u32 fd;
> +};
> +
> +static struct file *task_file_seq_get_next(struct pid_namespace *ns, u32 *tid,
> +                                          int *fd, struct task_struct **task,
> +                                          struct files_struct **fstruct)

Why not just passing struct bpf_iter_seq_task_file_info* directly,
instead of these 5 individual pointers?

> +{
> +       struct files_struct *curr_files;
> +       struct task_struct *curr_task;
> +       u32 curr_tid = *tid, max_fds;
> +       int curr_fd = *fd;
> +
> +       /* If this function returns a non-NULL file object,
> +        * it held a reference to the task/files_struct/file.
> +        * Otherwise, it does not hold any reference.
> +        */

[...]
