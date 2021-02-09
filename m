Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88CD3159C8
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234643AbhBIW6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:58:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbhBIWdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 17:33:43 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BE6C0698CC;
        Tue,  9 Feb 2021 13:30:34 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id d26so11501557pfn.5;
        Tue, 09 Feb 2021 13:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=r2epxJOwWQ7OTRzZ6i1rMgc7T6GcVx34zs5FRLJt7HQ=;
        b=vhWCdcYJR9oUeHfdlZvegm5eHrPDufrpv0DKf1H7WRRLaskwVVCLxzLiAAmm2lE1Q+
         F8A+Mx5P9v0VgZ/MvMNZm84bQtxskLY53hH8mXiUeUylc/zBPEnQ+UWCS/bH+CfX/lKe
         Ca8LwKHhQyTGwSeORKmH+t62z6SFmToGGpTJ/HdJxKQKwm0qwVI+btfrDRW209j/ryt7
         6OAsPagECqiG39IvCuKRrCz4+rzLwnYechySC+3xNQyJJjxjSqiB0CpbMOmvHFIrRoyZ
         789OeBUcVambntsPbJDLwXfluoCmtAVmXz3n6Gw3wI7Pcx5qgOQc7UlLthFHxP0uXeR2
         Aulw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r2epxJOwWQ7OTRzZ6i1rMgc7T6GcVx34zs5FRLJt7HQ=;
        b=IaaM+S2bo20Og2eLw/8qT7gxaiZKwuUDy8FXelGFiKrkFkGdmRsgVqEHC14/3Bzrd9
         fMIqsANOVhsS0dwsdOkdCS8d4TWtt0QZDwHBg5qTHL1rjHUQGERkoNvfAuXhl8vh7tKZ
         g0h27/lfLAQa8Y3UACP248NbNBCuAWfABaWZc187eKtu2gbPH2nO3SMUZAnDieugNXvC
         IYpXFAb4nj1vf4oIi+V6SBcVJw0i5TlyYnVuNUlQa7RHgo9DflxYEBrm76IxhKHlQLuv
         A31uGwFhzUfanaNV6CK6ml6l8kNNoo4Ki8sVOE37P33auMJhJx0PqzQwjpIih/ljqzaX
         0OPw==
X-Gm-Message-State: AOAM530KXhJN2sC15mKCnNWLSmFJgSUpEmzCmdg+/CL6CPdmsIhirUAQ
        17L9PWK7OZyJJiE9JoFonME=
X-Google-Smtp-Source: ABdhPJx1yNSGCP3O9PElNc6OHlzjBYkY/lOvEnjoU/DJ1dizd3X0Jttcb070oKHBERDshf351Lo0fQ==
X-Received: by 2002:a62:33c3:0:b029:1e3:cf7f:f1a5 with SMTP id z186-20020a6233c30000b02901e3cf7ff1a5mr3257220pfz.39.1612906234258;
        Tue, 09 Feb 2021 13:30:34 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:c01f])
        by smtp.gmail.com with ESMTPSA id 30sm23858075pgl.77.2021.02.09.13.30.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 13:30:33 -0800 (PST)
Date:   Tue, 9 Feb 2021 13:30:31 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        ast@kernel.org, daniel@iogearbox.net, kernel-team@fb.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH v5 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20210209213031.v4wzzka7nth7xzq5@ast-mbp.dhcp.thefacebook.com>
References: <20210208225255.3089073-1-songliubraving@fb.com>
 <20210208225255.3089073-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208225255.3089073-2-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 08, 2021 at 02:52:52PM -0800, Song Liu wrote:
