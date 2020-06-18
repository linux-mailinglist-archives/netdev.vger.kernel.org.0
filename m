Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F5101FDA28
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 02:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgFRAYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 20:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726815AbgFRAYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 20:24:38 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2004C061755
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:24:36 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id y78so1264935wmc.0
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 17:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BsBMwDY/wzj5JPc+RIAfnRHAwTAtQyxAjeIvX5uizJ0=;
        b=P6uDJxqWGlg92IwZHwlieJ9FbQ5JlnXdHcOWiTnuCzAVpgiAhtF+eCJ83GL1DG2obO
         NaXdJi4EiLg1QiRfi7W1X5t1mj3YLs+wpN+yytFn+OaP3xOy5YpyzRXZzxHxNkUz23Jy
         MohJe52L51GA+hTal5jn8RBMRafaflVbWAZIAimBiWryk3WMgLG0rUOSC3+LGVJN9VjF
         B7ZhkttDiUURWh8Hvwc+It7uu3Lq365FRXxUJxsDI6yOvh9t8BsQW0EVgrpFhiUihEdy
         yFCjziPf+Rdq5LKVxqDsGCBw87ptCoXcd4k5qKGjTk2r0S6J4uvlIg7WlMv91nn+Jpij
         oyOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BsBMwDY/wzj5JPc+RIAfnRHAwTAtQyxAjeIvX5uizJ0=;
        b=DBo1J7mg038lyE31CcY35QtaG2Njhu6nGcIdMz5KfGxR1zd/X3kL/kL4dVMeCXfdAZ
         K+/FIgvCNWih1Hv6+6noOVlXpJVFvPzBHLIcGqQoWi6vlsxzIUENQzMDqsIyZGDgGJv/
         2/bPIVHrLBXNyhVoDj9EuFutNZxSh41QvmFPAidAIc8TmQts0V45nsKIyw2ixldJPz0p
         vBdCexacUQY0fIlDINlxHsSJ6KGQ3W/nEfZk7LGMBpc6+lgFvuV8Y82m7i43TGz4yjQO
         sbjJ5q1kXA58SKznh321U73wyFIVrznwPQxmsLcvFvSQ/L43fb/JIA07VVRzWqg5bGr/
         GVEQ==
X-Gm-Message-State: AOAM533rk1ouLokJtXIjZfHEn2jKxgaX11rtIXQZm+n44wdJ5K2lCdvR
        MAJHt5RW11MRSw9UzdJNCu+dEw==
X-Google-Smtp-Source: ABdhPJyUYDzuJtCFIV8o75ER72mVxjE0qpvAVW5OjFrX/SuWCtdhKtYa7UPopskRnndJKg83PUcRnw==
X-Received: by 2002:a1c:a304:: with SMTP id m4mr1275848wme.49.1592439875341;
        Wed, 17 Jun 2020 17:24:35 -0700 (PDT)
Received: from [192.168.1.10] ([194.53.184.244])
        by smtp.gmail.com with ESMTPSA id e12sm1357260wro.52.2020.06.17.17.24.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 17:24:34 -0700 (PDT)
Subject: Re: [PATCH bpf-next 8/9] tools/bpftool: show info for processes
 holding BPF map/prog/link/btf FDs
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Hao Luo <haoluo@google.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Song Liu <songliubraving@fb.com>
References: <20200617161832.1438371-1-andriin@fb.com>
 <20200617161832.1438371-9-andriin@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <eebb2cea-dc27-77c6-936e-06ac5272921a@isovalent.com>
Date:   Thu, 18 Jun 2020 01:24:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200617161832.1438371-9-andriin@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-06-17 09:18 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> Add bpf_iter-based way to find all the processes that hold open FDs against
> BPF object (map, prog, link, btf). bpftool always attempts to discover this,
> but will silently give up if kernel doesn't yet support bpf_iter BPF programs.
> Process name and PID are emitted for each process (task group).
> 
> Sample output for each of 4 BPF objects:
> 
> $ sudo ./bpftool prog show
> 2694: cgroup_device  tag 8c42dee26e8cd4c2  gpl
>         loaded_at 2020-06-16T15:34:32-0700  uid 0
>         xlated 648B  jited 409B  memlock 4096B
>         pids systemd(1)
> 2907: cgroup_skb  name egress  tag 9ad187367cf2b9e8  gpl
>         loaded_at 2020-06-16T18:06:54-0700  uid 0
>         xlated 48B  jited 59B  memlock 4096B  map_ids 2436
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 
> $ sudo ./bpftool map show
> 2436: array  name test_cgr.bss  flags 0x400
>         key 4B  value 8B  max_entries 1  memlock 8192B
>         btf_id 1202
>         pids test_progs(2238417), test_progs(2238445)
> 2445: array  name pid_iter.rodata  flags 0x480
>         key 4B  value 4B  max_entries 1  memlock 8192B
>         btf_id 1214  frozen
>         pids bpftool(2239612)
> 
> $ sudo ./bpftool link show
> 61: cgroup  prog 2908
>         cgroup_id 375301  attach_type egress
>         pids test_progs(2238417), test_progs(2238445)
> 62: cgroup  prog 2908
>         cgroup_id 375344  attach_type egress
>         pids test_progs(2238417), test_progs(2238445)
> 
> $ sudo ./bpftool btf show
> 1202: size 1527B  prog_ids 2908,2907  map_ids 2436
>         pids test_progs(2238417), test_progs(2238445)
> 1242: size 34684B
>         pids bpftool(2258892)
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

