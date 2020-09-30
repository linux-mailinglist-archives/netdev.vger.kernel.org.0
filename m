Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D1C27DD2F
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 02:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729525AbgI3AAN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 20:00:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728192AbgI3AAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 20:00:12 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DB19C061755;
        Tue, 29 Sep 2020 17:00:11 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w7so6463657pfi.4;
        Tue, 29 Sep 2020 17:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0Pjd53fD2sBc+fXIGlMYU+kpxJEKruFYLrsekrSB8mg=;
        b=D9uYHkxft0fGH7fMMD/yWKc/gn/G5zYOxivYKUSnQQUpm2oH314eje+pprFgShA5YT
         QZIBPzREy87bgJWbHo/o6VxNqOc9iCcaN+voJdNUj4XMUAsKT39yYgr0t4Vry5ilqf2+
         b/0HtF2djzdsZ222MxN6mGPt5Afx2jtTpn0jlPXFXMTbdvt0rg8dE+/wi/wDrPthBKvD
         pyYxy8PqONvLuiOWAI4r6f0Xx3i8SB7wV7hTeJP9lfmGrqownSMzctA9pLk7LxZB6JAl
         lRxI6mcHcq9Zkndaka5966zXTxDBS7+OSOZ71uL6qnzpdoh/lcsTP0wx3ho8AXTE79FK
         ImSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0Pjd53fD2sBc+fXIGlMYU+kpxJEKruFYLrsekrSB8mg=;
        b=EAtQDAm2HUC0tGEmi/cMQE7cQgDnKITvO5RjJw99yxs5192T3m17mCnf6PZNlMoDfj
         4AV2WWgu79+2++Mup8jIQplqgVvlKsl+YCzgaU1m1J03oBNHl3cDJCa3HZgoawC7E8kw
         eMJgaoesbkj3GBDDVlANR7hQhbsKS1BJZJ6B9LeajSfJFym+OKwPgb5pDE+Zb5aTnZRo
         +xaGdkGnGw5OSVPlX1MXvl6C56aO3miqNz4y4jFowLFhyS01eWVtRUhGvab22NVhkyXc
         C1/sVZMkfgQCsb+OmCRvPhw4SBJ0/bb15Egwmxjo1WyOGvhc+pkREjZ7wu/iRg37dTzh
         J47g==
X-Gm-Message-State: AOAM531R3N1dhiyerZDqW5QEbDR66bx9j5yZcg3kW1bIkuzympOw8oun
        lkutzt49HvbapbTYO04aSMU=
X-Google-Smtp-Source: ABdhPJwYCHSXD4ZlwqUov1uBMXaTtndsgo6zJRq/8CJAFWe4fph+aW02zONt8LaxqGzkoJ8wTnm3ug==
X-Received: by 2002:a62:5a04:0:b029:142:2501:397f with SMTP id o4-20020a625a040000b02901422501397fmr121880pfb.68.1601424010777;
        Tue, 29 Sep 2020 17:00:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d27])
        by smtp.gmail.com with ESMTPSA id gj6sm28852pjb.10.2020.09.29.17.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Sep 2020 17:00:09 -0700 (PDT)
Date:   Tue, 29 Sep 2020 17:00:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com,
        ast@kernel.org, daniel@iogearbox.net, john.fastabend@gmail.com,
        kpsingh@chromium.org
Subject: Re: [PATCH bpf-next] bpf: fix raw_tp test run in preempt kernel
Message-ID: <20200930000007.dgtgbma7rfyeezjx@ast-mbp.dhcp.thefacebook.com>
References: <20200929225013.930-1-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929225013.930-1-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 03:50:13PM -0700, Song Liu wrote:
> In preempt kernel, BPF_PROG_TEST_RUN on raw_tp triggers:
> 
> [   35.874974] BUG: using smp_processor_id() in preemptible [00000000]
> code: new_name/87
> [   35.893983] caller is bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.900124] CPU: 1 PID: 87 Comm: new_name Not tainted 5.9.0-rc6-g615bd02bf #1
> [   35.907358] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
> BIOS 1.10.2-1ubuntu1 04/01/2014
> [   35.916941] Call Trace:
> [   35.919660]  dump_stack+0x77/0x9b
> [   35.923273]  check_preemption_disabled+0xb4/0xc0
> [   35.928376]  bpf_prog_test_run_raw_tp+0xd4/0x1b0
> [   35.933872]  ? selinux_bpf+0xd/0x70
> [   35.937532]  __do_sys_bpf+0x6bb/0x21e0
> [   35.941570]  ? find_held_lock+0x2d/0x90
> [   35.945687]  ? vfs_write+0x150/0x220
> [   35.949586]  do_syscall_64+0x2d/0x40
> [   35.953443]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> 
> Fix this by calling migrate_disable() before smp_processor_id().
> 
> Fixes: 1b4d60ec162f ("bpf: Enable BPF_PROG_TEST_RUN for raw_tracepoint")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---
>  net/bpf/test_run.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
> index fde5db93507c4..3ea05a5daf544 100644
> --- a/net/bpf/test_run.c
> +++ b/net/bpf/test_run.c
> @@ -251,11 +251,7 @@ __bpf_prog_test_run_raw_tp(void *data)
>  {
>  	struct bpf_raw_tp_test_run_info *info = data;
>  
> -	rcu_read_lock();
> -	migrate_disable();
>  	info->retval = BPF_PROG_RUN(info->prog, info->ctx);
> -	migrate_enable();
> -	rcu_read_unlock();

I would keep rcu_read_lock here, since there is no need to expand its scope.

>  }
>  
>  int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
> @@ -293,27 +289,27 @@ int bpf_prog_test_run_raw_tp(struct bpf_prog *prog,
>  
>  	info.prog = prog;
>  
> +	rcu_read_lock();
> +	migrate_disable();
>  	if ((kattr->test.flags & BPF_F_TEST_RUN_ON_CPU) == 0 ||
>  	    cpu == smp_processor_id()) {

may be use get_cpu/put_cpu instead?

>  		__bpf_prog_test_run_raw_tp(&info);
> -	} else {
> +	} else if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
>  		/* smp_call_function_single() also checks cpu_online()
>  		 * after csd_lock(). However, since cpu is from user
>  		 * space, let's do an extra quick check to filter out
>  		 * invalid value before smp_call_function_single().
>  		 */
> -		if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
>  		err = -ENXIO;
> -			goto out;
> -		}
> -
> +	} else {
>  		err = smp_call_function_single(cpu, __bpf_prog_test_run_raw_tp,
>  					       &info, 1);
> -		if (err)
> -			goto out;
>  	}
> +	migrate_enable();
> +	rcu_read_unlock();
>  
> -	if (copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32)))
> +	if (err == 0 &&

!err would be canonical.

> +	    copy_to_user(&uattr->test.retval, &info.retval, sizeof(u32)))
>  		err = -EFAULT;
>  
>  out:
> -- 
> 2.24.1
> 
