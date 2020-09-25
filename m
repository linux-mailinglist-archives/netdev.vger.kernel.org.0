Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE6B9277D9B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 03:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgIYB0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 21:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgIYB0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 21:26:17 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0526BC0613CE;
        Thu, 24 Sep 2020 18:26:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id z19so1550943pfn.8;
        Thu, 24 Sep 2020 18:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x5Vfp86at7uSTzsn8OXcDo/PlyY6mKf/IwNIrR1tICg=;
        b=APJI8m/zFyl90UdUFN0JQYF+FbO8j0ur+5oQ896vmRBo/aB8P06AckBkr9pwQvpfzq
         a00bdF2At0Iruaqh+NnI5L5QFuAmhT2hka0LAXuBt7kTdPMh6ZacbSJNUasBPA8iuhgL
         4VhG7cfZ9YChjMdw2oXrqBOibshHqGS4Mun74akqbWA9OxfTDkrerdeLbkNcetaC/eOO
         WfiO+CYMFwBh88JlAoz+OQ24fE/u+PxpaSGDRBbwziTNSI3aNLhaLXfvIOPNBoc4IcSP
         Nj9rI24yE3Igw783lcpY1+jPJi93rRdhqXPRM19suxd5QtdveExUHAmPOx2qkBn6D4WE
         BHUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x5Vfp86at7uSTzsn8OXcDo/PlyY6mKf/IwNIrR1tICg=;
        b=hcyLUxrDl1WM12ApGKmzLgxiLTzfaR09+dEJhnTKQCKPFrxbrAg1A5ERSxRc/jffek
         anh4IZFYFGOFXUhLGKZyxGPD/uTOVw2koW7tDdeVFQuUSUHc+PbVrTHMeaacY/sPWcO0
         CHIzfqaWiIrunQk2pMZuf0ofGezW523nKFHVtQ2KdtUHkIG4wWhh6qEPri1K8tssFdac
         usKApFZgKcw3gqlqhUge5kdJHiqHpyL6ETUnaPUQwQReSc0BA2IhJlzahVVzUQf+mgkx
         wW0vhAkTzgfMMSoQijeJY2yU3c5GeohlC8pxORvv41okkkci4+RKxCoJd6GhM20LJXIZ
         enZw==
X-Gm-Message-State: AOAM533Y69casyIoaKRASQ3EtiNei9x3G8NaqmkYsAepjfaSEPxH+eh6
        J1FDb++ljYlxG3h+h2jNuLU=
X-Google-Smtp-Source: ABdhPJwB/OJNGGa1SViPqm0+0eE6iBMN8GMAlJbswhOBHJ6OvM3WUKnuAVPQuhxxGDrl35G7S41hiQ==
X-Received: by 2002:a17:902:bd4a:b029:d2:2767:dabb with SMTP id b10-20020a170902bd4ab02900d22767dabbmr1809804plx.64.1600997176359;
        Thu, 24 Sep 2020 18:26:16 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:49ed])
        by smtp.gmail.com with ESMTPSA id 137sm646524pfb.183.2020.09.24.18.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 18:26:15 -0700 (PDT)
Date:   Thu, 24 Sep 2020 18:26:11 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andriin@fb.com, yhs@fb.com,
        linux@rasmusvillemoes.dk, andriy.shevchenko@linux.intel.com,
        pmladek@suse.com, kafai@fb.com, songliubraving@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org, shuah@kernel.org,
        rdna@fb.com, scott.branden@broadcom.com, quentin@isovalent.com,
        cneirabustos@gmail.com, jakub@cloudflare.com, mingo@redhat.com,
        rostedt@goodmis.org, bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        acme@kernel.org
Subject: Re: [PATCH v6 bpf-next 6/6] selftests/bpf: add test for
 bpf_seq_printf_btf helper
Message-ID: <20200925012611.jebtlvcttusk3hbx@ast-mbp.dhcp.thefacebook.com>
References: <1600883188-4831-1-git-send-email-alan.maguire@oracle.com>
 <1600883188-4831-7-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1600883188-4831-7-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 06:46:28PM +0100, Alan Maguire wrote:
> Add a test verifying iterating over tasks and displaying BTF
> representation of data succeeds.  Note here that we do not display
> the task_struct itself, as it will overflow the PAGE_SIZE limit on seq
> data; instead we write task->fs (a struct fs_struct).

Yeah. I've tried to print task_struct before reading above comment and
it took me long time to figure out what 'read failed: Argument list too long' means.
How can we improve usability of this helper?

We can bump:
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -88,8 +88,8 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
        mutex_lock(&seq->lock);

        if (!seq->buf) {
-               seq->size = PAGE_SIZE;
+               seq->size = PAGE_SIZE * 32;

to whatever number, but printing single task_struct needs ~800 lines and
~18kbytes. Humans can scroll through that much spam, but can we make it less
verbose by default somehow?
May be not in this patch set, but in the follow up?

> +SEC("iter/task")
> +int dump_task_fs_struct(struct bpf_iter__task *ctx)
> +{
> +	static const char fs_type[] = "struct fs_struct";
> +	struct seq_file *seq = ctx->meta->seq;
> +	struct task_struct *task = ctx->task;
> +	struct fs_struct *fs = (void *)0;
> +	static struct btf_ptr ptr = { };
> +	long ret;
> +
> +	if (task)
> +		fs = task->fs;
> +
> +	ptr.type = fs_type;
> +	ptr.ptr = fs;

imo the following is better:
       ptr.type_id = __builtin_btf_type_id(*fs, 1);
       ptr.ptr = fs;

> +
> +	if (ctx->meta->seq_num == 0)
> +		BPF_SEQ_PRINTF(seq, "Raw BTF fs_struct per task\n");
> +
> +	ret = bpf_seq_printf_btf(seq, &ptr, sizeof(ptr), 0);
> +	switch (ret) {
> +	case 0:
> +		tasks++;
> +		break;
> +	case -ERANGE:
> +		/* NULL task or task->fs, don't count it as an error. */
> +		break;
> +	default:
> +		seq_err = ret;
> +		break;
> +	}

Please add handling of E2BIG to this switch. Otherwise
printing large amount of tiny structs will overflow PAGE_SIZE and E2BIG
will be send to user space.
Like this:
@@ -40,6 +40,8 @@ int dump_task_fs_struct(struct bpf_iter__task *ctx)
        case -ERANGE:
                /* NULL task or task->fs, don't count it as an error. */
                break;
+       case -E2BIG:
+               return 1;

Also please change bpf_seq_read() like this:
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 30833bbf3019..8f10e30ea0b0 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -88,8 +88,8 @@ static ssize_t bpf_seq_read(struct file *file, char __user *buf, size_t size,
        mutex_lock(&seq->lock);

        if (!seq->buf) {
-               seq->size = PAGE_SIZE;
-               seq->buf = kmalloc(seq->size, GFP_KERNEL);
+               seq->size = PAGE_SIZE << 3;
+               seq->buf = kvmalloc(seq->size, GFP_KERNEL);

So users can print task_struct by default.
Hopefully we will figure out how to deal with spam later.