[...]

> diff --git a/tools/bpf/bpftool/pids.c b/tools/bpf/bpftool/pids.c
> new file mode 100644
> index 000000000000..3474a91743ff
> --- /dev/null
> +++ b/tools/bpf/bpftool/pids.c
> @@ -0,0 +1,229 @@

[...]

> +int build_obj_refs_table(struct obj_refs_table *table, enum bpf_obj_type type)
> +{
> +	char buf[4096];
> +	struct pid_iter_bpf *skel;
> +	struct pid_iter_entry *e;
> +	int err, ret, fd = -1, i;
> +	libbpf_print_fn_t default_print;
> +
> +	hash_init(table->table);
> +	set_max_rlimit();
> +
> +	skel = pid_iter_bpf__open();
> +	if (!skel) {
> +		p_err("failed to open PID iterator skeleton");
> +		return -1;
> +	}
> +
> +	skel->rodata->obj_type = type;
> +
> +	/* we don't want output polluted with libbpf errors if bpf_iter is not
> +	 * supported
> +	 */
> +	default_print = libbpf_set_print(libbpf_print_none);
> +	err = pid_iter_bpf__load(skel);
> +	libbpf_set_print(default_print);
> +	if (err) {
> +		/* too bad, kernel doesn't support BPF iterators yet */
> +		err = 0;
> +		goto out;
> +	}
> +	err = pid_iter_bpf__attach(skel);
> +	if (err) {
> +		/* if we loaded above successfully, attach has to succeed */
> +		p_err("failed to attach PID iterator: %d", err);

Nit: What about using strerror(err) for the error messages, here and
below? It's easier to read than an integer value.

> +		goto out;
> +	}
> +
> +	fd = bpf_iter_create(bpf_link__fd(skel->links.iter));
> +	if (fd < 0) {
> +		err = -errno;
> +		p_err("failed to create PID iterator session: %d", err);
> +		goto out;
> +	}
> +
> +	while (true) {
> +		ret = read(fd, buf, sizeof(buf));
> +		if (ret < 0) {
> +			err = -errno;
> +			p_err("failed to read PID iterator output: %d", err);
> +			goto out;
> +		}
> +		if (ret == 0)
> +			break;
> +		if (ret % sizeof(*e)) {
> +			err = -EINVAL;
> +			p_err("invalid PID iterator output format");
> +			goto out;
> +		}
> +		ret /= sizeof(*e);
> +
> +		e = (void *)buf;
> +		for (i = 0; i < ret; i++, e++) {
> +			add_ref(table, e);
> +		}
> +	}
> +	err = 0;
> +out:
> +	if (fd >= 0)
> +		close(fd);
> +	pid_iter_bpf__destroy(skel);
> +	return err;
> +}

[...]

> diff --git a/tools/bpf/bpftool/skeleton/pid_iter.bpf.c b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> new file mode 100644
> index 000000000000..f560e48add07
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/pid_iter.bpf.c
> @@ -0,0 +1,80 @@
> +// SPDX-License-Identifier: GPL-2.0

This would make it the only file not dual-licensed GPL/BSD in bpftool.
We've had issues with that before [0], although linking to libbfd is no
more a hard requirement. But I see you used a dual-license in the
corresponding header file pid_iter.h, so is the single license
intentional here? Or would you consider GPL/BSD?

[0] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=896165#38

> +// Copyright (c) 2020 Facebook
> +#include <vmlinux.h>
> +#include <bpf/bpf_helpers.h>
> +#include <bpf/bpf_core_read.h>
> +#include <bpf/bpf_tracing.h>
> +#include "pid_iter.h"

[...]

> +
> +char LICENSE[] SEC("license") = "GPL";
> diff --git a/tools/bpf/bpftool/skeleton/pid_iter.h b/tools/bpf/bpftool/skeleton/pid_iter.h
> new file mode 100644
> index 000000000000..5692cf257adb
> --- /dev/null
> +++ b/tools/bpf/bpftool/skeleton/pid_iter.h
> @@ -0,0 +1,12 @@
> +/* SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause) */

[...]