> Introduce task_vma bpf_iter to print memory information of a process. It
> can be used to print customized information similar to /proc/<pid>/maps.
> 
> Current /proc/<pid>/maps and /proc/<pid>/smaps provide information of
> vma's of a process. However, these information are not flexible enough to
> cover all use cases. For example, if a vma cover mixed 2MB pages and 4kB
> pages (x86_64), there is no easy way to tell which address ranges are
> backed by 2MB pages. task_vma solves the problem by enabling the user to
> generate customize information based on the vma (and vma->vm_mm,
> vma->vm_file, etc.).
> 
> To access the vma safely in the BPF program, task_vma iterator holds
> target mmap_lock while calling the BPF program. If the mmap_lock is
> contended, task_vma unlocks mmap_lock between iterations to unblock the
> writer(s). This lock contention avoidance mechanism is similar to the one
> used in show_smaps_rollup().
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  kernel/bpf/task_iter.c | 217 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 216 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/bpf/task_iter.c b/kernel/bpf/task_iter.c
> index 175b7b42bfc46..a0d469f0f481c 100644
> --- a/kernel/bpf/task_iter.c
> +++ b/kernel/bpf/task_iter.c
> @@ -286,9 +286,198 @@ static const struct seq_operations task_file_seq_ops = {
>  	.show	= task_file_seq_show,
>  };
>  
> +struct bpf_iter_seq_task_vma_info {
> +	/* The first field must be struct bpf_iter_seq_task_common.
> +	 * this is assumed by {init, fini}_seq_pidns() callback functions.
> +	 */
> +	struct bpf_iter_seq_task_common common;
> +	struct task_struct *task;
> +	struct vm_area_struct *vma;
> +	u32 tid;
> +	unsigned long prev_vm_start;
> +	unsigned long prev_vm_end;
> +};
> +
> +enum bpf_task_vma_iter_find_op {
> +	task_vma_iter_first_vma,   /* use mm->mmap */
> +	task_vma_iter_next_vma,    /* use curr_vma->vm_next */
> +	task_vma_iter_find_vma,    /* use find_vma() to find next vma */
> +};
> +
> +static struct vm_area_struct *
> +task_vma_seq_get_next(struct bpf_iter_seq_task_vma_info *info)
> +{
> +	struct pid_namespace *ns = info->common.ns;
> +	enum bpf_task_vma_iter_find_op op;
> +	struct vm_area_struct *curr_vma;
> +	struct task_struct *curr_task;
> +	u32 curr_tid = info->tid;
> +
> +	/* If this function returns a non-NULL vma, it holds a reference to
> +	 * the task_struct, and holds read lock on vma->mm->mmap_lock.
> +	 * If this function returns NULL, it does not hold any reference or
> +	 * lock.
> +	 */
> +	if (info->task) {
> +		curr_task = info->task;
> +		curr_vma = info->vma;
> +		/* In case of lock contention, drop mmap_lock to unblock
> +		 * the writer.
> +		 */
> +		if (mmap_lock_is_contended(curr_task->mm)) {
> +			info->prev_vm_start = curr_vma->vm_start;
> +			info->prev_vm_end = curr_vma->vm_end;
> +			op = task_vma_iter_find_vma;
> +			mmap_read_unlock(curr_task->mm);
> +			if (mmap_read_lock_killable(curr_task->mm))
> +				goto finish;

in case of contention the vma will be seen by bpf prog again?
It looks like the 4 cases of overlaping vmas (after newly acquired lock)
that show_smaps_rollup() is dealing with are not handled here?

> +		} else {
> +			op = task_vma_iter_next_vma;
> +		}
> +	} else {
> +again:
> +		curr_task = task_seq_get_next(ns, &curr_tid, true);
> +		if (!curr_task) {
> +			info->tid = curr_tid + 1;
> +			goto finish;
> +		}
> +
> +		if (curr_tid != info->tid) {
> +			info->tid = curr_tid;
> +			op = task_vma_iter_first_vma;
> +		} else {
> +			op = task_vma_iter_find_vma;

what will happen if there was no contetion on the lock and no seq_stop
when this line was hit and set op = find_vma; ?
If I'm reading this correctly prev_vm_start/end could still
belong to some previous task.
My understanding that if read buffer is big the bpf_seq_read()
will keep doing while(space in buffer) {seq->op->show(), seq->op->next();}
and task_vma_seq_get_next() will iterate over all vmas of one task and
will proceed into the next task, but if there was no contention and no stop
then prev_vm_end will either be still zero (so find_vma(mm, 0 - 1) will be lucky
and will go into first vma of the new task) or perf_vm_end is some address
of some previous task's vma. In this case find_vma may return wrong vma
for the new task.
It seems to me prev_vm_end/start should be set by this task_vma_seq_get_next()
function instead of relying on stop callback.

> +		}
> +
> +		if (!curr_task->mm)
> +			goto next_task;
> +
> +		if (mmap_read_lock_killable(curr_task->mm))
> +			goto finish;
> +	}
> +
> +	switch (op) {
> +	case task_vma_iter_first_vma:
> +		curr_vma = curr_task->mm->mmap;
> +		break;
> +	case task_vma_iter_next_vma:
> +		curr_vma = curr_vma->vm_next;
> +		break;
> +	case task_vma_iter_find_vma:
> +		/* We dropped mmap_lock so it is necessary to use find_vma
> +		 * to find the next vma. This is similar to the  mechanism
> +		 * in show_smaps_rollup().
> +		 */
> +		curr_vma = find_vma(curr_task->mm, info->prev_vm_end - 1);
> +
> +		if (curr_vma && (curr_vma->vm_start == info->prev_vm_start))
> +			curr_vma = curr_vma->vm_next;
> +		break;
> +	}
> +	if (!curr_vma) {
> +		mmap_read_unlock(curr_task->mm);
> +		goto next_task;
> +	}
> +	info->task = curr_task;
> +	info->vma = curr_vma;
> +	return curr_vma;
> +
> +next_task:
> +	put_task_struct(curr_task);
> +	info->task = NULL;
> +	curr_tid++;
> +	goto again;
> +
> +finish:
> +	if (curr_task)
> +		put_task_struct(curr_task);
> +	info->task = NULL;
> +	info->vma = NULL;
> +	return NULL;
> +}
> +
> +static void *task_vma_seq_start(struct seq_file *seq, loff_t *pos)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +	struct vm_area_struct *vma;
> +
> +	vma = task_vma_seq_get_next(info);
> +	if (vma && *pos == 0)
> +		++*pos;
> +
> +	return vma;
> +}
> +
> +static void *task_vma_seq_next(struct seq_file *seq, void *v, loff_t *pos)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +
> +	++*pos;
> +	return task_vma_seq_get_next(info);
> +}
> +
> +struct bpf_iter__task_vma {
> +	__bpf_md_ptr(struct bpf_iter_meta *, meta);
> +	__bpf_md_ptr(struct task_struct *, task);
> +	__bpf_md_ptr(struct vm_area_struct *, vma);
> +};
> +
> +DEFINE_BPF_ITER_FUNC(task_vma, struct bpf_iter_meta *meta,
> +		     struct task_struct *task, struct vm_area_struct *vma)
> +
> +static int __task_vma_seq_show(struct seq_file *seq, bool in_stop)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +	struct bpf_iter__task_vma ctx;
> +	struct bpf_iter_meta meta;
> +	struct bpf_prog *prog;
> +
> +	meta.seq = seq;
> +	prog = bpf_iter_get_info(&meta, in_stop);
> +	if (!prog)
> +		return 0;
> +
> +	ctx.meta = &meta;
> +	ctx.task = info->task;
> +	ctx.vma = info->vma;
> +	return bpf_iter_run_prog(prog, &ctx);
> +}
> +
> +static int task_vma_seq_show(struct seq_file *seq, void *v)
> +{
> +	return __task_vma_seq_show(seq, false);
> +}
> +
> +static void task_vma_seq_stop(struct seq_file *seq, void *v)
> +{
> +	struct bpf_iter_seq_task_vma_info *info = seq->private;
> +
> +	if (!v) {
> +		(void)__task_vma_seq_show(seq, true);
> +	} else {
> +		/* Set prev_vm_start to ~0UL, so that we don't skip the
> +		 * vma returned by the next find_vma(). Please refer to
> +		 * case task_vma_iter_find_vma in task_vma_seq_get_next().
> +		 */
> +		info->prev_vm_start = ~0UL;
> +		info->prev_vm_end = info->vma->vm_end;
> +		mmap_read_unlock(info->task->mm);
> +		put_task_struct(info->task);
> +		info->task = NULL;
> +	}
> +}
> +
> +static const struct seq_operations task_vma_seq_ops = {
> +	.start	= task_vma_seq_start,
> +	.next	= task_vma_seq_next,
> +	.stop	= task_vma_seq_stop,
> +	.show	= task_vma_seq_show,
> +};
> +
>  BTF_ID_LIST(btf_task_file_ids)
>  BTF_ID(struct, task_struct)
>  BTF_ID(struct, file)
> +BTF_ID(struct, vm_area_struct)
>  
>  static const struct bpf_iter_seq_info task_seq_info = {
>  	.seq_ops		= &task_seq_ops,
> @@ -328,6 +517,26 @@ static struct bpf_iter_reg task_file_reg_info = {
>  	.seq_info		= &task_file_seq_info,
>  };
>  
> +static const struct bpf_iter_seq_info task_vma_seq_info = {
> +	.seq_ops		= &task_vma_seq_ops,
> +	.init_seq_private	= init_seq_pidns,
> +	.fini_seq_private	= fini_seq_pidns,
> +	.seq_priv_size		= sizeof(struct bpf_iter_seq_task_vma_info),
> +};
> +
> +static struct bpf_iter_reg task_vma_reg_info = {
> +	.target			= "task_vma",
> +	.feature		= BPF_ITER_RESCHED,
> +	.ctx_arg_info_size	= 2,
> +	.ctx_arg_info		= {
> +		{ offsetof(struct bpf_iter__task_vma, task),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +		{ offsetof(struct bpf_iter__task_vma, vma),
> +		  PTR_TO_BTF_ID_OR_NULL },
> +	},
> +	.seq_info		= &task_vma_seq_info,
> +};
> +
>  static int __init task_iter_init(void)
>  {
>  	int ret;
> @@ -339,6 +548,12 @@ static int __init task_iter_init(void)
>  
>  	task_file_reg_info.ctx_arg_info[0].btf_id = btf_task_file_ids[0];
>  	task_file_reg_info.ctx_arg_info[1].btf_id = btf_task_file_ids[1];
> -	return bpf_iter_reg_target(&task_file_reg_info);
> +	ret =  bpf_iter_reg_target(&task_file_reg_info);
> +	if (ret)
> +		return ret;
> +
> +	task_vma_reg_info.ctx_arg_info[0].btf_id = btf_task_file_ids[0];
> +	task_vma_reg_info.ctx_arg_info[1].btf_id = btf_task_file_ids[2];
> +	return bpf_iter_reg_target(&task_vma_reg_info);
>  }
>  late_initcall(task_iter_init);
> -- 
> 2.24.1
> 

-- 
