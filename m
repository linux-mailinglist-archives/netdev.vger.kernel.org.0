Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC23B319951
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 05:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbhBLEsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 23:48:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhBLEr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 23:47:56 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93151C061574;
        Thu, 11 Feb 2021 20:47:16 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id t11so5450750pgu.8;
        Thu, 11 Feb 2021 20:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qdkQpYGmovlbLm9AjueiZQhJE1B/fzhKTm7VvpE05yU=;
        b=IWw8PdPLVOs42dU/36xHTH49SKCB/8a/J4SIMQ7yfWRHy+itvKyRi75luKceYVHpbe
         uaWiv94AqL5RVmKWuQV59fGlRt+6Lxq48RIpi3roRk364wIJTleE811ZG0294XYTo4SR
         BVDHySQWEXcugFC6i/enHaeRcrwBNPN8OKh5zMMVLmmDx0cspgbwtwjw89SB9ahfDeV3
         0Z/ns9s4hhGdL3oZOjTkp/nx661zKqpOSkwe8I1AeAaXRFg2meLzkAt8tjdaCNk0OLRW
         ghKHwbAeFw7Mb1WIetLv1CcrSSVJLHYuuMHceaoAgn0u1GMcPjuyTJiVL/Vdzs53jv6u
         vAzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qdkQpYGmovlbLm9AjueiZQhJE1B/fzhKTm7VvpE05yU=;
        b=h3Far7I3L025u6sivxlYM6BhPqD12CSkgstINU51W9w2OlNgfl0S5HUnyY2wtCEWcc
         gcrMQAyo1TG2yB2wOLsNxoF6J9PBnn4J9496upHhWwAbOOhSg7YmfBhKjGvtAmOAxd67
         3ZNT6Mip8R5a1LV61ev5uPyuSx5wvbmwBD4YdPTlyIBYoZEedbXWcyGoWTcNPeDOO5Kp
         4eqGkUic3tmDtj6IOE6+d0Dsok/Z1GYkEUMD9qCqez4AbiE4+I8TFHL4nvgaoqK7uH/R
         j9hPe17uwM6i8ETjVkgWGyXDWXTnnInlW7m898oOhdiY6l1fm5qNY8mzPAeuiQ6mx7+F
         bOLg==
X-Gm-Message-State: AOAM532PGIImPsbUEpC6IEDfTNTu4xivL98JsG78QOJ2N5vbmJwQ/mJd
        RBgsCgSPlqppG025GqNLU/s=
X-Google-Smtp-Source: ABdhPJxKpx0BNz43kB6jP006to5mkzB0qD8G6ZTLjuDUPdTSv1dA8UfUvkPAZnHb0TXBS1x09QQlcA==
X-Received: by 2002:a62:e804:0:b029:1dd:cf18:bdee with SMTP id c4-20020a62e8040000b02901ddcf18bdeemr1444005pfi.63.1613105236077;
        Thu, 11 Feb 2021 20:47:16 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:31f0])
        by smtp.gmail.com with ESMTPSA id y20sm7148856pfo.210.2021.02.11.20.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 20:47:15 -0800 (PST)
Date:   Thu, 11 Feb 2021 20:47:13 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, linux-mm@kvack.org,
        ast@kernel.org, daniel@iogearbox.net, kernel-team@fb.com,
        akpm@linux-foundation.org, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v6 bpf-next 1/4] bpf: introduce task_vma bpf_iter
Message-ID: <20210212044713.ptgvtsnh22vp5axg@ast-mbp.dhcp.thefacebook.com>
References: <20210212014232.414643-1-songliubraving@fb.com>
 <20210212014232.414643-2-songliubraving@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212014232.414643-2-songliubraving@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 05:42:29PM -0800, Song Liu wrote:
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

That part doesn't match patch 2.
If it needs to call sleepable prog it should call it differently,
since bpf_iter_run_prog() is doing rcu_read_lock().
Try adding the following:
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 845b2168e006..06f65b18bc54 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1159,6 +1159,8 @@ BPF_CALL_3(bpf_d_path, struct path *, path, char *, buf, u32, sz)
        long len;
        char *p;

+       might_sleep();
and you will see a splat from patch 4's task_vma test.

But this might_sleep above is not correct. d_path is not about sleepability.
It does its locking under rcu_read_lock.
The bpf_d_path_allowed is confusing, since it checks for lsm sleepable hooks,
but it's not about sleeping. Those hooks are safe because they don't hold
any vfs locks. With bpf iterators the situation is the same.
They all are called from bpf_seq_read. Which runs in user context and
there are no vfs locks to worry about.
So it's safe to enable all iterators to access bpf_d_path. No need
to introduce sleepable iterators.
The upcoming bpf_for_each_map_elem is kinda an iterator too where
map elem callback shouldn't be able to call bpf_d_path, but
it won't have expected_attach_type == BPF_TRACE_ITER, so
bpf_for_each_map_elem will be fine the way last patches were done.
So just drop 'prog->aux->sleepable' from patch 2 and delete patch 3.
